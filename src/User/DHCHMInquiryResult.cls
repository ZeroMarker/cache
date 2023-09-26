/// Description:问诊结果表
/// Creator:wangguoying
Class User.DHCHMInquiryResult Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Inheritance = right, SqlTableName = DHC_HM_InquiryResult ]
{

Parameter ClassName = "User.DHCHMInquiryResult";

Relationship IRParRef As User.DHCHMInquiryType [ Cardinality = parent, Inverse = ITResult ];

Relationship IRDetail As User.DHCHMInquiryResultDetail [ Cardinality = children, Inverse = IRDParRef ];

/// 代码
Property IRCode As %String [ Required, SqlColumnNumber = 2, SqlFieldName = IR_Code ];

/// 描述
Property IRDesc As %String [ Required, SqlColumnNumber = 3, SqlFieldName = IR_Desc ];

/// 序号
Property IRSort As %Integer [ Required, SqlColumnNumber = 4, SqlFieldName = IR_Sort ];

/// 类名  需要通过复杂计算关联此结果时，需要配置类方法名来实现关联关系
Property IRClassName As %String [ SqlColumnNumber = 5, SqlFieldName = IR_ClassName ];

/// 方法名
Property IRMethodName As %String [ SqlColumnNumber = 6, SqlFieldName = IR_MethodName ];

/// 作废标记
Property IRNoActive As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlFieldName = IR_NoActive ];

/// 更新日期
Property IRUpdateDate As %Date [ SqlFieldName = IR_UpdateDate ];

/// 更新时间
Property IRUpdateTime As %Time [ SqlFieldName = IR_UpdateTime ];

/// 更信人 指向SS_User
Property IRUpdateUserDR As %String [ SqlFieldName = IR_UpdateUserDR ];

Index SortIndex On (IRParRef, IRSort) [ Unique ];

Index CodeIndex On (IRParRef, IRCode) [ Unique ];

Storage Default
{
<Data name="DHCHMInquiryResultDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IRCode</Value>
</Value>
<Value name="3">
<Value>IRDesc</Value>
</Value>
<Value name="4">
<Value>IRSort</Value>
</Value>
<Value name="5">
<Value>IRClassName</Value>
</Value>
<Value name="6">
<Value>IRMethodName</Value>
</Value>
<Value name="7">
<Value>IRNoActive</Value>
</Value>
<Value name="8">
<Value>IRUpdateDate</Value>
</Value>
<Value name="9">
<Value>IRUpdateTime</Value>
</Value>
<Value name="10">
<Value>IRUpdateUserDR</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ITResult")</DataLocation>
<DefaultData>DHCHMInquiryResultDefaultData</DefaultData>
<IdLocation>^User.DHCHMInquiryTypeC("ITResult")</IdLocation>
<IndexLocation>^User.DHCHMInquiryResultI</IndexLocation>
<StreamLocation>^User.DHCHMInquiryResultS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
