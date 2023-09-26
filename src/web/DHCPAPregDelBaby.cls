Import SQLUser

Include Nur.DateFormat

Class web.DHCPAPregDelBaby Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

Query RuptureMode() As %Query(ROWSPEC = "ord,typ")
{
}

ClassMethod RuptureModeExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    s typ="自然",ord="Y"
    d output
    s typ="人工",ord="N"
    d output
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
   
output
    set Data=$lb(ord,typ)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod RuptureModeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = RuptureModeExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
	//
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

ClassMethod RuptureModeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = RuptureModeExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod UpdateBaby(Rowid As %String, arg As %String)
{
	q:Rowid="" 1
	k PLIST
	&sql(select * into PLIST() from DHC_PA_PregDelBaby where BABY_RowID=:Rowid)
	s PLIST(6)=$P(arg,"^",1)         ;BABY_MembraneRuptureMode
	s PLIST(7)=$P(arg,"^",2)         ; BABY_CordWeekNum
	s PLIST(8)=$P(arg,"^",3)         ; BABY_CordRoundNeckLoose
	s PLIST(11)=$P(arg,"^",4)        ; BABY_CordDrug
	s PLIST(10)=$P(arg,"^",5)        ; BABY_AnomalCompl
	s PLIST(9)=$P(arg,"^",6)         ;BABY_CaputDetail
	;i (PLIST(5)="")!(PLIST(5)="L") s PLIST(5)="D"
    &SQL(update DHC_PA_PregDelBaby Values PLIST() where  BABY_RowID=:Rowid)
	q SQLCODE
}

ClassMethod getBabydata(babyID) As %String
{
    q:babyID="" ""
    s pregDr=$p(babyID,"||",1)
    s delSub=$p(babyID,"||",2)
    s babySub=$p(babyID,"||",3)
    q:('$d(^PAPRG(pregDr,"DEL",delSub,"BABY",babySub,"DHC"))) ""
    s babyInfo=$g(^PAPRG(pregDr,"DEL",delSub,"BABY",babySub,"DHC"))
    i babyInfo'="" d
    .s RuptureMode=$p(babyInfo,"^",2)
    .s CordWeekNum=$p(babyInfo,"^",3)
    .s CordLooseCode=$p(babyInfo,"^",4)
    .s CordDrug=$p(babyInfo,"^",7)
    .s AnomalCompl=$p(babyInfo,"^",6)
    .s CaputDetail=$p(babyInfo,"^",5)
    .s rtl=$g(RuptureMode)_"^"_$g(CordWeekNum)_"^"_$g(CordLooseCode)_"^"_$g(CordDrug)_"^"_AnomalCompl_"^"_CaputDetail
    e  s rt1=""
	q rtl
}

Query CordRoundNeck() As %Query(ROWSPEC = "ord,typ")
{
}

ClassMethod CordRoundNeckExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    s typ="",ord=""
    d output
    s typ="松",ord="Y"
    d output
    s typ="紧",ord="N"
    d output
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
   
output
    set Data=$lb(ord,typ)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod CordRoundNeckFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CordRoundNeckExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
	//
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

ClassMethod CordRoundNeckClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CordRoundNeckExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Creator: wangxinlei
/// CreatDate: 2010-02-06
/// Description: 取婴儿听边筛查结果
/// Table：PA_PregDelBaby,DHC_PA_PregDelBaby
/// Input：EpisodeID: 婴儿就诊ID,BabyID: 婴儿信息表ID
/// Return：ScreenDate_"^"_ScreenTime_"^"_BinauralFlag_"^"_LeftEarFlag_"^"_RightEarFlag
/// 			筛查日期^筛查时间^双耳通过^左耳通过^右耳通过
ClassMethod GetBabySreen(EpisodeID As %String, BabyID As %String)
{
	//w ##class(web.DHCPAPregDelBaby).GetBabySreen("","387||2||4")
	q:(EpisodeID="")&(BabyID="") ""
	i EpisodeID'="",BabyID="" d
	.s papmiId=+$g(^PAADM(+EpisodeID))
    .q:papmiId=0  
    .s PREGRowId=$o(^PAPRGi("BABY_Person_DR",papmiId,""),-1)
    .s DELChildsub=$o(^PAPRGi("BABY_Person_DR",papmiId,PREGRowId,"DEL",""),-1)
	.s BABYChildsub=$o(^PAPRGi("BABY_Person_DR",papmiId,PREGRowId,"DEL",DELChildsub,"BABY",""),-1)
	.s BabyID=PREGRowId_"||"_DELChildsub_"||"_BABYChildsub
	q:BabyID="" ""
	s PREGRowId=$p(BabyID,"||",1)
	s DELChildsub=$p(BabyID,"||",2)
	s BABYChildsub=$p(BabyID,"||",3)
	q:(PREGRowId="")!(DELChildsub="")!(BABYChildsub="") ""
	s ScreenDate=$p($g(^PAPRG(PREGRowId,"DEL",DELChildsub,"BABY",BABYChildsub,"DHC")),"^",10)
	i ScreenDate'="" s ScreenDate=$$$zd(ScreenDate,4)
	s ScreenTime=$p($g(^PAPRG(PREGRowId,"DEL",DELChildsub,"BABY",BABYChildsub,"DHC")),"^",11)
	i ScreenTime'="" s ScreenTime=$zt(ScreenTime,2)
	s BinauralFlag=$p($g(^PAPRG(PREGRowId,"DEL",DELChildsub,"BABY",BABYChildsub,"DHC")),"^",12)
	s LeftEarFlag=$p($g(^PAPRG(PREGRowId,"DEL",DELChildsub,"BABY",BABYChildsub,"DHC")),"^",13)
	s RightEarFlag=$p($g(^PAPRG(PREGRowId,"DEL",DELChildsub,"BABY",BABYChildsub,"DHC")),"^",14)
	q ScreenDate_"^"_ScreenTime_"^"_BinauralFlag_"^"_LeftEarFlag_"^"_RightEarFlag
}

/// Creator: wangxinlei
/// CreatDate: 2010-02-06
/// Description: 保存婴儿听边筛查结果
/// Table：PA_PregDelBaby,DHC_PA_PregDelBaby
/// Input：EpisodeID: 婴儿就诊ID,BabyID: 婴儿信息表ID,
/// 		   Para: 筛查日期^筛查时间^双耳通过^左耳通过^右耳通过
/// Return：成功返回0,否则返回非0
ClassMethod SaveBabySreen(EpisodeID As %String, BabyID As %String, Para As %String)
{
	//w ##class(web.DHCPAPregDelBaby).SaveBabySreen("221","2||2||2","2017-04-24^17:20:35^Y^Y^Y")
	q:(EpisodeID="")&(BabyID="") "无婴儿就诊信息!"
	;s ^scv1("tlsc")=EpisodeID _","_ BabyID_","_Para 
	i EpisodeID'="",BabyID="" d
	.s papmiId=+$g(^PAADM(+EpisodeID))
    .q:papmiId=0  
    .s PREGRowId=$o(^PAPRGi("BABY_Person_DR",papmiId,""),-1)
    .s DELChildsub=$o(^PAPRGi("BABY_Person_DR",papmiId,PREGRowId,"DEL",""),-1)
	.s BABYChildsub=$o(^PAPRGi("BABY_Person_DR",papmiId,PREGRowId,"DEL",DELChildsub,"BABY",""),-1)
	.s BabyID=PREGRowId_"||"_DELChildsub_"||"_BABYChildsub
	q:BabyID="" "无婴儿就诊信息!"
	
	s ScreenDate=$p(Para,"^",1)
	s ScreenDate=$$$zdh(ScreenDate,4)
	i ScreenDate>+$h q "不能大于当前日期!"
	s ScreenTime=$p(Para,"^",2)
	i ScreenTime[":" s ScreenTime=$zth(ScreenTime,2)
	i ((ScreenTime>$p($h,",",2))&(ScreenDate=+$h)) q "不能大于当前时间!"
	s BinauralFlag=$p(Para,"^",3)
	s LeftEarFlag=$p(Para,"^",4)
	s RightEarFlag=$p(Para,"^",5)
    &SQL(update DHC_PA_PregDelBaby set BABY_ScreenDate=:ScreenDate,BABY_ScreenTime=:ScreenTime,
    			BABY_BinauralFlag=:BinauralFlag,BABY_LeftEarFlag=:LeftEarFlag,BABY_RightEarFlag=:RightEarFlag
     			where  BABY_RowID=:BabyID)
	q SQLCODE
}

}
