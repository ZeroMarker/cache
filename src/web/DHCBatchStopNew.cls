Class web.DHCBatchStopNew Extends DHCDoc.Util.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod GetCurrDate() As %String
{
	q +$h_"^"_$zd(+$h,3)_"^"_$zd(+$h,4)
}

ClassMethod FormatDateToString(Date, flag) As %String
{
	q:Date="" ""
	if (flag'="") {
		s Date=$zdh(Date,flag)
	}else{
		s:Date["-" Date=$zdh(Date,3)
		s:Date["/" Date=$zdh(Date,4)
	}
	q Date
}

ClassMethod FormatStringToDate(Date, flag As %String = "") As %String
{
	q:Date="" ""
	if flag="" s flag=3
	s Date=$zd(Date,flag)
	q Date
}

ClassMethod FormatStringToTime(Time, flag As %String = "") As %String
{
	q:Time="" ""
	if flag="" s flag=1
	s Time=..%ZT(Time,flag)
	q Time
}

/// d ##class(web.DHCBatchStopNew).GetLocData("","1","1","",9)
ClassMethod GetLocData(desc, userid As %String = "", groupid As %String = "", doctor As %String = "", HospId As %String = "")
{
	s ^Temp("GetLocData1")=userid_","_groupid_","_HospId
	s HospId=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	/*s flag=0
	if groupid'="" {
		s groupdesc=$p($g(^SSU("SSGRP",groupid)),"^",1)
		if groupdesc["门办" s flag=1
	}
	if (userid="")&&(flag=0) {
		w "[]" 
		quit
	}*/
	s desc=$ZCVT(desc,"U")
	w "["
		s num=0
		/*if (flag=1){
			s ExaBorough="" f  s ExaBorough=$o(^User.DHCExaBorDepI("BordBorDrIndex",ExaBorough)) q:ExaBorough=""  do
			.Quit:("^11^14^16^17^24^25^")[("^"_ExaBorough_"^")
			.d OutExaBorDepJson
		}else{
		 	s BoruID="" f  s BoruID=$o(^User.DHCBorUserI("BoruUseDrIndex"," "_userid,BoruID)) q:BoruID=""  do
			.s ExaBorough=$list(^User.DHCBorUserD(BoruID),2)
			.q:ExaBorough=""
			.d OutExaBorDepJson
		}*/
	s IsHideExaBor=+##class(web.DHCOPRegConfig).GetSpecConfigNode("IsHideExaBor",HospId)
	if (IsHideExaBor=0){
		s ExaBorough=0
		f  s ExaBorough=$o(^User.DHCExaBoroughD(ExaBorough)) q:ExaBorough=""  d
		.s HospitalDr=$lg(^User.DHCExaBoroughD(ExaBorough),13)
		.q:HospId'=HospitalDr
		.d OutExaBorDepJson
	}
	k CTLocArr
	s otherCount=0
	s AdmTypeStr="O^E"
	for i=1:1:$l(AdmTypeStr,"^"){
		s AdmType=$p(AdmTypeStr,"^",i)
		s myrowid=0
		for  {
			s myrowid=$o(^PAC("ADMLOC",0,"AdmType",AdmType,myrowid)) 
			q:myrowid="" 
			continue:'$d(^CTLOC(myrowid))
			continue:$d(CTLocArr(myrowid))
			continue:($d(^User.DHCExaBorDepI("BordDepDrIndex"," "_myrowid))||$d(^User.DHCExaBorDepI("BordDepDrIndex",myrowid)))&&(IsHideExaBor=0)
			;科室排班权限判断
			continue:(userid'="")&&('##class(web.DHCUserGroup).UserCanDo(userid,myrowid))
			s CTLOCActiveFlag=$p($g(^CTLOC(myrowid)),"^",14)
			continue:CTLOCActiveFlag="N"
			s CTLOCDateActiveFrom=$p($g(^CTLOC(myrowid)),"^",24)
			continue:(CTLOCDateActiveFrom'="")&&(CTLOCDateActiveFrom>+$h)
			s CTLOCDateActiveTo=$p($g(^CTLOC(myrowid)),"^",25)
			continue:(CTLOCDateActiveTo'="")&&(CTLOCDateActiveTo<+$h)
			s CTDesc=$p($g(^CTLOC(myrowid)),"^",2)
			s CTAliasTem=""
			i $l(CTDesc,"-")>1 s CTAliasTem=$P(CTDesc,"-",1)
			s CTAlias=$P(^CTLOC(myrowid),"^",43)
			//continue:(desc'="")&&(CTDesc'[desc)&&(CTAlias'[desc)
			continue:(desc'="")&&('##class(web.DHCOPAdmReg).CheckLocDesc(myrowid,desc))
			i CTAlias="" s CTAlias=CTAliasTem
			s doctorstr=##class(web.DHCBatchStopNew).GetDocDataStr(myrowid,userid)
			continue:((doctor'="")&&(doctorstr'[doctor))
			continue:($P(^CTLOC(myrowid),"^",14)'="Y")
			s HospitalDr=$p($g(^CTLOC(myrowid)),"^",22)
			;continue:HospId'=HospitalDr
			continue:"N"=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("CT_Loc",myrowid,HospId)
			s otherCount=otherCount+1
			s CTLocArr(myrowid)=1
			if (IsHideExaBor=0){
				i otherCount=1 {
					s ExaBorough="Other"
					s ExaBoroughDesc="未对照诊区科室列表"
					if (num=0) {
						w "{""id"":"""_"Exa^"_ExaBorough_""",""text"":"""_ExaBoroughDesc_""",""children"":["
					}else{
						w ",{""id"":"""_"Exa^"_ExaBorough_""",""text"":"""_ExaBoroughDesc_""",""children"":["
					}
					w ..getJsonTreeStartSign("Loc^"_myrowid,CTDesc)
				}else {
					if (num=0) {
						w ..getJsonTreeStartSign("Loc^"_myrowid,CTDesc)
					}else{
						w ","_..getJsonTreeStartSign("Loc^"_myrowid,CTDesc)
					}
				}
			}else{
				s ExaBorough=$o(^User.DHCExaBorDepI("BordDepDrIndex"," "_myrowid,""))
				s ExaBoroughdr=""
				if (ExaBorough'=""){
					s ExaBoroughdr=$lg(^User.DHCExaBorDepD(ExaBorough),6)
				}
				i otherCount=1 {
					w ..getJsonTreeStartSign("Loc^"_myrowid_"^"_ExaBoroughdr,CTDesc)
				}else{
					w ","_..getJsonTreeStartSign("Loc^"_myrowid_"^"_ExaBoroughdr,CTDesc)
				}
			}
			s num=num+1
		}
	}
	if (IsHideExaBor=0){
		if (otherCount>0) w "]}"
	}
	w "]"
	k CTLocArr
	q 1
	
OutExaBorDepJson
	s num=num+1
	if (num'=1) w ","
	
	s ExaBoroughDesc=$list(^User.DHCExaBoroughD(ExaBorough),5)
	w "{""id"":"""_"Exa^"_ExaBorough_""",""text"":"""_ExaBoroughDesc_""",""children"":["
	
	s count=0
	k CTMJCTLOC
	s ID="" f  s ID=$o(^User.DHCExaBorDepI("BordBorDrIndex",ExaBorough,ID)) q:ID=""  do
	.s RowId=$list(^User.DHCExaBorDepD(ID),7)
	.q:RowId="" 
	.q:'$d(^CTLOC(RowId))
	.;科室排班权限判断
	.q:(userid'="")&&('##class(web.DHCUserGroup).UserCanDo(userid,RowId))
	.s CTLOCActiveFlag=$p($g(^CTLOC(RowId)),"^",14)
	.Q:CTLOCActiveFlag="N"
	.s CTLOCDateActiveFrom=$p($g(^CTLOC(RowId)),"^",24)
	.Q:(CTLOCDateActiveFrom'="")&&(CTLOCDateActiveFrom>+$h)
	.s CTLOCDateActiveTo=$p($g(^CTLOC(RowId)),"^",25)
	.Q:(CTLOCDateActiveTo'="")&&(CTLOCDateActiveTo<+$h)
	.s CTDesc=$p($g(^CTLOC(RowId)),"^",2)
	.s CTAliasTem=""
	.i $l(CTDesc,"-")>1 s CTAliasTem=$P(CTDesc,"-",1)
	.s CTAlias=$P(^CTLOC(RowId),"^",43)
	.//Quit:(desc'="")&&(CTDesc'[desc)&&(CTAlias'[desc)
	.Quit:(desc'="")&&('##class(web.DHCOPAdmReg).CheckLocDesc(RowId,desc))
	.i CTAlias="" s CTAlias=CTAliasTem
	.s doctorstr=##class(web.DHCBatchStopNew).GetDocDataStr(RowId,userid)
	.q:((doctor'="")&&(doctorstr'[doctor))
	.s CTMJRowid = $o(^DHCCTLoc(0,"Minor",RowId,""))   // 获取一级科室进行排序
	.s HospitalDr=$p($g(^CTLOC(RowId)),"^",22)
	.q:HospId'=HospitalDr
	.if CTMJRowid="" s CTMJRowid=99999
	.s CTMJCTLOC(CTMJRowid,RowId)=CTDesc
	
	s CTMJRowid="" f  s CTMJRowid=$o(CTMJCTLOC(CTMJRowid)) q:CTMJRowid=""  do
	.s RowId="" f  s RowId=$o(CTMJCTLOC(CTMJRowid,RowId)) q:RowId=""  do
	..s CTDesc=$g(CTMJCTLOC(CTMJRowid,RowId))
	..s count = count+1
	..i count=1 d
	...w ..getJsonTreeStartSign("Loc^"_RowId,CTDesc)
	..e  d
	...w ","_..getJsonTreeStartSign("Loc^"_RowId,CTDesc)
	w "]}"
	quit
}

/// w ##class(web.DHCBatchStopNew).GetDocDataStr(3)
ClassMethod GetDocDataStr(LocRowid As %String, userid As %String = "")
{
	n (LocRowid,userid)
	s count=0,docstr=""
	s RowId=0 f  S RowId=$o(^RB("RES",0,"CTLOC",LocRowid,RowId)) Q:RowId=""  d
	.Q:'($D(^RB("RES",RowId)))
	.set ScheSt=$p(^RB("RES",RowId),"^",6)
	.Q:(ScheSt'="Y")
	.S DateTo=$p(^RB("RES",RowId),"^",23)
	.q:(DateTo'="")&&((+DateTo)<(+$h))
	.S DocID=$p(^RB("RES",RowId),"^",2)
	.Q:DocID=""
	.Q:('$d(^CTPCP(DocID,1)))
	.;医生排班权限判断
	.q:(userid'="")&&('##class(web.DHCUserGroup).UserCanDo(userid,LocRowid,DocID))
	.s Active=$p(^CTPCP(DocID,1),"^",9)
	.q:Active'="Y"
	.s DocCode=$p(^CTPCP(DocID,1),"^",1)
	.s DocDesc=$p(^CTPCP(DocID,1),"^",2)
	.s DocDesc=##class(web.DHCOPAdmReg).CutLetter(DocDesc)
	.s:docstr'="" docstr=docstr_"^"_DocDesc_"^"_DocCode
	.s:docstr="" docstr=DocDesc_"^"_DocCode
	q docstr
}

/// w ##class(web.DHCBatchStopNew).GetDocData(59,"毛羽")
ClassMethod GetDocData(LocRowid, doctor As %String = "", userid As %String = "", HospID = "")
{
	s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	s ^tempscl("GetDocData")=LocRowid_","_doctor_","_userid
	w "["
	s count=0
	s RowId=0 f  S RowId=$o(^RB("RES",0,"CTLOC",LocRowid,RowId)) Q:RowId=""  d
	.Q:'($D(^RB("RES",RowId)))
	.Q:"N"=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("RB_Resource",RowId,HospID)
	.set ScheSt=$p(^RB("RES",RowId),"^",6)
	.Q:(ScheSt'="Y")
	.S DateTo=$p(^RB("RES",RowId),"^",23)
	.q:(DateTo'="")&&((+DateTo)<(+$h))
	.S DocID=$p(^RB("RES",RowId),"^",2)
	.Q:DocID=""
	.Q:('$d(^CTPCP(DocID,1)))
	.s CTPCPActiveFlag=$p(^CTPCP(DocID,1),"^",9)
	.Q:CTPCPActiveFlag="N"
	.s ActiveFrom=$p(^CTPCP(DocID,2),"^",14)
	.Q:(ActiveFrom'="")&&(ActiveFrom>+$h)
	.s ActiveTo=$p(^CTPCP(DocID,2),"^",15)
	.Q:(ActiveTo'="")&&(ActiveTo<+$h)
	.;医生排班权限判断
	.q:(userid'="")&&('##class(web.DHCUserGroup).UserCanDo(userid,LocRowid,DocID))
	.s DocCode=$p(^CTPCP(DocID,1),"^",1)
	.s DocDesc=$p(^CTPCP(DocID,1),"^",2)
	.//s DocDesc=##class(web.DHCOPAdmReg).CutLetter(DocDesc)
	.s Docstr=DocCode_"^"_DocDesc
	.q:((doctor'="?")&&(Docstr'[doctor))
	.s count = count+1
	.i count=1 d
	..w ..getJsonTreeStartSignChild("Doc^"_DocID,DocDesc)
	.e  d
	..w ","_..getJsonTreeStartSignChild("Doc^"_DocID,DocDesc)
	w "]"
	q 0
}

/// Descript:返回Json串起始符
ClassMethod getJsonTreeStartSign(id, text) As %String
{
	N (id, text)
	S del=""""
	q "{"_del_"id"_del_":"_del_id_del_","_del_"text"_del_":"_del_text_del_","_del_"state"_del_":"_del_"closed"_del_"}" //_","_del_"state"_del_":"_del_"closed"_del
}

/// Descript:返回Json串起始符
ClassMethod getJsonTreeStartSignChild(id, text) As %String
{
	N (id, text)
	S del=""""
	q "{"_del_"id"_del_":"_del_id_del_","_del_"text"_del_":"_del_text_del_"}" //_","_del_"state"_del_":"_del_"closed"_del
}

/// Descript:返回Json串起始符
ClassMethod getJsonTreeRootSign(id, text) As %String
{
	N (id, text)
	S del=""""
	q "{"_del_"id"_del_":"_del_id_del_","_del_"text"_del_":"_del_text_del //_","_del_"state"_del_":"_del_"closed"_del
}

/// d ##class(%ResultSet).RunQuery("web.DHCBatchStopNew","DayWeekFind")
Query DayWeekFind() As %Query(ROWSPEC = "Id:%String,Desc:%String")
{
}

ClassMethod DayWeekFindExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s Id="",Desc="&nbsp;"
	d OutputRow
	Set Id=0
	for  Set Id=$o(^CT("DOW",1,Id)) Quit:Id=""  do
	.Set Desc=$p(^CT("DOW",1,Id),"^",1)
	.Set weekid=$p(^CT("DOW",1,Id),"^",2)
 	.d OutputRow
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(Id,Desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod DayWeekFindFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DayWeekFindExecute ]
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

ClassMethod DayWeekFindClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DayWeekFindExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCBatchStopNew","StopReasonFind")
Query StopReasonFind() As %Query(ROWSPEC = "Id:%String,Desc:%String")
{
}

ClassMethod StopReasonFindExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s Id="",Desc="&nbsp;"
	d OutputRow1
	s Id=0	f  s Id=$O(^RBC("NA",Id)) Q:Id=""  d
	.s Sttime=$P(^RBC("NA",Id),"^",4)
	.s Endtime=$P(^RBC("NA",Id),"^",5)
	.q:Sttime>(+$H)
	.q:(Endtime<(+$H))&&(Endtime'="")
	.s Desc=$P(^RBC("NA",Id),"^",2)
 	.d OutputRow1
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(Id,Desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod StopReasonFindFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = StopReasonFindExecute ]
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

ClassMethod StopReasonFindClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = StopReasonFindExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindStopResultClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindStopResultExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCBatchStopNew","FindStopResult","8/26/2016","8/26/2016")
ClassMethod FindStopResultExecute(ByRef qHandle As %Binary, StartDate As %String = "", EndDate As %String = "") As %Status
{
	s ^tempFindStopResultExecute=StartDate_","_EndDate
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s UserID=1   //%session.Get("LOGON.USERID")
	if $L(StartDate,"/")=3 s StartDate=$zdh(StartDate,4)
	if $L(EndDate,"/")=3 s EndDate=$zdh(EndDate,4)
	s ReasonNotes=""
	s NARowid=""
	f  s NARowid=$O(^RB("NA",NARowid),-1) q:NARowid=""  d
	.s RESDR=$p(^RB("NA",NARowid),"^",1)
	.s DepID=$p($g(^RB("RES",RESDR)),"^",1)
	.S DepDesc=$P($g(^CTLOC(DepID)),"^",2)
	.S DocID=$p(^RB("RES",RESDR),"^",2)
	.q:(UserID'="")&&('##class(web.DHCUserGroup).UserCanDo(UserID,DepID,DocID))
	.S DocDesc=$P(^CTPCP(DocID,1),"^",2)
	.s StDate=$P($P(^RB("NA",NARowid),"^",2),"Z",1)
	.s EDate=$P($P(^RB("NA",NARowid),"^",3),"Z",1)
	.q:(StartDate'="")&&(StDate<StartDate)
	.q:(EndDate'="")&&(EDate>EndDate)
	.s StDate=$zd(StDate,3)
	.s EDate=$zd(EDate,3)
	.s RSVP=$P(^RB("NA",NARowid),"^",6)
	.if RSVP="Y" s RSVP="停诊"
	.e  i RSVP="N" s RSVP="撤销停诊"
	.s UpDate=$P(^RB("NA",NARowid),"^",9)
	.s UpTime=$P(^RB("NA",NARowid),"^",10)
	.s UpDateUser=$P(^RB("NA",NARowid),"^",11)
	.s ReasonDr=$P(^RB("NA",NARowid),"^",4)
	.s ReasonNotes=""
	.if ReasonDr'="" S ReasonNotes=$P($g(^RBC("NA",ReasonDr)),"^",2)
	.s PutDOWId=$P(^RB("NA",NARowid),"^",15)
	.s PutDOW=""
	.if PutDOWId'="" Set PutDOW=$p(^CT("DOW",1,PutDOWId),"^",1)
	.s TimeRange=$P(^RB("NA",NARowid),"^",16)
	.if TimeRange'="" do
	..s TimeRange=$p(^DHCTimeRange(TimeRange),"^",2)
	.do OutputRow2
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow2
	set Data=$lb(DepDesc,DocDesc,ReasonNotes,StDate,EDate,NARowid,RSVP,PutDOW,TimeRange)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	quit
ResetVariables
	///set (repid)=0
	set (DepDesc,DocDesc,ReasonNotes,StDate,EDate,NARowid,RSVP)=""
	quit
}

ClassMethod FindStopResultFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindStopResultExecute ]
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

Query FindStopResult(StartDate As %String = "", EndDate As %String = "") As %Query(ROWSPEC = "TLoc:%String,TDoc:%String,TStopReason:%String,TStartDate:%String,TEndDate:%String,NARowid:%String,RSVP:%String,PutDOW:%String,TimeRange:%String")
{
}

ClassMethod BatchStopAll(StartDate As %String, EndDate As %String, LocDocIdStr As %String, Reason As %String, DayWeek As %String, UserID As %String, Notes As %String, StopMethod As %String, TimeRange As %String)
{
	Set len1=$l(LocDocIdStr,"|")
	k LocArr
	for i=1:1:len1{
		Set LocDocStr=$p(LocDocIdStr,"|",i)
		Set LocId=$p(LocDocStr,"!",1)
		Set DocIdStr=$p(LocDocStr,"!",2)
		Set LocArr(LocId)=DocIdStr
	}
	s LocId=0
	for  s LocId=$o(LocArr(LocId)) Quit:LocId=""  do
	.Set DocIdStr=LocArr(LocId)
	.s RowId=0 
	.f  S RowId=$o(^RB("RES",0,"CTLOC",LocId,RowId)) Q:RowId=""  d
	..Q:'($D(^RB("RES",RowId)))
	..set ScheSt=$p(^RB("RES",RowId),"^",6)
	..Q:(ScheSt'="Y")
	..S DocID=$p(^RB("RES",RowId),"^",2)
	..Q:DocID=""
	..Quit:(DocIdStr'="")&&(("^"_DocIdStr_"^")'[("^"_DocID_"^"))
	..s ret=..BatchStop(StartDate, EndDate, LocId, DocID, Reason, DayWeek,Notes, UserID, StopMethod,TimeRange)
	..if ret=0 do
	...do ..SendDHCMessage(LocId,DocID,UserID,StartDate,EndDate,DayWeek,TimeRange)
	
	Quit 0
}

ClassMethod BatchStop(StartDate, EndDate, DepId, DocId, Reason, DayWeek, Notes, UserID, StopMethod, TimeRange)
{
	
	//w ##class(web.DHCOPRegHolidayAdjust).BatchStop("30/05/2008","31/05/2008",1442,22073,"","",6)
	//查找出所有的已经生成的记录,将它们的状态置成S
	set ResRowId=$Order(^RB("RES",0,"CTPCP",DocId,DepId,0))
	s ^guo("BatchStop")=ResRowId_","_StartDate_","_EndDate_","_DepId_","_DocId_","_Reason_","_Notes_","_UserID_","_StopMethod
	if $L(StartDate,"/")=3 s StartDate=$zdh(StartDate,4)
	if $L(EndDate,"/")=3 s EndDate=$zdh(EndDate,4)
	s Count=0
	f ASDate=StartDate:1:EndDate d
	.Set AdmWeek=$zd(ASDate,10)
	.if AdmWeek=0 Set AdmWeek=7
	.Quit:(AdmWeek'=DayWeek)&&(DayWeek'="")
	.s StartTimeID=""
	.f  s StartTimeID=$O(^RBAS(ResRowId,0,"DateSTime",ASDate,StartTimeID)) q:(StartTimeID="")  d
	..s RBASRowId="",ASStatus=""
	..f  s RBASRowId=$O(^RBAS(ResRowId,0,"DateSTime",ASDate,StartTimeID,RBASRowId)) q:(RBASRowId="")  d
	...s ASStatusid=$P(^RBAS(ResRowId,RBASRowId,"DHC"),"^",10)
	...s TimeRangeId=$P(^RBAS(ResRowId,RBASRowId,"DHC"),"^",17)
	...Quit:(TimeRange'="")&&(TimeRangeId'=TimeRange)
	...if ASStatusid'="" s ASStatus=$p(^DHCRBCASStatus(ASStatusid),"^",1)
	...Q:((ASStatus="S")||(ASStatus="TR")||(ASStatus="PS"))&&(StopMethod="S")
	...Q:((ASStatus="R")||(ASStatus="N"))&&(StopMethod="N")
	...&SQL(Select ASS_Rowid into :ASStatusDR from SQLUser.DHC_RBCASStatus Where ASS_Code=:StopMethod)
	...s $P(^RBAS(ResRowId,RBASRowId,"DHC"),"^",10)=ASStatusDR
	...s $P(^RBAS(ResRowId,RBASRowId,"DHC"),"^",11)=Reason
	...//d ##class(RegInterface.SynVisitSchedule).SynStopVisitSchedule(ResRowId_"||"_RBASRowId)
	...;调用平台组接口
	...s rtn=##class(web.DHCENS.EnsHISService).DHCHisInterface("STOPAPPTSCHEDULEINFO",ResRowId_"||"_RBASRowId)
	...s ret=##class(web.DHCRBApptScheduleUpdateLog).AddRBApptScheduleLog("S",ResRowId_"||"_RBASRowId,"")
	...s Count=Count+1
	//插入到批量停诊表
	set RSVP="N"
	if StopMethod="S" set RSVP="Y"
	s UpdateDate=..%SysDate()
	s UpdateTime=..%SysTime()
	q:Count=0 "Repeat"
	if (Count>0){
		&sql(insert into SQLUser.RB_NotAvail (NA_RES_DR,NA_FrDate,NA_FrTime,NA_ToDate,NA_ToTime,NA_Reason_DR,NA_UpdateDate,NA_UpdateTime,NA_UpdateUser_DR,NA_RSVP,NA_DayOfWeek_DR,NA_TimeRange_DR)
	   Values(:ResRowId,:StartDate,:UpdateTime,:EndDate,:UpdateTime,:Reason,:UpdateDate,:UpdateTime,:UserID,:RSVP,:DayWeek,:TimeRange))
	  Q:(SQLCODE'=0) "-202"
	}
	Q 0
}

/// w ##class(web.DHCBatchStopNew).CheckResData("16/08/2016","31/08/2016","308!","")
ClassMethod CheckResData(StartDate As %String, EndDate As %String, LocDocIdStr As %String, DayWeek As %String, TimeRange As %String)
{
	
		if $L(StartDate,"/")=3 s StartDate=$zdh(StartDate,4)
	if $L(EndDate,"/")=3 s EndDate=$zdh(EndDate,4)
	s ret=""
	Set len1=$l(LocDocIdStr,"|")
	k LocArr
	for i=1:1:len1{
		Set LocDocStr=$p(LocDocIdStr,"|",i)
		Set LocId=$p(LocDocStr,"!",1)
		Set DocIdStr=$p(LocDocStr,"!",2)
		Set LocArr(LocId)=DocIdStr
	}
	s LocId=0
	for  s LocId=$o(LocArr(LocId)) Quit:LocId=""  do
	.Set DocIdStr=LocArr(LocId)
	.s RowId=0 
	.f  S RowId=$o(^RB("RES",0,"CTLOC",LocId,RowId)) Q:RowId=""  d
	..Q:'($D(^RB("RES",RowId)))
	..set ScheSt=$p(^RB("RES",RowId),"^",6)
	..Q:(ScheSt'="Y")
	..S DocID=$p(^RB("RES",RowId),"^",2)
	..Q:DocID=""
	..Quit:(DocIdStr'="")&&(("^"_DocIdStr_"^")'[("^"_DocID_"^"))
	..set ResRowId=$Order(^RB("RES",0,"CTPCP",DocID,LocId,0))
	..f ASDate=StartDate:1:EndDate d
	...Set AdmWeek=$zd(ASDate,10)
	...if AdmWeek=0 Set AdmWeek=7
	...Quit:(AdmWeek'=DayWeek)&&(DayWeek'="")
	...s StartTimeID=""
	...f  s StartTimeID=$O(^RBAS(ResRowId,0,"DateSTime",ASDate,StartTimeID)) q:(StartTimeID="")  d
	....s RBASRowId=""
	....f  s RBASRowId=$O(^RBAS(ResRowId,0,"DateSTime",ASDate,StartTimeID,RBASRowId)) q:(RBASRowId="")  d
	.....s ASStatusid=$P(^RBAS(ResRowId,RBASRowId,"DHC"),"^",10)
	.....if ASStatusid'="" s ASStatus=$p(^DHCRBCASStatus(ASStatusid),"^",1)
	.....Q:(ASStatus="S")||(ASStatus="TR")   //停诊和被停诊则退出
	.....s TimeRangeId=$P(^RBAS(ResRowId,RBASRowId,"DHC"),"^",17)
	.....Quit:(TimeRange'="")&&(TimeRangeId'=TimeRange)
	.....s SubRowId="" f  s SubRowId=$O(^RBAS(ResRowId,RBASRowId,"APPT",SubRowId)) q:(SubRowId="")  d
	......Set LocRowid=$p( ^RB("RES", ResRowId),"^",1)
	......Set DocRowid=$p( ^RB("RES", ResRowId),"^",2)
	......Set LocDesc=$p(^CTLOC(LocRowid),"^",2)
	......Set DocDesc=$p(^CTPCP(DocRowid,1),"^",2)
	......if ret="" s ret=LocDesc_" "_DocDesc_$zd(ASDate,3)_"有预约记录"
	......else  Set ret=ret_","_LocDesc_" "_DocDesc_$zd(ASDate,3)_"有预约记录"
	Q ret
}

ClassMethod UpdateNotAvailSel(RowidStr, UserID, StopMethod)
{
	TS
	s err=0
	for i=1:1:$l(RowidStr,"^"){
		s rowid=$p(RowidStr,"^",i)
		s rtn=##class(web.DHCOPRegHolidayAdjust).UpdateNotAvail(rowid,UserID, StopMethod)
		s err=rtn
		quit:err'=0	
	}
	if err=0{
		tc
		q 0	
	}else{
		trollback
		q err	
	}
}

/// d ##class(%ResultSet).RunQuery("web.DHCBatchStopNew","TimeRangeFind")
Query TimeRangeFind() As %Query(ROWSPEC = "Id:%String,Desc:%String")
{
}

ClassMethod TimeRangeFindExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s Id="",Desc="&nbsp;"
	d OutputRow3
	s Id=0	f  s Id=$O(^DHCTimeRange(Id)) Q:Id=""  d
	.s Sttime=$P(^DHCTimeRange(Id),"^",7)
	.s Endtime=$P(^DHCTimeRange(Id),"^",8)
	.q:Sttime>(+$H)
	.q:(Endtime<(+$H))&&(Endtime'="")
	.s Desc=$P(^DHCTimeRange(Id),"^",2)
 	.d OutputRow3
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow3
	set Data=$lb(Id,Desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod TimeRangeFindFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = TimeRangeFindExecute ]
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

ClassMethod TimeRangeFindClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = TimeRangeFindExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 5800||10 
/// w ##class(web.DHCRBApptSchedule).SendDHCMessage("5800||10","5801||10",299,1)
ClassMethod SendDHCMessage(LocRowid As %String, DocRowid As %String, UserId As %String, StartDate As %String, EndDate As %String, Week As %String, TimeRange As %String)
{
	//Set rtn =##class(websys.DHCMessageInterface).Send(Context, ActionTypeCode, FromUserRowId, EpisodeId , OrdItemId , ToUserRowId , OtherInfoJson )
	S DocDesc=$p(^CTPCP(DocRowid,1),"^",2)
	s LocDesc=$p(^CTLOC(LocRowid),"^",2)
	s StartDate=$p(StartDate,"/",3)_"年"_$p(StartDate,"/",2)_"月"_$p(StartDate,"/",1)_"日"
	s EndDate=$p(EndDate,"/",3)_"年"_$p(EndDate,"/",2)_"月"_$p(EndDate,"/",1)_"日"
	s UserName=$p(^SSU("SSUSR",UserId),"^",2)
	s UserIdStr=""
	s WeekDesc=""
	if Week'=""{
		s WeekDesc=$p(^CT("DOW",1,Week),"^",1)	
	}
	s TimeRangeDesc=""
	if TimeRange'=""{
		s TimeRangeDesc=$p(^DHCTimeRange(TimeRange),"^",2)	
	}
	s id=0
	for  s id=$o(^User.DHCExaBorDepI("BordDepDrIndex"," "_LocRowid,id)) quit:id=""  do
	.s BorId=$list(^User.DHCExaBorDepD(id),6)
	.q:BorId=""
	.s BorDesc=$list(^User.DHCExaBoroughD(BorId),"5")
	.s UserIdStr=""
	.s boruserId=0
	.for  s boruserId=$o(^User.DHCBorUserI("BoruBorDrIndex",BorId,boruserId)) Quit:boruserId=""  do
	..Set userid=$list(^User.DHCBorUserD(boruserId),3)
	..if UserIdStr="" s UserIdStr=userid
	..else  s UserIdStr=UserIdStr_"^"_userid
	.q:UserIdStr=""
	.s content="尊敬的"_BorDesc_"分诊护士您好:您"_BorDesc_" "_LocDesc_" "_DocDesc_" ("_StartDate_"--"_EndDate_" "_WeekDesc_TimeRangeDesc_")的出诊记录已经发生停诊，请知晓处理，如有问题请联系门诊办公室。"
	.s rtn=##class(websys.DHCMessageInterface).Send(content, "1047", UserName, "" , "" , UserIdStr , "")	

	q 0
}

}
