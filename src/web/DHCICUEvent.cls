Import BS

Class web.DHCICUEvent Extends %RegisteredObject
{

Query FindBusiICUEvent(icuaId, startDate = "", startTime = "", endDate = "", endTime = "", Disposal = "") As %Query(ROWSPEC = "ConICUECode:%String,ConfigEvent:%String,ConfigEventCat:%String,ConICUECatId:%String,BusiEvent:%String,DisposalCode:%String,userId:%String,userName:%String,DisposalDateTime:%String,ICUECreateDateTime:%String,EventId:%String,BusICUENote:%String") [ SqlProc ]
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCICUEvent","FindBusiICUEvent",121,"2018/8/1","18:00")
ClassMethod FindBusiICUEventExecute(ByRef qHandle As %Binary, icuaId, startDate = "", startTime = "", endDate = "", endTime = "", Disposal = "") As %Status
{
	k ^tmpwhl("FindBusiICUEvent")
	s ^tmpwhl("FindBusiICUEvent",icuaId)=icuaId_"@"_startDate_"@"_startTime_"@"_endDate_"@"_endTime_"@"_Disposal 
    s repid=$i(^CacheTemp)
    i $g(ind)="" s ind=1
    d ##class(web.VitalSignWarn).GetIfWarn(icuaId)
    //前台入参传的太乱  YuanLin 20181213
    s StartSchDate=startDate
    s EndSchDate=startTime
    i StartSchDate'="" s StartSchDate=##class(web.DHCClinicCom).ConvertToDateH(StartSchDate)
    i EndSchDate'="" s EndSchDate=##class(web.DHCClinicCom).ConvertToDateH(EndSchDate)
    //---
    i startDate'="" s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
    i startTime'="" s startTime=##class(web.DHCClinicCom).ConvertToTimeH(startTime)
    s BusiICUEventId="",userName="",disposal=""
    i endDate="" s endDate="A"
    f  s disposal=$O(^BS.ICU.DocEventI("ArrDisp",icuaId,disposal)) q:disposal=""  d
    .q:(disposal'=endDate)&&(endDate'="A")
    .f  s BusiICUEventId=$O(^BS.ICU.DocEventI("ArrDisp",icuaId,disposal,BusiICUEventId)) q:BusiICUEventId=""  d
    ..s ConICUECode="",ConfigEvent="",ConfigEventCat="",ConICUECatId="",BusiEvent="",DisposalCode="",userId="",userName="",DisposalDateTime="",ICUECreateDateTime=""
    ..s ConICUEId="",EventId=""
    ..s ConICUECode=$lg(^BS.ICU.DocEventD(BusiICUEventId),2)
    ..i ConICUECode'="" s ConICUEId=$O(^CF.ICU.DocEventI("Code",ConICUECode,""))
    ..i ConICUEId'=""  d
    ...s ConfigEvent=$lg(^CF.ICU.DocEventD(ConICUEId),2)
    ...s ConICUECatId=$lg(^CF.ICU.DocEventD(ConICUEId),3)
    ...i ConICUECatId'=""  s ConfigEventCat=$lg(^CF.ICU.DocEventCatD(ConICUECatId),2)
    ..s IIDr=$lg($g(^CF.ICU.DocEventD(ConICUEId)),4)
    ..q:IIDr=""
    ..s BusiEvent=$lg(^DHCICUCInquiry($p(IIDr,"||",1),"I",$p(IIDr,"||",2)),2) ;$lg(^CF.ICU.DocEventD(ConICUEId),1)
    ..s Disposal=$lg(^BS.ICU.DocEventD(BusiICUEventId),9)
    ..s DisposalCode=disposal
    ..s userId=$lg(^BS.ICU.DocEventD(BusiICUEventId),10)
    ..i userId'="" s userName=$p($g(^SSU("SSUSR",userId)),"^",2)
    ..s FromDate=$zd($lg(^BS.ICU.DocEventD(BusiICUEventId),3),3)
    ..;b ;"123"
    ..s FromTime=##class(web.DHCClinicCom).ConvertToTime($lg(^BS.ICU.DocEventD(BusiICUEventId),4))
    ..s ToTime=##class(web.DHCClinicCom).ConvertToTime($lg(^BS.ICU.DocEventD(BusiICUEventId),6))
    ..s DisposalDate=$lg(^BS.ICU.DocEventD(BusiICUEventId),11)
    ..s DisposalTime=$lg(^BS.ICU.DocEventD(BusiICUEventId),12)
    ..s BusICUENote=$lg(^BS.ICU.DocEventD(BusiICUEventId),13)
    ..;b ;"666"
    ..;q:(startDate'="")&&(startDate'=$lg(^BS.ICU.DocEventD(BusiICUEventId),3))
    ..;b ;"456"
    ..;q:(startTime'="")&&((startTime<DisposalTime)||(startTime-21600>DisposalTime))
    ..i DisposalDate'=""  s DisposalDate=##class(web.DHCClinicCom).ConvertToDate(DisposalDate)
    ..i DisposalTime'=""  s DisposalTime=##class(web.DHCClinicCom).ConvertToTime(DisposalTime)
    ..s DisposalDateTime=FromDate_"   "_FromTime_"    "_ToTime
    ..; 控制查询条件 YuanLin 20181213
    ..i FromDate'="" s FromSchDate=##class(web.DHCClinicCom).ConvertToDateH(FromDate)
    ..q:((FromSchDate'="")&(StartSchDate'="")&(FromSchDate<StartSchDate))
    ..q:((FromSchDate'="")&(EndSchDate'="")&(FromSchDate>EndSchDate))
    ..; 控制查询条件
    ..s ICUECreateDate=$lg(^BS.ICU.DocEventD(BusiICUEventId),7)
    ..s ICUECreateTime=$lg(^BS.ICU.DocEventD(BusiICUEventId),8)
    ..i ICUECreateDate'=""  s ICUECreateDate=##class(web.DHCClinicCom).ConvertToDate(ICUECreateDate)
    ..i ICUECreateTime'=""  s ICUECreateTime=##class(web.DHCClinicCom).ConvertToTime(ICUECreateTime)
    ..s ICUECreateDateTime=ICUECreateDate_" "_ICUECreateTime
    ..s EventId=BusiICUEventId
    ..d OutputBusiICUEvent
    s qHandle=$lb(0,repid,0)
    q $$$OK
OutputBusiICUEvent
    s Data=$lb(ConICUECode,ConfigEvent,ConfigEventCat,ConICUECatId,BusiEvent,DisposalCode,userId,userName,DisposalDateTime,ICUECreateDateTime,EventId,BusICUENote)
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
    q
}

ClassMethod FindBusiICUEventFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBusiICUEventExecute ]
{
    s AtEnd=$li(qHandle,1)
    s repid=$li(qHandle,2)
    s ind=$li(qHandle,3)
    //
    s ind=$o(^CacheTemp(repid,ind))
    i ind="" {              // if there are no more rows, finish fetching
        s AtEnd=1
        s Row=""
    }
    else      {             // fetch row
        s Row=^CacheTemp(repid,ind)
    }
    // Save QHandle
    s qHandle=$lb(AtEnd,repid,ind)
    q $$$OK
}

ClassMethod FindBusiICUEventClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBusiICUEventExecute ]
{
    s repid=$li(qHandle,2)
    k ^CacheTemp(repid)
    q $$$OK
}

ClassMethod SaveEventInfo(Id, Disposal, userId, CreatData, CreatTime) As %String
{
    s CreatData=+$h
    s CreatTime=$P($h,",",2)
    &SQL(update BS_ICU.DocEvent set BSICUDE_Disposal=:Disposal,
    BSICUDE_DisposalUser_Dr=:userId,
    BSICUDE_CreateDate=:CreatData,
    BSICUDE_CreateTime=:CreatTime
    where ID=:Id)
    q 0
}

/// w ##class(web.DHCICUEvent).GetIfWarn()
ClassMethod GetIfWarn(icuaId As %String) As %String
{
	s ^tempwhl("GetIfWarn",icuaId)=$h
	q:icuaId=""
	s BusiICUEventId="",retstr="N"
    f  s BusiICUEventId=$O(^BS.ICU.DocEventI("ArrDisp",icuaId,"O",BusiICUEventId)) q:BusiICUEventId=""  d
       .i BusiICUEventId'="" s retstr="Y"
    q retstr
}

/// w ##class(web.DHCICUEvent).InsertIcuEventAll("21182","2018-08-09","06:00","2018-08-09","06:00")
ClassMethod InsertIcuEventAll(icuaId, FromDate, FromTime, ToDate, ToTime) As %String
{
 s FromDate=##class(web.DHCClinicCom).ConvertToDateH(FromDate)
 s FromTime=##class(web.DHCClinicCom).ConvertToTimeH(FromTime)
 s ToDate=##class(web.DHCClinicCom).ConvertToDateH(ToDate)
 s ToTime=##class(web.DHCClinicCom).ConvertToTimeH(ToTime)
  s ID="",ICUEventID=""
  f  s ID=$o(^CF.ICU.DocEventD(ID)) q:ID=""  d
	.s ConICUECode=$lg(^CF.ICU.DocEventD(ID),1)
 	.s CFICUDEExcludeCode=$lg(^CF.ICU.DocEventD(ID),4)
	.s value=""
	.s ICUCIIDr=$p(CFICUDEExcludeCode,"||",1)
	.s ICUCIIlocation=$p(CFICUDEExcludeCode,"||",2)
	.s one=..FindIcuEventValueByIucaIdandcode(icuaId,CFICUDEExcludeCode,FromDate,FromTime)
	.i ICUCIIDr'="" s value=$p($g(^DHCICUInquiry($j,40,icuaId)),"^",ICUCIIlocation)
	.i (CFICUDEExcludeCode'="")&(one'="") s value=one
	.q:value="" 
	.s objDHCICUArrange=##class(User.DHCICUArrange).%OpenId(icuaId)
	.s objICUEvent = ##class(BS.ICU.DocEvent).%New()
	.s objICUEvent.BSICUDEICUADr=objDHCICUArrange
	.s objICUEvent.BSICUDECFICUDECode=ConICUECode
	.s objICUEvent.BSICUDEFromDate=FromDate
	.s objICUEvent.BSICUDEFromTime=FromTime
	.s objICUEvent.BSICUDEToDate=ToDate
	.s objICUEvent.BSICUDEToTime=ToTime
	.s objICUEvent.BSICUDECreateDate=$p($h,",",1)
	.s objICUEvent.BSICUDECreateTime=$p($h,",",2)
	.s objICUEvent.BSICUDEDisposal="O"
	.s objICUEvent.BSICUDEDisposalUserDr=""
	.s objICUEvent.BSICUDEDisposalDate=""
	.s objICUEvent.BSICUDEDisposalTime=""
	.s objICUEvent.BSICUDENote=value
	.s saveStatus=objICUEvent.%Save()
 	.s ICUEventID=objICUEvent.%Id()
	.d objICUEvent.%Close()
	q ICUEventID
}

/// w ##class(web.DHCICUEvent).InsertIcuEventAll"21182","2018-08-09","06:00","2018-08-09","06:00")
ClassMethod InsertIcuEventOnce(icuaId, FromDate, FromTime, ToDate, ToTime) As %String
{
 s FromDate=##class(web.DHCClinicCom).ConvertToDateH(FromDate)
 s FromTime=##class(web.DHCClinicCom).ConvertToTimeH(FromTime)
 s ToDate=##class(web.DHCClinicCom).ConvertToDateH(ToDate)
 s ToTime=##class(web.DHCClinicCom).ConvertToTimeH(ToTime)
  s ID="",ICUEventID="",ifExist="N"
 f  s ID=$o(^CF.ICU.DocEventD(ID)) q:ID=""  d
	.s ConICUECode=$lg(^CF.ICU.DocEventD(ID),1)
 	.s CFICUDEExcludeCode=$lg(^CF.ICU.DocEventD(ID),4)
	.s value=""
	.s ICUCIIDr=$p(CFICUDEExcludeCode,"||",1)
	.s ICUCIIlocation=$p(CFICUDEExcludeCode,"||",2)
	.i ICUCIIDr'="" s value=$p($g(^DHCICUInquiry($j,40,icuaId)),"^",ICUCIIlocation)
	.s ifExist=..GetIfExistWarnByCode(icuaId,ConICUECode)
	.b ;"1"
	.q:value="" 
	.q:ifExist="Y"
	.s objDHCICUArrange=##class(User.DHCICUArrange).%OpenId(icuaId)
	.s objICUEvent = ##class(BS.ICU.DocEvent).%New()
	.s objICUEvent.BSICUDEICUADr=objDHCICUArrange
	.s objICUEvent.BSICUDECFICUDECode=ConICUECode
	.s objICUEvent.BSICUDEFromDate=FromDate
	.s objICUEvent.BSICUDEFromTime=FromTime
	.s objICUEvent.BSICUDEToDate=ToDate
	.s objICUEvent.BSICUDEToTime=ToTime
	.s objICUEvent.BSICUDECreateDate=$p($h,",",1)
	.s objICUEvent.BSICUDECreateTime=$p($h,",",2)
	.s objICUEvent.BSICUDEDisposal="O"
	.s objICUEvent.BSICUDEDisposalUserDr=""
	.s objICUEvent.BSICUDEDisposalDate=""
	.s objICUEvent.BSICUDEDisposalTime=""
	.s objICUEvent.BSICUDENote=value
	.s saveStatus=objICUEvent.%Save()
 	.s ICUEventID=objICUEvent.%Id()
	.d objICUEvent.%Close()
	q ICUEventID
}

/// w ##class(web.DHCICUEvent).InsertIcuEventSixHour(221,"2020-10-14","00:00","2020-10-16","05:59")
ClassMethod InsertIcuEventSixHour(ctlocId, FromDate, FromTime, ToDate, ToTime) As %String
{
  s ^TEMPWHL("InsertIcuEventSixHour",ctlocId,FromDate,FromTime,ToDate,ToTime)=$h
  s retstr=""
  s icuaId=0 
  b ;"insert"
  d ##class(web.DHCICUStat).FindIcuInquiry(ctlocId,40,FromDate,ToDate,"",FromTime,ToTime)
  b ;"d"
  f  s icuaId=$O(^DHCICUInquiry($j,40,icuaId)) q:icuaId=""  d 
  .q:'$d(^DHCICUArrange(icuaId))
  .b ;"2"
  .w icuaId,!
  .;q:icuaId<100
  .s retstr= ##class(web.DHCICUEvent).InsertIcuEventAll(icuaId,FromDate,FromTime,ToDate,ToTime)
  q retstr
}

/// w ##class(web.DHCICUEvent).InsertIcuEventOneHour(39,"2018-08-09","06:00","2018-08-09","06:00")
ClassMethod InsertIcuEventOneHour(ctlocId, FromDate, FromTime, ToDate, ToTime) As %String
{
  s ^TEMPWHL("InsertIcuEventOneHour",ctlocId,FromDate,FromTime,ToDate,ToTime)=$h
  s retstr=""
  b ;"FindIcuInquiry"
  d ##class(web.DHCICUStat).FindIcuInquiry(ctlocId,37,FromDate,ToDate,"I",FromTime,ToTime)
  s icuaId=0
  f  s icuaId=$O(^DHCICUInquiry($j,40,icuaId)) q:icuaId=""  d 
  .s startDate=+$p($g(^DHCICUArrange(+icuaId)),"^",6)
  .s startTime=+$p($g(^DHCICUArrange(+icuaId)),"^",8)
  .i icuaId=24 b ;"24"
  .s duraHour=##class(web.DHCClinicCom).CalculateDuration(startDate,startTime,$p($h,",",1),$p($h,",",2),"H")
  .q:'$d(^DHCICUArrange(icuaId))
  .;q:icuaId<100
  .b ;"One"
  .s retstr= ##class(web.DHCICUEvent).InsertIcuEventOnce(icuaId,FromDate,FromTime,ToDate,ToTime)
  q retstr
}

/// w ##class(web.DHCICUEvent).FindIcuEventValueByIucaIdandcode(21303,"InSepsis")
ClassMethod FindIcuEventValueByIucaIdandcode(icuaId, code, FromDate, FromTime) As %String
{
	s retstr="",disposal="",BusiICUEventId=""
    f  s disposal=$O(^BS.ICU.DocEventI("ArrDisp",icuaId,disposal)) q:disposal=""  d
    .f  s BusiICUEventId=$O(^BS.ICU.DocEventI("ArrDisp",icuaId,disposal,BusiICUEventId)) q:BusiICUEventId=""  d
    ..s ConICUECode="",ConfigEvent="",ConfigEventCat="",ConICUECatId="",BusiEvent="",DisposalCode="",userId="",userName="",DisposalDateTime="",ICUECreateDateTime=""
    ..s ConICUEId="",EventId=""
    ..s ConICUECode=$lg(^BS.ICU.DocEventD(BusiICUEventId),2)
    ..s datestartDate=$lg(^BS.ICU.DocEventD(BusiICUEventId),3)
    ..s datestartTime=$lg(^BS.ICU.DocEventD(BusiICUEventId),4)
    ..;s duraHour=##class(web.DHCClinicCom).CalculateDuration(FromDate,FromTime,datestartDate,datestartTime)
    ..q:ConICUECode'=code
    ..s ConICUEValue=$lg(^BS.ICU.DocEventD(BusiICUEventId),13)
    ..s retstr=ConICUEValue
    q retstr
}

/// w ##class(web.DHCICUStatDebug).GetIfExistWarnByCode(21303,"InSepsis")
ClassMethod GetIfExistWarnByCode(icuaId As %String, code As %String) As %String
{
	s ^tempwhl("GetIfWarn",icuaId)=$h
	q:icuaId=""
	s disposal="",retstr="N"
 	f  s disposal=$O(^BS.ICU.DocEventI("ArrDisp",icuaId,disposal)) q:disposal=""  d  
 	.s BusiICUEventId=""
     .f  s BusiICUEventId=$O(^BS.ICU.DocEventI("ArrDisp",icuaId,disposal,BusiICUEventId)) q:BusiICUEventId=""  d
     ..s ConICUECode=$lg(^BS.ICU.DocEventD(BusiICUEventId),2)
     ..q:ConICUECode'=code
    ..s retstr="Y"
     q retstr
}

ClassMethod GenData(locId, date, hour, curTime)
{
	if ('$IsValidNum(date)) set date=##class(web.DHCClinicCom).ConvertToDateH(date)
	// do ##class(web.DHCICUStat).FindIcuInquiry(locId,37,date-1,date,"","07:00","07:00")
	s ^tempwhl("VitalSignWarn",hour)=hour	 
	s retstr2=##class(web.DHCICUEvent).InsertIcuEventOneHour(locId,+date-1,"07:00",+$h,"07:00")
	s ^tempwhl("web.DHCICUEvent",hour)=hour
	i (hour=5) d 
       .s retstr1=##class(web.DHCICUEvent).InsertIcuEventSixHour(locId,+date-1,"0:00",+date,"5:59")
       .s ^tempwhl("VitalSignWarn","retstr1",hour)=retstr1
	i (hour=11) d 
       .s retstr1=##class(web.DHCICUEvent).InsertIcuEventSixHour(locId,+date-1,"6:00",+date,"11:59")
       .s ^tempwhl("VitalSignWarn","retstr1",hour)=retstr1
	i (hour=17) d 
       .s retstr1=##class(web.DHCICUEvent).InsertIcuEventSixHour(locId,+date-1,"12:00",+date,"17:59")
       .s ^tempwhl("VitalSignWarn","retstr1",hour)=retstr1
	i (hour=23) d 
       .s retstr1=##class(web.DHCICUEvent).InsertIcuEventSixHour(locId,+date-1,"18:00",+date,"23:59")
       .s ^tempwhl("VitalSignWarn","retstr1",hour)=retstr1
    quit 0
}

Storage Default
{
<Data name="VitalSignWarnDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCICUEventD</DataLocation>
<DefaultData>VitalSignWarnDefaultData</DefaultData>
<IdLocation>^web.DHCICUEventD</IdLocation>
<IndexLocation>^web.DHCICUEventI</IndexLocation>
<StreamLocation>^web.DHCICUEventS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
