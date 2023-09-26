Class web.DHCNurShiftExchage Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 230;

ClassMethod LockClear(locId) As %String
{
	s locId=%session.Get("LOGON.CTLOCID")
	s sid=%session.SessionId
 d ##class(websys.Lock).LockClear($Lb(locId,"User.DHCNurWardShift"),%session.SessionId)
 q 0
}

Query GetWard(code As %String) As %Query(ROWSPEC = "desc:%String,rw:%String")
{
}

ClassMethod GetWardExecute(ByRef qHandle As %Binary, code As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s sub=0 f  s sub=$o(^PAWARD(sub)) q:(sub="")!(sub="BED_BedType_DR")  d
    .q:$p(^PAWARD(sub),"^",6)'="Y"
    .s desc=$p(^PAWARD(sub),"^",2)
    .q:((desc'[code)&(code'=""))
   	.Do OutwardRow
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutwardRow
	set Data=$lb(desc,sub)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetWardFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetWardExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

ClassMethod GetWardClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetWardExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod HasCounted(userId, admDate, type, EpisodeID) As %String
{
	n (userId,admDate,type,EpisodeID)
	 s hasCountFlag=0,existCritiIndex=""  ;w $o(^DHCNurExchage(3880,$ZD(65433-1,3),"23","")) 
    f  s existCritiIndex=$o(^DHCNurExchageType(userId,admDate,EpisodeID,type,existCritiIndex)) q:existCritiIndex=""  d
    .s existAdm=$p(^DHCNurExchageType(userId,admDate,EpisodeID,type,existCritiIndex),"^",4) //长期医嘱夜班开时会在第二天凌晨滚出一条，但是一个班不能统计两次
    .s:existAdm=EpisodeID hasCountFlag=1
   q hasCountFlag
}

Query GetWardItemSummary(startDate As %String, endDate As %String, wardId As %String, wardDesc As %String, startTime As %String, endTime As %String, userId As %String, type As %String) As %Query(ROWSPEC = "tDate:%String,tAdmSum:%String,tDischSum:%String,tTransInSum:%String,tTransOutSum:%String,tSpecCareSum:%String,tACareSum:%String,tOperSum:%String,tCritiSum:%String,tDeathSum:%String,tBirthSum:%String,tSeveritySum:%String,totalNum:%String")
{
}

// 仅当 记录以前保存过但是被删了  返回1

ClassMethod GetHasDeleteFlag(useID, Date, type, EpisodeID, workType) As %String
{
	n (useID,Date,type,EpisodeID,workType)
	q:workType="" 0
	s ret=0
	i $D(^DHCNurExchage(useID,"HASDELETE",$ZD(Date,3),EpisodeID,type,workType)) s ret=1  //
	i $D(^DHCNurExchage(useID,"HASDELETE",$ZD(Date-1,3),EpisodeID,type,workType)) s ret=1  //
   q ret
}

/// 普通手术如果存在 返回备注,不存在时返回0
ClassMethod IfExistOPOrder(ordDate, EpisodeID, arcimCodes, sTime = "", eTime = "") As %String
{

	//w ##class(web.DHCNurShiftExchage).IfExistOPOrder(63628,9643831,"ZT0026^ZT0027",0,25141)
	n (ordDate,EpisodeID,arcimCodes,sTime,eTime)
	s ret=0
	q:EpisodeID="" ret
	s num=$l(arcimCodes,"^")
	f i=1:1:num d
	.q:ret=1
	.s code=$p(arcimCodes,"^",i)
	.q:code=""
	.s rowId=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(code),""))
	.q:rowId=""
	.s rowId=rowId_"||"_"1"
	.s oeordId=$o(^OEORD(0,"Adm",EpisodeID,""))
	.q:oeordId=""
	.s oeoriSub=""
	.f  s oeoriSub=$o(^OEORDi(0,"ARCIM",oeordId,rowId,ordDate,oeoriSub)) q:(oeoriSub="")||(ret'=0)  d
	..q:'$d(^OEORD(oeordId,"I",oeoriSub,1))
	..s statDr=$p(^OEORD(oeordId,"I",oeoriSub,1),"^",13)
	..s sttTime=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",10)
	..s xDate=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",34)
    ..s xTime=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",15)
	..//s ^ypzTmp("time",code,EpisodeID)=statDr_"/"_sttTime_"/"_ordDate_"/"_xDate_"/"_xTime
	..s fillerno=$p($g(^OEORD(oeordId,"I",oeoriSub,9)),"^",12)
	..;i fillerno'="" s sttTime=0
	..//i fillerno'="" s sTime=0
	..b ;01
	..q:sttTime<sTime //如果注释，白班夜班都统计
	..q:sttTime>eTime
	..i (statDr'=4)&(statDr'=11)&(statDr'=2) d
	...b
	... s ret=$G(^OEORD(oeordId,"I", oeoriSub,"DEP",1))

	 q ret
}

/// 妇科取医嘱名+备注
ClassMethod getFKOPInfo(oeord) As %String
{
	
	s ordPar=$p(oeord,"||",1)
	 s ordSub=$p(oeord,"||",2)
	 q:(ordSub)="" ""
    s ArcimDR=$p(^OEORD(ordPar,"I",ordSub,1),"^",2) 
    q:ArcimDR="" ""
	s ARCIMRowid=$P(ArcimDR,"||",1)
	s ARCIMSub=$P(ArcimDR,"||",2)
	s ARCIMD=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",2)  ;ord name  
	s ARCIMDesc=ARCIMD
	s Notes=$G(^OEORD(ordPar,"I", ordSub,"DEP",1)) 
	i Notes'="" s ARCIMDesc=ARCIMDesc_"("_Notes_")"
    ;s ARCIMDesc=$P(ARCIMD,"]",2)
    
    q ARCIMDesc
}

ClassMethod GetWardItemSummaryExecute(ByRef qHandle As %Binary, startDate As %String = "", endDate As %String = "", wardId As %String = "", wardDesc As %String, startTime = "", endTime = "", userId = "", type) As %Status
{
	//d ##class(%ResultSet).RunQuery("web.DHCNurShiftExchage","GetWardItemSummary",63627,6363628,51,"",64800,25140,3880,"Night") //s lodId=98
	//d ##class(%ResultSet).RunQuery("web.DHCNurShiftExchage","GetWardItemSummary",63251,63251,48,"",25200,68400,3880,"Day")
	//d ##class(%ResultSet).RunQuery("web.DHCNurShiftExchage","GetWardItemSummary",63253,63254,48,"",68400,25200,3880,"Night")
	
	Set repid=$I(^CacheTemp)
 	s ind=1
 	i wardId="" d
 	.s wardDesc=$tr(wardDesc,"-","")
 	.i wardDesc'="" s wardId=$o(^PAWARD(0,"WARD_Desc",wardDesc,wardId))
 	i (startDate="")&(endDate="")&(wardId="")  Set qHandle=$lb(0,repid,0) Quit $$$OK
 	i wardId="" Set qHandle=$lb(0,repid,0) Quit $$$OK
 	i startDate="" s startDate=+$H
 	i endDate="" s endDate=+$H
 	
 	i endDate-startDate>7 s startDate=endDate-7
 	i startTime="" s startTime=0
 	i endTime="" s endTime=86400
 	s tmpStartTime=startTime
 	s tmpEndTime=endTime
 	s admDate=""
 	i userId="" s userId=%session.Data("LOGON.USERID")
 	
 	//该函数只查一个班次，日间为当天，夜间为当天或当天加昨天，其他时间只查询数据库的已经数据
 	//k ^DHCNurExchage(userId)	//病室报告分日间与夜间查看注释调试
 	f admDate=startDate:1:endDate d
	.s (admSum,dischSum,transInSum,transOutSum,specCareSum,aCareSum,operSum,tomorrowOperSum,critiSum,deathSum,birthSum,severitySum)=0
 	.s sTime=startTime
 	.s eTime=endTime
 	.i admDate'=startDate s sTime=0,eTime=tmpEndTime
 	.i admDate'=endDate s eTime=86400,sTime=tmpStartTime
 	.k TMPPat
 	.k TMPtrans
 	.s TMPPat=""
 	.s workType="夜班"
 	.i (sTime>=$p(^DHCNurWardShiftTime,"^",1))&&(eTime<=$p(^DHCNurWardShiftTime,"^",2)) s workType="白班"
 	.;b //2
 	.s transInf=..GetWardTransNum(admDate,wardId,userId,sTime,eTime,.TMPtrans) //转出科室要病人的手术
    .s transInSum=$P($G(transInf),"^",1)
    .s transOutSum=$P($G(transInf),"^",2)
 	.s EpisodeID=""
 	.f  s EpisodeID=$o(^PAADMi("PAADM_AdmDate",admDate,EpisodeID)) q:EpisodeID=""  d
 	..s paAdmTime=$p($g(^PAADM(EpisodeID)),"^",7)
 	..q:paAdmTime<sTime
    ..q:paAdmTime'<eTime
    ..s ret=$g(^PAADM(EpisodeID,"TRANS",2))
    ..q:ret=""
    ..s patWardId=$p(^PAADM(EpisodeID,"TRANS",2),"^",9)
    ..q:patWardId'=wardId
    ..s admVisitStat=$p($g(^PAADM(EpisodeID)),"^",20)
    ..q:admVisitStat="C"
    ..s MotherAdm=$p($g(^PAADM(EpisodeID)),"^",75)
  
    ..q:(MotherAdm'="")
    ..s HasSaveFlag=..GetHasDeleteFlag(userId,admDate,"入院",EpisodeID,workType)
    ..q:(HasSaveFlag=1)
    ..s admSum=admSum+1  
    ..s patInfo=..PatInfo1(EpisodeID)
    ..s $p(patInfo,"^",7)=..GetWardLastBed(EpisodeID,wardId)
    ..s rawAge=$p(patInfo,"^",8)
    ..s formatAge=rawAge
    ..s noteStr=""
    ..i (sTime>=$p(^DHCNurWardShiftTime,"^",1))&&(sTime<$p(^DHCNurWardShiftTime,"^",2)) s noteStr=$p(patInfo,"^",4)_"，"_formatAge
    ..e  s noteStr="^"_$p(patInfo,"^",4)_";"_formatAge
    ..s infostr=$p(patInfo,"^",7)_"^"_$p(patInfo,"^",5)_"^"_$p(patInfo,"^",14)_"^"_EpisodeID_"^"_noteStr
    ..;i (sTime>=$p(^DHCNurWardShiftTime,"^",1))&&(sTime<$p(^DHCNurWardShiftTime,"^",2)) d
	    ..;.s ^DHCNurExchageType(userId,admDate,EpisodeID,"入院","白班")=infostr
	..s ^objcyf1210(userId,admDate,EpisodeID)=infostr
    ..s ^DHCNurExchageType(userId,admDate,EpisodeID,"入院",workType)=infostr
    ..s ^DHCNurExchage(userId,$ZD(admDate,3),"入院",admSum)=infostr
 	.s patRoomId=""
 	.f  s patRoomId=$O(^PAADMi("CurrWard",wardId,patRoomId)) q:patRoomId=""  d
 	..s EpisodeID=""   //当前在院
 	..f  s EpisodeID=$O(^PAADMi("CurrWard",wardId,patRoomId,EpisodeID)) q:EpisodeID=""  d
    ...s paVisit=$p($g(^PAADM(EpisodeID)),"^",20)
    ...q:paVisit'="A"
    ...s paAdmDate=$p($g(^PAADM(EpisodeID)),"^",6)
    ...s TMPPat(userId,EpisodeID)=""
    .s EpisodeID=""
    .f  s EpisodeID=$O(^PAADMi("DisDateT","I",admDate,EpisodeID)) q:EpisodeID=""  d
    ..s disWardId=$p($g(^PAADM(EpisodeID)),"^",70)  //已经出院的人当天的事件要统计
    ..q:disWardId'=wardId
    ..s paVisit=$p($g(^PAADM(EpisodeID)),"^",20)
    ..q:paVisit'="D"
    ..s disDate=$p($g(^PAADM(EpisodeID)),"^",17)
    ..s disTime=$p($g(^PAADM(EpisodeID)),"^",18)
    ..i (disDate'="")&(admDate=disDate) d
    ...q:disTime<sTime
    ...q:disTime'<eTime
    ...s TMPPat(userId,EpisodeID)=""
    .s EpisodeID=""
    .f  s EpisodeID=$O(^PAADMi("EstDisch",admDate,EpisodeID)) q:EpisodeID=""  d
    ..s disWardId=$p($g(^PAADM(EpisodeID)),"^",70)  //已经siwang的人当天的事件要统计
    ..q:disWardId'=wardId
    ..s paVisit=$p($g(^PAADM(EpisodeID)),"^",20)
    ..s disDate=$p($g(^PAADM(EpisodeID)),"^",59)
    ..s disTime=$p($g(^PAADM(EpisodeID)),"^",60)
    ..i (disDate'="")&(admDate=disDate) d
    ...q:disTime<sTime
    ...q:disTime'<eTime
    ...s TMPPat(userId,EpisodeID)=""
    .i $D(TMPPat) d
    ..s EpisodeID=""
    ..f  s EpisodeID=$o(TMPPat(userId,EpisodeID)) q:EpisodeID=""  d
    ...b:EpisodeID=2383 ;16667
    ...s specCareFlag=..IfExistOrder(admDate,EpisodeID, "4409301020^666600007^666600494",sTime,eTime)
    ...i specCareFlag=1 s specCareSum=specCareSum+1
    ...s aCareFlag=..IfExistOrder(admDate,EpisodeID, "4409010218^666600679",sTime,eTime)
    ...i aCareFlag=1 s aCareSum=aCareSum+1
    ...s saveDate=admDate
    ...i sTime=0 d 
    ....s critiSumFlag=..IfExistLongOrder(admDate-1,EpisodeID, "WFY000811",0,86399,wardId)
    ....s saveDate=admDate-1
    ...e  d
    ....s critiSumFlag=..IfExistLongOrder(admDate,EpisodeID, "WFY000811",sTime,eTime,wardId)
    ...i critiSumFlag=1 d
    ....s HasSaveFlag=..GetHasDeleteFlag(userId,saveDate,"病重",EpisodeID,workType)
    ....q:(HasSaveFlag=1)
    ....s critiSum=critiSum+1
    ....s patInfo=..PatInfo1(EpisodeID)
    ....s $p(patInfo,"^",7)=..GetWardLastBed(EpisodeID,wardId)
    ....;q:(hasCountFlagTod=1)
    ....;i (sTime>=$p(^DHCNurWardShiftTime,"^",1))&&(sTime<$p(^DHCNurWardShiftTime,"^",2)) d
	....;.s ^DHCNurExchageType(userId,saveDate,EpisodeID,"病重","白班")=$p(patInfo,"^",7)_"^"_$p(patInfo,"^",5)_"^"_$p(patInfo,"^",14)_"^"_EpisodeID
    ....s ^DHCNurExchageType(userId,saveDate,EpisodeID,"病重",workType)=$p(patInfo,"^",7)_"^"_$p(patInfo,"^",5)_"^"_$p(patInfo,"^",14)_"^"_EpisodeID
    ....s ^pjf(userId,EpisodeID)=$p(patInfo,"^",7)_"^"_$p(patInfo,"^",5)_"^"_$p(patInfo,"^",14)_"^"_EpisodeID
    ....s ^DHCNurExchage(userId,$ZD(admDate,3),"病重",critiSum)=$p(patInfo,"^",7)_"^"_$p(patInfo,"^",5)_"^"_$p(patInfo,"^",14)_"^"_EpisodeID
   
    ...//病危
    ...s saveDate=admDate
    ...i sTime=0 d 
    ....s severitySumFlag=..IfExistLongOrder(admDate-1,EpisodeID, "WFY000810",0,86399,wardId)
    ....s saveDate=admDate-1
    ...e  d
    ....s severitySumFlag=..IfExistLongOrder(admDate,EpisodeID, "WFY000810",sTime,eTime,wardId)
    ...;s severitySumFlag=..IfExistOrder(admDate,EpisodeID, "N0301^N0302",sTime,eTime)
    ...i severitySumFlag=1 d
    ....s HasSaveFlag=..GetHasDeleteFlag(userId,saveDate,"病危",EpisodeID,workType)
    ....q:(HasSaveFlag=1)
    ....s severitySum=severitySum+1
    ....;q:(hasCountFlagTod=1)
    ....s patInfo=..PatInfo1(EpisodeID)
    ....s $p(patInfo,"^",7)=..GetWardLastBed(EpisodeID,wardId)
   
    ....i (sTime>=$p(^DHCNurWardShiftTime,"^",1))&&(sTime<$p(^DHCNurWardShiftTime,"^",2)) s noteStr=##class(web.DHCThreeNew).GetLastData(EpisodeID)
    ....e  s noteStr="^"_##class(web.DHCThreeNew).GetLastData(EpisodeID)
    ....s infoStr=$p(patInfo,"^",7)_"^"_$p(patInfo,"^",5)_"^"_$p(patInfo,"^",14)_"^"_EpisodeID_"^"_noteStr
    ....;i (sTime>=$p(^DHCNurWardShiftTime,"^",1))&&(sTime<$p(^DHCNurWardShiftTime,"^",2)) d
	....;.s ^DHCNurExchageType(userId,saveDate,EpisodeID,"病危","白班")=infoStr
    ....s ^DHCNurExchageType(userId,saveDate,EpisodeID,"病危",workType)=infoStr
    ....s ^DHCNurExchage(userId,$ZD(admDate,3),"病危",severitySum)=infoStr
    ....//b //bw
    ...//s operSumFlag=..IfOperApp(admDate,EpisodeID,sTime,eTime)
    ...//b //op
    ...d ..SetOPStatus(admDate,userId,EpisodeID,sTime,eTime,wardId)  //手术
    ...s deathSumFlag=..IfExistOrder(admDate,EpisodeID, "WFY001254",sTime,eTime)
    ...s HasSaveFlag=..GetHasDeleteFlag(userId,admDate,"死亡",EpisodeID,workType)
    ...q:(HasSaveFlag=1)
    ...i deathSumFlag=1 d
    ....s deathSum=deathSum+1
    ....s patInfo=..PatInfo1(EpisodeID)
    ....s $p(patInfo,"^",7)=..GetWardLastBed(EpisodeID,wardId)

    ....;i (sTime>=$p(^DHCNurWardShiftTime,"^",1))&&(sTime<$p(^DHCNurWardShiftTime,"^",2)) d
	....;.s ^DHCNurExchageType(userId,admDate,EpisodeID,"死亡","白班")=$p(patInfo,"^",7)_"^"_$p(patInfo,"^",5)_"^"_$p(patInfo,"^",14)_"^"_EpisodeID
    ....s ^DHCNurExchageType(userId,admDate,EpisodeID,"死亡",workType)=$p(patInfo,"^",7)_"^"_$p(patInfo,"^",5)_"^"_$p(patInfo,"^",14)_"^"_EpisodeID
    ....s ^DHCNurExchage(userId,$ZD(admDate,3),"死亡",deathSum)=$p(patInfo,"^",7)_"^"_$p(patInfo,"^",5)_"^"_$p(patInfo,"^",14)_"^"_EpisodeID
    
    .d ..SetCheckOutStatus(admDate,userId,sTime,eTime,workType) //出院
    
    .i $D(TMPtrans) d //转出科室带出手术
    ..s EpisodeID=""
    ..f  s EpisodeID=$o(TMPtrans(userId,EpisodeID)) q:EpisodeID=""  d
    ...d ..SetOPStatus(admDate,userId,EpisodeID,sTime,eTime,wardId) //手术


	.s preRowid=0
	.f  s preRowid=$o(^PAPRGi("BABY_BirthDate",admDate,preRowid)) q:preRowid=""  d
	..s DeliveryId=0
	..;b //fm
	..f  s DeliveryId=$o(^PAPRGi("BABY_BirthDate",admDate,preRowid,"DEL",DeliveryId)) q:DeliveryId=""  d
	...s DelBabyId=$o(^PAPRGi("BABY_BirthDate",admDate,preRowid,"DEL",DeliveryId,"BABY","")) 
	...q:DelBabyId=""
	...s methodId=""
	...s normalFlag=1
	...f  s methodId=$o(^PAPRG(preRowid,"DEL",DeliveryId,"BABY",DelBabyId,"PDBDM",methodId)) q:(methodId="")||(normalFlag=0)  d
	....s DelMthdDR=+^PAPRG(preRowid,"DEL",DeliveryId,"BABY",DelBabyId,"PDBDM",methodId)
	....s:DelMthdDR'=1 normalFlag=0
	...q:normalFlag=0
	...s BirthTime=$p(^PAPRG(preRowid,"DEL",DeliveryId,"BABY",DelBabyId),"^",49)
	...s motherAdm=$p(^PAPRG(preRowid,"DEL",DeliveryId),"^",1)
	
	
	...q:(BirthTime<=sTime)||(BirthTime>endTime)
	...s birthWard=..GetWardAccordDT(motherAdm,$zd(admDate,3),$zt(BirthTime))
	...;b //fm2
	...s motherCurWard=+$P(^PAADM(motherAdm),"^",73)
	...q:(wardId'=birthWard)&&(wardId'=motherCurWard)
	...s HasSaveFlag=..GetHasDeleteFlag(userId,admDate,"分娩",motherAdm,workType)
    ...q:(HasSaveFlag=1)
    
	...s patInfo=..PatInfo1(motherAdm)
	...s $p(patInfo,"^",7)=..GetWardLastBed(motherAdm,wardId)
	...;i (sTime>=$p(^DHCNurWardShiftTime,"^",1))&&(sTime<$p(^DHCNurWardShiftTime,"^",2)) d
	...;.s ^DHCNurExchageType(userId,admDate,motherAdm,"分娩","白班")=$p(patInfo,"^",7)_"^"_$p(patInfo,"^",5)_"^"_$p(patInfo,"^",14)_"^"_motherAdm
	...s ^DHCNurExchageType(userId,admDate,motherAdm,"分娩",workType)=$p(patInfo,"^",7)_"^"_$p(patInfo,"^",5)_"^"_$p(patInfo,"^",14)_"^"_motherAdm
	.;s preRowid=0
	.;f  s preRowid=$o(^PAPRGi("DEL_LaborDate",admDate,preRowid)) q:preRowid=""  d
	.;.s delChildsub=0 
	.;.f  s delChildsub=$o(^PAPRGi("DEL_LaborDate",admDate,preRowid,"DEL",delChildsub)) q:delChildsub=""  d
	.;..s AdmID=$p($g(^PAPRG(preRowid,"DEL",delChildsub)),"^",1)
    .;..q:AdmID=""
    .;..s TStatusCode=$p($g(^PAPRG(preRowid,"DEL",delChildsub,"DHC")),"^",10)
    .;..//"待产""D/分娩""R/产后康复""D/分娩""O/手术""W/病房""C/取消"
    .;..q:TStatusCode'="D"
    .;..s dateWardId=..getPatWard(AdmID,admDate)
    .;..q:dateWardId'=wardId
    .;..s HasSaveFlag=..GetHasDeleteFlag(userId,admDate,"分娩",EpisodeID)
    .;..q:(HasSaveFlag=1)
	.;..s birthSum=birthSum+1
	.;..s patInfo=..PatInfo1(AdmID)
	.;..s ^DHCNurExchageType(userId,admDate,AdmID,"分娩",birthSum)=$p(patInfo,"^",7)_"^"_$p(patInfo,"^",5)_"^"_$p(patInfo,"^",14)_"^"_EpisodeID
	.;..s ^DHCNurExchage(userId,$ZD(admDate,3),"分娩",birthSum)=$p(patInfo,"^",7)_"^"_$p(patInfo,"^",5)_"^"_$p(patInfo,"^",14)_"^"_EpisodeID
    .//总数/当前在院病人/等候区不算
	.s curRoomId="",totalNum=0
	.f  s curRoomId=$O(^PAADMi("CurrWard",wardId,curRoomId)) q:curRoomId=""  d
	..s EpisodeID="" 
	..f  s EpisodeID=$O(^PAADMi("CurrWard",wardId,curRoomId,EpisodeID)) q:EpisodeID=""  d
	...s paVisit=$p($g(^PAADM(EpisodeID)),"^",20)
	...q:paVisit'="A"
	...s bedSub=$p($p($g(^PAADM(EpisodeID)),"^",73),"||",2)
    ...q:bedSub=""
    ...s HasSaveFlag=..GetHasDeleteFlag(userId,admDate,"在院",EpisodeID,workType)
    ...q:(HasSaveFlag=1)
    ...s patInfo=..PatInfo1(EpisodeID)
    
    ...s ^DHCNurInHospital(userId,EpisodeID)=$p(patInfo,"^",7)
    ...;b //in
    ...;i (sTime>=$p(^DHCNurWardShiftTime,"^",1))&&(sTime<$p(^DHCNurWardShiftTime,"^",2)) d
    ...;.s ^DHCNurExchageType(userId,admDate,EpisodeID,"在院","白班")=$p(patInfo,"^",7)_"^"_$p(patInfo,"^",5)_"^"_$p(patInfo,"^",14)_"^"_EpisodeID
    ...;e  d
    ...i '$d(^DHCNurExchageType(userId,admDate-1,EpisodeID,"在院",workType)) d
    ....;b //in hos
    ....s ^DHCNurExchageType(userId,admDate,EpisodeID,"在院",workType)=$p(patInfo,"^",7)_"^"_$p(patInfo,"^",5)_"^"_$p(patInfo,"^",14)_"^"_EpisodeID
	...;s totalNum=totalNum+1
	.d OutWardSummary
    
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutWardSummary
	set Data=$lb($ZD(admDate,3),admSum,dischSum,transInSum,transOutSum,specCareSum,aCareSum,operSum,critiSum,deathSum,birthSum,severitySum,totalNum)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetWardLastBed(EpisodeID, Ward) As %String
{
	//w ##class(web.DHCNurShiftExchage).GetWardLastBed(2459402,66)
	s ret=""
	s Childsub="" f  s Childsub=$o(^PAADM(EpisodeID,"TRANS",Childsub),-1) q:(Childsub="")||(ret'="")  d
    .s ward=$P(^PAADM(EpisodeID,"TRANS",Childsub),"^",9)
  	.q:ward=""
  	.q:Ward'=ward
  	.s bedDr=$P(^PAADM(EpisodeID,"TRANS",Childsub),"^",8)
  	.q:bedDr=""
  	.s WardId=$p(bedDr,"||",1)
  	.s bedSub=$p(bedDr,"||",2)
  	.s ret=$p($g(^PAWARD(WardId,"BED",bedSub)),"^",1)
  	q ret
}

ClassMethod GetWardAccordDT(EpisodeID, Date, Time) As %String
{
	//w ##class(web.DHCNurShiftExchage).GetWardAccordDT(2462743,"2014-04-01","10:00")
	s ret=""
	s Date=$zdh(Date,3)
	s Time=$zth(Time)
	s PreWard=""
    s stdatetime=Date*86400+Time //pan 20111102
    s Childsub="" f  s Childsub=$o(^PAADM(EpisodeID,"TRANS",Childsub)) q:(Childsub="")||(ret'="")  d
    .s ward=$P(^PAADM(EpisodeID,"TRANS",Childsub),"^",9)
  	.q:ward=""
	.s transStDate=$P($G(^PAADM(EpisodeID,"TRANS",Childsub)),"^",1)
  	.s transStTime=$P($G(^PAADM(EpisodeID,"TRANS",Childsub)),"^",2)
  	.s transEndDate=$P($G(^PAADM(EpisodeID,"TRANS",Childsub)),"^",3)
    .s transEndTime=$P($G(^PAADM(EpisodeID,"TRANS",Childsub)),"^",4)
    
    .s transDateTime=(transStDate*86400)+transStTime
    .s transEndDateTime=(transEndDate*86400)+transEndTime
    .i (stdatetime>=transDateTime)&&(stdatetime<transEndDateTime) d
    ..s ret=ward
    .i (stdatetime>=transDateTime)&&(transEndDate="") d
    ..s ret=ward
   q ret
}

ClassMethod GetCheckOutBed(Adm) As %String
{
	// w ##class(web.DHCNurShiftExchage).GetCheckOutBed(2588283) 
	q:$G(Adm)="" ""
	s bed=""
	s Childsub="" f  s Childsub=$o(^PAADM(Adm,"TRANS",Childsub),-1) q:(Childsub="")||(bed'="")  d
	   .s bedDr=$p(^PAADM(Adm,"TRANS",Childsub),"^",8)
	   .s:bedDr'="" bed=$p(bedDr,"||",2)
	   .q:bed=""
	   .s curWardId=+bedDr
	   .s bedSub=$p(bedDr,"||",2)
	   .i bedSub'="" s bed=$p($g(^PAWARD(curWardId,"BED",bedSub)),"^",1)
       .e  s bed=""
	  
	q bed
}

ClassMethod SetCheckOutStatus(admDate, userId, sTime, eTime, workType) As %String
{
	 s EpisodeID=""
	 b //check
	f  s EpisodeID=$O(^PAADMi("DisDateT","I",admDate,EpisodeID)) q:EpisodeID=""  d
    .s disWardId=$p($g(^PAADM(EpisodeID)),"^",70)
    .q:disWardId'=wardId
    .s paVisit=$p($g(^PAADM(EpisodeID)),"^",20)
    .q:paVisit'="D"
    .s disDate=$p($g(^PAADM(EpisodeID)),"^",17)
    .s disTime=$p($g(^PAADM(EpisodeID)),"^",18)
    .i (disDate'="")&(admDate=disDate) d
        ..q:disTime<sTime
        ..q:disTime'<eTime
        ..s deathFlag=..IfExistTempOrderEver(EpisodeID,"W1102")
        
        ..q:deathFlag=1
        ..s HasSaveFlag=..GetHasDeleteFlag(userId,admDate,"出院",EpisodeID,workType)
        ..q:(HasSaveFlag=1)
        ..s dischSum=dischSum+1
        ..s patInfo=..PatInfo1(EpisodeID)
        ..
        ..s $p(patInfo,"^",7)=..GetCheckOutBed(EpisodeID)
        ..b //CheckOut
        ..i (sTime>=$p(^DHCNurWardShiftTime,"^",1))&&(sTime<$p(^DHCNurWardShiftTime,"^",2)) d
	    ...s ^DHCNurExchageType(userId,admDate,EpisodeID,"出院","白班")=$p(patInfo,"^",7)_"^"_$p(patInfo,"^",5)_"^"_$p(patInfo,"^",14)_"^"_EpisodeID
        ..e  s ^DHCNurExchageType(userId,admDate,EpisodeID,"出院","夜班")=$p(patInfo,"^",7)_"^"_$p(patInfo,"^",5)_"^"_$p(patInfo,"^",14)_"^"_EpisodeID
        ..s ^DHCNurExchage(userId,$ZD(admDate,3),"出院",dischSum)=$p(patInfo,"^",7)_"^"_$p(patInfo,"^",5)_"^"_$p(patInfo,"^",14)_"^"_EpisodeID

	q ""
}

ClassMethod SetOPStatus(admDate, userId, EpisodeID, sTime, eTime, wardId) As %String
{
  // b //s a=##class(web.DHCNurShiftExchage).SetOPStatus(64883,"5468","2824",0,"25141","6")
    i EpisodeID=2824  s ^nw(11)=$lb(admDate, userId, EpisodeID, sTime, eTime, wardId)
	s wordType="夜班"  //6:59                           18:00
 	i (sTime>=$p(^DHCNurWardShiftTime,"^",1))&&(sTime<$p(^DHCNurWardShiftTime,"^",2)) s wordType="白班"
	s HasSaveFlag=..GetHasDeleteFlag(userId,admDate,"手术",EpisodeID,wordType)

    if (HasSaveFlag'=1) d
    .s noteStr=""
    .s operSumFlag=..IfExistOPOrder(admDate,EpisodeID, "330502005^330602002^331303008^331302004B^330204004",sTime,eTime)
    .if operSumFlag'=0 b ///opsum
    .s isCancel=..IfExistOrder(admDate,EpisodeID, "N3161",sTime,eTime)
    .s hasNewLongFlag =..HaveNewLongOrder(admDate,EpisodeID, "",sTime,eTime)
    .if hasNewLongFlag'=0 d
    ..s OPInfo=..getFKOPInfo(hasNewLongFlag)
    ..i (sTime>=$p(^DHCNurWardShiftTime,"^",1))&&(sTime<$p(^DHCNurWardShiftTime,"^",2)) s noteStr=OPInfo
    ..e  s noteStr="^"_OPInfo
    .i operSumFlag'=0 d
    ..i (sTime>=$p(^DHCNurWardShiftTime,"^",1))&&(sTime<$p(^DHCNurWardShiftTime,"^",2)) s noteStr=operSumFlag
    ..e  s noteStr="^"_operSumFlag
    .s patInfo=..PatInfo1(EpisodeID)
    .s $p(patInfo,"^",7)=..GetWardLastBed(EpisodeID,wardId)
    .i ((operSumFlag'=0)||(hasNewLongFlag'=0))&&(isCancel=0) d
    ..s infoStr=$p(patInfo,"^",7)_"^"_$p(patInfo,"^",5)_"^"_$p(patInfo,"^",14)_"^"_EpisodeID_"^"_noteStr
    ..;i (sTime>=$p(^DHCNurWardShiftTime,"^",1))&&(sTime<$p(^DHCNurWardShiftTime,"^",2)) d
	..;.s ^DHCNurExchageType(userId,admDate,EpisodeID,"手术","白班")=infoStr
    ..s ^DHCNurExchageType(userId,admDate,EpisodeID,"手术",wordType)=infoStr

    ..s ^DHCNurExchage(userId,$ZD(admDate,3),"手术",operSum)=infoStr
    ..;s ^lftmp(userId,$ZD(admDate,3),"手术",operSum)=^DHCNurExchage(userId,$ZD(admDate,3),"手术",operSum)
    s HasSaveFlag=..GetHasDeleteFlag(userId,admDate,"明日手术",EpisodeID,wordType)
    q:(HasSaveFlag=1)
    s noteStr=""
    s operSumFlag=..IfExistOPOrder(admDate+1,EpisodeID, "ZT0026^ZT0027",sTime,eTime)
    ;s isCancel=..IfExistOrder(admDate,EpisodeID, "N3161",sTime,eTime)
    i operSumFlag'=0 d
    .i (sTime>=$p(^DHCNurWardShiftTime,"^",1))&&(sTime<$p(^DHCNurWardShiftTime,"^",2)) s noteStr=operSumFlag
    .e  s noteStr="^"_operSumFlag
    s hasNewLongFlag =..HaveNewLongOrder(admDate+1,EpisodeID, "",sTime,eTime)  //N0108^N3149^N3148
    if hasNewLongFlag'=0 d
    .s OPInfo=..getFKOPInfo(hasNewLongFlag)
    .i (sTime>=$p(^DHCNurWardShiftTime,"^",1))&&(sTime<$p(^DHCNurWardShiftTime,"^",2)) s noteStr=OPInfo
    .e  s noteStr="^"_OPInfo
	
    s patInfo=..PatInfo1(EpisodeID)
    s $p(patInfo,"^",7)=..GetWardLastBed(EpisodeID,wardId)
    i ((operSumFlag'=0)||(hasNewLongFlag'=0)) d
    .s infoStr=$p(patInfo,"^",7)_"^"_$p(patInfo,"^",5)_"^"_$p(patInfo,"^",14)_"^"_EpisodeID_"^"_noteStr
    .;i (sTime>=$p(^DHCNurWardShiftTime,"^",1))&&(sTime<$p(^DHCNurWardShiftTime,"^",2)) d
	.;.s ^DHCNurExchageType(userId,admDate+1,EpisodeID,"明日手术","白班")=infoStr
    .s ^DHCNurExchageType(userId,admDate+1,EpisodeID,"明日手术",wordType)=infoStr

    .s ^DHCNurExchage(userId,$ZD(admDate+1,3),"明日手术",tomorrowOperSum)=infoStr
	
	q ""
}

ClassMethod GetWardItemSummaryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetWardItemSummaryExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

ClassMethod GetWardItemSummaryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetWardItemSummaryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod getPatWard(adm, date) As %String
{
	n (adm, date)
	s childSub=0
	f  s childSub=$o(^PAADM(adm,"TRANS",childSub)) q:childSub=""  d
	.s startDate=$p(^PAADM(adm,"TRANS",childSub),"^",1)
	.s endDate=$p(^PAADM(adm,"TRANS",childSub),"^",3)
	.q:(startDate>(date))
	.q:(endDate<date)&(endDate'="")
	.s wardDr=$p(^PAADM(adm,"TRANS",childSub),"^",9)
	.q:wardDr=""
	q $g(wardDr)
}

/// EpisodeID就诊号
/// ordDate 医嘱日期
/// ArcimCodes  医嘱的代码的组合,如:"c001^003"
/// 判断ordDate EpisodeID是否有ArcimCodes医嘱
ClassMethod IfExistLongOrder(ordDate, EpisodeID, arcimCodes, sTime = "", eTime = "", wardId) As %String
{
	//w ##class(web.DHCNurShiftExchage).IfExistLongOrder(63267,2541198,"N0303^N0304",25201,68400)
	n (ordDate,EpisodeID,arcimCodes,sTime,eTime,wardId)
	s ret=0
	q:EpisodeID="" ret
	s num=$l(arcimCodes,"^")
	f i=1:1:num d
	.q:ret=1
	.s code=$p(arcimCodes,"^",i)
	.q:code=""
	.s rowId=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(code),""))
	.q:rowId=""
	.s rowId=rowId_"||"_"1"
	.s oeordId=$o(^OEORD(0,"Adm",EpisodeID,""))
	.q:oeordId=""
	
	.s oeoriSub=""
	.f  s oeoriSub=$o(^OEORDi(0,"ARCIM",oeordId,rowId,ordDate,oeoriSub)) q:oeoriSub=""  d
	..q:'$d(^OEORD(oeordId,"I",oeoriSub,1))
	..s curDocFlag=##Class(web.DHCNurCom).OrdWardLinkDoc(wardId,"DOCTOR","",oeordId_"||"_oeoriSub)
	..q:curDocFlag="N"
	..s statDr=$p(^OEORD(oeordId,"I",oeoriSub,1),"^",13)
	..s sttTime=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",10)
	..s xDate=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",34)
    ..s xTime=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",15)
	..//s ^ypzTmp("time",code,EpisodeID)=statDr_"/"_sttTime_"/"_ordDate_"/"_xDate_"/"_xTime
	..s fillerno=$p($g(^OEORD(oeordId,"I",oeoriSub,9)),"^",12)
	..;i fillerno'="" s sttTime=0
	..;i fillerno'="" s sTime=0
	..;b ;01
	..;q:sttTime<sTime //如果注释，白班夜班都统计
	..q:sttTime>eTime
	..;b //
	..i (statDr'=4)&(statDr'=11)&(statDr'=2) s ret=1 q
	..q:(statDr=11)||(statDr=2)
    ..i xDate>ordDate s ret=1 q
    ..i xDate<ordDate s ret=0 q
    
    ..i (xDate=ordDate)&&(sTime=(+^DHCNurWardShiftTime))&&(xTime<(+^DHCNurWardShiftTime)) s ret=0 q //25200之前停止白班不算
    ..i (xDate=ordDate)&&(eTime>($p(^DHCNurWardShiftTime,",",2)))&&(xTime<($p(^DHCNurWardShiftTime,",",2))) s ret=0 q //68400之前停止夜班不算
	..s ret=1 q
	q ret
}

// 医生是否给此人开过某条临时医嘱

ClassMethod IfExistTempOrderEver(EpisodeID, arcimCodes) As %String
{
	s ret=0
	q:EpisodeID="" ret
	s num=$l(arcimCodes,"^")
	f i=1:1:num d
	.q:ret=1
	.s code=$p(arcimCodes,"^",i)
	.q:code=""
	.s rowId=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(code),""))
	.q:rowId=""
	.s rowId=rowId_"||"_"1"
	.s oeordId=$o(^OEORD(0,"Adm",EpisodeID,""))
	.q:oeordId=""
	
	.s ordDate=0
	.f  s ordDate=$o(^OEORDi(0,"ARCIM",oeordId,rowId,ordDate)) q:(ordDate="")||(ret=1)  d
	..s oeoriSub=""
	..f  s oeoriSub=$o(^OEORDi(0,"ARCIM",oeordId,rowId,ordDate,oeoriSub)) q:(oeoriSub="")||(ret=1)  d
	
	...q:'$d(^OEORD(oeordId,"I",oeoriSub,1))
	...s statDr=$p(^OEORD(oeordId,"I",oeoriSub,1),"^",13)
	...s xDate=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",34)
	...q:xDate'=""
    ...i (statDr'=4)&(statDr'=11)&(statDr'=2) s ret=1 q
    q ret
}

/// EpisodeID就诊号
/// ordDate 医嘱日期
/// ArcimCodes  医嘱的代码的组合,如:"c001^003"
/// 判断ordDate EpisodeID是否有ArcimCodes医嘱
ClassMethod IfExistOrder(ordDate, EpisodeID, arcimCodes, sTime = "", eTime = "") As %String
{
	//w ##class(web.DHCNurShiftExchage).IfExistOrder(63196,4028834,"ZT0026",68400,86399)
	n (ordDate,EpisodeID,arcimCodes,sTime,eTime)
	s ret=0
	q:EpisodeID="" ret
	s num=$l(arcimCodes,"^")
	f i=1:1:num d
	.q:ret=1
	.s code=$p(arcimCodes,"^",i)
	.q:code=""
	.s rowId=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(code),""))
	.q:rowId=""
	.s rowId=rowId_"||"_"1"
	.s oeordId=$o(^OEORD(0,"Adm",EpisodeID,""))
	.q:oeordId=""
	.s oeoriSub=""
	.f  s oeoriSub=$o(^OEORDi(0,"ARCIM",oeordId,rowId,ordDate,oeoriSub)) q:oeoriSub=""  d
	..q:'$d(^OEORD(oeordId,"I",oeoriSub,1))
	..s statDr=$p(^OEORD(oeordId,"I",oeoriSub,1),"^",13)
	..s sttTime=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",10)
	..s xDate=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",34)
    ..s xTime=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",15)
	..//s ^ypzTmp("time",code,EpisodeID)=statDr_"/"_sttTime_"/"_ordDate_"/"_xDate_"/"_xTime
	..s fillerno=$p($g(^OEORD(oeordId,"I",oeoriSub,9)),"^",12)
	..;i fillerno'="" s sttTime=0
	..//i fillerno'="" s sTime=0
	..;b ;01
	..q:sttTime<sTime //如果注释，白班夜班都统计
	..q:sttTime>eTime
	..i (statDr'=4)&(statDr'=11)&(statDr'=2) s ret=1 q
	..q:(statDr=11)||(statDr=2)
    ..i xDate>ordDate s ret=1 q
    ..i xDate<ordDate s ret=0 q
    ..i xTime'<eTime s ret=1 q
    ..;i (xDate=ordDate)&&(eTime>68399)&&(xTime<68399) s ret=0 q
	q ret
}

/// EpisodeID就诊号
/// ordDate 医嘱日期
/// ArcimCodes  医嘱的代码的组合,如:"c001^003"
/// 判断当天是否有最新的长嘱 返回首条医嘱ID
ClassMethod HaveNewLongOrder(ordDate, EpisodeID, arcimCodes, sTime = "", eTime = "") As %String
{
	//w ##class(web.DHCNurShiftExchage).HaveNewLongOrder(63246,2516383,"N0108",25200,68400)
	n (ordDate,EpisodeID,arcimCodes,sTime,eTime)
	s ret=0
	q:EpisodeID="" ret
	s num=$l(arcimCodes,"^")
	f i=1:1:num d
	.q:ret=1
	.s code=$p(arcimCodes,"^",i)
	.q:code=""
	.s rowId=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(code),""))
	.q:rowId=""
	.s rowId=rowId_"||"_"1"
	.s oeordId=$o(^OEORD(0,"Adm",EpisodeID,""))
	.q:oeordId=""
	.s oeoriSub=""
	.f  s oeoriSub=$o(^OEORDi(0,"ARCIM",oeordId,rowId,ordDate,oeoriSub)) q:(oeoriSub="")||(ret'=0)  d
	..q:'$d(^OEORD(oeordId,"I",oeoriSub,1))
	..s statDr=$p(^OEORD(oeordId,"I",oeoriSub,1),"^",13)
	..s sttTime=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",10)
	..s xDate=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",34)
    ..s xTime=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",15)
	..//s ^ypzTmp("time",code,EpisodeID)=statDr_"/"_sttTime_"/"_ordDate_"/"_xDate_"/"_xTime
	..s fillerno=$p($g(^OEORD(oeordId,"I",oeoriSub,9)),"^",12)
	..q:fillerno'="" //只取新长嘱
	..//i fillerno'="" s sTime=0
	..;b ;01
	..q:sttTime<sTime //如果注释，白班夜班都统计
	..q:sttTime>eTime
	..i (statDr'=4)&(statDr'=11)&(statDr'=2) s ret=oeordId_"||"_oeoriSub q
	..;i (statDr'=4)&(statDr'=11)&(statDr'=2) s ret=1 q
	..;q:(statDr=11)||(statDr=2)
    ..;i xDate>ordDate s ret=1 q
    ..;i xDate<ordDate s ret=0 q
    ..;i xTime'<eTime s ret=1 q
    ..;i (xDate=ordDate)&&(eTime>68399)&&(xTime<68399) s ret=0 q
	q ret
}

ClassMethod IfOperApp(admDate, EpisodeID, sTime = "", eTime = "") As %String
{
	s retOpFlag=0
	q:(admDate="")!(EpisodeID="") 0
	s opaRowId=""
    f  s opaRowId=$O(^DHCANOPArrange(0,"Adm",EpisodeID,opaRowId)) q:opaRowId=""  d
    .s opaStartDate=$P($G(^DHCANOPArrange(opaRowId)),"^",14)
    .s opaStartTime=$P($G(^DHCANOPArrange(opaRowId)),"^",15)
    .q:(opaStartDate="")!(opaStartDate'=admDate)
    .q:opaStartTime<sTime
    .q:opaStartTime'<eTime
    .s retOpFlag=1
    q retOpFlag
}

ClassMethod GetTransNum(admDate, wardId, userId = "", sTime = "", eTime = "") As %String
{
	
   /* .s admTime=""
    .f  s admTime=$O(^PAADMi("TransDateTime",admDate,admTime)) q:admTime=""  d
    ..s EpisodeID="" 
    ..f  s EpisodeID=$O(^PAADMi("TransDateTime",admDate,admTime,EpisodeID)) q:EpisodeID=""  d
    ...s paAdmDate=$p($g(^PAADM(EpisodeID)),"^",6)
    ...q:paAdmDate=admDate
    ...s childSub=""
    ...s isTransIn=0
    ...f  s childSub=$O(^PAADMi("TransDateTime",admDate,admTime,EpisodeID,childSub)) q:childSub=""  d
    ....s transEndDate=$P($G(^PAADM(EpisodeID,"TRANS",childSub)),"^",3)
    ....//q:transEndDate'=""
    ....s transWardId=$P($G(^PAADM(EpisodeID,"TRANS",childSub)),"^",9)
    ....s outChildSub=$O(^PAADM(EpisodeID,"TRANS",childSub),-1)
    ....q:outChildSub=""
    ....s outWardId=$P($G(^PAADM(EpisodeID,"TRANS",outChildSub)),"^",9)
    ....q:transWardId'=wardId
    ....q:transWardId=outWardId
    ....s isTransIn=1
    ...i isTransIn=1 s transInSum=transInSum+1*/
	q:(admDate="")!(wardId="") "^"
	s transInSum=0,transOutSum=0
    s EpisodeID=""
    f  s EpisodeID=$O(^PAADMi("TransEndDate",admDate,EpisodeID)) q:EpisodeID=""  d
    .s isWardPat=0,isTransOut=0,isTransIn=0
    .s paVisit=$p($g(^PAADM(EpisodeID)),"^",20)
    .q:paVisit="D"
    .//s paDisDate=$p($g(^PAADM(EpisodeID)),"^",17)
    .//s paAdmDate=$p($g(^PAADM(EpisodeID)),"^",6)
    .//q:(paDisDate=admDate)!(paAdmDate=admDate)
    .s childSub=""
    .f  s childSub=$O(^PAADMi("TransEndDate",admDate,EpisodeID,childSub)) q:(isWardPat=1)!(childSub="")  d
    ..s transWardId=$P($G(^PAADM(EpisodeID,"TRANS",childSub)),"^",9)
    ..q:transWardId'=wardId
    ..i transWardId=wardId s isWardPat=1
    ..
    ..i transWardId=wardId d 
    ...s outChildSub=childSub
    ...f  s outChildSub=$O(^PAADM(EpisodeID,"TRANS",outChildSub),-1) q:(isTransOut=1)!(outChildSub="")  d
    ....s tranDate=$P($G(^PAADM(EpisodeID,"TRANS",outChildSub)),"^",3)
    ....q:tranDate'=admDate
    ....s tranTime=$P($G(^PAADM(EpisodeID,"TRANS",outChildSub)),"^",2)
    ....q:tranTime<sTime
    ....q:tranTime'<eTime
    ....s outWardId=$P($G(^PAADM(EpisodeID,"TRANS",outChildSub)),"^",9)
    ....i outWardId'=wardId s isTransOut=1
    ...
    ...s inChildSub=childSub
    ...f  s inChildSub=$O(^PAADM(EpisodeID,"TRANS",inChildSub)) q:(isTransIn=1)!(inChildSub="")  d
    ....s tranDate=$P($G(^PAADM(EpisodeID,"TRANS",inChildSub)),"^",1)
    ....q:tranDate'=admDate
    ....s tranTime=$P($G(^PAADM(EpisodeID,"TRANS",inChildSub)),"^",2)
    ....q:tranTime<sTime
    ....q:tranTime'<eTime
    ....s inWardId=$P($G(^PAADM(EpisodeID,"TRANS",inChildSub)),"^",9)
    ....i inWardId'=wardId s isTransIn=1
	.i isTransIn=1 d 
	..s transInSum=transInSum+1
	..s patInfo=..PatInfo1(EpisodeID)
    ..s ^DHCNurExchage(userId,$ZD(admDate,3),"转入",transInSum)=$p(patInfo,"^",7)_"^"_$p(patInfo,"^",5)_"^"_$p(patInfo,"^",14)_"^"_EpisodeID
	.i isTransOut=1 d 
	..s transOutSum=transOutSum+1
	..s patInfo=..PatInfo1(EpisodeID)
    ..s ^DHCNurExchage(userId,$ZD(admDate,3),"转出",transOutSum)=$p(patInfo,"^",7)_"^"_$p(patInfo,"^",5)_"^"_$p(patInfo,"^",14)_"^"_EpisodeID 
	q transInSum_"^"_transOutSum
}

ClassMethod PatInfo1(curId) As %String
{
	//病人基本信息;入参:登记号或OEORI_ROWID,根据最后一个ADM取信息
    n (curId)
    s admId=curId
    s papmiId=+^PAADM(admId)
    s ctlocId=$p(^PAADM(admId),"^",4)
	s ctlocDesc=$p(^CTLOC(+ctlocId),"^",2)	
	s doc=$p(^PAADM(admId),"^",9)
	if doc'="" s DocDes=$P(^CTPCP(doc,1),"^",2)
    s roomId=$p(^PAADM(admId),"^",69)
    i (roomId'="") s room=$p(^PAROOM(roomId),"^",2)
    s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
    s MedCareNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)
    s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
    i $d(^PAPER(papmiId,"PAT",3)) s safetyNetCardNo=$p(^PAPER(papmiId,"PAT",3),"^",4) ;病案号
    e  s safetyNetCardNo=""
    s sex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
    S homeAddres=$g(^PAPER(papmiId,"PER","ADD")) // 住址
    s homeTel=$p($g(^PAPER(papmiId,"PER",1)),"^",11)  //家庭电话
    s workTel=$p($g(^PAPER(papmiId,"PER",1)),"^",9)   //工作电话
    s handtel=$p($g(^PAPER(papmiId,"PER",4)),"^",21)  //手机
    s bedSub=$p($p($g(^PAADM(admId)),"^",73),"||",2)
    s curWardId=$p($g(^PAADM(admId)),"^",70)
    i curWardId'="" s wardDesc=$p(^PAWARD(curWardId),"^",1)
    i bedSub'="" s bedCode=$p($g(^PAWARD(curWardId,"BED",bedSub)),"^",1)
    e  s bedCode=""
    s birth=$p($g(^PAPER(papmiId,"ALL")),"^",6)
    ;s age=##class(web.DHCCLCom).CalAge(birth,+$h)
    s age=##class(web.DHCBillInterface).GetPapmiAge(papmiId,curId)
    //s age=$p(age,"Y",1)
    //ctlocDesc未取后半部分 ypz 060522
    s mrAdm=$p(^PAADM(admId),"^",61)
    s mrDiagnos=""
    s subChild=0
	f  s subChild=$o(^MR(mrAdm,"DIA",subChild)) q:subChild=""  d
	.s typChildSub=0
	.s typChildSub=$o(^MR(mrAdm,"DIA",subChild,"TYP",typChildSub)) q:typChildSub=""  d
	..s typDr=$p(^MR(mrAdm,"DIA",subChild,"TYP",typChildSub),"^",1)
	..//b ;01
	..q:typDr'=12
	..s ICDCodeDr=$p(^MR(mrAdm,"DIA",subChild),"^",1)
	..i ICDCodeDr'="" s mrDiagnos=mrDiagnos_" "_$p($g(^MRC("ID",ICDCodeDr)),"^",2)
	..//b ;02
	..i $d(^MR(mrAdm,"DIA",subChild,"DES",1))  d 
	...s:(^MR(mrAdm,"DIA",subChild,"DES",1)'="") mrDiagnos=mrDiagnos_"("_^MR(mrAdm,"DIA",subChild,"DES",1)_")"
	//b ;03
	i mrDiagnos="" s mrDiagnos=##class(web.DHCCLCom).GetDiag(curId)
    s retStr=regNo_"^"_ctlocDesc_"^"_$g(room)_"^"_$g(sex)_"^"_$g(patName)_"^"_$g(safetyNetCardNo)_"^"_$g(bedCode)_"^"_$g(age)_"^"_$g(wardDesc)_"^"_homeAddres_"^"_homeTel_"  "_workTel_"  "_handtel_"^"_$G(DocDes)_"^"_MedCareNo_"^"_$G(mrDiagnos)
    q retStr
}

// Query FindShiftExchageDetail(parr As %String) As %Query(ROWSPEC = "type11:%String,bedCode:%String,patName:%String,diagnos:%String,dayNote:%String,nightNote:%String,par:%String,rw:%String,EpisodeID:%String,workType:%String")

Query FindShiftExchageDetail(parr As %String) As %Query(ROWSPEC = "Item101:%String,Item102:%String,Item103:%String,Item104:%String,Item105:%String,Item106:%String,par:%String,rw:%String,EpisodeID:%String,Item111:%String")
{
}

ClassMethod FindShiftExchageDetailExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//s ^NWLog("Find",$zd(+$h,3),$zt($p($h,",",2)))=parr
 	s ^TMP("wl20170319")=parr
 	//s ^nw("1")=parr
 	//d ##class(%ResultSet).RunQuery("web.DHCNurShiftExchage","FindShiftExchageDetail","89^2017-03-20^3880^")
 	s lodId=$P(parr,"^",1)
 	s DateDetail=$P(parr,"^",2)
 	s:DateDetail["/" DateDetail=$zdh(DateDetail,4),DateDetail=$zd(DateDetail,3)
 	s userID=$P(parr,"^",3)
 	s workType=$P(parr,"^",4)
 	s flag=$P(parr,"^",5)
 	s sumDate=$zdh(DateDetail,3)
 	i (lodId="")!(DateDetail="") Set qHandle=$lb(0,repid,0) Quit $$$OK
 	i +DateDetail=DateDetail d
 	.s DateDetail=$zd(DateDetail,3)
 	//日期是当天 并且时间 小于7点  日期-1
 	if ($ZDH(DateDetail,3)=+$h)&&($P($h,",",2)<$p(^DHCNurWardShiftTime,"^",1)) s DateDetail=$ZD($ZDH(DateDetail,3)-1,3)
	k ^TMP(repid,"tempbedcode")
	s ^lf("count")=0
	//判断是否保存过汇总记录
	s par=$O(^User.DHCNurWardShiftI("LocDate"," "_lodId,$ZDH(DateDetail,3),""))
	s ^lf("parref")=par
	//s par=""
	i par'="" 
	{   
	    b ;01
		s rw="" f  s rw=$O(^User.DHCNurWardShiftD(par,"ChildRec",rw)) q:rw=""  d
		.s type=$ListGet(^User.DHCNurWardShiftD(par,"ChildRec",rw),5)			//Item101
		.i type="" s type="在院"
		.s bedCode=$ListGet(^User.DHCNurWardShiftD(par,"ChildRec",rw),6)		//Item102
		.i bedCode="" s bedCode="z"
		.s ^TMP(repid,"tempbedcode",type,"A"_bedCode,rw)=""
		b ;sort
		s TypeStr="出院^转出^死亡^入院^转入^分娩^手术^今日手术^明日手术^病重^病危^在院"
		f i=1:1:$L(TypeStr) d
		.s CurType=$P(TypeStr,"^",i)
		.q:CurType=""
		.s CurBedCode="" f  s CurBedCode=$O(^TMP(repid,"tempbedcode",CurType,CurBedCode)) q:CurBedCode=""  d
		..s rw="" f  s rw=$O(^TMP(repid,"tempbedcode",CurType,CurBedCode,rw)) q:rw=""  d
		...;s type=$ListGet(^User.DHCNurWardShiftD(par,"ChildRec",rw),5)	
		...s type=CurType	//Item101
		...s subWorkType=$ListGet(^User.DHCNurWardShiftD(par,"ChildRec",rw),35)	
		...;q:(subWorkType'=workType)&&(subWorkType'="")
		...s bedCode=$ListGet(^User.DHCNurWardShiftD(par,"ChildRec",rw),6)		//Item102
		...s patName=$ListGet(^User.DHCNurWardShiftD(par,"ChildRec",rw),7)		//Item103
		...s diagnos=$ListGet(^User.DHCNurWardShiftD(par,"ChildRec",rw),8)		//Item104
		...s dayNote=$ListGet(^User.DHCNurWardShiftD(par,"ChildRec",rw),9)		//Item105
		...s nightNote=$ListGet(^User.DHCNurWardShiftD(par,"ChildRec",rw),10)		//Item106
		...s EpisodeID=$ListGet(^User.DHCNurWardShiftD(par,"ChildRec",rw),11)		//Item107
		...s deleteFlag=$ListGet(^User.DHCNurWardShiftD(par,"ChildRec",rw),14)		//Item107
		...q:(flag'=deleteFlag)
		...s workType=$ListGet(^User.DHCNurWardShiftD(par,"ChildRec",rw),15)		//Item107
		...;b //type
		...s killDate=DateDetail
		...s killType=type
		...i type="明日手术" s killDate=$zdh(DateDetail,3)+1
		...i type="今日手术" s killType="手术"
		...i workType="白班"  d
		....q:EpisodeID=""
		....if $D(^DHCNurExchage(userID,killDate,EpisodeID,killType,"夜班")) d
		.....k ^DHCNurExchage(userID,killDate,EpisodeID,killType,"夜班")
		.....s workType="白夜班"
		...i killType="在院" d  
		....s work=..GetType(DateDetail)
		....if (work="Night")&&(EpisodeID'="")  d
		.....if ($d(^DHCNurInHospital(userID,EpisodeID))) d 
		......i workType="白班" s workType="白夜班"
		....i EpisodeID'="" d
		.....if $d(^DHCNurExchageType(userID,$zdh(killDate,3),EpisodeID,killType,"夜班")) d
		......k ^DHCNurExchageType(userID,$zdh(killDate,3),EpisodeID,killType,"夜班")
		....e  d
		.....if work="Day" s workType="白班"
		...i (killType="病重")||(killType="病危") d 
		....i EpisodeID'="" d
		.....s work=..GetType(DateDetail)
		.....if work="Night"  d
		......i $d(^DHCNurExchageType(userID,$zdh(killDate,3),EpisodeID,killType,"夜班")) d 
		.......k ^DHCNurExchageType(userID,$zdh(killDate,3),EpisodeID,killType,"夜班")
		.......i workType="白班" s workType="白夜班"
		......i $d(^DHCNurExchageType(userID,$zdh(killDate,3)+1,EpisodeID,killType,"夜班")) d 
		.......k ^DHCNurExchageType(userID,$zdh(killDate,3)+1,EpisodeID,killType,"夜班")
		.......i workType="白班" s workType="白夜班"
		...d OutDetail
		k ^TMP(repid,"tempbedcode")
	}
	s rw=""
	b //2
	 	i userID="" s userID=%session.Data("LOGON.USERID")
		s dayNote="",nightNote=""
		s startDate=$zdh(DateDetail,3)
		k ^TMPOUTSORT
	s admDate="" f  s admDate=$o(^DHCNurExchageType(userID,admDate)) q:admDate=""  d
	.s EpisodeID="" f  s EpisodeID=$o(^DHCNurExchageType(userID,admDate,EpisodeID)) q:EpisodeID=""  d
	..s eventType="" f  s eventType=$o(^DHCNurExchageType(userID,admDate,EpisodeID,eventType)) q:eventType=""  d
	...s workType="" f  s workType=$o(^DHCNurExchageType(userID,admDate,EpisodeID,eventType,workType)) q:workType=""  d
	....s ^TMPOUTSORT(userID,admDate,eventType,EpisodeID,workType)=^DHCNurExchageType(userID,admDate,EpisodeID,eventType,workType)
		f date=startDate:1:(startDate+1) d
		.s DateDetail=date
		.s Type="出院"
		.s num=""
	    .f  s num=$o(^TMPOUTSORT(userID,DateDetail,Type,num)) q:num=""  d
	    ..s workType=""
	    ..f  s workType=$o(^TMPOUTSORT(userID,DateDetail,Type,num,workType)) q:workType=""  d
	    ...s type=Type
	    ...s bedCode=$p(^TMPOUTSORT(userID,DateDetail,Type,num,workType),"^",1)
	    ...s patName=$p(^TMPOUTSORT(userID,DateDetail,Type,num,workType),"^",2)
		...s diagnos=$p(^TMPOUTSORT(userID,DateDetail,Type,num,workType),"^",3)
		...s EpisodeID=$p(^TMPOUTSORT(userID,DateDetail,Type,num,workType),"^",4)
		...i bedCode'="",EpisodeID'="" s ^TMP(repid,"tempbedcode",bedCode,EpisodeID)=""
		...d OutDetail
		.s Type="转出"
		.s num=""
	    .f  s num=$o(^TMPOUTSORT(userID,DateDetail,Type,num)) q:num=""  d
	    ..s workType=""
	    ..f  s workType=$o(^TMPOUTSORT(userID,DateDetail,Type,num,workType)) q:workType=""  d
	    ...s type=Type
	    ...s bedCode=$p(^TMPOUTSORT(userID,DateDetail,Type,num,workType),"^",1)
	    ...s patName=$p(^TMPOUTSORT(userID,DateDetail,Type,num,workType),"^",2)
		...s diagnos=$p(^TMPOUTSORT(userID,DateDetail,Type,num,workType),"^",3)
		...s EpisodeID=$p(^TMPOUTSORT(userID,DateDetail,Type,num,workType),"^",4)
		...i bedCode'="",EpisodeID'="" s ^TMP(repid,"tempbedcode",bedCode,EpisodeID)=""
		...d OutDetail
		.s Type="死亡"
		.s num=""
	    .f  s num=$o(^TMPOUTSORT(userID,DateDetail,Type,num)) q:num=""  d
	    ..s workType=""
	    ..f  s workType=$o(^TMPOUTSORT(userID,DateDetail,Type,num,workType)) q:workType=""  d
	    ...s type=Type
	    ...s bedCode=$p(^TMPOUTSORT(userID,DateDetail,Type,num,workType),"^",1)
	    ...s patName=$p(^TMPOUTSORT(userID,DateDetail,Type,num,workType),"^",2)
		...s diagnos=$p(^TMPOUTSORT(userID,DateDetail,Type,num,workType),"^",3)
		...s EpisodeID=$p(^TMPOUTSORT(userID,DateDetail,Type,num,workType),"^",4)
		...i bedCode'="",EpisodeID'="" s ^TMP(repid,"tempbedcode",bedCode,EpisodeID)=""
		...d OutDetail
		.s Type="入院"
		.s num=""
	   .f  s num=$o(^TMPOUTSORT(userID,DateDetail,Type,num)) q:num=""  d
	    ..s workType=""
	    ..f  s workType=$o(^TMPOUTSORT(userID,DateDetail,Type,num,workType)) q:workType=""  d
	    ...s type=Type
	    ...s bedCode=$p(^TMPOUTSORT(userID,DateDetail,Type,num,workType),"^",1)
	    ...s patName=$p(^TMPOUTSORT(userID,DateDetail,Type,num,workType),"^",2)
		...s diagnos=$p(^TMPOUTSORT(userID,DateDetail,Type,num,workType),"^",3)
		...s EpisodeID=$p(^TMPOUTSORT(userID,DateDetail,Type,num,workType),"^",4)
		...s dayNote=$p(^TMPOUTSORT(userID,DateDetail,Type,num,workType),"^",5)
		...s nightNote=$p(^TMPOUTSORT(userID,DateDetail,Type,num,workType),"^",6)
		...i bedCode'="",EpisodeID'="" s ^TMP(repid,"tempbedcode",bedCode,EpisodeID)=""  
		...d OutDetail
		...s (dayNote,nightNote)=""
		.s Type="转入"
		.s num=""
	    .f  s num=$o(^TMPOUTSORT(userID,DateDetail,Type,num)) q:num=""  d
	    ..s workType=""
	    ..f  s workType=$o(^TMPOUTSORT(userID,DateDetail,Type,num,workType)) q:workType=""  d
	    ...s type=Type
	    ...s bedCode=$p(^TMPOUTSORT(userID,DateDetail,Type,num,workType),"^",1)
	    ...s patName=$p(^TMPOUTSORT(userID,DateDetail,Type,num,workType),"^",2)
		...s diagnos=$p(^TMPOUTSORT(userID,DateDetail,Type,num,workType),"^",3)
		...s EpisodeID=$p(^TMPOUTSORT(userID,DateDetail,Type,num,workType),"^",4)
		...s dayNote=$p(^TMPOUTSORT(userID,DateDetail,Type,num,workType),"^",5)
		...s nightNote=$p(^TMPOUTSORT(userID,DateDetail,Type,num,workType),"^",6)
		...i bedCode'="",EpisodeID'="" s ^TMP(repid,"tempbedcode",bedCode,EpisodeID)=""
		...d OutDetail
		.s Type="分娩"
		.s num=""
	    .f  s num=$o(^TMPOUTSORT(userID,DateDetail,Type,num)) q:num=""  d
	    ..s workType=""
	    ..f  s workType=$o(^TMPOUTSORT(userID,DateDetail,Type,num,workType)) q:workType=""  d
	    ...s type=Type
	    ...s bedCode=$p(^TMPOUTSORT(userID,DateDetail,Type,num,workType),"^",1)
	    ...s patName=$p(^TMPOUTSORT(userID,DateDetail,Type,num,workType),"^",2)
		...s diagnos=$p(^TMPOUTSORT(userID,DateDetail,Type,num,workType),"^",3)
		...s EpisodeID=$p(^TMPOUTSORT(userID,DateDetail,Type,num,workType),"^",4)
		...s dayNote=$p(^TMPOUTSORT(userID,DateDetail,Type,num,workType),"^",5)
		...s nightNote=$p(^TMPOUTSORT(userID,DateDetail,Type,num,workType),"^",6)
		...i bedCode'="",EpisodeID'="" s ^TMP(repid,"tempbedcode",bedCode,EpisodeID)=""
		...d OutDetail
		.s Type="手术"
		.s num=""
		.b //ss
	    .f  s num=$o(^TMPOUTSORT(userID,DateDetail,Type,num)) q:num=""  d
	    ..s workType=""
	    ..f  s workType=$o(^TMPOUTSORT(userID,DateDetail,Type,num,workType)) q:workType=""  d
	    ...s type="今日手术" //Type
	    ...s bedCode=$p(^TMPOUTSORT(userID,DateDetail,Type,num,workType),"^",1)
	    ...s patName=$p(^TMPOUTSORT(userID,DateDetail,Type,num,workType),"^",2)
		...s diagnos=$p(^TMPOUTSORT(userID,DateDetail,Type,num,workType),"^",3)
		...s EpisodeID=$p(^TMPOUTSORT(userID,DateDetail,Type,num,workType),"^",4)
		...s dayNote=$p(^TMPOUTSORT(userID,DateDetail,Type,num,workType),"^",5)
		...s nightNote=$p(^TMPOUTSORT(userID,DateDetail,Type,num,workType),"^",6)
		...i bedCode'="",EpisodeID'="" s ^TMP(repid,"tempbedcode",bedCode,EpisodeID)=""
		...b //ssout
		...d OutDetail
		.//DateDetail查询明天是否有手术
		.;s ToDateDetail=$ZD(($ZDH(DateDetail,3)+1),3)
		.s Type="明日手术"
		.s num=""
		.s tomorrowDate=DateDetail+1
	    .f  s num=$o(^TMPOUTSORT(userID,tomorrowDate,Type,num)) q:num=""  d
	    ..s workType=""
	    ..f  s workType=$o(^TMPOUTSORT(userID,tomorrowDate,Type,num,workType)) q:workType=""  d
	    ...s type="明日手术"
	    ...s bedCode=$p(^TMPOUTSORT(userID,tomorrowDate,Type,num,workType),"^",1)
	    ...s patName=$p(^TMPOUTSORT(userID,tomorrowDate,Type,num,workType),"^",2)
		...s diagnos=$p(^TMPOUTSORT(userID,tomorrowDate,Type,num,workType),"^",3)
		...s EpisodeID=$p(^TMPOUTSORT(userID,tomorrowDate,Type,num,workType),"^",4)
		...s dayNote=$p(^TMPOUTSORT(userID,tomorrowDate,Type,num,workType),"^",5)
		...s nightNote=$p(^TMPOUTSORT(userID,tomorrowDate,Type,num,workType),"^",6)
		...i bedCode'="",EpisodeID'="" s ^TMP(repid,"tempbedcode",bedCode,EpisodeID)=""
		...d OutDetail
		
		.s Type="病重"
		.s num=""
	    .f  s num=$o(^TMPOUTSORT(userID,DateDetail,Type,num)) q:num=""  d
	    ..s workType=""
	    ..f  s workType=$o(^TMPOUTSORT(userID,DateDetail,Type,num,workType)) q:workType=""  d
	    ...s type=Type
	    ...s bedCode=$p(^TMPOUTSORT(userID,DateDetail,Type,num,workType),"^",1)
	    ...s patName=$p(^TMPOUTSORT(userID,DateDetail,Type,num,workType),"^",2)
		...s diagnos=$p(^TMPOUTSORT(userID,DateDetail,Type,num,workType),"^",3)
		...s EpisodeID=$p(^TMPOUTSORT(userID,DateDetail,Type,num,workType),"^",4)
		...s dayNote=$p(^TMPOUTSORT(userID,DateDetail,Type,num,workType),"^",5)
		...s nightNote=$p(^TMPOUTSORT(userID,DateDetail,Type,num,workType),"^",6)
		...i bedCode'="",EpisodeID'="" s ^TMP(repid,"tempbedcode",bedCode,EpisodeID)=""
		
		...d OutDetail
		 
		.s Type="病危"
		.s num=""
	    .f  s num=$o(^TMPOUTSORT(userID,DateDetail,Type,num)) q:num=""  d
	    ..s workType=""
	    ..f  s workType=$o(^TMPOUTSORT(userID,DateDetail,Type,num,workType)) q:workType=""  d
	    ...s type=Type
	    ...s bedCode=$p(^TMPOUTSORT(userID,DateDetail,Type,num,workType),"^",1)
	    ...s patName=$p(^TMPOUTSORT(userID,DateDetail,Type,num,workType),"^",2)
		...s diagnos=$p(^TMPOUTSORT(userID,DateDetail,Type,num,workType),"^",3)
		...s EpisodeID=$p(^TMPOUTSORT(userID,DateDetail,Type,num,workType),"^",4)
		...s dayNote=$p(^TMPOUTSORT(userID,DateDetail,Type,num,workType),"^",5)
		...s nightNote=$p(^TMPOUTSORT(userID,DateDetail,Type,num,workType),"^",6)
		...i bedCode'="",EpisodeID'="" s ^TMP(repid,"tempbedcode",bedCode,EpisodeID)=""
		...d OutDetail
		.s Type="在院"
		.s num=""
	    .f  s num=$o(^TMPOUTSORT(userID,DateDetail,Type,num)) q:num=""  d
	    ..s workType=""
	    ..f  s workType=$o(^TMPOUTSORT(userID,DateDetail,Type,num,workType)) q:workType=""  d
	    ...s type=Type
	    ...s bedCode=$p(^TMPOUTSORT(userID,DateDetail,Type,num,workType),"^",1)
	    ...s patName=$p(^TMPOUTSORT(userID,DateDetail,Type,num,workType),"^",2)
		...s diagnos=$p(^TMPOUTSORT(userID,DateDetail,Type,num,workType),"^",3)
		...s EpisodeID=$p(^TMPOUTSORT(userID,DateDetail,Type,num,workType),"^",4)
		...s dayNote=$p(^TMPOUTSORT(userID,DateDetail,Type,num,workType),"^",5)
		...s nightNote=$p(^TMPOUTSORT(userID,DateDetail,Type,num,workType),"^",6)
		...i bedCode'="",EpisodeID'="" s ^TMP(repid,"tempbedcode",bedCode,EpisodeID)=""
		...d OutDetail

		//显示当前病人列表
		s LocType=$p($g(^CTLOC(lodId)),"^",13)
		i (LocType="W")!(LocType="EM") d
		.s WardID=$o(^PAWARD(0,"WARD_LocationDR",lodId,0))
		e  d
		.s WardID=""
		b //zy
		s (dayNote,nightNote)=""
		if (WardID'="")&&(par="") {
			s curRoomId=0 f  s curRoomId=$o(^PAADMi("CurrWard",WardID,curRoomId)) q:curRoomId=""  d
			.s EpisodeID=0 f  s EpisodeID=$o(^PAADMi("CurrWard",WardID,curRoomId,EpisodeID)) q:EpisodeID=""  d
			..s pavisit=$p($g(^PAADM(EpisodeID)),"^",20)
		    ..i pavisit'="A" q
			..s bedSub=$p($g(^PAADM(EpisodeID)),"^",73)
			..q:bedSub=""	//无床位退出
			..s curWardId=$P(bedSub,"||",1)
			..s curBedSub=$P(bedSub,"||",2)
			..q:(curWardId="")!(curBedSub="")
			..s bedCode=$p($g(^PAWARD(curWardId,"BED",curBedSub)),"^",1)
		 	..q:bedCode=""
		 	..i $D(^TMP(repid,"tempbedcode",bedCode,EpisodeID))<1 d
			...s ^TMP(repid,"tempbedcode",bedCode,EpisodeID)=1
			//按床位排序
			s curBedCode=0 f  s curBedCode=$o(^TMP(repid,"tempbedcode",curBedCode)) q:curBedCode=""  d
			.s EpisodeID=0 f  s EpisodeID=$o(^TMP(repid,"tempbedcode",curBedCode,EpisodeID)) q:EpisodeID=""  d
			..q:$G(^TMP(repid,"tempbedcode",curBedCode,EpisodeID))'=1
			..s patInfo=..PatInfo1(EpisodeID)
			..s type=""
			..s bedCode=$p(patInfo,"^",7)
		    ..s patName=$p(patInfo,"^",5)
			..s diagnos=$p(patInfo,"^",14)
			..s ^lf("date")=$P(parr,"^",2)
			..s workType=""
			..s work=..GetType($P(parr,"^",2))
			..if work="Night" s workType="夜班"
			..e  d
			...if work="Day" s workType="白班"
			..d OutDetail
			k ^TMP(repid,"tempbedcode")
		}

		if LocType="E" {
			//医生交班表病人列表
			s patAdmDate="" f  s patAdmDate=$o(^PAADMi("TDepDateTime","I",lodId,patAdmDate)) q:patAdmDate=""  d
		 	.s patAdmTime=0 f  s patAdmTime=$o(^PAADMi("TDepDateTime","I",lodId,patAdmDate,patAdmTime)) q:patAdmTime=""  d
			..s EpisodeID=0 f  s EpisodeID=$o(^PAADMi("TDepDateTime","I",lodId,patAdmDate,patAdmTime,EpisodeID)) q:EpisodeID=""  d
			...s pavisit=$p($g(^PAADM(EpisodeID)),"^",20)
			...q:pavisit'="A"
			...s bedSub=$p($g(^PAADM(EpisodeID)),"^",73)
			...q:bedSub=""	//无床位退出
			...s curWardId=$P(bedSub,"||",1)
			...s curBedSub=$P(bedSub,"||",2)
			...q:(curWardId="")!(curBedSub="")
			...s bedCode=$p($g(^PAWARD(curWardId,"BED",curBedSub)),"^",1)
		 	...q:bedCode=""
		 	...i $D(^TMP(repid,"tempbedcode",bedCode,EpisodeID))<1 d
			....s ^TMP(repid,"tempbedcode",bedCode,EpisodeID)=1
			//按床位排序
			s curBedCode=0 f  s curBedCode=$o(^TMP(repid,"tempbedcode",curBedCode)) q:curBedCode=""  d
			.s EpisodeID=0 f  s EpisodeID=$o(^TMP(repid,"tempbedcode",curBedCode,EpisodeID)) q:EpisodeID=""  d
			..q:$G(^TMP(repid,"tempbedcode",curBedCode,EpisodeID))'=1
			..s patInfo=..PatInfo1(EpisodeID)
			..s type=""
			..s bedCode=$p(patInfo,"^",7)
		    ..s patName=$p(patInfo,"^",5)
			..s diagnos=$p(patInfo,"^",14)
			..q:$g(^DHCNurExchagePat(lodId,sumDate,patName))=1
			..d OutDetail
			k ^TMP(repid,"tempbedcode")
		}
		
	;if $D(^DHCNurExchage(userID)) k ^DHCNurExchage(userID)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutDetail
	//set ret="Item101|"_type_"^Item102|"_bedCode_"^Item103|"_patName_"^Item104|"_diagnos_"^Item105|"_dayNote_"^Item106|"_nightNote_"^par|"_par_"^rw|"_rw_"^EpisodeID|"_EpisodeID_"^Item111|"_workType
	set Data=$lb(type,bedCode,patName,diagnos,dayNote,nightNote,par,rw,EpisodeID,workType)
	;w type,bedCode,patName,diagnos,dayNote,nightNote,par,rw,EpisodeID,workType,!
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod TestWard(WardID, par = "") As %String
{
	//d ##class(web.DHCNurShiftExchage).TestWard(48,"")
	
 q ""
}

ClassMethod FindShiftExchageDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindShiftExchageDetailExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

ClassMethod FindShiftExchageDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindShiftExchageDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// w ##class(web.DHCNurShiftExchage).ConvertDateFormat("2010-10-15","1")
ClassMethod ConvertDateFormat(DateStr As %String, Mode As %String) As %String
{
	q:DateStr="" ""	
	s ret=""
	if Mode=0 {
		for i=1:1:$l(DateStr,$C(2)) {
			s DateNum=$P(DateStr,$C(2),i)
			i ret="" s ret=$ZD(DateNum,3)
			e  s ret=ret_","_$ZD(DateNum,3)
		}
	}
	if Mode=1 {
		for i=1:1:$l(DateStr,",") {
			s Date=$P(DateStr,",",i)
			i ret="" s ret=$ZDH(Date,3)
			e  s ret=ret_$C(2)_$ZDH(Date,3)
		}
	}
	if Mode=3 {
		for i=1:1:$l(DateStr,",") {
			s Date=$P(DateStr,",",i)
			i ret="" s ret=$ZDH(Date,4)
			e  s ret=ret_$C(2)_$ZDH(Date,4)
		}
	}
	if Mode=4 {
		for i=1:1:$l(DateStr,$C(2)) {
			s DateNum=$P(DateStr,$C(2),i)
			i ret="" s ret=$ZD(DateNum,4)
			e  s ret=ret_","_$ZD(DateNum,4)
		}
	}
	Q ret
}

/// Description:根据日期与登陆病区查询本病区的病人
/// Table：		PA_Adm,PA_PatMas,PA_Person,PAC_Ward,PAC_Bed
/// Input：		logonLocId: 登陆科室
/// Return：	床号,姓名,性别,年龄,诊断
Query FindCurWardPat(Parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindCurWardPatExecute(ByRef qHandle As %Binary, Parr As %String = "") As %Status
{
	s repid=$i(^CacheTemp)
	s ind=1
	//d ##class(%ResultSet).RunQuery("web.DHCNurShiftExchage","FindCurWardPat","3^2013-11-05^08:00:00")
	s logonLocId=$P(Parr,"^",1)
	s CareDate=$P(Parr,"^",2)
	s CareTime=$P(Parr,"^",3)
	s LocationId=$P(Parr,"^",4)
	//CareTime字段备用/暂固定为8点
	s CareTime="08:00:00"
	s ^objcyf99=Parr
	b
	if (logonLocId=10000)
	{
		s LocId=%session.Data("LOGON.CTLOCID")
		
		s markSetId=0 f  s markSetId=$O(^User.DHCOPChgDepMarkSetD(markSetId)) q:markSetId=""  d
		.s DepSource=$Listget(^User.DHCOPChgDepMarkSetD(markSetId),4)
		.q:DepSource'=LocId
		.s DepTarget=$Listget(^User.DHCOPChgDepMarkSetD(markSetId),5)
		.q:DepTarget=""
		.s AdmDate=0 f  s AdmDate=$o(^PAADMi("CurrLoc",DepTarget,AdmDate)) q:AdmDate=""  d
		..s AdmTime=0 f  s AdmTime=$o(^PAADMi("CurrLoc",DepTarget,AdmDate,AdmTime)) q:AdmTime=""  d
		...s EpisodeID=0 f  s EpisodeID=$o(^PAADMi("CurrLoc",DepTarget,AdmDate,AdmTime,EpisodeID)) q:EpisodeID=""  d
		....s AdmTyp=$p($g(^PAADM(EpisodeID)),"^",2)
		....q:AdmTyp'="E"
		....s pavisit=$p($g(^PAADM(EpisodeID)),"^",20)
		....q:pavisit'="A" 
		....s locId=$p($g(^PAADM(EpisodeID)),"^",4)
		....q:(LocationId'="")&&(LocationId'=locId)
		....s IsLgOrQj=##class(web.DHCEmergency).IfLgOrQj(EpisodeID)
		....q:IsLgOrQj=1
		....s patInfo=##class(web.DHCCLCom).PatInfo("^"_EpisodeID)
	    ....s BedCode=$P(patInfo,"^",7)
	    ....s PatName=$P(patInfo,"^",5)
	    ....s PatSex=$P(patInfo,"^",4)
	    ....s PatAge=$P(patInfo,"^",8)
	    ....s MedCard=$P(patInfo,"^",13)
	    ....s PatDiag=##class(web.DHCCLCom).GetDiag(EpisodeID)  //$P(patInfo,"^",14)
	    ....s aa=..GetShiftExchageInfo(EpisodeID,CareDate,CareTime)
	    ....s aa="BedCode|"_BedCode_"^PatName|"_PatName_"^PatSex|"_PatSex_"^PatAge|"_PatAge_"^PatDiag|"_PatDiag_"^Adm|"_EpisodeID_"^MedCard|"_MedCard_"^"_aa
	    ....d OutRowReg
		
		s AdmDate=0 f  s AdmDate=$o(^PAADMi("CurrLoc",LocId,AdmDate)) q:AdmDate=""  d
		.s AdmTime=0 f  s AdmTime=$o(^PAADMi("CurrLoc",LocId,AdmDate,AdmTime)) q:AdmTime=""  d
		..s EpisodeID=0 f  s EpisodeID=$o(^PAADMi("CurrLoc",LocId,AdmDate,AdmTime,EpisodeID)) q:EpisodeID=""  d
		...s AdmTyp=$p($g(^PAADM(EpisodeID)),"^",2)
		...q:AdmTyp'="E"
		...s pavisit=$p($g(^PAADM(EpisodeID)),"^",20)
		...q:pavisit'="A"
		...s locId=$p($g(^PAADM(EpisodeID)),"^",4)
		...q:(LocationId'="")&&(LocationId'=locId)
		...s IsLgOrQj=##class(web.DHCEmergency).IfLgOrQj(EpisodeID)
		...q:IsLgOrQj=1
		...s patInfo=##class(web.DHCCLCom).PatInfo("^"_EpisodeID)
	    ...s BedCode=$P(patInfo,"^",7)
	    ...s PatName=$P(patInfo,"^",5)
	    ...s PatSex=$P(patInfo,"^",4)
	    ...s PatAge=$P(patInfo,"^",8)
	    ...s MedCard=$P(patInfo,"^",13)
	    ...b
	    ...s PatDiag=##class(web.DHCCLCom).GetDiag(EpisodeID)  //$P(patInfo,"^",14)
	    ...s aa=..GetShiftExchageInfo(EpisodeID,CareDate,CareTime)
	    ...s aa="BedCode|"_BedCode_"^PatName|"_PatName_"^PatSex|"_PatSex_"^PatAge|"_PatAge_"^PatDiag|"_PatDiag_"^Adm|"_EpisodeID_"^MedCard|"_MedCard_"^"_aa
	    ...d OutRowReg
	}
	else
	{
	i logonLocId="" s logonLocId=%session.Data("LOGON.CTLOCID")
 	s logonLocType=$p($g(^CTLOC(logonLocId)),"^",13)
	i (logonLocType="W")!(logonLocType="EM") d
	.s WardID=$o(^PAWARD(0,"WARD_LocationDR",logonLocId,0))
	e  d
	.s WardID=""
	b //
	i WardID="" s ind=1 s qHandle=$lb(0,repid,0) Quit $$$OK
    k ^TMP(repid,"tempbedcode")
	s curRoomId=0 f  s curRoomId=$o(^PAADMi("CurrWard",WardID,curRoomId)) q:curRoomId=""  d
	.s EpisodeID=0 f  s EpisodeID=$o(^PAADMi("CurrWard",WardID,curRoomId,EpisodeID)) q:EpisodeID=""  d
	..s pavisit=$p($g(^PAADM(EpisodeID)),"^",20)
    ..i pavisit'="A" q
	..s bedSub=$p($g(^PAADM(EpisodeID)),"^",73)
	..q:bedSub=""
	..s locId=$p($g(^PAADM(EpisodeID)),"^",4)
	..q:(LocationId'="")&&(LocationId'=locId)
	..s curWardId=$P(bedSub,"||",1)
	..s curBedSub=$P(bedSub,"||",2)
	..s rcflag=$P(^PAWARD(curWardId,"BED",curBedSub),"^",4)
	..q:rcflag="N"
	..q:(curWardId="")!(curBedSub="")
	..s bedCode=$p($g(^PAWARD(curWardId,"BED",curBedSub)),"^",1)
 	..q:bedCode=""
 	..s bedCode=bedCode_"床"
	..s ^TMP(repid,"tempbedcode",bedCode,EpisodeID)=""

	s curBedCode=0 f  s curBedCode=$o(^TMP(repid,"tempbedcode",curBedCode)) q:curBedCode=""  d
	.s EpisodeID=0 f  s EpisodeID=$o(^TMP(repid,"tempbedcode",curBedCode,EpisodeID)) q:EpisodeID=""  d
	..s patInfo=##class(web.DHCCLCom).PatInfo("^"_EpisodeID)
	..//s retStr=regNo_"^"_ctlocDesc_"^"_$g(room)_"^"_$g(sex)_"^"_$g(patName)_"^"_$g(safetyNetCardNo)_"^"_$g(bedCode)_"^"_$g(age)_"^"_$g(wardDesc)_"^"_homeAddres_"^"_homeTel_"  "_workTel_"  "_handtel_"^"_$G(DocDes)_"^"_MedCareNo_"^"_$G(mrDiagnos)
	..s BedCode=$P(patInfo,"^",7)
	..s PatName=$P(patInfo,"^",5)
	..s PatSex=$P(patInfo,"^",4)
	..s PatAge=$P(patInfo,"^",8)
	..s MedCard=$P(patInfo,"^",13)
	..s PatDiag=##class(web.DHCCLCom).GetDiag(EpisodeID)  //$P(patInfo,"^",14)
	..s aa=..GetShiftExchageInfo(EpisodeID,CareDate,CareTime)
	..s aa="BedCode|"_BedCode_"^PatName|"_PatName_"^PatSex|"_PatSex_"^PatAge|"_PatAge_"^PatDiag|"_PatDiag_"^Adm|"_EpisodeID_"^MedCard|"_MedCard_"^"_aa
	..b
	..d OutRowReg
	k ^TMP(repid,"tempbedcode")
	
    }
	s qHandle=$lb(0,repid,0)
	q $$$OK

OutRowReg
	s Data=$lb(aa) //$lb(BedCode,PatName,PatSex,PatAge,PatDiag)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod FindCurWardPatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCurWardPatExecute ]
{
	s AtEnd=$li(qHandle,1)
	s repid=$li(qHandle,2)
	s ind=$li(qHandle,3)
	s ind=$o(^CacheTemp(repid,ind))
	i ind="" {				// if there are no more rows, finish fetching
		s AtEnd=1
		s Row=""
	}
	else {			
		s Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindCurWardPatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCurWardPatExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

/// Description:根据日期与登陆病区查询本病区的病人
/// Table：		PA_Adm,PA_PatMas,PA_Person,PAC_Ward,PAC_Bed
/// Input：		logonLocId: 登陆科室
/// Return：	床号,姓名,性别,年龄,诊断
Query FindCurWardPatNew(Parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindCurWardPatNewExecute(ByRef qHandle As %Binary, Parr As %String = "") As %Status
{
	s repid=$i(^CacheTemp)
	s ind=1
	//d ##class(%ResultSet).RunQuery("web.DHCNurShiftExchage","FindCurWardPat","3^2018-05-05^08:00:00^2018-05-10^08:00:00^")
	s logonLocId=$P(Parr,"^",1)
	s StaDate=$P(Parr,"^",2)
	s StaTime=$P(Parr,"^",3)
	s EnDate=$P(Parr,"^",4)
	s LocationId=$P(Parr,"^",5)
	//CareTime字段备用/暂固定为8点
	//s StaTime="08:00:00"
	
	s ^objcyf99=Parr
	b
	if (logonLocId=10000)
	{
		s LocId=%session.Data("LOGON.CTLOCID")
		
		s markSetId=0 f  s markSetId=$O(^User.DHCOPChgDepMarkSetD(markSetId)) q:markSetId=""  d
		.s DepSource=$Listget(^User.DHCOPChgDepMarkSetD(markSetId),4)
		.q:DepSource'=LocId
		.s DepTarget=$Listget(^User.DHCOPChgDepMarkSetD(markSetId),5)
		.q:DepTarget=""
		.s AdmDate=0 f  s AdmDate=$o(^PAADMi("CurrLoc",DepTarget,AdmDate)) q:AdmDate=""  d
		..s AdmTime=0 f  s AdmTime=$o(^PAADMi("CurrLoc",DepTarget,AdmDate,AdmTime)) q:AdmTime=""  d
		...s EpisodeID=0 f  s EpisodeID=$o(^PAADMi("CurrLoc",DepTarget,AdmDate,AdmTime,EpisodeID)) q:EpisodeID=""  d
		....s AdmTyp=$p($g(^PAADM(EpisodeID)),"^",2)
		....q:AdmTyp'="E"
		....s pavisit=$p($g(^PAADM(EpisodeID)),"^",20)
		....q:pavisit'="A" 
		....s locId=$p($g(^PAADM(EpisodeID)),"^",4)
		....q:(LocationId'="")&&(LocationId'=locId)
		....s IsLgOrQj=##class(web.DHCEmergency).IfLgOrQj(EpisodeID)
		....q:IsLgOrQj=1
		....s patInfo=##class(web.DHCCLCom).PatInfo("^"_EpisodeID)
	    ....s BedCode=$P(patInfo,"^",7)
	    ....s PatName=$P(patInfo,"^",5)
	    ....s PatSex=$P(patInfo,"^",4)
	    ....s PatAge=$P(patInfo,"^",8)
	    ....s MedCard=$P(patInfo,"^",13)
	    ....s PatDiag=##class(web.DHCCLCom).GetDiag(EpisodeID)  //$P(patInfo,"^",14)
	    ....s aa=..GetShiftExchageInfoNew(EpisodeID,StaDate,EnDate,StaTime)
	    ....s aa="BedCode|"_BedCode_"^PatName|"_PatName_"^PatSex|"_PatSex_"^PatAge|"_PatAge_"^PatDiag|"_PatDiag_"^Adm|"_EpisodeID_"^MedCard|"_MedCard_"^"_aa
	    ....d OutRowRegNew
		
		s AdmDate=0 f  s AdmDate=$o(^PAADMi("CurrLoc",LocId,AdmDate)) q:AdmDate=""  d
		.s AdmTime=0 f  s AdmTime=$o(^PAADMi("CurrLoc",LocId,AdmDate,AdmTime)) q:AdmTime=""  d
		..s EpisodeID=0 f  s EpisodeID=$o(^PAADMi("CurrLoc",LocId,AdmDate,AdmTime,EpisodeID)) q:EpisodeID=""  d
		...s AdmTyp=$p($g(^PAADM(EpisodeID)),"^",2)
		...q:AdmTyp'="E"
		...s pavisit=$p($g(^PAADM(EpisodeID)),"^",20)
		...q:pavisit'="A"
		...s locId=$p($g(^PAADM(EpisodeID)),"^",4)
		...q:(LocationId'="")&&(LocationId'=locId)
		...s IsLgOrQj=##class(web.DHCEmergency).IfLgOrQj(EpisodeID)
		...q:IsLgOrQj=1
		...s patInfo=##class(web.DHCCLCom).PatInfo("^"_EpisodeID)
	    ...s BedCode=$P(patInfo,"^",7)
	    ...s PatName=$P(patInfo,"^",5)
	    ...s PatSex=$P(patInfo,"^",4)
	    ...s PatAge=$P(patInfo,"^",8)
	    ...s MedCard=$P(patInfo,"^",13)
	    ...b
	    ...s PatDiag=##class(web.DHCCLCom).GetDiag(EpisodeID)  //$P(patInfo,"^",14)
	    ...s aa=..GetShiftExchageInfoNew(EpisodeID,StaDate,EnDate,StaTime)
	    ...s aa="BedCode|"_BedCode_"^PatName|"_PatName_"^PatSex|"_PatSex_"^PatAge|"_PatAge_"^PatDiag|"_PatDiag_"^Adm|"_EpisodeID_"^MedCard|"_MedCard_"^"_aa
	    ...d OutRowRegNew
	}
	else
	{
	i logonLocId="" s logonLocId=%session.Data("LOGON.CTLOCID")
 	s logonLocType=$p($g(^CTLOC(logonLocId)),"^",13)
	i (logonLocType="W")!(logonLocType="EM") d
	.s WardID=$o(^PAWARD(0,"WARD_LocationDR",logonLocId,0))
	e  d
	.s WardID=""
	b //
	i WardID="" s ind=1 s qHandle=$lb(0,repid,0) Quit $$$OK
    k ^TMP(repid,"tempbedcode")
	s curRoomId=0 f  s curRoomId=$o(^PAADMi("CurrWard",WardID,curRoomId)) q:curRoomId=""  d
	.s EpisodeID=0 f  s EpisodeID=$o(^PAADMi("CurrWard",WardID,curRoomId,EpisodeID)) q:EpisodeID=""  d
	..s pavisit=$p($g(^PAADM(EpisodeID)),"^",20)
    ..i pavisit'="A" q
	..s bedSub=$p($g(^PAADM(EpisodeID)),"^",73)
	..q:bedSub=""
	..s locId=$p($g(^PAADM(EpisodeID)),"^",4)
	..q:(LocationId'="")&&(LocationId'=locId)
	..s curWardId=$P(bedSub,"||",1)
	..s curBedSub=$P(bedSub,"||",2)
	..s rcflag=$P(^PAWARD(curWardId,"BED",curBedSub),"^",4)
	..q:rcflag="N"
	..q:(curWardId="")!(curBedSub="")
	..s bedCode=$p($g(^PAWARD(curWardId,"BED",curBedSub)),"^",1)
 	..q:bedCode=""
 	..s bedCode=bedCode_"床"
	..s ^TMP(repid,"tempbedcode",bedCode,EpisodeID)=""

	s curBedCode=0 f  s curBedCode=$o(^TMP(repid,"tempbedcode",curBedCode)) q:curBedCode=""  d
	.s EpisodeID=0 f  s EpisodeID=$o(^TMP(repid,"tempbedcode",curBedCode,EpisodeID)) q:EpisodeID=""  d
	..s patInfo=##class(web.DHCCLCom).PatInfo("^"_EpisodeID)
	..//s retStr=regNo_"^"_ctlocDesc_"^"_$g(room)_"^"_$g(sex)_"^"_$g(patName)_"^"_$g(safetyNetCardNo)_"^"_$g(bedCode)_"^"_$g(age)_"^"_$g(wardDesc)_"^"_homeAddres_"^"_homeTel_"  "_workTel_"  "_handtel_"^"_$G(DocDes)_"^"_MedCareNo_"^"_$G(mrDiagnos)
	..s BedCode=$P(patInfo,"^",7)
	..s PatName=$P(patInfo,"^",5)
	..s PatSex=$P(patInfo,"^",4)
	..s PatAge=$P(patInfo,"^",8)
	..s MedCard=$P(patInfo,"^",13)
	..s PatDiag=##class(web.DHCCLCom).GetDiag(EpisodeID)  //$P(patInfo,"^",14)
	..s aa=..GetShiftExchageInfoNew(EpisodeID,StaDate,EnDate,StaTime)
	..s aa="BedCode|"_BedCode_"^PatName|"_PatName_"^PatSex|"_PatSex_"^PatAge|"_PatAge_"^PatDiag|"_PatDiag_"^Adm|"_EpisodeID_"^MedCard|"_MedCard_"^"_aa
	..b
	..d OutRowRegNew
	k ^TMP(repid,"tempbedcode")
	
    }
	s qHandle=$lb(0,repid,0)
	q $$$OK

OutRowRegNew
	s Data=$lb(aa) //$lb(BedCode,PatName,PatSex,PatAge,PatDiag)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod FindCurWardPatNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCurWardPatNewExecute ]
{
	s AtEnd=$li(qHandle,1)
	s repid=$li(qHandle,2)
	s ind=$li(qHandle,3)
	s ind=$o(^CacheTemp(repid,ind))
	i ind="" {				// if there are no more rows, finish fetching
		s AtEnd=1
		s Row=""
	}
	else {			
		s Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindCurWardPatNewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCurWardPatNewExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

/// 根据就诊ID与日期查询病人的交班信息
ClassMethod GetShiftExchageInfo(EpisodeID, CareDate, CareTime) As %String
{
	//CareTime字段备用/暂固定为8点
	s CareTime="08:00:00"
	if (EpisodeID="")!(CareDate="")!(CareTime="") q ""
	if CareDate["-" s CareDate=$ZDH(CareDate,3)
	if CareTime[":" s CareTime=$ZTH(CareTime) 
    s Id=$O(^User.DHCNurShiftExchageI("AdmDatTim"," "_EpisodeID,CareDate,CareTime,""))
    if Id="" q ""
	s tmp=""
	s a=##class(User.DHCNurShiftExchage).getVal(Id,.tmp)
	s retArr=..getRet(.tmp)
	q retArr
}

// w ##class(web.DHCNurShiftExchage).GetShiftExchageInfo(5960,"2018-05-23","2018-05-24","08:00:00")

/// 根据就诊ID与日期段查询病人的交班信息
ClassMethod GetShiftExchageInfoNew(EpisodeID, StaDate, EnDate, CareTime) As %String
{
	//CareTime字段备用/暂固定为8点
	s CareTime="08:00:00"
	s retArr=""
	if (EpisodeID="")!(StaDate="")!(EnDate="")!(CareTime="") q ""
	if StaDate["-" s StaDate=$ZDH(StaDate,3)
	if EnDate["-" s EnDate=$ZDH(EnDate,3)
	if CareTime[":" s CareTime=$ZTH(CareTime) 
	for CareDate=StaDate:1:EnDate d
    .s Id=""
    .f  s Id=$O(^User.DHCNurShiftExchageI("AdmDatTim"," "_EpisodeID,CareDate,CareTime,Id)) q:Id=""  d 
    ..b //00
    ..s tmp=""
	..s a=##class(User.DHCNurShiftExchage).getVal(Id,.tmp)
	..s retArrNew=..getRet(.tmp)
	s retArr=retArr_retArrNew
	q retArr
}

/// 按代码|值格式返回
ClassMethod getRet(tmp) As %String
{
	s k=""
	s ret21=""
	f {
		s k=$O(tmp(k))
		q:k=""
		;i k'="Item23"
	    s value=..format($G(tmp(k)))
		//s value=$G(tmp(k))
		s ret21=ret21_k_"|"_value_"^"
	}
 	q ret21
}

ClassMethod format(formatstr As %String) As %String
{
	q:formatstr="" ""
	s str=formatstr
	s splitList=$lb("'"," ","　 ")
	s retStr=""
	for i=1:1:$listlength(splitList)
	{
		i (str[$list(splitList,i))
		{
			s num=$L(str,$list(splitList,i))
			for j=1:1:num
			{
			
				s s=$P(str,$list(splitList,i),j)
				i j=num s retStr=retStr_s
				e  s retStr=retStr_s_"\\"_$list(splitList,i)
			}
		}
		else
		{
			s retStr=str
		}
	
		s str=retStr
		s retStr=""
	}
	q str
}

/// 查询某个病人所有的交班记录
Query FindPatDataDetail(Parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindPatDataDetailExecute(ByRef qHandle As %Binary, Parr As %String = "") As %Status
{
	s repid=$i(^CacheTemp)
	s ind=1
	//d ##class(%ResultSet).RunQuery("web.DHCNurShiftExchage","FindPatDataDetail","211","2011-07-21","07:00:00")
	s EpisodeID=$P(Parr,"^",1)
	s StartDate=$P(Parr,"^",2)
	s EndDate=$P(Parr,"^",3)
	//CareTime字段备用/暂固定为8点
	s CareTime="08:00:00"
	s StartDate=$ZDH(StartDate,3)
	s EndDate=$ZDH(EndDate,3)
	for CurDate=StartDate:1:EndDate {
		s aa=..GetShiftExchageInfo(EpisodeID,CurDate,CareTime)
		if aa="" continue
		s aa=aa_"^CareDate|"_$ZD(CurDate,3)_"^Adm|"_EpisodeID
		d OutRowDetail
	}
	s qHandle=$lb(0,repid,0)
	q $$$OK

OutRowDetail
	s Data=$lb(aa) //$lb(BedCode,PatName,PatSex,PatAge,PatDiag)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod FindPatDataDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPatDataDetailExecute ]
{
	s AtEnd=$li(qHandle,1)
	s repid=$li(qHandle,2)
	s ind=$li(qHandle,3)
	s ind=$o(^CacheTemp(repid,ind))
	i ind="" {				// if there are no more rows, finish fetching
		s AtEnd=1
		s Row=""
	}
	else {			
		s Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindPatDataDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPatDataDetailExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

// d ##class(%ResultSet).RunQuery("web.DHCNurShiftExchage","FindCurWardPatPrn","570!2013-03-08!08#00#00!3!3")

/// 打印模版调用
Query FindCurWardPatPrn(Parr As %String) As %Query(ROWSPEC = "BedCode,PatName,PatSex,PatAge,MedCard,PatDiag,Item1,Item2,Item3,Item4,Item5,Item6,Item7,Item8,Item9,Item10,Item11,Item12,Item13,Item14,Item15,Item16,Item17,Item18,Item19,Item20,Item21,Item22,Item23,Item24,Item25,Item26,Item27,Item28,Item29,Item30,Item31,Item32,Item33,Item34,Item35,Item36,Item37,Item38,Item39,Item40,Item41,Item42,Item43,Item44,Item45,Item46,Item47,Item48,Item49,Item50")
{
}

ClassMethod FindCurWardPatPrnExecute(ByRef qHandle As %Binary, Parr As %String = "") As %Status
{
	s repid=$i(^CacheTemp)
	s ind=1
	s Parr=$tr(Parr,"#",":")
	//s ^TmpPan=Parr
	//d ##class(%ResultSet).RunQuery("web.DHCNurShiftExchage","FindCurWardPatPrn","570!2011-07-22!08:00:00")
	s logonLocId=$P(Parr,"!",1)
	s CareDate=$P(Parr,"!",2)
	s CareTime=$P(Parr,"!",3)
	s LogLoc=$P(Parr,"!",4)
	s LocationId=$P(Parr,"!",5)
	//CareTime字段备用/暂固定为8点
	s CareTime="08:00:00"
	if CareDate["-" s CareDate=$ZDH(CareDate,3)
	if CareTime[":" s CareTime=$ZTH(CareTime)
	
	if (logonLocId=10000)
	{
		s LocId=LogLoc //%session.Data("LOGON.CTLOCID")
		
		s markSetId=0 f  s markSetId=$O(^User.DHCOPChgDepMarkSetD(markSetId)) q:markSetId=""  d
		.s DepSource=$Listget(^User.DHCOPChgDepMarkSetD(markSetId),4)
		.q:DepSource'=LocId
		.s DepTarget=$Listget(^User.DHCOPChgDepMarkSetD(markSetId),5)
		.q:DepTarget=""
		.s AdmDate=0 f  s AdmDate=$o(^PAADMi("CurrLoc",DepTarget,AdmDate)) q:AdmDate=""  d
		..s AdmTime=0 f  s AdmTime=$o(^PAADMi("CurrLoc",DepTarget,AdmDate,AdmTime)) q:AdmTime=""  d
		...s EpisodeID=0 f  s EpisodeID=$o(^PAADMi("CurrLoc",DepTarget,AdmDate,AdmTime,EpisodeID)) q:EpisodeID=""  d
		....s AdmTyp=$p($g(^PAADM(EpisodeID)),"^",2)
		....q:AdmTyp'="E"
		....s pavisit=$p($g(^PAADM(EpisodeID)),"^",20)
		....q:pavisit'="A" 
		....s locId=$p($g(^PAADM(EpisodeID)),"^",4)
		....q:(LocationId'="")&&(LocationId'=locId)
		....s IsLgOrQj=##class(web.DHCEmergency).IfLgOrQj(EpisodeID)
		....q:IsLgOrQj=1
		....s patInfo=##class(web.DHCCLCom).PatInfo("^"_EpisodeID)
	    ....//s retStr=regNo_"^"_ctlocDesc_"^"_$g(room)_"^"_$g(sex)_"^"_$g(patName)_"^"_$g(safetyNetCardNo)_"^"_$g(bedCode)_"^"_$g(age)_"^"_$g(wardDesc)_"^"_homeAddres_"^"_homeTel_"  "_workTel_"  "_handtel_"^"_$G(DocDes)_"^"_MedCareNo_"^"_$G(mrDiagnos)
	    ....s BedCode=$P(patInfo,"^",7)
	    ....s PatName=$P(patInfo,"^",5)
	    ....s PatSex=$P(patInfo,"^",4)
	    ....s PatAge=$P(patInfo,"^",8)
	    ....s MedCard=$P(patInfo,"^",13)
	    ....s PatDiag=##class(web.DHCCLCom).GetDiag(EpisodeID)  //$P(patInfo,"^",14)
	    ....q:(EpisodeID="")&(CareDate="")&(CareTime="")
	    ....s Item1="",Item2="",Item3="",Item4="",Item5="",Item6="",Item7="",Item8="",Item9="",Item10=""
	    ....s Item11="",Item12="",Item13="",Item14="",Item15="",Item16="",Item17="",Item18="",Item19="",Item20=""
	    ....s Item21="",Item22="",Item23="",Item24="",Item25="",Item26="",Item27="",Item28="",Item29="",Item30=""
	    ....s Item31="",Item32="",Item33="",Item34="",Item35="",Item36="",Item37="",Item38="",Item39="",Item40=""
	    ....s Item41="",Item42="",Item43="",Item44="",Item45="",Item46="",Item47="",Item48="",Item49="",Item50=""
	    ....s Id=$O(^User.DHCNurShiftExchageI("AdmDatTim"," "_EpisodeID,CareDate,CareTime,""))
	    ....i Id'="" d
	    .....s arr=$G(^User.DHCNurShiftExchageD(Id))
	    .....s Item1=$ListGet(arr,5)
	    .....s Item2=$ListGet(arr,16)
        .....s Item3=$ListGet(arr,27)
        .....s Item4=$ListGet(arr,38)
        .....s Item5=$ListGet(arr,49)
        .....s Item6=$ListGet(arr,51)
        .....s Item7=$ListGet(arr,52)
        .....s Item8=$ListGet(arr,53)
        .....s Item9=$ListGet(arr,54)
        .....s Item10=$ListGet(arr,6)
        .....s Item11=$ListGet(arr,7)
        .....s Item12=$ListGet(arr,8)
        .....s Item13=$ListGet(arr,9)
        .....s Item14=$ListGet(arr,10)
        .....s Item15=$ListGet(arr,11)
        .....s Item16=$ListGet(arr,12)
        .....s Item17=$ListGet(arr,13)
        .....s Item18=$ListGet(arr,14)
        .....s Item19=$ListGet(arr,15)
        .....s Item20=$ListGet(arr,17)
        .....s Item21=$ListGet(arr,18)
        .....s Item22=$ListGet(arr,19)
        .....s Item23=$ListGet(arr,20)
        .....s Item24=$ListGet(arr,21)
        .....s Item25=$ListGet(arr,22)
        .....s Item26=$ListGet(arr,23)
        .....s Item27=$ListGet(arr,24)
        .....s Item28=$ListGet(arr,25)
        .....s Item29=$ListGet(arr,26)
        .....s Item30=$ListGet(arr,28)
        .....s Item31=$ListGet(arr,29)
        .....s Item32=$ListGet(arr,30)
        .....s Item33=$ListGet(arr,31)
        .....s Item34=$ListGet(arr,32)
        .....s Item35=$ListGet(arr,33)
        .....s Item36=$ListGet(arr,34)
        .....s Item37=$ListGet(arr,35)
        .....s Item38=$ListGet(arr,36)
        .....s Item39=$ListGet(arr,37)
        .....s Item40=$ListGet(arr,39)
        .....s Item41=$ListGet(arr,40)
        .....s Item42=$ListGet(arr,41)
        .....s Item43=$ListGet(arr,42)
        .....s Item44=$ListGet(arr,43)
        .....s Item45=$ListGet(arr,44)
        .....s Item46=$ListGet(arr,45)
        .....s Item47=$ListGet(arr,46)
        .....s Item48=$ListGet(arr,47)
        .....s Item49=$ListGet(arr,48)    
        .....s Item50=$ListGet(arr,50)
	    ....d OutRowRegPrn
		
		s AdmDate=0 f  s AdmDate=$o(^PAADMi("CurrLoc",LocId,AdmDate)) q:AdmDate=""  d
		.s AdmTime=0 f  s AdmTime=$o(^PAADMi("CurrLoc",LocId,AdmDate,AdmTime)) q:AdmTime=""  d
		..s EpisodeID=0 f  s EpisodeID=$o(^PAADMi("CurrLoc",LocId,AdmDate,AdmTime,EpisodeID)) q:EpisodeID=""  d
		...s AdmTyp=$p($g(^PAADM(EpisodeID)),"^",2)
		...q:AdmTyp'="E"
		...s pavisit=$p($g(^PAADM(EpisodeID)),"^",20)
		...q:pavisit'="A" 
		...s locId=$p($g(^PAADM(EpisodeID)),"^",4)
		...q:(LocationId'="")&&(LocationId'=locId)
		...s IsLgOrQj=##class(web.DHCEmergency).IfLgOrQj(EpisodeID)
		...q:IsLgOrQj=1
		...s patInfo=##class(web.DHCCLCom).PatInfo("^"_EpisodeID)
	    ...//s retStr=regNo_"^"_ctlocDesc_"^"_$g(room)_"^"_$g(sex)_"^"_$g(patName)_"^"_$g(safetyNetCardNo)_"^"_$g(bedCode)_"^"_$g(age)_"^"_$g(wardDesc)_"^"_homeAddres_"^"_homeTel_"  "_workTel_"  "_handtel_"^"_$G(DocDes)_"^"_MedCareNo_"^"_$G(mrDiagnos)
	    ...s BedCode=$P(patInfo,"^",7)
	    ...s PatName=$P(patInfo,"^",5)
	    ...s PatSex=$P(patInfo,"^",4)
	    ...s PatAge=$P(patInfo,"^",8)
	    ...s MedCard=$P(patInfo,"^",13)
	    ...s PatDiag=##class(web.DHCCLCom).GetDiag(EpisodeID)  //$P(patInfo,"^",14)
	    ...q:(EpisodeID="")&(CareDate="")&(CareTime="")
	    ...s Item1="",Item2="",Item3="",Item4="",Item5="",Item6="",Item7="",Item8="",Item9="",Item10=""
	    ...s Item11="",Item12="",Item13="",Item14="",Item15="",Item16="",Item17="",Item18="",Item19="",Item20=""
	    ...s Item21="",Item22="",Item23="",Item24="",Item25="",Item26="",Item27="",Item28="",Item29="",Item30=""
	    ...s Item31="",Item32="",Item33="",Item34="",Item35="",Item36="",Item37="",Item38="",Item39="",Item40=""
	    ...s Item41="",Item42="",Item43="",Item44="",Item45="",Item46="",Item47="",Item48="",Item49="",Item50=""
	    ...s Id=$O(^User.DHCNurShiftExchageI("AdmDatTim"," "_EpisodeID,CareDate,CareTime,""))
	    ...i Id'="" d
	    ....s arr=$G(^User.DHCNurShiftExchageD(Id))
	    ....s Item1=$ListGet(arr,5)
	    ....s Item2=$ListGet(arr,16)
        ....s Item3=$ListGet(arr,27)
        ....s Item4=$ListGet(arr,38)
        ....s Item5=$ListGet(arr,49)
        ....s Item6=$ListGet(arr,51)
        ....s Item7=$ListGet(arr,52)
        ....s Item8=$ListGet(arr,53)
        ....s Item9=$ListGet(arr,54)
        ....s Item10=$ListGet(arr,6)
        ....s Item11=$ListGet(arr,7)
        ....s Item12=$ListGet(arr,8)
        ....s Item13=$ListGet(arr,9)
        ....s Item14=$ListGet(arr,10)
        ....s Item15=$ListGet(arr,11)
        ....s Item16=$ListGet(arr,12)
        ....s Item17=$ListGet(arr,13)
        ....s Item18=$ListGet(arr,14)
        ....s Item19=$ListGet(arr,15)
        ....s Item20=$ListGet(arr,17)
        ....s Item21=$ListGet(arr,18)
        ....s Item22=$ListGet(arr,19)
        ....s Item23=$ListGet(arr,20)
        ....s Item24=$ListGet(arr,21)
        ....s Item25=$ListGet(arr,22)
        ....s Item26=$ListGet(arr,23)
        ....s Item27=$ListGet(arr,24)
        ....s Item28=$ListGet(arr,25)
        ....s Item29=$ListGet(arr,26)
        ....s Item30=$ListGet(arr,28)
        ....s Item31=$ListGet(arr,29)
        ....s Item32=$ListGet(arr,30)
        ....s Item33=$ListGet(arr,31)
        ....s Item34=$ListGet(arr,32)
        ....s Item35=$ListGet(arr,33)
        ....s Item36=$ListGet(arr,34)
        ....s Item37=$ListGet(arr,35)
        ....s Item38=$ListGet(arr,36)
        ....s Item39=$ListGet(arr,37)
        ....s Item40=$ListGet(arr,39)
        ....s Item41=$ListGet(arr,40)
        ....s Item42=$ListGet(arr,41)
        ....s Item43=$ListGet(arr,42)
        ....s Item44=$ListGet(arr,43)
        ....s Item45=$ListGet(arr,44)
        ....s Item46=$ListGet(arr,45)
        ....s Item47=$ListGet(arr,46)
        ....s Item48=$ListGet(arr,47)
        ....s Item49=$ListGet(arr,48)    
        ....s Item50=$ListGet(arr,50)
	    ...d OutRowRegPrn
	}
	else
	{
	i logonLocId="" s logonLocId=%session.Data("LOGON.CTLOCID")
 	s logonLocType=$p($g(^CTLOC(logonLocId)),"^",13)
	i (logonLocType="W")!(logonLocType="EM") d
	.s WardID=$o(^PAWARD(0,"WARD_LocationDR",logonLocId,0))
	e  d
	.s WardID=""
	i WardID="" s ind=1 s qHandle=$lb(0,repid,0) Quit $$$OK
	
	s curRoomId=0 f  s curRoomId=$o(^PAADMi("CurrWard",WardID,curRoomId)) q:curRoomId=""  d
	.s EpisodeID=0 f  s EpisodeID=$o(^PAADMi("CurrWard",WardID,curRoomId,EpisodeID)) q:EpisodeID=""  d
	..s pavisit=$p($g(^PAADM(EpisodeID)),"^",20)
    ..i pavisit'="A" q
	..s bedSub=$p($g(^PAADM(EpisodeID)),"^",73)
	..q:bedSub=""
	..s locId=$p($g(^PAADM(EpisodeID)),"^",4)
	..q:(LocationId'="")&&(LocationId'=locId)
	..s curWardId=$P(bedSub,"||",1)
	..s curBedSub=$P(bedSub,"||",2)
	..q:(curWardId="")!(curBedSub="")
	..s bedCode=$p($g(^PAWARD(curWardId,"BED",curBedSub)),"^",1)
 	..q:bedCode=""
 	..s bedCode=bedCode_"床"
	..s ^TMP(repid,"tempbedcode",bedCode,EpisodeID)=""
	
	s curBedCode=0 f  s curBedCode=$o(^TMP(repid,"tempbedcode",curBedCode)) q:curBedCode=""  d
	.s EpisodeID=0 f  s EpisodeID=$o(^TMP(repid,"tempbedcode",curBedCode,EpisodeID)) q:EpisodeID=""  d
	..s patInfo=##class(web.DHCCLCom).PatInfo("^"_EpisodeID)
	..//s retStr=regNo_"^"_ctlocDesc_"^"_$g(room)_"^"_$g(sex)_"^"_$g(patName)_"^"_$g(safetyNetCardNo)_"^"_$g(bedCode)_"^"_$g(age)_"^"_$g(wardDesc)_"^"_homeAddres_"^"_homeTel_"  "_workTel_"  "_handtel_"^"_$G(DocDes)_"^"_MedCareNo_"^"_$G(mrDiagnos)
	..s BedCode=$P(patInfo,"^",7)
	..s PatName=$P(patInfo,"^",5)
	..s PatSex=$P(patInfo,"^",4)
	..s PatAge=$P(patInfo,"^",8)
	..s MedCard=$P(patInfo,"^",13)
	..s PatDiag=##class(web.DHCCLCom).GetDiag(EpisodeID)  //$P(patInfo,"^",14)
	..q:(EpisodeID="")&(CareDate="")&(CareTime="")
	..s Item1="",Item2="",Item3="",Item4="",Item5="",Item6="",Item7="",Item8="",Item9="",Item10=""
	..s Item11="",Item12="",Item13="",Item14="",Item15="",Item16="",Item17="",Item18="",Item19="",Item20=""
	..s Item21="",Item22="",Item23="",Item24="",Item25="",Item26="",Item27="",Item28="",Item29="",Item30=""
	..s Item31="",Item32="",Item33="",Item34="",Item35="",Item36="",Item37="",Item38="",Item39="",Item40=""
	..s Item41="",Item42="",Item43="",Item44="",Item45="",Item46="",Item47="",Item48="",Item49="",Item50=""
	..s Id=$O(^User.DHCNurShiftExchageI("AdmDatTim"," "_EpisodeID,CareDate,CareTime,""))
	..i Id'="" d
	...s arr=$G(^User.DHCNurShiftExchageD(Id))
	...s Item1=$ListGet(arr,5)
	...s Item2=$ListGet(arr,16)
    ...s Item3=$ListGet(arr,27)
    ...s Item4=$ListGet(arr,38)
    ...s Item5=$ListGet(arr,49)
    ...s Item6=$ListGet(arr,51)
    ...s Item7=$ListGet(arr,52)
    ...s Item8=$ListGet(arr,53)
    ...s Item9=$ListGet(arr,54)
    ...s Item10=$ListGet(arr,6)
    ...s Item11=$ListGet(arr,7)
    ...s Item12=$ListGet(arr,8)
    ...s Item13=$ListGet(arr,9)
    ...s Item14=$ListGet(arr,10)
    ...s Item15=$ListGet(arr,11)
    ...s Item16=$ListGet(arr,12)
    ...s Item17=$ListGet(arr,13)
    ...s Item18=$ListGet(arr,14)
    ...s Item19=$ListGet(arr,15)
    ...s Item20=$ListGet(arr,17)
    ...s Item21=$ListGet(arr,18)
    ...s Item22=$ListGet(arr,19)
    ...s Item23=$ListGet(arr,20)
    ...s Item24=$ListGet(arr,21)
    ...s Item25=$ListGet(arr,22)
    ...s Item26=$ListGet(arr,23)
    ...s Item27=$ListGet(arr,24)
    ...s Item28=$ListGet(arr,25)
    ...s Item29=$ListGet(arr,26)
    ...s Item30=$ListGet(arr,28)
    ...s Item31=$ListGet(arr,29)
    ...s Item32=$ListGet(arr,30)
    ...s Item33=$ListGet(arr,31)
    ...s Item34=$ListGet(arr,32)
    ...s Item35=$ListGet(arr,33)
    ...s Item36=$ListGet(arr,34)
    ...s Item37=$ListGet(arr,35)
    ...s Item38=$ListGet(arr,36)
    ...s Item39=$ListGet(arr,37)
    ...s Item40=$ListGet(arr,39)
    ...s Item41=$ListGet(arr,40)
    ...s Item42=$ListGet(arr,41)
    ...s Item43=$ListGet(arr,42)
    ...s Item44=$ListGet(arr,43)
    ...s Item45=$ListGet(arr,44)
    ...s Item46=$ListGet(arr,45)
    ...s Item47=$ListGet(arr,46)
    ...s Item48=$ListGet(arr,47)
    ...s Item50=$ListGet(arr,50)
    ...s Item49=$ListGet(arr,48)    
	..d OutRowRegPrn
	k ^TMP(repid,"tempbedcode")
	}
	s qHandle=$lb(0,repid,0)
	q $$$OK

OutRowRegPrn
	s Data=$lb(BedCode,PatName,PatSex,PatAge,MedCard,PatDiag,Item1,Item2,Item3,Item4,Item5,Item6,Item7,Item8,Item9,Item10,Item11,Item12,Item13,Item14,Item15,Item16,Item17,Item18,Item19,Item20,Item21,Item22,Item23,Item24,Item25,Item26,Item27,Item28,Item29,Item30,Item31,Item32,Item33,Item34,Item35,Item36,Item37,Item38,Item39,Item40,Item41,Item42,Item43,Item44,Item45,Item46,Item47,Item48,Item49,Item50)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod FindCurWardPatPrnFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCurWardPatPrnExecute ]
{
	s AtEnd=$li(qHandle,1)
	s repid=$li(qHandle,2)
	s ind=$li(qHandle,3)
	s ind=$o(^CacheTemp(repid,ind))
	i ind="" {				// if there are no more rows, finish fetching
		s AtEnd=1
		s Row=""
	}
	else {			
		s Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindCurWardPatPrnClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCurWardPatPrnExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

/// 医生界面交班表使用,查询登陆科室关联的病区
ClassMethod getloc(logonLocId, funname As %String) As %String
{
	//w ##class(web.DHCNurShiftExchage).getloc(11,"add")
	i logonLocId="" q 0
	s linkId=0  f  s linkId=$O(^CTLOC(logonLocId,"LINK",linkId)) q:linkId=""  d
	.s linkLocId=$p($g(^CTLOC(logonLocId,"LINK",linkId)),"^",1)
	.q:linkLocId=""
	.s ctlocDesc=$p($g(^CTLOC(linkLocId)),"^",2)
	.s ctlocId=linkLocId
	.s rtnval=funname_"('"_$ZCVT($g(ctlocId),"O","JS")_"','"_$ZCVT($g(ctlocDesc),"O","JS")_"');"
 	.&javascript<#(rtnval)#>
 	s a=funname_"('"_$ZCVT(10000,"O","JS")_"','"_$ZCVT("JZLS-急诊流水","O","JS")_"');"
 	&javascript<#(a)#>
 	q 0
}

ClassMethod getlocation(logonLocId, funname As %String) As %String
{
	//w ##class(web.DHCNurShiftExchage).getloc(11,"add")
	i logonLocId="" q 0
	s rtnval=funname_"('"_$ZCVT("","O","JS")_"','"_$ZCVT("","O","JS")_"');"
	&javascript<#(rtnval)#>
	s locDesc=""
	f  s locDesc=$O(^PAC("ADMLOC",0,"TypeDesc","E",locDesc)) q:locDesc=""  d
	.s ctlocId=$O(^PAC("ADMLOC",0,"TypeDesc","E",locDesc,""))
	.s rtnval=funname_"('"_$ZCVT($g(ctlocId),"O","JS")_"','"_$ZCVT($g(locDesc),"O","JS")_"');"
 	.&javascript<#(rtnval)#>
 	s a=funname_"('"_$ZCVT(10000,"O","JS")_"','"_$ZCVT("JZLS-急诊流水","O","JS")_"');"
 	&javascript<#(a)#>
 	q 0
}

ClassMethod getlocexchage(funname As %String) As %String
{
	s rw="" f  s rw=$O(^CTLOC(rw)) q:rw=""  d
	.s a=$P(^CTLOC(rw),"^")
	.s c=$P(^CTLOC(rw),"^",2)
	.q:c=""
	.s LocType=$p($g(^CTLOC(rw)),"^",13)
	.q:(LocType'="W")&(LocType'="EM")&(LocType'="E")
	.s rtnval=funname_"('"_$ZCVT($g(rw),"O","JS")_"','"_$ZCVT($g(c),"O","JS")_"');"
	.&javascript<#(rtnval)#>
	q 0
}

/// 返回应该查白班夜班还是历史数据
ClassMethod GetType(searchDate) As %String
{
	s searchType=""
	s curDate=+$h
	s curTime=$p($h,",",2)
	s:searchDate["/" searchDate=$zdh(searchDate,4),searchDate=$zd(searchDate,3)
	
	//s curTime=86200
	if ($ZDH(searchDate,3)=curDate)&&(curTime>$p(^DHCNurWardShiftTime,"^",1))&&(curTime<$p(^DHCNurWardShiftTime,"^",2)) s searchType="Day"
	if ($ZDH(searchDate,3)=curDate)&&(curTime>($p(^DHCNurWardShiftTime,"^",2)-1)) s searchType="Night"  //19-24
	if ($ZDH(searchDate,3)=curDate)&&(curTime<$p(^DHCNurWardShiftTime,"^",1)) s searchType="Night"   //0-7 查询日期是今天
	if ($ZDH(searchDate,3)=(curDate-1))&&(curTime<$p(^DHCNurWardShiftTime,"^",1)) s searchType="Night" //0-7 查询日期是昨天(跨12点的时候没有刷新界面)
    q searchType
}

/// 插入以前班次数据
ClassMethod InsertPreviousData(parr = "") As %String
{
	//w ##class(web.DHCNurShiftExchage).InsertPreviousData("89^2014-01-10^3880")
	q:parr="" ""
	s type=""
	//b
	s LocId=$P(parr,"^",1)
	s SumDate=$P(parr,"^",2)
	s userId=$P(parr,"^",3)
	s userID=userId
	//判断是否保存过汇总记录
	
		if $D(^DHCNurExchage(userId)) k ^DHCNurExchage(userId)	//GetWardItemSummary中注释掉原清除Global
		//日间7-7
		i LocId="" s LocId=%session.Data("LOGON.CTLOCID")
		s LocType=$p($g(^CTLOC(LocId)),"^",13)
		i (LocType="W")!(LocType="EM") d
		.s wardId=$o(^PAWARD(0,"WARD_LocationDR",LocId,0))
		e  d
		.s wardId=""
		i wardId="" q "@"
		s wardDesc =""
			
			s startDate=$ZDH(SumDate,3)
			s endDate=$ZDH(SumDate,3)
			s startTime=$ZTH("07:00:00")
			s endTime=$ZTH("18:59:59")
			d PreDayWork
			s startDate=$ZDH(SumDate,3)
			s endDate=$ZDH(SumDate,3)+1  //夜间7-7当天19点到第二天07点
			s startTime=$ZTH("19:00:00")
			s endTime=$ZTH("6:59:59")
			d PreNightWork
		s retStr=$g(dayTotal)_"^"_$g(dayAdmSum)_"^"_$g(dayTransInSum)_"^"_$g(dayDischSum)_"^"_$g(dayTransOutSum)_"^"_$g(dayDeathSum)_"^"_$g(dayOperSum)_"^"_$g(dayBabySum)_"^"_$g(dayCritiSum)_"^"_$g(daySeveritySum)_"^"_$g(dayNurse)_"@"_$g(nightTotal)_"^"_$g(nightAdmSum)_"^"_$g(nightTransInSum)_"^"_$g(nightDischSum)_"^"_$g(nightTransOutSum)_"^"_$g(nightDeathSum)_"^"_$g(nightOperSum)_"^"_$g(nightBabySum)_"^"_$g(nightCritiSum)_"^"_$g(nightSeveritySum)_"^"_$g(nightNurse)
	s par=$O(^User.DHCNurWardShiftI("LocDate"," "_LocId,$ZDH(SumDate,3),""))
	s DateDetail=SumDate
	i (par'="")
		{
			s rw="" f  s rw=$O(^User.DHCNurWardShiftD(par,"ChildRec",rw)) q:rw=""  d
		.s type=$ListGet(^User.DHCNurWardShiftD(par,"ChildRec",rw),5)			//Item101
		.i type="" s type="在院"
		.s bedCode=$ListGet(^User.DHCNurWardShiftD(par,"ChildRec",rw),6)		//Item102
		.i bedCode="" s bedCode=0
		.s ^TMP(repid,"tempbedcode",type,bedCode,rw)=""
			s TypeStr="出院^转出^死亡^入院^转入^分娩^手术^今日手术^明日手术^病重^病危^在院"
		f i=1:1:$L(TypeStr) d
		.s CurType=$P(TypeStr,"^",i)
		.q:CurType=""
		.s CurBedCode="" f  s CurBedCode=$O(^TMP(repid,"tempbedcode",CurType,CurBedCode)) q:CurBedCode=""  d
		..s rw="" f  s rw=$O(^TMP(repid,"tempbedcode",CurType,CurBedCode,rw)) q:rw=""  d
		...;s type=$ListGet(^User.DHCNurWardShiftD(par,"ChildRec",rw),5)	
		...s type=CurType	//Item101
		...s subWorkType=$ListGet(^User.DHCNurWardShiftD(par,"ChildRec",rw),35)	
		...;q:(subWorkType'=workType)&&(subWorkType'="")
		...s bedCode=$ListGet(^User.DHCNurWardShiftD(par,"ChildRec",rw),6)		//Item102
		...s patName=$ListGet(^User.DHCNurWardShiftD(par,"ChildRec",rw),7)		//Item103
		...s diagnos=$ListGet(^User.DHCNurWardShiftD(par,"ChildRec",rw),8)		//Item104
		...s dayNote=$ListGet(^User.DHCNurWardShiftD(par,"ChildRec",rw),9)		//Item105
		...s nightNote=$ListGet(^User.DHCNurWardShiftD(par,"ChildRec",rw),10)		//Item106
		...s EpisodeID=$ListGet(^User.DHCNurWardShiftD(par,"ChildRec",rw),11)		//Item106
		...b //type
		...s killDate=DateDetail
		...s killType=type
		...i type="明日手术" s killDate=$zd($zdh(DateDetail,3)+1,3)
		...i type="今日手术" s killType="手术"
		...if $D(^DHCNurExchage(userID,killDate,killType)) d
		  ....s tnum=""   ;清除已经保存过的统计数据
		  ....f  s tnum=$O(^DHCNurExchage(userID,killDate,killType,tnum)) q:tnum=""  d
		   .....s searchEID=$p(^DHCNurExchage(userID,killDate,killType,tnum),"^",4)
		   .....i searchEID=EpisodeID  K ^DHCNurExchage(userID,killDate,killType,tnum)
		k ^TMP(repid,"tempbedcode")
		}
		else 
		{
			s saveName=""
			if $D(^SSU("SSUSR",userId)) d
	          .s saveName=$p(^SSU("SSUSR",userId),"^",2)
			s a=##class(User.DHCNurWardShift).%New()
			 s a.LocDr=LocId
		 s a.RecUser=userId
		 s a.CareDate=$ZDH(SumDate,3)
		s a.RecDate=+$h
		s a.RecTime=$p($h,",",2)
		
		 s a.Item1=$p($p(retStr,"@",1),"^",1)
			 s a.Item2=$p($p(retStr,"@",1),"^",2)
			 s a.Item3=$p($p(retStr,"@",1),"^",3)
			 s a.Item4=$p($p(retStr,"@",1),"^",4)
			 s a.Item5=$p($p(retStr,"@",1),"^",5)
		    s a.Item6=$p($p(retStr,"@",1),"^",6)
			 s a.Item7=$p($p(retStr,"@",1),"^",7)
			 s a.Item8=$p($p(retStr,"@",1),"^",8)
			 s a.Item9=$p($p(retStr,"@",1),"^",9)
			 s a.Item10=$p($p(retStr,"@",1),"^",10)
			 s a.Item21=saveName
			
			 s a.Item11=$p($p(retStr,"@",2),"^",1)
			 s a.Item12=$p($p(retStr,"@",2),"^",2)
			 s a.Item13=$p($p(retStr,"@",2),"^",3)
			 s a.Item14=$p($p(retStr,"@",2),"^",4)	
			 s a.Item15=$p($p(retStr,"@",2),"^",5)
			 s a.Item16=$p($p(retStr,"@",2),"^",6)
			 s a.Item17=$p($p(retStr,"@",2),"^",7)
			 s a.Item18=$p($p(retStr,"@",2),"^",8)
			 s a.Item19=$p($p(retStr,"@",2),"^",9)				
	         s a.Item20=$p($p(retStr,"@",2),"^",10)
			 s a.Item22=saveName
		s a.DayWork=1
		s a.NightWork=1
			d a.%Save()
			s par=a.%Id()
		}
		s userID=userId
			i userID="" s userID=%session.Data("LOGON.USERID")
		s dayNote="",nightNote=""
		s startDate=$zdh(DateDetail,3)
		f date=startDate:1:(startDate+1) d
		.s DateDetail=$zd(date,3)
		.s Type="出院"
		.s num=""
	    .f  s num=$o(^DHCNurExchage(userID,DateDetail,Type,num)) q:num=""  d
	    ..s type=Type
	    ..s bedCode=$p(^DHCNurExchage(userID,DateDetail,Type,num),"^",1)
	    ..s patName=$p(^DHCNurExchage(userID,DateDetail,Type,num),"^",2)
		..s diagnos=$p(^DHCNurExchage(userID,DateDetail,Type,num),"^",3)
		..s EpisodeID=$p(^DHCNurExchage(userID,DateDetail,Type,num),"^",4)
		..i bedCode'="",EpisodeID'="" s ^TMP(repid,"tempbedcode",bedCode,EpisodeID)=""
		..d InsertData
		.s Type="转出"
		.s num=""
	    .f  s num=$o(^DHCNurExchage(userID,DateDetail,Type,num)) q:num=""  d
	    ..s type=Type
	    ..s bedCode=$p(^DHCNurExchage(userID,DateDetail,Type,num),"^",1)
	    ..s patName=$p(^DHCNurExchage(userID,DateDetail,Type,num),"^",2)
		..s diagnos=$p(^DHCNurExchage(userID,DateDetail,Type,num),"^",3)
		..s EpisodeID=$p(^DHCNurExchage(userID,DateDetail,Type,num),"^",4)
		..i bedCode'="",EpisodeID'="" s ^TMP(repid,"tempbedcode",bedCode,EpisodeID)=""
		..d InsertData
		.s Type="死亡"
		.s num=""
	    .f  s num=$o(^DHCNurExchage(userID,DateDetail,Type,num)) q:num=""  d
	    ..s type=Type
	    ..s bedCode=$p(^DHCNurExchage(userID,DateDetail,Type,num),"^",1)
	    ..s patName=$p(^DHCNurExchage(userID,DateDetail,Type,num),"^",2)
		..s diagnos=$p(^DHCNurExchage(userID,DateDetail,Type,num),"^",3)
		..s EpisodeID=$p(^DHCNurExchage(userID,DateDetail,Type,num),"^",4)
		..i bedCode'="",EpisodeID'="" s ^TMP(repid,"tempbedcode",bedCode,EpisodeID)=""
		..d InsertData
		.s Type="入院"
		.s num=""
	    .f  s num=$o(^DHCNurExchage(userID,DateDetail,Type,num)) q:num=""  d
	    
	    ..s type=Type
	    ..s bedCode=$p(^DHCNurExchage(userID,DateDetail,Type,num),"^",1)
	    ..s patName=$p(^DHCNurExchage(userID,DateDetail,Type,num),"^",2)
		..s diagnos=$p(^DHCNurExchage(userID,DateDetail,Type,num),"^",3)
		..s EpisodeID=$p(^DHCNurExchage(userID,DateDetail,Type,num),"^",4)
		..s dayNote=$p(^DHCNurExchage(userID,DateDetail,Type,num),"^",5)
		..s nightNote=$p(^DHCNurExchage(userID,DateDetail,Type,num),"^",6)
		..i bedCode'="",EpisodeID'="" s ^TMP(repid,"tempbedcode",bedCode,EpisodeID)=""  
		..d InsertData
		..s (dayNote,nightNote)=""
		.s Type="转入"
		.s num=""
	    .f  s num=$o(^DHCNurExchage(userID,DateDetail,Type,num)) q:num=""  d
	    ..s type=Type
	    ..s bedCode=$p(^DHCNurExchage(userID,DateDetail,Type,num),"^",1)
	    ..s patName=$p(^DHCNurExchage(userID,DateDetail,Type,num),"^",2)
		..s diagnos=$p(^DHCNurExchage(userID,DateDetail,Type,num),"^",3)
		..s EpisodeID=$p(^DHCNurExchage(userID,DateDetail,Type,num),"^",4)
		..i bedCode'="",EpisodeID'="" s ^TMP(repid,"tempbedcode",bedCode,EpisodeID)=""
		..d InsertData
		.s Type="分娩"
		.s num=""
	    .f  s num=$o(^DHCNurExchage(userID,DateDetail,Type,num)) q:num=""  d
	    ..s type=Type
	    ..s bedCode=$p(^DHCNurExchage(userID,DateDetail,Type,num),"^",1)
	    ..s patName=$p(^DHCNurExchage(userID,DateDetail,Type,num),"^",2)
		..s diagnos=$p(^DHCNurExchage(userID,DateDetail,Type,num),"^",3)
		..s EpisodeID=$p(^DHCNurExchage(userID,DateDetail,Type,num),"^",4)
		..i bedCode'="",EpisodeID'="" s ^TMP(repid,"tempbedcode",bedCode,EpisodeID)=""
		..d InsertData
		.s Type="手术"
		.s num=""
	    .f  s num=$o(^DHCNurExchage(userID,DateDetail,Type,num)) q:num=""  d
	    ..s type="今日手术" //Type
	    ..s bedCode=$p(^DHCNurExchage(userID,DateDetail,Type,num),"^",1)
	    ..s patName=$p(^DHCNurExchage(userID,DateDetail,Type,num),"^",2)
		..s diagnos=$p(^DHCNurExchage(userID,DateDetail,Type,num),"^",3)
		..s EpisodeID=$p(^DHCNurExchage(userID,DateDetail,Type,num),"^",4)
		..i bedCode'="",EpisodeID'="" s ^TMP(repid,"tempbedcode",bedCode,EpisodeID)=""
		..b //ssout
		..d InsertData
		.//DateDetail查询明天是否有手术
		.;s ToDateDetail=$ZD(($ZDH(DateDetail,3)+1),3)
		.s Type="明日手术"
		.s num=""
		.s tomorrowDate=$zd(($zdh(DateDetail,3)+1),3)
	    .f  s num=$o(^DHCNurExchage(userID,tomorrowDate,Type,num)) q:num=""  d
	    ..s type="明日手术"
	    ..s bedCode=$p(^DHCNurExchage(userID,tomorrowDate,Type,num),"^",1)
	    ..s patName=$p(^DHCNurExchage(userID,tomorrowDate,Type,num),"^",2)
		..s diagnos=$p(^DHCNurExchage(userID,tomorrowDate,Type,num),"^",3)
		..s EpisodeID=$p(^DHCNurExchage(userID,tomorrowDate,Type,num),"^",4)
		..i bedCode'="",EpisodeID'="" s ^TMP(repid,"tempbedcode",bedCode,EpisodeID)=""
		..d InsertData
		.s Type="病重"
		.s num=""
	    .f  s num=$o(^DHCNurExchage(userID,DateDetail,Type,num)) q:num=""  d
	    ..s type=Type
	    ..s bedCode=$p(^DHCNurExchage(userID,DateDetail,Type,num),"^",1)
	    ..s patName=$p(^DHCNurExchage(userID,DateDetail,Type,num),"^",2)
		..s diagnos=$p(^DHCNurExchage(userID,DateDetail,Type,num),"^",3)
		..s EpisodeID=$p(^DHCNurExchage(userID,DateDetail,Type,num),"^",4)
		..i bedCode'="",EpisodeID'="" s ^TMP(repid,"tempbedcode",bedCode,EpisodeID)=""
		..d InsertData
		.s Type="病危"
		.s num=""
	    .f  s num=$o(^DHCNurExchage(userID,DateDetail,Type,num)) q:num=""  d
	    ..s type=Type
	    ..s bedCode=$p(^DHCNurExchage(userID,DateDetail,Type,num),"^",1)
	    ..s patName=$p(^DHCNurExchage(userID,DateDetail,Type,num),"^",2)
		..s diagnos=$p(^DHCNurExchage(userID,DateDetail,Type,num),"^",3)
		..s EpisodeID=$p(^DHCNurExchage(userID,DateDetail,Type,num),"^",4)
		..i bedCode'="",EpisodeID'="" s ^TMP(repid,"tempbedcode",bedCode,EpisodeID)=""
		..d InsertData
  q 0
	
	
	
InsertData
   
	s a=##class(User.DHCNurWardShiftSub).%New()
	s objParrent=##class(User.DHCNurWardShift).%OpenId(par)
		s a.RecParref=objParrent
		s a.WorkType=""
		 s a.RecUser=$g(userId)
		 s a.Item101=$g(type)
		 s a.Item102=$g(bedCode)
		 s a.Item103=$g(patName)
		 s a.Item104=$g(diagnos)
		 s a.Item105=$g(daytNote)
		 s a.Item106=$g(nightNote)
		 s a.Item107=$g(EpisodeID)
        d a.%Save()
	quit
			
PreDayWork
			s dayTotal="",dayAdmSum="",dayTransInSum="",dayDischSum="",dayTransOutSum=""
			s dayDeathSum="",dayOperSum="",dayBabySum="",daySeveritySum="",dayCritiSum=""
			//s dayNurse=""
	
			//s ^pjf("Day")=startDate_"@"_startTime_"!"_endDate_"@"_endTime
			i (LocType="W")!(LocType="EM") {
				//b ;001
				
				s rset=##class(%ResultSet).%New("web.DHCNurShiftExchage:GetWardItemSummary")
				do rset.Execute(startDate,endDate,wardId,wardDesc,startTime,endTime,userId,type)
				while (rset.Next()) {
					//b //tDate"",tAdmSum"",tDischSum"",tTransInSum,tTransOutSum,tSpecCareSum,tACareSum,tOperSum,tCritiSum,tDeathSum,tBirthSum,tSeveritySum
					s dayAdmSum=rset.GetData(2)
					s dayTransInSum=rset.GetData(4)
					s dayDischSum=rset.GetData(3)
					s dayTransOutSum=rset.GetData(5)
					s dayDeathSum=rset.GetData(10)
					s dayOperSum=rset.GetData(8)
					s dayBabySum=rset.GetData(11)
					s daySeveritySum=rset.GetData(12)
					s dayCritiSum=rset.GetData(9)
					s dayTotal=rset.GetData(13)
				}	
				d rset.Close()
			}
			i (LocType="E"){
				s retShiftStr=##class(web.DHCNurShiftExchage).GetLocItemSummary(startDate,endDate,startTime,endTime,LocId,userId)
				s dayAdmSum=$P(retShiftStr,"^",1)
				s dayTransInSum=$P(retShiftStr,"^",2)
				s dayDischSum=$P(retShiftStr,"^",3)
				s dayTransOutSum=$P(retShiftStr,"^",4)
				s dayDeathSum=$P(retShiftStr,"^",5)
				s dayOperSum=$P(retShiftStr,"^",6)
				s dayBabySum=$P(retShiftStr,"^",7)
				s dayCritiSum=$P(retShiftStr,"^",8)
				s daySeveritySum=$P(retShiftStr,"^",9)
				s dayTotal=$P(retShiftStr,"^",10)
			
			}
			q
PreNightWork
			//夜间7-7
			//s ^pjf("Night")=startDate_"@"_startTime_"!"_endDate_"@"_endTime
			s nightTotal="",nightAdmSum="",nightTransInSum="",nightDischSum="",nightTransOutSum=""
			s nightDeathSum="",nightOperSum="",nightBabySum="",nightSeveritySum="",nightCritiSum=""
			//s nightNurse=""
			i (LocType="W")!(LocType="W"){
				//b ;002
				s rset=##class(%ResultSet).%New("web.DHCNurShiftExchage:GetWardItemSummary")
				do rset.Execute(startDate,endDate,wardId,wardDesc,startTime,endTime,userId,type)
				while (rset.Next()) {
					s nightAdmSum=nightAdmSum+rset.GetData(2)
					s nightTransInSum=nightTransInSum+rset.GetData(4)
					s nightDischSum=nightDischSum+rset.GetData(3)
					s nightTransOutSum=nightTransOutSum+rset.GetData(5)
					s nightDeathSum=nightDeathSum+rset.GetData(10)
					s nightOperSum=nightOperSum+rset.GetData(8)
					s nightBabySum=nightBabySum+rset.GetData(11)
					s nightSeveritySum=nightSeveritySum+rset.GetData(12)
					s nightCritiSum=nightCritiSum+rset.GetData(9)
					s nightTotal=rset.GetData(13)
				}
				d rset.Close()
			}
			i (LocType="E"){
				s retShiftStr=##class(web.DHCNurShiftExchage).GetLocItemSummary(startDate,endDate,startTime,endTime,LocId,userId)
				s nightAdmSum=$P(retShiftStr,"^",1)
				s nightTransInSum=$P(retShiftStr,"^",2)
				s nightDischSum=$P(retShiftStr,"^",3)
				s nightTransOutSum=$P(retShiftStr,"^",4)
				s nightDeathSum=$P(retShiftStr,"^",5)
				s nightOperSum=$P(retShiftStr,"^",6)
				s nightBabySum=$P(retShiftStr,"^",7)
				s nightCritiSum=$P(retShiftStr,"^",8)
				s nightSeveritySum=$P(retShiftStr,"^",9)
				s nightTotal=$P(retShiftStr,"^",10)
			}
		q
}

/// 取病室报告汇总数据
ClassMethod GetExchageSummary(parr = "", type) As %String
{
	//w ##class(web.DHCNurShiftExchage).GetExchageSummary("89^2014-04-14^3880")
	//w ##class(web.DHCNurShiftExchage).GetExchageSummary("105^2016-11-18^3880")
	q:parr="" ""
	s type=""
	s ^DHCNurWardShiftTime=$ZTH("06:59:01")_"^"_$ZTH("18:00:00")
	s LocId=$P(parr,"^",1)
	s SumDate=$P(parr,"^",2)
	s FindDate=SumDate //界面上点查询时的时间
	s userId=$P(parr,"^",3)
	s curDate=+$h
	s curTime=$p($h,",",2)
	s type=..GetType(FindDate)
	
	s:FindDate["/" FindDate=$zdh(FindDate,4),FindDate=$zd(FindDate,3)
	
	if ($ZDH(FindDate,3)=curDate)&&(curTime<+^DHCNurWardShiftTime) s FindDate=$ZD($ZDH(FindDate,3)-1,3) //凌晨查询的夜班应该是昨天的夜班
	;s ^lf("bingshisummary")=type_","_parr
	//判断是否保存过汇总记录
	s par=$O(^User.DHCNurWardShiftI("LocDate"," "_LocId,$ZDH(FindDate,3),""))
	;s ^lf("bingshipar")=par
	b ;33
 if $D(^DHCNurExchage(userId)) k ^DHCNurExchage(userId)	//GetWardItemSummary中注释掉原清除Global
 if $D(^DHCNurExchageType(userId)) k ^DHCNurExchageType(userId) //自动查出来记录的班次
 if $D(^DHCNurInHospital(userId)) k ^DHCNurInHospital(userId) 
	i par'="" d
	.s obj=##class(User.DHCNurWardShift).%OpenId(par)
	.s nightNurse=obj.Item22
	.s dayNurse=obj.Item21
	.s dayWork=obj.DayWork
	.s nightWork=obj.NightWork
	.s careDate=obj.CareDate
	.s lastSaveDate=obj.RecDate
	.s lastSaveTime=obj.RecTime
	.s noEpsiodeNum=1
	.s rw="" f  s rw=$O(^User.DHCNurWardShiftD(par,"ChildRec",rw)) q:rw=""  d
		..s EventType=$ListGet(^User.DHCNurWardShiftD(par,"ChildRec",rw),5)			//Item101
		..q:EventType=""
		..s EpisodeID=$ListGet(^User.DHCNurWardShiftD(par,"ChildRec",rw),11)		//Item107
		..s deleteFlag=$ListGet(^User.DHCNurWardShiftD(par,"ChildRec",rw),14)		//Item110
		..s wordType=$ListGet(^User.DHCNurWardShiftD(par,"ChildRec",rw),15)
		..q:(EpisodeID="")   //自动查出的记录，但是已经被删除
		..i EventType="今日手术" s EventType="手术"
		..i (deleteFlag=1) d
		...s ^DHCNurExchage(userId,"HASDELETE",$ZD(careDate,3),EpisodeID,EventType,wordType)=""
		
	
		;s dayTotal="",dayAdmSum="",dayTransInSum="",dayDischSum="",dayTransOutSum=""
			;s dayDeathSum="",dayOperSum="",dayBabySum="",daySeveritySum="",dayCritiSum=""
		;s nightTotal="",nightAdmSum="",nightTransInSum="",nightDischSum="",nightTransOutSum=""
			;s nightDeathSum="",nightOperSum="",nightBabySum="",nightSeveritySum="",nightCritiSum=""
			s dayTotal=0,dayAdmSum=0,dayTransInSum=0,dayDischSum=0,dayTransOutSum=0,dayTotalBaby=0,dayTransOutSumBaby=0,dayDischSumBaby=0
			s dayDeathSum=0,dayOperSum=0,dayBabySum=0,daySeveritySum=0,dayCritiSum=0
		s nightTotal=0,nightAdmSum=0,nightTransInSum=0,nightDischSum=0,nightTransOutSum=0,nightTotalBaby=0,nightTransOutSumBaby=0,nightDischSumBaby=0
			s nightDeathSum=0,nightOperSum=0,nightBabySum=0,nightSeveritySum=0,nightCritiSum=0
		//日间7-7
		i LocId="" s LocId=%session.Data("LOGON.CTLOCID")
		s LocType=$p($g(^CTLOC(LocId)),"^",13)
		b ;4
		i (LocType="W")!(LocType="EM") d
		.s wardId=$o(^PAWARD(0,"WARD_LocationDR",LocId,0))
		e  d
		.s wardId=""
		i wardId="" q "@"
		s wardDesc =""
			i (type="Day") d
			.s startDate=$ZDH(FindDate,3)
			.s endDate=$ZDH(FindDate,3)
			.s startTime=$p(^DHCNurWardShiftTime,"^",1)
			.s endTime=$p(^DHCNurWardShiftTime,"^",2)
			.d DayWork
			
			i (type="Night") d
			.s startDate=$ZDH(FindDate,3)
			.s endDate=$ZDH(FindDate,3)+1  //夜间7-7当天19点到第二天7:00:00
			.s startTime=$p(^DHCNurWardShiftTime,"^",2)
			.s endTime=$p(^DHCNurWardShiftTime,"^",1)
			.d NightWork
       //NightWork DayWork只把自动查出来的记录设置白班或夜班，最后查数据库已有的记录，一起得出统计数据
       //区别记录的班次时先查数据库，保存的是白班，又有夜班时显示成白夜班，没有记录显示成查询的班次，
       //有白夜班只想删除夜晚的删除记录，自己增加白班，删除白班后夜班的事件不能查出需自己增加
		
		//当天手术查询时在^DHCNurExchageType节点下是手术，显示到界面上时为今日手术，统计到手术计数里
	
		
		s par=$O(^User.DHCNurWardShiftI("LocDate"," "_LocId,$ZDH(FindDate,3),""))
	s ^lf("bingshipar")=par
	s (dayTemorOperSum,nightTemorOperSum)=0
	i (par'="") d
	.s rw="" f  s rw=$O(^User.DHCNurWardShiftD(par,"ChildRec",rw)) q:rw=""  d   //查数据库记录,已经保存过的删除自动查询产生的条目 更新记录的床号
		..s EventType=$ListGet(^User.DHCNurWardShiftD(par,"ChildRec",rw),5)			//Item101
		..
		..s EpisodeID=$ListGet(^User.DHCNurWardShiftD(par,"ChildRec",rw),11)		//Item107
		..s deleteFlag=$ListGet(^User.DHCNurWardShiftD(par,"ChildRec",rw),14)		//Item110
		..q:(deleteFlag=1)
		..s workType=$ListGet(^User.DHCNurWardShiftD(par,"ChildRec",rw),15)  //Item111
		..s type=..GetType(FindDate) 
		..i rw="28" d
		...b
		..i EventType="今日手术" s EventType="手术"
		..i EventType="" s EventType="在院"
		..i (EventType="出院") d 
		...if (EpisodeID'="")&&($p(^PAADM(EpisodeID),"^",75)'="") d 
		....if type'="" d //小孩
		.....d ..GetCountChageRecord(.dayDischSumBaby,.nightDischSumBaby,EventType,workType,EpisodeID,$ZDH(FindDate,3),userId,par,rw,type)
		....e  d ..GetCount(.dayDischSumBaby,.nightDischSumBaby,EventType,workType,EpisodeID,$ZDH(FindDate,3),userId)
		...e  d 
		....if type'="" d  //大人
		.....d ..GetCountChageRecord(.dayDischSum,.nightDischSum,EventType,workType,EpisodeID,$ZDH(FindDate,3),userId,par,rw,type)
		....e  d ..GetCount(.dayDischSum,.nightDischSum,EventType,workType,EpisodeID,$ZDH(FindDate,3),userId)
		..i (EventType="转出") d 
		...if (EpisodeID'="")&&($p(^PAADM(EpisodeID),"^",75)'="") d 
		....if type'="" d //小孩
		.....d ..GetCountChageRecord(.dayTransOutSumBaby,.nightTransOutSumBaby,EventType,workType,EpisodeID,$ZDH(FindDate,3),userId,par,rw,type)
		....e  d ..GetCount(.dayTransOutSumBaby,.nightTransOutSumBaby,EventType,workType,EpisodeID,$ZDH(FindDate,3),userId)
		...e  d
		....if type'="" d  //大人
		.....d ..GetCountChageRecord(.dayTransOutSum,.nightTransOutSum,EventType,workType,EpisodeID,$ZDH(FindDate,3),userId,par,rw,type)
		....e  d ..GetCount(.dayTransOutSum,.nightTransOutSum,EventType,workType,EpisodeID,$ZDH(FindDate,3),userId)
		..i (EventType="死亡") d 
		...if type'="" d 
		....d ..GetCountChageRecord(.dayDeathSum,.nightDeathSum,EventType,workType,EpisodeID,$ZDH(FindDate,3),userId,par,rw,type)
		...e  d ..GetCount(.dayDeathSum,.nightDeathSum,EventType,workType,EpisodeID,$ZDH(FindDate,3),userId)
		..i (EventType="入院") d 
		...if type'="" d 
		....d ..GetCountChageRecord(.dayAdmSum,.nightAdmSum,EventType,workType,EpisodeID,$ZDH(FindDate,3),userId,par,rw,type)
		...e  d ..GetCount(.dayAdmSum,.nightAdmSum,EventType,workType,EpisodeID,$ZDH(FindDate,3),userId)
		..i (EventType="转入") d 
		...if type'="" d 
		....d ..GetCountChageRecord(.dayTransInSum,.nightTransInSum,EventType,workType,EpisodeID,$ZDH(FindDate,3),userId,par,rw,type)
		...e  d ..GetCount(.dayTransInSum,.nightTransInSum,EventType,workType,EpisodeID,$ZDH(FindDate,3),userId)
		..i (EventType="分娩") d 
		 ...if type'="" d ..GetCountChageRecord(.dayBabySum,.nightBabySum,EventType,workType,EpisodeID,$ZDH(FindDate,3),userId,par,rw,type)
		 ...e  d ..GetCount(.dayBabySum,.nightBabySum,EventType,workType,EpisodeID,$ZDH(FindDate,3),userId) 
		..i (EventType="手术") d 
		...if type'="" d ..GetCountChageRecord(.dayOperSum,.nightOperSum,EventType,workType,EpisodeID,$ZDH(FindDate,3),userId,par,rw,type)
		...e  d ..GetCount(.dayOperSum,.nightOperSum,EventType,workType,EpisodeID,$ZDH(FindDate,3),userId) 
		..i (EventType="今日手术") d 
		...if type'="" d ..GetCountChageRecord(.dayOperSum,.nightOperSum,EventType,workType,EpisodeID,$ZDH(FindDate,3),userId,par,rw,type)
		...e  d ..GetCount(.dayOperSum,.nightOperSum,EventType,workType,EpisodeID,$ZDH(FindDate,3),userId) 
		..i (EventType="明日手术") d 
		...if type'="" d ..GetCountChageRecord(.dayTemorOperSum,.nightTemorOperSum,EventType,workType,EpisodeID,$ZDH(FindDate,3),userId,par,rw,type) 
		...e  d ..GetCount(.dayTemorOperSum,.nightTemorOperSum,EventType,workType,EpisodeID,$ZDH(FindDate,3),userId) 
		..i (EventType="病重") d 
		...if type'="" d 
		....d ..GetCountChageRecord(.dayCritiSum,.nightCritiSum,EventType,workType,EpisodeID,$ZDH(FindDate,3),userId,par,rw,type) 
		...e  d ..GetCount(.dayCritiSum,.nightCritiSum,EventType,workType,EpisodeID,$ZDH(FindDate,3),userId)
		..i (EventType="病危") d 
		...if type'="" d 
		....d ..GetCountChageRecord(.daySeveritySum,.nightSeveritySum,EventType,workType,EpisodeID,$ZDH(FindDate,3),userId,par,rw,type)
		...e  d ..GetCount(.daySeveritySum,.nightSeveritySum,EventType,workType,EpisodeID,$ZDH(FindDate,3),userId)
		..i (EventType="在院")  d
		...s type=..GetType(FindDate) 
		...i EpisodeID["10413866"  d
		....b ;444
		...//q:EpisodeID="" 
		...//q:$g(^PAADM(EpisodeID))=""
		...if type'="" d 
		....if (EpisodeID'="")&&($p($g(^PAADM(EpisodeID)),"^",75)'="") d ..GetCountChageRecord(.dayTotalBaby,.nightTotalBaby,EventType,workType,EpisodeID,$ZDH(FindDate,3),userId,par,rw,type) 
		....e  d ..GetCountChageRecord(.dayTotal,.nightTotal,EventType,workType,EpisodeID,$ZDH(FindDate,3),userId,par,rw,type) 
		...e  d
		....if (EpisodeID'="")&&($p($g(^PAADM(EpisodeID)),"^",75)'="") d ..GetCount(.dayTotalBaby,.nightTotalBaby,EventType,workType,EpisodeID,$ZDH(FindDate,3),userId)
		....e  d ..GetCount(.dayTotal,.nightTotal,EventType,workType,EpisodeID,$ZDH(FindDate,3),userId)
	     
	  s date="" f  s date=$O(^DHCNurExchageType(userId,date)) q:date=""  d  //增加自动查询的统计
	   .s eid="" f  s eid=$O(^DHCNurExchageType(userId,date,eid)) q:eid=""  d
	   ..s eventType="" f  s eventType=$O(^DHCNurExchageType(userId,date,eid,eventType)) q:eventType=""  d
	   ...s workType="" f  s workType=$O(^DHCNurExchageType(userId,date,eid,eventType,workType)) q:workType=""  d
	   ....i workType="白班" d  //自动查询是白班时间
	   .....i eventType="出院" s dayDischSum=dayDischSum+1
	   .....i eventType="转出" s dayTransOutSum=dayTransOutSum+1
	   .....i eventType="死亡" s dayDeathSum=dayDeathSum+1
	   .....i eventType="入院" s dayAdmSum=dayAdmSum+1
	   .....i eventType="转入" s dayTransInSum=dayTransInSum+1
	   .....i eventType="分娩" s dayBabySum=dayBabySum+1
	   .....i eventType="手术" s dayOperSum=dayOperSum+1
	   .....i eventType="今日手术" s dayOperSum=dayOperSum+1
	   .....i eventType="病重" s dayCritiSum=dayCritiSum+1
	   .....i eventType="病危" s daySeveritySum=daySeveritySum+1
	   .....i eventType="在院" s dayTotal=dayTotal+1
	   ....e  d   //自动查询是夜班时间
	   .....i eventType="出院" s nightDischSum=nightDischSum+1
	   .....i eventType="转出" s nightTransOutSum=nightTransOutSum+1
	   .....i eventType="死亡" s nightDeathSum=nightDeathSum+1
	   .....i eventType="入院" s nightAdmSum=nightAdmSum+1
	   .....i eventType="转入" s nightTransInSum=nightTransInSum+1
	   .....i eventType="分娩" s nightBabySum=nightBabySum+1
	   .....i eventType="手术" s nightOperSum=nightOperSum+1
	   .....i eventType="今日手术" s nightOperSum=nightOperSum+1
	   .....i eventType="病重" s nightCritiSum=nightCritiSum+1
	   .....i eventType="病危" s nightSeveritySum=nightSeveritySum+1
	   .....i eventType="在院" s nightTotal=nightTotal+1
	  
	  s type=..GetType(FindDate)
	  if (type="")&&(par'="")&&((+$h)<63266) {
		  
	   //除了今日白班夜班，其他都只查记录，不更新事件
			s arr=$G(^User.DHCNurWardShiftD(par))
			s dayTotal=$listGet(arr,3)
			s dayAdmSum=$listGet(arr,14)
			s dayTransInSum=$listGet(arr,25)
			s dayDischSum=$listGet(arr,27)
			s dayTransOutSum=$listGet(arr,28)
			s dayDeathSum=$listGet(arr,29)
			s dayOperSum=$listGet(arr,30)
			s dayBabySum=$listGet(arr,31)
			s daySeveritySum=$listGet(arr,4)
			s dayCritiSum=$listGet(arr,32)
			s dayNurse=$ListGet(arr,16)
			//s retStr=dayTotal_"^"_dayAdmSum_"^"_dayTransInSum_"^"_dayDischSum_"^"_dayTransOutSum_"^"_dayDeathSum_"^"_dayOperSum_"^"_dayBabySum_"^"_dayCritiSum_"^"_daySeveritySum_"^"_dayNurse

			s nightTotal=$ListGet(arr,5)
			s nightAdmSum=$ListGet(arr,6)
			s nightTransInSum=$ListGet(arr,7)
			s nightDischSum=$ListGet(arr,8)
			s nightTransOutSum=$ListGet(arr,9)
			s nightDeathSum=$ListGet(arr,10)
			s nightOperSum=$ListGet(arr,11)
			s nightBabySum=$ListGet(arr,12)
			s nightSeveritySum=$ListGet(arr,15)
			s nightCritiSum=$ListGet(arr,13)
			s nightNurse=$ListGet(arr,17)
			//s retStr=retStr_"@"_nightTotal_"^"_nightAdmSum_"^"_nightTransInSum_"^"_nightDischSum_"^"_nightTransOutSum_"^"_nightDeathSum_"^"_nightOperSum_"^"_nightBabySum_"^"_nightCritiSum_"^"_nightSeveritySum_"^"_nightNurse
		}
	   if $G(dayTotalBaby)'=0 s dayTotal=$g(dayTotal)_"/"_$g(dayTotalBaby)
	   if $G(nightTotalBaby)'=0 s nightTotal=$g(nightTotal)_"/"_$g(nightTotalBaby)
	   if $G(dayDischSumBaby)'=0 s dayDischSum=$g(dayDischSum)_"/"_$g(dayDischSumBaby)
	   if $G(nightDischSumBaby)'=0 s nightDischSum=$g(nightDischSum)_"/"_$g(nightDischSumBaby)
	   if $G(dayTransOutSumBaby)'=0 s dayTransOutSum=$g(dayTransOutSum)_"/"_$g(dayTransOutSumBaby)
	   if $G(nightTransOutSumBaby)'=0 s nightTransOutSum=$g(nightTransOutSum)_"/"_$g(nightTransOutSumBaby)
	   //$g(nightTotal)
	s retStr=$g(dayTotal)_"^"_$g(dayAdmSum)_"^"_$g(dayTransInSum)_"^"_$g(dayDischSum)_"^"_$g(dayTransOutSum)_"^"_$g(dayDeathSum)_"^"_$g(dayOperSum)_"^"_$g(dayBabySum)_"^"_$g(dayCritiSum)_"^"_$g(daySeveritySum)_"^"_$g(dayNurse)_"@"_$g(nightTotal)_"^"_$g(nightAdmSum)_"^"_$g(nightTransInSum)_"^"_$g(nightDischSum)_"^"_$g(nightTransOutSum)_"^"_$g(nightDeathSum)_"^"_$g(nightOperSum)_"^"_$g(nightBabySum)_"^"_$g(nightCritiSum)_"^"_$g(nightSeveritySum)_"^"_$g(nightNurse)
	q retStr
			
DayWork
			;s dayTotal="",dayAdmSum="",dayTransInSum="",dayDischSum="",dayTransOutSum=""
			;s dayDeathSum="",dayOperSum="",dayBabySum="",daySeveritySum="",dayCritiSum=""
			//s dayNurse=""
			//s ^pjf("Day")=startDate_"@"_startTime_"!"_endDate_"@"_endTime
			i (LocType="W")!(LocType="EM") {
				s rset=##class(%ResultSet).%New("web.DHCNurShiftExchage:GetWardItemSummary")
				do rset.Execute(startDate,endDate,wardId,wardDesc,startTime,endTime,userId,type)
				while (rset.Next()) {
					//以前版本的统计数据只取在院人数，其他根据^DHCNurExchageType统计
					//b //tDate"",tAdmSum"",tDischSum"",tTransInSum,tTransOutSum,tSpecCareSum,tACareSum,tOperSum,tCritiSum,tDeathSum,tBirthSum,tSeveritySum
					/*s dayAdmSum=rset.GetData(2)
					s dayTransInSum=rset.GetData(4)
					s dayDischSum=rset.GetData(3)
					s dayTransOutSum=rset.GetData(5)
					s dayDeathSum=rset.GetData(10)
					s dayOperSum=rset.GetData(8)
					s dayBabySum=rset.GetData(11)
					s daySeveritySum=rset.GetData(12)
					s dayCritiSum=rset.GetData(9)*/
					/*s dayAdmSum=0
					s dayTransInSum=0
					s dayDischSum=0
					s dayTransOutSum=0
					s dayDeathSum=0
					s dayOperSum=0
					s dayBabySum=0
					s daySeveritySum=0
					s dayCritiSum=0
					s dayTotal=rset.GetData(13)*/
					b //day
				}	
				d rset.Close()
			}
			i (LocType="E"){
				s retShiftStr=##class(web.DHCNurShiftExchage).GetLocItemSummary(startDate,endDate,startTime,endTime,LocId,userId)
				s dayAdmSum=$P(retShiftStr,"^",1)
				s dayTransInSum=$P(retShiftStr,"^",2)
				s dayDischSum=$P(retShiftStr,"^",3)
				s dayTransOutSum=$P(retShiftStr,"^",4)
				s dayDeathSum=$P(retShiftStr,"^",5)
				s dayOperSum=$P(retShiftStr,"^",6)
				s dayBabySum=$P(retShiftStr,"^",7)
				s dayCritiSum=$P(retShiftStr,"^",8)
				s daySeveritySum=$P(retShiftStr,"^",9)
				s dayTotal=$P(retShiftStr,"^",10)
			
			}
			//s dayTotal=dayTotal+dayAdmSum+dayTransInSum+dayDischSum+dayTransOutSum+dayDeathSum+dayOperSum+dayBabySum+daySeveritySum+dayCritiSum
			//s retStr=dayTotal_"^"_dayAdmSum_"^"_dayTransInSum_"^"_dayDischSum_"^"_dayTransOutSum_"^"_dayDeathSum_"^"_dayOperSum_"^"_dayBabySum_"^"_dayCritiSum_"^"_daySeveritySum_"^"
			//q retStr
			q
NightWork
			//夜间7-7
			//s ^pjf("Night")=startDate_"@"_startTime_"!"_endDate_"@"_endTime
			;s nightTotal="",nightAdmSum="",nightTransInSum="",nightDischSum="",nightTransOutSum=""
			;s nightDeathSum="",nightOperSum="",nightBabySum="",nightSeveritySum="",nightCritiSum=""
			//s nightNurse=""
			i (LocType="W")!(LocType="W"){
				//b ;002
				s rset=##class(%ResultSet).%New("web.DHCNurShiftExchage:GetWardItemSummary")
				do rset.Execute(startDate,endDate,wardId,wardDesc,startTime,endTime,userId,type)
				while (rset.Next()) {
					/*s nightAdmSum=nightAdmSum+rset.GetData(2)
					s nightTransInSum=nightTransInSum+rset.GetData(4)
					s nightDischSum=nightDischSum+rset.GetData(3)
					s nightTransOutSum=nightTransOutSum+rset.GetData(5)
					s nightDeathSum=nightDeathSum+rset.GetData(10)
					s nightOperSum=nightOperSum+rset.GetData(8)
					s nightBabySum=nightBabySum+rset.GetData(11)
					s nightSeveritySum=nightSeveritySum+rset.GetData(12)
					s nightCritiSum=nightCritiSum+rset.GetData(9)*/
					/*s nightAdmSum=0
					s nightTransInSum=0
					s nightDischSum=0
					s nightTransOutSum=0
					s nightDeathSum=0
					s nightOperSum=0
					s nightBabySum=0
					s nightSeveritySum=0
					s nightCritiSum=0
					s nightTotal=rset.GetData(13)*/
				}
				d rset.Close()
			}
			i (LocType="E"){
				s retShiftStr=##class(web.DHCNurShiftExchage).GetLocItemSummary(startDate,endDate,startTime,endTime,LocId,userId)
				s nightAdmSum=$P(retShiftStr,"^",1)
				s nightTransInSum=$P(retShiftStr,"^",2)
				s nightDischSum=$P(retShiftStr,"^",3)
				s nightTransOutSum=$P(retShiftStr,"^",4)
				s nightDeathSum=$P(retShiftStr,"^",5)
				s nightOperSum=$P(retShiftStr,"^",6)
				s nightBabySum=$P(retShiftStr,"^",7)
				s nightCritiSum=$P(retShiftStr,"^",8)
				s nightSeveritySum=$P(retShiftStr,"^",9)
				s nightTotal=$P(retShiftStr,"^",10)
			}
			//s nightTotal=nightTotal+nightAdmSum+nightTransInSum+nightDischSum+nightTransOutSum+nightDeathSum+nightOperSum+nightBabySum+nightSeveritySum+nightCritiSum
		q
}

ClassMethod GetCountChageRecord(dayCount, nightCount, eventType, workType, EpisodeID, Date, userId, parr, chl, searchType) As %String
{
	//删除已经查不找但之前已经保存的记录, 更新床号
	i eventType="明日手术" s Date=Date+1
	s id=parr_"||"_chl
	i (workType="白夜班")  d
	.s dayCount=dayCount+1,nightCount=nightCount+1
	.q:$G(EpisodeID)=""
	.q:$g(searchType)=""
	.s a=##class(User.DHCNurWardShiftSub).%OpenId(id)
	.i $d(^DHCNurExchageType(userId,Date,EpisodeID,eventType,"白班"))  d  //白天有白夜班，为手动修改，不在病区时不用修改其他信息
	 ..s a.Item102=$p(^DHCNurExchageType(userId,Date,EpisodeID,eventType,"白班"),"^",1) //修改床号
	 ..d a.%Save()
	 ..k ^DHCNurExchageType(userId,Date,EpisodeID,eventType,"白班")
	
	.s nightFlag=0
	.if (searchType="Night")&&($d(^DHCNurExchageType(userId,Date,EpisodeID,eventType,"夜班"))) d
	..s nightFlag=1
	 ..s a.Item102=$p(^DHCNurExchageType(userId,Date,EpisodeID,eventType,"夜班"),"^",1) //修改床号
	 ..s:a.Item106="" a.Item106=$p(^DHCNurExchageType(userId,Date,EpisodeID,eventType,"夜班"),"^",6) 
	 ..d a.%Save()
	 ..k ^DHCNurExchageType(userId,Date,EpisodeID,eventType,"夜班")
	.if (searchType="Night")&&($d(^DHCNurExchageType(userId,Date+1,EpisodeID,eventType,"夜班"))) d
	 ..s nightFlag=1
	 ..s a.Item102=$p(^DHCNurExchageType(userId,Date+1,EpisodeID,eventType,"夜班"),"^",1) //修改床号
	 ..s:a.Item106="" a.Item106=$p(^DHCNurExchageType(userId,Date+1,EpisodeID,eventType,"夜班"),"^",6) 
	 ..d a.%Save()
	 ..k ^DHCNurExchageType(userId,Date+1,EpisodeID,eventType,"夜班")
	 .if (searchType="Night")&&(nightFlag=0)  d
	  ..s nightCount=nightCount-1  //白夜班，当天夜晚，人不在，改成白班
	  ..;s a.Item110=1
	  ..s a.Item111="白班"
	  ..d a.%Save() //
	  
	;m ^objcyf10102Copy=^DHCNurExchageType
	i (workType="夜班") d
	.s a=##class(User.DHCNurWardShiftSub).%OpenId(id)
	.s nightCount=nightCount+1
	.q:$G(EpisodeID)=""
	.q:$g(searchType)=""
	.s nightFlag=0
	.if $d(^DHCNurExchageType(userId,Date,EpisodeID,eventType,"夜班")) d
	..s nightFlag=1
	 ..s a.Item102=$p(^DHCNurExchageType(userId,Date,EpisodeID,eventType,"夜班"),"^",1) //修改床号
	 ..d a.%Save()
	 ..k ^DHCNurExchageType(userId,Date,EpisodeID,eventType,"夜班")
	.if $d(^DHCNurExchageType(userId,Date+1,EpisodeID,eventType,"夜班")) d
	 ..s nightFlag=1
	 ..s a.Item102=$p(^DHCNurExchageType(userId,Date+1,EpisodeID,eventType,"夜班"),"^",1) //修改床号
	 ..d a.%Save()
	 .. k ^DHCNurExchageType(userId,Date+1,EpisodeID,eventType,"夜班")
	.if nightFlag=0  d
	  ..i (searchType="Night") d //当天夜晚，人不在，删记录
	  ...//s ^objcyf1010=searchType
	  ...s nightCount=nightCount-1
	  ...s a.Item110=1
	  ...d a.%Save() //删除数据
	i (workType="白班") d
	.s a=##class(User.DHCNurWardShiftSub).%OpenId(id)
	.s dayCount=dayCount+1
	.q:$G(EpisodeID)=""
	.q:$g(searchType)=""
	.i $d(^DHCNurExchageType(userId,Date,EpisodeID,eventType,"白班"))  d
	 ..s a.Item102=$p(^DHCNurExchageType(userId,Date,EpisodeID,eventType,"白班"),"^",1) //修改床号
	 ..d a.%Save()
	 ..k ^DHCNurExchageType(userId,Date,EpisodeID,eventType,"白班")
	.e  d
	..i (searchType="Day") d //当天白天，人不在，删记录
	...;s ^objcyf10102(id)=userId_"%"_Date
	...;s ^objcyf10102=userId_"&"_Date_"&"_EpisodeID_"&"_eventType
	...s dayCount=dayCount-1
	...s a.Item110=1
	...d a.%Save() //删除数据
	q ""
}

ClassMethod GetCount(dayCount, nightCount, eventType, workType, EpisodeID, Date, userId) As %String
{
	
	i eventType="明日手术" s Date=Date+1
	i (workType="白夜班")  d
	.s dayCount=dayCount+1,nightCount=nightCount+1
	.q:$G(EpisodeID)=""
	.i $d(^DHCNurExchageType(userId,Date,EpisodeID,eventType,"白班")) k ^DHCNurExchageType(userId,Date,EpisodeID,eventType,"白班")
	.i $d(^DHCNurExchageType(userId,Date,EpisodeID,eventType,"夜班")) k ^DHCNurExchageType(userId,Date,EpisodeID,eventType,"夜班")
	.i $d(^DHCNurExchageType(userId,Date+1,EpisodeID,eventType,"夜班")) k ^DHCNurExchageType(userId,Date+1,EpisodeID,eventType,"夜班")
	i (workType="夜班") d
	.s nightCount=nightCount+1
	.q:$G(EpisodeID)=""
	.i $d(^DHCNurExchageType(userId,Date,EpisodeID,eventType,"夜班")) k ^DHCNurExchageType(userId,Date,EpisodeID,eventType,"夜班")
	.i $d(^DHCNurExchageType(userId,Date+1,EpisodeID,eventType,"夜班")) k ^DHCNurExchageType(userId,Date+1,EpisodeID,eventType,"夜班")
	i (workType="白班") d
	.s dayCount=dayCount+1
	.q:$G(EpisodeID)=""
	.i $d(^DHCNurExchageType(userId,Date,EpisodeID,eventType,"白班")) k ^DHCNurExchageType(userId,Date,EpisodeID,eventType,"白班")
	q ""
}

/// 病室报告/打印调用
ClassMethod GetExchagePrint(parr) As %String
{
    //w ##class(web.DHCNurShiftExchage).GetExchagePrint("211#2011-10-25")
	s LocId=$P(parr,"#",1)
	s CareDate=$P(parr,"#",2)
	if (LocId="")!(CareDate="") q ""
	b //
    s Id=$O(^User.DHCNurWardShiftI("LocDate"," "_LocId,$ZDH(CareDate,3),""))
    if Id="" q ""
	s tmp=""
	s a=##class(User.DHCNurWardShift).getVal(Id,.tmp)
	s tmp("LocDr")=LocId_"@"_$P($p($g(^CTLOC(LocId)),"^",2),"-",2)
	s tmp("CareDate")=CareDate
	s retArr=..getRet(.tmp)
	s retArr=$TR(retArr,"|","&")
	s retArr=$TR(retArr,"@","|")
	q retArr
}

/// 病室报告打印/表格不能自动换行
ClassMethod GetExchagePrintTableExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
	//d ##class(%ResultSet).RunQuery("web.DHCNurShiftExchage","GetExchagePrintTable","211#2011-10-25")
	s LocId=$P(parr,"#",1)
	s CareDate=$P(parr,"#",2)
	if (LocId="")!(CareDate="") q ""
    s par=$O(^User.DHCNurWardShiftI("LocDate"," "_LocId,$ZDH(CareDate,3),""))
    if par="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s rw="" f  s rw=$O(^User.DHCNurWardShiftD(par,"ChildRec",rw)) q:rw=""  d
	.s tmp("Item101")=$ListGet(^User.DHCNurWardShiftD(par,"ChildRec",rw),5)		//Item101
	.s tmp("Item102")=$ListGet(^User.DHCNurWardShiftD(par,"ChildRec",rw),6)		//Item102
	.s tmp("Item103")=$ListGet(^User.DHCNurWardShiftD(par,"ChildRec",rw),7)		//Item103
	.s tmp("Item104")=$ListGet(^User.DHCNurWardShiftD(par,"ChildRec",rw),8)		//Item104
	.s tmp("Item105")=$ListGet(^User.DHCNurWardShiftD(par,"ChildRec",rw),9)		//Item105
	.s tmp("Item106")=$ListGet(^User.DHCNurWardShiftD(par,"ChildRec",rw),10)	//Item106
	.s ret="",k=""  
	.f  s k=$O(tmp(k)) q:k=""  d
	..s ret=ret_k_"|"_tmp(k)_"^"
	.d OutRowtyp
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetExchagePrintTableFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetExchagePrintTableExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetExchagePrintTableClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetExchagePrintTableExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

Query GetExchagePrintTable(parr As %String) As %Query(ROWSPEC = "aa")
{
}

/// 病室报告打印/护理记录单格式可以自动换行
ClassMethod GetExchagePrintTbExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s ^pjf(111)=parr
	//d ##class(%ResultSet).RunQuery("web.DHCNurShiftExchage","GetExchagePrintTb","130#2014-10-20")
	s LocId=$P(parr,"#",1)
	s CareDate=$P(parr,"#",2)
	i CareDate["/"  s CareDate=##class(websys.Conversions).DateHtmlToLogical(CareDate)
	else  s CareDate=$ZDH(CareDate,3)
	s i=" "
	if (LocId="")!(CareDate="") Set qHandle=$lb(0,repid,0) Quit $$$OK
    s par=$O(^User.DHCNurWardShiftI("LocDate"," "_LocId,CareDate,""))
    if par="" Set qHandle=$lb(0,repid,0) Quit $$$OK
    s ii=0
	s rw="" f  s rw=$O(^User.DHCNurWardShiftD(par,"ChildRec",rw)) q:rw=""  d
	.s deleteFlag=$ListGet(^User.DHCNurWardShiftD(par,"ChildRec",rw),14)
	.q:(deleteFlag=1)
	.s Item101=$ListGet(^User.DHCNurWardShiftD(par,"ChildRec",rw),5)		//Item101
	.s Item102=$ListGet(^User.DHCNurWardShiftD(par,"ChildRec",rw),6)		//Item102
	.s Item103=$ListGet(^User.DHCNurWardShiftD(par,"ChildRec",rw),7)		//Item103
	.s Item104=$ListGet(^User.DHCNurWardShiftD(par,"ChildRec",rw),8)		//Item104
	.s Item105=$ListGet(^User.DHCNurWardShiftD(par,"ChildRec",rw),9)		//Item105
	.s Item106=$ListGet(^User.DHCNurWardShiftD(par,"ChildRec",rw),10)		//Item106
	.s Item105=$tr(Item105," ","")
	.s Item106=$tr(Item106," ","")
	.s Item105=$tr(Item105,$c(13,10),"")
	.s Item106=$tr(Item106,$c(13,10),"")
	.q:(Item105="")&(Item106="")
	.;i Item105["/" s Item105=$tr(Item105,"/","-")
	.;i Item106["/" s Item106=$tr(Item106,"/","-")
	.;s Item105="a"
	.;s Item106="b"
	.s ii=ii+1
	.if Item102="" s Item102="z"_ii,i=i_" "
	.e  s Item102="A"_Item102
	.;s Item102=ii
	.s sort(Item101,Item102,rw)=^User.DHCNurWardShiftD(par,"ChildRec",rw)
	.b ;88
	;.;d OutRowtyp2
	s TypeStr="出院^转出^死亡^入院^转入^分娩^手术^今日手术^明日手术^病重^病危^在院"
	s typeNum=$l(TypeStr,"^")
	f i=1:1:typeNum
	{
		s type=$p(TypeStr,"^",i)
		s bed="" f  s bed=$o(sort(type,bed)) q:bed=""  d
		.s rw=0 f  s rw=$o(sort(type,bed,rw)) q:rw=""  d
		..s Item101=$ListGet(sort(type,bed,rw),5)		//Item101
		..s Item102=$ListGet(sort(type,bed,rw),6)		//Item102
		..s Item103=$ListGet(sort(type,bed,rw),7)		//Item103
		..s Item104=$ListGet(sort(type,bed,rw),8)		//Item104
		..s Item105=$ListGet(sort(type,bed,rw),9)		//Item105
		..s Item106=$ListGet(sort(type,bed,rw),10)		//Item106
		..s Item105=$replace(Item105,$c(13,10),"&&")
	    ..s Item106=$replace(Item106,$c(13,10),"&&")
		..d OutRowtyp2
	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp2
	set Data=$lb(Item101,Item102,Item103,Item104,Item105,Item106)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetExchagePrintTbFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetExchagePrintTbExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetExchagePrintTbClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetExchagePrintTbExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

Query GetExchagePrintTb(parr As %String) As %Query(ROWSPEC = "Item101,Item102,Item103,Item104,Item105,Item106") [ SqlProc ]
{
}

/// 取病室报告汇总数据//护理记录单格式打印调用
ClassMethod GetExchageSummaryTb(parr = "") As %String
{
	//w ##class(web.DHCNurShiftExchage).GetExchageSummaryTb("211^2011-10-24")
	q:parr="" ""
	s LocId=$P(parr,"#",1)
	;s LocDesc=$P($p($g(^CTLOC(LocId)),"^",2),"-",2)
	s LocDesc=$p($g(^CTLOC(LocId)),"^",2)
	s SumDate=$P(parr,"#",2)
	s retStr="科室:"_..FillSpace(LocDesc,12)_"日期:"_SumDate
	s userId=$P(parr,"^",3)
	//判断是否保存过汇总记录
	s:SumDate["/" SumDate=$zdh(SumDate,4),SumDate=$zd(SumDate,3)
	b //09
	s par=$O(^User.DHCNurWardShiftI("LocDate"," "_LocId,$ZDH(SumDate,3),""))
	b //99
	if par="" q ""
	s arr=$G(^User.DHCNurWardShiftD(par))
	if arr="" q ""
	s dayTotal=$listGet(arr,7)
	s dayAdmSum=$listGet(arr,8)
	s dayTransInSum=$listGet(arr,9)
	s dayDischSum=$listGet(arr,10)
	s dayTransOutSum=$listGet(arr,11)
	s dayDeathSum=$listGet(arr,12)
	s dayOperSum=$listGet(arr,13)
	s dayBabySum=$listGet(arr,14)
	s daySeveritySum=$listGet(arr,15)
	s dayCritiSum=$listGet(arr,16)
	s dayNurse=$ListGet(arr,27)
	s retStr=retStr_"^总数:"_..FillSpace(dayTotal,3)_"入院:"_..FillSpace(dayAdmSum,3)_"转入:"_..FillSpace(dayTransInSum,3)_"出院:"_..FillSpace(dayDischSum,3)_"转出:"_..FillSpace(dayTransOutSum,3)_"死亡:"_..FillSpace(dayDeathSum,3)_"手术:"_..FillSpace(dayOperSum,3)_"分娩:"_..FillSpace(dayBabySum,3)_"病重:"_..FillSpace(daySeveritySum,3)_"病危:"_..FillSpace(dayCritiSum,3)
	s nightTotal=$ListGet(arr,17)
	s nightAdmSum=$ListGet(arr,18)
	s nightTransInSum=$ListGet(arr,19)
	s nightDischSum=$ListGet(arr,20)
	s nightTransOutSum=$ListGet(arr,21)
	s nightDeathSum=$ListGet(arr,22)
	s nightOperSum=$ListGet(arr,23)
	s nightBabySum=$ListGet(arr,24)
	s nightSeveritySum=$ListGet(arr,25)
	s nightCritiSum=$ListGet(arr,26)
	s nightNurse=$ListGet(arr,28)
	s retStr=retStr_"^总数:"_..FillSpace(nightTotal,3)_"入院:"_..FillSpace(nightAdmSum,3)_"转入:"_..FillSpace(nightTransInSum,3)_"出院:"_..FillSpace(nightDischSum,3)_"转出:"_..FillSpace(nightTransOutSum,3)_"死亡:"_..FillSpace(nightDeathSum,3)_"手术:"_..FillSpace(nightOperSum,3)_"分娩:"_..FillSpace(nightBabySum,3)_"病重:"_..FillSpace(nightSeveritySum,3)_"病危:"_..FillSpace(nightCritiSum,3)
	s retStr=retStr_"^日间签字:"_..FillSpace(dayNurse,10)_"夜间签字:"_nightNurse
	q retStr
}

/// 补空格/为打印时整齐换行用
ClassMethod FillSpace(inStr = "", spaceNum = 1) As %String
{
	s outStr=inStr
	f i=$l(inStr):1:spaceNum d
	.s outStr=outStr_" "
	q outStr
}

/// 取日期+时间的数字格式
ClassMethod GetAbsTime(dt As %String) As %String
{
	//将日期时间转换成秒
	s dat=$P(dt,",",1),tim=$P(dt,",",2)
	q ((dat*86400)+tim)
}

/// 科室查询
ClassMethod GetLocItemSummary(startDate As %String, endDate As %String, startTime As %String, endTime As %String, locId As %String, userId As %String) As %String
{
 	//w ##class(web.DHCNurShiftExchage).GetLocItemSummary(62395,62395,25201,68400,31,3879)
 	i (startDate="")&(endDate="")&(locId="")  q ""
 	i startDate="" s startDate=+$H
 	e  d
 	.i startDate["/" s startDate=$ZDH(startDate,4)
 	.i startDate["-" s startDate=$ZDH(startDate,3)
 	i endDate="" s endDate=+$H
  	e  d
 	.i endDate["/" s endDate=$ZDH(endDate,4)
 	.i endDate["-" s endDate=$ZDH(endDate,3)	
 	//最多查询一个周内数据,以结束日期为准
 	i endDate-startDate>7 s startDate=endDate-7
 	i startTime="" s startTime=0
 	i endTime="" s endTime=86400
 	i userId="" s userId=%session.Data("LOGON.USERID")
 	//k ^DHCNurExchage(userId)	//病室报告分日间与夜间查看注释调试
	s stdatetime=..GetAbsTime(startDate_","_startTime)
	s edatetime=..GetAbsTime(endDate_","_endTime)
	s sTime=startTime
	s eTime=endTime
 	s (admSum,dischSum,transInSum,transOutSum,specCareSum,aCareSum,operSum,critiSum,deathSum,birthSum,severitySum,totalNum)=0
	s patAdmDate="" f  s patAdmDate=$o(^PAADMi("TDepDateTime","I",locId,patAdmDate)) q:patAdmDate=""  d
 	.s patAdmTime=0 f  s patAdmTime=$o(^PAADMi("TDepDateTime","I",locId,patAdmDate,patAdmTime)) q:patAdmTime=""  d
	..s EpisodeID=0 f  s EpisodeID=$o(^PAADMi("TDepDateTime","I",locId,patAdmDate,patAdmTime,EpisodeID)) q:EpisodeID=""  d
	...s pavisit=$p($g(^PAADM(EpisodeID)),"^",20)
	...i pavisit="D" d
	....//出院
	....s disDate=$p($g(^PAADM(EpisodeID)),"^",17)
    ....s disTime=$p($g(^PAADM(EpisodeID)),"^",18)
	....s disDateTime=..GetAbsTime(disDate_","_disTime)
    ....i disDateTime>=stdatetime,disDateTime<edatetime d
	.....s dischSum=dischSum+1
    .....s patInfo=..PatInfo1(EpisodeID)
    .....s ^DHCNurExchage(userId,$ZD(disDate,3),"出院",dischSum)=$p(patInfo,"^",7)_"^"_$p(patInfo,"^",5)_"^"_$p(patInfo,"^",14)_"^"_EpisodeID
 	...q:pavisit'="A"
 	...s totalNum=totalNum+1
	...//入院
	...s admDateTime=..GetAbsTime(patAdmDate_","_patAdmTime)
    ...i admDateTime>=stdatetime,admDateTime<edatetime d
    ....s admSum=admSum+1
    ....s patInfo=..PatInfo1(EpisodeID)
    ....s ^DHCNurExchage(userId,$ZD(patAdmDate,3),"入院",admSum)=$p(patInfo,"^",7)_"^"_$p(patInfo,"^",5)_"^"_$p(patInfo,"^",14)_"^"_EpisodeID
	...f admDate=startDate:1:endDate d
	....//病重
    ....s critiSumFlag=..IfExistOrder(admDate,EpisodeID, "N0303^N0303",sTime,eTime)
    ....i critiSumFlag=1 d
    .....s critiSum=critiSum+1
    .....s patInfo=..PatInfo1(EpisodeID)
    .....s ^DHCNurExchage(userId,$ZD(admDate,3),"病重",critiSum)=$p(patInfo,"^",7)_"^"_$p(patInfo,"^",5)_"^"_$p(patInfo,"^",14)_"^"_EpisodeID
    ....//病危
    ....s severitySumFlag=..IfExistOrder(admDate,EpisodeID, "N0301^N0302",sTime,eTime)
    ....i severitySumFlag=1 d
    .....s severitySum=severitySum+1
    .....s patInfo=..PatInfo1(EpisodeID)
    .....s ^DHCNurExchage(userId,$ZD(admDate,3),"病危",severitySum)=$p(patInfo,"^",7)_"^"_$p(patInfo,"^",5)_"^"_$p(patInfo,"^",14)_"^"_EpisodeID
    ....//手术
    ....s operSumFlag=..IfExistOrder(admDate,EpisodeID, "ZT0026^ZT0027",sTime,eTime)
    ....i operSumFlag=1 d
    .....s operSum=operSum+1
    .....s patInfo=..PatInfo1(EpisodeID)
    .....s ^DHCNurExchage(userId,$ZD(admDate,3),"手术",operSum)=$p(patInfo,"^",7)_"^"_$p(patInfo,"^",5)_"^"_$p(patInfo,"^",14)_"^"_EpisodeID
    ....//死亡
    ....s mrAdmId=$p(^PAADM(EpisodeID),"^",61)
	....s disconId=$p($g(^MR(mrAdmId,"PRO",1)),"^",10)
	....i disconId'="" s disconDeadFlag=$p($g(^PAC("DISCON",disconId)),"^",3)
	....e  s disconDeadFlag=""
	....i disconDeadFlag="D" d  //medtrak中维护是否死亡标志
	.....s papmiId=$p(^PAADM(EpisodeID),"^",1)
	.....s DeceasedDate=$p($g(^PAPER(papmiId,"ALL")),"^",13) 	//PAPER_Deceased_Date
    .....s DeceasedTime=$p($g(^PAPER(papmiId,"ALL")),"^",8) 	//PAPER_DeceasedTime
	.....s DeceasedDateTime=..GetAbsTime(DeceasedDate_","_DeceasedTime)
    .....i DeceasedDateTime>=stdatetime,DeceasedDateTime<edatetime d
	......s deathSum=deathSum+1
	......s patInfo=..PatInfo1(EpisodeID)
	......s ^DHCNurExchage(userId,$ZD(admDate,3),"死亡",deathSum)=$p(patInfo,"^",7)_"^"_$p(patInfo,"^",5)_"^"_$p(patInfo,"^",14)_"^"_EpisodeID
	....//生产
	....//s MotherAdmDR=$p(^PAADM(EpisodeID),"^",75)
	....//i MotherAdmDR'="" d
	....//.s babyAdmDateTime=..GetAbsTime(patAdmDate_","_patAdmTime)
    ....//.i babyAdmDateTime>=stdatetime,babyAdmDateTime<edatetime d
	....//..s birthSum=birthSum+1
	....//..s patInfo=..PatInfo1(DELAdmDR)
	....//..s ^DHCNurExchage(userId,$ZD(admDate,3),"生产",birthSum)=$p(patInfo,"^",7)_"^"_$p(patInfo,"^",5)_"^"_$p(patInfo,"^",14)_"^"_EpisodeID
	....//分娩
	....s PREGRowId=0
	....f  s PREGRowId=$O(^PAPRGi("DEL_Adm_DR",EpisodeID,PREGRowId)) q:PREGRowId=""  d
	.....s Childsub=0
	.....f  s Childsub=$O(^PAPRGi("DEL_Adm_DR",EpisodeID,PREGRowId,"DEL",Childsub)) q:Childsub=""  d
	......s LabourOnsetDate=$P($G(^PAPRG(PREGRowId,"DEL",Childsub)),"^",19)		//PA_PregDelivery	//DEL_LabourOnsetDate
	......s LabourOnsetTime=$P($G(^PAPRG(PREGRowId,"DEL",Childsub)),"^",20)		//PA_PregDelivery	//DEL_LabourOnsetTime
	......i LabourOnsetTime="" s LabourOnsetTime=0
	......s LabourDateTime=..GetAbsTime(LabourOnsetDate_","_LabourOnsetTime)
    ......i LabourDateTime>=stdatetime,LabourDateTime<edatetime d
	.......s birthSum=birthSum+1
	.......s patInfo=..PatInfo1(DELAdmDR)
	.......s ^DHCNurExchage(userId,$ZD(admDate,3),"分娩",birthSum)=$p(patInfo,"^",7)_"^"_$p(patInfo,"^",5)_"^"_$p(patInfo,"^",14)_"^"_EpisodeID

	//转入转出
	f admDate=startDate:1:endDate d
    .s EpisodeID="" f  s EpisodeID=$O(^PAADMi("TransEndDate",admDate,EpisodeID)) q:EpisodeID=""  d
    ..s transIndex=0,PreLoc=""
    ..k temp
    ..s Childsub="" f  s Childsub=$O(^PAADMi("TransEndDate",admDate,EpisodeID,Childsub),-1) q:(Childsub="")!(transIndex>2)  d
    ...s loc=$P(^PAADM(EpisodeID,"TRANS",Childsub),"^",6)
  	...q:loc=""
	...s transStDate=$P($G(^PAADM(EpisodeID,"TRANS",Childsub)),"^",1)
  	...s transStTime=$P($G(^PAADM(EpisodeID,"TRANS",Childsub)),"^",2)
  	...s transEndDate=$P($G(^PAADM(EpisodeID,"TRANS",Childsub)),"^",3)
    ...s transEndTime=$P($G(^PAADM(EpisodeID,"TRANS",Childsub)),"^",4)
    ...i loc'=PreLoc d
    ....s transIndex=transIndex+1
    ....s temp(transIndex,EpisodeID,loc)=((transStDate*86400)+transStTime)_"^"_((transEndDate*86400)+transEndTime)
    ....s PreLoc=loc
	..//转入//转科记录有两条且最后一条是当前科室的
	..i $D(temp(2,EpisodeID))>0,$G(temp(1,EpisodeID,locId))'="" d
	...s transDateTime=+$P($G(temp(1,EpisodeID,locId)),"^",1)
    ...i transDateTime>=stdatetime,transDateTime<edatetime d
    ....s transInSum=transInSum+1
	....s patInfo=..PatInfo1(EpisodeID)
    ....s ^DHCNurExchage(userId,$ZD(transStDate,3),"转入",transInSum)=$p(patInfo,"^",7)_"^"_$p(patInfo,"^",5)_"^"_$p(patInfo,"^",14)_"^"_EpisodeID
    ..//转出//转科记录倒数第二条是当前科室的
    ..i $G(temp(2,EpisodeID,locId))'="" d
    ...s transDateTime=+$P($G(temp(1,EpisodeID,locId)),"^",2)
    ...i transDateTime>=stdatetime,transDateTime<edatetime d
	....s transOutSum=transOutSum+1
	....s patInfo=..PatInfo1(EpisodeID)
    ....s ^DHCNurExchage(userId,$ZD(transEndDate,3),"转出",transOutSum)=$p(patInfo,"^",7)_"^"_$p(patInfo,"^",5)_"^"_$p(patInfo,"^",14)_"^"_EpisodeID 
	s totalSum=admSum + transInSum + dischSum + transOutSum + deathSum + operSum + birthSum + severitySum + critiSum
	q admSum_"^"_transInSum_"^"_dischSum_"^"_transOutSum_"^"_deathSum_"^"_operSum_"^"_birthSum_"^"_critiSum_"^"_severitySum_"^"_totalNum
	q ""
}

ClassMethod GetAdmTrans(EpisodeID, admDate, wardId, sTime, eTime) As %String
{
	//w ##class(web.DHCNurShiftExchage).GetAdmTrans(3928967,63197,57,0,86300)
	//w ##class(web.DHCNurShiftExchage).GetAdmTrans(4050117,63197,57,0,86300)
	s transIndex=0,PreWard=""
	s transin=0,transout=0
    k temp
    s stdatetime=admDate*86400+sTime //pan 20111102
    s edatetime=admDate*86400+eTime
    s Childsub="" f  s Childsub=$o(^PAADM(EpisodeID,"TRANS",Childsub)) q:(Childsub="")  d
    .s ward=$P(^PAADM(EpisodeID,"TRANS",Childsub),"^",9)
  	.q:ward=""
	.s transStDate=$P($G(^PAADM(EpisodeID,"TRANS",Childsub)),"^",1)
  	.s transStTime=$P($G(^PAADM(EpisodeID,"TRANS",Childsub)),"^",2)
  	.s transEndDate=$P($G(^PAADM(EpisodeID,"TRANS",Childsub)),"^",3)
    .s transEndTime=$P($G(^PAADM(EpisodeID,"TRANS",Childsub)),"^",4)
    .i (ward'=PreWard)&&(PreWard'="") d
    ..//科室不同
    ..s transDateTime=(transStDate*86400)+transStTime
    ..i (transDateTime>=stdatetime)&&(transDateTime<edatetime) d
     ...i ward=wardId d 
     ....//后一个科室是当前科室
     ....s transin=1
     ...e  i PreWard=wardId d 
     ....//前一个科室是当前科室
     ....s transout=1
    .s PreWard=ward
    q transin_"^"_transout
}

/// 取病区转入转出人数
ClassMethod GetWardTransNum(admDate, wardId, userId = "", sTime = "", eTime = "", TMPPat) As %String
{
	//w ##class(web.DHCNurShiftExchage).GetWardTransNum(63197,34,3880,0,86300,.tmp)
	q:(admDate="")!(wardId="") "^"
	i admDate["-" s admDate=$ZDH(admDate,3)
	i admDate["/" s admDate=$ZDH(admDate,4)
	s wordType="夜班"
	i (sTime>=$p(^DHCNurWardShiftTime,"^",1))&&(sTime<$p(^DHCNurWardShiftTime,"^",2)) s wordType="白班"
	s transInSum=0,transOutSum=0
    s EpisodeID=""
    f  s EpisodeID=$O(^PAADMi("TransEndDate",admDate,EpisodeID)) q:EpisodeID=""  d
	   .s tranInfo=..GetAdmTrans(EpisodeID,admDate,wardId,sTime, eTime)
	   .s tranIn=$p(tranInfo,"^",1)
	   .s tranOut=$p(tranInfo,"^",2)
	   .i tranIn=1 d 
	   ..s HasSaveFlag=..GetHasDeleteFlag(userId,admDate,"转入",EpisodeID,workType)
       ..q:(HasSaveFlag=1)
	   ..s transInSum=transInSum+1
	   ..s patInfo=..PatInfo1(EpisodeID)
	   ..s $p(patInfo,"^",7)=..GetWardLastBed(EpisodeID,wardId)
	   ..s rawAge=$p(patInfo,"^",8)
   	   ..s formatAge=rawAge
       ..s noteStr=""
       ..i (sTime>=$p(^DHCNurWardShiftTime,"^",1))&&(sTime<$p(^DHCNurWardShiftTime,"^",2)) s noteStr=$p(patInfo,"^",4)_"，"_formatAge
       ..e  s noteStr="^"_$p(patInfo,"^",4)_";"_formatAge
	   ..;s TMPPat(userId,EpisodeID)=""
	    ..;i (sTime>=$p(^DHCNurWardShiftTime,"^",1))&&(sTime<$p(^DHCNurWardShiftTime,"^",2)) d
	    ..;.s ^DHCNurExchageType(userId,admDate,EpisodeID,"转入","白班")=$p(patInfo,"^",7)_"^"_$p(patInfo,"^",5)_"^"_$p(patInfo,"^",14)_"^"_EpisodeID_"^"_noteStr
	   ..s ^DHCNurExchageType(userId,admDate,EpisodeID,"转入",wordType)=$p(patInfo,"^",7)_"^"_$p(patInfo,"^",5)_"^"_$p(patInfo,"^",14)_"^"_EpisodeID_"^"_noteStr
	   ..s ^DHCNurExchage(userId,$ZD(admDate,3),"转入",transInSum)=$p(patInfo,"^",7)_"^"_$p(patInfo,"^",5)_"^"_$p(patInfo,"^",14)_"^"_EpisodeID_"^"_noteStr
	   .i tranOut=1 d 
	   ..s HasSaveFlag=..GetHasDeleteFlag(userId,admDate,"转出",EpisodeID,workType)
	   ..b
       ..q:(HasSaveFlag=1)
	   ..s transOutSum=transOutSum+1
	   ..s patInfo=..PatInfo1(EpisodeID)
	   ..s $p(patInfo,"^",7)=..GetWardLastBed(EpisodeID,wardId)
	   ..s TMPPat(userId,EpisodeID)=""
	   ..;i (sTime>=$p(^DHCNurWardShiftTime,"^",1))&&(sTime<$p(^DHCNurWardShiftTime,"^",2)) d
	    
	    ..;.s ^DHCNurExchageType(userId,admDate,EpisodeID,"转出","白班")=$p(patInfo,"^",7)_"^"_$p(patInfo,"^",5)_"^"_$p(patInfo,"^",14)_"^"_EpisodeID
	   ..;e  s ^DHCNurExchageType(userId,admDate,EpisodeID,"转出","夜班")=$p(patInfo,"^",7)_"^"_$p(patInfo,"^",5)_"^"_$p(patInfo,"^",14)_"^"_EpisodeID
	   ..s ^DHCNurExchageType(userId,admDate,EpisodeID,"转出",wordType)=$p(patInfo,"^",7)_"^"_$p(patInfo,"^",5)_"^"_$p(patInfo,"^",14)_"^"_EpisodeID
	   ..s ^DHCNurExchage(userId,$ZD(admDate,3),"转出",transOutSum)=$p(patInfo,"^",7)_"^"_$p(patInfo,"^",5)_"^"_$p(patInfo,"^",14)_"^"_EpisodeID
	q transInSum_"^"_transOutSum
}

}
