Import BS

Class web.VitalSignWarn Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query FindBusiICUEvent(icuaId, startDate, startTime, endDate, endTime, Disposal = "") As %Query(ROWSPEC = "ConICUECode:%String,ConfigEvent:%String,ConfigEventCat:%String,ConICUECatId:%String,BusiEvent:%String,DisposalCode:%String,userId:%String,userName:%String,DisposalDateTime:%String,ICUECreateDateTime:%String,EventId:%String,BusICUENote:%String") [ SqlProc ]
{
}

/// d ##class(%ResultSet).RunQuery("web.VitalSignWarn","FindBusiICUEvent",121,"2018/8/1","18:00")
ClassMethod FindBusiICUEventExecute(ByRef qHandle As %Binary, icuaId, startDate = "", startTime = "", Disposal = "O", endDate, endTime) As %Status
{
    s repid=$i(^CacheTemp)
    i $g(ind)="" s ind=1
    i startDate'="" s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
    i startTime'="" s startTime=##class(web.DHCClinicCom).ConvertToTimeH(startTime)
    s BusiICUEventId="",userName="",disposal=""
    f  s disposal=$O(^BS.ICU.DocEventI("ArrDisp",icuaId,disposal)) q:disposal=""  d
    .q:(Disposal'="")&&(disposal'=Disposal)
    .f  s BusiICUEventId=$O(^BS.ICU.DocEventI("ArrDisp",icuaId,disposal,BusiICUEventId)) q:BusiICUEventId=""  d
    ..s ConICUECode="",ConfigEvent="",ConfigEventCat="",ConICUECatId="",BusiEvent="",DisposalCode="",userId="",userName="",DisposalDateTime="",ICUECreateDateTime=""
    ..s ConICUEId="",EventId=""
    ..s ConICUECode=$lg(^BS.ICU.DocEventD(BusiICUEventId),2)
    ..i ConICUECode'="" s ConICUEId=$O(^CF.ICU.DocEventI("Code",ConICUECode,""))
    ..i ConICUEId'=""  d
    ...s ConfigEvent=$lg(^CF.ICU.DocEventD(ConICUEId),2)
    ...s ConICUECatId=$lg(^CF.ICU.DocEventD(ConICUEId),3)
    ...i ConICUECatId'=""  s ConfigEventCat=$lg(^Config.ICUEventCatD(ConICUECatId),2)
    ..s IIDr=$lg(^CF.ICU.DocEventD(ConICUEId),4)
    ..q:IIDr=""
    ..s BusiEvent=$lg(^DHCICUCInquiry($p(IIDr,"||",1),"I",$p(IIDr,"||",2)),2) ;$lg(^Config.ICUEventD(ConICUEId),1)
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
    ..q:(startDate'="")&&(startDate'=$lg(^BS.ICU.DocEventD(BusiICUEventId),3))
    ..;b ;"456"
    ..;q:(startTime'="")&&((startTime<DisposalTime)||(startTime-21600>DisposalTime))
    ..i DisposalDate'=""  s DisposalDate=##class(web.DHCClinicCom).ConvertToDate(DisposalDate)
    ..i DisposalTime'=""  s DisposalTime=##class(web.DHCClinicCom).ConvertToTime(DisposalTime)
    ..s DisposalDateTime=FromDate_"   "_FromTime_"    "_ToTime
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

/// w ##class(web.VitalSignWarn).GetIfWarn()
ClassMethod GetIfWarnOld(icuaId As %String) As %String
{
	s ^tempwhl("GetIfWarn",icuaId)=$h
	q:icuaId=""
	s BusiICUEventId="",retstr="N"
    f  s BusiICUEventId=$O(^BS.ICU.DocEventI("ArrDisp",icuaId,"O",BusiICUEventId)) q:BusiICUEventId=""  d
       .i BusiICUEventId'="" s retstr="Y"
    q retstr
}

/// w ##class(web.VitalSignWarn).GetIfWarn(IcuaId)
ClassMethod GetIfWarn(icuaId As %String) As %String
{
	k ^tempwhl("GetIfWarn",icuaId)
	s ^tempwhl("GetIfWarn",icuaId)=$h
	q:icuaId=""
	s PatDeptId=$p($g(^DHCICUArrange(+icuaId)),"^",2)
	s startDate=$p($g(^DHCICUArrange(+icuaId)),"^",6)
	s startTime=$p($g(^DHCICUArrange(+icuaId)),"^",8)
	s currDT=##class(web.DHCClinicCom).DateTimeAdd(startDate,startTime,21600) //只获取六小时以内数据
	s currDate=$p(currDT,"^",1)
	s currTime=$p(currDT,"^",2)
	s duraHour=##class(web.DHCClinicCom).CalculateDuration(startDate,startTime,currDate,currTime,"H")
 	s BusiICUEventId="",retstr="N"
    f  s BusiICUEventId=$O(^BS.ICU.DocEventI("ArrDisp",icuaId,"O",BusiICUEventId)) q:BusiICUEventId=""  d
       .i BusiICUEventId'="" s retstr="Y"
    //i (duraHour=6)&&(retstr="N") d ##class(web.DHCICUEvent).InsertIcuEventSixHour(104,currDate,currTime,currDate,currTime)
    ;i (retstr="N") d ##class(web.DHCICUEvent).InsertIcuEventSixHour(104,startDate,startTime,currDate,currTime)
    b ;"12"
    d ##class(web.DHCICUEvent).InsertIcuEventOneHour(PatDeptId,startDate,startTime,currDate,currTime)
    q retstr
}

/// w ##class(web.VitalSignWarn).InsertIcuEvent("21182","2018-08-09","06:00","2018-08-09","06:00")
ClassMethod InsertIcuEvent(icuaId, FromDate, FromTime, ToDate, ToTime) As %String
{
 s FromDate=##class(web.DHCClinicCom).ConvertToDateH(FromDate)
 s FromTime=##class(web.DHCClinicCom).ConvertToTimeH(FromTime)
 s ToDate=##class(web.DHCClinicCom).ConvertToDateH(ToDate)
 s ToTime=##class(web.DHCClinicCom).ConvertToTimeH(ToTime)
 ;b ;"start"
 s ID="",ICUEventID=""
 f  s ID=$o(^Config.ICUEventD(ID)) q:ID=""  d
	.s ConICUECode=$lg(^Config.ICUEventD(ID),1)
	.s ConICUEICUCIIDr=$lg(^Config.ICUEventD(ID),4)
	.s ICUCIIDr=$p(ConICUEICUCIIDr,"||",1)
	.s ICUCIIlocation=$p(ConICUEICUCIIDr,"||",2)
	.i ICUCIIDr'="" s value=$p($g(^DHCICUInquiry(ICUCIIDr,icuaId)),"^",ICUCIIlocation)
	.q:value=""
	.s objDHCICUArrange=##class(User.DHCICUArrange).%OpenId(icuaId)
	.s objICUEvent = ##class(Busi.ICUEvent).%New()
	.s objICUEvent.BusICUEICUADr=objDHCICUArrange
	.s objICUEvent.BusICUEConICUECode=ConICUECode
	.s objICUEvent.BusICUEFromDate=FromDate
	.s objICUEvent.BusICUEFromTime=FromTime
	.s objICUEvent.BusICUEToDate=ToDate
	.s objICUEvent.BusICUEToTime=ToTime
	.s objICUEvent.BusICUECreateDate=$p($h,",",1)
	.s objICUEvent.BusICUECreateTime=$p($h,",",2)
	.s objICUEvent.BusICUEDisposal="O"
	.s objICUEvent.BusICUEDisposalUserDr=""
	.s objICUEvent.BusICUEDisposalDate=""
	.s objICUEvent.BusICUEDisposalTime=""
	.s objICUEvent.BusICUENote=value
	.s saveStatus=objICUEvent.%Save()
	.;b ;"1"
	.s ICUEventID=objICUEvent.%Id()
	.d objICUEvent.%Close()
	q ICUEventID
}

/// w ##class(web.VitalSignWarn).InsertIcuEventAll(39,"2018-08-09","06:00","2018-08-09","06:00")
ClassMethod InsertIcuEventAll(ctlocId, FromDate, FromTime, ToDate, ToTime) As %String
{
  s ^TEMPWHL("InsertIcuEventAll",ctlocId,FromDate,FromTime,ToDate,ToTime)=$h
  s retstr=""
  d ##class(web.DHCICUStat).FindIcuInquiry(ctlocId,73,FromDate,ToDate,"",FromTime,ToTime)
  s icuaId=0
  f  s icuaId=$O(^DHCICUInquiry(73,icuaId)) q:icuaId=""  d 
  .w icuaId,!
  .;b ;"3"
  .q:'$d(^DHCICUArrange(icuaId))
  .q:icuaId<100
  .;w icuaId,!
  .;b ;"1"
  .s retstr= ##class(web.VitalSignWarn).InsertIcuEvent(icuaId,FromDate,FromTime,ToDate,ToTime)
  q retstr
}

}
