Import SQLUser

Class web.DHCBPSendShortMessage Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 获取病人安排列表(透析记录为依据)
/// startDate透析查询开始日期，endDate透析查询结束日期，daySeqNo班次(早、中、晚)
/// d ##class(%ResultSet).RunQuery("web.DHCBPSendShortMessage","FindBedGroupArrangeList","2020-08-26","2020-08-26","")
Query FindBedGroupArrangeList(startDate, endDate, daySeqNo As %String = "", locId As %String = "") As %Query(ROWSPEC = "Id,RegNo,RegisterId,PatientName,Age,Gender,BedGroupDesc,BedDesc,DayPartCode,DayPart,ModeId,ModeDesc,ArrangeDate,Status,ReceptionTime") [ SqlProc ]
{
}

ClassMethod FindBedGroupArrangeListExecute(ByRef qHandle As %Binary, startDate, endDate, daySeqNo As %String = "", locId As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1	
	s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	s endDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
	s locIdList=##Class(web.DHCBPCom).GetLinkLocByLocId(locId) //科室关联	
	f curDate=startDate:1:endDate d
		.s bpaId=""
		.f  s bpaId=$o(^DHCBPArrange(0,"Date",curDate,bpaId)) q:bpaId=""  d
			..q:$$GetArrange(bpaId)<0
			..i bpaReceiveTime="" s bpaReceiveTime="23:59"
			..s bpaReceiveTime=$zth(bpaReceiveTime)
			..i bpaBedGroupDr="" s bpaBedGroupDr="1000"			
			..s ^TMPBP("SendShortMessag",$j,bpaBedGroupDr,bpaReceiveTime,bpaId)=""
	d Output
	K ^TMPBP("SendShortMessag",$j) //排序的临时global	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
GetArrange(bpaId)	
	q:bpaId="" -1
	s bpprId=$lg(^DHCBPArrange(bpaId),1)
	s bpprPatLocDr=$lg(^DHCBPPatRegister(bpprId),34)	
    q:((locId'="")&&(bpprPatLocDr'="")&&($p($g(^CTLOC(locId)),"^",22)'=$p($g(^CTLOC(bpprPatLocDr)),"^",22))) -1.1 //病人所在医院判断
    q:(bpprPatLocDr'="")&&(locIdList'="")&&(("^"_locIdList_"^")'[("^"_bpprPatLocDr_"^")) -1.2
	s papmiId=$lg(^DHCBPPatRegister(bpprId),1)
	q:papmiId="" -2
	s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	s patientName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	s patBirth=$p($g(^PAPER(papmiId,"ALL")),"^",6)	//出生日期
	s Age=##class(web.DHCClinicCom).CalAge(patBirth,+$h)
	s Gender=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
	s bpprStatus=$lg(^DHCBPPatRegister(bpprId),14)	
	s bpprEndDate=$lg(^DHCBPPatRegister(bpprId),13)
	s bpaDate=$lg(^DHCBPArrange(bpaId),4)
	q:(bpprStatus="D")&&(bpprEndDate<bpaDate) -2.5 //转归后
	s arrDate=bpaDate
	s bpaDate=##class(web.DHCClinicCom).ConvertToDate(bpaDate)	
	s bpaStatus=$lg(^DHCBPArrange(bpaId),9)
	q:(bpaStatus="D")||(bpaStatus="A") -3
	i bpaStatus="A" s bpaStatus="申请"	
	i bpaStatus="R" s bpaStatus="安排"
	i bpaStatus="M" s bpaStatus="治疗"
	i bpaStatus="F" s bpaStatus="完成"
	s bpaDaySeqNo=$lg(^DHCBPArrange(bpaId),6)
	q:bpaDaySeqNo="" -4
	q:(daySeqNo'="")&&(daySeqNo'=bpaDaySeqNo) -4
	i bpaDaySeqNo="A" s bpaDaySeqNoDesc="上午"	
	i bpaDaySeqNo="P" s bpaDaySeqNoDesc="下午"
	i bpaDaySeqNo="E" s bpaDaySeqNoDesc="晚上"
	s bpaBPCBedDr=$lg(^DHCBPArrange(bpaId),7)
	s bpaBPCBedDesc=$lg($g(^DHCBPC("Bed",+bpaBPCBedDr)),2) //床位
	s bpaBedGroupDr=$lg($g(^DHCBPC("Bed",+bpaBPCBedDr)),3) 	
	s bpaBedGroupDesc=""
	i (bpaBPCBedDr'=""&&bpaBPCBedDr'="0") d
		.s bpaBedGroupDr=$lg($g(^DHCBPC("Bed",+bpaBPCBedDr)),3) 	
		.s bpaBedGroupDesc=$lg($g(^DHCBPC("BedGroup",+bpaBedGroupDr)),2) //床位组
	e  d
		.s bppId=##class(web.DHCBPPatSetUpBedGroup).GetPatSetUpBedGroupID(bpprId,bpaDaySeqNo) //病人绑定床位组记录ID
		.i bppId'="" d
			..s bpaBedGroupDr=$lg($g(^DHCBPPatSetUpBedGroup(bppId)),1) //绑定床位组
			..s bpaBedGroupDesc=$lg($g(^DHCBPC("BedGroup",+bpaBedGroupDr)),2)
	s bpaBPCBPModeDr=$lg(^DHCBPArrange(bpaId),26)
	s bpaBPCBPModeDesc=$lg($g(^DHCBPC("BloodPurificationMode",+bpaBPCBPModeDr)),2)	
	s bpaReceiveTime="" //获取当次透析设置接诊时间(临时)
	s arrExtValue=##class(web.DHCBPArrangeExtend).GetArrangeExtendValue(bpaId,"SignInReceiveTime")
	i arrExtValue'="" s bpaReceiveTime= $p(arrExtValue,$c(3),1)
	i bpaReceiveTime="" s bpaReceiveTime=##class(web.DHCBPPatSetUpBedGroup).GetCalReceptionTime(bpprId,arrDate,bpaDaySeqNo) //绑定的接诊时间
	//w bpaId,!	
	q 0
Output
    // 床位组排序
	s tmpBedGroup=""
	f  s tmpBedGroup=$o(^TMPBP("SendShortMessag",$j,tmpBedGroup)) q:tmpBedGroup=""  d
		.s tmpReceiveTime=""
		.f  s tmpReceiveTime=$o(^TMPBP("SendShortMessag",$j,tmpBedGroup,tmpReceiveTime)) q:tmpReceiveTime=""  d
			..s bpaId=""
			..f  s bpaId=$o(^TMPBP("SendShortMessag",$j,tmpBedGroup,tmpReceiveTime,bpaId)) q:bpaId=""  d	
				...q:$$GetArrange(bpaId)<0				
				...d OutputRow
	q
OutputRow
	set Data=$lb(bpaId,regNo,bpprId,patientName,Age,Gender,bpaBedGroupDesc,bpaBPCBedDesc,bpaDaySeqNo,bpaDaySeqNoDesc,bpaBPCBPModeDr,bpaBPCBPModeDesc,bpaDate,bpaStatus,bpaReceiveTime)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindBedGroupArrangeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBedGroupArrangeListExecute ]
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

ClassMethod FindBedGroupArrangeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBedGroupArrangeListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 给病人发生短信息
/// w ##class(web.DHCBPSendShortMessage).InsertSendShortMessage("114912^N^196")
ClassMethod InsertSendShortMessage(SendShortMessagStr) As %String
{
	s result="",count=0
	q:SendShortMessagStr="" "无保存数据"
	s bpArrangeIdStr=$P(SendShortMessagStr,"^",1) //透析记录ID
	s Status=$P(SendShortMessagStr,"^",2) //预约、取消预约
	f i=1:1:$l(bpArrangeIdStr,"#")  d
		.s bpaId=+$p(bpArrangeIdStr,"#",i)
		.s bpprId=$lg(^DHCBPArrange(bpaId),1)
		.s papmiId=$lg(^DHCBPPatRegister(bpprId),1)
		.s mobilePhone=$P($g(^PAPER(papmiId,"PER",1)),"^",11)
		.s PatientName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
		.s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
		.s bpaDate=$lg(^DHCBPArrange(bpaId),4)
		.s arrDate=bpaDate
		.s bpaWeekSeqNo=$zd(bpaDate,10)
		.s bpaDate=##class(web.DHCClinicCom).ConvertToDate(bpaDate)
		.s bpaDaySeqNo=$lg(^DHCBPArrange(bpaId),6)
		.i bpaDaySeqNo="A" s bpaDaySeqNoDesc="上午"	
		.i bpaDaySeqNo="P" s bpaDaySeqNoDesc="下午"
		.i bpaDaySeqNo="E" s bpaDaySeqNoDesc="晚上"
		.s bpaReceiveTime="" //获取当次透析设置接诊时间(临时)
		.s arrExtValue=##class(web.DHCBPArrangeExtend).GetArrangeExtendValue(bpaId,"SignInReceiveTime")
		.i arrExtValue'="" s bpaReceiveTime= $p(arrExtValue,$c(3),1)
		.i bpaReceiveTime="" s bpaReceiveTime=##class(web.DHCBPPatSetUpBedGroup).GetCalReceptionTime(bpprId,arrDate,bpaDaySeqNo) //绑定的接诊时间		
		.//【北京协和医院】温馨提示:尊敬的患者xxx(ID号Xxxx),您预约了2020年08月05日(星期三)上午07:10血液净化中心就诊。谢谢！[北京协和医院] 
    	.s note=""
    	.i Status="N" d
    		..s note="【医院】温馨提示:尊敬的患者"_PatientName_"(ID号"_regNo_"),您预约了"_bpaDate_"(星期"_bpaWeekSeqNo_")"_bpaDaySeqNoDesc_bpaReceiveTime_"血液净化中心就诊。谢谢！"
    	.e  i Status="C" d
    		..s note="【医院】温馨提示:尊敬的患者"_PatientName_"(ID号"_regNo_"),您取消预约了"_bpaDate_"(星期"_bpaWeekSeqNo_")"_bpaDaySeqNoDesc_bpaReceiveTime_"血液净化中心就诊。谢谢！"
    	.s messageObj=##class(User.DHCBPSendShortMessage).%New()
    	.s messageObj.BPSSMBPPatRegisterDr=##class(User.DHCBPPatRegister).%OpenId(bpprId)   
    	.s messageObj.BPSSMStatus=Status
    	.s messageObj.BPSSMCtcpDr=$P(SendShortMessagStr,"^",3)
    	.s messageObj.BPSSMDate=+$h
    	.s messageObj.BPSSMTime=$P($h,",",2)
    	.s messageObj.BPSSMPhone=mobilePhone
    	.s messageObj.BPSSMNote=note
    	.s messageObj.BPSSMDaySeqNo=bpaDaySeqNo
    	.s ss= messageObj.%Save()
    	.d messageObj.%Close()
    	.//w messageObj.%Id(),!
		.s ret=..SendShortMessage(mobilePhone,note)
		.s count=count+ret
	s result=count
    q result
}

/// w ##class(web.DHCBPSendShortMessage).SendShortMessage("13811100543","123")
ClassMethod SendShortMessage(MobilePhone As %String, MessageInfo As %String) As %String
{
	s sum=0
	s obj=##class(User.EnsInterface).%New()
	s obj.IntEventDesc="SendSMSMessageInfo"
	s obj.IntEventName="发送短信信息"
	s obj.IntInput=MobilePhone
	s obj.IntInputDesc="电话号码"
	s obj.IntInsDate=$p($h,",",1)
	s obj.IntInsTime=$p($h,",",2)
	s obj.IntKeyString=MessageInfo
	s sc=obj.%Save()
	i $$$ISOK(sc) d
		.s ret="0^成功"
		.s sum=sum+1
	d obj.%Close()
	q sum
}

/// 获取病人关联床位组列表
/// bedGroupId床位组ID，curStatus绑定状态:N正常，D删除
/// d ##class(%ResultSet).RunQuery("web.DHCBPSendShortMessage","FindShortMessageList","2020-08-26","92","","A")
Query FindShortMessageList(startDate As %String, registerId As %String = "", curStatus As %String = "", daySeqNo As %String = "", locId As %String = "") As %Query(ROWSPEC = "Id,RegisterId,RegNo,PatientName,Age,Gender,CtcpId,CtcpDesc,Date,Time,Status,MobilePhone,Note") [ SqlProc ]
{
}

ClassMethod FindShortMessageListExecute(ByRef qHandle As %Binary, startDate As %String, registerId As %String = "", curStatus As %String = "", daySeqNo As %String = "", locId As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	i (startDate="")&&(registerId="") Set qHandle=$lb(0,repid,0) Quit $$$OK
	s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	s locIdList=##Class(web.DHCBPCom).GetLinkLocByLocId(locId) //科室关联
	s bpSSMId=""
	if (registerId'="")
	{
		f  s bpSSMId=$o(^DHCBPSendShortMessage(0,"PatRegister",registerId,bpSSMId)) q:bpSSMId=""  d
			.q:$$GetShortMessage()<0
			.s sDate=$lg(^DHCBPSendShortMessage(bpSSMId),2)
			.q:(startDate'="")&&(startDate'=sDate)
			.d OutputRow
	}
	if (registerId="")&&(startDate'="")
	{
		f  s bpSSMId=$o(^DHCBPSendShortMessage(0,"Date",startDate,bpSSMId)) q:bpSSMId=""  d
			.q:$$GetShortMessage()<0
			.d OutputRow
	}	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
GetShortMessage()
	q:bpSSMId="" -1
	s Id=bpSSMId
	s RegisterId=$lg(^DHCBPSendShortMessage(bpSSMId),1)
	s bpprPatLocDr=$lg(^DHCBPPatRegister(RegisterId),34)	
    q:((locId'="")&&(bpprPatLocDr'="")&&($p($g(^CTLOC(locId)),"^",22)'=$p($g(^CTLOC(bpprPatLocDr)),"^",22))) -1.1 //病人所在医院判断
    q:(bpprPatLocDr'="")&&(locIdList'="")&&(("^"_locIdList_"^")'[("^"_bpprPatLocDr_"^")) -1.2
	s papmiId=$lg(^DHCBPPatRegister(RegisterId),1)
	q:papmiId="" -2
	s RegNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	s PatientName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	s patBirth=$p($g(^PAPER(papmiId,"ALL")),"^",6)	//出生日期
	s Age=##class(web.DHCClinicCom).CalAge(patBirth,+$h)
	s Gender=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
	s CtcpId=$lg(^DHCBPSendShortMessage(bpSSMId),5)
	s CtcpDesc=""
	i CtcpId'="" d
		.s CtcpDesc=##class(web.DHCBPCom).GetNameById(CtcpId)
	s Date=$lg(^DHCBPSendShortMessage(bpSSMId),2)
	i Date'="" d
		.s Date=##class(web.DHCClinicCom).ConvertToDate(Date)
	s Time=$lg(^DHCBPSendShortMessage(bpSSMId),3)
	i Time'="" d
		.s Time=##class(web.DHCClinicCom).ConvertToTime(Time)
	s Status=$lg(^DHCBPSendShortMessage(bpSSMId),4)		
	q:(curStatus'="")&&(curStatus'=Status) -3
	i Status="N" s Status="预约短信"
	i Status="C" s Status="取消预约短信"
	s MobilePhone=$lg(^DHCBPSendShortMessage(bpSSMId),6)
	s Note=$lg(^DHCBPSendShortMessage(bpSSMId),7)
	s DaySeqNo=$lg(^DHCBPSendShortMessage(bpSSMId),8)
	q:(daySeqNo'="")&&(daySeqNo'=DaySeqNo) -4
	q 0    
OutputRow
	set Data=$lb(Id,RegisterId,RegNo,PatientName,Age,Gender,CtcpId,CtcpDesc,Date,Time,Status,MobilePhone,Note)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindShortMessageListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindShortMessageListExecute ]
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

ClassMethod FindShortMessageListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindShortMessageListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Storage Default
{
<Data name="DHCBPSendShortMessageDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCBPSendShortMessageD</DataLocation>
<DefaultData>DHCBPSendShortMessageDefaultData</DefaultData>
<IdLocation>^web.DHCBPSendShortMessageD</IdLocation>
<IndexLocation>^web.DHCBPSendShortMessageI</IndexLocation>
<StreamLocation>^web.DHCBPSendShortMessageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
