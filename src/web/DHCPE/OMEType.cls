Class web.DHCPE.OMEType Extends %Persistent
{

ClassMethod UpdateOMEType(ID, InfoStr)
{
	;w ##class(web.DHCPE.OMEType).UpdateOMEType("","")
	S Code=$P(InfoStr,"^",1)
	S Desc=$P(InfoStr,"^",2)
	s OMECode="",OMEDesc=""

	if ID="" d
	.s obj=##class(User.DHCPEOMEType).%New()
	e  d
	.s obj=##class(User.DHCPEOMEType).%OpenId(ID)
	.s OMECode=$LG(^User.DHCPEOMETypeD(ID),2)
	.S OMEDesc=$LG(^User.DHCPEOMETypeD(ID),3)
	q:(OMECode'=Code)&&($d(^User.DHCPEOMETypeI("OMETCodeIndex"," "_Code))) "0^代码重复!"
	q:(OMEDesc'=Desc)&&($d(^User.DHCPEOMETypeI("OMETDescIndex"," "_Desc))) "0^描述重复!"

	s obj.OMETCode=$P(InfoStr,"^",1)
	s obj.OMETDesc=$P(InfoStr,"^",2)
	s obj.OMETActive=$P(InfoStr,"^",3)
	s obj.OMETVIPLevel=$P(InfoStr,"^",4)
	s obj.OMETExpInfo=$P(InfoStr,"^",5)
	s obj.OMETRemark=$P(InfoStr,"^",6)
	s sc=obj.%Save()
	d obj.%Close()
	If ($System.Status.IsError(sc))	
	{
		q "-1^"_$System.Status.GetErrorText(sc)
	}else{
		q obj.%Id()
	}
}

ClassMethod GetOneOMETypeInfo(ID)
{
	q:ID="" "^^^^^^^^^^^"
	s ID=$P(ID,"$",1)
	s obj=##class(User.DHCPEOMEType).%OpenId(ID)
	s Code=obj.OMETCode
	s Desc=obj.OMETDesc
	s Active=obj.OMETActive
	s PEType=obj.OMETVIPLevel
	s ExpInfo=obj.OMETExpInfo
	s Remark=obj.OMETRemark
	q Code_"^"_Desc_"^"_Active_"^"_PEType_"^"_ExpInfo_"^"_Remark
}

/// 职业健康检查种类
Query SearchOMEType() As %Query(ROWSPEC = "TID:%String,TCode:%String,TDesc:%String,TActive:%String,TVIPLevel:%String,TVIPLevelDR:%String,TExpInfo:%String,TRemark:%String")
{
}

ClassMethod SearchOMETypeExecute(ByRef qHandle As %Binary) As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCPE.OMEType", "SearchOMEType")
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s ID=""
 	f  s ID=$O(^User.DHCPEOMETypeD(ID)) q:ID=""  d
 	.s TCode=$LG(^User.DHCPEOMETypeD(ID),2)
	.s TDesc=$LG(^User.DHCPEOMETypeD(ID),3)
	.s TActive=$LG(^User.DHCPEOMETypeD(ID),4)
	.i TActive="Y" S TActive="是"
	.E  S TActive="否"
	.s TVIPLevelDR=$LG(^User.DHCPEOMETypeD(ID),5)
	.s:TVIPLevelDR'="" TVIPLevel=$P($G(^DHCPEVIPLevel("VIP",TVIPLevelDR)),"^",2)
	.s TExpInfo=$LG(^User.DHCPEOMETypeD(ID),6)
	.s TRemark=$LG(^User.DHCPEOMETypeD(ID),7)
	.d FindBuild
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
FindBuild      
	set Data=$lb(ID,TCode,TDesc,TActive,TVIPLevel,TVIPLevelDR,TExpInfo,TRemark)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SearchOMETypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchOMETypeExecute ]
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

ClassMethod SearchOMETypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchOMETypeExecute ]
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
ClassMethod OMETypeDelete(ID)
{
	;w ##class(web.DHCPE.OMEType).OMETypeDelete("","")
	s obj=##class(User.DHCPEOMEType).%New()
	s sc=obj.%DeleteId(ID)
	d obj.%Close()
	If ($System.Status.IsError(sc))	
	{
		q "-1^"_$System.Status.GetErrorText(sc)
	}else{
		q obj.%Id()
	}
}

/// 检查种类的下拉列表
ClassMethod OutOMETypeToHTML(ContrlWidth As %String = "", DefaultValue As %String = "", tabIndex As %String = 0) As %String
{
	;s ^sxt("ddd")=DefaultValue
	;d ##class(web.DHCPE.OMEType).OutOMETypeToHTML()
	s:(""=ContrlWidth) ContrlWidth="155"
	
	w "<select name='OMETypeDR' id='OMETypeDR' style='width:"_ContrlWidth_"' HEIGHT=0 tabIndex="_tabIndex_">",!
	w "<option value=''>  </option>",!
	s id=0
	f  s id=$o(^User.DHCPEOMETypeD(id)) q:id=""  d
	.s selected=""
	.s:DefaultValue=id selected="selected"
	.s use=$LG($g(^User.DHCPEOMETypeD(id)),4)
	.i use="Y" d
	..s use="可用"
	.e  d
	..s use="<color = red>禁用</color>"
	.s desc=$LG($g(^User.DHCPEOMETypeD(id)),3) ;_"   "_use
	.//i use="Y" d
	.w "<option value='"_id_"' "_selected_">"_desc_"</option>",!
	w "</select>",!
	Quit $$$OK
}

Storage Default
{
<Data name="OMETypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCPE.OMETypeD</DataLocation>
<DefaultData>OMETypeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCPE.OMETypeD</IdLocation>
<IndexLocation>^web.DHCPE.OMETypeI</IndexLocation>
<StreamLocation>^web.DHCPE.OMETypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
