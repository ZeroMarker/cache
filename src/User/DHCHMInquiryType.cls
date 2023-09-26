/// Description：问诊类型表
/// Creator：wangguoying
Class User.DHCHMInquiryType Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Inheritance = right, SqlTableName = DHC_HM_InquiryType ]
{

Parameter ClassName = "User.DHCHMInquiryType";

Relationship ITResult As User.DHCHMInquiryResult [ Cardinality = children, Inverse = IRParRef ];

/// 代码
Property ITCode As %String [ Required, SqlColumnNumber = 2, SqlFieldName = IT_Code ];

/// 描述
Property ITDesc As %String [ Required, SqlColumnNumber = 3, SqlFieldName = IT_Desc ];

/// 序号
Property ITSort As %Integer [ SqlColumnNumber = 4, SqlFieldName = IT_Sort ];

/// 作废标记
Property ITNoActive As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlFieldName = IT_NoActive ];

/// 更新日期
Property ITUpdateDate As %Date [ SqlFieldName = IT_UpdateDate ];

/// 更新时间
Property ITUpdateTime As %Time [ SqlFieldName = IT_UpdateTime ];

/// 更信人 指向SS_User
Property ITUpdateUserDR As %String [ SqlFieldName = IT_UpdateUserDR ];

Index SortIndex On ITSort;

Index CodeIndex On ITCode [ Unique ];

Storage Default
{
<Data name="DHCHMInquiryTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ITCode</Value>
</Value>
<Value name="3">
<Value>ITDesc</Value>
</Value>
<Value name="4">
<Value>ITSort</Value>
</Value>
<Value name="5">
<Value>ITNoActive</Value>
</Value>
<Value name="6">
<Value>ITUpdateDate</Value>
</Value>
<Value name="7">
<Value>ITUpdateTime</Value>
</Value>
<Value name="8">
<Value>ITUpdateUserDR</Value>
</Value>
</Data>
<DataLocation>^User.DHCHMInquiryTypeD</DataLocation>
<DefaultData>DHCHMInquiryTypeDefaultData</DefaultData>
<IdLocation>^User.DHCHMInquiryTypeD</IdLocation>
<IndexLocation>^User.DHCHMInquiryTypeI</IndexLocation>
<StreamLocation>^User.DHCHMInquiryTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
