Class DHCWL.BaseDataQuery.Install Extends %RegisteredObject
{

/*
	cspProjPath:项目路径
*/
ClassMethod CompileProj(cspProjPath As %String = "dthealth/web/csp/") As %Status
{
	s ret=$$$OK
	//需要编译的类文件
	s classlist("DHCWL.BaseDataQuery.QueryObj.cls")="" 
	s classlist("DHCWL.BaseDataQuery.Item.cls")=""		
	s classlist("DHCWL.BaseDataQuery.QryobjPro.cls")=""
	s classlist("DHCWL.BaseDataQuery.ReportCfg.cls")=""
	s classlist("DHCWL.BaseDataQuery.ReportCfgSub.cls")=""
	s classlist("DHCWL.BaseDataQuery.URMap.cls")=""
	s classlist("DHCWL.BaseDataQuery.Util.cls")=""
	s classlist("DHCWL.BaseDataQuery.Interface.cls")=""
	s classlist("DHCWL.BaseDataQuery.VerManagement.cls")=""
	s classlist("DHCWL.util.GetSetService.cls")=""

	//需要编译的CSP文件
	s cspList(cspProjPath_"dhcwl/basedataquery/createqueryobj.csp")=""
	s cspList(cspProjPath_"dhcwl/basedataquery/dataqrycfg.csp")=""
	s cspList(cspProjPath_"dhcwl/basedataquery/maintainbdq.csp")=""
	s cspList(cspProjPath_"dhcwl/basedataquery/qryobjpro.csp")=""
	s cspList(cspProjPath_"dhcwl/basedataquery/qryuserright.csp")=""
	s cspList(cspProjPath_"dhcwl/basedataquery/queryobj.csp")=""			
	
	//编译类文件
	w !,"Compiling CLS files"		
	s sc=$system.OBJ.CompileList(.classlist)

	if $$$ISERR(sc){ 
		d $system.OBJ.DisplayError(sc)
		q sc
	}else{
		//编译CSP文件
		w !,"Compiling CSP files"		
		s sc=$system.OBJ.CompileList(.cspList)
	
		if $$$ISERR(sc){ 
			d $system.OBJ.DisplayError(sc)
			q sc
		}
		w !,"Compilation finished successfully!"
	}
	q ret
}

/// d ##class(DHCWL.BaseDataQuery.Install).RegVersion()
ClassMethod RegVersion() As %Status
{
	s detail=##class(DHCWL.BaseDataQuery.VerManagement).%New()
	s detail.VMDName = "基础数据查询"
	s detail.VMDCode = "V2.1.0"
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

// d ##class(DHCWL.BaseDataQuery.Install).Install()

ClassMethod Install(cspProjPath As %String = "dthealth/web/csp/")
{
	s ret=..CompileProj(cspProjPath)	//编译文件
	if $$$ISOK(ret){ 
		s ret=..RegVersion()		//注册版本
		if $$$ISOK(ret)
		{
			s ret=##class(DHCWL.BaseDataQuery.Install).BuildDS()
			if ret="" w !,!,"The installation is complete !"
			else  w !,"BuildData Soruce fail!"_ret		
		}
		/*
		{
			s ret=##class(DHCWL.BaseDataQuery.Interface).ImpGlobal2QryObj("A")
			if ret'="" {
				w !,ret	
			}else{
				s ret=##class(DHCWL.BaseDataQuery.Interface).ImpGlobal2RptObj()
				if ret'="" {
					w !,ret
					q	
				}
				w !,"Import Query Object complete!"
				w !,"Register version complete!"
				w !,!,"The installation is complete !"
			}
		}
		*/
		else
		{
			w !,"Register version fail!"		
		}
			
	}else{
		w !,"Compile Project fail!"	
	}
}

/// Creator：      王峥
/// CreatDate：    2018-10-11
/// Description:：   收集数据源数据并保存到表里
/// Table：       	DHCWL_BaseDataQuery.DS，DHCWL_DM_T.ThemeBase
/// Input：          无
/// Output：         无
/// Return：         是否成功的说明
/// Others：        其它说明
/// d ##class(DHCWL.BaseDataQuery.Install).BuildDS()
ClassMethod BuildDS() As %String
{
	s $zt="SQLErr"
	s ret=""
	//1、得到所有主题数据
	s list= ##class(DHCWL.DM.T.ThemeBase).GetAll()
	s cnt=list.Count() 
	f i=1:1:cnt {
		s obj=list.GetAt(i)	
		s code=obj.Code
		s name=obj.Name
		s descript=obj.Description
		s type="主题"
		if $d(^DHCWL.BaseDataQuery.DSI("InxCodeType",code,type)) continue
		
		s themePath=obj.GetPath()
		s newObj=##class(DSPB).%New()
		s newObj.Code=code
		s newObj.Name=name
		s newObj.Descript=descript
		s newObj.Type=type
		s newObj.themePath=themePath
		s sc=newObj.%Save()
		If $$$ISERR(sc) {
			s ret="新建报表对象失败:"_$System.Status.GetErrorText(sc)
	 	}
	 	d newObj.%Close()
	 	if ret'="" q 
	}
	if ret'="" q ret
	
	//2、插入指标数据源	
	//allKPI
	s code="allKPI"
	s name="所有指标"
	s descript="所有指标"
	s type="指标"
	if '$d(^DHCWL.BaseDataQuery.DSI("InxCodeType",code,type)) {
		s newObj=##class(DSKPI).%New()
		s newObj.Code=code
		s newObj.Name=name
		s newObj.Descript=descript
		s newObj.Type=type
		s sc=newObj.%Save()
		If $$$ISERR(sc) {
			s ret="新建报表对象失败:"_$System.Status.GetErrorText(sc)
	 	}
	 	d newObj.%Close()	
	} 	
		
	q ret
SQLErr
	if ret="" s ret="新建查询对象失败:"_$ZERROR
	q ret
}

}
