Class DHCWL.BaseDataQuery.QueryObj Extends %Persistent
{

/// 查询对象名称
Property BaseObjName As %String(COLLATION = "EXACT") [ Required ];

/// 查询对象描述
Property BaseObjDesc As %String(COLLATION = "EXACT");

/// 主题标识
Property ThemeBaseID As %String(COLLATION = "EXACT");

Index BaseObjNameIndex On BaseObjName [ PrimaryKey ];

/// s obj=##class(DHCWL.BaseDataQuery.QueryObj).GetIdByName(Name)
ClassMethod GetIdByName(Name)
{
	q:'$d(^DHCWL.BaseDataQuery.QueryObjI("BaseObjNameIndex",Name)) ""
	q $o(^DHCWL.BaseDataQuery.QueryObjI("BaseObjNameIndex",Name,""))
}

ClassMethod GetItems(QueryObjName) As %ListOfObjects
{
	s list=##class(%ListOfObjects).%New()
	q:QueryObjName="" list
	//QueryObjNameIndex On (QueryObjName, Name);

	q:'$d(^DHCWL.BaseDataQuery.ItemI("QueryObjNameIndex",QueryObjName)) list
	s itemName="" 
	f{
	  s itemName=$o(^DHCWL.BaseDataQuery.ItemI("QueryObjNameIndex",QueryObjName,itemName))
	  q:itemName=""
	  s id=$o(^DHCWL.BaseDataQuery.ItemI("QueryObjNameIndex",QueryObjName,itemName,""))
	  s obj=##class(DHCWL.BaseDataQuery.Item).%OpenId(id)
	  continue:obj=""
	  d list.Insert(obj)
	}
	q list
}

ClassMethod GetByName(Name) As QueryObj
{
	q ##class(QueryObj).%OpenId(##class(QueryObj).GetIdByName(Name))
}

ClassMethod Insert(ByRef inParam, ByRef outParam) As %String
{
	s $zt="SQLErr"
	s ret=""
	s newObj=##class(DHCWL.BaseDataQuery.QueryObj).%New()
	s newObj.BaseObjName=inParam("BaseObjName")
	s newObj.BaseObjDesc=inParam("BaseObjDesc")
	s newObj.ThemeBaseID=inParam("ThemeBaseID")
	s sc=newObj.%Save()
	If $$$ISERR(sc) {
		s ret="新建查询对象失败:"_$System.Status.GetErrorText(sc)
		q ret
 	}
	s inParam("ROWID")=newObj.%Id() 
	d newObj.%Close()
	q ret
SQLErr
	if ret="" s ret="新建查询对象失败:"_$ZERROR
	q ret
}

Storage Default
{
<Data name="QueryObjDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BaseObjName</Value>
</Value>
<Value name="3">
<Value>BaseObjDesc</Value>
</Value>
<Value name="4">
<Value>ThemeBaseID</Value>
</Value>
</Data>
<DataLocation>^DHCWL.BaseDataQuery.QueryObjD</DataLocation>
<DefaultData>QueryObjDefaultData</DefaultData>
<IdLocation>^DHCWL.BaseDataQuery.QueryObjD</IdLocation>
<IndexLocation>^DHCWL.BaseDataQuery.QueryObjI</IndexLocation>
<StreamLocation>^DHCWL.BaseDataQuery.QueryObjS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
