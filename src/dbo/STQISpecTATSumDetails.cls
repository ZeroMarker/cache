Class dbo.STQISpecTATSumDetails Extends %Persistent [ Owner = {UnknownUser}, SqlTableName = ST_QISpecTATSumDetails ]
{

/// Foreign Key FKRPVisitNumberTCRepeatBTTestCode created via DDL
ForeignKey FKSTQISpecTATSumDetailsSTQISpecTATSum(TATSumDR) References dbo.STQISpecTATSum(PKSTQISpecTATSum) [ SqlName = FK_ST_QISpecTATSumDetails_ST_QISpecTATSum ];

Index IndexMaster On (TATSumDR, VisitNumberDR) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKSTQISpecTATSumDetails On RowID [ PrimaryKey, SqlName = PK_ST_QISpecTATSumDetails, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 999999999999999999, MINVAL = -999999999999999999) [ Identity, Required, SqlColumnNumber = 2 ];

Property TATSumDR As %Library.Integer(MAXVAL = 999999999999999999, MINVAL = -999999999999999999) [ SqlColumnNumber = 3 ];

Property VisitNumberDR As %Library.Integer(MAXVAL = 999999999999999999, MINVAL = -999999999999999999) [ Required, SqlColumnNumber = 4 ];

Storage Default
{
<Data name="STQISpecTATSumDetailsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TATSumDR</Value>
</Value>
<Value name="3">
<Value>ReportDR</Value>
</Value>
<Value name="4">
<Value>VisitNumberDR</Value>
</Value>
</Data>
<DataLocation>^dbo.STQISpecTATSumDetailsD</DataLocation>
<DefaultData>STQISpecTATSumDetailsDefaultData</DefaultData>
<IdLocation>^dbo.STQISpecTATSumDetailsD</IdLocation>
<IndexLocation>^dbo.STQISpecTATSumDetailsI</IndexLocation>
<StreamLocation>^dbo.STQISpecTATSumDetailsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
