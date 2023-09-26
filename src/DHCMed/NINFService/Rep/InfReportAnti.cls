/// 名称: DHCMed.NINFService.Rep.InfReportAnti
/// 描述: 医院感染报告 抗菌用药
/// 编写者：zhufei
/// 编写日期: 2011-06-21
Class DHCMed.NINFService.Rep.InfReportAnti Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2012-06-21
/// Description:  取医院感染报告 抗菌用药
/// Table：       DHCMed.NINF.Rep.InfReportAnti
/// Input：       DHCMed.NINF.Rep.InfReportAnti.ID
/// Return：      返回obj
/// w ##class(DHCMed.NINFService.Rep.InfReportAnti).GetSubRec(1)
ClassMethod GetSubRec(aRepID As %String) As DHCMed.NINF.Rep.InfReportAnti
{
	New (aRepID)
	Set return=""
	Quit:aRepID="" return
	
	Set SubID=0
	For {
		Set SubID=$o(^DHCMed.NINF("InfRep",aRepID,"Anti",SubID))
		Quit:SubID=""
		Set return=return_$c(1)_aRepID_"||"_SubID
	}
	Set:return'="" return=$e(return,2,$l(return))
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2012-06-21
/// Description:  取医院感染报告 抗菌用药
/// Table：       DHCMed.NINF.Rep.InfReportAnti
/// Input：       DHCMed.NINF.Rep.InfReportAnti.ID
/// Return：      返回obj
/// w ##class(DHCMed.NINFService.Rep.InfReportAnti).GetSubObj(1)
ClassMethod GetSubObj(aId As %String) As DHCMed.NINF.Rep.InfReportAnti
{
	New (aId)
	Set return=""
	
	Set obj=##Class(DHCMed.NINF.Rep.InfReportAnti).GetObjById(aId)
	If $IsObject(obj) {
		Set return=obj
	} Else {
		Set obj=##Class(DHCMed.NINF.Rep.InfReportAnti).%New()
		If obj'="" Do obj.%Close()
		set return=obj
	}
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2012-06-26
/// Description:  删除医院感染报告 抗菌用药
/// Table：       DHCMed.NINF.Rep.InfReportAnti
/// Input：       DHCMed.NINF.Rep.InfReport.ID
/// Return：      返回obj
/// w ##class(DHCMed.NINFService.Rep.InfReportAnti).DelSubRec(1)
ClassMethod DelSubRec(aId As %String) As %String
{
	New (aId)
	Set return=##Class(DHCMed.NINF.Rep.InfReportAnti).DeleteById(aId)
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2012-06-26
/// Description:  保存医院感染报告 抗菌用药
/// Table：       DHCMed.NINF.Rep.InfReportAnti
/// Input：       
/// Return：      返回ID
/// w ##class(DHCMed.NINFService.Rep.InfReportAnti).SaveSubRec("","")
ClassMethod SaveSubRec(aInput As %String, aSeparate As %String) As %String
{
	New (aInput,aSeparate)
	Set return=0
	Set $ZT="SaveSubRecErr"
	
	Set CHR1=$p(aSeparate,",",1)
	Quit:(CHR1="") return
	
	Set RepID=$p(aInput,CHR1,1)
	Quit:RepID="" return
	Quit:'$d(^DHCMed.NINF("InfRep",RepID)) return
	
	Set ArcimDesc=$p(aInput,CHR1,5)
	Quit:ArcimDesc="" return
	Set StartDate=$p(aInput,CHR1,6)
	;Set:StartDate["-" StartDate=$zdh(StartDate,3)
	Set:StartDate'="" StartDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(StartDate)
	Set StartTime=$p(aInput,CHR1,7)
	Set:StartTime[":" StartTime=$zth(StartTime,1)
	Set EndDate=$p(aInput,CHR1,8)
	;Set:EndDate["-" EndDate=$zdh(EndDate,3)
	Set:EndDate'="" EndDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(EndDate)
	Set EndTime=$p(aInput,CHR1,9)
	Set:EndTime[":" EndTime=$zth(EndTime,1)
	
	Set PreMedTime=$p(aInput,CHR1,20)    //格式:0小时0分钟
	Set PostMedDays=$p(aInput,CHR1,21)   //格式:0天
	
	Set $p(aInput,CHR1,6)=StartDate
	Set $p(aInput,CHR1,7)=StartTime
	Set $p(aInput,CHR1,8)=EndDate
	Set $p(aInput,CHR1,9)=EndTime
	
	Set return=##Class(DHCMed.NINF.Rep.InfReportAnti).Update(aInput,CHR1)
	Quit return
	
SaveSubRecErr
	Quit -999
}

/// Creator：     zhufei
/// CreatDate：   2012-05-26
/// Description:  查询疾病诊断信息
/// Table：       DHCMed.NINF.Rep.InfReportAnti
/// Input:        
/// do ##class(%ResultSet).RunQuery("DHCMed.NINFService.Rep.InfReportAnti","QrySubRec","","653362")
Query QrySubRec(aReportID As %String, aEpisodeID As %String) As %Query(ROWSPEC = "RepID:%String,SubID:%String,ArcimID:%String,ArcimDesc:%String,StartDate:%String,StartTime:%String,EndDate:%String,EndTime:%String,DoseQty:%String,DoseUnitID:%String,DoseUnitDesc:%String,PhcFreqID:%String,PhcFreqDesc:%String,MedUsePurposeID:%String,MedUsePurposeDesc:%String,AdminRouteID:%String,AdminRouteDesc:%String,MedPurposeID:%String,MedPurposeDesc:%String,TreatmentModeID:%String,TreatmentModeDesc:%String,PreMedIndicatID:%String,PreMedIndicatDesc:%String,PreMedEffectID:%String,PreMedEffectDesc:%String,CombinedMedID:%String,CombinedMedDesc:%String,PreMedTime:%String,PostMedDays:%String,SenAnaID:%String,SenAnaDesc:%String,DataSource:%String") [ SqlProc ]
{
}

ClassMethod QrySubRecExecute(ByRef qHandle As %Binary, aReportID As %String, aEpisodeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aReportID="")&&(aEpisodeID="") $$$OK
	
	If aReportID'="" {
		Set xSubID=0
		For {
			Set xSubID=$o(^DHCMed.NINF("InfRep",aReportID,"Anti",xSubID))
			Quit:xSubID=""
			
			Set objSub=##class(DHCMed.NINF.Rep.InfReportAnti).GetObjById(aReportID_"||"_xSubID)
			Continue:'$IsObject(objSub)
			
			Set (ArcimID,ArcimDesc,StartDate,StartTime,EndDate,EndTime,DoseQty,DoseUnitID,DoseUnitDesc,PhcFreqID,PhcFreqDesc)=""
			Set (MedUsePurposeID,MedUsePurposeDesc,AdminRouteID,AdminRouteDesc)=""
			Set (MedPurposeID,MedPurposeDesc,TreatmentModeID,TreatmentModeDesc)=""
			Set (PreMedIndicatID,PreMedIndicatDesc,PreMedEffectID,PreMedEffectDesc)=""
			Set (CombinedMedID,CombinedMedDesc,PreMedTime,PostMedDays)=""
			Set (SenAnaID,SenAnaDesc,DataSource)=""
			
			Set DataSource=objSub.DataSource
			Set ArcimID=objSub.ArcimID
			Set ArcimDesc=objSub.ArcimDesc
			Set StartDate=objSub.StartDate
			;Set:StartDate'="" StartDate=$zd(StartDate,3)
			Set:StartDate'="" StartDate=##class(DHCMed.SSService.CommonCls).DateLogicalToHtml(StartDate)
			Set StartTime=objSub.StartTime
			Set:StartTime'="" StartTime=$zt(StartTime,1)
			Set EndDate=objSub.EndDate
			;Set:EndDate'="" EndDate=$zd(EndDate,3)
			Set:EndDate'="" EndDate=##class(DHCMed.SSService.CommonCls).DateLogicalToHtml(EndDate)
			Set EndTime=objSub.EndTime
			Set:EndTime'="" EndTime=$zt(EndTime,1)
			Set DoseQty=objSub.DoseQty
			Set DoseUnitID=objSub.DoseUnit
			Set:DoseUnitID'="" DoseUnitDesc=$p($g(^CT("UOM",+DoseUnitID)),"^",2)
			Set PhcFreqID=objSub.PhcFreq
			Set:PhcFreqID'="" PhcFreqDesc=$p($g(^PHCFR(PhcFreqID)),"^",3)
			
			If $IsObject(objSub.MedUsePurpose) {
				Set MedUsePurposeID=objSub.MedUsePurpose.%Id()
				Set MedUsePurposeDesc=objSub.MedUsePurpose.Description
			}
			If $IsObject(objSub.AdminRoute) {
				Set AdminRouteID=objSub.AdminRoute.%Id()
				Set AdminRouteDesc=objSub.AdminRoute.Description
			}
			If $IsObject(objSub.MedPurpose) {
				Set MedPurposeID=objSub.MedPurpose.%Id()
				Set MedPurposeDesc=objSub.MedPurpose.Description
			}
			If $IsObject(objSub.TreatmentMode) {
				Set TreatmentModeID=objSub.TreatmentMode.%Id()
				Set TreatmentModeDesc=objSub.TreatmentMode.Description
			}
			If $IsObject(objSub.PreMedIndicat) {
				Set PreMedIndicatID=objSub.PreMedIndicat.%Id()
				Set PreMedIndicatDesc=objSub.PreMedIndicat.Description
			}
			If $IsObject(objSub.PreMedEffect) {
				Set PreMedEffectID=objSub.PreMedEffect.%Id()
				Set PreMedEffectDesc=objSub.PreMedEffect.Description
			}
			If $IsObject(objSub.CombinedMed) {
				Set CombinedMedID=objSub.CombinedMed.%Id()
				Set CombinedMedDesc=objSub.CombinedMed.Description
			}
			Set PreMedTime=objSub.PreMedTime
			Set PostMedDays=objSub.PostMedDays
			If $IsObject(objSub.SenAna) {
				Set SenAnaID=objSub.SenAna.%Id()
				Set SenAnaDesc=objSub.SenAna.Description
			}
			
			Set Data=$lb(aReportID,xSubID)
			Set Data=Data_$lb(ArcimID,ArcimDesc,StartDate,StartTime,EndDate,EndTime,DoseQty,DoseUnitID,DoseUnitDesc,PhcFreqID,PhcFreqDesc)
			Set Data=Data_$lb(MedUsePurposeID,MedUsePurposeDesc,AdminRouteID,AdminRouteDesc)
			Set Data=Data_$lb(MedPurposeID,MedPurposeDesc,TreatmentModeID,TreatmentModeDesc)
			Set Data=Data_$lb(PreMedIndicatID,PreMedIndicatDesc,PreMedEffectID,PreMedEffectDesc)
			Set Data=Data_$lb(CombinedMedID,CombinedMedDesc,PreMedTime,PostMedDays)
			Set Data=Data_$lb(SenAnaID,SenAnaDesc,DataSource)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	} Else {
		//抗菌用药药学分类
		Set AntiPhcDrugType=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("NINFInfAntiPhcDrugType","")
	 	//取给药途径字段
	 	Set PHCInstrucField=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("NINFInfPHCInstrucField","")
	 	
	 	Set ZIndex=$zn,JIndex=$j,NIndex="QrySubRec"
		Set xOrdID=$o(^OEORD(0,"Adm",aEpisodeID,""))
	 	Set xArcimID=""
	 	For {
		 	Set xArcimID=$o(^OEORDi(0,"ARCIM",+xOrdID,xArcimID))
		 	Quit:xArcimID=""
		 	Set objArcim=##class(DHCMed.Base.Arcim).GetObjById(xArcimID)
		 	Continue:'$IsObject(objArcim)
		 	Set ARCICOrderType=objArcim.ARCICOrderType
		 	Continue:ARCICOrderType'="R"
		 	/* update by zf 2014-04-28
		 	Set ARCIMPHCDFDR=objArcim.ARCIMPHCDFDR
		 	Set objPhc=##class(DHCMed.Base.PHC).GetObjById(ARCIMPHCDFDR)
		 	Continue:(objPhc.PHCCDesc="")||(objPhc.PHCSCDesc="")
		 	Set PHCCDesc=objPhc.PHCCDesc
		 	Set PHCSCDesc=objPhc.PHCSCDesc 
		 	//抗生素,抗感染,抗微生物
		 	//w AntiPhcDrugType_"///"_objPhc.PHCCDesc_"///"_objPhc.PHCSCDesc,!
		 	Continue:(AntiPhcDrugType'="")&&(AntiPhcDrugType'[PHCSCDesc)&&(AntiPhcDrugType'[PHCCDesc)
		 	*/
		 	If AntiPhcDrugType'="" {
			 	Set tmpPHCCat=##Class(DHCMed.NINFService.Srv.CommonCls).GetPHCCat(xArcimID)
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
					
					Set FillerNo=$p($g(^OEORD(xOrdID,"I",xSubID,9)),"^",12)
					If FillerNo'="" {
						Set OEItemID=$p(FillerNo,"!!",1)
					}Else{
						Set OEItemID=xOrdID_"||"_xSubID
					}
					Continue:xOrdID=""
					
					Set xDate=$p($g(^OEORD(xOrdID,"I",xSubID,3)),"^",34)
					Continue:(+xDate)'=0  //停止的医嘱过滤掉
					
					Set ^TMP(ZIndex,JIndex,NIndex,OEItemID,xSubID)=FillerNo
				}
			}
		}
		
		Set OEItemID=""
		For {
			Set OEItemID=$o(^TMP(ZIndex,JIndex,NIndex,OEItemID))
			Quit:OEItemID=""
			
			Set (ArcimID,ArcimDesc,StartDate,StartTime,EndDate,EndTime,DoseQty,DoseUnitID,DoseUnitDesc,PhcFreqID,PhcFreqDesc)=""
			Set (MedUsePurposeID,MedUsePurposeDesc,AdminRouteID,AdminRouteDesc)=""
			Set (MedPurposeID,MedPurposeDesc,TreatmentModeID,TreatmentModeDesc)=""
			Set (PreMedIndicatID,PreMedIndicatDesc,PreMedEffectID,PreMedEffectDesc)=""
			Set (CombinedMedID,CombinedMedDesc,PreMedTime,PostMedDays)=""
			Set (SenAnaID,SenAnaDesc,DataSource)=""
			
			Set FstSubID=0,LstSubID=0,OEOrdStartDate=0,OEOrdEndDate=0,StartDateList=""
			Set SubID=0
			For {
				Set SubID=$o(^TMP(ZIndex,JIndex,NIndex,OEItemID,SubID))
				Quit:SubID=""
				
				Set objOEItem=##class(DHCMed.Base.OrdItem).GetObjById((+OEItemID)_"||"_SubID)
				Continue:'$IsObject(objOEItem)
				Set tmpStartDate=objOEItem.OEORISttDat
				Set tmpStartDate=+tmpStartDate
				Set tmpStartTime=objOEItem.OEORISttTim
				Set tmpStartTime=+tmpStartTime
				Continue:tmpStartDate=0
				
				If (FstSubID=0)||(SubID<FstSubID) {
					Set FstSubID=SubID
				}
				If (LstSubID=0)||(SubID>LstSubID) {
					Set LstSubID=SubID
				}
				If (OEOrdStartDate=0)||(tmpStartDate<OEOrdStartDate) {
					Set OEOrdStartDate=tmpStartDate
					Set OEOrdStartTime=tmpStartTime
				}
				If (OEOrdEndDate=0)||(tmpStartDate>OEOrdEndDate) {
					Set OEOrdEndDate=tmpStartDate
					Set OEOrdEndTime=tmpStartTime
				}
				If $listfind(StartDateList,tmpStartDate)<1 {
					Set StartDateList=StartDateList_$lb(tmpStartDate)
				}
			}
			If OEOrdStartDate'="" {
				;Set StartDate=$zd(+OEOrdStartDate,3)
				Set StartDate=##class(DHCMed.SSService.CommonCls).DateLogicalToHtml(+OEOrdStartDate)
				Set StartTime=$zt(+OEOrdStartTime,2)
				
			}
			If OEOrdEndDate'="" {
				;Set EndDate=$zd(+OEOrdEndDate,3)
				Set EndDate=##class(DHCMed.SSService.CommonCls).DateLogicalToHtml(+OEOrdEndDate)
				Set EndTime=$zt(+OEOrdEndTime,2)
			}
			Set MedDays=$listlength(StartDateList)  //用药天数
			
			Set objOEItem=##class(DHCMed.Base.OrdItem).GetObjById(OEItemID)
			Continue:'$IsObject(objOEItem)
			Set ArcimID=objOEItem.OEORIItmMastDR
			Set:ArcimID'="" ArcimDesc=$p($g(^ARCIM(+ArcimID,+$p(ArcimID,"||",2),1)),"^",2)
			Continue:ArcimDesc=""
			
			//从抗菌药物管理中取治疗、预防数据
			Set rowid="",isZL=0,isYF=0
			For {
				Set rowid=$o(^DAUP("ADM",aEpisodeID,OEItemID,rowid))  
				Quit:rowid=""  
				/*Set DTAUPDr=$p($g(^DAUP("DAUP",rowid)),"^",20)
				Continue:DTAUPDr=""
				Set AURDr=$p($g(^DTAUP("AUP",DTAUPDr)),"^",3)
				Continue:AURDr=""
				Set Aur=$p(^DCTAR("AUR",AURDr),"^",1)
				*/
				
				//modify by mxp 2017-06-02 标准版 最新版抗菌药物管理 配置数据
				Set AIMDr=$p($g(^DAUP("DAUP",rowid)),"^",20) //使用目的
				Continue:AIMDr=""
				Set AURDr=$p($g(^DHCAntBasePurposeDataConfigD(AIMDr)),"^",6) //使用目的大类
				Continue:AURDr=""				
				Set Aur=$p($g(^DHCAntBasePurposeDataConfigD(AURDr)),"^",4)

				Set:Aur="ZL" isZL=1
				Set:Aur="YF" isYF=1
			}
			If (isZL=1)&&(isYF=1)
			{
				Set MedPurposeDesc="治疗+预防"	
			}ElseIf(isZL=1)
			{
				Set MedPurposeDesc="治疗"
			}ElseIf(isYF=1)
			{
				Set MedPurposeDesc="预防"
			}
			If MedPurposeDesc'="" {
				Set MedPurposeID=##Class(DHCMed.NINFService.Srv.CommonCls).GetDicIDByDesc("NINFInfMedPurpose",MedPurposeDesc)
				Set:MedPurposeID="" MedPurposeDesc="*"_MedPurposeDesc
			}
			
			Set OEORIInstrDR=objOEItem.OEORIInstrDR  //PHC_Instruc  用法
			If PHCInstrucField="Desc2" {
				Set OEORIInstr=$p($g(^PHCIN(+OEORIInstrDR)),"^",3)
			} Else {
				Set OEORIInstr=$p($g(^PHCIN(+OEORIInstrDR)),"^",2)
			}
			Set:$p(OEORIInstr,"-",2)'="" OEORIInstr=$p(OEORIInstr,"-",2)
			Continue:OEORIInstr["皮试"  //过滤掉皮试医嘱
			If OEORIInstrDR'="" {
				Set objTmp=##class(DHCMed.NINF.Srv.MKDicMapping).GetMappingData("InfDicAdminRoute",OEORIInstrDR)
				If $IsObject(objTmp) {
					Set AdminRouteDesc=objTmp.TargetDesc
				}
			}
			If AdminRouteDesc="" {
				Set AdminRouteDesc=OEORIInstr
				Set:(AdminRouteDesc["静脉滴注")||(AdminRouteDesc["静脉点滴") AdminRouteDesc="静脉点滴"
				Set:AdminRouteDesc["静脉注射" AdminRouteDesc="静脉注射"
				Set:AdminRouteDesc["外用" AdminRouteDesc="外用"
				Set:(AdminRouteDesc["气雾吸入")||(AdminRouteDesc["雾化吸入") AdminRouteDesc="气雾吸入"
			}
			If AdminRouteDesc'="" {
				Set AdminRouteID=##Class(DHCMed.NINFService.Srv.CommonCls).GetDicIDByDesc("NINFInfAdminRoute",AdminRouteDesc)
				Set:AdminRouteID="" AdminRouteDesc="*"_AdminRouteDesc
			}
			
			Set DoseQty=objOEItem.OEORIDoseQty
			Set DoseUnitID=objOEItem.OEORIUnitDR
			Set:DoseUnitID'="" DoseUnitDesc=$p($g(^CT("UOM",+DoseUnitID)),"^",2)
			Set PhcFreqID=objOEItem.OEORIPHFreqDR
			Set:PhcFreqID'="" PhcFreqDesc=$p($g(^PHCFR(PhcFreqID)),"^",3)
			
			Set:PhcFreqDesc["术前" MedUsePurposeDesc="术前用药"
			Set:PhcFreqDesc["术中" MedUsePurposeDesc="术中用药"
			Set:PhcFreqDesc["术后" MedUsePurposeDesc="术后用药"
			//If ((PhcFreqDesc'["术前")&&(PhcFreqDesc'["术中")&&(PhcFreqDesc'["术后")) {
			//	Set MedUsePurposeDesc="其它用药"
			//}
			Set MedUsePurposeID=##Class(DHCMed.NINFService.Srv.CommonCls).GetDicIDByDesc("NINFInfMedUsePurpose",MedUsePurposeDesc)
			
			Set DataSource="OEITEM:"_OEItemID
			
			Set Data=$lb("","")
			Set Data=Data_$lb(ArcimID,ArcimDesc,StartDate,StartTime,EndDate,EndTime,DoseQty,DoseUnitID,DoseUnitDesc,PhcFreqID,PhcFreqDesc)
			Set Data=Data_$lb(MedUsePurposeID,MedUsePurposeDesc,AdminRouteID,AdminRouteDesc)
			Set Data=Data_$lb(MedPurposeID,MedPurposeDesc,TreatmentModeID,TreatmentModeDesc)
			Set Data=Data_$lb(PreMedIndicatID,PreMedIndicatDesc,PreMedEffectID,PreMedEffectDesc)
			Set Data=Data_$lb(CombinedMedID,CombinedMedDesc,PreMedTime,PostMedDays)
			Set Data=Data_$lb(SenAnaID,SenAnaDesc,DataSource)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
		Kill ^TMP(ZIndex,JIndex,NIndex)
	}
	Quit $$$OK
}

ClassMethod QrySubRecClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySubRecExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QrySubRecFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySubRecExecute ]
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

/// Creator：     zhufei
/// CreatDate：   2012-08-10
/// Description:  检查是否使用抗菌用药
/// Table：       
/// Input：       aEpisodeID  就诊号
/// Return：      return<=0:否  return>0:是
/// w ##class(DHCMed.NINFService.Rep.InfReportAnti).IsCheckAnti("47235")
ClassMethod IsCheckAnti(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=0,Count=0
	Quit:aEpisodeID="" return
	
	Set rs=##Class(%ResultSet).%New("DHCMed.NINFService.Rep.InfReportAnti:QrySubRec")
	Do rs.Execute("",aEpisodeID)
	While (rs.Next()){
		Set Count=Count+1
	}
	Do rs.Close()
	
	Set return=Count
	Quit return
}

}
