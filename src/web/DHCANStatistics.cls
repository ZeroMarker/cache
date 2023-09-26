/// 麻醉统计
Class web.DHCANStatistics Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

/// Creator：      	陈长青
/// CreatDate：    	2014-01-14
/// Description： 	查询一段时间内手术麻醉详细信息(只查询进行过麻醉监护的数据)
/// Table：        	DHC_AN_OPArrange  OR_Anaesthesia  OR_Anaest_Operation
/// Input：        	startDate：查询的开始日期，endDate：查询的结束日期
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("web.DHCANStatistics","FindANOPDetail","2014-01-14","2014-01-14")
Query FindANOPDetail(startDate As %String, endDate As %String, ifAN As %String = "Y") As %Query(ROWSPEC = "OperDate:%String,OperTime:%String,SecondOperTime:%String,TheareInTime:%String,TheareOutTime:%String,OperStartTime:%String,AnaStartTime:%String,TheareInDT:%String,TheareOutDT:%String,OperStartDT:%String,OperEndDT:%String,AnaStartDT:%String,Dept:%String,BedNo:%String,RegNo:%String,PatName:%String,Gender:%String,Age:%String,PreOPDiagnosis:%String,PlanOperation:%String,PostOPDiagnosis:%String,Operation:%String,AnaMethod:%String,SecondAnaMethod:%String,AnaDoctor:%String,AnaSuperDoctor:%String,AnaAssistant:%String,AnaIntern:%String,OperRoom:%String,OperSeqNo:%String,OperDoctor:%String,OperAssistant:%String,SecondOperAssistant:%String,OperIntern:%String,AllOperDoctor:%String,CircleNurse:%String,InstrumentNurse:%String,SourceType:%String,SourceTypeDesc:%String,BloodLossQty:%String,RedBloodCellQty:%String,BloodPlasmaQty:%String,AutoBloodQty:%String,BloodPlateletQty:%String,BloodCoaplationFactorQty:%String,BeforeTransBloodPara:%String,AfterTransBloodPara:%String,UntowardReaction:%String,DocArriveTime:%String,GroupDoctor:%String,IsDelay:%String,DelayReason:%String,UserDesc:%String,OperTotalMinutes:%String,AnaTotalMinutes:%String,TheareTotalMinutes:%String,MedUnit:%String") [ SqlProc ]
{
}

ClassMethod FindANOPDetailExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, ifAN As %String = "Y") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	i (startDate="") s startDate=+$h
	e  s startDate=##class(web.DHCANOPCom).ConvertToDateH(startDate)
	
	i (endDate="") s endDate=+$h
	e  s endDate=##class(web.DHCANOPCom).ConvertToDateH(endDate)
	
	i (startDate>endDate) s startDate=endDate
	
	s beforeTransBloodEvent="szsj048",afterTransBloodEvent="szsj050"
	s untowardReactionEvent="szsj049",operStartEvent="szsj004",operEndEvent="szsj005",anaStartEvent="szsj002"
	s theareInEvent="szsj001",theareOutEvent="szsj008"
	
	f i=startDate:1:endDate  d
	.s opaId=""
	.f  s opaId=$o(^DHCANOPArrange(0,"SDate",i,opaId)) q:(opaId="")  d
	..s anStatus=##class(web.DHCANCom).JudgeANStatus(opaId)
	..q:(ifAN="Y")&(anStatus'="Y")
	..q:(ifAN="N")&(anStatus="Y")
	..s operDate=##class(web.DHCANOPCom).ConvertToDate(i)
	..s arrangeInfo=^DHCANOPArrange(opaId)
	..s opaStatus=$p(arrangeInfo,"^",27)
	..q:(opaStatus'="F")
	..//手术时间
	..s anaId=$p(arrangeInfo,"^",2)
	..s EpisodeID=+anaId
	..s anaSubId=$p(anaId,"||",2)
	..s theareInTime=$p(^OR(EpisodeID,"ANA",anaSubId),"^",40)
	..s theareInTime=##class(web.DHCANOPCom).ConvertToTime(theareInTime)
	..s theareOutTime=$p(^OR(EpisodeID,"ANA",anaSubId),"^",42)
	..i (anStatus'="Y") s theareOutTime=$p(^DHCANOPArrange(opaId),"^",17)
	..s theareOutTime=##class(web.DHCANOPCom).ConvertToTime(theareOutTime)
	..s theareInDT="",theareOutDT=""
	..i (anStatus="Y")  d
	...s theareEvent=##class(web.DHCANOPData).GetEventInfo(opaId,theareInEvent)
	...s theareInDT=$p(theareEvent,"^",4)
	...s theareEvent=##class(web.DHCANOPData).GetEventInfo(opaId,theareOutEvent)
	...s theareOutDT=$p(theareEvent,"^",4)
	...i (theareOutDT="")  d
	....s theareOutDate=$p(^DHCANOPArrange(opaId),"^",16)
	....s theareOutDate=##class(web.DHCANOPCom).ConvertToDate(theareOutDate)
	....s theareOutDT=theareOutDate_" "_theareOutTime
	..s operTime=theareInTime_"～"_theareOutTime
	..s operStartDT="",operEndDT=""
	..i (anStatus="Y")  d
	...s operEvent=##class(web.DHCANOPData).GetEventInfo(opaId,operStartEvent)
	...s operStartDT=$p(operEvent,"^",4)
	...s operEvent=##class(web.DHCANOPData).GetEventInfo(opaId,operEndEvent)
	...s operEndDT=$p(operEvent,"^",4)
	..s operStartTime=$p(^OR(EpisodeID,"ANA",anaSubId),"^",19)
	..i (anStatus'="Y") s operStartTime=$p(^DHCANOPArrange(opaId),"^",15)
	..s operStartTime=##class(web.DHCANOPCom).ConvertToTime(operStartTime)
	..s secondOperTime=operStartTime_"～"_theareOutTime
	..//麻醉开始时间
	..s anaStartTime=$p(^OR(EpisodeID,"ANA",anaSubId),"^",3)
	..s anaStartTime=##class(web.DHCANOPCom).ConvertToTime(anaStartTime)
	..s anaStartDT=""
	..i (anStatus="Y")  d
	...s anaEvent=##class(web.DHCANOPData).GetEventInfo(opaId,anaStartEvent)
	...s anaStartDT=$p(anaEvent,"^",4)
	..//科室
	..s applyLocId=$p(arrangeInfo,"^",54)
	..s applyLoc=$p(^CTLOC(applyLocId),"^",2)
	..//床号
	..s bedNo=""
	..s wardId=$p(^PAADM(EpisodeID),"^",70)    //当前病区ID
	..s bedSubId=$p($p($g(^PAADM(EpisodeID)),"^",73),"||",2)
	..i (wardId'="")&(bedSubId'="")  s bedNo=$p($g(^PAWARD(wardId,"BED",bedSubId)),"^",1)
	..//登记号
	..s papmiId=$p(^PAADM(EpisodeID),"^",1)
	..s regNo=$p(^PAPER(papmiId,"PAT",1),"^",1)
	..//病人姓名
	..s patName=$p(^PAPER(papmiId,"ALL"),"^",1)
	..//性别
	..s genderId=$p(^PAPER(papmiId,"ALL"),"^",7)
	..s gender=$p(^CT("SEX",genderId),"^",2)
	..//年龄
	..s birthDate=$p(^PAPER(papmiId,"ALL"),"^",6)
	..s age=##class(web.UDHCANOPArrange).CalAge(birthDate,i)
	..//术前诊断
	..s OPSubId=$o(^OR(EpisodeID,"ANA",anaSubId,"OP",0))
	..s preOPDiagnosis="",preOPDiagnosisId=""
	..s preOPDiagnosisId=$p(^OR(EpisodeID,"ANA",anaSubId,"OP",OPSubId),"^",4)
	..s preOPDiagnosis=$p($g(^MRC("ID",+preOPDiagnosisId)),"^",2)
	..i (preOPDiagnosis="")  s preOPDiagnosis=$g(^OR(EpisodeID,"ANA",anaSubId,"TXT",2))
	..//拟施手术
	..s planOperationId=$p(^OR(EpisodeID,"ANA",anaSubId,"OP",OPSubId,"DHC"),"^",2)
	..s planOperation=$p($g(^ORC("OPER",+planOperationId)),"^",2)
	..i (planOperation="") s planOperation=planOperationId
	..//术后诊断
	..s postOPDiagnosisStr=##class(web.DHCANOPData).GetPostOPDiagnosis(EpisodeID,anaSubId,OPSubId)
	..s postOPDiagnosis=$p(postOPDiagnosisStr,"^",1)
	..i (postOPDiagnosis="")  d
	...;如果术后诊断为空，那么从日志global中获取术后诊断(温岭术后登记保存后，术后诊断变成空)
	...s currentDate=+$h+1,maxTime=86400
	...s diagSaveDate=$o(^TMPCCQ(opaId,"PostDiag",currentDate),-1)
	...i (diagSaveDate'="")  d
	....s diagSaveTime=$o(^TMPCCQ(opaId,"PostDiag",diagSaveDate,maxTime),-1)
	....i (diagSaveTime'="") s postOPDiagnosis=$p(^TMPCCQ(opaId,"PostDiag",diagSaveDate,diagSaveTime),"^",1)
	..//实施手术
	..s operation=##class(web.DHCANOPData).GetExecOperation(EpisodeID,anaSubId,OPSubId)
	..//麻醉方法、麻醉方法二
	..s anaMethodId=$P(^OR(EpisodeID,"ANA",anaSubId),"^",5)
	..s anaMethod=$p($g(^ORC("ANMET",+anaMethodId)),"^",2)
	..s anaMethodCount=$l(anaMethodId,"|")
	..s secondAnaMethod=""
	..i (anaMethodCount>1)  d
	...s secondAnaMethodId=$p(anaMethodId,"|",2)
	...s secondAnaMethod=$p($g(^ORC("ANMET",+secondAnaMethodId)),"^",2)
	..//麻醉医生
	..s anaDoctorId=$P(^OR(EpisodeID,"ANA",anaSubId),"^",6)
	..s anaDoctor=##class(web.DHCANOPCom).GetNameById(anaDoctorId)
	..//麻醉指导
	..s anaSuperDocId=$P(^OR(EpisodeID,"ANA",anaSubId),"^",7)
	..s anaSuperDoc=##class(web.DHCANOPCom).GetNameById(anaSuperDocId)
	..//麻醉助手
	..s anaAssistant=##class(web.DHCANOPData).GetAnaAssistant(EpisodeID,anaSubId,OPSubId)
	..s anaIntern=$p(arrangeInfo,"^",43)
	..//手术间
	..s operRoomId=$p(arrangeInfo,"^",20)
	..s operRoom=$p($g(^DHCANC("OPRoom",operRoomId)),"^",2)
	..//台次
	..s operSeqNo=$p(arrangeInfo,"^",26)
	..//手术医生
	..s operDoctorId=$P(^OR(EpisodeID,"ANA",anaSubId,"OP",OPSubId),"^",8)
	..s operDoctor=##class(web.DHCANOPCom).GetNameById(operDoctorId)
	..//手术一助、手术二助
	..s allOperAssistant=##class(web.DHCANOPData).GetOperAssistant(EpisodeID,anaSubId,OPSubId)
	..s operAssistant=$p(allOperAssistant,",",1)
	..s secondOperAssistant=$p(allOperAssistant,",",2)
	..s allOperDoctor=operDoctor
	..i (allOperAssistant'="") s allOperDoctor=allOperDoctor_","_allOperAssistant
	..s operIntern=$p(arrangeInfo,"^",42)
	..//巡回护士
	..s circleNurseStr=##class(web.DHCANOPData).GetANOPNurse(EpisodeID,anaSubId,OPSubId,"CIRN")
	..s circleNurse=$p(circleNurseStr,"^",1)
	..//器械护士
	..s instrumentNurseStr=##class(web.DHCANOPData).GetANOPNurse(EpisodeID,anaSubId,OPSubId,"SCN")
	..s instrumentNurse=$p(instrumentNurseStr,"^",1)
	..//手术类型(来源)
	..s sourceType=$p(^OR(EpisodeID,"ANA",anaSubId),"^",32)
	..s sourceTypeDesc="择期"
	..i (sourceType="E") s sourceTypeDesc="急诊"
	..//失血量
	..s bloodLossQty=##class(web.DHCANOPData).GetInOutItemValue(opaId,"BloodLoss")
	..//红细胞
	..s redBloodCellQty=##class(web.DHCANOPData).GetInOutItemValue(opaId,"RedBloodCell")
	..//血浆
	..s bloodPlasmaQty=##class(web.DHCANOPData).GetInOutItemValue(opaId,"BloodPlasma")
	..//自体血
	..s autoBloodQty=##class(web.DHCANOPData).GetInOutItemValue(opaId,"AutoBlood")
	..//血小板
	..s bloodPlateletQty=##class(web.DHCANOPData).GetInOutItemValue(opaId,"BloodPlatelet")
	..//凝血因子(冷沉淀)
	..s bloodCoaplationFactorQty=##class(web.DHCANOPData).GetInOutItemValue(opaId,"BloodCoaplationFactor")
	..s eventInfo=##class(web.DHCANOPData).GetEventInfo(opaId,beforeTransBloodEvent)
	..//输血前血气参数
	..s beforeTransBloodPara=$p(eventInfo,"^",1)
	..s eventInfo=##class(web.DHCANOPData).GetEventInfo(opaId,afterTransBloodEvent)
	..//输血后血气参数
	..s afterTransBloodPara=$p(eventInfo,"^",1)
	..s eventInfo=##class(web.DHCANOPData).GetEventInfo(opaId,untowardReactionEvent)
	..//输血并发症(输血不良反应)
	..s untowardReaction=$p($p($p(eventInfo,"^",1),"#",1),":",2)
	..i (untowardReaction="")  d
	...i (+redBloodCellQty'=0)!(+bloodPlasmaQty'=0)!(+bloodPlateletQty'=0)!(+bloodCoaplationFactorQty'=0)  d
	....s untowardReaction="无"
	..//输血填报者
	..s userDesc=$p(eventInfo,"^",3)
	..//医生到达时间
	..s docArriveTime=""
	..//是否同组医师
	..s groupDoctor=""
	..//手术是否延迟
	..s isDelay=""
	..//手术延迟原因
	..s delayReason=""
	..//手术间时长
	..s theareTotalMinutes=""
	..//麻醉时长
	..s anaTotalMinutes=""
	..//手术时长
	..s operTotalMinutes=""
	..s medUnit=""
	..s appDate=$p(arrangeInfo,"^",3)
	..i (operDoctorId'="") s medUnit=..GetMedUnitByDocId(operDoctorId,appDate)
	..d OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRow
	Set Data=$lb(operDate,operTime,secondOperTime,theareInTime,theareOutTime,operStartTime,anaStartTime,theareInDT,theareOutDT,operStartDT,operEndDT,anaStartDT,applyLoc,bedNo,regNo,patName,gender,age,preOPDiagnosis,planOperation,postOPDiagnosis,operation,anaMethod,secondAnaMethod,anaDoctor,anaSuperDoc,anaAssistant,anaIntern,operRoom,operSeqNo,operDoctor,operAssistant,secondOperAssistant,operIntern,allOperDoctor,circleNurse,instrumentNurse,sourceType,sourceTypeDesc,bloodLossQty,redBloodCellQty,bloodPlasmaQty,autoBloodQty,bloodPlateletQty,bloodCoaplationFactorQty,beforeTransBloodPara,afterTransBloodPara,untowardReaction,docArriveTime,groupDoctor,isDelay,delayReason,userDesc,theareTotalMinutes,anaTotalMinutes,operTotalMinutes,medUnit)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindANOPDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindANOPDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod FindANOPDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindANOPDetailExecute ]
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

/// 获取手术医生的医疗单元
ClassMethod GetMedUnitByDocId(doctorId As %String, appDate As %String) As %String
{
	s result=""
	i (doctorId="")!(appDate="")!($d(^CTLOC(0,"CTPCP",doctorId))<1) q result
	s ifFind="N",ctLocId=0,medUnitId=0,medUnitCareProvId=0
	f  s ctLocId=$o(^CTLOC(0,"CTPCP",doctorId,ctLocId)) q:(ctLocId="")!(ifFind="Y")  d
	.f  s medUnitId=$o(^CTLOC(0,"CTPCP",doctorId,ctLocId,"MU",medUnitId)) q:(medUnitId="")!(ifFind="Y")  d
	..f  s medUnitCareProvId=$o(^CTLOC(0,"CTPCP",doctorId,ctLocId,"MU",medUnitId,"CP",medUnitCareProvId)) q:(medUnitCareProvId="")!(ifFind="Y")  d
	...s dateFrom=$p(^CTLOC(ctLocId,"MU",medUnitId,"CP",medUnitCareProvId),"^",5)
	...s dateTo=$p(^CTLOC(ctLocId,"MU",medUnitId,"CP",medUnitCareProvId),"^",6)
	...q:((dateTo'="")&(appDate>dateTo))!(appDate<dateFrom)
	...s result=ctLocId_"||"_medUnitId_"||"_medUnitCareProvId
	...s ifFind="Y"
	q result
}

/// Creator：      	陈长青
/// CreatDate：    	2015-03-05
/// Description： 	查询手术科室
/// Table：        	CT_LOC
/// Input：        	LocListCode:科室列表代码
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("web.DHCANStatistics","FindOPLocationList","OP")
Query FindOPLocationList(locListCode As %String) As %Query(ROWSPEC = "Id:%String,Code:%String,Description:%String") [ SqlProc ]
{
}

ClassMethod FindOPLocationListExecute(ByRef qHandle As %Binary, locListCode As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	set locListId=##class(web.DHCClinicCom).GetLocIdByLocListCode(locListCode)
	set locCount=$length(locListId,"^")
	for i=1:1:locCount
	{
		set locId=$piece(locListId,"^",i)
		continue:(locId="")
		continue:'$data(^CTLOC(locId))
		set locCode=$piece(^CTLOC(locId),"^",1)
		set locDesc=$piece(^CTLOC(locId),"^",2)
		if ($length(locDesc,"-")>0)
		{
			set locDesc=$piece(locDesc,"-",2)	
		}
		do OutputRow
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRow
	Set Data=$lb(locId,locCode,locDesc)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindOPLocationListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOPLocationListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod FindOPLocationListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOPLocationListExecute ]
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

/// Creator：      	陈长青
/// CreatDate：    	2015-03-09
/// Description： 	查询手术申请排班、麻醉监护信息
/// Table：        	DHC_AN_OPArrange  OR_Anaesthesia  OR_Anaest_Operation
/// Input：        	startDate：查询的开始日期，endDate：查询的结束日期
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("web.DHCANStatistics","FindArrangeInfo","2015-04-08","2015-04-08")
Query FindArrangeInfo(startDate As %String, endDate As %String, locId As %String = "", roomId As %String = "", singlePatient = "N", regNoPara As %String = "", medicareNoPara As %String = "", patNamePara As %String = "", applyLocIdPara As %String = "", surgeonDocIdPara As %String = "") As %Query(ROWSPEC = "Id,EpisodeID,AnaestId,PatName,Gender,Age,RegNo,MedicareNo,OperLocId,OperLoc,OperRoomId,OperRoom,ApplyLocId,ApplyLoc,SurgeonDocId,SurgeonDoc,SurAssistant,AnaestDoc,AnaestDocId,AnaAssistant,InstrNurse,CirculNurse,TheatreInDT,AnaestStartDT,AnaestFinishDT,OperStartDT,OperStartDate,OperStartTime,OperFinishDT,TheatreOutDT,PACUInDT,PACUOutDT,SecurityCheckDT,PreOPCheckingTime,PreTheatreOutCheckingTime,PositionDT,AreaInDT,AreaOutDT,AbnormalVitalSign,BloodTransApply,DrugInfo,MaterialInfo,LabInfo,Status,RealStatus,Operation,OperCategoryId,OperCategory,Seq,SourceType,SpecialPat,Puerperant,AntiResistance,Infection,SecurityReturn,MulDeptOperation,SurgeonDocTypeId,RegStartDT,RegFinishDT,DeceasedDT,Deceased,DeptGroupId,DeptGroup,LongOperDuration,PatDeptId,PatDeptDesc") [ SqlProc ]
{
}

ClassMethod FindArrangeInfoExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, locId As %String = "", roomId As %String = "", singlePatient = "N", regNoPara As %String = "", medicareNoPara As %String = "", patNamePara As %String = "", applyLocIdPara As %String = "", surgeonDocIdPara As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	set ^TMPCCQ("ArrangeInfoPara")=startDate_"^"_endDate_"^"_locId_"^"_roomId_"^"_regNoPara_"^"_medicareNoPara_"^"_patNamePara
	i startDate=$c(0) s startDate=""
	i endDate=$c(0) s endDate=""
	i locId=$c(0) s locId=""
	i roomId=$c(0) s roomId=""
	i regNoPara=$c(0) s regNoPara=""
	i medicareNoPara=$c(0) s medicareNoPara=""
	i patNamePara=$c(0) s patNamePara=""
	i singlePatient=$c(0) s singlePatient=""
	i applyLocIdPara=$c(0) s applyLocIdPara=""
	i surgeonDocIdPara=$c(0) s surgeonDocIdPara=""
	
	set listCount=1
	k OPAIDList
	if (singlePatient="Y")
	{
		s papmiId=""
		i regNoPara'="" s papmiId=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(regNoPara),""))
		i papmiId="",medicareNoPara'="" d
		.s medicareNoPara=$$ALPHAUP^SSUTIL4(medicareNoPara)
		.s papmiId=$o(^PAPERi("Medicare1",medicareNoPara,""))
		i papmiId'=""
		{
			s patNamePara=""
			set admType=""
			for
			{
			set admType=$order(^PAPERdr(papmiId,"ADM",admType))
			quit:(admType="")
			set EpisodeID=0
			for
			{
				set EpisodeID=$order(^PAPERdr(papmiId,"ADM",admType,EpisodeID))
				quit:(EpisodeID="")
				set opaId=0
				for
				{
					set opaId=$order(^DHCANOPArrange(0,"Adm",EpisodeID,opaId))
					quit:(opaId="")
					if (##class(User.DHCANOPArrange).%ExistsId(opaId))
					{
						set OPAIDList(listCount)=opaId
						set listCount=listCount+1	
					}	
				}
			}
			}
		} 
		else
		{
			if (patNamePara'="")
			{
				for
				{
					set papmiId=$order(^PAPERi("PAPER_PatName",patNamePara,papmiId))
					quit:papmiId=""
					set EpisodeIDList=##class(web.DHCClinicCom).GetPatientEpisodeID("",papmiId,"","","IO")
					for i=1:1:$length(EpisodeIDList,"^")
					{
						set EpisodeID=$piece(EpisodeIDList,"^",i)
						set opaId=0
						for
						{
							set opaId=$order(^DHCANOPArrange(0,"Adm",EpisodeID,opaId))
							quit:(opaId="")
							if (##class(User.DHCANOPArrange).%ExistsId(opaId))
							{
								set OPAIDList(listCount)=opaId
								set listCount=listCount+1	
							}	
						}	
					}	
				}	
			}	
		}
		
		set ^TMPCCQ("ArrangeInfoPara",1)="test"_"^"_regNoPara_"^"_medicareNoPara_"^"_patNamePara
	}
	else
	{
		i (startDate="") s startDate=+$h
		e  s startDate=##class(web.DHCANOPCom).ConvertToDateH(startDate)
	
		i (endDate="") s endDate=+$h
		e  s endDate=##class(web.DHCANOPCom).ConvertToDateH(endDate)
	
		i (startDate>endDate) s startDate=endDate
		
		for i=startDate:1:endDate
		{
			set opaId=""
			for
			{
				set opaId=$order(^DHCANOPArrange(0,"SDate",i,opaId))
				quit:(opaId="")	
				if (##class(User.DHCANOPArrange).%ExistsId(opaId))
				{
					set OPAIDList(listCount)=opaId
					set listCount=listCount+1	
				}
			}	
		}	
	}
	
	set listLength=$o(OPAIDList(""),-1)
	for i=1:1:listLength
	{
		set opaId=OPAIDList(i)
		continue:('##class(User.DHCANOPArrange).%ExistsId(opaId))
		set arrangeInfo=^DHCANOPArrange(opaId)
			set operRoomId=$piece(arrangeInfo,"^",20)
			continue:(roomId'="")&(roomId'=operRoomId)
			set operRoom=""
			if (operRoomId'="")
			{
				set operRoom=$piece($get(^DHCANC("OPRoom",operRoomId)),"^",2)	
			}
			
			set regStartDate=$piece(arrangeInfo,"^",14)
			set regStartTime=$piece(arrangeInfo,"^",15)
			set regStartDT=##class(web.DHCClinicCom).ConvertToDateTime(regStartDate,regStartTime)	//手术开始时间（术后登记）
			
			set regFinishDate=$piece(arrangeInfo,"^",16)
			set regFinishTime=$piece(arrangeInfo,"^",17)
			set regFinishDT=##class(web.DHCClinicCom).ConvertToDateTime(regFinishDate,regFinishTime)	//手术结束时间（术后登记）
			
			set seq=$piece(arrangeInfo,"^",26)
			set anaestId=$piece(arrangeInfo,"^",2)
			set EpisodeID=+anaestId
			set anaestSubId=$piece(anaestId,"||",2)
			
			
			
			set theatreInDate=$piece(^OR(EpisodeID,"ANA",anaestSubId),"^",39)
			set theatreInTime=$piece(^OR(EpisodeID,"ANA",anaestSubId),"^",40)
			set theatreInDT=##class(web.DHCClinicCom).ConvertToDateTime(theatreInDate,theatreInTime)	//入室时间
			//set theatreInInfo=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"AN.TheatreInDT")
			//set theatreInDT=$piece(theatreInInfo,$c(3),1)
			
			set patMasterId=$piece(^PAADM(EpisodeID),"^",1)		//病人登记ID
			set patName=$piece(^PAPER(patMasterId,"ALL"),"^",1)
			set genderId=$piece(^PAPER(patMasterId,"ALL"),"^",7)
			set gender=$piece(^CT("SEX",genderId),"^",2)
			set birthDate=$piece(^PAPER(patMasterId,"ALL"),"^",6)
			set age=##class(web.DHCClinicCom).CalAge(birthDate,+$h)		//计算年龄
			set regNo=$piece(^PAPER(patMasterId,"PAT",1),"^",1)
			set medicareNo=##class(web.DHCClinicCom).GetMedicareNo(patMasterId,"")
			
			//特需收费
			set admReasonId=$piece(^PAADM(EpisodeID,1),"^",7)
			set admReasonCode=""
			if (+admReasonId>0)
			{
				set admReasonCode=$piece($get(^PAC("ADMREA",admReasonId)),"^",1)	
			}
			set specialPat="N"
			if (admReasonCode="ZF03") //协和特需收费的代码，如果别的医院需要那么可以做成配置
			{
				set specialPat="Y"	
			}
			
			//多重耐药菌 multiple antimicrobial resistance
			set antiResistance="" ;##class(web.DHCANOPData).GetMultipleAntiResistance(EpisodeID,theatreInDT)
			
			//感染四项
			set infection="N",infectionResult="阳性"
			set HBsAg=$piece(^DHCANOPArrange(opaId,"PALab"),"^",30)
			if (HBsAg=infectionResult)
			{
				set infection="Y"	
			}
			set HCVAb=$piece(^DHCANOPArrange(opaId,"PALab"),"^",34)
			if (HCVAb=infectionResult)
			{
				set infection="Y"	
			}
			set HivAb=$piece(^DHCANOPArrange(opaId,"PALab"),"^",35)
			if (HivAb=infectionResult)
			{
				set infection="Y"	
			}
			set TPAb=$piece(^DHCANOPArrange(opaId,"PALab"),"^",36)
			if (TPAb=infectionResult)
			{
				set infection="Y"	
			}
			

			//多科手术
			set applyLocId=$piece(arrangeInfo,"^",54)
			set applyLoc="",deptGroupId="",deptGroup=""
			if (applyLocId'="")
			{
				set wardFlag=$piece($get(^CTLOC(applyLocId)),"^",5)
				set linkLocId=""
				if (wardFlag="Y")
				{
					set linkLocId=##class(web.DHCClinicCom).GetLinkLocId(applyLocId)
				}
				if (linkLocId'="")
				{
					set linkLocCount=$length(linkLocId,"^")
					set operDayStartDate=+$h-7,operDayEndDate=+$h
					set operDayQuery=##class(%ResultSet).%New("web.DHCANCRoom:FindSurgeryDay")
					for j=1:1:linkLocCount
					{
						set singleLinkLocId=$piece(linkLocId,"^",j)
						continue:(+singleLinkLocId<=0)
						set linkGroupId=$piece($get(^CTLOC(singleLinkLocId)),"^",19)
						set execResult=operDayQuery.Execute(operDayStartDate,operDayEndDate,linkGroupId)
						set newApplyLocId=""
						while(operDayQuery.Next())
						{
							set newApplyLocId=singleLinkLocId
							quit:(+newApplyLocId>0)	
						}
						if (+newApplyLocId>0)
						{
							set applyLocId=newApplyLocId
							quit:(+newApplyLocId>0)
						}	
					}	
				}
				
				set deptGroupId=$piece($get(^CTLOC(applyLocId)),"^",19)
				if (deptGroupId'="")
				{
					set deptGroup=$piece($get(^RBC("DEP",deptGroupId)),"^",2)	
				}
				set applyLoc=$piece(^CTLOC(applyLocId),"^",2)		//手术申请科室
				if ($length(applyLoc,"-")=2)
				{
					set applyLoc=$piece(applyLoc,"-",2)	
				}	
			}
			continue:(applyLocIdPara'="")&(applyLocIdPara'=applyLocId)
			
			set patDeptId=$piece(arrangeInfo,"^",21)
			continue:(patDeptId=552) ;过滤国际医疗部的病人
			set patDeptDesc=$piece($get(^CTLOC(patDeptId)),"^",2)
			if ($length(patDeptDesc,"-")=2)
			{
				set patDeptDesc=$piece(patDeptDesc,"-",2)	
			}
			
			set patDeptGroupId=$piece($get(^CTLOC(patDeptId)),"^",19)
			set mulDeptOperation="N"
			if (+patDeptGroupId>0)&(+deptGroupId>0)
			{
				if (patDeptGroupId'=deptGroupId)
				{
					set mulDeptOperation="Y"	
				}	
			}
			else
			{
				if (patDeptId'="")&(applyLocId'="")&(patDeptId'=applyLocId)
				{
					set mulDeptOperation="Y"	
				}	
			}
			
			
			set operSubId=$order(^OR(EpisodeID,"ANA",anaestSubId,"OP",0))
			continue:(operSubId="")
			set operLocId=$piece(^OR(EpisodeID,"ANA",anaestSubId,"OP",operSubId),"^",10)
			set operLoc=""
			if (operLocId'="")
			{
				set operLoc=$piece(^CTLOC(operLocId),"^",2)	
				if ($length(operLoc,"-")=2)
				{
					set operLoc=$piece(operLoc,"-",2)	
				}
			}
			continue:(locId'="")&(locId'=operLocId)
			
			set surgeonDocId="",surgeonDoc="",surgeonDocTypeId=""
			if (operSubId'="")
			{
				set surgeonDocId=$piece(^OR(EpisodeID,"ANA",anaestSubId,"OP",operSubId),"^",8)
				if (+surgeonDocId>0)
				{
					set surgeonDocTypeId=$piece($get(^CTPCP(+surgeonDocId,1)),"^",4) 	
				}
				set surgeonDoc=##class(web.DHCANOPCom).GetNameById(surgeonDocId)
			}
			continue:(surgeonDocIdPara'="")&(surgeonDocId'=surgeonDocIdPara)
			
			//手术助手
			set surAssistant=""
			if (operSubId'="")
			{
				set surAssistant=##class(web.DHCANOPData).GetOperAssistant(EpisodeID,anaestSubId,operSubId)
			}
			if (surAssistant="")
			{
				set surAssistant=$piece(^DHCANOPArrange(opaId),"^",42)	
			}
			
			//麻醉助手
			set anaAssistant=""
			if (operSubId'="")
			{
				set anaAssistant=##class(web.DHCANOPData).GetAnaAssistant(EpisodeID,anaestSubId,operSubId)	
			}
			if (anaAssistant="")
			{
				set anaAssistant=$piece(^DHCANOPArrange(opaId),"^",43)	
			}
			
			//麻醉医生
			set anaestId=$piece(^OR(EpisodeID,"ANA",anaestSubId),"^",6)
			set anaestDoc=##class(web.DHCANOPCom).GetNameById(anaestId)
			
			//器械护士
			set instrNurse=""
			if (operSubId'="")
			{
				set instrNurseInfo=##class(web.DHCANOPData).GetANOPNurse(EpisodeID,anaestSubId,operSubId,"SCN")
				set instrNurse=$piece(instrNurseInfo,"^",1)		
			}
			
			//巡回护士
			set circulNurse=""
			if (operSubId'="")
			{
				set circulNurseInfo=##class(web.DHCANOPData).GetANOPNurse(EpisodeID,anaestSubId,operSubId,"CIRN")
				set circulNurse=$piece(circulNurseInfo,"^",1)		
			}
			
			
			
			//入手术科室日期和时间
			set areaInDate=$piece(^OR(EpisodeID,"ANA",anaestSubId),"^",35)
			set areaInTime=$piece(^OR(EpisodeID,"ANA",anaestSubId),"^",36)
			set areaInDT=##class(web.DHCClinicCom).ConvertToDateTime(areaInDate,areaInTime)	
			//set areaInInfo=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"AN.AreaInDT")
			//set areaInDT=$piece(areaInInfo,$c(3),1)
			
			//离手术科室日期和时间
			set areaOutDate=$piece(^OR(EpisodeID,"ANA",anaestSubId),"^",37)
			set areaOutTime=$piece(^OR(EpisodeID,"ANA",anaestSubId),"^",38)
			set areaOutDT=##class(web.DHCClinicCom).ConvertToDateTime(areaOutDate,areaOutTime)
			//set areaOutInfo=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"AN.AreaOutDT")
			//set areaOutDT=$piece(areaOutInfo,$c(3),1)
			
			//麻醉开始日期和时间
			set anaestStartDate=$piece(^OR(EpisodeID,"ANA",anaestSubId),"^",2)
			set anaestStartTime=$piece(^OR(EpisodeID,"ANA",anaestSubId),"^",3)
			set anaestStartDT=##class(web.DHCClinicCom).ConvertToDateTime(anaestStartDate,anaestStartTime)
			if (anaestStartDT'="")
			{
				set anaStartDTH=anaestStartDate+(anaestStartTime/100000)
				set theatreInDTH=theatreInDate+(theatreInTime/100000)
				if (anaStartDTH<theatreInDTH)
				{
					set theatreInInfo=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"AN.TheatreInDT")
					if ($piece(theatreInInfo,$c(3),1)'="") set theatreInDT=$piece(theatreInInfo,$c(3),1)	
				}	
			}
			//set anaestStartInfo=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"AN.AnaestStartDT")
			//set anaestStartDT=$piece(anaestStartInfo,$c(3),1)
			
			//麻醉结束日期和时间
			set anaestFinishDate=$piece(^OR(EpisodeID,"ANA",anaestSubId),"^",29)
			set anaestFinishTime=$piece(^OR(EpisodeID,"ANA",anaestSubId),"^",4)
			set anaestFinishDT=##class(web.DHCClinicCom).ConvertToDateTime(anaestFinishDate,anaestFinishTime)
			//set anaestFinishInfo=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"AN.AnaestFinishDT")
			//set anaestFinishDT=$piece(anaestFinishInfo,$c(3),1)
			
			//手术开始日期和时间
			set operStartInfo=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"AN.OperStartDT")
			set operStartDT=$piece(operStartInfo,$c(3),1)
			set operStartDate=$piece(operStartDT," ",1)
			set operStartTime=$piece(operStartDT," ",2)
			
			//手术结束日期和时间
			set operFinishInfo=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"AN.OperFinishDT")
			set operFinishDT=$piece(operFinishInfo,$c(3),1)
			
			
			//离手术间日期和时间
			set theatreOutDate=$piece(^OR(EpisodeID,"ANA",anaestSubId),"^",41)
			set theatreOutTime=$piece(^OR(EpisodeID,"ANA",anaestSubId),"^",42)
			set theatreOutDT=##class(web.DHCClinicCom).ConvertToDateTime(theatreOutDate,theatreOutTime)
			//set theatreOutInfo=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"AN.TheatreOutDT")
			//set theatreOutDT=$piece(theatreOutInfo,$c(3),1)
			
			//入恢复室日期和时间
			set PACUInDate=$piece($get(^DHCANOPArrange(opaId,"PACU")),"^",6)
			set PACUInTime=$piece($get(^DHCANOPArrange(opaId,"PACU")),"^",7)
			set PACUInDT=##class(web.DHCClinicCom).ConvertToDateTime(PACUInDate,PACUInTime)
			//set PACUInInfo=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"AN.PACUInDT")
			//set PACUInDT=$piece(PACUInInfo,$c(3),1)
			
			
			//离恢复室日期和时间
			set PACUOutDate=$piece($get(^DHCANOPArrange(opaId,"PACU")),"^",8)
			set PACUOutTime=$piece($get(^DHCANOPArrange(opaId,"PACU")),"^",9)
			set PACUOutDT=##class(web.DHCClinicCom).ConvertToDateTime(PACUOutDate,PACUOutTime)	
			//set PACUOutInfo=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"AN.PACUOutDT")
			//set PACUOutDT=$piece(PACUOutInfo,$c(3),1)
			
			//三方核查开始日期和时间
			set securityCheckExtendInfo=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"OPS.FirstCheckTime")
			set securityCheckDT=$piece(securityCheckExtendInfo,$c(3),1)
			
			set securityCheckExtendInfo=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"OPS.PreOPCheckingTime")
			set preOPCheckingTime=$piece(securityCheckExtendInfo,$c(3),1)
			
			set securityCheckExtendInfo=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"OPS.PreTheatreOutCheckingTime")
			set preTheatreOutCheckingTime=$piece(securityCheckExtendInfo,$c(3),1)
			
			//术后安返
			set patMasterId=$piece(^PAADM(EpisodeID),"^",1)
			set deceasedTime=$piece(^PAPER(patMasterId,"ALL"),"^",8)
			set deceasedDate=$piece(^PAPER(patMasterId,"ALL"),"^",13)
			set deceasedDT=##class(web.DHCClinicCom).ConvertToDateTime(deceasedDate,deceasedTime)
			set deceased=$piece(^PAPER(patMasterId,"ALL"),"^",12)
			set deceasedDTH=deceasedDate+(deceasedTime/100000)
			set theatreOutDTH=theatreOutDate+(theatreOutTime/100000)
			set securityReturn="Y"
			if (deceased="Y")&(deceasedDTH<=theatreOutDTH)
			{
				set securityReturn="N"	
			}
			
			//超长手术时间
			set longOperDuration="" ;##class(web.DHCANOperDuration).GetOperDuration(opaId)
			
			
			//摆体位日期和时间
			set positionDT=""
			
			//异常生命体征
			set abnormalVitalSign=""
			
			//输血申请
			set bloodTransApply=""
			
			//术中用药
			set drugInfo=""
			
			//手术材料
			set materialInfo=""
			
			//检验项目
			set labInfo=""
			
			//手术状态
			set status=$piece(arrangeInfo,"^",27)
			set realStatus=$piece(arrangeInfo,"^",27)
			set statusText=""
			if ("AD"'[status)
			{
				if (areaInDT'="")&(theatreInDT="")
				{
					set statusText="等待"
					
				}
				if (theatreInDT'="")&(theatreOutDT="")
				{
					set statusText="术中"
					set status="I"	
				}
				if (theatreOutDT'="")&(PACUInDT="")
				{
					set statusText="术毕"
					set status="L"	
				}
				if (PACUInDT'="")&(areaOutDT="")
				{
					set statusText="恢复"
					set status="P"	
				}
				if (areaOutDT'="")
				{
					set statusText="完成"
					set status="F"
				}	
			}
			
			
			//手术名称
			set operation=""
			set operation=##class(web.DHCANOPData).GetExecOperation(EpisodeID,anaestSubId,operSubId)
			set puerperantFlag="剖宫产"
			set puerperant="N"
			if (operation[puerperantFlag)
			{
				set puerperant="Y"	
			}
			
			//手术分类
			set operDetail="" ;##class(web.DHCANOPData).GetExecOperationDetail(EpisodeID,anaestSubId,operSubId)
			set operCategory=$p(operDetail,"^",2)
			set operCategoryId=$p(operDetail,"^",3)
			if (operCategoryId="")
			{
				set operCategoryId="8"		
			}
			//b //ccq
			
			//来源类型(急诊或择期)
			set sourceType=$p(^OR(EpisodeID,"ANA",anaestSubId),"^",32)
			do OutputRow	
	}
	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRow
	Set Data=$lb(opaId,EpisodeID,anaestId,patName,gender,age,regNo,medicareNo,operLocId,operLoc,operRoomId,operRoom,applyLocId,applyLoc,surgeonDocId,surgeonDoc,surAssistant,anaestDoc,anaestDocId,anaAssistant,instrNurse,circulNurse,theatreInDT,anaestStartDT,anaestFinishDT,operStartDT,operStartDate,operStartTime,operFinishDT,theatreOutDT,PACUInDT,PACUOutDT,securityCheckDT,preOPCheckingTime,preTheatreOutCheckingTime,positionDT,areaInDT,areaOutDT,abnormalVitalSign,bloodTransApply,drugInfo,materialInfo,labInfo,status,realStatus,operation,operCategoryId,operCategory,seq,sourceType,specialPat,puerperant,antiResistance,infection,securityReturn,mulDeptOperation,surgeonDocTypeId,regStartDT,regFinishDT,deceasedDT,deceased,deptGroupId,deptGroup,longOperDuration,patDeptId,patDeptDesc)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindArrangeInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindArrangeInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod FindArrangeInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindArrangeInfoExecute ]
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

/// Creator：      	陈长青
/// CreatDate：    	2015-4-4
/// Description： 	手术室实时监控统计
/// Table：        	DHC_AN_OPArrange,OR_Anaesthesia,OR_Anaest_Operation
/// Input：        	startDate:查询开始日期,startTime:查询开始时间,endDate:查询结束日期,endTime:查询结束时间
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("web.DHCANStatistics","FindOperStatistics","2015-4-3","05:00","2015-4-4","05:00")
Query FindOperStatistics(startDate As %String, startTime As %String, endDate As %String, endTime As %String) As %Query(ROWSPEC = "OperLocId,OperLocDesc,OperRoomId,OperRoomDesc,OpaId,AreaInDT,AreaOutDT,TheatreInDT,TheatreOutDT,OperStartDT,OperFinishDT,AnaStartDT,AnaFinishDT,PACUInDT,PACUOutDT,OperStatus,PatName,Gender,Age,SourceType,EpisodeID,RegNo,AnaestId,SurgeonDocId,SurgeonDoc,SurgeonAssistant,AnaestDocId,AnaestDoc,AnaAssistant,InstrNurse,CirculNurse,SeqNo,Deceased,DeceasedDT,SecurityReturn,MulDeptOperation") [ SqlProc ]
{
}

ClassMethod FindOperStatisticsExecute(ByRef qHandle As %Binary, startDate As %String, startTime As %String, endDate As %String, endTime As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	set operLocQuery=##class(%ResultSet).%New("web.DHCANStatistics:FindOPLocationList")
	set operLocStatus=operLocQuery.Execute("OP")
	
	set startDateH=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	set startTimeH=##class(web.DHCClinicCom).ConvertToTimeH(startTime)
	set startDTH=startDateH+(startTimeH/100000)
	set endDateH=##class(web.DHCClinicCom).ConvertToDateH(endDate)
	set endTimeH=##class(web.DHCClinicCom).ConvertToTimeH(endTime)
	set endDTH=endDateH+(endTimeH/100000)
	set minDateTime="0001-01-01 00:00"
	
	set operArrangeQuery=##class(%ResultSet).%New("web.DHCANStatistics:FindArrangeInfo")
	while (operLocQuery.%Next())
	{
		set operLocId=operLocQuery.Get("Id")
		set operLocDesc=operLocQuery.Get("Description")
		set operArrangeStatus=operArrangeQuery.Execute(startDate,endDate,operLocId)
			while(operArrangeQuery.%Next())
			{
				set opaId=operArrangeQuery.Get("Id")
				set areaInDT=operArrangeQuery.Get("AreaInDT")
				if (areaInDT="")
				{
					//如果是手术申请状态或手术拒绝状态的手术，没有入手术科室时间，以手术申请时预计的时间比较
					set areaInDT=##class(web.DHCClinicCom).ConvertToDateTime($piece(^DHCANOPArrange(opaId),"^",14),$piece(^DHCANOPArrange(opaId),"^",15))	
				}
				//if (areaInDT="") set areaInDT="0001-01-01 00:00"
				continue:(areaInDT="")
				
				set areaInDateH=##class(web.DHCClinicCom).ConvertToDateH($piece(areaInDT," ",1))
				set areaInTimeH=##class(web.DHCClinicCom).ConvertToTimeH($piece(areaInDT," ",2))
				set areaInDTH=areaInDateH+(areaInTimeH/100000)
				// 入手术科室时间判断
				continue:(areaInDTH<startDTH)!(areaInDTH>endDTH)
				set operRoomId=operArrangeQuery.Get("OperRoomId")
				set operRoomDesc=operArrangeQuery.Get("OperRoom")
				set areaOutDT=operArrangeQuery.Get("AreaOutDT")
				if (areaOutDT="") set areaOutDT=minDateTime
				set theatreInDT=operArrangeQuery.Get("TheatreInDT")
				if (theatreInDT="") set theatreInDT=minDateTime
				set theatreOutDT=operArrangeQuery.Get("TheatreOutDT")
				if (theatreOutDT="") set theatreOutDT=minDateTime
				set operStartDT=operArrangeQuery.Get("OperStartDT")
				if (operStartDT="") set operStartDT=minDateTime
				set operFinishDT=operArrangeQuery.Get("OperFinishDT")
				if (operFinishDT="") set operFinishDT=minDateTime
				set anaStartDT=operArrangeQuery.Get("AnaestStartDT")
				if (anaStartDT="") set anaStartDT=minDateTime
				set anaFinishDT=operArrangeQuery.Get("AnaestFinishDT")
				if (anaFinishDT="") set anaFinishDT=minDateTime
				set PACUInDT=operArrangeQuery.Get("PACUInDT")
				if (PACUInDT="") set PACUInDT=minDateTime
				set PACUOutDT=operArrangeQuery.Get("PACUOutDT")
				if (PACUOutDT="") set PACUOutDT=minDateTime
				set operStatus=operArrangeQuery.Get("Status")
				set currentStatus=$piece(^DHCANOPArrange(opaId),"^",27)
				if (currentStatus="F") set operStatus=currentStatus
				set patName=operArrangeQuery.Get("PatName")
				set gender=operArrangeQuery.Get("Gender")
				set age=operArrangeQuery.Get("Age")
				set sourceType=operArrangeQuery.Get("SourceType")
				set EpisodeID=operArrangeQuery.Get("EpisodeID")
				set regNo=operArrangeQuery.Get("RegNo")
				set surgeonDocId=operArrangeQuery.Get("SurgeonDocId")
				set surgeonDoc=operArrangeQuery.Get("SurgeonDoc")
				set surAssistant=operArrangeQuery.Get("SurAssistant")
				set anaestId=operArrangeQuery.Get("AnaestId")
				set anaestDocId=operArrangeQuery.Get("AnaestDocId")
				set anaestDoc=operArrangeQuery.Get("AnaestDoc")
				set anaAssistant=operArrangeQuery.Get("AnaAssitant")
				set instrNurse=operArrangeQuery.Get("InstrNurse")
				set circulNurse=operArrangeQuery.Get("CirculNurse")
				set seqNo=operArrangeQuery.Get("Seq")
				if (+seqNo<=0) set seqNo=-1
				set patMasterId=$piece(^PAADM(EpisodeID),"^",1)
				set deceasedTime=$piece(^PAPER(patMasterId,"ALL"),"^",8)
				set deceasedDate=$piece(^PAPER(patMasterId,"ALL"),"^",13)
				set deceasedDT=##class(web.DHCClinicCom).ConvertToDateTime(deceasedDate,deceasedTime)
				if (deceasedDT="") set deceasedDT=minDateTime
				set deceased=$piece(^PAPER(patMasterId,"ALL"),"^",12)
				set securityReturn=operArrangeQuery.Get("SecurityReturn")
				set mulDeptOperation=operArrangeQuery.Get("MulDeptOperation")
				do OutputRow
			}
		
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow
	Set Data=$lb(operLocId,operLocDesc,operRoomId,operRoomDesc,opaId,areaInDT,areaOutDT,theatreInDT,theatreOutDT,operStartDT,operFinishDT,anaStartDT,anaFinishDT,PACUInDT,PACUOutDT,operStatus,patName,gender,age,sourceType,EpisodeID,regNo,anaestId,surgeonDocId,surgeonDoc,surgeonAssistant,anaestDocId,anaestDoc,anaAssistant,instrNurse,circulNurse,seqNo,deceased,deceasedDT,securityReturn,mulDeptOperation)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindOperStatisticsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOperStatisticsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod FindOperStatisticsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOperStatisticsExecute ]
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

/// Creator：      	陈长青
/// CreatDate：    	2015-6-16
/// Description： 	获取医生职称
/// Table：        	CT_CarPrvTp
/// Input：        	
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("web.DHCANStatistics","FindCareProvType")
Query FindCareProvType() As %Query(ROWSPEC = "Id,Code,Desc") [ SqlProc ]
{
}

ClassMethod FindCareProvTypeExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	set typeId=0,today=+$h
	for
	{
		set typeId=$order(^CT("CPT",typeId))
		quit:(typeId="")
		set activeFlag=$piece(^CT("CPT",typeId),"^",3)
		continue:(activeFlag="N")
		set dateFrom=+$piece(^CT("CPT",typeId),"^",5)
		set dateTo=	$piece(^CT("CPT",typeId),"^",6)
		continue:(today<dateFrom)!((dateTo'="")&(today>(+dateTo)))
		set internalType=$piece(^CT("CPT",typeId),"^",4)
		continue:(internalType'="DOCTOR")
		set code=$piece(^CT("CPT",typeId),"^",1)
		set desc=$piece(^CT("CPT",typeId),"^",2)
		do OutputRow
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow
	Set Data=$lb(typeId,code,desc)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindCareProvTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCareProvTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod FindCareProvTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCareProvTypeExecute ]
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

}
