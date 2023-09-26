Import SQLUser

/// wangjian
/// 2014-07-07
/// 支付宝消息业务类
Class DHCAliPay.ChargeInterface.DHCOPBillAliPayExp Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// wangjian
/// 2014-07-07
/// 支付宝医嘱推送
/// w ##class(DHCAliPay.ChargeInterface.DHCOPBillAliPayExp).GetBillInfo("<Request><phoneNo>18511901950</phoneNo><terminalId>zfb_client</terminalId><terminalType>web</terminalType><hospitalId>5</hospitalId><patientCard>000288079134</patientCard><patientId>71066</patientId><admId>1252405</admId><userCode>alipay001</userCode></Request>")
ClassMethod GetBillInfo(Input As %String) As %GlobalCharacterStream
{
	Set $ZT="AliPayGetBillInfoET"
	Set ^DHCBillAliPay("GetBillInfo",+$h,$p($h,",",2),"Input")=Input
	New (Input)
    Set err=0
    Set streamObj=##class(%GlobalCharacterStream).%New()
	Set inputObj=##class(DHCAliPay.DHCEntity.PCA.AliPayRequest).%New()
    Do inputObj.XMLNodeDeserialize(.inputObj,"Request",Input)
    Set CardNO=inputObj.patientCard
    Set TerminalId=inputObj.terminalId
    Set TerminalType=inputObj.terminalType
    Set HospitalId=inputObj.hospitalId 
    Set PhoneNo=inputObj.phoneNo
    Set PatientId=inputObj.patientId 
    Set AdmInfo=inputObj.admId
    Set UserCode=inputObj.userCode
    Do inputObj.%Close()
    Set PatOrderObj=##class(DHCAliPay.DHCEntity.PCA.PatOrder).%New()
    Set OutputXML=""  
    If (AdmInfo=""){
	   Set PatOrderObj.ResultCode=-1
	   Set PatOrderObj.ErrorMsg="就诊不存在"
	   Do PatOrderObj.XMLExportToString(.OutputXML,"Response")
	   Do PatOrderObj.%Close()
	}
	Quit:(AdmInfo="") OutputXML
	If UserCode="" Set UserCode="alipay001"
	;Set UserCode="alipay001"
	Set:UserCode'="" UserCode=$$ALPHAUP^SSUTIL4(UserCode)
	Set:UserCode'="" Userid=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,""))
	Set gLoc=$p($g(^SSU("SSUSR",Userid)),"^",4)
	Set Grup=$p($g(^SSU("SSUSR",Userid)),"^",5)
	Set OPGS=$o(^DHCOPGSi("GS",0,"GSDR",Grup,""))
	Set RecLoc=""
	If Grup'=""  Do
	.Set RecLoc=##class(web.UDHCOPGSConfig).ReadRLByGPRowID(Grup,gLoc)
	Set Adm="",AdmStr="",billnostr=""	
    For i=1:1:$Length(AdmInfo,"^") Do
    .Set Adm=$p(AdmInfo,"^",i)
    .Quit:+Adm=0
	.Set AdmDate=$p($g(^PAADM(Adm)),"^",6)
	.Set Visit=$p($g(^PAADM(Adm)),"^",20)
	.Set Papmi=$p($g(^PAADM(Adm)),"^",1)
	.Set PapNo=$p(^PAPER(Papmi,"PAT",1),"^",1)   ;登记号
	.Set PapName=$p(^PAPER(Papmi,"ALL"),"^",1)   ;姓名
	.Set Sex=$p(^PAPER(Papmi,"ALL"),"^",7)       ;性别
	.If Sex'="" Set Sex=$p(^CT("SEX",Sex),"^",2)
	.Set PatientDOB=$P($G(^PAPER(Papmi,"ALL")),"^",6)
	.Set PatAge=##class(web.DHCDTHealthCommon).GetAgeDesc(PatientDOB,+$h)
	.Set AdmDate=$p($g(^PAADM(Adm)),"^",6)
	.Quit:Visit'["A"
	.If AdmStr=""  Set AdmStr=Adm
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
	   Set PatOrderObj.ResultCode=-4
	   Set PatOrderObj.ErrorMsg="此病人无医嘱信息."
	   Do PatOrderObj.XMLExportToString(.OutputXML,"Response")
	   Do PatOrderObj.%Close()
	}
	Quit:billnostr="" OutputXML
	;
	Set TBillCount=$l(billnostr,"^")
	For i=1:1:TBillCount Quit:+rtn'=0  Do
	.Set AdmBill=$p(billnostr,"^",i)
	.Set PBO="0"
	.For  Set PBO=$o(^DHCPB(AdmBill,"O",PBO))  Quit:PBO=""  Do
	..Quit:('$D(^DHCPB(AdmBill,"O",PBO)))||($d(^DHCPB(AdmBill,"O",PBO))=10)
	..Set PBord=$p($g(^DHCPB(AdmBill,"O",PBO)),"^",4)
	..Set OrdDoc=$p($g(^OEORD(+PBord,"I",$p(PBord,"||",2),1)),"^",11)
	..Set DocName=$p($g(^SSU("SSUSR",Userid)),"^",2)
	..Set OrdRecLoc=$p($g(^OEORD(+PBord,"I",$p(PBord,"||",2),3)),"^",6)
	..Set RecLocDesc=$p($g(^CTLOC(OrdRecLoc)),"^",2)
	..Set LocAdress=$g(^CTLOC(OrdRecLoc,"ADDR",0))
	..Set Billed=$p($g(^OEORD(+PBord,"I",$p(PBord,"||",2),3)),"^",5)
	..Quit:(Billed="P")!(Billed="I")
	..Set OrdStat=$p($g(^OEORD(+PBord,"I",$p(PBord,"||",2),1)),"^",13)
	..Set:OrdStat'="" OrdStat=$p($g(^OEC("OSTAT",OrdStat)),"^",1)
	..Quit:(OrdStat'="V")&&(OrdStat'="E")
	..Quit:(RecLoc'="")&&(RecLoc'[OrdRecLoc)
	..Set Limit=##class(web.UDHCOEORDOPIF).ReadSkinRtnFlag(PBord)    ;;;add by zhl 2010.03.02
	..Quit:Limit="Y"
	..;q:(RecLoc'="")&&('$d(^OEORDi(0,"RecDepOrd",+PBord,RecLoc,$p(PBord,"||",2))))
	..Set OrdIns=$p($g(^OEORD(+PBord,"I",$p(PBord,"||",2),11)),"^",18)
    ..Set:OrdIns="" OrdIns=##class(web.DHCBillCons).ReadDefInsType()
	..Quit:(OrdIns="")
	..;Set InsAdmSour=""
	..;Set:OrdIns'="" InsAdmSour=$p($g(^PAC("ADMREA",OrdIns)),"^",9)
	..;Set:(+InsAdmSour=0)&(CurIns="") CurIns=OrdIns
	..Set LimitOrdIns=..GetLimtIns(OrdIns)
	..Quit:((RecLoc'="")&&(RecLoc'[OrdRecLoc))||(LimitOrdIns="Y")||(Limit="Y")
	..Set PBD="0"
	..For  Set PBD=$o(^DHCPB(AdmBill,"O",PBO,"D",PBD))  Quit:PBD=""  Do
	...Quit:('$D(^DHCPB(AdmBill,"O",PBO,"D",PBD)))||($D(^DHCPB(AdmBill,"O",PBO,"D",PBD))=10)
	...Set arci=$p($g(^DHCPB(AdmBill,"O",PBO,"D",PBD)),"^",3)
	...Quit:arci=""
	...Set UnitPrice=$p($g(^DHCPB(AdmBill,"O",PBO,"D",PBD)),"^",4)
	...Set ArcQty=$p($g(^DHCPB(AdmBill,"O",PBO,"D",PBD)),"^",5)
	...Set OCSubCat=$p($g(^DHCTARI(arci)),"^",15)
	...Set ArciDesc=$p($g(^DHCTARI(arci)),"^",2)
	...s BillUnintid=$p(^DHCTARI(arci),"^",3)
    ...s BillUnint=$p(^CT("UOM",BillUnintid),"^",2)
	...Set OCCat=$p($g(^DHCTarC("OC",OCSubCat)),"^",3)
	...Set amt=$p($g(^DHCPB(AdmBill,"O",PBO,"D",PBD)),"^",7)
	...Set discamount=$p($g(^DHCPB(AdmBill,"O",PBO,"D",PBD)),"^",8)
	...Set payorshare=$p($g(^DHCPB(AdmBill,"O",PBO,"D",PBD)),"^",9)
	...Set patientshare=$p($g(^DHCPB(AdmBill,"O",PBO,"D",PBD)),"^",10)
	...Set ^TMP("DHCOPBillAuto","BillInfo",+$h,$j,Papmi,OCCat)=+$g(^TMP("DHCOPBillAuto","BillInfo",+$h,$j,Papmi,OCCat))+amt
	...set ^TMP("DHCOPBillAuto","BillInfo",+$h,$j,Papmi,OCCat,ArciDesc,"TotalAmount")=+$g(^TMP("DHCOPBillAuto","BillInfo",+$h,$j,Papmi,OCCat,ArciDesc,"TotalAmount"))+amt
	...Set ^TMP("DHCOPBillAuto","BillInfo",+$h,$j,Papmi,OCCat,ArciDesc)=$g(^TMP("DHCOPBillAuto","BillInfo",+$h,$j,Papmi,OCCat,ArciDesc))+patientshare
	...set ^TMP("DHCOPBillAuto","BillInfo",+$h,$j,Papmi,OCCat,ArciDesc,"Disc")=+$g(^TMP("DHCOPBillAuto","BillInfo",+$h,$j,Papmi,OCCat,ArciDesc,"Disc"))+discamount
	...set ^TMP("DHCOPBillAuto","BillInfo",+$h,$j,Papmi,OCCat,ArciDesc,"PayorShare")=+$g(^TMP("DHCOPBillAuto","BillInfo",+$h,$j,Papmi,OCCat,ArciDesc,"PayorShare"))+payorshare
	...Set:UnitPrice'="" ^TMP("DHCOPBillAuto","BillInfo",+$h,$j,Papmi,OCCat,ArciDesc,"Price")=UnitPrice
	...Set ^TMP("DHCOPBillAuto","BillInfo",+$h,$j,Papmi,OCCat,ArciDesc,"Qty")=+$g(^TMP("DHCOPBillAuto","BillInfo",+$h,$j,Papmi,OCCat,ArciDesc,"Qty"))+ArcQty
	...set:BillUnint'="" ^TMP("DHCOPBillAuto","BillInfo",+$h,$j,Papmi,OCCat,ArciDesc,"Format")=BillUnint
	Set FeeStr="",Total=0
	If $D(^TMP("DHCOPBillAuto","BillInfo",+$h,$j,Papmi))  Do
	.Set catdr="0"
	.For  Set catdr=$o(^TMP("DHCOPBillAuto","BillInfo",+$h,$j,Papmi,catdr))  q:catdr=""  Do
	..Set CatDes=$p($g(^DHCTarC("TOC",catdr)),"^",2)
	..Set CatFee=+$g(^TMP("DHCOPBillAuto","BillInfo",+$h,$j,Papmi,catdr))
	..If $e($zabs(CatFee),1,1)="."  Do
	...If CatFee>0  Set CatFee="0"_CatFee
	...Else  Set CatFee="-0"_$zabs(CatFee)
	..If FeeStr=""  Set FeeStr=CatDes_"^"_CatFee
	..Else  Set FeeStr=FeeStr_"##"_CatDes_"^"_CatFee
	..;Do streamObj.Write("<TarOCCateItem><TarOCCateDesc>"_CatDes_"</TarOCCateDesc><TarOCCateAmt>"_CatFee_"</TarOCCateAmt><OEOrdItems>")
	..;Do streamObj.Write("<TarOCCateItem><TarOCCateDesc>"_CatDes_"</TarOCCateDesc><TarOCCateAmt>"_CatFee_"</TarOCCateAmt>")
	..Set TarOCCateItemObj=##class(DHCAliPay.DHCEntity.PCA.TarOCCateItem).%New()
    ..Set TarOCCateItemObj.TarOCCateDesc=CatDes
 	..Set TarOCCateItemObj.TarOCCateAmt=$j(CatFee,3,2)
	..Set Arcdes="0",ArcNum=0
	..For  Set Arcdes=$o(^TMP("DHCOPBillAuto","BillInfo",+$h,$j,Papmi,catdr,Arcdes))   Quit:Arcdes=""   Do
	...Set ArciFee=+$g(^TMP("DHCOPBillAuto","BillInfo",+$h,$j,Papmi,catdr,Arcdes))
	...Set Price=+$g(^TMP("DHCOPBillAuto","BillInfo",+$h,$j,Papmi,catdr,Arcdes,"Price"))
	...Set Qty=+$g(^TMP("DHCOPBillAuto","BillInfo",+$h,$j,Papmi,catdr,Arcdes,"Qty"))
	...Set Format=$g(^TMP("DHCOPBillAuto","BillInfo",+$h,$j,Papmi,catdr,Arcdes,"Format"))
	...Set DiscAmount=+$g(^TMP("DHCOPBillAuto","BillInfo",+$h,$j,Papmi,catdr,Arcdes,"Disc"))
	...Set TotalAmount=+$g(^TMP("DHCOPBillAuto","BillInfo",+$h,$j,Papmi,catdr,Arcdes,"TotalAmount"))
	...set PayorShareAmt=+$g(^TMP("DHCOPBillAuto","BillInfo",+$h,$j,Papmi,catdr,Arcdes,"PayorShare"))
	...Set Total=Total+ArciFee
	...Set ArcNum=ArcNum+1
	...If $E($zabs(ArciFee),1,1)="."  Do
	....If ArciFee>0  Set ArciFee="0"_ArciFee
	....Else  Set ArciFee="-0"_$zabs(ArciFee)
	...If $E($zabs(Price),1,1)="."  Do
	....If Price>0  Set Price="0"_Price
	....Else  Set Price="-0"_$zabs(Price)
	...If ArcNum=1  Set FeeStr=FeeStr_"^"_Arcdes_$C(2)_Price_$C(2)_Qty_$C(2)_ArciFee
	...If  Set FeeStr=FeeStr_$c(3)_Arcdes_$c(2)_Price_$C(2)_Qty_$C(2)_ArciFee
	...Set OEOrdItemObj=##class(DHCAliPay.DHCEntity.PCA.OEOrdItem).%New()
    ...Set OEOrdItemObj.ArcmiDesc=Arcdes
 	...Set OEOrdItemObj.Price=$j(Price,3,2)
 	...Set OEOrdItemObj.DiscAmount=$fn(DiscAmount,"",2)
 	...Set OEOrdItemObj.TotalAmount=$fn(TotalAmount,"",2)
 	...Set OEOrdItemObj.PayorShareAmt=$fn(PayorShareAmt,"",2)
 	...Set OEOrdItemObj.Qty=Qty
 	...Set OEOrdItemObj.Amt=$J(ArciFee,3,2)
 	...;Set OEOrdItemObj.Adress=LocAdress
 	...;Set OEOrdItemObj.Doc=DocName
 	...;Set OEOrdItemObj.RecLoc=RecLocDesc
 	...Do TarOCCateItemObj.OEOrdItems.Insert(OEOrdItemObj)
 	...Do OEOrdItemObj.%Close()
 	..Do PatOrderObj.TarOCCateItems.Insert(TarOCCateItemObj)
 	..Do TarOCCateItemObj.%Close()
 	If (+Total>0){
		Set PatOrderObj.ResultCode=0
		Set PatOrderObj.ErrorMsg="获取费用信息成功."
		Do PatOrderObj.XMLExportToString(.OutputXML,"Response")
		Do PatOrderObj.%Close()
	}else{
		Set PatOrderObj.ResultCode=-4
	    Set PatOrderObj.ErrorMsg="此病人无医嘱信息."
		Do PatOrderObj.XMLExportToString(.OutputXML,"Response")
		Do PatOrderObj.%Close()	
	}
    Quit:(+Total'>0) OutputXML
 	Set PatOrderObj.PatNO=PapNo
	Set PatOrderObj.PatName=PapName
	Set PatOrderObj.PatSex=Sex
	Set PatOrderObj.PatAge=PatAge
	;Set PatOrderObj.PatType=PatType
	Set PatOrderObj.AmtSum=$J(Total,3,2)
	Do PatOrderObj.XMLExportToString(.OutputXML,"Response")
	Do PatOrderObj.%Close()
	;
	Kill ^TMP("DHCOPBillAuto","BillInfo",+$h,$j,Papmi)
	;
	Quit OutputXML
	;
AliPayGetBillInfoET
   	Set PatOrderObj=##class(DHCAliPay.DHCEntity.PCA.PatOrder).%New()
   	Set PatOrderObj.ResultCode=-10
   	Set PatOrderObj.ErrorMsg="程序处理出错:"_$ZERROR
  	Set OutputXML=""
   	Do PatOrderObj.XMLExportToString(.OutputXML,"Response")
   	Do PatOrderObj.%Close()
	Quit OutputXML
}

/// wangjian
/// 2014-07-08
/// 支付宝账生成His流水号(账单号)
/// w ##class(DHCAliPay.ChargeInterface.DHCOPBillAliPayExp).SetPayTradeNo("<Request><phoneNo>18511901950</phoneNo><terminalId>zfb_client</terminalId><terminalType>web</terminalType><hospitalId>5</hospitalId><patientCard>000288079134</patientCard><patientId>378464</patientId><admId>1252405</admId><userCode>alipay001</userCode></Request>")
ClassMethod SetPayTradeNo(Input As %String) As %GlobalCharacterStream
{
	Set $ZT="AliPaySetTradeNoET"
	New (Input)
	Set ^DHCBillAliPay("SetPayTradeNo",+$h,$p($h,",",2),"Input")=Input
    Set err=0
    Set streamObj=##class(%GlobalCharacterStream).%New()
	Set inputObj=##class(DHCAliPay.DHCEntity.PCA.AliPayRequest).%New()
    Do inputObj.XMLNodeDeserialize(.inputObj,"Request",Input)
    Set CardNO=inputObj.patientCard
    Set TerminalId=inputObj.terminalId
    Set TerminalType=inputObj.terminalType
    Set HospitalId=inputObj.hospitalId 
    Set PhoneNo=inputObj.phoneNo
    Set PatientId=inputObj.patientId 
    Set AdmInfo=inputObj.admId
    Set UserCode=inputObj.userCode
    Set PatPaySum=inputObj.patAmt
    Do inputObj.%Close() 
    Set outputObj=##class(DHCAliPay.DHCEntity.PCA.HisTradeNoResponse).%New()
    Set OutputXML=""  
    If (AdmInfo=""){
		Set outputObj.ResultCode=-1
		Set outputObj.ErrorMsg="就诊不存在,无法生成订单号"
		Do outputObj.XMLExportToString(.OutputXML,"Response")
		Do outputObj.%Close()
	}
	Quit:(AdmInfo="") OutputXML
	If UserCode="" Set UserCode="alipay001"
	Set TradeType="C"
	Set:UserCode'="" UserCode=$$ALPHAUP^SSUTIL4(UserCode)
	Set:UserCode'="" Userid=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,""))
	Set gLoc=$p($g(^SSU("SSUSR",Userid)),"^",4)
	Set Grup=$p($g(^SSU("SSUSR",Userid)),"^",5)
	Set OPGS=$o(^DHCOPGSi("GS",0,"GSDR",Grup,""))
	Set Expstr=Userid_"^3^OP"_"^"_PatPaySum ;user^3^交易来源^金额^原订单号
	If HospitalId="" set HospitalId=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(gLoc) ;根据科室取院区 
	;If HospitalId="" set HospitalId=5
	Set rtn=..CheckRepeatTrade(AdmInfo,TradeType,Userid)
	b ;;
	If (rtn=-1){
		;生成新订单
		Set rtn=..SetHisTradeNoInfo(AdmInfo,PatientId,CardNO,TradeType,HospitalId,Expstr)
	}
	Set HisTradeNo=$p(rtn,"^",3)
	Set HisTradeAdm=$p(rtn,"^",4)
	Set HisTradeAmt=$p(rtn,"^",5)
	Set HisTradeAmt=$fn(HisTradeAmt,"",2)
	If (+rtn'=0) {
		Set outputObj.ResultCode=-2
	   	Set outputObj.ErrorMsg="生成订单号失败!"
		Do outputObj.XMLExportToString(.OutputXML,"Response")
		Do outputObj.%Close()
		}
	Quit:(+rtn'=0) OutputXML
	s outputObj.ResultCode=0
	s outputObj.ErrorMsg="生成订单号成功!"
	s outputObj.AdmId=HisTradeAdm
	s outputObj.PatientId=PatientId
	s outputObj.HisTradeNo=HisTradeNo
	s outputObj.HisTradeAmt=HisTradeAmt
	Do outputObj.XMLExportToString(.OutputXML,"Response")
	Do outputObj.%Close()
	
	Quit OutputXML
	;
AliPaySetTradeNoET
   	Set outputObj=##class(DHCAliPay.DHCEntity.PCA.HisTradeNoResponse).%New()
   	b 
   	Set outputObj.ResultCode=-10
   	Set outputObj.ErrorMsg="程序处理出错:"_$ZERROR
  	Set OutputXML=""
   	Do outputObj.XMLExportToString(.OutputXML,"Response")
   	Do outputObj.%Close()
	Quit OutputXML
}

/// w ##class(DHCAliPay.ChargeInterface.DHCOPBillAliPayExp).SetHisTradeNoInfo()
ClassMethod SetHisTradeNoInfo(Adm, PatientId, BankCardNO, BankTradeType, HospDR, ExpStr)
{
	New (Adm,PatientId, BankCardNO, BankTradeType, HospDR, ExpStr)
	Set ^DHCBillAliPay("SetHisTradeNoInfo",+$h,$p($h,",",2),"Input")=Adm_"%%"_PatientId_"%%"_BankCardNO_"%%"_BankTradeType_"%%"_HospDR_"%%"_ExpStr
	;user^3^交易来源^金额^原订单号
	Set Guser=$p(ExpStr,"^",1)
	Set TradeType=$p(ExpStr,"^",3)
	Set OldTradeId=$p(ExpStr,"^",5)  ;原订单号 没有传空
	Set TradeID=""
	Set RetCode=0
	TSTART
	;Insert DHC_INVAliTradePay
	Kill PLIST
	Set TradeDate=+$h
	Set TradeTime=$p($h,",",2)
	Set PLIST(22)=TradeDate		;IAP_TradeDate HIS交易日期
	Set PLIST(23)=TradeTime		;IAP_TradeTime	HIS交易时间
	Set PLIST(25)=TradeType
	Set PLIST(26)=Guser
	Set PLIST(27)=BankTradeType	;IAP_BankTradeType	银行交易类型
	;Set PLIST(28)=BankCode		;IAP_CardType	卡类型
	Set PLIST(29)=HospDR			;IAP_Hospital_Dr 医院指针
	Set PLIST(34)=OldTradeId		;原订单号
	Set PLIST(32)="alipay"
	Set PLIST(49)=PatientId
	Set myRtn=##class(web.DHCOPBillINVAliPay).INSERT()
	Set err=$p(myRtn,"^",1)
	Set IBPRowID=$p(myRtn,"^",2)
	;Set PLIST(4)=BankCardNO		;IAP_Pan	卡号
	;Set TradeDate=+$h
	;Set TradeTime=$p($h,",",2)
    ;&sql(insert into DHC_INVAliTradePay(IAP_TradeUser_DR,IAP_TradeType,IAP_Hospital_Dr)values (:Guser,:TradeType,:HospDR))
 	Set RetCode=RetCode+SQLCODE
 	;b ;0
 	If RetCode'=0  Do
 	.Trollback
	Quit:(RetCode'=0) RetCode
 	Set IBPRowID=$p($g(%ROWID),$c(1))
	Set TradeID=..SetTransactionId(IBPRowID,HospDR)	;生成HIS端交易号
    Set TradeID=$p(TradeID,$c(1))
    &sql(update DHC_INVAliTradePay set IAP_HISTradeID=:TradeID,IAP_Adm_DR=:Adm,IAP_Papmi_Dr=:PatientId where IAP_Rowid=:IBPRowID)
	Set RetCode=RetCode+SQLCODE
	;b ;1
	If RetCode'=0  Do
	.Trollback
	Quit:(RetCode'=0) RetCode
	;Set rtn=0
	Set billnostr=""
	If (+Adm'=0)&&(BankTradeType="C")  Do
	.Set ARPBLRowid="",myPBRowID=0,myPayedFlag=""
	.For  Set myPBRowID=$O(^DHCPB(0,"ADM", Adm, myPBRowID)) Quit:((myPBRowID="")!(myPayedFlag="B"))  Do
	..Set myPayedFlag=$p($g(^DHCPB(myPBRowID)),"^",16)
	..Quit:(myPayedFlag'="B")
	..Set ARPBLRowid=myPBRowID
	.If $g(ARPBLRowid)'=""  Do
	..If billnostr=""  Set billnostr=ARPBLRowid
	..Else  Set billnostr=billnostr_"^"_ARPBLRowid
	.Set gloc=$p($g(^SSU("SSUSR",Guser)),"^",4)
	.Set Grup=$p($g(^SSU("SSUSR",Guser)),"^",5)
	.Set OPGS=$o(^DHCOPGSi("GS",0,"GSDR",Grup,""))
	.Set RecLoc=""
	.If Grup'=""  d
	..Set RecLoc=##class(web.UDHCOPGSConfig).ReadRLByGPRowID(Grup,gloc)
	.Set TradeAmt=0
	.Set TBillCount=$l(billnostr,"^")
	.For i=1:1:TBillCount Do
	..;Quit:+rtn'=0
	..Set AdmBill=$p(billnostr,"^",i)
	..Set PBO="0"
	..For  Set PBO=$o(^DHCPB(AdmBill,"O",PBO))  Quit:PBO=""  Do
	...Quit:('$D(^DHCPB(AdmBill,"O",PBO)))||($d(^DHCPB(AdmBill,"O",PBO))=10)
	...Set PBord=$p($g(^DHCPB(AdmBill,"O",PBO)),"^",4)
	...Set AdmOrd=+PBord,Odritm=$p(PBord,"||",2)
	...Set OrdRecLoc=$p($g(^OEORD(AdmOrd,"I",Odritm,3)),"^",6)
	...Set OrdIns=$p($g(^OEORD(+AdmOrd,"I",Odritm,11)),"^",18)
	...Set Billed=$p($g(^OEORD(+PBord,"I",$p(PBord,"||",2),3)),"^",5)
	...Quit:(Billed="P")!(Billed="I")
	...Set OrdStat=$p($g(^OEORD(+PBord,"I",$p(PBord,"||",2),1)),"^",13)
	...Set:OrdStat'="" OrdStat=$p($g(^OEC("OSTAT",OrdStat)),"^",1)
	...Quit:(OrdStat'="V")&&(OrdStat'="E")
	...Set Limit=##class(web.UDHCOEORDOPIF).ReadSkinRtnFlag(PBord)   ;;;add by zhl 2010.03.02
	...;Set InsAdmSour=""
	...;Set:OrdIns'="" InsAdmSour=$p($g(^PAC("ADMREA",OrdIns)),"^",9)
	...Set LimitOrdIns=..GetLimtIns(OrdIns)
	...Quit:((RecLoc'="")&&(RecLoc'[OrdRecLoc))||(LimitOrdIns="Y")||(Limit="Y")
	...Set OrdStat=$p($g(^OEORD(+PBord,"I",$p(PBord,"||",2),1)),"^",13)
	...Set:OrdStat'="" OrdStat=$p($g(^OEC("OSTAT",OrdStat)),"^",1)
 	...Set armrowid=$p($g(^DHCPB(AdmBill,"O",PBO)),"^",3)
 	...Set armstatus=OrdStat
 	...Set price=$p($g(^DHCPB(AdmBill,"O",PBO)),"^",7)
 	...Set qty=$p($g(^DHCPB(AdmBill,"O",PBO)),"^",5)+$p($g(^DHCPB(AdmBill,"O",PBO)),"^",6)
 	...Set totalamt=$p($g(^DHCPB(AdmBill,"O",PBO)),"^",8) ;取自付金额？11
 	...Set discamount=$p($g(^DHCPB(AdmBill,"O",PBO)),"^",9)
 	...Set payorshare=$p($g(^DHCPB(AdmBill,"O",PBO)),"^",10)
 	...Set patientshare=$p($g(^DHCPB(AdmBill,"O",PBO)),"^",11)
 	...Set TradeAmt=TradeAmt+patientshare
 	...Set oeordrowid=PBord
    ...&sql(insert into DHC_INVAliTradeSub (IAD_IAP_ParRef,IAD_ArmDesc,IAD_ArmStatus,IAD_Price,IAD_Qty,IAD_TotalAmt,IAD_OEORDER,IAD_DiscAmount,IAD_PayorShare,IAD_PatientShare )values (:IBPRowID,:armrowid,:armstatus,:price,:qty,:totalamt,:oeordrowid,:discamount,:payorshare,:patientshare))
	...Set RetCode=+RetCode+SQLCODE ;add hu 14.7.4
	Else  Do
	.Set TradeAmt=$p(ExpStr,"^",4) ;挂号或者反交易取传入金额生成金额
	&sql(update DHC_INVAliTradePay set IAP_TradeAmt=:TradeAmt where IAP_Rowid=:IBPRowID)
 	Set RetCode=+RetCode+SQLCODE
 	If RetCode'=0  Do
 	.Trollback
 	Else  Do
 	.Tcommit
	Set rtn=RetCode_"^"_IBPRowID_"^"_TradeID_"^"_$g(Adm)_"^"_$g(TradeAmt)
	Quit rtn
}

ClassMethod SetTransactionId(IBPRowid, HospDR)
{
	n (IBPRowid, HospDR)
	i +HospDR=0 d
	.s HospCode="BJYY"
	e  d
	.s HospCode=$e($p(^CT("HOSP",HospDR),"^",1)	,0,4)
	s CurrDate=$zd(+$h,8)
	s CurrTime=$tr($zt($p($h,",",2),1),":","")
	s tmp="0000"
	s:$l(IBPRowid)>4 IBPRowid=$e(IBPRowid,$l(IBPRowid)-3,$l(IBPRowid))
	s FormatIBPRowid=$e(tmp,1,$l(tmp)-$l(IBPRowid))_IBPRowid
	s rtn=CurrDate_CurrTime_HospCode_FormatIBPRowid
	;s title=$zd(+$h,8)
	;s rtn=title_rtn
	q rtn
}

/// wangjian
/// 2014-07-08
/// 支付宝结算
/// w ##class(DHCAliPay.ChargeInterface.DHCOPBillAliPayExp).OPBillCharge(^DHCBillAliPay("OPBillCharge",63718,55014,"Input"))
ClassMethod OPBillCharge(Input As %String) As %GlobalCharacterStream
{
	;Set $zt="AliPayOPBillChargeET"
	New (Input)
	Set ^DHCBillAliPay("OPBillCharge",+$h,$p($h,",",2),"Input")=Input
    Set err=0,HospDR=""
    Set streamObj=##class(%GlobalCharacterStream).%New()
	Set inputObj=##class(DHCAliPay.DHCEntity.PCA.AliPayRequest).%New()
	Set AliTradeInfoObj=##class(DHCAliPay.DHCEntity.PCA.BankPayResult).%New()
    Do inputObj.XMLNodeDeserialize(.inputObj,"Request",Input)
    Set CardNO=inputObj.patientCard
    Set TerminalId=inputObj.terminalId
    Set TerminalType=inputObj.terminalType
    Set HospitalId=inputObj.hospitalId 
    Set PhoneNo=inputObj.phoneNo
    Set PatientId=inputObj.patientId 
    Set AdmInfo=inputObj.admId
    Set UserCode=inputObj.userCode
    Set PatPaySum=inputObj.patAmt 
    set HisTradeNo=inputObj.hisTradeNo
   
    Set AliTradeInfoObj=inputObj.bankTradeInfo
    b ;支付宝返回信息
    Set AliPayResultCode=AliTradeInfoObj.ResultCode ;交易结果,错误代码表0000：成功
    Set AliPayRevTranFlag=AliTradeInfoObj.RevTranFlag ;正反交易标志0-扣费，1-退费
    Set AliPayTradeNo=AliTradeInfoObj.BankTradeNo ;支付宝交易流水号
    Set AliPayAccountNo=AliTradeInfoObj.PayCardNo ;支付宝账户
    Set AliPayPaySum=AliTradeInfoObj.PayAmt ;扣款总金额
    Set AliPayHISTradeNo=AliTradeInfoObj.HISTradeNo ;HIS流水号--订单号
    Set AliPayPatientID=AliTradeInfoObj.PatientID ;病人登记号
    Set AliPayOrgHISTradeNo=AliTradeInfoObj.OrgHISTradeNo ;原交易流水号(暂不用)
    Set AliPayTradeDateTime=AliTradeInfoObj.BankDate
    Set AliPayTradeDate=$p(AliPayTradeDateTime," ",1)
    Set AliPayTradeTime=$p(AliPayTradeDateTime," ",2)
    If AliPayTradeDate'="" Set AliPayTradeDate=$zdh(AliPayTradeDate,3)
    If AliPayTradeTime'="" Set AliPayTradeTime=$zth(AliPayTradeTime,1)
    ;交易信息
 	s AliPayTradeInfo=AliPayHISTradeNo_"^"_AliPayPaySum_"^"_AliPayTradeNo_"^"_AliPayAccountNo_"^^"_AliPayTradeDate_"^"_AliPayTradeTime
    Do AliTradeInfoObj.%Close()
    Do inputObj.%Close()
    ;获取必要信息
    If UserCode="" Set UserCode="alipay001"
    ;Set UserCode="alipay001"
	Set TradeType="C"
	Set:UserCode'="" UserCode=$$ALPHAUP^SSUTIL4(UserCode)
	Set:UserCode'="" Userid=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,""))
	Set gLoc=$p($g(^SSU("SSUSR",Userid)),"^",4)
	Set Grup=$p($g(^SSU("SSUSR",Userid)),"^",5)
	Set OPGS=$o(^DHCOPGSi("GS",0,"GSDR",Grup,""))
	Set Expstr=Userid_"^3^OP"
	If HospitalId="" set HospitalId=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(gLoc) ;根据科室取院区 

    Set ChargeObj=##class(DHCAliPay.DHCEntity.PCA.AutoPayChargeResult).%New()
    Set OutputXML=""
    Set Paymode=$o(^CT("CTPM",0,"Code","ALIPAY",""))
    Set myPayinfo=Paymode_"^^^^"
    
    If (HisTradeNo=""){
		Set ChargeObj.ResultCode=-2
		Set ChargeObj.ErrorMsg="订单号不能为空"
		Do ChargeObj.XMLExportToString(.OutputXML,"Response")
		Do ChargeObj.%Close()
    }
   Quit:(HisTradeNo="") OutputXML
    
    
   ;根据订单取就诊
	Set IBPRowid=$o(^DHCINVALITPi(0,"PTN",HisTradeNo,""))
	Set IBPRc=""
	If (+IBPRowid'=0) {
		Set AdmInfo=$p(^DHCINVALITP(IBPRowid),"^",45)
		Set IBPRc=$p(^DHCINVALITP(IBPRowid),"^",1)
	}Else {
		Set AdmInfo="" 
		}
	If (IBPRc="0000"){
		Set ChargeObj.ResultCode=-4
	  	Set ChargeObj.ErrorMsg="此订单已经付款成功"
	   	Do ChargeObj.XMLExportToString(.OutputXML,"Response")
	   	Do ChargeObj.%Close()
		}
	
	Quit:(IBPRc="0000") OutputXML
	If (+IBPRowid=0) {
	Set ChargeObj.ResultCode=-3
	  	Set ChargeObj.ErrorMsg="无效订单号"
	  	b ;1
	  	set rollrtn=..RollBack(AliPayTradeInfo,Userid,TradeType,"",Paymode,"无效订单号",$g(AdmInfo))
	   	Do ChargeObj.XMLExportToString(.OutputXML,"Response")
	   	Do ChargeObj.%Close()
		}   
	Quit:(+IBPRowid=0) OutputXML
	
    If (+AdmInfo=0) {
		Set ChargeObj.ResultCode=-1
		Set ChargeObj.ErrorMsg="就诊记录不存在,不能结算"
		b ;2
		set rollrtn=..RollBack(AliPayTradeInfo,Userid,TradeType,"",Paymode,"就诊记录不存在",$g(AdmInfo))
		Do ChargeObj.XMLExportToString(.OutputXML,"Response")
		Do ChargeObj.%Close()	
	}
	Quit:(+AdmInfo=0) OutputXML
    
	;获取订单状态
	Set HisTradeNoStutas=..GetHisTradelockInfo(HisTradeNo)
	If (HisTradeNoStutas=1){
		Set ChargeObj.ResultCode=-5
		Set ChargeObj.ErrorMsg="此订单在交易中"
		Do ChargeObj.XMLExportToString(.OutputXML,"Response")
		Do ChargeObj.%Close()
	}
	If (HisTradeNoStutas=-1){
		Set ChargeObj.ResultCode=-6
		Set ChargeObj.ErrorMsg="此订单已交易失败"
		Do ChargeObj.XMLExportToString(.OutputXML,"Response")
		Do ChargeObj.%Close()
	}
	If (HisTradeNoStutas=0){
		Set ChargeObj.ResultCode=-4
		Set ChargeObj.ErrorMsg="此订单已经付款成功"
		Do ChargeObj.XMLExportToString(.OutputXML,"Response")
		Do ChargeObj.%Close()
	}
	Quit:(HisTradeNoStutas'="") OutputXML 
    
    Set rtn=..SetHisTradelockInfo(HisTradeNo,1)
    
    Set rtn=0
	Set TradeOrdStr=..GetInTradeSubOrd(HisTradeNo)
	/*
	Set RecLoc=""
	If Grup'=""  d
	.Set RecLoc=##class(web.UDHCOPGSConfig).ReadRLByGPRowID(Grup,gLoc)
	Set Adm="",AdmStr="",UnBillOrdStr="",CurIns=""
	;Set AdmInfo1=##class(web.DHCOPCashierIF).GetToDayAdmStr(Papmi,"N")
    For i=1:1:$l(AdmInfo,"^") Do
    .Set Adm=$p(AdmInfo,"^",i)
    .Quit:+Adm=0
	.Set AdmDate=$p($g(^PAADM(Adm)),"^",6)
	.;Quit:(AdmInfo'="")&&(("^"_AdmInfo_"^")'[("^"_Adm_"^"))
	.Set Visit=$p($g(^PAADM(Adm)),"^",20)
	.Quit:Visit'["A"
	.If AdmStr=""  Set AdmStr=Adm
	.Else  Set AdmStr=AdmStr_"^"_Adm
	.Set CurIns=$p(^PAADM(Adm,1),"^",7)
	.Set AdmOrd=$o(^OEORD(0,"Adm",Adm,""))
	.Set Odritm="0"
	.For  Set Odritm=$o(^OEORD(AdmOrd,"I",Odritm))  Quit:Odritm=""   Do
	..Set OrdRecLoc=$p($g(^OEORD(AdmOrd,"I",Odritm,3)),"^",6)
	..Set OrdIns=$p($g(^OEORD(+AdmOrd,"I",Odritm,11)),"^",18)
	..Set OEORDI=AdmOrd_"||"_Odritm
	..Set Limit=##class(web.UDHCOEORDOPIF).ReadSkinRtnFlag(OEORDI)   ;;;add by zhl 2010.03.02
	..;Set InsAdmSour=""
	..;Set:OrdIns'="" InsAdmSour=$p($g(^PAC("ADMREA",OrdIns)),"^",9)
	..;Set:(+InsAdmSour=0)&(CurIns="") CurIns=OrdIns
	..Set LimitOrdIns=..GetLimtIns(OrdIns)
	..Set TestOrder="^"_AdmOrd_"||"_Odritm_"^"
	..If ((RecLoc'="")&&(RecLoc'[OrdRecLoc))||(LimitOrdIns="Y")||(Limit="Y")||(TradeOrdStr'[TestOrder) Do
	...If UnBillOrdStr=""  Set UnBillOrdStr=OEORDI
	...Else  Set UnBillOrdStr=UnBillOrdStr_"^"_OEORDI	
    Set ExpStr=Grup_"^"_gLoc_"^"_""_"^Y^F^^0^"
    b ;1111
    ;Set rtn=##class(web.DHCOPINVCons).OPBillCharge(AdmStr, Userid, UnBillOrdStr, CurIns, PatPaySum, myPayinfo, gLoc, "0", "", "0",ExpStr)
	;Set ExpStr="N"_PayModeCode_"^"
	*/
	
	b ;开始结算
	Set ExpStr=Grup_"^"_gLoc_"^"_""_"^Y^F^^0^"
	If +PatientId=0 Set Papmi=$p(^PAADM(AdmInfo),"^",1)
	Else  Set Papmi=PatientId
	Set rtn=..OPOEORDBILLINLForAli(Papmi, AdmInfo, TradeOrdStr,PatPaySum, Userid,ExpStr) 
	;b ;2222
	b ;调用结算程序
    If rtn=0	Set ErrCode=rtn 
    If +rtn'=0	Set ErrCode=+rtn_":门诊结算失败"
    If +rtn=102	Set ErrCode="102:结算金额不符"
    If +rtn=101	Set ErrCode="101:没有门诊结算数据"
    If +rtn=112	Set ErrCode="112:判断舍入错误" 
    If (+rtn'=0) d
    .;更新支付信息,生成负交易(AdmInfo传空his交易失败)
 	.Set rollrtn=..RollBack(AliPayTradeInfo,Userid,TradeType,"",Paymode,ErrCode,$g(AdmInfo))
	.Set ChargeObj.ResultCode=+rtn
	.Set ChargeObj.ErrorMsg=ErrCode
	.Do ChargeObj.XMLExportToString(.OutputXML,"Response")
	.Do ChargeObj.%Close()
	Quit:+rtn'=0 OutputXML
	
	Set InvRowidStr=$p(rtn,$c(2),2)
    For i=2:1:$l(InvRowidStr,"^") Do
    .Set PrtInvRowid=$p(InvRowidStr,"^",i)
    .Quit:+PrtInvRowid=0
    .;获取发药窗口
    .Set WinInfo=""
    .;Set WinInfo=##class(web.UDHCOPINVPrtData12).GetPrescWinByPrtRowID(PrtInvRowid)
    .Set invAmt=##class(DHCAliPay.ChargeInterface.AliPayLogic).GetOPInvAliPayAmt(PrtInvRowid)
    .Set HospDR=""
  	.Set err=+rtn
  	.Set InvoiceObj=##class(DHCAliPay.DHCEntity.PCA.Invoice).%New()
    .Set InvoiceObj.TransactionId=HisTradeNo
 	.Set InvoiceObj.InvoiceNO=PrtInvRowid
 	.Set InvoiceObj.InvoiceAmt=$J(invAmt,3,2)
 	.Set InvoiceObj.PrescWindow=WinInfo
 	.;Set InvoiceObj.InvocieExpStr=""
 	.Do ChargeObj.Invoices.Insert(InvoiceObj)
 	.Do InvoiceObj.%Close()
 	/*
    ;
    If +err'=0 Do
    .;更新支付信息,生成负交易(AdmInfo传空his交易失败)
 	.Set rollrtn=..RollBack(AliPayTradeInfo,Userid,TradeType,InvRowidStr,Paymode,"His确认完成失败")
    .Set ChargeObj.ResultCode=-7
	.Set ChargeObj.ErrorMsg="收费确认完成失败"
    .For i=2:1:$l(InvRowidStr,"^") d
    ..Set PrtInvRowid=$p(InvRowidStr,"^",i)
    ..Quit:+PrtInvRowid=0
    ..Set rtn=##class(web.DHCBillConsIF).DelINVPRTForYB(PrtInvRowid,Grup)
    Else  Do
    */
    ;更新支付信息
 	Set rtn=..UpdateAliPayInfo(AdmInfo,AliPayTradeInfo,Userid,"",InvRowidStr,Paymode,"结算成功")
 	Set Mesrtn=##class(DHCAliPay.ChargeInterface.AliPayLogic).SendOrderMessageToAli(InvRowidStr)
 	Set rtn1=..SetHisTradelockInfo(HisTradeNo,0)
    Set ChargeObj.ResultCode=+rtn
	Set ChargeObj.ErrorMsg="结算成功" 
    ;
    Do ChargeObj.XMLExportToString(.OutputXML,"Response")
	Do ChargeObj.%Close()
    Quit OutputXML
    
AliPayOPBillChargeET
   	Set PatOrderObj=##class(DHCAliPay.DHCEntity.PCA.AutoPayChargeResult).%New()
   	Set PatOrderObj.ResultCode=-10
   	Set PatOrderObj.ErrorMsg="程序处理出错:"_$ZERROR
   	Set rollrtn=..RollBack(AliPayTradeInfo,Userid,TradeType,"",Paymode,"程序异常",$g(AdmInfo))
  	Set OutputXML=""
   	Do PatOrderObj.XMLExportToString(.OutputXML,"Response")
   	Do PatOrderObj.%Close()
	Quit OutputXML
}

/// wangjian
/// 2014-07-07
/// 根据医嘱费别,判断是否可以结算
/// 默认不受限N N(不受限可结算),Y(受限不可结算)
/// w ##class(DHCAliPay.ChargeInterface.DHCOPBillAliPayExp).GetLimtIns()
ClassMethod GetLimtIns(OrdIns)
{
	New (OrdIns)
	Set rtn="N"
	Set InsAdmSour=""
	Set:OrdIns'="" InsAdmSour=$p($g(^PAC("ADMREA",OrdIns)),"^",9)
	If (+InsAdmSour'=0)&&(+InsAdmSour'=1) Set rtn="Y" 
	Quit rtn
}

/// wangjian
/// 2014-07-07
/// 根据订单号返回交易子表医嘱串
/// w ##class(DHCAliPay.ChargeInterface.DHCOPBillAliPayExp).GetInTradeSubOrd()
ClassMethod GetInTradeSubOrd(HisTradeNo)
{
	New (HisTradeNo)
	Set OrdStr=""
	Set IbpRowid=$o(^DHCINVALITPi(0,"PTN",HisTradeNo,""))	
	Quit:(+IbpRowid=0) OrdStr
	Set IbsSub="0"
	For  Set IbsSub=$o(^DHCINVALITP(IbpRowid,"D",IbsSub)) Quit:IbsSub=""  Do
	.Set OrdStatus=$p(^DHCINVALITP(IbpRowid,"D",IbsSub),"^",4)
	.Quit:OrdStatus="D"
	.Set OEORIOrdId=$p(^DHCINVALITP(IbpRowid,"D",IbsSub),"^",1)
	.If OrdStr="" Set OrdStr="^"_OEORIOrdId_"^"
	.Else  Set OrdStr=OrdStr_OEORIOrdId_"^"
	
	Quit OrdStr
}

/// wangjian
/// 2014-07-07
/// 更新交易表
/// w ##class(DHCAliPay.ChargeInterface.DHCOPBillAliPayExp).InsertAliPayInfo(5750278,"BJYY1407041539110063^52.00",3788,"C","5928781","23")
/// ; His交易失败时候 AdmId传空 紧接着生成负交易 
/// ExpStr ：失败原因
ClassMethod UpdateAliPayInfo(AdmId, TradeInfo, UserId, TradeFlag, PrtStr, PaymDR, ExpStr)
{

 New (AdmId,TradeInfo,UserId,TradeFlag,PrtStr,PaymDR,ExpStr)
 Quit:(TradeInfo="") "-1^TradeInfoNull"
 ;his订单号^交易金额^支付宝交易流水号^支付宝账号^原支付流水号
 Set RetCode=0
 Set HisTradeNo=$p(TradeInfo,"^",1) 
 Set IBIRowid=$o(^DHCINVALITPi(0,"PTN",HisTradeNo,""))
 Quit:IBIRowid="" "-1^NoTradeNo"
 Set ConInvNum=##class(DHCAliPay.ChargeInterface.DHCOPBillAliPayExp).GetLinkInvNum(IBIRowid)
 Quit:+ConInvNum>0 "-2^HavePaid"
 Set AliTradeNo=$p(TradeInfo,"^",3) 
 Set AliAccManager=$p(TradeInfo,"^",4)
 Set AliTradeDate=$p(TradeInfo,"^",6) ;可以为空以异步为准
 If AliTradeDate="" Set AliTradeDate=+$h
 Set AliTradeTime=$p(TradeInfo,"^",7) ;可以为空以异步为准
 If AliTradeTime="" Set AliTradeTime=$p($h,",",2)
 Set AliChargeAmt=$p(TradeInfo,"^",2)
 Set Rc="0000"
 Set RcDetail="交易成功"
 TSTART
 &sql(update DHC_INVAliTradePay set IAP_txn_date =:AliTradeDate,IAP_txn_time=:AliTradeTime,IAP_Rc=:Rc,IAP_Rc_detail=:RcDetail,IAP_Tr_amt=:AliChargeAmt
               ,IAP_RRN=:AliTradeNo,IAP_Paymode=:PaymDR, IAP_Adm_DR=:AdmId,
               IAP_chargeno=:AliAccManager where IAP_Rowid=:IBIRowid)
               
 Set RetCode=RetCode+SQLCODE  
 If RetCode'=0  Do
 .Trollback 
 b ;b00,IAP_HISOldTradeID=:OldAliNo
 ;insert into DHC_INVAliConSub
 If RetCode=0 Do
 .Set prtLen=$l(PrtStr,"^")
 .For num=1:1:prtLen  Do
 ..Set PrtId=$p(PrtStr,"^",num)
 ..Quit:+PrtId=0
 ..Set sFlag="N"
 ..&sql(insert into DHC_INVAliConSub (IAS_IAP_ParRef,IAS_INVPRT_DR,IAS_Status) values (:IBIRowid,:PrtId,:sFlag))
 ..Set RetCode=RetCode+SQLCODE
 If RetCode'=0  Do
 .Trollback
 Else  Do
 .Tcommit
 ;;His 交易失败的话 发起负交易
 Set HospitalId=$p(^DHCINVALITP(IBIRowid),"^",28)
 Set Note=$p(ExpStr,"^",1)
 If (Note'["结算成功")&&(TradeFlag="C") Do
 .;his交易失败生成负交易
 .Set myExpStr=UserId_"^3^OP^"_HospitalId_"^"_Note
 .Set rtn=..RefundAliPay(HisTradeNo,AliChargeAmt,myExpStr)
 Quit RetCode_"^"_IBIRowid_"^"_Rc_"^"_RcDetail
}

/// wangjian
/// 2014-07-07
/// His交易失败支付宝退交易(供内部调用)
/// w ##class(DHCAliPay.ChargeInterface.DHCOPBillAliPayExp).RefundAliPay("20141125181827ZGYDYY5172","0.02","1334^3^OP^2^卡号为空")
/// ExpStr:Userid_"^3^OP^HospitalId^备注信息"
ClassMethod RefundAliPay(OldHisTradeNo As %String, RefundAmt As %String, ExpStr As %String) As %String
{
	n (OldHisTradeNo,RefundAmt,ExpStr)
	s ^DHCBillAliPay("RefundAliPay",+$h,$p($h,",",2),OldHisTradeNo,"Input")=OldHisTradeNo_"|"_RefundAmt_"|"_ExpStr
	s rtn=..RefundAliPayNew(OldHisTradeNo,RefundAmt,ExpStr)
	s ^DHCBillAliPay("RefundAliPay",+$h,$p($h,",",2),OldHisTradeNo,"Output")=rtn
	q rtn
}

/// wangjian
/// 2014-07-07
/// w ##class(DHCAliPay.ChargeInterface.DHCOPBillAliPayExp).RefundAliPayNew("20140910172750KM8791","7.50","2538^3^OP^5^调用异常")
ClassMethod RefundAliPayNew(OldHisTradeNo As %String, RefundAmt As %String, ExpStr As %String) As %String
{
	n (OldHisTradeNo,RefundAmt,ExpStr)
	s rtnstr=""	
	
	s TradeType="D"
	s Userid=$p(ExpStr,"^",1)
	s HospitalId=$p(ExpStr,"^",4)
	s gLoc=$p($g(^SSU("SSUSR",Userid)),"^",4)
	i HospitalId="" set HospitalId=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(gLoc) ;根据科室取院区 
	s IbpRowid=$o(^DHCINVALITPi(0,"PTN",OldHisTradeNo,""))	
	s AdmInfo=$p(^DHCINVALITP(IbpRowid),"^",45)
	s OldAliPayNo=$p(^DHCINVALITP(IbpRowid),"^",7)
	s CardNO=""
	s Patientid=$p(^DHCINVALITP(IbpRowid),"^",48)
	i Patientid="" s Patientid=$p(^PAADM(AdmInfo),"^",1)
	s PayMode=$p(^DHCINVALITP(IbpRowid),"^",46)
	;user^3^交易来源^金额^
	s myExpstr=Userid_"^3^OP"_"^"_RefundAmt_"^"_IbpRowid
	//update by zza
	s rtn=..SetHisTradeNoInfo(AdmInfo,"",CardNO,TradeType,HospitalId,myExpstr)
	q:+rtn'=0 "SetTradeErr"
	s HisTradeNo=$p(rtn,"^",3)
	s NewIbpRowid=$p(rtn,"^",2)
	;b ;;;;;;;;;下面信息待定
	;s inputstr=OldAliPayNo_"^"_RefundAmt_"^"_HisTradeNo_"^"_Patientid
	;s obj=DHCAliPay.DHCOPBillServiceSoap.%New()
	;s rtnstr=obj.PayReturnToZFB(inputsrt)  ;调用支付宝退费程序	
	;<?xml version='1.0' encoding='UTF-8'?><OrderPayReturn><trade_no>2014070137493957</trade_no><money>0.01</money><memo>东华退款测试</memo><batch_no>2014070137493959</batch_no><patientid>21341241</patientid></OrderPayReturn>
	;<?xml version='1.0' encoding='UTF-8'?><orderpayreturn><error></error><is_success>T</is_success><trade_no>交易号</trade_no><money>0.01</money><memo>东华退款测试</memo><batch_no>新订单</batch_no><patientid>21341241</patientid></orderpayreturn>
	s Mark=$p(ExpStr,"^",5)
	;b ;input
	s rtnstr=##Class(MHC.PublicPay).ReturnPay(OldAliPayNo,HisTradeNo,Patientid,RefundAmt,Mark)
	s ^DHCBillAliPay("RefundAliPayNew",+$h,$p($h,",",2),OldHisTradeNo,"Output")=rtnstr
	b ;rtnstr
	s AliObj=##class(DHCAliPay.DHCEntity.PCA.orderpayreturn).%New()
    d AliObj.XMLNodeDeserialize(.AliObj,"orderpayreturn",rtnstr)
    s Alierror=AliObj.error
    s Aliissuccess=AliObj.issuccess ;T 成功 F 失败
    s Alitradeno=AliObj.tradeno ;交易流水号
    s Alimoney=AliObj.money
    s Alimemo=AliObj.memo
    s Alibatchno=AliObj.batchno ;订单号
    s Alipatientid=AliObj.patientid
    ;q:Alibatchno'=OldHisTradeNo "batchnoErr"
	s PrtStr=""
	i Aliissuccess="T" d
	.;保存支付宝返回信息
	.s rtnstr=0
	.s ReTradeInfo=HisTradeNo_"^"_Alimoney_"^"_Alitradeno_"^"_""
	.s InsuFlag=""
	.;his订单号^交易金额^支付宝交易流水号^支付宝账号
	.s rtn=..UpdateAliPayInfo(AdmInfo,ReTradeInfo,Userid,TradeType,PrtStr,PayMode,"")
	e  d
	.s rtn=Alierror
	
	q rtn
}

/// w ##class(DHCAliPay.ChargeInterface.DHCOPBillAliPayExp).BILLN(1252360,2537)
ClassMethod BILLN(adm, billuser)
{
	s BabyFlag=##class(web.UDHCJFORDCHK).getmotheradm(adm)
	q:BabyFlag="true" 0
	s Num=##class(web.UDHCJFBaseCommon).JudgeBillNum(adm)
	q:Num>1 0
	s err=##class(web.UDHCJFBILL).BILL(adm,billuser)
	s err=$p(err,"^",1)
	Q 0
}

/// wangjian
/// 2014-07-13
/// 避免一次就诊未结算医嘱生成多次订单(先只针对收费)
/// 规则:根据当前就诊找未扣费成功的订单(oldtradeno),判断当前就诊未结算医嘱与oldtradeno金额是否相等
/// 如果金额相等情况下,oldtradeno子表医嘱完全包含当前未结算医嘱,此时返回oldtradeno信息不再生成新订单,否则生成新订单
/// w ##class(DHCAliPay.ChargeInterface.DHCOPBillAliPayExp).CheckRepeatTrade(1252405,"C",2537)
ClassMethod CheckRepeatTrade(Adm, BankTradeType, Guser)
{
	New (Adm,BankTradeType,Guser)
	;1 计算未结算医嘱金额 生成未结算医嘱串
	Set NewOrderStr="",billnostr=""
	If (+Adm'=0)&&(BankTradeType="C")  Do
	.Set ARPBLRowid="",myPBRowID=0,myPayedFlag=""
	.For  Set myPBRowID=$O(^DHCPB(0,"ADM", Adm, myPBRowID)) Quit:((myPBRowID="")!(myPayedFlag="B"))  Do
	..Set myPayedFlag=$p($g(^DHCPB(myPBRowID)),"^",16)
	..Quit:(myPayedFlag'="B")
	..Set ARPBLRowid=myPBRowID
	.If $g(ARPBLRowid)'=""  Do
	..If billnostr=""  Set billnostr=ARPBLRowid
	..Else  Set billnostr=billnostr_"^"_ARPBLRowid
	.Set gloc=$p($g(^SSU("SSUSR",Guser)),"^",4)
	.Set Grup=$p($g(^SSU("SSUSR",Guser)),"^",5)
	.Set OPGS=$o(^DHCOPGSi("GS",0,"GSDR",Grup,""))
	.Set RecLoc=""
	.If Grup'=""  d
	..Set RecLoc=##class(web.UDHCOPGSConfig).ReadRLByGPRowID(Grup,gloc)
	.Set TradeAmt=0
	.Set TBillCount=$l(billnostr,"^")
	.For i=1:1:TBillCount Do
	..;Quit:+rtn'=0
	..Set AdmBill=$p(billnostr,"^",i)
	..Set PBO="0"
	..For  Set PBO=$o(^DHCPB(AdmBill,"O",PBO))  Quit:PBO=""  Do
	...Quit:('$D(^DHCPB(AdmBill,"O",PBO)))||($d(^DHCPB(AdmBill,"O",PBO))=10)
	...Set PBord=$p($g(^DHCPB(AdmBill,"O",PBO)),"^",4)
	...Set AdmOrd=+PBord,Odritm=$p(PBord,"||",2)
	...Set OrdRecLoc=$p($g(^OEORD(AdmOrd,"I",Odritm,3)),"^",6)
	...Set OrdIns=$p($g(^OEORD(+AdmOrd,"I",Odritm,11)),"^",18)
	...Set Limit=##class(web.UDHCOEORDOPIF).ReadSkinRtnFlag(PBord)   ;;;add by zhl 2010.03.02
	...Set LimitOrdIns=..GetLimtIns(OrdIns)
	...Quit:((RecLoc'="")&&(RecLoc'[OrdRecLoc))||(LimitOrdIns="Y")||(Limit="Y")
	...Set OrdStat=$p($g(^OEORD(+PBord,"I",$p(PBord,"||",2),1)),"^",13)
	...Set:OrdStat'="" OrdStat=$p($g(^OEC("OSTAT",OrdStat)),"^",1)
	...Quit:(OrdStat'="V")&&(OrdStat'="E")
 	...Set armrowid=$p($g(^DHCPB(AdmBill,"O",PBO)),"^",3)
 	...Set armstatus=OrdStat
 	...Set price=$p($g(^DHCPB(AdmBill,"O",PBO)),"^",7)
 	...Set qty=$p($g(^DHCPB(AdmBill,"O",PBO)),"^",5)+$p($g(^DHCPB(AdmBill,"O",PBO)),"^",6)
 	...Set totalamt=$p($g(^DHCPB(AdmBill,"O",PBO)),"^",11) ;取自付金额？11
 	...Set TradeAmt=TradeAmt+totalamt
 	...If NewOrderStr="" Set NewOrderStr="^"_PBord_"^"
	...Else  Set NewOrderStr=NewOrderStr_PBord_"^"
	b ;2循环就诊找金额相等未成功订单
	Set RepeatFlag=0 ;找到重复订单号 置成1
	Set RtnIBPRowid=""
	;;;
	Set IBPRowid=""
	For  Set IBPRowid=$o(^DHCINVALITPi(0,"Adm",Adm,IBPRowid),-1) Quit:(IBPRowid="")!(RepeatFlag=1)  Do
	.Set IBPRc=$p(^DHCINVALITP(IBPRowid),"^",1)
	.Quit:IBPRc="0000"
	.Set IBPTradeAmt=$p(^DHCINVALITP(IBPRowid),"^",23)
	.Quit:+IBPTradeAmt'=+TradeAmt
	.Set IBPTradeNo=$p(^DHCINVALITP(IBPRowid),"^",32)
	.Set IBPOrderStr=..GetInTradeSubOrd(IBPTradeNo)
	.Set EquFlag=..CheckStrEqu(IBPOrderStr,NewOrderStr,"^")
	.Quit:+EquFlag=1
	.Set RepeatFlag=1
	.Set RtnIBPRowid=IBPRowid
	If RepeatFlag=1 {
		Set HisAdm=$p(^DHCINVALITP(RtnIBPRowid),"^",45)
		Set HisTradeNo=$p(^DHCINVALITP(RtnIBPRowid),"^",32)
		Set HisTradeAmt=$p(^DHCINVALITP(RtnIBPRowid),"^",23)
		Set rtn=0_"^"_RtnIBPRowid_"^"_HisTradeNo_"^"_HisAdm_"^"_HisTradeAmt
		}Else{
			Set rtn=-1
			}
	b ;add by wangjian 跨天要重新生成订单	
	If +rtn=0  Do
	.Set HisTradeNoIBPRowid=$p(rtn,"^",2)
	.Set HisTradeNoDate=$p(^DHCINVALITP(HisTradeNoIBPRowid),"^",21)
	.If HisTradeNoDate'=+$h Set rtn=-1
	;end	
	Quit rtn
}

/// wangjian
/// 2014-07-13
/// 判断Str1与Str2的所有不为空节点是否一致
/// 正反对比 Note1Flag Note2Flag 均为Y 返回0 否则 返回1(不完全一样)
/// w ##class(DHCAliPay.ChargeInterface.DHCOPBillAliPayExp).CheckStrIn("^1||1^1||2^1||3^","^1||3^1||2^1||1^","^")
ClassMethod CheckStrEqu(Str1, Str2, Delimiter)
{
	New (Str1,Str2,Delimiter)
	Set Note1Flag="Y" ,Note2Flag="Y"
	For i=1:1:$l(Str1,Delimiter) Quit:Note1Flag="N"  Do
	.Set Node1=$p(Str1,Delimiter,i)
	.Quit:Node1=""
	.Set Node1=Delimiter_Node1_Delimiter
	.If Str2'[(Node1) Set Note1Flag="N"
		
	For i=1:1:$l(Str2,Delimiter) Quit:Note2Flag="N"  Do
	.Set Node2=$p(Str2,Delimiter,i)
	.Quit:Node2=""
	.Set Node2=Delimiter_Node2_Delimiter
	.If Str1'[(Node2) Set Note2Flag="N"	
	
	If (Note1Flag="Y")&&(Note2Flag="Y") Set rtn=0
	Else  Set rtn=1
	
	Quit rtn
}

/// wangjian
/// 2014-07-16
/// 返回一笔交易的交易状态
/// -1 交易异常 0 已成功 1 交易中
ClassMethod GetHisTradelockInfo(HisTradeNO)
{
	New (HisTradeNO)
	Set rtn=$g(^DHCBillAliPay("HisTradeNOLock",HisTradeNO)) 
	Quit rtn
}

/// wangjian
/// 2014-07-16
/// 设置交易状态
/// -1 交易异常 0 已成功 1 交易中
ClassMethod SetHisTradelockInfo(HisTradeNO, Status)
{
	New (HisTradeNO,Status)
	Set ^DHCBillAliPay("HisTradeNOLock",HisTradeNO)=Status
	Quit 0
}

/// wangjian
/// 2014-07-16
/// 支付宝成功,His交易异常后续处理
/// 保存交易号,发起反交易
ClassMethod RollBack(AliPayTradeInfo, Userid, TradeType, InvRowidStr, Paymode, Reason, tAdmInfo As %String = "")
{
	
 New (AliPayTradeInfo,Userid,TradeType,InvRowidStr,Paymode,Reason,tAdmInfo)
 Set ^DHCBillAliPay("RollBack",+$h,$p($h,",",2),"Input")=AliPayTradeInfo_"%%%"_Userid_"%%%"_TradeType_"%%%"_InvRowidStr_"%%%"_Paymode_"%%%"_Reason
 Set Updatertn=..UpdateAliPayInfo(tAdmInfo,AliPayTradeInfo,Userid,TradeType,InvRowidStr,Paymode,Reason)
 Set HisTradeNo=$p(AliPayTradeInfo,"^",1)
 Set Setrtn=..SetHisTradelockInfo(HisTradeNo,-1)	
 Quit 0
}

/// 退费异步推送
/// w ##class(DHCAliPay.ChargeInterface.DHCOPBillAliPayExp).CheckAliRefundAsyn(^DHCBillAliPay("CheckAliRefundAsyn",63712,59999,"Input"))
ClassMethod CheckAliRefundAsyn(Input As %String) As %String
{
	//Set $ZT="CheckAliRefundAsynET"
    New (Input) 
    Quit:Input="" "-1^NoCheckInfo"
    Set ^DHCBillAliPay("CheckAliRefundAsyn",+$h,$p($h,",",2),"Input")=Input
    
    Set OutStr=0
    Set streamObj=##class(%GlobalCharacterStream).%New()
	Set inputObj=##class(DHCAliPay.DHCEntity.PCA.orderpayreturn).%New()
    Do inputObj.XMLNodeDeserialize(.inputObj,"OrderPayReturn",Input)
    
    Set CheckAliTradeNo=inputObj.tradeno
    Set CheckHisTradeNo=inputObj.outtradeno
    Set CheckAccManage=inputObj.buyeremail
    Set CheckTotalAmt=inputObj.totalfee
  
    Set CheckTradeDateTime=inputObj.gmtpayment
 
    Set:CheckTradeDateTime'="" CheckTradeDate=$zdh($p(CheckTradeDateTime," ",1),3)
    Set:CheckTradeDateTime'="" CheckTradeTime=$zth($p(CheckTradeDateTime," ",1))
    Set CheckStatus=inputObj.tradestatus
   
    Do inputObj.%Close()
   
    Set Err=0,ResultCode="",ResultContent=""
    If ($d(^DHCINVALITPi(0,"PTN",CheckHisTradeNo)))&&(CheckStatus="T")  Do
    
	.Set IBPRowid=$o(^DHCINVALITPi(0,"PTN",CheckHisTradeNo,""))
	.Set CheckPayM=$p(^DHCINVALITP(IBPRowid),"^",46)
	.If (+CheckPayM=0) Do 
	..Set CheckPayM=$o(^CT("CTPM",0,"Code","ALIPAY",""))
	.;Set CheckAsynNum=+$p(^DHCINVALITP(IBPRowid),"^",44)
	.Set CheckRc=$p(^DHCINVALITP(IBPRowid),"^",1)
	.Set CheckAdm=+$p(^DHCINVALITP(IBPRowid),"^",45)
	.Set CheckUser=$p(^DHCINVALITP(IBPRowid),"^",25)
	.set CheckPatientId=$p(^DHCINVALITP(IBPRowid),"^",48)
	.Set CheckAliStr=$g(CheckHisTradeNo)_"^"_$g(CheckTotalAmt)_"^"_$g(CheckAliTradeNo)_"^"_$g(CheckAccManage)_"^^"_$g(CheckTradeDate)_"^"_$g(CheckTradeTime)
	.Set CheckPrt=$g(^DHCBillAliPay("MZJF","HisTradeNOConPrt",CheckHisTradeNo))
	.Set rtn=##class(DHCAliPay.ChargeInterface.DHCOPBillAliPayExp).UpdateAliPayInfo(CheckAdm,CheckAliStr,CheckUser,"D",CheckPrt,CheckPayM,"")
	.Set Err=$p(rtn,"^",1)
	.Set IBPRowID=$p(rtn,"^",2)
	.Set ResultCode=$p(rtn,"^",3)
	.Set ResultContent=$p(rtn,"^",4)
	.If ((+Err'=0)&&(ResultCode'="0000")) Do
	..;s rtn=##class(web.DHCBillBankLogic).DeleteIBP(IBPRowID,"")	
	.Set NewPrtRowid=$p($g(^DHCBillAliPay("MZJF","HisTradeNOConPrt",CheckHisTradeNo)),"^",1)
	.Set AbortPrtRowID=$p($g(^DHCBillAliPay("MZJF","HisTradeNOConPrt",CheckHisTradeNo)),"^",2)
	.b ;;kk
	.If (Err=0) Do
	..Set PrtFireType=""
	..If +NewPrtRowid'=0 Set PrtFireType=$p(^DHCINVPRT(NewPrtRowid),"^",34)
	..If +AbortPrtRowID'=0 Set PrtFireType=$p(^DHCINVPRT(AbortPrtRowID),"^",34)
	..b ;;PrtFireType
	..If PrtFireType="R" Set Mark="退号" 
	..Else  If (PrtFireType="F")  Set Mark="退费"
	..Else  Set Mark="订单交易失败退费"
	..;Set Amt=##class(DHCAliPay.ChargeInterface.AliPayLogic).GetOPInvAliPayAmt(NewPrtRowid_"|"_AbortPrtRowID)
	..Set Message=Mark_"成功,退费金额"_CheckTotalAmt_"元,请注意查收!"
	..s OldIBPRowid=$p(^DHCINVALITP(IBPRowid),"^",33)
	..i (CheckPatientId="")&&(OldIBPRowid'="") d
	...s CheckPatientId=$p(^DHCINVALITP(OldIBPRowid),"^",48)
	..b ;gyongao1
	..Set Mesrtn=##class(MHC.PublicMessage).SendToAli(CheckPatientId,Message,"REFOUNDFEE","","")
	..;Set ^WANGJIAN("SendToAliErr",CheckPatientId,CheckHisTradeNo)=Mesrtn
	Quit:((+Err'=0)&&(ResultCode'="0000")) "-1003^"_ResultCode_"^"_ResultContent
	Quit:((+Err=0)&&(ResultCode'="0000")) "-1003^"_ResultCode_"^"_ResultContent
	Quit:((+Err'=0)&&(ResultCode="0000")) "-1002^"_err_"^支付宝交易成功,HIS更新交易记录记录失败"
	Quit Err_"^"_ResultCode_"^"_ResultContent
CheckAliRefundAsynET	
   	Set Err="-1^^"
	Quit Err
}

ClassMethod OPOEORDBILLINLForAli(PAPMIDR As %String, ADMStrInfo As %String, OEORDStr As %String, PatPaySum As %String, UserRID As %String, ExpStr As %String) As %String
{
	///重新发布内嵌接口
	n (PAPMIDR, ADMStrInfo, OEORDStr, PatPaySum, UserRID,ExpStr)
	
	;ADMStrInfo=AdmRowID1^AdmRowID2^
	;OEORDStr=^RowID1^RowID2^RowID3^
	s $ZT="ERROR^DHCSSERR"
	s GroupDr=$p(ExpStr,"^",1)
	s ULoadLocDR=$p(ExpStr,"^",2)
	s myrtn=0
	
	;计费参数输入有误退出
	;q:(PAPMIDR="") 2620_$c(2)_"^^^^"
	;q:(ADMStrInfo="") 2620_$c(2)_"^^^^"
	;q:(OEORDStr="") 2620_$c(2)_"^^^^"
	;s OEORDStr="^"_$g(OEORDStr)_"^"
	s myAllInsStr=""
	s mySum=0
	k ^TMPOPINSType($j)
	;1.获取患者的费别
	s myInsList=##class(web.DHCOPCashier).GetPatPrescTypeList(PAPMIDR,ADMStrInfo)
	s mylen=$l(myInsList,$c(2))
	f i=1:1:mylen  d
	.;s myInsDR=$p($p(myInsList,$c(2),i),"^",3)
	.s myInsDR=$p($p(myInsList,$c(2),i),"^",2)
	.s ^TMPOPINSType($j,"INS",myInsDR)=myInsDR			;费别
	.s ^TMPOPINSType($j,"INS",myInsDR,"PatSum")=0		;患者支付钱
	.s ^TMPOPINSType($j,"INS",myInsDR,"UB")=""			;Unbilled OEORI Str
	.s ^TMPOPINSType($j,"INS",myInsDR,"ADMUB")=""			;Unbilled OEORI Str
	.s ^TMPOPINSType($j,"INS",myInsDR,"BillStr")=""		;结算的OEORI串
	.s myUnBillStr=""		;不结算的
	.s myBillStr=""			;结算的
	.s myRtnStr=##class(web.udhcOPBill1).ReadUFAdmOrder(ADMStrInfo,myInsDR,"",GroupDr, ULoadLocDR)
	.s myAllInsStr=$g(myAllInsStr)_"^"_myRtnStr_"^"
	.s myRtnLen=$l(myRtnStr,"^")
	.f j=1:1:myRtnLen d
	..s myOERowID=$p(myRtnStr,"^",j)
	..q:(myOERowID="")
	..i ("^"_OEORDStr_"^")'[("^"_myOERowID_"^") d
	...s myUnBillStr=$g(myUnBillStr)_"^"_myOERowID
	..e  d
	...s myBillStr=$g(myBillStr)_"^"_myOERowID
	.s:(myUnBillStr'="") myUnBillStr=$g(myUnBillStr)_"^"
	.s:(myBillStr="") myBillStr=$g(myBillStr)_"^"
	.s ^TMPOPINSType($j,"INS",myInsDR,"UB")=myUnBillStr
	.s ^TMPOPINSType($j,"INS",myInsDR,"BillStr")=myBillStr
	.s myPatSum=..GetOEORDSum(myBillStr)
	.;b	;GetSum
	.s ^TMPOPINSType($j,"INS",myInsDR,"PatSum")=+$g(myPatSum)
	.s mySum=+$g(mySum)+$g(myPatSum)
	.;写UnBill字符串
	.s myBillStr=^TMPOPINSType($j,"INS",myInsDR,"BillStr")
	.s myAdmLen=$l(ADMStrInfo,"^")
	.f Idx=1:1:myAdmLen  q:(myBillStr="")  d
	..s myAdmRowID=$p(ADMStrInfo,"^",Idx)
	..q:(myAdmRowID="")
	..;$c(2)_myAdmRowID_$c(2)
	..s myOEORDDR=$o(^OEORD(0,"Adm",myAdmRowID,0))
	..s myCurAdmUBStr=""
	..s myBillStr=^TMPOPINSType($j,"INS",myInsDR,"BillStr")
	..q:(myBillStr="")
	..s myUnBillStr=$g(^TMPOPINSType($j,"INS",myInsDR,"UB"))
	..s myOELen=$l(myUnBillStr,"^")
	..s myOPUnBillStr=""
	..f OEIdx=1:1:myOELen  d
	...s myOERowID=$p(myUnBillStr,"^",OEIdx)
	...q:("^"_myOERowID)'[("^"_myOEORDDR_"||")		;当前OERowID,不是本次就诊退出
	...s myOPUnBillStr=myOPUnBillStr_myOERowID_"^"
	..s myOPUnBillStr="^"_myOPUnBillStr
	..s myAdmStr=$c(2)_myAdmRowID_$c(2)
	..s ^TMPOPINSType($j,"INS",myInsDR,"ADMUB")=$g(^TMPOPINSType($j,"INS",myInsDR,"ADMUB"))_myAdmStr_myOPUnBillStr_myAdmStr
	
	b	;102
	i (+PatPaySum'=mySum){
		k ^TMPOPINSType($j)
		q 102_$c(2)_"^^^^"			;金额不符
	}
	
	s myComFlag=0		;包含标志
	;验证医嘱串是否符合条件？？
	s mylen=$l(OEORDStr,"^")
	f i=1:1:mylen  q:(+myComFlag'=0)  d
	.s myBillOERowID=$p(OEORDStr,"^",i)
	.q:(myBillOERowID="")
	.i (myAllInsStr)'[("^"_myBillOERowID_"^") d
	..s myComFlag=1
	
	i (+myComFlag=1) {
		k ^TMPOPINSType($j)
		q:(+myComFlag=1) 2621_$c(2)_"^^^^^"		;传入的医嘱串不符合要求报错退出
	}
	
	;2.计算每个费别不结算的医嘱串, 费用总额, 
	
	;支付宝支付
	Set Paymode=$o(^CT("CTPM",0,"Code","ALIPAY",""))
	s Payinfo=Paymode_"^^^^"
	
	s myrtn=0
	d ..tb()
	;3.循环费别,记帐
	s myINVStr=""
	s myInsDR=0
	f  s myInsDR=$o(^TMPOPINSType($j,"INS",myInsDR)) q:(myInsDR="")!(+myrtn'=0)  d
	.s myBillStr=$g(^TMPOPINSType($j,"INS",myInsDR,"BillStr"))
	.s myUnBillStr=$g(^TMPOPINSType($j,"INS",myInsDR,"ADMUB"))
	.s myPatSum=$g(^TMPOPINSType($j,"INS",myInsDR,"PatSum"))
	.s mySFlag=0
	.s myOldINVRID=""
	.s myInsPayCtl=0
	.s myExpStr=GroupDr_"^"_ULoadLocDR_"^"_""_"^N^F"
	.q:((myBillStr="")!(myBillStr="^"))
	.b	;;;;OPBill
	.s myRtnStr=##class(web.DHCOPINVCons).OPBillCharge(ADMStrInfo, UserRID, myUnBillStr,myInsDR, myPatSum,Payinfo, GroupDr, mySFlag, myOldINVRID,myInsPayCtl,myExpStr)
	.s myRtnStr=$p(myRtnStr,$c(2),1)
	.s myrtn=+$p(myRtnStr,"^",1)
	.q:(+myrtn)
	.;确认完成
	.;s InvRowidStr=$p(myrtn,$c(2),1)
    .f i=2:1:$l(myRtnStr,"^") d  q:+ret'=0
    ..s PrtInvRowid=$p(myRtnStr,"^",i)
    ..q:+PrtInvRowid=0
	..s CTLocDR=ULoadLocDR
	..s GroupDR=GroupDr
	..s ExtUserID=$p(^DHCINVPRT(PrtInvRowid),"^",21)
	..s myExpStr=GroupDR_"^"_CTLocDR_"^"_""_"^Y^F^^0^^"
	..s ret=##class(web.DHCBillConsIF).CompleteCharge("7",ExtUserID,myInsDR,PrtInvRowid,"0","",myExpStr)
	..s myrtn=myrtn+ret
	.q:+myrtn'=0
	.s myStr=myRtnStr
	.s $p(myStr,"^",1)=""
	.s myINVStr=myINVStr_myStr
	
	i +myrtn=0  d ..tc()
	e  d
	.Trollback
	
	k ^TMPOPINSType($j)
	
	q myrtn_$c(2)_myINVStr
}

ClassMethod GetOEORDSum(OEORIStr As %String) As %String
{
	n (OEORIStr)
	
	;w ##class(web.udhcOPBillIF).GetOEORDSum("63||3^63||4^63||5")
	;w ##class(web.DHCOPCashier).GetPatPrescTypeList("12")
	;加入安全组判断，是否能够计费此医嘱
	
	s mySum=0
	s myrtn=0
	
	s mylen=$l(OEORIStr,"^")
	
	f i=1:1:mylen  q:(+myrtn'=0)  d
	.s myOERowID=$p(OEORIStr,"^",i)
	.q:(myOERowID="")
	.s OrderRowid=+myOERowID
	.s itemsub=$p(myOERowID,"||",2)
	.s statcode=""
	.s billed=$p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",5)
	.q:(billed="P")!(billed="I")
	.s itemstat=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",13)
	.i itemstat'="" d
	..s statcode=$p($g(^OEC("OSTAT",itemstat)),"^",1)
	.Q:((statcode'="V")&(statcode'="E"))
	.s InsTypeDR=$p(^OEORD(+OrderRowid,"I",itemsub,11),"^",18) ;OEORI_BBExtCode
	.Set JfCF=$o(^DHCTarC("CF",""))
	.If (InsTypeDR="")&(JfCF'="") Set InsTypeDR=$P(^DHCTarC("CF",JfCF),"^",3)
	.;PatType, InsType, ARCIMRowid, SttDate, PriorRowid, InstrRowid, LinkTo, OEPrice
	.;("","","205||1",+$h,"","","","")
	.s ArcimRowid=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",2)
	.s SttDate=+$h				;医嘱日期变为当前日期
	.s OEPrice=$p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",25)		;;取出P   价格 OE_OrdItem->OEORI_Price
	.s adm=$p(^OEORD(+OrderRowid),"^",1)
	.s hospID=##class(web.UDHCHospitalGroup).GetHospitalByAdm(adm)
	.s RCDRowID=$p($g(^PAADM(adm,"DHC")),"^",25)	
	.s oeore=""
	.s regLoc=""
	.s itmPriceExpStr=RCDRowID_"^"_myOERowID_"^"_oeore_"^"_adm_"^"_regLoc_"^"_""
	.s BillPrice=##class(web.UDHCJFPRICE).GetOrderPrice("",InsTypeDR,ArcimRowid,SttDate,"","","",OEPrice,hospID,itmPriceExpStr)
	.s Price=$P(BillPrice,"^",1)
	.q:+Price=0                   ;过滤价格为0的项目
	.s OrdDiscPrice=$P(BillPrice,"^",2)
	.s OrdInsPrice=$P(BillPrice,"^",3)
	.s OrdPatPrice=$P(BillPrice,"^",4)
	.s ConFac=##class(web.DHCOPCashier).GetUomConvFactor(ArcimRowid,myOERowID)
    .s refundqty=##class(web.DHCOutPhReturn).GetRetOrdQty(myOERowID,"") 
	.i refundqty'="" d
	..s refundqty=refundqty/ConFac		;部分退药数量转换为整包装?
	.else  d
	..s refundqty=0		;
	.s Price1=Price*ConFac	
	.s OrdDiscPrice1=OrdDiscPrice*ConFac
	.s OrdInsPrice1=OrdInsPrice*ConFac
	.;
	.s PackQty=$p($g(^OEORD(OrderRowid,"I",itemsub,9)),"^",4)
	.s ItemCatDR=$p(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1),"^",10) ;ARC_ItmMast->ARCIM_ItemCat_DR
	.s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)  ;ARC_ItemCat->ARCIC_OrderType
	.s Doseqty=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",12)		;OEORI_PhQtyOrd
	.i (OrderType="R")&(PackQty="") s PackQty=1
	.;药品去整包装单位数量OEORI_QtyPackUOM而非药品取OEORI_PHQtyOrd;
	.i ((OrderType="R")&(PackQty'="")) d
	..;s Doseqty=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",12)
	..;s PackQty=Doseqty
	.e  d 
	..s PackQty=Doseqty
	.s PackQty= PackQty-refundqty		;减去退的数量?
	.//modify 2013-07-18 chenxi 配液中心药品取药房接口程序
    .s OEFlag=$p($g(^OEORD(+OrderRowid,"I",itemsub,"DHC")),"^",16)
    .i OEFlag="Y"  d
    ..s PackQty=##class(web.DHCSTPIVAOUTCOMMON).GetPIVAOutValidQty(myOERowID)
    ..s PackQty=PackQty/ConFac
    .;
	.//modify 2014-11-17 收费项目有折扣系数时先把总金额、折扣金额、记账金额四舍五入后在计算自付金额
	.s PrcAmt=Price1*PackQty
	.s PrcAmt=##class(web.UDHCJFBILL).round(PrcAmt) 
	.s DiscAmt=OrdDiscPrice1*PackQty
	.s DiscAmt=##class(web.UDHCJFBILL).round(DiscAmt)
	.s InsAmt=OrdInsPrice1*PackQty
	.s InsAmt=##class(web.UDHCJFBILL).round(InsAmt)
	.s Amount=PrcAmt-DiscAmt-InsAmt
	.s mySum=+mySum+Amount
	
	s mySum=$fn(mySum,"",2)
	q mySum
}

/// wangjian
/// 2015-04-10
/// 获取交易记录关联发票的张数
/// Input:dhc_invbanktradepay的Rowid
/// w ##class(DHCAliPay.ChargeInterface.DHCOPBillAliPayExp).GetLinkInvNum(10)
ClassMethod GetLinkInvNum(IBIRowid)
{
	
	n (IBIRowid)
	s InvNum=0,IBSSub="0"
	f  s IBSSub=$o(^DHCINVALITP(IBIRowid,"C",IBSSub))  q:(IBSSub="")  d
 	.s InvPrtRowid=$p(^DHCINVALITP(IBIRowid,"C",IBSSub),"^",1)
 	.q:InvPrtRowid=""
 	.s InvNum=InvNum+1
 	
	q InvNum
}

ClassMethod tb()
{
 n SQLCODE
 TSTART  s SQLCODE=$zu(34)
 q
}

ClassMethod tc()
{
 n SQLCODE
 i $$intp^%qartp TCOMMIT  s SQLCODE=$zu(34)
 q
}

}
