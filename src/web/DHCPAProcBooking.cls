Import SQLUser

Class web.DHCPAProcBooking Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

Query FindProcBooking(regNo, EpisodeID, BookingDeptId, BookingUserId, startDate, endDate, admType, procbStatusId, cityAreaId, HRReasonId) As %Query(ROWSPEC = "tPROCBStatus:%String,tBookingDept:%String,tBookingUser:%String,tBookingDate:%String,tBookingTime:%String,tUpdateUser:%String,tUpdateDate:%String,tUpdateTime:%String,tProcbRowId:%String,tBookingAdmId:%String,tAdmitAdmId:%String,PatName:%String,PatRegNo:%String,procLnmp:%String,tcityArea:%String,phone:%String,tHRMainReason:%String,tHRSecondReason:%String")
{
}

ClassMethod FindProcBookingExecute(ByRef qHandle As %Binary, regNo = "", EpisodeID = "", BookingDeptId = "", BookingUserId = "", startDate = "", endDate = "", admType = "OEI", procbStatusId = "", cityAreaId = "", HRReasonId = "") As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	i startDate="" s startDate=+$h
	i endDate="" s endDate=+$h 	   
    s preprocId=""
    i regNo'="" d
        .s papmiId=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(regNo),""))
        .q:papmiId=""
        .s admTypes(1)="O",admTypes(2)="E",admTypes(3)="I"
        .f i=1:1:3 d
        	..i admType[admTypes(i) d
            	...s EpisodeID=""
            	...f  s EpisodeID=$o(^PAPERdr(papmiId,"ADM",admTypes(i),EpisodeID),-1) q:EpisodeID=""  d
                	....s admVisitStat=$p($g(^PAADM(EpisodeID)),"^",20)
                	....i (admVisitStat'="A")&(admVisitStat'="D") q
                	....s admDate=$p($g(^PAADM(EpisodeID)),"^",6)
                	....q:admDate<startDate
                	....q:admDate>endDate
                	....s procId=$o(^DHCProc(0,"Adm",EpisodeID,""))
                	....q:procId=""
                	....q:procId=preprocId
                	....s preprocId=procId
                	....s ProcbSub=0
                	....f  s ProcbSub=$o(^DHCProc(0,"BookingDate",admDate,procId,ProcbSub)) q:ProcbSub=""  d
 	 				.....s tPROCBStatusId=$p(^DHCProc(procId,"Booking",ProcbSub),"^",1)
 	 				.....q:(procbStatusId'="")&(tPROCBStatusId'=procbStatusId)
 					.....s tPROCBStatus=$SELECT(tPROCBStatusId="B":"预约",tPROCBStatusId="A":"就诊",tPROCBStatusId="C":"取消",1:"")
 					.....s tBookingAdmId=$p(^DHCProc(procId,"Booking",ProcbSub),"^",2)
 					.....s papmiId=+$g(^PAADM(tBookingAdmId))
 					.....s PatName=$P(^PAPER(papmiId,"ALL"),"^",1)
 					.....s PatRegNo=$P(^PAPER(papmiId,"PAT",1),"^",2)
 					.....s tBookingDeptId=$p(^DHCProc(procId,"Booking",ProcbSub),"^",3)
  					.....q:(BookingDeptId'="")&(BookingDeptId'=tBookingDeptId)
 					.....s tBookingDept=$p($g(^CTLOC(tBookingDeptId)),"^",2)
 					.....s tBookingUserId=$p(^DHCProc(procId,"Booking",ProcbSub),"^",4)
 					.....q:(BookingUserId'="")&(BookingUserId'=tBookingUserId)
 					.....s tBookingUser=""
					.....i tBookingUserId'="" s tBookingUser=$p($g(^SSU("SSUSR",tBookingUserId)),"^",2)
 					.....s tBookingDate=$p(^DHCProc(procId,"Booking",ProcbSub),"^",5)
 					.....i tBookingDate'="" s tBookingDate=$zd(tBookingDate,4)
 					.....s tBookingTime=$p(^DHCProc(procId,"Booking",ProcbSub),"^",6)
 					.....i tBookingTime'="" s tBookingTime=$zt(tBookingTime,2)
 					.....s tAdmitAdmId=$p(^DHCProc(procId,"Booking",ProcbSub),"^",7)
 					.....s tUpdateUserId=$p(^DHCProc(procId,"Booking",ProcbSub),"^",8)
 					.....s tUpdateUser=""
					.....i tUpdateUserId'="" s tUpdateUser=$p(^SSU("SSUSR",tUpdateUserId),"^",2)
 					.....s tUpdateDate=$p(^DHCProc(procId,"Booking",ProcbSub),"^",9)
 					.....i tUpdateDate'="" s tUpdateDate=$zd(tUpdateDate,4)
 					.....s tUpdateTime=$p(^DHCProc(procId,"Booking",ProcbSub),"^",10)
 					.....i tUpdateTime'="" s tUpdateTime=$zt(tUpdateTime,2)
					.....s tProcbRowId=procId_"||"_ProcbSub
					.....;s procId
					.....;s wxl("BookingStatus")=tPROCBStatus
					.....s procLnmp=$p(^DHCProc(procId),"^",8)
	        		.....i procLnmp'="" s procLnmp=$zd(procLnmp,4)
	        		.....s tmpcityAreaId=$p(^DHCProc(procId),"^",14)
	        		.....q:(cityAreaId'="")&(cityAreaId'=tmpcityAreaId)
	        		.....s tcityArea=$p(^CT("CITAREA",+tmpcityAreaId),"^",2)
	        		.....s phone=$p(^DHCProc(procId),"^",15)
	        		.....s HRMainReasonId=$p(^DHCProc(procId),"^",17)
	        		.....s HRSecondReasonId=$p(^DHCProc(procId),"^",18)
	        		.....s tHRMainReason=$p(^DHCProcC("HRReason",+HRMainReasonId),"^",2)
	        		.....s tHRSecondReason=$p(^DHCProcC("HRReason",+HRSecondReasonId),"^",2)
	        		.....q:(HRReasonId'="")&(HRReasonId'=+HRMainReasonId)&(HRReasonId'=+HRSecondReasonId)
					.....d OutputRow
					
    /*i regNo="",EpisodeID'="" d
 	.s tmpprocId=$o(^DHCProc(0,"Adm",EpisodeID,""))
 	.i tmpprocId="" d
 	..s papmiId=+$g(^PAADM(EpisodeID))
 	..q:papmiId=""
 	..s tmpprocId=0
 	..f  s tmpprocId=$o(^DHCProc(0,"PAPMI",papmiId,tmpprocId)) q:tmpprocId=""
 	...q:$p(^DHCProc(tmpProcId),"^",3)'="O"
 	...q:$p($G(^DHCProc(tmpProcId)),"^",10)'="Y"
 	...s preprocId=tmpprocId*/
 	//i BookingDeptId="" s BookingDeptId=%session.Get("LOGON.CTLOCID")
 	//i BookingUserId="" s BookingUserId=%session.Get("LOGON.USERID") 
 	i regNo="" d
 		.f BookingDate=startDate:1:endDate d
			..s procId=0
			..f  s procId=$o(^DHCProc(procId)) q:procId=""  d
			...//q:procId'=preprocId
			...s ProcbSub=0
			...f  s ProcbSub=$o(^DHCProc(0,"BookingDate",BookingDate,procId,ProcbSub)) q:ProcbSub=""  d
 	 		....s tPROCBStatusId=$p(^DHCProc(procId,"Booking",ProcbSub),"^",1)
 	 		....q:(procbStatusId'="")&(tPROCBStatusId'=procbStatusId)
 			....s tPROCBStatus=$SELECT(tPROCBStatusId="B":"预约",tPROCBStatusId="A":"就诊",tPROCBStatusId="C":"取消",1:"")
 			....s tBookingAdmId=$p(^DHCProc(procId,"Booking",ProcbSub),"^",2)
 			....s papmiId=+$g(^PAADM(tBookingAdmId))
 			....s PatName=$P(^PAPER(papmiId,"ALL"),"^",1)
 			....s PatRegNo=$P(^PAPER(papmiId,"PAT",1),"^",2)
 			....s tBookingDeptId=$p(^DHCProc(procId,"Booking",ProcbSub),"^",3)
  			....q:(BookingDeptId'="")&(BookingDeptId'=tBookingDeptId)
 			....s tBookingDept=$p($p($g(^CTLOC(tBookingDeptId)),"^",2),"-",2)
 			....s tBookingUserId=$p(^DHCProc(procId,"Booking",ProcbSub),"^",4)
 			....q:(BookingUserId'="")&(BookingUserId'=tBookingUserId)
 			....s tBookingUser=""
			....i tBookingUserId'="" s tBookingUser=$p($g(^SSU("SSUSR",tBookingUserId)),"^",2)
 			....s tBookingDate=$p(^DHCProc(procId,"Booking",ProcbSub),"^",5)
 			....i tBookingDate'="" s tBookingDate=$zd(tBookingDate,4)
 			....s tBookingTime=$p(^DHCProc(procId,"Booking",ProcbSub),"^",6)
 			....i tBookingTime'="" s tBookingTime=$zt(tBookingTime,2)
 			....s tAdmitAdmId=$p(^DHCProc(procId,"Booking",ProcbSub),"^",7)
 			....s tUpdateUserId=$p(^DHCProc(procId,"Booking",ProcbSub),"^",8)
 			....s tUpdateUser=""
			....i tUpdateUserId'="" s tUpdateUser=$p(^SSU("SSUSR",tUpdateUserId),"^",2)
 			....s tUpdateDate=$p(^DHCProc(procId,"Booking",ProcbSub),"^",9)
 			....i tUpdateDate'="" s tUpdateDate=$zd(tUpdateDate,4)
 			....s tUpdateTime=$p(^DHCProc(procId,"Booking",ProcbSub),"^",10)
 			....i tUpdateTime'="" s tUpdateTime=$zt(tUpdateTime,2)
			....s tProcbRowId=procId_"||"_ProcbSub
			....s wxl("BookingStatus")=tPROCBStatus
			....s procLnmp=$p(^DHCProc(procId),"^",8)
	        ....i procLnmp'="" s procLnmp=$zd(procLnmp,4)
	        ....s tmpcityAreaId=$p(^DHCProc(procId),"^",14)
	        ....q:(cityAreaId'="")&(cityAreaId'=tmpcityAreaId)
	        ....s tcityArea=$p(^CT("CITAREA",+tmpcityAreaId),"^",2)
	        ....s phone=$p(^DHCProc(procId),"^",15)
	        ....s HRMainReasonId=$p(^DHCProc(procId),"^",17)
	        ....s HRSecondReasonId=$p(^DHCProc(procId),"^",18)
	        ....s tHRMainReason=$p(^DHCProcC("HRReason",+HRMainReasonId),"^",2)
	        ....s tHRSecondReason=$p(^DHCProcC("HRReason",+HRSecondReasonId),"^",2)
	        ....q:(HRReasonId'="")&(HRReasonId'=+HRMainReasonId)&(HRReasonId'=+HRSecondReasonId)
			....d OutputRow
				
 	
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
OutputRow
	s Data=$lb(tPROCBStatus,tBookingDept,tBookingUser,tBookingDate,tBookingTime,tUpdateUser,tUpdateDate,tUpdateTime,tProcbRowId,tBookingAdmId,tAdmitAdmId,PatName,PatRegNo,procLnmp,tcityArea,phone,tHRMainReason,tHRSecondReason)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindProcBookingFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindProcBookingExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
	//
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {				// fetch row
 		s Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindProcBookingClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindProcBookingExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

Query FindProcbStatus() As %Query(ROWSPEC = "ID:%String,ProcbStatus:%String")
{
}

ClassMethod FindProcbStatusExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	s Str="B^A^C"
	s Str1="预约^就诊^取消"
	FOR index=1:1:3  {
	s ProcbStatus=$p(Str1,"^",index)
    s ID=$p(Str,"^",index)
 	Do OutputRow
 	}	 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow
	set Data=$lb(ID,ProcbStatus)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindProcbStatusFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindProcbStatusExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
	//
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {				// fetch row
 		s Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindProcbStatusClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindProcbStatusExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

ClassMethod AddBooking(ProcbStatus As %String, EpisodeID As %String, BookingDept, BookingUser As %String, BookingDate As %String, BookingTime As %String)
{
    i EpisodeID="" q -1
    s ProcRowId=""
 	s ProcRowId=$o(^DHCProc(0,"Adm",EpisodeID,""))
 	q:ProcRowId="" -2    
    q:$p(^DHCProc(ProcRowId),"^",3)'="O" "非打开状态"
    q:$p($G(^DHCProc(ProcRowId)),"^",10)'="Y" "非高危妊娠"            	

    q:BookingDate=""
    q:BookingTime=""
    s BookingDate=$zdh(BookingDate,4)
    s BookingTime=$zth(BookingTime,2)
	&SQL(insert into DHC_PA_ProcBooking(PROCB_Parref,PROCB_Status,PROCB_BookingAdm_DR,PROCB_BookingDept_DR,PROCB_BookingUser_DR,PROCB_BookingDate,PROCB_BookingTime) Values(:ProcRowId,:ProcbStatus,:EpisodeID,:BookingDept,:BookingUser,:BookingDate,:BookingTime))
	q SQLCODE
}

ClassMethod UpdateBooking(ProcbRowId As %String, ProcbStatus As %String, EpisodeID As %String, UpdateUser As %String)
{
    i ProcbRowId="" q -1
    s UpdateDate=+$h
    s UpdateTime=$p($h,",",2)
	&SQL(update DHC_PA_ProcBooking set PROCB_Status=:ProcbStatus,PROCB_AdmitAdm_DR=:EpisodeID,PROCB_UpdateUser_DR=:UpdateUser,PROCB_UpdateDate=:UpdateDate,PROCB_UpdateTime=:UpdateTime where PROCB_RowId=:ProcbRowId)
	q SQLCODE
}

Query LookUpBookingUser(desc As %String) As %Query(ROWSPEC = "BookingUser:%String,BookingUserId:%String")
{
}

ClassMethod LookUpBookingUserExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
	s desc=$$ALPHAUP^SSUTIL4(desc)
	s BookingUserId=0
	f  s BookingUserId=$o(^SSU("SSUSR",BookingUserId)) q:BookingUserId=""  d
	    .s BookingUser=$$ALPHAUP^SSUTIL4($p(^SSU("SSUSR",BookingUserId),"^",2))
	    .i (desc'="")&($p(BookingUser,desc,1)'="") q
	    .d OutputRow4
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
OutputRow4
	s Data=$lb(BookingUser,BookingUserId)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod LookUpBookingUserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpBookingUserExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
	//
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {				// fetch row
 		s Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod LookUpBookingUserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpBookingUserExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

ClassMethod GetUserName(UserId As %String = "")
{
	s UserName=$$ALPHAUP^SSUTIL4($p(^SSU("SSUSR",UserId),"^",2))
	q UserName
}

ClassMethod GetBookingInfo(EpisodeID)
{
	q:(EpisodeID="") ""
	s procId=$o(^DHCProc(0,"Adm",EpisodeID,""))
	q:procId="" ""
	s procbSub=$o(^DHCProc(0,"BookingAdm",EpisodeID,procId,""))
    s procbStr=$g(^DHCProc(procId,"Booking",procbSub))
    q:procbStr="" ""
    i $p(procbStr,"^",5)'="" s $p(procbStr,"^",5)=$zd($p(procbStr,"^",5),4)
    i $p(procbStr,"^",6)'="" s $p(procbStr,"^",6)=$zt($p(procbStr,"^",6),2)
    q procbStr
}

}
