///     
Class dbo.QCEQASample Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = QC_EQASample, StorageStrategy = Default ]
{

Index IndexMaster On SampleNo [ SqlName = Index_Master, Type = index ];

Index IndexEpisodeNo On (MachineParameterDR, AssayDate, EpisodeNo) [ SqlName = Index_EpisodeNo, Type = index ];

Index IndexAuthDate On (MachineParameterDR, AuthDate) [ SqlName = Index_AuthDate, Type = index ];

Index IndexEQAWGPlan On EQAWGPlanDR [ SqlName = Index_EQAWGPlan, Type = index ];

/// DDL Primary Key Specification
Index PKQCEQASAMPLE On RowID [ PrimaryKey, SqlName = PK_QC_EQASAMPLE, Type = index, Unique ];

/// Foreign Key FKBTEQAItemPlanEQAItem created via DDL
ForeignKey FKQCEQASampleEQAWGPlan(EQAWGPlanDR) References dbo.QCEQAWGPlan(PKQCEQAWGPLAN) [ SqlName = FK_QC_EQASample_EQAWGPlan ];

/// Foreign Key FKQCEQASampleMIMachineParameter created via DDL
ForeignKey FKQCEQASampleMIMachineParameter(MachineParameterDR) References dbo.BTMIMachineParameter(PKBTMIMACHINEPARAMETER) [ SqlName = FK_QC_EQASample_MIMachineParameter ];

/// Foreign Key FKQCEQASampleEntryUser created via DDL
ForeignKey FKQCEQASampleEntryUser(EntryUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_QC_EQASample_EntryUser ];

/// Foreign Key FKQCEQASampleAuthUser created via DDL
ForeignKey FKQCEQASampleAuthUser(AuthUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_QC_EQASample_AuthUser ];

/// Foreign Key FKQCEQASampleAddUser created via DDL
ForeignKey FKQCEQASampleAddUser(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_QC_EQASample_AddUser ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property SampleNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ Required, SqlColumnNumber = 3 ];

Property EQAWGPlanDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property ReceiveDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property SampleName As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 6 ];

Property SampleCode As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 7 ];

Property SampleStatus As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 8 ];

Property StorageCond As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 9 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 10 ];

Property MachineParameterDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

Property AssayDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

Property EpisodeNo As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 13 ];

Property EntryDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

Property EntryTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 15 ];

Property EntryUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 16 ];

Property AuthDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 17 ];

Property AuthTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 18 ];

Property AuthUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 19 ];

Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 20 ];

Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 21 ];

Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 22 ];

Property StorageSite As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 23 ];

Storage Default
{
<Data name="QCEQASampleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SampleNo</Value>
</Value>
<Value name="3">
<Value>EQAWGPlanDR</Value>
</Value>
<Value name="4">
<Value>ReceiveDate</Value>
</Value>
<Value name="5">
<Value>SampleName</Value>
</Value>
<Value name="6">
<Value>SampleCode</Value>
</Value>
<Value name="7">
<Value>SampleStatus</Value>
</Value>
<Value name="8">
<Value>StorageCond</Value>
</Value>
<Value name="9">
<Value>Remark</Value>
</Value>
<Value name="10">
<Value>MachineParameterDR</Value>
</Value>
<Value name="11">
<Value>AssayDate</Value>
</Value>
<Value name="12">
<Value>EpisodeNo</Value>
</Value>
<Value name="13">
<Value>EntryDate</Value>
</Value>
<Value name="14">
<Value>EntryTime</Value>
</Value>
<Value name="15">
<Value>EntryUserDR</Value>
</Value>
<Value name="16">
<Value>AuthDate</Value>
</Value>
<Value name="17">
<Value>AuthTime</Value>
</Value>
<Value name="18">
<Value>AuthUserDR</Value>
</Value>
<Value name="19">
<Value>AddDate</Value>
</Value>
<Value name="20">
<Value>AddTime</Value>
</Value>
<Value name="21">
<Value>AddUserDR</Value>
</Value>
<Value name="22">
<Value>StorageSite</Value>
</Value>
</Data>
<DataLocation>^dbo.QCEQASampleD</DataLocation>
<DefaultData>QCEQASampleDefaultData</DefaultData>
<IdLocation>^dbo.QCEQASampleD</IdLocation>
<IndexLocation>^dbo.QCEQASampleI</IndexLocation>
<StreamLocation>^dbo.QCEQASampleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
