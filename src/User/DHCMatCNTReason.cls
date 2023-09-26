Class User.DHCMatCNTReason Extends (%Persistent, User.Abstract) [ SqlTableName = DHC_MatCNT_Reason, StorageStrategy = Storage ]
{

/// 原因代码
Property MATCRCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = MATCR_Code ];

/// 原因描述
Property MATCRDesc As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = MATCR_Desc ];

/// 上级原因ROWID
Property MATCRIDDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = MATCRID_DR ];

/// 院区ID
Property MATCRHospDR As User.CTHospital [ SqlColumnNumber = 5, SqlFieldName = MATCR_Hosp_DR ];

Storage Storage
{
<Data name="DHCMatCNTReasonDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MATCRCode</Value>
</Value>
<Value name="3">
<Value>MATCRDesc</Value>
</Value>
<Value name="4">
<Value>MATCRIDDR</Value>
</Value>
<Value name="5">
<Value>MATCRHospDR</Value>
</Value>
</Data>
<DataLocation>^User.DHCMatCNTReasonD</DataLocation>
<DefaultData>DHCMatCNTReasonDefaultData</DefaultData>
<IdLocation>^User.DHCMatCNTReasonD</IdLocation>
<IndexLocation>^User.DHCMatCNTReasonI</IndexLocation>
<StreamLocation>^User.DHCMatCNTReasonS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
