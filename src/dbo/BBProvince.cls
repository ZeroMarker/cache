/// 省份
/// 
Class dbo.BBProvince Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_Province ]
{

/// DDL Primary Key Specification
Index PKBBPROVINCE On RowID [ PrimaryKey, SqlName = PK_BB_PROVINCE, Type = index, Unique ];

Index IndexMaster On Code [ SqlName = Index_Master, Type = index, Unique ];

Index IndexSequence On Sequence [ SqlName = Index_Sequence, Type = index ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ Required, SqlColumnNumber = 4 ];

Property SName As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 5 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="BBProvinceDefaultData">
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
<Value>SName</Value>
</Value>
<Value name="5">
<Value>Sequence</Value>
</Value>
<Value name="6">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BBProvinceD</DataLocation>
<DefaultData>BBProvinceDefaultData</DefaultData>
<IdLocation>^dbo.BBProvinceD</IdLocation>
<IndexLocation>^dbo.BBProvinceI</IndexLocation>
<StreamLocation>^dbo.BBProvinceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
