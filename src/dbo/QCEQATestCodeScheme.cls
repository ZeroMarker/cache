///     
Class dbo.QCEQATestCodeScheme Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = QC_EQATestCodeScheme, StorageStrategy = Default ]
{

Index IndexMaster On (WorkGroupDR, OpenYear, TestCodeDR) [ SqlName = Index_Master, Type = index ];

Index IndexTestCode On (TestCodeDR, OpenYear, WorkGroupDR) [ SqlName = Index_TestCode, Type = index ];

Index IndexMachine On (MachineParameterDR, OpenYear) [ SqlName = Index_Machine, Type = index ];

Index IndexEQAItem On (EQAItemDR, OpenYear) [ SqlName = Index_EQAItem, Type = index ];

Index IndexWorkGroup On (WorkGroupDR, OpenYear, EQAItemDR) [ SqlName = Index_WorkGroup, Type = index ];

/// DDL Primary Key Specification
Index PKQCEQATESTCODESCHEME On RowID [ PrimaryKey, SqlName = PK_QC_EQATESTCODESCHEME, Type = index, Unique ];

/// Foreign Key FKQCEQATestCodeWorkGroup created via DDL
ForeignKey FKQCEQATestCodeWorkGroup(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_QC_EQATestCode_WorkGroup ];

/// Foreign Key FKQCEQATestCodeTestCode created via DDL
ForeignKey FKQCEQATestCodeTestCode(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_QC_EQATestCode_TestCode ];

/// Foreign Key FKQCEQATestCodeEQAItem created via DDL
ForeignKey FKQCEQATestCodeEQAItem(EQAItemDR) References dbo.BTEQAItem(PKBTEQAITEM) [ SqlName = FK_QC_EQATestCode_EQAItem ];

/// Foreign Key FKQCEQATestCodeMIMachineParameter created via DDL
ForeignKey FKQCEQATestCodeMIMachineParameter(MachineParameterDR) References dbo.BTMIMachineParameter(PKBTMIMACHINEPARAMETER) [ SqlName = FK_QC_EQATestCode_MIMachineParameter ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property OpenYear As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property EQAItemDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

Property ResFormat As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 7 ];

Property IsQC As %Library.Boolean [ SqlColumnNumber = 8 ];

Property MachineParameterDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 9 ];

Property MachineIDs As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 10 ];

Property IsTarget As %Library.Boolean [ SqlColumnNumber = 11 ];

Property TargetValue As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 12 ];

Property TargetSource As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 13 ];

Property MatCompany As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 14 ];

Property QCLevel As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 15 ];

Property NotJoinQCReason As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 16 ];

Property NotJoinQCMethod As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 17 ];

Property IsEQA As %Library.Boolean [ SqlColumnNumber = 18 ];

Property EQAType As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 19 ];

Property NotJoinEQAReason As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 20 ];

Property IsComparison As %Library.Boolean [ SqlColumnNumber = 21 ];

Property CompRemark As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 22 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 23 ];

Property ResultUnit As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 24 ];

Storage Default
{
<Data name="QCEQATestCodeSchemeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WorkGroupDR</Value>
</Value>
<Value name="3">
<Value>OpenYear</Value>
</Value>
<Value name="4">
<Value>TestCodeDR</Value>
</Value>
<Value name="5">
<Value>EQAItemDR</Value>
</Value>
<Value name="6">
<Value>ResFormat</Value>
</Value>
<Value name="7">
<Value>IsQC</Value>
</Value>
<Value name="8">
<Value>MachineParameterDR</Value>
</Value>
<Value name="9">
<Value>MachineIDs</Value>
</Value>
<Value name="10">
<Value>IsTarget</Value>
</Value>
<Value name="11">
<Value>TargetValue</Value>
</Value>
<Value name="12">
<Value>TargetSource</Value>
</Value>
<Value name="13">
<Value>MatCompany</Value>
</Value>
<Value name="14">
<Value>QCLevel</Value>
</Value>
<Value name="15">
<Value>NotJoinQCReason</Value>
</Value>
<Value name="16">
<Value>NotJoinQCMethod</Value>
</Value>
<Value name="17">
<Value>IsEQA</Value>
</Value>
<Value name="18">
<Value>EQAType</Value>
</Value>
<Value name="19">
<Value>NotJoinEQAReason</Value>
</Value>
<Value name="20">
<Value>IsComparison</Value>
</Value>
<Value name="21">
<Value>CompRemark</Value>
</Value>
<Value name="22">
<Value>Sequence</Value>
</Value>
<Value name="23">
<Value>ResultUnit</Value>
</Value>
</Data>
<DataLocation>^dbo.QCEQATestCodeSchemeD</DataLocation>
<DefaultData>QCEQATestCodeSchemeDefaultData</DefaultData>
<IdLocation>^dbo.QCEQATestCodeSchemeD</IdLocation>
<IndexLocation>^dbo.QCEQATestCodeSchemeI</IndexLocation>
<StreamLocation>^dbo.QCEQATestCodeSchemeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
