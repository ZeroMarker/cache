Class User.DHCPEContract Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ SqlTableName = DHC_PE_Contract ]
{

Parameter ClassName = "User.DHCPEContract";

/// 合同编号
Property CNo As %String [ Required, SqlFieldName = C_No ];

/// 合同名称
Property CName As %String(MAXLEN = 200) [ Required, SqlFieldName = C_Name ];

/// 备注
Property CRemark As %String(MAXLEN = 500) [ SqlFieldName = C_Remark ];

/// 创建人
Property CCreateUserDR As User.SSUser [ Required, SqlFieldName = C_CreateUser_DR ];

/// 创建日期
Property CCreateDate As %Date [ SqlFieldName = C_CreateDate ];

/// 创建时间
Property CCreateTime As %Time [ SqlFieldName = C_CreateTime ];

/// 体检科室
Property CDepartCodeDR As User.CTLoc [ Required, SqlFieldName = C_DepartCode_DR ];

/// 签订日期
Property CSignDate As %Date [ SqlFieldName = C_SignDate ];

/// 合同编号索引
Index CNoIndex On CNo [ Unique ];

/// 姓名索引
Index NameIndex On CName As AlphaUp;

/// 创建日期索引
Index DateIndex On CCreateDate;

/// 签订日期索引
Index SignDateIndex On CSignDate;

Storage Default
{
<Data name="DHCPEContractDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CNo</Value>
</Value>
<Value name="3">
<Value>CName</Value>
</Value>
<Value name="4">
<Value>CRemark</Value>
</Value>
<Value name="5">
<Value>CCreateUserDR</Value>
</Value>
<Value name="6">
<Value>CCreateDate</Value>
</Value>
<Value name="7">
<Value>CCreateTime</Value>
</Value>
<Value name="8">
<Value>CDepartCodeDR</Value>
</Value>
<Value name="9">
<Value>CSignDate</Value>
</Value>
</Data>
<DataLocation>^User.DHCPEContractD</DataLocation>
<DefaultData>DHCPEContractDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCPEContractD</IdLocation>
<IndexLocation>^User.DHCPEContractI</IndexLocation>
<StreamLocation>^User.DHCPEContractS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
