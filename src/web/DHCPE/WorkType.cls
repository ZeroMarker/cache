Class web.DHCPE.WorkType Extends %Persistent
{

ClassMethod UpdateWorkType(ID, InfoStr)
{
	;w ##class(web.DHCPE.WorkType).UpdateWorkType("","")
	S Code=$P(InfoStr,"^",1)
	S Desc=$P(InfoStr,"^",2)
	s WorkTCode="",WorkTDesc=""

	if ID="" d
	.s obj=##class(User.DHCPEWorkType).%New()
	e  d
	.s obj=##class(User.DHCPEWorkType).%OpenId(ID)
	.s WorkTCode=$LG(^User.DHCPEWorkTypeD(ID),2)
	.S WorkTDesc=$LG(^User.DHCPEWorkTypeD(ID),3)
	q:(WorkTCode'=Code)&&($d(^User.DHCPEWorkTypeI("WTCodeIndex"," "_Code))) "0^代码重复!"
	q:(WorkTDesc'=Desc)&&($d(^User.DHCPEWorkTypeI("WTDescIndex"," "_Desc))) "0^描述重复!"

	s obj.WTCode=$P(InfoStr,"^",1)
	s obj.WTDesc=$P(InfoStr,"^",2)
	s obj.WTActive=$P(InfoStr,"^",3)
	s obj.WTExpInfo=$P(InfoStr,"^",4)
	s obj.WTRemark=$P(InfoStr,"^",5)
	s sc=obj.%Save()
	d obj.%Close()
	If ($System.Status.IsError(sc))	
	{
		q "-1^"_$System.Status.GetErrorText(sc)
	}else{
		q obj.%Id()
	}
}

ClassMethod GetOneWorkTypeInfo(ID)
{
	q:ID="" "^^^^^^^^^^^"
	s ID=$P(ID,"$",1)
	s obj=##class(User.DHCPEWorkType).%OpenId(ID)
	s Code=obj.WTCode
	s Desc=obj.WTDesc
	s Active=obj.WTActive
	s ExpInfo=obj.WTExpInfo
	s Remark=obj.WTRemark
	q Code_"^"_Desc_"^"_Active_"^"_ExpInfo_"^"_Remark
}

/// 职业健康工种
Query SearchWorkType(Code As %String = "", Desc As %String = "", Active As %String = "") As %Query(ROWSPEC = "TID:%String,TCode:%String,TDesc:%String,TActive:%String,TExpInfo:%String,TRemark:%String")
{
}

ClassMethod SearchWorkTypeExecute(ByRef qHandle As %Binary, Code As %String = "", Desc As %String = "", Active As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCPE.WorkType", "SearchWorkType")
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	
 	s ID=""
 	f  s ID=$O(^User.DHCPEWorkTypeD(ID)) q:ID=""  d
 	.s TCode=$LG(^User.DHCPEWorkTypeD(ID),2)
 	.q:((Code'="")&&(TCode'[Code))
	.s TDesc=$LG(^User.DHCPEWorkTypeD(ID),3)
 	.q:((Desc'="")&&(TDesc'[Desc))
	.s TActive=$LG(^User.DHCPEWorkTypeD(ID),4)
	.q:((Active'="")&&(Active'=TActive))
	.i TActive="Y" S TActive="是"
	.e  s TActive="否"
	.s TExpInfo=$LG(^User.DHCPEWorkTypeD(ID),5)
	.s TRemark=$LG(^User.DHCPEWorkTypeD(ID),6)
	.d FindBuild
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
FindBuild      
	Set Data=$lb(ID,TCode,TDesc,TActive,TExpInfo,TRemark)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SearchWorkTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchWorkTypeExecute ]
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

ClassMethod SearchWorkTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchWorkTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod DeleteWorkType(ID)
{
	;w ##class(web.DHCPE.WorkType).DeleteWorkType("","")
	s obj=##class(User.DHCPEWorkType).%New()
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
<Data name="WorkTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCPE.WorkTypeD</DataLocation>
<DefaultData>WorkTypeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCPE.WorkTypeD</IdLocation>
<IndexLocation>^web.DHCPE.WorkTypeI</IndexLocation>
<StreamLocation>^web.DHCPE.WorkTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
