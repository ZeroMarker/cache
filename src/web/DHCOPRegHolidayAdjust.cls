Class web.DHCOPRegHolidayAdjust Extends DHCDoc.Util.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 把排班从OriginalDate复制至AdjustDate,并删除原OriginalDate日期的所有排班记录
ClassMethod AdjustHoliday(OriginalDate, AdjustDate, HospitalDr, SessionStr) [ ProcedureBlock = 1 ]
{
	//w ##class(web.DHCOPRegHolidayAdjust).AdjustHoliday("27/04/2008","28/04/2008")
	i OriginalDate'="" s OriginalDate=..%ZDH(OriginalDate)
    i AdjustDate'="" s AdjustDate=..%ZDH(AdjustDate)
	s UserID=%session.Get("LOGON.USERID")
	s CurDate=..%SysDate(),CurTime=..%SysTime()
		
	
	K ResourceArr
	s loc=0,FindAvaildRes=0
	for{
		Set loc=$o(^RB("RES",0,"CTLOC",loc))
		quit:loc=""
		s locHospital=$p($g(^CTLOC(loc)),"^",22)
		continue:(HospitalDr'=locHospital)
		s RowId=0 
		for{
			Set RowId=$o(^RB("RES",0,"CTLOC",loc,RowId))
			quit:RowId=""
			s DocDr=$P(^RB("RES",RowId),"^",2)
			;如果非医生则退出
			continue:DocDr=""
			continue:'$D(^CTPCP(DocDr,1))
			;判断是否需要排班
			s ScheSt=$p(^RB("RES",RowId),"^",6)
			continue:(ScheSt'="Y")
			s ResourceArr(RowId)=""
			if ($D(^RBAS(0,"Date",AdjustDate,RowId))){
				s FindAvaildRes=1
			}
		}
	}
	if FindAvaildRes=1{
		quit "-1^"_..%ZD(AdjustDate)_"日期存在排班记录,请前往坐诊信息批量处理界面删除该日期的所有排班之后,再进行排班迁移！"
	}
	///原出诊日期中是否还有有效的就诊和预约记录
	s RowId=0,Msg=""
	for {
		s RowId=$O(ResourceArr(RowId))
		q:(RowId="")
		s DocDr=$P(^RB("RES",RowId),"^",2)
		s MarkDesc=$p(^CTPCP(DocDr,1),"^",2)
		s DeptDr=$p(^RB("RES",RowId),"^",1)
		s DepDesc=$P(^CTLOC(DeptDr),"^",2)
		s SessStartTime=""
		f  {
			s SessStartTime=$O(^RBAS(RowId,0,"DateSTime",OriginalDate,SessStartTime))
			q:(SessStartTime="")
			s RBApptRowId=""
			f{
				s RBApptRowId=$O(^RBAS(RowId,0,"DateSTime",OriginalDate,SessStartTime,RBApptRowId))
				q:(RBApptRowId="")
				s QueueNO=$P($G(^RBAS(RowId,RBApptRowId,"DHC")),"^",4)
				s retnum=##Class(web.DHCApptScheduleNew).GetRegisterNum(QueueNO)
				s RegisterNum=$P(retnum,"^",1)
				s AppedNum=$P(retnum,"^",2)
				s AppedArriveNum=$P(retnum,"^",3)
				
				if (RegisterNum+AppedNum+AppedArriveNum)>0{
					if (Msg'="") s Msg=Msg_";"_DepDesc_" "_MarkDesc
					if (RegisterNum>0) s Msg=Msg_"已挂号"_RegisterNum_"人,"
					if (AppedNum>0) s Msg=Msg_"已预约"_AppedNum_"人,"
					if (AppedArriveNum>0) s Msg=Msg_"已取号"_AppedArriveNum_"人,"
					s Msg=$e(Msg,1,$L(Msg)-1)
				}
			}
		}
	}
	if (Msg'=""){
		s Msg="-1^"_..%ZD(OriginalDate)_"业务数据尚未处理:"_Msg_"。请处理完毕后再进行操作！"
		q Msg
	}
	s Count=0,ErrCount=0,Msg=""
	s RowId=0
	for {
		s RowId=$O(ResourceArr(RowId))
		q:(RowId="")
		s DocDr=$P(^RB("RES",RowId),"^",2)
		s MarkDesc=$p(^CTPCP(DocDr,1),"^",2)
		s DeptDr=$p(^RB("RES",RowId),"^",1)
		s DepDesc=$P(^CTLOC(DeptDr),"^",2)
		s ret=..CopyApptSchedule(RowId,OriginalDate,AdjustDate,SessionStr)
		
		s subErrCode=$P(ret,"^",1)
		s subMsg=$P(ret,"^",2)
		s subCount=$P(ret,"^",3)
		
		if (+subErrCode'=0){
			if (Msg=""){
				s Msg=DeptDr_" "_MarkDesc_" 迁移失败："_subMsg
			}else{
				s Msg=Msg_";"_DeptDr_" "_MarkDesc_" 迁移失败："_subMsg
			}
			s ErrCount=ErrCount+subCount
		}else{
			s Count=Count+subCount
		}
		
	}
	
	s Msg="调整排班成功"_(+Count)_"条,调整失败排班"_(+ErrCount)_"条,失败详情："_($CASE(Msg,"":"无",:Msg))
	s Msg=$replace(Msg,"^","|")
	s ^AdjustHolidayShe("ADJUST",HospitalDr,OriginalDate)=OriginalDate_"^"_AdjustDate_"^"_UserID_"^"_CurDate_"^"_CurTime_"^"_Msg
	Q "0^"_Msg
}

ClassMethod DelAdjustHoliday(OriginalDate, HospitalDr)
{
	if $l(OriginalDate,"/")=3 s OriginalDate=$zdh(OriginalDate,4)
	if $l(OriginalDate,"-")=3 s OriginalDate=$zdh(OriginalDate,3)
	s err=0
	k ^AdjustHolidayShe("ADJUST",HospitalDr,OriginalDate) 
	Q err
}

/// 长时段停诊
ClassMethod BatchStop(StartDate, EndDate, DepId, DocId, Reason, Notes, UserID, StopMethod, GroupId)
{
	//w ##class(web.DHCOPRegHolidayAdjust).BatchStop("30/05/2008","31/05/2008",1442,22073,"","",6)
	//查找出所有的已经生成的记录,将它们的状态置成S
	set ResRowId=$Order(^RB("RES",0,"CTPCP",DocId,DepId,0))
	s StartDate=..%ZDH(StartDate)
    s EndDate=..%ZDH(EndDate)
	s Count=0 //操作停诊/撤销停诊排班数量
	s CancelRequestCount=0 //撤销申请的排班数量
	f ASDate=StartDate:1:EndDate d
	.s StartTimeID=""
	.f  s StartTimeID=$O(^RBAS(ResRowId,0,"DateSTime",ASDate,StartTimeID)) q:(StartTimeID="")  d
	..s RBASRowId="",ASStatus=""
	..f  s RBASRowId=$O(^RBAS(ResRowId,0,"DateSTime",ASDate,StartTimeID,RBASRowId)) q:(RBASRowId="")  d
	...s ASStatusid=$P(^RBAS(ResRowId,RBASRowId,"DHC"),"^",10)
	...if ASStatusid'="" s ASStatus=$p(^DHCRBCASStatus(ASStatusid),"^",1)
	...s NewStatusCode=StopMethod
	...if NewStatusCode="" s NewStatusCode=##class(web.DHCRBApptSchedule).GetRBApptScheduleStatus(ResRowId_"||"_RBASRowId)
	...i NewStatusCode="S" s type="S"
	...e  s type="SC"
	...;判断是否有正在申请审批的记录
	...s RequestID=0,RequestIDStr=""
	...f  s RequestID=$o(^User.DHCRBApptScheduleRequestI("RBASIDIndex",ResRowId_"||"_RBASRowId,RequestID)) Q:RequestID=""  d
	....s ASRRequestType=$lg(^User.DHCRBApptScheduleRequestD(RequestID),13)
	....Q:(ASRRequestType'="S")&&(type="SC")
	....Q:(ASRRequestType'="SC")&&(type="S")
	....s ASRRequestResult=$lg(^User.DHCRBApptScheduleRequestD(RequestID),11)
	....Q:(ASRRequestResult'="N")
	....i RequestIDStr="" s RequestIDStr=RequestID
	....e  s RequestIDStr=RequestIDStr_"^"_RequestID
	...&SQL(Select ASS_Rowid into :ASStatusDR from SQLUser.DHC_RBCASStatus Where ASS_Code=:NewStatusCode)
	...s ret=0
	...if (type="SC") d
	....s ScheduleDate=$P($G(^RBAS(ResRowId,RBASRowId)),"^",1)
	....s SessStartTime=$P($G(^RBAS(ResRowId,RBASRowId)),"^",4)
	....s Roomid=$P($g(^RBAS(ResRowId,RBASRowId,"DHC")),"^",5)
	....s ret=##class(web.DHCRBResourceRule).CheckSchedule(ResRowId,ScheduleDate,Roomid, SessStartTime,ResRowId_"||"_RBASRowId)
	...Q:ret'=0
	...;存在正在申请的停诊/撤销停诊记录则撤销申请
	...i RequestIDStr'="" d
	....d ##class(web.DHCRBApptScheduleAudi).DeleteRBASRequest(RequestIDStr,UserID,"N")
	....s CancelRequestCount=CancelRequestCount+1
	...Q:((ASStatus="S")||(ASStatus="TR")||(ASStatus="PS"))&&(NewStatusCode="S")
	...Q:((ASStatus="R")||(ASStatus="N")||(ASStatus="A")||(ASStatus="TR"))&&(NewStatusCode'="S")
	...// 是否需要审批
	...if (+(##class(web.DHCRBApptScheduleAudi).GetRBASRequestFlag(type,ResRowId))=1)  d
	....s AuditStatus=##class(web.DHCRBApptScheduleAudi).CheckIsAuditStatus(ResRowId_"||"_RBASRowId)
	....i AuditStatus="" s ret=##class(web.DHCRBApptSchedule).RBASRequest(ResRowId_"||"_RBASRowId,type_"^"_Reason_"^"_"^"_"^"_"^"),Count=Count+1
	...e  d
	....s $P(^RBAS(ResRowId,RBASRowId,"DHC"),"^",10)=ASStatusDR
	....s $P(^RBAS(ResRowId,RBASRowId,"DHC"),"^",11)=Reason
	....;调用平台组接口
	....s rtn=##class(web.DHCENS.EnsHISService).DHCHisInterface("STOPAPPTSCHEDULEINFO",ResRowId_"||"_RBASRowId)
	....s Count=Count+1
	//插入到批量停诊表
	set RSVP="N"
	if StopMethod="S" set RSVP="Y"
	s UpdateDate=..%SysDate()
	s UpdateTime=..%SysTime()
	q:(Count=0)&&(CancelRequestCount=0) "Repeat"
	if (Count>0)||(CancelRequestCount>0){
		&sql(insert into SQLUser.RB_NotAvail (NA_RES_DR,NA_FrDate,NA_FrTime,NA_ToDate,NA_ToTime,NA_Reason_DR,NA_UpdateDate,NA_UpdateTime,NA_UpdateUser_DR,NA_RSVP)
	   Values(:ResRowId,:StartDate,:UpdateTime,:EndDate,:UpdateTime,:Reason,:UpdateDate,:UpdateTime,:UserID,:RSVP))
	  Q:(SQLCODE'=0) "-202"
	}
	Q 0_"^"_Count
}

ClassMethod CheckResData(StartDate, EndDate, DepId, DocId)
{
	//w ##class(web.DHCOPRegHolidayAdjust).CheckResData("28/05/2008","28/05/2008",1442,21977)
	//s ^guo("CheckResData")=StartDate_","_EndDate_","_DepId_","_DocId
	if $L(StartDate,"/")=3 s StartDate=$zdh(StartDate,4)
	if $L(EndDate,"/")=3 s EndDate=$zdh(EndDate,4)
	if $L(StartDate,"-")=3 s StartDate=$zdh(StartDate,3)
	if $L(EndDate,"-")=3 s EndDate=$zdh(EndDate,3)
	set ResRowId=$Order(^RB("RES",0,"CTPCP",DocId,DepId,0))
	//遍历生成记录表,有记录则提示 ^的第一部分为有出诊记录,第二部分为有预约记录
	s StrFind="",StrFind1=""
	s ReturnValue="^"
	f ASDate=StartDate:1:EndDate d
	.s StartTimeID=""
	.f  s StartTimeID=$O(^RBAS(ResRowId,0,"DateSTime",ASDate,StartTimeID)) q:(StartTimeID="")||(StrFind'="")  d
	..s RBASRowId=""
	..f  s RBASRowId=$O(^RBAS(ResRowId,0,"DateSTime",ASDate,StartTimeID,RBASRowId)) q:(RBASRowId="")||(StrFind'="")  d
	...s ASStatusid=$P(^RBAS(ResRowId,RBASRowId,"DHC"),"^",10)
	...if ASStatusid'="" s ASStatus=$p(^DHCRBCASStatus(ASStatusid),"^",1)
	...Q:(ASStatus="S")||(ASStatus="TR")   //停诊和被停诊则退出
	...s StrFind=StrFind_RBASRowId
	...if StrFind'="" s ReturnValue="-200^"
	...q:StrFind'=""
	.s RBAPPTTimeRowId="",SubRowId=""
	.f  s RBAPPTTimeRowId=$O(^RBAS("APPT_Date",ResRowId,ASDate,RBAPPTTimeRowId)) q:(RBAPPTTimeRowId="")||(SubRowId'="")  d
	..s RBASRowId=""
	..f  s RBASRowId=$O(^RBAS("APPT_Date",ResRowId,ASDate,RBAPPTTimeRowId,RBASRowId)) q:(RBASRowId="")||(SubRowId'="")  d
	...s ASStatusid=$P(^RBAS(ResRowId,RBASRowId,"DHC"),"^",10)
	...if ASStatusid'="" s ASStatus=$p(^DHCRBCASStatus(ASStatusid),"^",1)
	...Q:(ASStatus="S")||(ASStatus="TR")   //停诊和被停诊则退出
	...s SubRowId="" f  s SubRowId=$O(^RBAS("APPT_Date",ResRowId,ASDate,RBAPPTTimeRowId,RBASRowId,SubRowId)) q:(SubRowId="")||(SubRowId'="")  d
	....s StrFind1=StrFind1_SubRowId
	....if SubRowId'="" s ReturnValue=ReturnValue_"-201"
	....q:SubRowId'=""
	
	Q ReturnValue
}

/// 执行排班移动,并删除原始排班内容
/// input:
/// 	ResRowId:需要拷贝的资源ID
/// 	OriginalDate:原始排班日期
/// 	AdjustDate:调整排班日期
/// 	SessionStr:
/// output
/// 	成功标识^错误信息^复制成功数据
ClassMethod CopyApptSchedule(ResRowId, OriginalDate, AdjustDate, SessionStr) [ ProcedureBlock = 1 ]
{
	s ExpStr=$P(SessionStr,"^",2)_"^"_$P(SessionStr,"^",1)
	s ControlExpStr="Y^Y"
	s ErrCode=0,Msg="",Count=0
	TS
	s SessStartTime=""
	f  {
		s SessStartTime=$O(^RBAS(ResRowId,0,"DateSTime",OriginalDate,SessStartTime))
		q:(SessStartTime="")||(ErrCode'=0)

		s RBApptRowId=""
		f{
			s RBApptRowId=$O(^RBAS(ResRowId,0,"DateSTime",OriginalDate,SessStartTime,RBApptRowId))
			q:(RBApptRowId="")||(ErrCode'=0)
			s IrregularFlag=$p(^RBAS(+ResRowId,RBApptRowId),"^",13)
			continue:(IrregularFlag="A")
			s RBApptID=ResRowId_"||"_RBApptRowId
			s Count=Count+1
			//将排班复制至目标日期
			s ret2=##Class(web.DHCRBApptSchedule).CopyOneScheduleNew(RBApptID,AdjustDate,"","",ExpStr,ControlExpStr)
			s ErrCode=+ret2
			if (ErrCode'=0){
				s Msg=ret2
				continue
			}
			//删除原排班数据
			s ErrCode=##Class(web.DHCRBApptSchedule).DelectOneSchedule(RBApptID)
			if (+ErrCode'=0){
				s Msg="删除排班"_RBApptID_"失败,错误代码:"_ErrCode
				continue
			}
			
		}
	}
	if (ErrCode=0){
		TC
	}else{
		TRO
		s Count=0
	}
	q ErrCode_"^"_$replace(Msg,"^","|")_"^"_Count
}

ClassMethod FindAdjustDateClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = FindAdjustDateExecute ]
{
	// Clean up by purging the temporary node in ^CacheTemp global
	//New repid
	Set repid=$li(QHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindAdjustDateExecute(ByRef QHandle As %Binary, HospitalDr) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s AdjustRowId=""
	f  s AdjustRowId=$O(^AdjustHolidayShe("ADJUST",HospitalDr,AdjustRowId)) q:AdjustRowId=""  d
	.s OriginalDate=$p(^AdjustHolidayShe("ADJUST",HospitalDr,AdjustRowId),"^",1)
	.s OriginalDate=..%ZD(OriginalDate) //$zd(OriginalDate,3)
	.s AdjustDate=$p(^AdjustHolidayShe("ADJUST",HospitalDr,AdjustRowId),"^",2)
	.s AdjustDate=..%ZD(AdjustDate) //$zd(AdjustDate,3)
	.s UserDesc=""
	.s UserID=$p(^AdjustHolidayShe("ADJUST",HospitalDr,AdjustRowId),"^",3)
	.i UserID'="" s UserDesc=$p($g(^SSU("SSUSR",UserID)),"^",2)
	.s UpdateDate=$p(^AdjustHolidayShe("ADJUST",HospitalDr,AdjustRowId),"^",4)
	.i UpdateDate'="" s UpdateDate=..%ZD(UpdateDate) //$zd(UpdateDate,3)
	.s UpdateTime=$p(^AdjustHolidayShe("ADJUST",HospitalDr,AdjustRowId),"^",5)
	.i UpdateTime'="" s UpdateTime=..%ZT(UpdateTime,1)
	.s HospitalDesc=$p(^CT("HOSP",HospitalDr),"^",2)
	.s LogInfo=$p(^AdjustHolidayShe("ADJUST",HospitalDr,AdjustRowId),"^",6)
	.d OutputRow
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(OriginalDate,AdjustDate,UserDesc,UpdateDate,UpdateTime,HospitalDesc,LogInfo)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	quit
}

ClassMethod FindAdjustDateFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAdjustDateExecute ]
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

ClassMethod FindStopResultClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindStopResultExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod FindStopResultExecute(ByRef qHandle As %Binary, StartDate As %String = "", EndDate As %String = "", Loc As %String = "", Doc As %String = "", paraReasonDr As %String = "", HospID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s UserID=%session.Get("LOGON.USERID")
	//if $L(StartDate,"/")=3 s StartDate=$zdh(StartDate,4)
	//if $L(EndDate,"/")=3 s EndDate=$zdh(EndDate,4)
	i StartDate'="" s StartDate=..%ZDH(StartDate)
    i EndDate'="" s EndDate=..%ZDH(EndDate)
	s ReasonNotes=""
	s NARowid=0
	f  s NARowid=$O(^RB("NA",NARowid)) q:NARowid=""  d
	.s RESDR=$p(^RB("NA",NARowid),"^",1)
	.s DepID=$p($g(^RB("RES",RESDR)),"^",1)
	.q:(Loc'="")&&(Loc'=DepID)
	.S DepDesc=$P($g(^CTLOC(DepID)),"^",2)
	.s Hospdr=$p($g(^CTLOC(DepID)),"^",22)
	.q:HospID'=Hospdr
	.S DocID=$p(^RB("RES",RESDR),"^",2)
	.q:(Doc'="")&&(Doc'=DocID)
	.q:(UserID'="")&&('##class(web.DHCUserGroup).UserCanDo(UserID,DepID,DocID))
	.S DocDesc=$P(^CTPCP(DocID,1),"^",2)
	.s StDate=$P($P(^RB("NA",NARowid),"^",2),"Z",1)
	.s EDate=$P($P(^RB("NA",NARowid),"^",3),"Z",1)
	.q:(StartDate'="")&&(StDate<StartDate)
	.q:(EndDate'="")&&(EDate>EndDate)
	.s StDate=..%ZD(StDate) //$zd(StDate,3)
	.s EDate=..%ZD(EDate) //$zd(EDate,3)
	.s RSVP=$P(^RB("NA",NARowid),"^",6)
	.s NAFlag=RSVP
	.if RSVP="Y" s RSVP="停诊"
	.e  i RSVP="N" s RSVP="撤销停诊"
	.s UpDate=$P(^RB("NA",NARowid),"^",9)
	.s UpTime=$P(^RB("NA",NARowid),"^",10)
	.s UpDateUser=$P(^RB("NA",NARowid),"^",11)
	.i UpDateUser'="" s UserName=$p(^SSU("SSUSR",UpDateUser),"^",2)
	.s ReasonDr=$P(^RB("NA",NARowid),"^",4)
	.q:(paraReasonDr'="")&&(paraReasonDr'=ReasonDr)
	.s ReasonNotes=""
	.if ReasonDr'="" S ReasonNotes=$P($g(^RBC("NA",ReasonDr)),"^",2)
	.do OutputRow1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(DepDesc,DocDesc,ReasonNotes,StDate,EDate,NARowid,RSVP,UserName,NAFlag,DepID)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	quit
ResetVariables
	///set (repid)=0
	set (DepDesc,DocDesc,ReasonNotes,StDate,EDate,NARowid,RSVP,UserName,NAFlag)=""
	quit
}

ClassMethod FindStopResultFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindStopResultExecute ]
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

ClassMethod InsertAppQty(Para As %String) As %String
{
	Ts
	s ASRowid=$P(Para,"^",1)
	s MethodDR=$P(Para,"^",2)
	s Qty=$P(Para,"^",3)
	s StartNum=$P(Para,"^",4)
	Set object = ##class(User.DHCRBApptScheduleAppQty).%New(ASRowid)
	d object.ASQASParRefSetObjectId(ASRowid)
	d object.ASQMethodDRSetObjectId(MethodDR)
	s object.ASQQty=Qty
	s object.ASQStartNum=StartNum
	Set sc = object.%Save()
	If $$$ISERR(sc) {
		Do $System.Status.DisplayError()
		Trollback
		Q 100
	}
	Tc
	Q 0
}

/// w ##class(web.DHCOPRegHolidayAdjust).UpdateNotAvail(40,1,"N",1)
ClassMethod UpdateNotAvail(Rowid, UserID, StopMethod, GroupId)
{
	new (Rowid, UserID,StopMethod,GroupId,%session)
	s ^Tempslc("UpdateNotAvail")=Rowid_","_UserID_","_StopMethod_","_GroupId
	Q:Rowid="" "-203"
	set ResRowId=$P(^RB("NA",Rowid),"^",1)
	set DepId=$p(^RB("RES",ResRowId),"^",1)
	set DocId=$p(^RB("RES",ResRowId),"^",2)
	set FrDateTime=$P(^RB("NA",Rowid),"^",2)
	set FrDate=$P(FrDateTime,"Z",1)
	set ToDateTime=$P(^RB("NA",Rowid),"^",3)
	set ToDate=$P(ToDateTime,"Z",1)
	set Reason=$P(^RB("NA",Rowid),"^",4)
	set Notes=$G(^RB("NA",Rowid,"REM"))
	set myrtn=##class(web.DHCOPRegHolidayAdjust).BatchStop(FrDate, ToDate, DepId, DocId, Reason, Notes, UserID,StopMethod,GroupId)
	/*
	s UpdateDate=..%SysDate()
	s UpdateTime=..%SysTime()
	&sql(insert into SQLUser.RB_NotAvail (NA_RES_DR,NA_FrDate,NA_FrTime,NA_ToDate,NA_ToTime,NA_Reason_DR,NA_UpdateDate,NA_UpdateTime,NA_UpdateUser_DR,NA_RSVP)
	 Values(:ResRowId,:StartDate,:UpdateTime,:EndDate,:UpdateTime,:Reason,:UpdateDate,:UpdateTime,:UserID,"No"))
	Q:(SQLCODE'=0) "-202"
	*/
	Q myrtn
}

Query FindAdjustDate(HospitalDr) As %Query(ROWSPEC = "TOriginalDate:%String,TAdjustDate:%String,UserName,UpdateDate,UpdateTime,HospitalDesc,LogInfo")
{
}

Query FindStopResult(StartDate As %String = "", EndDate As %String = "", Loc As %String = "", Doc As %String = "", paraReasonDr As %String = "", HospID As %String = "") As %Query(ROWSPEC = "TLoc:%String,TDoc:%String,TStopReason:%String,TStartDate:%String,TEndDate:%String,NARowid:%String,RSVP:%String,UserName:%String,NAFlag:%String,DepID:%String")
{
}

/// create 20200110 by yl
/// 判断排班是否在有效的长时段停诊内
/// input:排班表id
/// output: 结果状态^长时段停诊开始日期^长时段停诊结束日期
ClassMethod CheckRBASInHoliday(RBASRowId As %String)
{
	n (RBASRowId)
	s ^Tmpyl("CheckRBASInHoliday")=RBASRowId
	s RBRowId=+RBASRowId
	s AsSub=$p(RBASRowId,"||",2)
	s AsDate=$p(^RBAS(RBRowId,AsSub),"^",1)
	s ExitFlag=0, ExitFrDate="", ExitToDate=""
	if $d(^RB("NA",0,"RES",RBRowId))=10 {
		s DateStr="" f  {
			s DateStr=$o(^RB("NA",0,"RES",RBRowId,DateStr))
			q:DateStr=""
			s NAFrDate=$p(DateStr,"Z",1)
			continue:NAFrDate>AsDate
			s NARowId=0 f  {
				s NARowId=$o(^RB("NA",0,"RES",RBRowId,DateStr,NARowId))
				q:NARowId=""
				s ToDateStr=$p(^RB("NA",NARowId),"^",3)
				s NAToDate=$p(ToDateStr,"Z",1)
				continue:AsDate>NAToDate
				s ExitFlag=1
				s ExitFrDate=$zd(NAFrDate,3)
				s ExitToDate=$zd(NAToDate,3)
				q:ExitFlag=1
			}
		}
	}
	q ExitFlag_"^"_ExitFrDate_"^"_ExitToDate
}

// 判断长时段停诊/撤销停诊是否需要审批

ClassMethod CheckBatchStopRequestFlag(DepId, StopMethod, GroupId, HospId) As %String
{
	s HospId=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	if GroupId'=""{
		s AudiNotLimitedGroupStr=..%GetConfig("AudiNotLimitedGroupStr",HospId)
		if (AudiNotLimitedGroupStr'="")&&(("^"_AudiNotLimitedGroupStr_"^")[("^"_GroupId_"^")) Q 0
	}
	if DepId'=""{
		;不受限制的科室
		s AudiNotNeedLocStr=..%GetConfig("AudiNotNeedLocStr",HospId)
		if AudiNotNeedLocStr'=""{
			s AudiNotNeedLocStr="^"_AudiNotNeedLocStr_"^"
			if (AudiNotNeedLocStr[("^"_DepId_"^")) Q 0
		}
	}
	if StopMethod="N" s Type="AudiCancelStopSchedule"
	if StopMethod="S" s Type="AudiStopSchedule"
	s val=..%GetConfig(Type,HospId)
	if val="Y" s val=1
	else  s val=0
	Q val
}

}
