/// 名称: CT.IPMR.FPS.DataItemMapSrv
/// 描述: 编目数据项对照相关服务方法
/// 创建者：liyi
/// 创建日期: 2019-09-17
Class CT.IPMR.FPS.DataItemMapSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liyi
/// CreatDate：   2019-10-08
/// Description:  查询编目数据项对照的术语集
/// Table：       CT.IPMR.FP.DataItemMap,CT.IPMR.FP.DataItem
/// Input：       aFPTypeID：首页类型
///               aAlias：关键字
/// output:       符合条件的对照关系
/// D ##class(%ResultSet).RunQuery("CT.IPMR.FPS.DataItemMapSrv","QueryMapGlossary","156","D01.001.01")
Query QueryMapGlossary(aFPTypeID As %String, aDataItemCode As %String) As %Query(ROWSPEC = "MapID:%String,BGFPTypeID:%String,BGFPTypeDesc:%String,BGCode:%String,BGDesc:%String,BGDataTypeID:%String,BGDataTypeDesc:%String,BGIsActive:%String,BGResume:%String")
{
}

ClassMethod QueryMapGlossaryExecute(ByRef qHandle As %Binary, aFPTypeID As %String, aDataItemCode As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit:(aDataItemCode="")||(aFPTypeID="") $$$OK
 	
 	Set FPTypeIDs = aFPTypeID
 	For xInd = 1:1:$length(aFPTypeID,",") {
		Set FPTypeID=$p(aFPTypeID,",",xInd)
		Set obj = ##class(CT.IPMR.FP.DataItem).GetObjByCode(aDataItemCode,FPTypeID)
		Continue:'$IsObject(obj)
	}
 	Set DataItemID = obj.%Id()
 	Set xMapID=""
 	For {
		Set xMapID=$o( ^CT.IPMR.FP.DataItemMapI("IndexDataItemDr",DataItemID,xMapID))
		Quit:xMapID=""
		Set objMap = ##class(CT.IPMR.FP.DataItemMap).GetObjById(xMapID)
		Continue:'$IsObject(objMap)
		Set objGlossary  = objMap.FDGlossaryDr
		Set objDataItem  = objMap.FDDataItemDr
	
		Set objBGFPType = objGlossary.BGFPTypeDr
		Set (BGFPTypeID,BGFPTypeDesc)=""
		If $IsObject(objBGFPType){
			Set BGFPTypeID   = objBGFPType.%Id()
			Set BGFPTypeDesc = objBGFPType.BDDesc
		}
		Set BGCode = objGlossary.BGCode
		Set BGDesc = objGlossary.BGDesc
		Set objBGDataType = objGlossary.BGDataTypeDr
		Set (BGDataTypeID,BGDataTypeDesc)=""
		If $IsObject(objBGDataType){
			Set BGDataTypeID   = objBGDataType.%Id()
			Set BGDataTypeDesc = objBGDataType.BDDesc
		}
		Set BGIsActive = objGlossary.BGIsActive
		Set BGResume = objGlossary.BGResume
		Set Data=$lb(xMapID,BGFPTypeID,BGFPTypeDesc,BGCode,BGDesc,BGDataTypeID,BGDataTypeDesc,BGIsActive,BGResume)
 		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
 	
	Quit $$$OK
}

ClassMethod QueryMapGlossaryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryMapGlossaryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryMapGlossaryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryMapGlossaryExecute ]
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
/// CreatDate：   2019-10-08
/// Description:  自动对照编目数据项
/// Table：       CT.IPMR.FP.DataItemMap
/// Input：       
/// Return：      返回String
/// w ##class(CT.IPMR.FPS.DataItemMapSrv).AutoContrast()
ClassMethod AutoContrast() As %String
{
	
	Set return =""
	Set xDataItemID = ""
	For {
		Set xDataItemID = $o(^CT.IPMR.FP.DataItemD(xDataItemID))
		Quit:xDataItemID=""
		
		Set objDataItem = ##class(CT.IPMR.FP.DataItem).GetObjById(xDataItemID)
		Continue:'$isobject(objDataItem)
		Set DataItemDesc = objDataItem.FDDesc
		Continue:DataItemDesc=""
		
		Set xGlossaryID = ""
		For {
			Set xGlossaryID = $o(^CT.IPMR.BT.GlossaryI("IndexDesc"," "_$zcvt(DataItemDesc,"U"),xGlossaryID))
			Quit:xGlossaryID=""
		
			Set InputStr    = ""
			Set InputStr    = InputStr_"^"_xGlossaryID
			Set InputStr    = InputStr_"^"_xDataItemID
			D ##class(CT.IPMR.FP.DataItemMap).Update(InputStr,"^")
		}
	}
	
	Quit "OK"
}

Storage Default
{
<Data name="DataItemMapSrvDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CT.IPMR.FPS.DataItemMapSrvD</DataLocation>
<DefaultData>DataItemMapSrvDefaultData</DefaultData>
<IdLocation>^CT.IPMR.FPS.DataItemMapSrvD</IdLocation>
<IndexLocation>^CT.IPMR.FPS.DataItemMapSrvI</IndexLocation>
<StreamLocation>^CT.IPMR.FPS.DataItemMapSrvS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
