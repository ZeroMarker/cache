/// 重症信息
Class DHCCL.Implement.ICU.ICUArrangeService Extends (%RegisteredObject, DHCCL.Interface.ICU.IICUInfoService)
{

/// 获取重症监护信息	
Method GetICUArrangeInfo(EpisodeID As %String) As %GlobalCharacterStream
{
	set retStream=##class(%GlobalCharacterStream).%New()
    do retStream.Rewind()
    
    do retStream.Write("<Response>")

	set rset=##class(%ResultSet).%New("DHCCL.Implement.ICU.ICUArrangeService:FindICUAInfo")
	do rset.Execute(EpisodeID)
	while (rset.Next()) 
	{
		set icuaInfoObj=##class(DHCCL.DTO.ICU.ICUAInfo).%New()
		set icuaInfoObj.IcuaId=rset.Get("icuaId")
		set icuaInfoObj.EpisodeID=rset.Get("admId")
		set icuaInfoObj.PatientID=rset.Get("papmiId")
		set icuaInfoObj.PatName=rset.Get("patName")
		set icuaInfoObj.RegNo=rset.Get("regNo")
		set icuaInfoObj.PatGender=rset.Get("sex")
		set icuaInfoObj.PatBirth=rset.Get("birth")
		set icuaInfoObj.PatAge=rset.Get("age")
		set icuaInfoObj.MedcareNo=rset.Get("medcareNo")
		set icuaInfoObj.CurDeptId=rset.Get("curLocId")
		set icuaInfoObj.CurDeptDesc=rset.Get("curLocDesc")
		set icuaInfoObj.CurWardId=rset.Get("curWardId")
		set icuaInfoObj.CurWardDesc=rset.Get("curWardDesc")
		set icuaInfoObj.CurBedId=rset.Get("bedId")
		set icuaInfoObj.CurBedCode=rset.Get("bedCode")
		set icuaInfoObj.PAAdmReasonDesc=rset.Get("PAAdmReasonDesc")
		set icuaInfoObj.AdmDate=rset.Get("AdmDate")
		set icuaInfoObj.AdmStayDay=rset.Get("admStayDay")
		set icuaInfoObj.DiagnoseDesc=rset.Get("mrDiagnoseDesc")
		set icuaInfoObj.InWardDT=rset.Get("inWardDT")
		set icuaInfoObj.ICUAStartDT=rset.Get("ICUAStartDT")
		set icuaInfoObj.ICUALeaveDT=rset.Get("ICUALeaveDT")
		set icuaInfoObj.ICUALeaveConditionCode=rset.Get("ICUALeaveConditionCode")
		set icuaInfoObj.ICUALeaveConditionDesc=rset.Get("ICUALeaveConditionDesc")
		set icuaInfoObj.ICUADeptId=rset.Get("ICUAAdmLocId")
		set icuaInfoObj.ICUADeptDesc=rset.Get("ICUAAdmLocDesc")
		set icuaInfoObj.ICUAWardId=rset.Get("icuWardId")
		set icuaInfoObj.ICUAWardDesc=rset.Get("icuWardDesc")
		set icuaInfoObj.ICUABedCode=rset.Get("icuBedCode")
		set icuaInfoObj.ICUAPatHeight=rset.Get("ICUAPatHeight")
		set icuaInfoObj.ICUAPatWeight=rset.Get("ICUAPatWeight")
		set icuaInfoObj.ICUAChargeNurseDr=rset.Get("ICUAChargeNurseDr")
		set icuaInfoObj.ICUAChargeNurseDesc=rset.Get("ICUAChargeNurseDesc")
		set icuaInfoObj.ICUASupervisorNurseDr=rset.Get("ICUASupervisorNurseDr")
		set icuaInfoObj.ICUASupervisorNurseDesc=rset.Get("ICUASupervisorNurseDesc")
		set icuaInfoObj.ICUAResidentCtcpDr=rset.Get("ICUAResidentCtcpDr")
		set icuaInfoObj.ICUAResidentCtcpDesc=rset.Get("ICUAResidentCtcpDesc")
		set icuaInfoObj.ICUAAttendingCtcpDr=rset.Get("ICUAAttendingCtcpDr")
		set icuaInfoObj.ICUAAttendingCtcpDesc=rset.Get("ICUAAttendingCtcpDesc")
		set icuaInfoObj.InWardDays=rset.Get("inWardDays")
		
		set xml=##class(%GlobalCharacterStream).%New()
		set ret=icuaInfoObj.XMLExportToStream(.xml,"ICUAInfo")
		do retStream.CopyFrom(xml)
	}
	
	do retStream.Write("</Response>")
	quit retStream
}

/// 目的:是为了实现院感业务（呼吸机 VAE 监测）与重症系统对接，完成患者呼吸机 PEEP、FiO2 数据回传到院感系统
Method GetVAEInfoByEpisodeID(EpisodeID As %String, DateFrom As %String, DateTo As %String) As %GlobalCharacterStream
{
	set retStream=##class(%GlobalCharacterStream).%New()
    do retStream.Rewind()
    
    do retStream.Write("<Response>")

	s icuaId="" f  s icuaId=$o(^DHCICUArrange(0,"Adm",EpisodeID,icuaId)) q:icuaId=""  d
	.q:'$d(^DHCICUArrange(icuaId))
	.do OutputVAEInfo(icuaId)
	
	do retStream.Write("</Response>")
	quit retStream
	
OutputVAEInfo(icuaId)
	set rset=##class(%ResultSet).%New("DHCCL.Implement.ICU.ICUArrangeService:FindICUOrderByRecordItem")
	do rset.Execute(icuaId,"PEEP^FiO2^FiO2-Set^PEEPS",DateFrom,"",DateTo,"","Y")  ;;Temper^NSBP   PEEP^FiO2
	while (rset.Next()) 
	{
		set vaeInfo=##class(DHCCL.DTO.ICU.VAE).%New()
		set vaeInfo.ICUOrderID=rset.Get("icuoId")
		set vaeInfo.ResultType=rset.Get("icucriCode")
		set vaeInfo.ResultDate=rset.Get("icuoStartDate")
		set vaeInfo.ResultTime=rset.Get("icuoStartTime")
		set vaeInfo.Result=rset.Get("icuoValue")
		set vaeInfo.RegUser=rset.Get("icuoUserDesc")
		set vaeInfo.RstIsActive=rset.Get("isActive")
		
		set xml=##class(%GlobalCharacterStream).%New()
		set ret=vaeInfo.XMLExportToStream(.xml,"VAE")
		do retStream.CopyFrom(xml)
	}
}

/// 获取重症质控指标信息
Method GetICUQualityControlStat(startDate As %String, endDate As %String, locIdStr As %String, userId As %String, version As %String = "") As %GlobalCharacterStream
{
	set retStream=##class(%GlobalCharacterStream).%New()
    do retStream.Rewind()
    
    do retStream.Write("<Response>")
	set rset=##class(%ResultSet).%New("web.DHCICUQualityControlStatistic:FindICUQualityControlStat")
	do rset.Execute(startDate,endDate,locIdStr,userId,version)
	while (rset.Next()) 
	{
		set icuQualityControlObj=##class(DHCCL.DTO.ICU.ICUQualityControl).%New()
		set query=##class(%ResultSet).%New("CIS.AN.COM.DataService:FindProperties")
        set sc=query.Execute("DHCCL.DTO.ICU.ICUQualityControl")
        while(query.%Next())
        {
            set propertyName=query.Get("Name")
	        set $property(icuQualityControlObj,propertyName)=rset.Get(propertyName)
        }
		
		set xml=##class(%GlobalCharacterStream).%New()
		set ret=icuQualityControlObj.XMLExportToStream(.xml,"ICUQualityControl")
		do retStream.CopyFrom(xml)
	}
	do retStream.Write("</Response>")
	quit retStream
}

/// 获取重症病人质控指标详细信息
Method GetICUQualityControlDetail(icuaId As %String = "", EpisodeID As %String = "", DischargeDate As %String = "") As %GlobalCharacterStream
{
	/*
	set retStream=##class(%GlobalCharacterStream).%New()
    do retStream.Rewind()
    
    do retStream.Write("<Response>")
	set rset=##class(%ResultSet).%New("DHCCL.Implement.ICU.ICUQualityControlService:FindICUQualityControlDetail")
	do rset.Execute(icuaId,EpisodeID,DischargeDate)
	while (rset.Next()) 
	{
		set icuQualityControlDetailObj=##class(DHCCL.DTO.ICU.ICUQualityControlDetail).%New()
		set query=##class(%ResultSet).%New("CIS.AN.COM.DataService:FindProperties")
        set sc=query.Execute("DHCCL.DTO.ICU.ICUQualityControlDetail")
        while(query.%Next())
        {
            set propertyName=query.Get("Name")
	        set $property(icuQualityControlDetailObj,propertyName)=rset.Get(propertyName)
        }
		
		set xml=##class(%GlobalCharacterStream).%New()
		set ret=icuQualityControlDetailObj.XMLExportToStream(.xml,"ICUQualityControlDetail")
		do retStream.CopyFrom(xml)
	}
	do retStream.Write("</Response>")
	quit retStream
	*/
	
	set jsonStr=##class(CIS.AN.COM.String).QueryToJSON("DHCCL.Implement.ICU.ICUQualityControlService","FindICUQualityControlDetail",icuaId,EpisodeID,DischargeDate)
	set tag="data"
	set ret="{"""_tag_""":"_jsonStr_"}"
	
	set retStream=##class(%GlobalCharacterStream).%New()
    do retStream.Rewind()
    do retStream.Write(ret)
	quit retStream
}

/// d ##class(%ResultSet).RunQuery("DHCCL.Implement.ICU.ICUArrangeService","FindICUAInfo",530)
Query FindICUAInfo(EpisodeID As %String) As %Query(ROWSPEC = "icuaId,admId,papmiId,patName,regNo,sex,birth,age,medcareNo,curLocId,curLocDesc,curWardId,curWardDesc,bedId,bedCode,PAAdmReasonDesc,AdmDate,admStayDay,mrDiagnoseDesc,inWardDT,ICUAStartDT,ICUALeaveDT,ICUALeaveConditionCode,ICUALeaveConditionDesc,ICUAAdmLocId,ICUAAdmLocDesc,icuWardId,icuWardDesc,icuBedCode,ICUAPatHeight,ICUAPatWeight,ICUAChargeNurseDr,ICUAChargeNurseDesc,ICUASupervisorNurseDr,ICUASupervisorNurseDesc,ICUAResidentCtcpDr,ICUAResidentCtcpDesc,ICUAAttendingCtcpDr,ICUAAttendingCtcpDesc,inWardDays") [ SqlProc ]
{
}

ClassMethod FindICUAInfoExecute(ByRef qHandle As %Binary, EpisodeID As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	i (EpisodeID="") 
	{
		Set qHandle=$lb(0,repid,0) 
		Quit $$$OK
	}
	
	s icuaId="" f  s icuaId=$o(^DHCICUArrange(0,"Adm",EpisodeID,icuaId)) q:icuaId=""  d
	.q:'$d(^DHCICUArrange(icuaId))
	.do OutputSingle(icuaId)
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputSingle(icuaId)
	s admId=$p(^DHCICUArrange(icuaId),"^",1)
	s papmiId=$p($g(^PAADM(admId)),"^",1)
	s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	s sex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
	s birth=$p($g(^PAPER(papmiId,"ALL")),"^",6)
	s age=##class(web.DHCClinicCom).CalAge(birth,+$h)
	s medcareNo=##class(web.DHCWMRService).IGetMrNoByEpisodeID(admId , .ErrMsg)
	s curLocId=$p($g(^PAADM(admId)),"^",4)
	s curLocDesc=$P(^CTLOC(curLocId),"^",2)
	s curWardId=$p($g(^PAADM(admId)),"^",70)
	s curWardDesc=$P($G(^PAWARD(curWardId)),"^",2)
	s bedId=$p($g(^PAADM(admId)),"^",73)
	s bedSub=$p(bedId,"||",2)
	s bedCode="" 
	i bedSub'="" s bedCode=$p($g(^PAWARD(curWardId,"BED",bedSub)),"^",1)
	s AdmReason=$P($g(^PAADM(admId,1)),"^",7)
	s PAAdmReasonDesc="" ;;就诊原因
	i AdmReason'="" s PAAdmReasonDesc=$P($g(^PAC("ADMREA",AdmReason)),"^",2)
	s AdmDateH=$P(^PAADM(admId),"^",6) ;;入院日期
	s AdmDate=""
	i AdmDateH'="" s AdmDate=$zd(AdmDateH,3)
	s admStayDay="" ;;在院天数
	i AdmDate'="" s admStayDay=($P($h,"^",1)-AdmDateH+10)_"天"
	s mrAdmId=$p($g(^PAADM(EpisodeID)),"^",61)
	s mrDiagnoseDesc=##class(web.DHCClinicCom).GetMRDiagnosDesc(mrAdmId," ")
	s inWardDT=##class(web.DHCICUCom).GetWardInDateTime("",icuaId,"",""," ") ;;入病区日期时间

	//重症开始监护日期时间
	s ICUAStartDate=$p($g(^DHCICUArrange(icuaId)),"^",6)
	s ICUAStartTime=$p($g(^DHCICUArrange(icuaId)),"^",8)
	i ICUAStartDate'="" s ICUAStartDate=$zd(ICUAStartDate,3)
	i ICUAStartTime'="" s ICUAStartTime=$zt(ICUAStartTime)
	s ICUAStartDT=""
	i (ICUAStartDate'="")&&(ICUAStartTime'="") set ICUAStartDT=ICUAStartDate_" "_ICUAStartTime
	
	//重症结束监护日期时间
	s ICUALeaveDate=$p($g(^DHCICUArrange(+icuaId)),"^",44)
	s ICUALeaveTime=$p($g(^DHCICUArrange(+icuaId)),"^",45)
	i ICUALeaveDate'="" s ICUALeaveDate=$zd(ICUALeaveDate,3)
	i ICUALeaveTime'="" s ICUALeaveTime=$zt(ICUALeaveTime)
	s ICUALeaveDT=""
	i (ICUALeaveDate'="")&&(ICUALeaveTime'="") set ICUALeaveDT=ICUALeaveDate_" "_ICUALeaveTime
	
	//转归状态
	s ICUALeaveConditionCode=$p($g(^DHCICUArrange(+icuaId)),"^",43)
	s ICUALeaveConditionDesc=""
	i ICUALeaveConditionCode="D" s ICUALeaveConditionDesc="死亡"
	i ICUALeaveConditionCode="T" s ICUALeaveConditionDesc="转科"
	i ICUALeaveConditionCode="A" s ICUALeaveConditionDesc="自动出院"
	i ICUALeaveConditionCode="M" s ICUALeaveConditionDesc="治愈出院"
	i ICUALeaveConditionCode="O" s ICUALeaveConditionDesc="外出治疗"
	
	//重症监护科室
	s ICUAAdmLocId=+$p($g(^DHCICUArrange(+icuaId)),"^",2)
	set ICUAAdmLocDesc=""
	if ICUAAdmLocId'="" s ICUAAdmLocDesc=$p(^CTLOC(ICUAAdmLocId),"^",2)
	
	//重症监护病区床位
	s icuBedId=$p($g(^DHCICUArrange(+icuaId)),"^",4)
	s icuWardId="", icuWardDesc="",icuBedCode=""
	i icuBedId'="" d
	.s icuWardId=$p(icuBedId,"||",1)
	.s icuWardDesc=$P($g(^PAWARD(icuWardId)),"^",2)
	.s icuBedSub=$p(icuBedId,"||",2)
	.s icuBedCode=$p($g(^PAWARD(+icuWardId,"BED",+icuBedSub)),"^",1)
	
	set ICUAPatHeight=$p(^DHCICUArrange(icuaId),"^",24)  //病人入ICU身高
	set ICUAPatWeight=$p(^DHCICUArrange(icuaId),"^",25)  //病人入ICU体重
	
	//重症监护护士医生
	s ICUAChargeNurseDr=$p($g(^DHCICUArrange(+icuaId)),"^",60)  //责任护士
	s ICUAChargeNurseDesc=$p(##class(web.DHCClinicCom).GetUserTypeName(ICUAChargeNurseDr),"^",2)
	s ICUASupervisorNurseDr=$p($g(^DHCICUArrange(+icuaId)),"^",61)  //主管护士
	s ICUASupervisorNurseDesc=$p(##class(web.DHCClinicCom).GetUserTypeName(ICUASupervisorNurseDr),"^",2)
	s ICUAResidentCtcpDr=$p($g(^DHCICUArrange(+icuaId)),"^",28)  //主治医师
	s ICUAResidentCtcpDesc=$p(##class(web.DHCClinicCom).GetUserTypeName(ICUAResidentCtcpDr),"^",2)
	s ICUAAttendingCtcpDr=$p($g(^DHCICUArrange(+icuaId)),"^",29)  //住院医师
	s ICUAAttendingCtcpDesc=$p(##class(web.DHCClinicCom).GetUserTypeName(ICUAAttendingCtcpDr),"^",2)
	
	//重症监护天数
	s inDate=##class(web.DHCICUCom).GetWardInDateTime(admId,icuaId,"","","^","D")
	i inDate="" s inDate=$p($g(^DHCICUArrange(icuaId)),"^",6)
	s wardOutDateTime=##class(web.DHCICUCom).GetWardOutDateTime("",icuaId,"","","^","D")
	s outDate=$p(wardOutDateTime,"^",1)
	i outDate="" s outDate=+$h
	s inWardDays=outDate-inDate
	do OutputRow
	
	quit
	
OutputRow
	set Data=$lb(icuaId,admId,papmiId,patName,regNo,sex,birth,age,medcareNo,curLocId,curLocDesc,curWardId,curWardDesc,bedId,bedCode,PAAdmReasonDesc,AdmDate,admStayDay,mrDiagnoseDesc,inWardDT,ICUAStartDT,ICUALeaveDT,ICUALeaveConditionCode,ICUALeaveConditionDesc,ICUAAdmLocId,ICUAAdmLocDesc,icuWardId,icuWardDesc,icuBedCode,ICUAPatHeight,ICUAPatWeight,ICUAChargeNurseDr,ICUAChargeNurseDesc,ICUASupervisorNurseDr,ICUASupervisorNurseDesc,ICUAResidentCtcpDr,ICUAResidentCtcpDesc,ICUAAttendingCtcpDr,ICUAAttendingCtcpDesc,inWardDays)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindICUAInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindICUAInfoExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {	
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindICUAInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindICUAInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("DHCCL.Implement.ICU.ICUArrangeService","FindICUOrderByRecordItem",3,"Temper^NSBP","2017-8-1","","2017-8-10","","Y")
Query FindICUOrderByRecordItem(icuaId As %String, recordItemCodeStr As %String, stDate As %String, stTime As %String, endDate As %String, endTime As %String, ifAll As %String = "N") As %Query(ROWSPEC = "icuoId,icucriId,icucriCode,icucriDesc,icuoEditFlag,icuoStartDate,icuoStartTime,icuoValue,icuoUserId,icuoUserDesc,isActive")
{
}

ClassMethod FindICUOrderByRecordItemExecute(ByRef qHandle As %Binary, icuaId As %String, recordItemCodeStr As %String, stDate As %String, stTime As %String, endDate As %String, endTime As %String, ifAll As %String = "N") As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	
	if ((icuaId="")||(recordItemCodeStr=""))
	{
		s qHandle=$lb(0,repid,0)
		q $$$OK
	}

	s fromDate=##class(web.DHCClinicCom).ConvertToDateH(stDate)
	s fromTime=##class(web.DHCClinicCom).ConvertToTimeH(stTime)
	s toDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
	s toTime=##class(web.DHCClinicCom).ConvertToTimeH(endTime)
	
	for i=1:1:$l(recordItemCodeStr,"^")
	{
		set recordItemCode=$p(recordItemCodeStr,"^",i)
		s icucriId=##class(web.DHCICUCom).GetIcuriIdByCode(recordItemCode)
		continue:icucriId=""
		s icucriCode=$p($g(^DHCICUC("RecordItem",+icucriId)),"^",1)
		s icucriDesc=$p($g(^DHCICUC("RecordItem",+icucriId)),"^",2)
		
		for date=fromDate:1:toDate
		{
			s time="" f  s time=$o(^DHCICUOrder(0,"RecordItem",icucriId,date,icuaId,time)) q:(time="")  d
			.q:(date=fromDate)&(time<fromTime)
			.q:(date=toDate)&(time>toTime)			
			.s icuoId="" f  s icuoId=$o(^DHCICUOrder(0,"RecordItem",icucriId,date,icuaId,time,icuoId)) q:(icuoId="")  d
			..q:'$d(^DHCICUOrder(icuoId))
			..s icuoEditFlag=$p(^DHCICUOrder(icuoId),"^",25)
			..s isActive="Y"
			..if ("ICD"[icuoEditFlag) s isActive="N"
			..q:(isActive="N")&&(ifAll="N")
			..s icuoStartDate=$p(^DHCICUOrder(icuoId),"^",5)
			..if icuoStartDate'="" set icuoStartDate=$zd(icuoStartDate,3)
			..s icuoStartTime=$p(^DHCICUOrder(icuoId),"^",6)
			..if icuoStartTime'="" set icuoStartTime=$zt(icuoStartTime)
			..s icuoValue=##class(web.DHCICUOrder).GetRecordValueSingle(icuoId)
			..s icuoUserId=$p(^DHCICUOrder(icuoId),"^",4)
			..s icuoUserDesc=""
			..i icuoUserId'="" s icuoUserDesc=$p($g(^SSU("SSUSR",icuoUserId)),"^",2)
			..do OutputRow
		}
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRow
	set Data=$lb(icuoId,icucriId,icucriCode,icucriDesc,icuoEditFlag,icuoStartDate,icuoStartTime,icuoValue,icuoUserId,icuoUserDesc,isActive)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindICUOrderByRecordItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindICUOrderByRecordItemExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {	
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindICUOrderByRecordItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindICUOrderByRecordItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
