/// 类名：web.DHCENS.STBLL.OPERATION.Method.OperationSchedule
/// 描述：用于获取手麻系统所需的手术预约信息
/// 编写者：WuXianPu
/// 编写日期：2012-07-14
Class web.DHCENS.STBLL.OPERATION.Method.OperationSchedule Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：WuXianPu
/// CreatDate：2012—07-14
/// Description：手术申请预约信息
/// Table：
/// Input：<Request><ScheduleDateStart>2012-04-01</ScheduleDateStart><ScheduleDateStop>2012-05-01</ScheduleDateStop><PerformedCode>手麻科护理单元</PerformedCode><OperStatus>N</OperStatus></Request>
/// Return：手术预约信息集合
/// Others:w ##class(web.DHCENS.STBLL.OPERATION.Method.OperationSchedule).OperationSchedule("<Request><ScheduleDateStart>2012-04-01</ScheduleDateStart><ScheduleDateStop>2012-05-01</ScheduleDateStop><PerformedCode>手麻科护理单元</PerformedCode><OperStatus>N</OperStatus></Request>")
ClassMethod OperationSchedule(Input As %String) As web.DHCENS.STBLL.OPERATION.Model.OperationScheduleListRp
{
	s $ZTrap = "SendMessageET"
	s startDate="",endDate="",operCtlocCode="",opaCollectedStatus=""
	s reader=##class(%XML.Reader).%New()
	s sc=reader.OpenString(Input)
	d reader.Correlate("Request","web.DHCENS.STBLL.OPERATION.Model.OperationScheduleListRt")
	s DeptDictInfo=##class(web.DHCENS.STBLL.OPERATION.Model.OperationScheduleListRt).%New()
	While reader.Next(.obj,.sc) {
		s startDate=obj.ScheduleDateStart
		s endDate=obj.ScheduleDateStop
		s operCtlocCode=obj.PerformedCode
		s opaCollectedStatus=obj.OperStatus
	} 	
	s MainObj=..GetOperationSchedule(startDate,endDate,operCtlocCode,opaCollectedStatus)
	Quit MainObj
SendMessageET
	s MainObj=##class(web.DHCENS.STBLL.OPERATION.Model.OperationScheduleListRp).%New()
	s MainObj.ResultCode="-1"
	s MainObj.ResultContent=$ze
    Quit MainObj
}

ClassMethod GetOperationSchedule(startDate As %String, endDate As %String, operCtlocCode As %String = "", opaCollectedStatus As %String = "") As web.DHCENS.STBLL.OPERATION.Model.OperationScheduleListRp
{
	s:startDate'="" startDate=$ZDH(startDate,5)
	s:endDate'="" endDate=$ZDH(endDate,5)
	s MainObj=##class(web.DHCENS.STBLL.OPERATION.Model.OperationScheduleListRp).%New()
    f date=startDate:1:endDate
    {  
    	s opRowId="" 
        f  s opRowId=$O(^DHCANOPArrange(0,"SDate",date,opRowId)) q:opRowId=""  d 
	    .s TmpOPArrangeStr=$G(^DHCANOPArrange(opRowId))
	    .s oprRoomDr=$P(TmpOPArrangeStr,"^",20)
	    .i oprRoomDr'="" d
	    ..s oprDeptDr=$P($G(^DHCANC("OPRoom",oprRoomDr)),"^",3)
	    ..i oprDeptDr'=""   s oprDeptCode=$P($G(^CTLOC(oprDeptDr)),"^")
        ..e  s oprDeptCode=""
        .e  d
        ..s oprDeptCode=""
        .q:(oprDeptCode'=operCtlocCode)&(operCtlocCode'="")        
        .s collectedStatus=$P(TmpOPArrangeStr,"^",18)
        .q:(opaCollectedStatus'[collectedStatus)&(opaCollectedStatus'="")
        .s Obj=##class(web.DHCENS.STBLL.OPERATION.Model.OperationSchedule).%New()
        .s Obj=..GetAnOpApp(opRowId)
        .d MainObj.Operations.Insert(Obj)        
	}
	s Count=MainObj.Operations.Count()
	i Count>0
	{
		s MainObj.ResultCode="0"
		s MainObj.ResultContent="成功"
	}
	else
	{
		s MainObj.ResultCode="-1"
		s MainObj.ResultContent="失败"		
	}
	Quit MainObj
}

// w ##class(web.DHCENS.STBLL.OPERATION.Method.OperationSchedule).GetAnOpApp("4")

ClassMethod GetAnOpApp(OpRowId As %String) As web.DHCENS.STBLL.OPERATION.Model.OperationSchedule
{
	s RetStr="",OprDeptCode="",OpaStartDateTime=""
	s Ret=0
	s MyObj=##class(web.DHCENS.STBLL.OPERATION.Model.OperationSchedule).%New()
    s AdmInfoId=$P($G(^DHCANOPArrange(OpRowId)),"^",1)
    
    s AdmObj=##class(web.DHCENS.Model.AdmInfo).%New()
    s AdmObj=##class(web.DHCENS.Method.AdmInfo).AdmInfo(AdmInfoId)
    s PatObj=##class(web.DHCENS.Model.PatInfo).%New()
    s PatObj=##class(web.DHCENS.Method.PatInfo).PatInfo(AdmObj.PatRowID)
 	
	s MyObj.PatientID =PatObj.RegisterNo
	s MyObj.PatientName=PatObj.PatientName
	s MyObj.SexCode=PatObj.SexCode
	s MyObj.SexDesc=PatObj.SexDesc
	s MyObj.CredentialType=PatObj.CredentialType
	s MyObj.CredentialNo=PatObj.CredentialNo
	s MyObj.AdmNo =$G(AdmInfoId)
    s MyObj.ScheduleID=$G(OpRowId)   
    s MyObj.DeptStayCode=AdmObj.AdmDeptCode
    s MyObj.DeptStayDesc=AdmObj.AdmDeptDesc    
	s MyObj.BedNO =AdmObj.CurrentBedNo
	s MyObj.Age=PatObj.Age
	s MyObj.DocumentID=PatObj.DocumentID
	s MyObj.WardStayCode=AdmObj.CurrentWardCode
	s MyObj.WardStayDesc=AdmObj.CurrentWardDesc
	s MyObj.FeeTypeCode=AdmObj.FeeTypeCode
	s MyObj.FeeTypeDesc=AdmObj.FeeTypeDesc
	s MyObj.AdmTypeCode=AdmObj.AdmTypeCode
	s MyObj.AdmTypeDesc=AdmObj.AdmTypeDesc
	
    s OpaStartDate=$P($G(^DHCANOPArrange(OpRowId)),"^",14)
    s OpaStartTime=$P($G(^DHCANOPArrange(OpRowId)),"^",15)
    s:(OpaStartDate'="")&&(OpaStartTime'="") OpaStartDateTime=$ZD(OpaStartDate,3)_" "_$ZT(OpaStartTime)
    s MyObj.ScheduledDateTime=OpaStartDateTime 
       
    s OprDr=$P($G(^DHCANOPArrange(OpRowId)),"^",20)
    s OprDesc="",OprDeptDr=""
    i OprDr'="" d
    .s OprCode=$P($G(^DHCANC("OPRoom",OprDr)),"^",1)
    .s OprDesc=$P($G(^DHCANC("OPRoom",OprDr)),"^",2)
    .s OprDeptDr=$P($G(^DHCANC("OPRoom",OprDr)),"^",3)
    .s MyObj.OperatingRoomNo=OprDesc  
     
    i OprDeptDr'=""  d
    .s OprDeptCode=$P($G(^CTLOC(OprDeptDr)),"^")
    .s MyObj.OperatingRoom=$G(OprDeptCode)   
    
     
    s MyObj.Sequence=$P($G(^DHCANOPArrange(OpRowId)),"^",26)        
    s AnaId=$P($G(^DHCANOPArrange(OpRowId)),"^",2)
	s AdmId=$P(AnaId,"||",1)
	s AnaSub=$P(AnaId,"||",2)	
	
    s AnmedthodDr=$P($G(^OR(AdmId,"ANA",AnaSub)),"^",5)
    s AnaDr=$P($G(^OR(AdmId,"ANA",AnaSub)),"^",6)    
    s OpaEmergencyFlage=$P($G(^OR(AdmId,"ANA",AnaSub)),"^",32)
    
    //ANA_SourceType 急诊(E)/择期(B)
    s MyObj.EmergencyIndicator=$G(OpaEmergencyFlage)
    s MyObj.EmergencyIndicatorCode=$case(OpaEmergencyFlage,"B":"择期","E":"急诊","N":"加班")
    
    // 病情说明
    s MyObj.PatientCondition=""    
    
	s AnaOpSub=0,OperDiagCode="",OperDiagDesc="",OplevelDesc=""
	s AnaOpSub=$O(^OR(AdmId,"ANA",AnaSub,"OP",AnaOpSub))
	s OpasDr1="",OpasDr2="",OpasDr3="",OpasDr4="",OperDiagDr="",OpSurgeonDr=""
	s AnassDr1="",AnassDr2="",AnassDr3="",AnassDr4="",AnassDr5="",AnassDr6="",AnassDr7=""
	s OpscnDr1="",OpscnDr2="",OperDr=""
	s OpcirnDr1="",OpcirnDr2="",OpcirnDr3=""
	s AnaNotes=""
	s OperPositionId=""	
    
	i AnaOpSub'="" d
	.s OperDiagDr=$P($G(^OR(AdmId,"ANA",AnaSub,"OP",AnaOpSub)),"^",4)
    .s OpSurgeonDr=$P($G(^OR(AdmId,"ANA",AnaSub,"OP",AnaOpSub)),"^",8)
    .s OpasDr1=$P($G(^OR(AdmId,"ANA",AnaSub,"OP",AnaOpSub,"ASS",1)),"^",1)
    .s OpasDr2=$P($G(^OR(AdmId,"ANA",AnaSub,"OP",AnaOpSub,"ASS",2)),"^",1)	
    .s OpasDr3=$P($G(^OR(AdmId,"ANA",AnaSub,"OP",AnaOpSub,"ASS",3)),"^",1)
    .s OpasDr4=$P($G(^OR(AdmId,"ANA",AnaSub,"OP",AnaOpSub,"ASS",4)),"^",1)
    
    .s AnassDr1=$P($G(^OR(AdmId,"ANA",AnaSub,"OP",AnaOpSub,"ANASS",1)),"^")
	.s AnassDr2=$P($G(^OR(AdmId,"ANA",AnaSub,"OP",AnaOpSub,"ANASS",2)),"^")
    .s AnassDr3=$P($G(^OR(AdmId,"ANA",AnaSub,"OP",AnaOpSub,"ANASS",21)),"^")
    .s AnassDr4=$P($G(^OR(AdmId,"ANA",AnaSub,"OP",AnaOpSub,"ANASS",22)),"^")
    .s AnassDr5=$P($G(^OR(AdmId,"ANA",AnaSub,"OP",AnaOpSub,"ANASS",23)),"^")
    .s AnassDr6=$P($G(^OR(AdmId,"ANA",AnaSub,"OP",AnaOpSub,"ANASS",24)),"^")
    .s AnassDr7=$P($G(^OR(AdmId,"ANA",AnaSub,"OP",AnaOpSub,"ANASS",25)),"^")
    .s OpscnDr1=$P($G(^OR(AdmId,"ANA",AnaSub,"OP",AnaOpSub,"SCN",1)),"^")
    .s OpscnDr2=$P($G(^OR(AdmId,"ANA",AnaSub,"OP",AnaOpSub,"SCN",21)),"^")
	.s OpcirnDr1=$P($G(^OR(AdmId,"ANA",AnaSub,"OP",AnaOpSub,"CIRN",1)),"^")
    .s OpcirnDr2=$P($G(^OR(AdmId,"ANA",AnaSub,"OP",AnaOpSub,"CIRN",21)),"^")
    .s OpcirnDr3=$P($G(^OR(AdmId,"ANA",AnaSub,"OP",AnaOpSub,"CIRN",3)),"^")
    .s AnaNotes=$G(^OR(AdmId,"ANA",AnaSub,"TXT"))
	.s OperPositionId=$P($G(^OR(AdmId,"ANA",AnaSub,"OP",AnaOpSub,"POS",1)),"^")
	.s OperDr=$P($G(^OR(AdmId,"ANA",AnaSub,"OP",AnaOpSub)),"^",6)


	i OperDiagDr'="" d
	.s OperDiagDesc=$P($G(^MRC("ID",OperDiagDr)),"^",2)	
	.s OperDiagCode=$P($G(^MRC("ID",OperDiagDr)),"^",1)	
    .s MyObj.DiagBeforeOperationCode=$G(OperDiagCode)
    .s MyObj.DiagBeforeOperationDesc=$G(OperDiagDesc)
     
	s OperDesc="",oplevelDesc="",OperCode=""
	i OperDr'=""  d
	.s OperCode=$P($G(^ORC("OPER",OperDr)),"^",1)
	.s OperDesc=$P($G(^ORC("OPER",OperDr)),"^",2)
	.s OperationScale=$P($G(^ORC("OPER",OperDr)),"^",7)
	.s MyObj.OperationNO=$G(OperCode)
    .s MyObj.Operation=$G(OperDesc)
    .s:OperationScale'="" MyObj.OperationScaleDesc=$p($G(^ORC("CATEG",OperationScale)),"^",2)
    .s:OperationScale'="" MyObj.OperationScaleCode=$p($G(^ORC("CATEG",OperationScale)),"^",1)
    e  d
    .// 手写手术名称
    .s MyObj.Operation=$g(^OR(AdmId,"ANA",AnaSub,"OP",AnaOpSub,"REM",2))
    
    i $P($G(^DHCANOPArrange(OpRowId)),"^",10)="" d
    .s MyObj.IsolationIndicator=1
    e  d
    .s MyObj.IsolationIndicator=$P($G(^DHCANOPArrange(OpRowId)),"^",10)
    
    s PatDeptDr=$P($G(^DHCANOPArrange(OpRowId)),"^",21)
    i PatDeptDr'="" d
    .s PatDeptCode=$P($G(^CTLOC(PatDeptDr)),"^",1)
    .s PatDeptDesc=$P($G(^CTLOC(PatDeptDr)),"^",2)
    .s MyObj.OperatingDeptCode=$G(PatDeptCode)
    .s MyObj.OperatingDeptDesc=$G(PatDeptDesc)
    
	i OpSurgeonDr'="" d
	.s OpSurgeonCode=$P($G(^CTPCP(OpSurgeonDr,1)),"^",1)
	.s OpSurgeonDesc=$P($G(^CTPCP(OpSurgeonDr,1)),"^",2)
	.s MyObj.SurgeonCode=$G(OpSurgeonCode)
	.s MyObj.SurgeonDesc=$G(OpSurgeonDesc)
	
	s OpasId1="",OpasId2="",OpasId3="",OpasId4="",AnmedthodDesc=""
	s OpasDesc1="",OpasDesc2="",OpasDesc3="",OpasDesc4=""
	
	i OpasDr1'=""  d
	.s OpasId1=$P($G(^CTPCP(OpasDr1,1)),"^",1)
	.s OpasDesc1=$P($G(^CTPCP(OpasDr1,1)),"^",2)
	i OpasDr2'=""  d
	.s OpasId2=$P($G(^CTPCP(OpasDr2,1)),"^",1)
	.s OpasDesc2=$P($G(^CTPCP(OpasDr2,1)),"^",2)
	i OpasDr3'=""  d
	.s OpasId3=$P($G(^CTPCP(OpasDr3,1)),"^",1)
	.s OpasDesc3=$P($G(^CTPCP(OpasDr3,1)),"^",2)
	i OpasDr4'=""  d
	.s OpasId4=$P($G(^CTPCP(OpasDr4,1)),"^",1)
	.s OpasDesc4=$P($G(^CTPCP(OpasDr4,1)),"^",2)
    s MyObj.FirstAssistantCode=$G(OpasId1)   
    s MyObj.SecondAssistantCode=$G(OpasId2)  
    s MyObj.ThirdAssistantCode=$G(OpasId3)
    s MyObj.FourthAssistantCode=$G(OpasId4)
    s MyObj.FirstAssistantDesc=$G(OpasDesc1)   
    s MyObj.SecondAssistantDesc=$G(OpasDesc2)  
    s MyObj.ThirdAssistantDesc=$G(OpasDesc3)
    s MyObj.FourthAssistantDesc=$G(OpasDesc4)
    
    i AnmedthodDr'="" d
   	.s Length=$l(AnmedthodDr,"|")
   	.for k=1:1:Length-1 d
   	..if (AnmedthodDesc'="") d
    ...s AnmedthodDesc=AnmedthodDesc_"^"_$P($G(^ORC("ANMET",$p(AnmedthodDr,"|",k))),"^",2)
    ...s AnmedthodCode=AnmedthodCode_"^"_$P($G(^ORC("ANMET",$p(AnmedthodDr,"|",k))),"^",1)
    ..e  d
    ...s AnmedthodDesc=$P($G(^ORC("ANMET",$p(AnmedthodDr,"|",k))),"^",2)
    ...s AnmedthodCode=$P($G(^ORC("ANMET",$p(AnmedthodDr,"|",k))),"^",1)
    i $l(AnmedthodDesc,"-")>1 d
    .s AnmedthodDesc=$p(AnmedthodDesc,"-",2)
    .s MyObj.AnesthesiaMethodCode=$G(AnmedthodCode)
    .s MyObj.AnesthesiaMethodDesc=$G(AnmedthodDesc)
    
	i AnaDr'=""  d
	.s AnaId=$P($G(^CTPCP(AnaDr,1)),"^",1)
	.s AnaDesc=$P($G(^CTPCP(AnaDr,1)),"^",2)
	.s MyObj.AnesthesiaDoctorCode=$G(AnaId)
	.s MyObj.AnesthesiaDoctorDesc=$G(AnaDesc)
	
	s AnassId1="",AnassId2="",AnassId3="",AnassId4="",AnassId5="",AnassId6="",AnassId7=""
	s AnassDesc1="",AnassDesc2="",AnassDesc3="",AnassDesc4="",AnassDesc5="",AnassDesc6="",AnassDesc7=""
	i AnassDr1'=""  d
	.s AnassId1=$P($G(^CTPCP(AnassDr1,1)),"^",1)
	.s AnassDesc1=$P($G(^CTPCP(AnassDr1,1)),"^",2)
	i AnassDr2'=""  d
	.s AnassId2=$P($G(^CTPCP(AnassDr2,1)),"^",1)
	.s AnassDesc2=$P($G(^CTPCP(AnassDr2,1)),"^",2)
	i AnassDr3'=""  d
	.s AnassId3=$P($G(^CTPCP(AnassDr3,1)),"^",1)
	.s AnassDesc3=$P($G(^CTPCP(AnassDr3,1)),"^",2)
	
	i AnassDr4'=""  d
	.s AnassId4=$P($G(^CTPCP(AnassDr4,1)),"^",1)
	.s AnassDesc4=$P($G(^CTPCP(AnassDr4,1)),"^",2)
	i AnassDr5'=""  d
	.s AnassId5=$P($G(^CTPCP(AnassDr5,1)),"^",1)
	.s AnassDesc5=$P($G(^CTPCP(AnassDr5,1)),"^",2)
	i AnassDr6'=""  d
	.s AnassId6=$P($G(^CTPCP(AnassDr6,1)),"^",1)
	.s AnassDesc6=$P($G(^CTPCP(AnassDr6,1)),"^",2)
	i AnassDr7'=""  d
	.s AnassId7=$P($G(^CTPCP(AnassDr7,1)),"^",1)
	.s AnassDesc7=$P($G(^CTPCP(AnassDr7,1)),"^",2)
    s MyObj.SecondAnesthesiaDoctorCode=$G(AnassDr1)
    s MyObj.SecondAnesthesiaDoctorDesc=$G(AnassDesc1)
    s MyObj.ThirdAnesthesiaDoctorCode=$G(AnassDr2)
    s MyObj.ThirdAnesthesiaDoctorDesc=$G(AnassDesc2)
    s MyObj.AnesthesiaAssistantCode=$G(AnassId3)         //$G(anassDesc3)
    s MyObj.AnesthesiaAssistantDesc=$G(AnassDesc3)         
    s MyObj.SecondAnesthesiaAssistantCode=$G(AnassId4)   //$G(anassDesc4)
    s MyObj.SecondAnesthesiaAssistantDesc=$G(AnassDesc4)   //$G(anassDesc4)
    s MyObj.ThirdAnesthesiaAssistantCode=$G(AnassId5)    //$G(anassDesc5)
    s MyObj.ThirdAnesthesiaAssistantDesc=$G(AnassDesc5)    //$G(anassDesc5)
    s MyObj.FourthAnesthesiaAssistantCode=$G(AnassId6)   //$G(anassDesc6)
    s MyObj.FourthAnesthesiaAssistantDesc=$G(AnassDesc6)   //$G(anassDesc6)
    s MyObj.BloodTranDoctorCode=$G(AnassId7)             //$G(anassDesc7)
    s MyObj.BloodTranDoctorDesc=$G(AnassDesc7)             //$G(anassDesc7)

	
	s OpscnId1="",OpscnId2=""
	s OpscnDesc1="",OpscnDesc2=""
	i OpscnDr1'=""  d
	.s OpscnId1=$P($G(^CTPCP(OpscnDr1,1)),"^",1)
	.s OpscnDesc1=$P($G(^CTPCP(OpscnDr1,1)),"^",2)
	i OpscnDr2'=""  d
	.s OpscnId2=$P($G(^CTPCP(OpscnDr2,1)),"^",1)
	.s OpscnDesc2=$P($G(^CTPCP(OpscnDr2,1)),"^",2)
    s MyObj.FirstOperationNurseCode=$G(OpscnId1)  //$G(opscnDesc1)
    s MyObj.FirstOperationNurseDesc=$G(OpscnDesc1)  //$G(opscnDesc1)
    s MyObj.SecondOperationNurseCode=$G(OpscnId2) //$G(opscnDesc2)
    s MyObj.SecondOperationNurseDesc=$G(OpscnDesc2) //$G(opscnDesc2)
	
	s OpcirnId1="",OpcirnId2="",OpcirnId3=""
	s OpcirnDesc1="",OpcirnDesc2="",OpcirnDesc3=""
	i OpcirnDr1'=""  d
	.s OpcirnId1=$P($G(^CTPCP(OpcirnDr1,1)),"^",1)
	.s OpcirnDesc1=$P($G(^CTPCP(OpcirnDr1,1)),"^",2)
	i OpcirnDr2'=""  d
	.s OpcirnId2=$P($G(^CTPCP(OpcirnDr2,1)),"^",1)
	.s OpcirnDesc2=$P($G(^CTPCP(OpcirnDr2,1)),"^",2)
	i OpcirnDr3'="" d
	.s OpcirnId3=$P($G(^CTPCP(OpcirnDr3,1)),"^",1)
	.s OpcirnDesc3=$P($G(^CTPCP(OpcirnDr3,1)),"^",2)
    s MyObj.FirstSupplyNurseCode=$G(OpcirnId1)  //$G(opcirnDesc1)
    s MyObj.SecondSupplyNurseCode=$G(OpcirnId2) //$G(opcirnDesc2)
    s MyObj.ThirdSupplyNurseCode=$G(OpcirnId3)  //$G(opcirnDesc3)
    s MyObj.FirstSupplyNurseDesc=$G(OpcirnDesc1)  //$G(opcirnDesc1)
    s MyObj.SecondSupplyNurseDesc=$G(OpcirnDesc2) //$G(opcirnDesc2)
    s MyObj.ThirdSupplyNurseDesc=$G(OpcirnDesc3)  //$G(opcirnDesc3)
    
    s MyObj.NotesOnOperation=$G(AnaNotes)
    
    s OpaAppDate=$P($G(^DHCANOPArrange(OpRowId)),"^",3)
    i OpaAppDate'="" s OpaAppDate=$ZD(OpaAppDate,3)
    s OpaAppTime=$P($G(^DHCANOPArrange(OpRowId)),"^",5)
    i OpaAppTime'="" s OpaAppTime=$ZT(OpaAppTime)
    s MyObj.ReqDateTime=$G(OpaAppDate)_" "_$G(OpaAppTime)
    s EnteredBy=$P($G(^DHCANOPArrange(OpRowId)),"^",6)
    if EnteredBy'="" d
    .s MyObj.EnteredByCode=$P($G(^CTPCP(EnteredBy,1)),"^",1)
    .s MyObj.EnteredByDesc=$P($G(^CTPCP(EnteredBy,1)),"^",2)
    s ArrangeDate=$P($G(^DHCANOPArrange(OpRowId)),"^",7) 
    s ArrangeTime=$P($G(^DHCANOPArrange(OpRowId)),"^",8) 
    if ((ArrangeDate'="")&&(ArrangeTime'=""))
    s MyObj.EnteredByDateTime=$zd(ArrangeDate,3)_" "_$zt(ArrangeTime,3)
    
    s MyObj.OperStatus=$P($G(^DHCANOPArrange(OpRowId)),"^",27)
	
	s OperPositionDesc=""
	i OperPositionId'="" d
	.s OperPositionDesc=$P($G(^ORC("OPPOS",OperPositionId)),"^",2)
	s MyObj.OperationPosition=$g(OperPositionDesc)
	Quit MyObj
}

/// w ##class(web.DHCENS.STBLL.OPERATION.Method.OperationSchedule).OperationAppInfoPortal("1")
ClassMethod OperationAppInfoPortal(AppRowId As %String) As %String
{
	
	set $zt="Exception"
	set operationStream=##class(web.DHCANAdaptor).GetANOperation("","","","","","",AppRowId)
	s reader=##class(%XML.Reader).%New()
	s sc=reader.OpenStream(operationStream)
	d reader.Correlate("PatInfo","web.DHCANInterface")
	set portalObj=##class(web.DHCENS.STBLL.OPERATION.Model.OperationPortalObject).%New()
	set OpName="",OpDate="",OpTime="",ANAOPSurgeonCode="",AssistantFirstCtcpCode=""
	set AssistantSecondCtcpCode="",AssistantThirdCtcpCode="",OPAStatus="",status=1
	While reader.Next(.obj,.sc) {
		set OpName=obj.OpName 
		set portalObj.OpName=OpName
		set portalObj.OpRoom=obj.OPAOpRoom 
		set portalObj.OrdNo=obj.OPASeq 
		set ANAOPSurgeonCode=obj.ANAOPSurgeonCode
		//set portalObj.Surgeon=obj.ANAOPSurgeon
		set portalObj.Surgeon=obj.ANAOPSurgeon
		set Ass=obj.AssistantFirstCtcp
		set AssistantFirstCtcpCode=obj.AssistantFirstCtcpCode
		set AssistantSecondCtcpCode=obj.AssistantSecondCtcpCode
		set AssistantThirdCtcpCode=obj.AssistantThirdCtcpCode
		set:obj.AssistantSecondCtcp'="" Ass=Ass_" "_obj.AssistantSecondCtcp
		set:obj.AssistantThirdCtcp'="" Ass=Ass_" "_obj.AssistantThirdCtcp
		set:obj.AssOtherCtcpStr'="" Ass=Ass_" "_obj.AssOtherCtcpStr
		set portalObj.Ass=Ass
		set portalObj.Dept=obj.PatLoc 
		set portalObj.PreDiag=obj.ANAOPPreopDiag
		set portalObj.MedcareNo=obj.MedCareNo 
		set portalObj.PatName=obj.PatName 
		set OpDate=$p(obj.OPAStartDateTime," ",1)
		set portalObj.OpDate=OpDate
		set OpTime=$p(obj.OPAStartDateTime," ",2) 
		set portalObj.OpTime=OpTime
		set portalObj.OperLoc=obj.Ward 
		
		//手术安排的状态
		set OPAStatus = obj.OPAStatus
	}
	set jsonobj=##class(ext.util.JsonObject).%New()
	set jsonobj.ContainNullValue=1
	set string=jsonobj.FromObject(portalObj).Json()
	set ssUserCode=ANAOPSurgeonCode
	
	//手术安排的状态
	if (OPAStatus '=""){
		if (OPAStatus = "拒绝" ){
			set status=3
		}
	}
	
	set:AssistantFirstCtcpCode'="" ssUserCode=ssUserCode_";"_AssistantFirstCtcpCode
	set:AssistantSecondCtcpCode'="" ssUserCode=ssUserCode_";"_AssistantSecondCtcpCode
	set:AssistantThirdCtcpCode'="" ssUserCode=ssUserCode_";"_AssistantThirdCtcpCode
	set operationStr=ssUserCode_"^"_OpName_"^"_"1"_"^"_OpDate_"^^"_string_"^"_"Operation"
	set operationStr=operationStr_"^"_"0"_"^"_AppRowId_"^"_status
	Quit operationStr	
Exception
	set portalObj=##class(web.DHCENS.STBLL.OPERATION.Model.OperationPortalObject).%New()
	d portalObj.XMLExportToString(.string)
	Quit string
}

}
