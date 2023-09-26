Import SQLUser

Class web.DHCWMRQuality.ExExamResult Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 116;

ClassMethod getMRScore(ExamRule, Paadm)
{
	n (ExamRule,Paadm)
	s ret=0
	q:Paadm="" ret
	
	k ^CacheTemp("Score",$zn,$j)
	s ^CacheTemp("Score",$zn,$j,0)=100    //总分
	s RstRowid=0,flag=0
	f  s RstRowid=$o(^DHCWMRERST(0,"PAADM",+Paadm,RstRowid)) q:RstRowid=""  d
	.q:$p($g(^DHCWMRERST(+RstRowid)),"^",13)'="Y"
	.s CurrRule=$p($g(^DHCWMRERST(+RstRowid)),"^",2)
	.q:(ExamRule'="")&&(("|"_ExamRule_"|")'[("|"_CurrRule_"|"))
	.s DtlRowid=0
	.f  s DtlRowid=$o(^DHCWMRERST(RstRowid,"D",DtlRowid)) q:DtlRowid=""  d
	..q:$p($g(^DHCWMRERST(+RstRowid,"D",DtlRowid)),"^",7)'="Y"
	..s iNumber=+$p($g(^DHCWMRERST(+RstRowid,"D",DtlRowid)),"^",2)
	..s EntryID=$p($g(^DHCWMRERST(+RstRowid,"D",DtlRowid)),"^",1)
	..s EntryInfo=$g(^DHCWMRER(+$p(EntryID,"||",1),"S",+$p(EntryID,"||",2),"E",+$p(EntryID,"||",3)))
	..s EDicID=$p(EntryInfo,"^",1)
	..s EScore=$p(EntryInfo,"^",2)      //项目分值
	..s EMultiErr=$p(EntryInfo,"^",5)   //是否允许多次评分
	..s EVeto=$p(EntryInfo,"^",6)       //是否单项否决
	..s SectionInfo=$g(^DHCWMRER(+$p(EntryID,"||",1),"S",+$p(EntryID,"||",2)))
	..s SDicID=$p(SectionInfo,"^",1)
	..s SScore=$p(SectionInfo,"^",2)    //大类分值
	..s ^CacheTemp("Score",$zn,$j,SDicID,0)=SScore   //大类总分
	..//单项否决扣分
	..i EVeto="Y" d
	...q:$d(^CacheTemp("Score",$zn,$j,SDicID,EntryID))
	...s ^CacheTemp("Score",$zn,$j,-1)=(+$g(^CacheTemp("Score",$zn,$j,-1)))+EScore
	...s ^CacheTemp("Score",$zn,$j,SDicID,EntryID)=""
	..q:EVeto="Y"
	..//普通项目扣分
	..q:$d(^CacheTemp("Score",$zn,$j,SDicID,EntryID))&&(EMultiErr'="Y")
	..s:EMultiErr="N" iNumber=1
	..s ^CacheTemp("Score",$zn,$j,SDicID,-1)=(+$g(^CacheTemp("Score",$zn,$j,SDicID,-1)))+(iNumber*EScore)
	
	s Score=(+$g(^CacheTemp("Score",$zn,$j,0)))
	s Score=Score-(+$g(^CacheTemp("Score",$zn,$j,-1)))
	s SDicID=0
	f  s SDicID=$o(^CacheTemp("Score",$zn,$j,SDicID)) q:SDicID=""  d
	.i $g(^CacheTemp("Score",$zn,$j,SDicID,0))>$g(^CacheTemp("Score",$zn,$j,SDicID,-1)) d
	..s Score=Score-(+$g(^CacheTemp("Score",$zn,$j,SDicID,-1)))
	.e  d
	..s Score=Score-(+$g(^CacheTemp("Score",$zn,$j,SDicID,0)))
	k ^CacheTemp("Score",$zn,$j)
	
	s:Score>0 ret=Score
	q ret
}

ClassMethod StatMRQualityClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = StatMRQualityExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod StatMRQualityExecute(ByRef qHandle As %Binary, ExamRule As %String, AdmLoc As %String, AdmWard As %String, AdmDoc As %String, DateFrom As %String, DateTo As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	//s ^ZF(11)=$lb(ExamRule,AdmLoc,AdmWard,AdmDoc,DateFrom,DateTo)
	q:(DateFrom="")||(DateTo="") $$$OK
	
	k ^CacheTemp("MRStat",$zn,$j)
	f DischDate=DateFrom:1:DateTo d
	.s Paadm=0
	.f  s Paadm=$o(^PAADMi("DischDate",DischDate,Paadm)) q:Paadm=""  d
	..s tmpPaadm=$g(^PAADM(+Paadm))
	..q:tmpPaadm=""
	..q:$p(tmpPaadm,"^",75)'=""    //婴儿不建病案
	..q:$p(tmpPaadm,"^",20)'="D"                 //就诊状态
	..s tmpLoc=$p(tmpPaadm,"^",4)
	..q:(AdmLoc'="")&&(tmpLoc'=AdmLoc)           //出院科室
	..s tmpWard=$p(tmpPaadm,"^",70)
	..q:(AdmWard'="")&&(tmpWard'=AdmWard)        //出院病区
	..s tmpDoc=$p(tmpPaadm,"^",9)
	..q:(AdmDoc'="")&&(tmpDoc'=AdmDoc)           //主管医生
	..s Score=..getMRScore(ExamRule,Paadm)       //取病案得分
	..s tmpLoc=tmpLoc_"||"_tmpWard
	..s ^CacheTemp("MRStat",$zn,$j,tmpLoc,0,"Count")=(+$g(^CacheTemp("MRStat",$zn,$j,tmpLoc,0,"Count")))+1
	..s:Score>=90 ^CacheTemp("MRStat",$zn,$j,tmpLoc,0,"First")=(+$g(^CacheTemp("MRStat",$zn,$j,tmpLoc,0,"First")))+1
	..s:(Score<90)&&(Score>=70) ^CacheTemp("MRStat",$zn,$j,tmpLoc,0,"Second")=(+$g(^CacheTemp("MRStat",$zn,$j,tmpLoc,0,"Second")))+1
	..s:Score<70 ^CacheTemp("MRStat",$zn,$j,tmpLoc,0,"Third")=(+$g(^CacheTemp("MRStat",$zn,$j,tmpLoc,0,"Third")))+1
	..q:tmpDoc=""
	..s ^CacheTemp("MRStat",$zn,$j,tmpLoc,tmpDoc,"Count")=(+$g(^CacheTemp("MRStat",$zn,$j,tmpLoc,tmpDoc,"Count")))+1
	..s:Score>=90 ^CacheTemp("MRStat",$zn,$j,tmpLoc,tmpDoc,"First")=(+$g(^CacheTemp("MRStat",$zn,$j,tmpLoc,tmpDoc,"First")))+1
	..s:(Score<90)&&(Score>=70) ^CacheTemp("MRStat",$zn,$j,tmpLoc,tmpDoc,"Second")=(+$g(^CacheTemp("MRStat",$zn,$j,tmpLoc,tmpDoc,"Second")))+1
	..s:Score<70 ^CacheTemp("MRStat",$zn,$j,tmpLoc,tmpDoc,"Third")=(+$g(^CacheTemp("MRStat",$zn,$j,tmpLoc,tmpDoc,"Third")))+1
	
	s tmpLoc="",Count=0,First=0,Second=0,Third=0
	f  s tmpLoc=$o(^CacheTemp("MRStat",$zn,$j,tmpLoc)) q:tmpLoc=""  d
	.s tmpLocDesc=$p($g(^CTLOC(+$p(tmpLoc,"||",1))),"^",2)
	.s:tmpLocDesc["-" tmpLocDesc=$p(tmpLocDesc,"-",2)
	.s tmpWardID=$p($g(^PAWARD(+$p(tmpLoc,"||",2))),"^",5)    //CT_Loc 病区
	.s tmpWardDesc=$p($g(^CTLOC(+tmpWardID)),"^",2)
	.s:tmpWardDesc["-" tmpWardDesc=$p(tmpWardDesc,"-",2)
	.s MRCount=+$g(^CacheTemp("MRStat",$zn,$j,tmpLoc,0,"Count"))
	.s MRFirst=+$g(^CacheTemp("MRStat",$zn,$j,tmpLoc,0,"First"))
	.s MRSecond=+$g(^CacheTemp("MRStat",$zn,$j,tmpLoc,0,"Second"))
	.s MRThird=+$g(^CacheTemp("MRStat",$zn,$j,tmpLoc,0,"Third"))
	.s Count=Count+MRCount,First=First+MRFirst,Second=Second+MRSecond,Third=MRThird
	.s Data=$lb(tmpLocDesc,tmpWardDesc,"---",MRFirst,MRSecond,MRThird,MRCount,ExamRule,+$p(tmpLoc,"||",1),+$p(tmpLoc,"||",2),AdmDoc,DateFrom,DateTo)
	.s ^CacheTemp(repid,ind)=Data
	.s ind=ind+1
	.s tmpDoc=0
	.f  s tmpDoc=$o(^CacheTemp("MRStat",$zn,$j,tmpLoc,tmpDoc)) q:tmpDoc=""  d
	..s tmpDocDesc=$p($g(^CTPCP(+tmpDoc)),"^",2)    //CT_CareProv
	..s SSUserID=$o(^SSU("SSUSR",0,"CTPCP",+tmpDoc,0))  //SS_User
	..s:SSUserID'="" tmpDocDesc=$p($g(^SSU("SSUSR",+SSUserID)),"^",2)
	..s MRCount=+$g(^CacheTemp("MRStat",$zn,$j,tmpLoc,tmpDoc,"Count"))
	..s MRFirst=+$g(^CacheTemp("MRStat",$zn,$j,tmpLoc,tmpDoc,"First"))
	..s MRSecond=+$g(^CacheTemp("MRStat",$zn,$j,tmpLoc,tmpDoc,"Second"))
	..s MRThird=+$g(^CacheTemp("MRStat",$zn,$j,tmpLoc,tmpDoc,"Third"))
	..s Data=$lb("---","---",tmpDocDesc,MRFirst,MRSecond,MRThird,MRCount,ExamRule,+$p(tmpLoc,"||",1),+$p(tmpLoc,"||",2),tmpDoc,DateFrom,DateTo)
	..s ^CacheTemp(repid,ind)=Data
	..s ind=ind+1
	s Data=$lb("合计","---","---",First,Second,Third,Count,ExamRule,AdmLoc,AdmWard,AdmDoc,DateFrom,DateTo)
	s ^CacheTemp(repid,ind)=Data
	k ^CacheTemp("MRStat",$zn,$j)
	
	Quit $$$OK
}

ClassMethod StatMRQualityFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = StatMRQualityExecute ]
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

/// ****************************************************************
/// 功能说明   : 出院病人病历质量统计
/// 入参       : 
/// ExamRule   : 评估标准
/// Loc        : 就诊科室
/// Ward       : 就诊病区
/// Doc        : 就诊医生
/// DateFrom   : 开始日期
/// DateTo     : 结束日期
/// 备注       : 
/// 程序调试   : d ##Class(%ResultSet).RunQuery("web.DHCWMRQuality.ExExamResult","StatMRQuality",ExamRule,Loc,Ward,Doc,DateFrom,DateTo)
/// ****************************************************************
Query StatMRQuality(ExamRule As %String, AdmLoc As %String, AdmWard As %String, AdmDoc As %String, DateFrom As %String, DateTo As %String) As %Query(ROWSPEC = "LocDesc:%String,WardDesc:%String,DocDesc:%String,MRFirst:%String,MRSecond:%String,MRThird:%String,MRCount:%String,ExamRule:%String,AdmLoc:%String,AdmWard:%String,AdmDoc:%String,DateFrom:%String,DateTo:%String")
{
}

ClassMethod QryMRQualityClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMRQualityExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryMRQualityExecute(ByRef qHandle As %Binary, ExamRule As %String, AdmLoc As %String, AdmWard As %String, AdmDoc As %String, DateFrom As %String, DateTo As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	//s ^ZF(11)=$lb(ExamRule,AdmLoc,AdmWard,AdmDoc,DateFrom,DateTo)
	q:(DateFrom="")||(DateTo="") $$$OK
	s HospCode=##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetHospCode()
	
	k ^CacheTemp("MRQry",$zn,$j)
	f tmpDate=DateFrom:1:DateTo d
	.s Paadm=0
	.f  s Paadm=$o(^PAADMi("DischDate",tmpDate,Paadm)) q:Paadm=""  d
	..s tmpPaadm=$g(^PAADM(+Paadm))
	..q:tmpPaadm=""
	..q:$p(tmpPaadm,"^",75)'=""    //婴儿不建病案
	..q:$p(tmpPaadm,"^",20)'="D"    //就诊状态
	..s tmpLoc=$p(tmpPaadm,"^",4)
	..q:(AdmLoc'="")&&(tmpLoc'=AdmLoc)         //出院科室
	..s tmpWard=$p(tmpPaadm,"^",70)
	..q:(AdmWard'="")&&(tmpWard'=AdmWard)      //出院病区
	..s tmpDoc=$p(tmpPaadm,"^",9)
	..q:(AdmDoc'="")&&(tmpDoc'=AdmDoc)         //主管医生
	..s Score=..getMRScore(ExamRule,Paadm)   //取病案得分
	..s:Score>=90 Grade="甲"
	..s:(Score<90)&&(Score>=70) Grade="乙"
	..s:Score<70 Grade="丙"
	..
	..s Papmi=$p(tmpPaadm,"^",1)
	..s RegNo=$p($g(^PAPER(+Papmi,"PAT",1)),"^",1)
	..s MrNo=$p($g(^PAPER(+Papmi,"PAT",1)),"^",22)
	..s:(HospCode="ChengDu_HX") MrNo=$p(tmpPaadm,"^",81)
	..s PatName=$p($g(^PAPER(+Papmi,"ALL")),"^",1)
	..s Sex=$p($g(^CT("SEX",$p($g(^PAPER(+Papmi,"ALL")),"^",7))),"^",2)
	..s BirthDay=$p($g(^PAPER(+Papmi,"ALL")),"^",6)
	..s:BirthDay'="" BirthDay=$zd(BirthDay,3)
	..s AdmDate=$zd($p(tmpPaadm,"^",6),3)
	..s DischDate=$zd(tmpDate,3)
	..s LocDesc=$p($g(^CTLOC(+tmpLoc)),"^",2)
	..s WardDesc=$p($g(^PAWARD(+tmpWard)),"^",2)  //PAC_Ward
	..s WLocID=$p($g(^PAWARD(+tmpWard)),"^",5)
	..s:WLocID'="" WardDesc=$p($g(^CTLOC(+WLocID)),"^",2)
	..s DocDesc=$p($g(^CTPCP(+tmpDoc)),"^",2)    //CT_CareProv
	..s SSUserID=$o(^SSU("SSUSR",0,"CTPCP",+tmpDoc,0))  //SS_User
	..s:SSUserID'="" DocDesc=$p($g(^SSU("SSUSR",+SSUserID)),"^",2)
	..
	..s Data=$lb(RegNo,MrNo,PatName,Sex,BirthDay,AdmDate,DischDate,LocDesc,WardDesc,DocDesc,Paadm,Papmi,Score,Grade,ExamRule)
	..s ^CacheTemp(repid,ind)=Data
	..s ind=ind+1
	k ^CacheTemp("MRQry",$zn,$j)
	
	Quit $$$OK
}

ClassMethod QryMRQualityFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMRQualityExecute ]
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

/// ****************************************************************
/// 功能说明   : 出院病人病历质量查询
/// 入参       : 
/// ExamRule   : 评估标准
/// AdmLoc     : 就诊科室
/// AdmWard    : 就诊病区
/// AdmDoc     : 就诊医生
/// DateFrom   : 开始日期
/// DateTo     : 结束日期
/// 备注       : 
/// 程序调试   : d ##Class(%ResultSet).RunQuery("web.DHCWMRQuality.ExExamResult","QryMRQuality",ExamRule,Loc,Ward,Doc,DateFrom,DateTo)
/// ****************************************************************
Query QryMRQuality(ExamRule As %String, AdmLoc As %String, AdmWard As %String, AdmDoc As %String, DateFrom As %String, DateTo As %String) As %Query(ROWSPEC = "RegNo:%String,MrNo:%String,PatName:%String,Sex:%String,BirthDay:%String,AdmDate:%String,DischDate:%String,LocDesc:%String,WardDesc:%String,DocDesc:%String,Paadm:%String,Papmi:%String,Score:%String,Grade:%String,ExamRule:%String")
{
}

ClassMethod QryByPaadmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryByPaadmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryByPaadmExecute(ByRef qHandle As %Binary, ExamRule As %String, Paadm As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	//s ^ZF(11)=$lb(ExamRule,Paadm)
	q:Paadm="" $$$OK
	s RstRowid=0
	f  s RstRowid=$o(^DHCWMRERST(0,"PAADM",+Paadm,RstRowid)) q:RstRowid=""  d
	.q:$p($g(^DHCWMRERST(+RstRowid)),"^",13)'="Y"
	.s RDicID=$p($g(^DHCWMRERST(+RstRowid)),"^",2)
	.q:(ExamRule'="")&&(("|"_ExamRule_"|")'[("|"_RDicID_"|"))
	.s RDicDesc=$p($g(^DHCWMRRDIC(+RDicID)),"^",2)
	.s DtlRowid=0
	.f  s DtlRowid=$o(^DHCWMRERST(RstRowid,"D",DtlRowid)) q:DtlRowid=""  d
	..q:$p($g(^DHCWMRERST(+RstRowid,"D",DtlRowid)),"^",7)'="Y"
	..s EiNumber=+$p($g(^DHCWMRERST(+RstRowid,"D",DtlRowid)),"^",2)
	..s EntryID=$p($g(^DHCWMRERST(+RstRowid,"D",DtlRowid)),"^",1)
	..s EntryInfo=$g(^DHCWMRER(+$p(EntryID,"||",1),"S",+$p(EntryID,"||",2),"E",+$p(EntryID,"||",3)))
	..s EDicID=$p(EntryInfo,"^",1)
	..s EDicDesc=$p($g(^DHCWMREDIC(+EDicID)),"^",2)
	..s EScore=$p(EntryInfo,"^",2)      //项目分值
	..s EMultiErr=$p(EntryInfo,"^",5)   //是否允许多次评分
	..s EVeto=$p(EntryInfo,"^",6)       //是否单项否决
	..s SectionInfo=$g(^DHCWMRER(+$p(EntryID,"||",1),"S",+$p(EntryID,"||",2)))
	..s SDicID=$p(SectionInfo,"^",1)
	..s SDicDesc=$p($g(^DHCWMRSDIC(+SDicID)),"^",2)
	..s SScore=$p(SectionInfo,"^",2)    //大类分值
	..s DtlPRowid=0
	..f  s DtlPRowid=$o(^DHCWMRERST(RstRowid,"D",DtlRowid,"P",DtlPRowid)) q:DtlPRowid=""  d
	...q:$p($g(^DHCWMRERST(RstRowid,"D",DtlRowid,"P",DtlPRowid)),"^",4)'="Y"
	...s RstDtlP=$g(^DHCWMRERST(RstRowid,"D",DtlRowid,"P",DtlPRowid))
	...s RLocId=$p(RstDtlP,"^",3)                    //责任科室
	...s RLocDesc=$p($g(^CTLOC(+RLocId)),"^",2)
	...s:RLocDesc["-" RLocDesc=$p(RLocDesc,"-",2)
	...s REmployeeId=$p(RstDtlP,"^",1)               //责任人
	...s REmployeeDesc=$p($g(^SSU("SSUSR",+REmployeeId)),"^",2)
	...s Data=$lb(RDicDesc,SDicDesc,SectionInfo,EDicDesc,EntryInfo,EiNumber,EScore,RLocDesc,REmployeeDesc,EMultiErr,EVeto)
	...s ^CacheTemp(repid,ind)=Data
	...s ind=ind+1
	
	Quit $$$OK
}

ClassMethod QryByPaadmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryByPaadmExecute ]
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

/// ****************************************************************
/// 功能说明   : 病历问题列表(ByPaadm)
/// 入参       : 
/// ExamRule   : 评估标准
/// Paadm      : 就诊号
/// 备注       : 
/// 程序调试   : d ##Class(%ResultSet).RunQuery("web.DHCWMRQuality.ExExamResult","QryByPaadm",ExamRule,Paadm)
/// ****************************************************************
Query QryByPaadm(ExamRule As %String, Paadm As %String) As %Query(ROWSPEC = "RDicDesc:%String,SDicDesc:%String,SectionInfo:%String,EDicDesc:%String,EntryInfo:%String,EiNumber:%String,EScore:%String,RLocDesc:%String,REmployeeDesc:%String,EMultiErr:%String,EVeto:%String")
{
}

ClassMethod StatErrListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = StatErrListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod StatErrListExecute(ByRef qHandle As %Binary, ExamRule As %String, DutyLoc As %String, DutyDoc As %String, DateFrom As %String, DateTo As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	//s ^ZF(11)=$lb(ExamRule,DutyLoc,DutyDoc,DateFrom,DateTo)
	q:(DateFrom="")||(DateTo="") $$$OK
	s HospCode=##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetHospCode()
	
	k ^CacheTemp("StatErr",$zn,$j)
	f tmpDate=DateFrom:1:DateTo d
	.s Paadm=0
	.f  s Paadm=$o(^PAADMi("DischDate",tmpDate,Paadm)) q:Paadm=""  d
	..s tmpPaadm=$g(^PAADM(+Paadm))
	..q:tmpPaadm=""
	..q:$p(tmpPaadm,"^",75)'=""    //婴儿不建病案
	..q:$p(tmpPaadm,"^",20)'="D"    //就诊状态
	..s RstRowid=0
	..f  s RstRowid=$o(^DHCWMRERST(0,"PAADM",Paadm,RstRowid)) q:RstRowid=""  d
	...q:$p($g(^DHCWMRERST(+RstRowid)),"^",13)'="Y"
	...s RDicID=$p($g(^DHCWMRERST(+RstRowid)),"^",2)
	...q:(ExamRule'="")&&(("|"_ExamRule_"|")'[("|"_RDicID_"|"))
	...s DtlRowid=0
	...f  s DtlRowid=$o(^DHCWMRERST(RstRowid,"D",DtlRowid)) q:DtlRowid=""  d
	....q:$p($g(^DHCWMRERST(+RstRowid,"D",DtlRowid)),"^",7)'="Y"
	....s DtlPRowid=0
	....f  s DtlPRowid=$o(^DHCWMRERST(RstRowid,"D",DtlRowid,"P",DtlPRowid)) q:DtlPRowid=""  d
	.....s DtlPInfo=$g(^DHCWMRERST(+RstRowid,"D",DtlRowid,"P",DtlPRowid))
	.....s tmpLoc=$p(DtlPInfo,"^",3)
	.....q:(DutyLoc'="")&&(tmpLoc'=DutyLoc)
	.....s tmpDoc=$p(DtlPInfo,"^",1)
	.....q:(DutyDoc'="")&&(tmpDoc'=DutyDoc)
	.....//没写完 20090816 ZF
	k ^CacheTemp("StatErr",$zn,$j)
	
	Quit $$$OK
}

ClassMethod StatErrListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = StatErrListExecute ]
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

/// ****************************************************************
/// 功能说明   : 统计病历问题列表
/// 入参       : 
/// ExamRule   : 评估标准
/// DutyLoc    : 责任科室
/// DutyDoc    : 责任医生
/// DateFrom   : 开始日期
/// DateTo     : 结束日期
/// 备注       : 
/// 程序调试   : d ##Class(%ResultSet).RunQuery("web.DHCWMRQuality.ExExamResult","StatErrList",ExamRule,DutyLoc,DutyDoc,DateFrom,DateTo)
/// ****************************************************************
Query StatErrList(ExamRule As %String, DutyLoc As %String, DutyDoc As %String, DateFrom As %String, DateTo As %String) As %Query(ROWSPEC = "RDicDesc:%String,SDicDesc:%String,SectionInfo:%String,EDicDesc:%String,EntryInfo:%String,EiNumber:%String,EScore:%String,RLocDesc:%String,REmployeeDesc:%String,EMultiErr:%String,EVeto:%String")
{
}

ClassMethod QryErrListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryErrListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryErrListExecute(ByRef qHandle As %Binary, ExamRule As %String, DutyLoc As %String, DutyDoc As %String, DateFrom As %String, DateTo As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	//没写完 20090816 ZF
	
	Quit $$$OK
}

ClassMethod QryErrListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryErrListExecute ]
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

/// ****************************************************************
/// 功能说明   : 查询病历问题列表
/// 入参       : 
/// ExamRule   : 评估标准
/// DutyLoc    : 责任科室
/// DutyDoc    : 责任医生
/// DateFrom   : 开始日期
/// DateTo     : 结束日期
/// 备注       : 
/// 程序调试   : d ##Class(%ResultSet).RunQuery("web.DHCWMRQuality.ExExamResult","QryErrList",ExamRule,DutyLoc,DutyDoc,DateFrom,DateTo)
/// ****************************************************************
Query QryErrList(ExamRule As %String, DutyLoc As %String, DutyDoc As %String, DateFrom As %String, DateTo As %String) As %Query(ROWSPEC = "RDicDesc:%String,SDicDesc:%String,SectionInfo:%String,EDicDesc:%String,EntryInfo:%String,EiNumber:%String,EScore:%String,RLocDesc:%String,REmployeeDesc:%String,EMultiErr:%String,EVeto:%String")
{
}

}
