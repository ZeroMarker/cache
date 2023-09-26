Import SQLUser

/// 评估标准存取方法
Class web.DHCWMRExamRuleCtl Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 154;

/// 存 4 评估标准 DHC_WMR_ExamRule
ClassMethod UpdateRule(Instring)
{
    n (Instring)
    s ret=""
    s RuleDicDr=+$p(Instring,"^",2)
    q:'$d(^DHCWMRRDIC(RuleDicDr)) -1
    
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
    zn MEDDATA
    s ret=$$UpdateExamRule^DHCWMRExamRule(Instring)
	zn CurrentNS
	q ret
}

/// 存 4.1 评估大类 DHC_WMR_ExamSection
ClassMethod UpdateSection(Instring)
{
    n (Instring)
    s ret=""
    s SectionDicDr=+$p(Instring,"^",3)
    q:'$d(^DHCWMRSDIC(SectionDicDr)) -1
    
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
    zn MEDDATA
    s ret=$$UpdateExamSection^DHCWMRExamRule(Instring)
	zn CurrentNS
	q ret
}

/// 存 4.1.1 评估项目 DHC_WMR_ExamEntry
ClassMethod UpdateEntry(Instring)
{
    n (Instring)
    s ret=""
    s EntryDicDr=+$p(Instring,"^",3)
    q:'$d(^DHCWMREDIC(EntryDicDr)) -1
    
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
    zn MEDDATA
    s ret=$$UpdateExamEntry^DHCWMRExamRule(Instring)
	zn CurrentNS
	q ret
}

/// ********** by wuqk 2007-12-10 begin*******
/// 事务
/// 存 4.1.1 评估项目 DHC_WMR_ExamEntry
/// 存 4.1.2 评估项目模板索引 DHC_WMR_ExamEntryIndex
ClassMethod UpdateEntryExp(Instring, InstrTemplate)
{
    n (Instring,InstrTemplate)
    s ret=""
	/*
    s EntryDicDr=+$p(Instring,"^",3)
    q:'$d(^DHCWMREDIC(EntryDicDr)) -1
    
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
    zn MEDDATA
    Tstart
    s ret=$$UpdateExamEntry^DHCWMRExamRule(Instring)
    i ret'["||" d
    .TRollBack
    .zn CurrentNS
    q:ret'["||" ret
    s ExamEntryRowid=ret
    s flag=0
    f i=1:1:$l(InstrTemplate,"^") q:flag<0  d
    .s TemplateID=$p(InstrTemplate,"^",i)
    .q:TemplateID=""
    .s sTemp="^"_ExamEntryRowid_"^"_TemplateID_"^"_"Y"
    .s flag=$$UpdateExamEntryIndex^DHCWMRExamRule(sTemp)
    i flag<0 d 
    .TRollBack
    .zn CurrentNS
	q:flag<0 flag
	TCommit
    
	zn CurrentNS
	*/
	q ret
}

/// 4.1.2 评估项目模板索引 DHC_WMR_ExamEntryIndex
ClassMethod UpdateExamEntryIndex(Instring)
{
    n (Instring)
    s ret=""
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
    zn MEDDATA
    s ret=$$UpdateExamEntryIndex^DHCWMRExamRule(Instring)
	zn CurrentNS
	q ret
}

/// ********** by wuqk 2007-12-10 End*******
/// 存 4.2 评估等级 DHC_WMR_ExamGarde
ClassMethod UpdateGarde(Instring)
{
    n (Instring)
    s ret=""
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
    zn MEDDATA
    s ret=$$UpdateExamGarde^DHCWMRExamRule(Instring)
	zn CurrentNS
	q ret
}

/// 取 4 评估标准 DHC_WMR_ExamRule
ClassMethod ByIdGetRule(RuleRowid)
{
	n (RuleRowid)
	
	s retString=##class(web.DHCWMRQualityBaseCtl).GetERById(RuleRowid)
	
	i retString'="" d
	.;DHC_WMR_RuleDic
	.s RuleDicDr=+$p(retString,"^",2)
	.s RuleDic=##class(web.DHCWMRQualityBaseCtl).GetDicRById(RuleDicDr)
	.i RuleDic'="" d
	..;DHC_WMR_Dictionary
	..s DicDr=$p(RuleDic,"^",4)
	..s Dic=##class(web.DHCWMRQualityBaseCtl).GetDicById(DicDr)
	.;w RuleDic,!,$g(Dic),"//",!!
	.s RuleDic=RuleDic_$c(2)_$g(Dic)
    .s retString=retString_$c(2)_RuleDic
	q retString
	/*
	s retString=""
    q:'$d(^DHCWMRER(+RuleRowid)) retString
	
	s retString=$g(^DHCWMRER(+RuleRowid))
	s retString=+RuleRowid_"^"_retString
	s ScoreMethod=$p(retString,"^",8)
	s:ScoreMethod["A" ScoreMethod="Add"
	s:ScoreMethod["R" ScoreMethod="Reduce"
	s $p(retString,"^",8)=ScoreMethod
	s $p(retString,"^",9)=$s($p(retString,"^",9)["Y":"Yes",1:"No")
	
	;DHC_WMR_RuleDic
	s RuleDr=$p(retString,"^",2)
	i RuleDr'="" d
	.s RuleDr=+RuleDr
	.s:RuleDr'=0 RuleDic=RuleDr_"^"_$g(^DHCWMRRDIC(RuleDr))
	.;Dictionary
    .s DicRowid=+$p($g(RuleDic),"^",4)
    .s:DicRowid'=0 Dic=DicRowid_"^"_$g(^DHCWMRDIC(DicRowid))
	s RuleDic=$g(RuleDic)_$c(2)_$g(Dic)
	
	s retString=retString_$c(2)_$g(RuleDic)
	q retString
	*/
}

/// 取 4.1 评估大类 DHC_WMR_ExamSection
ClassMethod ByIdGetSection(SectionRowid)
{
	n (SectionRowid)
	
	s retString=##class(web.DHCWMRQualityBaseCtl).GetESById(SectionRowid)
	
	i retString'="" d
	.;DHC_WMR_SectionDic
	.s SectionDic=""
	.s SectionDicDr=$p(retString,"^",2)
	.s:SectionDicDr'="" SectionDic=##class(web.DHCWMRQualityBaseCtl).GetDicSById(SectionDicDr)
	.i SectionDic'="" d
	..;DHC_WMR_Dictionary
	..s DicDr=$p(SectionDic,"^",4)
	..s:DicDr'="" Dic=##class(web.DHCWMRQualityBaseCtl).GetDicById(DicDr)
	.;w SectionDic,!,$g(Dic),!
	.s SectionDic=SectionDic_$c(2)_$g(Dic)
    .s retString=retString_$c(2)_SectionDic
	q retString
	/*
	s retString=""
	s RuleRowid=+SectionRowid
	s SectionSub=$p(SectionRowid,"||",2)
    q:'$d(^DHCWMRER(+RuleRowid,"S",SectionSub)) retString
	
	s retString=$g(^DHCWMRER(+RuleRowid,"S",SectionSub))
	s retString=SectionRowid_"^"_retString
	s:$p(retString,"^",5)'="" $p(retString,"^",5)=$s($p(retString,"^",5)["Y":"Yes",1:"No")
	
	;DHC_WMR_SectionDic
	s SectionDr=$p(retString,"^",2)
	i SectionDr'="" d
	.s SectionDr=+SectionDr
	.s:SectionDr'=0 SectionDic=SectionDr_"^"_$g(^DHCWMRSDIC(SectionDr))
	.;Dictionary
    .s DicRowid=+$p($g(SectionDic),"^",4)
    .s:DicRowid'=0 Dic=DicRowid_"^"_$g(^DHCWMRDIC(DicRowid))
	s SectionDic=$g(SectionDic)_$c(2)_$g(Dic)
	
	s retString=retString_$c(2)_$g(SectionDic)
	q retString
	*/
}

/// 取 4.1.1 评估项目 DHC_WMR_ExamEntry
ClassMethod ByIdGetEntry(EntryRowid)
{
	n (EntryRowid)
	
	s retString=##class(web.DHCWMRQualityBaseCtl).GetEEById(EntryRowid)
	
	i retString'="" d
	.;质控项目
	.;DHC_WMR_EntryDic
	.s EntryDic=""
	.s EntryDicDr=$p(retString,"^",2)
	.s:EntryDicDr'="" EntryDic=##class(web.DHCWMRQualityBaseCtl).GetDicEById(EntryDicDr)
	.i EntryDic'="" d
	..;DHC_WMR_Dictionary
	..s tmpDic0Dr=$p(EntryDic,"^",4)
	..s:tmpDic0Dr'="" tmpDic0=##class(web.DHCWMRQualityBaseCtl).GetDicById(tmpDic0Dr)
	.;w EntryDic,!,$g(tmpDic0),!
	.s EntryDic=EntryDic_$c(2)_$g(tmpDic0)
	.
	.;DHC_WMR_ExamEntry
	.s ExamEntry=""
	.s ExamEntryDr=$p(retString,"^",8)
	.s:ExamEntryDr'="" ExamEntry=##class(web.DHCWMRQualityBaseCtl).GetEEById(ExamEntryDr)
	.i ExamEntry'="" d
	..;DHC_WMR_EntryDic
	..s tmpEntryDicDr=$p(ExamEntry,"^",2)
	..s:tmpEntryDicDr'="" tmpEntryDic=##class(web.DHCWMRQualityBaseCtl).GetDicEById(tmpEntryDicDr)
	..;DHC_WMR_ExamEntry
	..s tmpExamEntryDr=$p(ExamEntry,"^",8)
	..s:tmpExamEntryDr'="" tmpExamEntry=##class(web.DHCWMRQualityBaseCtl).GetEEById(tmpExamEntryDr)
	..;DHC_WMR_Dictionary
	..s tmpDic1Dr=$p(ExamEntry,"^",10)
	..s:tmpDic1Dr'="" tmpDic1=##class(web.DHCWMRQualityBaseCtl).GetDicById(tmpDic1Dr)
	.;w ExamEntry,!,$g(tmpEntryDic),!,$g(tmpExamEntry),!,$g(tmpDic1),!
	.s ExamEntry=ExamEntry_$c(2)_$g(tmpEntryDic)_$c(2)_$g(tmpExamEntry)_$c(2)_$g(tmpDic1)
	.
	.;责任人类型
	.;DHC_WMR_Dictionary
	.s Dic=""
	.s DicDr=$p(retString,"^",10)
	.s:DicDr'="" Dic=##class(web.DHCWMRQualityBaseCtl).GetDicById(DicDr)
	.;w Dic,!
	.s retString=retString_$c(2)_EntryDic_$c(2)_ExamEntry_$c(2)_Dic
	q retString
	/*
	s retString=""
	s RuleRowid=+EntryRowid
	s SectionSub=$p(EntryRowid,"||",2)
	s EntrySub=$p(EntryRowid,"||",3)
    q:'$d(^DHCWMRER(+RuleRowid,"S",SectionSub,"E",EntrySub)) retString
	
	s retString=$g(^DHCWMRER(+RuleRowid,"S",SectionSub,"E",EntrySub))
	s retString=EntryRowid_"^"_retString
	s:$p(retString,"^",6)'="" $p(retString,"^",6)=$s($p(retString,"^",6)["Y":"Yes",1:"No")
	s:$p(retString,"^",7)'="" $p(retString,"^",7)=$s($p(retString,"^",7)["Y":"Yes",1:"No")
	s:$p(retString,"^",11)'="" $p(retString,"^",11)=$s($p(retString,"^",11)["Y":"Yes",1:"No")
	
	;DHC_WMR_EntryDic
	s EntryDr=$p(retString,"^",2)
	i EntryDr'="" d
	.s EntryDr=+EntryDr
	.s:EntryDr'=0 EntryDic=EntryDr_"^"_$g(^DHCWMREDIC(EntryDr))
	.;Dictionary
    .s DicRowid=+$p($g(EntryDic),"^",4)
    .s:DicRowid'=0 Dic=DicRowid_"^"_$g(^DHCWMRDIC(DicRowid))
	s EntryDic=$g(EntryDic)_$c(2)_$g(Dic)
	
	;^DHCWMRER({DHC_WMR_ExamRule.Rowid},"S",{DHC_WMR_ExamSection.ChildSub},"E",{ChildSub})
	s ExamEntryDr=$p(retString,"^",8)
	i ExamEntryDr'="" d
	.s ExamRRowid=+ExamEntryDr
	.s ExamSSub=$p(ExamEntryDr,"||",2)
	.s ExamESub=$p(ExamEntryDr,"||",3)
	.q:((ExamSSub="")||(ExamESub=""))
	.s ExamEntry=ExamEntryDr_"^"_$g(^DHCWMRER(ExamRRowid,"S",ExamSSub,"E",ExamESub))
	
	;Dictionary
    s DicDr=+$p(retString,"^",10)
    s:DicDr'=0 Dic=DicDr_"^"_$g(^DHCWMRDIC(DicDr))
	s retString=retString_$c(2)_$g(EntryDic)_$c(2)_$g(ExamEntry)_$c(2)_$g(Dic)
	q retString
	*/
}

/// 取 4.2 评估等级 DHC_WMR_ExamGarde
ClassMethod ByIdGetGarde(GardeRowid)
{
	n (GardeRowid)
	
	s retString=##class(web.DHCWMRQualityBaseCtl).GetEGById(GardeRowid)
	q retString
	/*
	s retString=""
	s RuleRowid=+GardeRowid
	s GardeSub=$p(GardeRowid,"||",2)
    q:'$d(^DHCWMRER(+RuleRowid,"G",GardeSub)) retString
	
	s retString=$g(^DHCWMRER(+RuleRowid,"G",GardeSub))
	s retString=GardeRowid_"^"_retString
	s:$p(retString,"^",4)'="" $p(retString,"^",4)=$s($p(retString,"^",4)["Y":"Yes",1:"No")
	q retString
	*/
}

/**********************************************
/评估标准展现
***********************************************/
ClassMethod GetRuleByDic(RuleDic, Active)
{
	n (RuleDic,Active)
	s ret=""
	;^DHCWMRER(0,"RuleActive",{RuleDr},{IsActive},{Rowid})
	q:'$d(^DHCWMRER(0,"RuleActive",+RuleDic)) ret
	
	i Active'=""  d
	.q:'$d(^DHCWMRER(0,"RuleActive",+RuleDic,Active))
	.s RuleRowid=""
	.f  s RuleRowid=$o(^DHCWMRER(0,"RuleActive",+RuleDic,Active,RuleRowid)) q:RuleRowid=""  d
	..s ret=ret_$c(1)_..ByIdGetRule(+RuleRowid)
	e  d
	.s tempActive=""
	.f  s tempActive=$o(^DHCWMRER(0,"RuleActive",+RuleDic,tempActive)) q:tempActive=""  d
	..s RuleRowid=""
	..f  s RuleRowid=$o(^DHCWMRER(0,"RuleActive",+RuleDic,tempActive,RuleRowid)) q:RuleRowid=""  d
	...s ret=ret_$c(1)_..ByIdGetRule(+RuleRowid)
	s:$l(ret)>0 ret=$e(ret,2,$l(ret))
	q ret
}

ClassMethod GetSectionByRule(RuleRowid, Active)
{
	n (RuleRowid,Active)
	s ret=""
	;^DHCWMRER({DHC_WMR_ExamRule.Rowid},"S",0,"Pos",{Pos},{ChildSub})
	q:'$d(^DHCWMRER(RuleRowid,"S")) ret
	
	s Pos=""
	f  s Pos=$o(^DHCWMRER(RuleRowid,"S",0,"Pos",Pos)) q:Pos=""  d
	.s SectionSub=0
	.f  s SectionSub=$o(^DHCWMRER(RuleRowid,"S",0,"Pos",Pos,SectionSub)) q:SectionSub=""  d
	..s SectionRowid=RuleRowid_"||"_SectionSub
	..s s=..ByIdGetSection(SectionRowid)
	..q:(Active'="")&($p(s,"^",5)'[Active)
	..s ret=ret_$c(1)_s
	s:$l(ret)>0 ret=$e(ret,2,$l(ret))
	q ret
}

/// 按Section取Entry
ClassMethod GetEntryBySection(SectionRowid, Active)
{
	n (SectionRowid, Active)
	;^DHCWMRER({DHC_WMR_ExamRule.Rowid},"S",
	;{DHC_WMR_ExamSection.ChildSub},"E",0,"ParPos",
	;{ParentDr},{Pos},{ChildSub}) 
	s RuleRowid=+SectionRowid
	s SectionSub=$p(SectionRowid,"||",2)
	s ret=""
	q:'$d(^DHCWMRER(RuleRowid,"S",SectionSub,"E",0,"ParPos")) ret
	
	s Parent=""
	f  s Parent=$o(^DHCWMRER(RuleRowid,"S",SectionSub,"E",0,"ParPos",Parent)) q:Parent=""  d
	.s pos=""
	.f  s pos=$o(^DHCWMRER(RuleRowid,"S",SectionSub,"E",0,"ParPos",Parent,pos)) q:pos=""  d
	..s EntrySub=""
	..f  s EntrySub=$o(^DHCWMRER(RuleRowid,"S",SectionSub,"E",0,"ParPos",Parent,pos,EntrySub)) q:EntrySub=""  d
	...s EntryRowid=RuleRowid_"||"_SectionSub_"||"_EntrySub
	...s s=..ByIdGetEntry(EntryRowid)
	...q:(Active'="")&($p(s,"^",11)'[Active)
	...s ret=ret_$c(1)_s
	s:$l(ret)>0 ret=$e(ret,2,$l(ret))
	q ..ReplaceString(ret,$c(13)_$c(10),"\n") //Modified By LiYang 2008-12-17 替换掉字符串中的回车
}

/// 字符替换
ClassMethod ReplaceString(Str, OldStr, NewStr)
{
	n (Str, OldStr, NewStr)
	set intCounter = 1
	while (1)
	{
		set tmp =$e(Str, intCounter, intCounter + $l(OldStr) - 1) 
		if (tmp = OldStr)
		{
			 set $e(Str, intCounter, intCounter + $l(OldStr) - 1) = NewStr
			 set intCounter = intCounter + $l(NewStr) - $l(OldStr)
		}
		quit:intCounter>=$l(Str)
		set intCounter = intCounter + 1
	}
	quit Str
}

/// 取第一级Entry,即Parent=0
ClassMethod GetMEntryBySection(SectionRowid, Active)
{
	n (SectionRowid, Active)
	;^DHCWMRER({DHC_WMR_ExamRule.Rowid},"S",
	;{DHC_WMR_ExamSection.ChildSub},"E",0,"ParPos",
	;{ParentDr},{Pos},{ChildSub}) 
	s RuleRowid=+SectionRowid
	s SectionSub=$p(SectionRowid,"||",2)
	s ret=""
	q:'$d(^DHCWMRER(RuleRowid,"S",SectionSub,"E",0,"ParPos",0)) ret
	
	s pos=""
	f  s pos=$o(^DHCWMRER(RuleRowid,"S",SectionSub,"E",0,"ParPos",0,pos)) q:pos=""  d
	.s EntrySub=""
	.f  s EntrySub=$o(^DHCWMRER(RuleRowid,"S",SectionSub,"E",0,"ParPos",0,pos,EntrySub)) q:EntrySub=""  d
	..s EntryRowid=RuleRowid_"||"_SectionSub_"||"_EntrySub
	..s s=..ByIdGetEntry(EntryRowid)
	..q:(Active'="")&($p(s,"^",11)'[Active)
	..s ret=ret_$c(1)_s
	s:$l(ret)>0 ret=$e(ret,2,$l(ret))
	q ret
}

/// 按照Parent取Entry
ClassMethod GetEntryByParent(ParentRowid, Active)
{
	;n (ParentRowid, Active)
	;^DHCWMRER(0,"EntryParPos",{ParentDr},
	;{Pos},{DHC_WMR_ExamRule.Rowid},
	;{DHC_WMR_ExamSection.ChildSub},{ChildSub})
	s ret=""
	q:'$d(^DHCWMRER(0,"EntryParPos",ParentRowid)) ret
    
	s pos=""
	f  s pos=$o(^DHCWMRER(0,"EntryParPos",ParentRowid,pos)) q:pos=""  d
	.s Rule=""
    .f  s Rule=$o(^DHCWMRER(0,"EntryParPos",ParentRowid,pos,Rule)) q:Rule=""  d
    ..s Section=""
    ..f  s Section=$o(^DHCWMRER(0,"EntryParPos",ParentRowid,pos,Rule,Section)) q:Section=""  d
    ...s Entry=""
    ...f  s Entry=$o(^DHCWMRER(0,"EntryParPos",ParentRowid,pos,Rule,Section,Entry)) q:Entry=""  d
    ....s tmpEntry=+Rule_"||"_Section_"||"_Entry
    ....s s=..ByIdGetEntry(tmpEntry)
	....q:(Active'="")&($p(s,"^",11)'[Active)
	....s ret=ret_$c(1)_s
	s:$l(ret)>0 ret=$e(ret,2,$l(ret))
	q ret
}

/// 检查评估大类的显示位置（同一评估大类显示位置不能重复）
ClassMethod CheckSectionPos(InString)
{
	n (InString)
	
	s ret=-2
	s RuleRowid=$p(InString,"^",1)
	s SectionSub=$p(InString,"^",2)
	s Pos=$p(InString,"^",3)
	;^DHCWMRER({DHC_WMR_ExamRule.Rowid},"S",0,"Pos",{Pos},{ChildSub})
	q:((RuleRowid="")||(Pos="")) ret
	i SectionSub="" d
	.s:'$d(^DHCWMRER(RuleRowid,"S",0,"Pos",Pos)) ret=1
	e  d
	.s Chl=0
	.f  s Chl=$o(^DHCWMRER(RuleRowid,"S",0,"Pos",Pos,Chl)) q:Chl=""  d
	..s:Chl'=SectionSub ret=-1
	.s:ret'=-1 ret=1
	q ret
}

/// 检查评估项目的显示位置（同一评估项目显示位置不能重复）
/// 已存在（显示位置不可用）返回-1，不存在（此显示位置可用）返回1
ClassMethod CheckEntryPos(InString)
{
	n (InString)
	
	s ret=-2
	s RuleRowid=$p(InString,"^",1)
	s SectionSub=$p(InString,"^",2)
	s EntryChl=$p(InString,"^",3)
	s ParentDr=$p(InString,"^",4)
	s Pos=$p(InString,"^",5)
	;^DHCWMRER({DHC_WMR_ExamRule.Rowid},"S",{DHC_WMR_ExamSection.ChildSub},"E",0,"ParPos",{ParentDr},{Pos},{ChildSub})
	q:((RuleRowid="")||(SectionSub="")) ret
	q:((ParentDr="")||(Pos="")) ret
	i EntryChl="" d
	.s:'$d(^DHCWMRER(RuleRowid,"S",SectionSub,"E",0,"ParPos",ParentDr,Pos)) ret=1
	e  d
	.s Chl=0
	.f  s Chl=$o(^DHCWMRER(RuleRowid,"S",SectionSub,"E",0,"ParPos",ParentDr,Pos,Chl)) q:Chl=""  d
	..s:Chl'=EntryChl ret=-1
	.s:ret'=-1 ret=1
	q ret
}

/// 通过评估标准查询评估等级
ClassMethod GetGardeByRuleId(RuleRowid, IsActive)
{
	n (RuleRowid, IsActive)
	s ret=""
	q:RuleRowid="" ret
	s IsActive=$s(IsActive["Y":"Yes",1:"No")
	;^DHCWMRER({DHC_WMR_ExamRule.Rowid},"G",0,"Score",{MinScore},{ChildSub})
	;^DHCWMRER({DHC_WMR_ExamRule.Rowid},"G",{ChildSub})
	q:'$d(^DHCWMRER(RuleRowid,"G")) ret
	s MinScore=""
	f  s MinScore=$o(^DHCWMRER(RuleRowid,"G",0,"Score",MinScore)) q:MinScore=""  d
	.s GardeSub=0
	.f  s GardeSub=$o(^DHCWMRER(RuleRowid,"G",0,"Score",MinScore,GardeSub)) q:GardeSub=""  d
	..s GardeRowid=RuleRowid_"||"_GardeSub
	..s Garde=..ByIdGetGarde(GardeRowid)
	..s tmpActive=$p(Garde,"^",4)
	..q:(IsActive="")&(tmpActive'=IsActive)
	..s ret=ret_$c(1)_Garde
	s:$l(ret)>0 ret=$e(ret,2,$l(ret))
	q ret
}

/// BuildData Function
ClassMethod BuildData(repid As %String, ind As %String, s As %String)
{
    set Data=$lb("")
    f iBuild=1:1:$l(s,"^") d
    .s $li(Data,iBuild)=$p(s,"^",iBuild)
    Set ^CacheTemp(repid,ind)=Data
    q
}

/// 获取检查标准字典列表
/// IsActive：是否活动
/// By Liyang 2008-6-15
ClassMethod GetRuleDicList(IsActive)
{
	set id = ""
	set str = ""
	set strData= ""
	do
	{
		set id = $o(^DHCWMRRDIC(id))
		if (id '= "")
		{
			set strData = $g(^DHCWMRRDIC(id))
			if (($p(strData,"^",4) = IsActive)!(IsActive = ""))
			{
				set str = str_id_"^"_strData_$c(1)
			}
		}
	} while(id '= "")
	quit str
}

}
