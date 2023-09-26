Class web.PAAdmTransaction Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 2995;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "TRANS_RowId";

Parameter SQLDESCRIPTION = "TRANS_RowId";

Parameter SQLROWID = "TRANS_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod FindEpisodesInBAClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindEpisodesInBAFetch ]
{
	n repid
	s repid=$li(QHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

// qse 20110721

/// KM 6-May-2002
/// This is the new query that all requests for episodes in room should run off.
///  	KM 21-Oct-2002: This is the main query that collects information 
/// on episodes in a wards waiting/booked room.
///  d ##class(%ResultSet).RunQuery("web.PAAdmTransaction","FindEpisodesInBA",56,"")
ClassMethod FindEpisodesInBAExecute(ByRef QHandle As %Library.Binary, WardID As %Library.String, BookingDueDate As %Library.String = "") As %Library.Status
{
	n repid,ROOMQuery,RoomID,ID,Status,outlier,TempLoc
	s repid=$I(^CacheTemp)
	s ind=1
	s QHandle=$lb(0,repid,0)

	s listDocDischs=##class(%ListOfDataTypes).%New()	//出院病人LIST
	s listNewPats=##class(%ListOfDataTypes).%New()	//入院病人LIST
	s listTransPats=##class(%ListOfDataTypes).%New()	//转科病人List
	s listOthers=##class(%ListOfDataTypes).%New()	//其他病人List
	s chl=0  f  s chl=$O(^PAWARDA(WardID,"WADM",chl)) q:chl=""  d
	.s ID=$P(^PAWARDA(WardID,"WADM",chl),"^",1)
	.s Status=$P(^PAWARDA(WardID,"WADM",chl),"^",2)
	.s RoomID=$P(^PAWARDA(WardID,"WADM",chl),"^",4)
	.s ROOMQuery=""
	.i RoomID'="" s ROOMQuery=$P(^PAROOM(RoomID),"^",5)
	.Q:(ROOMQuery'="BA")&&(ROOMQuery'="WA")&&(ROOMQuery'="WE")&&(ROOMQuery'="")
    .s TempLoc=$P($g(^PAADM(ID)),"^",74)
    .s PAADMVisitStatus=$p(^PAADM(ID),"^",20)
    .Q:PAADMVisitStatus'="A"
    .s outlier="0"
    .s pat=##class(%ArrayOfDataTypes).%New()
	.d pat.SetAt(ID,"ID")
	.d pat.SetAt(Status,"Status")
	.d pat.SetAt(outlier,"outlier")
	.d pat.SetAt(TempLoc,"TempLoc")
	.s ifNewPatient=##class(web.DHCSETIMAGE).IfNewPatient(ID)
	.i ifNewPatient=1 d listNewPats.Insert(pat)
	.s ifDocDisch=##class(web.DHCSETIMAGE).DocDisch(ID)
	.i ifDocDisch=1 d listDocDischs.Insert(pat)
    .s ifNewTrans=##class(web.DHCSETIMAGE).IsTransInPat(ID)
	.i ifNewTrans=1 d listTransPats.Insert(pat)
    .i (ifNewPatient'=1)&&(ifDocDisch'=1) d listOthers.Insert(pat)    

	d ListTraversal(listDocDischs)
	d ListTraversal(listNewPats)
	d ListTraversal(listTransPats)
	d ListTraversal(listOthers)
	d ListTraversal(##Class(Nur.DHCNurTransAudit).TransOutList(WardID))
	
    Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutPat
	set Data=$lb(ID,Status,outlier,TempLoc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
ListTraversal(list)
	for i=1:1:list.Count() D
	.s pat = list.GetAt(i)
	.s ID = pat.GetAt("ID")
	.s Status = pat.GetAt("Status")
	.s outlier = pat.GetAt("outlier")
	.s TempLoc = pat.GetAt("TempLoc")
	.d OutPat
}

ClassMethod FindEpisodesInBAFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindEpisodesInBAExecute ]
{
	n repid
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindEpisodesInMPRClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindEpisodesInMPRFetch ]
{
	n repid
	s repid=$li(QHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// ; ab 6.03.03 - query to get episodes for one or more multi patient rooms
/// ; if only wardid passed, get episodes for all MPR's in ward
/// ; ab 16.09.03 - 37188 changed to an execute based query because we need to sort by priority
/// d ##class(%ResultSet).RunQuery("web.PAAdmTransaction","FindEpisodesInMPR",56,"")
ClassMethod FindEpisodesInMPRExecute(ByRef QHandle As %Library.Binary, WardID As %Library.String = "", RoomID As %Library.String = "") As %Library.Status
{
	n repid,ROOMQuery,PACRoomID,ID,Status,outlier,TempLoc
	s repid=$I(^CacheTemp)
	s ind=1
	s QHandle=$lb(0,repid,0)
	
	s chl=0  f  s chl=$O(^PAWARDA(WardID,"WADM",chl)) q:chl=""  d
	.s ID=$P(^PAWARDA(WardID,"WADM",chl),"^",1)
	.s VisitStatus=$p($g(^PAADM(ID)),"^",20)
	.q:VisitStatus'="A" 
	.s PACRoomID=$P(^PAWARDA(WardID,"WADM",chl),"^",4)
	.s ROOMQuery=""
	.i PACRoomID'="" s ROOMQuery=$P(^PAROOM(PACRoomID),"^",5)
	.Q:ROOMQuery'="MPR"
	.Q:(RoomID'="")&&(PACRoomID'=RoomID)
	.s Status=$P(^PAWARDA(WardID,"WADM",chl),"^",2)
    .s TempLoc=$P($g(^PAADM(ID)),"^",74)
    .s outlier="0"
    .d OutPat1

    Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutPat1
	set Data=$lb(ID,Status,outlier,TempLoc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindEpisodesInMPRFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindEpisodesInMPRExecute ]
{
	n repid
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// qse add 2011.07.23 ????
ClassMethod getba(WardID)
{
 //s a=##class(web.PAAdmTransaction).getba(10)
	s chl=""  f  s chl=$O(^PAWARDA(WardID,"WADM",chl)) q:chl=""  d
	.s ID=$P(^PAWARDA(WardID,"WADM",chl),"^",1)
	.s Status=$P(^PAWARDA(WardID,"WADM",chl),"^",2)
    .s TempLoc=$P($g(^PAADM(ID)),"^",74)
    .s outlier="0"
    .w !,ID,"-",Status
}

ClassMethod FindEpisodesInRoomClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindEpisodesInRoomFetch ]
{
}

/// KM 6-May-2002
/// This is the new query that all requests for episodes in room should run off.
/// KM 21-Oct-2002: This query is THE query used to find episodes in Waiting 
/// Areas of either type WA or WE.  It is called from both epr.floorplan.csp 
/// and the web.PACWardRoom.FindPatientsInRoom
ClassMethod FindEpisodesInRoomExecute(ByRef QHandle As %Library.Binary, locID As %Library.String = "", qryType As %Library.String = "") As %Library.Status
{
}

ClassMethod FindEpisodesInRoomFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindEpisodesInRoomExecute ]
{
}

ClassMethod FindTransactionListClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindTransactionListFetch ]
{
	s repid=$li(QHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// wanghc 2011-10-28
ClassMethod FindTransactionListExecute(ByRef QHandle As %Library.Binary, EpisodeID As %Library.String = "", TransType As %Library.String = "") As %Library.Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	Set QHandle=$lb(0,repid,0)
    i EpisodeID="" Quit $$$OK
    s PAADMPAPMIDR=$p(^PAADM(EpisodeID),"^",1)
    s sub=0 f  s sub = $O(^PAADM(EpisodeID,"TRANS",sub)) q:sub=""  d
    .s (SSUSRName,WARDDesc,ROOMDesc,ROOMTDesc,BEDCode,TRANSParRef,TRANSEndDate,TRANSEndTime,TRANSStartDate,TRANSStartTime,BTRDesc,REQSTDesc,HOSPDesc,TRANSUpdateDate,TRANSUpdateTime,TRANSTYPCode,TRANSTYPDesc,TRANSDateAccepted,TRANSTimeAccepted,TRANSClosure,PAADMPAPMIDR,CTLOCDesc,BTRTransferRemark,BEDTPDesc,TRANSReadyForBill,CTPCPDesc)=""
    .s transGlobal=^PAADM(EpisodeID,"TRANS",sub)
    .s TarDR= $p(transGlobal,"^",21)
    .s:TarDR'="" TRANSTYPCode=$p(^PAC("TRANSTYP",TarDR),"^",1)
	.;q:(TRANSTYPCode'="")&&(TRANSTYPCode'=TransType)&&(TransType'="")
	.s:TarDR'="" TRANSTYPDesc=$p(^PAC("TRANSTYP",TarDR),"^",2)
	.;q:TRANSTYPCode="T"	//Transfer  Move "" 
    .s SSUSRDR = $p(transGlobal,"^",16)
    .s SSUSRName = $s(SSUSRDR'="":$p(^SSU("SSUSR",SSUSRDR),"^",2),1:"")
    .s WARDDR = $p(transGlobal,"^",9)
    .s:WARDDR'="" WARDDesc=$p(^PAWARD(WARDDR),"^",2)
    .s ROOMDR=$p(transGlobal,"^",7)
    .s:ROOMDR'="" ROOMDesc=$p(^PAROOM(ROOMDR),"^",2)
    .s ROOMTDR=$p(transGlobal,"^",10)
    .s:ROOMTDR'="" ROOMTDesc=$p(^PAC("ROOMT",ROOMTDR),"^",2)
    .s BEDDR=$p(transGlobal,"^",8)
    .s:BEDDR'="" BEDCode=$p(^PAWARD(+BEDDR,"BED",$p(BEDDR,"||",2)),"^",1)
    .s TRANSParRef=EpisodeID
    .s TRANSEndDate=$p(transGlobal,"^",3)
    .s TRANSEndTime=$p(transGlobal,"^",4)
    .s TRANSStartDate=$p(transGlobal,"^",1)
    .s TRANSStartTime=$p(transGlobal,"^",2)
    .s TRANSUpdateDate=$p(transGlobal,"^",14)
    .s TRANSUpdateTime=$p(transGlobal,"^",15)
    .s TRANSDateAccepted=$p(transGlobal,"^",22)
    .s TRANSTimeAccepted=$p(transGlobal,"^",23)
    .s TRANSClosure=$p(transGlobal,"^",26)
    .s TRANSReadyForBill=$p(transGlobal,"^",32)
    .s StatusDR=$p(transGlobal,"^",12) ;TRANS_Status_DRPACTransfRequestStatus
    .s:StatusDR'="" REQSTDesc=$p(^PAC("REQST",StatusDR),"^",2)
    .s CTLOCDR=$p(transGlobal,"^",6)
    .s:CTLOCDR'="" CTLOCDesc=$p(^CTLOC(CTLOCDR),"^",2)
    .s BEDTPDR=$p(transGlobal,"^",31)
    .s:(BEDTPDR'="")&&($d(^PAC("BEDTP",BEDTPDR))'=0) BEDTPDesc=$p(^PAC("BEDTP",BEDTPDR),"^",2)
    .;s BTRDesc=
    .;s HOSPDesc=
    .;s BTRTransferRemark,
    .s CTPCPDr=$p(transGlobal,"^",5)
    .i CTPCPDr'="" s CTPCPDesc=$p(^CTPCP(CTPCPDr,1),"^",2)
    .d OutPat2
    Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutPat2
	set Data=$lb(EpisodeID_"||"_sub,SSUSRName,WARDDesc,ROOMDesc,ROOMTDesc,BEDCode,TRANSParRef,TRANSEndDate,TRANSEndTime,TRANSStartDate,TRANSStartTime,BTRDesc,REQSTDesc,HOSPDesc,TRANSUpdateDate,TRANSUpdateTime,TRANSTYPCode,TRANSTYPDesc,TRANSDateAccepted,TRANSTimeAccepted,TRANSClosure,PAADMPAPMIDR,CTLOCDesc,BTRTransferRemark,BEDTPDesc,TRANSReadyForBill,CTPCPDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindTransactionListFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindTransactionListExecute ]
{
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// ab 18.03.04 - 41053 - called from TAfterUpd,TAfterIns to update PAAdmTransaction2 fields for bitmap indexes
ClassMethod UpdateBitmapIndex(TransID As %String = "")
{
}

/// Invoked after websysSave - can be used to provide extra websysSave functionality while keeping the default websysSave behaviour.
ClassMethod websysAfterSave(compref As %String, ByRef id As %String, new As %Boolean) As %Boolean
{
}

/// This returns the trans rows that represent the admission
ClassMethod GetAdmissionTrans(EpisodeID As %Library.String)
{
}

/// ;ab 23.04.02 - admitting unit is first transfers location
ClassMethod GetAdmittingLocAndDoc(EpisodeID As %Library.String) As %Library.String
{
}

/// ab 1.03.04
/// if booking/move - hosp from ward
/// if transfer - hosp from loc
/// w ##class(web.PAAdmTransaction).GetTransactionHospital("469||1")
ClassMethod GetTransactionHospital(TransID As %String = "") As %String
{
	Q ""
}

/// KM 18-Sep-2002: This program gets ALL Booked details called from (amongst other places) epr.CTIconAssocation.FPGatheringData().
ClassMethod GetArrayDetails(EpisodeID As %Library.String, PARAMS As %Library.String, ByRef ARY As %Library.String)
{
}

/// KM 9-May-2002: This method is called from the component items for 
/// ward and bed on components PAAdm.Edit and PAAdm.EditEmergency
/// If this Episode is a Pre-Admission then return the FIRST booked 
/// Ward/Bed, otherwise return the Ward/Bed Occupying information.
/// ab 28.04.05 - obj is now ignored, we get all details from globals
ClassMethod GetBed(ByRef obj As %String, element As %String, id As %String = "") As %String
{
	if element="ward" {
		i $IsObject(obj), $IsObject(obj.PAADMCurrentWardDR) q obj.PAADMCurrentWardDR.WARDDesc
	}
	quit ""
}

/// ab 11.08.03 - called from "bedtype" field on PAAdm.Edit
ClassMethod GetLastMoveBooking(EpisodeID As %String) As %String
{
}

/// KM 18-Sep-2002: This program gets all the open ward/bed booking details for an episode.
/// It is called from PAAdmTransaction.GetArrayDetails()
ClassMethod GetBookingTransactions(EpisodeID As %Library.String, PARAMS As %Library.String, ByRef ARY As %Library.String)
{
}

/// KM 18-Sep-2002: Now called from PAAdmTransaction.GetArrayDetails()
ClassMethod GetCurrentAdmDoc(EpisodeID As %Library.String) As %Library.String
{
}

/// KM 18-Sep-2002: Called from workflows containing component 
/// PAAdm.EditBedAdmission.  This component should only be called
/// from Emergency where, as up to this date they can only make one
/// inpatient booking.
ClassMethod GetFirstActiveBooking(EpisodeID As %Library.String, PARAMS As %Library.String) As %Library.String
{
}

/// ab 23.09.02 - called from PAAdmTransaction.EditList (seen by doc edit)
ClassMethod GetFirstAdmDoc(EpisodeID As %Library.String) As %Library.String
{
}

ClassMethod GetFirstBookedMove(trans As %Library.String, preadm As %Library.String = "")
{
	q ""
}

/// PAAdmTransaction.Transfer.List-Sent1-ValueGet ,Code1-ValueGet
ClassMethod GetSentCodedDetails(type As %Library.String, id As %Library.String)
{
	if type="Sent" q 0
	if type="Coded" q 0
}

/// 	KM 20-Sep-2002: Created to replace this method in PACBedAdm
/// BedID: 	The ID of the bed being checked
/// Status: If you only want to check if the bed is occupied then pass in status "T"
/// If you want to check if the bed has an accepted booking then pass in the status "A"
/// If you want to check if the bed has a requested booking then pass in the status "R"
/// EpID: 	If you are checking if bed is free for a particular Episode then pass 
/// in their EpisodeID.  The method will then return that bed is free if it is already
/// occupied or booked by this specific Episode.
ClassMethod IsBedFree(BedID As %Library.String, Status As %Library.String, EpisodeID As %Library.String = "") As %Library.Integer
{
}

/// 	MD 11-03-2003: New method for checking status of a particular bed
/// see IsBedFree
ClassMethod IsBedFreeNew(BedID As %Library.String, Status As %Library.String, EpisodeID As %Library.String = "") As %Library.String
{
}

/// KM 18-Sep-2002: This method created to be called by the "WasInBed" Icons conditional expression.
ClassMethod IsMovedFromBed(EpisodeID As %Library.String) As %Library.Integer
{
	q 1
}

/// ab 24.07.03 - 37120 - used on PAAdmLeave.List
ClassMethod MovedToMentalHealth(EpisodeID As %String = "") As %String
{
}

/// ab 30.10.03 - 40206 - called by icon "WARDBOOKING" conditional expression
ClassMethod IsOtherWardBooking(EpisodeID As %String = "", WardID As %String = "") As %Boolean
{
	q $$$OK
}

/// ab 30.03.04 41721 - called from PAAdm.EditEmergency
ClassMethod MoveMROnDischarge(EpisodeID As %String = "") As %String
{
}

/// CJB 08/11/2002 29954
ClassMethod SetAdmDateTime(EpisodeID As %Library.String, AdmDate As %Library.String, AdmTime As %Library.String, AdmissionTrans As %Library.String)
{
}

/// 	KM 21-Oct-2002: This method is used to change the status of multiple
/// transactions.  It is also called from the delete item on most
/// transaction list components.
/// Log 23764: A transaction is never actually deleted its status is just changed to Rejected, "J".
/// wanghc 2012/08/22
ClassMethod SetStatus(compref As %Library.String, TransIDs As %String = "", Status As %String = "")
{
	q:TransIDs="" ""
	s obj = ##class(User.PAAdmTransaction).%OpenId(TransIDs)
	s statusDr = ##class(web.PACTransfRequestStatus).GetIdFromCodeOrDescription(Status)
	q:statusDr="" ""
	d obj.TRANSStatusDRSetObjectId(statusDr)
	d obj.%Save()
	q ""
}

ClassMethod SetBillingStatus(compref As %Library.String, TransID As %String = "", ReadyB As %String = "", TWard As %String = "")
{
}

ClassMethod TestTransType(EpisodeID As %Library.String, TransID As %Library.String, Loc As %Library.String, CareProv As %Library.String, Ward As %Library.String, Room As %Library.String, Bed As %Library.String, TempLoc As %Library.String, TempLocDeclared As %Library.String, ParentWard As %Library.String = "", ParentWardDec As %Library.String = "") As %Library.Date
{
}

ClassMethod setDischarge(compid As %Library.String = "", EpisodeID As %Library.String = "", PARAMS As %Library.String = "")
{
}

ClassMethod setPAAdm(EpisodeID As %Library.String, TransType As %Library.String, PARAMS As %Library.String)
{
}

ClassMethod setStartDateTime(EpisodeID As %Library.String, TransID As %Library.String = "", TransType As %Library.String, MainCP As %Library.String, TransStartDate As %Library.Date, TransStartTime As %Library.Time, TransEndDate As %Library.Date, TransEndTime As %Library.Time, nowTimeInSecs As %Library.Integer, ByRef validDates As %Library.String, FutureConfBooking As %Library.String = "") As %Library.String
{
}

ClassMethod setWLSecondaryUnits(EpisodeID As %Library.String, wlid As %Library.String, PARAMS As %Library.String)
{
}

/// Invoked before websysSave - can be used to cancel the save.<br>
ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
	s bedId=$g(%request.Data("BedID",1))
	s EpisodeID=$g(%request.Data("EpisodeID",1))
	S TRANSStartDate = $g(%request.Data("TRANSStartDate",1))
	s TRANSStartTime = $g(%request.Data("TRANSStartTime",1))
	Set TRANSStartDate = ##class(websys.Conversions).DateHtmlToLogical(TRANSStartDate)
	Set TRANSStartTime = ##class(websys.Conversions).TimeHtmlToLogical(TRANSStartTime)
	S compid = $e($p(compref,"i"),2,9999)
	if (bedId'="") && (EpisodeID>0){
		Set WardId = + bedId
		Set BedSubId = $p(bedId,"||",2)
		SEt BedTypeDr = $p(^PAWARD(WardId,"BED",BedSubId),"^",2)
		Set BedType = $p(^PAC("BEDTP",BedTypeDr),"^",1)
		Set RoomId = $p(^PAWARD(WardId,"BED",BedSubId),"^",3)
		Set SexId =  $p(^PAPER(+^PAADM(EpisodeID),"ALL"),"^",7)
		Set differentSexFlag = 0
		; 房间不能住异性
		//if (RoomId>0)&&(BedType'="MATERNALBABY") {
		if (RoomId>0)&&(##class(Nur.NIS.Service.Base.Bed).ifBabyBed(BedType)'="Y") {
			Set DifferentSexPatients = $p(^PAROOM(RoomId),"^",4)
			;Set ^Wanghc("SexRes",compid,"RoomId",RoomId)=DifferentSexPatients_","_SexId_","_WardId_"||"_BedSubId
			Set tmpWardId=""
			For {
				Set tmpWardId = $o(^PAWARD("BED_Room_DR",RoomId,tmpWardId))
				Quit:tmpWardId=""
				Quit:(differentSexFlag=1)
				Set tmpBedId=""
			    for {
				 	 Set tmpBedId = $o(^PAWARD("BED_Room_DR",RoomId,tmpWardId,tmpBedId))
				 	 Quit:tmpBedId=""
				 	 Continue:'$d(^PAWARD(tmpWardId,"BED",tmpBedId))
				 	 SEt tmpBedTypeDr = $p(^PAWARD(tmpWardId,"BED",tmpBedId),"^",2)
				 	 Set tmpBedType = $p(^PAC("BEDTP",tmpBedTypeDr),"^",1)
				 	 //Continue:"MATERNALBABY"=tmpBedType
				 	 continue:##class(Nur.NIS.Service.Base.Bed).ifBabyBed(tmpBedType)="Y"
				 	 Set tmpBedRcFlag = $p(^PAWARD(WardId,"BED",BedSubId),"^",4)
				 	 Continue:"N"=tmpBedRcFlag
				 	
				 	 Quit:(differentSexFlag=1)
				 	 SEt bedAdmId = $O(^PAWARDA(tmpWardId,"BED",tmpBedId,"ADM",""),-1)
				 	 if (bedAdmId>0){
				 	 	Set paadm = $p(^PAWARDA(tmpWardId,"BED",tmpBedId,"ADM",bedAdmId),"^",1)
				 	 	if (paadm>0){
				 	 		Set tmpSexId = $p(^PAPER(+^PAADM(paadm),"ALL"),"^",7)
				 	 		if (tmpSexId'="")&&(SexId'="")&&(SexId'=tmpSexId) Set differentSexFlag=1
				 	 		Quit:(differentSexFlag=1)
				 	 	}
				 	 }
			    }
			}
			If (DifferentSexPatients="N"),differentSexFlag=1{
				d msg.AddItem("E",$g(t("SexRestrict2"),""),"",compid,"TRANSBedDR")
				Quit 0
			}
			If (DifferentSexPatients="W"),differentSexFlag=1{
				d msg.AddItem("E",$g(t("SexRestrict2"),""),"",compid,"TRANSBedDR")
			}
		}
	}
	
	If (TRANSStartDate>0)&&(EpisodeID>0){
		Set PAAdmDate = $p(^PAADM(EpisodeID),"^",6)
		Set PAAdmTime = $p(^PAADM(EpisodeID),"^",7)
		i ##class(websys.Conversions).IsValidMethodName("web.DHCDischargeHistory","GetAdminDateTime"){
			Set rtn = ##class(web.DHCDischargeHistory).GetAdminDateTime(EpisodeID)
			;没有入院日期不覆盖
			if rtn>0{
				Set PAAdmDate = $p(rtn,"^",1), PAAdmTime = $p(rtn,"^",2)
			}
		}
		If (TRANSStartDate<PAAdmDate){
			d msg.AddItem("E",$g(t("DateTimeInvalid"),"StartDate Invalidate"),"",compid,"TRANSStartDate")
			Quit 0
		}
		if (TRANSStartDate=PAAdmDate)&&(TRANSStartTime<PAAdmTime) {
			d msg.AddItem("E",$g(t("DateTimeInvalid"),"StartDate Invalidate"),"",compid,"TRANSStartTime")
			Quit 0
		}
	}else{
		d msg.AddItem("E",$g(t("DateTimeInvalid"),"StartDate Invalidate"),"",compid,"TRANSStartDate")
		Quit 0 
	}
	if (bedId'=""){
		//如果床上有人不允许继续处理,防止并发操作
		&SQL(Select ADM_PAADM_DR into :CurEpisodeID From SQLUser.PAC_BedAdm Where ADM_ParRef=:bedId)
		if $g(CurEpisodeID)>0 {
			d msg.AddItem("E","床上已有病人!","",compid,"TRANSBedDR")
			Quit 0
		}
		//
		s unavail=##class(web.PACBedStatusChange).IsUnavailBedStatus(bedId,.statDesc)
		if (unavail>0){
			d msg.AddItem("E","床不可用! "_statDesc,"",compid,"TRANSBedDR")
			Quit 0
		}
	}
	Q $$$OK
}

/// ab 17.12.02 - called from emergency seen by clinician, changes seen by fields on paadm
ClassMethod websysDeleteSeenByDoc(compref As %Library.String, id As %Library.String = "")
{
}

ClassMethod websysSave(compref As %Library.String, id As %Library.String, component As %Library.String)
{
	n EpisodeID,userId,bedId,StDate,StTime,wardId,roomId,bedSub,bedTypeId,curDate,curTime
	n editPreTrans,reqstId,transtypId,bookedStatus,curWardId,mBabyBedtpId,ADMParRef,locId,cptSub,caretypId,caretypCode,ctacuId
	n RoomID,ROOMQuery

	s EpisodeID=$g(%request.Data("EpisodeID",1))
	q:EpisodeID="" ""
	s userId=$g(%request.Data("UserID",1))
	q:userId="" ""
	S compid = $e($p(compref,"i"),1,9999)
	i '..websysBeforeSave(compref,.id) q 0
    s transType=$g(%request.Data("TransType",1))
    //若是新建转科记录%request.Data("BedID",1)和%request.Data("WardRoomDR",1)为空
	s bedId=$g(%request.Data("BedID",1))
	s StDate=$g(%request.Data("TRANSStartDate",1))
	s StTime=$g(%request.Data("TRANSStartTime",1))
	s WardRoomDR=$g(%request.Data("WardRoomDR",1))
	i StDate'="" s StDate=##class(websys.Conversions).DateHtmlToLogical(StDate) ;$zdh(StDate,4)
	i StTime'="" s StTime=$zth(StTime,2)
	// 彭俊福
	if (transType="MT")!(transType="T") d
	.s StDate=+$h
	.s StTime=$p($h,",",2)

	&SQL(Select PAADM_VisitStatus into :PAADMVisitStatus From SQLUser.PA_Adm Where PAADM_RowId=:EpisodeID)
	if SQLCODE=0 && PAADMVisitStatus="D" {
		d msg.AddItem("E",$g(t("NOTAVAILABLE"),""),"",compid,"NOTAVAILABLE")
		Quit 0
	}

    i component="PAAdmTransaction.Edit" 
 	{
		;s CurWardID=$g(%request.Data("CurWardID",1))	;wanghc 20130312 登录二单元,把一单元的病人放到一单元等待区时,病人跑到二单元等待区了
	 	s CurWardID = ##class(web.PACWard).GetIdFromCodeOrDescription($g(%request.Data("TRANSWardDR",1))) ;wanghc 20130204 医生登录时
	 	s wardId=CurWardID
 	}
 	s Hosid=%session.Data("LOGON.HOSPID")
    i bedId'=""
    {
   		s Transid=$o(^Nur.DHCBedApplyChangeI("TransBed"," "_Hosid,bedId," "_EpisodeID,+$h,""),-1)
   		i Transid'=""
   		{
    		s ret=$listget($g(^Nur.DHCBedApplyChangeD(Transid)),10)
    		i ret="E"
    		{
	    		s ret="F"  //置完成状态换床申请
	    		&SQL(update Nur.DHCBedApplyChange (AuditStatus) Values (:ret) Where ID=:Transid)
	    	}
   		}
    }
 	s LocationID =$g(%request.Data("LocationID",1))
	s CTPCPCode=$g(%request.Data("CTPCPCode",1))
	
	s CTPCPID=$S(CTPCPCode'="":$O(^CTPCP(0,"Code",$ZCVT(CTPCPCode,"U"),0)),1:"")

	s TRANSMain=##class(websys.Conversions).YesNoHtmlToLogical($g(%request.Data("TRANSMain",1)))

    i bedId'="" s wardId=+bedId
    ;q:$g(wardId)="" ""
    
    s roomId="",bedSub="",bedTypeId=""
    if WardRoomDR'="" {		;wanghc 当转到等待区时, 转移表TRANS_Room_DR为空 20130422
		s roomId=$p($g(^PAWARD(+WardRoomDR,"ROOM",$p(WardRoomDR,"||",2))),"^",1)
		i roomId'="" s ROOMQuery=$P(^PAROOM(roomId),"^",5)
		if ROOMQuery="BA" s roomId="" 
	}
	i bedId'="" s bedSub=$p(bedId,"||",2)
	i bedSub'="" {
		s roomId=$p(^PAWARD(+bedId,"BED",bedSub),"^",3)
		s bedTypeId=$p(^PAWARD(+bedId,"BED",bedSub),"^",2)
	}
	s curDate=+$h,curTime=$p($h,",",2)
	s curTime=$E($zt(curTime,1),1,5)
	s curTime=$zth(curTime,2)
	i StDate="" s StDate=curDate
	i StTime="" s StTime=curTime
	
	//从等待区到床上
	i component="PAAdmTransaction.Edit" 
 	{
		//如果床上有人不允许继续处理,防止并发操作
		s compid=$e($p(compref,"i",1),2,999)
		s bedId=$g(%request.Data("BedID",1))
		i bedId'="" k ^DHCBedManager("AppBed",bedId)
		&SQL(Select ADM_PAADM_DR into :CurEpisodeID From SQLUser.PAC_BedAdm Where ADM_ParRef=:bedId)
		if SQLCODE=0 {
			d msg.AddItem("E",$g(t("XLOCKEXTRA"),""),"",compid,"XLOCKEXTRA")
			Quit 0
		}
		s CurBed=$p($g(^PAADM(EpisodeID)),"^",73)
    	i CurBed'="" s CurBedCode=$p($g(^PAWARD(+CurBed,"BED",$p(CurBed,"||",2))),"^",1)
    	e  s CurBedCode=""
    	
    	i bedId'="" s tbedCode=$p($g(^PAWARD(+bedId,"BED",$p(bedId,"||",2))),"^",1)
    	e  s tbedCode=""
		Tstart
		s TransInfo=##Class(Nur.DHCNurTransAudit).TransNewLoc(EpisodeID,userId,CTPCPID,LocationID)
		if TransInfo=0
		{
			Tc
		}
		else
		{
			Trollback
		}
		
		s editPreTrans="Y"   //床位图 换床
		s reqstId=$o(^PAC("REQST",0,"Code","T",""))
		s transtypId=$o(^PAC("TRANSTYP",0,"Code","M",""))
		s preTransSub="",transSub=0
		f  s preTransSub=$o(^PAADM(EpisodeID,"TRANS",preTransSub),-1) q:(preTransSub="")!(transSub>0)  d
		.i $p(^PAADM(EpisodeID,"TRANS",preTransSub),"^",21)=transtypId s transSub=preTransSub
		.i $p(^PAADM(EpisodeID,"TRANS",preTransSub),"^",21)="",$p(^PAADM(EpisodeID,"TRANS",preTransSub),"^",9)'="" s transSub=preTransSub
	    i transSub>0,editPreTrans="Y" {
			s preTransId=EpisodeID_"||"_transSub
			s preReqstId=$o(^PAC("REQST",0,"Code","D",""))
			&sql(update SQLUser.PA_AdmTransaction set TRANS_Status_DR=:preReqstId,TRANS_EndDate=:StDate,TRANS_EndTime=:StTime where TRANS_RowId=:preTransId)
	    }
		If (##class(websys.Conversions).IsValidMethodName("web.DHCDischargeHistory","SaveAdminDateTime")) {
			Set firstToBed=1,tmpTransSub=""
			f  s tmpTransSub=$o(^PAADM(EpisodeID,"TRANS",tmpTransSub)) q:(tmpTransSub="")||(firstToBed=0)  d
			.i +$p($g(^PAADM(EpisodeID,"TRANS",tmpTransSub)),"^",8)>0 s firstToBed=0
			if ((firstToBed=1)&&(bedId'="")){
				//第一次分床时记录下时间
				Set PAAdmCurrLoc = $p($g(^PAADM(EpisodeID)),"^",4)
				Set adminDateTimeRtn = ##class(web.DHCDischargeHistory).SaveAdminDateTime(EpisodeID,curDate,curTime,2,PAAdmCurrLoc,wardId)	
				;Set ^Wanghc("tra",2)=adminDateTimeRtn_","_EpisodeID_","_curDate_","_curTime_","_2_","_PAAdmCurrLoc_","_wardId
				//清除一站式虚床标记
				s IPBook=$o(^DHCDocIPBK(0,"EpisodeIDTo",EpisodeID,""))
				i IPBook'="" d
				.s visulBed=$p(^DHCDocIPBK(IPBook),"^",37)
    			.i visulBed'="" s Cancel=##Class(Nur.DHCNurAppointExecBed).ChangeStatus(visulBed,"N")
			}
			s TranInBedFlag=##Class(web.DHCADMQTREC).GetAdmTransLocBed(EpisodeID)
			i TranInBedFlag=0
			{
				s tansLocTypDr=""
				s QtRecTypDr=0 f  s QtRecTypDr=$O(^DHCQTRECTYP("typ",QtRecTypDr)) q:((QtRecTypDr="")!(tansLocTypDr'=""))  d
				.s typeCODE=$p(^DHCQTRECTYP("typ",QtRecTypDr),"^",3)
				.q:typeCODE'="trans"
				.s typeDesc=$p(^DHCQTRECTYP("typ",QtRecTypDr),"^",2)
				.i typeDesc["转" s tansLocTypDr=QtRecTypDr
				s:tansLocTypDr'="" QtRet=##Class(web.DHCADMQTREC).QtInsert(EpisodeID,"","",tansLocTypDr,userId)
			}
		}	
		&sql(insert into SQLUser.PA_AdmTransaction (TRANS_ParRef,TRANS_StartDate,TRANS_StartTime,
					TRANS_Ward_DR,TRANS_Status_DR,TRANS_UpdateDate,TRANS_UpdateTime,TRANS_UpdateUser_DR,
					TRANS_TransType_DR,TRANS_Room_DR,TRANS_Bed_DR,TRANS_BedType_DR)  
			Values (:EpisodeID,:StDate,:StTime,:wardId,:reqstId,:curDate,:curTime,:userId,:transtypId,:roomId,:bedId,:bedTypeId))
		i SQLCODE  q 0  //插入转病区信息出错
		s transId=$g(%ROWID)
		q:transId="" ""
	
		s bookedStatus="O"
		s curWardId=""
		s TransOccupy="N"        //床位图换床 转科占床 N
		f  s curWardId=$o(^PAWARDA(0,"ADM",EpisodeID,curWardId)) q:(curWardId="")!(TransOccupy="Y")  d
		.;q:(curWardId=TransOccupyWardId)&(wardId'=TransOccupyWardId)&(TransOccupyWardId'="") //转科至非占床的病区时,不取消转科占床
		.//床位图换床  暂时注释掉
		.s curBedSub=$o(^PAWARDA(0,"ADM",EpisodeID,+curWardId,""))
		.//s mBabyBedtpId=$o(^PAC("BEDTP",0,"BEDTP_Code","MATERNALBABY",""))
		.s bedtpId=$p(^PAWARD(+curWardId,"BED",+curBedSub),"^",2)
		.s ADMParRef=curWardId_"||"_curBedSub
		.&sql(delete from SQLUser.PAC_BedAdm where ADM_ParRef=:ADMParRef)
		.q:SQLCODE
		.//q:mBabyBedtpId=""
		.//i mBabyBedtpId=bedtpId s $p(^PAWARD(curWardId,"BED",curBedSub),"^",4)="N"
		.i ##class(Nur.NIS.Service.Base.Bed).ifBabyBedByBedTypeId(bedtpId)="Y" d
		..s $p(^PAWARD(curWardId,"BED",curBedSub),"^",4)="N"

		;删除在等待区的记录
		;此索引只在WADM_Room_DR为空时才生成,详见Index定义 add by zhouzq 2011.11.08
		&sql(delete from SQLUser.PAC_WardAdm where WADM_PAADM_DR=:EpisodeID)
		/*
		i $o(^PAWARDA(0,"WADM",EpisodeID,""))'="" { 
			&sql(delete from SQLUser.PAC_WardAdm where WADM_PAADM_DR=:EpisodeID)
		}
		*/
		if bedSub'="" 
		{
			
			&sql(insert into SQLUser.PAC_BedAdm (ADM_ParRef,ADM_PAADM_DR,ADM_BookedStatus,ADM_Trans_DR)
				Values (:bedId,:EpisodeID,:bookedStatus,:transId))
				
			
			i SQLCODE q 0   ///"插入床位信息出错!"
		}else{
			;增加对WardRoomDR字段的更新,add by zhouzq 2011.11.8
			if WardRoomDR'="" {
				s RoomID=$p($g(^PAWARD(+WardRoomDR,"ROOM",$p(WardRoomDR,"||",2))),"^",1)
				i RoomID'="" s ROOMQuery=$P(^PAROOM(RoomID),"^",5)
				if ROOMQuery="BA" s RoomID="" 
			}
		
			&sql(insert into SQLUser.PAC_WardAdm (WADM_ParRef,WADM_PAADM_DR,WADM_BookedStatus,WADM_Trans_DR,WADM_Room_DR)
				Values (:wardId,:EpisodeID,:bookedStatus,:transId,:RoomID))
			i SQLCODE q 0  ///"插入等待区信息出错!"
		}
		&sql(update SQLUser.PA_Adm (PAADM_CurrentBed_DR,PAADM_CurrentWard_Dr,PAADM_CurrentRoom_DR) Values (:bedId,:wardId,:roomId) Where PAADM_RowId=:EpisodeID)
		i SQLCODE q 0    ////"更新就诊病区、房间及床位信息出错!"
	
		s locId=$p(^PAWARD(wardId),"^",5)
		q:locId="" ""
		s cptSub=$o(^CTLOC(locId,"CPT",0))
		q:cptSub="" 0
		s caretypId=$p($g(^CTLOC(locId,"CPT",cptSub)),"^")
		q:caretypId="" 0
		s caretypCode=$p(^PAC("CARETYP",caretypId),"^")
		q:caretypCode="" 0
		s ctacuId=$o(^CT("ACU",0,"Code",caretypCode,""))
		q:ctacuId="" 0
		&sql(update SQLUser.PA_Adm (PAADM_Priority_DR) Values (:ctacuId) Where PAADM_RowId=:EpisodeID)
	    i SQLCODE q 0  ///"修改病人等级出错!"
	    s EnsInterface=##class(web.DHCENS.EnsHISService).DHCHisInterface("SENDTRANSOUTBEDINFO",EpisodeID_"^"_$zd(curDate,3)_" "_$zt(curTime,2)_"^"_CurBedCode_"^"_tbedCode)
		q 0
		
	}else{  
        //非组件PAAdmTransaction.Edit 转科或指定医生 
        
		if (LocationID="")&&($g(%request.Data("TRANSCTLOCDR",1))'="")
	    {    
	       s locDesc=$$ALPHAUP^SSUTIL4(%request.Data("TRANSCTLOCDR",1))
		   s LocationID=$o(^CTLOC(0,"Desc",locDesc,""))
	    }
	    

	    s wardId=$g(wardId)
	    if (wardId="")&&($g(%request.Data("TRANSWardDR",1))'="")
	    {  
	       s wardDesc=$$ALPHAUP^SSUTIL4(%request.Data("TRANSWardDR",1))
		   s wardId=$o(^PAWARD(0,"WARD_Desc",wardDesc,""))
	    }

	    //同科不同病区转移时,没有选择科室时的处理 2013-2-27 wanghc
	    if (wardId'="") && (LocationID=""){
		    ;廊坊管道局就是一个病人二个科室,取的关联科室不正确,取病人所在科室 20140508
		    Set LocationID = $p(^PAADM(EpisodeID),"^",4)		    
		}
	    
	    s CTPCPID=$g(CTPCPID)
	    if (CTPCPID="")&&($g(%request.Data("TRANSCTCPDR",1))'="")
	    {  
	       s careDesc=$$ALPHAUP^SSUTIL4(%request.Data("TRANSCTCPDR",1))
	       s CTPCPID=$o(^CTPCP(0,"Decs",careDesc,""))
	    }
	    
	    If transType="MT" {
		    Set PatCurrentDepID = $p(^PAADM(EpisodeID),"^",4)		    
		    If PatCurrentDepID'=""{
			    If (LocationID="")||(PatCurrentDepID=LocationID) {
			    	Set transType="M" 			;没有选择科室或转到病人所在科室
			    	
			    	//通过转科界面转到当前科室床位也要插入入院日期时间
			    	If (##class(websys.Conversions).IsValidMethodName("web.DHCDischargeHistory","SaveAdminDateTime")) {
						Set firstToBed=1,tmpTransSub=""
						f  s tmpTransSub=$o(^PAADM(EpisodeID,"TRANS",tmpTransSub)) q:(tmpTransSub="")||(firstToBed=0)  d
						.i +$p($g(^PAADM(EpisodeID,"TRANS",tmpTransSub)),"^",8)>0 s firstToBed=0
						if (firstToBed=1)&&(bedId'=""){
							//第一次分床时记录下时间
							Set adminDateTimeRtn = ##class(web.DHCDischargeHistory).SaveAdminDateTime(EpisodeID,curDate,curTime,2,LocationID,wardId)	

						}
					}
			    }
		    }
		}
		//***********************************************************************
		//根据转移类型判读是否更新床位房间信息 PAAdmTransaction.Movement.List 转科
		s ^ncefytemp("transloctmp")="MT"
		if transType="MT"
		{
			//转科不选病区无论是否在系统配置护士站里设置都直接退出不更新
	       	q:wardId="" ""
	       	Q:LocationID="" ""
	       	s curWardIdN=$p($g(^PAADM(EpisodeID)),"^",70) 
	       	s curctlocIdN=$p(^PAADM(EpisodeID),"^",4) 
	       	i (curWardIdN'=wardId)
	       	{
		       	//i curctlocIdN=LocationID s transloctmp=""
		       	//e  s transloctmp=LocationID
		       	
		       	s transloctmp=LocationID
		       	Ts
		       	s TransAudit=##Class(Nur.DHCNurTransAudit).insertData(EpisodeID,curDate,curTime,transloctmp,wardId,userId,curctlocIdN,curWardIdN)     	
		       	
		       	i TransAudit=0 tc
		       	e  tro
		    }
		    q:curWardIdN'=wardId ""
			//新建转科记录 transaction表两条记录一条显示在指定医生里
			if $g(%request.Data("ID",1))=""
			{
			   ;新建转移记录时%request.Data("WardRoomDR",1)会为空,直接取前面的roomId
			   ;s roomId=$g(%request.Data("WardRoomDR",1))			  
			   s reqstId=$o(^PAC("REQST",0,"Code","T",""))
			    s editPreTrans="Y"   //床位图 换床
				s reqstId=$o(^PAC("REQST",0,"Code","T",""))
				s transtypId=$o(^PAC("TRANSTYP",0,"Code","M",""))
				s preTransSub="",transSub=0
				f  {
					s preTransSub=$o(^PAADM(EpisodeID,"TRANS",preTransSub),-1) 
					q:(preTransSub="")!(transSub>0)
					i $p(^PAADM(EpisodeID,"TRANS",preTransSub),"^",21)=transtypId s transSub=preTransSub
					i $p(^PAADM(EpisodeID,"TRANS",preTransSub),"^",21)="",$p(^PAADM(EpisodeID,"TRANS",preTransSub),"^",9)'="" s transSub=preTransSub
				}
			    i transSub>0,editPreTrans="Y" {
					s preTransId=EpisodeID_"||"_transSub
					s preReqstId=$o(^PAC("REQST",0,"Code","D",""))
					&sql(update SQLUser.PA_AdmTransaction set TRANS_Status_DR=:preReqstId,TRANS_EndDate=:StDate,TRANS_EndTime=:StTime where TRANS_RowId=:preTransId)
			    }
			    ;Set ^Wanghc("tra",3)=transSub
				If (##class(websys.Conversions).IsValidMethodName("web.DHCDischargeHistory","SaveAdminDateTime")) {
					Set firstToBed=1,tmpTransSub=""
					f  s tmpTransSub=$o(^PAADM(EpisodeID,"TRANS",tmpTransSub)) q:(tmpTransSub="")||(firstToBed=0)  d
					.i +$p($g(^PAADM(EpisodeID,"TRANS",tmpTransSub)),"^",8)>0 s firstToBed=0
					if (firstToBed=1)&&(bedId'=""){
						//第一次分床时记录下时间
						//Set PAAdmCurrLoc = $p($g(^PAADM(EpisodeID)),"^",4)
						Set adminDateTimeRtn = ##class(web.DHCDischargeHistory).SaveAdminDateTime(EpisodeID,curDate,curTime,2,LocationID,wardId)	
						;Set ^Wanghc("tra",4)=adminDateTimeRtn_","_EpisodeID_","_curDate_","_curTime_","_2_","_PAAdmCurrLoc_","_wardId
					}
				}
			  s transtypId=$o(^PAC("TRANSTYP",0,"Code","T",""))		
			  &sql(insert into SQLUser.PA_AdmTransaction 
			  (TRANS_ParRef,TRANS_StartDate,TRANS_StartTime,
			  TRANS_Status_DR,TRANS_UpdateDate,TRANS_UpdateTime,TRANS_UpdateUser_DR,
			  TRANS_TransType_DR,TRANS_CTLOC_DR,TRANS_CTCP_DR,
			  TRANS_Room_DR,TRANS_Bed_DR,TRANS_BedType_DR,TRANS_Main)  
			  Values (:EpisodeID,:StDate,:StTime,:reqstId,:curDate,:curTime,:userId,
				:transtypId,:LocationID,:CTPCPID,:roomId,:bedId,:bedTypeId,:TRANSMain))			
			  i SQLCODE q 
			  s transtypId=$o(^PAC("TRANSTYP",0,"Code","M",""))
			  &sql(insert into SQLUser.PA_AdmTransaction 
			  (TRANS_ParRef,TRANS_StartDate,TRANS_StartTime,
			  TRANS_Status_DR,TRANS_UpdateDate,TRANS_UpdateTime,TRANS_UpdateUser_DR,
			  TRANS_TransType_DR,TRANS_Ward_DR,TRANS_Room_DR,TRANS_Bed_DR,TRANS_BedType_DR,TRANS_Main)  
			  Values (:EpisodeID,:StDate,:StTime,:reqstId,:curDate,:curTime,:userId,:transtypId,:wardId,:roomId,:bedId,:bedTypeId,:TRANSMain))
			  i (SQLCODE = 0) {
               s transId=$g(%ROWID)
              }
              else
              {i SQLCODE q }
			  s bookedStatus="O"
			  s curWardId=""
			  s TransOccupy="N"        //床位图换床 转科占床 N
			  f  s curWardId=$o(^PAWARDA(0,"ADM",EpisodeID,curWardId)) q:(curWardId="")!(TransOccupy="Y")  d
			  .;q:(curWardId=TransOccupyWardId)&(wardId'=TransOccupyWardId)&(TransOccupyWardId'="") //转科至非占床的病区时,不取消转科占床
			  .//床位图换床  暂时注释掉
			  .s curBedSub=$o(^PAWARDA(0,"ADM",EpisodeID,+curWardId,""))
			  .//s mBabyBedtpId=$o(^PAC("BEDTP",0,"BEDTP_Code","MATERNALBABY",""))
			  .s bedtpId=$p(^PAWARD(+curWardId,"BED",+curBedSub),"^",2)
			  .s ADMParRef=curWardId_"||"_curBedSub
			  .&sql(delete from SQLUser.PAC_BedAdm where ADM_ParRef=:ADMParRef)
			  .q:SQLCODE
			  .//q:mBabyBedtpId=""
			  .//i mBabyBedtpId=bedtpId s $p(^PAWARD(curWardId,"BED",curBedSub),"^",4)="N"
			  .i ##class(Nur.NIS.Service.Base.Bed).ifBabyBedByBedTypeId(bedtpId)="Y" d
			  ..s $p(^PAWARD(curWardId,"BED",curBedSub),"^",4)="N"
			  ;删除在等待区的记录
			  ;此索引只在WADM_Room_DR为空时才生成,详见Index定义 add by zhouzq 2011.11.08
			  &sql(delete from SQLUser.PAC_WardAdm where WADM_PAADM_DR=:EpisodeID)
	           //转科时选了床则插入
				if $g(%request.Data("TRANSBedDR",1))'="" 
				{
					&sql(insert into SQLUser.PAC_BedAdm (ADM_ParRef,ADM_PAADM_DR,ADM_BookedStatus,ADM_Trans_DR)
						Values (:bedId,:EpisodeID,:bookedStatus,:transId))
					i SQLCODE q 0
				}
				else //没选床位只插入等待区
				{
					;增加对WardRoomDR字段的更新,add by zhouzq 2011.11.8
					if WardRoomDR'="" {
						s RoomID=$p($g(^PAWARD(+WardRoomDR,"ROOM",$p(WardRoomDR,"||",2))),"^",1)
						i RoomID'="" s ROOMQuery=$P(^PAROOM(RoomID),"^",5)
						if ROOMQuery="BA" s RoomID="" 
					}
		
					&sql(insert into SQLUser.PAC_WardAdm (WADM_ParRef,WADM_PAADM_DR,WADM_BookedStatus,WADM_Trans_DR,WADM_Room_DR)
						Values (:wardId,:EpisodeID,:bookedStatus,:transId,:RoomID))
					i SQLCODE q 0  ////"插入等待区信息出错!"
				}
				 
			}
			
			
			&sql(update SQLUser.PA_Adm 
			(PAADM_DepCode_DR,PAADM_AdmDocCodeDR,PAADM_CurrentBed_DR,PAADM_CurrentWard_Dr,PAADM_CurrentRoom_DR) 
	 		Values (:LocationID,:CTPCPID,:bedId,:wardId,:roomId) Where PAADM_RowId=:EpisodeID)
	 		i SQLCODE q 0   ///"更新就诊病区、房间及床位信息出错!"
	 		d ##Class(web.DHCMainNurse).ClearMainNurseDoc(EpisodeID,"","","","")
		}

		//根据转移类型判读是否更新床位房间信息 PAAdmTransaction.Movement.List 转科
		if transType="MTOld"
		{
			
			//转科不选病区无论是否在系统配置护士站里设置都直接退出不更新
	       	q:wardId="" ""
	       	Q:LocationID="" ""
			//新建转科记录 transaction表两条记录一条显示在指定医生里
			if $g(%request.Data("ID",1))=""
			{
			   ;新建转移记录时%request.Data("WardRoomDR",1)会为空,直接取前面的roomId
			   ;s roomId=$g(%request.Data("WardRoomDR",1))			  
			   s reqstId=$o(^PAC("REQST",0,"Code","T",""))
			    s editPreTrans="Y"   //床位图 换床
				s reqstId=$o(^PAC("REQST",0,"Code","T",""))
				s transtypId=$o(^PAC("TRANSTYP",0,"Code","M",""))
				s preTransSub="",transSub=0
				f  {
					s preTransSub=$o(^PAADM(EpisodeID,"TRANS",preTransSub),-1) 
					q:(preTransSub="")!(transSub>0)
					i $p(^PAADM(EpisodeID,"TRANS",preTransSub),"^",21)=transtypId s transSub=preTransSub
					i $p(^PAADM(EpisodeID,"TRANS",preTransSub),"^",21)="",$p(^PAADM(EpisodeID,"TRANS",preTransSub),"^",9)'="" s transSub=preTransSub
				}
			    i transSub>0,editPreTrans="Y" {
					s preTransId=EpisodeID_"||"_transSub
					s preReqstId=$o(^PAC("REQST",0,"Code","D",""))
					&sql(update SQLUser.PA_AdmTransaction set TRANS_Status_DR=:preReqstId,TRANS_EndDate=:StDate,TRANS_EndTime=:StTime where TRANS_RowId=:preTransId)
			    }
			    ;Set ^Wanghc("tra",3)=transSub
				If (##class(websys.Conversions).IsValidMethodName("web.DHCDischargeHistory","SaveAdminDateTime")) {
					Set firstToBed=1,tmpTransSub=""
					f  s tmpTransSub=$o(^PAADM(EpisodeID,"TRANS",tmpTransSub)) q:(tmpTransSub="")||(firstToBed=0)  d
					.i +$p($g(^PAADM(EpisodeID,"TRANS",tmpTransSub)),"^",8)>0 s firstToBed=0
					if (firstToBed=1)&&(bedId'=""){
						//第一次分床时记录下时间
						//Set PAAdmCurrLoc = $p($g(^PAADM(EpisodeID)),"^",4)
						Set adminDateTimeRtn = ##class(web.DHCDischargeHistory).SaveAdminDateTime(EpisodeID,curDate,curTime,2,LocationID,wardId)	
						;Set ^Wanghc("tra",4)=adminDateTimeRtn_","_EpisodeID_","_curDate_","_curTime_","_2_","_PAAdmCurrLoc_","_wardId
					}
				}
			  s transtypId=$o(^PAC("TRANSTYP",0,"Code","T",""))		
			  &sql(insert into SQLUser.PA_AdmTransaction 
			  (TRANS_ParRef,TRANS_StartDate,TRANS_StartTime,
			  TRANS_Status_DR,TRANS_UpdateDate,TRANS_UpdateTime,TRANS_UpdateUser_DR,
			  TRANS_TransType_DR,TRANS_CTLOC_DR,TRANS_CTCP_DR,
			  TRANS_Room_DR,TRANS_Bed_DR,TRANS_BedType_DR,TRANS_Main)  
			  Values (:EpisodeID,:StDate,:StTime,:reqstId,:curDate,:curTime,:userId,
				:transtypId,:LocationID,:CTPCPID,:roomId,:bedId,:bedTypeId,:TRANSMain))			
			  i SQLCODE q 
			  s transtypId=$o(^PAC("TRANSTYP",0,"Code","M",""))
			  &sql(insert into SQLUser.PA_AdmTransaction 
			  (TRANS_ParRef,TRANS_StartDate,TRANS_StartTime,
			  TRANS_Status_DR,TRANS_UpdateDate,TRANS_UpdateTime,TRANS_UpdateUser_DR,
			  TRANS_TransType_DR,TRANS_Ward_DR,TRANS_Room_DR,TRANS_Bed_DR,TRANS_BedType_DR,TRANS_Main)  
			  Values (:EpisodeID,:StDate,:StTime,:reqstId,:curDate,:curTime,:userId,:transtypId,:wardId,:roomId,:bedId,:bedTypeId,:TRANSMain))
			  i (SQLCODE = 0) {
               s transId=$g(%ROWID)
              }
              else
              {i SQLCODE q }
			  s bookedStatus="O"
			  s curWardId=""
			  s TransOccupy="N"        //床位图换床 转科占床 N
			  f  s curWardId=$o(^PAWARDA(0,"ADM",EpisodeID,curWardId)) q:(curWardId="")!(TransOccupy="Y")  d
			  .;q:(curWardId=TransOccupyWardId)&(wardId'=TransOccupyWardId)&(TransOccupyWardId'="") //转科至非占床的病区时,不取消转科占床
			  .//床位图换床  暂时注释掉
			  .s curBedSub=$o(^PAWARDA(0,"ADM",EpisodeID,+curWardId,""))
			  .//s mBabyBedtpId=$o(^PAC("BEDTP",0,"BEDTP_Code","MATERNALBABY",""))
			  .s bedtpId=$p(^PAWARD(+curWardId,"BED",+curBedSub),"^",2)
			  .s ADMParRef=curWardId_"||"_curBedSub
			  .&sql(delete from SQLUser.PAC_BedAdm where ADM_ParRef=:ADMParRef)
			  .q:SQLCODE
			  .//q:mBabyBedtpId=""
			  .//i mBabyBedtpId=bedtpId s $p(^PAWARD(curWardId,"BED",curBedSub),"^",4)="N"
			  .i ##class(Nur.NIS.Service.Base.Bed).ifBabyBedByBedTypeId(bedtpId)="Y" d
			  ..s $p(^PAWARD(curWardId,"BED",curBedSub),"^",4)="N"
			  ;删除在等待区的记录
			  ;此索引只在WADM_Room_DR为空时才生成,详见Index定义 add by zhouzq 2011.11.08
			  &sql(delete from SQLUser.PAC_WardAdm where WADM_PAADM_DR=:EpisodeID)
	           //转科时选了床则插入
				if $g(%request.Data("TRANSBedDR",1))'="" 
				{
					&sql(insert into SQLUser.PAC_BedAdm (ADM_ParRef,ADM_PAADM_DR,ADM_BookedStatus,ADM_Trans_DR)
						Values (:bedId,:EpisodeID,:bookedStatus,:transId))
					i SQLCODE q 0
				}
				else //没选床位只插入等待区
				{
					;增加对WardRoomDR字段的更新,add by zhouzq 2011.11.8
					if WardRoomDR'="" {
						s RoomID=$p($g(^PAWARD(+WardRoomDR,"ROOM",$p(WardRoomDR,"||",2))),"^",1)
						i RoomID'="" s ROOMQuery=$P(^PAROOM(RoomID),"^",5)
						if ROOMQuery="BA" s RoomID="" 
					}
		
					&sql(insert into SQLUser.PAC_WardAdm (WADM_ParRef,WADM_PAADM_DR,WADM_BookedStatus,WADM_Trans_DR,WADM_Room_DR)
						Values (:wardId,:EpisodeID,:bookedStatus,:transId,:RoomID))
					i SQLCODE q 0  ////"插入等待区信息出错!"
				}
				 
			}
			
			
			&sql(update SQLUser.PA_Adm 
			(PAADM_DepCode_DR,PAADM_AdmDocCodeDR,PAADM_CurrentBed_DR,PAADM_CurrentWard_Dr,PAADM_CurrentRoom_DR) 
	 		Values (:LocationID,:CTPCPID,:bedId,:wardId,:roomId) Where PAADM_RowId=:EpisodeID)
	 		i SQLCODE q 0   ///"更新就诊病区、房间及床位信息出错!"
	 		d ##Class(web.DHCMainNurse).ClearMainNurseDoc(EpisodeID,"","","","")
		}
		// 指定医生 PAAdmTransaction.Transfer.List  
		if transType="T"
		{
			q:CTPCPID="" "医生不能为空"
			s reqstId=$o(^PAC("REQST",0,"Code","T",""))
		    s transtypId=$o(^PAC("TRANSTYP",0,"Code","T",""))	
		    s editPreTrans="Y"
		    s preTransSub="",transSub=0
				f  s preTransSub=$o(^PAADM(EpisodeID,"TRANS",preTransSub),-1) q:(preTransSub="")!(transSub>0)  d
				.i $p(^PAADM(EpisodeID,"TRANS",preTransSub),"^",21)=transtypId s transSub=preTransSub
				.;$p(^PAADM(EpisodeID,"TRANS",preTransSub),"^",9)中 9->6 wanghc 20130224 结束转移科室记录,而不是结束转移病区记录
				.i $p(^PAADM(EpisodeID,"TRANS",preTransSub),"^",21)="",$p(^PAADM(EpisodeID,"TRANS",preTransSub),"^",6)'="" s transSub=preTransSub
			    i transSub>0,editPreTrans="Y" {
					s preTransId=EpisodeID_"||"_transSub
					s preReqstId=$o(^PAC("REQST",0,"Code","D",""))
					&sql(update SQLUser.PA_AdmTransaction set TRANS_Status_DR=:preReqstId,TRANS_EndDate=:StDate,TRANS_EndTime=:StTime where TRANS_RowId=:preTransId)
			}	
		    &sql(insert into SQLUser.PA_AdmTransaction 
			(TRANS_ParRef,TRANS_StartDate,TRANS_StartTime,
			 TRANS_Status_DR,TRANS_UpdateDate,TRANS_UpdateTime,TRANS_UpdateUser_DR,
			TRANS_TransType_DR,TRANS_CTLOC_DR,TRANS_CTCP_DR,
			TRANS_Room_DR,TRANS_Bed_DR,TRANS_BedType_DR,TRANS_Main)  
			Values (:EpisodeID,:StDate,:StTime,:reqstId,:curDate,:curTime,:userId,
				:transtypId,:LocationID,:CTPCPID,:roomId,:bedId,:bedTypeId,:TRANSMain))	
			i SQLCODE q
			//不更新病区房间和床位和科室
			&sql(update SQLUser.PA_Adm (PAADM_AdmDocCodeDR)
	 		Values (:CTPCPID) Where PAADM_RowId=:EpisodeID)
	 		i SQLCODE q 0   ///"指定医生出错!"
		}
		if ((transType="")||(transType="M")){
			//转病区不选病区直接退出不更新
	       	q:wardId="" ""
	       	
	       	s curWardIdN=$p($g(^PAADM(EpisodeID)),"^",70) 
	       	s curctlocIdN=$p(^PAADM(EpisodeID),"^",4) 
	       	i (curWardIdN'=wardId)
	       	{
		       	;i curctlocIdN=LocationID s transloctmp=""
		       	;e  s transloctmp=LocationID
		       	s transloctmp=LocationID
		       	Ts
		       	s TransAudit=##Class(Nur.DHCNurTransAudit).insertData(EpisodeID,curDate,curTime,transloctmp,wardId,userId,curctlocIdN,curWardIdN)     	
		       	
		       	i TransAudit=0 tc
		       	e  tro
		    }
		    q:curWardIdN'=wardId ""
		    
			if $g(%request.Data("ID",1))=""	{

			  	s roomId=$g(%request.Data("WardRoomDR",1))
			  
			    s editPreTrans="Y"   //床位图 换床
				s reqstId=$o(^PAC("REQST",0,"Code","T",""))
				s transtypId=$o(^PAC("TRANSTYP",0,"Code","M",""))
				s preTransSub="",transSub=0
				f  s preTransSub=$o(^PAADM(EpisodeID,"TRANS",preTransSub),-1) q:(preTransSub="")!(transSub>0)  d
				.i $p(^PAADM(EpisodeID,"TRANS",preTransSub),"^",21)=transtypId s transSub=preTransSub
				.i $p(^PAADM(EpisodeID,"TRANS",preTransSub),"^",21)="",$p(^PAADM(EpisodeID,"TRANS",preTransSub),"^",9)'="" s transSub=preTransSub
			    i transSub>0,editPreTrans="Y" {
					s preTransId=EpisodeID_"||"_transSub
					s preReqstId=$o(^PAC("REQST",0,"Code","D",""))
					&sql(update SQLUser.PA_AdmTransaction set TRANS_Status_DR=:preReqstId,TRANS_EndDate=:StDate,TRANS_EndTime=:StTime where TRANS_RowId=:preTransId)
			    }
			  	&sql(insert into SQLUser.PA_AdmTransaction 
			  		(TRANS_ParRef,TRANS_StartDate,TRANS_StartTime,
			  		TRANS_Status_DR,TRANS_UpdateDate,TRANS_UpdateTime,TRANS_UpdateUser_DR,
			  		TRANS_TransType_DR,TRANS_Ward_DR,TRANS_Room_DR,TRANS_Bed_DR,TRANS_BedType_DR,TRANS_Main)  
			  	Values (:EpisodeID,:StDate,:StTime,:reqstId,:curDate,:curTime,:userId,:transtypId,:wardId,:roomId,:bedId,:bedTypeId,:TRANSMain))
			  	i (SQLCODE = 0) {
               		s transId=$g(%ROWID)
              	} else {
	              	i SQLCODE q
	            }
			  	s bookedStatus="O"
			  	s curWardId="" f  {
				  	s curWardId=$o(^PAWARDA(0,"ADM",EpisodeID,curWardId)) 
				  	q:(curWardId="")
			  		s curBedSub=$o(^PAWARDA(0,"ADM",EpisodeID,+curWardId,""))
			  		//s mBabyBedtpId=$o(^PAC("BEDTP",0,"BEDTP_Code","MATERNALBABY",""))
			  		s bedtpId=$p(^PAWARD(+curWardId,"BED",+curBedSub),"^",2)
			  		s ADMParRef=curWardId_"||"_curBedSub
			  		&sql(delete from SQLUser.PAC_BedAdm where ADM_ParRef=:ADMParRef)
			  		continue:SQLCODE
			  		//continue:mBabyBedtpId=""
			  		//i mBabyBedtpId=bedtpId s $p(^PAWARD(curWardId,"BED",curBedSub),"^",4)="N"
			  		i ##class(Nur.NIS.Service.Base.Bed).ifBabyBedByBedTypeId(bedtpId)="Y"{
				  		s $p(^PAWARD(curWardId,"BED",curBedSub),"^",4)="N"
				  	}
			  	}
			  	
			  	;删除在等待区的记录
			  	;此索引只在WADM_Room_DR为空时才生成,详见Index定义 add by zhouzq 2011.11.08
			  	&sql(delete from SQLUser.PAC_WardAdm where WADM_PAADM_DR=:EpisodeID)
	           	//转科时选了床则插入
				if $g(%request.Data("TRANSBedDR",1))'="" 
				{
					&sql(insert into SQLUser.PAC_BedAdm (ADM_ParRef,ADM_PAADM_DR,ADM_BookedStatus,ADM_Trans_DR)
						Values (:bedId,:EpisodeID,:bookedStatus,:transId))
					i SQLCODE q 0  ////"插入床位信息出错!"
				}
				else //没选床位只插入等待区
				{
					;增加对WardRoomDR字段的更新,add by zhouzq 2011.11.8
					if WardRoomDR'="" {
						s RoomID=$p($g(^PAWARD(+WardRoomDR,"ROOM",$p(WardRoomDR,"||",2))),"^",1)
						i RoomID'="" s ROOMQuery=$P(^PAROOM(RoomID),"^",5)
						if ROOMQuery="BA" s RoomID="" 
					}
		
					&sql(insert into SQLUser.PAC_WardAdm (WADM_ParRef,WADM_PAADM_DR,WADM_BookedStatus,WADM_Trans_DR,WADM_Room_DR)
						Values (:wardId,:EpisodeID,:bookedStatus,:transId,:RoomID))
					i SQLCODE q 0  ////"插入等待区信息出错!"
				}
			}
			
			&sql(update SQLUser.PA_Adm 
						(PAADM_CurrentBed_DR,PAADM_CurrentWard_Dr,PAADM_CurrentRoom_DR) 
	 			Values (:bedId,:wardId,:roomId) 
	 			Where PAADM_RowId=:EpisodeID)
	 		i SQLCODE q 0 ////"更新就诊病区、房间及床位信息出错!"
			If (##class(websys.Conversions).IsValidMethodName("web.DHCDischargeHistory","SaveAdminDateTime")) {
					s adminDateTime = ##class(web.DHCDischargeHistory).GetAdminDateTime(EpisodeID)
					if (adminDateTime="^")&&(bedId'=""){
						//第一次分床时记录下时间
						//Set PAAdmCurrLoc = $p($g(^PAADM(EpisodeID)),"^",4)
						Set adminDateTimeRtn = ##class(web.DHCDischargeHistory).SaveAdminDateTime(EpisodeID,curDate,curTime,2,LocationID,wardId)	
						;Set ^Wanghc("tra",4)=adminDateTimeRtn_","_EpisodeID_","_curDate_","_curTime_","_2_","_LocationID_","_wardId
					}
			}
			s retUpdateMainDoc = ##class(web.DHCMainNurse).UpdateDoc(EpisodeID,CTPCPID,LocationID,userId)
		}
	}
	set TemporaryLoc = $G(%request.Data("TemporaryLoc",1))
	if TemporaryLoc'="" {
		Set TemporaryLocId = ##class(web.CTLoc).GetIdFromCodeOrDescription(TemporaryLoc)
		&sql(update SQLUser.PA_Adm (PAADM_TempLoc_DR) values (:TemporaryLocId) Where PAADM_RowId=:EpisodeID)
	}
}

/// 	/*
/// 		Called from both PAAdmTransaction.EditBooking (inpatient bookings)
/// 		and PAAdmTransaction.EditBookingEM (emergency bookings to inpatient)
/// 	*/
ClassMethod websysSaveBooking(compref As %Library.String, id As %Library.String)
{
}

ClassMethod websysSaveFromWL(compref As %Library.String, id As %Library.String, PARAMS As %Library.String)
{
}

/// ; ab 8.05.03 - moved from websysSave because method was getting too big
ClassMethod websysSaveValidate()
{
}

Query FindEpisodesInBA(WardID As %Library.String, BookingDueDate As %String) As %Library.Query(CONTAINID = 2, ROWSPEC = "ID,index,Status,outlier")
{
}

Query FindEpisodesInMPR(WardID As %Library.String, RoomID As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "ID,index,Status,RoomID")
{
}

Query FindEpisodesInRoom(locID As %Library.String, qryType As %Library.String) As %Library.Query(CONTAINID = 2, ROWSPEC = "Ecount,ID,TempLoc")
{
}

/// Returns the RowIDs for the transfers containing a change of location, in descending (Date/Time) order
Query FindLocationsByID(EpisodeID As %Library.String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,Location,StartDate,StartTime,EndDate,EndTime")
{
SELECT TRANS_RowId,TRANS_CTLOC_DR,TRANS_StartDate,
TRANS_StartTime,TRANS_EndDate,TRANS_EndTime
FROM SQLUser.PA_AdmTransaction
WHERE (TRANS_ParRef = :EpisodeID) 
AND (TRANS_CTLOC_DR IS NOT NULL) 
ORDER BY TRANS_StartDate DESC, TRANS_StartTime DESC
}

/// Returns the RowIDs for the moves in descending (Date/Time) order
Query FindMovesByID(EpisodeID As %Library.String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,Room,Bed,StartDate,StartTime,EndDate,EndTime,Status,WardID")
{
SELECT TRANS_RowId,TRANS_Room_DR->ROOM_Desc,
TRANS_Bed_DR->BED_Code,TRANS_StartDate,
TRANS_StartTime,TRANS_EndDate,TRANS_EndTime,
TRANS_Status_DR->REQST_Code,
TRANS_Ward_DR
FROM SQLUser.PA_AdmTransaction
WHERE (TRANS_ParRef = :EpisodeID) 
AND (TRANS_CTLOC_DR IS NULL) 
AND (TRANS_CTCP_DR IS NULL)
AND (TRANS_Status_DR->REQST_Code <> 'J')
ORDER BY TRANS_StartDate DESC, TRANS_StartTime DESC
}

/// Used to find out if anyone has been moved to a specific bed before a discharge can be reversed
Query FindMovesToBed(Bed As %Library.String, datefrom As %Library.Date, timefrom As %Library.Time, dateto As %Library.Date, timeto As %Library.Time) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,EpisodeID")
{
SELECT TRANS_RowId,TRANS_ParRef
FROM SQLUser.PA_AdmTransaction
WHERE (TRANS_Bed_DR = :Bed) 
AND ((TRANS_StartDate > :datefrom) OR ((TRANS_StartDate = :datefrom) AND  (TRANS_StartTime > :timefrom)))
AND ((TRANS_StartDate < :dateto) OR ((TRANS_StartDate = :dateto) AND  (TRANS_StartTime < :timeto)))
}

Query FindNewFollowingMove(EpisodeID As %Library.String, Date As %Library.String, Time As %Library.String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID")
{
SELECT TRANS_RowId
FROM SQLUser.PA_AdmTransaction
WHERE (TRANS_ParRef = :EpisodeID) 
AND (TRANS_CTLOC_DR IS NULL) 
AND (TRANS_CTCP_DR IS NULL) 
AND ((TRANS_StartDate > :Date) OR ((TRANS_StartDate = :Date) AND  (TRANS_StartTime > :Time)))
ORDER BY TRANS_StartDate ASC, TRANS_StartTime ASC
}

Query FindNewFollowingTransfer(EpisodeID As %Library.String, Date As %Library.String, Time As %Library.String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID")
{
SELECT TRANS_RowId
FROM SQLUser.PA_AdmTransaction
WHERE (TRANS_ParRef = :EpisodeID) AND (TRANS_Room_DR IS NULL) AND (TRANS_Bed_DR IS NULL) AND ((TRANS_StartDate > :Date) OR ((TRANS_StartDate = :Date) AND (TRANS_StartTime > :Time)))
ORDER BY TRANS_StartDate ASC, TRANS_StartTime ASC
}

Query FindNewPreviousMove(EpisodeID As %Library.String, Date As %Library.String, Time As %Library.String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID")
{
SELECT TRANS_RowId
FROM SQLUser.PA_AdmTransaction
WHERE (TRANS_ParRef = :EpisodeID) 
AND (TRANS_CTLOC_DR IS NULL) 
AND (TRANS_CTCP_DR IS NULL) 
AND ((TRANS_StartDate < :Date) OR ((TRANS_StartDate = :Date) 
AND (TRANS_StartTime < :Time)))
ORDER BY TRANS_StartDate DESC, TRANS_StartTime DESC
}

Query FindNewPreviousTransfer(EpisodeID As %Library.String, Date As %Library.String, Time As %Library.String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID")
{
SELECT TRANS_RowId
FROM SQLUser.PA_AdmTransaction
WHERE   (TRANS_ParRef = :EpisodeID) AND (TRANS_Ward_DR IS NULL) AND (TRANS_Room_DR IS NULL) AND (TRANS_Bed_DR IS NULL)AND ((TRANS_StartDate < :Date) OR ((TRANS_StartDate = :Date) AND (TRANS_StartTime < :Time)))
ORDER BY TRANS_StartDate DESC, TRANS_StartTime DESC
}

/// This is a quiry to find all the transfers with blank end dates and times
Query FindOpenTransfersForID(EpisodeID As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "ID:%Library.String")
{
SELECT TRANS_RowId
FROM SQLUser.PA_AdmTransaction
WHERE (TRANS_ParRef = :EpisodeID) AND (TRANS_Ward_DR IS NULL) AND (TRANS_Room_DR IS NULL) AND (TRANS_Bed_DR IS NULL) AND (TRANS_EndDate IS NULL) AND (TRANS_EndTime IS NULL)
}

/// Returns the RowIDs for theTransfersinvolving the main care provider in descending (Date/Time) order
Query FindTransOfMainCareProvByID(EpisodeID As %Library.String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,Room,Bed,StartDate,StartTime,EndDate,EndTime,Status")
{
SELECT
     TRANS_RowId,TRANS_Room_DR->ROOM_Desc,
     TRANS_Bed_DR->BED_Code,TRANS_StartDate,
     TRANS_StartTime,TRANS_EndDate,TRANS_EndTime,
     TRANS_Status_DR
FROM SQLUser.PA_AdmTransaction
WHERE (TRANS_ParRef = :EpisodeID) 
AND (TRANS_CTCP_DR IS NOT NULL)
AND (TRANS_Main = 'Y')
AND 	(TRANS_Status_DR->REQST_Code <> 'J')
ORDER BY TRANS_StartDate DESC, TRANS_StartTime DESC
}

Query FindTransactionList(EpisodeID As %Library.String, TransType As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "TRANS_RowId,SSUSR_Name,WARD_Desc,ROOM_Desc,ROOMT_Desc,BED_Code,TRANS_ParRef,TRANS_EndDate,TRANS_EndTime,TRANS_StartDate,TRANS_StartTime,BTR_Desc,REQST_Desc,HOSP_Desc,TRANS_UpdateDate,TRANS_UpdateTime,TRANSTYP_Code,TRANSTYP_Desc,TRANS_DateAccepted,TRANS_TimeAccepted,TRANS_Closure,PAADM_PAPMI_DR,CTLOC_Desc,BTRTransferRemark,BEDTPDesc,TRANSReadyForBill,CTPCPDesc")
{
}

/// ab - modified for 46334, only called from getBookingTransactions?
Query FindTransactionType(EpisodeID As %Library.String, TransType As %Library.String, Status As %Library.String, ClosedStatus As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "ID,BedID,BedCode,RoomID,RoomDesc,WardID,WardCode,WardDesc,StartDate,StartTime,EndDate,EndTime,StatusCode,StatusDesc,BedSortOrder,TransTypeCode")
{
SELECT TRANS_RowId,
TRANS_Bed_DR,TRANS_Bed_DR->BED_Code,
TRANS_Room_DR,TRANS_Room_DR->ROOM_Desc,
TRANS_Ward_DR,TRANS_Ward_DR->WARD_Code,TRANS_Ward_DR->WARD_Desc,
TRANS_StartDate,TRANS_StartTime,
TRANS_EndDate,TRANS_EndTime,
TRANS_Status_DR->REQST_Code,
TRANS_Status_DR->REQST_Desc,
TRANS_Bed_DR->BED_SortingOrder,TRANS_TransType_DR->TRANSTYP_Code
FROM SQLUser.PA_AdmTransaction
WHERE (TRANS_ParRef = :EpisodeID) 
AND (TRANS_Status_DR->REQST_Code <> 'J')
AND (TRANS_Status_DR->REQST_Code = :Status OR :Status IS NULL)
AND (TRANS_Status_DR->REQST_Code <> :ClosedStatus)
ORDER BY TRANS_StartDate DESC, TRANS_StartTime DESC
}

/// Returns the RowIDs for theTransfers in descending (Date/Time) order
Query FindTransfersByID(EpisodeID As %Library.String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,Main,StatusCode,CareProvID,DeptID")
{
SELECT TRANS_RowId, TRANS_Main, 
 TRANS_Status_DR->REQST_Code,
 TRANS_CTCP_DR, TRANS_CTLOC_DR
FROM SQLUser.PA_AdmTransaction
WHERE (TRANS_ParRef = :EpisodeID) 
 AND (TRANS_Ward_DR IS NULL) 
 AND (TRANS_Room_DR IS NULL) 
 AND (TRANS_Bed_DR IS NULL)
ORDER BY TRANS_StartDate DESC, TRANS_StartTime DESC
}

/// ab 29.08.03 - 37906
ClassMethod ValidateCodeTableDates(compid As %String, id As %String) As %String
{
}

/// md 01.10.03 - 39518
ClassMethod SetICUCCUFields(EpisodeID As %String = "") As %Boolean
{
}

/// JW: used in PAADM to limit the careprovider search to selected location and location type
Query LookUpByPartialCareProv(docDesc As %String, locDesc As %String, conFlag As %String, date As %Date, userFlag As %String, Hospitals As %String, LocIDs As %String, admtype As %String, locType As %String, time As %String, intType As %String, HOSPDesc As %String, flags As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "RESDesc:%String,code:%String,Location:%String,HIDDEN:%String,HIDDEN:%String,Hospital:%String,Responsible Unit:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String")
{
}

/// by wuqk 2011-06-23 未完成，部分条件未判断
/// 仅判断 rescDesc、locDesc、date
ClassMethod LookUpByPartialCareProvExecute(ByRef QHandle As %Library.Binary, rescDesc As %String = "", locDesc As %String = "", conFlag As %String = "", date As %String = "", userFlag As %String = "", Hospitals As %String = "", LocIDs As %String = "", admtype As %String = "", locType As %String = "", prompttime As %String = "", intType As %String = "", HOSPDesc As %String = "", flags As %String = "") As %Library.Status
{
	n repid
	s repid=$I(^CacheTemp)
	s ind=1
	s QHandle=$lb(0,repid,0)
	//s outFlg=0
	//^RB("RES",0,"LocDesc",{RES_CTLOC_DR},$$ALPHAUP({RES_Desc}),{RES_RowId})
	//locDesc ^CTLOC(0,"Desc",$$ALPHAUP({CTLOC_Desc}),{CTLOC_RowID})
	//Condition
	if date'="" s date= ##class(websys.Conversions).DateHtmlToLogical(date) ;$ZDH(date,4)
	if locDesc'=""{
		s locDesc=$zu(28,locDesc,6)
		s ctlocId=$o(^CTLOC(0,"Desc",locDesc,0))
		quit:ctlocId="" $$$OK
		quit:'$d(^RB("RES",0,"LocDesc",ctlocId)) $$$OK
		do BuildByDocDesc
	}else{
		s ctlocId=$o(^RB("RES",0,"LocDesc",0))
		while ctlocId'="" {
			do BuildByDocDesc
			s ctlocId=$o(^RB("RES",0,"LocDesc",ctlocId))
		}
	}
	quit $$$OK
BuildByDocDesc
	Set rescChar = $e(rescDesc,1)
	Set rescChar = $ascii(rescChar)
	;A-Z,a-z  CTPCP_OtherName  拼音查询  wanghc 2015-03-22
	if ((rescChar>64)&&(rescChar<91))||((rescChar>96)&&(rescChar<123)){
		Set tmpRescDesc = $zcvt(rescDesc,"U")
		set resId = $o(^RB("RES",0))
		while (resId'=""){
			 set resId = $o(^RB("RES",resId))
			 set objRBResource = ##class(User.RBResource).%OpenId(resId,0)
			 continue:'$IsObject(objRBResource)
			 Set ReSourceLocDr = objRBResource.RESCTLOCDRGetObjectId()
			 continue:(ctlocId'="")&&(ctlocId'=ReSourceLocDr)
			 set OtherName = objRBResource.RESCTPCPDR.CTPCPOtherName
			 continue:($zcvt($e(OtherName,1,$l(rescDesc)),"U")'=tmpRescDesc)&&(tmpRescDesc'="")
			 do BulidData 
		}
	}else{
		s rescDesc=$zu(28,rescDesc,6)
		s tempDesc=rescDesc
		s:tempDesc="" tempDesc=$o(^RB("RES",0,"LocDesc",ctlocId,tempDesc))
		while (tempDesc'="")&&($e(tempDesc,1,$l(rescDesc))=rescDesc){
			s resId=$o(^RB("RES",0,"LocDesc",ctlocId,tempDesc,0))
			while resId'=""{
				do BulidData
				s resId=$o(^RB("RES",0,"LocDesc",ctlocId,tempDesc,resId))
			}
			s tempDesc=$o(^RB("RES",0,"LocDesc",ctlocId,tempDesc))
		
		}
	}
	quit
BulidData
	set objRBResource=##class(User.RBResource).%OpenId(resId,0)
	quit:'$IsObject(objRBResource)
	;CS程序维护数据截止时间记录在.RESDateTo字段上
	;quit:(date'="")&&(objRBResource.RESDateActiveTo'="")&&(objRBResource.RESDateActiveTo<date)
	quit:(date'="")&&(objRBResource.RESDateActiveFrom'="")&&(objRBResource.RESDateActiveFrom>date)
	quit:(date'="")&&(objRBResource.RESDateTo'="")&&(objRBResource.RESDateTo<date)
	set admright = objRBResource.RESAdmittingRights
	quit:(admright'="Y")
	
	s ctpcpID=$p($G(^RB("RES",resId)),"^",2)
	s activeFlag=$P($G(^CTPCP(ctpcpID,1)),"^",9)
	q:activeFlag'="Y"
	s today=+$h,ssuserID=""
	s ssuserID = $o(^SSU("SSUSR",0,"CTPCP",ctpcpID,""))	
	quit:(ssuserID'="")&(today'="")&&($P(^SSU("SSUSR",ssuserID),"^",96)'="")&&($P(^SSU("SSUSR",ssuserID),"^",96)>today)
	quit:(ssuserID'="")&(today'="")&&($P(^SSU("SSUSR",ssuserID),"^",97)'="")&&($P(^SSU("SSUSR",ssuserID),"^",97)<today)
	
		
	s data=$lb()
	s $li(data,1)=objRBResource.RESDesc
	s $li(data,2)=objRBResource.RESCode
	s $li(data,3)=$s($IsObject(objRBResource.RESCTLOCDR):objRBResource.RESCTLOCDR.CTLOCDesc,1:"")
	s $li(data,4)=objRBResource.%Id()
	s $li(data,5)=$s($IsObject(objRBResource.RESCTLOCDR):objRBResource.RESCTLOCDR.%Id(),1:"")
	s $li(data,9)=$s($IsObject(objRBResource.RESCTPCPDR):objRBResource.RESCTPCPDR.%Id(),1:"")
	//s $li(data,10)=objRBResource.RESCTPCPDR
	s $li(data,11)=$s($IsObject(objRBResource.RESCTPCPDR):objRBResource.RESCTPCPDR.CTPCPCarPrvTpDR.CTCPTDesc,1:"")
	s ^CacheTemp(repid,ind)=data
	s ind=ind+1
	
	q $$$OK
}

ClassMethod LookUpByPartialCareProvFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpByPartialCareProvExecute ]
{
	n repid
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod LookUpByPartialCareProvClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpByPartialCareProvFetch ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// by wuqk 2011-06-23
ClassMethod LookUpBrokerByPartialCareProv(itmjs As %String = "", itmjsex As %String = "", docDesc As %String = "", locDesc As %String = "", conFlag As %String = "", date As %String = "", userFlag As %String = "", Hospitals As %String = "", LocIDs As %String = "", admtype As %String = "", locType As %String = "", prompttime As %String = "", intType As %String = "", HOSPDesc As %String = "", flags As %String = "") As %Library.Boolean
{
	set rs=##Class(%ResultSet).%New("web.RBResource.LookUpByPartialCareProv")
	quit:'$IsObject(rs) 0
	do rs.Execute(docDesc, locDesc, conFlag, date, userFlag, Hospitals, LocIDs, admtype, locType, prompttime, intType, HOSPDesc, flags)
	set cols=rs.GetColumnCount()
	set rows=0
	set retval=""
	while rs.Next() {
		set rows=rows+1
		quit:rows>1
		set firstVal=rs.GetData(1)
		for colIndex=1:1:cols{
			set retval=retval_rs.GetData(colIndex)_"^"
		}
	}
 	d rs.%Close() k rs
 	quit:rows'=1 0
 	set:itmjs'="" fn=itmjs_"('"_firstVal_"');"
 	set:itmjsex'="" fn=fn_itmjsex_"('"_retval_"');"
	&javascript<#(fn)#>
 	quit $$$OK
}

}
