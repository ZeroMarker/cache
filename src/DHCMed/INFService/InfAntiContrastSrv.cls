/// 名称: DHCMed.INFService.InfAntiContrastSrv
/// 描述: DHCMed.INF.InfAntiContrast 感染标准抗菌素与系统抗菌药对照的常用操作
/// 编写者：liuyh
/// 编写日期: 2010-05-25
Class DHCMed.INFService.InfAntiContrastSrv Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liuyh
/// CreatDate：   2010-05-25
/// Description:  查询抗生素信息
/// Table：       PHC_SubCat
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCMed.INFService.InfAntiContrastSrv","QueryPHCSubCat","","抗生素")
Query QueryPHCSubCat(PHCCatId As %String, PHCCatDesc As %String) As %Query(ROWSPEC = "code:%String,desc:%String,PHCSubCatId:%String")
{
}

ClassMethod QueryPHCSubCatExecute(ByRef qHandle As %Binary, PHCCatId As %String, PHCCatDesc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s rowid="",ret="",Count=0,JIndex=$j
	
	s tmp=$g(^DHCMedHosptial(0))
    s xHosCode=$p(tmp,"/",4)
	
	;^PHCC({PHC_Cat.PHCC_RowId},"SC",{PHCSC_ChildSub})
    i PHCCatId="" d
    .s PHCCatId=0
    .f  s PHCCatId=$o(^PHCC(PHCCatId)) q:PHCCatId=""  d
    ..s tmp=$g(^PHCC(PHCCatId))
    ..s tmpCatDesc=$p(tmp,"^",2)
    ..q:(xHosCode="")&&(PHCCatDesc'="")&&(tmpCatDesc'[PHCCatDesc)
    ..q:(xHosCode="BeiJing_ZYY")&&(tmpCatDesc'="抗微生物药")
    ..q:(xHosCode="BeiJing_DT")&&(tmpCatDesc'="抗生素")
    ..q:'$d(^PHCC(PHCCatId,"SC"))
    ..s ChildSub=0
    ..f  s ChildSub=$o(^PHCC(PHCCatId,"SC",ChildSub)) q:ChildSub=""  d
    ...s tmp=$g(^PHCC(PHCCatId,"SC",ChildSub))
    ...q:tmp=""
    ...s $li(data,1)=$p(tmp,"^",1)		// Code
    ...s $li(data,2)=$p(tmp,"^",2)		// Desc
    ...s $li(data,3)=PHCCatId_"||"_ChildSub		//PHCSubCatId
    ...s ^CacheTemp(repid,ind)=data
    ...s ind=ind+1
    e  d
    .q:'$d(^PHCC(+PHCCatId,"SC"))
    .s ChildSub=0
    .f  s ChildSub=$o(^PHCC(PHCCatId,"SC",ChildSub)) q:ChildSub=""  d
    ..s tmp=$g(^PHCC(PHCCatId,"SC",ChildSub))
    ..q:tmp=""
    ..s $li(data,1)=$p(tmp,"^",1)		// Code
    ..s $li(data,2)=$p(tmp,"^",2)		// Desc
    ..s $li(data,3)=PHCCatId_"||"_ChildSub		// PHCSubCatId
    ..s ^CacheTemp(repid,ind)=data
    ..s ind=ind+1
	q $$$OK
}

ClassMethod QueryPHCSubCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryPHCSubCatExecute ]
{
	Set repid=$li(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryPHCSubCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryPHCSubCatExecute ]
{
	Set AtEnd=$li(qHandle,1)
 	Set repid=$li(qHandle,2)
 	Set ind=$li(qHandle,3)
 	
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     liuyh
/// CreatDate：   2010-05-25
/// Description:  查询抗菌药物对照信息
/// Table：       ARC_ItmMast
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCMed.INFService.InfAntiContrastSrv","QueryAntiContrast","1||1")
Query QueryAntiContrast(PHCSubCatId As %String) As %Query(ROWSPEC = "rowid:%String,ItmMastId:%String,ItmMastDesc:%String,InfAntiDR:%String,InfAntiDesc:%String,Active:%String")
{
}

ClassMethod QueryAntiContrastExecute(ByRef qHandle As %Binary, PHCSubCatId As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s ^aa=PHCSubCatId
	s ret="",Count=0,JIndex=$j
	q:PHCSubCatId="" $$$OK
	s DrgMastId=0
    f  s DrgMastId=$o(^PHCD(DrgMastId)) q:DrgMastId=""  d
    .s tmp=$g(^PHCD(DrgMastId,1))
    .q:tmp=""
    .s tmpSubCatId=$p(tmp,"^",3)
    .q:(PHCSubCatId'="")&&(PHCSubCatId'=tmpSubCatId)
    .s ChildSub=0
    .f  s ChildSub=$o(^PHCD(DrgMastId,"DF",ChildSub)) q:ChildSub=""  d
    ..s DrgFormId=DrgMastId_"||"_ChildSub
    ..;^ARCIM(0,"PHCDF",{ARCIM_PHCDF_DR},{ARCIM_Subscript},{ARCIM_Version})
    ..q:'$d(^ARCIM(0,"PHCDF",DrgFormId))
    ..s SubScript=0
    ..f  s SubScript=$o(^ARCIM(0,"PHCDF",DrgFormId,SubScript)) q:SubScript=""  d
    ...s Version=0
    ...f  s Version=$o(^ARCIM(0,"PHCDF",DrgFormId,SubScript,Version)) q:Version=""  d
    ....s ItmMastId=SubScript_"||"_Version
    ....s AntiConID=$o(^DHCMed.INF.InfAntiContrastI("ItmMastDR"," "_ItmMastId,""))
    ....i AntiConID=""  d  //该抗菌药物未做对照
    .....s $li(data,1)=""				// DHCMed.INF.InfAntiContrast表rowid
    .....s $li(data,2)=ItmMastId		// ItmMastDR
    .....s $li(data,3)=$p($g(^ARCIM(SubScript,Version,1)),"^",2)	// 医嘱项描述
    .....s $li(data,4)=""				// 标准抗菌素ID
    .....s $li(data,5)=""				// 标准抗菌素描述
    .....s $li(data,6)="Y"				// 是否有效(默认为有效)
   	....e  d
   	.....s obj=##class(DHCMed.INF.InfAntiContrast).%OpenId(AntiConID)
   	.....q:'$IsObject(obj)
    .....s $li(data,1)=AntiConID
    .....s $li(data,2)=obj.ItmMastDR
    .....s cSubScript=$p(obj.ItmMastDR,"||",1)
    .....s cVersion=$p(obj.ItmMastDR,"||",2)
    .....q:cSubScript=""
    .....q:cVersion=""
    .....s $li(data,3)=$p($g(^ARCIM(cSubScript,cVersion,1)),"^",2)
    .....s $li(data,4)=obj.InfAntiDR
    .....s PatObj=##class(DHCMed.INF.InfAntiDic).GetObjById(obj.InfAntiDR)
    .....q:'$IsObject(PatObj)
    .....s $li(data,5)=PatObj.Description
    .....s $li(data,6)=$s(obj.Active=1:"Y",obj.Active=0:"N",1:"Y")
    ....s ^CacheTemp(repid,ind)=data
    ....s ind=ind+1
    
    q $$$OK
}

ClassMethod QueryAntiContrastClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryAntiContrastExecute ]
{
	Set repid=$li(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryAntiContrastFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryAntiContrastExecute ]
{
	Set AtEnd=$li(qHandle,1)
 	Set repid=$li(qHandle,2)
 	Set ind=$li(qHandle,3)
 	
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     liuyh
/// CreatDate：   2010-05-26
/// Description:  查询标准抗菌药物字典
/// Table：       DHCMed.INF.InfAntiDic
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCMed.INFService.InfAntiContrastSrv","QueryAntiDicInfo")
Query QueryAntiDicInfo() As %Query(ROWSPEC = "rowid:%String,desc:%String")
{
}

ClassMethod QueryAntiDicInfoExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s rowid=""

	f  s rowid=$o(^DHCMed.INF.InfAntiDicD(rowid)) q:rowid=""  d
	.s obj=##class(DHCMed.INF.InfAntiDic).%OpenId(rowid)
	.s $li(data,1)=rowid
	.s $li(data,2)=obj.Code_"-"_obj.Description
	.q:obj.Active'=1
    .s ^CacheTemp(repid,ind)=data
    .s ind=ind+1
    .do obj.%Close()
	q $$$OK
}

ClassMethod QueryAntiDicInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryAntiDicInfoExecute ]
{
	Set repid=$li(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryAntiDicInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryAntiDicInfoExecute ]
{
	Set AtEnd=$li(qHandle,1)
 	Set repid=$li(qHandle,2)
 	Set ind=$li(qHandle,3)
 	
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
