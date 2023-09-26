Import SQLUser

Class web.DHCBL.RQ.RepDataQueryLog Extends %RegisteredObject [ ProcedureBlock ]
{

ClassMethod SaveData(RepName As %String, RepCond As %String, UserName As %String, GroupDesc As %String, UserIP As %String) As %String
{
	;w ##class(web.DHCBL.RQ.RepDataQueryLog).SaveData("查询1","Para1:A;Para2:B","用户1","角色1","127.0.0.1")
	s myobj = ##class(User.DHCRepDataQueryLog).%New()
	
	s myobj.BIRepName = RepName
	
	s myobj.BIRepCondition = RepCond
	s myobj.QueryUserName = UserName
	s myobj.QueryGroupDesc = GroupDesc
	s myobj.QueryUserIP = UserIP
	
	s sc = myobj.%Save()
	
	q sc
}

}
