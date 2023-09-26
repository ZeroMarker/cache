Import User

Class DHCBP.PatientList Extends web.DHCClinicCom
{

// D ##class(%ResultSet).RunQuery("DHCBP.PatientList","Find","2021-11-08","A","194","")

Query Find(date As %String, workShift, locId As %String, bedGroupId As %String) As %Query(ROWSPEC = "RowId,Bed,StatusDesc,PatName,Sex,Birth,RegNo,PatRegisterId,ArrageDate,ArrageTime,CheckDoctor,CheckDate,CheckTime,ReCheckDoctor,ReCheckDate,ReCheckTime,CheckNurse,CheckNurseDate,CheckNurseTime,StartOperationNurse,StartOperationNurseDate,StartOperationNurseTime,ReCheckNurse,ReCheckNurseDate,ReCheckNurseTime")
{
}

ClassMethod FindExecute(ByRef qHandle As %Binary, date As %String, workShift As %String, locId As %String, bedGroupId As %String) As %Status
{
	s ^TempBPDebug("DHCBP.PatientList-Find")=date_","_workShift_","_locId_","_bedGroupId
	//优先级：regNo,papmiMedicare,papmiName,ctlocId
	k ^TMPBP("BP",$j)
	//s date="2021/5/31"
  	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s locIdList=##Class(web.DHCBPCom).GetLinkLocByLocId(locId) //科室关联
	s date=##class(web.DHCClinicCom).ConvertToDateH(date)
	s rowId=""
	f  s rowId=$o(^DHCBPArrange(0,"Date",date,rowId)) q:rowId=""  d
	.d GetDateRow
	s daySeqNo="" f  s daySeqNo=$o(^TMPBP("BP",$j,daySeqNo)) q:daySeqNo=""  d
	.s bedGroupDr="" f  s bedGroupDr=$o(^TMPBP("BP",$j,daySeqNo,bedGroupDr)) q:bedGroupDr=""  d
	..s bedId="" f  s bedId=$o(^TMPBP("BP",$j,daySeqNo,bedGroupDr,bedId)) q:bedId=""  d
	...do OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK	

GetDateRow  
    s item=##class(User.DHCBPArrange).%OpenId(rowId)
    s bpprId=item.BPABPPatRegisterDr.%Id()
    q:bpprId=""
    //set arrangExtend=..GetExtendByCode(rowId, "ReviewNurseId")
    s patInfo=..GetPatInfo(rowId)
    q:item.BPABPCBedDr="" "无"
    s bed=item.BPABPCBedDr.BPCBDesc
    s bed=..GetBedNum(bed)
    s bedId=item.BPABPCBedDr.%Id()
    s bedGroup=item.BPABPCBedDr.BPCBBPCBedGroupDr
    s bedGroupDr=item.BPABPCBedDr.BPCBBPCBedGroupDr.%Id()
    q:((bedGroupId'="")&&(bedGroup=""))
    q:((bedGroupId'="")&&(bedGroupId'=bedGroup.%Id()))
    s daySeqNo=item.BPADaySeqNo
    i (workShift=""){
	    s time=$p($h,",",2)
	    i time<43200 s workShift="A"
	    e  i ((time>43200)&(time<61200)) s workShift="P"
	    e  i time>61200 s workShift="E"
	    }
    q:(workShift'="")&&(daySeqNo'=workShift)
    s bpprPatLocationDr=item.BPABPPatRegisterDr.BPPRPatLocationDr	
    q:((locId'="")&&(bpprPatLocationDr'="")&&($p($g(^CTLOC(locId)),"^",22)'=$p($g(^CTLOC(bpprPatLocationDr)),"^",22))) -9 //病人所在医院判断
    q:(bpprPatLocationDr'="")&&(locIdList'="")&&(("^"_locIdList_"^")'[("^"_bpprPatLocationDr_"^")) -10
    
    s arrageDate=##class(web.DHCClinicCom).ConvertToDate(item.BPADate)
    s arrageTime=##class(web.DHCClinicCom).ConvertToTime(item.BPATime)
    //s status=##class(User.DHCBPArrange).BPAStatusLogicalToDisplay(item.BPAStatus)
    s status=item.BPAStatus
    q:status="D"
    s statusDesc=$$GetStatus()
    s checkDoctor="",checkDate="",checkTime=""
    // 审核
    if (item.BPACheckDocDr'=""){
	    s obj=##class(User.CTCareProv).%OpenId(item.BPACheckDocDr)
	    s checkDoctor=obj.CTPCPDesc
	    s checkDate=..ConvertToDate(item.BPACheckDate)
	    s checkTime=..ConvertToTime(item.BPACheckTime)
    }
    s reCheckDate="",reCheckTime="",reCheckDoctor=""
    // 复核
    if (item.BPARecheckDocDr'=""){
	    //b ;1
	    s obj=##class(User.CTCareProv).%OpenId(item.BPARecheckDocDr)
	    s reCheckDoctor=obj.CTPCPDesc
	    s reCheckDate=..ConvertToDate(item.BPARecheckDate)
	    s reCheckTime=..ConvertToTime(item.BPARecheckTime)
    }
    // 核查护士
    s checkNurse="",checkNurseDate="",checkNurseTime=""
    if (item.BPACheckNurseDr'=""){
	    ;b ;3
	    s obj=##class(User.CTCareProv).%OpenId(item.BPACheckNurseDr)
	    s checkNurse=obj.CTPCPDesc
	    s checkNurseDate=..ConvertToDate(item.BPACheckDate)
	    s checkNurseTime=..ConvertToTime(item.BPACheckTime)
    }
    // 上机护士
    s startOperationNurse="",startOperationNurseDate="",startOperationNurseTime=""
    if (item.BPAStartOperationNurseDr'=""){
	    s obj=##class(User.CTCareProv).%OpenId(item.BPAStartOperationNurseDr)
	    s startOperationNurse=obj.CTPCPDesc
	    s startOperationNurseDate=..ConvertToDate(item.BPAStartOperationDate)
	    s startOperationNurseTime=..ConvertToTime(item.BPAStartOperationTime)
    }
    // 上机核对护士
    s reCheckNurse="",reCheckNurseDate="",reCheckNurseTime=""
    s reCheckNurse=..GetExtendByCode(rowId, "ReviewNurseId")
    if (reCheckNurse'=""){
	    s reCheckNurseDate=reCheckNurse.GetAt("Date")
	    s reCheckNurseTime=reCheckNurse.GetAt("Time")
	    s reCheckNurse=reCheckNurse.GetAt("UserName")
    }
    b
    s ^TMPBP("BP",$j,daySeqNo,bedGroupDr,bedId)=$lb(rowId,bed,statusDesc,patInfo.GetAt("PatName"),patInfo.GetAt("Sex"),patInfo.GetAt("Birth"),patInfo.GetAt("RegNo"),patInfo.GetAt("PatRegisterId"),arrageDate,arrageTime,checkDoctor,checkDate,checkTime,reCheckDoctor,reCheckDate,reCheckTime,checkNurse,checkNurseDate,checkNurseTime,startOperationNurse,startOperationNurseDate,startOperationNurseTime,reCheckNurse,reCheckNurseDate,reCheckNurseTime)
    quit
OutputRow 
	//set Data=$lb(rowId,bed,statusDesc,patInfo.GetAt("PatName"),patInfo.GetAt("Sex"),patInfo.GetAt("Birth"),patInfo.GetAt("RegNo"),patInfo.GetAt("PatRegisterId"),arrageDate,arrageTime,checkDoctor,checkDate,checkTime,reCheckDate,reCheckTime,checkNurse,checkNurseDate,checkNurseTime,startOperationNurse,startOperationNurseDate,startOperationNurseTime,reCheckNurse,reCheckNurseDate,reCheckNurseTime)
 	//Set ^CacheTemp(repid,ind)=^TMPAN("App",$j,sortOpRoomDesc,sortSeq,locDoc,opaId)
 	Set ^CacheTemp(repid,ind)=^TMPBP("BP",$j,daySeqNo,bedGroupDr,bedId)
 	Set ind=ind+1
	quit
GetStatus()
   ;申请;已接受;透析中;透析已完成
   q:status="A" "申请"
   q:status="R" "已接受"
   q:status="M" "透析中"
   q:status="F" "完成"
   q "UnKnown"
}

ClassMethod FindFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBPArrangeSummaryExecute ]
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

ClassMethod FindClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBPArrangeSummaryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

// d ##class(DHCBP.PatientList).GetExtendByCode(25976,"BFR")

ClassMethod GetExtendByCode(rowId, code) As %String
{
	s id=""
	&sql(select ID into:id from DHC_BP_ArrangeExtend
	where BPAE_BPA_Dr=:rowId and BPAE_BPCAECode=:code)
	q:SQLCODE'=0 ""
 	q:id="" ""
	s obj=##class(User.DHCBPArrangeExtend).%OpenId(id)
	//s item={}
	//s item.Code=obj.BPAEBPCAECode
	//s item.Value=obj.BPAEValue
	//s item.Date=..ConvertToDate(obj.BPAEUpdateDate)
	//s item.Time=..ConvertToTime(obj.BPAEUpdateTime)
	//s item.UserName=obj.BPAEUserDr
	
	s item=##class(%Library.ArrayOfDataTypes).%New()
	d item.SetAt(obj.BPAEBPCAECode,"Code")
	d item.SetAt(obj.BPAEValue,"Value")
	d item.SetAt(..ConvertToDate(obj.BPAEUpdateDate),"Date")
	d item.SetAt(..ConvertToTime(obj.BPAEUpdateTime),"Time")
	d item.SetAt(obj.BPAEUserDr,"UserName")
	s user=##class(User.SSUser).%OpenId(obj.BPAEUserDr)
	if (user'=""){
		//s item.UserName=user.SSUSRName
		d item.SetAt(user.SSUSRName,"UserName")
	}
	q item
}

ClassMethod GetPatInfo(rowId) As %String
{
	s bpprId=$lg(^DHCBPArrange(rowId),1)
	s papmiId=$lg(^DHCBPPatRegister(bpprId),1)
	q:papmiId="" -6
	s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	s papmiMedicare=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)
	s patSex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
	s patBirth=$p($g(^PAPER(papmiId,"ALL")),"^",6)	//出生日期
	//s item={}
	s item=##class(%Library.ArrayOfDataTypes).%New()
	d item.SetAt(patSex,"Sex")
	d item.SetAt(patBirth,"Birth")
	d item.SetAt(patName,"PatName")
	d item.SetAt(regNo,"RegNo")
	d item.SetAt(bpprId,"PatRegisterId")
	//s item.Sex=patSex
	//s item.Birth=patBirth
	//s item.PatName=patName
	//s item.RegNo=regNo
	//s item.PatRegisterId=bpprId
	q item
}

ClassMethod GetCareProv(id)
{
	s item=##class(User.CTCareProv).%OpenId(id)
	//s res={}
	s res=##class(%Library.ArrayOfDataTypes).%New()
	d res.SetAt(item.CTPCPDesc,"Name")
	//s res.Name=item.CTPCPDesc
	q res
}

Query FindBPCBedGroup(locId) As %SQLQuery(CONTAINID = 1)
{
SELECT BPCBG_RowId As Id,
       BPCBG_Code As Code,
       BPCBG_Desc As Description,
	   BPCBG_Location_Dr As LocationDr,
	   BPCBG_Isolated As Isolated
	   FROM DHC_BPC_BedGroup where BPCBG_Location_Dr=:locId
}

// w ##class(DHCBP.PatientList).GetBedNum("床位16")

ClassMethod GetBedNum(bed) As %String
{
	s bednum=""
	s bedleth=$l(bed)
	s bednum=$e(bed,3,bedleth)
	i bedleth<4 s bednum=0_bednum
	
	q bednum
}

}
