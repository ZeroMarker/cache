/// Description：问诊知识库与调查问卷内容选项关联
/// Creator：wangguoying
Class User.DHCHMInquiryOptionRelate Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ SqlTableName = DHC_HM_InquiryOptionRelate ]
{

Parameter ClassName = "User.DHCHMInquiryOptionRelate";

Relationship IORParRef As User.DHCHMInquiryQuesRelate [ Cardinality = parent, Inverse = IQROption ];

Property IOROptionDR As User.DHCHMCQDOptions [ Required, SqlColumnNumber = 2, SqlFieldName = IOR_Option_DR ];

Index ParRefOptionIndex On (IORParRef, IOROptionDR) [ Unique ];

Storage Default
{
<Data name="DHCHMInquiryOptionRelateDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IOROptionDR</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("IQROption")</DataLocation>
<DefaultData>DHCHMInquiryOptionRelateDefaultData</DefaultData>
<IdLocation>^User.DHCHMInquiryQuesRelateC("IQROption")</IdLocation>
<IndexLocation>^User.DHCHMInquiryOptionRelateI</IndexLocation>
<StreamLocation>^User.DHCHMInquiryOptionRelateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
