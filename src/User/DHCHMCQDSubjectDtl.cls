/// 问卷量表(主题)与问题关联表
Class User.DHCHMCQDSubjectDtl Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Inheritance = right, SqlTableName = DHC_HM_CQDSubjectDtl ]
{

Parameter ClassName = "User.DHCHMCQDSubjectDtl";

Relationship QDSDParRef As User.DHCHMCQDSubject [ Cardinality = parent, Inverse = ChildDtl ];

/// 问卷问题
Property QDSDQustionDetailDR As User.DHCHMCQuestionsDetail [ Required, SqlFieldName = QDSD_QustionDetail_DR ];

/// 问题分类
Property QDSDSubjectCatDR As User.DHCHMCQDSubjectCat [ Required, SqlFieldName = QDSD_SubjectCatDR ];

/// 是否必填项
Property QDSDRequired As %String [ SqlFieldName = QDSD_Required ];

/// 默认值
Property QDSDDefvalue As %String [ SqlFieldName = QDSD_Defvalue ];

/// 显示编号
Property QDSDNumber As %String [ SqlFieldName = QDSD_Number ];

/// 顺序号
Property QDSDSort As %Integer [ Required, SqlFieldName = QDSD_Sort ];

/// 激活
Property QDSDActive As %String(DISPLAYLIST = ",Yes,No", VALUELIST = ",Y,N") [ Required, SqlFieldName = QDSD_Active ];

/// 更新日期
Property QDSDUpdateDate As %Date [ SqlFieldName = QDSD_UpdateDate ];

/// 更新时间
Property QDSDUpdateTime As %Time [ SqlFieldName = QDSD_UpdateTime ];

/// 更新人 指向SS_User
Property QDSDUpdateUserDR As %String [ SqlFieldName = QDSD_UpdateUser_DR ];

/// 父节点
Property QDSDParentDR As %String(COLLATION = "ALPHAUP") [ SqlFieldName = QDSD_ParentDR ];

/// 顺序号 索引
Index IndexParRefSort On (QDSDParRef, QDSDSort);

/// 不同分类下可能存在重复问题，把唯一索引去掉了
Index IndexDetailParRef On (QDSDQustionDetailDR, QDSDParRef);

/// 不同分类下可能存在重复问题，相同分类下不允许重复
Index IdxOfSubjectCatDtl On (QDSDParRef, QDSDSubjectCatDR, QDSDQustionDetailDR) [ Unique ];

/// 分类+顺序号 索引
Index IdxOfSubjectCatSort On (QDSDParRef, QDSDSubjectCatDR, QDSDSort);

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>QDSDQustionDetailDR</Value>
</Value>
<Value name="3">
<Value>QDSDActive</Value>
</Value>
<Value name="4">
<Value>QDSDUpdateDate</Value>
</Value>
<Value name="5">
<Value>QDSDUpdateTime</Value>
</Value>
<Value name="6">
<Value>QDSDUpdateUserDR</Value>
</Value>
<Value name="7">
<Value>QDSDSort</Value>
</Value>
<Value name="8">
<Value>QDSDParentDR</Value>
</Value>
<Value name="9">
<Value>QDSDSubjectCatDR</Value>
</Value>
<Value name="10">
<Value>QDSDRequired</Value>
</Value>
<Value name="11">
<Value>QDSDDefvalue</Value>
</Value>
<Value name="12">
<Value>QDSDNumber</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("DTL")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>{%%PARENT}("DTL")</IdLocation>
<IndexLocation>^CT.PE.HM.CQDSubjectI("DTL")</IndexLocation>
<StreamLocation>^User.DHCHMCQDSubjectDtlS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
