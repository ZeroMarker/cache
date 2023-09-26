/// BTCheckValidTestCode
Class dbo.BTCheckValidTestCode Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_CheckValidTestCode, StorageStrategy = Default ]
{

/// Foreign Key FKCCheckValidTestCode created via DDL
ForeignKey FKCheckValidTestCode(CheckValidRulesDR) References dbo.BTCheckValidRules(PKBTCHECKVALIDRULES) [ SqlName = FK_CheckValidTestCode ];

/// Foreign Key FKCheckValidTestCodeTestCode created via DDL
ForeignKey FKBTCheckValidTestCodeTestCode(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_CheckValidTestCodeTestCode ];

Index IndexDataMaster On (CheckValidRulesDR, TestCodeDR) [ SqlName = Index_DataMaster, Type = index, Unique ];

Index IndexTestCode On (TestCodeDR, CheckValidRulesDR) [ SqlName = Index_TestCode, Type = index ];

/// DDL Primary Key Specification
Index PKBTCHECKVALIDTESTCODE On RowID [ PrimaryKey, SqlName = PK_BT_CHECKVALIDTESTCODE, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

/// 自动审核项目  
Property CheckValidRulesDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 检测项目  
Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Storage Default
{
<Data name="BTCheckValidTestCodeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CheckValidRulesDR</Value>
</Value>
<Value name="3">
<Value>TestCodeDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BTCheckValidTestCodeD</DataLocation>
<DefaultData>BTCheckValidTestCodeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTCheckValidTestCodeD</IdLocation>
<IndexLocation>^dbo.BTCheckValidTestCodeI</IndexLocation>
<StreamLocation>^dbo.BTCheckValidTestCodeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
