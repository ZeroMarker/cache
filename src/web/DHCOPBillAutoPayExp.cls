Import SQLUser

/// Lid
/// 2011-03-07
/// 门诊自助消息业务类
Class web.DHCOPBillAutoPayExp Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator:Lid
/// CreatDate:2011-03-07
/// Desc:  将病人当天当前科室就诊的医嘱信息对应的费用按门诊大类统计输出
/// 	Input:
/// 	Return:
/// 	Debug:w ##class(web.DHCOPBillAutoPayExp).GetBillInfo("<Request><CardNo>63030700736</CardNo><SecrityNo>6288863345</SecrityNo><Userid>EOG005</Userid><StartDate></StartDate><EndDate></EndDate><AdmInfo></AdmInfo><PatAmt></PatAmt><BankTradeInfo></BankTradeInfo><ExpStr>03</ExpStr></Request>")
/// <Request><CardNo>63031800007</CardNo><SecrityNo>6289966852</SecrityNo><Userid>EOG005</Userid><StartDate></StartDate><EndDate></EndDate><AdmInfo>619279</AdmInfo><PatAmt></PatAmt><BankTradeInfo></BankTradeInfo><ExpStr>03</ExpStr></Request>
ClassMethod GetBillInfo(Input As %String) As %GlobalCharacterStream
{
	;Set $ZT="GetBillInfoET"
    New (Input)
	;
    Set err=0
    Set streamObj=##class(%GlobalCharacterStream).%New()
	Set inputObj=##class(web.DHCEntity.PCA.AutoPayInputInfo).%New()
    Do inputObj.XMLNodeDeserialize(.inputObj,"Request",Input)
    ;Do inputObj.XMLNodeDeserialize(inputObj,"Request",Input)
    Set CardNO=inputObj.CardNo
    Set SecrityNo=inputObj.SecrityNo
    Set UserCode=inputObj.Userid
    //Set UserCode="zzsf"_UserCode	;自助机前添加一个前缀
    Set StDate=inputObj.StartDate 
    Set EndDate=inputObj.EndDate
    Set PatAmt=inputObj.PatAmt 
    Set BankTradeInfo=inputObj.BankTradeInfo
    Set AdmInfo=inputObj.AdmInfo
    Set ExpStr=inputObj.ExpStr
    Set CardType=$p(ExpStr,"^",1)
 	;
 	;b ;yhb
   	Set Data=##class(web.UDHCAccManageCLSIF).getaccinfofromcardno(CardNO,SecrityNo,"")
    ;s str=rtn_"^"_AccID_"^"_AccNo_"^"_left_"^"_Balance_"^"_DepPrice_"^"_Pass
	;s str=str_"^"_Papmi_"^"_PAPMINo_"^"_myCardRowID_"^"_myAccType
	;s str=str_"^"_mySCMode_"^"_myRtnCardTypeDR_"^"_mySelectCardTypeTip
    Set err=$p(Data,"^",1)
    Set Papmi=$p(Data,"^",8)
    Set AccM=$p(Data,"^",2)
    Set AccMBalance=$p(Data,"^",5)
    Set AccMDepPrice=$p(Data,"^",6)
    Set AccMAccType=$p(Data,"^",11)
    Set AccMCardTypeDR=$p(Data,"^",13)
    ;
  	Set OutputXML=""
  	Set PatOrderObj=##class(web.DHCEntity.PCA.PatOrder).%New()
    If (+err'=0){
	   Set PatOrderObj.ResultCode=err
	   If err=-200 Set ErrDesc="无效卡"
	   If err=-201 Set ErrDesc="卡有效，而账户无效返回-201"
	   Set PatOrderObj.ErrorMsg=ErrDesc
	   Set OutputXML=""
	   Do PatOrderObj.XMLExportToString(.OutputXML,"Response")
	   Do PatOrderObj.%Close()
	}
	Quit:+err'=0 OutputXML
   	;
   	If (Papmi=""){
	   Set PatOrderObj.ResultCode=-2
	   Set PatOrderObj.ErrorMsg="此卡号不存在病人信息"
	   Set OutputXML=""
	   Do PatOrderObj.XMLExportToString(.OutputXML,"Response")
	   Do PatOrderObj.%Close()
	}
	Quit:Papmi="" OutputXML
	;
	;Set expStr=""_$c(2)_CardType   ;3是银医卡的卡类型Rowid(DHC_cardtypedef)
    ;Set accInfo=##class(web.UDHCAccManageCLSIF).getaccinfofromcardno(CardNO,"",expStr)
    ;Set AccM=$p(accInfo,"^",2)  ;
    ;If AccM="" {
	;	Set PatOrderObj.ResultCode=-5
	;   Set PatOrderObj.ErrorMsg="此卡号不存在账户信息"
	;    Set OutputXML=""
	;    Do PatOrderObj.XMLExportToString(.OutputXML,"Response")
	;    Do PatOrderObj.%Close()    
	;}
 	;Quit:+AccM=0 OutputXML
	
	Set PapNo=$p(^PAPER(Papmi,"PAT",1),"^",1)   ;登记号
	Set PapName=$p(^PAPER(Papmi,"ALL"),"^",1)   ;姓名
	Set Sex=$p(^PAPER(Papmi,"ALL"),"^",7)       ;性别
	If Sex'="" Set Sex=$p(^CT("SEX",Sex),"^",2)
	Set PatientDOB=$P($G(^PAPER(Papmi,"ALL")),"^",6)
	Set PatAge=##class(web.UDHCJFBaseCommon).GetAgeDesc(PatientDOB,+$h)
	Set:UserCode'="" UserCode=$$ALPHAUP^SSUTIL4(UserCode)
	Set:UserCode'="" Userid=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,""))
	;set Userid=UserCode
	If ((Userid="")||('$d(^SSU("SSUSR",Userid)))){
	   Set PatOrderObj.ResultCode=-3
	   Set PatOrderObj.ErrorMsg="无此收费员."
	   Set OutputXML=""
	   Do PatOrderObj.XMLExportToString(.OutputXML,"Response")
	   Do PatOrderObj.%Close()
	}
	Quit:(Userid="")||('$d(^SSU("SSUSR",Userid))) OutputXML
	;
	Kill ^TMP("DHCOPBillAuto","BillInfo",+$h,$j,Papmi)
	Set gLoc=$p($g(^SSU("SSUSR",Userid)),"^",4)
	Set Grup=$p($g(^SSU("SSUSR",Userid)),"^",5)
	Set OPGS=$o(^DHCOPGSi("GS",0,"GSDR",Grup,""))
	Set RecLoc=""
	If Grup'=""  d
	.Set RecLoc=##class(web.UDHCOPGSConfig).ReadRLByGPRowID(Grup,gLoc)
	;
	Set Adm="",AdmStr="",billnostr=""
	Set rtn=0
    Set AdmInfo1=##class(web.DHCOPCashierIF).GetToDayAdmStr(Papmi,"N")
    b ;AdmInfo1
    For i=1:1:$Length(AdmInfo1,"^") Do
    .Set Adm=$p(AdmInfo1,"^",i)
    .Quit:+Adm=0
	.Set AdmDate=$p($g(^PAADM(Adm)),"^",6)
	.Set Visit=$p($g(^PAADM(Adm)),"^",20)
	.Quit:(AdmInfo'="")&&(("^"_AdmInfo_"^")'[("^"_Adm_"^"))
	.Quit:Visit'["A"
	.If AdmStr=""  s AdmStr=Adm
	.Else  Set AdmStr=AdmStr_"^"_Adm
	.Set rtn=##class(web.UDHCJFBILL).BILL(Adm,Userid)
	.Quit:+rtn'=0
	.Set myPayedFlag=""
	.Set myPBRowID=0
	.Set ARPBLRowid=""
	.For  Set myPBRowID=$O(^DHCPB(0,"ADM", Adm, myPBRowID)) Quit:((myPBRowID="")!(myPayedFlag="B"))  Do
	..Set myPayedFlag=$p($g(^DHCPB(myPBRowID)),"^",16)
	..Quit:(myPayedFlag'="B")
	..Set ARPBLRowid=myPBRowID
	.If $g(ARPBLRowid)'=""  Do
	..If billnostr=""  Set billnostr=ARPBLRowid
	..Else  Set billnostr=billnostr_"^"_ARPBLRowid
	.Quit:(+rtn)'=0
	If (billnostr=""){
		b ;bbbbb
	   Set PatOrderObj.ResultCode=-4
	   Set PatOrderObj.ErrorMsg="此病人无医嘱信息."
	   Set OutputXML=""
	   Do PatOrderObj.XMLExportToString(.OutputXML,"Response")
	   Do PatOrderObj.%Close()
	}
	b ;billnostr
	Quit:billnostr="" OutputXML
	;
	Set TBillCount=$l(billnostr,"^")
	For i=1:1:TBillCount Quit:+rtn'=0  Do
	.Set AdmBill=$p(billnostr,"^",i)
	.Set PBO="0"
	.For  Set PBO=$o(^DHCPB(AdmBill,"O",PBO))  Quit:PBO=""  Do
	..Quit:('$D(^DHCPB(AdmBill,"O",PBO)))||($d(^DHCPB(AdmBill,"O",PBO))=10)
	..Set PBord=$p($g(^DHCPB(AdmBill,"O",PBO)),"^",4)
	..Set OrdRecLoc=$p($g(^OEORD(+PBord,"I",$p(PBord,"||",2),3)),"^",6)
	..Set OrdStat=$p($g(^OEORD(+PBord,"I",$p(PBord,"||",2),1)),"^",13)
	..Set:OrdStat'="" OrdStat=$p($g(^OEC("OSTAT",OrdStat)),"^",1)
	..Quit:OrdStat="D"
	..Quit:(RecLoc'="")&&(RecLoc'[OrdRecLoc)
	..Set Limit=##class(web.UDHCOEORDOPIF).ReadSkinRtnFlag(PBord)    ;;;add by zhl 2010.03.02
	..Quit:Limit="Y"
	..;q:(RecLoc'="")&&('$d(^OEORDi(0,"RecDepOrd",+PBord,RecLoc,$p(PBord,"||",2))))
	..Set OrdIns=$p($g(^OEORD(+PBord,"I",$p(PBord,"||",2),11)),"^",18)
    ..Set:OrdIns="" OrdIns=##class(web.DHCBillCons).ReadDefInsType()
	..b ;222
	..Quit:(OrdIns="")||(+$p($g(^PAC("ADMREA",OrdIns)),"^",9)>0)	;医保病人不在自助机结算
	..b ;333
	..Set ArcimRowid=$p($g(^DHCPB(AdmBill,"O",PBO)),"^",3)
	..Set ArcimDesc=$p($g(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1)),"^",2) ;名称
	..Set ItemCatDR=$p($g(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1)),"^",10)	;ARC_ItemCat
	..Set OrdCatDR=$p(^ARC("IC",ItemCatDR),"^",8)								;OEC_OrderCategory
	..;Set OrdCatDesc=$p(^OEC("ORCAT",OrdCatDR),"^",2)
	..Set PBOBillQty=+$p($g(^DHCPB(AdmBill,"O",PBO)),"^",5)
	..Set PBORefundQty=+$p($g(^DHCPB(AdmBill,"O",PBO)),"^",6)
	..Set PBOQty=PBOBillQty+PBORefundQty
	..Set PBOUnitPrice=+$p($g(^DHCPB(AdmBill,"O",PBO)),"^",7)
	..Set PBOPatShare=+$p($g(^DHCPB(AdmBill,"O",PBO)),"^",11)
	..Quit:PBOPatShare=0
	..Set ArcQty=PBOQty
	..Set ArciDesc=ArcimDesc
	..Set OCCat=OrdCatDR
	..Set amt=PBOPatShare
	..Set UnitPrice=PBOUnitPrice
	..;
	..Set ^TMP("DHCOPBillAuto","BillInfo",+$h,$j,Papmi,OCCat)=+$g(^TMP("DHCOPBillAuto","BillInfo",+$h,$j,Papmi,OCCat))+amt
	..Set ^TMP("DHCOPBillAuto","BillInfo",+$h,$j,Papmi,OCCat,ArciDesc)=$g(^TMP("DHCOPBillAuto","BillInfo",+$h,$j,Papmi,OCCat,ArciDesc))+amt
	..Set:UnitPrice'="" ^TMP("DHCOPBillAuto","BillInfo",+$h,$j,Papmi,OCCat,ArciDesc,"Price")=UnitPrice
	..Set ^TMP("DHCOPBillAuto","BillInfo",+$h,$j,Papmi,OCCat,ArciDesc,"Qty")=+$g(^TMP("DHCOPBillAuto","BillInfo",+$h,$j,Papmi,OCCat,ArciDesc,"Qty"))+ArcQty
	..;
	..;Set PBD="0"
	..;For  Set PBD=$o(^DHCPB(AdmBill,"O",PBO,"D",PBD))  Quit:PBD=""  Do
	..;.Quit:('$D(^DHCPB(AdmBill,"O",PBO,"D",PBD)))||($D(^DHCPB(AdmBill,"O",PBO,"D",PBD))=10)
	..;.Set arci=$p($g(^DHCPB(AdmBill,"O",PBO,"D",PBD)),"^",3)
	..;.Quit:arci=""
	..;.Set UnitPrice=$p($g(^DHCPB(AdmBill,"O",PBO,"D",PBD)),"^",4)
	..;.Quit:+UnitPrice=0
	..;.Set ArcQty=$p($g(^DHCPB(AdmBill,"O",PBO,"D",PBD)),"^",5)
	..;.Set OCSubCat=$p($g(^DHCTARI(arci)),"^",15)
	..;.Set ArciDesc=$p($g(^DHCTARI(arci)),"^",2)
	..;.Set OCCat=$p($g(^DHCTarC("OC",OCSubCat)),"^",3)
	..;.Set amt=$p($g(^DHCPB(AdmBill,"O",PBO,"D",PBD)),"^",7)
	..;.;
	..;.Set ^TMP("DHCOPBillAuto","BillInfo",+$h,$j,Papmi,OCCat)=+$g(^TMP("DHCOPBillAuto","BillInfo",+$h,$j,Papmi,OCCat))+amt
	..;.Set ^TMP("DHCOPBillAuto","BillInfo",+$h,$j,Papmi,OCCat,ArciDesc)=$g(^TMP("DHCOPBillAuto","BillInfo",+$h,$j,Papmi,OCCat,ArciDesc))+amt
	..;.Set:UnitPrice'="" ^TMP("DHCOPBillAuto","BillInfo",+$h,$j,Papmi,OCCat,ArciDesc,"Price")=UnitPrice
	..;.Set ^TMP("DHCOPBillAuto","BillInfo",+$h,$j,Papmi,OCCat,ArciDesc,"Qty")=+$g(^TMP("DHCOPBillAuto","BillInfo",+$h,$j,Papmi,OCCat,ArciDesc,"Qty"))+ArcQty
	;
    ;
	Set FeeStr="",Total=0
	If $D(^TMP("DHCOPBillAuto","BillInfo",+$h,$j,Papmi))  Do
	.Set catdr="0"
	.For  Set catdr=$o(^TMP("DHCOPBillAuto","BillInfo",+$h,$j,Papmi,catdr))  q:catdr=""  Do
	..;Set CatDes=$p($g(^DHCTarC("TOC",catdr)),"^",2)
	..Set CatDes=$p(^OEC("ORCAT",catdr),"^",2)
	..Set CatFee=+$g(^TMP("DHCOPBillAuto","BillInfo",+$h,$j,Papmi,catdr))
	..Set Total=Total+CatFee
	..If $e($zabs(CatFee),1,1)="."  Do
	...If CatFee>0  Set CatFee="0"_CatFee
	...Else  Set CatFee="-0"_$zabs(CatFee)
	..If FeeStr=""  Set FeeStr=CatDes_"^"_CatFee
	..Else  Set FeeStr=FeeStr_"##"_CatDes_"^"_CatFee
	..;Do streamObj.Write("<TarOCCateItem><TarOCCateDesc>"_CatDes_"</TarOCCateDesc><TarOCCateAmt>"_CatFee_"</TarOCCateAmt><OEOrdItems>")
	..;Do streamObj.Write("<TarOCCateItem><TarOCCateDesc>"_CatDes_"</TarOCCateDesc><TarOCCateAmt>"_CatFee_"</TarOCCateAmt>")
	..Set TarOCCateItemObj=##class(web.DHCEntity.PCA.TarOCCateItem).%New()
    ..Set TarOCCateItemObj.TarOCCateDesc=CatDes
 	..;Set TarOCCateItemObj.TarOCCateAmt=$j(CatFee,3,2)
 	..///金额单位由元转成分
 	..Set TarOCCateItemObj.TarOCCateAmt=$j(CatFee,3,2)*100
	..Set Arcdes="0",ArcNum=0
	..For  Set Arcdes=$o(^TMP("DHCOPBillAuto","BillInfo",+$h,$j,Papmi,catdr,Arcdes))   Quit:Arcdes=""   Do
	...Set ArciFee=+$g(^TMP("DHCOPBillAuto","BillInfo",+$h,$j,Papmi,catdr,Arcdes))
	...Set Price=+$g(^TMP("DHCOPBillAuto","BillInfo",+$h,$j,Papmi,catdr,Arcdes,"Price"))
	...Set Qty=+$g(^TMP("DHCOPBillAuto","BillInfo",+$h,$j,Papmi,catdr,Arcdes,"Qty"))
	...Set ArcNum=ArcNum+1
	...If $E($zabs(ArciFee),1,1)="."  Do
	....If ArciFee>0  Set ArciFee="0"_ArciFee
	....Else  Set ArciFee="-0"_$zabs(ArciFee)
	...If $E($zabs(Price),1,1)="."  Do
	....If Price>0  Set Price="0"_Price
	....Else  Set Price="-0"_$zabs(Price)
	...If ArcNum=1  Set FeeStr=FeeStr_"^"_Arcdes_$C(2)_Price_$C(2)_Qty_$C(2)_ArciFee
	...If  Set FeeStr=FeeStr_$c(3)_Arcdes_$c(2)_Price_$C(2)_Qty_$C(2)_ArciFee
	...Set OEOrdItemObj=##class(web.DHCEntity.PCA.OEOrdItem).%New()
    ...Set OEOrdItemObj.ArcmiDesc=Arcdes
 	...;Set OEOrdItemObj.Price=$j(Price,3,2)
 	...///金额单位由元转成分201301老大修改
 	...Set OEOrdItemObj.Price=$j(Price,3,2)*100
 	...Set OEOrdItemObj.Qty=Qty
 	...;Set OEOrdItemObj.Amt=$J(ArciFee,3,2)
 	...///金额单位由元转成分
 	...Set OEOrdItemObj.Amt=$J(ArciFee,3,2)*100
 	...Do TarOCCateItemObj.OEOrdItems.Insert(OEOrdItemObj)
 	...Do OEOrdItemObj.%Close()
 	..Do PatOrderObj.TarOCCateItems.Insert(TarOCCateItemObj)
 	..Do TarOCCateItemObj.%Close()
 	If (+Total>0){
	 	Set PatOrderObj.ResultCode=0
	    Set PatOrderObj.ErrorMsg="获取费用信息成功."
	}else{
		b ;b0000
		Set PatOrderObj.ResultCode=-4
	    Set PatOrderObj.ErrorMsg="此病人无医嘱信息."	
	}
 	Set PatOrderObj.PatNO=PapNo
	Set PatOrderObj.PatName=PapName
	Set PatOrderObj.PatSex=Sex
	Set PatOrderObj.PatAge=PatAge
	;Set PatOrderObj.AmtSum=$J(Total,3,2)
	///金额单位由元转成分
	Set PatOrderObj.AmtSum=$J(Total,3,2)*100
	Do PatOrderObj.XMLExportToString(.OutputXML,"Response")
	Do PatOrderObj.%Close()
	;
	Kill ^TMP("DHCOPBillAuto","BillInfo",+$h,$j,Papmi)
	;
	Quit OutputXML
	;
GetBillInfoET
   	Set PatOrderObj=##class(web.DHCEntity.PCA.PatOrder).%New()
   	Set PatOrderObj.ResultCode=-10
   	Set PatOrderObj.ErrorMsg="程序处理出错:"_$ZERROR
  	Set OutputXML=""
   	Do PatOrderObj.XMLExportToString(.OutputXML,"Response")
   	Do PatOrderObj.%Close()
	Quit OutputXML
}

/// creat by zhl 2010.01.07 
/// modify by Lid 2011-03-30
/// description   结算病人当天当前科室的就诊纪录
ClassMethod AutoOPBillCharge(Input As %String) As %GlobalCharacterStream
{
	Set $zt="AutoOPBillChargeET"
	s ^TMP("jkcs")=Input
	New (Input)
    Set err=0,HospDR=""
    Set streamObj=##class(%GlobalCharacterStream).%New()
	Set inputObj=##class(web.DHCEntity.PCA.AutoPayInputInfo).%New()
    Do inputObj.XMLNodeDeserialize(.inputObj,"Request",Input)
    Set CardNO=inputObj.CardNo
    Set SecrityNo=inputObj.SecrityNo
    Set UserCode=inputObj.Userid
    //Set UserCode="zzsf"_UserCode	;自助机前添加一个前缀
    Set StDate=inputObj.StartDate 
    Set EndDate=inputObj.EndDate
    Set PatPaySum=inputObj.PatAmt
    ///金额单位由分转成元
    ///set PatPaySum=PatPaySum/100
    ///
    Set BankTradeInfo=inputObj.BankTradeInfo
    Set AdmInfo=inputObj.AdmInfo
    Set ExpStr=inputObj.ExpStr
    Set CardType=$p(ExpStr,"^",1)
    ;
	b  ;Lid 2011-10-26 判断多个就诊记录是否为同一医院(非同一医院的就诊记录不能一起结算)
	Set TmpHospDR="",ManyHospFlag=0
	For i=1:1:$l(AdmInfo,"^") Do  Quit:ManyHospFlag=1
	.Set myAdm=$p(AdmInfo,"^",i)
	.Quit:+myAdm=0
	.Set myAdmDepCodeDR=$p(^PAADM(myAdm),"^",4)
	.Set HospDR=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(myAdmDepCodeDR)
	.Set:TmpHospDR="" TmpHospDR=HospDR
	.Set:TmpHospDR'=HospDR ManyHospFlag=1
	;
	Set OutputXML=""
  	Set ChargeObj=##class(web.DHCEntity.PCA.AutoPayChargeResult).%New()
	if (+ManyHospFlag=1) {
		Set ChargeObj.ResultCode=-6
	  	Set ChargeObj.ErrorMsg="就诊记录非同一院区,请核实."
	   	Set OutputXML=""
	   	Do ChargeObj.XMLExportToString(.OutputXML,"Response")
	   	Do ChargeObj.%Close()	
	}
	Quit:(+ManyHospFlag=1) OutputXML
	;
	set ^TMP("Card","rt")=CardNO_"^"_SecrityNo
	b
	Set Data=##class(web.UDHCAccManageCLSIF).getaccinfofromcardno(CardNO,SecrityNo,"")
	b
	set ^TMP("Card","rp")=Data
    ;s str=rtn_"^"_AccID_"^"_AccNo_"^"_left_"^"_Balance_"^"_DepPrice_"^"_Pass
	;s str=str_"^"_Papmi_"^"_PAPMINo_"^"_myCardRowID_"^"_myAccType
	;s str=str_"^"_mySCMode_"^"_myRtnCardTypeDR_"^"_mySelectCardTypeTip
    Set err=$p(Data,"^",1)
    Set Papmi=$p(Data,"^",8)
    Set AccM=$p(Data,"^",2)
    Set AccMLeft=$p(Data,"^",4)
    Set AccMBalance=$p(Data,"^",5)
    Set AccMDepPrice=$p(Data,"^",6)
    Set AccMAccType=$p(Data,"^",11)
    Set AccMCardTypeDR=$p(Data,"^",13)
	b   ;************1
	If (CardType="03")&(+AccMLeft<+PatPaySum){
		Set ChargeObj.ResultCode="-6"
	   Set ChargeObj.ErrorMsg="账户余额不足"
	   Set OutputXML=""
	   Do ChargeObj.XMLExportToString(.OutputXML,"Response")
	   Do ChargeObj.%Close()	
	}
	;
    If (+err'=0){
	   Set ChargeObj.ResultCode=err
	   If err=-200 Set ErrDesc="无效卡"
	   If err=-201 Set ErrDesc="卡有效，而账户无效返回-201"
	   Set ChargeObj.ErrorMsg=ErrDesc
	   Set OutputXML=""
	   Do ChargeObj.XMLExportToString(.OutputXML,"Response")
	   Do ChargeObj.%Close()
	}
	Quit:+err'=0 OutputXML
	b   ;************2
   	Set:UserCode'="" UserCode=$$ALPHAUP^SSUTIL4(UserCode)
   	Set:UserCode'="" Userid=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,""))
   	If (Userid="")||('$d(^SSU("SSUSR",Userid))){
	   Set ChargeObj.ResultCode=-3
	   Set ChargeObj.ErrorMsg="无此操作员"
	   Set OutputXML=""
	   Do ChargeObj.XMLExportToString(.OutputXML,"Response")
	   Do ChargeObj.%Close()
	}
	Quit:(Userid="")||('$d(^SSU("SSUSR",Userid))) OutputXML
	b   ;************3
	If (Papmi=""){
	   Set ChargeObj.ResultCode=-2
	   Set ChargeObj.ErrorMsg="此卡号不存在病人信息."
	   Set OutputXML=""
	   Do ChargeObj.XMLExportToString(.OutputXML,"Response")
	   Do ChargeObj.%Close()
	}
	Quit:(Papmi="") OutputXML
	;
	If CardType="03" {
		Set Paymode=$o(^CT("CTPM",0,"Code","CPP",""))	
	}Else{
		Set Paymode=$o(^CT("CTPM",0,"Code","CARDCPP",""))	
	}
    Set myPayinfo=Paymode_"^^^^"
    ;	
	Set gloc=$p($g(^SSU("SSUSR",Userid)),"^",4)	;SSUSR_DefaultDept
	b ;bpay1
	Set Grup=$p($g(^SSU("SSUSR",Userid)),"^",5)	;SSUSR_Group
	Set OPGS=$o(^DHCOPGSi("GS",0,"GSDR",Grup,""))
	Set RecLoc=""
	If Grup'=""  d
	.Set RecLoc=##class(web.UDHCOPGSConfig).ReadRLByGPRowID(Grup,gloc)
	;k ^TMP("DHCOPBillAuto","AutoOPBillCharge",+$h,$j,Papmi)
	Set Adm="",AdmStr="",UnBillOrdStr="",CurIns=""
	Set AdmInfo1=##class(web.DHCOPCashierIF).GetToDayAdmStr(Papmi,"N")
	b ;111
    For i=1:1:$l(AdmInfo1,"^") Do
    .Set Adm=$p(AdmInfo1,"^",i)
    .Quit:+Adm=0
	.Set AdmDate=$p($g(^PAADM(Adm)),"^",6)
	.Quit:(AdmInfo'="")&&(("^"_AdmInfo_"^")'[("^"_Adm_"^"))
	.Set Visit=$p($g(^PAADM(Adm)),"^",20)
	.Quit:Visit'["A"
	.If AdmStr=""  Set AdmStr=Adm
	.Else  Set AdmStr=AdmStr_"^"_Adm
	.b ;bpay2
	.Set AdmOrd=$o(^OEORD(0,"Adm",Adm,""))
	.Quit:+AdmOrd=0
	.Set Odritm="0"
	.For  Set Odritm=$o(^OEORD(AdmOrd,"I",Odritm))  Quit:Odritm=""   Do
	..Set OrdRecLoc=$p($g(^OEORD(AdmOrd,"I",Odritm,3)),"^",6)
	..Set OrdIns=$p($g(^OEORD(+AdmOrd,"I",Odritm,11)),"^",18)
	..Set OEORDI=AdmOrd_"||"_Odritm
	..Set Limit=##class(web.UDHCOEORDOPIF).ReadSkinRtnFlag(OEORDI)   ;;;add by zhl 2010.03.02
	..Set InsAdmSour=""
	..Set:OrdIns'="" InsAdmSour=$p($g(^PAC("ADMREA",OrdIns)),"^",9)
	..Set:(+InsAdmSour=0)&(CurIns="") CurIns=OrdIns
	..If ((RecLoc'="")&&(RecLoc'[OrdRecLoc))||(+InsAdmSour'=0)||(Limit="Y")  Do
	...If UnBillOrdStr=""  Set UnBillOrdStr=OEORDI
	...Else  Set UnBillOrdStr=UnBillOrdStr_"^"_OEORDI	
	;
    Set myCurPreSum=##class(web.DHCBillConsIF).OPCRound(PatPaySum,"")
    Set myCurRoundSum=$fn(myCurPreSum-PatPaySum,"",2)
	;
    Set ExpStr=Grup_"^"_gloc_"^"_AccM_"^Y^F^^0^"_myCurRoundSum 
    Set ^TMP("OPBillCharge")=AdmStr_"^"_Userid_"^"_UnBillOrdStr_"^"_CurIns_"^"_PatPaySum_"^"_myPayinfo_"^"_Grup_"^"_"0"_"^"_""_"^"_"0"_"^"_ExpStr
    b ;1start
    Set rtn=##class(web.DHCOPINVCons).OPBillCharge(AdmStr, Userid, UnBillOrdStr, CurIns, PatPaySum, myPayinfo, Grup, "0", "", "0",ExpStr) ;gloc改为Grup  安全组
    b ;2start
    Set ErrCode=+rtn_":门诊结算失败"
    If +rtn=102   Set ErrCode="102:结算金额不符"
    If +rtn=101   Set ErrCode="101:没有门诊结算数据"
    If +rtn=112   Set ErrCode="112:判断舍入错误"
    If (+rtn'=0){
	    Set ChargeObj.ResultCode=+rtn
	   	Set ChargeObj.ErrorMsg=ErrCode
	   	Do ChargeObj.XMLExportToString(.OutputXML,"Response")
	   	Do ChargeObj.%Close()
	}
	Quit:+rtn'=0 OutputXML
	;
	Set InvRowidStr=$p(rtn,$c(2),1)
	If +rtn=0{
		;药房接口	;Lid 2014-12-01 注释，药房发药标志在确认完成时再置
		//d ##class(web.udhcOPPHARWIN).UpdatePHWINV(InvRowidStr)
	}
	;
	If CardType="03" {
		For i=2:1:$l(InvRowidStr,"^") Do  Quit:+err'=0
	    .Set PrtInvRowid=$p(InvRowidStr,"^",i)
	    .Quit:+PrtInvRowid=0
	   	.If +rtn=0 Do
	    ..;Lid 2012-04-20 确认完成	
	   	..Set myInsTypeDR=$p(^DHCINVPRT(PrtInvRowid),"^",9)
	   	..Set CTLocDR=gloc
		..Set GroupDR=Grup
		..Set ExtUserID=$p(^DHCINVPRT(PrtInvRowid),"^",21)
	   	..Set myExpStr=GroupDR_"^"_CTLocDR_"^"_""_"^Y^F^^0^^"
		..Set rtn=##class(web.DHCBillConsIF).CompleteCharge("7",ExtUserID,myInsTypeDR,PrtInvRowid,"0","",myExpStr)
	  	..Set err=+rtn
	  	
	  	.;获取发药窗口
	    .Set WinInfo=""
	    .;Set WinInfo=##class(web.UDHCOPINVPrtData12).GetPrescWinByPrtRowID(PrtInvRowid)
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
	    
	    If +err'=0 Do 
	    .Set myPrtStr=##class(web.DHCBillBankLogic).GetDelPrt(InvRowidStr,"")
	    .Set rtn=##class(web.DHCBillConsIF).DelINVPRTForYB(myPrtStr,Grup)	
	    .Set ChargeObj.ResultCode=+err
		.Set ChargeObj.ErrorMsg="结算失败" 		   	   
	    If +err=0 Do
	    .Set ChargeObj.ResultCode=+err
		.Set ChargeObj.ErrorMsg="结算成功"
	    Do ChargeObj.XMLExportToString(.OutputXML,"Response")
		Do ChargeObj.%Close()
	}Else{
		;Set myrtn=+$p(InvRowidStr,"^",1)_$c(1)_"结算成功"_$c(2) ;结算成功标志
	    For i=2:1:$l(InvRowidStr,"^") Do  Quit:+err'=0
	    .b ;binvrowidstr
	    .Set PrtInvRowid=$p(InvRowidStr,"^",i)
	    .Quit:+PrtInvRowid=0
	    .Set CTLocDR=gloc
		.Set GroupDR=Grup
		.Set ExtUserID=$p(^DHCINVPRT(PrtInvRowid),"^",21)
		.Set HospDR=$p(^DHCINVPRT(PrtInvRowid),"^",39)
		.Set TerminalID=ExtUserID
		.Set TerminalID=##class(web.DHCBillBMCLogic).FormatTerminalId(TerminalID)
		.Set ExpStr=CTLocDR_"^"_GroupDR_"^"_HospDR_"^"_"25"_"^"_TerminalID_"^"_ExtUserID
		.b ;BMCPayStart
	    .Set BMCPayRtn=##class(web.DHCBillBMCLogic).BMCPay("OP",PrtInvRowid,"",CardNO,"C",ExpStr)
	    .b ;BMCPayRtn
	    .s SucessPrt=""
	    .Set err=$p(BMCPayRtn,"^",1)
	    .Set ResultCode=$p(BMCPayRtn,"^",2)
	    .Set ResultContent=$p(BMCPayRtn,"^",3)
	    .Set ErrCode=ResultCode_ResultContent
	    .If +err=0 Do
	    ..;Lid 2012-04-20 确认完成	
	   	..Set myInsTypeDR=$p(^DHCINVPRT(PrtInvRowid),"^",9)
	   	..Set myExpStr=GroupDR_"^"_CTLocDR_"^"_""_"^Y^F^^0^^"
		..Set rtn=##class(web.DHCBillConsIF).CompleteCharge("7",ExtUserID,myInsTypeDR,PrtInvRowid,"0","",myExpStr)
	  	..Set err=+rtn
	  	.If +err=0 Do
	    ..If $g(SucessPrt)="" Set SucessPrt=PrtInvRowid
	    ..Else  Set SucessPrt=SucessPrt_"^"_PrtInvRowid
	    ..Set myIBSRowid=$o(^DHCINVBTPi(0,"S","IPDR",PrtInvRowid,""))
	    ..Set TradePayID=$p(^DHCINVBTP(myIBSRowid),"^",32)
	    ..Set invAmt=$p(^DHCINVBTP(myIBSRowid),"^",23)
	  	.If +err=0 d
	  	..Set InvoiceObj=##class(web.DHCEntity.PCA.Invoice).%New()
	    ..Set InvoiceObj.TransactionId=TradePayID
	 	..Set InvoiceObj.InvoiceNO=PrtInvRowid
	 	..Set InvoiceObj.InvoiceAmt=$J(invAmt,3,2)
	 	..Set InvoiceObj.PrescWindow=$g(WinInfo)
	 	..;Set InvoiceObj.InvocieExpStr=""
	 	..Do ChargeObj.Invoices.Insert(InvoiceObj)
	 	..Do InvoiceObj.%Close()
	    ;
	    ;生成交易流水号,银行结算失败后HIS回滚
	    If +err'=0 Do
	    .b ;删除
	    .If SucessPrt="" Do    ;等于空的情况下提示结算失败、部分成功的时候还是提示成功，返回成功的发票的明细。
	    ..Set ChargeObj.ResultCode=-7
		..Set ChargeObj.ErrorMsg="生成交易流水号失败."
	    .Set myPrtStr=##class(web.DHCBillBankLogic).GetDelPrt(InvRowidStr,SucessPrt)
	    .Set rtn=##class(web.DHCBillConsIF).DelINVPRTForYB(myPrtStr,Grup)
	    If +err=0 Do
	    .Set ChargeObj.ResultCode=+err
		.Set ChargeObj.ErrorMsg="结算成功"
	    Do ChargeObj.XMLExportToString(.OutputXML,"Response")
		Do ChargeObj.%Close()
	}
    
	b ;;End
    q OutputXML
	;
AutoOPBillChargeET
   	Set ChargeObj=##class(web.DHCEntity.PCA.AutoPayChargeResult).%New()
   	Set ChargeObj.ResultCode=-10
   	Set ChargeObj.ErrorMsg="程序处理出错:"_$ZERROR
  	Set OutputXML=""
   	Do ChargeObj.XMLExportToString(.OutputXML,"Response")
   	Do ChargeObj.%Close()
	Quit OutputXML
}

/// Lid
/// 2011-03-30
/// 插入银行交易信息
ClassMethod InserBankTradeInfo(Input As %String) As %GlobalCharacterStream
{
	n (Input)
    s err=0
    s streamObj=##class(%GlobalCharacterStream).%New()
    //test
    d streamObj.Write("<Response><ResultCode>0</ResultCode><ErrorMsg>HIS插入银行交易信息成功</ErrorMsg></Response>")
    q streamObj
    //test
	s inputObj=##class(web.DHCEntity.PCA.AutoPayInputInfo).%New()
    d inputObj.XMLNodeDeserialize(.inputObj,"Request",Input)
    s CardNO=inputObj.CardNo
    s SecrityNo=inputObj.SecrityNo
    s UserCode=inputObj.Userid
    s StDate=inputObj.StartDate 
    s EndDate=inputObj.EndDate
    s PatAmt=inputObj.PatAmt 
    s BankTradeInfo=inputObj.BankTradeInfo 
    s AdmInfo=inputObj.AdmInfo
    s PrtRowID=inputObj.InvoiceNO
    s HisTradeNO=inputObj.TransactionId
    s ExpStr=inputObj.ExpStr
    ;
	s:UserCode'="" UserCode=$$ALPHAUP^SSUTIL4(UserCode)
   	s:UserCode'="" Userid=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,""))
   	i (Userid="")||('$d(^SSU("SSUSR",Userid))) d ; "无此操作员"
    .s err=-3
	.d streamObj.Write("<Response><ResultCode>"_err_"</ResultCode><ErrorMsg>无此收费员</ErrorMsg></Response>")
	q:+err'=0 streamObj
   	
   	s gloc=$p($g(^SSU("SSUSR",Userid)),"^",4)
	s Grup=$p($g(^SSU("SSUSR",Userid)),"^",5)  ;安全组
	;
	s OutputObj=##class(web.DHCEntity.PCA.BankTradeOutput).%New()
	d OutputObj.XMLNodeDeserialize(.OutputObj,"Response",BankTradeInfo)
    s TradeCode=OutputObj.TradeCode	//交易代码
	s BankID=OutputObj.BankID	//银行代码
	s BankDate=OutputObj.BankDate	//银行交易时间YYYYMMDDHHMMSS
	s BankTradeNo=OutputObj.BankTradeNo	//银行唯一流水号
	s ResultCode=OutputObj.ResultCode	//交易结果,错误代码表 0000：成功
	s ResultContent=OutputObj.ResultContent	//对错误/异常的详细描述信息
	s PayCardNo=OutputObj.PayCardNo	//银联卡号
	s BankAccDate=OutputObj.BankAccDate	//银行账务日期
	s RevTranFlag=OutputObj.RevTranFlag	//正反交易标志 1-退费
	s PatientID=OutputObj.PatientID	//患者主索引
	s PayAmt=OutputObj.PayAmt	//退款金额
	s HISTradeNo=OutputObj.HISTradeNo	//HIS交易流水号
	s OrgHISTradeNo=OutputObj.OrgHISTradeNo	//原HIS流水号
	s OrgPaySeqNo=OutputObj.OrgPaySeqNo	//原支付小票号 HIS生成，唯一
	;
	i ResultCode'="0000" d
	.s rtn=##class(web.DHCBillConsIF).DelINVPRTForYB(PrtRowID,Grup)
	.i +rtn'=0 d
	..s err=-8
	..d streamObj.Write("<Response><ResultCode>"_err_"</ResultCode><ErrorMsg>"_+rtn_":HIS回滚数据失败,请与计算机中心联系</ErrorMsg></Response>")
    e  d
   	.;Lid 2012-04-20 确认完成	
   	.s myInsTypeDR=$p(^DHCINVPRT(PrtRowID),"^",9)
   	.s myExpStr=Grup_"^"_gloc_"^"_""_"^Y^F^^0^^"
	.;s rtn=##class(web.DHCBillConsIF).CompleteCharge("7",Userid,myInsTypeDR,PrtRowID,"0","",myExpStr)
	.s err=rtn
	.i (+err=0) d
	..;银行交易成功
    ..;ExpStr:扩展串(科室^安全组^医院^渠道代码^科室代码^操作员代码)
    ..s myExpStr=gloc_"^"_Grup_"^"_"1"_"^"_"15"_"^"_Userid_"^"_Userid_"^^^"
    ..s rtn=##class(web.DHCBillBMCLogic).BMCUpdateTradeData("OP",PrtRowID,"","R",HISTradeNo,BankTradeInfo, myExpStr)
	..s err=$p(rtn,"^",1)	;err_"^"_$g(IBPRowID)_"^"_$g(ResultCode)_"^"_$g(ResultContent)
	..s IBPRowID=$p(rtn,"^",2)
	..s ResultCode=$p(rtn,"^",3)
	..s ResultContent=$p(rtn,"^",4)
	.i (+err=0)
	..d streamObj.Write("<Response><ResultCode>0</ResultCode><ErrorMsg>HIS插入银行交易信息成功</ErrorMsg></Response>")
	.e  d
	..d streamObj.Write("<Response><ResultCode>"_err_"</ResultCode><ErrorMsg>"_+$p(rtn,$c(4),1)_":HIS插入银行交易信息失败</ErrorMsg></Response>")
	..s rtn=##class(web.DHCBillConsIF).DelINVPRTForYB(PrtRowID,Grup) 
	;
	q streamObj
}

/// Lid
/// 2011-03-30
/// 插入银行交易信息
ClassMethod InserBankTradeInfoOLD(Input As %String) As %GlobalCharacterStream
{
	Set $ZT="InserBankTradeInfoET"
	New (Input)
    Set err=0
    Set streamObj=##class(%GlobalCharacterStream).%New()
	Set inputObj=##class(web.DHCEntity.PCA.AutoPayInputInfo).%New()
    Do inputObj.XMLNodeDeserialize(.inputObj,"Request",Input)
    Set CardNO=inputObj.CardNo
    Set SecrityNo=inputObj.SecrityNo
    Set UserCode=inputObj.Userid
    //Set UserCode="zzsf"_UserCode	;自助机前添加一个前缀
    Set StDate=inputObj.StartDate 
    Set EndDate=inputObj.EndDate
    Set PatAmt=inputObj.PatAmt 
    Set BankTradeInfo=inputObj.BankTradeInfo
    Set AdmInfo=inputObj.AdmInfo
    Set ExpStr=inputObj.ExpStr
    Set TransactionId=inputObj.TransactionId
    Set PrtRowID=inputObj.InvoiceNO
    ;
    Set OutputXML=""
    Set UpdateBankResultObj=##class(web.DHCEntity.PCA.AutoPayUpdateBankResult).%New()
  	;
	Set:UserCode'="" UserCode=$$ALPHAUP^SSUTIL4(UserCode)
   	Set:UserCode'="" Userid=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,""))
   	If ((Userid="")||('$d(^SSU("SSUSR",Userid)))){
		Set UpdateBankResultObj.ResultCode=-3
   		Set UpdateBankResultObj.ErrorMsg="无此操作员."  
   		Do UpdateBankResultObj.XMLExportToString(.OutputXML,"Response")
   		Do UpdateBankResultObj.%Close()
	}
   	Quit:(Userid="")||('$d(^SSU("SSUSR",Userid))) 
   	;
   	Set gloc=$p($g(^SSU("SSUSR",Userid)),"^",4)
	Set Grup=$p($g(^SSU("SSUSR",Userid)),"^",5)  ;安全组
	;
	Set ResultCode=$p(BankTradeInfo,"|",1)	;判断银行交易是否成功
	If ResultCode'="00" d
	.Set rtn=##class(web.DHCBillConsIF).DelINVPRTForYB(PrtRowID,Grup)
	.If +rtn'=0 d
	..Set UpdateBankResultObj.ResultCode=-8
   	..Set UpdateBankResultObj.ErrorMsg=+rtn_":HIS回滚数据失败,请与计算机中心联系" 
   	.;ExpStr:扩展串(科室^安全组^医院^渠道代码^科室代码^操作员代码)
    .Set myExpStr=gloc_"^"_Grup_"^"_"1"_"^"_"15"_"^"_Userid_"^"_Userid_"^^^"
    .;                                                  PatType, Guser, PrtRowid, AbortPrtRowID, BankCardNO, BankTradeType,HISTradeID,BankData, ExpStr
	.Set rtn=##class(web.DHCBillBankLogic).POSDataSave("OP",Userid,PrtRowID,"",CardNO,"S1",TransactionId,BankTradeInfo,myExpStr)
	.Set err=$p(rtn,$c(2),1)	;err_$c(2)_$g(IBPRowID)_$c(2)_$g(Rc)_$c(2)_$g(RcDetail)
	.Set IBPRowID=$p(rtn,$c(2),2)
	.Set Rc=$p(rtn,$c(2),3)
	.Set ResultContent=$p(rtn,$c(2),4)
   	.Set UpdateBankResultObj.ResultCode=0
   	.Set UpdateBankResultObj.ErrorMsg=+0_":银医卡交易失败，HIS回滚成功。" 
    Else  Do
    .;银行交易成功
    .;ExpStr:扩展串(科室^安全组^医院^渠道代码^科室代码^操作员代码)
    .Set myExpStr=gloc_"^"_Grup_"^"_"1"_"^"_"15"_"^"_Userid_"^"_Userid_"^^^"
    .;                                                  PatType, Guser, PrtRowid, AbortPrtRowID, BankCardNO, BankTradeType,HISTradeID,BankData, ExpStr
	.Set rtn=##class(web.DHCBillBankLogic).POSDataSave("OP",Userid,PrtRowID,"",CardNO,"S1",TransactionId,BankTradeInfo,myExpStr)
	.Set err=$p(rtn,$c(2),1)	;err_$c(2)_$g(IBPRowID)_$c(2)_$g(Rc)_$c(2)_$g(RcDetail)
	.Set IBPRowID=$p(rtn,$c(2),2)
	.Set Rc=$p(rtn,$c(2),3)
	.Set ResultContent=$p(rtn,$c(2),4)
	.If (+err=0) Do
	..Set UpdateBankResultObj.ResultCode=err
   	..Set UpdateBankResultObj.ErrorMsg=+err_":HIS插入银行交易信息成功." 
	.Else  Do
	..Set UpdateBankResultObj.ResultCode=err
   	..Set UpdateBankResultObj.ErrorMsg=+ResultContent_":HIS插入银行交易信息失败." 
   	..Set rtn=##class(web.DHCBillConsIF).DelINVPRTForYB(PrtRowID,Grup)
   	..Set rtn=##class(web.DHCBillBankLogic).DeleteIBP(IBPRowID,"")
	;
	Do UpdateBankResultObj.XMLExportToString(.OutputXML,"Response")
   	Do UpdateBankResultObj.%Close()
   	;
	q OutputXML
	;
InserBankTradeInfoET
   	Set PatOrderObj=##class(web.DHCEntity.PCA.AutoPayUpdateBankResult).%New()
   	Set PatOrderObj.ResultCode=-10
   	Set PatOrderObj.ErrorMsg="程序处理出错:"_$ZERROR
  	Set OutputXML=""
   	Do PatOrderObj.XMLExportToString(.OutputXML,"Response")
   	Do PatOrderObj.%Close()
	Quit OutputXML
}

/// Creator:Lid
/// CreatDate:2012-02-07
/// Desc:获取病人基本信息
/// Input:
/// Return:
/// Debug:w ##class(web.DHCOPBillAutoPayExp).GetPatientInfo("")
ClassMethod GetPatientInfo(Input As %String) As %String
{
	;Set $ZT="GetPatientInfoET"
	Set OutputXML=""
	Set InputObj=##class(web.DHCEntity.PCA.AutoPayInputInfo).%New()
    Do InputObj.XMLNodeDeserialize(.InputObj,"Request",Input)
    Set CardNo=InputObj.CardNo
    Set SecrityNo=InputObj.SecrityNo
    Set ExpStr=InputObj.ExpStr
    Set CardType=$p(ExpStr,"^",1)	;卡类型，有自助机在扩展串的第一位传入
	;
    Set OutputObj=##class(web.DHCEntity.PCA.AutoPayPatInfo).%New()
    if (CardNo=""){
	   Set OutputObj.ResultCode=-1
	   Set OutputObj.ErrorMsg="此卡号不存在"
	   Set OutputXML=""
	   Do OutputObj.XMLExportToString(.OutputXML,"Response")
	   Do OutputObj.%Close()
	}
	Quit:CardNo="" OutputXML
	;
    Set CardID="",Papmi="",BankActive="",BankSign=""
    ;For  Set CardID=$o(^DHCCARDi("CF",0,"CardNo",CardNo,CardID))  Quit:CardID=""   Do
    ;.Set Data=$g(^DHCCARD("CF",CardID))
    ;.Set active=$p(Data,"^",10)
    ;.Quit:active'["N"
   	;.Set Papmi=$p(Data,"^",4)
   	;.Set BankActive=$p(Data,"^",19)
    ;.Set BankSign=$p(Data,"^",20)
    Set Data=##class(web.UDHCAccManageCLSIF).getaccinfofromcardno(CardNo,SecrityNo,"") ;20130109
    ;Set Data=##class(web.UDHCAccManageCLSIF).getaccinfofromcardno(CardNo,SecrityNo,"")
    ;s str=rtn_"^"_AccID_"^"_AccNo_"^"_left_"^"_Balance_"^"_DepPrice_"^"_Pass
	;s str=str_"^"_Papmi_"^"_PAPMINo_"^"_myCardRowID_"^"_myAccType
	;s str=str_"^"_mySCMode_"^"_myRtnCardTypeDR_"^"_mySelectCardTypeTip
    Set Papmi=$p(Data,"^",8)
    b ;b01
    Set AccMRowID=$p(Data,"^",2)
    Set AccMBalance=$p(Data,"^",5)
    Set AccMBalance=AccMBalance*100
    Set AccMDepPrice=$p(Data,"^",6)
    Set AccMAccType=$p(Data,"^",11)
    Set AccMCardTypeDR=$p(Data,"^",13)
	;
    if (Papmi="") {
	    Set OutputObj.ResultCode=-2
	   	Set OutputObj.ErrorMsg="此卡号不存在病人信息"
	   	Set OutputXML=""
	  	Do OutputObj.XMLExportToString(.OutputXML,"Response")   
	  	Do OutputObj.%Close()
	}
    Quit:Papmi="" OutputXML
    ;
    /*广西南宁没有“卡激活”，“卡签约”功能
    if (BankSign'="") {
		Set OutputObj.ResultCode=-4
	   	Set OutputObj.ErrorMsg="卡号未签约"
	   	Set OutputXML=""
	  	Do OutputObj.XMLExportToString(.OutputXML,"Response")  
	  	Do OutputObj.%Close()  
	}
	Quit:BankSign'="" OutputXML
	if (BankActive'="Y"){
		Set OutputObj.ResultCode=-5
	   	Set OutputObj.ErrorMsg="卡号未激活"
	   	Set OutputXML=""
	  	Do OutputObj.XMLExportToString(.OutputXML,"Response") 
	  	Do OutputObj.%Close() 	
	}
	Quit:BankActive'="Y" OutputXML
	*/
    Set PapNo=$p(^PAPER(Papmi,"PAT",1),"^",1)   ;登记号
	Set PapName=$p(^PAPER(Papmi,"ALL"),"^",1)   ;姓名
	Set Sex=$p(^PAPER(Papmi,"ALL"),"^",7)       ;性别
	If Sex'="" Set Sex=$p(^CT("SEX",Sex),"^",2)
	Set PatAge=""
	Set PatientDOB=$P($G(^PAPER(Papmi,"ALL")),"^",6)
	Set PatAge=##class(web.UDHCJFBaseCommon).GetAgeDesc(PatientDOB,+$h)
	;
	Set OutputObj.ResultCode=0
	Set OutputObj.ErrorMsg="查询病人信息成功"
	Set OutputObj.PatNO=PapNo
	Set OutputObj.PatName=PapName
	Set OutputObj.PatAge=PatAge
	Set OutputObj.PatSex=Sex
	Set OutputObj.AccMAccStatus=""	;
    Set OutputObj.AccMBalance=AccMBalance
    Set OutputObj.AccMDepPrice=AccMDepPrice
    Set OutputObj.AccMRowID=AccMRowID
   	Set OutputXML=""
  	Do OutputObj.XMLExportToString(.OutputXML,"Response")
  	Do OutputObj.%Close()
    Quit OutputXML
    ;
GetPatientInfoET
	Set OutputXML=""
	Set OutputObj=##class(web.DHCEntity.PCA.AutoPayPatInfo).%New()
	Set OutputObj.ResultCode=-10
	Set OutputObj.ErrorMsg="程序处理错误:"_$ZERROR
	Do OutputObj.XMLExportToString(.OutputXML,"Response")
	Quit OutputXML
}

/// Creator:Lid
/// CreatDate:2012-02-07
/// Desc: 根据卡号及日期查询就诊记录
/// Input:
/// Return:
/// Debug:w ##class(web.DHCOPBillAutoPayExp).GetAdmByCardNo("")
ClassMethod GetAdmByCardNo(Input As %String) As %String
{
	Set $ZT="GetAdmByCardNoET"
	New (Input)
	Set InputObj=##class(web.DHCEntity.PCA.AutoPayInputInfo).%New()
    Do InputObj.XMLNodeDeserialize(.InputObj,"Request",Input)
    Set CardNo=InputObj.CardNo
    Set SecrityNo=InputObj.SecrityNo
    Set StDate=InputObj.StartDate 
    Set EndDate=InputObj.EndDate
    If (StDate["-") Set StDate=$ZDH(StDate,3)
    If (EndDate["-") Set EndDate=$ZDH(EndDate,3) 
    Set Userid=InputObj.Userid
    //Set UserCode="zzsf"_UserCode	;自助机前添加一个前缀
  	;
  	Set OutputXML=""
  	Set OutputObj=##class(web.DHCEntity.PCA.AdmItems).%New()
    if ((CardNo="")!($p(CardNo,$c(0))="")){
	   Set OutputObj.ResultCode=-1
	   Set OutputObj.ErrorMsg="此卡号不存在"
	   Set OutputXML=""
	   Do OutputObj.XMLExportToString(.OutputXML,"Response")
	   Do OutputObj.%Close()
	}
	Quit:CardNo="" OutputXML
    ;
    Set CardID="",Papmi=""
    ;For  Set CardID=$o(^DHCCARDi("CF",0,"CardNo",CardNo,CardID))  Quit:CardID=""   Do
    ;.Set Data=$g(^DHCCARD("CF",CardID))
    ;.Set active=$p(Data,"^",10)
    ;.Quit:active'["N"
    ;.Set Papmi=$p(Data,"^",4)
    Set Data=##class(web.UDHCAccManageCLSIF).getaccinfofromcardno(CardNo,SecrityNo,"")
    Set Papmi=$p(Data,"^",8)
    Set AccMRowID=$p(Data,"^",2)
    Set AccMBalance=$p(Data,"^",5)
    Set AccMDepPrice=$p(Data,"^",6)
    Set AccMAccType=$p(Data,"^",11)
    Set AccMCardTypeDR=$p(Data,"^",13)
    if (Papmi="") {
	    Set OutputObj.ResultCode=-2
	   	Set OutputObj.ErrorMsg="此卡号不存在病人信息"
	  	Do OutputObj.XMLExportToString(.OutputXML,"Response")   
	  	Do OutputObj.%Close()
	}
    Quit:Papmi="" OutputXML
    ;
    Set Type="" ,AdmStr=""
    Set AdmInfo=##class(web.DHCOPCashierIF).GetToDayAdmStr(Papmi,"N")
    For i=1:1:$l(AdmInfo,"^") Do
    .Set Adm=$p(AdmInfo,"^",i)
    .Quit:+Adm=0
    .Set Data=$g(^PAADM(Adm))
    .Set AdmDate=$p(Data,"^",6)
    .Quit:((StDate'="")&&(AdmDate<StDate))||((EndDate'="")&&(AdmDate>EndDate))
    .Quit:$p(Data,"^",20)["C"
    .Set rtn=##class(web.UDHCJFBILL).BILL(Adm,Userid)
	.Quit:+rtn'=0
	.Set myPayedFlag=""
	.Set myPBRowID=0
	.Set billamt=0
	.For  Set myPBRowID=$o(^DHCPB(0,"ADM", Adm, myPBRowID)) Quit:((myPBRowID="")!(myPayedFlag="B"))  Do
	..Set myPayedFlag=$p($g(^DHCPB(myPBRowID)),"^",16)
	..Quit:(myPayedFlag'="B")
	..Set totamt=+$piece($get(^DHCPB(myPBRowID)),"^",8)
	..Set billamt=billamt+totamt
	.Quit:+billamt=0
    .Set admdep=$p(Data,"^",4)
    .Set admdepdesc=$p($g(^CTLOC(admdep)),"^",2)
	.Set admdocdesc=""
	.Set admdoc=$p(Data,"^",9)
	.If admdoc'="" Set admdocdesc=$p($g(^CTPCP(admdoc,1)),"^",2)
    .If AdmStr=""  Set AdmStr=Adm_"^"_$zd(AdmDate,3)_"^"_admdepdesc_"^"_admdocdesc
    .Else   Set AdmStr=AdmStr_$c(2)_Adm_"^"_$zd(AdmDate,3)_"^"_admdepdesc_"^"_admdocdesc
    .Set AdmItemObj=##class(web.DHCEntity.PCA.AdmItem).%New()
    .Set AdmItemObj.AdmRowid=Adm
 	.Set AdmItemObj.AdmDate=$zd(AdmDate,3)
 	.Set AdmItemObj.AdmLoc=admdepdesc
 	.Set AdmItemObj.AdmDoctor=admdocdesc
 	.Do OutputObj.AdmItems.Insert(AdmItemObj)
    If (AdmStr'=""){
		Set OutputObj.ResultCode=0
		Set OutputObj.ErrorMsg="获取就诊记录成功"    
	}Else{
		Set OutputObj.ResultCode=-3
		Set OutputObj.ErrorMsg="此病人没有需要缴费的就诊记录"	
	}
	Do OutputObj.XMLExportToString(.OutputXML,"Response") 
 	Do OutputObj.%Close()
	Quit OutputXML
	;
GetAdmByCardNoET
	Set OutputObj=##class(web.DHCEntity.PCA.AutoPayPatInfo).%New()
	Set OutputObj.ResultCode=-10
	Set OutputObj.ErrorMsg="程序处理错误:"_$ZERROR
	Do OutputObj.XMLExportToString(.OutputXML,"Response")
	Quit OutputXML
}

/// creat by zhl 2010.09.01\
/// description   根据就诊记录取该就诊记录的发票明细
/// output     姓名_"^"_性别_"^"_登记号_$C(2)_detail_$C(2)_detail_$C(3)_姓名_"^"_性别_"^"_登记号_$C(2)_detail_$C(2)_detail
/// detail:    lab1_"^"_lab2_"^"_lab3_"^"_lab4_"^"_lab5_"^"_lab6
ClassMethod GetBillDetailByAdm(AdmStr As %String) As %GlobalCharacterStream
{
   //w ##Class(web.DHCOPBillAutoPayExp).GetBillDetailByAdm("806517^806515")
    q:AdmStr="" "-1^"
    s BDetailStr=""
	s Len=$l(AdmStr,"^")
	s PrtStr="",APIStr=""
	f i=1:1:Len   d
	.s Adm=$p(AdmStr,"^",i)
	.q:(Adm="")||('$d(^PAADM(Adm)))
	.s cons=""
	.f  s cons=$o(^DHCBCI(0,"ADM",Adm,cons))  q:cons=""   d
	..s Prt=$p(^DHCBCI(cons),"^",1)
	..q:(Prt="")||('$d(^DHCINVPRT(Prt)))
	..s flag=$p(^DHCINVPRT(Prt),"^",8)
	..q:flag'["N"
	..s AccPrt=$p(^DHCINVPRT(Prt),"^",4)
	..i +AccPrt'=0  d
	...q:$d(^TMP("DHCOPBill","GetBillDetailByAdm",$j,AccPrt))
	...s ^TMP("DHCOPBill","GetBillDetailByAdm",$j,AccPrt)=AccPrt
	...i APIStr=""  s APIStr=AccPrt
	...e  s APIStr=APIStr_"^"_AccPrt 
	..q:+AccPrt'=0
	..i PrtStr=""  s PrtStr=Prt
	..e  s PrtStr=PrtStr_"^"_Prt
 
    q:(PrtStr="")&&(APIStr="") "-2^"
    s Str=PrtStr_"#"_APIStr
    s BDetailStr=##class(web.udhcOPQUERY).InvListPrint(Str)
    
    s StreamObj=##class(%GlobalCharacterStream).%New()
    
    
    s OutPutXML=""
    f i=1:1:$l(BDetailStr,$c(3))    d
    .s PatData=$p(BDetailStr,$c(3),i)
    .s Patinfo=$p(PatData,$c(2),1)
    .s Name=$p(Patinfo,"^",1)
    .s Sex=$p(Patinfo,"^",2)
    .s PatNo=$p(Patinfo,"^",3)
    .s OutPutXML="<Patient><PatInfo><Name>"_Name_"</Name><Sex>"_Sex_"</Sex><PatNo>"_PatNo_"</PatNo></PatInfo><PatFee>"
    .s StreamObj=StreamObj.Write(OutPutXML)
    .f j=2:1:$l(PatData,$c(2))    d
    ..s PatDetails=$p(PatData,$c(2),j)
    ..s Cat=$p(PatDetails,"^",1)
    ..s tari=$p(PatDetails,"^",2)
    ..s Price=$p(PatDetails,"^",3)
    ..s Qty=$p(PatDetails,"^",4)
    ..s Patshare=$p(PatDetails,"^",5)
    ..s Total=$p(PatDetails,"^",6)
    ..s OutPutXML="<Details><Cat>"_Cat_"</Cat><Tari>"_tari_"</Tari><Price>"_Price_"</Price><Qty>"_Qty_"</Qty><Total>"
    ..s OutPutXML=OutPutXML_Total_"</Total><Patshare>"_Patshare_"</Patshare></Details>"
    ..s StreamObj=StreamObj.Write(OutPutXML)
    .s OutPutXML="</PatFee></Patient>"
    .s StreamObj=StreamObj.Write(OutPutXML)
    i OutPutXML=""  s RtnCode=-3
    e  s RtnCode=0
	q RtnCode_"^"_StreamObj
}

/// Lid
/// 2011-03-30
/// 根据发票Rowid获取银医卡支付金额
ClassMethod GetOPInvBankCardAmt(invRowid)
{
	;w ##class(web.DHCOPBillAutoPayExp).GetOPInvBankCardAmt(35919)
	n (invRowid)
	s amt=0.00
	s IPM="0"
	q:'$d(^DHCINVPRT(invRowid,"P",IPM))
	f  s IPM=$o(^DHCINVPRT(invRowid,"P",IPM)) q:IPM=""  d
	.s s=$g(^DHCINVPRT(invRowid,"P",IPM))
	.s payMDr=$p(s,"^",1)
	.s payMCode=$p(^CT("CTPM",payMDr),"^",1)
	.s payMAmt=+$p(s,"^",3)
	.s handDr=##class(web.DHCBillBankLogic).GetPayModeHardComm("OP",payMDr)
	.i handDr'="" d
	..s amt=amt+payMAmt
	s amt=$fn($zabs(amt),"",2)
	
	q amt
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
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCOPBillAutoPayExpD</IdLocation>
<IndexLocation>^web.DHCOPBillAutoPayExpI</IndexLocation>
<StreamLocation>^web.DHCOPBillAutoPayExpS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
