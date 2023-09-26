Class dbo.HRContractChange Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = HR_ContractChange, StorageStrategy = Default ]
{

Index IndexMaster On (StaffDR, ChangeDate, ChangeTime) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexContractDate On ContractDate [ SqlName = Index_ContractDate, Type = index ];

Index IndexChangeDate On ChangeDate [ SqlName = Index_ChangeDate, Type = index ];

Index IndexChangeUser On ChangeUserDR [ SqlName = Index_ChangeUser, Type = index ];

/// DDL Primary Key Specification
Index PKHRContractChange On RowID [ PrimaryKey, SqlName = PK_HR_CONTRACTCHANGE, Type = index, Unique ];

ForeignKey FKContractChangeStaff(StaffDR) References dbo.HRStaff(PKHRSTAFF) [ SqlName = FK_ContractChangeStaff ];

ForeignKey FKContractChangeEmployeeType(EmployTypeDR) References dbo.BTHREmployType(PKBTHREMPLOYTYPE) [ SqlName = FK_ContractChangeEmployeeType ];

ForeignKey FKContractChangeChangeUser(ChangeUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_ContractChangeChangeUser ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property StaffDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property EmployTypeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property ContractDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property ExpireDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

Property ContractFilePath As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ Required, SqlColumnNumber = 7 ];

Property ChangeDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Property ChangeTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Property ChangeUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

Property ContractFileName As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 11 ];

Storage Default
{
<Data name="HRContractChangeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>StaffDR</Value>
</Value>
<Value name="3">
<Value>EmployTypeDR</Value>
</Value>
<Value name="4">
<Value>ContractDate</Value>
</Value>
<Value name="5">
<Value>ExpireDate</Value>
</Value>
<Value name="6">
<Value>ContractFilePath</Value>
</Value>
<Value name="7">
<Value>ChangeDate</Value>
</Value>
<Value name="8">
<Value>ChangeTime</Value>
</Value>
<Value name="9">
<Value>ChangeUserDR</Value>
</Value>
<Value name="10">
<Value>ContractFileName</Value>
</Value>
</Data>
<DataLocation>^dbo.HRContractChangeD</DataLocation>
<DefaultData>HRContractChangeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.HRContractChangeD</IdLocation>
<IndexLocation>^dbo.HRContractChangeI</IndexLocation>
<StreamLocation>^dbo.HRContractChangeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
