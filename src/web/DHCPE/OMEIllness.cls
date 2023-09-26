Class web.DHCPE.OMEIllness Extends %Persistent
{

ClassMethod UpdateOMEIllness(ID, InfoStr)
{
	;w ##class(web.DHCPE.OMEIllness).UpdateOMEIllness("","")
	S Code=$P(InfoStr,"^",1)
	S Desc=$P(InfoStr,"^",2)
	s OMECode="",OMEDesc=""

	if ID="" d
	.s obj=##class(User.DHCPEOMEIllness).%New()
	e  d
	.s obj=##class(User.DHCPEOMEIllness).%OpenId(ID)
	.s OMECode=$LG(^User.DHCPEOMEIllnessD(ID),2)
	.S OMEDesc=$LG(^User.DHCPEOMEIllnessD(ID),3)
	S UDesc=""
	i Desc'="" S UDesc=$$ALPHAUP^SSUTIL4(Desc)
	q:(OMECode'=Code)&&($d(^User.DHCPEOMEIllnessI("ITCodeIndex"," "_Code))) "0^代码重复!"
	q:(OMEDesc'=Desc)&&($d(^User.DHCPEOMEIllnessI("ITDescIndex"," "_UDesc))) "0^目标疾病重复!"

	s obj.ITCode=$P(InfoStr,"^",1)
	s obj.ITDesc=$P(InfoStr,"^",2)
	s obj.ITActive=$P(InfoStr,"^",3)
	d obj.ITConclusionDRSetObjectId($P(InfoStr,"^",4))
	s obj.ITExpInfo=$P(InfoStr,"^",5)
	s obj.ITRemark=$P(InfoStr,"^",6)
	s sc=obj.%Save()
	d obj.%Close()
	If ($System.Status.IsError(sc))	
	{
		q "-1^"_$System.Status.GetErrorText(sc)
	}else{
		q obj.%Id()
	}
}

/// w ##class(web.DHCPE.OMEIllness).GetOneOMEIllnessInfo("1")
ClassMethod GetOneOMEIllnessInfo(ID)
{
	q:ID="" "^^^^^^^^^^^"
	s ID=$P(ID,"$",1)
	s obj=##class(User.DHCPEOMEIllness).%OpenId(ID)
	s Code=obj.ITCode
	s Desc=obj.ITDesc
	s Active=obj.ITActive
	s ConclusionDR=obj.ITConclusionDRGetObjectId()
	i ConclusionDR'="" s Conclusion=$LG($g(^User.DHCPEConclusionD(ConclusionDR)),3)
	s ExpInfo=obj.ITExpInfo
	s Remark=obj.ITRemark
	q Code_"^"_Desc_"^"_Active_"^"_Conclusion_"^"_ExpInfo_"^"_Remark_"^"_ConclusionDR
}

// 目标疾病

Query SearchOMEIllness() As %Query(ROWSPEC = "TID:%String,TCode:%String,TDesc:%String,TActive:%String,TConclusionDR:%String,TConclusion:%String,TExpInfo:%String,TRemark:%String")
{
}

ClassMethod SearchOMEIllnessExecute(ByRef qHandle As %Binary) As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCPE.OMEIllness", "SearchOMEIllness")
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s ID=""
 	f  s ID=$O(^User.DHCPEOMEIllnessD(ID)) q:ID=""  d
 	.s TCode=$LG(^User.DHCPEOMEIllnessD(ID),2)
	.s TDesc=$LG(^User.DHCPEOMEIllnessD(ID),3)
	.s TActive=$LG(^User.DHCPEOMEIllnessD(ID),4)
	.i TActive="Y" S TActive="是"
	.e  s TActive="否"
	.s ConclusionDR=$LG(^User.DHCPEOMEIllnessD(ID),5)
	.s Conclusion=""
	.s:ConclusionDR'="" Conclusion=$LG($g(^User.DHCPEConclusionD(ConclusionDR)),3)
	.s TExpInfo=$LG(^User.DHCPEOMEIllnessD(ID),6)
	.s TRemark=$LG(^User.DHCPEOMEIllnessD(ID),7)
	.d FindBuild
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
FindBuild      
	set Data=$lb(ID,TCode,TDesc,TActive,ConclusionDR,Conclusion,TExpInfo,TRemark)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SearchOMEIllnessFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchOMEIllnessExecute ]
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

ClassMethod SearchOMEIllnessClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchOMEIllnessExecute ]
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
ClassMethod OMEIllnessDelete(ID)
{
	;w ##class(web.DHCPE.OMEIllness).OMEIllnessDelete("","")
	s obj=##class(User.DHCPEOMEIllness).%New()
	s sc=obj.%DeleteId(ID)
	d obj.%Close()
	If ($System.Status.IsError(sc))	
	{
		q "-1^"_$System.Status.GetErrorText(sc)
	}else{
		q obj.%Id()
	}
}

/// 结论分类
Query ConclusionList(Desc As %Library.String = "") As %Query(ROWSPEC = "ID:%String,C_Code:%String:编码,C_Desc:%String:描述,C_VIPLevel:%String:VIP等级,C_ExpInfo:%String:扩展信息,C_Severity:%String:严重程度,C_Remark:%String:备注")
{
}

ClassMethod ConclusionListExecute(ByRef qHandle As %Binary, Desc As %Library.String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCPE.OMEIllness","ConclusionList")
	Set repid=$I(^CacheTemp)
 	s ind=1
 	i Desc'="" d
 	.s ID=0
 	.s ID=$O(^User.DHCPEConclusionI("CDescIndex"," "_Desc,ID))
 	.q:ID=""
 	.s Code=$LG(^User.DHCPEConclusionD(ID),2)
	.s Active=$LG(^User.DHCPEConclusionD(ID),4)
	.q:Active="N"
	.s VIPLevel=$LG(^User.DHCPEConclusionD(ID),5)
	.s:VIPLevel'="" VIPLevel=$P($G(^DHCPEVIPLevel("VIP",VIPLevel)),"^",2)
	.s ExpInfo=$LG(^User.DHCPEConclusionD(ID),6)
	.s Severity=$LG(^User.DHCPEConclusionD(ID),7)
	.s Remark=$LG(^User.DHCPEConclusionD(ID),8)
	.d FindBuild
	e  d
	.s ID=0
	.f  s ID=$O(^User.DHCPEConclusionD(ID)) q:ID=""  d
	..s Code=$LG(^User.DHCPEConclusionD(ID),2)
	..s Desc=$LG(^User.DHCPEConclusionD(ID),3)
	..s Active=$LG(^User.DHCPEConclusionD(ID),4)
	..q:Active="N"
	..s VIPLevel=$LG(^User.DHCPEConclusionD(ID),5)
	..s:VIPLevel'="" VIPLevel=$P($G(^DHCPEVIPLevel("VIP",VIPLevel)),"^",2)
	..s ExpInfo=$LG(^User.DHCPEConclusionD(ID),6)
	..s Severity=$LG(^User.DHCPEConclusionD(ID),7)
	..s Remark=$LG(^User.DHCPEConclusionD(ID),8)
	..d FindBuild
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
FindBuild      
	set Data=$lb(ID,Code,Desc,VIPLevel,ExpInfo,Severity,Remark)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod ConclusionListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ConclusionListExecute ]
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

ClassMethod ConclusionListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ConclusionListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Storage Default
{
<Data name="OMEIllnessDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCPE.OMEIllnessD</DataLocation>
<DefaultData>OMEIllnessDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCPE.OMEIllnessD</IdLocation>
<IndexLocation>^web.DHCPE.OMEIllnessI</IndexLocation>
<StreamLocation>^web.DHCPE.OMEIllnessS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
