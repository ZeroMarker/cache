Class User.DHCCertDetail Extends %Persistent [ SqlTableName = DHC_CertDetail ]
{

/// 机构ID(供应商或生产厂家)
Property CERTOrgId As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 2, SqlFieldName = CERT_OrgId ];

/// 机构类型(Vendor代表供应商, Manf代表生产厂家, Carrier代表配送商)
Property CERTOrgType As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 3, SqlFieldName = CERT_OrgType ];

/// 资质类型
Property CERTType As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 4, SqlFieldName = CERT_Type ];

/// 资质类型名称
Property CERTName As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 5, SqlFieldName = CERT_Name ];

/// 证件编号
Property CERTText As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 6, SqlFieldName = CERT_Text ];

/// 发证机关
Property CERTIssuedDept As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 7, SqlFieldName = CERT_IssuedDept ];

/// 发证日期
Property CERTIssuedDate As %Library.Date [ SqlColumnNumber = 8, SqlFieldName = CERT_IssuedDate ];

/// 有效期截止
Property CERTDateTo As %Library.Date [ SqlColumnNumber = 9, SqlFieldName = CERT_DateTo ];

/// 长期标记(效期)
Property CERTBlankedFlag As %Library.String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = CERT_BlankedFlag ];

/// 延期标记
Property CERTDelayFlag As %Library.String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = CERT_DelayFlag ];

/// 延期有效期
Property CERTDelayDateTo As %Library.Date [ SqlColumnNumber = 12, SqlFieldName = CERT_DelayDateTo ];

/// 三证合一标记
Property CERTThreeInOneFlag As %Library.String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = CERT_ThreeInOneFlag ];

/// 有效期开始
Property CERTDateFrom As %Library.Date [ SqlColumnNumber = 14, SqlFieldName = CERT_DateFrom ];

/// 展示标记
Property CERTShowFlag As %Library.String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 15, SqlFieldName = CERT_ShowFlag ];

/// 平台资质id
Property CERTCloudID As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 16, SqlFieldName = CERT_CloudID ];

Index OrgType On (CERTOrgType As Exact, CERTOrgId As Exact, CERTType As Exact);

Storage Default
{
<Data name="DHCCertDetailDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CERTOrgId</Value>
</Value>
<Value name="3">
<Value>CERTOrgType</Value>
</Value>
<Value name="4">
<Value>CERTType</Value>
</Value>
<Value name="5">
<Value>CERTName</Value>
</Value>
<Value name="6">
<Value>CERTText</Value>
</Value>
<Value name="7">
<Value>CERTIssuedDept</Value>
</Value>
<Value name="8">
<Value>CERTIssuedDate</Value>
</Value>
<Value name="9">
<Value>CERTDateTo</Value>
</Value>
<Value name="10">
<Value>CERTBlankedFlag</Value>
</Value>
<Value name="11">
<Value>CERTDelayFlag</Value>
</Value>
<Value name="12">
<Value>CERTDelayDateTo</Value>
</Value>
<Value name="13">
<Value>CERTThreeInOneFlag</Value>
</Value>
<Value name="14">
<Value>CERTDateFrom</Value>
</Value>
<Value name="15">
<Value>CERTShowFlag</Value>
</Value>
<Value name="16">
<Value>CERTCloudID</Value>
</Value>
</Data>
<DataLocation>^User.DHCCertDetailD</DataLocation>
<DefaultData>DHCCertDetailDefaultData</DefaultData>
<IdLocation>^User.DHCCertDetailD</IdLocation>
<IndexLocation>^User.DHCCertDetailI</IndexLocation>
<StreamLocation>^User.DHCCertDetailS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
