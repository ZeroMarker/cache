Import SQLUser

/// 质控结果查询
Class web.DHCWMRExamRstQry Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 129;

ClassMethod GetVolByDischDate(JIndex, MrType, FromDate, ToDate, Ctloc)
{
	n (JIndex, MrType, FromDate, ToDate,Ctloc)
	s:JIndex="" JIndex=$j
	s iNum=0
	;s ^Wuqk(0)=FromDate
	s:FromDate["-" FromDate=$zdh(FromDate,3)
	s:ToDate["-" ToDate=$zdh(ToDate,3)
	s:FromDate["/" FromDate=$zdh(FromDate,4)
	s:ToDate["/" ToDate=$zdh(ToDate,4)
	k ^CacheTemp("WMRExamVol",JIndex)
	;w !,"PAAdm..."
	
	;^PAADMi("DischDate",Date)
	s Date=FromDate-1
	f  s Date=$o(^PAADMi("DischDate",Date)) q:(Date="")!(Date>ToDate)  d
	.s ADMId=""
	.f  s ADMId=$o(^PAADMi("DischDate",Date,ADMId)) q:ADMId=""  d
	..s AdmCtloc=+$p($g(^PAADM(ADMId)),"^",4)
	..q:(Ctloc'="")&(Ctloc'=AdmCtloc)
	..q:'$d(^DHCWMRVOL(0,"VolAdm",ADMId))
	..s VolId=$o(^DHCWMRVOL(0,"VolAdm",ADMId,""),-1)
	..s VolumeInfo=##class(web.DHCWMRVolumeCtl).GetVolume(VolId)
	..s VolActiveFlg=$p(VolumeInfo,"^",8)
	..q:VolActiveFlg'="Y"     //病案卷无效退出
	..s MainId=$p(VolumeInfo,"^",2)
	..s MainInfo=##class(web.DHCWMRMainCtl).GetMainById(MainId)  
	..s MainType=$p(MainInfo,"^",2)          //病案类型
	..s MainActiveFlg=$p(MainInfo,"^",7)
	..q:MainActiveFlg'="Y"     //病案无效退出
	..q:MainType'=MrType    //病案类型不符,退出
	..s iNum=iNum+1
	..s ^CacheTemp("WMRExamVol",JIndex,VolId)=""
	
	;w !,"HisAdm..."
	;DHCWMRHISADM(0,"DisDate",{DischargeDate},{Rowid})
	s Date=FromDate-1
	f  s Date=$o(^DHCWMRHISADM(0,"DisDate",Date)) q:(Date="")!(Date>ToDate)  d
	.s HisAdmId=""
	.f  s HisAdmId=$o(^DHCWMRHISADM(0,"DisDate",Date,HisAdmId)) q:(HisAdmId="")  d
	..;^DHCWMRVOL(0,"HistoryAdm",{HistroyAdm_Dr},{Rowid})
	..s VolId=$o(^DHCWMRVOL(0,"HistoryAdm",HisAdmId,""),-1)
	..;w !,"VolId="_VolId
	..s VolumeInfo=##class(web.DHCWMRVolumeCtl).GetVolume(VolId)
	..s VolActiveFlg=$p(VolumeInfo,"^",8)
	..q:VolActiveFlg'="Y"     //病案卷无效退出
	..s MainId=$p(VolumeInfo,"^",2)
	..s MainInfo=##class(web.DHCWMRMainCtl).GetMainById(MainId)  
	..s MainType=$p(MainInfo,"^",2)          //病案类型
	..s MainActiveFlg=$p(MainInfo,"^",7)
	..q:MainActiveFlg'="Y"     //病案无效退出
	..q:MainType'=MrType    //病案类型不符,退出
	..s iNum=iNum+1
	..s ^CacheTemp("WMRExamVol",JIndex,VolId)=""
	q iNum
}

ClassMethod GetVolByAdmDate(JIndex, MrType, FromDate, ToDate, Ctloc)
{
	n (JIndex, MrType, FromDate, ToDate,Ctloc)
	s:JIndex="" JIndex=$j
	s iNum=0
	;s ^Wuqk(0)=FromDate
	s:FromDate["-" FromDate=$zdh(FromDate,3)
	s:ToDate["-" ToDate=$zdh(ToDate,3)
	s:FromDate["/" FromDate=$zdh(FromDate,4)
	s:ToDate["/" ToDate=$zdh(ToDate,4)
	k ^CacheTemp("WMRExamVol",JIndex)
	;w !,"PAAdm..."
	
	;^PAADMi("PAADM_AdmDate",Date)
	s Date=FromDate-1
	f  s Date=$o(^PAADMi("PAADM_AdmDate",Date)) q:(Date="")!(Date>ToDate)  d
	.s ADMId=""
	.f  s ADMId=$o(^PAADMi("PAADM_AdmDate",Date,ADMId)) q:ADMId=""  d
	..s AdmCtloc=+$p($g(^PAADM(ADMId)),"^",4)
	..q:(Ctloc'="")&(Ctloc'=AdmCtloc)
	..q:'$d(^DHCWMRVOL(0,"VolAdm",ADMId))
	..s VolId=$o(^DHCWMRVOL(0,"VolAdm",ADMId,""),-1)
	..s VolumeInfo=##class(web.DHCWMRVolumeCtl).GetVolume(VolId)
	..s VolActiveFlg=$p(VolumeInfo,"^",8)
	..q:VolActiveFlg'="Y"     //病案卷无效退出
	..s MainId=$p(VolumeInfo,"^",2)
	..s MainInfo=##class(web.DHCWMRMainCtl).GetMainById(MainId)  
	..s MainType=$p(MainInfo,"^",2)          //病案类型
	..s MainActiveFlg=$p(MainInfo,"^",7)
	..q:MainActiveFlg'="Y"     //病案无效退出
	..q:MainType'=MrType    //病案类型不符,退出
	..s iNum=iNum+1
	..s ^CacheTemp("WMRExamVol",JIndex,VolId)=""
	
	;w !,"HisAdm..."
	;^DHCWMRHISADM(0,"ADMDate",{AdmitDate},{Rowid})
	s Date=FromDate-1
	f  s Date=$o(^DHCWMRHISADM(0,"ADMDate",Date)) q:(Date="")!(Date>ToDate)  d
	.s HisAdmId=""
	.f  s HisAdmId=$o(^DHCWMRHISADM(0,"ADMDate",Date,HisAdmId)) q:(HisAdmId="")  d
	..;^DHCWMRVOL(0,"HistoryAdm",{HistroyAdm_Dr},{Rowid})
	..s VolId=$o(^DHCWMRVOL(0,"HistoryAdm",HisAdmId,""),-1)
	..;w !,"VolId="_VolId
	..s VolumeInfo=##class(web.DHCWMRVolumeCtl).GetVolume(VolId)
	..s VolActiveFlg=$p(VolumeInfo,"^",8)
	..q:VolActiveFlg'="Y"     //病案卷无效退出
	..s MainId=$p(VolumeInfo,"^",2)
	..s MainInfo=##class(web.DHCWMRMainCtl).GetMainById(MainId)  
	..s MainType=$p(MainInfo,"^",2)          //病案类型
	..s MainActiveFlg=$p(MainInfo,"^",7)
	..q:MainActiveFlg'="Y"     //病案无效退出
	..q:MainType'=MrType    //病案类型不符,退出
	..s iNum=iNum+1
	..s ^CacheTemp("WMRExamVol",JIndex,VolId)=""
	q iNum
}

ClassMethod GetVolByCheckDate(JIndex, MrType, FromDate, ToDate, Ctloc)
{
	n (JIndex, MrType, FromDate, ToDate,Ctloc)
	s:JIndex="" JIndex=$j
	s iNum=0
	;s ^Wuqk(0)=FromDate
	s:FromDate["-" FromDate=$zdh(FromDate,3)
	s:ToDate["-" ToDate=$zdh(ToDate,3)
	s:FromDate["/" FromDate=$zdh(FromDate,4)
	s:ToDate["/" ToDate=$zdh(ToDate,4)
	k ^CacheTemp("WMRExamVol",JIndex)
	;w !,"PAAdm..."
	
	;^DHCWMRERST(0,"RuleDate",{ExamRuleDr},{ExamDate},{Rowid})
	s ERRowid=0
	f  s ERRowid=$o(^DHCWMRERST(0,"RuleDate",ERRowid)) q:ERRowid=""  d
	.s Date=FromDate-1
	.f  s Date=$o(^DHCWMRERST(0,"RuleDate",ERRowid,Date)) q:(Date="")!(Date>ToDate)  d
	..s ERstRowid=0
	..f  s ERstRowid=$o(^DHCWMRERST(0,"RuleDate",ERRowid,Date,ERstRowid)) q:ERstRowid=""  d
	...s tmpERst=$g(^DHCWMRERST(ERstRowid))
	...q:tmpERst=""
	...s VolId=$p(tmpERst,"^",1)
	...q:(+VolId)=0
	...s ADMId=$p($g(^DHCWMRVOL(+VolId)),"^",2)
	...s:ADMId'="" AdmCtloc=+$p($g(^PAADM(+ADMId)),"^",4)
	...q:(ADMId'="")&(Ctloc'="")&(Ctloc'=AdmCtloc)
	...s VolumeInfo=##class(web.DHCWMRVolumeCtl).GetVolume(VolId)
	...s VolActiveFlg=$p(VolumeInfo,"^",8)
	...q:VolActiveFlg'="Y"     //病案卷无效退出
	...s MainId=$p(VolumeInfo,"^",2)
	...s MainInfo=##class(web.DHCWMRMainCtl).GetMainById(MainId)  
	...s MainType=$p(MainInfo,"^",2)          //病案类型
	...s MainActiveFlg=$p(MainInfo,"^",7)
	...q:MainActiveFlg'="Y"     //病案无效退出
	...q:MainType'=MrType    //病案类型不符,退出
	...s iNum=iNum+1
	...s ^CacheTemp("WMRExamVol",JIndex,VolId)=""
	
	q iNum
}

ClassMethod GetExamRstByVol(JIndex, ExamRuleDr)
{
	n (JIndex,ExamRuleDr)
	s iNum=0
	q:'$d(^CacheTemp("WMRExamVol",JIndex)) iNum
	k ^CacheTemp("WMRExamRst",JIndex)
	s VolId=""
    f  s VolId=$o(^CacheTemp("WMRExamVol",JIndex,VolId)) q:VolId=""  d
    .;w !,VolId
    .q:'$d(^DHCWMRERST(0,"RuleVol",ExamRuleDr,VolId))
    .;w "--1"
    .s ExamRstRowid=""
    .f  s ExamRstRowid=$o(^DHCWMRERST(0,"RuleVol",ExamRuleDr,VolId,ExamRstRowid)) q:ExamRstRowid=""  d
    ..s ^CacheTemp("WMRExamRst",JIndex,ExamRstRowid)=""
    ..s iNum=iNum+1
	q JIndex
}

ClassMethod BuildData1(ExamRstRowid)
{
	n (ExamRstRowid)
	
	s TmpStr=##class(web.DHCWMRExamResultCtl).ByIdGetExamResult(ExamRstRowid)
	;retString_$c(2)_Volume_$c(2)_ExamRule_$c(2)_$g(tmpRuleDic)_$c(2)_ExamGarde_$c(2)_SSUser
	s sExamRst=$p(TmpStr,$c(2),1)
	s sVolume=$p(TmpStr,$c(2),2)
	s sExamRule=$p(TmpStr,$c(2),3)
	s sExamGarde=$p(TmpStr,$c(2),5)
	
	s sSignUser=$p(TmpStr,$c(2),6)
	s VolRowid=+sVolume
	s MainRowid=$p(sVolume,"^",2)
	s sVolAdmInfo=##class(web.DHCWMRBaseInfoCtl).GetAdmInfoByVol(VolRowid)
    s sBaseInfo=##class(web.DHCWMRBaseInfoCtl).GetBaseInfoByMain(MainRowid)
    s sMain=##class(web.DHCWMRMainCtl).GetMainById(MainRowid)
	s Data=$lb("")
	
	Set $li(Data,1)=$p(sMain,"^",3)             ;MrNo
	Set $li(Data,2)=$p(sBaseInfo,"^",27)        ;PatNo
	Set $li(Data,3)=$p(sBaseInfo,"^",2)         ;Name
	Set $li(Data,4)=$p(sVolAdmInfo,"^",5)       ;Ctloc
	Set $li(Data,5)=$p(sVolAdmInfo,"^",3)       ;AdmDate
	Set $li(Data,6)=$p(sVolAdmInfo,"^",7)       ;DischDate
	Set $li(Data,7)=$p(sExamGarde,"^",2)        ;Grade
	Set $li(Data,8)=$p(sExamRst,"^",5)          ;Score
	Set $li(Data,9)=$p(sExamRst,"^",10)         ;Money
	Set $li(Data,10)=$p(sExamRst,"^",12)        ;ExamDate
	Set $li(Data,11)=$p(sExamRst,"^",1)         ;ExamRstRowid
	Set $li(Data,12)=MainRowid                  ;MainRowid
	Set $li(Data,13)=$p(sExamRst,"^",6)         ;ActualScore 	Add by liuxf 2008-09-22
	q Data
}

ClassMethod QueryRstClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryRstExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryRstExecute(ByRef qHandle As %Binary, RuleDicRowid As %String, ExamRuleRowid As %String, MrType As %String, DateType As %String, FromDate As %String, ToDate As %String, Ctloc As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	s JIndex=$j
	;RuleDicRowid
	q:ExamRuleRowid="" $$$OK
    q:MrType="" $$$OK
    q:DateType="" $$$OK
    q:FromDate="" $$$OK
    q:ToDate="" $$$OK
    ;Ctloc
    
    i DateType=1 d
    .s AdmNum=..GetVolByAdmDate(JIndex, MrType, FromDate, ToDate, Ctloc)
    .s RstNum=..GetExamRstByVol(JIndex, ExamRuleRowid)
    i DateType=2 d
    .s AdmNum=..GetVolByDischDate(JIndex, MrType, FromDate, ToDate, Ctloc)
    .s RstNum=..GetExamRstByVol(JIndex, ExamRuleRowid)
    i DateType=3 d
    .s AdmNum=..GetVolByCheckDate(JIndex, MrType, FromDate, ToDate, Ctloc)
    .s RstNum=..GetExamRstByVol(JIndex, ExamRuleRowid)
    
    q:'$d(^CacheTemp("WMRExamRst",JIndex)) $$$OK
    s ExamRstRowid=""
	f  s ExamRstRowid=$o(^CacheTemp("WMRExamRst",JIndex,ExamRstRowid)) q:ExamRstRowid=""  d
	.s data=..BuildData1(ExamRstRowid)
	.s ^CacheTemp(repid,ind)=data
 	.s ind=ind+1
 	
 	k ^CacheTemp("WMRExamVol",JIndex)
	k ^CacheTemp("WMRExamRst",JIndex)
	Quit $$$OK
}

ClassMethod QueryRstFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryRstExecute ]
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

/*****************************************
/参数说明：
/;RuleDicRowid   ---  DHC_WMR_RuleDic.Rowid  可空
/;ExamRuleRowid  ---  DHC_WMR_ExamRule.Rowid 目前不可空,可考虑扩展
/;MrType         ---  病案类型               不可空
/;DateType       ---  查询日期类型 1:入院日期; 2:出院日期; 3:检查日期
/;FromDate       ---  开始日期
/;ToDate         ---  结束日期
/;Ctloc          ---  科室                    可空
///Modify by liuxf 2008-09-22 增加查询后输出列：ActualScore(累计分数)
******************************************/
Query QueryRst(RuleDicRowid As %String, ExamRuleRowid As %String, MrType As %String, DateType As %String, FromDate As %String, ToDate As %String, Ctloc As %String) As %Query(ROWSPEC = "MrNo:%String,PatNo:%String,Name:%String,Ctloc:%String,AdmDate:%String,DischDate:%String,Grade:%String,Score:%String,Money:%String,ExamDate:%String,ExamRstRowid:%String,MainRowid:%String,ActualScore:%String")
{
}

ClassMethod Builddtl(dtlString)
{
	n (dtlString)
	
	;retString_$c(2)_ExamEntry_$c(2)_$g(tmpEntryDic)_$c(2)_$g(tmpExamEntry)_$c(2)_$g(tmpDic)
	s sDtl=$p(dtlString,$c(2),1)
	s sExamEntry=$p(dtlString,$c(2),2)
	s sEntryDic=$p(dtlString,$c(2),3)
	s sPExamEntry=$p(dtlString,$c(2),4)
	s sPEntryDic=$p(dtlString,$c(2),5)
	s sDic=""
	s EntryTypeRowid=$p(sEntryDic,"^",4)
	s:EntryTypeRowid'="" sDic=##class(web.DHCWMRDictionaryCtl).GetDataById(EntryTypeRowid)
	
	s sErrType=""
	s Errtype=$p(sDtl,"^",7)
	s:Errtype'="" sErrType=##class(web.DHCWMRDictionaryCtl).GetDataById(Errtype)
	
	s Data=$lb("")
	;,,,,,,,,,,,,
	Set $li(Data,1)=$p(sDtl,"^",1)            ;dtlRowid
	Set $li(Data,2)=$p(sExamEntry,"^",1)      ;ExamEntryRowid
	Set $li(Data,3)=$p(sEntryDic,"^",1)       ;EntryRowid
	Set $li(Data,4)=$p(sEntryDic,"^",3)       ;EntryDesc
	Set $li(Data,5)=$p(sEntryDic,"^",4)       ;EntryTypeRowid
	Set $li(Data,6)=$p(sDic,"^",4)            ;EntryType
	Set $li(Data,7)=$p(sDtl,"^",3)            ;iNum
	Set $li(Data,8)=$p(sDtl,"^",4)            ;Score
	Set $li(Data,9)=$p(sDtl,"^",5)            ;Money
	Set $li(Data,10)=$p(sDtl,"^",6)           ;TriggerDate
	Set $li(Data,11)=$p(sErrType,"^",4)           ;ErrType
	Set $li(Data,12)=$p(sDtl,"^",8)           ;Active
	Set $li(Data,13)=$p(sDtl,"^",9)           ;ResumeText
	q Data
}

ClassMethod QueryRstDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryRstDtlExecute ]
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

ClassMethod QueryRstDtlExecute(ByRef qHandle As %Binary, ExamRstRowid As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	q:ExamRstRowid="" $$$OK
	q:'$d(^DHCWMRERST(ExamRstRowid,"D")) $$$OK
	
	;^DHCWMRERST({DHC_WMR_ExamResult.Rowid},"D",{ChildSub})
	s dtlSub=0
    f  s dtlSub=$o(^DHCWMRERST(ExamRstRowid,"D",dtlSub)) q:dtlSub=""  d
    .s dtlRowid=ExamRstRowid_"||"_dtlSub
    .s dtlString=##class(web.DHCWMRExamResultCtl).ByIdGetExamRDtl(dtlRowid)
    .s data=..Builddtl(dtlString)
	.s ^CacheTemp(repid,ind)=data
 	.s ind=ind+1
    
	Quit $$$OK
}

ClassMethod QueryRstDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryRstDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/*****************************************
/参数说明：
ExamRstRowid   ---  DHC_WMR_ExamResult.Rowid
******************************************/
Query QueryRstDtl(ExamRstRowid As %String) As %Query(ROWSPEC = "dtlRowid:%String,ExamEntryRowid:%String,EntryRowid:%String,EntryDesc:%String,EntryTypeRowid:%String,EntryType:%String,iNum:%String,Score:%String,Money:%String,TriggerDate:%String,ErrType:%String,Active:%String,ResumeText:%String")
{
}

ClassMethod Builddtlp(dtlpString)
{
	n (dtlpString)
	;retString_$c(2)_SSUser_$c(2)_Dic_$c(2)_Loc
	s sDtlP=$p(dtlpString,$c(2),1)
	s sUser=$p(dtlpString,$c(2),2)
	s sDic=$p(dtlpString,$c(2),3)
	s sLoc=$p(dtlpString,$c(2),4)
	
	s Data=$lb("")
	;,,,,,,,PActive,PResume
	Set $li(Data,1)=$p(sDtlP,"^",1)            ;dtlpRowid
	Set $li(Data,2)=$p(sUser,"^",1)      ;usr
	Set $li(Data,3)=$p(sUser,"^",3)       ;usrName
	Set $li(Data,4)=$p(sDic,"^",1)       ;RSbilityDr
	Set $li(Data,5)=$p(sDic,"^",4)       ;RSbilityDresc
	Set $li(Data,6)=$p(sLoc,"^",1)            ;ctloc
	Set $li(Data,7)=$p(sLoc,"^",2)            ;ctlocDesc
	Set $li(Data,8)=$p(sDtlP,"^",5)          ;Active
	Set $li(Data,9)=$p(sDtlP,"^",6)          ;ResumeText
	q Data
}

ClassMethod QueryDtlPClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryDtlPExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryDtlPExecute(ByRef qHandle As %Binary, dtlRowid As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	q:dtlRowid="" $$$OK
	s ExamRstRowid=+dtlRowid
	s dtlSub=$p(dtlRowid,"||",2)
	q:'$d(^DHCWMRERST(ExamRstRowid,"D",dtlSub,"P")) $$$OK
	
	s pSub=0
    f  s pSub=$o(^DHCWMRERST(ExamRstRowid,"D",dtlSub,"P",pSub)) q:pSub=""  d
    .s dtlpRowid=dtlRowid_"||"_pSub
    .s dtlpString=##class(web.DHCWMRExamResultCtl).ByIdGetExamRDtlP(dtlpRowid)
    .s data=..Builddtlp(dtlpString)
	.s ^CacheTemp(repid,ind)=data
 	.s ind=ind+1
    
	Quit $$$OK
}

ClassMethod QueryDtlPFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryDtlPExecute ]
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

ClassMethod QueryResultByVolumeIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryResultByVolumeIDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryResultByVolumeIDExecute(ByRef qHandle As %Binary, RuleID As %String, VolumeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	quit:VolumeID="" $$$OK
	set tmpRuleID = ""
	while 1
	{
		set tmpRuleID = $o(^DHCWMRERST(0, "RuleVol", tmpRuleID))
		quit:tmpRuleID=""
		set ResultID = ""
		while 1
		{
			set ResultID = $o(^DHCWMRERST(0, "RuleVol", tmpRuleID, VolumeID, ResultID))
			quit:ResultID=""
			continue:(tmpRuleID'=RuleID)&(RuleID'="")
			set ^CacheTemp(repid, ind) = $$BuildQueryResultByVolume(ResultID)
			set ind = ind + 1
		}
	}
	Quit $$$OK
BuildQueryResultByVolume(ExamRstRowid)
	n (ExamRstRowid)
	
	s TmpStr=##class(web.DHCWMRExamResultCtl).ByIdGetExamResult(ExamRstRowid)
	;retString_$c(2)_Volume_$c(2)_ExamRule_$c(2)_$g(tmpRuleDic)_$c(2)_ExamGarde_$c(2)_SSUser
	s sExamRst=$p(TmpStr,$c(2),1)
	s sVolume=$p(TmpStr,$c(2),2)
	s sExamRule=$p(TmpStr,$c(2),3)
	s sExamGarde=$p(TmpStr,$c(2),5)
	
	s sSignUser=$p(TmpStr,$c(2),6)
	s VolRowid=+sVolume
	s MainRowid=$p(sVolume,"^",2)
	s sVolAdmInfo=##class(web.DHCWMRBaseInfoCtl).GetAdmInfoByVol(VolRowid)
    s sBaseInfo=##class(web.DHCWMRBaseInfoCtl).GetBaseInfoByMain(MainRowid)
    s sMain=##class(web.DHCWMRMainCtl).GetMainById(MainRowid)
	s Data=$lb("")
	
	Set $li(Data,1)=$p(sMain,"^",3)             ;MrNo
	Set $li(Data,2)=$p(sBaseInfo,"^",27)        ;PatNo
	Set $li(Data,3)=$p(sBaseInfo,"^",2)         ;Name
	Set $li(Data,4)=$p(sVolAdmInfo,"^",5)       ;Ctloc
	Set $li(Data,5)=$p(sVolAdmInfo,"^",3)       ;AdmDate
	Set $li(Data,6)=$p(sVolAdmInfo,"^",7)       ;DischDate
	Set $li(Data,7)=$p(sExamGarde,"^",2)        ;Grade
	Set $li(Data,8)=$p(sExamRst,"^",5)          ;Score
	Set $li(Data,9)=$p(sExamRst,"^",10)         ;Money
	Set $li(Data,10)=$p(sExamRst,"^",12)        ;ExamDate
	Set $li(Data,11)=$p(sExamRst,"^",1)         ;ExamRstRowid
	Set $li(Data,12)=MainRowid                  ;MainRowid
	Set $li(Data,13)=$p(sExamRst,"^",6)         ;ActualScore 	Add by liuxf 2008-09-22
	Set $li(Data,14)=$p(sExamRule,"^",10)        ;ExamRuleName
	Set:$p(sExamRst,"^",7)="Yes" $li(Data,15) = "1" //Primary Result
	Set:$p(sExamRst,"^",7)'="Yes" $li(Data,15) = "0" //Primary Result
	//w !,sExamRst
	q Data
}

Query QueryDtlP(dtlRowid As %String) As %Query(ROWSPEC = "dtlpRowid:%String,usr:%String,usrName:%String,RSbilityDr:%String,RSbilityDresc:%String,ctloc:%String,ctlocDesc:%String,PActive:%String,PResume:%String")
{
}

/*****************************************
/参数说明：
ExamRstRowid   ---  DHC_WMR_ExamRDtl.Rowid
******************************************/
ClassMethod QueryResultByVolumeIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryResultByVolumeIDExecute ]
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

/// 通过检查的标准、病案卷ID查找检查结果列表
Query QueryResultByVolumeID(RuleID As %String, VolumeID As %String) As %Query(ROWSPEC = "MrNo:%String,PatNo:%String,Name:%String,Ctloc:%String,AdmDate:%String,DischDate:%String,Grade:%String,Score:%String,Money:%String,ExamDate:%String,ExamRstRowid:%String,MainRowid:%String,ActualScore:%String,RuleName:%String,IsPrimary:%String")
{
}

}
