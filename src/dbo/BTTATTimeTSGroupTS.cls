Class dbo.BTTATTimeTSGroupTS Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_TATTimeTSGroupTS ]
{

Index IndexMaster On (TATTimeTSGroupDR, TestSetDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexTestSet On (TestSetDR, TATTimeTSGroupDR) [ SqlName = Index_TestSet, Type = index ];

Index IndexSequence On (TATTimeTSGroupDR, Sequence) [ SqlName = Index_Sequence, Type = index ];

/// Foreign Key FKBTTATTimeTSGroupTSTS created via DDL
ForeignKey FKBTTATTimeTSGroupTSTS(TestSetDR) References dbo.BTTestSet(PKBTTESTSET) [ SqlName = FK_BTTATTimeTSGroupTSTS ];

/// Foreign Key FKBTTATTimeTSGroupTSTSGroup created via DDL
ForeignKey FKBTTATTimeTSGroupTSTSGroup(TATTimeTSGroupDR) References dbo.BTTATTimeTSGroup(PKBTTATTIMETSGROUP) [ SqlName = FK_BTTATTimeTSGroupTSTSGroup ];

/// DDL Primary Key BTTATTimeTSGroupTime
Index PKBTTATTIMETSGROUPTS On RowID [ PrimaryKey, SqlName = PK_BT_TATTIMETSGROUPTS, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

/// TAT完成时医嘱分组  
Property TATTimeTSGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 医嘱  
Property TestSetDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 序号  
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Storage Default
{
<Data name="BTTATTimeTSGroupTSDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TATTimeTSGroupDR</Value>
</Value>
<Value name="3">
<Value>TestSetDR</Value>
</Value>
<Value name="4">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^dbo.BTTATTimeTSGroupTSD</DataLocation>
<DefaultData>BTTATTimeTSGroupTSDefaultData</DefaultData>
<IdLocation>^dbo.BTTATTimeTSGroupTSD</IdLocation>
<IndexLocation>^dbo.BTTATTimeTSGroupTSI</IndexLocation>
<StreamLocation>^dbo.BTTATTimeTSGroupTSS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
