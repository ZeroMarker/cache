Class dbo.BTRUTestSet Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTRU_TestSet, StorageStrategy = Default ]
{

/// DDL Primary Key Specification
Index PKBTRUTestSet On RowID [ PrimaryKey, SqlName = PK_BTRU_TestSet, Type = index, Unique ];

Index IndexCode On Code [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSequence On HISCode [ SqlName = Index_HISCode, Type = index ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 项目组合套Code  
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 3 ];

/// 序号(HIS对照码) 
Property HISCode As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 4 ];

/// 名称  
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 5 ];

/// 禁忌症  
Property Codeication As %Library.String(COLLATION = "Exact", MAXLEN = 65536) [ SqlColumnNumber = 6 ];

/// 相互作用  
Property Interact As %Library.String(COLLATION = "Exact", MAXLEN = 65536) [ SqlColumnNumber = 7 ];

/// 临床意义  
Property ClinicalSign As %Library.String(COLLATION = "Exact", MAXLEN = 65536) [ SqlColumnNumber = 8 ];

/// 注意事项  
Property Notes As %Library.String(COLLATION = "Exact", MAXLEN = 65536) [ SqlColumnNumber = 9 ];

/// 适应症  
Property Indication As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 10 ];

/// 激活  {1:true,0:false}
Property Active As %Library.Boolean [ SqlColumnNumber = 11 ];

/// 序号
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

Storage Default
{
<Data name="BTRUTestSetDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>HISCode</Value>
</Value>
<Value name="4">
<Value>CName</Value>
</Value>
<Value name="5">
<Value>Codeication</Value>
</Value>
<Value name="6">
<Value>Interact</Value>
</Value>
<Value name="7">
<Value>ClinicalSign</Value>
</Value>
<Value name="8">
<Value>Notes</Value>
</Value>
<Value name="9">
<Value>Indication</Value>
</Value>
<Value name="10">
<Value>Active</Value>
</Value>
<Value name="11">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^dbo.BTRUTestSetD</DataLocation>
<DefaultData>BTRUTestSetDefaultData</DefaultData>
<IdLocation>^dbo.BTRUTestSetD</IdLocation>
<IndexLocation>^dbo.BTRUTestSetI</IndexLocation>
<StreamLocation>^dbo.BTRUTestSetS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
