/// 问卷内容维护
Class User.DHCHMCQuestionsDetail Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Inheritance = right, SqlTableName = DHC_HM_CQuestionsDetail ]
{

Parameter ClassName = "User.DHCHMCQuestionsDetail";

Relationship QDOptions As DHCHMCQDOptions [ Cardinality = children, Inverse = QDOParRef ];

Relationship QDLOrdSets As User.DHCHMCQDLinkOrdSets [ Cardinality = children, Inverse = QDLSParRef ];

Relationship QDLoc As User.DHCHMCQDetailLoc [ Cardinality = children, Inverse = CQDLParRef ];

/// 问题代码
Property QDCode As %String [ Required, SqlFieldName = QD_Code ];

/// 问题描述
Property QDDesc As %String(MAXLEN = 300) [ Required, SqlFieldName = QD_Desc ];

/// 项目类型（T说明型，N数值型， M多选型，S单选型，D日期型）
Property QDType As %String [ SqlFieldName = QD_Type ];

/// 单位
Property QDUnit As %String [ SqlFieldName = QD_Unit ];

/// 性别 指向CT_Sex
Property QDSex As %String [ SqlFieldName = QD_Sex ];

/// 激活
Property QDActive As %String [ SqlFieldName = QD_Active ];

/// 是否必填项
Property QDRequired As %String [ SqlFieldName = QD_Required ];

/// 关联体检结果
Property QDLinkCode As %String [ SqlFieldName = QD_LinkCode ];

/// 一行显示数量
Property QDElementNum As %Integer [ SqlFieldName = QD_ElementNum ];

/// 备注
Property QDRemark As %String(MAXLEN = 500) [ SqlFieldName = QD_Remark ];

/// 解释说明
Property QDNote As %String(MAXLEN = 1000) [ SqlFieldName = QD_Note ];

/// 解释说明类型（P图片，T文本）
Property QDNoteType As %String(DISPLAYLIST = ",Text,Picture", VALUELIST = ",T,P") [ SqlFieldName = QD_NoteType ];

/// 关联描述
Property QDLinkDesc As %String [ SqlFieldName = QD_LinkDesc ];

/// 关联单位
Property QDLinkUnit As %String [ SqlFieldName = QD_LinkUnit ];

/// 关联分隔符
Property QDLinkBreak As %String [ SqlFieldName = QD_LinkBreak ];

/// 录入值上限
Property QDMaxValue As %String [ SqlFieldName = QD_MaxValue ];

/// 录入值下限
Property QDMinValue As %String [ SqlFieldName = QD_MinValue ];

/// 参考值上限
Property QDRangeMax As %String [ SqlFieldName = QD_RangeMax ];

/// 参考值下限
Property QDRangeMin As %String [ SqlFieldName = QD_RangeMin ];

/// 继承方式
Property QDIherit As %String [ SqlFieldName = QD_Iherit ];

/// 默认值
Property QDDefvalue As %String [ SqlFieldName = QD_Defvalue ];

/// 父节点
Property QDParentDR As %String(COLLATION = "ALPHAUP") [ SqlFieldName = QD_ParentDR ];

/// 更新日期
Property QDUpdateDate As %Date [ SqlFieldName = QD_UpdateDate ];

/// 更新时间
Property QDUpdateTime As %Time [ SqlFieldName = QD_UpdateTime ];

/// 更新人 指向SS_User
Property QDUpdateUserDR As %String [ SqlFieldName = QD_UpdateUserDR ];

/// 代码 索引
Index QDCodeIndex On QDCode [ Unique ];

/// 描述 索引
Index QDDescIndex On QDDesc;

/// 关联体检结果 索引
Index QDLinkCodeIndex On QDLinkCode;

/// 父记录索引
Index IndexParentDR On QDParentDR;

Storage Default
{
<Data name="DHCHMCQuestionsDetailDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>QDActive</Value>
</Value>
<Value name="3">
<Value>QDCode</Value>
</Value>
<Value name="4">
<Value>QDDesc</Value>
</Value>
<Value name="5">
<Value>QDElementNum</Value>
</Value>
<Value name="6">
<Value>QDLinkCode</Value>
</Value>
<Value name="7">
<Value>QDNote</Value>
</Value>
<Value name="8">
<Value>QDRemark</Value>
</Value>
<Value name="9">
<Value>QDRequired</Value>
</Value>
<Value name="10">
<Value>QDSex</Value>
</Value>
<Value name="11">
<Value>QDType</Value>
</Value>
<Value name="12">
<Value>QDUnit</Value>
</Value>
<Value name="13">
<Value>QDNoteType</Value>
</Value>
<Value name="14">
<Value>QDLinkDesc</Value>
</Value>
<Value name="15">
<Value>QDLinkUnit</Value>
</Value>
<Value name="16">
<Value>QDLinkBreak</Value>
</Value>
<Value name="17">
<Value>QDMaxValue</Value>
</Value>
<Value name="18">
<Value>QDMinValue</Value>
</Value>
<Value name="19">
<Value>QDRangeMax</Value>
</Value>
<Value name="20">
<Value>QDRangeMin</Value>
</Value>
<Value name="21">
<Value>QDIherit</Value>
</Value>
<Value name="22">
<Value>QDDefvalue</Value>
</Value>
<Value name="23">
<Value>QDParentDR</Value>
</Value>
<Value name="24">
<Value>QDUpdateDate</Value>
</Value>
<Value name="25">
<Value>QDUpdateTime</Value>
</Value>
<Value name="26">
<Value>QDUpdateUserDR</Value>
</Value>
</Data>
<DataLocation>^User.DHCHMCQuestionsDetailD</DataLocation>
<DefaultData>DHCHMCQuestionsDetailDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCHMCQuestionsDetailD</IdLocation>
<IndexLocation>^User.DHCHMCQuestionsDetailI</IndexLocation>
<StreamLocation>^User.DHCHMCQuestionsDetailS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
