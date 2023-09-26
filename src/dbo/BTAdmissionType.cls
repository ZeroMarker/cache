///     
Class dbo.BTAdmissionType Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_AdmissionType, StorageStrategy = Default ]
{

Index IndexCode On Code [ SqlName = Index_Code, Type = index, Unique ];

Index IndexHISCode On HISCode [ SqlName = Index_HISCode, Type = index ];

/// DDL Primary Key Specification
Index PKBTADMISSIONTYPE On RowID [ PrimaryKey, SqlName = PK_BT_ADMISSIONTYPE, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 4 ];

Property AdmType As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 5 ];

Property HISCode As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 6 ];

Storage Default
{
<Data name="BTAdmissionTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>CName</Value>
</Value>
<Value name="4">
<Value>AdmType</Value>
</Value>
<Value name="5">
<Value>HISCode</Value>
</Value>
</Data>
<DataLocation>^dbo.BTAdmissionTypeD</DataLocation>
<DefaultData>BTAdmissionTypeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTAdmissionTypeD</IdLocation>
<IndexLocation>^dbo.BTAdmissionTypeI</IndexLocation>
<StreamLocation>^dbo.BTAdmissionTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
