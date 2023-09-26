/// 重症质控指标统计
Class web.DHCICUQualityControlStatistic Extends %RegisteredObject
{

/// d ##class(%ResultSet).RunQuery("web.DHCICUQualityControlStatistic","FindICUQualityControlStat","2020-11-10","2022-11-11","210","4636")
Query FindICUQualityControlStat(startDate As %String, endDate As %String, locIdStr As %String, userId As %String, version As %String = "") As %Query(ROWSPEC = "SeqNo,Title,Count,CountCode,Total,TotalCode,Rate")
{
}

ClassMethod FindICUQualityControlStatExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, locIdStr As %String, userId As %String, version As %String = "") As %Status
{
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	
	set inquiryStDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	set inquiryEndDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
	
	if ((userId="")||(locIdStr="")||(inquiryStDate>inquiryEndDate))
	{
		s qHandle=$lb(0,repid,0)
		q $$$OK
	}
	
	set wardIdStr=##class(web.DHCICUQualityControlStatistic).GetWardIdStrByLocIdStr(locIdStr)
	
	set deathProbabilitySum=0, InvasiveVentilatorDaysSum=0, CVDaysSum=0, UrinaryTubeDaysSum=0
	kill ^tmpFindICUQualityControlStat(userId)
	for date=inquiryStDate:1:inquiryEndDate
	{
		set icuaId="" 
		for 
		{
			set icuaId=$order(^DHCICUOrder(0,"SttDateTime",date,icuaId))
			quit:(icuaId="")
			
			set inDateTime=##class(web.DHCICUCom).GetWardInDateTime("",icuaId,"","","^","D")
			continue:(inDateTime="")
			
			set inDate=$p(inDateTime,"^"),inTime=$p(inDateTime,"^",2)
			set inDateH=##class(web.DHCClinicCom).ConvertToDateH(inDate),inTimeH=##class(web.DHCClinicCom).ConvertToDateH(inTime)
			
			set outDateTime=##class(web.DHCICUCom).GetWardOutDateTime("",icuaId,"","","^","D")
			set outDate=$p(outDateTime,"^",1),outTime=$p(outDateTime,"^",2)
			
			set icuBedId=$p($g(^DHCICUArrange(+icuaId)),"^",4)
			continue:(icuBedId="")
			continue:(wardIdStr'="")&(("^"_wardIdStr_"^")'[("^"_(+icuBedId)_"^"))
			
			continue:$d(^tmpFindICUQualityControlStat(userId,"icuaCount",icuaId))
			set ^tmpFindICUQualityControlStat(userId,"icuaCount",icuaId)=""
			
			
			//入科24小时ApacheII评分
			set stDate=inDateH,stTime=inTimeH,eDate=inDateH+1,eTime=inTimeH
			set apacheTotalScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,"ApacheTotalScore",stDate,stTime,eDate,eTime,"First")
			set note="ApacheII分数:"_apacheTotalScore
			if (+apacheTotalScore>=15) 
			{
				set ^tmpFindICUQualityControlStat(userId,"ApacheIIScoreMoreThan15",icuaId)=note
			}
			if ((+apacheTotalScore<10)&&(+apacheTotalScore>0)) 
			{
				set ^tmpFindICUQualityControlStat(userId,"ApacheIIScoreLessThan10",icuaId)=note
			}
			if ((+apacheTotalScore<15)&&(+apacheTotalScore>=10)) 
			{
				set ^tmpFindICUQualityControlStat(userId,"ApacheIIScoreBetween10To15",icuaId)=note
			}
			if ((+apacheTotalScore<20)&&(+apacheTotalScore>=15)) 
			{
				set ^tmpFindICUQualityControlStat(userId,"ApacheIIScoreBetween15To20",icuaId)=note
			}
			if ((+apacheTotalScore<25)&&(+apacheTotalScore>=20)) 
			{
				set ^tmpFindICUQualityControlStat(userId,"ApacheIIScoreBetween20To25",icuaId)=note
			}
			if (+apacheTotalScore>=25) 
			{
				set ^tmpFindICUQualityControlStat(userId,"ApacheIIScoreGreaterThan25",icuaId)=note
			}
			
			;;感染性休克，取自基线资料
			if (##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"ICUAShockType")="是")
			{
				set ^tmpFindICUQualityControlStat(userId,"SepticShock",icuaId)="感染性休克"
			
			
				//感染性休克3h集束化治疗（bundle）完成率
				set stDate=inDateH,stTime=inTimeH
				set dateTimeStr=##class(web.DHCClinicCom).DateTimeAdd(stDate,stTime,3*3600)
				set eDate=$piece(dateTimeStr,"^",1),eTime=$piece(dateTimeStr,"^",2)
				;;1.Lac最大值
				set MaxLac=##class(web.DHCICUOrder).GetRecordValue(icuaId,"Lac",stDate,stTime,eDate,eTime,"Max") 
				;if (+MaxLac=0) set MaxLac=##class(web.DHCICUQualityControlStatistic).GetLabValue(icuaId,"LAC",stDate,stTime,eDate,eTime,"First")
				;;2.有血培养医嘱
				set IfHasBloodCultureOeOrd=##class(web.DHCICUQualityControlStatistic).GetOEOrderValue(icuaId,"5139||1",stDate,stTime,eDate,eTime,"YesNo")
				;;3.抗菌药物
				set IfUseAntibiotics=##class(web.DHCICUQualityControlStatistic).JudgeIfUseAntibiotics(icuaId,stDate,stTime,eDate,eTime)
				;;4.有创平均压最小值
				set MinAMAP=##class(web.DHCICUOrder).GetRecordValue(icuaId,"AMAP",stDate,stTime,eDate,eTime,"Min")
				;;5.是否应用晶体液：乳酸林格、复方氯化钠、0.9%氯化钠、万汶、贺斯等
				set IfUseCrystalLiquid=##class(web.DHCICUQualityControlStatistic).GetOEOrderValue(icuaId,"1804||1^1803||1^1633||1",stDate,stTime,eDate,eTime,"YesNo")
				set If3hBundle=0
				set flag1=(+MaxLac>0)
				set flag2=(IfHasBloodCultureOeOrd="Y")
				set flag3=(IfUseAntibiotics="Y")
				set flag4=(+MinAMAP>=65)&&(+MaxLac>0)&&(+MaxLac<4)
				set flag5=(+MinAMAP<65)&&(+MinAMAP>0)&&(+MaxLac>=4)&&(IfUseCrystalLiquid="Y")
				if (flag1&&flag2&&flag3&&(flag4||flag5)) 
				{
					set If3hBundle=1
					set ^tmpFindICUQualityControlStat(userId,"SepticShock3hBundle",icuaId)=""
				}
				
				
				//感染性休克6h集束化治疗（bundle）完成率
				set dateTimeStr4h=##class(web.DHCClinicCom).DateTimeAdd(stDate,stTime,4*3600) ;4小时
				set stDate4h=$piece(dateTimeStr4h,"^",1),stTime4h=$piece(dateTimeStr4h,"^",2)
				set dateTimeStr6h=##class(web.DHCClinicCom).DateTimeAdd(stDate,stTime,6*3600) ;6小时
				set eDate6h=$piece(dateTimeStr6h,"^",1),eTime6h=$piece(dateTimeStr6h,"^",2)
				set ifHasSepsis=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"ICUASepsis")
				;;3小时内低血压MAP<65
				set minMAP=##class(web.DHCICUOrder).GetRecordValue(icuaId,"MAP",stDate,stTime,eDate,eTime,"Min")
				;;4-6小时使用升压药
				set IfUseVasopressor=##class(web.DHCICUQualityControlStatistic).GetOEOrderValue(icuaId,"1306||1^1215||1",stDate4h,stTime4h,eDate6h,eTime6h,"YesNo")
				;;0-6小时内低血压(MAP<65)
				set minMAP2=##class(web.DHCICUOrder).GetRecordValue(icuaId,"MAP",stDate,stTime,eDate6h,eTime6h,"Min")
				;;0-6小时须测CVP和ScvO2
				set FirstCVP=##class(web.DHCICUOrder).GetRecordValue(icuaId,"CVP",stDate,stTime,eDate6h,eTime6h,"First") 
				set FirstScvO2=##class(web.DHCICUOrder).GetRecordValue(icuaId,"ScvO2",stDate,stTime,eDate6h,eTime6h,"First") 
				set flag6=(ifHasSepsis="是")||((+minMAP>0)&&(+minMAP<65)&&(IfUseVasopressor="Y"))
				set flag7=(+minMAP2>0)&&(+minMAP2<65)&&(FirstCVP'="")&&(FirstScvO2'="")
				if (If3hBundle||flag6||flag7) 
				{
					set ^tmpFindICUQualityControlStat(userId,"SepticShock6hBundle",icuaId)=""
				}
			}

			//ICU抗菌药物治疗前病原学送检率
			set stDate=inDateH, stTime=inTimeH, eDate=outDate, eTime=outTime
			if ((outDate="")||(outTime="")) set eDate=+$h, eTime=$p($h,",",2)
			;首次获取使用抗菌药物的时间
			set AntibioticsDT=##class(web.DHCICUQualityControlStatistic).JudgeIfUseAntibiotics(icuaId,stDate,stTime,eDate,eTime,"AntibioticsDT")
			set AntibioticsDate=$p(AntibioticsDT,"^",1), AntibioticsTime=$p(AntibioticsDT,"^",2)
			if (AntibioticsDate'="")&&(AntibioticsTime'="")
			{
				set ^tmpFindICUQualityControlStat(userId,"Antibiotics",icuaId)=""
				;病原学检验标本送检包括：微生物培养, 真菌细菌培养, 降钙素原, PCT, 白介素-6，白细胞介素-6检测等
				set specimenTestArcimIdStr="6154||1^5144||1^5145||1^5146||1^5147||1^5148||1^5149||1^5150||1^5151||1^5152||1^5153||1^5154||1^5155||1^5156||1^5157||1^5158||1^5159||1^5160||1^5161||1^5162||1^5105||1"
				set IfHasSpecimenTest=##class(web.DHCICUQualityControlStatistic).GetOEOrderValue(icuaId,specimenTestArcimIdStr,stDate,stTime,AntibioticsDate,AntibioticsTime,"YesNo")
				if (IfHasSpecimenTest="Y") 
				{
					set ^tmpFindICUQualityControlStat(userId,"AntibioticsSpecimenTest",icuaId)=""
				}
			}
			
			
			//ICU深静脉血栓（DVT）预防率
			set stDate=inDateH, stTime=inTimeH, eDate=outDate, eTime=outTime
			if ((outDate="")||(outTime="")) set eDate=+$h, eTime=$p($h,",",2)
			;肝素或低分子肝素抗凝，取医嘱项
			set heparinArcimIdStr="1231||1^1251||1^1311||1^1313||1^1368||1^1370||1^1446||1^1447||1"
			set IfHasHeparin=##class(web.DHCICUQualityControlStatistic).GetOEOrderValue(icuaId,heparinArcimIdStr,stDate,stTime,eDate,eTime,"YesNo")
			;机械预防(肢体加压泵、梯度压力弹力袜等)以及下腔静脉滤器，取医嘱项
			set mechanicalPreventionArcimId="10139||1^2901||1^3649||1"
			set IfHasMechanicalPrevention=##class(web.DHCICUQualityControlStatistic).GetOEOrderValue(icuaId,mechanicalPreventionArcimId,stDate,stTime,eDate,eTime,"YesNo")
			;重症护理II的DVT预防措施
			set DVTRecordItemIdStr="6622^6702^6757^6758^6759"
			set IfHasDVTRecordItem=##class(web.DHCICUQualityControlStatistic).JudgeIfHasRecordItem(icuaId,DVTRecordItemIdStr,stDate,stTime,eDate,eTime)
			if ((IfHasHeparin="Y")||(IfHasMechanicalPrevention="Y")||(IfHasDVTRecordItem="Y")) 
			{
				set ^tmpFindICUQualityControlStat(userId,"DVTPrevention",icuaId)=""
			}
			
			
			//ICU收治患者预计病死率，取自基线资料
			set DeathProbability=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"ICUADeathProbability")
			if (+DeathProbability>0)
			{
				set DeathProbability=$fn(+DeathProbability,"",4)
				set ^tmpFindICUQualityControlStat(userId,"DeathProbability",icuaId)="预计死亡率: "_DeathProbability
				set deathProbabilitySum=deathProbabilitySum+DeathProbability
			}


			//ICU患者标化病死指数,根据病人转归状态判断病人是否死亡
			set leaveCondition=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"ICUALeaveCondition")
			if leaveCondition="死亡"
			{
				set ^tmpFindICUQualityControlStat(userId,"StandardizedDeath",icuaId)="转归状态: "_leaveCondition
			}
			
			
			//ICU非计划气管插管拔管率 && ICU气管插管拔管后48h内再插管率
			set stDate=inDateH, stTime=inTimeH, eDate=outDate, eTime=outTime
			if ((outDate="")||(outTime="")) set eDate=+$h, eTime=$p($h,",",2)
			set TracheaCannula=##class(web.DHCICUOrder).GetRecordValue(icuaId,"TracheaCannula",stDate,stTime,eDate,eTime,"First") 
			if TracheaCannula'=""
			{
				;插管日期
				set IntubationDate=##class(web.DHCICUOrder).GetRecordValue(icuaId,"IntubationDate",stDate,stTime,eDate,eTime,"First") 
				;拔管日期
				set ExtubationDate=##class(web.DHCICUOrder).GetRecordValue(icuaId,"bgri",stDate,stTime,eDate,eTime,"First") 
				;拔管原因
				set ExtubationReason=##class(web.DHCICUOrder).GetRecordValue(icuaId,"bgyy",stDate,stTime,eDate,eTime,"First") 
				;插管次数
				set AllIntubationTimes=##class(web.DHCICUOrder).GetRecordValue(icuaId,"IntubationDate",stDate,stTime,eDate,eTime,"Times") 
				set note="插管日期:"_IntubationDate_",拔管日期:"_ExtubationDate_",拔管原因:"_ExtubationReason
				if (IntubationDate'="")&&(ExtubationDate'="")
				{
					set ^tmpFindICUQualityControlStat(userId,"TracheaCannula",icuaId)=note
					if (ExtubationReason="意外脱出") set ^tmpFindICUQualityControlStat(userId,"NonePlanTracheaCannula",icuaId)=note
					
					
					;;气管插管拔管后48h内再插管
					set ReInTubeDuration=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"ReInTube")
					if ((+ReInTubeDuration>0)&&(+ReInTubeDuration<2))
					{
						set ^tmpFindICUQualityControlStat(userId,"TracheaCannula48hReIntubation",icuaId)=note_",插管次数:"_AllIntubationTimes
					}
				}
			}
			
			
			//非计划转入ICU率
			set SourceType=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"ICUASourceType")
			if ((SourceType="急诊内科")||(SourceType="急诊手术"))
			{
				set ^tmpFindICUQualityControlStat(userId,"NonePlanTransferICU",icuaId)="收治类型:"_SourceType
			}
			
			
			//转出ICU后48h内重返率??
			set TranferOutAndReturnIn48=$$Judge48hReturnICU(icuaId)
			if (TranferOutAndReturnIn48)
			{
				set ^tmpFindICUQualityControlStat(userId,"TranferOutAndReturnIn48h",icuaId)=note
			}
			
			
			//ICU呼吸机相关性肺炎（VAP）发病率
			set stDate=inDateH, stTime=inTimeH, eDate=outDate, eTime=outTime
			if ((outDate="")||(outTime="")) set eDate=+$h, eTime=$p($h,",",2)
			;;病人有创呼吸天数
			set InvasiveVentilatorDays=##class(web.DHCICUQualityControlStatistic).GetVentilatorDays(icuaId,stDate,stTime,eDate,eTime,"InvasiveVentilatorDays")
			if (InvasiveVentilatorDays>0)
			{
				set InvasiveVentilatorDaysSum=InvasiveVentilatorDaysSum+InvasiveVentilatorDays
				set note="有创呼吸天数:"_InvasiveVentilatorDaysSum
				set ^tmpFindICUQualityControlStat(userId,"InvasiveVentilatorDays",icuaId)=note
			}
			;;VAP发生例数, 判断是否置入气管？？
			set VAP=##class(web.DHCICUOrder).GetRecordValue(icuaId,"TracheaCannula",stDate,stTime,eDate,eTime,"First")
			if (VAP'="")
			{
				set ^tmpFindICUQualityControlStat(userId,"VAP",icuaId)=""
			}
			
			
			//ICU血管内导管相关血流感染（CRBSI）发病率，判断是否有中心静脉置管(PICC)?
			set stDate=inDateH, stTime=inTimeH, eDate=outDate, eTime=outTime
			if ((outDate="")||(outTime="")) set eDate=+$h, eTime=$p($h,",",2)
			set IfHasCRBSI=##class(web.DHCICUQualityControlStatistic).JudgeIfHasRecordItem(icuaId,"zcgy^ycgy^zctjm^yctjm^zzzz^yzzz^picchy",stDate,stTime,eDate,eTime)
			if (IfHasCRBSI="Y")
			{
				set ^tmpFindICUQualityControlStat(userId,"CRBSI",icuaId)=""
				
				//中心静脉置管天数
				set CVTubeDate=##class(web.DHCICUOrder).GetRecordValue(icuaId,"CVTubeDate",stDate,stTime,eDate,eTime,"First")   ;置管日期
				set CVTubeDrawDate=##class(web.DHCICUOrder).GetRecordValue(icuaId,"CVTubeDrawDate",stDate,stTime,eDate,eTime,"First")  ;拔管日期
				if (CVTubeDate'="")
				{
					if CVTubeDrawDate="" set CVTubeDrawDate=outDate
					set CVTubeStartDateH=##class(DHCClinicCom).ConvertToDateH($p(CVTubeDate," ",1))
					set CVTubeEndDateH=##class(DHCClinicCom).ConvertToDateH($p(CVTubeDrawDate," ",1))
					set CVDays=CVTubeEndDateH-CVTubeStartDateH
					set CVDaysSum=CVDaysSum+CVDays
					set ^tmpFindICUQualityControlStat(userId,"CVDays",icuaId)="中心静脉置管天数:"_CVDays_"天"
				}
			}
			
			
			//ICU导尿管相关泌尿系感染（CAUTI）发病率，判断是否有尿管?
			set stDate=inDateH, stTime=inTimeH, eDate=outDate, eTime=outTime
			if ((outDate="")||(outTime="")) set eDate=+$h, eTime=$p($h,",",2)
			set IfHasCAUTI=##class(web.DHCICUQualityControlStatistic).JudgeIfHasRecordItem(icuaId,"NGDNG^NGDNGqqq",stDate,stTime,eDate,eTime)
			if (IfHasCAUTI="Y")
			{
				set ^tmpFindICUQualityControlStat(userId,"CAUTI",icuaId)=""
				
				//尿管置管天数
				set UrinaryTubeDate=##class(web.DHCICUOrder).GetRecordValue(icuaId,"CgDate",stDate,stTime,eDate,eTime,"First")         ;插管日期
				set UrinaryTubeDrawDate=##class(web.DHCICUOrder).GetRecordValue(icuaId,"BgDate",stDate,stTime,eDate,eTime,"First")         ;拔管日期
				if (UrinaryTubeDate'="")
				{
					if UrinaryTubeDrawDate="" set UrinaryTubeDrawDate=outDate
					set UrinaryTubeDateH=##class(DHCClinicCom).ConvertToDateH($p(UrinaryTubeDate," ",1))
					set UrinaryTubeDrawDateH=##class(DHCClinicCom).ConvertToDateH($p(UrinaryTubeDrawDate," ",1))
					set UrinaryTubeDays=UrinaryTubeDrawDateH-UrinaryTubeDateH
					set UrinaryTubeDaysSum=UrinaryTubeDaysSum+UrinaryTubeDays
					set ^tmpFindICUQualityControlStat(userId,"UrinaryTubeDays",icuaId)="尿管置管天数:"_UrinaryTubeDays_"天"
				}
			}
		}
	}
	
	set SeqNo=0
	set icuaCount=$$CountIcuaId("icuaCount")
	do OutputPercent("ICU患者收治率和ICU患者收治床日率","","","","")
	do OutputPercent("&emsp;&emsp; ICU患者收治率",icuaCount,"icuaCount",$$CountHospitalAdm(),"")
	do OutputPercent("&emsp;&emsp; ICU患者收治床日率",icuaCount,"icuaCount",$$CountHospitalAdmBed(),"")
	
	do OutputPercent("急性生理与慢性健康评分(APACHEⅡ评分)≥15分患者收治率(入ICU24小时内)",$$CountIcuaId("ApacheIIScoreMoreThan15"),"ApacheIIScoreMoreThan15",icuaCount,"icuaCount")
	do OutputPercent("&emsp;&emsp; ApacheII评分&lt;10分",$$CountIcuaId("ApacheIIScoreLessThan10"),"ApacheIIScoreLessThan10",icuaCount,"icuaCount")
	do OutputPercent("&emsp;&emsp; ApacheII评分≥10分且&lt;15分",$$CountIcuaId("ApacheIIScoreLessThan10"),"ApacheIIScoreLessThan10",icuaCount,"icuaCount")
	do OutputPercent("&emsp;&emsp; ApacheII评分≥15分且&lt;20分",$$CountIcuaId("ApacheIIScoreBetween15To20"),"ApacheIIScoreBetween15To20",icuaCount,"icuaCount")
	do OutputPercent("&emsp;&emsp; ApacheII评分≥20分且&lt;25分",$$CountIcuaId("ApacheIIScoreBetween20To25"),"ApacheIIScoreBetween20To25",icuaCount,"icuaCount")
	do OutputPercent("&emsp;&emsp; ApacheII评分≥25分",$$CountIcuaId("ApacheIIScoreGreaterThan25"),"ApacheIIScoreGreaterThan25",icuaCount,"icuaCount")
	
	do OutputPercent("感染性休克3h集束化治疗（bundle）完成率",$$CountIcuaId("SepticShock3hBundle"),"SepticShock3hBundle",$$CountIcuaId("SepticShock"),"SepticShock")
	do OutputPercent("感染性休克6h集束化治疗（bundle）完成率",$$CountIcuaId("SepticShock6hBundle"),"SepticShock6hBundle",$$CountIcuaId("SepticShock"),"SepticShock")
	
	do OutputPercent("ICU抗菌药物治疗前病原学送检率",$$CountIcuaId("AntibioticsSpecimenTest"),"AntibioticsSpecimenTest",$$CountIcuaId("Antibiotics"),"Antibiotics")
	do OutputPercent("ICU深静脉血栓（DVT）预防率",$$CountIcuaId("DVTPrevention"),"DVTPrevention",icuaCount,"icuaCount")
	
	do OutputPercent("ICU患者预计病死率",deathProbabilitySum,"DeathProbability",icuaCount,"icuaCount")
	do OutputPercent("ICU患者标化病死指数",$$CountIcuaId("StandardizedDeath"),"StandardizedDeath",icuaCount,"icuaCount")

	do OutputPercent("ICU非计划气管插管拔管率",$$CountIcuaId("NonePlanTracheaCannula"),"NonePlanTracheaCannula",$$CountIcuaId("TracheaCannula"),"TracheaCannula")
	do OutputPercent("ICU气管插管拔管后48h内再插管率",$$CountIcuaId("TracheaCannula48hReIntubation"),"TracheaCannula48hReIntubation",$$CountIcuaId("TracheaCannula"),"TracheaCannula")

	do OutputPercent("非计划转入ICU率",$$CountIcuaId("NonePlanTransferICU"),"NonePlanTransferICU",icuaCount,"icuaCount")
	do OutputPercent("转出ICU后48h内重返率",$$CountIcuaId("TranferOutAndReturnIn48h"),"TranferOutAndReturnIn48h",icuaCount,"icuaCount")
	
	do OutputThousandth("ICU呼吸机相关性肺炎（VAP）发病率",$$CountIcuaId("VAP"),"VAP",InvasiveVentilatorDaysSum,"InvasiveVentilatorDays")
	do OutputThousandth("ICU血管内导管相关血流感染（CRBSI）发病率",$$CountIcuaId("CRBSI"),"CRBSI",CVDaysSum,"CVDays")
	do OutputThousandth("ICU导尿管相关泌尿系感染（CAUTI）发病率",$$CountIcuaId("CAUTI"),"CAUTI",UrinaryTubeDaysSum,"UrinaryTubeDays")
	
	s qHandle=$lb(0,repid,0)
	q $$$OK
	
CountHospitalAdm()
	set count=0
	;set count=$$GetRYRS^DHCWLBuildKPIData(startDate,endDate) 
	quit count ;HIS提供数据接口??
	
CountHospitalAdmBed()
	;HIS提供数据接口??
	set count=##class(web.DHCICUStat).GetMRIPData(startDate,endDate)
	quit count
	
Judge48hReturnICU(icuaid)
	set result="Y"
	s inDateTime=##class(web.DHCICUCom).GetWardInDateTime("",icuaid,"","","^","D")
    s outDateTime=##class(web.DHCICUCom).GetWardOutDateTime("",icuaid,"","","^","D")
    s WardinDate=$p(inDateTime,"^",1),WardinTime=$p(inDateTime,"^",2)
	s WardoutDate=$p(outDateTime,"^",1),WardoutTime=$p(outDateTime,"^",2)
	s icuBedId=$p($g(^DHCICUArrange(icuaid)),"^",4)
	s wardLocId=$p(^PAWARD(+icuBedId),"^",5)
	s EpisodeID=$p(^DHCICUArrange(icuaid),"^",1)
	s icuaId2=""
	f  s icuaId2=$o(^DHCICUArrange(0,"Adm",EpisodeID,icuaId2),-1) q:icuaId2=""  d
    .q:'$d(^DHCICUArrange(icuaId2))
    .q:icuaId2=icuaid
    q:icuaId2="" result
	s inDateTime2=##class(web.DHCICUCom).GetWardInDateTime("",icuaid2,"","","^","D")
    s outDateTime2=##class(web.DHCICUCom).GetWardOutDateTime("",icuaid2,"","","^","D")
    s WardinDate2=$p(inDateTime2,"^",1),WardinTime2=$p(inDateTime2,"^",2)
	s WardoutDate2=$p(outDateTime2,"^",1),WardoutTime2=	$p(outDateTime2,"^",2)
	s icuBedId2=$p($g(^DHCICUArrange(icuaid2)),"^",4)
	s wardLocId2=$p(^PAWARD(+icuBedId2),"^",5)
    i WardoutDate<WardinDate2 s icuHour=(WardinTime2-WardoutTime)\3600+((WardinDate2-WardoutDate)*24)
    i icuHour<=48  set result="Y"
    quit result
	
CountIcuaId(statCode)
	quit:'$d(^tmpFindICUQualityControlStat(userId)) 0
	quit:'$d(^tmpFindICUQualityControlStat(userId,statCode)) 0
	set count=0
	set id="" for  set id=$o(^tmpFindICUQualityControlStat(userId,statCode,id)) q:id=""  d
	.set count=count+1
	quit count

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

ClassMethod FindICUQualityControlStatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindICUQualityControlStatExecute ]
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

ClassMethod FindICUQualityControlStatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindICUQualityControlStatExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCICUQualityControlStatistic","FindICUStatPatInfo","4636","AllPatientCount")
Query FindICUStatPatInfo(userId As %String, statCode As %String) As %Query(ROWSPEC = "icuaId,patName,patSex,patAge,icuInDateTime,icuOutDateTime,wardDesc,icuBed,ResidentDoctor,ICUGuardDay,icuDiag,papmiMedicare,admNo,ICUALeaveCondition,note")
{
}

ClassMethod FindICUStatPatInfoExecute(ByRef qHandle As %Binary, userId As %String, statCode As %String) As %Status
{
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1

	if ((userId="")||(statCode=""))
	{
		s qHandle=$lb(0,repid,0)
		q $$$OK
	}
	
	set icuaId="" for  set icuaId=$o(^tmpFindICUQualityControlStat(userId,statCode,icuaId)) q:icuaId=""  d
	.do OutputStatInfo

	s qHandle=$lb(0,repid,0)
	q $$$OK
	
OutputStatInfo
	set patName=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"patName")
	set patSex=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"patSex")
	set patAge=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"patAge")
	set icuInDateTime=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"icuInDateTime")
	set icuOutDateTime=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"icuOutDateTime")
	set wardDesc=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"wardDesc")
	set icuBed=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"icuBed")
	set wardDiag=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"wardDiag")
	set ResidentDoctor=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"ResidentDoctor")
	set ICUGuardDay=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"ICUGuardDay")
	set icuDiag=$$GetMRDesc(icuaId) ;##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"MainDiag")
	set papmiMedicare=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"papmiMedicare")
	set admNo=$p($g(^DHCICUArrange(+icuaId)),"^",1)
	set ICUALeaveCondition=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"ICUALeaveCondition")
	set note=$g(^tmpFindICUQualityControlStat(userId,statCode,icuaId))	
	
	do OutputRow
	quit
	

GetMRDesc(icuaId)
	s EpisodeID=$p($g(^DHCICUArrange(+icuaId)),"^",1)
	s mradmId=$P(^PAADM(EpisodeID),"^",61)
	s icuaRelatedDiagDr=$p(^DHCICUArrange(+icuaId),"^",20)
	s mrdiaSub=0,mrcidDesc=""
	f  s mrdiaSub=$O(^MR(mradmId,"DIA",mrdiaSub)) q:(mrdiaSub="")  d
		.s mrcidId=$p(^MR(mradmId,"DIA",mrdiaSub),"^")
		.i mrcidId'="" s curMrcidDesc=$p($g(^MRC("ID",+mrcidId)),"^",2)
		.e  s curMrcidDesc=$g(^MR(mradmId,"DIA",mrdiaSub,"DES",1))
		.q:curMrcidDesc=""
		.s mrcidDesc=$tr(mrcidDesc,$c(13))
		.s mrcidDesc=$tr(mrcidDesc,$c(10))
		.i mrcidDesc'="" s mrcidDesc=mrcidDesc_","
		.s mrcidDesc=mrcidDesc_curMrcidDesc
	quit mrcidDesc
	
OutputRow
	s Data=$lb(icuaId,patName,patSex,patAge,icuInDateTime,icuOutDateTime,wardDesc,icuBed,ResidentDoctor,ICUGuardDay,icuDiag,papmiMedicare,admNo,ICUALeaveCondition,note)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod FindICUStatPatInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindICUStatPatInfoExecute ]
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

ClassMethod FindICUStatPatInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindICUStatPatInfoExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

/// 查询ICU科室
/// d ##class(%ResultSet).RunQuery("web.DHCICUQualityControlStatistic","FindICULoc") 
Query FindICULoc() As %Query(ROWSPEC = "DeptID,DeptName")
{
}

ClassMethod FindICULocExecute(ByRef qHandle As %Binary) As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 
  	s locId=""
 	f  s locId=$o(^DHCICUPara(0,"Ctloc",locId)) q:locId=""  d
	    .s tIcuParaId=$o(^DHCICUPara(0,"Ctloc",locId,""))
	    .q:'$d(^DHCICUPara(tIcuParaId))
	    .s tDeptID=$p(^DHCICUPara(tIcuParaId),"^",2)
	    .q:tDeptID=""
	    .s tDeptName=$p($g(^CTLOC(+tDeptID)),"^",2)
	    .d OutputRow1
	    .s wardLocId=$o(^CTLOC(tDeptID,"LINK",0,"Loc",""))
	    .q:wardLocId=""
	    .s tDeptID=wardLocId
	    .s tDeptName=$p($g(^CTLOC(+tDeptID)),"^",2)
	    .d OutputRow1
	    
	    
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
OutputRow1
	s Data=$lb(tDeptID,tDeptName)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindICULocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindICULocExecute ]
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

ClassMethod FindICULocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindICULocExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// 通过科室Id获取关联病区Id
/// w ##class(web.DHCICUQualityControlStatistic).GetWardIdStrByLocIdStr(47)
ClassMethod GetWardIdStrByLocIdStr(locIdStr As %String) As %String
{
	s wardIdStr=""
	f i=1:1:$l(locIdStr,"^")
	{
		s locId=$p(locIdStr,"^",i)
		q:locId=""
		s wardLocId=""
		i '$d(^DHCICUPara(0,"Ctloc",locId)) s wardLocId=$o(^CTLOC(locId,"LINK",0,"Loc",""))
		e  s wardLocId=locId
		q:wardLocId=""
		s wardId=$o(^PAWARD(0,"WARD_LocationDR",wardLocId,0))
		q:wardId=""
		i wardIdStr'="" s wardIdStr=wardIdStr_"^"
		s wardIdStr=wardIdStr_wardId
	}
	q wardIdStr
}

ClassMethod JudgeIfHasRecordItem(icuaId As %String, recordItemIdStr As %String, fromDate As %String, fromTime As %String, toDate As %String, toTime As %String, type As %String = "") As %String
{
	set ifHasRecordItem="N"
	for i=1:1:$l(recordItemIdStr,"^")
	{
		quit:ifHasRecordItem="Y"
		set recordItemId=$p(recordItemIdStr,"^",i)
		set result=##class(web.DHCICUOrder).GetRecordValue(icuaId,recordItemId,fromDate,fromTime,toDate,toTime,"First")
		if (result'="")
		{
			set ifHasRecordItem="Y"
		}
	}
	
	quit ifHasRecordItem
}

/// 获取下医嘱信息
ClassMethod GetOEOrderValue(icuaId As %String, arcimIdStr As %String, fromDate As %String, fromTime As %String, toDate As %String, toTime As %String, type As %String = "", needNote As %String = "") As %String
{
	set EpisodeID=$p($g(^DHCICUArrange(+icuaId)),"^",1)
	quit:EpisodeID="" ""
	
	s oeordId=$o(^OEORD(0,"Adm",EpisodeID,""))
	q:(oeordId="") ""
	
	set fromDate=##class(web.DHCClinicCom).ConvertToDateH(fromDate)
	set fromTime=##class(web.DHCClinicCom).ConvertToTimeH(fromTime)
	set toDate=##class(web.DHCClinicCom).ConvertToDateH(toDate)
	set toTime=##class(web.DHCClinicCom).ConvertToTimeH(toTime)
	
	set ArcimDescDT=""
	set IfExist="N"
	
	for i=1:1:$l(arcimIdStr,"^") do
	.set arcimId=$p(arcimIdStr,"^",i)
	.quit:arcimId=""
	.set startDate=fromDate-1
	.set oeoriSttDate=startDate for  set oeoriSttDate=$o(^OEORDi(0,"ARCIM",oeordId,arcimId,oeoriSttDate)) q:(oeoriSttDate="")||(oeoriSttDate>toDate)  d
	..set oeoriSub="" for  set oeoriSub=$o(^OEORDi(0,"ARCIM",oeordId,arcimId,oeoriSttDate,oeoriSub)) q:(oeoriSub="")  d
	...quit:'$d(^OEORD(oeordId,"I",oeoriSub))
	...set oeoriId=oeordId_"||"_oeoriSub
	...set ordStatCode=##Class(web.DHCClinicCom).GetOrdStatCode(oeoriId)
	...q:(("D"[ordStatCode))&&("U"[ordStatCode) //状态过滤
	...set oeoriSttDat=$p(^OEORD(oeordId,"I",oeoriSub,1),"^",9) //下医嘱日期
	...set oeoriSttTim=$p(^OEORD(oeordId,"I",oeoriSub,1),"^",10) //下医嘱时间
	...quit:((startDate=oeoriSttDat)&&(fromTime>oeoriSttTim))||((toDate=oeoriSttDat)&&(toTime<oeoriSttTim))
	...set oriNote=$g(^OEORD(oeordId,"I",+oeoriSub,"DEP",1))  //医嘱说明
	...if (needNote'="")&&(oriNote[needNote) set IfExist="Y"
	...set arcimDesc=$p($g(^ARCIM(+arcimId,+$p(arcimId,"||",2),1)),"^",2)
	...set ArcimDescInfo=oeoriId_"#"_arcimDesc_"#"_$zd(oeoriSttDat,3)_" "_$zt(oeoriSttTim,2)					 					
	...if ArcimDescDT="" set ArcimDescDT=ArcimDescInfo
	...else  set ArcimDescDT=ArcimDescDT_"^"_ArcimDescInfo
	
	quit:type="YesNo" IfExist
	
	quit ArcimDescDT
}

/// 判断是否使用抗菌药物，根据医嘱判断
ClassMethod JudgeIfUseAntibiotics(icuaId As %String, fromDate As %String, fromTime As %String, toDate As %String, toTime As %String, type As %String = "") As %String
{
	set EpisodeID=$p($g(^DHCICUArrange(+icuaId)),"^",1)
	quit:EpisodeID="" "N"
	
	s oeordId=$o(^OEORD(0,"Adm",EpisodeID,""))
	q:(oeordId="") "N"
	
	set fromDate=##class(web.DHCClinicCom).ConvertToDateH(fromDate)
	set fromTime=##class(web.DHCClinicCom).ConvertToTimeH(fromTime)
	set toDate=##class(web.DHCClinicCom).ConvertToDateH(toDate)
	set toTime=##class(web.DHCClinicCom).ConvertToTimeH(toTime)
	
	set IfExist="N", AntibioticsDT=""
	
	set isFind=0
	set arcimId="" f  s arcimId=$o(^OEORDi(0,"ARCIM",oeordId,arcimId)) q:(arcimId="")!(isFind)  d
	.set phcPoisonCode=##class(web.DHCClinicCom).GetPHCPoisonCode(arcimId)
	.if ((phcPoisonCode="KSS1")||(phcPoisonCode="KSS2")||(phcPoisonCode="KSS3")) do
	..set startDate=fromDate-1
	..set oeoriSttDate=startDate for  set oeoriSttDate=$o(^OEORDi(0,"ARCIM",oeordId,arcimId,oeoriSttDate)) q:(oeoriSttDate="")||(oeoriSttDate>toDate)  d
	...set oeoriSub="" for  set oeoriSub=$o(^OEORDi(0,"ARCIM",oeordId,arcimId,oeoriSttDate,oeoriSub)) q:(oeoriSub="")  d
	....quit:'$d(^OEORD(oeordId,"I",oeoriSub))
	....set oeoriId=oeordId_"||"_oeoriSub
	....set ordStatCode=##Class(web.DHCClinicCom).GetOrdStatCode(oeoriId)
	....q:(("D"[ordStatCode))&&("U"[ordStatCode) //状态过滤
	....set oeoriSttDat=$p(^OEORD(oeordId,"I",oeoriSub,1),"^",9) //下医嘱日期
	....set oeoriSttTim=$p(^OEORD(oeordId,"I",oeoriSub,1),"^",10) //下医嘱时间
	....quit:((startDate=oeoriSttDat)&&(fromTime>oeoriSttTim))||((toDate=oeoriSttDat)&&(toTime<oeoriSttTim))
	....set isFind=1, IfExist="Y", AntibioticsDT=oeoriSttDat_"^"_oeoriSttTim
	
	quit:type="AntibioticsDT" AntibioticsDT
	
	quit IfExist
}

/// 获取检验信息
ClassMethod GetLabValue(icuaId As %String, standardCode As %String, fromDate As %String, fromTime As %String, toDate As %String, toTime As %String, type As %String = "")
{
	set EpisodeID=$p($g(^DHCICUArrange(+icuaId)),"^",1)
	quit:EpisodeID="" ""
	
	set ifSingle=0
	if type="First" set ifSingle=1
	
	set result=##class(web.DHCClinicCom).GetTestResult(EpisodeID,"","",standardCode,fromDate,fromTime,toDate,toTime,ifSingle)
	
	quit:type="First" $p(result,"\",1)
	quit result
}

/// 获取呼吸机天数
/// w ##class(web.DHCICUQualityControlStatistic).GetVentilatorDays(5,"2021-02-02","00:00","2024-02-02","00:00","InvasiveVentilatorDays")
ClassMethod GetVentilatorDays(icuaId, fromDate, fromTime, toDate, toTime, type = "") As %String
{
	quit:icuaId="" ""
	
	;呼吸模式
	set icucriId=##class(web.DHCICUCom).GetIcuriIdByCode("VentilatorMode")
	
	set fromDate=##class(web.DHCClinicCom).ConvertToDateH(fromDate)
	set fromTime=##class(web.DHCClinicCom).ConvertToTimeH(fromTime)
	set toDate=##class(web.DHCClinicCom).ConvertToDateH(toDate)
	set toTime=##class(web.DHCClinicCom).ConvertToTimeH(toTime)
	
	set VentilatorDays=0				;呼吸机天数
	set InvasiveVentilatorDays=0  		;有创呼吸机天数
	set NoninvasiveVentilatorDays=0  	;无创呼吸机天数
	
	set InvasiveVentMode="SIMV^CPAP^BIPAP^CMV^PS^SIMV+PS"
	
	kill VentilatorDaysStat
	set startDate=fromDate-1
	set date=startDate for  set date=$o(^DHCICUOrder(0,"RecordItem",icucriId,date)) q:(date="")!(date>toDate)  d
	.set time="" for  set time=$o(^DHCICUOrder(0,"RecordItem",icucriId,date,icuaId,time)) q:(time="")  d
	..quit:(date=startDate)&(time<fromTime)
	..quit:(date=toDate)&(time>toTime)
	..set icuoId="" for  set icuoId=$o(^DHCICUOrder(0,"RecordItem",icucriId,date,icuaId,time,icuoId)) q:(icuoId="")  d
	...quit:'$d(^DHCICUOrder(icuoId))
	...quit:"ICD"[$p(^DHCICUOrder(icuoId),"^",25)
	...set Note=$p(^DHCICUOrder(icuoId),"^",10)
	...set Qty=$p(^DHCICUOrder(icuoId),"^",11)
	...set icuaStartDate=$p(^DHCICUOrder(icuoId),"^",5)
	...set icuaStartTime=$p(^DHCICUOrder(icuoId),"^",6)
	...quit:Note=""
	...quit:$d(VentilatorDaysStat(icuaStartDate,Note))
	...set VentilatorDaysStat(icuaStartDate,Note)=""
	...set VentilatorDays=VentilatorDays+1
	...if ("^"_InvasiveVentMode_"^")[("^"_Note_"^") set InvasiveVentilatorDays=InvasiveVentilatorDays+1
	...if Note["无创" set NoninvasiveVentilatorDays=NoninvasiveVentilatorDays+1
	
	
	quit:type="VentilatorDays" VentilatorDays
	quit:type="InvasiveVentilatorDays" InvasiveVentilatorDays
	quit:type="NoninvasiveVentilatorDays" NoninvasiveVentilatorDays
	quit:type="" VentilatorDays_"^"_InvasiveVentilatorDays_"^"_NoninvasiveVentilatorDays
}

}
