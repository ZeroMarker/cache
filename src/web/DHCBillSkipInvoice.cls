Import SQLUser

/// 名称: web.DHCBillSkipInvoice.cls
/// 描述: 发票跳号业务类
/// 编写者: ZhYW
/// 编写日期: 2018-02-12
Class web.DHCBillSkipInvoice Extends BILL.COM.Abstract
{

/// Creator: ZhYW
/// CreatDate: 2018-02-12
/// Description: 获取收费员门诊预交金当前可用发票和剩余发票数
/// Input: 
/// Return: 
/// Debug: w ##class(web.DHCBillSkipInvoice).GetAccPreReceiptNo("10207", 2)
ClassMethod GetAccPreReceiptNo(userId As %String, hospId As %String) As %String
{
	set receiptType=##class(web.UDHCAccAddDeposit).GetReceiptType(hospId)
	set leftNum=0
	set activeInvStr=""
	if (receiptType'=""){
		set activeInvStr=..GetActiveInvInfo(userId, receiptType, hospId)
	}
	set rowId=$p(activeInvStr,"^",1)
	set curNo=$p(activeInvStr,"^",2)
	set endNo=$p(activeInvStr,"^",3)
	set title=$p(activeInvStr,"^",4)
	if ((curNo'="")&&(endNo'="")){
		set leftNum=+endNo-curNo+1
	}
	set str=curNo_"^"_rowId_"^"_leftNum_"^"_endNo_"^"_title
    
    quit str
}

/// Creator: ZhYW
/// CreatDate: 2018-02-12
/// Description: 获取门诊收费员当前可用发票和剩余发票数
/// Input: 
/// Return: 
/// Debug: w ##class(web.DHCBillSkipInvoice).GetOPReceiptNo()
ClassMethod GetOPReceiptNo(userId As %String, insTypeId As %String, expStr As %String) As %String
{
	set groupId=$p(expStr,"^",1)
	set fairType=$p(expStr,"^",2)
	set hospId=$p(expStr,"^",3)
	
	set leftNum=0
	set (rowId, curNo, endNo, title)=""
	
	set myExpSr=fairType_"^"_insTypeId_"^"_hospId
	set rtnValue=##class(udhcOPBillIF).ReadReceiptNO(userId, groupId, myExpSr)
	set rtn=$p(rtnValue,"^",1)
	if (+rtn=0){
		set curNo=$p(rtnValue,"^",2)
		set rowId=$p(rtnValue,"^",3)
		set endNo=$p(rtnValue,"^",4)
		set title=$p(rtnValue,"^",5)
		set leftNum=$p(rtnValue,"^",6)
	}
	
	set str=curNo_"^"_rowId_"^"_leftNum_"^"_endNo_"^"_title

 	quit str
}

/// Creator: ZhYW
/// CreatDate: 2018-02-12
/// Description: 获取收费员住院押金当前可用发票和剩余发票数
/// Input: 
/// Return: 
/// Debug: w ##class(web.DHCBillSkipInvoice).GetIPDepReceiptNo("4632","I","2")
ClassMethod GetIPDepReceiptNo(userId As %String, depositType As %String, hospId As %String) As %String
{
	set leftNum=0
	if (depositType="") {
		set depositType="ID"
	}
	set receiptType=$case(depositType, "ID":"I", :"I")
	set activeRcptStr=..GetActiveReceiptInfo(userId, receiptType, hospId)
	set rowId=$p(activeRcptStr,"^",1)
	set curNo=$p(activeRcptStr,"^",2)
	set endNo=$p(activeRcptStr,"^",3)
	set title=$p(activeRcptStr,"^",4)
	if ((curNo'="")&&(endNo'="")) {
		set leftNum=+endNo-curNo+1
	}
	set str=curNo_"^"_rowId_"^"_leftNum_"^"_endNo_"^"_title

	quit str
}

/// Creator: ZhYW
/// CreatDate: 2018-02-12
/// Description: 获取收费员出院结算当前可用发票和剩余发票数
/// Input: 
/// Return: 
/// Debug: w ##class(web.DHCBillSkipInvoice).GetIPReceiptNo()
ClassMethod GetIPReceiptNo(userId As %String, insTypeId As %String, expStr As %String) As %String
{
	set groupId=$p(expStr,"^",1)
	set hospId=$p(expStr,"^",2)
	
	set leftNum=0
	set (rowId, curNo, endNo, title)=""
	
	set insInvType=##class(web.UDHCJFPAY).GetInvTypeByAdmRea(insTypeId, "I", hospId)
    if (insInvType="") {
	    set insInvType="I"
	}
	set activeInvStr=..GetActiveInvInfo(userId, insInvType, hospId)
	set rowId=$p(activeInvStr,"^",1)
	set curNo=$p(activeInvStr,"^",2)
	set endNo=$p(activeInvStr,"^",3)
	set title=$p(activeInvStr,"^",4)
	if ((curNo'="")&&(endNo'="")){
		set leftNum=+endNo-curNo+1
	}
    
	set str=curNo_"^"_rowId_"^"_leftNum_"^"_endNo_"^"_title

 	quit str
}

/// Creator: ZhYW
/// CreatDate: 2018-02-12
/// Description: 获取操作员可用发票信息
/// Table: DHC_INVOICE
/// Input: 
/// Return: 
/// Debug: w ##class(web.DHCBillSkipInvoice).GetActiveInvInfo(10207, "I", 2)
ClassMethod GetActiveInvInfo(userId As %String, invType As %String, hospId As %String) As %String
{
	set (rowId, curNo, endNo, title)=""
	&SQL(
		SELECT TOP 1 %ID, INV_LastNum, INV_EndInv, INV_title INTO :rowId, :curNo, :endNo, :title
		FROM DHC_INVOICE
		WHERE INV_Usr = :userId AND INV_Finalflag = 'Y' AND INV_type = :invType AND INV_hospital = :hospId
		ORDER BY %ID
	)
	quit rowId_"^"_curNo_"^"_endNo_"^"_title
}

/// Creator: ZhYW
/// CreatDate: 2018-02-12
/// Description: 获取操作员可用押金收据信息
/// Table: dhc_sfreceipt
/// Input: 
/// Return: 
/// Debug: w ##class(web.DHCBillSkipInvoice).GetActiveReceiptInfo(10207, "I", 2)
ClassMethod GetActiveReceiptInfo(userId As %String, receiptType As %String, hospId As %String) As %String
{
	set (rowId, curNo, endNo, title)=""
	&SQL(
		SELECT TOP 1 %ID, rcpt_currentno, rcpt_endno, rcpt_title INTO :rowId, :curNo, :endNo, :title
		FROM dhc_sfreceipt
		WHERE rcpt_lquser = :userId AND rcpt_useflag = '1' AND rcpt_loc = :receiptType AND rcpt_hospital = :hospId
		ORDER BY %ID
	)	       
	quit rowId_"^"_curNo_"^"_endNo_"^"_title
}

/// Creator: ZhYW
/// CreatDate: 2018-02-12
/// Description: 作废发票(注：只能从当前可用发票号开始，往后作废,不能任意号段作废.)
/// Table: DHC_VoidInv
/// Input: 
/// Return:
/// Debug: w ##class(web.DHCBillSkipInvoice).SkipInvoice("10000000068^dddd^10000000068^1^10000002000^A^^OP","17275^239^3^2^20")
ClassMethod SkipInvoice(invStr As %String, sessionStr As %String) As %String
{
	set $zt="ERROR"
	set ^TMP("SkipInvoice")=$lb(invStr, sessionStr)
	set userId=$p(sessionStr,"^",1)
	set groupId=$p(sessionStr,"^",2)
	set ctLocId=$p(sessionStr,"^",3)
	set hospId=$p(sessionStr,"^",4)

	set abortStNo=$p(invStr,"^",1)
	set voidReason=$p(invStr,"^",2)
	set abortEndNo=$p(invStr,"^",3)
	set abortNum=$p(invStr,"^",4)
	set endInvNo=$p(invStr,"^",5)
	set title=$p(invStr,"^",6)
	set insType=$p(invStr,"^",7)
	set receiptType=$p(invStr,"^",8)
	
	set rtn=0
	quit:(userId="")||(receiptType="") -1_"^"_"参数错误"

	quit:((abortEndNo-abortStNo+1)'=abortNum) -1_"^"_"作废数量与实际作废号段数不一致"
	
	quit:((abortEndNo-abortStNo)<0) -1_"^"_"结束号码不能小于开始号码"
	quit:((endInvNo-abortEndNo)<0) -1_"^"_"结束号码不能大于最大号码"
	
	ts
	
	if (receiptType="OP") {
		//门诊收费跳号
		set rtnValue=..UpdateOPReceipNo(userId, abortEndNo, groupId, "F", insType, hospId)
	}elseif (receiptType="OD") {
		//门诊预交金跳号
		set myPreReceiptType=##class(web.UDHCAccAddDeposit).GetReceiptType(hospId)
		if (myPreReceiptType'="") {
			set rtnValue=..UpdateAccPreReceiptNo(userId, abortEndNo, myPreReceiptType, hospId)
		}else {
			 set rtnValue=-5_"^"_"不需要跳号"
		}
	}elseif (receiptType="IP") {
		//住院收费跳号
		set rtnValue=..UpdateIPReceiptNo(userId, abortEndNo, groupId, insType, hospId)
	}else {
		set rtnValue=..UpdateIPDepReceiptNo(userId, abortEndNo, receiptType, hospId)
		set receiptType="ID"
	}
	set rtn=$p(rtnValue,"^",1)
	if (+rtn) tro  quit rtnValue
	set receiptId=$p(rtnValue,"^",2)
	
	set len=$l(endInvNo)
	for curNo=abortStNo:1:abortEndNo {
		set receiptNo=##class(web.UDHCJFBaseCommon).FormatINVNO(curNo, len)
		set receiptNo=title_receiptNo
		set objVOI=##class(User.DHCVoidInv).%New()
		set objVOI.VOIDate=+$h
		set objVOI.VOITime=$p($h,",",2)
		set objVOI.VOIInvNo=receiptNo
		do objVOI.VOIUserDRSetObjectId(userId)
		set objVOI.VOIReason=voidReason
		set objVOI.VOIHandin="N"
		set objVOI.VOIType=receiptType
		do objVOI.VOIHospDRSetObjectId(hospId)
		set sc=objVOI.%Save()
		set id=objVOI.%Id()
		do objVOI.%Close()
		if $$$ISERR(sc) {
			set rtn=$system.Status.GetErrorCodes(sc)_"^"_$system.Status.GetErrorText(sc)
			quit
		}
		
		//2021-04-08 ZhYW 保存发票扩展表数据
		continue:(" OP IP "'[(" "_receiptType_" "))
		set dto=##class(BILL.INV.DTO.Entity.PrtExt).%New()
		set dto.InvType=$tr(receiptType,"P","T")
		set dto.InvDR=id
		set dto.BatchNo=title
		set dto.InvNo=receiptNo
		set dto.PAPMIDR=""
		set dto.Payer=""
		set dto.PayerIdentifier=""
		set dto.UserDR=userId
		set dto.Reviewer=""
		set dto.InvoiceDR=receiptId
		set rtn=##class(BILL.INV.BL.PrtExt).Save(dto)
		quit:(+rtn)
	}
    if (+rtn) tro  quit rtn
    
    if ($tl>0) tc

	quit rtn

ERROR
	quit ..AppException()
}

/// Creator: ZhYW
/// CreatDate: 2018-02-12
/// Description: 更新门诊预交金票据号
/// Input: 
/// Return: 
/// Debug: w ##class(web.DHCBillSkipInvoice).UpdateAccPreReceiptNo()
ClassMethod UpdateAccPreReceiptNo(userId As %String, rcptNo As %String, receiptType As %String, hospId As %String) As %String
{
	set rtnValue=..GetAccPreReceiptNo(userId, receiptType, hospId)
	set rowId=$p(rtnValue,"^",2)
	
	set rtn=..UpdateInvoice(rowId, rcptNo, userId, receiptType, hospId)

	quit rtn_"^"_rowId
}

/// Creator: ZhYW
/// CreatDate: 2018-02-12
/// Description: 更新门诊发票票据号
/// Input: 
/// Return: 
/// Debug: w ##class(web.DHCBillSkipInvoice).UpdateOPReceipNo()
ClassMethod UpdateOPReceipNo(userId As %String, rcptNo As %String, groupId As %String, fairType As %String, insTypeId As %String, hospId As %String)
{
	set useINVType="O"
	set insUseINVType=##class(web.UDHCJFPAY).GetInvTypeByAdmRea(insTypeId, "O", hospId)
	if (insUseINVType'="") {
		set useINVType=insUseINVType
	}
	set myRegRcptType=##class(web.udhcOPBill7).GetRegReceiptType(hospId)
	if ((fairType="R")&&(myRegRcptType'="")) {
		set useINVType=myRegRcptType
	}

	set myExpStr=groupId_"^"_fairType_"^"_hospId
	set rtnValue=..GetOPReceiptNo(userId, insTypeId, myExpStr)
	set rowId=$p(rtnValue,"^",2)
	
	set rtn=..UpdateInvoice(rowId, rcptNo, userId, useINVType, hospId)
	
	quit rtn_"^"_rowId
}

/// Creator: ZhYW
/// CreatDate: 2018-02-12
/// Description: 更新住院押金票据号
/// Input: 
/// Return:  
/// Debug: w ##class(web.DHCBillSkipInvoice).UpdateIPDepReceiptNo()
ClassMethod UpdateIPDepReceiptNo(userId As %String, rcptNo As %String, depositType As %String, hospId As %String) As %String
{
	set rtnValue=..GetIPDepReceiptNo(userId, depositType, hospId)
	set rowId=$p(rtnValue,"^",2)
	quit:(rowId="") -201
	set endNo=$p(rtnValue,"^",4)
	
	set endNoABCINfo=##class(web.DHCBillCommon).GetINVPreABCInfo(endNo)
	set endNo=$p(endNoABCINfo,"^",1)
	
	set len=$l(endNo)
	if ($l(rcptNo)<len) {
		set rcptNo=##class(web.UDHCJFBaseCommon).FormatINVNO(rcptNo, len)
	}
	
	set curlen=$l(rcptNo)
	quit:((len'=curlen)||(+rcptNo>+endNo)) -202
	
	set rtn=##class(web.DHCIPBillDeposit).Ok(rcptNo, endNo, userId, rowId)
	
	quit rtn_"^"_rowId
}

/// Creator: ZhYW
/// CreatDate: 2018-02-12
/// Description: 更新住院收费票据号
/// Input: 
/// Return: 
/// Debug: w ##class(web.DHCBillSkipInvoice).UpdateIPReceiptNo()
ClassMethod UpdateIPReceiptNo(userId As %String, rcptNo As %String, groupId As %String, insTypeId As %String, hospId As %String) As %String
{
	set insInvType=##class(web.UDHCJFPAY).GetInvTypeByAdmRea(insTypeId, "I", hospId)
    if (insInvType="") {
	    set insInvType="I"
	}
	set expStr=groupId_"^"_hospId
	set rtnValue=..GetIPReceiptNo(userId, insTypeId, expStr)
	set rowId=$p(rtnValue,"^",2)
	
	set rtn=..UpdateInvoice(rowId, rcptNo, userId, insInvType, hospId)
	
	quit rtn_"^"_rowId
}

/// Creator: ZhYW
/// CreatDate: 2018-02-12
/// Description: 更新发票号
/// Table: DHC_INVOICE
/// Input: 
/// Return: 
/// Debug: w ##class(web.DHCBillSkipInvoice).UpdateInvoice()
ClassMethod UpdateInvoice(rowId As %String, rcptNo As %String, userId As %String, invType As %String, hospId As %String) As %String
{
	set rtn=-201
	quit:(+rowId=0) rtn
	set endNo=$p(^DHCINVOICE(rowId),"^",2)

	set len=$l(endNo)
	if ($l(rcptNo)<len) {
		set rcptNo=##class(web.UDHCJFBaseCommon).FormatINVNO(rcptNo, len)
	}
	
	set curLen=$l(rcptNo)
	quit:((len'=curLen)||(+rcptNo>+endNo)) -202
	
	if (+rcptNo=+endNo) {        //如果是最后一张领取的发票,标记为已用完
		set rtn=##class(web.UDHCAccAddDeposit).InvToFinal(rowId, rcptNo, userId, invType, hospId)
		quit rtn
	}
	
	set lastNum=##class(web.UDHCJFBaseCommon).incre(rcptNo)
	&SQL(
		UPDATE DHC_INVOICE
		SET INV_LastNum = :lastNum
		WHERE %ID = :rowId
	)
	set rtn=SQLCODE
	if (rtn) {
		set rtn=rtn_"^"_$g(%msg)
	}
	quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2018-06-13
/// Description: 跳号明细查询
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCBillSkipInvoice","FindSkipInv","2018-05-01","2018-06-13","OP","5")
Query FindSkipInv(stDate As %String, endDate As %String, invType As %String, guser As %String, hospId As %String, langId As %String = "") As websys.Query(ROWSPEC = "TUserName:%String:操作员,TDate:%String:作废日期,TTime:%String:作废时间,TVoidType:%String:票据类型,TInvNo:%String:作废票据号,TReason:%String:作废原因,THandinFlag:%String:是否结算") [ SqlProc ]
{
}

ClassMethod FindSkipInvExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, invType As %String, guser As %String, hospId As %String, langId As %String = "") As %Status
{
 	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
 	set ind=1
 	set ^TMP("FindSkipInv")=$lb(stDate, endDate, invType, guser, hospId, langId)
 	
	set stDate=##class(websys.Conversions).DateHtmlToLogical(stDate)
	set endDate=##class(websys.Conversions).DateHtmlToLogical(endDate)
 	
 	for date=endDate:-1:stDate {
		set rowId=0
		while($o(^DHCVoidInv(0,"Date",date,rowId))) {
			set rowId=$o(^DHCVoidInv(0,"Date",date,rowId))
			set invData=$g(^DHCVoidInv(rowId))
			continue:(invData="")
			set voidType=$p(invData,"^",11)
			continue:(invType'=voidType)
			set voidHospDR=$p(invData,"^",12)
			continue:(voidHospDR'=hospId)
			set voidType=$case(voidType, "OP":"门诊发票", "OD":"门诊预交金", "ID":"住院押金", "IP":"住院发票", :"")
			set voidType=##class(websys.Translation).Get("dhcbill.skipinvdtllist.csp", voidType)
			set voidUserDR=$p(invData,"^",5)
			continue:((guser'="")&&(guser'=voidUserDR))
			set voidUserName=$p($g(^SSU("SSUSR",voidUserDR)),"^",2)
			set voidUserName=##class(User.SSUser).GetTranByDesc("SSUSRName", voidUserName, langId)
			set voidTime=$p(invData,"^",2)
			set voidDate=##class(websys.Conversions).DateLogicalToHtml(date)
			set voidTime=##class(websys.Conversions).TimeLogicalToHtml(voidTime)
			set voidInvNo=$p(invData,"^",3)
			set voidReason=$p(invData,"^",7)
			set voidHandinFlag=$p(invData,"^",10)
		 	do OutputSkipInv
		}
 	}
 	
 	quit $$$OK
 	
OutputSkipInv
 	set Data=$lb(voidUserName,voidDate,voidTime,voidType,voidInvNo,voidReason,voidHandinFlag)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
 	quit
}

}
