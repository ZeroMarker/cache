/// 汇总发血明细
Class dbo.BSIssueRecordItem Extends %Persistent [ Owner = {UnknownUser}, SqlTableName = BS_IssueRecordItem ]
{

/// Foreign Key created via DDL
ForeignKey FKTAT(BSIssueRecordDR) References dbo.BSIssueRecord(PKIssueRecordId) [ SqlName = FK_BLD_CT_REQ_Detalis_BLDRequestDR ];

Index IndexMaster On (BSIssueRecordDR, PackDR) [ SqlName = Index_Master, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property BSIssueRecordDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 3 ];

///  血液制品
Property PackDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Storage Default
{
<Data name="BSIssueRecordItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BSIssueRecordDR</Value>
</Value>
<Value name="3">
<Value>PackDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BSIssueRecordItemD</DataLocation>
<DefaultData>BSIssueRecordItemDefaultData</DefaultData>
<IdLocation>^dbo.BSIssueRecordItemD</IdLocation>
<IndexLocation>^dbo.BSIssueRecordItemI</IndexLocation>
<StreamLocation>^dbo.BSIssueRecordItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
