///     
Class dbo.BDSendCostLog Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_SendCostLog, StorageStrategy = Default ]
{

/// Foreign Key FKBDSCLogSendCost created via DDL
ForeignKey FKBDSCLogSendCost(SendCostDR) References dbo.BDSendCost(PKBDSENDCOST) [ SqlName = FK_BD_SCLog_SendCost ];

Index IndexSendCost On SendCostDR [ SqlName = Index_SendCost, Type = index ];

Index IndexSendDate On SendDate [ SqlName = Index_SendDate, Type = index ];

/// DDL Primary Key Specification
Index PKBDSENDCOSTLOG On RowID [ PrimaryKey, SqlName = PK_BD_SENDCOSTLOG, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property SendCostDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property SendDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property SendTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property ReturnResult As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 6 ];

Storage Default
{
<Data name="BDSendCostLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SendCostDR</Value>
</Value>
<Value name="3">
<Value>SendDate</Value>
</Value>
<Value name="4">
<Value>SendTime</Value>
</Value>
<Value name="5">
<Value>ReturnResult</Value>
</Value>
</Data>
<DataLocation>^dbo.BDSendCostLogD</DataLocation>
<DefaultData>BDSendCostLogDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BDSendCostLogD</IdLocation>
<IndexLocation>^dbo.BDSendCostLogI</IndexLocation>
<StreamLocation>^dbo.BDSendCostLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
