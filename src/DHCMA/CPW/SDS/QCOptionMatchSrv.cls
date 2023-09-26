/// 单病种质控项目选项对照（HIS医嘱项）处理
Class DHCMA.CPW.SDS.QCOptionMatchSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhugz
/// CreatDate：   2018-12-27
/// Description:  查询质控病种值域对照信息
/// Table：       DHCMA.CPW.SD.QCOptionMatch      
/// d ##class(%ResultSet).RunQuery("DHCMA.CPW.SDS.QCOptionMatchSrv","QryQCItemOptionMatch","2")
Query QryQCItemOptionMatch(aOptionDr As %String) As %Query(ROWSPEC = "OptionDr:%String,RowID:%String,OMType:%String,OMTypeDesc:%String,OMArcimID:%String,OMArcimDesc:%String,OMPHCGeneric:%String,OMCategory:%String")
{
}

ClassMethod QryQCItemOptionMatchExecute(ByRef qHandle As %Binary, aOptionDr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit:aOptionDr="" $$$OK
 	Set xRowID=0
 	For
 	{	
 		Set xRowID=$o(^DHCMA.CPW.SD.QCOptionMatchI("IndexOfItemOptionDr",aOptionDr,xRowID))
 		Quit:xRowID=""
 		Set ObjOptionMatch = ##class(DHCMA.CPW.SD.QCOptionMatch).GetObjById(xRowID)
 		Set OMType          = ObjOptionMatch.OMType
 		Set OMArcimID       = ObjOptionMatch.OMArcimID
 		Set OMArcimDesc     = ObjOptionMatch.OMArcimDesc
 		Set OMPHCGeneric    = ObjOptionMatch.OMPHCGeneric
 		Set OMCategory		= ObjOptionMatch.OMCategory	
 		Set OMTypeDesc=$Case(OMType,1:"按医嘱",2:"按药品通用名",3:"按药品分类",:"")	
		Set Data=$lb(aOptionDr,xRowID,OMType,OMTypeDesc,OMArcimID,OMArcimDesc,OMPHCGeneric,OMCategory)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
 	}
	Quit $$$OK
}

ClassMethod QryQCItemOptionMatchClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryQCItemOptionMatchExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryQCItemOptionMatchFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryQCItemOptionMatchExecute ]
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
