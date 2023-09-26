/// 电子病历综合查询配置项目类型表(比如字符、数字等，暂时保留)
Class EPRmeta.Query.QueryItemType Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 项目名称唯一索引
Index IdxName On Name [ Unique ];

/// 项目代码唯一索引
Index IdxCode On Code [ Unique ];

Property Name As %String(TRUNCATE = 1) [ Required ];

Property Code As %String(TRUNCATE = 1) [ Required ];

Property IsActive As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N");

Property Remark As %String(MAXLEN = 200, TRUNCATE = 1);

Storage Default
{
<Data name="QueryItemTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>IsActive</Value>
</Value>
<Value name="5">
<Value>Remark</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.QueryItemTypeD</DataLocation>
<DefaultData>QueryItemTypeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.QueryItemTypeD</IdLocation>
<IndexLocation>^DHCEPRM.QueryItemTypeI</IndexLocation>
<StreamLocation>^DHCEPRM.QueryItemTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
