Class DHCBP.Arrange Extends web.DHCClinicCom
{

// w ##class(DHCBP.Arrange).Get(5)

ClassMethod Get(arrangeId)
{
	//s param={}.%FromJSON(param)
	//s arrangeId=param.arrangeId
	s curCode=""
	//s json={}
	//s json=$LISTBUILD()
	s json=##class(%Library.ArrayOfDataTypes).%New()
	// 获取扩展表数据
	For{
		s curCode=$O(^DHCBPArrangeExtend(0,"BPACode",arrangeId,curCode))
		q:curCode=""
		s rowId=$O(^DHCBPArrangeExtend(0,"BPACode",arrangeId,curCode,""))
		s extend=##class(User.DHCBPArrangeExtend).%OpenId(rowId)
		if (extend.BPAEValue'=""){
			//d json.%Set(extend.BPAEBPCAECode,extend.BPAEValue)
			d AddJson(extend.BPAEBPCAECode,extend.BPAEValue,"%Float")
		}
		else {
			// d json.%Set(extend.BPAEBPCAECode,extend.BPAENote)
			d AddJson(extend.BPAEBPCAECode,extend.BPAEValue,"%String")
		}
	}
	// 获取Arrange表数据
	Set cdef = ##class(%Dictionary.ClassDefinition).%OpenId("User.DHCBPArrange")
	Set count = cdef.Properties.Count()
	s arrange=##class(User.DHCBPArrange).%OpenId(arrangeId)
	s clsMethods=cdef.Methods.Count()
	For i = 1:1:count {
		Set propertyName=cdef.Properties.GetAt(i).Name
		Set type=cdef.Properties.GetAt(i).Type
		//w type,!
		s value=$PROPERTY(arrange,propertyName)
		s value=..ToString(value,type)
		s name=$Replace(propertyName,"BPA","")
		if ((type="%Date")||(type="%Time")) s type="%String"
		if (type'["User."){
			//d json.%Set(name,value)
			d AddJson(name,value,type)
		}
		
    }
	q $$ToJson()
AddJson(name,value,type)
   //d json.%Set(name,value)
   d json.SetAt(value,name)
   s JSONArray(name)=value
   s JSONArray(name,"type")=type
ToJson()
   s sub=""
   s jsonStr="{"
   For{
	   s sub=$O(JSONArray(sub))
	   q:sub=""
	   s type=JSONArray(sub,"type")
	   s value=JSONArray(sub)
	   if (type'="%String"){
	     s curItem=""""_sub_""":"_+value
	   }
	   else{
		   s curItem=""""_sub_""":"""_value_""""
	   }
	   if (jsonStr="{"){
		   s jsonStr=jsonStr_curItem
	   }
	   else{
		   s jsonStr=jsonStr_","_curItem
	  }
   }
   q jsonStr_"}"
}

ClassMethod ToString(value, type)
{
	s newValue=value
	if (type="%Date"){
	   set newValue=..ConvertToDate(value)
	}
	elseif (type="%Time"){
		set newValue=..ConvertToTime(value)
	}
	elseif (type="%Time"){
		set newValue=..ConvertToTime(value)
	}
	
	q newValue
}

ClassMethod Set(paramStr)
{
	s ExtendStr=""
	s ArrangeParamStr=""
	// 旧版本
	// s obj=##class(Nur.JSON).Decode(json)
	// w obj.GetAt("WardRoundTime")
	// %Library.ArrayOfDataTypes
	// ItemArray.Next("") 通过Next可以循环所有属性
	//s obj={}.%FromJSON(paramStr)
	s obj=##class(Nur.JSON).Decode(paramStr)
	s arrangeId=obj.GetAt("ArrangeId")
	q:arrangeId="" "数据未效"
	set iter = obj.%GetIterator()
	Set cdef = ##class(%Dictionary.ClassDefinition).%OpenId("User.DHCBPArrange")
	Set count = cdef.Properties.Count()
	s arrange=##class(User.DHCBPArrange).%OpenId(arrangeId)
	while iter.%GetNext(.key,.value) {
		b //////
	  if ((";"_ExtendStr_";")[(";"_key_";")){
		  s rowId=##class(DHCBP.ArrangeExtend).Save(arrangeId,key,value,value,"")
	  }
	  else{
		  s name="BPA"_key
		  
		  For i = 1:1:count {
		     Set propertyName=cdef.Properties.GetAt(i).Name
		     if (propertyName=name){
			     b //
			     Set $PROPERTY(arrange,propertyName)=value
			 }
		  }

      }
	}
	b
    d arrange.%Save()
	q 0
}

ClassMethod ArrangeBed(paramStr)
{
	//s obj={}.%FromJSON(paramStr)
	s obj=##class(Nur.JSON).Decode(paramStr)
	q:obj.GetAt("ArrangeId") "安排表ID为空"
	s arrange=##class(User.DHCBPArrange).%OpenId(obj.GetAt("ArrangeId"))
    // s registerId=$p(bedArrangePara,$c(3),2)
    //q:registerId="" "登记表id为空"	    
    //i (registerId'="") s arrange.BPABPPatRegisterDr=##class(User.DHCBPPatRegister).%OpenId(registerId)
    // s arrange.BPAAdmDr=$p(bedArrangePara,$c(3),3)
    s arrangeDate=obj.GetAt("ArrangeDate")
    s daySeqNo=obj.GetAt("SeqNO")
   
    s bedId=obj.GetAt("BedId")
    s bedIsArranged=1
    s status=$p(bedArrangePara,$c(3),10)
    i bedId'="" d
    .s bedIsArranged=##class(web.DHCBPArrange).GetBedIsArranged(arrangeDate,daySeqNo,bedId)
    e  d 
    .s arrange.BPAStatus="A"  
    .s arrange.BPABPCBedDr=""  
    i 'bedIsArranged d
    .s arrange.BPABPCBedDr=##class(User.DHCBPCBed).%OpenId(bedId)
    .s bpBedEquipDr=$o(^DHCBPBedEquip(0,"Bed",+bedId,"")) //净化设备
    .s bpEquipDr=$lg($g(^DHCBPBedEquip(+bpBedEquipDr)),2)
    .s arrange.BPABPCEquipDr=##class(User.DHCBPCEquip).%OpenId(bpEquipDr)    
    .s arrange.BPAStatus=status   
    d arrange.%Save()
    s result=arrange.%Id()
    q result
}

// w ##class(DHCBP.Arrange).GetNowArrange(8,119,"N")

/// 获取当天病人透析记录
ClassMethod GetNowArrange(registerId, locId, patRegStatus)
{
	s locIdList=##Class(web.DHCBPCom).GetLinkLocByLocId(locId) //科室关联
	
	s fromDate=##class(web.DHCClinicCom).ConvertToDateH($h)
	s toDate=##class(web.DHCClinicCom).ConvertToDateH($h)
	s bpaId=""
	q:registerId=""
	s result=""
	f  s bpaId=$o(^DHCBPArrange(0,"PatRegister",registerId,bpaId)) q:bpaId=""  d
	.q:bpaId=""
	.s bpprId=$lg(^DHCBPArrange(bpaId),1)
	.q:bpprId="" 
	.s admId=$lg(^DHCBPPatRegister(bpprId),26)
	.q:admId=""
	.s admDeptId=$p($g(^PAADM(admId)),"^",4)
	.;s bpprPatDeptDr=$lg(^DHCBPPatRegister(bpprId),30)
	.s bpprPatLocationDr=$lg(^DHCBPPatRegister(bpprId),34)	
    .q:((locId'="")&&(bpprPatLocationDr'="")&&($p($g(^CTLOC(locId)),"^",22)'=$p($g(^CTLOC(bpprPatLocationDr)),"^",22)))  //病人所在医院判断
   	.q:(bpprPatLocationDr'="")&&(locIdList'="")&&(("^"_locIdList_"^")'[("^"_bpprPatLocationDr_"^"))
    .s bpsId=$lg(^DHCBPArrange(bpaId),3)
    .q:bpsId=""
	.s bpprStatus=$lg(^DHCBPPatRegister(bpprId),14)
	.//;i bpprId=118 w bpprStatus_"/"_patRegStatus,!
	.q:(patRegStatus'="")&&("^"_patRegStatus_"^"'[bpprStatus) //通过ArrangeId查询某个病人,不再判断方案状态
	.i bpprStatus="N" s bpprStatus="治疗"
	.i bpprStatus="D" s bpprStatus="转归"	
	.s bpprPatBPNo=$lg(^DHCBPPatRegister(bpprId),17)
	.s bpprPatType=$lg(^DHCBPPatRegister(bpprId),25)
	.s papmiId=$lg(^DHCBPPatRegister(bpprId),1)
	.q:papmiId="" 
	.q:'$d(^PAPER(papmiId,"PAT",1)) 
	.s bpaDate=$lg(^DHCBPArrange(bpaId),4)
	.s bpaTime=$lg(^DHCBPArrange(bpaId),5)
	.q:(bpaDate'="")&(bpaDate>toDate)
	.q:(bpaDate'="")&(bpaDate<fromDate)
	.s bpaDaySeqNo=""
	.s bpaDaySeqNo=$lg(^DHCBPArrange(bpaId),6)	
	.s bpaBPCBedDr=$lg(^DHCBPArrange(bpaId),7)
	.s bpaBPCBedDesc=$lg($g(^DHCBPC("Bed",+bpaBPCBedDr)),2)
	.s bpcBedGroupDr=$lg($g(^DHCBPC("Bed",+bpaBPCBedDr)),3)
	.s bpcBedGroupDesc=$lg($g(^DHCBPC("BedGroup",+bpcBedGroupDr)),2)
	.s bpaEquipDr=$lg(^DHCBPArrange(bpaId),25) //净化设备
	.s bpaEquipDesc=$lg($g(^DHCBPC("Equip",+bpaEquipDr)),3)	
	.s bpaArrangeType=$lg(^DHCBPArrange(bpaId),8)
	.s bpaStatus=$lg(^DHCBPArrange(bpaId),9)	
	.q:bpaStatus="" 
	.q:bpaStatus="D" 
	.s result=bpaId
	
	
    q result
}

}
