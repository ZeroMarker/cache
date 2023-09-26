/// Desc:自定义字典操作
/// Creator: Candyxu
Class DHCEPRFS.BL.BLCustomDic Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", ProcedureBlock ]
{

/// Desc:增加字典
ClassMethod AddDic(ACode As %String, ADesc As %String, Alias As %String, AType As %String, AIsActive As %String, AIndex As %String) As %String
{
	s result = -1
	q:(ACode = "")||(ADesc = "")||(AType = "")
	s obj = ##Class(DHCEPRFS.META.CustomDic).%New()
	s obj.CtmDictAlias = Alias
	s obj.CtmDictCode = ACode
	s obj.CtmDictDesc = ADesc
	s obj.CtmDictType = AType
	s obj.CtmIndex = AIndex
	s obj.CtmIsActive = AIsActive
	s sc = obj.%Save()
	s:($$$ISOK(sc)) result = obj.%Id()
	s obj = ""
	q result
}

/// Desc: 字典
/// Creator: Candyxu
Query GetAllDic() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,CtmDictCode:%String,CtmDictDesc:%String,CtmDictAlias:%String,CtmDictType:%String,CtmIndex:%Integer")
{
	SELECT ID,CtmDictCode,CtmDictDesc,CtmDictAlias,CtmDictType,CtmIndex
	FROM DHCEPRFS_META.CustomDic WHERE CtmIsActive =1
}

/// Desc:根据字典目录ID取分类项
/// Debug:do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLCustomDic","GetFieldByCateDicID",1)
Query GetFieldByCateDicID(CateDicID As %String) As %Query(ROWSPEC = "ID:%String,FieldName:%String,FieldDesc:%String,FieldType:%String,FieldInterface:%String,CategoryID:%String,Sequence:%String")
{
}

ClassMethod GetFieldByCateDicIDExecute(ByRef qHandle As %Binary, CateDicID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	q:(CateDicID = "") $$$OK
	s CateDicID = +CateDicID
	s sequence = ""
	for {
		s sequence = $o(^DHCEPRFS.META.QueryFieldsI("IdxSequence",CateDicID,sequence))
		q:(sequence = "")
		s rowID = ""
		for {
			s rowID = $o(^DHCEPRFS.META.QueryFieldsI("IdxSequence",CateDicID,sequence,rowID))
			q:(rowID = "")
			s obj = ##Class(DHCEPRFS.META.QueryFields).%OpenId(rowID)
			continue:(obj = "")
			continue:((obj.IsActive '= 1)&&(obj.IsActive '= "Y"))
			s FieldName = obj.FieldName
			s FieldDesc = obj.FieldDesc
			s FieldType = obj.FieldType
			s FieldInterface = obj.FieldInterface
			s CategoryID = obj.CategoryID
			s Sequence = obj.Sequence
			s data = $lb(rowID,FieldName,FieldDesc,FieldType,FieldInterface,CategoryID,Sequence)
			s ^CacheTemp(repid,ind) = data
			s ind=ind+1
		}
	}
	Quit $$$OK
}

ClassMethod GetFieldByCateDicIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetFieldByCateDicIDExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetFieldByCateDicIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetFieldByCateDicIDExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
		kill ^CacheTemp(repid)
	}
	Else      {				// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Desc:根据类型获得字典
/// Debug:do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLCustomDic","GetCustomDicByType",3)
Query GetCustomDicByType(AType As %String) As %Query(ROWSPEC = "Code:%String,Desc:%String")
{
}

ClassMethod GetCustomDicByTypeExecute(ByRef qHandle As %Binary, AType As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	q:(AType = "") $$$OK
	s AType = $zcvt(AType,"U")
	s index = ""
	for {
		s index = $o(^DHCEPRFS.META.CustomDicI("IdxTypeIndex"," "_AType,index))
		q:(index = "")
		s rowID = ""
		for {
			s rowID = $o(^DHCEPRFS.META.CustomDicI("IdxTypeIndex"," "_AType,index,rowID))
			q:(rowID = "")
			s obj = ##Class(DHCEPRFS.META.CustomDic).%OpenId(rowID)
			s CtmDictCode = obj.CtmDictCode
			s CtmDictDesc = obj.CtmDictDesc
			s data = $lb(CtmDictCode,CtmDictDesc)
			s ^CacheTemp(repid,ind) = data
			s ind=ind+1
		}
	}
	Quit $$$OK
}

ClassMethod GetCustomDicByTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCustomDicByTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetCustomDicByTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCustomDicByTypeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
		kill ^CacheTemp(repid)
	}
	Else      {				// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Desc:取分类目录字典
Query GetCateDic() As %Query(ROWSPEC = "ID:%String,CategoryName:%String,CategoryDesc:%String,Sequence:%String")
{
}

ClassMethod GetCateDicExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s index = ""
	for {
		s index = $o(^DHCEPRFS.META.QueryCategoryI("IdxSequence",index))
		q:(index = "")
		s rowID = ""
		for {
			s rowID = $o(^DHCEPRFS.META.QueryCategoryI("IdxSequence",index,rowID))
			q:(rowID = "")
			s obj = ##Class(DHCEPRFS.META.QueryCategory).%OpenId(rowID)
			q:(obj = "")
			s CategoryName = obj.CategoryName
			s CategoryDesc = obj.CategoryDesc
			s Sequence = obj.Sequence
			s data = $lb(rowID,CategoryName,CategoryDesc,Sequence)
			s ^CacheTemp(repid,ind) = data
			s ind=ind+1
		}
	}
	Quit $$$OK
}

ClassMethod GetCateDicClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCateDicExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetCateDicFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCateDicExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
		kill ^CacheTemp(repid)
	}
	Else      {				// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
