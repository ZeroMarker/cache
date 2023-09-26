Class User.DHCHMOQEvaluation Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Inheritance = right ]
{

Parameter ClassName = "User.DHCHMOQEvaluation";

Relationship QEParRef As User.DHCHMOQEQuestion [ Cardinality = parent, Inverse = DHCHMOQEvaluation ];

/// 4	QE_CEvaluationDetail _DR	评估内容					指向DHC_HM_CEvaluationDetail
Property QECEvaluationDetailDR As User.DHCHMCEvaluationDetail [ Required ];

/// 5	QE_Result	结果
Property QEResult As %String;

/// 	QE_Remark	备注	Text	
Property QERemark As %String(MAXLEN = 200);

/// 7	QE_UpdateUsr	更新人					指向ss_User
Property QEUpdateUsr As User.SSUser;

/// 8	QE_UpdateDate	更新日期	Date	
Property QEUpdateDate As %Date;

/// 8	QE_UpdateTime	更新时间	Time	
Property QEUpdateTime As %Time;

Property QECalculateOrder As %Integer;

/// QE_CEvaluationDetail _DR
Index QECEvaluationDetailDRIndex On (QEParRef, QECEvaluationDetailDR);

Storage Default
{
<Data name="DHCHMOQEvaluationDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>QECEvaluationDetailDR</Value>
</Value>
<Value name="3">
<Value>QERemark</Value>
</Value>
<Value name="4">
<Value>QEResult</Value>
</Value>
<Value name="5">
<Value>QEUpdateDate</Value>
</Value>
<Value name="6">
<Value>QEUpdateTime</Value>
</Value>
<Value name="7">
<Value>QEUpdateUsr</Value>
</Value>
<Value name="8">
<Value>QECalculateOrder</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("DHCHMOQEvaluation")</DataLocation>
<DefaultData>DHCHMOQEvaluationDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCHMOQEQuestionC("DHCHMOQEvaluation")</IdLocation>
<IndexLocation>^User.DHCHMOQEvaluationI</IndexLocation>
<StreamLocation>^User.DHCHMOQEvaluationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
