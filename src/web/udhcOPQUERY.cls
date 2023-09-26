Import SQLUser

Class web.udhcOPQUERY Extends BILL.COM.Abstract
{

/// Description: 门诊收据查询
/// Debug: do ##class(%ResultSet).RunQuery("web.udhcOPQUERY","INVQUERY11","","","","2021-02-23","00:00:00","2021-02-23","23:59:59","","","","","","","2")
Query INVQUERY11(ReceipNO As %String, PatientNO As %String, PatientName As %String, StDate As %String, StTime As %String, EndDate As %String, EndTime As %String, INVStatus As %String, UserId As %String, INVFootFlag As %String, CardNo As %String, PayModeId As %String, InsTypeId As %String, IsCESFlag As %String, HospId As %String, LangId As %String = "") As websys.Query(ROWSPEC = "TINVRowid:%String:发票ID,TINVNO:%String:发票号,TPatID:%String:登记号,TPatName:%String:患者姓名,TAcount:%Float:票据金额,TAbort:%String:作废,TRefund:%String:红冲,THandin:%String:结算,TUser:%String:收费员,TDate:%String:收费日期,TTime:%String:收费时间,TParkDate:%String:废票日期,TParkTime:%String:废票时间,TParUName:%String:作废人,TotSum:%Float:费用总额,TPayMode:%String:支付方式,TabFlag:%String:票据类型,TYBSum:%Float:医保支付额,OldInvNo:%String:原发票号,InsType:%String:结算费别,TEncryptLevel:%String:密级,TPatLevel:%String:级别,TDiscAmount:%Float:折扣金额,TPayorShare:%Float:记账金额,TInitInvNo:%String:作废发票号,IsStayInv:%String:是否留观结算,InvUsrName:%String:开票人,InvDate:%String:开票日期,InvTime:%String:开票时间,AllowRefundUserName:%String:退费申请人,AllowRefundDate:%String:退费申请日期,AllowRefundTime:%String:退费申请时间,CESFlag:%String:应急收费") [ SqlProc ]
{
}

ClassMethod INVQUERY11Execute(ByRef qHandle As %Binary, ReceipNO As %String, PatientNO As %String, PatientName As %String, StDate As %String, StTime As %String, EndDate As %String, EndTime As %String, INVStatus As %String, UserId As %String, INVFootFlag As %String, CardNo As %String, PayModeId As %String, InsTypeId As %String, IsCESFlag As %String, HospId As %String, LangId As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	
	if ((LangId="")&&($d(%session))) {
		set LangId=%session.Get("LOGON.LANGID")
	}
	
	set ^TMP("INVQUERY11")=$lb(ReceipNO, PatientNO, PatientName, StDate, StTime, EndDate, EndTime, INVStatus, UserId, INVFootFlag, CardNo, PayModeId, InsTypeId, IsCESFlag, HospId)

	set StDate=##class(websys.Conversions).DateHtmlToLogical(StDate)
	set EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	set StTime=##class(websys.Conversions).TimeHtmlToLogical(StTime)
	set EndTime=##class(websys.Conversions).TimeHtmlToLogical(EndTime)
	
    if (ReceipNO'="") {
	    //结算小条
	 	set TabFlag="PRT"
	    set PrtRowid=0
	    while($o(^DHCINVPRT(0,"INV",ReceipNO,PrtRowid))) {
		    set PrtRowid=$o(^DHCINVPRT(0,"INV",ReceipNO,PrtRowid))
		    do GetInvPrtDetails(PrtRowid)
		}
		
		//集中打印发票
		set TabFlag="API"
		set PrtRowid=0
		while($o(^DHCINVPRTAPi(0,"INVNo",ReceipNO,PrtRowid))) {
			set PrtRowid=$o(^DHCINVPRTAPi(0,"INVNo",ReceipNO,PrtRowid))
			do GetApiDetails(PrtRowid)
		}
		quit $$$OK
	}
	
	kill PatIdAry
	if (PatientNO'="") {
		set PatientNO=##class(web.UDHCJFBaseCommon).regnocon(PatientNO)
		set PatientNO=$zcvt(PatientNO,"U")
		set Papmi=$o(^PAPERi("PAPMI_PatNo",PatientNO,""))
		if (Papmi'="") {
			set PatIdAry(Papmi)=""
		}
	}elseif (PatientName'="") {
		do ##class(BILL.COM.PAPatMas).GetPatientByName(PatientName, .PatIdAry)
	}
	if ($d(PatIdAry)) {
		set Papmi=0
		while($o(PatIdAry(Papmi))) {
			set Papmi=$o(PatIdAry(Papmi))
			//结算小条
			set TabFlag="PRT"
			set PrtRowid=""
			while($o(^DHCINVPRT(0,"PAPMI",Papmi,PrtRowid),-1)) {
				set PrtRowid=$o(^DHCINVPRT(0,"PAPMI",Papmi,PrtRowid),-1)
				set PrtUsrDR=$p($g(^DHCINVPRT(PrtRowid)),"^",21)
				continue:((UserId'="")&&(PrtUsrDR'=UserId))
				do GetInvPrtDetails(PrtRowid)
			}
			
			//集中打印发票
			set TabFlag="API"
			set PrtRowid=""
			while($o(^DHCINVPRTAPi(0,"PAPMI",Papmi,PrtRowid),-1)) {
				set PrtRowid=$o(^DHCINVPRTAPi(0,"PAPMI",Papmi,PrtRowid),-1)
				set InvUsrDR=$p($g(^DHCINVPRTAP(PrtRowid)),"^",5)
				continue:((UserId'="")&&(PrtUsrDR'=UserId))
				do GetApiDetails(PrtRowid)
			}
		}
		quit $$$OK
	}
	
	if (UserId'="") {
		for PDate=EndDate:-1:StDate {
			//结算小条
			set TabFlag="PRT"
			set PrtRowid=""
			while($o(^DHCINVPRT(0,"UserDate",UserId,PDate,PrtRowid),-1)) {
				set PrtRowid=$o(^DHCINVPRT(0,"UserDate",UserId,PDate,PrtRowid),-1)
				set myPrtDate=$p($g(^DHCINVPRT(PrtRowid)),"^",5)
				set myPrtTime=$p($g(^DHCINVPRT(PrtRowid)),"^",20)
				continue:((StDate'="")&&(StDate>myPrtDate))
				continue:((EndDate'="")&&(EndDate<myPrtDate))
				continue:((StDate=myPrtDate)&&(myPrtTime<StTime))
				continue:((EndDate=myPrtDate)&&(myPrtTime>EndTime))
				do GetInvPrtDetails(PrtRowid)
			}
			
			//集中打印发票
			set TabFlag="API"
			set PrtRowid=""
			while($o(^DHCINVPRTAPi(0,"UserDate",UserId,PDate,PrtRowid),-1)) {
				set PrtRowid=$o(^DHCINVPRTAPi(0,"UserDate",UserId,PDate,PrtRowid),-1)
				set myApiDate=$p($g(^DHCINVPRTAP(PrtRowid)),"^",3)
				set myApiTime=$p($g(^DHCINVPRTAP(PrtRowid)),"^",4)
				continue:((StDate'="")&&(StDate>myApiDate))
				continue:((EndDate'="")&&(EndDate<myApiDate))
				continue:((StDate=myApiDate)&&(myApiTime<StTime))
				continue:((EndDate=myApiDate)&&(myApiTime>EndTime))
				do GetApiDetails(PrtRowid)
			}
		}
		quit $$$OK
	}
	
	for PDate=EndDate:-1:StDate {
		//结算小条
		set TabFlag="PRT"
		set PrtRowid=""
		while($o(^DHCINVPRT(0,"Date",PDate,PrtRowid),-1)) {
			set PrtRowid=$o(^DHCINVPRT(0,"Date",PDate,PrtRowid),-1)
			set myPrtTime=$p($g(^DHCINVPRT(PrtRowid)),"^",20)
			set myPrtDate=$p($g(^DHCINVPRT(PrtRowid)),"^",5)
			continue:((StDate'="")&&(StDate>myPrtDate))
			continue:((EndDate'="")&&(EndDate<myPrtDate))
			continue:((StDate=myPrtDate)&&(myPrtTime<StTime))
			continue:((EndDate=myPrtDate)&&(myPrtTime>EndTime))
			do GetInvPrtDetails(PrtRowid)
		}
		
		//集中打印发票
		set TabFlag="API"
		set PrtRowid=""
		while($o(^DHCINVPRTAPi(0,"Date",PDate,PrtRowid),-1)) {
			set PrtRowid=$o(^DHCINVPRTAPi(0,"Date",PDate,PrtRowid),-1)
			set myApiDate=$p($g(^DHCINVPRTAP(PrtRowid)),"^",3)
			set myApiTime=$p($g(^DHCINVPRTAP(PrtRowid)),"^",4)
			continue:((StDate'="")&&(StDate>myApiDate))
			continue:((EndDate'="")&&(EndDate<myApiDate))
			continue:((StDate=myApiDate)&&(myApiTime<StTime))
			continue:((EndDate=myApiDate)&&(myApiTime>EndTime))
			do GetApiDetails(PrtRowid)
		}
	}
	
   	quit $$$OK
	
GetInvPrtDetails(PrtRowid)
	set PrtData=$g(^DHCINVPRT(PrtRowid))
	set HospDR=$p(PrtData,"^",39)
	quit:(HospDR'=HospId)
	
    set initInvDR=$p(PrtData,"^",13)
   	set Flag=$p(PrtData,"^",8)
	quit:((INVStatus'="")&&(INVStatus'=Flag))
	set Abortflag=(Flag="A")
	set refundflag=(Flag="S")
   	set accPInvDR=$p(PrtData,"^",4)   //PRT_ACCPINV_DR
   	quit:(+accPInvDR'=0)
    
	set myInvNo=$p(PrtData,"^",14)
    set initInvNo=$s((+initInvDR'=0):$p($g(^DHCINVPRT(initInvDR)),"^",14),1:"")
    
	set PrtUsrDR=$p(PrtData,"^",21)
	set PrtUsrName=$s((+PrtUsrDR'=0):$p($g(^SSU("SSUSR",PrtUsrDR)),"^",2),1:"")
	set PrtUsrName=##class(User.SSUser).GetTranByDesc("SSUSRName", PrtUsrName, LangId)
	
	set insTypeDR=$p(PrtData,"^",9)
	quit:((InsTypeId'="")&&(InsTypeId'=insTypeDR))
	set insType=$s((+insTypeDR'=0):$p($g(^PAC("ADMREA",insTypeDR)),"^",2),1:"")
	set insType=##class(User.PACAdmReason).GetTranByDesc("READesc", insType, LangId)
	
	set PapmiDR=$p(PrtData,"^",15)
	set PapmiNo=$s((+PapmiDR'=0):$p($g(^PAPER(PapmiDR,"PAT",1)),"^",2),1:"")
	set PapmiName=$s((+PapmiDR'=0):$p($g(^PAPER(PapmiDR,"ALL")),"^",1),1:"")

	//add by wangjian 2015-01-15 增加病人密级和级别
    set PatEncryptLevel=##class(web.UDHCJFBaseCommon).GetPatEncryptLevel(PapmiDR, "")
    set EncryptLevel=$p(PatEncryptLevel,"^",1)
    set PatLevel=$p(PatEncryptLevel,"^",2)
    
    set Acount=$p(PrtData,"^",16)
	set Acount=$fn(Acount,"",2)
	set TotSum=$p(PrtData,"^",1)
	set TotSum=$fn(TotSum,"",2)
	set DiscAmt=$p(PrtData,"^",7)
	set DiscAmt=$fn(DiscAmt,"",2)
	set PayorShare=$p(PrtData,"^",18)
	set PayorShare=$fn(PayorShare,"",2)

	set Handin=$p(PrtData,"^",10)
	quit:(INVFootFlag'="")&&(INVFootFlag'=Handin)
	set handflag=(Handin="Y")

	set PayMStr=""
	set PaymIdStr=""
	set myPMSub=0
	while($o(^DHCINVPRT(PrtRowid,"P",myPMSub))) {
		set myPMSub=$o(^DHCINVPRT(PrtRowid,"P",myPMSub))
		set myPMSubData=$g(^DHCINVPRT(PrtRowid,"P",myPMSub))
		set myPMDR=$p(myPMSubData,"^",1)
		continue:(+myPMDR=0)
		set PaymIdStr=$s((PaymIdStr=""):myPMDR,1:(PaymIdStr_"^"_myPMDR))
		set IPMAmt=$p(myPMSubData,"^",3)
		set IPMAmt=$fn(IPMAmt,"",2)
		set PayMDesc=$p($g(^CT("CTPM",myPMDR)),"^",2)
		set PayMDesc=##class(User.CTPayMode).GetTranByDesc("CTPMDesc", PayMDesc, LangId)
		set myStr=PayMDesc_": "_IPMAmt
		set PayMStr=$s((PayMStr=""):myStr,1:(PayMStr_" "_myStr))
	}
	quit:((PayModeId'="")&&(("^"_PaymIdStr_"^")'[("^"_PayModeId_"^")))
    
	set PRTParkDate=""
	set PRTParkTime=""
	set ParkUserName=""
	if (Flag'="N") {
		set ParkINVDR=$o(^DHCINVPRT(0,"InitInvDR",PrtRowid,0))
		if (+ParkINVDR'=0) {
			set PRTParkData=$g(^DHCINVPRT(ParkINVDR))
			set PRTParkDate=$p(PRTParkData,"^",5)
			set PRTParkTime=$p(PRTParkData,"^",20)
			set ParkUserDR=$p(PRTParkData,"^",21)
			set ParkUserName=$s((+ParkUserDR'=0):$p($g(^SSU("SSUSR",ParkUserDR)),"^",2),1:"")
			set ParkUserName=##class(User.SSUser).GetTranByDesc("SSUSRName", ParkUserName, LangId)
		}
	}
	set PRTParkDate=##class(websys.Conversions).DateLogicalToHtml(PRTParkDate)
	set PRTParkTime=##class(websys.Conversions).TimeLogicalToHtml(PRTParkTime)
	set myYBPaySum=+$p(PrtData,"^",31)
	set myYBPaySum=$fn(myYBPaySum,"",2)
	set OldInvDr=$p(PrtData,"^",29)
	set OldInvNo=$s((+OldInvDr'=0):$p($g(^DHCINVPRT(OldInvDr)),"^",14),1:"")
	set PrtDate=$p(PrtData,"^",5)
	set PrtDate=##class(websys.Conversions).DateLogicalToHtml(PrtDate)
	set PrtTime=$p(PrtData,"^",20)
	set PrtTime=##class(websys.Conversions).TimeLogicalToHtml(PrtTime)
	set isStayInv=$p(PrtData,"^",44)
	//+2021-02-23 ZhYW
	set (InvUsrName, InvDate, InvTime)=""
	set INVPrintFlag=$p(PrtData,"^",3)
	if (INVPrintFlag="P") {
		set InvUsrName=PrtUsrName
		set InvDate=PrtDate
		set InvTime=PrtTime
	}
	set InvUsrName=##class(User.SSUser).GetTranByDesc("SSUSRName", InvUsrName, LangId)
	set AllowRefundDate=$p(PrtData,"^",23)
	set AllowRefundDate=##class(websys.Conversions).DateLogicalToHtml(AllowRefundDate)
	set AllowRefundTime=$p(PrtData,"^",24)
	set AllowRefundTime=##class(websys.Conversions).TimeLogicalToHtml(AllowRefundTime)
	set AllowRefundUserDR=$p(PrtData,"^",25)
	set AllowRefundUserName=$s((+AllowRefundUserDR'=0):$p($g(^SSU("SSUSR",AllowRefundUserDR)),"^",2),1:"")
	set AllowRefundUserName=##class(User.SSUser).GetTranByDesc("SSUSRName", AllowRefundUserName, LangId)
	set CESFlag=##class(BILL.CES.COM.Log).IsCESFlag("DHC_INVPRT", PrtRowid)
	quit:((IsCESFlag="Y")&&(CESFlag'=1))
	quit:((IsCESFlag="N")&&(CESFlag=1))
	
	do OutputINVDtl

	quit
	
GetApiDetails(PrtRowid)
	set PrtAccPData=$g(^DHCINVPRTAP(PrtRowid))
	set HospDR=$p(PrtAccPData,"^",30)
    quit:(HospDR'=HospId)
    
	set insTypeDR=$p(PrtAccPData,"^",31)
	quit:((InsTypeId'="")&&(InsTypeId'=insTypeDR))
	set insType=$s((+insTypeDR'=0):$p($g(^PAC("ADMREA",insTypeDR)),"^",2),1:"")
	set insType=##class(User.PACAdmReason).GetTranByDesc("READesc", insType, LangId)

	set PapmiDR=$p(PrtAccPData,"^",11)
	set PapmiNo=$s((+PapmiDR'=0):$p($g(^PAPER(PapmiDR,"PAT",1)),"^",2),1:"")
	set PapmiName=$s((+PapmiDR'=0):$p($g(^PAPER(PapmiDR,"ALL")),"^",1),1:"")

	//add by wangjian 2015-01-15 增加病人密级和级别
    set PatEncryptLevel=##class(web.UDHCJFBaseCommon).GetPatEncryptLevel(PapmiDR, "")
    set EncryptLevel=$p(PatEncryptLevel,"^",1)
    set PatLevel=$p(PatEncryptLevel,"^",2)
	
	set Acount=$p(PrtAccPData,"^",13)
	set Acount=$fn(Acount,"",2)
	set TotSum=$p(PrtAccPData,"^",1)
	set TotSum=$fn(TotSum,"",2)
	set DiscAmt=$p(PrtAccPData,"^",14)
	set DiscAmt=$fn(DiscAmt,"",2)
	set PayorShare=$p(PrtAccPData,"^",15)
	set PayorShare=$fn(PayorShare,"",2)
	set Flag=$p(PrtAccPData,"^",2)
	quit:((INVStatus'="")&&(INVStatus'=Flag))
	set Abortflag=(Flag="A")
	set refundflag=(Flag="S")
	
	set myInvNo=$p(PrtAccPData,"^",6)       //API_INVNo
	set initInvDR=$p(PrtAccPData,"^",10)    //API_PayINV_DR
	quit:((myInvNo="")&&(initInvDR=""))	    //被作废的小票退出
	set Handin=$p(PrtAccPData,"^",33)       //API_Handin
	quit:(INVFootFlag'="")&&(INVFootFlag'=Handin)
	set handflag=(Handin="Y")

	set initInvNo=$s((+initInvDR'=0):$p($g(^DHCINVPRTAP(initInvDR)),"^",6),1:"")
	
	set PayMStr=""
	set PaymIdStr=""
	set myPMSub=0
	while($o(^DHCINVPRTAP(PrtRowid,"P",myPMSub))) {
		set myPMSub=$o(^DHCINVPRTAP(PrtRowid,"P",myPMSub))
		set myPMSubData=$g(^DHCINVPRTAP(PrtRowid,"P",myPMSub))
		continue:(myPMSubData="")
		set myPMDR=$p(myPMSubData,"^",1)
		continue:(+myPMDR=0)
		set PaymIdStr=$s((PaymIdStr=""):myPMDR,1:(PaymIdStr_"^"_myPMDR))
		set IPMAmt=$p(myPMSubData,"^",3)
		set IPMAmt=$fn(IPMAmt,"",2)
		set PayMDesc=$p($g(^CT("CTPM",myPMDR)),"^",2)
		set PayMDesc=##class(User.CTPayMode).GetTranByDesc("CTPMDesc", PayMDesc, LangId)
		set myStr=PayMDesc_": "_IPMAmt
		set PayMStr=$s((PayMStr=""):myStr,1:(PayMStr_" "_myStr))
	}
	quit:((PayModeId'="")&&(("^"_PaymIdStr_"^")'[("^"_PayModeId_"^")))
	
	set PRTParkDate=""
	set PRTParkTime=""
	set ParkUserName=""
	if (Flag'="N") {
		set ParkINVDR=$o(^DHCINVPRTAPi(0,"APIDR",PrtRowid,0))
		if (+ParkINVDR'=0) {
			set PRTParkData=$g(^DHCINVPRTAP(ParkINVDR))
			set PRTParkDate=$p(PRTParkData,"^",3)
			set PRTParkTime=$p(PRTParkData,"^",4)
			set ParkUserDR=$p(PRTParkData,"^",5)
			set ParkUserName=$s((+ParkUserDR'=0):$p($g(^SSU("SSUSR",ParkUserDR)),"^",2),1:"")
			set ParkUserName=##class(User.SSUser).GetTranByDesc("SSUSRName", ParkUserName, LangId)
		}
	}
	set PRTParkDate=##class(websys.Conversions).DateLogicalToHtml(PRTParkDate)
	set PRTParkTime=##class(websys.Conversions).TimeLogicalToHtml(PRTParkTime)
	set myYBPaySum=$p(PrtAccPData,"^",17)	  //API_SelfYBPay
	set myYBPaySum=$fn(myYBPaySum,"",2)
	set OldInvDr=$p(PrtAccPData,"^",22)
	set OldInvNo=$s((+OldInvDr'=0):$p($g(^DHCINVPRTAP(OldInvDr)),"^",6),1:"")
	set (InvUsrName, InvDate, InvTime)=""
	if (myInvNo'="") {
		set InvUsrDR=$p(PrtAccPData,"^",5)
		set InvUsrName=$s((+InvUsrDR'=0):$p($g(^SSU("SSUSR",InvUsrDR)),"^",2),1:"")
		set InvUsrName=##class(User.SSUser).GetTranByDesc("SSUSRName", InvUsrName, LangId)
		set InvDate=$p(PrtAccPData,"^",3)
		set InvDate=##class(websys.Conversions).DateLogicalToHtml(InvDate)
		set InvTime=$p(PrtAccPData,"^",4)
		set InvTime=##class(websys.Conversions).TimeLogicalToHtml(InvTime)
	}
	set isStayInv=$p(PrtAccPData,"^",29)
	//+2021-02-23 ZhYW
	set AccConPayId=$o(^DHCINVPRTCAPi(0,"APINVDR",PrtRowid,""),-1)
	set InvPrtDR=$p(^DHCINVPRTCAP(AccConPayId),"^",1)
	set InvPrtData=$g(^DHCINVPRT(InvPrtDR))
	set PrtUsrDR=$p(InvPrtData,"^",21)
	set PrtUsrName=$s((+PrtUsrDR'=0):$p($g(^SSU("SSUSR",PrtUsrDR)),"^",2),1:"")
	set PrtUsrName=##class(User.SSUser).GetTranByDesc("SSUSRName", PrtUsrName, LangId)
	set PrtDate=$p(InvPrtData,"^",5)
	set PrtDate=##class(websys.Conversions).DateLogicalToHtml(PrtDate)
	set PrtTime=$p(InvPrtData,"^",20)
	set PrtTime=##class(websys.Conversions).TimeLogicalToHtml(PrtTime)
	set AllowRefundDate=$p(InvPrtData,"^",23)
	set AllowRefundDate=##class(websys.Conversions).DateLogicalToHtml(AllowRefundDate)
	set AllowRefundTime=$p(InvPrtData,"^",24)
	set AllowRefundTime=##class(websys.Conversions).TimeLogicalToHtml(AllowRefundTime)
	set AllowRefundUserDR=$p(InvPrtData,"^",25)
	set AllowRefundUserName=$s((+AllowRefundUserDR'=0):$p($g(^SSU("SSUSR",AllowRefundUserDR)),"^",2),1:"")
	set AllowRefundUserName=##class(User.SSUser).GetTranByDesc("SSUSRName", AllowRefundUserName, LangId)
	set CESFlag=0   //集中打印发票认为非应急收费系统导入数据
	quit:((IsCESFlag="Y")&&(CESFlag'=1))
	quit:((IsCESFlag="N")&&(CESFlag=1))
	do OutputINVDtl
	quit

OutputINVDtl
	set Data=$lb(PrtRowid,myInvNo,PapmiNo,PapmiName,Acount,Abortflag,refundflag,handflag,PrtUsrName,PrtDate,PrtTime,PRTParkDate,PRTParkTime,ParkUserName,TotSum,PayMStr,TabFlag,myYBPaySum,OldInvNo,insType,EncryptLevel,PatLevel,DiscAmt,PayorShare,initInvNo,isStayInv,InvUsrName,InvDate,InvTime,AllowRefundUserName,AllowRefundDate,AllowRefundTime,CESFlag)
	set ^CacheTemp(repid,ind)=Data
	set ind=$i(ind)
	quit
}

/// Debug: do ##class(%ResultSet).RunQuery("web.udhcOPQUERY","INVQUERY","ALL","韩冬","","","","2018-11-16","2018-11-16","N","ALL","  N","238","303","","")
Query INVQUERY(ChargeUser As %String, ReceipNO As %String, PatientNO As %String, PatientName As %String, StartDate As %String, EndDate As %String, INVFlag As %String, INVStatus As %String, HospId As %String, LangId As %String = "") As websys.Query(ROWSPEC = "TINVRowid:%String:发票ID,TINVNO:%String:发票号,TPatID:%String:登记号,TPatName:%String:患者姓名,TAcount:%Float:自付金额,TAbort:%String:作废,TRefund:%String:红冲,THandin:%String:结算,TUser:%String:操作员,TDate:%String:收费日期,TTime:%String:收费时间,TParkDate:%String:退费时间,TParkTime:%String:退费时间,TParUName:%String:退费操作员,TotSum:%Float:费用总额,TabFlag:%String,TInsuPaySum:%Float:医保金额,InsType:%String:结算费别,EncryptLevel:%String:密级,PatLevel:%String:级别,IsStayInv:%String:是否急诊留观发票")
{
}

ClassMethod INVQUERYExecute(ByRef qHandle As %Binary, ChargeUser As %String, ReceipNO As %String, PatientNO As %String, PatientName As %String, StartDate As %String, EndDate As %String, INVFlag As %String, INVStatus As %String, HospId As %String, LangId As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	set ^TMP("INVQUERY")=$lb(ChargeUser, ReceipNO, PatientNO, PatientName, StartDate, EndDate, INVFlag, INVStatus, HospId, LangId)
	
	if ((LangId="")&&($d(%session))) {
		set LangId=%session.Get("LOGON.LANGID")
	}

	set StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
	set EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	if ((StartDate="")||(EndDate=""))  quit $$$OK
	
	if (ReceipNO'="") {
		//结算小条
		set TabFlag="PRT"
		set PrtRowid=0
		while($o(^DHCINVPRT(0,"INV",ReceipNO,PrtRowid))) {
			set PrtRowid=$o(^DHCINVPRT(0,"INV",ReceipNO,PrtRowid))
			do GetInfoOfInv(PrtRowid)
		}

		//集中打印发票
		set TabFlag="API"
		set PrtRowid=0
		while($o(^DHCINVPRTAPi(0,"INVNo",ReceipNO,PrtRowid))) {
			set PrtRowid=$o(^DHCINVPRTAPi(0,"INVNo",ReceipNO,PrtRowid))
			do GetInfoOfAPI(PrtRowid)
		}
		
		quit $$$OK
	}

	if (PatientNO'="") {
		set PatientNO=##class(web.UDHCJFBaseCommon).regnocon(PatientNO)
		set PatientNO=$zcvt(PatientNO,"U")
		set myPAPMIStr=$o(^PAPERi("PAPMI_PatNo",PatientNO,""))
		for index=1:1:$l(myPAPMIStr,"^") {
			set papmi=$p(myPAPMIStr,"^",index)
			continue:(+papmi=0)
			//结算小条
			set TabFlag="PRT"
			set PrtRowid=""
			while($o(^DHCINVPRT(0,"PAPMI",papmi,PrtRowid),-1)) {
				set PrtRowid=$o(^DHCINVPRT(0,"PAPMI",papmi,PrtRowid),-1)
				set prtDate=$p(^DHCINVPRT(PrtRowid),"^",5)
				set prtTime=$p(^DHCINVPRT(PrtRowid),"^",20)
				continue:((prtDate<StartDate)||(prtDate>EndDate))
				do GetInfoOfInv(PrtRowid)
			}
			
			//集中打印发票
			set TabFlag="API"
			set PrtRowid=""
			while($o(^DHCINVPRTAPi(0,"PAPMI",papmi,PrtRowid),-1)) {
				set PrtRowid=$o(^DHCINVPRTAPi(0,"PAPMI",papmi,PrtRowid),-1)
				set prtDate=$p(^DHCINVPRTAP(PrtRowid),"^",3)
				set prtTime=$p(^DHCINVPRTAP(PrtRowid),"^",4)
				continue:((prtDate<StartDate)||(prtDate>EndDate))
				do GetInfoOfAPI(PrtRowid)
			}
		}
		
		quit $$$OK
	}
	
	for date=EndDate:-1:StartDate {
		//结算小条
		set TabFlag="PRT"
		set PrtRowid=""
		while($o(^DHCINVPRT(0,"Date",date,PrtRowid),-1)) {
			set PrtRowid=$o(^DHCINVPRT(0,"Date",date,PrtRowid),-1)
			do GetInfoOfInv(PrtRowid)
		}
		
		//集中打印发票记录
		set TabFlag="API"
		set PrtRowid=""
		while($o(^DHCINVPRTAPi(0,"Date",date,PrtRowid),-1)) {
			set PrtRowid=$o(^DHCINVPRTAPi(0,"Date",date,PrtRowid),-1)
			do GetInfoOfAPI(PrtRowid)
		}
	}
	
	quit $$$OK

GetInfoOfInv(PrtRowid)
	set PrtData=$g(^DHCINVPRT(PrtRowid))
	set hospDR=$p(PrtData,"^",39)
	quit:(hospDR'=HospId)
	set PrtUsrDR=$p(PrtData,"^",21)
	set PrtUsrCode=$p($g(^SSU("SSUSR",PrtUsrDR)),"^",1)
	set PrtUsrName=$p($g(^SSU("SSUSR",PrtUsrDR)),"^",2)
	set PrtUsrName=##class(User.SSUser).GetTranByDesc("SSUSRName", PrtUsrName, LangId)
	quit:((ChargeUser'="") && ($zcvt(PrtUsrCode,"U")'[$zcvt(ChargeUser,"U")) && ($zcvt(PrtUsrName,"U")'[$zcvt(ChargeUser,"U")))
	set PrtNO=$p(PrtData,"^",14)
	quit:((PrtNO'=ReceipNO)&&(ReceipNO'=""))
	set insTypeDR=$p(PrtData,"^",9)
	set insType=$s((+insTypeDR'=0):$p($g(^PAC("ADMREA",insTypeDR)),"^",2),1:"")
	set insType=##class(User.PACAdmReason).GetTranByDesc("READesc", insType, LangId)
	set PapmiDR=$p(PrtData,"^",15)
	set PapmiNo=$p($g(^PAPER(PapmiDR,"PAT",1)),"^",2)
	quit:((PapmiNo'=PatientNO)&&(PatientNO'=""))
	set PapmiName=$p($g(^PAPER(PapmiDR,"ALL")),"^",1)
	quit:((PapmiName'=PatientName)&&(PatientName'=""))
	//add by lml 2015-01-15 增加病人密级和级别
	set PatEncryptLevel=##class(web.UDHCJFBaseCommon).GetPatEncryptLevel(PapmiDR, "")
	set EncryptLevel=$p(PatEncryptLevel,"^",1)
	set PatLevel=$p(PatEncryptLevel,"^",2)
	
	set Acount=$p(PrtData,"^",16)
	set Acount=$fn(Acount,"",2)
	set TotSum=$p(PrtData,"^",1)
	set TotSum=$fn(TotSum,"",2)
	set Flag=$p(PrtData,"^",8)
	quit:((INVFlag'="")&&(INVFlag'=Flag))
	set Abortflag=(Flag="A")
	set refundflag=(Flag="S")
	quit:((INVStatus'="")&&(INVStatus'[Flag))
	set PRTDate=$p(PrtData,"^",5)
	set PRTDate=##class(websys.Conversions).DateLogicalToHtml(PRTDate)
	set PRTTime=$p(PrtData,"^",20)
	set PRTTime=##class(websys.Conversions).TimeLogicalToHtml(PRTTime)
	set myInvDR=$p(PrtData,"^",13)
	set myAcPInvDR=$p(PrtData,"^",4)	    //指向集中打印发票表Rowid
	quit:(myAcPInvDR'="")                             //过滤已经集中打印发票的支付小条
	set myInvNo=$p(PrtData,"^",14)
	quit:((myInvDR'="")&&(myInvNo=""))

	set myHandin=$p(PrtData,"^",10)
	set handflag=(myHandin="Y")
	
	set PRTParkDate=""
	set PRTParkTime=""
	set ParkUserName=""
	if (Flag'="N") {
		set ParkINVDR=$o(^DHCINVPRT(0,"InitInvDR",PrtRowid,0))
		if (ParkINVDR'="") {
			set PRTParkData=$g(^DHCINVPRT(ParkINVDR))
			set PRTParkDate=$p(PRTParkData,"^",5)
			set PRTParkTime=$p(PRTParkData,"^",20)
			set ParkUserDR=$p(PRTParkData,"^",21)
			set ParkUserName=$s((+ParkUserDR'=0):$p($g(^SSU("SSUSR",ParkUserDR)),"^",2),1:"")
			set ParkUserName=##class(User.SSUser).GetTranByDesc("SSUSRName", ParkUserName, LangId)
		}
	}
	set PRTParkDate=##class(websys.Conversions).DateLogicalToHtml(PRTParkDate)
	set PRTParkTime=##class(websys.Conversions).TimeLogicalToHtml(PRTParkTime)
	set myYBPaySum=+$p(PrtData,"^",31)
	set myYBPaySum=$fn(myYBPaySum,"",2)
	set isStayInv=$p(PrtData,"^",44)
	do OutputINVQUERYO
	quit
	
GetInfoOfAPI(PrtRowid)
	set PrtAccPData=$g(^DHCINVPRTAP(PrtRowid))
    set hospDR=$p(PrtAccPData,"^",30)
	quit:(hospDR'=HospId)
	set PrtUsrDR=$p(PrtAccPData,"^",5)
	set PrtUsrCode=$p($g(^SSU("SSUSR",PrtUsrDR)),"^",1)
	set PrtUsrName=$p($g(^SSU("SSUSR",PrtUsrDR)),"^",2)
	set PrtUsrName=##class(User.SSUser).GetTranByDesc("SSUSRName", PrtUsrName, LangId)
	quit:((ChargeUser'="") && ($zcvt(PrtUsrCode,"U")'[$zcvt(ChargeUser,"U")) && ($zcvt(PrtUsrName,"U")'[$zcvt(ChargeUser,"U")))
	set PrtNO=$p(PrtAccPData,"^",6)
	quit:((PrtNO'=ReceipNO)&&(ReceipNO'=""))	
	set insTypeDR=$p(PrtAccPData,"^",31)
	set insType=$s((+insTypeDR'=0):$p($g(^PAC("ADMREA",insTypeDR)),"^",2),1:"")
	set insType=##class(User.PACAdmReason).GetTranByDesc("READesc", insType, LangId)
	set PapmiDR=$p(PrtAccPData,"^",11)
	set PapmiNo=$p($g(^PAPER(PapmiDR,"PAT",1)),"^",2)
	quit:((PapmiNo'=PatientNO)&&(PatientNO'=""))
	set PapmiName=$p($g(^PAPER(PapmiDR,"ALL")),"^",1)
	quit:((PapmiName'=PatientName)&&(PatientName'=""))
	//add by lml 2015-01-15 增加病人密级和级别
	set PatEncryptLevel=##class(web.UDHCJFBaseCommon).GetPatEncryptLevel(PapmiDR, "")
	set EncryptLevel=$p(PatEncryptLevel,"^",1)
	set PatLevel=$p(PatEncryptLevel,"^",2)
	set Acount=$fn(+$p(PrtAccPData,"^",13),"",2)
	set TotSum=$fn(+$p(PrtAccPData,"^",1),"",2)
	set Flag=$p(PrtAccPData,"^",2)
	quit:((INVStatus'="")&&(INVStatus'[Flag))
	set Abortflag=(Flag="A")
	set refundflag=(Flag="S")
	set PRTTime=$p(PrtAccPData,"^",4)
	set PRTTime=##class(websys.Conversions).TimeLogicalToHtml(PRTTime)
	set myInvDR=$p(PrtAccPData,"^",10)
	quit:((PrtNO="")&&(myInvDR=""))			//被作废的小票退出
	set myInvNo=$p(PrtAccPData,"^",6)
	quit:((myInvDR'="")&&(myInvNo=""))
	
	set myHandin=$p(PrtAccPData,"^",33)
	set handflag=(myHandin="Y")
	
	set PRTParkDate=""
	set PRTParkTime=""
	set ParkUserName=""
	if (Flag'="N") {
		set ParkINVDR=$o(^DHCINVPRTAPi(0,"APIDR",PrtRowid,0))
		if (ParkINVDR'="") {
			set PRTParkData=$g(^DHCINVPRTAP(ParkINVDR))
			set PRTParkDate=$p(PRTParkData,"^",3)
			set PRTParkTime=$p(PRTParkData,"^",4)
			set ParkUserDR=$p(PRTParkData,"^",5)
			set ParkUserName=$s((+ParkUserDR'=0):$p($g(^SSU("SSUSR",ParkUserDR)),"^",2),1:"")
			set ParkUserName=##class(User.SSUser).GetTranByDesc("SSUSRName", ParkUserName, LangId)
		}
	}
	set PRTParkDate=##class(websys.Conversions).DateLogicalToHtml(PRTParkDate)
	set PRTParkTime=##class(websys.Conversions).TimeLogicalToHtml(PRTParkTime)
	set myYBPaySum=$p(PrtAccPData,"^",17)	//API_SelfYBPay
	set myYBPaySum=$fn(myYBPaySum,"",2)
	set PRTDate=$p(PrtAccPData,"^",3)
	set PRTDate=##class(websys.Conversions).DateLogicalToHtml(PRTDate)
	set isStayInv=$p(PrtAccPData,"^",29)
	do OutputINVQUERYO
	quit
	
OutputINVQUERYO
	set Data=$lb(PrtRowid,PrtNO,PapmiNo,PapmiName,Acount,Abortflag,refundflag,handflag,PrtUsrName,PRTDate,PRTTime,PRTParkDate,PRTParkTime,ParkUserName,TotSum,TabFlag,myYBPaySum,insType,EncryptLevel,PatLevel,isStayInv)
	set ^CacheTemp(repid,ind)=Data
	set ind=$i(ind)
	quit
}

/// do ##class(%ResultSet).RunQuery("web.udhcOPQUERY","FindInvUser","收费",2)
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
	
	if (desc'=""){
		set desc=$zcvt(desc,"U")
	}
	kill userAry
	
    set userId=0
    while($o(^DHCINVPRT(0,"User",userId))) {
    	set userId=$o(^DHCINVPRT(0,"User",userId))
	    set userData=$g(^SSU("SSUSR",userId))
		continue:(userData="")
	    set showFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("SS_User", userId, hospId)
		continue:(showFlag="N")
		set userAry(userId)=""
	    set userCode=$p(userData,"^",1)
	    set userName=$p(userData,"^",2)
	    set userName=##class(User.SSUser).GetTranByDesc("SSUSRName", userName, langId)
	    continue:((desc'="")&&($zcvt(userCode,"U")'[desc)&&($zcvt(userName,"U")'[desc))
		do OutputInvUser
    }
	set userId=0
	while($o(^DHCINVPRTAPi(0,"UseDR",userId))) {
		set userId=$o(^DHCINVPRTAPi(0,"UseDR",userId))
		continue:($d(userAry(userId)))       //去重
		set userData=$g(^SSU("SSUSR",userId))
		continue:(userData="")
		set showFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("SS_User", userId, hospId)
		continue:(showFlag="N")
		set userCode=$p(userData,"^",1)
		set userName=$p(userData,"^",2)
		set userName=##class(User.SSUser).GetTranByDesc("SSUSRName", userName, langId)
		continue:((desc'="")&&($zcvt(userCode,"U")'[desc)&&($zcvt(userName,"U")'[desc))
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
/// CreatDate: 2018-03-13
/// Description: 获取门诊费用清单打印数据
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.udhcOPQUERY","GetInvDtlPrtInfo","1967:PRT")
Query GetInvDtlPrtInfo(invStr As %Text) As websys.Query(ROWSPEC = "patName:%String,sex:%String,patNo:%String,invNo:%String,prtDate:%String,userName:%String,invIdx:%String,catDesc:%String,tariDesc:%String,price:%String,qty:%Float,total:%Float,patShare:%Float,ybzfbl:%String,medListCode:%String,medListDesc:%String,hospDesc:%String") [ SqlProc ]
{
}

ClassMethod GetInvDtlPrtInfoExecute(ByRef qHandle As %Binary, invStr As %Text) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
 	set ind=1
 	set ^TMP("GetInvDtlPrtInfo")=invStr
 	
 	kill invDtlAry
 	
 	for i=1:1:$l(invStr,"!") {
		set myInvStr=$p(invStr,"!",i)
		continue:(myInvStr="")
		set invId=$p(myInvStr,":",1)
		set invType=$p(myInvStr,":",2)
		continue:((invId="")||(invType=""))
		if (invType="PRT") {
			do GetPrtInvInfo
		}else {
			do GetAccPInvInfo
		}
 	}
 	
 	set invIdx=0
	set papmi=0
	while($o(invDtlAry(papmi))) {
		set papmi=$o(invDtlAry(papmi))
		set patInfo=$g(invDtlAry(papmi))
	 	set patName=$lg(patInfo,1)
	 	set sex=$lg(patInfo,2)
	 	set patNo=$lg(patInfo,3)
		set invId=0
		while($o(invDtlAry(papmi,invId))) {
			set invId=$o(invDtlAry(papmi,invId))
			set dtlInfo=$g(invDtlAry(papmi,invId))
		  	set invNo=$lg(dtlInfo,1)
		  	set prtDate=$lg(dtlInfo,2)
		  	set userName=$lg(dtlInfo,3)
		  	set invIdx=$i(invIdx)
		  	set catDR=0
		  	while($o(invDtlAry(papmi,invId,catDR))) {
			  	set catDR=$o(invDtlAry(papmi,invId,catDR))
				set catDesc=$p($g(^DHCTarC("TOC",catDR)),"^",2)
			  	set tari=0
			  	while($o(invDtlAry(papmi,invId,catDR,tari))) {
				  	set tari=$o(invDtlAry(papmi,invId,catDR,tari))
					set data=$g(invDtlAry(papmi,invId,catDR,tari))
					set tariDesc=$p($g(^DHCTARI(tari)),"^",2)
					set price=$lg(data,1)
					set price=$fn(price,"",4)
					set qty=$lg(data,2)
					set qty=$fn(qty,"N")
					set total=$lg(data,3)
					set total=$fn(total,"",2)
					set patShare=$lg(data,4)
					set patShare=$fn(patShare,"",2)
					set ybzfbl=$lg(data,5)
					set medListCode=$lg(data,6)
					set medListDesc=$lg(data,7)
					do OutputPrtInfo
				}
			}
		}
	}
    
	quit $$$OK
GetPrtInvInfo
	set invInfo=$g(^DHCINVPRT(invId))
	quit:(invInfo="")
	set sum=$p(invInfo,"^",1)
	set prtDate=$p(invInfo,"^",5)
	set invNo=$p(invInfo,"^",14)
	set papmi=$p(invInfo,"^",15)
	set userDR=$p(invInfo,"^",21)
	set hospDR=$p(invInfo,"^",39) //2023-04-19 LUANZH 输出院区
	set hospDesc=$s((hospDR'=""):$p(^CT("HOSP",hospDR),"^",2),1:"")
	do GetInvPatInfo
	do GetInvDetails(invId)
	quit
GetAccPInvInfo
	set invInfo=$g(^DHCINVPRTAP(invId))
	quit:(invInfo="")
	set sum=$p(invInfo,"^",1)
	set prtDate=$p(invInfo,"^",3)
	set userDR=$p(invInfo,"^",5)
	set invNo=$p(invInfo,"^",6)
	set papmi=$p(invInfo,"^",11)
	set hospDR=$p(invInfo,"^",30) //2023-04-19 LUANZH 输出院区
	set hospDesc=$s((hospDR'=""):$p(^CT("HOSP",hospDR),"^",2),1:"")
	do GetInvPatInfo
	set accPConInv=0
	while($o(^DHCINVPRTCAPi(0,"APINVDR",invId,accPConInv))) {
		set accPConInv=$o(^DHCINVPRTCAPi(0,"APINVDR",invId,accPConInv))
		set prtRowId=$p($g(^DHCINVPRTCAP(accPConInv)),"^",1)
		do GetInvDetails(prtRowId)
	}
	quit
GetInvPatInfo
	set patName=$p($g(^PAPER(papmi,"ALL")),"^",1)
	set patNo=$p($g(^PAPER(papmi,"PAT",1)),"^",2)
	set sexDR=$p($g(^PAPER(papmi,"ALL")),"^",7)
	set sex=$s((sexDR'=""):$p(^CT("SEX",sexDR),"^",2),1:"")
	set prtDate=##class(websys.Conversions).DateLogicalToHtml(prtDate)
	set userName=$s((userDR'=""):$p(^SSU("SSUSR",userDR),"^",2),1:"")
	set $li(invDtlAry(papmi),1)=patName
	set $li(invDtlAry(papmi),2)=sex
	set $li(invDtlAry(papmi),3)=patNo
	set $li(invDtlAry(papmi,invId),1)=invNo
	set $li(invDtlAry(papmi,invId),2)=prtDate
	set $li(invDtlAry(papmi,invId),3)=userName
	quit
GetInvDetails(prtRowId)
	set insTypeDR=$p(^DHCINVPRT(prtRowId),"^",9)
	set hospDR=$p(^DHCINVPRT(prtRowId),"^",39)
	set billConInv=0
	while($o(^DHCBCI(0,"INV",prtRowId,billConInv))) {
		set billConInv=$o(^DHCBCI(0,"INV",prtRowId,billConInv))
		set conData=$g(^DHCBCI(billConInv))
		continue:(conData="")
		set pb=$p(conData,"^",2)
		continue:(+pb=0)
		set adm=$p(conData,"^",3)
		set pbo=0
		while($o(^DHCPB(pb,"O",pbo))) {
			set pbo=$o(^DHCPB(pb,"O",pbo))
			set pboData=$g(^DHCPB(pb,"O",pbo))
			continue:(pboData="")
			set oeitm=$p(pboData,"^",4)    //Zhan 20201027 下边TarItmLinkInsu函数要用的参数
			set pbd=0
			while($o(^DHCPB(pb,"O",pbo,"D",pbd))) {
				set pbd=$o(^DHCPB(pb,"O",pbo,"D",pbd))
				set pbdData=$g(^DHCPB(pb,"O",pbo,"D",pbd))
				continue:(pbdData="")
				set pbdRowId=pb_"||"_pbo_"||"_pbd
				set tariDR=$p(pbdData,"^",3)
				set price=$p(pbdData,"^",4)
				set qty=$p(pbdData,"^",5)
				set total=$p(pbdData,"^",7)
				set patShare=$p(pbdData,"^",10)
				set catSubDR=$p($g(^DHCTARI(tariDR)),"^",15)
				set catDR=$p($g(^DHCTarC("OC",catSubDR)),"^",3)
				set insuStr=##class(web.DHCINSUPort).TarItmLinkInsu(tariDR, insTypeDR, oeitm, adm, price, hospDR)
				set xmlb=$p(insuStr,"^",1)
			    set ybzfbl=$p(insuStr,"^",2)
			    set medListCode=$p(insuStr,"^",12)    //国家医保编码
				set medListDesc=$p(insuStr,"^",13)    //国家医保名称
			    if ((ybzfbl'="")&&(ybzfbl<1)) {
					set ybzfbl=(+ybzfbl*100)_"%"    //标准版取自付比例,项目上需要医保分类的话,另行修改
			    }
				set $li(invDtlAry(papmi,invId,catDR,tariDR),1)=price
				set $li(invDtlAry(papmi,invId,catDR,tariDR),2)=$lg($g(invDtlAry(papmi,invId,catDR,tariDR)),2)+qty
				set $li(invDtlAry(papmi,invId,catDR,tariDR),3)=$lg($g(invDtlAry(papmi,invId,catDR,tariDR)),3)+total
				set $li(invDtlAry(papmi,invId,catDR,tariDR),4)=$lg($g(invDtlAry(papmi,invId,catDR,tariDR)),4)+patShare
				set $li(invDtlAry(papmi,invId,catDR,tariDR),5)=ybzfbl
				set $li(invDtlAry(papmi,invId,catDR,tariDR),6)=medListCode
				set $li(invDtlAry(papmi,invId,catDR,tariDR),7)=medListDesc
			}
		}
	}
	quit
   
OutputPrtInfo
 	set Data=$lb(patName,sex,patNo,invNo,prtDate,userName,invIdx,catDesc,tariDesc,price,qty,total,patShare,ybzfbl,medListCode,medListDesc,hospDesc)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
 	quit
}

}
