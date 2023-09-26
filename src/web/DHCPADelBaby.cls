Include Nur.DateFormat

Class web.DHCPADelBaby Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

Query FindBabyInfo(stdate As %String, enddate As %String, FindStatusId As %String = "") As %Query(ROWSPEC = "MotherName:%String,MotherId:%String,BABYBirthWeigth:%String,BABYBirthLength:%String,BABYBirthDate:%String,BABYBirthTime:%String,BABYSex:%String,DHCPAPMIGravida:%String,DHCPAPMIPara:%String,BABYApgarScore1min:%String,BABYApgarScore5min:%String,BABYApgarScore10min:%String,Doctor:%String,wardDesc:%String,safetyNetCardNo:%String,BABYName:%String,PatientID:%String,EpisodeID:%String,BabyID:%String,DelMthd:%String,Outcomedesc:%String,BABYBirthWeek:%String,ind:%String,BABYRegno:%String,ScreenDate:%String,BinauralFlag:%String,LeftEarFlag:%String,RightEarFlag:%String,BedCode:%String")
{
}

ClassMethod FindBabyInfoExecute(ByRef qHandle As %Binary, stdate As %String, enddate As %String, FindStatusId As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	k ^tmpBabyInfodel($j)
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
	.....i (curWardId'="")&(curWardId'=999) s wardDesc=$p(^PAWARD(curWardId),"^",2)
	.....s MotherName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	.....s MotherId=$p($g(^PAPER(papmiId,"ALL")),"^",9)
	.....s DHCPAPMIGravida=$p($g(^PAPER(papmiId,"DHC")),"^",3)
	.....s DHCPAPMIPara=$p($g(^PAPER(papmiId,"DHC")),"^",4)
	.....s DELAdmDR=$p($g(^PAPRG(PREGRowId,"DEL",DELChildsub)),"^",1)
    .....;s MedCareNoIP=##class(web.DHCWMRService).IGetMrTypeInfo(DELAdmDR) //病案号
    .....;s safetyNetCardNo=$p(MedCareNoIP,"^",1)
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
	.....s BABYBirthLength=$p($g(^PAPRG(PREGRowId,"DEL",DELChildsub,"BABY",BABYChildsub)),"^",14)
	.....s BABYBirthWeek=$p($g(^PAPRG(PREGRowId,"DEL",DELChildsub,"BABY",BABYChildsub)),"^",30)
	.....s BABYBirthDay=$p($g(^PAPRG(PREGRowId,"DEL",DELChildsub,"BABY",BABYChildsub)),"^",29)
	.....s BABYSexDR=$p($g(^PAPRG(PREGRowId,"DEL",DELChildsub,"BABY",BABYChildsub)),"^",48)
	.....i BABYSexDR'=""  d
	......s BABYSex=$p($g(^CT("SEX",BABYSexDR)),"^",2)
	.....e  d
	......s BABYSex=""
	.....s scroes=##class(web.DHCPADelivery).GetApgarScore(PREGRowId_"||"_DELChildsub_"||"_BABYChildsub)
	.....;s BABYApgarScore1min=$p($g(^PAPRG(PREGRowId,"DEL",DELChildsub,"BABY",BABYChildsub,"PDBAS",1)),"^",6)
	.....;i BABYApgarScore1min'="" s BABYApgarScore1min=$p($g(^PAC("APGS",+BABYApgarScore1min)),"^",2)
	.....s BABYApgarScore1min=$p(scroes,"^",1)
	.....s BABYApgarScore5min=$p(scroes,"^",2)
	.....s BABYApgarScore10min=$p(scroes,"^",3)
	.....;s BABYApgarScore5min=$p($g(^PAPRG(PREGRowId,"DEL",DELChildsub,"BABY",BABYChildsub)),"^",8)
	.....;i BABYApgarScore5min'="" s BABYApgarScore5min=$p($g(^PAC("APGS",+BABYApgarScore5min)),"^",2)
	.....;s BABYApgarScore10min=$p($g(^PAPRG(PREGRowId,"DEL",DELChildsub,"BABY",BABYChildsub)),"^",12)
	.....;i BABYApgarScore10min'="" s BABYApgarScore10min=$p($g(^PAC("APGS",+BABYApgarScore10min)),"^",2)
	.....s BABYOutcome=$p($g(^PAPRG(PREGRowId,"DEL",DELChildsub,"BABY",BABYChildsub)),"^",23)
	.....s BABYOutcome=+BABYOutcome
	.....i BABYOutcome'=0 s Outcomedesc=$p($g(^PAC("OPREG",BABYOutcome)),"^",2),Outcomecode=$p($g(^PAC("OPREG",BABYOutcome)),"^",1)
	.....e  s Outcomedesc="",Outcomecode=""
	.....q:(FindStatusId'=Outcomecode)&(FindStatusId'="")
	.....s BABYDocDR=$p($g(^PAPRG(PREGRowId,"DEL",DELChildsub,"BABY",BABYChildsub)),"^",22)
	.....i BABYDocDR'=""  d
	......s BABYDoc=$p(^CTPCP(BABYDocDR,1),"^",2)
	.....e  d
	......s BABYDoc=""
	.....s BABYMidDR=$p($g(^PAPRG(PREGRowId,"DEL",DELChildsub,"BABY",BABYChildsub)),"^",24)
	.....i BABYMidDR'=""  d
	......s BABYMid=$p(^CTPCP(BABYMidDR,1),"^",2)
	.....e  d
	......s BABYMid=""
	.....s BABYReDocDR=$p($g(^PAPRG(PREGRowId,"DEL",DELChildsub,"BABY",BABYChildsub)),"^",46)
	.....i BABYReDocDR'=""  d
	......s BABYReDoc=$p(^CTPCP(BABYReDocDR,1),"^",2)
	.....e  d
	......s BABYReDoc=""
	.....s BABYAcMidDR=$p($g(^PAPRG(PREGRowId,"DEL",DELChildsub,"BABY",BABYChildsub)),"^",2)
	.....i BABYAcMidDR'=""  d
	......s BABYAcMid=$p(^CTPCP(BABYAcMidDR,1),"^",2)
	.....e  d
	......s BABYAcMid=""
	.....i BABYMid="" d
	......s BABYAcMidDR2=$p($g(^PAPRG(PREGRowId,"DEL",DELChildsub,"BABY",BABYChildsub)),"^",3)
	......i BABYAcMidDR2'="" s BABYMid=$p(^CTPCP(BABYAcMidDR2,1),"^",2)
	.....s pdbdmsub=0,DelMthd="" 
    .....f  s pdbdmsub=$o(^PAPRG(PREGRowId,"DEL",DELChildsub,"BABY",BABYChildsub,"PDBDM",pdbdmsub)) q:pdbdmsub=""  d
    ......q:pdbdmsub=""
    ......s DelMthdDR=$p($g(^PAPRG(PREGRowId,"DEL",DELChildsub,"BABY",BABYChildsub,"PDBDM",pdbdmsub)),"^",1)
    ......s DelMthdDR=+DelMthdDR
    ......i DelMthdDR'=0 d
    .......s tmpDelMthd=$p($g(^PAC("DLMTH",DelMthdDR)),"^",2)
    .......i DelMthd="" s DelMthd=tmpDelMthd
    .......e  s DelMthd=DelMthd_","_tmpDelMthd
	.....s Doctor=BABYMid_" "_BABYDoc_" "_BABYAcMid_" "_BABYReDoc
	.....s ScreenDate=$p($g(^PAPRG(PREGRowId,"DEL",DELChildsub,"BABY",BABYChildsub,"DHC")),"^",10)
	.....i ScreenDate'="" s ScreenDate=$$$zd(ScreenDate,3)
	.....s BinauralFlag=$p($g(^PAPRG(PREGRowId,"DEL",DELChildsub,"BABY",BABYChildsub,"DHC")),"^",12)
	.....s LeftEarFlag=$p($g(^PAPRG(PREGRowId,"DEL",DELChildsub,"BABY",BABYChildsub,"DHC")),"^",13)
	.....s RightEarFlag=$p($g(^PAPRG(PREGRowId,"DEL",DELChildsub,"BABY",BABYChildsub,"DHC")),"^",14)
	.....d OutputRow
	k ^tmpBabyInfodel($j)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(MotherName,MotherId,BABYBirthWeigth,BABYBirthLength,BABYBirthDate,BABYBirthTime,BABYSex,DHCPAPMIGravida,DHCPAPMIPara,BABYApgarScore1min,BABYApgarScore5min,BABYApgarScore10min,Doctor,wardDesc,safetyNetCardNo,BABYName,PatientID,EpisodeID,BabyID,DelMthd,Outcomedesc,BABYBirthWeek_"+"_BABYBirthDay,ind,BABYRegno,ScreenDate,BinauralFlag,LeftEarFlag,RightEarFlag,BedCode)
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

/// Creator:
/// CreatDate:
/// Description: 取婴儿打印信息
/// Table：PA_PregDelBaby,DHC_PA_PregDelBaby,PA_PrDelBabyDelMthd,PAC_DeliveryMethod
/// Input：BabyID: 婴儿信息表ID,
/// Return：MotherName^safetyNetCardNo^BABYName^BABYBirthWeigth^BABYBirthLength^BABYBirthDate_"/ "_BABYBirthTime^BABYSex
/// 			^DHCPAPMIGravida^DHCPAPMIPara^WeekDay^Apgar^Doctor^wardDesc^MotherId^handtel^homeAddres
/// 			^DelMthd^ScreenDate^BinauralFlag^LeftEarFlag^RightEarFlag^BedCode
/// 			母亲姓名^病案号^婴儿姓名^出生体重^出生长度^出生日期/出生时间^婴儿性别
/// 			^孕次^产次^孕周^阿普卡评分^助产士^病区^身份证^联系电话^联系地址
/// 			^分娩方式^筛查日期^双耳通过^左耳通过^右耳通过^床位号
ClassMethod GetPrintData(BabyID As %String)
{
	q:BabyID=""
	s PREGRowId=$p(BabyID,"||",1)
	s DELChildsub=$p(BabyID,"||",2)
	s BABYChildsub=$p(BabyID,"||",3)
	s DELAdmDR=$p($g(^PAPRG(PREGRowId,"DEL",DELChildsub)),"^",1)
	s papmiId=+$g(^PAADM(+DELAdmDR))
	s MotherName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	s MotherId=$p($g(^PAPER(papmiId,"ALL")),"^",9)
	s handtel=$p($g(^PAPER(papmiId,"PER",1)),"^",11)   //手机
	S homeAddres=$g(^PAPER(papmiId,"PER","ADD",1))     // 住址
	s DHCPAPMIGravida=$p($g(^PAPER(papmiId,"DHC")),"^",3)
	s DHCPAPMIPara=$p($g(^PAPER(papmiId,"DHC")),"^",4)
	s curWardId=$p($g(^PAADM(DELAdmDR)),"^",70)  
    i curWardId'="" s wardDesc=$p(^PAWARD(curWardId),"^",2)
    e  s wardDesc=""
    ;s MedCareNoIP=##class(web.DHCWMRService).IGetMrTypeInfo(DELAdmDR) 	//病案号
    ;s safetyNetCardNo=$p(MedCareNoIP,"^",1)
    s safetyNetCardNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)			//2010-02-02 直接取值
    s motherBedId=$p($g(^PAADM(+DELAdmDR)),"^",73)						//母亲床位号
    s motherWardId=$p(motherBedId,"||",1)
    s motherBedSub=$p(motherBedId,"||",2) 
	s BedCode=""
	i motherWardId'="",motherBedSub'="" d
	.s BedCode=$p($g(^PAWARD(motherWardId,"BED",motherBedSub)),"^",1)
    s PatientID=$p($g(^PAPRG(PREGRowId,"DEL",DELChildsub,"BABY",BABYChildsub)),"^",73)
    s PatientID=+PatientID
    i PatientID'=0 d
    .s BABYName=$p($g(^PAPER(PatientID,"ALL")),"^",1)
    .s EpisodeID=$o(^PAPERdr(PatientID,"ADM","I",""))
    e  d
    .s BABYName=""
    .s EpisodeID=""
	s BABYBirthWeigth=$p($g(^PAPRG(PREGRowId,"DEL",DELChildsub,"BABY",BABYChildsub)),"^",17)
	s BABYBirthLength=$p($g(^PAPRG(PREGRowId,"DEL",DELChildsub,"BABY",BABYChildsub)),"^",14)
	s BABYBirthDate=$$$zd($p($g(^PAPRG(PREGRowId,"DEL",DELChildsub,"BABY",BABYChildsub)),"^",13),3)
	s BABYBirthTime=$zt($p($g(^PAPRG(PREGRowId,"DEL",DELChildsub,"BABY",BABYChildsub)),"^",49))
	s BABYBirthDate=BABYBirthDate_" "_BABYBirthTime
	s BABYSexDR=$p($g(^PAPRG(PREGRowId,"DEL",DELChildsub,"BABY",BABYChildsub)),"^",48)
	i BABYSexDR'=""  d
	.s BABYSex=$p($g(^CT("SEX",BABYSexDR)),"^",2)
	e  d
	.s BABYSex=""
	s BABYApgarScore1min=$p($g(^PAPRG(PREGRowId,"DEL",DELChildsub,"BABY",BABYChildsub)),"^",6)
	i BABYApgarScore1min'="" s BABYApgarScore1min=$p($g(^PAC("APGS",+BABYApgarScore1min)),"^",2)
	s BABYApgarScore5min=$p($g(^PAPRG(PREGRowId,"DEL",DELChildsub,"BABY",BABYChildsub)),"^",8)
	i BABYApgarScore5min'="" s BABYApgarScore5min=$p($g(^PAC("APGS",+BABYApgarScore5min)),"^",2)
	s BABYApgarScore10min=$p($g(^PAPRG(PREGRowId,"DEL",DELChildsub,"BABY",BABYChildsub)),"^",12)
	i BABYApgarScore10min'="" s BABYApgarScore10min=$p($g(^PAC("APGS",+BABYApgarScore10min)),"^",2)
	s scroes=##class(web.DHCPADelivery).GetApgarScore(PREGRowId_"||"_DELChildsub_"||"_BABYChildsub)
	s BABYApgarScore1min=$p(scroes,"^",1)
	s BABYApgarScore5min=$p(scroes,"^",2)
	s BABYApgarScore10min=$p(scroes,"^",3)
	s BABYDocDR=$p($g(^PAPRG(PREGRowId,"DEL",DELChildsub,"BABY",BABYChildsub)),"^",22)
	i BABYDocDR'=""  d
	.s BABYDoc=$p(^CTPCP(BABYDocDR,1),"^",2)
	e  d
	.s BABYDoc=""
	s BABYMidDR=$p($g(^PAPRG(PREGRowId,"DEL",DELChildsub,"BABY",BABYChildsub)),"^",24)
	i BABYMidDR'=""  d
	.s BABYMid=$p(^CTPCP(BABYMidDR,1),"^",2)
	e  d
	.s BABYMid=""
	i BABYMid="" d
	.s BABYAcMidDR2=$p($g(^PAPRG(PREGRowId,"DEL",DELChildsub,"BABY",BABYChildsub)),"^",3)
	.i BABYAcMidDR2'="" s BABYMid=$p(^CTPCP(BABYAcMidDR2,1),"^",2)
	s BABYReDocDR=$p($g(^PAPRG(PREGRowId,"DEL",DELChildsub,"BABY",BABYChildsub)),"^",46)
	i BABYReDocDR'=""  d
	.s BABYReDoc=$p(^CTPCP(BABYReDocDR,1),"^",2)
	e  d
	.s BABYReDoc=""
	s BABYAcMidDR=$p($g(^PAPRG(PREGRowId,"DEL",DELChildsub,"BABY",BABYChildsub)),"^",2)
	i BABYAcMidDR'=""  d
	.s BABYAcMid=$p(^CTPCP(BABYAcMidDR,1),"^",2)
	e  d
	.s BABYAcMid=""
	s BABYBirthWeek=$p($g(^PAPRG(PREGRowId,"DEL",DELChildsub,"BABY",BABYChildsub)),"^",30)
	s BABYBirthDay=$p($g(^PAPRG(PREGRowId,"DEL",DELChildsub,"BABY",BABYChildsub)),"^",29)
	s Apgar=BABYApgarScore1min_"-"_BABYApgarScore5min_"-"_BABYApgarScore10min
	s Doctor=BABYMid_" "_BABYDoc_" "_BABYAcMid_" "_BABYReDoc
	i (BABYBirthWeek'="")!(BABYBirthDay'="") s WeekDay=$g(BABYBirthWeek)_"+"_$g(BABYBirthDay)
	e  s WeekDay=""
	s pdbdmsub=0,DelMthd="" 							//分娩方式
    f  s pdbdmsub=$o(^PAPRG(PREGRowId,"DEL",DELChildsub,"BABY",BABYChildsub,"PDBDM",pdbdmsub)) q:pdbdmsub=""  d
    .s DelMthdDR=$p($g(^PAPRG(PREGRowId,"DEL",DELChildsub,"BABY",BABYChildsub,"PDBDM",pdbdmsub)),"^",1)
    .s DelMthdDR=+DelMthdDR
    .i DelMthdDR'=0 d
    ..s tmpDelMthd=$p($g(^PAC("DLMTH",DelMthdDR)),"^",2)
    ..i DelMthd="" s DelMthd=tmpDelMthd
    ..e  s DelMthd=DelMthd_","_tmpDelMthd
	s ScreenDate=$p($g(^PAPRG(PREGRowId,"DEL",DELChildsub,"BABY",BABYChildsub,"DHC")),"^",10)
	i ScreenDate'="" s ScreenDate=$$$zd(ScreenDate,3)		//筛查日期
	s BinauralFlag=$p($g(^PAPRG(PREGRowId,"DEL",DELChildsub,"BABY",BABYChildsub,"DHC")),"^",12)
	s LeftEarFlag=$p($g(^PAPRG(PREGRowId,"DEL",DELChildsub,"BABY",BABYChildsub,"DHC")),"^",13)
	s RightEarFlag=$p($g(^PAPRG(PREGRowId,"DEL",DELChildsub,"BABY",BABYChildsub,"DHC")),"^",14)
	s str=MotherName_"^"_safetyNetCardNo_"^"_BABYName_"^"_BABYBirthWeigth_"^"_BABYBirthLength_"^"_BABYBirthDate_"^"_BABYSex_"^"_DHCPAPMIGravida_"^"_DHCPAPMIPara_"^"_WeekDay_"^"_Apgar_"^"_Doctor_"^"_wardDesc_"^"_MotherId_"^"_handtel_"^"_homeAddres_"^"_DelMthd_"^"_ScreenDate_"^"_BinauralFlag_"^"_LeftEarFlag_"^"_RightEarFlag_"^"_BedCode
	q str
}

Query FindStatus(desc As %String) As %Query(ROWSPEC = "BabyStatusDesc:%String,BabyStatusCode:%String")
{
}

ClassMethod FindStatusExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s code="BBA",desc="到达前生产"
	d OutputRow4
 	s code="L",desc="活产"
	d OutputRow4
	s code="D",desc="死胎"
	d OutputRow4
	s code="MC",desc="流产"
	d OutputRow4
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow4
	set Data=$lb(desc,code)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindStatusFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindStatusExecute ]
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

ClassMethod FindStatusClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindStatusExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetPrintList(BabyID As %String)
{
	q:BabyID=""
	s PREGRowId=$p(BabyID,"||",1)
	s DELChildsub=$p(BabyID,"||",2)
	s BABYChildsub=$p(BabyID,"||",3)
	s DELAdmDR=$p($g(^PAPRG(PREGRowId,"DEL",DELChildsub)),"^",1)
}

}
