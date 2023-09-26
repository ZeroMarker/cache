Class web.DHCDocRegConfigDataCheck Extends DHCDoc.Util.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 资源监测情况
/// d ##class(%ResultSet).RunQuery("web.DHCDocRegConfigDataCheck","ResConfigDataCheck","238","","")
Query ResConfigDataCheck(StartDate As %String, EndDate As %String, LocId As %String, MarkId As %String, HospID As %String = "") As websys.Query(CONTAINID = 0, ROWSPEC = "ResRowId:%String:资源ID,LocDesc:%String:科室,MarkDdesc:%String:医生号别,chkMsg:%String:监测结果")
{
}

ClassMethod ResConfigDataCheckExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, LocId As %String, MarkId As %String, HospID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	kill ^||tmpItemArr
	if (StartDate="") s StartDate=..%SysDate()
	else  s StartDate=..%ZDH(StartDate)
	if (EndDate="") s EndDate=..%SysDate()
	else  s EndDate=..%ZDH(EndDate)
	if (LocId'="")&&(MarkId'="") {
		s ResRowId=$o(^RB("RES",0,"CTPCP",MarkId,LocId,""))
		d GetOutPutData
	}elseif (LocId'="")&&(MarkId="") {
		s ResRowId=""
		for {
			s ResRowId=$o(^RB("RES",0,"CTLOC",LocId,ResRowId)) Q:ResRowId=""
			d GetOutPutData
		}
	}else{
		s ResRowId=""
		for {
			s ResRowId=$o(^RB("RES",ResRowId)) Q:ResRowId=""
			d GetOutPutData
		}
	}
	s locId=0
	for {
		s locId=$o(^||tmpItemArr(locId)) Q:locId=""
		s ResRowId=0
		for {
			s ResRowId=$o(^||tmpItemArr(locId,ResRowId)) Q:ResRowId=""
			s Data=$g(^||tmpItemArr(locId,ResRowId))
			d OutputRow21
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRow21
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
RecordSortTmpData
	Set ^||tmpItemArr(locId,ResRowId)=Data
	Q
GetOutPutData
  Q:ResRowId=""
  s chkMsg="" //监测结果
  s markId=$p(^RB("RES",ResRowId),"^",2)
  s locId=$p(^RB("RES",ResRowId),"^",1)
  s LocHospDr=$p($g(^CTLOC(locId)),"^",22)
  Q:LocHospDr'=HospID
  
  s HaveScheduleFlag=0
  for ASDate=StartDate:1:EndDate {
	  s ASSessStartTime=""
	  for {
	  	 s ASSessStartTime=$o(^RBAS(ResRowId,0,"DateSTime",ASDate,ASSessStartTime)) Q:(ASSessStartTime="")||(HaveScheduleFlag=1)
	  	 s ASChildSub=0  
	  	 for {
		  	 s ASChildSub=$O(^RBAS(ResRowId,0,"DateSTime",ASDate,ASSessStartTime,ASChildSub)) q:(ASChildSub="")||(HaveScheduleFlag=1) 
			 s status=$P($G(^RBAS(ResRowId,ASChildSub,"DHC")),"^",10)
			 i status'="" s status=$P(^DHCRBCASStatus(status),"^",1)
			 ;被替诊的可以再次被安排
			 continue:(status="TR")!(status="S")
			 s HaveScheduleFlag=1
		}
	  }
  }
  //监测时间段内没有有效排班记录,不做监测
  Q:HaveScheduleFlag=0
  ;1、监测是否有挂号权限可挂
  s GroupHaveRegGranted=0 //安全组是否授权过挂号权限
  s GroupMarkHaveGranted=0 //资源是否授权过挂号权限
  s GroupId=0
  for {
	  s GroupId=$o(^SSU("SSGRP",GroupId)) Q:GroupId=""
	  s GrantedMarkStr=$P($g(^SSU("SSGRP",GroupId,"DHC")),"^",1)
	  if (GrantedMarkStr'="") s GroupHaveRegGranted=1
	  else  s GroupMarkHaveGranted=1
	  if (GrantedMarkStr'="")&&(("!"_GrantedMarkStr_"!")[("!"_ResRowId_"!")) s GroupMarkHaveGranted=1
	  Q:(GroupHaveRegGranted=1)&&(GroupMarkHaveGranted=1)
  }
  if (GroupHaveRegGranted=1)&&(GroupMarkHaveGranted=0) {
	  s chkMsg="无挂号权限可挂"
  }
  ;2、监测是否进行医生号别对照
  s MarkDocFlag=0
  s markdocId=0
  for {
	  s markdocId=$o(^User.DHCMarkDocI("MarkddepDrIndex",locId,markdocId)) Q:(markdocId="")||(MarkDocFlag=1)
	  s MarkdMarkDr=$lg(^User.DHCMarkDocD(markdocId),3)
	  continue:(MarkdMarkDr'=markId)
	  s MarkDocFlag=1
  }
  if (MarkDocFlag=0) {
	  s Msg="无医生号别对照记录"
	  if (chkMsg="") s chkMsg=Msg
	  else  s chkMsg=chkMsg_" ; "_Msg
  }
  ;3、监测诊区号别对照
  if '$d(^User.DHCDepMarkI("DempDepDrMarkDrIndex"," "_locId,markId)) {
	  s Msg="无诊区号别对照记录"
	  if (chkMsg="") s chkMsg=Msg
	  else  s chkMsg=chkMsg_" ; "_Msg
  }
  Q:chkMsg=""
  s MarkDdesc=$p(^CTPCP(markId,1),"^",2)
  s LocDesc=$p(^CTLOC(locId),"^",2)
  s Data=$lb(ResRowId,LocDesc,MarkDdesc,chkMsg)
  d RecordSortTmpData
  Q
}

/// d ##class(%ResultSet).RunQuery("web.DHCDocRegConfigDataCheck","CheckOrdItemLabSpec",2)
Query ExaBorRoomConfigDataCheck(HospID = "") As websys.Query(CONTAINID = 0, ROWSPEC = "index:%String:序号,desc:%String:监测项目,chkMsg:%String:监测结果")
{
}

ClassMethod ExaBorRoomConfigDataCheckExecute(ByRef qHandle As %Binary, HospID = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	;1、监测诊室是否有对照诊区
	s RoomDr=0
	for {
		s RoomDr=$o(^CTLOC(0,"LocType","OR",RoomDr)) Q:RoomDr=""
		if '$d(^User.DHCBorExaRoomI("BordExaRoomDrIndex"," "_RoomDr)) {
			s DateActiveFrom=$p(^CTLOC(RoomDr),"^",24)
			continue:(DateActiveFrom'="")&&(DateActiveFrom>+$h)
			s DateActiveTo=$p(^CTLOC(RoomDr),"^",25)
			continue:(DateActiveTo'="")&&(DateActiveTo<=..%SysDate())
			s desc=$p(^CTLOC(RoomDr),"^",2)
			s RoomHospDr=$p(^CTLOC(RoomDr),"^",22)
			continue:RoomHospDr'=HospID
			s chkMsg="诊室无对照诊区"
			d OutputRow22
		}
	}
	;2、监测诊区是否有操作员诊区对照
	s borid=0
	for {
		s borid=$o(^User.DHCExaBoroughD(borid)) Q:borid=""
		if '$d(^User.DHCBorUserI("BoruBorDrIndex",borid)) {
			s desc=$lg(^User.DHCExaBoroughD(borid),5)
			s ExabHospitalDr=$lg(^User.DHCExaBoroughD(borid),13)
			continue:ExabHospitalDr'=HospID
			s chkMsg="诊区无对照操作员"
			d OutputRow22
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRow22
	Set ^CacheTemp(repid,ind)=$LB(ind,desc,chkMsg)
	Set ind=ind+1
	quit
}

Query CheckAppCatInTemp(HospID = "") As websys.Query(CONTAINID = 0, ROWSPEC = "index:%String:序号,desc:%String:监测项目,chkMsg:%String:监测结果")
{
}

ClassMethod CheckAppCatInTempExecute(ByRef qHandle As %Binary, HospID = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	k ^tmp("ArcItmCat",$J)
	s ArcItmCat=""
	f  s ArcItmCat=$O(^ARC("IC",ArcItmCat)) q:ArcItmCat=""  d
	.s OrderType= $P(^ARC("IC",ArcItmCat),"^",7)
	.q:(OrderType'="X")&&(OrderType'="L")
	.s APTRowId=""
	.f  s APTRowId=$o(^DHCAPPPRT(0,"Arc",ArcItmCat,APTRowId)) q:APTRowId=""  d  /// 去模板关联表ID
	..s APTTemp=$p(^DHCAPPPRT(APTRowId),"^",2)	
	..s ^tmp("ArcItmCat",$J,ArcItmCat)=APTTemp
	.i '$D(^tmp("ArcItmCat",$J,ArcItmCat)) s ^tmp("ArcItmCat",$J,ArcItmCat)=""
	s id="" f  s id=$O(^tmp("ArcItmCat",$J,id))  q:id=""  d
	.q:^tmp("ArcItmCat",$J,id)'=""
	.s desc=$P(^ARC("IC",id),"^",2)
	.s chkMsg="子类未配置打印模板"
	.d OutputRowTemp

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRowTemp
	Set ^CacheTemp(repid,ind)=$LB(ind,desc,chkMsg)
	Set ind=ind+1
	quit
}

Query CheckOrdItemLabSpec(HospID = "") As websys.Query(CONTAINID = 0, ROWSPEC = "index:%String:序号,desc:%String:监测项目,chkMsg:%String:监测结果")
{
}

ClassMethod CheckOrdItemLabSpecExecute(ByRef qHandle As %Binary, HospID = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	s ARCIMSubscript=0  
	f  s ARCIMSubscript=$o(^ARCIM(ARCIMSubscript)) q:ARCIMSubscript=""  d
	.s ARCIMVersion=""
	.f  s ARCIMVersion=$o(^ARCIM(ARCIMSubscript,ARCIMVersion)) q:ARCIMVersion=""  d
	..s desc=$P(^ARCIM(ARCIMSubscript,ARCIMVersion,1),"^",2)
	..s ItemCatRowID=$P(^ARCIM(ARCIMSubscript,ARCIMVersion,1),"^",10)
	..s Ordtype=$p(^ARC("IC",ItemCatRowID),"^",7)
	..//q:Ordtype'="L"
	..q:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("ARC_ItmMast",ARCIMSubscript_"||"_ARCIMVersion,HospID)="N"
	..s ARCIMEffDateTo=$P($G(^ARCIM(ARCIMSubscript,ARCIMVersion,7)),"^",1)
	..q:((ARCIMEffDateTo'="")&&(ARCIMEffDateTo<+$H))
	..s ContactName=""
	..s id=ARCIMSubscript_"||"_ARCIMVersion
	..//d OutputRow1
	..s LabSpec=..GetLocRecLoc(id,HospID)
	..q:LabSpec'=""
	..s chkMsg="医嘱未维护标本"
	..d OutputRowOrdLab

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRowOrdLab
	Set ^CacheTemp(repid,ind)=$LB(ind,desc,chkMsg)
	Set ind=ind+1
	quit
}

Query CheckOrdItemRecLoc(HospID = "") As websys.Query(CONTAINID = 0, ROWSPEC = "index:%String:序号,desc:%String:监测项目,chkMsg:%String:监测结果")
{
}

ClassMethod CheckOrdItemRecLocExecute(ByRef qHandle As %Binary, HospID = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	s ARCIMSubscript=0  
	f  s ARCIMSubscript=$o(^ARCIM(ARCIMSubscript)) q:ARCIMSubscript=""  d
	.s ARCIMVersion=""
	.f  s ARCIMVersion=$o(^ARCIM(ARCIMSubscript,ARCIMVersion)) q:ARCIMVersion=""  d
	..s desc=$P(^ARCIM(ARCIMSubscript,ARCIMVersion,1),"^",2)
	..s ItemCatRowID=$P(^ARCIM(ARCIMSubscript,ARCIMVersion,1),"^",10)
	..s Ordtype=$p(^ARC("IC",ItemCatRowID),"^",7)
	..//q:Ordtype'="L"
	..q:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("ARC_ItmMast",ARCIMSubscript_"||"_ARCIMVersion,HospID)="N"
	..s ARCIMEffDateTo=$P($G(^ARCIM(ARCIMSubscript,ARCIMVersion,7)),"^",1)
	..q:((ARCIMEffDateTo'="")&&(ARCIMEffDateTo<+$H))
	..s ContactName=""
	..s id=ARCIMSubscript_"||"_ARCIMVersion
	..//d OutputRow1
	..s LabSpec=..GetLocRecLoc(id,HospID)
	..q:LabSpec'=""
	..s chkMsg="医嘱未维护接收科室"
	..d OutputRowRecLoc

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRowRecLoc
	Set ^CacheTemp(repid,ind)=$LB(ind,desc,chkMsg)
	Set ind=ind+1
	quit
}

ClassMethod GetLocRecLoc(Arcim As %String, HospitalID As %String = "") As %String
{
	s ret=""
	s ret=..GetLocRecLocByItem(Arcim, HospitalID)
	Q:ret'="" ret
	;
	s ItemCat=$P($g(^ARCIM(+Arcim,$p(Arcim,"||",2),1)),"^",10 )
	Q:ItemCat="" ""
	s ret=..GetLocRecLocByItemCat(ItemCat, HospitalID)
	Q:ret'="" ret

	s OrderCat=$P($g(^ARC("IC",ItemCat)),"^",8)
	Q:OrderCat="" ""
	s ret=..GetLocRecLocByCat(OrderCat, HospitalID)

	Q ret
}

ClassMethod GetLocRecLocByCat(OrderCat As %String, HospitalID As %String = "") As %String
{
	s ret="",ret1=""
	s Today=..%SysDate()
	s ToTime=..%SysTime()
	s DefaultOrdLocRecLoc="",OrdLocRecLoc="",DefaultNoOrdLocRecLoc="",NoOrdLocRecLoc=""
	s sub=0  f  s sub=$O(^OEC("ORCAT",OrderCat,"RL",sub)) Q:(sub="")||(ret'="")  d
	. s OrdLoc=$P($g(^OEC("ORCAT",OrderCat,"RL",sub)),"^", 2)
	. //Q:(EpLoc'=OrdLoc)&&(OrdLoc'="")
	. s TimeFrom=$P($g(^OEC("ORCAT",OrderCat,"RL",sub)),"^", 5)
	. s TimeTo=$P($g(^OEC("ORCAT",OrderCat,"RL",sub)),"^", 6)
	. s DateFrom=$P($g(^OEC("ORCAT",OrderCat,"RL",sub)),"^", 8)
	. s DateTo=$P($g(^OEC("ORCAT",OrderCat,"RL",sub)),"^", 9)
	. Q:(DateFrom'="")&&(DateFrom>Today)
	. Q:(DateTo'="")&&(DateTo<Today)
	. Q:((TimeFrom'="")&(ToTime<TimeFrom))!((TimeTo'="")&(ToTime>TimeTo))
	. s Default=$P($g(^OEC("ORCAT",OrderCat,"RL",sub)),"^", 4)
	. s RecLoc=$P($g(^OEC("ORCAT",OrderCat,"RL",sub)),"^", 3)
	. Q:'##class(DHCDoc.DHCDocConfig.LocExt).LocActive(RecLoc)
	. s RecLocDesc=$P($g(^CTLOC(RecLoc)),"^",2)
	. s OrderPriority=$P($g(^OEC("ORCAT",OrderCat,"RL",sub)),"^",10)
	. s RecLocHospitalID=$P($g(^CTLOC(RecLoc)),"^",22)
	. Q:(RecLocHospitalID'=HospitalID)
	. s ClinicType=$P($g(^OEC("ORCAT",OrderCat,"RL",sub)),"^", 12)
	. //Q:((admType'="")&&(ClinicType'="")&&(admType'=ClinicType))
	. s ret=RecLocDesc
	Q ret
}

ClassMethod GetLocRecLocByItem(Arcim As %String, HospitalID As %String = "") As %String
{
	s ret="",ret1=""
	s Today=..%SysDate()
	s ToTime=..%SysTime()
	
	s DefaultOrdLocRecLoc="",OrdLocRecLoc="",DefaultNoOrdLocRecLoc="",NoOrdLocRecLoc=""
	s sub=0  f  s sub= $O(^ARCRL(+Arcim,sub))  Q:(sub="")  d 
	. s OrdLoc=$P($g(^ARCRL(+Arcim,sub)),"^", 1)
	. //Q:(EpLoc'=OrdLoc)&&(OrdLoc'="")
	. s TimeFrom=$P($g(^ARCRL(+Arcim,sub)),"^", 5)
	. s TimeTo=$P($g(^ARCRL(+Arcim,sub)),"^", 6)
	. s DateFrom=$P($g(^ARCRL(+Arcim,sub)),"^", 8)
	. s DateTo=$P($g(^ARCRL(+Arcim,sub)),"^", 9)
	. Q:(DateFrom'="")&&(DateFrom>Today)
	. Q:(DateTo'="")&&(DateTo<Today)
	. Q:((TimeFrom'="")&(ToTime<TimeFrom))!((TimeTo'="")&(ToTime>TimeTo))
	. s Default=$P($g(^ARCRL(+Arcim,sub)),"^", 4)
	. s RecLoc=$P($g(^ARCRL(+Arcim,sub)),"^", 2)
	. Q:'##class(DHCDoc.DHCDocConfig.LocExt).LocActive(RecLoc)
	. s RecLocDesc=$P(^CTLOC(RecLoc),"^",2)
	. s OrderPriority=$P($g(^ARCRL(+Arcim,sub)),"^", 10)
	
	. s RecLocHospitalID=$P($g(^CTLOC(RecLoc)),"^",22)
	. Q:(RecLocHospitalID'=HospitalID)
	. s ClinicType=$P($g(^ARCRL(+Arcim,sub)),"^", 12)
	. //Q:((admType'="")&&(ClinicType'="")&&(admType'=ClinicType))
	. s RecLocDesc=$P(^CTLOC(RecLoc),"^",2)
	 Q ret
}

ClassMethod GetLocRecLocByItemCat(ItemCat As %String, HospitalID As %String = "") As %String
{
	s ret="",ret1=""
	s Today=..%SysDate()
	s ToTime=..%SysTime()
	
	
	s DefaultOrdLocRecLoc="",OrdLocRecLoc="",DefaultNoOrdLocRecLoc="",NoOrdLocRecLoc=""
	 
	 s rl=0  f  s rl=$O(^ARC("IC",ItemCat,"RL",rl)) q:(rl="")||(ret'="")  d
	 . s OrdLoc=$P($g(^ARC("IC",ItemCat,"RL",rl)),"^",2)
	 . //Q:(EpLoc'=OrdLoc)&&(OrdLoc'="")
	 . s TimeFrom=$P($g(^ARC("IC",ItemCat,"RL",rl)),"^",5)
	 . s TimeTo=$P($g(^ARC("IC",ItemCat,"RL",rl)),"^",6)
	 . s DateFrom=$P($g(^ARC("IC",ItemCat,"RL",rl)),"^",8)
	 . s DateTo=$P($g(^ARC("IC",ItemCat,"RL",rl)),"^",9)
	 . Q:(DateFrom'="")&&(DateFrom>Today)
	 . Q:(DateTo'="")&&(DateTo<Today)
	 . Q:((TimeFrom'="")&(ToTime<TimeFrom))!((TimeTo'="")&(ToTime>TimeTo))
	 . s RecLoc=$P($g(^ARC("IC",ItemCat,"RL",rl)),"^",3)
	 . Q:'##class(DHCDoc.DHCDocConfig.LocExt).LocActive(RecLoc)
	 . s Default=$P($g(^ARC("IC",ItemCat,"RL",rl)),"^",4)
	 . s RecLocDesc=$P(^CTLOC(RecLoc),"^",2)
	 . s OrderPriority=$P($g(^ARC("IC",ItemCat,"RL",rl)),"^",10)
	 . s RecLocHospitalID=$P(^CTLOC(RecLoc),"^",22)
	 . Q:(RecLocHospitalID'=HospitalID)
	 . s ClinicType=$P($g(^ARC("IC",ItemCat,"RL",rl)),"^",12)
	 . //Q:((admType'="")&&(ClinicType'="")&&(admType'=ClinicType))
	 . s ret=RecLocDesc
	
	 Q ret
}

}
