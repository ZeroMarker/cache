/// 标本质量
Class dbo.BTSpecimenQuality Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_SpecimenQuality, StorageStrategy = Default ]
{

Index IndexCode On Code [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSequence On Sequence [ SqlName = Index_Sequence, Type = index ];

/// Foreign Key FKWorkGroupMachine created via DDL
ForeignKey FKWorkGroupDR(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_WorkGroupDR ];

/// Foreign Key FKMachineWorkGroup created via DDL
ForeignKey FKWorkGroupMachineDR(WorkGroupMachineDR) References dbo.BTWorkGroupMachine(PKBTWORKGROUPMACHINE) [ SqlName = FK_WorkGroupMachineDR ];

/// DDL Primary Key Specification
Index PKBTSPECIMENQUALITY On RowID [ PrimaryKey, SqlName = PK_BT_SPECIMENQUALITY, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 4 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 6 ];

Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Property WorkGroupMachineDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Property IsDefault As %Library.Boolean [ SqlColumnNumber = 9 ];

Storage Default
{
<Data name="BTSpecimenQualityDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>CName</Value>
</Value>
<Value name="4">
<Value>Sequence</Value>
</Value>
<Value name="5">
<Value>Active</Value>
</Value>
<Value name="6">
<Value>WorkGroupDR</Value>
</Value>
<Value name="7">
<Value>WorkGroupMachineDR</Value>
</Value>
<Value name="8">
<Value>IsDefault</Value>
</Value>
</Data>
<DataLocation>^dbo.BTSpecimenQualityD</DataLocation>
<DefaultData>BTSpecimenQualityDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTSpecimenQualityD</IdLocation>
<IndexLocation>^dbo.BTSpecimenQualityI</IndexLocation>
<StreamLocation>^dbo.BTSpecimenQualityS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
