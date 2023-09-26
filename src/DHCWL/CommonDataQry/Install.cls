/// 名称: DHCWL.CommonDataQry.Install
/// 描述: 通用简单数据查询类
/// 编写者：王峥
/// 编写日期: 2017-8
Class DHCWL.CommonDataQry.Install Extends %RegisteredObject
{

/// Creator：      	王峥
/// CreatDate：    	2017-8
/// Description:   	注册通用简单数据查询版本
/// Table：       	DHCWL.CommonDataQry.VerManagement
/// Input：         
/// Output： 
/// Return：		
/// d ##class(DHCWL.CommonDataQry.Install).RegVersion()
ClassMethod RegVersion() As %Status
{
	s detail=##class(DHCWL.CommonDataQry.VerManagement).%New()
	s detail.VMDName = "通用简单数据查询"
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

/// Creator：      	王峥
/// CreatDate：    	2017-8
/// Description:   	安装通用简单数据查询版本
/// Table：       	
/// Input：         
/// Output： 
/// Return：
ClassMethod Install()
{
		s ret=..RegVersion()		//注册版本
		if $$$ISOK(ret)
		{
			w !,"The installation is complete !"
		}else{
			w !,"Register version fail!"
		}
}

}
