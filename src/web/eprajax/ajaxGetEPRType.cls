/// 名称: 获取患者病历类型;
/// 描述: 用于电子病历主页判断当前患者是加载老病历还是新病历;
/// 编写者：Zuoxiang Xie
/// 编写日期: 19/07/2011
Class web.eprajax.ajaxGetEPRType Extends %CSP.Page [ ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	s episodeID = $Get(%request.Data("EpisodeID",1),"-1")
	
	s count = ##Class(EPRinstance.ECRecord).GetOldRecCount(episodeID)
	
	s typeID = $s(count>0:"0",1:"1")
	w typeID
	
	q $$$OK
}

}
