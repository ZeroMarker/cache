/// DHC Web Medical Record runtime quality monitor 
/// Build Temporary global
/// By wuqk 2007-12
Class web.DHCWMRQuality.BOExpressionExplain Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 11;

ClassMethod BuildTemporary(ExamEntryRowId, EpisodeID)
{
	n (ExamEntryRowId,EpisodeID)
	Set ret=""
	Set ExamRuleDr=+ExamEntryRowId
	Set ExamSecSub=+$p(ExamEntryRowId,"||",2)
	Set ExamEntrySub=+$p(ExamEntryRowId,"||",3)
	Set ExamSecDr=ExamRuleDr_"||"_ExamSecSub
		
	;ExamRule
	Set sExamRule=##class(web.DHCWMRQualityBaseCtl).GetERById(ExamRuleDr)
	Set RuleDicDr=$p(sExamRule,"^",2)
	Set Active=$p(sExamRule,"^",9)
	Quit:Active'["Y" ret
	
	;RuleDic
	Set sRuleDic=##class(web.DHCWMRQualityBaseCtl).GetDicRById(RuleDicDr)
	Set RuleTitle=$p(sRuleDic,"^",3)
	Set Active=$p(sRuleDic,"^",5)
	Quit:Active'["Y" ret
		
	;ExamSection
	Set sExamSec=##class(web.DHCWMRQualityBaseCtl).GetESById(ExamSecDr)
	Set SecDicDr=$p(sExamSec,"^",2)
	Set Active=$p(sExamSec,"^",5)
	Quit:Active'["Y" ret
	
	;SectionDic
	Set sSecDic=##class(web.DHCWMRQualityBaseCtl).GetDicSById(SecDicDr)
	Set SecTitle=$p(sSecDic,"^",3)
	Set Active=$p(sSecDic,"^",5)
	Quit:Active'["Y" ret
	
	;ExamEntry
	Set sExamEntry=##class(web.DHCWMRQualityBaseCtl).GetEEById(ExamEntryRowId)
	Set EntryDr=+$p(sExamEntry,"^",2)
	Set Active=$p(sExamEntry,"^",11)
	Quit:Active'["Y" ret
	
	;EntryDic
	Set sEntryDic=##class(web.DHCWMRQualityBaseCtl).GetDicEById(EntryDr)
	Set EntryTitle=$p(sEntryDic,"^",3)
	Set Active=$p(sEntryDic,"^",5)
	Quit:Active'["Y" ret
	
	Set ret=##class(web.DHCWMRQuality.BOEntryExpExplain).ExplainEntry(ExamEntryRowId,EpisodeID,.TempIndex)
	If +ret
	{
		Set ^CacheTemp("DHCWMRQuality",$j,EpisodeID,ExamRuleDr)=RuleTitle
		Set ^CacheTemp("DHCWMRQuality",$j,EpisodeID,ExamRuleDr,ExamSecSub)=SecTitle
		M ^CacheTemp("DHCWMRQuality",$j,EpisodeID,ExamRuleDr,ExamSecSub,ExamEntrySub)=TempIndex($j)
		Set ^CacheTemp("DHCWMRQuality",$j,EpisodeID,ExamRuleDr,ExamSecSub,ExamEntrySub)=EntryTitle
	}
	Quit ret
}

}
