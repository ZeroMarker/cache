Class web.DHCPE.ProtectiveMeasures Extends %Persistent
{

ClassMethod UpdateProtectiveMeasures(ID, InfoStr)
{
	;w ##class(web.DHCPE.ProtectiveMeasures).UpdateProtectiveMeasures("","")
	S Code=$P(InfoStr,"^",1)
	S Desc=$P(InfoStr,"^",2)
	s ProMCode="",ProMDesc=""

	if ID="" d
	.s obj=##class(User.DHCPEProtectiveMeasures).%New()
	e  d
	.s obj=##class(User.DHCPEProtectiveMeasures).%OpenId(ID)
	.s ProMCode=$LG(^User.DHCPEProtectiveMeasuresD(ID),2)
	.S ProMDesc=$LG(^User.DHCPEProtectiveMeasuresD(ID),3)
	q:(ProMCode'=Code)&&($d(^User.DHCPEProtectiveMeasuresI("PMCodeIndex"," "_Code))) "0^代码重复!"
	q:(ProMDesc'=Desc)&&($d(^User.DHCPEProtectiveMeasuresI("PMDescIndex"," "_Desc))) "0^描述重复!"

	s obj.PMCode=$P(InfoStr,"^",1)
	s obj.PMDesc=$P(InfoStr,"^",2)
	s obj.PMActive=$P(InfoStr,"^",3)
	s obj.PMExpInfo=$P(InfoStr,"^",4)
	s obj.PMRemark=$P(InfoStr,"^",5)
	s sc=obj.%Save()
	d obj.%Close()
	If ($System.Status.IsError(sc))	
	{
		q "-1^"_$System.Status.GetErrorText(sc)
	}else{
		q obj.%Id()
	}
}

ClassMethod GetOneProtectiveMeasuresInfo(ID)
{
	q:ID="" "^^^^^^^^^^^"
	s ID=$P(ID,"$",1)
	s obj=##class(User.DHCPEProtectiveMeasures).%OpenId(ID)
	s Code=obj.PMCode
	s Desc=obj.PMDesc
	s Active=obj.PMActive
	s ExpInfo=obj.PMExpInfo
	s Remark=obj.PMRemark
	q Code_"^"_Desc_"^"_Active_"^"_ExpInfo_"^"_Remark
}

/// 防护措施维护
Query SearchProtectiveMeasures() As %Query(ROWSPEC = "TID:%String,TCode:%String,TDesc:%String,TActive:%String,TExpInfo:%String,TRemark:%String")
{
}

ClassMethod SearchProtectiveMeasuresExecute(ByRef qHandle As %Binary) As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCPE.ProtectiveMeasures", "SearchProtectiveMeasures")
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s ID=""
 	f  s ID=$O(^User.DHCPEProtectiveMeasuresD(ID)) q:ID=""  d
 	.s TCode=$LG(^User.DHCPEProtectiveMeasuresD(ID),2)
	.s TDesc=$LG(^User.DHCPEProtectiveMeasuresD(ID),3)
	.s TActive=$LG(^User.DHCPEProtectiveMeasuresD(ID),4)
	.i TActive="Y" S TActive="是"
	.e  S TActive="否"
	.s TExpInfo=$LG(^User.DHCPEProtectiveMeasuresD(ID),5)
	.s TRemark=$LG(^User.DHCPEProtectiveMeasuresD(ID),6)
	.d FindBuild
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
FindBuild      
	set Data=$lb(ID,TCode,TDesc,TActive,TExpInfo,TRemark)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SearchProtectiveMeasuresFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchProtectiveMeasuresExecute ]
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

ClassMethod SearchProtectiveMeasuresClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchProtectiveMeasuresExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/*ClassMethod GetOneOMETypeInfo(ID)
{
	q:ID="" "^^^^^^^^^^^"
	s ID=$P(ID,"$",1)
	s obj=##class(User.DHCPEOMEType).%OpenId(ID)
	s TCode=obj.OMETCode
	s TDesc=obj.OMETDesc
	s TActive=obj.OMETActive
	s TVIPLevel=obj.OMETVIPLevel
	s TExpInfo=obj.OMETExpInfo
	s TRemark=obj.OMETRemark
	q TCode_"^"_TDesc_"^"_TActive_"^"_TVIPLevel_"^"_TExpInfo_"^"_TRemark
}*/
ClassMethod DeleteProtectiveMeasures(ID)
{
	;w ##class(web.DHCPE.ProtectiveMeasures).DeleteProtectiveMeasures("","")
	s obj=##class(User.DHCPEProtectiveMeasures).%New()
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
<Data name="ProtectiveMeasuresDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCPE.ProtectiveMeasuresD</DataLocation>
<DefaultData>ProtectiveMeasuresDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCPE.ProtectiveMeasuresD</IdLocation>
<IndexLocation>^web.DHCPE.ProtectiveMeasuresI</IndexLocation>
<StreamLocation>^web.DHCPE.ProtectiveMeasuresS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
