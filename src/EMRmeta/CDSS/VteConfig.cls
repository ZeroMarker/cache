Class EMRmeta.CDSS.VteConfig Extends %Persistent
{

Index configData On (IsActive, DocID, TitleCode, Path);

Property Path As %String;

Property DocID As %String;

Property TitleCode As %String;

Property IsActive As %String;

Storage Default
{
<Data name="VteConfigDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Path</Value>
</Value>
<Value name="3">
<Value>DocID</Value>
</Value>
<Value name="4">
<Value>TitleCode</Value>
</Value>
<Value name="5">
<Value>IsActive</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.EMRmeta.CDSS.VteConfigD</DataLocation>
<DefaultData>VteConfigDefaultData</DefaultData>
<IdLocation>^DHCEMRM.EMRmeta.CDSS.VteConfigD</IdLocation>
<IndexLocation>^DHCEMRM.EMRmeta.CDSS.VteConfigI</IndexLocation>
<StreamLocation>^DHCEMRM.EMRmeta.CDSS.VteConfigS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
