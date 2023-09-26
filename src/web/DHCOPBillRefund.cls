Import SQLUser

/// 名称: web.DHCOPBillRefund.cls
/// 描述: 门诊退费查询类
/// 编写者: ZhYW
/// 编写日期: 2019-04-23
Class web.DHCOPBillRefund Extends BILL.COM.Abstract
{

/// Creator: ZhYW
/// CreatDate: 2019-04-23
/// Description: 查询门诊收费操作员
/// Input: 
/// Output: 
/// Return: do ##class(%ResultSet).RunQuery("web.DHCOPBillRefund","FindInvUser", "")
Query FindInvUser(desc As %String, hospId As %String, langId As %String = "") As websys.Query(ROWSPEC = "id:%String,text:%String")
{
}

ClassMethod FindInvUserExecute(ByRef qHandle As %Binary, desc As %String, hospId As %String, langId As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1

	if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
	kill userList
	set upDesc=$zcvt(desc,"U")
	
	set userId=0
	while($o(^DHCINVPRT(0,"User",userId))) {
		set userId=$o(^DHCINVPRT(0,"User",userId))
		set userData=$g(^SSU("SSUSR",userId))
		set showFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("SS_User", userId, hospId)
		continue:(showFlag="N")
		set userList(userId)=""
		set userCode=$p(userData,"^",1)
		set userName=$p(userData,"^",2)
		continue:((upDesc'="")&&($zcvt(userCode,"U")'[upDesc)&&($zcvt(userName,"U")'[upDesc))
		set userName=##class(User.SSUser).GetTranByDesc("SSUSRName", userName, langId)
		do OutputInvUser
	}
	
	set userId=0
	while($o(^DHCINVPRTAPi(0,"UseDR",userId))) {
		set userId=$o(^DHCINVPRTAPi(0,"UseDR",userId))
		continue:($d(userList(userId)))       //去重
		set userData=$g(^SSU("SSUSR",userId))
		set showFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("SS_User", userId, hospId)
		continue:(showFlag="N")
		set userCode=$p(userData,"^",1)
		set userName=$p(userData,"^",2)
		continue:((upDesc'="")&&($zcvt(userCode,"U")'[upDesc)&&($zcvt(userName,"U")'[upDesc))
		set userName=##class(User.SSUser).GetTranByDesc("SSUSRName", userName, langId)
		do OutputInvUser
	}
	
	quit $$$OK
OutputInvUser
	set Data=$lb(userId,userName)
	set ^CacheTemp(repid,ind)=Data
	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2019-04-23
/// Description: 门诊票据查询
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCOPBillRefund","FindOPBillINV","2020-06-24","2020-06-24","","","","0","239^535^9")
Query FindOPBillINV(stDate As %String, endDate As %String, userId As %String, receiptNo As %String, patientNo As %String, auditFlag As %String, sessionStr As %String) As websys.Query(ROWSPEC = "patientNo:%String:登记号,patName:%String:患者姓名,invRowId:%String:发票ID,invNo:%String:发票号,patShareAmt:%Float:自付金额,userName:%String:收费员,prtDate:%String:收费日期,prtTime:%String:收费时间,totalAmt:%Float:费用总额,prtRowId:%String:小条ID,invFlag:%String:发票类型,hasRefOrd:%String:是否有可退费医嘱,invUsrName:%String:开票人,invDate:%String:开票日期,invTime:%String:开票时间,encryptLevel:%String:密级,patLevel:%String:级别")
{
}

ClassMethod FindOPBillINVExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, userId As %String, receiptNo As %String, patientNo As %String, auditFlag As %String, sessionStr As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	set ^TMP("FindOPBillINV")=$lb(stDate, endDate, userId, receiptNo, patientNo, auditFlag, sessionStr)
	if ((stDate="")||(endDate=""))  quit $$$OK
	
	set stDate=##class(websys.Conversions).DateHtmlToLogical(stDate)
	set endDate=##class(websys.Conversions).DateHtmlToLogical(endDate)
	
	set groupId=$p(sessionStr,"^",2)
	set ctLocId=$p(sessionStr,"^",3)
	set hospId=$p(sessionStr,"^",4)
	set langId=$p(sessionStr,"^",5)
	
	set isAllowRefReg=..IsAllowedRefundReg(hospId)  //获取能否退挂号费  2022-09-8  Luan Zhenhui
	
	//根据发票号查询
	if (receiptNo'="") {
		//门诊收费
		set invFlag="PRT"
		set invRowId=0
		while($o(^DHCINVPRT(0,"INV",receiptNo,invRowId))) {
			set invRowId=$o(^DHCINVPRT(0,"INV",receiptNo,invRowId))
			set isAuditInv=##class(BILL.OP.COM.Method).CheckInvIsRefAudit(invRowId, invFlag)
			continue:((isAuditInv'=1)&&(auditFlag=1))
			set hasRefOrd=isAuditInv   //+2022-10-25 ZhYW 是否含有可退费医嘱
			if (hasRefOrd=0) {
				set hasRefOrd=##class(web.DHCOPBillEmergTrans2IP).CheckInvIsOPToIP(invRowId_":"_invFlag)
			}
			do GetPrtInfo(invRowId)
		}
		//集中打印发票
		set invFlag="API"
		set invRowId=0
		while($o(^DHCINVPRTAPi(0,"INVNo",receiptNo,invRowId))) {
			set invRowId=$o(^DHCINVPRTAPi(0,"INVNo",receiptNo,invRowId))
			set isAuditInv=##class(BILL.OP.COM.Method).CheckInvIsRefAudit(invRowId, invFlag)
			continue:((isAuditInv'=1)&&(auditFlag=1))
			set hasRefOrd=isAuditInv   //+2022-10-25 ZhYW 是否含有可退费医嘱
			if (hasRefOrd=0) {
				set hasRefOrd=##class(web.DHCOPBillEmergTrans2IP).CheckInvIsOPToIP(invRowId_":"_invFlag)
			}
			do GetAPIInfo(invRowId)
		}
		quit $$$OK
	}
	
	//根据患者主索引查询
	if (patientNo'="") {
		set patientNo=##class(web.UDHCJFBaseCommon).regnocon(patientNo)
		set patientId=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(patientNo),""))
		quit:(+patientId=0) $$$OK
		//门诊收费
		set invFlag="PRT"
		set invRowId=""
		while($o(^DHCINVPRT(0,"PAPMI",patientId,invRowId),-1)) {
			set invRowId=$o(^DHCINVPRT(0,"PAPMI",patientId,invRowId),-1)
			set invData=$g(^DHCINVPRT(invRowId))
			set invDate=$p(invData,"^",5)
			set invTime=$p(invData,"^",20)
			continue:((invDate<stDate)||(invDate>endDate))
			set isAuditInv=##class(BILL.OP.COM.Method).CheckInvIsRefAudit(invRowId, invFlag)
			continue:((isAuditInv'=1)&&(auditFlag=1))
			set hasRefOrd=isAuditInv   //+2022-10-25 ZhYW 是否含有可退费医嘱
			if (hasRefOrd=0) {
				set hasRefOrd=##class(web.DHCOPBillEmergTrans2IP).CheckInvIsOPToIP(invRowId_":"_invFlag)
			}
			do GetPrtInfo(invRowId)
		}
		//集中打印发票
		set invFlag="API"
		set invRowId=""
		while($o(^DHCINVPRTAPi(0,"PAPMI",patientId,invRowId),-1)) {
			set invRowId=$o(^DHCINVPRTAPi(0,"PAPMI",patientId,invRowId),-1)
			set invData=$g(^DHCINVPRTAP(invRowId))
			set invDate=$p(invData,"^",3)
			set invTime=$p(invData,"^",4)
			continue:((invDate<stDate)||(invDate>endDate))
			set isAuditInv=##class(BILL.OP.COM.Method).CheckInvIsRefAudit(invRowId, invFlag)
			continue:((isAuditInv'=1)&&(auditFlag=1))
			set hasRefOrd=isAuditInv   //+2022-10-25 ZhYW 是否含有可退费医嘱
			if (hasRefOrd=0) {
				set hasRefOrd=##class(web.DHCOPBillEmergTrans2IP).CheckInvIsOPToIP(invRowId_":"_invFlag)
			}
			do GetAPIInfo(invRowId)
		}
		quit $$$OK
	}
	
	//根据收费员查询
	if (userId'="") {
		//门诊收费
		set invFlag="PRT"
		set date=$s((+endDate'=0):(endDate+1),1:"")
		while($o(^DHCINVPRT(0,"UserDate",userId,date),-1)) {
			set date=$o(^DHCINVPRT(0,"UserDate",userId,date),-1)
			continue:((stDate'="")&&(stDate>date))
			set invRowId=""
			while($o(^DHCINVPRT(0,"UserDate",userId,date,invRowId),-1)) {
				set invRowId=$o(^DHCINVPRT(0,"UserDate",userId,date,invRowId),-1)
				set isAuditInv=##class(BILL.OP.COM.Method).CheckInvIsRefAudit(invRowId, invFlag)
				continue:((isAuditInv'=1)&&(auditFlag=1))
				set hasRefOrd=isAuditInv    //+2022-10-25 ZhYW 是否含有可退费医嘱
				if (hasRefOrd=0) {
					set hasRefOrd=##class(web.DHCOPBillEmergTrans2IP).CheckInvIsOPToIP(invRowId_":"_invFlag)
				}
				do GetPrtInfo(invRowId)
			}
		}
		//集中打印发票
		set invFlag="API"
		set date=$s((+endDate'=0):(endDate+1),1:"")
		while($o(^DHCINVPRTAPi(0,"UserDate",userId,date),-1)) {
			set date=$o(^DHCINVPRTAPi(0,"UserDate",userId,date),-1)
			continue:((stDate'="")&&(stDate>date))
			set invRowId=""
			while($o(^DHCINVPRTAPi(0,"UserDate",userId,date,invRowId),-1)) {
				set invRowId=$o(^DHCINVPRTAPi(0,"UserDate",userId,date,invRowId),-1)
				set isAuditInv=##class(BILL.OP.COM.Method).CheckInvIsRefAudit(invRowId, invFlag)
				continue:((isAuditInv'=1)&&(auditFlag=1))
				set hasRefOrd=isAuditInv    //+2022-10-25 ZhYW 是否含有可退费医嘱
				if (hasRefOrd=0) {
					set hasRefOrd=##class(web.DHCOPBillEmergTrans2IP).CheckInvIsOPToIP(invRowId_":"_invFlag)
				}
				do GetAPIInfo(invRowId)
			}
		}
		quit $$$OK
	}
	
	//根据日期查询
	for date=endDate:-1:stDate {
		//门诊收费
		set invFlag="PRT"
		set invRowId=""
		while($o(^DHCINVPRT(0,"Date",date,invRowId),-1)) {
			set invRowId=$o(^DHCINVPRT(0,"Date",date,invRowId),-1)
			set isAuditInv=##class(BILL.OP.COM.Method).CheckInvIsRefAudit(invRowId, invFlag)
			continue:((isAuditInv'=1)&&(auditFlag=1))
			set hasRefOrd=isAuditInv     //+2022-10-25 ZhYW 是否含有可退费医嘱
			if (hasRefOrd=0) {
				set hasRefOrd=##class(web.DHCOPBillEmergTrans2IP).CheckInvIsOPToIP(invRowId_":"_invFlag)
			}
			do GetPrtInfo(invRowId)
		}
		//集中打印发票
		set invFlag="API"
		set invRowId=""
		while($o(^DHCINVPRTAPi(0,"Date",date,invRowId),-1)) {
			set invRowId=$o(^DHCINVPRTAPi(0,"Date",date,invRowId),-1)
			set isAuditInv=##class(BILL.OP.COM.Method).CheckInvIsRefAudit(invRowId, invFlag)
			continue:((isAuditInv'=1)&&(auditFlag=1))
			set hasRefOrd=isAuditInv    //+2022-10-25 ZhYW 是否含有可退费医嘱
			if (hasRefOrd=0) {
				set hasRefOrd=##class(web.DHCOPBillEmergTrans2IP).CheckInvIsOPToIP(invRowId_":"_invFlag)
			}
			do GetAPIInfo(invRowId)
		}
	}
	
	quit $$$OK
	
GetPrtInfo(invRowId)
	set prtInvData=$g(^DHCINVPRT(invRowId))
	set hospDR=$p(prtInvData,"^",39)
	quit:(hospDR'=hospId)
	set prtFlag=$p(prtInvData,"^",8)
	quit:(prtFlag="TP")
	set fairType=$p(prtInvData,"^",34)
	quit:((isAllowRefReg=0)&&(fairType="R"))  //R:过滤挂号发票
	set totalAmt=$p(prtInvData,"^",1)
	set totalAmt=$fn(totalAmt,"",2)
	set invNo=$p(prtInvData,"^",14)
	set accPayInvDR=$p(prtInvData,"^",4)
	quit:(accPayInvDR'="")    //集中打印发票的退出
	set initInvDR=$p(prtInvData,"^",13)
	quit:(initInvDR'="")
	quit:($o(^DHCINVPRT(0,"InitInvDR",invRowId,""))'="")  //被退费的小条退出
	quit:($o(^DHCINVPRT(0,"OldINV",invRowId,""))'="")
	set userDR=$p(prtInvData,"^",21)
	set userName=$p($g(^SSU("SSUSR",userDR)),"^",2)
	set userName=##class(User.SSUser).GetTranByDesc("SSUSRName", userName, langId) 
	set patShareAmt=$p(prtInvData,"^",16)
	set patShareAmt=$fn(patShareAmt,"",2)
	set prtDate=$p(prtInvData,"^",5)
	set prtDate=##class(websys.Conversions).DateLogicalToHtml(prtDate)
	set prtTime=$p(prtInvData,"^",20)
	set prtTime=##class(websys.Conversions).TimeLogicalToHtml(prtTime)
	set accPConPrtDR=""   //集中打印发票关联的小条RowId
	set papmi=$p(prtInvData,"^",15)
	set regNo=$p($g(^PAPER(papmi,"PAT",1)),"^",2)
	set patName=$p($g(^PAPER(papmi,"ALL")),"^",1)
  	set (invUsrName, invDate, InvTime)=""
  	set invPrintFlag=$p(prtInvData,"^",3)
  	set (invUsrName, invDate, invTime)=""
  	if (invPrintFlag="P") {
		set invUsrName=userName      //开票人
		set invDate=prtDate          //开票日期
		set invTime=prtTime          //开票时间
	}
	set patEncryptLevel=##class(web.UDHCJFBaseCommon).GetPatEncryptLevel(papmi, "")
 	set encryptLevel=$p(patEncryptLevel,"^",1)
  	set patLevel=$p(patEncryptLevel,"^",2)
	do OutputOPBillINV
	quit
	
GetAPIInfo(invRowId)
	set accPInvData=$g(^DHCINVPRTAP(invRowId))
	set hospDR=$p(accPInvData,"^",30)
	quit:(hospDR'=hospId)
	set totalAmt=$p(accPInvData,"^",1)
	set totalAmt=$fn(totalAmt,"",2)
	set userDR=$p(accPInvData,"^",5)
	set invUsrName=$p($g(^SSU("SSUSR",userDR)),"^",2)    //开票人
	set invUsrName=##class(User.SSUser).GetTranByDesc("SSUSRName", invUsrName, langId)
	set invNo=$p(accPInvData,"^",6)
	set initInvDR=$p(accPInvData,"^",10)
	quit:(initInvDR'="")    //负票退出
	quit:($o(^DHCINVPRTAPi(0,"OldADR",invRowId,""))'="")  //被退费的发票退出
	quit:($o(^DHCINVPRTAPi(0,"APIDR",invRowId,""))'="")
	set invDate=$p(accPInvData,"^",3)
	set invDate=##class(websys.Conversions).DateLogicalToHtml(invDate)
	set invTime=$p(accPInvData,"^",4)
	set invTime=##class(websys.Conversions).TimeLogicalToHtml(invTime)
	set patShareAmt=$p(accPInvData,"^",13)
	set patShareAmt=$fn(patShareAmt,"",2)
	set accPConPrtDR=""   //集中打印发票关联的小条RowId
	set isAllowAtPRTPage=..APIINVIsAllowRefAtPRTRefPage(invRowId)
	if (isAllowAtPRTPage="Y") {
		set apiConDR=$o(^DHCINVPRTCAPi(0,"APINVDR",invRowId,0))
		set accPConPrtDR=$s((+apiConDR'=0):$p($g(^DHCINVPRTCAP(apiConDR)),"^",1),1:"")
	}
	set papmi=$p(accPInvData,"^",11)
	set regNo=$p($g(^PAPER(papmi,"PAT",1)),"^",2)
	set patName=$p($g(^PAPER(papmi,"ALL")),"^",1)
	//+2023-02-16 ZhYW 增加收费员、收费日期、收费时间
	set accConPayId=$o(^DHCINVPRTCAPi(0,"APINVDR",invRowId,""),-1)
	set invPrtDR=$p(^DHCINVPRTCAP(accConPayId),"^",1)
	set invPrtData=$g(^DHCINVPRT(invPrtDR))
	set prtUsrDR=$p(invPrtData,"^",21)
	set userName=$s((+prtUsrDR'=0):$p($g(^SSU("SSUSR",prtUsrDR)),"^",2),1:"")       //收费员
	set userName=##class(User.SSUser).GetTranByDesc("SSUSRName", userName, langId)
	set prtDate=$p(invPrtData,"^",5)
	set prtDate=##class(websys.Conversions).DateLogicalToHtml(prtDate)   //收费日期
	set prtTime=$p(invPrtData,"^",20)
	set prtTime=##class(websys.Conversions).TimeLogicalToHtml(prtTime)   //收费时间
	set patEncryptLevel=##class(web.UDHCJFBaseCommon).GetPatEncryptLevel(papmi, "")
	set encryptLevel=$p(patEncryptLevel,"^",1)
	set patLevel=$p(patEncryptLevel,"^",2)
	do OutputOPBillINV
	quit
	
OutputOPBillINV
	set Data=$lb(regNo,patName,invRowId,invNo,patShareAmt,userName,prtDate,prtTime,totalAmt,accPConPrtDR,invFlag,hasRefOrd,invUsrName,invDate,invTime,encryptLevel,patLevel)
	set ^CacheTemp(repid,ind)=Data
	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2019-04-23
/// Description: 判断发票是否已做申请
/// Input: prtRowId:发票RowId(DHC_INVPRT.RowId / DHC_AccPayInv.RowId), invType:发票类型(PRT, API)
/// Return: 0:否, 1:是
/// Debug: w ##class(web.DHCOPBillRefund).CheckInvIsRefReq(233825, "INV")
ClassMethod CheckInvIsRefReq(prtRowId As %String, invType As %String) As %String
{
	set rtn=0
	quit:(+prtRowId=0) rtn
	if (invType="API") {
		set prtFlag=$p(^DHCINVPRTAP(prtRowId),"^",2)
		quit:(prtFlag'="N") rtn
		set apiConDR=0
		while($o(^DHCINVPRTCAPi(0,"APINVDR",prtRowId,apiConDR))) {
			set apiConDR=$o(^DHCINVPRTCAPi(0,"APINVDR",prtRowId,apiConDR))
			set prtId=$p($g(^DHCINVPRTCAP(apiConDR)),"^",1)
			set rtn=$$CheckInv(prtId)
			quit:(+rtn)
		}
		quit rtn
	}
	quit $$CheckInv(prtRowId)
	
CheckInv(prtRowId)
	set prtFlag=$p(^DHCINVPRT(prtRowId),"^",8)
	quit:(prtFlag'="N") rtn
	quit ($o(^DHCINVPRT(prtRowId,"OA",0))>0)
}

/// Creator: ZhYW
/// CreatDate: 2019-04-23
/// Description: 判断发票号是否存在
/// Input: recepitNo:发票号
/// Return: 0:不存在，1:存在
/// Debug: w ##class(web.DHCOPBillRefund).CheckInvIsReqByInvNo()
ClassMethod CheckInvIsValid(recepitNo As %String, hospId As %String) As %String
{
	quit:(recepitNo="") 0

	set invRowId=""
	set prtRowId=0
	while($o(^DHCINVPRT(0,"INV",recepitNo,prtRowId))&&(invRowId="")) {
		set prtRowId=$o(^DHCINVPRT(0,"INV",recepitNo,prtRowId))
		set hospDR=$p(^DHCINVPRT(prtRowId),"^",39)
		continue:(hospDR'=hospId)
		set invRowId=prtRowId
	}
	quit:(+invRowId'=0) 1
	
	set prtRowId=0
	while($o(^DHCINVPRTAPi(0,"INVNo",recepitNo,prtRowId))&&(invRowId="")) {
		set prtRowId=$o(^DHCINVPRTAPi(0,"INVNo",recepitNo,prtRowId))
		set hospDR=$p(^DHCINVPRTAP(prtRowId),"^",30)
		continue:(hospDR'=hospId)
		set invRowId=prtRowId
	}
	quit:(+invRowId'=0) 1
	
	quit 0
}

/// Creator: ZhYW
/// CreatDate: 2019-04-23
/// Description: 查询门诊退费医嘱
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCOPBillRefund","FindOrdItm", "7048:PRT","20")
Query FindOrdItm(invStr As %String, langId As %String = "") As websys.Query(ROWSPEC = "arcimDesc:%String:医嘱,patShareAmt:%Float:金额,billQty:%String:数量,packUom:%String:单位,itmStat:%String:医嘱状态,prescNo:%String:处方/标本号,recDept:%String:接收科室,refQty:%String:退费数量,refAmt:%Float:退费金额,auditFlag:%String,disabled:%String,select:%String,cantRefReason:%String:不能退费原因,execInfo:%String:执行情况,ordSttDate:%String:医嘱日期,isAppRep:%String:是否多部位检查,isCNMedItem:%String:是否草药,oeori:%String:医嘱ID,pboRowId:%String,prtId:%String")
{
}

ClassMethod FindOrdItmExecute(ByRef qHandle As %Binary, invStr As %String, langId As %String = "") As %Status
{
    set repid=$I(^CacheTemp)
    set qHandle=$lb(0,repid,0)
    set ind=1
	set ^TMP("FindOrdItm")=$lb(invStr, langId)
	
	if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}

	set invId=$p(invStr,":",1)
	set invType=$p(invStr,":",2)
	if ((invId="")||(invType="")) quit $$$OK
	
	if (invType="API") {
		set apiConDR=0
		while($o(^DHCINVPRTCAPi(0,"APINVDR",invId,apiConDR))) {
			set apiConDR=$o(^DHCINVPRTCAPi(0,"APINVDR",invId,apiConDR))
			set apiConData=$g(^DHCINVPRTCAP(apiConDR))
  			set prtId=$p(apiConData,"^",1)
  			do GetOrdItmDtl(prtId)
		}
		quit $$$OK
	}
	
	do GetOrdItmDtl(invId)
 
    quit $$$OK
    
GetOrdItmDtl(prtId)
	set hospDR=$p(^DHCINVPRT(prtId),"^",39)
	
    set billConInv=0
    while($o(^DHCBCI(0,"INV",prtId,billConInv))) {
	    set billConInv=$o(^DHCBCI(0,"INV",prtId,billConInv))
  		set pb=$p($g(^DHCBCI(billConInv)),"^",2)
  		set pbo=0
  		while($o(^DHCPB(pb,"O",pbo))) {
	  		set pbo=$o(^DHCPB(pb,"O",pbo))
	  		set pboData=$g(^DHCPB(pb,"O",pbo))
			continue:(pboData="")
			set pboRowId=pb_"||"_pbo
			set patShareAmt=$p(pboData,"^",11)
			set patShareAmt=$fn(patShareAmt,"",2)
			set refAmt=patShareAmt                    //退费金额初始化为收费金额
			set arcim=$p(pboData,"^",3)
			set arcimDesc=$p($g(^ARCIM(+arcim,$p(arcim,"||",2),1)),"^",2)   //名称
			set arcimDesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc", arcimDesc, langId) 
			set oeori=$p(pboData,"^",4)               //PBO_OEORI_DR
			set pboBillQty=$p(pboData,"^",5)          //PBO_BillQty
			set pboRefQty=$p(pboData,"^",6)           //PBO_RefundQty
			set pboQty=pboBillQty+pboRefQty
			continue:(pboQty=0)
			do InitOutput
			set packQty=$p($g(^OEORD(+oeori,"I",$p(oeori,"||",2),9)),"^",4)                //OEORI_QtyPackUOM
			set doseQty=$p($g(^OEORD(+oeori,"I",$p(oeori,"||",2),1)),"^",12)		       //OEORI_PhQtyOrd
			set itmStatDR=$p($g(^OEORD(+oeori,"I",+$p(oeori,"||",2),1)),"^",13)            //医嘱状态
			set itmStatCode=$s((+itmStatDR'=0):$p($g(^OEC("OSTAT",itmStatDR)),"^",1),1:"")
			set itmStat=$s((+itmStatDR'=0):$p($g(^OEC("OSTAT",itmStatDR)),"^",2),1:"")
			set itmStat=##class(User.OECOrderStatus).GetTranByDesc("OSTATDesc", itmStat, langId)
			set ordSttDate=$p($g(^OEORD(+oeori,"I",+$p(oeori,"||",2),1)),"^",9)            //OEORI_SttDat 医嘱日期
			set ordSttDate=##class(websys.Conversions).DateLogicalToHtml(ordSttDate)
			set ordDeptDR=$p($g(^OEORD(+oeori,"I",+$p(oeori,"||",2),1)),"^",3)             //OEORI_OrdDept_DR 就诊科室
			set ordDept=$s((+ordDeptDR'=0):$p($g(^CTLOC(ordDeptDR)),"^",2),1:"")
			set authStr=##class(web.UDHCPRTOEAuthIF).ReadOEORDAuthFlag(prtId, oeori, "")
 			set auditFlag=$p(authStr,"^",1)              //判断是否审批
			set disabled=$p(authStr,"^",2)               //判断选择项目是否disable
 			set select=$p(authStr,"^",3)                 //判断选择项目是否被选中
			set cantRefReason=$p(authStr,"^",4)          //不可退费原因
			set priceInfo=##class(web.UDHCOEORDOPIF).GetOrderPrice(pboRowId, oeori, 0, "")
			set price=$p(priceInfo,"^",1)        //PBO_UnitPrice
			set patPrice=$p(priceInfo,"^",4)     //PBO_PatPrice
			set packUom=##class(web.DHCBillCommon).GetPackUom(arcim, oeori)
			set packUom=##class(User.CTUOM).GetTranByDesc("CTUOMDesc", packUom, langId)
			set confac=##class(web.DHCBillCommon).GetUomConvFactor(arcim, oeori)
			set billQty=pboQty/confac
			set refQty=billQty                   //退费数量初始化为计费数量
			set recDeptDR=$p($g(^OEORD(+oeori,"I",+$p(oeori,"||",2),3)),"^",6)     //接收科室
 			set recDept=$s((+recDeptDR'=0):$p($g(^CTLOC(recDeptDR)),"^",2),1:"")
 			set recDept=##class(User.CTLoc).GetTranByDesc("CTLOCDesc", recDept, langId)
  			set ordCateType=##class(web.UDHCJFBaseCommon).GetOrdCateType(arcim, 0)
  			set prescNo=$s((ordCateType="R"):$p($g(^OEORD(+oeori,"I",$p(oeori,"||",2),1)),"^",14),1:$p($g(^OEORD(+oeori,"I",$p(oeori,"||",2),3)),"^",20))         //处方/检验标本号
  			
  			if (ordCateType="R") {
	  			//药品
	  			do DrugOrder
				continue
	  		}
	  		
	  		//非药品
			set packQty=doseQty
			
	  		//走发放的材料
	  		set isMatGrant=##class(web.DHCOPBillRefundRequest).CheckIsMatDispGrant(oeori)  //门诊物资走发放流程标识
	  		if (isMatGrant="Y") {
		  		do MatGrantOrder
				continue
		  	}

		  	//多部位检查申请单
		  	set isAppRep=##class(web.UDHCJFPRICE).IsAppRepOrder(oeori)
			if (isAppRep="Y") {
				do AppRepOrder
				continue
			}

			//其他医嘱
			do OtherOrder
			continue
	  	}
	}
    quit
    
InitOutput
	set isCNMedItem=0
	set isAppRep="N"
	quit

DrugOrder
	set isCNMedItem=##class(web.DHCDocOrderCommon).IsCNMedItem(arcim, hospDR)
	set isOPIVAS=$p($g(^OEORD(+oeori,"I",$p(oeori,"||",2),"DHC")),"^",16)   //静配标识
	if (isOPIVAS="Y") {
		//静脉配液
		set effectiveQty=##class(BILL.Interface.Inside.Invoke).GetEffectiveQtyForOPIVAS(oeori)
		set packQty=effectiveQty/confac
		set retQty=billQty-packQty
		set ivasDspInfo=##class(BILL.Interface.Inside.Invoke).GetOPIVASQtyByOeori(oeori, "C^R")
		set packIVASQty=$p(ivasDspInfo,"^",1)
		set retIVASQty=$p(ivasDspInfo,"^",2)
		set packIVASQty=packIVASQty/confac
		set retIVASQty=retIVASQty/confac
		set packIVASQty=$fn(packIVASQty,"N")
		set retIVASQty=$fn(retIVASQty,"N")
		set execInfo=##class(websys.Translation).Get("", "已发药", langId)_"："_packIVASQty_"&emsp;"_##class(websys.Translation).Get("", "已退药", langId)_"："_retIVASQty_"&emsp;"_##class(websys.Translation).Get("", "有效数量", langId)_"："_packQty
	}else {
		set dspQty=..GetOutPHQty(oeori, prtId)     //发药数量
		set dspQty=dspQty/confac
		set dspQty=$fn(dspQty,"N")
		set retQty=..GetRetOrdQty(oeori, prtId)     //退药数量
		set retQty=retQty/confac
		set retQty=$fn(retQty,"N")
		set execInfo=##class(websys.Translation).Get("", "已发药", langId)_"："_dspQty_"&emsp;"_##class(websys.Translation).Get("", "已退药", langId)_"："_retQty
	}
	if (+retQty'=0) {
		set refQty=retQty
		set refAmt=..GetPHRefundSum(pboRowId, prtId)    //药品退药金额
	}
	do FormatOutput
	quit

MatGrantOrder
	//走发放的材料
	set matDspQty=##class(web.DHCOPBillRefundRequest).GetMatDispQty(oeori)
	set dspQty=$p(matDspQty,"^",1)      //发放数量
	set retQty=..GetMatRetQty(oeori, prtId)     //物资实际退费数量
	set dspQty=$fn(dspQty,"N")
	set retQty=$fn(retQty,"N")
	set execInfo=##class(websys.Translation).Get("", "已发放", langId)_"："_dspQty_"&emsp;"_##class(websys.Translation).Get("", "已退回", langId)_"："_retQty
	if (+dspQty'=0) {
		set refQty=retQty
		set refAmt=patPrice*refQty      //已发放时,按实际退的数量计算退费金额
	}
	do FormatOutput
	quit
		
AppRepOrder
	//多部位检查申请单
	set partDesc=##class(web.DHCAPPInterface).GetExaReqPartDesc(oeori)
	set arcimDesc=arcimDesc_partDesc
	set isPartExecFlag=..IsPartExecut(oeori)   //判断是否是部分执行
	if (isPartExecFlag=0) set itmStatCode=""
	set execInfo=$s((itmStatCode="E"):##class(websys.Translation).Get("", "已执行", langId),1:"")
	set isRefAll=..IsAllRefundRepPart(oeori)
	set refQty=$case(isRefAll,1:1,:0)   //refQty:0:全部退费,1:部分退费
	set refAmt=..GetRepPartRefAmt(oeori, pboRowId)
	do FormatOutput
	quit

OtherOrder
	//其他医嘱
	set execQty=##class(web.UDHCJFBILL).GetOrdExecQty(oeori)   //已执行数量
	set execQty=execQty/confac
	set execQty=$fn(execQty,"N")
	set unExecQty=packQty-execQty          //未执行数量(总数量-已执行数量)
	set unExecQty=$fn(unExecQty,"N")
	set refQty=refQty-execQty              //退费数量默认为计费数量-执行数量
	set execInfo=##class(websys.Translation).Get("", "已执行", langId)_"："_execQty_"&emsp;"_##class(websys.Translation).Get("", "未执行", langId)_"："_unExecQty
	set refQtyInfo=##class(web.DHCOPBillOERefundQty).GetRefundQTY(oeori, "")
	set retQty=+$p(refQtyInfo,"^",2)
	if (retQty'=0) set refQty=retQty      //有申请数量时，退费数量取申请的数量
	set refAmt=patPrice*refQty
	do FormatOutput
	quit

FormatOutput
	//急诊转住院的医嘱全退
  	if (##class(web.DHCOPBillEmergTrans2IP).OrdIsOPToIPByOEORI(oeori)) {
	  	set refQty=$s((isAppRep="Y"):0,1:billQty)   //新版检查申请单全退时refQty标记为0
		set refAmt=patShareAmt
	}
	set billQty=$fn(billQty,"N")
	set refQty=$fn(refQty,"N")
	do OutputOrdItm
	quit
OutputOrdItm
    set Data=$lb(arcimDesc,patShareAmt,billQty,packUom,itmStat,prescNo,recDept,refQty,refAmt,auditFlag,disabled,select,cantRefReason,execInfo,ordSttDate,isAppRep,isCNMedItem,oeori,pboRowId,prtId)
    set ^CacheTemp(repid,ind)=Data
    set ind=$i(ind)
    quit
}

/// Creator: ZhYW
/// CreatDate: 2019-04-27
/// Description: 获取门诊发药数量
/// Input: oeitm:OE_OrdItem.RowId, prtRowId:DHC_INVPRT.RowId
/// Return: 
/// Debug: w ##class(web.DHCOPBillRefund).GetOutPHQty("1133||3", 7507860)
ClassMethod GetOutPHQty(oeitm As %String, prtRowId As %String) As %String
{
	set outPHQty=0
	set stayFlag=##class(web.UDHCJFBaseCommon).GetPrtInvStat(prtRowId)  //留观标识
	if (stayFlag="Y") {
		set dsp=0
		while ($o(^DHCOEDISQTY(0,"OEORI",oeitm,dsp))) {
			set dsp=$o(^DHCOEDISQTY(0,"OEORI",oeitm,dsp))
			set dspData=$g(^DHCOEDISQTY(dsp))
			set dspStatus=$p(dspData,"^",7)
			continue:(dspStatus'="C")
			set dspQty=$p(dspData,"^",11)
			set outPHQty=$i(outPHQty, dspQty)
		}
		quit outPHQty
	}
	
	set dispQtyInfo=##class(PHA.FACE.OUT.Com).GetOutQtyByOeori(oeitm)
	set outPHQty=$p(dispQtyInfo,"^",1)     //发药数量
	quit outPHQty
}

/// Creator: ZhYW
/// CreatDate: 2019-04-27
/// Description: 获取门诊退药数量
/// Input: oeitm:OE_OrdItem.RowId, prtRowId:DHC_INVPRT.RowId
/// Return: 
/// Debug: w ##class(web.DHCOPBillRefund).GetRetOrdQty("3482340||2", 7507860)
ClassMethod GetRetOrdQty(oeitm As %String, prtRowId As %String) As %String
{
	set retQty=0
	set stayFlag=##class(web.UDHCJFBaseCommon).GetPrtInvStat(prtRowId)  //留观标识
	if (stayFlag="Y") {
		set dsp=0
		while ($o(^DHCOEDISQTY(0,"OEORI",oeitm,dsp))) {
			set dsp=$o(^DHCOEDISQTY(0,"OEORI",oeitm,dsp))
			set dspData=$g(^DHCOEDISQTY(dsp))
			set dspStatus=$p(dspData,"^",7)
			continue:(dspStatus'="R")
			set dspQty=$p(dspData,"^",11)
			set retQty=$i(retQty, dspQty)
		}
		quit retQty
	}
	
	set retQty=##class(BILL.Interface.Inside.Invoke).GetRetOrdQty(oeitm, prtRowId)
	quit retQty
}

/// Creator: ZhYW
/// CreatDate: 2018-12-27
/// Description: 根据账单医嘱RowId和发票RowId取退药金额
/// Input: pboRowId:DHC_PatBillOrder.RowId, prtRowId:DHC_INVPRT.RowId
/// Return: 
/// Debug: w ##class(web.DHCOPBillRefund).GetPHRefundSum("21324||4","13848")
ClassMethod GetPHRefundSum(pboRowId As %String, prtRowId As %String) As %String
{
	set ^TMP("GetPHRefundSum")=$lb(pboRowId, prtRowId)
	set refundSum=0
	quit:($l("||")'=2) refundSum
	
	set pb=+$p(pboRowId,"||",1)
	set pbo=+$p(pboRowId,"||",2)
	
	set oeitm=$p($g(^DHCPB(pb,"O",pbo)),"^",4)
	set isOPIVAS=$p($g(^OEORD(+oeitm,"I",$p(oeitm,"||",2),"DHC")),"^",16)
	
	set pbd=0
	while($o(^DHCPB(pb,"O",pbo,"D",pbd))) {
		set pbd=$o(^DHCPB(pb,"O",pbo,"D",pbd))
		set pbdData=$g(^DHCPB(pb,"O",pbo,"D",pbd))
		continue:(pbdData="")
		set pbdQty=$p(pbdData,"^",5)
		set dspbId=$p(pbdData,"^",27)
		continue:(dspbId="")
		set price=$p(pbdData,"^",4)        //PBD_UnitPrice
		set patPrice=$p(pbdData,"^",20)    //PBD_PatPrice
		if (isOPIVAS="Y") {
			set refQty=##class(BILL.Interface.Inside.Invoke).GetDspbQtyForOPIVASReq(dspbId)
		}else {
			set refQty=##class(BILL.Interface.Inside.Invoke).GetPrtPhdRetQty(prtRowId, dspbId)
		}
		set refQty=refQty*(pbdQty/$zabs(pbdQty))
		set refundSum=$i(refundSum,(patPrice*refQty))
	}
	
	quit ##class(web.UDHCJFBILL).round(refundSum)
}

/// Creator: ZhYW
/// CreateDate: 2019-04-25
/// Description: 取发票的支付方式及金额，并返回多种支付方式标志
/// Input: 
/// Return: 
/// Debug: w ##class(web.DHCOPBillRefund).GetReceiptInfo("6625:PRT","17275")
ClassMethod GetReceiptInfo(invStr As %String, userId As %String) As %String
{
	set ^TMP("GetReceiptInfo")=$lb(invStr, userId)
	set jsonStr=""
	set invId=$p(invStr,":",1)
	set invType=$p(invStr,":",2)
	quit:((invId="")||(invType="")) jsonStr
	
	set invPaymDR=""    //自费支付方式
	set (papmi, totalAmt, patShareAmt, userDR)=""
	set (prtFlag, reportsDR, insTypeDR, roundErrAmt)=""
	set (stayInvFlag, insuDivDR, insuPayAmt)=""
	set (refBtnFlag, accMDR, accMLeft)=""
	set (autoFlag, writeOffFlag)=""
	
	if (invType="API") {
		quit:'$d(^DHCINVPRTAP(invId)) jsonStr
		&SQL(
			SELECT ROUND(API_Amount,2), API_Flag, API_INVRep_DR, API_AutoYBFlag, API_InsType_DR,
				   API_PAPMI_DR, ROUND(API_PatientShare,2), API_PUser_DR, API_InsDiv_DR, ROUND(API_SelfYBPay,2),
				   ROUND(API_OPCRoundSum,2), API_StayFlag
			INTO :totalAmt, :prtFlag, :reportsDR, :autoFlag, :insTypeDR,
				 :papmi, :patShareAmt, :userDR, :insuDivDR, :insuPayAmt,
				 :roundErrAmt, :stayInvFlag
			FROM DHC_AccPayINV
			WHERE %ID = :invId
		)
	 	set refBtnFlag=""
	    if ('$d(^DHCINVPRTAPi(0,"APIDR",invId))) {
			set refBtnFlag=$s(((userId=userDR)&&(+reportsDR=0)):"A",1:"S")   //作废还是红冲标识
		}
		set writeOffFlag=..CheckWriteOffAPI(invId)   //需撤销
		
		set paymSub=""
		while($o(^DHCINVPRTAP(invId,"P",paymSub),-1)&&(invPaymDR="")) {
			set paymSub=$o(^DHCINVPRTAP(invId,"P",paymSub),-1)
			set paymData=$g(^DHCINVPRTAP(invId,"P",paymSub))
	   		continue:(paymData="")
	   		set paymDR=$p(paymData,"^",1)
	   		set paymCode=$p($g(^CT("CTPM",paymDR)),"^",1)
	   		continue:((paymCode["YB")||(paymCode["INSU"))   //集中打印发票的先这么判断自费支付方式
	   		set invPaymDR=paymDR
		}
	    
		set accMDR=$p(^DHCINVPRTAP(invId),"^",12)        //API_AccMan_DR
		set accMLeft=$s((+accMDR'=0):$fn($p(^DHCACD("AccM",accMDR),"^",8),"",2),1:"")
	}else {
		quit:'$d(^DHCINVPRT(invId)) jsonStr
		&SQL(
			SELECT ROUND(PRT_Acount,2), PRT_Flag, PRT_DHCINVPRTR_DR, PRT_InsType_DR, PRT_PAPMI_DR,
				   ROUND(PRT_PatientShare,2), PRT_Usr, PRT_InsDiv_DR, ROUND(PRT_YBPaySum,2), ROUND(PRT_OPCRoundErr,2),
				   PRT_StayFlag
			INTO :totalAmt, :prtFlag, :reportsDR, :insTypeDR, :papmi,
				 :patShareAmt, :userDR, :insuDivDR, :insuPayAmt, :roundErrAmt,
				 :stayInvFlag
			FROM DHC_INVPRT
			WHERE %ID = :invId
		)
	    set refBtnFlag=""
	    if ('$d(^DHCINVPRT(0,"InitInvDR",invId))) {
			set refBtnFlag=$s(((userId=userDR)&&(+reportsDR=0)):"A",1:"S")   //作废还是红冲标识
		}
	  	set refBtnFlag=$s(((userId=userDR)&&(+reportsDR=0)):"A",1:"S")   //作废还是红冲标识
	    
	    set accPLDR=""
	    set paymSub=""
	    while($o(^DHCINVPRT(invId,"P",paymSub),-1)&&(accPLDR="")) {
		    set paymSub=$o(^DHCINVPRT(invId,"P",paymSub),-1)
		    set paymData=$g(^DHCINVPRT(invId,"P",paymSub))
	   		continue:(paymData="")
	   		set paymDR=$p(paymData,"^",1)
	   		set paymNote=$p(paymData,"^",12)
	   		continue:(+paymNote'=1)      //IPM_Note3记录为1时为自费支付方式
	   		if (invPaymDR="") {
	    		set invPaymDR=paymDR
	    	}
	    	set myAccPLDR=$p(paymData,"^",8)      //IPM_AccPL_DR
	    	if (myAccPLDR'="") {
		    	set accPLDR=myAccPLDR
		    }
		}
	    set accMDR=$s((+accPLDR'=0):+accPLDR,1:"")
	    set accMLeft=$s((+accMDR'=0):$fn($p(^DHCACD("AccM",accMDR),"^",8),"",2),1:"")
	}
	
	set obj={}
	set obj.patientId=papmi
	set obj.totalAmt=totalAmt
	set obj.patShareAmt=patShareAmt
	set obj.userId=userDR
	set obj.prtFlag=prtFlag
	set obj.reportsId=reportsDR
	set obj.insTypeId=insTypeDR
	set obj.roundErrAmt=roundErrAmt
	set obj.stayInvFlag=stayInvFlag
	set obj.invPaymDR=invPaymDR
	set obj.insuDivId=insuDivDR
	set obj.insuPayAmt=insuPayAmt
	set obj.refBtnFlag=refBtnFlag
	set obj.accMRowId=accMDR
	set obj.accMLeft=accMLeft
	set obj.autoFlag=autoFlag
	set obj.writeOffFlag=writeOffFlag
    quit obj.%ToJSON()
}

/// Creator: ZhYW
/// CreatDate: 2019-05-09
/// Description: 判断集中打印发票退费是否能在普通门诊退费界面退费
///              1. 集中打印发票时医保分解的不能在普通门诊退费界面退费
///              2. 集中打印发票:小条 = 1:n 不能在普通门诊退费界面退费
/// Input: accPInvId: DHC_AccPayINV.RowId
/// Return: "N":否, "Y":是
/// Debug: w ##class(web.DHCOPBillRefund).APIINVIsAllowRefAtPRTRefPage(1017)
ClassMethod APIINVIsAllowRefAtPRTRefPage(accPInvId As %String) As %String
{
	set rtn="Y"
	
	set accInsuDivDR=$p($g(^DHCINVPRTAP(accPInvId)),"^",19)
	set autoFlag=$p(^DHCINVPRTAP(accPInvId),"^",25)         //API_AutoYBFlag
	if ((+accInsuDivDR'=0)&&(+autoFlag=0)) {
		quit "N"                  //1
	}

	if ($o(^DHCINVPRTCAPi(0,"APINVDR",accPInvId,0))'=$o(^DHCINVPRTCAPi(0,"APINVDR",accPInvId,""),-1)) {
		quit "N"                  //2
	}
		
	quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2017-05-27
/// Description: 判断集中打印发票退费是否需要先撤销集中打印发票
///             1. 门诊收费实时医保结算时, 未将医保结算的DHC_INVPRT.PRT_InsDiv_DR更新到DHC_AccPayINV.API_InsDiv_DR时,需要先撤销再退费
///             2. 非卡支付集中打印发票时, 需要先撤销再退费
/// Input: accPInvId: DHC_AccPayINV.RowId
/// Return: flag(="N" 不需要撤销, ="Y"需要撤销)
/// Table: DHC_AccPayINV, DHC_AccPayINVMode
/// Debug: w ##class(web.DHCOPBillRefund).CheckWriteOffAPI(21865)
ClassMethod CheckWriteOffAPI(accPInvId As %String) As %String
{
	set rtn="N"
	quit:((+accPInvId=0)||('$d(^DHCINVPRTAP(accPInvId)))) rtn
		
	set accInsuDivDR=$p($g(^DHCINVPRTAP(accPInvId)),"^",19)
	set autoFlag=$p($g(^DHCINVPRTAP(accPInvId)),"^",25)      //API_AutoYBFlag
	quit:((+accInsuDivDR'=0)&&(+autoFlag=1)) "Y"
	
	set apiConDR=0
	for  set apiConDR=$o(^DHCINVPRTCAPi(0,"APINVDR",accPInvId,apiConDR))  quit:((apiConDR="")||(rtn="Y"))  do
	.set prtRowId=$p($g(^DHCINVPRTCAP(apiConDR)),"^",1)
	.quit:((+prtRowId=0)||('$d(^DHCINVPRT(prtRowId))))
	.set insuDivDR=$p(^DHCINVPRT(prtRowId),"^",30)
	.set isPrtInsuDiv="N"
	.if ((+insuDivDR'=0)&&(+accInsuDivDR=0)) do    //未将医保实时结算的DHC_INVPRT.PRT_InsDiv_DR更新到DHC_AccPayINV.API_InsDiv_DR时,需要先撤销再退费
	..set isPrtInsuDiv="Y"
	.set isCardPay="N"
	.set prtPaymSub=""
	.for  set prtPaymSub=$o(^DHCINVPRT(prtRowId,"P",prtPaymSub),-1)  quit:((prtPaymSub="")||(isCardPay="Y"))  do
	..set paymInfo=$g(^DHCINVPRT(prtRowId,"P",prtPaymSub))
	..quit:(paymInfo="")
	..set selfPaymFlag=$p(paymInfo,"^",12)   //IPM_Note3
	..quit:(+selfPaymFlag=0)                 //过滤医保支付的
	..set myAccPLDR=$p(paymInfo,"^",8)
	..if (myAccPLDR'="") do
	...set isCardPay="Y"
	.if ((isPrtInsuDiv="Y")&&(isCardPay="N")) do
	..set rtn="Y"
	
	quit rtn
}

/// Creator: ZhYW
/// CreateDate: 2019-04-25
/// Description: 取发票的支付方式及金额，并返回多种支付方式标志
/// Input: 
/// Return: 
/// Debug: w ##class(web.DHCOPBillRefund).GetInvPayModeList("234226:PRT")
ClassMethod GetInvPayModeList(invStr As %String, langId As %String = "") As %String
{
	set ^TMP("GetInvPayModeList")=$lb(invStr, langId)
	
	if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
	set invId=$p(invStr,":",1)
	set invType=$p(invStr,":",2)
	quit:((invId="")||(invType="")) ""
	
	kill paymAry
	if (invType="API") {
		set paymSub=0
		while($o(^DHCINVPRTAP(invId,"P",paymSub))) {
			set paymSub=$o(^DHCINVPRTAP(invId,"P",paymSub))
			set paymSubData=$g(^DHCINVPRTAP(invId,"P",paymSub))
  			continue:(paymSubData="")
  			set paymDR=$p(paymSubData,"^",1)
			continue:(+paymDR=0)
			set paymCode=$p(^CT("CTPM",paymDR),"^",1)
			set paymAmt=$p(paymSubData,"^",3)
			set selfPayFlag=$s(((paymCode'["YB")&&(paymCode'["INSU")):1, 1:0)   //集中打印发票的先这么判断自费支付
			set $li(paymAry(paymDR),1)=$lg($g(paymAry(paymDR)),1)+paymAmt
			set $li(paymAry(paymDR),2)=selfPayFlag
		}
	}else {
	    set paymSub=0
	    while($o(^DHCINVPRT(invId,"P",paymSub))) {
		    set paymSub=$o(^DHCINVPRT(invId,"P",paymSub))
		    set paymSubData=$g(^DHCINVPRT(invId,"P",paymSub))
	  		continue:(paymSubData="")
	   		set paymDR=$p(paymSubData,"^",1)
	   		continue:(+paymDR=0)
	  		set paymAmt=$p(paymSubData,"^",3)
	   		set paymNote=$p(paymSubData,"^",12)   //IPM_Note3记录为1时为非医保支付方式
	   		set selfPayFlag=paymNote
	  		set $li(paymAry(paymDR),1)=$lg($g(paymAry(paymDR)),1)+paymAmt
	   		set $li(paymAry(paymDR),2)=selfPayFlag
		}
	}
	
	set selfPaymNum=0
	set paymList=""
	set paymDR=0
	while($o(paymAry(paymDR))) {
		set paymDR=$o(paymAry(paymDR))
		set paymData=$g(paymAry(paymDR))
		set paymAmt=$lg(paymData,1)
		set paymAmt=$fn(paymAmt,"",2)
		set selfPayFlag=$lg(paymData,2)
		if (+selfPayFlag=1) {
			set selfPaymNum=$i(selfPaymNum)
		}
		set paymDesc=$p(^CT("CTPM",paymDR),"^",2)
		set paymDesc=##class(User.CTPayMode).GetTranByDesc("CTPMDesc", paymDesc, langId)
		set tmpStr=paymDesc_$c(2)_paymAmt
		set paymList=$s((paymList=""):tmpStr,1:(paymList_"^"_tmpStr))
	}
	
	//selfPaymNum>1时为多种支付方式
    set rtn=selfPaymNum_"#"_paymList
    
    quit rtn
}

/// Creator: ZhYW
/// CreateDate: 2021-04-21
/// Description: 判断发票退费时退费数量是否大于收费数量
/// Input: prtRowId: DHC_INVPRT.RowId
/// Return: 
/// Debug: w ##class(web.DHCOPBillRefund).IsValidRefQty(12842)
ClassMethod IsValidRefQty(prtRowId As %String) As %String
{
	set rtn=0
    quit:(+prtRowId=0) 0
    
    set billConInvDR=0
    while($o(^DHCBCI(0,"INV",prtRowId,billConInvDR))&&(rtn=0)) {
	    set billConInvDR=$o(^DHCBCI(0,"INV",prtRowId,billConInvDR))
	    set pb=$p($g(^DHCBCI(billConInvDR)),"^",2)
	    set pbo=0
	    while($o(^DHCPB(pb,"O",pbo))&&(rtn=0)) {
		    set pbo=$o(^DHCPB(pb,"O",pbo))
		    set pboData=$g(^DHCPB(pb,"O",pbo))
			continue:(pboData="")
			set oeitm=$p(pboData,"^",4)
			set pboBillQty=$p(pboData,"^",5)       //PBO_BillQty
			set pboRefQty=$p(pboData,"^",6)        //PBO_RefundQty
			set pboQty=pboBillQty+pboRefQty
 			set ordCateType=##class(web.UDHCJFBaseCommon).GetOrdCateType(oeitm, 1)
 			if (ordCateType="R") {
	 			//药品  				
   				set isOPIVAS=$p($g(^OEORD(+oeitm,"I",$p(oeitm,"||",2),"DHC")),"^",16)
   				if (isOPIVAS="Y") {
	   				//静脉配液
	   				set effectiveQty=##class(BILL.Interface.Inside.Invoke).GetEffectiveQtyForOPIVAS(oeitm)
    				if (pboQty<effectiveQty) {     //静脉配液控制计费数量不能小于有效数量
	    				set rtn=1
	    			}
	    			continue
	   			}
	   			set retQty=##class(BILL.Interface.Inside.Invoke).GetRetOrdQty(oeitm, prtRowId)
				if (retQty>pboQty) {
				 	set rtn=1
				}
				continue
	 		}
	 		
	 		//非药品
	 		set refQtyInfo=##class(web.DHCOPBillOERefundQty).GetRefundQTY(oeitm, "")
			set retQty=+$p(refQtyInfo,"^",2)
		 	if (retQty>pboQty) {
			 	set rtn=1
			}
			continue
		}
	}
    
    quit rtn
}

/// Description: 根据医嘱rowid获取退费金额(新版检查申请单)
///  规则：
/// 		1.判断是否走折扣
/// 		2.如果没有走折扣, 直接取退费部位的价格
/// 		3.如果走折扣，需按中间表的折扣从小到大取退费金额（第一个退费部位的价格乘最后一个系数，第二个退费部位的价格乘倒数第二个折扣系数...依次递推）
/// 		4.部位加收医嘱的计算规则:部位退费时部位加收必须退费（部位加收一定不能有折扣）
/// 		5.后处理医嘱的计算规则：后处理医嘱只能与最后一个部位一起退费，即如果有部位没有退费，它就不能退费.
/// Debug: w ##class(web.DHCOPBillRefund).GetRepPartRefAmt("8054||5","15356||1","")
ClassMethod GetRepPartRefAmt(oeitm As %String, pbo As %String, arReqItmIdStr As %String = "") As %String
{
	set ^TMP("GetRepPartRefAmt")=$lb(oeitm, pbo, arReqItmIdStr)
	set (price, discPrice, insPrice, patPrice)=0
	set adm=$p(^OEORD(+oeitm),"^",1)
	set patType=$p($g(^PAADM(adm,1)),"^",6)
	set insType=$p($g(^DHCPB(+pbo)),"^",4)
	set arcim=$p(^OEORD(+oeitm,"I",$p(oeitm,"||",2),1),"^",2)
	set priceDate=$p($g(^OEORD(+oeitm,"I",$p(oeitm,"||",2),9)),"^",15)      //OEORI_BillPriceDate
	set oeprice=""
	//取Adm保存的挂号优惠类别
	set RCDRowID=$p($g(^PAADM(adm,"DHC")),"^",25)
    set HospID=##class(web.UDHCHospitalGroup).GetHospitalByAdm(adm)
	set regLoc=""
	set itmPriceExpStr=RCDRowID_"^"_oeitm_"^"_""_"^"_adm_"^"_regLoc_"^"_""
	
	if (arReqItmIdStr="") {
		set repItmIdStr=##class(web.DHCAPPInterface).GetReqEPTRAStr(oeitm)   //获取已申请中间表id串
	}else {
		set repItmIdStr=##class(web.DHCAPPInterface).GetEPTRAStr(oeitm, arReqItmIdStr)
	}
	
	set index=0
	
	set ordQty=$p($g(^OEORD(+oeitm,"I",$p(oeitm,"||",2),1)),"^",12)
	//是否走折扣
	set isDiscRtn=..IsBillByDisc(oeitm, pbo)
	set isDisc=$p(isDiscRtn,"!",1)
	set discStr=$p(isDiscRtn,"!",2)
	for i=1:1:$l(repItmIdStr,"!!") {
		set repItmId=$p(repItmIdStr,"!!",i)
		continue:(+repItmId=0)
		set repItmData=$g(^DHCAPREPTA(repItmId))
		continue:(repItmData="")
		set pointer=$p(repItmData,"^",1)	   //ARTI_Pointer
		set disc=$p(repItmData,"^",4)	       //ARTI_Disc
		set itm=$p(repItmData,"^",5)	       //ARTI_Tar_Dr
		set qty=$p(repItmData,"^",8)	       //ARTI_Qty
		set billStatus=$p(repItmData,"^",9)    //ARTI_Billed
		continue:(billStatus'="P")
		set pboDR=$p(repItmData,"^",12)
		continue:(pboDR'=pbo)
		set err=##class(web.UDHCJFPRICE).GetItmPrice(itm, priceDate, insType, patType, oeprice, HospID, itmPriceExpStr)
		if ((isDisc'=0)&&(pointer'="")) {
			//判断医嘱项目是否走折扣
			set isBascPriceFlag=..IsBascPrice(arcim, itm, priceDate)
			if (isBascPriceFlag=1) {
				set factDisc=$p(discStr,"^",$i(index))	  //第一个退费部位的价格乘最后一个系数，第二个退费部位的价格乘倒数第二个折扣系数...依次递推
				set disc=factDisc
			}
		}
		set err0=($p(err,"^",1)*disc)_"^"_($p(err,"^",2)*disc)_"^"_($p(err,"^",3)*disc)_"^"_($p(err,"^",4)*disc)
		set price=$p(err0,"^",1)*qty*ordQty+price
		set discPrice=$p(err0,"^",2)*qty*ordQty+discPrice
		set insPrice=$p(err0,"^",3)*qty*ordQty+insPrice
		set patPrice=$p(err0,"^",4)*qty*ordQty+patPrice
	}
	
	set refAmt=$fn(patPrice,"",2)
	
	quit refAmt
}

/// Description: 验证医嘱项对应得收费项目是否打折
/// Return: 0:不打折，1：打折
/// Debug: w ##class(web.DHCOPBillRefund).IsBascPrice("14560||1",5648,"2017-04-01")
ClassMethod IsBascPrice(arcim As %String, itm As %String, stDate As %String)
{
	set isBasePrice=0
	set execDate=""
	while(($o(^DHCOLT(0,"ARTTA",arcim,itm,execDate))'="")&&(isBasePrice=0)) {
		set execDate=$o(^DHCOLT(0,"ARTTA",arcim,itm,execDate))
		continue:(execDate>stDate)
		set oltDR=0
		while($o(^DHCOLT(0,"ARTTA",arcim,itm,execDate,oltDR))&&(isBasePrice=0)) {
			set oltDR=$o(^DHCOLT(0,"ARTTA",arcim,itm,execDate,oltDR))
			set oltData=^DHCOLT(oltDR)
			set endDate=$p(oltData,"^",5)
			continue:((endDate'="")&&(endDate<stDate))
			set bascPriceFlag=$p(oltData,"^",8)
			set isBasePrice=(bascPriceFlag="Y")
		}
	}
	
	quit isBasePrice
}

/// Description: 验证是否走折扣
/// 0_$c(2)_"":没有走折扣
/// 1_$c(2)_0.3^0.8^1:走折扣
/// Debug: w ##class(web.DHCOPBillRefund).IsBillByDisc("1785||11","2428||2")
ClassMethod IsBillByDisc(oeitm As %String, pbo As %String) As %String
{
	kill discAry
	set index=0
	
	set itmDR=0
	while($o(^DHCAPREPTA(0,"OrdTar",oeitm,itmDR))) {
		set itmDR=$o(^DHCAPREPTA(0,"OrdTar",oeitm,itmDR))
		set artiDR=0
		while($o(^DHCAPREPTA(0,"OrdTar",oeitm,itmDR,artiDR))) {
			set artiDR=$o(^DHCAPREPTA(0,"OrdTar",oeitm,itmDR,artiDR))
			set artiData=$g(^DHCAPREPTA(artiDR))
			set type=$p(artiData,"^",3)	      //ARTI_Type
			continue:(type'="P")
			set disc=$p(artiData,"^",4)
			set billStatus=$p(artiData,"^",9)   //账单状态
			continue:(billStatus'="P")
			set pboDR=$p(artiData,"^",12)
			continue:(pbo'=pboDR)
			set partFlag=$p(artiData,"^",14)
			continue:(partFlag'=1)         //1：部位医嘱，其他：非部位医嘱
			set discAry(disc,$i(index))=""
		}
	}
	
	set discStr="", discFlag=0
	set disc=""
	while($o(discAry(disc))'="") {
		set disc=$o(discAry(disc))
		set index=0
		while($o(discAry(disc,index))) {
			set index=$o(discAry(disc,index))
			if ((+disc'=1)&&(discFlag=0)) {
				set discFlag=1
			}
			set discStr=$s((discStr=""):disc,1:(discStr_"^"_disc))
		}
	}
	
	quit discFlag_"!"_discStr
}

/// Description: 验证是否全部退费
/// Return: 0:全部或未退，1:部分退, 空:非新版申请单医嘱
/// Debug: w ##class(web.DHCOPBillRefund).IsAllRefundRepPart("8054||5")
ClassMethod IsAllRefundRepPart(oeitm As %String) As %String
{
	set isAppRep=##class(web.UDHCJFPRICE).IsAppRepOrder(oeitm)
	quit:(isAppRep'="Y") ""
	
	set partRefStr=##class(web.DHCAPPInterface).GetReqBillPartID(oeitm)
	set partRefFlag=$p(partRefStr,$c(1),1)
	
	quit partRefFlag
}

/// Description: 判断医嘱的执行状态
/// Return: 0:部分执行或未执行，1:全部执行
/// Debug: w ##class(web.DHCOPBillRefund).IsPartExecut("8054||5")
ClassMethod IsPartExecut(oeitm As %String) As %String
{
	set flag=-1
	set exec=0
	while($o(^OEORD(+oeitm,"I",$p(oeitm,"||",2),"X",exec))) {
		set exec=$o(^OEORD(+oeitm,"I",$p(oeitm,"||",2),"X",exec))
		set statDR=$p($g(^OEORD(+oeitm,"I",$p(oeitm,"||",2),"X",exec)),"^",16)		//OE_OrdExec.OEORE_Order_Status_DR
		set statCode=$s((+statDR'=0):$p(^OEC("STAT",statDR),"^",1),1:"")
		set flag=(statCode="F")
		quit:(flag=0)
	}
	
	if (flag=-1) set flag=0
	
	quit flag
}

/// Return: -1:无执行记录,0:全部未执行,1:部分执行,2:全部执行
/// Debug: w ##class(web.DHCOPBillRefund).IsPartExecut2("1217||3")
ClassMethod IsPartExecut2(oeitm As %String) As %String
{
	set isAppRep=##class(web.UDHCJFPRICE).IsAppRepOrder(oeitm)
	quit:(isAppRep="Y") ..IsAppRepPartExecut(oeitm)
	
	set flag=-1
	set execFalg=0
	set noExecFlag=0
	set exec=0
	while($o(^OEORD(+oeitm,"I",$p(oeitm,"||",2),"X",exec))) {
		set exec=$o(^OEORD(+oeitm,"I",$p(oeitm,"||",2),"X",exec))
		set statDR=$p($g(^OEORD(+oeitm,"I",$p(oeitm,"||",2),"X",exec)),"^",16)		//OE_OrdExec.OEORE_Order_Status_DR
		set statCode=$s((+statDR'=0):$p(^OEC("STAT",statDR),"^",1),1:"")
		if (statCode="F") {
			set execFalg=1
		}else {
			set noExecFlag=1
		}
	}
	
	if (execFalg=0)&&(noExecFlag=1)	set flag=0	   //全部未执行
	if (execFalg=1)&&(noExecFlag=1) set flag=1	   //部分执行
	if (execFalg=1)&&(noExecFlag=0) set flag=2	   //全部执行
	
	quit flag
}

/// Creator: ZhYW
/// CreatDate: 2017-09-08
/// Description: 更新检查申请部位表退费申请状态
/// Input: OE_OrdItem.RowID, arReqItmIdStr: DHC_AppRepPart.RowID
/// Return: 0:"更新成功", <>0:"更新失败"
/// Debug: w ##class(web.udhcOPRefund).UpdateExaReqFlag("653||2", "")
ClassMethod UpdateExaReqFlag(oeitm As %String, arReqItmIdStr As %String) As %String
{
	set $zt="ERROR"
	set rtn=0
	quit:(oeitm="") rtn
	set arReqID=$o(^DHCAPREP(0,"OrdItem",oeitm,""))         // 检查申请ID
	quit:(arReqID="") rtn
	set sub=$o(^DHCAPREP(0,"OrdItem",oeitm,arReqID,""))     // 检查申请医嘱项Child
	quit:(sub="") rtn
	
	set upd2NArReqItmIdStr=""
	set child=0
	while($o(^DHCAPREP(arReqID,"AR",sub,"PA",child))) {
		set child=$o(^DHCAPREP(arReqID,"AR",sub,"PA",child))
		set arReqItmId=arReqID_"||"_sub_"||"_child
		set exeStatus=$p(^DHCAPREP(arReqID,"AR",sub,"PA",child),"^",2)
		continue:(exeStatus="D")
		set reqFlag=$p(^DHCAPREP(arReqID,"AR",sub,"PA",child),"^",6)    // 退费申请
		continue:(reqFlag'="Y")
		if (("!!"_arReqItmIdStr_"!!") '[ ("!!"_arReqItmId_"!!")) {
			set upd2NArReqItmIdStr=$s((upd2NArReqItmIdStr=""):arReqItmId,1:(upd2NArReqItmIdStr_"!!"_arReqItmId))
		}
	}

	ts
	
	if (arReqItmIdStr'="") {
		set rtn=##class(web.DHCAPPInterface).SetExaReqFlag(oeitm, arReqItmIdStr, "Y")
		if (+rtn) tro  quit rtn
	}
	if (upd2NArReqItmIdStr'="") {
		set rtn=##class(web.DHCAPPInterface).SetExaReqFlag(oeitm, upd2NArReqItmIdStr, "N")
		if (+rtn) tro  quit rtn
	}
	
	if ($tl>0) tc
	
	quit rtn

ERROR
	quit ..AppException()
}

/// Creator: ZhYW
/// CreatDate: 2019-01-15
/// Description: 新版检查申请单执行状态
/// Input: oeitm:OE_OrdItem.RowId
/// Table: DHC_AppRepTarItm
/// Return: -1:非新版检查申请单或无执行记录, 0:全部未执行, 1:部分执行, 2:全部执行
/// Debug: w ##class(web.DHCOPBillRefund).IsAppRepPartExecut("357||5")
ClassMethod IsAppRepPartExecut(oeitm As %String) As %String
{
	set flag=-1
	set isAppRep=##class(web.UDHCJFPRICE).IsAppRepOrder(oeitm)
	quit:(isAppRep'="Y") flag
	
	set execFalg=0
	set noExecFlag=0
	
	set itmDR=0
	while($o(^DHCAPREPTA(0,"OrdTar",oeitm,itmDR))) {
		set itmDR=$o(^DHCAPREPTA(0,"OrdTar",oeitm,itmDR))
		set artiDR=0
		while($o(^DHCAPREPTA(0,"OrdTar",oeitm,itmDR,artiDR))) {
			set artiDR=$o(^DHCAPREPTA(0,"OrdTar",oeitm,itmDR,artiDR))
			set artiData=$g(^DHCAPREPTA(artiDR))
			continue:(artiData="")
			set billed=$p(artiData,"^",9)         //ARTI_Billed
			continue:(billed'="P")           
			set oeore=$p(artiData,"^",10)	     //ARTI_OrdExec
			set statDR=$p($g(^OEORD(+oeore,"I",$p(oeore,"||",2),"X",oeore)),"^",16)		//OE_OrdExec.OEORE_Order_Status_DR
			set statCode=$s((+statDR'=0):$p(^OEC("STAT",statDR),"^",1),1:"")
			if (statCode="F") {
				set execFalg=1
			}else {
				set noExecFlag=1
			}
		}
	}
	
	if ((execFalg=0)&&(noExecFlag=1)) set flag=0	//全部未执行
	if ((execFalg=1)&&(noExecFlag=1)) set flag=1	//部分执行
	if ((execFalg=1)&&(noExecFlag=0)) set flag=2	//全部执行
	
	quit flag
}

/// Creator: ZhYW
/// CreatDate: 2019-12-23
/// Description: 根据医嘱和发票取物资材料已退数量(发放模式下)
/// Input: oeori:OE_OrdItem.RowId, prtId:DHC_INVPRT.RowId
/// Return: 已退数量
/// Debug: w ##class(web.DHCOPBillRefund).GetMatRetQty("329||3", 367)
ClassMethod GetMatRetQty(oeori As %String, prtId As %String) As %String
{
	set refQty=0
   	set rqId=0
   	while($o(^DHCOERefundQTY(0,"OEORI",oeori,rqId))) {
	   	set rqId=$o(^DHCOERefundQTY(0,"OEORI",oeori,rqId))
	   	set rqData=$g(^DHCOERefundQTY(rqId))
		continue:(rqData="")
		set refundQty=$p(rqData,"^",3)
		set status=$p(rqData,"^",4)
		set myPrtId=$p(rqData,"^",9)       //OERQ_PRTInv_DR
		continue:((prtId'="")&&(prtId'=myPrtId))
		set actRefFlag=$p(rqData,"^",10)   //OERQ_ActRefFlag
		continue:(actRefFlag'="Y")
		set refQty=$i(refQty, refundQty)
	}
	
   	quit refQty
}

/// Creator: ZhYW
/// CreatDate: 2020-09-10
/// Description: 获取病人退费金额信息
/// Input: 
/// Return: 
/// Debug: w ##class(web.DHCOPBillRefund).GetRefundInfo("201:API")
ClassMethod GetRefundInfo(invStr As %String) As %String
{
	set invId=$p(invStr,":",1)
	set invType=$p(invStr,":",2)
	
	kill paymAry
	if (invType="API") {
		set rtnValue=$$GetAccPayInv(invId)
	}else {
		set rtnValue=$$GetPrtRowId(invId)
	}
	set rtn=$p(rtnValue,"^",1)
	set refPatSum=$p(rtnValue,"^",2)
	set refSelfSum=$p(rtnValue,"^",3)
	
	set refmodeStr=""
	set paymId=0
	while($o(paymAry(paymId))) {
		set paymId=$o(paymAry(paymId))
		set paymAmt=$g(paymAry(paymId))
		continue:(+paymAmt=0)
		set paymDesc=$p($g(^CT("CTPM",paymId)),"^",2)
		set flag=$s((+paymAmt>0):"收",1:"退")
		set myStr=flag_paymDesc_"："_$fn($zabs(paymAmt),"",2)
		set refmodeStr=$s((refmodeStr=""):myStr,1:(refmodeStr_","_myStr))
	}
	set jsonObj={}
	set jsonObj.code=rtn
	set jsonObj.refPatSum=refPatSum
	set jsonObj.refSelfSum=refSelfSum
	set jsonObj.refmodeStr=refmodeStr
	quit jsonObj.%ToJSON()
	
GetAccPayInv(prtRowId) 
	//负票
	set striRowId=$o(^DHCINVPRTAPi(0,"APIDR",prtRowId,0))
	quit:(+striRowId=0) -1
	set striPatSum=$p($g(^DHCINVPRTAP(striRowId)),"^",13)       //自付金额
	set striSelfPatSum=$p($g(^DHCINVPRTAP(striRowId)),"^",16)   //自费退费额
	set striYBSum=$p($g(^DHCINVPRTAP(striRowId)),"^",17)        //医保支付金额
	
	set paymSub=0
	while($o(^DHCINVPRTAP(striRowId,"P",paymSub))) {
		set paymSub=$o(^DHCINVPRTAP(striRowId,"P",paymSub))
		set subData=$g(^DHCINVPRTAP(striRowId,"P",paymSub))
		set paymDR=$p(subData,"^",1)
		set paymAmt=$p(subData,"^",3)
		set paymAry(paymDR)=$i(paymAry(paymDR), paymAmt)
	}
	
	//新发票
	set newPatSum=0
	set newSelfPatSum=0
    set newRowId=$o(^DHCINVPRTAPi(0,"OldADR",prtRowId,0))
    if (+newRowId'=0) {
	    set newPatSum=$p($g(^DHCINVPRTAP(newRowId)),"^",13)       //自付金额
		set newSelfPatSum=$p($g(^DHCINVPRTAP(newRowId)),"^",16)   //自费退费额
		set newYBSum=$p($g(^DHCINVPRTAP(newRowId)),"^",17)
		
		set paymSub=0
		while($o(^DHCINVPRTAP(newRowId,"P",paymSub))) {
			set paymSub=$o(^DHCINVPRTAP(newRowId,"P",paymSub))
			set subData=$g(^DHCINVPRTAP(newRowId,"P",paymSub))
			set paymDR=$p(subData,"^",1)
			set paymAmt=$p(subData,"^",3)
			set paymAry(paymDR)=$i(paymAry(paymDR), paymAmt)
		}
	}
	
	set refPatSum=striPatSum+newPatSum
	set refPatSum=$fn($zabs(refPatSum),"",2)
	set refSelfSum=striSelfPatSum+newSelfPatSum
	set refSelfSum=$fn($zabs(refSelfSum),"",2)

	quit 0_"^"_refPatSum_"^"_refSelfSum
	
GetPrtRowId(prtRowId)
	//负票
	set striRowId=$o(^DHCINVPRT(0,"InitInvDR",prtRowId,0))
	quit:(+striRowId=0) -1
	set striPatSum=$p($g(^DHCINVPRT(striRowId)),"^",16)   //自付金额
	set striYBSum=$p($g(^DHCINVPRT(striRowId)),"^",31)    //医保支付金额
	set striSelfPatSum=striPatSum-striYBSum   //自费退费额
	
	set paymSub=0
	while($o(^DHCINVPRT(striRowId,"P",paymSub))) {
		set paymSub=$o(^DHCINVPRT(striRowId,"P",paymSub))
		set subData=$g(^DHCINVPRT(striRowId,"P",paymSub))
		set paymDR=$p(subData,"^",1)
		set paymAmt=$p(subData,"^",3)
		set paymAry(paymDR)=$i(paymAry(paymDR), paymAmt)
	}

    //新发票
    set newPatSum=0
    set newSelfPatSum=0
    set newRowId=$o(^DHCINVPRT(0,"OldINV",prtRowId,0))
    if (+newRowId'=0) {
		set newPatSum=$p($g(^DHCINVPRT(newRowId)),"^",16)    //自付金额
		set newYBSum=$p($g(^DHCINVPRT(newRowId)),"^",31)     //医保支付金额
		set newSelfPatSum=newPatSum-newYBSum     //自费收费额
		
		set paymSub=0
		while($o(^DHCINVPRT(newRowId,"P",paymSub))) {
			set paymSub=$o(^DHCINVPRT(newRowId,"P",paymSub))
			set subData=$g(^DHCINVPRT(newRowId,"P",paymSub))
			set paymDR=$p(subData,"^",1)
			set paymAmt=$p(subData,"^",3)
			set paymAry(paymDR)=$i(paymAry(paymDR), paymAmt)
		}
	}
	set refPatSum=striPatSum+newPatSum
	set refPatSum=$fn($zabs(refPatSum),"",2)
    set refSelfSum=striSelfPatSum+newSelfPatSum
	set refSelfSum=$fn($zabs(refSelfSum),"",2)
    
    quit 0_"^"_refPatSum_"^"_refSelfSum
}

/// Creator: ZhYW
/// CreatDate: 2020-12-10
/// Description: 判断部分退费，患者支付是否大于退款金额
/// Input: striRowId:负票RowId, payInfo:重收的支付方式信息
/// Return: 0:否, 1:是
/// Others: 切换支付方式重收或医保转自费，部分退费可能会重收
/// Debug: w ##class(web.DHCOPBillRefund).IsNeedPayAftRef("11436","2^^^^^^^202^^^")
ClassMethod IsNeedPayAftRef(striRowId As %String, payInfo As %String) As %String
{
	set rtn=0
	quit:(+striRowId=0) rtn
		
	set striData=$g(^DHCINVPRT(striRowId))
	set hospId=$p(striData,"^",39)
	set initInvDR=$p(striData,"^",13)
	quit:(+initInvDR=0) rtn
	
	kill initPMAry
	//原票
	set paymSub=""
	while($o(^DHCINVPRT(initInvDR,"P",paymSub),-1)) {
		set paymSub=$o(^DHCINVPRT(initInvDR,"P",paymSub),-1)
		set subData=$g(^DHCINVPRT(initInvDR,"P",paymSub))
		continue:(subData="")
		set paymDR=$p(subData,"^",1)
		set isSelf=$p(subData,"^",12)
		continue:(+isSelf'=1)     //过滤医保支付方式
		set paymAmt=$p(subData,"^",3)
		continue:(+paymAmt=0)
		set initPMAry(paymDR)=$g(initPMAry(paymDR))+paymAmt    //原支付金额
	}
	
	kill paymAry
	//负票
	set paymSub=""
	while($o(^DHCINVPRT(striRowId,"P",paymSub),-1)) {
		set paymSub=$o(^DHCINVPRT(striRowId,"P",paymSub),-1)
		set subData=$g(^DHCINVPRT(striRowId,"P",paymSub))
		continue:(subData="")
		set paymDR=$p(subData,"^",1)
		set isSelf=$p(subData,"^",12)
		continue:(+isSelf'=1)     //过滤医保支付方式
		set paymAmt=$p(subData,"^",3)
		continue:(+paymAmt=0)
		set paymAry(paymDR)=$g(paymAry(paymDR))+paymAmt    //退费金额
	}
	
	for i=1:1:$l(payInfo,$c(2)) {
		set tmpInfo=$p(payInfo,$c(2),i)
		continue:(tmpInfo="")
		set paymDR=$p(tmpInfo,"^",1)
		set paymAmt=$p(tmpInfo,"^",8)
		continue:(+paymAmt=0)
		set paymAry(paymDR)=$g(paymAry(paymDR))+paymAmt    //收费金额
	}
	
	set paymDR=0
	while($o(paymAry(paymDR))) {
		set paymDR=$o(paymAry(paymDR))
		set paymAmt=$g(paymAry(paymDR))
		if ($d(initPMAry(paymDR))&&(+initPMAry(paymDR)'=+$zabs(paymAmt))) {
			//+2023-04-22 ZhYW 是部分退费且该支付方式不能差额退款
			set rtn=..IsAllowedPartRefByPM(paymDR, hospId)
			quit:(+rtn)
		}
		if (paymAmt>0) {
			set rtn=1
			quit
		}
	}
	
	quit rtn
}

/// Creator: LUAN ZhenHui
/// CreatDate: 2022-09-07
/// Description: 获取是否允许退挂号费配置
/// Input: hospId: CT_Hospital.RowId
/// Return: 1:是, 0:否
/// Others: 通用配置-门诊收费系统-门诊退费-是否允许退挂号费
/// Debug: w ##class(web.DHCOPBillRefund).IsAllowedRefundReg(2)
ClassMethod IsAllowedRefundReg(hospId As %String) As %String
{
    set jsonStr=##class(BILL.CFG.COM.GeneralCfg).GetResultByRelaCode("OPCHRG.OPRefd.SFYXTGHF", "", "", hospId)
	set cfgData=##class(%DynamicObject).%FromJSON(jsonStr).data
	quit ($zcvt($p(cfgData,"^",2),"U")="YES")
}

/// Creator: ZhYW
/// CreatDate: 2022-10-24
/// Description: 获取部分退费是否按全退后再收费界面重收配置
/// Input: hospId: CT_Hospital.RowId
/// Return: 1:是, 0:否
/// Others: 通用配置-门诊收费系统-门诊退费-部分退费是否按全退后再收费界面重收
/// Debug: w ##class(web.DHCOPBillRefund).IsRefundedReCharge(2)
ClassMethod IsRefundedReCharge(hospId As %String) As %String
{
    set jsonStr=##class(BILL.CFG.COM.GeneralCfg).GetResultByRelaCode("OPCHRG.OPRefd.BFTFSFAQTHZSFJMZS", "", "", hospId)
	set cfgData=##class(%DynamicObject).%FromJSON(jsonStr).data
	quit ($zcvt($p(cfgData,"^",2),"U")="YES")
}

/// Creator: ZhYW
/// CreatDate: 2022-11-01
/// Description: 判断第三方支付的门诊收费是否允许原路退
/// Input: prtPMRowId: DHC_INVPPRT.RowId, refModeId:CT_PayMode.RowId(退费支付方式Id)
/// Return: 
/// Debug: w ##class(web.DHCOPBillRefund).IsAllowedInitModeToRefund("5365", 47)
ClassMethod IsAllowedInitModeToRefund(prtRowId As %String, refModeId As %String) As %String
{
	set rtn=0
	quit:(+prtRowId=0) -1_"^"_"参数错误"
	
	set rtnValue=..GetInvPayModeList(prtRowId_":"_"PRT")
	set selfPaymNum=$p(rtnValue,"#",1)
	set invPayment=(selfPaymNum>1)   //是否多种支付标识(1:是，0:否)
	
	set paymSub=""
	while($o(^DHCINVPRT(prtRowId,"P",paymSub),-1)) {
		set paymSub=$o(^DHCINVPRT(prtRowId,"P",paymSub),-1)
		set paymSubData=$g(^DHCINVPRT(prtRowId,"P",paymSub))
		continue:(paymSubData="")
		set prtPMRowId=prtRowId_"||"_paymSub
		set paymId=$p(paymSubData,"^",1)
		set isSelf=$p(paymSubData,"^",12)
		continue:(+isSelf'=1)     //过滤医保支付方式
		set myRefModeId=$s((invPayment=1):paymId,1:refModeId)
		set rtn=##class(web.UDHCINVPRT).IsAllowedInitModeToRefund(prtPMRowId, myRefModeId)
		quit:(+rtn)
	}
	
	quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2022-11-22
/// Description: 医保收费跨月是否能退费
/// Input: prtRowId:DHC_INVPRT/DHC_AccPayInv.RowId, invType:发票类型("API":集中打印发票)
/// Return: 1:是, 0:否
/// Debug: w ##class(web.DHCOPBillRefund).IsAllowedRefInsuDiffMth("6336","PRT")
ClassMethod IsAllowedRefInsuDiffMth(prtRowId As %String, invType As %String) As %String
{
	set rtn=1
	quit:(+prtRowId=0) rtn
	if (invType="API") {
		set accPInvData=$g(^DHCINVPRTAP(prtRowId))
		set prtDate=$p(accPInvData,"^",3)
		set insuDivDR=$p(accPInvData,"^",19)
		set hospDR=$p(accPInvData,"^",30)
		if (+insuDivDR>0) {
			quit $$IsInsuDiffMth()
		}
		//集中打印发票对应小条为医保情况
		set conDR=0
		while($o(^DHCINVPRTCAPi(0,"APINVDR",prtRowId,conDR))) {
			set conDR=$o(^DHCINVPRTCAPi(0,"APINVDR",prtRowId,conDR))
			set prtId=$p($g(^DHCINVPRTCAP(conDR)),"^",1)
			set rtn=$$LimitAuthOfPrtRef(prtId)
			quit:(rtn=0)
		}
		quit rtn
	}else {
		quit $$LimitAuthOfPrtRef(prtRowId)
	}

LimitAuthOfPrtRef(prtId)
	set prtInvData=$g(^DHCINVPRT(prtId))
	set prtDate=$p(prtInvData,"^",5)
	set insuDivDR=$p(prtInvData,"^",30)    //PRT_InsDiv_DR
	set hospDR=$p(prtInvData,"^",39)
	quit $$IsInsuDiffMth()
	
IsInsuDiffMth()
	quit:(+insuDivDR=0) rtn
	quit:('$SYSTEM.SQL.DATEDIFF("mm", prtDate, +$h)) rtn
	//通用配置->门诊收费系统->门诊退费->医保收费跨月是否能退费
	set jsonStr=##class(BILL.CFG.COM.GeneralCfg).GetResultByRelaCode("OPCHRG.OPRefd.YBSFKYSFNTF", "", "", hospDR)
	set cfgData=##class(%DynamicObject).%FromJSON(jsonStr).data
	quit ($zcvt($p(cfgData,"^",2),"U")="YES")
}

/// Creator: ZhYW
/// CreatDate: 2023-04-04
/// Description: 医保住院患者是否允许门诊部分退费
/// Input: patientId:PA_PatMas.RowId, hospId:CT_Hospital.RowId
/// Return: 1:是, 0:否
/// Others: 通用配置-门诊收费系统-门诊退费-医保住院患者是否允许门诊部分退费
/// Debug: w ##class(web.DHCOPBillRefund).IsAllowedIPPatPartRef(26283, 2)
ClassMethod IsAllowedIPPatPartRef(patientId As %String, hospId As %String) As %String
{
	set rtn=1
	set inAdm=##class(web.DHCIPBillReg).GetAdmitEpisodeID(patientId)   //获取住院在院就诊Id
	quit:(inAdm="") rtn   //无在院就诊
	set jsonStr=##class(BILL.CFG.COM.GeneralCfg).GetResultByRelaCode("OPCHRG.OPRefd.YBZYHZSFYXMZBFTF", "", "", hospId)
	set cfgData=##class(%DynamicObject).%FromJSON(jsonStr).data
	quit ($zcvt($p(cfgData,"^",2),"U")="YES")
}

/// Creator: LUANZH
/// CreatDate: 2023-04-06
/// Description: 是否默认查询已做退费申请
/// Input: hospId:CT_Hospital.RowId
/// Return: 1:是, 0:否
/// Others: 通用配置-门诊收费系统-门诊退费-是否默认查询已做退费申请
/// Debug: w ##class(web.DHCOPBillRefund).IsQryRefundAudit(2)
ClassMethod IsQryRefundAudit(hospId As %String) As %String
{
	set jsonStr=##class(BILL.CFG.COM.GeneralCfg).GetResultByRelaCode("OPCHRG.OPRefd.SFMRCXYZTFSQ", "", "", hospId)
	set cfgData=##class(%DynamicObject).%FromJSON(jsonStr).data
	quit ($zcvt($p(cfgData,"^",2),"U")="YES")
}

/// Creator: ZhYW
/// CreatDate: 2023-04-22
/// Description: 判断支付方式是否不支持差额退款
/// Input: paymId:, CT_PayMode.RowId, hospId: CT_Hospital.RowId
/// Return: 1:是, 0:否
/// Others: 通用配置-门诊收费系统-门诊退费-不支持差额退费的支付方式配置
/// Debug: w ##class(web.DHCOPBillRefund).IsAllowedPartRefByPM(1, 2)
ClassMethod IsAllowedPartRefByPM(paymId As %String, hospId As %String) As %String
{
	set rset=##class(%ResultSet).%New("BILL.CFG.COM.GeneralCfg:GetResultByRelaCodeForQuery")
	do rset.Execute("OPCHRG.OPRefd.BZCCETFDZFFSPZ", "", paymId, hospId)
	quit rset.Next()
}

/// Creator: ZhYW
/// CreatDate: 2023-05-22
/// Description: 获取可退费发票行记录背景颜色配置
/// Input: hospId:CT_Hospital.RowId
/// Return: 背景颜色色值
/// Others: 通用配置-门诊收费系统-门诊退费-可退费发票行记录背景颜色配置
/// Debug: w ##class(web.DHCOPBillRefund).GetRefInvRowBgClr(2)
ClassMethod GetRefInvRowBgClr(hospId As %String) As %String
{
	set jsonStr=##class(BILL.CFG.COM.GeneralCfg).GetResultByRelaCode("OPCHRG.OPRefd.KTFFPHJLBJYSPZ", "", "", hospId)
	set cfgData=##class(%DynamicObject).%FromJSON(jsonStr).value
	quit cfgData
}

/// Creator: ZhYW
/// CreatDate: 2023-05-22
/// Description: 获取可退费发票行数据字体颜色配置
/// Input: hospId:CT_Hospital.RowId
/// Return: 字体颜色色值
/// Others: 通用配置-门诊收费系统-门诊退费-可退费发票行数据字体颜色配置
/// Debug: w ##class(web.DHCOPBillRefund).GetRefInvRowClr(2)
ClassMethod GetRefInvRowClr(hospId As %String) As %String
{
	set jsonStr=##class(BILL.CFG.COM.GeneralCfg).GetResultByRelaCode("OPCHRG.OPRefd.KTFFPHSJZTYSPZ", "", "", hospId)
	set cfgData=##class(%DynamicObject).%FromJSON(jsonStr).value
	quit cfgData
}

}
