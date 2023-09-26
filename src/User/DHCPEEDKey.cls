/// 建议关键词表
Class User.DHCPEEDKey Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ SqlTableName = DHC_PE_EDKey ]
{

Parameter ClassName = "User.DHCPEEDKey";

/// 关键词
Property EDKDesc As %String [ SqlFieldName = EDK_Desc ];

/// 颜色
Property EDKColor As %String [ SqlFieldName = EDK_Color ];

/// 作废标记
Property EDKNoActive As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlFieldName = EDK_NoActive ];

/// 更新日期
Property EDKUpdateDate As %Date [ SqlFieldName = EDK_UpdateDate ];

/// 更新时间
Property EDKUpdateTime As %Time [ SqlFieldName = EDK_UpdateTime ];

/// 更信人 指向SS_User
Property EDKUpdateUserDR As %String [ SqlFieldName = EDK_UpdateUserDR ];

// Index EDKDescIndex On EDKDesc [ Unique ];

Index EDKDescIndex On EDKDesc;

Storage Default
{
<Data name="DHCPEEDKeyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EDKDesc</Value>
</Value>
<Value name="3">
<Value>EDKColor</Value>
</Value>
<Value name="4">
<Value>EDKNoActive</Value>
</Value>
<Value name="5">
<Value>EDKUpdateDate</Value>
</Value>
<Value name="6">
<Value>EDKUpdateTime</Value>
</Value>
<Value name="7">
<Value>EDKUpdateUserDR</Value>
</Value>
</Data>
<DataLocation>^User.DHCPEEDKeyD</DataLocation>
<DefaultData>DHCPEEDKeyDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCPEEDKeyD</IdLocation>
<IndexLocation>^User.DHCPEEDKeyI</IndexLocation>
<StreamLocation>^User.DHCPEEDKeyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
