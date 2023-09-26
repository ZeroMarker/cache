Import SQLUser

Class web.DHCIPBillPBCloseAcount Extends BILL.COM.Abstract
{

/// Description: 封账
/// Debug: w ##class(web.DHCIPBillPBCloseAcount).CloseAcount("10","25448","12173","10.1.130.194")
ClassMethod CloseAcount(adm, billno, userId, computername) As %String
{
	set $zt="ERROR"
	set ^TMP("CloseAcount")=$lb(adm, billno, userId, computername)
	quit:((adm="")||(billno="")) -1_"^"_"参数错误"
	
	set closeFlag=..GetPaidCAcountFlag(billno)
	quit:(closeFlag="Y") -1_"^"_"账单已封账，不能重复封账"
	
	set prtRowId=##class(BILL.IP.COM.Method).GetPrtInvIdByBill(billno)
	quit:(+prtRowId'=0) -1_"^"_"账单已结算，不能封账"
	
   	set visitStatus=$p(^PAADM(adm),"^",20)
   	quit:(visitStatus="P") -1_"^"_"就诊是预住院就诊，不能封账"
   	
	set lockErr=##class(DHCDoc.Util.System).LOCK("PA_Adm", adm, userId, computername)
	quit:(+lockErr'=-1) -110_"^"_"就诊："_adm_"被锁定"
	
	ts
	
	set rtn=0
	set curDate=+$h
	set curTime=$p($h,",",2)
	
	//更新账单
	&SQL(
		UPDATE DHC_PatientBill
		SET PB_PayedFlag = 'P', PB_UpdateDate = :curDate, PB_UpdateTime = :curTime, PB_UpdateUser = :userId
		WHERE %ID = :billno
	)
	set rtn=SQLCODE
	if (+rtn) {
		tro
		do ##class(DHCDoc.Util.System).LOCKCLR("PA_Adm", adm)
		quit rtn_"^"_$g(%msg)
	}
	
	set rtn=..UpdateItms(billno, "P")
	if (+rtn) {
		tro
		do ##class(DHCDoc.Util.System).LOCKCLR("PA_Adm", adm)
		quit rtn
	}
	
	if ($tl>0) tc
	
	set ^DHCPB(0,"PBCloseAcount",billno)="Y"_"^"_userId_"^"_curDate_"^"_curTime
	
	// Lid 2018-03-28 添加封账日志
	set tableName="PBCloseAcount", className="PBCloseAcount", classNameDesc="封账", objectDesc="新增", operateType="A"
	set json=##class(%DynamicObject).%New()
	set json.flag="Y"
	set json.userId=userId
	set json.closeDate=##class(websys.Conversions).DateLogicalToHtml(curDate)
	set json.closeTime=##class(websys.Conversions).TimeLogicalToHtml(curTime)
	set jsonStr=json.%ToJSON()

	set jsonStrOld=""
	do ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther(tableName, className, classNameDesc, billno, objectDesc, operateType, jsonStr, jsonStrOld, userId)
	
	set ^DHCIPBill("PatientBill",0,"accountrecAdmBill",adm,billno)="Y"
	
	set patAmt=$p($g(^DHCPB(billno)),"^",12)        //add by zhl  20120207    start
	set deposit=##class(web.UDHCJFBaseCommon).deposit(adm)
	set patShareSum=0
	set actbill=0
	while($o(^DHCIPBill("PatientBill",0,"accountrecAdmBill",adm,actbill))) {
		set actbill=$o(^DHCIPBill("PatientBill",0,"accountrecAdmBill",adm,actbill))
		set patAmt=$p($g(^DHCPB(actbill)),"^",12)
		set patShareSum=$i(patShareSum, patAmt)
	}
	set OweSum=deposit-patShareSum
	set ^DHCIPBill("PatientBill",0,"accountrecAdm",adm,curDate,curTime)=OweSum        //add by zhl  20120207    end
	
	do ##class(DHCDoc.Util.System).LOCKCLR("PA_Adm", adm)
	
	quit rtn

ERROR
	quit ..AppException()
}

/// Debug: w ##class(web.DHCIPBillPBCloseAcount).UpdateItms(273271, "P")
ClassMethod UpdateItms(pb As %String, billStatus As %String) As %String
{
	set rtn=0
	
	set pbo=0
	while($o(^DHCPB(pb,"O",pbo))&&(rtn=0)) {
		set pbo=$o(^DHCPB(pb,"O",pbo))
		set pboData=$g(^DHCPB(pb,"O",pbo))
		continue:(pboData="")
		set pboRowId=pb_"||"_pbo
		set exec=$p(pboData,"^",20)
		if (billStatus="P") {
			set status=$p(^OEORD(+exec,"I",$p(exec,"||",2),"X",$p(exec,"||",3)),"^",6)
			set $p(^OEORD(+exec,"I",$p(exec,"||",2),"X",$p(exec,"||",3)),"^",6)=billStatus
			&SQL(
				UPDATE DHC_PatBillOrder
				SET PBO_BillStatus = :status
				WHERE PBO_RowId = :pboRowId
			)
			set rtn=SQLCODE
			if (+rtn) {
				set rtn=rtn_"^"_$g(%msg)
				quit
			}
			continue
		}
		set pboStatus=$p(pboData,"^",16)
		set $p(^OEORD(+exec,"I",$p(exec,"||",2),"X",$p(exec,"||",3)),"^",6)=pboStatus
	}
	
	quit rtn
}

/// Debug: w ##class(web.DHCIPBillPBCloseAcount).GetPaidCAcountFlag("287318")
ClassMethod GetPaidCAcountFlag(BillNo As %String) As %String
{
	set isClosed="N"
	quit:(BillNo="") isClosed
	set closeAcountData=$g(^DHCPB(0,"PBCloseAcount",BillNo))
	if (closeAcountData'="") {
		set isClosed=$p(closeAcountData,"^",1)
	}
	quit isClosed
}

/// Description: 取消封账
/// Debug: w ##class(web.DHCIPBillPBCloseAcount).UnCloseAcount("13","287318","10207","收费01")
ClassMethod UnCloseAcount(adm, billno, userId, computername) As %String
{
	set $zt="ERROR"
	
	set ^TMP("UnCloseAcount")=$lb(adm, billno, userId, computername)
	quit:((adm="")||(billno="")) -1_"^"_"参数错误"
	
	set closeFlag=..GetPaidCAcountFlag(billno)
	quit:(closeFlag'="Y") -1_"^"_"账单未封账，无需取消"

	set isConfirm=##class(web.UDHCJFBillDetailOrder).GetCodingFlag(adm, billno)
	quit:(isConfirm="Y") -1_"^"_"已经审核，不能取消"

	set prtRowId=##class(BILL.IP.COM.Method).GetPrtInvIdByBill(billno)
	quit:(+prtRowId'=0) -1_"^"_"账单已经结算，不能取消"
	
	set lockErr=##class(DHCDoc.Util.System).LOCK("PA_Adm", adm, userId, computername)
	quit:(+lockErr'=-1) -110_"^"_"就诊："_adm_"被锁定"
	
	ts
	
	set rtn=0
	set curDate=+$h
	set curTime=$p($h,",",2)
	
	//更新账单
	&SQL(
		UPDATE DHC_PatientBill
		SET PB_PayedFlag = 'B', PB_UpdateDate = :curDate, PB_UpdateTime = :curTime, PB_UpdateUser = :userId
		WHERE %ID = :billno
	)
	set rtn=SQLCODE
	if (+rtn) {
		tro
		do ##class(DHCDoc.Util.System).LOCKCLR("PA_Adm", adm)
		quit rtn_"^"_$g(%msg)
	}
	
	set rtn=..UpdateItms(billno, "B")
	if (+rtn)  {
		tro
		do ##class(DHCDoc.Util.System).LOCKCLR("PA_Adm", adm)
		quit rtn
	}
	
	/*
	set rtn=##class(web.UDHCJFREBILL).REBILL("", "", adm, billno, userId)
	if (+rtn) {
		tro
		do ##class(DHCDoc.Util.System).LOCKCLR("PA_Adm", adm)
		quit rtn
	}
	*/
	set closeAcountData=$g(^DHCPB(0,"PBCloseAcount",billno))
	set oldUsr=$p(closeAcountData,"^",2)
	set oldCloseDate=$p(closeAcountData,"^",3)
	set oldCloseDate=##class(websys.Conversions).DateLogicalToHtml(oldCloseDate)
	set oldCloseTime=$p(closeAcountData,"^",4)
	set oldCloseTime=##class(websys.Conversions).TimeLogicalToHtml(oldCloseTime)
	
	set rtn=..DelCloseAcount(billno)
    if (+rtn) {
		tro
		do ##class(DHCDoc.Util.System).LOCKCLR("PA_Adm", adm)
		quit rtn
	}
	
	if ($tl>0) tc

    // Lid 2018-03-28 添加封账日志
	set tableName="PBCloseAcount", className="PBCloseAcount", classNameDesc="取消封账", objectDesc="修改", operateType="U"
	set json=##class(%DynamicObject).%New()
	set json.flag="Y"
	set json.userId=oldUsr
	set json.closeDate=##class(websys.Conversions).DateLogicalToHtml(oldCloseDate)
	set json.closeTime=##class(websys.Conversions).TimeLogicalToHtml(oldCloseTime)
	set jsonStr=json.%ToJSON()
	
	set jsonOld=##class(%DynamicObject).%New()
	set jsonOld.flag="N"
	set jsonOld.userId=userId
	set jsonOld.closeDate=##class(websys.Conversions).DateLogicalToHtml(curDate)
	set jsonOld.closeTime=##class(websys.Conversions).TimeLogicalToHtml(curTime)
	set jsonStrOld=jsonOld.%ToJSON()
	do ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther(tableName, className, classNameDesc, billno, objectDesc, operateType, jsonStr, jsonStrOld, userId)
	
	kill ^DHCIPBill("PatientBill",0,"accountrecAdmBill",adm,billno)
	
	set patAmt=$p($g(^DHCPB(billno)),"^",12)        //add by zhl 20120207 start
	set deposit=##class(web.UDHCJFBaseCommon).deposit(adm)
	set patShareSum=0
	set actbill=0
	while($o(^DHCIPBill("PatientBill",0,"accountrecAdmBill",adm,actbill))) {
		set actbill=$o(^DHCIPBill("PatientBill",0,"accountrecAdmBill",adm,actbill))
		set patAmt=$p($g(^DHCPB(actbill)),"^",12)
		set patShareSum=$i(patShareSum, patAmt)
	}
	set OweSum=deposit-patShareSum
	set ^DHCIPBill("PatientBill",0,"accountrecAdm",adm,curDate,curTime)=OweSum     //add by zhl  20120207    end
		
	do ##class(DHCDoc.Util.System).LOCKCLR("PA_Adm", adm)
   
	quit rtn
	
ERROR
	quit ..AppException()
}

/// Creator: ZhYW
/// CreatDate: 2021-07-22
/// Description: 取消封账后删掉封账标识
/// Input: DHC_PatientBill.RowId
/// Return: 
/// Debug: w ##class(web.DHCIPBillPBCloseAcount).DelCloseAcount("287318")
ClassMethod DelCloseAcount(billId As %String)
{
	kill ^DHCPB(0,"PBCloseAcount",billId)
	quit 0
}

}
