///     
Class dbo.BDPackCheckResult Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_PackCheckResult, StorageStrategy = Default ]
{

/// DDL Primary Key Specification
Index IndexMaster On (PackDR, PackCheckItemDR) [ PrimaryKey, SqlName = Index_Master, Type = index, Unique ];

/// DDL   
Index IndexSeqNum On (PackDR, SeqNum) [ SqlName = Index_SeqNum, Type = index ];

/// Foreign Key FKBDPackCheckResultBBPackCheckItems created via DDL
ForeignKey FKBDPackCheckResultBBPackCheckItems(PackCheckItemDR) References dbo.BBPackCheckItems(PKBBPACKCHECKITEMS) [ SqlName = FK_CheckResult_CheckItems ];

/// Foreign Key FKCheckResultPack created via DDL
ForeignKey FKCheckResultPack(PackDR) References dbo.BDPack(PKBDPACK) [ SqlName = FK_CheckResult_Pack ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property PackDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property PackCheckItemDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property Result As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 5 ];

Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Storage Default
{
<Data name="BDPackCheckResultDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PackDR</Value>
</Value>
<Value name="3">
<Value>PackCheckItemDR</Value>
</Value>
<Value name="4">
<Value>Result</Value>
</Value>
<Value name="5">
<Value>SeqNum</Value>
</Value>
</Data>
<DataLocation>^dbo.BDPackCheckResultD</DataLocation>
<DefaultData>BDPackCheckResultDefaultData</DefaultData>
<IdLocation>^dbo.BDPackCheckResultD</IdLocation>
<IndexLocation>^dbo.BDPackCheckResultI</IndexLocation>
<StreamLocation>^dbo.BDPackCheckResultS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
