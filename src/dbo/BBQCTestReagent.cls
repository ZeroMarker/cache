/// 输血质控 检测试剂
Class dbo.BBQCTestReagent Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BBQC_TestReagent ]
{

/// Foreign Key FKBBQCTestReagentTestItemDR created via DDL
ForeignKey FKBBQCTestReagentTestItemDR(TestItemDR) References dbo.BBQCTestItem(PKBBQCTESTITEM) [ SqlName = FK_BBQCTestReagentTestItemDR ];

/// Foreign Key FKBBQCTestReagentTestCodeDR created via DDL
ForeignKey FKBBQCTestReagentTestCodeDR(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_BBQCTestReagentTestCodeDR ];

/// DDL Primary Key Specification
Index PKBBQCTESTREAGENT On RowID [ PrimaryKey, SqlName = PK_BBQC_TESTREAGENT, Type = index, Unique ];

Index IndexCode On Code [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSequence On Sequence [ SqlName = Index_Sequence, Type = index ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 代码  
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

/// 名称  
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ Required, SqlColumnNumber = 4 ];

/// 检测项目  
Property TestItemDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

/// 检测项目  
Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 序号  
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 激活  {1:true,0:false}
Property Active As %Library.Boolean [ SqlColumnNumber = 8 ];

Storage Default
{
<Data name="BBQCTestReagentDefaultData">
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
<Value>TestItemDR</Value>
</Value>
<Value name="5">
<Value>TestCodeDR</Value>
</Value>
<Value name="6">
<Value>Sequence</Value>
</Value>
<Value name="7">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BBQCTestReagentD</DataLocation>
<DefaultData>BBQCTestReagentDefaultData</DefaultData>
<IdLocation>^dbo.BBQCTestReagentD</IdLocation>
<IndexLocation>^dbo.BBQCTestReagentI</IndexLocation>
<StreamLocation>^dbo.BBQCTestReagentS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
