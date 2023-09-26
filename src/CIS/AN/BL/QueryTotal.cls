Class CIS.AN.BL.QueryTotal Extends %Persistent
{

// Description: 	手术室工作统计

// Input:			statDate:开始日期，endDate：结束日期

// call CIS_AN_BL.QueryTotal_NurseWorkTotal("2021-07-01","2021-07-28")

// do ##class(%ResultSet).RunQuery("CIS.AN.BL.QueryTotal","NurseWorkTotal","2021-07-26","2021-07-26")

Query NurseWorkTotal(statDate As %String, endDate As %String) As %Query(ROWSPEC = "scNurCode:%String,scNurName:%String,opsId:%String,operDesc:%String,age:%String,opsttime:%String,opendtime:%String,opTime:%String,ASAClass:%String,ageScore:%Float,ASAClassScore:%Float,openScore:%Float,endScore:%Float,opTimeScore:%Float,TSScore:%Float,midNightScore:%Float,NoScNurScore:%Float,MedcareNo:%String,TotalScore:%String") [ SqlProc ]
{
}

ClassMethod NurseWorkTotalExecute(ByRef qHandle As %Binary, statDate As %String, endDate As %String) As %Status
{
	k ^tempNurWorkCount("App",$j)
	K ^tempNurWorkCountALL
	set repid=$I(^CacheTemp)
 	set ind=1
 	if statDate="" set sdate=+$H
 	else  set sdate=##class(web.DHCClinicCom).ConvertToDateH(statDate)
 	if endDate="" set edate=+$h
 	else  set edate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
 	set SubNode="SDate"
 	set opsId=""
 	for date=sdate:1:edate
 	{
	 	set opsId=0
	 	for
	 	{
		 	set opTimeScore=0,ASAClassScore=0,midNightScore=0,ageScore=0,openScore=$fn(0.5,"",2),endScore=$fn(0.5,"",2),TSScore=0,NoScNurScore=0
	 		set opsId=$o(^CIS.AN.OperScheduleI("OPDate",date,opsId))
			quit:(opsId="")
			set schedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
			;set theatreInTime=##class(CIS.AN.BL.OperData).GetOperDataByCode(opsId,"AN_OPS_006","TheatreInTime")
			;continue:(theatreInTime="")
			set anaestObj=##class(CIS.AN.COM.Query).ToObject("CIS.AN.BL.Anaesthesia:FindAnaesthesia",opsId)
			set OperStartDT=anaestObj.GetValue("OperStartDT")			// 手术开始时间
			set OperFinishDT=anaestObj.GetValue("OperFinishDT")			// 手术结束时间
			continue:OperStartDT=""
			continue:OperFinishDT=""
			if OperStartDT'="" set opsttime=$zth($p(OperStartDT," ",2))
			if OperFinishDT'="" set opendtime=$zth($p(OperFinishDT," ",2))
			if (opsttime>opendtime) set opTime=opendtime+86400-opsttime
			else  set opTime=opendtime-opsttime
			
			i (opendtime>1)&(opendtime<28800) set midNightScore=1
			set opTimeScore=$fn((opTime/3600),"",1)
			
			set OperDesc=""
			set operData=##class(CIS.AN.BL.OperScheduleList).GetOperList(opsId,.operData)
			//set operListObject=##class(CIS.AN.BL.OperationList).GetOperListObject(opsId)
			set OperDesc=operData(1,"OperationDesc")					// 实施手术名称
			if OperDesc["透视" set TSScore=$fn("0.5",",",1)
			
			set ASAClassDesc="Ⅱ"
			set ASAClasstem=anaestObj.GetValue("ASAClassDesc")
			if ASAClasstem'="" set ASAClassDesc=ASAClasstem
			if ASAClassDesc="Ⅲ" set ASAClassScore=$fn("0.5",",",1)
            if ASAClassDesc="Ⅳ" set ASAClassScore=$fn("1",",",1)
            if ASAClassDesc="Ⅴ" set ASAClassScore=$fn("2",",",1)
            
            set EpisodeID=schedule.EpisodeID
            set patInfoObj=##class(CIS.AN.COM.Query).ToObject("CIS.AN.BL.Admission:FindPatient",EpisodeID)
            set age=patInfoObj.GetValue("PatAge")
            //set papmiId=$p($g(^PAADM(adm)),"^",1)
            set MedcareNo =patInfoObj.GetValue("MedcareNo") ;住院号
            //set birth=$p($g(^PAPER(papmiId,"ALL")),"^",6)
	        //set age=##class(web.UDHCANOPArrange).CalAge(birth,+$h)   //年龄
	        if ((age["岁")&((+age>70)||(+age=70))) set ageScore=$fn("0.5",",",1)
	        if ((age["岁")&((+age<6)||(+age=6))) set ageScore=$fn("0.5",",",1)
	        //总分
			s TotalScore=ageScore+ASAClassScore+openScore+endScore+opTimeScore+TSScore+midNightScore+NoScNurScore
	        
	        set scNurCode="",scNurName=""
	        set ScrubNurse=schedule.ScrubNurse	
	        if ScrubNurse="" set NoScNurScore=$fn("0.5",",",1)		;无器械护士
	        set scNurCode=$Piece($get(^CTPCP(+ScrubNurse,1)),"^",1)
			set scNurName=$Piece($get(^CTPCP(+ScrubNurse,1)),"^",2)
			if scNurCode'="" s ^tempNurWorkCount("App",$j,scNurCode,opsId)=$lb(scNurCode,scNurName,opsId,OperDesc,age,$zt(opsttime,1),$zt(opendtime,1),$zt(opTime,1),ASAClassDesc,ageScore,ASAClassScore,openScore,endScore,opTimeScore,TSScore,midNightScore,NoScNurScore,MedcareNo,TotalScore)
			if scNurCode'="" S ^tempNurWorkCountALL(scNurCode,opsId)=scNurName_"^"_ageScore_"^"_ASAClassScore_"^"_openScore_"^"_endScore_"^"_opTimeScore_"^"_TSScore_"^"_midNightScore_"^"_NoScNurScore
			
			set cirNurCode="",cirNurName=""  //巡床
			set CircualNurse=schedule.CircualNurse
			set scNurCode=$Piece($get(^CTPCP(+cirNurCode,1)),"^",1)
			set scNurName=$Piece($get(^CTPCP(+cirNurCode,1)),"^",2)
			if cirNurCode'="" s ^tempNurWorkCount("App",$j,cirNurCode,opsId)=$lb(cirNurCode,cirNurName,opsId,OperDesc,age,opsttime,opendtime,opTime,ASAClassDesc,ageScore,ASAClassScore,openScore,endScore,opTimeScore,TSScore,midNightScore,NoScNurScore,MedcareNo,TotalScore)
			if cirNurCode'="" S ^tempNurWorkCountALL(cirNurCode,opsId)=scNurName_"^"_ageScore_"^"_ASAClassScore_"^"_openScore_"^"_endScore_"^"_opTimeScore_"^"_TSScore_"^"_midNightScore_"^"_NoScNurScore
			//do OutRowNurseWorkTotal
	 	}
 	}  //end date
 	
 	set NurCode=""
 	for
	 		{	
	 			
	 			set NurCode=$o(^tempNurWorkCount("App",$j,NurCode))
	 			q:NurCode=""
	 			set opsId=""
	 			for
	 			{	
	 				
	 				set opsId=$o(^tempNurWorkCount("App",$j,NurCode,opsId))
	 				q:opsId=""
	 				do OutRowFindFindAnaDiag(^tempNurWorkCount("App",$j,NurCode,opsId))
	 			}
	 			
	 		}
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutRowFindFindAnaDiag(test)
	//set Data=$lb(opsId,OperStartDT,OperFinishDT,opTimeScore,midNightScore,OperDesc,TSScore,ASAClassDesc,ageScore,NoScNurScore,ScrubNurse,scNurCode,scNurName)
 	set Data=test
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod NurseWorkTotalFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = NurseWorkTotalExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod NurseWorkTotalClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = NurseWorkTotalExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

// 汇总

Query NurseWorkTotalAll(statDate As %String, endDate As %String) As %Query(ROWSPEC = "Name:%String,total:%Float") [ SqlProc ]
{
}

ClassMethod NurseWorkTotalAllExecute(ByRef qHandle As %Binary, statDate As %String, endDate As %String) As %Status
{
	
	
	set repid=$I(^CacheTemp)
 	set ind=1
 	//do ##class(%ResultSet).RunQuery("CIS.AN.BL.QueryTotal","NurseWorkTotal",statDate,endDate)
 	set NurseCode=""
 	for
 	{	
 		set NurseCode=$o(^tempNurWorkCountALL(NurseCode))
 		q:NurseCode=""
 		
 		set count=0
 		
 		set opsId=""
 		for
 		{	
 			set opsId=$o(^tempNurWorkCountALL(NurseCode,opsId))
 			q:opsId=""
 			set NurseName=$p(^tempNurWorkCountALL(NurseCode,opsId),"^",1)
 			set score1=$p(^tempNurWorkCountALL(NurseCode,opsId),"^",2)
 			set score2=$p(^tempNurWorkCountALL(NurseCode,opsId),"^",3)
 			set score3=$p(^tempNurWorkCountALL(NurseCode,opsId),"^",4)
 			set score4=$p(^tempNurWorkCountALL(NurseCode,opsId),"^",5)
 			set score5=$p(^tempNurWorkCountALL(NurseCode,opsId),"^",6)
 			set count=count+score1+score2+score3+score4+score5
 		}
 		do OutRowNurseWorkTotalAll
 	}
 	
 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutRowNurseWorkTotalAll
	set Data=$lb(NurseName,count)
 	
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod NurseWorkTotalAllFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = NurseWorkTotalAllExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod NurseWorkTotalAllClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = NurseWorkTotalAllExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

// Description: 	麻醉工作统计

// Input:			statDate:开始日期，endDate：结束日期

// call CIS_AN_BL.QueryTotal_AnaDocWorkTotal("2021-07-01","2021-07-28")

// do ##class(%ResultSet).RunQuery("CIS.AN.BL.QueryTotal","AnaDocWorkTotal","2021-08-11","2021-08-11","","陈明富")

Query AnaDocWorkTotal(statDate As %String, endDate As %String, ZYHMedcareNo As %String = "", XMName As %String = "") As %Query(ROWSPEC = "AnesthesiologistCode:%String,AnesthesiologistDesc:%String,opsId:%String,opsttime:%String,opendtime:%String,opTime:%String,AnaMethodStr:%String,methodScoreTotal,TimeScore:%Float,SjmccScore:%Float,count:%Float,MedcareNo:%String") [ SqlProc ]
{
}

ClassMethod AnaDocWorkTotalExecute(ByRef qHandle As %Binary, statDate As %String, endDate As %String, ZYHMedcareNo As %String = "", XMName As %String = "") As %Status
{
	k ^tempANADocWorkCount("App",$j)
	k ^tempANADocWorkCountAll
	set repid=$I(^CacheTemp)
 	set ind=1
 	s ^DHCSZJSZX("SZJSZHWK")=$lb(statDate,endDate,ZYHMedcareNo,XMName)
 	if statDate="" set sdate=+$H
 	else  set sdate=##class(web.DHCClinicCom).ConvertToDateH(statDate)
 	if endDate="" set edate=+$h
 	else  set edate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
 	if ZYHMedcareNo'="" s ZYHMedcareNo=$replace(ZYHMedcareNo," ","")
 	if XMName'="" s XMName=$replace(XMName," ","")
 	set SubNode="SDate"
 	set opsId=""
 	for date=sdate:1:edate
 	{
	 	set opsId=0
	 	for
	 	{
		 	s flag=0,XMFlag=0,resu=""
		 	set anamethodScore=0,SpecialOperation=0,methodScoreTotal=0
	 		set opsId=$o(^CIS.AN.OperScheduleI("OPDate",date,opsId))
			quit:(opsId="")
			
			set schedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
			set EpisodeID=schedule.EpisodeID
            set patInfoObj=##class(CIS.AN.COM.Query).ToObject("CIS.AN.BL.Admission:FindPatient",EpisodeID)
            set MedcareNo =patInfoObj.GetValue("MedcareNo") ;住院号
			if (ZYHMedcareNo'="")&&(ZYHMedcareNo'=MedcareNo) s flag=1
			continue:(flag=1)
			;set theatreInTime=##class(CIS.AN.BL.OperData).GetOperDataByCode(opsId,"AN_OPS_006","TheatreInTime")
			;continue:(theatreInTime="")
			
			set anaestObj=##class(CIS.AN.COM.Query).ToObject("CIS.AN.BL.Anaesthesia:FindAnaesthesia",opsId)
			
			set AnesthesiologistCode="",AnesthesiologistDesc=""
			set Anesthesiologist=anaestObj.GetValue("Anesthesiologist")	// 麻醉医生
			//continue:Anesthesiologist=""
			//set AnesthesiologistDesc=anaestObj.GetValue("AnesthesiologistDesc")		// 麻醉医生姓名
			set AnesthesiologistCode=$Piece($get(^CTPCP(+Anesthesiologist,1)),"^",1)
			set AnesthesiologistDesc=$Piece($get(^CTPCP(+Anesthesiologist,1)),"^",2)
			
			set AnaExpert="",AnaExpertCode="",AnaExpertDesc=""
	 		set AnaExpert=anaestObj.GetValue("AnaExpert")				// 麻醉指导
	 		set AnaExpertCode=$Piece($get(^CTPCP(+AnaExpert,1)),"^",1)
	 		set AnaExpertDesc=$Piece($get(^CTPCP(+AnaExpert,1)),"^",2)
	 		
			if (XMName'="")&&((XMName'=AnesthesiologistDesc)&&(XMName'=AnaExpertDesc)) s XMFlag=1
			continue:(XMFlag=1)
			
			set OperStartDT=anaestObj.GetValue("TheatreInDT")			// 手术开始时间，OperStartDT手术开始
			set OperFinishDT=anaestObj.GetValue("OperFinishDT")			// 手术结束时间
			continue:OperStartDT=""
			continue:OperFinishDT=""
			if OperStartDT'="" set opsttime=$zth($p(OperStartDT," ",2))
			if OperFinishDT'="" set opendtime=$zth($p(OperFinishDT," ",2))
			if (opsttime>opendtime) set opTime=opendtime+86400-opsttime
			else  set opTime=opendtime-opsttime
			
			i (opendtime>1)&(opendtime<28800) set midNightScore=1
			set opTimeScore=$fn((opTime/3600),"",1)
			
			//set AnaMethod=anaestObj.GetValue("AnaMethod")				// 麻醉方法ID
			//set AnaMethodDesc=##class(CIS.AN.COM.String).GetDescByIDStr("User.ORCAnaestMethod","ANMETDesc",AnaMethod)	// 麻醉方法名称
			
			set AnaMethodStr=##class("CIS.AN.BL.OperScheduleList").GetAnaestMethod(opsId)
            set rowIdCount=$length(AnaMethodStr,"+")
            
			for i=1:1:rowIdCount
			{
				set AnaMethodDesc=$piece(AnaMethodStr,"+",i)
				set:AnaMethodDesc="基础麻醉(含强化)" anamethodScore=$fn(0.5,"",2)
				set:AnaMethodDesc="全身麻醉(未插管)" anamethodScore=$fn(0.5,"",2)
				set:AnaMethodDesc="股神经阻滞" anamethodScore=$fn(0.5,"",2)
				set:AnaMethodDesc="坐骨神经阻滞" anamethodScore=$fn(0.5,"",2)
				
				set:AnaMethodDesc="腹平面神经阻滞" anamethodScore=$fn(1,"",2)
				set:AnaMethodDesc="腰丛神经阻滞" anamethodScore=$fn(1,"",2)
				set:AnaMethodDesc="连续硬膜外麻醉" anamethodScore=$fn(1,"",2)
				set:AnaMethodDesc="单次腰麻" anamethodScore=$fn(1,"",2)
				set:AnaMethodDesc="骶管阻滞麻醉" anamethodScore=$fn(1,"",2)
				set:AnaMethodDesc="颈丛神经阻滞" anamethodScore=$fn(1,"",2)
				set:AnaMethodDesc="腰硬联合麻醉" anamethodScore=$fn(2,"",2)
				
				set:AnaMethodDesc="臂丛神经阻滞" anamethodScore=$fn(2,"",2)
				
				set:AnaMethodDesc="全身麻醉(气管插管)" anamethodScore=$fn(3.5,"",2)
				set:AnaMethodDesc="全身麻醉(喉罩置入)" anamethodScore=$fn(3.5,"",2)
				
				set:AnaMethodDesc="支气管内麻醉" anamethodScore=$fn(5,"",2)
				if i=1 set methodScoreTotal=$fn($fn(methodScoreTotal,"",2)+$fn(anamethodScore,"",2),"",2)
				else  set methodScoreTotal=$fn($fn(methodScoreTotal,"",2)+$fn((anamethodScore*0.5),"",2),"",2)
			}
			set TimeScore=0
			if (opTime>(3600*2))&&(AnaMethodStr'["全身麻醉(气管插管)")
			{	
				set TimeScore=$fn(((opTime-(3600*2))/3600)*0.5,"",2)
			}
			
			if (opTime>(3600*3))&&(AnaMethodStr["全身麻醉(气管插管)")
			{	
				set TimeScore=$fn((((opTime-(3*3600))/3600)*0.75)+1,"",2)
			}
			
			set sjmcc1=##class(CIS.AN.BL.OperData).GetOperDataByCode(opsId,"AN_ANS_017","ANIGeneralInduce")
			set sjmcc2=##class(CIS.AN.BL.OperData).GetOperDataByCode(opsId,"AN_ANS_034","ANIGeneralInduce")
			set sjmcc3=##class(CIS.AN.BL.OperData).GetOperDataByCode(opsId,"AN_ANS_033","ANIGeneralInduce")
			set sjmcc4=##class(CIS.AN.BL.OperData).GetOperDataByCode(opsId,"AN_ANS_017","ANIGeneralInduceType")
			set sjmcc5=##class(CIS.AN.BL.OperData).GetOperDataByCode(opsId,"AN_ANS_034","ANIGeneralInduceType")
			set sjmcc6=##class(CIS.AN.BL.OperData).GetOperDataByCode(opsId,"AN_ANS_033","ANIGeneralInduceType")
			set SjmccScore=0
			if (((sjmcc1'="")&&(sjmcc1'="/"))||((sjmcc2'="")&&(sjmcc2'="/"))||((sjmcc3'="")&&(sjmcc3'="/"))||((sjmcc4'="")&&(sjmcc4'="/"))||((sjmcc5'="")&&(sjmcc5'="/"))||((sjmcc6'="")&&(sjmcc6'="/")))
			{	
				set SjmccScore=1
			}
			
			set count=0
			set count=$fn(methodScoreTotal+TimeScore+SjmccScore,"",2)
			
			if AnesthesiologistCode'=""  d
			.i XMName'="" d
			..i XMName=AnesthesiologistDesc d
			...s ^tempANADocWorkCount("App",$j,AnesthesiologistCode,opsId)=$lb(AnesthesiologistCode,AnesthesiologistDesc,opsId,$zt(opsttime,1),$zt(opendtime,1),$zt(opTime,1),AnaMethodStr,methodScoreTotal,TimeScore,SjmccScore,count,MedcareNo)
			...s ^tempANADocWorkCountAll(AnesthesiologistCode,opsId)=AnesthesiologistDesc_"^"_methodScoreTotal_"^"_TimeScore_"^"_SjmccScore
			.e  d
			..s ^tempANADocWorkCount("App",$j,AnesthesiologistCode,opsId)=$lb(AnesthesiologistCode,AnesthesiologistDesc,opsId,$zt(opsttime,1),$zt(opendtime,1),$zt(opTime,1),AnaMethodStr,methodScoreTotal,TimeScore,SjmccScore,count,MedcareNo)
			..s ^tempANADocWorkCountAll(AnesthesiologistCode,opsId)=AnesthesiologistDesc_"^"_methodScoreTotal_"^"_TimeScore_"^"_SjmccScore
			
			;if AnesthesiologistCode'="" s ^tempANADocWorkCount("App",$j,AnesthesiologistCode,opsId)=$lb(AnesthesiologistCode,AnesthesiologistDesc,opsId,$zt(opsttime,1),$zt(opendtime,1),$zt(opTime,1),AnaMethodStr,methodScoreTotal,TimeScore,SjmccScore,count,MedcareNo)
	 		;if AnesthesiologistCode'="" s ^tempANADocWorkCountAll(AnesthesiologistCode,opsId)=AnesthesiologistDesc_"^"_methodScoreTotal_"^"_TimeScore_"^"_SjmccScore
	 		
			if AnaExpertCode'=""  d
			.i XMName'="" d
			..i XMName=AnaExpertDesc d
			...s ^tempANADocWorkCount("App",$j,AnaExpertCode,opsId)=$lb(AnaExpertCode,AnaExpertDesc,opsId,$zt(opsttime,1),$zt(opendtime,1),$zt(opTime,1),AnaMethodStr,methodScoreTotal,TimeScore,SjmccScore,count,MedcareNo)
			...s ^tempANADocWorkCountAll(AnaExpertCode,opsId)=AnaExpertDesc_"^"_methodScoreTotal_"^"_TimeScore_"^"_SjmccScore
			.e  d
			..s ^tempANADocWorkCount("App",$j,AnaExpertCode,opsId)=$lb(AnaExpertCode,AnaExpertDesc,opsId,$zt(opsttime,1),$zt(opendtime,1),$zt(opTime,1),AnaMethodStr,methodScoreTotal,TimeScore,SjmccScore,count,MedcareNo)
			..s ^tempANADocWorkCountAll(AnaExpertCode,opsId)=AnaExpertDesc_"^"_methodScoreTotal_"^"_TimeScore_"^"_SjmccScore
			
	 		;if AnaExpertCode'="" s ^tempANADocWorkCount("App",$j,AnaExpertCode,opsId)=$lb(AnaExpertCode,AnaExpertDesc,opsId,$zt(opsttime,1),$zt(opendtime,1),$zt(opTime,1),AnaMethodStr,methodScoreTotal,TimeScore,SjmccScore,count,MedcareNo)
	 		;if AnaExpertCode'="" s ^tempANADocWorkCountAll(AnaExpertCode,opsId)=AnaExpertDesc_"^"_methodScoreTotal_"^"_TimeScore_"^"_SjmccScore
	 	}
 	}  //end date
 	
 	set NurCode=""
 	for
	 		{	
	 			
	 			set NurCode=$o(^tempANADocWorkCount("App",$j,NurCode))
	 			q:NurCode=""
	 			set opsId=""
	 			for
	 			{	
	 				
	 				set opsId=$o(^tempANADocWorkCount("App",$j,NurCode,opsId))
	 				q:opsId=""
	 				do OutRowAnaDocWorkTotal(^tempANADocWorkCount("App",$j,NurCode,opsId))
	 			}
	 			
	 		}
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutRowAnaDocWorkTotal(test)
	//set Data=$lb(opsId,OperStartDT,OperFinishDT,opTimeScore,midNightScore,OperDesc,TSScore,ASAClassDesc,ageScore,NoScNurScore,ScrubNurse,scNurCode,scNurName)
 	set Data=test
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod AnaDocWorkTotalFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = AnaDocWorkTotalExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod AnaDocWorkTotalClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = AnaDocWorkTotalExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query ANWorkTotalAll(statDate As %String, endDate As %String) As %Query(ROWSPEC = "Name:%String,total:%Float") [ SqlProc ]
{
}

ClassMethod ANWorkTotalAllExecute(ByRef qHandle As %Binary, statDate As %String, endDate As %String) As %Status
{
	
	
	set repid=$I(^CacheTemp)
 	set ind=1
 	set NurseCode=""
 	for
 	{	
 		set NurseCode=$o(^tempANADocWorkCountAll(NurseCode))
 		q:NurseCode=""
 		
 		set count=0
 		
 		set opsId=""
 		for
 		{	
 			set opsId=$o(^tempANADocWorkCountAll(NurseCode,opsId))
 			q:opsId=""
 			set NurseName=$p(^tempANADocWorkCountAll(NurseCode,opsId),"^",1)
 			set score1=$p(^tempANADocWorkCountAll(NurseCode,opsId),"^",2)
 			set score2=$p(^tempANADocWorkCountAll(NurseCode,opsId),"^",3)
 			set score3=$p(^tempANADocWorkCountAll(NurseCode,opsId),"^",4)
 			
 			set count=count+score1+score2+score3
 		}
 		do OutRowANWorkTotalAll
 	}
 	
 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutRowANWorkTotalAll
	set Data=$lb(NurseName,count)
 	
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod ANWorkTotalAllFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ANWorkTotalAllExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod ANWorkTotalAllClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ANWorkTotalAllExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

// 麻醉方法统计

// do ##class(%ResultSet).RunQuery("CIS.AN.BL.QueryTotal","AnaMethodQry","2021-07-26","2021-09-26")

// MethodDesc麻醉方法，count数量

Query AnaMethodQry(statDate As %String, endDate As %String) As %Query(ROWSPEC = "MethodDesc:%String,count:%Float") [ SqlProc ]
{
}

ClassMethod AnaMethodQryExecute(ByRef qHandle As %Binary, statDate As %String, endDate As %String) As %Status
{
	
	k ^tempAnaMethod
	set repid=$I(^CacheTemp)
 	set ind=1
 	if statDate="" set sdate=+$H
 	else  set sdate=##class(web.DHCClinicCom).ConvertToDateH(statDate)
 	if endDate="" set edate=+$h
 	else  set edate=##class(web.DHCClinicCom).ConvertToDateH(endDate)

 	set SubNode="SDate"
 	set opsId=""
 	for date=sdate:1:edate
 	{
	 	set opsId=0
	 	for
	 	{
	 		set opsId=$o(^CIS.AN.OperScheduleI("OPDate",date,opsId))
			quit:(opsId="")
			
			set schedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
			//set EpisodeID=schedule.EpisodeID
			set AnaMethodStr=##class("CIS.AN.BL.OperScheduleList").GetAnaestMethod(opsId)
            set rowIdCount=$length(AnaMethodStr,"+")
            
			for i=1:1:rowIdCount
			{
				set AnaMethodDesc=$piece(AnaMethodStr,"+",i)
				continue:AnaMethodDesc=""
				if AnaMethodDesc["("  set AnaMethodDesc=$p(AnaMethodDesc,"(",1)
				if $g(^tempAnaMethod(AnaMethodDesc))="" set ^tempAnaMethod(AnaMethodDesc)=1
				else  set ^tempAnaMethod(AnaMethodDesc)=^tempAnaMethod(AnaMethodDesc)+1
			}
			
	 	}
 	}
 	
 	set MethodDesc=""
 	for
 	{	
 		set MethodDesc=$o(^tempAnaMethod(MethodDesc))
 		q:MethodDesc=""
 		set count=^tempAnaMethod(MethodDesc)
 		do OutRowAnaMethodQry
 	}
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutRowAnaMethodQry
	set Data=$lb(MethodDesc,count)
 	
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod AnaMethodQryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = AnaMethodQryExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod AnaMethodQryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = AnaMethodQryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

// 手术间手术统计

// do ##class(%ResultSet).RunQuery("CIS.AN.BL.QueryTotal","OperRoomQry","2021-07-26","2021-09-26")

// RoomDesc手术间名称，count数量

Query OperRoomQry(statDate As %String, endDate As %String) As %Query(ROWSPEC = "RoomDesc:%String,count:%Float") [ SqlProc ]
{
}

ClassMethod OperRoomQryExecute(ByRef qHandle As %Binary, statDate As %String, endDate As %String) As %Status
{
	
	k ^tempOperRoomQry
	set repid=$I(^CacheTemp)
 	set ind=1
 	if statDate="" set sdate=+$H
 	else  set sdate=##class(web.DHCClinicCom).ConvertToDateH(statDate)
 	if endDate="" set edate=+$h
 	else  set edate=##class(web.DHCClinicCom).ConvertToDateH(endDate)

 	set SubNode="SDate"
 	set opsId=""
 	for date=sdate:1:edate
 	{
	 	set opsId=0
	 	for
	 	{
	 		set opsId=$o(^CIS.AN.OperScheduleI("OPDate",date,opsId))
			quit:(opsId="")
			
			set schedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
			//set EpisodeID=schedule.EpisodeID
			continue:schedule.OperRoom=""
			set OperRoom=schedule.OperRoom.%Id()                // 手术间ID
        	set RoomDesc=schedule.OperRoom.Description          // 手术间名称
			if $g(^tempOperRoomQry(RoomDesc))="" set ^tempOperRoomQry(RoomDesc)=1
			else  set ^tempOperRoomQry(RoomDesc)=^tempOperRoomQry(RoomDesc)+1
			
			
	 	}
 	}
 	
 	set RoomDesc=""
 	for
 	{	
 		set RoomDesc=$o(^tempOperRoomQry(RoomDesc))
 		q:RoomDesc=""
 		set count=^tempOperRoomQry(RoomDesc)
 		do OutRowOperRoomQry
 	}
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutRowOperRoomQry
	set Data=$lb(RoomDesc,count)
 	
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod OperRoomQryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = OperRoomQryExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod OperRoomQryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = OperRoomQryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

// Description: 	护士工作量统计

// Input:			statDate:开始日期，endDate：结束日期

// call CIS_AN_BL.QueryTotal_NurseOperNum("2021-07-01","2021-07-28")

// do ##class(%ResultSet).RunQuery("CIS.AN.BL.QueryTotal","NurseOperNum","2021-07-26","2021-07-26")

Query NurseOperNum(statDate As %String, endDate As %String) As %Query(ROWSPEC = "scNurCode:%String,scNurName:%String,opsId:%String,operDesc:%String,age:%String,opsttime:%String,opendtime:%String,opTime:%String") [ SqlProc ]
{
}

ClassMethod NurseOperNumExecute(ByRef qHandle As %Binary, statDate As %String, endDate As %String) As %Status
{
	k ^tempNurWorkCount("App",$j)
	K ^tempNurWorkCount
	set repid=$I(^CacheTemp)
 	set ind=1
 	if statDate="" set sdate=+$H
 	else  set sdate=##class(web.DHCClinicCom).ConvertToDateH(statDate)
 	if endDate="" set edate=+$h
 	else  set edate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
 	set SubNode="SDate"
 	set opsId=""
 	for date=sdate:1:edate
 	{
	 	set opsId=0
	 	for
	 	{
		 	set opTimeScore=0,ASAClassScore=0,midNightScore=0,ageScore=0,openScore=$fn(0.5,"",2),endScore=$fn(0.5,"",2),TSScore=0,NoScNurScore=0
	 		set opsId=$o(^CIS.AN.OperScheduleI("OPDate",date,opsId))
			quit:(opsId="")
			set schedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
			;set theatreInTime=##class(CIS.AN.BL.OperData).GetOperDataByCode(opsId,"AN_OPS_006","TheatreInTime")
			;continue:(theatreInTime="")
			set anaestObj=##class(CIS.AN.COM.Query).ToObject("CIS.AN.BL.Anaesthesia:FindAnaesthesia",opsId)
			set OperStartDT=anaestObj.GetValue("OperStartDT")			// 手术开始时间
			set OperFinishDT=anaestObj.GetValue("OperFinishDT")			// 手术结束时间
			continue:OperStartDT=""
			continue:OperFinishDT=""
			if OperStartDT'="" set opsttime=$zth($p(OperStartDT," ",2))
			if OperFinishDT'="" set opendtime=$zth($p(OperFinishDT," ",2))
			if (opsttime>opendtime) set opTime=opendtime+86400-opsttime
			else  set opTime=opendtime-opsttime
			
			i (opendtime>1)&(opendtime<28800) set midNightScore=1
			set opTimeScore=$fn((opTime/3600),"",1)
			
			set OperDesc=""
			set operData=##class(CIS.AN.BL.OperScheduleList).GetOperList(opsId,.operData)
			//set operListObject=##class(CIS.AN.BL.OperationList).GetOperListObject(opsId)
			set OperDesc=operData(1,"OperationDesc")					// 实施手术名称
			if OperDesc["透视" set TSScore=$fn("0.5",",",1)
			
			set ASAClassDesc="Ⅱ"
			set ASAClasstem=anaestObj.GetValue("ASAClassDesc")
			if ASAClasstem'="" set ASAClassDesc=ASAClasstem
			if ASAClassDesc="Ⅲ" set ASAClassScore=$fn("0.5",",",1)
            if ASAClassDesc="Ⅳ" set ASAClassScore=$fn("1",",",1)
            if ASAClassDesc="Ⅴ" set ASAClassScore=$fn("2",",",1)
            
            set EpisodeID=schedule.EpisodeID
            set patInfoObj=##class(CIS.AN.COM.Query).ToObject("CIS.AN.BL.Admission:FindPatient",EpisodeID)
            set age=patInfoObj.GetValue("PatAge")
            //set papmiId=$p($g(^PAADM(adm)),"^",1)
            set MedcareNo =patInfoObj.GetValue("MedcareNo") ;住院号
            //set birth=$p($g(^PAPER(papmiId,"ALL")),"^",6)
	        //set age=##class(web.UDHCANOPArrange).CalAge(birth,+$h)   //年龄
	        if ((age["岁")&((+age>70)||(+age=70))) set ageScore=$fn("0.5",",",1)
	        if ((age["岁")&((+age<6)||(+age=6))) set ageScore=$fn("0.5",",",1)
	        //总分
			s TotalScore=ageScore+ASAClassScore+openScore+endScore+opTimeScore+TSScore+midNightScore+NoScNurScore
	        
	        set scNurCode="",scNurName=""
	        set ScrubNurse=schedule.ScrubNurse	
	        if ScrubNurse="" set NoScNurScore=$fn("0.5",",",1)		;无器械护士
	        set scNurCode=$Piece($get(^CTPCP(+ScrubNurse,1)),"^",1)
			set scNurName=$Piece($get(^CTPCP(+ScrubNurse,1)),"^",2)
			if scNurCode'="" s ^tempNurWorkCount("App",$j,scNurCode,opsId)=$lb(scNurCode,scNurName,opsId,OperDesc,age,$zt(opsttime,1),$zt(opendtime,1),$fn(opTime/3600,"",2))
			;if scNurCode'="" S ^tempNurWorkCountALL(scNurCode,opsId)=scNurName_"^"_ageScore_"^"_ASAClassScore_"^"_openScore_"^"_endScore_"^"_opTimeScore_"^"_TSScore_"^"_midNightScore_"^"_NoScNurScore
			
			set cirNurCode="",cirNurName=""  //巡床
			set CircualNurse=schedule.CircualNurse
			set scNurCode=$Piece($get(^CTPCP(+cirNurCode,1)),"^",1)
			set scNurName=$Piece($get(^CTPCP(+cirNurCode,1)),"^",2)
			if cirNurCode'="" s ^tempNurWorkCount("App",$j,cirNurCode,opsId)=$lb(cirNurCode,cirNurName,opsId,OperDesc,age,opsttime,opendtime,$fn(opTime/3600,"",2))
			;if cirNurCode'="" S ^tempNurWorkCountALL(cirNurCode,opsId)=scNurName_"^"_ageScore_"^"_ASAClassScore_"^"_openScore_"^"_endScore_"^"_opTimeScore_"^"_TSScore_"^"_midNightScore_"^"_NoScNurScore
			//do OutRowNurseWorkTotal
	 	}
 	}  //end date
 	
 	set NurCode=""
 	for
	 		{	
	 			
	 			set NurCode=$o(^tempNurWorkCount("App",$j,NurCode))
	 			q:NurCode=""
	 			set opsId=""
	 			for
	 			{	
	 				
	 				set opsId=$o(^tempNurWorkCount("App",$j,NurCode,opsId))
	 				q:opsId=""
	 				do OutRowNurseOperNum(^tempNurWorkCount("App",$j,NurCode,opsId))
	 			}
	 			
	 		}
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutRowNurseOperNum(test)
	//set Data=$lb(opsId,OperStartDT,OperFinishDT,opTimeScore,midNightScore,OperDesc,TSScore,ASAClassDesc,ageScore,NoScNurScore,ScrubNurse,scNurCode,scNurName)
 	set Data=test
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod NurseOperNumFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = NurseOperNumExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod NurseOperNumClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = NurseOperNumExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

// Description: 	1.	麻醉医生工作量统计

// Input:			statDate:开始日期，endDate：结束日期

// call CIS_AN_BL.QueryTotal_AnaOperNum("2021-07-01","2021-07-28")

// do ##class(%ResultSet).RunQuery("CIS.AN.BL.QueryTotal","AnaOperNum","2021-08-11","2021-08-11","","")

Query AnaOperNum(statDate As %String, endDate As %String, ZYHMedcareNo As %String = "", XMName As %String = "") As %Query(ROWSPEC = "AnesthesiologistCode:%String,AnesthesiologistDesc:%String,opsId:%String,opsttime:%String,opendtime:%String,opTime:%String,AnaMethodStr:%String,methodScoreTotal,TimeScore:%Float,SjmccScore:%Float,count:%Float,MedcareNo:%String") [ SqlProc ]
{
}

ClassMethod AnaOperNumExecute(ByRef qHandle As %Binary, statDate As %String, endDate As %String, ZYHMedcareNo As %String = "", XMName As %String = "") As %Status
{
	k ^tempANADocWorkCount("App",$j)
	k ^tempANADocWorkCountAll
	set repid=$I(^CacheTemp)
 	set ind=1
 	s ^DHCSZJSZX("SZJSZHWK")=$lb(statDate,endDate,ZYHMedcareNo,XMName)
 	if statDate="" set sdate=+$H
 	else  set sdate=##class(web.DHCClinicCom).ConvertToDateH(statDate)
 	if endDate="" set edate=+$h
 	else  set edate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
 	if ZYHMedcareNo'="" s ZYHMedcareNo=$replace(ZYHMedcareNo," ","")
 	if XMName'="" s XMName=$replace(XMName," ","")
 	set SubNode="SDate"
 	set opsId=""
 	for date=sdate:1:edate
 	{
	 	set opsId=0
	 	for
	 	{
		 	s flag=0,XMFlag=0,resu=""
		 	set anamethodScore=0,SpecialOperation=0,methodScoreTotal=0
	 		set opsId=$o(^CIS.AN.OperScheduleI("OPDate",date,opsId))
			quit:(opsId="")
			
			set schedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
			set EpisodeID=schedule.EpisodeID
            set patInfoObj=##class(CIS.AN.COM.Query).ToObject("CIS.AN.BL.Admission:FindPatient",EpisodeID)
            set MedcareNo =patInfoObj.GetValue("MedcareNo") ;住院号
			if (ZYHMedcareNo'="")&&(ZYHMedcareNo'=MedcareNo) s flag=1
			continue:(flag=1)
			;set theatreInTime=##class(CIS.AN.BL.OperData).GetOperDataByCode(opsId,"AN_OPS_006","TheatreInTime")
			;continue:(theatreInTime="")
			
			set anaestObj=##class(CIS.AN.COM.Query).ToObject("CIS.AN.BL.Anaesthesia:FindAnaesthesia",opsId)
			
			set AnesthesiologistCode="",AnesthesiologistDesc=""
			set Anesthesiologist=anaestObj.GetValue("Anesthesiologist")	// 麻醉医生
			//continue:Anesthesiologist=""
			//set AnesthesiologistDesc=anaestObj.GetValue("AnesthesiologistDesc")		// 麻醉医生姓名
			set AnesthesiologistCode=$Piece($get(^CTPCP(+Anesthesiologist,1)),"^",1)
			set AnesthesiologistDesc=$Piece($get(^CTPCP(+Anesthesiologist,1)),"^",2)
			
			set AnaExpert="",AnaExpertCode="",AnaExpertDesc=""
	 		set AnaExpert=anaestObj.GetValue("AnaExpert")				// 麻醉指导
	 		set AnaExpertCode=$Piece($get(^CTPCP(+AnaExpert,1)),"^",1)
	 		set AnaExpertDesc=$Piece($get(^CTPCP(+AnaExpert,1)),"^",2)
	 		
			if (XMName'="")&&((XMName'=AnesthesiologistDesc)&&(XMName'=AnaExpertDesc)) s XMFlag=1
			continue:(XMFlag=1)
			
			set OperStartDT=anaestObj.GetValue("TheatreInDT")			// 手术开始时间，OperStartDT手术开始
			set OperFinishDT=anaestObj.GetValue("OperFinishDT")			// 手术结束时间
			continue:OperStartDT=""
			continue:OperFinishDT=""
			if OperStartDT'="" set opsttime=$zth($p(OperStartDT," ",2))
			if OperFinishDT'="" set opendtime=$zth($p(OperFinishDT," ",2))
			if (opsttime>opendtime) set opTime=opendtime+86400-opsttime
			else  set opTime=opendtime-opsttime
			
			i (opendtime>1)&(opendtime<28800) set midNightScore=1
			set opTimeScore=$fn((opTime/3600),"",1)
			
			//set AnaMethod=anaestObj.GetValue("AnaMethod")				// 麻醉方法ID
			//set AnaMethodDesc=##class(CIS.AN.COM.String).GetDescByIDStr("User.ORCAnaestMethod","ANMETDesc",AnaMethod)	// 麻醉方法名称
			
			set AnaMethodStr=##class("CIS.AN.BL.OperScheduleList").GetAnaestMethod(opsId)
            set rowIdCount=$length(AnaMethodStr,"+")
            
			for i=1:1:rowIdCount
			{
				set AnaMethodDesc=$piece(AnaMethodStr,"+",i)
				set:AnaMethodDesc="基础麻醉(含强化)" anamethodScore=$fn(0.5,"",2)
				set:AnaMethodDesc="全身麻醉(未插管)" anamethodScore=$fn(0.5,"",2)
				set:AnaMethodDesc="股神经阻滞" anamethodScore=$fn(0.5,"",2)
				set:AnaMethodDesc="坐骨神经阻滞" anamethodScore=$fn(0.5,"",2)
				
				set:AnaMethodDesc="腹平面神经阻滞" anamethodScore=$fn(1,"",2)
				set:AnaMethodDesc="腰丛神经阻滞" anamethodScore=$fn(1,"",2)
				set:AnaMethodDesc="连续硬膜外麻醉" anamethodScore=$fn(1,"",2)
				set:AnaMethodDesc="单次腰麻" anamethodScore=$fn(1,"",2)
				set:AnaMethodDesc="骶管阻滞麻醉" anamethodScore=$fn(1,"",2)
				set:AnaMethodDesc="颈丛神经阻滞" anamethodScore=$fn(1,"",2)
				set:AnaMethodDesc="腰硬联合麻醉" anamethodScore=$fn(2,"",2)
				
				set:AnaMethodDesc="臂丛神经阻滞" anamethodScore=$fn(2,"",2)
				
				set:AnaMethodDesc="全身麻醉(气管插管)" anamethodScore=$fn(3.5,"",2)
				set:AnaMethodDesc="全身麻醉(喉罩置入)" anamethodScore=$fn(3.5,"",2)
				
				set:AnaMethodDesc="支气管内麻醉" anamethodScore=$fn(5,"",2)
				if i=1 set methodScoreTotal=$fn($fn(methodScoreTotal,"",2)+$fn(anamethodScore,"",2),"",2)
				else  set methodScoreTotal=$fn($fn(methodScoreTotal,"",2)+$fn((anamethodScore*0.5),"",2),"",2)
			}
			set TimeScore=0
			if (opTime>(3600*2))&&(AnaMethodStr'["全身麻醉(气管插管)")
			{	
				set TimeScore=$fn(((opTime-(3600*2))/3600)*0.5,"",2)
			}
			
			if (opTime>(3600*3))&&(AnaMethodStr["全身麻醉(气管插管)")
			{	
				set TimeScore=$fn((((opTime-(3*3600))/3600)*0.75)+1,"",2)
			}
			
			set sjmcc1=##class(CIS.AN.BL.OperData).GetOperDataByCode(opsId,"AN_ANS_017","ANIGeneralInduce")
			set sjmcc2=##class(CIS.AN.BL.OperData).GetOperDataByCode(opsId,"AN_ANS_034","ANIGeneralInduce")
			set sjmcc3=##class(CIS.AN.BL.OperData).GetOperDataByCode(opsId,"AN_ANS_033","ANIGeneralInduce")
			set sjmcc4=##class(CIS.AN.BL.OperData).GetOperDataByCode(opsId,"AN_ANS_017","ANIGeneralInduceType")
			set sjmcc5=##class(CIS.AN.BL.OperData).GetOperDataByCode(opsId,"AN_ANS_034","ANIGeneralInduceType")
			set sjmcc6=##class(CIS.AN.BL.OperData).GetOperDataByCode(opsId,"AN_ANS_033","ANIGeneralInduceType")
			set SjmccScore=0
			if (((sjmcc1'="")&&(sjmcc1'="/"))||((sjmcc2'="")&&(sjmcc2'="/"))||((sjmcc3'="")&&(sjmcc3'="/"))||((sjmcc4'="")&&(sjmcc4'="/"))||((sjmcc5'="")&&(sjmcc5'="/"))||((sjmcc6'="")&&(sjmcc6'="/")))
			{	
				set SjmccScore=1
			}
			
			set count=0
			set count=$fn(methodScoreTotal+TimeScore+SjmccScore,"",2)
			
			if AnesthesiologistCode'=""  d
			.i XMName'="" d
			..i XMName=AnesthesiologistDesc d
			...s ^tempANADocWorkCount("App",$j,AnesthesiologistCode,opsId)=$lb(AnesthesiologistCode,AnesthesiologistDesc,opsId,$zt(opsttime,1),$zt(opendtime,1),$zt(opTime,1),AnaMethodStr,methodScoreTotal,TimeScore,SjmccScore,count,MedcareNo)
			...s ^tempANADocWorkCountAll(AnesthesiologistCode,opsId)=AnesthesiologistDesc_"^"_methodScoreTotal_"^"_TimeScore_"^"_SjmccScore
			.e  d
			..s ^tempANADocWorkCount("App",$j,AnesthesiologistCode,opsId)=$lb(AnesthesiologistCode,AnesthesiologistDesc,opsId,$zt(opsttime,1),$zt(opendtime,1),$zt(opTime,1),AnaMethodStr,methodScoreTotal,TimeScore,SjmccScore,count,MedcareNo)
			..s ^tempANADocWorkCountAll(AnesthesiologistCode,opsId)=AnesthesiologistDesc_"^"_methodScoreTotal_"^"_TimeScore_"^"_SjmccScore
			
			;if AnesthesiologistCode'="" s ^tempANADocWorkCount("App",$j,AnesthesiologistCode,opsId)=$lb(AnesthesiologistCode,AnesthesiologistDesc,opsId,$zt(opsttime,1),$zt(opendtime,1),$zt(opTime,1),AnaMethodStr,methodScoreTotal,TimeScore,SjmccScore,count,MedcareNo)
	 		;if AnesthesiologistCode'="" s ^tempANADocWorkCountAll(AnesthesiologistCode,opsId)=AnesthesiologistDesc_"^"_methodScoreTotal_"^"_TimeScore_"^"_SjmccScore
	 		
			if AnaExpertCode'=""  d
			.i XMName'="" d
			..i XMName=AnaExpertDesc d
			...s ^tempANADocWorkCount("App",$j,AnaExpertCode,opsId)=$lb(AnaExpertCode,AnaExpertDesc,opsId,$zt(opsttime,1),$zt(opendtime,1),$zt(opTime,1),AnaMethodStr,methodScoreTotal,TimeScore,SjmccScore,count,MedcareNo)
			...s ^tempANADocWorkCountAll(AnaExpertCode,opsId)=AnaExpertDesc_"^"_methodScoreTotal_"^"_TimeScore_"^"_SjmccScore
			.e  d
			..s ^tempANADocWorkCount("App",$j,AnaExpertCode,opsId)=$lb(AnaExpertCode,AnaExpertDesc,opsId,$zt(opsttime,1),$zt(opendtime,1),$zt(opTime,1),AnaMethodStr,methodScoreTotal,TimeScore,SjmccScore,count,MedcareNo)
			..s ^tempANADocWorkCountAll(AnaExpertCode,opsId)=AnaExpertDesc_"^"_methodScoreTotal_"^"_TimeScore_"^"_SjmccScore
			
	 		;if AnaExpertCode'="" s ^tempANADocWorkCount("App",$j,AnaExpertCode,opsId)=$lb(AnaExpertCode,AnaExpertDesc,opsId,$zt(opsttime,1),$zt(opendtime,1),$zt(opTime,1),AnaMethodStr,methodScoreTotal,TimeScore,SjmccScore,count,MedcareNo)
	 		;if AnaExpertCode'="" s ^tempANADocWorkCountAll(AnaExpertCode,opsId)=AnaExpertDesc_"^"_methodScoreTotal_"^"_TimeScore_"^"_SjmccScore
	 	}
 	}  //end date
 	
 	set NurCode=""
 	for
	 		{	
	 			
	 			set NurCode=$o(^tempANADocWorkCount("App",$j,NurCode))
	 			q:NurCode=""
	 			set opsId=""
	 			for
	 			{	
	 				
	 				set opsId=$o(^tempANADocWorkCount("App",$j,NurCode,opsId))
	 				q:opsId=""
	 				do OutRowAnaOperNum(^tempANADocWorkCount("App",$j,NurCode,opsId))
	 			}
	 			
	 		}
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutRowAnaOperNum(test)
	//set Data=$lb(opsId,OperStartDT,OperFinishDT,opTimeScore,midNightScore,OperDesc,TSScore,ASAClassDesc,ageScore,NoScNurScore,ScrubNurse,scNurCode,scNurName)
 	set Data=test
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod AnaOperNumFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = AnaOperNumExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod AnaOperNumClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = AnaOperNumExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

Storage Default
{
<Data name="QueryTotalDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.BL.QueryTotalD</DataLocation>
<DefaultData>QueryTotalDefaultData</DefaultData>
<IdLocation>^CIS.AN.BL.QueryTotalD</IdLocation>
<IndexLocation>^CIS.AN.BL.QueryTotalI</IndexLocation>
<StreamLocation>^CIS.AN.BL.QueryTotalS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
