Import SQLUser

/// 评估结果存取方法
Class web.DHCWMRExamResultCtl Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 164;

/// 存 6 评估结果 DHC_WMR_ExamResult
ClassMethod UpdateExamResult(Instring)
{
    n (Instring)
    s ret=""
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
    zn MEDDATA
    s ret=$$UpdateExamResult^DHCWMRExamResult(Instring)
	zn CurrentNS
	q ret
}

/// 存 6.1 评估结果项目内容 DHC_WMR_ExamRDtl
ClassMethod UpdateExamRDtl(Instring)
{
    n (Instring)
    s ret=""
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
    zn MEDDATA
    s ret=$$UpdateExamRDtl^DHCWMRExamResult(Instring)
	zn CurrentNS
	q ret
}

/// 存 6.1.1 评估项目 DHC_WMR_ExamRDtlPeople
ClassMethod UpdateExamRDtlPeople(Instring)
{
    n (Instring)
    s ret=""
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
    zn MEDDATA
    s ret=$$UpdateExamRDtlPeople^DHCWMRExamResult(Instring)
	zn CurrentNS
	q ret
}

/// 存 6.1.2 自动监控项目 DHC_WMR_ExamRDtlACR
ClassMethod UpdateExamRDtlACR(Instring)
{
    n (Instring)
    s ret=""
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
    zn MEDDATA
    s ret=$$UpdateExamRDtlACR^DHCWMRExamResult(Instring)
	zn CurrentNS
	q ret
}

/// 取 6 评估结果 DHC_WMR_ExamResult
ClassMethod ByIdGetExamResult(ExamRRowid)
{
	n (ExamRRowid)
	
	s retString=##class(web.DHCWMRQualityBaseCtl).GetExRById(ExamRRowid)
	
	i retString'="" d
	.;DHC_WMR_MainVolume
	.s Volume=""
	.s VolumeDr=$p(retString,"^",2)
	.s:VolumeDr'="" Volume=##class(web.DHCWMRQualityBaseCtl).GetVolById(VolumeDr)
	.
	.;DHC_WMR_ExamRule
	.s ExamRule=""
	.s ExamRuleDr=$p(retString,"^",3)
	.s:ExamRuleDr'="" ExamRule=##class(web.DHCWMRQualityBaseCtl).GetERById(ExamRuleDr)
	.i ExamRule'="" d
	..;DHC_WMR_RuleDic
	..s tmpRuleDicDr=$p($g(ExamRule),"^",2)
	..s tmpRuleDic=##class(web.DHCWMRQualityBaseCtl).GetDicRById(tmpRuleDicDr)
	.s ExamRule=ExamRule_$c(2)_$g(tmpRuleDic)
	.
	.;DHC_WMR_ExamGarde
	.s ExamGarde=""
	.s ExamGardeDr=$p(retString,"^",8)
	.s:ExamGardeDr'="" ExamGarde=##class(web.DHCWMRQualityBaseCtl).GetEGById(ExamGardeDr)
	.
	.;SS_User
	.s SSUserDr=+$p(retString,"^",11)
	.s:SSUserDr'=0 SSUser=##class(web.DHCMedBaseCtl).GetUsrStr(SSUserDr)
	.s SSUser=$tr($g(SSUser),"/","^")
	.
	.s retString=retString_$c(2)_Volume_$c(2)_ExamRule_$c(2)_ExamGarde_$c(2)_SSUser
	q retString
	/*
	s retString=""
    q:'$d(^DHCWMRERST(+ExamRRowid)) retString
	
	s retString=$g(^DHCWMRERST(+ExamRRowid))
	s retString=ExamRRowid_"^"_retString
	s:$p(retString,"^",4)'="" $p(retString,"^",4)=$s($p(retString,"^",4)["Y":"Yes",1:"No")
	s:$p(retString,"^",7)'="" $p(retString,"^",7)=$s($p(retString,"^",7)["Y":"Yes",1:"No")
	s:$p(retString,"^",9)'="" $p(retString,"^",9)=$s($p(retString,"^",9)["Y":"Yes",1:"No")
	s:$p(retString,"^",12)'="" $p(retString,"^",12)=$zd($p(retString,"^",12),3)   ;评估日期(2007-01-01)
	s:$p(retString,"^",13)'="" $p(retString,"^",13)=$zt($p(retString,"^",13),2)   ;评估时间(10:10)
	s:$p(retString,"^",14)'="" $p(retString,"^",14)=$s($p(retString,"^",14)["Y":"Yes",1:"No")
	
	;^DHCWMRVOL({DHC_WMR_MainVolume.Rowid})
	s VolRowid=+$p(retString,"^",2)
	s Volume=""
	s:VolRowid'=0 Volume=VolRowid_"^"_$g(^DHCWMRVOL(VolRowid))
	s:$p(Volume,"^",5)'="" $p(Volume,"^",5)=$s($p(Volume,"^",5)["Y":"Yes",1:"No")
	s:$p(Volume,"^",6)'="" $p(Volume,"^",6)=$s($p(Volume,"^",6)["Y":"Yes",1:"No")
	s:$p(Volume,"^",8)'="" $p(Volume,"^",8)=$s($p(Volume,"^",8)["Y":"Yes",1:"No")
	s:$p(Volume,"^",9)'="" $p(Volume,"^",9)=$s($p(Volume,"^",9)["Y":"Yes",1:"No")
	
	;^DHCWMRER({Rowid})
	s ExamRuleDr=$p(retString,"^",3)
	i ExamRuleDr'="" d
	.s ExamRuleDr=+ExamRuleDr
	.s ExamRule=""
	.s:ExamRuleDr'=0 ExamRule=ExamRuleDr_"^"_$g(^DHCWMRER(ExamRuleDr))
	.s ScoreMethod=$p(ExamRule,"^",8)
	.s:ScoreMethod["A" ScoreMethod="Add"
	.s:ScoreMethod["R" ScoreMethod="Reduce"
	.s:$p(ExamRule,"^",8)'="" $p(ExamRule,"^",8)=ScoreMethod
	.s:$p(ExamRule,"^",9)'="" $p(ExamRule,"^",9)=$s($p(ExamRule,"^",9)["Y":"Yes",1:"No")
	.;^DHCWMRRDIC({Rowid})
	.s RuleDicDr=+$p($g(ExamRule),"^",2)
	.s:RuleDicDr'=0 RuleDic=RuleDicDr_"^"_$g(^DHCWMRRDIC(RuleDicDr))
	.s:$p(RuleDic,"^",5)'="" $p(RuleDic,"^",5)=$s($p(RuleDic,"^",5)["Y":"Yes",1:"No")
	s ExamRule=$g(ExamRule)_$c(2)_$g(RuleDic)
	
	;^DHCWMRER({DHC_WMR_ExamRule.Rowid},"G",{ChildSub})
	s ExamGardeDr=$p(retString,"^",8)
	i ExamGardeDr'="" d
	.s ExamRRowid=+ExamGardeDr
	.s ExamGSub=$p(ExamGardeDr,"||",2)
	.q:ExamGSub=""
	.s ExamGarde=ExamGardeDr_"^"_$g(^DHCWMRER(ExamRRowid,"G",ExamGSub))
	.s:$p(ExamGarde,"^",4)'="" $p(ExamGarde,"^",4)=$s($p(ExamGarde,"^",4)["Y":"Yes",1:"No")
	s ExamGarde=$g(ExamGarde)
	
	s SSUserDr=$p(retString,"^",11)
	s:SSUserDr'="" SSUser=##class(web.DHCMedBaseCtl).GetUsrStr(+SSUserDr)
	s SSUser=$tr($g(SSUser),"/","^")
	
	;w $g(ExamRule)_"//"_$g(RuleDic),!!
	;w $g(Volume)_"//"_"*"_"//"_$g(ExamGarde)_"//"_$g(SSUser),!!
	s retString=retString_$c(2)_$g(Volume)_$c(2)_$g(ExamRule)_$c(2)_$g(ExamGarde)_$c(2)_$g(SSUser)
	q retString
	*/
}

/// 取 6.1 评估结果项目内容 DHC_WMR_ExamRDtl
ClassMethod ByIdGetExamRDtl(ExamRDtlRowid)
{
	n (ExamRDtlRowid)
	
	s retString=##class(web.DHCWMRQualityBaseCtl).GetExRDById(ExamRDtlRowid)
	
	i retString'="" d
	.;DHC_WMR_ExamEntry
	.s ExamEntry=""
	.s ExamEntryDr=$p(retString,"^",2)
	.s:ExamEntryDr'="" ExamEntry=##class(web.DHCWMRQualityBaseCtl).GetEEById(ExamEntryDr)
	.i ExamEntry'="" d
	..;DHC_WMR_EntryDic
	..s tmpEntryDicDr=$p(ExamEntry,"^",2)
	..s:tmpEntryDicDr'="" tmpEntryDic=##class(web.DHCWMRQualityBaseCtl).GetDicEById(tmpEntryDicDr)
	..;DHC_WMR_ExamEntry
	..s tmpExamEntryDr=$p(ExamEntry,"^",8)
	..s:tmpExamEntryDr'="" tmpExamEntry=##class(web.DHCWMRQualityBaseCtl).GetEEById(tmpExamEntryDr)
	..;DHC_WMR_Dictionary
	..s tmpDicDr=$p(ExamEntry,"^",10)
	..s:tmpDicDr'="" tmpDic=##class(web.DHCWMRQualityBaseCtl).GetDicById(tmpDicDr)
	.s ExamEntry=ExamEntry_$c(2)_$g(tmpEntryDic)_$c(2)_$g(tmpExamEntry)_$c(2)_$g(tmpDic)
	.s retString=retString_$c(2)_ExamEntry
	q retString
	/*
	s retString=""
	s ExamRRowid=+ExamRDtlRowid
	s ExamRDtlSub=$p(ExamRDtlRowid,"||",2)
    q:'$d(^DHCWMRERST(+ExamRRowid,"D",ExamRDtlSub)) retString
	
	s retString=$g(^DHCWMRERST(+ExamRRowid,"D",ExamRDtlSub))
	s retString=ExamRDtlRowid_"^"_retString
	s:$p(retString,"^",6)'="" $p(retString,"^",6)=$zd($p(retString,"^",6),3)   ;触发日期（2007-01-01）
	s:$p(retString,"^",8)'="" $p(retString,"^",8)=$s($p(retString,"^",8)["Y":"Yes",1:"No")
	
	;^DHCWMRER({DHC_WMR_ExamRule.Rowid},"S",{DHC_WMR_ExamSection.ChildSub},"E",{ChildSub})
	s ExamEntryDr=$p(retString,"^",2)
	i ExamEntryDr'="" d
	.s ExamRRowid=+ExamEntryDr
	.s ExamSSub=$p(ExamEntryDr,"||",2)
	.s ExamESub=$p(ExamEntryDr,"||",3)
	.q:((ExamSSub="")||(ExamESub=""))
	.s ExamEntry=ExamEntryDr_"^"_$g(^DHCWMRER(ExamRRowid,"S",ExamSSub,"E",ExamESub))
    .s:$p(ExamEntry,"^",6)'="" $p(ExamEntry,"^",6)=$s($p(ExamEntry,"^",6)["Y":"Yes",1:"No")
	.s:$p(ExamEntry,"^",7)'="" $p(ExamEntry,"^",7)=$s($p(ExamEntry,"^",7)["Y":"Yes",1:"No")
	.s:$p(ExamEntry,"^",11)'="" $p(ExamEntry,"^",11)=$s($p(ExamEntry,"^",11)["Y":"Yes",1:"No")
	.;^DHCWMREDIC({Rowid})
	.s EntryDr=+$p($g(ExamEntry),"^",2)
	.s Entry=""
	.s:EntryDr'=0 Entry=EntryDr_"^"_$g(^DHCWMREDIC(EntryDr))
	.s:$p(Entry,"^",5)'="" $p(Entry,"^",5)=$s($p(Entry,"^",5)["Y":"Yes",1:"No")
	.;^DHCWMRER({DHC_WMR_ExamRule.Rowid},"S",{DHC_WMR_ExamSection.ChildSub},"E",{ChildSub})
	.s EEDr=$p($g(ExamEntry),"^",8)
	.i EEDr'="" d
	..s ERRowid=+EEDr
	..s ESSub=$p(EEDr,"||",2)
	..s EESub=$p(EEDr,"||",3)
	..q:((ESSub="")||(EESub=""))
	..s EE=EEDr_"^"_$g(^DHCWMRER(ERRowid,"S",ESSub,"E",EESub))
    ..s:$p(EE,"^",6)'="" $p(EE,"^",6)=$s($p(EE,"^",6)["Y":"Yes",1:"No")
	..s:$p(EE,"^",7)'="" $p(EE,"^",7)=$s($p(EE,"^",7)["Y":"Yes",1:"No")
	..s:$p(EE,"^",11)'="" $p(EE,"^",11)=$s($p(EE,"^",11)["Y":"Yes",1:"No")
	.;^DHCWMRDIC({Rowid})
    .s DicDr=+$p($g(ExamEntry),"^",10)
    .s Dic=""
    .s:DicDr'=0 Dic=DicDr_"^"_$g(^DHCWMRDIC(DicDr))
	.s:$p(Dic,"^",5)'="" $p(Dic,"^",5)=$zd(+$p(Dic,"^",5),3)
	.s:$p(Dic,"^",6)'="" $p(Dic,"^",6)=$zd(+$p(Dic,"^",6),3)
	.s:$p(Dic,"^",11)'="" $p(Dic,"^",11)=$s($p(Dic,"^",11)["Y":"Yes",1:"No")
    s ExamEntry=$g(ExamEntry)_$c(2)_$g(Entry)_$c(2)_$g(EE)_$c(2)_$g(Dic)
    
	s retString=retString_$c(2)_$g(ExamEntry)
	q retString
	*/
}

/// 取 6.1.1 评估项目 DHC_WMR_ExamRDtlPeople
ClassMethod ByIdGetExamRDtlP(ExamRDtlPRowid)
{
	n (ExamRDtlPRowid)
	
	s retString=##class(web.DHCWMRQualityBaseCtl).GetExRDPById(ExamRDtlPRowid)
	
	i retString'="" d
	.;SS_User
	.s SSUserDr=+$p(retString,"^",2)
	.s:SSUserDr'=0 SSUser=##class(web.DHCMedBaseCtl).GetUsrStr(SSUserDr)
	.s SSUser=$tr($g(SSUser),"/","^")
	.
	.;DHC_WMR_Dictionary
	.s Dic=""
	.s DicDr=$p(retString,"^",3)
	.s:DicDr'="" Dic=##class(web.DHCWMRQualityBaseCtl).GetDicById(DicDr)
	.
	.;CT_Loc
	.s LocDr=+$p(retString,"^",4)
	.s:LocDr'=0 Loc=##class(web.DHCMedBaseCtl).GetCtlocStr(LocDr)
	.s Loc=$tr($g(Loc),"/","^")
	.s retString=retString_$c(2)_SSUser_$c(2)_Dic_$c(2)_Loc
	q retString
	/*
	s retString=""
	s ExamRRowid=+ExamRDtlPRowid
	s ExamRDtlSub=$p(ExamRDtlPRowid,"||",2)
	s ExamRDtlPSub=$p(ExamRDtlPRowid,"||",3)
    q:'$d(^DHCWMRERST(+ExamRRowid,"D",ExamRDtlSub,"P",ExamRDtlPSub)) retString
	
	s retString=$g(^DHCWMRERST(+ExamRRowid,"D",ExamRDtlSub,"P",ExamRDtlPSub))
	s retString=ExamRDtlPRowid_"^"_retString
	s:$p(retString,"^",5)'="" $p(retString,"^",5)=$s($p(retString,"^",5)["Y":"Yes",1:"No")
	
	;SSUser
	s SSUserDr=+$p(retString,"^",2)
	s:SSUserDr'=0 SSUser=##class(web.DHCMedBaseCtl).GetUsrStr(SSUserDr)
	s SSUser=$tr($g(SSUser),"/","^")
	
	;DHC_WMR_Dictionary
	s DicDr=+$p(retString,"^",3)
	s Dic=""
	s:DicDr'=0 Dic=DicDr_"^"_$g(^DHCWMRDIC(DicDr))
	s:$p(Dic,"^",5)'="" $p(Dic,"^",5)=$zd(+$p(Dic,"^",5),3)
	s:$p(Dic,"^",6)'="" $p(Dic,"^",6)=$zd(+$p(Dic,"^",6),3)
	s:$p(Dic,"^",11)'="" $p(Dic,"^",11)=$s($p(Dic,"^",11)["Y":"Yes",1:"No")
	
	;CT_Loc
	s LocDr=+$p(retString,"^",4)
	s:LocDr'=0 Loc=##class(web.DHCMedBaseCtl).GetCtlocStr(LocDr)
	s Loc=$tr(Loc,"/","^")
    
	s retString=retString_$c(2)_$g(SSUser)_$c(2)_$g(Dic)_$c(2)_$g(Loc)
	q retString
	*/
}

/// 批处理，保存评估结果项目内容
/// 表：DHC_WMR_ExamRDtl
/// 表：DHC_WMR_ExamRDtlPeople
ClassMethod SaveExamRDtl(ExamRDtl)
{
	n (ExamRDtl)
	s ret=-1111
	q:ExamRDtl="" ret
	
	b //TStart
	TStart
	s DtlCount=$l(ExamRDtl,$c(1))
	f Ind=1:1:DtlCount d
	.q:ret<-1111
	.s tmpExamRDtl=$p(ExamRDtl,$c(1),Ind)
	.q:tmpExamRDtl=""
	.s tmpRDtl=$p(tmpExamRDtl,$c(2),1)
	.s tmpRDtlPeople=$p(tmpExamRDtl,$c(2),2)
	.b //UpdateExamRDtl
	.s retFlg=..UpdateExamRDtl(tmpRDtl)
	.;b //retFlg
	.i retFlg<0 TRollBack
	.s:retFlg<0 ret=-2222
	.q:retFlg<0
	.s PelCount=$l(tmpRDtlPeople,$c(3))
	.s PelRowid=retFlg
	.f IndSub=1:1:PelCount d
	..q:ret<-2222
	..s tmpRDtlPel=$p(tmpRDtlPeople,$c(3))
	..q:tmpRDtlPel=""
	..s:$p(tmpRDtlPel,"^",1)="" $p(tmpRDtlPel,"^",1)=PelRowid
	..b //UpdateExamRDtlPeople
	..s retFlg=..UpdateExamRDtlPeople(tmpRDtlPel)
	..b //retFlg
	..i retFlg<0 TRollBack
	..s:retFlg<0 ret=-2222.1
	q:ret<-1111 ret
	b //TCommit
	TCommit
	
	s ret=9999
	q ret
}

/// 测试--批处理，保存评估结果项目内容
ClassMethod TestSaveExamRDtl()
{
	s s1="^815418^52^N^85.5^85.5^Y^52||1^N^145^0^^^Y^Test"
	s s2="^^32||1||10^90^90^90^2007-01-01^A^Y^A"_$c(2)_"^^1^1^3^Y^B"_$c(3)_"^^1^1^3^Y^B"_$c(1)_"^^32||1||10^90^90^90^2007-01-01^A^Y^A"_$c(2)_"^^1^1^3^Y^B"_$c(3)_"^^1^1^3^Y^B"
	
	s ret=##class(web.DHCWMRExamResultCtl).SaveExamRst(s1,s2)
	q ret
}

ClassMethod SaveExamRst(sExamRst, sDtl)
{
	n (sExamRst,sDtl)
	s ret=-1
	//q:(sExamRst="")!(sDtl="") ret
	q:(sExamRst="") ret //Modified By LiYang 2008-10-14  即便是没有问题，也可以保存通过~
	TStart
	s RstRowid=..UpdateExamResult(sExamRst)
	i +RstRowid<0 d
	.TRollBack
	s:+RstRowid<0 ret=-1.1
	q:+RstRowid<0 ret
	s ret=RstRowid
	s DtlCount=$l(sDtl,$c(1))
	f Ind=1:1:DtlCount d
	.s tmpExamRDtl=$p(sDtl,$c(1),Ind)
	.s tmpRDtl=$p(tmpExamRDtl,$c(2),1)
	.s tmpDtlPList=$p(tmpExamRDtl,$c(2),2)
	.q:(tmpRDtl="")!(tmpDtlPList="")
	.s $p(tmpRDtl,"^",1)=RstRowid
	.s dtlRowid=..UpdateExamRDtl(tmpRDtl)
	.i +dtlRowid<0 TRollBack
	.s:+dtlRowid<0 ret=-2.1
	.q:+dtlRowid<0
	.s PelCount=$l(tmpDtlPList,$c(3))
	.f IndSub=1:1:PelCount d
	..s tmpRDtlPel=$p(tmpDtlPList,$c(3),IndSub)
	..q:tmpRDtlPel=""
	..s:$p(tmpRDtlPel,"^",1)="" $p(tmpRDtlPel,"^",1)=dtlRowid
	..s dtlpRowid=..UpdateExamRDtlPeople(tmpRDtlPel)
	..i +dtlpRowid<0 TRollBack
	..s:+dtlpRowid<0 ret=-2.2
	..q:+dtlpRowid<0
	q:ret<0 ret
	TCommit
	q ret
}

ClassMethod QueryExamResultDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryExamResultDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryExamResultDtlExecute(ByRef qHandle As %Binary, ResultID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	quit:($d(^DHCWMRERST(+ResultID))=0) $$$OK
	set strResult = $g(^DHCWMRERST(+ResultID))
	set Child = "0"
	while 1
	{
		set Child = $o(^DHCWMRERST(ResultID,"D",Child))
		quit:Child=""
		set strData = $g(^DHCWMRERST(ResultID,"D",Child))
		if ($p(strData, "^", 7) = "Y")
		{
			set ^CacheTemp(repid, ind) = $$BuildQueryExamResultDtl($p(strResult,"^",2), ResultID, Child,strData)
			set ind = ind + 1
		}
	}
	
	Quit $$$OK

BuildQueryExamResultDtl(RuleID, ResultID, Child, strDtl)
	n (RuleID, ResultID, Child, strDtl)
	Set Data=$lb("")
	
	set EntryID = $p(strDtl ,"^", 1)
	set Entry = $g(^DHCWMRER(+$p(EntryID,"||",1),"S",+$p(EntryID,"||",2),"E",+$p(EntryID,"||",3)))
	set EntryDic = $g(^DHCWMREDIC(+$p(Entry, "^", 1)))
	
	set Section = $g(^DHCWMRER(+$p(EntryID,"||",1),"S",+$p(EntryID,"||",2)))
	set SectionDic = $g(^DHCWMRSDIC(+$p(Section, "^", 1)))
	
	set PeopleID = "0"
	set PeopleStr = ""
	while 1
	{
		set PeopleID = $o(^DHCWMRERST(ResultID, "D", Child, "P", PeopleID))
		quit:PeopleID=""
		set People = $g(^DHCWMRERST(ResultID, "D", Child, "P", PeopleID))		
		continue:$p(People,"^",4)'="Y"
		set UserID = $p(People,"^",1)
		set LocID = $p(People, "^", 3)
		if (UserID '= "")
		{
			set UserData = ##class(web.DHCMedBaseCtl).GetUsrStr(+UserID)
			set Loc = $g(^CTLOC(+LocID))
			set TmpUser = $p(UserData, "/", 2) _ " " _ $p(UserData, "/", 3)
			if (UserData '= "")
			{
				set tmpResult = TmpUser
			}
			else
			{
				set tmpResult =  $p(Loc, "^", 2)
			}
			 
		}
		else //Modified By LiYang 2009-3-9 如果没有责任人就显示责任科室
		{
			set Loc = $g(^CTLOC(+LocID))
			set tmpResult =  $p(Loc, "^", 2)
		}
		if ((UserID="")&&(+LocID=0))
		{
			set tmpResult = $p(People, "^", 5)
		}
		set:PeopleStr'="" PeopleStr = PeopleStr _ ","
		set PeopleStr = PeopleStr _ tmpResult
	}
	
	Set $li(Data, 1)= $p(SectionDic, "^", 2) //章节
	Set $li(Data, 2)= $p(EntryDic, "^", 2)  //条目
	if ($p(strDtl, "^", 5) '= "")  //触发日期
	{
		Set $li(Data, 3)= $zd($p(strDtl, "^", 5),3) 
	}
	else
	{
		Set $li(Data, 3)= ""
	}
	Set $li(Data, 4) = $p(strDtl, "^", 2) //数量
	Set $li(Data, 5) = $p(strDtl, "^", 3) //分数
	Set $li(Data, 6) = $p(strDtl, "^", 4) //扣款
	Set $li(Data, 7) = PeopleStr //责任人
	
	quit Data
}

ClassMethod QueryExamResultDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryExamResultDtlExecute ]
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

/// 查询评估结果明细
Query QueryExamResultDtl(ResultID As %String) As %Query(ROWSPEC = "SectionName:%String:章节,EntryName:%String:条目,HappendDate:%String:发生日期,Number:%String:次数,Score:%String:扣分,Money:%String:扣款,People:%String:责任人")
{
}

/// By LiYang 2008-11-11
/// 通过检查结果的ID，查询结果的明细项目
ClassMethod GetDetailByResultID(ResultID)
{
	n (ResultID)
	s ResultID=$g(ResultID)
	quit:ResultID=""
	set ChildSub = ""
	set ret = ""
	for  set ChildSub=$o(^DHCWMRERST(ResultID,"D",+ChildSub)) quit:ChildSub=""  d
	.set ret = ret _ $$BuildExamResultDtl(ResultID, ChildSub) _ $c(1)
	quit ret

BuildExamResultDtl(ResultID, ChildSub)
	n (ResultID, ChildSub)
	quit:(ResultID="")!(ChildSub="") ""
	set strDtl = $g(^DHCWMRERST(ResultID, "D", ChildSub))
	set:$p(strDtl,"^",5)'="" $p(strDtl,"^",5)=$zd($p(strDtl,"^",5),4)
	quit:strDtl="" ""
	set strDtl = ResultID _ "||" _ ChildSub _ "^" _strDtl
	set PeopleStr = ""
	set PeopleID = ""
	while 1
	{
		set PeopleID = $o(^DHCWMRERST(ResultID, "D", ChildSub, "P", PeopleID))
		quit:PeopleID=""
		set People = $g(^DHCWMRERST(ResultID, "D", ChildSub, "P", PeopleID))		
		continue:$p(People,"^",4)'="Y"
		set UserID = $p(People,"^",1)
		set LocID = $p(People, "^", 3)
		set UserData = ##class(web.DHCMedBaseCtl).GetUsrStr(+UserID)
		set Loc = ##class(web.DHCMedBaseCtl).GetCtlocStr(+LocID)
		set PeopleStr = PeopleStr_ResultID_"||"_ChildSub_"||"_PeopleID_"^"_People_$c(4)_UserData_$c(4)_Loc_$c(3)
	}
	set strResult = strDtl _ $c(2) _ PeopleStr
	quit strResult
}

}
