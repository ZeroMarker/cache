Class DHCWL.MRTJ.BaseService Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// Query：从BS代码维护，获取科室信息，提供给病案统计使用
/// Creator:ycm 2016-05-13
/// 参数说明：GrpCode:为空，则使用默认的病案统计Code,否则根据GrpCode解析
/// 此函数只支持统计子组的解析
/// d ##Class(%ResultSet).RunQuery("DHCWL.MRTJ.BaseService","GetBSGrpDep","")
Query GetBSGrpDep(GrpCode As %String = "") As %Query(ROWSPEC = "GrpId:%String,GrpCode:%String,GrpDesc:%String,SubGrpId:%String,SubGrpCode:%String,SubGrpDesc:%String,Sort:%Integer,LocId:%String,LocDesc:%String") [ SqlProc ]
{
}

ClassMethod GetBSGrpDepExecute(ByRef qHandle As %Binary, GrpCode As %String = "") As %Status
{
	n (qHandle,GrpCode)
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
    Set qHandle=$lb(0,repid,0)
    
    i GrpCode="" s GrpCode="MRGrpDep"  ///BS代码维护默认病案统计科室组
    s GrpCodeI=$$ALPHAUP^SSUTIL4(GrpCode)
    s GrpId=$O(^DHCWL.CodeCfg.GroupI("Code"," "_GrpCodeI,""))
    q:+GrpId=0 $$$OK
    s GrpDesc=$lg(^DHCWL.CodeCfg.GroupD(GrpId),3,"")
    
    s SubGrpId=0
    f  s SubGrpId=$O(^DHCWL.CodeCfg.SubGroupI("GrpDr",GrpId,SubGrpId)) q:SubGrpId=""  d
    .s SubGrpCode=$lg(^DHCWL.CodeCfg.SubGroupD(SubGrpId),2,"")
    .s SubGrpDesc=$lg(^DHCWL.CodeCfg.SubGroupD(SubGrpId),3,"")
    .s Sort=$lg(^DHCWL.CodeCfg.SubGroupD(SubGrpId),5,"")
    .s Id=0,LocId="",LocDesc="",flag=0
    .f  s Id=$O(^DHCWL.CodeCfg.SubGroupItemI("SGrpIM",SubGrpId,Id)) Q:Id=""  d
    ..s LocId=$tr(Id," ","")
    ..s LocDesc=$P(^CTLOC(LocId),"^",2)
    ..i LocDesc["-" s LocDesc=$P(LocDesc,"-",2)
    ..s flag=1
    ..d GetBSGrpDep
    .q:+flag=1
    .d GetBSGrpDep
    Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
GetBSGrpDep
 	s Data=$lb(GrpId,GrpCode,GrpDesc,SubGrpId,SubGrpCode,SubGrpDesc,Sort,LocId,LocDesc)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetBSGrpDepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBSGrpDepExecute ]
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

ClassMethod GetBSGrpDepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBSGrpDepExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 根据CT_LocLinkLocation 的科室关系，大致初始化BS代码病案统计科室，建立住院科室与病区的关系，但是与门诊的关系需要手动建立
/// ycm 2016-05-13
/// d ##Class(DHCWL.MRTJ.BaseService).InitBSGrpDep()
ClassMethod InitBSGrpDep() As %String
{
	s DimId=$O(^DHCWL.MKPI.MKPIDimTypeI("DimTypeI","CTLOC",""))
	q:+DimId=0 "-1^维度CT_LOC不存在"
	s GrpCode="MRGrpDep"
	s GrpCodeI=$$ALPHAUP^SSUTIL4(GrpCode)
	s GrpId=""
	i $D(^DHCWL.CodeCfg.GroupI("Code"," "_GrpCodeI))||$D(^DHCWL.CodeCfg.GroupI("Code",GrpCodeI)) d
	.s GrpId=$O(^DHCWL.CodeCfg.GroupI("Code"," "_GrpCodeI,""))
	.i +GrpId=0 s GrpId=$O(^DHCWL.CodeCfg.GroupI("Code",GrpCodeI,""))
	else  d
	.s GrpDesc="病案统计科室组"
	.s UpDate=+$H
	.TStart
	.s SQLCODE=0
	.&SQL(INSERT INTO DHCWL_CodeCFG.DHCWLCodeCfgGroup(Grp_Code, Grp_Desc, Grp_CreateDate, Grp_Dim_Dr) VALUES(:GrpCode,:GrpDesc,:UpDate,:DimId))
	.i SQLCODE=0 TCommit
	.else  d
	..w "-2^GrpId插入错误"
	..Trollback
	.s GrpId=+$g(%ROWID)
	q:+GrpId=0 "-3^GrpId为空错误"
	s ParRefdr=0
	f  s ParRefdr=$O(^CTLOC(ParRefdr)) q:ParRefdr=""  d
	.q:'$D(^CTLOC(ParRefdr,"LINK"))
	.s ParRefDesc=$P($g(^CTLOC(ParRefdr)),"^",2)
	.s ParRefType=$P($g(^CTLOC(ParRefdr)),"^",13)
	.q:ParRefType="W"  
	.i ParRefDesc["-" s ParRefDesc=$P(ParRefDesc,"-",2)
	.s SubGrpCode="C"_ParRefdr
	.s SubGrpCodeI=$$ALPHAUP^SSUTIL4(SubGrpCode)
	.s SubGrpId=$O(^DHCWL.CodeCfg.SubGroupI("Code",GrpId," "_SubGrpCodeI,""))
	.i +SubGrpId=0 d
	..s Sort=$O(^DHCWL.CodeCfg.SubGroupI("GrpDrSort",GrpId,""),-1)
	..s Sort=Sort+1
	..TStart
	..s SQLCODE=0
	..&SQL(INSERT INTO DHCWL_CodeCFG.DHCWLCodeCfgSubGroup(SGrp_Grp_Dr, SGrp_Code, SGrp_Desc, SGrp_Sort) VALUES(:GrpId,:SubGrpCode,:ParRefDesc,:Sort))
	..i SQLCODE=0 TCommit
	..else  d
	...w "-4^SubGrpId插入错误"
	...Trollback
	..s SubGrpId=+$g(%ROWID)
	.q:+SubGrpId=0  
	.//科室本身插入
	.i '$D(^DHCWL.CodeCfg.SubGroupItemI("SGrp"," "_ParRefdr,SubGrpId,GrpId)) d
	..q:$D(^DHCWL.CodeCfg.SubGroupItemI("Grp",GrpId," "_ParRefdr))
	..TStart
	..s SQLCODE=0
	..&SQL(INSERT INTO DHCWL_CodeCFG.DHCWLCodeCfgSubGroupItem(SGrpIM_SGrp_Dr, SGrpIM_Item_DR, SGrpIM_Grp_Dr)VALUES(:SubGrpId,:ParRefdr,:GrpId))
	..i SQLCODE=0 TCommit
	..else  Trollback
	.//病区
	.s subId=0
	.f  s subId=$O(^CTLOC(ParRefdr,"LINK",subId)) q:subId=""  d
	..s LocId=$P(^CTLOC(ParRefdr,"LINK",subId),"^",1)
	..q:$D(^DHCWL.CodeCfg.SubGroupItemI("SGrp"," "_LocId,SubGrpId,GrpId)) ///已经存在
	..q:$D(^DHCWL.CodeCfg.SubGroupItemI("Grp",GrpId," "_LocId))
	..TStart
	..s SQLCODE=0
	..&SQL(INSERT INTO DHCWL_CodeCFG.DHCWLCodeCfgSubGroupItem(SGrpIM_SGrp_Dr, SGrpIM_Item_DR, SGrpIM_Grp_Dr)VALUES(:SubGrpId,:LocId,:GrpId))
	..i SQLCODE=0 TCommit
	..else  Trollback
	
	q 1
}

Storage Default
{
<Data name="BaseServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^DHCWL.MRTJ.BaseServiceD</DataLocation>
<DefaultData>BaseServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWL.MRTJ.BaseServiceD</IdLocation>
<IndexLocation>^DHCWL.MRTJ.BaseServiceI</IndexLocation>
<StreamLocation>^DHCWL.MRTJ.BaseServiceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
