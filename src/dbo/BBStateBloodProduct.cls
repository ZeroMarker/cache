Class dbo.BBStateBloodProduct Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_StateBloodProduct, StorageStrategy = Default ]
{

/// Foreign Key FKBBBPorductHospital created via DDL
ForeignKey FKBBBPorductHospital(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_BB_BPorduct_Hospital ];

Index IndexCode On (HospitalDR, Code) [ SqlName = Index_Code, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBBStateBLOODPRODUCT On RowID [ PrimaryKey, SqlName = PK_BBState_BLOODPRODUCT, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ Required, SqlColumnNumber = 4 ];

Property EName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 5 ];

Property Synonym As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 6 ];

Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

Storage Default
{
<Data name="BBStateBloodProductDefaultData">
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
<Value>EName</Value>
</Value>
<Value name="5">
<Value>Synonym</Value>
</Value>
<Value name="6">
<Value>HospitalDR</Value>
</Value>
<Value name="7">
<Value>BloodProductDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BBStateBloodProductD</DataLocation>
<DefaultData>BBStateBloodProductDefaultData</DefaultData>
<IdLocation>^dbo.BBStateBloodProductD</IdLocation>
<IndexLocation>^dbo.BBStateBloodProductI</IndexLocation>
<StreamLocation>^dbo.BBStateBloodProductS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
