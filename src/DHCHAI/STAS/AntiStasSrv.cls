/// 名称: DHCHAI.STAS.AntiStasSrv
/// 描述: 抗菌药物统计服务
/// 编写者：liyi
/// 编写日期: 2017-10-23
Class DHCHAI.STAS.AntiStasSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liyi
/// CreatDate：   2017-10-23
/// Description:  住院患者抗菌药物使用
/// Table：       
/// Input：       aQryType：1 同期住院 2 出院
/// Return：      返回%List
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STAS.AntiStasSrv","QryInPatAntUse","1|2","E","2016-10-10","2016-10-18")
Query QryInPatAntUse(aHospIDs As %String, aLocType As %String, aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "Paadm:%String,AdmLocID:%String,AdmLocDesc:%String,AntUseFlg:%String,PreUseFlg:%String,CureUseFlg:%String,CureSubmissFlg:%String,KSS3UseFlg:%String,KSS2UseFlg:%String,KSS3CureSubmissFlg:%String,KSS2CureSubmissFlg:%String,KSS3CureBloodSubmissFlg:%String,KSS2CureBloodSubmissFlg:%String") [ SqlProc ]
{
}

ClassMethod QryInPatAntUseExecute(ByRef qHandle As %Binary, aHospIDs As %String, aLocType As %String, aDateFrom As %String, aDateTo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Set:aDateFrom>+$h aDateFrom=+$h
 	Set:aDateTo>+$h aDateTo=+$h
 	Quit:(aDateFrom="")||(aDateTo="")||(aLocType="") $$$OK
    Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
    Quit:aHospIDs="" $$$OK
    
	Set NIndex="QryInPatAntUse"
	Kill ^TMP($zn,$j,NIndex)
	
	Set ListArray=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransEpisByLocDate(aDateFrom,aDateTo,aLocType,"","I") //某段时间的在科人数
	For index=1:1:ListArray.Count() {
		Set TransInfo=ListArray.GetAt(index)	
		Continue:TransInfo=""
		
		Set Date   = $LIST(TransInfo,1)
		Set Paadm  = $LIST(TransInfo,2)
		Set Status = $LIST(TransInfo,3)			
		Set LocID  = $LIST(TransInfo,4)	
		Set TansID = $LIST(TransInfo,5)
		
		Set objLoc = ##class(DHCHAI.BT.Location).GetObjById(LocID)
		Continue:'$IsObject(objLoc)
		//  医院过滤
		Continue:'$IsObject(objLoc.BTHospDr)
		Continue:'$listfind(aHospIDs,objLoc.BTHospDr.%Id())
		
		Set ^TMP($zn,$j,NIndex,TansID) = ""
	}
	Set xTransID = ""
	For {
		Set xTransID = $o(^TMP($zn,$j,NIndex,xTransID))
		Quit:xTransID=""
		
		Set objTrans = ##class(DHCHAI.DP.PAAdmTrans).GetObjById(xTransID)
		Continue:'$IsObject(objTrans)
		
		Set objPaadm = objTrans.PAEpisodeDr
		Set objAdmLoc = objTrans.PATransLocDr
		Continue:'$IsObject(objAdmLoc)
		Continue:'$IsObject(objPaadm)
		
		Set AdmLocID = objAdmLoc.%Id()
		If objAdmLoc.BTDesc2'=""{
			Set AdmLocDesc = objAdmLoc.BTDesc2
		}else{
			Set AdmLocDesc = objAdmLoc.BTDesc
		}
		Set TransDate = objTrans.PATransDate
		Set OutLocDate= objTrans.PAOutLocDate
		
		// 抗菌药物统计开始日期
		Set xfDate = TransDate
		If TransDate<aDateFrom{
			Set xfDate = aDateFrom
		}
		// 抗菌药物统计结束日期
		Set xtDate = OutLocDate
		if (OutLocDate>aDateTo)&&(OutLocDate'=""){
			Set xtDate = aDateTo
		}
		If OutLocDate=""{
			Set xtDate = aDateTo
		}
		Set AntUseInfo = ##class(DHCHAI.STAS.AntiStasSrv).GetAntUseInfo(objPaadm.%Id(),xfDate,xtDate)
		
		Set (AntUseFlg,PreUseFlg,CureUseFlg,CureSubmissFlg,KSS3UseFlg)=0
		Set (KSS2UseFlg,KSS3CureSubmissFlg,KSS2CureSubmissFlg,KSS3CureBloodSubmissFlg,KSS2CureBloodSubmissFlg)=0
		If AntUseInfo'=""{
			Set AntUseFlg = $p(AntUseInfo,"^",1)
			Set PreUseFlg = $p(AntUseInfo,"^",2)
			Set CureUseFlg = $p(AntUseInfo,"^",3)
			Set CureSubmissFlg = $p(AntUseInfo,"^",7)	//治疗前送检
			Set KSS3UseFlg = $p(AntUseInfo,"^",8)	//使用特殊药物
			Set KSS2UseFlg = $p(AntUseInfo,"^",9)	//使用限制药物
			Set KSS3CureSubmissFlg = $p(AntUseInfo,"^",10)	//特殊治疗前送检
			Set KSS2CureSubmissFlg = $p(AntUseInfo,"^",11)	//限制治疗前送检
			Set KSS3CureBloodSubmissFlg = $p(AntUseInfo,"^",12)	//特殊治疗前血培养送检
			Set KSS2CureBloodSubmissFlg = $p(AntUseInfo,"^",13)	//限制治疗前血培养送检
		}
		Set Data=$lb(objPaadm.%Id(),AdmLocID,AdmLocDesc,AntUseFlg,PreUseFlg,CureUseFlg,CureSubmissFlg,KSS3UseFlg,KSS2UseFlg,KSS3CureSubmissFlg,KSS2CureSubmissFlg,KSS3CureBloodSubmissFlg,KSS2CureBloodSubmissFlg)
	 	Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryInPatAntUseClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInPatAntUseExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryInPatAntUseFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInPatAntUseExecute ]
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

/// Creator：     liyi
/// CreatDate：   2017-10-23
/// Description:  出院患者抗菌药物使用
/// Table：       
/// Input：       
/// Return：      返回%List
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STAS.AntiStasSrv","QryOutPatAntUse","1||2","E","2016-10-01","2016-10-25")
Query QryOutPatAntUse(aHospIDs As %String, aLocType As %String, aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "Paadm:%String,DishLocID:%String,DishLocDesc:%String,AntUseFlg:%String,AntCount:%String,UseDays:%String,IsSubmiss:%String,CureUseFlg:%String") [ SqlProc ]
{
}

ClassMethod QryOutPatAntUseExecute(ByRef qHandle As %Binary, aHospIDs As %String, aLocType As %String, aDateFrom As %String, aDateTo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Set:aDateFrom>+$h aDateFrom=+$h
 	Set:aDateTo>+$h aDateTo=+$h
 	Quit:(aDateFrom="")||(aDateTo="")||(aLocType="") $$$OK
    Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
    Quit:aHospIDs=""

    Set xAdmType = ""
    For {
		Set xAdmType = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType))
		Quit:xAdmType=""
		Continue:(xAdmType'="I")&&(xAdmType'="EP")
		
		For xDishDate = aDateFrom:1:aDateTo{
			Set xDishTime = ""
			For {
				Set xDishTime = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType,xDishDate,xDishTime))
				Quit:xDishTime=""
				
				Set xPaadm = ""
				For {
					Set xPaadm = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType,xDishDate,xDishTime,xPaadm))
					Quit:xPaadm=""
					
					Set objPaadm = ##class(DHCHAI.DP.PAAdm).GetObjById(xPaadm)
					Continue:'$IsObject(objPaadm)
					
					Set DischDate = objPaadm.PADischDate
					Set AdmDate = objPaadm.PAAdmDate
					// 出院科室/病区
					Set objDishLoc = ""
					if aLocType="E"{
						Set objDishLoc = objPaadm.PAAdmLocDr
					}
					if aLocType="W"{
						Set objDishLoc = objPaadm.PAAdmWardDr
					}
					Continue:objDishLoc=""
					
					//  医院过滤
					Continue:'$IsObject(objDishLoc.BTHospDr)
					Continue:'$listfind(aHospIDs,objDishLoc.BTHospDr.%Id())
					
					Set DishLocID = objDishLoc.%Id()
					If objDishLoc.BTDesc2'=""{
						Set DishLocDesc = objDishLoc.BTDesc2
					}else{
						Set DishLocDesc = objDishLoc.BTDesc
					}
					Continue:DishLocDesc=""
					
					// 抗生素使用标记,使用天数,是否送检
					Set (AntUseFlg,UseDays,IsSubmiss,CureUseFlg)=0
					Set AntUseInfo = ..GetAntUseInfo(xPaadm,AdmDate,DischDate)
					If AntUseInfo'=""{
						Set AntUseFlg = $p(AntUseInfo,"^",1)
						Set CureUseFlg = $p(AntUseInfo,"^",3) 
						Set AntCount = $p(AntUseInfo,"^",4)
						Set UseDays = $p(AntUseInfo,"^",5)
						Set IsSubmiss = $p(AntUseInfo,"^",6)
					}
					Set Data = $lb(xPaadm,DishLocID,DishLocDesc,AntUseFlg,AntCount,UseDays,IsSubmiss,CureUseFlg)
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
				
			}
		}
	}
	Quit $$$OK
}

ClassMethod QryOutPatAntUseClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOutPatAntUseExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryOutPatAntUseFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOutPatAntUseExecute ]
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

/// Description: 获取期内就诊抗菌药物（全身用药）使用+送检信息
/// return: 是否用抗菌药物^是否预防使用^是否治疗使用^使用品种数^使用天数^是否送检^是否治疗前送检^是否特殊用药^是否限制用药^是否特殊用药前送检^是否限制用药前送检^是否特殊用药前学培养送检^是否限制用药前学培养送检^是否特殊治疗前送检^是否限制治疗前送检
/// w ##class(DHCHAI.STAS.AntiStasSrv).GetAntUseInfo("5580","2016-01-01","2017-11-11")
ClassMethod GetAntUseInfo(aPaadm As %String, aDateFrom As %String = "", aDateTo As %String = "") As %String
{
	New (aPaadm,aDateFrom,aDateTo)
	Set return =""
	Quit:aPaadm="" return
    
    Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	Quit:(aDateFrom="")||(aDateTo="") return
	Quit:aDateFrom>aDateTo return
	Set InstrucList=##class(DHCHAI.BT.Config).GetValByCode("StatInstrucList")
 	Set InstrucList=","_InstrucList_","
 	
	Set (IsUseAnt,IsPreUse,IsCureUse,AntCount,UseDays,IsSubmiss,IsCureSubmiss,IsKSS3Use,IsKSS2Use,IsKSS3CureSubmiss,IsKSS2CureSubmiss,IsKSS3CureBloodSubmiss,IsKSS2CureBloodSubmiss)=0
	
	// 品种,首次用药,最后用药,首次治疗用药,首次特殊治疗用药,首次限制治疗用药
	Set (AntGeneric,firstUseDate,LastUseDate,fistCureDate,fistKSS3CureDate,fistKSS2CureDate)=""
	Set xScode = ""
	For {
		Set xScode=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aPaadm,xScode))
		Quit:xScode=""
		
		Set xSttDate = ""
		For {
			Set xSttDate=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aPaadm,xScode,1,xSttDate))
			Quit:xSttDate=""
			
			Set xOrdItemID =""
			For {
				Set xOrdItemID=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aPaadm,xScode,1,xSttDate,xOrdItemID))
				Quit:xOrdItemID=""
				
				Set objOrdItem = ##class(DHCHAI.DP.OEOrdItem).GetObjById(xOrdItemID)
				Continue:'$IsObject(objOrdItem)
				Continue:objOrdItem.OEIsActive'=1
				
				Set SttDate = objOrdItem.OESttDate
				Set EndDate = objOrdItem.OEXDate
				Set Priority = objOrdItem.OEPriority	//医嘱类型
				Set PriorityMap =  ##class(DHCHAI.DP.PhraseMap).GetMapValue(xScode,"OEPriority",objOrdItem.OEPriority)
				Continue:PriorityMap=""
				
				Set Instruc = objOrdItem.OEInstruc //给药途径
				Set InstrucMapStr =  ##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(xScode,"AntiAdminRoute",Instruc)
				Continue:InstrucMapStr=""
				Set InstrucMap = $p(InstrucMapStr,"^",3)
				//Set InstrucList = $lb("口服","肌肉注射","静脉点滴","静脉注射")	//全身用药
				//Continue:'$listfind(InstrucList,InstrucMap)
				Continue:(InstrucList'="")&&(InstrucList'[(","_InstrucMap_","))
				
				Set UsePurpose = objOrdItem.OEAntUsePurpose	// 用药目的
				Set:UsePurpose="" UsePurpose="其他"
				Set UsePurposeMapStr =  ##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(xScode,"AntiMedPurpose",UsePurpose)
				Continue:UsePurposeMapStr=""
				Set UsePurpose = $p(UsePurposeMapStr,"^",3)
				
				Set Generic = objOrdItem.OEGeneric  // 通用名，用于计算品种
				Set DrgPoison = objOrdItem.OEAntDrgPoison	//管制分类
				if PriorityMap="N"{
					Set EndDate = SttDate
				}else{
					If EndDate=""{		// 长期医嘱未停止只计算到传入结束日期
						Set EndDate = aDateTo
					}
				}
				Continue:EndDate<aDateFrom  // 停药日期在传入日期前
				Continue:SttDate>aDateTo	// 用药日期在传入日期后
				
				// 计算单个药物期内用药时间段(日期控制在传入日期内)
				If SttDate<aDateFrom{
					Set SttDate = aDateFrom
				}
				If EndDate>aDateTo{
					Set EndDate = aDateTo
				}
				Set IsUseAnt = 1
				Set:UsePurpose="治疗" IsCureUse=1
				Set:UsePurpose="预防" IsPreUse=1
				// 品种
				If '$listfind(AntGeneric,Generic){
					Set AntCount = AntCount+1
				}
				Set AntGeneric = AntGeneric_$lb(Generic)
				
				// 首次用药日期
				If firstUseDate=""{
					Set firstUseDate = SttDate
				}else{
					Set:firstUseDate>SttDate firstUseDate = SttDate
				}
				// 最后用药日期
				If LastUseDate=""{
					Set LastUseDate = EndDate
				}else{
					Set:LastUseDate<EndDate LastUseDate = EndDate
				}
				
				// 首次治疗用药日期
				If UsePurpose = "治疗"{
					If fistCureDate=""{
						Set fistCureDate = SttDate
					}else{
						Set:fistCureDate>SttDate fistCureDate = SttDate
					}
				}
				Set:DrgPoison="KSS3" IsKSS3Use=1	//使用特殊级
				Set:DrgPoison="KSS2" IsKSS2Use=1	//使用限制级
				// 首次特殊治疗用药日期
				If (DrgPoison="KSS3")&&(UsePurpose="治疗"){
					If fistKSS3CureDate=""{
						Set fistKSS3CureDate = SttDate
					}else{
						Set:fistKSS3CureDate>SttDate fistKSS3CureDate = SttDate
					}
				}
				// 首次限制治疗用药日期
				If (DrgPoison="KSS2")&&(UsePurpose="治疗"){
					If fistKSS2CureDate=""{
						Set fistKSS2CureDate = SttDate
					}else{
						Set:fistKSS2CureDate>SttDate fistKSS2CureDate = SttDate
					}
				}
			}
		}
	}
	If IsUseAnt=1{		//使用了抗生素计算送检
		Set UseDays = LastUseDate-firstUseDate+1	//用药天数
		// 送检采用检验结果
		Set xVisitNumberDr=""
		For {
			Set xVisitNumberDr=$o(^DHCHAI.DP.LabVisitNumberI("IndexEpisodeDr",aPaadm,xVisitNumberDr))
			Quit:xVisitNumberDr=""
			
			Set objVisitNumber=##class(DHCHAI.DP.LabVisitNumber).GetObjById(xVisitNumberDr)
			Continue:'$isobject(objVisitNumber)
			Continue:objVisitNumber.LabIsActive'=1
			
			Set SCode   = objVisitNumber.LabSCode
			Set CollDate=objVisitNumber.LabCollDate		//采集日期
			Set RecDate =objVisitNumber.LabRecDate		//接收日期
			Set Specimen= objVisitNumber.LabSpecimen
			Set CollDate=$s(CollDate'="":CollDate,1:RecDate)		//送检日期优先用采集日期
			Continue:CollDate=""
			
			Set objSpecMap = ##class(DHCHAI.DP.LabSpecMap).GetObjBySpecimen(SCode,Specimen)
			If $IsObject(objSpecMap.BTMapItemDr)&&(objSpecMap.BTIsActive=1){
				if objSpecMap.BTMapItemDr.BTIsActive=1{
					Set Specimen = objSpecMap.BTMapItemDr.BTSpecDesc
				}
			}
				
			//Set:CollDate'="" CollDate=$zd(CollDate,3)
			Set:CollDate'="" CollDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(CollDate)
			Set xTestSetDesc = "",checkFlg=0
			For {
				Set xTestSetDesc = $o(^DHCHAI.DP.LabVisitTestSetI("IndexVisitNumberTestSet",xVisitNumberDr,xTestSetDesc))
				Quit:xTestSetDesc=""
				
				Set objTestSetCat = ##class(DHCHAI.DP.LabTestSetMap).GetTSCatByTestSet(SCode,xTestSetDesc)
				Continue:'$isobject(objTestSetCat)
				Continue:objTestSetCat.BTDesc'="微生物送检"
				Set checkFlg = 1
			}
			Continue:checkFlg=0	//不是送检标本
			
			Set IsSubmiss = 1
			If CollDate<=fistCureDate{	//治疗前送检
				Set IsCureSubmiss = 1
			}
			If CollDate<=fistKSS3CureDate{	//特殊治疗前送检
				Set IsKSS3CureSubmiss = 1
			}
			If CollDate<=fistKSS2CureDate{	//限制治疗前送检
				Set IsKSS2CureSubmiss = 1
			}
			If Specimen="血液"{
				If CollDate<=fistKSS3CureDate{	//特殊治疗前学培养送检
					Set IsKSS3CureBloodSubmiss = 1
				}
				If CollDate<=fistKSS2CureDate{	//限制治疗前学培养送检
					Set IsKSS2CureBloodSubmiss = 1
				}
			}
		}
	}
	Set return = IsUseAnt_"^"_IsPreUse_"^"_IsCureUse_"^"_AntCount_"^"_UseDays
	_"^"_IsSubmiss_"^"_IsCureSubmiss_"^"_IsKSS3Use_"^"_IsKSS2Use_"^"_IsKSS3CureSubmiss
	_"^"_IsKSS2CureSubmiss_"^"_IsKSS3CureBloodSubmiss_"^"_IsKSS2CureBloodSubmiss
	Quit return
}

}
