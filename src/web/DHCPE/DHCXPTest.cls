Class web.DHCPE.DHCXPTest Extends %Persistent
{

/// w ##class(web.DHCPE.DHCXPTest).CheckInvInfo(27602)
ClassMethod CheckInvInfo(Inv)
{
	Set InvAmt=$P(^DHCPEINVPRT(Inv),"^",7)
	Set CatAmt=0
	s PreItemID=""
  	f  s PreItemID=$O(^DHCPEOEITEM(Inv,"OEITEM",PreItemID)) q:PreItemID=""  d //,"TARITEM",itmsub)
	.s TARITEMSub=""
	.f  s TARITEMSub=$O(^DHCPEOEITEM(Inv,"OEITEM",PreItemID,"TARITEM",TARITEMSub)) q:TARITEMSub=""  d
	..;TarItem_"^"_$j((CurCatFee/(qty*orderQty)),3,2)_"^"_(qty*orderQty)_"^"_$j(CurCatFee,3,2)
	..s Info=$G(^DHCPEOEITEM(Inv,"OEITEM",PreItemID,"TARITEM",TARITEMSub))
	..s TARITEMID=$P(Info,"^",1)
	..s Amount=$P(Info,"^",4)
	..s CatAmt=CatAmt+Amount
	i InvAmt'=CatAmt q "金额不符："_(InvAmt-CatAmt)
	q "金额一致"
}

/// w ##class(web.DHCPE.DHCXPTest).GetIfHadLCT("4042926")
ClassMethod GetIfHadLCT(PAADM)
{
	s ^sxt("adad")=PAADM
	s IADM=$O(^DHCPEIADM(0,"PAADM",PAADM,0))
    q:IADM="" ""
    b ;1
    s PIADM=$p(^DHCPEIADM(IADM),"^",4)
    b ;2331
    q:('$d(^DHCPEPreIADM(0,"ItmMast","33046||1",PIADM))) ""
    b ;11111
    s PreordSub=0
    s OEORIDR=""
    f  s PreordSub=$o(^DHCPEPreIADM(0,"ItmMast","33046||1",PIADM,PreordSub)) q:(PreordSub="")  d
	.s CRMOCRMORI=PIADM_"||"_PreordSub
	.b ;2
	.s CRMORowId=$o(^DHCPECRMO(0,"CRMORI",CRMOCRMORI,0))
	.s BillStatus=$p(^DHCPECRMO(CRMORowId),"^",4)
	.;b ;3
	.s OEORIDR=$p(^DHCPECRMO(CRMORowId),"^",1)
	.;b ;13
	.q:((BillStatus="NP")||(BillStatus="PP"))
	.s ^sxt("ff")=1
	.b ;4
	b ;005
	q OEORIDR
}

Storage Default
{
<Data name="DHCXPTestDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCPE.DHCXPTestD</DataLocation>
<DefaultData>DHCXPTestDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCPE.DHCXPTestD</IdLocation>
<IndexLocation>^web.DHCPE.DHCXPTestI</IndexLocation>
<StreamLocation>^web.DHCPE.DHCXPTestS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
