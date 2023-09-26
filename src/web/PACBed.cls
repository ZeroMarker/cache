Include Nur.DateFormat

Class web.PACBed Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 986;

Parameter SQLDATEFROM = "BED_DateFrom";

Parameter SQLDATETO = "BED_DateTo";

Parameter SQLCODE = "BED_Code";

Parameter SQLDESCRIPTION = "BED_Code";

Parameter SQLROWID = "BED_RowID";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod ClearFloorplan(WardID As %Library.String, WardDesc As %Library.String)
{
}

ClassMethod ConvertAllFloorplans()
{
}

ClassMethod ConvertFloorplanFromRooms(WardID As %Library.String, WardDesc As %Library.String)
{
}

/// ab 11.10.02
/// new bed broker!
/// (bedcode is unique)
ClassMethod FindAllBInWardResBroker(itmjs As %String = "", itmjsex As %String = "", Ward As %String = "", Arg1 As %String = "", Bed As %String = "", EpisodeID As %String = "", AvailOnly As %String = "", Arg4 As %String = "", Arg5 As %String = "", Room As %String = "", Arg7 As %String = "", AdmType As %String = "", Location As %String = "") As %Library.Boolean
{
}

ClassMethod FindAllBInWardResClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindAllBInWardResFetch ]
{
	n repid
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// SB 30/08/02 (24407): This Lookup was copied from FindAvailBInWarRes. Site wants to see all beds with a status against each one.
/// 
ClassMethod FindAllBInWardResExecute(ByRef QHandle As %Library.Binary, WardDesc As %Library.String, OrigWardID As %Library.String, BedCode As %Library.String, EpisodeID As %Library.String, AvailableBeds As %Library.String, DateFrom As %Library.Date, TimeFrom As %Library.Time, RoomDesc As %Library.String = "a", SortOrder As %String = "", AdmType As %String = "", Location As %String = "") As %Library.Status
{
	n repid
	s repid=$I(^CacheTemp)
	s ind=1
    
    // PACBedDesc,PACWardDesc,PACRoomDesc,BedType,statDesc,HIDDEN,HIDDEN,HIDDEN,HIDDEN,HIDDEN,PACRoomType,HIDDEN,RestrictReason,RestrictDateFrom,RestrictTimeFrom,RestrictDateTo,RestrictTimeTo,HIDDEN,HIDDEN,HIDDEN,HIDDEN,HIDDEN,HIDDEN,HIDDEN
	;所选病区的床位信息, HIDDEN 的位置(不知道),后面那些不知道什么意思
	//i WardDesc="" s QHandle=$lb(0,repid1,0) q $$$OK
	s:%request.Get("WardID")'="" WardID=%request.Get("WardID") 
	s INBED=$P(WardDesc,"^",2)
	s WardDesc=$P(WardDesc,"^",1)
	s:WardDesc'="" WardID=$o(^PAWARD(0,"WARD_Desc",$$ALPHAUP^SSUTIL4(WardDesc),0))
	i ($g(WardID)=""){
		set WardID=$O(^PAWARD(0))
		while (WardID'="")
		{
			d findbyward(WardID)
			set WardID=$O(^PAWARD(WardID))
		}
	}
	else
	{
		s WardDesc = $p(^PAWARD(WardID),"^",2)
		d findbyward(WardID)
	}
	s QHandle=$lb(0,repid,0)
	q $$$OK
findbyward(WardID)
	s wardLinkLoc=$p($G(^PAWARD(WardID)),"^",5)
	q:wardLinkLoc="" ""
	s locType=$p(^CTLOC(wardLinkLoc),"^",13)
	q:(locType'="EM")&&(AdmType="E") ""
	s PACWardDesc=WardDesc
	s bedsub=0 f  {
		s bedsub=$o(^PAWARD(WardID,"BED",bedsub)) 
		q:bedsub=""
		s (PACBedDesc,PACRoomDesc,BedType,statDesc,PACRoomType,RestrictReason,RestrictDateFrom,RestrictTimeFrom,RestrictDateTo,RestrictTimeTo)=""
		s PACBedDesc=$p(^PAWARD(WardID,"BED",bedsub),"^",1)
		s PACRoomID=$p(^PAWARD(WardID,"BED",bedsub),"^",3)
		s:PACRoomID'="" PACRoomDesc=$p($g(^PAROOM(PACRoomID)),"^",2)
		s BedTypeID=$p(^PAWARD(WardID,"BED",bedsub),"^",2)
		s:BedTypeID'="" BedType=$p($g(^PAC("BEDTP",BedTypeID)),"^",2)
		s RcFlag=$p(^PAWARD(WardID,"BED",bedsub),"^",4)
		continue:(RcFlag="N") ;未激活的床
		s PACRoomTypeID=""
		s:PACRoomID'="" PACRoomTypeID=$p($G(^PAROOM(PACRoomID)),"^",3)	
		s:PACRoomTypeID'="" PACRoomType=$p($G(^PAC("ROOMT",PACRoomTypeID)),"^",2)
	
		s BedID=WardID_"||"_bedsub
		;
		&sql(select BED_Available into :available from SQLUser.PAC_Bed WHERE BED_RowId = :BedID)
		s:EpisodeID'="" statDesc=$s(available="N":"占用",1:"空")
		s statDesc=""
		s unavail=##class(web.PACBedStatusChange).IsUnavailBedStatus(BedID,.statDesc)
		
		;如果床位上已经安排病人,就不需要显示
		s adm=$o(^PAWARDA(+WardID,"BED",+$p(BedID,"||",2),"ADM",0))
		continue:(INBED'="INBED")&&(adm'="")
		continue:(INBED="INBED")&&(adm="")
		;PAC_BedAvailRestriction
		s avrbedsub=0 f {
			s avrbedsub=$o(^PAWARD(WardID,"BED",bedsub,"AVR",avrbedsub)) 
			q:avrbedsub=""
			s RestrictReasonDR=$p(^PAWARD(WardID,"BED",bedsub,"AVR",avrbedsub),"^",3)
			s RestrictReason=$p(^PAC("RNAV",RestrictReasonDR),"^",2)
			s RestrictDateFrom=$$$zd($p(^PAWARD(WardID,"BED",bedsub,"AVR",avrbedsub),"^",1),3)
			s RestrictTimeFrom=$zd($p(^PAWARD(WardID,"BED",bedsub,"AVR",avrbedsub),"^",4),3)
			s RestrictDateTo=$$$zd($p(^PAWARD(WardID,"BED",bedsub,"AVR",avrbedsub),"^",2),3)
			s RestrictTimeTo=$zd($p(^PAWARD(WardID,"BED",bedsub,"AVR",avrbedsub),"^",5),3)
		}
		;PAC_BedStatusChange, availRestriction表中没存记录, 从状态表中取数据,wanghc
		if (statDesc'=""){
			s statubedsub=$o(^PAWARDA(WardID,"BED",bedsub,"STAT",""),-1) 
			if statubedsub>0{
				Set tmpstatdata = $g(^PAWARDA(WardID,"BED",bedsub,"STAT",statubedsub))
				s RestrictReasonDR=$p(tmpstatdata,"^",7)
				s RestrictReason=$p(^PAC("RNAV",RestrictReasonDR),"^",2)
				s RestrictDateFrom=$p(tmpstatdata,"^",1)
				IF (RestrictDateFrom'="") SET RestrictDateFrom=$$$zd(RestrictDateFrom,3)
				s RestrictTimeFrom=$p(tmpstatdata,"^",2)
				IF (RestrictTimeFrom'="") SET RestrictTimeFrom=$zT(RestrictTimeFrom)
				s RestrictDateTo=$p(tmpstatdata,"^",5)
				IF (RestrictDateTo'="") SET RestrictDateTo=$$$zD(RestrictDateTo,3)
				s RestrictTimeTo=$p(tmpstatdata,"^",6)
				IF (RestrictTimeTo'="") SET RestrictTimeTo=$zT(RestrictTimeTo)
			}
			
		}
		d outputrow
	}
	Q
outputrow
	s ^CacheTemp(repid,ind)=$lb(PACBedDesc,PACWardDesc,PACRoomDesc,BedType,statDesc,WardID_"||"_bedsub,WardID,BedTypeID,PACRoomID,PACRoomTypeID,PACRoomType,WardID_"||"_bedsub_"||"_avrbedsub,RestrictReason,RestrictDateFrom,RestrictTimeFrom,RestrictDateTo,RestrictTimeTo)
	s ind=ind+1
	q
}

/// SB 30/08/02 (24407): This Lookup was copied from FindAvailBInWarRes. Site wants to see all beds with a status against each one.
ClassMethod FindAllBInWardResFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindAllBInWardResExecute ]
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

/// Default implementation of LookUp Query.
ClassMethod FindBedClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindBedFetch ]
{
}

/// AB 4.03.02
/// Query used on component PACBed.ListBeds
ClassMethod FindBedExecute(ByRef QHandle As %Library.Binary, Location As %Library.String, BedDept As %Library.String, SimDept As %Library.String, Boarders As %Library.String, BedSex As %Library.String, BedStatus As %Library.String, EDDDateFrom As %Library.Date, EDDDateTo As %Library.Date, BedUnit As %Library.String, CTLOCHospitalDR As %Library.String, TRUSTDesc As %Library.String, HCADesc As %Library.String, Unavailable As %Library.String, BedType As %Library.String, Ward As %Library.String, ExtraParams As %Library.String) As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
}

ClassMethod FindBedFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindBedExecute ]
{
}

ClassMethod LookUpBedsInWardsBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", WardIDs As %String = "", Bed As %String = "", WardCodes As %String = "") As %Library.Boolean
{
}

ClassMethod LookUpBedsInWardsClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpBedsInWardsFetch ]
{
}

ClassMethod LookUpBedsInWardsExecute(ByRef QHandle As %Library.Binary, WardIDs As %String = "", Bed As %String = "", WardCodes As %String = "") As %Library.Status
{
}

ClassMethod LookUpBedsInWardsFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpBedsInWardsExecute ]
{
}

/// lists all the beds associated with a ward and all rooms that have a query type.
/// 
/// Ward is either a description or code of a ward
ClassMethod FindForFloorplanExecute(ByRef QHandle As %Library.Binary, WardID As %Library.String, Ward As %Library.String = "") As %Library.Status
{
}

/// Author - John Hart
/// Purpose - To find available bed in a ward or throughout the hospital
/// Used By - PAADM.BedAdmissionEdit
ClassMethod FindForFloorplanFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindForFloorplanExecute ]
{
}

/// Author - John Hart
/// Purpose - To find available bed in a ward or throughout the hospital
/// Used By - PAADM.BedAdmissionEdit
ClassMethod FindForFloorplanClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindForFloorplanFetch ]
{
}

/// Author - John Hart
/// Purpose - To find the bed ID if given a Bed description and Ward ID
/// Used By - Component: PAAdm.EditBedAdmission
ClassMethod GetIdFromBedAndWard(BedDesc As %String, WardID As %String, RoomID As %String = "") As %String
{
	;web.PAADM.websysSave方法中使用
	s rtn=""
	Q:BedDesc="" rtn
	Q:WardID="" rtn
	s sub="" for  s sub = $O(^PAWARD(WardID,"BED",sub)) q:sub=""  d
	.s Code = $p(^PAWARD(WardID,"BED",sub),"^",1)
	.s:Code=BedDesc rtn=WardID_"||"_sub
	q rtn
}

/// ab 11.10.03 40403
/// used in hidden field BedID in PAAdm.Edit
/// similar to PAAdmTransaction.GetBed
ClassMethod GetBedIDForAdm(EpisodeID As %String = "") As %String
{
}

ClassMethod GetTelExt(bed As %Library.String) As %Library.String
{
}

/// Determines if the bed is currently assigned to a particular department
ClassMethod IsBedInDept(BedID As %Library.String, DepID As %Library.String) As %Library.Boolean
{
}

ClassMethod IsStillFree(BedID As %Library.String) As %Library.Boolean
{
}

ClassMethod websysSavePositions(compref As %Library.String, id As %Library.String)
{
}

/// Author - John Hart
/// Purpose - To find available bed in a ward or throughout the hospital
/// Used By - PAADM.BedAdmissionEdit
/// 
/// Replace by FindBedsInWard until July because we have no sensible way 
/// of determining bed status at Austin until then
Query FindAllBInWardRes(WardDesc As %String, WardID As %String, Bed As %String, EpisodeID As %String, AvailableBeds As %String, DateFrom As %Library.Date, TimeFrom As %Library.Time, Room As %String, SortOrder As %String, AdmType As %String, Location As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "PACBedDesc:%String,PACWardDesc:%String,PACRoomDesc:%String,BedType:%String,statDesc:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,PACRoomType:%String,HIDDEN:%String,RestrictReason:%String,RestrictDateFrom:%String,RestrictTimeFrom:%String,RestrictDateTo:%String,RestrictTimeTo:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String")
{
}

Query LookUpBedsInWards(WardIDs As %String, Bed As %String, WardCodes As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "Bed,Room,Ward,HIDDEN")
{
}

Query FindBed(Location As %Library.String, BedDept As %Library.String, SimDept As %Library.String, Boarders As %Library.String, BedSex As %Library.String, BedStatus As %Library.String, EDDDateFrom As %Library.Date, EDDDateTo As %Library.Date, BedUnit As %Library.String, CTLOCHospitalDR As %Library.String, TRUSTDesc As %Library.String, HCADesc As %Library.String, Unavailable As %Library.String, BedType As %String, Ward As %Library.String, ExtraParams As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "WARDDesc,BEDNo,ROOMNo,BSTAT,PATSEX,EPDEPT,EDD:%Library.Date,PATFirstName,PATLastName,PatientID,Unavail,UnavailReason,Btype,BedID,BBD:%Library.Date,hospital,hcarea,hcregion,episodeid,ReqDate,ReqTime,HiddenVIP")
{
}

/// Purpose - To find available bed in a ward or throughout the hospital
/// Used By - PACBed.FindForFloorplan,PAAdm.DischargeAll()
Query FindBedsInWard(WardID) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,BEDCode,ROOMDesc,BEDPositionLeft,BEDPositionTop,BEDPositionWidth,BEDPositionHeight,BEDRcFlag,BEDIcon,BEDTypeDesc,RoomType,BEDDateFrom,BEDDateTo,BEDSNAP")
{
SELECT BED_RowID, BED_Code, 
 BED_Room_DR->ROOM_Desc, 
 BED_PositionLeft, BED_PositionTop, 
 BED_PositionWidth, BED_PositionHeight, 
 BED_RcFlag, BED_BedType_DR->BEDTP_IconName, 
 BED_BedType_DR->BEDTP_Desc,
 BED_Room_DR->ROOM_RoomType_DR->ROOMT_Desc, BED_DateFrom, BED_DateTo, BED_SNAP
FROM SQLUser.PAC_Bed
WHERE (BED_WARD_ParRef = :WardID)
ORDER	BY BED_SortingOrder ASC
}

Query FindForFloorplan(WardID, Ward) As %Library.Query(CONTAINID = 1, ROWSPEC = "ID,BEDCode,ROOMDesc,WardRoomID,PositionLeft,PositionTop,PositionWidth,PositionHeight,ActiveFlag,QueryType,Rows,UnavailReason,BEDIcon,BEDTypeDesc,Incompletes,RoomType,DateFrom,DateTo,BEDSNAP")
{
}

}
