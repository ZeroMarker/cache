Class web.PACBedStatusChange Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 289;

Parameter SQLDATEFROM;

Parameter SQLDATETO = "STAT_DateTo";

Parameter SQLCODE = "STAT_RowId";

Parameter SQLDESCRIPTION = "STAT_RowId";

Parameter SQLROWID = "STAT_RowId";

/// ab 12.06.02 - closes all unoccupied&active beds in a ward or room
ClassMethod CloseBeds(compref As %Library.String, id As %Library.String = "", ward As %Library.String = "", room As %Library.String = "")
{
}

/// 床位图调用 2012.04.24 zhouzq
/// w ##class(web.PACBedStatusChange).IsClosed("27||19",+$h,+$p($h,",",2)))
ClassMethod IsClosed(BedID As %String = "", sdate As %String = {+$h}, stime As %String = {$p($h,",",2)}, inactive As %String = "") As %Library.Boolean
{
	n (BedID,sdate,stime,inactive)
	s sd="",st="",td="", tt=""
	s unavail=0
	Q:BedID="" 0
	s WardID=+BedID,bed=$P(BedID,"||",2)
	s status=$g(^PAWARDA(WardID,"BED",bed))

	s ind=0 for {
		s ind=$O(^PAWARDA(WardID,"BED",bed,"STAT",ind))
		Q:ind=""
		s data=$g(^PAWARDA(WardID,"BED",bed,"STAT",ind))
		s sd=$p(data,"^",1),st=$p(data,"^",2)
		s td=$p(data,"^",5),tt=$p(data,"^",6)
		continue:(sd'="")&&(sd>sdate)
		continue:(sd'="")&&(st'="")&&(sd=sdate)&&(st>stime)
		continue:(td'="")&&(td<sdate)
		continue:(td'="")&&(tt'="")&&(td=sdate)&&(tt<stime)
		s bedStatusDR=$p(data,"^",3)
		s bedStatus=$s(bedStatusDR'="":$p($g(^PAC("BSTAT",bedStatusDR)),"^",1),1:"")
		if bedStatus="U" s unavail=1 Quit
		
	}
	quit unavail
}

/// 床位图调用 2012.04.24 zhouzq
/// w ##class(web.PACBedStatusChange).IsUnavailBedStatus("27||19",.unavailreason)
ClassMethod IsUnavailBedStatus(BedID As %Library.String = "", ByRef reasonunavail As %Library.String) As %Library.Boolean
{
	n (BedID,reasonunavail)
	s ^tempsc("IsUnavailBedStatus")=$lb(BedID,reasonunavail)
	s unavail=0
	Q:BedID="" 0
	q:BedID=0 0
	s sdate=+$H,stime=$P($H,",",2)
	s WardID=+BedID,bed=$P(BedID,"||",2)
	s status=$g(^PAWARDA(WardID,"BED",bed))
	set reasonunavail=""
	s ind=0 for {
		s ind=$O(^PAWARDA(WardID,"BED",bed,"STAT",ind))
		Q:ind=""
		s data=$g(^PAWARDA(WardID,"BED",bed,"STAT",ind))
		; 
		s sd=$p(data,"^",1),st=$p(data,"^",2)
		s td=$p(data,"^",5),tt=$p(data,"^",6)
		; wanghc 预包床 也是 不可用状态
		;Continue:(sd'="")&&(sd>sdate)
		;Continue:(sd'="")&&(st'="")&&(sd=sdate)&&(st>stime)
		Continue:(td'="")&&(td<sdate)
		Continue:(td'="")&&(tt'="")&&(td=sdate)&&(tt<stime)
		set reasonunavailDR=$p(data,"^",7)
		set reasonunavail=$s(reasonunavailDR'="":$p($g(^PAC("RNAV",reasonunavailDR)),"^",2),1:"") 

		s bedStatusDR=$p(data,"^",3)
		s bedStatus=$s(bedStatusDR'="":$p($g(^PAC("BSTAT",bedStatusDR)),"^",1),1:"")
		if bedStatus="U" s unavail=1 Quit
		
	}
	Quit unavail
}

ClassMethod IsUnavailReason(BedID As %Library.String = "") As %Library.String
{
}

ClassMethod ReOpenBeds(compref As %Library.String, id As %Library.String = "", ward As %Library.String = "", room As %Library.String = "")
{
}

ClassMethod ResetEndTimes(id As %Library.String)
{
}

/// set available status of bed
/// called from websyssave
ClassMethod websysAfterSave(compref As %String, ByRef id As %String, new As %Boolean) As %Boolean
{
	q $$$OK
}

/// Invoked before websysSave - can be used to cancel the save.<br>
ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
	q $$$OK
}

}
