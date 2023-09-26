Import SQLUser

Class web.DHCWMRExamBase Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 20;

/// DHC_WMR_AutoCheckRule
ClassMethod GetAutoCheckRule()
{
	;^DHCWMRACR({RowId})
	s Rowid=0
	s ret=""
	f  s Rowid=$o(^DHCWMRACR(Rowid)) q:Rowid=""  d
	.s s=$g(^DHCWMRACR(Rowid))
	.s s=Rowid_"^"_s
	.s $p(s,"^",4)=$s($p(s,"^",4)["Y":"Yes",1:"No")
	.s ret=ret_s_$c(1)
	q ret
}

/// DHC_WMR_ExamEntryIndex->DHC_WMR_ExamEntry
ClassMethod GetExamEntryByTemplate(TemplateId)
{
	n (TemplateId)
	s ret=""
	;^DHCWMRERi(0,"TemplateEntry",{TemplateID},{ExamEntryDr},{RowId})
	q:'$d(^DHCWMRERi(0,"TemplateEntry",TemplateId)) ret
	s ExamEntryId=0
	f  s ExamEntryId=$o(^DHCWMRERi(0,"TemplateEntry",TemplateId,ExamEntryId)) q:ExamEntryId=""  d
	.s sExamEntry=##class(web.DHCWMRQualityBaseCtl).GetEEById(ExamEntryId)
	.q:$p(sExamEntry,"^",11)'="Yes"
	.s ExamRuleId=+ExamEntryId
	.s ExamSecId=ExamRuleId_"||"_$p(ExamEntryId,"||",2)
	.s sExamEsc=##class(web.DHCWMRQualityBaseCtl).GetESById(ExamSecId)
	.q:$p(sExamEsc,"^",5)'="Yes"
	.s sExamRule=##class(web.DHCWMRQualityBaseCtl).GetERById(ExamRuleId)
	.q:$p(sExamRule,"^",9)'="Yes"
	.s EntryDr=+$p(sExamEntry,"^",2)
	.s sEntryDic=##class(web.DHCWMRQualityBaseCtl).GetDicEById(EntryDr)
	.s ret=ret_sExamEntry_$c(2)_sEntryDic_$c(1)
	q ret
}

/// DHC_WMR_ExamEntry
ClassMethod GetTreeByTemplate(TemplateId)
{
	n (TemplateId)
	s ret=$j
	k ^CacheTemp("ExamRule",$j)
	;^DHCWMRERi(0,"TemplateEntry",{TemplateID},{ExamEntryDr},{RowId})
	q:'$d(^DHCWMRERi(0,"TemplateEntry",TemplateId)) ret
	s ExamEntryId=0
	f  s ExamEntryId=$o(^DHCWMRERi(0,"TemplateEntry",TemplateId,ExamEntryId)) q:ExamEntryId=""  d
	.s sExamEntry=##class(web.DHCWMRQualityBaseCtl).GetEEById(ExamEntryId)
	.q:$p(sExamEntry,"^",11)'="Yes"
	.s EntryDr=+$p(sExamEntry,"^",2)
	.s sEntryDic=##class(web.DHCWMRQualityBaseCtl).GetDicEById(EntryDr)
	.s Exp=$p(sExamEntry,"^",13)
	.s EntryDesc=$p(sEntryDic,"^",3)
	.s ExamRule=+ExamEntryId
	.s ExamSectionSub=$p(ExamEntryId,"||",2)
	.s ExamEntrySub=$p(ExamEntryId,"||",3)
	.i '$d(^CacheTemp("ExamRule",$j,ExamRule)) d
	..s sExamRule=##class(web.DHCWMRQualityBaseCtl).GetERById(ExamRule)
	..s RuleDic=$p(sExamRule,"^",2)
	..s sRuleDic=##class(web.DHCWMRQualityBaseCtl).GetDicRById(RuleDic)
	..s ^CacheTemp("ExamRule",$j,ExamRule)=$p(sRuleDic,"^",3)
	.i '$d(^CacheTemp("ExamRule",$j,ExamRule,ExamSectionSub)) d
	..s ExamSection=ExamRule_"||"_ExamSectionSub
	..s sExamSec=##class(web.DHCWMRQualityBaseCtl).GetESById(ExamSection)
	..s SecDic=$p(sExamSec,"^",2)
	..s sSecDic=##class(web.DHCWMRQualityBaseCtl).GetDicSById(SecDic)
	..s ^CacheTemp("ExamRule",$j,ExamRule,ExamSectionSub)=$p(sSecDic,"^",3)
	.s sRet=EntryDesc_"^"_Exp
	.s ^CacheTemp("ExamRule",$j,ExamRule,ExamSectionSub,ExamEntrySub)=sRet
	q ret
}

}
