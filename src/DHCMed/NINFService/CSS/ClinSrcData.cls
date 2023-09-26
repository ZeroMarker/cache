/// 名称:DHCMed.NINFService.CSS.ClinSrcData
/// 描述:横断面相关临床数据
/// 编写者：zhufei
/// 编写日期: 2014-05-09
Class DHCMed.NINFService.CSS.ClinSrcData Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// do ##class(%ResultSet).RunQuery("DHCMed.NINFService.CSS.ClinSrcData","QryAntiList","3616073")
Query QryAntiList(aEpisodeID As %String) As %Query(ROWSPEC = "OEItemID:%String,FillerNo:%String,ArcimID:%String,ArcimDesc:%String,PriorityDesc:%String,SttDate:%String,XDate:%String,PhcFreq:%String,PHCInstr:%String") [ SqlProc ]
{
}

ClassMethod QryAntiListExecute(ByRef qHandle As %Binary, aEpisodeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aEpisodeID="") $$$OK
	
	Set OEOrdType=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("DPIO-OEOrdType","")
	Set OEOrdType=+OEOrdType
	
	Set AntiPhcDrugType=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("CC-AnitPHCCat","")
	Quit:AntiPhcDrugType="" return
	
	Set xOrdID=$o(^OEORD(0,"Adm",aEpisodeID,""))
	Quit:xOrdID="" $$$OK
	
 	Kill ClinAntiList
 	Set xArcimID=""
 	For {
	 	Set xArcimID=$o(^OEORDi(0,"ARCIM",+xOrdID,xArcimID))
	 	Quit:xArcimID=""
	 	
	 	Set objArcim=##class(DHCMed.Base.Arcim).GetObjById(xArcimID)
	 	Continue:'$IsObject(objArcim)
	 	Set ARCICOrderType=objArcim.ARCICOrderType
	 	Continue:ARCICOrderType'="R"
	 	Set ArcimDesc=objArcim.ARCIMDesc
	 	Continue:ArcimDesc["皮试剂"
	 	
	 	If AntiPhcDrugType'="" {
		 	Set tmpPHCCat=##Class(DHCMed.DPCustom.Data.OEOrdItem).GetPHCCat(xArcimID)
			Continue:tmpPHCCat=""
	 		Set PHCCat=$p(tmpPHCCat,$c(1),1)
	 		Set PHCCatCode=$p(PHCCat,$c(2),2)
	 		Set PHCCatDesc=$p(PHCCat,$c(2),3)
	 		Set PHCSubCat=$p(tmpPHCCat,$c(1),2)
	 		Set PHCSubCatCode=$p(PHCSubCat,$c(2),2)
	 		Set PHCSubCatDesc=$p(PHCSubCat,$c(2),3)
	 		Set PHCPoison=$p(tmpPHCCat,$c(1),3)
	 		Set PHCPoisonCode=$p(PHCPoison,$c(2),2)
	 		Set PHCPoisonDesc=$p(PHCPoison,$c(2),3)
	 		Set PHCAntiFlag=$p(tmpPHCCat,$c(1),4)
	 		
	 		If ((PHCCatCode'="")&&(AntiPhcDrugType[PHCCatCode))
	 		||((PHCCatDesc'="")&&(AntiPhcDrugType[PHCCatDesc))
	 		||((PHCSubCatCode'="")&&(AntiPhcDrugType[PHCSubCatCode))
	 		||((PHCSubCatDesc'="")&&(AntiPhcDrugType[PHCSubCatDesc))
	 		||((PHCPoisonCode'="")&&(AntiPhcDrugType[PHCPoisonCode))
	 		||((PHCPoisonDesc'="")&&(AntiPhcDrugType[PHCPoisonDesc))
	 		||((PHCAntiFlag'="")&&(AntiPhcDrugType[PHCAntiFlag))
	 		{
		 		//符合筛查条件药品
		 	} Else {
			 	Continue
			}
		}
		
		Set xOrdDate=0
		For {
			Set xOrdDate=$o(^OEORDi(0,"ARCIM",+xOrdID,xArcimID,xOrdDate))
			Quit:xOrdDate=""
			
			Set xSubID=0
			For {
				Set xSubID=$o(^OEORDi(0,"ARCIM",+xOrdID,xArcimID,xOrdDate,xSubID))
				Quit:xSubID=""
				
				Set OEItemID=xOrdID_"||"_xSubID
			 	If OEOrdType=0 { //滚执行记录模式
					Continue:(##class(DHCMed.DPCustom.Data.OEOrdItem).IsValidOEItem7(OEItemID)=0)
				} ElseIf OEOrdType=1 {  //滚医嘱模式
				 	Continue:(##class(DHCMed.DPCustom.Data.OEOrdItem).IsValidOEItem(OEItemID)=0)
				} Else {
					Continue
				}
				
				Set objOEItem=##class(DHCMed.Base.OrdItem).GetObjById(OEItemID)
				Continue:'$IsObject(objOEItem)
				Set StartDate=objOEItem.OEORISttDat
				Set StartDate=+StartDate
				Continue:StartDate=0
				Set:StartDate'="" StartDate=$zd(StartDate,3)
				Set XDate=objOEItem.OEORIXDate
				Set:XDate'="" XDate=$zd(XDate,3)
				
				Set PhcFreqID=objOEItem.OEORIPHFreqDR    //PHC_Freq 频次
				Set PhcFreqDesc=$p($g(^PHCFR(+PhcFreqID)),"^",3)
				Set:PhcFreqDesc="" PhcFreqDesc=$p($g(^PHCFR(+PhcFreqID)),"^",4)
				
				Set OEORIInstrDR=objOEItem.OEORIInstrDR  //PHC_Instruc 用法
				Set OEORIInstr=$p($g(^PHCIN(+OEORIInstrDR)),"^",2)
				Set:OEORIInstr="" OEORIInstr=$p($g(^PHCIN(+OEORIInstrDR)),"^",3)
				Set:$p(OEORIInstr,"-",2)'="" OEORIInstr=$p(OEORIInstr,"-",2)
				Continue:OEORIInstr["皮试"  //过滤掉皮试医嘱
				
				Set FillerNo=$p($g(^OEORD(xOrdID,"I",xSubID,9)),"^",12)
				If FillerNo'="" {
					Set FillerNo=$p(FillerNo,"!!",1)
				}Else{
					Set FillerNo=xOrdID_"||"_xSubID
				}
				
				Set OEPriority=$p($g(^OEORD(xOrdID,"I",xSubID,1)),"^",8)
				Set PriorityDesc=$p($g(^OECPR(+OEPriority)),"^",2)
				
				If $d(ClinAntiList(FillerNo)){
					Set Data=$g(ClinAntiList(FillerNo))
					Set:XDate'="" $list(Data,6)=XDate
				} Else {
					Set Data=$lb(OEItemID,FillerNo,xArcimID,ArcimDesc,PriorityDesc,StartDate,XDate,PhcFreqDesc,OEORIInstr)
				}
				Set ClinAntiList(FillerNo)=Data
			}
		}
	}
	
	Set xOEItemID="",Count=0
	For {
		Set xOEItemID=$o(ClinAntiList(xOEItemID))
		Quit:xOEItemID=""
		
		Set Count=Count+1
		Set Data=$g(ClinAntiList(xOEItemID))
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
 	Kill ClinAntiList
	
	Quit $$$OK
}

ClassMethod QryAntiListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAntiListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryAntiListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAntiListExecute ]
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

/// do ##class(%ResultSet).RunQuery("DHCMed.NINFService.CSS.ClinSrcData","QryLabList","3616073")
Query QryLabList(aEpisodeID As %String) As %Query(ROWSPEC = "OEItemID:%String,OEItemDesc:%String,TestSetRow:%String,TestCode:%String,TestDesc:%String,SubmissionDate:%String,Specimen:%String,Pathogeny:%String") [ SqlProc ]
{
}

ClassMethod QryLabListExecute(ByRef qHandle As %Binary, aEpisodeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aEpisodeID="") $$$OK
	
	Set LabOECategory=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("CC-LabOECategory","")
	Quit:LabOECategory="" return
	
	Set arrRec=##Class(DHCMed.DPCustom.Data.LabTestSet).GetDataByAdm(aEpisodeID,"","",LabOECategory)
	Set Num=arrRec.Count()
	For indRec=1:1:Num {
		Set objRec=arrRec.GetAt(indRec)
		Continue:'$IsObject(objRec)
		
		Set DataCount=objRec.TestData.Count()
		For indData=1:1:DataCount {
			Set objData=objRec.TestData.GetAt(indData)
			Continue:'$IsObject(objData)
			Continue:objData.DataFormat'="V"
			
			Set checkFlag=##Class(DHCMed.DP.Base.ActWards).Check0("LIS-PY",objData.DataText)
			Continue:checkFlag'=""
			
			Set OEItemID=objRec.OEItemID
			Set OEItemDesc=objRec.OEItemDesc
			Set TestSetRow=objRec.TestSetRow
			Set TestCode=objData.TestCode
			Set TestDesc=objData.TestDesc
			Set SubmissionDate=objRec.SubmissionDate
			Set Specimen=objRec.SpecimenDesc
			Set Pathogeny=objData.DataText
			
			Set Data=$lb(OEItemID,OEItemDesc,TestSetRow,TestCode,TestDesc,SubmissionDate,Specimen,Pathogeny)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	
	Quit $$$OK
}

ClassMethod QryLabListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLabListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryLabListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLabListExecute ]
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

/// do ##class(%ResultSet).RunQuery("DHCMed.NINFService.CSS.ClinSrcData","QryOperList","3616073")
Query QryOperList(aEpisodeID As %String) As %Query(ROWSPEC = "RecordID:%String,OperDesc:%String,OperType:%String,OperDate:%String,DeptDesc:%String,DocName:%String,CutGrade:%String,CutHealing:%String,Anesthesia:%String") [ SqlProc ]
{
}

ClassMethod QryOperListExecute(ByRef qHandle As %Binary, aEpisodeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aEpisodeID="") $$$OK
	
	Set arrRec=##Class(DHCMed.DPCustom.Data.Operation).GetDataByAdm(aEpisodeID,"","")
	Set Num=arrRec.Count()
	For indRec=1:1:Num {
		Set objRec=arrRec.GetAt(indRec)
		Continue:'$IsObject(objRec)
		
		Set RecordID=objRec.RecordID
		Set OperDesc=objRec.OperDesc
		Set OperType=objRec.OperType
		Set OperDate=objRec.SttDate
		Set DeptDesc=objRec.DeptDesc
		Set DocName=objRec.DocName
		Set CutGrade=objRec.CutGrade
		Set CutHealing=objRec.CutHealing
		Set Anesthesia=objRec.Anesthesia
		
		Set Data=$lb(RecordID,OperDesc,OperType,OperDate,DeptDesc,DocName,CutGrade,CutHealing,Anesthesia)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryOperListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOperListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryOperListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOperListExecute ]
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

/// do ##class(%ResultSet).RunQuery("DHCMed.NINFService.CSS.ClinSrcData","QryBugsSenList","3616073")
Query QryBugsSenList(aEpisodeID As %String) As %Query(ROWSPEC = "OEItemID:%String,OEItemDesc:%String,TestSetRow:%String,TestCode:%String,TestDesc:%String,SubmissionDate:%String,Specimen:%String,Pathogeny:%String,Antibiotics:%String") [ SqlProc ]
{
}

ClassMethod QryBugsSenListExecute(ByRef qHandle As %Binary, aEpisodeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aEpisodeID="") $$$OK
	
	Set LabOECategory=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("CC-LabOECategory","")
	Quit:LabOECategory="" return
	
	Set arrRec=##Class(DHCMed.DPCustom.Data.LabTestSet).GetDataByAdm(aEpisodeID,"","",LabOECategory)
	Set Num=arrRec.Count()
	For indRec=1:1:Num {
		Set objRec=arrRec.GetAt(indRec)
		Continue:'$IsObject(objRec)
		
		Set DataCount=objRec.TestData.Count()
		For indData=1:1:DataCount {
			Set objData=objRec.TestData.GetAt(indData)
			Continue:'$IsObject(objData)
			Continue:objData.DataFormat'="V"
			
			Set checkFlag=##Class(DHCMed.DP.Base.ActWards).Check0("LIS-PY",objData.DataText)
			Continue:checkFlag'=""
			
			Set OEItemID=objRec.OEItemID
			Set OEItemDesc=objRec.OEItemDesc
			Set TestSetRow=objRec.TestSetRow
			Set TestCode=objData.TestCode
			Set TestDesc=objData.TestDesc
			Set SubmissionDate=objRec.SubmissionDate
			Set Specimen=objRec.SpecimenDesc
			Set Pathogeny=objData.DataText
			Set Antibiotics=objData.Antibiotics
			
			Set Data=$lb(OEItemID,OEItemDesc,TestSetRow,TestCode,TestDesc,SubmissionDate,Specimen,Pathogeny,Antibiotics)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	
	Quit $$$OK
}

ClassMethod QryBugsSenListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryBugsSenListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryBugsSenListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryBugsSenListExecute ]
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

}
