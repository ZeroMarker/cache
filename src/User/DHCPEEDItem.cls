/// 危害因素关联检查项目
Class User.DHCPEEDItem Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ SqlTableName = DHC_PE_EDItem ]
{

Parameter ClassName = "User.DHCPEEDItem";

Relationship EDIParref As User.DHCPEEndanger [ Cardinality = parent, Inverse = EDItemChild ];

/// 项目ID
Property EDIItemMastID As %String [ Required, SqlFieldName = EDI_ItemMast_ID ];

/// 必选标志 Y必选 N不必选
Property EDINeedFlag As %String(MAXLEN = 1) [ SqlFieldName = EDI_NeedFlag ];

/// 套餐标志 Y是 N不是
Property EDISetsFlag As %String(MAXLEN = 1) [ Required, SqlFieldName = EDI_SetsFlag ];

/// 检查种类
Property EDIOMETypeDR As User.DHCPEOMEType [ SqlFieldName = EDI_OMETypeDR ];

/// 激活，Y，N
Property EDIActive As %String(MAXLEN = 1) [ SqlFieldName = EDI_Active ];

/// 检查项目扩展信息
Property EDIExpInfo As %String(MAXLEN = 10) [ SqlFieldName = EDI_ExpInfo ];

/// 备注
Property EDIRemark As %String(MAXLEN = 200) [ SqlFieldName = EDI_Remark ];

/// 更新日期
Property EDIUpdateDate As %Date [ SqlFieldName = EDI_UpdateDate ];

/// 更新时间
Property EDIUpdateTime As %Time [ SqlFieldName = EDI_UpdateTime ];

/// 更信人 指向SS_User
Property EDIUpdateUserDR As %String [ SqlFieldName = EDI_UpdateUserDR ];

/// 检查项目中重点检查内容维护
Relationship EDItemDetailChild As User.DHCPEEDItemDetail [ Cardinality = children, Inverse = EDDParref ];

Index ItemIDIndex On EDIItemMastID;

Storage Default
{
<Data name="DHCPEEDItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EDIItemMastID</Value>
</Value>
<Value name="3">
<Value>EDINeedFlag</Value>
</Value>
<Value name="4">
<Value>EDISetsFlag</Value>
</Value>
<Value name="5">
<Value>EDIOMETypeDR</Value>
</Value>
<Value name="6">
<Value>EDIActive</Value>
</Value>
<Value name="7">
<Value>EDIExpInfo</Value>
</Value>
<Value name="8">
<Value>EDIRemark</Value>
</Value>
<Value name="9">
<Value>EDIEndangerDR</Value>
</Value>
<Value name="10">
<Value>EDIUpdateDate</Value>
</Value>
<Value name="11">
<Value>EDIUpdateTime</Value>
</Value>
<Value name="12">
<Value>EDIUpdateUserDR</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("EDItemChild")</DataLocation>
<DefaultData>DHCPEEDItemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCPEEndangerC("EDItemChild")</IdLocation>
<IndexLocation>^User.DHCPEEDItemI</IndexLocation>
<StreamLocation>^User.DHCPEEDItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
