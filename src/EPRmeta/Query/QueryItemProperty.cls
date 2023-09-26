/// 临床信息综合查询项目属性表
Class EPRmeta.Query.QueryItemProperty Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Index IdxCategoryID On CategoryID;

/// 临床信息综合查询类别ID
Property CategoryID As %Integer [ Required ];

/// 属性代码，对应查询结果临时global中的节点名称
Property Code As %String(TRUNCATE = 1) [ Required ];

/// 属性名称
Property Name As %String(TRUNCATE = 1) [ Required ];

/// 是否默认选中
Property IsChecked As %String(TRUNCATE = 1) [ Required ];

/// 是否有效
Property IsActive As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N");

Storage Default
{
<Data name="QueryItemPropertyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CategoryID</Value>
</Value>
<Value name="3">
<Value>Code</Value>
</Value>
<Value name="4">
<Value>Name</Value>
</Value>
<Value name="5">
<Value>IsChecked</Value>
</Value>
<Value name="6">
<Value>IsActive</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.QueryItemPropertyD</DataLocation>
<DefaultData>QueryItemPropertyDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.QueryItemPropertyD</IdLocation>
<IndexLocation>^DHCEPRM.QueryItemPropertyI</IndexLocation>
<StreamLocation>^DHCEPRM.QueryItemPropertyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
