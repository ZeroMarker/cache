/// 发送明细表
Class User.DHCHMOMagazineSendDetail Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Inheritance = right ]
{

Parameter ClassName = "User.DHCHMOMagazineSendDetail";

//MSD_ParRef

//ID

//MSD_ChildSub

//MSD_SourceType

//MSD_SourceID

//Property MSDChildSub As %String;

Property MSDSourceType As %String;

Property MSDSourceID As %String;

Relationship MSDParRef As User.DHCHMOMagazineSendMain [ Cardinality = parent, Inverse = MSMdetail ];

Storage Default
{
<Data name="DHCHMOMagazineSendDetailDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MSDChildSub</Value>
</Value>
<Value name="3">
<Value>MSDSourceID</Value>
</Value>
<Value name="4">
<Value>MSDSourceType</Value>
</Value>
</Data>
<DataLocation>^User.DHCHMOMagazineSendDetailD</DataLocation>
<DefaultData>DHCHMOMagazineSendDetailDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCHMOMagazineSendDetailD</IdLocation>
<IndexLocation>^User.DHCHMOMagazineSendDetailI</IndexLocation>
<StreamLocation>^User.DHCHMOMagazineSendDetailS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
