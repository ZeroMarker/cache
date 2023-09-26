Include Nur.DateFormat

/// portal组查询婴儿相关数据接口类
Class web.DHCNurPortalBaby Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

Query FindBabyInfo(dateMonth As %String, FindStatusId As %String = "D") As %Query(ROWSPEC = "weightRange:%String,neonatalDeathNum:%String")
{
}

/// ##class(%ResultSet).RunQuery("web.DHCNurPortalBaby","FindBabyInfo","2017-04")
ClassMethod FindBabyInfoExecute(ByRef qHandle As %Binary, dateMonth As %String, FindStatusId As %String = "D") As %Status
{
    
    q:dateMonth="" "入参年月不能为空"
    q:dateMonth'["-" "入参年月格式错误,yyyy-MM"
    s neonatalDeathNum=0,weightRange=""
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	k ^tmpBabyInfodel($j)
	k ^tmpDeadBabyBum($j)
	s sdateStr=dateMonth_"-01"
	s stdate=$$$zdh(sdateStr,1)
	s enddate=$SYSTEM.SQL.LASTDAY(sdateStr)
	i (stdate="")!(enddate="") s sdate=+$H,edate=+$H
	e  s sdate=stdate,edate=enddate
    f date=sdate:1:edate d
	.s PREGRowId=""
	.f  s PREGRowId=$o(^PAPRGi("BABY_BirthDate",date,PREGRowId))  q:PREGRowId=""  d
	..s DELChildsub=""
	..f  s DELChildsub=$o(^PAPRGi("BABY_BirthDate",date,PREGRowId,"DEL",DELChildsub))  q:DELChildsub=""  d
	...s BABYChildsub=""
	...f  s BABYChildsub=$o(^PAPRGi("BABY_BirthDate",date,PREGRowId,"DEL",DELChildsub,"BABY",BABYChildsub))  q:BABYChildsub=""  d
	....s DELAdmDR=$p($g(^PAPRG(PREGRowId,"DEL",DELChildsub)),"^",1)
	....q:DELAdmDR=""
	....s papmiId=+$g(^PAADM(+DELAdmDR))
	....s curWardId=$p($g(^PAADM(DELAdmDR)),"^",70)
	....i curWardId="" s curWardId=999
	....s BirthTime=$p($g(^PAPRG(PREGRowId,"DEL",DELChildsub,"BABY",BABYChildsub)),"^",49)
	....s BID=PREGRowId_"||"_DELChildsub_"||"_BABYChildsub
	....s ^tmpBabyInfodel($j,date,BirthTime,curWardId,papmiId,BID)=""
	i $d(^tmpBabyInfodel($j))=0  Set qHandle=$lb(0,repid,0) Quit $$$OK
	s num=1,dy0kg=0,dy1kg=0,dy3kg=0,dy5kg=0,dy7kg=0
	s date="" f  s date=$o(^tmpBabyInfodel($j,date)) q:date=""  d
	.s BirthTime="" f  s BirthTime=$o(^tmpBabyInfodel($j,date,BirthTime)) q:BirthTime=""  d
	..s curWardId="" f  s curWardId=$o(^tmpBabyInfodel($j,date,BirthTime,curWardId)) q:curWardId=""  d
	...i date'="" s BABYBirthDate=$$$zd(date,3)
	...s papmiId="" f  s papmiId=$o(^tmpBabyInfodel($j,date,BirthTime,curWardId,papmiId)) q:papmiId=""  d
	....s BABYBirthTime=$zt(BirthTime)
	....s BabyID="" f  s BabyID=$o(^tmpBabyInfodel($j,date,BirthTime,curWardId,papmiId,BabyID)) q:BabyID=""  d
	.....s PREGRowId=$p(BabyID,"||",1)
	.....s DELChildsub=$p(BabyID,"||",2)
	.....s BABYChildsub=$p(BabyID,"||",3)
	.....s wardDesc=""
	.....i (curWardId'="")&(curWardId'=999) s wardDesc=$p(($p(^PAWARD(curWardId),"^",2)),"-",2)
	.....s MotherName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	.....s MotherId=$p($g(^PAPER(papmiId,"ALL")),"^",9)
	.....s DHCPAPMIGravida=$p($g(^PAPER(papmiId,"DHC")),"^",3)
	.....s DHCPAPMIPara=$p($g(^PAPER(papmiId,"DHC")),"^",4)
	.....s DELAdmDR=$p($g(^PAPRG(PREGRowId,"DEL",DELChildsub)),"^",1)
    .....s safetyNetCardNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)			//2010-02-02 直接取值,母亲病案号
    .....s motherBedId=$p($g(^PAADM(+DELAdmDR)),"^",73)							//母亲床位号
    .....s motherWardId=$p(motherBedId,"||",1)
    .....s motherBedSub=$p(motherBedId,"||",2) 
	.....s BedCode=""
	.....i motherWardId'="",motherBedSub'="" d
	......s BedCode=$p($g(^PAWARD(motherWardId,"BED",motherBedSub)),"^",1)
    .....s PatientID=$p($g(^PAPRG(PREGRowId,"DEL",DELChildsub,"BABY",BABYChildsub)),"^",73)
    .....s PatientID=+PatientID
    .....i PatientID'=0 d
    ......s BABYName=$p($g(^PAPER(PatientID,"ALL")),"^",1)
    ......s BABYRegno=$p($g(^PAPER(PatientID,"PAT",1)),"^",1)
    ......s EpisodeID=$o(^PAPERdr(PatientID,"ADM","I",""))
    .....e  d
    ......s BABYName=""
    ......s EpisodeID=""
    ......s BABYRegno=""
	.....s BABYBirthWeigth=$p($g(^PAPRG(PREGRowId,"DEL",DELChildsub,"BABY",BABYChildsub)),"^",17)
	.....s BABYOutcome=$p($g(^PAPRG(PREGRowId,"DEL",DELChildsub,"BABY",BABYChildsub)),"^",23)
	.....s BABYOutcome=+BABYOutcome
	.....i BABYOutcome'=0 s Outcomedesc=$p($g(^PAC("OPREG",BABYOutcome)),"^",2),Outcomecode=$p($g(^PAC("OPREG",BABYOutcome)),"^",1)
	.....e  s Outcomedesc="",Outcomecode=""
	.....q:(FindStatusId'=Outcomecode)&(FindStatusId'="")
	.....i BABYBirthWeigth<1000  d
	......s weightRangeStr ="1Kg以下" 
	......s dy0kg=dy0kg+num 
	......s ^tmpDeadBabyBum($j,weightRangeStr)=dy0kg
	.....i (BABYBirthWeigth>=1000)&&(BABYBirthWeigth<3000) d
	......s weightRangeStr ="1Kg~3Kg" 
	......s dy1kg=dy1kg+num 
	......s ^tmpDeadBabyBum($j,weightRangeStr)=dy1kg
	.....i (BABYBirthWeigth>=3000)&&(BABYBirthWeigth<5000) d
	......s weightRangeStr ="3Kg~5Kg" 
	......s dy3kg=dy3kg+num 
	......s ^tmpDeadBabyBum($j,weightRangeStr)=dy3kg
	.....i (BABYBirthWeigth>=5000)&&(BABYBirthWeigth<7000) d
	......s weightRangeStr ="5Kg~7Kg" 
	......s dy5kg=dy5kg+num 
	......s ^tmpDeadBabyBum($j,weightRangeStr)=dy5kg
	.....i (BABYBirthWeigth>=7000)  d
	......s weightRange ="7Kg以上" 
	......s dy7kg=dy7kg+num 
	......s ^tmpDeadBabyBum($j,weightRangeStr)=dy7kg
	s weightRange=""  f  s weightRange=$O(^tmpDeadBabyBum($j,weightRange)) Q:weightRange=""  d
	.s neonatalDeathNum=$p(^tmpDeadBabyBum($j,weightRange),"^",1)
	.d OutputRow
	k ^tmpBabyInfodel($j)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(weightRange,neonatalDeathNum)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindBabyInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBabyInfoExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {	
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindBabyInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBabyInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
