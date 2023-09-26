Class DHCWL.CodeCfgData.GetSubGrpList Extends %RegisteredObject
{

/// Creator：      yuanxu
/// CreatDate：    2014-06-05
/// Description:： 通过分组大类ID按顺序得到组下面的明细条目
/// Table：       DHCWL_CodeCfg.DHCWLCodeCfgSubGroup
/// Input：       
/// Output：      
/// Return：
/// Others：d ##class(%ResultSet).RunQuery("DHCWL.CodeCfgData.GetSubGrpList","GetSubListByGrpIdQuery","1")
Query GetSubListByGrpIdQuery(grpId As %Text) As %Query(ROWSPEC = "subDesc:%String,subCode:%String,subSort:%String,subLevel:%String") [ SqlProc ]
{
}

ClassMethod GetSubListByGrpIdQueryExecute(ByRef qHandle As %Binary, grpId As %Text) As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	k ^TEMPDHCWLCode("S",$j)
	s qHandle=$lb(0,repid,0)
 	s ind=1
	q:grpId="" 0
	/*s count=0
	s subGrpList=""
	s subgrpId=0 f  s subgrpId=$o(^DHCWL.CodeCfg.SubGroupI("GrpDr",grpId,subgrpId)) q:subgrpId=""  d
	.s value=##class(DHCWL.CodeCfg.SubGroup).%OpenId(subgrpId)
	.s subgrpDesc=value.SGrpDesc
	.s subgrpCode=value.SGrpCode
	.s subgrpSort=value.SGrpSort
	.s ^TEMPDHCWLCode($j,subgrpSort)=subgrpDesc_"^"_subgrpCode
	s sort=0 f  s sort=$o(^TEMPDHCWLCode($j,sort)) q:sort=""  d
	.s subDesc=$p($g(^TEMPDHCWLCode($j,sort)),"^",1)
	.s subCode=$p($g(^TEMPDHCWLCode($j,sort)),"^",2)
	.s ^CacheTemp(repid,ind)=$lb(subDesc,subCode)
	.s ind=ind+1*/
	d ##class(DHCWL.CodeCfgData.FunctionModule).GetSubGrpList(grpId)
	s subgrpSort=""
	for{
		s subgrpSort=$o(^||TEMPDHCWLCode("S",$j,subgrpSort))
		q:subgrpSort=""
		s mgrpDescS=$p($g(^||TEMPDHCWLCode("S",$j,subgrpSort)),"^",1)
		s subgrpTreeCode=$p($g(^||TEMPDHCWLCode("S",$j,subgrpSort)),"^",2)
		s subgrpLevel=$p($g(^||TEMPDHCWLCode("S",$j,subgrpSort)),"^",3)
		s ^CacheTemp(repid,ind)=$lb(mgrpDescS,subgrpTreeCode,subgrpSort,subgrpLevel)
	    s ind=ind+1
	}	
	
	k ^||TEMPDHCWLCode("S",$j)
	Quit $$$OK
}

ClassMethod GetSubListByGrpIdQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSubListByGrpIdQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	k ^TEMPDHCWLCode($j)
	Quit $$$OK
}

ClassMethod GetSubListByGrpIdQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSubListByGrpIdQueryExecute ]
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

/// Creator：      yuanxu
/// CreatDate：    2014-06-05
/// Description:： 通过分组大类CODE按顺序得到组下面的明细条目
/// Table：       DHCWL_CodeCfg.DHCWLCodeCfgSubGroup
/// Input：       
/// Output：      
/// Return：
/// Others：d ##class(%ResultSet).RunQuery("DHCWL.CodeCfgData.GetSubGrpList","GetSubListByGrpCodeQuery","IPLocGrp")
Query GetSubListByGrpCodeQuery(grpCode As %Text) As %Query(ROWSPEC = "subDesc:%String,subCode:%String,subSort:%String,subLevel:%String") [ SqlProc ]
{
}

ClassMethod GetSubListByGrpCodeQueryExecute(ByRef qHandle As %Binary, grpCode As %Text) As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	k ^TEMPDHCWLCode($j)
	s qHandle=$lb(0,repid,0)
 	s ind=1
	q:grpCode="" 0
	s code=$zcvt(grpCode,"U")
	s subGrpList=""
	s grpId=$o(^DHCWL.CodeCfg.GroupI("Code"," "_code,"")) 
	q:grpId="" 0
	/*s subgrpId=0 f  s subgrpId=$o(^DHCWL.CodeCfg.SubGroupI("GrpDr",grpId,subgrpId)) q:subgrpId=""  d
	.s value=##class(DHCWL.CodeCfg.SubGroup).%OpenId(subgrpId)
	.s subgrpDesc=value.SGrpDesc
	.s subgrpCode=value.SGrpCode
	.s subgrpSort=value.SGrpSort
	.s ^TEMPDHCWLCode($j,subgrpSort)=subgrpDesc_"^"_subgrpCode
	s sort=0 f  s sort=$o(^TEMPDHCWLCode($j,sort)) q:sort=""  d
	.s subDesc=$p($g(^TEMPDHCWLCode($j,sort)),"^",1)
	.s subCode=$p($g(^TEMPDHCWLCode($j,sort)),"^",2)
	.s ^CacheTemp(repid,ind)=$lb(subDesc,subCode)
	.s ind=ind+1*/
	d ##class(DHCWL.CodeCfgData.FunctionModule).GetSubGrpList(grpId)
	s subgrpSort=""
	for{
		s subgrpSort=$o(^||TEMPDHCWLCode("S",$j,subgrpSort))
		q:subgrpSort=""
		s mgrpDescS=$p($g(^||TEMPDHCWLCode("S",$j,subgrpSort)),"^",1)
		s subgrpTreeCode=$p($g(^||TEMPDHCWLCode("S",$j,subgrpSort)),"^",2)
		s subgrpLevel=$p($g(^||TEMPDHCWLCode("S",$j,subgrpSort)),"^",3)
		s ^CacheTemp(repid,ind)=$lb(mgrpDescS,subgrpTreeCode,subgrpSort,subgrpLevel)
	    s ind=ind+1
	}	
	
	k ^||TEMPDHCWLCode("S",$j)
	Quit $$$OK
}

ClassMethod GetSubListByGrpCodeQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSubListByGrpCodeQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	k ^TEMPDHCWLCode($j)
	Quit $$$OK
}

ClassMethod GetSubListByGrpCodeQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSubListByGrpCodeQueryExecute ]
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

}
