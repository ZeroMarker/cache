Class User.DHCPersonDetail Extends (%Persistent, User.Abstract) [ SqlTableName = DHC_PersonDetail ]
{

/// 机构ID(供应商或生产厂家)
Property PERDOrgId As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 2, SqlFieldName = PERD_OrgId ];

/// 机构类型(Vendor代表供应商, Manf代表生产厂家, Carrier代表配送商)
Property PERDOrgType As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 3, SqlFieldName = PERD_OrgType ];

/// 人员类型
Property PERDType As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 4, SqlFieldName = PERD_Type ];

/// 人员类型描述
Property PERDTypeDesc As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 5, SqlFieldName = PERD_TypeDesc ];

/// 姓名
Property PERDName As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 6, SqlFieldName = PERD_Name ];

/// 身份证
Property PERDCard As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 7, SqlFieldName = PERD_Card ];

/// 手机
Property PERDCarrTel As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 8, SqlFieldName = PERD_CarrTel ];

/// 电话
Property PERDTel As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 9, SqlFieldName = PERD_Tel ];

/// 邮箱
Property PERDEmail As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 10, SqlFieldName = PERD_Email ];

/// 传真
Property PERDFax As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 11, SqlFieldName = PERD_Fax ];

/// 授权开始日期
Property PERDStartDate As %Library.Date [ SqlColumnNumber = 12, SqlFieldName = PERD_StartDate ];

/// 授权截止日期
Property PERDEndDate As %Library.Date [ SqlColumnNumber = 13, SqlFieldName = PERD_EndDate ];

/// 授权截止日期
Property PERDShowFlag As %Library.String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 14, SqlFieldName = PERD_ShowFlag ];

Index OrgType On (PERDOrgType As Exact, PERDOrgId As Exact, PERDType As Exact);

Storage Default
{
<Data name="DHCPersonDetailDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PERDOrgId</Value>
</Value>
<Value name="3">
<Value>PERDOrgType</Value>
</Value>
<Value name="4">
<Value>PERDType</Value>
</Value>
<Value name="5">
<Value>PERDTypeDesc</Value>
</Value>
<Value name="6">
<Value>PERDName</Value>
</Value>
<Value name="7">
<Value>PERDCard</Value>
</Value>
<Value name="8">
<Value>PERDCarrTel</Value>
</Value>
<Value name="9">
<Value>PERDTel</Value>
</Value>
<Value name="10">
<Value>PERDEmail</Value>
</Value>
<Value name="11">
<Value>PERDFax</Value>
</Value>
<Value name="12">
<Value>PERDStartDate</Value>
</Value>
<Value name="13">
<Value>PERDEndDate</Value>
</Value>
<Value name="14">
<Value>PERDShowFlag</Value>
</Value>
</Data>
<DataLocation>^User.DHCPersonDetailD</DataLocation>
<DefaultData>DHCPersonDetailDefaultData</DefaultData>
<IdLocation>^User.DHCPersonDetailD</IdLocation>
<IndexLocation>^User.DHCPersonDetailI</IndexLocation>
<StreamLocation>^User.DHCPersonDetailS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
