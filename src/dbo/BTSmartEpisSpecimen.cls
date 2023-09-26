/// 排样规则关联标本类型 表
Class dbo.BTSmartEpisSpecimen Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_SmartEpisSpecimen ]
{

/// Foreign Key FKBTSmartEpisSpecimenBTSpecimen created via DDL
ForeignKey FKBTSmartEpisSpecimenBTSpecimen(SpecimenDR) References dbo.BTSpecimen(PKBTSPECIMEN) [ SqlName = FK_BTSmartEpisSpecimenBTSpecimen ];

/// Foreign Key FKBTSmartEpisSpecimenBTSmartEpis created via DDL
ForeignKey FKBTSmartEpisSpecimenBTSmartEpis(SmartEpisDR) References dbo.BTSmartEpis(PKBTSmartEpis) [ SqlName = FK_BTSmartEpisSpecimenBTSmartEpis ];

Index IndexMaster On (SmartEpisDR, SpecimenDR) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTSmartEpisSpecimen On RowID [ PrimaryKey, SqlName = PK_BT_SmartEpisSpecimen, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 流水号规则
Property SmartEpisDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 标本
Property SpecimenDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Storage Default
{
<Data name="BTSmartEpisSpecimenDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SmartEpisDR</Value>
</Value>
<Value name="3">
<Value>SpecimenDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BTSmartEpisSpecimenD</DataLocation>
<DefaultData>BTSmartEpisSpecimenDefaultData</DefaultData>
<IdLocation>^dbo.BTSmartEpisSpecimenD</IdLocation>
<IndexLocation>^dbo.BTSmartEpisSpecimenI</IndexLocation>
<StreamLocation>^dbo.BTSmartEpisSpecimenS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
