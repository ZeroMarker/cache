/// 名称：DHCMed.EPDService.InfectCCMapSrv
/// 描述：传染病疾病字典与监控中心传染病监控项目关联记录相关接口
/// 创建者：liuyh
/// 创建日期：2017-05-31
Class DHCMed.EPDService.InfectCCMapSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liuyh
/// CreatDate：   2017-05-31
/// Description:  查询监控项目字典数据
/// Table：       DHCMed.EPD.InfectCCMap
/// Input:        
/// do ##class(%ResultSet).RunQuery("DHCMed.EPDService.InfectCCMapSrv","QryItemDicInfo","EPDCC","")
Query QryItemDicInfo(xSubjectCode As %String, xInfectID As %String, chkIsViewAll As %String) As %Query(ROWSPEC = "rowid:%String,IDDesc:%String,IDResume:%String,IsChecked:%String")
{
}

ClassMethod QryItemDicInfoExecute(ByRef qHandle As %Binary, xSubjectCode As %String, xInfectID As %String, chkIsViewAll As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(xSubjectCode="")||(xInfectID="") $$$OK
	
	Set objSubject=##class(DHCMed.CC.Subject).GetObjByCode(xSubjectCode)
	Quit:'$IsObject(objSubject) $$$OK
	Set SubjectID=objSubject.%Id()
	Set SubActive=objSubject.IsActive
	Quit:SubActive'=1 $$$OK
	
	Set rowid=""
	For {
		Set rowid=$o(^DHCMed.CC("ItemDic",rowid))
		Quit:rowid=""
		
		Set obj=##class(DHCMed.CC.ItemDic).GetObjById(rowid)
		Continue:'$IsObject(obj)
		
		Continue:(chkIsViewAll="N")&&('$d(^DHCMed.EPD.InfectCCMapI("IndexInfDicID"," "_xInfectID," "_rowid)))
		//DHCMed.CC.SubjectItm 
		Continue:'$d(^DHCMed.CCi("SItem",0,"IndexItemDic",SubjectID,rowid))	
		
		Set SubjectItmID=$o(^DHCMed.CCi("SItem",0,"IndexItemDic",SubjectID,rowid,""),-1)
		Set SubItmObj=##class(DHCMed.CC.SubjectItm).GetObjById(SubjectItmID)
		Continue:'$IsObject(SubItmObj)
		Continue:SubItmObj.IsActive=0
		
		Set IDDesc=obj.IDDesc
		Set IDResume=obj.IDResume
		Set IsChecked=0
		Set:$d(^DHCMed.EPD.InfectCCMapI("IndexInfDicID"," "_xInfectID," "_rowid)) IsChecked=1
		Set Data=$lb(rowid,IDDesc,IDResume,IsChecked)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryItemDicInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryItemDicInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryItemDicInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryItemDicInfoExecute ]
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

}
