Class web.DHCPE.CashierEx Extends %Persistent
{

/// debug: w ##class(web.DHCPE.CashierEx).GetSSPFlag(101911)
ClassMethod GetSSPFlag(InvoicId)
{
	s SSPFlag=0
	q:InvoicId="" SSPFlag
	s InvNo=$P($g(^DHCPEINVPRT(InvoicId)),"^",1)
	s FocusPrintID=""
	s FocusPrintID=$o(^User.DHCPEINVFocusPrtI("IFPINVDRIndex"," "_InvoicId,""))
	//s:InvNo[("DHCSSP") SSPFlag=1
	s:((InvNo[("DHCSSP"))||(InvNo["DHCDZP"))&&(FocusPrintID="") SSPFlag=1
	q SSPFlag
}

/// debug：w ##class(web.DHCPE.CashierEx).GetListInfo("25775,25776","")
ClassMethod GetListInfo(preAuditIds, listcount As %String, LocID)
{
	
	//d ##class(web.DHCPE.Cashier).FeeInfoCheck(preAuditIds,0)
	//d ##class(web.DHCPE.Cashier).FeeInfoCheckNew(preAuditIds,0)
	d ##class(web.DHCPE.Cashier).FeeInfoCheckMH(preAuditIds,0)
	
	s Job=$J
	s TotalAmt=0
	s j=1
	while(j<=$l(preAuditIds,",")){
		s preAuditId=$p(preAuditIds,",",j)
		s j=j+1
		continue:preAuditId=""
		s TotalAmt=TotalAmt+$P(^DHCPEPreA(preAuditId),"^",9)
	}
	s TotalAmt=$FN(TotalAmt,"",2)
	
	s PreItemID=""
  	f  s PreItemID=$O(^DHCPEOEITEMTemp(+preAuditIds,"OEITEM",PreItemID)) q:PreItemID=""  d //,"TARITEM",itmsub)
	.s OneAmount=0
	.s TARITEMSub=""
	.f  s TARITEMSub=$O(^DHCPEOEITEMTemp(+preAuditIds,"OEITEM",PreItemID,"TARITEM",TARITEMSub)) q:TARITEMSub=""  d
	..s Info=$G(^DHCPEOEITEMTemp(+preAuditIds,"OEITEM",PreItemID,"TARITEM",TARITEMSub))
	..
	..s TARITEMID=$P(Info,"^",1)
	..s OneAmount=+$P(Info,"^",4)
	..s OneAmount=$FN(OneAmount,"",2)
	..i $D(^DHCPEOEITEMTemp(+preAuditIds,"OEITEM",PreItemID,"SetsName")) d
	...s Desc="丙 "_$G(^DHCPEOEITEMTemp(+preAuditIds,"OEITEM",PreItemID,"SetsName"))
	...s Uom=""
	...s Qty=1
	...s ItemSort="1"
	..e  d
	...s YBCode=##class(web.DHCPE.Cashier).GetYBCode(TARITEMID)
	...s Desc=YBCode_" "_$p($g(^DHCTARI(TARITEMID)),"^",2)
	...s Uom=##class(web.DHCPE.Cashier).GetUomByTarItem(TARITEMID)
	...s Qty=$g(^DHCPEDataEx("DHCPEPreIOrdItem","Qty",PreItemID))
	...s ItemSort="2"
	..s ^TempDHCPEListInfo(Job,ItemSort,Desc,"OneAmt",OneAmount)=""
	..s ^TempDHCPEListInfo(Job,ItemSort,Desc,"Amt",OneAmount)=$G(^TempDHCPEListInfo(Job,ItemSort,Desc,"Amt",OneAmount))+OneAmount
	..s ^TempDHCPEListInfo(Job,ItemSort,Desc,"Qty",OneAmount)=$G(^TempDHCPEListInfo(Job,ItemSort,Desc,"Qty",OneAmount))+Qty
	..s ^TempDHCPEListInfo(Job,ItemSort,Desc,"Uom")=Uom

	s RoundFeeFlag=0
	;s:$D(^DHCPEOEITEMTemp(preAuditIds,"RoundInfo")) RoundFeeFlag=1
	k ^DHCPEOEITEMTemp(+preAuditIds)
	k ^DHCPEOEITEMAccAccTemp(+preAuditIds)
	
	s col=$g(^DHCPESetting("DHCPE","InvCol",LocID)) ;发票明细打印列数
	if col="" s col=1
	s invcolSet=^DHCPESetting("DHCPE","InvColSortType",LocID) ;发票明细显示顺序
	
	s InvNameMaxLen=+$g(^DHCPESetting("DHCPE","InvNameMaxLen"))
	
	s ItemInfos=""
	s listcount=0
	s Sort=""
	f  s Sort=$O(^TempDHCPEListInfo(Job,Sort)) q:Sort=""  d
	.s ItemName=""
	.f  s ItemName=$O(^TempDHCPEListInfo(Job,Sort,ItemName)) q:ItemName=""  d
	..s OneAmt=""
	..f  s OneAmt=$O(^TempDHCPEListInfo(Job,Sort,ItemName,"OneAmt",OneAmt)) q:OneAmt=""  d
	...i InvNameMaxLen>0 s ItemName=$e(ItemName,1,InvNameMaxLen)
	...s ItemQty=$G(^TempDHCPEListInfo(Job,Sort,ItemName,"Qty",OneAmt))
	...s ItemAmount=$G(^TempDHCPEListInfo(Job,Sort,ItemName,"Amt",OneAmt))
	...s ItemPrice=ItemAmount/ItemQty
	...s UOM=$G(^TempDHCPEListInfo(Job,Sort,ItemName,"Uom"))
	...i (listcount#col)=0  d
	....i ItemInfos'="" s ItemInfos=ItemInfos_$c(2)
	...e  d
	....i ItemInfos'="" s ItemInfos=ItemInfos_"^"
	...s ItemPrice=$FN(ItemPrice,"",2)
	...s ItemAmount=$FN(ItemAmount,"",2)
	...i RoundFeeFlag=1 d
	....s ItemPrice=TotalAmt
	....s ItemAmount=TotalAmt
	...//费用明细单上金额右对齐 start
	...i $L(ItemPrice)<9 d
	....s ItemPrice=$E("         "," ",8-$L(ItemPrice))_ItemPrice
	...i $L(ItemAmount)<9 d
	....s ItemAmount=$E("         "," ",8-$L(ItemAmount))_ItemAmount
	...//费用明细单上金额右对齐 end
	...i invcolSet=1 s ItemInfos=ItemInfos_ItemName_"^"_ItemQty_"^"_ItemPrice_"^"_ItemAmount
	...i invcolSet=2 s ItemInfos=ItemInfos_ItemName_"^"_UOM_"^"_ItemQty_"^"_ItemAmount
	...;i invcolSet=3 s ItemInfos=ItemInfos_ItemName_"^"_UOM_"^"_ItemQty_"^"_ItemPrice_"^"_ItemAmount
	...i invcolSet=3 s ItemInfos=ItemInfos_ItemName_"^^^^"_$c(2)_"^"_UOM_"^"_ItemQty_"^"_ItemPrice_"^"_ItemAmount   //小条打印格式
	...s listcount=listcount+1
	//s TotalAmt="合计:"_TotalAmt
	//s ItemInfos=ItemInfos_$c(2)_"___________________________________________^^^^"_TotalAmt
	//s ItemInfos=ItemInfos_$c(2)_"^"_"[甲:无自付,已:有自付,丙:全自付]"_"^^^"
	//s ItemInfos=ItemInfos_$c(2)_"____________________________________________________^^^^"_TotalAmt
	
	s ItemInfos=ItemInfos_$c(2)_"^^^^"_TotalAmt
	s ItemInfos=ItemInfos_$c(2)_"__________________________________^^^^"
	s ItemInfos=ItemInfos_$c(2)_"[甲:无自付,乙:有自付,丙:全自付]"_"^^^^"
	s ItemInfos=ItemInfos_$c(2)_"[限北京医保标示]^^^^"
	
	i ItemInfos'=""
	{
		s j=(listcount#col)
		for k=1:1:j s ItemInfos=ItemInfos_"^^^^"
	}
		
	k ^TempDHCPEListInfo(Job)
	q ItemInfos
}

/// w ##class(web.DHCPE.CashierEx).GetTextInfo("101802,101904")
ClassMethod GetTextInfo(preAuditIds, LocID)
{
	//s ^temp("DHCPE","GetTextInfo")=$lb(preAuditIds.LocID)
	s PaySum=0
	s j=1
	while(j<=$l(preAuditIds,",")){
		s preAuditId=$p(preAuditIds,",",j)
		s j=j+1
		continue:preAuditId=""
		s PaySum=PaySum+$P($g(^DHCPEPreA(preAuditId)),"^",9)
	}
	s OneID=+preAuditIds
	s NoPayed=""
	s PayedFlag=$P($g(^DHCPEPreA(OneID)),"^",14)
	s:PayedFlag="UNCHARGED" NoPayed="未结算"
	
	s InvNo=""
	S PAPBRowId=$O(^DHCPEPAPBR(0,"PADR",OneID,0)) 
	I PAPBRowId'="" d
	.s PBID=$p($g(^DHCPEPAPBR(PAPBRowId)),"^",2)
	.i PBID'="" s InvID=$o(^DHCPEINVPRT(0,"PB",PBID,0))
	.i InvID'="" s InvNo=$p($g(^DHCPEINVPRT(InvID)),"^",1)
	
	;RegNo  PatName PaySum  Date
	s CRMID=$P($g(^DHCPEPreA(OneID)),"^",2)
	s Type=$P($g(^DHCPEPreA(OneID)),"^",1)
	i Type="I" d
	.s BaseID=$P($g(^DHCPEPreIADM(CRMID)),"^",1)
	.s RegNo=$P($g(^DHCPEPreIBI(BaseID)),"^",1)
	.s PatName=$P($g(^DHCPEPreIBI(BaseID)),"^",2)
	e  d
	.s BaseID=$P($g(^DHCPEPreGADM(CRMID)),"^",1)
	.s RegNo=$P($g(^DHCPEPreGBI(BaseID)),"^",13)
	.s PatName=$P($g(^DHCPEPreGBI(BaseID)),"^",2)
	s c=$c(2)
	s PatNameHead=$e(PatName,1,10)
	s PatNameExt=$e(PatName,11,$l(PatName))
	
	s HospitalName=""
	s HOSPID=##class(web.DHCPE.CT.DHCPEMappingLoc).GetHospIDByLocID(LocID)
    s HospitalName=##class(web.DHCPE.DHCPECommon).GetHospitalName(HOSPID)
	
	s Info="RegNo"_c_RegNo_"^PatName"_c_PatNameHead_"^PatNameExt"_c_PatNameExt_"^Date"_c_$ZD($H,3)_"^PaySum"_c_PaySum_"^NoPayed"_c_NoPayed_"^InvNo"_c_InvNo_"^HospitalName"_c_HospitalName

	q Info
}

/// 0:不打印发票，不走发票号
/// 1:打印发票，走发票号
ClassMethod NeedPrintInv(PaymodeStr)
{
	;s ret=##class(web.DHCPE.CashierEx).NeedPrintInv("&673.00&21^^^^^200&1^^^^^473#")
	s InvFlag=0
	s DHCPayMode=""
	s PayModeLength=$L(PaymodeStr,"&")
	;b ;PayModeLength
	f i=3:1:PayModeLength  d
	.s OnePayMode=$P(PaymodeStr,"&",i)
	.s PayMode=+OnePayMode
	.s PayCode=$P(^CT("CTPM",PayMode),"^",1)
	.;b ;PayCode
	.;i '(PayCode[("TJ")) s InvFlag=1
	.;s:(PayCode[("TJ")) DHCPayMode=PayCode
	.i (('(PayCode[("TJDJK")))||('(PayCode[("TJYJJ")))) s InvFlag=1
	.s:((PayCode[("TJDJK")||(PayCode[("TJYJJ")))) DHCPayMode=PayCode
	q InvFlag_"^"_DHCPayMode
}

ClassMethod GetInvAmountInfo(InvID)
{
	;w ##class(web.DHCPE.CashierEx).GetInvAmountInfo(370)
	s Amt=0
	s ModeStr=""
	s ArrcpID=$P(^DHCPEINVPRT(InvID),"^",4)
	s PayModeSub=0
	f  s PayModeSub=$O(^ARRCP(ArrcpID,"PAYM",PayModeSub)) q:PayModeSub=""  d
	.s PayModeID=$P(^ARRCP(ArrcpID,"PAYM",PayModeSub),"^",1)
	.s Flag=..NeedPrintInv("&&"_PayModeID)
	.s:+Flag=0 NoPrintFlag=1
	.q:+Flag=0
	.s PrintFlag=1
	.s PayDesc=$P(^CT("CTPM",PayModeID),"^",2)
	.s ChequeNo=$P(^ARRCP(ArrcpID,"PAYM",PayModeSub),"^",4)
	.s OneAmt=$P(^ARRCP(ArrcpID,"PAYM",PayModeSub),"^",3)
	.s Amt=Amt+OneAmt
	.s OneInfo=PayDesc_":"_$J(OneAmt,"",2)
	.;i ChequeNo'="" d
	.;.s OneInfo=OneInfo_"("_ChequeNo_")"
	.i ModeStr="" d
	..s ModeStr=OneInfo
	.e  d
	..s ModeStr=ModeStr_" "_OneInfo
	s Amt=$J(Amt,"",2)
	q Amt_"^"_ModeStr
}

ClassMethod GetDropPaymodeInfo(PayModeInfo, RefInvID)
{
	;w ##class(web.DHCPE.CashierEx).GetDropPaymodeInfo(PayModeInfo,RefInvID)
	s PayedModeLength=$l(PayModeInfo,"^")
	f i=1:1:PayedModeLength  d
	.s OneInfo=$p(PayModeInfo,"^",i)
	.s OnePayMode=$p(OneInfo,",",1)
	.s NewPayMode=$p(OneInfo,",",5)
	
	.s OnePayModeCode="",NewPayModeCode=""
	.i OnePayMode'="" s OnePayModeCode=$p($g(^CT("CTPM",OnePayMode)),"^",1)
	.i NewPayMode'="" s NewPayModeCode=$p($g(^CT("CTPM",NewPayMode)),"^",1)
	.s ssrAmont=##class(web.DHCPE.Cashier).GetssrAmountByInv(RefInvID)
	.i (OnePayModeCode="CASH")&&(NewPayModeCode'="CASH")&&(ssrAmont'=0) d
	..;s $p(OneInfo,",",2)=$p(OneInfo,",",2)-ssrAmont

	.s NewNo=$P(OneInfo,",",3)
	.s OtherNo=..GetOldOtherNo(RefInvID,OnePayMode)
	.s:NewNo="" $P(OneInfo,",",3)=OtherNo
	.s:NewPayMode'="" $P(OneInfo,",",1)=NewPayMode
	.s $P(PayModeInfo,"^",i)=OneInfo
	q PayModeInfo
}

/*
ClassMethod GetDropPaymodeInfo(PayModeInfo, RefInvID)
{
	;w ##class(web.DHCPE.CashierEx).GetDropPaymodeInfo(PayModeInfo,RefInvID)
	s PayedModeLength=$l(PayModeInfo,"^")
	f i=1:1:PayedModeLength  d
	.s OneInfo=$p(PayModeInfo,"^",i)
	.s OnePayMode=$p(OneInfo,",",1)
	.s OtherNo=..GetOldOtherNo(RefInvID,OnePayMode)
	.s $P(OneInfo,",",3)=OtherNo
	.s $P(PayModeInfo,"^",i)=OneInfo
	q PayModeInfo
}
*/
ClassMethod GetOldOtherNo(RefInvID, PayMode)
{
	s ArrcpID=$P(^DHCPEINVPRT(RefInvID),"^",4)
	s OtherNo=""
	s PayModeSub=0
	f  s PayModeSub=$O(^ARRCP(ArrcpID,"PAYM",PayModeSub)) q:(PayModeSub="")||(OtherNo'="")  d
	.s PayModeID=$P(^ARRCP(ArrcpID,"PAYM",PayModeSub),"^",1)
	.i PayModeID=PayMode d
	..s OtherNo=$P(^ARRCP(ArrcpID,"PAYM",PayModeSub),"^",4)
	q OtherNo
}

/// debug: w ##class(web.DHCPE.CashierEx).UpdatePayModeAmtByRefInv(370)
ClassMethod UpdatePayModeAmtByRefInv(RefInvID, UserID As %String = "", locId As %String = "")
{
	
	s errs=""
	s ArrcpID=$P($g(^DHCPEINVPRT(RefInvID)),"^",4)
	s BillId=$P($g(^DHCPEINVPRT(RefInvID)),"^",3)
	s AdmId=$P($g(^DHCPEINVPRT(RefInvID)),"^",2)
	s InvID=$P($g(^DHCPEINVPRT(RefInvID)),"^",9)
	s InvBillId=$P($g( ^DHCPEINVPRT(InvID)),"^",3)
	s PayModeSub=0
	f  s PayModeSub=$O(^ARRCP(ArrcpID,"PAYM",PayModeSub)) q:(PayModeSub="")||(errs'="")  d
	.s PayModeID=$P($g(^ARRCP(ArrcpID,"PAYM",PayModeSub)),"^",1)
	.s PayModeCode=$P($g(^CT("CTPM",PayModeID)),"^",1)
	.s ChequeNo=$P($g(^ARRCP(ArrcpID,"PAYM",PayModeSub)),"^",4)
	.s OneAmt=$P($g(^ARRCP(ArrcpID,"PAYM",PayModeSub)),"^",3)
	.i PayModeCode="TJYJJ" d
	..;s APID=##class(web.DHCPE.AdvancePayment).GetUseID(AdmId,PayModeCode,"N")
	..s APID=##class(web.DHCPE.AdvancePayment).GetUseIDByPBDR(InvBillId,PayModeCode,"N")
	..s:APID="" errs="预交金帐户不存在"
	..q:APID=""
	..s strings=APID_"^"_(-OneAmt)_"^"_BillId_"^^"  //为了和门诊、住院退费保持一致，字段APAC_SourceNo都存账单ID
	..;s strings=APID_"^"_(-OneAmt)_"^"_RefInvID_"^^"
	..s errs=##class(web.DHCPE.AdvancePayment).InsertAPAC(strings,"CF")
	.i PayModeCode="TJDJK" d
	..s APID=##class(web.DHCPE.AdvancePayment).GetUseID(ChequeNo,PayModeCode,"N")
	..s:APID="" errs="储值卡帐户不存在"
	..q:APID=""
	..s strings=APID_"^"_(-OneAmt)_"^"_BillId_"^^" //为了和门诊、住院退费保持一致，字段APAC_SourceNo都存账单ID
	..;s strings=APID_"^"_(-OneAmt)_"^"_RefInvID_"^^"
	..s errs=##class(web.DHCPE.AdvancePayment).InsertAPAC(strings,"CF")
	.i (PayModeCode="TJGBK")||(PayModeCode="TJZKK") d
	..s APID=##class(web.DHCPE.AdvancePayment).GetUseID(AdmId,PayModeCode,"F")
	..s:APID="" errs="没有可使用帐户"
	..q:APID=""
	..s strings=APID_"^N^退费产生,退费发票号^"_RefInvID
	..s errs=##class(web.DHCPE.AdvancePayment).UpdateData("3",strings)
	..if $p(errs,"^",1)'="0" d
	...s errs="修改卡状态错误"
	..e  d
	...s errs=""
	.i PayModeCode="CPP" d
	..s papmi=$P($g(^PAADM(AdmId)),"^",1)
	..s CardNo=$P($g(^ARRCP(ArrcpID,"PAYM",PayModeSub)),"^",20) ;账户ID
	..s errs=##class(web.DHCPE.DHCQseXmComm).ReduDepos(UserID,papmi,CardNo,OneAmt,RefInvID,locId)
	..s:+errs=0 errs=""

	q errs
}

/// Description: 根据发票ID更新门诊预交金表、体检预交金表dhc_pe_apamountchange
/// Input:       InvID:发票ID, UserID:用户ID,locId:科室ID
/// Return：
/// Debug: W ##class(web.DHCPE.CashierEx).UpdatePayModeAmt()
ClassMethod UpdatePayModeAmtByInv(InvID, UserID As %String = "", locId As %String = "")
{
	s errs=""
	s ArrcpID=$P($g(^DHCPEINVPRT(InvID)),"^",4) //支付方式ID
	s BillId=$P($g(^DHCPEINVPRT(InvID)),"^",3)  //账单ID
	s AdmId=$P($g(^DHCPEINVPRT(InvID)),"^",2)   //就诊ID
	i locId="" s locId=$p($g(^PAADM(AdmId)),"^",4) //就诊科室ID
	s HospID=##class(web.DHCPE.CT.DHCPEMappingLoc).GetHospIDByLocID(locId) //院区ID
	s PayModeSub=0
	f  s PayModeSub=$O(^ARRCP(ArrcpID,"PAYM",PayModeSub)) q:(PayModeSub="")||(errs'="")  d
	.s PayModeID=$P($g(^ARRCP(ArrcpID,"PAYM",PayModeSub)),"^",1)
	.s PayModeCode=$P($g(^CT("CTPM",PayModeID)),"^",1)
	.s ChequeNo=$P($g(^ARRCP(ArrcpID,"PAYM",PayModeSub)),"^",4)
	.s OneAmt=$P($g(^ARRCP(ArrcpID,"PAYM",PayModeSub)),"^",3)
	.i PayModeCode="TJYJJ" d
	..s APID=##class(web.DHCPE.AdvancePayment).GetUseID(AdmId,PayModeCode,"N")
	..s strings=APID_"^"_(-OneAmt)_"^"_BillId_"^^"
	..s errs=##class(web.DHCPE.AdvancePayment).InsertAPAC(strings,"C",UserID,locId,"N",HospID)
	.i PayModeCode="TJDJK" d
	..s APID=##class(web.DHCPE.AdvancePayment).GetUseID(ChequeNo,PayModeCode,"N")
	..s strings=APID_"^"_(-OneAmt)_"^"_BillId_"^^"
	..s errs=##class(web.DHCPE.AdvancePayment).InsertAPAC(strings,"C",UserID,locId,"N",HospID)
	.i (PayModeCode="TJGBK")||(PayModeCode="TJZKK") d
	..s APID=##class(web.DHCPE.AdvancePayment).GetUseID(AdmId,PayModeCode,"N")
	..s strings=APID_"^F^收费产生,账单号为^"_BillId
	..s errs=##class(web.DHCPE.AdvancePayment).UpdateData("3",strings,UserID,locId,HospID)
	..if $p(errs,"^",1)'="0" d
	...s errs="修改卡状态错误"
	..e  d
	...s errs=""
	.i PayModeCode="CPP" d
	..s papmi=$P($g(^PAADM(AdmId)),"^",1)
	..s CardNo=$P($g(^ARRCP(ArrcpID,"PAYM",PayModeSub)),"^",20)  ;账户ID
	..s errs=##class(web.DHCPE.DHCQseXmComm).ReduDepos(UserID,papmi,CardNo,OneAmt,InvID,locId)
	..s:+errs=0 errs=""
	q errs
}

// 得到默认计费项对应的分类金额

// 不打印分类明细时，打印设置的医嘱名称

ClassMethod GetFeeCatInfo(Amount)
{
	s c=$C(2)
	s LocID=%session.Get("LOGON.CTLOCID")
	
	/*
	s TARITEMID=$G(^DHCPESetting("DHCPE","SetsDefaultTar",LocID))
	s OneInfo=##class(web.DHCPE.Cashier).GetTarOC(TARITEMID,"N")
	s TarOCID=$P(OneInfo,"^",1)
	s TarOCDesc=$P(OneInfo,"^",2)
	*/
	//s InvFeeID=$G(^DHCPESetting("DHCPE","Group'sOEArcItemId"))
	s InvFeeID=$G(^DHCPESetting("DHCPE","Group'sOEArcItemId",LocID))
	s OneTar=..GetOneTarItem(InvFeeID)
	//s OneInfo=##class(web.DHCPE.Cashier).GetTarOC(OneTar,"N")
	s OneInfo=##class(web.DHCPE.Cashier).GetTarOC(OneTar,"N",LocID)
	s TarOCID=$P(OneInfo,"^",1)
	s TarOCDesc=$P(OneInfo,"^",2)
	
	s Fee=$FN(Amount,"",2)_"元"
	s i=1
	;发票xml中没写明分类标签名称，只是写了标签
	s CatRtn="^"_"Fee"_i_c_Fee_"^"_"FeeLab"_i_c_TarOCDesc
	;发票xml中写明分类标签名称，Setting里面设置了数据对应的标签名称
	;s LabelName=$G(^DHCPESetting("DHCPE","InvFeeCat",TarOCID))
	;s CatRtn="^"_LabelName_c_Fee
	
	q CatRtn
}

// 得到医嘱项对应的收费项

// w ##class(web.DHCPE.CashierEx).GetOneTarItem("4||1")

ClassMethod GetOneTarItem(arcitmid)
{
	s retStr=""
	s TarItem=0
	f  s TarItem=$o(^DHCOLT(0,"ARTTA",arcitmid,TarItem)) q:TarItem=""  d
	.s StartDate=0
	.f  s StartDate=$o(^DHCOLT(0,"ARTTA",arcitmid,TarItem,StartDate)) q:(StartDate="")||(StartDate>+$H)  d
	..s OLTID=0
	..f  s OLTID=$o(^DHCOLT(0,"ARTTA",arcitmid,TarItem,StartDate,OLTID)) q:OLTID=""  d
	...s EndDate=$p(^DHCOLT(OLTID),"^",5)
	...q:(EndDate'="")&&(EndDate<+$H)
	...s retStr=TarItem
	q retStr
}

// w ##class(web.DHCPE.CashierEx).GetTarItemCount(101911)

ClassMethod GetTarItemCount(preAuditIds)
{
	s Job=$J
	k ^TempDHCPEListInfo(Job)
	
	s PreItemID=""
  	f  s PreItemID=$O(^DHCPEOEITEMTemp(+preAuditIds,"OEITEM",PreItemID)) q:PreItemID=""  d //,"TARITEM",itmsub)
	.s TARITEMSub=""
	.f  s TARITEMSub=$O(^DHCPEOEITEMTemp(+preAuditIds,"OEITEM",PreItemID,"TARITEM",TARITEMSub)) q:TARITEMSub=""  d
	..s Info=$G(^DHCPEOEITEMTemp(+preAuditIds,"OEITEM",PreItemID,"TARITEM",TARITEMSub))
	..s TARITEMID=$P(Info,"^",1)
	..i $D(^DHCPEOEITEMTemp(+preAuditIds,"OEITEM",PreItemID,"SetsName")) d
	...s Desc="丙 "_$G(^DHCPEOEITEMTemp(+preAuditIds,"OEITEM",PreItemID,"SetsName"))
	...s ItemSort="1"
	..e  d
	...s YBCode=##class(web.DHCPE.Cashier).GetYBCode(TARITEMID)
	...s Desc=YBCode_" "_$p($g(^DHCTARI(TARITEMID)),"^",2)
	...s ItemSort="2"
	..s ^TempDHCPEListInfo(Job,ItemSort,Desc)=""
	.b ;003
	
	s listcount=0
	s Sort=""
	f  s Sort=$O(^TempDHCPEListInfo(Job,Sort)) q:Sort=""  d
	.s ItemName=""
	.f  s ItemName=$O(^TempDHCPEListInfo(Job,Sort,ItemName)) q:ItemName=""  d
	..s listcount=listcount+1
		
	k ^TempDHCPEListInfo(Job)
	
	q listcount
}

ClassMethod OutRoundType(ContrlWidth As %String = "")
{
	;d ##class(web.DHCPE.CashierEx).OutRoundType(125)
	s:(""=ContrlWidth) ContrlWidth="125"
	w "<select name='RoundType' id='RoundType' style='width:"_ContrlWidth_"' HEIGHT=0>",!
	w "<option value='1'>"_..GetRoundTypeDesc(1)_"</option>",!
	w "<option value='2'>"_..GetRoundTypeDesc(2)_"</option>",!
	w "<option value='3'>"_..GetRoundTypeDesc(3)_"</option>",!
	w "<option value='4'>"_..GetRoundTypeDesc(4)_"</option>",!
	w "</select>",!
}

ClassMethod GetRoundTypeDesc(RoundType)
{
	q:RoundType="1" "定额卡"
	q:RoundType="2" "西院交费"
	q:RoundType="3" "换套餐补费"
	q:RoundType="4" "其他"
	q ""
}

ClassMethod GetRoundFee(InvID)
{
	q:InvID="" ""
	s FH=1
	s RefInvID=$P(^DHCPEINVPRT(InvID),"^",9)
	i RefInvID'="" d
	.s FH=-1
	.s InvID=RefInvID
	s RetInfo=""
	s PreItemID=""
	f  s PreItemID=$O(^DHCPEOEITEM(InvID,"RoundInfo",PreItemID)) q:PreItemID=""  d
	.s OneInfo=$G(^DHCPEOEITEM(InvID,"RoundInfo",PreItemID))
	.s RoundType=$P(OneInfo,"^",1)
	.s RoundType=..GetRoundTypeDesc(RoundType)
	.s RoundRemak=$P(OneInfo,"^",2)
	.s RoundFee=$P(OneInfo,"^",3)
	.i RetInfo="" d
	..s RetInfo=RoundType_"^"_RoundRemak_"^"_RoundFee
	.e  d
	..s RetInfo=RetInfo_"$$"_RoundType_"^"_RoundRemak_"^"_RoundFee
	q RetInfo
}

// w ##class(web.DHCPE.CashierEx).GetProveInfo(731)

ClassMethod GetProveInfo(InvID)
{
	//基本信息
	s FocusPrintID=$o(^User.DHCPEINVFocusPrtI("IFPINVDRIndex"," "_InvID,""))
	s invNo=$p($g(^DHCPEINVPRT(InvID)),"^",1)
	i FocusPrintID'="" d
	.s invNo=$LG(^User.DHCPEINVFocusPrtD(FocusPrintID),3)
	
	s invdate=$p($g(^DHCPEINVPRT(InvID)),"^",11)
	//真实打印日期
	i FocusPrintID'="" d
	.s invdate=$LG(^User.DHCPEINVFocusPrtD(FocusPrintID),5)
	s invdate=$zd(invdate,3)
	
	s invtime=$p($g(^DHCPEINVPRT(InvID)),"^",12)
	i FocusPrintID'="" d
	.s invtime=$LG(^User.DHCPEINVFocusPrtD(FocusPrintID),6)
	s invtime=$zt(invtime,3)
	s AdmID=$p($g(^DHCPEINVPRT(InvID)),"^",2)
	s patid=$p($g(^PAADM(AdmID)),"^",1)
	if patid="" q rtn
	s patname=$p($g(^PAPER(patid,"ALL")),"^",1)
	s InvExInfo=##class(web.DHCPE.CashierEx).GetInvAmountInfo(InvID)
	s InvAmt=$P(InvExInfo,"^",1)
	s AmtTotal=$p($g(^DHCPEINVPRT(InvID)),"^",7)
	s AmtTotal=$FN(AmtTotal,"",2)
	s hzamount=##Class(web.DHCPE.DHCPEPAY).RMBDXXZH("","",InvAmt,"2")
	s BaseInfo=patname_"^"_invNo_"^"_invdate_" "_invtime_"^"_AmtTotal_"^"_InvAmt_"^"_hzamount_"^"_$ZD(+$H,3)
	//分类信息
	i +InvAmt=+AmtTotal d
	.s PayModeExStr=""
	e  d
	.s PayModeExStr=$P(InvExInfo,"^",2)
	
	s locid=$P($G(^PAADM(AdmID)),"^",4)
	//i $G(^DHCPESetting("DHCPE","InvPrintCatInfo"))="Y" d
	i $G(^DHCPESetting("DHCPE","InvPrintCatInfo",locid))="Y"  d
	.i PayModeExStr="" d
	..s CatInfo=..GetFeeCatDataInfo(InvID)
	.e  d
	..s CatInfo="体检费^"_InvAmt
	else  d
	.s CatInfo="体检费^"_InvAmt
	//收费项明细
	//s ListFlag=^DHCPESetting("DHCPE","InvListFlag")
	s ListFlag=^DHCPESetting("DHCPE","InvListFlag",locid)
	s FeeItemInfo=##class(web.DHCPE.Cashier).GetInvoiceListInfo("I",InvID,ListFlag,0)
	q BaseInfo_$C(3)_CatInfo_$C(3)_FeeItemInfo
}

ClassMethod GetFeeCatDataInfo(invid)
{
	s Job=$J
	s c=$C(2)
	s paadm=$p($g(^DHCPEINVPRT(invid)),"^",2)
	s LocID=$P($g(^PAADM(paadm)),"^",4)

  	s PreItemID=""
  	f  s PreItemID=$O(^DHCPEOEITEM(invid,"OEITEM",PreItemID)) q:PreItemID=""  d //,"TARITEM",itmsub)
	.s TARITEMSub=""
	.f  s TARITEMSub=$O(^DHCPEOEITEM(invid,"OEITEM",PreItemID,"TARITEM",TARITEMSub)) q:TARITEMSub=""  d
	..;TarItem_"^"_$j((CurCatFee/(qty*orderQty)),3,2)_"^"_(qty*orderQty)_"^"_$j(CurCatFee,3,2)
	..s Info=$G(^DHCPEOEITEM(invid,"OEITEM",PreItemID,"TARITEM",TARITEMSub))
	..s TARITEMID=$P(Info,"^",1)
	..s Amount=$P(Info,"^",4)
	..;s OneInfo=##class(web.DHCPE.Cashier).GetTarOC(TARITEMID)
	..s OneInfo=##class(web.DHCPE.Cashier).GetTarOC(TARITEMID,"Y",LocID)
	..s TarOCID=$P(OneInfo,"^",1)
	..s ^TempDHCPECatInfo(Job,TarOCID)=+($G(^TempDHCPECatInfo(Job,TarOCID)))+Amount
	..s ^TempDHCPECatInfo(Job,TarOCID,"Desc")=$P(OneInfo,"^",2)
	s CatRtn=""
	s i=0
	s TarOCID=""
	f  s TarOCID=$O(^TempDHCPECatInfo(Job,TarOCID)) q:TarOCID=""  d
	.s Desc=$G(^TempDHCPECatInfo(Job,TarOCID,"Desc"))
	.s i=i+1
	.s Fee=$G(^TempDHCPECatInfo(Job,TarOCID))
	.s Fee=$FN(Fee,"",2)
	.i CatRtn="" d
	..s CatRtn=Desc_"^"_Fee
	.e  d
	..s CatRtn=CatRtn_c_Desc_"^"_Fee
	k ^TempDHCPECatInfo(Job)
	q CatRtn
}

// w ##class(web.DHCPE.CashierEx).GetInvUserNum(3881)

ClassMethod GetInvUserNum(userId)
{
	s invnum=$i(^DHCIPBill("InvNum","OPBill",+$h))
	s numLength=$L(invnum)
	s invnum=$E("00000",1,5-numLength)_invnum
	s invnum=$E($ZD(+$H,8),3,8)_invnum
	s HospYBCode=$G(^DHCPESetting("DHCPE","HospYBCode"))
	s invnum=HospYBCode_invnum
	q invnum
}

ClassMethod DeleteRoundFee(preAuditIds)
{
	s ret=""
	s j=1
	while(j<=$l(preAuditIds,",")){
		s preAuditId=$p(preAuditIds,",",j)
		s j=j+1
		continue:preAuditId=""
		s preAdmId=0
		f  s preAdmId=$o(^DHCPEPreIADM(0,"PAORDITEM",preAuditId,preAdmId)) q:((preAdmId="")||(ret'=""))  d
		.q:'$D(^DHCPEDataEx("InsertRoundFee",preAdmId))
		.s childsub=0
		.f  s childsub=$O(^DHCPEDataEx("InsertRoundFee",preAdmId,childsub)) q:childsub=""  d
		..s PreItemID=preAdmId_"||"_childsub
		..s ret=##class(web.DHCPE.PreItemList).IDeleteItem(preAdmId,"PERSON",PreItemID,"")
		..q:ret'=""
		..k ^DHCPEDataEx("InsertRoundFee",preAdmId,childsub)
	}
	q ret
}

// 多个支付方式时用$c(2)隔(格式：支付方式表指针^支付金额^银行表指针(CMC_BankMas)^支票号^银行卡类型指针(ARC_BankCardType)^合同单指针^支票日期^支票对方账户号码^账户支付明细表指针)

ClassMethod GetPayInfoByInvID(PEInvID)
{
	s ret=""
	s ARRCPID=$P(^DHCPEINVPRT(PEInvID),"^",4)
	q:ARRCPID="" ret
	s PAYMSub=0
	f  s PAYMSub=$O(^ARRCP(ARRCPID,"PAYM",PAYMSub)) q:PAYMSub=""  d
	.s PayMode=$P(^ARRCP(ARRCPID,"PAYM",PAYMSub),"^",1)
	.s Amt=$P(^ARRCP(ARRCPID,"PAYM",PAYMSub),"^",3)
	.s BankID=$P(^ARRCP(ARRCPID,"PAYM",PAYMSub),"^",2)
	.s ChequeNo=$P(^ARRCP(ARRCPID,"PAYM",PAYMSub),"^",4)
	.s OneInfo=PayMode_"^"_Amt_"^"_BankID_"^"_ChequeNo
	.i ret="" d
	..s ret=OneInfo
	.e  d
	..s ret=ret_$C(2)_OneInfo
	q ret
}

ClassMethod InsertOPInv(PEInvID, groupID As %String = "", locID As %String = "")
{
	//w ##class(web.DHCPE.CashierEx).InsertOPInv(88)
	;ISaveInv(papmi, billStr, payInfo, receipNO, instype, sFlag, oldInvDr, prtDate, prtTime, expStr)
	s $ZT="InsertOPInvErr"
	//q:$G(^DHCPESetting("DHCPE","InsertOPInv"))'="Y" 0
	q:$G(^DHCPESetting("DHCPE","InsertOPInv",locID))'="Y" 0
	s paadm=$P(^DHCPEINVPRT(PEInvID),"^",2)
	s papmi=$P(^PAADM(paadm),"^",1)
	s billStr=$P(^DHCPEINVPRT(PEInvID),"^",3)
	//多个支付方式时用$c(2)隔(格式：支付方式表指针^支付金额^银行表指针(CMC_BankMas)^支票号^银行卡类型指针(ARC_BankCardType)^合同单指针^支票日期^支票对方账户号码^账户支付明细表指针)
	s payInfo=..GetPayInfoByInvID(PEInvID)
	s receipNO=$P(^DHCPEINVPRT(PEInvID),"^",1)
	s:receipNO[("DHC") receipNO=""
	//s instype=$P(^PAADM(paadm,1),"^",7)
	
	s instype=$P($G(^DHCPEOEITEM(PEInvID)),"^",6)
	s:instype="" instype=$P(^PAADM(paadm,1),"^",7)
	s:instype="" instype=$O(^PAC("ADMREA",0))
	
	
	s oldInvDr=$P(^DHCPEINVPRT(PEInvID),"^",9)
	i oldInvDr="" d
	.s sFlag="0"  ;收费  1退费
	e  d
	.s sFlag="1"
	s prtDate=$P(^DHCPEINVPRT(PEInvID),"^",11)
	s prtTime=$P(^DHCPEINVPRT(PEInvID),"^",12)
	i groupID="" 
	{
		s:$D(%session) groupID=%session.Get("LOGON.LANGID")
		s:groupID="" groupID=164
	}
	i locID="" 
	{
		s:$D(%session) locID=%session.Get("LOGON.CTLOCID")
		s:locID="" locID=304
	}
	s accID=""
	s runInvNo="N"
	s feeType="H"
	s userID=$P(^DHCPEINVPRT(PEInvID),"^",10)
	s hospitalID=$P(^CTLOC(locID),"^",22)
	s ip=""
	i oldInvDr=""  ;收费
	{
		//安全组^登录科室^账户rowid^是否走发票(Y:走发票，N:不走发票)^费用类型(F:收费,R:过号,H:体检)
		//^预收额^找零^分币误差^收费员^医院指针^收费员电脑IP地址
	
		s expStr=groupID_"^"_locID_"^"_accID_"^"_runInvNo_"^"_feeType
		s expStr=expStr_"^"_""_"^"_""_"^"_""_"^"_userID_"^"_hospitalID_"^"_ip
		s ret=##class(web.DHCOPBillPhysicalInv).ISaveInv(papmi,billStr,payInfo,receipNO,instype,sFlag,oldInvDr,prtDate,prtTime,expStr)
	}
	else ;退费
	{
		//expStr:安全组^登录科室^收费员^医院指针^IP地址
		s expStr=groupID_"^"_locID_"^"_userID_"^"_hospitalID_"^"_ip
		s OPOldInvID=$G(^DHCPEDataEx("DHCPEINVPRT","H2O",oldInvDr))  ;找出原来门诊收据id
		q:OPOldInvID="" 0
		s invFlag="A"
		s ret=##class(web.DHCOPBillPhysicalInv).IRefundInv(OPOldInvID,billStr,invFlag,payInfo,receipNO,prtDate,prtTime,expStr)
	}
	i +ret=0{
		s OPInvID=$P(ret,"^",2)
		s ^DHCPEDataEx("DHCPEINVPRT","H2O",PEInvID)=OPInvID
		s ^DHCPEDataEx("DHCPEINVPRT","O2H",OPInvID)=PEInvID
	}
	q +ret
InsertOPInvErr
	q 0
}

ClassMethod UpdatePayMode(InvID, PaymodeInfo)
{
	;s ret=##class(web.DHCPE.CashierEx).UpdatePayMode(InvID,PaymodeInfo)
	s SQLCODE=0
	s ArrcpID=$P(^DHCPEINVPRT(InvID),"^",4)
	s i=0
	s PayModeSub=0
	f  s PayModeSub=$O(^ARRCP(ArrcpID,"PAYM",PayModeSub)) q:(PayModeSub="")||(SQLCODE'=0)  d
	.s PayModeID=$P(^ARRCP(ArrcpID,"PAYM",PayModeSub),"^",1)
	.s i=i+1
	.s OneInfo=$P(PaymodeInfo,"^",i)
	.s NewPayMode=$P(OneInfo,",",5)
	.i (NewPayMode'="")&&(NewPayMode'=PayModeID) d
	..s PAYMRowID=ArrcpID_"||"_PayModeSub
	..&SQL(Update Sqluser.ar_rcptpaymode set PAYM_PayMode_DR=:NewPayMode where PAYM_RowId=:PAYMRowID)
	q SQLCODE
}

ClassMethod ReCalAmt(GADM)
{
	q:GADM="" 0
	s GADM=$P(^DHCPEGADM(GADM),"^",2)
	q ##class(web.DHCPE.PreIADM).UpdateGroupAuditAmount(GADM,1)
}

// d ##class(web.DHCPE.CashierEx).DailyReport(1,"")

// 门诊日结调用结算方法

ClassMethod DailyReport(UserID, HospitalID)
{
	s $ZT="DailyReportErr"
	s ret=##class(web.DHCPE.DHCPEUSERREPORT).FootPDbyUser(UserID,"","") 
	i +ret>0 q "0^"_ret
	q "-1^"
DailyReportErr
	q "-1^"
}

// d ##class(web.DHCPE.CashierEx).GetTarItemInfoByInvID(11047222)

// 根据门诊发票id，存对应的收费项明细

ClassMethod GetTarItemInfoByInvID(InvID)
{
	s $ZT="GetTarItemErr"
	q:InvID="" "-1^发票为空"
	q:$D(^DHCPEDataEx("MZInvID",InvID)) ""
	s HPInvNo=$G(^DHCPEDataEx("DHCPEINVPRT","O2H",InvID))
	q:HPInvNo="" "-1^非体检发票"
	s OldInvID=$P(^DHCPEINVPRT(HPInvNo),"^",9)
	s FH=1
	i OldInvID'="" d
	.s HPInvNo=OldInvID
	.s FH=-1

	s Sort=0
	s PreItemID=""
	f  s PreItemID=$O(^DHCPEOEITEM(HPInvNo,"OEITEM",PreItemID)) q:PreItemID=""  d
	.s TARITEMSub=""
	.f  s TARITEMSub=$O(^DHCPEOEITEM(HPInvNo,"OEITEM",PreItemID,"TARITEM",TARITEMSub)) q:TARITEMSub=""  d
	..s Info=$G(^DHCPEOEITEM(HPInvNo,"OEITEM",PreItemID,"TARITEM",TARITEMSub))
	..s TARITEMID=$P(Info,"^",1)
	..s Qty=$P(Info,"^",3)
	..s Price=$P(Info,"^",2)*FH
	..s Price=$FN(Price,"",2)
	..s Amount=$P(Info,"^",4)*FH
	..s Amount=$FN(Amount,"",2)
	..s Sort=Sort+1
	..s ^DHCPEDataEx("MZInvID",InvID,Sort)=TARITEMID_"^"_Qty_"^"_Price_"^"_Amount
	q 0
	//s ^DHCPEDataEx("MZInvID",InvID,Sort)="收费项ID^收费项数量^收费项单价^总金额"
GetTarItemErr
	q "-1^发生异常"
}

/// Creator: xueying
/// CreateDate: 2018-03-29
/// Descript: 判断体检代金卡、预交金的余额和账户是否存在
/// w ##class(web.DHCPE.CashierEx).JudgeTJKRemainAmount()
ClassMethod JudgeTJKRemainAmount(AdmId, OneAmt, PayModeID, No, OldPayModeID)
{
	
	s errs=""
	s PayModeCode=""
	if (OldPayModeID'=PayModeID){
	i PayModeID'="" s PayModeCode=$p($g(^CT("CTPM",PayModeID)),"^",1)
	i PayModeCode="TJYJJ" d
	.s APID=##class(web.DHCPE.AdvancePayment).GetUseID(AdmId,PayModeCode,"N")
	..s:APID="" errs="预交金帐户不存在"
	i PayModeCode="TJDJK" d
	.s:No="" errs="没有输入代金卡号"
	.q:No=""
	.s APID=##class(web.DHCPE.AdvancePayment).GetUseID(No,PayModeCode,"N")
	.s:APID="" errs="储值卡帐户不存在"
	.q:APID=""
	.s errs=##class(web.DHCPE.AdvancePayment).JudgeUse(No,OneAmt,PayModeCode)
	}
	Q errs
}

/// w ##class(web.DHCPE.CashierEx).GetProveInfoXML("2122")
ClassMethod GetProveInfoXML(InvID)
{
	s c=$c(2)
	s HOSPID=%session.Get("LOGON.HOSPID")
    s HospitalName=##class(web.DHCPE.DHCPECommon).GetHospitalName(HOSPID)
 	//基本信息
	s FocusPrintID=$o(^User.DHCPEINVFocusPrtI("IFPINVDRIndex"," "_InvID,""))
	s invNo=$p($g(^DHCPEINVPRT(InvID)),"^",1)
	i invNo["DHCPEYJS" q "-1^预结算记录不能打印"
	i FocusPrintID'="" d
	.s invNo=$LG(^User.DHCPEINVFocusPrtD(FocusPrintID),3)
	
	s invdate=$p($g(^DHCPEINVPRT(InvID)),"^",11)
	//真实打印日期
	i FocusPrintID'="" d
	.s invdate=$LG(^User.DHCPEINVFocusPrtD(FocusPrintID),5)
	//s invdate=$zd(invdate,3)
	i invdate'="" s invdate=##class(websys.Conversions).DateLogicalToHtml(invdate)
	s invtime=$p($g(^DHCPEINVPRT(InvID)),"^",12)
	i FocusPrintID'="" d
	.s invtime=$LG(^User.DHCPEINVFocusPrtD(FocusPrintID),6)
	s invtime=$zt(invtime,3)
	s AdmID=$p($g(^DHCPEINVPRT(InvID)),"^",2)
	s patid=$p($g(^PAADM(AdmID)),"^",1)
	if patid="" q "-1^就诊无效"
	s patname=$p($g(^PAPER(patid,"ALL")),"^",1)
	s InvExInfo=##class(web.DHCPE.CashierEx).GetInvAmountInfo(InvID)
	s InvAmt=$P(InvExInfo,"^",1)
	s AmtTotal=$p($g(^DHCPEINVPRT(InvID)),"^",7)
	s AmtTotal=$FN(AmtTotal,"",2)
	s srf=$p($g(^DHCPEINVPRT(InvID)),"^",21)
	s srf=$j(srf,3,2)
	i srf'=0.00 s srf=srf
	e  s srf=" "

	//s hzamount=##Class(web.DHCPE.DHCPEPAY).RMBDXXZH("","",AmtTotal,"2")
	s hzamount=##Class(web.DHCPE.DHCPEPAY).RMBDXXZH("","",InvAmt,"2")  //取实际支付金额，不判定支付方式等
	s BaseInfo="srf"_c_srf_"^"_"Name"_c_patname_"^"_"InvNo"_c_invNo_"^"_"InvDate"_c_invdate_"^"_"InvTime"_c_invtime_"^"_"AmtTotal"_c_AmtTotal_"^"_"InvAmt"_c_InvAmt_"^"_"HZAmount"_c_hzamount_"^"_"CurDate"_c_##class(websys.Conversions).DateLogicalToHtml(+$H)_"^"_"Hospital"_c_HospitalName
	//分类信息
	i +InvAmt=+AmtTotal d
	.s PayModeExStr=""
	e  d
	.s PayModeExStr=$P(InvExInfo,"^",2)
	s locid=$P($G(^PAADM(AdmID)),"^",4)
	//i $G(^DHCPESetting("DHCPE","InvPrintCatInfo"))="Y"  d
	i $G(^DHCPESetting("DHCPE","InvPrintCatInfo",locid))="Y"  d
	.i PayModeExStr="" d
	..s CatInfo=..GetFeeCatDataInfo(InvID)
	.e  d
	..s CatInfo="体检费^"_AmtTotal
	else  d
	.s CatInfo="体检费^"_AmtTotal
	//收费项明细
	//s ListFlag=^DHCPESetting("DHCPE","InvListFlag")
	s ListFlag=^DHCPESetting("DHCPE","InvListFlag",locid)
	s FeeItemInfo=##class(web.DHCPE.Cashier).GetInvoiceListInfo("I",InvID,ListFlag,0)
	q BaseInfo_$C(3)_CatInfo_$C(3)_FeeItemInfo
}

// w ##class(web.DHCPE.CashierEx).GetBalanceINVByDate("2019-2-2","2019-2-2",10000)

ClassMethod GetBalanceINVByDate(StartDate, EndDate, PID)
{
	/*
	d ##class(web.DHCINSUPort).GetDivInfobyDivDr("结算表的rowid","结算状态判断","扩展参数")
	结算状态 N表示正常记录，B:表示被红充，S表示红充记录
	扩展参数ExtStr：总金额^医保支付金额^核对方式^^
	核对方式这么传：0:不核对金额,1:核对总金额,2:核对总金额及医保支付总额
	/// Output:错误状态码1：有正常记录，非1：未找到对应的数据^医保总金额、医保报销金额、医保现金支付金额
	/// 错误状态码 {1:正常;-202:his医保数据状态不一致;-203:医保无此记录;-204:his没有相应记录;-205:his医保数据金额不一致}
	*/
	s:StartDate["-" StartDate=$ZDH(StartDate,"3")
	s:EndDate["-" EndDate=$ZDH(EndDate,"3")
	s ErrNum=0
	s CheckType="1"
	s Date=StartDate-1
	f  s Date=$O(^DHCPEINVPRT(0,"DATE",Date)) q:(Date="")||(Date>EndDate)  d
	.s InvPrtID=0
	.f  s InvPrtID=$O(^DHCPEINVPRT(0,"DATE",Date,InvPrtID)) q:(InvPrtID="")  d
	..s CheckData=..GetCheckData(InvPrtID)
	..s InsuID=$P(CheckData,"^",1)
	..q:InsuID=""
	..s InvAmt=$P(CheckData,"^",3)
	..s InsuAmt=$P(CheckData,"^",4)
	..s InvFlag=$P(CheckData,"^",2)
	..s ExpStr=InvAmt_"^"_InsuAmt_"^"_CheckType
	..s CheckInfo=##class(web.DHCINSUPort).GetDivInfobyDivDr(InsuID,InvFlag,ExpStr)
	..s CheckFlag=$P(CheckInfo,"^",1)
	..q:CheckFlag="1"
	..//登记号^姓名^就诊号^$zd(iDate,3)^PRTFlag^发票ID^医保结算表ID^操作员^发票ID^医保结算状态^医保结算日期^医保操作员^医保就诊类型^发票金额
	..s PAADM=$P(^DHCPEINVPRT(InvPrtID),"^",2)
	..s UserID=$P(^DHCPEINVPRT(InvPrtID),"^",10)
	..s PatID=$P(^PAADM(PAADM),"^",1)
	..s RegNo=$P(^PAPER(PatID,"PAT",1),"^",1)
	..s Name=$P(^PAPER(PatID,"ALL"),"^",1)
	..s ErrSort=$I(^CacheTemp("INSUBalance",PID,"OP","INVPE","Error"))
	..s ErrInfo=RegNo_"^"_Name_"^"_PAADM_"^"_$ZD(Date,3)_"^"_InvFlag_"^"_InvPrtID_"^"_InsuID_"^"_UserID_"^"_InvPrtID_"^^^^^"_InvAmt
	..s ErrNum=ErrNum+1
	..s ^CacheTemp("INSUBalance",PID,"OP","INVPE","Error",ErrSort)=ErrInfo
	q ErrNum
}

// w ##class(web.DHCPE.CashierEx).GetInfobyInvID(2079,"N","27^0^1")

ClassMethod GetInfobyInvID(InvPrtID, InvFlag, ExpStr)
{
	/*
	结算状态 N表示正常记录，B:表示被红充，S表示红充记录
	扩展参数ExtStr：总金额^医保支付金额^核对方式^^
	核对方式这么传：0:不核对金额,1:核对总金额,2:核对总金额及医保支付总额
	Output:错误状态码1：有正常记录，非1：未找到对应的数据^医保总金额、医保报销金额、医保现金支付金额
	错误状态码 {1:正常;-202:his医保数据状态不一致;-203:医保无此记录;-204:his没有相应记录;-205:his医保数据金额不一致}
	*/
	s ErrCode=1
	i '$D(^DHCPEINVPRT(InvPrtID)){  //没有发票记录
		s ErrCode="-204"
		q ErrCode
	}
	s CheckData=..GetCheckData(InvPrtID)
	s InsuID=$P(CheckData,"^",1)
	s TotalAmt=$P(CheckData,"^",3)
	s InsuAmt=$P(CheckData,"^",4)
	s ZFAmt=$P(CheckData,"^",5)
	s AmtStr=TotalAmt_"^"_InsuAmt_"^"_ZFAmt
	i InsuID=""{  //没有记录医保结算ID
		s ErrCode="-202"  //不是医保结算  
		q ErrCode_"^"_AmtStr
	}
	s HisInvFlag=$P(CheckData,"^",2)
	i HisInvFlag'=InvFlag{  //结算状态不一致
		s ErrCode="-202"  //不是医保结算
		q ErrCode_"^"_AmtStr
	}
	s HisInvAmt=$P(CheckData,"^",3)
	s HisInsuAmt=$P(CheckData,"^",4)
	s CheckType=$P(ExpStr,"^",3)
	s InvAmt=$P(ExpStr,"^",1)	
	i CheckType="1"{
		i (+InvAmt'=+HisInvAmt){
			s ErrCode="-205"  //结算金额不一致
			q ErrCode_"^"_AmtStr
		}
	}
	i CheckType="2"{
		s InsuAmt=$P(ExpStr,"^",2)
		i (+InsuAmt'=+HisInsuAmt)||(+InvAmt'=+HisInvAmt){
			s ErrCode="-205"  //结算金额不一致
			q ErrCode_"^"_AmtStr
		}
	}
	q ErrCode_"^"_AmtStr
}

// w ##class(web.DHCPE.CashierEx).GetCheckData(2079)

ClassMethod GetCheckData(InvPrtID)
{
	//返回状态、发票金额、医保金额
	s InvFlag="N"
	s DropPrtID=$P(^DHCPEINVPRT(InvPrtID),"^",9)
	i DropPrtID'="" d
	.s InvFlag="S"  //红冲的负记录
	.s InsuID=$P(^DHCPEOEITEM(DropPrtID),"^",4)
	e  d
	.s InsuID=$P(^DHCPEOEITEM(InvPrtID),"^",4)
	.i $D(^DHCPEINVPRT(0,"REF",InvPrtID)) d
	..s InvFlag="B"  //被红冲
	.e  d
	..s InvFlag="N"  //正常
	s InvAmt=$P(^DHCPEINVPRT(InvPrtID),"^",7)
	s InvAmt=$FN(InvAmt,"",2)
	s InsuAmt=""
	s ARReceiptsID=$P(^DHCPEINVPRT(InvPrtID),"^",4)
	s Sub=$O(^ARRCP(ARReceiptsID,"PAYM",0))
	s ZFAmt=$P(^ARRCP(ARReceiptsID,"PAYM",Sub),"^",3)
	s InsuAmt=$FN((InvAmt-ZFAmt),"",2)
	s ZFAmt=$FN(ZFAmt,"",2)
	q InsuID_"^"_InvFlag_"^"_InvAmt_"^"_InsuAmt_"^"_ZFAmt
}

// w ##class(web.DHCPE.CashierEx).GetPayInfoForWX(1715)

ClassMethod GetPayInfoForWX(PEInvID)
{
	s ret=""
	s ARRCPID=$P(^DHCPEINVPRT(PEInvID),"^",4)
	s PAADM=$P(^DHCPEINVPRT(PEInvID),"^",2)
	q:ARRCPID="" ret
	s PAYMSub=0
	f  s PAYMSub=$O(^ARRCP(ARRCPID,"PAYM",PAYMSub)) q:PAYMSub=""  d
	.s PayMode=$P(^ARRCP(ARRCPID,"PAYM",PAYMSub),"^",1)
	.s PayMode=$P(^CT("CTPM",PayMode),"^",1)
	.q:(PayMode'=("ALIPAY"))&&(PayMode'=("WECHATPAY"))
	.s Amt=$P(^ARRCP(ARRCPID,"PAYM",PAYMSub),"^",3)
	.s OneInfo=PayMode_"^"_Amt_"^"_PAADM
	.i ret="" d
	..s ret=OneInfo
	.e  d
	..s ret=ret_$C(2)_OneInfo
	q ret
}

/// 验证是否需要调用扫码付
/// w ##class(web.DHCPE.CashierEx).GetPayInfoForScanCode(1715)
ClassMethod GetPayInfoForScanCode(PEInvID)
{
	s ret=""
	s ARRCPID=$P(^DHCPEINVPRT(PEInvID),"^",4)
	q:ARRCPID="" ret
	s PAYMSub=0
	f  s PAYMSub=$O(^ARRCP(ARRCPID,"PAYM",PAYMSub)) q:PAYMSub=""  d
	.s PayMode=$P(^ARRCP(ARRCPID,"PAYM",PAYMSub),"^",1)
	.s PayModeCode=$P(^CT("CTPM",PayMode),"^",1)
	.q:PayModeCode'="SMF"
	.s Amt=$P(^ARRCP(ARRCPID,"PAYM",PAYMSub),"^",3)
	.s OneInfo=PayMode_"^"_PayModeCode_"^"_Amt
	.i ret="" d
	..s ret=OneInfo
	.e  d
	..s ret=ret_$C(2)_OneInfo
	q ret
}

ClassMethod NeedPrintInvByInvID(InvID)
{
	s InvFlag=0
	s DHCPayMode=""
	s ArrcpID=$P(^DHCPEINVPRT(InvID),"^",4)
	s PayModeSub=0
	f  s PayModeSub=$O(^ARRCP(ArrcpID,"PAYM",PayModeSub)) q:(PayModeSub="")  d
	.s PayModeID=$P(^ARRCP(ArrcpID,"PAYM",PayModeSub),"^",1)
	.s PayModeCode=$P(^CT("CTPM",PayModeID),"^",1)
	.i '(PayModeCode[("TJ")) s InvFlag=1
	.s:(PayModeCode[("TJ")) DHCPayMode=PayModeCode
	q InvFlag_"^"_DHCPayMode
}

/// 记录体检扫码付  订单关联关系   部分退费时PEInvID=作废发票ID!新发票ID
ClassMethod SetRelationHisOrderRecord(PEInvID, TradOrdID, TradeType)
{
	s Num=$L(PEInvID,"!")
	f i=1:1:Num d
	.s CurInvID=$P(PEInvID,"!",i)
	.s ^DHCPEDataEx("ScanPayH2O",TradeType, CurInvID)=TradOrdID
	.s ^DHCPEDataEx("ScanPayO2H",TradeType, TradOrdID)=CurInvID
	q ##class(DHCBILL.Common.DHCBILLCommon).RelationOrderToHIS(TradOrdID,PEInvID,TradeType)
}

/// Descript:记录需要补交易的发票
/// Input:
/// 		Invprt:需要退费的发票ID	
/// 			Type:0  记录待补交易  1 清理补交易记录
/// Creater:	wangguoying
/// CreateDate:	2019-07-17
/// Debug: w ##class(web.DHCPE.CashierEx).SetNeedRefundRecord(1361)
ClassMethod SetNeedRefundRecord(Invprt, Type)
{
	i Type=0
	{
		s ^DHCPEDataEx("NeedPOSRefund",Invprt)=%session.Get("LOGON.USERID")_"^"_+$H_"^"_$P($H,",",2)
	}
	i Type=1
	{
		k ^DHCPEDataEx("NeedPOSRefund",Invprt)
	}
	q 0
}

/// Descript:获取POS体检退费参数
/// Input:
/// 		NewInvID:新体检发票ID	
///         DropInvID:体检负发票ID	
///         OriPEInvID:体检原发票ID
/// 		PayCode:支付方式代码
/// Return:0^支付方式ID^退费金额^正发票对应的交易订单ID^正发票ID^负发票ID^新发票ID^最原始的收费订单^PAADM^互联网扫码付标记$C(1)互联网支付记录(互联网支付记录一定要放在最后)   非0^错误信息
/// Creater:	wangguoying
/// CreateDate:	2019-02-19
/// Debug: w ##class(web.DHCPE.CashierEx).GetPOSRefundPara("2652","2650","^wxpay^alipay^YHK^")
ClassMethod GetPOSRefundPara(NewInvID, DropInvID, OriPEInvID, PayCode = "")
{
	s paadm=$P($g(^DHCPEINVPRT(OriPEInvID)),"^",2)
	s locid=$P($G(^PAADM(paadm)),"^",4)


	i PayCode=""
	{
		//s PayCode=$G(^DHCPESetting("DHCPE","ExtPayModeCode"))
		s PayCode=$G(^DHCPESetting("DHCPE","ExtPayModeCode",locid))
	}
	q:PayCode="" ""
	q:(DropInvID="")&&(OriPEInvID="") "" 
	s:OriPEInvID="" OriPEInvID=$P($g(^DHCPEINVPRT(DropInvID)),"^",9)
	s:DropInvID="" DropInvID=$O(^DHCPEINVPRT(0,"REF",OriPEInvID,""))
	if NewInvID="" s NewInvID=$G(^DHCPEPRT(OriPEInvID,"NewRefInvID"))
	set paadm=$P($g(^DHCPEINVPRT(DropInvID)),"^",2)
	set ArrcpID=$P($g(^DHCPEINVPRT(DropInvID)),"^",4)
	set POSDR="" ;支付方式ID
	set POSRefundAmt=0 ;退费金额 
	set PayModeSub=0
	set scanCodeFlag=0    ;互联网产品组扫码付标记  
	for  set PayModeSub=$O(^ARRCP(ArrcpID,"PAYM",PayModeSub)) q:(PayModeSub="")  d
	.s PayModeID=$P($g(^ARRCP(ArrcpID,"PAYM",PayModeSub)),"^",1)
	
	.s PayModeCode=$P($g(^CT("CTPM",PayModeID)),"^",1)
	.
	.q:PayCode'[("^"_PayModeCode_"^")
	
	.s Amt=0-$P($g(^ARRCP(ArrcpID,"PAYM",PayModeSub)),"^",3)
	.q:+Amt=0
	.s POSRefundAmt=POSRefundAmt+Amt
	.;s:(POSRefundAmt>0)&($G(^DHCPESetting("DHCPE","DHCScanCode"))[("^"_PayModeCode_"^")) scanCodeFlag=1
	.s:(POSRefundAmt>0)&($G(^DHCPESetting("DHCPE","DHCScanCode",locid))[("^"_PayModeCode_"^")) scanCodeFlag=1
	.s POSDR=PayModeID

	;q:(POSDR="")||(POSRefundAmt=0) ""  ;退费不包含POS时 
	set POSNewAmt=0 ;POS 新收金额
	if NewInvID'=""
	{
		set ArrcpID=$P($g(^DHCPEINVPRT(NewInvID)),"^",4)
		set PayModeSub=0
		for  set PayModeSub=$O(^ARRCP(ArrcpID,"PAYM",PayModeSub)) q:(PayModeSub="")  d
		.s PayModeID=$P($g(^ARRCP(ArrcpID,"PAYM",PayModeSub)),"^",1)
		.s PayModeCode=$P($g(^CT("CTPM",PayModeID)),"^",1)
		.q:PayCode'[("^"_PayModeCode_"^")
		.s POSNewAmt=POSNewAmt+$P(^ARRCP(ArrcpID,"PAYM",PayModeSub),"^",3)
		.s POSDR=PayModeID
	}
	set POSRefundAmt=POSRefundAmt-POSNewAmt ;扫码付实际退费金额
	q:+POSRefundAmt<=0 ""
	set OrigOPInvID=OriPEInvID // $G(^DHCPEDataEx("DHCPEINVPRT","H2O",OriPEInvID))  ;门诊正票ID
	set MinusOPInvID=DropInvID  // $G(^DHCPEDataEx("DHCPEINVPRT","H2O",DropInvID))  ;门诊负票ID
	set NewOPInvID=""
	set:NewInvID'="" NewOPInvID=NewInvID // $G(^DHCPEDataEx("DHCPEINVPRT","H2O",NewInvID))  ;门诊新票ID
	set TradeID="" ;##class(DHCBILL.Common.DHCBILLCommon).GetOrgETPRowIDByPrt(OrigOPInvID,"OP")
	s:POSRefundAmt'="" POSRefundAmt=$J(POSRefundAmt,"",2)
	
	s ysInvprt=..GetOriInvprt(DropInvID)
	s PEBarCodeStr=""
	i scanCodeFlag=1 s PEBarCodeStr=$G(^DHCPEDataEx("PEBarCodePayStr", ysInvprt))
	
	q "0^"_POSDR_"^"_POSRefundAmt_"^"_TradeID_"^"_OrigOPInvID_"^"_MinusOPInvID_"^"_NewOPInvID_"^"_ysInvprt_"^"_paadm_"^"_scanCodeFlag_$C(1)_PEBarCodeStr
}

/// Descript:获取第三方支付信息
/// Input:
/// 		PEInvID：体检发票ID	
/// Return:PayModeDr_"^"_curPayCode_"^"_totalAmt_$C(1)_patID_"^"_paadm_"^"_scanCodeFlag 
///            (scancodeFlag为0时调用计费公共函数，为1时调用互联网产品组扫码付)
/// Creater:	wangguoying
/// CreateDate:	2019-02-19
/// Debug: w ##class(web.DHCPE.CashierEx).GetPayInfoByPayCode("2652")
ClassMethod GetPayInfoByPayCode(PEInvID, PayCode = "")
{
	s paadm=$P($g(^DHCPEINVPRT(PEInvID)),"^",2)
	s locid=$P($G(^PAADM(paadm)),"^",4)

	i PayCode=""
	{
		//s PayCode=$G(^DHCPESetting("DHCPE","ExtPayModeCode"))
		s PayCode=$G(^DHCPESetting("DHCPE","ExtPayModeCode",locid))
	}
	q:PayCode="" ""
	s PosDR=""
	s ret=""
	s scanCodeFlag=0    ;互联网产品组扫码付标记  
	s ARRCPID=$P(^DHCPEINVPRT(PEInvID),"^",4)
	q:ARRCPID="" ret
	s len=$l(PayCode,"^")
	f i=1:1:len  d
	.s curPayCode=$P(PayCode,"^",i)
	.q:curPayCode=""
	.s PayModeDr=""
	.s totalAmt=0
	.s PAYMSub=0
	.f  s PAYMSub=$O(^ARRCP(ARRCPID,"PAYM",PAYMSub)) q:PAYMSub=""  d
	..s PayModeDr=$P(^ARRCP(ARRCPID,"PAYM",PAYMSub),"^",1)
	..s PayModeCode=$P(^CT("CTPM",PayModeDr),"^",1)
	..q:PayModeCode'=curPayCode
	..s PosDR=PayModeDr
	..s curAmt=$P(^ARRCP(ARRCPID,"PAYM",PAYMSub),"^",3)
	..s totalAmt=totalAmt+curAmt	
	..;s:(totalAmt>0)&($G(^DHCPESetting("DHCPE","DHCScanCode"))[("^"_PayModeCode_"^")) scanCodeFlag=1
	..s:(totalAmt>0)&($G(^DHCPESetting("DHCPE","DHCScanCode",locid))[("^"_PayModeCode_"^")) scanCodeFlag=1
	.q:+totalAmt=0
	.s OneInfo=PosDR_"^"_curPayCode_"^"_totalAmt
	
	.i ret="" d
	..s ret=OneInfo
	.e  d
	..s ret=ret_$C(2)_OneInfo
	
	q:ret="" ""
	
	
	s OldInvID=$G(^DHCPEPRT(PEInvID,"RefInvID")) //原票不为空，说明该发票为退费新收的发票。新收发票金额大于原票对应金额时才需要补缴
	i OldInvID'=""
	{
		s newAmt=+$p(ret,"^",3)
		s OldInfo=..GetPayInfoByInvID(OldInvID)  
		i OneInfo'="" d
		.s oldAmt=+$P(OneInfo,"^",3)
		.s newAmt=newAmt-oldAmt
		q:newAmt<=0 ""  ;小于0说明新收发票金额小于发票金额，此时应调用第三方退费
		s $p(ret,"^",3)=newAmt		
	}
	
	i ret'="" 
	{
		s PAADM=$P(^DHCPEINVPRT(PEInvID),"^",2)
		s PatID=$P(^PAADM(PAADM),"^",1)
		s ret=ret_$C(1)_PatID_"^"_PAADM_"^"_scanCodeFlag
	}
	q ret
}

/// Descript:根据退费发票找到原始的收费发票
/// Input:
/// 			DropInvprt:退费发票ID
/// Creater:	wangguoying
/// CreateDate:	2019-12-26
/// Debug: w ##class(web.DHCPE.CashierEx).GetOriInvprt(1361)
ClassMethod GetOriInvprt(DropInvprt)
{
	s invprt=$P(^DHCPEINVPRT(DropInvprt),"^",9)  ;正票ID
	s orinInvprt=""   ;最原始的正票
	do{
		s oldInvprt=$G(^DHCPEPRT(invprt,"RefInvID"))
		i oldInvprt=""  s orinInvprt=invprt  continue
		s invprt=oldInvprt
	}while(orinInvprt="")
	q orinInvprt
}

/// Descript:记录发票扣费日志  用于区分需要补交易的发票（在计费相关程序扣费成功后再调用此方法）
/// Input:
/// 		Invprt:退费发票ID
/// 			UserID:退费操作员
/// Creater:	wangguoying
/// CreateDate:	2019-12-25
/// Debug: w ##class(web.DHCPE.CashierEx).RecordPOSRefund(1361)
ClassMethod RecordPOSRefund(DropInvprt, UserID = "")
{
	i UserID="" s:$D(%session) UserID=%session.Get("LOGON.USERID")
	s OriPEInvID=$P(^DHCPEINVPRT(DropInvprt),"^",9)
	s NewInvID=$G(^DHCPEPRT(OriPEInvID,"NewRefInvID"))
	s ^DHCPEDataEx("POSRefund",DropInvprt)=UserID_"^"_+$H_"^"_$P($H,",",2)_"^"_OriPEInvID_"^"_NewInvID	
	q 0
}

/// Descript:判断某张发票是否需要补交易
/// Input:
/// 		Invprt:发票ID
/// OutPut: "" 不需要补交易  ,  原票ID&退费发票ID&新收发票ID&新票预结算标记
/// Creater:	wangguoying
/// CreateDate:	2019-12-25
/// Debug: w ##class(web.DHCPE.CashierEx).IsRefundException(1361)
ClassMethod IsRefundException(Invprt)
{
	
	s Ret=""
	s InvFlag=$p(^DHCPEINVPRT(Invprt),"^",8)
	i InvFlag="N"  //收费
	{
		s InvNo=$P(^DHCPEINVPRT(Invprt),"^",1)
		s OriInvPrt=$G(^DHCPEPRT(Invprt,"RefInvID"))  //原收费记录
		i OriInvPrt="" d  //非退费新收发票
		.s OriInvPrt=Invprt
		s NewInvPrt=$G(^DHCPEPRT(OriInvPrt,"NewRefInvID"))
		s DropInPrt=$O(^DHCPEINVPRT(0,"REF",OriInvPrt,""))
		q:DropInPrt="" ""
		s RefundPara=..GetPOSRefundPara(NewInvPrt,DropInPrt,OriInvPrt)
		i (RefundPara'="")&&(+$P(RefundPara,"^",3)>0)&&('$D(^DHCPEDataEx("POSRefund",DropInPrt)))  d
		.s yjsFlag=0
		.s:(NewInvPrt'="")&&($P(^DHCPEINVPRT(NewInvPrt),"^",1)["DHCPEYJS") yjsFlag=1
		.s Ret=OriInvPrt_"&"_DropInPrt_"&"_NewInvPrt_"&"_yjsFlag   
	}else{ //退费
		s OriInvPrt=$P(^DHCPEINVPRT(Invprt),"^",9)  //原票
		s NewInvPrt=$G(^DHCPEPRT(OriInvPrt,"NewRefInvID"))  //新票
		s RefundPara=..GetPOSRefundPara(NewInvPrt,Invprt,OriInvPrt)
		i (RefundPara'="")&&(+$P(RefundPara,"^",3)>0)&&('$D(^DHCPEDataEx("POSRefund",Invprt)))  d
		.s yjsFlag=0
		.s:(NewInvPrt'="")&&($P(^DHCPEINVPRT(NewInvPrt),"^",1)["DHCPEYJS") yjsFlag=1
		.s Ret=OriInvPrt_"&"_Invprt_"&"_NewInvPrt_"&"_yjsFlag   
	}
	q Ret
}

/// Descript:记录体检发票与计费交易订单的关联
/// Input:
/// 		Invprt:发票ID
/// 			TradOrdID:交易订单
/// OutPut: 		
/// Creater:	wangguoying
/// CreateDate:	2019-12-25
/// Debug: w ##class(web.DHCPE.CashierEx).SetRelationTrade(1361)
ClassMethod SetRelationTrade(PEInvID, TradOrdID)
{
	s ^DHCPEDataEx("ExtPayH2O", PEInvID)=TradOrdID
	s ^DHCPEDataEx("ExtPayO2H", TradOrdID)=PEInvID
	q 0
}

/// Descript:记录体检发票与互联网订单的关联
/// Input:
/// 			Invprt:发票ID
/// 			PEBarCodePayStr：互联网交易信息
/// OutPut: 		
/// Creater:	wangguoying
/// CreateDate:	2019-12-25
/// Debug: w ##class(web.DHCPE.CashierEx).SetRelationPEBarCode(1361)
ClassMethod SetRelationPEBarCode(PEInvID, PEBarCodePayStr)
{
	s ^DHCPEDataEx("PEBarCodePayStr", PEInvID)=PEBarCodePayStr
	s paadm=$P(^DHCPEINVPRT(PEInvID),"^",2)
	s opInvprt=$G(^DHCPEDataEx("DHCPEINVPRT","H2O",PEInvID))
	d ##class(MHC.BarCodePay).updatePEBarCodePay(paadm,PEBarCodePayStr,"C",opInvprt)
	q 0
}

/// Descript:验证发票支付金额是否正确
/// Input:
/// 			InvID:发票ID
/// 			PayInfos:支付信息  支付方式,金额,^支付方式,金额,
/// 			Force:不正确时强制更新发票支付方式  
/// OutPut: 0 正确  1 不正确		
/// Creater:	wangguoying
/// CreateDate:	2020-11-25
/// Debug: w ##class(web.DHCPE.CashierEx).VaildInvprtAmt(3465,"1,20")
ClassMethod VaildInvprtAmt(InvID, PayInfos, Force = "0")
{
	b ;InvID, PayInfos, Force
	s cashCode="1",cashAmt=0,totalAmt=0  ;现金需要考虑凑整
	k PPInfo(InvID)
	f i=1:1:$L(PayInfos,"^")  d
	.s payedInfo=$p(PayInfos,"^",i)
	.s paymode=$p(payedInfo,",",1)
	.s payamount=$p(payedInfo,",",2)
	.s PPInfo(InvID,paymode)=$G(PPInfo(InvID,paymode))+payamount
	.s totalAmt=totalAmt+payamount
	
	i $D(PPInfo(InvID,cashCode))
	{
		s PPInfo(InvID,cashCode)=PPInfo(InvID,cashCode)+$p(^DHCPEINVPRT(InvID),"^",21)
		//s totalAmt=totalAmt+$p(^DHCPEINVPRT(InvID),"^",21)
	}
	b ;totalAmt
	q:+totalAmt'=+$p(^DHCPEINVPRT(InvID),"^",7) 1   //支付金额不等于发票金额 直接返回失败
	s ErrFlag=0  ;发票支付方式金额 是否正确 0 正确  1 不正确
	ts:Force=1
	s paymode=""
	f  s paymode=$O(PPInfo(InvID,paymode))  q:(paymode="")||(ErrFlag=1)  d
	.b ;paymode
	.s invPayInfo=..GetPayAmtByPayId(InvID,paymode)
	.s payamount=PPInfo(InvID,paymode)
	.s invAmt=$P(invPayInfo,$C(1),1)
	.s balance=payamount-invAmt
	.b ;balance  payamount invAmt
	.i +balance'=0 d
	..i Force=0  s ErrFlag=1  q
	..e  d
	...s paymsubInfo=$P(invPayInfo,$C(1),2)
	...s paysubId=$P($P(paymsubInfo,$C(2),1),"^",1)
	...&SQL(Update Sqluser.ar_rcptpaymode set PAYM_Amt=PAYM_Amt+:balance where PAYM_RowId=:paysubId)
	...i SQLCODE'=0  s ErrFlag=1  q
	k PPInfo(InvID)
	i (Force=1)&(ErrFlag=1)  tro  q ErrFlag
	tc:Force=1
	q ErrFlag
}

ClassMethod GetPayAmtByPayId(InvID, PayModeId)
{
	s ARRCPID=$P(^DHCPEINVPRT(InvID),"^",4)
	q:ARRCPID="" 0
	s totalAmt=0,ids=""
	s PAYMSub=0
	f  s PAYMSub=$O(^ARRCP(ARRCPID,"PAYM",PAYMSub)) q:PAYMSub=""  d
	.s PayModeDr=$P(^ARRCP(ARRCPID,"PAYM",PAYMSub),"^",1)
	.q:PayModeDr'=PayModeId
	.s curAmt=$P(^ARRCP(ARRCPID,"PAYM",PAYMSub),"^",3)
	.s totalAmt=totalAmt+curAmt
	.i ids=""  d
	..s ids=ARRCPID_"||"_PAYMSub_"^"_curAmt
	.e  d
	..s ids=ids_$C(2)_ARRCPID_"||"_PAYMSub_"^"_curAmt
	q totalAmt_$C(1)_ids
}

/// Descript:判断审核记录对应的发票是否为预结算
/// Input:
/// 			AuditDR：DHC_PE_PreAudit
/// OutPut: 0 不是  1 是  3 未结算记录		
/// Creater:	wangguoying
/// CreateDate:	2020-02-20
/// Debug: w ##class(web.DHCPE.CashierEx).IsYJSByAuditDr(1361)
ClassMethod IsYJSByAuditDr(AuditDR)
{
	s ret=3
	s PaiedStatus=$P(^DHCPEPreA(AuditDR),"^",14)
	i PaiedStatus="CHARGED" 
	{
		s relateId=$O(^DHCPEPAPBR(0,"PADR",AuditDR,""))
		q:relateId="" 3
		s pbType=$P(^DHCPEPAPBR(relateId),"^",3)
		q:pbType'="N" 3
		s pbid=$P(^DHCPEPAPBR(relateId),"^",2)
		s invprt=$O(^DHCPEINVPRT(0,"PB",pbid,""))
		s invType=$P(^DHCPEINVPRT(invprt),"^",8)
		q:invType'="N" 3
		s invNo=$P(^DHCPEINVPRT(invprt),"^",1)
		i invNo["DHCPEYJS" s ret=1
		e  s ret=0
	}
	q ret
}

/// Descript:判断医嘱是否为预结算
/// Input:
/// 			OEORI：OE_OrdItem
/// OutPut: 0 不是  1 是  3 未结算记录		
/// Creater:	wangguoying
/// CreateDate:	2020-02-20
/// Debug: w ##class(web.DHCPE.CashierEx).IsYJSByOEORI(1361)
ClassMethod IsYJSByOEORI(OEORI)
{
	s ret=3
	q:$p(^OEORD(+OEORI,"I",$P(OEORI,"||",2),3),"^",5)'="P" 3
	s crmord=$O(^DHCPECRMO(0,"OEORI",OEORI,""))
	q:crmord="" 3
	s preIOrdItem=$P(^DHCPECRMO(crmord),"^",2)
	s ordEnt=$P(^DHCPEPreIADM(+preIOrdItem,"ORDITEM",$P(preIOrdItem,"||",2)),"^",2)
	s auditDr=""
	i ordEnt'="" d
	.s feeSub=0
	.f  s feeSub=$O(^DHCPEPreIADM(+ordEnt,"ORDENT",$P(ordEnt,"||",2),"FEE",feeSub)) q:(feeSub="")||(auditDr'="")  d
	..s curAudit=$P(^DHCPEPreIADM(+ordEnt,"ORDENT",$P(ordEnt,"||",2),"FEE",feeSub),"^",5)
	..s useFlag=$P(^DHCPEPreA(curAudit),"^",21)
	..q:useFlag="NU"
	..s paiedStatus=$P(^DHCPEPreA(curAudit),"^",14)
	..q:paiedStatus="UNCHARGED"
	..s auditDr=curAudit 
	e  d
	.s feeSub=0
	.f  s feeSub=$O(^DHCPEPreIADM(+preIOrdItem,"ORDITEM",$P(preIOrdItem,"||",2),"FEE",feeSub)) q:(feeSub="")||(auditDr'="")  d
	..s curAudit=$P(^DHCPEPreIADM(+preIOrdItem,"ORDITEM",$P(preIOrdItem,"||",2),"FEE",feeSub),"^",5)
	..s useFlag=$P(^DHCPEPreA(curAudit),"^",21)
	..q:useFlag="NU"
	..s paiedStatus=$P(^DHCPEPreA(curAudit),"^",14)
	..q:paiedStatus="UNCHARGED"
	..s auditDr=curAudit 
	q:auditDr="" 3
	q ..IsYJSByAuditDr(auditDr)
}

/// function：判断是否存在凑整费
/// d ##class(web.DHCPE.CashierEx).IsExistRoundFee()
ClassMethod IsExistRoundFee(preAuditIds)
{
	s flag="0"
	s j=1
	while(j<=$l(preAuditIds,",")){
		s preAuditId=$p(preAuditIds,",",j)
		s j=j+1
		continue:preAuditId=""
		s preAdmId=0
		f  s preAdmId=$o(^DHCPEPreIADM(0,"PAORDITEM",preAuditId,preAdmId)) q:((preAdmId="")||(flag="1"))  d
		.q:'$D(^DHCPEDataEx("InsertRoundFee",preAdmId))
		.s childsub=0
		.f  s childsub=$O(^DHCPEDataEx("InsertRoundFee",preAdmId,childsub)) q:childsub=""  d
	    ..q:flag=1
		..i $d(^DHCPEDataEx("InsertRoundFee",preAdmId,childsub)) s flag=1
	}
	q flag
}

/// Descript:获取发票医保结算信息
/// Input:
/// 			Invprt：DHC_PE_INVPRT
/// OutPut: 	医保结算ID^费别^医疗类别
/// Creater:	wangguoying
/// CreateDate:	2022-07-04
/// Debug: w ##class(web.DHCPE.CashierEx).GetInsuInfo(1361)
ClassMethod GetInsuInfo(Invprt)
{
	i $p(^DHCPEINVPRT(Invprt),"^",8)'="N"  s Invprt = $p(^DHCPEINVPRT(Invprt),"^",9)
	s insuId = $P($G(^DHCPEOEITEM(Invprt)),"^",4)
	q:insuId="" ""
	q insuId_"^"_$P($G(^DHCPEOEITEM(Invprt)),"^",6)_"^"_$P($G(^DHCPEOEITEM(Invprt)),"^",7)
}

/// Descript:根据计费订单更新真实的支付方式
/// Input:
/// 		PEInvID：体检发票ID	
/// 		ETPRowID：计费交易记录ID	
/// Return:		0：成功  非0^失败
/// Creater:	wangguoying
/// CreateDate:	2022-05-13
/// Debug: w ##class(web.DHCPE.CashierEx).UpdatePayCodeByETPRowID("2652")
ClassMethod UpdatePayCodeByETPRowID(PEInvID, ETPRowID)
{
	s realPayMode = ##class(DHCBILL.Common.DHCBILLCommon).GetETPPayModeID(ETPRowID)
	i realPayMode'=""
	{
		s curExtInfo = ..GetPayInfoByPayCode(PEInvID)
		q:curExtInfo="" "-1^原支付方式不存在"
		s oldPayMode = $P(curExtInfo,"^",1)
		q:oldPayMode=realPayMode 0
		s ARRCPID=$P(^DHCPEINVPRT(PEInvID),"^",4)
		&sql(update SqlUser.AR_RcptPayMode set PAYM_PayMode_DR=:realPayMode where PAYM_ParRef=:ARRCPID and PAYM_PayMode_DR=:oldPayMode)
		q SQLCODE
	}
	q 0
}

Storage Default
{
<Data name="CashierExDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCPE.CashierExD</DataLocation>
<DefaultData>CashierExDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCPE.CashierExD</IdLocation>
<IndexLocation>^web.DHCPE.CashierExI</IndexLocation>
<StreamLocation>^web.DHCPE.CashierExS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
