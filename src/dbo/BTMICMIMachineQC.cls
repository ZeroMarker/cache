Class dbo.BTMICMIMachineQC Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTMIC_MIMachineQC ]
{

/// Foreign Key FKBTMICMIMachineQCMICQCMaterialDR created via DDL
ForeignKey FKBTMICMIMachineQCMICQCMaterialDR(MICQCMaterialDR) References dbo.BTMICQCMaterial(PKBTMICQCMATERIAL) [ SqlName = FK_BTMICMIMachineQCMICQCMaterialDR ];

/// DDL Primary Key Specification
Index PKBTMICMIMACHINEQC On RowID [ PrimaryKey, SqlName = PK_BTMIC_MIMACHINEQC, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property MICQCMaterialDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property SampleID As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 4 ];

Storage Default
{
<Data name="BTMICMIMachineQCDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RowID</Value>
</Value>
<Value name="3">
<Value>MICQCMaterialDR</Value>
</Value>
<Value name="4">
<Value>SampleID</Value>
</Value>
</Data>
<DataLocation>^dbo.BTMICMIMachineQCD</DataLocation>
<DefaultData>BTMICMIMachineQCDefaultData</DefaultData>
<IdLocation>^dbo.BTMICMIMachineQCD</IdLocation>
<IndexLocation>^dbo.BTMICMIMachineQCI</IndexLocation>
<StreamLocation>^dbo.BTMICMIMachineQCS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
