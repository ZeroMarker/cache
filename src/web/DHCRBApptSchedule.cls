Class web.DHCRBApptSchedule Extends DHCDoc.Util.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod ApptScheduleListQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ApptScheduleListQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 排班记录查询
ClassMethod ApptScheduleListQueryExecute(ByRef qHandle As %Binary, LocationName As %String, ClinicGroupName As %String, DoctorName As %String, ScheduleDate As %Date, ASRowId As %String = "", UserID As %String = "") As %Status
{
	s ^zhou("ApptScheduleListQuery")=LocationName_","_ClinicGroupName_","_DoctorName_","_ScheduleDate_","_ASRowId
	;d ##class(%ResultSet).RunQuery("web.DHCRBApptSchedule","ApptScheduleListQuery","","","","","7||205")

	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	if (ScheduleDate="") set ScheduleDate=..%SysDate()
		
	if ASRowId'=""  d
	.Do FindByASRowId
	.Set L1="" For  Set L1=$O(^TMP("ApptScheduleList",$j,L1)) Quit:L1=""  Do
	..Set L2="" For  Set L2=$O(^TMP("ApptScheduleList",$j,L1,L2)) Quit:L2=""  Do
	...Set L3="" For  Set L3=$O(^TMP("ApptScheduleList",$j,L1,L2,L3)) Quit:L3=""  Do
	....Set L4="" For  Set L4=$O(^TMP("ApptScheduleList",$j,L1,L2,L3,L4)) Quit:L4=""  Do
	.....Set ^CacheTemp(repid,ind)=^TMP("ApptScheduleList",$j,L1,L2,L3,L4)
	.....Set ind=ind+1 
	.Set qHandle=$lb(0,repid,0)
	.Kill ^TMP("ApptScheduleList",$j)
	Quit:(ASRowId'="") $$$OK
	
	Set LocStr=""
	i LocationName'=""  d
	.Set LocRowid="" For  Set LocRowid=$O(^CTLOC(LocRowid)) Quit:LocRowid=""  Do
	..Set LocDesc=$P($g(^CTLOC(LocRowid)),"^",2)
	..q:LocDesc=""
	..i LocDesc[LocationName  d
	...i LocStr="" s LocStr=LocRowid
	...e  s LocStr=LocStr_"^"_LocRowid
    
    Set DocStr=""
    i DoctorName'=""  d
	.Set DocRowid="" For  Set DocRowid=$O(^CTPCP(DocRowid)) Quit:DocRowid=""  Do
	..Set DocDesc=$P($g(^CTPCP(DocRowid,1)),"^",2)
	..q:DocDesc=""
	..i DocDesc[DoctorName  d
	...i DocStr="" s DocStr=DocRowid
	...e  s DocStr=DocStr_"^"_DocRowid
	
    If (LocStr'="") d
    .For LocFor=1:1:$l(LocStr,"^")  Do
    ..Set LocRowid=$p(LocStr,"^",LocFor)
    ..Quit:LocRowid=""
 	..Do FindByLoc
 	..Set L1="" For  Set L1=$O(^TMP("ApptScheduleList",$j,L1)) Quit:L1=""  Do
	...Set L2="" For  Set L2=$O(^TMP("ApptScheduleList",$j,L1,L2)) Quit:L2=""  Do
	....Set L3="" For  Set L3=$O(^TMP("ApptScheduleList",$j,L1,L2,L3)) Quit:L3=""  Do
	.....Set L4="" For  Set L4=$O(^TMP("ApptScheduleList",$j,L1,L2,L3,L4)) Quit:L4=""  Do
	......Set ^CacheTemp(repid,ind)=^TMP("ApptScheduleList",$j,L1,L2,L3,L4)
	......Set ind=ind+1 
	..Set qHandle=$lb(0,repid,0)
	..Kill ^TMP("ApptScheduleList",$j)
	Quit:(LocStr'="") $$$OK
	
	If (DocStr'="") d
    .For DocFor=1:1:$l(DocStr,"^")  Do
    ..Set DocRowid=$p(DocStr,"^",DocFor)
    ..Quit:DocRowid=""
	..Do FindByDoc
	..Set L1="" For  Set L1=$O(^TMP("ApptScheduleList",$j,L1)) Quit:L1=""  Do
	...Set L2="" For  Set L2=$O(^TMP("ApptScheduleList",$j,L1,L2)) Quit:L2=""  Do
	....Set L3="" For  Set L3=$O(^TMP("ApptScheduleList",$j,L1,L2,L3)) Quit:L3=""  Do
	.....Set L4="" For  Set L4=$O(^TMP("ApptScheduleList",$j,L1,L2,L3,L4)) Quit:L4=""  Do
	......Set ^CacheTemp(repid,ind)=^TMP("ApptScheduleList",$j,L1,L2,L3,L4)
	......Set ind=ind+1 
	..Set qHandle=$lb(0,repid,0)
	..Kill ^TMP("ApptScheduleList",$j)
	
	Set qHandle=$lb(0,repid,0)	
	Quit $$$OK
	
FindByASRowId
	Set ResRowId=$p(ASRowId,"||",1)
	Set ASChildSub=$p(ASRowId,"||",2)
	Do OutputRow	
	Quit
		
FindByLoc
	Quit:'$d(^RB("RES",0,"CTLOC",LocRowid))
	;i ScheduleDate="" set ScheduleDate=..%SysDate()
	Set ResRowId="" f  s ResRowId=$o(^RB("RES",0,"CTLOC",LocRowid,ResRowId))  q:ResRowId=""  d
	.Q:'$D(^RBAS(ResRowId,0,"DateSTime"))
	.Set CTPId=$p($g(^RB("RES",ResRowId)),"^",2)
	.Quit:(DocStr'="")&&(("^"_DocStr_"^")'[("^"_CTPId_"^"))
	.s ASSessStartTime="" f  s ASSessStartTime=$O(^RBAS(ResRowId,0,"DateSTime",ScheduleDate,ASSessStartTime)) q:(ASSessStartTime="")  d
	..s ASChildSub=0  f  s ASChildSub=$O(^RBAS(ResRowId,0,"DateSTime",ScheduleDate,ASSessStartTime,ASChildSub)) q:(ASChildSub="")  d
	...Do OutputRow
	Quit
	
FindByDoc
	Quit:'$d(^RB("RES",0,"CTPCP",DocRowid))
	Set LocRowid="" f  s LocRowid=$o(^RB("RES",0,"CTPCP",DocRowid,LocRowid))  q:LocRowid=""  d
	.Quit:(LocStr'="")&&(("^"_LocStr_"^")'[("^"_LocRowid_"^"))
	.Set ResRowId="" f  s ResRowId=$o(^RB("RES",0,"CTPCP",DocRowid,LocRowid,ResRowId))  q:ResRowId=""  d
	..Q:'$D(^RBAS(ResRowId))
	..s ASSessStartTime="" f  s ASSessStartTime=$O(^RBAS(ResRowId,0,"DateSTime",ScheduleDate,ASSessStartTime)) q:(ASSessStartTime="")  d
	...s ASChildSub=0  f  s ASChildSub=$O(^RBAS(ResRowId,0,"DateSTime",ScheduleDate,ASSessStartTime,ASChildSub)) q:(ASChildSub="")  d
	....Do OutputRow
	Quit
	
OutputRow
	Do ResetVariables
 	Set ID=ResRowId_"||"_ASChildSub
 	Set DepID=$p($g(^RB("RES",ResRowId)),"^",1)
 	i DepID'="" Set DepName=$p($g(^CTLOC(DepID)),"^",2)
 	set DepName1=$P(DepName,"-",2)
    	if DepName1'="" set DepName=DepName1
 	Set DoctorID=$p($g(^RB("RES",ResRowId)),"^",2)
 	i DoctorID'="" Set DoctorName=$p($g(^CTPCP(DoctorID,1)),"^",2)
 	;lxz加入User权限设置判断,否则只选择科室不选择医生会查询科室下所有医生可修改。
 	s UserCanDoFlag=1
 	if UserID'="" d
 	.s UserCanDoFlag=##class(web.DHCUserGroup).UserCanDo(UserID,DepID,DoctorID)
 	Q:'UserCanDoFlag
 	;诊室
 	Set RoomID=$p($G(^RBAS(ResRowId,ASChildSub,"DHC")),"^",5)
 	i RoomID'="" Set RoomName=$p($g(^CTLOC(RoomID)),"^",2)
 	set RoomName1=$P(RoomName,"-",2)
    	if RoomName1'="" set RoomName=RoomName1
    	;出诊日期
	Set AsDate=$p(^RBAS(ResRowId,ASChildSub),"^",1)
	;if AsDate'=""  s AsDate=$zd(AsDate,4)
	;开始时间
	Set SessionStartTime=$p(^RBAS(ResRowId,ASChildSub),"^",4)
	s SessionStartTime=..%ZT(SessionStartTime,1)
	;结束时间
	Set SessionEndTime=$p(^RBAS(ResRowId,ASChildSub),"^",5)
	s SessionEndTime=..%ZT(SessionEndTime,1)
	;出诊时段
	set SessionTimeID=$P($G(^RBAS(ResRowId,ASChildSub,"DHC")),"^",17)
	if SessionTimeID'="" s SessionTimeName=$P($G(^DHCTimeRange(SessionTimeID)),"^",2)
	;出诊级别
	s SessionTypeDr=$P($G(^RBAS(ResRowId,ASChildSub,"DHC")),"^",6)
	i SessionTypeDr'="" s SessionTypeDesc=$P($G(^RBC("SESS",SessionTypeDr)),"^",2)
	;出诊时段
	;Set SessionTimeID=$p(^RBAS(ResRowId,ASChildSub),"^",5)
	;价格
	Set FeeStr=""
    set Price=##class(web.DHCOPAdmReg).GetScheduleFee(ID,"", +$H, FeeStr)
	;出诊限额
	Set TotalNum=$p(^RBAS(ResRowId,ASChildSub),"^",8)
	Set BookNum=$p(^RBAS(ResRowId,ASChildSub),"^",2)
	Set OverBookNum=$P($G(^RBAS(ResRowId,ASChildSub,"DHC")),"^",3)
	Set AppStartNo=$p(^RBAS(ResRowId,ASChildSub),"^",10)
	Set QueueNO=$P($G(^RBAS(+ID,$P(ID,"||",2),"DHC")),"^",4)
	Set RBEffDateSessionID=$p(^RBAS(ResRowId,ASChildSub),"^",12)
	Set IrregularFlag=$p(^RBAS(ResRowId,ASChildSub),"^",13)
	Set Status="",StatusDesc=""
	Set StatusDr=$P($G(^RBAS(ResRowId,ASChildSub,"DHC")),"^",10)
	i StatusDr'="" {
		s Status=$P($G(^DHCRBCASStatus(StatusDr)),"^",1)
		s StatusDesc=$P($G(^DHCRBCASStatus(StatusDr)),"^",2)
	}
	s TRRBASRowId=$P($G(^RBAS(ResRowId,ASChildSub,"DHC")),"^",12)
	i (TRRBASRowId'="") d
	.i $d(^RB("RES",+TRRBASRowId)) d
	..s TRDocRowId= $P($G(^RB("RES",+TRRBASRowId)),"^",2)
	..s TRDoc=$p($g(^CTPCP(TRDocRowId,1)),"^",2)
	;判断是否填写预约限额
	if (OverBookNum'="0")   d
    .set sc=##class(web.DHCRBResourceRule).CheckAppQtyByApptSchedule(ID)
	.;if ('sc)  d
	..;if status="N" set Status="X"
	s SessionClinicGroupDr=$P($G(^RBAS(ResRowId,ASChildSub,"DHC")),"^",7)
    s SessionClinicGroupDr=##class(web.DhcResEffDateSessionClass).CheckClinicGroupDR(DepID,SessionClinicGroupDr)
    i SessionClinicGroupDr'="" s SessionClinicGroupDesc=$P($G(^RBC("CLGRP",SessionClinicGroupDr)),"^",2)
	set retnum=##class(web.DHCRBResourceRule).GetRegisterNum(QueueNO,ID)
	set RegisterNum=$P(retnum,"^",1)
	set AppedNum=$P(retnum,"^",2)
	set AppedArriveNum=$P(retnum,"^",3)
	
	s TRRBASRowId=$P($G(^RBAS(ResRowId,ASChildSub,"DHC")),"^",12)
	set LockFlag=$P($G(^RBAS(ResRowId,ASChildSub,"DHC")),"^",16)
	set LockFlag=$P($G(^RBAS(ResRowId,ASChildSub,"DHC")),"^",7)
	
	s ASTimeRangeFlag=$P($G(^RBAS(ResRowId,ASChildSub,"DHC")),"^",19)
	;i ASTimeRangeFlag="Y" s ASTimeRangeFlag=1
	s ASTRStartTime=$P($G(^RBAS(ResRowId,ASChildSub,"DHC")),"^",20)
	s ASTREndTime=$P($G(^RBAS(ResRowId,ASChildSub,"DHC")),"^",21)
	s ASTRLength=$P($G(^RBAS(ResRowId,ASChildSub,"DHC")),"^",22)
	s ASTRRegNum=$P($G(^RBAS(ResRowId,ASChildSub,"DHC")),"^",23)
	s ASTRRegNumStr=$P($G(^RBAS(ResRowId,ASChildSub,"DHC")),"^",24)
	s ASTRRegInfoStr=$P($G(^RBAS(ResRowId,ASChildSub,"DHC")),"^",25)
	s ASAddRegNum=$P($G(^RBAS(ResRowId,ASChildSub,"DHC")),"^",26)
	s StopRegNoFlag=$P($G(^RBAS(ResRowId,ASChildSub,"DHC")),"^",27)
	s NoLimitLoadFlag=$P($G(^RBAS(ResRowId,ASChildSub,"DHC")),"^",31)
	if NoLimitLoadFlag="Y"{
		s BookNum="-"
		s AppStartNo="-"
	}
	s QueueNO=##class(web.DHCRBResourceRule).GetFreeQueueNO(QueueNO)	
	s SessionClinicGroupDrStr="",SessionClinicGroupDescStr=""
	s ClinicGroupStr=##class(web.DHCApptScheduleNew).GetClinicGroupDrStr(ID)
	if ClinicGroupStr'=""{
		s SessionClinicGroupDrStr=$p(ClinicGroupStr,"^",1)
		s SessionClinicGroupDescStr=$p(ClinicGroupStr,"^",2)
	}
	s TRInfo=ASTimeRangeFlag_"^"_ASTRStartTime_"^"_ASTREndTime_"^"_ASTRLength_"^"_ASTRRegNum_"^"_ASTRRegNumStr_"^"_ASTRRegInfoStr_"^"_ASAddRegNum_"^"_StopRegNoFlag
	
	Quit:(ClinicGroupName'="")&&(SessionClinicGroupDesc'[ClinicGroupName)
	set Data=$LB(ID,DepName,DepID,DoctorName,DoctorID,RoomName,RoomID,AsDate,SessionStartTime,SessionEndTime,SessionTimeName,SessionTypeDesc,SessionTimeID,Price,TotalNum,BookNum,OverBookNum,AppStartNo,QueueNO,Status,StatusDesc,RegisterNum,AppedNum,AppedArriveNum,TRDoc,SessionClinicGroupDr,SessionClinicGroupDesc,SessionTypeDr,LockFlag,IrregularFlag,TRInfo,SessionClinicGroupDrStr,SessionClinicGroupDescStr,NoLimitLoadFlag)
	;lxz 原来取值节点少一层（ASChildSub）,如果先停在加之后虽然是最后一个有效状态显示但是界面上的数据肯定显示不全
	Set ^TMP("ApptScheduleList",$j,AsDate,SessionStartTime,ResRowId,ASChildSub)=Data
	Quit
	
ResetVariables
	Set (ID,DepName,DepID,DoctorName,DoctorID,RoomName,RoomID,AsDate,SessionStartTime,SessionEndTime,SessionTimeName,SessionTypeDesc,SessionTimeID,Price,TotalNum,BookNum,OverBookNum,AppStartNo,QueueNO,Status,RegisterNum,AppedNum,AppedArriveNum,TRDoc,SessionClinicGroupDr,SessionClinicGroupDesc,SessionTypeDr,LockFlag,IrregularFlag,SessionClinicGroupDrStr,SessionClinicGroupDescStr,NoLimitLoadFlag)=""
	Quit
}

ClassMethod ApptScheduleListQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ApptScheduleListQueryExecute ]
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

/// 撤消替诊
ClassMethod CancelOneSchedule(ScheduleID As %String) As %String
{
}

/// 撤消停诊
/// w ##class(web.DHCRBApptSchedule).CancelStopOneSchedule("580||773")
ClassMethod CancelStopOneSchedule(ScheduleID As %String, IsAudit As %String = "0") As %String
{
	
	set ResRowId=+ScheduleID
	set schedule=##class(User.RBApptSchedule).%OpenId(ScheduleID)
	set ScheduleDate=schedule.ASDate
	set SessStartTime=schedule.ASSessStartTime
	set Roomid=""
	Set object = ##class(User.DHCRBApptSchedule).%OpenId(ScheduleID)
	if $IsObject(object.ASRoomDR)	s Roomid=object.ASRoomDR.%Id()

	set ret=##class(web.DHCRBResourceRule).CheckSchedule(ResRowId,ScheduleDate,Roomid, SessStartTime,ScheduleID)
	if ret'=0 {
		s retcode=$P(ret,"^",1)
		s DulASRowId=$P(ret,"^",2)
		if (DulASRowId'=""){
			s DulResRowId=$P(DulASRowId,"||",1)
			s DulResDocRowId=$p(^RB("RES",DulResRowId),"^",2)
			s DulResLocRowId=$p(^RB("RES",DulResRowId),"^",1)
			s DulResDocDesc=$p(^CTPCP(DulResDocRowId,1),"^",2)
			s DulResLocDesc=$p($g(^CTLOC(DulResLocRowId)),"^",2)
		}
		Quit retcode_"^"_DulResLocDesc_DulResDocDesc
	}
	if (IsAudit="0")&&(+(##class(web.DHCRBApptScheduleAudi).GetRBASRequestFlag("SC",ScheduleID))=1){
		s AuditStatus=##class(web.DHCRBApptScheduleAudi).CheckIsAuditStatus(ScheduleID)
		if AuditStatus'=""{
			q AuditStatus
		}
		s InfoStr="SC"_"^"_""_"^"_"^"_"^"_"^"
		q ..RBASRequest(ScheduleID,InfoStr)
	}
	set OldDataJson=##class(web.DHCDocDataChangeLog).GetLogJsonData("User.RBApptSchedule"_$c(2)_ScheduleID_"^"_"User.DHCRBApptSchedule"_$c(2)_ScheduleID)
	TStart	
	set StatusCode=##class(web.DHCRBApptSchedule).GetRBApptScheduleStatus(ScheduleID)
	set schedule=##class(User.DHCRBApptSchedule).%OpenId(ScheduleID)
	&SQL(Select ASS_Rowid into :ASStatusDR from SQLUser.DHC_RBCASStatus Where ASS_Code=:StatusCode)
	Do schedule.ASStatusDRSetObjectId(ASStatusDR)
	Do schedule.ASReasonNotAvailDRSetObjectId("")
	Set sc = schedule.%Save()
	If $$$ISERR(sc) {
		Do $System.Status.DisplayError()
		Trollback
		Quit 100
	}
	;做停诊日志
	s ret=##class(web.DHCRBApptScheduleUpdateLog).AddRBApptScheduleLog("CS",ScheduleID,"")
	If ret'=0 {
		Trollback
		Quit 100
	}
	;状态改变日志
	s ret=##class(web.DHCRBApptSchedule).AddRBApptScheduleStatusLog(ScheduleID,StatusCode)
	If ret'=0 {
		Trollback
		Quit 100
	}
	;医生站业务数据修改日志
	set NewDataJson=##class(web.DHCDocDataChangeLog).GetLogJsonData("User.RBApptSchedule"_$c(2)_ScheduleID_"^"_"User.DHCRBApptSchedule"_$c(2)_ScheduleID)
	set ret=##class(web.DHCDocDataChangeLog).SaveLog("RB_ApptSchedule#DHC_RBApptSchedule","User.RBApptSchedule#User.DHCRBApptSchedule","排班信息","User.RBApptSchedule#User.DHCRBApptSchedule_"_ScheduleID,$p($g(^RB("RES",+ScheduleID)),"^",17),"U",NewDataJson,OldDataJson)
	If ret'=0 {
		Trollback
		s ^tempscl("NewDataJson")=$lb(ret,"RB_ApptSchedule#DHC_RBApptSchedule","User.RBApptSchedule#User.DHCRBApptSchedule","排班信息","User.RBApptSchedule#User.DHCRBApptSchedule_"_ScheduleID,$p($g(^RB("RES",+ScheduleID)),"^",17),"U",NewDataJson,OldDataJson)
		Quit 100
	}
	Tcommit
	
	//大屏接口
	s CFIFScreenStart=##class(web.DHCOPRegConfig).GetSpecConfigNode("IFScreenStart")
	if (CFIFScreenStart=1)&&(ScheduleDate=..%SysDate()){
		s FullFlag=##class(web.DHCRBApptSchedule).CheckScheduleFull(ScheduleID)
		d ##class(dhcinterface.DoctorApptScheClient).SetScreenDisplayMsg(ScheduleID,FullFlag)
	}
	Quit 0
}

/// 检查是否现场号已满
ClassMethod CheckScheduleFull(RBASId As %String)
{
	;w ##class(web.DHCRBApptSchedule).CheckScheduleFull("1||1")
	s SingleQueueNo=""
	s ResRowId=$P(RBASId,"||",1)
	s Childsub=$P(RBASId,"||",2)
	
	;无此排班记录
	Q:'$d(^RBAS(ResRowId,Childsub)) "-1"
	
	;挂号限额=预约限额+正号限额
	s Load=$P($G(^RBAS(ResRowId,Childsub)),"^",8)
	;预约限额
	s AppLoad=$P($G(^RBAS(ResRowId,Childsub)),"^",2)
	;加号限额
	s AddLoad=$P($G(^RBAS(ResRowId,Childsub,"DHC")),"^",3)
	
	s ASQueueNo=$P(^RBAS(ResRowId,Childsub,"DHC"),"^",4)
	;正号串与加号串
	s NormalQueueNoStr=$P(ASQueueNo,$C(1),1)
	s AddQueueNoStr=$P(ASQueueNo,$C(1),2)
	Q:NormalQueueNoStr="" 0
	 
	//正常挂号取号(包括预约的)
	set Count=0
 for i=1:1:$l(NormalQueueNoStr,",") {
	 	s SingleQueueNoStr=$P(NormalQueueNoStr,",",i)
	 	s QueueNoStatus=$P(SingleQueueNoStr,":",2)
	 	s QueueNo=$P(SingleQueueNoStr,":",1)
	 	;未取号和已退号的可用
	 	i ((QueueNoStatus'=0)&&(QueueNoStatus'=4)){
		 	s Count=Count+1
	 	}
 }
	set Count1=0
 for i=1:1:$l(AddQueueNoStr,",") {
	 	s SingleQueueNoStr=$P(AddQueueNoStr,",",i)
	 	s QueueNoStatus=$P(SingleQueueNoStr,":",2)
	 	s QueueNo=$P(SingleQueueNoStr,":",1)
	 	;未取号和已退号的可用
	 	i ((QueueNoStatus'=0)&&(QueueNoStatus'=4)){
		 	s Count1=Count1+1
	 	}
 }

	if (Count'<Load)&&(Count1'<AddLoad) Q 1
	Q 0
}

/// 生成所有资源排班记录
ClassMethod CreateDaysSchedule(StartDate As %Date, EndDate As %Date, CreateMode As %String, Group As %String = "", UserID As %String = "", SchStr As %String = "", weekflag As %String = "", ASSESSRowIdStr As %String = "", ScheduleLinesRowId As %String = "", HospID = "")
{
	;在w ##class(web.DHCRBApptSchedule).CreateDaysSchedule(65545,65545,0,323,12062,"50|2","","",12,3)
	; CreateMode:更新方式,如果排班记录已经存在决定是否更新
	; 0:不更新  非0:更新
	n (StartDate,EndDate,CreateMode,Group,UserID,SchStr,weekflag,ASSESSRowIdStr,%session,ScheduleLinesRowId,HospID)
	s ^tempscl("CreateDaysSchedule1")=StartDate_","_EndDate_","_CreateMode_","_Group_","_UserID_","_SchStr_","_weekflag_","_ASSESSRowIdStr_","_ScheduleLinesRowId_","_HospID
	s LocStr=""
	K ^DHCSchedBatchLog("SCHED",+$H)
	//s RowId=0  f  Set RowId=$o(^RB("RES",RowId)) quit:RowId=""  d
	//修改为按科室顺序
	Set SchStrLen=$l(SchStr,"^")
	Set SchLocArr=""
	//Set SchDoc=""
	for i=1:1:SchStrLen{
		Set SchLoc=$p($p(SchStr,"^",i),"|",1)
		Set SchDoc=$p($p(SchStr,"^",i),"|",2)
		if (SchLoc'=""){
			if $g(SchLocArr(SchLoc))="" Set SchLocArr(SchLoc)=SchDoc
			else  Set SchLocArr(SchLoc)=SchLocArr(SchLoc)_"^"_SchDoc
		}
	}
	s loc=0 f  Set loc=$o(^RB("RES",0,"CTLOC",loc)) quit:loc=""  d
	.s LocActiveDateFrom=$p(^CTLOC(loc),"^",24)
	.s LocActiveDateTo=$p(^CTLOC(loc),"^",25)
	.Q:(LocActiveDateFrom'="")&&(LocActiveDateFrom>+$h)
	.Q:(LocActiveDateTo'="")&&(LocActiveDateTo<=..%SysDate())
	.;q:(UserID'="")&&('$D(^User.DHCUserGroupI("UserLocDoc"," "_UserID," "_loc)))
	.q:(UserID'="")&&('##class(web.DHCUserGroup).UserCanDo(UserID,loc))
	.s locHospId=$p(^CTLOC(loc),"^",22)
	.q:((HospID'="")&&(HospID'=locHospId))
	.s flag=0
	.s SubmitInfo=$G(^CTLOC(loc,"RBSSubmit")) //Flag_"^"_Date,Time_"^"_User
	.s Flag=$P(SubmitInfo,"^",1)
	.//q:Flag'="S"
	.Quit:(SchStr'="")&&('$d(SchLocArr(loc)))
	.s LocCreatFlag="N" ;科室内有号别生成了排班
	.s RowId=0 f  Set RowId=$o(^RB("RES",0,"CTLOC",loc,RowId)) quit:RowId=""  d
	..s CTPCPRowId=$P(^RB("RES",RowId),"^",2)
	..;如果非医生则退出
	..Q:CTPCPRowId=""
	..;q:(UserID'="")&&('$D(^User.DHCUserGroupI("UserLocDoc"," "_UserID," "_loc," "_CTPCPRowId)))
	..;q:(UserID'="")&&('##class(web.DHCUserGroup).UserCanDo(UserID,loc,CTPCPRowId))
	..;判断是否需要排班
	..s DateFrom=$p(^RB("RES",RowId),"^",22)
	..s DateTo=$p(^RB("RES",RowId),"^",23)
	..;Quit:(DateTo'="")&&(DateTo<(+$h))
	..s ScheSt=$p(^RB("RES",RowId),"^",6)
	..Q:(ScheSt'="Y")
	..Quit:($g(SchLocArr(loc))'="")&&(("^"_$g(SchLocArr(loc))_"^")'[("^"_CTPCPRowId_"^"))
	..Q:(DateTo'="")&&(DateTo<StartDate)
	..Q:(DateFrom'="")&&(DateFrom>EndDate)
	..s CreateDateF=StartDate,CreateDateT=EndDate
	..i (DateFrom'="")&&(CreateDateF<DateFrom) s CreateDateF=DateFrom
	..i (DateTo'="")&&(CreateDateT>DateTo) s CreateDateT=DateTo
	..s flag=..CreateResDaysSchedule(RowId,CreateDateF,CreateDateT,CreateMode,weekflag,ASSESSRowIdStr,UserID,Group,ScheduleLinesRowId,HospID)
	..if (flag'=0)&&(LocCreatFlag'="Y") s LocCreatFlag="Y"
	.q:LocCreatFlag'="Y"
	.;q:flag=0
	.d ##class(web.DHCOPAdmRegQuery).LocSubmit(loc,"C",UserID)
	.s LocDesc=$P(^CTLOC(loc),"^",2)
	.i LocStr="" d
	..s LocStr=loc_"^"_LocDesc
	.e  d
	..s LocStr=LocStr_$C(1)_loc_"^"_LocDesc
	q LocStr
}

/// 生成指定资源的排班记录
ClassMethod CreateResDaysSchedule(ResRowId As %String, StartDate As %Date, EndDate As %Date, CreateMode As %String, weekflag As %String = "", ASSESSRowIdStr As %String = "", UserID As %String = "", GroupID As %String = "", ScheduleLinesRowId As %String = "", HospID = "")
{
	s ^guo("CreateResDaysSchedule",ResRowId)=$lb(ResRowId , StartDate , EndDate , CreateMode , weekflag , ASSESSRowIdStr,UserID,GroupID,HospID)
	;d ##class(web.DHCRBApptSchedule).CreateResDaysSchedule(824,61006,61015,1)
	n (ResRowId,StartDate,EndDate,CreateMode,weekflag,ASSESSRowIdStr,%session,UserID,GroupID,ScheduleLinesRowId,HospID)
	Set Geneflag=0
	s CFHolidayNotCreateSche=##class(web.DHCOPRegConfig).GetSpecConfigNode("HolidayNotCreateSche") 
	if (ScheduleLinesRowId=""){
		s ResDateRowId=##class(web.DHCRBResSession).GetValidEffectDateRowId(ResRowId)
		s DateRowId=$P(ResDateRowId,"||",2)
	}else{
		s DateRowId=$o(^RB("RES",ResRowId,"DATE",0,"RSL",ScheduleLinesRowId,""),-1)
		s ResDateRowId=ResRowId_"||"_DateRowId
	}
	;s:ResRowId="3279" ^wrz(3299,3279)=ResDateRowId
	;s:ResRowId="3278" ^wrz(3301,3278)=ResDateRowId
	Q:DateRowId="" Geneflag
	S SessRowId=0 f  s SessRowId=$O(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId)) Q:(SessRowId="")  d
	.Q:$D(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId))=10
	.S SessDOWRowid=$p(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",2)
	.S SessScheduleGenerFlag=$p(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",16)
	.Q:(SessScheduleGenerFlag="N") 
	.Q:(ASSESSRowIdStr'="")&&(("^"_ASSESSRowIdStr_"^")'[("^"_ResRowId_"||"_DateRowId_"||"_SessRowId_"^"))
	.for CurrDate=StartDate:1:EndDate d
	..s CurrWeek=$ZD(CurrDate,10)
	..if CurrWeek=0 Set CurrWeek=7
	..;Q:(SessDOWRowid'=CurrWeek)&(CurrWeek'=0)&(SessDOWRowid'=7)
	..;Q:(SessDOWRowid'=CurrWeek)
	..Q:(SessDOWRowid'=CurrWeek)&&(SessDOWRowid'="")
	..// 生成日期段内 某一个星期几的排班
	..Q:(weekflag'="")&&(weekflag<=7)&&(CurrWeek'=weekflag)
	..S SessRowid=ResDateRowId_"||"_SessRowId
	..s HoliCreateflag=0
	..i CFHolidayNotCreateSche="1" d
	...// 判断日期是否为节假日，走基础数据维护-》节假日维护界面 节日2/假日1/非节假日0 /错误 -1
	...s IsHoliday=##class(web.DHCBL.CT.BDPHoliday).IsHolidayDate(..%ZD(CurrDate),"","") 
	...//##class(web.DHCOPRegFestivalSet).CheckDayIsFestival(CurrDate)
	...i (IsHoliday=2) s HoliCreateflag=1
	..//Q:HoliCreateflag=1
	..Q:(HoliCreateflag=1)&&(weekflag<=7)
	
	..s FlagStop=..IsStopRBResource(ResRowId,CurrDate) ;判断资源是否在停诊中
	..Q:FlagStop="Y"
	..i ResRowId="168" b //5462
	..s err=..CreateResOneDaySchedule(SessRowid,CurrDate,CreateMode,UserID,GroupID,HospID)
	..b ;err
	..Set Geneflag=Geneflag+1
	if Geneflag'=0 Do
	.Set loc=$P(^RB("RES",ResRowId),"^",1)
	.Set doc=$P(^RB("RES",ResRowId),"^",2)
	.Set LocDesc=$P($g(^CTLOC(loc)),"^",2)
	.Set CTPCPName=$P($g(^CTPCP(doc,1)),"^",2)
	.Set ^DHCSchedBatchLog("SCHED",+$H,loc)=LocDesc
	.Set ^DHCSchedBatchLog("SCHED",+$H,loc,doc)=CTPCPName
	q Geneflag
}

/// 生成指定资源指定日期的排班记录
ClassMethod CreateResOneDaySchedule(ResSessRowid As %String, CreateDate As %Date, CreateMode As %String, UserID As %String = "", GroupID As %String = "", HospID = "")
{
	i ResSessRowid="546||1||1" s ^guo("CreateResOneDaySchedule",ResSessRowid)=ResSessRowid_"^"_CreateDate_"^"_CreateMode
	;w ##class(web.DHCRBApptSchedule).CreateResOneDaySchedule("2||1||1",61100,1)
	n (ResSessRowid,CreateDate,CreateMode,%session,UserID,GroupID,HospID)
	Set object=##class(User.RBResEffDateSession).%OpenId(ResSessRowid)
	s SessRoomDR=""
	if $IsObject(object.SESSRoomDR)	s SessRoomDR=object.SESSRoomDR.%Id()
	s SESSSessionTypeDR=""
	if $IsObject(object.SESSSessionTypeDR) s SESSSessionTypeDR=object.SESSSessionTypeDR.%Id()
	s SESSClinicGroupDR=""
	if $IsObject(object.SESSClinicGroupDR) s SESSClinicGroupDR=object.SESSClinicGroupDR.%Id()
	s SessTimeStart=object.SESSTimeStart
	s SessTimeEnd=object.SESSTimeEnd
	s SessSlotLength=object.SESSSlotLength
	s SessLoad=object.SESSLoad
	s SessNoSlots=object.SESSNoSlots
	s SessNoApptSlot=object.SESSNoApptSlot
	s SessNumberOfWeeks=object.SESSNumberOfWeeks
	s SessNoOverbookAllowed=object.SESSNoOverbookAllowed
	s TRRowId=object.SESSSessionNo
	s SessClinicGroupDRStr=object.SESSClinicGroupDRStr
	if SessClinicGroupDRStr'="" s SESSClinicGroupDR=SessClinicGroupDRStr
	s SESSNoLimitLoadFlag=object.SESSNoLimitLoadFlag
	
	s Para=CreateDate_"^"_SessTimeStart_"^"_SessTimeEnd_"^"_SessLoad_"^"_SessNoApptSlot_"^"_SessNumberOfWeeks_"^"_SessNoOverbookAllowed_"^"_SessRoomDR_"^"_SESSSessionTypeDR_"^"_SESSClinicGroupDR
	s Para=Para_"^"_TRRowId_"^"_SESSNoLimitLoadFlag ;12
	
	s TimeRangeRegInfo=$G(^RB("RES",+ResSessRowid,"DATE",$P(ResSessRowid,"||",2),"SESS",$P(ResSessRowid,"||",3),"DHC"))
	if ($p(TimeRangeRegInfo,"^",1)'="Y")&&($p(TimeRangeRegInfo,"^",1)'="N") s TimeRangeRegInfo="^^^^^^^^" 
	s Para=Para_"^"_TimeRangeRegInfo
	s ResRowId=$P(ResSessRowid,"||",1)
	s ASChildSub=$O(^RBAS(ResRowId,0,"DateTR",CreateDate,TRRowId,0))
	;w "ASChildSub:"_ASChildSub
	;b ;update
	s err=100
	;s ^guo("insert",ResSessRowid)=Para
	//如果排班先进行预约，再删除预约记录及排班记录，重新生成排班ASChildSub不为空，但此时^RBAS不存在
	if (ASChildSub'=""){
		if ('$d(^RBAS(ResRowId,ASChildSub))) s ASChildSub=""
	}
	if (ASChildSub="")
	{
		s err=..Insert(ResSessRowid,Para,UserID,GroupID,HospID)
		
	}else{
		s ResAppScheduleRowId=ResRowId_"||"_ASChildSub
		s rbasRegOrAppoInfo = ..GetASRegInfo(ResAppScheduleRowId)
		s rbasRegOrAppoCount = (+$p(rbasRegOrAppoInfo, "^", 1)) + (+$p(rbasRegOrAppoInfo, "^", 2))
		Set IrregularFlag=""
		Set IrregularFlag=$p(^RBAS(ResRowId,ASChildSub),"^",13)
		if IrregularFlag="A"{
			s err=..Update(ResAppScheduleRowId,Para,ResSessRowid)
		} else {
			if (rbasRegOrAppoCount = 0) {
				s err=..Update(ResAppScheduleRowId,Para,ResSessRowid)
			}
		}
		;s err=..Update(ResAppScheduleRowId,Para)
	}
	Q err
}

/// 获取挂号限额数据
ClassMethod GetAppQtyByApptSchedule(ScheduleID As %String) As %String
{
	Quit ##class(web.DHCRBApptScheduleAppQty).GetAppQtyByApptSchedule(ScheduleID)
}

/// 得到可用的排班记录RowId 串
ClassMethod GetAvailRA(ResRowId As %String, AdmDate As %Date, AdmTime As %Time, TimeRangeRowId As %String, SelectTRQuery As %String = "", IfAvailFlag As %String = "", ShowStopFlag As %String = "") As %String
{
	s ^tmpguo("GetAvailRA",$h)=ResRowId_","_AdmDate_","_AdmTime_","_TimeRangeRowId_","_SelectTRQuery_","_IfAvailFlag
	;w ##class(web.DHCRBApptSchedule).GetAvailRA(3997,64718,"","",1)	
	s ASRowIdStr="",ASRowId=""
    n TRRowId
	
	if $L(AdmDate,"/")=3 s AdmDate=$ZDH(AdmDate,4)
	if $L(AdmDate,"-")=3 s AdmDate=$ZDH(AdmDate,3)
	;先按照时段查看，如果时段为空就诊日期为当日按照。则查询当下所有时段。
	;如果不包含的话按照时段包含取应该显示的排班
	if (AdmDate=..%SysDate())&&(TimeRangeRowId="")  {
		s TimeRangeRowId=..GetTimeRangeStrByRange(TimeRangeRowId)
	}
	s NowTime=..%SysTime()
	s ASSessStartTime="" f  s ASSessStartTime=$O(^RBAS(ResRowId,0,"DateSTime",AdmDate,ASSessStartTime)) q:(ASSessStartTime="")  d
	.s ASChildSub=0  f  s ASChildSub=$O(^RBAS(ResRowId,0,"DateSTime",AdmDate,ASSessStartTime,ASChildSub)) q:(ASChildSub="")  d
	..s StartTime=ASSessStartTime
	..s EndTime=$P($G(^RBAS(ResRowId,ASChildSub)),"^",5)
	..;Q:(StartTime'="")&&(AdmTime'>StartTime)
	..;Q:(EndTime'="")&&(AdmTime'<EndTime)
	..s TRRowId=$P($G(^RBAS(ResRowId,ASChildSub,"DHC")),"^",17) //dhcrbapptschedul User.DHCTimeRange
	..i TRRowId="" s TRRowId=##class(web.DHCRBResSession).GetTimeRangeByTime(StartTime)
	..s RESEPMarkFlag=##class(web.DHCRBResource).GetEPMarkFlag(ResRowId)
	..s TRDesc=""
	..if TRRowId'="" s TRDesc=$P($G(^DHCTimeRange(TRRowId)),"^",2)
	..s ASStopRegNoFlag=$p($g(^RBAS(ResRowId,ASChildSub,"DHC")),"^",27) //停正号标志
	..Q:(ASStopRegNoFlag="Y")&&(AdmDate>+$h)
	..;--------若查询时段是"当前",判断时段的挂号时间段是否包含当前时间,若包含则显示该排班.----
	..s ASRegTimeRangIsContain=0
	..s HospId=$p(##class(web.DHCOPAdmReg).GetCurrentHosp("","",ResRowId_"||"_ASChildSub,""),"^",1)
	..if (TimeRangeRowId="CUR")&&(TRRowId'="") d
	...i (AdmDate=..%SysDate()) s ASRegTimeRangIsContain=..ChkRegTimeRangeIsContain(TRRowId,HospId)
	...e  s ASRegTimeRangIsContain=..ChkTimeRangeIsContain(TRRowId,HospId)
	..;-----------------当日号别按照挂号开始时间和结束时间检索   ----------------------------------
	..s RegTimeFlag="Y" ;允许查询
	..s OpenFlag="N" ;开启挂号时间标志
	..if ((TRRowId'="")&&(AdmDate=..%SysDate())&&(RESEPMarkFlag'=1)&&(TimeRangeRowId'=""))  d
	...s TRRegSTTime=$P($G(^DHCTimeRange(TRRowId)),"^",9)
	...s TRRegEndTime=$P($G(^DHCTimeRange(TRRowId)),"^",10)
	...if (TRRegSTTime'="")||(TRRegEndTime'="")  d
	....;开启了挂号时间,同步判断排班上得个性出诊截止时间.如果有一个不满足退出
	....s OpenFlag="Y"
	....if (TRRegSTTime'="")&&(NowTime<TRRegSTTime) s RegTimeFlag="N"
	....if (TRRegEndTime'="")&&(NowTime>TRRegEndTime) s RegTimeFlag="N"
	....s EndTime=$P($G(^RBAS(ResRowId,ASChildSub)),"^",5)
	....if (EndTime'="")&&(NowTime>EndTime) s RegTimeFlag="N"
	....if (RegTimeFlag="Y")&&(TimeRangeRowId'="CUR")&&(("!"_TimeRangeRowId_"!")'[("!"_TRRowId_"!")) s RegTimeFlag="N"
	....if (RegTimeFlag="N")&&(TimeRangeRowId'="CUR")&&(("!"_TimeRangeRowId_"!")[("!"_TRRowId_"!")) s RegTimeFlag="Y"
	..Q:(RegTimeFlag="N")
	..;开启得时候查看预约
	..Q:(AdmDate'=..%SysDate())&(RESEPMarkFlag'=1)&(TimeRangeRowId'="")&(TRRowId'="")&(("!"_TimeRangeRowId_"!")'[("!"_TRRowId_"!"))&(OpenFlag="Y")&(ASRegTimeRangIsContain=0)
	..;未开启还是走原来得时段
	..Q:(RESEPMarkFlag'=1)&(TimeRangeRowId'="")&(TRRowId'="")&(("!"_TimeRangeRowId_"!")'[("!"_TRRowId_"!"))&(OpenFlag="N")&(ASRegTimeRangIsContain=0)
	..s status=$P($G(^RBAS(ResRowId,ASChildSub,"DHC")),"^",10)
	..i status'="" s status=$P(^DHCRBCASStatus(status),"^",1)
	..;过滤停诊和替诊
	..;Q:(status="S")||(status="TR")||(status="PS")
	..Q:(status="TR")||(status="PS")
	..Q:(ShowStopFlag'="1")&&(status="S")
	..//过滤 待审核
	..Q:(status="AUD")
	..//只停诊预约和只停诊正号需求	
	..//Q:(($g(isApp)'="")&&(isApp=1)&&(status="SA"))
	..//Q:(($g(isApp)'="")&&(isApp'=1)&&(status="SP"))
	..s ASIrregularFlag=$p($g(^RBAS(ResRowId,ASChildSub)),"^",13)
	..;默认是不找不规则出诊记录的
	..q:((ASIrregularFlag="A")&&((IfAvailFlag="")||(IfAvailFlag="Y")))
	..s ASRowId=ResRowId_"||"_ASChildSub
	..i ASRowIdStr="" s ASRowIdStr=ASRowId
	..e  s ASRowIdStr=ASRowIdStr_"^"_ASRowId
	
	Q ASRowIdStr
}

/// 取得可挂出的诊号串
ClassMethod GetAvailSeqNoStr(RBASId As %String, RegType As %String, APPMethodRowId As %String = "", NotFormat As %String = "") As %String
{
	;w ##class(web.DHCRBApptSchedule).GetAvailSeqNoStr("179||8","NOR")
	;n (RBASId,RegType)
	s SingleQueueNo=""
	s ResRowId=$P(RBASId,"||",1)
	s Childsub=$P(RBASId,"||",2)
	;无此排班记录
	Q:'$d(^RBAS(ResRowId,Childsub)) "-1"
	
	s AppReturnTime=0
	s TRRowId=$P($G(^RBAS(ResRowId,Childsub,"DHC")),"^",17)
	if TRRowId'="" s AppReturnTime=$p($g(^DHCTimeRange(TRRowId)),"^",5)
	s CurrentDatTim=$h
	s CurrentDate=$p(CurrentDatTim,",",1),CurrentTime=$p(CurrentDatTim,",",2)
	
	s ASDate=$P(^RBAS(ResRowId,Childsub),"^",1)
	
	;取预约号信息
	s AppStartSeqNo=$P(^RBAS(ResRowId,Childsub),"^",10)
	;预约限额
	s APPSeqNoCount=$P(^RBAS(ResRowId,Childsub),"^",2)
	
	i AppStartSeqNo="" s AppStartSeqNo=0
	i APPSeqNoCount="" s AppStartSeqNo=0

	 s ASQueueNo=$P(^RBAS(ResRowId,Childsub,"DHC"),"^",4)
	 ;正号串与加号串
	 s NormalQueueNoStr=$P(ASQueueNo,$C(1),1)
	 s AddQueueNoStr=$P(ASQueueNo,$C(1),2)
	 
	Q:(NormalQueueNoStr="")&&((RegType="NOR")||(RegType="APP")) ""
	s QueueNoStr=""
	//现场号段
	i RegType="NORN" {
		;如果没有设定预约号段
		if (+APPSeqNoCount=0){
			s RegType="NOR"
		}else {
		 	for num=1:1:$l(NormalQueueNoStr,",") {
			 	s SingleQueueNoStr=$P(NormalQueueNoStr,",",num)
			 	s QueueNoStatus=$P(SingleQueueNoStr,":",2)
			 	s QueueNo=$P(SingleQueueNoStr,":",1)
			 	;未取号和已退号的可用及非预约的号
			 	s QueueNoInAppFlag=+##class(web.DHCRBApptScheduleAppQty).CheckQueueNoInApp(RBASId,QueueNo,$g(APPMethodRowId))
			 	i ((QueueNoStatus=0)||('##class(web.DHCRBAppointment).GetReturnAllowRegFlag(QueueNoStatus)))&&((QueueNoInAppFlag'=1)||((APPMethodRowId'="")||(APPMethodRowId'=1))){
				 	i QueueNoStr="" s QueueNoStr=QueueNo
				 	e  s QueueNoStr=QueueNoStr_","_QueueNo
			 	}
		 	}
	 	}
	}

	//当天可挂号包括未预约出去的号
	i RegType="NOR" {
	 	s NormalQueueNoLen=$l(NormalQueueNoStr,",")
	 	for i=1:1:NormalQueueNoLen {
		 	s SingleQueueNoStr=$P(NormalQueueNoStr,",",i)
		 	continue:SingleQueueNoStr=""
		 	s QueueNoStatus=$P(SingleQueueNoStr,":",2)
		 	s QueueNo=$P(SingleQueueNoStr,":",1)
		 	;addbynk-20180317
		 	Set AppReturnTime2=AppReturnTime
		 	if QueueNoStatus=2{
				Set AppReturnTime1=""
				Set ApptRowid=##class(web.DHCOPAdmReg).getApptRowidByQueNo(RBASId,QueueNo)
				if ApptRowid'="" Set AppReturnTime1=##class(web.DHCOPAdmReg).GetAppReturnTimeBySeqNo(RBASId,QueueNo)   //$g(^RBAS(+ApptRowid,$p(ApptRowid,"||",2),"APPT",$p(ApptRowid,"||",3),"DHCRetTime"))
				if AppReturnTime1'="" Set AppReturnTime2=AppReturnTime1
				else  Set AppReturnTime2=AppReturnTime
				
				;ApptRowid只会取到"I"状态的预约记录
				if (ApptRowid'="")&&(ASDate=CurrentDate)&&(CurrentTime>AppReturnTime2) {
					;如果预约不释放资源并增号且当前时间大于回归时间点 则增号
					;置为爽约状态
					d ##Class(web.DHCRBAppointment).AddAppBreak(ApptRowid,"")
				    if (##class(web.DHCRBAppointment).GetReturnAllowRegFlag(QueueNoStatus,"Y")){
						;d ##Class(web.DHCRBAppointment).AddAppBreak(ApptRowid,"")
						s AppMethod=$P(SingleQueueNoStr,":",3)
						s NormalQueueNoLen=##class(web.DHCRBAppointment).AddOneScheduleQueue(RBASId)	
					}
				}				
			}
			;addbynk-20180317
		 	;未取号和已退号的可用
		 	i ((QueueNoStatus=0)||('##class(web.DHCRBAppointment).GetReturnAllowRegFlag(QueueNoStatus))||(('##class(web.DHCRBAppointment).GetReturnAllowRegFlag(QueueNoStatus,"Y"))&&(CurrentTime>AppReturnTime2))){
			 	i QueueNoStr="" s QueueNoStr=QueueNo
			 	e  s QueueNoStr=QueueNoStr_","_QueueNo
		 	}
	 	}
	}
	
	//可挂预约号
	i RegType="APP" {
	 	;没有设定预约号信息
	 	Q:(+APPSeqNoCount=0) ""
	 	for num=1:1:$l(NormalQueueNoStr,",") {
		 	s SingleQueueNoStr=$P(NormalQueueNoStr,",",num)
		 	s QueueNoStatus=$P(SingleQueueNoStr,":",2)
		 	s QueueNo=$P(SingleQueueNoStr,":",1)
		 	;未取号和已退号的可用
		 	i ((QueueNoStatus=0)||('##class(web.DHCRBAppointment).GetReturnAllowRegFlag(QueueNoStatus))){
			 	;只取预约号段里的号
			 	s QueueNoInAppFlag=+##class(web.DHCRBApptScheduleAppQty).CheckQueueNoInApp(RBASId,QueueNo,$g(APPMethodRowId))
			 	i QueueNoInAppFlag=1 {
				 	i QueueNoStr="" s QueueNoStr=QueueNo
				 	e  s QueueNoStr=QueueNoStr_","_QueueNo
			 	}
		 	}
	 	}
	}
	//可挂加号
	i RegType="ADD" {
	 	for i=1:1:$l(AddQueueNoStr,",") {
		 	s SingleQueueNoStr=$P(AddQueueNoStr,",",i)
		 	s QueueNoStatus=$P(SingleQueueNoStr,":",2)
		 	s QueueNo=$P(SingleQueueNoStr,":",1)
		 	;未取号和已退号的可用
		 	i ((QueueNoStatus=0)||('##class(web.DHCRBAppointment).GetReturnAllowRegFlag(QueueNoStatus))){
			 	i QueueNoStr="" s QueueNoStr=QueueNo
			 	e  s QueueNoStr=QueueNoStr_","_QueueNo
		 	}
	 	}
	}
	Q:NotFormat="Y" QueueNoStr
	//处理输出格式转变为"1-10,13-15,16-20",缺失部分为不显示部分
	i RegType="ADD" {
		// 加号单独处理,by xp，2012-04-20
		s QueueNoStr=..FormatAddQueueNoStr(QueueNoStr)
	}else{
		s QueueNoStr=..FormatQueueNoStr(QueueNoStr)
	}
	
	
	Q QueueNoStr
}

/// w ##class(web.DHCRBApptSchedule).FormatAddQueueNoStr("+1,+2,+3")
/// w ##class(web.DHCRBApptSchedule).FormatAddQueueNoStr("+1,+2,+3,+5,+6,+9,+11,+12,+13")
ClassMethod FormatAddQueueNoStr(QueueNoStr As %String) As %String
{
	n (QueueNoStr)
	q:QueueNoStr="" ""
	s QueueNoStr=$tr(QueueNoStr,"+","")
	s QueueNoStr=..FormatQueueNoStr(QueueNoStr)
	s Len=$l(QueueNoStr,"-")
	q:Len<2 "+"_QueueNoStr
	s NewQueueNoStr=""
	f i=1:1:Len  d
	.s QueueNoNod=$p(QueueNoStr,"-",i)
	.s QueueNoNod="+"_QueueNoNod
	.i NewQueueNoStr="" s NewQueueNoStr=QueueNoNod
	.e  s NewQueueNoStr=NewQueueNoStr_"-"_QueueNoNod
	s QueueNoStr=NewQueueNoStr
	
	s Len=$l(QueueNoStr,",")
	q:Len<2 QueueNoStr
	s NewQueueNoStr=""
	f i=2:1:Len  d
	.s QueueNoNod=$p(QueueNoStr,",",i)
	.s QueueNoNod="+"_QueueNoNod
	.i NewQueueNoStr="" s NewQueueNoStr=QueueNoNod
	.e  s NewQueueNoStr=NewQueueNoStr_","_QueueNoNod
	s QueueNoStr=$p(QueueNoStr,",")_","_NewQueueNoStr
	q QueueNoStr
}

ClassMethod FormatQueueNoStr(QueueNoStr As %String) As %String
{
	n (QueueNoStr)
	Q:QueueNoStr="" ""
	s PreQueueNo=""
	s NextQueueNo=""
	s CurrQueueNo=""
	s myRtnStr=""
	
	s Len=$l(QueueNoStr,",")
	s i=Len
	while(i>0){
		s PreQueueNo=$p(QueueNoStr,",",i-1)
		s CurrQueueNo=$p(QueueNoStr,",",i)
		s NextQueueNo=$p(QueueNoStr,",",i+1)
		if NextQueueNo="",PreQueueNo="" s myRtnStr=CurrQueueNo_"-"_CurrQueueNo goto Next
		if NextQueueNo="" {
			s myRtnStr=myRtnStr_"-"_CurrQueueNo
			if CurrQueueNo'=(PreQueueNo+1) {
			   s myRtnStr="-"_PreQueueNo_","_CurrQueueNo_myRtnStr
		    }
			goto Next
		}
		if PreQueueNo="" {
			s myRtnStr=CurrQueueNo_myRtnStr
			goto Next
		}
		if CurrQueueNo'=(PreQueueNo+1) {
			s myRtnStr="-"_PreQueueNo_","_CurrQueueNo_myRtnStr
		}
Next
		s i=i-1
	}
	if ((+myRtnStr<0)&&($p($p(myRtnStr,",",1),"-",1)="")) s myRtnStr=$p(myRtnStr,"-",2)_"-"_$p(myRtnStr,"-",2,$l(myRtnStr,"-"))
	
	Q myRtnStr
}

ClassMethod GetNoScheduleDocStr(AdmDate As %String, loc As %String, TimeRangeRowId As %String) As %String
{
	s ^zhou("GetNoScheduleDocStr")=AdmDate_","_loc_","_TimeRangeRowId
	;w ##class(web.DHCRBApptSchedule).GetNoScheduleDocStr("2008-01-12",6,7)
	s ret=""
	Q:AdmDate="" ""
	s AdmDate=$ZDH(AdmDate,3)
	s RowId=0 f  Set RowId=$o(^RB("RES",0,"CTLOC",loc,RowId)) quit:RowId=""  d
	.s CTPCPRowId=$P(^RB("RES",RowId),"^",2)
	.;如果非医生则退出
	.Q:CTPCPRowId=""
	.;判断是否需要排班
	.s ScheSt=$p(^RB("RES",RowId),"^",6)
	.Q:(ScheSt'="Y")
	.s Find=$$HaveSchedule(RowId,AdmDate,TimeRangeRowId)
	.Q:Find=1
	.Q:('$d(^CTPCP(CTPCPRowId,1)))
	.s CTPCPDesc=$p(^CTPCP(CTPCPRowId,1),"^",2)
	.i $d(^CTPCP(CTPCPRowId,3)) d
	..s DocOtherName=$p(^CTPCP(CTPCPRowId,3),"^",28)
	..i DocOtherName'="" s CTPCPDesc=CTPCPDesc_"-"_DocOtherName
	.s Data=CTPCPRowId_$C(1)_CTPCPDesc
	.i ret="" s ret=Data
	.e  s ret=ret_"^"_Data
	Q ret
HaveSchedule(ResRowId,AdmDate,TimeRangeRowId)
	s Find=0
	s ASSessStartTime=0 f  s ASSessStartTime=$O(^RBAS(ResRowId,0,"DateSTime",AdmDate,ASSessStartTime)) q:(ASSessStartTime="")  d
	.s ASChildSub=0  f  s ASChildSub=$O(^RBAS(ResRowId,0,"DateSTime",AdmDate,ASSessStartTime,ASChildSub)) q:(ASChildSub="")  d
	..s StartTime=ASSessStartTime
	..s TRRowId=$P($G(^RBAS(ResRowId,ASChildSub,"DHC")),"^",17)
	..;s TRRowId=##class(web.DHCRBResSession).GetTimeRangeByTime(StartTime)
	..Q:(TRRowId'=TimeRangeRowId)
	..s status=$P($G(^RBAS(ResRowId,ASChildSub,"DHC")),"^",10)
	..i status'="" s status=$P(^DHCRBCASStatus(status),"^",1)
	..;被替诊的可以再次被安排
	..Q:(status="TR")!(status="S")
	..s Find=1
	Q Find
}

/// 取得已挂出或已预约出排号,
ClassMethod GetNotAvailSeqNoCount(RBASId As %String, RegType As %String) As %String
{
	;w ##class(web.DHCRBApptSchedule).GetNotAvailSeqNoCount("215||3","APP")
	s SingleQueueNo=""
	s ResRowId=$P(RBASId,"||",1)
	s Childsub=$P(RBASId,"||",2)
	
	;取预约号信息
	s AppStartSeqNo=$P(^RBAS(ResRowId,Childsub),"^",10)
	;预约限额
	s APPSeqNoCount=$P(^RBAS(ResRowId,Childsub),"^",2)
	
	i AppStartSeqNo="" s AppStartSeqNo=0
	i APPSeqNoCount="" s APPSeqNoCount=0
	i APPSeqNoCount=0 s AppStartSeqNo=0

	;无此排班记录
	Q:'$d(^RBAS(ResRowId,Childsub)) "-1"
	
	 s SingleQueueNo=0
	 s ASQueueNo=$P(^RBAS(ResRowId,Childsub,"DHC"),"^",4)
	 ;正号串与加号串
	 s NormalQueueNoStr=$P(ASQueueNo,$C(1),1)
	 s AddQueueNoStr=$P(ASQueueNo,$C(1),2)
	 Q:NormalQueueNoStr="" 0
	 
	//正常挂号取号(包括预约的)
	set Count=0
	i RegType="NOR" {
	 	for i=1:1:$l(NormalQueueNoStr,",") {
		 	s SingleQueueNoStr=$P(NormalQueueNoStr,",",i)
		 	s QueueNoStatus=$P(SingleQueueNoStr,":",2)
		 	s QueueNo=$P(SingleQueueNoStr,":",1)
		 	s SingleQueueNo=""
		 	;未取号和已退号的可用
		 	i ((QueueNoStatus'=0)&&(QueueNoStatus'=4)){
			 	s Count=Count+1
		 	}
	 	}
	}
	//预约取号
	i RegType="APP" {
	 	;没有设定预约号信息
	 	Q:(+APPSeqNoCount=0) 0
	 	for i=1:1:$l(NormalQueueNoStr,",") {
		 	s SingleQueueNoStr=$P(NormalQueueNoStr,",",i)
		 	s QueueNoStatus=$P(SingleQueueNoStr,":",2)
		 	s QueueNo=$P(SingleQueueNoStr,":",1)
		 	s SingleQueueNo=""
		 	;未取号和已退号的可用
		 	i ((QueueNoStatus'=0)&&(QueueNoStatus'=4)){
			 	;只取预约号段里的号
			 	s QueueNoInAppFlag=+##class(web.DHCRBApptScheduleAppQty).CheckQueueNoInApp(RBASId,QueueNo,$g(APPMethodRowId))
			 	i QueueNoInAppFlag=1 s Count=Count+1
		 	}
	 	}
	}
	//加号取号
	i RegType="ADD" {
		if AddQueueNoStr'="" {
		 	for i=1:1:$l(AddQueueNoStr,",") {
			 	s SingleQueueNoStr=$P(AddQueueNoStr,",",i)
			 	s QueueNoStatus=$P(SingleQueueNoStr,":",2)
			 	s QueueNo=$P(SingleQueueNoStr,":",1)
			 	;未取号和已退号的可用
			 	i ((QueueNoStatus'=0)&&(QueueNoStatus'=4)){
				 	s Count=Count+1
			 	}
		 	}
		}
	}
	Q Count
}

ClassMethod GetRegisterNum(RBASId As %String) As %String
{
	n (RBASId)
	s ResRowId=$P(RBASId,"||",1)
	s Childsub=$P(RBASId,"||",2)
	s RegedCount=0 ;挂号+取号
	s AppedCount=0 ;预约+取号
	s AppedArriveCount=0 ;取号
	s AppointCount=0 ;预约
	s RegfeeRowId=""
	for{
		s RegfeeRowId=$O(^User.DHCRegistrationFeeI("RBASDr",RBASId,RegfeeRowId))
		Q:RegfeeRowId=""
		s AdmRowid=$lg(^User.DHCRegistrationFeeD(RegfeeRowId),2)
		s AdmStatus=$p($G(^PAADM(AdmRowid)),"^",20)
		continue:AdmStatus'="A"
		s SeqNo=$lg(^User.DHCRegistrationFeeD(RegfeeRowId),8)
		continue:(SeqNo["+")
		s RegedCount=RegedCount+1
	}
	s APPTChildSub=""
	for{
		s APPTChildSub=$o(^RBAS(ResRowId,Childsub,"APPT",APPTChildSub))
		Q:APPTChildSub=""
		s AppStatus=$p(^RBAS(ResRowId,Childsub,"APPT",APPTChildSub),"^",3)
		s AppSeqNo=$p(^RBAS(ResRowId,Childsub,"APPT",APPTChildSub),"^",5)
		continue:(AppSeqNo["+")
		if (AppStatus="I")!(AppStatus="A"){
			s AppedCount=AppedCount+1
		}
		if (AppStatus="I"){
			s AppointCount=AppointCount+1
		}
		if (AppStatus="A"){
			s AppedArriveCount=AppedArriveCount+1
		}
	}
	s ASQueueNo=$P(^RBAS(ResRowId,Childsub,"DHC"),"^",4)
	s JiaHao=##class(web.DHCApptScheduleNew).GetRegisterNumRule($p(ASQueueNo,$c(1),2))
	;加号已经挂号或取号数
	s JiaHaoRegedCount=$P(JiaHao,"^",1)
	;加号未取号数
	s JiaHaoUnArriveCount=$P(JiaHao,"^",4)

	s CountInfo=(RegedCount+JiaHaoRegedCount)_"^"_AppedCount_"^"_AppedArriveCount_"^"_(JiaHaoRegedCount+JiaHaoUnArriveCount)
	s CountInfo=CountInfo_"^"_RegedCount_"^"_AppointCount
	q CountInfo
}

/// 得到已用的
ClassMethod GetUsedSeqNoCount(RBASId As %String) As %String
{
	;w ##class(web.DHCRBApptSchedule).GetUsedSeqNoCount("372||6")
	s ^zhou("UsedSeqNoCount")=RBASId
	s RegedCount=0,AppedCount=0,AddedCount=0
	s ResRowId=$P(RBASId,"||",1)
	s Childsub=$P(RBASId,"||",2)

	s ASQueueNo=$P(^RBAS(ResRowId,Childsub,"DHC"),"^",4)
	
	s UsedSeqNoCountStr=##class(web.DHCRBResourceRule).GetRegisterNum(ASQueueNo,RBASId)
	s RegedCount=$p(UsedSeqNoCountStr,"^",1)
	s AppedCount=$p(UsedSeqNoCountStr,"^",2)
	s AddedCount=$p(UsedSeqNoCountStr,"^",4)
	s AppedArriveCount=$p(UsedSeqNoCountStr,"^",3)
 	Q RegedCount_"^"_AppedCount_"^"_AddedCount_"^"_AppedArriveCount
}

ClassMethod Insert(ResSessRowid As %String, Para As %String, UserID As %String = "", GroupID As %String = "", HospID = "") As %String
{
	;w ##class(web.DHCRBApptSchedule).Insert("2||1||1","61100^23400^43200^30^10^1^5^^1^1^1")
	n (ResSessRowid,Para,%session,UserID,GroupID,HospID)
	s ^tmplog("Insert")=$lb(ResSessRowid,Para,UserID,GroupID,HospID)
	Set $ZT="ERROR^DHCSSERR"
	TS
	s ResRowid=$P(ResSessRowid,"||",1)
	s ASDate=$P(Para,"^",1)
	s ASSessStartTime=$P(Para,"^",2)
	s ASSessEndTime=$P(Para,"^",3)
	s ASLoad=$P(Para,"^",4)
	s ASNoApptSession=$P(Para,"^",5)
	i ASNoApptSession="" s ASNoApptSession=0
	//i ASNoApptSession>99 s ASNoApptSession=99
	s ASAvailability=1
	s ASQueueNoCount=$P(Para,"^",6)
	s ASNoOverbookAllow=$P(Para,"^",7)

	s ASQueueNo=""
	/*
	for i=1:1:ASLoad d
	.i ASQueueNo="" s ASQueueNo=i_":"_0
	.e  s ASQueueNo=ASQueueNo_","_i_":"_0
	s AddQueueNo=""
	i ASNoOverbookAllow'="" {
		for i=1:1:ASNoOverbookAllow d
		.i AddQueueNo="" s AddQueueNo="+"_i_":"_0
		.e  s AddQueueNo=AddQueueNo_",+"_i_":"_0
	}
	s ASQueueNo=ASQueueNo_$C(1)_AddQueueNo*/
	
	s ASRoomDR=$P(Para,"^",8)
	s ASSessionTypeDR=$P(Para,"^",9)
	s ASClinicGroupDR=$P(Para,"^",10)
	s ASTimeRangeDR=$P(Para,"^",11)
	s ASNoLimitLoadFlag=$P(Para,"^",12)
	s ASTRNodeStart=13
    s ASTRFlag=$P(Para,"^",ASTRNodeStart)
	i ASTRFlag="Y" {
		s ASTRStartTime=$P(Para,"^",$I(ASTRNodeStart))
		i ASTRStartTime'="" s ASTRStartTime=..%ZTH(ASTRStartTime,3)
		s ASTREndTime=$P(Para,"^",$I(ASTRNodeStart))
		i ASTREndTime'="" s ASTREndTime=..%ZTH(ASTREndTime,3)
		s ASTRLength=$P(Para,"^",$I(ASTRNodeStart))
		s ASTRRegNum=$P(Para,"^",$I(ASTRNodeStart))
		s ASTRRegNumStr=$P(Para,"^",$I(ASTRNodeStart))
		s ASTRRegInfoStr=$P(Para,"^",$I(ASTRNodeStart))
	} else {
		s ASTRFlag=""
		s ASTRStartTime=""
		s ASTREndTime=""
		s ASTRLength=""
		s ASTRRegNum=""
		s ASTRRegNumStr=""
		s ASTRRegInfoStr=""		
	}
	s ASQueueNo=##class(web.DHCRBResourceRule).GenerateQueueNO(ASLoad,ASNoOverbookAllow,ASNoLimitLoadFlag)
	
	s ASDateCreate=..%SysDate()
	s ASTimeCreate=..%SysTime()
	&SQL(Select ASS_Rowid into :ASStatusDR from SQLUser.DHC_RBCASStatus Where ASS_Code='N')
	Set object = ##class(User.RBApptSchedule).%New(ResRowid)
	Do object.ASRESParRefSetObjectId(ResRowid)
	s object.ASDate=ASDate
	s object.ASSessStartTime=ASSessStartTime
	s object.ASSessEndTime=ASSessEndTime
	;预约限额
	;i ASNoApptSession=0 s ASNoApptSession=1
	s object.ASNoApptSession=ASNoApptSession
	s object.ASLoad=ASLoad
	s object.ASAvailability=ASAvailability
	s object.ASQueueNoCount=ASQueueNoCount
	Do object.ASRBEffDateSessionDRSetObjectId(ResSessRowid)
	s object.ASNumPatIn=0
	s object.ASNumPatOut=0
	s object.ASSession=0
	s object.ASLastUpdateDate=ASDateCreate
	s object.ASLastUpdateTime=ASTimeCreate
	S sc = object.%Save()
	If $$$ISERR(sc) {
		Do $System.Status.DisplayError()
		Trollback
		Quit 100
	}
	d object.%Close()
	;b ;update User.DHCRBApptSchedule
	Set ASChildsub=object.ASChildSub
	Set ASRowid=object.%Id()
	Set object = ##class(User.DHCRBApptSchedule).%OpenId(ASRowid)
	Do object.ASRESParRefSetObjectId(ResRowid)
	s object.ASChildsub=ASChildsub
	s object.ASNoOverbookAllowed=ASNoOverbookAllow
	s object.ASQueueNo=ASQueueNo

	Do object.ASRoomDRSetObjectId(ASRoomDR)
	Do object.ASSessionTypeDRSetObjectId(ASSessionTypeDR)
	if +ASClinicGroupDR>0{
		Do object.ASClinicGroupDRSetObjectId(+ASClinicGroupDR)
	}
	s object.ASClinicGroupDRStr=ASClinicGroupDR
	s object.ASDateCreate=ASDateCreate
	s object.ASDateCreate=ASDateCreate
	s object.ASTimeCreate=ASTimeCreate
	;排班待审核标记
	s ASAuditFlag=""
	s InStatusCode="N"
	if (+(##class(web.DHCRBApptScheduleAudi).GetRBASRequestFlag("NS",ResRowid,GroupID,HospID))=1){
		s ASAuditFlag="Y"
		s InStatusCode="AUD" ;待审核
	}
	s object.ASAuditFlag=ASAuditFlag
	&SQL(Select ASS_Rowid into :ASStatusDR from SQLUser.DHC_RBCASStatus Where ASS_Code=:InStatusCode)
	Do object.ASStatusDRSetObjectId(ASStatusDR)
	s object.ASDate=ASDate
	//分时段就诊
	s object.ASTimeRangeFlag=ASTRFlag
	s object.ASTRStartTime=ASTRStartTime
	s object.ASTREndTime=ASTREndTime
	s object.ASTRLength=ASTRLength
	s object.ASTRRegNum=ASTRRegNum
	s object.ASTRRegNumStr=ASTRRegNumStr
	s object.ASTRRegInfoStr=ASTRRegInfoStr
	if ASTimeRangeDR'="" d object.ASTimeRangeDRSetObjectId(ASTimeRangeDR)
	s object.ASNoLimitLoadFlag=ASNoLimitLoadFlag
	;b ;save
	Set sc = object.%Save()
	If $$$ISERR(sc) {
		Do $System.Status.DisplayError()
		Trollback
		Quit 100
	}
	if ASAuditFlag="Y"{
		s InfoStr="NS"_"^"_""_"^"_"^"_"^"_"^"
		s ret=..RBASRequest(ASRowid,InfoStr,UserID)
		if ret'="0"{
			Trollback
			Quit 101	
		}	
	}
	;状态改变日志
	s ret=##class(web.DHCRBApptSchedule).AddRBApptScheduleStatusLog(ASRowid,"N")
	If ret'=0 {
		Trollback
		Quit 100
	}
	;医生站业务数据修改日志
	set NewDataJson=##class(web.DHCDocDataChangeLog).GetLogJsonData("User.RBApptSchedule"_$c(2)_ASRowid_"^"_"User.DHCRBApptSchedule"_$c(2)_ASRowid)
	set ret=##class(web.DHCDocDataChangeLog).SaveLog("RB_ApptSchedule#DHC_RBApptSchedule","User.RBApptSchedule#User.DHCRBApptSchedule","排班信息","User.RBApptSchedule#User.DHCRBApptSchedule_"_ASRowid,$p($g(^RB("RES",+ASRowid)),"^",17),"A",NewDataJson,"")
	If ret'=0 {
		Trollback
		Quit 100
	}
	//调用平台组接口
	s rtn=##class(web.DHCENS.EnsHISService).DHCHisInterface("S00000003",ASRowid)
	;b ;insert User.DHCRBApptScheduleAppQty
	/*s err=0
	s DateChild=$P(ResSessRowid,"||",2)
	s SessChild=$P(ResSessRowid,"||",3)
	s AQChild=0  f  s AQChild=$O(^RB("RES",ResRowid,"Date",DateChild,"SESS",SessChild,"AQ",AQChild)) q:(AQChild="")!(err=100)  d
	.s APPData=^RB("RES",ResRowid,"Date",DateChild,"SESS",SessChild,"AQ",AQChild)
	.s MethodDR=$P(APPData,"^",1)
 .s Qty=$P(APPData,"^",2)
 .s Para=ASRowid_"^"_APPData
 .s err=..InsertAppQty(Para)
 .Q:err=100
	Q:(err=100) 100*/
	s GetTempAppStr=..GetTempAppMethod(ResSessRowid)
	s ret=##class(DHCDoc.OPAdm.Schedule).UpdateAppMethodQtyNew(ASRowid,GetTempAppStr,"")
	If ret'=0 {
		Trollback
		Quit 100
	}
	s SessTempList=..GetTempTRInfoNew(ResSessRowid)
	b ;093323
	s ret=##class(DHCDoc.OPAdm.Schedule).UpdateTRInfoNew(ASRowid,SessTempList)
	If ret'=0 {
		Trollback
		Quit 100
	}
	s ret=##class(DHCDoc.OPAdm.ScheduleTemplateConfig).CreatTempExtendConfig(ResSessRowid,ASRowid)
	If ret'=0 {
		Trollback
		Quit 100
	}
	Tc
	Q 0
}

ClassMethod GetTempTRInfoNew(SessRowid) As %DynamicArray
{
	s AMArr=[]
	s ResRowid=+SessRowid,DateSub=$P(SessRowid,"||",2),SessSub=$P(SessRowid,"||",3)
	s TRSub=0 f  s TRSub=$O(^RB("RES",ResRowid,"DATE",DateSub,"SESS",SessSub,"TR",TRSub)) Q:TRSub=""  d
	.s str=^RB("RES",ResRowid,"DATE",DateSub,"SESS",SessSub,"TR",TRSub)
	.s TRObj={}
	.s TRObj.ASTRRowid=""
	.s TRObj.SttTime=##class(websys.Conversions).TimeLogicalToHtml($P(str,"^",1))
	.s TRObj.EndTime=##class(websys.Conversions).TimeLogicalToHtml($P(str,"^",2))
	.s TRObj.Load=$P(str,"^",3)
	.s TRObj.tabTRAppMethodInfo=[]
	.s TRAMSub=0 f  s TRAMSub=$O(^RB("RES",ResRowid,"DATE",DateSub,"SESS",SessSub,"TR",TRSub,"TRAM",TRAMSub)) Q:TRAMSub=""  d
	..s str=^RB("RES",ResRowid,"DATE",DateSub,"SESS",SessSub,"TR",TRSub,"TRAM",TRAMSub)
	..s AMObj={}
	..s AMObj.TRAMRowid=""
	..s AMObj.AppMethodID=$P(str,"^",1)
	..s AMObj.AppMethod=$P(^RBC("APTM",AMObj.AppMethodID),"^",2)
	..s AMObj.MaxQty=$P(str,"^",2)
	..s AMObj.ReserveQty=$P(str,"^",3)
	..d TRObj.tabTRAppMethodInfo.%Push(AMObj)
	.s TRObj.tabTRClinicGroupInfo=[]
	.s TRAMSub=0 f  s TRAMSub=$O(^RB("RES",ResRowid,"DATE",DateSub,"SESS",SessSub,"TR",TRSub,"TRCG",TRAMSub)) Q:TRAMSub=""  d
	..s str=^RB("RES",ResRowid,"DATE",DateSub,"SESS",SessSub,"TR",TRSub,"TRCG",TRAMSub)
	..s AMObj={}
	..s AMObj.TRClinicGroupRowid=""
	..s AMObj.ClinicGroupMethodID=$P(str,"^",1)
	..s AMObj.ClinicGroup=$P(^RBC("CLGRP",AMObj.ClinicGroupMethodID),"^",2)
	..s AMObj.Qty=$P(str,"^",2)
	..d TRObj.tabTRClinicGroupInfo.%Push(AMObj)
	.d AMArr.%Push(TRObj)
	Q AMArr.%ToJSON()
}

ClassMethod GetTempAppMethod(SessRowid) As %String
{
	s AMArr=[]
	s ResRowid=+SessRowid,DateSub=$P(SessRowid,"||",2),SessSub=$P(SessRowid,"||",3)
	s AQSub=0 f  s AQSub=$O(^RB("RES",ResRowid,"Date",DateSub,"SESS",SessSub,"AQ",AQSub)) Q:AQSub=""  d
	.s obj={}
	.s obj.ASAMRowid=""
	.s obj.AppMethodID=$P(^RB("RES",ResRowid,"Date",DateSub,"SESS",SessSub,"AQ",AQSub),"^",1)
	.s obj.AppMethod=$P($G(^RBC("APTM",+obj.AppMethodID)),"^",2)
	.s obj.MaxQty=$P(^RB("RES",ResRowid,"Date",DateSub,"SESS",SessSub,"AQ",AQSub),"^",4)
	.s obj.ReserveQty=$P(^RB("RES",ResRowid,"Date",DateSub,"SESS",SessSub,"AQ",AQSub),"^",2)
	.s obj.StartNo=$P(^RB("RES",ResRowid,"Date",DateSub,"SESS",SessSub,"AQ",AQSub),"^",3)
	.d AMArr.%Push(obj)
	Q AMArr.%ToJSON()
}

ClassMethod GetASAppMethod(ASRowID) As %String
{
	s AMArr=[]
	s ResRowid=+ASRowID,DateSub=$P(ASRowID,"||",2)
	s AQSub=0 f  s AQSub=$O(^RBAS(ResRowid,DateSub,"AQ",AQSub)) Q:AQSub=""  d
	.s obj={}
	.s obj.ASAMRowid=""
	.s obj.AppMethodID=$P(^RBAS(ResRowid,DateSub,"AQ",AQSub),"^",1)
	.s obj.AppMethod=$P($G(^RBC("APTM",+obj.AppMethodID)),"^",2)
	.s obj.MaxQty=$P(^RBAS(ResRowid,DateSub,"AQ",AQSub),"^",7)
	.s obj.ReserveQty=$P(^RBAS(ResRowid,DateSub,"AQ",AQSub),"^",2)
	.s obj.StartNo=$P(^RBAS(ResRowid,DateSub,"AQ",AQSub),"^",3)
	.d AMArr.%Push(obj)
	Q AMArr.%ToJSON()
}

ClassMethod GetASTRInfoNew(ASRowID) As %DynamicArray
{
	s AMArr=[]
	s ResRowid=+ASRowID,DateSub=$P(ASRowID,"||",2)
	s TRSub=0 f  s TRSub=$O(^RBAS(ResRowid,DateSub,"ASTR",TRSub)) Q:TRSub=""  d
	.s str=^RBAS(ResRowid,DateSub,"ASTR",TRSub)
	.s TRObj={}
	.s TRObj.ASTRRowid=""
	.s TRObj.SttTime=##class(websys.Conversions).TimeLogicalToHtml($P(str,"^",1))
	.s TRObj.EndTime=##class(websys.Conversions).TimeLogicalToHtml($P(str,"^",2))
	.s TRObj.Load=$P(str,"^",3)
	.s TRObj.tabTRAppMethodInfo=[]
	.s TRObj.tabTRClinicGroupInfo=[]
	.s TRAMSub=0 f  s TRAMSub=$O(^RBAS(ResRowid,DateSub,"ASTR",TRSub,"TRAM",TRAMSub)) Q:TRAMSub=""  d
	..s str=^RBAS(ResRowid,DateSub,"ASTR",TRSub,"TRAM",TRAMSub)
	..s AMObj={}
	..s AMObj.TRAMRowid=""
	..s AMObj.AppMethodID=$P(str,"^",1)
	..s AMObj.AppMethod=$P(^RBC("APTM",AMObj.AppMethodID),"^",2)
	..s AMObj.MaxQty=$P(str,"^",2)
	..s AMObj.ReserveQty=$P(str,"^",3)
	..d TRObj.tabTRAppMethodInfo.%Push(AMObj)
	.s TRCGSub=0 f  s TRCGSub=$O(^RBAS(ResRowid,DateSub,"ASTR",TRSub,"TRCG",TRCGSub)) Q:TRCGSub=""  d
	..s str=^RBAS(ResRowid,DateSub,"ASTR",TRSub,"TRCG",TRCGSub)
	..s AMObj={}
	..s AMObj.TRClinicGroupRowid=""
	..s AMObj.ClinicGroupMethodID=$P(str,"^",1)
	..s AMObj.ClinicGroup=$P(^RBC("CLGRP",AMObj.ClinicGroupMethodID),"^",2)
	..s AMObj.Qty=$P(str,"^",2)
	..d TRObj.tabTRClinicGroupInfo.%Push(AMObj)
	.d AMArr.%Push(TRObj)
	Q AMArr.%ToJSON()
}

ClassMethod InsertAppQty(Para As %String) As %String
{
	;w ##class(web.DHCRBApptSchedule).InsertAppQty("2||28^2^1^1")
	Ts
	s ASRowid=$P(Para,"^",1)
	s MethodDR=$P(Para,"^",2)
	s Qty=$P(Para,"^",3)
	s StartNum=$P(Para,"^",4)
	b
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

/// 新增一条排班记录
ClassMethod InsertOneSchedule(SecheduleDate As %String, DoctorID As %String, LocationID As %String, TRRowId As %String, TotalNum As %String, BookNum As %String, OverBookNum As %String, RoomID As %String, SessionTypeID As %String, ClinicGroupID As %String, BookStartNum As %String, SessStartTime As %String = "", SessEndTime As %String = "", StatusCode As %String = "N", TimeRangeInfoStr As %String = "", ASIrregularFlag As %String = "", StopRegNoFlag As %String = "", GroupRowID As %String = "", ExpStr As %String = "")
{
	s ^zhou("InsertOneSchedule")=SecheduleDate_","_DoctorID_","_LocationID_","_TRRowId_","_TotalNum_","_BookNum_","_OverBookNum_","_RoomID_","_SessionTypeID_","_ClinicGroupID_","_BookStartNum_","_SessStartTime_","_SessEndTime_","_StatusCode_","_TimeRangeInfoStr
	;w ##class(web.DHCRBApptSchedule).InsertOneSchedule("2019-02-28^2019-03-01",480,1,1,50,"","","",1,"",0,"08:30:00","12:00:00","A","N^^^^^^")
	;w ##class(web.DHCRBApptSchedule).InsertOneSchedule("20/04/2012","1428","260","1","110","1","","188","1","","","06:30:00","13:00:00","AR","N^^^^^^")
	set ResRowID=""
	set ResRowID=$Order(^RB("RES",0,"CTPCP",DoctorID,LocationID,ResRowID))
	if (ResRowID=""){
		Trollback
		Quit 300
	}
	if BookNum="" s BookNum=0
	//i SecheduleDate'="" s ScheduleDate=..%ZDH(SecheduleDate)
	s NoLimitLoadFlag=""
	if ExpStr'=""{
		s NoLimitLoadFlag=$p(ExpStr,"^",1)	
	}
	if SessStartTime'=""  s SessStartTime=..%ZTH(SessStartTime)
	else  s SessStartTime=$P(^DHCTimeRange(TRRowId),"^",3)
	if SessEndTime'=""  s SessEndTime=..%ZTH(SessEndTime)
	else  s SessEndTime=$P(^DHCTimeRange(TRRowId),"^",4)
    s DHCRBTRRowId=TRRowId   //因为在CheckSchedule中将它赋空了
    s RepeatScheMsg=""
    for m=1:1:$l(SecheduleDate,"^"){
	    set oneScheduleDate=$p(SecheduleDate,"^",m)
	    continue:oneScheduleDate=""
	    s oneScheduleDate=..%ZDH(oneScheduleDate)
		set ret=##class(web.DHCRBResourceRule).CheckSchedule(ResRowID,oneScheduleDate,RoomID, SessStartTime,"")
		if ret'=0 {
			s retcode=$P(ret,"^",1)
			s DulASRowId=$P(ret,"^",2)
			if (DulASRowId'=""){
				s DulResRowId=$P(DulASRowId,"||",1)
				s DulResDocRowId=$p(^RB("RES",DulResRowId),"^",2)
				s DulResLocRowId=$p(^RB("RES",DulResRowId),"^",1)
				s DulResDocDesc=$p(^CTPCP(DulResDocRowId,1),"^",2)
				s DulResLocDesc=$p($g(^CTLOC(DulResLocRowId)),"^",2)
			}
			//Quit retcode_"^"_DulResLocDesc_DulResDocDesc
			s Msg=retcode_"^"_DulResLocDesc_DulResDocDesc
			i RepeatScheMsg="" s RepeatScheMsg=Msg
			else  s RepeatScheMsg=RepeatScheMsg_" "_Msg
		}
	}
	Q:RepeatScheMsg'="" RepeatScheMsg
	s CreateUser=%session.Get("LOGON.USERID")
	s ErrCode=0,ASRowidStr="",ASAuditFlagStr=""
	for q=1:1:$l(SecheduleDate,"^"){
		TStart
	    set oneScheduleDate=$p(SecheduleDate,"^",q)
	    continue:oneScheduleDate=""
	    s oneScheduleDate=..%ZDH(oneScheduleDate)
	    Set object = ##class(User.RBApptSchedule).%New(ResRowID)
		Do object.ASRESParRefSetObjectId(ResRowID)
		set object.ASDate=oneScheduleDate
		set object.ASSessStartTime=SessStartTime
		set object.ASSessEndTime=SessEndTime
		;不规则出诊记录标志
		set:ASIrregularFlag'="" object.ASIrregularFlag="A"  
		;预约限额
		set object.ASNoApptSession=BookNum
		set object.ASLoad=TotalNum
		set object.ASAvailability=1
		set object.ASQueueNoCount=BookStartNum
		set object.ASLastUpdateDate=..%SysDate()
		set object.ASLastUpdateTime=..%SysTime()
		//判断替诊医生当天是否有排班记录
		/*
		set scheduleRowID=""
		set scheduleRowID=$Order(^RBAS(ResRowID,0,"DateSTime",object.ASDate,SessStartTime,scheduleRowID))
		if (scheduleRowID'="")
		{
			Trollback
			Quit 200
		}
		*/
		//Do object.ASRBEffDateSessionDRSetObjectId(ResSessRowid)
		set object.ASNumPatIn=0
		set object.ASNumPatOut=0
		set object.ASSession=0
		
		Set sc = object.%Save()
		If $$$ISERR(sc) {
			b  ;001
			Do $System.Status.DisplayError()
			Trollback
			s ErrCode=100
			Quit
		}
		Set ASChildsub=object.ASChildSub
		Set ASRowid=object.%Id()
		do object.%Close()
		
		Set object = ##class(User.DHCRBApptSchedule).%OpenId(ASRowid)
		do object.ASRESParRefSetObjectId(ResRowID)
		set object.ASChildsub=ASChildsub
		set object.ASNoOverbookAllowed=OverBookNum
		set object.ASQueueNo=##class(web.DHCRBResourceRule).GenerateQueueNO(TotalNum,OverBookNum,NoLimitLoadFlag)
		Do object.ASRoomDRSetObjectId(RoomID)
		Do object.ASSessionTypeDRSetObjectId(SessionTypeID)
		if (+ClinicGroupID>0){
			Do object.ASClinicGroupDRSetObjectId(+ClinicGroupID)
		}
		set object.ASClinicGroupDRStr=ClinicGroupID
	    Do object.ASTimeRangeDRSetObjectId(DHCRBTRRowId)
		set object.ASDateCreate=$Piece($h,",",1)
		set object.ASTimeCreate=$Piece($h,",",2)
		Do object.ASUserAuthoriseDRSetObjectId(CreateUser)
		set object.ASDate=oneScheduleDate
		set object.ASStopRegNoFlag=StopRegNoFlag
		set object.ASNoLimitLoadFlag=NoLimitLoadFlag
		&SQL(Select ASS_Rowid into :ASStatusDR from SQLUser.DHC_RBCASStatus Where ASS_Code=:StatusCode)
		Do object.ASStatusDRSetObjectId(ASStatusDR)
		;排班待审核标记
		s ASAuditFlag=""
		if (+(##class(web.DHCRBApptScheduleAudi).GetRBASRequestFlag("N",ResRowID,GroupRowID))=1){
			s ASAuditFlag="Y"
			s StatusCode="AUD" ;待审核
		}
		s object.ASAuditFlag=ASAuditFlag
		&SQL(Select ASS_Rowid into :ASStatusDR from SQLUser.DHC_RBCASStatus Where ASS_Code=:StatusCode)
		Do object.ASStatusDRSetObjectId(ASStatusDR)
		//分时段就诊
		s ASTRFlag=$P(TimeRangeInfoStr,"^",1)
		s ASTRStartTime=$P(TimeRangeInfoStr,"^",2)
		i ASTRStartTime'="" s ASTRStartTime=..%ZTH(ASTRStartTime,3)
		s ASTREndTime=$P(TimeRangeInfoStr,"^",3)
		i ASTREndTime'="" s ASTREndTime=..%ZTH(ASTREndTime,3)
		s ASTRLength=$P(TimeRangeInfoStr,"^",4)
		s ASTRRegNum=$P(TimeRangeInfoStr,"^",5)
		s ASTRRegNumStr=$P(TimeRangeInfoStr,"^",6)
		s ASTRRegInfoStr=$P(TimeRangeInfoStr,"^",7)
		if TimeRangeInfoStr'="" d
		.s object.ASTimeRangeFlag=ASTRFlag
		.s object.ASTRStartTime=ASTRStartTime
		.s object.ASTREndTime=ASTREndTime
		.s object.ASTRLength=ASTRLength
		.s object.ASTRRegNum=ASTRRegNum
		.s object.ASTRRegNumStr=ASTRRegNumStr
		.s object.ASTRRegInfoStr=ASTRRegInfoStr
		
		Set sc = object.%Save()
		If $$$ISERR(sc) {
			b  ;002
			Do $System.Status.DisplayError()
			Trollback
			s ErrCode=100
			Quit
		}
		if NoLimitLoadFlag'="Y"{
			//新增限额子表数据
			set sc=##class(web.DHCRBApptScheduleAppQty).Insert(ASRowid)
			if (sc'="0"){
				b   ;003
				Trollback
				s ErrCode=100
				Quit
			}
		}
		;修改日志  guobaoping
		s ret=##class(web.DHCRBApptScheduleUpdateLog).AddRBApptScheduleLog("A",ASRowid,"")
		If ret'=0 {
			Trollback
			s ErrCode=100
			Quit
		}else{
			if ASAuditFlag="Y"{
				s InfoStr="N"_"^"_""_"^"_"^"_"^"_"^"
				s ret=..RBASRequest(ASRowid,InfoStr,CreateUser)
				if ret'="0"{
					Trollback
					s ErrCode=100
					Quit	
				}	
			}	
		}
		;状态改变日志
		s ret=##class(web.DHCRBApptSchedule).AddRBApptScheduleStatusLog(ASRowid,StatusCode)
		If ret'=0 {
			Trollback
			s ErrCode=100
			Quit
		}
		;医生站业务数据修改日志
		set NewDataJson=##class(web.DHCDocDataChangeLog).GetLogJsonData("User.RBApptSchedule"_$c(2)_ASRowid_"^"_"User.DHCRBApptSchedule"_$c(2)_ASRowid)
		set ret=##class(web.DHCDocDataChangeLog).SaveLog("RB_ApptSchedule#DHC_RBApptSchedule","User.RBApptSchedule#User.DHCRBApptSchedule","排班信息","User.RBApptSchedule#User.DHCRBApptSchedule_"_ASRowid,$p($g(^RB("RES",+ASRowid)),"^",17),"A",NewDataJson,"")
		If ret'=0 {
			Trollback
			s ErrCode=100
			Quit
		}
		Tcommit
		//同步排班信息
		d ##class(DHCExternalService.RegInterface.SynVisitSchedule).SynOneSchedule(ASRowid)
		//调用平台组接口
		s rtn=##class(web.DHCENS.EnsHISService).DHCHisInterface("S00000003",ASRowid)
		if ASRowidStr="" {
			s ASRowidStr=ASRowid
			s ASAuditFlagStr=ASAuditFlag
		}else{
			s ASRowidStr=ASRowidStr_$C(1)_ASRowid
			s ASAuditFlagStr=ASAuditFlagStr_$C(1)_ASAuditFlag
		}
	}
	if (ErrCode=0) {
		//自动插入实名制医生号别对照
		d ##class(DHCDoc.DHCDocConfig.CommonFunction).AutoInsertMarkDoc(ResRowID)
		//自动插入分诊区号别对照号别对照
		d ##class(DHCDoc.DHCDocConfig.CommonFunction).AutoInsertDepMark(ResRowID)
	}
	Q ErrCode_"^"_ASRowidStr_"^"_$g(ASAuditFlagStr)
}

/// 替诊
/// d ##class(web.DHCRBApptSchedule).ReplaceOneSchedule("492||34","86","140","1","3878","2")
ClassMethod ReplaceOneSchedule(ScheduleID As %String, ReplaceDoctorID As %String, ReplaceLocationID As %String, ReplaceReasonID As %String, AuditUserID As %String, ReplaceSessionTypeID, IsAudit As %String = "0", ERepRemark As %String = "") As %String
{
	s ^TMP("ReplaceOneSchedule")=ScheduleID_"^"_ReplaceDoctorID_"^"_ReplaceLocationID_"^"_ReplaceReasonID_"^"_AuditUserID_"^"_ReplaceSessionTypeID_"^"_IsAudit
	set ResRowID=""
	set ResRowID=$Order(^RB("RES",0,"CTPCP",ReplaceDoctorID,ReplaceLocationID,ResRowID))
	Q:ResRowID="" 300
	///如果替诊的医生当诊有排班,则不允许替诊
	s ScheduleTime=$P($G(^RBAS(+ScheduleID,$P(ScheduleID,"||",2))),"^",4)
	s ScheduleDate=$P($G(^RBAS(+ScheduleID,$P(ScheduleID,"||",2))),"^",1)
	s TimeRangeRowId=$P($G(^RBAS(+ScheduleID,$P(ScheduleID,"||",2),"DHC")),"^",17)
	//s AvailRA=..GetAvailRANew(ResRowID,ScheduleDate,"",TimeRangeRowId)
	//Q:AvailRA'="" 200
	s TRSessStartTime=$P($G(^DHCTimeRange(TimeRangeRowId)),"^",3)
	s AvailRA=##class(web.DHCRBResourceRule).CheckSchedule(ResRowID,ScheduleDate,"", TRSessStartTime,"")
	Q:AvailRA'=0 200
	/*
	if (##class(web.DHCDocHardCoded).GetRBASRequestFlag("R")=1)&&(IsAudit="0"){
		s InfoStr="R"_"^"_ReplaceReasonID_"^"_ReplaceDoctorID_"^"_ReplaceLocationID_"^"_ReplaceReasonID_"^"
		q ..RBASRequest(ScheduleID,InfoStr)
	}
	*/
	s OldDep=$p(^RB("RES",+ScheduleID),"^",1)
	s CopyClinicGroup="Y"
	if OldDep'=ReplaceLocationID {
		s CopyClinicGroup="N"	;非替诊本科室的，不复制专业组
	}
	if (+(##class(web.DHCRBApptScheduleAudi).GetRBASRequestFlag("R",ScheduleID))=1)&&(IsAudit="0"){
		s AuditStatus=##class(web.DHCRBApptScheduleAudi).CheckIsAuditStatus(ScheduleID)
		if AuditStatus'=""{
			q AuditStatus
		}
		s InfoStr="R"_"^"_ReplaceReasonID_"^"_ReplaceDoctorID_"^"_ReplaceLocationID_"^"_ReplaceSessionTypeID_"^"
		q ..RBASRequest(ScheduleID,InfoStr)
	}
	TStart
	set OldDataJsonTR = ##class(web.DHCDocDataChangeLog).GetLogJsonData("User.RBApptSchedule"_$c(2)_ScheduleID_"^"_"User.DHCRBApptSchedule"_$c(2)_ScheduleID)
	;
	//新增替诊医生排班记录
	//Trakcare排班记录表User.RBApptSchedule
	set Oldschedule=##class(User.RBApptSchedule).%OpenId(ScheduleID)
	set NewSchedule=##class(User.RBApptSchedule).%New(ResRowID)
	do NewSchedule.ASRESParRefSetObjectId(ResRowID)
	set ASDate=Oldschedule.ASDate
	set NewSchedule.ASDate=Oldschedule.ASDate
	set NewSchedule.ASSessStartTime=Oldschedule.ASSessStartTime
	set NewSchedule.ASSessEndTime=Oldschedule.ASSessEndTime
	set NewSchedule.ASLoad=Oldschedule.ASLoad
	set NewSchedule.ASAvailability=Oldschedule.ASAvailability
	set NewSchedule.ASQueueNoCount=Oldschedule.ASQueueNoCount
	;预约限额
	set NewSchedule.ASNoApptSession=Oldschedule.ASNoApptSession
	//set NewSchedule.ASRBEffDateSessionDR=Oldschedule.ASRBEffDateSessionDR
	set NewSchedule.ASNumPatIn=Oldschedule.ASNumPatIn
	set NewSchedule.ASNumPatOut=Oldschedule.ASNumPatOut
	set NewSchedule.ASSession=Oldschedule.ASSession
	Set sc = NewSchedule.%Save()
	If $$$ISERR(sc) {
		Do $System.Status.DisplayError()
		Trollback
		Quit 100
	}
	
	do Oldschedule.%Close()
	do NewSchedule.%Close()
	set NewScheduleID=NewSchedule.%Id()
	Set ChildSub=NewSchedule.ASChildSub
	//Dhc排班记录扩展表User.DHCRBApptSchedule
	set Oldschedule=##class(User.DHCRBApptSchedule).%OpenId(ScheduleID)
	set NewSchedule=##class(User.DHCRBApptSchedule).%OpenId(NewScheduleID)
	Do NewSchedule.ASRESParRefSetObjectId(ResRowID)
	set NewSchedule.ASChildsub=ChildSub
	set NewSchedule.ASDate=ASDate
	set NewSchedule.ASNoOverbookAllowed=Oldschedule.ASNoOverbookAllowed
	set NewSchedule.ASQueueNo=Oldschedule.ASQueueNo
	//判断新的科室是否有次诊室
	if (Oldschedule.ASRoomDR'=""){
		s LocArealoc=$p(^RB("RES",+NewScheduleID),"^",1)
		s ExaRowidStr=##class(web.DHCApptScheduleNew).GetExaRowidStrByLoc(LocArealoc)
		s LocAreaExamRowid=""
		s id=$o(^User.DHCBorExaRoomI("BordExaRoomDrIndex"," "_Oldschedule.ASRoomDR,""))
		i id'="" s LocAreaExamRowid=$list(^User.DHCBorExaRoomD(id),5)
		if (("^"_ExaRowidStr_"^")[("^"_LocAreaExamRowid_"^")) set NewSchedule.ASRoomDR=Oldschedule.ASRoomDR
	}
	do NewSchedule.ASSessionTypeDRSetObjectId(ReplaceSessionTypeID)
	if CopyClinicGroup="Y" {
		set NewSchedule.ASClinicGroupDR=Oldschedule.ASClinicGroupDR
		set NewSchedule.ASClinicGroupDRStr=Oldschedule.ASClinicGroupDRStr
	}
	//分时段就诊
	set NewSchedule.ASTimeRangeFlag=Oldschedule.ASTimeRangeFlag
	set NewSchedule.ASTRStartTime=Oldschedule.ASTRStartTime
	set NewSchedule.ASTREndTime=Oldschedule.ASTREndTime
	set NewSchedule.ASTRLength=Oldschedule.ASTRLength
	set NewSchedule.ASTRRegNum=Oldschedule.ASTRRegNum
	set NewSchedule.ASTRRegNumStr=Oldschedule.ASTRRegNumStr
	set NewSchedule.ASTRRegInfoStr=Oldschedule.ASTRRegInfoStr
	set NewSchedule.ASStopRegNoFlag=Oldschedule.ASStopRegNoFlag
	set NewSchedule.ASNoLimitLoadFlag=Oldschedule.ASNoLimitLoadFlag
	//set NewSchedule.ASStatusDR=Oldschedule.ASStatusDR
	&SQL(Select ASS_Rowid into :ASStatusDR from SQLUser.DHC_RBCASStatus Where ASS_Code='R')
	b ;ASStatusDR
	Do NewSchedule.ASStatusDRSetObjectId(ASStatusDR)
	Do NewSchedule.ASTimeRangeDRSetObjectId(TimeRangeRowId)
	set NewSchedule.ASDateCreate=$piece($h,",",1)
	set NewSchedule.ASTimeCreate=$piece($h,",",2)
	set NewSchedule.ASASDR=Oldschedule.%Id()
	Set sc = NewSchedule.%Save()
	If $$$ISERR(sc) {
		Do $System.Status.DisplayError()
		Trollback
		Quit 100
	}
	;状态改变日志
	s ret=##class(web.DHCRBApptSchedule).AddRBApptScheduleStatusLog(NewScheduleID,"R","",ERepRemark)
	If ret'=0 {
		Trollback
		Quit 100
	}
	 
	//更新被替诊医生排班记录
	&SQL(Select ASS_Rowid into :ASStatusDR from SQLUser.DHC_RBCASStatus Where ASS_Code='TR')
	Do Oldschedule.ASStatusDRSetObjectId(ASStatusDR)
	Do Oldschedule.ASUserAuthoriseDRSetObjectId(AuditUserID)
	Do Oldschedule.ASReasonNotAvailDRSetObjectId(ReplaceReasonID)
	set Oldschedule.ASASDR=NewSchedule.%Id() 

	Set sc = Oldschedule.%Save()
	If $$$ISERR(sc) {
		Do $System.Status.DisplayError()
		Trollback
		Quit 100
	}
	//更新排班记录扩展信息
	s ret=..SaveRBASExtendConfig(ScheduleID,NewScheduleID)
	If ret'=0 {
		Do $System.Status.DisplayError()
		Trollback
		Quit 100
	}
	;状态改变日志
	s ret=##class(web.DHCRBApptSchedule).AddRBApptScheduleStatusLog(ScheduleID,"TR","",ERepRemark)
	If ret'=0 {
		Trollback
		Quit 100
	}
	set Oldschedule=##class(User.RBApptSchedule).%OpenId(ScheduleID)
	set Oldschedule.ASLastUpdateDate=..%SysDate()
	set Oldschedule.ASLastUpdateTime=..%SysTime()
	Set sc = Oldschedule.%Save()
	If $$$ISERR(sc) {
		Do $System.Status.DisplayError()
		Trollback
		Quit 100
	}
	
	//复制被替诊医生的预约限额
	s err=0
	s AQChild=0  f  s AQChild=$O(^RBAS(+ScheduleID,$P(ScheduleID,"||",2),"AQ",AQChild))  q:(AQChild="")!(err=100)  d
	.s APPData=^RBAS(+ScheduleID,$P(ScheduleID,"||",2),"AQ",AQChild)
	.s MethodDR=$P(APPData,"^",1)
 	.s Qty=$P(APPData,"^",2)
 	.s AQStartNum=$P(APPData,"^",3)
 	.s ASQMaxQty=$P(APPData,"^",7)
	.s appQty=##class(User.DHCRBApptScheduleAppQty).%New(NewScheduleID)
	.d appQty.ASQASParRefSetObjectId(NewScheduleID)
	.d appQty.ASQMethodDRSetObjectId(MethodDR)
	.s appQty.ASQQty=Qty
	.s appQty.ASQStartNum=AQStartNum
	.s appQty.ASQMaxQty=ASQMaxQty
	.S sc = appQty.%Save()
	.I $$$ISERR(sc) s err=100
	 i err=100 {
	    Tro
		Q 101
	 }
	//复制分时段信息、分时段预约方式
	s err=0
	s ASTRChildSub=0 f  s ASTRChildSub=$O(^RBAS(+ScheduleID,$P(ScheduleID,"||",2),"ASTR",ASTRChildSub))  q:(ASTRChildSub="")!(err=100)  d
	.s APPTimeRangeData=$g(^RBAS(+ScheduleID,$P(ScheduleID,"||",2),"ASTR",ASTRChildSub))
	.s ASTRSttTime=$p(APPTimeRangeData,"^",1)
	.s ASTREndTime=$p(APPTimeRangeData,"^",2)
	.s ASTRLoad=$p(APPTimeRangeData,"^",3)
	.s ASTRQueueNo=$p(APPTimeRangeData,"^",4)
	.s ASTRObj=##class(User.RBApptScheduleTR).%New(NewScheduleID)
	.d ASTRObj.ASTRParRefSetObjectId(NewScheduleID)
	.s ASTRObj.ASTRSttTime=ASTRSttTime
	.s ASTRObj.ASTREndTime=ASTREndTime
	.s ASTRObj.ASTRLoad=ASTRLoad
	.s ASTRObj.ASTRQueueNo=ASTRQueueNo
	.s sc = ASTRObj.%Save()
	.I $$$ISERR(sc) s err=100
	.i err=0 d
	..do ASTRObj.%Close()
	..s ASTRRowId=ASTRObj.%Id()
	..s ASTRAMChildSub=0
	..f  s ASTRAMChildSub=$O(^RBAS(+ScheduleID,$P(ScheduleID,"||",2),"ASTR",ASTRChildSub,"TRAM",ASTRAMChildSub))  q:(ASTRAMChildSub="")!(err=100)  d
	...s APPTRAMData=$g(^RBAS(+ScheduleID,$P(ScheduleID,"||",2),"ASTR",ASTRChildSub,"TRAM",ASTRAMChildSub))
	...s ASTRAMMethodDR=$p(APPTRAMData,"^",1)
	...s ASTRAMMaxQty=$p(APPTRAMData,"^",2)
	...s ASTRAMReserveQty=$p(APPTRAMData,"^",3)
	...s ASTRAMObj=##class(User.RBApptScheduleTRAppMethod).%New(ASTRRowId)
	...d ASTRAMObj.ASTRAMParRefSetObjectId(ASTRRowId)
	...d ASTRAMObj.ASTRAMMethodDRSetObjectId(ASTRAMMethodDR)
	...s ASTRAMObj.ASTRAMMaxQty=ASTRAMMaxQty
	...s ASTRAMObj.ASTRAMReserveQty=ASTRAMReserveQty
	...s sc = ASTRAMObj.%Save()
	...I $$$ISERR(sc) s err=100
	...i err=0 do ASTRAMObj.%Close()
	..s ASTRCMChildSub=0
	..f  s ASTRCMChildSub=$O(^RBAS(+ScheduleID,$P(ScheduleID,"||",2),"ASTR",ASTRChildSub,"TRCG",ASTRCMChildSub))  q:(ASTRCMChildSub="")!(err=100)!(CopyClinicGroup'="Y")  d
	...s APPTRAMData=$g(^RBAS(+ScheduleID,$P(ScheduleID,"||",2),"ASTR",ASTRChildSub,"TRCG",ASTRCMChildSub))
	...s ClinicGroupMethodID=$p(APPTRAMData,"^",1)
	...s Qty=$p(APPTRAMData,"^",2)
	...s ASTRAMObj=##class(User.RBApptScheduleTRClinicGroup).%New(ASTRRowId)
	...d ASTRAMObj.ASTRCGParRefSetObjectId(ASTRRowId)
	...d ASTRAMObj.ASTRCGClinicGroupDRSetObjectId(ClinicGroupMethodID)
	...s ASTRAMObj.ASTRCGQty=Qty
	...s sc = ASTRAMObj.%Save()
	...I $$$ISERR(sc) s err=100
	...i err=0 do ASTRAMObj.%Close()
	i err=100 {
	    Tro
		Q 101
	}
	;医生站业务数据修改日志
	; 被替诊日志
	set NewDataJsonTR=##class(web.DHCDocDataChangeLog).GetLogJsonData("User.RBApptSchedule"_$c(2)_ScheduleID_"^"_"User.DHCRBApptSchedule"_$c(2)_ScheduleID)
	set ret=##class(web.DHCDocDataChangeLog).SaveLog("RB_ApptSchedule#DHC_RBApptSchedule","User.RBApptSchedule#User.DHCRBApptSchedule","排班信息","User.RBApptSchedule#User.DHCRBApptSchedule_"_ScheduleID,$p($g(^RB("RES",+ScheduleID)),"^",17),"U",NewDataJsonTR,OldDataJsonTR)
	If ret'=0 {
		Trollback
		Quit 100
	}
	; 替诊日志
	set NewDataJson=##class(web.DHCDocDataChangeLog).GetLogJsonData("User.RBApptSchedule"_$c(2)_NewScheduleID_"^"_"User.DHCRBApptSchedule"_$c(2)_NewScheduleID)
	set ret=##class(web.DHCDocDataChangeLog).SaveLog("RB_ApptSchedule#DHC_RBApptSchedule","User.RBApptSchedule#User.DHCRBApptSchedule","排班信息","User.RBApptSchedule#User.DHCRBApptSchedule_"_NewScheduleID,$p($g(^RB("RES",+NewScheduleID)),"^",17),"A",NewDataJson,"")
	If ret'=0 {
		Trollback
		Quit 100
	}
	 //复制被替诊医生的预约记录
	s APPTChild=0  f  s APPTChild=$O(^RBAS(+ScheduleID,$P(ScheduleID,"||",2),"APPT",APPTChild))  q:(APPTChild="")!(err=100)  d
	.s APPTRowid=+ScheduleID_"||"_$P(ScheduleID,"||",2)_"||"_APPTChild
	.s APPTStatus=""
	.S APPTobject =##class(User.RBAppointment).%OpenId(APPTRowid)
	.i $IsObject(APPTobject) {s APPTStatus=APPTobject.APPTStatus}
	.q:APPTStatus'="I"
	.d APPTobject.%Close()
	.K PLIST
	.&sql(select * into :PLIST() from SQLUser.RB_Appointment where APPT_RowId=:APPTRowid)
	.K PLIST(0),PLIST(1),PLIST(2)
	.s PLIST(0)=NewScheduleID
	.&sql(Insert into SQLUser.RB_Appointment VALUES :PLIST())
	.I SQLCODE s err=100
	.//scl 20160303
	.s NewAPPTRowid =$p(%ROWID,$c(1))
	.set Oldobject=##class(User.DHCRBAppointment).%OpenId(APPTRowid)
	.set AppPatCredNo=Oldobject.APPTCredNo
	.set AppPatTel=Oldobject.APPTMobilePhone
	.set AppPatName=Oldobject.APPTPatientName
	.set AppPatAddress=Oldobject.APPTPatientAddress
	.set AppPatType=Oldobject.APPTPatType
	.set AppCredTypeId=Oldobject.APPTCredTypeDR.%Id()
	.set Newobject=##class(User.DHCRBAppointment).%OpenId(NewAPPTRowid)
    .set Newobject.APPTCredNo=AppPatCredNo
	.set Newobject.APPTMobilePhone=AppPatTel
	.set Newobject.APPTPatientName=AppPatName
	.set Newobject.APPTPatientAddress=AppPatAddress
	.set Newobject.APPTPatType=AppPatType
	.do Newobject.APPTCredTypeDRSetObjectId(AppCredTypeId)
	.do Newobject.APPTRBAppointmentDRSetObjectId(APPTRowid)
	.Set sc = Newobject.%Save()
	.If ($$$ISERR(sc)) set err=100
	.do Oldobject.%Close()
	.do Newobject.%Close()
	.b //00
	.//end--
	 i err=100 {
	    Tro
		Q 101
	 }else{
		 /*&sql(delete from SQLUser.RB_Appointment where APPT_AS_ParRef=:ScheduleID)
		 i " 0 100 "'[(" "_SQLCODE_" ") {
			 Tro
			 Q 101
		 }*/
		 s APPTLastStatusChangeDate=..%SysDate()
		 s APPTLastStatusChangeTime=..%SysTime()
		 &sql(Update SQLUser.RB_Appointment Set APPT_Status="X",APPT_LastStatusChangeDate=:APPTLastStatusChangeDate,
		 APPT_LastStatusChangeTime=:APPTLastStatusChangeTime,APPT_LastStatusChangeUser_DR=:AuditUserID
		  Where APPT_AS_ParRef=:ScheduleID and APPT_Status="I" )
		  i " 0 100 "'[(" "_SQLCODE_" ") {
			 Tro
			 Q 101
		 }
	 }
	 
	;做停诊日志  guobaoping
	s ret=##class(web.DHCRBApptScheduleUpdateLog).AddRBApptScheduleLog("R",ScheduleID,NewScheduleID)
	If ret'=0 {
		Trollback
		Quit 100
	}
	//自动插入实名制医生号别对照
	d ##class(DHCDoc.DHCDocConfig.CommonFunction).AutoInsertMarkDoc(ResRowID)
	//自动插入分诊区号别对照号别对照
	d ##class(DHCDoc.DHCDocConfig.CommonFunction).AutoInsertDepMark(ResRowID)
	Tcommit
	d ##class(DHCExternalService.RegInterface.SynVisitSchedule).SynReplaceVisitSchedule(ScheduleID)
	//调用大屏接口
	//s CFIFScreenStart=##class(web.DHCOPRegConfig).GetSpecConfigNode("IFScreenStart")
	//if (CFIFScreenStart=1){
	//	set err=##class(dhcinterface.DoctorApptScheClient).ReplaceApptSche(ScheduleID,NewScheduleID)
	//}

	//调用114替诊接口
	//s CFIFTeleAppStart=##class(web.DHCOPRegConfig).GetSpecConfigNode("IFTeleAppStart")
	//if (CFIFTeleAppStart=1)&&(ASDate=..%SysDate()){
	//	set err=##class(dhcinterface.TeleClient).notifyChangeWork(ScheduleID,NewScheduleID)
	//	If err'=0 {
	//		Do $System.Status.DisplayError()
			;Trollback
			;Quit 100
	//	}
	//}
	;Tcommit
	;调用平台组接口
	s rtn=##class(web.DHCENS.EnsHISService).DHCHisInterface("CHANGEAPPTSCHEDULEINFO",ScheduleID)
	Quit 0
}

/// 停诊
ClassMethod StopOneSchedule(ScheduleID As %String, StopReasonID As %String, AuditUserID As %String, StatusCode As %String = "S", IsAudit As %String = "0", StopRemark As %String = "") As %String
{
	;s ^gry("StopOneSchedule")=ScheduleID_"^"_StopReasonID_"^"_AuditUserID
	
	/*
	if (##class(web.DHCDocHardCoded).GetRBASRequestFlag("S")=1)&&(StatusCode="S")&&(IsAudit="0"){
		s InfoStr=StatusCode_"^"_StopReasonID_"^"_"^"_"^"_"^"
		q ..RBASRequest(ScheduleID,InfoStr)

	
	}
	if (IsAudit="0"){
		s ret="0"
		s OldResult=""
		s ID=0
		f  s ID=$O(^User.DHCRBApptScheduleRequestI("RBASIDIndex",ScheduleID,ID)) q:(ID="")||(OldResult'="")  d
		.s obj=##class(User.DHCRBApptScheduleRequest).%OpenId(ID)
		.s Result=obj.ASRRequestResult
		.q:Result'="N"
		.s OldResult=obj.ASRRequestType
		s:OldResult="S" ret="已经申请停诊"
		s:OldResult="R" ret="已经申请替诊"
		q:ret'="0" ret
	}
	*/
	if (+(##class(web.DHCRBApptScheduleAudi).GetRBASRequestFlag("S",ScheduleID))=1)&&(IsAudit="0"){
		s AuditStatus=##class(web.DHCRBApptScheduleAudi).CheckIsAuditStatus(ScheduleID)
		if AuditStatus'=""{
			q AuditStatus
		}
		s InfoStr=StatusCode_"^"_StopReasonID_"^"_"^"_"^"_"^"
		Q ..RBASRequest(ScheduleID,InfoStr)
	}
	set OldDataJson=##class(web.DHCDocDataChangeLog).GetLogJsonData("User.RBApptSchedule"_$c(2)_ScheduleID_"^"_"User.DHCRBApptSchedule"_$c(2)_ScheduleID)
	TStart
	//set StatusCode=##class(web.DHCRBApptSchedule).GetRBApptScheduleStatus(ScheduleID)
	set schedule=##class(User.RBApptSchedule).%OpenId(ScheduleID)
	set schedule.ASLastUpdateDate=..%SysDate()
	set schedule.ASLastUpdateTime=..%SysTime()
	Set sc = schedule.%Save()
	If $$$ISERR(sc) {
		;Do $System.Status.DisplayError()
		Trollback
		Quit 100
	}
	set schedule=##class(User.DHCRBApptSchedule).%OpenId(ScheduleID)
	Do schedule.ASUserAuthoriseDRSetObjectId(AuditUserID)
	&SQL(Select ASS_Rowid into :ASStatusDR from SQLUser.DHC_RBCASStatus Where ASS_Code=:StatusCode)
	Do schedule.ASStatusDRSetObjectId(ASStatusDR)
	Do schedule.ASReasonNotAvailDRSetObjectId(StopReasonID)
	set ASDate=schedule.ASDate
	Set sc = schedule.%Save()
	If $$$ISERR(sc) {
		;Do $System.Status.DisplayError()
		Trollback
		Quit 100
	}
	;做停诊日志  guobaoping
	s ret=##class(web.DHCRBApptScheduleUpdateLog).AddRBApptScheduleLog("S",ScheduleID,"")
	If ret'=0 {
		Trollback
		Quit 100
	}
	;状态改变日志
	s ret=##class(web.DHCRBApptSchedule).AddRBApptScheduleStatusLog(ScheduleID,StatusCode,"",StopRemark)
	If ret'=0 {
		Trollback
		Quit 100
	}
	;医生站业务数据修改日志
	set NewDataJson=##class(web.DHCDocDataChangeLog).GetLogJsonData("User.RBApptSchedule"_$c(2)_ScheduleID_"^"_"User.DHCRBApptSchedule"_$c(2)_ScheduleID)
	set ret=##class(web.DHCDocDataChangeLog).SaveLog("RB_ApptSchedule#DHC_RBApptSchedule","User.RBApptSchedule#User.DHCRBApptSchedule","排班信息","User.RBApptSchedule#User.DHCRBApptSchedule_"_ScheduleID,$p($g(^RB("RES",+ScheduleID)),"^",17),"U",NewDataJson,OldDataJson)
	If ret'=0 {
		Trollback
		s ^tempscl("NewDataJson")=$lb(ret,"RB_ApptSchedule#DHC_RBApptSchedule","User.RBApptSchedule#User.DHCRBApptSchedule","排班信息","User.RBApptSchedule#User.DHCRBApptSchedule_"_ScheduleID,$p($g(^RB("RES",+ScheduleID)),"^",17),"U",NewDataJson,OldDataJson)
		Quit 100
	}
	Tcommit
	d ##class(DHCExternalService.RegInterface.SynVisitSchedule).SynStopVisitSchedule(ScheduleID)
	//大屏停诊接口
	
	//s CFIFScreenStart=##class(web.DHCOPRegConfig).GetSpecConfigNode("IFScreenStart")
	//if (CFIFScreenStart=1)&&(ASDate=..%SysDate()){
 	//d ##class(dhcinterface.DoctorApptScheClient).StopApptSche(ScheduleID)
		/*
		If err'=0 {
			Do $System.Status.DisplayError()
			;Quit 100
		}
		*/
 	//}	
	
	//调用114停诊接口
	//s CFIFTeleAppStart=##class(web.DHCOPRegConfig).GetSpecConfigNode("IFTeleAppStart")
	//if (CFIFTeleAppStart=1){
	//	set err=##class(dhcinterface.TeleClient).notifyStopWork(ScheduleID)
	//	If err'=0 {
			;Do $System.Status.DisplayError()
			;Trollback
			;Quit 100
	//	}
	//}
	;调用平台组接口
	s rtn=##class(web.DHCENS.EnsHISService).DHCHisInterface("STOPAPPTSCHEDULEINFO",ScheduleID)
	Quit 0
}

/// W ##class(web.DHCRBApptSchedule).Update("611||227","63152^46800^61200^800^20^^5^216^5^^2^N^^^^^^","611||1||6")
ClassMethod Update(ResAppScheduleRowId As %String, Para As %String, ResSessRowid As %String = "") As %String
{
	n (ResAppScheduleRowId,Para,ResSessRowid)
	Set $ZT="ERROR^DHCSSERR"
	TS
	set OldDataJson=##class(web.DHCDocDataChangeLog).GetLogJsonData("User.RBApptSchedule"_$c(2)_ResAppScheduleRowId_"^"_"User.DHCRBApptSchedule"_$c(2)_ResAppScheduleRowId)
	;s ResRowid=$P(ResAppScheduleRowId,"||",1)
	s ASDate=$P(Para,"^",1)
	s ASSessStartTime=$P(Para,"^",2)
	s ASSessEndTime=$P(Para,"^",3)
	s ASLoad=$P(Para,"^",4)
	s ASNoApptSession=+$P(Para,"^",5)		// 必须字段格式化处理
	s ASAvailability=1
	s ASQueueNoCount=$P(Para,"^",6)
	s ASNoOverbookAllow=$P(Para,"^",7)

    ;需增加正号数量,如果是诊间预约和诊间加号的不能算在内
    ;1.如果 限额已经使用数+剩余数>限额 则 缩减剩余数
    ;2.如果 限额已经使用数+剩余数<限额 则 增加剩余数
    s ResRowid=$p(ResAppScheduleRowId,"||",1)
    s childsub=$p(ResAppScheduleRowId,"||",2)
	s ASQueueNo=""
	Set IrregularFlag=$p($g(^RBAS(+ResRowid,childsub)),"^",13)
	/*
	if IrregularFlag="A"
	{
		;标准版默认没有数量等
		Set OldASQueueNoStr=$p(^RBAS(+ResRowid,childsub,"DHC"),"^",4)
		Set OldASQueueNoStr=$p(OldASQueueNoStr,$c(1),1)
		Set OldLen=$l(OldASQueueNoStr,",")
		s LimitUseedSum=0
		for i=1:1:OldLen {
			s OldASQueueNoItem=$p(OldASQueueNoStr,",",i)
			s QueueNo=$p(OldASQueueNoItem,":",1)
			s QueueNoStatus=$p(OldASQueueNoItem,":",2)
			continue:QueueNo=""
			;0 剩号,1 已挂号,3 已取号
			i " 0 1 3 "[(" "_QueueNoStatus_" ") s LimitUseedSum=LimitUseedSum+1
		}
		lock +^RBASLOCK(ResRowid,childsub):10
		i LimitUseedSum>ASLoad {
			;缩减循环
			s balance=(LimitUseedSum-ASLoad)
			for i=OldLen:-1:1 {
				s OldASQueueNoItem=$p(OldASQueueNoStr,",",i)
				s QueueNo=$p(OldASQueueNoItem,":",1)
				s QueueNoStatus=$p(OldASQueueNoItem,":",2)
				continue:QueueNo=""
				i (balance>0)&(" 0 "[(" "_QueueNoStatus_" ")) {
					s balance=balance-1
					continue
				}
				i ASQueueNo="" s ASQueueNo=OldASQueueNoItem
				e  s ASQueueNo=OldASQueueNoItem_","_ASQueueNo
			}
		}else{
			;增加循环
			 for addLoop=1:1:+(ASLoad-LimitUseedSum) {
				 s maxQueueNo=##class(web.DHCRBResourceRule).GetMaxQueueNO(OldASQueueNoStr)
			 	 s oneStr=(maxQueueNo+1)_":0"
			 	 s $P(OldASQueueNoStr,",",OldLen+1)=oneStr
			 	 s ASQueueNo=OldASQueueNoStr 
			 }
		}
		lock -^RBASLOCK(ResRowid,childsub):5
		
	}
	
	s AddQueueNo=""
	;此处不正确,已经使用的加号要考虑
	i ASNoOverbookAllow'="" {
		for i=1:1:ASNoOverbookAllow d
		.i AddQueueNo="" s AddQueueNo="+"_i_":"_0
		.e  s AddQueueNo=AddQueueNo_",+"_i_":"_0
	}
	*/
	s ASRoomDR=$P(Para,"^",8)
	s ASSessionTypeDR=$P(Para,"^",9)
	s ASClinicGroupDR=$P(Para,"^",10)
	s ASTimeRangeDR=$P(Para,"^",11)
	s ASNoLimitLoadFlag=$P(Para,"^",12)
	s ASTRNodeStart=13
    s ASTRFlag=$P(Para,"^",ASTRNodeStart)
	s ASTRStartTime=$P(Para,"^",$I(ASTRNodeStart))
	i ((ASTRStartTime'="")&&(ASTRStartTime[":")) s ASTRStartTime=..%ZTH(ASTRStartTime,3)
	s ASTREndTime=$P(Para,"^",$I(ASTRNodeStart))
	i ((ASTREndTime'="")&&(ASTREndTime[":")) s ASTREndTime=..%ZTH(ASTREndTime,3)
	s ASTRLength=$P(Para,"^",$I(ASTRNodeStart))
	s ASTRRegNum=$P(Para,"^",$I(ASTRNodeStart))
	s ASTRRegNumStr=$P(Para,"^",$I(ASTRNodeStart))
	s ASTRRegInfoStr=$P(Para,"^",$I(ASTRNodeStart))
	;有可能原来对应session已经不再有效,此时应记录最新的sessiondr
	s ASQueueNo=##class(web.DHCRBResourceRule).GenerateQueueNO(ASLoad,ASNoOverbookAllow,ASNoLimitLoadFlag)
	s ASDateCreate=..%SysDate()
	s ASTimeCreate=..%SysTime()
	
	Set object = ##class(User.RBApptSchedule).%OpenId(ResAppScheduleRowId)
	s object.ASDate=ASDate
	s object.ASSessStartTime=ASSessStartTime
	s object.ASSessEndTime=ASSessEndTime
	;预约限额
	s object.ASNoApptSession=ASNoApptSession
	s object.ASLoad=ASLoad
	s object.ASAvailability=ASAvailability
	s object.ASQueueNoCount=ASQueueNoCount
	Do:$g(ResSessRowid)'="" object.ASRBEffDateSessionDRSetObjectId(ResSessRowid)
	;s object.ASNumPatIn=0
	;s object.ASNumPatOut=0
	;s object.ASSession=0
	if IrregularFlag="A" Set object.ASIrregularFlag="S"
	Set sc = object.%Save()
	If $$$ISERR(sc) {
		b ; User.RBApptSchedule
		Do $System.Status.DisplayError(sc)
		Trollback
		Quit 100
	}
	d object.%Close()
	Set ASChildsub=object.ASChildSub
	Set ASRowid=object.%Id()
	Set object = ##class(User.DHCRBApptSchedule).%OpenId(ASRowid)
	s object.ASNoOverbookAllowed=ASNoOverbookAllow
	s object.ASQueueNo=ASQueueNo
	Do object.ASRoomDRSetObjectId(ASRoomDR)
	Do object.ASSessionTypeDRSetObjectId(ASSessionTypeDR)
	Do object.ASClinicGroupDRSetObjectId(ASClinicGroupDR)
	//s object.ASDateCreate=ASDateCreate
	//s object.ASTimeCreate=ASTimeCreate
	//分时段就诊
	s object.ASTimeRangeFlag=ASTRFlag
	s object.ASTRStartTime="" ;ASTRStartTime
	s object.ASTREndTime="" ;ASTREndTime
	s object.ASTRLength="" ;ASTRLength
	s object.ASTRRegNum="" ;ASTRRegNum
	s object.ASTRRegNumStr="" ;ASTRRegNumStr
	s object.ASTRRegInfoStr="" ;ASTRRegInfoStr
	//End
	Set sc = object.%Save()
	If $$$ISERR(sc) {
		b ;User.DHCRBApptSchedule
		Do $System.Status.DisplayError(sc)
		Trollback
		Quit 100
	}
	s GetTempAppStr=..GetTempAppMethod(ResSessRowid)
	s ret=##class(DHCDoc.OPAdm.Schedule).UpdateAppMethodQtyNew(ASRowid,GetTempAppStr,"")
	If ret'=0 {
		Trollback
		Quit 100
	}
	s SessTempList=..GetTempTRInfoNew(ResSessRowid)
	b ;093323
	s ret=##class(DHCDoc.OPAdm.Schedule).UpdateTRInfoNew(ASRowid,SessTempList)
	If ret'=0 {
		Trollback
		Quit 100
	}
	s ret=##class(DHCDoc.OPAdm.ScheduleTemplateConfig).CreatTempExtendConfig(ResSessRowid,ASRowid)
	If ret'=0 {
		Trollback
		Quit 100
	}
	Tc
	;b ;insert User.DHCRBApptScheduleAppQty
	s err=..UpdateAppQty(ASRowid)
	if (err=100) Trollback  Q 100
	;医生站业务数据修改日志
	set NewDataJson=##class(web.DHCDocDataChangeLog).GetLogJsonData("User.RBApptSchedule"_$c(2)_ASRowid_"^"_"User.DHCRBApptSchedule"_$c(2)_ASRowid)
	set ret=##class(web.DHCDocDataChangeLog).SaveLog("RB_ApptSchedule#DHC_RBApptSchedule","User.RBApptSchedule#User.DHCRBApptSchedule","排班信息","User.RBApptSchedule#User.DHCRBApptSchedule_"_ASRowid,$p($g(^RB("RES",+ASRowid)),"^",17),"U",NewDataJson,OldDataJson)
	If ret'=0 {
		Trollback
		Quit 100
	}
	Tc
	Q 0
}

ClassMethod UpdateAppQty(ASRowId As %String) As %String
{
	Ts
	Tc
	Q 0
}

/// 更新挂号限额数据
ClassMethod UpdateApptScheduleAppQty(ScheduleID As %String, AppString As %String) As %String
{
	Quit ##class(web.DHCRBApptScheduleAppQty).Update(ScheduleID,AppString)
}

/// 修改一条排班记录
ClassMethod UpdateOneSchedule(ScheduleID As %String, Roomid As %String, TotalNum As %String, OverBookNum As %String, BookNum As %String, BookStartNum As %String = 0, ClinicGroupDR As %String, SessionTypeDR As %String, LockFlag As %String = "", SessStartTime As %String = "", SessEndTime As %String = "", TimeRangeInfoStr As %String = "", StopRegNoFlag As %String = "", ExpStr As %String = "") As %String
{
	s ^tmplog("UpdateOneSchedule")=$lb(ScheduleID,Roomid,TotalNum,OverBookNum,BookNum,BookStartNum,ClinicGroupDR,SessionTypeDR, LockFlag, SessStartTime, SessEndTime, TimeRangeInfoStr, StopRegNoFlag, ExpStr)
	;w ##class(web.DHCRBApptSchedule).UpdateOneSchedule("3146||240","427","","","","0","","4","N","08:30:00","11:30:00","N^^^^^^","","Y")
	set OldDataJson=##class(web.DHCDocDataChangeLog).GetLogJsonData("User.RBApptSchedule"_$c(2)_ScheduleID_"^"_"User.DHCRBApptSchedule"_$c(2)_ScheduleID)
	set OldRoomID=$p($G(^RBAS(+ScheduleID,$P(ScheduleID,"||",2),"DHC")),"^",5)
	set ResRowId=+ScheduleID
	set schedule=##class(User.RBApptSchedule).%OpenId(ScheduleID)
	set oldTotalNum=schedule.ASLoad
	set ScheduleDate=schedule.ASDate
	set OldASIrregularFlag=schedule.ASIrregularFlag
	set CurAddNum=(+TotalNum)-(+oldTotalNum)
	;set AddRegNum=schedule.ASAddRegNum
	;set SessStartTime=schedule.ASSessStartTime
	do schedule.%Close()
	//界面时段开始时间、结束时间取值
	s TimeRangeRowId=$P($G(^RBAS(+ScheduleID,$P(ScheduleID,"||",2),"DHC")),"^",17)
	s StartTime="",EndTime=""
	i TimeRangeRowId'="" d 
	.s StartTime=$p($G(^DHCTimeRange(TimeRangeRowId)),"^",3)
	.s EndTime=$p($G(^DHCTimeRange(TimeRangeRowId)),"^",4)
	if SessStartTime'=""  s SessStartTime=..%ZTH(SessStartTime)
	else  s SessStartTime=StartTime
	if SessEndTime'=""  s SessEndTime=..%ZTH(SessEndTime)
	else  s SessEndTime=EndTime
	//格式转换处理
	s BookNum=+BookNum
	i OverBookNum'="" s OverBookNum=+OverBookNum
	s NoLimitLoadFlag=""
	if ExpStr'=""{
		s NoLimitLoadFlag=$p(ExpStr,"^",1)	
	}
	//
	;正号最大额,包括预约
	s NormalCount=..GetNotAvailSeqNoCount(ScheduleID,"NOR")
	if NormalCount>TotalNum Q "-203"
	;预约号最大值
	s AppCount=..GetNotAvailSeqNoCount(ScheduleID,"APP")
	if AppCount>BookNum Q "-204"
	;加号最大值
	s AddCount=..GetNotAvailSeqNoCount(ScheduleID,"ADD")
	i AddCount>OverBookNum Q "-205"
	
	s ret=0
	s ASTRChildSub=0 for  {
		s ASTRChildSub=$O(^RBAS(+ScheduleID,$P(ScheduleID,"||",2),"ASTR",ASTRChildSub))  
		q:ASTRChildSub=""
		s ASTRCMChildSub=0 for {
			s ASTRCMChildSub=$O(^RBAS(+ScheduleID,$P(ScheduleID,"||",2),"ASTR",ASTRChildSub,"TRCG",ASTRCMChildSub))  
			q:ASTRCMChildSub=""
			s APPTRAMData=$g(^RBAS(+ScheduleID,$P(ScheduleID,"||",2),"ASTR",ASTRChildSub,"TRCG",ASTRCMChildSub))
			s ClinicGroupMethodID=$p(APPTRAMData,"^",1)
			i (","_ClinicGroupDR_",")'[(","_ClinicGroupMethodID_",")  {
				s ret="-206"
				q
			}
		}
	}
	q:ret'=0 ret
	
	set ret=##class(web.DHCRBResourceRule).CheckSchedule(ResRowId,ScheduleDate,Roomid, SessStartTime,ScheduleID)
	if ret'=0 {
		s retcode=$P(ret,"^",1)
		s DulASRowId=$P(ret,"^",2)
		if (DulASRowId'=""){
			s DulResRowId=$P(DulASRowId,"||",1)
			s DulResDocRowId=$p(^RB("RES",DulResRowId),"^",2)
			s DulResLocRowId=$p(^RB("RES",DulResRowId),"^",1)
			s DulResDocDesc=$p(^CTPCP(DulResDocRowId,1),"^",2)
			s DulResLocDesc=$p($g(^CTLOC(DulResLocRowId)),"^",2)
		}
		Quit retcode_"^"_DulResLocDesc_DulResDocDesc
	}
	s Para=##class(web.DHCRBApptScheduleUpdateLog).GetOneRBApptSchedule(ScheduleID)
	TStart
	;w "BookNum:"_BookNum
	set schedule=##class(User.RBApptSchedule).%OpenId(ScheduleID)
	set schedule.ASNoApptSession=BookNum
	set schedule.ASLoad=TotalNum
	set schedule.ASQueueNoCount=BookStartNum
	set schedule.ASSessStartTime=SessStartTime
	set schedule.ASSessEndTime=SessEndTime
	if (OldASIrregularFlag="A"){
		Set schedule.ASIrregularFlag="S"
	}	

	Set sc = schedule.%Save()
	If $$$ISERR(sc) {
		Do $System.Status.DisplayError()
		Trollback
		Quit 100
	}
	do schedule.%Close()
	set schedule=##class(User.DHCRBApptSchedule).%OpenId(ScheduleID)
	
	set oldOverBookNum=schedule.ASNoOverbookAllowed
	set oldQueueNo=schedule.ASQueueNo
	do schedule.ASRoomDRSetObjectId(Roomid)
	s schedule.ASNoOverbookAllowed=OverBookNum
	if (+ClinicGroupDR>0){
		Do schedule.ASClinicGroupDRSetObjectId(+ClinicGroupDR)
	}
	s schedule.ASClinicGroupDRStr=ClinicGroupDR
	do schedule.ASSessionTypeDRSetObjectId(SessionTypeDR)
	s schedule.ASStopRegNoFlag=StopRegNoFlag
	s schedule.ASQueueNo=##class(web.DHCRBResourceRule).EditQueueNO(oldQueueNo,oldTotalNum,TotalNum,oldOverBookNum,OverBookNum,ScheduleID,NoLimitLoadFlag)
	s schedule.ASNoLimitLoadFlag=NoLimitLoadFlag
	//分时段就诊
	s ASTRFlag=$P(TimeRangeInfoStr,"^",1)
	s ASTRStartTime=$P(TimeRangeInfoStr,"^",2)
	i ASTRStartTime'="" s ASTRStartTime=..%ZTH(ASTRStartTime,3)
	s ASTREndTime=$P(TimeRangeInfoStr,"^",3)
	i ASTREndTime'="" s ASTREndTime=..%ZTH(ASTREndTime,3)
	s ASTRLength=$P(TimeRangeInfoStr,"^",4)
	s ASTRRegNum=$P(TimeRangeInfoStr,"^",5)
	s ASTRRegNumStr=$P(TimeRangeInfoStr,"^",6)
	s ASTRRegInfoStr=$P(TimeRangeInfoStr,"^",7)
	if TimeRangeInfoStr'="" d
	.s schedule.ASTimeRangeFlag=ASTRFlag
	.s schedule.ASTRStartTime=ASTRStartTime
	.s schedule.ASTREndTime=ASTREndTime
	.s schedule.ASTRLength=ASTRLength
	.s schedule.ASTRRegNum=ASTRRegNum
	.s schedule.ASTRRegNumStr=ASTRRegNumStr
	.s schedule.ASTRRegInfoStr=ASTRRegInfoStr
	//修改正号数量的加诊数量
	s OldAddNum=schedule.ASAddRegNum
	s CurAddNum=CurAddNum+(+OldAddNum)
	s schedule.ASAddRegNum=CurAddNum
	
	;暂时注释
	;set schedule.ASLockFlag=LockFlag
	Set sc = schedule.%Save()
	If $$$ISERR(sc) {
		Do $System.Status.DisplayError()
		Trollback
		Quit 100
	}
	if NoLimitLoadFlag="Y"{
		b //删除限额子表数据
		set sc=##class(web.DHCRBApptScheduleAppQty).DeleteByAS(ScheduleID)
		if (sc'="0"){
			Trollback
			s ErrCode=100
			Quit
		}
	}
	;修改日志  guobaoping
	s ret=##class(web.DHCRBApptScheduleUpdateLog).AddRBApptScheduleLog("U",ScheduleID,Para)
	If ret'=0 {
		Trollback
		Quit 100
	}
	;医生站业务数据修改日志
	set NewDataJson=##class(web.DHCDocDataChangeLog).GetLogJsonData("User.RBApptSchedule"_$c(2)_ScheduleID_"^"_"User.DHCRBApptSchedule"_$c(2)_ScheduleID)
	set ret=##class(web.DHCDocDataChangeLog).SaveLog("RB_ApptSchedule#DHC_RBApptSchedule","User.RBApptSchedule#User.DHCRBApptSchedule","排班信息","User.RBApptSchedule#User.DHCRBApptSchedule_"_ScheduleID,$p($g(^RB("RES",+ScheduleID)),"^",17),"U",NewDataJson,OldDataJson)
	If ret'=0 {
		Trollback
		Quit 100
	}
	//诊室不同修改已挂号数据
	if (OldRoomID'=Roomid)	{
		s rtn=..UpdateOneAdmRoomID(ScheduleID,Roomid)
		}
	//亚专业分时段修改
	if (ClinicGroupDR'=""){
		s rtn=##class(DHCDoc.OPAdm.Schedule).UpdateASRowIDClinicGroup(ScheduleID)
		}
	Tcommit
	d ##class(DHCExternalService.RegInterface.SynVisitSchedule).SynRegCount(ScheduleID) ;SynStopVisitSchedule(ScheduleID)
	//调用平台组接口
	s rtn=##class(web.DHCENS.EnsHISService).DHCHisInterface("S00000003",ScheduleID)
	//大屏接口
	//s CFIFScreenStart=##class(web.DHCOPRegConfig).GetSpecConfigNode("IFScreenStart")
	//if (CFIFScreenStart=1)&&(ScheduleDate=..%SysDate()){
	//	s FullFlag=##class(web.DHCRBApptSchedule).CheckScheduleFull(ScheduleID)
	//	d ##class(dhcinterface.DoctorApptScheClient).SetScreenDisplayMsg(ScheduleID,FullFlag)
	//}
	Quit 0
}

ClassMethod UpdateTestData()
{
	set rs=##class(%ResultSet).%New()
	d rs.Prepare("select as_rowid AS ID from RB_ApptSchedule ")
	d rs.Execute()
	while(rs.Next())
	{
		set ASRowid=rs.Get("ID")
		w ASRowid,!
		set schdule=##class(User.RBApptSchedule).%OpenId(ASRowid)
	set schdule.ASLoad=20
	
	set schdule.ASQueueNoCount=1
	set TotalNum=20
	
	
	d schdule.%Save()
	d schdule.%Close()
	
	set schdule=##class(User.DHCRBApptSchedule).%OpenId(ASRowid)
	//set RowID=$piece($Get(^RB("RES",ASRowid)),"^",2)
				
	//Do object.ASClinicGroupDRSetObjectId(ClinicGroupID)
	set schdule.ASNoOverbookAllowed=20
	set OverBookNum=20
	set schdule.ASQueueNo=##class(web.DHCRBResourceRule).GenerateQueueNO(TotalNum,OverBookNum)
	set r=schdule.ASQueueNo

	d schdule.%Save()
	
	//set sc=##class(web.DHCRBApptScheduleAppQty).Insert(ASRowid)
	
	}
}

Query ApptScheduleListQuery(LocationName As %String, ClinicGroupName As %String, DoctorName As %String, ScheduleDate As %Date, ASRowId As %String, UserID As %String = "") As %Query(ROWSPEC = "ID:%String,LocationName:%String,LocationID:%String,DoctorName:%String,DoctorID:%String,RoomName:%String,RoomID:%String,ScheduleDate:%String,SessionStartTime:%String,SessEndTime:%String,SessionTimeName:%String,SessionTypeDesc:%String,SessionTimeID:%String,Price:%String,TotalNum:%String,BookNum:%String,OverBookNum:%String,AppStartNo:%String,QueueNO:%String,Status:%String,StatusDesc:%String,RegisterNum:%String,AppedNum:%String,AppedArriveNum:%String,TRDoc:%String,SessionClinicGroupDr:%String,SessionClinicGroupDesc:%String,SessionTypeDr:%String,LockFlag:%String,IrregularFlag:%String,TRInfo:%String,SessionClinicGroupDrStr:%String,SessionClinicGroupDescStr:%String,NoLimitLoadFlag:%String")
{
}

/// 停诊替诊申请, add for xhyy ,停替诊审批流程函数
/// 对应审批组件:DHCRBApptScheduleAudit
ClassMethod RBASRequest(RBASID, InfoStr, UserID As %String = "")
{
	//w ##class(web.DHCRBApptSchedule).RBASRequest("3226||66","R^1^1873^242^1^")
	//InfoStr  ASRRequestType(S;R)^ASRReasonDR^ASRDoctorDR^ASRLocDR^ASRSessionTypeDR^ASRRBASDR
	n (RBASID,InfoStr,UserID,%session)
	s:UserID="" UserID=%session.Get("LOGON.USERID")
	s Date=..%SysDate()
	s Time=..%SysTime()
	s ret=0
	s RBID=+RBASID
	s RBASSub=$P(RBASID,"||",2)
	s LocDesc=""
	s LocRowID=$p($g(^RB("RES",+RBID)),"^",1)
	if LocRowID'=""{
		s LocDesc=$p($g(^CTLOC(LocRowID)),"^",2)
		s:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
	}
	s OldResult=""
	s ID=0
	f  s ID=$O(^User.DHCRBApptScheduleRequestI("RBASIDIndex",RBASID,ID)) q:(ID="")||(OldResult'="")  d
	.s obj=##class(User.DHCRBApptScheduleRequest).%OpenId(ID)
	.s Result=obj.ASRRequestResult
	.q:Result'="N"
	.s OldResult=obj.ASRRequestType
	s:OldResult="S" ret="已经申请停诊"
	s:OldResult="R" ret="已经申请替诊"
	q:ret'="0" ret
	s obj=##class(User.DHCRBApptScheduleRequest).%New()
	d obj.ASRRBASIDSetObjectId(RBASID)
	s obj.ASRRequestType=$P(InfoStr,"^",1)
	s obj.ASRRequestResult="N"
	d obj.ASRReasonDRSetObjectId($P(InfoStr,"^",2))
	d obj.ASRDoctorDRSetObjectId($P(InfoStr,"^",3))
	d obj.ASRLocDRSetObjectId($P(InfoStr,"^",4))
	d obj.ASRSessionTypeDRSetObjectId($P(InfoStr,"^",5))
	d obj.ASRRBASDRSetObjectId($P(InfoStr,"^",6))
	d obj.ASRRequestUserDRSetObjectId(UserID)
	s obj.ASRRequestDate=Date
	s obj.ASRRequestTime=Time
	Set sc = obj.%Save()
	If $$$ISERR(sc) {
		s ret="更新申请信息失败"
	}
	q ret
}

// 得到分时段就诊信息

// w ##class(web.DHCRBApptSchedule).GetTimeRangeRegInfo("2315||380","8")

ClassMethod GetTimeRangeRegInfo(RBASId, QueueNo, TimeRangeDesc)
{
	n (RBASId, QueueNo, TimeRangeDesc, %session)
	Q:(RBASId="")||(QueueNo["+") ""
	s TimeRangeFlag=$P($G(^RBAS(+RBASId,$P(RBASId,"||",2),"DHC")),"^",19)
	s RegNumStr=$P($G(^RBAS(+RBASId,$P(RBASId,"||",2),"DHC")),"^",24)
	s RegInfoStr=$P($G(^RBAS(+RBASId,$P(RBASId,"||",2),"DHC")),"^",25)
	s Date=$P($G(^RBAS(+RBASId,$P(RBASId,"||",2))),"^",1)
	s Date=..%ZD(Date) //$ZD(Date,3)
	q:TimeRangeFlag'="Y" ""	;"请咨询护士台"
	;国际医疗不打印时段 for xhyy
	;s DepId=$p($g(^RB("RES",+RBASId)),"^",1)
	;i DepId'="" s DepDesc=$p($g(^CTLOC(DepId)),"^",2)
	;q:$g(DepDesc)["国际医疗" "请咨询护士台"
	
	/*s i=$L(RegNumStr,",")
	s Position=0
	f j=1:1:i
	{
		s regInfo=$P(RegNumStr,",",j)
		s minReg=$P(regInfo,"-",1)
		s maxReg=$P(regInfo,"-",2)
		s:(minReg<=QueueNo)&&(maxReg>=QueueNo) Position=j
	}
	q:Position>0 Date_" "_$P(RegInfoStr,",",Position) //"请于"_Date_"日"_$P(RegInfoStr,",",Position)_"间前来就诊"
	s i=$L(RegInfoStr,"-")
	s lastTime=$P(RegInfoStr,"-",i)*/
	s TimeRange=""
	s OneEndNo=0
	s ASTRSub=0 for {
		s ASTRSub=$O(^RBAS(+RBASId,$P(RBASId,"||",2),"ASTR",ASTRSub)) q:(ASTRSub="")||(TimeRange'="")
		s TRLoad=$P(^RBAS(+RBASId,$P(RBASId,"||",2),"ASTR",ASTRSub),"^",3)
		s OneSttNo=OneEndNo+1,OneEndNo=OneEndNo+TRLoad
		if ((QueueNo>=OneSttNo)&&(QueueNo<=OneEndNo)){
			s StartTime=$P(^RBAS(+RBASId,$P(RBASId,"||",2),"ASTR",ASTRSub),"^",1)
			s EndTime=$P(^RBAS(+RBASId,$P(RBASId,"||",2),"ASTR",ASTRSub),"^",2)
			s TimeRange=..%ZT(StartTime)_"-"_..%ZT(EndTime)
		}
	}
	q:TimeRange'="" Date_" "_TimeRange
	q ""	;"请咨询护士台"
}

/// creater	lxz
/// desc     通过时间点获取包含当前时间点的所有时段
/// w ##class(web.DHCRBApptSchedule).GetTimeRangeStrByTime()
ClassMethod GetTimeRangeStrByTime(TimInput As %String = "", HospId As %String = "") As %String
{
	s HospId=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	s ret=""
	if TimInput=""  s TimInput=..%SysTime()
	s TRRowId=0  f  s TRRowId=$O(^DHCTimeRange(TRRowId)) Q:(TRRowId="")  d
	.Q:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("DHC_TimeRange",TRRowId,HospId)="N"
	.s StartTime=$P(^DHCTimeRange(TRRowId),"^",3)
	.s EndTime=$P(^DHCTimeRange(TRRowId),"^",4)
	.s UseStDate=$P(^DHCTimeRange(TRRowId),"^",7)
	.Q:(UseStDate>+$H)&&(UseStDate'="")
	.s UseEndDate=$P(^DHCTimeRange(TRRowId),"^",8)
	.Q:(UseEndDate<+$H)&&(UseEndDate'="")
	.i (TimInput>=StartTime)&&(TimInput<=EndTime) d
	..if ret="" s ret=TRRowId
	..else  s ret=ret_"!"_TRRowId
	Q ret
}

/// desc  通过时段获取包含传入时段的所有时段
ClassMethod GetTimeRangeStrByRange1(RangeInput As %String = "") As %String
{
	Q:RangeInput="" ""
	s ret=""
	s STimeIn=$P(^DHCTimeRange(RangeInput),"^",3)
	S ETimeIn=$P(^DHCTimeRange(RangeInput),"^",4)
	s TRRowId=0  f  s TRRowId=$O(^DHCTimeRange(TRRowId)) Q:(TRRowId="")  d
	.s StartTime=$P(^DHCTimeRange(TRRowId),"^",3)
	.s EndTime=$P(^DHCTimeRange(TRRowId),"^",4)
	.s UseStDate=$P(^DHCTimeRange(TRRowId),"^",7)
	.Q:(UseStDate>+$H)&&(UseStDate'="")
	.s UseEndDate=$P(^DHCTimeRange(TRRowId),"^",8)
	.Q:(UseEndDate<+$H)&&(UseEndDate'="")
	.i (StartTime<=STimeIn)&&(EndTime>=ETimeIn) d
	..if ret="" s ret=TRRowId
	..else  s ret=ret_"!"_TRRowId
	Q ret
}

/// w ##class(web.DHCRBApptSchedule).GetTimeRangeStrByRange("1!2!3!4")
ClassMethod GetTimeRangeStrByRange(RangeInput As %String = "") As %String
{
	Q:RangeInput="" ""
	s ret=""
	s RangeInputNew=RangeInput
	s len=$l(RangeInput,"!")
	for i=1:1:len {
		s RangeInput=$p(RangeInputNew,"!",i)
		s STimeIn=$P(^DHCTimeRange(RangeInput),"^",3)
		S ETimeIn=$P(^DHCTimeRange(RangeInput),"^",4)
		s TRRowId=0  f  s TRRowId=$O(^DHCTimeRange(TRRowId)) Q:(TRRowId="")  d
		.s StartTime=$P(^DHCTimeRange(TRRowId),"^",3)
		.s EndTime=$P(^DHCTimeRange(TRRowId),"^",4)
		.s UseStDate=$P(^DHCTimeRange(TRRowId),"^",7)
		.Q:(UseStDate>+$H)&&(UseStDate'="")
		.s UseEndDate=$P(^DHCTimeRange(TRRowId),"^",8)
		.Q:(UseEndDate<+$H)&&(UseEndDate'="")
		.i (StartTime<=STimeIn)&&(EndTime>=ETimeIn) d
		..q:("!"_ret_"!")[("!"_TRRowId_"!")
		..if ret="" s ret=TRRowId
		..else  s ret=ret_"!"_TRRowId
	}
	Q ret
}

/// 插入不规则出诊记录,主要用于临时需要出诊记录用
/// w ##class(web.DHCRBApptSchedule).InsertOneIrrSchedule(66,868,63152,2)
ClassMethod InsertOneIrrSchedule(LocID As %String, DocID As %String, SecheduleDate As %String = "", TimeRangeId As %String = "") As %String
{
	;s ^tmpgry("InsertOneIrrSchedule")=LocID_","_DocID_","_SecheduleDate_","_TimeRangeId
	s Rtn="-100"
	Q:(LocID="")||(DocID="") Rtn
	i SecheduleDate="" s SecheduleDate=$zd(+$H,4)
	e  s SecheduleDate=$zd(SecheduleDate,4)
	if TimeRangeId="" {
		;使用封装方法获得
		s TRRowId=##class(web.DHCRBResSession).GetTimeRangeByTime()
	}else{s TRRowId=TimeRangeId}
	Q:TRRowId="" Rtn
	s TotalNum=0 ;挂号数量
	s BookNum=0
	s OverBookNum=0
	s RoomID=""
	s TimeRangeInfoStr=""
	s SessionTypeID=""
	s ResRowId=$o(^RB("RES",0,"CTPCP",DocID,LocID,""))
	Q:ResRowId="" Rtn
	//从模板获取职称
	s ASWeek=$zd($zdh(SecheduleDate,4),10)
	i ASWeek=0 s ASWeek=7
	s RBResEffDateChildsub=$O(^RB("RES",ResRowId,"DATE",""),-1)
	i RBResEffDateChildsub'="" {
		b ;RBResEffDateChildsub
		/// zzz 20160816 循环时段串来检索
		for zi=1:1:$length(TimeRangeId,"^"){
			s TRRowId=$p(TimeRangeId,"^",zi)
			s SESSChildsub=0
			f  s SESSChildsub=$o(^RB("RES",ResRowId,"DATE",RBResEffDateChildsub,"SESS",SESSChildsub)) q:(SESSChildsub="")  d
			.S SessDOWRowid=$p(^RB("RES",ResRowId,"DATE",RBResEffDateChildsub,"SESS",SESSChildsub),"^",2)
			.S SessScheduleGenerFlag=$p(^RB("RES",ResRowId,"DATE",RBResEffDateChildsub,"SESS",SESSChildsub),"^",16)
			.Q:(SessScheduleGenerFlag="N")
			.Q:SessDOWRowid'=ASWeek
			.s SessionRangeID=$p(^RB("RES",ResRowId,"DATE",RBResEffDateChildsub,"SESS",SESSChildsub),"^",3)
			.//Q:TimeRangeId'=SessionRangeID
			.Q:TRRowId'=SessionRangeID
			.s SessionTypeID=$p(^RB("RES",ResRowId,"DATE",RBResEffDateChildsub,"SESS",SESSChildsub),"^",9)
			.s TimeRangeInfoStr=$g(^RB("RES",ResRowId,"DATE",RBResEffDateChildsub,"SESS",SESSChildsub,"DHC"))
		}
	}
	//如果排班模板上为空则找最近一次的排班记录
	i SessionTypeID="" {
		s ASDate=$O(^RBAS(ResRowId,0,"DateSTime",""),-1)
		i ASDate'="" s SessStartTime=$O(^RBAS(ResRowId,0,"DateSTime",ASDate,""),-1)
		i $g(SessStartTime)'="" s AsChildId=$O(^RBAS(ResRowId,0,"DateSTime",ASDate,SessStartTime,""),-1)
		i $g(AsChildId)'="" s SessionTypeID=$p($g(^RBAS(ResRowId,AsChildId,"DHC")),"^",6)
	}
	//从医生默认设置中获取出诊职称
	i SessionTypeID="" {
		s SessionTypeID=$p($g(^RB("RES",ResRowId,"DHC")),"^",1)
	}
	Q:SessionTypeID="" Rtn
	s ClinicGroupID=""
	s BookStartNum=""
	s SessStartTime=""
	s SessEndTime=""
	s StatusCode="N"
	s ASIrregularFlag="A"  ;不规则加诊标志
	s TimeRangeInfoStr=""
	s Rtn=##class(web.DHCRBApptSchedule).InsertOneSchedule(SecheduleDate,DocID,LocID,TRRowId,TotalNum, BookNum, OverBookNum,RoomID,SessionTypeID,ClinicGroupID, BookStartNum , SessStartTime, SessEndTime, StatusCode, TimeRangeInfoStr,ASIrregularFlag)
	Q Rtn
}

/// creater lxz
/// desc 查看资源是否在停诊中（长时段停诊）
/// input RBResourceDr 资源ID  InDate 日期
/// Retuen "Y" 停诊 "N" 正常
/// SQLUser RB_NotAvail 停诊表
/// w ##class(web.DHCRBApptSchedule).IsStopRBResource(549,63553)
ClassMethod IsStopRBResource(RBResourceDr As %String, InDate As %String) As %String
{
	s ^Tempzong("IsStopRBResource")=RBResourceDr_"^"_InDate
	Q:(RBResourceDr="")||(InDate="") "N"
	s Flag="N"
	s Date=0
	f  s Date=$O(^RB("NA",0,"RES",RBResourceDr,Date)) Q:(Date="")  d
	.s NARowId=0
	.f  s NARowId=$O(^RB("NA",0,"RES",RBResourceDr,Date,NARowId)) Q:(NARowId="")  d
	..s StDate=$P($P($G(^RB("NA",NARowId)),"^",2),"Z",1)
    ..s EDate=$P($P($G(^RB("NA",NARowId)),"^",3),"Z",1)
    ..Q:(InDate<StDate)
  	..Q:(InDate>EDate)
 	..s RSVP=$P(^RB("NA",NARowId),"^",6) ;"Y"-停诊 "N"-撤销停诊
  	..if RSVP="Y"  s Flag="Y"
  	..else  s Flag="N"
    q Flag
}

/// w ##class(web.DHCRBApptSchedule).CopySchedules("2020-06-08","2020-06-12","2020-11-02","2020-11-06","")
ClassMethod CopySchedules(CopyStartDate As %Date, CopyEndDate As %Date, CreatStartDate As %Date, CreatEndDate As %Date, CopyByOneWeek As %String = "", HospID As %String = "") As %String
{
	s ^zhangkui("CopySchedules")=CopyStartDate_","_CopyEndDate_","_CreatStartDate_","_CreatEndDate_","_CopyByOneWeek
	q:CopyStartDate="" "-1^ 样板模板时间段开始日期不能为空"
	q:CopyEndDate="" "-1^ 样板模板时间段结束日期不能为空"
	q:CreatStartDate="" "-1^ 生成排班时间段开始日期不能为空"
	q:CreatEndDate="" "-1^ 生成排班时间段结束日期不能为空"
	//初始化日期格式
	if CopyStartDate["/" s CopyStartDate=$zdh(CopyStartDate,4)
	if CopyStartDate["-" s CopyStartDate=$zdh(CopyStartDate,3)
	if CopyEndDate["/" s CopyEndDate=$zdh(CopyEndDate,4)
	if CopyEndDate["-" s CopyEndDate=$zdh(CopyEndDate,3)
	if CreatStartDate["/" s CreatStartDate=$zdh(CreatStartDate,4)
	if CreatStartDate["-" s CreatStartDate=$zdh(CreatStartDate,3)
	if CreatEndDate["/" s CreatEndDate=$zdh(CreatEndDate,4)
	if CreatEndDate["-" s CreatEndDate=$zdh(CreatEndDate,3)
	
	
	if ((CopyByOneWeek="on")||(CopyByOneWeek=1)){
	if ((CopyEndDate-CopyStartDate)'=6) q "-1^按照一周复制样本模板时间段必须是一周"
	for Date1=CopyStartDate:1:CopyEndDate d
	.if ($zd(Date1,10)=1) s Monday=Date1
	.if ($zd(Date1,10)=2) s Tuesday=Date1
	.if ($zd(Date1,10)=3) s Wednesday=Date1
	.if ($zd(Date1,10)=4) s Thursday=Date1
	.if ($zd(Date1,10)=5) s Friday=Date1
	.if ($zd(Date1,10)=6) s Saturday=Date1
	.if ($zd(Date1,10)=0) s Sunday=Date1
	for OneDay1=CreatStartDate:1:CreatEndDate d
	.if ($zd(OneDay1,10)=1) s CopyFromDate1=$G(Monday)
	.if ($zd(OneDay1,10)=2) s CopyFromDate1=$G(Tuesday)
	.if ($zd(OneDay1,10)=3) s CopyFromDate1=$G(Wednesday)
	.if ($zd(OneDay1,10)=4) s CopyFromDate1=$G(Thursday)
	.if ($zd(OneDay1,10)=5) s CopyFromDate1=$G(Friday)
	.if ($zd(OneDay1,10)=6) s CopyFromDate1=$G(Saturday)
	.if ($zd(OneDay1,10)=0) s CopyFromDate1=$G(Sunday)
	.if CopyFromDate1'="" d
	..d ..CopyOneDaySchedule(CopyFromDate1,OneDay1,HospID)
	}else{
		if ((CopyEndDate-CopyStartDate)'=(CreatEndDate-CreatStartDate)) q "-2^不按照一周复制，模板和生成的时间段天数必须一样多"
		
		for CopyIndex=1:1:(CopyEndDate-CopyStartDate+1) d
	    .s CopyDate=CopyStartDate+CopyIndex-1
	    .s CreatDate=CreatStartDate+CopyIndex-1
		.d ..CopyOneDaySchedule(CopyDate,CreatDate,HospID)
	}
	
	q 0
}

ClassMethod CopyOneDaySchedule(CopyFromDate2 As %Date, CopyToDate2 As %Date, HospID As %String = "") As %String
{
	q:CopyFromDate2="" "-2^被复制样本模板日期不能为空"
	q:CopyToDate2="" "-2^生成排班日期不能为空"
	s ExpStr=%session.Get("LOGON.GROUPID")_"^"_%session.Get("LOGON.USERID")
	if CopyFromDate2["/" s CopyFromDate2=$zdh(CopyFromDate2,4)
	if CopyFromDate2["-" s CopyFromDate2=$zdh(CopyFromDate2,3)
	if CopyToDate2["/" s CopyToDate2=$zdh(CopyToDate2,4)
	if CopyToDate2["-" s CopyToDate2=$zdh(CopyToDate2,3)
	
	s RESRowId2=0
	f  s RESRowId2=$o(^RB("RES",RESRowId2)) q:RESRowId2=""  d
	.s RESCTLOCDR=$p(^RB("RES",RESRowId2),"^",1)
	.Q:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("CT_Loc",RESCTLOCDR,HospID)="N"
	.s ASSessStartTime2="" f  s ASSessStartTime2=$o(^RBAS(RESRowId2,0,"DateSTime",CopyFromDate2,ASSessStartTime2)) q:ASSessStartTime2=""  d
	..s ASChildSub2=0 f  s ASChildSub2=$o(^RBAS(RESRowId2,0,"DateSTime",CopyFromDate2,ASSessStartTime2,ASChildSub2)) q:ASChildSub2=""  d
	...s ScheduleID2=RESRowId2_"||"_ASChildSub2
	...q:$d(^RBAS(RESRowId2,ASChildSub2))=0
	...q:$d(^RBAS(RESRowId2,ASChildSub2,"DHC"))=0
	...s ASSessionTypeDR2=$p(^RBAS(RESRowId2,ASChildSub2,"DHC"),"^",6)
	...q:ASSessionTypeDR2=""
	...s SESSDesc2=$p($g(^RBC("SESS",ASSessionTypeDR2)),"^",2)
	...;q:SESSDesc2'["病房"                     //哈医大只生成职称带有"病房"的排班。
	...s ASStatusDR2=$p($g(^RBAS(RESRowId2,ASChildSub2,"DHC")),"^",10)
	...s ASSCode2=$p($g(^DHCRBCASStatus(ASStatusDR2)),"^",1)
	...//标版修改为  生成正常 加诊 补诊的排班
	...q:(ASSCode2'="N")&&(ASSCode2'="A")&&(ASSCode2'="AR") //哈医大只生成正常的排班（不包含停替诊，加诊等）                     
	...s ret2=..CopyOneScheduleNew(ScheduleID2,CopyToDate2,"","",ExpStr)
}

ClassMethod CopyOneSchedule(ScheduleID3 As %String, CopyToDate3 As %Date) As %String
{
	q:ScheduleID3="" "ScheduleID不能为空"
	q:CopyToDate3="" "-3^生成排班日期不能为空"
	if CopyToDate3["/" s CopyToDate3=$zdh(CopyToDate3,4)
	if CopyToDate3["-" s CopyToDate3=$zdh(CopyToDate3,3)
	s ASStatusDR3=$p($g(^RBAS(+ScheduleID3,$P(ScheduleID3,"||",2),"DHC")),"^",10)
	
	
	s ScheduleTime3=$P($G(^RBAS(+ScheduleID3,$P(ScheduleID3,"||",2))),"^",4)
	s ScheduleDate3=$P($G(^RBAS(+ScheduleID3,$P(ScheduleID3,"||",2))),"^",1)
	s TimeRangeRowId3=$P($G(^RBAS(+ScheduleID3,$P(ScheduleID3,"||",2),"DHC")),"^",17)
	;s TimeRangeRowId=##class(web.DHCRBResSession).GetTimeRangeByTime(ScheduleTime)
	s ResRowID3=+ScheduleID3
	s AvailRA3=..GetAvailRANew(ResRowID3,CopyToDate3,"",TimeRangeRowId3)
	Q:AvailRA3'="" "-3^同一时段同一个医生只能有一个排班"
	TStart
	;

	//Trakcare排班记录表User.RBApptSchedule
	set Oldschedule3=##class(User.RBApptSchedule).%OpenId(ScheduleID3)
	set NewSchedule3=##class(User.RBApptSchedule).%New(ResRowID3)
	do NewSchedule3.ASRESParRefSetObjectId(ResRowID3)
	set ASDate3=CopyToDate3
	set NewSchedule3.ASDate=CopyToDate3
	set NewSchedule3.ASSessStartTime=Oldschedule3.ASSessStartTime
	set NewSchedule3.ASSessEndTime=Oldschedule3.ASSessEndTime
	set NewSchedule3.ASLoad=Oldschedule3.ASLoad
	set NewSchedule3.ASAvailability=Oldschedule3.ASAvailability
	set NewSchedule3.ASQueueNoCount=Oldschedule3.ASQueueNoCount
	;预约限额
	set NewSchedule3.ASNoApptSession=Oldschedule3.ASNoApptSession
	//set NewSchedule.ASRBEffDateSessionDR=Oldschedule.ASRBEffDateSessionDR
	set NewSchedule3.ASNumPatIn=Oldschedule3.ASNumPatIn
	set NewSchedule3.ASNumPatOut=Oldschedule3.ASNumPatOut
	set NewSchedule3.ASSession=Oldschedule3.ASSession
	Set sc = NewSchedule3.%Save()
	If $$$ISERR(sc) {
		Do $System.Status.DisplayError()
		Trollback
		Quit 100
	}
	
	do Oldschedule3.%Close()
	do NewSchedule3.%Close()
	set NewScheduleID3=NewSchedule3.%Id()
	Set ChildSub3=NewSchedule3.ASChildSub
	//Dhc排班记录扩展表User.DHCRBApptSchedule
	set Oldschedule3=##class(User.DHCRBApptSchedule).%OpenId(ScheduleID3)
	set NewSchedule3=##class(User.DHCRBApptSchedule).%OpenId(NewScheduleID3)
	Do NewSchedule3.ASRESParRefSetObjectId(ResRowID3)
	set NewSchedule3.ASChildsub=ChildSub3
	set NewSchedule3.ASDate=CopyToDate3
	set NewSchedule3.ASNoOverbookAllowed=Oldschedule3.ASNoOverbookAllowed
	set NewSchedule3.ASQueueNo=Oldschedule3.ASQueueNo
	set NewSchedule3.ASRoomDR=Oldschedule3.ASRoomDR
	do NewSchedule3.ASSessionTypeDRSetObjectId(Oldschedule3.ASSessionTypeDR.%Id())
	set NewSchedule3.ASClinicGroupDR=Oldschedule3.ASClinicGroupDR
	//注意如果没有分时段就诊的老库，可能需要去掉下面这一段
	//分时段就诊
	set NewSchedule3.ASTimeRangeFlag=Oldschedule3.ASTimeRangeFlag
	set NewSchedule3.ASTRStartTime=Oldschedule3.ASTRStartTime
	set NewSchedule3.ASTREndTime=Oldschedule3.ASTREndTime
	set NewSchedule3.ASTRLength=Oldschedule3.ASTRLength
	set NewSchedule3.ASTRRegNum=Oldschedule3.ASTRRegNum
	set NewSchedule3.ASTRRegNumStr=Oldschedule3.ASTRRegNumStr
	set NewSchedule3.ASTRRegInfoStr=Oldschedule3.ASTRRegInfoStr
	//注意如果没有分时段就诊的老库，可能需要去掉上面这一段
	//set NewSchedule.ASStatusDR=Oldschedule.ASStatusDR
	&SQL(Select ASS_Rowid into :ASStatusDR3 from SQLUser.DHC_RBCASStatus Where ASS_Code='N')
	;b ;ASStatusDR
	Do NewSchedule3.ASStatusDRSetObjectId(ASStatusDR3)
	Do NewSchedule3.ASTimeRangeDRSetObjectId(TimeRangeRowId3)
	set NewSchedule3.ASDateCreate=$piece($h,",",1)
	set NewSchedule3.ASTimeCreate=$piece($h,",",2)
	set NewSchedule3.ASASDR=Oldschedule3.%Id()  //作为指向标志是说明由这条排班生成的
	Set sc = NewSchedule3.%Save()
	If $$$ISERR(sc) {
		Do $System.Status.DisplayError()
		Trollback
		Quit 100
	}
	
	 
	
	//复制原排班的预约限额
	s err=0
	s AQChild3=0  f  s AQChild3=$O(^RBAS(+ScheduleID3,$P(ScheduleID3,"||",2),"AQ",AQChild3))  q:(AQChild3="")!(err=100)  d
	.s APPData3=^RBAS(+ScheduleID3,$P(ScheduleID3,"||",2),"AQ",AQChild3)
	.s MethodDR3=$P(APPData3,"^",1)
 	.s Qty3=$P(APPData3,"^",2)
 	.s AQStartNum3=$P(APPData3,"^",3)
	.s appQty3=##class(User.DHCRBApptScheduleAppQty).%New(NewScheduleID3)
	.d appQty3.ASQASParRefSetObjectId(NewScheduleID3)
	.d appQty3.ASQMethodDRSetObjectId(MethodDR3)
	.s appQty3.ASQQty=Qty3
	.s appQty3.ASQStartNum=AQStartNum3
	.S sc = appQty3.%Save()
	.I $$$ISERR(sc) s err=100
	 i err=100 {
	    Tro
		Q 101
	}
	 
	;状态改变日志
	s ret=##class(web.DHCRBApptSchedule).AddRBApptScheduleStatusLog(ScheduleID3,"N")
	If ret'=0 {
		Trollback
		Quit 100
	}
	;医生站业务数据修改日志
	set NewDataJson=##class(web.DHCDocDataChangeLog).GetLogJsonData("User.RBApptSchedule"_$c(2)_ScheduleID3_"^"_"User.DHCRBApptSchedule"_$c(2)_ScheduleID3)
	set ret=##class(web.DHCDocDataChangeLog).SaveLog("RB_ApptSchedule#DHC_RBApptSchedule","User.RBApptSchedule#User.DHCRBApptSchedule","排班信息","User.RBApptSchedule#User.DHCRBApptSchedule_"_ScheduleID3,$p($g(^RB("RES",+ScheduleID3)),"^",17),"A",NewDataJson,"")
	If ret'=0 {
		Trollback
		Quit 100
	}
	Tcommit
	d ##class(DHCExternalService.RegInterface.SynVisitSchedule).SynOneSchedule(ScheduleID3)  //同步到号源平台
	
	Quit 0
}

/// 查找预约方式的SQLQuery
Query LookupApptMethod(Code As %String, Desc As %String) As %SQLQuery(ROWSPEC = "预约方式名称:%String,RowId:%String,Code:%String")
{
	select APTM_Desc,APTM_RowId,APTM_Code from SQLUser.RBC_AppointMethod
	where (APTM_Code %Startswith :Code) or (APTM_Desc %Startswith :Desc)
}

// w ##class(web.DHCRBApptSchedule).FormatQueueNoStrNew("A400101,A400102,A400103,A400104,A400105")

ClassMethod FormatQueueNoStrNew(QueueNoStr As %String) As %String
{
	n (QueueNoStr)
	Q:QueueNoStr="" ""
	s PreQueueNo=""
	s NextQueueNo=""
	s CurrQueueNo=""
	s myRtnStr=""
	
	s Len=$l(QueueNoStr,",")
	s i=Len
	while(i>0){
		s PreQueueNo=$p(QueueNoStr,",",i-1)
		s PreQueueNoStr=##class(web.UDHCJFBaseCommon).GetINVPreABCInfo(PreQueueNo)
		s OnePreQueueNoABC=$p(PreQueueNoStr,"^",2)
		s OnePreQueueNo=$p(PreQueueNoStr,"^",1)
		s CurrQueueNo=$p(QueueNoStr,",",i)
		s CurrQueueNoStr=##class(web.UDHCJFBaseCommon).GetINVPreABCInfo(CurrQueueNo)
		s CurrQueueNoABC=$p(CurrQueueNoStr,"^",2)
		s OneCurrQueueNo=$p(CurrQueueNoStr,"^",1)
		s NextQueueNo=$p(QueueNoStr,",",i+1)
		if NextQueueNo="" {
			s myRtnStr=myRtnStr_"-"_CurrQueueNo
			goto Next1
		}
		if PreQueueNo="" {
			s myRtnStr=CurrQueueNo_myRtnStr
			goto Next1
		}
		if OneCurrQueueNo'=(OnePreQueueNo+1) {
			s myRtnStr="-"_PreQueueNo_","_CurrQueueNo_myRtnStr
		}
		
Next1
		s i=i-1
	}
	if ($p(myRtnStr,"-",1)="") s myRtnStr=$p(myRtnStr,"-",2)
	Q myRtnStr
}

// zhangjianwei

ClassMethod SendMessage(ScheduleID)
{
  	   //d ##class(web.DHCRBApptSchedule).SendMessage("4266||2")
      //取出科室和医生信息
      
	s RESID=+ScheduleID
	s LocDr=$p(^RB("RES",RESID),"^",1)
	S Loc=$p(^CTLOC(LocDr),"^",2)
	s DocDr=$p(^RB("RES",RESID),"^",2)
	s Doc=$p(^CTPCP(DocDr,1),"^",2)
	s RBAppsub=$p(ScheduleID,"||",2)
	//向18937527756发送信息提示医生停诊
	
	s AsDate=$p(^RBAS(+ScheduleID,$P(ScheduleID,"||",2)),"^",1)
	s AsDate=$zd(AsDate,3)
	//S message="【河南省人民医院】"_$p(AsDate,"-",1)_"年"_$p(AsDate,"-",2)_"月"_$p(AsDate,"-",3)_"日"_","_Loc_Doc_"医生门诊,因故取消"

	//d ##class(web.DHCENS.EnsHISService).DHCHisInterface("S00000043","18937527756",message)
	
	 //循环停诊信息对应的预约信息
 	s AppSub="" f  s AppSub=$o(^RBAS(RESID,RBAppsub,"APPT",AppSub)) q:AppSub=""  d
 	.q:+AppSub=0
 	.S appstuts=$p(^RBAS(RESID,RBAppsub,"APPT",AppSub),"^",3)
 	.q:appstuts'="I"
 	.//判断是不是无卡预约
	.S Exite=$D(^RBAS(RESID,RBAppsub,"APPT",AppSub,"DHC"))
    .i Exite'=0  d
	..s Name=$p(^RBAS(RESID,RBAppsub,"APPT",AppSub,"DHC"),"^",1)
    ..s EName=$E(Name,2,$l(Name))
	..s APPTMobilePhone=$p(^RBAS(RESID,RBAppsub,"APPT",AppSub,"DHC"),"^",5)
	.e  d
	..s papmidr=$p(^RBAS(RESID,RBAppsub,"APPT",AppSub),"^",2)
	..s Name=$p(^PAPER(papmidr,"ALL"),"^",1) 
	..s EName=$E(Name,2,$l(Name))
	..S APPTMobilePhone=$p(^PAPER(papmidr,"PER",1),"^",11) 
	.s APPTQueueNo=$p(^RBAS(RESID,RBAppsub,"APPT",AppSub),"^",5)
	  .//通过预约 的就诊队列号取到就诊时段信息
	.s time=##class(web.DHCOPAdmReg).GetAdmTimeBySeqNo(ScheduleID,APPTQueueNo)
	.i time="" d 
	..s time=##class(web.DHCOPAdmReg).GetAdmTimeRange(ScheduleID,APPTQueueNo) //GetAdmTimeBySeqNo
	.s admsttime=$p(time,"-",1)
	.s hour=$p(admsttime,":",1)
	.s minate=$p(admsttime,":",2)
	.S date=$p(^RBAS(RESID,RBAppsub),"^",1)
	.s date=$zd(date,3)
	.s year=$p(date,"-",1)
	.s month=$p(date,"-",2)
	.s day=$p(date,"-",3) 
	.s message= "【河南省人民医院】*"_EName_"您好，非常抱歉，您预约的"_year_"年"_month_"月"_day_"日"_hour_"时"_minate_"分我院"_Loc_Doc_"医生门诊，因故取消，您可预约同时段其他医生或者重新预约该医生其他时段的号源，感谢您的理解与支持！"	
	.//w message,!
	.d ##class(web.DHCENS.EnsHISService).DHCHisInterface("S00000043",APPTMobilePhone,message)
}

ClassMethod FADUANXIN()
{
	//d ##class(web.DHCRBApptSchedule).FADUANXIN()
	s STR="262||3,604||1,765||1,765||2,777||1,862||1,1369||1,1369||2,1400||1,1455||1,1455||2,1461||1,1461||2,1498||1,1498||2,1649||1,1649||2,1682||10,1682||11,2016||5,2016||6,2209||2,2209||3,2251||1,2269||1,2277||2,2279||1,2384||3,2386||3,2418||3,2448||2,2448||3,2448||4,2450||3,2466||3,2466||5,2529||1,2529||3,2529||5,2592||5,2632||3,2733||2,3514||1,3530||2,3555||13,3555||14,3565||9,3565||10,3612||4,3612||6,3612||14,3614||4,3614||6,3630||6,3630||7,3669||2,3673||4,3673||6,3673||8,3674||4,3681||4,3681||6,3869||3,3985||1,3985||2,3985||4,4219||1,4219||2,4266||2,4266||8,4266||10,4289||1,4289||2,4629||2,5198||2,5929||1"
	S ScheduleID=""
	S N=$L(STR,",")
	b ;545
	for i=1:1:N {
		s ScheduleID=$p(STR,",",i)
		d ..SendMessage(ScheduleID)
		//s rtn=##class(web.DHCENS.EnsHISService).DHCHisInterface("STOPAPPTSCHEDULEINFO",ScheduleID)
		//w rtn,!
		}
	     
	
	q 0
}

// 停替珍信息查询

Query FindStopReschedule(Loc As %String = "", StDate As %String, EnDate As %String, BordBor As %String = "") As %Query(ROWSPEC = "LocDesc:%String,DocDesc:%String,AsDate:%String,ASStatus:%String,UserAuthorise:%String,ASASDesc:%String") [ SqlProc ]
{
}

// D ##class(%ResultSet).RunQuery("web.DHCRBApptSchedule","FindStopReschedule","","","","")

ClassMethod FindStopRescheduleExecute(ByRef qHandle As %Binary, Loc As %String = "", StDate As %String = "", EnDate As %String = "", BordBor As %String = "") As %Status
{
	n repid
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	//排班表的索引
	//^RBAS({RB_Resource.RES_RowId},0,"DateSTime",{AS_Date},{AS_SessStartTime},{AS_ChildSub})
	//由资源表科室索引//科室为空时只能查询本安全组对应的科室
	//^RB("RES",0,"CTLOC",{RES_CTLOC_DR},{RES_RowId})
	if (StDate="")||(EnDate="") 	Set qHandle=$lb(0,repid,0)
	q:(StDate="")||(EnDate="") $$$OK
	i StDate["-" s StDate=$zdh(StDate,3)
	i EnDate["-" s EnDate=$zdh(EnDate,3)
	if Loc'="" d
	.s RBRowID=""  f  s RBRowID=$o(^RB("RES",0,"CTLOC",Loc,RBRowID)) q:RBRowID=""  D
	..do GetInfo
	e  d
	.Q:BordBor=""
	.s ID="" F  S ID=$O(^User.DHCExaBorDepI("BordBorDrIndex",BordBor,ID)) Q:ID=""  D 
	..S Loc=$LIST(^User.DHCExaBorDepD(ID),7)
	..s RBRowID=""  f  s RBRowID=$o(^RB("RES",0,"CTLOC",Loc,RBRowID)) q:RBRowID=""  d
	...do GetInfo
	
	  //Set ^CacheTemp(repid,ind)=$lb("科室","医生","出诊时间","状态","停替珍处理人","替珍医生")
	Set ind=ind+1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
GetInfo

	s StartDate=StDate-1 
	f  s StartDate=$o(^RBAS(RBRowID,0,"DateSTime",StartDate)) q:(StartDate>EnDate)||(StartDate="")  d
	.s SessStartTime="" f  s SessStartTime=$O(^RBAS(RBRowID,0,"DateSTime",StartDate,SessStartTime)) q:SessStartTime=""  d
	..s ChildSub="" f  s ChildSub=$o(^RBAS(RBRowID,0,"DateSTime",StartDate,SessStartTime,ChildSub)) q:ChildSub=""  d
	...s ASStatusDR =$p(^RBAS(RBRowID,ChildSub,"DHC"),"^",10)
	...q:ASStatusDR=""
	...s checkstr="234"
	...q:$find(checkstr,ASStatusDR)=0
	...s LocDr=$p(^RB("RES",RBRowID),"^",1)
	...s LocDesc=$P(^CTLOC(LocDr),"^",2)
	...s DocDr=$p(^RB("RES",RBRowID),"^",2)
	...s DocDesc=$p(^CTPCP(DocDr,1),"^",2)
	...s AsDate=$p(^RBAS(RBRowID,ChildSub),"^",1)
	...s AsDate=$zd(AsDate,3)
	...s ASStatus=$P(^DHCRBCASStatus(ASStatusDR),"^",2)
	...s UserAuthoriseDR=$p(^RBAS(RBRowID,ChildSub,"DHC"),"^",13)
	...i UserAuthoriseDR'="" d
	....s UserAuthorise=$p(^SSU("SSUSR",UserAuthoriseDR),"^",2)
	...s ASASDR=$p(^RBAS(RBRowID,ChildSub,"DHC"),"^",12)
	...s ASASDesc=""
	...i ASASDR'="" d
	....s ASRESParRef=$p(^RBAS(+ASASDR,$p(ASASDR,"||",2),"DHC"),"^",1)
	....s ASASDocDr=$P(^RB("RES", ASRESParRef),"^",2)
	....s ASASDesc=$p(^CTPCP(ASASDocDr,1),"^",2)
     
	...s Data=$lb(LocDesc,DocDesc,AsDate,ASStatus,UserAuthorise,ASASDesc)
	...Set ^CacheTemp(repid,ind)=Data
	...Set ind=ind+1
}

ClassMethod FindStopRescheduleClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindStopRescheduleExecute ]
{
	n repid
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindStopRescheduleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindStopRescheduleExecute ]
{
	n repid
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {			// if there are no more rows, finish fetching
	 Set AtEnd=1
	 Set Row=""
	 k ^CacheTemp(repid)
	}Else {				// fetch rowf
	 Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 5800||10 
/// w ##class(web.DHCRBApptSchedule).SendDHCMessage("5800||10","5801||10",299,1)
ClassMethod SendDHCMessage(RBASRowid As %String, NewASRowid As %String, UserId As %String)
{
	//1、       尊敬的**诊区分诊护士您好：您 xx诊区  xx科室  xx医师  x年x月x日/（  x年x月x日--  x年x月x日）的出诊记录已经发生替诊，替诊医师 xx科xx医生 ，请及时做好相关处理，如有问题请联系门诊办公室。
	//2、       尊敬的**诊区分诊护士您好：您 xx诊区  xx科室  xx医师  x年x月x日/（  x年x月x日--  x年x月x日）的出诊记录已经发生替诊，替诊医师 xx科xx医生 ，请及时做好相关处理，如有问题请联系门诊办公室。
	//尊敬的用户您好：您 xx诊区  xx科室  xx大夫  x年x月x日的出诊记录已经发生停诊，请知晓处理，如有问题请联系门诊办公室。
	//Set rtn =##class(websys.DHCMessageInterface).Send(Context, ActionTypeCode, FromUserRowId, EpisodeId , OrdItemId , ToUserRowId , OtherInfoJson )
	s LocRowid=$p(^RB("RES",+RBASRowid),"^",1)
	s DocRowid=$p(^RB("RES",+RBASRowid),"^",2)
	S DocDesc=$p(^CTPCP(DocRowid,1),"^",2)
	s ASDate=$p(^RBAS(+RBASRowid,$P(RBASRowid,"||",2)),"^",1)
	s LocDesc=$p(^CTLOC(LocRowid),"^",2)
	s CtLocMajor=##class(web.DHCOPAdmReg).GetDepartmentGroupId(LocRowid)    
	if (CtLocMajor'=""){
		s LocDesc=$p($g(^DHCCTLoc(CtLocMajor)),"^",2)	
	}
	S ASDate=$zd(ASDate,3)
	s ASDate=$p(ASDate,"-",1)_"年"_$p(ASDate,"-",2)_"月"_$p(ASDate,"-",3)_"日"
	s NewLocRowid="",NewDocRowid=""
	s UserName=$p(^SSU("SSUSR",UserId),"^",2)
	if NewASRowid'=""{
		s NewLocRowid=$p(^RB("RES",+NewASRowid),"^",1)
		s NewDocRowid=$p(^RB("RES",+NewASRowid),"^",2)
		s NewLocDesc=$p(^CTLOC(NewLocRowid),"^",2)
		s NewDocDesc=$p(^CTPCP(NewDocRowid,1),"^",2)
		s id=0
		s UserIdStr=""
		for  s id=$o(^User.DHCExaBorDepI("BordDepDrIndex"," "_LocRowid,id)) quit:id=""  do
		.s BorId=$list(^User.DHCExaBorDepD(id),6)
		.q:BorId=""
		.s BorDesc=$list(^User.DHCExaBoroughD(BorId),"5")
		.s UserIdStr=""
		.s boruserId=0
		.for  s boruserId=$o(^User.DHCBorUserI("BoruBorDrIndex",BorId,boruserId)) Quit:boruserId=""  do
		..Set userid=$list(^User.DHCBorUserD(boruserId),3)
		..if UserIdStr="" s UserIdStr=userid
		..else  s UserIdStr=UserIdStr_"^"_userid
		.q:UserIdStr=""
		.s content="尊敬的"_BorDesc_"分诊护士您好:您"_BorDesc_" "_LocDesc_" "_DocDesc_" "_ASDate_"的出诊记录已经发生替诊，替诊医师 "_NewLocDesc_" "_NewDocDesc_"，请及时做好相关处理，如有问题请联系门诊办公室"
		.s rtn=##class(websys.DHCMessageInterface).Send(content, "1047", UserName, "" , "" , UserIdStr , "")	
	}else{
		s id=0
		s UserIdStr=""
		for  s id=$o(^User.DHCExaBorDepI("BordDepDrIndex"," "_LocRowid,id)) quit:id=""  do
		.s BorId=$list(^User.DHCExaBorDepD(id),6)
		.q:BorId=""
		.s BorDesc=$list(^User.DHCExaBoroughD(BorId),"5")
		.s UserIdStr=""
		.s boruserId=0
		.for  s boruserId=$o(^User.DHCBorUserI("BoruBorDrIndex",BorId,boruserId)) Quit:boruserId=""  do
		..Set userid=$list(^User.DHCBorUserD(boruserId),3)
		..if UserIdStr="" s UserIdStr=userid
		..else  s UserIdStr=UserIdStr_"^"_userid
		.q:UserIdStr=""
		.s content="尊敬的"_BorDesc_"分诊护士您好:您"_BorDesc_" "_LocDesc_" "_DocDesc_" "_ASDate_"的出诊记录已经发生停诊，请知晓处理，如有问题请联系门诊办公室。"
		.s rtn=##class(websys.DHCMessageInterface).Send(content, "1047", UserName, "" , "" , UserIdStr , "")	
	}
	
	q 0
}

/// w ##class(web.DHCRBApptSchedule).GetExaBorFlag(6)
ClassMethod GetExaBorFlag(LocRowid As %String)
{
	s BordRowid=$o(^User.DHCExaBorDepI("BordDepDrIndex"," "_LocRowid,0))
	s BorRowid=""
	if BordRowid'=""{
		s BorRowid=$list(^User.DHCExaBorDepD(BordRowid),6)	
	}
	s borStr=",25,24,20,16,18,17,14,11,22,"
	if BorRowid'=""{
		s BorRowid=","_BorRowid_","
		if borStr[BorRowid{
			q 0	
		}
	}
	Quit 1
}

// 更新医生默认设置到分时段设置中

// w ##class(web.DHCRBApptSchedule).updatert()

ClassMethod updatert() As %String
{
	s RESRowId=0
	f  s RESRowId=$o(^RB("RES",RESRowId)) q:RESRowId=""  d
	.q:'$d(^RB("RES",RESRowId))
	.s RESCTLOCDR=$p(^RB("RES",RESRowId),"^",1)
	.//q:RESCTLOCDR'="6"
	.q:'$d(^RB("RES",RESRowId,"DHC"))
	.s RESLoad=$p(^RB("RES",RESRowId,"DHC"),"^",3)
	.s RESAppLoad=$p(^RB("RES",RESRowId,"DHC"),"^",4)
	.s RESAppStartNum=$p(^RB("RES",RESRowId,"DHC"),"^",5)
	.s RESLoadXW=$p(^RB("RES",RESRowId,"DHC"),"^",19)
	.s RESTRowid=$o(^RB("RES",RESRowId,"REST",""))
	.i RESTRowid="" d
	..//INSERT INTO table_name (列1, 列2,...) VALUES (值1, 值2,....)
	..&sql(insert into SQLUser.DHC_RBResourceTR (REST_Resource_DR,REST_TimeRange_DR,REST_Load,REST_AppLoad,REST_AppStartNum) values (:RESRowId,1,:RESLoad,:RESAppLoad,:RESAppStartNum))
	..i SQLCODE'=0 w "失败:"_RESRowId_","_1,!
	..e  w "成功:"_RESRowId_","_1,!
	..&sql(insert into SQLUser.DHC_RBResourceTR (REST_Resource_DR,REST_TimeRange_DR,REST_Load,REST_AppLoad,REST_AppStartNum) values (:RESRowId,2,:RESLoadXW,:RESAppLoad,:RESAppStartNum))
	..i SQLCODE'=0 w RESRowId_","_2,!
	..e  w "成功:"_RESRowId_","_2,!
}

/// w ##class(web.DHCRBApptSchedule).SendScheduleService("2588||27")
ClassMethod SendScheduleService(ScheduleID As %String)
{
	s RBRowId=+ScheduleID
	s ASChildSub=$p(ScheduleID,"||",2)
	s status=$P($G(^RBAS(RBRowId,ASChildSub,"DHC")),"^",10)
	i status'="" s status=$P(^DHCRBCASStatus(status),"^",1)
	///状态不正常的不推送
	Q:(status="TR")!(status="S")!(status="PS")!(status="F") ""
	///过了资源截止日期不推送
	s DateTo=$p(^RB("RES",RBRowId),"^",19)
  	if (DateTo'="")&&(DateTo<(+$h)){
		Q ""	
	}
	///判断就诊日期,7天以后排班不推送
	s AdmDate=$P($G(^RBAS(RBRowId,ASChildSub)),"^",1)
	quit:(AdmDate-(+$h)>7) ""
	s rtn=##class(web.DHCENS.EnsHISService).DHCHisInterface("S00000003",ScheduleID)
	q rtn
}

/// w ##class(web.DHCRBApptSchedule).SendStopScheduleService("2588||27")
ClassMethod SendStopScheduleService(ScheduleID As %String)
{
	s RBRowId=+ScheduleID
	s ASChildSub=$p(ScheduleID,"||",2)
	s status=$P($G(^RBAS(RBRowId,ASChildSub,"DHC")),"^",10)
	i status'="" s status=$P(^DHCRBCASStatus(status),"^",1)
	///过了资源截止日期不推送
	s DateTo=$p(^RB("RES",RBRowId),"^",19)
  	if (DateTo'="")&&(DateTo<(+$h)){
		//Q ""	
	}
	///判断就诊日期,7天以后排班不推送
	s AdmDate=$P($G(^RBAS(RBRowId,ASChildSub)),"^",1)
	quit:(AdmDate-(+$h)>7) ""
	s rtn=##class(web.DHCENS.EnsHISService).DHCHisInterface("STOPAPPTSCHEDULEINFO",ScheduleID)
	q rtn
}

/// w ##class(web.DHCRBApptSchedule).SendScheduleService("2588||27")
/// 用于晚上10:00推送排班限制
ClassMethod SendScheduleServiceNew(ScheduleID As %String)
{
	n (ScheduleID)
	s rtn=""
	s RBRowId=+ScheduleID
	s ASChildSub=$p(ScheduleID,"||",2)
	s status=$P($G(^RBAS(RBRowId,ASChildSub,"DHC")),"^",10)
	i status'="" s status=$P(^DHCRBCASStatus(status),"^",1)
	Q:(status="TR")!(status="S")!(status="PS")!(status="F") ""
	///过了资源截止日期不推送
	s DateTo=$p(^RB("RES",RBRowId),"^",19)
  	if (DateTo'="")&&(DateTo<(+$h)){
		Q ""	
	}
	//s LocRowid=$p(^RB("RES",RBRowId),"^",1)
	//Quit:##class(web.DHCRBApptSchedule).GetExaBorFlag(LocRowid)=0 ""
	///判断就诊日期,8天以后排班不推送
	s AdmDate=$P($G(^RBAS(RBRowId,ASChildSub)),"^",1)
	quit:+$h>=AdmDate ""
	quit:(AdmDate-(+$h)>8) ""
	//w ScheduleID_"  "_$zd(AdmDate,3),!
	s rtn=##class(web.DHCENS.EnsHISService).DHCHisInterface("S00000003",ScheduleID)
	q 1
	q rtn
}

/// 查询科室资源截止的医生的排班是否停诊,然后推送第三方停诊信息
/// d ##class(web.DHCRBApptSchedule).SendResourceDateTo()
ClassMethod SendResourceDateTo()
{
	s i=0
	s RBRowId="" f  s RBRowId=$o(^RB("RES",RBRowId)) q:RBRowId=""  d
	.s DateTo=$p(^RB("RES",RBRowId),"^",19)
  	.Quit:'((DateTo'="")&&(DateTo<(+$h)))
	.s AdmDate=..%SysDate()-1
	.for  s AdmDate=$o(^RBAS(RBRowId,0,"DateSTime",AdmDate)) Quit:AdmDate=""  do
	..s DateSTime="" f  s DateSTime=$o(^RBAS(RBRowId,0,"DateSTime",AdmDate,DateSTime)) q:DateSTime=""  d
    ...s ASChildSub="" f  s ASChildSub=$o(^RBAS(RBRowId,0,"DateSTime",AdmDate,DateSTime,ASChildSub)) q:ASChildSub=""  d
    ....s DateSTime1=..%ZT(DateSTime)
    ....s rowid=RBRowId_"||"_ASChildSub
    ....s LocRowid=$p(^RB("RES",RBRowId),"^",1)
    ....s status=$P($G(^RBAS(RBRowId,ASChildSub,"DHC")),"^",10)
	....i status'="" s status=$P(^DHCRBCASStatus(status),"^",1)
	....Q:((status="TR")!(status="S")!(status="PS")!(status="F"))
	....//s rtn= ..StopOneSchedule(rowid,"",1)
    ....w rowid_"  "_$zd(AdmDate,3)_status,!
}

/// do ##class(web.DHCRBApptSchedule).SendSchedule(+$h+8)
ClassMethod SendSchedule(AdmDate)
{
	s i=0
	if AdmDate="" s AdmDate=..%SysDate()
	s RBRowId="" f  s RBRowId=$o(^RBAS(RBRowId)) q:RBRowId=""  d
	.s DateSTime="" f  s DateSTime=$o(^RBAS(RBRowId,0,"DateSTime",AdmDate,DateSTime)) q:DateSTime=""  d
    ..s ASChildSub="" f  s ASChildSub=$o(^RBAS(RBRowId,0,"DateSTime",AdmDate,DateSTime,ASChildSub)) q:ASChildSub=""  d
    ...s DateSTime1=..%ZT(DateSTime)
    ...s rowid=RBRowId_"||"_ASChildSub
    ...s ret=##class(web.DHCRBApptSchedule).SendScheduleServiceNew(rowid)
    ...if ret'=""  s i=i+1
    ...w rowid_"  "_$zd(AdmDate,4)_"  "_i,!
    w i
}

/// d ##class(web.DHCOPAdmReg).GetTodaySchedule("")
/// 用于自助机推送挂号当天的排班。
ClassMethod GetTodaySchedule(AdmDate As %String = "")
{
	s i=0
	if AdmDate="" s AdmDate=..%SysDate()
	s RBRowId="" f  s RBRowId=$o(^RBAS(RBRowId)) q:RBRowId=""  d
	.s DateSTime="" f  s DateSTime=$o(^RBAS(RBRowId,0,"DateSTime",AdmDate,DateSTime)) q:DateSTime=""  d
    ..s ASChildSub="" f  s ASChildSub=$o(^RBAS(RBRowId,0,"DateSTime",AdmDate,DateSTime,ASChildSub)) q:ASChildSub=""  d
    ...s DateSTime1=..%ZT(DateSTime)
    ...s rowid=RBRowId_"||"_ASChildSub
    ...s LocRowid=$p(^RB("RES",RBRowId),"^",1)
    ...w ##class(web.DHCRBApptSchedule).SendScheduleService(rowid),!
}

/// 得到已预约数
ClassMethod GetAppedSeqNoCount(RBASId As %String) As %String
{
	n (RBASId)
	s AppedCount=0
	s ResRowId=$P(RBASId,"||",1)
	s Childsub=$P(RBASId,"||",2)
	s ASNoLimitLoadFlag=..GetASNoLimitLoadFlag(RBASId)
	if ASNoLimitLoadFlag="Y"{
		s ret=..GetRegisterNum(RBASId)	
		s AppedCount=$p(ret,"^",2)
	}else{
		s ASQueueNo=$P(^RBAS(ResRowId,Childsub,"DHC"),"^",4)
		;正号串与加号串
		s NormalQueueNoStr=$P(ASQueueNo,$C(1),1)
		s AddQueueNoStr=$P(ASQueueNo,$C(1),2)
		for i=1:1:$l(NormalQueueNoStr,",") {
		 	s SingleQueueNoStr=$P(NormalQueueNoStr,",",i)
		 	s QueueNoStatus=$P(SingleQueueNoStr,":",2)
		 	i (QueueNoStatus=2)!(QueueNoStatus=3){
			 	s AppedCount=AppedCount+1
			}
		}
	}
   	Q AppedCount
}

/// 得到已挂号数
ClassMethod GetRegSeqNoCount(RBASId As %String) As %String
{
	n (RBASId)
	s AppedCount=0
	s ResRowId=$P(RBASId,"||",1)
	s Childsub=$P(RBASId,"||",2)
	s ASNoLimitLoadFlag=..GetASNoLimitLoadFlag(RBASId)
	if ASNoLimitLoadFlag="Y"{
		s ret=..GetRegisterNum(RBASId)	
		s AppedCount=$p(ret,"^",2)
	}else{
		s ASQueueNo=$P(^RBAS(ResRowId,Childsub,"DHC"),"^",4)
		;正号串与加号串
		s NormalQueueNoStr=$P(ASQueueNo,$C(1),1)
		s AddQueueNoStr=$P(ASQueueNo,$C(1),2)
		for i=1:1:$l(NormalQueueNoStr,",") {
		 	s SingleQueueNoStr=$P(NormalQueueNoStr,",",i)
		 	s QueueNoStatus=$P(SingleQueueNoStr,":",2)
		 	i (QueueNoStatus=1){
			 	s AppedCount=AppedCount+1
			}
		}
	}
	Q AppedCount
}

ClassMethod GetASRegInfo(RBASId As %String) As %String
{
	s AppedCount=..GetAppedSeqNoCount(RBASId)	
	s RegCount=..GetRegSeqNoCount(RBASId)	
	s ASNoLimitLoadFlag=..GetASNoLimitLoadFlag(RBASId)
	s:ASNoLimitLoadFlag'="Y" ASNoLimitLoadFlag="N"
	Q RegCount_"^"_AppedCount_"^"_ASNoLimitLoadFlag
}

// w ##class(web.DHCRBApptSchedule).AddRBApptScheduleStatusLog()

ClassMethod AddRBApptScheduleStatusLog(ScheduleID As %String, statusCode As %String, UserID As %String = "", Remark As %String = "") As %String
{
	 &SQL(Select ASS_Rowid into :ASStatusDR from SQLUser.DHC_RBCASStatus Where ASS_Code=:statusCode)
	 if UserID="" s UserID=%session.Get("LOGON.USERID")
	 s object = ##class(User.DHCRBApptScheduleStatusChangeLog).%New()
	 s object.ASSLRBASDR=ScheduleID
	 s object.ASSLUpdateDate=..%SysDate()
	 s object.ASSLUpdateTime=..%SysTime()
	 s object.ASSLUpdateUser=UserID
	 Do object.ASSLStatusDRSetObjectId(ASStatusDR)
	 s object.ASSLRemark=Remark
	 Set sc = object.%Save()
	 If $$$ISERR(sc) {
			;Do $System.Status.DisplayError()
			Trollback
			Quit 100
		}

	 do object.%Close()
	 Q 0
}

// w ##class(web.DHCRBApptSchedule).GetRBApptScheduleStatus()

ClassMethod GetRBApptScheduleStatus(ScheduleID As %String) As %String
{
	s Status="N"
	q:ScheduleID="" Status

	s rowid="" f {
		s rowid=$o(^DHCASSLOGi("APPTSCHEDULE",ScheduleID,rowid),-1)
		q:rowid=""
		s StatusDR=$p(^DHCASSLOG(rowid),"^",2)
		s Status=$p(^DHCRBCASStatus(StatusDR),"^",1)
		q:(Status'="S")&&(Status'="TR")
	}
	q:rowid="" "N"
	if Status="AUD" {
		s rowid=$o(^DHCASSLOGi("APPTSCHEDULE",ScheduleID,rowid))
		q:rowid="" Status
		s StatusDR=$p(^DHCASSLOG(rowid),"^",2)
		s Status=$p(^DHCRBCASStatus(StatusDR),"^",1)
	}
	q Status
}

ClassMethod UpdateScheduleAuditFlag(ASRowid, Type, UserID)
{
	n (ASRowid,Type,UserID)
	s ret=0
	Set object = ##class(User.DHCRBApptSchedule).%OpenId(ASRowid)
	;排班待审核标记
	s ASAuditFlag="N"
	s object.ASAuditFlag=ASAuditFlag
	S ASStatus="N"
	if Type="N" S ASStatus="A"
	if Type="NS" S ASStatus="N"
	&SQL(Select ASS_Rowid into :ASStatusDR from SQLUser.DHC_RBCASStatus Where ASS_Code=:ASStatus)
	Do object.ASStatusDRSetObjectId(ASStatusDR)
	Set sc = object.%Save()
	If $$$ISERR(sc) {
		s ret="更新失败"
	}
	;状态改变日志
	s ret=##class(web.DHCRBApptSchedule).AddRBApptScheduleStatusLog(ASRowid,ASStatus,UserID)
	If ret'=0 {
		//Trollback
		//Quit 100
	}
	q ret
}

/// w ##class(web.DHCRBApptSchedule).CopyScheduleNew("1350||3^1350||6","18/04/2020","","","1^1")
ClassMethod CopyScheduleNew(CopyFromRBASIdStr As %String, CopyToDateStr As %String, CopyToDocDr As %String, CopyToTimeRangeDr As %String, ExpStr As %String) As %String
{
	s ^tempscl("CopyScheduleNew")=CopyFromRBASIdStr_","_CopyToDateStr_","_CopyToDocDr_","_CopyToTimeRangeDr_","_ExpStr
	s ErrCode=0,ASRowidStr="",ASAuditFlagStr=""
	//Set CopyToDate=..%ZDH(CopyToDate)
	for index=1:1:$l(CopyFromRBASIdStr,"^") {
		s FromScheduleID=$p(CopyFromRBASIdStr,"^",index)
		for m=1:1:$l(CopyToDateStr,","){
			s CopyToDate=$p(CopyToDateStr,",",m)
			s CopyToDate=..%ZDH(CopyToDate)
			s rtn=..CopyOneScheduleNew(FromScheduleID,CopyToDate,CopyToDocDr,CopyToTimeRangeDr,ExpStr)
			s ErrCode=$p(rtn,"^",1)
			if (ErrCode=0){
				s ASRowid=$p(rtn,"^",2)
				s ASAuditFlag=$p(rtn,"^",2)
				if ASRowidStr="" {
					s ASRowidStr=ASRowid
					s ASAuditFlagStr=ASAuditFlag
				}else{
					s ASRowidStr=ASRowidStr_$C(1)_ASRowid
					s ASAuditFlagStr=ASAuditFlagStr_$C(1)_ASAuditFlag
				}
			}else{
				s ErrCode=$p(rtn,"^",2)
				Q
			}
		}
	}
	q ErrCode_"^"_ASRowidStr_"^"_ASAuditFlagStr
}

/// 排班复制
/// 目前复制出诊记录、移动出诊记录界面都有使用该方法
ClassMethod CopyOneScheduleNew(FromScheduleID As %String, CopyToDate As %Date, CopyToDocDr As %String, CopyToTimeRangeDr As %String, ExpStr As %String, ControlExpStr As %String = "") As %String
{
	s TimeRangeRowId3=$P($G(^RBAS(+FromScheduleID,$P(FromScheduleID,"||",2),"DHC")),"^",17)
	s ASStatusDR3=$p($g(^RBAS(+FromScheduleID,$P(FromScheduleID,"||",2),"DHC")),"^",10)
	s ScheduleTime3=$P($G(^RBAS(+FromScheduleID,$P(FromScheduleID,"||",2))),"^",4)
	s ScheduleDate3=$P($G(^RBAS(+FromScheduleID,$P(FromScheduleID,"||",2))),"^",1)
	s ScheduleLocDr3=$p(^RB("RES",+FromScheduleID),"^",1)
	if (CopyToDocDr'=""){
		s ResRowID3=$o(^RB("RES",0,"CTPCP",CopyToDocDr,ScheduleLocDr3,""))
		Q:ResRowID3="" "-1^该医生未添加到复制科室!"
	}else{
		s ResRowID3=+FromScheduleID
		s CopyToTimeRangeDr=TimeRangeRowId3
	}
	/*s AvailRA3=..GetAvailRANew(ResRowID3,CopyToDate,"",CopyToTimeRangeDr)
	Q:AvailRA3'="" "-3^同一时段同一个医生只能有一个排班!"*/
	s DateFrom=$p(^RB("RES",ResRowID3),"^",22)
	s DateTo=$p(^RB("RES",ResRowID3),"^",23)
	if ((DateFrom'="")&&(CopyToDate<DateFrom))!((DateTo'="")&&(CopyToDate>DateTo)) {
		s ResDesc=$p(^RB("RES",ResRowID3),"^",17)
		s:DateFrom'="" DateFrom=$zd(DateFrom,3)
		s:DateTo'="" DateTo=$zd(DateTo,3)
		Q "-3^复制时间不在 【"_ResDesc_"】 的有效时间("_DateFrom_"至"_DateTo_")内"
	}
	s TRSessStartTime=$P($G(^DHCTimeRange(CopyToTimeRangeDr)),"^",3)
	set ret=##class(web.DHCRBResourceRule).CheckSchedule(ResRowID3,CopyToDate,"", TRSessStartTime,"")
	if ret'=0 {
		Q "-3^同一时段同一个医生只能有一个排班!"
	}
	s GroupID=$p(ExpStr,"^",1)
	s UserID=$p(ExpStr,"^",2)
	s NeedCopyRoom=$p(ControlExpStr,"^",1)		//是否拷贝诊室
	s NeedCopyStatus=$p(ControlExpStr,"^",2)	//是否拷贝状态
	TStart
	s ASDateCreate=..%SysDate()
	s ASTimeCreate=..%SysTime()
	//Trakcare排班记录表User.RBApptSchedule
	set Oldschedule3=##class(User.RBApptSchedule).%OpenId(FromScheduleID)
	set NewSchedule3=##class(User.RBApptSchedule).%New(ResRowID3)
	do NewSchedule3.ASRESParRefSetObjectId(ResRowID3)
	set NewSchedule3.ASDate=CopyToDate
	if (TimeRangeRowId3=CopyToTimeRangeDr){
		set NewSchedule3.ASSessStartTime=Oldschedule3.ASSessStartTime
		set NewSchedule3.ASSessEndTime=Oldschedule3.ASSessEndTime
	}else{
		set TRTimeStr=##class(web.DHCRBResSession).GetTRTimeStrByRowId(CopyToTimeRangeDr)
		set NewSchedule3.ASSessStartTime=..%ZTH($p(TRTimeStr,"^",1))
		set NewSchedule3.ASSessEndTime=..%ZTH($p(TRTimeStr,"^",2))
	}
	set NewASLoad=Oldschedule3.ASLoad
	set NewSchedule3.ASLoad=Oldschedule3.ASLoad
	set NewSchedule3.ASAvailability=Oldschedule3.ASAvailability
	set NewSchedule3.ASQueueNoCount=Oldschedule3.ASQueueNoCount
	;预约限额
	set NewSchedule3.ASNoApptSession=Oldschedule3.ASNoApptSession
	//set NewSchedule.ASRBEffDateSessionDR=Oldschedule.ASRBEffDateSessionDR
	set NewSchedule3.ASNumPatIn=Oldschedule3.ASNumPatIn
	set NewSchedule3.ASNumPatOut=Oldschedule3.ASNumPatOut
	set NewSchedule3.ASSession=Oldschedule3.ASSession
	s NewSchedule3.ASLastUpdateDate=ASDateCreate
	s NewSchedule3.ASLastUpdateTime=ASTimeCreate
	if (NeedCopyStatus="Y"){
		set NewSchedule3.ASIrregularFlag=Oldschedule3.ASIrregularFlag
	}
	Set sc = NewSchedule3.%Save()
	If $$$ISERR(sc) {
		Do $System.Status.DisplayError()
		Trollback
		Quit 100
	}
	
	do Oldschedule3.%Close()
	do NewSchedule3.%Close()
	set NewScheduleID3=NewSchedule3.%Id()
	Set ChildSub3=NewSchedule3.ASChildSub
	//Dhc排班记录扩展表User.DHCRBApptSchedule
	set Oldschedule3=##class(User.DHCRBApptSchedule).%OpenId(FromScheduleID)
	set NewSchedule3=##class(User.DHCRBApptSchedule).%OpenId(NewScheduleID3)
	Do NewSchedule3.ASRESParRefSetObjectId(ResRowID3)
	set NewSchedule3.ASChildsub=ChildSub3
	set NewSchedule3.ASDate=CopyToDate
	set NewSchedule3.ASNoOverbookAllowed=Oldschedule3.ASNoOverbookAllowed
	set NewASNoLimitLoadFlag=Oldschedule3.ASNoLimitLoadFlag
	set NewASQueueNo=##class(web.DHCRBResourceRule).GenerateQueueNO(NewASLoad,Oldschedule3.ASNoOverbookAllowed,NewASNoLimitLoadFlag)
	/*for k=1:1:NewASLoad  {
		i NewASQueueNo="" s NewASQueueNo=k_":"_0
		e  s NewASQueueNo=NewASQueueNo_","_k_":"_0
	}*/
	set NewSchedule3.ASQueueNo=NewASQueueNo //Oldschedule3.ASQueueNo
	if (NeedCopyRoom="Y"){
		set NewSchedule3.ASRoomDR=Oldschedule3.ASRoomDR
	}
	do NewSchedule3.ASSessionTypeDRSetObjectId(Oldschedule3.ASSessionTypeDR.%Id())
	if $IsObject(Oldschedule3.ASClinicGroupDR) do NewSchedule3.ASClinicGroupDRSetObjectId(Oldschedule3.ASClinicGroupDR.%Id())
	set NewSchedule3.ASClinicGroupDRStr=Oldschedule3.ASClinicGroupDRStr
	//注意如果没有分时段就诊的老库，可能需要去掉下面这一段
	s ASTimeRangeFlag=Oldschedule3.ASTimeRangeFlag
	if (ASTimeRangeFlag="Y"){
		s ASTRLength=Oldschedule3.ASTRLength
		s ASTRRegNum=Oldschedule3.ASTRRegNum
		if (TimeRangeRowId3'=CopyToTimeRangeDr){
			s ASTRStartTime=..%ZTH($p(TRTimeStr,"^",1))
			s ASTREndTime=..%ZTH($p(TRTimeStr,"^",2))
			s rtn=##class(web.DHCRBResSession).TRInfoCalculate($p(TRTimeStr,"^",1),$p(TRTimeStr,"^",2),ASTRLength,ASTRRegNum)
			if ($p(rtn,"^",1)=0){
				s ASTRRegNumStr=$p(rtn,"^",2)
				s ASTRRegInfoStr=$p(rtn,"^",3)
			}else{
				s ASTRStartTime=""
				s ASTREndTime=""
				s ASTRLength=""
				s ASTRRegNum=""
				s ASTRRegNumStr=""
				s ASTRRegInfoStr=""
				s ASTimeRangeFlag="N"
			}
		}else{
			s ASTRStartTime=Oldschedule3.ASTRStartTime
			s ASTREndTime=Oldschedule3.ASTREndTime
			
			s ASTRRegNumStr=Oldschedule3.ASTRRegNumStr
			s ASTRRegInfoStr=Oldschedule3.ASTRRegInfoStr
		}
		
	}else{
		s ASTRStartTime=""
		s ASTREndTime=""
		s ASTRLength=""
		s ASTRRegNum=""
		s ASTRRegNumStr=""
		s ASTRRegInfoStr=""
	}
	
	//分时段就诊
	set NewSchedule3.ASTimeRangeFlag=ASTimeRangeFlag
	set NewSchedule3.ASTRStartTime=ASTRStartTime
	set NewSchedule3.ASTREndTime=ASTREndTime
	set NewSchedule3.ASTRLength=ASTRLength
	set NewSchedule3.ASTRRegNum=ASTRRegNum
	set NewSchedule3.ASTRRegNumStr=ASTRRegNumStr
	set NewSchedule3.ASTRRegInfoStr=ASTRRegInfoStr
	//注意如果没有分时段就诊的老库，可能需要去掉上面这一段
	
	Do NewSchedule3.ASTimeRangeDRSetObjectId(CopyToTimeRangeDr)
	set NewSchedule3.ASDateCreate=$piece($h,",",1)
	set NewSchedule3.ASTimeCreate=$piece($h,",",2)
	set NewSchedule3.ASASDR=Oldschedule3.%Id()  //作为指向标志是说明由这条排班生成的
	set NewSchedule3.ASDateCreate=ASDateCreate
	set NewSchedule3.ASTimeCreate=ASTimeCreate
	set NewSchedule3.ASNoLimitLoadFlag=NewASNoLimitLoadFlag
	;排班待审核标记
	s ASAuditFlag=""
	s InStatusCode="A"
	if (+(##class(web.DHCRBApptScheduleAudi).GetRBASRequestFlag("N",ResRowID3,GroupID))=1){
		s ASAuditFlag="Y"
		s InStatusCode="AUD" ;待审核
	}
	&SQL(Select ASS_Rowid into :ASStatusDR from SQLUser.DHC_RBCASStatus Where ASS_Code=:InStatusCode)
	if (NeedCopyStatus="Y"){
		s ASAuditFlag=Oldschedule3.ASAuditFlag
		Do NewSchedule3.ASStatusDRSetObjectId(ASStatusDR3)
		s NewSchedule3.ASAuditFlag=ASAuditFlag
		if ($ISOBJECT(Oldschedule3.ASUserAuthoriseDR))&&(Oldschedule3.ASUserAuthoriseDR.%Id()'=""){
			Do NewSchedule3.ASUserAuthoriseDRSetObjectId(Oldschedule3.ASUserAuthoriseDR.%Id())
		}
		if ($ISOBJECT(Oldschedule3.ASReasonNotAvailDR))&&(Oldschedule3.ASReasonNotAvailDR.%Id()'=""){
			Do NewSchedule3.ASReasonNotAvailDRSetObjectId(Oldschedule3.ASReasonNotAvailDR.%Id())
		}
		set NewSchedule3.ASStopRegFlag=Oldschedule3.ASStopRegFlag
		set NewSchedule3.ASStopRegNoFlag=Oldschedule3.ASStopRegNoFlag


		s RequestID=$o(^User.DHCRBApptScheduleRequestI("RBASIDIndex",FromScheduleID,""),-1)
		if (RequestID'="")&&(ASAuditFlag'="Y"){
			k RequestPLIST
			&sql(select * into RequestPLIST() from SQLUser.DHCRBApptScheduleRequest where ID=:RequestID)
			k RequestPLIST(0),RequestPLIST(1),RequestPLIST(2)
			s RequestPLIST(16)=NewScheduleID3
			&sql( INSERT INTO SQLUser.DHCRBApptScheduleRequest VALUES :RequestPLIST())
		}
		
	}else{
		Do NewSchedule3.ASStatusDRSetObjectId(ASStatusDR)
		s NewSchedule3.ASAuditFlag=ASAuditFlag
	}
		
	
	Set sc = NewSchedule3.%Save()
	If $$$ISERR(sc) {
		Do $System.Status.DisplayError()
		Trollback
		Quit 100
	}
	if ASAuditFlag="Y"{
		s InfoStr="N"_"^"_""_"^"_"^"_"^"_"^"
		s ret=..RBASRequest(NewScheduleID3,InfoStr,UserID)
		if ret'="0"{
			Trollback
			Quit 101	
		}	
	}
	s GetTempAppStr=..GetASAppMethod(FromScheduleID)
	s ret=##class(DHCDoc.OPAdm.Schedule).UpdateAppMethodQtyNew(NewScheduleID3,GetTempAppStr,"")
	If ret'=0 {
		Trollback
		Quit 100
	}
	//如果复制到的时段和复制时段相同,复制分时段信息
	if (CopyToTimeRangeDr=TimeRangeRowId3){
		s SessTempList=..GetASTRInfoNew(FromScheduleID)
		s ret=##class(DHCDoc.OPAdm.Schedule).UpdateTRInfoNew(NewScheduleID3,SessTempList)
		If ret'=0 {
			Trollback
			Quit 100
		}
	}
	//复制排班记录扩展信息
	s ret=..SaveRBASExtendConfig(FromScheduleID,NewScheduleID3)
	If ret'=0 {
		Trollback
		Quit 100
	}
	;状态改变日志
	s NewASStatus=$p($g(^RBAS(+NewScheduleID3,$P(NewScheduleID3,"||",2),"DHC")),"^",10)
	s:NewASStatus'="" NewASStatus=$p(^DHCRBCASStatus(NewASStatus),"^",1)
	s ret=##class(web.DHCRBApptSchedule).AddRBApptScheduleStatusLog(NewScheduleID3,NewASStatus)
	If ret'=0 {
		Trollback
		Quit 100
	}
	;医生站业务数据修改日志
	set NewDataJson=##class(web.DHCDocDataChangeLog).GetLogJsonData("User.RBApptSchedule"_$c(2)_NewScheduleID3_"^"_"User.DHCRBApptSchedule"_$c(2)_NewScheduleID3)
	set ret=##class(web.DHCDocDataChangeLog).SaveLog("RB_ApptSchedule#DHC_RBApptSchedule","User.RBApptSchedule#User.DHCRBApptSchedule","排班信息","User.RBApptSchedule#User.DHCRBApptSchedule_"_NewScheduleID3,$p($g(^RB("RES",+NewScheduleID3)),"^",17),"A",NewDataJson,"")
	If ret'=0 {
		Trollback
		Quit 100
	}
	//自动插入实名制医生号别对照
	d ##class(DHCDoc.DHCDocConfig.CommonFunction).AutoInsertMarkDoc(ResRowID3)
	//自动插入分诊区号别对照号别对照
	d ##class(DHCDoc.DHCDocConfig.CommonFunction).AutoInsertDepMark(ResRowID3)
	Tcommit
	d ##class(DHCExternalService.RegInterface.SynVisitSchedule).SynOneSchedule(NewScheduleID3)  //同步到号源平台
	Quit 0_"^"_NewScheduleID3_"^"_ASAuditFlag
}

/// 得到可用的排班记录RowId 串
ClassMethod GetAvailRANew(ResRowId As %String, AdmDate As %Date, AdmTime As %Time, TimeRangeRowId As %String) As %String
{
	s ASRowIdStr="",ASRowId=""
    n TRRowId
	if $L(AdmDate,"/")=3 s AdmDate=$ZDH(AdmDate,4)
	if $L(AdmDate,"-")=3 s AdmDate=$ZDH(AdmDate,3)
	;先按照时段查看，如果时段为空就诊日期为当日按照。则查询当下所有时段。
	;如果不包含的话按照时段包含取应该显示的排班
	if (AdmDate=..%SysDate())  d
	.if TimeRangeRowId=""  d
	..s TimeRangeRowId=..GetTimeRangeStrByRange(TimeRangeRowId)	
	..//s TimeRangeRowId=##class(web.DHCRBResSession).GetTimeRangeByTime(..%SysTime())
	s NowTime=..%SysTime()
	s ASSessStartTime="" f  s ASSessStartTime=$O(^RBAS(ResRowId,0,"DateSTime",AdmDate,ASSessStartTime)) q:(ASSessStartTime="")  d
	.s ASChildSub=0  f  s ASChildSub=$O(^RBAS(ResRowId,0,"DateSTime",AdmDate,ASSessStartTime,ASChildSub)) q:(ASChildSub="")  d
	..s StartTime=ASSessStartTime
	..s EndTime=$P($G(^RBAS(ResRowId,ASChildSub)),"^",5)
	..s TRRowId=$P($G(^RBAS(ResRowId,ASChildSub,"DHC")),"^",17) //dhcrbapptschedul User.DHCTimeRange
	..i TRRowId="" d
	...s TRRowId=##class(web.DHCRBResSession).GetTimeRangeByTime(StartTime)
	..s RESEPMarkFlag=##class(web.DHCRBResource).GetEPMarkFlag(ResRowId)
	..Q:(RESEPMarkFlag'=1)&(TimeRangeRowId'="")&(TRRowId'="")&(("!"_TimeRangeRowId_"!")'[("!"_TRRowId_"!"))
	..s status=$P($G(^RBAS(ResRowId,ASChildSub,"DHC")),"^",10)
	..i status'="" s status=$P(^DHCRBCASStatus(status),"^",1)
	..;过滤停诊和替诊、待审核
	..Q:(status="TR")||(status="PS")||(status="S")||(status="AUD")
	..s ASIrregularFlag=$p($g(^RBAS(ResRowId,ASChildSub)),"^",13)
	..;默认是不找不规则出诊记录的
	..Q:(ASIrregularFlag="A")
	..s ASRowId=ResRowId_"||"_ASChildSub
	..i ASRowIdStr="" s ASRowIdStr=ASRowId
	..e  s ASRowIdStr=ASRowIdStr_"^"_ASRowId
	Q ASRowIdStr
}

ClassMethod ChkRegTimeRangeIsContain(TRRowId As %String, HospId As %String) As %String
{
	s CurTime=..%SysTime()
	s TRRegStartTime=$P($G(^DHCTimeRange(TRRowId)),"^",9) //挂号开始时间
	s TRRegEndTime=$P($G(^DHCTimeRange(TRRowId)),"^",10)
	if (TRRegStartTime="")&&(TRRegStartTime="") {
		s TRRegStartTime=$P($G(^DHCTimeRange(TRRowId)),"^",3) //出诊开始时间
		s TRRegEndTime=$P($G(^DHCTimeRange(TRRowId)),"^",4)
	}
	s TimeRangeInclude=##class(web.DHCOPRegConfig).GetSpecConfigNodeHosp("TimeRangeInclude",HospId)
	if (TimeRangeInclude=2){
		Q:(TRRegStartTime="")&&(TRRegEndTime="") 1
		Q:(TRRegStartTime'="")&&(TRRegEndTime'="")&&(TRRegStartTime<=CurTime)&&(TRRegEndTime>=CurTime) 1
		Q:(TRRegStartTime'="")&&(TRRegEndTime'="")&&(TRRegStartTime>=CurTime) 1
		Q:(TRRegStartTime'="")&&(TRRegEndTime="")&&(TRRegStartTime<=CurTime) 1
		Q:(TRRegStartTime="")&&(TRRegEndTime'="")&&(TRRegEndTime>=CurTime) 1
	}else{
		Q:(TRRegStartTime="")&&(TRRegEndTime="") 1
		Q:(TRRegStartTime'="")&&(TRRegEndTime'="")&&(TRRegStartTime<=CurTime)&&(TRRegEndTime>=CurTime) 1
		Q:(TRRegStartTime'="")&&(TRRegEndTime="")&&(TRRegStartTime<=CurTime) 1
		Q:(TRRegStartTime="")&&(TRRegEndTime'="")&&(TRRegEndTime>=CurTime) 1
	
	}
	Q 0
}

ClassMethod ChkTimeRangeIsContain(TRRowId As %String, HospId As %String) As %String
{
	s CurTime=..%SysTime()
	s TRStartTime=$P($G(^DHCTimeRange(TRRowId)),"^",3)
	s TREndTime=$P($G(^DHCTimeRange(TRRowId)),"^",4)
	s TimeRangeInclude=##class(web.DHCOPRegConfig).GetSpecConfigNodeHosp("TimeRangeInclude",HospId)
	if (TimeRangeInclude=2){
		Q:(TRStartTime="")&&(TREndTime="") 1
		Q:(TRStartTime'="")&&(TREndTime'="")&&(TRStartTime<=CurTime)&&(TREndTime>=CurTime) 1
		Q:(TRStartTime'="")&&(TREndTime'="")&&(TRStartTime>=CurTime) 1
		Q:(TRStartTime'="")&&(TREndTime="")&&(TRStartTime<=CurTime) 1
		Q:(TRStartTime="")&&(TREndTime'="")&&(TREndTime>=CurTime) 1
	}else{
		Q:(TRStartTime="")&&(TREndTime="") 1
		Q:(TRStartTime'="")&&(TREndTime'="")&&(TRStartTime<=CurTime)&&(TREndTime>=CurTime) 1
		Q:(TRStartTime'="")&&(TREndTime="")&&(TRStartTime<=CurTime) 1
		Q:(TRStartTime="")&&(TREndTime'="")&&(TREndTime>=CurTime) 1
	}
	
	Q 0
}

// 删除排班记录

ClassMethod DelectOneSchedule(ASRowID As %String)
{
	q:ASRowID="" ""
	s ASDesc=$p($g(^RB("RES",+ASRowID)),"^",17)
	set OldDataJson=##class(web.DHCDocDataChangeLog).GetLogJsonData("User.RBApptSchedule"_$c(2)_ASRowID_"^"_"User.DHCRBApptSchedule"_$c(2)_ASRowID)
	TS
	&sql(DELETE FROM SQLUser.RB_ApptSchedule WHERE AS_RowId=:ASRowID)
	i SQLCODE'=0 {
		Trollback
		Quit 1
	}
	/*&sql(DELETE FROM SQLUser.DHC_RBApptSchedule WHERE AS_Rowid=:ASRowID)
	b ;09323
	i SQLCODE'=0 {
		Trollback
		Quit 2
	}*/
	&sql(DELETE FROM SQLUser.DHC_RBApptScheduleUpdateLog WHERE ASUL_RBAS_DR=:ASRowID)
	i SQLCODE<0 {
		Trollback
		Quit 3
	}
	&sql(DELETE FROM SQLUser.DHC_RBApptScheduleStatusChangeLog WHERE ASSL_RBAS_DR=:ASRowID)
	i SQLCODE<0 {
		Trollback
		Quit 4
	}
	set ret=##class(web.DHCDocDataChangeLog).SaveLog("RB_ApptSchedule#DHC_RBApptSchedule","User.RBApptSchedule#User.DHCRBApptSchedule","排班信息","User.RBApptSchedule#User.DHCRBApptSchedule_"_ASRowID,ASDesc,"D","",OldDataJson)
	TC
	//同步排班接口
	s rtn=SQLCODE
	q rtn
}

ClassMethod SaveRBASExtendConfig(FromScheduleID As %String, NewScheduleID3 As %String) As %String
{
	s count=0
	s RowIDStr="", TypeIDStr="", ValueStr=""
	s ASQECChildsub=0
	for {
		s ASQECChildsub=$o(^RBAS(+FromScheduleID,$p(FromScheduleID,"||",2),"AQEC",ASQECChildsub)) Q:ASQECChildsub=""
		s TemplateConfigID=$P($g(^RBAS(+FromScheduleID,$p(FromScheduleID,"||",2),"AQEC",ASQECChildsub)),"^",1)
		s Value=$P(^RBAS(+FromScheduleID,$p(FromScheduleID,"||",2),"AQEC",ASQECChildsub),"^",2)
		if (count=0){
			s TypeIDStr=TemplateConfigID
		}else{
			s TypeIDStr=TypeIDStr_$C(1)_TemplateConfigID
		}
		if (count=0){
			s ValueStr=Value
		}else{
			s ValueStr=ValueStr_$C(1)_Value
		}
		s count=count+1
	}
	s rtn=##class(DHCDoc.OPAdm.ScheduleTemplateConfig).SaveASScheduleExtendConfig(NewScheduleID3, "", TypeIDStr, ValueStr)
	Q rtn
}

/// 判断是否可以生成不规则排班
ClassMethod CheckInsertOneIrrSchedule(LocID As %String, DocID As %String, SecheduleDate As %String = "", TimeRangeId As %String = "") As %String
{
	;s ^tmpgry("CheckInsertOneIrrSchedule")=LocID_","_DocID_","_SecheduleDate_","_TimeRangeId
	Q:(LocID="")||(DocID="") "没有找到出诊记录,或者从未排班"
	i SecheduleDate="" s SecheduleDate=$zd(+$H,4)
	e  s SecheduleDate=$zd(SecheduleDate,4)
	s HospID=$p($g(^CTLOC(LocID)),"^",22)
	if TimeRangeId="" {
		;使用封装方法获得
		s TRRowId=##class(web.DHCRBResSession).GetTimeRangeByTime("",HospID)
	}else{s TRRowId=TimeRangeId}
	s TimeRangeId=TRRowId
	b ; ddf
	Q:TRRowId="" "没有找到出诊记录,或者从未排班"
	s TotalNum=0 ;挂号数量
	s BookNum=0
	s OverBookNum=0
	s RoomID=""
	s TimeRangeInfoStr=""
	s SessionTypeID=""
	s ResRowId=$o(^RB("RES",0,"CTPCP",DocID,LocID,""))
	Q:ResRowId="" "没有找到出诊记录,或者从未排班"
	//从模板获取职称
	s ASWeek=$zd($zdh(SecheduleDate,4),10)
	i ASWeek=0 s ASWeek=7
	s RBResEffDateChildsub=$O(^RB("RES",ResRowId,"DATE",""),-1)
	i RBResEffDateChildsub'="" {
		b ;RBResEffDateChildsub
		/// zzz 20160816 循环时段串来检索
		for zi=1:1:$length(TimeRangeId,"^"){
			s TRRowId=$p(TimeRangeId,"^",zi)
			s SESSChildsub=0
			f  s SESSChildsub=$o(^RB("RES",ResRowId,"DATE",RBResEffDateChildsub,"SESS",SESSChildsub)) q:(SESSChildsub="")  d
			.S SessDOWRowid=$p(^RB("RES",ResRowId,"DATE",RBResEffDateChildsub,"SESS",SESSChildsub),"^",2)
			.S SessScheduleGenerFlag=$p(^RB("RES",ResRowId,"DATE",RBResEffDateChildsub,"SESS",SESSChildsub),"^",16)
			.Q:(SessScheduleGenerFlag="N")
			.Q:SessDOWRowid'=ASWeek
			.s SessionRangeID=$p(^RB("RES",ResRowId,"DATE",RBResEffDateChildsub,"SESS",SESSChildsub),"^",3)
			.//Q:TimeRangeId'=SessionRangeID
			.Q:TRRowId'=SessionRangeID
			.s SessionTypeID=$p(^RB("RES",ResRowId,"DATE",RBResEffDateChildsub,"SESS",SESSChildsub),"^",9)
			.s TimeRangeInfoStr=$g(^RB("RES",ResRowId,"DATE",RBResEffDateChildsub,"SESS",SESSChildsub,"DHC"))
		}
	}
	//如果排班模板上为空则找最近一次的排班记录
	i SessionTypeID="" {
		s ASDate=$O(^RBAS(ResRowId,0,"DateSTime",""),-1)
		i ASDate'="" s SessStartTime=$O(^RBAS(ResRowId,0,"DateSTime",ASDate,""),-1)
		i $g(SessStartTime)'="" s AsChildId=$O(^RBAS(ResRowId,0,"DateSTime",ASDate,SessStartTime,""),-1)
		i $g(AsChildId)'="" s SessionTypeID=$p($g(^RBAS(ResRowId,AsChildId,"DHC")),"^",6)
	}
	//从医生默认设置中获取出诊职称
	i SessionTypeID="" {
		s SessionTypeID=$p($g(^RB("RES",ResRowId,"DHC")),"^",1)
	}
	Q:SessionTypeID="" "没有找到出诊记录,或者从未排班"
	s ClinicGroupID=""
	s BookStartNum=""
	s SessStartTime=""
	s SessEndTime=""
	s StatusCode="N"
	s ASIrregularFlag="A"  ;不规则加诊标志
	s TimeRangeInfoStr=""
	set ResRowID=""
	set ResRowID=$Order(^RB("RES",0,"CTPCP",DocID,LocID,ResRowID))
	if (ResRowID=""){
		Quit "没有找到出诊记录,或者从未排班"
	}
	if BookNum="" s BookNum=0
	if SessStartTime'=""  s SessStartTime=..%ZTH(SessStartTime)
	else  s SessStartTime=$P(^DHCTimeRange(TRRowId),"^",3)
	if SessEndTime'=""  s SessEndTime=..%ZTH(SessEndTime)
	else  s SessEndTime=$P(^DHCTimeRange(TRRowId),"^",4)
    s DHCRBTRRowId=TRRowId   //因为在CheckSchedule中将它赋空了
    s RepeatScheMsg=""
    for m=1:1:$l(SecheduleDate,"^"){
	    set oneScheduleDate=$p(SecheduleDate,"^",m)
	    continue:oneScheduleDate=""
	    s oneScheduleDate=..%ZDH(oneScheduleDate)
		set ret=##class(web.DHCRBResourceRule).CheckSchedule(ResRowID,oneScheduleDate,RoomID, SessStartTime,"")
		if ret'=0 {
			s retcode=$P(ret,"^",1)
			s DulASRowId=$P(ret,"^",2)
			if (DulASRowId'=""){
				s DulResRowId=$P(DulASRowId,"||",1)
				s DulResDocRowId=$p(^RB("RES",DulResRowId),"^",2)
				s DulResLocRowId=$p(^RB("RES",DulResRowId),"^",1)
				s DulResDocDesc=$p(^CTPCP(DulResDocRowId,1),"^",2)
				s DulResLocDesc=$p($g(^CTLOC(DulResLocRowId)),"^",2)
			}
			s Msg=retcode_"^"_DulResLocDesc_DulResDocDesc
			i RepeatScheMsg="" s RepeatScheMsg=Msg
			else  s RepeatScheMsg=RepeatScheMsg_" "_Msg
		}
	}
	Q:RepeatScheMsg'="" RepeatScheMsg
	Q 0
}

ClassMethod OPDocRegistInsertIrrSchedule(LocID, DocRowId, PatientID, BillType, RegConDisId, ASRowId, FeeStr)
{
	if (ASRowId=""){
		s NowDate=..%SysDate()
		s NowTime=..%SysTime()
		s TimeRangeRowId=##class(web.DHCRBResSession).GetTimeRangeByTime(NowTime)
		s Rtn=##class(web.DHCRBApptSchedule).InsertOneIrrSchedule(LocID,DocRowId,NowDate,TimeRangeRowId)
		s RtnFlag=$P(Rtn,"^",1)
		if RtnFlag=0 {
			s ASRowId=$P(Rtn,"^",2)
		}
	}
	s TotalFee="0"
	if (ASRowId'=""){
		if (BillType=""){
			set PatCatDr=$p(^PAPER(PatientID,"PER",1),"^",10)
			i PatCatDr'="" set DHCPACADMDr=$O(^DHCPACADM(0,"Social",PatCatDr,""))
			if $g(DHCPACADMDr)'="" set BillType=$p(^DHCPACADM(DHCPACADMDr),"^",2)
		}
		s DocResValue=##class(web.DHCOPAdmReg).GetMarkRegFee(ASRowId,BillType, PatientID,"",RegConDisId)
		s RegFee=$p(DocResValue,"^",12)
		s CheckFee=$p(DocResValue,"^",14)
		s HoliFee=$p(DocResValue,"^",16)
		s AppFee=$p(DocResValue,"^",18)
		s ReCheckFee=$p(DocResValue,"^",15)
		s OtherFee=$p(DocResValue,"^",20)
		s TRDesc=$p(DocResValue,"^",21)
		s ScheduleDate=$p(DocResValue,"^",28)
		s TotalFee=HoliFee+CheckFee+RegFee+AppFee+OtherFee
		if (FeeStr="0||0||0||0"){
			s TotalFee=RegFee
		}
		q "0^"_ASRowId_"^"_TotalFee_"^"_BillType
	} else {
		q "202^新增非规则出诊记录失败!"
	}
}

ClassMethod UpdateMulScheduleAddNum(InputStr)
{
	s ret=0
	s InputObj=[].%FromJSON(InputStr)
	TS
	for i=1:1:InputObj.%Size(){
		s ScheduleID=InputObj.%Get(i-1).ASRowId
		continue:ScheduleID=""
		s OverBookNum=InputObj.%Get(i-1).ASAddLoad
		s ret=..UpdateOneScheduleAddNum(ScheduleID,OverBookNum)
		Q:ret
	}
	s retObj={"code":(ret)}
	if ret{
		Tro
		s retObj.msg=$CASE(ret,-205:"加号限额不能小于已挂出数",:"修改失败:"_ret)
	}else{
		TC
		s retObj.msg="修改成功!"
	}
	Q retObj.%ToJSON()
}

/// 修改一条排班记录的加号限额
ClassMethod UpdateOneScheduleAddNum(ScheduleID As %String, OverBookNum As %String = "") As %String
{
	s ^tmp("UpdateOneScheduleAddNum")=$LB(ScheduleID,OverBookNum)
	s OldOverBookNum=$P($G(^RBAS(+ScheduleID,$P(ScheduleID,"||",2),"DHC")),"^",3)
	Q:+OldOverBookNum=+OverBookNum 0	;相同 直接返回
	;w ##class(web.DHCRBApptSchedule).UpdateOneScheduleAddNum("10||10","5")
	set OldDataJson=##class(web.DHCDocDataChangeLog).GetLogJsonData("User.RBApptSchedule"_$c(2)_ScheduleID_"^"_"User.DHCRBApptSchedule"_$c(2)_ScheduleID)
	set ResRowId=+ScheduleID
	set schedule=##class(User.RBApptSchedule).%OpenId(ScheduleID)
	set oldTotalNum=schedule.ASLoad
	set OldASIrregularFlag=schedule.ASIrregularFlag
	do schedule.%Close()
	
	i OverBookNum'="" s OverBookNum=+OverBookNum
	
	;加号最大值
	s AddCount=..GetNotAvailSeqNoCount(ScheduleID,"ADD")
	i AddCount>OverBookNum Q "-205"
	s Para=##class(web.DHCRBApptScheduleUpdateLog).GetOneRBApptSchedule(ScheduleID)
	TStart
	set schedule=##class(User.RBApptSchedule).%OpenId(ScheduleID)
	
	if (OldASIrregularFlag="A"){
		Set schedule.ASIrregularFlag="S"
	}	

	Set sc = schedule.%Save()
	If $$$ISERR(sc) {
		Do $System.Status.DisplayError()
		Trollback
		Quit 100
	}
	do schedule.%Close()
	
	set schedule=##class(User.DHCRBApptSchedule).%OpenId(ScheduleID)
	
	set oldOverBookNum=schedule.ASNoOverbookAllowed
	set oldQueueNo=schedule.ASQueueNo
	set oldNoLimitLoadFlag=schedule.ASNoLimitLoadFlag
	set schedule.ASNoOverbookAllowed=OverBookNum
	
	set schedule.ASQueueNo=##class(web.DHCRBResourceRule).EditQueueNO(oldQueueNo,oldTotalNum,oldTotalNum,oldOverBookNum,OverBookNum,ScheduleID,oldNoLimitLoadFlag)
	
	;set schedule.ASLockFlag=LockFlag
	Set sc = schedule.%Save()
	If $$$ISERR(sc) {
		Do $System.Status.DisplayError()
		Trollback
		Quit 100
	}
	;修改日志  guobaoping
	s ret=##class(web.DHCRBApptScheduleUpdateLog).AddRBApptScheduleLog("U",ScheduleID,Para)
	If ret'=0 {
		Trollback
		Quit 100
	}
	;医生站业务数据修改日志
	set NewDataJson=##class(web.DHCDocDataChangeLog).GetLogJsonData("User.RBApptSchedule"_$c(2)_ScheduleID_"^"_"User.DHCRBApptSchedule"_$c(2)_ScheduleID)
	set ret=##class(web.DHCDocDataChangeLog).SaveLog("RB_ApptSchedule#DHC_RBApptSchedule","User.RBApptSchedule#User.DHCRBApptSchedule","排班信息","User.RBApptSchedule#User.DHCRBApptSchedule_"_ScheduleID,$p($g(^RB("RES",+ScheduleID)),"^",17),"U",NewDataJson,OldDataJson)
	If ret'=0 {
		Trollback
		Quit 100
	}	
	Tcommit
	d ##class(DHCExternalService.RegInterface.SynVisitSchedule).SynRegCount(ScheduleID) ;SynStopVisitSchedule(ScheduleID)
	//调用平台组接口
	s rtn=##class(web.DHCENS.EnsHISService).DHCHisInterface("S00000003",ScheduleID)
	
	Quit 0
}

ClassMethod GetDocID(UserRowid As %String = "") As %String
{
	q:UserRowid="" ""
 	s CTPCPRowId=$P(^SSU("SSUSR",UserRowid),"^",14)
 	q CTPCPRowId
}

ClassMethod UpdateOneAdmRoomID(ScheduleID, RoomID)
{
	q:((ScheduleID="")||(RoomID="")) ""
	s RegfeeRowId=""
	for{
		s RegfeeRowId=$O(^User.DHCRegistrationFeeI("RBASDr",ScheduleID,RegfeeRowId))
		q:RegfeeRowId=""
		s Adm=$List(^User.DHCRegistrationFeeD(RegfeeRowId),2)
		continue:Adm=""
		s VisitStatus=$p($g(^PAADM(Adm)),"^",20)
		continue:VisitStatus'="A"
		&SQL(Update SQLUser.DHCRegistrationFee set RegfeeRoomDr=:RoomID where %Id=:RegfeeRowId)
		}
	q 0
}

ClassMethod GetASNoLimitLoadFlag(RBASId)
{
	n (RBASId)
	s ResRowId=+RBASId
	s Childsub=$p(RBASId,"||",2)
	s ASNoLimitLoadFlag=$P($g(^RBAS(ResRowId,Childsub,"DHC")),"^",31)
	if ASNoLimitLoadFlag'="Y" s ASNoLimitLoadFlag=""
	Q ASNoLimitLoadFlag
}

}
