/// 12、表达式表DHC_HM_CExpression
Class User.DHCHMCExpression Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Inheritance = right, SqlTableName = DHC_HM_CExpression ]
{

Parameter ClassName = "User.DHCHMCExpression";

/// E_Type	类型			NOTNULL		见设置说明表
Property EType As %String [ Required ];

/// E_SourceID		Text
Property ESourceID As %String;

/// 4	E_CQuestionnaire_DR	问卷	D		NOT NULL		DHC_HM_CQuestionnaire
Property ECQuestionnaireDR As User.DHCHMCQuestionnaire [ Required ];

/// 9	E_Sex	性别	Text	1			F女M男N不限
Property ESex As %String;

/// 13	E_AgeMin	年龄下限	Number	
Property EAgeMin As %Integer;

/// 13	E_AgeMax	年龄上限	Number	
Property EAgeMax As %Integer;

/// 8	E_ExpressionType 	表达式类型	M				F函数，E表达式
Property EExpressionType As %String;

/// E_Expression 表达式	Text	200	
Property EExpression As %String(MAXLEN = 1200);

/// E_Parameters参数	Text	200	
Property EParameters As %String(MAXLEN = 200);

/// E_Unit	单位	Text	200	
Property EUnit As %String(MAXLEN = 200);

/// 12	E_Remark 备注	Text	200	
Property ERemark As %String(MAXLEN = 200);

Index ETypeIndex On (EType, ESourceID);

Index QTSIndex On (ECQuestionnaireDR, EType, ESourceID);

Storage Default
{
<Data name="DHCHMCExpressionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EAgeMin</Value>
</Value>
<Value name="3">
<Value>EExpression</Value>
</Value>
<Value name="4">
<Value>EExpressionType</Value>
</Value>
<Value name="5">
<Value>EParameters</Value>
</Value>
<Value name="6">
<Value>ERemark</Value>
</Value>
<Value name="7">
<Value>ESex</Value>
</Value>
<Value name="8">
<Value>ESourceID</Value>
</Value>
<Value name="9">
<Value>EType</Value>
</Value>
<Value name="10">
<Value>EUnit</Value>
</Value>
<Value name="11">
<Value>ECQuestionnaireDR</Value>
</Value>
<Value name="12">
<Value>EAgeMax</Value>
</Value>
</Data>
<DataLocation>^User.DHCHMCExpressionD</DataLocation>
<DefaultData>DHCHMCExpressionDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCHMCExpressionD</IdLocation>
<IndexLocation>^User.DHCHMCExpressionI</IndexLocation>
<StreamLocation>^User.DHCHMCExpressionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
