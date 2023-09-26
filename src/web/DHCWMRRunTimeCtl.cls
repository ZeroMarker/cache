Import SQLUser

Class web.DHCWMRRunTimeCtl Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 83;

ClassMethod QueryLocByNameClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryLocByNameExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryLocByNameExecute(ByRef qHandle As %Binary) As %Status
{
    ;d ##class(%ResultSet).RunQuery("web.DHCWMRPublicFun","QueryLocByName","mn","")
    Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	;^PAWARD({WARD_RowID})
    s tmpRowid=0
    f  s tmpRowid=$o(^PAWARD(tmpRowid)) q:(tmpRowid="")!(+tmpRowid=0)  d
	.s LocDesc=$p(^PAWARD(tmpRowid),"^",2)
	.s:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
	.s s=tmpRowid_"^"_LocDesc
    .s Data=$lb(tmpRowid,LocDesc)
 	.s ^CacheTemp(repid,ind)=Data
    .s ind=ind+1
    
    Quit $$$OK
}

ClassMethod QueryLocByNameFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryLocByNameExecute ]
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

Query QueryLocByName() As %Query(ROWSPEC = "WardRowid:%String,WardName:%String")
{
}

/*
Query QueryRuleDic() As %SQLQuery(CONTAINID = 1)
{
  SELECT %ID,Title FROM DHC_WMR_RuleDic where %ID>0 AND IsActive='Y'
}
*/
/// BuildData Function
ClassMethod BuildData(repid As %String, ind As %String, s As %String)
{
    set Data=$lb("")
    f iBuild=1:1:$l(s,"^") d
    .s $li(Data,iBuild)=$p(s,"^",iBuild)
    Set ^CacheTemp(repid,ind)=Data
    q
}

ClassMethod QueryRuleDicClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryRuleDicExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod QueryRuleDicExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
    Set ind = 1
    Set qHandle=$lb(0,repid,0)
    
    ;^DHCWMRRDIC({Rowid})
    s Rowid=0
    f  s Rowid=$o(^DHCWMRRDIC(Rowid)) q:Rowid=""  d
    .s tmpRule=$g(^DHCWMRRDIC(Rowid))
    .;Rowid,Title
    .s Title=$p(tmpRule,"^",2)
    .s IsActive=$p(tmpRule,"^",4)
    .q:IsActive'="Y"
    .s s=Rowid_"^"_Title
    .d ..BuildData(repid,ind,s)
    .s ind=ind+1

    Quit $$$OK
}

ClassMethod QueryRuleDicFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryRuleDicExecute ]
{
        
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {
	    // if there are no more rows, finish fetching
        Set AtEnd = 1
        Set Row = ""
    }
    Else{
	    // fetch row
        Set Row=^CacheTemp(repid,ind)
    }
    // Save QHandle
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

Query QueryRuleDic() As %Query(ROWSPEC = "Rowid:%String,Title:%String")
{
}

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
	
	s ret=##Class(web.DHCWMRMedBasePaadmCtl).GetCurrPaadms(Ward)
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
   s MrNo=$p(^PAPER(papmi,"PER",4),"^",4) 
   s DocName=$p($p(s,"^",8),"/",3)
   
   s Data=$lb(PatNo,PatName,Sex,Age,AdmDate,MrNo,DocName,Paadm,papmi)
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

Query QueryAdms(ExamRuleRowid As %String, Ward As %String) As %Query(ROWSPEC = "PatNo:%String,PatName:%String,Sex:%String,Age:%String,AdmDate:%String,MrNo:%String,DocName:%String,Paadm:%String,papmi:%String")
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
	
	q:'$d(^DHCWMRER(ExamRuleRowid)) $$$OK
	
	;^DHCWMRER({DHC_WMR_ExamRule.Rowid},"S",{DHC_WMR_ExamSection.ChildSub},"E",{ChildSub})
	s Section=0
	f  s Section=$o(^DHCWMRER(ExamRuleRowid,"S",Section)) q:Section=""  d
	.s Entry=0
	.;b ;1
	.f  s Entry=$o(^DHCWMRER(ExamRuleRowid,"S",Section,"E",Entry)) q:Entry=""  d
	..;b  ;2
	..s EntryRowid=ExamRuleRowid_"||"_Section_"||"_Entry
	..s s=##class(web.DHCWMRQualityBaseCtl).GetEEById(EntryRowid)
	..s flag=$$BuildEntry(s)
	
 	Quit $$$OK
BuildEntry(s)
   
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

   s Data=$lb(ExamEntry,EntryDesc,ResultRowid,RSbilityDesc,DocName,DocRowid)
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

Query QueryEntrys(paadm As %String, ExamRuleRowid As %String) As %Query(ROWSPEC = "ExamEntry:%String,EntryDesc:%String,ResultRowid:%String,RSbilityDesc:%String,DocName:%String,DocRowid:%String")
{
}

}
