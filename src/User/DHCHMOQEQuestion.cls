Class User.DHCHMOQEQuestion Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Inheritance = right, SqlTableName = DHC_HM_OQEQuestion ]
{

Parameter ClassName = "User.DHCHMOQEQuestion";

Relationship QEQParRef As User.DHCHMOEvaluationRecord [ Cardinality = parent, Inverse = DHCHMOQEQuestion ];

///     4	QEQ_CQuestionnaire_DR	问卷			NOT NULL		DHC_HM_CQuestionnaire
Property QEQCQuestionnaireDR As User.DHCHMCQuestionnaire [ Required ];

///     	QEQ_CHumanClass_DR	人员分类					DHC_HM_CHumanClass
Property QEQCHumanClassDR As User.DHCHMCHumanClass;

///     	QEQ_Remark	备注	Text	200	
Property QEQRemark As %String(MAXLEN = 200);

///     	QEQ_Status	状态	M				N新建
Property QEQStatus As %String;

///     R录入
///     S提交
///     ES评估提交
///     TS提示提交
///     P已打印
///     	QEQ_AddUser_DR	添加人					SS_User
Property QEQAddUserDR As User.SSUser [ Required ];

///     12	QEQ_AddDate	添加日期	Date
Property QEQAddDate As %Date;

///     12	QEQ_AddTime	添加时间	Time
Property QEQAddTime As %Time;

///     	QEQ_SubmitUserType	问卷提交人类型					U：SS_User
Property QEQSubmitUserType As %String;

///     B：DHC_HM_OBaseInfo
///     	QEQ_SubmitUser_DR	问卷提交人	
Property QEQSubmitUserDR As %String;

///     	QEQ_SubmitDate	问卷提交日期	Date
Property QEQSubmitDate As %Date;

///     	QEQ_SubmitTime	问卷提交时间	Time
Property QEQSubmitTime As %Time;

///     	QEQ_ESubmitUser_DR	评估提交人					SS_User
Property QEQESubmitUserDR As User.SSUser;

///     	QEQ_ESubmitDate	评估提交日期	Date
Property QEQESubmitDate As %Date;

///     	QEQ_ESubmitTime	评估提交时间	Time
Property QEQESubmitTime As %Time;

///     	QEQ_TipsSubmitUser_DR	提示提交人					SS_User
Property QEQTipsSubmitUserDR As User.SSUser;

///     	QEQ_TipsSubmitDate	提示提交日期	Date
Property QEQTipsSubmitDate As %Date;

///     	QEQ_TipsSubmitTime	提示提交时间	Time	
Property QEQTipsSubmitTime As %Time;

///     	QEQ_PrintUser_DR	打印人					SS_User
Property QEQPrintUserDR As User.SSUser;

///     	QEQ_PrintDate	打印日期	Date	
Property QEQPrintDate As %Date;

///     	QEQ_PrintTime	打印时间	Time
Property QEQPrintTime As %Time;

///     Q_CQuestionnaire_DR
Index QEQCQuestionnaireDRIndex On QEQCQuestionnaireDR;

///     Q_CHumanClass_DR
Index QEQCHumanClassDRIndex On QEQCHumanClassDR;

///     Q_Status人员或者时间都有可能被用到索引
Index QEQStatusIndex On QEQStatus;

Index QEQAddDateIndex On QEQAddDate;

Relationship DHCHMOQResult As DHCHMOQResult [ Cardinality = children, Inverse = QRParRef ];

Relationship DHCHMOQEvaluation As DHCHMOQEvaluation [ Cardinality = children, Inverse = QEParRef ];

Relationship DHCHMOQMedicalTips As DHCHMOQMedicalTips [ Cardinality = children, Inverse = QMTParRef ];

Storage Default
{
<Data name="DHCHMOQEQuestionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>QEQAddDate</Value>
</Value>
<Value name="3">
<Value>QEQAddTime</Value>
</Value>
<Value name="4">
<Value>QEQAddUserDR</Value>
</Value>
<Value name="5">
<Value>QEQCHumanClassDR</Value>
</Value>
<Value name="6">
<Value>QEQCQuestionnaireDR</Value>
</Value>
<Value name="7">
<Value>QEQESubmitDate</Value>
</Value>
<Value name="8">
<Value>QEQESubmitTime</Value>
</Value>
<Value name="9">
<Value>QEQESubmitUserDR</Value>
</Value>
<Value name="10">
<Value>QEQPostCode</Value>
</Value>
<Value name="11">
<Value>QEQPrintDate</Value>
</Value>
<Value name="12">
<Value>QEQPrintTime</Value>
</Value>
<Value name="13">
<Value>QEQPrintUserDR</Value>
</Value>
<Value name="14">
<Value>QEQRemark</Value>
</Value>
<Value name="15">
<Value>QEQStatus</Value>
</Value>
<Value name="16">
<Value>QEQSubmitDate</Value>
</Value>
<Value name="17">
<Value>QEQSubmitTime</Value>
</Value>
<Value name="18">
<Value>QEQSubmitUserDR</Value>
</Value>
<Value name="19">
<Value>QEQSubmitUserType</Value>
</Value>
<Value name="20">
<Value>QEQTipsSubmitDate</Value>
</Value>
<Value name="21">
<Value>QEQTipsSubmitTime</Value>
</Value>
<Value name="22">
<Value>QEQTipsSubmitUserDR</Value>
</Value>
</Data>
<DataLocation>^User.DHCHMOQEQuestionD</DataLocation>
<DefaultData>DHCHMOQEQuestionDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCHMOQEQuestionD</IdLocation>
<IndexLocation>^User.DHCHMOQEQuestionI</IndexLocation>
<StreamLocation>^User.DHCHMOQEQuestionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
