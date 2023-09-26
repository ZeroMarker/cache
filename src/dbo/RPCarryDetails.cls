///     
Class dbo.RPCarryDetails Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_CarryDetails, StorageStrategy = Default ]
{

/// Foreign Key FKCarryDetails created via DDL
ForeignKey FKCarryDetails(CarryDR) References dbo.RPCarry(PKRPCARRY) [ SqlName = FK_CarryDetails ];

/// Foreign Key FKCarryDetailsUser created via DDL
ForeignKey FKCarryDetailsUser(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_CarryDetailsUser ];

/// Foreign Key FKCarryDetailsVisitNumber created via DDL
ForeignKey FKCarryDetailsVisitNumber(VisitNumberDR) References dbo.RPVisitNumber(PKRPVISITNUMBER) [ SqlName = FK_CarryDetailsVisitNumber ];

/// Foreign Key FKCarryDetailsVisitNumber created via DDL
ForeignKey FKCarryDetailsPack(PackDR) References dbo.BDPack(PKBDPACK) [ SqlName = FK_CarryDetailsPack ];

Index IndexMaster On (CarryDR, OrderNo) [ SqlName = Index_Master, Type = index ];

Index IndexVisitNumber On VisitNumberDR [ SqlName = Index_VisitNumber, Type = index ];

Index IndexPackDR On PackDR [ SqlName = Index_PackDR, Type = index ];

/// DDL Primary Key Specification
Index PKRPCARRYDETAILS On RowID [ PrimaryKey, SqlName = PK_RP_CARRYDETAILS, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property CarryDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property OrderNo As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property VisitNumberDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Property PackDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property Status As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 7 ];

Property Notes As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 8 ];

Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

Property ReceiveDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

Property ReceiveTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

Property ReceiveUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

Property TestSetDesc As %Library.String(COLLATION = "Exact", MAXLEN = 300) [ SqlColumnNumber = 15 ];

Storage Default
{
<Data name="RPCarryDetailsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CarryDR</Value>
</Value>
<Value name="3">
<Value>OrderNo</Value>
</Value>
<Value name="4">
<Value>VisitNumberDR</Value>
</Value>
<Value name="5">
<Value>PackDR</Value>
</Value>
<Value name="6">
<Value>Status</Value>
</Value>
<Value name="7">
<Value>Notes</Value>
</Value>
<Value name="8">
<Value>AddDate</Value>
</Value>
<Value name="9">
<Value>AddTime</Value>
</Value>
<Value name="10">
<Value>AddUserDR</Value>
</Value>
<Value name="11">
<Value>ReceiveDate</Value>
</Value>
<Value name="12">
<Value>ReceiveTime</Value>
</Value>
<Value name="13">
<Value>ReceiveUserDR</Value>
</Value>
<Value name="14">
<Value>TestSetDesc</Value>
</Value>
</Data>
<DataLocation>^dbo.RPCarryDetailsD</DataLocation>
<DefaultData>RPCarryDetailsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.RPCarryDetailsD</IdLocation>
<IndexLocation>^dbo.RPCarryDetailsI</IndexLocation>
<StreamLocation>^dbo.RPCarryDetailsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
