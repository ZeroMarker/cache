Class User.DHCBPAuthorizationItem Extends %Persistent [ Owner = {_SYSTEM}, SqlTableName = DHC_BP_AuthorizationItem ]
{

Property parentId As User.DHCBPAuthorization;

Property groupId As %Integer;

ClassMethod Add(parentId, groupId)
{
	// w ##class(User.DHCBPAuthorizationItem).Add(parentId,groupId)
	&sql(Insert Into DHC_BP_AuthorizationItem(parentId,groupId) values(:parentId,:groupId))
	q SQLCODE
}

Storage Default
{
<Data name="DHCBPAuthorizationItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>parentId</Value>
</Value>
<Value name="3">
<Value>groupId</Value>
</Value>
</Data>
<DataLocation>^User.DHCBPAuthorizationItemD</DataLocation>
<DefaultData>DHCBPAuthorizationItemDefaultData</DefaultData>
<IdLocation>^User.DHCBPAuthorizationItemD</IdLocation>
<IndexLocation>^User.DHCBPAuthorizationItemI</IndexLocation>
<StreamLocation>^User.DHCBPAuthorizationItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
