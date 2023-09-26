Class CT.PHA.IN.KPIDefinition Extends (%Persistent, User.Abstract) [ SqlRowIdName = Def_RowID, SqlTableName = KPIDefinition, StorageStrategy = ObjStorage ]
{

Relationship ChildDefDim As CT.PHA.IN.KPIDefDim [ Cardinality = children, Inverse = DefdParref ];

/// 代码
Property DefCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = Def_Code ];

/// 描述
Property DefDesc As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = Def_Desc ];

/// 执行代码
Property DefExeCode As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = Def_ExeCode ];

/// 数据节点
Property DefDataNod As %String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = Def_DataNod ];

/// 备注
Property DefRemark As %String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = Def_Remark ];

/// 创建日期
Property DefUpdateDate As %Date [ SqlColumnNumber = 7, SqlFieldName = Def_UpdateDate ];

Index CodeI On DefCode As Exact;

Index DescI On DefDesc As Exact;

Storage ObjStorage
{
<Data name="KPIDefinitionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DefCode</Value>
</Value>
<Value name="3">
<Value>DefDesc</Value>
</Value>
<Value name="4">
<Value>DefExeCode</Value>
</Value>
<Value name="5">
<Value>DefDataNod</Value>
</Value>
<Value name="6">
<Value>DefRemark</Value>
</Value>
<Value name="7">
<Value>DefUpdateDate</Value>
</Value>
</Data>
<DataLocation>^CT.PHA.IN.KPIDefD</DataLocation>
<DefaultData>KPIDefinitionDefaultData</DefaultData>
<IdLocation>^CT.PHA.IN.KPIDefD</IdLocation>
<IndexLocation>^CT.PHA.IN.KPIDefI</IndexLocation>
<StreamLocation>^CT.PHA.IN.KPIDefS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
