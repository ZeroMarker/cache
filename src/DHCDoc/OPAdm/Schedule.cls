Class DHCDoc.OPAdm.Schedule Extends DHCDoc.Util.RegisteredObject
{

/// w ##class(DHCDoc.OPAdm.Schedule).GetAppScheduleList(1,"","2019-08-01","2019-08-01","")
ClassMethod GetAppScheduleList(LocRowid, DocRowid, SttDate, EndDate, UserID, RBASRowid = "", TimeRangeStr = "")
{
	s SttDate=..%ZDH(SttDate)
	s:SttDate="" SttDate=..%SysDate()
	s EndDate=..%ZDH(EndDate)
	if EndDate="" s EndDate=$CASE(RBASRowid,"":($H+30),:($H+999))
	if RBASRowid'=""{
		s ResRowid=+RBASRowid
		d OneRes
	}elseif (LocRowid'="")&(DocRowid'=""){
		s ResRowid=$O(^RB("RES",0,"CTPCP",DocRowid,LocRowid,0))
		d OneRes
	}elseif LocRowid'=""{
		s ResRowid=0 f  s ResRowid=$O(^RB("RES",0,"CTLOC",LocRowid,ResRowid)) q:ResRowid=""  d
		.d OneRes
	}elseif DocRowid'=""{
		s LocRowid=0 f  s LocRowid=$O(^RB("RES",0,"CTPCP",DocRowid,LocRowid)) q:LocRowid=""  d
		.s ResRowid=$O(^RB("RES",0,"CTPCP",DocRowid,LocRowid,0))
		.d OneRes
	}
	
	s RetObj=[]
	s ASDate="" f  s ASDate=$O(SchduleList(ASDate)) Q:ASDate=""  d
	.s ASDateObj={}
	.s ASDateObj.ASDate=$P($ZD(ASDate,3),"-",2,3)
	.s ASDateObj.Week=##class(web.DHCOPAdmReg).ConvertDateToWeek(ASDate)
	.s TimeRanges=[]
	.s TRRowid="" f  s TRRowid=$O(SchduleList(ASDate,TRRowid)) Q:TRRowid=""  d
	..s TRObj={}
	..s TRObj.TimeRange=$P($G(^DHCTimeRange(TRRowid)),"^",2)
	..s Schedules=[]
	..s ASRowid="" f  s ASRowid=$O(SchduleList(ASDate,TRRowid,ASRowid)) Q:ASRowid=""  d
	...i ASRowid=RBASRowid d
	....s ASDateObj.Selected=1,TRObj.Selected=1
	...d Schedules.%Push(SchduleList(ASDate,TRRowid,ASRowid))
	..s TRObj.Schedules=Schedules
	..d TimeRanges.%Push(TRObj)
	.s ASDateObj.TimeRanges=TimeRanges
	.d RetObj.%Push(ASDateObj)
	Q RetObj.%ToJSON()
OneRes
	s ResLocID=$P(^RB("RES",ResRowid),"^",1)
	s ResDocID=$P(^RB("RES",ResRowid),"^",2)
	Q:'$D(^User.DHCUserGroupI("UserLocDoc"," REG"," "_UserID," "_ResLocID," "_ResDocID))
	s ASDate=SttDate-1 f  s ASDate=$O(^RBAS(ResRowid,0,"DateSTime",ASDate)) Q:(ASDate="")!(ASDate>EndDate)  d
	.s ScheduleDate=$ZD(ASDate,3)
	.s SessSttTime="" f  s SessSttTime=$O(^RBAS(ResRowid,0,"DateSTime",ASDate,SessSttTime)) q:(SessSttTime="")  d
	..s ASSub=0  f  s ASSub=$O(^RBAS(ResRowid,0,"DateSTime",ASDate,SessSttTime,ASSub)) q:(ASSub="")  d
	...s TRRowid=$P(^RBAS(ResRowid,ASSub,"DHC"),"^",17)
	...q:(TimeRangeStr'="")&(("^"_TimeRangeStr_"^")'[("^"_TRRowid_"^"))
	...i RBASRowid="" d
	....d OneSchedule
	...e  d
	....s SchduleList(ASDate,TRRowid,ResRowid_"||"_ASSub)=ResRowid_"||"_ASSub
	Q
OneSchedule
	s ASRowid=ResRowid_"||"_ASSub
	s ScheduleObj=..GetScheduleSingleInfo(ASRowid,.TRRowid)
	s SchduleList(ASDate,TRRowid,ASRowid)=ScheduleObj
	Q
}

ClassMethod GetScheduleSingleInfo(ASRowid, ByRef TRRowid As %String = "") As %DynamicObject
{
	s ResRowid=+ASRowid,ASSub=$P(ASRowid,"||",2)
	s LocDR=$P(^RB("RES",ResRowid),"^",1)
	s LocDesc=$P($G(^CTLOC(+LocDR)),"^",2)
	s:LocDesc["-" LocDesc=$P(LocDesc,"-",2)
	s ResDesc=$P(^RB("RES",ResRowid),"^",17)
	s TRRowid=$P(^RBAS(ResRowid,ASSub,"DHC"),"^",17)
	s:TRRowid="" TRRowid=" "
	s ASLoad=$P(^RBAS(ResRowid,ASSub),"^",8)
	s SessTypeDR=$P(^RBAS(ResRowid,ASSub,"DHC"),"^",6)
	s SessType=$P($G(^RBC("SESS",+SessTypeDR)),"^",2)
	s RoomDR=$P(^RBAS(ResRowid,ASSub,"DHC"),"^",5)
	s Room=$P($G(^CTLOC(+RoomDR)),"^",2)
	s:Room["-" Room=$P(Room,"-",2)
	s CGRowid=$P(^RBAS(ResRowid,ASSub,"DHC"),"^",7)
	s CGDesc=$P($G(^RBC("CLGRP",+CGRowid)),"^",2)
	s StatusDR=$P(^RBAS(ResRowid,ASSub,"DHC"),"^",10)
	s ASStatusCode=$P(^DHCRBCASStatus(StatusDR),"^",1)
	s ASStatus=$P(^DHCRBCASStatus(StatusDR),"^",2)
	s RBASDR=$P(^RBAS(ResRowid,ASSub,"DHC"),"^",12)
	s obj={}
	s obj.ASRowid=ASRowid
	s obj.ASStatusCode=ASStatusCode
	s obj.IrregularFlag=$p(^RBAS(ResRowid,ASSub),"^",13)
	s obj.Loc=LocDesc
	s obj.Doctor=ResDesc
	if (ASStatusCode["S")!(ASStatusCode="TR"){
		s StopReasonDR=$P(^RBAS(ResRowid,ASSub,"DHC"),"^",11)
		s StopReason=$P(^RBC("NA",StopReasonDR),"^",2)
		if $L(StopReason)>5 s StopReason=$E(StopReason,1,5)_"..."
		s obj.StopReason=StopReason
	}
	if ASStatusCode["R"{
		s NewResDesc=$P(^RB("RES",+RBASDR),"^",17)
		i ASStatusCode="TR" s obj.ReplaceDoc=NewResDesc
		e  s obj.ReplacedDoc=NewResDesc
	}
	s obj.Load=ASLoad
	s obj.RoomDesc=Room
	s obj.CGDesc=CGDesc
	s obj.SessTypeDesc=SessType
	Q obj
}

/// w ##class(DHCDoc.OPAdm.Schedule).GetScheduleInfo("1085||258")
ClassMethod GetScheduleInfo(ASRowid)
{
	s retObj={}
	s ResRowid=+ASRowid,ASSub=$P(ASRowid,"||",2)
	s schedule=##class(User.RBApptSchedule).%OpenId(ASRowid)
	s scheduleExt=##class(User.DHCRBApptSchedule).%OpenId(ASRowid)
	s retObj.AdmDate=..%ZD(schedule.ASDate)
	s retObj.AdmLoc=schedule.ASRESParRef.RESCTLOCDRGetObjectId()
	s retObj.AdmDoc=schedule.ASRESParRef.RESCTPCPDRGetObjectId()
	s retObj.ASLoad=schedule.ASLoad
	s retObj.AppStartNo=schedule.ASQueueNoCount
	s retObj.AppLoad=schedule.ASNoApptSession
	s retObj.AddLoad=scheduleExt.ASNoOverbookAllowed
	s retObj.TimeRange=scheduleExt.ASTimeRangeDRGetObjectId()
	s retObj.SessType=scheduleExt.ASSessionTypeDRGetObjectId()
	s retObj.Room=scheduleExt.ASRoomDRGetObjectId()
	s retObj.ClincGroup=scheduleExt.ASClinicGroupDRGetObjectId()
	s AppMethods=[]
	s ASQSub=0 for{	;预约方式限额
		s ASQSub=$O(^RBAS(ResRowid,ASSub,"AQ",ASQSub)) Q:ASQSub=""
		s obj={}
		s obj.ASAMRowid=ASRowid_"||"_ASQSub
		s obj.AppMethodID=$P(^RBAS(ResRowid,ASSub,"AQ",ASQSub),"^",1)
		s obj.AppMethod=$P(^RBC("APTM",obj.AppMethodID),"^",2)
		s obj.StartNo=$P(^RBAS(ResRowid,ASSub,"AQ",ASQSub),"^",3)
		s obj.ReserveQty=$P(^RBAS(ResRowid,ASSub,"AQ",ASQSub),"^",2)
		s obj.MaxQty=$P(^RBAS(ResRowid,ASSub,"AQ",ASQSub),"^",4)
		d AppMethods.%Push(obj)
	}
	s retObj.tabAppMethodInfo=AppMethods
	s retObj.TRFlag=scheduleExt.ASTimeRangeFlag
	s TimeRanges=[]
	s ASTRSub=0 for{
		s ASTRSub=$O(^RBAS(ResRowid,ASSub,"ASTR",ASTRSub)) Q:ASTRSub=""
		s ASTRObj={}
		s ASTRObj.ASTRRowid=ASRowid_"||"_ASTRSub
		s SttTime=$P(^RBAS(ResRowid,ASSub,"ASTR",ASTRSub),"^",1)
		s ASTRObj.SttTime=##class(websys.Conversions).TimeLogicalToHtml(SttTime)
		s EndTime=$P(^RBAS(ResRowid,ASSub,"ASTR",ASTRSub),"^",2)
		s ASTRObj.EndTime=##class(websys.Conversions).TimeLogicalToHtml(EndTime)
		s ASTRObj.Load=$P(^RBAS(ResRowid,ASSub,"ASTR",ASTRSub),"^",3)
		s TRAppMethods=[]
		s TRAMSub=0 for{
			s TRAMSub=$O(^RBAS(ResRowid,ASSub,"ASTR",ASTRSub,"TRAM",TRAMSub)) Q:TRAMSub=""
			s TRAMObj={}
			s TRAMObj.TRAMRowid=ASRowid_"||"_ASTRSub_"||"_TRAMSub
			s TRAMObj.AppMethodID=$P(^RBAS(ResRowid,ASSub,"ASTR",ASTRSub,"TRAM",TRAMSub),"^",1)
			s TRAMObj.AppMethod=$P($G(^RBC("APTM",+TRAMObj.AppMethodID)),"^",2)
			s TRAMObj.MaxQty=$P(^RBAS(ResRowid,ASSub,"ASTR",ASTRSub,"TRAM",TRAMSub),"^",2)
			s TRAMObj.ReserveQty=$P(^RBAS(ResRowid,ASSub,"ASTR",ASTRSub,"TRAM",TRAMSub),"^",3)
			d TRAppMethods.%Push(TRAMObj)
		}
		s ASTRObj.tabTRAppMethodInfo=TRAppMethods
		d TimeRanges.%Push(ASTRObj)
	}
	s retObj.tabTRInfo=TimeRanges
	Q retObj.%ToJSON()
}

// w ##class(DHCDoc.OPAdm.Schedule).GetAppMethodsInfo("2333||331")

ClassMethod GetAppMethodsInfo(ASRowid)
{
	q:ASRowid="" "[]"
	s ResRowid=+ASRowid,ASSub=$P(ASRowid,"||",2)
	s AppMethods=[]
	s ASQSub=0 for{	;预约方式限额
		s ASQSub=$O(^RBAS(ResRowid,ASSub,"AQ",ASQSub)) Q:ASQSub=""
		s obj={}
		s obj.ASAMRowid=ASRowid_"||"_ASQSub
		s obj.AppMethodID=$P(^RBAS(ResRowid,ASSub,"AQ",ASQSub),"^",1)
		s obj.AppMethod=$P(^RBC("APTM",obj.AppMethodID),"^",2)
		s obj.StartNo=$P(^RBAS(ResRowid,ASSub,"AQ",ASQSub),"^",3)
		s obj.ReserveQty=$P(^RBAS(ResRowid,ASSub,"AQ",ASQSub),"^",2)
		s obj.MaxQty=$P(^RBAS(ResRowid,ASSub,"AQ",ASQSub),"^",7)
		b ;0932323
		d AppMethods.%Push(obj)
	}
	Q AppMethods.%ToJSON()
}

/// 保存排班信息,一次可插入多个排班
/// w ##class(DHCDoc.OPAdm.Schedule).SaveScheduleInfo(^Wqy("SaveScheduleInfo"))
ClassMethod SaveScheduleInfo(InputJson)
{
	s $ZT="SaveScheduleInfoErr"
	s ^Wqy("SaveScheduleInfo")=InputJson
	s InputObj={}.%FromJSON(InputJson)
	s retObj={}
	s ASRowid=InputObj.ASRowid
	s ASRowidStr=ASRowid
	TS
	if ASRowid'=""{
		;更新排班
		s ret=##class(web.DHCRBApptSchedule).UpdateOneSchedule(ASRowid,InputObj.Room,InputObj.ASLoad,InputObj.AddLoad,InputObj.AppLoad,InputObj.AppStartNo,InputObj.ClincGroup,InputObj.SessType,"",InputObj.SttTime,InputObj.EndTime)
		if ret'=0{
			TRO
			s retObj.Code=$P(ret,"^")
			s retObj.msg=..GetErrMsg(ret)
			Q retObj.%ToJSON()
		}
	}else{
		;新增排班
		s InputObj.AdmDate=$TR(InputObj.AdmDate," ")
		for i=1:1:$L(InputObj.AdmDate,","){
			s AdmDate=$P(InputObj.AdmDate,",",i)
			s ret=##class(web.DHCRBApptSchedule).InsertOneSchedule(AdmDate,InputObj.AdmDoc,InputObj.AdmLoc,InputObj.TimeRange,InputObj.ASLoad,InputObj.AppLoad,InputObj.AddLoad,InputObj.Room,InputObj.SessType,InputObj.ClincGroup,InputObj.AppStartNo,InputObj.SttTime,InputObj.EndTime,"A")
			s retCode=$P(ret,"^")
			if retCode'=0{
				s retObj.Code=retCode
				s retObj.msg=..GetErrMsg(ret)
				Q
			}
			s ASRowid=$P(ret,"^",2)
			if ASRowidStr="" s ASRowidStr=ASRowid
			else  s ASRowidStr=ASRowidStr_"^"_ASRowid
		}
		if +retObj.Code'=0{
			TRO
			Q retObj.%ToJSON()
		} 
	}
	if ASRowidStr=""{
		TRO
		s retObj.Code=-1
		s retObj.msg="没有保存的排班"
		Q retObj.%ToJSON()
	}
	s ASRowids=[]
	for i=1:1:$L(ASRowidStr,"^"){
		;更新分时段标志
		s ASRowid=$P(ASRowidStr,"^",i)
		s TRFlag=InputObj.TRFlag
		&SQL(UPDATE SQLUser.DHC_RBApptSchedule SET AS_TimeRangeFlag=:TRFlag WHERE AS_Rowid=:ASRowid)
		;处理原先预约方式限额
		s retObj=..UpdateAppMethodQty(ASRowid,InputObj.tabAppMethodInfo,InputObj.UserID)
		Q:+retObj.Code'=0
		;新分时段 分时段预约方式信息保存
		s TRInfoObj=InputObj.tabTRInfo
		s retObj=..UpdateTRInfo(ASRowid,TRInfoObj)
		Q:+retObj.Code'=0
		d ASRowids.%Push(ASRowid)
	}
	if +retObj.Code'=0{
		TRO
		Q retObj.%ToJSON()
	} 
	TC
	s retObj.Code=0
	s retObj.msg="成功"
	s retObj.ASRowids=ASRowids
	Q retObj.%ToJSON()
SaveScheduleInfoErr
	TRO
	s retObj={}
	s retObj.Code=-1
	s retObj.msg=$ZE
	Q retObj.%ToJSON()
}

ClassMethod GetErrMsg(err)
{
	s Code=$P(err,"^",1)
	Q $CASE(Code,
	 -100:"不能增加或者修改当前日期以前的排班",
	 -200:"医生已经有排班记录",
	 -201:"同一个医生不能在同一天同一时段安排两次:"_$P(err,"^",2),
	 -202:"此诊室已经在同一天同一时段被安排过:"_$P(err,"^",2),
	 -203:"正号限额不能小于已挂出号数!",
	 -204:"预约限额不能小于已预约数",
	 -205:"加号限额不能小于已挂出数",
	 -300:"医生没有安排资源 ",:"坐诊信息调整失败:"_err)
}

ClassMethod UpdateTRInfo(ASRowid, TRInfoObj As %DynamicArray) As %DynamicObject
{
	s retObj={"Code":0}
	TS
	for i=1:1:TRInfoObj.%Size(){
		s obj=TRInfoObj.%Get(i-1)
		continue:'$IsObject(obj)
		s ASTRRowid=obj.ASTRRowid
		if (ASTRRowid="")!($P(ASTRRowid,"||",1,2)'=ASRowid){
			s ASTRObj=##class(User.RBApptScheduleTR).%New(ASRowid)
			d ASTRObj.ASTRParRefSetObjectId(ASRowid)
		}else{
			s ASTRObj=##class(User.RBApptScheduleTR).%OpenId(ASTRRowid)
		}
		s ASTRObj.ASTRSttTime=##class(websys.Conversions).TimeHtmlToLogical(obj.SttTime)
		s ASTRObj.ASTREndTime=##class(websys.Conversions).TimeHtmlToLogical(obj.EndTime)
		s ASTRObj.ASTRLoad=obj.Load
		s sc=ASTRObj.%Save()
		if $$$ISERR(sc){
			s retObj.Code=-1
			s retObj.msg="保存失败"
			Q
		}
		;更新时段预约方式信息
		s retObj=..UpdateTRAppMethodQty(ASTRObj.%Id(),obj.tabTRAppMethodInfo)
		Q:+retObj.Code
		s IDList(ASTRObj.%Id())=""
	}
	if +retObj.Code{
		TRO
	}else{
		s ASTRSub=0 for{
			s ASTRSub=$O(^RBAS(+ASRowid,$P(ASRowid,"||",2),"ASTR",ASTRSub)) Q:ASTRSub=""
			s ASTRRowid=ASRowid_"||"_ASTRSub
			if '$D(IDList(ASTRRowid)){
				&SQL(DELETE FROM SQLUser.RB_ApptScheduleTR WHERE ASTR_RowId=:ASTRRowid)
			}
		}
		s rtn=..SaveAppMethodQueue(ASRowid)
		TC
	}
	Q retObj
}

ClassMethod UpdateTRAppMethodQty(ASTRRowid, AMObj As %DynamicArray) As %DynamicObject
{
	s retObj={"Code":0}
	TS
	if $IsObject(AMObj){
		for j=1:1:AMObj.%Size(){
			s obj=AMObj.%Get(j-1)
			continue:'$IsObject(obj)
			s TRAMRowid=obj.TRAMRowid
			if (TRAMRowid="")!($P(TRAMRowid,"||",1,3)'=ASTRRowid){
				s TRAMObj=##class(User.RBApptScheduleTRAppMethod).%New(ASTRRowid)
				d TRAMObj.ASTRAMParRefSetObjectId(ASTRRowid)
			}else{
				s TRAMObj=##class(User.RBApptScheduleTRAppMethod).%OpenId(TRAMRowid)
			}
			d TRAMObj.ASTRAMMethodDRSetObjectId(obj.AppMethodID)
			s TRAMObj.ASTRAMMaxQty=obj.MaxQty
			s TRAMObj.ASTRAMReserveQty=obj.ReserveQty
			s sc=TRAMObj.%Save()
			b ;ddd
			if $$$ISERR(sc){
				s retObj.Code=-1
				s retObj.msg="时段预约方式保存失败"
				Q
			}
			s IDList(TRAMObj.%Id())=""
		}
	}
	if +retObj.Code{
		TRO
	}else{
		s TRAMSub=0 for{
			s TRAMSub=$O(^RBAS(+ASTRRowid,$P(ASTRRowid,"||",2),"ASTR",$P(ASTRRowid,"||",3),"TRAM",TRAMSub)) Q:TRAMSub=""
			s TRAMRowid=ASTRRowid_"||"_TRAMSub
			if '$D(IDList(TRAMRowid)){
				&SQL(DELETE FROM SQLUser.RB_ApptScheduleTRAppMethod WHERE ASTRAM_RowId=:TRAMRowid)
			}
		}
		TC
	}
	Q retObj
}

ClassMethod UpdateTRClinicGroupInfo(ASTRRowid, AMObj As %DynamicArray) As %DynamicObject
{
	s retObj={"Code":0}
	TS
	if $IsObject(AMObj){
		for j=1:1:AMObj.%Size(){
			s obj=AMObj.%Get(j-1)
			continue:'$IsObject(obj)
			continue:obj.ClinicGroupMethodID=""
			s TRClinicGroupRowid=obj.TRClinicGroupRowid
			if (TRClinicGroupRowid="")!($P(TRClinicGroupRowid,"||",1,3)'=ASTRRowid){
				s TRAMObj=##class(User.RBApptScheduleTRClinicGroup).%New(ASTRRowid)
				d TRAMObj.ASTRCGParRefSetObjectId(ASTRRowid)
			}else{
				s TRAMObj=##class(User.RBApptScheduleTRClinicGroup).%OpenId(TRClinicGroupRowid)
			}
			d TRAMObj.ASTRCGClinicGroupDRSetObjectId(obj.ClinicGroupMethodID)
			s TRAMObj.ASTRCGQty=obj.Qty
			s sc=TRAMObj.%Save()
			if $$$ISERR(sc){
				s retObj.Code=-1
				s retObj.msg="亚专业保存失败"
				Q
			}
			s IDList(TRAMObj.%Id())=""
		}
	}
	if +retObj.Code{
		TRO
	}else{
		s TRAMSub=0 for{
			s TRAMSub=$O(^RBAS(+ASTRRowid,$P(ASTRRowid,"||",2),"ASTR",$P(ASTRRowid,"||",3),"TRCG",TRAMSub)) Q:TRAMSub=""
			s TRAMRowid=ASTRRowid_"||"_TRAMSub
			if '$D(IDList(TRAMRowid)){
				&SQL(DELETE FROM SQLUser.RB_ApptScheduleTRClinicGroup WHERE ID=:TRAMRowid)
			}
		}
		TC
	}
	Q retObj
}

ClassMethod UpdateAppMethodQty(ASRowid, ASAppQtyObj As %DynamicArray, UserID As %String) As %DynamicObject
{
	s retObj={"Code":0}
	s ^tempqujan("ASAppQtyObj")=ASAppQtyObj
	TS
	for i=1:1:ASAppQtyObj.%Size(){
		s obj=ASAppQtyObj.%Get(i-1)
		continue:'$IsObject(obj)
		s ASAMRowid=obj.ASAMRowid
		if (ASAMRowid="")!($P(ASAMRowid,"||",1,2)'=ASRowid){
			s AMQObj=##class(User.DHCRBApptScheduleAppQty).%New(ASRowid)
			d AMQObj.ASQASParRefSetObjectId(ASRowid)
			s Action="新增",Type="A"
		}else{
			s AMQObj=##class(User.DHCRBApptScheduleAppQty).%OpenId(ASAMRowid)
			if (AMQObj.ASQStartNum=obj.StartNo)&(AMQObj.ASQQty=obj.ReserveQty)
				&(AMQObj.ASQMethodDRGetObjectId()=obj.AppMethodID)&(AMQObj.ASQMaxQty=obj.MaxQty){
				s IDList(ASAMRowid)=""
				continue
			}
			s Action="更新",Type="U"
		}
		d AMQObj.ASQMethodDRSetObjectId(obj.AppMethodID)
		s AMQObj.ASQStartNum=obj.StartNo
		s AMQObj.ASQQty=obj.ReserveQty
		s AMQObj.ASQMaxQty=obj.MaxQty
		s sc=AMQObj.%Save()
		if $$$ISERR(sc){
			s retObj.Code=-1
			s retObj.msg="更新预约方式失败"
			Q
		}
		s ASULNotes=Action_" "_obj.AppMethod_" 起始号:"_obj.StartNo_",数量:"_obj.ReserveQty
		d ..AddScheduleLog(ASRowid,UserID,Type,ASULNotes)
		s IDList(AMQObj.%Id())=""
	}
	if +retObj.Code'=0{
		TRO
	}else{
		s AMQSub=0 for{
			s AMQSub=$O(^RBAS(+ASRowid,$P(ASRowid,"||",2),"AQ",AMQSub)) Q:AMQSub=""
			s AMQRowid=ASRowid_"||"_AMQSub
			if '$D(IDList(AMQRowid)){
				&SQL(DELETE FROM SQLUser.DHC_RBApptScheduleAppQty WHERE ASQ_RowId=:AMQRowid)
			}
		}
		TC
	}
	Q retObj
}

/// w ##class(DHCDoc.OPAdm.Schedule).UpdateAppMethodQtyNew("2333||331",^tempqujan("ASAppQtyObj"),1)
ClassMethod UpdateAppMethodQtyNew(ASRowid, ASAppQtyObjStr, UserID As %String) As %DynamicObject
{
	s retObj=0
	s ^tempqujan("ASAppQtyObj")=ASAppQtyObjStr
	s ASAppQtyObj={}.%FromJSON(ASAppQtyObjStr)
	TS
	for i=1:1:ASAppQtyObj.%Size(){
		s obj=ASAppQtyObj.%Get(i-1)
		continue:'$IsObject(obj)
		s ASAMRowid=obj.ASAMRowid
		if (ASAMRowid="")!($P(ASAMRowid,"||",1,2)'=ASRowid){
			s AMQObj=##class(User.DHCRBApptScheduleAppQty).%New(ASRowid)
			d AMQObj.ASQASParRefSetObjectId(ASRowid)
			s Action="新增",Type="A"
		}else{
			s AMQObj=##class(User.DHCRBApptScheduleAppQty).%OpenId(ASAMRowid)
			if (AMQObj.ASQStartNum=obj.StartNo)&(AMQObj.ASQQty=obj.ReserveQty)
				&(AMQObj.ASQMethodDRGetObjectId()=obj.AppMethodID)&(AMQObj.ASQMaxQty=obj.MaxQty){
				s IDList(ASAMRowid)=""
				continue
			}
			s Action="更新",Type="U"
		}
		d AMQObj.ASQMethodDRSetObjectId(obj.AppMethodID)
		s AMQObj.ASQStartNum=obj.StartNo
		s AMQObj.ASQQty=obj.ReserveQty
		s AMQObj.ASQMaxQty=obj.MaxQty
		s sc=AMQObj.%Save()
		if $$$ISERR(sc){
			s Code="更新预约方式失败"
			Q
		}
		s ASULNotes=Action_" "_obj.AppMethod_" 起始号:"_obj.StartNo_",数量:"_obj.ReserveQty
		d ..AddScheduleLog(ASRowid,UserID,Type,ASULNotes)
		s IDList(AMQObj.%Id())=""
	}
	if retObj'=0{
		TRO
	}else{
		s AMQSub=0 for{
			s AMQSub=$O(^RBAS(+ASRowid,$P(ASRowid,"||",2),"AQ",AMQSub)) Q:AMQSub=""
			s AMQRowid=ASRowid_"||"_AMQSub
			if '$D(IDList(AMQRowid)){
				&SQL(DELETE FROM SQLUser.DHC_RBApptScheduleAppQty WHERE ASQ_RowId=:AMQRowid)
			}
		}
		;s rtn=..ChangeDHCQueueNo(ASRowid)
		TC
	}
	Q retObj
}

ClassMethod CheckTRInfoTime(TRInfoObjStr, ASRowId = "")
{
	s ^tempqujian("UpdateTRInfoNew")=TRInfoObjStr
	s retObj=0
	s TRInfoObj={}.%FromJSON(TRInfoObjStr)
	s Message=0, Total=0
	for i=1:1:TRInfoObj.%Size(){
		s obj=TRInfoObj.%Get(i-1)
		s Total=Total+obj.Load
		s ASTRSttTime=##class(websys.Conversions).TimeHtmlToLogical(obj.SttTime)
		s ASTREndTime=##class(websys.Conversions).TimeHtmlToLogical(obj.EndTime)
		if (ASTREndTime<ASTRSttTime){
			s Message="第"_i_"行的开始时间大于结束时间"
			q 
		}
		s quitflag=0
		for j=1:1:TRInfoObj.%Size(){
			s Jobj=TRInfoObj.%Get(j-1)
			continue:j=i
			if ((i+1)=j){
				s JASTRSttTime=##class(websys.Conversions).TimeHtmlToLogical(Jobj.SttTime)
				s JASTREndTime=##class(websys.Conversions).TimeHtmlToLogical(Jobj.EndTime)
				if (JASTRSttTime<ASTREndTime){
					s Message="第"_j_"行的开始时间小于第"_i_"行结束时间"
					s quitflag=1
					q 
				}
			}
		}
		q:quitflag=1
	}
	q:Message'=0 Message
	if ASRowId'="" {
		s QueueStr=$p(^RBAS(+ASRowId,$p(ASRowId,"||",2),"DHC"),"^",4)
		i $l($p(QueueStr,$c(1),1),",")'=Total {
			s Message="时段号数("_$l($p(QueueStr,$c(1),1),",")_")不等于分时段数量总和"
		}
	}
	q Message
}

/// w ##class(DHCDoc.OPAdm.Schedule).UpdateTRInfoNew("3146||108",^tempqujian("UpdateTRInfoNew"))
ClassMethod UpdateTRInfoNew(ASRowid, TRInfoObjStr As %String) As %String
{
	s ^tempqujian("UpdateTRInfoNew")=TRInfoObjStr
	s retObj=0
	s TRInfoObj={}.%FromJSON(TRInfoObjStr)
	TS
	for i=1:1:TRInfoObj.%Size(){
		s obj=TRInfoObj.%Get(i-1)
		continue:'$IsObject(obj)
		s ASTRRowid=obj.ASTRRowid
		s ASTRObj=##class(User.RBApptScheduleTR).%New(ASRowid)
		if (ASTRRowid="")!($P(ASTRRowid,"||",1,2)'=ASRowid){
			s ASTRObj=##class(User.RBApptScheduleTR).%New(ASRowid)
			d ASTRObj.ASTRParRefSetObjectId(ASRowid)
		}else{
			s ASTRObj=##class(User.RBApptScheduleTR).%OpenId(ASTRRowid)
		}
		s ASTRObj.ASTRSttTime=##class(websys.Conversions).TimeHtmlToLogical(obj.SttTime)
		s ASTRObj.ASTREndTime=##class(websys.Conversions).TimeHtmlToLogical(obj.EndTime)
		s ASTRObj.ASTRLoad=obj.Load
		s sc=ASTRObj.%Save()
		if $$$ISERR(sc){
			s retObj="保存失败"
			Q
		}
		b ;更新时段预约方式信息
		s retObjStr=..UpdateTRAppMethodQty(ASTRObj.%Id(),obj.tabTRAppMethodInfo)
		Q:+retObjStr.Code
		b ;更新亚专业
		s retObjStr=..UpdateTRClinicGroupInfo(ASTRObj.%Id(),obj.tabTRClinicGroupInfo)
		Q:+retObjStr.Code
		s IDList1(ASTRObj.%Id())=""
	}
	if retObj'=0{
		TRO
	}else{
		s ASTRSub=0 
		for{
			s ASTRSub=$O(^RBAS(+ASRowid,$P(ASRowid,"||",2),"ASTR",ASTRSub)) Q:ASTRSub=""
			s ASTRRowid=ASRowid_"||"_ASTRSub
			if '$D(IDList1(ASTRRowid)){
				&SQL(DELETE FROM SQLUser.RB_ApptScheduleTR WHERE ASTR_RowId=:ASTRRowid)
			}	
		}
		s rtn=..SaveAppMethodQueue(ASRowid)
		TC
	}
	Q retObj
}

/// w ##class(DHCDoc.OPAdm.Schedule).GetTRInfoNew("3146||108")
ClassMethod GetTRInfoNew(ASRowid)
{
	s ResRowid=+ASRowid,ASSub=$P(ASRowid,"||",2)
	s TimeRanges=[]
	s ASTRSub=0 for{
		s ASTRSub=$O(^RBAS(ResRowid,ASSub,"ASTR",ASTRSub)) Q:ASTRSub=""
		s ASTRObj={}
		s ASTRObj.ASTRRowid=ASRowid_"||"_ASTRSub
		s SttTime=$P(^RBAS(ResRowid,ASSub,"ASTR",ASTRSub),"^",1)
		s ASTRObj.SttTime=##class(websys.Conversions).TimeLogicalToHtml(SttTime)
		s EndTime=$P(^RBAS(ResRowid,ASSub,"ASTR",ASTRSub),"^",2)
		s ASTRObj.EndTime=##class(websys.Conversions).TimeLogicalToHtml(EndTime)
		s ASTRObj.Load=$P(^RBAS(ResRowid,ASSub,"ASTR",ASTRSub),"^",3)
		s TRAppMethods=[]
		s TRAMSub=0 for{
			s TRAMSub=$O(^RBAS(ResRowid,ASSub,"ASTR",ASTRSub,"TRAM",TRAMSub)) Q:TRAMSub=""
			s TRAMObj={}
			s TRAMObj.TRAMRowid=ASRowid_"||"_ASTRSub_"||"_TRAMSub
			s TRAMObj.AppMethodID=$P(^RBAS(ResRowid,ASSub,"ASTR",ASTRSub,"TRAM",TRAMSub),"^",1)
			s TRAMObj.AppMethod=$P($G(^RBC("APTM",+TRAMObj.AppMethodID)),"^",2)
			s TRAMObj.MaxQty=$P(^RBAS(ResRowid,ASSub,"ASTR",ASTRSub,"TRAM",TRAMSub),"^",2)
			s TRAMObj.ReserveQty=$P(^RBAS(ResRowid,ASSub,"ASTR",ASTRSub,"TRAM",TRAMSub),"^",3)
			d TRAppMethods.%Push(TRAMObj)
		}
		s ASTRObj.tabTRAppMethodInfo=TRAppMethods
		s TRClinicGroup=[]
		s TRAMSub=0 for{
			s TRAMSub=$O(^RBAS(ResRowid,ASSub,"ASTR",ASTRSub,"TRCG",TRAMSub)) Q:TRAMSub=""
			s TRAMObj={}
			s TRAMObj.TRClinicGroupRowid=ASRowid_"||"_ASTRSub_"||"_TRAMSub
			s TRAMObj.ClinicGroupMethodID=$P(^RBAS(ResRowid,ASSub,"ASTR",ASTRSub,"TRCG",TRAMSub),"^",1)
			s TRAMObj.ClinicGroup=$P(^RBC("CLGRP",TRAMObj.ClinicGroupMethodID),"^",2)
			s TRAMObj.Qty=$P(^RBAS(ResRowid,ASSub,"ASTR",ASTRSub,"TRCG",TRAMSub),"^",2)
			d TRClinicGroup.%Push(TRAMObj)
		}
		s ASTRObj.tabTRClinicGroupInfo=TRClinicGroup
		s TmpSort("GetTRInfoNew",SttTime)=ASTRObj
		;d TimeRanges.%Push(ASTRObj)
	}
	s l1="" for {
		s l1=$o(TmpSort("GetTRInfoNew",l1))
		q:l1=""
		d TimeRanges.%Push(TmpSort("GetTRInfoNew",l1))
	}
	Q TimeRanges.%ToJSON()
}

ClassMethod AddScheduleLog(ASRowid, UserID, Type, ASULNotes)
{
	s object = ##class(User.DHCRBApptScheduleUpdateLog).%New()
	s object.ASULRBASDR=ASRowid
	s object.ASULUpdateDate=..%SysDate()
	s object.ASULUpdateTime=..%SysTime()
	s object.ASLUpdateUser=UserID
	s object.ASULType=Type
	s object.ASULNotes=ASULNotes
	s sc = object.%Save()
	If $$$ISERR(sc) {
		Q 100
	}
	Q 0
}

ClassMethod StopOneSchedule(ASRowid As %String, StopReasonID As %String, AuditUserID As %String, StatusCode As %String = "S")
{
	s retObj={}
	s ret=##class(web.DHCRBApptSchedule).StopOneSchedule(ASRowid,StopReasonID,AuditUserID,StatusCode)
	s retObj.Code=ret
	if ret=0{
		s retObj.msg="停诊成功"
		s retObj.Schedule=..GetScheduleSingleInfo(ASRowid)
	}else{
		s retObj.msg=ret
	}
	Q retObj.%ToJSON()
}

ClassMethod CancelStopOneSchedule(ASRowid)
{
	s retObj={}
	s ret=##class(web.DHCRBApptSchedule).CancelStopOneSchedule(ASRowid)
	s retObj.Code=ret
	if ret=0{
		s retObj.msg="撤销停诊成功"
		s retObj.Schedule=..GetScheduleSingleInfo(ASRowid)
	}else{
		s retObj.msg=ret
	}
	Q retObj.%ToJSON()
}

ClassMethod ReplaceOneSchedule(ASRowid As %String, ReplaceDoctorID As %String, ReplaceLocationID As %String, ReplaceReasonID As %String, AuditUserID As %String, ReplaceSessionTypeID)
{
	s retObj={}
	s ret=##class(web.DHCRBApptSchedule).ReplaceOneSchedule(ASRowid,ReplaceDoctorID,ReplaceLocationID,ReplaceReasonID,AuditUserID,ReplaceSessionTypeID)
	s retObj.Code=ret
	if ret=0{
		s retObj.msg="替诊成功"
		s retObj.OldSchedule=..GetScheduleSingleInfo(ASRowid)
		s RBASDR=$P(^RBAS(+ASRowid,$P(ASRowid,"||",2),"DHC"),"^",12)
		s retObj.NewSchedule=..GetScheduleSingleInfo(RBASDR)
	}else{
		i ret=200 s ret="替诊医生该时段已经有排班记录"
		s retObj.msg=ret
	}
	Q retObj.%ToJSON()
}

Query QueryLoc(UserID) As %Query(ROWSPEC = "LocRowid,LocDesc")
{
}

ClassMethod QueryLocExecute(ByRef qHandle As %Binary, UserID) As %Status
{
	s LocID=0 f  s LocID=$O(^User.DHCUserGroupI("UserLocDoc"," REG"," "_UserID,LocID)) Q:LocID=""  d
	.s LocRowid=$TR(LocID," ")
	.s LocDesc=$P($G(^CTLOC(LocRowid)),"^",2)
	.q:LocDesc=""
	.if LocDesc'["-" d
	..s RCode=$P($G(^CTLOC(LocRowid)),"^",43)
	..s:RCode'="" LocDesc=LocDesc_"-"_$ZCVT(RCode,"U")
	.s qHandle($I(ind))=$LB(LocRowid,LocDesc)
	Quit $$$OK
}

ClassMethod QueryLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryLocExecute ]
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

Query QueryDoc(UserID, LocRowid) As %Query(ROWSPEC = "DocRowid,DocName")
{
}

ClassMethod QueryDocExecute(ByRef qHandle As %Binary, UserID, LocRowid) As %Status
{
	s DocID=0 f  s DocID=$O(^User.DHCUserGroupI("UserLocDoc"," REG"," "_UserID," "_LocRowid,DocID)) Q:DocID=""  d
	.s DocRowid=$TR(DocID," ")
	.s DocName=$P($G(^CTPCP(DocRowid,1)),"^",2)
	.q:DocName=""
	.s RCode=$P($G(^CTPCP(DocRowid,3)),"^",28)
	.s:RCode'="" DocName=DocName_"-"_RCode
	.s qHandle($I(ind))=$LB(DocRowid,DocName)
	Quit $$$OK
}

ClassMethod QueryDocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryDocExecute ]
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

/// w ##class(DHCDoc.OPAdm.Schedule).GetDocDefaultData(1,104,1,1)
ClassMethod GetDocDefaultData(LocRowid, DocRowid, TimeRangeId = "", WeekNo = "")
{
	s retObj={}
	s ResRowid=$O(^RB("RES",0,"CTPCP",DocRowid,LocRowid,0))
	if ResRowid'=""{
		if (TimeRangeId'="")&(WeekNo'=""){
			s SessRowid=""
			&SQL(SELECT SESS_RowId INTO :SessRowid FROM SQLUser.RB_ResEffDateSession 
				WHERE SESS_ParRef->DATE_ParRef=:ResRowid AND SESS_DOW_DR->DOW_Sequence=:WeekNo AND SESS_SessionNo=:TimeRangeId)
			if SessRowid'=""{
				s SessObj={}.%FromJSON(##class(DHCDoc.OPAdm.ScheduleTemp).GetSessInfo(SessRowid))
				s retObj.ASLoad=SessObj.ASLoad
				s retObj.AppStartNo=SessObj.AppStartNo
				s retObj.AppLoad=SessObj.AppLoad
				s retObj.AddLoad=SessObj.AddLoad
				s retObj.SessType=SessObj.SessType
				s retObj.ClincGroup=SessObj.ClincGroup
				s retObj.Room=SessObj.Room
				s retObj.TRFlag=SessObj.TRFlag
				s retObj.tabAppMethodInfo=SessObj.tabAppMethodInfo
				s retObj.tabTRInfo=SessObj.tabTRInfo
				Q retObj.%ToJSON()
			}
		}
		s resObj=##Class(User.DHCRBResource).%OpenId(ResRowid)
		s retObj.ASLoad=resObj.RESLoad
		s retObj.AppStartNo=resObj.RESAppStartNum
		s retObj.AppLoad=resObj.RESAppLoad
		s retObj.AddLoad=resObj.RESAddLoad
		s retObj.SessType=resObj.RESSessionTypeDRGetObjectId()
		s retObj.ClincGroup=resObj.RESClinicGroupDRGetObjectId()
	}
	Q retObj.%ToJSON()
}

/// w ##class(%ResultSet).RunQuery("DHCDoc.OPAdm.Schedule","QueryTimeRange")
Query QueryTimeRange() As %SQLQuery(ROWSPEC = "id:%String,text:%String,SttTime:%String,EndTime:%String")
{
	SELECT TR_RowId AS id,TR_Desc AS text,TO_CHAR(TR_StartTime,'HH24:MI') AS SttTime,TO_CHAR(TR_EndTime,'HH24:MI') AS EndTime FROM SQLUser.DHC_TimeRange WHERE TR_ValidEndDate IS NULL OR TR_ValidEndDate>+$H
}

Query QuerySessType() As %SQLQuery
{
	SELECT SESS_RowId AS SessRowid, SESS_Desc AS SessDesc FROM SQLUser.RBC_SessionType
}

/// w ##class(%ResultSet).RunQuery("DHCDoc.OPAdm.Schedule","QueryAppMethod")
Query QueryAppMethod() As %SQLQuery
{
	SELECT APTM_RowId AS id, APTM_Desc AS text FROM SQLUser.RBC_AppointMethod WHERE APTM_DateTo IS NULL OR APTM_DateTo>+$H
}

Query QueryClinicGroup(LocId As %String = "") As %SQLQuery
{
	select A.CLGRP_RowId AS CGRowid,A.CLGRP_Desc AS CGDesc, A.CLGRP_Code AS CGCode from SQLUser.RBC_ClinicGroup A,SQLUser.DHC_LocSpec B
		WHERE ((A.CLGRP_DateFrom <= +$h) OR (A.CLGRP_DateFrom IS NULL))
		AND  ((A.CLGRP_DateTo>= +$h) OR (A.CLGRP_DateTo IS NULL) )
		AND ((A.CLGRP_RowId=B.DHCLS_CG_DR)AND(B.DHCLS_Loc_DR=:LocId) )
}

Query QueryClinicGroupNew(HospID As %String = "") As %SQLQuery
{
	select distinct A.CLGRP_RowId, A.CLGRP_RowId AS CGRowid,A.CLGRP_Desc AS CGDesc, A.CLGRP_Code AS CGCode from SQLUser.RBC_ClinicGroup A,SQLUser.DHC_LocSpec B
		WHERE ((A.CLGRP_DateFrom <= +$h) OR (A.CLGRP_DateFrom IS NULL))
		AND  ((A.CLGRP_DateTo>= +$h) OR (A.CLGRP_DateTo IS NULL) )
		AND ((A.CLGRP_RowId=B.DHCLS_CG_DR)AND(B.DHCLS_Loc_DR->CTLOC_Hospital_DR=:HospID) )
}

Query QueryRoom(desc = "") As %SQLQuery
{
	SELECT CTLOC_RowID AS RoomRowid,CTLOC_Desc AS RoomDesc FROM SQLUser.CT_Loc WHERE CTLOC_Type='OR' 
		AND (CTLOC_Desc %STARTSWITH :desc OR CTLOC_Code %STARTSWITH :desc)
}

Query QueryReasonNotAvailQuery() As %SQLQuery(CONTAINID = 1)
{
	 select %ID AS TID,
	 RNAV_Code AS TRNAVCode,
	 RNAV_DateFrom AS TRNAVDateFrom,
	 RNAV_DateTo AS TRNAVDateTo,
	 RNAV_Desc AS TRNAVDesc,
	 RNAV_Type AS TRNAVType
	 from sqluser.RBC_ReasonNotAvail WHERE RNAV_DateTo IS NULL Order By RNAV_Code
}

Query LookUpUser(desc As %String) As %Library.SQLQuery(CONTAINID = 1)
{
	SELECT TOP 50 SSUSR_RowId As Rowid,SSUSR_Name||'-'||SSUSR_Initials As Name FROM SQLUser.SS_User 
		WHERE (SSUSR_Name %STARTSWITH :desc or SSUSR_Initials %STARTSWITH :desc or SSUSR_CareProv_DR->CTPCP_OtherName %STARTSWITH :desc)
		AND ((SSUSR_DateTo>= :date) OR (SSUSR_DateTo IS NULL) )
}

/// 停号状态
Parameter StopStatus = 7;

ClassMethod ShowAvailSeqNo(ASRowid)
{
	s retArr=[]
	s StopStatus=..#StopStatus
	s ResRowid=+ASRowid,ASSub=$P(ASRowid,"||",2)
	s ASQueueNo=$P(^RBAS(ResRowid,ASSub,"DHC"),"^",4)
	s NormalQueueNoStr=$P(ASQueueNo,$C(1),1)
	s AddQueueNoStr=$P(ASQueueNo,$C(1),2)
	s ASQueueNoStr=NormalQueueNoStr_","_AddQueueNoStr
	s len=$L(ASQueueNoStr,",")
	f i=1:1:len{
		s SingleQueueNoStr=$P(ASQueueNoStr,",",i)
		continue:SingleQueueNoStr=""
		s StatusCode=$P(SingleQueueNoStr,":",2)
		if (StatusCode=0)!(StatusCode=StopStatus)!('##class(web.DHCRBAppointment).GetReturnAllowRegFlag(StatusCode)){
			s SeqNo=$P(SingleQueueNoStr,":",1)
			d retArr.%Push({"QueueNo":(SeqNo),"StatusCode":(StatusCode)})
		}
	}
	Q retArr.%ToJSON()
}

/// 停单个号 QueueNo为空 停/撤销停 全部
ClassMethod StopQueueNo(ASRowid, QueueNo, NewStatusCode, UserID)
{
	s StopStatus=..#StopStatus
	s ResRowid=+ASRowid,ASSub=$P(ASRowid,"||",2)
	lock +^RBASLOCK(ResRowid,ASSub)
	s ASQueueNo=$P(^RBAS(ResRowid,ASSub,"DHC"),"^",4)
	s NormalQueueNoStr=$P(ASQueueNo,$C(1),1)
	s AddQueueNoStr=$P(ASQueueNo,$C(1),2)
	s ASQueueNoStr=NormalQueueNoStr_","_AddQueueNoStr
	s len=$L(ASQueueNoStr,",")
	s NorLen=$L(NormalQueueNoStr,",")
	s UpdateSeqNoStr=""
	f i=1:1:len{
		s SingleQueueNoStr=$P(ASQueueNoStr,",",i)
		continue:SingleQueueNoStr=""
		s SeqNo=$P(SingleQueueNoStr,":",1)
		if (SeqNo=QueueNo)!(QueueNo=""){
			s StatusCode=$P(SingleQueueNoStr,":",2)
			if (NewStatusCode=0)&(StatusCode'=StopStatus){
				continue
			}elseif (NewStatusCode=StopStatus){
				if ((StatusCode'=0)&&(##class(web.DHCRBAppointment).GetReturnAllowRegFlag(StatusCode))){
					continue
				}
			}
			i SeqNo["+" s $P(AddQueueNoStr,",",i-NorLen)=SeqNo_":"_NewStatusCode
			e  s $P(NormalQueueNoStr,",",i)=SeqNo_":"_NewStatusCode
			i UpdateSeqNoStr="" s UpdateSeqNoStr=SeqNo
			e  s UpdateSeqNoStr=UpdateSeqNoStr_","_SeqNo
		}
	}
	
	i NewStatusCode=StopStatus s Action="停号"
	e  s Action="撤销停号"	
	s ASULNotes=Action_":"_UpdateSeqNoStr
	d ..AddScheduleLog(ASRowid,UserID,"U",ASULNotes)
	
	s $P(^RBAS(ResRowid,ASSub,"DHC"),"^",4)=NormalQueueNoStr_$C(1)_AddQueueNoStr
	lock -^RBASLOCK(ResRowid,ASSub)
	Q 0
}

/// 1.非分时段模式:也认为是分时段模式,认为是一个段
/// 2.分时段模式:
/// 	a.分时段维护了预约方式，考虑其他方式保留号与本身最大预约数
/// 	b.分时段没有维护该预约方式,考虑时段其他预约方式维护保留号的剩余,且要该预约方式其他时段已维护的保留
/// w ##class(DHCDoc.OPAdm.Schedule).GetAppAvailSeqNo("1085||898","","15:00","16:00")
ClassMethod GetAppAvailSeqNo(ASRowid, AppMethodID = "", SttTime = "", EndTime = "", ByRef AvailQty = "", ByRef AppMaxQty = "")
{
	s AvailQty=0
	s:AppMethodID="" AppMethodID=$O(^RBC("APTM",0,"Code","WIN",0))
	s ResRowid=$P(ASRowid,"||",1),ASSub=$P(ASRowid,"||",2)
	s AppQty=$p(^RBAS(ResRowid,ASSub),"^",2)
	s (AppMaxQty,AppReserveQty,OtherReservSum)=""
	s ASQSub=0 f  s ASQSub=$O(^RBAS(ResRowid,ASSub,"AQ",ASQSub)) Q:ASQSub=""  d
	.s MethodID=$P(^RBAS(ResRowid,ASSub,"AQ",ASQSub),"^",1)
	.q:MethodID=""
	.i MethodID=AppMethodID d
	..s AppMaxQty=$P(^RBAS(ResRowid,ASSub,"AQ",ASQSub),"^",4)
	..s AppReserveQty=$P(^RBAS(ResRowid,ASSub,"AQ",ASQSub),"^",2)
	.e  d
	..s ReserveQty=$P(^RBAS(ResRowid,ASSub,"AQ",ASQSub),"^",2)
	..s OtherReservSum=OtherReservSum+ReserveQty
	;重新计算可预约最大数量(减去其他预约方式的保留号)
	s LeftQty=AppQty-OtherReservSum
	s:(LeftQty<AppMaxQty)!(AppMaxQty="") AppMaxQty=LeftQty
	Q:AppMaxQty<=0 ""
	s AppStartNo=$p(^RBAS(ResRowid,ASSub),"^",10)
	s:AppStartNo="" AppStartNo=1
	s AppEndNo=AppStartNo+AppQty-1
	s SttTime=##class(websys.Conversions).TimeHtmlToLogical(SttTime)
	s EndTime=##class(websys.Conversions).TimeHtmlToLogical(EndTime)
	s:SttTime="" SttTime=$P(^RBAS(ResRowid,ASSub),"^",4)
	s:EndTime="" EndTime=$P(^RBAS(ResRowid,ASSub),"^",5)
	s TRFlag=$p(^RBAS(ResRowid,ASSub,"DHC"),"^",19)	
	i TRFlag="Y" d ;各个分时段预约方式分配情况
	.s EndNo=0,TRAMMaxQtySum=0,TRAMReserveQtySum=0
	.s ASTRSub=0 f  s ASTRSub=$O(^RBAS(ResRowid,ASSub,"ASTR",ASTRSub)) Q:ASTRSub=""  d
	..s TRLoad=$P(^RBAS(ResRowid,ASSub,"ASTR",ASTRSub),"^",3)
	..s SttNo=EndNo+1,EndNo=EndNo+TRLoad
	..s TRSttNo=$CASE(SttNo<AppStartNo,1:AppStartNo,:SttNo)
	..s TREndNo=$CASE(EndNo>AppEndNo,1:AppEndNo,:EndNo)
	..q:TRSttNo>TREndNo
	..s LeftQty=TRLoad,TRAMMaxQty="",TRAMReserveQty="",MethodExistFlag=0
	..s TRAMSub=0 f  s TRAMSub=$O(^RBAS(ResRowid,ASSub,"ASTR",ASTRSub,"TRAM",TRAMSub)) Q:TRAMSub=""  d
	...s TRAMAppMethodID=$P(^RBAS(ResRowid,ASSub,"ASTR",ASTRSub,"TRAM",TRAMSub),"^",1)
	...i TRAMAppMethodID=AppMethodID d
	....s MethodExistFlag=1
	....s TRAMMaxQty=$P(^RBAS(ResRowid,ASSub,"ASTR",ASTRSub,"TRAM",TRAMSub),"^",2)
	....s TRAMReserveQty=$P(^RBAS(ResRowid,ASSub,"ASTR",ASTRSub,"TRAM",TRAMSub),"^",3)
	....s TRAMMaxQtySum=TRAMMaxQtySum+TRAMMaxQty,TRAMReserveQtySum=TRAMReserveQtySum+TRAMReserveQty
	...e  d
	....s LeftQty=LeftQty-$P(^RBAS(ResRowid,ASSub,"ASTR",ASTRSub,"TRAM",TRAMSub),"^",3)
	..i TRAMMaxQty>LeftQty s TRAMMaxQty=LeftQty	;最大数不能大于时段号数减去其他保留号的剩余
	..s TRNoStr=TRSttNo_"-"_TREndNo
	..i 'MethodExistFlag s TRAMReserveQty=0,TRAMMaxQty=LeftQty
	..s TRSttTime=$P(^RBAS(ResRowid,ASSub,"ASTR",ASTRSub),"^",1)
	..s TREndTime=$P(^RBAS(ResRowid,ASSub,"ASTR",ASTRSub),"^",2)
	..s TRContainFlag=(TRSttTime>=SttTime)&&(TREndTime<=EndTime)
	..i 'MethodExistFlag&&TRContainFlag d	;没有维护该预约方式,时段满足
	...s NoStr=$P($G(TRList("NoMethodTR")),"^",1)
	...s NoStr=$CASE(NoStr="",1:TRNoStr,:NoStr_","_TRNoStr)
	...s TRAMMaxQty=TRAMMaxQty+$P($G(TRList("NoMethodTR")),"^",3)
	...s TRList("NoMethodTR")=NoStr_"^"_TRAMReserveQty_"^"_TRAMMaxQty
	..e  i MethodExistFlag&&TRContainFlag d	;维护了该预约方式,时段满足
	...s node=$O(TRList("MethodTR",""),-1)+1
	...s TRList("MethodTR",node)=TRNoStr_"^"_TRAMReserveQty_"^"_TRAMMaxQty
	.i $D(TRList("NoMethodTR")) d
	..s NoStr=$P(TRList("NoMethodTR"),"^",1)
	..s MethodLeftMaxQty=AppMaxQty-TRAMMaxQtySum
	..s MethodLeftReserveQty=AppReserveQty-TRAMReserveQtySum
	..s TRAMMaxQty=$P(TRList("NoMethodTR"),"^",3)
	..s:TRAMMaxQty>MethodLeftMaxQty TRAMMaxQty=MethodLeftMaxQty
	..s TRList("NoMethodTR")=NoStr_"^"_MethodLeftReserveQty_"^"_TRAMMaxQty
	e  d	;不是分时段,当成只有一个段的分时段
	.s TRNoStr=AppStartNo_"-"_AppEndNo
	.s TRList("MethodTR",1)=TRNoStr_"^"_AppReserveQty_"^"_AppMaxQty
	
	s MethodUsedQty=0
	s ASQueueNo=$P(^RBAS(ResRowid,ASSub,"DHC"),"^",4)
	s NormalQueueNoStr=$P(ASQueueNo,$C(1),1)
	s len=$l(NormalQueueNoStr,",")
	f i=1:1:len{
		s SingleQueueNoStr=$P(NormalQueueNoStr,",",i)
		s QueueNo=$P(SingleQueueNoStr,":",1)
		continue:(QueueNo<AppStartNo)!(QueueNo>AppEndNo)
		s QueueStatus=$P(SingleQueueNoStr,":",2)
		s MethodID=$P(SingleQueueNoStr,":",3)
		if ("123"[QueueStatus)&(MethodID=AppMethodID){
			Q:$I(MethodUsedQty)>=AppMaxQty
		}
		s QueueNoList(QueueNo)=$P(SingleQueueNoStr,":",2,3)
	}
	Q:MethodUsedQty>=AppMaxQty ""
	
	s node=0 f  s node=$O(TRList("MethodTR",node)) q:node=""  d
	.s TRNoStr=$P(TRList("MethodTR",node),"^",1)
	.s MaxQty=$P(TRList("MethodTR",node),"^",3)
	.d GetOneQtyRange
	i $D(TRList("NoMethodTR")) d
	.s TRNoStr=$P(TRList("NoMethodTR"),"^",1)
	.s MaxQty=$P(TRList("NoMethodTR"),"^",3)
	.d GetOneQtyRange
	s TotalCount=0
	s AvailSeqNoStr=""	;从小到大排序输出
	s QueueNo="" f  s QueueNo=$O(AvailNoList(QueueNo)) q:QueueNo=""  d
	.i AvailSeqNoStr="" s AvailSeqNoStr=AvailNoList(QueueNo)
	.e  s AvailSeqNoStr=AvailSeqNoStr_","_AvailNoList(QueueNo)
	.s TotalCount=TotalCount+1
	s:TotalCount<AvailQty AvailQty=TotalCount
	Q AvailSeqNoStr
GetOneQtyRange
	Q:MaxQty<=0
	s UsedQty=0
	k OneAvailNoList
	for i=1:1:$L(TRNoStr,","){
		s OneAvailSeqNoStr=""
		s oneTRNOStr=$P(TRNoStr,",",i)
		s SttNo=$P(oneTRNOStr,"-",1),EndNo=$P(oneTRNOStr,"-",2)
		for QueueNo=SttNo:1:EndNo{
			continue:'$D(QueueNoList(QueueNo))
			s QueueStatus=$P(QueueNoList(QueueNo),":",1)
			if (QueueStatus=0)!('##class(web.DHCRBAppointment).GetReturnAllowRegFlag(QueueStatus)){
				k QueueNoList(QueueNo)
				i OneAvailSeqNoStr="" s OneAvailSeqNoStr=QueueNo
				e  s OneAvailSeqNoStr=OneAvailSeqNoStr_","_QueueNo
			}elseif "123"[QueueStatus{
				s MethodID=$P(QueueNoList(QueueNo),":",2)
				if MethodID=AppMethodID{
					if $I(UsedQty)>MaxQty{
						k OneAvailNoList
						Q
					}
				}
			}
		}
		Q:UsedQty>=MaxQty
		if OneAvailSeqNoStr'=""{
			s OneAvailNoList($P(OneAvailSeqNoStr,","))=OneAvailSeqNoStr
		}
	}
	s AvailQty=AvailQty+MaxQty-UsedQty
	m AvailNoList=OneAvailNoList
	Q
}

ClassMethod CheckBeforeInsert(ResRowid, ASDate, TRRowid, RoomId)
{
	s ErrMsg=""
	s LocID=$P(^RB("RES",ResRowid),"^",1)
	s LocDesc=$P(^CTLOC(LocID),"^",2)
	s:LocDesc["-" LocDesc=$P(LocDesc,"-",2)
	s ResDesc=$P(^RB("RES",ResRowid),"^",17)
	s ASInfo=LocDesc_ResDesc_$ZD(ASDate,3)_$P(^DHCTimeRange(TRRowid),"^",2)_"生成失败:"
	s SessSttTime="" for{
		s SessSttTime=$O(^RBAS(ResRowid,0,"DateSTime",ASDate,SessSttTime)) Q:SessSttTime=""
		s ASSub=0 for{
			s ASSub=$O(^RBAS(ResRowid,0,"DateSTime",ASDate,SessSttTime,ASSub)) Q:ASSub=""
			s TimeRangeID=$P(^RBAS(ResRowid,ASSub,"DHC"),"^",17)
			if ##class(DHCDoc.OPAdm.ScheduleTemp).TimeRangeContain(TimeRangeID,TRRowid){
				s TimeRange=$P(^DHCTimeRange(TimeRangeID),"^",2)
				s ErrMsg=ASInfo_"已有"_TimeRange_"排班"
				Q
			}
		}
		Q:ErrMsg
	}
	Q:ErrMsg ErrMsg
	/*if RoomId'=""{
		s RBResRowid=0 for{
			s RBResRowid=$O(^RBAS(0,"DateRoom",ASDate,RoomId,RBResRowid)) Q:RBResRowid=""
			s ASSub=0 for{
				s ASSub=$O(^RBAS(0,"DateRoom",ASDate,RoomId,RBResRowid,ASSub)) Q:ASSub=""
				s TimeRangeID=$P(^RBAS(RBResRowid,ASSub,"DHC"),"^",17)
				if ##class(DHCDoc.OPAdm.ScheduleTemp).TimeRangeContain(TimeRangeID,TRRowid){
					s TimeRange=$P(^DHCTimeRange(TimeRangeID),"^",2)
					s Room=$P(^CTLOC(RoomId),"^",2)
					s:Room["-" Room=$P(Room,"-",2)
					s ErrMsg=ASInfo_TimeRange_Room_"已有"_$P(^RB("RES",RBResRowid),"^",17)_"坐诊"
					Q
				}
			}
			Q:ErrMsg
		}
	}*/
	Q ErrMsg
}

ClassMethod CreateByScheduleTemp(ASDate, SessRowid) As %String
{
	s ResRowid=+SessRowid
	s ASDateCreate=..%SysDate()
	s ASTimeCreate=..%SysTime()
	s ASDate=..%ZDH(ASDate)
	s SessObj=##class(User.RBResEffDateSession).%OpenId(SessRowid)
	if '$IsObject(SessObj){
		Q -100
	}
	Q:+SessObj.SESSLoad=0 -101
	s ErrMsg=..CheckBeforeInsert(ResRowid,ASDate,SessObj.SESSSessionNo,SessObj.SESSRoomDRGetObjectId())
	if ErrMsg'=""{
		Q -1_"^"_ErrMsg
	}
	s ASStatusDR=""
	&SQL(Select ASS_Rowid into :ASStatusDR from SQLUser.DHC_RBCASStatus Where ASS_Code='N')
	if ASStatusDR=""{
		Q -1
	}
	TS
	s SessSttTime=SessObj.SESSTimeStart
	s SessEndTime=SessObj.SESSTimeEnd
	s TimeRangeID=SessObj.SESSSessionNo
	s SESSNoLimitLoadFlag=SessObj.SESSNoLimitLoadFlag
	if (SessSttTime="")&&(TimeRangeID'="") s SessSttTime=$P(^DHCTimeRange(TimeRangeID),"^",3)
	if (SessEndTime="")&&(TimeRangeID'="") s SessEndTime=$P(^DHCTimeRange(TimeRangeID),"^",4)
	s object = ##class(User.RBApptSchedule).%New(ResRowid)
	d object.ASRESParRefSetObjectId(ResRowid)
	s object.ASDate=ASDate
	s:SessSttTime'="" object.ASSessStartTime=SessSttTime
	s:SessEndTime'="" object.ASSessEndTime=SessEndTime
	s object.ASNoApptSession=SessObj.SESSNoApptSlot
	s:+object.ASNoApptSession=0 object.ASNoApptSession=1
	s object.ASLoad=SessObj.SESSLoad
	s object.ASAvailability=1
	s object.ASQueueNoCount=SessObj.SESSNumberOfWeeks
	d object.ASRBEffDateSessionDRSetObjectId(SessRowid)
	s object.ASNumPatIn=0
	s object.ASNumPatOut=0
	s object.ASSession=0
	s object.ASLastUpdateDate=ASDateCreate
	s object.ASLastUpdateTime=ASTimeCreate
	S sc = object.%Save()
	If $$$ISERR(sc) {
		;Do $System.Status.DisplayError()
		Trollback
		Quit 100
	}
	d object.%Close()
	s ASChildsub=object.ASChildSub
	s ASRowid=object.%Id()
	
	s object = ##class(User.DHCRBApptSchedule).%OpenId(ASRowid)
	d object.ASRESParRefSetObjectId(ResRowid)
	s object.ASChildsub=ASChildsub
	s object.ASNoOverbookAllowed=SessObj.SESSNoOverbookAllowed
	s object.ASQueueNo=##class(web.DHCRBResourceRule).GenerateQueueNO(SessObj.SESSLoad,SessObj.SESSNoOverbookAllowed,SESSNoLimitLoadFlag)
	s object.ASRoomDR=SessObj.SESSRoomDR
	s object.ASSessionTypeDR=SessObj.SESSSessionTypeDR
	s object.ASClinicGroupDR=SessObj.SESSClinicGroupDR
	s object.ASDateCreate=ASDateCreate
	s object.ASTimeCreate=ASTimeCreate
	d object.ASStatusDRSetObjectId(ASStatusDR)
	s object.ASDate=ASDate
	s object.ASTimeRangeFlag=SessObj.SESSTimeRangeFlag
	d object.ASTimeRangeDRSetObjectId(TimeRangeID)
	s object.ASNoLimitLoadFlag=SESSNoLimitLoadFlag
	s sc = object.%Save()
	If $$$ISERR(sc) {
		;Do $System.Status.DisplayError()
		Trollback
		Quit 100
	}
	s err=0
	s DateSub=$P(SessRowid,"||",2),SessSub=$P(SessRowid,"||",3)
	;预约方式复制
	s AQSub=0 for{
		s AQSub=$O(^RB("RES",ResRowid,"Date",DateSub,"SESS",SessSub,"AQ",AQSub)) Q:AQSub=""
		s AQStr=^RB("RES",ResRowid,"Date",DateSub,"SESS",SessSub,"AQ",AQSub)
		s AppMethodID=$P(AQStr,"^",1)
		continue:AppMethodID=""
		s AMQObj=##class(User.DHCRBApptScheduleAppQty).%New(ASRowid)
		d AMQObj.ASQASParRefSetObjectId(ASRowid)
		d AMQObj.ASQMethodDRSetObjectId(AppMethodID)
		s AMQObj.ASQStartNum=$P(AQStr,"^",3)
		s AMQObj.ASQQty=$P(AQStr,"^",2)
		s AMQObj.ASQMaxQty=$P(AQStr,"^",4)
		s sc=AMQObj.%Save()
		if $$$ISERR(sc){
			s err=101
			Q
		}
	}
	if err{
		TRO
		Q err
	}
	;分时段预约信息复制
	s TRSub=0 for{
		s TRSub=$O(^RB("RES",ResRowid,"DATE",DateSub,"SESS",SessSub,"TR",TRSub)) Q:TRSub=""
		s TRObj=##class(User.RBResEffDateSessionTR).%OpenId(SessRowid_"||"_TRSub)
		continue:'$IsObject(TRObj)
		s ASTRObj=##class(User.RBApptScheduleTR).%New(ASRowid)
		d ASTRObj.ASTRParRefSetObjectId(ASRowid)
		s ASTRObj.ASTRSttTime=TRObj.STRSttTime
		s ASTRObj.ASTREndTime=TRObj.STREndTime
		s ASTRObj.ASTRLoad=TRObj.STRLoad
		s sc=ASTRObj.%Save()
		if $$$ISERR(sc){
			s err=102
			Trollback
			Q 
		}
		s ASTRRowid=ASTRObj.%Id()
		s TRAMSub=0 for{
			s TRAMSub=$O(^RB("RES",ResRowid,"DATE",DateSub,"SESS",SessSub,"TR",TRSub,"TRAM",TRAMSub)) Q:TRAMSub=""
			s AMObj=##class(User.RBResEffDateSessionTRAppMethod).%OpenId(SessRowid_"||"_TRSub_"||"_TRAMSub)
			continue:'$IsObject(AMObj)
			s TRAMObj=##class(User.RBApptScheduleTRAppMethod).%New(ASTRRowid)
			d TRAMObj.ASTRAMParRefSetObjectId(ASTRRowid)
			s TRAMObj.ASTRAMMethodDR=AMObj.STRAMMethodDR
			s TRAMObj.ASTRAMMaxQty=AMObj.STRAMMaxQty
			s TRAMObj.ASTRAMReserveQty=AMObj.STRAMReserveQty
			s sc=TRAMObj.%Save()
			if $$$ISERR(sc){
				s err=103
				Trollback
				Q 
			}
		}
		Q:err
	}
	s err=..SaveAppMethodQueue(ASRowid)
	if err{
		TRO
		Q err
	}
	TC
	//调用平台组接口
	s rtn=##class(web.DHCENS.EnsHISService).DHCHisInterface("S00000003",ASRowid)
	Q 0
}

/// 将老分时段数据插入新分时段的表,只处理当前日期以后的排班
/// DHC_RBApptScheduleAppQty扩展可预约最大数的字段默认为原预约数量
/// d ##class(DHCDoc.OPAdm.Schedule).TRInfoOldToNew()
ClassMethod TRInfoOldToNew()
{
	s ResRowid=0 f  s ResRowid=$O(^RBAS(ResRowid)) Q:ResRowid=""  d
	.s ASDate=..%SysDate() f  s ASDate=$O(^RBAS(ResRowid,0,"DateSTime",ASDate)) q:ASDate=""  d
	..s SessSttTime="" f  s SessSttTime=$O(^RBAS(ResRowid,0,"DateSTime",ASDate,SessSttTime)) q:(SessSttTime="")  d
	...s ASSub=0  f  s ASSub=$O(^RBAS(ResRowid,0,"DateSTime",ASDate,SessSttTime,ASSub)) q:(ASSub="")  d
	....s ASQSub=0 f  s ASQSub=$O(^RBAS(ResRowid,ASSub,"AQ",ASQSub)) q:ASQSub=""  d
	.....s ReserveQty=$P(^RBAS(ResRowid,ASSub,"AQ",ASQSub),"^",2)
	.....s MaxQty=$P(^RBAS(ResRowid,ASSub,"AQ",ASQSub),"^",4)
	.....if MaxQty<ReserveQty d
	......s ASQRowid=ResRowid_"||"_ASSub_"||"_ASQSub
	......&SQL(UPDATE SQLUser.DHC_RBApptScheduleAppQty SET ASQ_MaxQty=:ReserveQty WHERE ASQ_RowId=:ASQRowid)
	......w ASQRowid,":",SQLCODE,!
	....s ASTRSub=$O(^RBAS(ResRowid,ASSub,"ASTR",0))
	....q:ASTRSub'=""	;已经有新的分时段数据
	....s TimeStr=$P(^RBAS(ResRowid,ASSub,"DHC"),"^",25)
	....q:TimeStr=""
	....s NumStr=$P(^RBAS(ResRowid,ASSub,"DHC"),"^",24)
	....s TRInfoObj=[]
	....for i=1:1:$L(TimeStr,",") d
	.....s obj={}
	.....s oneTimeStr=$P(TimeStr,",",i)
	.....s obj.SttTime=$P(oneTimeStr,"-",1)
	.....s obj.EndTime=$P(oneTimeStr,"-",2)
	.....s oneNumStr=$P(NumStr,",",i)
	.....s obj.Load=$P(oneNumStr,"-",2)-$P(oneNumStr,"-",1)+1
	.....d TRInfoObj.%Push(obj)
	....s ASRowid=ResRowid_"||"_ASSub
	....s retObj=..UpdateTRInfo(ASRowid,TRInfoObj)
	....w ASRowid,":",retObj.%ToJSON(),!
	Q 0
}

ClassMethod GetTRASLoad(ASRowID)
{
	q:ASRowID="" 0
	s ResRowid=$P(ASRowID,"||",1)
	s ASSub=$P(ASRowID,"||",2)
	s ASLoad=$P(^RBAS(ResRowid,ASSub),"^",8)
	s ASQueueNo=$P(^RBAS(ResRowid,ASSub,"DHC"),"^",4)
 	s NormalQueueNoStr=$P(ASQueueNo,$C(1),1)
 	s AddQueueNoStr=$P(ASQueueNo,$C(1),2)
 	s CurrentLoad=0
 	s CurrentLoad=$L(NormalQueueNoStr,",")
 	q CurrentLoad
}

/// 根据预约方式的占号数改变正号串的数据
ClassMethod ChangeDHCQueueNo(ScheduleID)
{
	set schedule=##class(User.RBApptSchedule).%OpenId(ScheduleID)
	set oldTotalNum=schedule.ASLoad
	set OldASIrregularFlag=schedule.ASIrregularFlag
	do schedule.%Close()
	set schedule=##class(User.DHCRBApptSchedule).%OpenId(ScheduleID)
	set oldOverBookNum=schedule.ASNoOverbookAllowed
	set oldQueueNo=schedule.ASQueueNo
	set OverBookNum=schedule.ASNoOverbookAllowed
	s TotalNum=##class(DHCDoc.OPAdm.Schedule).GetTRASLoad(ScheduleID)
	set schedule.ASQueueNo=##class(web.DHCRBResourceRule).EditQueueNO(oldQueueNo,oldTotalNum,TotalNum,oldOverBookNum,OverBookNum,ScheduleID)
	Set sc = schedule.%Save()
	If $$$ISERR(sc) {
		Do $System.Status.DisplayError()
		Trollback
		Quit 100
	}
	q 0
}

/// 将分时段预约里，存上对应的号串
ClassMethod SaveAppMethodQueue(ASRowid)
{
	s ^tempqujin("SaveAppMethodQueue")=ASRowid
	s ResRowid=+ASRowid,ASSub=$P(ASRowid,"||",2)
	s TimeRanges=[]
	s ASQueueNo=$P(^RBAS(ResRowid,ASSub,"DHC"),"^",4)
 	s NormalQueueNoStr=$P(ASQueueNo,$C(1),1)
 	s AddQueueNoStr=$P(ASQueueNo,$C(1),2)
 	s OneSttNo=0,OneEndNo=0
 	s err=0
	s ASTRSub=0 for{
		s ASTRSub=$O(^RBAS(ResRowid,ASSub,"ASTR",ASTRSub)) Q:ASTRSub=""
		s ASTRRowid=ASRowid_"||"_ASTRSub
		s TRLoad=$P(^RBAS(ResRowid,ASSub,"ASTR",ASTRSub),"^",3)
		s OneSttNo=OneEndNo+1,OneEndNo=OneEndNo+TRLoad
		s OneStr=""
		for number=OneSttNo:1:OneEndNo{
			s OneQueueStr=$P(NormalQueueNoStr,",",number)
			s OneNo=$P(OneQueueStr,":",1)
			if OneStr="" s OneStr=OneNo_":0"
			else  s OneStr=OneStr_","_OneNo_":0"
			}
		s AMQObj=##class(User.RBApptScheduleTR).%OpenId(ASTRRowid)
		s AMQObj.ASTRQueueNo=OneStr
		s sc=AMQObj.%Save()
		if $$$ISERR(sc){
			s err=106
		}
		
	}
	q err
}

/// 根据预约方式的占号数改变正号串的数据
ClassMethod StopReg(ASRowid, Flag)
{
	
	set schedule=##class(User.DHCRBApptSchedule).%OpenId(ASRowid)
	s schedule.ASStopRegFlag=Flag
	Set sc = schedule.%Save()
	If $$$ISERR(sc) {
		Do $System.Status.DisplayError()
		Trollback
		Quit 100
	}
	q 0
}

/// 查询是否有有效排班或者排班模板
/// w ##class(DHCDoc.OPAdm.Schedule)CheckScheduleActive(12175 ,+$H ,"")
/// 入参：UserID，开始日期,结束日期
/// 出参：0没有，1^存在的科室
ClassMethod CheckScheduleActive(USERID, StDate As %String = "", EndDate As %String = "99999")
{
	q:USERID="" ""
	s CTCareProv9=$p(^SSU("SSUSR",USERID),"^",9)
	s CTCareProv14=$p(^SSU("SSUSR",USERID),"^",14)
	if (StDate="") s StDate=+$H
	if EndDate="" s EndDate=99999
	s CTPCPDR=""
	if ((CTCareProv9'="")||(CTCareProv14'="")){
		if CTCareProv9'="" s CTPCPDR=CTCareProv9
		if CTCareProv14'="" s CTPCPDR=CTCareProv14
	}
	s CTLOCDR=""
	s retScheduleTemp=""
	s retSchedule=""
	for {
		s CTLOCDR=$O(^RB("RES",0,"CTPCP",CTPCPDR,CTLOCDR))
		q:CTLOCDR=""
		q:((retScheduleTemp'="")||(retSchedule'=""))
		s RESRowId=""
		for {
			s RESRowId=$O(^RB("RES",0,"CTPCP",CTPCPDR,CTLOCDR,RESRowId))
			q:RESRowId=""
			q:((retScheduleTemp'="")||(retSchedule'=""))
			s RESDateActiveFrom=$p($g(^RB("RES",RESRowId)),"^",22)
			s RESDateActiveTo=$p($g(^RB("RES",RESRowId)),"^",23)
			s RESScheduleRequired=$p($g(^RB("RES",RESRowId)),"^",6)
			continue:$g(RESScheduleRequired)="N"
			continue:(RESDateActiveFrom'="")&&(RESDateActiveFrom>+$h)
			continue:(RESDateActiveTo'="")&&(RESDateActiveTo<+$h)
			///查询模板
			s DateSub=0
			for {
				s DateSub=$O(^RB("RES",RESRowId,"DATE",DateSub))
				Q:DateSub=""
				q:((retScheduleTemp'="")||(retSchedule'=""))
				S SessSub=0
				for{
					S SessSub=$O(^RB("RES",RESRowId,"DATE",DateSub,"SESS",SessSub))
					q:SessSub=""
					q:((retScheduleTemp'="")||(retSchedule'=""))
					s SessNo=$P(^RB("RES",RESRowId,"DATE",DateSub,"SESS",SessSub),"^",3)
					continue:SessNo=""
					s DOWDR=$P(^RB("RES",RESRowId,"DATE",DateSub,"SESS",SessSub),"^",2)
					continue:DOWDR=""
					s retScheduleTemp=CTLOCDR
				}
				
			}
			//查询排版
			s Startdate=StDate-1 f  s Startdate=$o(^RBAS(RESRowId,0,"DateSTime",Startdate)) q:(Startdate>EndDate)||(Startdate="")||(retScheduleTemp'="")||(retSchedule'="")  d
			.s DateSTime="" f  s DateSTime=$o(^RBAS(RESRowId,0,"DateSTime",Startdate,DateSTime)) q:((DateSTime="")||(retScheduleTemp'="")||(retSchedule'=""))  d
			..s ASChildSub="" f  s ASChildSub=$o(^RBAS(RESRowId,0,"DateSTime",Startdate,DateSTime,ASChildSub)) q:((ASChildSub="")||(retScheduleTemp'="")||(retSchedule'=""))  d
			...s ASStatusDR=$p(^RBAS(RESRowId,ASChildSub,"DHC"),"^",10)
			...s ASStatusCode=$P(^DHCRBCASStatus(ASStatusDR),"^",1)
			...q:((ASStatusCode="S")||(ASStatusCode="PS")||(ASStatusCode="TR")||(ASStatusCode="AUD"))
			...s retSchedule=CTLOCDR
			
		}
		
	}
	if (retSchedule="")&&(retScheduleTemp="") q 0
	s rtn="1^"
	if (retSchedule'="") s rtn=rtn_"该医生在"_$p(^CTLOC(retSchedule),"^",2)_"有有效排班"
	if (retScheduleTemp'="") s rtn=rtn_"该医生在"_$p(^CTLOC(retScheduleTemp),"^",2)_"有有效排班模板"
	q rtn
}

ClassMethod ShowAvailSeqNoNew(ASRowid)
{
	s StopStatus=..#StopStatus
	s ResRowid=+ASRowid,ASSub=$P(ASRowid,"||",2)
	s ASQueueNo=$P(^RBAS(ResRowid,ASSub,"DHC"),"^",4)
	s TimeRangeFlag=$P($G(^RBAS(ResRowid,ASSub,"DHC")),"^",19)
	s NormalQueueNoStr=$P(ASQueueNo,$C(1),1)
	s AddQueueNoStr=$P(ASQueueNo,$C(1),2)
	s ASQueueNoStr=NormalQueueNoStr //_","_AddQueueNoStr
	
	k TimeRangeArr
	s len=$L(ASQueueNoStr,",")
	if TimeRangeFlag="Y" {
		s OneEndNo=0
		s ASTRSub=0 for {
			s ASTRSub=$O(^RBAS(ResRowid,ASSub,"ASTR",ASTRSub)) 
			q:ASTRSub=""
			s TRLoad=$P(^RBAS(ResRowid,ASSub,"ASTR",ASTRSub),"^",3)
			s StartTime=$P(^RBAS(ResRowid,ASSub,"ASTR",ASTRSub),"^",1)
			s EndTime=$P(^RBAS(ResRowid,ASSub,"ASTR",ASTRSub),"^",2)
			s TimeRange=$zt(StartTime)_"-"_$zt(EndTime)
			s OneSttNo=OneEndNo+1,OneEndNo=OneEndNo+TRLoad
			for QueueNo=OneSttNo:1:OneEndNo {
				s TimeRangeArr(QueueNo)=TimeRange
			}
		}

	}else {
		s StartTime=$P(^RBAS(ResRowid,ASSub),"^",4)
		s EndTime=$P(^RBAS(ResRowid,ASSub),"^",5)
		s TimeRange=$zt(StartTime)_"-"_$zt(EndTime)
		f i=1:1:len {
			s SingleQueueNoStr=$P(ASQueueNoStr,",",i)
			continue:SingleQueueNoStr=""
			s QueueNo=$P(SingleQueueNoStr,":",1)
			s TimeRangeArr(QueueNo)=TimeRange
		}
	}
	b ;asd
	f i=1:1:len {
		s SingleQueueNoStr=$P(ASQueueNoStr,",",i)
		continue:SingleQueueNoStr=""
		s StatusCode=$P(SingleQueueNoStr,":",2)
		if (StatusCode=0)!(StatusCode=StopStatus)!('##class(web.DHCRBAppointment).GetReturnAllowRegFlag(StatusCode)){
			s SeqNo=$P(SingleQueueNoStr,":",1)
			s TimeRange=$g(TimeRangeArr(SeqNo))
			s:TimeRange="" TimeRange=" "
			s SeqNoArr(TimeRange,SeqNo)=StatusCode
		}
	}
	/*s len=$L(AddQueueNoStr,",")
	f i=1:1:len {
		s SingleQueueNoStr=$P(AddQueueNoStr,",",i)
		continue:SingleQueueNoStr=""
		s StatusCode=$P(SingleQueueNoStr,":",2)
		if (StatusCode=0)!(StatusCode=StopStatus)!('##class(web.DHCRBAppointment).GetReturnAllowRegFlag(StatusCode)){
			s SeqNo=$P(SingleQueueNoStr,":",1)
			s SeqNoArr("加号",SeqNo)=StatusCode
		}
	}*/
	s retArr=##class(%DynamicArray).%New()
	s l1="" f {
		s l1=$o(SeqNoArr(l1))
		q:l1=""
		s OneArr=##class(%DynamicArray).%New()
		s OneObj=##class(%DynamicObject).%New()
		s l2="" f {
			s l2=$o(SeqNoArr(l1,l2))
			q:l2=""
			s StatusCode=SeqNoArr(l1,l2)
			s OneArrObj=##class(%DynamicObject).%New()
			d OneArrObj.%Set("QueueNo",l2)
			d OneArrObj.%Set("StatusCode",StatusCode)
			d OneArr.%Push(OneArrObj)
			d OneArrObj.%Close()
		}
		d OneObj.%Set("TimeRange",l1)
		d OneObj.%Set("Lists",OneArr)
		d retArr.%Push(OneObj)
		d OneObj.%Close()
	}
	
	Q retArr.%ToJSON()
}

Query QueryClinicGroupList(ASRowID As %String = "") As %Query(ROWSPEC = "id:%String,text:%String")
{
}

// D ##class(%ResultSet).RunQuery("DHCDoc.OPAdm.Schedule","QueryClinicGroupList","3146||118")

ClassMethod QueryClinicGroupListExecute(ByRef qHandle As %Binary, ASRowID As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	if ASRowID=""{
		s qHandle=$lb(0,repid,0) 
		Quit $$$OK
	}
	s ClinicGroupStr=$P($G(^RBAS(+ASRowID,$P(ASRowID,"||",2),"DHC")),"^",29)
	if ClinicGroupStr=""{
		s qHandle=$lb(0,repid,0) 
		Quit $$$OK
	}
	for i=1:1:$l(ClinicGroupStr,","){
		s ClinicGroupID=$P(ClinicGroupStr,",",i)
		s ClinicGroup=$P(^RBC("CLGRP",ClinicGroupID),"^",2)
		set Data=$lb(ClinicGroupID,ClinicGroup)
 		Set ^CacheTemp(repid,ind)=Data
 		Set ind=ind+1
		}
	
	s qHandle=$lb(0,repid,0) 
	Quit $$$OK
}

ClassMethod QueryClinicGroupListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryClinicGroupListExecute ]
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

ClassMethod QueryClinicGroupListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryClinicGroupListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 更新排班信息时，更新分时段亚专业数据
ClassMethod UpdateASRowIDClinicGroup(ASRowID)
{
	s ^Tempqujian("UpdateASRowIDClinicGroup")=ASRowID
	s SessionClinicGroupDrStr=$P($G(^RBAS(+ASRowID,$P(ASRowID,"||",2),"DHC")),"^",29)
	if (SessionClinicGroupDrStr'=""){
		s ASSub=0 for{
			s ASSub=$O(^RBAS(+ASRowID,$P(ASRowID,"||",2),"ASTR",ASSub)) Q:ASSub=""
			s TRAMSub=0 for{
				s TRAMSub=$O(^RBAS(+ASRowID,$P(ASRowID,"||",2),"ASTR",ASSub,"TRCG",TRAMSub)) Q:TRAMSub=""
				s TRAMRowid=ASRowID_"||"_ASSub_"||"_TRAMSub
				s ClinicGroupMethodID=$P(^RBAS(+ASRowID,$P(ASRowID,"||",2),"ASTR",ASSub,"TRCG",TRAMSub),"^",1)
				if ((","_SessionClinicGroupDrStr_",")'[(","_ClinicGroupMethodID_",")){
					&SQL(DELETE FROM SQLUser.RB_ApptScheduleTRClinicGroup WHERE ID=:TRAMRowid)
				}
			}
		}
	}
	q 0
}

}
