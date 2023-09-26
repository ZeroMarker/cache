/// 名称: DHCMed.INFService.ReportExportSrv
/// 描述: 基于报告表的导出 模块类
/// 编写者：ChenJB
/// 编写日期: 2010-06-18
Class DHCMed.INFService.ReportExportSrv Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     陈剑波
/// CreatDate：   2010-06-18
/// Description:  查询服务器信息 打印模板位置
/// Table：       websys.config
/// Input：       
/// output:             
/// Return：w ##class(DHCMed.INFService.ReportExportSrv).GetCrServerInfo()
ClassMethod GetCrServerInfo() As %String
{
	n
	s CurrentNS=$ZNSPACE
	s Config=##class(websys.Configuration).%OpenId(1)
	s MEDDATA=Config.DataNamespace
	s LABDATA=Config.LabDataNamespace
	s Server=Config.WebServer
	S Path=Config.PathToReports
	//华西用该值 Path访问模板
	s crServer=Config.URLToCrystalReports
	s LayOutManager=Config.LayoutManager
	s WebServerAppURL = "http://"_Config.WebServer_Config.PathToApp
	d Config.%Close()
    s s=CurrentNS_$c(1)_MEDDATA_$c(1)_LABDATA_$c(1)_Server_$c(1)_Path_$c(1)_LayOutManager_$C(1)_WebServerAppURL
	q crServer
}

/// w ##class(DHCMed.INFService.ReportExportSrv).GetReplaceInfo("通知下好,好不下!","下","下午")
ClassMethod GetReplaceInfo(SS As %String = "", OldStr As %String, NewStr As %String) As %String
{
	n (SS,OldStr,NewStr)
	s ret=""
	q:(SS="")!(OldStr="") SS
	
	for  q:$f(SS,OldStr)=0  d
	.s ret=ret_$p(SS,OldStr,1)
	.s ret=ret_NewStr
	.s pos=$f(SS,OldStr)
	.s SS=$e(SS,pos,$l(SS))	
	.s:$f(SS,OldStr)=0 ret=ret_SS
	.//w SS,!
	q ret
}

}
