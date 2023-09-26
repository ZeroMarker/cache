Class web.DHCBL.Doctor.Appoint Extends (DHCDoc.Util.RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

ClassMethod ConvertDateToWeek(DateNum As %String) As %String
{
	if DateNum'="" {
		s Week=$ZD(DateNum,10)
		if Week=1 Q "周一"
		if Week=2 Q "周二"
		if Week=3 Q "周三"
		if Week=4 Q "周四"
		if Week=5 Q "周五"
		if Week=6 Q "周六"
		if Week=0 Q "周日"
	} 
	Q ""
}

ClassMethod GetApptScheduleListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetApptScheduleListExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetApptScheduleListExecute(ByRef qHandle As %Binary, ALL As %String = "", StartDate As %String = "", EndDate As %String = "", DocMarkDr As %String = "", RBResRowid As %String = "") As %Status
{
	//s ^yanghua("inAppt")="1"
	;d ##class(%ResultSet).RunQuery("web.DHCBL.Doctor.Appoint","GetApptScheduleList")
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	Set RowID=0,Price=0
	s AppDaysLimit=##class(web.DHCOPRegConfig).GetSpecConfigNode("AppDaysLimit")
	//set usercode=%session.Get("LOGON.USERCODE")
	set userID=%session.Get("LOGON.USERID")
	set CTPcpRowId=$p(^SSU("SSUSR",userID),"^",14)
	set LoginDepId=%session.Get("LOGON.CTLOCID")
    s StartDate=%request.Get("StartDate")
    
    //s ^tmpguo("userID")=CTPcpRowId_","_StartDate_","_EndDate_","_DocMarkDr 
	i $l(StartDate,"-")=3 s StartDate=$zdh(StartDate,3)
	i $l(StartDate,"/")=3 s StartDate=$zdh(StartDate,4)
	//s EndDate=%request.Get("EndDate")
	s:EndDate="" EndDate=%request.Get("EndDate")
	i $l(EndDate,"-")=3 s EndDate=$zdh(EndDate,3)
	i $l(EndDate,"/")=3 s EndDate=$zdh(EndDate,4)
	
	i StartDate'="" s StartDate=..%ZDH(StartDate)
    i EndDate'="" s EndDate=..%ZDH(EndDate)
	
	if RBResRowid'=""{
		d GetDataByResDr()
	}else{
		i CTPcpRowId="" 
		{
			Set qHandle=$lb(0,repid,0)
			Quit $$$OK
		}
		d GetDataByMark()
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
GetDataByResDr()
	;lxz 通过资源ID获取排班对照
	s RESRowId=RBResRowid
	s locdr=$P($G(^RB("RES",+RESRowId)),"^",1)
	s CTPcpDR=$P($G(^RB("RES",+RESRowId)),"^",2)
	s mASDate=0
	s mASDate=+$o(^RBAS(RESRowId,0,"DateSTime",mASDate))
	while(mASDate'=0){
		s todayDate=+$p($h,",",1)
		s LimitDate=+$p($h,",",1)+AppDaysLimit
		s QuitFlag=0
		if (mASDate<StartDate)&&(StartDate'="") s QuitFlag=1
		if (mASDate>EndDate)&&(EndDate'="") s QuitFlag=1
		If ((mASDate>=todayDate) && (mASDate<=LimitDate)&&(QuitFlag'=1)){
			s mSessStartTime=0
			s mSessStartTime=+$o(^RBAS(RESRowId,0,"DateSTime",mASDate,mSessStartTime))
			while(mSessStartTime'=0){
				s mASChildSub=0
				s mASChildSub=+$o(^RBAS(RESRowId,0,"DateSTime",mASDate,mSessStartTime,mASChildSub))
				while(mASChildSub'=0){
					;lxz 异常排班不用取值
					s ASIrregularFlag=$p($g(^RBAS(RESRowId,mASChildSub)),"^",13)
					if ASIrregularFlag'="A"
					{
						
						do OutputRow
						
					}
					s mASChildSub=+$o(^RBAS(RESRowId,0,"DateSTime",mASDate,mSessStartTime,mASChildSub))
				}
				s mSessStartTime=+$o(^RBAS(RESRowId,0,"DateSTime",mASDate,mSessStartTime))
			}
		}
		s mASDate=+$o(^RBAS(RESRowId,0,"DateSTime",mASDate))
	}
	
	q 
GetDataByMark()
	;lxz 通过号别获取资源-取医生号别对照配置
	s CTPcpDR=""
	s CTPcpDR=$O(^User.DHCMarkDocI("MarkdDocMarkIndex",CTPcpRowId,CTPcpDR))
	while(CTPcpDR'="")
	{
	;w CTPcpDR,!
	;b ;CTPcpDR 
	s locdr=""
	s locdr=$o(^RB("RES",0,"CTPCP",CTPcpDR,locdr))
	while(locdr'=""){
		//w locdr,!
		//b ;locdr
		if ((locdr=LoginDepId)) {
			
			
			s RESRowId=0
			s RESRowId=+$o(^RB("RES",0,"CTPCP",CTPcpDR,locdr,RESRowId))
			while(+RESRowId'=0)
			{
				//w RESRowId,!
				//b ;RESRowId
				//^RBAS(2,0,"DateSTime",61010,28800,3)=
				s mASDate=0
				s mASDate=+$o(^RBAS(RESRowId,0,"DateSTime",mASDate))
				while(mASDate'=0){
					//w mASDate,!
					//b ;mASDate
					//日期判断B.AS_Date >getdate()
					//B.AS_Date <dateadd(day,"_AppDaysLimit_",getdate())"
					s todayDate=+$p($h,",",1)
					s LimitDate=+$p($h,",",1)+AppDaysLimit
					;b ;mASDate,!
					s QuitFlag=0
					if (mASDate<StartDate)&&(StartDate'="") s QuitFlag=1
					if (mASDate>EndDate)&&(EndDate'="") s QuitFlag=1
					
					If ((mASDate>=todayDate) && (mASDate<=LimitDate)&&(QuitFlag'=1)){
						s mSessStartTime=0
						s mSessStartTime=+$o(^RBAS(RESRowId,0,"DateSTime",mASDate,mSessStartTime))
						while(mSessStartTime'=0){
							;w mSessStartTime,!
							;b ;mSessStartTime
							s mASChildSub=0
							s mASChildSub=+$o(^RBAS(RESRowId,0,"DateSTime",mASDate,mSessStartTime,mASChildSub))
							while(mASChildSub'=0){
								;lxz 异常排班不用取值
								s ASIrregularFlag=$p($g(^RBAS(RESRowId,mASChildSub)),"^",13)
								if ASIrregularFlag'="A"
								{
									if DocMarkDr'=""{if (CTPcpDR=DocMarkDr){do OutputRow}}
									else {do OutputRow}
								}
								s mASChildSub=+$o(^RBAS(RESRowId,0,"DateSTime",mASDate,mSessStartTime,mASChildSub))
							}
							s mSessStartTime=+$o(^RBAS(RESRowId,0,"DateSTime",mASDate,mSessStartTime))
						}
					}
					s mASDate=+$o(^RBAS(RESRowId,0,"DateSTime",mASDate))
				}
				s RESRowId=$o(^RB("RES",0,"CTPCP",CTPcpDR,locdr,RESRowId))
			}
		}
		s locdr=$o(^RB("RES",0,"CTPCP",CTPcpDR,locdr))
	}
	s CTPcpDR=$O(^User.DHCMarkDocI("MarkdDocMarkIndex",CTPcpRowId,CTPcpDR))
	}
	q 

OutputRow
	Do ResetVariables	
		set ID=RESRowId_"||"_mASChildSub ;rst.Data("ID")
		set LocationName=$p(^CTLOC(locdr),"^",2) ;rst.Data("LocationName")
		set LocationName1=$P(LocationName,"--",2) ;$P(LocationName,"-",2)
		if LocationName1'="" set LocationName=LocationName1
		set LocationID=locdr ;rst.Data("LocationID")
		set DoctorName=$p(^CTPCP(CTPcpDR,1),"^",2) ;rst.Data("DoctorName")
		set DoctorID=CTPcpDR ;rst.Data("DoctorID")
		//^RBAS(2,3,"DHC")=<<"2^3^0^1:1,2:1,3:1,4:1,5:1,6:1,7:1,8:1,9:1,10:1,11:3:3,12:3:3,13:3:3,14:3:3,15:3:3,16:3:3,17:0,18:3:3,19:3:1,20:3:1,21:1,22:1,23:1,24:1,25:1,26:1,27:1,28:1,29:1,30:1"_$C(1)_"+1:1,+2:1,+3:1,+4:1,+5:1,+6:1^317^5^93^61002^72042^1^^^^61010">>
		
		set RoomID=$p($G(^RBAS(RESRowId,mASChildSub,"DHC")),"^",5) ;rst.Data("RoomID")
		IF RoomID'="" set RoomName=$p(^CTLOC(RoomID),"^",2) ;rst.Data("RoomName")
		
		set ScheduleDate=mASDate ;rst.Data("ScheduleDate")
		set ScheduleWeek=..ConvertDateToWeek(ScheduleDate)
		set SessionStartTime=mSessStartTime ;rst.Data("SessionStartTime")
		set SessionEndTime=$p(^RBAS(RESRowId,mASChildSub),"^",5) ;rst.Data("SessionEndTime")
		
		set SessionTimeName=""
		;Set SessionTimeID=##class(web.DHCRBResSession).GetTimeRangeByTime(SessionStartTime)
		Set SessionTimeID=$P($G(^RBAS(RESRowId,mASChildSub,"DHC")),"^",17)
		If SessionTimeID'="" s SessionTimeName=$P(^DHCTimeRange(SessionTimeID),"^",2)
		Set FeeStr=""
		set Price=##class(web.DHCOPAdmReg).GetScheduleFee(ID,"", +$H, FeeStr)
		
		set TotalNum=$p(^RBAS(RESRowId,mASChildSub),"^",8) ;rst.Data("TotalNum")
		//set BookNum=$p(^RBAS(RESRowId,mASChildSub),"^",2) ;rst.Data("BookNum")
		set BookNum=##class(web.DHCRBApptScheduleAppQty).GetAPPMethodQty(RESRowId_"||"_mASChildSub,"DOC")

		set OverBookNum=$p(^RBAS(RESRowId,mASChildSub,"DHC"),"^",3) ;rst.Data("OverBookNum")
		set ASDate=$P($G(^RBAS(RESRowId,mASChildSub)),"^",1)
		//quit:(BookNum'>1)&&(+OverBookNum=0)
		quit:(BookNum'>0)&&(ASDate>+$h)&&(ALL'="on")
		quit:(+OverBookNum=0)&&(ASDate=..%SysDate())&&(ALL'="on")
		set QueueNO=$p(^RBAS(RESRowId,mASChildSub,"DHC"),"^",4) ;rst.Data("QueueNO")
		set retnum=##class(web.DHCRBResourceRule).GetRegisterNum(QueueNO)
		set RegisterNum=$P(retnum,"^",1)
		set MethodDr=$O(^RBC("APTM",0,"Code","DOC",0))	
		set AppedNum=##class(web.DHCRBApptScheduleAppQty).GetMethodAppedQty(RESRowId_"||"_mASChildSub,MethodDr) //$P(retnum,"^",2)
		set QueueNO=##class(web.DHCRBResourceRule).GetFreeQueueNO(QueueNO)
		
		s StatusID=$p(^RBAS(RESRowId,mASChildSub,"DHC"),"^",10)
		if StatusID'="" {
			set Status=^DHCRBCASStatus(StatusID) ;rst.Data("Status")
			set StatusCode=$p(Status,"^",1)
		}
		q:(StatusCode="S")||(StatusCode="TR")||(StatusCode="PS")
		set AppStartNo=$p(^RBAS(RESRowId,mASChildSub),"^",10) ;rst.Data("AppStartNo")
		
		s SessionTypeDr=$P($G(^RBAS(+ID,$P(ID,"||",2),"DHC")),"^",6)
		s SessionTypeDesc=""
		i SessionTypeDr'="" s SessionTypeDesc=$P($G(^RBC("SESS",SessionTypeDr)),"^",2)

		s SessionClinicGroupDr=$P($G(^RBAS(+ID,$P(ID,"||",2),"DHC")),"^",7)
		s SessionClinicGroupDesc=""
		i SessionClinicGroupDr'="" s SessionClinicGroupDesc=$P($G(^RBC("CLGRP",SessionClinicGroupDr)),"^",2)

		s TRDoc=""
		s TRRBASRowId=$P(^RBAS(+ID,$P(ID,"||",2),"DHC"),"^",12)
		i (TRRBASRowId'="") d
		.i $d(^RB("RES",+TRRBASRowId)) d
		..s TRDocRowId= $P($G(^RB("RES",+TRRBASRowId)),"^",2)
		..s TRDoc=$p($g(^CTPCP(TRDocRowId,1)),"^",2)
		set Data=$ListBuild(ID,LocationName,ScheduleWeek,LocationID,DoctorName,DoctorID,RoomName,RoomID,ScheduleDate,SessionStartTime,SessionEndTime,SessionTimeName,SessionTypeDesc,SessionTimeID,Price,TotalNum,BookNum,OverBookNum,AppStartNo,QueueNO,Status,RegisterNum,AppedNum,TRDoc,SessionClinicGroupDr,SessionClinicGroupDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	Quit
ResetVariables
	Set (ID,LocationName,ScheduleWeek,LocationID,DoctorName,DoctorID,RoomName,RoomID,ScheduleDate,SessionStartTime,SessionEndTime,SessionTimeName,SessionTypeDesc,SessionTimeID,Price,TotalNum,BookNum,OverBookNum,AppStartNo,QueueNO,Status,RegisterNum,AppedNum,TRDoc,SessionClinicGroupDr,SessionClinicGroupDesc)=""
	Quit
}

ClassMethod GetApptScheduleListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetApptScheduleListExecute ]
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

ClassMethod GetPatDetailById(itmjs As %Library.String = "", itmjsex As %Library.String = "", patientid As %Library.String = "")
{
	Set (id,code,desc)=""
	Set PatDr=patientid
	Quit:PatDr="" 0
	//s CardID=$o(^DHCCARDi("CF",0,"PAPMIDR",PatDr,0))
	//Set cardNo=$p(^DHCCARD("CF",CardID),"^",2)  //$p(^DHCCARD("CF",PatDr),"^",2)
	s CardID="",cardNo="",cardtype=""
	f  s CardID=$o(^DHCCARDi("CF",0,"PAPMIDR",PatDr,CardID)) q:(CardID="")||(cardNo'="")  d
	.s CFActiveFlag=$p(^DHCCARD("CF",CardID),"^",10)
	.q:CFActiveFlag'="N"
	.s cardNo=$p(^DHCCARD("CF",CardID),"^",2)
	.s cardtype=$p(^DHCCARD("CF",CardID),"^",16)
	Set Name=$p(^PAPER(PatDr,"ALL"),"^",1)
	set RIDCardNo=$p($g(^PAPER(PatDr,"ALL")),"^",9)
	Set Age=+$p(^PAPER(PatDr,"ALL"),"^",6)
	;Set Age=$p(((+$H-Age)/365)+0.5,".")
	Set Age=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.reg.GetPapmiAge",PatDr,"")
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
	Set desc=Name_"^"_Age_"^"_Sex_"^"_OPMRN_"^"_IPMRN_"^"_PatCat_"^"_PatDr_"^"_RIDCardNo_"^"_RAddress_"^"_patientid_"^"_AppBreakCount_"^"_cardNo_"^"_cardtype
	set retval=itmjs_"('"_$ZCVT(desc,"O","JS")_"');"
	i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(desc,"O","JS")_"^"_id_"^"_$ZCVT(code,"O","JS")_"');"
	&javascript<#(retval)#>
	q 1
}

Query GetApptScheduleList(ALL As %String = "", StartDate As %String = "", EndDate As %String = "", DocMarkDr As %String = "", RBResRowid As %String = "") As %Query(ROWSPEC = "ID:%String,LocationName:%String,ScheduleWeek:%String,LocationID:%String,DoctorName:%String,DoctorID:%String,RoomName:%String,RoomID:%String,ScheduleDate:%String,SessionStartTime:%String,SessEndTime:%String,SessionTimeName:%String,SessionTypeDesc:%String,SessionTimeID:%String,Price:%String,TotalNum:%String,BookNum:%String,OverBookNum:%String,AppStartNo:%String,QueueNO:%String,Status:%String,RegisterNum:%String,AppedNum:%String,TRDoc:%String,SessionClinicGroupDr:%String,SessionClinicGroupDesc:%String")
{
}

/// 判断是否可以分时段预约
ClassMethod CheckIsAllowTimeRangeReg(LocId As %String, DocId As %String) As %Boolean
{
	;n (LocId,DocId)
	s ResRowId=$O(^RB("RES",0,"CTPCP",DocId,LocId,0))
	q:ResRowId="" 0
	s AllowGetSeqNoFlag=$p($g(^RB("RES",ResRowId,"DHC")),"^",18)
	q:AllowGetSeqNoFlag'="Y" 0
	
	q 1
}

}
