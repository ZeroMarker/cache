/// / websys.MenuGroup
Class ext.websys.MenuGroup Extends (%Persistent, ext.websys.Abstract) [ Inheritance = right, Owner = {_SYSTEM} ]
{

Parameter MAJORVERSION;

Parameter MINORVERSION;

Parameter SQLFILTER;

Parameter BUILD = 54;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "ID";

Parameter SQLDESCRIPTION = "ID";

Parameter SQLROWID = "ID";

// 显示菜单

ClassMethod ShowBar(id As %String) As %Library.String
{
	d ##Class(websys.MenuGroup).ShowBar(id)
}

/// Rebuild menugroup items from a set of delimited strings.
Method MenuItemsAdd(ids As %Library.String = "") As %Library.String
{
}

/// return list of menugroupitem's menu id in sequence order
Method MenuItemsGet() As %Library.String
{
}

ClassMethod MenuType(id As %String) As %Library.String
{
}

Storage Default
{
<Data name="MenuGroupDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^ext.websys.MenuGroupD</DataLocation>
<DefaultData>MenuGroupDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^ext.websys.MenuGroupD</IdLocation>
<IndexLocation>^ext.websys.MenuGroupI</IndexLocation>
<StreamLocation>^ext.websys.MenuGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
