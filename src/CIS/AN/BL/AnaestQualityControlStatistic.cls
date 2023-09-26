/// 麻醉质控指标统计
Class CIS.AN.BL.AnaestQualityControlStatistic Extends %RegisteredObject
{

/// Creator：      	李杰
/// CreatDate：    	2021年8月9日
/// Description： 	查询质控统计
/// Table：        	CIS.AN.OperSchedule
/// Input:			1.startDate:开始日期，2.endDate:结束日期, 3.anaDeptId:麻醉科室Id, 4.查询用户Id
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.AnaestQualityControlStatistic","FindAnaQualityControlStat","2019-09-01","2022-09-30","364","10209")
Query FindAnaQualityControlStat(startDate As %String, endDate As %String, anaDeptId As %String, userId As %String = "", Version As %String = "") As %Query(ROWSPEC = "SeqNo,OperQualityTitle,Count,CountCode,Total,TotalCode,Rate") [ SqlProc ]
{
}

ClassMethod FindAnaQualityControlStatExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, anaDeptId As %String, userId As %String = "", Version As %String = "") As %Status
{
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	

	set startDateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(startDate,"")
	set endDateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(endDate,"")
	if ((startDateH>endDateH) || (userId=""))
	{
		s qHandle=$lb(0,repid,0)
		q $$$OK	
	}


	kill ^tmpFindAnaQualityControlStat(userId)
	set indexNode="OPDate",operCount=0,pacuCount=0
	for date=startDateH:1:endDateH
	{
		set opsId=0
		for
		{
			set opsId=$order(^CIS.AN.OperScheduleI(indexNode,date,opsId))
			quit:(opsId="")
			set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
			set mainAnaId=##class(CIS.AN.BL.Anaesthesia).GetMainAnaId(opsId)
			continue:mainAnaId=""
			set anaDept=operSchedule.AnaDept
			continue:(anaDeptId'="")&&(anaDept'=anaDeptId)
			set operDept=operSchedule.OperDeptID
			set statusCode=operSchedule.Status.Code
			set operDate=operSchedule.OperDate
			set operTime=operSchedule.OperTime
			set EpisodeID=operSchedule.EpisodeID
			set operRoom=operSchedule.OperRoom
			//只统计出室、术毕、恢复室、停止手术
			continue:(statusCode'="RoomOut")&&(statusCode'="Finish")&&(statusCode'="PACUIn")&&(statusCode'="Stop")
			continue:operRoom=""
			
			set anaestObj=##class(CIS.AN.COM.Query).ToObject("CIS.AN.BL.Anaesthesia:FindAnaesthesia",opsId)
	        set AnaStartDT=anaestObj.GetValue("AnaStartDT")				
	        set TheatreOutTransLoc=anaestObj.GetValue("TheatreOutTransLoc") 
	        set PACUInDT=anaestObj.GetValue("PACUInDT")
			set PACUOutDT=anaestObj.GetValue("PACUOutDT")
			set TheatreInDT=anaestObj.GetValue("TheatreInDT")
			set TheatreOutDT=anaestObj.GetValue("TheatreOutDT")
			set AnaMethod=anaestObj.GetValue("AnaMethod")				
			set TheatreOutTransLoc=anaestObj.GetValue("TheatreOutTransLoc")
			set IsNonePlanInICU=anaestObj.GetValue("IsNonePlanInICU")
			
			//入恢复室
			if ((PACUInDT'="") && (PACUOutDT'=""))  
	        {
				set pacuCount=pacuCount+1
				set ^tmpFindAnaQualityControlStat(userId,"pacuCount",opsId)=""
		    }
		    
		    //各ASA分级麻醉患者比例
		    set asaClassId=anaestObj.GetValue("ASAClass")
			set asaClassDesc=anaestObj.GetValue("ASAClassDesc")
			if (asaClassDesc'="")&&(asaClassDesc'="None")
			{
				set asaClassCode=$$GetASACode(asaClassDesc)
				set ^tmpFindAnaQualityControlStat(userId,asaClassCode,opsId)=""
			}
			else
			{
				set asaClassCode="ASANone"
				set ^tmpFindAnaQualityControlStat(userId,asaClassCode,opsId)=""
			}
			
			//急诊非择期麻醉比例
			if operSchedule.SourceType="E"
			{
				set ^tmpFindAnaQualityControlStat(userId,"EmOperCount",opsId)=""
			}
			
			//各类麻醉方式比例
			for i=1:1:$length(AnaMethod, ",")
			{
				set AnaMethodId=$piece(AnaMethod,",",i)
				if (AnaMethodId'="")
				{
					set AnaMethodCode=$piece($g(^ORC("ANMET",AnaMethodId)),"^",1)
					set AnaMethodDesc=$piece($g(^ORC("ANMET",AnaMethodId)),"^",2)
					set AnaTypeId=$piece($g(^ORC("ANMET",AnaMethodId)),"^",3)
					if ((AnaMethodCode=22)) 
					{
						//椎管内麻醉
						set ^tmpFindAnaQualityControlStat(userId,"IntraspinalAnesthesiaCount",opsId)=""
					}
					elseif ((AnaMethodCode=44)||(AnaMethodCode=45))  
					{
						//插管全麻
						set ^tmpFindAnaQualityControlStat(userId,"IntubationAnesthesiaCount",opsId)=""
					}
					elseif ((AnaMethodCode=11)||(AnaMethodCode=12)||(AnaMethodCode=12))  
					{
						//非插管全麻
						set ^tmpFindAnaQualityControlStat(userId,"NonIntubationAnesthesiaCount",opsId)=""
					}
					elseif ((AnaMethodCode=41)||(AnaMethodCode=42)||(AnaMethodCode=43)||(AnaMethodCode=44)||(AnaMethodCode=45))  
					{
						//复合麻醉
						set ^tmpFindAnaQualityControlStat(userId,"CompoundAnesthesiaCount",opsId)=""
					}
					else  
					{
						//其他麻醉方式
						set ^tmpFindAnaQualityControlStat(userId,"OtherAnesthesiaCount",opsId)=""
					}
				}
			}
			
			set sc=##class(CIS.AN.BL.AnaestQualityControlStatistic).GetAnaQualityControl(opsId, .qualityControlArray)
			//麻醉开始后手术取消率
			if (qualityControlArray(opsId,"AnaStartAndOperCancel")="Y")
			{
				set ^tmpFindAnaQualityControlStat(userId,"AnaStartAndOperCancelCount",opsId)=""
			}
			//麻醉后监测治疗室(PACU)转出延迟率
			if (qualityControlArray(opsId,"PACUTransferOutDelay")="Y")
			{
				set ^tmpFindAnaQualityControlStat(userId,"PACUTransferOutDelayCount",opsId)=""
			}
			//PACU入室低体温率
			if (qualityControlArray(opsId,"PACUInRoomLowTemperature")="Y")
			{
				set ^tmpFindAnaQualityControlStat(userId,"PACUInRoomLowTemperatureCount",opsId)=""
			}
			
			// 非计划转入ICU率
			if (TheatreOutTransLoc="ICU")
			{
				set ^tmpFindAnaQualityControlStat(userId,"TransferToICUCount",opsId)="" //分母
				if (qualityControlArray(opsId,"NonePlanTransferToICU")="Y")  //分子
				{
					set ^tmpFindAnaQualityControlStat(userId,"NonePlanTransferToICUCount",opsId)=""
				}
			}
			
			// 非计划二次气管插管
			if (##class(CIS.AN.BL.AnesthetistWorkload).HasEvent(opsId,"拔管")="Y")
			{
				set ^tmpFindAnaQualityControlStat(userId,"TubeOutOperCount",opsId)=""  //分母
			}
			if (qualityControlArray(opsId,"NonePlanReTubeIn")="Y")
			{
				set ^tmpFindAnaQualityControlStat(userId,"NonePlanTubeInOperCount",opsId)="" //分子
			}
			
			//麻醉开始后24小时内死亡率
			if (qualityControlArray(opsId,"DeathAfterAnaest24Hour")="Y")
			{
				set ^tmpFindAnaQualityControlStat(userId,"DeathAfterAnaest24HourCount",opsId)=""
			}
			
			//麻醉开始后24小时内心跳骤停率
			if (qualityControlArray(opsId,"CardiacArrestAfterAnaest24Hour")="Y")
			{
				set ^tmpFindAnaQualityControlStat(userId,"CardiacArrestAfterAnaest24HourCount",opsId)=""
			}
			
			//术中自体血输注率
			if (##class(CIS.AN.BL.AnaestQualityControlStatistic).GetBloodTransVolume(opsId,"BloodTransfusion")>=400)
			{
				set ^tmpFindAnaQualityControlStat(userId,"BloodTransfutionCount",opsId)=""
			}
			if qualityControlArray(opsId,"SelfBloodTransfution")="Y"
			{
				set ^tmpFindAnaQualityControlStat(userId,"SelfBloodTransfutionCount",opsId)=""
			}
			
			//麻醉期间严重过敏反应发生率
			if qualityControlArray(opsId,"SevereAllergicReaction")="Y"
			{
				set ^tmpFindAnaQualityControlStat(userId,"SevereAllergicReactionCount",opsId)=""
			}
			
			//椎管内麻醉后严重神经并发症
			if (qualityControlArray(opsId,"ComplicatOfSpinalAnaest")="Y")
			{
				 set ^tmpFindAnaQualityControlStat(userId,"ComplicatOfSpinalAnaestCount",opsId)=""
			}
			
			//中心静脉穿刺严重并发症发生率
			if ((##class(CIS.AN.BL.AnesthetistWorkload).HasEvent(opsId,"中心静脉穿刺")="Y"))
			{
				set ^tmpFindAnaQualityControlStat(userId,"CentralVenipunctureCount",opsId)="" //分母
			}
			if (qualityControlArray(opsId,"SevereCentralVenipuncture")="Y")
			{
				set ^tmpFindAnaQualityControlStat(userId,"SevereCentralVenipunctureCount",opsId)="" //分子
			}
			
			//全麻气管插管拔管后声音嘶哑
			if (qualityControlArray(opsId,"IntubeOuttubeHoarseness")="Y")
			{
				set ^tmpFindAnaQualityControlStat(userId,"IntubeOuttubeHoarsenessCount",opsId)=""
			}
			
			//麻醉后新发昏迷发生率
			if (qualityControlArray(opsId,"PostAnaestComa")="Y")
			{
				set ^tmpFindAnaQualityControlStat(userId,"PostAnaestComaCount",opsId)=""
			}
			
			set operCount=operCount+1
			set ^tmpFindAnaQualityControlStat(userId, "operCount", opsId)=""
		}	
	}
	
	set SeqNo=0
	
	do OutputPercent("麻醉科医患比",$$CounterCareProv(anaDeptId), "", operCount/10000, "operCount")
	
	do OutputPercent("各ASA分级麻醉患者比例","", "", "", "")
	do OutputPercent("&emsp;&emsp; I级",$$CounterStat("ASAI"),"ASAI",operCount,"operCount")
	do OutputPercent("&emsp;&emsp; II级",$$CounterStat("ASAII"),"ASAII",operCount,"operCount")
	do OutputPercent("&emsp;&emsp; III级",$$CounterStat("ASAIII"),"ASAIII",operCount,"operCount")
	do OutputPercent("&emsp;&emsp; IV级",$$CounterStat("ASAIV"),"ASAIV",operCount,"operCount")
	do OutputPercent("&emsp;&emsp; V级",$$CounterStat("ASAV"),"ASAV",operCount,"operCount")
	do OutputPercent("&emsp;&emsp; 未定级",$$CounterStat("ASANone"),"ASANone",operCount,"operCount")
	
	do OutputPercent("急诊非择期麻醉比例",$$CounterStat("EmOperCount"),"EmOperCount",operCount,"operCount")
	
	do OutputPercent("各类麻醉方式比例","", "", "", "")
	do OutputPercent("&emsp;&emsp; 椎管内麻醉",$$CounterStat("IntraspinalAnesthesiaCount"),"IntraspinalAnesthesiaCount",operCount,"operCount")
	do OutputPercent("&emsp;&emsp; 插管全麻",$$CounterStat("IntubationAnesthesiaCount"),"IntubationAnesthesiaCount",operCount,"operCount")
	do OutputPercent("&emsp;&emsp; 非插管全麻",$$CounterStat("NonIntubationAnesthesiaCount"),"NonIntubationAnesthesiaCount",operCount,"operCount")
	do OutputPercent("&emsp;&emsp; 复合麻醉",$$CounterStat("CompoundAnesthesiaCount"),"CompoundAnesthesiaCount",operCount,"operCount")
	do OutputPercent("&emsp;&emsp; 其他麻醉方式",$$CounterStat("OtherAnesthesiaCount"),"OtherAnesthesiaCount",operCount,"operCount")
	
	do OutputThousandth("麻醉开始后手术取消率",$$CounterStat("AnaStartAndOperCancelCount"),"AnaStartAndOperCancelCount",operCount,"operCount")
	do OutputThousandth("麻醉后监测治疗室(PACU)转出延迟率",$$CounterStat("PACUTransferOutDelayCount"),"PACUTransferOutDelayCount",pacuCount,"pacuCount")
	do OutputPercent("PACU入室低体温率",$$CounterStat("PACUInRoomLowTemperatureCount"),"PACUInRoomLowTemperatureCount",pacuCount,"pacuCount")
	do OutputPercent("非计划转入ICU率",$$CounterStat("NonePlanTransferToICUCount"),"NonePlanTransferToICUCount",$$CounterStat("TransferToICUCount"),"TransferToICUCount")
	do OutputPercent("非计划二次气管插管率",$$CounterStat("NonePlanTubeInOperCount"),"NonePlanTubeInOperCount",$$CounterStat("TubeOutOperCount"),"TubeOutOperCount")
	do OutputPercent("麻醉开始后24小时内死亡率",$$CounterStat("DeathAfterAnaest24HourCount"),"DeathAfterAnaest24HourCount",operCount,"operCount")
	do OutputPercent("麻醉开始后24小时内心跳骤停率",$$CounterStat("CardiacArrestAfterAnaest24HourCount"),"CardiacArrestAfterAnaest24HourCount",operCount,"operCount")
	do OutputThousandth("术中自体血输注率",$$CounterStat("SelfBloodTransfutionCount"),"SelfBloodTransfutionCount",$$CounterStat("BloodTransfutionCount"),"BloodTransfutionCount")
	do OutputThousandth("麻醉期间严重过敏反应发生率",$$CounterStat("SevereAllergicReactionCount"),"SevereAllergicReactionCount",operCount,"operCount")
	do OutputThousandth("椎管内麻醉后严重神经并发症发生率",$$CounterStat("ComplicatOfSpinalAnaestCount"),"ComplicatOfSpinalAnaestCount",$$CounterStat("IntraspinalAnesthesiaCount"),"IntraspinalAnesthesiaCount")
	do OutputThousandth("中心静脉穿刺严重并发症发生率",$$CounterStat("SevereCentralVenipunctureCount"),"SevereCentralVenipunctureCount",$$CounterStat("CentralVenipunctureCount"),"CentralVenipunctureCount")
	do OutputThousandth("全麻气管插管拔管后声音嘶哑发生率",$$CounterStat("IntubeOuttubeHoarsenessCount"),"IntubeOuttubeHoarsenessCount",$$CounterStat("IntubationAnesthesiaCount"),"IntubationAnesthesiaCount")
	do OutputThousandth("麻醉后新发昏迷发生率",$$CounterStat("PostAnaestComaCount"),"PostAnaestComaCount",operCount,"operCount")
	
	s qHandle=$lb(0,repid,0)
	q $$$OK
	
CounterCareProv(deptId)
	set CareProvCount=0
	set rset=##class(%ResultSet).%New("CIS.AN.BL.Admission:FindCareProv")
	do rset.Execute("",deptId)
	while (rset.Next()) 
	{
		set Description=rset.Get("Description")
		continue:(Description="doctor")||(Description="indoctor")
		set CareProvCount=CareProvCount+1
	}
	quit CareProvCount

GetASACode(desc)
	set code = $s(desc["Ⅰ":"ASAI",desc["Ⅱ":"ASAII",desc["Ⅲ":"ASAIII",desc["Ⅳ":"ASAIV",desc["Ⅴ":"ASAV",1:"None")
	quit code  
	
GetModuleDataValueByCode(opsId,moduleId,dataItemCode)
	set RecordSheet="",value=""
	&sql(select RowId into :RecordSheet from CIS_AN.RecordSheet where OperSchedule=:opsId and DataModule=:moduleId)
	if RecordSheet'="" &sql(select DataValue into :value from CIS_AN.OperData where RecordSheet=:RecordSheet and DataItem=:dataItemCode)
	quit value

CounterStat(code)
	set counter=0
	if ($d(^tmpFindAnaQualityControlStat(userId, code)))
	{
		set id=""
		for
		{
			set id=$order(^tmpFindAnaQualityControlStat(userId, code, id))
			quit:(id="")
			set counter=counter+1
		}
	}
	quit counter

OutputPercent(Title,Count,CountCode,Total,TotalCode)
	set SeqNo=SeqNo+1
	set Rate="0.00%"
	if (+Total>0) set Rate=$fn(Count/Total*100, "", 2)_"%"
	if (Count="")&&(Total="") set Rate=""
	
	s ^CacheTemp(repid,ind)=$lb(SeqNo,Title,Count,CountCode,Total,TotalCode,Rate)
	s ind=ind+1
	q

OutputThousandth(Title,Count,CountCode,Total,TotalCode)
	set SeqNo=SeqNo+1
	set Rate="0.00‰"
	if (+Total>0) set Rate=$fn(Count/Total*1000, "", 2)_"‰"
	if (Count="")&&(Total="") set Rate=""
	
	s ^CacheTemp(repid,ind)=$lb(SeqNo,Title,Count,CountCode,Total,TotalCode,Rate)
	s ind=ind+1
	q
}

ClassMethod FindAnaQualityControlStatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAnaQualityControlStatExecute ]
{
	s AtEnd=$li(qHandle,1)
	s repid=$li(qHandle,2)
	s ind=$li(qHandle,3)
	//
	s ind=$o(^CacheTemp(repid,ind))
	i ind="" {				// if there are no more rows, finish fetching
	s AtEnd=1
	s Row=""
	}
	else      {				// fetch row
	s Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindAnaQualityControlStatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAnaQualityControlStatExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.AnaestQualityControlStatistic","FindOperStatDetail","17418","operCount")
Query FindOperStatDetail(userId As %String, statCode As %String) As %Query(ROWSPEC = "OpsId,StatusDesc,StatusColor,SourceType,SourceTypeDesc,OperDate,PatName,PatGender,PatAge,PatDeptDesc,PatBedCode,RegNo,MedcareNo,OperDesc,OperClass,SurgeonDesc,AnesthesiologistDesc,AnaExpertDesc,AnaAssistantDesc,AnNurse,AnaMethodDesc,ASAClassDesc,CircualNurseDesc,ScrubNurseDesc,PACUInDT,PACUOutDT,OperDeptDesc,AnaDeptDesc,OpsId,TheatreOutTransLocDesc") [ SqlProc ]
{
}

ClassMethod FindOperStatDetailExecute(ByRef qHandle As %Binary, userId As %String, statCode As %String) As %Status
{
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1

	if ((userId="") || (statCode=""))
	{
		s qHandle=$lb(0,repid,0)
		q $$$OK	
	}
	
	if ('$d(^tmpFindAnaQualityControlStat(userId, statCode)))
	{
		s qHandle=$lb(0,repid,0)
		q $$$OK	
	}
	
	set opsId=0
	for
	{
		set opsId=$order(^tmpFindAnaQualityControlStat(userId, statCode,opsId))
		quit:(opsId="")
		set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
		set PatDeptID=operSchedule.PatDeptID
		set EpisodeID=operSchedule.EpisodeID
		set SourceType=operSchedule.SourceType
		set ScrubNurse=operSchedule.ScrubNurse
		set Status=operSchedule.Status.%Id()				// 手术状态ID
		set StatusDesc=operSchedule.Status.Description		// 手术状态名称
		set StatusColor=operSchedule.Status.BGColor
		set SourceType=operSchedule.SourceType				// 手术类型
		set SourceTypeDesc=##class(CIS.AN.OperSchedule).SourceTypeLogicalToDisplay(operSchedule.SourceType)
		set ScrubNurseDesc=##class(CIS.AN.BL.OperationList).GetCareProvDesc(ScrubNurse)
		set CircualNurse=operSchedule.CircualNurse
		set CircualNurseDesc=##class(CIS.AN.BL.OperationList).GetCareProvDesc(CircualNurse)	
		set OperDuration=operSchedule.OperDuration
		set PatBedID=operSchedule.PatBedID	
		set PatBedCode=##class(CIS.AN.COM.String).GetDescByID("User.PACBed","BEDCode",operSchedule.PatBedID)
		set OperDate=##class(CIS.AN.COM.DateTime).ConvertToDateHis(operSchedule.OperDate,"")
		set patInfoObj=##class(CIS.AN.COM.Query).ToObject("CIS.AN.BL.Admission:FindPatient",EpisodeID)
		set PatName=patInfoObj.GetValue("PatName")
		set PatGender=patInfoObj.GetValue("PatGender")
		set PatAge=patInfoObj.GetValue("PatAge")
		set RegNo=patInfoObj.GetValue("RegNo")
		set MedcareNo=patInfoObj.GetValue("MedcareNo")	
		set PatDeptDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTLoc","CTLOCDesc",operSchedule.PatDeptID)
		set operData=##class(CIS.AN.BL.OperScheduleList).GetOperList(opsId,.operData)
		set OperDesc=operData(1,"OperationDesc")
		
		s OperClass="",CATEGDesc=""
		&sql(SELECT OperClass into:CATEGDr FROM sqluser.CIS_AN.OperList WHERE OperSchedule =:opsId )
		if ((CATEGDr'="")&&($d(^ORC("CATEG",CATEGDr)))) s CATEGDesc=$p(^ORC("CATEG",CATEGDr),"^",2)
		set OperClass=CATEGDesc ;OperListData.OperClass
		set SurgeonDesc=operData(1,"SurgeonDesc")
		set anaestObj=##class(CIS.AN.COM.Query).ToObject("CIS.AN.BL.Anaesthesia:FindAnaesthesia",opsId)
		set AnaMethod=anaestObj.GetValue("AnaMethod")
		set AnaMethodDesc=##class(CIS.AN.COM.String).GetDescByIDStr("User.ORCAnaestMethod","ANMETDesc",AnaMethod)
		set AnesthesiologistDesc=anaestObj.GetValue("AnesthesiologistDesc")
		set ASAClass=anaestObj.GetValue("ASAClass")
		set ASAClassDesc=anaestObj.GetValue("ASAClassDesc")
		set AnaExpertDesc=anaestObj.GetValue("AnaExpertDesc")
		set AnaAssistant=anaestObj.GetValue("AnaAssistant")
		set AnaAssistantDesc=##class(CIS.AN.BL.OperationList).GetCareProvDesc(AnaAssistant)
		set AnNurseId=anaestObj.GetValue("AnaNurse")
		set AnNurse=##class(CIS.AN.BL.OperationList).GetCareProvDesc(AnNurseId)
		set AnaMethod=anaestObj.GetValue("AnaMethod")
		set AnaMethodDesc=##class(CIS.AN.COM.String).GetDescByIDStr("User.ORCAnaestMethod","ANMETDesc",AnaMethod)	// 麻醉方法名称
		set PACUInDT=anaestObj.GetValue("PACUInDT")
		if (PACUInDT'=""){
			set PACUInDateH=##class(CIS.AN.COM.DateTime).ConvertToDateH($P(PACUInDT," ",1))
			set PACUInTimeH=##class(CIS.AN.COM.DateTime).ConvertToTimeH($P(PACUInDT," ",2))
			set PACUInDT=##class(CIS.AN.COM.DateTime).ConvertToDateHis(PACUInDateH)_" "_##class(CIS.AN.COM.DateTime).ConvertToTimeHis(PACUInTimeH)
		}
		set PACUOutDT=anaestObj.GetValue("PACUOutDT")
		if (PACUOutDT'=""){
			set PACUOutDateH=##class(CIS.AN.COM.DateTime).ConvertToDateH($P(PACUOutDT," ",1))
			set PACUOutTimeH=##class(CIS.AN.COM.DateTime).ConvertToTimeH($P(PACUOutDT," ",2))
			set PACUOutDT=##class(CIS.AN.COM.DateTime).ConvertToDateHis(PACUOutDateH)_" "_##class(CIS.AN.COM.DateTime).ConvertToTimeHis(PACUOutTimeH)
		}
		set OperDeptDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTLoc","CTLOCDesc",operSchedule.OperDeptID)
		set AnaDeptDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTLoc","CTLOCDesc",operSchedule.AnaDept)
		set TheatreOutTransLocDesc=anaestObj.GetValue("TheatreOutTransLocDesc")
		do OutputRow
	}	
	
	
	s qHandle=$lb(0,repid,0)
	q $$$OK
		
OutputRow
	s ^CacheTemp(repid,ind)=$lb(opsId,StatusDesc,StatusColor,SourceType,SourceTypeDesc,OperDate,PatName,PatGender,PatAge,PatDeptDesc,PatBedCode,RegNo,MedcareNo,OperDesc,OperClass,SurgeonDesc,AnesthesiologistDesc,AnaExpertDesc,AnaAssistantDesc,AnNurse,AnaMethodDesc,ASAClassDesc,CircualNurseDesc,ScrubNurseDesc,PACUInDT,PACUOutDT,OperDeptDesc,AnaDeptDesc,opsId,TheatreOutTransLocDesc)
	s ind=ind+1
	q
}

ClassMethod FindOperStatDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOperStatDetailExecute ]
{
	s AtEnd=$li(qHandle,1)
	s repid=$li(qHandle,2)
	s ind=$li(qHandle,3)
	//
	s ind=$o(^CacheTemp(repid,ind))
	i ind="" {				// if there are no more rows, finish fetching
	s AtEnd=1
	s Row=""
	}
	else      {				// fetch row
	s Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindOperStatDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOperStatDetailExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

/// w ##class(CIS.AN.BL.AnaestQualityControlStatistic).GetBloodTransVolume(62,"BloodTransfusion","红细胞悬液")
ClassMethod GetBloodTransVolume(opsId, categoryCode, bloodDataItemDesc = "") As %String
{
	set total=0
	set moduleCode = "AnaestRecord"
	set recordSheetId=##class(CIS.AN.BL.RecordSheet).GetRecordSheetIdByModCode(opsId,moduleCode,"")
	set drugDatas=##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.AnaestRecord:FindDrugDatas",recordSheetId,"N")
	for i=1:1:(drugDatas.Size)
	{
		set drugData = drugDatas.GetAt(i)
		continue:drugData=""
		set dataItemId=drugData.GetValue("DataItem")
		set rowId=drugData.GetValue("RowId")
		set doseUnit=drugData.GetValue("DoseUnitDesc")
		set description=drugData.GetValue("Description")
		set mainCategoryCode=drugData.GetValue("MainCategoryCode")
		continue:categoryCode'=mainCategoryCode
		continue:(bloodDataItemDesc'="")&&(bloodDataItemDesc'=description)
		set sumQty=##class(CIS.AN.BL.AnaestRecord).CalcDrugSumQty(rowId)
		set total=total+sumQty
	}
	quit total
}

ClassMethod GetAnaQualityControl(opsId As %String, ByRef array As %String) As %String
{
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	set mainAnaId=##class(CIS.AN.BL.Anaesthesia).GetMainAnaId(opsId)
	set operDept=operSchedule.OperDeptID
	set statusCode=operSchedule.Status.Code
	set operDate=operSchedule.OperDate
	set operTime=operSchedule.OperTime
	set EpisodeID=operSchedule.EpisodeID
	set anaestObj=##class(CIS.AN.COM.Query).ToObject("CIS.AN.BL.Anaesthesia:FindAnaesthesia",opsId)
    set AnaStartDT=anaestObj.GetValue("AnaStartDT")				
    set TheatreOutTransLoc=anaestObj.GetValue("TheatreOutTransLoc") 
    set PACUInDT=anaestObj.GetValue("PACUInDT")
	set PACUOutDT=anaestObj.GetValue("PACUOutDT")
	set TheatreInDT=anaestObj.GetValue("TheatreInDT")
	set TheatreOutDT=anaestObj.GetValue("TheatreOutDT")
	set AnaMethod=anaestObj.GetValue("AnaMethod")				
	set TheatreOutTransLoc=anaestObj.GetValue("TheatreOutTransLoc")
	set IsNonePlanInICU=anaestObj.GetValue("IsNonePlanInICU")
			
	set moduleId=""
	set moduleDesc="麻醉质控指标"
	&sql(select RowId into :moduleId from CT_AN.DataModule where Description=:moduleDesc)
	
	kill array
	//麻醉开始后手术取消
	set array(opsId,"AnaStartAndOperCancel")=$$OR($$JudgeModuleDataValue(opsId, moduleId, "ANACQualityAnCancelStart", "是"), $$JudgeAnaStartAndOperCancel()) 
	//麻醉后监测治疗室(PACU)转出延迟
	set array(opsId,"PACUTransferOutDelay")=$$OR($$JudgeModuleDataValue(opsId, moduleId, "ANAPACUTransferOutDelay", "是"), $$JudgePACUTransferOutDelay())
	//PACU入室低体温
	set array(opsId,"PACUInRoomLowTemperature")=$$OR($$JudgeModuleDataValue(opsId, moduleId, "ANAPACUInRoomLowTemperature", "是"), $$JudgePACUInRoomLowTemperature())
	//非计划转入ICU
	set array(opsId,"NonePlanTransferToICU")=$$OR($$JudgeModuleDataValue(opsId, moduleId, "ANAUnPlanToICU", "是"), "N")
	//非计划二次气管插管
	set array(opsId,"NonePlanReTubeIn")=$$OR($$JudgeModuleDataValue(opsId, moduleId, "ANAUnPlanTube", "是"), $$JudgeNonePlanReTubeIn())
	//麻醉开始后24小时内死亡
	set array(opsId,"DeathAfterAnaest24Hour")=$$OR($$JudgeModuleDataValue(opsId, moduleId, "ANA24hDeadCHK", "是"), $$JudgePatientDeadIn24h())
	//麻醉开始后24小时内心跳骤停
	set array(opsId,"CardiacArrestAfterAnaest24Hour")=$$OR($$JudgeModuleDataValue(opsId, moduleId, "ANA24hHartStop", "是"), "N")
	//术中自体血输注
	set array(opsId,"SelfBloodTransfution")=$$OR($$JudgeModuleDataValue(opsId, moduleId, "ANAZTXSZ", "是"), $$JudgeSelfBloodTransfution())
	//麻醉期间严重过敏反应发生
	set array(opsId,"SevereAllergicReaction")=$$OR($$JudgeModuleDataValue(opsId, moduleId, "ANACQualityUnexpectedAllergy", "是"), $$JudgeSevereAllergicReaction())
	//椎管内麻醉后严重神经并发症发生
	set array(opsId,"ComplicatOfSpinalAnaest")=$$OR($$JudgeModuleDataValue(opsId, moduleId, "ANACQualityIntravertebralAnaNCP", "是"), "N")
	//中心静脉穿刺严重并发症发生
	set array(opsId,"SevereCentralVenipuncture")=$$OR($$JudgeModuleDataValue(opsId, moduleId, "ANACQualityCVPConcurrent", "是"), "N")
	//全麻气管插管拔管后声音嘶哑发生
	set array(opsId,"IntubeOuttubeHoarseness")=$$OR($$JudgeModuleDataValue(opsId, moduleId, "ANACQualityGeneralAnaHoarseness", "是"), "N")
	//麻醉后新发昏迷发生
	set array(opsId,"PostAnaestComa")=$$OR($$JudgeModuleDataValue(opsId, moduleId, "ANANewComa", "是"), "N")
	//术中呼吸心跳骤停
	set array(opsId,"ApneaInOper")=$$OR($$JudgeModuleDataValue(opsId, moduleId, "ANAInOPHartStop", "是"), "N")
	//术中主动保温
	set array(opsId,"HeatPreservationInOper")=$$OR($$JudgeModuleDataValue(opsId, moduleId, "ANAHeatPreservationInOper", "是"), "N")
	//入室后手术麻醉取消
	set array(opsId,"InRoomAndOperCancel")=$$OR($$JudgeModuleDataValue(opsId, moduleId, "ANACQualityInRoomCancelStart", "是"), "N")
	//麻醉后24小时内患者麻醉直接相关死亡
	set array(opsId,"DeathIn24HourForAnaest")=$$OR($$JudgeModuleDataValue(opsId, moduleId, "ANACQualityUnexpectedDead", "是"), "N")
	//区域阻滞麻醉后严重神经并发症发生
	set array(opsId,"SevereRegionBlockAnaest")=$$OR($$JudgeModuleDataValue(opsId, moduleId, "ANACQualityAreaAnaNCP", "是"), "N")
	//全身麻醉术中知晓发生
	set array(opsId,"AwarenessInGeneralAnest")=$$OR($$JudgeModuleDataValue(opsId, moduleId, "ANACQualityConsciousness", "是"), "N")
	//术中牙齿损伤发生
	set array(opsId,"ToothDamageInOper")=$$OR($$JudgeModuleDataValue(opsId, moduleId, "ANACQualityTeethBroken", "是"), "N")
	//麻醉中发生未预期的意识障碍
	set array(opsId,"ConsciousnessDisorder")=$$OR($$JudgeModuleDataValue(opsId, moduleId, "ANAConsciousnessDisorder", "是"), "N")
	//麻醉中出现氧饱和度重度降低
	set array(opsId,"SPO2LowInOper")=$$OR($$JudgeModuleDataValue(opsId, moduleId, "ANASPO2LowInOper", "是"), "N")
	//全身麻醉结束时使用催醒药物
	set array(opsId,"UseAwakeningDrug")=$$OR($$JudgeModuleDataValue(opsId, moduleId, "ANAUseAwakeningDrug", "是"), "N")
	//麻醉中因误咽误吸引发呼吸道硬塞
	set array(opsId,"RespiratoryBlock")=$$OR($$JudgeModuleDataValue(opsId, moduleId, "ANARespiratoryBlock", "是"), "N")
	//实施心肺复苏治疗
	set array(opsId,"CardiopulmonaryResume")=$$OR($$JudgeModuleDataValue(opsId, moduleId, "ANACardiopulmonaryResume", "是"), "N")
	//心肺复苏成功
	set array(opsId,"CardiopulmonaryResumeSuccess")=$$OR($$JudgeModuleDataValue(opsId, moduleId, "ANACCPRSusses", "是"), "N")
	//计划外建立人工气道
	set array(opsId,"NonePlanArtificialAirway")=$$OR($$JudgeModuleDataValue(opsId, moduleId, "ANANonePlanArtificialAirway", "是"), "N")
	
	quit 0
	
OR(p1, p2)
	quit:(p1="Y")||(p2="Y") "Y"
	quit "N"

AND(p1, p2)
	quit:(p1="Y")&&(p2="Y") "Y"
	quit "N"
	
JudgeModuleDataValue(opsId,moduleId,dataItemCode,dataValue)
	set RecordSheet="",value=""
	&sql(select RowId into :RecordSheet from CIS_AN.RecordSheet where OperSchedule=:opsId and DataModule=:moduleId)
	if RecordSheet'="" &sql(select DataValue into :value from CIS_AN.OperData where RecordSheet=:RecordSheet and DataItem=:dataItemCode)
	quit:value=dataValue "Y"
	quit "N"
	
JudgeAnaStartAndOperCancel()
	//麻醉开始后手术取消
	set result="N"
	if (##class(CIS.AN.BL.AnesthetistWorkload).HasEvent(opsId,"麻醉开始")="Y")&&(statusCode="Stop") set result="Y"
	quit result
	
JudgePACUTransferOutDelay()
	//麻醉后监测治疗室(PACU)转出延迟率
	set result="N"
	if ((PACUInDT'="")&&(PACUOutDT'=""))
	{
		set duration=##class(CIS.AN.COM.DateTime).CalculateDurationS(PACUInDT,PACUOutDT,"H")
		if (duration>3) set result="Y"
	}
	quit result

JudgePACUInRoomLowTemperature()
	//PACU入室低体温率
	set result="N"
	if ((PACUInDT'="")&&(PACUOutDT'=""))
	{
		set pacuMinTemp=$$GetMinVitalSignValue(opsId,"PACURecord","Temperature")
		if (+pacuMinTemp>0 && +pacuMinTemp<35.5) set result="Y"
	}
	quit result
	
JudgeNonePlanReTubeIn()
	//非计划二次气管插管
	set result="N"
	if ((##class(CIS.AN.BL.AnesthetistWorkload).GetEventDataCount(opsId,"TubeIn")>1)&&(TheatreOutTransLoc="ICU")) set result="Y"
	quit result
	
JudgePatientDeadIn24h()
	//病人术后24小时死亡
	set result="N"
	if (TheatreOutTransLoc="Death") set result="Y"
	set deadDate="",deadTime=""
	&sql(SELECT PAADM_EstimDischargeDate,PAADM_EstimDischargeTime into :deadDate,:deadTime FROM SQLUser.PA_Adm WHERE PAADM_Type ='I' AND PAADM_VisitStatus ='D' AND  PAADM_DischCond_DR=14 AND PAADM_RowID=:EpisodeID)
	if ((deadDate'="")&&(deadTime'=""))
	{
		set duration=##class(CIS.AN.COM.DateTime).CalculateDuration(operDate,operTime,deadDate,deadTime,"D")
		if +duration<=1 set result="Y"
	}
	if (TheatreOutTransLoc="Death") set result="Y"
	quit result

JudgeSelfBloodTransfution()
	//术中自体血输注
	set result="N"
	if (..GetBloodTransVolume(opsId,"BloodTransfusion","自体血")>=400) set result="Y"
	quit result
	
JudgeSevereAllergicReaction()
	//麻醉期间严重过敏反应发生率
	set result="N"
	if ((##class(CIS.AN.BL.AnesthetistWorkload).HasEvent(opsId,"过敏")="Y")||(##class(CIS.AN.BL.AnesthetistWorkload).HasEvent(opsId,"过敏性休克")="Y"))
	{
		set result="Y"
	}
	quit result
	
GetMinVitalSignValue(opsId, moduleCode, paraItemCode) 
	set minValue=""
	set recordSheetId=##class(CIS.AN.BL.RecordSheet).GetRecordSheetIdByModCode(opsId,moduleCode,"")
	set paraItemId=##class(CIS.AN.BL.AnesthetistWorkload).GetParaItemId(recordSheetId,"Temperature")
	&sql(SELECT min(DataValue) into :minValue FROM cis_an.anadata WHERE ParaItem=:paraItemId)
	quit minValue
}

}
