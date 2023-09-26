Class User.DHCMRCOffShootStatTitle Extends %Persistent [ ClassType = persistent ]
{

Property Title As %String;

Index TitleIndex On Title [ Unique ];

Property Items As list Of DHCMRCOffShootStatItem;

Storage Default
{
<Data name="DHCMRCOffShootStatTitleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Items</Value>
</Value>
<Value name="3">
<Value>Title</Value>
</Value>
</Data>
<DataLocation>^DHCMRC("OSS")</DataLocation>
<DefaultData>DHCMRCOffShootStatTitleDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMRC("OSS")</IdLocation>
<IndexLocation>^DHCMRCi("OSS",0)</IndexLocation>
<StreamLocation>^User.DHCMRCOffShootStatTitleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
