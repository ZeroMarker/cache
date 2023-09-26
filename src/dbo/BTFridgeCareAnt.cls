///     
Class dbo.BTFridgeCareAnt Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_FridgeCareAnt ]
{

Index IndexMaster On (WorkGroupDR, AntibioticsDR) [ SqlName = Index_Master, Type = index, Unique ];

/// Foreign Key FKBTFridgeCareAntAntibioticsDR created via DDL
ForeignKey FKBTFridgeCareAntAntibioticsDR(AntibioticsDR) References dbo.BTAntibiotics(PKBTANTIBIOTICS) [ SqlName = FK_BTFridgeCareAntAntibioticsDR ];

/// Foreign Key FKBTFridgeCareAntWorkGroupDR created via DDL
ForeignKey FKBTFridgeCareAntWorkGroupDR(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_BTFridgeCareAntWorkGroupDR ];

/// DDL Primary Key Specification
Index PKBTFRIDGECAREANT On RowID [ PrimaryKey, SqlName = PK_BT_FRIDGECAREANT, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property AntibioticsDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Storage Default
{
<Data name="BTFridgeCareAntDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AntibioticsDR</Value>
</Value>
<Value name="3">
<Value>WorkGroupDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BTFridgeCareAntD</DataLocation>
<DefaultData>BTFridgeCareAntDefaultData</DefaultData>
<IdLocation>^dbo.BTFridgeCareAntD</IdLocation>
<IndexLocation>^dbo.BTFridgeCareAntI</IndexLocation>
<StreamLocation>^dbo.BTFridgeCareAntS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
