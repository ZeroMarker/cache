Class EPRservice.RQ.RQActionAppoint Extends %RegisteredObject [ ProcedureBlock ]
{

/// d ##Class(%ResultSet).RunQuery("EPRservice.RQ.RQActionAppoint","GetAppointAdmByDate","2017-03-27","2017-03-27")
Query GetAppointAdmByDate(AStartDate As %String, AEndDate As %String, AAuthLevel As %String = "300") As %Query(ROWSPEC = "EpisodeID:%String,RegNo:%String,PatName:%String,PatGender:%String,AdmDate:%String,DisDate:%String,AdmDept:%String,DisDept:%String,DoctorDesc:%String,MRNo:%String,AppointInfo:%String") [ SqlProc ]
{
}

ClassMethod GetAppointAdmByDateExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String, AAuthLevel As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	set ind=1		
	Set qHandle=$lb(0,repid,0)	
	
	Set:AStartDate["-" AStartDate=$zdh(AStartDate,3)
	Set:AEndDate["-" AEndDate=$zdh(AEndDate,3)
	
	s statusList = "R^F", count = $L(statusList,"^")
	for i = 1:1:count
	{
		s status = $P(statusList,"^",i)
		
		for date = AStartDate:1:AEndDate
		{
			s appointid = ""
			for {
				s appointid = $O(^DHCEPRI.EPRActionAppointI("IdxAppointDt"," "_status,date,appointid))
				quit:(appointid="")
				
				s obj = ##Class(EPRinstance.EPRActionAppoint).%OpenId(appointid)
				continue:(obj = "")
				continue:(obj.EpisodeID = "")
				continue:(obj.AuthLevel < AAuthLevel)
				
				s ^CacheTemp(repid,"ADM",obj.EpisodeID)=obj.EpisodeID
			}
			
		}
	}
	
	s admid = ""
	for {
		s admid = $O(^CacheTemp(repid,"ADM",admid))
		q:(admid="")
		
		s patid = $P($g(^PAADM(admid)),"^",1)
		continue:(patid = "")
		
		//EpisodeID:%String,RegNo:%String,PatName:%String,PatGender:%String,AdmDate:%String,DisDate:%String,AdmDept:%String,DisDept:%String,AppointInfo:%String
		s objPaAdm = $g(^PAADM(+AEpisodeID))
	    q:(objPaAdm = "") 
		s EpisodeID = admid
		s RegNo = $P($g(^PAPER(patid,"PAT",1)),"^",1)
		s MRNo = $p($g(^PAPER(+patid,"PAT",1)),"^",22)
		s PatName = $P($G(^PAPER(patid,"ALL")),"^",1)
		s PatGender = $P($G(^PAPER(patid,"ALL")),"^",7)
		s:(PatGender'="") PatGender = $P($g(^CT("SEX",PatGender)),"^",2)
		s AdmDate = $P($G(^PAADM(admid)),"^",6)
		s:(AdmDate'="") AdmDate = $zd(AdmDate,3)
		s DisDate = $P($G(^PAADM(admid)),"^",17)
		s:(DisDate'="") DisDate = $zd(DisDate,3)
		s AdmDept = ..AdmDept(admid,"")
		s:(AdmDept'="") AdmDept = $p(AdmDept,"^",3)
		s DisDept = $P($g(^PAADM(admid)),"^",4)
		s:(DisDept'="") DisDept = $p($g(^CTLOC(DisDept)),"^",2)
		s AdmDocID = $p(objPaAdm,"^",9)
	    s:(AdmDocID = "") AdmDocID = "-1"
	    s DoctorDesc = $s(AdmDocID '= -1:$p($g(^CTPCP((+AdmDocID),1)),"^",2),1:"未指定")
		s AppointInfo = ""
		
		s ^CacheTemp(repid,ind) = $lb(EpisodeID,RegNo,PatName,PatGender,AdmDate,DisDate,AdmDept,DisDept,DoctorDesc,MRNo,AppointInfo)
	    s ind=ind+1
	}
	
	kill ^CacheTemp(repid,"ADM")
	
	quit $$$OK
}

ClassMethod GetAppointAdmByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAppointAdmByDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod GetAppointAdmByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAppointAdmByDateExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		k ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod AdmDept(argAdmId As %String, argHospital As %String = "") As %String
{
	q:(($d(argAdmId)=0)||(argAdmId="")) ""
	s TRANSChildsub="",locDR="",tmplocDR="",bed="",admdept="",DeptDesc="",DeptCode=""
	
	// 遍历转科记录，取入院科室
	f  s TRANSChildsub=$o(^PAADM(argAdmId,"TRANS",TRANSChildsub)) q:(TRANSChildsub="")!(bed'="")  d
	.s bed=$p($g(^PAADM(argAdmId,"TRANS",TRANSChildsub)),"^",8)
	.s tmplocDR=$p($g(^PAADM(argAdmId,"TRANS",TRANSChildsub)),"^",6)
	.if tmplocDR'="" {s locDR=tmplocDR}
		
	if locDR'="" 
	{	
		s DeptCode=$p($g(^CTLOC(locDR)),"^",1)
		s DeptDesc=$p($g(^CTLOC(locDR)),"^",2)
		if $l(DeptDesc,"-")>1 {s DeptDesc=$p($g(DeptDesc),"-",2)}
		s admdept=locDR_"^"_DeptCode_"^"_DeptDesc		
	}
	
	q admdept
}

}
