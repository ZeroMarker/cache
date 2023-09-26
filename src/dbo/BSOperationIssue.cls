/// 手术用血信息汇总
Class dbo.BSOperationIssue Extends (%Persistent, %XML.Adaptor) [ Owner = {UnknownUser}, SqlTableName = BS_OperationIssue ]
{

/// Foreign Key created via DDL
ForeignKey FKTAT(BSBSOperationDR) References dbo.BSOperation(PKBSOperationId) [ SqlName = FK_BSOperationDR ];

Index IndexMaster On (BSBSOperationDR, IssueDR, PackDR) [ SqlName = Index_Master, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property BSBSOperationDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 3 ];

///  发血单号
Property IssueDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

///  血袋ID
Property PackDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

///  血液制品
Property ProductDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

///  血液制品
Property BloodCompontDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

///  血液制品
Property Volume As %Library.Float(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 8 ];

Storage Default
{
<Data name="BSOperationIssueDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BSBSOperationDR</Value>
</Value>
<Value name="3">
<Value>IssueDR</Value>
</Value>
<Value name="4">
<Value>PackDR</Value>
</Value>
<Value name="5">
<Value>ProductDR</Value>
</Value>
<Value name="6">
<Value>BloodCompontDR</Value>
</Value>
<Value name="7">
<Value>Volume</Value>
</Value>
</Data>
<DataLocation>^dbo.BSOperationIssueD</DataLocation>
<DefaultData>BSOperationIssueDefaultData</DefaultData>
<IdLocation>^dbo.BSOperationIssueD</IdLocation>
<IndexLocation>^dbo.BSOperationIssueI</IndexLocation>
<StreamLocation>^dbo.BSOperationIssueS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
