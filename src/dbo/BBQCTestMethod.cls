/// 输血质控 检测方法
Class dbo.BBQCTestMethod Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BBQC_TestMethod ]
{

/// DDL Primary Key Specification
Index PKBBQCTESTMETHOD On RowID [ PrimaryKey, SqlName = PK_BBQC_TESTMETHOD, Type = index, Unique ];

Index IndexCode On Code [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSequence On Sequence [ SqlName = Index_Sequence, Type = index ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 代码  
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

/// 名称  
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ Required, SqlColumnNumber = 4 ];

/// 序号  
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

/// 激活  {1:true,0:false}
Property Active As %Library.Boolean [ SqlColumnNumber = 6 ];

Storage Default
{
<Data name="BBQCTestMethodDefaultData">
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
<Value>Sequence</Value>
</Value>
<Value name="5">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BBQCTestMethodD</DataLocation>
<DefaultData>BBQCTestMethodDefaultData</DefaultData>
<IdLocation>^dbo.BBQCTestMethodD</IdLocation>
<IndexLocation>^dbo.BBQCTestMethodI</IndexLocation>
<StreamLocation>^dbo.BBQCTestMethodS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
