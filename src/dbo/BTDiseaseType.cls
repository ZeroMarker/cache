/// 疾病类型
Class dbo.BTDiseaseType Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_DiseaseType, StorageStrategy = Default ]
{

Index IndexType On (Type, Code) [ SqlName = Index_Type, Type = index ];

/// DDL Primary Key Specification
Index PKBTDiseaseType On RowID [ PrimaryKey, SqlName = PK_BT_DiseaseType, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

/// 代码  
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

/// 名称  
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ Required, SqlColumnNumber = 4 ];

/// 类型  
Property Type As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 名称代码  
Property SCode As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 6 ];

/// 序列  
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

Storage Default
{
<Data name="BTDiseaseTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>CName</Value>
</Value>
<Value name="4">
<Value>Type</Value>
</Value>
<Value name="5">
<Value>SCode</Value>
</Value>
<Value name="6">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^dbo.BTDiseaseTypeD</DataLocation>
<DefaultData>BTDiseaseTypeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTDiseaseTypeD</IdLocation>
<IndexLocation>^dbo.BTDiseaseTypeI</IndexLocation>
<StreamLocation>^dbo.BTDiseaseTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
