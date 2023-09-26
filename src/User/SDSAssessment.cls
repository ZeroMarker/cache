/// Creator:谷雪萍
/// CreatDate:2018-05-05
/// Description：评分表（评分型）业务表
/// Table：User.SDSAssessment
Class User.SDSAssessment Extends (%Persistent, User.Abstract) [ SqlTableName = SDS_Assessment ]
{

/// 总得分
Property SDSAScore As %String(MAXLEN = "") [ SqlColumnNumber = 2, SqlFieldName = SDSA_Score ];

/// 描述
Property SDSADesc As %String(MAXLEN = "") [ SqlColumnNumber = 3, SqlFieldName = SDSA_Desc ];

/// 结构化诊断表DR
Property SDSADiagDR As %String [ SqlColumnNumber = 4, SqlFieldName = SDSA_Diag_DR ];

/// 等级
Property SDSARank As %String(MAXLEN = "") [ SqlColumnNumber = 5, SqlFieldName = SDSA_Rank ];

/// 评分表DR
Property SDSABaseDR As User.MKBAssessmentBase [ SqlColumnNumber = 6, SqlFieldName = SDSA_Base_DR ];

/// 内容值串
Property SDSAValue As %String(MAXLEN = "") [ SqlColumnNumber = 7, SqlFieldName = SDSA_Value ];

Index DiagBaseIndex On (SDSADiagDR As Exact, SDSABaseDR);

Storage Default
{
<Data name="SDSAssessmentDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SDSAScore</Value>
</Value>
<Value name="3">
<Value>SDSADesc</Value>
</Value>
<Value name="4">
<Value>SDSADiagDR</Value>
</Value>
<Value name="5">
<Value>SDSARank</Value>
</Value>
<Value name="6">
<Value>SDSABaseDR</Value>
</Value>
<Value name="7">
<Value>SDSAValue</Value>
</Value>
</Data>
<DataLocation>^User.SDSAssessmentD</DataLocation>
<DefaultData>SDSAssessmentDefaultData</DefaultData>
<IdLocation>^User.SDSAssessmentD</IdLocation>
<IndexLocation>^User.SDSAssessmentI</IndexLocation>
<StreamLocation>^User.SDSAssessmentS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
