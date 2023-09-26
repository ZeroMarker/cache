/// 监控接口
Class DHCMed.CCService.RunningProcess.ControlService Extends DHCMed.Abstract [ Not ProcedureBlock ]
{

/// 业务中监控方法
/// 参数：
/// EpisodeID:就诊ID
/// KeywordCode:关键字代码（大小写无关）
/// 返回值：
/// 监控完毕，返回 “OK”
/// w ##class(DHCMed.CCService.RunningProcess.ControlService).DiseaseControl(242,"EPDDIAGNOSE")
ClassMethod DiseaseControl(EpisodeID As %Integer, KeywordCode As %String) As %Integer
{
	n (EpisodeID,KeywordCode)	
	Set FromDate=+$h
	Set ToDate=+$h
	Set ret=0
	Set objSubject=##class(DHCMed.CC.Subject).GetObjByCode("DIACC") //DIACC 是最新的疾病监控主题
	Quit:$IsObject(objSubject)=0 -1
	Set objKeyword=##class(DHCMed.CC.KeyWord).GetObjByCode(KeywordCode)
	Quit:$IsObject(objKeyword)=0 -2
	Set result=##class(DHCMed.CCService.RunningProcess.CoreVM).Process(objSubject.%Id(),FromDate,ToDate,EpisodeID,objKeyword.%Id())
	Quit result
}

}
