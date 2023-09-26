Class User.DHCBPAuthorization Extends %Persistent [ Owner = {_SYSTEM}, SqlTableName = DHC_BP_Authorization ]
{

Property authName As %String(TRUNCATE = 1);

Property note As %String(TRUNCATE = 1);

// w ##class(User.DHCBPAuthorization).Add("Nurse","护士")

// w ##class(User.DHCBPAuthorization).Add("Doctor","医生")

// w ##class(User.DHCBPAuthorization).Add("Nurse-Admin","护士管理员")

// w ##class(User.DHCBPAuthorization).Add("Manager","系统管理(只负责权限维护)")

ClassMethod Add(authName, note)
{
	// w ##class(User.DHCBPAuthorization).Add(authName,note)
	&sql(Insert Into DHC_BP_Authorization(authName,note) values(:authName,:note))
	q SQLCODE
}

Storage Default
{
<Data name="DHCBPAuthorizationDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>authName</Value>
</Value>
<Value name="3">
<Value>Note</Value>
</Value>
<Value name="4">
<Value>note</Value>
</Value>
</Data>
<DataLocation>^User.DHCBPAuthorizationD</DataLocation>
<DefaultData>DHCBPAuthorizationDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCBPAuthorizationD</IdLocation>
<IndexLocation>^User.DHCBPAuthorizationI</IndexLocation>
<StreamLocation>^User.DHCBPAuthorizationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
