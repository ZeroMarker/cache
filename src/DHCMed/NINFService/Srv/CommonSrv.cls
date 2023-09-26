/// 名称: DHCMed.NINFService.Srv.CommonSrv
/// 描述: 接口文件,为了提高加载速度
/// 编写者：zhufei
/// 编写日期: 2012-10-23
Class DHCMed.NINFService.Srv.CommonSrv Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod ChangeDateFormatToHtml(aValue As %String) As %String
{
	Set return=##Class(DHCMed.NINFService.Srv.CommonCls).ChangeDateFormatToHtml(aValue)
	Quit return
}

ClassMethod ChangeDateFormat(aValue As %String, aFormat As %String = "3") As %String
{
	Set return=##Class(DHCMed.NINFService.Srv.CommonCls).ChangeDateFormat(aValue,aFormat)
	Quit return
}

ClassMethod ChangeTimeFormat(aValue As %String, aFormat As %String = "1") As %String
{
	Set return=##Class(DHCMed.NINFService.Srv.CommonCls).ChangeTimeFormat(aValue,aFormat)
	Quit return
}

ClassMethod GetDicsByType(aType As %String) As %String
{
	Set return=##Class(DHCMed.NINFService.Srv.CommonCls).GetDicsByType(aType)
	Quit return
}

ClassMethod GetTemplatePath() As %String
{
	Set return=##class(DHCMed.NINFService.Srv.CommonCls).GetTemplatePath()
	Quit return
}

ClassMethod GetSSDicList(argTypeCode As %String, argActive As %String) As %String
{
	Set return=##class(DHCMed.NINFService.Srv.CommonCls).GetSSDicList(argTypeCode,argActive)
	Quit return
}

ClassMethod GetMrNoByAdm(aEpisodeID As %String) As %String
{
	Set return=##class(DHCMed.NINFService.Srv.CommonCls).GetMrNoByAdm(aEpisodeID)
	Quit return
}

ClassMethod GetTransLocList(aEpisodeID As %String, aTransType As %String) As %String
{
	Set return=##class(DHCMed.NINFService.Srv.CommonCls).GetTransLocList(aEpisodeID,aTransType)
	Quit return
}

}
