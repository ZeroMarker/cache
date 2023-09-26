/// 综合监测系统接口
/// 创建者：李阳
/// 创建日期：2012-11-26
/// 
Class DHCMed.NINFService.Srv.INTInterface Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// w ##class(DHCMed.NINFService.Srv.INTInterface).GetIntCntResult("INFAW",16833241)
ClassMethod GetIntCntResult(SubjectCode As %String, EpisodeID As %String, ConfigCode As %String = "") As %String
{
	New (EpisodeID,SubjectCode,ConfigCode)
	Set return=""
	Quit:(EpisodeID="")||((SubjectCode="")&&(ConfigCode="")) return
	
	Set $ZT="GetIntCntResultErr"
	
	Set result=##class(DHCMed.CCService.IntegratedCtrl.Common).GetICResult(SubjectCode,EpisodeID,ConfigCode)
	For i=1:1:$l(result,$c(1)) {
		Set tmp=$p(result,$c(1),i)
		Continue:tmp=""
		Continue:$p(tmp,"^",2)=0
		Set DicName=$p(tmp,"^",1)
		Continue:DicName=""
		//易感因素自动对照
		Set DicCode=##Class(DHCMed.SSService.DictionarySrv).GetIDByDesc("","NINFInfInfFactors",DicName)
		If DicCode'="" {
			Set objDic=##class(DHCMed.SS.Dictionary).GetByTypeCode("NINFInfInfFactors",DicCode,1)
			If $IsObject(objDic) {
				Set return=return_","_objDic.%Id()
			}
		}
		//侵害性操作自动对照
		Set DicCode=##Class(DHCMed.SSService.DictionarySrv).GetIDByDesc("","NINFInfInvasiveOper",DicName)
		If DicCode'="" {
			Set objDic=##class(DHCMed.SS.Dictionary).GetByTypeCode("NINFInfInfFactors",DicCode,1)
			If $IsObject(objDic) {
				Set return=return_","_objDic.%Id()
			}
		}
	}
	Set:return'="" return=$e(return,2,$l(return))
	Quit return
	
GetIntCntResultErr
	Quit ""
}

}
