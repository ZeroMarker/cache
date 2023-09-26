Class web.DHCPE.PreItemListEx Extends %Persistent
{

/// Description: 判断是否已经包含医嘱中的细项
/// Input:       PreIAdmID：预约ID, ArcimID：医嘱项ID
/// Return:      0：不包含  2：包含
/// Debug:  d ##class(web.DHCPE.PreItemListEx).HadLisDetail("39125","20859||1")
ClassMethod HadLisDetail(PreIAdmID, ArcimID)
{
	 i $L(PreIAdmID,"||")>1 d
	 .s LocID=$P($g(^DHCPEPreGADM(+PreIAdmID)),"^",23)
	 e  s LocID=$P($g(^DHCPEPreIADM(PreIAdmID)),"^",26)
	 
	 s LabStation=$G(^DHCPESetting("DHCPE","StationId_Lab",LocID))

	//s STID=$O(^DHCPEST(0,"STORD_ARCIM",ArcimID,0))
	//根据医嘱项ID查找对应OrderDR（站点和项目组合ID）
	s StatOrderDR=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(ArcimID,LocID)
    s STID=$p(StatOrderDR,"||",1)            //站点ID
	q:STID'=LabStation 0
	
	s Job=$J
	s Flag=0
	k ^TempDHCPEPreItemListEx(Job,"LisDetail")
	s CurArcimID=""
	
	i $L(PreIAdmID,"||")>1 d
	.;分组
	.s GADM=+PreIAdmID
	.s GTeam=$P(PreIAdmID,"||",2)
	.s Sub=0
	.f  s Sub=$O(^DHCPEPreGADM(GADM,"Team",GTeam,"ORDITEM",Sub)) q:Sub=""  d
	..s CurArcimID=$P($g(^DHCPEPreGADM(GADM,"Team",GTeam,"ORDITEM",Sub)),"^",1)
	..q:CurArcimID=""
	..s Stat=$P($g(^DHCPEPreGADM(GADM,"Team",GTeam,"ORDITEM",Sub)),"^",13)
	..q:Stat'="1"
	..d SetTempListEx
	e  d
	.;个人
	.s Sub=0
	.f  s Sub=$O(^DHCPEPreIADM(PreIAdmID,"ORDITEM",Sub)) q:Sub=""  d
	..s CurArcimID=$P($g(^DHCPEPreIADM(PreIAdmID,"ORDITEM",Sub)),"^",1)
	..q:CurArcimID=""
	..s Stat=$P($g(^DHCPEPreIADM(PreIAdmID,"ORDITEM",Sub)),"^",16)
	..q:Stat'="1"
	..d SetTempListEx
	
	q:CurArcimID="" 0
	
	s ODRID=0
	//f  s ODRID=$O(^DHCPEODR(0,"ARCIM",ArcimID,ODRID)) q:(ODRID="")||(Flag=2)  d
	f  s ODRID=$o(^DHCPEODR(0,"OrderID",StatOrderDR,ODRID))  q:(ODRID="")||(Flag=2)  d
	.s ODSort=+$P($g(^DHCPEODR(ODRID)),"^",3)
	.q:ODSort=0
	.s ODID=$P($g(^DHCPEODR(ODRID)),"^",2)
	.s ODDesc=$p($g(^DHCPEST(+ODID,"OD",$p(ODID,"||",2))),"^",1)
	.q:ODDesc="备注"
	.i $D(^TempDHCPEPreItemListEx(Job,"LisDetail",ODID)) s Flag=2
	
	k ^TempDHCPEPreItemListEx(Job,"LisDetail")
	q Flag
	
SetTempListEx
	//s STID=$O(^DHCPEST(0,"STORD_ARCIM",CurArcimID,0))
	//根据医嘱项ID查找对应OrderDR（站点和项目组合ID）
	s CurStatOrderDR=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(CurArcimID,LocID)
    s CurSTID=$p(CurStatOrderDR,"||",1)            //站点ID
	q:CurSTID'=LabStation 

	s ODRID=0
	//f  s ODRID=$O(^DHCPEODR(0,"ARCIM",CurArcimID,ODRID)) q:ODRID=""  d
	f  s ODRID=$o(^DHCPEODR(0,"OrderID",CurStatOrderDR,ODRID))  q:ODRID=""  d
	.s ODSort=+$P($g(^DHCPEODR(ODRID)),"^",3)
	.q:ODSort=0
	.s ODID=$P($g(^DHCPEODR(ODRID)),"^",2)
	.s ^TempDHCPEPreItemListEx(Job,"LisDetail",ODID)=""
	q
}

ClassMethod GetAdmInfo(PreIADMID)
{
	//d ##class(web.DHCPE.PreItemListEx).GetAdmInfo(60317)
	s WinType=##class(web.DHCPE.PrintIAdmInfo).GetWinSetType("")
	
	q:WinType'=1 ""
	//s SendSTID="^13^14^15^27^28^"
	s SendSTID=$g(^DHCPESetting("DHCPE","StationId_Ris","SendRisApplication"))
	q:PreIADMID="" ""
	q:$L(PreIADMID,"||")>1 ""
	s IADM=$O(^DHCPEIADM(0,"CRMADM",PreIADMID,0))
	q:IADM="" ""
	s PAADM=$P(^DHCPEIADM(IADM),"^",1)
	/*
	s PatID=$P(^PAADM(PAADM),"^",1)
	q PAADM_"^"_PatID
	b ;PAADM
	*/
	q:PAADM="" ""
	
	s OrderID=$O(^OEORD(0,"Adm",PAADM,0))
	q:OrderID="" ""
	s OrderSub=0
	s Flag=0
	f  s OrderSub=$O(^OEORD(OrderID,"I",OrderSub)) q:(OrderSub="")||(Flag=1)  d
	.
	.s ItemStat=$P($G(^OEORD(OrderID,"I",OrderSub,1)),"^",13)
	.q:ItemStat'="1"
	.s ArcimID=$P(^OEORD(OrderID,"I",OrderSub,1),"^",2)
	.s STID=$O(^DHCPEST(0,"STORD_ARCIM",ArcimID,0))
	.q:SendSTID'[("^"_STID_"^")
	.b ;SendSTID
	.q:"Y"=##class(web.DHCRisApplicationBill).IsSendAppBill(OrderID_"||"_OrderSub)
	.s Flag=1
	q:Flag=0 ""
	s PatID=$P(^PAADM(PAADM),"^",1)
	s MRAdm=$P(^PAADM(PAADM),"^",61)
	q PAADM_"^"_PatID_"^"_MRAdm
}

ClassMethod UpdateSpecInfo(OEORDItemID)
{
	q 0
	;d ##class(web.DHCPE.PreItemListEx).UpdateSpecInfo("4366061||4")
	s SQLCODE=0
	s OrderID=+OEORDItemID
	s SpecNo=$p($G(^OEORD(OrderID,"I",$P(OEORDItemID,"||",2),3)),"^",20)
	q:SpecNo="" SQLCODE
	s NewSpecNo=""
	s OrdStr=""
	s OrderSub=0
	f  s OrderSub=$O(^OEORD(0,"EpisNo",SpecNo,OrderID,OrderSub))  q:(OrderSub="")||(SQLCODE'=0)  d
	.s NewOrderItemID=OrderID_"||"_OrderSub
	.q:OEORDItemID=NewOrderItemID
	.s Stat=$P(^OEORD(OrderID,"I",OrderSub,1),"^",13)
	.q:Stat'="1"
	.q:'$D(^DHCPEDataEx("SendRisRequest",NewOrderItemID))
	.s:NewSpecNo="" NewSpecNo=$I(^PEEPIS(0))
	.&SQL(Update SQLUser.OE_OrdItem set OEORI_LabEpisodeNo=:NewSpecNo where OEORI_RowID=:NewOrderItemID)
	.;b ;SQLCODE
	.q:SQLCODE'=0
	.i OrdStr="" d
	..s OrdStr=NewOrderItemID
	.e  d
	..s OrdStr=OrdStr_"^"_NewOrderItemID
	q:SQLCODE'=0 SQLCODE
	q:OrdStr="" SQLCODE
	d ##class(web.DHCPE.CRM.RisGateway).SendRequestInfo(OrdStr)
	q SQLCODE
}

ClassMethod GetRoundFee(PreIADM)
{
	q:PreIADM="" ""
	s RetInfo=""
	s PreItemSub=""
	f  s PreItemSub=$O(^DHCPEDataEx("InsertRoundFee",PreIADM,PreItemSub)) q:PreItemSub=""  d
	.s Stat=$P(^DHCPEPreIADM(PreIADM,"ORDITEM",PreItemSub),"^",16)
	.q:Stat'="1"
	.s OneInfo=$G(^DHCPEDataEx("InsertRoundFee",PreIADM,PreItemSub))
	.s RoundType=$P(OneInfo,"^",1)
	.s RoundType=##class(web.DHCPE.CashierEx).GetRoundTypeDesc(RoundType)
	.s RoundRemak=$P(OneInfo,"^",2)
	.s RoundFee=$P(OneInfo,"^",3)
	.i RetInfo="" d
	..s RetInfo=RoundType_"^"_RoundRemak_"^"_RoundFee
	.e  d
	..s RetInfo=RetInfo_"$$"_RoundType_"^"_RoundRemak_"^"_RoundFee
	q RetInfo
}

ClassMethod GetIFeeAsCharged(PreIAdmID)
{
	q:$L(PreIAdmID,"||")>1 ""
	s PreIAdmID=$P(PreIAdmID,"^",1)
	s IFeeAsCharged=$G(^DHCPEPreIADM(PreIAdmID,"IFeeAsCharged"))
	q:IFeeAsCharged'="" IFeeAsCharged  ;优先返回有设置的
	s GID=$P(^DHCPEPreIADM(PreIAdmID),"^",2)
	q:GID="" $P(^DHCPEPreIADM(PreIAdmID),"^",9) ;返回个人的视同收费状态
	q $G(^DHCPEPreIADM(PreIAdmID,"IFeeAsCharged"))
}

ClassMethod SetIFeeAsCharged(PreIAdmID, AsCharged)
{
	q:$L(PreIAdmID,"||")>1 "团体不允许设置自费加项"
	s l=$L(PreIAdmID,"^")
	i l=1
	{
		s GID=$P(^DHCPEPreIADM(PreIAdmID),"^",2)
	}
	f i=1:1:l d
	.s IAdmID=$P(PreIAdmID,"^",i)
	.s ^DHCPEPreIADM(IAdmID,"IFeeAsCharged")=AsCharged
	q ""
}

/// Description:  "转公费"、"转自费"按钮显示
/// Input:         PreItemID(个人预约ID)
/// Debug:  w ##class(web.DHCPE.PreItemListEx).OutChangeFeeButtonHISUI()
ClassMethod OutChangeFeeButtonHISUI(PreItemID)
{
	q:PreItemID="" ""
	s PreGADM=$p($G(^DHCPEPreIADM(+PreItemID)),"^",2)
	q:PreGADM="" ""
	s LimitAmout=""
	s LimitAmout=$p($G(^DHCPEPreIADM(+PreItemID)),"^",12)
	q:+LimitAmout>0 ""
	q:'$d(^DHCPEPreIADM(+PreItemID,"ORDITEM",$P(PreItemID,"||",2))) ""
	s TItemID=$P($g(^DHCPEPreIADM(+PreItemID,"ORDITEM",$P(PreItemID,"||",2))),"^",4)
	q:TItemID'="" ""
	s crmID=$o(^DHCPECRMO(0,"CRMORI",PreItemID,0))
	q:crmID="" ""
	s PreEntID=$P($g(^DHCPEPreIADM(+PreItemID,"ORDITEM",$P(PreItemID,"||",2))),"^",2)
	s QFlag=0
	s AType=""
	
	/***iMedical 8.5之后套餐都是以单个项目存在 start***/
	
	/*
	i (PreEntID'="")&&$D(^DHCPEPreIADM(+PreItemID,"ORDENT",$P(PreEntID,"||",2),"FEE")) d
	.s FeeSub=0
	.f s FeeSub=$O(^DHCPEPreIADM(+PreItemID,"ORDENT",$P(PreEntID,"||",2),"FEE",FeeSub)) q:(FeeSub="")||(QFlag=1) d
	..s AuditID=$P($g(^DHCPEPreIADM(+PreItemID,"ORDENT",$P(PreEntID,"||",2),"FEE",FeeSub)),"^",5)
	..q:AuditID="" 
	..s Status=$P($g(^DHCPEPreA(AuditID)),"^",21)
	..q:Status="NU"
	..s Status=$P($g(^DHCPEPreA(AuditID)),"^",14)
	..i Status="CHARGED" d
	...s QFlag=1
	..e d
	...s AType=$P($g(^DHCPEPreA(AuditID)),"^",1)
	e d
	.s FeeSub=0
	.f s FeeSub=$O(^DHCPEPreIADM(+PreItemID,"ORDITEM",$P(PreItemID,"||",2),"FEE",FeeSub)) q:(FeeSub="")||(QFlag=1) d
	..s AuditID=$P($g(^DHCPEPreIADM(+PreItemID,"ORDITEM",$P(PreItemID,"||",2),"FEE",FeeSub)),"^",5) 
	..q:AuditID=""
	..s Status=$P($g(^DHCPEPreA(AuditID)),"^",21)
	..q:Status="NU"
	..s Status=$P($g(^DHCPEPreA(AuditID)),"^",14)
	..
	..i Status="CHARGED" d
	...s QFlag=1
	..e d
	...s AType=$P($g(^DHCPEPreA(AuditID)),"^",1)
	*/
	
	/***iMedical 8.5之后套餐都是以单个项目存在 end***/
	s FeeSub=0
	f  s FeeSub=$O(^DHCPEPreIADM(+PreItemID,"ORDITEM",$P(PreItemID,"||",2),"FEE",FeeSub)) q:(FeeSub="")||(QFlag=1)  d
	.s AuditID=$P($g(^DHCPEPreIADM(+PreItemID,"ORDITEM",$P(PreItemID,"||",2),"FEE",FeeSub)),"^",5) 
	.q:AuditID=""
	.s Status=$P($g(^DHCPEPreA(AuditID)),"^",21)
	.q:Status="NU"
	.s Status=$P($g(^DHCPEPreA(AuditID)),"^",14)
	.i Status="CHARGED" d
	..s QFlag=1
	.e  d
	..s AType=$P($g(^DHCPEPreA(AuditID)),"^",1)

	q:QFlag=1 ""
	
	s ButtonID=PreItemID_"^ORDITEM"
	
	/***iMedical 8.5之后套餐都是以单个项目存在 start***/
	
	/*
	i PreEntID'="" d
	.s ButtonID=PreEntID_"^ORDENT"
	*/
	
	/***iMedical 8.5之后套餐都是以单个项目存在 end***/

	
	i AType="G" d
	.s ButtonDesc="转自费"
	.s ButtonID=ButtonID_"^I"
	e  d
	.s ButtonDesc="转公费"
	.s ButtonID=ButtonID_"^G"

   q "<a href='#' onclick='ChangeFeeTypeFuction()' id='"_ButtonID_"' >"_ButtonDesc_"</a>"
}

/// debug: w ##class(web.DHCPE.PreItemListEx).OutChangeFeeButton("506||3")
ClassMethod OutChangeFeeButton(PreItemID)
{
	q:PreItemID="" ""
	s LimitAmout=""
	s LimitAmout=$p($G(^DHCPEPreIADM(+PreItemID)),"^",12)
	q:+LimitAmout>0
	q:'$d(^DHCPEPreIADM(+PreItemID,"ORDITEM",$P(PreItemID,"||",2))) ""
	s TItemID=$P($g(^DHCPEPreIADM(+PreItemID,"ORDITEM",$P(PreItemID,"||",2))),"^",4)
	q:TItemID'="" ""
	s PreEntID=$P($g(^DHCPEPreIADM(+PreItemID,"ORDITEM",$P(PreItemID,"||",2))),"^",2)
	s QFlag=0
	s AType=""
	i PreEntID'="" d
	.s FeeSub=0
	.f  s FeeSub=$O(^DHCPEPreIADM(+PreItemID,"ORDENT",$P(PreEntID,"||",2),"FEE",FeeSub)) q:(FeeSub="")||(QFlag=1)  d
	..s AuditID=$P(^DHCPEPreIADM(+PreItemID,"ORDENT",$P(PreEntID,"||",2),"FEE",FeeSub),"^",5)	
	..s Status=$P(^DHCPEPreA(AuditID),"^",21)
	..q:Status="NU"
	..s Status=$P(^DHCPEPreA(AuditID),"^",14)
	..i Status="CHARGED" d
	...s QFlag=1
	..e  d
	...s AType=$P(^DHCPEPreA(AuditID),"^",1)
	e  d
	.s FeeSub=0
	.f  s FeeSub=$O(^DHCPEPreIADM(+PreItemID,"ORDITEM",$P(PreItemID,"||",2),"FEE",FeeSub)) q:(FeeSub="")||(QFlag=1)  d
	..s AuditID=$P(^DHCPEPreIADM(+PreItemID,"ORDITEM",$P(PreItemID,"||",2),"FEE",FeeSub),"^",5)	
	..s Status=$P(^DHCPEPreA(AuditID),"^",21)
	..q:Status="NU"
	..s Status=$P(^DHCPEPreA(AuditID),"^",14)
	..;w AuditID_"^"_Status
	..i Status="CHARGED" d
	...s QFlag=1
	..e  d
	...s AType=$P(^DHCPEPreA(AuditID),"^",1)
	q:QFlag=1 ""
	s ButtonID=PreItemID_"^ORDITEM"
	i PreEntID'="" d
	.s ButtonID=PreEntID_"^ORDENT"
	i AType="G" d
	.s ButtonDesc="转自费"
	.s ButtonID=ButtonID_"^I"
	e  d
	.s ButtonDesc="转公费"
	.s ButtonID=ButtonID_"^G"
	w "<button onclick='ChangeFeeTypeFuction()' id='"_ButtonID_"'>"_ButtonDesc_"</button>"
	q ""
}

ClassMethod ChangeFeeType(ItemInfo)
{
	s ItemID=$P(ItemInfo,"^",1)
	s ItemType=$P(ItemInfo,"^",2)
	s NewFeeType=$P(ItemInfo,"^",3)
	s TeamID=$P(^DHCPEPreIADM(+ItemID),"^",3)
 	s SQLCODE=0
	i NewFeeType="G" d
	.s PreAuditID=##class(web.DHCPE.PreItemList).GetPARowId("G",TeamID,"PRE")
	.//s ADDAuditID=##class(web.DHCPE.PreItemList).GetPARowId("G",OldTeam,"ADD")
	e  d
	.//s PreAuditID=##class(web.DHCPE.PreItemList).GetPARowId("I",PreIADMID,"PRE")
	.s PreAuditID=##class(web.DHCPE.PreItemList).GetPARowId("I",+ItemID,"ADD")
	s FeeSub=0
	f  s FeeSub=$O(^DHCPEPreIADM(+ItemID,ItemType,$P(ItemID,"||",2),"FEE",FeeSub)) q:(FeeSub="")  d
	.s AuditID=$P(^DHCPEPreIADM(+ItemID,ItemType,$P(ItemID,"||",2),"FEE",FeeSub),"^",5)	
	.s Status=$P(^DHCPEPreA(AuditID),"^",21)
	.q:Status="NU"
	.s Status=$P(^DHCPEPreA(AuditID),"^",14)
	.q:Status="CHARGED"
	.s FeeID=ItemID_"||"_FeeSub
	.i ItemType="ORDITEM" d
	..&SQL(update sqluser.dhc_pe_preiorditemfee set PIOIF_PAudit_DR=:PreAuditID where pioif_rowid=:FeeID)
	.e  d
	..&SQL(update sqluser.dhc_pe_preiordentfee set PIOEF_PAudit_DR=:PreAuditID where pioef_rowid=:FeeID)
	.d ##class(web.DHCPE.PreIADM).UpdatePersonAuditAmount(+FeeID)
	
	
	s GAsCharged=$P(^DHCPEPreIADM(+ItemID),"^",9)
	s IAsCharged=$g(^DHCPEPreIADM(+ItemID,"IFeeAsCharged"))
	if (ItemType="ORDITEM")
	{
	i (NewFeeType="G")&&(GAsCharged="Y") d
	.s crmID=$o(^DHCPECRMO(0,"CRMORI",ItemID,0))
	.i crmID'="" d
	..&SQL(update sqluser.DHC_PE_CRMOrder set CRMO_BillStatus='OC' where CRMO_RowID=:crmID)
	..q:SQLCODE'=0
	..s OEORDID=$p(^DHCPECRMO(crmID),"^",1)
	..&SQL(update sqluser.OE_OrdItem set OEORI_Billed='P' where OEORI_RowID=:OEORDID)
	
	i (NewFeeType="G")&&(GAsCharged'="Y") d
	.s crmID=$o(^DHCPECRMO(0,"CRMORI",ItemID,0))
	.i crmID'="" d
	..&SQL(update sqluser.DHC_PE_CRMOrder set CRMO_BillStatus='NP' where CRMO_RowID=:crmID)
	..q:SQLCODE'=0
	..s OEORDID=$p(^DHCPECRMO(crmID),"^",1)
	..&SQL(update sqluser.OE_OrdItem set OEORI_Billed='TB' where OEORI_RowID=:OEORDID)
	
	
	
	i (NewFeeType="I")&&(IAsCharged="Y") d
	.s crmID=$o(^DHCPECRMO(0,"CRMORI",ItemID,0))
	.i crmID'="" d
	..&SQL(update sqluser.DHC_PE_CRMOrder set CRMO_BillStatus='OC' where CRMO_RowID=:crmID)
	..q:SQLCODE'=0
	..s OEORDID=$p(^DHCPECRMO(crmID),"^",1)
	..&SQL(update sqluser.OE_OrdItem set OEORI_Billed='P' where OEORI_RowID=:OEORDID)
	
	
	
	i (NewFeeType="I")&&(IAsCharged'="Y") d
	.s crmID=$o(^DHCPECRMO(0,"CRMORI",ItemID,0))
	.i crmID'="" d
	..&SQL(update sqluser.DHC_PE_CRMOrder set CRMO_BillStatus='NP' where CRMO_RowID=:crmID)
	..q:SQLCODE'=0
	..s OEORDID=$p(^DHCPECRMO(crmID),"^",1)
	..&SQL(update sqluser.OE_OrdItem set OEORI_Billed='TB' where OEORI_RowID=:OEORDID)
	}
	
	q SQLCODE
}

/// d ##class(web.DHCPE.PreItemListEx).SaveNoPayItem()
ClassMethod SaveNoPayItem()
{
	s $ZT="SaveNoPayItemErr"
	s CurDate=+$H
	q:$D(^DHCPENoPayItemI(CurDate)) "已经生成了未付费记录"
	s Sort=$I(^DHCPENoPayItem(0))
	;s ^DHCPENoPayItem(Sort)=+$H
	s ITotal=0
	s GTotal=0
	s Total=0
	s PIADM=""
	f  s PIADM=$O(^DHCPEPreIADM(PIADM),-1) q:PIADM=""||PIADM=0  d
	.s Status=$P(^DHCPEPreIADM(PIADM),"^",8)
	.q:Status="ARRIVED"
	.s GID=$P(^DHCPEPreIADM(PIADM),"^",2)
	.s Type="I"
	.s:GID'="" Type=GID
	.s OneAdmAmt=0
	.s ItemSub=0
	.f  s ItemSub=$O(^DHCPEPreIADM(PIADM,"ORDITEM",ItemSub)) q:ItemSub=""  d
	..s EntID=$P(^DHCPEPreIADM(PIADM,"ORDITEM",ItemSub),"^",2)
	..q:EntID'=""
	..s ItemStat=$P(^DHCPEPreIADM(PIADM,"ORDITEM",ItemSub),"^",16)
	..q:ItemStat'="1"
	..s ItemFeeSub=0
	..f  s ItemFeeSub=$O(^DHCPEPreIADM(PIADM,"ORDITEM",ItemSub,"FEE",ItemFeeSub)) q:ItemFeeSub=""  d
	...s AuditID=$P(^DHCPEPreIADM(PIADM,"ORDITEM",ItemSub,"FEE",ItemFeeSub),"^",5)
	...q:AuditID=""
	...s PayedFlag=$p(^DHCPEPreA(AuditID),"^",14)
	...q:PayedFlag="CHARGED"
	...s Amt=$P(^DHCPEPreIADM(PIADM,"ORDITEM",ItemSub,"FEE",ItemFeeSub),"^",2)
	...s OneAdmAmt=OneAdmAmt+Amt
	...s FeeID=PIADM_"||"_ItemSub_"||"_ItemFeeSub
	...s ^DHCPENoPayItem(Sort,Type,PIADM,"ORDITEM",FeeID)=Amt
	.s ItemSub=0
	.f  s ItemSub=$O(^DHCPEPreIADM(PIADM,"ORDENT",ItemSub)) q:ItemSub=""  d
	..s ItemStat=$P(^DHCPEPreIADM(PIADM,"ORDENT",ItemSub),"^",9)
	..q:ItemStat'="1"
	..s ItemFeeSub=0
	..f  s ItemFeeSub=$O(^DHCPEPreIADM(PIADM,"ORDENT",ItemSub,"FEE",ItemFeeSub)) q:ItemFeeSub=""  d
	...s AuditID=$P(^DHCPEPreIADM(PIADM,"ORDENT",ItemSub,"FEE",ItemFeeSub),"^",5)
	...q:AuditID=""
	...s PayedFlag=$p(^DHCPEPreA(AuditID),"^",14)
	...q:PayedFlag="CHARGED"
	...s Amt=$P(^DHCPEPreIADM(PIADM,"ORDENT",ItemSub,"FEE",ItemFeeSub),"^",2)
	...s OneAdmAmt=OneAdmAmt+Amt
	...s FeeID=PIADM_"||"_ItemSub_"||"_ItemFeeSub
	...s ^DHCPENoPayItem(Sort,Type,PIADM,"ORDENT",FeeID)=Amt
	.i +OneAdmAmt'=0 d
	..s ^DHCPENoPayItem(Sort,Type,PIADM)=OneAdmAmt
	..s ^DHCPENoPayItem(Sort,Type)=+$G(^DHCPENoPayItem(Sort,Type))+OneAdmAmt
	..s Total=Total+OneAdmAmt
	..i Type'="I" d
	...s GTotal=GTotal+OneAdmAmt
	..e  d
	...s ITotal=ITotal+OneAdmAmt
	s ^DHCPENoPayItem(Sort)=$H_"^"_Total_"^"_GTotal_"^"_ITotal
	s ^DHCPENoPayItemI(CurDate)=Sort
	q 0
SaveNoPayItemErr
	s ^DHCPENoPayItemErr(+$H)=$ZERROR
	q -1
}

ClassMethod SearchNoPayItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchNoPayItemExecute ]
{
	Set repid=$LIST(qHandle,2)
	 Kill ^CacheTemp(repid)
	 Quit $$$OK
}

ClassMethod SearchNoPayItemExecute(ByRef qHandle As %Binary, StartDate As %String = "", EndDate As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	if (StartDate=""&&(EndDate=""))
 	{
	 	Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 	s:StartDate["-" StartDate=$ZDH(StartDate,3)
 	s:EndDate["-" EndDate=$ZDH(EndDate,3)
 	s:StartDate["/" StartDate=$ZDH(StartDate,4)
 	s:EndDate["/" EndDate=$ZDH(EndDate,4)
 	s:StartDate="" StartDate=1
 	s:EndDate="" EndDate=+$H
	s Date=StartDate-1
	f  s Date=$O(^DHCPENoPayItemI(Date)) q:Date=""||(Date>EndDate)  d
	.s TDate=$ZD(Date,3)
	.s TSort=$G(^DHCPENoPayItemI(Date))
	.s AmtInfo=$G(^DHCPENoPayItem(TSort))
	.s TTotal=$P(AmtInfo,"^",2)
	.s TGTotal=$P(AmtInfo,"^",3)
	.s TITotal=$P(AmtInfo,"^",4)
	.d FindBuild

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
FindBuild      
	set Data=$lb(TSort,TDate,TTotal,TGTotal,TITotal)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SearchNoPayItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchNoPayItemExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 	Set AtEnd=1
 	Set Row=""
 	}
 	Else      {				// fetch row
 	Set Row=^CacheTemp(repid,ind)
 	}
 	// , PatientNo As %String, SurName As %String, CurrentDept As %String, CurrentBed As %String, CurrentWard As %String, CurrentDoctor As %String, StartDate As %Date, EndDate As %Date, CurrentAdmType As %String, CONTEXT As %String
 	// Save QHandlePatientNo As %String, SurName As %String, CurrentDept As %String, CurrentBed As %String, CurrentWard As %String, CurrentDoctor As %String, StartDate As %Date, EndDate As %Date, CurrentAdmType As %String	
 	s qHandle=$lb(AtEnd,repid,ind)
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.PreItemListEx","SearchNoPayItem","","2016-12-13")
Query SearchNoPayItem(StartDate As %String = "", EndDate As %String = "") As %Query(ROWSPEC = "TSort:%String:序号,TDate:%String:截止日期,TTotal:%String:总额,TGTotal:%String:团体总额,TITotal:%String:个人总额") [ SqlProc ]
{
}

ClassMethod SearchNoPayItemDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchNoPayItemDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
	 Kill ^CacheTemp(repid)
	 Quit $$$OK
}

ClassMethod SearchNoPayItemDetailExecute(ByRef qHandle As %Binary, Sort As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	if (Sort="")
 	{
	 	Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 	s GID=""
	f  s GID=$O(^DHCPENoPayItem(Sort,GID)) q:GID=""  d
	.s TSort=Sort
	.i GID="I" d
	..s TGroup="个人"
	.e  d
	..s TGroup=$P(^DHCPEPreGADM(GID),"^",1)
	..s TGroup=$P(^DHCPEPreGBI(GID),"^",2)
	.s TTotal=$G(^DHCPENoPayItem(Sort,GID))
	.d FindBuild

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
FindBuild      
	set Data=$lb(TSort,TGroup,TTotal)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SearchNoPayItemDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchNoPayItemDetailExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 	Set AtEnd=1
 	Set Row=""
 	}
 	Else      {				// fetch row
 	Set Row=^CacheTemp(repid,ind)
 	}
 	// , PatientNo As %String, SurName As %String, CurrentDept As %String, CurrentBed As %String, CurrentWard As %String, CurrentDoctor As %String, StartDate As %Date, EndDate As %Date, CurrentAdmType As %String, CONTEXT As %String
 	// Save QHandlePatientNo As %String, SurName As %String, CurrentDept As %String, CurrentBed As %String, CurrentWard As %String, CurrentDoctor As %String, StartDate As %Date, EndDate As %Date, CurrentAdmType As %String	
 	s qHandle=$lb(AtEnd,repid,ind)
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.PreItemListEx","SearchNoPayItemDetail","1")
Query SearchNoPayItemDetail(Sort As %String = "") As %Query(ROWSPEC = "TSort:%String:序号,TGroup:%String:单位名称,TTotal:%String:总额") [ SqlProc ]
{
}

/*
ClassMethod ChangeVipLevel(PAADM, iVIP)
{

	
	s IADMRowId=$o(^DHCPEIADM(0,"PAADM",PAADM,""),-1)
	q:IADMRowId="" 1
	s PreIAdmID=$P($g(^DHCPEIADM(IADMRowId)),"^",4)
	q:PreIAdmID="" 1
	s $p(^DHCPEPreIADM(PreIAdmID),"^",18)=iVIP

	q 0
}
*/
ClassMethod ChangeVipLevel(PreIAdmID, iVIP)
{
	q:PreIAdmID="" 1
	s $p(^DHCPEPreIADM(PreIAdmID),"^",18)=iVIP
	q 0
}

Storage Default
{
<Data name="PreItemListExDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCPE.PreItemListExD</DataLocation>
<DefaultData>PreItemListExDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCPE.PreItemListExD</IdLocation>
<IndexLocation>^web.DHCPE.PreItemListExI</IndexLocation>
<StreamLocation>^web.DHCPE.PreItemListExS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
