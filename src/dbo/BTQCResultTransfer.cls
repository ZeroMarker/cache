Class dbo.BTQCResultTransfer Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTQC_ResultTransfer ]
{

/// Foreign Key FKQCResultTransferHospital created via DDL
ForeignKey FKQCResultTransferHospital(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_QCResultTransferHospital ];

Index IndexMaster On (HospitalDR, OldResult) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTQCRESULTTRANSFER On RowID [ PrimaryKey, SqlName = PK_BTQC_TRANSFER, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 老结果  
Property OldResult As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ Required, SqlColumnNumber = 3 ];

/// 医院  
Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

/// 新结果  
Property NewResult As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 5 ];

/// 序号  
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Storage Default
{
<Data name="BTQCResultTransferDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OldResult</Value>
</Value>
<Value name="3">
<Value>HospitalDR</Value>
</Value>
<Value name="4">
<Value>NewResult</Value>
</Value>
<Value name="5">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^dbo.BTQCResultTransferD</DataLocation>
<DefaultData>BTQCResultTransferDefaultData</DefaultData>
<IdLocation>^dbo.BTQCResultTransferD</IdLocation>
<IndexLocation>^dbo.BTQCResultTransferI</IndexLocation>
<StreamLocation>^dbo.BTQCResultTransferS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
