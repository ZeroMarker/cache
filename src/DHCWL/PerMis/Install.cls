Class DHCWL.PerMis.Install Extends %RegisteredObject
{

/// d ##class(DHCWL.PerMis.Install).RegVersion()
ClassMethod RegVersion() As %Status
{
	s detail=##class(DHCWL.PerMis.VerManagement).%New()
	s detail.VMDName = "报表权限管理"
	s detail.VMDCode = "V1.0.0"
	s detail.VMDTSName = "王峥"
	s detail.VMDremarks=""
	s detail.VMDUpDate=$zd($p($h,",",1),3)
	s detail.VMDInstallDate=$zd($p($h,",",1),3)
	s detail.VMDInstallTime=$zt($p($h,",",2),1)
	Set sc = detail.%Save()
	If $$$ISERR(sc) {
		Do $System.Status.DisplayError(sc)
	}
	q sc
}

/// d ##class(DHCWL.PerMis.Install).AddAdminGrp()
ClassMethod AddAdminGrp() As %String
{
	if $d(^DHCWL.PerMis.GrpI("InxCode","Admin")) q ""
	s inParam("Code")="Admin"
	s inParam("Descript")="系统超级权限组"
	s ret=##class(DHCWL.PerMis.Grp).Insert(.inParam,.outParam)
	q ret
}

ClassMethod Install()
{
	//增加超级用户
	/*s ret= ##class(DHCWL.PerMis.Install).AddAdminGrp()
	if ret'="" {
		w !,ret
		q	
	}
	*/
	//注册版本
	d ##class(DHCWL.PerMis.Install).RegVersion()
}

}
