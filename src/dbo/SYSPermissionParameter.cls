Class dbo.SYSPermissionParameter Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = SYS_PermissionParameter ]
{

Index IndexMaster On (PermissionDR, HospitalDR, ParaType) [ SqlName = IndexMaster, Type = index, Unique ];

ForeignKey FKPermissionParameterRowID(PermissionDR) References dbo.SYSPermission(PKSYSPERMISSION) [ SqlName = FK_PermissionParameterRowID ];

ForeignKey FKPermissionParameterHosDR(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_PermissionParameterHosDR ];

/// DDL Primary Key Specification
Index PKSYSPERMISSIONPARAMETER On RowID [ PrimaryKey, SqlName = PK_SYS_PERMISSIONPARAMETER, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property PermissionDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property ParaType As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 5 ];

Property ParaValue As %Library.String(COLLATION = "Exact", MAXLEN = 4000) [ SqlColumnNumber = 6 ];

Property ParaList As %Library.String(COLLATION = "Exact", MAXLEN = 4000) [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="SYSPermissionParameterDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PermissionDR</Value>
</Value>
<Value name="3">
<Value>HospitalDR</Value>
</Value>
<Value name="4">
<Value>ParaType</Value>
</Value>
<Value name="5">
<Value>ParaValue</Value>
</Value>
<Value name="6">
<Value>ParaList</Value>
</Value>
</Data>
<DataLocation>^dbo.SYSPermissionParameterD</DataLocation>
<DefaultData>SYSPermissionParameterDefaultData</DefaultData>
<IdLocation>^dbo.SYSPermissionParameterD</IdLocation>
<IndexLocation>^dbo.SYSPermissionParameterI</IndexLocation>
<StreamLocation>^dbo.SYSPermissionParameterS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
