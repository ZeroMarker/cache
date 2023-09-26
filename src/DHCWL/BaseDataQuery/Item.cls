/// d ##class(DHCWL.BaseDataQuery.Item).%BuildIndices()
Class DHCWL.BaseDataQuery.Item Extends %Persistent
{

/// 查询对象名称
Property QueryObjName As %String(COLLATION = "EXACT");

Index QueryObjNameIndex On (QueryObjName, Name);

/// 查询项描述
Property Descript As %String;

/// 查询项名称
Property Name As %String(COLLATION = "EXACT");

/// 查询项类型
Property Type As %String;

/// 关联维度类型
Property LinkDimType As %String;

/// 关联维度编码
/// 2.0后，改完基础维度的路径
Property LinkDimCode As %String;

/// 保留字段
Property PiecePos As %Integer;

/// 统计项数值类型
Property ColType As %Integer;

/// 子类型类型-custom:自定义
Property SubType As %String(COLLATION = "EXACT");

/// 子类型类型-custom:自定义
Property FunPara As %String(COLLATION = "EXACT");

ClassMethod GetItem(QueryObjName, Name) As Item
{
	q:( ('$d(^DHCWL.BaseDataQuery.ItemI("QueryObjNameIndex",QueryObjName))) || ('$d(^DHCWL.BaseDataQuery.ItemI("QueryObjNameIndex",QueryObjName,Name))) ) ""
	s id=$o(^DHCWL.BaseDataQuery.ItemI("QueryObjNameIndex",QueryObjName,Name,""))
	q ##class(Item).%OpenId(id)
}

ClassMethod Insert(ByRef inParam, ByRef outParam) As %String
{
	s $zt="SQLErr"
	s ret=""	
	//s qryObj=##class(DHCWL.BaseDataQuery.QueryObj).%OpenId(inParam("ROWID"))
	s itemNames=inParam("ItemName")
	s len=$l(itemNames,",")	
	f i=1:1:len {
		s newObj=##class(DHCWL.BaseDataQuery.Item).%New()
		s newObj.QueryObjName=inParam("BaseObjName")
		s newObj.Name=$p(itemNames,",",i)						//把主题维度的编码作为查询对象的名称
		s newObj.Descript=$p(inParam("ItemDesc"),",",i)
		s newObj.Type=$p(inParam("ItemType"),",",i)
		s newObj.LinkDimType=$p(inParam("LinkDimType"),",",i)
		s newObj.LinkDimCode=$p(inParam("DimCode"),",",i)
		s newObj.PiecePos=-1
		s newObj.ColType=$p(inParam("ColType"),",",i)
		s newObj.SubType=$p(inParam("SubType"),",",i)
		s newObj.FunPara=$p(inParam("FunPara"),",",i)
		s sc=newObj.%Save()
		If $$$ISERR(sc) {
			s ret="新建统计项失败:"_$System.Status.GetErrorText(sc)
			q
	 	}
	 	d newObj.%Close()
	}

	q ret

SQLErr
	if ret="" s ret="新建统计项失败:"_$ZERROR
	q ret
}

ClassMethod update(ByRef inParam, ByRef outParam) As %String
{
	s $zt="SQLErr"
	s ret=""	
	s ItemIDs=inParam("ItemID")
	s len=$l(ItemIDs,",")	
	f i=1:1:len {
		s newObj=##class(DHCWL.BaseDataQuery.Item).%OpenId($p(ItemIDs,",",i))
		s newObj.Descript=$p(inParam("ItemDesc"),",",i)
		s newObj.Type=$p(inParam("ItemType"),",",i)
		//s newObj.LinkDimType=$p(inParam("DimType"),",",i)
		s newObj.LinkDimCode=$p(inParam("DimCode"),",",i)
		s sc=newObj.%Save()
		If $$$ISERR(sc) {
			s ret="更新统计项失败:"_$System.Status.GetErrorText(sc)
			q
	 	}
	 	d newObj.%Close()
	}

	q ret
	
SQLErr
	if ret="" s ret="更新统计项失败:未知错误!"
	q ret
}

ClassMethod UpdateCustom(ByRef inParam, ByRef outParam) As %String
{
	s $zt="SQLErr"
	s ret=""	
	s ItemID=inParam("ItemID")
	s newObj=##class(DHCWL.BaseDataQuery.Item).%OpenId(ItemID)
	s newObj.Descript=inParam("ItemDesc")
	s newObj.FunPara=inParam("FunPara")
	s sc=newObj.%Save()
	If $$$ISERR(sc) {
		s ret="更新统计项失败:"_$System.Status.GetErrorText(sc)
		q
 	}
 	d newObj.%Close()


	q ret
	
SQLErr
	if ret="" s ret="更新统计项失败:未知错误!"
	q ret
}

ClassMethod DelCustom(ByRef inParam, ByRef outParam) As %String
{
	s $zt="SQLErr"
	s ret=""	
	s ItemID=inParam("itemID")
	Set sc = ##class(DHCWL.BaseDataQuery.Item).%DeleteId(ItemID)	
	If $$$ISERR(sc) {
		s ret="更新统计项失败:"_$System.Status.GetErrorText(sc)
		q
 	}
	q ret
	
SQLErr
	if ret="" s ret="更新统计项失败:未知错误!"
	q ret
}

Storage Default
{
<Data name="ItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>QueryObjName</Value>
</Value>
<Value name="3">
<Value>Descript</Value>
</Value>
<Value name="4">
<Value>Name</Value>
</Value>
<Value name="5">
<Value>Type</Value>
</Value>
<Value name="6">
<Value>LinkDimType</Value>
</Value>
<Value name="7">
<Value>LinkDimCode</Value>
</Value>
<Value name="8">
<Value>PiecePos</Value>
</Value>
<Value name="9">
<Value>ColType</Value>
</Value>
<Value name="10">
<Value>SubType</Value>
</Value>
<Value name="11">
<Value>FunPara</Value>
</Value>
</Data>
<DataLocation>^DHCWL.BaseDataQuery.ItemD</DataLocation>
<DefaultData>ItemDefaultData</DefaultData>
<IdLocation>^DHCWL.BaseDataQuery.ItemD</IdLocation>
<IndexLocation>^DHCWL.BaseDataQuery.ItemI</IndexLocation>
<StreamLocation>^DHCWL.BaseDataQuery.ItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
