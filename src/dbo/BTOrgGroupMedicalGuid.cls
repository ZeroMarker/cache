///     
Class dbo.BTOrgGroupMedicalGuid Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_OrgGroupMedicalGuid ]
{

/// DDL Primary Key Disease
Index IndexAntiWCode On (RUOrganismGroupDR, AntiWCode) [ SqlName = Index_AntiWCode, Type = index ];

/// DDL Primary Key Disease
Index IndexDisease On (RUOrganismGroupDR, AntiWCode, RUDiseaseDR) [ SqlName = Index_Disease, Type = index ];

/// Foreign Key FKBTOrgGroupMedicalGuidRUOrganismGroupDR created via DDL
ForeignKey FKBTOrgGroupMedicalGuidRUOrganismGroupDR(RUOrganismGroupDR) References dbo.BTRUOrganismGroup(PKBTRUORGANISMGROUP) [ SqlName = FK_BTOrgGroupMedicalGuidRUOrganismGroupDR ];

/// Foreign Key FKBTOrgGroupMedicalGuidRUDiseaseDR created via DDL
ForeignKey FKBTOrgGroupMedicalGuidRUDiseaseDR(RUDiseaseDR) References dbo.BTRUDisease(PKBTRUDisease) [ SqlName = FK_BTOrgGroupMedicalGuidRUDiseaseDR ];

/// Foreign Key FKBTOrgGroupMedicalGuidMidGuidSourceDR created via DDL
ForeignKey FKBTOrgGroupMedicalGuidMidGuidSourceDR(MidGuidSourceDR) References dbo.BTMidGuidSource(PKBTMIDGUIDSOURCE) [ SqlName = FK_BTOrgGroupMedicalGuidMidGuidSourceDR ];

/// DDL Primary Key Specification
Index PKBTORGGROUPMEDICALGUID On RowID [ PrimaryKey, SqlName = PK_BT_ORGGROUPMEDICALGUID, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property RUOrganismGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 3 ];

Property AntiWCode As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 4 ];

Property LevelNo As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 5 ];

Property RUDiseaseDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 7 ];

Property MidGuidSourceDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 10 ];

Storage Default
{
<Data name="BTOrgGroupMedicalGuidDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RUOrganismGroupDR</Value>
</Value>
<Value name="3">
<Value>AntiWCode</Value>
</Value>
<Value name="4">
<Value>LevelNo</Value>
</Value>
<Value name="5">
<Value>RUDiseaseDR</Value>
</Value>
<Value name="6">
<Value>Remark</Value>
</Value>
<Value name="7">
<Value>MidGuidSourceDR</Value>
</Value>
<Value name="8">
<Value>Sequence</Value>
</Value>
<Value name="9">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BTOrgGroupMedicalGuidD</DataLocation>
<DefaultData>BTOrgGroupMedicalGuidDefaultData</DefaultData>
<IdLocation>^dbo.BTOrgGroupMedicalGuidD</IdLocation>
<IndexLocation>^dbo.BTOrgGroupMedicalGuidI</IndexLocation>
<StreamLocation>^dbo.BTOrgGroupMedicalGuidS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
