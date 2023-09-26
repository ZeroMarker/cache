Class dhc.bonus.module.WorkItemType Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = WorkItemTypeID ]
{

//项类别编码

Property ItemTypeCode As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = ItemTypeCode ];

//项目类别名称

Property ItemTypeName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ItemTypeName ];

Storage Default
{
<Data name="WorkItemTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ItemTypeCode</Value>
</Value>
<Value name="3">
<Value>ItemTypeName</Value>
</Value>
</Data>
<DataLocation>^dhcbsmdWorkItemTypeD</DataLocation>
<DefaultData>WorkItemTypeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsmdWorkItemTypeD</IdLocation>
<IndexLocation>^dhcbsmdWorkItemTypeI</IndexLocation>
<SQLMap name="indexcode">
<Global>^DHCItemTypeCode</Global>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexname">
<Global>^DHCItemTypeName</Global>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhcbsmdWorkItemTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
