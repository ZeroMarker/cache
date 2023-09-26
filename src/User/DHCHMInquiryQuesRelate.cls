/// Description：问诊知识库与调查问卷内容关联
/// Creator：wangguoying
Class User.DHCHMInquiryQuesRelate Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ SqlTableName = DHC_HM_InquiryQuesRelate ]
{

Parameter ClassName = "User.DHCHMInquiryQuesRelate";

Relationship IQROption As User.DHCHMInquiryOptionRelate [ Cardinality = children, Inverse = IORParRef ];

/// 问诊结果
Property IQRResultDR As User.DHCHMInquiryResult [ Required, SqlColumnNumber = 2, SqlFieldName = IQR_Result_DR ];

/// 问卷问题
Property IQRQustionDetailDR As User.DHCHMCQuestionsDetail [ Required, SqlColumnNumber = 3, SqlFieldName = IQR_QustionDetail_DR ];

/// 拓展表达式
Property IQRExpression As %String [ SqlColumnNumber = 4, SqlFieldName = IQR_Expression ];

Index ResultDetailIndex On (IQRResultDR, IQRQustionDetailDR) [ Unique ];

Storage Default
{
<Data name="DHCHMInquiryQuesRelateDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IQRResultDR</Value>
</Value>
<Value name="3">
<Value>IQRQustionDetailDR</Value>
</Value>
<Value name="4">
<Value>IQRExpression</Value>
</Value>
</Data>
<DataLocation>^User.DHCHMInquiryQuesRelateD</DataLocation>
<DefaultData>DHCHMInquiryQuesRelateDefaultData</DefaultData>
<IdLocation>^User.DHCHMInquiryQuesRelateD</IdLocation>
<IndexLocation>^User.DHCHMInquiryQuesRelateI</IndexLocation>
<StreamLocation>^User.DHCHMInquiryQuesRelateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
