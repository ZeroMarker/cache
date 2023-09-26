Class User.DHCHMOQResult Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Inheritance = right ]
{

Parameter ClassName = "User.DHCHMOQResult";

Relationship QRParRef As User.DHCHMOQEQuestion [ Cardinality = parent, Inverse = DHCHMOQResult ];

/// 4	QR_CQuestionsDetail_DR	问题					指向DHC_HM_CQuestionsDetail
Property QRCQuestionsDetailDR As User.DHCHMCQuestionsDetail [ Required ];

/// QR_QuestionSubject_DR
Property QRQuestionSubjectDR As User.DHCHMCQuestionSubject [ Required ];

/// 	QR_CQDOptions_DR						DHC_HM_CQDOptions
Property QRCQDOptionsDR As User.DHCHMCQDOptions;

/// 5	QR_Result	结果	
Property QRResult As %String;

/// 	QR_Remark	备注	Text	
Property QRRemark As %String(MAXLEN = 512);

/// 6	QR_UpdateType	更新人类型	M				H-His用户 U-客户
Property QRUpdateType As %String;

/// 7	QR_UpdateUsr	更新人					指向ss_User或Dhc_HM_CBaseInfo
Property QRUpdateUsr As %String;

/// 8	QR_UpdateDate	更新日期	Date
Property QRUpdateDate As %Date;

/// 8	QR_UpdateTime	更新时间	Time	
Property QRUpdateTime As %Time;

/// QR_CQuestionsDetail_DR
Index Detail On (QRParRef, QRQuestionSubjectDR, QRCQuestionsDetailDR);

Index Subject On (QRParRef, QRQuestionSubjectDR);

Index DetailOption On (QRParRef, QRCQuestionsDetailDR, QRCQDOptionsDR);

Storage Default
{
<Data name="DHCHMOQResultDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>QRCQDOptionsDR</Value>
</Value>
<Value name="3">
<Value>QRCQuestionsDetailDR</Value>
</Value>
<Value name="4">
<Value>QRRemark</Value>
</Value>
<Value name="5">
<Value>QRResult</Value>
</Value>
<Value name="6">
<Value>QRUpdateDate</Value>
</Value>
<Value name="7">
<Value>QRUpdateTime</Value>
</Value>
<Value name="8">
<Value>QRUpdateType</Value>
</Value>
<Value name="9">
<Value>QRUpdateUsr</Value>
</Value>
<Value name="10">
<Value>QRQuestionSubjectDR</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("DHCHMOQResult")</DataLocation>
<DefaultData>DHCHMOQResultDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCHMOQEQuestionC("DHCHMOQResult")</IdLocation>
<IndexLocation>^User.DHCHMOQResultI</IndexLocation>
<StreamLocation>^User.DHCHMOQResultS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
