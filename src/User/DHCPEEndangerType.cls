Class User.DHCPEEndangerType Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ SqlTableName = DHC_PE_EndangerType ]
{

Parameter ClassName = "User.DHCPEEndangerType";

/// 危害因素分类代码
Property EDTCode As %String(MAXLEN = 20) [ Required, SqlFieldName = EDT_Code ];

/// 危害因素分类描述
Property EDTDesc As %String(MAXLEN = 20) [ Required, SqlFieldName = EDT_Desc ];

///  激活，Y，N
Property EDTActive As %String(MAXLEN = 1) [ SqlFieldName = EDT_Active ];

///  VIP等级
Property EDTVIPLevel As %Integer [ Required, SqlFieldName = EDT_VIPLevel ];

///  危害因素分类扩展信息
Property EDTExpInfo As %String(MAXLEN = 10) [ SqlFieldName = EDT_ExpInfo ];

///  备注
Property EDTRemark As %String(MAXLEN = 200) [ SqlFieldName = EDT_Remark ];

/// 代码索引
Index EDTCodeIndex On EDTCode [ Unique ];

/// 描述索引
Index EDTDescIndex On EDTDesc [ Unique ];

/// VIP等级索引
Index VIPLevelIndex On EDTVIPLevel As AlphaUp;

Storage Default
{
<Data name="DHCPEEndangerTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EDTCode</Value>
</Value>
<Value name="3">
<Value>EDTDesc</Value>
</Value>
<Value name="4">
<Value>EDTActive</Value>
</Value>
<Value name="5">
<Value>EDTVIPLevel</Value>
</Value>
<Value name="6">
<Value>EDTExpInfo</Value>
</Value>
<Value name="7">
<Value>EDTRemark</Value>
</Value>
</Data>
<DataLocation>^User.DHCPEEndangerTypeD</DataLocation>
<DefaultData>DHCPEEndangerTypeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCPEEndangerTypeD</IdLocation>
<IndexLocation>^User.DHCPEEndangerTypeI</IndexLocation>
<StreamLocation>^User.DHCPEEndangerTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
