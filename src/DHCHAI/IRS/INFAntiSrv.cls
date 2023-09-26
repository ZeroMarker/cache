/// 名称: DHCHAI.IRS.INFAntiSrv
/// 描述: 感染报告- 抗菌药物相关服务
/// 编写者：liyi
/// 编写日期: 2017-09-19
Class DHCHAI.IRS.INFAntiSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liyi
/// CreatDate：   2017-09-19
/// Description:  通过感染报告ID查询抗菌药物
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.INFAntiSrv","QryINFAntiByRep","",4673)
Query QryINFAntiByRep(aReportID As %String, aEpisodeID As %String) As %Query(ROWSPEC = "ID:%String,EpisodeID:%String,AntiUseID:%String,AntiDesc:%String,AntiDesc2:%String,SttDate:%String,EndDate:%String,DoseQty:%String,DoseUnitID:%String,DoseUnit:%String,PhcFreqID:%String,PhcFreq:%String,MedUsePurposeID:%String,MedUsePurpose:%String,AdminRouteID:%String,AdminRoute:%String,MedPurposeID:%String,MedPurpose:%String,TreatmentModeID:%String,TreatmentMode:%String,PreMedEffectID:%String,PreMedEffect:%String,PreMedIndicatID:%String,PreMedIndicat:%String,CombinedMedID:%String,CombinedMed:%String,PreMedTime:%String,PostMedDays:%String,SenAnaID:%String,SenAna:%String,UpdateDate:%String,UpdateTime:%String,UpdateUserID:%String,UpdateUser:%String,SttTime,EndTime") [ SqlProc ]
{
}

ClassMethod QryINFAntiByRepExecute(ByRef qHandle As %Binary, aReportID As %String, aEpisodeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit:(aReportID="")&&(aEpisodeID="") $$$OK
 	
 	If aReportID'=""{
	 	Set objRep = ##class(DHCHAI.IR.INFReport).GetObjById(aReportID)
	 	Quit:'$isobject(objRep) $$$OK
	 	
	 	Quit:'$IsObject(objRep.IREpisodeDr) $$$OK
	
	    Set LinkAntis=objRep.GetRepLinkIDs("DHCHAI.IR.INFAnti")
		Quit:LinkAntis="" $$$OK
	 	For indx = 1:1:$length(LinkAntis,","){
			Set ID = $p(LinkAntis,",",indx)
			Continue:ID=""
			
			Set Data = ..BuildINFAntData(ID)
			Continue:Data=""
			
			Set ^CacheTemp(repid,ind)=Data
	    	Set ind=ind+1
	 	}
 	}else{
	 	Set xSCode=""
		For {
			Set xSCode = $o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aEpisodeID,xSCode))
			Quit:xSCode=""
			
			Set xSttDate = ""
			For {
				Set xSttDate = $o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aEpisodeID,xSCode,1,xSttDate))
				Quit:xSttDate=""
				
				Set xID = ""
				For {
					Set xID = $o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aEpisodeID,xSCode,1,xSttDate,xID))
					Quit:xID=""
					
					Set objOrdItem = ##class(DHCHAI.DP.OEOrdItem).GetObjById(xID)
					Continue:'$IsObject(objOrdItem)
					Continue:objOrdItem.OEIsActive=0
					
					Set INFAntiID = $o(^DHCHAI.IR.INFAntiI("IndexEpisodeAntiUseDr",aEpisodeID,xID,""))
					if INFAntiID'=""{
						Set Data = ..BuildINFAntData(INFAntiID)
						Continue:Data=""
						
						Set ^CacheTemp(repid,ind)=Data
				    	Set ind=ind+1
					}else{
						Set AntiUseID = xID
						Set AntiDesc = objOrdItem.OEOrdDesc
						Set AntiDesc2 = objOrdItem.OEGeneric
						Set SttDate = objOrdItem.OESttDate
						Set:SttDate'="" SttDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(SttDate)
						Set SttTime= objOrdItem.OESttTime
						Set:SttTime'="" SttTime=$zt(SttTime,1)
						Set EndDate = objOrdItem.OEXDate
						Set:EndDate'="" EndDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(EndDate)
						Set EndTime =objOrdItem.OEXTime
						Set:EndTime'="" EndTime=$zt(EndTime,1)
						Set DoseQty = objOrdItem.OEDoseQty
						// 剂量单位
						Set DoseUnitID = ""
						Set DoseUnit = objOrdItem.OEDoseQtyUom
						Set PhraseMap=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(xSCode,"OEDoseUnit",DoseUnit)  
						If (PhraseMap'="") {
							Set DoseUnitID  = $p(PhraseMap,"^",1)
							Set DoseUnit 	= $p(PhraseMap,"^",3)
						}
						// 频次
						Set PhcFreqID = ""
						Set PhcFreq = objOrdItem.OEFreqDesc	
						Set PhraseMap=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(xSCode,"OEPhcFreq",PhcFreq)  
						If (PhraseMap'="") {
							Set PhcFreqID  = $p(PhraseMap,"^",1)
							Set PhcFreq    = $p(PhraseMap,"^",3)
						}
						Set (MedUsePurposeID,MedUsePurpose)=""  // 用途
						// 给药途径
						Set AdminRouteID = ""
						Set AdminRoute = objOrdItem.OEInstruc	
						Set PhraseMap=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(xSCode,"AntiAdminRoute",AdminRoute)  
						If (PhraseMap'="") {
							Set AdminRouteID  = $p(PhraseMap,"^",1)
							Set AdminRoute    = $p(PhraseMap,"^",3)
						}
						// 目的
						Set MedPurposeID = ""
						Set MedPurpose = objOrdItem.OEAntUsePurpose
						Set PhraseMap=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(xSCode,"AntiMedPurpose",MedPurpose)  
						If (PhraseMap'="") {
							Set MedPurposeID  = $p(PhraseMap,"^",1)
							Set MedPurpose    = $p(PhraseMap,"^",3)
						}
						Set (TreatmentModeID,TreatmentMode)=""  // 治疗用药方式
						Set (PreMedEffectID,PreMedEffect)=""  // 预防用药效果
						Set (PreMedIndicatID,PreMedIndicat)="" // 预防用药指征
						Set (CombinedMedID,CombinedMed)=""   // 联合用药
						Set PreMedTime=""  // 术前用药时间(分钟)
						Set PostMedDays="" // 术后用药天数(天)
						Set (SenAnaID,SenAna)=""   // 敏感度
						Set UpdateDate=""
						Set UpdateTime=""
						Set UpdateUserID=""
						Set UpdateUser=""
						//多语言处理
						Set AntiDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("ARCIMDesc",AntiDesc,"User.ARCItmMast")
						Set Data = $lb("",EpisodeID,AntiUseID,AntiDesc,AntiDesc2,SttDate,EndDate,DoseQty,DoseUnitID,DoseUnit,PhcFreqID,PhcFreq,MedUsePurposeID,MedUsePurpose,AdminRouteID,AdminRoute,MedPurposeID,MedPurpose,TreatmentModeID,TreatmentMode,PreMedEffectID,PreMedEffect,PreMedIndicatID,PreMedIndicat,CombinedMedID,CombinedMed,PreMedTime,PostMedDays,SenAnaID,SenAna,UpdateDate,UpdateTime,UpdateUserID,UpdateUser,SttTime,EndTime)
						Set ^CacheTemp(repid,ind)=Data
						Set ind=ind+1 
					}
				}
			}
		}
 	}
	Quit $$$OK
}

ClassMethod QryINFAntiByRepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryINFAntiByRepExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryINFAntiByRepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryINFAntiByRepExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

/// 取抗菌用药信息
ClassMethod BuildINFAntData(aID As %String) As %String
{
	New (aID)
	Set return=""
	Quit:aID="" return
	
	Set obj = ##class(DHCHAI.IR.INFAnti).GetObjById(aID)
	Quit:'$IsObject(obj) return
	
	Set objAdm = obj.IREpisodeDr
	Quit:'$IsObject(objAdm) return
	
	Set EpisodeID = objAdm.%Id()
	Quit:EpisodeID="" return
	
	Set objAntiUse = obj.IRAntiUseDr
	Set AntiUseID=""
	Set:$IsObject(objAntiUse) AntiUseID = objAntiUse.%Id()
	
	Set AntiDesc = obj.IRAntiDesc
	Set AntiDesc2 = obj.IRAntiDesc2
	Set SttDate = obj.IRSttDate
	Set:SttDate'="" SttDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(SttDate)
	Set EndDate = obj.IREndDate
	Set:EndDate'="" EndDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(EndDate)
	Set DoseQty = obj.IRDoseQty
	Set objDoseUnit = obj.IRDoseUnit
	Set SttTime =obj.IRSttTime
	Set:SttTime'="" SttTime=$zt(SttTime,1)
	Set EndTime =obj.IREndTime
	Set:EndTime'="" EndTime=$zt(EndTime,1)
	Set (DoseUnitID,DoseUnit)=""
	if $IsObject(objDoseUnit){
		Set DoseUnitID = objDoseUnit.%Id()
		Set DoseUnit = objDoseUnit.BTDesc
	}
	Set objPhcFreq = obj.IRPhcFreq
	Set (PhcFreqID,PhcFreq)=""
	if $IsObject(objPhcFreq){
		Set PhcFreqID = objPhcFreq.%Id()
		Set PhcFreq = objPhcFreq.BTDesc
	}
	Set objMedUsePurpose = obj.IRMedUsePurpose
	Set (MedUsePurposeID,MedUsePurpose)=""
	if $IsObject(objMedUsePurpose){
		Set MedUsePurposeID = objMedUsePurpose.%Id()
		Set MedUsePurpose = objMedUsePurpose.BTDesc
	}
	Set objAdminRoute = obj.IRAdminRoute
	Set (AdminRouteID,AdminRoute)=""
	if $IsObject(objAdminRoute){
		Set AdminRouteID = objAdminRoute.%Id()
		Set AdminRoute = objAdminRoute.BTDesc
	}
	Set objMedPurpose = obj.IRMedPurpose
	Set (MedPurposeID,MedPurpose)=""
	if $IsObject(objMedPurpose){
		Set MedPurposeID = objMedPurpose.%Id()
		Set MedPurpose = objMedPurpose.BTDesc
	}
	Set objTreatmentMode = obj.IRTreatmentMode
	Set (TreatmentModeID,TreatmentMode)=""
	if $IsObject(objTreatmentMode){
		Set TreatmentModeID = objTreatmentMode.%Id()
		Set TreatmentMode = objTreatmentMode.BTDesc
	}
	Set objPreMedEffect = obj.IRPreMedEffect
	Set (PreMedEffectID,PreMedEffect)=""
	if $IsObject(objPreMedEffect){
		Set PreMedEffectID = objPreMedEffect.%Id()
		Set PreMedEffect = objPreMedEffect.BTDesc
	}
	Set objPreMedIndicat = obj.IRPreMedIndicat
	Set (PreMedIndicatID,PreMedIndicat)=""
	if $IsObject(objPreMedIndicat){
		Set PreMedIndicatID = objPreMedIndicat.%Id()
		Set PreMedIndicat = objPreMedIndicat.BTDesc
	}
	Set objCombinedMed = obj.IRCombinedMed
	Set (CombinedMedID,CombinedMed)=""
	if $IsObject(objCombinedMed){
		Set CombinedMedID = objCombinedMed.%Id()
		Set CombinedMed = objCombinedMed.BTDesc
	}
	Set PreMedTime = obj.IRPreMedTime
	Set PostMedDays = obj.IRPostMedDays
	Set objSenAna = obj.IRSenAna
	Set (SenAnaID,SenAna)=""
	if $IsObject(objSenAna){
		Set SenAnaID = objSenAna.%Id()
		Set SenAna = objSenAna.BTDesc
	}
	Set UpdateDate = obj.IRUpdateDate
	Set:UpdateDate'="" UpdateDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(UpdateDate)
	Set UpdateTime = obj.IRUpdateTime
	Set:UpdateTime'="" UpdateTime=$zt(UpdateTime)
	Set objUpdateUser = obj.IRUpdateUserDr
	Set (UpdateUserID,UpdateUser)=""
	If $IsObject(objUpdateUser){
		Set UpdateUserID = objUpdateUser.%Id()
		Set UpdateUser = objUpdateUser.BTDesc
	}
	Set return = $lb(aID,EpisodeID,AntiUseID,AntiDesc,AntiDesc2,SttDate,EndDate,DoseQty,DoseUnitID,DoseUnit,PhcFreqID,PhcFreq,MedUsePurposeID,MedUsePurpose,AdminRouteID,AdminRoute,MedPurposeID,MedPurpose,TreatmentModeID,TreatmentMode,PreMedEffectID,PreMedEffect,PreMedIndicatID,PreMedIndicat,CombinedMedID,CombinedMed,PreMedTime,PostMedDays,SenAnaID,SenAna,UpdateDate,UpdateTime,UpdateUserID,UpdateUser,SttTime,EndTime)
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2018-12-03
/// Description:  通过感染报告ID查询抗菌药物
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.INFAntiSrv","QryINFAntiByRep1","",69857,"201812030005")
Query QryINFAntiByRep1(aReportID As %String, aEpisodeID As %String, aSurvNumber As %String) As %Query(ROWSPEC = "ID:%String,EpisodeID:%String,AntiUseID:%String,AntiDesc:%String,AntiDesc2:%String,SttDate:%String,EndDate:%String,DoseQty:%String,DoseUnitID:%String,DoseUnit:%String,PhcFreqID:%String,PhcFreq:%String,MedUsePurposeID:%String,MedUsePurpose:%String,AdminRouteID:%String,AdminRoute:%String,MedPurposeID:%String,MedPurpose:%String,TreatmentModeID:%String,TreatmentMode:%String,PreMedEffectID:%String,PreMedEffect:%String,PreMedIndicatID:%String,PreMedIndicat:%String,CombinedMedID:%String,CombinedMed:%String,PreMedTime:%String,PostMedDays:%String,SenAnaID:%String,SenAna:%String,UpdateDate:%String,UpdateTime:%String,UpdateUserID:%String,UpdateUser:%String") [ SqlProc ]
{
}

ClassMethod QryINFAntiByRep1Execute(ByRef qHandle As %Binary, aReportID As %String, aEpisodeID As %String, aSurvNumber As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	//Set ^zhoubo= aReportID_"^"_aEpisodeID_"^"_aSurvNumber
 	Quit:(aSurvNumber="")&&(aEpisodeID="") $$$OK
 	Set objSurv=##class(DHCHAI.IR.SurveyExec).GetObjById(aSurvNumber)
 	Quit:'$isobject(objSurv) $$$OK
 	Set SESurvSttDate = objSurv.SESurvSttDate // 调查开始日期
 	Set SESurvEndDate = objSurv.SESurvEndDate // 调查结束日期
 	If aReportID'=""{
	 	Quit $$$OK
 	}else{
	 	Set xSCode=""
		For {
			Set xSCode = $o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aEpisodeID,xSCode))
			Quit:xSCode=""
			
			Set xSttDate = ""
			For {
				Set xSttDate = $o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aEpisodeID,xSCode,1,xSttDate))
				Quit:xSttDate=""
				Quit:xSttDate>SESurvEndDate
				Set xID = ""
				For {
					Set xID = $o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aEpisodeID,xSCode,1,xSttDate,xID))
					Quit:xID=""
					
					Set objOrdItem = ##class(DHCHAI.DP.OEOrdItem).GetObjById(xID)
					Continue:'$IsObject(objOrdItem)
					Continue:objOrdItem.OEIsActive=0
					
					Set INFAntiID = $o(^DHCHAI.IR.INFAntiI("IndexEpisodeAntiUseDr",aEpisodeID,xID,""))
					if INFAntiID'=""{
						Set Data = ..BuildINFAntData1(INFAntiID,SESurvSttDate,SESurvEndDate)
						Continue:Data=""
						
						Set ^CacheTemp(repid,ind)=Data
				    	Set ind=ind+1
					}else{
						Set AntiUseID = xID
						Set AntiDesc = objOrdItem.OEOrdDesc
						Set AntiDesc2 = objOrdItem.OEGeneric
						Set SttDate = objOrdItem.OESttDate
						Set OEPriority = objOrdItem.OEPriority
						If (OEPriority="临时医嘱"){
							Continue:(SttDate<SESurvSttDate)
						}Else{
							Set tmpEndDate = objOrdItem.OEXDate
							Set:tmpEndDate="" tmpEndDate=+$h
							Continue:(tmpEndDate<SESurvSttDate)
						}
						Set:SttDate'="" SttDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(SttDate)
						Set EndDate = objOrdItem.OEXDate
						Set:EndDate'="" EndDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(EndDate)
						Set DoseQty = objOrdItem.OEDoseQty
						// 剂量单位
						Set DoseUnitID = ""
						Set DoseUnit = objOrdItem.OEDoseQtyUom
						Set PhraseMap=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(xSCode,"OEDoseUnit",DoseUnit)  
						If (PhraseMap'="") {
							Set DoseUnitID  = $p(PhraseMap,"^",1)
							Set DoseUnit 	= $p(PhraseMap,"^",3)
						}
						// 频次
						Set PhcFreqID = ""
						Set PhcFreq = objOrdItem.OEFreqDesc	
						Set PhraseMap=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(xSCode,"OEPhcFreq",PhcFreq)  
						If (PhraseMap'="") {
							Set PhcFreqID  = $p(PhraseMap,"^",1)
							Set PhcFreq    = $p(PhraseMap,"^",3)
						}
						Set (MedUsePurposeID,MedUsePurpose)=""  // 用途
						// 给药途径
						Set AdminRouteID = ""
						Set AdminRoute = objOrdItem.OEInstruc	
						Set PhraseMap=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(xSCode,"AntiAdminRoute",AdminRoute)  
						If (PhraseMap'="") {
							Set AdminRouteID  = $p(PhraseMap,"^",1)
							Set AdminRoute    = $p(PhraseMap,"^",3)
						}
						// 目的
						Set MedPurposeID = ""
						Set MedPurpose = objOrdItem.OEAntUsePurpose
						Set PhraseMap=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(xSCode,"AntiMedPurpose",MedPurpose)  
						If (PhraseMap'="") {
							Set MedPurposeID  = $p(PhraseMap,"^",1)
							Set MedPurpose    = $p(PhraseMap,"^",3)
						}
						Set (TreatmentModeID,TreatmentMode)=""  // 治疗用药方式
						Set (PreMedEffectID,PreMedEffect)=""  // 预防用药效果
						Set (PreMedIndicatID,PreMedIndicat)="" // 预防用药指征
						Set (CombinedMedID,CombinedMed)=""   // 联合用药
						Set PreMedTime=""  // 术前用药时间(分钟)
						Set PostMedDays="" // 术后用药天数(天)
						Set (SenAnaID,SenAna)=""   // 敏感度
						Set UpdateDate=""
						Set UpdateTime=""
						Set UpdateUserID=""
						Set UpdateUser=""
						Set Data = $lb("",EpisodeID,AntiUseID,AntiDesc,AntiDesc2,SttDate,EndDate,DoseQty,DoseUnitID,DoseUnit,PhcFreqID,PhcFreq,MedUsePurposeID,MedUsePurpose,AdminRouteID,AdminRoute,MedPurposeID,MedPurpose,TreatmentModeID,TreatmentMode,PreMedEffectID,PreMedEffect,PreMedIndicatID,PreMedIndicat,CombinedMedID,CombinedMed,PreMedTime,PostMedDays,SenAnaID,SenAna,UpdateDate,UpdateTime,UpdateUserID,UpdateUser)
						Set ^CacheTemp(repid,ind)=Data
						Set ind=ind+1 
					}
				}
			}
		}
 	}
	Quit $$$OK
}

ClassMethod QryINFAntiByRep1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryINFAntiByRep1Execute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryINFAntiByRep1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryINFAntiByRep1Execute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

/// 取抗菌用药信息
ClassMethod BuildINFAntData1(aID As %String, aSESurvSttDate As %String, aSESurvEndDate As %String) As %String
{
	New (aID,aSESurvSttDate,aSESurvEndDate)
	Set return=""
	Quit:aID="" return
	
	Set obj = ##class(DHCHAI.IR.INFAnti).GetObjById(aID)
	Quit:'$IsObject(obj) return
	
	Set objAdm = obj.IREpisodeDr
	Quit:'$IsObject(objAdm) return
	
	Set EpisodeID = objAdm.%Id()
	Quit:EpisodeID="" return
	
	Set objAntiUse = obj.IRAntiUseDr
	Set AntiUseID=""
	Set:$IsObject(objAntiUse) AntiUseID = objAntiUse.%Id()
	
	Set AntiDesc = obj.IRAntiDesc
	Set AntiDesc2 = obj.IRAntiDesc2
	Set SttDate = obj.IRSttDate
	Set OEPriority = objAntiUse.OEPriority
	If (OEPriority="临时医嘱"){
		Quit:(SttDate<aSESurvSttDate) return
	}Else{
		Set tmpEndDate = obj.IREndDate
		Set:tmpEndDate="" tmpEndDate=+$h
		Quit:(tmpEndDate<aSESurvSttDate) return
	}
	Set:SttDate'="" SttDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(SttDate)
	Set EndDate = obj.IREndDate
	Set:EndDate'="" EndDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(EndDate)
	Set DoseQty = obj.IRDoseQty
	Set objDoseUnit = obj.IRDoseUnit
	Set (DoseUnitID,DoseUnit)=""
	if $IsObject(objDoseUnit){
		Set DoseUnitID = objDoseUnit.%Id()
		Set DoseUnit = objDoseUnit.BTDesc
	}
	Set objPhcFreq = obj.IRPhcFreq
	Set (PhcFreqID,PhcFreq)=""
	if $IsObject(objPhcFreq){
		Set PhcFreqID = objPhcFreq.%Id()
		Set PhcFreq = objPhcFreq.BTDesc
	}
	Set objMedUsePurpose = obj.IRMedUsePurpose
	Set (MedUsePurposeID,MedUsePurpose)=""
	if $IsObject(objMedUsePurpose){
		Set MedUsePurposeID = objMedUsePurpose.%Id()
		Set MedUsePurpose = objMedUsePurpose.BTDesc
	}
	Set objAdminRoute = obj.IRAdminRoute
	Set (AdminRouteID,AdminRoute)=""
	if $IsObject(objAdminRoute){
		Set AdminRouteID = objAdminRoute.%Id()
		Set AdminRoute = objAdminRoute.BTDesc
	}
	Set objMedPurpose = obj.IRMedPurpose
	Set (MedPurposeID,MedPurpose)=""
	if $IsObject(objMedPurpose){
		Set MedPurposeID = objMedPurpose.%Id()
		Set MedPurpose = objMedPurpose.BTDesc
	}
	Set objTreatmentMode = obj.IRTreatmentMode
	Set (TreatmentModeID,TreatmentMode)=""
	if $IsObject(objTreatmentMode){
		Set TreatmentModeID = objTreatmentMode.%Id()
		Set TreatmentMode = objTreatmentMode.BTDesc
	}
	Set objPreMedEffect = obj.IRPreMedEffect
	Set (PreMedEffectID,PreMedEffect)=""
	if $IsObject(objPreMedEffect){
		Set PreMedEffectID = objPreMedEffect.%Id()
		Set PreMedEffect = objPreMedEffect.BTDesc
	}
	Set objPreMedIndicat = obj.IRPreMedIndicat
	Set (PreMedIndicatID,PreMedIndicat)=""
	if $IsObject(objPreMedIndicat){
		Set PreMedIndicatID = objPreMedIndicat.%Id()
		Set PreMedIndicat = objPreMedIndicat.BTDesc
	}
	Set objCombinedMed = obj.IRCombinedMed
	Set (CombinedMedID,CombinedMed)=""
	if $IsObject(objCombinedMed){
		Set CombinedMedID = objCombinedMed.%Id()
		Set CombinedMed = objCombinedMed.BTDesc
	}
	Set PreMedTime = obj.IRPreMedTime
	Set PostMedDays = obj.IRPostMedDays
	Set objSenAna = obj.IRSenAna
	Set (SenAnaID,SenAna)=""
	if $IsObject(objSenAna){
		Set SenAnaID = objSenAna.%Id()
		Set SenAna = objSenAna.BTDesc
	}
	Set UpdateDate = obj.IRUpdateDate
	Set:UpdateDate'="" UpdateDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(UpdateDate)
	Set UpdateTime = obj.IRUpdateTime
	Set:UpdateTime'="" UpdateTime=$zt(UpdateTime)
	Set objUpdateUser = obj.IRUpdateUserDr
	Set (UpdateUserID,UpdateUser)=""
	If $IsObject(objUpdateUser){
		Set UpdateUserID = objUpdateUser.%Id()
		Set UpdateUser = objUpdateUser.BTDesc
	}
	Set return = $lb(aID,EpisodeID,AntiUseID,AntiDesc,AntiDesc2,SttDate,EndDate,DoseQty,DoseUnitID,DoseUnit,PhcFreqID,PhcFreq,MedUsePurposeID,MedUsePurpose,AdminRouteID,AdminRoute,MedPurposeID,MedPurpose,TreatmentModeID,TreatmentMode,PreMedEffectID,PreMedEffect,PreMedIndicatID,PreMedIndicat,CombinedMedID,CombinedMed,PreMedTime,PostMedDays,SenAnaID,SenAna,UpdateDate,UpdateTime,UpdateUserID,UpdateUser)
	Quit return
}

}
