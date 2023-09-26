///     
Class dbo.MCOrgIndentify Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = MC_OrgIndentify, StorageStrategy = Default ]
{

Index IndexDataMaster On (ProcessRecordDR, OrderNo) [ SqlName = Index_DataMaster, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKMCORGINDENTIFY On RowID [ PrimaryKey, SqlName = PK_MC_ORGINDENTIFY, Type = index, Unique ];

/// Foreign Key FKMCOrgIdentifyCulture created via DDL
ForeignKey FKMCOrgIdentifyCulture(CultureDR) References dbo.MCCulture(PKMCCULTURE) [ SqlName = FK_MC_OrgIdentify_Culture ];

/// Foreign Key FKMCOrgIdentifyGenus created via DDL
ForeignKey FKMCOrgIdentifyGenus(GenusDR) References dbo.BTGenus(PKBTGENUS) [ SqlName = FK_MC_OrgIdentify_Genus ];

/// Foreign Key FKMCOrgIdentifyPR created via DDL
ForeignKey FKMCOrgIdentifyPR(ProcessRecordDR) References dbo.MCProcessRecord(PKMCPROCESSRECORD) [ SqlName = FK_MC_OrgIdentify_PR ];

/// Foreign Key FKMCOrgIdentityOrganism created via DDL
ForeignKey FKMCOrgIdentityOrganism(OrganismDR) References dbo.BTOrganism(PKBTORGANISM) [ SqlName = FK_MC_OrgIdentity_Organism ];

/// Foreign Key FKMCOrgIdentitySuspectOrganism created via DDL
ForeignKey FKMCOrgIdentitySuspectOrganism(SuspectOrganismDR) References dbo.BTOrganism(PKBTORGANISM) [ SqlName = FK_MC_OrgIdentity_SuspectOrganism ];

/// Foreign Key FKMCOrgIdentityVisitNumberReport created via DDL
ForeignKey FKMCOrgIdentityVisitNumberReport(VisitNumberReportDR) References dbo.RPVisitNumberReport(PKRPVISITNUMBERREPORT) [ SqlName = FK_MC_OrgIdentity_VisitNumberReport ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property ProcessRecordDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property OrderNo As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property CultureDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property GenusDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property SuspectOrganismDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Property OrganismDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Property OrganismNumber As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 9 ];

Property OrgidfyMethod As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

Property Description As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 11 ];

Property VisitNumberReportDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 12 ];

Storage Default
{
<Data name="MCOrgIndentifyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ProcessRecordDR</Value>
</Value>
<Value name="3">
<Value>OrderNo</Value>
</Value>
<Value name="4">
<Value>CultureDR</Value>
</Value>
<Value name="5">
<Value>GenusDR</Value>
</Value>
<Value name="6">
<Value>SuspectOrganismDR</Value>
</Value>
<Value name="7">
<Value>OrganismDR</Value>
</Value>
<Value name="8">
<Value>OrganismNumber</Value>
</Value>
<Value name="9">
<Value>Method</Value>
</Value>
<Value name="10">
<Value>Description</Value>
</Value>
<Value name="11">
<Value>VisitNumberReportDR</Value>
</Value>
<Value name="12">
<Value>OrgidfyMethod</Value>
</Value>
</Data>
<DataLocation>^dbo.MCOrgIndentifyD</DataLocation>
<DefaultData>MCOrgIndentifyDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.MCOrgIndentifyD</IdLocation>
<IndexLocation>^dbo.MCOrgIndentifyI</IndexLocation>
<StreamLocation>^dbo.MCOrgIndentifyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
