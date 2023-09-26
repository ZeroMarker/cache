/// Desc:病历操作字典及相关操作
/// Creator:Candy
/// CreateDate:2014-3-19
Class EMRmeta.EMRAction Extends (%Persistent, User.Abstract)
{

Property ActionCode As %String(TRUNCATE = 1);

Property ActionName As %String(TRUNCATE = 1);

Index IdxActionCode On ActionCode [ Unique ];

Index IdxActionName On ActionName;

Storage Default
{
<Data name="EMRActionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ActionCode</Value>
</Value>
<Value name="3">
<Value>ActionName</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.EMRActionD</DataLocation>
<DefaultData>EMRActionDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRM.EMRActionD</IdLocation>
<IndexLocation>^DHCEMRM.EMRActionI</IndexLocation>
<StreamLocation>^DHCEMRM.EMRActionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
