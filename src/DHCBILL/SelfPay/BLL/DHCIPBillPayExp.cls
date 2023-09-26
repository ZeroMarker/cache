/// wangjian
/// 2018-03-20
/// 住院第三方及自助支付业务类
Class DHCBILL.SelfPay.BLL.DHCIPBillPayExp Extends %RegisteredObject
{

/// Creator: wangjian
/// CreatDate: 2018-03-14
/// Description: 根据卡号及日期查询就诊记录
/// Debug: w ##class(DHCBILL.SelfPay.BLL.DHCIPBillPayExp).GetIPAdmInfo("<Request><TradeCode>5001</TradeCode><HospitalID>2</HospitalID><CardNo></CardNo><CardType></CardType><SecrityNo></SecrityNo><PatientID>0000000262</PatientID><UserCode>cashier</UserCode><TerminalID>ZZJ001</TerminalID><AimFlag>Dep</AimFlag><StartDate></StartDate><EndDate></EndDate><ExpStr></ExpStr></Request>")
ClassMethod GetIPAdmInfo(Input As %String) As %Stream.GlobalCharacter
{
	Set $zt="GetIPAdmInfoET"
    Set InputObj=##class(DHCBILL.SelfPay.Entity.GetIPAdmInfo.Req.Request).%New()
    Do InputObj.XMLNodeDeserialize(.InputObj, "Request", Input)
    Set CardNo=InputObj.CardNo
    Set CardType=InputObj.CardType
    Set SecrityNo=InputObj.SecrityNo
    Set PatientNo=InputObj.PatientID
    Set MedicalNo=InputObj.MedicalNo
    Set UserCode=InputObj.UserCode
    Set TerminalID=InputObj.TerminalID
    Set AimFlag=InputObj.AimFlag
    Set StDate=InputObj.StartDate 
    Set EndDate=InputObj.EndDate
    Set HospitalID=InputObj.HospitalID
    
    If (HospitalID="") Set HospitalID=$o(^CT("HOSP",0))
 	If (StDate["-") Set StDate=$zdh(StDate,3)
    If (EndDate["-") Set EndDate=$zdh(EndDate,3)
    
    Set UserID=""
    If (UserCode'="") {
	    Set UserCode=$$ALPHAUP^SSUTIL4(UserCode)
	    Set UserID=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,""))
	}
    
 	Set OutputObj=##class(DHCBILL.SelfPay.Entity.GetIPAdmInfo.Res.Response).%New()
 	
	If ((CardNo="")&&(PatientNo="")&&(MedicalNo="")){
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "卡号和登记号不能都为空")
		Quit OutputXML
	}
	
	If ((UserID="")||('$d(^SSU("SSUSR",UserID)))){
	 	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj,  -2, "用户代码传入有误")
		Quit OutputXML
	}
	Set GLoc=$p($g(^SSU("SSUSR",UserID)),"^",4)
	Set Grup=$p($g(^SSU("SSUSR",UserID)),"^",5)
	
	Set PatientId=""
	Set PatInfo=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).GetPatCommInfo(CardNo, CardType, SecrityNo, PatientNo)
	If (" 0 -201 "[(" "_$p(PatInfo,"^",1)_" ")) {
		Set PatientId=$p(PatInfo,"^",8)
	}
	If ((PatientId="")&&(MedicalNo'="")) {
		Set PatientId=##class(DHCWMR.IO.OutService).IGetPatientIDByMrNo(MedicalNo, "I", HospitalID, "")
	}
	If (PatientId="") {
	 	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "患者信息传入有误")
		Quit OutputXML
	}
	
	If (AimFlag="Dep") {
		//默认找在院就诊,无在院就诊找最近一次未结算就诊记录
		Set InAdm=""
		Set Adm=""
		While($o(^PAPERdr(PatientId,"ADM","I",Adm),-1)) {
			Set Adm=$o(^PAPERdr(PatientId,"ADM","I",Adm),-1)
			Set VisitStatus=$p(^PAADM(Adm),"^",20)
			Continue:(VisitStatus="C")
			If (VisitStatus="A") {
				Set InAdm=Adm
				Quit
			}
			Set NoPayNum=##class(web.UDHCJFBaseCommon).JudgeBillNum(Adm)
			If ((InAdm="")&&(NoPayNum>0)) {
				Set InAdm=Adm   //只找最近一次未结算就诊
				Quit
			}
		}
		If (InAdm="") {
			Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "无可交押金就诊记录")
			Quit OutputXML
		}

		Set AdmInfoObj=##class(DHCBILL.SelfPay.Entity.GetIPAdmInfo.Res.AdmInfo).%New()
		Set (BillNo, AdmReason, NationalCode, TotalAmount, DepositAmount, DepositBalance)=""
		Set AdmDate=$p(^PAADM(InAdm),"^",6)
		Set AdmDate=$zd(AdmDate,3)
		Set AdmDeptDr=$p(^PAADM(InAdm),"^",4)
		Set AdmDept=$s((+AdmDeptDr'=0):$p($g(^CTLOC(AdmDeptDr)),"^",2),1:"")
		Set AdmReasonDr=$p(^PAADM(InAdm,1),"^",7)
		If (AdmReasonDr'="") {
			Set NationalCode=$p(^PAC("ADMREA",AdmReasonDr),"^",5)
			Set AdmReason=$p(^PAC("ADMREA",AdmReasonDr),"^",2)
		}
		Set TotalAmount=##class(DHCBILL.SelfPay.BLL.DHCIPBillPayLogic).TotalAmount(InAdm)
		Set DepositAmount=##class(DHCBILL.SelfPay.BLL.DHCIPBillPayLogic).Deposit(InAdm)
		Set DepositBalance=DepositAmount-TotalAmount
		
		Set PB=0
		While($o(^DHCPB(0,"ADM",InAdm,PB))) {
			Set PB=$o(^DHCPB(0,"ADM",InAdm,PB))
			Set PBPayFlag=$p(^DHCPB(PB),"^",16)
			Continue:(PBPayFlag="P")
			Set BillNo=PB
			Quit
		}

		Set AdmInfoObj.AdmID=InAdm
		Set AdmInfoObj.AdmDate=AdmDate
		Set AdmInfoObj.AdmDept=AdmDept
		Set AdmInfoObj.BillNo=BillNo
		Set AdmInfoObj.AdmReason=AdmReason
		Set AdmInfoObj.NationalCode=NationalCode
		Set AdmInfoObj.TotalAmount=TotalAmount
		Set AdmInfoObj.DepositAmount=DepositAmount
		Set AdmInfoObj.DepositBalance=DepositBalance

		Do OutputObj.AdmInfoList.Insert(AdmInfoObj)
		
		Set BaseInfo=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).GetPatBaseInfo(PatientId, HospitalID)
	    Set OutputObj.PatientID=$p(BaseInfo,"^",2)
	    Set OutputObj.PatientName=$p(BaseInfo,"^",3)
	    Set OutputObj.Sex=$p(BaseInfo,"^",4)
	    Set OutputObj.DOB=$p(BaseInfo,"^",5)
	    Set OutputObj.Medical=$p(BaseInfo,"^",7)
	    Set OutputObj.CredType=$p(BaseInfo,"^",9)
	    Set OutputObj.CredNo=$p(BaseInfo,"^",10)

		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, 0, "成功")
		Quit OutputXML
	    
    }ElseIf(AimFlag="Pay"){
	   	//找到未结算就诊记录,如果两个以上未结算账单合并账单或不予结算，并进行出院费用核查
	    Set NotPayAdm=""
	    Set NoPayNum=0
	    Set Adm=""
	    While($o(^PAPERdr(PatientId,"ADM","I",Adm),-1)) {
		    Set Adm=$o(^PAPERdr(PatientId,"ADM","I",Adm),-1)
		 	Set VisitStatus=$p(^PAADM(Adm),"^",20)
		    Continue:(VisitStatus'="D")
		    Set NoPayNum=##class(web.UDHCJFBaseCommon).JudgeBillNum(Adm)
		    Continue:(+NoPayNum=0)
		    Set NotPayAdm=Adm
		}
	    
		if (NotPayAdm="") {
			Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "患者未出院或无可结算出院记录")
			Quit OutputXML
		}
	    
	    //多个账单不予结算;尝试合并账单或者返回根据医院需求???
		if (+NoPayNum>1) {
			Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -2, "存在多个未结算账单请到窗口结算")
			Quit OutputXML
		}
	    
	    Set (AdmDate, AdmDept, BillNo, AdmReason, NationalCode, TotalAmount, DepositAmount, DepositBalance)=""
	    
	    //模拟前台账单
	    Do ##class(web.UDHCJFBILL).BILL(NotPayAdm, UserID)
	    
	    Set PB=0
	    While($o(^DHCPB(0,"ADM",NotPayAdm,PB))) {
		    Set PB=$o(^DHCPB(0,"ADM",NotPayAdm,PB))
		    Set PBPayFlag=$p(^DHCPB(PB),"^",16)
			Continue:(PBPayFlag="P")
			Set BillNo=PB
			Quit
		}

	    //出院结算费用核查 封装到一个地方 不符合出院条件直接返回不和条件原因
	    Set DisChargeInfo=##class(DHCBILL.SelfPay.BLL.DHCIPBillPayLogic).CheckFee(NotPayAdm, BillNo)
	    Set DisChargeFlag=$p(DisChargeInfo,"^",1)
	    If (+DisChargeFlag'=0) {
			Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, +DisChargeFlag, $p(DisChargeInfo,"^",2))
			Quit OutputXML
		}
		
		Set AdmDate=$p(^PAADM(NotPayAdm),"^",6)
		Set AdmDate=$zd(AdmDate,3)
		Set AdmDeptDr=$p(^PAADM(NotPayAdm),"^",4)
		Set AdmDept=$s((AdmDeptDr'=""):$p(^CTLOC(AdmDeptDr),"^",2),1:"")
		Set AdmReasonDr=$p(^PAADM(NotPayAdm,1),"^",7)
		If (AdmReasonDr'="") {
			Set NationalCode=$p(^PAC("ADMREA",AdmReasonDr),"^",5)
			Set AdmReason=$p(^PAC("ADMREA",AdmReasonDr),"^",2)
		}

		Set TotalAmount=##class(DHCBILL.SelfPay.BLL.DHCIPBillPayLogic).TotalAmount(NotPayAdm)
		Set DepositAmount=##class(DHCBILL.SelfPay.BLL.DHCIPBillPayLogic).Deposit(NotPayAdm)
		Set DepositBalance=DepositAmount-TotalAmount
		
		Set AdmInfoObj=##class(DHCBILL.SelfPay.Entity.GetIPAdmInfo.Res.AdmInfo).%New()
		Set AdmInfoObj.AdmID=NotPayAdm
		Set AdmInfoObj.AdmDate=AdmDate
		Set AdmInfoObj.AdmDept=AdmDept
		Set AdmInfoObj.BillNo=BillNo
		Set AdmInfoObj.AdmReason=AdmReason
		Set AdmInfoObj.NationalCode=NationalCode
		Set AdmInfoObj.TotalAmount=$fn(TotalAmount,"",2)
		Set AdmInfoObj.DepositAmount=$fn(DepositAmount,"",2)
		Set AdmInfoObj.DepositBalance=$fn(DepositBalance,"",2)
		Do OutputObj.AdmInfoList.Insert(AdmInfoObj)
		
		Set BaseInfo=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).GetPatBaseInfo(PatientId, HospitalID)
	    Set OutputObj.PatientID=$p(BaseInfo,"^",2)
	    Set OutputObj.PatientName=$p(BaseInfo,"^",3)
	    Set OutputObj.Sex=$p(BaseInfo,"^",4)
	    Set OutputObj.DOB=$p(BaseInfo,"^",5)
	    Set OutputObj.Medical=$p(BaseInfo,"^",7)
	    Set OutputObj.CredType=$p(BaseInfo,"^",9)
	    Set OutputObj.CredNo=$p(BaseInfo,"^",10)

		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, 0, "成功")
		Quit OutputXML
    }Else {
		Set Adm=""
		While($o(^PAPERdr(PatientId,"ADM","I",Adm),-1)) {
			Set Adm=$o(^PAPERdr(PatientId,"ADM","I",Adm),-1)
			Set VisitStatus=$p(^PAADM(Adm),"^",20)
		    Continue:(VisitStatus="C")
			Set (BillNo, AdmReason, NationalCode, TotalAmount, DepositAmount, DepositBalance)=""
			Set AdmDate=$p(^PAADM(Adm),"^",6)
			Set AdmDate=$zd(AdmDate,3)
			Set AdmDeptDr=$p(^PAADM(Adm),"^",4)
			Set AdmDept=$s((+AdmDeptDr'=0):$p($g(^CTLOC(AdmDeptDr)),"^",2),1:"")
			Set AdmReasonDr=$p(^PAADM(Adm,1),"^",7)
			If (AdmReasonDr'="") {
				Set NationalCode=$p(^PAC("ADMREA",AdmReasonDr),"^",5)
				Set AdmReason=$p(^PAC("ADMREA",AdmReasonDr),"^",2)
			}
			Set TotalAmount=##class(DHCBILL.SelfPay.BLL.DHCIPBillPayLogic).AllTotalAmount(Adm)
			Set DepositAmount=0
			Set DepositBalance=0  //DepositAmount-TotalAmount
			Set AdmInfoObj=##class(DHCBILL.SelfPay.Entity.GetIPAdmInfo.Res.AdmInfo).%New()
			Set AdmInfoObj.AdmID=Adm
			Set AdmInfoObj.AdmDate=AdmDate
			Set AdmInfoObj.AdmDept=AdmDept
			Set AdmInfoObj.BillNo=BillNo
			Set AdmInfoObj.AdmReason=AdmReason
			Set AdmInfoObj.NationalCode=NationalCode
			Set AdmInfoObj.TotalAmount=TotalAmount
			Set AdmInfoObj.DepositAmount=DepositAmount
			Set AdmInfoObj.DepositBalance=DepositBalance
			Do OutputObj.AdmInfoList.Insert(AdmInfoObj)
		}
		
		Set BaseInfo=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).GetPatBaseInfo(PatientId, HospitalID)
	    Set OutputObj.PatientID=$p(BaseInfo,"^",2)
	    Set OutputObj.PatientName=$p(BaseInfo,"^",3)
	    Set OutputObj.Sex=$p(BaseInfo,"^",4)
	    Set OutputObj.DOB=$p(BaseInfo,"^",5)
	    Set OutputObj.Medical=$p(BaseInfo,"^",7)
	    Set OutputObj.CredType=$p(BaseInfo,"^",9)
	    Set OutputObj.CredNo=$p(BaseInfo,"^",10)
	    
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, 0, "成功")
		Quit OutputXML
	}
    
GetIPAdmInfoET
	Set $zt=""
    Set OutputObj=##class(DHCBILL.SelfPay.Entity.GetIPAdmInfo.Res.Response).%New()
	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -99, "程序处理错误:"_$ze)
	Quit OutputXML
}

/// Creator: wangjian
/// CreatDate: 2018-03-14
/// Description: 根据卡号及日期查询就诊记录
/// Debug: w ##class(DHCBILL.SelfPay.BLL.DHCIPBillPayExp).AddIPDeposit("<Request><TradeCode></TradeCode><HospitalID></HospitalID><CardNo>0000030201</CardNo><CardType></CardType><SecrityNo></SecrityNo><PatientID></PatientID><UserCode>sf01</UserCode><TerminalID>ZZJ001</TerminalID><AdmID>3435</AdmID><PayDetails><PayModeCode>CASH</PayModeCode><TradeChannel></TradeChannel><PayAccountNo>smk12345</PayAccountNo><PayAmt>1000</PayAmt><PlatformNo>2018032219013000001</PlatformNo><OutPayNo>201803221902</OutPayNo><PayChannel>CASH</PayChannel><POSPayStr></POSPayStr><PayDate>2018-05-05</PayDate><PayTime>22:24:22</PayTime></PayDetails><ExpStr></ExpStr></Request>")
ClassMethod AddIPDeposit(Input As %String) As %Stream.GlobalCharacter
{
	Set $zt="AddIPDepositET"
    Set InputObj=##class(DHCBILL.SelfPay.Entity.AddIPDeposit.Req.Request).%New()
    Do InputObj.XMLNodeDeserialize(.InputObj, "Request", Input)
    Set CardNo=InputObj.CardNo
    Set CardType=InputObj.CardType
    Set SecrityNo=InputObj.SecrityNo
    Set PatientNo=InputObj.PatientID
    Set MedicalNo=InputObj.MedicalNo
    Set UserCode=InputObj.UserCode
    Set TerminalID=InputObj.TerminalID
    Set HospitalID=InputObj.HospitalID
    Set AdmID=InputObj.AdmID
    #dim PayDetailsObj As DHCBILL.SelfPay.Entity.AddIPDeposit.Req.PayDetails
    Set PayDetailsObj=InputObj.PayDetails
    Set Amount=""
    Set PayModeCode=""
    Set TradeChannel=""
    If ($IsObject(PayDetailsObj)) {
		Set Amount=PayDetailsObj.PayAmt
	    Set PayModeCode=PayDetailsObj.PayModeCode
	    Set TradeChannel=PayDetailsObj.TradeChannel
	}
    
    If (HospitalID="") Set HospitalID=$o(^CT("HOSP",0))
    
    Set UserID=""
    If (UserCode'="") {
	    Set UserCode=$$ALPHAUP^SSUTIL4(UserCode)
	    Set UserID=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,""))
	}
    
 	Set OutputObj=##class(DHCBILL.SelfPay.Entity.AddIPDeposit.Res.Response).%New()
 	
	If ((CardNo="")&&(PatientNo="")&&(MedicalNo="")){
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "卡号和登记号不能都为空", 1)
		Quit OutputXML
	}
	
	If ((UserID="")||('$d(^SSU("SSUSR",UserID)))){
	 	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "用户代码传入有误", 1)
		Quit OutputXML
	}
	Set GLoc=$p($g(^SSU("SSUSR",UserID)),"^",4)
	Set Grup=$p($g(^SSU("SSUSR",UserID)),"^",5)
	
	Set PatientId=""
	Set PatInfo=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).GetPatCommInfo(CardNo, CardType, SecrityNo, PatientNo)
	If (" 0 -201 "[(" "_$p(PatInfo,"^",1)_" ")) {
		Set PatientId=$p(PatInfo,"^",8)
	}
	
	If ((PatientId="")&&(MedicalNo'="")) {
		Set PatientId=##class(DHCWMR.IO.OutService).IGetPatientIDByMrNo(MedicalNo, "I", HospitalID, "")
	}
	
	If (PatientId="") {
	 	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "患者信息传入有误", 1)
		Quit OutputXML
	}
	
	If (AdmID="") {
	 	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "就诊号不能为空", 1)
		Quit OutputXML
	}
	Set VisitStatus=$p(^PAADM(AdmID),"^",20)
	Set NoPayNum=##class(web.UDHCJFBaseCommon).JudgeBillNum(AdmID)
	If ((VisitStatus'="A")&&(NoPayNum=0)) {
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "此就诊不能交押金", 1)
		Quit OutputXML
	}
	
	Set RetCode=0
	
	ts
	
	//申请交易流水
	Set TradeType="DEP"
	Set TExpstr=UserID_"^"_Grup_"^"_GLoc_"^"_HospitalID_"^"_TerminalID_"^"_TradeType
	Set RtnValue=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).SetHISTradeNo(CardNo, AdmID, "", "C", Amount, TExpstr)
	If (+$p(RtnValue,"^",1)) {
	   	tro
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, +$p(RtnValue,"^",1), "HIS创建交易流水号失败", 1)
		Quit OutputXML
	}
	Set ETPRowID=$p(RtnValue,"^",2)
	Set OrderNo=$p(RtnValue,"^",3)
	
	Set myExpStr=UserID_"^"_Grup_"^"_GLoc_"^"_HospitalID_"^"_TerminalID_"^"_TradeType_"^"_TradeChannel
	Set RtnValue=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).SavePayInfo(OrderNo, "", .PayDetailsObj, myExpStr)
	If (+$p(RtnValue,"^",1)){
	   	tro
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, +$p(RtnValue,"^",1), "保存支付信息失败", 1)
		Quit OutputXML
	}

	/*
	//走收据的放开
    Set ReceiptNoStr=##class(web.UDHCJFBaseCommon).GetRcptNo(UserID, HospitalID)
    Set ReceiptId=$p(ReceiptNoStr,"^",1)
    Set CurNo=$p(ReceiptNoStr,"^",3)
	*/
    
    Set Paymode=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).TransPaymodeByOutCode(PayModeCode)
    Set DepTypeId=$o(^ARC("ARCDT",0,"Code","01",0))    //住院押金
    Set myRemark=""
    Set myTransfer=""
    Set myRefArrcpId=""
    Set myInitDepId=""
    Set myCurNoType=1
    Set DepStr=DepTypeId_"^"_Amount_"^"_AdmID_"^"_myRemark_"^"_myTransfer
    Set DepStr=DepStr_"^"_myRefArrcpId_"^"_myInitDepId_"^"_myCurNoType
    
	Set myBankId=""
    Set myChequeNo=""
    Set myBankCardId=""
    Set myUnitId=""
    Set myChequeDate=""
    Set myPayAccNo=""
    Set PayMStr=Paymode_"^"_myBankId_"^"_myChequeNo_"^"_myBankCardId_"^"_myUnitId
    Set PayMStr=PayMStr_"^"_myChequeDate_"^"_myPayAccNo_"^"_Amount_"^"_"^"_"^"_"^"_ETPRowID
    
    Set SessionStr=UserID_"^"_Grup_"^"_GLoc_"^"_HospitalID
    
    Set RtnValue=##class(web.DHCIPBillDeposit).InsertDeposit(DepStr, PayMStr, SessionStr)  //交押金
	If (+$p(RtnValue,"^",1)) {
	   	tro
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, +$p(RtnValue,"^",1), "交押金失败", 1)
		Quit OutputXML
	}
    Set PrtRowID=$p(RtnValue,"^",2)
	
	If ($tl>0) tc
	
	Set TotalAmt=##class(DHCBILL.SelfPay.BLL.DHCIPBillPayLogic).TotalAmount(AdmID)
	Set DepositAmt=##class(DHCBILL.SelfPay.BLL.DHCIPBillPayLogic).Deposit(AdmID)
	Set OutputObj.SerialNo=OrderNo
	Set OutputObj.DepositAmount=DepositAmt
	Set OutputObj.DepositBalance=$fn((DepositAmt-TotalAmt),"",2)
	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, 0, "成功")
	Quit OutputXML
	
AddIPDepositET
	Set $zt=""
	If ($tl>0) tro
    Set OutputObj=##class(DHCBILL.SelfPay.Entity.AddIPDeposit.Res.Response).%New()
	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -99, "程序处理错误:"_$ze)
	Quit OutputXML
}

/// Creator: wangjian
/// CreatDate: 2018-03-14
/// Description: 根据卡号及日期查询就诊记录
/// Debug: w ##class(DHCBILL.SelfPay.BLL.DHCIPBillPayExp).GetIPDepRecord("<Request><TradeCode></TradeCode><HospitalID></HospitalID><CardNo>0000030201</CardNo><CardType></CardType><SecrityNo></SecrityNo><PatientID></PatientID><UserCode>sf01</UserCode><TerminalID>ZZJ001</TerminalID><AdmID>243</AdmID><ExpStr></ExpStr></Request>")
ClassMethod GetIPDepRecord(Input As %String) As %Stream.GlobalCharacter
{
	Set $zt="GetIPDepRecordET"
    Set InputObj=##class(DHCBILL.SelfPay.Entity.GetIPDepRecord.Req.Request).%New()
    Do InputObj.XMLNodeDeserialize(.InputObj, "Request", Input)
    Set CardNo=InputObj.CardNo
    Set CardType=InputObj.CardType
    Set SecrityNo=InputObj.SecrityNo
    Set PatientNo=InputObj.PatientID
    Set MedicalNo=InputObj.MedicalNo
    Set UserCode=InputObj.UserCode
    Set TerminalID=InputObj.TerminalID
    Set StDate=InputObj.StartDate
    Set EndDate=InputObj.EndDate
    Set HospitalID=InputObj.HospitalID
    Set AdmID=InputObj.AdmID
    If (HospitalID="") Set HospitalID=$o(^CT("HOSP",0))
    
    Set UserID=""
    If (UserCode'="") {
	    Set UserCode=$$ALPHAUP^SSUTIL4(UserCode)
	    Set UserID=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,""))
	}
    
 	Set OutputObj=##class(DHCBILL.SelfPay.Entity.GetIPDepRecord.Res.Response).%New()
 	
	If ((CardNo="")&&(PatientNo="")&&(MedicalNo="")) {
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "卡号和登记号不能都为空")
		Quit OutputXML
	}
	
	If ((UserID="")||('$d(^SSU("SSUSR",UserID)))) {
	 	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "用户代码传入有误")
		Quit OutputXML
	}
	Set GLoc=$p($g(^SSU("SSUSR",UserID)),"^",4)
	Set Grup=$p($g(^SSU("SSUSR",UserID)),"^",5)
	
	Set PatientId=""
	Set PatInfo=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).GetPatCommInfo(CardNo, CardType, SecrityNo, PatientNo)
	If (" 0 -201 "[(" "_$p(PatInfo,"^",1)_" ")) {
		Set PatientId=$p(PatInfo,"^",8)
	}
	If ((PatientId="")&&(MedicalNo'="")) {
		Set PatientId=##class(DHCWMR.IO.OutService).IGetPatientIDByMrNo(MedicalNo, "I", HospitalID, "")
	}
	
	If (PatientId="") {
	 	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -3, "患者信息传入有误")
		Quit OutputXML
	}
	
	If (AdmID="") {
	 	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -43, "就诊号不能为空")
		Quit OutputXML
	}
	
	Set DepNum=0
	Set DepRowId=0
	While($o(^DHCSFPRINTDETAIL(0,"adm",AdmID,DepRowId))) {
		Set DepRowId=$o(^DHCSFPRINTDETAIL(0,"adm",AdmID,DepRowId))
		Set DepData=$g(^DHCSFPRINTDETAIL(DepRowId))
		Set PrtStatus=$p(DepData,"^",8)
	    Continue:(PrtStatus'=1)
		Set ReceiptNo=$p(DepData,"^",1)
		Set PayDate=$p(DepData,"^",2)
		Set PayTime=$p(DepData,"^",3)
	    Set PayAmout=$p(DepData,"^",6)
	    Set PaymSub=$o(^DHCSFPRINTDETAIL(DepRowId,"P",0))
		Set PaymSubData=$g(^DHCSFPRINTDETAIL(DepRowId,"P",+PaymSub))
		Set PayModeDR=$p(PaymSubData,"^",1)
		Set PayMode=$s((+PayModeDR'=0):$p($g(^CT("CTPM",PayModeDR)),"^",2),1:"")
	    Set PrtUserDr=$p(DepData,"^",14)
	    Set PayUserCode=$p($g(^SSU("SSUSR",PrtUserDr)),"^",1)
	    Set PayUserName=$p($g(^SSU("SSUSR",PrtUserDr)),"^",2)
	    Set PayWardDr=$p(DepData,"^",36)
	    Set PayWard=$s((PayWardDr'=""):$p(^PAWARD(PayWardDr),"^",2),1:"")
	    Set PayDeptDr=$p(DepData,"^",37)
	    Set PayDept=$s((PayDeptDr'=""):$p(^CTLOC(PayDeptDr),"^",2),1:"")
	    Set PaidFlag=$p(DepData,"^",38)
	    Set Remark=""
	    Set RecordObj=##class(DHCBILL.SelfPay.Entity.GetIPDepRecord.Res.Record).%New()
	    Set RecordObj.PayDate=$zd(PayDate,3)
	    Set RecordObj.PayTime=$zt(PayTime,1)
	    Set RecordObj.PayAmout=$fn(PayAmout,"",2)
	    Set RecordObj.PayFlag=$case(PaidFlag,"Y":"已使用",:"正常")
	    Set RecordObj.PayMode=PayMode
	    Set RecordObj.ReceiptNo=ReceiptNo
	    Set RecordObj.PayUserCode=PayUserCode
	    Set RecordObj.PayUserName=PayUserName
	    Set RecordObj.PayDept=PayDept
	    Set RecordObj.PayWard=PayWard
	    Set RecordObj.Remark=Remark
	    Set DepNum=$i(DepNum)
	    Do OutputObj.RecordList.Insert(RecordObj)
	    Do RecordObj.%Close()
	}
	Set OutputObj.RecordCount=DepNum
    
    Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, 0, "成功")
	Quit OutputXML
	
GetIPDepRecordET
	Set $zt=""
    Set OutputObj=##class(DHCBILL.SelfPay.Entity.GetIPDepRecord.Res.Response).%New()
	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -99, "程序处理错误:"_$ze)
	Quit OutputXML
}

/// Creator: ZhYW
/// CreatDate: 2022-10-26
/// Description: 入院登记
/// Debug: w ##class(DHCBILL.SelfPay.BLL.DHCIPBillPayExp).IPRegister("<Request><TradeCode>5011</TradeCode><HospitalID></HospitalID><UserCode>reg</UserCode><CardNo>3219858836</CardNo><CardType>25</CardType><SecrityNo></SecrityNo><PatientID>0000832358</PatientID><IPBookID>173</IPBookID></Request>").Read()
ClassMethod IPRegister(Input As %String) As %Stream.GlobalCharacter
{
	set $zt="IPRegisterET"
    set InputObj=##class(DHCBILL.SelfPay.Entity.IPRegister.Req.Request).%New()
    do InputObj.XMLNodeDeserialize(.InputObj, "Request", Input)
    set CardNo=InputObj.CardNo
    set CardType=InputObj.CardType
    set SecrityNo=InputObj.SecrityNo
    set PatientNo=InputObj.PatientID
    set MedicalNo=InputObj.MedicalNo
    set UserCode=InputObj.UserCode
    set TerminalID=InputObj.TerminalID
    set HospitalID=InputObj.HospitalID
	set IPBookID=InputObj.IPBookID     //住院证ID
	set HospitalID=$s((+InputObj.HospitalID'=0):InputObj.HospitalID,1:$o(^CT("HOSP",0)))   //多院区时院区Id必传
	set AdmReason=$s((+InputObj.AdmReason'=0):InputObj.AdmReason,1:1)  //未传费别是默认全自费
	do InputObj.%Close()
	
	set OutputObj=##class(DHCBILL.SelfPay.Entity.IPRegister.Res.Response).%New()
	
	if ((CardNo="")&&(PatientNo="")&&(MedicalNo="")) {
		set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, "-1", "卡号、登记号不能都为空")
		quit OutputXML
	}
	
    set UserID=""
    if (UserCode'="") {
	    set UserCode=$$ALPHAUP^SSUTIL4(UserCode)
	    set UserID=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,""))
	}
	if ((UserID="")||('$d(^SSU("SSUSR",UserID)))) {
	 	set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, "-2", "用户代码传入有误")
		quit OutputXML
	}
	
	set GLoc=$p($g(^SSU("SSUSR",UserID)),"^",4)
	set Grup=$p($g(^SSU("SSUSR",UserID)),"^",5)
	
	set PatientId=""
	set PatInfo=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).GetPatCommInfo(CardNo, CardType, SecrityNo, PatientNo)
	if (" 0 -201 "[(" "_$p(PatInfo,"^",1)_" ")) {
		set PatientId=$p(PatInfo,"^",8)
	}
	if ((PatientId="")&&(MedicalNo'="")) {
		set PatientId=##class(DHCWMR.IO.OutService).IGetPatientIDByMrNo(MedicalNo, "I", HospitalID, "")
	}
	if (PatientId="") {
	 	set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "患者信息传入有误")
		quit OutputXML
	}
	
	/*
    if (IPBookID="") {
		set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -7, "住院证ID为空")
		quit OutputXML
	}
	*/
	
	set SessionStr=UserID_"^"_Grup_"^"_GLoc_"^"_HospitalID
	
	set RegJsonStream=##class(web.DHCIPBillReg).GetRegInfo(PatientId, IPBookID, SessionStr)
	do RegJsonStream.Rewind()
	if (+RegJsonStream.success) {
		set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, RegJsonStream.success, RegJsonStream.msg)
		quit OutputXML
	}
	set PatJson=RegJsonStream.PatInfo
	set AdmJson=RegJsonStream.AdmInfo
	set IPBookJson=RegJsonStream.IPBookInfo
	
	if (+PatJson.success) {
		set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, PatJson.success, PatJson.msg)
		quit OutputXML
	}
	
	//基本信息对象
	set PersonObj=##class(BILL.IP.DTO.Entity.Reg.PAPerson).%New()
	set PersonObjJsonStr=##class(web.DHCBillCommon).GetClsPropJson("BILL.IP.DTO.Entity.Reg.PAPerson")
	set PersonObjJson=##class(%DynamicObject).%FromJSON(PersonObjJsonStr)
	set iter=PersonObjJson.%GetIterator()
   	while iter.%GetNext(.key, .value) {
   		do PersonObj.%Set(key, PatJson.%Get(key))
   	}
	set PersonXML=""
	do PersonObj.XMLExportToString(.PersonXML, "PAPerson")

	//基本信息扩展串对象
	set PersonExpObj=##class(BILL.IP.DTO.Entity.Reg.PAPersonExp).%New()
	set PersonExpObjJsonStr=##class(web.DHCBillCommon).GetClsPropJson("BILL.IP.DTO.Entity.Reg.PAPersonExp")
	set PersonExpObjJson=##class(%DynamicObject).%FromJSON(PersonExpObjJsonStr)
	set iter=PersonExpObjJson.%GetIterator()
   	while iter.%GetNext(.key, .value) {
   		do PersonExpObj.%Set(key, PatJson.%Get(key))
   	}
	set PersonExpXML=""
	do PersonExpObj.XMLExportToString(.PersonExpXML, "PAPersonExp")

	//就诊对象
	set AdmObj=##class(BILL.IP.DTO.Entity.Reg.PAAdm).%New()
	set AdmObjJsonStr=##class(web.DHCBillCommon).GetClsPropJson("BILL.IP.DTO.Entity.Reg.PAAdm")
	set AdmObjJson=##class(%DynamicObject).%FromJSON(AdmObjJsonStr)
	set iter=AdmObjJson.%GetIterator()
   	while iter.%GetNext(.key, .value) {
	   	if ((" Dept Ward Doctor "[(" "_key_" "))&&(InputObj.%Get(key)'="")) {
		   	do AdmObj.%Set(key, InputObj.%Get(key))   //传入的科室、病区、主管医生优先级高
		   	continue
		}
   		do AdmObj.%Set(key, IPBookJson.%Get(key))
   	}
	set AdmObj.AdmCategory=##class(web.DHCIPBillReg).GetDefAdmCatId()    //入院情况
	set AdmObj.AdmReason=AdmReason
	set AdmObj.DiagnosType=##class(web.DHCIPBillReg).GetRegDiagTypeId()   //入院诊断类型RowId
	set AdmXML=""
	do AdmObj.XMLExportToString(.AdmXML, "PAAdm")
	
	//photoStream Base64身份证照片信息
	&SQL(
		SELECT PAPER_Photo
		INTO :photoStream
		FROM PA_Person
		WHERE %ID = :PatientId
	)
	set ExpStr=photoStream
	
	if (+IPBookID'=0) {
		set EpisodeID=IPBookJson.EpisodeID
		if (+EpisodeID'=0) {
			set visitStatus=$p($g(^PAADM(EpisodeID)),"^",20)
			if (visitStatus'="P") {
				set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "不能选择"_$case(visitStatus,"A":"在院","C":"退院","P":"预住院","D":"出院",:"未知")_"就诊办理入院")
				quit OutputXML
			}
			//预住院转住院
			set RtnValue=##class(web.DHCBillPreIPAdmTrans).Trans2IPFromReg(PersonXML, PersonExpXML, AdmXML, SessionStr, ExpStr)
			set Rtn=$p(RtnValue,"^",1)
			if (+Rtn) {
				set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, +Rtn, $p(RtnValue,"^",2))
				quit OutputXML
			}
			set mrNo=##class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID, "I", "")
			set OutputObj.EpisodeID=EpisodeID
			set OutputObj.MedicareNo=mrNo
			set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, 0, $p(RtnValue,"^",2))
			quit OutputXML
		}
	}
	
	//入院登记
	set RtnValue=##class(web.DHCIPBillReg).SaveRegInfo(PersonXML, PersonExpXML, AdmXML, SessionStr, ExpStr)
	set Rtn=$p(RtnValue,"^",1)
	if (+Rtn) {
		set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, +Rtn, $p(RtnValue,"^",2))
		quit OutputXML
	}
	set EpisodeID=$p(RtnValue,"^",4)
	set mrNo=##class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID, "I", "")
	set OutputObj.EpisodeID=EpisodeID
	set OutputObj.MedicareNo=mrNo
	set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, 0, $p(RtnValue,"^",2))
	quit OutputXML
IPRegisterET
	set $zt=""
    set OutputObj=##class(DHCBILL.SelfPay.Entity.IPRegister.Res.Response).%New()
	set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -99, "程序处理错误:"_$ze)
	quit OutputXML
}

/// Creator: wangjian
/// CreatDate: 2017-11-28
/// Description: 通过卡号获取患者入院基本信息和就诊信息
/// Debug: w ##class(DHCBILL.SelfPay.BLL.DHCIPBillPayExp).GetIPRegInfo("<Request><PatientCard>10380399</PatientCard><CardType>2</CardType><SecrityNo></SecrityNo><PatientID></PatientID><HospitalID>2</HospitalID><ExtUserID>JS001</ExtUserID></Request>")
ClassMethod GetIPRegInfo(Input As %String) As %Stream.GlobalCharacter
{
	set $ZT="GetIPRegInfoET"
	Set InputObj=##class(DHCBILL.SelfPay.Entity.GetIPAdmInfo.Req.Request).%New()
    Do InputObj.XMLNodeDeserialize(.InputObj, "Request", Input)
    Set CardNo=InputObj.CardNo
    Set CardType=InputObj.CardType
    Set SecrityNo=InputObj.SecrityNo
    Set PatNo=InputObj.PatientID
    Set UserCode=InputObj.UserCode
    Set HospitalID=InputObj.HospitalID
    Set MedicalNo=InputObj.MedicalNo
	Do InputObj.%Close()
	
	Set OutputXML=""
	Set OutputObj=##class(DHCBILL.SelfPay.Entity.GetIPAdmInfo.Res.Response).%New()
 	
	If ((CardNo="")&&(PatNo="")){
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "卡号和登记号不能都为空")
		Quit OutputXML
	}
	Set PatientId=""
	Set PatInfo=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).GetPatCommInfo(CardNo, CardType, SecrityNo, PatNo)
	If (" 0 -201 "[(" "_$p(PatInfo,"^",1)_" ")) {
		Set PatientId=$p(PatInfo,"^",8)
	}	
	If ((PatientId="")&&(MedicalNo'="")) {
		Set PatientId=##class(DHCWMR.IO.OutService).IGetPatientIDByMrNo(MedicalNo, "I", HospitalID, "")
	}
	If (PatientId="") {
	 	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -2, "患者信息传入有误")
		Quit OutputXML
	}
    
    Set UserID=""
    If (UserCode'="") {
	    Set UserCode=$$ALPHAUP^SSUTIL4(UserCode)
	    Set UserID=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,""))
    }
    If ((UserID="")||('$d(^SSU("SSUSR",UserID)))) {
	 	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -3, "无此收费员或传入有误.")
		Quit OutputXML
	}
    Set GLoc=$p($g(^SSU("SSUSR",UserID)),"^",4)  //SSUSR_DefaultDept
    Set Grup=$p($g(^SSU("SSUSR",UserID)),"^",5)  //SSUSR_Group
    
    Set IPBook=""
    //其他医院放开注释 医大一院不走住院证走住院预约
    Set IPBook=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).GetIPBookIDByPatientID(PatientId)
    //其他医院注释 医大一院住院找预约就诊记录
    /*
    Set Adm=""
    For  Set Adm=$o(^PAPERdr(PatientId,"ADM","I",Adm),-1) Quit:((Adm="")||(IPBook'="")) Do
	.Set VisitStatus=$p(^PAADM(Adm),"^",20)
	.Quit:(VisitStatus'="P")
	.Set IPBook=Adm
	*/
	If (IPBook="") {
	 	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -4, "没有预约住院信息")
		Quit OutputXML
	}
    Set RegInfo=##class(web.UDHCJFIPReg).getpatinfo(PatNo,"",IPBook) //中国医大一院
    If (RegInfo="") {
	 	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -5, "获取患者入院信息失败")
		Quit OutputXML
	}
	 
	Set PatInfoObj=##class(DHCBILL.SelfPay.Entity.IPReg.IPRegPatInfo).%New()
	Set PatInfoObj.PatientID=$p(RegInfo,"^",3)
	Set PatInfoObj.PatName=$p(RegInfo,"^",4)
	Set PatInfoObj.Medicare=$p(RegInfo,"^",5)
	Set PatInfoObj.Sex=$p($p(RegInfo,"^",6),"@",1)
	Set PatInfoObj.PaperID=$p(RegInfo,"^",7)
	Set PatInfoObj.BirthDate=$p(RegInfo,"^",8)
	Set PatInfoObj.Age=$p(RegInfo,"^",9)
	Set PatInfoObj.MarDescID=$p($p(RegInfo,"^",10),"@",1)
	Set PatInfoObj.RLGDescID=$p($p(RegInfo,"^",11),"@",1)
	Set PatInfoObj.Address=$p(RegInfo,"^",12)
	Set PatInfoObj.HomeTel=$p(RegInfo,"^",13)
	Set PatInfoObj.ZipCode=$p($p(RegInfo,"^",14),"@",2)
	Set PatInfoObj.Company=$p(RegInfo,"^",15)
	Set PatInfoObj.WorkTel=$p(RegInfo,"^",16)

	Set PatInfoObj.ProvID=$p($p(RegInfo,"^",17),"@",1)
	Set PatInfoObj.Email=$p(RegInfo,"^",18)
	Set PatInfoObj.MobTel=$p(RegInfo,"^",19)
	Set PatInfoObj.CityID=$p($p(RegInfo,"^",20),"@",1)
	Set PatInfoObj.CityareaID=$p($p(RegInfo,"^",51),"@",1)
	Set PatInfoObj.NationID=$p($p(RegInfo,"^",36),"@",1)
	Set PatInfoObj.CardTypeID=$p($p(RegInfo,"^",37),"@",1)
	Set PatInfoObj.GovCardNo=$p(RegInfo,"^",38)
	Set PatInfoObj.CountryID=$p($p(RegInfo,"^",39),"@",1)
	Set PatInfoObj.OccuID=$p($p(RegInfo,"^",40),"@",1)
	Set PatInfoObj.EduID=$p($p(RegInfo,"^",41),"@",1)
	Set PatInfoObj.LanguID=$p($p(RegInfo,"^",42),"@",1)
	Set PatInfoObj.EmptypeID=$p($p(RegInfo,"^",43),"@",1)

	Set PatInfoObj.BirProv=$p($p(RegInfo,"^",44),"@",3)
	Set PatInfoObj.BirCity =$p($p(RegInfo,"^",44),"@",2)
	Set PatInfoObj.HomePlace=$p($p(RegInfo,"^",44),"@",1)

	Set PatInfoObj.ForeignID=$p($p(RegInfo,"^",45),"@",1)
	Set PatInfoObj.CtrltID=$p($p(RegInfo,"^",46),"@",1)
	Set PatInfoObj.FPhon=$p(RegInfo,"^",47)
	Set PatInfoObj.FAddress=$p(RegInfo,"^",48)
	Set PatInfoObj.FNotes=$p(RegInfo,"^",49)
	Set PatInfoObj.AdmTimes=$p(RegInfo,"^",50)
	Set BabyAge=$p(RegInfo,"^",56)
	If (BabyAge'="") {
		Set PatInfoObj.babybir=$p(RegInfo,"^",57)
		Set PatInfoObj.agehour=$p(RegInfo,"^",58)
		Set PatInfoObj.ageMinutes=$p(RegInfo,"^",59)
	}
	Set PatInfoObj.BorCounty=$p($p(RegInfo,"^",64),"@",3)
	Set PatInfoObj.BorCity=$p($p(RegInfo,"^",64),"@",2)
	Set PatInfoObj.HomeTown=$p($p(RegInfo,"^",64),"@",1)

	Set OutputObj.PatInfo=PatInfoObj
	 
	Set AdmInfoObj=##class(DHCExternalService.BillInterface.DHCEntity.IPRegAdmInfo).%New()
	Set AdmInfoObj.AdmID=$p(RegInfo,"^",21)
	Set AdmInfoObj.AdmVisit=$p(RegInfo,"^",23)
	Set AdmInfoObj.AdmDepDr=$p($p(RegInfo,"^",24),"@",1)
	Set AdmInfoObj.AdmDepDesc=$p($p(RegInfo,"^",24),"@",2)
	Set AdmInfoObj.AdmWardDr=$p($p(RegInfo,"^",25),"@",1)
	Set AdmInfoObj.AdmWardDesc=$p($p(RegInfo,"^",25),"@",2)
	Set AdmInfoObj.BedDr=$p($p(RegInfo,"^",26),"@",1)
	Set AdmInfoObj.BedDesc=$p($p(RegInfo,"^",26),"@",2)
	Set AdmInfoObj.RoomDr=$p($p(RegInfo,"^",33),"@",1)
	Set AdmInfoObj.RoomDesc=$p($p(RegInfo,"^",33),"@",2)
	Set AdmInfoObj.AdmDocDr=$p($p(RegInfo,"^",27),"@",1)
	Set AdmInfoObj.AdmDoc=$p($p(RegInfo,"^",27),"@",2)
	Set AdmInfoObj.AdmReasonDr=$p($p(RegInfo,"^",28),"@",1)
	Set AdmInfoObj.AdmReason=$p($p(RegInfo,"^",28),"@",2)
	Set AdmInfoObj.AdmEpis=$p($p(RegInfo,"^",29),"@",2)
	Set AdmInfoObj.AdmDate=$p(RegInfo,"^",30)
	Set AdmInfoObj.AdmTime=$p(RegInfo,"^",31)
	Set AdmInfoObj.UserName=$p(RegInfo,"^",32)
	Set AdmInfoObj.AdmRYQKDr=$p($p(RegInfo,"^",34),"@",1)
	Set AdmInfoObj.AdmRYQK=$p($p(RegInfo,"^",34),"@",2)
	Set AdmInfoObj.DiagnosDr=$p($p(RegInfo,"^",53),"@",1)
	Set AdmInfoObj.Diagnos=$p($p(RegInfo,"^",53),"@",2)
	Set AdmInfoObj.DigtypeDr=$p($p(RegInfo,"^",54),"@",1)
	Set AdmInfoObj.Digtype=$p($p(RegInfo,"^",54),"@",2)
	Set AdmInfoObj.DiagnosDesc=$p(RegInfo,"^",55)
	Set AdmInfoObj.InsuDig=$p($p(RegInfo,"^",63),"@",2)
	Set AdmInfoObj.RefDocListDr=$p($p(RegInfo,"^",60),"@",1)
	Set AdmInfoObj.RefDocList=$p($p(RegInfo,"^",60),"@",2)
	Set OutputObj.AdmInfo=AdmInfoObj
	Set OutputObj.IPBook=IPBook
    Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, 0, "成功")
	Quit OutputXML
GetIPRegInfoET
	Set $zt=""
    Set OutputObj=##class(DHCBILL.SelfPay.Entity.GetIPAdmInfo.Res.Response).%New()
	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -99, "程序处理错误:"_$ze)
	Quit OutputXML
}

/// Description: 修改个人基本信息
/// Debug: w ##class(DHCBILL.SelfPay.BLL.DHCIPBillPayExp).SavePatientInfo("<Request><UserCode>zysf</UserCode><PatientID>0003043658</PatientID><PatName></PatName><Medicare></Medicare><Sex></Sex><PaperID></PaperID><BirthDate></BirthDate><Age></Age><MarDescID>22</MarDescID><RLGDescID></RLGDescID><Address>恒大名都没了</Address><Company>东华医为哈哈</Company><HomeTel>13810147322</HomeTel><WorkTel></WorkTel><ZipCode></ZipCode><Email></Email><MobTel>13810147322</MobTel><HomePlace>3</HomePlace><HomeTown>4</HomeTown><BirProv>5</BirProv><BirCity>28</BirCity><BirTown>370</BirTown><BirAddress>111</BirAddress><BorProv>1</BorProv><BorCity>1</BorCity><BorTown>1</BorTown><BorAddress>人民</BorAddress><ProvID>4</ProvID><CityID>16</CityID><CityareaID>248</CityareaID><SocSatID></SocSatID><NationID>2</NationID><CardTypeID></CardTypeID><GovCardNo></GovCardNo><CountryID>1</CountryID><OccuID>317</OccuID><EduID></EduID><LanguID></LanguID><EmptypeID></EmptypeID><CtrltID>256</CtrltID><ForeignID>王宁</ForeignID><FPhon>13194235299</FPhon><FAddress>乐乐妈</FAddress><FNotes></FNotes><AdmTimes></AdmTimes><babybir></babybir><agehour></agehour><ageMinutes></ageMinutes></Request>").Read()
ClassMethod SavePatientInfo(Input As %String) As %Stream.GlobalCharacter
{
	set $zt="SavePatientInfoET"

    if Input["?>" set Input=$p(Input,"?>",2)
    if Input[$c(10) set Input=$tr(Input,$c(10),"")
    
    set InputObj=##class(DHCBILL.SelfPay.Entity.GetIPRegInfo.Res.IPRegPatInfo).%New()
    Do InputObj.XMLNodeDeserialize(.InputObj, "Request", Input)
    
    Set PatientID=InputObj.PatientID
    Set UserCode=InputObj.UserCode
    set CardNo=InputObj.CardNo
    set CardType=InputObj.CardType
    set SecrityNo=""
    set Country=InputObj.CountryID     ;国家
    set NationID=InputObj.NationID     ;民族
    Set Sex=InputObj.Sex               ;性别
    Set PaperID=InputObj.PaperID       ;身份证号码
    Set BirthDate=InputObj.BirthDate   ;出生年月
    Set Age=InputObj.Age               ;年龄    
    Set CardTypeID=InputObj.CardTypeID ;证件类型
    Set GovCardNo=InputObj.GovCardNo   ;证件号码
    set OccuID=InputObj.OccuID         ;职业
    Set MarDescID=InputObj.MarDescID   ;婚姻状况
    set HomePlace=InputObj.HomePlace   ;籍贯省
    set HomeTown=InputObj.HomeTown     ;籍贯市
    set BirProv=InputObj.BirProv       ;省(出生)
    set BirCity=InputObj.BirCity       ;市(出生)
    set BirTown=InputObj.BirTown       ;区县(出生)
    set BirAddress=InputObj.BirAddress
    Set ProvID=InputObj.ProvID         ;现住址省
    Set CityID=InputObj.CityID         ;现住址市
    Set CityareaID=InputObj.CityareaID ;现住址县
    Set Address=InputObj.Address       ;家庭地址备注  
    Set MobTel=InputObj.MobTel         ;手机
	Set BorProv=InputObj.BorProv       ;省(户口)	
	Set BorCity=InputObj.BorCity       ;市(户口)	
	Set BorTown=InputObj.BorTown       ;区县(户口)
	set BorAddress=InputObj.BorAddress
	Set Company=InputObj.Company	   ;工作单位
	Set HomeTel=InputObj.HomeTel       ;电话
	set WorkTel=InputObj.WorkTel
	Set ForeignID=InputObj.ForeignID   ;联系人
    Set FPhon=InputObj.FPhon           ;联系人电话
    Set CtrltID=InputObj.CtrltID       ;患者与联系人的关系
    set FAddress=InputObj.FAddress     ;联系人地址  
    Set PatName=InputObj.PatName       ;姓名
    Set MedicalNo=InputObj.Medicare    ;病案号  
    Set EduID=InputObj.EduID 
	Do InputObj.%Close()
	
	Set HospitalID=$o(^CT("HOSP",0))
	
	set OutputObj=##class(DHCBILL.SelfPay.Entity.GetIPRegInfo.Res.Response).%New()
	Set PatientId=""
	Set PatInfo=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).GetPatCommInfo(CardNo, CardType, SecrityNo, PatientID)
	If (" 0 -201 "[(" "_$p(PatInfo,"^",1)_" ")) {
		Set PatientId=$p(PatInfo,"^",8)
	}
	If ((PatientId="")&&(MedicalNo'="")) {
		Set PatientId=##class(DHCWMR.IO.OutService).IGetPatientIDByMrNo(MedicalNo, "I", HospitalID, "")
	}
	If (PatientId="") {
	 	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -3, "患者信息传入有误")
		Quit OutputXML
	}
	
	Set UserID=""
    If (UserCode'="") {
	    Set UserCode=$$ALPHAUP^SSUTIL4(UserCode)
	    Set UserID=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,""))
	}
	If ((UserID="")||('$d(^SSU("SSUSR",UserID)))){
	 	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -2, "用户代码传入有误")
		Quit OutputXML
	}
	
	ts
	
	Set PersonObj=##class(User.PAPerson).%OpenId(PatientId, 0)
	Set PatMasObj=##class(User.PAPatMas).%OpenId(PatientId, 0)
    Set DHCPersonID=$o(^DHCPERSON(0,"PAPERSON",PatientId,0))
	If (+DHCPersonID=0) {
		Set DHCPersonObj=##class(User.DHCPerson).%New()
		do DHCPersonObj.PAPERPaPersondrSetObjectId(PatientId)
	}Else {
		Set DHCPersonObj=##class(User.DHCPerson).%OpenId(DHCPersonID, 0)
	}
    If (PatName'="") s PatMasObj.PAPMIName=PatName	     ;姓名
    If (Country'="") {
	    ;s CountryID=$o(^CT("COU",0,"Code",Country,""))
    	d PersonObj.PAPERCountryDRSetObjectId(Country)    ;国家 CT_Country
    }
    If (NationID'="") {
	    ;s NationIDDr=$o(^CT("NAT",0,"Code",NationID,""))
    	d PersonObj.PAPERNationDRSetObjectId(NationID) ;民族 CT_Nation
    }
	s:(PaperID'="") PatMasObj.PAPMIID=PaperID              ;PAPMI_ID   身份证
	if (CardTypeID'="") {
		;s CardTypeDR=$o(^PAC("CARD",0,"Code",CardTypeID,""))
		d PatMasObj.PAPMICardTypeDRSetObjectId(CardTypeID)                      ;PAPMI_CardType_DR   证件类型
		s PatMasObj.PAPMIDVAnumber=GovCardNo                                    ;PAPMI_DVAnumber     证件号码
		s:PaperID="" PatMasObj.PAPMIID=GovCardNo                      ;PAPMI_ID   身份证
		if (CardTypeID=20)&(GovCardNo'="") {
			s Birth=$e(GovCardNo,7,14)
			s BirthDay=$zdh(Birth,8)
			s PersonObj.PAPERDob=BirthDay
			s PatMasObj.PAPMIDOB=BirthDay                    ;更新出生日期会自动更新年龄	    
			s SexDr=$e(GovCardNo,17)
			i SexDr#2=0 s Sex="F" 
			i SexDr#2=1 s Sex="M"
			s SexID=$o(^CT("SEX",0,"Code",Sex,""))
			d PersonObj.PAPERSexDRSetObjectId(SexID)
			d PatMasObj.PAPMISexDRSetObjectId(SexID)
	   }
    }
    if (Sex'="") {
	    ;s SexID=$o(^CT("SEX",0,"Code",Sex,""))
        d PersonObj.PAPERSexDRSetObjectId(Sex)  ;CT_Sex
		d PatMasObj.PAPMISexDRSetObjectId(Sex)
    }
    if (BirthDate'="") {
	    s BirthDate=$zdh(BirthDate,3)
	    s PersonObj.PAPERDob=BirthDay
		s PatMasObj.PAPMIDOB=BirthDay   
    } 
	s:HomeTel'="" PersonObj.PAPERTelH=HomeTel                       ;电话
	s:MobTel'="" PersonObj.PAPERMobPhone=MobTel                     ;手机
    s:WorkTel'="" PersonObj.PAPERTelO=WorkTel
	if (OccuID'="") {
		;s OccuID=$o(^CT("OCC",0,"Code",OccuID,""))
		d PersonObj.PAPEROccupationDRSetObjectId(OccuID) ;职业  CT_Occupation
	}
	if Company'="" s PersonObj.PAPERSecondPhone=Company          ;工作单位
	if Company'="" s PatMasObj.PAPMISecondPhone=Company   
	
	if (EduID'="") { 
		;s EduID=$o(^CT("EDU",0,"Code",EduID,""))
		d PersonObj.PAPEREducationDRSetObjectId(EduID)    ;CT_Education 教育
	}
	if (MarDescID'="") {
		;s MaritalDR=$o(^CT("MAR",0,"Code",MarDescID,""))
		d PersonObj.PAPERMaritalDRSetObjectId(MarDescID)           ;CT_Marital    婚姻状态
	}
	if (Country'=1) {
		s HomePlace=""  ;外国友人不存籍贯
		s HomeTown=""
	}
	if (HomePlace'="") {
	   ;s HomePlaceDR=$o(^CT("PROV",0,"Code",HomePlace,""))
	   do PersonObj.PAPERProvinceBirthDRSetObjectId(HomePlace)   //CT_Province 省(籍贯) 
	}	
	
	if (HomeTown'="") {
	    ;s HomeTownDR=$o(^CT("CIT",0,"Code",HomeTown,""))
	    do PersonObj.PAPERCityBirthDRSetObjectId(HomeTown)       //CT_City 市(籍贯) 
	}
	;现住址
	if (ProvID'="") {
	   ;s ProvinceDR=$o(^CT("PROV",0,"Code",ProvID,""))
	   d PersonObj.PAPERCTProvinceDRSetObjectId(ProvID)              ;PAPER_CT_Province_DR  现住址(省)
	}
	if (CityID'="") {
	    ;s CityCodeDR=$o(^CT("CIT",0,"Code",CityID,""))
	    d PersonObj.PAPERCityCodeDRSetObjectId(CityID)                ;PAPER_CityCode_DR   现住址(市)
	}
	if (CityareaID'="") {
	    ;s CityAreaDR=$o(^CT("CITAREA",0,"Code",CityareaID,""))
	    d PersonObj.PAPERCityAreaDRSetObjectId(CityareaID)        ;CTCityArea   现住址(县)
	} 
	i (Address'="") {
		d PersonObj.PAPERStName.Clear()
		d PersonObj.PAPERStName.Insert(Address)                                   ;PAPER_StName        地址备注手写方式
	}
	;现住址		
	
	;出生地
	if (BirProv'="") {
	   ;s BirProvDR=$o(^CT("PROV",0,"Code",BirProv,""))
	   set DHCPersonObj.PAPERBirthProvinceDR=BirProv
	}
	if (BirCity'="") {
	    ;s BirCityDR=$o(^CT("CIT",0,"Code",BirCity,""))
	    set DHCPersonObj.PAPERBirthCityDR=BirCity
	}
	if (BirTown'="") {
	    ;s BirTownDR=$o(^CT("CITAREA",0,"Code",BirTown,""))
	    set DHCPersonObj.PAPERBirthAreadr=BirTown
	} 
	
	i BirAddress'="" set DHCPersonObj.PAPERBirthAddress=BirAddress
	;出生地
	
	;户口
	if (BorProv'="") {
	   ;s BorProvDR=$o(^CT("PROV",0,"Code",BorProv,""))
	   set DHCPersonObj.PAPERHouseProvinceDR=BorProv    //省(户口)
	}
	if (BorCity'="") {
	    ;s BorCityDR=$o(^CT("CIT",0,"Code",BorCity,""))
	    set DHCPersonObj.PAPERHouseCityDR=BorCity        //市(户口)
	}
	if (BorTown'="") {
	    ;s BorTownDR=$o(^CT("CITAREA",0,"Code",BorTown,""))
	    s DHCPersonObj.PAPERHouseAreaDR=BorTown               //县(户口)
	}
	i (BorAddress'="") s DHCPersonObj.PAPERHouseAddress=BorAddress
	;户口
	
	s:ForeignID'="" PersonObj.PAPERForeignId=ForeignID                         ;PAPER_ForeignId     联系人
	s:FPhon'="" PersonObj.PAPERForeignPhone=FPhon                              ;PAPER_ForeignPhone  联系人电话
	s:FAddress'="" PersonObj.PAPERForeignAddress=FAddress   ;联系人地址
	if (CtrltID'="") {
		;s CTRLTDR=$o(^CT("RLT",0,"Code",CtrltID,""))
		d PersonObj.PAPERCTRLTDRSetObjectId(CtrltID)                 ;CT_Relation     与联系人关系
	}
	
	Set PersonObj.PAPERUpdateDate=+$h
	Set PersonObj.PAPERUpdateTime=$p($h,",",2)
 	Set sc=PersonObj.%Save()
 	If $$$ISERR(sc) {
		Do $System.Status.DisplayError(sc)
		tro
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj,"-1","更新人员信息失败PAPerson")
		Quit OutputXML
 	}
	Set sc=PatMasObj.%Save()
 	If $$$ISERR(sc) {
		Do $System.Status.DisplayError(sc)
		tro
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj,"-2","更新人员信息失败PAPatMas")
		Quit OutputXML
 	}
 	
	Set sc=DHCPersonObj.%Save()
 	If $$$ISERR(sc) {
		Do $System.Status.DisplayError(sc)
		tro
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj,"-3","更新人员信息失败PAPatMas")
		Quit OutputXML
 	}
	Do PatMasObj.%Close()
	Do PersonObj.%Close()
	Do DHCPersonObj.%Close()
	If ($tl>0) tc
	
	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj,"0","成功")
	Quit OutputXML
    
SavePatientInfoET
	Set $zt=""
    Set OutputObj=##class(DHCBILL.SelfPay.Entity.IPRegister.Res.Response).%New()
	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj,"-99","程序处理错误:"_$ZERROR)
	Quit OutputXML
}

}
