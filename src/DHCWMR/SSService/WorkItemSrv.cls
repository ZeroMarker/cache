/// 名称: DHCWMR.SSService.WorkItemSrv
/// 描述: 病案操作项目的常用操作
/// 编写者：zhouruimeng
/// 编写日期: 2014-08-19
Class DHCWMR.SSService.WorkItemSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhouruimeng
/// CreatDate：   2014-08-25
/// Description:  查询病案操作项目
/// Table：       DHCWMR.SS.WorkItem
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCWMR.SSService.WorkItemSrv","QryWorkItem")
Query QryWorkItem() As %Query(ROWSPEC = "Id:%String,WCode:%String,WDesc:%String,Resume:%String")
{
}

ClassMethod QryWorkItemExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set xId=""
 	For {
	 	Set xId=$o(^DHCWMR.SS.WorkItemD(xId))
	 	Quit:xId=""
	 	
	 	Set objSub = ##class(DHCWMR.SS.WorkItem).GetObjById(xId)
	 	Continue:'$IsObject(objSub)
	 	
	 	Set RowId = objSub.%Id()
	 	Set WCode = objSub.WICode
	 	Set WDesc = objSub.WIDesc
	 	Set Resume  = objSub.WIResume
 		
 		Set Data = $LB(RowId,WCode,WDesc,Resume)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
 	}
 	
	Quit $$$OK
}

ClassMethod QryWorkItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryWorkItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryWorkItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryWorkItemExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 导入病案操作项目
/// w ##Class(DHCWMR.SSService.WorkItemSrv).ImportWorkItem("")
ClassMethod ImportWorkItem(aInputStr As %String) As %String
{
	New (aInputStr)
	Set return=0
	Quit:(aInputStr="") return
	
	Set Code = $p(aInputStr,"^",2)
	Set Desc = $p(aInputStr,"^",3)
	Set Resume = $p(aInputStr,"^",4)
	
	Set InputStr=""
	Set InputStr=InputStr_"^"_Code
	Set InputStr=InputStr_"^"_Desc
	Set InputStr=InputStr_"^"_Resume
	
	Set return=##class(DHCWMR.SS.WorkItem).Update(InputStr,"^")
	Quit return
}

/// Creator：     zhouruimeng
/// CreatDate：   2014-08-27
/// Description:  导出病案操作项目
/// Table：       DHCWMR.SS.WorkItem
/// w ##Class(DHCWMR.SSService.WorkItemSrv).ExportWorkItem()
ClassMethod ExportWorkItem() As %String
{
	Set return=""
	
	Set xId=""
	For {
		Set xId=$o(^DHCWMR.SS.WorkItemD(xId))
		Quit:xId=""
		Set Ind=0
		
		Set objConfig=##class(DHCWMR.SS.WorkItem).GetObjById(xId)
		Continue:'$IsObject(objConfig)
		
		Set Id          = objConfig.%Id()
	 	Set Code        = objConfig.WICode
	 	Set Description = objConfig.WIDesc
	 	Set Resume      = objConfig.WIResume 
	 	Set Ind=Ind+1
		Set return=return_"||"_Ind_"^"_Id_"^"_Code_"^"_Description_"^"_Resume
	}
	
	Quit return
}

}
