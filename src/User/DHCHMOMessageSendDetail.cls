Class User.DHCHMOMessageSendDetail Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Inheritance = right ]
{

Parameter ClassName = "User.DHCHMOMessageSendDetail";

//MSD_SourceType

//MSD_SourceID

//MSD_MobileTelephone

//MSD_Status

//MSD_SendDate

//MSD_SendTime

Property MSDSourceType As %String [ Required ];

Property MSDSourceID As %String [ Required ];

Property MSDMobileTelephone As %String;

Property MSDStatus As %String;

Property MSDSendDate As %Date;

Property MSDSendTime As %Time;

Relationship MSDParRef As User.DHCHMOMessageSendMain [ Cardinality = parent, Inverse = drMdetail ];

Index MSDSourceTypeIndex On (MSDSourceType, MSDSourceID);

Index MSDStatusIndex On MSDStatus;

Index MSDSendDateIndex On (MSDSendDate, MSDSendTime);

Storage Default
{
<Data name="DHCHMOMessageSendDetailDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MSDMobileTelephone</Value>
</Value>
<Value name="3">
<Value>MSDSendDate</Value>
</Value>
<Value name="4">
<Value>MSDSendTime</Value>
</Value>
<Value name="5">
<Value>MSDSourceID</Value>
</Value>
<Value name="6">
<Value>MSDSourceType</Value>
</Value>
<Value name="7">
<Value>MSDStatus</Value>
</Value>
</Data>
<DataLocation>^User.DHCHMOMessageSendDetailD</DataLocation>
<DefaultData>DHCHMOMessageSendDetailDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCHMOMessageSendDetailD</IdLocation>
<IndexLocation>^User.DHCHMOMessageSendDetailI</IndexLocation>
<StreamLocation>^User.DHCHMOMessageSendDetailS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
