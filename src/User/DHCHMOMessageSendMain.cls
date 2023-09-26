Class User.DHCHMOMessageSendMain Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Inheritance = right ]
{

Parameter ClassName = "User.DHCHMOMessageSendMain";

//MSM_MessageDetail	短信内容

//MSM_Remark备注

//MSM_CreateUser	创建人

//MSM_CreateDate	创建日期

//MSM_CreateTime	创建时间

Property MSMMessageDetail As %String(MAXLEN = 200) [ Required ];

Property MSMRemark As %String(MAXLEN = 200);

Property MSMCreateUser As User.SSUser;

Property MSMSendDate As %Date;

Property MSMSendTime As %Time;

Index MSMCreateUserIndex On MSMCreateUser;

Relationship drMdetail As User.DHCHMOMessageSendDetail [ Cardinality = children, Inverse = MSDParRef ];

Storage Default
{
<Data name="DHCHMOMessageSendMainDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MSMCreateUser</Value>
</Value>
<Value name="3">
<Value>MSMMessageDetail</Value>
</Value>
<Value name="4">
<Value>MSMRemark</Value>
</Value>
<Value name="5">
<Value>MSMSendDate</Value>
</Value>
<Value name="6">
<Value>MSMSendTime</Value>
</Value>
</Data>
<DataLocation>^User.DHCHMOMessageSendMainD</DataLocation>
<DefaultData>DHCHMOMessageSendMainDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCHMOMessageSendMainD</IdLocation>
<IndexLocation>^User.DHCHMOMessageSendMainI</IndexLocation>
<StreamLocation>^User.DHCHMOMessageSendMainS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
