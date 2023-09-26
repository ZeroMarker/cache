Class DHCCSYS.SetDBAppLabelAuto Extends %RegisteredObject
{

/// DB端执行w ##class(DHCCSYS.SetDBAppLabelAuto).SetDBLabel("项目名称","MCP上安装部署需求编号","项目经理名字","DBA名字","iMedical版本号")
/// d ##class(DHCCSYS.SetDBAppLabelAuto).SetDBLabel("项目名称","MCP上安装部署需求编号","项目经理名字","DBA名字","8.4.2")
ClassMethod SetDBLabel(sHospitalName, sMcpReqNum, sPMName, sDBAName, sVersion As %String) As %String
{
}

/// 主ECP/WEB端执行d ##class(DHCCSYS.SetDBAppLabelAuto).SetAppLabel("项目名称","MCP上安装部署需求编号","项目经理名字","DBA名字","iMedical虚拟目录物理路径","iMedical版本号")
/// d ##class(DHCCSYS.SetDBAppLabelAuto).SetAppLabel("项目名称","MCP上安装部署需求编号","项目经理名字","DBA名字","D:\dthealth\app\dthis","8.4.2")
ClassMethod SetAppLabel(sHospitalName, sMcpReqNum, sPMName, sDBAName, sAppDir, sVersion As %String) As %String
{
}

}
