Class web.DHCPE.OrdSetsPrice Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Create by MLH 2008-01-31 
/// 分摊医嘱套费用的医嘱  
/// w ##class(web.DHCPE.OrdSetsPrice).SplitOrdSetPrice("6630||1")
/// PIOIRowId=6630||1 OrdItemFactFEE=1.666666666666666667
ClassMethod SplitOrdSetPrice(PIOIOrdEntDR)
{
    
   Quit:$g(PIOIOrdEntDR)=""
    Set PIADMRowId=$p(PIOIOrdEntDR,"||",1)
    Quit:$g(PIADMRowId)=""
    Set PIOESub=$p(PIOIOrdEntDR,"||",2)
    Quit:$g(PIOESub)=""
    
    Kill ^DHCPEDataEx("DHC_PE_PreIOrdItemFee","PIOEFEE",PIOIOrdEntDR)

    Set PIOISub=0,PIOICount=0,PIOIEntFeeSum=0
    For  Set PIOISub=$o(^DHCPEPreIADM(0,"OrdEnt",PIOIOrdEntDR,PIADMRowId,PIOISub)) Quit:(PIOISub="")  Do
    .Set PIOIRowId=PIADMRowId_"||"_PIOISub
    .Set PIOIItemStat=$p($g(^DHCPEPreIADM(PIADMRowId,"ORDITEM",PIOISub)),"^",16)
    .Quit:(PIOIItemStat="4")
    .Set ^DHCPEDataEx("DHC_PE_PreIOrdItemFee","PIOEFEE",PIOIOrdEntDR,PIOIRowId)=""
    .;Set PIOICount=PIOICount+1
    .//Set PIOIFee=$p($g(^DHCPEPreIADM(PIADMRowId,"ORDITEM",PIOISub)),"^",14)
    .Set ARCIMDR=$p($g(^DHCPEPreIADM(PIADMRowId,"ORDITEM",PIOISub)),"^",1)
    .Quit:$g(ARCIMDR)=""
    .s ItemFeeType=$G(^DHCPEDataEx("DHCPEPreIADM","ADMFeeType","Item",PIADMRowId_"||"_PIOISub))  //根据项目取对应的体检费别 for 协和
    .Set PIOIFee=+##class(web.DHCPE.PreItemList).GetOrderPrice(ARCIMDR,PIADMRowId,"",ItemFeeType)
    .q:+PIOIFee=0
    .Set PIOIEntFeeSum=PIOIFee+PIOIEntFeeSum
    .Set PIOICount=PIOICount+1
    
    Set OrdEntAAmount=$p($g(^DHCPEPreIADM(PIADMRowId,"ORDENT",PIOESub)),"^",7)
    Set OrdEntFAmount=0
    Set PIOEFSub=0
    For  Set PIOEFSub=$o(^DHCPEPreIADM(PIADMRowId,"ORDENT",PIOESub,"FEE",PIOEFSub)) Quit:(PIOEFSub="")  Do
    .Set PARowId=$p($g(^DHCPEPreIADM(PIADMRowId,"ORDENT",PIOESub,"FEE",PIOEFSub)),"^",5)
    .q:PARowId=""
    .Set IsAbort="N"
    .Set PAPBRowId=0
    .For  Set PAPBRowId=$o(^DHCPEPAPBR(0,"PADR",PARowId,PAPBRowId)) Quit:(PAPBRowId="")  Do
    ..Set PBType=$p($g(^DHCPEPAPBR(PAPBRowId)),"^",3)
    ..If PBType="A" Set IsAbort=PBType
    .If IsAbort="N" Set OrdEntFAmount=OrdEntFAmount+$p($g(^DHCPEPreIADM(PIADMRowId,"ORDENT",PIOESub,"FEE",PIOEFSub)),"^",2)
    
    If ((OrdEntAAmount'=0)&(OrdEntAAmount'="")) Do
    .Set OrdEntFeeRebate=OrdEntFAmount/OrdEntAAmount
    
    If PIOIEntFeeSum'=OrdEntAAmount Set OrdEntFeeRebate=""
    //Set i=0,SplitedFee=0
     Set i=1,SplitedFee=0
    Set PIOIRowId=0
    For  Set PIOIRowId=$o(^DHCPEDataEx("DHC_PE_PreIOrdItemFee","PIOEFEE",PIOIOrdEntDR,PIOIRowId)) Quit:(PIOIRowId="")  Do
    .Set PIOISub=$p(PIOIRowId,"||",2)
    .Quit:$g(PIOISub)=""
    .Set OrdItemFactFEE=0,OrdItemAAmount=0
    .Set OrdItemAAmount=$p($g(^DHCPEPreIADM(PIADMRowId,"ORDITEM",PIOISub)),"^",14)
    .;w !,PIADMRowId
    .
    .If $g(OrdItemAAmount)="" Do  // mlh20080317
    ..Set ARCIMDR=$p($g(^DHCPEPreIADM(PIADMRowId,"ORDITEM",PIOISub)),"^",1)
    ..Quit:$g(ARCIMDR)=""
    ..s ItemFeeType=$G(^DHCPEDataEx("DHCPEPreIADM","ADMFeeType","Item",PIADMRowId_"||"_PIOISub))  //根据项目取对应的体检费别 for 协和
    ..Set OrdItemAAmount=+##class(web.DHCPE.PreItemList).GetOrderPrice(ARCIMDR,PIADMRowId,"",ItemFeeType)
    .q:OrdItemAAmount=0
    .If i<(PIOICount) Do
    ..If ($g(OrdEntFeeRebate)="") Do 
    ...Set OrdItemFactFEE=OrdItemAAmount*(OrdEntAAmount/PIOIEntFeeSum)   ;OrdEntFAmount/PIOICount
    ...;w !,OrdItemAAmount
    ..Else  Do
    ...;w !,OrdItemAAmount_"A"
    ...Set OrdItemFactFEE=OrdItemAAmount*OrdEntFeeRebate
    .Else  Do
    ..Set OrdItemFactFEE=OrdEntFAmount-SplitedFee
    .Set OrdItemFactFEE=$fn(OrdItemFactFEE,"",2)
    .;w !,"OrdItemFactFEE"_OrdItemAAmount_"^"_OrdItemFactFEE
    .Set ^DHCPEDataEx("DHC_PE_PreIOrdItemFee","PIOEFEE",PIOIOrdEntDR,PIOIRowId)=OrdItemFactFEE
    .s arcimdesc=$p(^ARCIM(+ARCIMDR,"1",1),"^",2)
    .Set SplitedFee=SplitedFee+OrdItemFactFEE
    .Set i=i+1
    Quit 0
}

/*
ClassMethod SplitOrdSetPrice(PIOIOrdEntDR)
{
	
	Quit:$g(PIOIOrdEntDR)=""
	Set PIADMRowId=$p(PIOIOrdEntDR,"||",1)
	Quit:$g(PIADMRowId)=""
	Set PIOESub=$p(PIOIOrdEntDR,"||",2)
	Quit:$g(PIOESub)=""
	
	Kill ^DHCPEDataEx("DHC_PE_PreIOrdItemFee","PIOEFEE",PIOIOrdEntDR)

	Set PIOISub=0,PIOICount=0,PIOIEntFeeSum=0
	For  Set PIOISub=$o(^DHCPEPreIADM(0,"OrdEnt",PIOIOrdEntDR,PIADMRowId,PIOISub)) Quit:(PIOISub="")  Do
	.Set PIOIRowId=PIADMRowId_"||"_PIOISub
	.Set PIOIItemStat=$p($g(^DHCPEPreIADM(PIADMRowId,"ORDITEM",PIOISub)),"^",16)
	.Quit:(PIOIItemStat="4")
	.Set ^DHCPEDataEx("DHC_PE_PreIOrdItemFee","PIOEFEE",PIOIOrdEntDR,PIOIRowId)=""
	.Set PIOICount=PIOICount+1
	.//Set PIOIFee=$p($g(^DHCPEPreIADM(PIADMRowId,"ORDITEM",PIOISub)),"^",14)
	.Set ARCIMDR=$p($g(^DHCPEPreIADM(PIADMRowId,"ORDITEM",PIOISub)),"^",1)
	.Quit:$g(ARCIMDR)=""
	.s ItemFeeType=$G(^DHCPEDataEx("DHCPEPreIADM","ADMFeeType","Item",PIADMRowId_"||"_PIOISub))  //根据项目取对应的体检费别 for 协和
	.Set PIOIFee=##class(web.DHCPE.PreItemList).GetOrderPrice(ARCIMDR,PIADMRowId,"",ItemFeeType)
	.Set PIOIEntFeeSum=PIOIFee+PIOIEntFeeSum
    //q 9
	Set OrdEntAAmount=$p($g(^DHCPEPreIADM(PIADMRowId,"ORDENT",PIOESub)),"^",7)
	Set OrdEntFAmount=0
	Set PIOEFSub=0
	For  Set PIOEFSub=$o(^DHCPEPreIADM(PIADMRowId,"ORDENT",PIOESub,"FEE",PIOEFSub)) Quit:(PIOEFSub="")  Do
	.Set PARowId=$p($g(^DHCPEPreIADM(PIADMRowId,"ORDENT",PIOESub,"FEE",PIOEFSub)),"^",5)
	.q:PARowId=""
	.Set IsAbort="N"
	.Set PAPBRowId=0
	.For  Set PAPBRowId=$o(^DHCPEPAPBR(0,"PADR",PARowId,PAPBRowId)) Quit:(PAPBRowId="")  Do
	..Set PBType=$p($g(^DHCPEPAPBR(PAPBRowId)),"^",3)
	..If PBType="A" Set IsAbort=PBType
	.If IsAbort="N" Set OrdEntFAmount=OrdEntFAmount+$p($g(^DHCPEPreIADM(PIADMRowId,"ORDENT",PIOESub,"FEE",PIOEFSub)),"^",2)
	
	If ((OrdEntAAmount'=0)&(OrdEntAAmount'="")) Do
	.Set OrdEntFeeRebate=OrdEntFAmount/OrdEntAAmount
	
	If PIOIEntFeeSum'=OrdEntAAmount Set OrdEntFeeRebate=""
	Set i=0,SplitedFee=0
	Set PIOIRowId=0
	For  Set PIOIRowId=$o(^DHCPEDataEx("DHC_PE_PreIOrdItemFee","PIOEFEE",PIOIOrdEntDR,PIOIRowId)) Quit:(PIOIRowId="")  Do
	.Set PIOISub=$p(PIOIRowId,"||",2)
	.Quit:$g(PIOISub)=""
	.Set OrdItemFactFEE=0,OrdItemAAmount=0
	.Set OrdItemAAmount=$p($g(^DHCPEPreIADM(PIADMRowId,"ORDITEM",PIOISub)),"^",14)
	.If $g(OrdItemAAmount)="" Do  // mlh20080317
	..Set ARCIMDR=$p($g(^DHCPEPreIADM(PIADMRowId,"ORDITEM",PIOISub)),"^",1)
	..Quit:$g(ARCIMDR)=""
	..s ItemFeeType=$G(^DHCPEDataEx("DHCPEPreIADM","ADMFeeType","Item",PIADMRowId_"||"_PIOISub))  //根据项目取对应的体检费别 for 协和
	..Set OrdItemAAmount=##class(web.DHCPE.PreItemList).GetOrderPrice(ARCIMDR,PIADMRowId,"",ItemFeeType)
	.If i<(PIOICount-1) Do
	..If ($g(OrdEntFeeRebate)="") Do 
	...Set OrdItemFactFEE=OrdEntFAmount/PIOICount
	..Else  Do
	...Set OrdItemFactFEE=OrdItemAAmount*OrdEntFeeRebate
	.Else  Do
	..Set OrdItemFactFEE=OrdEntFAmount-SplitedFee
	.Set OrdItemFactFEE=$fn(OrdItemFactFEE,"",2)
	.Set ^DHCPEDataEx("DHC_PE_PreIOrdItemFee","PIOEFEE",PIOIOrdEntDR,PIOIRowId)=OrdItemFactFEE
	.s arcimdesc=$p(^ARCIM(+ARCIMDR,"1",1),"^",2)
	.Set SplitedFee=SplitedFee+OrdItemFactFEE
	.Set i=i+1
    Quit 0
}
*/
/// 取单个项目实际价钱 //胡华明要的
/// w ##class(web.DHCPE.OrdSetsPrice).PEOrdPrice("","23502||1")
ClassMethod PEOrdPrice(OEORIRowId As %String, PIOIRowId As %String = "") As %String
{
	Quit:($g(OEORIRowId)="")&&($g(PIOIRowId)="") ""
	If PIOIRowId="" Do
	.Set CRMORowId=$o(^DHCPECRMO(0,"OEORI",OEORIRowId,0))
	.Quit:$g(CRMORowId)="" 
	.Set PIOIRowId=$p(^DHCPECRMO(CRMORowId),"^",2)
	Quit:$g(PIOIRowId)="" ""
	Set PIADM=$p(PIOIRowId,"||",1)
	Quit:$g(PIADM)="" ""
	Set PIOIChd=$p(PIOIRowId,"||",2)
	Quit:$g(PIOIChd)="" ""
	Set OEORIPrice=""
	Set PIOIOrdEntDR=$p(^DHCPEPreIADM(PIADM,"ORDITEM",PIOIChd),"^",2)
	If PIOIOrdEntDR="" Do
	.Set PIOIFRowId=0
	.For  Set PIOIFRowId=$o(^DHCPEPreIADM(PIADM,"ORDITEM",PIOIChd,"FEE",PIOIFRowId))  Quit:PIOIFRowId=""  Do
	..Set PAudit=$p(^DHCPEPreIADM(PIADM,"ORDITEM",PIOIChd,"FEE",PIOIFRowId),"^",5)
	..q:PAudit=""
	..Set PAStatus=$p(^DHCPEPreA(PAudit),"^",21)
	..Quit:$g(PAStatus)="NU"
	..Set FactAmount=$p(^DHCPEPreIADM(PIADM,"ORDITEM",PIOIChd,"FEE",PIOIFRowId),"^",2)
	..Set OEORIPrice=OEORIPrice+FactAmount
	Else  Do
	.;b ///aa
	.Do ..SplitOrdSetPrice(PIOIOrdEntDR)
	.Set OEORIPrice=$g(^DHCPEDataEx("DHC_PE_PreIOrdItemFee","PIOEFEE",PIOIOrdEntDR,PIOIRowId))
	//w !,OEORIPrice
	Quit OEORIPrice
}

}
