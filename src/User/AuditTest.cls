Class User.AuditTest Extends %Persistent
{

Storage Default
{
<Data name="AuditTestDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^User.AuditTestD</DataLocation>
<DefaultData>AuditTestDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.AuditTestD</IdLocation>
<IndexLocation>^User.AuditTestI</IndexLocation>
<StreamLocation>^User.AuditTestS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
