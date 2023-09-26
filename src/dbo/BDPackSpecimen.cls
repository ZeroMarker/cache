///     
Class dbo.BDPackSpecimen Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_PackSpecimen, StorageStrategy = Default ]
{

Index IndexMaster On (PackDR, SpecimenNo) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index IndexSpecimenNo On SpecimenNo [ SqlName = Index_SpecimenNo, Type = index ];

/// DDL Primary Key Specification
Index PKBDPackSpecimen On RowID [ PrimaryKey, SqlName = PK_BD_PackSpecimen, Type = index, Unique ];

/// Foreign Key FKPackSpecimenPack created via DDL
ForeignKey FKPackSpecimenPack(PackDR) References dbo.BDPack(PKBDPACK) [ SqlName = FK_PackSpecimen_Pack ];

/// Foreign Key FKBDXMPlanAddUser created via DDL
ForeignKey FKPackSpecimenAddUser(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_Pack_Specimen_AddUser ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property PackDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property SpecimenNo As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ Required, SqlColumnNumber = 4 ];

Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

Storage Default
{
<Data name="BDPackSpecimenDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PackDR</Value>
</Value>
<Value name="3">
<Value>SpecimenNo</Value>
</Value>
<Value name="4">
<Value>AddDate</Value>
</Value>
<Value name="5">
<Value>AddTime</Value>
</Value>
<Value name="6">
<Value>AddUserDR</Value>
</Value>
<Value name="7">
<Value>RowID</Value>
</Value>
</Data>
<DataLocation>^dbo.BDPackSpecimenD</DataLocation>
<DefaultData>BDPackSpecimenDefaultData</DefaultData>
<IdLocation>^dbo.BDPackSpecimenD</IdLocation>
<IndexLocation>^dbo.BDPackSpecimenI</IndexLocation>
<StreamLocation>^dbo.BDPackSpecimenS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
