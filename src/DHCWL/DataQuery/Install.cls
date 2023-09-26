/// 名称: DHCWL.DataQuery.Install
/// 描述: 指标数据查询安装类
/// 编写者：王峥
/// 编写日期: 2017-7
Class DHCWL.DataQuery.Install Extends %RegisteredObject
{

/// Creator：      	王峥
/// CreatDate：    	2017-7
/// Description:   	注册指标数据查询版本
/// Table：       	DHCWL.BaseDataQuery.VerManagement
/// Input：         
/// Output： 
/// Return：		
/// d ##class(DHCWL.DataQuery.Install).RegVersion()
ClassMethod RegVersion() As %Status
{
	s detail=##class(DHCWL.DataQuery.VerManagement).%New()
	s detail.VMDName = "指标数据查询"
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
/// CreatDate：    	2017-7
/// Description:   	安装指标数据查询版本
/// Table：       	
/// Input：         
/// Output： 
/// Return：		
ClassMethod Install(cspProjPath As %String = "dthealth/web/csp/")
{

		s ret=..RegVersion()		//注册版本
		if $$$ISOK(ret)
		{
			//w !,"The installation is complete !"
			s ret=..AddDefaultBT()
			if ret="" w !,"The installation is complete !"
		}else{
			w !,"Register version fail!"
		}
}

/// d ##class(DHCWL.DataQuery.Install).AddDefaultBT()
ClassMethod AddDefaultBT() As %String
{
	s ret=0
	//如果已存在就退出
	q:$d(^DHCWL.DataQuery.BusinessTypeI("InxCode","SysDefaultBT")) ret
	
	&sql(INSERT INTO DHCWL_DataQuery.BusinessType (Code,Descript,Remarks) VALUES ("SysDefaultBT","系统内置类型","非标指标全部归入到此类型")  )
	
	IF (SQLCODE = 0) {
		s btRowID=%ROWID
		s kpiID=""
		f {
			s kpiID=$o(^DHCWL.MKPI.MKPID(kpiID))
			q:kpiID=""
			
			
			s kpiCode=$lg(^DHCWL.MKPI.MKPID(kpiID),2)
			continue:$d(^DHCWL.DataQuery.BTSubI("BTCodeKPICode","SysDefaultBT",kpiCode))
			s secFlagDr=$lg(^DHCWL.MKPI.MKPID(kpiID),11)
			continue:$g(secFlagDr)=""
			&sql(INSERT INTO DHCWL_DataQuery.BTSub (BusinessTypeCode,KPICode) VALUES ("SysDefaultBT",:kpiCode))
			if (SQLCODE'= 0) {
				s ret=1
				w !,"INSERT INTO DHCWL_DataQuery.BTSub失败,SQLCODE="_SQLCODE
			}
			q:SQLCODE'=0 
		}
	}
	q ret
}

}
