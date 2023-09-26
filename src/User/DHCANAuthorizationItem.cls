Class User.DHCANAuthorizationItem Extends %Persistent [ Owner = {_SYSTEM}, SqlTableName = DHC_AN_AuthorizationItem ]
{

Property parentId As User.DHCANAuthorization;

Property groupId As %Integer;

ClassMethod Add(parentId, groupId)
{
	// w ##class(User.DHCANAuthorizationItem).Add(parentId,groupId)
	&sql(Insert Into DHC_AN_AuthorizationItem(parentId,groupId) values(:parentId,:groupId))
	q SQLCODE
}

ClassMethod Delete(ID)
{
	// w ##class(User.DHCANAuthorizationItem).Delete(ID)
	&sql(Delete from DHC_AN_AuthorizationItem where ID =:ID)
	q SQLCODE
}

Storage Default
{
<Data name="DHCANAuthorizationItemDefaultData">
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
<DataLocation>^User.DHCANAuthorizationItemD</DataLocation>
<DefaultData>DHCANAuthorizationItemDefaultData</DefaultData>
<IdLocation>^User.DHCANAuthorizationItemD</IdLocation>
<IndexLocation>^User.DHCANAuthorizationItemI</IndexLocation>
<StreamLocation>^User.DHCANAuthorizationItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
