Class DHCDoc.OPAdm.ScheduleTemp Extends DHCDoc.Util.RegisteredObject
{

/// w ##class(DHCDoc.OPAdm.ScheduleTemp).GetSessTemp("","",1)
ClassMethod GetSessTemp(LocRowid, DocRowid, UserID, ScheduleLinesRowId = "")
{
	if (LocRowid'="")&(DocRowid'=""){
		s ResRowid=$O(^RB("RES",0,"CTPCP",DocRowid,LocRowid,0))
		d OneRes
	}elseif LocRowid'=""{
		s ResRowid=0 f  s ResRowid=$O(^RB("RES",0,"CTLOC",LocRowid,ResRowid)) q:ResRowid=""  d
		.d OneRes
	}elseif DocRowid'=""{
		s LocRowid=0 f  s LocRowid=$O(^RB("RES",0,"CTPCP",DocRowid,LocRowid)) q:LocRowid=""  d
		.s ResRowid=$O(^RB("RES",0,"CTPCP",DocRowid,LocRowid,0))
		.d OneRes
	}else{
		s LocID="" f  s LocID=$O(^User.DHCUserGroupI("UserLocDoc"," REG"," "_UserID,LocID)) Q:LocID=""  d
		.s mLocID=$TR(LocID," ")
		.s DocID="" f  s DocID=$O(^User.DHCUserGroupI("UserLocDoc"," REG"," "_UserID,LocID,DocID)) Q:DocID=""  d
		..s mDocID=$TR(DocID," ")
		..s ResRowid=$O(^RB("RES",0,"CTPCP",mDocID,mLocID,0))
		..q:ResRowid=""
		..d OneRes
	}
	s LocArr=[]
	s LocID=0 f  s LocID=$O(TempList(LocID)) Q:LocID=""  d
	.s LocObj={}
	.s LocDesc=$P(^CTLOC(LocID),"^",2)
	.s:LocDesc["-" LocDesc=$P(LocDesc,"-",2)
	.s LocObj.LocID=LocID
	.s LocObj.LocDesc=LocDesc
	.s LocObj.Doctors=[]
	.s row=0
	.s DocID=0 f  s DocID=$O(TempList(LocID,DocID)) Q:DocID=""  d
	..s DocObj={}
	..s DocObj.DocID=DocID
	..s DocObj.DocName=$P(^CTPCP(DocID,1),"^",2)
	..s DocObj.Temps=TempList(LocID,DocID)
	..s DocObj.row=DocObj.Temps.%Size()
	..s row=row+DocObj.row
	..d LocObj.Doctors.%Push(DocObj)
	.s LocObj.row=row
	.d LocArr.%Push(LocObj)
	Q LocArr.%ToJSON()
OneRes
	s ResLocID=$P(^RB("RES",ResRowid),"^",1)
	s ResDocID=$P(^RB("RES",ResRowid),"^",2)
	Q:'$D(^User.DHCUserGroupI("UserLocDoc"," REG"," "_UserID," "_ResLocID," "_ResDocID))
	s DateSub=$P(..GetDateRowid(ResRowid,ScheduleLinesRowId),"||",2)
	Q:DateSub=""
	d OneSessDate
	Q
OneSessDate
	k SessList
	s SessSub=0 f  s SessSub=$O(^RB("RES",ResRowid,"DATE",DateSub,"SESS",SessSub)) q:SessSub=""  d
	.s SessNo=$P(^RB("RES",ResRowid,"DATE",DateSub,"SESS",SessSub),"^",3)
	.q:SessNo=""
	.s DOWDR=$P(^RB("RES",ResRowid,"DATE",DateSub,"SESS",SessSub),"^",2)
	.q:DOWDR=""
	.s DOW=$P(^CT("DOW",1,DOWDR),"^",2)
	.s SessList(SessNo,DOW)=..GetSingleSessInfo(ResRowid_"||"_DateSub_"||"_SessSub)
	
	s SessInfo=[]
	s SessNo=0 f  s SessNo=$O(SessList(SessNo)) Q:SessNo=""  d
	.s TRObj={}
	.s TRObj.TimeRangeID=SessNo
	.s TRObj.TimeRange=$P(^DHCTimeRange(SessNo),"^",2)
	.s TRObj.WeekLoad=[]
	.f DOW=1:1:7 d
	..d TRObj.WeekLoad.%Push($G(SessList(SessNo,DOW)))
	.d SessInfo.%Push(TRObj)
	if SessInfo.%Size(){
		s TempList(ResLocID,ResDocID)=SessInfo
	}
	Q
}

ClassMethod GetSingleSessInfo(SessRowid) As %DynamicObject
{
	s obj={"SessRowid":(SessRowid)}
	s ResRowid=+SessRowid,DateSub=$P(SessRowid,"||",2),SessSub=$P(SessRowid,"||",3)
	s obj.Load=+$P(^RB("RES",ResRowid,"DATE",DateSub,"SESS",SessSub),"^",8)
	s obj.GenerFlag=$P(^RB("RES",ResRowid,"DATE",DateSub,"SESS",SessSub),"^",16)
	s:obj.GenerFlag'="Y" obj.GenerFlag="N"
	Q obj
}

ClassMethod GetSessTempList(SessRowid)
{
	s ResRowid=+SessRowid,DateSub=$P(SessRowid,"||",2)
	s SessSub=0 f  s SessSub=$O(^RB("RES",ResRowid,"DATE",DateSub,"SESS",SessSub)) q:SessSub=""  d
	.s SessNo=$P(^RB("RES",ResRowid,"DATE",DateSub,"SESS",SessSub),"^",3)
	.q:SessNo=""
	.s DOWDR=$P(^RB("RES",ResRowid,"DATE",DateSub,"SESS",SessSub),"^",2)
	.q:DOWDR=""
	.s DOW=$P(^CT("DOW",1,DOWDR),"^",2)
	.s SessList(DOW)=$P(^CT("DOW",1,DOWDR),"^",1)
	.s SessList(DOW,SessNo)=ResRowid_"||"_DateSub_"||"_SessSub_"^"_$P(^DHCTimeRange(SessNo),"^",2)
	s RetObj=[]
	s DOW=0 f  s DOW=$O(SessList(DOW)) Q:DOW=""  d
	.s WeekObj={}
	.s WeekObj.Week=SessList(DOW)
	.s WeekObj.TimeRanges=[]
	.s SessNo=0 f  s SessNo=$O(SessList(DOW,SessNo)) Q:SessNo=""  d
	..s obj={}
	..s obj.SessRowid=$P(SessList(DOW,SessNo),"^",1)
	..s obj.TimeRange=$P(SessList(DOW,SessNo),"^",2)
	..i obj.SessRowid=SessRowid s WeekObj.Selected=1,obj.Selected=1
	..d WeekObj.TimeRanges.%Push(obj)
	.d RetObj.%Push(WeekObj)
	Q RetObj.%ToJSON()
}

ClassMethod GetSessInfo(SessRowid)
{
	s RetObj={}
	s SessObj=##class(User.RBResEffDateSession).%OpenId(SessRowid)
	if $IsObject(SessObj){
		s RetObj.Week=SessObj.SESSDOWDRGetObjectId()
		s RetObj.AdmLoc=SessObj.SESSParRef.DATEParRef.RESCTLOCDRGetObjectId()
		s RetObj.AdmDoc=SessObj.SESSParRef.DATEParRef.RESCTPCPDRGetObjectId()
		s RetObj.TimeRange=SessObj.SESSSessionNo
		;s RetObj.SttTime=..%ZT(SessObj.SESSTimeStart,2)
		;s RetObj.EndTime=..%ZT(SessObj.SESSTimeEnd,2)
		s RetObj.SessType=SessObj.SESSSessionTypeDRGetObjectId()
		s RetObj.Room=SessObj.SESSRoomDRGetObjectId()
		s RetObj.ClincGroup=SessObj.SESSClinicGroupDRGetObjectId()
		s RetObj.ASLoad=SessObj.SESSLoad
		s RetObj.AppStartNo=SessObj.SESSNumberOfWeeks
		s RetObj.AppLoad=SessObj.SESSNoApptSlot
		s RetObj.AddLoad=SessObj.SESSNoOverbookAllowed
		s RetObj.TRFlag=SessObj.SESSTimeRangeFlag
		s RetObj.GenerFlag=SessObj.SESSScheduleGenerFlag
		s RetObj.tabAppMethodInfo=..GetTempAppMethod(SessRowid)
		s RetObj.tabTRInfo=..GetTempTRInfo(SessRowid)
		s RetObj.ScheduleLinesRowId=SessObj.SESSParRef.DATERSLDRGetObjectId()
	}
	Q RetObj.%ToJSON()
}

ClassMethod GetTempAppMethod(SessRowid) As %DynamicArray
{
	s AMArr=[]
	s ResRowid=+SessRowid,DateSub=$P(SessRowid,"||",2),SessSub=$P(SessRowid,"||",3)
	s AQSub=0 f  s AQSub=$O(^RB("RES",ResRowid,"Date",DateSub,"SESS",SessSub,"AQ",AQSub)) Q:AQSub=""  d
	.s obj={}
	.s obj.AQRowid=SessRowid_"||"_AQSub
	.s obj.AppMethodID=$P(^RB("RES",ResRowid,"Date",DateSub,"SESS",SessSub,"AQ",AQSub),"^",1)
	.s obj.AppMethod=$P($G(^RBC("APTM",+obj.AppMethodID)),"^",2)
	.s obj.MaxQty=$P(^RB("RES",ResRowid,"Date",DateSub,"SESS",SessSub,"AQ",AQSub),"^",4)
	.s obj.ReserveQty=$P(^RB("RES",ResRowid,"Date",DateSub,"SESS",SessSub,"AQ",AQSub),"^",2)
	.s obj.StartNo=$P(^RB("RES",ResRowid,"Date",DateSub,"SESS",SessSub,"AQ",AQSub),"^",3)
	.d AMArr.%Push(obj)
	Q AMArr
}

ClassMethod GetTempAppMethodNew(SessRowid) As %String
{
	q:SessRowid="" "[]"
	s AMArr=[]
	s ResRowid=+SessRowid,DateSub=$P(SessRowid,"||",2),SessSub=$P(SessRowid,"||",3)
	s AQSub=0 f  s AQSub=$O(^RB("RES",ResRowid,"Date",DateSub,"SESS",SessSub,"AQ",AQSub)) Q:AQSub=""  d
	.s obj={}
	.s obj.AQRowid=SessRowid_"||"_AQSub
	.s obj.AppMethodID=$P(^RB("RES",ResRowid,"Date",DateSub,"SESS",SessSub,"AQ",AQSub),"^",1)
	.s obj.AppMethod=$P($G(^RBC("APTM",+obj.AppMethodID)),"^",2)
	.s obj.MaxQty=$P(^RB("RES",ResRowid,"Date",DateSub,"SESS",SessSub,"AQ",AQSub),"^",4)
	.s obj.ReserveQty=$P(^RB("RES",ResRowid,"Date",DateSub,"SESS",SessSub,"AQ",AQSub),"^",2)
	.s obj.StartNo=$P(^RB("RES",ResRowid,"Date",DateSub,"SESS",SessSub,"AQ",AQSub),"^",3)
	.d AMArr.%Push(obj)
	Q AMArr.%ToJSON()
}

/// w ##class(DHCDoc.OPAdm.ScheduleTemp).GetTempTRInfoNew("7||1||2")
ClassMethod GetTempTRInfoNew(SessRowid) As %DynamicArray
{
	q:SessRowid="" "[]"
	s AMArr=[]
	s ResRowid=+SessRowid,DateSub=$P(SessRowid,"||",2),SessSub=$P(SessRowid,"||",3)
	s TRSub=0 f  s TRSub=$O(^RB("RES",ResRowid,"DATE",DateSub,"SESS",SessSub,"TR",TRSub)) Q:TRSub=""  d
	.s str=$G(^RB("RES",ResRowid,"DATE",DateSub,"SESS",SessSub,"TR",TRSub))
	.q:str=""
	.s TRObj={}
	.s TRObj.AQTRRowid=SessRowid_"||"_TRSub
	.s TRObj.SttTime=##class(websys.Conversions).TimeLogicalToHtml($P(str,"^",1))
	.s TRObj.EndTime=##class(websys.Conversions).TimeLogicalToHtml($P(str,"^",2))
	.s TRObj.Load=$P(str,"^",3)
	.s TRObj.tabTRAppMethodInfo=[]
	.s TRAMSub=0 f  s TRAMSub=$O(^RB("RES",ResRowid,"DATE",DateSub,"SESS",SessSub,"TR",TRSub,"TRAM",TRAMSub)) Q:TRAMSub=""  d
	..s str=^RB("RES",ResRowid,"DATE",DateSub,"SESS",SessSub,"TR",TRSub,"TRAM",TRAMSub)
	..s AMObj={}
	..s AMObj.TRAMRowid=TRObj.AQTRRowid_"||"_TRAMSub
	..s AMObj.AppMethodID=$P(str,"^",1)
	..s AMObj.AppMethod=$P(^RBC("APTM",AMObj.AppMethodID),"^",2)
	..s AMObj.MaxQty=$P(str,"^",2)
	..s AMObj.ReserveQty=$P(str,"^",3)
	..d TRObj.tabTRAppMethodInfo.%Push(AMObj)
	.s TRObj.tabTRClinicGroupInfo=[]
	.s TRAMSub=0 f  s TRAMSub=$O(^RB("RES",ResRowid,"DATE",DateSub,"SESS",SessSub,"TR",TRSub,"TRCG",TRAMSub)) Q:TRAMSub=""  d
	..s str=^RB("RES",ResRowid,"DATE",DateSub,"SESS",SessSub,"TR",TRSub,"TRCG",TRAMSub)
	..s AMObj={}
	..s AMObj.TRClinicGroupRowid=TRObj.AQTRRowid_"||"_TRAMSub
	..s AMObj.ClinicGroupMethodID=$P(str,"^",1)
	..s AMObj.ClinicGroup=$P(^RBC("CLGRP",AMObj.ClinicGroupMethodID),"^",2)
	..s AMObj.Qty=$P(str,"^",2)
	..d TRObj.tabTRClinicGroupInfo.%Push(AMObj)
	.d AMArr.%Push(TRObj)
	Q AMArr.%ToJSON()
}

ClassMethod GetTempTRInfo(SessRowid) As %DynamicArray
{
	s AMArr=[]
	s ResRowid=+SessRowid,DateSub=$P(SessRowid,"||",2),SessSub=$P(SessRowid,"||",3)
	s TRSub=0 f  s TRSub=$O(^RB("RES",ResRowid,"DATE",DateSub,"SESS",SessSub,"TR",TRSub)) Q:TRSub=""  d
	.s str=^RB("RES",ResRowid,"DATE",DateSub,"SESS",SessSub,"TR",TRSub)
	.s TRObj={}
	.s TRObj.AQTRRowid=SessRowid_"||"_TRSub
	.s TRObj.SttTime=##class(websys.Conversions).TimeLogicalToHtml($P(str,"^",1))
	.s TRObj.EndTime=##class(websys.Conversions).TimeLogicalToHtml($P(str,"^",2))
	.s TRObj.Load=$P(str,"^",3)
	.s TRObj.tabTRAppMethodInfo=[]
	.s TRAMSub=0 f  s TRAMSub=$O(^RB("RES",ResRowid,"DATE",DateSub,"SESS",SessSub,"TR",TRSub,"TRAM",TRAMSub)) Q:TRAMSub=""  d
	..s str=^RB("RES",ResRowid,"DATE",DateSub,"SESS",SessSub,"TR",TRSub,"TRAM",TRAMSub)
	..s AMObj={}
	..s AMObj.TRAMRowid=TRObj.AQTRRowid_"||"_TRAMSub
	..s AMObj.AppMethodID=$P(str,"^",1)
	..s AMObj.AppMethod=$P(^RBC("APTM",AMObj.AppMethodID),"^",2)
	..s AMObj.MaxQty=$P(str,"^",2)
	..s AMObj.ReserveQty=$P(str,"^",3)
	..d TRObj.tabTRAppMethodInfo.%Push(AMObj)
	.d AMArr.%Push(TRObj)
	Q AMArr
}

ClassMethod CheckBeforeSave(InputObj) As %DynamicObject
{
	s retObj={"Code":0}
	s SessRowid=InputObj.SessRowid
	s WeekId=InputObj.Week
	s TimeRangeId=InputObj.TimeRange
	s RoomId=InputObj.Room
	if SessRowid=""{
		s LocRowid=InputObj.AdmLoc
		s DocRowid=InputObj.AdmDoc
		s ScheduleLinesRowId=InputObj.ScheduleLinesRowId
		s ResRowid=$O(^RB("RES",0,"CTPCP",DocRowid,LocRowid,0))
		s DateRowid=..GetDateRowid(ResRowid,ScheduleLinesRowId)
		s DateSub=$P(DateRowid,"||",2)
		Q:DateSub="" retObj
		s ResRowid=$O(^RB("RES",0,"CTPCP",DocRowid,LocRowid,0))
	}else{
		s ResRowid=+SessRowid,DateSub=$P(SessRowid,"||",2)
	}
	s SessSub=0 for{
		s SessSub=$O(^RB("RES",ResRowid,"DATE",DateSub,"SESS",SessSub)) Q:SessSub=""
		continue:SessSub=$P(SessRowid,"||",3)
		s DOWDR=$P(^RB("RES",ResRowid,"DATE",DateSub,"SESS",SessSub),"^",2)
		if DOWDR=WeekId{
			s SessNo=$P(^RB("RES",ResRowid,"DATE",DateSub,"SESS",SessSub),"^",3)
			if ..TimeRangeContain(SessNo,TimeRangeId){
				s DOW=$P(^CT("DOW",1,DOWDR),"^",1)
				s TimeRange=$P(^DHCTimeRange(SessNo),"^",2)
				s retObj.Code=-1
				s retObj.msg="与医生现有模板:"_DOW_" "_TimeRange_" 冲突"
				Q
			}
		}
	}
	Q retObj
}

/// w ##class(DHCDoc.OPAdm.ScheduleTemp).SaveScheduleTemp(^Wqy("SaveScheduleTemp"))
ClassMethod SaveScheduleTemp(InputJson)
{
	;s ^Wqy("SaveScheduleTemp")=InputJson
	s InputObj={}.%FromJSON(InputJson)
	s retObj=..CheckBeforeSave(InputObj)
	if retObj.Code'=0{
		Q retObj.%ToJSON()
	}
	s SessRowid=InputObj.SessRowid
	s LocRowid=InputObj.AdmLoc
	s DocRowid=InputObj.AdmDoc
	TS
	if SessRowid=""{
		s ScheduleLinesRowId=InputObj.ScheduleLinesRowId
		s DateRowid=..GetResEffDate(LocRowid,DocRowid,ScheduleLinesRowId)
		if DateRowid=""{
			TRO
			s retObj.Code=-1
			s retObj.msg="新增RBResEffDate失败!"
			Q retObj.%ToJSON()
		}
		s SessObj=##class(User.RBResEffDateSession).%New(DateRowid)
		d SessObj.SESSParRefSetObjectId(DateRowid)
	}else{
		s SessObj=##class(User.RBResEffDateSession).%OpenId(SessRowid)
	}
	d SessObj.SESSDOWDRSetObjectId(InputObj.Week)
	s SessObj.SESSSessionNo=InputObj.TimeRange
	s SessObj.SESSTimeStart=##class(websys.Conversions).TimeHtmlToLogical(InputObj.SttTime)
	s SessObj.SESSTimeEnd=##class(websys.Conversions).TimeHtmlToLogical(InputObj.EndTime)
	d SessObj.SESSSessionTypeDRSetObjectId(InputObj.SessType)
	d SessObj.SESSRoomDRSetObjectId(InputObj.Room)
	d SessObj.SESSClinicGroupDRSetObjectId(InputObj.ClincGroup)
	s SessObj.SESSLoad=InputObj.ASLoad
	s SessObj.SESSNumberOfWeeks=InputObj.AppStartNo
	s SessObj.SESSNoApptSlot=InputObj.AppLoad
	s SessObj.SESSNoOverbookAllowed=InputObj.AddLoad
	s SessObj.SESSTimeRangeFlag=InputObj.TRFlag
	s SessObj.SESSScheduleGenerFlag=InputObj.GenerFlag
	s sc=SessObj.%Save()
	if $$$ISERR(sc){
		TRO
		s retObj.Code=-1
		s retObj.msg="保存模板失败!"
		Q retObj.%ToJSON()
	}
	s SessRowid=SessObj.%Id()
	s retObj=..SaveTempAppMethod(SessRowid,InputObj.tabAppMethodInfo)
	if retObj.Code'=0{
		Q retObj.%ToJSON()
	}
	s retObj=..SaveTempTR(SessRowid,InputObj.tabTRInfo)
	if retObj.Code'=0{
		Q retObj.%ToJSON()
	}
	TC
	s retObj=..GetSingleSessInfo(SessRowid)
	s retObj.Code=0
	s retObj.msg="保存成功!"
	Q retObj.%ToJSON()
}

ClassMethod SaveTempAppMethod(SessRowid, AMObj As %DynamicArray) As %DynamicObject
{
	TS
	s ResRowid=+SessRowid,DateSub=$P(SessRowid,"||",2),SessSub=$P(SessRowid,"||",3)
	s retObj={"Code":0}
	for i=1:1:AMObj.%Size(){
		s obj=AMObj.%Get(i-1)
		s AQRowid=obj.AQRowid
		if $P(AQRowid,"||",1,3)'=SessRowid s AQRowid=""
		if AQRowid=""{
			s AQObj=##class(User.DHCRBResEffDateSessAppQty).%New(SessRowid)
			s AQObj.AQParRef=SessRowid
			s AQObj.AQResDR=ResRowid
			s AQObj.AQDateChildsub=DateSub
			s AQObj.AQSessChildsub=SessSub
		}else{
			s AQObj=##class(User.DHCRBResEffDateSessAppQty).%OpenId(AQRowid)
		}
		d AQObj.AQMethodDRSetObjectId(obj.AppMethodID)
		s AQObj.AQQty=obj.ReserveQty
		s AQObj.AQMaxQty=obj.MaxQty
		s AQObj.AQStartNum=obj.StartNo
		s sc=AQObj.%Save()
		if $$$ISERR(sc){
			s retObj.Code=-1
			s retObj.msg="更新预约方式失败"
			Q
		}
		s IDList(AQObj.%Id())=""
	}
	if +retObj.Code'=0{
		TRO
	}else{
		s AQSub=0 for{
			s AQSub=$O(^RB("RES",ResRowid,"Date",DateSub,"SESS",SessSub,"AQ",AQSub)) Q:AQSub=""
			s AQRowid=SessRowid_"||"_AQSub
			if '$D(IDList(AQRowid)){
				&SQL(DELETE FROM SQLUser.DHC_RBResEffDateSessAppQty WHERE AQ_Rowid=:AQRowid)
			}
		}
		TC
	}
	Q retObj
}

ClassMethod DelTempAppQty(SessRowid) As %String
{
	s ResRowid=+SessRowid,DateSub=$P(SessRowid,"||",2),SessSub=$P(SessRowid,"||",3)
	s AQSub=0
	for{
		s AQSub=$O(^RB("RES",ResRowid,"Date",DateSub,"SESS",SessSub,"AQ",AQSub))
		Q:AQSub=""
		s AQRowid=SessRowid_"||"_AQSub
		&SQL(DELETE FROM SQLUser.DHC_RBResEffDateSessAppQty WHERE AQ_Rowid=:AQRowid)
	}
}

/// w ##class(DHCDoc.OPAdm.ScheduleTemp).SaveTempAppMethodNew("2084||1||7",^tempqujian("SaveTempAppMethodNew"))
ClassMethod SaveTempAppMethodNew(SessRowid, AMObjStr As %String) As %String
{
	s ^tempqujian("SaveTempAppMethodNew")=AMObjStr
	s AMObj={}.%FromJSON(AMObjStr)
	TS
	s ResRowid=+SessRowid,DateSub=$P(SessRowid,"||",2),SessSub=$P(SessRowid,"||",3)
	s retObj=0
	for i=1:1:AMObj.%Size(){
		s obj=AMObj.%Get(i-1)
		s AQRowid=obj.AQRowid
		if $P(AQRowid,"||",1,3)'=SessRowid s AQRowid=""
		if AQRowid=""{
			/*s AQObj=##class(User.DHCRBResEffDateSessAppQty).%New(SessRowid)
			b ;0933232
			s AQObj.AQParRef=SessRowid
			s AQObj.AQResDR=ResRowid
			s AQObj.AQDateChildsub=DateSub
			s AQObj.AQSessChildsub=SessSub*/
			Set PLIST(2)=ResRowid
			Set PLIST(3)=DateSub
			Set PLIST(4)=SessSub
			Set PLIST(6)=obj.AppMethodID
			Set PLIST(7)=obj.ReserveQty
			Set PLIST(9)=obj.StartNo
			Set PLIST(10)=obj.MaxQty
			&SQL(Insert Into SQLUser.DHC_RBResEffDateSessAppQty values :PLIST())
			if (SQLCODE=0){
				s rowid=$p(%ROWID,$c(1))
				s IDList(rowid)=""
			}else{
				s retObj="更新预约方式失败"
				Q
			}
		}else{
			s AQObj=##class(User.DHCRBResEffDateSessAppQty).%OpenId(AQRowid)
			d AQObj.AQMethodDRSetObjectId(obj.AppMethodID)
			s AQObj.AQQty=obj.ReserveQty
			s AQObj.AQMaxQty=obj.MaxQty
			s AQObj.AQStartNum=obj.StartNo
			s sc=AQObj.%Save()
			if $$$ISERR(sc){
				s retObj="更新预约方式失败"
				Q
			}
			s IDList(AQObj.%Id())=""
		}
	}
	if +retObj'=0{
		TRO
	}else{
		s AQSub=0 for{
			s AQSub=$O(^RB("RES",ResRowid,"Date",DateSub,"SESS",SessSub,"AQ",AQSub)) Q:AQSub=""
			s AQRowid=SessRowid_"||"_AQSub
			if '$D(IDList(AQRowid)){
				&SQL(DELETE FROM SQLUser.DHC_RBResEffDateSessAppQty WHERE AQ_Rowid=:AQRowid)
			}
		}
		TC
	}
	Q retObj
}

ClassMethod SaveTempTRNew(SessRowid, TRInfoObjStr As %String) As %String
{
	s TRInfoObj={}.%FromJSON(TRInfoObjStr)
	s retObj=0
	TS
	s ResRowid=+SessRowid,DateSub=$P(SessRowid,"||",2),SessSub=$P(SessRowid,"||",3)
	s TRSub=0 f  s TRSub=$O(^RB("RES",ResRowid,"DATE",DateSub,"SESS",SessSub,"TR",TRSub)) Q:TRSub=""  d
	.s AQTRRowid=SessRowid_"||"_TRSub
	.&SQL(DELETE FROM SQLUser.RB_ResEffDateSessionTR WHERE STR_RowId=:AQTRRowid)
	for i=1:1:TRInfoObj.%Size(){
		s obj=TRInfoObj.%Get(i-1)
		continue:'$IsObject(obj)
		s AQTRRowid=obj.AQTRRowid
		if $P(AQTRRowid,"||",1,3)'=SessRowid s AQTRRowid=""
		//if AQTRRowid=""{
		s TRObj=##class(User.RBResEffDateSessionTR).%New(SessRowid)
		d TRObj.STRParRefSetObjectId(SessRowid)
		//}else{
		//	s TRObj=##class(User.RBResEffDateSessionTR).%OpenId(AQTRRowid)
		//}
		s TRObj.STRSttTime=##class(websys.Conversions).TimeHtmlToLogical(obj.SttTime)
		s TRObj.STREndTime=##class(websys.Conversions).TimeHtmlToLogical(obj.EndTime)
		s TRObj.STRLoad=obj.Load
		s sc=TRObj.%Save()
		if $$$ISERR(sc){
			s retObj="保存分时段信息失败"
			Q
		}
		s AQTRRowid=TRObj.%Id()
		s IDList(AQTRRowid)=""
		s tabTRAppMethodInfo=obj.tabTRAppMethodInfo
		if tabTRAppMethodInfo'=""{
			s retObjStr=..SaveTempTRAppMethod(AQTRRowid,tabTRAppMethodInfo)
			if retObjStr.Code'=0{
				Q
			}
		}
		s tabTRClinicGroupInfo=obj.tabTRClinicGroupInfo
		if tabTRClinicGroupInfo'=""{
			s retObjStr=..SaveTempTRClinicGroupInfo(AQTRRowid,tabTRClinicGroupInfo)
			if retObjStr.Code'=0{
				Q
			}
		}
	}
	if retObj'=0{
		TRO
	}else{
		TC
	}
	Q retObj
}

ClassMethod SaveTempTR(SessRowid, TRInfoObj As %DynamicArray) As %DynamicObject
{
	s retObj={"Code":0}
	TS
	for i=1:1:TRInfoObj.%Size(){
		s obj=TRInfoObj.%Get(i-1)
		continue:'$IsObject(obj)
		s AQTRRowid=obj.AQTRRowid
		if $P(AQTRRowid,"||",1,3)'=SessRowid s AQTRRowid=""
		if AQTRRowid=""{
			s TRObj=##class(User.RBResEffDateSessionTR).%New(SessRowid)
			d TRObj.STRParRefSetObjectId(SessRowid)
		}else{
			s TRObj=##class(User.RBResEffDateSessionTR).%OpenId(AQTRRowid)
		}
		s TRObj.STRSttTime=##class(websys.Conversions).TimeHtmlToLogical(obj.SttTime)
		s TRObj.STREndTime=##class(websys.Conversions).TimeHtmlToLogical(obj.EndTime)
		s TRObj.STRLoad=obj.Load
		s sc=TRObj.%Save()
		if $$$ISERR(sc){
			s retObj.Code=-1
			s retObj.msg="保存分时段信息失败"
			Q
		}
		s AQTRRowid=TRObj.%Id()
		s IDList(AQTRRowid)=""
		s tabTRAppMethodInfo=obj.tabTRAppMethodInfo
		if tabTRAppMethodInfo'=""{
			s retObj=..SaveTempTRAppMethod(AQTRRowid,tabTRAppMethodInfo)
			if retObj.Code'=0{
				Q
			}
		}
	}
	if retObj.Code'=0{
		TRO
	}else{
		s ResRowid=+SessRowid,DateSub=$P(SessRowid,"||",2),SessSub=$P(SessRowid,"||",3)
		s TRSub=0 f  s TRSub=$O(^RB("RES",ResRowid,"DATE",DateSub,"SESS",SessSub,"TR",TRSub)) Q:TRSub=""  d
		.s AQTRRowid=SessRowid_"||"_TRSub
		.i '$D(IDList(AQTRRowid)) d
		..&SQL(DELETE FROM SQLUser.RB_ResEffDateSessionTR WHERE STR_RowId=:AQTRRowid)
		TC
	}
	Q retObj
}

ClassMethod SaveTempTRAppMethod(AQTRRowid, TRAppMethodObj As %DynamicArray) As %DynamicObject
{
	s retObj={"Code":0}
	TS
	for i=1:1:TRAppMethodObj.%Size(){
		s obj=TRAppMethodObj.%Get(i-1)
		continue:'$IsObject(obj)
		s TRAMRowid=obj.TRAMRowid
		if $P(TRAMRowid,"||",1,4)'=AQTRRowid s TRAMRowid=""
		if TRAMRowid=""{
			s TRAMObj=##class(User.RBResEffDateSessionTRAppMethod).%New(AQTRRowid)
			d TRAMObj.STRAMParRefSetObjectId(AQTRRowid)
		}else{
			s TRAMObj=##class(User.RBResEffDateSessionTRAppMethod).%OpenId(TRAMRowid)
		}
		d TRAMObj.STRAMMethodDRSetObjectId(obj.AppMethodID)
		s TRAMObj.STRAMReserveQty=obj.ReserveQty
		s TRAMObj.STRAMMaxQty=obj.MaxQty
		s sc=TRAMObj.%Save()
		if $$$ISERR(sc){
			s retObj.Code=-1
			s retObj.msg="保存分时段预约方式失败"
			Q
		}
		s TRAMRowid=TRAMObj.%Id()
		s IDList(TRAMRowid)=""
	}
	if retObj.Code'=0{
		TRO
	}else{
		s ResRowid=+AQTRRowid,DateSub=$P(AQTRRowid,"||",2),SessSub=$P(AQTRRowid,"||",3),TRSub=$P(AQTRRowid,"||",4)
		s TRAMSub=0 f  s TRAMSub=$O(^RB("RES",ResRowid,"DATE",DateSub,"SESS",SessSub,"TR",TRSub,"TRAM",TRAMSub)) Q:TRAMSub=""  d
		.s TRAMRowid=AQTRRowid_"||"_TRAMSub
		.i '$D(IDList(TRAMRowid)) d
		..&SQL(DELETE FROM SQLUser.RB_ResEffDateSessionTRAppMethod WHERE STRAM_RowId=:TRAMRowid)
		TC
	}
	Q retObj
}

ClassMethod SaveTempTRClinicGroupInfo(AQTRRowid, TRClinicGroupObj As %DynamicArray)
{
	s retObj={"Code":0}
	TS
	for i=1:1:TRClinicGroupObj.%Size(){
		s obj=TRClinicGroupObj.%Get(i-1)
		continue:'$IsObject(obj)
		s TRClinicGroupRowid=obj.TRClinicGroupRowid
		if $P(TRClinicGroupRowid,"||",1,4)'=AQTRRowid s TRClinicGroupRowid=""
		if TRClinicGroupRowid=""{
			s TRAMObj=##class(User.RBResEffDateSessionTRClinicGroup).%New(AQTRRowid)
			d TRAMObj.STRCGParRefSetObjectId(AQTRRowid)
		}else{
			s TRAMObj=##class(User.RBResEffDateSessionTRClinicGroup).%OpenId(TRClinicGroupRowid)
		}
		d TRAMObj.STRCGClinicGroupDRSetObjectId(obj.ClinicGroupMethodID)
		s TRAMObj.STRCGQty=obj.Qty
		s sc=TRAMObj.%Save()
		if $$$ISERR(sc){
			s retObj.Code=-1
			s retObj.msg="保存分时段预约方式失败"
			Q
		}
		s TRClinicGroupRowid=TRAMObj.%Id()
		s IDList(TRClinicGroupRowid)=""
	}
	if retObj.Code'=0{
		TRO
	}else{
		s ResRowid=+AQTRRowid,DateSub=$P(AQTRRowid,"||",2),SessSub=$P(AQTRRowid,"||",3),TRSub=$P(AQTRRowid,"||",4)
		s TRAMSub=0 f  s TRAMSub=$O(^RB("RES",ResRowid,"DATE",DateSub,"SESS",SessSub,"TR",TRSub,"TRCG",TRAMSub)) Q:TRAMSub=""  d
		.s TRAMRowid=AQTRRowid_"||"_TRAMSub
		.i '$D(IDList(TRAMRowid)) d
		..&SQL(DELETE FROM SQLUser.RB_ResEffDateSessionTRClinicGroup WHERE ID=:TRAMRowid)
		TC
	}
	Q retObj
}

ClassMethod GetDateRowid(ResRowid, ScheduleLinesRowId = "")
{
	Q:ResRowid="" ""
	s DateRowid=""
	s DateSub="" for{
		s DateSub=$O(^RB("RES",ResRowid,"DATE",DateSub),-1) Q:+DateSub=0
		s RSLDR=$P(^RB("RES",ResRowid,"DATE",DateSub),"^",2)
		if RSLDR=ScheduleLinesRowId{
			s DateRowid=ResRowid_"||"_DateSub
			Q
		}
	}
	/*if DateRowid=""{
		s DateSub=$O(^RB("RES",ResRowid,"DATE",""),-1)
		s:+DateSub'=0 DateRowid=ResRowid_"||"_DateSub
	}*/
	Q DateRowid
}

ClassMethod GetResEffDate(LocRowid, DocRowid, ScheduleLinesRowId = "")
{
	s ResRowid=$O(^RB("RES",0,"CTPCP",DocRowid,LocRowid,0))
	s DateRowid=..GetDateRowid(ResRowid,ScheduleLinesRowId)
	Q:DateRowid'="" DateRowid
	s obj=##class(User.RBResEffDate).%New(ResRowid)
	d obj.DATEParRefSetObjectId(ResRowid)
	s obj.DATEDateFrom=..%SysDate()
	d obj.DATERSLDRSetObjectId(ScheduleLinesRowId)
	s sc=obj.%Save()
	if $$$ISERR(sc){
		Q ""
	}
	Q obj.%Id()
}

ClassMethod UpdateGenerFlag(SessRowid, NewGenerFlag)
{
	s retObj={}
	&SQL(UPDATE SQLUser.RB_ResEffDateSession SET SESS_ScheduleGenerFlag=:NewGenerFlag WHERE SESS_RowId=:SessRowid)
	if 'SQLCODE{
		s retObj.Schedule=..GetSingleSessInfo(SessRowid)
	}
	s retObj.Code=SQLCODE
	Q retObj.%ToJSON()
}

Query QueryDOW() As %SQLQuery
{
	SELECT DOW_RowId AS id, DOW_Name AS text FROM SQLUser.CT_DayOfWeek ORDER BY DOW_Sequence
}

ClassMethod TimeRangeContain(TRRowid1, TRRowid2)
{
	s SttTime1=$P(^DHCTimeRange(TRRowid1),"^",3)
	s EndTime1=$P(^DHCTimeRange(TRRowid1),"^",4)
	s SttTime2=$P(^DHCTimeRange(TRRowid2),"^",3)
	s EndTime2=$P(^DHCTimeRange(TRRowid2),"^",4)
	Q:(SttTime1>=EndTime2)!(SttTime2>=EndTime1) 0
	Q 1
}

Query QueryScheduleLine() As %SQLQuery
{
	SELECT RSL_RowId AS id, RSL_Desc AS text FROM SQLUser.RB_ResScheduleLines WHERE RSL_RowId>0
}

/// 排班生成
/// w ##class(DHCDoc.OPAdm.ScheduleTemp).GenSchedule(^Wqy("GenSchedule"))
ClassMethod GenSchedule(InputJson)
{
	;s ^Wqy("GenSchedule")=InputJson
	s RetObj={"SuccessCount":0,"ErrMsg":[]}
	s InputObj=[].%FromJSON(InputJson)
	s UserID=InputObj.UserID
	s SttDate=..%ZDH(InputObj.SttDate)
	s EndDate=..%ZDH(InputObj.EndDate)
	s ScheduleLinesRowId=InputObj.ScheduleLinesRowId
	s LocDocObj=InputObj.LocDoc
	if LocDocObj.%Size(){	;按选择科室医生生成
		f i=1:1:LocDocObj.%Size() d
		.s DocObj=LocDocObj.%Get(i-1)
		.s LocID=DocObj.LocRowid
		.f j=1:1:DocObj.Doctors.%Size() d
		..s DocID=DocObj.Doctors.%Get(j-1)
		..s ResRowid=$O(^RB("RES",0,"CTPCP",DocID,LocID,0))
		..q:ResRowid=""
		..d OneRes
	}else{	;没有选择生成全部
		s LocID="" f  s LocID=$O(^User.DHCUserGroupI("UserLocDoc"," REG"," "_UserID,LocID)) Q:LocID=""  d
		.s mLocID=$TR(LocID," ")
		.s DocID="" f  s DocID=$O(^User.DHCUserGroupI("UserLocDoc"," REG"," "_UserID,LocID,DocID)) Q:DocID=""  d
		..s mDocID=$TR(DocID," ")
		..s ResRowid=$O(^RB("RES",0,"CTPCP",mDocID,mLocID,0))
		..q:ResRowid=""
		..d OneRes
	}
	Q RetObj.%ToJSON()
OneRes
	s DateRowid=..GetDateRowid(ResRowid,ScheduleLinesRowId)
	s DateSub=$P(DateRowid,"||",2)
	Q:DateSub=""
	for ASDate=SttDate:1:EndDate{
		s WeekNo=$ZD(ASDate,10)
		s:WeekNo=0 WeekNo=7
		s SessRowid=""
		&SQL(DECLARE SessCursor CURSOR FOR
			SELECT SESS_RowId INTO :SessRowid FROM SQLUser.RB_ResEffDateSession 
			WHERE SESS_ParRef=:DateRowid AND SESS_ScheduleGenerFlag='Y' AND SESS_DOW_DR->DOW_Sequence=:WeekNo)
		&SQL(OPEN SessCursor)
		for{
			&SQL(FETCH SessCursor) QUIT:SQLCODE
			s err=##class(DHCDoc.OPAdm.Schedule).CreateByScheduleTemp(ASDate,SessRowid)
			if err{
				s:$P(err,"^",2)'="" err=$P(err,"^",2)
				d RetObj.ErrMsg.%Push(err)
			}else{
				s RetObj.SuccessCount=RetObj.SuccessCount+1
			}
		}
		&SQL(CLOSE SessCursor)
	}
	Q
}

/// w ##class(DHCDoc.OPAdm.ScheduleTemp).GetUserLocDocJSON(1)
ClassMethod GetUserLocDocJSON(UserID, ScheduleLinesRowId = "")
{
	s RetObj=[]
	s rsLoc=##class(%ResultSet).%New("DHCDoc.OPAdm.Schedule:QueryLoc")
	s rsDoc=##class(%ResultSet).%New("DHCDoc.OPAdm.Schedule:QueryDoc")
	d rsLoc.Execute(UserID)
	while rsLoc.Next(){
		s LocRowid=rsLoc.GetDataByName("LocRowid")
		s DocArr=[]
		d rsDoc.Execute(UserID,LocRowid)
		while rsDoc.Next(){
			s DocRowid=rsDoc.GetDataByName("DocRowid")
			s ResRowid=$O(^RB("RES",0,"CTPCP",DocRowid,LocRowid,0))
			s DateRowid=..GetDateRowid(ResRowid,ScheduleLinesRowId)
			continue:DateRowid=""
			s Count=0
			&SQL(SELECT count(SESS_RowId) INTO :Count FROM SQLUser.RB_ResEffDateSession 
				WHERE SESS_ParRef=:DateRowid AND SESS_ScheduleGenerFlag='Y')
			continue:Count=0
			s DocName=rsDoc.GetDataByName("DocName")
			s DocObj={}
			s DocObj.id=LocRowid_"_"_DocRowid
			s DocObj.text=DocName
			s DocObj.iconCls="icon-doctor"
			d DocArr.%Push(DocObj)
		}
		continue:'DocArr.%Size()
		s LocObj={}
		s LocObj.id=LocRowid
		s LocObj.text=rsLoc.GetDataByName("LocDesc")
		s LocObj.iconCls="icon-house"
		s LocObj.children=DocArr
		d RetObj.%Push(LocObj)
	}
	Q RetObj.%ToJSON()
}

ClassMethod DeleteTemp(SessRowid)
{
	&SQL(DELETE SQLUser.RB_ResEffDateSession WHERE SESS_RowId=:SessRowid)
	Q SQLCODE
}

/// 将老分时段数据插入新分时段的表,处理老模板数据,包括班次
/// DHC_RBResEffDateSessAppQty扩展可预约最大数的字段默认为原预约数量
/// d ##class(DHCDoc.OPAdm.ScheduleTemp).TRInfoOldToNew()
ClassMethod TRInfoOldToNew()
{
	if '$O(^RB("RSL",0)){
		&SQL(INSERT INTO SQLUser.RB_ResScheduleLines VALUES('01','通用模板',+$H,NULL,NULL,NULL,NULL,NULL,NULL,NULL))
	}
	s RSLRowid=$O(^RB("RSL",0))
	s ResRowid=0 f  s ResRowid=$O(^RB("RES",ResRowid)) Q:ResRowid=""  d
	.s DateSub=0 f  s DateSub=$O(^RB("RES",ResRowid,"DATE",DateSub)) Q:DateSub=""  d
	..s ScheduleLineID=$P(^RB("RES",ResRowid,"DATE",DateSub),"^",2)
	..i ScheduleLineID="" d
	...s DateRowid=ResRowid_"||"_DateSub
	...&SQL(UPDATE SQLUser.RB_ResEffDate SET DATE_RSL_DR=:RSLRowid WHERE DATE_RowId=:DateRowid)
	..d DealTimeRangeInfo
	Q 0
DealTimeRangeInfo
	s SessSub=0 f  s SessSub=$O(^RB("RES",ResRowid,"DATE",DateSub,"SESS",SessSub)) Q:SessSub=""  d
	.Q:$O(^RB("RES",ResRowid,"DATE",DateSub,"SESS",SessSub,"TR",0))
	.s TRInfo=$G(^RB("RES",ResRowid,"DATE",DateSub,"SESS",SessSub,"DHC"))
	.s TRFlag=$P(TRInfo,"^",1)
	.s NumStr=$P(TRInfo,"^",6)
	.s TimeStr=$P(TRInfo,"^",7)
	.s SessRowid=ResRowid_"||"_DateSub_"||"_SessSub
	.;&SQL(UPDATE SQLUser.RB_ResEffDateSession SET SESS_TimeRangeFlag=:TRFlag WHERE SESS_RowId=:SessRowid)
	.i TimeStr'="" d
	..s TRObj=[]
	..f i=1:1:$L(TimeStr,",") d
	...s OneTimeStr=$P(TimeStr,",",i)
	...s OneNumStr=$P(NumStr,",",i)
	...s obj={}
	...s obj.SttTime=$P(OneTimeStr,"-",1)
	...s obj.EndTime=$P(OneTimeStr,"-",2)
	...s obj.Load=$P(OneNumStr,"-",2)-$P(OneNumStr,"-",1)+1
	...d TRObj.%Push(obj)
	..s RetObj=..SaveTempTR(SessRowid,TRObj)
	..w RetObj.%ToJSON(),!
	.
	.s AQSub=0 f  s AQSub=$O(^RB("RES",ResRowid,"Date",DateSub,"SESS",SessSub,"AQ",AQSub)) Q:AQSub=""  d
	..s Qty=$P(^RB("RES",ResRowid,"Date",DateSub,"SESS",SessSub,"AQ",AQSub),"^",2)
	..s $P(^RB("RES",ResRowid,"Date",DateSub,"SESS",SessSub,"AQ",AQSub),"^",4)=Qty
	Q
}

/// d ##class(DHCDoc.OPAdm.ScheduleTemp).DealData()
ClassMethod DealData()
{
	s ResRowid=0 f  s ResRowid=$O(^RB("RES",ResRowid)) Q:ResRowid=""  d
	.s DateSub=0 f  s DateSub=$O(^RB("RES",ResRowid,"Date",DateSub)) Q:DateSub=""  d
	..s SessSub=0 f  s SessSub=$O(^RB("RES",ResRowid,"Date",DateSub,"SESS",SessSub)) Q:SessSub=""  d
	...s Index=$G(^RB("RES",ResRowid,"DATE",DateSub,"SESS",SessSub,"AQ",0))
	...s AQSub=0 f  s AQSub=$O(^RB("RES",ResRowid,"Date",DateSub,"SESS",SessSub,"AQ",AQSub)) Q:AQSub=""  d
	....i Index<AQSub d
	.....k ^RB("RES",ResRowid,"Date",DateSub,"SESS",SessSub,"AQ",AQSub)
	.....w ResRowid_"||"_DateSub_"||"_SessSub_"||"_AQSub,!
	Q 0
}

/// w ##class(%ResultSet).RunQuery("DHCDoc.OPAdm.ScheduleTemp","QueryAppMethod")
Query QueryAppMethod() As %SQLQuery
{
	SELECT APTM_RowId AS id, APTM_Desc AS text FROM SQLUser.RBC_AppointMethod WHERE APTM_DateTo IS NULL OR APTM_DateTo>+$H
}

ClassMethod GetTRASLoad(SessRowid)
{
	q:SessRowid="" 0
	s ResRowid=$P(SessRowid,"||",1)
	s DateSub=$P(SessRowid,"||",2)
	s SessSub=$P(SessRowid,"||",3)
	s ASLoad=$P(^RB("RES",ResRowid,"DATE",DateSub,"SESS",SessSub),"^",8)
	/*s AQSub=0 for
	{ 
	s AQSub=$O(^RB("RES",ResRowid,"Date",DateSub,"SESS",SessSub,"AQ",AQSub)) 
	Q:AQSub=""  
	s AppMethodID=$P(^RB("RES",ResRowid,"Date",DateSub,"SESS",SessSub,"AQ",AQSub),"^",1)
	s APTMAppropriateRegist=$P(^RBC("APTM",AppMethodID),"^",6)  //是否启用占号模式
	if (APTMAppropriateRegist="Y"){
		s ReserveQty=$P(^RB("RES",ResRowid,"Date",DateSub,"SESS",SessSub,"AQ",AQSub),"^",2)
		s ASLoad=ASLoad+ReserveQty
		}
	}*/
	q ASLoad
}

ClassMethod SaveTempExtendConfig(CopyFromSessRowid As %String, NewSessRowId As %String) As %String
{
	s count=0
	s RowIDStr="", TypeIDStr="", ValueStr=""
	s ResRowid=+CopyFromSessRowid,DateSub=$P(CopyFromSessRowid,"||",2),SessSub=$P(CopyFromSessRowid,"||",3)
	s AQECChildsub=0
	for {
		s AQECChildsub=$o(^RB("RES",ResRowid,"Date",DateSub,"SESS",SessSub,"AQEC",AQECChildsub)) Q:AQECChildsub=""
		s TemplateConfigID=$P(^RB("RES",ResRowid,"Date",DateSub,"SESS",SessSub,"AQEC",AQECChildsub),"^",1)
		s Value=$P(^RB("RES",ResRowid,"Date",DateSub,"SESS",SessSub,"AQEC",AQECChildsub),"^",2)
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
	s rtn=##class(DHCDoc.OPAdm.ScheduleTemplateConfig).SaveTempExtendConfig(NewSessRowId, "", TypeIDStr, ValueStr)
	Q rtn
}

/// 导入排版前验证数据
/// w ##Class(DHCDoc.OPAdm.ScheduleTemp).ValidateRBResSessData()
ClassMethod ValidateRBResSessData(SessData As %String, ExpStr As %String) As %String
{
	q:(SessData="") "-1^无效数据"
	s ImportHospId=$p(ExpStr,"^",1) //导入院区
	s ImportHospName=$p(^CT("HOSP",ImportHospId),"^",2)
	s RSLDesc=$P(SessData,"^",1)	//班次
	s LocDesc=$P(SessData,"^",2)	//科室名称
	s RESCode=$P(SessData,"^",3)	//号别代码
	s RESDesc=$P(SessData,"^",4)	//号别名称
	s WeekNum=$P(SessData,"^",5)	//出诊时间(星期)
	s TRDesc=$P(SessData,"^",6)		//时段
	s SessionTypeDesc=$P(SessData,"^",7)	//挂号职称
	s CLGRPDesc=$P(SessData,"^",8)	//亚专业
	s RoomDesc=$P(SessData,"^",9)	//诊室
	s SessLoad=$P(SessData,"^",10)	//正号限额
	s SessNoApptSlot=$P(SessData,"^",11)	//预约限额
	s AddtionMax=$P(SessData,"^",12)	//加号限额
	s SessNoSlots=SessLoad-SessNoApptSlot
	s SessNumberOfWeeks=$P(SessData,"^",13)	//预约起始号
	s TRFlag=$P(SessData,"^",14)	//分时段就诊
	s TRStartTime=$P(SessData,"^",15)	//开始时间
	s TREndTime=$P(SessData,"^",16)	//结束时间
	s TRLength=$P(SessData,"^",17)	//间隔分钟
	s TRRegNum=$P(SessData,"^",18)	//时段号数
	s AppMethodStr=$P(SessData,"^",19)	//预约方式信息（方式|限额|起始号）
	
	if (RSLDesc=""){
		Q "-1^班次为空!"
	}
	s RSLRowID=0,FindRSLRowID=""
	for {
		s RSLRowID=$o(^RB("RSL",RSLRowID)) Q:(RSLRowID="")||(FindRSLRowID'="")
		s tmpRSLDesc=$p(^RB("RSL",RSLRowID),"^",2)
		continue:(tmpRSLDesc'=RSLDesc)
		s RSLStartDate=$p(^RB("RSL",RSLRowID),"^",3)
		continue:(RSLStartDate'="")&&(RSLStartDate>+$h)
		s RSLEndDate=$p(^RB("RSL",RSLRowID),"^",4)
		continue:(RSLEndDate'="")&&(RSLEndDate<=..%SysDate())
		continue:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("RB_ResScheduleLines",RSLRowID,ImportHospId)="N"
		s FindRSLRowID=RSLRowID
	}
	/*&SQL(SELECT RSL_RowId into :RSLRowID FROM SQLUser.RB_ResScheduleLines WHERE RSL_Desc=:RSLDesc)
	if (SQLCODE'=0)||(RSLRowID=""){
		q "-1^未找到对应的班次!"
	}*/
	s RSLRowID=FindRSLRowID
	if (RSLRowID="") {
		Q "-1^未找到对应的班次!"
	}
	if (LocDesc=""){
		Q "-1^科室为空!"
	}
	s LocRowID="",FindLocRowID=""
	for {
		s LocRowID=$O(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(LocDesc),LocRowID)) Q:LocRowID=""
		s LosHospDr=$p(^CTLOC(LocRowID),"^",22)
		continue:LosHospDr'=ImportHospId
		s FindLocRowID=LocRowID
		Q
	}
	s LocRowID=FindLocRowID
	//s LocRowID=$O(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(LocDesc),0))
	if (LocRowID=""){
		Q "-1^未找到对应的科室"
	}
	if (RESCode="")||(RESDesc=""){
		Q "-1^号别为空"
	}
	s MarkRowID=$O(^CTPCP(0,"Code",$$ALPHAUP^SSUTIL4(RESCode),0))
	if (MarkRowID=""){
		Q "-1^找不到对应的号别:"_RESCode
	}
	s tmpCTPCPDesc=$p($g(^CTPCP(MarkRowID,1)),"^",2)
	Q:(tmpCTPCPDesc'=RESDesc) "-1^根据号别代码获取到的号别名称和传入的号别名称不匹配!"
	Q:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("CT_CareProv",MarkRowID,ImportHospId)="N" "-1^"_ImportHospName_"无此科室的号别:"_RESCode
	s ResRowID=$O(^RB("RES",0,"CTPCP",MarkRowID,LocRowID,0))
	if (ResRowID=""){
		Q "-1^找不到对应的资源"
	}
	if (WeekNum<1)||(WeekNum>7){
		Q "-1^无效的星期"
	}
	s WeekDr=""
	&SQL(SELECT DOW_RowId into :WeekDr FROM SQLUser.CT_DayOfWeek WHERE DOW_Day=:WeekNum)
	if (SQLCODE'=0)||(WeekDr=""){
		q "-1^无效的周数:"_WeekNum
	}
	if (TRDesc=""){
		q "-1^时段为空"
	}
	s TimeRangeDr=0,FindTimeRangeDr=""
	for {
		s TimeRangeDr=$o(^DHCTimeRange(TimeRangeDr)) Q:(TimeRangeDr="")||(FindTimeRangeDr'="")
		s tmpTRDesc=$p(^DHCTimeRange(TimeRangeDr),"^",2)
		continue:(tmpTRDesc'=TRDesc)
		continue:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("DHC_TimeRange",TimeRangeDr,ImportHospId)="N"
		s FindTimeRangeDr=TimeRangeDr
	}
	s TimeRangeDr=FindTimeRangeDr
	if (TimeRangeDr="") {
		Q "-1^无效的时段:"_TRDesc
	}
	/*&SQL(SELECT TR_RowId into :TimeRangeDr FROM SQLUser.DHC_TimeRange WHERE TR_Desc=:TRDesc)
	if (SQLCODE'=0)||(TimeRangeDr=""){
		q "-1^无效的时段:"_TRDesc
	}*/
	if (SessionTypeDesc=""){
		q "-1^职称为空"
	}
	s SessionTypeDr=0,FindSessionTypeDr=""
	for {
		s SessionTypeDr=$o(^RBC("SESS",0,"Desc",$$ALPHAUP^SSUTIL4(SessionTypeDesc),SessionTypeDr)) Q:(SessionTypeDr="")||(FindSessionTypeDr'="")
		continue:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("RBC_SessionType",SessionTypeDr,ImportHospId)="N"
		s FindSessionTypeDr=SessionTypeDr
	}
	s SessionTypeDr=FindSessionTypeDr
	//s SessionTypeDr=$O(^RBC("SESS",0,"Desc",$$ALPHAUP^SSUTIL4(SessionTypeDesc),0))
	if (SessionTypeDr=""){
		q "-1^无效的职称"_SessionTypeDesc
	}
	s CLGRPDr=0,FindCLGRPDr=""
	if (CLGRPDesc'=""){
		for {
			s CLGRPDr=$o(^RBC("CLGRP",0,"Desc",$$ALPHAUP^SSUTIL4(CLGRPDesc),CLGRPDr)) Q:(CLGRPDr="")||(FindCLGRPDr'="")
			continue:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("RBC_ClinicGroup",CLGRPDr,ImportHospId)="N"
			s FindCLGRPDr=CLGRPDr
		}
		if (FindCLGRPDr="") {
			Q "-1^无效的亚专业"_CLGRPDesc
		}
		/*s CLGRPDr=$O(^RBC("CLGRP",0,"Desc",$$ALPHAUP^SSUTIL4(CLGRPDesc),0))
		if (CLGRPDr=""){
			q "-1^无效的亚专业"_CLGRPDesc
		}*/
	}
	s CLGRPDr=FindCLGRPDr
	s RoomDr=0,FindRoomDr=""
	if (RoomDesc'=""){
		for {
			s RoomDr=$O(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(RoomDesc),RoomDr)) Q:(RoomDr="")||(FindRoomDr'="")
			s RoomHospDr=$p(^CTLOC(RoomDr),"^",22)
			continue:RoomHospDr'=ImportHospId
			s FindRoomDr=RoomDr
		}
		if (FindRoomDr=""){
			q "-1^无效的诊室"_RoomDesc
		}
	}
	s RoomDr=FindRoomDr
	s ret=##class(DHCDoc.DHCDocConfig.ScheduleTemp).CheckBeforeSaveSess("",LocRowID,MarkRowID,WeekDr,TimeRangeDr,RSLRowID)
	q:(+ret<0) ret
	
	if (+SessLoad=0){
		q "-1^正号限额不能为空"
	}
	if (+SessNoApptSlot'=0)&&(+SessNumberOfWeeks=0){
		q "-1^预约限额不为空时,预约起始号不能为空"
	}
	if (SessLoad<SessNoApptSlot){
		q "-1^正号限额不能小于预约限额"
	}
	if (+SessNoApptSlot'=0){
		if (SessLoad-SessNumberOfWeeks+1)<SessNoApptSlot{
			q "-1^正号限额减去预约起始号要大于等于预约限额！"
		}
	}
	if (SessLoad>999){
		q "-1^正号限额不能超过999！"
	}
	s TRRegNumStr=""
	s TRRegInfoStr=""
	if (TRFlag="Y"){
		s ret=##Class(web.DHCRBResSession).TRInfoCalculate(TRStartTime,TREndTime,TRLength,TRRegNum)
		if (+ret'=0){
			q ret
		}else{
			s TRRegNumStr=$P(ret,"^",2)
			s TRRegInfoStr=$P(ret,"^",3)
		}
	}
	s OutPutStr="0^"_RSLRowID_"^"_ResRowID_"^"_WeekDr_"^"_TimeRangeDr
	s OutPutStr=OutPutStr_"^"_SessionTypeDr_"^"_CLGRPDr_"^"_RoomDr_"^"_SessLoad_"^"_SessNoApptSlot
	s OutPutStr=OutPutStr_"^"_SessNoSlots_"^"_AddtionMax_"^"_SessNumberOfWeeks_"^"_TRFlag_"^"_TRStartTime
	s OutPutStr=OutPutStr_"^"_TREndTime_"^"_TRLength_"^"_TRRegNum_"^"_TRRegNumStr_"^"_TRRegInfoStr
	q OutPutStr
}

/// 导入排版模板
/// w ##Class(DHCDoc.OPAdm.ScheduleTemp).ImportRBResSessData()
ClassMethod ImportRBResSessData(SessData As %String, ExpStr As %String)
{
	s OutPutStr=..ValidateRBResSessData(SessData,ExpStr)
	q:(+OutPutStr<0) OutPutStr
	s AppMethodStr=$P(SessData,"^",19)	//预约方式信息（方式|限额|起始号）
	s RSLRowID=$P(OutPutStr,"^",2)
	s ResRowID=$P(OutPutStr,"^",3)
	s WeekDr=$P(OutPutStr,"^",4)
	s TimeRangeDr=$P(OutPutStr,"^",5)
	s SessionTypeDr=$P(OutPutStr,"^",6)
	s CLGRPDr=$P(OutPutStr,"^",7)
	s RoomDr=$P(OutPutStr,"^",8)
	s SessLoad=$P(OutPutStr,"^",9)
	s SessNoApptSlot=$P(OutPutStr,"^",10)
	s SessNoSlots=$P(OutPutStr,"^",11)
	s AddtionMax=$P(OutPutStr,"^",12)
	s SessNumberOfWeeks=$P(OutPutStr,"^",13)
	s TRFlag=$P(OutPutStr,"^",14)
	s TRStartTime=$P(OutPutStr,"^",15)
	s TREndTime=$P(OutPutStr,"^",16)
	s TRLength=$P(OutPutStr,"^",17)
	s TRRegNum=$P(OutPutStr,"^",18)
	s TRRegNumStr=$P(OutPutStr,"^",19)
	s TRRegInfoStr=$P(OutPutStr,"^",20)
	
	s LocId=$P(^RB("RES",ResRowID),"^",1)
	s DocId=$P(^RB("RES",ResRowID),"^",2)
	s DOW=WeekDr_$C(1)_$P(^CT("DOW",1,WeekDr),"^",1)
	s TStartTime=$P(^DHCTimeRange(TimeRangeDr),"^",3)
	s TEndTime=$P(^DHCTimeRange(TimeRangeDr),"^",4)
	s:TStartTime'="" TStartTime=..%ZT(TStartTime,1)
	s:TEndTime'="" TEndTime=..%ZT(TEndTime,1)
	
	s SessPatientType="O"
	s AutoLoad=""
	s ExtLoad=""
	s InsertData=""_"^"_DOW_"^"_TStartTime_"^"_TEndTime_"^^"_SessLoad_"^"_SessNoSlots_"^"_SessNoApptSlot
	s InsertData=InsertData_"^"_SessNumberOfWeeks_"^"_AddtionMax_"^"_RoomDr_"^"_SessionTypeDr_"^"_CLGRPDr_"^"_SessPatientType_"^"_TimeRangeDr_"^"_"Y"
	s InsertData=InsertData_"^"_TRFlag_"^"_TRStartTime_"^"_TREndTime_"^"_TRLength_"^"_TRRegNum_"^"_TRRegNumStr_"^"_TRRegInfoStr_"^"_AutoLoad_"^"_ExtLoad
	
	TS
	if (CLGRPDr'=""){
		s LocSpecCount=0
		&sql(select count(DHCLS_Loc_DR) into :LocSpecCount from SQLUSER.DHC_LocSpec where DHCLS_Loc_DR=:LocId and DHCLS_CG_DR=:CLGRPDr)
		if (SQLCODE=0)&&(LocSpecCount=0)
		{
			//自动插入科室及专业组对照
			d ##Class(web.DHCLocSpec).InsertLocSpec(LocId,CLGRPDr)
		}
	}
	s ret=##class(DHCDoc.DHCDocConfig.ScheduleTemp).GetDocDateRowid(LocId, DocId, RSLRowID)
	if (+ret'=0){
		TRO
		q ret_"^插入班次失败"
	}
	s ResEffDate=$P(ret,"^",2)
	s ret=##Class(web.DHCRBResSession).Insert(ResEffDate,InsertData)
	if (+ret'=0){
		TRO
		q ret_"^插入排版模板失败"
	}
	s SessRowId=$P(ret,"^",2)
	s RetSessRowId=$P(ret,"^",2)
	s paraString=""
	for i=1:1:$L(AppMethodStr,"&") {
		s OneAppMethod=$P(AppMethodStr,"&",i)
		if (OneAppMethod=""){
			continue
		}
		s ApptMethod=$P(OneAppMethod,"|",1)
		s AppQty=$P(OneAppMethod,"|",2)
		s AppStartNum=$P(OneAppMethod,"|",3)
		s ApptMethodDr=$O(^RBC("APTM",0,"Desc",ApptMethod,0))
		if (paraString="") {
			s paraString=SessRowId_"^"_ApptMethodDr_"^"_AppQty_"^"_AppStartNum
		}else{
			s paraString=paraString_","_SessRowId_"^"_ApptMethodDr_"^"_AppQty_"^"_AppStartNum
		}
		
		
	}
	if (paraString'=""){
		s ret=##Class(web.DHCRBResEffDateSessAppQty).SaveScheduleAppQty(paraString)
		if (+ret'=0){
			TRO
			q ret_"^插入预约方式限额失败"
		}
	}
	
	TC
	q 0_"^"_RetSessRowId
}

Query QueryClinicGroup(SessRowid As %String = "") As %Query(ROWSPEC = "id:%String,text:%String")
{
}

// D ##class(%ResultSet).RunQuery("DHCDoc.OPAdm.ScheduleTemp","QueryClinicGroup","7||1||1")

ClassMethod QueryClinicGroupExecute(ByRef qHandle As %Binary, SessRowid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	if SessRowid=""{
		s qHandle=$lb(0,repid,0) 
		Quit $$$OK
	}
	s Str=$G(^RB("RES",+SessRowid,"DATE",$P(SessRowid,"||",2),"SESS",$P(SessRowid,"||",3)))
	s ClinicGroupStr=$P(Str,"^",42)
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

ClassMethod QueryClinicGroupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryClinicGroupExecute ]
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

ClassMethod QueryClinicGroupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryClinicGroupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
