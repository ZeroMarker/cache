/// 名称: CT.IPMR.FPS.DataItemCatSrv
/// 描述: 编目数据项分类相关服务方法
/// 创建者：liyi
/// 创建日期: 2019-09-17
Class CT.IPMR.FPS.DataItemCatSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liyi
/// CreatDate：   2019-10-08
/// Description:  查询编目数据项分类
/// Table：       CT.IPMR.FP.DataItemCat
/// Input：       aAlias：关键字
/// output:       符合条件的编目数据项分类
/// D ##class(%ResultSet).RunQuery("CT.IPMR.FPS.DataItemCatSrv","QryDataItemCat","")
Query QryDataItemCat(aAlias As %String = "") As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,DataType:%String,Range:%String,LinkCode:%String,DateLimit:%String")
{
}

ClassMethod QryDataItemCatExecute(ByRef qHandle As %Binary, aAlias As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Set xID = ""
 	For {
		Set xID = $o(^CT.IPMR.FP.DataItemCatD(xID))
		Quit:xID=""
		Set objDataItemCat = ##class(CT.IPMR.FP.DataItemCat).GetObjById(xID)
		Continue:'$isobject(objDataItemCat)
		
		Set Code = objDataItemCat.FDCode
		Set Desc = objDataItemCat.FDDesc
		Continue:(aAlias'="")&&(Desc'[aAlias)
		Set objDataType = objDataItemCat.FDDataTypeDr
		Set Range = objDataItemCat.FDRange
		Set DataType=""
		Set:$isobject(objDataType) DataType=objDataType.BDCode
		Set LinkCode = objDataItemCat.FDLinkCode
		Set LinkCode = $tr(LinkCode,".","")
		Set Code = $tr(Code,".","")
		Set DateLimit=objDataItemCat.FDDateLimit
		Set Data=$lb(xID,Code,Desc,DataType,Range,LinkCode,DateLimit)
 		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryDataItemCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDataItemCatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryDataItemCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDataItemCatExecute ]
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
/// Description:  导入编目数据项分类
/// Table：       CT.IPMR.FP.DataItemCat
/// Input：       编目数据项分类
/// w ##class("CT.IPMR.FPS.DataItemCatSrv").ImportDataItemCat("^F01.030^其他类-其他费^NUMBER^")
ClassMethod ImportDataItemCat(aInput As %String) As %String
{
	New (aInput)
	Set return = 0
	//Set ^TMP("ImportDataItemCat")=aInput
	Quit:aInput="" return
	Set DataTypeDesc = $p(aInput,"^",4)
	Set objDataType = ##class(CT.IPMR.BT.Dictionary).GetByTypeCode("FPDataType",DataTypeDesc)
	Quit:'$IsObject(objDataType) return
	
	Set FPTypeDescs = $p(aInput,"^",19)
	Set FPTypeIDs=""
	For ind=1:1:$length(FPTypeDescs,"/") {
		Set TypeDesc = $p(FPTypeDescs,"/",ind)
		Continue:TypeDesc=""
		Set objDic = ##class(CT.IPMR.BT.Dictionary).GetByTypeDesc("FrontPageType",TypeDesc)
		Continue:'$IsObject(objDic)
		If FPTypeIDs="" {
			Set FPTypeIDs = objDic.%Id()
		}else{
			Set FPTypeIDs = FPTypeIDs_","_objDic.%Id()
		}
	}
	Set $p(aInput,"^",19)=FPTypeIDs
	Set DataTypeID = objDataType.%Id()
	Set $p(aInput,"^",4)=DataTypeID
	
	set CatCode = $p(aInput,"^",2)
	set ID = $o(^CT.IPMR.FP.DataItemCatI("IndexFDCode"," "_$ZCVT(CatCode,"U"),0))
	set $p(aInput,"^",1) = ID
	Set return = ##class(CT.IPMR.FP.DataItemCat).Update(aInput,"^")
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2019-10-08
/// Description:  查询编目数据项分类
/// Table：       CT.IPMR.FP.DataItemCat
/// Input：       aAlias：关键字
/// output:       符合条件的编目数据项分类
/// D ##class(%ResultSet).RunQuery("CT.IPMR.FPS.DataItemCatSrv","QrytemCat","")
Query QrytemCat(aAlias As %String = "", aFirstLetter As %String = "") As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,DataTypeID:%String,DataTypeCode:%String,DataTypeDesc:%String,LinkCode:%String,IsShowCode:%String,DicType:%String,DicCode:%String,DicCodeColumn:%String,DicTextColumn:%String,DicDateFrom:%String,DicDateTo:%String,DicLinkColumn:%String,DicIDColumn:%String,IsNecessaryItem:%String,IsItemChar:%String,FPTypeID:%String")
{
}

ClassMethod QrytemCatExecute(ByRef qHandle As %Binary, aAlias As %String = "", aFirstLetter As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Set xID = ""
 	For {
		Set xID = $o(^CT.IPMR.FP.DataItemCatD(xID))
		Quit:xID=""
		Set obj = ##class(CT.IPMR.FP.DataItemCat).GetObjById(xID)
		Continue:'$isobject(obj)
		
		Set Code = obj.FDCode
		Continue:(aFirstLetter'="")&&($e(Code,0,1)'=aFirstLetter)
		
		Set Desc = obj.FDDesc
		Continue:(aAlias'="")&&(Desc'[aAlias)&&(Code'[aAlias)
		
		Set objDataType = obj.FDDataTypeDr
		Set (DataTypeID,DataTypeCode,DataTypeDesc)=""
		if $isobject(objDataType) {
			set DataTypeID=objDataType.%Id()
			set DataTypeCode=objDataType.BDCode
			set DataTypeDesc=objDataType.BDDesc
		}
		set LinkCode 	= obj.FDLinkCode
		set IsShowCode 	= obj.FDIsShowCode
		set DicType 	= obj.FDDicType
		set DicCode 	= obj.FDDicCode
		set DicCodeColumn 	= obj.FDDicCodeColumn
		set DicTextColumn 	= obj.FDDicTextColumn
		set DicDateFrom 	= obj.FDDicDateFrom
		set DicDateTo 		= obj.FDDicDateTo
		set DicLinkColumn 	= obj.FDDicLinkColumn
		set DicIDColumn 	= obj.FDDicIDColumn
		set IsNecessaryItem = obj.FDIsNecessaryItem
		set IsItemChar 		= obj.FDIsItemChar
		
		set FPTypeID="",xItemID=""
		For {
			set xItemID = $o(^CT.IPMR.FP.DataItemI("IndexCatDr",xID,xItemID))
			Quit:xItemID=""
			Quit:FPTypeID'=""
			Set objDataItem = ##class(CT.IPMR.FP.DataItem).GetObjById(xItemID)
			Continue:'$ISObject(objDataItem)
			Set objListFPType = objDataItem.FDFPType
			For xInd=1:1:objListFPType.Count() {
				Set objDic = objListFPType.GetAt(xInd)
				if $isobject(objDic) {
					if FPTypeID="" {
						Set FPTypeID   = objDic.%Id()
					}else{
						Set FPTypeID   = FPTypeID_","_objDic.%Id()
					}
				}
			}
		}
		Set Data=$lb(xID,Code,Desc,DataTypeID,DataTypeCode,DataTypeDesc,LinkCode,IsShowCode,DicType,DicCode,DicCodeColumn,DicTextColumn,DicDateFrom,DicDateTo,DicLinkColumn,DicIDColumn,IsNecessaryItem,IsItemChar,FPTypeID)
 		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QrytemCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrytemCatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QrytemCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrytemCatExecute ]
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
