Class User.DHCHMCQuestionnaire Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Inheritance = right, SqlTableName = DHC_HM_CQuestionnaire ]
{

Parameter ClassName = "User.DHCHMCQuestionnaire";

Relationship QSubject As DHCHMCQuestionSubject [ Cardinality = children, Inverse = QSParRef ];

Relationship QEDLink As DHCHMCQEDLink [ Cardinality = children, Inverse = QEDLParRef ];

/// 调查问卷代码
Property QCode As %String [ Required, SqlFieldName = Q_Code ];

/// 调查问卷名称
Property QDesc As %String [ Required, SqlFieldName = Q_Desc ];

/// 激活
Property QActive As %String [ SqlFieldName = Q_Active ];

/// (DISPLAYLIST = "健康管理问卷,随访", VALUELIST = "HM,CRM")
Property QType As %String [ SqlFieldName = Q_Type ];

/// 备注
Property QRemark As %String(MAXLEN = 200) [ SqlFieldName = Q_Remark ];

/// 指向标准问卷量表
Property QCQDSubjectDR As User.DHCHMCQDSubject [ SqlFieldName = Q_CQDSubjectDR ];

Index QTypeIndex On QType;

Index TypeCodeIndex On (QType, QCode);

Index TypeDescIndex On (QType, QDesc);

Index IdxOfCQDSubjectDR On QCQDSubjectDR;

Storage Default
{
<Data name="DHCHMCQuestionnaireDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>QActive</Value>
</Value>
<Value name="3">
<Value>QCode</Value>
</Value>
<Value name="4">
<Value>QDesc</Value>
</Value>
<Value name="5">
<Value>QRemark</Value>
</Value>
<Value name="6">
<Value>QType</Value>
</Value>
<Value name="7">
<Value>QCQDSubjectDR</Value>
</Value>
</Data>
<DataLocation>^User.DHCHMCQuestionnaireD</DataLocation>
<DefaultData>DHCHMCQuestionnaireDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCHMCQuestionnaireD</IdLocation>
<IndexLocation>^User.DHCHMCQuestionnaireI</IndexLocation>
<StreamLocation>^User.DHCHMCQuestionnaireS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
