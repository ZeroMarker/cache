/// 
/// 名称: DHCMed.Service
/// 描述: DHCMedBase 2.0 对外提供的接口
/// 编写者：wuqk
/// 编写日期: 2010-08-03
Class DHCMed.Service Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// 获取模板文件存放目录
/// w ##class(DHCMed.Service).GetTemplatePath()
ClassMethod GetTemplatePath() As %String
{
	New
	Set strPath=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHosp("SSTemplatePath")
	If strPath="" {
		Set objConfig=##class(websys.Configuration).%OpenId(1)
		Do objConfig.%Close()
		Set strPath=objConfig.PathToReports
	} Else {
		Set strPath=$tr(strPath,"/","\")
	}
	Quit strPath
}

/// 合并病人
/// 参数：
/// FromPatientID:源病人ID
/// ToPatientID:目标病人ID
/// UserId:操作用户ID
/// 功能：将病人ID从FromPatientID转到ToPatientID下
/// w ##class(DHCMed.Service).MergePatient(142721,112582,1)
ClassMethod MergePatient(FromPatientID As %String, ToPatientID As %String, UserId As %String) As %Integer
{
	new (FromPatientID,ToPatientID,UserId)
	
	//传染病报告
	set ret=##class(DHCMed.EPDService.Service).MergePatient(FromPatientID,ToPatientID,UserId)

	quit ret
}

/// 取消合并病人
/// 参数：
/// FromPatientID:源病人ID
/// ToPatientID:目标病人ID
/// UserId:操作用户ID
/// 功能：将曾经从FromPatientID转到ToPatientID下的病人ID还原
/// w ##class(DHCMed.Service).CancelMerge(142721,112582,1)
ClassMethod CancelMerge(FromPatientID As %String, ToPatientID As %String, UserId As %String) As %Integer
{
	n (FromPatientID,ToPatientID,UserId)
	
	//传染病报告
	set ret=##class(DHCMed.EPDService.Service).CancelMerge(FromPatientID,ToPatientID,UserId)
	
	quit ret
}

/// Creator：      zhufei
/// CreatDate：    2011-12-06
/// Description:   导出指定包名下的类,以单个XML文件形式存储(类名作为XML名称)
/// Input：        packagename：包名  nameAlias：指定类开头名 path：路径(c:\tmp\)。
/// Output：       对输出参数的说明
/// Return：       函数返回值的说明
/// Others：       w ##Class(DHCMed.Service).ExportClassByName("DHCMed.Test","","D:\"_$zd($h,3)_"\class\")
ClassMethod ExportClassByName(packagename As %String, nameAlias As %String, path As %String)
{
	New (packagename,nameAlias,path)
	
	Set path=$tr(path,"\","/")
	Set tmpChar=$e(path,$l(path)-1,$l(path))
    Set:tmpChar'="/" path=path_"/"
	
    s arrarylistcls=""
    s clsname="",clspath=""
	s clsCount=$system.OBJ.GetPackageList(.arrarylistcls,packagename)
	s clskey=""
	f  s clskey=$o(arrarylistcls(clskey)) q:clskey=""  d
	.q:clskey'[nameAlias
	.s clsname=clskey_".cls"
	.s clspath=path_clskey_".xml"
	.Do $system.OBJ.Export(clsname,clspath)
	
	Quit "DHCMed.Service.ExportClassByName() Over!"
}

/// Creator：      zhufei
/// CreatDate：    2011-12-06
/// Description:   导出指定名称的MAC,以单个XML文件形式存储(MAC名作为XML名称)
/// Input：        nameSpace: 名字空间 nameAlias：指定类开头名 path：路径(c:\tmp\)。
/// Output：       对输出参数的说明
/// Return：       函数返回值的说明
/// Others：       w ##Class(DHCMed.Service).ExportMACByName("DHC-Medsrc","DHCMed*.MAC","D:\"_$zd($h,3)_"\Medsrc\")
ClassMethod ExportMACByName(nameSpace As %String, nameAlias As %String, path As %String)
{
	New (nameSpace,nameAlias,path)
	
	Set path=$tr(path,"\","/")
	Set tmpChar=$e(path,$l(path)-1,$l(path))
    Set:tmpChar'="/" path=path_"/"
	
	Set currSpace=$ZNSPACE
	ZN nameSpace
	Set rs=##Class(%ResultSet).%New("%Library.Routine:RoutineList")
	Do rs.Execute(nameAlias)
	Set columns = rs.GetColumnCount()
	While (rs.Next()) {
		Set macName=rs.Data("Name")
		Set fileName=$e(macName,1,$l(macName)-4)_".xml"
		Set filePath=path_fileName
		Do $system.OBJ.Export(macName,filePath)
	}
	Do rs.Close()
	ZN currSpace
	
	Quit "DHCMed.Service.ExportMACByName() Over!"
}

/// Creator：      zhufei
/// CreatDate：    2011-12-06
/// Description:   导出指定名称的CSP,以单个XML文件形式存储(CSP名作为XML名称)
/// Input：        nameAlias：指定类开头名 path：路径(c:\tmp\)。
/// Output：       对输出参数的说明
/// Return：       函数返回值的说明
/// Others：       w ##Class(DHCMed.Service).ExportCSPByName("dhcmed*.csp","D:\"_$zd($h,3)_"\csp\")
ClassMethod ExportCSPByName(nameAlias As %String, path As %String)
{
	New (nameAlias,path)
	
	Set path=$tr(path,"\","/")
	Set tmpChar=$e(path,$l(path)-1,$l(path))
    Set:tmpChar'="/" path=path_"/"
	
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set PathToApp=Config.PathToApp
    Set PathToApp=$tr(PathToApp,"\","/")
    Set tmpChar=$e(PathToApp,$l(PathToApp)-1,$l(PathToApp))
    Set:tmpChar'="/" PathToApp=PathToApp_"/"
    
	Set nameAlias=PathToApp_"csp/"_nameAlias
	Set rs=##Class(%ResultSet).%New("%Library.RoutineMgr:StudioOpenDialog")
	Do rs.Execute(nameAlias)
	Set columns = rs.GetColumnCount()
	While (rs.Next()) {
		Set cspName=rs.Data("Name")
		Continue:$ZCVT(cspName,"U")'[".CSP"
		Set fileName=cspName_".xml"
		Set filePath=path_fileName
		Set cspName=PathToApp_"csp/"_cspName
		Do $system.OBJ.Export(cspName,filePath)
	}
	Do rs.Close()
	
	Quit "DHCMed.Service.ExportCSPByName() Over!"
}

/// Creator：      zhufei
/// CreatDate：    2011-12-06
/// Description:   导出指定名称的Global,以单个XML文件形式存储(Global名作为XML名称)
/// Input：        nameAlias：指定类开头名 path：路径(c:\tmp\)。
/// Output：       对输出参数的说明
/// Return：       函数返回值的说明
/// Others：       w ##Class(DHCMed.Service).ExportGlobalByName("DHCMed.EPD.GBL","D:\"_$zd($h,3)_"\data\")
ClassMethod ExportGlobalByName(nameAlias As %String, path As %String)
{
	New (nameAlias,path)
	
	Set path=$tr(path,"\","/")
	Set tmpChar=$e(path,$l(path)-1,$l(path))
    Set:tmpChar'="/" path=path_"/"
	
	Set fileName=$e(nameAlias,1,$l(nameAlias)-4)_".xml"
	Set filePath=path_fileName
	Do $system.OBJ.Export(nameAlias,filePath)
	
	Quit "DHCMed.Service.ExportGlobalByName() Over!"
}

}
