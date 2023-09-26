///     
Class dbo.BDMachineXM Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_MachineXM, StorageStrategy = Default ]
{

Index IndexMaster On (MachineParameterDR, PackDR, SampleNo) [ SqlName = Index_Master, Type = index ];

Index IndexSampleNo On (MachineParameterDR, SampleNo) [ SqlName = Index_SampleNo, Type = index ];

Index IndexStatus On (MachineParameterDR, Sended) [ SqlName = Index_Status, Type = index ];

Index IndexPack On (PackDR, MachineParameterDR) [ SqlName = Index_Pack, Type = index ];

/// DDL Primary Key Specification
Index PKBDMachineXM On RowID [ PrimaryKey, SqlName = PK_BD_MachineXM, Type = index, Unique ];

/// Foreign Key FKBDPack created via DDL
ForeignKey FKBDPack(PackDR) References dbo.BDPack(PKBDPACK) [ SqlName = FK_BD_Pack ];

/// Foreign Key FKBDReqForm created via DDL
ForeignKey FKBDReqForm(ReqFormDR) References dbo.BDReqForm(PKBDREQFORM) [ SqlName = FK_BD_ReqForm ];

/// Foreign Key FKBTMIMachineParameter created via DDL
ForeignKey FKBTMIMachineParameter(MachineParameterDR) References dbo.BTMIMachineParameter(PKBTMIMACHINEPARAMETER) [ SqlName = FK_BTMI_MachineParameter ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property MachineParameterDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property PackDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property SampleNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ Required, SqlColumnNumber = 5 ];

Property Sended As %Library.Boolean [ Required, SqlColumnNumber = 6 ];

Property ReqFormDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

Property SpecimenNo As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 8 ];

Storage Default
{
<Data name="BDMachineXMDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MachineParameterDR</Value>
</Value>
<Value name="3">
<Value>PackDR</Value>
</Value>
<Value name="4">
<Value>SampleNo</Value>
</Value>
<Value name="5">
<Value>Sended</Value>
</Value>
<Value name="6">
<Value>ReqFormDR</Value>
</Value>
<Value name="7">
<Value>SpecimenNo</Value>
</Value>
</Data>
<DataLocation>^dbo.BDMachineXMD</DataLocation>
<DefaultData>BDMachineXMDefaultData</DefaultData>
<IdLocation>^dbo.BDMachineXMD</IdLocation>
<IndexLocation>^dbo.BDMachineXMI</IndexLocation>
<StreamLocation>^dbo.BDMachineXMS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
