Class web.DHCWMRQuality.BORunTimeError Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 127;

ClassMethod QueryAdmsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryAdmsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryAdmsExecute(ByRef qHandle As %Binary, ExamRuleRowid As %String, Ward As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
    zn MEDDATA
	s ret=$$GetCurrPaadms^DHCMedBasePaadm(Ward)
	zn CurrentNS
	q:ret="" $$$OK
	s index=1
	f index=1:1:$l(ret,$c(1)) d
	.s s=$p(ret,$c(1),index)
	.q:s=""
	.s flag=$$BuildPaadms(s)
	
	Quit $$$OK 
BuildPaadms(s)
   
   s Paadm=$p(s,"^",1)
   s papmi=$p(s,"^",6)
   
   s PatNo=$p(s,"^",14)
   s PatName=$p(s,"^",15)
   s Sex=$p(s,"^",16)
   s Age=$p(s,"^",18)
   s AdmDate=$p(s,"^",4)
   //s MrNo=$p(^PAPER(papmi,"PER",4),"^",4)
   s MrNo=$p(^PAPER(papmi,"PAT",1),"^",22)
   s DocName=$p($p(s,"^",8),"/",3)
   s score=0
   s score=..GetRunTimeScore(ExamRuleRowid,Paadm)
   
   s Data=$lb(PatNo,PatName,Sex,Age,AdmDate,MrNo,DocName,Paadm,papmi,score)
   s ^CacheTemp(repid,ind)=Data
   s ind=ind+1
   q ind
}

ClassMethod QueryAdmsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryAdmsExecute ]
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

Query QueryAdms(ExamRuleRowid As %String, Ward As %String) As %Query(ROWSPEC = "PatNo:%String,PatName:%String,Sex:%String,Age:%String,AdmDate:%String,MrNo:%String,DocName:%String,Paadm:%String,papmi:%String,score:%String")
{
}

ClassMethod QueryEntrysClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryEntrysExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryEntrysExecute(ByRef qHandle As %Binary, paadm As %String, ExamRuleRowid As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	s paadm=$g(paadm)
	s:paadm="" paadm=$Get(%request.Data("EpisodeID",1))
	s ExamRuleRowid=$g(ExamRuleRowid)
	//取电子病历事件参数设置的评估标准***默认标准
	s:(+ExamRuleRowid)=0 ExamRuleRowid=$p(##Class(web.DHCWMRQuality.BOACRExpBaseConfig).GetEPRExamRuleByCont("0","Prompt"),"^",4)
	//取电子病历系统配置中运行态病历质控标准Dr，在环境变量中取EpisodeID,传入
	s:(+ExamRuleRowid)=0 ExamRuleRowid=##class(EPRmeta.SysOption).GetOptionValueByName("EPRExamRuleRunTimeDr")	
	
	q:(ExamRuleRowid="")||(paadm="") $$$OK
	q:'$d(^DHCWMRER(ExamRuleRowid)) $$$OK
	k ^CacheTemp("DHCWMRQuality",$j,paadm)
	;^DHCWMRER({DHC_WMR_ExamRule.Rowid},"S",{DHC_WMR_ExamSection.ChildSub},"E",{ChildSub})
	s Section=0
	f  s Section=$o(^DHCWMRER(ExamRuleRowid,"S",Section)) q:Section=""  d
	.s Entry=0
	.f  s Entry=$o(^DHCWMRER(ExamRuleRowid,"S",Section,"E",Entry)) q:Entry=""  d
	..s EntryRowid=ExamRuleRowid_"||"_Section_"||"_Entry
	..;s s=##class(web.DHCWMRQualityBaseCtl).GetEEById(EntryRowid)
	..s flag=##class(web.DHCWMRQuality.BOEntryExpExplain).ExplainExamEntry(EntryRowid,paadm,"","")
	..//w "flag="_flag,!
	..i flag=1 d
	...s sExamEntry=##class(web.DHCWMRQualityBaseCtl).GetEEById(EntryRowid)
	...s EntryDr=+$p(sExamEntry,"^",2)
	...s EntryScore=+$p(sExamEntry,"^",3)
	...s sEntryDic=##class(web.DHCWMRQualityBaseCtl).GetDicEById(EntryDr)
	...s EntryTitle=$p(sEntryDic,"^",3)
	...s SecDicId=$p($g(^DHCWMRER(+$p(EntryRowid,"||",1),"S",+$p(EntryRowid,"||",2))),"^",1)  //评估大类
	...s SectionDesc=$p($g(^DHCWMRSDIC(+SecDicId)),"^",2)  //评估大类描述
	...s tt=$$BuildEntry()
	k ^CacheTemp("DHCWMRQuality",$j,paadm)
 	Quit $$$OK
BuildEntry()
   /*
   s EntryDicRowid=$p(s,"^",2)
   s sEntryDic=##class(web.DHCWMRQualityBaseCtl).GetDicEById(EntryDicRowid)
   
   s RSbilityDr=$p(s,"^",10),sRSbility=""
   s:RSbilityDr'="" sRSbility=##class(web.DHCWMRQualityBaseCtl).GetDicById(RSbilityDr)
   
   s ExamEntry=EntryRowid
   s EntryDesc=$p(sEntryDic,"^",3)
   s ResultRowid=""
   s RSbilityDesc=$p(sRSbility,"^",4)
   s Doc=$p($g(^PAADM(+paadm)),"^",9),sdoc=""
   s:Doc'="" sdoc=##class(web.DHCMedBaseCtl).GetUserByCTCP(Doc)
   
   s DocName=$p(sdoc,"/",3)
   s DocRowid=$p(sdoc,"/",1)
   */
   
   s RSbilityDr=$p(sExamEntry,"^",10),sRSbility=""
   s:RSbilityDr'="" sRSbility=##class(web.DHCWMRQualityBaseCtl).GetDicById(RSbilityDr)
   ;w !,RSbilityDr_"^"_sRSbility
   s ExamEntry=EntryRowid
   s EntryDesc=$p(sEntryDic,"^",3)
   
   s ResultRowid=""
   s RSbilityDesc=$p(sRSbility,"^",4)
   s Doc=$p($g(^PAADM(+paadm)),"^",9),sdoc=""
   s:Doc'="" sdoc=##class(web.DHCMedBaseCtl).GetUserByCTCP(Doc)
   
   s DocName=$p(sdoc,"/",3)
   s DocRowid=$p(sdoc,"/",1)
   
   s Data=$lb(ExamEntry,EntryDesc,ResultRowid,RSbilityDesc,DocName,DocRowid,EntryScore,SectionDesc)
   s ^CacheTemp(repid,ind)=Data
   s ind=ind+1
   q ind
}

ClassMethod QueryEntrysFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryEntrysExecute ]
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

Query QueryEntrys(paadm As %String, ExamRuleRowid As %String) As %Query(ROWSPEC = "ExamEntry:%String,EntryDesc:%String,ResultRowid:%String,RSbilityDesc:%String,DocName:%String,DocRowid:%String,EntryScore:%String,SectionDesc:%String")
{
}

ClassMethod GetRunTimeScore(ExamRuleRowid, Paadm)
{
	n (ExamRuleRowid,Paadm)
	s ret=0
	q:'$d(^DHCWMRER(ExamRuleRowid)) ret
	q:$p($g(^DHCWMRER(ExamRuleRowid)),"^",8)'="Y" ret
	s MaxScore=+$p($g(^DHCWMRER(ExamRuleRowid)),"^",2)
	s ret=MaxScore
	s secSub=0
	f  s secSub=$o(^DHCWMRER(ExamRuleRowid,"S",secSub)) q:secSub=""  d
	.s EntrySub=0
	.f  s EntrySub=$o(^DHCWMRER(ExamRuleRowid,"S",secSub,"E",EntrySub)) q:EntrySub=""  d
	..s EntryRowid=ExamRuleRowid_"||"_+secSub_"||"_+EntrySub
	..s flag=##class(web.DHCWMRQuality.BOEntryExpExplain).ExplainExamEntry(EntryRowid,Paadm,"","")
	..i flag=1 d
	...s sExamEntry=##class(web.DHCWMRQualityBaseCtl).GetEEById(EntryRowid)
	...s EntryDr=+$p(sExamEntry,"^",2)
	...s EntryScore=+$p(sExamEntry,"^",3)
	...;s sEntryDic=##class(web.DHCWMRQualityBaseCtl).GetDicEById(EntryDr)
	...;s EntryTitle=$p(sEntryDic,"^",3)
	...s ret=ret-EntryScore
	q ret
}

}
