Import SQLUser

Class DHCExternalService.BillInterface.Service.DHCOPBillPayLogic Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator:wangjian
/// CreatDate:2013-02-19
/// Description:通过卡号得到病人基本信息和就诊信息
/// w ##class(DHCExternalService.BillInterface.Service.DHCOPBillPayLogic).GetPatCommInfoByCardNo("10018045","","")
ClassMethod GetPatCommInfoByCardNo(CardNo, PatNo)
{
	n (CardNo,PatNo)
	s rtn=""	
	set papmi=""
	i (CardNo'="")&&(PatNo="") d
	.s cardid=0
	.f  s cardid=$o(^DHCCARDi("CF",0,"CardNo",CardNo,cardid)) q:(cardid="")  d
	..s ActiveFlag=$p(^DHCCARD("CF",cardid),"^",10)
	..q:ActiveFlag'="N"
	..s papmi=$p(^DHCCARD("CF",cardid),"^",4)
	i PatNo'=""  d
	.set PatNo=$$ALPHAUP^SSUTIL4(PatNo) 
	.set papmi=$o(^PAPERi("PAPMI_PatNo",PatNo,""))
	.b ;009
	s (admreas,AdmNo,admdate,patward,remain,indays,dep,deploc,myAdm,patvisitstatus,deposit,patfee)=""
	b ;999999999999999
	i papmi'="" d
	.s patname=$p(^PAPER(papmi,"ALL"),"^",1),patregno=$p(^PAPER(papmi,"PAT",1),"^",1)
	.s sexid=$p(^PAPER(papmi,"ALL"),"^",7),sex=$p(^CT("SEX",sexid),"^",2),sexcode=$p(^CT("SEX",sexid),"^",1)
	.s zyno=$p(^PAPER(papmi,"PAT",1),"^",22)
	.i $d(^PAPER(papmi,"PER","ADD",1)) d
	.s Address=^PAPER(papmi,"PER","ADD",1)  ;地址
	.s curDate=$zd($h,3)
	.s dobDate=$zd($p($g(^PAPER(papmi,"ALL")),"^",6),3)
	.s patAge=##class(DHCExternalService.BillInterface.Service.DHCOPBillPayLogic).GetAgeDesc(dobDate,curDate)
	.s patcardtypeno=$p($g(^PAPER(papmi,"PAT",3)),"^",6) ;证件号
	.s patcardtypedr=$p($g(^PAPER(papmi,"PAT",3)),"^",7) ;证件类型指针
	.s Relationdr=""	 
	.i patcardtypedr'="" s patcardcode=$p(^PAC("CARD",patcardtypedr),"^",1),patcarddesc=$p(^PAC("CARD",patcardtypedr),"^",2)
	.e  s patcardcode="",patcarddesc=""
    .s adm="" f  s adm=$o(^PAPERdr(papmi,"ADM","I",adm)) q:(adm="")!(myAdm'="")  d
    ..b ;kk00
    ..s dep=$p(^PAADM(adm),"^",4),currward=$p(^PAADM(adm),"^",70)
	..s admtype=$p(^PAADM(adm),"^",2)
	..q:admtype'="I"
	..s visitstatus=$p(^PAADM(adm),"^",20)
	..q:visitstatus'="A"
	..i currward'=""  d  s patward=$p(^PAWARD(currward),"^",2)
	..e  d  s patward=""
	..s indays=+$h-$p(^PAADM(adm),"^",6)+1
	..s admdate=$zd($p(^PAADM(adm),"^",6),3)
	..s deploc=$p(^CTLOC(dep),"^",2)
	..s billflag=$p(^PAADM(adm),"^",45)
	..i billflag'["Y"  d
	...s patfee=##class(web.UDHCJFCKD).totalamount(adm) 
	...s deposit=##class(web.UDHCJFCKD).deposit(adm) 
	...s remain=deposit-patfee
	..s admreas=$p(^PAADM(adm,1),"^",7)
	..s:(admreas'="")&&($d(^PAC("ADMREA",admreas))) admreas=$p($g(^PAC("ADMREA",admreas)),"^",2)
	..s AdmNo=$p(^PAADM(adm),"^",81) ;就诊号
	..s myAdm=adm
	..s patvisitstatus="在院"
	.i myAdm=""  d
	..s adm="" f  s adm=$o(^PAPERdr(papmi,"ADM","I",adm)) q:(adm="")!(myAdm'="")  d
	...s admtype=$p(^PAADM(adm),"^",2)
	...q:admtype'="I"
	...s visitstatus=$p(^PAADM(adm),"^",20)
	...;q:visitstatus'="A"
	...i visitstatus="D" s patvisitstatus="出院"
	...i visitstatus="C" s patvisitstatus="退院"
	b ;bkbk
	s rtn=papmi_"^"_myAdm_"^"_patregno_"^"_patname_"^"_sexcode_"^"_sex_"^"_dobDate_"^"_zyno_"^"_Address
	s rtn=rtn_"^"_patcardcode_"^"_patcarddesc_"^"_patcardtypeno
	s rtn=rtn_"^"_admreas_"^"_AdmNo_"^"_admdate_"^"_patward_"^"_remain_"^"_patAge_"^"_indays_"^"_dep_"^"_deploc_"^"_patvisitstatus_"^"_deposit_"^"_patfee
	q rtn
}

ClassMethod CheckPayMByPrtRowID(PrtRowID, AbortPrtRowID)
{
	n (PrtRowID,AbortPrtRowID)
    s rtn=0,Amt=0,HandFlag=0,PayModeDR=""
    s RowidStr=PrtRowID_"|"_AbortPrtRowID
	s num=$l(RowidStr,"|")
	f i=1:1:num d
	.s rowid=$p(RowidStr,"|",i)
	.q:rowid=""
	.s IPM="0"
	.q:'$d(^DHCINVPRT(rowid,"P",IPM))
	.f  s IPM=$o(^DHCINVPRT(rowid,"P",IPM)) q:IPM=""  d
	..s s=$g(^DHCINVPRT(rowid,"P",IPM))
	..s payMDr=$p(s,"^",1)
	..s payMCode=$p(^CT("CTPM",payMDr),"^",1)
	..s payMAmt=+$p(s,"^",3)
	..s handInfo=..GetPayModeHardComm("OP",payMDr)
	..s handDr=$p(handInfo,"^",1)
	..i handDr'="" d
	...s Amt=Amt+payMAmt
	...s HandFlag=handDr
	...s PayModeDR=payMDr
	;
	i ((HandFlag>0)&(Amt'=0)) s rtn=HandFlag	//金额为0时也不调用银行接口
	q rtn_"^"_PayModeDR
}

ClassMethod CheckRefundMode(AbortPrtRowID, PrtRowID)
{
	n (AbortPrtRowID,PrtRowID)
    s Amt1=0,Amt2=0,rtn=""
    q:PrtRowID="" 0	;没有新发票记录，说明是全退
    ;
    i PrtRowID'="" d
    .s IPM="0"
	.f  s IPM=$o(^DHCINVPRT(PrtRowID,"P",IPM)) q:IPM=""  d
	..s s=$g(^DHCINVPRT(PrtRowID,"P",IPM))
	..s payMDr=$p(s,"^",1)
	..s payMCode=$p(^CT("CTPM",payMDr),"^",1)
	..s payMAmt=+$p(s,"^",3)
	..s HandDr=..GetPayModeHardComm("OP",payMDr)
	..i HandDr'="" d
	...s Amt1=Amt1+payMAmt
	;
	i AbortPrtRowID'="" d
	.s IPM="0"
	.f  s IPM=$o(^DHCINVPRT(AbortPrtRowID,"P",IPM)) q:IPM=""  d
	..s s=$g(^DHCINVPRT(AbortPrtRowID,"P",IPM))
	..s payMDr=$p(s,"^",1)
	..s payMCode=$p(^CT("CTPM",payMDr),"^",1)
	..s payMAmt=+$p(s,"^",3)
	..s HandDr=..GetPayModeHardComm("OP",payMDr)
	..i HandDr'="" d
	...s Amt2=Amt2+payMAmt
    ;
    s Amt1=$zabs(Amt1),Amt2=$zabs(Amt2)
    q:Amt1=0 0					;新发票记录的银医卡金额为0时,全退
    q:((Amt1'=0)&(Amt1<Amt2)) 1	;新发票记录的银医卡金额不为0时,部分退
    q:((Amt1'=0)&(Amt1=Amt2)) 2	;作废重打
    q 0
}

ClassMethod GetPayInput(PatType As %String, PayModeDr As %String, NewPrtRowid As %String, AbortPrtRowID As %String, BankCardNO As %String, BankTradeType As %String, ExpStr As %String)
{
	n (PatType, PayModeDr, NewPrtRowid,AbortPrtRowID, BankCardNO, BankTradeType, ExpStr,Input)
	s CTLocDR=$p(ExpStr,"^",1)
	s GroupDR=$p(ExpStr,"^",2)
	s HospDR=$p(ExpStr,"^",3)
	s ClientType=$p(ExpStr,"^",4)
	s TerminalID=$p(ExpStr,"^",5)
	;s TerminalID=##class(web.DHCBillBMCLogic).FormatTerminalId(TerminalID)
	s Userid=$p(ExpStr,"^",6)
	i HospDR="" s HospDR=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(CTLocDR)
	i (+AbortPrtRowID'=0) {
		;根据发票Rowid取原始的发票Rowid
		s IBPRowID="",IBSSub=""
		i (PatType="OP"){
			s OrgPrtRowID=..GetOrgPrtRowID(AbortPrtRowID,NewPrtRowid,"")
			s IBPRowID=$o(^DHCINVALITPi(0,"S","IPDR",OrgPrtRowID,"0"))
			s IBSSub=$o(^DHCINVALITPi(0,"S","IPDR",OrgPrtRowID,IBPRowID,"C",""),-1)	;取第一条还是最后一条？(一般情况下收费都是一对一)	
			s TotalAmt=..GetOPInvAliPayAmt(NewPrtRowid_"|"_AbortPrtRowID)	;要考虑扩展医保表
		} ;根据原始发票Rowid获取原交易信息
		s OrgTradeInfo=..GetOrgTradeData(PatType,IBPRowID,IBSSub,"")
		s AdmInfo=$p(OrgTradeInfo,"^",4)
		s CardNO=""
		s PatientId=$p(OrgTradeInfo,"^",3)
	}
	;针对医保分解
	i (+NewPrtRowid'=0)&&(+AbortPrtRowID=0) {
		;根据发票Rowid取原始的发票Rowid
		s IBPRowID="",IBSSub=""
		i (PatType="OP"){
			s OrgPrtRowID=NewPrtRowid
			s IBPRowID=$o(^DHCINVALITPi(0,"S","IPDR",OrgPrtRowID,"0"))
			s IBSSub=$o(^DHCINVALITPi(0,"S","IPDR",OrgPrtRowID,IBPRowID,"C",""),-1)	;取第一条还是最后一条？(一般情况下收费都是一对一)	
			s TotalAmt=..GetOPInvAliPayAmtForYB(NewPrtRowid_"|"_AbortPrtRowID)	;要考虑扩展医保表
		} ;根据原始发票Rowid获取原交易信息
		s OrgTradeInfo=..GetOrgTradeData(PatType,IBPRowID,IBSSub,"")
		s AdmInfo=$p(OrgTradeInfo,"^",4)
		s CardNO=""
		s PatientId=$p(OrgTradeInfo,"^",3)
	 }
	
	;s myExpstr=ExtUserID_"^3^"_PatType_"^"_TotalAmt_"^"_IBPRowID
	;s rtn=##class(DHCAliPay.ChargeInterface.DHCOPBillAliPayExp).SetHisTradeNoInfo(AdmInfo,PatientId,CardNO,BankTradeType,HospDR,myExpstr)
	s PayModHand="2"  ;
	set HisTradeExpStr=Userid_"^"_NewPrtRowid_"^"_AbortPrtRowID
    set rtn=##class(DHCExternalService.BillInterface.Service.DHCOPBillPayLogic).SetTradeID(PayModHand,CardNO,"C",HospDR,HisTradeExpStr) ;
	b ;22
	q:+rtn'=0 "SetTradeErr"
	s HisTradeNo=$p(rtn,"^",3)
	s IBPRowID=$p(rtn,"^",2)
	s err=+rtn
	q err_$c(2)_$g(IBPRowID)_$c(2)_$g(HisTradeNo)_$c(2)_$g(OrgTradeInfo)
}

/// 获取支付宝或微信金额
ClassMethod GetOPInvAliPayAmt(rowidStr)
{
	;发票如果发票存在医保分解扩展以医保扩展表为准
	n (rowidStr)
	s amt=0.00
	s num=$l(rowidStr,"|")
	f i=1:1:num d
	.s rowid=$p(rowidStr,"|",i)
	.q:rowid=""
	.i '$d(^DHCINVPRTInsu("0","PRT",rowid)) d
	..s IPM="0"
	..q:'$d(^DHCINVPRT(rowid,"P",IPM))
	..f  s IPM=$o(^DHCINVPRT(rowid,"P",IPM)) q:IPM=""  d
	...s s=$g(^DHCINVPRT(rowid,"P",IPM))
	...s payMDr=$p(s,"^",1)
	...s payMCode=$p(^CT("CTPM",payMDr),"^",1)
	...s payMAmt=+$p(s,"^",3)
	...s handDr=..GetPayModeHardComm("OP",payMDr)
	...i handDr'="" d
	....b ;009
	....s amt=amt+payMAmt
	.e  d
	..s InsuInvID=$o(^DHCINVPRTInsu("0","PRT",rowid,""))
	..s InsuIPM=0
	..q:'$d(^DHCINVPRTInsu(InsuInvID,"P",InsuIPM))
	..f  s InsuIPM=$o(^DHCINVPRTInsu(InsuInvID,"P",InsuIPM)) q:InsuIPM=""  d
	...s s=$g(^DHCINVPRTInsu(InsuInvID,"P",InsuIPM))
	...s payMDr=$p(s,"^",1)
	...s payMCode=$p(^CT("CTPM",payMDr),"^",1)
	...s payMAmt=+$p(s,"^",3)
	...s handDr=..GetPayModeHardComm("OP",payMDr)
	...i handDr'="" d
	....s amt=amt+payMAmt
	b ;00
	s amt=$fn($zabs(amt),"",2)
	b ;01
	q amt
}

ClassMethod GetOPInvAliPayAmtForYB(rowidStr)
{
	;发票如果发票存在医保分解扩展以医保扩展表为准
	n (rowidStr)
	s amt=0.00
	s num=$l(rowidStr,"|")
	f i=1:1:num d
	.s rowid=$p(rowidStr,"|",i)
	.q:rowid=""
	.s IPM="0"
	.q:'$d(^DHCINVPRT(rowid,"P",IPM))
	.f  s IPM=$o(^DHCINVPRT(rowid,"P",IPM)) q:IPM=""  d
	..s s=$g(^DHCINVPRT(rowid,"P",IPM))
	..s payMDr=$p(s,"^",1)
	..;b ;;
	..s payMCode=$p(^CT("CTPM",payMDr),"^",1)
	..s payMAmt=+$p(s,"^",3)
	..s handDr=..GetPayModeHardComm("OP",payMDr)
	..i handDr'="" d
	...s amt=amt+payMAmt
	
	s amt=$fn($zabs(amt),"",2)
	
	q amt
}

ClassMethod GetOrgPrtRowID(AbortPrtRowID, NewPrtRowid, ExpStr)
{
	New (AbortPrtRowID,NewPrtRowid,ExpStr)
	Set myPrtRowID=""
	If (+NewPrtRowid=0) {
		b ;新发票Rowid为空,一定上全退,负责为部分退费
		Set InitInvDR=$p(^DHCINVPRT(AbortPrtRowID),"^",13)	;PRT_initInv_DR
		Set myPrtRowID=InitInvDR
	}Else{
		Set OldInvDR=$p(^DHCINVPRT(NewPrtRowid),"^",29)	;PRT_OldINV_DR
		Set myPrtRowID=OldInvDR	
	}
	Set myOldInvDR=$p(^DHCINVPRT(myPrtRowID),"^",29)
	While (+myOldInvDR'=0) {
		Set myOldInvDR=$p(^DHCINVPRT(myPrtRowID),"^",29)	;PRT_OldINV_DR
		If (+myOldInvDR'=0){
			Set myPrtRowID=myOldInvDR
		}
	}
	Quit myPrtRowID
}

/// Creator:wangjian
/// CreatDate:2014-07-11
/// Description:获取原交易信息
/// Input:IBPRowID:原交易明细表Rowid,IBSSub:原交易明细表子表Sub,ExpStr:扩展信息("^^^^^^")
/// Output:
/// Return:
/// Other:
/// Debug:w ##class(DHCAliPay.ChargeInterface.AliPayLogic).GetOrgTradeData("OP","850","1","")
ClassMethod GetOrgTradeData(PatType, IBPRowID, IBSSub, ExpStr)
{
	n (PatType,IBPRowID,IBSSub,ExpStr)
	;
	s IBSRowd=IBPRowID_"||"_IBSSub
	s AdmInfo=$p(^DHCINVALITP(IBPRowID),"^",45)
	s OldAliPayNo=$p(^DHCINVALITP(IBPRowID),"^",7)
	s OldHisTradeNo=$p(^DHCINVALITP(IBPRowID),"^",32)
	s Patientid=$p(^DHCINVALITP(IBPRowID),"^",48)
	s PayMode=$p(^DHCINVALITP(IBPRowID),"^",46)
	i (PatType="OP"){
		s OldPaySeqNo=$p(^DHCINVALITP(IBPRowID,"C",IBSSub),"^",5)
	}elseif(PatType="IP"){
		s OldPaySeqNo=""
	}else{
		s OldPaySeqNo=OldHisTradeID
	}
	;
	s rtn=OldAliPayNo_"^"_OldHisTradeNo_"^"_Patientid_"^"_AdmInfo_"^"_PayMode
	b ;rtn 111
	q rtn
}

/// w ##class(DHCExternalService.BillInterface.Service.DHCOPBillPayLogic).Refund("OP","",1625004,"","D","81^22^^^^5394")
/// "OP",myPRTRowID,"","","D",myExpStr
ClassMethod Refund(PatType As %String, NewPrtRowid As %String, AbortPrtRowID As %String, BankCardNO As %String, BankTradeType As %String, ExpStr As %String)
{
	n (PatType, NewPrtRowid, AbortPrtRowID, BankCardNO, BankTradeType, ExpStr)
	s ^zhho("wzf")=PatType_","_NewPrtRowid_","_AbortPrtRowID_","_BankCardNO_","_BankTradeType_","_ExpStr
	s Rtn=0
	q:"C^D"'[BankTradeType "-1001^"_"^获取入参失败,交易类型不正确."
	i PatType="OP" s PayMInfo=..CheckPayMByPrtRowID(NewPrtRowid,AbortPrtRowID)
    s CardPayFlag=$p(PayMInfo,"^",1)
    s PayModeDr=$p(PayMInfo,"^",2)
	q:+CardPayFlag=0 "-1"	;非支付宝支付
	s ExtUserID=$p(ExpStr,"^",6)
		
	s RefundMode=0
	i PatType="OP" d
	.s RefundMode=..CheckRefundMode(AbortPrtRowID,NewPrtRowid)
	q:+RefundMode=2 "-1"	;作废重打不调接口 
	
	s rtn=..GetPayInput(PatType, PayModeDr, NewPrtRowid, AbortPrtRowID, BankCardNO, BankTradeType, ExpStr)
	s err=+$p(rtn,$c(2),1) 
	b ;支付返回
	s IBPRowID=$p(rtn,$c(2),2)
	s HISTradeNo=$p(rtn,$c(2),3)
	s RefTradeInfo=$p(rtn,$c(2),4)
	if ((+err'=0)&&(+IBPRowID'=0)) {
			
	}
	
	q:+err'=0 "-1001^"_err_"^获取入参失败."	
	s ^DHCBillAliPay("MZJF","HisTradeNOConPrt",HISTradeNo)=NewPrtRowid_"^"_AbortPrtRowID
	;收费时,TotalAmt是所有发票的总金额;退费时,TotalAmt是新发票和负票的差额;如果是全退,TotalAmt是负票的金额
	i (PatType="OP")&&(+AbortPrtRowID'=0){
		s TotalAmt=..GetOPInvAliPayAmt(NewPrtRowid_"|"_AbortPrtRowID)	;要考虑扩展医保表
	}
	i (PatType="OP")&&(+AbortPrtRowID=0)&&(+NewPrtRowid'=0){
		s TotalAmt=..GetOPInvAliPayAmtForYB(NewPrtRowid_"|"_AbortPrtRowID)	;要考虑扩展医保表
	}
	b ;kkkkk
	i (BankTradeType="D"){
	s Mark=$p(ExpStr,"^",7)
	i (Mark="") Set Mark="退号"
	s AdmInfo=$p(RefTradeInfo,"^",4)
	s OldHisTradeNo=$p(RefTradeInfo,"^",2)
	s OldAliPayNo=$p(RefTradeInfo,"^",1)
	s Patientid=$p(RefTradeInfo,"^",3)
	s PayMode=$p(RefTradeInfo,"^",5)
	s RefundTime=$zd(+$h,3)_" "_$zt($p($h,",",2),1)
	s RtnStr="<req><orderId>"_OldAliPayNo_"</orderId><notifyUrl>http://10.10.100.22/doReqToHis/refundCallback</notifyUrl><refundTime>"_RefundTime_"</refundTime><refundFee>"_(TotalAmt*100)_"</refundFee><reason>"_Mark_"</reason><refundNo>"_HISTradeNo_"</refundNo></req>"
	b ;zhhobk
	s RefundObj=##class(web.DHCENS.BLL.PAY.SOAP.PAYWebserviceSoap).%New()
	s ^hhhhh=RtnStr
	s rtnstr=RefundObj.Refund(RtnStr)
	b ;kkkk789
	i rtnstr'="" s Rtn=$p($p(rtnstr,"<resultCode>",2),"</resultCode>",1)
	e  s ^RefundLog(AbortPrtRowID)=rtnstr
	}
		
	q Rtn
}

/// 退住院押金
ClassMethod RefundIPDeposit(OldPrt, NewPrt)
{
	s Rtn=0
	s TotalAmt=$p(^DHCSFPRINTDETAIL(OldPrt),"^",6)
	s Mark="退住院押金"	
	s AdmInfo=$p(RefTradeInfo,"^",4)
	s OldHisTradeNo=$p(RefTradeInfo,"^",2)
	s HISTradeNo=OldHisTradeNo_"T"
	s abdrowid=$o(^DHCIPAutoDepBankData(0,"PrtDepoistDR",OldPrt,""))
	s OldAliPayNo=$p(^DHCIPAutoDepBankData(abdrowid),"^",15)
	set RefundTime=$zd(+$h,3)_" "_$zt($p($h,",",2),1)
	set RtnStr="<req><orderId>"_OldAliPayNo_"</orderId><notifyUrl>http://10.10.100.22/doReqToHis/refundCallback</notifyUrl><refundTime>"_RefundTime_"</refundTime><refundFee>"_(TotalAmt*100)_"</refundFee><reason>"_Mark_"</reason><refundNo>"_HISTradeNo_"</refundNo></req>"
	b ;zhhobk
	s RefundObj=##class(web.DHCENS.BLL.PAY.SOAP.PAYWebserviceSoap).%New()
	s ^hhhhh=RtnStr
	s rtnstr=RefundObj.Refund(RtnStr)
	b ;kkkk789
	i rtnstr'="" s Rtn=$p($p(rtnstr,"<resultCode>",2),"</resultCode>",1)
	e  s ^RefundIPLog(OldPrt)=rtnstr
	set logrowid=NewPrt
	if logrowid="" s logrowid=OldPrt
	set myuserid=$p(^DHCSFPRINTDETAIL(OldPrt),"^",14)
	set Adm=$p(^DHCSFPRINTDETAIL(OldPrt),"^",4)
	i NewPrt'="" s myuserid=$p(^DHCSFPRINTDETAIL(NewPrt),"^",14)
	set BankRequset="^^^"_myuserid_"^^^"_Adm_"^"_TotalAmt_"^22^"_HISTradeNo_"^^^"_HISTradeNo_"^^D^"_abdrowid
 	i Rtn=0 s insert=..InsertAutoDepBankData(BankRequset, logrowid)
	
	q Rtn
}

ClassMethod CreatSendNo()
{
	q $i(^SendNO)
}

ClassMethod SendMsg(PrtRowid, ExpStr)
{
	s Amt=$p(^DHCINVPRT(PrtRowid),"^",1)
	s AliAmt=..GetOPInvAliPayAmt(PrtRowid)
	s RefundAmt=Amt-AliAmt
	s eventNo=..CreatSendNo()
	s patientId=$p(^DHCINVPRT(PrtRowid),"^",15)	
	q:patientId="" 0
	s Cardno="" 
	s CardRowid=""  f  s CardRowid=$o(^DHCCARDi("CF",0,"PAPMIDR",patientId,CardRowid)) q:(CardRowid="")!(Cardno'="")  d
	.s active=$p(^DHCCARDi("CF",CardRowid),"^",10)
	.q:active'="N"
	.s Cardno=$p(^DHCCARDi("CF",CardRowid),"^",2)
	s RefundObj=##class(web.DHCENS.BLL.PAY.SOAP.PAYWebserviceSoap).%New()
	s RtnStr="<req><eventNo>"_eventNo_"</eventNo><eventType>customMessage</eventType><eventData><patientId>"_patientId_"<patientId><healthCardNo>"_Cardno_"</healthCardNo><title>医保分解</title><message>医保分解退还金额："_RefundAmt_",3个工作日内到账,请留意是否到账</message></eventData></req>"
	s rtnstr=RefundObj.CustomMessage(RtnStr)
	s ^sendlog($h)=RtnStr
	
	q 0
}

ClassMethod DeleteIBP(IPBRowID, ExpStr)
{
	n (IPBRowID,ExpStr)
	s myrtn=##class(web.DHCOPBillINVBankPay).DELETE(IPBRowID)
	q myrtn
}

ClassMethod DeleteIAP(IPBRowID, ExpStr)
{
	n (IPBRowID,ExpStr)
	s myrtn=##class(web.DHCOPBillINVAliPay).DELETE(IPBRowID)
	q myrtn
}

ClassMethod GetDelPrt(PrtStr, SucPrt)
{
	s PrtStr=$e(PrtStr,3,$l(PrtStr))
	s DelPrtStr=""
	i SucPrt="" d
	.s DelPrtStr=PrtStr
	e  d
	.s DelPrtStr=$p(PrtStr,SucPrt,2)
	q DelPrtStr
}

/// w ##class(DHCExternalService.BillInterface.Service.DHCOPBillPayLogic).GetPayModeHardComm("OP",22)
ClassMethod GetPayModeHardComm(invType, PayMode)
{
	n (invType,PayMode)	
	s HardDr=""
	s invType=" "_invType,PayMode=" "_PayMode
	i $d(^User.DHCCTPayModeExpI("PMEPayModeDRIndex",invType,PayMode)) d
	.s HardRowID=$o(^User.DHCCTPayModeExpI("PMEPayModeDRIndex",invType,PayMode,""))
	.s HardDr=$LIST(^User.DHCCTPayModeExpD(HardRowID),3)
	.s IfMode=$LIST(^User.DHCCTPayModeExpD(HardRowID),4)
	.s tmpPayMode=$tr(PayMode," ","")
	.s HardDr=HardDr_"^"_IfMode_"^"_tmpPayMode
	q HardDr
}

ClassMethod GetRcptNo(itmjs As %Library.String = "", itmjsex As %Library.String = "", Guser As %String, deposittype As %String) As %String
{
	k P1
	s Guser=$g(Guser),deposittype=$g(deposittype)
	s rowid="",endno="",curno="",title=""
	i deposittype="" s deposittype="住院押金"
	i (deposittype'="")&&(Guser'="")  d
	.s depttypedr=""
	.i deposittype="住院押金"  s depttypedr="I"
	.i deposittype="病历押金"  s depttypedr="M"
	.i deposittype="门诊押金"  s depttypedr="O"
	.i deposittype="急诊押金"  s depttypedr="E"
	.i deposittype="挂号押金"  s depttypedr="R"
	.i deposittype="注册押金"  s depttypedr="L"
	.s rcptrowid=0
	.f  s rcptrowid=$o(^DHCSFRECEIPT(rcptrowid)) q:rcptrowid=""  d
	..s useflag=$p(^DHCSFRECEIPT(rcptrowid),"^",7)
	..q:useflag'="1"
	..s lquser=$p(^DHCSFRECEIPT(rcptrowid),"^",8)
	..q:Guser'=lquser
	..s loc=$p(^DHCSFRECEIPT(rcptrowid),"^",15)
	..q:(loc'=depttypedr)
	..s endno=$p(^DHCSFRECEIPT(rcptrowid),"^",4)
	..s curno=$p(^DHCSFRECEIPT(rcptrowid),"^",5)
	..s title=$p(^DHCSFRECEIPT(rcptrowid),"^",9)
	..s rowid=rcptrowid
	s str=rowid_"^"_endno_"^"_curno_"^"_title
	
	q str
}

ClassMethod GetAgeDesc(DOB As %String, CalDate As %String) As %String
{
	q:DOB="" ""
	i DOB["/" s DOB=$zdh(DOB,4)
	i DOB["-" s DOB=$zdh(DOB,3)
	i CalDate["/" s CalDate=$zdh(CalDate,4)
	i CalDate["-" s CalDate=$zdh(CalDate,3)
	i CalDate="" s CalDate=+$h
	s Age=$$CalAge^at182(DOB,CalDate,"","","")
	s AgeYear=$P(Age,"|",12)
	s AgeMonth=$P(Age,"|",13)
	s AgeDay=$P(Age,"|",14)
	s AgeDesc=..FormatAge(AgeYear,AgeMonth,AgeDay)
	Q AgeDesc
}

ClassMethod FormatAge(AgeYear As %String, AgeMonth As %String, AgeDay As %String) As %String
{
	if AgeYear>0 s AgeDesc=AgeYear_"岁"
	else  d
	.if AgeMonth>0 s AgeDesc=AgeMonth_"月"
	.else  s AgeDesc=AgeDay_"天"
	Q AgeDesc
}

/// w ##class(DHCExternalService.BillInterface.Service.DHCOPBillPayLogic).SetTradeID(0,,C,3,6658^2300329^")
ClassMethod SetTradeID(HandCom As %String, BankCardNO As %String, BankTradeType As %String, HospDR As %String, ExpStr As %String) As %String
{
	n (HandCom,BankCardNO, BankTradeType,HospDR,ExpStr)
	s ^alisettrade($h)=HandCom_","_BankCardNO_","_BankTradeType_","_HospDR_","_ExpStr
	s $ZT="ERROR^DHCSSERR" 
	d ..tb()
	s Guser=$p(ExpStr,"!",1)
	s PrtInvStr=$p(ExpStr,"!",2)
	s Adm=$p(ExpStr,"!",3)
	s PapMi=$p(ExpStr,"!",4)
	s BankCode=""
	i +BankCardNO'=0 d
	.s CardInfo=##class(web.UDHCJFBaseCommon).GetPapmiByCardNO(BankCardNO)
	.s BankCode=$p(CardInfo,"^",5)
	s TradeID=""
	;
	;Insert DHC_INVBankTradePay
	k PLIST
	;s PLIST(4)=BankCardNO		;IBP_Pan	卡号
	;s CardRowid=$o(^DHCCARDi("CF",0,"CardNo",BankCardNO,""))
	;s myBankCardID=$p(^DHCCARD("CF"),"^",20)
	s TradeDate=+$h
	s TradeTime=$p($h,",",2)
	s PLIST(22)=TradeDate		;IBP_TradeDate HIS交易日期
	s PLIST(23)=TradeTime		;IBP_TradeTime	HIS交易时间
	s PLIST(26)=Guser
	s PLIST(27)=BankTradeType	;IBP_BankTradeType	银行交易类型
	s PLIST(28)=BankCode		;IBP_CardType	卡类型
	s PLIST(29)=HospDR			;IBP_Hospital_Dr 医院指针
	;s PLIST(40)=myBankCardID    ;银行ID
	i HandCom=2 s PLIST(40)=PrtInvStr
	i HandCom=2 s PLIST(46)=Adm
	i HandCom=2 s PLIST(47)=PapMi
	s myRtn=""
	i HandCom=1 s myRtn=##class(web.DHCOPBillINVBankPay).INSERT()
	i HandCom=2 s myRtn=##class(web.DHCOPBillINVAliPay).INSERT()
	s err=$p(myRtn,"^",1)
	s IBPRowID=$p(myRtn,"^",2)
	q:+err'=0 err_"^^"
	b ;nhcs
	s TradeID=..SetTransactionId(IBPRowID,HospDR)	;生成HIS端交易号
	;更新银行交易信息表
	i HandCom=1 s err=##class(web.DHCOPBillINVBankPay).SELECT(IBPRowID)
	i HandCom=2 s err=##class(web.DHCOPBillINVAliPay).SELECT(IBPRowID)
	b ;tro
	i +err'=0 TROLLBACK
	q:+err'=0 err_"^^"
	s PLIST(33)=TradeID	;IBPHISTradeID	HIS交易流水号
	i HandCom=1 s err=##class(web.DHCOPBillINVBankPay).UPDATE(IBPRowID)
	i HandCom=2 s err=##class(web.DHCOPBillINVAliPay).UPDATE(IBPRowID)
	i +err'=0 TROLLBACK
	q:+err'=0 err_"^^"
	d ..tc()
	s rtn=err_"^"_IBPRowID_"^"_TradeID
	q rtn
}

/// w ##class(web.DHCBillBMCLogic).FormatTerminalId(19028822)
ClassMethod FormatTerminalId(TerminalId)
{
	s len=$l(TerminalId)
	i len<15 d
	.s tmp="00000000000000"
	.s TerminalId=$e(tmp,1,$l(tmp)-$l(TerminalId))_TerminalId
	.s TerminalId="1"_TerminalId
	q TerminalId
}

/// w ##class(DHCExternalService.BillInterface.Service.DHCOPBillPayLogic).BMCUpdateTradeData(2,"OP",1624935,"","C","01603281403000009","<Response><TradeCode></TradeCode><BankCode></BankCode><BankDate></BankDate><BankTradeNo>1234567899999</BankTradeNo><ResultCode>0000</ResultCode><ResultContent> </ResultContent><PayCardNo></PayCardNo><BankAccDate>2016032178123</BankAccDate><RevTranFlag></RevTranFlag><PatientID></PatientID><PayAmt>174.61</PayAmt><OrgHISTradeNo></OrgHISTradeNo><OrgPaySeqNo></OrgPaySeqNo></Response>","22^269^2^15^6617^6617^^^")
/// w ##class(DHCExternalService.BillInterface.Service.DHCOPBillPayLogic).BMCUpdateTradeData(2,"OP","^1624957^","","C","01604061637000033","<Response><BankTradeNo>w001612016040600027</BankTradeNo><ResultCode>00</ResultCode><ResultContent>成功</ResultContent><BankAccDate>2016-04-06 16:37:31</BankAccDate><PatientID>00000036</PatientID><PayAmt>5503.0</PayAmt></Response>","22^269^2^15^6617^6617^^^")
ClassMethod BMCUpdateTradeData(HandCom As %String, PatType As %String, NewPrtRowid As %String, AbortPrtRowid As %String, BankTradeType As %String, HISTradeNo As %String, BankOutputXML As %String, ExpStr As %String)
{
	n (HandCom,PatType,NewPrtRowid,AbortPrtRowid,BankTradeType,HISTradeNo,BankOutputXML, ExpStr)
	;
	;s $ZT="ERROR^DHCSSERR" 
	s i=$i(^TMPBankOutputXML)
	s ^TMPBankOutputXML("CARDCPP","UPDATE",$zd(+$h,3),$zt($p($h,",",2),1),i)=HandCom_","_PatType_","_NewPrtRowid_","_AbortPrtRowid_","_BankTradeType_","_HISTradeNo_","_BankOutputXML_","_ExpStr
	s CTLocDR=$p(ExpStr,"^",1)
	s GroupDR=$p(ExpStr,"^",2)
	s HospDR=$p(ExpStr,"^",3)
	s ClientType=$p(ExpStr,"^",4)
	s TerminalID=$p(ExpStr,"^",5)
	s TerminalID=..FormatTerminalId(TerminalID)   //15位
	s ExtUserID=$p(ExpStr,"^",6)
	;
	s err=0
	i BankOutputXML[$c(10) s BankOutputXML=$tr(BankOutputXML,$c(10))
	b ;解析银行返回值
	s OutputObj=##class(DHCExternalService.BillInterface.DHCEntity.BankTradeOutput).%New()
	d OutputObj.XMLNodeDeserialize(.OutputObj,"Response",BankOutputXML)
    b
    s TradeCode=OutputObj.TradeCode	//交易代码
	s BankID=OutputObj.BankCode	//银行代码
	s BankDate=OutputObj.BankDate	//银行交易时间YYYYMMDDHHMMSS
	s BankTradeNo=OutputObj.BankTradeNo	//银行唯一流水号
	s ResultCode=OutputObj.ResultCode	//交易结果,错误代码表 0000：成功
	s ResultContent=OutputObj.ResultContent	//对错误/异常的详细描述信息
	s PayCardNo=OutputObj.PayCardNo	//银联卡号
	s BankAccDate=OutputObj.BankAccDate	//银行账务日期
	s RevTranFlag=OutputObj.RevTranFlag	//正反交易标志 1-退费
	s PatientID=OutputObj.PatientID	//患者主索引,登记号
	s PayAmt=OutputObj.PayAmt/100	//退款金额
	s OrgHISTradeNo=OutputObj.OrgHISTradeNo	//中国医大--自助机生成的交易号
	s OrgPaySeqNo=OutputObj.OrgPaySeqNo	//原支付小票号 HIS生成，唯一
	
	b ;t3
	d ..tb()
	;
	b ;更新银行交易信息表
	i (HandCom=1){
		i $d(^DHCINVBTPi(0,"PTN",HISTradeNo))'=0 d
		.s IBPRowID=$o(^DHCINVBTPi(0,"PTN",HISTradeNo,"0"))
		e  d
		.s err="-1007"
		.s IBPRowID=""
		.s ResultCode=""
		.s ResultContent=""
		i +err=0 s err=##class(web.DHCOPBillINVBankPay).SELECT(IBPRowID)
		b ;t4
		if ((+err=0)&((ResultCode="0000")!(ResultCode="00"))) {
			s PLIST(2)=ResultCode		;IBPRc
			s PLIST(3)=ResultContent			;IBP_Rc_detail
			s PLIST(4)=PayCardNo
			s PLIST(5)=+$g(PayAmt)
			s PLIST(8)=BankTradeNo	;IBP_RRN
			s PLIST(15)=$e(BankDate,1,10)
			s PLIST(16)=$e(BankDate,12,$l(BankDate))
			s PLIST(35)=OrgHISTradeNo	;中国医大--此字段存自助机生成的交易流水号
			s PLIST(37)=BankAccDate		
			s PLIST(24)=(+PayAmt)
			s PLIST(25)=PatType			;IBP_TradeType
			s PLIST(26)=ExtUserID
			s PLIST(32)=ClientType
			s PLIST(40)=BankID
			s PLIST(41)=RevTranFlag
			s PLIST(42)=TradeCode
			s err=##class(web.DHCOPBillINVBankPay).UPDATE(IBPRowID)	
			b ;t5
		}else {
				s ^TMPBankOutputXML("CARDCPP","FALSE",$zd(+$h,3),$zt($p($h,",",2),1),HISTradeNo)=BankOutputXML
		}
	
		if ((+err=0)&((ResultCode="0000")!(ResultCode="00"))) {
			if (PatType="OP"){
				s rtn=..InsertTradeSub(PatType,HISTradeNo,NewPrtRowid,AbortPrtRowid)
				s err=$p(rtn,"^",1)	
			}
		}
	}
	i (HandCom=2){
		i $d(^DHCINVALITPi(0,"PTN",HISTradeNo))'=0 d
		.s IBPRowID=$o(^DHCINVALITPi(0,"PTN",HISTradeNo,"0"))
		e  d
		.s err="-1007"
		.s IBPRowID=""
		.s ResultCode=""
		.s ResultContent=""
		i +err=0 s err=##class(web.DHCOPBillINVAliPay).SELECT(IBPRowID)
		b ;ttttt4
		if ((+err=0)&((ResultCode="0000")!(ResultCode="00"))) {
			s PLIST(2)=ResultCode		;IBPRc
			s PLIST(3)=ResultContent			;IBP_Rc_detail
			s PLIST(4)=PayCardNo
			s PLIST(5)=+$g(PayAmt)
			s PLIST(8)=BankTradeNo	;IBP_RRN
			s PLIST(15)=$e(BankAccDate,1,8)
			s PLIST(16)=$e(BankAccDate,9,$l(BankAccDate))
			s PLIST(35)=OrgHISTradeNo	;中国医大--此字段存自助机生成的交易流水号
			s PLIST(37)=BankAccDate		
			s PLIST(24)=(+PayAmt)
			s PLIST(25)=PatType			;IBP_TradeType
			s PLIST(26)=ExtUserID
			s PLIST(32)=ClientType
			s PLIST(40)=BankID
			s PLIST(41)=RevTranFlag
			s PLIST(42)=TradeCode
			s err=##class(web.DHCOPBillINVAliPay).UPDATE(IBPRowID)	
			b ;ttttt5
		}else {
		s ^TMPBankOutputXML("CARDCPP","FALSE",$zd(+$h,3),$zt($p($h,",",2),1),HISTradeNo)=BankOutputXML
		}
		b ;upkkkk
		if ((+err=0)&&((ResultCode="0000")!(ResultCode="00"))) {
			if (PatType="OP"){
				s rtn=..InsertAliTradeSub(PatType,HISTradeNo,NewPrtRowid,AbortPrtRowid)
				b ;bk000000
				s err=$p(rtn,"^",1)	
			}
		}
	}
	b ;newbk
	i +err'=0 d
	.TROLLBACK
	e  d
	.d ..tc()
	
	q err_"^"_$g(IBPRowID)_"^"_$g(ResultCode)_"^"_$g(ResultContent)
}

ClassMethod InsertAliTradeSub(PatType, HISTradeNo, NewPrtRowid, AbortPrtRowid)
{
	n (PatType,HISTradeNo,NewPrtRowid,AbortPrtRowid)
	s err=0
	s IBPRowID=$o(^DHCINVALITPi(0,"PTN",HISTradeNo,"0"))
	q:+IBPRowID=0 "-1^"
	;
	;更新银行交易信息表(DHC_InvBankTradePay)
	i +err=0 s err=##class(web.DHCOPBillINVAliPay).SELECT(IBPRowID)
	;
	if +err=0 {
		b ;插子表(DHC_InvBankConSub)
		s PrtRowIDStr=NewPrtRowid_"|"_AbortPrtRowid
		s InvCount=$L(PrtRowIDStr,"|")
		f k=1:1:InvCount d  q:+err'=0
		.k PLIST
		.s PLIST(0)=+IBPRowID
		.s myPrtRowID=+$p(PrtRowIDStr,"|",k)
		.q:+myPrtRowID=0
		.s PLIST(3)=myPrtRowID
		.i k=1 s sFlag="N" 	;对应发票的参照状态(N:新的发票Rowid,A:退费时负记录的Rowid)
		.i k=2 s sFlag="A"
		.s myPayModeDr=""
		.s IPM="0"
		.f  s IPM=$o(^DHCINVPRT(myPrtRowID,"P",IPM)) q:IPM=""  d
		..s s=$g(^DHCINVPRT(myPrtRowID,"P",IPM))
		..s PayModeDr=$p(s,"^",1)
		..s HandComFlag=..GetPayModeHardComm(PatType,PayModeDr)
		..q:+HandComFlag=0
		..s myPayModeDr=PayModeDr
		.s IPMDRSub=$o(^DHCINVPRTi(0,"PMDR",myPrtRowID,myPayModeDr,"P","0"))
		.s PLIST(5)=myPrtRowID_"||"_IPMDRSub	;IBS_InvPayMode_DR
		.s PLIST(6)="N"
		.s PLIST(7)=HISTradeNo	
		.&sql(insert into DHC_INVAliConSub (IAS_IAP_ParRef,IAS_INVPRT_DR,IAS_Status) values (:IBPRowID,:myPrtRowID,:sFlag))
		.b ;letbk
		.s err=err+SQLCODE
	}	
	;
	q err_"^"_IBPRowID
}

/// Creator:Lid
/// CreatDate:2011-12-07
/// Description:插入门诊子表
ClassMethod InsertTradeSub(PatType, HISTradeNo, NewPrtRowid, AbortPrtRowid)
{
	n (PatType,HISTradeNo,NewPrtRowid,AbortPrtRowid)
	s err=0
	s IBPRowID=$o(^DHCINVBTPi(0,"PTN",HISTradeNo,"0"))
	q:+IBPRowID=0 "-1^"
	;
	;更新银行交易信息表(DHC_InvBankTradePay)
	i +err=0 s err=##class(web.DHCOPBillINVBankPay).SELECT(IBPRowID)
	;
	if +err=0 {
		b ;插子表(DHC_InvBankConSub)
		s PrtRowIDStr=NewPrtRowid_"|"_AbortPrtRowid
		s InvCount=$L(PrtRowIDStr,"|")
		f k=1:1:InvCount d  q:+err'=0
		.k PLIST
		.s PLIST(0)=+IBPRowID
		.s myPrtRowID=+$p(PrtRowIDStr,"|",k)
		.q:+myPrtRowID=0
		.s PLIST(3)=myPrtRowID
		.i k=1 s PLIST(4)="N" 	;对应发票的参照状态(N:新的发票Rowid,A:退费时负记录的Rowid)
		.i k=2 s PLIST(4)="A"
		.s myPayModeDr=""
		.s IPM="0"
		.f  s IPM=$o(^DHCINVPRT(myPrtRowID,"P",IPM)) q:IPM=""  d
		..s s=$g(^DHCINVPRT(myPrtRowID,"P",IPM))
		..s PayModeDr=$p(s,"^",1)
		..s HandComFlag=##class(web.DHCBillBankLogic).GetPayModeHardComm(PatType,PayModeDr)
		..q:+HandComFlag=0
		..s myPayModeDr=PayModeDr
		.s IPMDRSub=$o(^DHCINVPRTi(0,"PMDR",myPrtRowID,myPayModeDr,"P","0"))
		.s PLIST(5)=myPrtRowID_"||"_IPMDRSub	;IBS_InvPayMode_DR
		.s PLIST(6)="N"
		.s PLIST(7)=HISTradeNo	
		.s err=##class(web.DHCOPBillINVBankConSub).INSERT()	
	}	
	;
	q err_"^"_IBPRowID
}

ClassMethod SetTransactionId(IBPRowid, HospDR)
{
	n (IBPRowid,HospDR)
	i +HospDR=0 d
	.s HospCode="1001"
	e  d
	.s HospCode=##Class(DHCExternalService.RegInterface.GetRelate).GetOuterHospitalCodeFromHISId(HospDR)
	.;s HospCode=$p(^CT("HOSP",HospDR),"^",1)
	.s HospCode=+HospCode
	s ServerCode=$g(^HISServerCode)
	s:ServerCode="" ServerCode=1		
	s CurrDate=$e($zd(+$h,8),3,8)
	s CurrTime=$tr($zt($p($h,",",2),2),":","")
	s tmp="000000"
	s:$l(IBPRowid)>6 IBPRowid=$e(IBPRowid,$l(IBPRowid)-5,$l(IBPRowid))
	s FormatIBPRowid=$e(tmp,1,$l(tmp)-$l(IBPRowid))_IBPRowid
	s rtn=HospCode_CurrDate_CurrTime_FormatIBPRowid
	q rtn
}

/// Creator:wangjian
/// CreatDate:2013-02-20
/// Desc:为不影响正常交押金把自助交押金单独插入押金表
ClassMethod InsertDeposit(dep, BankRequset) As %String
{
	n (dep, BankRequset)
	;向表ar_receipts,ar_rcptalloc,ar_rcptpaymode,dhc_sfprintdetail插入数据
    s deptype=$p(dep,"^",1)
    s payamt=$p(dep,"^",2)
    s paymode=$p(dep,"^",3)
    s company=$p(dep,"^",4)
    s bank=$p(dep,"^",5)
    s cardno=$p(dep,"^",6)
    s authno=$p(dep,"^",7)
    s adm=$p(dep,"^",8)
    s curno=$p(dep,"^",9)
    s gloc=$p(dep,"^",10)
    s userid=$p(dep,"^",11)
    s endno=$p(dep,"^",12)
    s title=$p(dep,"^",13)
    s banksub=$p(dep,"^",14)
    s comment=$p(dep,"^",15)
    s password=$p(dep,"^",16)
    s rcptrowid=$p(dep,"^",17)
    s rcptrowid=$g(rcptrowid)
    i adm'="" s papmi=$p(^PAADM(adm),"^",1)
    b   ;;;;;Add  by zhl shenyang  The same number with different title  S
    i (curno'="")&&($d(^DHCSFPRINTDETAIL(0,"RcptNo",curno)))  d
    .s SameNoDr="",SameFlag="N"
    .f  s SameNoDr=$o(^DHCSFPRINTDETAIL(0,"RcptNo",curno,SameNoDr))  q:(SameNoDr="")||(SameFlag="Y")  d
    ..s DataStr=$g(^DHCSFPRINTDETAIL(SameNoDr))
    ..s SameNoTitle=$p(DataStr,"^",29)
    ..i SameNoTitle=title  s SameFlag="Y"
    
    q:(curno'="")&&($d(^DHCSFPRINTDETAIL(0,"RcptNo",curno))'=0)&&($g(SameFlag)="Y") "-2"
       ;;;;;;;;zhl  E
    d ..tb()
    s payamt=+payamt
    k PLIST(1)
    s PLIST(7)=+$h
    s PLIST(11)=0,PLIST(49)=userid,PLIST(52)=papmi,PLIST(3)=gloc,PLIST(48)=gloc_"||"
    &sql(insert into ar_receipts values :PLIST())
    i SQLCODE'=0 Trollback
    b ;99
    q:SQLCODE'=0 SQLCODE
    s id=$g(%ROWID)
    k PLIST
    s PLIST(0)=id
    s PLIST(5)=payamt,PLIST(3)=paymode,PLIST(4)=bank,PLIST(21)=company,PLIST(6)=cardno,PLIST(7)=authno
    &sql(insert into ar_rcptpaymode values :PLIST())
    b ;98
    i SQLCODE'=0 Trollback
    q:SQLCODE'=0 SQLCODE
    K PLIST
    s PLIST(0)=id
    S PLIST(9)=adm,PLIST(4)=payamt,PLIST(17)=deptype
	&sql(insert into ar_rcptalloc values :PLIST())
	b ;97
	i SQLCODE'=0 Trollback
	q:SQLCODE'=0 SQLCODE	
	k PLSIT(1)
	s PLIST(2)=curno
    s PLIST(3)=$p($h,",")
    s PLIST(4)=$p($h,",",2)
    s PLIST(5)=adm
    s PLIST(6)=id
    s PLIST(7)=payamt
    s PLIST(8)=""
    s PLIST(9)="1"
    s PLIST(10)=paymode
    s PLIST(11)=bank
    s PLIST(12)=cardno
    s PLIST(13)=company
    s PLIST(14)=deptype
    s PLIST(15)=userid
    s PLIST(21)=userid
    s PLIST(22)="N"
    s PLIST(30)=""
    s PLIST(30)=title
    s PLIST(33)=""
    s PLIST(34)=comment
    s PLIST(35)=password
    s PLIST(36)=banksub  
    s PLIST(40)="N"  
    &sql(insert into dhc_sfprintdetail VALUES :PLIST())
    b  ;sfprint
    s prtrowid=$g(%ROWID)
    i SQLCODE'=0 Trollback
    q:SQLCODE'=0 SQLCODE
    s deptypedesc=$p(^ARC("ARCDT",deptype),"^",2)
    set retcode=0
    if (curno'="")
    {
    	s retcode=..Ok(curno,endno,userid,rcptrowid)
    	i retcode'=0 Trollback
    }
    ;s retcode=retcode+retcode1
    q:retcode'=0 retcode   
    b ;add by wangjian 2013-02-20 将请求入参插入DHCIPAutoDepBankData表
    s retcode=..InsertAutoDepBankData(BankRequset,prtrowid)
    b ;0090900
    i retcode'=0 Trollback
    q:retcode'=0 retcode
    
	d ..tc()
	q retcode_"^"_prtrowid_"^"_id
}

ClassMethod Ok(rcptno, endno, userid, rcptrowid)
{
   s ^xcr(3)=rcptno_"^"_endno_"^"_userid_"^"_rcptrowid
   s rcptrowid=$g(rcptrowid)
   q:(rcptrowid="") "-1"
    i rcptno=endno d 
    .s endflag="0"
    e  d
    .s rcptno=..incre("","",rcptno)
    .s endflag="1"
    b ;ok
    s retcode=0
    s retcode1=0
    s rcptid=""
    s startno=""
    i endflag="1"  d
    .&sql(update dhc_sfreceipt set Rcpt_currentno=:rcptno 
          where rcpt_rowid=:rcptrowid)
    .s retcode=retcode+SQLCODE
    e  d
    .&sql(update dhc_sfreceipt set Rcpt_currentno=:rcptno,
          Rcpt_useflag='2'
          where rcpt_rowid=:rcptrowid)
    .s retcode=retcode+SQLCODE	
	.&sql(select nvl(rcpt_rowid,""),Rcpt_startno 
	      into :rcptid,:startno
	      from dhc_sfreceipt 
	     where (rcpt_useflag is null or rcpt_useflag="") and Rcpt_lquser=:userid)
	.i (rcptid'="")&(SQLCODE=0)  d
	..&sql(update dhc_sfreceipt set Rcpt_currentno=:startno,
	              Rcpt_useflag='1'
	        where Rcpt_rowid=:rcptid)
	..s retcode=retcode+SQLCODE
	.e  d
	..s retcode1=retcode1+SQLCODE
	q retcode
}

ClassMethod incre(itmjs As %Library.String = "", itmjsex As %Library.String = "", invno As %String) As %String
{
 ;发票号自动累加1
	s lng=$l(invno)
	s ret=invno+1
	s l=$l(ret)
	f i=lng:(-1):(l+1) d
	.s ret="0"_""_ret
	//s retval=itmjs_"('"_$ZCVT(ret,"O","JS")_"');"
    //i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(ret,"O","JS")_"');"
    //&javascript<#(retval)#>
	q ret
}

ClassMethod InsertAutoDepBankData(BankRequset, prtrowid)
{
	s mybankdate=$p(BankRequset,"^",12)
	i mybankdate["/" s mybankdate=$zdh(mybankdate,4)
	i mybankdate["-" s mybankdate=$zdh(mybankdate,3)
	i $l(mybankdate)=8 s mybankdate=$zdh(mybankdate,8)
	K PLIST	
	b ;BankRequset
	s PLIST(2)=$p(BankRequset,"^",1)
    s PLIST(3)=$p(BankRequset,"^",2)
    s PLIST(4)=$p(BankRequset,"^",3)
    s PLIST(5)=$p(BankRequset,"^",4)     //user
    s PLIST(6)=$p(BankRequset,"^",5)
    s PLIST(7)=$p(BankRequset,"^",6)
    s PLIST(8)=$p(BankRequset,"^",7)     //adm
    s PLIST(9)=$p(BankRequset,"^",9)
    s PLIST(10)=$p(BankRequset,"^",10)
    s PLIST(11)=$p(BankRequset,"^",11)
    ;"^^^"_myuserid_"^^^"_Adm_"^"_TotalAmt_"^22^"_HISTradeNo_"^^^^^D^"_abdrowid
    s PLIST(12)=mybankdate               //date
    s PLIST(14)=+$h
    s PLIST(15)=$p($h,",",2)
    s PLIST(16)=$p(BankRequset,"^",13)
    s PLIST(17)=$p(BankRequset,"^",14)
    s PLIST(18)=+$p(BankRequset,"^",8)
    s PLIST(19)=prtrowid
    s PLIST(20)=$p(BankRequset,"^",15)
    s PLIST(21)=$p(BankRequset,"^",16)
    s PLIST(22)=$p(BankRequset,"^",17)	;Lid 2013-06-04 dhc_invprtzy表指针
    s PLIST(23)=$p(BankRequset,"^",18)	;Lid 2013-06-04 ar_rcptpaymode表指针
    s PLIST(24)=$p(BankRequset,"^",19)  ;参考号pos撤销用
    &sql(insert into DHCIPAutoDepBankData VALUES :PLIST())
	b ;0092345
	q SQLCODE
}

/// w ##class(DHCExternalService.BillInterface.Service.DHCOPBillPayLogic).GetRecTXTFromFTP("2015-04-08")
ClassMethod GetRecTXTFromFTP(inputName)
{
	n (inputName)
	s ftpIP="10.10.30.56"
	s userName="administrator"
	s password="Admin123"
	s port=21
	;门诊对账数据
	s path="/weixin/"
    i inputName="" d
    .s fileName=$zd(+$h-1,3)  
    e   s fileName=inputName
	s file=path_fileName_".csv"
	
	;b ;
	s stream=##class(%GlobalCharacterStream).%New()
	s ftp=##class(%Net.FtpSession).%New()
	;s char=##class(%IO.I.TranslationDevice).GetCharEncodingTable("GB18030")
	;s ftp.TranslateTable=char	
	If 'ftp.Connect(ftpIP,userName,password,port) Quit "请查证IP地址,用户名,密码,端口号是否正确"
	;获取文本列表
	n fileArray,key
	i 'ftp.NameList(path,.fileArray) q "获取FTP目录文件列表失败"
	s key="",i=$i(BanList)
	f  s BanList(i)=fileArray.GetNext(.key),i=i+1 q:(key="")
	s num=""
	f  s num=$o(BanList(num)) q:num=""  d
	.s BanListInfo=BanList(num)
	.q:BanListInfo'=file
	.s file=BanListInfo
	;b ;得到正确文本

	if 'ftp.Retrieve(file,stream) Quit "对账文本不存在"
	s Len=0,FalseNum=0,strflag=1
	s rtn=0
    while ('stream.AtEnd)&&(rtn'="end") {
	    s Info=stream.ReadLine()
	    s Info=$zcvt(Info,"I","GB18030")
	    ;b ;Info
	    if (strflag>1) {
    		q:(Info="")
    		;b ;不管中间是否有失败,全部执行完毕,SaveBalanceInfo 这个方法里有存储失败的数据,可单独处理
    		s rtn=..SaveBalanceInfo(Info)
    		i +rtn'=0 d
    		.s FalseNum=FalseNum+1
			.;失败记录
			.s ^TMPSaveBalance(fileName,FalseNum)=Info
		}
		s strflag=strflag+1
	}
    If 'ftp.Logout() Quit
    
	q FalseNum
}

/// wangjian
/// 2014-07-18
/// 保存对账数据
ClassMethod SaveBalanceInfo(BalanceInfo)
{
	q:BalanceInfo="" 0
	s BalanceInfo=$tr(BalanceInfo,"`","")
	s rtn=0
	s BanLen=$l(BalanceInfo)
	s TradeFlagDesc=$tr($p(BalanceInfo,",",11),$c(9),"")
	q:TradeFlagDesc["提现" 0
	
	s histradeno=$p(BalanceInfo,",",16)
	i histradeno="" s TradeFlag=0,TradeAmt=$tr($p(BalanceInfo,",",13),$c(9),"")
	e   s TradeFlag=1,TradeAmt=$tr($p(BalanceInfo,",",17),$c(9),"")
	s Date=$tr($p(BalanceInfo,",",1),$c(9),"")
	s IBTFinDate=$zdh($p(Date," "),3)
	s IBTTradeTime=$tr($p(Date," "),"-","")_$tr($p(Date," ",2),":","")
	;
	k PLIST
	;s PLIST(2)=$tr($p(BalanceInfo,",",1),$c(9),"")
	s PLIST(4)=$o(^CT("HOSP","0"))	
	s PLIST(10)=$tr($p(BalanceInfo,",",2),$c(9),"")
	s PLIST(11)=TradeFlag   ;收退标志
	s PLIST(12)=$o(^CT("CTPM",0,"Code","WZF",""))
	s PLIST(13)=$zabs(TradeAmt)
	s PLIST(14)=IBTTradeTime
	
	i TradeFlag=0 s PLIST(15)=$tr($p(BalanceInfo,",",7),$c(9),"")
	i TradeFlag=1 s PLIST(15)=$tr($p(BalanceInfo,",",16),$c(9),"")
	s PLIST(16)=IBTFinDate

    d ..tb()
	s myRtn=..DHCINVBankBalanceINSERT()
	s rtn=$p(myRtn,"^",1)
	i +rtn=0 d
	.d ..tc()
	e  d
	.Trollback

	s rtn=0
	q rtn
}

ClassMethod DHCINVBankBalanceINSERT()
{
	K PLIST(1)
	;s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(INSERT INTO DHC_INVAliBalance Values PLIST())
	;d ..tc()
	
	s myRowID=%ROWID
	i 'SQLCODE d ..DHCINVBankBalanceSELECT(myRowID)
	
	q SQLCODE_"^"_myRowID
}

ClassMethod DHCINVBankBalanceSELECT(RowId)
{
	k PLIST
	&sql(SELECT * INTO PLIST() FROM DHC_INVAliBalance WHERE IAT_RowID= :RowId) 
	s PLIST=$o(PLIST(""),-1)
	q SQLCODE
}

ClassMethod tb()
{
	;n SQLCODE
	;TSTART  s SQLCODE=$zu(34)
	TSTART
	q
}

ClassMethod tc()
{
 new SQLCODE
 ;i $$intp^%qartp TCOMMIT  s SQLCODE=$zu(34)
 i $$intp^%qartp TCOMMIT
 q
}

}
