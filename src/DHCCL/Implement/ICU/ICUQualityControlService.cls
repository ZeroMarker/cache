/// 重症病人质控指标详细信息
Class DHCCL.Implement.ICU.ICUQualityControlService Extends %RegisteredObject
{

/// d ##class(%ResultSet).RunQuery("DHCCL.Implement.ICU.ICUQualityControlService","FindICUQualityControlDetail",28)
Query FindICUQualityControlDetail(icuaId As %String = "", EpisodeID As %String = "", DischargeDate As %String = "") As %Query(ROWSPEC = "Id,IcuaId,AdmId,PapmiId,PatName,MedcareNo,RegNo,BedCode,Age,Sex,PAAdmReasonDesc,DischDate,HospDesc,CurLocDesc,CurWardDesc,ICUAResidentCtcpDesc,InWardDate,InWardTime,OutWardDate,OutWardTime,ICUALeaveConditionDesc,InWardDays,InWardHours,TransferLocDesc,IfDanger,IfSerious,IfRescue,TransferICUTimes,ReturnICUHours,InvasiveVentilatorDays,NoninvasiveVentilatorDays,VentilatorDays,VentilatorTimes,CVTubuDays,CVTubuTimes,UrinaryTubeDays,UrinaryTubeTimes,IfUseAntibiotics,UseAntibiotics,IfUseAntibioticsPrevent,UseAntibioticsPreventDays,IfUseAntibioticsCure,UseAntibioticsDays,TracheaInOutTubeTimes,ApacheIIScore,AntibioticsSpecimenTest,ApacheIIScoreMoreThan15,SepticShock3hBundle,SepticShock6hBundle,SepticShock,DVTPrevention,DeathProbability,StandardizedDeath,NonePlanTracheaCannula,TracheaCannula48hReIntubation,TracheaCannulaReIntubationDuration,NonePlanTransferICU,TranferOutAndReturnIn48h,TranferOutAndReturnFlag,TranferOutAndReturnDuration,VAP,CRBSI,CAUTI,SepticShock1hBundle") [ SqlProc ]
{
}

ClassMethod FindICUQualityControlDetailExecute(ByRef qHandle As %Binary, icuaId As %String, EpisodeID As %String, DischargeDate As %String) As %Status
{
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1

	if ((icuaId="")&&(EpisodeID="")&&(DischargeDate=""))
	{
		s qHandle=$lb(0,repid,0)
		q $$$OK	
	}
		
	if (icuaId'="")
	{
		do OutputDetail(icuaId)
	}
	elseif (EpisodeID'="")
	{
		do OutputDetailByAdmId(EpisodeID)		
	}
	elseif (DischargeDate'="")
	{
		set date=##class(CIS.AN.COM.DateTime).ConvertToDateH(DischargeDate)
		set admId=""  
		for  
		{
			set admId=$o(^PAADMi("DischDate",date,admId)) 
			quit:(admId="")
			do OutputDetailByAdmId(admId)
		}
	}
	
	s qHandle=$lb(0,repid,0)
	q $$$OK
	
OutputDetailByAdmId(admId)
	s icuArrangeId="" f  s icuArrangeId=$o(^DHCICUArrange(0,"Adm",admId,icuArrangeId),-1) q:icuArrangeId=""  d
    .q:'$d(^DHCICUArrange(icuArrangeId))
    .do OutputDetail(icuArrangeId) 
	quit	
	
OutputDetail(icuaId)
	s id=icuaId																					//A0001	唯一键
	s admId=$p(^DHCICUArrange(icuaId),"^",1)    												//A0003	就诊号
	s papmiId=$p($g(^PAADM(admId)),"^",1)														//A0004	基本信息表DR
	s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)												//A0005	姓名
	s medcareNo=##class(web.DHCWMRService).IGetMrNoByEpisodeID(admId , .ErrMsg)   				//A0006	病历号
	s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)												//A0007	登记号
	s curLocId=$p($g(^PAADM(admId)),"^",4)
	s curWardId=$p($g(^PAADM(admId)),"^",70)
	s bedId=$p($g(^PAADM(admId)),"^",73)
	s bedSub=$p(bedId,"||",2)
	s bedCode="" 																				//A0008	床号
	i bedSub'="" s bedCode=$p($g(^PAWARD(curWardId,"BED",bedSub)),"^",1)	
	s birth=$p($g(^PAPER(papmiId,"ALL")),"^",6)
	s age=##class(web.DHCClinicCom).CalAge(birth,+$h)											//A0009	年龄
	s sex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)							//A0010	性别
	s AdmReason=$P($g(^PAADM(admId,1)),"^",7)
	s PAAdmReasonDesc="" 
	i AdmReason'="" s PAAdmReasonDesc=$P($g(^PAC("ADMREA",AdmReason)),"^",2)					//A0011	就诊类型
	s DischDateH=$P(^PAADM(admId),"^",17) 												
	s DischDate=""																		
	i DischDateH'="" s DischDate=$zd(DischDateH,3)												//A0012	统计日期=出院日期
	s hospDesc=""																				//A0013	病人院区
	s curLocDesc=$P(^CTLOC(curLocId),"^",2)														//A0014	病人科室
	s curWardDesc=$P($G(^PAWARD(curWardId)),"^",2)												//A0015	病人病区
	s ICUAResidentCtcpDr=$p($g(^DHCICUArrange(+icuaId)),"^",28)  								//A0016	病人主治医生											
	s ICUAResidentCtcpDesc=$p(##class(web.DHCClinicCom).GetUserTypeName(ICUAResidentCtcpDr),"^",2)	
	
	set inDateTime=##class(web.DHCICUCom).GetWardInDateTime("",icuaId,"","","^","D")
	set inDate=$p(inDateTime,"^"),inTime=$p(inDateTime,"^",2)
	set inDateH=##class(web.DHCClinicCom).ConvertToDateH(inDate),inTimeH=##class(web.DHCClinicCom).ConvertToDateH(inTime)
	set outDateTime=##class(web.DHCICUCom).GetWardOutDateTime("",icuaId,"","","^","D")
	set outDate=$p(outDateTime,"^",1),outTime=$p(outDateTime,"^",2)
	set outDateH=##class(web.DHCClinicCom).ConvertToDateH(outDate),outTimeH=##class(web.DHCClinicCom).ConvertToDateH(outTime)
	set apacheTotalScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,"ApacheTotalScore",inDate,inTime,outDate,outTime,"First")
	
	s inWardDate=##class(web.DHCClinicCom).ConvertToDate(inDate)								//A0017	入科日期
	s inWardTime=##class(web.DHCClinicCom).ConvertToTime(inTime)								//A0018	入科时间
	s outWardDate=##class(web.DHCClinicCom).ConvertToDate(outDate,"")							//A0019	出科日期
	s outWardTime=##class(web.DHCClinicCom).ConvertToTime(outTime,"")							//A0020	出科时间

	s ICUALeaveConditionCode=$p($g(^DHCICUArrange(+icuaId)),"^",43)
	s ICUALeaveConditionDesc=""																	//A0021	出科情况
	i ICUALeaveConditionCode="D" s ICUALeaveConditionDesc="死亡"						 
	i ICUALeaveConditionCode="T" s ICUALeaveConditionDesc="转科"
	i ICUALeaveConditionCode="A" s ICUALeaveConditionDesc="自动出院"
	i ICUALeaveConditionCode="M" s ICUALeaveConditionDesc="治愈出院"
	i ICUALeaveConditionCode="O" s ICUALeaveConditionDesc="外出治疗"
	
	s inWardDays=##class(web.DHCClinicCom).CalculateDuration(inDateH,inTimeH,outDateH,outTimeH,"D") 		//A0022	在科总天数
	s inWardHours=##class(web.DHCClinicCom).CalculateDuration(inDateH,inTimeH,outDateH,outTimeH,"H")		//A0023	在科时长(小时)
	s transferLocDesc=""																		//A0024	转出科室
		
	s ifDanger=""																				//A0025	是否病危	从HIS医嘱取，可空
	s ifSerious=""																				//A0026	是否病重	从HIS医嘱取，可空
	s ifRescue=""																				//A0027	是否抢救	从HIS医嘱取，可空
	s transferICUTimes=$$CountIcuTimes(admId)													//A0028	本次入院第几次转入ICU	转入ICU次数
	s returnICUHours=""																			//A0029	转出ICU后至再重返ICU时长	第一次不用算，2次以上的时长
	s InvasiveVentilatorDays=$$GetVentilatorDays("InvasiveVentilatorDays")						//A0030	有创机械通气总天数
	s NoninvasiveVentilatorDays=$$GetVentilatorDays("NoninvasiveVentilatorDays")  				//A0031	无创机械通气总天数
	s VentilatorDays=$$GetVentilatorDays("VentilatorDays")										//A0032	呼吸机使用天数
	s VentilatorTimes=""																		//A0033	呼吸机使用次数
	s CVTubuDays=""																				//A0034	血管内导管留置总天数
	s CVTubuTimes=""																			//A0035	血管内导管留置次数
	s UrinaryTubeDays=""																		//A0036	留置导尿管使用天数
	s UrinaryTubeTimes=""																		//A0037	留置导尿管使用次数
	s ifUseAntibiotics=""																		//A0038	是否使用抗菌药物	从HIS医嘱取，可空
	s useAntibiotics=""																			//A0039	使用抗菌药物天数	从HIS医嘱取，可空，某一天有多次算1天
	s ifUseAntibioticsPrevent=""																//A0040	是否使用抗菌药物预防	从HIS医嘱取，可空
	s useAntibioticsPreventDays=""																//A0041	使用抗菌药物预防天数	从HIS医嘱取，可空
	s ifUseAntibioticsCure=""																	//A0042	是否使用抗菌药物治疗	从HIS医嘱取，可空
	s useAntibioticsDays=""																		//A0043	使用抗菌药物治疗天数	从HIS医嘱取，可空
	s tracheaInOutTubeTimes=""																	//A0044	气管插管拔管医嘱数量	从HIS医嘱取，可空
	s apacheIIScore=apacheTotalScore															//A0045	APACHEⅡ评分


	//质控主题相关
	set AntibioticsSpecimenTest=$$JudgeAntibioticsSpecimenTest()								//A0012	是否抗菌药物治疗前病原学送检
	set ApacheIIScoreMoreThan15=$$JudgeApacheIIScoreMoreThan15()								//A0013	入ICU24小时内APACHEⅡ评分值是否≥15分
	set SepticShock3hBundle=$$JudgeSepticShock3hBundle()										//A0014	是否感染性休克3h集束化治疗
	set SepticShock6hBundle=$$JudgeSepticShock6hBundle()										//A0015	是否感染性休克6h集束化治疗
	set SepticShock=$$JudgeSepticShock()														//A0016	是否感染性休克
	set DVTPrevention=$$JudgeDVTPrevention()													//A0017	是否进行深静脉血栓(DVT)预防
	set DeathProbability=$$GetDeathProbability()												//A0018	ICU患者预计病死率
	set StandardizedDeath=$$JudgeStandardizedDeath()											//A0019	是否死亡
	set NonePlanTracheaCannula=$$JudgeNonePlanTracheaCannula()									//A0020	是否非计划气管插管拔管
	set TracheaCannula48hReIntubation=$$JudgeTracheaCannula48hReIntubation()					//A0021	是否气管插管计划拔管后48H内再插管
	set TracheaCannulaReIntubationDuration=""													//A0022	气管插管计划拔管后再插管间隔时长
	set NonePlanTransferICU=$$JudgeNonePlanTransferICU()										//A0023	是否非计划转入ICU
	set TranferOutAndReturnIn48h=$$JudgeTranferOutAndReturnIn48h()								//A0024	是否转出ICU后48h内重返ICU
	set TranferOutAndReturnFlag=""																//A0025	转出ICU后重返ICU标志
	set TranferOutAndReturnDuration=""															//A0026	转出ICU后重返ICU间隔时长
	set VAP=$$JudgeVAP()																		//A0027	是否ICU呼吸机相关性肺炎(VAP)
	set CRBSI=$$JudgeCRBSI()																	//A0028	是否ICU血管内导管相关血流感染(CRBSI)
	set CAUTI=$$JudgeCAUTI()																	//A0029	是否ICU导尿管相关泌尿系统感染(CAUTI)
	set SepticShock1hBundle=""																	//A0030	是否感染性休克1h集束化治疗
	do OutputRow
	
	quit	
		
OutputRow
	s ^CacheTemp(repid,ind)=$lb(id,icuaId,admId,papmiId,patName,medcareNo,regNo,bedCode,age,sex,PAAdmReasonDesc,DischDate,hospDesc,curLocDesc,curWardDesc,ICUAResidentCtcpDesc,inWardDate,inWardTime,outWardDate,outWardTime,ICUALeaveConditionDesc,inWardDays,inWardHours,transferLocDesc,ifDanger,ifSerious,ifRescue,transferICUTimes,returnICUHours,InvasiveVentilatorDays,NoninvasiveVentilatorDays,VentilatorDays,VentilatorTimes,CVTubuDays,CVTubuTimes,UrinaryTubeDays,UrinaryTubeTimes,ifUseAntibiotics,useAntibiotics,ifUseAntibioticsPrevent,useAntibioticsPreventDays,ifUseAntibioticsCure,useAntibioticsDays,tracheaInOutTubeTimes,apacheIIScore,AntibioticsSpecimenTest,ApacheIIScoreMoreThan15,SepticShock3hBundle,SepticShock6hBundle,SepticShock,DVTPrevention,DeathProbability,StandardizedDeath,NonePlanTracheaCannula,TracheaCannula48hReIntubation,TracheaCannulaReIntubationDuration,NonePlanTransferICU,TranferOutAndReturnIn48h,TranferOutAndReturnFlag,TranferOutAndReturnDuration,VAP,CRBSI,CAUTI,SepticShock1hBundle)
	s ind=ind+1
	q
	
CountIcuTimes(admId)
	s count=0
	s aId="" f  s aId=$o(^DHCICUArrange(0,"Adm",admId,aId),-1) q:aId=""  d
    .q:'$d(^DHCICUArrange(aId))
    .s count=count+1
    q count
    
GetVentilatorDays(VentilatorType)
	q ##class(web.DHCICUQualityControlStatistic).GetVentilatorDays(icuaId,inDate,inTime,outDate,outTime,VentilatorType)
	
JudgeAntibiotics()
	//ICU抗菌药物治疗
	set result="N"
	set stDate=inDate, stTime=inTime, eDate=outDate, eTime=outTime
	if ((outDate="")||(outTime="")) set eDate=+$h, eTime=$p($h,",",2)
	;首次获取使用抗菌药物的时间
	set AntibioticsDT=##class(web.DHCICUQualityControlStatistic).JudgeIfUseAntibiotics(icuaId,stDate,stTime,eDate,eTime,"AntibioticsDT")
	set AntibioticsDate=$p(AntibioticsDT,"^",1), AntibioticsTime=$p(AntibioticsDT,"^",2)
	if (AntibioticsDate'="")&&(AntibioticsTime'="") set result="Y"

	quit result
	
JudgeAntibioticsSpecimenTest()
	//ICU抗菌药物治疗前病原学送检
	set result="N"
	if ($$JudgeAntibiotics()="Y")
	{
		set stDate=inDate, stTime=inTime, eDate=outDate, eTime=outTime
		if ((outDate="")||(outTime="")) set eDate=+$h, eTime=$p($h,",",2)
		;病原学检验标本送检包括：微生物培养, 真菌细菌培养, 降钙素原, PCT, 白介素-6，白细胞介素-6检测等
		set specimenTestArcimIdStr="6154||1^5144||1^5145||1^5146||1^5147||1^5148||1^5149||1^5150||1^5151||1^5152||1^5153||1^5154||1^5155||1^5156||1^5157||1^5158||1^5159||1^5160||1^5161||1^5162||1^5105||1"
		set IfHasSpecimenTest=##class(web.DHCICUQualityControlStatistic).GetOEOrderValue(icuaId,specimenTestArcimIdStr,stDate,stTime,AntibioticsDate,AntibioticsTime,"YesNo")
		if (IfHasSpecimenTest="Y") set result="Y"
	}
	quit result
	
JudgeApacheIIScoreMoreThan15()
	set result="N"
	if (+apacheTotalScore>=15) set result="Y"
	quit result
	
JudgeSepticShock3hBundle()
	//感染性休克3h集束化治疗（bundle）完成
	set result="N"
	if ($$JudgeSepticShock()="Y")
	{
		set stDate=inDateH,stTime=inTimeH
		set dateTimeStr=##class(web.DHCClinicCom).DateTimeAdd(stDate,stTime,3*3600)
		set eDate=$piece(dateTimeStr,"^",1),eTime=$piece(dateTimeStr,"^",2)
		;;1.Lac最大值
		set MaxLac=##class(web.DHCICUOrder).GetRecordValue(icuaId,"Lac",stDate,stTime,eDate,eTime,"Max") 
		if (+MaxLac=0) set MaxLac=##class(web.DHCICUQualityControlStatistic).GetLabValue(icuaId,"LAC",stDate,stTime,eDate,eTime,"First")
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
		if (flag1&&flag2&&flag3&&(flag4||flag5)) set result="Y"
	}
	quit result
	
JudgeSepticShock6hBundle()
	////感染性休克6h集束化治疗（bundle）完成
	set result="N"
	if ($$JudgeSepticShock3hBundle()="Y")
	{
		set stDate=inDateH,stTime=inTimeH
		set dateTimeStr=##class(web.DHCClinicCom).DateTimeAdd(stDate,stTime,3*3600)
		set eDate3h=$piece(dateTimeStr,"^",1),eTime3h=$piece(dateTimeStr,"^",2)       ;3小时
		set dateTimeStr4h=##class(web.DHCClinicCom).DateTimeAdd(stDate,stTime,4*3600) ;4小时
		set stDate4h=$piece(dateTimeStr4h,"^",1),stTime4h=$piece(dateTimeStr4h,"^",2)
		set dateTimeStr6h=##class(web.DHCClinicCom).DateTimeAdd(stDate,stTime,6*3600) ;6小时
		set eDate6h=$piece(dateTimeStr6h,"^",1),eTime6h=$piece(dateTimeStr6h,"^",2)
		set ifHasSepsis=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"ICUASepsis")
		;;3小时内低血压MAP<65
		set minMAP=##class(web.DHCICUOrder).GetRecordValue(icuaId,"MAP",stDate,stTime,eDate3h,eTime3h,"Min")
		;;4-6小时使用升压药
		set IfUseVasopressor=##class(web.DHCICUQualityControlStatistic).GetOEOrderValue(icuaId,"1306||1^1215||1",stDate4h,stTime4h,eDate6h,eTime6h,"YesNo")
		;;0-6小时内低血压(MAP<65)
		set minMAP2=##class(web.DHCICUOrder).GetRecordValue(icuaId,"MAP",stDate,stTime,eDate6h,eTime6h,"Min")
		;;0-6小时须测CVP和ScvO2
		set FirstCVP=##class(web.DHCICUOrder).GetRecordValue(icuaId,"CVP",stDate,stTime,eDate6h,eTime6h,"First") 
		set FirstScvO2=##class(web.DHCICUOrder).GetRecordValue(icuaId,"ScvO2",stDate,stTime,eDate6h,eTime6h,"First") 
		set flag6=(ifHasSepsis="是")||((+minMAP>0)&&(+minMAP<65)&&(IfUseVasopressor="Y"))
		set flag7=(+minMAP2>0)&&(+minMAP2<65)&&(FirstCVP'="")&&(FirstScvO2'="")
		if (flag6||flag7) set result="Y"

	}
	quit result
	
JudgeSepticShock()
	set result="N"
	if (##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"ICUAShockType")="是") set result="Y"
	quit result
	
JudgeDVTPrevention()
	//ICU深静脉血栓（DVT）预防
	set result="N"
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
	if ((IfHasHeparin="Y")||(IfHasMechanicalPrevention="Y")||(IfHasDVTRecordItem="Y")) set result="Y"
	quit result
	
GetDeathProbability()
	set DeathProbability=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"ICUADeathProbability")
	quit +DeathProbability

JudgeStandardizedDeath()
	//ICU患者标化病死指数,根据病人转归状态判断病人是否死亡
	set result="N"
	set leaveCondition=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"ICUALeaveCondition")
	if leaveCondition="死亡" set result="Y"
	quit result
	
JudgeNonePlanTracheaCannula()
	//ICU非计划气管插管拔管
	set result="N"
	set stDate=inDateH, stTime=inTimeH, eDate=outDate, eTime=outTime
	if ((outDate="")||(outTime="")) set eDate=+$h, eTime=$p($h,",",2)
	set TracheaCannula=##class(web.DHCICUOrder).GetRecordValue(icuaId,"TracheaCannula",stDate,stTime,eDate,eTime,"First") 
	if TracheaCannula'=""
	{
		set IntubationDate=##class(web.DHCICUOrder).GetRecordValue(icuaId,"IntubationDate",stDate,stTime,eDate,eTime,"First")  ;插管日期
		set ExtubationDate=##class(web.DHCICUOrder).GetRecordValue(icuaId,"bgri",stDate,stTime,eDate,eTime,"First") ;拔管日期
		set ExtubationReason=##class(web.DHCICUOrder).GetRecordValue(icuaId,"bgyy",stDate,stTime,eDate,eTime,"First")  ;拔管原因
		if (IntubationDate'="")&&(ExtubationDate'="")&&(ExtubationReason="意外脱出") set result="Y"
	}
	quit result

JudgeTracheaCannula48hReIntubation()
	//ICU气管插管拔管后48h内再插管
	set result="N"
	set stDate=inDateH, stTime=inTimeH, eDate=outDate, eTime=outTime
	if ((outDate="")||(outTime="")) set eDate=+$h, eTime=$p($h,",",2)
	set TracheaCannula=##class(web.DHCICUOrder).GetRecordValue(icuaId,"TracheaCannula",stDate,stTime,eDate,eTime,"First") 
	if TracheaCannula'=""
	{
		set IntubationDate=##class(web.DHCICUOrder).GetRecordValue(icuaId,"IntubationDate",stDate,stTime,eDate,eTime,"First")  ;插管日期
		set ExtubationDate=##class(web.DHCICUOrder).GetRecordValue(icuaId,"bgri",stDate,stTime,eDate,eTime,"First") ;拔管日期
		set ExtubationReason=##class(web.DHCICUOrder).GetRecordValue(icuaId,"bgyy",stDate,stTime,eDate,eTime,"First")  ;拔管原因
		set AllIntubationTimes=##class(web.DHCICUOrder).GetRecordValue(icuaId,"IntubationDate",stDate,stTime,eDate,eTime,"Times")  ;插管次数
		set ReInTubeDuration=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"ReInTube") ;;气管插管拔管后48h内再插管
		if (IntubationDate'="")&&(ExtubationDate'="")&&((+ReInTubeDuration>0)&&(+ReInTubeDuration<2)) set result="Y"
	}
	quit result
	
JudgeNonePlanTransferICU()
	set SourceType=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"ICUASourceType")
	if ((SourceType="急诊内科")||(SourceType="急诊手术")) set result="Y"
	quit result 
	
JudgeTranferOutAndReturnIn48h()
	set result="N"
	s inDateTime=##class(web.DHCICUCom).GetWardInDateTime("",icuaId,"","","^","D")
    s outDateTime=##class(web.DHCICUCom).GetWardOutDateTime("",icuaId,"","","^","D")
    s WardinDate=$p(inDateTime,"^",1),WardinTime=$p(inDateTime,"^",2)
	s WardoutDate=$p(outDateTime,"^",1),WardoutTime=$p(outDateTime,"^",2)
	s icuBedId=$p($g(^DHCICUArrange(icuaId)),"^",4)
	s wardLocId=$p(^PAWARD(+icuBedId),"^",5)
	s EpisodeID=$p(^DHCICUArrange(icuaId),"^",1)
	s icuaId2=""
	f  s icuaId2=$o(^DHCICUArrange(0,"Adm",EpisodeID,icuaId2),-1) q:icuaId2=""  d
    .q:'$d(^DHCICUArrange(icuaId2))
    .q:icuaId2=icuaId
    q:icuaId2="" result
	s inDateTime2=##class(web.DHCICUCom).GetWardInDateTime("",icuaid2,"","","^","D")
    s outDateTime2=##class(web.DHCICUCom).GetWardOutDateTime("",icuaid2,"","","^","D")
    s WardinDate2=$p(inDateTime2,"^",1),WardinTime2=$p(inDateTime2,"^",2)
	s WardoutDate2=$p(outDateTime2,"^",1),WardoutTime2=	$p(outDateTime2,"^",2)
	s icuBedId2=$p($g(^DHCICUArrange(icuaid2)),"^",4)
	s wardLocId2=$p(^PAWARD(+icuBedId2),"^",5)
    i WardoutDate<WardinDate2 s icuHour=(WardinTime2-WardoutTime)\3600+((WardinDate2-WardoutDate)*24)
    i icuHour<=48  
    {
	    set array(icuaId,"TranferOutAndReturnIn48h", "note")=""
	    set result="Y"
    }
    quit result
    
JudgeVAP()
	;;ICU呼吸机相关性肺炎（VAP）发病
	set result="N"
	set stDate=inDateH, stTime=inTimeH, eDate=outDate, eTime=outTime
	if ((outDate="")||(outTime="")) set eDate=+$h, eTime=$p($h,",",2)
	set VAP=##class(web.DHCICUOrder).GetRecordValue(icuaId,"TracheaCannula",stDate,stTime,eDate,eTime,"First")
	if (VAP'="") set result="Y"
	quit result
	
JudgeCRBSI()
	;;ICU血管内导管相关血流感染（CRBSI）发病
	set result="N"
	set stDate=inDateH, stTime=inTimeH, eDate=outDate, eTime=outTime
	if ((outDate="")||(outTime="")) set eDate=+$h, eTime=$p($h,",",2)
	set IfHasCRBSI=##class(web.DHCICUQualityControlStatistic).JudgeIfHasRecordItem(icuaId,"zcgy^ycgy^zctjm^yctjm^zzzz^yzzz^picchy",stDate,stTime,eDate,eTime)
	if (IfHasCRBSI="Y") set result="Y"
	quit result
	
JudgeCAUTI()
	;ICU导尿管相关泌尿系感染（CAUTI）发病率
	set result="N"
	set stDate=inDateH, stTime=inTimeH, eDate=outDate, eTime=outTime
	if ((outDate="")||(outTime="")) set eDate=+$h, eTime=$p($h,",",2)
	set IfHasCAUTI=##class(web.DHCICUQualityControlStatistic).JudgeIfHasRecordItem(icuaId,"NGDNG^NGDNGqqq",stDate,stTime,eDate,eTime)
	if (IfHasCAUTI="Y") set result="Y"
	quit result
}

ClassMethod FindICUQualityControlDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindICUQualityControlDetailExecute ]
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

ClassMethod FindICUQualityControlDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindICUQualityControlDetailExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

}
