///     
Class dbo.LISMachineRequisition Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = LIS_MachineRequisition ]
{

Index IndexMater On (HosCode, MachineCode) [ SqlName = Index_Mater, Type = index, Unique ];

Index IndexAddDate On (HosCode, MachineCode, AddDate, AddTime) [ SqlName = Index_AddDate, Type = index ];

Index IndexSequence On Sequence [ SqlName = Index_Sequence, Type = index ];

/// DDL Primary Key Specification
Index PKLISMACHINEREQUISITION On RowID [ PrimaryKey, SqlName = PK_LIS_MACHINEREQUISITION, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property UserName As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 3 ];

Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Property HosCode As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ Required, SqlColumnNumber = 6 ];

Property MachineCode As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ Required, SqlColumnNumber = 7 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 8 ];

Property KeyWord As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 9 ];

Property CommDirection As %Library.String(COLLATION = "Exact", MAXLEN = 2) [ SqlColumnNumber = 10 ];

Property DelimiterForTests As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 11 ];

Property DelimiterForResults As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 12 ];

Property DelimiterForAnt As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 13 ];

Property DelimiterForSen As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 14 ];

Property IFProgram As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 15 ];

Property ComPort As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 16 ];

Property BaudRate As %Library.String(COLLATION = "Exact", MAXLEN = 6) [ SqlColumnNumber = 17 ];

Property DataBits As %Library.String(COLLATION = "Exact", MAXLEN = 5) [ SqlColumnNumber = 18 ];

Property StopBits As %Library.String(COLLATION = "Exact", MAXLEN = 5) [ SqlColumnNumber = 19 ];

Property Parity As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 20 ];

Property DeviceCode As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 21 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 22 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 23 ];

Property Manufacturer As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 24 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 25 ];

Property EquipmentType As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 26 ];

Property LinkType As %Library.String(COLLATION = "Exact", MAXLEN = 2) [ SqlColumnNumber = 27 ];

Property UsingHos As %Library.String(COLLATION = "Exact", MAXLEN = 4000) [ SqlColumnNumber = 28 ];

Storage Default
{
<Data name="LISMachineRequisitionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>UserName</Value>
</Value>
<Value name="3">
<Value>AddDate</Value>
</Value>
<Value name="4">
<Value>AddTime</Value>
</Value>
<Value name="5">
<Value>HosCode</Value>
</Value>
<Value name="6">
<Value>MachineCode</Value>
</Value>
<Value name="7">
<Value>CName</Value>
</Value>
<Value name="8">
<Value>KeyWord</Value>
</Value>
<Value name="9">
<Value>CommDirection</Value>
</Value>
<Value name="10">
<Value>DelimiterForTests</Value>
</Value>
<Value name="11">
<Value>DelimiterForResults</Value>
</Value>
<Value name="12">
<Value>DelimiterForAnt</Value>
</Value>
<Value name="13">
<Value>DelimiterForSen</Value>
</Value>
<Value name="14">
<Value>IFProgram</Value>
</Value>
<Value name="15">
<Value>ComPort</Value>
</Value>
<Value name="16">
<Value>BaudRate</Value>
</Value>
<Value name="17">
<Value>DataBits</Value>
</Value>
<Value name="18">
<Value>StopBits</Value>
</Value>
<Value name="19">
<Value>Parity</Value>
</Value>
<Value name="20">
<Value>DeviceCode</Value>
</Value>
<Value name="21">
<Value>Sequence</Value>
</Value>
<Value name="22">
<Value>Active</Value>
</Value>
<Value name="23">
<Value>Manufacturer</Value>
</Value>
<Value name="24">
<Value>Remark</Value>
</Value>
<Value name="25">
<Value>EquipmentType</Value>
</Value>
<Value name="26">
<Value>LinkType</Value>
</Value>
<Value name="27">
<Value>UsingHos</Value>
</Value>
</Data>
<DataLocation>^dbo.LISMachineRequisitionD</DataLocation>
<DefaultData>LISMachineRequisitionDefaultData</DefaultData>
<IdLocation>^dbo.LISMachineRequisitionD</IdLocation>
<IndexLocation>^dbo.LISMachineRequisitionI</IndexLocation>
<StreamLocation>^dbo.LISMachineRequisitionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
