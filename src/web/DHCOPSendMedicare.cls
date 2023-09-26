Class web.DHCOPSendMedicare Extends DHCDoc.Util.RegisteredObject
{

ClassMethod FindAdmListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAdmListExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindAdmListExecute(ByRef qHandle As %Binary, Name As %String = "", RegNo As %String = "", StartDate As %String = "", EndDate As %String = "", HadSend As %String = "") As %Status
{
	
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	Set HospitalCode=##class(web.DHCDocOrderCommon).GetCurrentHospitalCode()
 	i (Name="")&&(RegNo="")&&(StartDate="")&&(EndDate=""){
	 	Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
	s vName=$ZConvert(Name,"U")
	i RegNo'="" d
	.s myPatLen=+$p(^CF("PATCF",1,3),"^",5)
	.s RegNo=$e("0000000000000000000",1,myPatLen-$l(RegNo))_RegNo
	i StartDate="" s StartDate=1
	i EndDate="" s EndDate=..%SysDate()
	i RegNo'="" d
	.s PatMasID=""
	.f  s PatMasID=$O(^PAPERi("PAPMI_PatNo",RegNo,PatMasID)) q:PatMasID=""  d
	..d PatientToAdm(PatMasID)
	e  i vName'=""  d
	.s CurName=$O(^PAPERi("PAPER_PatName",vName),-1)
	.f  s CurName=$O(^PAPERi("PAPER_PatName",CurName)) q:(CurName="")||(CurName'[vName)  d
	..s PatMasID=""
	..f  s PatMasID=$O(^PAPERi("PAPER_PatName",CurName,PatMasID)) q:(PatMasID="")  d
	...d PatientToAdm(PatMasID)
	e  d
	.s Date=StartDate-1
	.f  s Date=$O(^PAADMi("NNType","E",Date)) q:(Date="")||(Date>EndDate)  d
	..s AdmID=""
	..f  s AdmID=$O(^PAADMi("NNType","E",Date,AdmID)) q:AdmID=""  d
	...d OneAdm(AdmID)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
PatientToAdm(PatID)
	s AdmID=""
	f  s AdmID=$O(^PAPERdr(PatID,"ADM","E",AdmID)) q:AdmID=""  d
	.d OneAdm(AdmID)
	q

OneAdm(AdmID)
	d ReSetVar
	s Flag=$P($G(^PAADM(AdmID,"DHC")),"^",16)
	s Flag=$P(Flag,",",1)
	q:Flag'="Y"
	s HandSendFlag=$P(^PAADM(AdmID,"1"),"^",70)
	q:(HandSendFlag="Y")&&(HadSend="")
	i HandSendFlag="Y" d
	.s THadSend="已发送"
	e  d
	.s THadSend="未发送"
	s PatientID=$P(^PAADM(AdmID),"^",1)
	s TRegNo=$P(^PAPER(PatientID,"PAT",1),"^",1)
	q:(RegNo'="")&&(TRegNo'=RegNo)
	s TName=$P(^PAPER(PatientID,"ALL"),"^",1)
	q:(Name'="")&&(TName'[Name)
	s TSex=$P(^PAPER(PatientID,"ALL"),"^",7)
	i TSex'="" s TSex=$P(^CT("SEX",TSex),"^",2)
	s TCardID=$P(^PAPER(PatientID,"PAT",3),"^",6)
	s TLocName=$P(^PAADM(AdmID),"^",4)
	i TLocName'="" s TLocName=$P(^CTLOC(TLocName),"^",2)
	s TAdmDate=$P(^PAADM(AdmID),"^",6)
	q:(TAdmDate<StartDate)||(TAdmDate>EndDate)
	i TAdmDate'="" s TAdmDate=$ZD(TAdmDate,3)
	s TDocName=$P(^PAADM(AdmID),"^",9)
	i TDocName'="" s TDocName=$P(^CTPCP(TDocName,1),"^",2)
	s TAdmID=AdmID
	set Data=$ListBuild(TRegNo,TName,TSex,TCardID,TAdmDate,TDocName,TLocName,THadSend,TAdmID)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	q
ReSetVar
	set (TRegNo,TName,TSex,TCardID,TAdmDate,TDocName,TLocName,THadSend,TAdmID)=""
	q
}

ClassMethod FindAdmListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAdmListExecute ]
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

Query FindAdmList(Name As %String = "", RegNo As %String = "", StartDate As %String = "", EndDate As %String = "", HadSend As %String = "") As %Query(ROWSPEC = "TRegNo:%String,TName:%String,TSex:%String,TCardID:%String,TAdmDate:%String,TDocName:%String,TLocName:%String,THadSend:%String,TAdmID:%String")
{
}

ClassMethod SendMedicare(AdmID)
{
	
	&SQL(Update Sqluser.PA_ADM set PAADM_ChaplainPhone='Y' where PAADM_RowID=:AdmID)
	q:SQLCODE'=0 SQLCODE
	d ##class(DHCENS.REG.BS.WebREGService).OPRegInfoSend(AdmID)
	q SQLCODE
}

ClassMethod GetStatusStr()
{
	s rtn=$C(1)
	s id=0
	f  s id=$O(^DHCRBCASStatus(id)) q:id=""  d
	.s desc=$P(^DHCRBCASStatus(id),"^",2)
	.s oneStr=id_$C(1)_desc
	.s rtn=rtn_"^"_oneStr
	q rtn
}

ClassMethod FindRBASClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindRBASExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindRBASExecute(ByRef qHandle As %Binary, LocID As %String = "", DocID As %String = "", StatusID As %String = "", ReasonID As %String = "", StartDate As %String = "", EndDate As %String = "", Submit As %String = "") As %Status
{
	
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	i (DocID="")&&(LocID="")&&(StartDate="")&&(EndDate=""){
	 	Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 	s LogonHospId=%session.Get("LOGON.HOSPID")
 	i StartDate="" s StartDate=1
 	i EndDate="" s EndDate=..%SysDate()
 	i StartDate'="" s StartDate=..%ZDH(StartDate)
    i EndDate'="" s EndDate=..%ZDH(EndDate)
 	s Job=$J
 	k ^TempDHCRBASQuery(Job)
 	i DocID'="" d
 	.i LocID'="" d
 	..s RESID=0
 	..f  s RESID=$O(^RB("RES",0,"CTPCP",DocID,LocID,RESID)) q:RESID=""  d
 	...d OneRESInfo(RESID)
 	.e  d
 	.s locid=0
 	.f  s locid=$O(^RB("RES",0,"CTPCP",DocID,locid)) q:locid=""  d
 	..s RESID=0
 	..f  s RESID=$O(^RB("RES",0,"CTPCP",DocID,locid,RESID)) q:RESID=""  d
 	...d OneRESInfo(RESID)
 	e  i LocID'=""  d
 	.s RESID=0
 	.f  s RESID=$O(^RB("RES",0,"CTLOC",LocID,RESID)) q:RESID=""  d
 	..d OneRESInfo(RESID)
 	e  d
 	.s RESID=0
 	.f  s RESID=$O(^RB("RES",RESID)) q:RESID=""  d
 	..d OneRESInfo(RESID)
 	//Job,"Data",CurDate,Loc,Doc,CurStatus,SessType,RESID_"||"_Sub
 	s Date=""
 	f  s Date=$o(^TempDHCRBASQuery(Job,"Data",Date)) q:Date=""  d
 	.s Loc=""
 	.f  s Loc=$O(^TempDHCRBASQuery(Job,"Data",Date,Loc)) q:Loc=""  d
 	..s Doc=""
 	..f  s Doc=$O(^TempDHCRBASQuery(Job,"Data",Date,Loc,Doc)) q:Doc=""  d
 	...s Status=""
 	...f  s Status=$O(^TempDHCRBASQuery(Job,"Data",Date,Loc,Doc,Status)) q:Status=""  d
 	....s SessType=""
 	....f  s SessType=$O(^TempDHCRBASQuery(Job,"Data",Date,Loc,Doc,Status,SessType)) q:SessType=""  d
 	.....s RESID=""
 	.....f  s RESID=$O(^TempDHCRBASQuery(Job,"Data",Date,Loc,Doc,Status,SessType,RESID)) q:RESID=""  d
 	......s QtyInfo=$G(^TempDHCRBASQuery(Job,"Data",Date,Loc,Doc,Status,SessType,RESID))
 	......q:QtyInfo=""
 	......s TStatusDr=$p(QtyInfo,"^",1)
 	......s TStatus=$P(^DHCRBCASStatus(TStatusDr),"^",2)
 	......s TSessTypeDr=$p(QtyInfo,"^",2)
 	......s TSessType=$P(^RBC("SESS",TSessTypeDr),"^",2)
 	......s TLocDesc=$P(^CTLOC(Loc),"^",2)
 	......s TDocDesc=$P($G(^CTPCP(Doc,1)),"^",2)
 	......s TReason=$P(QtyInfo,"^",6)
 	......s TQty=$P(QtyInfo,"^",7)
 	......s TimeRangeDr=$P(QtyInfo,"^",8)
 	......s TTimeRange=$p(^DHCTimeRange(TimeRangeDr),"^",2)
 	......s TQty1="",TQty2="",TQty3=""
 	......s TDate=..%ZD(Date)
 	......d ListBuild
 	k ^TempDHCRBASQuery(Job)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OneRESInfo(RESID)
 	s CurDate=StartDate-1
	f  s CurDate=$O(^RBAS(RESID,0,"DateSTime",CurDate)) q:(CurDate="")||(CurDate>EndDate)  d
	.s Time=0
	.f  s Time=$O(^RBAS(RESID,0,"DateSTime",CurDate,Time)) q:(Time="")  d
	..s Sub=0
	..f  s Sub=$O(^RBAS(RESID,0,"DateSTime",CurDate,Time,Sub)) q:(Sub="")  d
	...s CurStatus=$P(^RBAS(RESID,Sub,"DHC"),"^",10)
	...q:(StatusID'="")&&(CurStatus'=StatusID)
	...s CurReason=$P(^RBAS(RESID,Sub,"DHC"),"^",11)
	...s CurStatusCode=$p(^DHCRBCASStatus(CurStatus),"^",1)
	...i (CurStatusCode'="S")&&(CurStatusCode'="PS")&&(CurStatusCode'="R")&&(CurStatusCode'="TR") s CurReason=""
	...q:(ReasonID'="")&&(CurReason'=ReasonID)
	...s ReasonType=""
	...i CurReason'="" s ReasonType=$P($g(^RBC("NA",CurReason)),"^",2)
	...q:(Submit'="")&&(ReasonType'="")&&(ReasonType'="F")
	...s SessType=$P(^RBAS(RESID,Sub,"DHC"),"^",6)
	...q:SessType=""
	...s TimeRange=$P(^RBAS(RESID,Sub,"DHC"),"^",17)
	...q:TimeRange=""
	...s Qty=$P(^RBAS(RESID,Sub),"^",8)
	...s Loc=$P(^RB("RES",RESID),"^",1)
	...s CTLocHospDr=$p(^CTLOC(Loc),"^",22)
	...q:(LogonHospId'="")&&(CTLocHospDr'=LogonHospId)
	...s Doc=$P(^RB("RES",RESID),"^",2)
	...s ^TempDHCRBASQuery(Job,"Data",CurDate,Loc,Doc,CurStatus,SessType,RESID_"||"_Sub)=CurStatus_"^"_SessType_"^"_CurDate_"^"_Loc_"^"_Doc_"^"_ReasonType_"^"_Qty_"^"_TimeRange
	q
ListBuild
	set Data=$ListBuild(TStatus,TSessType,TDate,TLocDesc,TDocDesc,TReason,TQty1,TQty2,TQty3,TQty,TTimeRange)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	q
 	/*s TimeRangeID=0
 	s i=1
 	f  s TimeRangeID=$O(^DHCTimeRange(TimeRangeID)) q:TimeRangeID=""  d
 	.s ^TempDHCRBASQuery(Job,"TimeRangeID",TimeRangeID)=i
 	.s i=i+1
 	
 	i DocID'="" d
 	.i LocID'="" d
 	..s RESID=0
 	..f  s RESID=$O(^RB("RES",0,"CTPCP",DocID,LocID,RESID)) q:RESID=""  d
 	...d OneRESInfo(RESID)
 	.e  d
 	.s locid=0
 	.f  s locid=$O(^RB("RES",0,"CTPCP",DocID,locid)) q:locid=""  d
 	..s RESID=0
 	..f  s RESID=$O(^RB("RES",0,"CTPCP",DocID,locid,RESID)) q:RESID=""  d
 	...d OneRESInfo(RESID)
 	e  i LocID'=""  d
 	.s RESID=0
 	.f  s RESID=$O(^RB("RES",0,"CTLOC",LocID,RESID)) q:RESID=""  d
 	..d OneRESInfo(RESID)
 	e  d
 	.s RESID=0
 	.f  s RESID=$O(^RB("RES",RESID)) q:RESID=""  d
 	..d OneRESInfo(RESID)
 	s Status=""
 	f  s Status=$O(^TempDHCRBASQuery(Job,"Data",Status)) q:Status=""  d
 	.s StatusDesc=$P(^DHCRBCASStatus(Status),"^",2)
 	.s SessType=""
 	.f  s SessType=$O(^TempDHCRBASQuery(Job,"Data",Status,SessType)) q:SessType=""  d
 	..s SessTypeDesc=$P(^RBC("SESS",SessType),"^",2)
 	..s Date=""
 	..f  s Date=$O(^TempDHCRBASQuery(Job,"Data",Status,SessType,Date)) q:Date=""  d
 	...s DateDesc=..%ZD(Date) //$ZD(Date,3)
 	...s Loc=""
 	...f  s Loc=$O(^TempDHCRBASQuery(Job,"Data",Status,SessType,Date,Loc)) q:Loc=""  d
 	....s LocDesc=$P(^CTLOC(Loc),"^",2)
 	....i $L(LocDesc,"-")>1 d
 	.....s LocDesc=$P(LocDesc,"-",2,4)
 	....s Doc=""
 	....f  s Doc=$O(^TempDHCRBASQuery(Job,"Data",Status,SessType,Date,Loc,Doc)) q:Doc=""  d
 	.....s DocDesc=$P($G(^CTPCP(Doc,1)),"^",2)
 	.....s QtyInfo=$G(^TempDHCRBASQuery(Job,"Data",Status,SessType,Date,Loc,Doc))
 	.....d ReSetVar2
 	.....s TReason=$G(^TempDHCRBASQuery(Job,"Data",Status,SessType,Date,Loc,Doc,"Rea"))
 	.....s TQty1=$P(QtyInfo,"^",1)
 	.....s TQty2=$P(QtyInfo,"^",2)
 	.....s TQty3=$P(QtyInfo,"^",3)
 	.....s TStatus=StatusDesc
 	.....s TSessType=SessTypeDesc
 	.....s TDate=DateDesc
 	.....s TLocDesc=LocDesc
 	.....s TDocDesc=DocDesc
 	.....d ListBuild
 	k ^TempDHCRBASQuery(Job)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OneRESInfo(RESID)
	s CurDate=StartDate-1
	f  s CurDate=$O(^RBAS(RESID,0,"DateSTime",CurDate)) q:(CurDate="")||(CurDate>EndDate)  d
	.s Time=0
	.f  s Time=$O(^RBAS(RESID,0,"DateSTime",CurDate,Time)) q:(Time="")  d
	..s Sub=0
	..f  s Sub=$O(^RBAS(RESID,0,"DateSTime",CurDate,Time,Sub)) q:(Sub="")  d
	...s CurStatus=$P(^RBAS(RESID,Sub,"DHC"),"^",10)
	...q:(StatusID'="")&&(CurStatus'=StatusID)
	...s CurReason=$P(^RBAS(RESID,Sub,"DHC"),"^",11)
	...s CurStatusCode=$p(^DHCRBCASStatus(CurStatus),"^",1)
	...i (CurStatusCode'="S")&&(CurStatusCode'="PS")&&(CurStatusCode'="R")&&(CurStatusCode'="TR") s CurReason=""
	...q:(ReasonID'="")&&(CurReason'=ReasonID)
	...s ReasonType=""
	...i CurReason'="" s ReasonType=$P($g(^RBC("NA",CurReason)),"^",2)
	...q:(Submit'="")&&(ReasonType'="")&&(ReasonType'="F")
	...s SessType=$P(^RBAS(RESID,Sub,"DHC"),"^",6)
	...q:SessType=""
	...s TimeRange=$P(^RBAS(RESID,Sub,"DHC"),"^",17)
	...q:TimeRange=""
	...s Qty=$P(^RBAS(RESID,Sub),"^",8)
	...s Loc=$P(^RB("RES",RESID),"^",1)
	...s CTLocHospDr=$p(^CTLOC(Loc),"^",22)
	...q:(LogonHospId'="")&&(CTLocHospDr'=LogonHospId)
	...s Doc=$P(^RB("RES",RESID),"^",2)
	...s Sort=$G(^TempDHCRBASQuery(Job,"TimeRangeID",TimeRange))
	...s $P(^TempDHCRBASQuery(Job,"Data",CurStatus,SessType,CurDate,Loc,Doc),"^",Sort)=Qty
	...s ^TempDHCRBASQuery(Job,"Data",CurStatus,SessType,CurDate,Loc,Doc,"Rea")=ReasonType
	q
ListBuild
	set Data=$ListBuild(TStatus,TSessType,TDate,TLocDesc,TDocDesc,TReason,TQty1,TQty2,TQty3)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	q
ReSetVar2
	set (TStatus,TSessType,TDate,TLocDesc,TDocDesc,TReason,TQty1,TQty2,TQty3)=""
	q*/
}

ClassMethod FindRBASFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindRBASExecute ]
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

Query FindRBAS(LocID As %String = "", DocID As %String = "", StatusID As %String = "", ReasonID As %String = "", StartDate As %String = "", EndDate As %String = "", Submit As %String = "") As %Query(ROWSPEC = "TStatus:%String,TSessType:%String,TDate:%String,TLocDesc:%String,TDocDesc:%String,TReason:%String,TQty1:%String,TQty2:%String,TQty3:%String,TQty,TTimeRange")
{
}

ClassMethod FindStopRBASClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindStopRBASExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindStopRBASExecute(ByRef qHandle As %Binary, LocID As %String = "", DocID As %String = "", StatusID As %String = "", ReasonID As %String = "", StartDate As %String = "", EndDate As %String = "", HadNotified As %String = "", BookingSystemID As %String = "") As %Status
{
	
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	i (DocID="")&&(LocID="")&&(StartDate="")&&(EndDate=""){
	 	Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 	s CommonID=..GetCommonID()
 	i StatusID="" s StatusID="S^PS"
 	i StartDate="" s StartDate=1
 	i EndDate="" s EndDate=..%SysDate()
 	s Job=$J
 	k ^TempDHCRBASQuery(Job)
 	s TimeRangeID=0
 	s i=1
 	f  s TimeRangeID=$O(^DHCTimeRange(TimeRangeID)) q:TimeRangeID=""  d
 	.s ^TempDHCRBASQuery(Job,"TimeRangeID",TimeRangeID)=i
 	.s i=i+1
 	
 	i DocID'="" d
 	.s RESID=0
 	.f  s RESID=$O(^RB("RES",0,"CTPCP",DocID,LocID,RESID)) q:RESID=""  d
 	..d OneRESInfo(RESID)
 	e  i LocID'=""  d
 	.s RESID=0
 	.f  s RESID=$O(^RB("RES",0,"CTLOC",LocID,RESID)) q:RESID=""  d
 	..d OneRESInfo(RESID)
 	e  d
 	.s RESID=0
 	.f  s RESID=$O(^RB("RES",RESID)) q:RESID=""  d
 	..d OneRESInfo(RESID)
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OneRESInfo(RESID)
	d ReSetVar3
	s Loc=$P(^RB("RES",RESID),"^",1)
	s TLocDesc=$P(^CTLOC(Loc),"^",2)
 	i $L(TLocDesc,"-")>1 d
 	.s TLocDesc=$P(TLocDesc,"-",2,4)
	s Doc=$P(^RB("RES",RESID),"^",2)
	q:Doc=""
	s TDocDesc=$P($G(^CTPCP(Doc,1)),"^",2)
	s CurDate=StartDate-1
	f  s CurDate=$O(^RBAS(RESID,0,"DateSTime",CurDate)) q:(CurDate="")||(CurDate>EndDate)  d
	.s TDate=$ZD(CurDate,3)
	.s Time=0
	.f  s Time=$O(^RBAS(RESID,0,"DateSTime",CurDate,Time)) q:(Time="")  d
	..s Sub=0
	..f  s Sub=$O(^RBAS(RESID,0,"DateSTime",CurDate,Time,Sub)) q:(Sub="")  d
	...s CurStatus=$P(^RBAS(RESID,Sub,"DHC"),"^",10)
	...q:CurStatus=""
	...s CurStatusCode=$P(^DHCRBCASStatus(CurStatus),"^",1)
	...q:(StatusID'="")&&(("^"_StatusID_"^")'[("^"_CurStatusCode_"^"))
	...s TStatus=$P(^DHCRBCASStatus(CurStatus),"^",2)
	...s CurReason=$P(^RBAS(RESID,Sub,"DHC"),"^",11)
	...s TReason=""
	...i CurReason'="" d
	....s TReason=$P($g(^RBC("NA",CurReason)),"^",2)
	...s SessType=$P(^RBAS(RESID,Sub,"DHC"),"^",6)
	...s TSessType=""
	...s:SessType'="" TSessType=$P(^RBC("SESS",SessType),"^",2)
	...s TimeRange=$P(^RBAS(RESID,Sub,"DHC"),"^",17)
	...s TTimeRange=""
	...s:TimeRange'="" TTimeRange=$P(^DHCTimeRange(TimeRange),"^",2)
	...s ApptSub=0
	...f  s ApptSub=$O(^RBAS(RESID,Sub,"APPT",ApptSub)) q:ApptSub=""  d
	....s Status=$P(^RBAS(RESID,Sub,"APPT",ApptSub),"^",3)
	....s TApptStatus=""
	....q:Status="X"
	....q:Status="T"
	....s:Status="I" TApptStatus="预约"
	....s:Status="A" TApptStatus="取号"
	....s TApptStatus=TApptStatus_Status
	....s PatMasID=$P(^RBAS(RESID,Sub,"APPT",ApptSub),"^",2)
	....s TID=RESID_"||"_Sub_"||"_ApptSub
	....s THadNotify=$D(^DHCOPRegManager("Success","UpdateNotifyStatus",TID))
	....q:(HadNotified'="")&&(THadNotify="0")
	....q:(HadNotified="")&&(THadNotify="1")
	....s TBookingSystem=$P(^RBAS(RESID,Sub,"APPT",ApptSub),"^",40)
	....q:(BookingSystemID'="")&&(TBookingSystem'=BookingSystemID)
	....s:TBookingSystem'="" TBookingSystem=$P(^PAC("APPTBS",TBookingSystem),"^",2)
	....s TOrderCode=$P(^RBAS(RESID,Sub,"APPT",ApptSub),"^",69)
	....i CommonID=PatMasID d
	.....s TName=$P(^RBAS(RESID,Sub,"APPT",ApptSub,"DHC"),"^",1)
	.....s TMobileTel=$P(^RBAS(RESID,Sub,"APPT",ApptSub,"DHC"),"^",5)
	.....s TTel=$P(^RBAS(RESID,Sub,"APPT",ApptSub,"DHC"),"^",4)
	.....s TCredNo=$P(^RBAS(RESID,Sub,"APPT",ApptSub,"DHC"),"^",8)
	....e  d
	.....s TName=$p($g(^PAPER(PatMasID,"ALL")),"^",1)
	.....s TMobileTel=$p($g(^PAPER(PatMasID,"PER",4)),"^",21)
	.....s TTel=$p($g(^PAPER(PatMasID,"PER",1)),"^",11)
	.....s TCredNo=$p($g(^PAPER(PatMasID,"PAT",3)),"^",6)
	
	....d ListBuild3
	q
ListBuild3
	set Data=$ListBuild(TLocDesc,TDocDesc,TReason,TDate,TSessType,TTimeRange,TID,TName,TStatus,TMobileTel,TTel,TSelect,THadNotify,TOrderCode,TBookingSystem,TApptStatus,TCredNo)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	q
ReSetVar3
	set (TLocDesc,TDocDesc,TReason,TDate,TSessType,TTimeRange,TID,TName,TStatus,TMobileTel,TTel,TSelect,THadNotify,TOrderCode,TBookingSystem,TApptStatus,TCredNo)=""
	q
}

ClassMethod FindStopRBASFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindStopRBASExecute ]
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

Query FindStopRBAS(LocID As %String = "", DocID As %String = "", StatusID As %String = "", ReasonID As %String = "", StartDate As %String = "", EndDate As %String = "", HadNotified As %String = "", BookingSystemID As %String = "") As %Query(ROWSPEC = "TLocDesc:%String,TDocDesc:%String,TReason:%String,TDate:%String,TSessType:%String,TTimeRange:%String,TID:%String,TName:%String,TStatus:%String,TMobileTel:%String,TTel:%String,TSelect:%String,THadNotify:%String,TOrderCode:%String,TBookingSystem:%String,TApptStatus:%String,TCredNo:%String")
{
}

// w ##class(web.DHCOPSendMedicare).GetWeekNum("2011-10-05")

ClassMethod GetWeekNum(DateStr)
{
	s $ZT="Err"
	s Date=..%ZDH(DateStr) //$ZDH(DateStr,3)
	s CurrDateWeek=$ZD(+$H,10)
	i CurrDateWeek=0 s CurrDateWeek=7
	s DateNum=Date-(+$H)+CurrDateWeek-1
	i DateNum>-1{
		q (DateNum\7)
	}else{
		q ((1+DateNum)\7)-1
	}
Err
 	q 0
}

// 判断是否有公共卡

ClassMethod GetCommonID()
{
	s CommonPatientID=""
	s CommonCardNo=##class(web.DHCOPRegConfig).GetSpecConfigNode("CommonCardNo")
	i (CommonCardNo'="") {
		s ExpStr=""_$c(2)_""_$C(2)_"PatInfo"
		s ret=##class(web.UDHCAccManageCLSIF).getaccinfofromcardno(CommonCardNo,"",ExpStr)
		s retcode=$P(ret,"^",1)
		if (retcode="-201")!(retcode="0"){
			s CommonPatientID=$P(ret,"^",8)
		}
	}
	q CommonPatientID
}

// 修改停诊通知状态

ClassMethod UpdateNotifyStatus(IDs, UserID As %String = "")
{
	s ErrNum=0
	s i=$L(IDs,"^")
	f j=1:1:i
	{
		s ID=$P(IDs,"^",j)
		s rtn=##class(DHCExternalService.RegInterface.RegManager).UpdateNotifyStatus(ID)
		i +rtn=0{
			s ^DHCOPRegManager("Success","UpdateNotifyStatus",ID)=$H_"^"_UserID
		}else{
			s ErrNum=ErrNum+1
		}
	}
	q ErrNum
}

ClassMethod FindVisitAmountClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindVisitAmountExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCOPSendMedicare","FindVisitAmount","2018-03-01","2018-03-11","1")
ClassMethod FindVisitAmountExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, CTLocID As %String) As %Status
{
	s ^Tempyl("FindVisitAount")=StartDate_","_EndDate_","_CTLocID
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	;k ^TMPVisitAmount("VisitAmount")
 	if StartDate["-" s StartDate=$zdh(StartDate,3)
 	else  s StartDate=$zdh(StartDate,4)
	if EndDate["-" s EndDate=$zdh(EndDate,3)
	else  s EndDate=$zdh(EndDate,4)
 	
 	i StartDate="" s StartDate=..%SysDate()
 	i EndDate="" s EndDate=..%SysDate()
 	if CTLocID="" d
 	.s RESID=0
 	.f  s RESID=$O(^RB("RES",RESID)) q:RESID=""  d
 	..d GetInfo(RESID)
 	else  d
 	.s RESID=0
 	.f  s RESID=$O(^RB("RES",0,"CTLOC",CTLocID,RESID)) q:RESID=""  d
	..d GetInfo(RESID)
	
	d OutPutFindInfo
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutFindInfo
	s myRESID=""
	for  s myRESID=$o(^||TMPVisitAmount("VisitAmount",myRESID)) Q:myRESID=""  d
	.s ResDocDr=$P(^RB("RES",myRESID),"^",2)
	.s DocDesc=$P(^CTPCP(ResDocDr,1),"^",2)
	.s ResLocDr=$P(^RB("RES",myRESID),"^",1)
	.s LocDesc=$P(^CTLOC(ResLocDr),"^",2)
	.if LocDesc["-" s LocDesc=$p(LocDesc,"-",2)
	.s VisitNum=+$g(^||TMPVisitAmount("VisitAmount",myRESID))
	.s Data=$lb(LocDesc,DocDesc,VisitNum)
	.Set ^CacheTemp(repid,ind)=Data
	.Set ind=ind+1
	quit	
GetInfo(RESID)
	s VisitNum=0
	s CurDate=StartDate-1
	f  s CurDate=$O(^RBAS(RESID,0,"DateSTime",CurDate)) q:(CurDate="")||(CurDate>EndDate)  d
	.s Time=0,DocDesc="",quitflag=0
	.s CTloc=$P(^RB("RES",RESID),"^",1) //查询科室ID
	.q:(CTLocID'="")&&(CTloc'=CTLocID)
	.f  s Time=$O(^RBAS(RESID,0,"DateSTime",CurDate,Time)) q:(Time="")  d
	..s Sub=0
	..f  s Sub=$O(^RBAS(RESID,0,"DateSTime",CurDate,Time,Sub)) q:(Sub="")!(quitflag=1)  d
	...s CurStatusDr=$P(^RBAS(RESID,Sub,"DHC"),"^",10)
	...s ASStatus=""
	...if CurStatusDr'="" s ASStatus=$p(^DHCRBCASStatus(CurStatusDr),"^",1)
	...if (ASStatus'="N")&&(ASStatus'="R") s quitflag=1
	.Q:quitflag=1
	.s ^||TMPVisitAmount("VisitAmount",RESID)=+$g(^||TMPVisitAmount("VisitAmount",RESID))+1
	Quit
}

ClassMethod FindVisitAmountFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindVisitAmountExecute ]
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

Query FindVisitAmount(StartDate As %String, EndDate As %String, CTLocID As %String) As %Query(ROWSPEC = "TLocDesc:%String,TempDoc:%String,TVisitNum:%Float") [ SqlProc ]
{
}

}
