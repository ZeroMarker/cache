/// DHC Web Medical Record runtime quality monitor 
/// Interface for EPR
/// By wuqk 2007-12
Class web.DHCWMRQuality.BOInterfaceEPR Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 12;

ClassMethod CheckTemplate(TemplateIndex As %String, EpisodeID As %String) As %String
{
	n (TemplateIndex,EpisodeID)
	Set ret=$j
	Quit:'$d(^PAADM(+EpisodeID)) ret
	Kill ^CacheTemp("DHCWMRQuality",$j,EpisodeID)
	Kill ^CacheTemp("DHCWMRQuality",$j,"ERROR")
	Set qryTmp=TemplateIndex
	
	If $d(^DHCWMRERi(0,"TemplateEntry",qryTmp))   ;If have some ExamEntrys of this TemplateIndex
	{
		Set ExamEntryRowId=""
		For  Set ExamEntryRowId=$o(^DHCWMRERi(0,"TemplateEntry",qryTmp,ExamEntryRowId)) Quit:ExamEntryRowId=""  d
		.;Set ret=$$BuildTemporary(ExamEntryRowId,EpisodeID)
		.;Set ret=##class(web.DHCWMRQuality.BOExpressionExplain).BuildTemporary(ExamEntryRowId,EpisodeID)
		.s ExamRuleRowId=+ExamEntryRowId
		.s RuleRowId=$p($g(^DHCWMRER(ExamRuleRowId)),"^",1)
		.s RuleTypeCode=##class(web.DHCWMRQualityDic).GetRuleType(RuleRowId)
		.q:RuleTypeCode'="B"                      ;只检查运行质控标准 by wuqk 2008-04
		.//20090525 ZF 升级版用
		.Set ret=##class(web.DHCWMRQuality.BOEntryExpExplain).ExplainExamEntry(ExamEntryRowId,EpisodeID,"","")
		.//20090525 ZF 旧版本用
		.//Set ret=##class(web.DHCWMRQuality.BOEntryExpExplain).ExplainExamEntry(ExamEntryRowId,EpisodeID)
	}
	Else ;If have some ExamEntrys begin of this TemplateIndex
	{
		;TemplateIndex is TempId or is TempId.SmipleCode
		;If it's a short TempId,it mast add a "."
		;For an example,TempIndex1="5011.S001",TempIndex2="501.S002",
		;if you put in "501",you cann't get TempIndex1
		
		Set:qryTmp'["." qryTmp=qryTmp_"."
		Set TmpFlag=qryTmp
		For  Set qryTmp=$o(^DHCWMRERi(0,"TemplateEntry",qryTmp)) q:qryTmp'[TmpFlag  d
		.Set ExamEntryRowId=""
		.For  Set ExamEntryRowId=$o(^DHCWMRERi(0,"TemplateEntry",qryTmp,ExamEntryRowId)) Quit:ExamEntryRowId=""  d
		..;Set ret=$$BuildTemporary(ExamEntryRowId,EpisodeID)
		..;Set ret=##class(web.DHCWMRQuality.BOExpressionExplain).BuildTemporary(ExamEntryRowId,EpisodeID)
		..s ExamRuleRowId=+ExamEntryRowId
		..s RuleRowId=$p($g(^DHCWMRER(ExamRuleRowId)),"^",1)
		..s RuleTypeCode=##class(web.DHCWMRQualityDic).GetRuleType(RuleRowId)
		..q:RuleTypeCode'="B"                      ;只检查运行质控标准 by wuqk 2008-04
		..//20090525 ZF 升级版用
		..Set ret=##class(web.DHCWMRQuality.BOEntryExpExplain).ExplainExamEntry(ExamEntryRowId,EpisodeID,"","")
		..//20090525 ZF 旧版本用
		..//Set ret=##class(web.DHCWMRQuality.BOEntryExpExplain).ExplainExamEntry(ExamEntryRowId,EpisodeID)
		..
	}
	Set ret=$j
	Quit ret
}

/// ***************************************************************
/// 说明           ：旧接口、执行病案质控评估标准检查病历
/// ***************************************************************
/// 入参           ：
/// ExamRuleRowid  ：评估标准ID
/// EpisodeID      ：就诊号
/// ***************************************************************
/// 返回值         ：
/// jIndex         ：$j
/// ***************************************************************
/// 临时Global     ：记录病历质量检查结果
///                ：^CacheTemp("DHCWMRQuality",$j,EpisodeID,ExamRuleDr)=RuleTitle
///                ：^CacheTemp("DHCWMRQuality",$j,EpisodeID,ExamRuleDr,ExamSecSub)=SecTitle
///                ：^CacheTemp("DHCWMRQuality",$j,EpisodeID,ExamRuleDr,ExamSecSub,ExamEntrySub)=EntryTitle
/// ***************************************************************
/// 调试           ：w ##Class(web.DHCWMRQuality.BOInterfaceEPR).GetRunTimeQuality(评估标准ID,就诊号)
/// ***************************************************************
ClassMethod GetRunTimeQuality(ExamRuleRowid As %String, EpisodeID As %String) As %String
{
	n (ExamRuleRowid,EpisodeID)
	s jIndex=$j
	q:'$d(^DHCWMRER(ExamRuleRowid)) jIndex
	
	s Section=0
	f  s Section=$o(^DHCWMRER(ExamRuleRowid,"S",Section)) q:Section=""  d
	.s Entry=0
	.f  s Entry=$o(^DHCWMRER(ExamRuleRowid,"S",Section,"E",Entry)) q:Entry=""  d
	..s EntryRowid=ExamRuleRowid_"||"_Section_"||"_Entry
	..//20090525 ZF 升级版用
	..s flag=##class(web.DHCWMRQuality.BOEntryExpExplain).ExplainExamEntry(EntryRowid,EpisodeID,"","")
	..//20090525 ZF 旧版本用
	..//s flag=##class(web.DHCWMRQuality.BOEntryExpExplain).ExplainExamEntry(EntryRowid,EpisodeID)
	
	q jIndex
}

/// ***************************************************************
/// 说明           ：新接口、执行病案质控评估标准检查病历
/// ***************************************************************
/// 入参           ：
/// EpisodeID      ：就诊号
/// TemplateID     ：模板ID
/// EventType      ：事件类型
/// InstanceIDs    : 可重复模板IDs
/// ***************************************************************
/// 返回值         ：
/// jIndex         ：$j
/// ***************************************************************
/// 临时Global     ：记录病历质量检查结果
///                ：^CacheTemp("DHCWMRQuality",$j,EpisodeID,ExamRuleDr)=RuleTitle
///                ：^CacheTemp("DHCWMRQuality",$j,EpisodeID,ExamRuleDr,ExamSecSub)=SecTitle
///                ：^CacheTemp("DHCWMRQuality",$j,EpisodeID,ExamRuleDr,ExamSecSub,ExamEntrySub)=EntryTitle
/// ***************************************************************
/// 调试           ：w ##Class(web.DHCWMRQuality.BOInterfaceEPR).GetRunTimeQualityNew(就诊号,界面模板ID,事件类型,可重复模板记录IDs)
/// ***************************************************************
ClassMethod GetRunTimeQualityNew(EpisodeID As %String, TemplateID As %String, EventType As %String, InstanceIDs As %String) As %String
{
	n (EpisodeID,TemplateID,EventType,InstanceIDs)
	//s ^ZF(EpisodeID)=$lb(EpisodeID,TemplateID,EventType,InstanceIDs)
	s jIndex=$j
	q:(EpisodeID="")||(TemplateID="")||(EventType="") jIndex
	
	//20090525 ZF 升级版病案质控走配置
	k ^CacheTemp("DHCWMRQuality",jIndex)
	s ExamRuleRowid=""
	s ExamRuleRowid=$p(##Class(web.DHCWMRQuality.BOACRExpBaseConfig).GetEPRExamRule(TemplateID,EventType),"^",4)
	i ExamRuleRowid="" d
	.s ExamRuleRowid=##class(EPRmeta.SysOption).GetOptionValueByName("EPRExamRuleRunTimeDr")
	.q:ExamRuleRowid=""
	.s jIndex=..GetRunTimeQuality(ExamRuleRowid,EpisodeID)
	e  d
	.q:'$d(^DHCWMRER(ExamRuleRowid))
	.//TempIdList=$lb()  唯一/可重复模板ID
	.s TempIdList=""
	.s:EventType="Print" TempIdList=##Class(web.DHCWMRQuality.BOACRExpBaseConfig).GetEPRTemIdList(TemplateID)
	.s:EventType="Save" TempIdList=$lb(TemplateID)
	.s InstIdList=""
	.//InstIdList=$lb()  可重复模板记录ID
	.s InstanceIDs=$tr(InstanceIDs,$c(0),"")
	.i InstanceIDs'="" d
	..f Ind=1:1:$length(InstanceIDs,",") d
	...s tmp=$p(InstanceIDs,"^",Ind)
	...q:tmp=""
	...s InstIdList=InstIdList_$lb(tmp)
	.//逐条检查病案质控项目
	.s Section=0
	.f  s Section=$o(^DHCWMRER(ExamRuleRowid,"S",Section)) q:Section=""  d
	..s Entry=0
	..f  s Entry=$o(^DHCWMRER(ExamRuleRowid,"S",Section,"E",Entry)) q:Entry=""  d
	...s EntryDr=+$p($g(^DHCWMRER(ExamRuleRowid,"S",Section,"E",Entry)),"^",1)
	...q:$p($g(^DHCWMREDIC(EntryDr)),"^",4)'="Y"
	...q:(EntryDr>2000)&(TempIdList'="")&($listfind(TempIdList,$p($g(^DHCWMREPRTEM(+EntryDr-2000)),"^",1))<1)
	...s EntryRowid=ExamRuleRowid_"||"_Section_"||"_Entry
	...s flag=##class(web.DHCWMRQuality.BOEntryExpExplain).ExplainExamEntry(EntryRowid,EpisodeID,TempIdList,InstIdList)
	...//s ^ZF(EntryRowid)=$lb(EntryRowid,EpisodeID,TempIdList,InstIdList,flag)
	/*********************************************************
	//20090525 ZF 旧版病案质控走电子病历参数设置
	s ExamRuleRowid=##class(EPRmeta.SysOption).GetOptionValueByName("EPRExamRuleRunTimeDr")
	q:ExamRuleRowid="" ret
	s jIndex=..GetRunTimeQuality(ExamRuleRowid,EpisodeID)
	*********************************************************/
	q jIndex
}

/// ***************************************************************
/// 说明           ：取病案质控控制类型
/// ***************************************************************
/// 入参           ：
/// TemplateID     ：病历内容
/// EventType      ：事件类型
/// ***************************************************************
/// 返回值         ：
/// ret            ：控制类型  “ret=0”不允许通过  “ret=1”允许通过
/// ***************************************************************
/// 调试           ：w ##Class(web.DHCWMRQuality.BOInterfaceEPR).GetControlType(界面模板ID,事件类型)
/// ***************************************************************
ClassMethod GetControlType(TemplateID As %String, EventType As %String) As %String
{
	n (TemplateID,EventType)
	s ret=1
	
	//20090525 ZF 升级版病案质控走配置
	s tmp=##Class(web.DHCWMRQuality.BOACRExpBaseConfig).GetEPRExamRule(TemplateID,EventType)
	s:$p(tmp,"^",3)=0 ret=0
	/*********************************************************
	//20090525 ZF 旧版病案质控走电子病历参数设置
	s:EventType="Print" ret=0
	*********************************************************/
	
	q ret
}

}
