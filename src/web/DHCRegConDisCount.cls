Import SQLUser

Class web.DHCRegConDisCount Extends (DHCDoc.Util.RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

// 保存挂号优惠设置基本信息

ClassMethod UpdateDHCRegConDisCount(RCDRowid As %String, Priority As %String, RCDCode As %String, RCDDesc As %String, RCDStartDate As %String, RCDStartTime As %String, RCDEndDate As %String, RCDEndTime As %String, RCDOtherDesc As %String, RCDHospitalDr As %String) As %String
{
	s RepeatFlag=0
	s rowid=0
	for {
		s rowid=$o(^DHCRCDi(0,"Hosp",RCDHospitalDr,rowid)) Q:rowid=""
		continue:(RCDRowid'="")&&(rowid=RCDRowid)
		s Code=$p($g(^DHCRCD(rowid)),"^",1)
		s Desc=$p($g(^DHCRCD(rowid)),"^",2)
		if ((Code=RCDCode)||(Desc=RCDDesc)) { //&&(PriorityRowid=Priority)
			s RepeatFlag=1
			Q
		}
	}
	Q:RepeatFlag=1 "repeat"
	s myrtn=0
	if $l(RCDStartDate,"/")=3 s RCDStartDate=$zdh(RCDStartDate,4)
	if $l(RCDEndDate,"/")=3 s RCDEndDate=$zdh(RCDEndDate,4)
	if $l(RCDStartDate,"-")=3 s RCDStartDate=$zdh(RCDStartDate,3)
	if $l(RCDEndDate,"-")=3 s RCDEndDate=$zdh(RCDEndDate,3)
	if RCDStartTime'="" s RCDStartTime=..%ZTH(RCDStartTime)
	if RCDEndTime'="" s RCDEndTime=..%ZTH(RCDEndTime)
	if (RCDRowid=""){
		Set RCD = ##class(User.DHCRegConDisCount).%New()
	}else {
		Set RCD = ##class(User.DHCRegConDisCount).%OpenId(RCDRowid)
	}
	s RCD.RCDCode=RCDCode
	s RCD.RCDDesc=RCDDesc
	s RCD.RCDPriority=Priority
	s RCD.RCDStartDate=RCDStartDate
	s RCD.RCDStartTime=RCDStartTime
	s RCD.RCDEndDate=RCDEndDate
	s RCD.RCDEndTime=RCDEndTime
	s RCD.RCDOtherDesc=RCDOtherDesc
	d RCD.RCDHospitalDrSetObjectId(RCDHospitalDr)
	Set sc = RCD.%Save()
	If ($System.Status.IsError(sc)){
		Do $System.Status.DisplayError(sc)
		Set myrtn = "-100"
	}
  q myrtn
}

// 保存挂号优惠设置详细设置

ClassMethod UpdateDHCRegConDisCountSet(RCDRowid As %String, Age As %String, AgeCompare As %String, SexDr As %String, DeptDr As %String, MarkDr As %String, FeeCateDr As %String, PatTypeDr As %String, OldCard As %String, DocSessionDr As %String) As %String
{
	s myrtn=0
	if RCDRowid="" q "-102"
	Set RCD = ##class(User.DHCRegConDisCount).%OpenId(RCDRowid)
	s RCD.RCDAge=Age
	s RCD.RCDAgeCompare=AgeCompare
	d RCD.RCDSexDrSetObjectId(SexDr)
	d RCD.RCDDeptDrSetObjectId(DeptDr)
	d RCD.RCDMarkDrSetObjectId(MarkDr)
	d RCD.RCDFeeCateDrSetObjectId(FeeCateDr)
	d RCD.RCDPatTypeDrSetObjectId(PatTypeDr)
	d RCD.RCDSessionDrSetObjectId(DocSessionDr)
	s RCD.RCDOldCard=OldCard
	Set sc = RCD.%Save()
	If ($System.Status.IsError(sc)){
			Do $System.Status.DisplayError(sc)
			Set myrtn = "-100"
	}
    Q myrtn
}

Query FindDHCRegConDisCount(HospitalDr As %String, Priority As %String = "", Code As %String = "", Desc As %String = "") As %Query(ROWSPEC = "RCDRowid,RCDCode,RCDDesc,RCDPriorityRowid,RCDPriority,RCDStartDate,RCDStartTime,RCDEndDate,RCDEndTime,RCDOtherDesc:%String,RCDHospitalDesc") [ SqlProc ]
{
}

ClassMethod FindDHCRegConDisCountClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = FindDHCRegConDisCountExecute ]
{
	// Clean up by purging the temporary node in ^CacheTemp global
	//New repid
	Set repid=$li(QHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindDHCRegConDisCountFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindDHCRegConDisCountExecute ]
{
	//New repid,ind
	Set AtEnd=$li(QHandle,1)
	Set repid=$li(QHandle,2)
	Set ind=$li(QHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {	// if there are no more rows, finish fetching
		 Set AtEnd=1
		 Set Row=""
	}
	Else      {	// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

// w ##class(web.DHCRegConDisCount).GetDHCRegConDisCountById(2)

ClassMethod GetDHCRegConDisCountById(RCDRowid) As %String
{
	q:RCDRowid="" ""
	s RCDSex="",RCDAgeCompare="",RCDDept="",RCDMark="",RCDFeeCate="",RCDPatType=""
	s RCDCode=$p($g(^DHCRCD(RCDRowid)),"^",1)
	s RCDDesc=$p($g(^DHCRCD(RCDRowid)),"^",2)
	s RCDPriorityRowid=$p($g(^DHCRCD(RCDRowid)),"^",3)
	s RCDPriority=""
	i RCDPriorityRowid=1 s RCDPriority="Ⅰ"
	e  i RCDPriorityRowid=2 s RCDPriority="Ⅱ"
	e  i RCDPriorityRowid=3 s RCDPriority="Ⅲ"
	e  i RCDPriorityRowid=4 s RCDPriority="Ⅳ"
	s RCDStartDate=$p($g(^DHCRCD(RCDRowid)),"^",4)
	s:RCDStartDate'="" RCDStartDate=$zd(RCDStartDate,4)
	s RCDStartTime=$p($g(^DHCRCD(RCDRowid)),"^",5)
	s:RCDStartTime'="" RCDStartTime=..%ZT(RCDStartTime,2)
	s RCDEndDate=$p($g(^DHCRCD(RCDRowid)),"^",6)
	s:RCDEndDate'="" RCDEndDate=$zd(RCDEndDate,4)
	s RCDEndTime=$p($g(^DHCRCD(RCDRowid)),"^",7)
	s:RCDEndTime'="" RCDEndTime=..%ZT(RCDEndTime,2)
	s RCDOtherDesc=$p($g(^DHCRCD(RCDRowid)),"^",8)
	s RCDAge=$p($g(^DHCRCD(RCDRowid)),"^",9)
	s RCDAgeCompareDr=$p($g(^DHCRCD(RCDRowid)),"^",10)
	i RCDAgeCompareDr=1 s RCDAgeCompare="<"
	e  i RCDAgeCompareDr=2 s RCDAgeCompare="="
	e  i RCDAgeCompareDr=3 s RCDAgeCompare=">"
	s RCDSexDr=$p($g(^DHCRCD(RCDRowid)),"^",11)
	s:RCDSexDr'="" RCDSex=$p(^CT("SEX",RCDSexDr),"^",2)
	s RCDDeptDr=$p($g(^DHCRCD(RCDRowid)),"^",12)
	s:RCDDeptDr'="" RCDDept=$p(^CTLOC(RCDDeptDr),"^",2)
	s RCDMarkDr=$p($g(^DHCRCD(RCDRowid)),"^",13)
	s:RCDMarkDr'="" RCDMark=$p(^CTPCP(RCDMarkDr,1),"^",2)
	s RCDFeeCateDr=$p($g(^DHCRCD(RCDRowid)),"^",14)
	s:RCDFeeCateDr'="" RCDFeeCate=$p(^PAC("ADMREA",RCDFeeCateDr),"^",2)
	s RCDPatTypeDr=$p($g(^DHCRCD(RCDRowid)),"^",15)
	s:RCDPatTypeDr'="" RCDPatType=$p(^CT("SS",RCDPatTypeDr),"^",2)
	s OldCard=$p($g(^DHCRCD(RCDRowid)),"^",16)
	s DocSessionDr=$p($g(^DHCRCD(RCDRowid)),"^",17)
	s ret=RCDCode_"^"_RCDDesc_"^"_RCDPriorityRowid_"^"_RCDPriority_"^"_RCDStartDate_"^"_RCDStartTime_"^"_RCDEndDate_"^"_RCDEndTime_"^"_RCDOtherDesc_"^"_RCDAge   ;10
	s ret=ret_"^"_RCDAgeCompareDr_"^"_RCDAgeCompare_"^"_RCDSexDr_"^"_RCDSex_"^"_RCDDeptDr_"^"_RCDDept_"^"_RCDMarkDr_"^"_RCDMark_"^"_RCDFeeCateDr_"^"_RCDFeeCate  ;20
	s ret=ret_"^"_RCDPatTypeDr_"^"_RCDPatType_"^"_OldCard_"^"_DocSessionDr
	q ret
}

/// d ##class(%ResultSet).RunQuery("web.DHCRegConDisCount","FindDHCRegConDisCount")
ClassMethod FindDHCRegConDisCountExecute(ByRef QHandle As %Binary, HospitalDr As %String, Priority As %String = "", Code As %String = "", Desc As %String = "") As %Status
{
	
	Set repid=$I(^CacheTemp)
	s ind=1
	s RCDRowid=""
	f  s RCDRowid=$o(^DHCRCD(RCDRowid)) q:RCDRowid=""  d
	.s RCDCode=$p($g(^DHCRCD(RCDRowid)),"^",1)
	.Q:(Code'="")&&(RCDCode'=Code)
	.s RCDDesc=$p($g(^DHCRCD(RCDRowid)),"^",2)
	.Q:(Desc'="")&&(RCDDesc'[Desc)
	.s RCDPriorityRowid=$p($g(^DHCRCD(RCDRowid)),"^",3)
	.Q:(Priority'="")&&(RCDPriorityRowid'=Priority)
	.s RCDPriority=""
	.i RCDPriorityRowid=1 s RCDPriority="Ⅰ"
	.e  i RCDPriorityRowid=2 s RCDPriority="Ⅱ"
	.e  i RCDPriorityRowid=3 s RCDPriority="Ⅲ"
	.e  i RCDPriorityRowid=4 s RCDPriority="Ⅳ"
	.s RCDStartDate=$p($g(^DHCRCD(RCDRowid)),"^",4)
	.s:RCDStartDate'="" RCDStartDate=..%ZD(RCDStartDate) //$zd(RCDStartDate,4)
	.s RCDStartTime=$p($g(^DHCRCD(RCDRowid)),"^",5)
	.s:RCDStartTime'="" RCDStartTime=..%ZT(RCDStartTime)
	.s RCDEndDate=$p($g(^DHCRCD(RCDRowid)),"^",6)
	.s:RCDEndDate'="" RCDEndDate=..%ZD(RCDEndDate) //$zd(RCDEndDate,4)
	.s RCDEndTime=$p($g(^DHCRCD(RCDRowid)),"^",7)
	.s:RCDEndTime'="" RCDEndTime=..%ZT(RCDEndTime)
	.s RCDOtherDesc=$p($g(^DHCRCD(RCDRowid)),"^",8)
	.s RCDHospitalDesc=""
	.s RCDHospitalDr=$p($g(^DHCRCD(RCDRowid)),"^",18)
	.q:RCDHospitalDr'=HospitalDr
	.;Q:"N"=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("DHC_RegConDisCount",RCDRowid,HospitalDr)
	.if RCDHospitalDr'="" s RCDHospitalDesc=$p(^CT("HOSP",RCDHospitalDr),"^",2)
	.Do OutputRow
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(RCDRowid,RCDCode,RCDDesc,RCDPriorityRowid,RCDPriority,RCDStartDate,RCDStartTime,RCDEndDate,RCDEndTime,RCDOtherDesc,RCDHospitalDesc)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	quit
}

/// w ##class(web.DHCRegConDisCount).ReadDHCRegConDisCountBroker("GetRegConToHUIJson","GetRegConToHUIJson","","","")
ClassMethod ReadDHCRegConDisCountBroker(JSFunName As %String, ListName As %String, PatientID As %String = "", BillTypeID As %String = "", ExpStr As %String = "", HospId As %String = "") As %String
{
	n (JSFunName,ListName,PatientID,BillTypeID,ExpStr,HospId,%session)
	s json="["
	s TDate=..%SysDate()
	s TTime=..%SysTime()
	Set langid=..%LanguageID()
	s HospId=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	Set rset = ##class(%ResultSet).%New("web.DHCRegConDisCount:FindDHCRegConDisCount")
	Set columns = rset.GetColumnCount()
	Set rs = rset.Execute(HospId)
	s myIdx=0
	While (rset.Next()) {
		s RCDRowid=$g(rset.Data("RCDRowid"))
		if PatientID'=""{
			continue:+(..CheckRegConDisCount(RCDRowid,PatientID,BillTypeID,"","",ExpStr))=0
		}
		s RCDDesc=$g(rset.Data("RCDDesc"))
		s RCDDesc=##class(User.DHCRegConDisCount).GetTranByDesc("RCDDesc",RCDDesc,langid)
		s RCDStartDate=..%ZDH($g(rset.Data("RCDStartDate")))
		s RCDStartTime=$g(rset.Data("RCDStartTime"))
		if RCDStartTime'="" s RCDStartTime=..%ZTH(RCDStartTime)
		s RCDEndDate=..%ZDH($g(rset.Data("RCDEndDate")))
		s RCDEndTime=$g(rset.Data("RCDEndTime"))
		if RCDEndTime'="" s RCDEndTime=..%ZTH(RCDEndTime)
		continue:RCDDesc=""
	    continue:((RCDStartDate'="")&&(TDate<RCDStartDate))||((RCDEndDate'="")&&(TDate>RCDEndDate))
	    continue:((RCDStartDate'="")&&(TDate=RCDStartDate)&&(TTime<RCDStartTime))||((RCDEndDate'="")&&(TDate=RCDEndDate)&&(TTime>RCDEndTime)&&(RCDEndTime'=""))
	 	s myIdx=myIdx+1
		s mySelFlag=0
		if (JSFunName="GetRegConToHUIJson"){
			s OneJsonData="{""text"":"""_$g(RCDDesc)_""",""id"":"""_$g(RCDRowid)_""""
			s OneJsonData=OneJsonData_"}"
			if myIdx=1 {
				s json=json_OneJsonData
			}else {
				s json=json_","_OneJsonData
			}
		}else{
			s rtnval=JSFunName_"('"_ListName_"','"_$ZCVT($g(RCDDesc),"O","JS")_"','"_$ZCVT($g(RCDRowid),"O","JS")_"','"_$ZCVT($g(myIdx),"O","JS")
			s rtnval=rtnval_"','"_$ZCVT(mySelFlag,"O","JS")_"');"
			&javascript<#(rtnval)#>
		}
		
	}
	d rset.Close()
	s json=json_"]"    
	if (JSFunName="GetRegConToHUIJson"){
		q json
	}
	q 0
}

ClassMethod ReadSex(JSFunName As %String = "", ListName As %String = "", RCDRowid As %String, JSON As %String = "") As %String
{
	;^CMC("CMCBM",{CMCBM_RowId})
	;w ##class(web.DHCRegConDisCount).ReadSex("","","")
	s myBMRowid=0
	s mydes=""
	s myval=""
	s mySelFlag=0
	s myIdx=0
	s mydes=""
	s rtn=0
	s rtnval=JSFunName_"('"_ListName_"','"_$ZCVT($g(mydes),"O","JS")_"','"_$ZCVT($g(myval),"O","JS")_"','"_$ZCVT($g(myIdx),"O","JS")
	s rtnval=rtnval_"','"_$ZCVT(mySelFlag,"O","JS")_"');"
	if JSON'="JSON" &javascript<#(rtnval)#>
	s myIdx=myIdx+1
	f  s myBMRowid=$o(^CT("SEX",myBMRowid)) q:(myBMRowid="")  d
	.s mydes=$p(^CT("SEX",myBMRowid),"^", 2)
	.s DateActiveFrom=$p(^CT("SEX",myBMRowid),"^",4)
	.q:(DateActiveFrom'="")&&(DateActiveFrom>+$h)
	.s DateActiveTo=$p(^CT("SEX",myBMRowid),"^",5)
	.q:(DateActiveTo'="")&&(DateActiveTo<=+$h)
	.s myval=myBMRowid
	.s myval=myval_"^"_$p(^CT("SEX",myBMRowid),"^", 1)
	.s mySelFlag=0
	.i RCDRowid'="" d
	..i myBMRowid=$p($g(^DHCRCD(RCDRowid)),"^",11) d
	...s mySelFlag=1
	.if JSON="JSON" d
	..if rtn=0 s rtn=myBMRowid_$c(1)_mydes
	..else  s rtn=rtn_"^"_myBMRowid_$c(1)_mydes
	.else  d
	..s rtnval=JSFunName_"('"_ListName_"','"_$ZCVT($g(mydes),"O","JS")_"','"_$ZCVT($g(myval),"O","JS")_"','"_$ZCVT($g(myIdx),"O","JS")
	..s rtnval=rtnval_"','"_$ZCVT(mySelFlag,"O","JS")_"');"
	..&javascript<#(rtnval)#>
	..s myIdx=myIdx+1
	q rtn
}

ClassMethod ReadCompare(JSFunName As %String = "", ListName As %String = "", RCDRowid As %String, JSON As %String = "") As %String
{
	;^CMC("CMCBM",{CMCBM_RowId})
	;w ##class(web.DHCRegConDisCount).ReadCompare("","")
	s myBMRowid=0
	s mydes=""
	s myval=""
	s mySelFlag=0
	s myIdx=0
	s mydes=""
	s rtn=0
	s rtnval=JSFunName_"('"_ListName_"','"_$ZCVT($g(mydes),"O","JS")_"','"_$ZCVT($g(myval),"O","JS")_"','"_$ZCVT($g(myIdx),"O","JS")
	s rtnval=rtnval_"','"_$ZCVT(mySelFlag,"O","JS")_"');"
	if JSON'="JSON" &javascript<#(rtnval)#>
	s myIdx=myIdx+1
	s com="<=>"
	f i=1:1:$length(com) d
	.s mydes=$e(com,i)
	.s myval=i
	.s mySelFlag=0
	.i RCDRowid'="" d
	..i i=$p($g(^DHCRCD(RCDRowid)),"^",10) d
	...s mySelFlag=1
	.if JSON="JSON" d
	..if rtn=0 s rtn=myval_$c(1)_mydes
	..else  s rtn=rtn_"^"_myval_$c(1)_mydes
	.else  d
	..s rtnval=JSFunName_"('"_ListName_"','"_$ZCVT($g(mydes),"O","JS")_"','"_$ZCVT($g(myval),"O","JS")_"','"_$ZCVT($g(myIdx),"O","JS")
	..s rtnval=rtnval_"','"_$ZCVT(mySelFlag,"O","JS")_"');"
	..&javascript<#(rtnval)#>
	..s myIdx=myIdx+1
	q rtn
}

// 取科室

ClassMethod OPLoclookupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = OPLoclookupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

// d ##class(%ResultSet).RunQuery("web.DHCRegConDisCount","OPLoclookup","")

ClassMethod OPLoclookupExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
    s desc=$$ALPHAUP^SSUTIL4(desc)
    If $g(ind)="" Set ind=1
	s OPLocdesc="",rowid="0"
	s rowid="0"
	f  s rowid=$o(^PAC("ADMLOC",0,"AdmType","O",rowid))  q:rowid=""  d
	.s OPLocdesc=$p(^CTLOC(rowid),"^",2)
	.q:##class(web.DHCOPAdmReg).CheckLocDesc(rowid,desc)'=1
	.d OutputRow1
	/*.i desc'=""  d
	..i OPLocdesc[desc  d
	...d OutputRow1
 	.e  d
   	..d OutputRow1*/
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
    
	set Data=$lb(OPLocdesc,rowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod OPLoclookupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = OPLoclookupExecute ]
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

Query OPLoclookup(desc As %String) As %Query(ROWSPEC = "OPLocdesc:%String,rowid:%String")
{
}

/*Query Findloc(depid, markname As %String = "") As %SQLQuery(CONTAINID = 1, ROWSPEC = "Desc:%String,RowID:%String")
{
SELECT RES_CTPCP_DR->CTPCP_Desc,RES_CTPCP_DR 
FROM SQLUser.RB_RESOURCE
WHERE (
:depid  is null or RES_CTLOC_DR = :depid
and (res_schedulerequired='Yes' or res_schedulerequired='Y'))and ((:markname is null)  or (RES_CTPCP_DR->CTPCP_Desc like '%'_:markname_'%'))
}*/
Query Findloc(depid, markname As %String = "", HospitalID As %String = "") As %Query(ROWSPEC = "Desc:%String,RowID:%String")
{
}

ClassMethod FindlocExecute(ByRef qHandle As %Binary, depid, markname As %String = "", HospitalID As %String = "") As %Status
{
	if (HospitalID="")&&($d(%session)) s HospitalID=%session.Get("LOGON.HOSPID")
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	if (depid=""){
		k TMPMarkDocArr($j)
		s RESRowId=0
		for {
			s RESRowId=$o(^RB("RES",RESRowId)) 
			Q:RESRowId=""
			s RESCTLOCDR=$p(^RB("RES",RESRowId),"^",1)
			continue:($p(^CTLOC(RESCTLOCDR),"^",22)'=HospitalID)
			s RESCTPCPDR=$p(^RB("RES",RESRowId),"^",2)
			continue:RESCTPCPDR=""
			s CTPCPDesc=$p($g(^CTPCP(RESCTPCPDR,1)),"^",2)
			continue:CTPCPDesc=""
			continue:##class(DHCDoc.Util.Base).CheckCTCareName("CT_CareProv",RESCTPCPDR,markname)'=1
			continue:$d(TMPMarkDocArr($j,RESCTPCPDR))
			s ScheduleRequired=$p(^RB("RES",RESRowId),"^",6)
			continue:ScheduleRequired'="Y"
			s DateActiveFrom=$p(^RB("RES",RESRowId),"^",22)
			continue:(DateActiveFrom'="")&&(DateActiveFrom>+$h)
			s DateActiveTo=$p(^RB("RES",RESRowId),"^",23)
			continue:(DateActiveTo'="")&&(DateActiveTo<=..%SysDate())
			s TMPMarkDocArr($j,RESCTPCPDR)=""
			d OutputRow12
	    }
	    k TMPMarkDocArr($j)
	}else{
		s RESRowId=0
		for {
			s RESRowId=$o(^RB("RES",0,"CTLOC",depid,RESRowId))
			Q:RESRowId=""
			s RESCTLOCDR=$p(^RB("RES",RESRowId),"^",1)
			continue:($p(^CTLOC(RESCTLOCDR),"^",22)'=HospitalID)
			s RESCTPCPDR=$p(^RB("RES",RESRowId),"^",2)
			continue:RESCTPCPDR=""
			s CTPCPDesc=$p($g(^CTPCP(RESCTPCPDR,1)),"^",2)
			continue:CTPCPDesc=""
			continue:##class(DHCDoc.Util.Base).CheckCTCareName("CT_CareProv",RESCTPCPDR,markname)'=1
			s ScheduleRequired=$p(^RB("RES",RESRowId),"^",6)
			continue:ScheduleRequired'="Y"
			s DateActiveFrom=$p(^RB("RES",RESRowId),"^",22)
			continue:(DateActiveFrom'="")&&(DateActiveFrom>+$h)
			s DateActiveTo=$p(^RB("RES",RESRowId),"^",23)
			continue:(DateActiveTo'="")&&(DateActiveTo<=..%SysDate())
			d OutputRow12
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRow12
	set Data=$lb(CTPCPDesc,RESCTPCPDR)
	 Set ^CacheTemp(repid,ind)=Data
	 Set ind=ind+1
	quit
}

ClassMethod FindlocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindlocExecute ]
{
	 Set AtEnd=$LIST(qHandle,1)
	 Set repid=$LIST(qHandle,2)
	 Set ind=$LIST(qHandle,3)
	 Set ind=$o(^CacheTemp(repid,ind))
	 If ind="" {				// if there are no more rows, finish fetching
		 Set AtEnd=1
		 Set Row=""
	 }
	 Else      {				// fetch row
		 Set Row=^CacheTemp(repid,ind)
	 }
	 s qHandle=$lb(AtEnd,repid,ind)
	 Quit $$$OK
}

ClassMethod FindlocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindlocExecute ]
{
	Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod ReadPatTypeAdm(JSFunName As %String = "", ListName As %String = "", RCDRowid As %String, JSON As %String = "", HospID = "") As %String
{
	;PAC_AdmReason
	s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	s myBMRowid=0
	s mydes=""
	s myval=""
	s mySelFlag=0
	s myIdx=0
	s mydes=""
	s rtn=0
	s rtnval=JSFunName_"('"_ListName_"','"_$ZCVT($g(mydes),"O","JS")_"','"_$ZCVT($g(myval),"O","JS")_"','"_$ZCVT($g(myIdx),"O","JS")
	s rtnval=rtnval_"','"_$ZCVT(mySelFlag,"O","JS")_"');"
	if JSON'="JSON" &javascript<#(rtnval)#>
	s myIdx=myIdx+1
	f  s myBMRowid=$o(^PAC("ADMREA",myBMRowid)) q:(myBMRowid="")  d
	.q:"N"=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("PAC_AdmReason",myBMRowid,HospID)
	.s mydes=$p(^PAC("ADMREA",myBMRowid),"^", 2)
	.s dateFrom=$p(^PAC("ADMREA",myBMRowid),"^", 3)
	.Q:(dateFrom'="")&&(dateFrom>+$h)
	.s dateTo=$p(^PAC("ADMREA",myBMRowid),"^", 4)
	.Q:(dateTo'="")&&(dateTo<+$h)
	.s myval=myBMRowid
	.s myval=myval_"^"_$p(^PAC("ADMREA",myBMRowid),"^", 1)		;
	.s mySelFlag=0
	.i RCDRowid'="" d
	..i myBMRowid=$p($g(^DHCRCD(RCDRowid)),"^",14) d
	...s mySelFlag=1
	.if JSON="JSON" d
	..if rtn=0 s rtn=myBMRowid_$c(1)_mydes
	..else  s rtn=rtn_"^"_myBMRowid_$c(1)_mydes
	.else  d
	..s rtnval=JSFunName_"('"_ListName_"','"_$ZCVT($g(mydes),"O","JS")_"','"_$ZCVT($g(myval),"O","JS")_"','"_$ZCVT($g(myIdx),"O","JS")
	..s rtnval=rtnval_"','"_$ZCVT(mySelFlag,"O","JS")_"');"
	..&javascript<#(rtnval)#>
	..s myIdx=myIdx+1
	q rtn
}

ClassMethod ReadPatType(JSFunName As %String = "", ListName As %String = "", RCDRowid As %String, JSON As %String = "", HospID = "") As %String
{
	s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	s myBMRowid=0
	s mydes=""
	s myval=""
	s mySelFlag=0
	s myIdx=0
	s mydes=""
	s rtn=0
	s rtnval=JSFunName_"('"_ListName_"','"_$ZCVT($g(mydes),"O","JS")_"','"_$ZCVT($g(myval),"O","JS")_"','"_$ZCVT($g(myIdx),"O","JS")
	s rtnval=rtnval_"','"_$ZCVT(mySelFlag,"O","JS")_"');"
	if JSON'="JSON" &javascript<#(rtnval)#>
	s myIdx=myIdx+1
	f  s myBMRowid=$o(^CT("SS",myBMRowid)) q:(myBMRowid="")  d
	.q:"N"=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("CT_SocialStatus",myBMRowid,HospID)
	.s mydes=$p(^CT("SS",myBMRowid),"^", 2)
	.s myval=myBMRowid
	.s myval=myval_"^"_$p(^CT("SS",myBMRowid),"^", 1)		;
	.s mySelFlag=0
	.i RCDRowid'="" d
	..i myBMRowid=$p($g(^DHCRCD(RCDRowid)),"^",15) d
	...s mySelFlag=1
	.if JSON="JSON" d
	..if rtn=0 s rtn=myBMRowid_$c(1)_mydes
	..else  s rtn=rtn_"^"_myBMRowid_$c(1)_mydes
	.else  d
	..s rtnval=JSFunName_"('"_ListName_"','"_$ZCVT($g(mydes),"O","JS")_"','"_$ZCVT($g(myval),"O","JS")_"','"_$ZCVT($g(myIdx),"O","JS")
	..s rtnval=rtnval_"','"_$ZCVT(mySelFlag,"O","JS")_"');"
	..&javascript<#(rtnval)#>
	..s myIdx=myIdx+1
	q rtn
}

// 判断满足的挂号优惠设置

// 入参：PatientID(病人RowId),RBASDr(排班RowId),RCDFeeCateDr(费别),OldCard(有无老年证,1为有)

// w ##class(web.DHCRegConDisCount).CheckDHCRegConDisCount(19,"559||651",1,"")

ClassMethod CheckDHCRegConDisCount(PatientID As %String, RBASDr As %String, FeeCateDr As %String, OldCard As %String, HospId As %String = "") As %String
{
	s ^tmpgry("CheckDHCRegConDisCount")=PatientID_","_RBASDr_","_FeeCateDr_","_OldCard_","_HospId
	//s ^TempzongHHY(RBASDr)=PatientID_","_RBASDr_","_FeeCateDr_","_OldCard
	q:PatientID="" ""
	q:RBASDr="" ""
	s HospId=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	q:HospId="" ""
	s PAPMIAge="",PAPMISex=""
	s FindID=""
	s TDate=..%SysDate()
	s TTime=..%SysTime()
	k RuleKeyAry
	s RCDRowid=""
	f  s RCDRowid=$o(^DHCRCD(RCDRowid)) q:RCDRowid=""  d
	.s RCDCode=$p($g(^DHCRCD(RCDRowid)),"^",1)
	.s RCDDesc=$p($g(^DHCRCD(RCDRowid)),"^",2)
	.s RCDPriorityRowid=$p($g(^DHCRCD(RCDRowid)),"^",3)
	.s RCDStartDate=$p($g(^DHCRCD(RCDRowid)),"^",4)
	.s RCDStartTime=$p($g(^DHCRCD(RCDRowid)),"^",5)
	.s RCDEndDate=$p($g(^DHCRCD(RCDRowid)),"^",6)
	.s RCDEndTime=$p($g(^DHCRCD(RCDRowid)),"^",7)
	.s RCDAge=$p($g(^DHCRCD(RCDRowid)),"^",9)
	.s RCDAgeCompare=$p($g(^DHCRCD(RCDRowid)),"^",10)
	.s RCDSexDr=$p($g(^DHCRCD(RCDRowid)),"^",11)
	.s RCDDeptDr=$p($g(^DHCRCD(RCDRowid)),"^",12)
	.s RCDMarkDr=$p($g(^DHCRCD(RCDRowid)),"^",13)
	.s RCDFeeCateDr=$p($g(^DHCRCD(RCDRowid)),"^",14)
	.s RCDPatTypeDr=$p($g(^DHCRCD(RCDRowid)),"^",15)
	.s RCDOldCard=$p($g(^DHCRCD(RCDRowid)),"^",16)
	.s RCDDocSession=$p($g(^DHCRCD(RCDRowid)),"^",17)
	.s RCDHospId=$p($g(^DHCRCD(RCDRowid)),"^",18)
	.q:RCDHospId'=HospId
	.q:((RCDStartDate'="")&&(TDate<RCDStartDate))||((RCDEndDate'="")&&(TDate>RCDEndDate))
	.q:((RCDStartDate'="")&&(TDate=RCDStartDate)&&(TTime<RCDStartTime))||((RCDEndDate'="")&&(TDate=RCDEndDate)&&(TTime>RCDEndTime))
	.;如果没有级别,默认最后一级
	.i RCDPriorityRowid="" s RCDPriorityRowid=4
	.i +RCDOldCard=0 s RCDOldCard=""
	.s RuleKeyAry(RCDPriorityRowid,RCDRowid)=RCDSexDr_"^"_RCDAge_"^"_RCDFeeCateDr_"^"_RCDPatTypeDr_"^"_RCDDeptDr_"^"_RCDMarkDr_"^"_RCDOldCard_"^"_RCDDocSession
	.i $tr(RuleKeyAry(RCDPriorityRowid,RCDRowid),"^","")="" k RuleKeyAry(RCDPriorityRowid,RCDRowid)
	
	Set Sex=$P(^PAPER(PatientID,"ALL"),"^",7)
	If Sex'="" Set PAPMISex=$P($g(^CT("SEX",Sex)),"^",2)
	Set DobDate=$P($g(^PAPER(PatientID,"ALL")),"^",6)
	If DobDate'="" Do
	.Set PAPMIDOB=$ZD($P(^PAPER(PatientID,"ALL"),"^",6),3)
	.i PAPMIDOB[("-") s PAPMIDOB=$ZDH(PAPMIDOB,3)
	.if PAPMIDOB[("/")  s PAPMIDOB=$ZDH(PAPMIDOB,4)
	.Set PAPMIAge=$$CalAge^at182(PAPMIDOB,TDate,"","","")
	.s PAPMIAge=$P(PAPMIAge,"|",12)
	s CTSocialStatus=$P($g(^PAPER(PatientID,"PER",1)),"^",10)
	s ResRowId=+RBASDr
	s ctloc=$p($g(^RB("RES",ResRowId)),"^",1)
	s ctpcp=$p($g(^RB("RES",ResRowId)),"^",2)
	s SessionType=$P($G(^RBAS(ResRowId,$p(RBASDr,"||",2),"DHC")),"^",6)
	s PriId=0
	for {
		s PriId=$O(RuleKeyAry(PriId)) Q:(PriId="")||(FindID'="")
		s RCDRowid=0
		for {
			s RCDRowid=$O(RuleKeyAry(PriId,RCDRowid)) Q:RCDRowid=""
			s CheckSex=$p(RuleKeyAry(PriId,RCDRowid),"^",1)
			continue:(CheckSex'="")&&(CheckSex'=Sex)
			s CheckAge=$p(RuleKeyAry(PriId,RCDRowid),"^",2)
			
			s RCDAgeCompare=$p($g(^DHCRCD(RCDRowid)),"^",10)
			continue:((CheckAge'="")&&(RCDAgeCompare=1)&&(PAPMIAge>=CheckAge))
			continue:((CheckAge'="")&&(RCDAgeCompare=2)&&(PAPMIAge'=CheckAge))
			continue:((CheckAge'="")&&(RCDAgeCompare=3)&&(PAPMIAge<=CheckAge))
			s CheckFeeCate=$p(RuleKeyAry(PriId,RCDRowid),"^",3)
			continue:(CheckFeeCate'="")&&(CheckFeeCate'=FeeCateDr)
			s CheckPatType=$p(RuleKeyAry(PriId,RCDRowid),"^",4)
			continue:(CheckPatType'="")&&(CheckPatType'=CTSocialStatus)
			s CheckDept=$p(RuleKeyAry(PriId,RCDRowid),"^",5)
			continue:(CheckDept'="")&&(CheckDept'=ctloc)
			s CheckMark=$p(RuleKeyAry(PriId,RCDRowid),"^",6)
			continue:(CheckMark'="")&&(CheckMark'=ctpcp)
			s CheckOldCard=$p(RuleKeyAry(PriId,RCDRowid),"^",7)
			continue:(CheckOldCard=1)&&(OldCard'=1)
			s CheckSessionType=$p(RuleKeyAry(PriId,RCDRowid),"^",8)
			continue:(CheckSessionType'="")&&(CheckSessionType'=SessionType)
			;如果同优先级有很多满足,则取第一条满足的情况
			s FindID=RCDRowid
			Q
		}
	}
	
	q FindID
}

ClassMethod ReadSessionType(JSFunName As %String = "", ListName As %String = "", RCDRowid As %String, JSON As %String = "", HospID = "") As %String
{
	;^CMC("CMCBM",{CMCBM_RowId})
	;w ##class(web.DHCRegConDisCount).ReadSex("","","")
	s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	s myBMRowid=0
	s mydes=""
	s myval=""
	s mySelFlag=0
	s myIdx=0
	s mydes=""
	s rtn=0
	s rtnval=JSFunName_"('"_ListName_"','"_$ZCVT($g(mydes),"O","JS")_"','"_$ZCVT($g(myval),"O","JS")_"','"_$ZCVT($g(myIdx),"O","JS")
	s rtnval=rtnval_"','"_$ZCVT(mySelFlag,"O","JS")_"');"
	if JSON'="JSON" &javascript<#(rtnval)#>
	s myIdx=myIdx+1
	f  s myBMRowid=$o(^RBC("SESS",myBMRowid)) q:(myBMRowid="")  d
	.q:"N"=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("RBC_SessionType",myBMRowid,HospID)
	.s mydes=$p(^RBC("SESS",myBMRowid),"^", 2)
	.s SESSDateFrom=$p(^RBC("SESS",myBMRowid),"^", 6)
	.Q:(SESSDateFrom'="")&&(SESSDateFrom>+$h)
	.s SESSDateTo=$p(^RBC("SESS",myBMRowid),"^", 7)
	.Q:(SESSDateTo'="")&&(SESSDateTo<+$h)
	.s myval=myBMRowid
	.s myval=myval_"^"_$p(^RBC("SESS",myBMRowid),"^", 1)
	.s mySelFlag=0
	.i RCDRowid'="" d
	..i myBMRowid=$p($g(^DHCRCD(RCDRowid)),"^",11) d
	...s mySelFlag=1
	.if JSON="JSON" d
	..if rtn=0 s rtn=myBMRowid_$c(1)_mydes
	..else  s rtn=rtn_"^"_myBMRowid_$c(1)_mydes
	.else  d
	..s rtnval=JSFunName_"('"_ListName_"','"_$ZCVT($g(mydes),"O","JS")_"','"_$ZCVT($g(myval),"O","JS")_"','"_$ZCVT($g(myIdx),"O","JS")
	..s rtnval=rtnval_"','"_$ZCVT(mySelFlag,"O","JS")_"');"
	..&javascript<#(rtnval)#>
	..s myIdx=myIdx+1
	q rtn
}

/// Desc:根据传入的条件判断挂号优惠设置是否满足
/// Input:RegConDisID 挂号优惠ID,PatientID：患者ID,RBASDr：排班ID,FeeCateDr：费别ID,OldCard：老年证
/// OutPut:0 不满足 1 满足
/// Debug:
ClassMethod CheckRegConDisCount(RegConDisID As %String, PatientID As %String, FeeCateDr As %String = "", RBASDr As %String = "", OldCard As %String = "", ExpStr As %String = "") As %String
{
	n (RegConDisID,PatientID,FeeCateDr,RBASDr,OldCard,ExpStr)
	s ret=0
	q:PatientID="" ret
	s PAPMIAge="",PAPMISex=""
	s FindID=""
	s TDate=..%SysDate()
	s TTime=..%SysTime()
	k RuleKeyAry
	if RegConDisID'="" d
	.s RCDRowid=RegConDisID
	.s RCDCode=$p($g(^DHCRCD(RCDRowid)),"^",1)
	.s RCDDesc=$p($g(^DHCRCD(RCDRowid)),"^",2)
	.s RCDPriorityRowid=$p($g(^DHCRCD(RCDRowid)),"^",3)
	.s RCDStartDate=$p($g(^DHCRCD(RCDRowid)),"^",4)
	.s RCDStartTime=$p($g(^DHCRCD(RCDRowid)),"^",5)
	.s RCDEndDate=$p($g(^DHCRCD(RCDRowid)),"^",6)
	.s RCDEndTime=$p($g(^DHCRCD(RCDRowid)),"^",7)
	.s RCDAge=$p($g(^DHCRCD(RCDRowid)),"^",9)
	.s RCDAgeCompare=$p($g(^DHCRCD(RCDRowid)),"^",10)
	.s RCDSexDr=$p($g(^DHCRCD(RCDRowid)),"^",11)
	.s RCDDeptDr=$p($g(^DHCRCD(RCDRowid)),"^",12)
	.s RCDMarkDr=$p($g(^DHCRCD(RCDRowid)),"^",13)
	.s RCDFeeCateDr=$p($g(^DHCRCD(RCDRowid)),"^",14)
	.s RCDPatTypeDr=$p($g(^DHCRCD(RCDRowid)),"^",15)
	.s RCDOldCard=$p($g(^DHCRCD(RCDRowid)),"^",16)
	.s RCDDocSession=$p($g(^DHCRCD(RCDRowid)),"^",17)
	.q:((RCDStartDate'="")&&(TDate<RCDStartDate))||((RCDEndDate'="")&&(TDate>RCDEndDate))
	.q:((RCDStartDate'="")&&(TDate=RCDStartDate)&&(TTime<RCDStartTime))||((RCDEndDate'="")&&(TDate=RCDEndDate)&&(TTime>RCDEndTime))
	.i +RCDOldCard=0 s RCDOldCard=""
	.s RuleKeyAry(RCDRowid)=RCDSexDr_"^"_RCDAge_"^"_RCDFeeCateDr_"^"_RCDPatTypeDr_"^"_RCDDeptDr_"^"_RCDMarkDr_"^"_RCDOldCard_"^"_RCDDocSession
	.i $tr(RuleKeyAry(RCDRowid),"^","")="" k RuleKeyAry(RCDRowid)
	
	q:'$d(RuleKeyAry) 1
	Set Sex=$P(^PAPER(PatientID,"ALL"),"^",7)
	If Sex'="" Set PAPMISex=$P($g(^CT("SEX",Sex)),"^",2)
	Set DobDate=$P($g(^PAPER(PatientID,"ALL")),"^",6)
	If DobDate'="" Do
	.Set PAPMIDOB=$ZD($P(^PAPER(PatientID,"ALL"),"^",6),3)
	.i PAPMIDOB[("-") s PAPMIDOB=$ZDH(PAPMIDOB,3)
	.if PAPMIDOB[("/")  s PAPMIDOB=$ZDH(PAPMIDOB,4)
	.Set PAPMIAge=$$CalAge^at182(PAPMIDOB,TDate,"","","")
	.s PAPMIAge=$P(PAPMIAge,"|",12)
	s CTSocialStatus=$P($g(^PAPER(PatientID,"PER",1)),"^",10)
	s ctloc="",ctpcp="",SessionType=""
	if RBASDr'=""{
		s ResRowId=+RBASDr
		s ctloc=$p($g(^RB("RES",ResRowId)),"^",1)
		s ctpcp=$p($g(^RB("RES",ResRowId)),"^",2)
		s SessionType=$P($G(^RBAS(ResRowId,$p(RBASDr,"||",2),"DHC")),"^",6)
	}
	if (RBASDr="")&&(ExpStr'=""){
		s ctloc=$p(ExpStr,"^",1)
		s ctpcp=$p(ExpStr,"^",2)
	}

	s RCDRowid=0
	for {
		s RCDRowid=$O(RuleKeyAry(RCDRowid)) Q:RCDRowid=""
		s CheckSex=$p(RuleKeyAry(RCDRowid),"^",1)
		continue:(CheckSex'="")&&(CheckSex'=Sex)
		s CheckAge=$p(RuleKeyAry(RCDRowid),"^",2)
		s RCDAgeCompare=$p($g(^DHCRCD(RCDRowid)),"^",10)
		continue:((CheckAge'="")&&(RCDAgeCompare=1)&&(PAPMIAge>=CheckAge))
		continue:((CheckAge'="")&&(RCDAgeCompare=2)&&(PAPMIAge'=CheckAge))
		continue:((CheckAge'="")&&(RCDAgeCompare=3)&&(PAPMIAge<=CheckAge))
		s CheckFeeCate=$p(RuleKeyAry(RCDRowid),"^",3)
		continue:(FeeCateDr'="")&&(CheckFeeCate'="")&&(CheckFeeCate'=FeeCateDr)
		s CheckPatType=$p(RuleKeyAry(RCDRowid),"^",4)
		continue:(CheckPatType'="")&&(CheckPatType'=CTSocialStatus)
		s CheckDept=$p(RuleKeyAry(RCDRowid),"^",5)
		continue:(ctloc'="")&&(CheckDept'="")&&(CheckDept'=ctloc)
		s CheckMark=$p(RuleKeyAry(RCDRowid),"^",6)
		continue:(ctpcp'="")&&(CheckMark'="")&&(CheckMark'=ctpcp)
		s CheckOldCard=$p(RuleKeyAry(RCDRowid),"^",7)
		continue:(CheckOldCard=1)&&(OldCard'=1)
		s CheckSessionType=$p(RuleKeyAry(RCDRowid),"^",8)
		continue:(SessionType'="")&&(CheckSessionType'="")&&(CheckSessionType'=SessionType)
		s ret=1
		Q
	}
	
	q ret
}

}
