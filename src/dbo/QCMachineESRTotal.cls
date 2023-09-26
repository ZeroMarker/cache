///     
Class dbo.QCMachineESRTotal Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = QC_MachineESRTotal ]
{

/// Foreign Key FKQCMachineESRTotalMachineParameterDR created via DDL
ForeignKey FKQCMachineESRTotalMachineParameterDR(MachineParameterDR) References dbo.BTMIMachineParameter(PKBTMIMACHINEPARAMETER) [ SqlName = FK_QCMachineESRTotalMachineParameterDR ];

/// Foreign Key FKQCMachineESRTotalTestCodeDR created via DDL
ForeignKey FKQCMachineESRTotalTestCodeDR(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_QCMachineESRTotalTestCodeDR ];

/// DDL Primary Key Specification
Index PKQCMACHINEESRTOTAL On RowID [ PrimaryKey, SqlName = PK_QC_MACHINEESRTOTAL, Type = index, Unique ];

Index IndexMaster On (MachineParameterDR, TestDate, TestCodeDR) [ SqlName = Index_Master, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property TestDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property MachineParameterDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property ResultNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

Property Mean As %Library.Float [ SqlColumnNumber = 7 ];

Property SD As %Library.Float [ SqlColumnNumber = 8 ];

Property MaxValue As %Library.Float [ SqlColumnNumber = 9 ];

Property MaxEpis As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 10 ];

Property MinValue As %Library.Float [ SqlColumnNumber = 11 ];

Property MinEpis As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 12 ];

Property LastTestDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

Property LastTestTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

Property RgLot As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 15 ];

Property CurRgMean As %Library.Float [ SqlColumnNumber = 16 ];

Property CurRgSD As %Library.Float [ SqlColumnNumber = 17 ];

Property HasQC As %Library.Boolean [ SqlColumnNumber = 18 ];

Property QcNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 19 ];

Storage Default
{
<Data name="QCMachineESRTotalDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TestDate</Value>
</Value>
<Value name="3">
<Value>MachineParameterDR</Value>
</Value>
<Value name="4">
<Value>TestCodeDR</Value>
</Value>
<Value name="5">
<Value>ResultNum</Value>
</Value>
<Value name="6">
<Value>Mean</Value>
</Value>
<Value name="7">
<Value>SD</Value>
</Value>
<Value name="8">
<Value>MaxValue</Value>
</Value>
<Value name="9">
<Value>MaxEpis</Value>
</Value>
<Value name="10">
<Value>MinValue</Value>
</Value>
<Value name="11">
<Value>MinEpis</Value>
</Value>
<Value name="12">
<Value>LastTestDate</Value>
</Value>
<Value name="13">
<Value>LastTestTime</Value>
</Value>
<Value name="14">
<Value>RgLot</Value>
</Value>
<Value name="15">
<Value>CurRgMean</Value>
</Value>
<Value name="16">
<Value>CurRgSD</Value>
</Value>
<Value name="17">
<Value>HasQC</Value>
</Value>
<Value name="18">
<Value>QcNum</Value>
</Value>
</Data>
<DataLocation>^dbo.QCMachineESRTotalD</DataLocation>
<DefaultData>QCMachineESRTotalDefaultData</DefaultData>
<IdLocation>^dbo.QCMachineESRTotalD</IdLocation>
<IndexLocation>^dbo.QCMachineESRTotalI</IndexLocation>
<StreamLocation>^dbo.QCMachineESRTotalS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
