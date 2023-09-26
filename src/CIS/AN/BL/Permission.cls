/// 功能授权、菜单授权业务类
Class CIS.AN.BL.Permission Extends %RegisteredObject
{

ClassMethod SaveActionPermissions(groupId As %String, dataPara As %String) As %String
{
	set $zt="ActionError"
	tstart
	set sc=##class(CIS.AN.COM.String).ToArray(dataPara,.dataArr)
	&sql(delete from CF_AN.ActionPermission where GroupID=:groupId)
	if (SQLCODE'=0)&(SQLCODE'=100)
	{
		trollback
		quit "E^"_$System.SQL.SQLCODE(SQLCODE)	
	}
	set dataIndex=0,saveRet="E^没有授权数据"
	for
	{
		set dataIndex=$o(dataArr(dataIndex))
		quit:(dataIndex="")
		k actionData
		m actionData=dataArr(dataIndex)
		set saveRet=##class(CIS.AN.COM.DataService).SaveData(.actionData)
		quit:($p(saveRet,"^",1)'="S")	
	}
	if ($p(saveRet,"^",1)'="S")
	{
		trollback
		quit saveRet	
	}
	tcommit
	quit "S^"
ActionError
	trollback
	quit "E^"_$ze
}

}
