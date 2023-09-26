/// 排样规则关联组合套 表
Class dbo.BTSmartEpisTestSet Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_SmartEpisTestSet ]
{

/// Foreign Key FKBTSmartEpisTestSetBTSmartEpis created via DDL
ForeignKey FKBTSmartEpisTestSetBTTestSet(TestSetDR) References dbo.BTTestSet(PKBTTESTSET) [ SqlName = FK_BTSmartEpisTestSetBTTestSet ];

/// Foreign Key FKBTSmartEpisTestSetBTSmartEpis created via DDL
ForeignKey FKBTSmartEpisTestSetBTSmartEpis(SmartEpisDR) References dbo.BTSmartEpis(PKBTSmartEpis) [ SqlName = FK_BTSmartEpisTestSetBTSmartEpis ];

Index IndexMaster On (SmartEpisDR, TestSetDR) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTSmartEpisTestSet On RowID [ PrimaryKey, SqlName = PK_BT_SmartEpisTestSet, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 流水号规则
Property SmartEpisDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 医嘱
Property TestSetDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Storage Default
{
<Data name="BTSmartEpisTestSetDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SmartEpisDR</Value>
</Value>
<Value name="3">
<Value>TestSetDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BTSmartEpisTestSetD</DataLocation>
<DefaultData>BTSmartEpisTestSetDefaultData</DefaultData>
<IdLocation>^dbo.BTSmartEpisTestSetD</IdLocation>
<IndexLocation>^dbo.BTSmartEpisTestSetI</IndexLocation>
<StreamLocation>^dbo.BTSmartEpisTestSetS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
