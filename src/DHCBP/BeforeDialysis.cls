Import User

/// 获取透前数据: Get
/// 保存透前数据: 
Class DHCBP.BeforeDialysis
{

/// 获取透析前数据
ClassMethod Get(arrangeId)
{
	// w ##class(DHCBP.BeforeDialysis).Get(1278)
	s arrange=##class(User.DHCBPArrange).%OpenId(arrangeId)
	s scheme=##class(User.DHCBPScheme).%OpenId(arrange.BPABPSchemeDr.%Id())
	
	s json=##class(%Library.ArrayOfDataTypes).%New()
	d json.SetAt("","PatName")
	//s json.PatName=""
	s curCode=""
	For{
		s curCode=$O(^DHCBPArrangeExtend(0,"BPACode",arrangeId,curCode))
		q:curCode=""
		s rowId=$O(^DHCBPArrangeExtend(0,"BPACode",arrangeId,curCode,""))
		s extend=##class(User.DHCBPArrangeExtend).%OpenId(rowId)
		if (extend.BPAEValue'=""){
			//d json.%Set(extend.BPAEBPCAECode,extend.BPAEValue)
			//d json.%Set(extend.BPAEBPCAECode,extend.BPAEValue)
			d json.SetAt(extend.BPAEValue,extend.BPAEBPCAECode)
		}
		else {
			// d json.%Set(extend.BPAEBPCAECode,extend.BPAENote)
			//d json.%Set(extend.BPAEBPCAECode,extend.BPAEValue)
			d json.SetAt(extend.BPAEValue,extend.BPAEBPCAECode)
		}
	}
	
	FOR i = "K","Na","Ca2","FilterReplaceMode","PlanFilterReplaceAmount","FirstHeparinAmount","PlanTherapyDuration","PlanDewaterAmount","DewaterAmount","IsolatedUltVolume","Temperature"{
		  s name="BPA"_i
    	  s value=$PROPERTY(arrange,name)
    	  i (i="PlanTherapyDuration"){
	    	  
	    	  S hour = value \ 60
			  do json.SetAt(hour,"PlanTherapyDurationHr")
              S min = $fn(value # 60,"",0)
              do json.SetAt(min,"PlanTherapyDurationMin")
	    	  
    	  }
    	  elseif(i="K")&&(value=""){
	    	  s value="2.5"
	    	  d json.SetAt(value,i)
	      }
	      elseif(i="Na")&&(value=""){
	    	  s value="138"
	    	  d json.SetAt(value,i)
	      }
	      elseif(i="Ca2")&&(value=""){
	    	  s value="1.5"
	    	  d json.SetAt(value,i)
	      }
	      elseif(i="Temperature")&&(value=""){
	    	  s value="37.0"
	    	  d json.SetAt(value,i)
	      }
    	  else {
	    	  i +value>0 d json.SetAt($fn(value,"",2),i)
	    	  e  d json.SetAt(value,i)

	      } 
    	  //d json.%Set(i,value)
 	}
 	Set arrangeClasDef = ##class(%Dictionary.ClassDefinition).%OpenId("User.DHCBPArrange")
 	
 	//生命体征
 	FOR i = "StartWeight","SubtractiveWeight","StartSystolicPressure","StartDiastolicPressure","StartHeartRate","BPMeasurePart","UrineVolume","StartSymptom","ClinicalEvaluationNote","CheckDocDr","DocOperateStatus","RecheckDocDr"{
		s name="BPA"_i
    	s value=$PROPERTY(arrange,name)
    	//d json.SetAt(value,i)
    	i +value>0 d json.SetAt($fn(value,"",2),i)
	    e  d json.SetAt(value,i)
    	if ((i="CheckDocDr")&&(value'="")){
	    	s obj=##class(User.CTCareProv).%OpenId(value)
	    	s BPACheckDoc=obj.CTPCPDesc
    		d json.SetAt(BPACheckDoc,"BPACheckDoc")
	    }
	    if ((i="RecheckDocDr")&&(value'="")){
	    	s obj=##class(User.CTCareProv).%OpenId(value)
	    	s BPARecheckDoc=obj.CTPCPDesc
    		d json.SetAt(BPARecheckDoc,"BPARecheckDoc")
	    }
    	//d json.%Set(i,value)
 	}
 	//透析方法
 	set value=arrange.BPABPCBPModeDr
 	if (value'=""){
		//do json.%Set("BPCBPModeDr",value.%Id())
		d json.SetAt(value.%Id(),"BPCBPModeDr")
	    set BloodPurificationMode=##class(User.DHCBPCBloodPurificationMode).%OpenId(value.%Id())
	    set BPCBPMDescValue=BloodPurificationMode.BPCBPMDesc
	    //do json.%Set("BPCBPModeDesc",BPCBPMDescValue)
	    d json.SetAt(BPCBPMDescValue,"BPCBPModeDesc")
	}
	set value=arrange.BPASecondBPCBPModeDr
 		if (value'=""){
 			//do json.%Set("SecondBPCBPModeDr",value.%Id())
 			d json.SetAt(value.%Id(),"SecondBPCBPModeDr")
	    	set BloodPurificationMode=##class(User.DHCBPCBloodPurificationMode).%OpenId(value.%Id())
	    	set BPCBPMDescValue=BloodPurificationMode.BPCBPMDesc
	    	d json.SetAt(BPCBPMDescValue,"SecondBPCBPModeDesc")
	    	//do json.%Set("SecondBPCBPModeDesc",BPCBPMDescValue)
		} 
	 
	//透析器材    	    	  
 	set value=arrange.BPABPCConsumableDr
 	if (value'=""){
	 	//do json.%Set("BPCConsumableDr",value.%Id())
	 	d json.SetAt(value.%Id(),"BPCConsumableDr")
	    set DHCBPCConsumable=##class(User.DHCBPCConsumable).%OpenId(value.%Id())
	    set BPCCDescValue=DHCBPCConsumable.BPCCDesc
	    //do json.%Set("BPCConsumableDesc",BPCCDescValue)
	    d json.SetAt(BPCCDescValue,"BPCConsumableDesc")
	    s consumableDataId=""
	    &SQL(SELECT BPAC_RowId into :consumableDataId FROM DHC_BP_ArrangeConsumable 
	where BPAC_BPArrange_Dr=:arrangeId and BPAC_Type="M")
		i SQLCODE="0" {
	    	//do json.%Set("BPCconsumableDataId",consumableDataId)
	    	d json.SetAt(consumableDataId,"BPCconsumableDataId")
		}
	}  
	else{
		s BPCConsumableDr="",consumableDataId=""
		&SQL(SELECT TOP 1 BPAC_RowId,BPAC_BPCConsumable_Dr into :consumableDataId,:BPCConsumableDr FROM DHC_BP_ArrangeConsumable 
	where BPAC_BPArrange_Dr=:arrangeId and BPAC_Type="M" and BPAC_IfAbandon <>"Y" order by BPAC_RowId desc)
		i SQLCODE="0" {
			d json.SetAt(BPCConsumableDr,"BPCConsumableDr")
			set DHCBPCConsumable=##class(User.DHCBPCConsumable).%OpenId(BPCConsumableDr)
	    	set BPCCDescValue=DHCBPCConsumable.BPCCDesc
	    	//do json.%Set("BPCConsumableDesc",BPCCDescValue)
	    	d json.SetAt(BPCCDescValue,"BPCConsumableDesc")
	    	d json.SetAt(consumableDataId,"BPCconsumableDataId")
		}
	}
	    
	set value=arrange.BPASecondBPCConsumableDr
 	if (value'=""){
	 	//do json.%Set("SecondBPCConsumableDr",value.%Id())
	 	d json.SetAt(value.%Id(),"SecondBPCConsumableDr")
	    set DHCBPCConsumable=##class(User.DHCBPCConsumable).%OpenId(value.%Id())
	    set BPCCDescValue=DHCBPCConsumable.BPCCDesc
	    //do json.%Set("SecondBPCConsumableDesc",BPCCDescValue)
	    d json.SetAt(BPCCDescValue,"SecondBPCConsumableDesc")
	    s SecondBPCConsumableDataId=""
	    &SQL(SELECT BPAC_RowId into :SecondBPCConsumableDataId FROM DHC_BP_ArrangeConsumable 
	where BPAC_BPArrange_Dr=:arrangeId and BPAC_Type="A" )
		i SQLCODE="0" {
	    	//do json.%Set("SecondBPCConsumableDataId",SecondBPCConsumableDataId)
	    	d json.SetAt(SecondBPCConsumableDataId,"SecondBPCConsumableDataId")
		}
	}
	else{
		s SecondBPCConsumableDr="",SecondBPCConsumableDataId=""
		&SQL(SELECT TOP 1 BPAC_RowId,BPAC_BPCConsumable_Dr into :SecondBPCConsumableDataId,:SecondBPCConsumableDr FROM DHC_BP_ArrangeConsumable 
	where BPAC_BPArrange_Dr=:arrangeId and BPAC_Type="A" and BPAC_IfAbandon <>"Y" order by BPAC_RowId desc)
		i SQLCODE="0" {
			d json.SetAt(SecondBPCConsumableDr,"SecondBPCConsumableDr")
			set DHCBPCConsumable=##class(User.DHCBPCConsumable).%OpenId(SecondBPCConsumableDr)
	    	set BPCCDescValue=DHCBPCConsumable.BPCCDesc
	    	//do json.%Set("BPCConsumableDesc",BPCCDescValue)
	    	d json.SetAt(BPCCDescValue,"SecondBPCConsumableDesc")
	    	d json.SetAt(SecondBPCConsumableDataId,"SecondBPCConsumableDataId")
			}
		
	} 
	    
	//血管通路arrange 
	set value=arrange.BPABPCVADr
 	if (value'=""){
	 	//do json.%Set("BPCVADr",value.%Id())
	 	d json.SetAt(value.%Id(),"BPCVADr")
	    set DHCBPCVascularAccess=##class(User.DHCBPCVascularAccess).%OpenId(value.%Id())
	    set BPCVADescValue=DHCBPCVascularAccess.BPCVADesc
	    //do json.%Set("BPCVADesc",BPCVADescValue)
	    d json.SetAt(BPCVADescValue,"BPCVADesc")
	     
		set value=arrange.BPAVABodySiteDr
 		if (value'=""){
			s VABodySiteDesc=$lg(^DHCCLC("BodySite",value),2)
			d json.SetAt(VABodySiteDesc,"VABodySiteDesc")
	    	d json.SetAt(value,"VABodySiteDr")
	    } 
	}    
    else {
	    s value=$PROPERTY(scheme,"BPSVascularAccessDr")
    	if (value'=""){
	    	//d json.%Set("VascularAccessDr",value)
	    	d json.SetAt(value,"VascularAccessDr")
	    	s VascularAccess=##class(User.DHCBPVascularAccess).%OpenId(value.%Id())
	    	s value=$PROPERTY(VascularAccess,"BPVBodySiteDr")
	    	if (value'=""){
		    	s VABodySiteDesc=$lg(^DHCCLC("BodySite",value),2)
		    	d json.SetAt(VABodySiteDesc,"VABodySiteDesc")
		    }
	    	//d json.%Set("VABodySiteDr",value)
	    	d json.SetAt(value,"VABodySiteDr")
	    	
	    	s value=$PROPERTY(VascularAccess,"BPVVascularAccessDr")
	    	//d json.%Set("BPCVADr",value.%Id())
	    	d json.SetAt(value.%Id(),"BPCVADr")
	    	set DHCBPCVascularAccess=##class(User.DHCBPCVascularAccess).%OpenId(value.%Id())
	        s value=$PROPERTY(DHCBPCVascularAccess,"BPCVADesc")
	        //do json.%Set("BPCVADesc",value)
	        d json.SetAt(value,"BPCVADesc")
	    	
    	}
    }
	     
 	FOR i = "PatDryWeight"{
		  s name="BPS"_i
    	  s value=$PROPERTY(scheme,name)
    	  //d json.%Set(i,value)
    	  d json.SetAt(value,i)
 	}
 	
	// 设置默认数据
	if ((arrange.BPAStatus="R") && (arrange.BPADocOperateStatus'="C")&&(arrange.BPADocOperateStatus'="R"))
	{
		FOR i = "BFR", "K","Na","Ca2","SubtractiveWeight","PatDryWeight","FilterReplaceMode","FilterReplaceAmount","FirstHeparinAmount","HeparinDose"{
		  s name="BPS"_i
    	  s value=$PROPERTY(scheme,name)
    	  if (i="PatDryWeight"){
	    	  d json.SetAt(value,"PatientDryWeight")
	    	 }
    	  //d json.%Set(i,value)
    	 else  {
	    	 d json.SetAt(value,i)
	    	 }
 		}
        
    	s value=$PROPERTY(scheme,"BPSAnticoagulantModeDr")
    	if (value'=""){
	    	//d json.%Set(i_"Id",value)
	    	d json.SetAt(value,"AnticoagulantModeDr")
	    	s antMode=##class(User.DHCBPCAnticoagulantMode).%OpenId(value.%Id())
	    	s value=$PROPERTY(antMode,"BPCAMDesc")
	    	//d json.%Set(i,value)
	    	d json.SetAt(value,i)
    	}
    	s schemeDr=arrange.BPABPSchemeDr.%Id()
    	s arrangeSchemeId="",therapyDuration="",filterReplaceMode="",filterReplaceAmount=""
    	&SQL(SELECT TOP 1 ID,BPAS_TherapyDuration,BPAS_FilterReplaceMode,BPAS_FilterReplaceAmount into :arrangeSchemeId,:therapyDuration,:filterReplaceMode,:filterReplaceAmount  FROM DHC_BP_ArrangeScheme 
		where BPAS_BPScheme_Dr=:schemeDr and BPAS_IfAbandon<>"Y" )
		b
		i SQLCODE="0" {
	    	  S hour = therapyDuration \ 60
			  do json.SetAt(hour,"PlanTherapyDurationHr")
              S min = $fn(therapyDuration # 60,"",0)
              do json.SetAt(min,"PlanTherapyDurationMin")
			  d json.SetAt(filterReplaceMode,"FilterReplaceMode")
			  d json.SetAt(filterReplaceAmount,"PlanFilterReplaceAmount")
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
			d json.SetAt(extend.BPAEValue,extend.BPAEBPCAECode)
		}
		else {
			d json.SetAt(extend.BPAENote,extend.BPAEBPCAECode)
			//d json.%Set(extend.BPAEBPCAECode,extend.BPAENote)
		}
	}
	
	//q json.%ToJSON()
	q ##class(Nur.JSON).Encode(json)
}

/// 获取透析方式
/// d ##class(%ResultSet).RunQuery("DHCBP.BeforeDialysis","FindBloodPurifMode",194,"N")
Query FindBloodPurifMode(locId As %String = "", isSpecial As %String = "N") As %Query(ROWSPEC = "Id:%String,Code:%String,Description:%String,IsSpecial:%String,LocationDr:%String")
{
}

ClassMethod FindBloodPurifModeExecute(ByRef qHandle As %Binary, locId As %String = "", isSpecial As %String = "N") As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	s locIdList=##Class(web.DHCBPCom).GetLinkLocByLocId(locId) //科室关联
	s tlocId=0
	f  s tlocId=$o(^DHCBP.Config.BPModeLocationI("Ctloc",tlocId)) q:tlocId=""  d
		.q:(locIdList'="")&&(("^"_locIdList_"^")'[("^"_tlocId_"^"))
		.s mlRowId=0
		.f  s mlRowId=$o(^DHCBP.Config.BPModeLocationI("Ctloc",tlocId,mlRowId)) q:mlRowId=""  d
			..s BPCModeRowId=$lg(^DHCBP.Config.BPModeLocationD(mlRowId),1)
			..s MLAliasDesc=$lg(^DHCBP.Config.BPModeLocationD(mlRowId),3)				
	    	..s Code=$lg(^DHCBPC("BloodPurificationMode",BPCModeRowId),1)	   
	    	..s Description=$lg(^DHCBPC("BloodPurificationMode",BPCModeRowId),2)
	    	..s LocationDr=$lg(^DHCBPC("BloodPurificationMode",BPCModeRowId),4)
	    	..s IsSpecial=$lg(^DHCBPC("BloodPurificationMode",BPCModeRowId),3)	
	    	..q:IsSpecial'=isSpecial
	    	..s Id=BPCModeRowId
	    	..d OutputRow1    
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
OutputRow1
	s Data=$lb(Id,Code,Description,IsSpecial,LocationDr)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindBloodPurifModeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBloodPurifModeOldExecute ]
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

ClassMethod FindBloodPurifModeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBloodPurifModeOldExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// 获取血管通路
/// d ##class(%ResultSet).RunQuery("web.DHCBPCVascularAccess","GetVascularAccessList")
Query GetVascularAccessList(locId As %String = "") As %Query(ROWSPEC = "Id:%String,Code:%String,Description:%String,LocationDr:%String")
{
}

ClassMethod GetVascularAccessListExecute(ByRef qHandle As %Binary, locId As %String = "") As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	s locIdList=##Class(web.DHCBPCom).GetLinkLocByLocId(locId) //科室关联
 	s tBPCVARowId=0
	f  s tBPCVARowId=$o(^DHCBPC("VascularAccess",tBPCVARowId)) q:tBPCVARowId=""  d
	    .s Code=$lg(^DHCBPC("VascularAccess",tBPCVARowId),1)
	    .q:Code=""
	    .s Description=$lg(^DHCBPC("VascularAccess",tBPCVARowId),2)
	    .q:Description=""
	    .s LocationDr=$lg(^DHCBPC("VascularAccess",tBPCVARowId),3)
	    .q:(LocationDr'="")&&(locIdList'="")&&(("^"_locIdList_"^")'[("^"_LocationDr_"^"))	   
	    .s Id=tBPCVARowId
	    .d OutputRow1
	    
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
OutputRow1
	s Data=$lb(Id,Code,Description,LocationDr)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetVascularAccessListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetVascularAccessListOldExecute ]
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

ClassMethod GetVascularAccessListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetVascularAccessListOldExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// 获取血管通路部位
/// d ##class(%ResultSet).RunQuery("web.DHCBPCVascularAccess","FindCLCBodySite")
Query FindCLCBodySite(locId As %String = "") As %Query(ROWSPEC = "Id:%String,Code:%String,Description:%String,LocationDr:%String")
{
}

ClassMethod FindCLCBodySiteExecute(ByRef qHandle As %Binary, locId As %String = "") As %Status
{
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	s locIdList=##Class(web.DHCBPCom).GetLinkLocByLocId(locId) //科室关联	
	s tRowId=0
	f  s tRowId=$o(^DHCCLC("BodySite",tRowId)) q:tRowId=""  d		
		.s tCode=$lg(^DHCCLC("BodySite",tRowId),1)
		.s tDesc=$lg(^DHCCLC("BodySite",tRowId),2)
		.s tlocDr=$lg(^DHCCLC("BodySite",tRowId),3)
		.q:(tlocDr'="")&&(locIdList'="")&&(("^"_locIdList_"^")'[("^"_tlocDr_"^"))
		.d OutputRow2
	s qHandle=$lb(0,repid,0)
	q $$$OK

OutputRow2
	s Data=$lb(tRowId,tCode,tDesc,tlocDr)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod FindCLCBodySiteFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCLCBodySiteExecute ]
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

ClassMethod FindCLCBodySiteClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCLCBodySiteExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

// w ##class(DHCBP.BeforeDialysis).SaveDocStartArrangeInfo("{""ArrangeId"":5,""StartWeight"":""55"",""SubtractiveWeight"":"""",""PatDryWeight"":""50"",""OverWeight"":""5"",""StartSystolicPressure"":""122"",""StartDiastolicPressure"":""0"",""StartHeartRate"":""0"",""undefined"":""无"",""UrineVolume"":""0"",""ClinicalEvaluationNote"":"""",""BPCBPModeDesc"" :""HDF血液透析滤过"",""BPCBPModeDr"":""1"",""SecondBPCBPModeDesc"":""HDF血液透析滤过"",""SecondBPCBPModeDr"":""1"",""BPCConsumableDesc"":""F60S"",""BPCConsumableDr"":""14"",""BPCconsumableDataId"":"""",""SecondBPCConsumableDesc"":""F60S"",""SecondBPCConsumableDr"":""14"",""SecondBPCConsumableDataId"":"""",""BPCVADesc"":""自体动静脉内瘘"",""BPCVADr"":""1"",""VABodySiteDesc"":"""",""VABodySiteDr"":"""",""Na"":"""",""K"":"""",""Ca2"":"""",""Temperature"":"""",""PlanFilterReplaceAmount"":"""",""AnticoagulantModeDesc"":""全身肝素化"",""AnticoagulantModeDr"":""2"",""Icodextrin2.5%"":""12"",""12Duration"":""1"",""12Frequency"":""1"",""BFR"":""3"",""PlanTherapyDuration"":"""",""PlanDewaterAmount"":"""",""DewaterAmount"":""22"",""IsolatedUltVolume"":"""",""IsolatedUltrafiltrationVolumeTime"":""3"",""NaValue"":""1"",""UltraFiltrationValue"":"""",""BicarbonateValue"":"""",""HypothermyValue"":""2"",""Status"":""R"",""docOperateStatus"":""C"",""CheckDocDr"":1,""saveDocDr"":1,""updateDate"":""2019/8/22"",""updateTime"":""14:29:55""}","{""consumable"":[{""Id"":"""",""consumableId"":""14"",""ConsumableAmount"":""1"",""Type"":""M""},{""Id"":"""",""consumableId"":""14"",""ConsumableAmount"":""1"",""Type"":""A""}]}","{""ArrangeId"":5,""Drug"":[{""DrugId"":""12"",""Options"":[{""Code"":""Duration"",""Value"":""1""},{""Code"":""Frequency"",""Value"":""1""}]},{""DrugId"":""12"",""Options"":[{""Code"":""Duration"",""Value"":""1""},{""Code"":""Frequency"",""Value"":""1""}]}]}","{""Parref"":5,""Note"":""2"",""BPCERPDr"":""9""}")

/// Creator: BY
/// CreatDate: 2019-8-8
/// Description: 保存医生透析记录单透析前填写的内容(保存和复核)
/// Table：DHC_BP_Arrange,DHC_BP_ArrangeAnticoagulantDrug,DHC_BP_ArrangeConsumable,DHC_BP_ArrangeEquipRunPara
/// Input：存放在安排表中的内容(arrangePara),透析器材(arrangeConsumablePara),设备运行参数(arrangeEquipRunParaString),抗凝方式(arrangeAnticoagulantDrugString)
/// Return：保存正确时返回 "1",错误提示相关内容
ClassMethod SaveDocStartArrangeInfo(arrangePara, consumableBusinessPara, anticoagulantPara, equipRunParaBusinessPara) As %String
{
	s ^tempby("20190529","BY")=arrangePara_","_consumableBusinessPara_","_anticoagulantPara_","_equipRunParaBusinessPara
	//s obj={}.%FromJSON(arrangePara)
	s obj=##class(Nur.JSON).Decode(arrangePara)
	//s arrangeId=obj.ArrangeId
	s arrangeId=obj.GetAt("ArrangeId")
	q:arrangeId=""
	s arrange=##class(User.DHCBPArrange).%OpenId(arrangeId)
	//s oriStatus=arrange.BPAStatus
	s oriStatus=obj.GetAt("Status")
	//q:arrange.BPAStatus="M" "已上机无法修改透前记录"
	//q:arrange.BPAStatus="F" "治疗已完成无法修改透前记录"
	i (oriStatus="A")!(oriStatus="R") d
	.i ((arrange.BPAStatus'="M")&&(arrange.BPAStatus'="F")) d
	..s arrange.BPAStatus=obj.GetAt("Status")
    s arrange.BPAStartWeight=obj.GetAt("StartWeight")
    s arrange.BPASubtractiveWeight=obj.GetAt("SubtractiveWeight")
    s arrange.BPAIntakeAmount=obj.GetAt("IntakeAmount")
    s arrange.BPAPlanDewaterAmount=obj.GetAt("PlanDewaterAmount")
    s arrange.BPADewaterAmount=obj.GetAt("DewaterAmount")
    s arrange.BPAFoodIntakeAmount=obj.GetAt("FoodIntakeAmount")
    s arrange.BPAResidualBloodAmount=obj.GetAt("ResidualBloodAmount")
    s arrange.BPAPlanTherapyDuration=obj.GetAt("PlanTherapyDuration")
    s modeId=obj.GetAt("BPCBPModeDr")
    i modeId'="" s arrange.BPABPCBPModeDr=##class(User.DHCBPCBloodPurificationMode).%OpenId(modeId)
    s secondModeId=obj.GetAt("SecondBPCBPModeDr")
    s arrange.BPASecondBPCBPModeDr=##class(User.DHCBPCBloodPurificationMode).%OpenId(secondModeId)
    s consumableId=obj.GetAt("BPCConsumableDr")
    s arrange.BPABPCConsumableDr=##class(User.DHCBPCConsumable).%OpenId(consumableId)
    s secondConsumableId=obj.GetAt("SecondBPCConsumableDr")
    s arrange.BPASecondBPCConsumableDr=##class(User.DHCBPCConsumable).%OpenId(secondConsumableId)
    s arrange.BPANa=obj.GetAt("Na")
    s arrange.BPAK=obj.GetAt("K")
    s arrange.BPACa2=obj.GetAt("Ca2")
    s arrange.BPAFilterReplaceMode=obj.GetAt("FilterReplaceMode")
    //s arrange.BPAFilterReplaceAmount=$p(arrangePara,$c(3),48) 
    s arrange.BPAPlanFilterReplaceAmount=obj.GetAt("PlanFilterReplaceAmount")
    s arrange.BPABPMeasurePart=obj.GetAt("BPMeasurePart")
    s arrange.BPATemperature=obj.GetAt("Temperature")
    //充水量 
     // 透析前舒张压
    s arrange.BPAStartDiastolicPressure=obj.GetAt("StartDiastolicPressure")
    // 透析前收缩压
    s arrange.BPAStartSystolicPressure=obj.GetAt("StartSystolicPressure")
    /// 透析前心率
    s arrange.BPAStartHeartRate=obj.GetAt("StartHeartRate")
    /// 透析前症状
    s arrange.BPAStartSymptom=obj.GetAt("StartSymptom")
    /// 尿量
    s arrange.BPAUrineVolume=obj.GetAt("UrineVolume")
    /// 临床评估备注
    s arrange.BPAClinicalEvaluationNote=obj.GetAt("ClinicalEvaluationNote")
    /// 单纯超滤量
    s arrange.BPAIsolatedUltVolume=obj.GetAt("IsolatedUltVolume")
    /// 血流速
    //s arrange.BPABFR=obj.GetAt("BFR")
    /// 透析时间
    s arrange.BPAPlanTherapyDuration=obj.GetAt("PlanTherapyDuration")
    /// UFV
    s arrange.BPAPlanDewaterAmount=obj.GetAt("PlanDewaterAmount")
    /// 净超滤
    s arrange.BPADewaterAmount=obj.GetAt("DewaterAmount")
    //血管通路码表指针
    s vascularAccessId=obj.GetAt("BPCVADr")
    i vascularAccessId'="" s arrange.BPABPCVADr=##class(User.DHCBPCVascularAccess).%OpenId(vascularAccessId)
    //血管通路建立部位指针
    s arrange.BPAVABodySiteDr=obj.GetAt("VABodySiteDr")
    //抗凝方案指针
    s anticoagulantModeId=obj.GetAt("AnticoagulantModeDr")
    i anticoagulantModeId'="" s arrange.BPAAnticoagulantModeDr=##class(User.DHCBPCAnticoagulantMode).%OpenId(anticoagulantModeId)
    s docOperateStatus=obj.GetAt("docOperateStatus")
    s arrange.BPADocOperateStatus=docOperateStatus
    s saveDocDr=""
    i docOperateStatus="C" 
    {
     s arrange.BPACheckDocDr=obj.GetAt("CheckDocDr")
     s updateDate=obj.GetAt("updateDate")
     i updateDate'="" s arrange.BPACheckDate=##class(web.DHCClinicCom).ConvertToDateH(updateDate)
     s updateTime=obj.GetAt("updateTime")
     i updateTime'="" s arrange.BPACheckTime= ##class(web.DHCClinicCom).ConvertToTimeH(updateTime)
     s status=obj.GetAt("Status")
     s num=..SaveBPNum(status,arrangeId)
     s saveDocDr=obj.GetAt("saveDocDr")
    }
    
    i docOperateStatus="R"
    {
     s arrange.BPARecheckDocDr=obj.GetAt("RecheckDocDr")
     s updateDate=$p(arrangePara,$c(3),96)
     i updateDate'="" s arrange.BPARecheckDate=##class(web.DHCClinicCom).ConvertToDateH(updateDate)
     s updateTime=$p(arrangePara,$c(3),97)
     i updateTime'="" s arrange.BPARecheckTime= ##class(web.DHCClinicCom).ConvertToTimeH(updateTime)
     s saveDocDr=obj.GetAt("saveDocDr")
    }
    s result=1    
    s saveStatus=arrange.%Save()
    //单超时间
    //(arrangeId, code, value, note, userId)
    s rowId=##class(DHCBP.ArrangeExtend).Save(arrangeId,"IsolatedUltrafiltrationVolumeTime",obj.GetAt("IsolatedUltrafiltrationVolumeTime"),"",obj.GetAt("UserId"))
    s rowId=##class(DHCBP.ArrangeExtend).Save(arrangeId,"BFR",obj.GetAt("BFR"),"",obj.GetAt("UserId"))
   	s rowId=##class(DHCBP.ArrangeExtend).Save(arrangeId,"PatientDryWeight",obj.GetAt("PatientDryWeight"),"",obj.GetAt("UserId"))
   
	i +saveStatus=0 q "保存数据失败!"
    s rowId=arrange.%Id()
    d arrange.%Close()
    s result=##class(DHCBP.Consumable).SaveArrangeConsumableList(rowId,consumableBusinessPara)
    i +result'=1 q "保存透析耗材错误"
    s result=##class(DHCBP.Anticoagulant).Save(anticoagulantPara)
    i +result'=1   q "保存抗凝药品错误"
    s ^tempby("20190529","saveStatus")=equipRunParaBusinessPara
    s result=##class(DHCBP.EquipRun).Save(equipRunParaBusinessPara)
    //s result=..SaveArrangeEquipRunParaList(rowId,equipRunParaBusinessPara)
    i +result=0  q "保存透析设备参数错误"   
    //d ##class(web.DHCBPCom).StartEquipCollect(arrangeId)
    q rowId
}

/// Creator: by
/// CreatDate: 2021-03-14
/// Description: 修改透析次数
/// Table：DHC_BP_PatRegister
/// Input：透析安排表状态status,登记表Id
/// Return：count
ClassMethod SaveBPNum(status, arrangeId) As %String
{
  q:arrangeId="" "无安排表id"
  s arrange=##class(User.DHCBPArrange).%OpenId(arrangeId)
  q:'$d(arrange)
  s registerId=arrange.BPABPPatRegisterDr.%Id()
  q:registerId="" "无登记表id"
  s docOperateStatus=arrange.BPADocOperateStatus
  s bpNum=arrange.BPABPNum
  s arrangeDate=arrange.BPADate
  s arrangedNum=0
  &sql(select count(*) into:arrangedNum from dhc_bp_arrange where BPA_BPPatRegister_Dr=:registerId and  BPA_Date<:arrangeDate
   and BPA_Status!='A' and BPA_Status!='D'
   and BPA_DocOperateStatus is not null and BPA_BPNum!=0 and  BPA_BPNum is not null)
  if (status="R")	
  {
	if ((docOperateStatus="C")&&((bpNum="")!(bpNum=0)))
	{
	  s bpNum=arrangedNum+1 
	}
  }
  if (status="D")
  {
	  s bpNum=bpNum-1
  }
  s arrange.BPABPNum=bpNum
  q bpNum
}

}
