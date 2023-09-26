/// 质控对比项目
Class dbo.BTQCComparisonTestCode Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTQC_ComparisonTestCode ]
{

Index IndexMaster On (ComparisonTestDR, TestCodeDR) [ SqlName = Index_Master, Type = index, Unique ];

/// Foreign Key FKBTQCComparisonTestCodeComparisonTestDR created via DDL
ForeignKey FKBTQCComparisonTestCodeComparisonTestDR(ComparisonTestDR) References dbo.BTQCComparisonTest(PKBTQCCOMPARISONTEST) [ SqlName = FK_BTQCComparisonTestCodeComparisonTestDR ];

/// Foreign Key FKBTQCComparisonTestCodeTestCodeDR created via DDL
ForeignKey FKBTQCComparisonTestCodeTestCodeDR(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_BTQCComparisonTestCodeTestCodeDR ];

/// DDL Primary Key Specification
Index PKBTQCCOMPARISONTESTCODE On RowID [ PrimaryKey, SqlName = PK_BTQC_COMPARISONTESTCODE, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 质控  
Property ComparisonTestDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 项目  
Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 参照  
Property Refer As %Library.Float [ SqlColumnNumber = 5 ];

/// 序号  
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 激活  {1:true,0:false}
Property Active As %Library.Boolean [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="BTQCComparisonTestCodeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ComparisonTestDR</Value>
</Value>
<Value name="3">
<Value>TestCodeDR</Value>
</Value>
<Value name="4">
<Value>Refer</Value>
</Value>
<Value name="5">
<Value>Sequence</Value>
</Value>
<Value name="6">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BTQCComparisonTestCodeD</DataLocation>
<DefaultData>BTQCComparisonTestCodeDefaultData</DefaultData>
<IdLocation>^dbo.BTQCComparisonTestCodeD</IdLocation>
<IndexLocation>^dbo.BTQCComparisonTestCodeI</IndexLocation>
<StreamLocation>^dbo.BTQCComparisonTestCodeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
