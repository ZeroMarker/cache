/// 参数配置表
Class User.CSSDParameter Extends (%Persistent, User.Abstract) [ SqlTableName = CSSD_Parameter ]
{

Relationship ChildParameterItm As User.CSSDParameterItm [ Cardinality = children, Inverse = ParameterItmParRef ];

/// 参数编码
Property CSSDPParaCode As %String(COLLATION = "Exact") [ SqlColumnNumber = 2, SqlFieldName = CSSDP_ParaCode ];

Property CSSDPParaName As %String(COLLATION = "Exact") [ SqlColumnNumber = 3, SqlFieldName = CSSDP_ParaName ];

Property CSSDPParaValue As %String(COLLATION = "Exact", TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = CSSDP_ParaValue ];

Property CSSDPCType As User.CSSDBaseDataType [ SqlColumnNumber = 5, SqlFieldName = CSSDDP_BaseTypeDr ];

/// 参数描述
Property CSSDPCParaDesc As %String(COLLATION = "Exact", TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = CSSDP_ParaDesc ];

Property CSSDPParaExplain As %String(COLLATION = "Exact", TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = CSSDP_ParaExplain ];

Index IndexCSSDPCType On CSSDPCType As Exact;

Index IndexCSSDPCCode On CSSDPParaCode As Exact;

Index IndexCSSDPCDESC On CSSDPParaName As Exact;

Index IndexCSSDPParaCodeType On (CSSDPParaCode As Exact, CSSDPCType As Exact);

Index IndexCSSDPParaDescType On (CSSDPParaName As Exact, CSSDPCType As Exact);

Storage Default
{
<Data name="CSSDParameterDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CSSDPParaCode</Value>
</Value>
<Value name="3">
<Value>CSSDPParaName</Value>
</Value>
<Value name="4">
<Value>CSSDPParaValue</Value>
</Value>
<Value name="5">
<Value>CSSDPCType</Value>
</Value>
<Value name="6">
<Value>CSSDPCParaDesc</Value>
</Value>
<Value name="7">
<Value>CSSDPParaExplain</Value>
</Value>
</Data>
<DataLocation>^User.CSSDParameterD</DataLocation>
<DefaultData>CSSDParameterDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.CSSDParameterD</IdLocation>
<IndexLocation>^User.CSSDParameterI</IndexLocation>
<StreamLocation>^User.CSSDParameterS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
