Class web.DHCRBApptScheduleUpdateLog Extends DHCDoc.Util.RegisteredObject
{

/// Creator?      guobaoping
/// CreatDate?    2009-03-09
/// Description:? 删除字符串的左导空格
/// Table?        
/// Input?        String
/// Output?       String
/// Return?       
/// Others?
ClassMethod DelLBlack(String As %String)
{
	 s length=$l(String)
 s checkflag="",subStr=String
 f i=1:1:length  q:(checkflag'="")&&(checkflag'=" ")  d
 .s char=$e(String,i)
 .s checkflag=char
 .i (char=" ") d
 ..s subStr=$e(String,i+1,length)
 .e  q 
 q subStr
}

/// Creator?      guobaoping
/// CreatDate?    2009-03-06
/// Description:? 检查修改的排班记录内容
/// Table?        
/// Input?        两条病人信息字符串
/// Output?       检出的修改过的记录并建立日志记录
/// Return?       
/// Others?
ClassMethod CheckRBApptScheduleUpdate(OldPara As %String, NewPara As %String) As %String
{
  
 s UPNotes=""
 q:(OldPara="")!(NewPara="") 
 f i=1:1:$L(OldPara,"^")  d
 .s TempVal=$p(OldPara,"^",i)
 .s NewTempVal=$p(NewPara,"^",i)
 .i (TempVal'=NewTempVal)&&(i=1)  s UPNotes="科室由"_$p(TempVal,$c(1),2)_"改成了"_$p(NewTempVal,$c(1),2)_"; "
 .i (TempVal'=NewTempVal)&&(i=2)  s UPNotes=UPNotes_"医生由"_$p(TempVal,$c(1),2)_"改成了"_$p(NewTempVal,$c(1),2)_"; "
 .i (TempVal'=NewTempVal)&&(i=3)  s UPNotes=UPNotes_"出诊日期由"_TempVal_"改成了"_NewTempVal_"; "
 .i (TempVal'=NewTempVal)&&(i=4)  s UPNotes=UPNotes_"开始时间由"_TempVal_"改成了"_NewTempVal_"; "
 .i (TempVal'=NewTempVal)&&(i=5)  s UPNotes=UPNotes_"截止时间由"_TempVal_"改成了"_NewTempVal_"; "
 .i (TempVal'=NewTempVal)&&(i=6)  s UPNotes=UPNotes_"出诊时段由"_$p(TempVal,$c(1),2)_"改成了"_$p(NewTempVal,$c(1),2)_"; "
 .i (TempVal'=NewTempVal)&&(i=7)  s UPNotes=UPNotes_"挂号职称由"_$p(TempVal,$c(1),2)_"改成了"_$p(NewTempVal,$c(1),2)_"; "
 .i (TempVal'=NewTempVal)&&(i=8)  s UPNotes=UPNotes_"诊室由"_$p(TempVal,$c(1),2)_"改成了"_$p(NewTempVal,$c(1),2)_"; "
 .i (TempVal'=NewTempVal)&&(i=9)  s UPNotes=UPNotes_"预约限额由"_TempVal_"改成了"_NewTempVal_"; "
 .i (TempVal'=NewTempVal)&&(i=10)  s UPNotes=UPNotes_"正号限额由"_TempVal_"改成了"_NewTempVal_"; "
 .i (TempVal'=NewTempVal)&&(i=11)  s UPNotes=UPNotes_"预约起始号由"_TempVal_"改成了"_NewTempVal_"; "
 .i (TempVal'=NewTempVal)&&(i=12)  s UPNotes=UPNotes_"加号限额由"_TempVal_"改成了"_NewTempVal_"; "
 .i (TempVal'=NewTempVal)&&(i=16)  s UPNotes=UPNotes_"亚专业由"_$p(TempVal,$c(1),2)_"改成了"_$p(NewTempVal,$c(1),2)_"; "
 .i (TempVal'=NewTempVal)&&(i=17)  s UPNotes=UPNotes_"停正号由"_TempVal_"改成了"_NewTempVal_"; "
 q UPNotes
}

/// Creator?      guobaoping
/// CreatDate?    2009-03-06
/// Description:? 添加病人信息修改日志
/// Table?        SQLuser.DHCUPPERSON 病人信息修改日志表
/// Input?        修改信息
/// Output?       sqlcode
/// Return?       
/// Others?
ClassMethod AddRBApptScheduleLog(ASULType As %String, RBASRowid As %String, Para As %String = "")
{
 q:ASULType="" 0
 s ASLUPDate=..%SysDate()
 s ASLUPTime=..%SysTime()
 s UserID=%session.Get("LOGON.USERID")
 
 i ASULType="A"  d
 .;新增排班
 .s AddRBAInfo=..GetOneRBApptSchedule(RBASRowid)
 .s ASULNotes="新增一条出诊日期为:"_$p(AddRBAInfo,"^",3)_"的"_$p($p(AddRBAInfo,"^"),$c(1),2)_" "_$p($p(AddRBAInfo,"^",2),$c(1),2)_",挂号职称为:"_$p($p(AddRBAInfo,"^",7),$c(1),2)
 e  i ASULType="S"  d
 .;停止排班
 .s StopRBAInfo=..GetOneRBApptSchedule(RBASRowid)
 .s ASULNotes="停诊一条出诊日期为:"_$p(StopRBAInfo,"^",3)_"的"_$p($p(StopRBAInfo,"^"),$c(1),2)_" "_$p($p(StopRBAInfo,"^",2),$c(1),2)_",挂号职称为:"_$p($p(StopRBAInfo,"^",7),$c(1),2)
 e  i ASULType="PS"  d
 .;中途停止排班
 .s StopRBAInfo=..GetOneRBApptSchedule(RBASRowid)
 .s ASULNotes="中途停诊一条出诊日期为:"_$p(StopRBAInfo,"^",3)_"的"_$p($p(StopRBAInfo,"^"),$c(1),2)_" "_$p($p(StopRBAInfo,"^",2),$c(1),2)_",挂号职称为:"_$p($p(StopRBAInfo,"^",7),$c(1),2)
 e  i ASULType="R"  d
 .;替诊排班
 .s ASULNotes="替诊"
 .s NewRBASRowid=Para
 .s OldRBAInfo=..GetOneRBApptSchedule(RBASRowid)
 .s OldNotes=$p($p(OldRBAInfo,"^"),$c(1),2)_" "_$p($p(OldRBAInfo,"^",2),$c(1),2)_",挂号职称为:"_$p($p(OldRBAInfo,"^",7),$c(1),2)
 .s NewOldRBAInfo=..GetOneRBApptSchedule(NewRBASRowid)
 .s NewNotes=$p($p(NewOldRBAInfo,"^"),$c(1),2)_" "_$p($p(NewOldRBAInfo,"^",2),$c(1),2)_",挂号职称为:"_$p($p(NewOldRBAInfo,"^",7),$c(1),2)
 .s ASULNotes=OldNotes_"  被替诊为 "_NewNotes
 e  i ASULType="U"  d
 .;更新排班
 .s UPRBAInfo=..GetOneRBApptSchedule(RBASRowid)
 .s ASULNotes=..CheckRBApptScheduleUpdate(Para,UPRBAInfo)
 e  i ASULType="CS"  d
 .;撤销停诊
 .s StopRBAInfo=..GetOneRBApptSchedule(RBASRowid)
 .s ASULNotes="撤销停诊一条出诊日期为:"_$p(StopRBAInfo,"^",3)_"的"_$p($p(StopRBAInfo,"^"),$c(1),2)_" "_$p($p(StopRBAInfo,"^",2),$c(1),2)_",挂号职称为:"_$p($p(StopRBAInfo,"^",7),$c(1),2)
 
 q:ASULNotes="" 0
 s object = ##class(User.DHCRBApptScheduleUpdateLog).%New()
 s object.ASULRBASDR=RBASRowid
 s object.ASULUpdateDate=..%SysDate()
 s object.ASULUpdateTime=..%SysTime()
 s object.ASLUpdateUser=UserID
 s object.ASULType=ASULType
 s object.ASULNotes=ASULNotes
 Set sc = object.%Save()

 If $$$ISERR(sc) {
		;Do $System.Status.DisplayError()
		Trollback
		Quit 100
	}

 do object.%Close()
 Q 0
}

// w ##class(web.DHCRBApptScheduleUpdateLog).GetOneRBApptSchedule("3226||1")

/// Creator?      guobaoping
/// CreatDate?    2009-03-06
/// Description:? 添加病人信息修改日志
/// Table?        SQLuser.DHCUPPERSON 病人信息修改日志表
/// Input?        修改信息
/// Output?       sqlcode
/// Return?       
/// Others?
ClassMethod GetOneRBApptSchedule(ASRowID As %String)
{
 	s ^TMP("GetOneRBApptSchedule")=ASRowID
 	s ret=""
 	q:ASRowID="" ret
 	s ResRowId=$p(ASRowID,"||")
 	s ASChildSub=$p(ASRowID,"||",2)
 	q:'$d(^RBAS(ResRowId,ASChildSub)) ret
 	Set DepID=$p($g(^RB("RES",ResRowId)),"^",1)
 	i DepID'="" Set DepName=$p($g(^CTLOC(DepID)),"^",2)
 	set DepName1=$P(DepName,"-",2)
    if DepName1'="" set DepName=DepName1
    s DoctorName=""
 	Set DoctorID=$p($g(^RB("RES",ResRowId)),"^",2)
 	i DoctorID'="" Set DoctorName=$p($g(^CTPCP(DoctorID,1)),"^",2)
 	;出诊日期
	Set ASDate=$p(^RBAS(ResRowId,ASChildSub),"^",1)
	if ASDate'=""  s ASDate=..%ZD(ASDate) //$zd(ASDate,4)
 	;开始时间
	Set SessStartTime=$p(^RBAS(ResRowId,ASChildSub),"^",4)
	i SessStartTime'=""  s SessStartTime=..%ZT(SessStartTime)
	;结束时间
	Set SessEndTime=$p(^RBAS(ResRowId,ASChildSub),"^",5)
	i SessEndTime'=""  s SessEndTime=..%ZT(SessEndTime)
	;出诊时段
	s SessionTimeName=""
	set SessionTimeID=$P($G(^RBAS(ResRowId,ASChildSub,"DHC")),"^",17)
	if SessionTimeID'="" s SessionTimeName=$P($G(^DHCTimeRange(SessionTimeID)),"^",2)
	;出诊级别
	s SessionTypeDesc=""
	s SessionTypeDr=$P($G(^RBAS(ResRowId,ASChildSub,"DHC")),"^",6)
	i SessionTypeDr'="" s SessionTypeDesc=$P($G(^RBC("SESS",SessionTypeDr)),"^",2)
	;诊室
	s RoomName=""
 	Set RoomID=$p($G(^RBAS(ResRowId,ASChildSub,"DHC")),"^",5)
 	i RoomID'="" Set RoomName=$p($g(^CTLOC(RoomID)),"^",2)
	;出诊限额
	Set TotalNum=$p(^RBAS(ResRowId,ASChildSub),"^",8)
	Set BookNum=$p(^RBAS(ResRowId,ASChildSub),"^",2)
	Set OverBookNum=$P($G(^RBAS(ResRowId,ASChildSub,"DHC")),"^",3)
	Set BookStartNum=$p(^RBAS(ResRowId,ASChildSub),"^",10)
	;亚专业
	Set ClinicGroup=""
	Set ClinicGroupDR=$P($G(^RBAS(ResRowId,ASChildSub,"DHC")),"^",7)
	if ClinicGroupDR'=""  Set ClinicGroup=$p(^RBC("CLGRP",ClinicGroupDR),"^",2)
	s Status=""
	Set StatusDr=$P($G(^RBAS(ResRowId,ASChildSub,"DHC")),"^",10)
	i StatusDr'="" s Status=$P($G(^RBC("SESS",StatusDr)),"^",2)
	s TRDoc="",TRDepName=""
	s TRRBASRowId=$P($G(^RBAS(ResRowId,ASChildSub,"DHC")),"^",12)
	i (TRRBASRowId'="") d
	.i $d(^RB("RES",+TRRBASRowId)) d
	..s TRDepRowId= $P($G(^RB("RES",+TRRBASRowId)),"^",1)
	..s TRDocRowId= $P($G(^RB("RES",+TRRBASRowId)),"^",2)
	..i TRDepRowId'="" Set TRDepName=$p($g(^CTLOC(TRDepRowId)),"^",2)
 	..set TRDepName1=$P(TRDepName,"-",2)
    ..if TRDepName1'="" set TRDepName=TRDepName1
	..s TRDoc=$p($g(^CTPCP(TRDocRowId,1)),"^",2)
	
	s SessionClinicGroupDr=$P($G(^RBAS(ResRowId,ASChildSub,"DHC")),"^",7)
    i SessionClinicGroupDr'="" s SessionClinicGroupDesc=$P($G(^RBC("CLGRP",SessionClinicGroupDr)),"^",2)
    //预约机构预约限额 
    ///停正号
    Set StopRegNoFlag=$P($G(^RBAS(ResRowId,ASChildSub,"DHC")),"^",27)
	set ret=DepID_$c(1)_DepName_"^"_DoctorID_$c(1)_DoctorName_"^"_ASDate_"^"_SessStartTime_"^"_SessEndTime_"^"_SessionTimeID_$c(1)_SessionTimeName_"^"_SessionTypeDr_$c(1)_SessionTypeDesc_"^"_RoomID_$c(1)_RoomName_"^"_BookNum_"^"_TotalNum_"^"_BookStartNum_"^"_OverBookNum_"^"_StatusDr_$c(1)_Status_"^"_TRDepName_"^"_TRDoc_"^"_ClinicGroupDR_$c(1)_ClinicGroup_"^"_StopRegNoFlag
	q ret
}

Query QueryRBASULog(CTlocID As %String, CTPCPID As %String, StartDate As %Date, EndDate As %Date, SelRBASFlag As %String, vRBASID As %String = "", HospID = "") As %Query(ROWSPEC = "DepName:%String,DoctorName:%String,ASDate:%String,UpdateRBAS:%String,UpdateDateN:%String,UpdateTime:%String,UpdateUser:%String,UpdateType:%String,UpdateNotes:%String")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCRBApptScheduleUpdateLog","QueryRBASULog","","","23/02/2021","23/02/2021","on","",2)
ClassMethod QueryRBASULogExecute(ByRef qHandle As %Binary, CTlocID As %String, CTPCPID As %String, StartDate As %Date, EndDate As %Date, SelRBASFlag As %String, vRBASID As %String = "", HospID = "") As %Status
{
	s ^TMP("QueryRBASULog")=CTlocID_","_CTPCPID_","_StartDate_","_EndDate_","_SelRBASFlag_","_vRBASID
	s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	Set repid=$I(^CacheTemp)	
	If $g(ind)="" Set ind=1
	Set qHandle=$lb(0,repid,0)
	kill ^TMP("RBASULog",$j)
	i StartDate'="" s StartDate=..%ZDH(StartDate)
    i EndDate'="" s EndDate=..%ZDH(EndDate)
	if StartDate="" s StartDate=..%SysDate()
	if EndDate="" s EndDate=..%SysDate()
	if (CTlocID'="")||(CTPCPID'="")||(SelRBASFlag="on") s vRBASID=""
	if (vRBASID'="") {
		s ObjectReference="USER.RBAPPTSCHEDULE#USER.DHCRBAPPTSCHEDULE_"_vRBASID
		s id=0
		for {
			s id=$o(^User.DHCDocDataChangeLogI("ObjectReferenceIndex"," "_ObjectReference,id)) Q:id=""
			Do GetOutPutRow
		}
	}elseif CTlocID'="" {
		Quit:'$d(^RB("RES",0,"CTLOC",CTlocID))
		s ResRowId=""
		for {
			s ResRowId=$o(^RB("RES",0,"CTLOC",CTlocID,ResRowId))  Q:ResRowId=""
			continue:'$D(^RBAS(ResRowId,0,"DateSTime"))
			Set CTPId=$p($g(^RB("RES",ResRowId)),"^",2)
			continue:(CTPCPID'="")&&(CTPId'=CTPCPID)
			i SelRBASFlag="on" {
				for ScheduleDate=StartDate:1:EndDate  {
					s ASSessStartTime=0 
					for {
						s ASSessStartTime=$O(^RBAS(ResRowId,0,"DateSTime",ScheduleDate,ASSessStartTime)) Q:(ASSessStartTime="")
						s ASChildSub=0  
						for {
							s ASChildSub=$O(^RBAS(ResRowId,0,"DateSTime",ScheduleDate,ASSessStartTime,ASChildSub)) Q:(ASChildSub="")
							s RBASID=ResRowId_"||"_ASChildSub
							s ObjectReference="USER.RBAPPTSCHEDULE#USER.DHCRBAPPTSCHEDULE_"_RBASID
							s id=0
							for {
								s id=$o(^User.DHCDocDataChangeLogI("ObjectReferenceIndex"," "_ObjectReference,id)) Q:id=""
								Do GetOutPutRow
							}
						}
					}
				}
			}else{
				s docName=$p($g(^CTPCP(CTPId,1)),"^",2)
				s id=0
				for {
					s id=$o(^User.DHCDocDataChangeLogI("ObjDesIdx",docName,id)) Q:id=""
					Do GetOutPutRow
				}
			}
		}
	}elseif CTPCPID'=""  {
		Quit:'$d(^RB("RES",0,"CTPCP",CTPCPID))
		s LocRowid="" 
		for {
			s LocRowid=$o(^RB("RES",0,"CTPCP",CTPCPID,LocRowid))  Q:LocRowid=""
			s ResRowId="" 
			for {
				s ResRowId=$o(^RB("RES",0,"CTPCP",CTPCPID,LocRowid,ResRowId))  Q:ResRowId=""
				continue:'$D(^RBAS(ResRowId,0,"DateSTime"))
				i SelRBASFlag="on" {
					for ScheduleDate=StartDate:1:EndDate  {
						s ASSessStartTime=0 
						for {
							s ASSessStartTime=$O(^RBAS(ResRowId,0,"DateSTime",ScheduleDate,ASSessStartTime)) Q:(ASSessStartTime="")
							s ASChildSub=0  
							for {
								s ASChildSub=$O(^RBAS(ResRowId,0,"DateSTime",ScheduleDate,ASSessStartTime,ASChildSub)) Q:(ASChildSub="")
								s RBASID=ResRowId_"||"_ASChildSub
								s ObjectReference="USER.RBAPPTSCHEDULE#USER.DHCRBAPPTSCHEDULE_"_RBASID
								s id=0
								for {
									s id=$o(^User.DHCDocDataChangeLogI("ObjectReferenceIndex"," "_ObjectReference,id)) Q:id=""
									Do GetOutPutRow
								}
							}
						}
					}
				}else{
					s docName=$p($g(^CTPCP(CTPCPID,1)),"^",2)
					s id=0
					for {
						s id=$o(^User.DHCDocDataChangeLogI("ObjDesIdx",docName,id)) Q:id=""
						Do GetOutPutRow
					}
				}
			}
		}
	}elseif SelRBASFlag="on"  {
		Set ResRowId="" 
		for {
			s ResRowId=$o(^RB("RES",ResRowId))  q:ResRowId=""
			continue:'$D(^RBAS(ResRowId,0,"DateSTime"))
			for ScheduleDate=StartDate:1:EndDate  {
				s ASSessStartTime=0 
				for {
					s ASSessStartTime=$O(^RBAS(ResRowId,0,"DateSTime",ScheduleDate,ASSessStartTime)) Q:(ASSessStartTime="")
					s ASChildSub=0  
					for {
						s ASChildSub=$O(^RBAS(ResRowId,0,"DateSTime",ScheduleDate,ASSessStartTime,ASChildSub)) Q:(ASChildSub="")
						s RBASID=ResRowId_"||"_ASChildSub
						s ObjectReference="USER.RBAPPTSCHEDULE#USER.DHCRBAPPTSCHEDULE_"_RBASID
						s id=0
						for {
							s id=$o(^User.DHCDocDataChangeLogI("ObjectReferenceIndex"," "_ObjectReference,id)) Q:id=""
							Do GetOutPutRow
						}
					}
				}
			}
		}
	}else {
		d FindBySelUPDate
	}
	Do OutPutRow
	kill ^TMP("RBASULog",$j)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutRow
	Set L1="" 
	For {
		Set L1=$O(^TMP("RBASULog",$j,L1)) Quit:L1=""
		Set L2="" 
		For {
			Set L2=$O(^TMP("RBASULog",$j,L1,L2)) Quit:L2=""
			Set L3="" 
			For  {
				Set L3=$O(^TMP("RBASULog",$j,L1,L2,L3)) Quit:L3=""
				Set ^CacheTemp(repid,ind)=^TMP("RBASULog",$j,L1,L2,L3)
				Set ind=ind+1 
			}
		}
	}
	Q
FindBySelUPDate	
	s date=StartDate-1
	for {
		s date=$o(^User.DHCDocDataChangeLogI("UpdateDateIndex",date)) Q:(date="")||((date>EndDate)&&(EndDate'=""))
		s id=0
		for {
			s id=$o(^User.DHCDocDataChangeLogI("UpdateDateIndex",date,id)) Q:id=""
			Do GetOutPutRow
		}
	}
	Quit
GetOutPutRow
	s data=$g(^User.DHCDocDataChangeLogD(id))
	s ClassName=$lg(data,3)
	Q:ClassName'="User.RBApptSchedule#User.DHCRBApptSchedule"
	s ObjectDesc=$lg(data,4) //对象ID
	i ObjectDesc["_" s UpdateRBAS=$p(ObjectDesc,"_",2)
	s ResRowId1=$p(UpdateRBAS,"||")
 	s ASChildSub1=$p(UpdateRBAS,"||",2)
 	Q:('$d(^RBAS(ResRowId1,ASChildSub1)))
 	s DepID=$p($g(^RB("RES",ResRowId1)),"^",1)
	Q:(CTlocID'="")&&(DepID'=CTlocID)
	s HospDr=$P(^CTLOC(DepID),"^",22)
	Q:HospDr'=HospID
	i DepID'="" Set DepName=$p($g(^CTLOC(DepID)),"^",2)
 	set DepName1=$P(DepName,"-",2)
    if DepName1'="" set DepName=DepName1
 	s ASDate=$p(^RBAS(ResRowId1,ASChildSub1),"^",1)
 	i ASDate'="" s ASDate=..%ZD(ASDate) //$zd(ASDate,3)
	Set DoctorID=$p($g(^RB("RES",ResRowId1)),"^",2)
 	Q:(CTPCPID'="")&&(DoctorID'=CTPCPID)
	i DoctorID'="" Set DoctorName=$p($g(^CTPCP(DoctorID,1)),"^",2)
	s UpdateDateN=$lg(data,7)
	Q:((UpdateDateN<StartDate)||(UpdateDateN>EndDate))&&(SelRBASFlag'="on")
	
	s UpdateUserDR=$lg(data,5)
    i UpdateUserDR'="" s UpdateUser=$p($G(^SSU("SSUSR",UpdateUserDR)),"^",2) //操作人
    else  s UpdateUser=""
	s UpdateType=$lg(data,9) //操作类型
	s UpdateDateN=..%ZD(UpdateDateN) //操作日期
    s UpdateTimeN=..%ZT($lg(data,8),1) //操作时间
    s UpdateNotes=##class(web.DHCDocDataChangeLog).GetChangeDetail(id)
	Q:UpdateNotes=""
	s Data=$lb(DepName,DoctorName,ASDate,UpdateRBAS,UpdateDateN,UpdateTimeN,UpdateUser,UpdateType,UpdateNotes)
	Set ^TMP("RBASULog",$j,id,$lg(data,7),$lg(data,8))=Data
 	Q
	/*i vRBASID'="" d
	.s ASULRowid=0 f  s ASULRowid=$O(^DHCASULOGi("RBApptSchedule",vRBASID,ASULRowid)) q:(ASULRowid="")  d
	..Do OutputRow
	.Set L1="" For  Set L1=$O(^TMP("RBASULog",$j,L1)) Quit:L1=""  Do
	..Set L2="" For  Set L2=$O(^TMP("RBASULog",$j,L1,L2)) Quit:L2=""  Do
	...Set L3="" For  Set L3=$O(^TMP("RBASULog",$j,L1,L2,L3)) Quit:L3=""  Do
	....Set ^CacheTemp(repid,ind)=^TMP("RBASULog",$j,L1,L2,L3)
	....Set ind=ind+1 
	.Set qHandle=$lb(0,repid,0)
	.Kill ^TMP("RBASULog",$j)
	Quit:(vRBASID'="") $$$OK
	
	i CTlocID'=""  d
 	.Do FindByLoc
 	.Set L1="" For  Set L1=$O(^TMP("RBASULog",$j,L1)) Quit:L1=""  Do
	..Set L2="" For  Set L2=$O(^TMP("RBASULog",$j,L1,L2)) Quit:L2=""  Do
	...Set L3="" For  Set L3=$O(^TMP("RBASULog",$j,L1,L2,L3)) Quit:L3=""  Do
	....Set ^CacheTemp(repid,ind)=^TMP("RBASULog",$j,L1,L2,L3)
	....Set ind=ind+1 
	.Set qHandle=$lb(0,repid,0)
	.Kill ^TMP("RBASULog",$j)
	Quit:(CTlocID'="") $$$OK
	
	i CTPCPID'=""  d
	.Do FindByDoc
	.Set L1="" For  Set L1=$O(^TMP("RBASULog",$j,L1)) Quit:L1=""  Do
	..Set L2="" For  Set L2=$O(^TMP("RBASULog",$j,L1,L2)) Quit:L2=""  Do
	...Set L3="" For  Set L3=$O(^TMP("RBASULog",$j,L1,L2,L3)) Quit:L3=""  Do
	....Set ^CacheTemp(repid,ind)=^TMP("RBASULog",$j,L1,L2,L3)
	....Set ind=ind+1 
	.Set qHandle=$lb(0,repid,0)
	.Kill ^TMP("RBASULog",$j)
	Quit:(CTPCPID'="") $$$OK
	
	i SelRBASFlag="on"  d
	.d FindBySelRBASDate
	.Set L1="" For  Set L1=$O(^TMP("RBASULog",$j,L1)) Quit:L1=""  Do
	..Set L2="" For  Set L2=$O(^TMP("RBASULog",$j,L1,L2)) Quit:L2=""  Do
	...Set L3="" For  Set L3=$O(^TMP("RBASULog",$j,L1,L2,L3)) Quit:L3=""  Do
	....Set ^CacheTemp(repid,ind)=^TMP("RBASULog",$j,L1,L2,L3)
	....Set ind=ind+1 
	.Set qHandle=$lb(0,repid,0)
	.Kill ^TMP("RBASULog",$j)
	Quit:(SelRBASFlag="on") $$$OK
	
     d FindBySelUPDate
     Set L1="" For  Set L1=$O(^TMP("RBASULog",$j,L1)) Quit:L1=""  Do
	 .Set L2="" For  Set L2=$O(^TMP("RBASULog",$j,L1,L2)) Quit:L2=""  Do
	 ..Set L3="" For  Set L3=$O(^TMP("RBASULog",$j,L1,L2,L3)) Quit:L3=""  Do
	 ...Set ^CacheTemp(repid,ind)=^TMP("RBASULog",$j,L1,L2,L3)
	 ...Set ind=ind+1 
	 Set qHandle=$lb(0,repid,0)
	 Kill ^TMP("RBASULog",$j)
	Quit $$$OK
	
FindBySelUPDate	
	f UpdateDate=StartDate:1:EndDate  d
	.q:'$d(^DHCASULOGi("UpdateDate",UpdateDate))
	.s ASULRowid=0 f  s ASULRowid=$o(^DHCASULOGi("UpdateDate",UpdateDate,ASULRowid)) q:(ASULRowid="")  d
	..Do OutputRow
	Quit

FindByLoc
	Quit:'$d(^RB("RES",0,"CTLOC",CTlocID))
	Set ResRowId="" f  s ResRowId=$o(^RB("RES",0,"CTLOC",CTlocID,ResRowId))  q:ResRowId=""  d
	.Q:'$D(^RBAS(ResRowId,0,"DateSTime"))
	.Set CTPId=$p($g(^RB("RES",ResRowId)),"^",2)
	.Quit:(CTPCPID'="")&&(CTPId'=CTPCPID)
	.i SelRBASFlag="on" d
	..f ScheduleDate=StartDate:1:EndDate  d
	...s ASSessStartTime=0 f  s ASSessStartTime=$O(^RBAS(ResRowId,0,"DateSTime",ScheduleDate,ASSessStartTime)) q:(ASSessStartTime="")  d
	....s ASChildSub=0  f  s ASChildSub=$O(^RBAS(ResRowId,0,"DateSTime",ScheduleDate,ASSessStartTime,ASChildSub)) q:(ASChildSub="")  d
	.....s RBASID=ResRowId_"||"_ASChildSub
	.....Q:'$D(^DHCASULOGi("RBApptSchedule",RBASID))
	.....s ASULRowid=0 f  s ASULRowid=$O(^DHCASULOGi("RBApptSchedule",RBASID,ASULRowid)) q:(ASULRowid="")  d
	......Do OutputRow
	.e  d
	..f UpdateDate=StartDate:1:EndDate  d
	...q:'$d(^DHCASULOGi("UpdateDate",UpdateDate))
	...s ASULRowid=0 f  s ASULRowid=$o(^DHCASULOGi("UpdateDate",UpdateDate,ASULRowid)) q:(ASULRowid="")  d
	....//b //4
	....Do OutputRow
	Quit		
FindByDoc
	Quit:'$d(^RB("RES",0,"CTPCP",CTPCPID))
	Set LocRowid="" f  s LocRowid=$o(^RB("RES",0,"CTPCP",CTPCPID,LocRowid))  q:LocRowid=""  d
	.Set ResRowId="" f  s ResRowId=$o(^RB("RES",0,"CTPCP",CTPCPID,LocRowid,ResRowId))  q:ResRowId=""  d
	..Q:'$D(^RBAS(ResRowId,0,"DateSTime"))
	..i SelRBASFlag="on" d
	...f ScheduleDate=StartDate:1:EndDate  d
	....s ASSessStartTime=0 f  s ASSessStartTime=$O(^RBAS(ResRowId,0,"DateSTime",ScheduleDate,ASSessStartTime)) q:(ASSessStartTime="")  d
	.....s ASChildSub=0  f  s ASChildSub=$O(^RBAS(ResRowId,0,"DateSTime",ScheduleDate,ASSessStartTime,ASChildSub)) q:(ASChildSub="")  d
	......s RBASID=ResRowId_"||"_ASChildSub
	......Q:'$D(^DHCASULOGi("RBApptSchedule",RBASID))
	......s ASULRowid=0 f  s ASULRowid=$O(^DHCASULOGi("RBApptSchedule",RBASID,ASULRowid)) q:(ASULRowid="")  d
	.......Do OutputRow
	..e  d
	...f UpdateDate=StartDate:1:EndDate  d
	....q:'$d(^DHCASULOGi("UpdateDate",UpdateDate))
	....s ASULRowid=0 f  s ASULRowid=$o(^DHCASULOGi("UpdateDate",UpdateDate,ASULRowid)) q:(ASULRowid="")  d
	.....Do OutputRow
	Quit
FindBySelRBASDate
	Set ResRowId="" f  s ResRowId=$o(^RB("RES",ResRowId))  q:ResRowId=""  d
	.Q:'$D(^RBAS(ResRowId,0,"DateSTime"))
	.f ScheduleDate=StartDate:1:EndDate  d
	..s ASSessStartTime=0 f  s ASSessStartTime=$O(^RBAS(ResRowId,0,"DateSTime",ScheduleDate,ASSessStartTime)) q:(ASSessStartTime="")  d
	...s ASChildSub=0  f  s ASChildSub=$O(^RBAS(ResRowId,0,"DateSTime",ScheduleDate,ASSessStartTime,ASChildSub)) q:(ASChildSub="")  d
	....s RBASID=ResRowId_"||"_ASChildSub
	....Q:'$D(^DHCASULOGi("RBApptSchedule",RBASID))
	....s ASULRowid=0 f  s ASULRowid=$O(^DHCASULOGi("RBApptSchedule",RBASID,ASULRowid)) q:(ASULRowid="")  d
	.....Do OutputRow
	Quit
OutputRow
	s UpdateRBAS=$p(^DHCASULOG(ASULRowid),"^",1)
	s DepName="",DoctorName=""
	s ResRowId1=$p(UpdateRBAS,"||")
 	s ASChildSub1=$p(UpdateRBAS,"||",2)
 	Q:('$d(^RBAS(ResRowId1,ASChildSub1)))
 	S ASDate=$p(^RBAS(ResRowId1,ASChildSub1),"^",1)
 	i ASDate'="" s ASDate=..%ZD(ASDate) //$zd(ASDate,3)
	s DepID=$p($g(^RB("RES",ResRowId1)),"^",1)
	Q:(CTlocID'="")&&(DepID'=CTlocID)
 	i DepID'="" Set DepName=$p($g(^CTLOC(DepID)),"^",2)
 	set DepName1=$P(DepName,"-",2)
    if DepName1'="" set DepName=DepName1
 	Set DoctorID=$p($g(^RB("RES",ResRowId1)),"^",2)
 	Q:(CTPCPID'="")&&(DoctorID'=CTPCPID)
 	i DoctorID'="" Set DoctorName=$p($g(^CTPCP(DoctorID,1)),"^",2)
	s UpdateDate=$p(^DHCASULOG(ASULRowid),"^",2)
	s UpdateTime=$p(^DHCASULOG(ASULRowid),"^",3)
	s UpdateTimeN=..%ZT(UpdateTime)
	s UpdateUser=$p(^DHCASULOG(ASULRowid),"^",4)
	s UpdateType=$p(^DHCASULOG(ASULRowid),"^",5)
	i UpdateType="A"  s UpdateType="新增"
	e  i UpdateType="S"  s UpdateType="停诊"
	e  i UpdateType="R"  s UpdateType="替诊"
	e  i UpdateType="U"  s UpdateType="更新"
	e  i UpdateType="CS"  s UpdateType="撤销停诊"
	e  s UpdateType=""
	s UpdateNotes=$p(^DHCASULOG(ASULRowid),"^",6)
	i UpdateUser'="" s UpdateUser=$P($G(^SSU("SSUSR",UpdateUser)),"^",2)
	s UpdateDateN=..%ZD(UpdateDate) //$zd(UpdateDate,3)
	s Data=$lb(DepName,DoctorName,ASDate,UpdateRBAS,UpdateDateN,UpdateTimeN,UpdateUser,UpdateType,UpdateNotes)
	Set ^TMP("RBASULog",$j,ASULRowid,UpdateDate,UpdateTime)=Data
	Quit*/
}

ClassMethod QueryRBASULogClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryRBASULogExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryRBASULogFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryRBASULogExecute ]
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

}
