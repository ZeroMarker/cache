Class web.DHCOUTPHA.Pricing.Query Extends %Persistent
{

ClassMethod GetDrugInfo(Inci, LocId = "")
{
	q:Inci="" ""
	s HospId=""
	i LocId'="" s HospId=$p(^CTLOC(LocId),"^",22)
	S InciDr=Inci
	s InciCode=$P(^INCI(InciDr,1),"^",1)      
	s InciDesc=$P(^INCI(InciDr,1),"^",2)   
	S PuomDr=$P(^INCI(InciDr,3),"^",6)                                  //入库单位ID
	s PuomDesc=""
    q:'$d(^CT("UOM",PuomDr)) ""
    S:PuomDr'="" PuomDesc=$P(^CT("UOM",PuomDr),"^",2)                                   //入库单位描述
    S pRp=##Class(web.DHCST.Common.PriceCommon).GetInciBasicRp(InciDr,+$H,PuomDr,HospId,"","") //入库单位进价
    S pSp=##Class(web.DHCST.Common.PriceCommon).GetPriceElse(InciDr,+$H,PuomDr,HospId,"","")  //入库单位售价
    s Spec=##class(web.DHCSTKUTIL).GetSpec(InciDr)
    s manf=##class(web.DHCST.Common.DrugStkCommon).GetLastManf(InciDr)
    s manf=$p(manf,"^",2)
    S ArcimDr=$P(^INCI(InciDr,1),"^",3)
    s OfficalCode=##class(web.DHCSTInterfaceFromElse).ArcimLinkInsu(ArcimDr,"","") //医保类别
    s colData=InciCode_"^"_InciDesc_"^"_ pRp_"^"_pSp_"^"_PuomDesc_"^"_Inci_"^"_Spec_"^"_manf_"^"_OfficalCode
	q colData
}

Storage Default
{
<Data name="QueryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCOUTPHA.Pricing.QueryD</DataLocation>
<DefaultData>QueryDefaultData</DefaultData>
<IdLocation>^web.DHCOUTPHA.Pricing.QueryD</IdLocation>
<IndexLocation>^web.DHCOUTPHA.Pricing.QueryI</IndexLocation>
<StreamLocation>^web.DHCOUTPHA.Pricing.QueryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
