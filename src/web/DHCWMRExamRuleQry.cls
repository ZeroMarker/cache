Import SQLUser

/// 评估标准查询方法
Class web.DHCWMRExamRuleQry Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 61;

ClassMethod QueryRuleByDicClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryRuleByDicExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryRuleByDicExecute(ByRef qHandle As %Binary, DicRowid As %String) As %Status
{
    s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:DicRowid="" $$$OK
	q:'$d(^DHCWMRER(0,"RuleActive",DicRowid)) $$$OK
	;^DHCWMRER(0,"RuleActive",{RuleDr},{IsActive},{Rowid})
	s active=""
	f  s active=$o(^DHCWMRER(0,"RuleActive",DicRowid,active)) q:active=""  d
	.s RuleRowid=""
    .f  s RuleRowid=$o(^DHCWMRER(0,"RuleActive",DicRowid,active,RuleRowid)) q:RuleRowid=""  d
    ..s s=$g(^DHCWMRER(+RuleRowid))
    ..s s=RuleRowid_"^"_s
    ..d BuileExamRuleList
	q $$$OK
BuileExamRuleList
    s data=$lb("")
 	For iIndex=1:1:$l(s) Do
 	.Set $li(data,iIndex)=$p(s,"^",iIndex)
 	s ^CacheTemp(repid,ind)=data
 	s ind=ind+1
 	q
}

ClassMethod QueryRuleByDicFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryRuleByDicExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/************************************************
 /Query DHC_WMR_ExamRule by RuleDicRowid
 *************************************************/
Query QueryRuleByDic(DicRowid As %String) As %Query(ROWSPEC = "RuleRowid:%String,RuleDr:%String,MaxScore:%String,PassingScore:%String,DeductLine:%String,MonyPerPoint:%String,Punishment:%String,ScoreMethod:%String,IsActive:%String,ResumeText:%String")
{
}

ClassMethod QuerySecByRuleClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QuerySecByRuleExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QuerySecByRuleExecute(ByRef qHandle As %Binary, RuleRowid As %String, Active As %String) As %Status
{
    s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:RuleRowid="" $$$OK
	q:'$d(^DHCWMRER(RuleRowid)) $$$OK
	
	s Pos=""
	f  s Pos=$o(^DHCWMRER(RuleRowid,"S",0,"Pos",Pos)) q:Pos=""  d
	.s SectionSub=0
	.f  s SectionSub=$o(^DHCWMRER(RuleRowid,"S",0,"Pos",Pos,SectionSub)) q:SectionSub=""  d
	..s SectionRowid=RuleRowid_"||"_SectionSub
	..s s=##class(web.DHCWMRExamRuleCtl).ByIdGetSection(SectionRowid)
	..q:(Active'="")&(Active'=$p(s,"^",5))
	..d BuildSection
	
	q $$$OK
BuildSection
    s secString=$p(s,$c(2),1)
    s secDicString=$p(s,$c(2),2)
    s SecRowid=$p(secString,"^",1)
    s SectionDr=$p(secString,"^",2)
    s SectionTitle=$p(secDicString,"^",3)
    s Score=+$p(secString,"^",3)
    s Pos=+$p(secString,"^",4)
    s IsActive=$p(secString,"^",5)
    s ResumeText=$p(secString,"^",6)
    s data=$lb(SecRowid,SectionDr,SectionTitle,Score,Pos,IsActive,ResumeText)
 	s ^CacheTemp(repid,ind)=data
 	s ind=ind+1
 	q
}

ClassMethod QuerySecByRuleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QuerySecByRuleExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/************************************************
 /Query DHC_WMR_ExamSection by RuleRowid
 *************************************************/
Query QuerySecByRule(RuleRowid As %String, Active As %String) As %Query(ROWSPEC = "SecRowid:%String,SectionDr:%String,SectionTitle:%String,Score:%String,Pos:%String,IsActive:%String,ResumeText:%String")
{
}

ClassMethod QueryEntryBySecParClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryEntryBySecParExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryEntryBySecParExecute(ByRef qHandle As %Binary, SectionRowid As %String, Parent As %String, Active As %String) As %Status
{
    s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:SectionRowid="" $$$OK
	
	s:Parent="" Parent=+Parent
	s RuleRowid=+SectionRowid
	s SectionSub=$p(SectionRowid,"||",2)
	q:'$d(^DHCWMRER(RuleRowid,"S",SectionSub,"E",0,"ParPos",Parent)) $$$OK
	
	s pos=""
	f  s pos=$o(^DHCWMRER(RuleRowid,"S",SectionSub,"E",0,"ParPos",Parent,pos)) q:pos=""  d
	.s EntrySub=""
	.f  s EntrySub=$o(^DHCWMRER(RuleRowid,"S",SectionSub,"E",0,"ParPos",Parent,pos,EntrySub)) q:EntrySub=""  d
	..s EntryRowid=RuleRowid_"||"_SectionSub_"||"_EntrySub
	..s s=##class(web.DHCWMRExamRuleCtl).ByIdGetEntry(EntryRowid)
	..q:(Active'="")&($p(s,"^",11)'[Active)
	..d BuildEntryList
	Quit $$$OK
BuildEntryList
    s ExamEntry=$p(s,$c(2),1)
    s EntryDic=$p(s,$c(2),2)
    s sDic=$p(s,$c(2),8)
    s iLen=$l(ExamEntry,"^")
    s data=$lb("")
    f i=1:1:iLen  d
    .s $li(data,i)=$p(ExamEntry,"^",i)
    s $li(data,iLen+1)=$p(EntryDic,"^",3)
    s $li(data,iLen+2)=$p(sDic,"^",4)
    s ^CacheTemp(repid,ind)=data
    s ind=ind+1
    q
}

ClassMethod QueryEntryBySecParFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryEntryBySecParExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// /by wuqk 2007-12-15
/// /因为增加examentry.expression 造成查询字段后延 
Query QueryEntryBySecPar(SectionRowid As %String, Parent As %String, Active As %String) As %Query(ROWSPEC = "EntryRowid:%String,EntryDr:%String,Score:%String,Pos:%String,Money:%String,MultiErr:%String,Veto:%String,ParentDr:%String,Layer:%String,RSbilityDr:%String,IsActive:%String,ResumeText:%String,EntryExp:%String,EntryTitle:%String,RSbilityDesc:%String")
{
}

ClassMethod QueryGardeByRuleClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryGardeByRuleExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryGardeByRuleExecute(ByRef qHandle As %Binary, RuleRowid As %String, Active As %String) As %Status
{
    s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	S ^zf=RuleRowid
	q:RuleRowid="" $$$OK
	q:'$d(^DHCWMRER(RuleRowid)) $$$OK
	
	s:Active'="" Active=$s(Active["Y":"Yes",1:"No")
	;^DHCWMRER({DHC_WMR_ExamRule.Rowid},"G",0,"Score",{MinScore},{ChildSub})
	s tmpMinScore=""
	f  s tmpMinScore=$o(^DHCWMRER(RuleRowid,"G",0,"Score",tmpMinScore)) q:tmpMinScore=""  d
	.s GardeSub=0
	.f  s GardeSub=$o(^DHCWMRER(RuleRowid,"G",0,"Score",tmpMinScore,GardeSub)) q:GardeSub=""  d
	..s GardeRowid=RuleRowid_"||"_GardeSub
	..s s=##class(web.DHCWMRExamRuleCtl).ByIdGetGarde(GardeRowid)
	..q:(Active'="")&(Active'=$p(s,"^",4))
	..d BuildGarde
	
	q $$$OK
BuildGarde
    s GardeString=$p(s,$c(2),1)
    s GardeRowid=$p(GardeString,"^",1)
    s Title=$p(GardeString,"^",2)
    s MinScore=$p(GardeString,"^",3)
    s IsActive=$p(GardeString,"^",4)
    s Resume=$p(GardeString,"^",5)
    s Money=$p(GardeString,"^",6)
    s data=$lb(GardeRowid,Title,MinScore,Money,IsActive,Resume)
 	s ^CacheTemp(repid,ind)=data
 	s ind=ind+1
 	q
}

ClassMethod QueryGardeByRuleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryGardeByRuleExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/************************************************
 /Query DHC_WMR_ExamGarde by RuleRowid
 *************************************************/
Query QueryGardeByRule(RuleRowid As %String, Active As %String) As %Query(ROWSPEC = "GardeRowid:%String,Title:%String,MinScore:%String,Money:%String,IsActive:%String,Resume:%String")
{
}

}
