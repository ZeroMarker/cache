/// 体检特殊客户类型维护
Class User.DHCPESpecialType Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ SqlTableName = DHC_PE_SpecialType ]
{

Parameter ClassName = "User.DHCPESpecialType";

/// 代码
Property SPTCode As %String [ Required, SqlFieldName = SPT_Code ];

Index SPTCodeIndex On SPTCode [ Unique ];

/// 描述
Property SPTDesc As %String [ Required, SqlFieldName = SPT_Desc ];

Index SPTDescIndex On SPTDesc [ Unique ];

/// 激活标志
Property SPTActiveFlag As %String [ SqlFieldName = SPT_ActiveFlag ];

/// 备注
Property SPTRemark As %String [ SqlFieldName = SPT_Remark ];

Storage Default
{
<Data name="DHCPESpecialTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SPTCode</Value>
</Value>
<Value name="3">
<Value>SPTDesc</Value>
</Value>
<Value name="4">
<Value>SPTActiveFlag</Value>
</Value>
<Value name="5">
<Value>SPTRemark</Value>
</Value>
</Data>
<DataLocation>^User.DHCPESpecialTypeD</DataLocation>
<DefaultData>DHCPESpecialTypeDefaultData</DefaultData>
<IdLocation>^User.DHCPESpecialTypeD</IdLocation>
<IndexLocation>^User.DHCPESpecialTypeI</IndexLocation>
<StreamLocation>^User.DHCPESpecialTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
