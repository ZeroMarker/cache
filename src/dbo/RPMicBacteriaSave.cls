Class dbo.RPMicBacteriaSave Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_MicBacteriaSave ]
{

Index IndexCode On Code [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSpecimenRack On (SpecimenRackDR, RowNum, ColNum) [ SqlName = Index_SpecimenRack, Type = index, Unique ];

Index IndexVisitNumber On VisitNumberDR [ SqlName = Index_VisitNumber, Type = index ];

Index IndexOrganism On OrganismDR [ SqlName = Index_Organism, Type = index ];

/// DDL Primary Key Specification
Index PKRPMICBACTERIASAVE On RowID [ PrimaryKey, SqlName = PK_RP_MICBACTERIASAVE, Type = index, Unique ];

/// Foreign Key FKOrganism created via DDL
ForeignKey FKOrganism(OrganismDR) References dbo.BTOrganism(PKBTORGANISM) [ SqlName = FK_Organism ];

/// Foreign Key FKVisitNumberReport created via DDL
ForeignKey FKVisitNumberReport(VisitNumberDR) References dbo.RPVisitNumber(PKRPVISITNUMBER) [ SqlName = FK_VisitNumberReport ];

/// Foreign Key FKSpecimenRack created via DDL
ForeignKey FKSpecimenRack(SpecimenRackDR) References dbo.BTSpecimenRack(PKBTSPECIMENRACK) [ SqlName = FK_SpecimenRack ];

/// Foreign Key FKAddUser created via DDL
ForeignKey FKAddUser(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_AddUser ];

/// Foreign Key FKUpdateUserDR created via DDL
ForeignKey FKUpdateUserDR(UpdateUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_UpdateUserDR ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ Required, SqlColumnNumber = 3 ];

Property OrganismDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

Property SpecimenRackDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Property VisitNumberDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property ColNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

Property RowNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 8 ];

Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

Property UpdateDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

Property UpdateTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

Property UpdateUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 15 ];

Storage Default
{
<Data name="RPMicBacteriaSaveDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>OrganismDR</Value>
</Value>
<Value name="4">
<Value>SpecimenRackDR</Value>
</Value>
<Value name="5">
<Value>VisitNumberDR</Value>
</Value>
<Value name="6">
<Value>ColNum</Value>
</Value>
<Value name="7">
<Value>RowNum</Value>
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
<Value>UpdateDate</Value>
</Value>
<Value name="12">
<Value>UpdateTime</Value>
</Value>
<Value name="13">
<Value>UpdateUserDR</Value>
</Value>
<Value name="14">
<Value>Remark</Value>
</Value>
</Data>
<DataLocation>^dbo.RPMicBacteriaSaveD</DataLocation>
<DefaultData>RPMicBacteriaSaveDefaultData</DefaultData>
<IdLocation>^dbo.RPMicBacteriaSaveD</IdLocation>
<IndexLocation>^dbo.RPMicBacteriaSaveI</IndexLocation>
<StreamLocation>^dbo.RPMicBacteriaSaveS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
