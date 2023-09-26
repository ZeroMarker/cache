/// 名称: DHCMed.SMDService.ExportSrv
/// 描述: 精神疾病报告打印
/// 编写者：李阳
/// 编写日期: 2014-12-15
Class DHCMed.SMDService.ExportSrv Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// 获取模板文件存放目录
/// w ##class(DHCMed.SMDService.ExportSrv).GetTemplatePath()
ClassMethod GetTemplatePath() As %String
{
	Set objConfig=##class(websys.Configuration).%OpenId(1)
	Do objConfig.%Close()
	Set strPath=objConfig.PathToReports
	Quit strPath
}

/// 转换日期格式
/// w ##Class(DHCMed.NINFService.Srv.CommonCls).ChangeDateFormat(+$h,3)
ClassMethod ChangeDateFormat(aValue As %String, aFormat As %String = "3") As %String
{
	New (aValue,aFormat)
	Set return=""
	Quit:aValue="" return
	Set aFormat=+aFormat
	Quit:(aFormat'=3)&&(aFormat'=4) return
	Set:aValue["-" aValue=$zdh(aValue,3)
	Set:aValue["/" aValue=$zdh(aValue,4)
	Set return=$zd(aValue,aFormat)
	Quit return
}

}
