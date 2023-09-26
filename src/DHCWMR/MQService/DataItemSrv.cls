/// 名称: DHCWMR.MQService.DataItemSrv
/// 描述: 首页数据项相关服务
/// 编写者：zhufei
/// 编写日期: 2014-12-07
Class DHCWMR.MQService.DataItemSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

///  Creator：     liyi
///  CreatDate：   2016-03-31
///  Description:  查询首页数据项大类
///  Table：       DHCWMR.MQService.DataItems
///  Return：      返回Query
///  do ##class(%Library.ResultSet).RunQuery("DHCWMR.MQService.DataItemSrv","QryDataField","","4","4||1")
Query QryDataField(aDataSrc As %String, aDataCat As %String, aDataSubCat As %String = "") As %Query(ROWSPEC = "ID:%String,ItemDesc:%String,ItemCat:%String,DataSrc:%String")
{
}

ClassMethod QryDataFieldExecute(ByRef qHandle As %Binary, aDataSrc As %String, aDataCat As %String, aDataSubCat As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set DataSrcCode=""
	If (aDataSrc'=""){
		Set objSrc=##class(DHCWMR.SS.Dictionary).GetObjById(aDataSrc)
		Quit:'$IsObject(objSrc) $$$OK
		Set DataSrcCode=objSrc.SDCode
		Quit:DataSrcCode="" $$$OK
	}
	
	Kill arrItemDesc
	Set xID=0
	For {
		Set xID=$o(^DHCWMR.MQ.DataItemsD(xID))
		Quit:xID=""
		
		Set obj=##class(DHCWMR.MQ.DataItems).GetObjById(xID)
		Continue:'$IsObject(obj)
		Continue:obj.IsActive'=1
		Set DataSrc=obj.DataSource
		Continue:DataSrc=""
		Continue:(DataSrcCode'=DataSrc)&&(DataSrcCode'="")
		Set ItemID=obj.%Id()
		Set ItemDesc=obj.MRItemDesc
		Set ItemCol=obj.MRItemCol
		Set objItemCat=obj.MRItemCat
		Set objItemSubCat=obj.MRItemSubCat
		Continue:'$isobject(objItemCat)
		Continue:'$isobject(objItemSubCat)
		Continue:(aDataCat'="")&&(aDataCat'=objItemCat.%Id())
		Continue:(aDataSubCat'="")&&(aDataSubCat'=objItemSubCat.%Id())
		Continue:$d(arrItemDesc(ItemDesc))
		Set arrItemDesc(ItemDesc)=""
		
		Set ^CacheTemp(repid,ind)=$lb(xID,ItemDesc,ItemCat,DataSrc)
		Set ind=ind+1
	}
	Kill arrItemDesc
	
	Quit $$$OK
}

ClassMethod QryDataFieldClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDataFieldExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryDataFieldFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDataFieldExecute ]
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

/// Creator：     zhufei
/// CreatDate：   2014-12-07
/// Description:  查询首页数据项列表
/// Table：       DHCWMR.MQ.DataItems
/// Input：       DataSource : 数据来源
///               ElementCode : 电子病历模板单元
///               DataType : 数据类型
///               MRItemDesc : 项目名称
///               MRItemCat : 项目分类
///               FPltemDesc : 编目项目名称
/// Return：      返回Query
/// d ##class(%ResultSet).RunQuery("DHCWMR.MQService.DataItemSrv","QryDataItems","")
Query QryDataItems(aItemAlias As %String) As %Query(ROWSPEC = "RowId:%String,DataSourceCode:%String,DataSource:%String,ElementCode:%String,ElementDesc:%String,DataTypeCode:%String,DataType:%String,MRItemDesc:%String,MRItemCat:%String,MRItemSubCat:%String,FPltemDesc:%String,MRItemCol:%String,MRIsIndex:%String,MRIsIndexDesc:%String,FPltemDesc:%String,IsActive:%String,IsActiveDesc:%String,Resume:%String,MRItemCatDesc:%String,MRItemSubCatDesc:%String") [ SqlProc ]
{
}

ClassMethod QryDataItemsExecute(ByRef qHandle As %Binary, aItemAlias As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	
	Set xID=""
	For {
		Set xID=$o(^DHCWMR.MQ.DataItemsD(xID))
		Quit:xID=""
		
		Set objDataItem = ##Class(DHCWMR.MQ.DataItems).GetObjById(xID)
		Continue:'$IsObject(objDataItem)
		
		Set DataSourceCode=objDataItem.DataSource
		Set DataSourceDesc="",DataSourceID=""
		Set objDic=##class(DHCWMR.SS.Dictionary).GetByTypeCode("FPDataSource",DataSourceCode,0)
		If $IsObject(objDic){
			Set DataSourceID=objDic.%Id()
			Set DataSourceCode=objDic.SDCode
			Set DataSourceDesc=objDic.SDDesc
		}
		Set ElementCode=objDataItem.ElementCode
		Set ElementDesc=objDataItem.ElementDesc
		
		Set DataTypeCode=objDataItem.DataType,DataTypeDesc="",DataTypeID=""
		Set objDic=##class(DHCWMR.SS.Dictionary).GetByTypeCode("FPDataType",DataTypeCode,0)
		If $IsObject(objDic){
			Set DataTypeID=objDic.%Id()
			Set DataTypeCode=objDic.SDCode
			Set DataTypeDesc=objDic.SDDesc
		}
		
		Set MRItemDesc=objDataItem.MRItemDesc
		Set MRItemCat=objDataItem.MRItemCat
		Set MRItemSubCat=objDataItem.MRItemSubCat
		Set MRItemCatDesc="",MRItemSubCatDesc=""
		Set:$isobject(MRItemCat) MRItemCatDesc = MRItemCat.DCDesc
		Set:$isobject(MRItemSubCat) MRItemSubCatDesc = MRItemSubCat.DSCDesc
		Set MRItemCol=objDataItem.MRItemCol
		Set MRIsIndex=objDataItem.MRIsIndex
		Set MRIsIndexDesc=$s(MRIsIndex=1:"是",1:"否")
		Set FPltemDesc=objDataItem.FPltemDesc
		Set IsActive=objDataItem.IsActive
		Set IsActiveDesc=$s(IsActive=1:"是",1:"否")
		Set Resume=objDataItem.Resume
		
		If aItemAlias'="" {
			//项目名称、项目分类、模板单元代码、编目项目名称检索
			Continue:(MRItemDesc'[aItemAlias)&&(MRItemCat'[aItemAlias)&&(MRItemSubCat'[aItemAlias)&&(ElementCode'[aItemAlias)&&(FPltemDesc'[aItemAlias)
		}
		
		Set Data=$lb(xID)
		Set Data=Data_$lb(DataSourceID)
		Set Data=Data_$lb(DataSourceDesc)
		Set Data=Data_$lb(ElementCode)
		Set Data=Data_$lb(ElementDesc)
		Set Data=Data_$lb(DataTypeID)
		Set Data=Data_$lb(DataTypeDesc)
		Set Data=Data_$lb(MRItemDesc)
		Set Data=Data_$lb(MRItemCat)
		Set Data=Data_$lb(MRItemSubCat)
		Set Data=Data_$lb(FPltemDesc)
		Set Data=Data_$lb(MRItemCol)
		Set Data=Data_$lb(MRIsIndex)
		Set Data=Data_$lb(MRIsIndexDesc)
		Set Data=Data_$lb(FPltemDesc)
		Set Data=Data_$lb(IsActive)
		Set Data=Data_$lb(IsActiveDesc)
		Set Data=Data_$lb(Resume)
		Set Data=Data_$lb(MRItemCatDesc)
		Set Data=Data_$lb(MRItemSubCatDesc)
		
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryDataItemsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDataItemsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryDataItemsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDataItemsExecute ]
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
