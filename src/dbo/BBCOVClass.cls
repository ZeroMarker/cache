///     
Class dbo.BBCOVClass Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_COVClass, StorageStrategy = Default ]
{

/// Foreign Key FKCOVClass created via DDL
ForeignKey FKCOVClass(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_COVClass ];

Index IndexCode On (HospitalDR, Code) [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSequence On (HospitalDR, Sequence) [ SqlName = Index_Sequence, Type = index ];

/// DDL Primary Key Specification
Index PKBBCOVCLASS On RowID [ PrimaryKey, SqlName = PK_BB_COVCLASS, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 4 ];

Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="BBCOVClassDefaultData">
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
<Value>HospitalDR</Value>
</Value>
<Value name="5">
<Value>Sequence</Value>
</Value>
<Value name="6">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BBCOVClassD</DataLocation>
<DefaultData>BBCOVClassDefaultData</DefaultData>
<IdLocation>^dbo.BBCOVClassD</IdLocation>
<IndexLocation>^dbo.BBCOVClassI</IndexLocation>
<StreamLocation>^dbo.BBCOVClassS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
