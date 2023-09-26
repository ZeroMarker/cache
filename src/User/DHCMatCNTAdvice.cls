Class User.DHCMatCNTAdvice Extends (%Persistent, User.Abstract) [ SqlTableName = DHC_MatCNT_Advice, StorageStrategy = Storage ]
{

/// 建议代码
Property MATCACode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = MATCA_Code ];

/// 建议描述
Property MATCADesc As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = MATCA_Desc ];

/// 院区ID
Property MATCAHospDR As User.CTHospital [ SqlColumnNumber = 4, SqlFieldName = MATCA_Hosp_DR ];

Storage Storage
{
<Data name="DHCMatCNTAdviceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MATCACode</Value>
</Value>
<Value name="3">
<Value>MATCADesc</Value>
</Value>
<Value name="4">
<Value>MATCAHospDR</Value>
</Value>
</Data>
<DataLocation>^User.DHCMatCNTAdviceD</DataLocation>
<DefaultData>DHCMatCNTAdviceDefaultData</DefaultData>
<IdLocation>^User.DHCMatCNTAdviceD</IdLocation>
<IndexLocation>^User.DHCMatCNTAdviceI</IndexLocation>
<StreamLocation>^User.DHCMatCNTAdviceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
