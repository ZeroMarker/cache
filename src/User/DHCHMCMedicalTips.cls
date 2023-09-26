/// 9、健康提示维护DHC_HM_CMedicalTips
Class User.DHCHMCMedicalTips Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Inheritance = right, SqlTableName = DHC_HM_CMedicalTips ]
{

Parameter ClassName = "User.DHCHMCMedicalTips";

/// MT_Code	代码	Text	40	
Property MTCode As %String(MAXLEN = 40);

Index MTCodeIndex On MTCode [ Unique ];

/// 5	MT_Desc	描述	Text
Property MTDesc As %String;

Index MTDescIndex On MTDesc;

/// 6	MT_Detail	提示内容	Text
Property MTDetail As %GlobalCharacterStream;

/// MT_Active	激活	Y/N
Property MTActive As %String;

/// HMMT_Remark	备注	
Property MTRemark As %String(MAXLEN = 200);

Storage Default
{
<Data name="DHCHMCMedicalTipsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>HMMTRemark</Value>
</Value>
<Value name="3">
<Value>MTActive</Value>
</Value>
<Value name="4">
<Value>MTCode</Value>
</Value>
<Value name="5">
<Value>MTDesc</Value>
</Value>
<Value name="6">
<Value>MTDetail</Value>
</Value>
<Value name="7">
<Value>MTRemark</Value>
</Value>
</Data>
<DataLocation>^User.DHCHMCMedicalTipsD</DataLocation>
<DefaultData>DHCHMCMedicalTipsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCHMCMedicalTipsD</IdLocation>
<IndexLocation>^User.DHCHMCMedicalTipsI</IndexLocation>
<StreamLocation>^User.DHCHMCMedicalTipsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
