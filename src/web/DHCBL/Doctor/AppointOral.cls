Class web.DHCBL.Doctor.AppointOral Extends (DHCDoc.Util.RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

/// d ##class(web.DHCBL.Doctor.AppointOral).InitAppedData("2012-7-1",194,1001)
ClassMethod InitAppedData(InitDate, LogonLocId, DocId)
{
	;s $zt="Error"
	w "["
	s Count=0
	s InitDate=$zdh(InitDate,3)
	
	s MarkId=""
	s MarkId=$O(^User.DHCMarkDocI("MarkdDocMarkIndex",DocId,MarkId))
	if (MarkId="") s MarkId=DocId
	while(MarkId'="")
	{
		s ResRowId=$O(^RB("RES",0,"CTPCP",MarkId,LogonLocId,0))
		i ResRowId="" goto Next
		s LastAsDate=$O(^RBAS(ResRowId,0,"DateSTime",""),-1)
		i LastAsDate="" s LastAsDate=InitDate+30
		for Date=InitDate:1:LastAsDate {
			s SessStartTime=0
			for {
				s SessStartTime=$O(^RBAS(ResRowId,0,"DateSTime",Date,SessStartTime)) q:SessStartTime=""
				s ChildSub=0
				for {
					s ChildSub=$O(^RBAS(ResRowId,0,"DateSTime",Date,SessStartTime,ChildSub)) q:ChildSub="" 
					s ASDate=$p($g(^RBAS(ResRowId,ChildSub)),"^",1)
					s ASSessStartTime=$p($g(^RBAS(ResRowId,ChildSub)),"^",4)
					s ASSessEndTime=$p($g(^RBAS(ResRowId,ChildSub)),"^",5)
					s ApptChild=0,RBASAppCount=0
					for {
						s ApptChild=$O(^RBAS(ResRowId,ChildSub,"APPT",ApptChild)) q:ApptChild=""
						s ApptData=$g(^RBAS(ResRowId,ChildSub,"APPT",ApptChild))
						s ApptPapmiDr=$p(ApptData,"^",2)
						;不显示无卡预约记录
						continue:ApptPapmiDr=""
						;不显示非诊间预约和诊间加号的
						s MethodDR=$P(ApptData,"^",12)
						s MethodDesc="",MethodCode=""
						i MethodDR'="" s MethodDesc=$P(^RBC("APTM",MethodDR),"^",2),MethodCode=$P(^RBC("APTM",MethodDR),"^",1)
						continue:(MethodCode'="DOCADD")&&(MethodCode'="DOC")
						i ApptPapmiDr'="" s PAPERName= $p($g(^PAPER(ApptPapmiDr,"ALL")),"^",1)
						s ApptStatus=$p(ApptData,"^",3)
						continue:(ApptStatus'="I")&&(ApptStatus'="A")
						s AppSeqNo=$P(ApptData,"^",5)
						s TimeRange=##class(web.DHCOPAdmReg).GetAdmTimeBySeqNo(ResRowId_"||"_ChildSub,AppSeqNo)
						b //45
						if (TimeRange'=""){
							s StartTime=$p(TimeRange,"-",1)
						}else{
							s StartTime=..%ZT(ASSessStartTime,2)
						}
						s RBASAppCount=RBASAppCount+1
						s Count=Count+1
						i Count=1 {
							w "{start_date:"""_$zd(ASDate,3)_" "_StartTime_""", end_date:"""_$zd(ASDate,3)_" "_..%ZT(ASSessEndTime,2)_""", text:"""_PAPERName_"""}"
						}else{
							;如果大于4条记录就显示"......"
							i RBASAppCount>4 {
								s PAPERName="......"
								w ",{start_date:"""_$zd(ASDate,3)_" "_StartTime_""", end_date:"""_$zd(ASDate,3)_" "_..%ZT(ASSessEndTime,2)_""", text:"""_PAPERName_"""}"
								q
							}else{
								w ",{start_date:"""_$zd(ASDate,3)_" "_StartTime_""", end_date:"""_$zd(ASDate,3)_" "_..%ZT(ASSessEndTime,2)_""", text:"""_PAPERName_"""}"
							}
						}
					}
				}
			}
		}
Next
		s MarkId=$O(^User.DHCMarkDocI("MarkdDocMarkIndex",DocId,MarkId))
	}
	w "]"
	
	q
Error
	w "]"
}

/// w ##class(web.DHCBL.Doctor.Appoint).GetExpectedTimeRange(63,"","")
ClassMethod GetExpectedTimeRange(JSFunName As %String = "", ListName As %String = "", LocId As %String, DocId As %String, IntervalTime As %String) As %String
{
	s $zt="Error"
	k ^TEMPExpectedTimeRange($J)
	s ret=""
	i (IntervalTime'="")&(IntervalTime[":") s IntervalTime=..%ZTH(IntervalTime,1)
	
	s DefaultIntervalTime=""
	s CFLocIntervalTime=$P($G(^CTLOC(LocId,"DHC")),"^",8)
	s DefaultIntervalTime=CFLocIntervalTime
	
	;资源间隔时间,如果传入了间隔时间,以传入的为最新间隔时间
	if DocId'="" {
		s ResRowId=$O(^RB("RES",0,"CTPCP",DocId,LocId,0))
		if ResRowId'="" {
			i IntervalTime="" {
				s DocIntervalTime=$p($g(^RB("RES",ResRowId,"DHC")),"^",1)
				i DocIntervalTime'="" s DefaultIntervalTime=DocIntervalTime
			}else{
				s $p(^RB("RES",ResRowId,"DHC"),"^",1)=IntervalTime
				s DefaultIntervalTime=DocIntervalTime
			}
		}
	}
	
	s CFIntervalTime(1)="5^5分钟"
	s CFIntervalTime(2)="10^10分钟"
	s CFIntervalTime(3)="20^20分钟"
	s CFIntervalTime(4)="30^30分钟"
	s CFIntervalTime(5)="40^40分钟"
	s CFIntervalTime(6)="50^50分钟"
	s CFIntervalTime(7)="60^1小时"
	s CFIntervalTime(8)="90^1小时30分钟"
	s CFIntervalTime(9)="120^2小时"
	s CFIntervalTime(10)="150^2小时30分钟"
	b ;
	s RowId=""
	for {
		s RowId=$O(CFIntervalTime(RowId)) q:RowId=""
		s myInter=$p(CFIntervalTime(RowId),"^",1)
		s mydes=$p(CFIntervalTime(RowId),"^",2)
		s myval=RowId
		i DefaultIntervalTime=myInter {
			s mysel=1
		}else{
			s mysel=0
		}
		s rtnval=JSFunName_"('"_ListName_"','"_$ZCVT($g(mydes),"O","JS")_"','"_$ZCVT($g(myInter),"O","JS")_"','"_$ZCVT($g(myval),"O","JS")
		s rtnval=rtnval_"','"_$ZCVT(mysel,"O","JS")_"');"
		&javascript<#(rtnval)#>
	}
	
	Q ret
Error
	q "-1"_$ZERROR
}

ClassMethod GetApptListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetApptListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetApptListExecute(ByRef qHandle As %Binary, StartDay As %String, EndDay As %String, LogonLocId As %String, DocId As %String, PatientID As %String = "", MarkDocID As %String = "", RBResID As %String = "") As %Status
{
	s ^TMPgry("GetApptListExecute")=StartDay_","_EndDay_","_LogonLocId_","_DocId_","_PatientID_","_MarkDocID_","_RBResID
	;d ##class(%ResultSet).RunQuery("web.DHCBL.Doctor.AppointOral","GetApptList","3/8/2012","3/8/2012",194,1001,2659)
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	if $l(StartDay,"/")=3 s StartDay=$zdh(StartDay,4)
	if $l(EndDay,"/")=3 s EndDay=$zdh(EndDay,4)
	if $l(StartDay,"-")=3 s StartDay=$zdh(StartDay,3)
	if $l(EndDay,"-")=3 s EndDay=$zdh(EndDay,3)
	if EndDay="" s EndDay=StartDay
	s:StartDay="" StartDay=..%SysDate()
	s:EndDay="" EndDay=..%SysDate()
	if (StartDay="")&&(EndDay="") Set qHandle=$lb(0,repid,0) Quit $$$OK
	s StartDay=..%ZDH(StartDay)
    s EndDate=..%ZDH(EndDay)
	
	if LogonLocId="" s LogonLocId=%session.Get("LOGON.CTLOCID")
	s UserID=%session.Get("LOGON.USERID")
	if DocId="" {
		i UserID'="" s DocId=$P(^SSU("SSUSR",UserID),"^",14)
	}
	//lxz 增加预约人和就诊日期的索引直接查询医生预约的所有的记录。按照条件过滤
	for Date=StartDay:1:EndDay {
		s ResRowId=0
		for{ 
			 s ResRowId=$O(^RBAS("TransUser",UserID,Date,ResRowId)) q:ResRowId=""
			 s MarkID=$P($G(^RB("RES",+ResRowId)),"^",2)
			 Continue:((RBResID'="")&&(ResRowId'=RBResID))
			 Continue:(MarkDocID'="")&&(MarkDocID'=MarkID)
			 s ChildSub=0
			 for {
				 s ChildSub=$O(^RBAS("TransUser",UserID,Date,ResRowId,ChildSub)) q:ChildSub=""
				 s ASDate=$p($g(^RBAS(ResRowId,ChildSub)),"^",1)
				 s ApptChild=0
				 for{
				 	s ApptChild=$O(^RBAS("TransUser",UserID,Date,ResRowId,ChildSub,ApptChild)) q:ApptChild=""
				 	d GetAppMesage()
				 }
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	/*
	
	//lxz 如果传入的资源ID不为空按照资源直接查找预约记录
	if RBResID'=""{
		s ResRowId=RBResID
		for Date=StartDay:1:EndDay {
			s SessStartTime=0
			for {
				s SessStartTime=$O(^RBAS(ResRowId,0,"DateSTime",Date,SessStartTime)) q:SessStartTime=""
				s ChildSub=0
				for {
					s ChildSub=$O(^RBAS(ResRowId,0,"DateSTime",Date,SessStartTime,ChildSub)) q:ChildSub="" 
					s ASDate=$p($g(^RBAS(ResRowId,ChildSub)),"^",1)
					s ASSessStartTime=$p($g(^RBAS(ResRowId,ChildSub)),"^",4)
					s ASSessEndTime=$p($g(^RBAS(ResRowId,ChildSub)),"^",5)
					s ApptChild=0
					for {
							s ApptChild=$O(^RBAS(ResRowId,ChildSub,"APPT",ApptChild)) q:ApptChild=""
							d GetAppMesage()
					}
				}
			}
		}	
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
		
	}
	s MarkId=""
	s MarkId=$O(^User.DHCMarkDocI("MarkdDocMarkIndex",DocId,MarkId))
	while(MarkId'="")
	{

		if (MarkDocID'="")&&(MarkDocID'=MarkId) goto Next
		s ResRowId=$O(^RB("RES",0,"CTPCP",MarkId,LogonLocId,0))
		i ResRowId="" goto Next
		for Date=StartDay:1:EndDay {
			s SessStartTime=0
			for {
				s SessStartTime=$O(^RBAS(ResRowId,0,"DateSTime",Date,SessStartTime)) q:SessStartTime=""
				s ChildSub=0
				for {
					s ChildSub=$O(^RBAS(ResRowId,0,"DateSTime",Date,SessStartTime,ChildSub)) q:ChildSub="" 
					s ASDate=$p($g(^RBAS(ResRowId,ChildSub)),"^",1)
					s ASSessStartTime=$p($g(^RBAS(ResRowId,ChildSub)),"^",4)
					s ASSessEndTime=$p($g(^RBAS(ResRowId,ChildSub)),"^",5)
					s ApptChild=0
					for {
						s ApptChild=$O(^RBAS(ResRowId,ChildSub,"APPT",ApptChild)) q:ApptChild=""
						d GetAppMesage()
					}
				}
			}
		}
Next
		s MarkIdSub=$O(^User.DHCMarkDocI("MarkdDocMarkIndex"," "_DocId,MarkIdSub))
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	*/
GetAppMesage()
	s ApptData=$g(^RBAS(ResRowId,ChildSub,"APPT",ApptChild))
	s ApptPapmiDr=$p(ApptData,"^",2)
	i ApptPapmiDr'="" s PAPERName= $p($g(^PAPER(ApptPapmiDr,"ALL")),"^",1)
	s ApptStatus=$p(ApptData,"^",3)
	q:(ApptStatus'="I")&&(ApptStatus'="A")
	s DepRowId=$P(^RB("RES",ResRowId),"^",1)
	s DocRowId=$P(^RB("RES",ResRowId),"^",2)
	s DepDesc=$p($g(^CTLOC(DepRowId)),"^",2)
	s DepDesc=..FormatDesc(DepDesc)
	s DocDesc=$P($g(^CTPCP(DocRowId,1)),"^",2)
	;预约人姓名
	s AppPatientID=$P(ApptData,"^",2)
	;不显示无卡预约记录
	q:AppPatientID=""
	q:'$D(^PAPER(AppPatientID))
	s AppPatientName="",AppPatientNo="",AppPatientSex="",AppPatientAge=""
	s Telphone=""
	q:(PatientID'="")&&(AppPatientID'=PatientID)
	if AppPatientID'="" d
	.s AppPatientName=$p(^PAPER(AppPatientID,"ALL"),"^",1)
	.s AppPatientSex=$p(^CT("SEX",$p(^PAPER(AppPatientID,"ALL"),"^",7)),"^",2)
	.s AppPatientAge=+$p(^PAPER(AppPatientID,"ALL"),"^",6)
	.;s AppPatientAge=$p(((+$H-AppPatientAge)/365)+0.5,".")
	.s AppPatientAge=##class(web.PAPerson).calculateAgeUnitsShow(AppPatientID)
	.S AppPatientNo=$p(^PAPER(AppPatientID,"PAT",1),"^",1)
	.s Telphone=$p(^PAPER(AppPatientID,"PER",1),"^",11)
	s EmployeeFunction="",SecretLevel=""
	s PatEncryptLevel="" ;##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(AppPatientID,.ErrMsg)
	i PatEncryptLevel'="" {
		s EmployeeFunction=$p(PatEncryptLevel,"^",2)
		s SecretLevel=$p(PatEncryptLevel,"^",1)
	}
	;
	s StatusCode=$P(ApptData,"^",3)
	q:(StatusCode="J")
	q:(StatusCode="X")
	s StatusDesc=""
	i StatusCode="I" s StatusDesc="已预约"
	i StatusCode="A" s StatusDesc="已取号"
	i StatusCode="X" s StatusDesc="已取消"
	s AdmRowId=$P(ApptData,"^",4)
	s QueueNo=$P(ApptData,"^",5)
	;
	s ApptTypeRowId=$P(ApptData,"^",1)
	s ApptTypeCode=""
	i ApptTypeRowId'="" s ApptTypeCode=$P(^RBC("AT",ApptTypeRowId),"^",1)
	;办理预约日期,预约时间,预约办理人
	s TransDate=$P(ApptData,"^",8)
	i TransDate'="" s TransDate=..%ZD(TransDate) //$ZD(TransDate,3)
	s TransTime=$P(ApptData,"^",9)
	i TransTime'="" s TransTime=..%ZT(TransTime)
	s TransUserDR=$P(ApptData,"^",11)
	s TransUserName="",TransUserGroupRowId=""
	i TransUserDR'="" d
	.s TransUserName=$p($g(^SSU("SSUSR",TransUserDR)),"^",2)
	.s TransUserGroupRowId=$P(^SSU("SSUSR",TransUserDR),"^",5)
	q:TransUserDR'=UserID //只查询医生自己预约的号
	s MethodDR=$P(ApptData,"^",12)
	s MethodDesc=""
	i MethodDR'="" s MethodDesc=$P($g(^RBC("APTM",MethodDR)),"^",2)
	s AdmType=$P(ApptData,"^",13)
	;
	;办理取号日期/取消日期,时间
	s StatusChangeDate=$P(ApptData,"^",63)
	i StatusChangeDate'="" s StatusChangeDate=..%ZD(StatusChangeDate) //$ZD(StatusChangeDate,3)
	s StatusChangeTime=$P(ApptData,"^",64)
	i StatusChangeTime'="" s StatusChangeTime=..%ZT(StatusChangeTime)
	s StatusChangeUserDR=$P(ApptData,"^",65)
	s StatusChangeUserName=""
	i StatusChangeUserDR'="" s StatusChangeUserName=$p($g(^SSU("SSUSR",StatusChangeUserDR)),"^",2)
	;接口流水号
	s SystemSession=$P(ApptData,"^",69)
	;
	s RBASStatusDesc="",RBASStatusReason=""
 	if $d(^RBAS(ResRowId,ChildSub)) d
    .s RBASStatusDr=$P(^RBAS(ResRowId,ChildSub,"DHC"),"^",10)
 	.s RBASStatusCode=$P(^DHCRBCASStatus(RBASStatusDr),"^",1)
 	.s RBASStatusDesc=$P(^DHCRBCASStatus(RBASStatusDr),"^",2)
 	.s RBASStatusReasonDr=$P(^RBAS(ResRowId,ChildSub,"DHC"),"^",11)
 	.i RBASStatusReasonDr'="" s RBASStatusReason=$P(^RBC("NA",RBASStatusReasonDr),"^",2)
	
	s StartTime=$P($G(^RBAS(ResRowId,ChildSub)),"^",4)
	s TRRowId=$P($G(^RBAS(ResRowId,ChildSub,"DHC")),"^",17)
	;s TRRowId=##class(web.DHCRBResSession).GetTimeRangeByTime(StartTime)
	i TRRowId'="" s TRDesc=$P(^DHCTimeRange(TRRowId),"^",2)
	e  s TRDesc="其他"
	s DocDesc=DocDesc_"("_TRDesc_")"
	;
 	;被替诊的挂号记录才能显示对应的替诊排班记录
 	s TRRBASRowId="",TRDoc=""
 	i (RBASStatusCode="TR") d
 	.s TRRBASRowId=$P(^RBAS(ResRowId,ChildSub,"DHC"),"^",12)
 	.i (TRRBASRowId'="") d
	..s TRDocRowId= $P($G(^RB("RES",+TRRBASRowId)),"^",2)
 	..s TRDoc=$p($g(^CTPCP(TRDocRowId,1)),"^",2)
	
	s RBASRowId=ResRowId_"||"_ChildSub
	s FeeStr="||||||1"
	s APPTRowId=ResRowId_"||"_ChildSub_"||"_ApptChild
	s NeedAppFee=##class(web.DHCRBAppointment).NeedAppFee(APPTRowId)
	s FeeStr="1||1||0||0"
	i NeedAppFee="1" s FeeStr="1||1||0||1"
	s PatCatDr=$p(^PAPER(AppPatientID,"PER",1),"^",10)
	s AdmReason=##class(web.DHCOPAdmReg).GetDefaultBillType(PatCatDr)
	s Sum=##class(web.DHCOPAdmReg).GetScheduleFee(RBASRowId,AdmReason,+$H,FeeStr,AppPatientID)
	s AppIntervalTime="" ;##class(web.DHCRBAppointment).GetAppIntervalTime(APPTRowId)
	s Remark=$g(^RBAS(ResRowId,ChildSub,"APPT",ApptChild,"REM",1))
	;lxz 获取分时段建议就诊时段
	s TTimeRange=##class(web.DHCOPAdmReg).GetAdmTimeBySeqNo(RBASRowId,QueueNo)
	s RowId=ResRowId_"||"_ChildSub_"||"_ApptChild
	s AppDateHTML=..%ZD(ASDate) //$ZD(ASDate,3)
	s Data=$lb(RowId,AppDateHTML,AppTime,DepDesc,DocDesc,AppPatientID,AppPatientNo,AppPatientName,AppPatientSex,AppPatientAge,StatusCode,StatusDesc,MethodDesc,QueueNo,Sum,RBASStatusDesc,TRDoc,RBASStatusReason,TransDate,TransTime,TransUserName,StatusChangeDate,StatusChangeTime,StatusChangeUserName,SystemSession,RBASStatusCode,AppIntervalTime,Remark,ind,EmployeeFunction,SecretLevel,Telphone,TTimeRange)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	q
}

ClassMethod GetApptListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetApptListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else{				// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 // Save QHandle
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query GetApptList(StartDay As %String, EndDay As %String, LogonLocId As %String, DocId As %String, PatientID As %String = "", MarkDocID As %String = "", RBResID As %String = "") As %Query(ROWSPEC = "RowId:%String,AppDate:%String,AppTime:%String,DepDesc:%String,DocDesc:%String,PatientID:%String,PatientNo:%String,PatientName:%String,AppPatientSex:%String,AppPatientAge:%String,StatusCode:%String,StatusDesc:%String,MethodDesc:%String,QueueNo:%String,Sum:%String,RBASStatusDesc:%String,TRDoc:%String,RBASStatusReason:%String,TransDate:%String,TransTime:%String,TransUserName:%String,StatusChangeDate:%String,StatusChangeTime:%String,StatusChangeUserName:%String,SystemSession:%String,RBASStatusCode:%String,AppIntervalTime:%String,Remark:%String,LineNum:%String,TPoliticalLevel:%String,TSecretLevel:%String,TPhone:%String,TTimeRange:%String")
{
}

ClassMethod GetPatDetailById(itmjs As %Library.String = "", itmjsex As %Library.String = "", patientid As %Library.String = "")
{
	Set (id,code,desc)=""
	Set PatDr=patientid
	Quit:PatDr="" 0
	s CardID=$o(^DHCCARDi("CF",0,"PAPMIDR",PatDr,0))
	Set cardNo=$p(^DHCCARD("CF",CardID),"^",2)  //$p(^DHCCARD("CF",PatDr),"^",2)
	
	Set Name=$p(^PAPER(PatDr,"ALL"),"^",1)
	set RIDCardNo=$p($g(^PAPER(PatDr,"ALL")),"^",9)
	Set Age=+$p(^PAPER(PatDr,"ALL"),"^",6)
	Set Age=$p(((+$H-Age)/365)+0.5,".")
	Set Sex=$p(^CT("SEX",$p(^PAPER(PatDr,"ALL"),"^",7)),"^",2)
	Set OPMRN="",IPMRN="",RAddress=""
	if $D(^PAPER(PatDr,"PER",4)) d
	.Set OPMRN=$p(^PAPER(PatDr,"PER",4),"^",4)
	.set RAddress=$p(^PAPER(PatDr,"PER",4),"^",18) 
	//if $D(^PAPER(PatDr,"PER",1)) d
	Set IPMRN=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(PatDr,"")
	Set PatCat=""
	if $D(^PAPER(PatDr,"PER",1)) d
	.Set PatCatDr=$p(^PAPER(PatDr,"PER",1),"^",10)
	If PatCatDr'="" Set PatCat=$p(^CT("SS",PatCatDr),"^",1)_"."_$p(^CT("SS",PatCatDr),"^",2)
	s AppBreakCount=##class(web.DHCRBAppointment).GetAppBreakCount(PatDr)
	Set desc=Name_"^"_Age_"^"_Sex_"^"_OPMRN_"^"_IPMRN_"^"_PatCat_"^"_PatDr_"^"_RIDCardNo_"^"_RAddress_"^"_patientid_"^"_AppBreakCount_"^"_cardNo
	set retval=itmjs_"('"_$ZCVT(desc,"O","JS")_"');"
	i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(desc,"O","JS")_"^"_id_"^"_$ZCVT(code,"O","JS")_"');"
	&javascript<#(retval)#>
	q 1
}

ClassMethod FormatDesc(Desc As %String)
{
	s Desc1=$P(Desc,"-",2)
	if Desc1'="" s Desc=Desc1
	Q Desc
}

ClassMethod GetDateList(StartDate As %String, LogonLocId As %String, DocId As %String, selMarkDocID As %String = "", MarkOther As %String = "")
{
	s DateList=""
	//q:selMarkDocID="" ""
	s StartDate=$ZDH(StartDate,3)
	s EndDate=StartDate+45
	if (MarkOther'=""){
		s ResRowId=MarkOther
		d GetDateList
	}else{
		if (selMarkDocID=""){
			s MarkId=""
			for{
				s MarkId=$O(^User.DHCMarkDocI("MarkdDocMarkIndex",DocId,MarkId))
				q:(MarkId="")
				s ResRowId=$O(^RB("RES",0,"CTPCP",MarkId,LogonLocId,0))
				i ResRowId="" continue
				d GetDateList
			}
		}else{
			s ResRowId=$o(^RB("RES",0,"CTPCP",DocId,LogonLocId,0))
			if (ResRowId'=""){
				d GetDateList
			}
		}
	}
	
	//如果传入的号别没有对照,则取该号别对应的出诊记录
	/*if '$d(^User.DHCMarkDocI("MarkdDocMarkIndex",DocId)){
		s ResRowId=$o(^RB("RES",0,"CTPCP",DocId,LogonLocId,0))
		if (ResRowId'=""){
			d GetDateList
		}
	}*/
   q DateList
GetDateList
	for Date=StartDate:1:EndDate {
		s ASSessStartTime="" 
		s Have="N"
		f  {
			s ASSessStartTime=$O(^RBAS(ResRowId,0,"DateSTime",Date,ASSessStartTime)) 
			q:((ASSessStartTime="")||(Have="Y"))
			s ASChildSub=0  
			f  {
				s ASChildSub=$O(^RBAS(ResRowId,0,"DateSTime",Date,ASSessStartTime,ASChildSub))
				q:((ASChildSub="")||(Have="Y"))
				s status=$P($G(^RBAS(ResRowId,ASChildSub,"DHC")),"^",10)
				i status'="" s status=$P(^DHCRBCASStatus(status),"^",1)
				;过滤停诊和替诊
				continue:(status="S")||(status="TR")||(status="PS")
				s Have="Y"
			}
		}
		if (Have="Y"){
			continue:(DateList[$ZD(Date,3))
			if (DateList=""){
				s DateList=$ZD(Date,3)
			}else{
				s DateList=DateList_"^"_$ZD(Date,3)
			}
		}
	}
}

Query GetOtherLocList(desc As %String, UserID As %String, CTLOC As %String) As %Query(ROWSPEC = "CTDesc:%String:科室,CTRowId:%String")
{
}

ClassMethod GetOtherLocListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOtherLocListExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetOtherLocListExecute(ByRef qHandle As %Binary, desc As %String, UserID As %String, CTLOC As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	k GetOPLocList
    /*if CTLOC'=""  d 
	.if $D(^User.DHCDocRegDocAppointI("RDAPPRegLocDRIndex",CTLOC))=10  d
	..s sub1=0
	..f  s sub1=$O(^User.DHCDocRegDocAppointI("RDAPPRegLocDRIndex",CTLOC,sub1))  Q:sub1=""  d
	...s RBASDr=$LG(^User.DHCDocRegDocAppointD(sub1),3)
	...s LocIDsub=$p($g(^RB("RES",+RBASDr)),"^",1)
    ...s GetOPLocList(LocIDsub)=""*/
    Set langid=..%LanguageID()
    s DoctorID=##class(web.SSUser).GetDefaultCareProvider(UserID)
    s CanDoStr=##class(web.DHCDocRegDocAppiont).GetAppCanDo(CTLOC,DoctorID)
    if CanDoStr'=""{
        s CanDoLen=$l(CanDoStr,"^")
        for loop=1:1:CanDoLen{
            s OneCanDoStr=$p(CanDoStr,"^",loop)
            s RBASDr=$p(OneCanDoStr,"!",1)
            continue:RBASDr=""
            s LocIDsub=$p($g(^RB("RES",+RBASDr)),"^",1)
            continue:'$d(^CTLOC(LocIDsub))
            s GetOPLocList(LocIDsub)=""
        }
    }
	s AdmType="O^E"
	s Len=$L(AdmType,"^")
	for i=1:1:Len  {
		s AdmTypePut=$P(AdmType,"^",i)
		s RowId=0 f  s RowId=$O(^PAC("ADMLOC",0,"AdmType",AdmTypePut,RowId)) Q:RowId=""  d
		.Q:'$d(^RB("RES",0,"CTLOC",RowId))
		.s LocDateTo=$p($g(^CTLOC(RowId)),"^",25)
		.Q:(LocDateTo'="")&&(LocDateTo<+$H)
		.s CTDesc=$p($g(^CTLOC(RowId)),"^",2)
		.s CTDesc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",CTDesc,langid)
		.s CTAliasTem=""
		.i $l(CTDesc,"-")>1 s CTAliasTem=$P(CTDesc,"-",1)
		.s CTAlias=$P(^CTLOC(RowId),"^",43)
		.Q:('$D(GetOPLocList(RowId)))
		.i CTAlias="" s CTAlias=CTAliasTem
		.Q:##class(web.DHCOPAdmReg).CheckLocDesc(RowId,desc)'=1
		.s CTRowId=RowId
		.s CTCode=CTRowId
		.s CTLOCMarkNO=##class(web.DHCBL.BDP.BDPSort).GetSortNum("User.CTLoc","正式",CTRowId)
		.i CTLOCMarkNO="" s CTLOCMarkNO="999"
	    .s GetOPLocList("RegCTLocLookup",CTLOCMarkNO,CTRowId)=CTDesc_"^"_CTAlias   //建立临时Globle
	
	}
	//按照序号排序
	
	s DesStr=""
	s seq="" for {
		s seq=$O(GetOPLocList("RegCTLocLookup",seq))
		Quit:seq=""
		s seq1="" for {
			s seq1=$O(GetOPLocList("RegCTLocLookup",seq,seq1))
			Quit:seq1=""
			s temp=GetOPLocList("RegCTLocLookup",seq,seq1)
			s CTRowId=seq1
			s CTDesc=$P(temp,"^",1)
			Do OutputRow1
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow1
	 set Data=$lb(CTDesc,CTRowId)
	 Set ^CacheTemp(repid,ind)=Data
	 Set ind=ind+1
	quit
}

ClassMethod GetOtherLocListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOtherLocListExecute ]
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

/// lxz 获取日历预约可以预约的科室ID
/// w ##class(web.DHCBL.Doctor.AppointOral).GetOPLocList("","")
ClassMethod GetOPLocList(UserID As %String, CTLOC As %String) As %String
{
	k GetOPLocList
	/*if CTLOC'=""  d 
	.if $D(^DHCDocRegConfig("LocCanAPP",CTLOC))=10  d
	..s sub1=0
	..f  s sub1=$O(^DHCDocRegConfig("LocCanAPP",CTLOC,sub1))  Q:sub1=""  d
	...s LocIDsub=$p($g(^RB("RES",+sub1)),"^",1)
	...s GetOPLocList(LocIDsub)=""
	*/
	if CTLOC'=""  d 
	.if $D(^User.DHCDocRegDocAppointI("RDAPPRegLocDRIndex",CTLOC))=10  d
	..s sub1=0
	..f  s sub1=$O(^User.DHCDocRegDocAppointI("RDAPPRegLocDRIndex",CTLOC,sub1))  Q:sub1=""  d
	...s RBASDr=$LG(^User.DHCDocRegDocAppointD(sub1),3)
	...s LocIDsub=$p($g(^RB("RES",+RBASDr)),"^",1)
	...s GetOPLocList(LocIDsub)=""
	
	s AdmType="O^E"
	s Len=$L(AdmType,"^")
	for i=1:1:Len  {
		s AdmTypePut=$P(AdmType,"^",i)
		s RowId=0 f  s RowId=$O(^PAC("ADMLOC",0,"AdmType",AdmTypePut,RowId)) Q:RowId=""  d
		.Q:'$d(^RB("RES",0,"CTLOC",RowId))
		.s LocDateTo=$p($g(^CTLOC(RowId)),"^",25)
		.Q:(LocDateTo'="")&&(LocDateTo<+$H)
		.s CTDesc=$p($g(^CTLOC(RowId)),"^",2)
		.s CTAliasTem=""
		.i $l(CTDesc,"-")>1 s CTAliasTem=$P(CTDesc,"-",1)
		.s CTAlias=$P(^CTLOC(RowId),"^",43)
		.Q:('$D(GetOPLocList(RowId)))
		.i CTAlias="" s CTAlias=CTAliasTem
		.s CTRowId=RowId
		.s CTCode=CTRowId
		.s CTLOCMarkNO=##class(web.DHCBL.BDP.BDPSort).GetSortNum("User.CTLoc","正式",CTRowId)
		.i CTLOCMarkNO="" s CTLOCMarkNO="999"
	    .s GetOPLocList("RegCTLocLookup",CTLOCMarkNO,CTRowId)=CTDesc_"^"_CTAlias   //建立临时Globle
	
	}
	//按照序号排序
	
	s DesStr=""
	s seq="" for {
		s seq=$O(GetOPLocList("RegCTLocLookup",seq))
		Quit:seq=""
		s seq1="" for {
			s seq1=$O(GetOPLocList("RegCTLocLookup",seq,seq1))
			Quit:seq1=""
			s temp=GetOPLocList("RegCTLocLookup",seq,seq1)
			s CTRowId=seq1
			s CTDesc=$P(temp,"^",1)
			s CTAlias=$P(temp,"^",2)
			if DesStr=""  d
			.s DesStr=CTRowId_$C(1)_CTAlias_"-"_CTDesc
			else  d
			.s DesStr=DesStr_"^"_CTRowId_$C(1)_CTAlias_"-"_CTDesc
		}
	}
	q DesStr
}

/// lxz 
/// 挂号升级查找可用的其他科室的号别
/// w ##class(web.DHCBL.Doctor.AppointOral).FindDocMarkStrNew(10919,4,53)
ClassMethod FindDocMarkStrNew(UserID As %String = "", LocID As %String = "", LogOnLoc As %String = "") As %String
{
	s ^Tempzong("FindMarkStr")=UserID_","_LocID_","_LogOnLoc
	//^DHCDocRegConfig("LocCanAPP",LocID,RBASDr)
	s DoctorID=""
 	if UserID'="" s DoctorID=##class(web.SSUser).GetDefaultCareProvider(UserID)
	s Ret=""
	k FindDocMarkStrNew
	if LocID'=""  d
	.s ResRowId=0
	.f  s ResRowId=$o(^RB("RES",0,"CTLOC",LocID,ResRowId)) quit:ResRowId=""  d
	..s MarkID=$p($g(^RB("RES",ResRowId)),"^",2)
	..Q:MarkID=""
	..s Ctloc=$p($g(^RB("RES",ResRowId)),"^",1)
	..s ScheSt=$p(^RB("RES",ResRowId),"^",6)
	..Q:ScheSt'="Y"
	..Q:$D(FindDocMarkStrNew(MarkID))
	..s MarkDesc=$p($g(^CTPCP(MarkID,1)),"^",2)
	..Q:$D(FindDocMarkStrNew(MarkID))
	..;s myRowID=$o(^User.DHCDocRegDocAppointI("RDAPPLocResIndex",LogOnLoc,ResRowId,""))
	..s myRowID=##class(web.DHCDocRegDocAppiont).GetAppCanDoRBAS(LogOnLoc,ResRowId,DoctorID)
	..Q:((LogOnLoc'="")&&(myRowID=""))
	..s FindDocMarkStrNew(MarkID)=""
	..if Ret=""  s Ret=ResRowId_$C(1)_MarkDesc
	..else  s Ret=Ret_"^"_ResRowId_$C(1)_MarkDesc
 	Q Ret
}

/// w ##class(web.DHCBL.Doctor.AppointOral).InitAppedDataNew("2018-3-08",17,818,818,"",11401")
/// lxz 显示新的预约.显示剩余号
ClassMethod InitAppedDataNew(InitDate, LogonLocId, DocId, MarkIDIn As %String = "", MarkOtherID As %String = "", USERID As %String = "")
{
	s ^lxz("InitAppedDataNew")=InitDate_","_LogonLocId_","_DocId_","_MarkIDIn_","_MarkOtherID_","_USERID
	;s $zt="Error"
	if MarkOtherID'="" {
		d ..GetMesageBYReresID(InitDate,MarkOtherID,USERID)
		q 
	}
	w "["
	s Count=0
	s InitDate=$zdh(InitDate,3)
	s MarkIdsub=""

	s MarkIdsub=$O(^User.DHCMarkDocI("MarkdDocMarkIndex",DocId,MarkIdsub))
	while($tr(MarkIdsub," ","")'="")&&(MarkIDIn'="")
	{   s MarkId=$tr(MarkIdsub," ","")
		if ((MarkIDIn'="")&&(MarkId'=MarkIDIn)){
			goto Next
		}
		s ResRowId=$O(^RB("RES",0,"CTPCP",MarkId,LogonLocId,0))
		i ResRowId="" goto Next
		s LastAsDate=$O(^RBAS(ResRowId,0,"DateSTime",""),-1)
		s AppDaysLimit=##class(web.DHCOPRegConfig).GetSpecConfigNode("AppDaysLimit")
		s:AppDaysLimit=0 AppDaysLimit=60
		i LastAsDate="" s LastAsDate=InitDate+AppDaysLimit
		s AdmDocID=$P($G(^RB("RES",+ResRowId)),"^",2)
		s AdmDoc=$p($G(^CTPCP(AdmDocID,1)),"^",2)
		for Date=InitDate:1:LastAsDate {
			s SessStartTime=""
			for {
				s FinAPP=0
				s HavePrint="N"
				s SessStartTime=$O(^RBAS(ResRowId,0,"DateSTime",Date,SessStartTime)) q:SessStartTime=""
				s ChildSub=0
				for {
					
					//医生加号
					if Date=..%SysDate() s MethodCode="DOCADD" 
					e  s MethodCode="DOC"
					s APPMethodRowId=""
			 		i MethodCode'="" s APPMethodRowId=$O(^RBC("APTM",0,"Code",MethodCode,0))
					
					s ChildSub=$O(^RBAS(ResRowId,0,"DateSTime",Date,SessStartTime,ChildSub)) q:ChildSub="" 
					s CanDo=0  s ArriveCount=0
					s ASDate=$p($g(^RBAS(ResRowId,ChildSub)),"^",1)
					s ASSessStartTime=$p($g(^RBAS(ResRowId,ChildSub)),"^",4)
					s ASSessEndTime=$p($g(^RBAS(ResRowId,ChildSub)),"^",5)
					s TRRowId=$P($G(^RBAS(+ResRowId,ChildSub,"DHC")),"^",17)
					s TRDesc=""
					s:TRRowId'="" TRDesc=$P(^DHCTimeRange(TRRowId),"^",2)
					s APPQty=##class(web.DHCRBApptScheduleAppQty).GetAPPMethodQty(ResRowId_"||"_ChildSub,MethodCode)
					
					Set StatusDr=$P($G(^RBAS(ResRowId,ChildSub,"DHC")),"^",10)
					s Status=""
					i StatusDr'="" {
						s Status=$P($G(^DHCRBCASStatus(StatusDr)),"^",1)
						s StatusDesc=$P($G(^DHCRBCASStatus(StatusDr)),"^",2)
					}
					Continue:(Status="S")||(Status="TR")||(Status="PS")
					;默认是不找不规则出诊记录的
					s ASIrregularFlag=$p($g(^RBAS(ResRowId,ChildSub)),"^",13)
					continue:(ASIrregularFlag="A")
					
					s ASQueueNo=$P(^RBAS(ResRowId,ChildSub,"DHC"),"^",4)
	 				;正号串与加号串
	 				s NormalQueueNoStr=$P(ASQueueNo,$C(1),1)
	 				s AddQueueNoStr=$P(ASQueueNo,$C(1),2)
	 				s ArriveCount=0,CanDo=0
			 		for i=1:1:$l(NormalQueueNoStr,",") {
				 		s SingleQueueNoStr=$P(NormalQueueNoStr,",",i)
				 		s QueueNoStatus=$P(SingleQueueNoStr,":",2)
				 		s QueueNo=$P(SingleQueueNoStr,":",1)
				 		s QueueNoMethodRowId=$P(SingleQueueNoStr,":",3)
				 		s QueueNoInAppFlag=+##class(web.DHCRBApptScheduleAppQty).CheckQueueNoInApp(ResRowId_"||"_ChildSub,QueueNo,APPMethodRowId)
				 		i ((QueueNoStatus=2)||(QueueNoStatus=3)){
					 		if QueueNoInAppFlag=1 {s ArriveCount=ArriveCount+1}
					 	}
					 	elseif(QueueNoStatus=0){
						 	if QueueNoInAppFlag=1 {s CanDo=CanDo+1}
						}
				 	}
				 	
				 	//s TRDesc=ResRowId_"||"_ChildSub
				 	s NUMA=0
				 	i AddQueueNoStr'="" s NUMA=$l(AddQueueNoStr,",")
				 	s AddUser=0
				 	s AddCanDo=0
				 	for i=1:1:$l(AddQueueNoStr,",") {
					 	s SingleQueueNoStr=$P(AddQueueNoStr,",",i)
					 	s QueueNoStatus=$P(SingleQueueNoStr,":",2)
					 	s QueueNo=$P(SingleQueueNoStr,":",1)
					 	;未取号和已退号的可用
					 	i ((QueueNoStatus=0)||('##class(web.DHCRBAppointment).GetReturnAllowRegFlag(QueueNoStatus))){
							s AddCanDo=AddCanDo+1
					 	}
						else{
							s AddUser=AddUser+1
						}
		 			}
		 			
		 			s ApptChild=0
					for  s ApptChild=$O(^RBAS(ResRowId,ChildSub,"APPT",ApptChild)) q:ApptChild=""  d
					.s ApptData=$g(^RBAS(ResRowId,ChildSub,"APPT",ApptChild))
					.s TransUserDR=$P(ApptData,"^",11)
					.Q:(TransUserDR'=USERID)&&(USERID'="") //只查询医生自己预约的号
					.s ApptPapmiDr=$p(ApptData,"^",2)
					.;不显示无卡预约记录
					.Q:ApptPapmiDr=""
					.;不显示非诊间预约和诊间加号的
					.s MethodDR=$P(ApptData,"^",12)
					.s MethodDesc="",MethodCode=""
					.i MethodDR'="" s MethodDesc=$P(^RBC("APTM",MethodDR),"^",2),MethodCode=$P(^RBC("APTM",MethodDR),"^",1)
					.Q:(MethodCode'="DOCA")&&(MethodCode'="DOC")
					.i ApptPapmiDr'="" s PAPERName= $p($g(^PAPER(ApptPapmiDr,"ALL")),"^",1)
					.s ApptStatus=$p(ApptData,"^",3)
					.Q:(ApptStatus'="I")&&(ApptStatus'="A")
					.s FinAPP=FinAPP+1
					
		 			Continue:Date<+$H
				 	Continue:(Date=..%SysDate())&&(NUMA=0)
				 	continue:(Date'=..%SysDate())&&(APPQty=0)
				 	if (Date=..%SysDate())&&(NUMA'=0){
					 	if Count=0{
			 				w "{start_date:"""_$zd(ASDate,3)_" "_..%ZT(ASSessStartTime)_""", end_date:"""_$zd(ASDate,3)_" "_..%ZT(ASSessStartTime)_""", text:"""_"(+)"_TRDesc_":"_"""}"
							w ",{start_date:"""_$zd(ASDate,3)_" "_..%ZT(ASSessEndTime)_""", end_date:"""_$zd(ASDate,3)_" "_..%ZT(ASSessEndTime)_""", text:"""_" "_NUMA_"-"_AddUser_"-"_AddCanDo_"""}"
				 		}else{
					 		w ",{start_date:"""_$zd(ASDate,3)_" "_..%ZT(ASSessStartTime)_""", end_date:"""_$zd(ASDate,3)_" "_..%ZT(ASSessStartTime)_""", text:"""_"(+)"_TRDesc_":"_"""}"
							w ",{start_date:"""_$zd(ASDate,3)_" "_..%ZT(ASSessEndTime)_""", end_date:"""_$zd(ASDate,3)_" "_..%ZT(ASSessEndTime)_""", text:"""_" "_NUMA_"-"_AddUser_"-"_AddCanDo_"""}"
				 		
					 	}
					 }
				 	elseif (APPQty'=0){
				 		if Count=0{
			 				w "{start_date:"""_$zd(ASDate,3)_" "_..%ZT(ASSessStartTime)_""", end_date:"""_$zd(ASDate,3)_" "_..%ZT(ASSessStartTime)_""", text:"""_TRDesc_":"_"""}"
							w ",{start_date:"""_$zd(ASDate,3)_" "_..%ZT(ASSessEndTime)_""", end_date:"""_$zd(ASDate,3)_" "_..%ZT(ASSessEndTime)_""", text:"""_" "_APPQty_"-"_ArriveCount_"-"_CanDo_"""}"
				 		}else{
					 		w ",{start_date:"""_$zd(ASDate,3)_" "_..%ZT(ASSessStartTime)_""", end_date:"""_$zd(ASDate,3)_" "_..%ZT(ASSessStartTime)_""", text:"""_TRDesc_":"_"""}"
							w ",{start_date:"""_$zd(ASDate,3)_" "_..%ZT(ASSessEndTime)_""", end_date:"""_$zd(ASDate,3)_" "_..%ZT(ASSessEndTime)_""", text:"""_" "_APPQty_"-"_ArriveCount_"-"_CanDo_"""}"
				 		}
				 	}
					s Count=Count+1
					s HavePrint="Y"
				}
				//输出当月之前的数据-或者在调整排版之前存在预约的数据
				if (HavePrint="N")&&(FinAPP'="0"){
					if (Count=0){
				    	//w "{start_date:"""_$zd(ASDate,3)_""", end_date:"""_$zd(ASDate,3)_""", text:"""_AdmDoc_":"_"""}"
						w "{start_date:"""_$zd(ASDate,3)_""", end_date:"""_$zd(ASDate,3)_""", text:"""_FinAPP_"条记录"_"""}"
					}else{
						 //w ",{start_date:"""_$zd(ASDate,3)_""", end_date:"""_$zd(ASDate,3)_""", text:"""_AdmDoc_":"_"""}"
						w ",{start_date:"""_$zd(ASDate,3)_""", end_date:"""_$zd(ASDate,3)_""", text:"""_FinAPP_"条记录"_"""}"
					}
				 	s Count=Count+1	
			   }
			}
		}
Next
		s MarkIdsub=$O(^User.DHCMarkDocI("MarkdDocMarkIndex",DocId,MarkIdsub))
	}
	w "]"
	
	q
Error
	w "]"
}

/// lxz --如果界面上选择了其他的科室其他的号别 按照传入的资源ID查找相关的排班信息
ClassMethod GetMesageBYReresID(InitDate As %String, ResRowId As %String, USERID As %String) As %String
{
	
	w "["
	s Count=0
	s:InitDate["-" InitDate=$zdh(InitDate,3)
	s:InitDate["/" InitDate=$zdh(InitDate,3)
	s LastAsDate=$O(^RBAS(ResRowId,0,"DateSTime",""),-1)
	s AppDaysLimit=##class(web.DHCOPRegConfig).GetSpecConfigNode("AppDaysLimit")
	s:AppDaysLimit=0 AppDaysLimit=60
	i LastAsDate="" s LastAsDate=InitDate+AppDaysLimit
	s AdmDocID=$P($G(^RB("RES",+ResRowId)),"^",2)
	s AdmDoc=$p($G(^CTPCP(AdmDocID,1)),"^",2)
	for Date=InitDate:1:LastAsDate {
	s SessStartTime=""
	for {
		s FinAPP=0
		s HavePrint="N"
		s SessStartTime=$O(^RBAS(ResRowId,0,"DateSTime",Date,SessStartTime)) q:SessStartTime=""
		s ChildSub=0
		for {
			//医生加号
			if Date=..%SysDate() s MethodCode="DOCADD" 
			e  s MethodCode="DOC"
			s APPMethodRowId=""
		 	i MethodCode'="" s APPMethodRowId=$O(^RBC("APTM",0,"Code",MethodCode,0))
			s ChildSub=$O(^RBAS(ResRowId,0,"DateSTime",Date,SessStartTime,ChildSub)) q:ChildSub="" 
			s CanDo=0  s ArriveCount=0
			s ASDate=$p($g(^RBAS(ResRowId,ChildSub)),"^",1)
			s ASSessStartTime=$p($g(^RBAS(ResRowId,ChildSub)),"^",4)
			s ASSessEndTime=$p($g(^RBAS(ResRowId,ChildSub)),"^",5)
			s TRRowId=$P($G(^RBAS(+ResRowId,ChildSub,"DHC")),"^",17)
			s TRDesc=""
			s:TRRowId'="" TRDesc=$P(^DHCTimeRange(TRRowId),"^",2)
			s APPQty=##class(web.DHCRBApptScheduleAppQty).GetAPPMethodQty(ResRowId_"||"_ChildSub,MethodCode)
			
			Set StatusDr=$P($G(^RBAS(ResRowId,ChildSub,"DHC")),"^",10)
			s Status=""
			i StatusDr'="" {
			s Status=$P($G(^DHCRBCASStatus(StatusDr)),"^",1)
			s StatusDesc=$P($G(^DHCRBCASStatus(StatusDr)),"^",2)
			}
			Continue:(Status="S")||(Status="TR")||(Status="PS")
			;默认是不找不规则出诊记录的
			s ASIrregularFlag=$p($g(^RBAS(ResRowId,ChildSub)),"^",13)
			continue:(ASIrregularFlag="A")
			
			
			s ASQueueNo=$P(^RBAS(ResRowId,ChildSub,"DHC"),"^",4)
			;正号串与加号串
			s NormalQueueNoStr=$P(ASQueueNo,$C(1),1)
			s AddQueueNoStr=$P(ASQueueNo,$C(1),2)
			s ArriveCount=0,CanDo=0
		 	for i=1:1:$l(NormalQueueNoStr,",") {
		 		s SingleQueueNoStr=$P(NormalQueueNoStr,",",i)
		 		s QueueNoStatus=$P(SingleQueueNoStr,":",2)
		 		s QueueNo=$P(SingleQueueNoStr,":",1)
		 		s QueueNoMethodRowId=$P(SingleQueueNoStr,":",3)
		 		s QueueNoInAppFlag=+##class(web.DHCRBApptScheduleAppQty).CheckQueueNoInApp(ResRowId_"||"_ChildSub,QueueNo,APPMethodRowId)
		 		i ((QueueNoStatus=2)||(QueueNoStatus=3)){
			 		if QueueNoInAppFlag=1 {s ArriveCount=ArriveCount+1}
			 	}
			 	elseif(QueueNoStatus=0){
				 	if QueueNoInAppFlag=1 {s CanDo=CanDo+1}
				}
			 }
		 	
		 	s NUMA=0
		 	i AddQueueNoStr'="" s NUMA=$l(AddQueueNoStr,",")
		 	s AddUser=0
		 	s AddCanDo=0
		 	for i=1:1:$l(AddQueueNoStr,",") {
			 	s SingleQueueNoStr=$P(AddQueueNoStr,",",i)
			 	s QueueNoStatus=$P(SingleQueueNoStr,":",2)
			 	s QueueNo=$P(SingleQueueNoStr,":",1)
			 	;未取号和已退号的可用
			 	i ((QueueNoStatus=0)||('##class(web.DHCRBAppointment).GetReturnAllowRegFlag(QueueNoStatus))){
					s AddCanDo=AddCanDo+1
			 	}
				else{
					s AddUser=AddUser+1
				}
			}
		
			s ApptChild=0
			for  s ApptChild=$O(^RBAS(ResRowId,ChildSub,"APPT",ApptChild)) q:ApptChild=""  d
			.s ApptData=$g(^RBAS(ResRowId,ChildSub,"APPT",ApptChild))
			.s TransUserDR=$P(ApptData,"^",11)
			.Q:(TransUserDR'=USERID)&&(USERID'="") //只查询医生自己预约的号
			.s ApptPapmiDr=$p(ApptData,"^",2)
			.;不显示无卡预约记录
			.Q:ApptPapmiDr=""
			.;不显示非诊间预约和诊间加号的
			.s MethodDR=$P(ApptData,"^",12)
			.s MethodDesc="",MethodCode=""
			.i MethodDR'="" s MethodDesc=$P(^RBC("APTM",MethodDR),"^",2),MethodCode=$P(^RBC("APTM",MethodDR),"^",1)
			.Q:(MethodCode'="DOCA")&&(MethodCode'="DOC")
			.i ApptPapmiDr'="" s PAPERName= $p($g(^PAPER(ApptPapmiDr,"ALL")),"^",1)
			.s ApptStatus=$p(ApptData,"^",3)
			.Q:(ApptStatus'="I")&&(ApptStatus'="A")
			.s FinAPP=FinAPP+1
		
			Continue:Date<+$H
		 	Continue:(Date=..%SysDate())&&(NUMA=0)
		 	continue:(Date'=..%SysDate())&&(APPQty=0)
		 	if (Date=..%SysDate())&&(NUMA'=0){
			 	if Count=0{
	 				w "{start_date:"""_$zd(ASDate,3)_" "_..%ZT(ASSessStartTime)_""", end_date:"""_$zd(ASDate,3)_" "_..%ZT(ASSessStartTime)_""", text:"""_"(+)"_TRDesc_":"_"""}"
					w ",{start_date:"""_$zd(ASDate,3)_" "_..%ZT(ASSessEndTime)_""", end_date:"""_$zd(ASDate,3)_" "_..%ZT(ASSessEndTime)_""", text:"""_" "_NUMA_"-"_AddUser_"-"_AddCanDo_"""}"
		 		}else{
			 		w ",{start_date:"""_$zd(ASDate,3)_" "_..%ZT(ASSessStartTime)_""", end_date:"""_$zd(ASDate,3)_" "_..%ZT(ASSessStartTime)_""", text:"""_"(+)"_TRDesc_":"_"""}"
					w ",{start_date:"""_$zd(ASDate,3)_" "_..%ZT(ASSessEndTime)_""", end_date:"""_$zd(ASDate,3)_" "_..%ZT(ASSessEndTime)_""", text:"""_" "_NUMA_"-"_AddUser_"-"_AddCanDo_"""}"
	 		
			 	}
			 }
		 	elseif (APPQty'=0){
		 		if Count=0{
	 				w "{start_date:"""_$zd(ASDate,3)_" "_..%ZT(ASSessStartTime)_""", end_date:"""_$zd(ASDate,3)_" "_..%ZT(ASSessStartTime)_""", text:"""_TRDesc_":"_"""}"
					w ",{start_date:"""_$zd(ASDate,3)_" "_..%ZT(ASSessEndTime)_""", end_date:"""_$zd(ASDate,3)_" "_..%ZT(ASSessEndTime)_""", text:"""_" "_APPQty_"-"_ArriveCount_"-"_CanDo_"""}"
		 		}else{
			 		w ",{start_date:"""_$zd(ASDate,3)_" "_..%ZT(ASSessStartTime)_""", end_date:"""_$zd(ASDate,3)_" "_..%ZT(ASSessStartTime)_""", text:"""_TRDesc_":"_"""}"
					w ",{start_date:"""_$zd(ASDate,3)_" "_..%ZT(ASSessEndTime)_""", end_date:"""_$zd(ASDate,3)_" "_..%ZT(ASSessEndTime)_""", text:"""_" "_APPQty_"-"_ArriveCount_"-"_CanDo_"""}"
		 		}
		 	}
			s Count=Count+1
			s HavePrint="Y"
		}
		//输出当月之前的数据-或者在调整排版之前存在预约的数据
		if (HavePrint="N")&&(FinAPP'="0"){
			if (Count=0){
		    	//w "{start_date:"""_$zd(ASDate,3)_""", end_date:"""_$zd(ASDate,3)_""", text:"""_AdmDoc_":"_"""}"
				w "{start_date:"""_$zd(ASDate,3)_""", end_date:"""_$zd(ASDate,3)_""", text:"""_FinAPP_"条记录"_"""}"
			}else{
				 //w ",{start_date:"""_$zd(ASDate,3)_""", end_date:"""_$zd(ASDate,3)_""", text:"""_AdmDoc_":"_"""}"
				w ",{start_date:"""_$zd(ASDate,3)_""", end_date:"""_$zd(ASDate,3)_""", text:"""_FinAPP_"条记录"_"""}"
			}
		 	s Count=Count+1	
	   }
	}
	}
	w "]"
	q
}

// ----------------组件版 跨科诊间预约号别配置后台方法，使用^DHCDocRegConfig("LocCanAPP")Global存储

// ----------------标准版已新增HUI版本维护界面，且新增后台存储实体类User.DHCDocRegDocAppoint,业务类web.DHCDocRegDocAppiont.cls

/// 科室预约权限设置 设置可以互相约的科室号别
ClassMethod SetUserCanDo(Loc As %String, RESRowIDStr As %String) As %String
{
	k ^DHCDocRegConfig("LocCanAPP",Loc)
	if RESRowIDStr'=""  d
	.s sublength=$L(RESRowIDStr,"^") 
	.f sub=1:1:sublength  d
	..s RBResDr=$P(RESRowIDStr,"^",sub)
	..if +RBResDr'=0  d
	...s ^DHCDocRegConfig("LocCanAPP",Loc,RBResDr)=""
	q 0
}

/// lxz 获取预约设置科室
ClassMethod GetSetLoc(AdmType As %String) As %String
{

	s Len=$L(AdmType,"^")
	for i=1:1:Len  {
		s AdmTypePut=$P(AdmType,"^",i)
		s RowId=0 f  s RowId=$O(^PAC("ADMLOC",0,"AdmType",AdmTypePut,RowId)) Q:RowId=""  d
		.Q:'$d(^RB("RES",0,"CTLOC",RowId))
		.s LocDateTo=$p($g(^CTLOC(RowId)),"^",25)
		.Q:(LocDateTo'="")&&(LocDateTo<+$H)
		.s CTDesc=$p($g(^CTLOC(RowId)),"^",2)
		.s CTAliasTem=""
		.i $l(CTDesc,"-")>1 s CTAliasTem=$P(CTDesc,"-",1)
		.s CTAlias=$P(^CTLOC(RowId),"^",43)
		.i CTAlias="" s CTAlias=CTAliasTem
		.s CTRowId=RowId
		.s CTCode=CTRowId
		.s CTLOCMarkNO=##class(web.DHCBL.BDP.BDPSort).GetSortNum("User.CTLoc","正式",CTRowId)
		.i CTLOCMarkNO="" s CTLOCMarkNO="999"
	    .s GetOPLocList("RegCTLocLookup",CTLOCMarkNO,CTRowId)=CTDesc_"^"_CTAlias   //建立临时Globle
	
	}
	//按照序号排序
	
	s DesStr=""
	s seq="" for {
		s seq=$O(GetOPLocList("RegCTLocLookup",seq))
		Quit:seq=""
		s seq1="" for {
			s seq1=$O(GetOPLocList("RegCTLocLookup",seq,seq1))
			Quit:seq1=""
			s temp=GetOPLocList("RegCTLocLookup",seq,seq1)
			s CTRowId=seq1
			s CTDesc=$P(temp,"^",1)
			s CTAlias=$P(temp,"^",2)
			if DesStr=""  d
			.s DesStr=CTRowId_"!"_CTDesc
			else  d
			.s DesStr=DesStr_"^"_CTRowId_"!"_CTDesc
		}
	}
	q DesStr
}

/// 获取科室可以预约的所有资源
ClassMethod GetRBResDr(LocID As %String) As %String
{
	s Ret=""
	if LocID'=""  d
	.s ResRowId=0
	.f  s ResRowId=$o(^RB("RES",0,"CTLOC",LocID,ResRowId)) quit:ResRowId=""  d
	..s MarkID=$p($g(^RB("RES",ResRowId)),"^",2)
	..Q:MarkID=""
	..s Ctloc=$p($g(^RB("RES",ResRowId)),"^",1)
	..s ScheSt=$p(^RB("RES",ResRowId),"^",6)
	..Q:ScheSt'="Y"
	..Q:$D(FindDocMarkStrNew(MarkID))
	..s MarkDesc=$p($g(^CTPCP(MarkID,1)),"^",2)
	..Q:$D(FindDocMarkStrNew(MarkID))
	..s FindDocMarkStrNew(MarkID)=""
	..if Ret=""  s Ret=ResRowId_"!"_MarkDesc
	..else  s Ret=Ret_"^"_ResRowId_"!"_MarkDesc
	q Ret
}

/// 获取科室配置权限
/// w ##class(web.DHCBL.Doctor.AppointOral).GetAppCanDo(5)
ClassMethod GetAppCanDo(LocID As %String, UserID As %String = "") As %String
{
	s Rtn=""
	//标准版已新加后台表结构,走标版新方法
	set flag=##class(%Dictionary.MethodDefinition).%ExistsId("web.DHCDocRegDocAppiont"_"||"_"GetAppCanDo")
	if (flag=1){
		s DocID=""
		if UserID'="" s DocID=$p($g(^SSU("SSUSR",UserID)),"^",14)
		s Rtn=##class(web.DHCDocRegDocAppiont).GetAppCanDo(LocID,DocID)
		q Rtn
	}
	i LocID'=""  d
	.s RBASDr=0
	.f  s RBASDr=$O(^DHCDocRegConfig("LocCanAPP",LocID,RBASDr)) Q:RBASDr=""  d
	..s LocIDsub=$p($g(^RB("RES",+RBASDr)),"^",1)
	..s CTLOCDesc=$P(^CTLOC(LocIDsub),"^",2)
	..s MarkDr=$p($g(^RB("RES",+RBASDr)),"^",2)
	..s MarkDesc=$P($G(^CTPCP(MarkDr,1)),"^",2)
	..s SubDesc=RBASDr_"!"_CTLOCDesc_"-"_MarkDesc
	..if Rtn="" s Rtn=SubDesc
	..else  s Rtn=Rtn_"^"_SubDesc
	q Rtn
}

// ----------------组件版 跨科诊间预约号别配置后台方法-------end

}
