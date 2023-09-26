/// 名称: CT.IPMR.FPS.ICDClassSrv
/// 描述: 编码库类目、亚目服务方法
/// 创建者：liyi
/// 创建日期: 2019-10-21
Class CT.IPMR.FPS.ICDCatSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liyi
/// CreatDate：   2020-02-22
/// Description:  导入类目字典
/// Table：       CT.IPMR.FP.ICDCat
/// Input：       aInputStr ：字典数据
///               aSeparate : 分隔符
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(CT.IPMR.FPS.ICDCatSrv).ImportICDCat("^O^其他非手术性操作^99","^")
ClassMethod ImportICDCat(aInputStr As %String, aSeparate As %String = "") As %String
{
	New (aInputStr,aSeparate)
	Set return = 0
	Set ^TMP("ImportICDCat")=$lb(aInputStr,aSeparate)
	Set TypeCode = $p(aInputStr,"^",2)
	Set objType = ##class(CT.IPMR.BT.Dictionary).GetByTypeCode("ICDType",TypeCode)
	Quit:'$isobject(objType) return
	Set $p(aInputStr,"^",2) = objType.%Id()
	Set ret = ##class(CT.IPMR.FP.ICDCat).Update(aInputStr,aSeparate)
	if ret<1 {
		Quit return
	}
	Set return = ret
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2020-02-22
/// Description:  导入亚目字典
/// Table：       CT.IPMR.FP.ICDCat
/// Input：       aInputStr ：字典数据
///               aSeparate : 分隔符
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(CT.IPMR.FPS.ICDCatSrv).ImportICDCatSub("","^")
ClassMethod ImportICDCatSub(aInputStr As %String, aSeparate As %String = "") As %String
{
	New (aInputStr,aSeparate)
	Set return = 0
	//Set ^TMP("ImportICDCatSub")=$lb(aInputStr,aSeparate)
	Set TypeCode = $p(aInputStr,"^",2)
	Set objType = ##class(CT.IPMR.BT.Dictionary).GetByTypeCode("ICDType",TypeCode)
	Quit:'$isobject(objType) return
	
	Set $p(aInputStr,"^",2) = objType.%Id()
	Set ret = ##class(CT.IPMR.FP.ICDCatSub).Update(aInputStr,aSeparate)
	if ret<1 {
		Quit return
	}
	Set return = ret
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2022-07-13
/// Description:  导入细目字典
/// Table：       CT.IPMR.FP.ICDDetailCata
/// Input：       aInputStr ：字典数据
///               aSeparate : 分隔符
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(CT.IPMR.FPS.ICDCatSrv).ImportICDDetailCata("","^")
ClassMethod ImportICDDetailCata(aInputStr As %String, aSeparate As %String = "") As %String
{
	New (aInputStr,aSeparate)
	Set return = 0
	//Set ^TMP("ImportICDDetailCata")=$lb(aInputStr,aSeparate)
	Set TypeCode = $p(aInputStr,"^",2)
	Set objType = ##class(CT.IPMR.BT.Dictionary).GetByTypeCode("ICDType",TypeCode)
	Quit:'$isobject(objType) return
	
	Set $p(aInputStr,"^",2) = objType.%Id()
	Set ret = ##class(CT.IPMR.FP.ICDDetailCata).Update(aInputStr,aSeparate)
	if ret<1 {
		Quit return
	}
	Set return = ret
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2020-02-22
/// Description:  查询ICD类目
/// Table：       CT.IPMR.FP.ICDCat
/// Input：       
/// output:       ICD类目列表
/// D ##class(%ResultSet).RunQuery("CT.IPMR.FPS.ICDCatSrv","QryICDCat","D")
Query QryICDCat(aICDTypeCode As %String) As %Query(ROWSPEC = "ID:%String,ICDTypeID:%String,ICDTypeCode:%String,ICDTypeDesc:%String,CatDesc:%String,CatAlias:%String")
{
}

ClassMethod QryICDCatExecute(ByRef qHandle As %Binary, aICDTypeCode As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit:aICDTypeCode="" $$$OK
 	
 	Set objType = ##class(CT.IPMR.BT.Dictionary).GetByTypeCode("ICDType",aICDTypeCode)
	Quit:'$isobject(objType) $$$OK
	
	Set ICDTypeID = objType.%Id()
	Set ICDTypeCode = objType.BDCode
	Set ICDTypeDesc = objType.BDDesc
	
	Set xICDAlias = ""
	For {
		Set xICDAlias = $o(^CT.IPMR.FP.ICDCatI("IndexICDAlias",objType.%Id(),xICDAlias))
		Quit:xICDAlias=""
		
		Set xID = ""
		For {
			Set xID = $o(^CT.IPMR.FP.ICDCatI("IndexICDAlias",objType.%Id(),xICDAlias,xID))
			Quit:xID=""
			Set obj = ##class(CT.IPMR.FP.ICDCat).GetObjById(xID)
			Continue:'$isobject(obj)
			Set CatDesc = obj.FIDesc
			Set CatAlias = obj.FIICDAlias
			Set Data=$lb(xID,ICDTypeID,ICDTypeCode,ICDTypeDesc,CatDesc,CatAlias)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QryICDCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryICDCatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryICDCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryICDCatExecute ]
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
/// CreatDate：   2020-02-22
/// Description:  查询ICD亚目
/// Table：       CT.IPMR.FP.ICDCat
/// Input：       
/// output:       ICD亚目列表
/// D ##class(%ResultSet).RunQuery("CT.IPMR.FPS.ICDCatSrv","QryICDCatSub","D")
Query QryICDCatSub(aICDTypeCode As %String) As %Query(ROWSPEC = "ID:%String,ICDTypeID:%String,ICDTypeCode:%String,ICDTypeDesc:%String,CatSubDesc:%String,CatSubAlias:%String")
{
}

ClassMethod QryICDCatSubExecute(ByRef qHandle As %Binary, aICDTypeCode As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit:aICDTypeCode="" $$$OK
 	
 	Set objType = ##class(CT.IPMR.BT.Dictionary).GetByTypeCode("ICDType",aICDTypeCode)
	Quit:'$isobject(objType) $$$OK
	
	Set ICDTypeID = objType.%Id()
	Set ICDTypeCode = objType.BDCode
	Set ICDTypeDesc = objType.BDDesc
	
	Set xICDAlias = ""
	For {
		Set xICDAlias = $o(^CT.IPMR.FP.ICDCatSubI("IndexICDAlias",objType.%Id(),xICDAlias))
		Quit:xICDAlias=""
		
		Set xID = ""
		For {
			Set xID = $o(^CT.IPMR.FP.ICDCatSubI("IndexICDAlias",objType.%Id(),xICDAlias,xID))
			Quit:xID=""
			Set obj = ##class(CT.IPMR.FP.ICDCatSub).GetObjById(xID)
			Continue:'$isobject(obj)
			Set CatSubDesc = obj.FIDesc
			Set CatSubAlias = obj.FIICDAlias
			Set Data=$lb(xID,ICDTypeID,ICDTypeCode,ICDTypeDesc,CatSubDesc,CatSubAlias)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QryICDCatSubClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryICDCatSubExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryICDCatSubFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryICDCatSubExecute ]
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
/// CreatDate：   2022-07-14
/// Description:  查询ICD细目
/// Table：       CT.IPMR.FP.ICDCat
/// Input：       
/// output:       ICD细目列表
/// D ##class(%ResultSet).RunQuery("CT.IPMR.FPS.ICDCatSrv","QryICDDetailCata","O")
Query QryICDDetailCata(aICDTypeCode As %String) As %Query(ROWSPEC = "ID:%String,ICDTypeID:%String,ICDTypeCode:%String,ICDTypeDesc:%String,DetailCataDesc:%String,DetailCataAlias:%String")
{
}

ClassMethod QryICDDetailCataExecute(ByRef qHandle As %Binary, aICDTypeCode As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit:aICDTypeCode="" $$$OK
 	
 	Set objType = ##class(CT.IPMR.BT.Dictionary).GetByTypeCode("ICDType",aICDTypeCode)
	Quit:'$isobject(objType) $$$OK
	
	Set ICDTypeID = objType.%Id()
	Set ICDTypeCode = objType.BDCode
	Set ICDTypeDesc = objType.BDDesc
	
	Set xICDAlias = ""
	For {
		Set xICDAlias = $o(^CT.IPMR.FP.ICDDetailCataI("IndexICDAlias",objType.%Id(),xICDAlias))
		Quit:xICDAlias=""
		
		Set xID = ""
		For {
			Set xID = $o(^CT.IPMR.FP.ICDDetailCataI("IndexICDAlias",objType.%Id(),xICDAlias,xID))
			Quit:xID=""
			Set obj = ##class(CT.IPMR.FP.ICDDetailCata).GetObjById(xID)
			Continue:'$isobject(obj)
			Set DetailCataDesc = obj.FIDesc
			Set DetailCataAlias = obj.FIICDAlias
			Set Data=$lb(xID,ICDTypeID,ICDTypeCode,ICDTypeDesc,DetailCataDesc,DetailCataAlias)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QryICDDetailCataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryICDDetailCataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryICDDetailCataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryICDDetailCataExecute ]
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
