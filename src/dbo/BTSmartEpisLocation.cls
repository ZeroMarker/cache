/// 排样规则关联科室 表
Class dbo.BTSmartEpisLocation Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_SmartEpisLocation ]
{

/// Foreign Key FKBTSmartEpisLocationBTLocation created via DDL
ForeignKey FKBTSmartEpisLocationBTLocation(LocationDR) References dbo.BTLocation(PKBTLOCATION) [ SqlName = FK_BTSmartEpisLocationBTLocation ];

/// Foreign Key FKBTSmartEpisLocationBTSmartEpis created via DDL
ForeignKey FKBTSmartEpisLocationBTSmartEpis(SmartEpisDR) References dbo.BTSmartEpis(PKBTSmartEpis) [ SqlName = FK_BTSmartEpisLocationBTSmartEpis ];

Index IndexMaster On (SmartEpisDR, LocationDR) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTSmartEpisLocation On RowID [ PrimaryKey, SqlName = PK_BT_SmartEpisLocation, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 流水号规则
Property SmartEpisDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 申请科室
Property LocationDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Storage Default
{
<Data name="BTSmartEpisLocationDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SmartEpisDR</Value>
</Value>
<Value name="3">
<Value>LocationDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BTSmartEpisLocationD</DataLocation>
<DefaultData>BTSmartEpisLocationDefaultData</DefaultData>
<IdLocation>^dbo.BTSmartEpisLocationD</IdLocation>
<IndexLocation>^dbo.BTSmartEpisLocationI</IndexLocation>
<StreamLocation>^dbo.BTSmartEpisLocationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
