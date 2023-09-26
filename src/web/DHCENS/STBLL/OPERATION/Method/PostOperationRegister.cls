Class web.DHCENS.STBLL.OPERATION.Method.PostOperationRegister Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：ZhangYonghao
/// CreatDate：2021—03-12
/// Description:手术排班和术后登记
/// Table：
/// Input：
/// w ##class(web.DHCENS.STBLL.OPERATION.Method.PostOperationRegister).SendPostOperRegInfo("")
ClassMethod SendPostOperRegInfo(Input As %GlobalCharacterStream) As %GlobalCharacterStream
{
	set $zt="Exception"
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(Input,.tDocument)
	d Input.Rewind()
	set Response=##class(web.DHCENS.STBLL.OPERATION.Model.Response).%New()
	set header=##class(web.DHCENS.STBLL.OPERATION.Model.Header).%New()
	set header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set header.SourceSystem="02"
	set Response.header=header
	set responseBody=##class(web.DHCENS.STBLL.OPERATION.Model.Respbody).%New()
	set (EpisodeID,ExternalID,AppDeptID,OperDeptID,OperExecDeptID,PatDeptID,PatWardID,PatBedID,Status,PrevDiagnosis,PrevAnaMethod,AppDate,AppTime,OperDate,OperTime,AppUserID,AppCareProvID,SourceType,Anaesthesia,ReentryOperation,IsoOperation,ECC,TransAutoblood,PrepareBlood,BloodType,RHBloodType,HbsAg,HcvAb,HivAb,Syphilis,OperRequirement,LabTest,PatName,PatGender,PatDOB,PatWeight,PatHeight,OperDuration,SurgicalMaterials,PlanSeq,AppOrderItem,ExtAnaestID,OperPosition,ExpertFlag,OriginalSchedule,SeqType,HighConsume,Antibiosis,InfectionOper,MIS,BodySite,SurIntership,SurVisitors,OperRoom,OperSeq,ScrubNurse,CircualNurse,InternshipNurse)=""
	set (OperSchedule,AnaMethod,AnaExpert,Anesthesiologist,AnaAssistant,AnaStaff,AreaInDT,AreaOutDT,TheatreInDT,TheatreOutDT,AnaStartDT,AnaFinishDT,TubeInDT,TubeOutDT,OperStartDT,OperFinishDT,PACUInDT,PACUOutDT,ASAClass,AnaClass,PreFasting,PreOperNote,PreMedication,OperPosition,ECGDoctor,TotalIn,ColloidalVol,CrystalloidVol,TotalOut,UrineVol,WaterLossVol,BloodLossVol,TheatreOutTransLoc,AreaOutTransLoc,OutRoomAna,AppDocConNo,ShiftDoctor,Pneumothorax,Pneumoperitoneum)=""
	
	if $$$ISERR(tSC) 
	{
		set responseBody.ResultCode="-1"
		set responseBody.ResultContent=tSC
		set Response.Respbody=responseBody
	}
	else
	{
		set (PATPatientID,PAADMVisitNumber,SCHEDULEID,DEPTSTAYED,BEDNO,SCHEDULEDDATETIME,OPERATINGROOM,OPERATINGROOMNO,SEQUENCE)=""
		set (DIAGBEFOREOPERATION,OPERATIONSCALE,EMERGENCYINDICATOR,ISOLATIONINDICATOR,OPERATINGDEPT,SURGEON,FIRSTASSISTANT,SECONDASSISTANT)=""
		set (THIRDASSISTANT,FOURTHASSISTANT,ANESTHESIAMETHOD,ANESTHESIADOCTOR,SECONDANESTHESIADOCTOR,THIRDANESTHESIADOCTOR,ANESTHESIAASSISTANT)=""
		set (SECONDANESTHESIAASSISTANT,THIRDANESTHESIAASSISTANT,FOURTHANESTHESIAASSISTANT,BLOODTRANDOCTOR,FIRSTOPERATIONNURSE)=""
		set (SECONDOPERATIONNURSE,FIRSTSUPPLYNURSE,SECONDSUPPLYNURSE,THIRDSUPPLYNURSE,NOTESONOPERATION,REQDATETIME,ENTEREDBY)=""
		set (STATUS,opaStr,anaStr,anaopStr,assDocStr,arrStr,operStr)=""
		set (OPERATIONNURSE,SUPPLYNURSE)=""
		set tSC=tDocument.EvaluateExpression("/Request/Body/OperationArrangeRt/PATPatientID","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
			set fieldValue=tRes.GetAt(1).Value
			set PATPatientID=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/OperationArrangeRt/PAADMVisitNumber","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
			set fieldValue=tRes.GetAt(1).Value
			set EpisodeID=$tr(fieldValue,$c(0),"")
		}
		
		set tSC=tDocument.EvaluateExpression("/Request/Body/OperationArrangeRt/SCHEDULE_ID","text()",.tRes)				
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set OperSchedule=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/OperationArrangeRt/DEPT_STAYED","text()",.tRes)				
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set PatDeptID=$tr(fieldValue,$c(0),"")
		}

		set tSC=tDocument.EvaluateExpression("/Request/Body/OperationArrangeRt/BED_NO","text()",.tRes)				
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set PatBedID=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/OperationArrangeRt/SCHEDULED_DATE_TIME","text()",.tRes)				
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set SCHEDULEDDATETIME=$tr(fieldValue,$c(0),"")
		}
		set:SCHEDULEDDATETIME'="" OperDate=$p(SCHEDULEDDATETIME," ",1)
		set:SCHEDULEDDATETIME'="" OperTime=$p(SCHEDULEDDATETIME," ",2)
		set tSC=tDocument.EvaluateExpression("/Request/Body/OperationArrangeRt/OPERATING_ROOM","text()",.tRes)				
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set OperExecDeptID=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/OperationArrangeRt/OPERATING_ROOM_NO","text()",.tRes)				
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set OperRoom=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/OperationArrangeRt/SEQUENCE","text()",.tRes)				
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set OperSeq=$tr(fieldValue,$c(0),"")
			set PostDiagnosis=$tr(fieldValue,$c(0),"")
		}			
		set tSC=tDocument.EvaluateExpression("/Request/Body/OperationArrangeRt/DIAG_BEFORE_OPERATION","text()",.tRes)				
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set PrevDiagnosis=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/OperationArrangeRt/PATIENT_CONDITION","text()",.tRes)				
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set PATIENTCONDITION=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/OperationArrangeRt/OPERATION_SCALE","text()",.tRes)				
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set OPERATIONSCALE=$tr(fieldValue,$c(0),"")
		}
		set:OPERATIONSCALE["一" OPERATIONSCALE="1"
		set:OPERATIONSCALE["二" OPERATIONSCALE="2"
		set:OPERATIONSCALE["三" OPERATIONSCALE="3"
		set:OPERATIONSCALE["四" OPERATIONSCALE="4"
		
		set tSC=tDocument.EvaluateExpression("/Request/Body/OperationArrangeRt/EMERGENCY_INDICATOR","text()",.tRes)				
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set SourceType=$tr(fieldValue,$c(0),"")
		}
		set:SourceType="0" SourceType="B"
		set:SourceType="1" SourceType="E"
		set:SourceType="2" SourceType="D"
		set tSC=tDocument.EvaluateExpression("/Request/Body/OperationArrangeRt/ISOLATION_INDICATOR","text()",.tRes)				
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set IsoOperation=$tr(fieldValue,$c(0),"")
		}
		set:IsoOperation="" IsoOperation="N"
		set:IsoOperation="1" IsoOperation="N"
		set:IsoOperation="2" IsoOperation="y"
		set:IsoOperation="3" IsoOperation="y"
		set tSC=tDocument.EvaluateExpression("/Request/Body/OperationArrangeRt/OPERATING_DEPT","text()",.tRes)				
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set SurgeonDeptID=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/OperationArrangeRt/SURGEON","text()",.tRes)				
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set Surgeon=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/OperationArrangeRt/FIRST_ASSISTANT","text()",.tRes)				
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set FIRSTASSISTANT=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/OperationArrangeRt/SECOND_ASSISTANT","text()",.tRes)				
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set SECONDASSISTANT=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/OperationArrangeRt/THIRD_ASSISTANT","text()",.tRes)				
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set THIRDASSISTANT=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/OperationArrangeRt/FOURTH_ASSISTANT","text()",.tRes)				
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set FOURTHASSISTANT=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/OperationArrangeRt/ANESTHESIA_METHOD","text()",.tRes)				
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set AnaMethod=$tr(fieldValue,$c(0),"")
		}
		set (Anesthesiologist1,Anesthesiologist2,Anesthesiologist3)=""
		set tSC=tDocument.EvaluateExpression("/Request/Body/OperationArrangeRt/ANESTHESIA_DOCTOR","text()",.tRes)				
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set Anesthesiologist1=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/OperationArrangeRt/SECOND_ANESTHESIA_DOCTOR","text()",.tRes)				
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set Anesthesiologist2=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/OperationArrangeRt/THIRD_ANESTHESIA_DOCTOR","text()",.tRes)				
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set Anesthesiologist3=$tr(fieldValue,$c(0),"")
		}
		set (AnaAssistant1,AnaAssistant2,AnaAssistant3,AnaAssistant4)=""
		set tSC=tDocument.EvaluateExpression("/Request/Body/OperationArrangeRt/ANESTHESIA_ASSISTANT","text()",.tRes)				
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set AnaAssistant1=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/OperationArrangeRt/SECOND_ANESTHESIA_ASSISTANT","text()",.tRes)				
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set AnaAssistant2=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/OperationArrangeRt/THIRD_ANESTHESIA_ASSISTANT","text()",.tRes)				
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set AnaAssistant3=$tr(fieldValue,$c(0),"")
		}
		set:AnaAssistant1'="" AnaAssistant=AnaAssistant1
		set:AnaAssistant2'="" AnaAssistant=AnaAssistant1_","_AnaAssistant2
		set:AnaAssistant3'="" AnaAssistant=AnaAssistant1_","_AnaAssistant2_","_AnaAssistant3
		set tSC=tDocument.EvaluateExpression("/Request/Body/OperationArrangeRt/FOURTH_ANESTHESIA_ASSISTANT","text()",.tRes)				
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set AnaAssistant4=$tr(fieldValue,$c(0),"")
		}
		set:AnaAssistant1'="" AnaAssistant=AnaAssistant1
		set:AnaAssistant2'="" AnaAssistant=AnaAssistant1_","_AnaAssistant2
		set:AnaAssistant3'="" AnaAssistant=AnaAssistant1_","_AnaAssistant2_","_AnaAssistant3
		set:AnaAssistant4'="" AnaAssistant=AnaAssistant1_","_AnaAssistant2_","_AnaAssistant3_","_AnaAssistant4
		set tSC=tDocument.EvaluateExpression("/Request/Body/OperationArrangeRt/BLOOD_TRAN_DOCTOR","text()",.tRes)				
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set BLOODTRANDOCTOR=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/OperationArrangeRt/FIRST_OPERATION_NURSE","text()",.tRes)				
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set FIRSTOPERATIONNURSE=$tr(fieldValue,$c(0),"")
		}
		i (FIRSTOPERATIONNURSEID'="")
		{
			set:OPERATIONNURSE'="" OPERATIONNURSE=OPERATIONNURSE_","_FIRSTOPERATIONNURSEID
			set:OPERATIONNURSE="" OPERATIONNURSE=FIRSTOPERATIONNURSEID
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/OperationArrangeRt/SECOND_OPERATION_NURSE","text()",.tRes)				
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set SECONDOPERATIONNURSE=$tr(fieldValue,$c(0),"")
		}
		i (SECONDOPERATIONNURSE'="")
		{
			set:OPERATIONNURSE'="" OPERATIONNURSE=OPERATIONNURSE_","_SECONDOPERATIONNURSE
			set:OPERATIONNURSE="" OPERATIONNURSE=SECONDOPERATIONNURSE
		}
		
		set tSC=tDocument.EvaluateExpression("/Request/Body/OperationArrangeRt/FIRST_SUPPLY_NURSE","text()",.tRes)				
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set FIRSTSUPPLYNURSE=$tr(fieldValue,$c(0),"")
		}
		i (FIRSTSUPPLYNURSEID'="")
		{
			set:SUPPLYNURSE'="" SUPPLYNURSE=SUPPLYNURSE_","_FIRSTSUPPLYNURSEID
			set:SUPPLYNURSE="" SUPPLYNURSE=FIRSTSUPPLYNURSEID
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/OperationArrangeRt/SECOND_SUPPLY_NURSE","text()",.tRes)				
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set SECONDSUPPLYNURSE=$tr(fieldValue,$c(0),"")
		}
		i (SECONDSUPPLYNURSEID'="")
		{
			set:SUPPLYNURSE'="" SUPPLYNURSE=SUPPLYNURSE_","_SECONDSUPPLYNURSEID
			set:SUPPLYNURSE="" SUPPLYNURSE=SECONDSUPPLYNURSEID
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/OperationArrangeRt/THIRD_SUPPLY_NURSE","text()",.tRes)				
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set THIRDSUPPLYNURSE=$tr(fieldValue,$c(0),"")
		}
		i (THIRDSUPPLYNURSEID'="")
		{
			set:SUPPLYNURSE'="" SUPPLYNURSE=SUPPLYNURSE_","_THIRDSUPPLYNURSEID
			set:SUPPLYNURSE="" SUPPLYNURSE=THIRDSUPPLYNURSEID
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/OperationArrangeRt/NOTES_ON_OPERATION","text()",.tRes)				
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set SurgicalMaterials=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/OperationArrangeRt/REQ_DATE_TIME","text()",.tRes)				
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set REQDATETIME=$tr(fieldValue,$c(0),"")
		}
		set:REQDATETIME'="" AppDate=$p(REQDATETIME," ",1)
		set:REQDATETIME'="" AppTime=$p(REQDATETIME," ",2)
		set tSC=tDocument.EvaluateExpression("/Request/Body/OperationArrangeRt/ENTERED_BY","text()",.tRes)				
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set ENTEREDBY=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/OperationArrangeRt/STATUS","text()",.tRes)				
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set Status=$tr(fieldValue,$c(0),"")
			//D:"拒绝",R:"安排",N:"非预约",I:"术中",P:"恢复室",L:"术毕",F:"完成",C:"撤销"

		}
		set:Status="D" Status="8"
		set:Status="R" Status="3"
		set:Status="N" Status="1"
		set:Status="I" Status="4"
		set:Status="P" Status="6"
		set:Status="L" Status="5"
		set:Status="F" Status="7"
		set:Status="C" Status="9"
		set AnaId=$P($G(^DHCANOPArrange(OperSchedule)),"^",2)
		set AdmId=$P(AnaId,"||",1)
		set AnaSub=$P(AnaId,"||",2)
		set AnaOpSub=$o(^OR(AdmId,"ANA",AnaSub,"OP",0))
		set OperRoomId=$P($G(^OR(AdmId,"ANA",AnaSub,"OP",AnaOpSub)),"^",10)
		set:OperRoomId'="" OPERATINGROOM=$P($G(^CTLOC(OperRoomId)),"^",1)
		set ErrorFlag="0"
		set (Operation,OperClass,BladeType,BodySite,OperPos,Note,Surgeon,Assistant,SurgeonDeptID,OperNo,AddtionalStaff,OperNote,PostDiagnosis,ExternalID)=""
		set tSC=tDocument.EvaluateExpression("/Request/Body/OperationArrangeRt","count(OPERATIONS)",.tRes)
		set OperList="#"
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'=""))
		{
			set hsCount=tRes.GetAt(1).Value
			set (OPERATIONNO,OPERATION,OPERATIONCODE,OPERATIONDEPT,OPERATIONDOCCODE)=""
			if (hsCount'=0)
			{
				for i=1:1:hsCount 
				{
					set tSC=tDocument.EvaluateExpression("/Request/Body/OperationArrangeRt/OPERATIONS["_i_"]/OPERATION_NO","text()",.tRes) 				
					if ($$$ISOK(tSC)&&(tRes.GetAt(1)'=""))
					{					
						set fieldValue=tRes.GetAt(1).Value
						set OperNo=$tr(fieldValue,$c(0),"")
					}
					set tSC=tDocument.EvaluateExpression("/Request/Body/OperationArrangeRt/OPERATIONS["_i_"]/OPERATION_Name","text()",.tRes) 				
					if ($$$ISOK(tSC)&&(tRes.GetAt(1)'=""))
					{					
						set fieldValue=tRes.GetAt(1).Value
						set Operation=$tr(fieldValue,$c(0),"")
					}
					set tSC=tDocument.EvaluateExpression("/Request/Body/OperationArrangeRt/OPERATIONS["_i_"]/OPERATION_CODE","text()",.tRes) 				
					if ($$$ISOK(tSC)&&(tRes.GetAt(1)'=""))
					{					
						set fieldValue=tRes.GetAt(1).Value
						set OPERATIONCODE=$tr(fieldValue,$c(0),"")
					}
					set tSC=tDocument.EvaluateExpression("/Request/Body/OperationArrangeRt/OPERATIONS["_i_"]/OPERATION_SCALE","text()",.tRes) 				
					if ($$$ISOK(tSC)&&(tRes.GetAt(1)'=""))
					{					
						set fieldValue=tRes.GetAt(1).Value
						set OperClass=$tr(fieldValue,$c(0),"")
						//OPERATIONSCALE传1，2，3，4
						set:OperClass["一" OperClass="1"
						set:OperClass["二" OperClass="2"
						set:OperClass["三" OperClass="3"
						set:OperClass["四" OperClass="4"
					}
					
					set:OperClass'="" OperClass=$o(^ORC("CATEG",0,"Code",OperClass,""))
					set tSC=tDocument.EvaluateExpression("/Request/Body/OperationArrangeRt/OPERATIONS["_i_"]/OPERATION_PositionCode","text()",.tRes) 				
					if ($$$ISOK(tSC)&&(tRes.GetAt(1)'=""))
					{					
						set fieldValue=tRes.GetAt(1).Value
						set BodySite=$tr(fieldValue,$c(0),"")
					}
					set:OPERATIONSCALE'="" OPERATIONSCALE=$o(^ORC("CATEG",0,"Code",OPERATIONSCALE,""))
					set tSC=tDocument.EvaluateExpression("/Request/Body/OperationArrangeRt/OPERATIONS["_i_"]/OPERATION_CutType","text()",.tRes) 				
					if ($$$ISOK(tSC)&&(tRes.GetAt(1)'=""))
					{					
						set fieldValue=tRes.GetAt(1).Value
						set BladeType=$tr(fieldValue,$c(0),"")
					}
					set OperList=OperList_$c(1)_"RowId"_$c(0)_OperSchedule_$c(1)_"OperSchedule"_$c(0)_OperSchedule_$c(1)_"Operation"_$c(0)_Operation_$c(1)_"OperClass"_$c(0)_OperClass_$c(1)_"BladeType"_$c(0)_BladeType_$c(1)_"BodySite"_$c(0)_BodySite_$c(1)_"OperPos"_$c(0)_OperPos_$c(1)_"Note"_$c(0)_Note_$c(1)_"Surgeon"_$c(0)_Surgeon_$c(1)_"Assistant"_$c(0)_Assistant_$c(1)_"SurgeonDeptID"_$c(0)_SurgeonDeptID_$c(1)_"OperNo"_$c(0)_OperNo_$c(1)_"AddtionalStaff"_$c(0)_AddtionalStaff_$c(1)_"OperNote"_$c(0)_OperNote_$c(1)_"PostDiagnosis"_$c(0)_PostDiagnosis_$c(1)_"ExternalID"_$c(0)_OperSchedule_$c(1)_"ClassName"_$c(0)_"CIS.AN.OperList"
				}
			}
		}			
	}
	set dataPara="RowId"_$c(0)_OperSchedule_$c(1)_"EpisodeID"_$c(0)_EpisodeID_$c(1)_"ExternalID"_$c(0)_OperSchedule_$c(1)_"AppDeptID"_$c(0)_AppDeptID_$c(1)_"OperDeptID"_$c(0)_OperDeptID_$c(1)_"OperExecDeptID"_$c(0)_OperExecDeptID_$c(1)_"PatDeptID"_$c(0)_PatDeptID_$c(1)_"PatWardID"_$c(0)_PatWardID_$c(1)_"PatBedID"_$c(0)_PatBedID_$c(1)_"Status"_$c(0)_Status_$c(1)_"PrevDiagnosis"_$c(0)_PrevDiagnosis_$c(1)_"PrevAnaMethod"_$c(0)_PrevAnaMethod_$c(1)_"AppDate"_$c(0)_AppDate_$c(1)_"AppTime"_$c(0)_AppTime_$c(1)_"OperDate"_$c(0)_OperDate_$c(1)_"OperTime"_$c(0)_OperTime_$c(1)_"AppUserID"_$c(0)_AppUserID_$c(1)_"AppCareProvID"_$c(0)_AppCareProvID_$c(1)_"SourceType"_$c(0)_SourceType_$c(1)_"Anaesthesia"_$c(0)_Anaesthesia_$c(1)_"ReentryOperation"_$c(0)_ReentryOperation_$c(1)_"IsoOperation"_$c(0)_IsoOperation_$c(1)_"ECC"_$c(0)_ECC_$c(1)_"TransAutoblood"_$c(0)_TransAutoblood_$c(1)_"PrepareBlood"_$c(0)_PrepareBlood_$c(1)_"BloodType"_$c(0)_BloodType_$c(1)_"RHBloodType"_$c(0)_RHBloodType_$c(1)_"HbsAg"_$c(0)_HbsAg_$c(1)_"HcvAb"_$c(0)_HcvAb_$c(1)_"HivAb"_$c(0)_HivAb_$c(1)_"Syphilis"_$c(0)_Syphilis_$c(1)_"OperRequirement"_$c(0)_OperRequirement_$c(1)_"LabTest"_$c(0)_LabTest_$c(1)_"PatName"_$c(0)_PatName_$c(1)_"PatGender"_$c(0)_PatGender_$c(1)_"PatDOB"_$c(0)_PatDOB_$c(1)_"PatWeight"_$c(0)_PatWeight_$c(1)_"PatHeight"_$c(0)_PatHeight_$c(1)_"OperDuration"_$c(0)_OperDuration_$c(1)_"SurgicalMaterials"_$c(0)_SurgicalMaterials_$c(1)_"PlanSeq"_$c(0)_PlanSeq_$c(1)_"AppOrderItem"_$c(0)_AppOrderItem_$c(1)_"ExtAnaestID"_$c(0)_ExtAnaestID_$c(1)_"OperPosition"_$c(0)_OperPosition_$c(1)_"ExpertFlag"_$c(0)_ExpertFlag_$c(1)_"OriginalSchedule"_$c(0)_OriginalSchedule_$c(1)_"SeqType"_$c(0)_SeqType_$c(1)_"HighConsume"_$c(0)_HighConsume_$c(1)_"Antibiosis"_$c(0)_Antibiosis_$c(1)_"InfectionOper"_$c(0)_InfectionOper_$c(1)_"MIS"_$c(0)_MIS_$c(1)_"BodySite"_$c(0)_BodySite_$c(1)_"SurIntership"_$c(0)_SurIntership_$c(1)_"SurVisitors"_$c(0)_SurVisitors_$c(1)_"OperRoom"_$c(0)_OperRoom_$c(1)_"OperSeq"_$c(0)_OperSeq_$c(1)_"ScrubNurse"_$c(0)_ScrubNurse_$c(1)_"CircualNurse"_$c(0)_CircualNurse_$c(1)_"InternshipNurse"_$c(0)_InternshipNurse_$c(1)_"ClassName"_$c(0)_"CIS.AN.OperSchedule"
	set dataPara=dataPara_$c(2)_"RowId"_$c(0)_OperSchedule_$c(1)_"OperSchedule"_$c(0)_OperSchedule_$c(1)_"AnaMethod"_$c(0)_AnaMethod_$c(1)_"AnaExpert"_$c(0)_AnaExpert_$c(1)_"Anesthesiologist"_$c(0)_Anesthesiologist_$c(1)_"AnaAssistant"_$c(0)_AnaAssistant_$c(1)_"AnaStaff"_$c(0)_AnaStaff_$c(1)_"AreaInDT"_$c(0)_AreaInDT_$c(1)_"AreaOutDT"_$c(0)_AreaOutDT_$c(1)_"TheatreInDT"_$c(0)_TheatreInDT_$c(1)_"TheatreOutDT"_$c(0)_TheatreOutDT_$c(1)_"AnaStartDT"_$c(0)_AnaStartDT_$c(1)_"AnaFinishDT"_$c(0)_AnaFinishDT_$c(1)_"TubeInDT"_$c(0)_TubeInDT_$c(1)_"TubeOutDT"_$c(0)_TubeOutDT_$c(1)_"OperStartDT"_$c(0)_OperStartDT_$c(1)_"OperFinishDT"_$c(0)_OperFinishDT_$c(1)_"PACUInDT"_$c(0)_PACUInDT_$c(1)_"PACUOutDT"_$c(0)_PACUOutDT_$c(1)_"ASAClass"_$c(0)_ASAClass_$c(1)_"AnaClass"_$c(0)_AnaClass_$c(1)_"PreFasting"_$c(0)_PreFasting_$c(1)_"PreOperNote"_$c(0)_PreOperNote_$c(1)_"PreMedication"_$c(0)_PreMedication_$c(1)_"OperPosition"_$c(0)_OperPosition_$c(1)_"ECGDoctor"_$c(0)_ECGDoctor_$c(1)_"TotalIn"_$c(0)_TotalIn_$c(1)_"ColloidalVol"_$c(0)_ColloidalVol_$c(1)_"CrystalloidVol"_$c(0)_CrystalloidVol_$c(1)_"TotalOut"_$c(0)_TotalOut_$c(1)_"UrineVol"_$c(0)_UrineVol_$c(1)_"WaterLossVol"_$c(0)_WaterLossVol_$c(1)_"BloodLossVol"_$c(0)_BloodLossVol_$c(1)_"TheatreOutTransLoc"_$c(0)_TheatreOutTransLoc_$c(1)_"AreaOutTransLoc"_$c(0)_AreaOutTransLoc_$c(1)_"OutRoomAna"_$c(0)_OutRoomAna_$c(1)_"AppDocConNo"_$c(0)_AppDocConNo_$c(1)_"ShiftDoctor"_$c(0)_ShiftDoctor_$c(1)_"Pneumothorax"_$c(0)_Pneumothorax_$c(1)_"Pneumoperitoneum"_$c(0)_Pneumoperitoneum_$c(1)_"ClassName"_$c(0)_"CIS.AN.Anaesthesia"
	set dataPara=dataPara_$c(2)_$p(OperList,"#"_$c(1),2)
	set userId=""
	;s ret=##class(CIS.AN.BL.OperApplication).SaveRegister(dataPara,userId)
	s ret=##class(CIS.AN.SRV.OperAppService).SaveRegisterExt(dataPara,userId)
	if $p(ret,"^",1)="S"
	{
		set responseBody.ResultCode=0
		set responseBody.ResultContent="成功"
		}else{
			set responseBody.ResultCode=-1
			set responseBody.ResultContent=ret
			}
	set Response.Respbody=responseBody
    d Response.XMLExportToStream(.stream)
    q stream
    
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

ClassMethod GetCareProcRowId(UserCode As %String) As %String
{
	set $zt="Exception"
	set UserRowId=""
	if ($d(^CTPCP(0,"Code",$$ALPHAUP^SSUTIL4(UserCode))))
	{
		set UserRowId=$o(^CTPCP(0,"Code",$$ALPHAUP^SSUTIL4(UserCode),""))
	}
	Quit UserRowId
Exception
	Quit ""
}

/// w ##class(web.DHCENS.STBLL.OPERATION.Method.PostOperationRegister).test()
ClassMethod test() As %String
{
	s input="<Request> <Header> <SourceSystem>SYS0004</SourceSystem> <MessageID>20210314163215125</MessageID> </Header> <Body> <OperationArrangeRt> <PATPatientID>0000000001</PATPatientID> <PAADMVisitNumber>64</PAADMVisitNumber> <SCHEDULE_ID>12</SCHEDULE_ID><OPERATIONS> <OPERATION_NO>1</OPERATION_NO> <OPERATION>三根冠状动脉的(主动脉)冠状动脉旁路移植</OPERATION> <OPERATION_CODE>36.1300</OPERATION_CODE> </OPERATIONS><DEPT_STAYED>KS0001</DEPT_STAYED> <BED_NO>01008</BED_NO> <SCHEDULED_DATE_TIME>2021-03-14 08:00:00</SCHEDULED_DATE_TIME> <OPERATING_ROOM>KS0118</OPERATING_ROOM> <OPERATING_ROOM_NO>5号间</OPERATING_ROOM_NO> <SEQUENCE>0</SEQUENCE> <DIAG_BEFORE_OPERATION>结核性视神经蛛网膜炎</DIAG_BEFORE_OPERATION> <PATIENT_CONDITION></PATIENT_CONDITION> <OPERATION_SCALE>一级手术</OPERATION_SCALE> <EMERGENCY_INDICATOR>1</EMERGENCY_INDICATOR> <ISOLATION_INDICATOR>0</ISOLATION_INDICATOR> <OPERATING_DEPT>KS0001</OPERATING_DEPT> <SURGEON>200001</SURGEON> <FIRST_ASSISTANT>010009</FIRST_ASSISTANT> <SECOND_ASSISTANT></SECOND_ASSISTANT> <THIRD_ASSISTANT></THIRD_ASSISTANT> <FOURTH_ASSISTANT></FOURTH_ASSISTANT> <ANESTHESIA_METHOD>腰硬联合麻醉</ANESTHESIA_METHOD> <ANESTHESIA_DOCTOR>201239</ANESTHESIA_DOCTOR> <SECOND_ANESTHESIA_DOCTOR></SECOND_ANESTHESIA_DOCTOR> <THIRD_ANESTHESIA_DOCTOR></THIRD_ANESTHESIA_DOCTOR> <ANESTHESIA_ASSISTANT></ANESTHESIA_ASSISTANT> <SECOND_ANESTHESIA_ASSISTANT></SECOND_ANESTHESIA_ASSISTANT> <THIRD_ANESTHESIA_ASSISTANT></THIRD_ANESTHESIA_ASSISTANT> <FOURTH_ANESTHESIA_ASSISTANT></FOURTH_ANESTHESIA_ASSISTANT> <BLOOD_TRAN_DOCTOR></BLOOD_TRAN_DOCTOR> <FIRST_OPERATION_NURSE>200735</FIRST_OPERATION_NURSE> <SECOND_OPERATION_NURSE></SECOND_OPERATION_NURSE> <FIRST_SUPPLY_NURSE>201563</FIRST_SUPPLY_NURSE> <SECOND_SUPPLY_NURSE></SECOND_SUPPLY_NURSE> <THIRD_SUPPLY_NURSE></THIRD_SUPPLY_NURSE> <NOTES_ON_OPERATION></NOTES_ON_OPERATION> <REQ_DATE_TIME>2021-03-14 15:50:59</REQ_DATE_TIME> <ENTERED_BY>200001</ENTERED_BY><STATUS>F</STATUS><QieKouNumber></QieKouNumber> <QieKouClass></QieKouClass> <AsaGrade>Ⅰ</AsaGrade> <BloodTransfered>N</BloodTransfered> <BloodLossed>0</BloodLossed> <ItemName>N</ItemName> <Dosage>0</Dosage> <StartDateTime>2021-03-14 15:20:00</StartDateTime> <EndDateTime>2021-03-14 17:00:00</EndDateTime></OperationArrangeRt> </Body> </Request>"
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write(input)
	s aa=..SendPostOperRegInfo(stream).Read()
	
	q aa
}

}
