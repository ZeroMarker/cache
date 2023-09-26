Import SQLUser

Class web.DHCSTCOMWEB Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 10;

ClassMethod GetComponentIdByName(ComponentName)
{
	n (ComponentName)
	s ComponentId=""
	&sql(select ID into :ComponentId from websys.component where name=:ComponentName)
	q ComponentId
}

ClassMethod GetUserID() As %String
{
	Q $G(%session.Data("LOGON.USERID"))
}

ClassMethod GetPrintPath(itmjs As %Library.String = "", itmjsex As %Library.String = "")
{
	&sql(select pathtoreports into :path from websys.configuration)
	q path
}

}
