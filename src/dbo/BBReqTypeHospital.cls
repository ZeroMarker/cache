Class dbo.BBReqTypeHospital Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_ReqTypeHospital, StorageStrategy = Default ]
{

/// Foreign Key FKBBRTestItemHospital created via DDL
ForeignKey FKBBRTestItemHospital(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_BB_RHos_Hospital ];

/// Foreign Key FKBBRTestItemReqType created via DDL
ForeignKey FKBBRTestItemReqType(ReqTypeDR) References dbo.BBReqType(PKBBREQTYPE) [ SqlName = FK_BB_RHos_ReqType ];

Index IndexMaster On (ReqTypeDR, HospitalDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexSeqNum On (HospitalDR, SeqNum) [ SqlName = Index_SeqNum, Type = index ];

/// DDL Primary Key Specification
Index PKBBREQTESTITEM On RowID [ PrimaryKey, SqlName = PK_BB_REQTYPEHOSPITAL, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property ReqTypeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Storage Default
{
<Data name="BBReqTypeHospitalDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ReqTypeDR</Value>
</Value>
<Value name="3">
<Value>HospitalDR</Value>
</Value>
<Value name="4">
<Value>SeqNum</Value>
</Value>
</Data>
<DataLocation>^dbo.BBReqTypeHospitalD</DataLocation>
<DefaultData>BBReqTypeHospitalDefaultData</DefaultData>
<IdLocation>^dbo.BBReqTypeHospitalD</IdLocation>
<IndexLocation>^dbo.BBReqTypeHospitalI</IndexLocation>
<StreamLocation>^dbo.BBReqTypeHospitalS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
