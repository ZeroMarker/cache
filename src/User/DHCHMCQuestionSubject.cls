/// 问卷主题表
Class User.DHCHMCQuestionSubject Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Inheritance = right, ProcedureBlock, SqlTableName = DHC_HM_CQuestionSubject ]
{

Parameter ClassName = "User.DHCHMCQuestionSubject";

Relationship QSParRef As User.DHCHMCQuestionnaire [ Cardinality = parent, Inverse = QSubject ];

Relationship QSDLink As DHCHMCSDLink [ Cardinality = children, Inverse = SDLParRef ];

/// 编码
Property QSCode As %String [ Required, SqlFieldName = QS_Code ];

/// 描述
Property QSDesc As %String [ Required, SqlFieldName = QS_Desc ];

/// 顺序号
Property QSOrder As %Integer [ SqlFieldName = QS_Order ];

/// 激活
Property QSActive As %String [ SqlFieldName = QS_Active ];

/// 备注
Property QSRemark As %String(MAXLEN = 200) [ SqlFieldName = QS_Remark ];

/// 性别
Property QSSex As %String [ SqlFieldName = QS_Sex ];

/// 护士填写标记  表示该主题只允许护士填写
Property QSDocFlag As %String(VALUELIST = ",Y,N") [ InitialExpression = "N", SqlFieldName = QS_DocFlag ];

/// 年龄下限
Property QSMinAge As %Integer [ SqlFieldName = QS_MinAge ];

/// 年龄上限
Property QSMaxAge As %Integer [ SqlFieldName = QS_MaxAge ];

Index QSOrderIndex On (QSParRef, QSOrder);

Index QSCodeIndex On (QSParRef, QSCode) [ Unique ];

Storage Default
{
<Data name="DHCHMCQuestionSubjectDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>QSActive</Value>
</Value>
<Value name="3">
<Value>QSCode</Value>
</Value>
<Value name="4">
<Value>QSDesc</Value>
</Value>
<Value name="5">
<Value>QSOrder</Value>
</Value>
<Value name="6">
<Value>QSRemark</Value>
</Value>
<Value name="7">
<Value>QSSex</Value>
</Value>
<Value name="8">
<Value>QSDocFlag</Value>
</Value>
<Value name="9">
<Value>QSMinAge</Value>
</Value>
<Value name="10">
<Value>QSMaxAge</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("QSubject")</DataLocation>
<DefaultData>DHCHMCQuestionSubjectDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCHMCQuestionnaireC("QSubject")</IdLocation>
<IndexLocation>^User.DHCHMCQuestionSubjectI</IndexLocation>
<StreamLocation>^User.DHCHMCQuestionSubjectS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
