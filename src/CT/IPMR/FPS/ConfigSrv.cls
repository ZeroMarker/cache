/// 名称: CT.IPMR.FPS.ConfigSrv
/// 描述: 编目配置相关服务方法
/// 创建者：liyi
/// 创建日期: 2019-09-17
Class CT.IPMR.FPS.ConfigSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liyi
/// CreatDate：   2019-10-08
/// Description:  查询编目配置
/// Table：       CT.IPMR.FP.Config
/// Input：       
/// output:       符合条件的编目配置
/// D ##class(%ResultSet).RunQuery("CT.IPMR.FPS.ConfigSrv","QueryCodeConfig")
Query QueryCodeConfig() As %Query(ROWSPEC = "ID:%String,WorkFlowID:%String,WorkFlowDesc:%String,WorkFItemID:%String,WorkFItemDesc:%String,ICDVerID:%String,ICDVerDesc:%String,OprVerID:%String,OprVerDesc:%String,ICDVer2ID:%String,ICDVer2Desc:%String,ICDVer3ID:%String,ICDVer3Desc:%String,Resume:%String,CodeMultiVerID:%String,CodeMultiVerDesc:%String,IsDefault:%String")
{
}

ClassMethod QueryCodeConfigExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	// 多语言
	Set langid=20
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
	}
 	Set xID =""
 	For {
		Set xID = $o(^CT.IPMR.FP.ConfigD(xID))
		Quit:xID=""
		Set objCodeConfig = ##class(CT.IPMR.FP.Config).GetObjById(xID)
		Continue:'$IsObject(objCodeConfig)
		Set objWorkFItem = objCodeConfig.FCWorkFItemDr
		Set objICDVer = objCodeConfig.FCICDVer
		Set objOprVer = objCodeConfig.FCOprVer
		Set objICDVer2 = objCodeConfig.FCICDVer2
		Set objICDVer3 = objCodeConfig.FCICDVer3
		Set Resume = objCodeConfig.FCResume
		Set objCodeMultiVer = objCodeConfig.FCCodeMultiVer
		Set IsDefault = objCodeConfig.FCIsDefault
		Continue:'$IsObject(objWorkFItem)
		Continue:'$IsObject(objWorkFItem.BWItem)
		Continue:'$IsObject(objWorkFItem.Parref)
		Set WorkFItemID = objWorkFItem.%Id()
		Set WorkFItemDesc=objWorkFItem.BWItem.BWDesc
		Set (ICDVerID,ICDVerDesc)=""
		If $IsObject(objICDVer){
			Set ICDVerID = objICDVer.%Id()
			Set ICDVerDesc = objICDVer.FIEdition.BDDesc_" "_objICDVer.FIICDType.BDDesc_" "_objICDVer.FIVersion
		}
		Set (OprVerID,OprVerDesc)=""
		If $IsObject(objOprVer){
			Set OprVerID = objOprVer.%Id()
			Set OprVerDesc = objOprVer.FIEdition.BDDesc_" "_objOprVer.FIICDType.BDDesc_" "_objOprVer.FIVersion
		}
		Set (ICDVer2ID,ICDVer2Desc)=""
		If $IsObject(objICDVer2){
			Set ICDVer2ID = objICDVer2.%Id()
			Set ICDVer2Desc = objICDVer2.FIEdition.BDDesc_" "_objICDVer2.FIICDType.BDDesc_" "_objICDVer2.FIVersion
		}
		Set (ICDVer3ID,ICDVer3Desc)=""
		If $IsObject(objICDVer3){
			Set ICDVer3ID = objICDVer3.%Id()
			Set ICDVer3Desc = objICDVer3.FIEdition.BDDesc_" "_objICDVer3.FIICDType.BDDesc_" "_objICDVer3.FIVersion
		}
		Set WorkFlowID = objWorkFItem.Parref.%Id()
		Set WorkFlowDesc = objWorkFItem.Parref.BWDesc
		Set (CodeMultiVerID,CodeMultiVerDesc)=""
		If $IsObject(objCodeMultiVer){
			Set CodeMultiVerID = objCodeMultiVer.%Id()
			Set CodeMultiVerDesc = objCodeMultiVer.BDDesc
		}
		Set:CodeMultiVerDesc'="" CodeMultiVerDesc=##class(CT.IPMR.BT.Dictionary).GetTranByDesc("BDDesc",CodeMultiVerDesc,langid)
		Set Data=$lb(xID,WorkFlowID,WorkFlowDesc,WorkFItemID,WorkFItemDesc,ICDVerID,ICDVerDesc,OprVerID,OprVerDesc,ICDVer2ID,ICDVer2Desc,ICDVer3ID,ICDVer3Desc,Resume,CodeMultiVerID,CodeMultiVerDesc,IsDefault)
 		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QueryCodeConfigClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryCodeConfigExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryCodeConfigFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryCodeConfigExecute ]
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

/// Creator：     liyi
/// CreatDate：   2022-03-16
/// Description:  查询多版本编目配置
/// Table：       CT.IPMR.BT.Config
/// Input：       aWorkFItemID:编目操作项目ID
/// output:       除默认配置外的编目配置
/// D ##class(%ResultSet).RunQuery("CT.IPMR.FPS.ConfigSrv","QryMultiVer","1||4")
Query QryMultiVer(aWorkFItemID As %String) As %Query(ROWSPEC = "ID:%String,CodeMultiVerDesc:%String")
{
}

ClassMethod QryMultiVerExecute(ByRef qHandle As %Binary, aWorkFItemID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	// 多语言
 	Set langid=20
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
	}
 	Quit:aWorkFItemID="" $$$OK
 	
 	Set xID = ""
	For {
		Set xID = $o(^CT.IPMR.FP.ConfigI("IndexWorkFItemDr",aWorkFItemID,xID))
		Quit:xID=""
		set objConfig = ##class(CT.IPMR.FP.Config).GetObjById(xID)
		Continue:objConfig.FCIsDefault=1
		Continue:'$isobject(objConfig.FCCodeMultiVer)
		Set CodeMultiVerDesc = objConfig.FCCodeMultiVer.BDDesc
		Set:CodeMultiVerDesc'="" CodeMultiVerDesc=##class(CT.IPMR.BT.Dictionary).GetTranByDesc("BDDesc",CodeMultiVerDesc,langid)
		Set Data=$lb(xID,CodeMultiVerDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryMultiVerClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMultiVerExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryMultiVerFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMultiVerExecute ]
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
