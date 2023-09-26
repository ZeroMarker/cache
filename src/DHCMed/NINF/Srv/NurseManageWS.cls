/// 远卓护理管理系统接口
Class DHCMed.NINF.Srv.NurseManageWS Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

Parameter SERVICENAME = "NurseManageInfo";

Parameter LOCATION = "http://10.193.10.128:1972/csp/websource";

Parameter NAMESPACE = "http://tempuri.org";

/// 更新护理管理记录
/// w ##class(DHCMed.NINF.Srv.NurseManageWS).Update("35983^2013.04.16^刘大玲^女^65^421792^普外科一区^结节性甲状腺肿^双侧甲状腺次全切除术^^Ⅱ^局麻强化^藤长胜赵宁^2013.04.16 10:36:00 ^2013.04.16 11:35:00 ^普外科^^^藤长胜^赵宁^^^^^")
ClassMethod Update(aInputStr As %String) As %String [ WebMethod ]
{
	Set return=##Class(DHCMed.NINF.Srv.NurseManage).Update(aInputStr)
	Quit return
}

}
