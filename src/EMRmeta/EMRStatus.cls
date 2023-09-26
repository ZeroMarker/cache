/// Desc:状态表
/// Creaotr:Candy
/// CreateDate:2014-3-19
Class EMRmeta.EMRStatus Extends (%Persistent, User.Abstract)
{

Property StatusCode As %String(TRUNCATE = 1);

Property StatusName As %String(TRUNCATE = 1);

Index IdxStatusCode On StatusCode [ Unique ];

Storage Default
{
<Data name="EMRStatusDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>StatusCode</Value>
</Value>
<Value name="3">
<Value>StatusName</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.EMRStatusD</DataLocation>
<DefaultData>EMRStatusDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRM.EMRStatusD</IdLocation>
<IndexLocation>^DHCEMRM.EMRStatusI</IndexLocation>
<StreamLocation>^DHCEMRM.EMRStatusS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
