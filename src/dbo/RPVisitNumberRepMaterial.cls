Class dbo.RPVisitNumberRepMaterial Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_VisitNumberRepMaterial ]
{

/// Foreign Key FKVisitNumberReport created via DDL
ForeignKey FKVisitNumberReport(VisitNumberReportDR) References dbo.RPVisitNumberReport(PKRPVISITNUMBERREPORT) [ SqlName = FK_VisitNumberReport ];

/// Foreign Key FKTestCode created via DDL
ForeignKey FKTestCode(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_TestCode ];

/// Foreign Key FKAuthUserDR created via DDL
ForeignKey FKAuthUserDR(AuthUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_AuthUserDR ];

Index IndexMaster On (VisitNumberReportDR, TestCodeDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexTCSequence On (VisitNumberReportDR, Sequence, TestCodeDR) [ SqlName = Index_TCSequence, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKRPVISITNUMBERREPORTMATERIAL On RowID [ PrimaryKey, SqlName = PK_RP_VISITNUMBERREPORTMATERIAL, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property VisitNumberReportDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property MatralNotes As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 5 ];

Property AuthUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property AuthDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Property AuthTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Storage Default
{
<Data name="RPVisitNumberRepMaterialDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>VisitNumberReportDR</Value>
</Value>
<Value name="3">
<Value>TestCodeDR</Value>
</Value>
<Value name="4">
<Value>MatralNotes</Value>
</Value>
<Value name="5">
<Value>AuthUserDR</Value>
</Value>
<Value name="6">
<Value>AuthDate</Value>
</Value>
<Value name="7">
<Value>AuthTime</Value>
</Value>
<Value name="8">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^dbo.RPVisitNumberRepMaterialD</DataLocation>
<DefaultData>RPVisitNumberRepMaterialDefaultData</DefaultData>
<IdLocation>^dbo.RPVisitNumberRepMaterialD</IdLocation>
<IndexLocation>^dbo.RPVisitNumberRepMaterialI</IndexLocation>
<StreamLocation>^dbo.RPVisitNumberRepMaterialS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
