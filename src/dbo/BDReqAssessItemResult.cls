Class dbo.BDReqAssessItemResult Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_ReqAssessItemResult ]
{

/// Foreign Key FKBDRFIRReqForm created via DDL
ForeignKey FKBDRAIReqAssess(ReqAssessDR) References dbo.BDReqAssess(PKBDREQASSESS) [ SqlName = FK_BD_RAI_ReqAssess ];

/// Foreign Key FKBDRFIRResultUser created via DDL
ForeignKey FKBDRAIResultUser(ResultUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_RAI_ResultUser ];

/// Foreign Key FKBDRFIRTestItem created via DDL
ForeignKey FKBDRAITestItem(TestItemDR) References dbo.BBTestItem(PKBBTESTITEM) [ SqlName = FK_BD_RAI_TestItem ];

Index IndexMaster On (ReqAssessDR, TestItemDR) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBDREQASSESSITEMRESULT On RowID [ PrimaryKey, SqlName = PK_BD_REQASSESSITEMRESULT, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property ReqAssessDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property TestItemDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

Property Result As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 5 ];

Property Unit As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 6 ];

Property RefRanges As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 7 ];

Property ResultDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Property ResultTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Property ResultUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

Property AbFlag As %Library.String(COLLATION = "Exact", MAXLEN = 5) [ SqlColumnNumber = 12 ];

Property TestItemGroup As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 13 ];

Storage Default
{
<Data name="BDReqAssessItemResultDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ReqAssessDR</Value>
</Value>
<Value name="3">
<Value>TestItemDR</Value>
</Value>
<Value name="4">
<Value>Result</Value>
</Value>
<Value name="5">
<Value>Unit</Value>
</Value>
<Value name="6">
<Value>RefRanges</Value>
</Value>
<Value name="7">
<Value>ResultDate</Value>
</Value>
<Value name="8">
<Value>ResultTime</Value>
</Value>
<Value name="9">
<Value>ResultUserDR</Value>
</Value>
<Value name="10">
<Value>SeqNum</Value>
</Value>
<Value name="11">
<Value>AbFlag</Value>
</Value>
<Value name="12">
<Value>TestItemGroup</Value>
</Value>
</Data>
<DataLocation>^dbo.BDReqAssessItemResultD</DataLocation>
<DefaultData>BDReqAssessItemResultDefaultData</DefaultData>
<IdLocation>^dbo.BDReqAssessItemResultD</IdLocation>
<IndexLocation>^dbo.BDReqAssessItemResultI</IndexLocation>
<StreamLocation>^dbo.BDReqAssessItemResultS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
