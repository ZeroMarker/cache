Class DHCExternalService.RegInterface.SynVisitSchedule Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Not ProcedureBlock ]
{

/// w ##class(DHCExternalService.RegInterface.SynVisitSchedule).AutoSynSchedule()
/// 自动同步排班信息
ClassMethod AutoSynSchedule()
{
	s CurDate=+$H
	s IntervaDays=7  ;上传几天后的排班
	s Date=CurDate+IntervaDays
	s Date=$ZD(Date,3)
	q ..SynVisitSchedule(Date,Date)
}

/// ^DHCOPSynVisitSchedule("Success","SynVisitSchedule")
/// 同步排班信息 2011-10-01
ClassMethod SynVisitSchedule(StartDate As %String = "", EndDate As %String = "") As %String
{
	;w ##class(DHCExternalService.RegInterface.SynVisitSchedule).SynVisitSchedule("2011-11-02","2011-11-08")
	s $ZT="SynScheduleErr"
	set myJob=$job
	s ErrCount=0,AllCount=0
	q:StartDate="" "-1^开始日期不能为空"
	q:EndDate="" "-1^结束日期不能为空"
	i $L(StartDate,"-")'=3 q "-1^开始日期格式不对"
	i $L(EndDate,"-")'=3 q "-1^结束日期格式不对"
	s StartDate=$ZDH(StartDate,3)
	s EndDate=$ZDH(EndDate,3)
	
	kill ^DHCOPSynVisitSchedule("Schedule",myJob)
	s ResID=0
	f  s ResID=$O(^RB("RES",ResID)) q:ResID=""  d
	.s Date=StartDate-1
	.f  s Date=$O(^RBAS(ResID,0,"DateSTime",Date)) q:(Date="")||(Date>EndDate)  d
	..s LastDate=+$G(^DHCOPSynVisitSchedule("LastDate"))
	..i LastDate<Date d
	...s ^DHCOPSynVisitSchedule("LastDate")=Date
	..s Time=0
	..f  s Time=$O(^RBAS(ResID,0,"DateSTime",Date,Time)) q:(Time="")  d
	...s Sub=0
	...f  s Sub=$O(^RBAS(ResID,0,"DateSTime",Date,Time,Sub)) q:(Sub="")  d
	....s RBASID=ResID_"||"_Sub
	....;s rtn=..SynOneSchedule(RBASID)
	....s RBASSessionLoad=..GetAppQty(RBASID)
	....q:(+RBASSessionLoad<1)
	....s rtn=..GetScheduleInfoByID(RBASID,myJob)
	....w rtn,!
	....s AllCount=AllCount+1
	....i +rtn'=0 d
	.....s ErrCount=ErrCount+1
	.....;w !,rtn
	set myrtn=..SynScheduleBatch(myJob)
	kill ^DHCOPSynVisitSchedule("Schedule",myJob)
	q "0^共"_AllCount_"条记录,其中"_ErrCount_"条不是正常的预约挂号的排班记录"
	
SynScheduleErr
	kill ^DHCOPSynVisitSchedule("Schedule",myJob)
	q "-1^SynVisitSchedule调用异常错误"_$ZERROR
}

ClassMethod GetScheduleInfoByID(RBASID As %String = "", myJob As %String) As %String
{
	s $ZT="GetScheduleInfoByIDET"
	//q:$D(^DHCOPSynVisitSchedule("Success","SynVisitSchedule",RBASID)) "-1^已经同步过"
	s LastDate=$G(^DHCOPSynVisitSchedule("LastDate"))
	s Obj=##class(User.RBApptSchedule).%OpenId(RBASID)
	//q:LastDate<Obj.ASDate "-1^在最后同步时间之后,不需要同步"
	q:Obj.ASRESParRef.RESCTPCPDRGetObjectId()="" "-1^医生为空不需要同步"
	s DHCRBASObj=##class(User.DHCRBApptSchedule).%OpenId(RBASID)
	q:DHCRBASObj.ASStatusDR.ASSCode="S" "-1^停诊" ;停诊
	q:DHCRBASObj.ASStatusDR.ASSCode="TR" "-1^被替诊" ;被替诊
	q:DHCRBASObj.ASStatusDR.ASSCode="PS" "-1^中途停诊" ;中途停诊
	
	s HospitalId=##class(DHCExternalService.RegInterface.GetRelate).GetOuterHospitalCodeFromHISId(Obj.ASRESParRef.RESCTLOCDR.CTLOCHospitalDR.%Id())
	s HospitalName=Obj.ASRESParRef.RESCTLOCDR.CTLOCHospitalDR.HOSPDesc
	if HospitalId="" {
		s HospitalId="02"
		s HospitalName="医大一院"
	}
	set OPTypeCode="",OPTypeName=""
	set OPTypeObj=Obj.ASRESParRef.RESCTLOCDR.CTLOCRespUnitDR
	if $IsObject(OPTypeObj)
	{
		set OPTypeCode=OPTypeObj.RUCode
		set OPTypeName=OPTypeObj.RUDesc
	}
	//2013-10-31
	s:OPTypeCode="" OPTypeCode="N"
	s:OPTypeName="" OPTypeName="普通"
	//q:OPTypeCode="" "-1^门诊类型不能为空"
	
	set index=(+$order(^DHCOPSynVisitSchedule("Schedule",myJob,HospitalId,OPTypeCode,""),-1))+1
	set ^DHCOPSynVisitSchedule("Schedule",myJob,HospitalId,OPTypeCode,index)=RBASID
	set ^DHCOPSynVisitSchedule("Schedule",myJob,HospitalId)=HospitalName
	set ^DHCOPSynVisitSchedule("Schedule",myJob,HospitalId,OPTypeCode)=OPTypeName
	
	q "0"
GetScheduleInfoByIDET
	q "-1^GetScheduleInfoByID调用异常错误"_$ZERROR
}

ClassMethod SynScheduleBatch(myJob As %String = "") As %String
{
	if (myJob="") quit "-1^"
	set BatchCount=15
	set myHospitalId=0
	while($order(^DHCOPSynVisitSchedule("Schedule",myJob,myHospitalId))'="")
	{
		set myHospitalId=$order(^DHCOPSynVisitSchedule("Schedule",myJob,myHospitalId))
		set myOPTypeCode=""
		while($order(^DHCOPSynVisitSchedule("Schedule",myJob,myHospitalId,myOPTypeCode))'="")
		{
			set myOPTypeCode=$order(^DHCOPSynVisitSchedule("Schedule",myJob,myHospitalId,myOPTypeCode))
			set myCount=$order(^DHCOPSynVisitSchedule("Schedule",myJob,myHospitalId,myOPTypeCode,""),-1)
			set mynum=myCount\BatchCount
			set mymod=myCount#BatchCount
			if (mymod'=0) set mynum=mynum+1
			for i=1:1:mynum
			{
				set InputObj=##class(DHCExternalService.RegInterface.Entity.SynVisitSchedule).%New()
				set InputObj.HIS="H1"
				set InputObj.TradeCode="2000"
				set InputObj.HospitalId=myHospitalId
				set InputObj.HospitalName=$get(^DHCOPSynVisitSchedule("Schedule",myJob,myHospitalId))
				set InputObj.OPTypeCode=myOPTypeCode
				set InputObj.OPTypeName=$get(^DHCOPSynVisitSchedule("Schedule",myJob,myHospitalId,myOPTypeCode))
				set InputObj.RBASCount=0
				set stnum=BatchCount*(i-1)
				set endnum=BatchCount*i
				while(($order(^DHCOPSynVisitSchedule("Schedule",myJob,myHospitalId,myOPTypeCode,stnum))'="")&&($order(^DHCOPSynVisitSchedule("Schedule",myJob,myHospitalId,myOPTypeCode,stnum))'>endnum))
				{
					set stnum=$order(^DHCOPSynVisitSchedule("Schedule",myJob,myHospitalId,myOPTypeCode,stnum))
					set RBASID=$get(^DHCOPSynVisitSchedule("Schedule",myJob,myHospitalId,myOPTypeCode,stnum))
					set Obj=##class(User.RBApptSchedule).%OpenId(RBASID)
					set RBASRecObj=..GetRBASRecObjByRBASObj(Obj)
					if (+RBASRecObj.RBASSessionLoad<1) continue
					do InputObj.RBAS.Insert(RBASRecObj)
					set InputObj.RBASCount=InputObj.RBASCount+1
					do Obj.%Close()
				}
				///开始推送
				if (+InputObj.RBASCount>0) set rtn=##class(DHCExternalService.RegInterface.InterfaceMethods).SynVisitSchedule(InputObj)
				do InputObj.%Close()
			}
		}
		
	}
	
	quit $get(rtn)
}

ClassMethod SynOneSchedule(RBASID As %String = "") As %String
{
	n (RBASID)
	s $ZT="SynOneScheduleErr"
	//q:$D(^DHCOPSynVisitSchedule("Success","SynVisitSchedule",RBASID)) "-1^已经同步过"
	s LastDate=$G(^DHCOPSynVisitSchedule("LastDate"))
	s Obj=##class(User.RBApptSchedule).%OpenId(RBASID)
	//q:LastDate<Obj.ASDate "-1^在最后同步时间之后,不需要同步"
	q:Obj.ASRESParRef.RESCTPCPDRGetObjectId()="" "-1^医生为空不需要同步"
	s DHCRBASObj=##class(User.DHCRBApptSchedule).%OpenId(RBASID)
	q:DHCRBASObj.ASStatusDR.ASSCode="S" "-1^停诊" ;停诊
	q:DHCRBASObj.ASStatusDR.ASSCode="TR" "-1^被替诊" ;被替诊
	q:DHCRBASObj.ASStatusDR.ASSCode="PS" "-1^中途停诊" ;中途停诊
	s InputObj=..GetInputObj("1")
	s InputObj.HospitalId=##class(DHCExternalService.RegInterface.GetRelate).GetOuterHospitalCodeFromHISId(Obj.ASRESParRef.RESCTLOCDR.CTLOCHospitalDR.%Id())
	s InputObj.HospitalName=Obj.ASRESParRef.RESCTLOCDR.CTLOCHospitalDR.HOSPDesc
	set InputObj.TradeCode="2000"
	
	set OPTypeCode="",OPTypeName=""
	set OPTypeObj=Obj.ASRESParRef.RESCTLOCDR.CTLOCRespUnitDR
	if $IsObject(OPTypeObj)
	{
		set OPTypeCode=OPTypeObj.RUCode
		set OPTypeName=OPTypeObj.RUDesc
	}
	if (OPTypeCode="") quit "-1^门诊分类不能为空"
	set InputObj.OPTypeCode=OPTypeCode
	set InputObj.OPTypeName=OPTypeName
	set InputObj.RBASCount="1"
	s RBASRecObj=..GetRBASRecObjByRBASObj(Obj)
	if (+RBASRecObj.RBASSessionLoad<1) quit "-1^可预约数量错误"
	d InputObj.RBAS.Clear()
	d InputObj.RBAS.Insert(RBASRecObj)
	;b ;InterfaceStar
	s rtn=##class(DHCExternalService.RegInterface.InterfaceMethods).SynVisitSchedule(InputObj)
	i +rtn=0 d
	.s ^DHCOPSynVisitSchedule("Success","SynVisitSchedule",RBASID)=$H
	.k ^DHCOPSynVisitSchedule("Failure","SynVisitSchedule",Obj.ASDate,RBASID)
	e  d
	.s ^DHCOPSynVisitSchedule("Failure","SynVisitSchedule",Obj.ASDate,RBASID)=$H_"^"_$P(rtn,"^",2)
	q rtn
SynOneScheduleErr
	q "-1^SynOneSchedule调用异常错误"_$ZERROR
}

/// 同步预约总数
ClassMethod SynRegCount(RBASID As %String = "") As %String
{
	n (RBASID)
	s $ZT="SynRegCountErr"
	;d ..SynOneSchedule(RBASID)
	;q:'$D(^DHCOPSynVisitSchedule("Success","SynVisitSchedule",RBASID)) "-1^记录没有同步过"
	s InputObj=..GetInputObj()
	s Obj=##class(User.DHCRBApptSchedule).%OpenId(RBASID)
	s InputObj.HospitalId=##class(DHCExternalService.RegInterface.GetRelate).GetOuterHospitalCodeFromHISId(Obj.ASRESParRef.RESCTLOCDR.CTLOCHospitalDR.%Id())
	s InputObj.RBASId=RBASID
	s RegNum=..GetAppQty(RBASID)
	s InputObj.RegCount=RegNum
	s rtn=##class(DHCExternalService.RegInterface.InterfaceMethods).SynRegCount(InputObj)
	s Obj=##class(User.RBApptSchedule).%OpenId(RBASID)
	i +rtn=0 d
	.s ^DHCOPSynVisitSchedule("Success","SynRegCount",RBASID)=$H
	.k ^DHCOPSynVisitSchedule("Failure","SynRegCount",Obj.ASDate,RBASID)
	e  d
	.s ^DHCOPSynVisitSchedule("Failure","SynRegCount",Obj.ASDate,RBASID)=$H_"^"_$P(rtn,"^",2)
	q rtn
SynRegCountErr
	q "-1^SynRegCount调用异常错误"_$ZERROR
}

/// 停诊
ClassMethod SynStopVisitSchedule(RBASID As %String = "") As %String
{
	n (RBASID)
	s $ZT="SynStopVisitScheduleErr"
	//q:'$D(^DHCOPSynVisitSchedule("Success","SynVisitSchedule",RBASID)) ""
	//q:$D(^DHCOPSynVisitSchedule("Success","SynStopVisitSchedule",RBASID)) ""
	s InputObj=..GetInputObj()
	s Obj=##class(User.DHCRBApptSchedule).%OpenId(RBASID)
	s InputObj.HospitalId=##class(DHCExternalService.RegInterface.GetRelate).GetOuterHospitalCodeFromHISId(Obj.ASRESParRef.RESCTLOCDR.CTLOCHospitalDR.%Id())
	//s InputObj.HospitalName=Obj.ASRESParRef.RESCTLOCDR.CTLOCHospitalDR.HOSPDesc
	s InputObj.RBASId=RBASID
	s InputObj.RBASREASON=Obj.ASReasonNotAvailDR.RNAVDesc
	s rtn=##class(DHCExternalService.RegInterface.InterfaceMethods).SynStopVisitSchedule(InputObj)
	s Obj=##class(User.RBApptSchedule).%OpenId(RBASID)
	i +rtn=0 d
	.s ^DHCOPSynVisitSchedule("Success","SynStopVisitSchedule",RBASID)=$H
	.k ^DHCOPSynVisitSchedule("Failure","SynStopVisitSchedule",Obj.ASDate,RBASID)
	e  d
	.s ^DHCOPSynVisitSchedule("Failure","SynStopVisitSchedule",Obj.ASDate,RBASID)=$H_"^"_$P(rtn,"^",2)
	q rtn
	
SynStopVisitScheduleErr
	q "-1^SynStopVisitSchedule调用异常错误"_$ZERROR
}

/// 替诊
ClassMethod SynReplaceVisitSchedule(RBASID As %String = "") As %String
{
	n (RBASID)
	s $ZT="SynReplaceVisitScheduleErr"
	//q:'$D(^DHCOPSynVisitSchedule("Success","SynVisitSchedule",RBASID)) ""
	//q:$D(^DHCOPSynVisitSchedule("Success","SynReplaceVisitSchedule",RBASID)) ""
	s InputObj=..GetInputObj("1")
	s Obj=##class(User.DHCRBApptSchedule).%OpenId(RBASID)
	s InputObj.HospitalId=##class(DHCExternalService.RegInterface.GetRelate).GetOuterHospitalCodeFromHISId(Obj.ASRESParRef.RESCTLOCDR.CTLOCHospitalDR.%Id())
	s InputObj.RBASId=RBASID
	s InputObj.RBASREASON=Obj.ASReasonNotAvailDR.RNAVDesc
	s RepASID=Obj.ASASDR
	b ;RepASID
	s RepASObj=##class(User.RBApptSchedule).%OpenId(RepASID)
	s RBASRecObj=..GetRBASRecObjByRBASObj(RepASObj)
	s AppPlatformQty=0
	s MethodDR=0
	for {
		s MethodDR=$O(^RBC("APTM",MethodDR)) q:MethodDR=""
		s MethodCode=$p($g(^RBC("APTM",MethodDR)),"^",1)
		s PlatformFlag=$p($g(^RBC("APTM",MethodDR,"DHC")),"^",1)
		if PlatformFlag="Y" {
			set myApptedCount=##Class(DHCExternalService.RegInterface.RegManager).GetApptedCount(RBASID,MethodCode)
			set AppPlatformQty=AppPlatformQty+myApptedCount
		}
	}
	set RBASRecObj.RBASSessionLoad=RBASRecObj.RBASSessionLoad-AppPlatformQty
	if (RBASRecObj.RBASSessionLoad<0) set RBASRecObj.RBASSessionLoad=0
	s InputObj.RBASRec=RBASRecObj
	s rtn=##class(DHCExternalService.RegInterface.InterfaceMethods).SynReplaceVisitSchedule(InputObj)
	i +rtn=0 d
	.s ^DHCOPSynVisitSchedule("Success","SynReplaceVisitSchedule",RBASID)=$H
	.k ^DHCOPSynVisitSchedule("Failure","SynReplaceVisitSchedule",RepASObj.ASDate,RBASID)
	.s ^DHCOPSynVisitSchedule("Success","SynVisitSchedule",RepASID)=$H
	e  d
	.s ^DHCOPSynVisitSchedule("Failure","SynReplaceVisitSchedule",RepASObj.ASDate,RBASID)=$H_"^"_$P(rtn,"^",2)
	q rtn
	
SynReplaceVisitScheduleErr
	q "-1^SynReplaceVisitSchedule调用异常错误"_$ZERROR
}

/// 得到入参对象
ClassMethod GetInputObj(IncludeHIS As %String = "0") As DHCExternalService.RegInterface.Entity.SynVisitSchedule
{
	s InputObj=##class(DHCExternalService.RegInterface.Entity.SynVisitSchedule).%New()
	s:IncludeHIS="1" InputObj.HIS="H1"
	s InputObj.TransactionId=""
	q InputObj
}

/// 得到单个出诊信息对象
ClassMethod GetRBASRecObjByRBASObj(RBASObj As User.RBApptSchedule) As DHCExternalService.RegInterface.Entity.RBASRec
{
	n (RBASObj)
	s RBASSessionLoad=..GetAppQty(RBASObj.%Id())
	s RtnObj=##class(DHCExternalService.RegInterface.Entity.RBASRec).%New()
	s DHCRBASObj=##class(User.DHCRBApptSchedule).%OpenId(RBASObj.%Id())
	s RtnObj.RBASSessionLoad=RBASSessionLoad
	q:+RtnObj.RBASSessionLoad=0 RtnObj
	s RtnObj.RBASId=RBASObj.%Id()
	s RtnObj.RBASDate=$ZD(RBASObj.ASDate,3)
	s RtnObj.RBASWeekDay=$ZD(RBASObj.ASDate,10)
	s:RtnObj.RBASWeekDay=0 RtnObj.RBASWeekDay=7
	s RtnObj.RBASSessionCode=DHCRBASObj.ASTimeRangeDR.TRCode
	if ('$IsObject(DHCRBASObj.ASTimeRangeDR)) s RtnObj.RBASSessionLoad=0 q RtnObj
	s RtnObj.RBASSessionCode=##class(GetRelate).GetOuterTimeRangeCode(DHCRBASObj.ASTimeRangeDR.%Id())
	s RtnObj.RBASSessionName=DHCRBASObj.ASTimeRangeDR.TRDesc
	s RtnObj.DoctorId=RBASObj.ASRESParRef.RESCTPCPDRGetObjectId()
	s RtnObj.DoctorName=RBASObj.ASRESParRef.RESCTPCPDR.CTPCPDesc
	s RtnObj.DoctorTitleCode=RBASObj.ASRESParRef.RESCTPCPDR.CTPCPCarPrvTpDR.CTCPTCode
	s RtnObj.DoctorTitle=RBASObj.ASRESParRef.RESCTPCPDR.CTPCPCarPrvTpDR.CTCPTDesc
	s RtnObj.DeptId=RBASObj.ASRESParRef.RESCTLOCDRGetObjectId()
	s RtnObj.Dept=RBASObj.ASRESParRef.RESCTLOCDR.CTLOCDesc
	s RtnObj.SubjectId=DHCRBASObj.ASClinicGroupDRGetObjectId()
	s RtnObj.Subject=DHCRBASObj.ASClinicGroupDR.CLGRPDesc
	s RtnObj.DoctorIntro=RBASObj.ASRESParRef.RESCTPCPDR.CTPCPSpecDR.CTSPCDesc //医生介绍
	
	s RtnObj.RegFee=##class(web.DHCOPAdmReg).GetSchedulFeeByConStr(RBASObj.%Id(),"Reg") //挂号费
	s RtnObj.CheckupFee=##class(web.DHCOPAdmReg).GetSchedulFeeByConStr(RBASObj.%Id(),"Check") //检查费
	s RtnObj.ServiceFee="" ;##class(web.DHCOPAdmReg).GetScheduleFee(RBASObj.%Id(),"",+$H,"||1|1|||") //服务费
	s RtnObj.OtherFee="" //##class(web.DHCOPAdmReg).GetScheduleFee(RBASObj.%Id(),"",+$H,"||1|1|||") //其它费
	s RtnObj.RBASPrice=RtnObj.RegFee+RtnObj.CheckupFee+RtnObj.ServiceFee+RtnObj.OtherFee //总挂号费
	
	s RtnObj.RBASSessionTypeId=DHCRBASObj.ASSessionTypeDRGetObjectId()
	s RtnObj.RBASSessionType=DHCRBASObj.ASSessionTypeDR.SESSDesc
	s RtnObj.RBASSessionType=$P(RtnObj.RBASSessionType,"(",1)
	s RtnObj.ClinicGroupCode=DHCRBASObj.ASClinicGroupDR.CLGRPCode
	s RtnObj.ClinicGroupName=DHCRBASObj.ASClinicGroupDR.CLGRPDesc
	s RtnObj.AdmitAddress=..GetAdmitAddress(RBASObj.%Id())             //DHCRBASObj.ASRESParRef.RESCTLOCDR.CTLOCFloor //就诊地点

	s RtnObj.StartTime=RBASObj.ASSessStartTime
	s:RtnObj.StartTime'="" RtnObj.StartTime=$ZT(RtnObj.StartTime) 
	s RtnObj.EndTime=RBASObj.ASSessEndTime
	s:RtnObj.EndTime'="" RtnObj.EndTime=$ZT(RtnObj.EndTime)
	s RtnObj.AdmitTimeRange="" //候诊时间
	s RtnObj.Note=RBASObj.ASRemarks.GetAt(RBASObj.ASRemarks.Count())
	q RtnObj
}

/// w ##class(DHCExternalService.RegInterface.SynVisitSchedule).GetAppQty("81||4")
/// 得到预约数量
ClassMethod GetAppQty(RBASID)
{
	n (RBASID)
	set AppQty=##class(web.DHCRBApptScheduleAppQty).GetAPPMethodQty(RBASID,"AMP")
	quit AppQty
}

/// w ##class(DHCExternalService.RegInterface.SynVisitSchedule).GetAdmitAddress("2||232")
/// 排班维护了诊室的取诊室位置地址，没有维护诊室的取科室位置地址 
ClassMethod GetAdmitAddress(RBASID As %String) As %String
{
	n (RBASID)
	s Valid = ##class(websys.Conversions).IsValidMethodName("web.DHCOPAdmReg","GetScheduleAddressInfo")
	if (Valid){
		Q ##Class(web.DHCOPAdmReg).GetScheduleAddressInfo(RBASID)
	}else{
		s AdmitAddress=""
		if $piece(RBASID,"||",2)=""{
			Q AdmitAddress
		}
		s RoomDr=$piece($get(^RBAS(+RBASID,$piece(RBASID,"||",2),"DHC")),"^",5)
		if RoomDr'=""{
			s AddDr=$o(^CTLOC(RoomDr,"ADDR",""),-1)
			if (AddDr'="") s AdmitAddress=$get(^CTLOC(RoomDr,"ADDR",AddDr))
		}
		if AdmitAddress=""{ 
			s LocDr=$piece($get(^RB("RES",+RBASID)),"^",1)
			s AddDr=$o(^CTLOC(LocDr,"ADDR",""),-1)
			if (AddDr'=""){
				s AdmitAddress=$get(^CTLOC(LocDr,"ADDR",AddDr))
			}
		}
		Q AdmitAddress
	}
}

}
