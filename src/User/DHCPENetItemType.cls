/// 网上套餐项目分类字典表
Class User.DHCPENetItemType Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ SqlTableName = DHC_PE_NetItemType ]
{

Parameter ClassName = "User.DHCPENetItemType";

/// 分类描述
Property NITDesc As %String [ Required, SqlFieldName = NIT_Desc ];

Index NITDescIndex On NITDesc [ Unique ];

/// 是否使用Y使用
Property NITUseFlag As %String(MAXLEN = 1) [ Required, SqlFieldName = NIT_UseFlag ];

/// 更新日期
Property NITUpdateDate As %Date [ SqlFieldName = NIT_UpdateDate ];

/// 更新时间
Property NITUpdateTime As %Time [ SqlFieldName = NIT_UpdateTime ];

/// 更信人 指向SS_User
Property NITUpdateUserDR As %String [ SqlFieldName = NIT_UpdateUserDR ];

Storage Default
{
<Data name="DHCPENetItemTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>NITDesc</Value>
</Value>
<Value name="3">
<Value>NITUseFlag</Value>
</Value>
<Value name="4">
<Value>NITUpdateDate</Value>
</Value>
<Value name="5">
<Value>NITUpdateTime</Value>
</Value>
<Value name="6">
<Value>NITUpdateUserDR</Value>
</Value>
</Data>
<DataLocation>^User.DHCPENetItemTypeD</DataLocation>
<DefaultData>DHCPENetItemTypeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCPENetItemTypeD</IdLocation>
<IndexLocation>^User.DHCPENetItemTypeI</IndexLocation>
<StreamLocation>^User.DHCPENetItemTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
