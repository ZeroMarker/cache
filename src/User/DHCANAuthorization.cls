Class User.DHCANAuthorization Extends %Persistent [ Owner = {_SYSTEM}, SqlTableName = DHC_AN_Authorization ]
{

Property authName As %String(TRUNCATE = 1);

Property note As %String(TRUNCATE = 1);

ClassMethod Add(authName, note)
{
	// w ##class(User.DHCANAuthorization).Add(authName,note)
	
	&sql(Insert Into DHC_AN_Authorization(authName,note) values(:authName,:note))
	q SQLCODE
}

ClassMethod Delete(ID)
{
	// w ##class(User.DHCANAuthorization).Delete(ID)
	&sql(select parentId into :AuthId from DHC_AN_AuthorizationItem where parentId=:ID)
	
	i $g(AuthId)=ID q -1
	&sql(Delete from DHC_AN_Authorization where ID =:ID)
	q SQLCODE
}

Storage Default
{
<Data name="DHCANAuthorizationDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>authName</Value>
</Value>
<Value name="3">
<Value>note</Value>
</Value>
</Data>
<DataLocation>^User.DHCANAuthorizationD</DataLocation>
<DefaultData>DHCANAuthorizationDefaultData</DefaultData>
<IdLocation>^User.DHCANAuthorizationD</IdLocation>
<IndexLocation>^User.DHCANAuthorizationI</IndexLocation>
<StreamLocation>^User.DHCANAuthorizationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
