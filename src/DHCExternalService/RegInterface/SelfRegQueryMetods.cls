Class DHCExternalService.RegInterface.SelfRegQueryMetods Extends (DHCDoc.Util.RegisteredObject, %XML.Adaptor)
{

Query FindResDoc(DepID As %String, UserID As %String = "", DocID As %String = "", HospID As %String = "") As %Query(ROWSPEC = "Desc:%String,Code:%String,Hidden:%String,Hidden:%String,DeptID:%String,DeptDesc:%String,DocSessionType:%String,DocSessionTypeID:%String,DocIntruduction:%String") [ SqlProc ]
{
}

/// d ##class(%ResultSet).RunQuery("DHCExternalService.RegInterface.SelfRegQueryMetods","FindResDoc","115","12173","","2")
ClassMethod FindResDocExecute(ByRef qHandle As %Binary, DepID As %String, UserID As %String = "", DocID As %String = "", HospID As %String = "") As %Status
{
	s ^tmpnk("FindResDoc")=$lb(DepID,UserID,DocID,HospID)
	s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	i DocID=""{
		if (DepID=""){
			k tmpDocListArr($j)
	        s RowId=0
	        f  s RowId=$o(^RB("RES",RowId)) q:RowId=""  d
	        .s LocId=$p(^RB("RES",RowId),"^",1)
	        .Q:'$d(^PAC("ADMLOC",0,"AdmType","O",LocId))&&('$d(^PAC("ADMLOC",0,"AdmType","E",LocId)))
	        .Q:'$d(^RB("RES",0,"CTLOC",LocId))
	        .Q:$d(tmpDocListArr($j,DocID))
	        .d ResetVariables1
			.s tmpDocListArr($j,DocID)=1
			.Q:'($D(^RB("RES",RowId)))
	        .set ScheSt=$p(^RB("RES",RowId),"^",6)
			.Q:(ScheSt'="Y")
	        .Q:"N"=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("RB_Resource",RowId,HospID)
	        .s ActiveFrom=$p(^RB("RES",RowId),"^",22)
	        .Q:(ActiveFrom'="")&&(ActiveFrom>+$h)
	        .s ActiveTo=$p(^RB("RES",RowId),"^",23)
	        .Q:(ActiveTo'="")&&(ActiveTo<=..%SysDate())
			.S DocID=$p(^RB("RES",RowId),"^",2)
			.Q:DocID=""
			.q:('$d(^CTPCP(DocID,1)))
			.s DocCode=$p(^CTPCP(DocID,1),"^",1)
			.s OtherDesc=$p(^CTPCP(DocID,3),"^",28)
			.;Q:##class(DHCDoc.Util.Base).CheckCTCareName("CT_CareProv",DocID,MarkCodeName)'="1"
			.s UserActive="Y"
			.set Userdr=$O(^SSU("SSUSR",0,"CTPCP",DocID,"0"))
			.if Userdr'="" d
			..s UserActive=$P(^SSU("SSUSR",Userdr),"^",19)
			.q:UserActive'="Y"
			.s DocDesc=$p(^CTPCP(DocID,1),"^",2)
			.s DeptID=LocId
			.Do OutputRowResDoc
			k tmpDocListArr($j)
		}else{
			s RowId=0 f  S RowId=$o(^RB("RES",0,"CTLOC",DepID,RowId)) Q:RowId=""  d
			.Q:'($D(^RB("RES",RowId)))
			.d ResetVariables1
			.set ScheSt=$p(^RB("RES",RowId),"^",6)
			.Q:(ScheSt'="Y")
			.Q:"N"=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("RB_Resource",RowId,HospID)
			.s ActiveFrom=$p(^RB("RES",RowId),"^",22)
	        .Q:(ActiveFrom'="")&&(ActiveFrom>+$h)
	        .s ActiveTo=$p(^RB("RES",RowId),"^",23)
	        .Q:(ActiveTo'="")&&(ActiveTo<=..%SysDate())
			.S DocID=$p(^RB("RES",RowId),"^",2)
			.Q:DocID=""
			.;Q:##class(DHCDoc.Util.Base).CheckCTCareName("CT_CareProv",DocID,MarkCodeName)'="1"
			.;q:(UserID'="")&&('##class(web.DHCUserGroup).UserCanDo(UserID,DepID,DocID))
			.q:('$d(^CTPCP(DocID,1)))
			.s UserActive="Y"
			.set Userdr=$O(^SSU("SSUSR",0,"CTPCP",DocID,"0"))
			.if Userdr'="" d
			..s UserActive=$P(^SSU("SSUSR",Userdr),"^",19)
			.q:UserActive'="Y"
			.s DocCode=$p(^CTPCP(DocID,1),"^",1)
			.s OtherDesc=$p(^CTPCP(DocID,3),"^",28)
			.s DocDesc=$p(^CTPCP(DocID,1),"^",2)
			.s DeptID=DepID
			.Do OutputRowResDoc
		}	
	}
	else{
		s LocRowId=0 
		f  S LocRowId=$o(^RB("RES",0,"CTPCP",DocID,LocRowId)) Q:LocRowId=""  d
		.Q:(DepID'="")&&(DepID'=LocRowId)
		.S RowId=0
		.f  S RowId=$o(^RB("RES",0,"CTPCP",DocID,LocRowId,RowId)) Q:RowId=""  d
		..Q:'($D(^RB("RES",RowId)))
		..d ResetVariables1
		..set ScheSt=$p(^RB("RES",RowId),"^",6)
		..Q:(ScheSt'="Y")
		..Q:"N"=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("RB_Resource",RowId,HospID)
		..s ActiveFrom=$p(^RB("RES",RowId),"^",22)
        ..Q:(ActiveFrom'="")&&(ActiveFrom>+$h)
        ..s ActiveTo=$p(^RB("RES",RowId),"^",23)
        ..Q:(ActiveTo'="")&&(ActiveTo<=..%SysDate())
		..S DocID=$p(^RB("RES",RowId),"^",2)
		..Q:DocID=""
		..;Q:##class(DHCDoc.Util.Base).CheckCTCareName("CT_CareProv",DocID,MarkCodeName)'="1"
		..;q:(UserID'="")&&('##class(web.DHCUserGroup).UserCanDo(UserID,DepID,DocID))
		..q:('$d(^CTPCP(DocID,1)))
		..s UserActive="Y"
		..set Userdr=$O(^SSU("SSUSR",0,"CTPCP",DocID,"0"))
		..if Userdr'="" d
		..s UserActive=$P(^SSU("SSUSR",Userdr),"^",19)
		..q:UserActive'="Y"
		..s DocCode=$p(^CTPCP(DocID,1),"^",1)
		..s OtherDesc=$p(^CTPCP(DocID,3),"^",28)
		..s DocDesc=$p(^CTPCP(DocID,1),"^",2)
		..s DeptID=LocRowId
		..Do OutputRowResDoc
	}
	
	Quit $$$OK
OutputRowResDoc
	s DeptDesc=$p(^CTLOC(DeptID),"^",2)
	S:DeptDesc["-" DeptDesc=$p(DeptDesc,"-",2)
	s DocProveTypeID=$p(^CTPCP(DocID,1),"^",4)
	q:DocProveTypeID=""
	s DocProveType=$p(^CT("CPT",DocProveTypeID),"^",4)
	q:DocProveType'="DOCTOR"
	s DocProveTypeDesc=$p(^CT("CPT",DocProveTypeID),"^",2)
	s DocIntruduction=""
	s DocSpecDR=$p(^CTPCP(DocID,1),"^",10)  //医生专长
	i DocSpecDR'=""  s DocIntruduction=$p(^CT("SPC",DocSpecDR),"^",2)  //专长描述
	set Data=$lb(DocDesc,DocCode,DocID,RowId,DeptID,DeptDesc,DocProveTypeDesc,DocProveTypeID,DocIntruduction)
	set qHandle($I(ind))=Data
	quit
ResetVariables1
	set (DocDesc,DocCode,DocID,DeptID,DeptDesc,DocProveTypeDesc,DocProveTypeID,DocIntruduction)=""
	quit
}

ClassMethod FindResDocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindResDocExecute ]
{
	s ind=$O(qHandle(""))
	if ind{
		s Row=qHandle(ind)
		k qHandle(ind)
	}else{
		s AtEnd=1
	}
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("DHCExternalService.RegInterface.SelfRegQueryMetods","FindRBAS","","","2016-01-01","2016-02-30")
Query FindRBAS(LocID As %String = "", DocID As %String = "", StartDate As %String = "", EndDate As %String = "", HospID As %String = "") As %Query(ROWSPEC = "TStatus:%String,TSessType:%String,TDate:%String,TLocID:%String,TLocDesc:%String,TDocID:%String,TDocDesc:%String,TReason:%String,TRepDocDesc:%String,TRepDocID:%String,TTimeRange:%String,TTimeRangeDesc:%String,TResScheID:%String")
{
}

ClassMethod FindRBASExecute(ByRef qHandle As %Binary, LocID As %String = "", DocID As %String = "", StartDate As %String = "", EndDate As %String = "", HospID As %String = "") As %Status
{
 	s Job=$J
 	k ^TempDHCRBASQuery(Job)
 	s TimeRangeID=0
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
 	s Status=""
 	f  s Status=$O(^TempDHCRBASQuery(Job,"Data",Status)) q:Status=""  d
 	.s StatusDesc=$P(^DHCRBCASStatus(Status),"^",2)
 	.s Date=""
 	.f  s Date=$O(^TempDHCRBASQuery(Job,"Data",Status,Date)) q:Date=""  d
 	..s DateDesc=$ZD(Date,3)
 	..s SRBScheduleID=""
 	..f  s SRBScheduleID=$O(^TempDHCRBASQuery(Job,"Data",Status,Date,SRBScheduleID)) q:SRBScheduleID=""  d
 	...s Loc=$P(^RB("RES",+SRBScheduleID),"^",1)
 	...s Doc=$P(^RB("RES",+SRBScheduleID),"^",2)
 	...s LocDesc=$P(^CTLOC(Loc),"^",2)
 	...i $L(LocDesc,"-")>1 d
 	....s LocDesc=$P(LocDesc,"-",2,4)
 	...s DocDesc=$P($G(^CTPCP(Doc,1)),"^",2)
 	...s QtyInfo=$G(^TempDHCRBASQuery(Job,"Data",Status,Date,SRBScheduleID))
 	...d ReSetVar2
 	...s TRepDocID=$P(QtyInfo,"^",1)
 	...s:TRepDocID'="" TRepDocDesc=$P($G(^CTPCP(TRepDocID,1)),"^",2)
 	...s TTimeRange=$P(QtyInfo,"^",2)
	...s TTimeRangeCode=$p(^DHCTimeRange(TTimeRange),"^",1)
 	...s TTimeRangeDesc=$p(^DHCTimeRange(TTimeRange),"^",2)
 	...s TStatus=StatusDesc
 	...s TSessType=$P($G(^RBC("SESS",$P(QtyInfo,"^",5))),"^",2)
 	...s TDate=DateDesc
 	...s TLocDesc=LocDesc
 	...s TDocDesc=DocDesc
 	...s TReason=$P(QtyInfo,"^",3)
 	...S TResScheID=$P(QtyInfo,"^",4)
 	...s TLocID=Loc
 	...s TDocID=Doc
 	...d ListBuild
 	k ^TempDHCRBASQuery(Job)
	Quit $$$OK
OneRESInfo(RESID)
	s CurDate=StartDate-1
	f  s CurDate=$O(^RBAS(RESID,0,"DateSTime",CurDate)) q:(CurDate="")||(CurDate>EndDate)  d
	.s Time=0
	.f  s Time=$O(^RBAS(RESID,0,"DateSTime",CurDate,Time)) q:(Time="")  d
	..s Sub=0
	..f  s Sub=$O(^RBAS(RESID,0,"DateSTime",CurDate,Time,Sub)) q:(Sub="")  d
	...s CurStatus=$P(^RBAS(RESID,Sub,"DHC"),"^",10)
	...set ScheSt=$p(^RB("RES",RESID),"^",6)
	...Q:(ScheSt'="Y")
	...Q:"N"=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("RB_Resource",RESID,HospID)
	...s CurStatusCode=$p(^DHCRBCASStatus(CurStatus),"^",1)
	...Q:(CurStatusCode'="TR")&&(CurStatusCode'="S")
	...s CurReason=$P(^RBAS(RESID,Sub,"DHC"),"^",11)
	...s ReasonType=""
	...i CurReason'="" s ReasonType=$P(^RBC("NA",CurReason),"^",2)
	...s SessType=$P(^RBAS(RESID,Sub,"DHC"),"^",6)
	...q:SessType=""
	...s TimeRange=$P(^RBAS(RESID,Sub,"DHC"),"^",17)
	...q:TimeRange=""
	...s RepRESId=$P(^RBAS(RESID,Sub,"DHC"),"^",12)
	...s RepRESId=+RepRESId
	...s RepDocID=""
	...i RepRESId'=0 d
	....s RepDocID=$P(^RB("RES",RepRESId),"^",2)
	...s Qty=$P(^RBAS(RESID,Sub),"^",8)
	...s Loc=$P(^RB("RES",RESID),"^",1)
	...s Doc=$P(^RB("RES",RESID),"^",2)
	...s ResScheID=RESID_"||"_Sub
	...;s Sort=$G(^TempDHCRBASQuery(Job,"TimeRangeID",TimeRange))
	...s ^TempDHCRBASQuery(Job,"Data",CurStatus,CurDate,ResScheID)=RepDocID_"^"_TimeRange_"^"_ReasonType_"^"_ResScheID_"^"_SessType
	q
ListBuild
	set Data=$ListBuild(TStatus,TSessType,TDate,TLocID,TLocDesc,TDocID,TDocDesc,TReason,TRepDocDesc,TRepDocID,TTimeRangeCode,TTimeRangeDesc,TResScheID)
	Set qHandle($I(ind))=Data
	q
ReSetVar2
	set (TStatus,TSessType,TDate,TLocID,TLocDesc,TDocID,TDocDesc,TReason,TRepDocDesc,TRepDocID,TTimeRangeCode,TTimeRangeDesc,TResScheID)=""
	q
}

ClassMethod FindRBASFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindRBASExecute ]
{
	s ind=$O(qHandle(""))
	if ind{
		s Row=qHandle(ind)
		k qHandle(ind)
	}else{
		s AtEnd=1
	}
	Quit $$$OK
}

ClassMethod GetOPDeptStr(UserId As %String, AdmType As %String, HospitalId As %String = "") As %String
{
	s ^tmpnk("GetOPDeptStr")=UserId_","_AdmType
	;w ##class(DHCExternalService.RegInterface.SelfRegQueryMetods).GetOPDeptStr(5,"O")
	s OPDeptStr=""
	Set rset=##class(%ResultSet).%New("web.DHCOPAdmReg:OPDeptList")
	do rset.Execute(UserId,AdmType,"",HospitalId)
	Set columns = rset.GetColumnCount()
	set row=0
	While (rset.Next()) {
		set RowId=rset.GetData(1)
		s LocHospitalDR=$p($g(^CTLOC(RowId)),"^",22)
		set Deptdesc=rset.GetData(2)
		set:Deptdesc["-" Deptdesc=$p(Deptdesc,"-",2)
		set Alias=rset.GetData(3)
		if Alias="" Set Alias=$p(rset.GetData(2),"-",1)
		if OPDeptStr="" s OPDeptStr=RowId
		else  s OPDeptStr=OPDeptStr_"^"_RowId
	}
	Q OPDeptStr
}

ClassMethod OPDocListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = OPDocListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod OPDocListExecute(ByRef qHandle As %Binary, Dept As %String = "") As %Status
{
	s ^zhou("OPDoc")=Dept
	;d ##class(%ResultSet).RunQuery("DHCExternalService.RegInterface.SelfRegQueryMetods","OPDocList","41^6617^2016-04-08^^^^269^^false^^^^^Y")
	Set repid=$I(^CacheTemp)	
	If $g(ind)="" Set ind=1
	Set DeptDr=""
	
	set UserId=$p($g(Dept),"^",2)
	;如果不为空则代表是是预约的日期
	set AppDate=$p($g(Dept),"^",3)
	;PAPER_RowId
	set nid = $p($g(Dept),"^",4)
	set TimeRangeRowId=$p($g(Dept),"^",5)
	Set FindDocDr=$p($g(Dept),"^",6)
	Set GroupRowId=$p($g(Dept),"^",7)
	set FindDeptDr=$p($g(Dept),"^",1)
	set AdmReason=$p($g(Dept),"^",8)
	set PatientID=$p($g(Dept),"^",4)
	Set DiagnosCatRowId=$p($g(Dept),"^",9)
	if DiagnosCatRowId'="" Set DiagnosCatRowId=$P(DiagnosCatRowId,"!",1)
	s SocialStatus="",OldManCardId=""
	//i PatientID'="" s SocialStatus=$P(^PAPER(PatientID,"PER",1),"^",10)
	 //add by guorongyong  20090526
	i PatientID'="" d
	.s SocialStatus=$P(^PAPER(PatientID,"PER",1),"^",10)
	.s OldManCardId=$p(^PAPER(PatientID,"ALL"),"^",20)
	 //add by guorongyong  20090526	
	s NotAvailDateStr="" ;..GetNotAvailDate()
	s AppDaysLimit=##class(web.DHCOPRegConfig).GetSpecConfigNode("AppDaysLimit")
	if AppDate'=0 {
		i AppDate="" d
		.Set AdmDate=..%SysDate(),AdmTime=..%SysTime(),AdmWeek=$ZD(..%SysDate(),10)
		e  d
		.;Set AdmDate=$ZDH(AppDate,4) ,AdmTime=..%SysTime(),AdmWeek=$ZD(AppDate,10)
		.Set AdmDate=$ZDH(AppDate,3) ,AdmTime=..%SysTime(),AdmWeek=$ZD(AppDate,10)
		;确定是否在预约周期限定内
		s AllowFind=1
		i (AppDaysLimit'=""){
			s AppLimitDate=AppDaysLimit+(+$H)
			i (AppLimitDate<AdmDate) s AllowFind=0
		}
		if (NotAvailDateStr'=""){
			if ("^"_NotAvailDateStr_"^")[("^"_AdmDate_"^") s AllowFind=0
		}
		s StartDate=AdmDate
		s AdmDate1=""
		if (AppDate'=""){
			F i=StartDate:1:(StartDate+AppDaysLimit-1) {
				if (NotAvailDateStr'=""){
					if ("^"_NotAvailDateStr_"^")[("^"_i_"^") continue
				}
				i AdmDate1="" s AdmDate1=i
				e  s AdmDate1=AdmDate1_"^"_i
			
			}
		}
		i AdmDate1'="" s AdmDate=AdmDate1
	}else{
		s AdmDate=""
		s AdmTime=..%SysTime()
		s AllowFind=1
		i (AppDaysLimit=""){s AppDaysLimit=7}
		s StartDate=..%SysDate()+1
		F i=StartDate:1:(StartDate+AppDaysLimit-1) {
			if (NotAvailDateStr'=""){
				if ("^"_NotAvailDateStr_"^")[("^"_i_"^") continue
			}
			i AdmDate="" s AdmDate=i
			e  s AdmDate=AdmDate_"^"_i
			
		}
	}
	if AdmDate="" s AllowFind=0
	if (FindDeptDr="")&(FindDocDr="") s AllowFind=0
	k ^TmpSortDocList($j)
	If (AllowFind'=1) {
		Do ResetVariables2
		Do OutputNullRow 	
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	;取安全组对应的资源和诊室
	s GroupRes=##class(web.DHCOPRegConfig).GetGroupRes(GroupRowId)
	s GroupRegRoom=##class(web.DHCOPRegConfig).GetGroupRegRoom(GroupRowId)
	;FindDeptDr是包含多个科室Rowid的串
	s ResRowIdStr=##Class(web.DHCOPAdmReg).GetResRowIdStr(FindDeptDr,FindDocDr)
	i ResRowIdStr="" {
		Do ResetVariables2
		Do OutputNullRow 	
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	;得到与病人类别对应的默认费别
	i AdmReason="" s AdmReason=$$DefaultBillType(nid)
	s AdmDateStr=AdmDate
	f m=1:1:$L(AdmDateStr,"^") d
	.s AdmDate=$P(AdmDateStr,"^",m)
	.;s RowId=0 f  Set RowId=$O(^RB("RES",0,node1,node2,RowId)) Quit:RowId=""  d
	.f j=1:1:$L(ResRowIdStr,"^") d
	..s RowId=$P(ResRowIdStr,"^",j)
	..Q:'$D(^RB("RES",RowId))
	..Set DocDr=$p(^RB("RES",RowId),"^",2)
	..Set DeptDr=$p(^RB("RES",RowId),"^",1)
	..;Q:(FindDocDr'="")&&(DocDr'=FindDocDr)
	..;Q:(FindDeptDr'="")&&(DeptDr'=FindDeptDr)
	..;号别标志
	..set ScheSt=$p(^RB("RES",RowId),"^",6)
	..Quit:(ScheSt'="Y")
	..Quit:(DocDr="")
	..Q:(GroupRes'="")&&(("!"_GroupRes_"!")'[("!"_RowId_"!"))
	..;
	..;判断是否挂号对号别的权限,如果没有设定权限就可以看所有号别
	..Set UGRowId=$o(^User.DHCUserGroupI("UserNamedr",UserId,0))
	..s FindStatus=""
	..if UGRowId'="" s FindStatus=$$UserMark(UserId,DocDr)
	..Quit:(FindStatus="")&&(UGRowId'="")
	..;
	..;获取该号别的缩写,以便界面操作快速定位
	..s AbbDoc=$$GetAbbDoc(DeptDr,DocDr)
	..;
	..;查找可用排班记录
	..;w RowId_"^"_AdmDate_"^"_TimeRangeRowId,!
	..;s ASRowIdStr=##Class(web.DHCRBApptSchedule).GetAvailRA(RowId,AdmDate,AdmTime,TimeRangeRowId)
	..s ASRowIdStr=##Class(web.DHCOPAdmReg).GetMultiDateAvailRA(RowId,AdmDate,AdmTime,TimeRangeRowId)
	..
	..;w ASRowIdStr
	..Quit:ASRowIdStr=""
	..s len=$L(ASRowIdStr,"^")
	..For i=1:1:len d
	...s ASRowId=$P(ASRowIdStr,"^",i)
	...
	...s RoomDR=$P($G(^RBAS(+ASRowId,$P(ASRowId,"||",2),"DHC")),"^",5)
	...s ^guo("ASRowId",ASRowId)=GroupRegRoom_"^^^"_RoomDR
	...Q:(GroupRegRoom'="")&&(("!"_GroupRegRoom_"!"_""_"!")'[("!"_RoomDR_"!"))
	...;
	...;返回指定日期排班记录的信息串
	...s DocResValue=##Class(web.DHCOPAdmReg).GetMarkRegFee(ASRowId,AdmReason,PatientID)
	...Q:(DocResValue=0)!(DocResValue="")
	...;
	...s SessionTypeDr=$P($G(^RBAS(+ASRowId,$P(ASRowId,"||",2),"DHC")),"^",6)
	...//guorongyong 2008-04-20 start
	...s SessionTypeCode="",SESSConv=""
	...i SessionTypeDr'="" s SessionTypeCode=$P($G(^RBC("SESS",SessionTypeDr)),"^",1)
	...if SessionTypeDr'="" s SESSConv=$p($g(^RBC("SESS",SessionTypeDr)),"^",9)
	...if SESSConv="" s SESSConv="15"
    ...//guorongyong 2008-04-20 end
	...s ASDate=$P($G(^RBAS(+ASRowId,$P(ASRowId,"||",2))),"^",1) 
	...s ASTimeRange=$P($G(^RBAS(+ASRowId,$P(ASRowId,"||",2),"DHC")),"^",17) 
	...s Load=$p(DocResValue,"^",1)
	...s AppLoad=$p(DocResValue,"^",2)
	...s AddLoad=$p(DocResValue,"^",3)
	...s AvailSeqNoStr=$p(DocResValue,"^",4)
	...s AvailSeqNoCount=$l(AvailSeqNoStr,",")
	...s AvailAddSeqNoStr=$p(DocResValue,"^",5)
	...s RoomDesc=$p(DocResValue,"^",6)
	...s RoomDr=$p(DocResValue,"^",7)
	...s ClinicGroupDesc=$p(DocResValue,"^",8)
	...;s ClinicGroupDr=$p(DocResValue,"^",9)
	...s SessionTypeDesc=$p(DocResValue,"^",10)
	...;s SessionTypeDr=$p(DocResValue,"^",11)
	...;如果没能维护服务价格应该就不能挂号,这个逻辑在替诊时一样
	...s RegFeeDr="",ExamFeeDr="",HoliFeeDr="",AppFeeDr=""
	...s RegFee=$p(DocResValue,"^",12)
	...s CheckFee=$p(DocResValue,"^",14)
	...s HoliFee=$p(DocResValue,"^",16)
	...s AppFee=$p(DocResValue,"^",18)
	...;s RegFeeDr=$p(DocResValue,"^",13)
	...s ReCheckFee=$p(DocResValue,"^",15)
	...;s HoliFeeDr=$p(DocResValue,"^",17)
	...;s AppFeeDr=$p(DocResValue,"^",19)
	...s OtherFee=$p(DocResValue,"^",20)
	...s TRDesc=$p(DocResValue,"^",21)
	...;
	...s RegedCount=$p(DocResValue,"^",22)
	...s AppedCount=$p(DocResValue,"^",23)
	...s AddedCount=$p(DocResValue,"^",24)
	...s AvailAppSeqNo=$p(DocResValue,"^",25)
	...i (ASDate>+$H) s AvailSeqNoStr=AvailAppSeqNo
	...s AvailNorSeqNoStr=$p(DocResValue,"^",26)
	...;
	...s ScheduleStatus=$p(DocResValue,"^",27)
	...s ScheduleDate=$p(DocResValue,"^",28)
	...s ScheduleDateWeek=$p(DocResValue,"^",29)
	...;
	...S MarkDesc=$p(^CTPCP(DocDr,1),"^",2)
	...;i TRDesc'="" s MarkDesc=MarkDesc_"("_TRDesc_")"
	...;
	...s RoomCode=""
	...i RoomDr'="" s RoomCode=$P(^CTLOC(RoomDr),"^",43)
	...;
	...s DepDesc=$P(^CTLOC(DeptDr),"^",2)
	...q:ASTimeRange=""
	...s ^TmpSortDocList($j,DeptDr,DocDr,ASDate,ASTimeRange)=$lb(ASRowId,MarkDesc,Load,AppLoad,AddLoad,AvailSeqNoStr,AvailAddSeqNoStr,RoomDesc,ClinicGroupDesc,SessionTypeDesc,RegFee,RegFeeDr,CheckFee,ReCheckFee,HoliFee,HoliFeeDr,AppFee,OtherFee,RoomCode,DepDesc,RegedCount,AppedCount,AddedCount,AvailNorSeqNoStr,ScheduleStatus,ScheduleDate,ScheduleDateWeek,TRDesc)
	i $d(^TmpSortDocList($j)) d
	.s myDeptDr=""
	.f  s myDeptDr=$o(^TmpSortDocList($j,myDeptDr)) q:myDeptDr=""  d
	..s myDocDr=""
	..f  s myDocDr=$o(^TmpSortDocList($j,myDeptDr,myDocDr)) q:myDocDr=""  d
	...s myASDate=""
	...f  s myASDate=$o(^TmpSortDocList($j,myDeptDr,myDocDr,myASDate)) q:myASDate=""  d
	....s myASTimeRange=""
	....f  s myASTimeRange=$o(^TmpSortDocList($j,myDeptDr,myDocDr,myASDate,myASTimeRange)) q:myASTimeRange=""  d
	.....set Data=^TmpSortDocList($j,myDeptDr,myDocDr,myASDate,myASTimeRange)
	.....Do OutputRow2
	k ^TmpSortDocList($j)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow2
	;号别,诊室,职称,正号,预约限额,加号限额,加号,剩号,挂号费,诊查费,假日费  
	;set Data=$lb(ASRowId,MarkDesc,Load,AppLoad,AddLoad,AvailSeqNoStr,AvailAddSeqNoStr,RoomDesc,ClinicGroupDesc,SessionTypeDesc,RegFee,RegFeeDr,CheckFee,ReCheckFee,HoliFee,HoliFeeDr,AppFee,OtherFee,RoomCode,DepDesc,RegedCount,AppedCount,AddedCount,AvailNorSeqNoStr,ScheduleStatus,ScheduleDate,ScheduleDateWeek,TRDesc)
	;set ind=AdmDate_TRDesc_SESSConv_RowId
	Set ^CacheTemp(repid,ind)=Data
	;如果不按日期+时段来排序需要把下面的代码放开
	Set ind=ind+1
	quit
OutputNullRow
	Set DocCode="",DocDesc=""
	set Data=$lb(ASRowId,MarkDesc,Load,AppLoad,AddLoad,AvailSeqNoStr,AvailAddSeqNoStr,RoomDesc,ClinicGroupDesc,SessionTypeDesc,RegFee,RegFeeDr,CheckFee,ReCheckFee,HoliFee,HoliFeeDr,AppFee,OtherFee,RoomCode,DepDesc,RegedCount,AppedCount,AddedCount,AvailNorSeqNoStr,ScheduleStatus,ScheduleDate,ScheduleDateWeek,TRDesc)
	set ind=1
	Set ^CacheTemp(repid,ind)=Data
	;Do OutputRow2
	Quit
ResetVariables2
	///set (repid)=0
	set (ASRowId,MarkDesc,Load,AppLoad,AddLoad,AvailSeqNoStr,AvailAddSeqNoStr,RoomDesc,ClinicGroupDesc,SessionTypeDesc,RegFee,RegFeeDr,CheckFee,ReCheckFee,HoliFee,HoliFeeDr,AppFee,OtherFee,RoomCode,DepDesc,RegedCount,AppedCount,AddedCount,ScheduleStatusCode,ScheduleStatus,ScheduleDate,ScheduleDateWeek,TRDesc)=""
	quit
GetAbbDoc(DeptDr,DocDr)
	s AbbDoc=""
	s RegKingRowid=$o(^User.DHCRegKindI("RegDeptDocIndex"," "_DeptDr," "_DocDr,0))
	if RegKingRowid'="" s AbbDoc=$LIST(^User.DHCRegKindD(RegKingRowid),4)
	s AbbDoc=$ZCVT(AbbDoc,"U")
	Q AbbDoc
DefaultBillType(PatientID)
	if PatientID="" Q ""
	set PatCatDr=$p(^PAPER(nid,"PER",1),"^",10)
	i PatCatDr'="" set DHCPACADMDr=$O(^DHCPACADM(0,"Social",PatCatDr,""))
	set AdmReason=""
	if $g(DHCPACADMDr)'="" set AdmReason=$p(^DHCPACADM(DHCPACADMDr),"^",2)
	Q AdmReason
UserMark(UserId,DocDr)
	s FindStatus=""
	s UserRowId=0 f  Set UserRowId=$o(^User.DHCUserGroupI("UserNamedr"," "_UserId,UserRowId)) quit:(UserRowId="")!(FindStatus'="")  d
	.s UserDocDr=$list(^User.DHCUserGroupD(UserRowId),2)
	.if (UserDocDr=DocDr) S FindStatus=UserDocDr
	Quit FindStatus
}

ClassMethod OPDocListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = OPDocListExecute ]
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

Query OPDocList(Dept As %String = "") As %Query(ROWSPEC = "ASRowId:%String,MarkDesc:%String,Load:%String,AppLoad:%String,AddLoad:%String,AvailSeqNoStr:%String,AvailAddSeqNoStr:%String,RoomDesc:%String,ClinicGroupDesc:%String,SessionTypeDesc:%String,RegFee:%String,RegFeeDr:%String,ExamFee:%String,ReCheckFee:%String,HoliFee:%String,HoliFeeDr:%String,AppFee:%String,AppFeeDr:%String,RoomCode:%String,DepDesc:%String,RegedCount:%String,AppedCount:%String,AddedCount:%String,AvailNorSeqNoStr:%String,ScheduleStatus:%String,ScheduleDate:%String,ScheduleDateWeek:%String,TimeRange:%String")
{
}

}
