Import SQLUser

/// Lid
/// 2011-03-07
/// 门诊自助消息业务类
Class DHCExternalService.BillInterface.Service.DHCOPBillPayExp Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator:zhho
/// CreatDate:2016-03-21
/// Desc: 根据卡号及日期查询就诊记录
/// Input:
/// Return:<Response><ResultCode>0</ResultCode><ResultContent>获取就诊记录成功</ResultContent><AdmItems><AdmItem><AdmRowid>729124</AdmRowid><AdmDate>2016-03-21</AdmDate><AdmLoc>NKMZ-内科门诊</AdmLoc><AdmDoctor>吴震</AdmDoctor><AdmLocCode>内科门诊</AdmLocCode><AdmDoctorCode>2137</AdmDoctorCode><AdmAmt>155.76</AdmAmt><AdmReasonCode>9</AdmReasonCode><AdmReasonDesc>自费</AdmReasonDesc></AdmItem></AdmItems></Response>
/// Debug:w ##class(DHCExternalService.BillInterface.Service.DHCOPBillPayExp).GetAdmByCardNo("<Request><CardNo></CardNo><SecrityNo></SecrityNo><Userid>cashier</Userid><StartDate></StartDate><EndDate></EndDate><PatAmt></PatAmt><BankTradeInfo></BankTradeInfo><AdmInfo></AdmInfo><InsuTypeDR></InsuTypeDR><PayModeCode></PayModeCode><TransactionId></TransactionId><InvoiceNO></InvoiceNO><YBChargeData></YBChargeData><ReceiptId></ReceiptId><PatientID>00326006</PatientID><ExpStr></ExpStr></Request>")
/// w ##class(DHCExternalService.BillInterface.Service.DHCOPBillPayExp).GetAdmByCardNo("<Request><TradeCode></TradeCode><HospitalId>3</HospitalId><CardNo>000000003017</CardNo><PatientID>00000036</PatientID><StartDate>2016-04-04</StartDate><EndDate>2016-04-05</EndDate></Request>")
ClassMethod GetAdmByCardNo(Input As %String) As %String
{
	set $ZT="GetAdmByCardNoET"
	
	New (Input)
	s ^zhhogetadm=Input
	k ^ChargeCheck(+$h-7)  ;保留一周日志
	set InputObj=##class(DHCExternalService.BillInterface.DHCEntity.AutoPayInputInfo).%New()
    Do InputObj.XMLNodeDeserialize(.InputObj,"Request",Input)
    set CardNo=InputObj.CardNo
    set SecrityNo=InputObj.SecrityNo
    set PatNo=InputObj.PatientID
    set StDate=InputObj.StartDate 
    set EndDate=InputObj.EndDate
    if (StDate["-") set StDate=$ZDH(StDate,3)
    if (EndDate["-") set EndDate=$ZDH(EndDate,3) 
    set UserCode=InputObj.Userid
    i UserCode="" s UserCode="wx002"
	set CardNo=$tr(CardNo,$c(0),"")
  	set OutputXML=""
  	set OutputObj=##class(DHCExternalService.BillInterface.DHCEntity.AdmItems).%New()
  	
    if ((CardNo="")&&(PatNo="")){
	   set OutputObj.ResultCode=-1
	   set OutputObj.ResultContent="卡号和登记号不能都为空"
	   set OutputXML=""
	   Do OutputObj.XMLExportToString(.OutputXML,"Response")
	   Do OutputObj.%Close()
	}
	quit:((CardNo="")&&(PatNo="")) OutputXML
	
	
	set Userid=""
    set:UserCode'="" UserCode=$$ALPHAUP^SSUTIL4(UserCode)
	set:UserCode'="" Userid=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,""))
	set:UserCode="" Userid=""
	if ((Userid="")||('$d(^SSU("SSUSR",Userid)))){
	   set OutputObj.ResultCode=-3
	   set OutputObj.ResultContent="无此收费员或传入有误."
	   set OutputXML=""
	   Do OutputObj.XMLExportToString(.OutputXML,"Response")
	   Do OutputObj.%Close()
	}
	quit:(Userid="")||('$d(^SSU("SSUSR",Userid))) OutputXML
	set Papmi=""
	set PatInfo=##class(DHCExternalService.BillInterface.Service.DHCOPBillPayLogic).GetPatCommInfoByCardNo(CardNo,PatNo)
	set Papmi=$p(PatInfo,"^",1)
	b ;kkk
	if (Papmi="") {
	    set OutputObj.ResultCode=-2
	   	set OutputObj.ResultContent="无此病人信息"
	  	Do OutputObj.XMLExportToString(.OutputXML,"Response")   
	  	Do OutputObj.%Close()
	}
    quit:Papmi="" OutputXML

    set Type="" ,AdmStr=""
    set AdmInfo=##class(web.DHCOPCashierIF).GetToDayAdmStr(Papmi,"N")
    For i=1:1:$l(AdmInfo,"^") Do
    .set Adm=$p(AdmInfo,"^",i)
    .quit:+Adm=0
    .set Data=$g(^PAADM(Adm))
    .set AdmDate=$p(Data,"^",6)
    .set AdmreasonDr=$p(^PAADM(Adm,1),"^",7)
    .set AdmreasonDesc=$p(^PAC("ADMREA",AdmreasonDr),"^",2)
    .set AdmreasonCode=$p(^PAC("ADMREA",AdmreasonDr),"^",1)
    .quit:((StDate'="")&&(AdmDate<StDate))||((EndDate'="")&&(AdmDate>EndDate))
    .quit:$p(Data,"^",20)["C"
    .set rtn=##class(web.UDHCJFBILL).BILL(Adm,Userid)
	.quit:+rtn'=0
	.set myPayedFlag=""
	.set myPBRowID=0
	.set billamt=0
	.For  set myPBRowID=$o(^DHCPB(0,"ADM", Adm, myPBRowID)) quit:((myPBRowID="")!(myPayedFlag="B"))  Do
	..set myPayedFlag=$p($g(^DHCPB(myPBRowID)),"^",16)
	..quit:(myPayedFlag'="B")
	..set totamt=+$p($g(^DHCPB(myPBRowID)),"^",8)
	..set PBO="0"
	..For  set PBO=$o(^DHCPB(myPBRowID,"O",PBO))  quit:PBO=""  Do
	...quit:('$D(^DHCPB(myPBRowID,"O",PBO)))||($d(^DHCPB(myPBRowID,"O",PBO))=10)
	...set PBord=$p($g(^DHCPB(myPBRowID,"O",PBO)),"^",4)
	...set PBOBillQty=+$p($g(^DHCPB(myPBRowID,"O",PBO)),"^",5)
	...set PBORefundQty=+$p($g(^DHCPB(myPBRowID,"O",PBO)),"^",6)
	...set PBOQty=PBOBillQty+PBORefundQty
	...set PBOUnitPrice=+$p($g(^DHCPB(myPBRowID,"O",PBO)),"^",7)
	...set PBOPatShare=+$p($g(^DHCPB(myPBRowID,"O",PBO)),"^",11)
	...quit:PBOPatShare=0
	...set OrdRecLoc=$p($g(^OEORD(+PBord,"I",$p(PBord,"||",2),3)),"^",6)
	...set OrdStat=$p($g(^OEORD(+PBord,"I",$p(PBord,"||",2),1)),"^",13)
	...set:OrdStat'="" OrdStat=$p($g(^OEC("OSTAT",OrdStat)),"^",1)
	...quit:((OrdStat'="V")&(OrdStat'="E"))
	...set billamt=billamt+PBOPatShare 
	..;set billamt=billamt+totamt
	.quit:billamt=0
    .set admdep=$p(Data,"^",4)
    .set admdepdesc=$p($p($g(^CTLOC(admdep)),"^",2),"-",2)
    .set admdepcode=$p($g(^CTLOC(admdep)),"^",1)
	.set admdocdesc=""
	.set admdoc=$p(Data,"^",9)
	.if admdoc'="" set admdocdesc=$p($g(^CTPCP(admdoc,1)),"^",2),admdoccode=$p($g(^CTPCP(admdoc,1)),"^",1)	
    .if AdmStr=""  set AdmStr=Adm_"^"_$zd(AdmDate,3)_"^"_admdepdesc_"^"_admdocdesc
    .Else   set AdmStr=AdmStr_$c(2)_Adm_"^"_$zd(AdmDate,3)_"^"_admdepdesc_"^"_admdocdesc
    .set AdmItemObj=##class(DHCExternalService.BillInterface.DHCEntity.AdmItem).%New()
    .set AdmItemObj.AdmRowid=Adm
 	.set AdmItemObj.AdmDate=$zd(AdmDate,3)
 	.set AdmItemObj.AdmLoc=admdepdesc
 	.set AdmItemObj.AdmDoctor=admdocdesc
 	.set AdmItemObj.AdmLocCode=admdepcode
 	.set AdmItemObj.AdmDoctorCode=admdoccode
 	.set AdmItemObj.AdmAmt=billamt*100
 	.set AdmItemObj.AdmReasonCode=AdmreasonCode
 	.set AdmItemObj.AdmReasonDesc=AdmreasonDesc
 	.Do OutputObj.AdmItems.Insert(AdmItemObj)
    if (AdmStr'=""){
		set OutputObj.ResultCode=0
		set OutputObj.ResultContent="获取就诊记录成功"    
	}Else{
		set OutputObj.ResultCode=-4
		set OutputObj.ResultContent="此病人没有需要缴费的就诊记录"	
	}
	Do OutputObj.XMLExportToString(.OutputXML,"Response") 
 	Do OutputObj.%Close()
	quit OutputXML
	;
GetAdmByCardNoET
	set OutputObj=##class(DHCExternalService.BillInterface.DHCEntity.AdmItems).%New()
	set OutputObj.ResultCode=-10
	set OutputObj.ResultContent="程序处理错误:"_$ZERROR
	Do OutputObj.XMLExportToString(.OutputXML,"Response")
	quit OutputXML
}

/// Creator:Lid
/// CreatDate:2011-03-07
/// Desc:  将病人当天当前科室就诊的医嘱信息对应的费用按门诊大类统计输出
/// 	Input:
/// 	Return:
/// 	Debug:w ##class(DHCExternalService.BillInterface.Service.DHCOPBillPayExp).GetBillInfo("<Request><CardNo></CardNo><SecrityNo></SecrityNo><PatientID>00326006</PatientID><Userid>cashier</Userid><StartDate></StartDate><EndDate></EndDate><AdmInfo>729124</AdmInfo><PatAmt></PatAmt><BankTradeInfo></BankTradeInfo><ExpStr>03</ExpStr></Request>")
/// w ##class(DHCExternalService.BillInterface.Service.DHCOPBillPayExp).GetBillInfo("<Request><TradeCode></TradeCode><CardNo>000000003017</CardNo><PatientID>00000036</PatientID><AdmInfo>729145</AdmInfo></Request>")
ClassMethod GetBillInfo(Input As %String) As %GlobalCharacterStream
{
	set $ZT="GetBillInfoET"
    new (Input)
    s ^testbill=Input
	set ShowDetailFlag=""  ;药品是否显示明细开关  1 显示  非1 不显示
    set err=0
    set streamObj=##class(%GlobalCharacterStream).%New()
	set inputObj=##class(DHCExternalService.BillInterface.DHCEntity.AutoPayInputInfo).%New()
    Do inputObj.XMLNodeDeserialize(.inputObj,"Request",Input)
    set CardNo=inputObj.CardNo
    set SecrityNo=inputObj.SecrityNo
    set UserCode=inputObj.Userid
    set StDate=inputObj.StartDate 
    set EndDate=inputObj.EndDate
    set AdmInfo=inputObj.AdmInfo
    set ExpStr=inputObj.ExpStr
    set PatNo=inputObj.PatientID
    i UserCode=""  s UserCode="wx002"
    set Papmi=""
    set OutputXML=""
	if (CardNo'=""){
    set CardID=""
    set Data=##class(web.UDHCAccManageCLSIF).getaccinfofromcardno(CardNo,SecrityNo,"$c(2)_$c(2)_PatInfo") ;20130109
    set Papmi=$p(Data,"^",8)
    set AccMRowID=$p(Data,"^",2)
    set AccMBalance=$p(Data,"^",5)
    set AccMDepPrice=$p(Data,"^",6)
    set AccMAccType=$p(Data,"^",11)
    set AccMCardTypeDR=$p(Data,"^",13)    
	}
	b ;kk
	if (PatNo'=""){
		set PatNo=$$ALPHAUP^SSUTIL4(PatNo) 
		set Papmi=$o(^PAPERi("PAPMI_PatNo",PatNo,""))
	}
	b ;k0
	set PatOrderObj=##class(DHCExternalService.BillInterface.DHCEntity.PatOrder).%New()	
	if (Papmi="") {
	    set PatOrderObj.ResultCode=-2
	   	set PatOrderObj.ResultContent="无此病人信息"
	  	Do PatOrderObj.XMLExportToString(.OutputXML,"Response")   
	  	Do PatOrderObj.%Close()
	}
    quit:Papmi="" OutputXML
  	
  	
	set PapNo=$p(^PAPER(Papmi,"PAT",1),"^",1)   ;登记号
	set PapName=$p(^PAPER(Papmi,"ALL"),"^",1)   ;姓名
	set Sex=$p(^PAPER(Papmi,"ALL"),"^",7)       ;性别
	if Sex'="" set Sex=$p(^CT("SEX",Sex),"^",2)
	set PatientDOB=$P($G(^PAPER(Papmi,"ALL")),"^",6)
	set PatAge=##class(DHCExternalService.BillInterface.Service.DHCOPBillPayLogic).GetAgeDesc(PatientDOB,+$h)
	set:UserCode'="" UserCode=$$ALPHAUP^SSUTIL4(UserCode)
	set:UserCode'="" Userid=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,""))
	if ((Userid="")||('$d(^SSU("SSUSR",Userid)))){
		set PatOrderObj.ResultCode=-3
		set PatOrderObj.ResultContent="无此收费员."
		set OutputXML=""
		Do PatOrderObj.XMLExportToString(.OutputXML,"Response")
		Do PatOrderObj.%Close()
	}
	quit:(Userid="")||('$d(^SSU("SSUSR",Userid))) OutputXML
	Kill ^TMP("DHCOPBillAuto","BillInfo",+$h,$j,Papmi)
	set gLoc=$p($g(^SSU("SSUSR",Userid)),"^",4)
	set Grup=$p($g(^SSU("SSUSR",Userid)),"^",5)
	set OPGS=$o(^DHCOPGSi("GS",0,"GSDR",Grup,""))
	set RecLoc=""
	if Grup'=""  d
	.set RecLoc=##class(web.UDHCOPGSConfig).ReadRLByGPRowID(Grup,gLoc)
	set Adm="",AdmStr="",billnostr=""
	;获取病人费别列表
	set PatPrescTypeList=##class(web.DHCOPCashierIF).GetPatPrescTypeList(Papmi,"")
	;set PrescTypeNum=$l(PatPrescTypeList,$c(2))
	set DefInsuType=$p($p(PatPrescTypeList,$c(2),1),"^",3)	;取默认费别
	set rtn=0
    set AdmInfo1=##class(web.DHCOPCashierIF).GetToDayAdmStr(Papmi,"N")
    For i=1:1:$Length(AdmInfo1,"^") Do
    .set Adm=$p(AdmInfo1,"^",i)
    .quit:+Adm=0
	.set AdmDate=$p($g(^PAADM(Adm)),"^",6)
	.set Visit=$p($g(^PAADM(Adm)),"^",20)
	.quit:(AdmInfo'="")&&(("^"_AdmInfo_"^")'[("^"_Adm_"^"))
	.quit:Visit'["A"
	.if AdmStr=""  s AdmStr=Adm
	.Else  set AdmStr=AdmStr_"^"_Adm
	.set rtn=##class(web.UDHCJFBILL).BILL(Adm,Userid)
	.quit:+rtn'=0
	.set myPayedFlag=""
	.set myPBRowID=0
	.set ARPBLRowid=""
	.For  set myPBRowID=$O(^DHCPB(0,"ADM", Adm, myPBRowID)) quit:((myPBRowID="")!(myPayedFlag="B"))  Do
	..set myPayedFlag=$p($g(^DHCPB(myPBRowID)),"^",16)
	..quit:(myPayedFlag'="B")
	..set ARPBLRowid=myPBRowID
	.if $g(ARPBLRowid)'=""  Do
	..if billnostr=""  set billnostr=ARPBLRowid
	..Else  set billnostr=billnostr_"^"_ARPBLRowid
	.quit:(+rtn)'=0
	if (billnostr=""){
		set PatOrderObj.ResultCode=-5
		set PatOrderObj.ResultContent="此病人无医嘱信息."
		set OutputXML=""
		Do PatOrderObj.XMLExportToString(.OutputXML,"Response")
		Do PatOrderObj.%Close()
	}
	quit:billnostr="" OutputXML
	set TBillCount=$l(billnostr,"^")
	For i=1:1:TBillCount quit:+rtn'=0  Do
	.set AdmBill=$p(billnostr,"^",i)
	.set PBO="0"
	.For  set PBO=$o(^DHCPB(AdmBill,"O",PBO))  quit:PBO=""  Do
	..quit:('$D(^DHCPB(AdmBill,"O",PBO)))||($d(^DHCPB(AdmBill,"O",PBO))=10)
	..set PBord=$p($g(^DHCPB(AdmBill,"O",PBO)),"^",4)
	..set PBOBillQty=+$p($g(^DHCPB(AdmBill,"O",PBO)),"^",5)
	..set PBORefundQty=+$p($g(^DHCPB(AdmBill,"O",PBO)),"^",6)
	..set PBOQty=PBOBillQty+PBORefundQty
	..set PBOUnitPrice=+$p($g(^DHCPB(AdmBill,"O",PBO)),"^",7)
	..set PBOPatShare=+$p($g(^DHCPB(AdmBill,"O",PBO)),"^",11)
	..quit:PBOPatShare=0
	..set OrdRecLoc=$p($g(^OEORD(+PBord,"I",$p(PBord,"||",2),3)),"^",6)
	..set OrdStat=$p($g(^OEORD(+PBord,"I",$p(PBord,"||",2),1)),"^",13)
	..set:OrdStat'="" OrdStat=$p($g(^OEC("OSTAT",OrdStat)),"^",1)
	..quit:((OrdStat'="V")&(OrdStat'="E"))
	..quit:(RecLoc'="")&&(RecLoc'[OrdRecLoc)
	..set Limit=##class(web.UDHCOEORDOPIF).ReadSkinRtnFlag(PBord)    ;;;add by zhl 2010.03.02
	..quit:Limit="Y"
	..set OrdIns=$p($g(^OEORD(+PBord,"I",$p(PBord,"||",2),11)),"^",18)
    ..set:OrdIns="" OrdIns=##class(web.DHCBillCons).ReadDefInsType()
	..set ArcimRowid=$p($g(^DHCPB(AdmBill,"O",PBO)),"^",3)
	..set ArcimDesc=$p($g(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1)),"^",2) ;名称
	..set PackUOMRowid=$p($g(^ARCIM(+ArcimRowid,1,8)),"^",14) ;整包装单位
	..set OEPrice=$p($g(^OEORD(+PBord,"I",$p(PBord,"||",2),3)),"^",25)		;;取出P   价格 OE_OrdItem->OEORI_Price
	..set PackQty=$p($g(^OEORD(+PBord,"I",$p(PBord,"||",2),9)),"^",4)
	..set PackUOM=""
	..if PackUOMRowid'=""  Do
	...set PackUOM=$p(^CT("UOM",PackUOMRowid),"^",2)
	..set ItemCatDR=$p($g(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1)),"^",10)	;ARC_ItemCat
	..set OrdCatDR=$p(^ARC("IC",ItemCatDR),"^",8)								;OEC_OrderCategory
	..set OrderType=$P(^ARC("IC",ItemCatDR),"^",7)  ;ARC_ItemCat->ARCIC_OrderType
	..set OrdIns=$p($g(^OEORD(+PBord,"I",$p(PBord,"||",2),11)),"^",18) ;OEORI_BBExtCode
    ..set:OrdIns="" OrdIns=##class(web.DHCBillCons).ReadDefInsType()
    ..set OrdInsSource=$p(^PAC("ADMREA",OrdIns),"^",9)
    ..set DefInsuTypeSource=$p(^PAC("ADMREA",DefInsuType),"^",9)
    ..set AdmReasonCode=$p(^PAC("ADMREA",OrdIns),"^",1)
    ..set DefInsuTypeFlag=1
    ..b ;admrea
    ..set:OrdIns=DefInsuType DefInsuTypeFlag=0
    ..i DefInsuTypeFlag=0  b ;bbbb
	..set JfCF=$o(^DHCTarC("CF",""))
	..if (OrdIns="")&(JfCF'="") set OrdIns=$P(^DHCTarC("CF",JfCF),"^",3)
	..;set SttDate=$p($g(^OEORD(+PBord,"I",$p(PBord,"||",2),1)),"^",9)    ///update by zhl 20110420
	..set SttDate=+$h
	..set BillPrice=##class(web.UDHCJFPRICE).GetOrderPrice("",OrdIns,ArcimRowid,SttDate,"","","",OEPrice)
	..set Price=$P(BillPrice,"^",1)
	..set OrdDiscPrice=$P(BillPrice,"^",2)
	..set OrdInsPrice=$P(BillPrice,"^",3)
	..set OrdPatPrice=$P(BillPrice,"^",4)
	..set INCI=$o(^INCI(0,"ARCIM_DR",+ArcimRowid,""))		;INC_Itm->RowID
	..if INCI'="" Do 
	...set INCIUOM=$p(^INCI(INCI,1),"^",10)   ;INC_Itm->INCI_CTUOM_DR
	...set ConFacDr=$o(^CT("CTCF",0,"UOM",PackUOMRowid,INCIUOM,""))
	...if ConFacDr="" set ConFac=1
	...Else  set ConFac=$P(^CT("CTCF",ConFacDr),"^",3)
	..Else  set ConFac=1
	..set refundqty=##class(web.DHCOutPhReturn).GetRetOrdQty(PBord) 
	..if refundqty'="" Do
	...set refundqty=refundqty/ConFac		;部分退药数量转换为整包装?
	..Else  Do
	...s refundqty=0		;
	..set Price=$fn(Price*ConFac,"",6)		;4--->6
	..set OrdDiscPrice=$fn(OrdDiscPrice*ConFac,"",6)	;4--->6
	..set OrdInsPrice=$fn(OrdInsPrice*ConFac,"",6)		;4--->6
	..set OrdPatPrice=$fn(OrdPatPrice*ConFac,"",6)		;4--->6
	..set Doseqty=$p($g(^OEORD(+PBord,"I",$p(PBord,"||",2),1)),"^",12)		;OEORI_PhQtyOrd
	..if (OrderType="R")&(PackQty="") set PackQty=1
	..;药品去整包装单位数量OEORI_QtyPackUOM而非药品取OEORI_PHQtyOrd;
	..if ((OrderType="R")&(PackQty'="")) Do
	...;s Doseqty=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",12)
	...;s PackQty=Doseqty
	..Else  Do 
	...set PackQty=Doseqty
	..set PackQty= PackQty-refundqty		;减去退的数量
	..;s PackQty=PackQty/ConFac
	..set TotalAmt=$fn(Price*PackQty,"",2)
	..set Amount=$fn(Price*PackQty,"",2)-$fn(OrdDiscPrice*PackQty,"",2)-$fn(OrdInsPrice*PackQty,"",2)
	..set DiscAmt=$fn(OrdDiscPrice*PackQty,"",2)
	..set PayorAmt=$fn(OrdInsPrice*PackQty,"",2)
	..set ArcQty=PackQty
	..set ArciDesc=ArcimDesc
	..set OCCat=OrdCatDR
	..set UnitPrice=OrdPatPrice
	..b ;kk999
	..set ^TMP("DHCOPBillAuto","BillInfo",+$h,$j,DefInsuTypeFlag,Papmi,OrdIns,OCCat)=+$g(^TMP("DHCOPBillAuto","BillInfo",+$h,$j,DefInsuTypeFlag,Papmi,OrdIns,OCCat))+Amount
	..set ^TMP("DHCOPBillAuto","BillInfo",+$h,$j,DefInsuTypeFlag,Papmi,OrdIns,OCCat,ArciDesc,"TotalAmt")=$g(^TMP("DHCOPBillAuto","BillInfo",+$h,$j,DefInsuTypeFlag,Papmi,OrdIns,OCCat,ArciDesc,"TotalAmt"))+TotalAmt
	..set ^TMP("DHCOPBillAuto","BillInfo",+$h,$j,DefInsuTypeFlag,Papmi,OrdIns,OCCat,ArciDesc,"PatShareAmt")=$g(^TMP("DHCOPBillAuto","BillInfo",+$h,$j,DefInsuTypeFlag,Papmi,OrdIns,OCCat,ArciDesc,"PatShareAmt"))+Amount
	..set ^TMP("DHCOPBillAuto","BillInfo",+$h,$j,DefInsuTypeFlag,Papmi,OrdIns,OCCat,ArciDesc,"DisAmt")=$g(^TMP("DHCOPBillAuto","BillInfo",+$h,$j,DefInsuTypeFlag,Papmi,OrdIns,OCCat,ArciDesc,"DisAmt"))+DiscAmt
	..set ^TMP("DHCOPBillAuto","BillInfo",+$h,$j,DefInsuTypeFlag,Papmi,OrdIns,OCCat,ArciDesc,"PayorAmt")=$g(^TMP("DHCOPBillAuto","BillInfo",+$h,$j,DefInsuTypeFlag,Papmi,OrdIns,OCCat,ArciDesc,"PayorAmt"))+PayorAmt
	..set:UnitPrice'="" ^TMP("DHCOPBillAuto","BillInfo",+$h,$j,DefInsuTypeFlag,Papmi,OrdIns,OCCat,ArciDesc,"Price")=UnitPrice
	..set ^TMP("DHCOPBillAuto","BillInfo",+$h,$j,DefInsuTypeFlag,Papmi,OrdIns,OCCat,ArciDesc,"Qty")=+$g(^TMP("DHCOPBillAuto","BillInfo",+$h,$j,DefInsuTypeFlag,Papmi,OrdIns,OCCat,ArciDesc,"Qty"))+ArcQty
	..set ^TMP("DHCOPBillAuto","BillInfo",+$h,$j,DefInsuTypeFlag,Papmi,OrdIns,OCCat,ArciDesc,"UOM")=PackUOM
	..;
    ;
	set FeeStr="",Total=0
	set DefInsuTypeFlag=$o(^TMP("DHCOPBillAuto","BillInfo",+$h,$j,""))
	if (DefInsuTypeFlag=""){
		set PatOrderObj.ResultCode=-4
	    set PatOrderObj.ResultContent="此病人无医嘱信息."	
	    set OutputXML=""
	   	Do PatOrderObj.XMLExportToString(.OutputXML,"Response")
	   	Do PatOrderObj.%Close()
	}
	quit:(DefInsuTypeFlag="") OutputXML
	b ;ttttttttt
	set AdmReasonCount=0
	s DefInsuTypeFlag=""  f  s DefInsuTypeFlag=$o(^TMP("DHCOPBillAuto","BillInfo",+$h,$j,DefInsuTypeFlag)) q:DefInsuTypeFlag=""  d
	.i $d(^TMP("DHCOPBillAuto","BillInfo",+$h,$j,DefInsuTypeFlag,Papmi))  Do
	..set InsuType=""
	..For  set InsuType=$o(^TMP("DHCOPBillAuto","BillInfo",+$h,$j,DefInsuTypeFlag,Papmi,InsuType)) q:InsuType=""  Do
	...set AdmReasonCount=+$g(AdmReasonCount)+1
	...set AdmReasonObj=##class(DHCExternalService.BillInterface.DHCEntity.AdmReason).%New()
	...set InsuTypeDesc=$p(^PAC("ADMREA",InsuType),"^",2)
	...b ;9999
	...set AdmReasonObj.InsuTypeDesc=InsuTypeDesc
	...set AdmReasonObj.InsuTypeDR=InsuType
	...set oestr=""
	...set catdr="0",Total=0
	...For  set catdr=$o(^TMP("DHCOPBillAuto","BillInfo",+$h,$j,DefInsuTypeFlag,Papmi,InsuType,catdr))  q:catdr=""  Do
	....set TarObj=##class(DHCExternalService.BillInterface.DHCEntity.TarOCCateItem).%New()	
	....set catstr=""
	....set CatDes=$p(^OEC("ORCAT",catdr),"^",2)
	....set CatFee=+$g(^TMP("DHCOPBillAuto","BillInfo",+$h,$j,DefInsuTypeFlag,Papmi,InsuType,catdr))
	....set TarObj.TarOCCateDesc=CatDes
	....set TarObj.TarOCCateAmt=CatFee*100
	....set Total=Total+CatFee
	....set Arcdes="0",ArcNum=0
	....for  set Arcdes=$o(^TMP("DHCOPBillAuto","BillInfo",+$h,$j,DefInsuTypeFlag,Papmi,InsuType,catdr,Arcdes))   quit:Arcdes=""   Do
	.....set TotalAmt=+$g(^TMP("DHCOPBillAuto","BillInfo",+$h,$j,DefInsuTypeFlag,Papmi,InsuType,catdr,Arcdes,"TotalAmt"))
	.....set Arcifee=+$g(^TMP("DHCOPBillAuto","BillInfo",+$h,$j,DefInsuTypeFlag,Papmi,InsuType,catdr,Arcdes,"PatShareAmt"))
	.....set DisAmt=+$g(^TMP("DHCOPBillAuto","BillInfo",+$h,$j,DefInsuTypeFlag,Papmi,InsuType,catdr,Arcdes,"DisAmt"))
	.....set PayorAmt=+$g(^TMP("DHCOPBillAuto","BillInfo",+$h,$j,DefInsuTypeFlag,Papmi,InsuType,catdr,Arcdes,"PayorAmt"))
	.....set Price=+$g(^TMP("DHCOPBillAuto","BillInfo",+$h,$j,DefInsuTypeFlag,Papmi,InsuType,catdr,Arcdes,"Price"))
	.....set Qty=+$g(^TMP("DHCOPBillAuto","BillInfo",+$h,$j,DefInsuTypeFlag,Papmi,InsuType,catdr,Arcdes,"Qty"))
	.....set UOM=$g(^TMP("DHCOPBillAuto","BillInfo",+$h,$j,DefInsuTypeFlag,Papmi,InsuType,catdr,Arcdes,"UOM"))
	.....i (ShowDetailFlag="1") ! (CatDes'["药")  d
	......set OrdItem=##class(DHCExternalService.BillInterface.DHCEntity.OEOrdItem).%New()
	......set OrdItem.ArcmiDesc=Arcdes
	......set OrdItem.DiscAmount=DisAmt
	......set OrdItem.PatientShareAmt=PayorAmt
	......set OrdItem.Price=Price
	......set OrdItem.Qty=Qty
	......set OrdItem.TotalAmount=TotalAmt*100
	......set OrdItem.UOM=UOM
	......do TarObj.OEOrdItems.Insert(OrdItem)
	......do TarObj.%Close()
	....do AdmReasonObj.TarOCCateItems.Insert(TarObj)
	...set AdmReasonObj.AmtSum=$j(Total*100,3,2)
	
	...do PatOrderObj.AdmReasons.Insert(AdmReasonObj)
 	...do AdmReasonObj.%Close()
 	set PatOrderObj.AdmReasonCount=AdmReasonCount
 	b ;567890
 	if (+Total>0){
	 	set PatOrderObj.ResultCode=0
	    set PatOrderObj.ResultContent="获取费用信息成功."
	}else{
		set PatOrderObj.ResultCode=-5
	    set PatOrderObj.ResultContent="此病人无医嘱信息."	
	}
	Do PatOrderObj.XMLExportToString(.OutputXML,"Response")
	Do PatOrderObj.%Close()
	;
	kill ^TMP("DHCOPBillAuto","BillInfo",+$h,$j)
	quit OutputXML
	;
GetBillInfoET
   	set PatOrderObj=##class(DHCExternalService.BillInterface.DHCEntity.PatOrder).%New()
   	set PatOrderObj.ResultCode=-10
   	set PatOrderObj.ResultContent="程序处理出错:"_$ZERROR
  	set OutputXML=""
   	Do PatOrderObj.XMLExportToString(.OutputXML,"Response")
   	Do PatOrderObj.%Close()
	quit OutputXML
}

/// w ##class(DHCExternalService.BillInterface.Service.DHCOPBillPayExp).PrintDirect("<Request><ReceiptId>1624957</ReceiptId></Request>")
ClassMethod PrintDirect(Input As %String) As %GlobalCharacterStream
{
	;Set $ZT="PrintDirectET"
	New (Input)
    Set err=0
    Set streamObj=##class(%GlobalCharacterStream).%New()
	Set inputObj=##class(DHCExternalService.BillInterface.DHCEntity.AutoPayInputInfo).%New()
    Do inputObj.XMLNodeDeserialize(.inputObj,"Request",Input)
    Set invrowidStr=inputObj.ReceiptId
    
    Set OutputXML=""
	Set OutputObj=##class(DHCExternalService.BillInterface.DHCEntity.AutoPayDirectResult).%New()
	If (invrowidStr=""){
		Set OutputObj.ResultCode=-3
   		Set OutputObj.ResultContent="传入为空收据"  
   		Do OutputObj.XMLExportToString(.OutputXML,"Response")
   		Do OutputObj.%Close()
	}
	q:(invrowidStr="") OutputXML
	b ;b0
	s WindowStr=""
	s length=$l(invrowidStr,"^")
	b ;01
	f i=1:1:length  d
	.s invRowID=$p(invrowidStr,"^",i) 
	.b ;02
	.q:+invRowID=0
	.q:'$d(^DHCINVPRT(invRowID))=1 
	.s dhcBCIRowid=0
	.f  s dhcBCIRowid=$o(^DHCBCI(0,"INV",invRowID,dhcBCIRowid)) q:dhcBCIRowid=""  d
	..s admRowId="",papmiRowId="",userName="",date="",sexRowId="",PatSex="",tmpAge="",PatAge="",mrRowId="",locRowId="",locName="",prtDate=""
	..s admRowId=$p(^DHCBCI(dhcBCIRowid),"^",3)
	..s locRowId=$p(^PAADM(admRowId),"^",4)
	..s AdmLoc=$p(^CTLOC(locRowId),"^",2)   //接诊科室
	..s AdmLocAddress=""
	..s AdmLocAddress=$p(^CTLOC(locRowId),"^",41) //楼层
	...i AdmLoc["-" s AdmLoc=$p(AdmLoc,"-",2)
	..s AdmDoc=$p($g(^PAADM(admRowId)),"^",9)  
    ..i AdmDoc'="" s AdmDoc=$p($g(^CTPCP(AdmDoc,1)),"^",2)     //就诊医生
	..s papmiRowId=$p(^PAADM(admRowId),"^",1)
	..s mradm=$p(^PAADM(admRowId),"^",61)
	..s AdmDia=##class(web.DHCMRDiagnos).GetMRDiagnosDesc($G(mradm),"/")
	..s PatName=$p(^PAPER(papmiRowId,"ALL"),"^",1)   //姓名
	..s PatNo=$p(^PAPER(papmiRowId,"PAT",1),"^",1)   //登记号
	..s CardNo=##class(web.DHCOutPhNewAddCommit).GetCardFrPmi(PatNo)
	..s sexRowId=$p(^PAPER(papmiRowId,"ALL"),"^",7)
	..s PatSex=$p(^CT("SEX",sexRowId),"^",2)      //性别
	..s tmpAge=$p(^PAPER(papmiRowId,"ALL"),"^",6)  
	..s PatAge=$p($zdt($h,3),"-",1)-$p($zdt(tmpAge,3),"-",1)  //年龄
	..s InvNo=$p(^DHCINVPRT(invRowID),"^",14)             //发票号
	..s PrtDate=$zd($p(^DHCINVPRT(invRowID),"^",5),3)_" "_$zt($p(^DHCINVPRT(invRowID),"^",20))      //打印日期时间
	..s billRowId=$p(^DHCBCI(dhcBCIRowid),"^",2)
	..s pboChildSub=0
	..s loc=""
	..f  s pboChildSub=$o(^DHCPB(billRowId,"O",pboChildSub)) q:pboChildSub=""  d
	...s arcIMRowId=$p(^DHCPB(billRowId,"O",pboChildSub),"^",3)
	...s arcimSubscript=$p(arcIMRowId,"||",1)
	...s arcimVersion=$p(arcIMRowId,"||",2)
	...s myOeoriDr=$p(^DHCPB(billRowId,"O",pboChildSub),"^",4)
	...s myPresNo=$p(^OEORD(+myOeoriDr,"I",$p(myOeoriDr,"||",2),1),"^",14)
	...i myOeoriDr="" b
	...s locRowId=$p(^OEORD(+myOeoriDr,"I",$p(myOeoriDr,"||",2),3),"^",6)   //接受科室Rowid
	...s locDesc=$p(^CTLOC(locRowId),"^",2)   //接受科室
	...i locRowId="" s locRowId=0
	...s myLocAddress=$g(^CTLOC(locRowId,"ADDR",1))  ;接收科室位置
	...s OrdInfo=##class(web.DHCDocService).GetOrdByOrdId(myOeoriDr)
	...s WinInfo=""
	...i myPresNo'="" s WinInfo=##class(web.DHCMZYFXTYW02).GetPrtPrescWin(invRowID,myPresNo)
	...i WindowStr'[WinInfo   s WindowStr=WindowStr_WinInfo 	
	...i myLocAddress="" s myLocAddress="无接收科室"
	...s ^TMP("ADRESS",$j,locRowId,myLocAddress,myOeoriDr)=OrdInfo_"^"_WinInfo
	b ;b1
	s locRowId=0
	f  s locRowId=$o(^TMP("ADRESS",$j,locRowId)) q:locRowId=""  d
	.s myAdress="",listData1=""
	.f  s myAdress=$o(^TMP("ADRESS",$j,locRowId,myAdress)) q:myAdress=""  d
	..s OUTRECCURObj=##class(DHCExternalService.BillInterface.DHCEntity.RecLoc).%New()  	
	..s locDesc=$p(^CTLOC(locRowId),"^",2)   //接受科室
	..s locCode=$p(^CTLOC(locRowId),"^",1)
	..s:locDesc["-" locDesc=$p(locDesc,"-",2)
	..s OUTRECCURObj.RecLocDesc=locDesc
	..s OUTRECCURObj.RecLocCode=locCode
  	..s OUTRECCURObj.RecLocAddress=myAdress
	..s OrdId=""
	..f  s OrdId=$o(^TMP("ADRESS",$j,locRowId,myAdress,OrdId)) q:(OrdId="")  d  //||(intNo>1)  d   20100721
	...s OeOrdObj=##class(DHCExternalService.BillInterface.DHCEntity.OEOrdItem).%New()
	...s mytmpstr=^TMP("ADRESS",$j,locRowId,myAdress,OrdId)
	...s orditmmast=$p($g(^OEORD(+OrdId,"I",$p(OrdId,"||",2),1)),"^",2)     ;//医嘱项	
	...s OrderName=$p(mytmpstr,"^",1)
	...s OrderPrice=$p(mytmpstr,"^",4)
	...s OrderQty=$p(mytmpstr,"^",3)
	...i ($l(OrderName)>15)  s OrderName=$e(OrderName,1,15)	
  	...s OeOrdObj.ArcmiDesc=OrderName
  	...s OeOrdObj.Price=OrderPrice
  	...s OeOrdObj.Qty=OrderQty
  	...d OUTRECCURObj.Items.Insert(OeOrdObj)
  	...d OeOrdObj.%Close()
  	..d OutputObj.RecLocs.Insert(OUTRECCURObj)
  	..d OUTRECCURObj.%Close()
  	k ^TMP("ADRESS",$j)
  	s OutputObj.ResultCode=0
  	s OutputObj.ResultContent="成功"
  	s OutputObj.PatNo=PatNo
  	s OutputObj.CardNo=CardNo
  	s OutputObj.PrtDate=PrtDate
  	s OutputObj.PatName=PatName
  	s OutputObj.PatSex=PatSex
  	s OutputObj.PatAge=PatAge
  	s OutputObj.AdmLoc=AdmLoc
  	s OutputObj.AdmLocAddress=AdmLocAddress
  	s OutputObj.AdmDoc=AdmDoc
  	s OutputObj.AdmDia=AdmDia
  	s OutputObj.PreWindow=WindowStr  	
	Do OutputObj.XMLExportToString(.OutputXML,"Response")
	Do OutputObj.%Close()
	
	
	q OutputXML
	
PrintDirectET
   	s OutputObj=##class(DHCExternalService.BillInterface.DHCEntity.AutoPayDirectResult).%New()
   	s OutputObj.ResultCode=-10
   	s OutputObj.ResultContent="程序处理出错:"_$ZERROR
  	s OutputXML=""
   	d OutputObj.XMLExportToString(.OutputXML,"Response")
   	d OutputObj.%Close()
	q OutputXML
}

/// creat by zhl 2010.01.07 
/// modify by Lid 2011-03-30
/// description   结算病人当天当前科室的就诊纪录
/// output:w ##class(DHCExternalService.BillInterface.Service.DHCOPBillPayExp).AutoOPBillCharge("<Request><CardNo></CardNo><SecrityNo></SecrityNo><Userid>wx002</Userid><StartDate></StartDate><EndDate></EndDate><PatAmt>325</PatAmt><BankTradeInfo><![CDATA[<Response><TradeCode></TradeCode><BankCode></BankCode><BankDate></BankDate><BankTradeNo>1234567899999</BankTradeNo><ResultCode>0000</ResultCode><ResultContent></ResultContent><PayCardNo></PayCardNo><BankAccDate>2016032178123</BankAccDate><RevTranFlag></RevTranFlag><PatientID></PatientID><PayAmt>325</PayAmt><OrgHISTradeNo></OrgHISTradeNo><OrgPaySeqNo></OrgPaySeqNo></Response>]]></BankTradeInfo><AdmInfo>729139</AdmInfo><InsuTypeDR>1</InsuTypeDR><PayModeCode>98</PayModeCode><TransactionId></TransactionId><InvoiceNO></InvoiceNO><YBChargeData></YBChargeData><ReceiptId></ReceiptId><PatientID>00326006</PatientID><ExpStr></ExpStr></Request>")
/// w ##class(DHCExternalService.BillInterface.Service.DHCOPBillPayExp).AutoOPBillCharge(^zhhocharge)
ClassMethod AutoOPBillCharge(Input As %String) As %GlobalCharacterStream
{
	;Set $zt="AutoOPBillChargeET"
	new (Input)
	s ^zhhocharge=Input
    set Err=0,HospDR=""
    set AutoYBFlag="N"   ;默认自助机不调用医保
    set NextStepFlag="N"  ;调用保存接口标志
    ;不牵涉医保都走his后结
    ;只有牵涉医保的需要调用保存
    ;传入医保信息的不需要调保存
    ;自助机是否调用his医保组接口
    set StreamObj=##class(%GlobalCharacterStream).%New()
	set InputObj=##class(DHCExternalService.BillInterface.DHCEntity.AutoPayInputInfo).%New()
    Do InputObj.XMLNodeDeserialize(.InputObj,"Request",Input)
    set CardNO=InputObj.CardNo
    set SecrityNo=InputObj.SecrityNo
    set PatNo=InputObj.PatientID
    set UserCode=InputObj.Userid
    set StDate=InputObj.StartDate 
    set EndDate=InputObj.EndDate
    set PatPaySum=InputObj.PatAmt
    set PatPaySum=PatPaySum/100
    set InsuTypeDR=InputObj.InsuTypeDR
	set PayMode=InputObj.PayModeCode
    set BankTradeInfo=InputObj.BankTradeInfo
    set YBChargeData=InputObj.YBChargeData
    set AdmInfo=InputObj.AdmInfo
    set TransactionId=InputObj.TransactionId
    set BankTradeNo=InputObj.OriHisOrderNo
    set ExpStr=InputObj.ExpStr
    set CardType=$p(ExpStr,"^",1)
    Do InputObj.%Close()  
    set OrderObj=##class(web.DHCEntity.PCA.BankTradeOutput).%New()
	do OrderObj.XMLNodeDeserialize(.OrderObj,"Response",BankTradeInfo)
	set BankTradeNo=OrderObj.BankTradeNo
	set PatNo=$$ALPHAUP^SSUTIL4(PatNo) 
	set Papmi=$o(^PAPERi("PAPMI_PatNo",PatNo,""))
	i UserCode="" s UserCode="wx002"
    Set OutputXML=""
    Set ChargeObj=##class(DHCExternalService.BillInterface.DHCEntity.AutoPayChargeResult).%New()

    Set:UserCode'="" UserCode=$$ALPHAUP^SSUTIL4(UserCode)
   	Set:UserCode'="" Userid=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,""))
   	If (Userid="")||('$d(^SSU("SSUSR",Userid))){
	   Set ChargeObj.ResultCode=-3
	   Set ChargeObj.ResultContent="无此操作员"
	   Set OutputXML=""
	   Do ChargeObj.XMLExportToString(.OutputXML,"Response")
	   Do ChargeObj.%Close()
	}
	Quit:(Userid="")||('$d(^SSU("SSUSR",Userid))) OutputXML
    Set Paymode=##class(DHCExternalService.RegInterface.GetRelate).GetHisPayModeID(PayMode) 
    If (Paymode=""){
	   Set ChargeObj.ResultCode=-9
	   Set ChargeObj.ResultContent="支付方式不存在"
	   Set OutputXML=""
	   Do ChargeObj.XMLExportToString(.OutputXML,"Response")
	   Do ChargeObj.%Close()
	}
	Quit:(Paymode="") OutputXML	
	Set AdmSource=0
	If InsuTypeDR'="" Set AdmSource=$p($g(^PAC("ADMREA",InsuTypeDR)),"^",9)
	;区分生成his交易流水1：dhc_invbanktradepay 2:dhc_invalitradepay
	set PayModHand=##class(DHCExternalService.BillInterface.Service.DHCOPBillPayLogic).GetPayModeHardComm("OP",Paymode)
	set PayModHand=+PayModHand
	i PayModHand="2" s AutoYBFlag="N"  ;第三方手机支付不调医保
	i AutoYBFlag="N" s NextStepFlag="N"  ;不调用医保的都不需要调保存接口
	i AdmSource=0  s AdmSource="Y"
	i AutoYBFlag="Y" s NextStepFlag="Y"  ;调用医保的需要调保存	
	
	if (YBChargeData'="")&&(InsuTypeDR=1) {
		Set ChargeObj.ResultCode=-6
	  	Set ChargeObj.ResultContent="传入参数冲突,请核实."
	   	Set OutputXML=""
	   	Do ChargeObj.XMLExportToString(.OutputXML,"Response")
	   	Do ChargeObj.%Close()	
	}
	Quit:((YBChargeData'="")&&(InsuTypeDR=1)) OutputXML
	Set PayModeCode=$p(^CT("CTPM",Paymode),"^",1)
    Set PayModeDesc=$p(^CT("CTPM",Paymode),"^",2)
	b ;Lid 2011-10-26 判断多个就诊记录是否为同一医院(非同一医院的就诊记录不能一起结算)
	Set TmpHospDR="",ManyHospFlag=0
	For i=1:1:$l(AdmInfo,"^") Do  Quit:ManyHospFlag=1
	.Set myAdm=$p(AdmInfo,"^",i)
	.Quit:+myAdm=0
	.Set myAdmDepCodeDR=$p(^PAADM(myAdm),"^",4)
	.Set HospDR=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(myAdmDepCodeDR)
	.Set:TmpHospDR="" TmpHospDR=HospDR
	.Set:TmpHospDR'=HospDR ManyHospFlag=1	
	if (+ManyHospFlag=1) {
		Set ChargeObj.ResultCode=-6
	  	Set ChargeObj.ResultContent="就诊记录非同一院区,请核实."
	   	Set OutputXML=""
	   	Do ChargeObj.XMLExportToString(.OutputXML,"Response")
	   	Do ChargeObj.%Close()	
	}
	Quit:(+ManyHospFlag=1) OutputXML
	set AccM=""
	/*
	set Data=##class(DHCExternalService.RegInterface.PatientManager).getaccinfofromcardno(CardNO,SecrityNo,$c(2)_CardType_$c(2)_"")
    set Err=$p(Data,"^",1)
	If ((+Err'="-200")){
	Set ChargeObj.ResultCode=Err
	Set ChargeObj.ResultContent="无效卡"
	Do ChargeObj.XMLExportToString(.OutputXML,"Response")
	Do ChargeObj.%Close()
	}
	Quit:((+Err="-200")) OutputXML
	
	If ((PayModeCode="CPP")&(+Err="-201")){
	Set ChargeObj.ResultCode=Err
	Set ChargeObj.ResultContent="账户无效,无法卡支付"
	Do ChargeObj.XMLExportToString(.OutputXML,"Response")
	Do ChargeObj.%Close()
	}
	Quit:((PayModeCode="CPP")&(+Err="-201")) OutputXML

    Set Papmi=$p(Data,"^",8)
    Set AccM=$p(Data,"^",2)
    Set AccMLeft=$p(Data,"^",4)
    Set AccMBalance=$p(Data,"^",5)
    Set AccMDepPrice=$p(Data,"^",6)
    Set AccMAccType=$p(Data,"^",11)
    Set AccMCardTypeDR=$p(Data,"^",13)
	
	
	If (PayModeCode="CPP")&(+AccMLeft<+PatPaySum)&(AdmSource=0){
		Set ChargeObj.ResultCode="-6"
	   Set ChargeObj.ResultContent="账户余额不足"
	   Do ChargeObj.XMLExportToString(.OutputXML,"Response")
	   Do ChargeObj.%Close()	
	}
	Quit:(PayModeCode="CPP")&(+AccMLeft<+PatPaySum)&(AdmSource=0) OutputXML	
	If (PayModeCode="CPP")&(+AccMLeft<0){
		Set ChargeObj.ResultCode="-6"
	   Set ChargeObj.ResultContent="账户已欠款,无法结算"
	   Set OutputXML=""
	   Do ChargeObj.XMLExportToString(.OutputXML,"Response")
	   Do ChargeObj.%Close()	
	}
	Quit:(PayModeCode="CPP")&(+AccMLeft<0) OutputXML 
	
	Set MyCCID=$p($g(^PAPER(Papmi,"PER",4)),"^",17)	;合同单位指针*/	
    Set MyPayinfo=Paymode_"^^^^^^^"
    ;	
	Set GLoc=$p($g(^SSU("SSUSR",Userid)),"^",4)	;SSUSR_DefaultDept
	Set Grup=$p($g(^SSU("SSUSR",Userid)),"^",5)	;SSUSR_Group
	Set OPGS=$o(^DHCOPGSi("GS",0,"GSDR",Grup,""))
	Set RecLoc=""
	If Grup'=""  d
	.Set RecLoc=##class(web.UDHCOPGSConfig).ReadRLByGPRowID(Grup,GLoc)
	Set Adm="",AdmStr="",UnBillOrdStr="",CurIns="",BillOrdStr=""
	Set AdmInfo1=##class(web.DHCOPCashierIF).GetToDayAdmStr(Papmi,"N")
    For i=1:1:$l(AdmInfo1,"^") Do
    .Set Adm=$p(AdmInfo1,"^",i)
    .Quit:+Adm=0
	.Set AdmDate=$p($g(^PAADM(Adm)),"^",6)
	.Quit:(AdmInfo'="")&&(("^"_AdmInfo_"^")'[("^"_Adm_"^"))
	.Set Visit=$p($g(^PAADM(Adm)),"^",20)
	.Quit:Visit'["A"
	.If AdmStr=""  Set AdmStr=Adm
	.Else  Set AdmStr=AdmStr_"^"_Adm
	.Set AdmOrd=$o(^OEORD(0,"Adm",Adm,""))
	.Quit:+AdmOrd=0
	.Set Odritm="0"
	.For  Set Odritm=$o(^OEORD(AdmOrd,"I",Odritm))  Quit:Odritm=""   Do
	..Set OrdRecLoc=$p($g(^OEORD(AdmOrd,"I",Odritm,3)),"^",6)
	..Set OrdIns=$p($g(^OEORD(+AdmOrd,"I",Odritm,11)),"^",18)
	..Set billstatus=$p($g(^OEORD(+AdmOrd,"I",Odritm,3)),"^",5)
	..i billstatus="P"  ;billPPPP
	..q:billstatus="P"
	..set OrdStat=$p($g(^OEORD(+AdmOrd,"I",Odritm,1)),"^",13)
	..set:OrdStat'="" OrdStat=$p($g(^OEC("OSTAT",OrdStat)),"^",1)
	..quit:((OrdStat'="V")&(OrdStat'="E"))
	..Set OEORDI=AdmOrd_"||"_Odritm
	..Set Limit=##class(web.UDHCOEORDOPIF).ReadSkinRtnFlag(OEORDI)   ;;;add by zhl 2010.03.02
	..Set InsAdmSour=""
	..Set:OrdIns'="" InsAdmSour=$p($g(^PAC("ADMREA",OrdIns)),"^",9)
	..Set:(+InsAdmSour=0)&(CurIns="") CurIns=OrdIns
	..If ((RecLoc'="")&&(RecLoc'[OrdRecLoc))||(Limit="Y")  Do
	...If UnBillOrdStr=""  Set UnBillOrdStr=OEORDI
	...Else  Set UnBillOrdStr=UnBillOrdStr_"^"_OEORDI	
	..Else  Do
	...If BillOrdStr=""  Set BillOrdStr=OEORDI
	...Else  Set BillOrdStr=BillOrdStr_"^"_OEORDI	
    Set MyCurPreSum=##class(web.DHCBillConsIF).OPCRound(PatPaySum,"")
    Set MyCurRoundSum=$fn(MyCurPreSum-PatPaySum,"",2)	
    Set ExpStr=Grup_"^"_GLoc_"^"_AccM_"^Y^F^^0^"_MyCurRoundSum
    b ;begincharge
  	If InsuTypeDR'=""   d
  	.Set CurIns=InsuTypeDR
  	.b ;开始结算
    .Set Rtn=##class(web.DHCOPINVCons).OPBillCharge(AdmStr, Userid, UnBillOrdStr, CurIns, PatPaySum, MyPayinfo, Grup, "0", "", "0",ExpStr) ;gloc改为Grup  安全组
	Else  Do
	.Set ExpStr="N^"_Paymode
	.b ;开始结算
	.Set Rtn=##class(web.udhcOPBillIF).OPOEORDBILLINL(Papmi, AdmStr, BillOrdStr,PatPaySum, Userid, Grup,GLoc,AccM,ExpStr) 
	b ;结算结束
    Set ErrCode=+Rtn_":门诊结算失败"
    If +Rtn=102   Set ErrCode="102:结算金额不符"
    If +Rtn=101   Set ErrCode="101:没有门诊结算数据"
    If +Rtn=112   Set ErrCode="112:判断舍入错误"
    If +Rtn=120   Set ErrCode="120:预结算失败"
    If +Rtn=0 {
		For k=1:1:$l(AdmStr,"^") Do
		.Set myAdm=$p(AdmStr,"^",k)
		.Quit:+myAdm=0
		.;Set ret=##class(web.DHCDOCHL7PROT).HL7Trant(myAdm)
		If InsuTypeDR'=""   Set InvRowidStr=$p(Rtn,$c(2),1)
		e    Set InvRowidStr=$p(Rtn,$c(2),2)
		;药房接口
		;Do ##class(web.udhcOPPHARWIN).UpdatePHWINV(InvRowidStr)  
	}
    If (+Rtn'=0){
	    Set ChargeObj.ResultCode=+Rtn
	   	Set ChargeObj.ResultContent=ErrCode
	   	Do ChargeObj.XMLExportToString(.OutputXML,"Response")
	   	Do ChargeObj.%Close()
	}
	Quit:+Rtn'=0 OutputXML
	Set Err=+Rtn
	b ;begin
	i NextStepFlag="N"	s outstr=$$ChargeAfter() ;his后结算	
	i NextStepFlag="Y"	s outstr=$$ChargeBefore() ;his 预结算
	s OutputXML=outstr
	q OutputXML
ChargeBefore()
	s myOutputXML=""
	If PayModeCode="CPP" {
		For i=2:1:$l(InvRowidStr,"^") Do
	    .Set PrtInvRowid=$p(InvRowidStr,"^",i)
	    .Quit:+PrtInvRowid=0
	    .;Lid 2012-04-20 确认完成	
	   	.Set MyInsTypeDR=$p(^DHCINVPRT(PrtInvRowid),"^",9)
	   	.Set CTLocDR=GLoc
		.Set GroupDR=Grup
		.Set ExtUserID=$p(^DHCINVPRT(PrtInvRowid),"^",21)
		.Set MyAdmSource=$p($g(^PAC("ADMREA",MyInsTypeDR)),"^",9)
	   	.Set MyExpStr=GroupDR_"^"_CTLocDR_"^"_AccM_"^Y^F^^0^^"
	   	.Set ConYBFlag="Y"
		.If +MyAdmSource=0 Do
		..Set Rtn=##class(web.DHCBillConsIF).CompleteCharge("7",ExtUserID,MyInsTypeDR,PrtInvRowid,"0","",MyExpStr)
		..Set ConYBFlag="N"
	  	.;获取发药窗口
	    .Set WinInfo=""
	    .;Set WinInfo=##class(web.UDHCOPINVPrtData12).GetPrescWinByPrtRowID(PrtInvRowid)
	    .Set LeftAmt=AccMBalance_"!"_AccMBalance_"^"
	    .Set ExpStrYB="N^"_GroupDR_"^^^^^^"_LeftAmt
	    .Set invAmt=$P(^DHCINVPRT(PrtInvRowid),"^",16)
	  	.Set InvoiceObj=##class(web.DHCEntity.PCA.Invoice).%New()
	    .Set InvoiceObj.TransactionId=""
	 	.Set InvoiceObj.InvoiceNO=PrtInvRowid
	 	.Set InvoiceObj.InvoiceAmt=$J(invAmt,3,2)
	 	.Set InvoiceObj.PrescWindow=WinInfo
	 	.Set InvoiceObj.ConYBFlag=ConYBFlag
	 	.Set InvoiceObj.ConYBData="0|"_ExtUserID_"|"_PrtInvRowid_"|"_MyAdmSource_"|"_MyInsTypeDR_"|"_ExpStrYB_"|"
	 	.;Set InvoiceObj.InvocieExpStr=""
	 	.Do ChargeObj.Invoices.Insert(InvoiceObj)
	 	.Do InvoiceObj.%Close()
	    ;
	    Set ChargeObj.ResultCode=0
		Set ChargeObj.ErrorMsg="结算成功"
	    Do ChargeObj.XMLExportToString(.myOutputXML,"Response")
		Do ChargeObj.%Close()
	}Else{
		For i=2:1:$l(InvRowidStr,"^")  Do
	    .Set PrtInvRowid=$p(InvRowidStr,"^",i)
	    .Quit:+PrtInvRowid=0
	    .;Lid 2012-04-20 确认完成	
	   	.Set MyInsTypeDR=$p(^DHCINVPRT(PrtInvRowid),"^",9)
	   	.Set CTLocDR=GLoc
		.Set GroupDR=Grup
		.Set ExtUserID=$p(^DHCINVPRT(PrtInvRowid),"^",21)
		.Set MyAdmSource=$p($g(^PAC("ADMREA",MyInsTypeDR)),"^",9)
	   	.Set MyExpStr=GroupDR_"^"_CTLocDR_"^"_""_"^Y^F^^0^^"
	   	.Set ConYBFlag="Y"
		.If +MyAdmSource=0 Do
		..Set ConYBFlag="N"
	  	.;获取发药窗口
	    .Set WinInfo=""
	    .;Set WinInfo=##class(web.UDHCOPINVPrtData12).GetPrescWinByPrtRowID(PrtInvRowid)
	    .Set LeftAmt=AccMBalance_"!"_AccMBalance_"^"
	    .Set ExpStrYB="N^"_GroupDR_"^^^^^^"_LeftAmt
	    .Set invAmt=$P(^DHCINVPRT(PrtInvRowid),"^",16)
	  	.Set InvoiceObj=##class(web.DHCEntity.PCA.Invoice).%New()
	    .Set InvoiceObj.TransactionId=""
	 	.Set InvoiceObj.InvoiceNO=PrtInvRowid
	 	.Set InvoiceObj.InvoiceAmt=$J(invAmt,3,2)
	 	.Set InvoiceObj.PrescWindow=WinInfo
	 	.Set InvoiceObj.ConYBFlag=ConYBFlag
	 	.Set InvoiceObj.ConYBData="0|"_ExtUserID_"|"_PrtInvRowid_"|"_MyAdmSource_"|"_MyInsTypeDR_"|"_ExpStrYB_"|"
	 	.;Set InvoiceObj.InvocieExpStr=""
	 	.Do ChargeObj.Invoices.Insert(InvoiceObj)
	 	.Do InvoiceObj.%Close()
	    ;
	    Set ChargeObj.ResultCode=0
		Set ChargeObj.ErrorMsg="预结算成功"
	    Do ChargeObj.XMLExportToString(.myOutputXML,"Response")
	    b ;33333
		Do ChargeObj.%Close()
	}
   
    q myOutputXML
	;
ChargeAfter()	
	s myOutputXML=""
	If PayModeCode="CPP" {
		For i=2:1:$l(InvRowidStr,"^") Do  Quit:+Err'=0
	    .Set PrtInvRowid=$p(InvRowidStr,"^",i)
	    .Quit:+PrtInvRowid=0
	    .;Lid 2012-04-20 确认完成	
	   	.Set MyInsTypeDR=$p(^DHCINVPRT(PrtInvRowid),"^",9)
	   	.Set CTLocDR=GLoc
		.Set GroupDR=Grup
		.Set ExtUserID=$p(^DHCINVPRT(PrtInvRowid),"^",21)
	   	.Set myExpStr=GroupDR_"^"_CTLocDR_"^"_""_"^Y^F^^0^^"
	   	.Set SaveYBRtn=0
	   	.If YBChargeData'=""  d
	   	..s Err=0  ;保存医保，预留调用医保接口   	
		.If Err=0 Set Rtn=##class(web.DHCBillConsIF).CompleteCharge("7",ExtUserID,myInsTypeDR,PrtInvRowid,"0","",myExpStr)
	  	.Set Err=+Rtn
	  	.;获取发药窗口
	    .Set WinInfo=""
	    .Set WinInfo=##class(web.UDHCOPINVPrtData12).GetPrescWinByPrtRowID(PrtInvRowid)
	    .Set invAmt=$P(^DHCINVPRT(PrtInvRowid),"^",16)
	  	.Set InvoiceObj=##class(web.DHCEntity.PCA.Invoice).%New()
	    .Set InvoiceObj.TransactionId=""
	 	.Set InvoiceObj.InvoiceNO=PrtInvRowid
	 	.Set InvoiceObj.InvoiceAmt=$J(invAmt,3,2)
	 	.Set InvoiceObj.PrescWindow=WinInfo
	 	.;Set InvoiceObj.InvocieExpStr=""
	 	.Do ChargeObj.Invoices.Insert(InvoiceObj)
	 	.Do InvoiceObj.%Close()
	    ;
	    
	    If +Err'=0 Do 
	    .Set myPrtStr=##class(web.DHCBillBankLogic).GetDelPrt(InvRowidStr,"")
	    .Set rtn=##class(web.DHCBillConsIF).DelINVPRTForYB(myPrtStr,Grup)	
	    .Set ChargeObj.ResultCode=+err
		.Set ChargeObj.ResultContent="结算失败" 		   	   
	    If +Err=0 Do
	    .Set ChargeObj.ResultCode=+err
		.Set ChargeObj.ResultContent="结算成功"
	    Do ChargeObj.XMLExportToString(.myOutputXML,"Response")
		Do ChargeObj.%Close()
		
	}ElseIf(PayModeCode="CARDCPP")!(PayModeCode="WZF"){
		set Err=+Rtn	
		set IBPRowid=""
		set WinInfo=""	
		set ChargeObj.ResultCode=0
		set HisTradeExpStr=Userid_"!"_$e(InvRowidStr,2,$l(InvRowidStr))_"!"_AdmStr_"!"_Papmi
    	set TradePayIDInfo=##class(DHCExternalService.BillInterface.Service.DHCOPBillPayLogic).SetTradeID(PayModHand,CardNO,"C",HospDR,HisTradeExpStr) ;
    	s ^alitrade($zd(+$h,3),$zt($p($h,",",2),1),"In")=PayModHand_"##"_HisTradeExpStr_"##"_TradePayIDInfo
    	set Err=$p(TradePayIDInfo,"^",1)    	
    	set IBPRowid=$p(TradePayIDInfo,"^",2)
    	set TransactionId=$p(TradePayIDInfo,"^",3)
	   	set myExpStr=Grup_"^"_GLoc_"^"_""_"^Y^F^^0^^"
    	i +Err=0 set Err=##class(web.DHCBillConsIF).CompleteCharge("7",Userid,InsuTypeDR,InvRowidStr,"0","",myExpStr)
    	s ^alitrade($zd(+$h,3),$zt($p($h,",",2),1),"Com")=Err
    	b ;complete
    	set myExpStr01=GLoc_"^"_Grup_"^"_"2"_"^"_"15"_"^"_Userid_"^"_Userid_"^^^"
	    i +Err=0  d
	    .For i=2:1:$l(InvRowidStr,"^") Do  
	    ..set PrtInvRowid=$p(InvRowidStr,"^",i)
	    ..quit:+PrtInvRowid=0
	    ..set ^alitrade($zd(+$h,3),$zt($p($h,",",2),1),"upda")=PayModHand_"@"_PrtInvRowid_"@"_TransactionId_"@"_BankTradeInfo_"@"_myExpStr01
	    ..set rtn=##class(DHCExternalService.BillInterface.Service.DHCOPBillPayLogic).BMCUpdateTradeData(PayModHand,"OP",PrtInvRowid,"","C",TransactionId,BankTradeInfo, myExpStr01) 	
		..set ^alitrade($zd(+$h,3),$zt($p($h,",",2),1),"updartn")=rtn
		..set Err=+Err++rtn
		b ;update;
		If +Err'=0 Do	    
	    .Set myPrtStr=##class(DHCExternalService.BillInterface.Service.DHCOPBillPayLogic).GetDelPrt(InvRowidStr,"")
	    .b ;bk del
	    .Set delrtn=##class(web.DHCBillConsIF).DelINVPRTForYB(myPrtStr,Grup)
	    .set ^alitrade($zd(+$h,3),$zt($p($h,",",2),1),"del")=delrtn
	    .If IBPRowid'="" d
	    ..i PayModHand="1" s RollRtn=##class(DHCExternalService.BillInterface.Service.DHCOPBillPayLogic).DeleteIBP(IBPRowid,"")
	    ..i PayModHand="2" s RollRtn=##class(DHCExternalService.BillInterface.Service.DHCOPBillPayLogic).DeleteIAP(IBPRowid,"")
	    .i delrtn'=0 d
	    ..Set ChargeObj.ResultCode=0			   
	    ..Set ChargeObj.ResultContent="His回滚失败,请到窗口处理"
	    .else  d
	    ..Set ChargeObj.ResultCode=-5
	    ..Set ChargeObj.ResultContent="His结算失败,回滚成功"
	    else  d
	    .set ChargeObj.ResultContent="结算成功"
	    .For i=2:1:$l(InvRowidStr,"^") Do  
	    ..set PrtInvRowid=$p(InvRowidStr,"^",i)
	    ..quit:+PrtInvRowid=0
	    ..set invAmt=$P(^DHCINVPRT(PrtInvRowid),"^",16)
	    ..Set WinInfo=##class(web.UDHCOPINVPrtData12).GetPrescWinByPrtRowID(PrtInvRowid)
	  	..set InvoiceObj=##class(DHCExternalService.BillInterface.DHCEntity.Invoice).%New()
	    ..set InvoiceObj.TransactionId=TransactionId
	 	..set InvoiceObj.InvoiceNO=PrtInvRowid
	 	..set InvoiceObj.InvoiceAmt=$J(invAmt,3,2)
	 	..set InvoiceObj.PrescWindow=$g(WinInfo)
	 	..Do ChargeObj.Invoices.Insert(InvoiceObj)
	 	..Do InvoiceObj.%Close() 
	   	Do ChargeObj.XMLExportToString(.myOutputXML,"Response")
	   	s ^zhhochargeout=OutputXML
	   	b ;zhho0000
		Do ChargeObj.%Close()		
	}	
	Else{
		Set IBPRowid=""
	    For i=2:1:$l(InvRowidStr,"^") Do  Quit:+err'=0
	    .b ;binvrowidstr
	    .Set PrtInvRowid=$p(InvRowidStr,"^",i)
	    .Quit:+PrtInvRowid=0	   
	   	.If BankTradeInfo'=""  d	
	    ..b ;生成HIS交易流水号
    	..Set TradePayIDInfo=##class(web.DHCBillBankLogic).SetTradeID(HandCom,CardNO,"C",HospDR,ExpStr) ;
    	..Set Err=$p(TradePayIDInfo,"^",1)
    	..Set IBPRowid=$p(TradePayIDInfo,"^",2)
    	..Set TransactionId=$p(TradePayIDInfo,"^",3)    	
		.If +Err=0 Do
		..;银行交易成功
	    ..s myExpStr01=gloc_"^"_Grup_"^"_"2"_"^"_"15"_"^"_Userid_"^"_Userid_"^^^"
	    ..s Err=##class(web.DHCBillBMCLogic).POSDataSave("OP",PrtInvRowid,"","C",TransactionId,BankTradeInfo, myExpStr01)
		.If +Err=0 Do
		..If YBChargeData'=""  d
	   	...s Err=0  ;保存医保，预留调用医保接口
	  	.If +Err'=0 Do
	    ..If IBPRowid'="" 
	    ...s RollRtn=##class(web.DHCBillBankLogic).DeleteIBP(IBPRowid,"")	   
	  	.If +Err=0 d
	  	..Set InvoiceObj=##class(web.DHCEntity.PCA.Invoice).%New()
	    ..Set InvoiceObj.TransactionId=TransactionId
	 	..Set InvoiceObj.InvoiceNO=PrtInvRowid
	 	..Set InvoiceObj.InvoiceAmt=$J(invAmt,3,2)
	 	..Set InvoiceObj.PrescWindow=$g(WinInfo)
	 	..;Set InvoiceObj.InvocieExpStr=""
	 	..Do ChargeObj.Invoices.Insert(InvoiceObj)
	 	..Do InvoiceObj.%Close()
	    ;生成交易流水号,银行结算失败后HIS回滚
	    If +Err'=0 Do	   
	    .Set ChargeObj.ResultCode=-7
		.Set ChargeObj.ResultContent="结算失败"
	    .Set myPrtStr=##class(web.DHCBillBankLogic).GetDelPrt(InvRowidStr,"")
	    .Set rtn=##class(web.DHCBillConsIF).DelINVPRTForYB(myPrtStr,Grup)
	    If +Err=0 Do
	    .Set ChargeObj.ResultCode=+err
		.Set ChargeObj.ErrorMsg="结算成功"
	    Do ChargeObj.XMLExportToString(.myOutputXML,"Response")
		Do ChargeObj.%Close()
	}
    b ;6789
    q myOutputXML
    
AutoOPBillChargeET
	If $g(InvRowidStr)'="" Do
	.Set myPrtStr=##class(web.DHCBillBankLogic).GetDelPrt(InvRowidStr,"")
	.Set rtn1=##class(web.DHCBillConsIF).DelINVPRTForYB(myPrtStr,Grup)
   	Set ChargeObj=##class(web.DHCEntity.PCA.AutoPayChargeResult).%New()
   	Set ChargeObj.ResultCode=-10
   	Set ChargeObj.ErrorMsg="程序处理出错:"_$ZERROR
  	Set OutputXML=""
   	Do ChargeObj.XMLExportToString(.OutputXML,"Response")
   	Do ChargeObj.%Close()
	Quit OutputXML
}

/// creat by zhho
/// description   结算病人当天当前科室的就诊纪录
/// output:w ##class(DHCExternalService.BillInterface.Service.DHCOPBillPayExp).AutoOPBillCharge("<Request><CardNo></CardNo><SecrityNo></SecrityNo><Userid>wx002</Userid><StartDate></StartDate><EndDate></EndDate><PatAmt>118.61</PatAmt><BankTradeInfo><![CDATA[<Response><TradeCode></TradeCode><BankCode></BankCode><BankDate></BankDate><BankTradeNo>1234567899999</BankTradeNo><ResultCode></ResultCode><ResultContent> </ResultContent><PayCardNo></PayCardNo><BankAccDate>2016032178123</BankAccDate><RevTranFlag></RevTranFlag><PatientID></PatientID><PayAmt>118.61</PayAmt><OrgHISTradeNo></OrgHISTradeNo><OrgPaySeqNo></OrgPaySeqNo></Response>]]></BankTradeInfo><AdmInfo>729124</AdmInfo><InsuTypeDR>2</InsuTypeDR><PayModeCode>CARDCPP</PayModeCode><TransactionId></TransactionId><InvoiceNO></InvoiceNO><YBChargeData></YBChargeData><ReceiptId></ReceiptId><PatientID>00326006</PatientID><ExpStr></ExpStr></Request>")
ClassMethod AutoOPBillChargeNew(Input As %String) As %GlobalCharacterStream
{
	set $zt="AutoOPBillChargeNewET"
	New (Input)
    set Err=0,HospDR=""
    set StreamObj=##class(%GlobalCharacterStream).%New()
	set InputObj=##class(DHCExternalService.BillInterface.DHCEntity.AutoPayInputInfo).%New()
    Do InputObj.XMLNodeDeserialize(.InputObj,"Request",Input)
    set CardNO=InputObj.CardNo
    set SecrityNo=InputObj.SecrityNo
    set PatNo=InputObj.PatientID
    set UserCode=InputObj.Userid
    set StDate=InputObj.StartDate 
    set EndDate=InputObj.EndDate
    set PatPaySum=InputObj.PatAmt
    set InsuTypeDR=InputObj.InsuTypeDR
	set PayMode=InputObj.PayModeCode
    set BankTradeInfo=InputObj.BankTradeInfo
    set YBChargeData=InputObj.YBChargeData
    set AdmInfo=InputObj.AdmInfo
    ;set TransactionId=InputObj.TransactionId
    set ExpStr=InputObj.ExpStr
    set CardType=$p(ExpStr,"^",1)
    set OrderObj=##class(web.DHCEntity.PCA.BankTradeOutput).%New()
	do OrderObj.XMLNodeDeserialize(.OrderObj,"Response",BankTradeInfo)
	set BankTradeNo=OutputObj.OrderObj	
    set PatNo=$$ALPHAUP^SSUTIL4(PatNo) 
	set Papmi=$o(^PAPERi("PAPMI_PatNo",PatNo,""))
    Do InputObj.%Close()
    set ChargeObj=##class(DHCExternalService.BillInterface.DHCEntity.AutoPayChargeResult).%New()
    set OutputXML=""
    set:UserCode'="" UserCode=$$ALPHAUP^SSUTIL4(UserCode)
   	set:UserCode'="" Userid=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,""))
   	if (Userid="")||('$d(^SSU("SSUSR",Userid))){
	   set ChargeObj.ResultCode=-3
	   set ChargeObj.ResultContent="无此操作员"
	   set OutputXML=""
	   Do ChargeObj.XMLExportToString(.OutputXML,"Response")
	   Do ChargeObj.%Close()
	}
	quit:(Userid="")||('$d(^SSU("SSUSR",Userid))) OutputXML
    set Paymode=##class(DHCExternalService.RegInterface.GetRelate).GetHisPayModeID(PayMode) 
    if (Paymode=""){
	   set ChargeObj.ResultCode=-9
	   set ChargeObj.ResultContent="支付方式不存在"
	   set OutputXML=""
	   Do ChargeObj.XMLExportToString(.OutputXML,"Response")
	   Do ChargeObj.%Close()
	}
	quit:(Paymode="") OutputXML

    set PayModeCode=$p(^CT("CTPM",Paymode),"^",1)
    set PayModeDesc=$p(^CT("CTPM",Paymode),"^",2)
	b ;Lid 2011-10-26 判断多个就诊记录是否为同一医院(非同一医院的就诊记录不能一起结算)
	set TmpHospDR="",ManyHospFlag=0
	set HospDR=""
	For i=1:1:$l(AdmInfo,"^") Do  quit:ManyHospFlag=1
	.set myAdm=$p(AdmInfo,"^",i)
	.quit:+myAdm=0
	.set myAdmDepCodeDR=$p(^PAADM(myAdm),"^",4)
	.set HospDR=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(myAdmDepCodeDR)
	.set:TmpHospDR="" TmpHospDR=HospDR
	.set:TmpHospDR'=HospDR ManyHospFlag=1
	if (+ManyHospFlag=1) {
		set ChargeObj.ResultCode=-6
	  	set ChargeObj.ResultContent="就诊记录非同一院区,请核实."	   	
	   	Do ChargeObj.XMLExportToString(.OutputXML,"Response")
	   	Do ChargeObj.%Close()	
	}
	quit:(+ManyHospFlag=1) OutputXML	
	
	set AdmSource=0
	if InsuTypeDR'="" set AdmSource=$p($g(^PAC("ADMREA",InsuTypeDR)),"^",9)	
    set MyPayinfo=Paymode_"^^^^^^^"
	set GLoc=$p($g(^SSU("SSUSR",Userid)),"^",4)	;SSUSR_DefaultDept
	set Grup=$p($g(^SSU("SSUSR",Userid)),"^",5)	;SSUSR_Group
	set OPGS=$o(^DHCOPGSi("GS",0,"GSDR",Grup,""))
	set RecLoc=""
	if Grup'=""  d
	.set RecLoc=##class(web.UDHCOPGSConfig).ReadRLByGPRowID(Grup,GLoc)
	set Adm="",AdmStr="",UnBillOrdStr="",CurIns="",BillOrdStr=""
	set AdmInfo1=##class(web.DHCOPCashierIF).GetToDayAdmStr(Papmi,"N")
    For i=1:1:$l(AdmInfo1,"^") Do
    .set Adm=$p(AdmInfo1,"^",i)
    .quit:+Adm=0
	.set AdmDate=$p($g(^PAADM(Adm)),"^",6)
	.quit:(AdmInfo'="")&&(("^"_AdmInfo_"^")'[("^"_Adm_"^"))
	.set Visit=$p($g(^PAADM(Adm)),"^",20)
	.quit:Visit'["A"
	.if AdmStr=""  set AdmStr=Adm
	.Else  set AdmStr=AdmStr_"^"_Adm
	.set AdmOrd=$o(^OEORD(0,"Adm",Adm,""))
	.quit:+AdmOrd=0
	.set Odritm="0"
	.For  set Odritm=$o(^OEORD(AdmOrd,"I",Odritm))  quit:Odritm=""   Do
	..set OrdRecLoc=$p($g(^OEORD(AdmOrd,"I",Odritm,3)),"^",6)
	..set OrdIns=$p($g(^OEORD(+AdmOrd,"I",Odritm,11)),"^",18)
	..set OEORDI=AdmOrd_"||"_Odritm
	..set Limit=##class(web.UDHCOEORDOPIF).ReadSkinRtnFlag(OEORDI)   ;;;add by zhl 2010.03.02
	..set InsAdmSour=""
	..set:OrdIns'="" InsAdmSour=$p($g(^PAC("ADMREA",OrdIns)),"^",9)
	..if ((RecLoc'="")&&(RecLoc'[OrdRecLoc))||(OrdIns'=InsuTypeDR)||(Limit="Y")  Do
	...if UnBillOrdStr=""  set UnBillOrdStr=OEORDI
	...Else  set UnBillOrdStr=UnBillOrdStr_"^"_OEORDI	
	..Else  Do
	...if BillOrdStr=""  set BillOrdStr=OEORDI
	...Else  set BillOrdStr=BillOrdStr_"^"_OEORDI	
    set MyCurPreSum=##class(web.DHCBillConsIF).OPCRound(PatPaySum,"")
    set MyCurRoundSum=$fn(MyCurPreSum-PatPaySum,"",2)	
    set ExpStr=Grup_"^"_GLoc_"^^Y^F^^0^"_MyCurRoundSum
  	b ;开始结算
    set rtn=##class(web.DHCOPINVCons).OPBillCharge(AdmStr, Userid, UnBillOrdStr, InsuTypeDR, PatPaySum, MyPayinfo, Grup, "0", "", "0",ExpStr) ;gloc改为Grup  安全组
    b ;endcharge
    set ErrCode=+rtn_":门诊结算失败"
    if +rtn=102   set ErrCode="102:结算金额不符"
    if +rtn=101   set ErrCode="101:没有门诊结算数据"
    if +rtn=112   set ErrCode="112:判断舍入错误"
    if +rtn=120   set ErrCode="120:预结算失败"
    if +rtn=0 {
		For k=1:1:$l(AdmStr,"^") Do
		.set myAdm=$p(AdmStr,"^",k)
		.quit:+myAdm=0
		.;set ret=##class(web.DHCDOCHL7PROT).HL7Trant(myAdm)
		set InvRowidStr=$p(rtn,$c(2),1)
		set ^ChargeCheck(+$h,BankTradeNo)=InvRowidStr
		;药房接口
		;Do ##class(web.udhcOPPHARWIN).UpdatePHWINV(InvRowidStr)  
	}
    if (+rtn'=0){
	    set ChargeObj.ResultCode=+rtn
	   	set ChargeObj.ResultContent=ErrCode
	   	set ^ChargeCheck(+$h,BankTradeNo)=ErrCode
	   	Do ChargeObj.XMLExportToString(.OutputXML,"Response")
	   	Do ChargeObj.%Close()
	   	
	}
	quit:+rtn'=0 OutputXML
		set Err=+rtn	
		set IBPRowid=""
		set WinInfo=""	
		set ChargeObj.ResultCode=0
		set HisTradeExpStr=ExtUserID_$e(InvRowidStr,2,$l(InvRowidStr))
    	set TradePayIDInfo=##class(DHCExternalService.BillInterface.Service.DHCOPBillPayLogic).SetTradeID(HandCom,CardNO,"C",HospDR,HisTradeExpStr) ;
    	set Err=$p(TradePayIDInfo,"^",1)
    	if (Err'=0){
	    	set ChargeObj.ResultCode=0
			set ChargeObj.ResultContent="结算成功,his生成交易流水失败"
	    	Do ChargeObj.XMLExportToString(.OutputXML,"Response")
			Do ChargeObj.%Close()
	    }
	    q:Err'=0 OutputXML
    	set IBPRowid=$p(TradePayIDInfo,"^",2)
    	set TransactionId=$p(TradePayIDInfo,"^",3)
 		set ExtUserID=$p(^DHCINVPRT(PrtInvRowid),"^",21)
	   	set myExpStr=Grup_"^"_GLoc_"^"_""_"^Y^F^^0^^"
    	set ComRtn=##class(web.DHCBillConsIF).CompleteCharge("7",Userid,InsuTypeDR,InvRowidStr,"0","",myExpStr)
    	if (+ComRtn'=0){
			set ChargeObj.ResultContent="结算成功,his确认完成失败,请到窗口处理"
	    	Do ChargeObj.XMLExportToString(.OutputXML,"Response")
			Do ChargeObj.%Close()
	    }
	    q:+ComRtn'=0 OutputXML
    	set myExpStr01=GLoc_"^"_Grup_"^"_"2"_"^"_"15"_"^"_Userid_"^"_Userid_"^^^"
	    set UpRtn=##class(DHCExternalService.BillInterface.Service.DHCOPBillPayLogic).BMCUpdateTradeData("OP",InvRowidStr,"","C",TransactionId,BankTradeInfo, myExpStr01) 	
	    if (+UpRtn'=0){
			set ChargeObj.ResultContent="结算成功,保存交易信息失败"
	    	Do ChargeObj.XMLExportToString(.OutputXML,"Response")
			Do ChargeObj.%Close()
	    }
	    q:+ComRtn'=0 OutputXML
	    set ChargeObj.ResultContent="结算成功"
	    For i=2:1:$l(InvRowidStr,"^") Do  
	    .set PrtInvRowid=$p(InvRowidStr,"^",i)
	    .quit:+PrtInvRowid=0
	    .set invAmt=$P(^DHCINVPRT(PrtInvRowid),"^",16)
	  	.set InvoiceObj=##class(DHCExternalService.BillInterface.DHCEntity.Invoice).%New()
	    .set InvoiceObj.TransactionId=TransactionId
	 	.set InvoiceObj.InvoiceNO=PrtInvRowid
	 	.set InvoiceObj.InvoiceAmt=$J(invAmt,3,2)
	 	.set InvoiceObj.PrescWindow=$g(WinInfo)
	 	.Do ChargeObj.Invoices.Insert(InvoiceObj)
	 	.Do InvoiceObj.%Close() 
	   	Do ChargeObj.XMLExportToString(.OutputXML,"Response")
		Do ChargeObj.%Close()
	b ;;End
    q OutputXML
AutoOPBillChargeNewET
	if $g(InvRowidStr)'="" Do
	.set myPrtStr=##class(web.DHCBillBankLogic).GetDelPrt(InvRowidStr,"")
	.set rtn1=##class(web.DHCBillConsif).DelINVPRTForYB(myPrtStr,Grup)
   	;
   	set ChargeObj=##class(DHCExternalService.BillInterface.DHCEntity.AutoPayChargeResult).%New()
   	set ChargeObj.ResultCode=-10
   	set ChargeObj.ResultContent="程序处理出错:"_$ZERROR
  	set OutputXML=""
   	Do ChargeObj.XMLExportToString(.OutputXML,"Response")
   	Do ChargeObj.%Close()
	quit OutputXML
}

/// 	Creator:Lid
/// 	CreatDate:2013-02-22
/// 	Desc:生成HIS交易流水号
/// Input:
/// Return:
/// Debug:w ##class(web.DHCOPBillAutoPayExp).setHISTradeNO("")
ClassMethod setHISTradeNO(Input As %String) As %GlobalCharacterStream
{
	New (Input)
	set err=0
    ;set streamObj=##class(%GlobalCharacterStream).%New()
    set inputObj=##class(DHCExternalService.BillInterface.DHCEntity.AutoPayInputInfo).%New()
    Do inputObj.XMLNodeDeserialize(.inputObj,"Request",Input)
    set CardNO=inputObj.CardNo
    set SecrityNo=inputObj.SecrityNo
    set UserCode=inputObj.Userid
    set ExpStr=inputObj.ExpStr
    ;
    ;
    set:UserCode'="" UserCode=$$ALPHAUP^SSUTIL4(UserCode)
   	set:UserCode'="" Userid=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,""))
    set gloc=$p($g(^SSU("SSUSR",Userid)),"^",4)
	set Grup=$p($g(^SSU("SSUSR",Userid)),"^",5)  ;安全组
    set HospDR=""
	set ExpStr=""
	b ;生成HIS交易流水号
   	set TradePayIDInfo=##class(DHCExternalService.BillInterface.Service.DHCOPBillPayLogic).SetTradeID(HandCom,CardNO,"C",HospDR,ExpStr) ;
   	set err=$p(TradePayIDInfo,"^",1)
   	set TradePayID=$p(TradePayIDInfo,"^",3)
   	;
   	if +err=0 Do
   	.set HisTradeNOObj=##class(DHCExternalService.BillInterface.DHCEntity.HISTradeNo).%New()
	.set HisTradeNOObj.TransactionId=TradePayID
	.set HisTradeNOObj.ResultCode=err
	.set HisTradeNOObj.ResultContent="获取交易流水号成功"
	Else  Do
	.set HisTradeNOObj=##class(DHCExternalService.BillInterface.DHCEntity.HISTradeNo).%New()
	.set HisTradeNOObj.ResultCode=err
	.set HisTradeNOObj.ResultContent="获取交易流水号失败"
	set OutputXML=""
	Do HisTradeNOObj.XMLExportToString(.OutputXML,"Response")
	Do HisTradeNOObj.%Close()
	Do inputObj.%Close()
	quit OutputXML
}

/// zhho
/// 2015-03-06
/// 多条提交
ClassMethod InserBankTradeInfo(Input As %String) As %GlobalCharacterStream
{
	set $ZT="InserBankTradeInfoET"
	New (Input)
	set (SussNum,FailNum,CommitFailNum)=0
	set ResultContent=""
    set Err=0
    set streamObj=##class(%GlobalCharacterStream).%New()
	set InputObj=##class(DHCExternalService.BillInterface.DHCEntity.AutoPayInputInfo).%New()
    Do InputObj.XMLNodeDeserialize(.InputObj,"Request",Input)
    set CardNO=InputObj.CardNo
    set SecrityNo=InputObj.SecrityNo
    set UserCode=InputObj.Userid
    set StDate=InputObj.StartDate 
    set EndDate=InputObj.EndDate 
    ;set OneMathMangFlag=inputObj.OneMathMangFlag
    set OutputXML=""
    set UpdateBankResultObj=##class(DHCExternalService.BillInterface.DHCEntity.AutoPayUpdateBankResult).%New()
	set:UserCode'="" UserCode=$$ALPHAUP^SSUTIL4(UserCode)
   	set:UserCode'="" Userid=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,""))
   	if ((Userid="")||('$d(^SSU("SSUSR",Userid)))){
		set UpdateBankResultObj.ResultCode=-3
   		set UpdateBankResultObj.ResultContent="无此操作员."  
   		Do UpdateBankResultObj.XMLExportToString(.OutputXML,"Response")
   		Do UpdateBankResultObj.%Close()
	}
   	quit:(Userid="")||('$d(^SSU("SSUSR",Userid))) 
   	set GLoc=$p($g(^SSU("SSUSR",Userid)),"^",4)
	set Grup=$p($g(^SSU("SSUSR",Userid)),"^",5)  ;安全组
	set InvoiceNum=InputObj.Invoices.Count()
	For i=1:1:InvoiceNum d
	.set Invoice=##class(DHCExternalService.BillInterface.DHCEntity.InvoiceBankInfo).%New()
	.set Invoice=InputObj.Invoices.GetAt(i)
	.set BankTradeInfo=Invoice.InvocieBankInfoStr
	.set TransactionId=Invoice.TransactionId
	.set PrtRowID=Invoice.InvoiceNO
	.set myExpStr=Invoice.InvocieExpStr
	.set ResultCode=$p(BankTradeInfo,"|",1)	;判断自助三方交易是否成功
	.set BankTradeInfo=$p(BankTradeInfo,"|",2)  ;银行串  为空证明没有调银行
	.if ResultCode'="0000" d
	..set DelRtn=##class(web.DHCBillConsif).DelINVPRTForYB(PrtRowID,Grup)
	..set FailNum=FailNum+1
	..if +DelRtn'=0 d
	...set UpdateBankResultObj.ResultCode=-8
	...set ResultContent=ResultContent_PrtRowID_"回滚his失败"
   	...set UpdateBankResultObj.ResultContent=+rtn_":HIS回滚数据失败,请与计算机中心联系" 	
   	..Else  Do
   	...set CommitFailNum=CommitFailNum+1
    .Else  Do
    ..;ExpStr:扩展串(科室^安全组^医院^渠道代码^科室代码^操作员代码)
    ..set InsuType=$p(^DHCINVPRT(PrtRowID),"^",9)
    ..set MyExpStr=GLoc_"^"_Grup_"^"_InsuType_"^"_"15"_"^"_Userid_"^"_Userid_"^^^"
	..;s rtn="0"_$c(2)_"34"_$c(2)_"0000"_$c(2)_"保存成功"
	..if BankTradeInfo'="" Do
	...set SaveRtn=##class(web.DHCBillBankLogic).POSDataSave("OP",Userid,PrtRowID,"",CardNO,"C",TransactionId,BankTradeInfo,MyExpStr)
	...set IBPRowID=$p(SaveRtn,$c(2),2)
	...set Rc=$p(SaveRtn,$c(2),3)
	...set ResultContent=$p(SaveRtn,$c(2),4)
	...set SaveRtn=$p(SaveRtn,$c(2),1)
	..Else  Do
	...set SaveRtn=0
	..if (+SaveRtn=0) Do
	...set ComExpStr=Grup_"^"_GLoc_"^"_""_"^Y^F^^0^^"
   	...set SaveRtn=##class(web.DHCBillCons12).CompleteCharge("3",Userid,InsuType,PrtRowID,"0","",ComExpStr)   	
	..if (+SaveRtn=0) Do
	...set SussNum=SussNum+1
	..Else  Do
	...set CommitFailNum=CommitFailNum+1
	set ResultContent="发票总张数:"_InvoiceNum
	if SussNum>0 set ResultContent="成功结算数:"_SussNum
	if FailNum>0 set ResultContent=ResultContent_"结算失败数:"_FailNum
	if CommitFailNum>0 set ResultContent=ResultContent_"需要窗口确认数:"_CommitFailNum
   	set UpdateBankResultObj.ResultContent=ResultContent
	Do UpdateBankResultObj.XMLExportToString(.OutputXML,"Response")
   	Do UpdateBankResultObj.%Close()
   	;
	quit OutputXML
	;
InserBankTradeInfoET
   	set PatOrderObj=##class(DHCExternalService.BillInterface.DHCEntity.AutoPayUpdateBankResult).%New()
   	set PatOrderObj.ResultCode=-10
   	set PatOrderObj.ResultContent="接口程序处理出错:"_$ZERROR
  	set OutputXML=""
   	Do PatOrderObj.XMLExportToString(.OutputXML,"Response")
   	Do PatOrderObj.%Close()
	quit OutputXML
}

/// wangjian
/// 2015-03-06
/// 单条银行交易信息保存
/// w ##class(DHCExternalService.BillInterface.Service.DHCOPBillPayExp).InserBankTradeInfoSingle("<Request><TradeCode></TradeCode><PatientID></PatientID><OriHisOrderNo></OriHisOrderNo><TransactionId>01604090916000141</TransactionId><AdmInfo></AdmInfo><PatAmt>.26</PatAmt><PayModeCode></PayModeCode><BankTradeInfo><![CDATA[<Response><BankTradeNo>01604090916000141</BankTradeNo><ResultCode>00</ResultCode><ResultContent>微信退款失败</ResultContent><BankAccDate>2016-04-09 09:16:26</BankAccDate><PatientID></PatientID><PayAmt>.26</PayAmt></Response>]]></BankTradeInfo><ExpStr>^^^^^^^N</ExpStr></Request>")
ClassMethod InserBankTradeInfoSingle(Input As %String) As %String
{
	set $ZT="InserBankTradeInfoSingleET"
	New (Input)
	s ^insert("save")=Input
    set Err=0
    set StreamObj=##class(%GlobalCharacterStream).%New()
	set InputObj=##class(DHCExternalService.BillInterface.DHCEntity.AutoPayInputInfo).%New()
    Do InputObj.XMLNodeDeserialize(.InputObj,"Request",Input)
    b ;kkjkj
    set CardNO=InputObj.CardNo
    set SecrityNo=InputObj.SecrityNo
    set UserCode=InputObj.Userid
    set StDate=InputObj.StartDate 
    set EndDate=InputObj.EndDate
    set PatAmt=InputObj.PatAmt 
    set BankTradeInfo=InputObj.BankTradeInfo
    set AdmInfo=InputObj.AdmInfo
    set ExpStr=InputObj.ExpStr
    set TransactionId=InputObj.TransactionId
    set PrtRowID=InputObj.InvoiceNO
    set RollFlag=$p(ExpStr,"^",8)
    
    
    s AbortRowid=""
    i PrtRowID=""  d
    .s PrtRowID=$p(^DHCBillAliPay("MZJF","HisTradeNOConPrt",TransactionId),"^",1)
    .s AbortRowid=$p(^DHCBillAliPay("MZJF","HisTradeNOConPrt",TransactionId),"^",2)
    i AbortRowid'="" s TradeType="D" 
    e   s TradeType="C"
    b ;kkk
    set OutputXML=""
    set UpdateBankResultObj=##class(DHCExternalService.BillInterface.DHCEntity.AutoPayUpdateBankResult).%New()
  	i UserCode="" s UserCode="wx002"
	set:UserCode'="" UserCode=$$ALPHAUP^SSUTIL4(UserCode)
   	set:UserCode'="" Userid=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,""))
   	if (Userid="")||('$d(^SSU("SSUSR",Userid))){
	   set UpdateBankResultObj.ResultCode=-3
	   set UpdateBankResultObj.ResultContent="无此操作员"
	   set OutputXML=""
	   Do UpdateBankResultObj.XMLExportToString(.OutputXML,"Response")
	   Do UpdateBankResultObj.%Close()
	}
	quit:(Userid="")||('$d(^SSU("SSUSR",Userid))) OutputXML
   	set GLoc=$p($g(^SSU("SSUSR",Userid)),"^",4)
	set Grup=$p($g(^SSU("SSUSR",Userid)),"^",5)  ;安全组
	;ExpStr:扩展串(科室^安全组^医院^渠道代码^科室代码^操作员代码)
    set MyExpStr=GLoc_"^"_Grup_"^"_"1"_"^"_"15"_"^"_Userid_"^"_Userid_"^^^"
    i UserCode="WX002"  set Paymode="22"  ;微信支付
    
    set OrderObj=##class(web.DHCEntity.PCA.BankTradeOutput).%New()
	do OrderObj.XMLNodeDeserialize(.OrderObj,"Response",BankTradeInfo)
	set ResultCode=OrderObj.ResultCode   
    
    if (TransactionId=""){
	   set UpdateBankResultObj.ResultCode=-3
	   set UpdateBankResultObj.ResultContent="His流水号为空"
	   set OutputXML=""
	   Do UpdateBankResultObj.XMLExportToString(.OutputXML,"Response")
	   Do UpdateBankResultObj.%Close()
	}
	quit:(TransactionId="") OutputXML
    
    if ((RollFlag="N")&&(ResultCode'="00")){
	   set UpdateBankResultObj.ResultCode=-3
	   set UpdateBankResultObj.ResultContent="失败不更新his状态"
	   set OutputXML=""
	   Do UpdateBankResultObj.XMLExportToString(.OutputXML,"Response")
	   Do UpdateBankResultObj.%Close()
	}
	quit:((RollFlag="N")&&(ResultCode'="00")) OutputXML    
    set PayModHand=##class(DHCExternalService.BillInterface.Service.DHCOPBillPayLogic).GetPayModeHardComm("OP",Paymode)
	;set Rtn=##class(web.DHCBillBankLogic).POSDataSave("OP",Userid,PrtRowID,"",CardNO,"C",TransactionId,BankTradeInfo,MyExpStr)
	set Rtn=##class(DHCExternalService.BillInterface.Service.DHCOPBillPayLogic).BMCUpdateTradeData(PayModHand,"OP",PrtRowID,AbortRowid,TradeType,TransactionId,BankTradeInfo, MyExpStr) 	
	set Err=$p(Rtn,$c(2),1)	;err_$c(2)_$g(IBPRowID)_$c(2)_$g(Rc)_$c(2)_$g(RcDetail)
	set IBPRowID=$p(Rtn,$c(2),2)
	set Rc=$p(Rtn,$c(2),3)
	set ResultContent=$p(Rtn,$c(2),4)	;
	
	if (ResultCode'="00")&&(RollFlag'="N") {
		set Rtn=##class(web.DHCBillConsif).DelINVPRTForYB(PrtRowID,Grup)
	}Else{
		For i=2:1:$l(PrtRowID,"^") Do  quit:+Rtn'=0
	    .set PrtInvRowid=$p(PrtRowID,"^",i)
	    .quit:+PrtInvRowid=0
	   	.set MyInsTypeDR=$p(^DHCINVPRT(PrtInvRowid),"^",9)
		.set MyExpStr=Grup_"^"_GLoc_"^"_""_"^Y^F^^0^^"
		.set Rtn=##class(web.DHCBillConsif).CompleteCharge("7",Userid,MyInsTypeDR,PrtInvRowid,"0","",MyExpStr)
	}
	
	if (+Rtn'=0)&&(ResultCode'="00") {
	set UpdateBankResultObj.resultCode=-8
   	set UpdateBankResultObj.resultDesc="银行交易失败,HIS回滚数据失败,请与计算机中心联系"
   	set OutputXML=""
	Do UpdateBankResultObj.XMLExportToString(.OutputXML,"res")
	Do UpdateBankResultObj.%Close() 
	}
	quit:(+Rtn'=0)&&(ResultCode'="00") OutputXML
	
	if (+Rtn=0)&&(ResultCode'="00")&&(RollFlag'="N") {
	set UpdateBankResultObj.resultCode=0
   	set UpdateBankResultObj.resultDesc="银医卡交易失败，HIS回滚成功。"
   	set OutputXML=""
	Do UpdateBankResultObj.XMLExportToString(.OutputXML,"res")
	Do UpdateBankResultObj.%Close()  
	}
   	quit:(+Rtn=0)&&(ResultCode'="00")&&(RollFlag'="N") OutputXML
   	
	set UpdateBankResultObj.resultCode=Rtn
   	set UpdateBankResultObj.resultDesc=+Rtn_":HIS插入银行交易信息成功." 
	Do UpdateBankResultObj.XMLExportToString(.OutputXML,"res")
   	Do UpdateBankResultObj.%Close()
   
   	;
	q OutputXML
	;
InserBankTradeInfoSingleET
   	set PatOrderObj=##class(DHCExternalService.BillInterface.DHCEntity.AutoPayUpdateBankResult).%New()
   	set PatOrderObj.resultCode=-10
   	set PatOrderObj.resultDesc="程序处理出错:"_$ZERROR
  	set OutputXML=""
   	Do PatOrderObj.XMLExportToString(.OutputXML,"res")
   	Do PatOrderObj.%Close()
	quit OutputXML
}

/// Creator:zhho
/// CreatDate:2016-03-25
/// Desc:查证交易是否完成
/// Input:
/// Return:
/// Debug:w ##class(web.DHCOPBillAutoPayExp).GetPatientInfo("")
ClassMethod CheckOPBillCharge(Input As %String) As %String
{
	;set $ZT="GetPatientInfoET"
	set OutputXML=""
	set InputObj=##class(DHCExternalService.BillInterface.DHCEntity.AutoPayInputInfo).%New()
    Do InputObj.XMLNodeDeserialize(.InputObj,"Request",Input)
    set CardNo=InputObj.CardNo
    set SecrityNo=InputObj.SecrityNo
    ;set:SecrityNo="" SecrityNo=0
    set PatNo=InputObj.PatientID
    set ExpStr=InputObj.ExpStr
    set CardType=$p(ExpStr,"^",1)	;卡类型，有自助机在扩展串的第一位传入
    set BankTradeNoStr=InputObj.BankTradeInfo
    set OutputObj=##class(DHCExternalService.BillInterface.DHCEntity.AutoPayChargeResult).%New()
    set OrderObj=##class(web.DHCEntity.PCA.BankTradeOutput).%New()
	do OrderObj.XMLNodeDeserialize(.OrderObj,"Response",BankTradeNoStr)
	set BankTradeNo=OrderObj.BankTradeNo 
	
	if (BankTradeNo=""){
	   ;set OutputObj.ResultCode=-1
	   ;set OutputObj.ResultContent="查证流水号为空"
	   ;set OutputXML=""
	   ;Do OutputObj.XMLExportToString(.OutputXML,"Response")
	   ;Do OutputObj.%Close()
	   s OutputXML="<res><resultCode>-1</resultCode><resultDesc>失败</resultDesc></res>"
	}
	quit:(BankTradeNo) OutputXML
	set LogInfo=$g(^ChargeCheck(+$h,BankTradeNo))
	if (+LogInfo'=0){
	   set OutputObj.ResultCode=-1
	   set OutputObj.ResultContent=LogInfo
	   set OutputXML=""
	   Do OutputObj.XMLExportToString(.OutputXML,"Response")
	   Do OutputObj.%Close()
	}
	quit:(+LogInfo'=0) OutputXML
	set TransactionId=""
	set IBPRowid=""
	set IBPRowid=$o(^DHCINVBTPi(0,"RRN",BankTradeNo,""))
	set:IBPRowid'="" TransactionId=$p(^DHCINVALITP(IBPRowid),"^",20)
	set tradeDate=$p(^DHCINVALITP(IBPRowid),"^",14)_" "_$p(^DHCINVALITP(IBPRowid),"^",15)
	set hisOrderid=$p(^DHCINVALITP(IBPRowid),"^",32)
	set OutputXML="<res><resultCode>0</resultCode><resultDesc>成功</resultDesc><pageSize>1</pageSize><pageNo>1</pageNo><hasNextPage>0</hasNextPage><orderInfo><tradeDate>"_tradeDate_"</tradeDate><payMode>98</payMode><hisOrderId>"_hisOrderid_"</hisOrderId><tradeNo></tradeNo><orderId></orderId><tradeFee></tradeFee></orderInfo></res>"

	
	For i=2:1:$l(LogInfo,"^") Do  
	.set PrtInvRowid=$p(InvRowidStr,"^",i)
	.quit:+PrtInvRowid=0
	.set invAmt=$P(^DHCINVPRT(PrtInvRowid),"^",16)
	.set InvoiceObj=##class(DHCExternalService.BillInterface.DHCEntity.Invoice).%New()
	.set InvoiceObj.TransactionId=TransactionId
	.set InvoiceObj.InvoiceNO=PrtInvRowid
	.set InvoiceObj.InvoiceAmt=$J(invAmt,3,2)
	.set InvoiceObj.PrescWindow=$g(WinInfo)
	.set InvoiceObj.InvocieExpStr=invocieExpstr
	.Do OutputObj.Invoices.Insert(InvoiceObj)	 	
	.Do InvoiceObj.%Close() 
	
	/*set IBPRowid=""
	set IBPRowid=$o(^DHCINVBTPi(0,"RRN",BankTradeNo,"")) 
	if (IBPRowid="")	{
		set OutputObj.ResultCode=-1
		set OutputObj.ResultContent="His流水表无该流水号,请核对！"
		set OutputXML=""
		Do OutputObj.XMLExportToString(.OutputXML,"Response")
		Do OutputObj.%Close()
	}  
	quit:(BankTradeNo) OutputXML  
	*/
   	set OutputXML=""
  	Do OutputObj.XMLExportToString(.OutputXML,"Response")
  	Do OutputObj.%Close()
    quit OutputXML
    ;
GetPatientInfoET
	set OutputXML=""
	set OutputObj=##class(DHCExternalService.BillInterface.DHCEntity.AutoPayPatInfo).%New()
	set OutputObj.ResultCode=-10
	set OutputObj.ResultContent="程序处理错误:"_$ZERROR
	Do OutputObj.XMLExportToString(.OutputXML,"Response")
	quit OutputXML
}

/// 2)	院内账户预交金充值
/// w ##Class(CardInterface.OPAccountDeposit).AddOPDeposit("<Request><TradeCode></TradeCode><TerminalID></TerminalID><HospitalId></HospitalId><ExtUserID>ZZ001</ExtUserID><PatientCard>010000117566</PatientCard><CardTypeCode>03</CardTypeCode><PatientID>0000856972</PatientID><AccountID>808975</AccountID><Amount>20</Amount><PayModeCode>CASH</PayModeCode><TransactionId>114</TransactionId><BankCode></BankCode><BankAccDate></BankAccDate><BankTransactionId></BankTransactionId><BankCardNo></BankCardNo></Request>")
ClassMethod AddOPDeposit(InputXml As %String) As %String
{
	set $zt="AddOPDepositErr"
	s ^TEMP("AddOPDeposit")=InputXml
	set InputObj=##Class(DHCExternalService.BillInterface.DHCEntity.AddOPDepositRt).%New()
	do InputObj.XMLNodeDeserialize(.InputObj,"Request",InputXml)
	set OutputObj=##Class(DHCExternalService.BillInterface.DHCEntity.AddOPDepositRp).%New()
	set CardTypeCode=InputObj.CardTypeCode
	set PatientCard=InputObj.PatientCard
	set PatientID=InputObj.PatientID
	set AccountID=InputObj.AccountID
	set Amount=+InputObj.Amount
	set PayModeCode=$$ALPHAUP^SSUTIL4(InputObj.PayModeCode)
	set TransactionId=InputObj.TransactionId
	set BankCode=InputObj.BankCode
	set BankAccDate=InputObj.BankAccDate
	set BankTransactionId=InputObj.BankTransactionId
	set BankCardNo=InputObj.BankCardNo
	
	set PayModeID=##class(DHCExternalService.RegInterface.GetRelate).GetHisPayModeID(PayModeCode) 
	set UserID=##Class(RegInterface.GetRelate).GetUser(InputObj.ExtUserID)
	set BankID=##Class(CardInterface.GetRelate).GetHISBankID(BankCode)
	
	if (PatientID="")
	{
		set OutputObj.ResultCode="-102"
		set OutputObj.ResultContent="病人信息不存在."
		do OutputObj.XMLExportToString(.OutputXml,"Response")
		quit OutputXml
	}
	if (AccountID="") {
		set OutputObj.ResultCode="-103"
		set OutputObj.ResultContent="门诊账户信息不存在."
		do OutputObj.XMLExportToString(.OutputXml,"Response")
		quit OutputXml
	}
	set myPatID=$piece($get(^DHCACD("AccM",AccountID)),"^",3)
	if (myPatID'=PatientID)
	{
		set OutputObj.ResultCode="-104"
		set OutputObj.ResultContent="账户和病人不匹配."
		do OutputObj.XMLExportToString(.OutputXml,"Response")
		quit OutputXml
	}
	if (UserID="") {
		set OutputObj.ResultCode="-105"
		set OutputObj.ResultContent="自助机HIS系统用户不存在."
		do OutputObj.XMLExportToString(.OutputXml,"Response")
		quit OutputXml
	}
	if (Amount'>0)
	{
		set OutputObj.ResultCode="-106"
		set OutputObj.ResultContent="充值金额错误."
		do OutputObj.XMLExportToString(.OutputXml,"Response")
		quit OutputXml
		
	}
	if (PayModeCode="")
	{
		set OutputObj.ResultCode="-107"
		set OutputObj.ResultContent="支付方式不能为空."
		do OutputObj.XMLExportToString(.OutputXml,"Response")
		quit OutputXml
	}
	//w PayModeCode,!
	if (PayModeID="")
	{
		set OutputObj.ResultCode="-108"
		set OutputObj.ResultContent="支付方式没有对照."
		do OutputObj.XMLExportToString(.OutputXml,"Response")
		quit OutputXml
	}
	if (PayModeCode="CASH")
	{
		if (TransactionId="")
		{
			set OutputObj.ResultCode="-109"
			set OutputObj.ResultContent="现金交易流水号不能为空."
			do OutputObj.XMLExportToString(.OutputXml,"Response")
			quit OutputXml	
		}
		set BankTransactionId=TransactionId //现金充值时流水号保存位置和银行的一样
	}
	elseif(PayModeCode="YHK")
	{
		if (BankID="")||(BankAccDate="")||(BankTransactionId="")||(BankCardNo="")
		{
			set OutputObj.ResultCode="-110"
			set OutputObj.ResultContent="银行交易信息不能为空."
			do OutputObj.XMLExportToString(.OutputXml,"Response")
			quit OutputXml	
		}
	}
	else
	{
		set OutputObj.ResultCode="-111"
		set OutputObj.ResultContent="支付代码错误."
		do OutputObj.XMLExportToString(.OutputXml,"Response")
		quit OutputXml
	}
	//预交金收据号
	s Rtn=##Class(web.UDHCAccAddDeposit).GetCurrentRecNo(UserID,"D")
	s ReceiptsNo=$p(Rtn,"^",4)
	i (ReceiptsNo=""){
		set OutputObj.ResultCode="-114"
		set OutputObj.ResultContent="预交金收据已用完"
		do OutputObj.XMLExportToString(.OutputXml,"Response")
		quit OutputXml
	}
	//808975^20^1765^4.收据号^^^1^8.^^^^114^^^押金类型
	//808965^100^1748^0956016^^^1^1^^^^12. ^^^P
	//str=AccountID_"^"_amt_"^"_user_"^"_ReceiptsNo_"^"_BackReason_"^"_Password_"^"_PayModeID_"^"_BankCardTypeID_"^"_CardChequeNo_"^"_BankID_"^"_Company_"^"_PayAccNo_"^"_ChequeDate_"^"_Remark_"^"_PDType
	//str="1.院内账户ID^2.充值金额^3.用户ID^4.收据号^5.退款原因^6.账户密码^7.支付方式ID^8.银行卡类型ID^9.支票号^10.银行ID^11.支付单位^12.支付账户号^13.支票日期^14.备注^15.押金类型"
	set myStr=AccountID_"^"_Amount_"^"_UserID_"^"_ReceiptsNo_"^^^"_PayModeID_"^^"_BankCardNo_"^"_BankID_"^^"_BankTransactionId_"^"_BankAccDate_"^^P"
	TSTART
	set myrtn=##Class(web.UDHCAccAddDeposit).AddDeposit(myStr)
	if (+myrtn=0)
	{
		TCommit		
		set RechargeTime=$p(myrtn,"^",5)
		set:RechargeTime="" RechargeTime=$zd(+$h,3)_" "_$zt($p($h,",",2),1)
		set OutputObj.DepositAmount=+$piece(myrtn,"^",4)
		set OutputObj.InvoiceNo=""
		set OutputObj.RechargeTime=RechargeTime
		set OutputObj.ResultCode=0
		set OutputObj.ResultContent="充值成功"
	}
	else
	{
		TRollback
		set OutputObj.ResultCode="-1"
		set OutputObj.ResultContent="充值失败."
	}
	
	do OutputObj.XMLExportToString(.OutputXml,"Response")
	quit OutputXml
	
	
AddOPDepositErr
	TRollback
	Set OutputObj=##Class(CardInterface.Entity.OPAcc.AddOPDepositRp).%New()
	Set OutputObj.ResultCode="-1"
	Set OutputObj.ResultContent="预交金充值失败:"_$ZERROR
	do OutputObj.XMLExportToString(.OutputXml,"Response")
	quit OutputXml
}

/// creat by zhl 2010.09.01
/// description   根据就诊记录取该就诊记录的发票明细
/// debugger: w ##class(DHCExternalService.BillInterface.Service.DHCOPBillPayExp).GetCompletedPayInfo("<Request><TradeCode></TradeCode><PatientID>00000036</PatientID></Request>")  
/// detail  :    lab1_"^"_lab2_"^"_lab3_"^"_lab4_"^"_lab5_"^"_lab6
ClassMethod GetCompletedPayInfo(Input As %String) As %GlobalCharacterStream
{
   set $zt="GetCompletedPayInfoET"
	New (Input)
	s ^testget=Input
    set Err=0,HospDR=""
    set StreamObj=##class(%GlobalCharacterStream).%New()
	set InputObj=##class(DHCExternalService.BillInterface.DHCEntity.AutoPayInputInfo).%New()
    do InputObj.XMLNodeDeserialize(.InputObj,"Request",Input)
    b ;kkkk
    set CardNO=InputObj.CardNo
    set SecrityNo=InputObj.SecrityNo
    set PatNo=InputObj.PatientID
    set StDate=InputObj.StartDate 
    set EndDate=InputObj.EndDate 

    set PatNo=$$ALPHAUP^SSUTIL4(PatNo) 
	set myPAPMIDR=$o(^PAPERi("PAPMI_PatNo",PatNo,""))
    set OutputXML=""
    set PayRecordObj=##class(DHCExternalService.BillInterface.DHCEntity.PayList).%New()
    set myIdx=0
	For date=(+$h-1):1:+$h Do	;默认查30天以内的未打印发票记录
	.b ;00
	.set myPRTRowID=""
	.For  set myPRTRowID=$o(^DHCINVPRT(0,"DatePAPMI",date,myPAPMIDR,myPRTRowID)) quit:myPRTRowID=""  Do
	..set myPLRowID=myPRTRowID
	..set myFairType=$p(^DHCINVPRT(myPRTRowID),"^",34)	;PRT_FairType
	..i myPRTRowID=1624957 b ;kkkklk
	..;quit:(myFairType'="F")&(myFairType'="R")	;
	..set myprtprintflag=$p(^DHCINVPRT(myPRTRowID),"^",3)
	..set myBillConRowid=$o(^DHCBCI(0,"INV",myPRTRowID,""))	
	..set myAdm=$p(^DHCBCI(myBillConRowid),"^",3)	
	..set myLocDr=$p(^PAADM(myAdm),"^",4)
	..set myAdmDate=$zd($p(^PAADM(myAdm),"^",6),3)
	..set mydocdr=$p(^PAADM(myAdm),"^",9)
	..set mydocdesc=$p(^CTPCP(mydocdr,1),"^",2)
	..set myLocDesc=$p(^CTLOC(myLocDr),"^",2)	
	..;quit:myprtprintflag="P"
	..set myprtflag=$p(^DHCINVPRT(myPRTRowID),"^",8)
	..i myPRTRowID=1624957  ;kjkjl
	..quit:((myprtflag="S")!(myprtflag="A")!(myprtflag="TP"))
	..set IPM="0",CardPayFlag=0
	..For  set IPM=$o(^DHCINVPRT(myPRTRowID,"P",IPM)) q:((IPM="")!(CardPayFlag=1))  d
	...set s=$g(^DHCINVPRT(myPRTRowID,"P",IPM))
	...set PayModeDr=$p(s,"^",1)
	...set:PayModeDr=22 CardPayFlag=1
	...i myPRTRowID=1624957 b ;sjfljflsd
	..quit:CardPayFlag=0		;只有支付方式CARDCPP且未打印发票的记录才查询出来
	..set mySSUsrDR=$p(^DHCINVPRT(myPRTRowID),"^",21)
	..set mySSUDesc=$p(^SSU("SSUSR",mySSUsrDR),"^",2)
	..set myPayDate=$zd($p(^DHCINVPRT(myPRTRowID),"^",5),3)
	..set myPayTime=$zt($p(^DHCINVPRT(myPRTRowID),"^",20),1)
	..set myPayNum=$fn($p(^DHCINVPRT(myPRTRowID),"^",1),"",2)*100	
	..set OrderDetails=""
	..set OrderDetails="" ;..GetOrdDetailsByPrtRowID(myPRowID)
	..set AccListDetailObj=##class(DHCExternalService.BillInterface.DHCEntity.PayListInfo).%New()
	..set AccListDetailObj.ChargeDate=myPayDate_" "_myPayTime
	..set AccListDetailObj.ReceiptId=myPRTRowID
	..set:myFairType="F" FairType="收费"
	..set:myFairType="R" FairType="挂号"
	..set AccListDetailObj.Adm=$g(myAdm)
	..set AccListDetailObj.AdmDate=myAdmDate	
	..set AccListDetailObj.AdmDep=myLocDr
	..set AccListDetailObj.AdmDepName=myLocDesc
	..set AccListDetailObj.DoctorId=mydocdr
	..set AccListDetailObj.DoctorName=mydocdesc
	..set AccListDetailObj.PayAmout=myPayNum 	
	..b ;03
	..set myIdx=+myIdx+1
	..Do PayRecordObj.PayListInfo.Insert(AccListDetailObj)
	..Do AccListDetailObj.%Close()
	b ;08
	i myIdx=0  {	
		set PayRecordObj.ResultCode=0
		set PayRecordObj.ResultContent="没有查询到您半月内的消费记录!"	   
		Do PayRecordObj.XMLExportToString(.OutputXML,"Response")
		Do PayRecordObj.%Close()	
	}
	else{
		set PayRecordObj.ResultCode=0
		set PayRecordObj.ResultContent="查询成功"	   
		Do PayRecordObj.XMLExportToString(.OutputXML,"Response")
		b ;kkkkk678
		Do PayRecordObj.%Close()			
		}

	q OutputXML
GetCompletedPayInfoET
	set OutputXML=""
	set OutputObj=##class(DHCExternalService.BillInterface.DHCEntity.PayList).%New()
	set OutputObj.ResultCode=-10
	set OutputObj.ResultContent="程序处理错误:"_$ZERROR
	Do OutputObj.XMLExportToString(.OutputXML,"Response")
	quit OutputXML
}

/// Lid
/// 2011-03-30
/// 根据发票Rowid获取明细
/// w ##class(DHCExternalService.BillInterface.Service.DHCOPBillPayExp).GetCompletedPayDetailInfo("<Request><CardNo></CardNo><SecrityNo></SecrityNo><Userid>cashier</Userid><StartDate></StartDate><EndDate></EndDate><PatAmt></PatAmt><BankTradeInfo></BankTradeInfo><AdmInfo></AdmInfo><InsuTypeDR></InsuTypeDR><PayModeCode></PayModeCode><TransactionId></TransactionId><InvoiceNO></InvoiceNO><YBChargeData></YBChargeData><ReceiptId>1624916</ReceiptId><PatientID>00326006</PatientID><ExpStr></ExpStr></Request>")
ClassMethod GetCompletedPayDetailInfo(Input As %String) As %GlobalCharacterStream
{
	set $zt="GetCompletedPayDetailInfoET"
	New (Input)
    set Err=0,HospDR=""
    set StreamObj=##class(%GlobalCharacterStream).%New()
	set InputObj=##class(DHCExternalService.BillInterface.DHCEntity.AutoPayInputInfo).%New()
    do InputObj.XMLNodeDeserialize(.InputObj,"Request",Input)
    set CardNO=InputObj.CardNo
    set SecrityNo=InputObj.SecrityNo
    set PatNo=InputObj.PatientID
    set StDate=InputObj.StartDate 
    set EndDate=InputObj.EndDate 
    set PrtRowid=InputObj.ReceiptId 
    set InAdm=InputObj.AdmInfo
    set Total=0
    set PatOrderObj=##class(DHCExternalService.BillInterface.DHCEntity.PayDetail).%New()    
	i PrtRowid'="" set Flag="INV"
	i (PrtRowid="")&&(InAdm'="") set Flag="ADM",PrtRowid=InAdm
	set billconrowid="" for  set billconrowid=$o(^DHCBCI(0,Flag,PrtRowid,billconrowid))  quit:billconrowid=""  do
	.s AdmBill=$p(^DHCBCI(billconrowid),"^",2)
	.set PBO="0"
	.for  set PBO=$o(^DHCPB(AdmBill,"O",PBO))  quit:PBO=""  Do
	..quit:('$D(^DHCPB(AdmBill,"O",PBO)))||($d(^DHCPB(AdmBill,"O",PBO))=10)
	..set PBord=$p($g(^DHCPB(AdmBill,"O",PBO)),"^",4)
	..set OrdDoc=$p($g(^OEORD(+PBord,"I",$p(PBord,"||",2),1)),"^",11)
	..;set DocName=$p($g(^SSU("SSUSR",Userid)),"^",2)
	..set OrdRecLoc=$p($g(^OEORD(+PBord,"I",$p(PBord,"||",2),3)),"^",6)
	..set RecLocDesc=$p($g(^CTLOC(OrdRecLoc)),"^",2)
	..set LocAdress=$g(^CTLOC(OrdRecLoc,"ADDR",0))
	..set OrdStat=$p($g(^OEORD(+PBord,"I",$p(PBord,"||",2),1)),"^",13)
	..set:OrdStat'="" OrdStat=$p($g(^OEC("OSTAT",OrdStat)),"^",1)
	..set OrdIns=$p($g(^OEORD(+PBord,"I",$p(PBord,"||",2),11)),"^",18)
	..set ArcimRowid=$p($g(^DHCPB(AdmBill,"O",PBO)),"^",3)
	..set PackUOMRowid=$p($g(^ARCIM(+ArcimRowid,1,8)),"^",14) ;整包装单位
	..set Price=$p($g(^DHCPB(AdmBill,"O",PBO)),"^",7)
	..set INCI=$o(^INCI(0,"ARCIM_DR",+ArcimRowid,""))		;INC_Itm->RowID
	..if INCI'="" Do 
	...set INCIUOM=$p(^INCI(INCI,1),"^",10)   ;INC_Itm->INCI_CTUOM_DR
	...set ConFacDr=$o(^CT("CTCF",0,"UOM",PackUOMRowid,INCIUOM,""))
	...if ConFacDr="" set ConFac=1
	...Else  set ConFac=$P(^CT("CTCF",ConFacDr),"^",3)
	..Else  set ConFac=1	
	..set Price=$fn(Price*ConFac,"",6)		;4--->6	
	..set OrderAmt=$p($g(^DHCPB(AdmBill,"O",PBO)),"^",8)*100
	..set ArcimDesc=$p($g(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1)),"^",2) ;名称	
	..set Qty=$p($g(^DHCPB(AdmBill,"O",PBO)),"^",5)
	..set RefundQty=$p($g(^DHCPB(AdmBill,"O",PBO)),"^",6)
	..set Qty=Qty-RefundQty
	..set Qty=Qty/ConFac
	..set OEPrice=$p($g(^OEORD(+PBord,"I",$p(PBord,"||",2),3)),"^",25)		;;取出P   价格 OE_OrdItem->OEORI_Price
	..set PackQty=$p($g(^OEORD(+PBord,"I",$p(PBord,"||",2),9)),"^",4)
	..b ;kkkk
	..set PackUOM=""
	..if PackUOMRowid'=""  Do
	...set PackUOM=$p(^CT("UOM",PackUOMRowid),"^",2)	
	..set OEOrdItemObj=##class(DHCExternalService.BillInterface.DHCEntity.OEOrdItem).%New()
    ..set OEOrdItemObj.ArcmiDesc=ArcimDesc
 	..set OEOrdItemObj.Price=$j(Price,3,2)
 	..set OEOrdItemObj.DiscAmount="" 
 	..set OEOrdItemObj.Qty=Qty
 	..set OEOrdItemObj.PatientShareAmt="" 
 	..set OEOrdItemObj.PayorShareAmt=" "
 	..set OEOrdItemObj.TotalAmount=OrderAmt
 	..set OEOrdItemObj.UOM=PackUOM 	
 	..set OEOrdItemObj.InsuType=" "
 	..set OEOrdItemObj.Unit=ConFac
 	
 	..set Total=Total+OrderAmt
 	..Do PatOrderObj.OEOrdItems.Insert(OEOrdItemObj)
 	..Do OEOrdItemObj.%Close() 	
 	b ;kkkkk
 	If (+Total>0){
	 	Set PatOrderObj.ResultCode=0
	    Set PatOrderObj.ResultContent="获取费用信息成功."
	}else{
		Set PatOrderObj.ResultCode=-4
	    Set PatOrderObj.ResultContent="此病人无医嘱信息."	
	}
	 set OutputXML=""
	  Do PatOrderObj.XMLExportToString(.OutputXML,"Response")
	   Do PatOrderObj.%Close()
	   
	   q OutputXML
	
	
GetCompletedPayDetailInfoET	
	set OutputObj=##class(DHCExternalService.BillInterface.DHCEntity.PayDetail).%New()
	set OutputObj.ResultCode=-10
	set OutputXML=""
	set OutputObj.ResultContent="程序处理错误:"_$ZERROR
	Do OutputObj.XMLExportToString(.OutputXML,"Response")
	Quit OutputXML
}

/// 获取病人的交费信息（含明细）
/// w ##class(DHCExternalService.BillInterface.Service.DHCOPBillPayExp).GetCompletedPayWithDetail("<Request><CardNo></CardNo><SecrityNo></SecrityNo><Userid>cashier</Userid><StartDate></StartDate><EndDate></EndDate><PatAmt></PatAmt><BankTradeInfo></BankTradeInfo><AdmInfo></AdmInfo><InsuTypeDR></InsuTypeDR><PayModeCode></PayModeCode><TransactionId></TransactionId><InvoiceNO></InvoiceNO><YBChargeData></YBChargeData><ReceiptId></ReceiptId><PatientID>00326006</PatientID><ExpStr></ExpStr></Request>")
ClassMethod GetCompletedPayWithDetail(Input As %String) As %GlobalCharacterStream
{
	 set $zt="GetCompletedPayWithDetailET"
	New (Input)
    set Err=0,HospDR=""
    set StreamObj=##class(%GlobalCharacterStream).%New()
	set InputObj=##class(DHCExternalService.BillInterface.DHCEntity.AutoPayInputInfo).%New()
    do InputObj.XMLNodeDeserialize(.InputObj,"Request",Input)
    b ;kkkk
    set CardNO=InputObj.CardNo
    set SecrityNo=InputObj.SecrityNo
    set PatNo=InputObj.PatientID
    set StDate=InputObj.StartDate 
    set EndDate=InputObj.EndDate 
    set PatNo=$$ALPHAUP^SSUTIL4(PatNo) 
	set myPAPMIDR=$o(^PAPERi("PAPMI_PatNo",PatNo,""))
    set OutputXML=""
    set PayRecordObj=##class(DHCExternalService.BillInterface.DHCEntity.PayList).%New()
    set myIdx=0
	For date=(+$h-1):1:+$h Do	;默认查30天以内的未打印发票记录
	.b ;00
	.set myPRTRowID=""
	.For  set myPRTRowID=$o(^DHCINVPRT(0,"DatePAPMI",date,myPAPMIDR,myPRTRowID)) quit:myPRTRowID=""  Do
	..set myPLRowID=myPRTRowID
	..set myFairType=$p(^DHCINVPRT(myPRTRowID),"^",34)	;PRT_FairType
	..quit:(myFairType'="F")&(myFairType'="R")	;
	..set myprtprintflag=$p(^DHCINVPRT(myPRTRowID),"^",3)
	..set myBillConRowid=$o(^DHCBCI(0,"INV",myPRTRowID,""))	
	..set myAdm=$p(^DHCBCI(myBillConRowid),"^",3)
	..set myLocDr=$p(^PAADM(myAdm),"^",4)
	..set myAdmDate=$zd($p(^PAADM(myAdm),"^",6),3)
	..s myLocDesc=$p(^CTLOC(myLocDr),"^",2)	
	..;quit:myprtprintflag="P"
	..set myprtflag=$p(^DHCINVPRT(myPRTRowID),"^",8)
	..quit:((myprtflag="S")!(myprtflag="A")!(myprtflag="TP"))
	..set IPM="0",CardPayFlag=0
	..For  set IPM=$o(^DHCINVPRT(myPRTRowID,"P",IPM)) q:((IPM="")!(CardPayFlag=1))  d
	...set s=$g(^DHCINVPRT(myPRTRowID,"P",IPM))
	...set PayModeDr=$p(s,"^",1)
	...set:PayModeDr=13 CardPayFlag=1
	..quit:CardPayFlag=0		;只有支付方式CARDCPP且未打印发票的记录才查询出来
	..set mySSUsrDR=$p(^DHCINVPRT(myPRTRowID),"^",21)
	..set mySSUDesc=$p(^SSU("SSUSR",mySSUsrDR),"^",2)
	..set myPayDate=$zd($p(^DHCINVPRT(myPRTRowID),"^",5),3)
	..set myPayTime=$zt($p(^DHCINVPRT(myPRTRowID),"^",20),1)
	..set myPayNum=$fn($p(^DHCINVPRT(myPRTRowID),"^",1),"",2)	
	..set OrderDetails=""
	..set OrderDetails="" ;..GetOrdDetailsByPrtRowID(myPRowID)
	..set AccListDetailObj=##class(DHCExternalService.BillInterface.DHCEntity.PayListInfo).%New()
	..set AccListDetailObj.ChargeDate=myPayDate_" "_myPayTime
	..set AccListDetailObj.ReceiptId=myPRTRowID
	..set:myFairType="F" FairType="收费"
	..set:myFairType="R" FairType="挂号"
	..set AccListDetailObj.Adm=$g(myAdm)
	..set AccListDetailObj.AdmDate=myAdmDate	
	..set AccListDetailObj.AdmDep=myLocDr
	..set AccListDetailObj.AdmDepName=myLocDesc
	..set AccListDetailObj.DoctorId=""
	..set AccListDetailObj.DoctorName=""	
	..set billconrowid="" for  set billconrowid=$o(^DHCBCI(0,"INV",myPRTRowID,billconrowid))  quit:billconrowid=""  do
	...s AdmBill=$p(^DHCBCI(billconrowid),"^",2)
	...set PBO="0"
	...for  set PBO=$o(^DHCPB(AdmBill,"O",PBO))  quit:PBO=""  Do
	....quit:('$D(^DHCPB(AdmBill,"O",PBO)))||($d(^DHCPB(AdmBill,"O",PBO))=10)
	....set PBord=$p($g(^DHCPB(AdmBill,"O",PBO)),"^",4)
	....set OrdDoc=$p($g(^OEORD(+PBord,"I",$p(PBord,"||",2),1)),"^",11)
	....;set DocName=$p($g(^SSU("SSUSR",Userid)),"^",2)
	....set OrdRecLoc=$p($g(^OEORD(+PBord,"I",$p(PBord,"||",2),3)),"^",6)
	....set RecLocDesc=$p($g(^CTLOC(OrdRecLoc)),"^",2)
	....set LocAdress=$g(^CTLOC(OrdRecLoc,"ADDR",0))
	....set OrdStat=$p($g(^OEORD(+PBord,"I",$p(PBord,"||",2),1)),"^",13)
	....set:OrdStat'="" OrdStat=$p($g(^OEC("OSTAT",OrdStat)),"^",1)
	....set OrdIns=$p($g(^OEORD(+PBord,"I",$p(PBord,"||",2),11)),"^",18)
	....set ArcimRowid=$p($g(^DHCPB(AdmBill,"O",PBO)),"^",3)
	....set PackUOMRowid=$p($g(^ARCIM(+ArcimRowid,1,8)),"^",14) ;整包装单位
	....set Price=$p($g(^DHCPB(AdmBill,"O",PBO)),"^",7)
	....set INCI=$o(^INCI(0,"ARCIM_DR",+ArcimRowid,""))		;INC_Itm->RowID
	....if INCI'="" Do 
	.....set INCIUOM=$p(^INCI(INCI,1),"^",10)   ;INC_Itm->INCI_CTUOM_DR
	.....set ConFacDr=$o(^CT("CTCF",0,"UOM",PackUOMRowid,INCIUOM,""))
	.....if ConFacDr="" set ConFac=1
	.....Else  set ConFac=$P(^CT("CTCF",ConFacDr),"^",3)
	....Else  set ConFac=1	
	....set Price=$fn(Price*ConFac,"",6)		;4--->6	
	....set OrderAmt=$p($g(^DHCPB(AdmBill,"O",PBO)),"^",8)
	....set ArcimDesc=$p($g(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1)),"^",2) ;名称	
	....set Qty=$p($g(^DHCPB(AdmBill,"O",PBO)),"^",5)
	....set RefundQty=$p($g(^DHCPB(AdmBill,"O",PBO)),"^",6)
	....set Qty=Qty-RefundQty
	....set Qty=Qty/ConFac
	....set OEPrice=$p($g(^OEORD(+PBord,"I",$p(PBord,"||",2),3)),"^",25)		;;取出P   价格 OE_OrdItem->OEORI_Price
	....set PackQty=$p($g(^OEORD(+PBord,"I",$p(PBord,"||",2),9)),"^",4)
	....b ;kkkk
	....set PackUOM=""
	....if PackUOMRowid'=""  Do
	.....set PackUOM=$p(^CT("UOM",PackUOMRowid),"^",2)	
	....set OEOrdItemObj=##class(DHCExternalService.BillInterface.DHCEntity.OEOrdItem).%New()
    ....set OEOrdItemObj.ArcmiDesc=ArcimDesc
 	....set OEOrdItemObj.Price=$j(Price,3,2)
 	....set OEOrdItemObj.DiscAmount="" 
 	....set OEOrdItemObj.Qty=Qty
 	....set OEOrdItemObj.PatientShareAmt="" 
 	....set OEOrdItemObj.PayorShareAmt=" "
 	....set OEOrdItemObj.TotalAmount=OrderAmt
 	....set OEOrdItemObj.UOM=PackUOM 
 	....do AccListDetailObj.OEOrdItems.Insert(OEOrdItemObj)	
 	....do OEOrdItemObj.%Close()
	..set myIdx=+myIdx+1
	..Do PayRecordObj.PayListInfo.Insert(AccListDetailObj)
	..Do AccListDetailObj.%Close()
	b ;08
	i myIdx=0  {	
		set PayRecordObj.ResultCode=0
		set PayRecordObj.ResultContent="没有查询到您半月内的消费记录!"	   
		Do PayRecordObj.XMLExportToString(.OutputXML,"Response")
		Do PayRecordObj.%Close()	
	}
	else{
		set PayRecordObj.ResultCode=0
		set PayRecordObj.ResultContent="查询成功"	   
		Do PayRecordObj.XMLExportToString(.OutputXML,"Response")
		b ;kkkkk678
		Do PayRecordObj.%Close()			
		}

	q OutputXML
GetCompletedPayWithDetailET
	set OutputXML=""
	set OutputObj=##class(DHCExternalService.BillInterface.DHCEntity.PayList).%New()
	set OutputObj.ResultCode=-10
	set OutputObj.ResultContent="程序处理错误:"_$ZERROR
	Do OutputObj.XMLExportToString(.OutputXML,"Response")
	quit OutputXML
}

/// w ##class(DHCExternalService.BillInterface.Service.DHCOPBillPayExp).GetIPPatAdmInfo("<Request><TradeCode></TradeCode><PatientCard>000000288043</PatientCard><PatientID></PatientID></Request>")
ClassMethod GetIPPatAdmInfo(Input As %String) As %GlobalCharacterStream
{
	set $ZT="GetIPPatientInfoET"
	new (Input)
	set ^TMP("GetIPPatientInfoRtkkk")=Input
	set InputObj=##class(DHCExternalService.BillInterface.DHCEntity.IPPatientInfoRequest).%New()
    do InputObj.XMLNodeDeserialize(.InputObj,"Request",Input)    
    set TerminalID=InputObj.TerminalID
    set HospitalId=InputObj.HospitalId
    set ExtUserID=InputObj.ExtUserID
    set CardNo=InputObj.PatientCard
    set CardType=InputObj.CardType
    set PatNo=InputObj.PatientID
    set SecrityNo=InputObj.SecrityNo
    set CardNo=$tr(CardNo,$c(0),"")
  	set OutputXML=""
  	b ;00
  	set OutputObj=##class(DHCExternalService.BillInterface.DHCEntity.IPPatientInfoResponse).%New()
    if ((CardNo="")&&(PatNo="")){
	   Set OutputObj.ResultCode=-1
	   Set OutputObj.ResultContent="卡号登记号都为空"
	   Set OutputXML=""
	   Do OutputObj.XMLExportToString(.OutputXML,"Response")
	   Do OutputObj.%Close()
	}
	Quit:((CardNo="")&&(PatNo="")) OutputXML
	b ;kkkkk789678
    set BaseInfo=##class(DHCExternalService.BillInterface.Service.DHCOPBillPayLogic).GetPatCommInfoByCardNo(CardNo,PatNo)
    set AdmID=$p(BaseInfo,"^",2)
    Set OutputObj.AdmID=AdmID
    Set OutputObj.PatientID=$p(BaseInfo,"^",3)
    Set OutputObj.PatientName=$p(BaseInfo,"^",4)
    Set OutputObj.SexCode=$p(BaseInfo,"^",5)
    Set OutputObj.Sex=$p(BaseInfo,"^",6)
    Set OutputObj.DOB=$p(BaseInfo,"^",7)
    Set OutputObj.MRID=$p(BaseInfo,"^",8)
    Set OutputObj.Address=$p(BaseInfo,"^",9)
    Set OutputObj.IDTypeCode=$p(BaseInfo,"^",10)
    Set OutputObj.IDType=$p(BaseInfo,"^",11)
    Set OutputObj.IDNo=$p(BaseInfo,"^",12)
    Set OutputObj.PatType=$p(BaseInfo,"^",13)   
    set OutputObj.InDays=$p(BaseInfo,"^",19)
    set OutputObj.BedNo=$p(BaseInfo,"^",22)
    set OutputObj.ChargeDoctorId=$p(BaseInfo,"^",23)
    set OutputObj.ChargeDoctorName=$p(BaseInfo,"^",24)
    set OutputObj.ChargeNurseId=$p(BaseInfo,"^",25)
    set OutputObj.ChargeNurseName=$p(BaseInfo,"^",26)
    set OutputObj.ConnectPhone=$p(BaseInfo,"^",27)
    set OutputObj.DeptId=$p(BaseInfo,"^",20)
    set OutputObj.DiscChargeDate=$p(BaseInfo,"^",28)
    set OutputObj.HospitalId=$p(BaseInfo,"^",29)
    set OutputObj.MedcareNo=$p(BaseInfo,"^",8)
    set OutputObj.PatVisutus=$p(BaseInfo,"^",22)
    set OutputObj.PrepayAmout=$p(BaseInfo,"^",23)*100
    set OutputObj.RelatePerson=""
    set OutputObj.RelatePhone=""
    set OutputObj.Relation=""
    set OutputObj.Remark=""
    set OutputObj.Settled=""
    set OutputObj.TotalAmout=$p(BaseInfo,"^",24)*100   
    Set OutputObj.AdmDate=$p(BaseInfo,"^",15)
    Set OutputObj.AdmLoc=$p(BaseInfo,"^",16)
    Set OutputObj.DepositAmount=$p(BaseInfo,"^",17)*100
    If (AdmID'=""){
		Set OutputObj.ResultCode=0
		Set OutputObj.ResultContent="获取就诊记录成功"    
	}Else{
		Set OutputObj.ResultCode=-3
		Set OutputObj.ResultContent="此病人不在院."	
	}
	Do OutputObj.XMLExportToString(.OutputXML,"Response") 
 	Do OutputObj.%Close()
	Quit OutputXML
	;
GetIPPatientInfoET
	Set OutputObj=##class(DHCExternalService.BillInterface.DHCEntity.IPPatientInfoResponse).%New()
	Set OutputObj.ResultCode=-10
	Set OutputObj.ResultContent="程序处理错误:"_$ZERROR
	Do OutputObj.XMLExportToString(.OutputXML,"Response")
	Quit OutputXML
}

/// w ##class(DHCExternalService.BillInterface.Service.DHCOPBillPayExp).operationCheck(^Lid("Input"))
ClassMethod operationCheck(Input As %String) As %String [ WebMethod ]
{
	Set $ZT="operationCheckET"
	New (Input)
	set ^TMP("AddIPPatDepositRtcheck")=Input      
    Set Adm=$p($p(Input,"<inpatientId>",2),"</inpatientId>",1)
    b ;kkkk
    if (Adm=""){	   
	   Set OutputXML="<res><resultCode>-1</resultCode><resultDesc>缺少必须入参</resultDesc><remark></remark></res>"
    }
    q:Adm="" OutputXML
    ;if PatNo'=""  d
  	;.set BaseInfo=##class(DHCExternalService.BillInterface.Service.DHCOPBillPayLogic).GetPatCommInfoByCardNo(CardNo,PatNo)
    ;.set Adm=$p(BaseInfo,"^",1)
    ;if (Adm=""){	   
	;   Set OutputXML="<res><resultCode>-1</resultCode><resultDesc>不可充值</resultDesc><remark><description></res>"
    ;}
    q:Adm="" OutputXML
	Set OutputXML="<res><resultCode>0</resultCode><resultDesc>成功</resultDesc><remark></remark></res>"
	
	q OutputXML
operationCheckET
	s OutputXML="<res><resultCode>-1</resultCode><resultDesc>调用异常</resultDesc><remark><description></res>"
	Quit OutputXML
}

/// w ##class(DHCExternalService.BillInterface.Service.DHCOPBillPayExp).AddIPDeposit("<Request><TradeCode></TradeCode><TerminalID></TerminalID><HospitalId></HospitalId><ExtUserID>wx001</ExtUserID><PatientCard></PatientCard><CardTypeCode></CardTypeCode><PatientID></PatientID><Adm>729126</Adm><Amount>100</Amount><PayModeCode>CARDCPP</PayModeCode><TransactionId>2153654</TransactionId><BankCode></BankCode><BankAccDate>20160323</BankAccDate><BankTransactionId>14435</BankTransactionId><BankCardNo></BankCardNo></Request>")
ClassMethod AddIPDeposit(Input As %String) As %GlobalCharacterStream
{
	Set $ZT="AddIPDepositET"
	New (Input)
	set ^TMP("AddIPPatDepositRt")=Input
	Set InputObj=##class(DHCExternalService.BillInterface.DHCEntity.IPAddDepositRequest).%New()
    Do InputObj.XMLNodeDeserialize(.InputObj,"Request",Input)
    Set TradeCode=InputObj.TradeCode ;交易代码
    Set TerminalID=InputObj.TerminalID ;终端编码
    Set HospitalId=InputObj.HospitalId ;医院唯一编号
    Set ExtUserID=InputObj.ExtUserID ;操作员Code
    Set PatientCard=InputObj.PatientCard ;卡号
    Set CardTypeCode=InputObj.CardTypeCode ;卡类型    
    Set PatNo=InputObj.PatientID ;患者ID
    Set Adm=InputObj.Adm ;就诊号
    Set Amount=InputObj.Amount ;充值金额
    Set PayModeCode=InputObj.PayModeCode ;支付方式
    Set TransactionId=InputObj.TransactionId ;交易流水号
    set UserCode=InputObj.ExtUserID
    Set BankCode=InputObj.BankCode ;交易银行
  	Set BankAccDate=InputObj.BankAccDate ;银行交易日期
    Set BankTransactionId=InputObj.BankTransactionId ;银行交易流水号
    Set BankCardNo=InputObj.BankCardNo ;银行卡号
   	set Amount=Amount/100
  	Set OutputXML=""
  	
  	set Adm=$tr(Adm,$c(0),"")
  	if (Adm="")&&(PatNo'="")  d
  	.set BaseInfo=##class(DHCExternalService.BillInterface.Service.DHCOPBillPayLogic).GetPatCommInfoByCardNo(CardNo,PatNo)
    .set AdmID=$p(BaseInfo,"^",1)
    .s visitstatus=$p(^PAADM(Adm),"^",20)
    .i visitstatus'="A" s Adm="" 
  	Set OutputObj=##class(DHCExternalService.BillInterface.DHCEntity.IPAddDepositResponse).%New()
    if (Adm=""){
	   Set OutputObj.ResultCode=-1
	   Set OutputObj.ResultContent="没有就诊记录"
	   Set OutputXML=""
	   Do OutputObj.XMLExportToString(.OutputXML,"Response")
	   Do OutputObj.%Close()
	}
	Quit:Adm="" OutputXML
	;转换成his字段
	Set UserId="",Gloc="",Grup=""
	Set:ExtUserID'="" UserCode=$$ALPHAUP^SSUTIL4(ExtUserID)
	Set:UserCode'="" UserId=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,""))
	Set:UserId'="" Gloc=$p($g(^SSU("SSUSR",UserId)),"^",4)	;SSUSR_DefaultDept
	Set:UserId'="" Grup=$p($g(^SSU("SSUSR",UserId)),"^",5)	;SSUSR_Group
	b ;
	Set RcptInfo=##class(DHCExternalService.BillInterface.Service.DHCOPBillPayLogic).GetRcptNo("","",UserId,"住院押金")
	b ;009
	Set Curno=$p(RcptInfo,"^",3)
	Set Endno=$p(RcptInfo,"^",2)	
	Set Title=$p(RcptInfo,"^",4)
	Set RcptRowid=$p(RcptInfo,"^",1)
	Set Paymode=##class(DHCExternalService.RegInterface.GetRelate).GetHisPayModeID(PayModeCode) 
	b ;kkkkk
	Set Bank=""
    ;拼串
    Set mydeptype="1"
    Set mypayamt=Amount
    Set mypaymode=Paymode
    Set mycompany=""
    Set mybank=Bank ;需转换
    Set mycardno=BankCardNo
    Set myauthno=BankCardNo
    Set myadm=Adm
    Set mycurno=Curno
    Set mygloc=Gloc
    Set myuserid=UserId
    Set myendno=Endno
    Set mytitle=Title
    Set mybanksub=""
    Set mycomment=""
    Set mypassword=""
    Set myrcptrowid=RcptRowid
    Set dep=mydeptype_"^"_mypayamt_"^"_mypaymode_"^"_mycompany_"^"_mybank_"^"_mycardno_"^"_myauthno
    Set dep=dep_"^"_myadm_"^"_mycurno_"^"_mygloc_"^"_myuserid_"^"_myendno_"^"_mytitle_"^"_mybanksub
    Set dep=dep_"^"_mycomment_"^"_mypassword_"^"_myrcptrowid
    Set BankRequset=TradeCode_"^"_TerminalID_"^"_HospitalId_"^"_myuserid_"^"_PatientCard_"^"_CardTypeCode
    Set BankRequset=BankRequset_"^"_Adm_"^"_Amount_"^"_Paymode_"^"_TransactionId_"^"_BankCode
    Set BankRequset=BankRequset_"^"_BankAccDate_"^"_BankTransactionId_"^"_BankCardNo_"^"_"C"_"^"_""
    ;
    Set DepositInfo=##class(DHCExternalService.BillInterface.Service.DHCOPBillPayLogic).InsertDeposit(dep,BankRequset) ;交押金
    set ResultFlag=$p(DepositInfo,"^",1) ;判断返回值
    b ;DepositInfo
    If (ResultFlag=0){
		Set Prtrowid=$p(DepositInfo,"^",2)
		Set Patfee=##class(web.UDHCJFCKD).totalamount(myadm) 
		Set Deposit=##class(web.UDHCJFCKD).deposit(myadm) 
		Set Remain=Deposit-Patfee
		Set Prtno=$p($p(^DHCSFPRINTDETAIL(Prtrowid),"^",1),$c(1))
		set ^ChargeCheck(+$h,BankTransactionId)=0_"^"_Prtrowid
	    Set OutputObj.DepositAmount=Remain
	    Set OutputObj.InvoiceNo=Prtno
		Set OutputObj.ResultCode=0
		Set OutputObj.ResultContent="交押金成功"    
	}Else{
		set ^ChargeCheck(+$h,BankTransactionId)=ResultFlag
		Set OutputObj.ResultCode=ResultFlag
		Set OutputObj.ResultContent="交押金失败:"_ResultFlag
	}
	Do OutputObj.XMLExportToString(.OutputXML,"Response") 
 	Do OutputObj.%Close()
	Quit OutputXML
	;
AddIPDepositET
	Set OutputObj=##class(DHCExternalService.BillInterface.DHCEntity.IPAddDepositResponse).%New()
	Set OutputObj.ResultCode=-10
	Set OutputObj.ResultContent="程序处理错误:"_$ZERROR
	Do OutputObj.XMLExportToString(.OutputXML,"Response")
	Quit OutputXML
}

ClassMethod CheckIPDeposit(Input As %String) As %GlobalCharacterStream
{
	
	Set $ZT="CheckIPDepositET"
	New (Input)
	
	Set InputObj=##class(DHCExternalService.BillInterface.DHCEntity.IPAddDepositRequest).%New()
    Do InputObj.XMLNodeDeserialize(.InputObj,"Request",Input) 
    Set BankTradeNo=InputObj.BankTransactionId ;银行交易流水号
    if (BankTradeNo=""){
	   set OutputObj.ResultCode=-1
	   set OutputObj.ResultContent="查证流水号为空"
	   set OutputXML=""
	   Do OutputObj.XMLExportToString(.OutputXML,"Response")
	   Do OutputObj.%Close()
	}
	quit:(BankTradeNo) OutputXML
   	s CheckInfo=$g(^ChargeCheck(+$h,BankTradeNo))
   	;set OutputObj=##class(DHCExternalService.BillInterface.DHCEntity.AutoPayChargeResult).%New()
	Set OutputObj=##class(DHCExternalService.BillInterface.DHCEntity.IPAddDepositResponse).%New()
   	if (+CheckInfo=0){
	   	set OutputObj.ResultCode=0
	   	set OutputObj.ResultContent="充值成功"
	   	set OutputObj.InvoiceNo=$p(CheckInfo,"^",2)
   	}
   	else{
	   	set OutputObj.ResultCode="-1"
	   	set OutputObj.ResultContent="充值失败"
	   	}
	Do OutputObj.XMLExportToString(.OutputXML,"Response") 
 	Do OutputObj.%Close()
	Quit OutputXML
	;
CheckIPDepositET
	Set OutputObj=##class(DHCExternalService.BillInterface.DHCEntity.IPAddDepositResponse).%New()
	Set OutputObj.ResultCode=-10
	Set OutputObj.ResultContent="程序处理错误:"_$ZERROR
	Do OutputObj.XMLExportToString(.OutputXML,"Response")
	Quit OutputXML
}

/// Creator:Lid
/// CreatDate:2013-09-10
/// Desc:住院押金记录查询
/// Input:<Request><TradeCode></TradeCode><InvPrtRowIDStr></InvPrtRowIDStr><UserCode></UserCode><AccMRowID></AccMRowID><PapmiRowid></PapmiRowid><ExpStr></ExpStr></Request>
/// Return:
/// Debug:w ##class(DHCExternalService.BillInterface.Service.DHCOPBillPayExp).GetDepPayRecord("<Request><TradeCode></TradeCode><TerminalID></TerminalID><HospitalId></HospitalId><ExtUserID>wx001</ExtUserID><PatientCard></PatientCard><CardTypeCode></CardTypeCode><PatientID></PatientID><Adm>729126</Adm><Amount>100</Amount><PayModeCode>CARDCPP</PayModeCode><TransactionId>2153654</TransactionId><BankCode></BankCode><BankAccDate>20160323</BankAccDate><BankTransactionId>14435</BankTransactionId><BankCardNo></BankCardNo></Request>")
ClassMethod GetDepPayRecord(Input As %String) As %GlobalCharacterStream [ WebMethod ]
{
	Set $ZT="GetDepPayRecordET"
	New (Input)
	set ^TMP("AddIPPatDepositRtllog")=Input
	Set InputObj=##class(DHCExternalService.BillInterface.DHCEntity.IPAddDepositRequest).%New()
    Do InputObj.XMLNodeDeserialize(.InputObj,"Request",Input)
      
    Set PatNo=InputObj.PatientID ;患者ID
    Set Adm=InputObj.Adm ;就诊号
    if (Adm=""){
	   Set OutputObj.ResultCode=-1
	   Set OutputObj.ResultContent="没有就诊记录"
	   Set OutputXML=""
	   Do OutputObj.XMLExportToString(.OutputXML,"Response")
	   Do OutputObj.%Close()
	}
	Quit:Adm="" OutputXML
	set DepNum=0
    set OutputObj=##class(DHCExternalService.BillInterface.DHCEntity.DepRecord).%New()
    set DepRowid=""  f  s DepRowid=$o(^DHCSFPRINTDETAIL(0,"adm",Adm,DepRowid)) q:DepRowid=""  d
    .set ListObj=##class(DHCExternalService.BillInterface.DHCEntity.RecordInfo).%New()
    .set PayDate=$zd($p(^DHCSFPRINTDETAIL(DepRowid),"^",2),3)_" "_$zt($p(^DHCSFPRINTDETAIL(DepRowid),"^",3),1)
    .set PayAmout=$p(^DHCSFPRINTDETAIL(DepRowid),"^",6)
    .set PayMode=$p(^DHCSFPRINTDETAIL(DepRowid),"^",9)
    .set Depositdr=$p(^DHCSFPRINTDETAIL(DepRowid),"^",13)
    .set:PayMode'="" PayMode=$p(^CT("CTPM",PayMode),"^",2)
    .set ListObj.PayTime=PayDate
    .set ListObj.PayAmout=PayAmout*100
    .set ListObj.PayFlag=Depositdr
    .set ListObj.PayMode=PayMode
    .set ListObj.Remark=" "
    .set DepNum=DepNum+1
    .do OutputObj.RecordInfo.Insert(ListObj)
    .do ListObj.%Close()
    
    i DepNum=0 d
    .s OutputObj.ResultCode=0
    .s OutputObj.ResultContent="未交过住院押金"
    e  d
    .s OutputObj.ResultCode=0
    .s OutputObj.ResultContent="查询成功"
    Do OutputObj.XMLExportToString(.OutputXML,"Response")
    
	Quit OutputXML  
    
GetDepPayRecordET
	Set OutputObj=##class(DHCExternalService.BillInterface.DHCEntity.IPAddDepositResponse).%New()
	Set OutputObj.ResultCode=-10
	Set OutputObj.ResultContent="程序处理错误:"_$ZERROR
	Do OutputObj.XMLExportToString(.OutputXML,"Response")
	Quit OutputXML
}

/// 住院日清明细
/// w ##class(DHCExternalService.BillInterface.Service.DHCOPBillPayExp).GetIPDailyBill("<Request><TradeCode></TradeCode><Adm>723518</Adm><BillDate>2016-04-09</BillDate></Request>")
ClassMethod GetIPDailyBill(Input As %String) As %GlobalCharacterStream [ WebMethod ]
{
	Set $ZT="GetIPDailyBillET"
	New (Input)
	set ^TMP("AddIPPatDepositRtIPdaiyl")=Input
	Set InputObj=##class(DHCExternalService.BillInterface.DHCEntity.IPAddDepositRequest).%New()
    Do InputObj.XMLNodeDeserialize(.InputObj,"Request",Input)      
    Set PatNo=InputObj.PatientID ;患者ID
    Set Adm=InputObj.Adm ;就诊号  
    set BillDate=InputObj.BillDate
    set BillDate=$zdh(BillDate,3)
    set OutputObj=##class(DHCExternalService.BillInterface.DHCEntity.IPCostInfo).%New()
    set BaseInfo=""
    if (Adm="")&&(PatNo'="")  d
  	.set BaseInfo=##class(DHCExternalService.BillInterface.Service.DHCOPBillPayLogic).GetPatCommInfoByCardNo(CardNo,PatNo)
    .set Adm=$p(BaseInfo,"^",1)
    
    if (Adm=""){
	   Set OutputObj.ResultCode=-1
	   Set OutputObj.ResultContent="没有就诊记录"
	   Set OutputXML=""
	   Do OutputObj.XMLExportToString(.OutputXML,"Response")
	   Do OutputObj.%Close()
	}
	Quit:Adm="" OutputXML
	
	set DepCount=0
	set DepPaid=0
	set IPAmount=0
	set BillAmount=0
	set PaidAmount=0
	set DailyBill=0
    set OutputObj=##class(DHCExternalService.BillInterface.DHCEntity.IPCostInfo).%New()
    set DepRowid=""  f  s DepRowid=$o(^DHCSFPRINTDETAIL(0,"adm",Adm,DepRowid)) q:DepRowid=""  d
    .set PayDate=$zd($p(^DHCSFPRINTDETAIL(DepRowid),"^",2),3)_" "_$zt($p(^DHCSFPRINTDETAIL(DepRowid),"^",3),1)
    .set PayAmout=$p(^DHCSFPRINTDETAIL(DepRowid),"^",6)
    .set PayMode=$p(^DHCSFPRINTDETAIL(DepRowid),"^",9)
    .set Depositdr=$p(^DHCSFPRINTDETAIL(DepRowid),"^",13)
    .set DepCount=DepCount+PayAmout
    .set:Depositdr="" DepPaid=DepPaid+PayAmout

	 set AdmBill=""  f  s AdmBill=$o(^DHCPB(0,"ADM",Adm,AdmBill))  q:AdmBill=""  d 
	.i $d(^DHCPB(AdmBill))  d
	..s bill=$p(^DHCPB(AdmBill),"^",16)
	..s IPAmount=IPAmount+$p(^DHCPB(AdmBill),"^",8) 
	..s:bill'="P" BillAmount=BillAmount+$p(^DHCPB(AdmBill),"^",8)	
	..s:bill="P" PaidAmount=PaidAmount+$p(^DHCPB(AdmBill),"^",8)	
	..Quit:bill="P"
	..set PBO="0"
	..For  set PBO=$o(^DHCPB(AdmBill,"O",PBO))  quit:PBO=""  Do
	...quit:('$D(^DHCPB(AdmBill,"O",PBO)))||($d(^DHCPB(AdmBill,"O",PBO))=10)
	...set PBord=$p($g(^DHCPB(AdmBill,"O",PBO)),"^",4)
	...s prtordflag="N"
	...set PBOBillQty=+$p($g(^DHCPB(AdmBill,"O",PBO)),"^",5)
	...set PBORefundQty=+$p($g(^DHCPB(AdmBill,"O",PBO)),"^",6)
	...set PBOQty=PBOBillQty+PBORefundQty
	...set PBOUnitPrice=+$p($g(^DHCPB(AdmBill,"O",PBO)),"^",7)
	...set PBOPatShare=+$p($g(^DHCPB(AdmBill,"O",PBO)),"^",11)	
	...Quit:PBord=""
	...Quit:'$d(^OEORD($p(PBord,"||",1),"I",$p(PBord,"||",2)))
	...;取收费项目明细
	...Set itm=0 
	...For  Set itm=$o(^DHCPB(+AdmBill,"O",PBO,"D",itm)) Quit:(itm="")!(prtordflag="Y")  Set s=^(itm) Do   ;收费项目明细
	....Set itmrowid=AdmBill_"||"_PBO_"||"_itm
	....Set billdate=$p(s,"^",11),billtime=$p(s,"^",12),billstatus=$p(s,"^",14)  ;yyx 06-12-07
	....Quit:(BillDate'="")&&(billdate'=BillDate)
	....Set taritm=$p(s,"^",3)
	....Set tariDesc=$p(^DHCTARI(taritm),"^",2)
  	....Set tariChargeBasis=$p(^DHCTARI(taritm),"^",20)     ;取物价编码
  	....Set tarinpat=$p(^DHCTARI(taritm),"^",14)
	....If tarinpat'=""  Do
	.....Set taric=$p(^DHCTarC("IC",tarinpat),"^",3)  ;收费项目住院分类
	.....Set taricDesc=$p(^DHCTarC("TIC",taric),"^",2)	;住院大类
	.....set taricCode=$p(^DHCTarC("TIC",taric),"^",1)
	....Set arcimid=$p($g(^DHCPB(AdmBill,"O",PBO)),"^",3)
	....Set itemcat=$p(^ARCIM(+arcimid,$p(arcimid,"||",2),1),"^",10)
   	....Set billdate=$p(s,"^",11)
   	....Set billtime=$p(s,"^",12)
    ....Set qty=$p(s,"^",5)     ;pbd_billqty
    ....Set price=$j($p(s,"^",4),3,4)   ;pbd_unitprice
    ....Set total=$p(s,"^",7)    ;pbd_totalamount
    ....set DailyBill=DailyBill+total
    ....Quit:+total=0
   	....set ^IPBillTotal(Adm,taric)=+$g(^IPBillTotal(Adm,taric))+total 	
   	b ;kkkk
   	s sub=""  f   s sub=$o(^IPBillTotal(Adm,sub)) q:sub=""  d   	
    .Set TarItemDetailObj=##class(DHCExternalService.BillInterface.DHCEntity.TarOCCateItem).%New()
    .set tardesc=$p(^DHCTarC("TIC",sub),"^",2)
    .set tarcode=$p(^DHCTarC("TIC",sub),"^",1)
    .Set TarItemDetailObj.TarOCCateCode=tarcode
    .Set TarItemDetailObj.TarOCCateDesc=tardesc
    .Set TarItemDetailObj.TarOCCateAmt=+$g(^IPBillTotal(Adm,sub))   
    .Do OutputObj.feeInfo.Insert(TarItemDetailObj)
    .Do TarItemDetailObj.%Close()	
	
	set OutputObj.ResultCode=0
	set OutputObj.ResultContent="成功"
	set OutputObj.totalAmout=IPAmount*100
	set OutputObj.prepayAmout=DepCount*100
	set OutputObj.unsettled=BillAmount*100   
    set OutputObj.settled=PaidAmount*100 
	set OutputObj.balance=$p(BaseInfo,"^",17)*100
	set OutputObj.billAmout=DailyBill*100
    Do OutputObj.XMLExportToString(.OutputXML,"Response")
    
	Quit OutputXML  
    
GetIPDailyBillET
	Set OutputObj=##class(DHCExternalService.BillInterface.DHCEntity.IPAddDepositResponse).%New()
	Set OutputObj.ResultCode=-10
	Set OutputObj.ResultContent="程序处理错误:"_$ZERROR
	Do OutputObj.XMLExportToString(.OutputXML,"Response")
	Quit OutputXML
}

/// 住院汇总费用
/// w ##class(DHCExternalService.BillInterface.Service.DHCOPBillPayExp).GetIPTotalCost("<Request><TradeCode></TradeCode><Adm>723518</Adm></Request>")
ClassMethod GetIPTotalCost(Input As %String) As %GlobalCharacterStream [ WebMethod ]
{
	Set $ZT="GetIPTotalCostET"
	New (Input)
	set ^TMP("AddIPPatDepositRt")=Input
	Set InputObj=##class(DHCExternalService.BillInterface.DHCEntity.IPAddDepositRequest).%New()
    Do InputObj.XMLNodeDeserialize(.InputObj,"Request",Input)
    set OutputXML="" 
    Set PatNo=InputObj.PatientID ;患者ID
    Set Adm=InputObj.Adm ;就诊号
    set DepCount=0
	set DepPaid=0
	set IPAmount=0
	set BillAmount=0
    ;i Adm'="" d 
    ;.;s IPAmount=##class(web.UDHCJFCKD).totalamount(Adm) 
	;.s DepCount=##class(web.UDHCJFCKD).deposit(Adm) 
    b ;bk
    if (Adm="")&&(PatNo'="")  d
  	.set BaseInfo=##class(DHCExternalService.BillInterface.Service.DHCOPBillPayLogic).GetPatCommInfoByCardNo(CardNo,PatNo)
    .set Adm=$p(BaseInfo,"^",1)
    .s visitstatus=$p(^PAADM(Adm),"^",20)	
    
    if (Adm=""){
	   Set OutputObj.ResultCode=-1
	   Set OutputObj.ResultContent="没有就诊记录"
	   Do OutputObj.XMLExportToString(.OutputXML,"Response")
	   Do OutputObj.%Close()
	}
	Quit:Adm="" OutputXML
	k ^IPBillTotal(Adm)
	
    set OutputObj=##class(DHCExternalService.BillInterface.DHCEntity.IPCostInfo).%New()
    set DepRowid=""  f  s DepRowid=$o(^DHCSFPRINTDETAIL(0,"adm",Adm,DepRowid)) q:DepRowid=""  d
    .set PayDate=$zd($p(^DHCSFPRINTDETAIL(DepRowid),"^",2),3)_" "_$zt($p(^DHCSFPRINTDETAIL(DepRowid),"^",3),1)
    .set PayAmout=$p(^DHCSFPRINTDETAIL(DepRowid),"^",6)
    .set PayMode=$p(^DHCSFPRINTDETAIL(DepRowid),"^",9)
    .set Depositdr=$p(^DHCSFPRINTDETAIL(DepRowid),"^",13)
    .set DepCount=DepCount+PayAmout
    .set:Depositdr="" DepPaid=DepPaid+PayAmout
    set billRowid=""  f  s billRowid=$o(^DHCPB(0,"ADM",Adm,billRowid))  q:billRowid=""  d 
	.b ;jkdjfkd
	.i $d(^DHCPB(billRowid))  d
	..s bill=$p(^DHCPB(billRowid),"^",16)
	..s IPAmount=IPAmount+$p(^DHCPB(billRowid),"^",8) 
	..s:bill'="P" BillAmount=BillAmount+$p(^DHCPB(billRowid),"^",8)
	..set PBO="0"
	..For  set PBO=$o(^DHCPB(billRowid,"O",PBO))  quit:PBO=""  Do
	...quit:('$D(^DHCPB(billRowid,"O",PBO)))||($d(^DHCPB(billRowid,"O",PBO))=10)
	...Set prtordflag="N"
	...set PBord=$p($g(^DHCPB(billRowid,"O",PBO)),"^",4)
	...set PBOBillQty=+$p($g(^DHCPB(billRowid,"O",PBO)),"^",5)
	...set PBORefundQty=+$p($g(^DHCPB(billRowid,"O",PBO)),"^",6)
	...set PBOQty=PBOBillQty+PBORefundQty
	...set PBOUnitPrice=+$p($g(^DHCPB(billRowid,"O",PBO)),"^",7)
	...set PBOPatShare=+$p($g(^DHCPB(billRowid,"O",PBO)),"^",11)	
	...Quit:PBord=""
	...Quit:'$d(^OEORD($p(PBord,"||",1),"I",$p(PBord,"||",2)))
	...;取收费项目明细
	...Set itm=0 
	...For  Set itm=$o(^DHCPB(+billRowid,"O",PBO,"D",itm)) Quit:(itm="")!(prtordflag="Y")  Set s=^(itm) Do   ;收费项目明细
	....Set itmrowid=billRowid_"||"_PBO_"||"_itm
	....Set billdate=$p(s,"^",11),billtime=$p(s,"^",12),billstatus=$p(s,"^",14)  ;yyx 06-12-07
	....;Quit:(billdate<StartDate)!(billdate>EndDate)
	....Set taritm=$p(s,"^",3)
	....Set tariDesc=$p(^DHCTARI(taritm),"^",2)
  	....Set tariChargeBasis=$p(^DHCTARI(taritm),"^",20)     ;取物价编码
  	....Set tarinpat=$p(^DHCTARI(taritm),"^",14)
	....If tarinpat'=""  Do
	.....Set taric=$p(^DHCTarC("IC",tarinpat),"^",3)  ;收费项目住院分类
	.....Set taricDesc=$p(^DHCTarC("TIC",taric),"^",2)	;住院大类
	.....set taricCode=$p(^DHCTarC("TIC",taric),"^",1)
	....Set arcimid=$p($g(^DHCPB(billRowid,"O",PBO)),"^",3)
	....Set itemcat=$p(^ARCIM(+arcimid,$p(arcimid,"||",2),1),"^",10)
   	....Set billdate=$p(s,"^",11)
   	....Set billtime=$p(s,"^",12)
    ....Set qty=$p(s,"^",5)     ;pbd_billqty
    ....Set price=$j($p(s,"^",4),3,4)   ;pbd_unitprice
    ....Set total=$p(s,"^",7)    ;pbd_totalamount
    ....Quit:+total=0
   	....set ^IPBillTotal(Adm,taric)=+$g(^IPBillTotal(Adm,taric))+total 	
   	b ;kkkk
   	s sub=""  f   s sub=$o(^IPBillTotal(Adm,sub)) q:sub=""  d   	
    .Set TarItemDetailObj=##class(DHCExternalService.BillInterface.DHCEntity.TarOCCateItem).%New()
    .set tardesc=$p(^DHCTarC("TIC",sub),"^",2)
    .set tarcode=$p(^DHCTarC("TIC",sub),"^",1)
    .Set TarItemDetailObj.TarOCCateCode=tarcode
    .Set TarItemDetailObj.TarOCCateDesc=tardesc
    .Set TarItemDetailObj.TarOCCateAmt=+$g(^IPBillTotal(Adm,sub))*100   
    .Do OutputObj.feeInfo.Insert(TarItemDetailObj)
    .Do TarItemDetailObj.%Close()	
	set OutputObj.ResultCode=0
	set OutputObj.ResultContent="成功"
	set OutputObj.totalAmout=IPAmount*100
	set OutputObj.prepayAmout=DepCount*100
	set OutputObj.unsettled=BillAmount*100
	set OutputObj.validPrepayAmout=DepPaid*100
    Do OutputObj.XMLExportToString(.OutputXML,"Response")
    s ^totalip=OutputXML
        
	Quit OutputXML  
    
GetIPTotalCostET
	Set OutputObj=##class(DHCExternalService.BillInterface.DHCEntity.IPAddDepositResponse).%New()
	Set OutputObj.ResultCode=-10
	Set OutputObj.ResultContent="程序处理错误:"_$ZERROR
	Do OutputObj.XMLExportToString(.OutputXML,"Response")
	Quit OutputXML
}

/// 住院费用分类明细查询  
/// w ##class(DHCExternalService.BillInterface.Service.DHCOPBillPayExp).GetIPDetailCost("<Request><TypeCode>检查费</TypeCode><Adm>723518</Adm></Request>")
ClassMethod GetIPDetailCost(Input As %String) As %GlobalCharacterStream [ WebMethod ]
{
	Set $ZT="GetIPDetailCostET"
	New (Input)
	set ^TMP("AddIPPatDepositRtdel")=Input
	Set InputObj=##class(DHCExternalService.BillInterface.DHCEntity.IPAddDepositRequest).%New()
    Do InputObj.XMLNodeDeserialize(.InputObj,"Request",Input)
    set OutStream=##class(%GlobalCharacterStream).%New()
    Set PatNo=InputObj.PatientID ;患者ID
    Set Adm=InputObj.Adm ;就诊号    
    set Type=InputObj.TypeCode
    set BillDate=InputObj.BillDate
    if (Adm="")&&(PatNo'="")  d
  	.set BaseInfo=##class(DHCExternalService.BillInterface.Service.DHCOPBillPayLogic).GetPatCommInfoByCardNo(CardNo,PatNo)
    .set Adm=$p(BaseInfo,"^",1)
    if (Adm=""){
	   Set OutputObj.ResultCode=-1
	   Set OutputObj.ResultContent="没有就诊记录"
	   Set OutputXML=""
	   Do OutputObj.XMLExportToString(.OutputXML,"Response")
	   Do OutputObj.%Close()
	   set sc=OutStream.Write(OutputXML)	
	}
	Quit:Adm="" OutStream
	k ^IPBillTotalDetail(Adm)
	s (IPAmount,BillAmount)=0
	set Index=0
	set OutputObj=##class(DHCExternalService.BillInterface.DHCEntity.PayDetail).%New()
	set AdmBill=""  f  s AdmBill=$o(^DHCPB(0,"ADM",Adm,AdmBill))  q:AdmBill=""  d 
	.i $d(^DHCPB(AdmBill))  d
	..s bill=$p(^DHCPB(AdmBill),"^",16)
	..s IPAmount=IPAmount+$p(^DHCPB(AdmBill),"^",8) 
	..s:bill'="P" BillAmount=BillAmount+$p(^DHCPB(AdmBill),"^",8)
	..set PBO="0"
	..For  set PBO=$o(^DHCPB(AdmBill,"O",PBO))  quit:PBO=""  Do
	...s prtordflag="N"
	...quit:('$D(^DHCPB(AdmBill,"O",PBO)))||($d(^DHCPB(AdmBill,"O",PBO))=10)
	...set PBord=$p($g(^DHCPB(AdmBill,"O",PBO)),"^",4)
	...set excid=$p($g(^DHCPB(AdmBill,"O",PBO)),"^",20)
	...set PBOBillQty=+$p($g(^DHCPB(AdmBill,"O",PBO)),"^",5)
	...set PBORefundQty=+$p($g(^DHCPB(AdmBill,"O",PBO)),"^",6)
	...set PBOQty=PBOBillQty+PBORefundQty
	...set PBOUnitPrice=+$p($g(^DHCPB(AdmBill,"O",PBO)),"^",7)
	...set PBOPatShare=+$p($g(^DHCPB(AdmBill,"O",PBO)),"^",11)	
	...Quit:PBord=""
	...Quit:'$d(^OEORD($p(PBord,"||",1),"I",$p(PBord,"||",2)))
	...Set arcimid=$p($g(^DHCPB(AdmBill,"O",PBO)),"^",3)
	...;b ;kkk0
	...set ArcimDesc=$p($g(^ARCIM(+arcimid,1,1)),"^",2) ;名称	
	...;取收费项目明细
	...Set itm=0 
	...For  Set itm=$o(^DHCPB(+AdmBill,"O",PBO,"D",itm)) Quit:(itm="")!(prtordflag="Y")  Set s=^(itm) Do   ;收费项目明细
	....Set itmrowid=AdmBill_"||"_PBO_"||"_itm
	....Set billdate=$p(s,"^",11),billtime=$p(s,"^",12),billstatus=$p(s,"^",14)  ;yyx 06-12-07
	....Quit:(BillDate'="")&&(billdate'=BillDate)
	....set price=$p(s,"^",4)
	....set qty=$p(s,"^",5)
	....set amt=$p(s,"^",7)
	....q:amt=0
	....Set taritm=$p(s,"^",3)
	....Set tariDesc=$p(^DHCTARI(taritm),"^",2)
  	....Set tariChargeBasis=$p(^DHCTARI(taritm),"^",20)     ;取物价编码
  	....Set tarinpat=$p(^DHCTARI(taritm),"^",14)
	....q:tarinpat=""  
	....Set taric=$p(^DHCTarC("IC",tarinpat),"^",3)  ;收费项目住院分类
	....Set taricDesc=$p(^DHCTarC("TIC",taric),"^",2)	;住院大类
	....set taricCode=$p(^DHCTarC("TIC",taric),"^",1)
	....q:(Type'="")&&(Type=taricCode) 
	....i $d(^IPBillTotalDetailse(Adm,tariDesc)) d  
	......s $p(^IPBillTotalDetailse(Adm,tariDesc),"^",1)=$p(^IPBillTotalDetailse(Adm,tariDesc),"^",1)+qty
	......s $p(^IPBillTotalDetailse(Adm,tariDesc),"^",2)=$p(^IPBillTotalDetailse(Adm,tariDesc),"^",2)+amt
	....e  s ^IPBillTotalDetailse(Adm,tariDesc)=qty_"^"_amt_"^"_price_"^"_arcimid	
    ....s Index=Index+1
    
    s sub=""  f  s sub=$o(^IPBillTotalDetailse(Adm,sub)) q:sub=""  d
      
    .set ItemObj=##class(DHCExternalService.BillInterface.DHCEntity.OEOrdItem).%New()
    .set ItemObj.ArcmiDesc=sub
    .set ItemObj.OEOrdId=$p(^IPBillTotalDetailse(Adm,sub),"^",4)
    .set ItemObj.Price=$p(^IPBillTotalDetailse(Adm,sub),"^",3)
    .set ItemObj.Qty=$p(^IPBillTotalDetailse(Adm,sub),"^",1)
    .set ItemObj.TotalAmount=$p(^IPBillTotalDetailse(Adm,sub),"^",2)
    .do OutputObj.OEOrdItems.Insert(ItemObj)
    .do ItemObj.%Close()   
    
    
    if (Index=0){
	    s OutputObj.ResultCode=0
    	s OutputObj.ResultContent="明细为空"
    }
    else {
	    s OutputObj.ResultCode=0
	    s OutputObj.ResultContent="查询成功"
    }
    ;Do OutputObj.XMLExportToString(.OutputXML,"Response")
    Do OutputObj.XMLExportToStream(.OutStream,"Response")
    b ;0000
    
	Quit OutStream  
    
GetIPDetailCostET
	Set OutputObj=##class(DHCExternalService.BillInterface.DHCEntity.IPAddDepositResponse).%New()
	set OutStream=##class(%GlobalCharacterStream).%New()
	Set OutputObj.ResultCode=-10
	Set OutputObj.ResultContent="程序处理错误:"_$ZERROR
	;Do OutputObj.XMLExportToString(.OutputXML,"Response")
	Do OutputObj.XMLExportToStream(.OutStream,"Response")
	 
	Quit OutStream
}

/// 获取对账总账
ClassMethod GetBillTotalInfo(Input As %String) As %GlobalCharacterStream [ WebMethod ]
{
	Set $ZT="GetBillTotalInfoET"
	New (Input)
	set ^TMP("AddIPPatDepositRt")=Input
	Set InputObj=##class(DHCExternalService.BillInterface.DHCEntity.CheckChargeInput).%New()
    Do InputObj.XMLNodeDeserialize(.InputObj,"Request",Input)
      
    Set StDate=InputObj.StartDate 
    set EndDate=InputObj.EndDate
    set Paymode=InputObj.PayMode
    set HandCom=##class(DHCExternalService.BillInterface.Service.DHCOPBillPayLogic).GetPayModeHardComm("OP",Paymode)
    i StDate=""  s StDate=+$h
    i EndDate=""  s EndDate=+$h
    i StDate["-"  s StDate=$zdh(StDate,3)
    i EndDate["-"  s EndDate=$zdh(EndDate,3)
    i StDate["/"  s StDate=$zdh(StDate,4)
    i EndDate["/"  s EndDate=$zdh(EndDate,4)
	set DepNum=0
    set OutputObj=##class(DHCExternalService.BillInterface.DHCEntity.CheckChargeOutput).%New()
	set TotalAmt=0  
	f date=StDate:1:EndDate d
	.s time=""   f  s time=$o(^DHCINVPRTi(0,date,time))  q:(time="")!(HandCom'="1")  d  ;门诊金额	 
	..s IBPRowid=""  f  s IBPRowid=$o(^DHCINVBTPi(0,"HISDTIME",date,time,IBPRowid))  q:IBPRowid=""  d
	...s Amt=$p(^DHCINVBTP(IBPRowid),"^",1)
	...s TotalAmt=TotalAmt+Amt
	.s time1=""   f  s time=$o(^DHCINVALITPi(0,date,time1))  q:(time1="")!(HandCom'="2")  d  ;门诊金额	 
	..s IAPRowid=""  f  s IAPRowid=$o(^DHCINVALITPi(0,"HISDTIME",date,time1,IAPRowid))  q:IAPRowid=""  d
	...s Amt=$p(^DHCINVALITP(IAPRowid),"^",1)
	...s TotalAmt=TotalAmt+Amt
	.s IBPIPRowid="" f  s IBPIPRowid=$o(^DHCIPAutoDepBankData(0,"HISTradeDate",date,IBPIPRowid))  q:(IBPIPRowid="")   d  ;住院预交金
   	..s Amt=$p(^DHCIPAutoDepBankData(IBPIPRowid),"^",17)
	..s TotalAmt=TotalAmt+Amt
    set:StDate=EndDate TimeRange=$zd(StDate,3)
    set:(StDate'=EndDate) TimeRange=$zd(StDate,3)_"-"_$zd(EndDate,3)
    set OutputObj.PayDate=TimeRange
    set OutputObj.PayAmout=TotalAmt   
    Do OutputObj.XMLExportToString(.OutputXML,"Response")
    
	Quit OutputXML  
    
GetBillTotalInfoET
	Set OutputObj=##class(DHCExternalService.BillInterface.DHCEntity.CheckChargeOutput).%New()
	Set OutputObj.ResultCode=-10
	Set OutputObj.ResultContent="程序处理错误:"_$ZERROR
	Do OutputObj.XMLExportToString(.OutputXML,"Response")
	Quit OutputXML
}

ClassMethod GetBillDetails(myBill, myOrd)
{
	New (myBill,myOrd)
	quit:'$d(^DHCPB(myBill,"O",myOrd))
	set ArcimRowid=$p(^DHCPB(myBill,"O",myOrd),"^",3)
	set ItemCatDR=$p(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1),"^",10) ;ARC_ItmMast->ARCIM_ItemCat_DR
	set:ItemCatDR'="" CatDr=$p(^ARC("IC",ItemCatDR),"^",8)
	set OrderType=$P(^ARC("IC",ItemCatDR),"^",7)  ;ARC_ItemCat->ARCIC_OrderType
	;增加规格
	set myINCItmDR=""
	set myINCItmDR=$o(^INCI(0,"ARCIM_DR",+ArcimRowid, 0))
	set myINCRegu=""
	set:(myINCItmDR'="") myINCRegu=$p($g(^INCI(myINCItmDR,3)),"^",9)
	set myINCRegu=##class(web.UDHCOPINVPrtData12).GetDrugSpec(ArcimRowid)
	set DrugCommonDesc=##class(web.UDHCJFCOMMON).GetDrugCommonNameByArcimId(ArcimRowid)
	set ArcimDesc=$p($g(^ARCIM(+ArcimRowid,1,1)),"^",2) ;名称
	set:(DrugCommonDesc'="") ArcimDesc=DrugCommonDesc_myINCRegu
	set PackUOMRowid=$p($g(^ARCIM(+ArcimRowid,1,8)),"^",14) ;整包装单位
	;set OEPrice=$p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",25)		;;取出P   价格 OE_OrdItem->OEORI_Price
	set PackUOM=""
	if PackUOMRowid'=""  Do
	.set PackUOM=$p($g(^CT("UOM",PackUOMRowid)),"^",2)
	set Price=$p(^DHCPB(myBill,"O",myOrd),"^",7)	
	;get the factor calculate;
	set INCI=$o(^INCI(0,"ARCIM_DR",+ArcimRowid,""))		;INC_Itm->RowID
	if INCI'="" Do 
	.set INCIUOM=$p(^INCI(INCI,1),"^",10)   ;INC_Itm->INCI_CTUOM_DR
	.set ConFacDr=$o(^CT("CTCF",0,"UOM",PackUOMRowid,INCIUOM,""))
	.if ConFacDr="" set ConFac=1
	.Else  set ConFac=$P(^CT("CTCF",ConFacDr),"^",3)
	Else  set ConFac=1
	set PackQty=$p(^DHCPB(myBill,"O",myOrd),"^",5)
	set refundqty=$p(^DHCPB(myBill,"O",myOrd),"^",6)			;;OE_OrdItem->OEORI_RefundQty
	if refundqty="" Do
	.set refundqty=0
	set PackQty=+PackQty+refundqty
	set Price=$fn(Price*ConFac,"",4)
	;b	;;
	if (OrderType="R")&(PackQty="") set PackQty=1
	if ((OrderType="R")&(PackQty'="")) Do
	.set PackQty=PackQty/ConFac
	set OrdPatSum=$fn($p(^DHCPB(myBill,"O",myOrd),"^",11),"",2)
	set OrdTotSum=$fn($p(^DHCPB(myBill,"O",myOrd),"^",8),"",2)
	;
	set ^TMP("InvData",$j,"D")=$g(^TMP("InvData",$j,"D"))+1
	set Idx=$g(^TMP("InvData",$j,"D"))
	set ^TMP("InvData",$j,"D",Idx)=$e($g(ArcimDesc),1,15)_"^"_""_"^"_""_"^"_""_"^"_OrdTotSum
	;^DHCPB({DHC_PatientBill.PB_RowId},"O",{DHC_PatBillOrder.PBO_ChildSub},"D",{PBD_ChildSub}) 
	set myPBDRowID=0
	For  set myPBDRowID=$o(^DHCPB(myBill,"O",myOrd,"D", myPBDRowID)) quit:(myPBDRowID="")  Do
	.set myTarRowID=$p(^DHCPB(myBill,"O",myOrd,"D", myPBDRowID),"^",3)	;PBD_TARI_DR
	.quit:myTarRowID=""
	.set myTarDesc=$p($g(^DHCTARI(myTarRowID)),"^",2)
	.set myUnitPrice=$p(^DHCPB(myBill,"O",myOrd,"D", myPBDRowID),"^",4)		;PBD_UnitPrice
	.set myUnitPrice=$fn(myUnitPrice,"",4)
	.set PackUOM=""
	.set PackUOMRowid=$p($g(^DHCTARI(myTarRowID)),"^",3)
	.if PackUOMRowid'=""  set PackUOM=$p($g(^CT("UOM",PackUOMRowid)),"^",2)
	.set PackQty=$p(^DHCPB(myBill,"O",myOrd,"D", myPBDRowID),"^",5)			;PBD_BillQty
	.set OrdTotSum=$p(^DHCPB(myBill,"O",myOrd,"D", myPBDRowID),"^",10)			; PBD_PatientShare
	.set OrdTotSum=$p(^DHCPB(myBill,"O",myOrd,"D", myPBDRowID),"^",7)		;;PBD_TotalAmount
	.set OrdTotSum=$fn(OrdTotSum,"",2)
	.set ^TMP("InvData",$j,"D")=$g(^TMP("InvData",$j,"D"))+1
	.set Idx=$g(^TMP("InvData",$j,"D"))
	.set myYBCode=""
	.///s myYBCode=##class(web.DHCINSUFacade).GetInusTarInfo(myTarRowID)
	.;s myLen=+$l($p(myTarDesc,"-",1))
	.set ^TMP("InvData",$j,"D",Idx)="  "_myYBCode_$e($g(myTarDesc),1,15)_"^"_$j(myUnitPrice,3,2)_"^"_$p(PackUOM,"[")_"^"_PackQty_"^"_OrdTotSum
	quit
}

/// 获取对账明细
ClassMethod GetCheckInfo(Input As %String) As %GlobalCharacterStream
{
	Set $ZT="GetCheckInfoET"
    New (Input,Flag)
    set err=0
    set streamObj=##class(%GlobalCharacterStream).%New()
	set inputObj=##class(DHCExternalService.BillInterface.DHCEntity.CheckChargeInput).%New()
    Do inputObj.XMLNodeDeserialize(.inputObj,"Request",Input)
    set StDate=inputObj.StartDate	;查询日期
    set EndDate=inputObj.EndDate	;支付方式，这里自助传过来的只有银联:1
    set PayMode=inputObj.PayMode
	set OutputObj=##class(DHCExternalService.BillInterface.DHCEntity.CheckChargeOutput).%New()
    set StDate=$zdh(StDate,8)
    set EndDate=$zdh(StDate,8)
    set OutputXML=""
    set HandCom=##class(DHCExternalService.BillInterface.Service.DHCOPBillPayLogic).GetPayModeHardComm("OP",PayMode)
    For Date=StDate:1:EndDate Do
   	.s time=""   f  s time=$o(^DHCINVPRTi(0,date,time))  q:(time="")!(HandCom'="1")  d  ;门诊金额	 
	..s IBPRowid=""  f  s IBPRowid=$o(^DHCINVBTPi(0,"HISDTIME",date,time,IBPRowid))  q:IBPRowid=""  d
	...s TradeAmt=$p(^DHCINVBTP(IBPRowid),"^",1)
	...s TradeDate=$zd(Date,3)_" "_$zt(time,1)
	...s HISTradeNo=$p(^DHCINVBTP(IBPRowid),"^",1)
	...s BankTradeNo=$p(^DHCINVBTP(IBPRowid),"^",1)
	...d setObjPropery
	.s time1=""   f  s time1=$o(^DHCINVALITPi(0,date,time1))  q:(time1="")!(HandCom'="2")  d  ;门诊金额	 
	..s IAPRowid=""  f  s IAPRowid=$o(^DHCINVALITPi(0,"HISDTIME",date,time1,IAPRowid))  q:IAPRowid=""  d
	...s TradeAmt=$p(^DHCINVALITP(IAPRowid),"^",1)
	...s TradeDate=$zd(Date,3)_" "_$zt(time,1)
	...s HISTradeNo=$p(^DHCINVALITP(IAPRowid),"^",1)
	...s BankTradeNo=$p(^DHCINVALITP(IAPRowid),"^",1)
	...d setObjPropery
	.s IBPIPRowid="" f  s IBPIPRowid=$o(^DHCIPAutoDepBankData(0,"HISTradeDate",date,IBPIPRowid))  q:(IBPIPRowid="")   d  ;住院预交金
   	..s TradeAmt=$p(^DHCIPAutoDepBankData(IBPIPRowid),"^",17)
  	..s TradeDate=$zd(Date,3)_" "_$zt(time,1)
  	..s HISTradeNo=$p(^DHCIPAutoDepBankData(IBPIPRowid),"^",17)
	..s BankTradeNo=$p(^DHCIPAutoDepBankData(IBPIPRowid),"^",17)
	...d setObjPropery
	
	
  	set OutputObj.ResultCode=0
  	set OutputObj.ResultContent="成功"
  	
  	Do OutputObj.XMLExportToString(.OutputXML,"Response")    
	Quit OutputXML  
	
setObjPropery
  	set OUTRECCURObj=##class(DHCExternalService.BillInterface.DHCEntity.OUTRECCUR).%New()
  	set OUTRECCURObj.TradeAmt=TradeAmt
  	set OUTRECCURObj.TradeDate=TradeDate
  	set OUTRECCURObj.HisTradeNo=HISTradeNo
  	set OUTRECCURObj.OrderTradeId=BankTradeNo
  	Do OutputObj.OUTRECCURS.Insert(OUTRECCURObj)
  	Do OUTRECCURObj.%Close()
  	
GetCheckInfoET
	Set OutputObj=##class(DHCExternalService.BillInterface.DHCEntity.CheckChargeOutput).%New()
	Set OutputObj.ResultCode=-10
	Set OutputObj.ResultContent="程序处理错误:"_$ZERROR
	set OutputXML="" 
	Do OutputObj.XMLExportToString(.OutputXML,"Response")
	Quit OutputXML
}

Storage Default
{
<Data name="DHCOPBillAutoPayExpDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCOPBillAutoPayExpD</DataLocation>
<DefaultData>DHCOPBillAutoPayExpDefaultData</DefaultData>
<IdLocation>^web.DHCOPBillAutoPayExpD</IdLocation>
<IndexLocation>^web.DHCOPBillAutoPayExpI</IndexLocation>
<StreamLocation>^web.DHCOPBillAutoPayExpS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
