Class web.DHCWLQueryDim Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Parameter BUILD = 269;

/// Query：解析科室组
/// d ##Class(%ResultSet).RunQuery("web.DHCWLQueryDim","QueryDept","MRGrpDep")
Query QueryDept(mGroupDr As %String) As %Query(ROWSPEC = "mGrpName:%String,mGrpSubName:%String,mGrpSubId:%String,mGrpDetail:%String,mGrpDetailId:%Integer") [ SqlProc ]
{
}

ClassMethod QueryDeptExecute(ByRef qHandle As %Binary, mGroupDr As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
    Set qHandle=$lb(0,repid,0)
    q:mGroupDr="" 1
    /*
	q:'$d(^DHCWLCFG("GRP",mGroupDr)) 1
	s mSubDr=0
	
	f  s mSubDr=$o(^DHCWLCFG("GRP",mGroupDr,"SUBGRP",mSubDr)) q:$g(mSubDr)=""  d
	.s mGrpName=$p($G(^DHCWLCFG("GRP",mGroupDr)),"^",2)
	.s mGrpSubName=$p($G(^DHCWLCFG("GRP",mGroupDr,"SUBGRP",mSubDr)),"^",2)
	.s mGroupSubDr=$g(mGroupDr)_"||"_$g(mSubDr)
	.s mGrpSubId=mGroupSubDr
	.s mDepName="Null"
	.s mSubDepId=0
	.f  s mSubDepId=$o(^DHCWLCFGR("SUBGRPDEP","SUBGRP",mGroupSubDr,mSubDepId)) q:$g(mSubDepId)=""  d
	..s mDepDr=$p($g(^DHCWLCFGR("SUBGRPDEP",mSubDepId)),"^",3) 
	..i mDepDr'="" d
    ...s mGrpDetail=$p($G(^CTLOC(mDepDr)),"^",2)
    ...i $G(mGrpDetail)["-" s mGrpDetail=$p($G(mGrpDetail),"-",2)
    ..s mGrpDetailId=mDepDr
    
    */
    q:mGroupDr="" $$$OK
	s GrpCodeI=$ZCVT(mGroupDr,"U")
	
	s grpId=0 
	f  s grpId=$o(^DHCWL.CodeCfg.GroupI("Code"," "_GrpCodeI,grpId)) q:grpId=""  d
	.s GrpDesc=$lg(^DHCWL.CodeCfg.GroupD(grpId),3,"")
	.s TypeDr=$lg(^DHCWL.CodeCfg.GroupD(grpId),7,"")
	.s DimDr=$lg(^DHCWL.CodeCfg.GroupD(grpId),11,"")
	.s subgrpId=0 f  s subgrpId=$o(^DHCWL.CodeCfg.SubGroupI("GrpDr",grpId,subgrpId)) q:subgrpId=""  d
	..s value=##class(DHCWL.CodeCfg.SubGroup).%OpenId(subgrpId)
	..s subgrpDesc=value.SGrpDesc
	..s subgrpCode=value.SGrpCode
	..s subgrpSort=value.SGrpSort
	..s ItemDr="",flag=0
	..f  s ItemDr=$O(^DHCWL.CodeCfg.SubGroupItemI("SGrpIM",subgrpId,ItemDr)) q:ItemDr=""  d
	...s flag=1
	...s Id=$tr(ItemDr," ","")
	...s ValueDesc=##class(DHCWL.Interface.MkpiData).GetDimPropertyValue(DimDr,Id)
	...;s ValueDes=##class(DHCWL.CodeCfg.Type).GetValueDeseById(TypeDr,Id)
	...;b //w
	...s ValueDesc=$P(ValueDesc,"@",1)
  	...s Data=$lb(GrpDesc,subgrpDesc,subgrpSort,ValueDesc,Id)
    ...s ^CacheTemp(repid,ind)=Data
 	...s ind=ind+1
	...q

    
    Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
}

ClassMethod QueryDeptFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryDeptExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryDeptClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryDeptExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Query：解析疾病组
/// d ##Class(%ResultSet).RunQuery("web.DHCWLQueryDim","GetDiagGrp","疾病分类报表编码")
Query GetDiagGrp(mGroupDr As %String) As %Query(ROWSPEC = "mGroupDr:%String,mDiagGrpSubDesc:%String,mDiagCat:%String") [ SqlProc ]
{
}

ClassMethod GetDiagGrpExecute(ByRef qHandle As %Binary, mGroupDr As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
    Set qHandle=$lb(0,repid,0)
    q:mGroupDr="" 1
    
	q:'$d(^DHCMRICDConfig(0,"MRICDCFG_CATEGORY",mGroupDr)) 1
	s mDiagGrpID=0
	f  s mDiagGrpID=$o(^DHCMRICDConfig(0,"MRICDCFG_CATEGORY",mGroupDr,mDiagGrpID)) q:$G(mDiagGrpID)=""  d
	.q:'$d(^DHCMRICDConfig(mDiagGrpID))
	.s mDiagGrpSubDesc=$p($g(^DHCMRICDConfig(mDiagGrpID)),"^",2)
	.s mDiagCat=$p($g(^DHCMRICDConfig(mDiagGrpID)),"^",3)
    .Do GetDiagGrp
    Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
GetDiagGrp
	s Data=$lb(mGroupDr,mDiagGrpSubDesc,mDiagCat)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetDiagGrpFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDiagGrpExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetDiagGrpClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDiagGrpExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Storage Default
{
<Data name="DHCWLQueryDimDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCWLQueryDimD</DataLocation>
<DefaultData>DHCWLQueryDimDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCWLQueryDimD</IdLocation>
<IndexLocation>^web.DHCWLQueryDimI</IndexLocation>
<StreamLocation>^web.DHCWLQueryDimS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
