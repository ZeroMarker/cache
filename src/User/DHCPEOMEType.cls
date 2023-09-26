/// 职业健康检查种类
Class User.DHCPEOMEType Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ SqlTableName = DHC_PE_OMEType ]
{

Parameter ClassName = "User.DHCPEOMEType";

///  职业健康检查种类代码
Property OMETCode As %String(MAXLEN = 20) [ Required, SqlFieldName = OMET_Code ];

/// 职业健康检查种类描述
Property OMETDesc As %String(MAXLEN = 20) [ Required, SqlFieldName = OMET_Desc ];

/// 激活，Y，N
Property OMETActive As %String(MAXLEN = 1) [ SqlFieldName = OMET_Active ];

/// 【作废】VIP等级
Property OMETVIPLevel As %String [ SqlFieldName = OMET_VIPLevel ];

///  职业健康检查种类扩展信息
Property OMETExpInfo As %String(MAXLEN = 10) [ SqlFieldName = OMET_ExpInfo ];

///  备注
Property OMETRemark As %String(MAXLEN = 200) [ SqlFieldName = OMET_Remark ];

/// 代码索引
Index OMETCodeIndex On OMETCode [ Unique ];

/// 描述索引
Index OMETDescIndex On OMETDesc [ Unique ];

/// VIP等级索引
Index VIPLevelIndex On OMETVIPLevel As AlphaUp;

Storage Default
{
<Data name="DHCPEOMETypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OMETCode</Value>
</Value>
<Value name="3">
<Value>OMETDesc</Value>
</Value>
<Value name="4">
<Value>OMETActive</Value>
</Value>
<Value name="5">
<Value>OMETVIPLevel</Value>
</Value>
<Value name="6">
<Value>OMETExpInfo</Value>
</Value>
<Value name="7">
<Value>OMETRemark</Value>
</Value>
</Data>
<DataLocation>^User.DHCPEOMETypeD</DataLocation>
<DefaultData>DHCPEOMETypeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCPEOMETypeD</IdLocation>
<IndexLocation>^User.DHCPEOMETypeI</IndexLocation>
<StreamLocation>^User.DHCPEOMETypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
