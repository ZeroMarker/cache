///     
Class dbo.BDMachineXMLog Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_MachineXMLog, StorageStrategy = Default ]
{

Index IndexMaster On (MachineParameterDR, AddDate, AddTime) [ SqlName = Index_Master, Type = index ];

Index IndexPack On PackDR [ SqlName = Index_Pack, Type = index ];

Index IndexUser On (AddUserDR, AddDate) [ SqlName = Index_User, Type = index ];

/// DDL Primary Key Specification
Index PKBDMachineXMLog On RowID [ PrimaryKey, SqlName = PK_BD_MachineXMLog, Type = index, Unique ];

/// Foreign Key FKMachineLogBTMIMachineParameter created via DDL
ForeignKey FKMachineLogBTMIMachineParameter(MachineParameterDR) References dbo.BTMIMachineParameter(PKBTMIMACHINEPARAMETER) [ SqlName = FK_MachineLog_BTMI_MachineParameter ];

/// Foreign Key FKMachineXMLogBDPack created via DDL
ForeignKey FKMachineXMLogBDPack(PackDR) References dbo.BDPack(PKBDPACK) [ SqlName = FK_MachineXMLog_BD_Pack ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property MachineParameterDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property PackDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

Property SampleNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ Required, SqlColumnNumber = 7 ];

Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 8 ];

Property SpecimenNo As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 9 ];

Storage Default
{
<Data name="BDMachineXMLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MachineParameterDR</Value>
</Value>
<Value name="3">
<Value>AddDate</Value>
</Value>
<Value name="4">
<Value>AddTime</Value>
</Value>
<Value name="5">
<Value>PackDR</Value>
</Value>
<Value name="6">
<Value>SampleNo</Value>
</Value>
<Value name="7">
<Value>AddUserDR</Value>
</Value>
<Value name="8">
<Value>SpecimenNo</Value>
</Value>
</Data>
<DataLocation>^dbo.BDMachineXMLogD</DataLocation>
<DefaultData>BDMachineXMLogDefaultData</DefaultData>
<IdLocation>^dbo.BDMachineXMLogD</IdLocation>
<IndexLocation>^dbo.BDMachineXMLogI</IndexLocation>
<StreamLocation>^dbo.BDMachineXMLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
