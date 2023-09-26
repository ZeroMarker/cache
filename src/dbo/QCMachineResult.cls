///     
Class dbo.QCMachineResult Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = QC_MachineResult, StorageStrategy = Default ]
{

/// Foreign Key FKMachineResultLot created via DDL
ForeignKey FKMachineResultLot(MaterialLotDR) References dbo.BTQCMaterialLot(PKBTQCMATERIALLOT) [ SqlName = FK_MachineResultLot ];

/// Foreign Key FKMachineResultMachine created via DDL
ForeignKey FKMachineResultMachine(MachineParameterDR) References dbo.BTMIMachineParameter(PKBTMIMACHINEPARAMETER) [ SqlName = FK_MachineResultMachine ];

/// Foreign Key FKMachineResultTestCode created via DDL
ForeignKey FKMachineResultTestCode(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_MachineResultTestCode ];

Index IndexLot On (MaterialLotDR, TestCodeDR, LevelNo, TestDate) [ SqlName = Index_Lot, Type = index ];

Index IndexMaster On (MachineParameterDR, TestCodeDR, LevelNo, TestDate, TestTime) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKQCMACHINERESULT On RowID [ PrimaryKey, SqlName = PK_QC_MACHINERESULT, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property MaterialLotDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property LevelNo As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property MachineParameterDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

Property SampleID As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 7 ];

Property TestDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 8 ];

Property TestTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 9 ];

Property TransmitDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

Property TransmitTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

Property Result As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 12 ];

Property TextRes As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 13 ];

Property MachineFlag As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 14 ];

Storage Default
{
<Data name="QCMachineResultDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MaterialLotDR</Value>
</Value>
<Value name="3">
<Value>TestCodeDR</Value>
</Value>
<Value name="4">
<Value>LevelNo</Value>
</Value>
<Value name="5">
<Value>MachineParameterDR</Value>
</Value>
<Value name="6">
<Value>SampleID</Value>
</Value>
<Value name="7">
<Value>TestDate</Value>
</Value>
<Value name="8">
<Value>TestTime</Value>
</Value>
<Value name="9">
<Value>TransmitDate</Value>
</Value>
<Value name="10">
<Value>TransmitTime</Value>
</Value>
<Value name="11">
<Value>Result</Value>
</Value>
<Value name="12">
<Value>TextRes</Value>
</Value>
<Value name="13">
<Value>MachineFlag</Value>
</Value>
</Data>
<DataLocation>^dbo.QCMachineResultD</DataLocation>
<DefaultData>QCMachineResultDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.QCMachineResultD</IdLocation>
<IndexLocation>^dbo.QCMachineResultI</IndexLocation>
<StreamLocation>^dbo.QCMachineResultS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
