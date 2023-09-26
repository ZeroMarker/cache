Import SQLUser

/// 评估标准树
Class web.DHCWMRQuality.ExEntryTree Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 11;

/// 评估标准
/// w ##Class(web.DHCWMRQuality.ExEntryTree).GetExamRule(RuleDicID, RuleID)
ClassMethod GetExamRule(RuleDicID, RuleID)
{
	n (RuleDicID, RuleID)
	s ret=""
	
	q:(RuleDicID="")&&(RuleID="") ret
	s Rowid=0,Flg=0
	f  s Rowid=$o(^DHCWMRER(Rowid)) q:(Rowid="")||(Flg=1)  d
	.q:(RuleID'="")&&(Rowid'=RuleID)
	.s tmpRule=##Class(web.DHCWMRQualityBaseCtl).GetERById(Rowid)
	.s tmpRuleDic=$p(tmpRule,"^",2)
	.s tmpActive=$p(tmpRule,"^",9)
	.q:tmpActive'["Y"
	.q:(RuleDicID'="")&&(RuleDicID'=tmpRuleDic)
	.s Flg=1
	.s $p(tmpRule,"^",2)=$tr(##Class(web.DHCWMRQualityBaseCtl).GetDicRById(+$p(tmpRule,"^",2)),"^","/")
	.s ret=tmpRule
	
	q ret
}

/// 处理ExamTree
/// w ##Class(web.DHCWMRQuality.ExExamTree).GetExamTree(ExamRule,ExamType)
/// ExamRule--评估标准   ExamType--标准类型(M:运行,F:终末,"":全部)
/// w ##Class(web.DHCWMRQuality.ExEntryTree).GetExamTree(ExamRule,ExamType)
ClassMethod GetExamTree(ExamRule, ExamType)
{
	n (ExamRule,ExamType)
	s ret=0,JIndex=$j
	
	k ^CacheTemp("Quality-ExamTree",JIndex)
	;^DHCWMRER({DHC_WMR_ExamRule.Rowid},"S",{DHC_WMR_ExamSection.ChildSub},"E",0,"ParPos",{ParentDr},{Pos},{ChildSub})
	q:ExamRule="" ret
	q:'$d(^DHCWMRER(+ExamRule)) ret
	q:$p($g(^DHCWMRER(+ExamRule)),"^",8)'="Y" ret     //评估标准无效退出
	s SecSub=0
	f  s SecSub=$o(^DHCWMRER(+ExamRule,"S",SecSub)) q:SecSub=""  d
	.s SecRowid=ExamRule_"||"_SecSub
	.s tmpSection=##Class(web.DHCWMRQualityBaseCtl).GetESById(SecRowid)
	.q:tmpSection=""
	.s SecActive=$p(tmpSection,"^",5)
	.q:SecActive'["Y"
	.s SecPos=+$p(tmpSection,"^",4)
	.s ParDR=""
	.f  s ParDR=$o(^DHCWMRER(+ExamRule,"S",SecSub,"E",0,"ParPos",ParDR)) q:ParDR=""  d
	..s EntryPos=0
	..f  s EntryPos=$o(^DHCWMRER(+ExamRule,"S",SecSub,"E",0,"ParPos",ParDR,EntryPos)) q:EntryPos=""  d
	...s EntrySub=0
	...f  s EntrySub=$o(^DHCWMRER(+ExamRule,"S",SecSub,"E",0,"ParPos",ParDR,EntryPos,EntrySub)) q:EntrySub=""  d
	....s EntryRowid=ExamRule_"||"_SecSub_"||"_EntrySub
	....s tmpEntry=##Class(web.DHCWMRQualityBaseCtl).GetEEById(EntryRowid)
	....q:tmpEntry=""
	....s EntryActive=$p(tmpEntry,"^",11)
	....q:EntryActive'["Y"
	....s EntryExp=$p(tmpEntry,"^",13)
	....q:(ExamType="M")&&(EntryExp="")    //M:运行   EntryExp'="" 运行质控项目
	....q:(ExamType="F")&&(EntryExp'="")   //F:终末   EntryExp="" 运行质控项目
	....s EntryPos=$p(tmpEntry,"^",4)
	....s ^CacheTemp("Quality-ExamTree",JIndex,+ExamRule,SecPos,SecSub,+ParDR,EntryPos,EntrySub)=""
	
	s ret=JIndex
	q ret
}

/// 取评估标准对应评估大类
/// w ##Class(web.DHCWMRQuality.ExEntryTree).GetRuleSection(RuleID,SecRowid,JIndex)
ClassMethod GetRuleSection(RuleID, SecRowid, JIndex)
{
	n (RuleID,SecRowid,JIndex)
	s ret=""
	q:RuleID="" ret
	
	;^CacheTemp("Quality-ExamTree",JIndex,+ExamRule,SecPos,SecSub,+ParDR,EntryPos,EntrySub)
	q:'$d(^CacheTemp("Quality-ExamTree",JIndex,+RuleID)) ret
	s SecPos=$s(SecRowid="":"",1:$p(##Class(web.DHCWMRQualityBaseCtl).GetESById(SecRowid),"^",4))
	s:SecPos'="" SecPos=$o(^CacheTemp("Quality-ExamTree",JIndex,+RuleID,SecPos),-1)
	s Flg=0
	f  s SecPos=$o(^CacheTemp("Quality-ExamTree",JIndex,+RuleID,SecPos)) q:(SecPos="")||(Flg=1)  d
	.s SecSub=$p(SecRowid,"||",2)
	.f  s SecSub=$o(^CacheTemp("Quality-ExamTree",JIndex,+RuleID,SecPos,SecSub)) q:(SecSub="")||(Flg=1)  d
	..s Rowid=RuleID_"||"_SecSub
	..s tmpSection=##Class(web.DHCWMRQualityBaseCtl).GetESById(Rowid)
	..s $p(tmpSection,"^",2)=$tr(##Class(web.DHCWMRQualityBaseCtl).GetDicSById(+$p(tmpSection,"^",2)),"^","/")
	..s ret=tmpSection
	..s Flg=1
	
	q ret
}

/// 取评估大类对应评估项目
/// w ##Class(web.DHCWMRQuality.ExEntryTree).GetSectionEntry(SectionID, EntryRowid, JIndex)
ClassMethod GetSectionEntry(SectionID, EntryRowid, JIndex)
{
	n (SectionID, EntryRowid,JIndex)
	s ret=""
	q:SectionID="" ret
	
	;^CacheTemp("Quality-ExamTree",JIndex,+ExamRule,SecPos,SecSub,+ParDR,EntryPos,EntrySub)
	s RuleID=+$p(SectionID,"||",1)
	s SecSub=+$p(SectionID,"||",2)
	s SecPos=+$p(##Class(web.DHCWMRQualityBaseCtl).GetESById(SectionID),"^",4)
	s ParDR=0
	q:'$d(^CacheTemp("Quality-ExamTree",JIndex,+RuleID,SecPos,SecSub,+ParDR)) ret
	s EntryPos=$s(EntryRowid="":"",1:$p(##Class(web.DHCWMRQualityBaseCtl).GetEEById(EntryRowid),"^",4))
	s:EntryPos'="" EntryPos=$o(^CacheTemp("Quality-ExamTree",JIndex,+RuleID,SecPos,SecSub,+ParDR,EntryPos),-1)
	s Flg=0
	f  s EntryPos=$o(^CacheTemp("Quality-ExamTree",JIndex,+RuleID,SecPos,SecSub,+ParDR,EntryPos)) q:(EntryPos="")||(Flg=1)  d
	.s EntrySub=$p(EntryRowid,"||",3)
	.f  s EntrySub=$o(^CacheTemp("Quality-ExamTree",JIndex,+RuleID,SecPos,SecSub,+ParDR,EntryPos,EntrySub)) q:(EntrySub="")||(Flg=1)  d
	..s Rowid=RuleID_"||"_SecSub_"||"_EntrySub
	..s tmpEntry=##Class(web.DHCWMRQualityBaseCtl).GetEEById(Rowid)
	..s $p(tmpEntry,"^",2)=$tr(##Class(web.DHCWMRQualityBaseCtl).GetDicEById(+$p(tmpEntry,"^",2)),"^","/")
	..s ret=tmpEntry
	..s Flg=1
	
	q ret
}

/// 取评估项目对应评估子项目
/// w ##Class(web.DHCWMRQuality.ExEntryTree).GetEntryEntry(EntryID, EntryRowid, JIndex)
ClassMethod GetEntryEntry(EntryID, EntryRowid, JIndex)
{
	n (EntryID, EntryRowid,JIndex)
	s ret=""
	q:EntryID="" ret
	
	;^CacheTemp("Quality-ExamTree",JIndex,+ExamRule,SecPos,SecSub,+ParDR,EntryPos,EntrySub)
	s RuleID=+$p(EntryID,"||",1)
	s SecSub=+$p(EntryID,"||",2)
	s SectionID=RuleID_"||"_SecSub
	s EntrySub=+$p(EntryID,"||",3)
	s SecPos=$p(##Class(web.DHCWMRQualityBaseCtl).GetESById(SectionID),"^",4)
	s ParDR=EntryID
	q:'$d(^CacheTemp("Quality-ExamTree",JIndex,+RuleID,SecPos,SecSub,+ParDR)) ret
	s EntryPos=$s(EntryRowid="":"",1:$p(##Class(web.DHCWMRQualityBaseCtl).GetEEById(EntryRowid),"^",4))
	s:EntryPos'="" EntryPos=$o(^CacheTemp("Quality-ExamTree",JIndex,+RuleID,SecPos,SecSub,+ParDR,EntryPos),-1)
	s Flg=0
	f  s EntryPos=$o(^CacheTemp("Quality-ExamTree",JIndex,+RuleID,SecPos,SecSub,+ParDR,EntryPos)) q:(EntryPos="")||(Flg=1)  d
	.s EntrySub=$p(EntryRowid,"||",3)
	.f  s EntrySub=$o(^CacheTemp("Quality-ExamTree",JIndex,+RuleID,SecPos,SecSub,+ParDR,EntryPos,EntrySub)) q:(EntrySub="")||(Flg=1)  d
	..s Rowid=RuleID_"||"_SecSub_"||"_EntrySub
	..s tmpEntry=##Class(web.DHCWMRQualityBaseCtl).GetEEById(Rowid)
	..s $p(tmpEntry,"^",2)=$tr(##Class(web.DHCWMRQualityBaseCtl).GetDicEById(+$p(tmpEntry,"^",2)),"^","/")
	..s ret=tmpEntry
	..s Flg=1
	
	q ret
}

}
