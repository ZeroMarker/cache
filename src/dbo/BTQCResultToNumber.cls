///     
Class dbo.BTQCResultToNumber Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTQC_ResultToNumber, StorageStrategy = Default ]
{

/// Foreign Key FKQCResultToNumberMacine created via DDL
ForeignKey FKQCResultToNumberMacine(MachineParameterDR) References dbo.BTMIMachineParameter(PKBTMIMACHINEPARAMETER) [ SqlName = FK_QCResultToNumberMacine ];

/// Foreign Key FKQCResultToNumberTestCode created via DDL
ForeignKey FKQCResultToNumberTestCode(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_QCResultToNumberTestCode ];

Index IndexMaster On (MachineParameterDR, TestCodeDR, OldResult) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTQCRESULTTONUMBER On RowID [ PrimaryKey, SqlName = PK_BTQC_RESULTTONUMBER, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property MachineParameterDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property OldResult As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ Required, SqlColumnNumber = 5 ];

Property NewResult As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 6 ];

// 目标浓度，123，多个用逗号分开

Property PerLevelNos As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 7 ];

// 转换公式

Property TransFormula As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 8 ];

Storage Default
{
<Data name="BTQCResultToNumberDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MachineParameterDR</Value>
</Value>
<Value name="3">
<Value>TestCodeDR</Value>
</Value>
<Value name="4">
<Value>OldResult</Value>
</Value>
<Value name="5">
<Value>NewResult</Value>
</Value>
<Value name="6">
<Value>PerLevelNos</Value>
</Value>
<Value name="7">
<Value>TransFormula</Value>
</Value>
</Data>
<DataLocation>^dbo.BTQCResultToNumberD</DataLocation>
<DefaultData>BTQCResultToNumberDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTQCResultToNumberD</IdLocation>
<IndexLocation>^dbo.BTQCResultToNumberI</IndexLocation>
<StreamLocation>^dbo.BTQCResultToNumberS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
