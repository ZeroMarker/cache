Import SQLUser

/// 获取透后数据:GetAfterDialysis
/// 添加医生透后数据:SaveDocEndAfterDialysis
/// 添加护士透后数据:SaveNurseAfterDialysis
Class DHCBP.AfterDialysis Extends web.DHCClinicCom
{

// w ##class(DHCBP.AfterDialysis).GetAfterDialysis(901)

ClassMethod GetAfterDialysis(arrangeId)
{
   //s ^tem("20190905")=arrangeId
	set arrange=##class(User.DHCBPArrange).%OpenId(arrangeId)
	//set json={}
	set json=##class(%Library.ArrayOfDataTypes).%New() 
	
	FOR i = "EndWeight", "StartWeight","EndDiastolicPressure","Grume","EndHeartRate","ReturnSalineAmount","EndSystolicPressure","BPSchemeAdjustment","DiseaseTreatment","TherapyDuration","EquipRunEffect","VascularAccessStatus","Note","PlanTherapyDuration","FilterReplaceAmount","DFR","EndOperationNurseDr","EndUpdateDocDr","SubtractiveWeight"{
		  s name="BPA"_i 
		  set value=$PROPERTY(arrange,name)
		  
		  if (i="TherapyDuration"){
			  S hour = value \ 60
			  do AddJson("TherapyDurationHr",hour)
              S min = value # 60
              do AddJson("TherapyDurationMin",$fn(min,"",1))
			  }
		  elseif ((i="EndOperationNurseDr")&&(value'="")){
	    	s obj=##class(User.CTCareProv).%OpenId(value)
	    	s EndOperationNurse=obj.CTPCPDesc
    		d json.SetAt(EndOperationNurse,"EndOperationNurse")
	     }
	     elseif ((i="EndUpdateDocDr")&&(value'="")){
	    	s obj=##class(User.CTCareProv).%OpenId(value)
	    	s EndUpdateDoc=obj.CTPCPDesc
    		d json.SetAt(EndUpdateDoc,"EndUpdateDoc")
	     }
	     elseif ((i="SubtractiveWeight")&&(value'="")){
		     
	    	d AddJson(i,$fn(value,"",1))
	     }
	     else{
		     if (value>0){
			  d AddJson(i,$fn(value,"",1))
		  	}
    	  	else {
	    	  do AddJson(i,value)
	      	} 
		 }
    	  
 	}
 	set value=arrange.BPABPCBPModeDr
 	do AddJson("BPCBPModeDr",value.%Id())
 	if (value'=""){
	    	set BloodPurificationMode=##class(User.DHCBPCBloodPurificationMode).%OpenId(value.%Id())
	    	
	    	set BPCBPMDescValue=BloodPurificationMode.BPCBPMDesc
	    	if (arrange.BPASecondBPCBPModeDr'=""){
		    	set BloodPurificationMode=##class(User.DHCBPCBloodPurificationMode).%OpenId(arrange.BPASecondBPCBPModeDr.%Id())
	    	
	    		set BPCBPSecondMDescValue=BloodPurificationMode.BPCBPMDesc
	    		set BPCBPMDescValue=BPCBPMDescValue_"+"_BPCBPSecondMDescValue
		    	}
	    	do AddJson("BPCBPMDesc",BPCBPMDescValue)
    	}
    //set StartWeightValue=arrange.BPAStartWeight
    //set EndWeightValue=arrange.BPAEndWeight
    //do AddJson("lostWeight",StartWeightValue-EndWeightValue)
    
 	set BedDr=arrange.BPABPCBedDr
 	if (BedDr'=""){
	    	set Bed=##class(User.DHCBPCBed).%OpenId(BedDr.%Id())
	    	set BPCBDescValue=Bed.BPCBDesc
	    	do AddJson("BPCBDesc",BPCBDescValue)
    	}
    set ChangedConsumableId="",ChangedConsumableDesc="",ChangedConsumableAmount="",ReplacedPipeId="",ReplacedPipeDesc="",ReplacedPipeAmount=""
    set ArrangeConsumableId=""
    For{
	    set ArrangeConsumableId=$O(^DHCBPArrangeConsumable(0,"Arrange",arrangeId,ArrangeConsumableId))
		quit:ArrangeConsumableId="" 
		set ArrangeConsumable=##class(User.DHCBPArrangeConsumable).%OpenId(ArrangeConsumableId)
	    //quit:(ArrangeConsumable.BPACIfAbandon'="")&(ArrangeConsumable.BPACIfAbandon="Y")
	    if (ArrangeConsumable.BPACType="R")&(ArrangeConsumable.BPACIfAbandon="N"){
		    set Consumable=##class(User.DHCBPCConsumable).%OpenId(ArrangeConsumable.BPACBPCConsumableDr.%Id())
		    
	    	if (Consumable.BPCCType'="O"){
		    	set ChangedConsumableId=ArrangeConsumable.BPACBPCConsumableDr.%Id()
		    	set ChangedConsumableDesc=Consumable.BPCCDesc
		    	set ChangedConsumableAmount=ArrangeConsumable.BPACAmount
			}
			else {
				set ReplacedPipeId=ArrangeConsumable.BPACBPCConsumableDr.%Id()
		    	set ReplacedPipeDesc=Consumable.BPCCDesc
				set ReplacedPipeAmount=ArrangeConsumable.BPACAmount
			}
		    do AddJson("ChangedConsumableId",ChangedConsumableId)
			do AddJson("ChangedConsumable",ChangedConsumableDesc)
			do AddJson("ChangedConsumableAmount",ChangedConsumableAmount)
			do AddJson("ReplacedPipeId",ReplacedPipeId)
	    	do AddJson("ReplacedPipe",ReplacedPipeDesc)
			do AddJson("ReplacedPipeAmount",ReplacedPipeAmount)
		 }
    }
    s curCode=""
	For{
		s curCode=$O(^DHCBPArrangeExtend(0,"BPACode",arrangeId,curCode))
		q:curCode=""
		s rowId=$O(^DHCBPArrangeExtend(0,"BPACode",arrangeId,curCode,""))
		s extend=##class(User.DHCBPArrangeExtend).%OpenId(rowId)
		
		if (extend.BPAEValue'=""){
			//d json.%Set(extend.BPAEBPCAECode,extend.BPAEValue)
			if (+extend.BPAEValue=extend.BPAEValue){
				do AddJson(extend.BPAEBPCAECode,$fn(extend.BPAEValue,"",1))
			}
			else {
				do AddJson(extend.BPAEBPCAECode,extend.BPAEValue)
			}
		}
		else {
			do AddJson(extend.BPAEBPCAECode,extend.BPAENote)
			//d json.%Set(extend.BPAEBPCAECode,extend.BPAENote)
		}
	}
	if ($d(^DHCBPArrangeExtend(0,"BPACode",arrangeId,"PatientEndSubtractiveWeight"))=0){
		do AddJson("PatientEndSubtractiveWeight",$fn($PROPERTY(arrange,"BPASubtractiveWeight"),"",2))
	}

	q ##class(Nur.JSON).Encode(json)
	
AddJson(name,value)
   //d json.%Set(name,value)
   d json.SetAt(value,name)
}

/// w ##class(DHCBP.AfterDialysis).SaveDocEndAfterDialysis("{""ArrangeId"":5,""EndWeight"":""60"",""EndDiastolicPressure"":""70"" ,""EndSystolicPressure"":""60"",""EndHeartRate"":""20"",""BPSchemeAdjustment"":""ASDADS"",""DiseaseTreatment"":""ASDADASD"",""EndUpdateDocDr"":""22"",""DocEndUpdateDate"":""2019-04-15"",""DocEndUpdateTime"":""18:55:15"",""VascularAccessStatus"":""正常""}")
/// s arrangePara:"{""ArrangeId"":5,""EndWeight"":""2019-04-15"",""EndDiastolicPressure"":""70"" ,""EndWeight"":""2019-04-15"",""EndDiastolicPressure"":""70"",""EndWeight"":""2019-04-15"",""EndDiastolicPressure"":""70"",""EndWeight"":""2019-04-15"",""EndDiastolicPressure"":""70"",""EndWeight"":""2019-04-15"",""EndDiastolicPressure"":""70"",""EndWeight"":""2019-04-15"",""EndDiastolicPressure"":""70""}"
ClassMethod SaveDocEndAfterDialysis(arrangePara)
{
	//s obj={}.%FromJSON(arrangePara)
	s obj=..ToJsonObj(arrangePara)
	//obj.GetAt("Role")
	s arrange=##class(User.DHCBPArrange).%OpenId(obj.GetAt("ArrangeId"))		
	//透后体重
	s arrange.BPAEndWeight=obj.GetAt("EndWeight")
    // 透析后舒张压
    s arrange.BPAEndDiastolicPressure=obj.GetAt("EndDiastolicPressure")
    /// 透析后收缩压
    s arrange.BPAEndSystolicPressure=obj.GetAt("EndSystolicPressure")
    /// 透析后心率
    s arrange.BPAEndHeartRate=obj.GetAt("EndHeartRate")
    //透析方案调整
    s arrange.BPABPSchemeAdjustment=obj.GetAt("BPSchemeAdjustment")
    //病情处理记录
    s arrange.BPADiseaseTreatment=obj.GetAt("DiseaseTreatment")
    //s arrange.BPAPlanFilterReplaceAmount=obj.GetAt("PlanFilterReplaceAmount")
    s arrange.BPAEndUpdateDocDr=obj.GetAt("careProvId")
    s arrange.BPADocEndUpdateDate=##class(web.DHCClinicCom).ConvertToDateH(+$H)
    s arrange.BPADocEndUpdateTime=##class(web.DHCClinicCom).ConvertToTimeH($P($H,",",2))
    //s arrange.BPAVascularAccessStatus=obj.VascularAccessStatus
    s saveStatus=arrange.%Save()
	q:(+saveStatus=0) "保存数据失败!"	
    s result=arrange.%Id()
    d arrange.%Close()
    if (obj.GetAt("PatientEndSubtractiveWeight")'="") s rest=##class(DHCBP.ArrangeExtend).Save(result,"PatientEndSubtractiveWeight",obj.GetAt("PatientEndSubtractiveWeight"),"",obj.GetAt("userId"))
    
    //d ##class(web.DHCBPCom).StopEquipCollect(obj.ArrangeId)
	q result
}

/// d ##class(DHCBP.AfterDialysis).SaveNurseAfterDialysis("{""ArrangeId"":5,""EndWeight"":""70"",""lostWeight"":""-15"",""EndDiastolicPressure"":""85"",""EndSystolicPressure"":""65"",""EndHeartRate"":""22"",""BPSchemeAdjustment"":""123131"",""DiseaseTreatment"":""345"",""BPCBPMDesc"":""HDF血液透析滤过+HDF血液透析滤过"",""BPCBPModeDr"":""1"",""BPCBDesc"":""床位3"",""TherapyDuration"":""4"",""DFR"":""23"",""PlanFilterReplaceAmount"":""22"",""ReturnSalineAmount"":""2"",""Grume"":""正常"",""ChangedConsumable"":""置换液管"",""ChangedConsumableId"":""49"",""ChangedConsumableAmount"":""1"",""ReplacedPipe"":""HIPS18"",""ReplacedPipeId"":""15"",""ReplacedPipeAmount"":""1"",""EquipRunEffect"":""正常"",""VascularAccessStatus"":""正常"",""Note"":""we"",""Status"":""F"",""userId"":1,""locId"":""22""}","{""consumable"":[{""Id"":"""",""consumableId"":""49"",""ConsumableAmount"":""1"",""Type"":""R""},{""Id"":"""",""consumableId"":""15"",""ConsumableAmount"":""1"",""Type"":""R""}]}")
ClassMethod SaveNurseAfterDialysis(arrangePara, consumableBusinessPara)
{
	//s obj={}.%FromJSON(arrangePara)
	s obj=..ToJsonObj(arrangePara)
	s arrangeId=obj.GetAt("ArrangeId")
	TSTART
	s arrange=##class(User.DHCBPArrange).%OpenId(arrangeId)	
	s arrange.BPAStatus=obj.GetAt("Status")
	s arrange.BPATherapyDuration=obj.GetAt("TherapyDuration")
	s arrange.BPAFilterReplaceAmount=obj.GetAt("FilterReplaceAmount")
    //s arrange.BPACirculatingNurseCtcpDr=obj.CirculatingNurseCtcpDr
    s arrange.BPACloseNurseCtcpDr=obj.GetAt("CloseNurseCtcpDr")
    s arrange.BPAEquipRunEffect=obj.GetAt("EquipRunEffect")
    s arrange.BPAGrume=obj.GetAt("Grume")
    s arrange.BPAPipeGrume=obj.GetAt("PipeGrume")
    //回输盐水总量
    s arrange.BPAReturnSalineAmount=obj.GetAt("ReturnSalineAmount")
    s arrange.BPADFR=obj.GetAt("DFR")
    s arrange.BPAVascularAccessStatus=obj.GetAt("VascularAccessStatus")
    s arrange.BPANote=obj.GetAt("Note")
    s arrange.BPADiseaseTreatment=obj.GetAt("DiseaseTreatment")
    s arrange.BPAEndOperationNurseDr=obj.GetAt("careProvId")
    s arrange.BPAEndOperationDate=##class(web.DHCClinicCom).ConvertToDateH(+$H)
    s arrange.BPAEndOperationTime=##class(web.DHCClinicCom).ConvertToTimeH($P($H,",",2))
    
    //s endDate=obj.EndDate
    //i endDate'="" s arrange.BPAEndDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
    //s endTime=obj.EndTime
    //i endTime'="" s arrange.BPAEndTime=##class(web.DHCClinicCom).ConvertToTimeH(endTime)
    //s arrange.BPAEndOperationNurseDr=obj.EndOperationNurseDr 
    //s updateDate=obj.EndOperationDate
    //i updateDate'="" s arrange.BPAEndOperationDate=##class(web.DHCClinicCom).ConvertToDateH(updateDate)
    //s updateTime=obj.EndOperationTime
    //i updateTime'="" s arrange.BPAEndOperationTime=##class(web.DHCClinicCom).ConvertToTimeH(updateTime)
    s saveStatus=arrange.%Save()
	i +saveStatus=0 TROLLBACK  q "保存数据失败!"
    s rowId=arrange.%Id()
    d arrange.%Close()
    if (obj.GetAt("DialyzerGrume")'="") s rest=##class(DHCBP.ArrangeExtend).Save(rowId,"DialyzerGrume",obj.GetAt("DialyzerGrume"),"",obj.GetAt("userId"))
    
    //TCOMMIT
    //TSTART
    s result=##class(DHCBP.Consumable).SaveArrangeConsumableList(rowId,consumableBusinessPara)   
    i +result'="1" TROLLBACK  q "保存透析耗材错误"
    TCOMMIT
    q rowId
}

/// d ##class(DHCBP.AfterDialysis).SaveVitalSigns("5")
ClassMethod SaveVitalSigns(arrangeId)
{
	s arrange=##class(User.DHCBPArrange).%OpenId(arrangeId)	
	// 透析前舒张压
	s arrange.BPAStartDiastolicPressure=$$GetDataId(2,"")
    // 透析前收缩压
    s arrange.BPAStartSystolicPressure=$$GetDataId(1,"")
    /// 透析前心率
    s arrange.BPAStartHeartRate=$$GetDataId(3,"")
	// 透析后舒张压
	 s arrange.BPAEndDiastolicPressure=$$GetDataId(2,"desc")
    /// 透析后收缩压
    s arrange.BPAEndSystolicPressure=$$GetDataId(1,"desc")
    /// 透析后心率
    s arrange.BPAEndHeartRate=$$GetDataId(3,"desc")
    s saveStatus=arrange.%Save()
	q:(+saveStatus=0) "保存数据失败!"	
    s result=arrange.%Id()
    d arrange.%Close()
    b
	q result
GetDataId(RecordItemDr,desc)
    &sql(SELECT TOP 1 BPR_Qty into:value FROM DHC_BP_Record WHERE BPR_BPArrange_Dr=:arrangeId AND BPR_BPCRecordItem_Dr=:RecordItemDr
    ORDER BY BPR_StartTime desc)
    q value
}

}
