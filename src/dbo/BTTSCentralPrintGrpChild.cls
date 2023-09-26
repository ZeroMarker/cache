///     
Class dbo.BTTSCentralPrintGrpChild Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_TSCentralPrintGrpChild ]
{

/// Foreign Key FKBTTSCentralPrintGrpChildTSCentralPrintGroupDR created via DDL
ForeignKey FKBTTSCentralPrintGrpChildTSCentralPrintGroupDR(TSCentralPrintGroupDR) References dbo.BTTSCentralPrintGroup(PKBTTSCENTRALPRINTGROUP) [ SqlName = FK_BTTSCentralPrintGrpChildTSCentralPrintGroupDR ];

/// Foreign Key FKBTTSCentralPrintGrpChildTestSetDR created via DDL
ForeignKey FKBTTSCentralPrintGrpChildTestSetDR(TestSetDR) References dbo.BTTestSet(PKBTTESTSET) [ SqlName = FK_BTTSCentralPrintGrpChildTestSetDR ];

/// DDL Primary Key Specification
Index PKBTTSCENTRALPRINTGRPCHILD On RowID [ PrimaryKey, SqlName = PK_BT_TSCENTRALPRINTGRPCHILD, Type = index, Unique ];

Index IndexMaster On (TestSetDR, TSCentralPrintGroupDR) [ SqlName = Index_Master, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property TSCentralPrintGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property TestSetDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Storage Default
{
<Data name="BTTSCentralPrintGrpChildDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TSCentralPrintGroupDR</Value>
</Value>
<Value name="3">
<Value>TestSetDR</Value>
</Value>
<Value name="4">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^dbo.BTTSCentralPrintGrpChildD</DataLocation>
<DefaultData>BTTSCentralPrintGrpChildDefaultData</DefaultData>
<IdLocation>^dbo.BTTSCentralPrintGrpChildD</IdLocation>
<IndexLocation>^dbo.BTTSCentralPrintGrpChildI</IndexLocation>
<StreamLocation>^dbo.BTTSCentralPrintGrpChildS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
