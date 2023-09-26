Class dbo.BBDefectType Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_DefectType ]
{

Index IndexCode On (HospitalDR, Code) [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSeqNum On (HospitalDR, SeqNum) [ SqlName = Index_SeqNum, Type = index ];

/// Foreign Key FKBBDefTypeHospital created via DDL
ForeignKey FKBBDefTypeHospital(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_BB_DefType_Hospital ];

/// DDL Primary Key Specification
Index PKBBDEFECTTYPE On RowID [ PrimaryKey, SqlName = PK_BB_DEFECTTYPE, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ Required, SqlColumnNumber = 4 ];

Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Storage Default
{
<Data name="BBDefectTypeDefaultData">
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
<Value>SeqNum</Value>
</Value>
</Data>
<DataLocation>^dbo.BBDefectTypeD</DataLocation>
<DefaultData>BBDefectTypeDefaultData</DefaultData>
<IdLocation>^dbo.BBDefectTypeD</IdLocation>
<IndexLocation>^dbo.BBDefectTypeI</IndexLocation>
<StreamLocation>^dbo.BBDefectTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
