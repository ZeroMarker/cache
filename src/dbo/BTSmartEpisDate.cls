Class dbo.BTSmartEpisDate Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_SmartEpisDate ]
{

/// Foreign Key FKBTSmartEpisTestSetBTSmartEpis created via DDL
ForeignKey FKBTSmartEpisTestDateBTSmartEpis(SmartEpisDR) References dbo.BTSmartEpis(PKBTSmartEpis) [ SqlName = FK_BTSmartEpisTestDateBTSmartEpis ];

Index IndexMaster On (SmartEpisDR, WeekDay) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTSmartEpisTestDate On RowID [ PrimaryKey, SqlName = PK_BT_SmartEpisTestDate, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 流水号规则
Property SmartEpisDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 周 枚举数据{1：周1，2:周2，3:周3，4:周4，5:周5，6:周6，7:周7}
Property WeekDay As %TinyInt [ Required, SqlColumnNumber = 4 ];

/// 时间节点
Property TimePoint As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Storage Default
{
<Data name="BTSmartEpisDateDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SmartEpisDR</Value>
</Value>
<Value name="3">
<Value>WeekDay</Value>
</Value>
<Value name="4">
<Value>TimePoint</Value>
</Value>
</Data>
<DataLocation>^dbo.BTSmartEpisDateD</DataLocation>
<DefaultData>BTSmartEpisDateDefaultData</DefaultData>
<IdLocation>^dbo.BTSmartEpisDateD</IdLocation>
<IndexLocation>^dbo.BTSmartEpisDateI</IndexLocation>
<StreamLocation>^dbo.BTSmartEpisDateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
