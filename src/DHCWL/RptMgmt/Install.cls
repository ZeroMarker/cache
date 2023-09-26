Class DHCWL.RptMgmt.Install Extends %RegisteredObject
{

/// d ##class(DHCWL.RptMgmt.Install).RegVersion()
ClassMethod RegVersion() As %Status
{
	s detail=##class(DHCWL.RptMgmt.VerManagement).%New()
	s detail.VMDName = "报表管理"
	s detail.VMDCode = "V2.1.0"
	s detail.VMDTSName = "王峥"
	s detail.VMDremarks="V1.0.0，1、按照公司UI规范，对界面进行了调整。2、‘其他备注’使用了htmlediter。3、在‘新增’中加入了‘加载其他说明’"
	s detail.VMDUpDate=$zd($p($h,",",1),3)
	s detail.VMDInstallDate=$zd($p($h,",",1),3)
	s detail.VMDInstallTime=$zt($p($h,",",2),1)
	Set sc = detail.%Save()
	If $$$ISERR(sc) {
		Do $System.Status.DisplayError(sc)
	}
	q sc
}

// d ##class(DHCWL.RptMgmt.Install).Install()

ClassMethod Install()
{
		s ret=..RegVersion()		//注册版本
		if $$$ISOK(ret)
		{
			w !,"The installation is complete !"		
		}
		else
		{
			w !,"Register version fail!"		
		}
}

}
