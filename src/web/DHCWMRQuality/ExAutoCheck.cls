Import SQLUser

Class web.DHCWMRQuality.ExAutoCheck Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 11;

/// ****************************************************************
/// 功能说明   : 自动任务检查病历质量
/// 入参       : 
/// 出参       : ret=1 任务完成     ret=-1 任务失败
/// 程序调试   : w ##Class(web.DHCWMRQuality.ExAutoCheck).AutoCheckMR()
/// ****************************************************************
ClassMethod AutoCheckMR() As %String
{
	n
	s ret=-1
	
	//自动任务标准(在院病人)
	s tmpTime=$p($h,",",2),ExamDate=+$h
	s ExamRuleRowid1=5
	s flg=..AutoCheckAdmitMR(ExamRuleRowid1,"",ExamDate)
	//保存自动任务执行结果
	s CurrDate=$zd(+$h,3),CurrTime=$zt($p($h,",",2),2)
	s Result="flg="_flg_"!time="_$zt(($p($h,",",2)-tmpTime),1)
	s ^DHCWMRACMR(CurrDate,CurrTime,ExamRuleRowid1)=Result
	
	//自动任务标准(出院病人)
	s tmpTime=$p($h,",",2),ExamDate=+$h
	s ExamRuleRowid2=6
	s flg=..AutoCheckDischMR(ExamRuleRowid2,"",ExamDate-3)  //出院病人推迟三天检查
	//保存自动任务执行结果
	s CurrDate=$zd(+$h,3),CurrTime=$zt($p($h,",",2),2)
	s Result="flg="_flg_"!time="_$zt(($p($h,",",2)-tmpTime),1)
	s ^DHCWMRACMR(CurrDate,CurrTime,ExamRuleRowid2)=Result
	
	s ret=1
	q ret
}

/// ****************************************************************
/// 功能说明   : 检查在院病人电子病历
/// 入参       : 
/// ExamRule   : 评估标准
/// Ward       : 病区
/// ExamDate   : 检查日期
/// 出参       : ret      'ret<=0':失败  'ret>0':成功
/// 备注       : 只查询就诊状态为'Admit'的就诊记录
/// 程序调试   : w ##Class(web.DHCWMRQuality.ExAutoCheck).AutoCheckAdmitMR(ExamRule, Ward, ExamDate)
/// ****************************************************************
ClassMethod AutoCheckAdmitMR(ExamRule, Ward, ExamDate)
{
	n (ExamRule,Ward,ExamDate)
	s ret=0
	
	k ^CacheTemp("MRQuality-Rst")     //清除病历质控ACR处理结果
	k ^CacheTemp("MRQuality-Err")     //清除病历质控处理错误结果
	k ^CacheTemp("MRQuality-A")       //清除在院病历质控处理结果
	k ^CacheTemp("MRQuality-D")       //清除出院病历质控处理结果
	
	q:ExamRule="" ret
	q:'$d(^DHCWMRER(+ExamRule)) ret
	q:$p($g(^DHCWMRER(+ExamRule)),"^",8)'="Y" ret     //评估标准无效退出
	
	q:ExamDate="" ret
	s ExamTime=0
	
	;^PAWARD({WARD_RowID})
	;^PAADMi("CurrWard",{PAADM_CurrentWard_DR},{PAADM_CurrentRoom_DR},{PAADM_RowID})
	//查找住院病人就诊记录
	s WardRowid=""
	f  s WardRowid=$o(^PAWARD(WardRowid)) q:WardRowid=""  d
	.q:(Ward'="")&&(Ward'=WardRowid)
	.s tmpWard=$g(^PAWARD(+WardRowid))
	.q:tmpWard=""
	.//w $p(tmpWard,"^",2),!
	.s WardActive=$p(tmpWard,"^",6)
	.q:WardActive'="Y"
	.q:'$d(^PAADMi("CurrWard",WardRowid))
	.s Room=0
	.f  s Room=$o(^PAADMi("CurrWard",WardRowid,Room)) q:Room=""  d
	..s Paadm=0
	..f  s Paadm=$o(^PAADMi("CurrWard",WardRowid,Room,Paadm)) q:Paadm=""  d
	...//w Paadm,!
	...s tmpPaadm=$g(^PAADM(+Paadm))
	...q:tmpPaadm=""
	...s VisitSta=$p(tmpPaadm,"^",20)
	...q:VisitSta'="A"    //判断就诊状态
	...s AdmType=$p(tmpPaadm,"^",2)
	...q:AdmType'="I"     //判断就诊类型
	...;评估项目检查
	...w Paadm_"  ",!
	...s RID="",SectionSub=0
	...f  s SectionSub=$o(^DHCWMRER(ExamRule,"S",SectionSub)) q:SectionSub=""  d
	....s EntrySub=0
	....f  s EntrySub=$o(^DHCWMRER(ExamRule,"S",SectionSub,"E",EntrySub)) q:EntrySub=""  d
	.....s ExamEntry=ExamRule_"||"_+SectionSub_"||"_+EntrySub
	.....s flag=..CheckExamEntry(ExamEntry,Paadm,ExamDate)
	.....q:flag'=1
	.....;评估结果保存
	.....s InPut=Paadm_"^"_ExamRule_"^"_ExamEntry_"^"_ExamDate
	.....;b //InPut=Paadm_"^"_ExamRule_"^"_ExamEntry_"^"_ExamDate
	.....s RetID=##Class(web.DHCWMRQuality.ExSaveResult).SaveAutoResult(RID,InPut)
	.....s:(+RetID)<0 ^CacheTemp("MRQuality-A","ERR",$zd(ExamDate,3),Paadm,ExamRule,ExamEntry)=""
	.....s:(+RetID)>0 ^CacheTemp("MRQuality-A","SUC",$zd(ExamDate,3),Paadm,ExamRule,ExamEntry)=""
	.....S:(+RetID)>0 RID=RetID
	
	s ret=1
	q ret
}

///  ****************************************************************
///  功能说明   : 检查出院病人电子病历
///  入参       : 
///  ExamRule   : 评估标准
///  Ward       : 病区
///  ExamDate   : 检查日期
///  Days       : 检查几天前出院病人的电子病历,默认为5
///  出参       : ret      'ret<=0':失败  'ret>0':成功
///  备注       : 只查询就诊状态为'Discharge'的就诊记录
///  程序调试   : w ##Class(web.DHCWMRQuality.ExAutoCheck).AutoCheckDischMR(ExamRule, Ward, ExamDate,Days)
///  ****************************************************************
ClassMethod AutoCheckDischMR(ExamRule, Ward, ExamDate)
{
	n (ExamRule, Ward, ExamDate)
	s ret=0
	
	k ^CacheTemp("MRQuality-Rst")     //清除病历质控ACR处理结果
	k ^CacheTemp("MRQuality-Err")     //清除病历质控处理错误结果
	k ^CacheTemp("MRQuality-A")       //清除在院病历质控处理结果
	k ^CacheTemp("MRQuality-D")       //清除出院病历质控处理结果
	
	q:ExamRule="" ret
	q:'$d(^DHCWMRER(+ExamRule)) ret
	q:$p($g(^DHCWMRER(+ExamRule)),"^",8)'="Y" ret     //评估标准无效退出
	
	q:ExamDate="" ret
	s ExamTime=0
	s DischDate=ExamDate
	
	;^PAADMi("DischDate",{PAADM_DischgDate},{PAADM_RowID})
	s Paadm=0
	f  s Paadm=$o(^PAADMi("DischDate",DischDate,Paadm)) q:Paadm=""  d
	.s tmpPaadm=$g(^PAADM(+Paadm))
	.q:tmpPaadm=""
	.//w Paadm,!
	.s VisitSta=$p(tmpPaadm,"^",20)
	.q:VisitSta'="D"    //判断就诊状态
	.s AdmType=$p(tmpPaadm,"^",2)
	.q:AdmType'="I"     //判断就诊类型
	.s AdmWard=$p(tmpPaadm,"^",70)
	.q:(Ward'="")&&(AdmWard'=Ward)   //判断就诊病区
	.;评估项目检查
	.w Paadm,!
	.s RID="",SectionSub=0
	.f  s SectionSub=$o(^DHCWMRER(ExamRule,"S",SectionSub)) q:SectionSub=""  d
	..s EntrySub=0
	..f  s EntrySub=$o(^DHCWMRER(ExamRule,"S",SectionSub,"E",EntrySub)) q:EntrySub=""  d
	...s ExamEntry=ExamRule_"||"_+SectionSub_"||"_+EntrySub
	...s flag=..CheckExamEntry(ExamEntry,Paadm,ExamDate)
	...q:flag'=1
	...;评估结果保存
	...s InPut=Paadm_"^"_ExamRule_"^"_ExamEntry_"^"_ExamDate
	...;b //InPut=Paadm_"^"_ExamRule_"^"_ExamEntry_"^"_ExamDate
	...s RetID=##Class(web.DHCWMRQuality.ExSaveResult).SaveAutoResult(RID,InPut)
	...s:(+RetID)<0 ^CacheTemp("MRQuality-D","ERR",$zd(ExamDate,3),Paadm,ExamRule,ExamEntry)=""
	...s:(+RetID)>0 ^CacheTemp("MRQuality-D","SUC",$zd(ExamDate,3),Paadm,ExamRule,ExamEntry)=""
	...S:(+RetID)>0 RID=RetID
	
	s ret=1
	q ret
}

ClassMethod CheckExamEntry(ExamEntry As %String, EpisodeID As %String, ExamDate As %String) As %String
{
	n (ExamEntry,EpisodeID,ExamDate)
	Set ret=""
	
	Set ExamRuleDr=+ExamEntry
	Set ExamSecSub=+$p(ExamEntry,"||",2)
	Set ExamEntrySub=+$p(ExamEntry,"||",3)
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
	Set sExamEntry=##class(web.DHCWMRQualityBaseCtl).GetEEById(ExamEntry)
	Set EntryDr=+$p(sExamEntry,"^",2)
	Set EntryExpression=$p(sExamEntry,"^",13)
	Quit:EntryExpression="" ret
	Set Active=$p(sExamEntry,"^",11)
	Quit:Active'["Y" ret
	
	;根据是否允许多次评分和质控结果判断是否还需要检查此项内容
	s MultiErr=$p(sExamEntry,"^",6)
	s MultiFlg=1
	i ((MultiErr'["Y")&&$d(^DHCWMRERST(0,"RuleAdm",ExamRuleDr,EpisodeID))) d
	.s RstId=0
	.f  s RstId=$o(^DHCWMRERST(0,"RuleAdm",ExamRuleDr,EpisodeID,RstId)) q:RstId=""  d
	..s:$d(^DHCWMRERST(RstId,"0","RstDtlEntryDr",ExamEntry,"Y")) MultiFlg=0
	q:MultiFlg=0 ret
	
	;EntryDic
	Set sEntryDic=##class(web.DHCWMRQualityBaseCtl).GetDicEById(EntryDr)
	Set EntryTitle=$p(sEntryDic,"^",3)
	Set Active=$p(sEntryDic,"^",5)
	Quit:Active'["Y" ret
	
	Set RCodeList=##class(web.DHCWMRExamACRCtl).ExpEntryExpression(EntryExpression)
	Quit:RCodeList="" ret
	For index=1:1:$l(RCodeList,$c(1))
	{
		Set tmpRCode=$p(RCodeList,$c(1),index)
		Quit:tmpRCode=""
        Set ACRExp=##class(web.DHCWMRExamACRCtl).GetACRExpByRCode(tmpRCode)
        ;Explain ACRExpression return value
        
        Set tmpVal=##class(web.DHCWMRQuality.BOACRExpExplain).ExplainACRExp(ACRExp,EpisodeID,"","")
        If +tmpVal<0   ;Explain ACRExp error
        {
	        Set ErrList=""
	        Set Err=tmpVal_" "_tmpRCode_"  "_ACRExp
	        Set:$d(^CacheTemp("MRQuality-Err",$zd(ExamDate,3),"ERROR")) ErrList=$g(^CacheTemp("MRQuality-Err",$zd(ExamDate,3),"ERROR"))
	        Set:ErrList'="" ErrList=ErrList_$c(13)_Err
	        Set:ErrList="" ErrList=tmpVal
	        Set ^CacheTemp("MRQuality-Err",$zd(ExamDate,3),"ERROR")=Err
	        Set tmpVal=0
	    }
        Set tmpPara=tmpRCode_"="_tmpVal
        Set @tmpPara
	}
	Set NewExpression="ret="_EntryExpression
	Set @NewExpression
	Quit ret
}

}
