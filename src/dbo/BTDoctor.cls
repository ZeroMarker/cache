///     
Class dbo.BTDoctor Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_Doctor, StorageStrategy = Default ]
{

/// Foreign Key FKDoctorHospital created via DDL
ForeignKey FKDoctorHospital(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_DoctorHospital ];

/// Foreign Key FKDoctorPostionTitle created via DDL
ForeignKey FKDoctorPostionTitle(PositionTitleDR) References dbo.BTPositionTitle(PKBTPOSITIONTITLE) [ SqlName = FK_DoctorPostionTitle ];

Index IndexCode On (HospitalDR, Code) [ SqlName = Index_Code, Type = index, Unique ];

Index IndexHISCode On (HospitalDR, HISCode) [ SqlName = Index_HISCode, Type = index ];

Index IndexSequence On (Sequence, HospitalDR) [ SqlName = Index_Sequence, Type = index ];

/// DDL Primary Key Specification
Index PKBTDOCTOR On RowID [ PrimaryKey, SqlName = PK_BT_DOCTOR, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 4 ];

Property HISCode As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 5 ];

Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

Property Telephone As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 7 ];

Property PositionTitleDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 10 ];

Storage Default
{
<Data name="BTDoctorDefaultData">
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
<Value>HISCode</Value>
</Value>
<Value name="5">
<Value>HospitalDR</Value>
</Value>
<Value name="6">
<Value>Telephone</Value>
</Value>
<Value name="7">
<Value>PositionTitleDR</Value>
</Value>
<Value name="8">
<Value>Sequence</Value>
</Value>
<Value name="9">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BTDoctorD</DataLocation>
<DefaultData>BTDoctorDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTDoctorD</IdLocation>
<IndexLocation>^dbo.BTDoctorI</IndexLocation>
<StreamLocation>^dbo.BTDoctorS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
