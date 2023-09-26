Class User.DHCHMOQMedicalTips Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Inheritance = right ]
{

Parameter ClassName = "User.DHCHMOQMedicalTips";

Relationship QMTParRef As User.DHCHMOQEQuestion [ Cardinality = parent, Inverse = DHCHMOQMedicalTips ];

/// 4	QMT_CMedicalTips _DR	健康提示					指向DHC_HM_CEvaluationDetail
Property QMTCMedicalTipsDR As User.DHCHMCMedicalTips [ Required ];

/// 	QMT_Desc	健康提示描述
Property QMTDesc As %String;

/// 5	QMT_Detail	提示内容	
Property QMTDetail As %GlobalCharacterStream;

/// 	QMT_Type	提示类型					A-	自动B-	手动
Property QMTType As %String;

/// 	QMT_Remark	备注	Text	
Property QMTRemark As %String(MAXLEN = 200);

/// 7	QMT_UpdateUsr	更新人					指向ss_User
Property QMTUpdateUsr As User.SSUser [ Required ];

/// 8	QMT_UpdateDate	更新日期	Date
Property QMTUpdateDate As %Date;

/// 8	QMT_UpdateTime	更新时间	Time	
Property QMTUpdateTime As %Time;

/// QMT_CMedicalTips _DR
Index QMTCMedicalTipsDRIndex On QMTCMedicalTipsDR;

Storage Default
{
<Data name="DHCHMOQMedicalTipsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>QMTCMedicalTipsDR</Value>
</Value>
<Value name="3">
<Value>QMTDesc</Value>
</Value>
<Value name="4">
<Value>QMTDetail</Value>
</Value>
<Value name="5">
<Value>QMTRemark</Value>
</Value>
<Value name="6">
<Value>QMTType</Value>
</Value>
<Value name="7">
<Value>QMTUpdateDate</Value>
</Value>
<Value name="8">
<Value>QMTUpdateTime</Value>
</Value>
<Value name="9">
<Value>QMTUpdateUsr</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("DHCHMOQMedicalTips")</DataLocation>
<DefaultData>DHCHMOQMedicalTipsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCHMOQEQuestionC("DHCHMOQMedicalTips")</IdLocation>
<IndexLocation>^User.DHCHMOQMedicalTipsI</IndexLocation>
<StreamLocation>^User.DHCHMOQMedicalTipsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
