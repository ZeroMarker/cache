Class web.DHCPE.Industry Extends %Persistent
{

ClassMethod UpdateIndustry(ID, InfoStr)
{
	;w ##class(web.DHCPE.Industry).UpdateIndustry("","")
	S Code=$P(InfoStr,"^",1)
	S Desc=$P(InfoStr,"^",2)
	s IndCode="",IndDesc=""

	if ID="" d
	.s obj=##class(User.DHCPEIndustry).%New()
	e  d
	.s obj=##class(User.DHCPEIndustry).%OpenId(ID)
	.s IndCode=$LG(^User.DHCPEIndustryD(ID),2)
	.S IndDesc=$LG(^User.DHCPEIndustryD(ID),3)
	q:(IndCode'=Code)&&($d(^User.DHCPEIndustryI("ICodeIndex"," "_Code))) "0^代码重复!"
	q:(IndDesc'=Desc)&&($d(^User.DHCPEIndustryI("IDescIndex"," "_Desc))) "0^描述重复!"

	s obj.ICode=$P(InfoStr,"^",1)
	s obj.IDesc=$P(InfoStr,"^",2)
	s obj.IActive=$P(InfoStr,"^",3)
	s obj.IExpInfo=$P(InfoStr,"^",4)
	s obj.IRemark=$P(InfoStr,"^",5)
	s sc=obj.%Save()
	d obj.%Close()
	If ($System.Status.IsError(sc))	
	{
		q "-1^"_$System.Status.GetErrorText(sc)
	}else{
		q obj.%Id()
	}
}

ClassMethod GetOneIndustryInfo(ID)
{
	q:ID="" "^^^^^^^^^^^"
	s ID=$P(ID,"$",1)
	s obj=##class(User.DHCPEIndustry).%OpenId(ID)
	s Code=obj.ICode
	s Desc=obj.IDesc
	s Active=obj.IActive
	s ExpInfo=obj.IExpInfo
	s Remark=obj.IRemark
	q Code_"^"_Desc_"^"_Active_"^"_ExpInfo_"^"_Remark
}

/// 职业健康检查种类
Query SearchIndustry(Desc = "", Active = "") As %Query(ROWSPEC = "TID:%String,TCode:%String,TDesc:%String,TActive:%String,TExpInfo:%String,TRemark:%String")
{
}

ClassMethod SearchIndustryExecute(ByRef qHandle As %Binary, Desc = "", Active = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCPE.Industry", "SearchIndustry")
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s ID=""
 	f  s ID=$O(^User.DHCPEIndustryD(ID)) q:ID=""  d
 	.s TCode=$LG(^User.DHCPEIndustryD(ID),2)
	.s TDesc=$LG(^User.DHCPEIndustryD(ID),3)
	.q:((Desc'="")&&(TDesc[Desc))
	.s TActive=$LG(^User.DHCPEIndustryD(ID),4)
	.q:((Active'="")&&(TActive'=Active))
	.i TActive="Y" S TActive="是"
	.e  S TActive="否"
	.s TExpInfo=$LG(^User.DHCPEIndustryD(ID),5)
	.s TRemark=$LG(^User.DHCPEIndustryD(ID),6)
	.d FindBuild
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
FindBuild    
	s TActive=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpe.occu.gbaseinfo.csp",TActive)  
	s TDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEIndustry",TDesc,"IDesc","cls")

	set Data=$lb(ID,TCode,TDesc,TActive,TExpInfo,TRemark)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SearchIndustryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchIndustryExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {		
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SearchIndustryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchIndustryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod DeleteIndustry(ID)
{
	;w ##class(web.DHCPE.Industry).DeleteIndustry("","")
	s obj=##class(User.DHCPEIndustry).%New()
	s sc=obj.%DeleteId(ID)
	d obj.%Close()
	If ($System.Status.IsError(sc))	
	{
		q "-1^"_$System.Status.GetErrorText(sc)
	}else{
		q obj.%Id()
	}
}

Storage Default
{
<Data name="IndustryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCPE.IndustryD</DataLocation>
<DefaultData>IndustryDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCPE.IndustryD</IdLocation>
<IndexLocation>^web.DHCPE.IndustryI</IndexLocation>
<StreamLocation>^web.DHCPE.IndustryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
