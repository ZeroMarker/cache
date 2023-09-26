/// 健康杂志发送主表
Class User.DHCHMOMagazineSendMain Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Inheritance = right ]
{

Parameter ClassName = "User.DHCHMOMagazineSendMain";

//MSM_Magazine_DR	健康杂志

//MSM_Remark   备注

//	MSM_SendUser	发送人

//	MSM_SendDate	发送日期

//	MSM_SendTime	发送时间

Property MSMMagazineDR As User.DHCHMCMagazine [ Required ];

Property MSMRemark As %String(MAXLEN = 200);

Property MSMSendUser As User.SSUser;

Property MSMSendDate As %Date;

Property MSMSendTime As %Time;

Index MSMagazineDRIndex On MSMMagazineDR;

Index MSMSendDateIndex On (MSMSendDate, MSMSendTime);

Relationship MSMdetail As User.DHCHMOMagazineSendDetail [ Cardinality = children, Inverse = MSDParRef ];

Storage Default
{
<Data name="DHCHMOMagazineSendMainDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MSMMagazineDR</Value>
</Value>
<Value name="3">
<Value>MSMRemark</Value>
</Value>
<Value name="4">
<Value>MSMSendDate</Value>
</Value>
<Value name="5">
<Value>MSMSendTime</Value>
</Value>
<Value name="6">
<Value>MSMSendUser</Value>
</Value>
</Data>
<DataLocation>^User.DHCHMOMagazineSendMainD</DataLocation>
<DefaultData>DHCHMOMagazineSendMainDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCHMOMagazineSendMainD</IdLocation>
<IndexLocation>^User.DHCHMOMagazineSendMainI</IndexLocation>
<StreamLocation>^User.DHCHMOMagazineSendMainS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
