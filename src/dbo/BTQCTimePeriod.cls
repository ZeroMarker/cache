///     
Class dbo.BTQCTimePeriod Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTQC_TimePeriod ]
{

/// Foreign Key FKBTQCTimePeriodMachineParameterDR created via DDL
ForeignKey FKBTQCTimePeriodMachineParameterDR(MachineParameterDR) References dbo.BTMIMachineParameter(PKBTMIMACHINEPARAMETER) [ SqlName = FK_BTQCTimePeriodMachineParameterDR ];

/// Foreign Key FKBTQCTimePeriodMaterialDR created via DDL
ForeignKey FKBTQCTimePeriodMaterialDR(MaterialDR) References dbo.BTQCMaterial(PKBTQCMATERIAL) [ SqlName = FK_BTQCTimePeriodMaterialDR ];

/// Foreign Key FKBTQCTimePeriodTestCodeDR created via DDL
ForeignKey FKBTQCTimePeriodTestCodeDR(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_BTQCTimePeriodTestCodeDR ];

/// DDL Primary Key Specification
Index PKBTQCTIMEPERIOD On RowID [ PrimaryKey, SqlName = PK_BTQC_TIMEPERIOD, Type = index ];

Index IndexMaster On (MachineParameterDR, TestCodeDR, MaterialDR) [ SqlName = Index_MachineParameterDR, Type = index ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property MachineParameterDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property MaterialDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property StartTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

Property EndTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 8 ];

Storage Default
{
<Data name="BTQCTimePeriodDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MachineParameterDR</Value>
</Value>
<Value name="3">
<Value>MaterialDR</Value>
</Value>
<Value name="4">
<Value>TestCodeDR</Value>
</Value>
<Value name="5">
<Value>StartTime</Value>
</Value>
<Value name="6">
<Value>EndTime</Value>
</Value>
<Value name="7">
<Value>Remark</Value>
</Value>
</Data>
<DataLocation>^dbo.BTQCTimePeriodD</DataLocation>
<DefaultData>BTQCTimePeriodDefaultData</DefaultData>
<IdLocation>^dbo.BTQCTimePeriodD</IdLocation>
<IndexLocation>^dbo.BTQCTimePeriodI</IndexLocation>
<StreamLocation>^dbo.BTQCTimePeriodS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
