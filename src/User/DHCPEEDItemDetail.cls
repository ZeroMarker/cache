/// 危害因素关联检查细项
Class User.DHCPEEDItemDetail Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ SqlTableName = DHC_PE_EDItemDetail ]
{

Parameter ClassName = "User.DHCPEEDItemDetail";

Relationship EDDParref As User.DHCPEEDItem [ Cardinality = parent, Inverse = EDItemDetailChild ];

/// 重点检查项目细项ID
Property EDIDDetailDR As User.DHCPEOrderDetail [ Required, SqlFieldName = EDID_DetailDR ];

/// 激活 Y N
Property EDIActive As %String(MAXLEN = 1) [ SqlFieldName = EDI_Active ];

/// 重点检查项目扩展信息
Property EDIExpInfo As %String(MAXLEN = 10) [ SqlFieldName = EDI_ExpInfo ];

/// 备注
Property EDIRemark As %String(MAXLEN = 200) [ SqlFieldName = EDI_Remark ];

/// 更新日期
Property EDIUpdateDate As %Date [ SqlFieldName = EDI_UpdateDate ];

/// 更新时间
Property EDIUpdateTime As %Time [ SqlFieldName = EDI_UpdateTime ];

/// 更信人 指向SS_User
Property EDIUpdateUserDR As %String [ SqlFieldName = EDI_UpdateUserDR ];

/// 细项的索引
Index DetailDRIndex On EDIDDetailDR;

Storage Default
{
<Data name="DHCPEEDItemDetailDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EDIDDetailDR</Value>
</Value>
<Value name="3">
<Value>EDIActive</Value>
</Value>
<Value name="4">
<Value>EDIExpInfo</Value>
</Value>
<Value name="5">
<Value>EDIRemark</Value>
</Value>
<Value name="6">
<Value>EDIUpdateDate</Value>
</Value>
<Value name="7">
<Value>EDIUpdateTime</Value>
</Value>
<Value name="8">
<Value>EDIUpdateUserDR</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("EDItemDetailChild")</DataLocation>
<DefaultData>DHCPEEDItemDetailDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCPEEDItemC("EDItemDetailChild")</IdLocation>
<IndexLocation>^User.DHCPEEDItemDetailI</IndexLocation>
<StreamLocation>^User.DHCPEEDItemDetailS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
