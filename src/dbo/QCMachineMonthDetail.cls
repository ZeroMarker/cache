Class dbo.QCMachineMonthDetail Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = QC_MachineMonthDetail ]
{

/// Foreign Key FKMachineMonthDetail created via DDL
ForeignKey FKMachineMonthDetail(MachineParameterDR) References dbo.BTMIMachineParameter(PKBTMIMACHINEPARAMETER) [ SqlName = FK_MachineMonthDetail ];

/// Foreign Key FKMachineMonthDetailTestCode created via DDL
ForeignKey FKMachineMonthDetailTestCode(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_MachineMonthDetailTestCode ];

Index IndexMaster On (MachineParameterDR, Year, Month, TestCodeDR, LevelNo, LotNo) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKQCMACHINEMONTHDETAIL On RowID [ PrimaryKey, SqlName = PK_QC_MACHINEMONTHDETAIL, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property MachineParameterDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property Year As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property Month As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

Property LevelNo As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

Property LotNo As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ SqlColumnNumber = 8 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 800) [ SqlColumnNumber = 9 ];

Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

Property AuthDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

Property AuthTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

Property AuthUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 15 ];

Property AuthRemark As %Library.String(COLLATION = "Exact", MAXLEN = 800) [ SqlColumnNumber = 16 ];

Storage Default
{
<Data name="QCMachineMonthDetailDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MachineParameterDR</Value>
</Value>
<Value name="3">
<Value>Year</Value>
</Value>
<Value name="4">
<Value>Month</Value>
</Value>
<Value name="5">
<Value>TestCodeDR</Value>
</Value>
<Value name="6">
<Value>LevelNo</Value>
</Value>
<Value name="7">
<Value>LotNo</Value>
</Value>
<Value name="8">
<Value>Remark</Value>
</Value>
<Value name="9">
<Value>AddDate</Value>
</Value>
<Value name="10">
<Value>AddTime</Value>
</Value>
<Value name="11">
<Value>AddUserDR</Value>
</Value>
<Value name="12">
<Value>AuthDate</Value>
</Value>
<Value name="13">
<Value>AuthTime</Value>
</Value>
<Value name="14">
<Value>AuthUserDR</Value>
</Value>
<Value name="15">
<Value>AuthRemark</Value>
</Value>
</Data>
<DataLocation>^dbo.QCMachineMonthDetailD</DataLocation>
<DefaultData>QCMachineMonthDetailDefaultData</DefaultData>
<IdLocation>^dbo.QCMachineMonthDetailD</IdLocation>
<IndexLocation>^dbo.QCMachineMonthDetailI</IndexLocation>
<StreamLocation>^dbo.QCMachineMonthDetailS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
