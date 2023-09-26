/// 问卷量表(主题)内容分类表
Class User.DHCHMCQDSubjectCat Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Inheritance = right, SqlTableName = DHC_HM_CQDSubjectCat ]
{

Parameter ClassName = "User.DHCHMCQDSubjectCat";

Relationship QDSCParRef As User.DHCHMCQDSubject [ Cardinality = parent, Inverse = ChildCat ];

/// 分类代码
Property QDSCCode As %String [ Required, SqlFieldName = QDSC_Code ];

/// 内容分类
Property QDSCDesc As %String(MAXLEN = 300) [ Required, SqlFieldName = QDSC_Desc ];

/// 显示编号
Property QDSCNumber As %String [ SqlFieldName = QDSC_Number ];

/// 顺序号
Property QDSCSort As %Integer [ Required, SqlFieldName = QDSC_Sort ];

/// 激活
Property QDSCActive As %String(DISPLAYLIST = ",Yes,No", VALUELIST = ",Y,N") [ Required, SqlFieldName = QDSC_Active ];

/// 更新日期
Property QDSCUpdateDate As %Date [ SqlFieldName = QDSC_UpdateDate ];

/// 更新时间
Property QDSCUpdateTime As %Time [ SqlFieldName = QDSC_UpdateTime ];

/// 更新人 指向SS_User
Property QDSCUpdateUserDR As %String [ SqlFieldName = QDSC_UpdateUser_DR ];

/// 父节点
Property QDSCParentDR As %String(COLLATION = "ALPHAUP") [ SqlFieldName = QDSC_ParentDR ];

Index IdxOfParRefSort On (QDSCParRef, QDSCSort);

Index IdxOfParRefDesc On (QDSCParRef, QDSCDesc);

Index IdxOfParRefCode On (QDSCParRef, QDSCCode) [ Unique ];

Storage Default
{
<Data name="DHCHMCQDSubjectCatDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>QDSCCode</Value>
</Value>
<Value name="3">
<Value>QDSCDesc</Value>
</Value>
<Value name="4">
<Value>QDSCNumber</Value>
</Value>
<Value name="5">
<Value>QDSCSort</Value>
</Value>
<Value name="6">
<Value>QDSCActive</Value>
</Value>
<Value name="7">
<Value>QDSCUpdateDate</Value>
</Value>
<Value name="8">
<Value>QDSCUpdateTime</Value>
</Value>
<Value name="9">
<Value>QDSCUpdateUserDR</Value>
</Value>
<Value name="10">
<Value>QDSCParentDR</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("CAT")</DataLocation>
<DefaultData>DHCHMCQDSubjectCatDefaultData</DefaultData>
<IdLocation>{%%PARENT}("CAT")</IdLocation>
<IndexLocation>^CT.PE.HM.CQDSubjectI("CAT")</IndexLocation>
<StreamLocation>^CT.PE.HM.CQDSubjectCatS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
