/// 名称: DHCMed.INFService.InfBaseSrv
/// 描述: 感染的常用基本操作 :根据Paadm 取医嘱手术 抗生素  病原体等信息信息
/// 编写者：ChenJB
/// 编写日期: 2010-05-17
Class DHCMed.INFService.InfBaseAricmSrv Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     ChenJB
/// CreatDate：   2010-05-19
/// Description:  查询病人抗生素的信息
/// Table：       DHCMed.Base.OrdItem
/// Input：       Paadm ： 就诊
/// output:       符合条件的项            
/// Return：      1: Rowid 2: ICDCodeDr 3: DocCodeDr 4: CTPCPCode 5: CTPCPDesc 6: CTCPTDesc
/// 			  7: CTCPTInternalType 8: DiaDate 9: DiaTime 10: IsActive 11: SignSymDr 12: AliasDiagText 13: ICD9CMCode 14: ICDDesc
/// D ##class(%ResultSet).RunQuery("DHCMed.INFService.InfBaseAricmSrv","QryArcimByPaadm","58008","1","Y")
Query QryArcimByPaadm(Paadm As %String = "", TypeCode As %String = "", DrugFlag As %String = "Yes", InfRepDr As %String = "") As %Query(ROWSPEC = "Rowid:%String,DrugName:%String,DrugsRoute:%String,DrugsRouteCode:%String,FromDate:%String,ToDate:%String,UseDayCnt:%String,AdmDrugs:%String,AdmDrugsCode:%String,InfAdmDrugsGoal:%String,InfAdmDrugsGoalCode:%String,CureAdmDrugsType:%String,CureAdmDrugsTypeCode:%String,DefendAdmDrugsType:%String,DefendAdmDrugsTypeCode:%String,IndicationDesc:%String,Indication:%String,Effect:%String,EffectCode:%String,UnionDrug:%String,UnionDrugCode:%String,AroundOpeDrugDesc:%String,AroundOpeDrug:%String,BeforeOpeDate:%String,AfterOpeDate:%String,Rationality:%String,RationalityCode:%String,Irrationality:%String,IrrationalityCode:%String,CurativeEffect:%String,CurativeEffectCode:%String,checked:%String,childSub:%String,ResumeText:%String,OprBeforInfo:%String,OprBeforInfoDesc:%String,OprAfterInfo:%String,OprAfterInfoDesc:%String,Text1:%String,AricmSumInfo:%String")
{
}

ClassMethod QryArcimByPaadmExecute(ByRef qHandle As %Binary, Paadm As %String = "", TypeCode As %String = "", DrugFlag As %String = "Yes", InfRepDr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	/*
 	s num=0,s=""
 	q:+Paadm=0 $$$OK
 	q:TypeCode="" $$$OK
 	//s repDr=##class(DHCMed.INFService.InfReportSrv).GetReportID(+Paadm,TypeCode)
 	s repDr=InfRepDr
    q:'$d(^OEORD(0,"Adm",+Paadm)) $$$OK
    s oeord=$o(^OEORD(0,"Adm",+Paadm,"")) 
    s arcim=""
    f  s arcim=$o(^OEORDi(0,"ARCIM",+oeord,arcim),-1) q:arcim=""  d
    .s objCls=##class(DHCMed.Base.Arcim).GetObjById(arcim)
    .q:'$IsObject(objCls)
    .s Type=objCls.ARCICOrderType
    .q:Type'="R" 
    .s objPhc=##class(DHCMed.Base.PHC).GetObjById(objCls.ARCIMPHCDFDR)
    .//q:(DrugFlag'="")&((objPhc.PHCCDesc'["抗感染")&(objPhc.PHCCDesc'["抗生素")&(objPhc.PHCCDesc'["抗微生物"))
    .q:(DrugFlag'="")&((objPhc.PHCSCDesc'["抗感染")&(objPhc.PHCSCDesc'["抗生素")&(objPhc.PHCSCDesc'["抗微生物"))  //ChengDu_HX ZheJiang_QZ
 	.s sttDate="",endDate="",Days=0,TMP="",AricmSumInfo=""
 	.k ^TMP($j,"arcItmDt",arcim)
 	.s xInstrID="" //药品用法/给药途径
 	.s ordDate="" f  s ordDate=$o(^OEORDi(0,"ARCIM",+oeord,arcim,ordDate)) q:ordDate=""  d
 	..s oeoriSub=0 f  s oeoriSub=$o(^OEORDi(0,"ARCIM",+oeord,arcim,ordDate,oeoriSub)) q:oeoriSub=""  d
 	...s oeori=oeord_"||"_oeoriSub
 	...s objOeorICls=##class(DHCMed.Base.OrdItem).GetObjById(oeori)
 	...s TsttDate=objOeorICls.OEORISttDat
 	...s InstrID=$p($g(^OEORD(+oeord,"I",oeoriSub,2)),"^",7)
 	...s InstrDesc=$p($g(^PHCIN(+InstrID)),"^",2)
 	...s:(xInstrID="")&&(InstrDesc'["皮试") xInstrID=InstrID
 	...s:AricmSumInfo="" AricmSumInfo=objOeorICls.OEORIDoseQty_"/"_objOeorICls.CTUOMDesc_";"_objOeorICls.PHCFRDesc1_";"_objOeorICls.PHCDUDesc1_";"_objOeorICls.PHCINDesc1
    ...q:TsttDate=0
    ...s ^TMP($j,"arcItmDt",arcim,TsttDate)=""
    .s sttDate=$o(^TMP($j,"arcItmDt",arcim,0))
    .s endDate=$o(^TMP($j,"arcItmDt",arcim,""),-1)
    .s Dt=0
    .f  s Dt=$o(^TMP($j,"arcItmDt",arcim,Dt)) q:Dt=""  d
    ..s Days=Days+1
    .s sttDate=$zd(sttDate,3),endDate=$zd(endDate,3)
    .//
    .s Data=$lb("")
    .s $li(Data,1)=arcim
    .s $li(Data,2)=objCls.ARCIMDesc
    .s DrugsRoute="" ,DrugsRouteCode="",checked="",childSub="",AdmDrugs="" , AdmDrugsCode=""
    .s InfAdmDrugsGoal="" ,InfAdmDrugsGoalCode="",CureAdmDrugsType="" ,CureAdmDrugsTypeCode=""
    .s DefendAdmDrugsType="" ,DefendAdmDrugsTypeCode="",IndicationDesc="" ,Indication=""
    .s Effect="" ,EffectCode="",UnionDrug="" ,UnionDrugCode="",AroundOpeDrugDesc="" ,AroundOpeDrug=""
    .s BeforeOpeDate="" ,AfterOpeDate="",Rationality="" ,RationalityCode="",Irrationality="" ,IrrationalityCode=""
    .s CurativeEffect="" ,CurativeEffectCode="",ResumeText=""
    .s OprBeforInfo="",OprBeforInfoDesc="",OprAfterInfo="",OprAfterInfoDesc="",Text1=""
    .
    .//***************************************
    .//给药途径 用法 PHC_Instruc
    .s DrugsRouteCode=xInstrID
    .s:DrugsRouteCode'="" DrugsRoute=$p($g(^PHCIN(+DrugsRouteCode)),"^",2)
    .i DrugsRoute'="" d
    ..s DrugsRouteCode=##Class(DHCMed.SSService.DictionarySrv).GetIDByDesc("","InfectionAdministerDrugsRoute",DrugsRoute)
    .e  d
    ..s DrugsRouteCode=""
    .//***************************************
    .
    .i repDr'="" d   ///已经保存过的数据
    ..//  DHCMed.INF.RepDrugI InfRepOeIdx
    ..q:arcim=""
    ..s arcimIdx=" "_$ZCVT(arcim,"U")
    ..q:'$d(^DHCMed.INF.RepDrugI("InfRepOeIdx",repDr,arcimIdx))
    ..s childSub=$o(^DHCMed.INF.RepDrugI("InfRepOeIdx",repDr,arcimIdx,0))
    ..q:childSub=""
    ..s objRepDrug=##class(DHCMed.INF.RepDrug).GetObjById(childSub)
    ..q:'$IsObject(objRepDrug)
    ..s checked=1
    ..s DrugsRouteCode=objRepDrug.Instr
    ..s AdmDrugsCode=objRepDrug.Mode
    ..s InfAdmDrugsGoalCode=objRepDrug.Aim
    ..s CureAdmDrugsTypeCode=objRepDrug.CureDrugMode
    ..s DefendAdmDrugsTypeCode=objRepDrug.PrevDrugMode
    ..s Indication=objRepDrug.PrevDrugFlag
    ..s EffectCode=objRepDrug.PrevDrugEffect
    ..s UnionDrugCode=objRepDrug.UniteDrug
    ..s AroundOpeDrug=objRepDrug.OprDrugFlag
    ..s BeforeOpeDate=objRepDrug.PreDrugTime
    ..s AfterOpeDate=objRepDrug.AftDrugDays
    ..s RationalityCode=objRepDrug.RightFlag
    ..s IrrationalityCode=objRepDrug.Impertinency
    ..s CurativeEffectCode=objRepDrug.Effect
    ..s ResumeText=objRepDrug.ResumeText
    ..s OprBeforInfo=objRepDrug.OprBeforInfo
    ..s OprAfterInfo=objRepDrug.OprAfterInfo
    ..s Text1=objRepDrug.Text1
    .i DrugsRouteCode'="" d
    ..s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(DrugsRouteCode,"InfectionAdministerDrugsRoute")
    ..s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    ..q:'$IsObject(objDic)
    ..s DrugsRoute=objDic.Description
    ..k objDic
    .s $li(Data,3)=DrugsRoute
    .s $li(Data,4)=DrugsRouteCode
    .s $li(Data,5)=sttDate  
    .s $li(Data,6)=endDate
    .s $li(Data,7)=Days
    .i AdmDrugsCode'="" d
    ..s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(AdmDrugsCode,"InfectionAdministerDrugs")
    ..s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    ..q:'$IsObject(objDic)
    ..s AdmDrugs=objDic.Description
    ..k objDic
    .s $li(Data,8)=AdmDrugs
    .s $li(Data,9)=AdmDrugsCode
    .i InfAdmDrugsGoalCode'="" d
    ..s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(InfAdmDrugsGoalCode,"InfectionAdministerDrugsGoal")
    ..s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    ..q:'$IsObject(objDic)
    ..s InfAdmDrugsGoal=objDic.Description
    ..k objDic
    .s $li(Data,10)=InfAdmDrugsGoal
    .s $li(Data,11)=InfAdmDrugsGoalCode
    .i CureAdmDrugsTypeCode'="" d
    ..s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(CureAdmDrugsTypeCode,"InfectionCureAdministerDrugsType")
    ..s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    ..q:'$IsObject(objDic)
    ..s CureAdmDrugsType=objDic.Description
    ..k objDic
    .s $li(Data,12)=CureAdmDrugsType
    .s $li(Data,13)=CureAdmDrugsTypeCode
    .i DefendAdmDrugsTypeCode'="" d
    ..s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(DefendAdmDrugsTypeCode,"InfectionDefendAdministerDrugsType")
    ..s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    ..q:'$IsObject(objDic)
    ..s DefendAdmDrugsType=objDic.Description
    ..k objDic
    .s $li(Data,14)=DefendAdmDrugsType
    .s $li(Data,15)=DefendAdmDrugsTypeCode
    .s:Indication="1" IndicationDesc="Yes"
    .s:Indication="0" IndicationDesc="No"
    .s $li(Data,16)=IndicationDesc
    .s $li(Data,17)=Indication
    .i EffectCode'="" d
    ..s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(EffectCode,"InfDefendDrugEffect")
    ..s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    ..q:'$IsObject(objDic)
    ..s Effect=objDic.Description
    ..k objDic
    .s $li(Data,18)=Effect
    .s $li(Data,19)=EffectCode
    .i UnionDrugCode'="" d
    ..s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(UnionDrugCode,"InfUnionDrug")
    ..s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    ..q:'$IsObject(objDic)
    ..s UnionDrug=objDic.Description
    ..k objDic
    .s $li(Data,20)=UnionDrug
    .s $li(Data,21)=UnionDrugCode
    .s:AroundOpeDrug="1" AroundOpeDrugDesc="Yes"
    .s:AroundOpeDrug="0" AroundOpeDrugDesc="No"
    .s $li(Data,22)=AroundOpeDrugDesc
    .s $li(Data,23)=AroundOpeDrug
    .s:BeforeOpeDate="" BeforeOpeDate="0D0H0M"
    .s $li(Data,24)=BeforeOpeDate
    .s $li(Data,25)=AfterOpeDate
    .i RationalityCode'="" d
    ..s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(RationalityCode,"InfRationality")
    ..s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    ..q:'$IsObject(objDic)
    ..s Rationality=objDic.Description
    ..k objDic
    .s $li(Data,26)=Rationality
    .s $li(Data,27)=RationalityCode
    .i IrrationalityCode'="" d
    ..s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(IrrationalityCode,"InfIrrationality")
    ..s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    ..q:'$IsObject(objDic)
    ..s Irrationality=objDic.Description
    ..k objDic
    .s $li(Data,28)=Irrationality
    .s $li(Data,29)=IrrationalityCode
    .i CurativeEffectCode'="" d
    ..s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(CurativeEffectCode,"InfCurativeEffect")
    ..s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    ..q:'$IsObject(objDic)
    ..s CurativeEffect=objDic.Description
    ..k objDic
    .s $li(Data,30)=CurativeEffect
    .s $li(Data,31)=CurativeEffectCode
    .s $li(Data,32)=checked
    .s $li(Data,33)=childSub
    .s $li(Data,34)=ResumeText
    .i OprBeforInfo'="" d
    ..s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(OprBeforInfo,"OprBeforInfo")
    ..s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    ..q:'$IsObject(objDic)
    ..s OprBeforInfoDesc=objDic.Description
    ..k objDic
    .s $li(Data,35)=OprBeforInfo
    .s $li(Data,36)=OprBeforInfoDesc
    .i OprAfterInfo'="" d
    ..s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(OprAfterInfo,"OprAfterInfo")
    ..s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    ..q:'$IsObject(objDic)
    ..s OprAfterInfoDesc=objDic.Description
    ..k objDic
    .s $li(Data,37)=OprAfterInfo
    .s $li(Data,38)=OprAfterInfoDesc
    .s $li(Data,39)=Text1
    .s $li(Data,40)=AricmSumInfo
    .s ^CacheTemp(repid,ind)=Data
    .s ind=ind+1
    .k ^TMP($j,"arcItmDt",arcim)
    */
 	Quit:Paadm="" $$$OK
 	
 	Set ZIndex=$zn,JIndex=$j
 	Kill ^TMP(ZIndex,JIndex,"QryArcimByPaadm")
 	
 	//add by wuqk 2012-04-09 for NewOrderModel
 	Set NewOrderModel=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHosp("NewOrderModel")
    
 	Set OrderID=$o(^OEORD(0,"Adm",Paadm,""))
 	Set ArcimID=""
 	For {
	 	Set ArcimID=$o(^OEORDi(0,"ARCIM",+OrderID,ArcimID))
	 	Quit:ArcimID=""
	 	Set objArcim=##class(DHCMed.Base.Arcim).GetObjById(ArcimID)
	 	Continue:'$IsObject(objArcim)
	 	Set ARCICOrderType=objArcim.ARCICOrderType
	 	Continue:ARCICOrderType'="R"
	 	Set ARCIMPHCDFDR=objArcim.ARCIMPHCDFDR
	 	Set objPhc=##class(DHCMed.Base.PHC).GetObjById(ARCIMPHCDFDR)
	 	Continue:(DrugFlag'="")&((objPhc.PHCCDesc'["抗感染")&(objPhc.PHCCDesc'["抗生素")&(objPhc.PHCCDesc'["抗微生物"))
		//Continue:(DrugFlag'="")&((objPhc.PHCSCDesc'["抗感染")&(objPhc.PHCSCDesc'["抗生素")&(objPhc.PHCSCDesc'["抗微生物"))
		Set StartDate=0
		For {
			Set StartDate=$o(^OEORDi(0,"ARCIM",+OrderID,ArcimID,StartDate))
			Quit:StartDate=""
			Set SubID=0
			For {
				Set SubID=$o(^OEORDi(0,"ARCIM",+OrderID,ArcimID,StartDate,SubID))
				Quit:SubID=""
				
				Set FillerNo=$p($g(^OEORD(OrderID,"I",SubID,9)),"^",12)
				If FillerNo'="" {
					Set OEOrdID=$p(FillerNo,"!!",1)
				}Else{
					Set OEOrdID=OrderID_"||"_SubID
				}
				Continue:OEOrdID=""
				
				Set xDate=$p($g(^OEORD(OrderID,"I",SubID,3)),"^",34)
				Continue:(+xDate)'=0  //停止的医嘱过滤掉
				
				Set ^TMP(ZIndex,JIndex,"QryArcimByPaadm",OEOrdID,SubID)=FillerNo
				//w OEOrdID_"///"_OrderID_"||"_SubID,!
			}
		}
	}
	
	Set OEOrdID=""
	For {
		Set OEOrdID=$o(^TMP(ZIndex,JIndex,"QryArcimByPaadm",OEOrdID))
		Quit:OEOrdID=""
		
	    Set DrugsRoute="" ,DrugsRouteCode="",checked="",childSub="",AdmDrugs="" , AdmDrugsCode=""
	    Set InfAdmDrugsGoal="" ,InfAdmDrugsGoalCode="",CureAdmDrugsType="" ,CureAdmDrugsTypeCode=""
	    Set DefendAdmDrugsType="" ,DefendAdmDrugsTypeCode="",IndicationDesc="" ,Indication=""
	    Set Effect="" ,EffectCode="",UnionDrug="" ,UnionDrugCode="",AroundOpeDrugDesc="" ,AroundOpeDrug=""
	    Set BeforeOpeDate="" ,AfterOpeDate="",Rationality="" ,RationalityCode="",Irrationality="" ,IrrationalityCode=""
	    Set CurativeEffect="" ,CurativeEffectCode="",ResumeText=""
	    Set OprBeforInfo="",OprBeforInfoDesc="",OprAfterInfo="",OprAfterInfoDesc="",Text1=""
		
		Set FstSubID=0,LstSubID=0,OEOrdStartDate=0,OEOrdEndDate=0,StartDateList="",OEORIDays=0
		Set SubID=0
		For {
			Set SubID=$o(^TMP(ZIndex,JIndex,"QryArcimByPaadm",OEOrdID,SubID))
			Quit:SubID=""
			
			Set OEORIID=(+OEOrdID)_"||"_SubID
			Set objOEORI=##class(DHCMed.Base.OrdItem).GetObjById(OEORIID)
			Continue:'$IsObject(objOEORI)
			Set tmpStartDate=objOEORI.OEORISttDat
			Set tmpEndDate=objOEORI.OEORIXDate         //add by wuqk 2012-04-09 for NewOrderModel EndDate
			Continue:(+tmpStartDate)=0
			
			If (FstSubID=0)||(SubID<FstSubID) {
				Set FstSubID=SubID
			}
			If (LstSubID=0)||(SubID>LstSubID) {
				Set LstSubID=SubID
			}
			Set tmpStartDate=+tmpStartDate
			If (OEOrdStartDate=0)||(tmpStartDate<OEOrdStartDate) {
				Set OEOrdStartDate=+tmpStartDate
			}
			If (NewOrderModel=1){ //add by wuqk 2012-04-09 for NewOrderModel
				Set OEOrdEndDate=tmpEndDate
				Set:+tmpEndDate=0 tmpEndDate=+$h
				Set:tmpEndDate>=tmpStartDate OEORIDays=OEORIDays+tmpEndDate-tmpStartDate+1
			}
			Else {
				If (OEOrdEndDate=0)||(tmpStartDate>OEOrdEndDate) {
					Set OEOrdEndDate=tmpStartDate
				}
				If $listfind(StartDateList,tmpStartDate)<1 {
					Set StartDateList=StartDateList_$lb(tmpStartDate)
				}
			}
		}
		Set OEOrdStartDate=$zd(+OEOrdStartDate,3)
		Set:OEOrdEndDate'="" OEOrdEndDate=$zd(+OEOrdEndDate,3)  //add by wuqk 2012-04-09 for NewOrderModel
		Set:NewOrderModel'=1 OEORIDays=$listlength(StartDateList)
		
		Set FstOEORIID=(+OEOrdID)_"||"_FstSubID
		Set objOEORI=##class(DHCMed.Base.OrdItem).GetObjById(FstOEORIID)
		Continue:'$IsObject(objOEORI)
		Set OEORIItmMastDR=objOEORI.OEORIItmMastDR
		Set OEORIItmMast=$p($g(^ARCIM(+OEORIItmMastDR,+$p(OEORIItmMastDR,"||",2),1)),"^",2)
		Continue:OEORIItmMast=""
		Set OEORIInstrDR=objOEORI.OEORIInstrDR  //PHC_Instruc  用法
		Set OEORIInstr=$p($g(^PHCIN(+OEORIInstrDR)),"^",2)
		Set:$p(OEORIInstr,"-",2)'="" OEORIInstr=$p(OEORIInstr,"-",2)
		Set DrugsRouteCode=OEORIInstr
		Set AricmSumInfo=objOEORI.OEORIDoseQty_"/"_objOEORI.CTUOMDesc_";"_objOEORI.PHCFRDesc1_";"_objOEORI.PHCDUDesc1_";"_objOEORI.PHCINDesc1
		
	    //取院感报告内容
	    Set repDr=+InfRepDr
	    If repDr'="" {
		    Set childSub=$o(^DHCMed.INF.RepDrugI("InfRepOeIdx",repDr," "_$ZCVT(FstOEORIID,"U"),0))
		    Set objRepDrug=##class(DHCMed.INF.RepDrug).GetObjById(childSub)
		    If $IsObject(objRepDrug) {
			    Set checked=1
			    Set DrugsRouteCode=objRepDrug.Instr
			    Set AdmDrugsCode=objRepDrug.Mode
			    Set InfAdmDrugsGoalCode=objRepDrug.Aim
			    Set CureAdmDrugsTypeCode=objRepDrug.CureDrugMode
			    Set DefendAdmDrugsTypeCode=objRepDrug.PrevDrugMode
			    Set Indication=objRepDrug.PrevDrugFlag
			    Set EffectCode=objRepDrug.PrevDrugEffect
			    Set UnionDrugCode=objRepDrug.UniteDrug
			    Set AroundOpeDrug=objRepDrug.OprDrugFlag
			    Set BeforeOpeDate=objRepDrug.PreDrugTime
			    Set AfterOpeDate=objRepDrug.AftDrugDays
			    Set RationalityCode=objRepDrug.RightFlag
			    Set IrrationalityCode=objRepDrug.Impertinency
			    Set CurativeEffectCode=objRepDrug.Effect
			    Set ResumeText=objRepDrug.ResumeText
			    Set OprBeforInfo=objRepDrug.OprBeforInfo
			    Set OprAfterInfo=objRepDrug.OprAfterInfo
			    Set Text1=objRepDrug.Text1
		    }
	    }
	    
		Set Data=$lb("")
	    //Set $li(Data,1)=OEORIItmMastDR   //医嘱项ID
	    Set $li(Data,1)=FstOEORIID
	    Set $li(Data,2)=OEORIItmMast     //医嘱项名称
		
	    //给药途径 用法 PHC_Instruc
	    i DrugsRouteCode'="" d
	    .s DrugsRouteCode=##Class(DHCMed.SSService.DictionarySrv).GetIDByDesc("","InfectionAdministerDrugsRoute",OEORIInstr)
	    .i DrugsRouteCode'="" d
	    ..s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(DrugsRouteCode,"InfectionAdministerDrugsRoute")
	    ..s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
	    ..i $IsObject(objDic) d
	    ...s DrugsRoute=objDic.Description
	    ...k objDic
	    s $li(Data,3)=DrugsRoute
	    s $li(Data,4)=DrugsRouteCode
	    
	    s $li(Data,5)=OEOrdStartDate
	    s $li(Data,6)=OEOrdEndDate
	    s $li(Data,7)=OEORIDays
	    
	    i AdmDrugsCode'="" d
	    .s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(AdmDrugsCode,"InfectionAdministerDrugs")
	    .s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
	    .q:'$IsObject(objDic)
	    .s AdmDrugs=objDic.Description
	    .k objDic
	    s $li(Data,8)=AdmDrugs
	    s $li(Data,9)=AdmDrugsCode
	    
	    i InfAdmDrugsGoalCode'="" d
	    .s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(InfAdmDrugsGoalCode,"InfectionAdministerDrugsGoal")
	    .s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
	    .q:'$IsObject(objDic)
	    .s InfAdmDrugsGoal=objDic.Description
	    .k objDic
	    s $li(Data,10)=InfAdmDrugsGoal
	    s $li(Data,11)=InfAdmDrugsGoalCode
	    
	    i CureAdmDrugsTypeCode'="" d
	    .s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(CureAdmDrugsTypeCode,"InfectionCureAdministerDrugsType")
	    .s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
	    .q:'$IsObject(objDic)
	    .s CureAdmDrugsType=objDic.Description
	    .k objDic
	    s $li(Data,12)=CureAdmDrugsType
	    s $li(Data,13)=CureAdmDrugsTypeCode
	    
	    i DefendAdmDrugsTypeCode'="" d
	    .s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(DefendAdmDrugsTypeCode,"InfectionDefendAdministerDrugsType")
	    .s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
	    .q:'$IsObject(objDic)
	    .s DefendAdmDrugsType=objDic.Description
	    .k objDic
	    s $li(Data,14)=DefendAdmDrugsType
	    s $li(Data,15)=DefendAdmDrugsTypeCode
	    
	    s:Indication="1" IndicationDesc="Yes"
	    s:Indication="0" IndicationDesc="No"
	    s $li(Data,16)=IndicationDesc
	    s $li(Data,17)=Indication
	    
	    i EffectCode'="" d
	    .s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(EffectCode,"InfDefendDrugEffect")
	    .s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
	    .q:'$IsObject(objDic)
	    .s Effect=objDic.Description
	    .k objDic
	    s $li(Data,18)=Effect
	    s $li(Data,19)=EffectCode
	    
	    i UnionDrugCode'="" d
	    .s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(UnionDrugCode,"InfUnionDrug")
	    .s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
	    .q:'$IsObject(objDic)
	    .s UnionDrug=objDic.Description
	    .k objDic
	    s $li(Data,20)=UnionDrug
	    s $li(Data,21)=UnionDrugCode
	    
	    s:AroundOpeDrug="1" AroundOpeDrugDesc="Yes"
	    s:AroundOpeDrug="0" AroundOpeDrugDesc="No"
	    s $li(Data,22)=AroundOpeDrugDesc
	    s $li(Data,23)=AroundOpeDrug
	    
	    s:BeforeOpeDate="" BeforeOpeDate="0D0H0M"
	    s $li(Data,24)=BeforeOpeDate
	    s $li(Data,25)=AfterOpeDate
	    
	    i RationalityCode'="" d
	    .s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(RationalityCode,"InfRationality")
	    .s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
	    .q:'$IsObject(objDic)
	    .s Rationality=objDic.Description
	    .k objDic
	    s $li(Data,26)=Rationality
	    s $li(Data,27)=RationalityCode
	    
	    i IrrationalityCode'="" d
	    .s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(IrrationalityCode,"InfIrrationality")
	    .s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
	    .q:'$IsObject(objDic)
	    .s Irrationality=objDic.Description
	    .k objDic
	    s $li(Data,28)=Irrationality
	    s $li(Data,29)=IrrationalityCode
	    
	    i CurativeEffectCode'="" d
	    .s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(CurativeEffectCode,"InfCurativeEffect")
	    .s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
	    .q:'$IsObject(objDic)
	    .s CurativeEffect=objDic.Description
	    .k objDic
	    s $li(Data,30)=CurativeEffect
	    s $li(Data,31)=CurativeEffectCode
	    
	    s $li(Data,32)=checked
	    s $li(Data,33)=childSub
	    s $li(Data,34)=ResumeText
	    
	    i OprBeforInfo'="" d
	    .s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(OprBeforInfo,"OprBeforInfo")
	    .s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
	    .q:'$IsObject(objDic)
	    .s OprBeforInfoDesc=objDic.Description
	    .k objDic
	    s $li(Data,35)=OprBeforInfo
	    s $li(Data,36)=OprBeforInfoDesc
	    
	    i OprAfterInfo'="" d
	    .s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(OprAfterInfo,"OprAfterInfo")
	    .s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
	    .q:'$IsObject(objDic)
	    .s OprAfterInfoDesc=objDic.Description
	    .k objDic
	    s $li(Data,37)=OprAfterInfo
	    s $li(Data,38)=OprAfterInfoDesc
	    
	    s $li(Data,39)=Text1
	    s $li(Data,40)=AricmSumInfo
	    
	    s ^CacheTemp(repid,ind)=Data
	    s ind=ind+1
	}
	Kill ^TMP(ZIndex,JIndex,"QryArcimByPaadm")
    
	Quit $$$OK
}

ClassMethod QryArcimByPaadmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryArcimByPaadmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryArcimByPaadmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryArcimByPaadmExecute ]
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

/// Build东华手麻系统数据
/// 一般医院的手术申请单走的是这个系统
ClassMethod BuildSysOperation(argOPArrID As %String, argORRowID As %String, argRepID As %String) As %List
{
	New (argOPArrID,argORRowID,argRepID)
	Set return=""
	Quit:(argOPArrID="")||(argORRowID="") return
	
	Set Paadm=$p(argORRowID,"||",1)
	Set AnaID=$p(argORRowID,"||",2)
	Set ORID=$p(argORRowID,"||",3)
	Quit:(Paadm="")||(AnaID="")||(ORID="") return
	
	// 手术排班表DHC_AN_OPArrange
	// ^DHCANOPArrange(0,"Adm",{OPA_Adm_dr},{OPA_RowId})
	// 麻醉表OR_Anaesthesia
	// ^OR({PA_Adm.PAADM_RowID},"ANA",{ANA_Childsub})  
	// 手术表OR_Anaest_Operation
	// ^OR({PA_Adm.PAADM_RowID},"ANA",{Childsub},"OP",{ANAOP_Childsub})
	// w ##Class(DHCMed.INFService.InfBaseAricmSrv).BuildSysOperation("","")
	Set InfOperDR=argORRowID
	Set ORInfo=$g(^OR(Paadm,"ANA",AnaID,"OP",ORID))            //->ORC_Operation
	Set OperID=$p(ORInfo,"^",6)                                //麻醉ID
	Set OperDesc=$p($g(^ORC("OPER",+OperID)),"^",2)            //手术名称
	Set OperICD10=$p($g(^ORC("OPER",+OperID)),"^",21)          //ICD9Map
	Set OperDocID=$p(ORInfo,"^",6)                             //术者ID
	Set OperDocDesc=""
	Set OPArrInfo=$g(^DHCANOPArrange(argOPArrID))
	Set OperStatus=$p(OPArrInfo,"^",27)                        //手术状态
	Quit:OperStatus="NotApp" return
	Set StartDate=$p(OPArrInfo,"^",14)                         //开始日期
	Set:StartDate'="" StartDate=$zd(+StartDate,3)
	Set StartTime=$p(OPArrInfo,"^",15)                         //开始时间
	Set:StartTime'="" StartTime=$zt(+StartTime,1)
	Set EndDate=$p(OPArrInfo,"^",16)                           //结束日期
	Set:EndDate'="" EndDate=$zd(+EndDate,3)
	Set EndTime=$p(OPArrInfo,"^",17)                           //结束时间
	Set:EndTime'="" EndTime=$zt(+EndTime,1)
	Set $li(Data,1)=InfOperDR
	Set $li(Data,2)=OperDesc
	Set $li(Data,3)=StartDate
	Set $li(Data,4)=OperStatus
	
    ..s oeori=Paadm_"||"_anaChild_"||"_opChild
    ..s s=$g(^OR(Paadm,"ANA",anaChild,"OP",opChild))
    ..s OPTypeDR=$p(s,"^",6)            ;
    ..s arcimDesc=$p($g(^ORC("OPER",OPTypeDR)),"^",2)
    ..s OPICD9Map=$p($g(^ORC("OPER",OPTypeDR)),"^",21)
    ..s sArr=$g(^DHCANOPArrange(oparr))
    ..s OperStatus=$p(sArr,"^",27)
    ..//Apply,Decline,Receive,InRoom,Operate,LeaveRoom,Finish,NotApp
    ..q:(OperStatus="NotApp")
    ..s sttDate=+$p(sArr,"^",14)
    ..s:sttDate'=0 sttDate=$zd(sttDate,3)
    ..s:sttDate=0 sttDate=""
    ..//s HospCode=$$GetHospitalCode^DHCMedBase02()
    ..s Data=$lb("")
    ..s $li(Data,1)=oeori           //
    ..s $li(Data,2)=arcimDesc
    ..s $li(Data,3)=StartDate
    ..s $li(Data,4)=OperStatus
    ..s EmerOprFlag="",EmerOprFlagDesc="",DateFrom="",TimeFrom="",DateTo="",TimeTo="",OprDoc="",OprDocDesc="",Anaesthesia="",AnaesthesiaDesc="",childSub="",checked=""
    ..s (CuteType,CuteTypeDesc,Concrescence,ConcrescenceDesc,CuteInfFlag,CuteInfFlagDesc,OprCuteType,OprCuteTypeDesc,InfectionFlag,InfectionFlagDesc,OperICD9Map,ResumeText)=""
    ..s (OprCDZBInfo,OprCDZBInfoDesc,OprZGInfo,OprZGInfoDesc,OprZGDtInfo,OprInfDate,OprInfNongY,OprInfNongYDesc,OprDiasInfo,OprSXInfo,OprSXInfoDesc,OprSHUXInfo,OprSHUXInfoDesc,OprCKongInfo,OprCKongInfoDesc)=""
    ..s (OprLGuanInfo,OprLGuanInfoDesc,OprWKYLInfo,OprWKYLInfoDesc,Text1,OprSXLInfo,OprSHUXLInfo)=""
    ..// ^DHCMed.INF.RepOPRI
    ..s (OprSKQJD,OprSKQJDDesc,OprBWFL,OprBWFLDesc,OprDangerCls,OprDangerClsDesc,OprInfCtLoc,OprInfCtLocDesc)=""
    ..s DateFrom=sttDate
    ..s DateTo=+$p(sArr,"^",16)
    ..s:DateTo'=0 DateTo=$zd(DateTo,3)
    ..s:DateTo=0 DateTo=""
    ..s TimeFrom=+$p(sArr,"^",15)
    ..s:TimeFrom'=0 TimeFrom=$zt(TimeFrom,1)
    ..s:TimeFrom=0 TimeFrom=""
    ..s TimeTo=+$p(sArr,"^",17)
    ..s:TimeTo'=0 TimeTo=$zt(TimeTo,2)
    ..s:TimeTo=0 TimeTo=""
    ..s OprDoc=$p(s,"^",8)
    ..s objUser=##class(DHCMed.Base.SSUser).GetObjById(OprDoc)
    ..s:'$IsObject(objUser) OprDocDesc=objUser.Name
    ..//一助
    ..//二助
    ..s assList=""
    ..s ass=0
    ..f  s ass=$o(^OR(Paadm,"ANA",anaChild,"OP",opChild,"ASS",ass)) q:ass=""  d
    ...s assDr=$g(^OR(Paadm,"ANA",anaChild,"OP",opChild,"ASS",ass))
    ...s objUser=##class(DHCMed.Base.SSUser).GetObjById(assDr)
    ...q:'$IsObject(objUser)
    ...s assDoctor=objUser.Name
    ...s:assDoctor'="" assList=assList_assDoctor_$c(3)
    ..s AnaesthesiaStr=$g(^OR(Paadm,"ANA",anaChild))
    ..s anDoctor=""  //麻醉医生
    ..s anDocDr=$p(AnaesthesiaStr,"^",7)
    ..s objUser=##class(DHCMed.Base.SSUser).GetObjById(anDocDr)
    ..s:$IsObject(objUser) anDoctor=objUser.Name
    ..s AnaesthesiaDesc=$p(AnaesthesiaStr,"^",5)
    ..s:AnaesthesiaDesc'="" AnaesthesiaDesc=$p(^ORC("ANMET",AnaesthesiaDesc),"^",2)
    ..i repDr'="" d   ///已经保存过的数据
    ...q:oeori=""
    ...s oeoriIdx=" "_$ZCVT(oeori,"U")
    ...q:'$d(^DHCMed.INF.RepOPRI("InfRepOeoriIdx",repDr,oeoriIdx))
    ...s childSub=$o(^DHCMed.INF.RepOPRI("InfRepOeoriIdx",repDr,oeoriIdx,0))
    ...q:childSub=""
    ...s objRepOPR=##class(DHCMed.INF.RepOPR).GetObjById(childSub)
    ...q:'$IsObject(objRepOPR)
    ...s checked=1
    ...s EmerOprFlag=objRepOPR.EmerOprFlag
    ...s:EmerOprFlag["Y" EmerOprFlagDesc="Yes"
    ...s:EmerOprFlag["N" EmerOprFlagDesc="No"
    ...s DateFrom=objRepOPR.DateFrom
    ...s TimeFrom=objRepOPR.TimeFrom
    ...s DateTo=objRepOPR.DateTo
    ...s TimeTo=objRepOPR.TimeTo
    ...s OprDoc=objRepOPR.OprDoc
    ...s Anaesthesia=objRepOPR.Anaesthesia
    ...s CuteType=objRepOPR.CuteType
    ...s Concrescence=objRepOPR.Concrescence
    ...s CuteInfFlag=objRepOPR.CuteInfFlag
    ...s OprCuteType=objRepOPR.OprCuteType
    ...s InfectionFlag=objRepOPR.InfectionFlag
    ...//s OperICD9Map=objRepOPR.OEORIDr
    ...s OperICD9Map=objRepOPR.OperICD9Map
    ...s ResumeText=objRepOPR.ResumeText          ////////end
    ...s OprCDZBInfo=objRepOPR.OprCDZBInfo
    ...s OprZGInfo=objRepOPR.OprZGInfo
    ...s OprZGDtInfo=objRepOPR.OprZGDtInfo
    ...s OprInfDate=objRepOPR.OprInfDate
    ...s OprInfNongY=objRepOPR.OprInfNongY
    ...s OprDiasInfo=objRepOPR.OprDiasInfo
    ...s OprSXInfo=objRepOPR.OprSXInfo
    ...s OprSHUXInfo=objRepOPR.OprSHUXInfo
    ...s OprCKongInfo=objRepOPR.OprCKongInfo
    ...s OprLGuanInfo=objRepOPR.OprLGuanInfo
    ...s OprWKYLInfo=objRepOPR.OprWKYLInfo
    ...s Text1=objRepOPR.Text1
    ...s OprSXLInfo=objRepOPR.OprSXLInfo
    ...s OprSHUXLInfo=objRepOPR.OprSHUXLInfo
    ...s OprSKQJD=objRepOPR.OprSKQJD
    ...s OprBWFL=objRepOPR.OprBWFL
    ...s OprDangerCls=objRepOPR.OprDangerCls
    ...s OprInfCtLoc=objRepOPR.OprInfCtLoc
    .../// add hx
    ...s:+DateFrom'=0 DateFrom=$zd(DateFrom,3)
    ...s:+TimeFrom'=0 TimeFrom=$zt(TimeFrom,1)
    ...s:+DateTo'=0 DateTo=$zd(DateTo,3)
    ...s:+TimeTo'=0 TimeTo=$zt(TimeTo,1)
    ...s:+OprZGDtInfo'=0 OprZGDtInfo=$zd(OprZGDtInfo,3)
    ...s:+OprInfDate'=0 OprInfDate=$zd(OprInfDate,3)
    ...i OprInfCtLoc'="" d
    ....s objTmp=##class(DHCMed.Base.Ctloc).GetObjById(OprInfCtLoc)
    ....q:'$IsObject(objTmp)
    ....s OprInfCtLocDesc=objTmp.Descs
    ...i OprDangerCls'="" d
    ....s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(OprDangerCls,"OprDangerCls")
    ....s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    ....q:'$IsObject(objDic)
    ....s OprDangerClsDesc=objDic.Description
    ....k objDic
    ...i OprBWFL'="" d
    ....s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(OprBWFL,"OprBWFL")
    ....s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    ....q:'$IsObject(objDic)
    ....s OprBWFLDesc=objDic.Description
    ....k objDic
    ...i OprSKQJD'="" d
    ....s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(OprSKQJD,"InfectionCutType")
    ....s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    ....q:'$IsObject(objDic)
    ....s OprSKQJDDesc=objDic.Description
    ....k objDic
    ...i OprWKYLInfo'="" d
    ....s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(OprWKYLInfo,"OprWKYLInfo")
    ....s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    ....q:'$IsObject(objDic)
    ....s OprWKYLInfoDesc=objDic.Description
    ....k objDic
    ...i OprLGuanInfo'="" d
    ....s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(OprLGuanInfo,"OprLGuanInfo")
    ....s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    ....q:'$IsObject(objDic)
    ....s OprLGuanInfoDesc=objDic.Description
    ....k objDic
    ...i OprCKongInfo'="" d
    ....s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(OprCKongInfo,"OprCKongInfo")
    ....s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    ....q:'$IsObject(objDic)
    ....s OprCKongInfoDesc=objDic.Description
    ....k objDic
    ...i OprSHUXInfo'="" d
    ....s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(OprSHUXInfo,"OprSHUXInfo")
    ....s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    ....q:'$IsObject(objDic)
    ....s OprSHUXInfoDesc=objDic.Description
    ....k objDic
    ...i OprSXInfo'="" d
    ....s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(OprSXInfo,"OprSXInfo")
    ....s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    ....q:'$IsObject(objDic)
    ....s OprSXInfoDesc=objDic.Description
    ....k objDic
    ...i OprInfNongY'="" d
    ....s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(OprInfNongY,"OprInfNongY")
    ....s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    ....q:'$IsObject(objDic)
    ....s OprInfNongYDesc=objDic.Description
    ....k objDic
    ...i OprZGInfo'="" d
    ....s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(OprZGInfo,"InfectionDiagnosePrognosis")
    ....s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    ....q:'$IsObject(objDic)
    ....s OprZGInfoDesc=objDic.Description
    ....k objDic
    ...i OprCDZBInfo'="" d
    ....s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(OprCDZBInfo,"OprCDZBInfo")
    ....s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    ....q:'$IsObject(objDic)
    ....s OprCDZBInfoDesc=objDic.Description
    ....k objDic
    ...i OprDoc'="" d
    ....s objUser=##class(DHCMed.Base.SSUser).GetObjById(OprDoc)
    ....q:'$IsObject(objUser)
    ....s OprDocDesc=objUser.Name
    ....k objUser
    ...i EmerOprFlag'="" d
    ....s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(EmerOprFlag,"OperationType")
    ....s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    ....q:'$IsObject(objDic)
    ....s EmerOprFlagDesc=objDic.Description
    ....k objDic
    ...i Anaesthesia'="" d
    ....s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(Anaesthesia,"InfectionNarcosisType")
    ....s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    ....q:'$IsObject(objDic)
    ....s AnaesthesiaDesc=objDic.Description
    ....k objDic
    ...i CuteType'="" d
    ....s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(CuteType,"InfectionOpeCutType")
    ....s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    ....q:'$IsObject(objDic)
    ....s CuteTypeDesc=objDic.Description
    ....k objDic
    ...i Concrescence'="" d
    ....s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(Concrescence,"InfectionWoundCicatrize")
    ....s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    ....q:'$IsObject(objDic)
    ....s ConcrescenceDesc=objDic.Description
    ....k objDic
    ...s:CuteInfFlag="1" CuteInfFlagDesc="Yes"
    ...s:CuteInfFlag="0" CuteInfFlagDesc="No"
    ...i OprCuteType'="" d
    ....s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(OprCuteType,"InfectionOperationCutType")
    ....s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    ....q:'$IsObject(objDic)
    ....s OprCuteTypeDesc=objDic.Description
    ....k objDic
    ...s:InfectionFlag="1" InfectionFlagDesc="Yes"
    ...s:InfectionFlag="0" InfectionFlagDesc="No"
    ..s $li(Data,5)=EmerOprFlag
    ..s $li(Data,6)=EmerOprFlagDesc
    ..s $li(Data,7)=DateFrom
    ..s $li(Data,8)=TimeFrom
    ..s $li(Data,9)=DateTo
    ..s $li(Data,10)=TimeTo
    ..s $li(Data,11)=OprDoc
    ..s $li(Data,12)=OprDocDesc
    ..s $li(Data,13)=Anaesthesia
    ..s $li(Data,14)=AnaesthesiaDesc
    ..s $li(Data,15)=CuteType
    ..s $li(Data,16)=CuteTypeDesc
    ..s $li(Data,17)=Concrescence
    ..s $li(Data,18)=ConcrescenceDesc
    ..s $li(Data,19)=CuteInfFlag
    ..s $li(Data,20)=CuteInfFlagDesc
    ..s $li(Data,21)=OprCuteType
    ..s $li(Data,22)=OprCuteTypeDesc
    ..s $li(Data,23)=InfectionFlag
    ..s $li(Data,24)=InfectionFlagDesc
    ..s $li(Data,25)=OperICD9Map
    ..s $li(Data,26)=ResumeText
    ..s $li(Data,27)=checked
    ..s $li(Data,28)=childSub    //checked
    ..s $li(Data,29)=OprCDZBInfo
    ..s $li(Data,30)=OprCDZBInfoDesc
    ..s $li(Data,31)=OprZGInfo
    ..s $li(Data,32)=OprZGInfoDesc
    ..s $li(Data,33)=OprZGDtInfo
    ..s $li(Data,34)=OprInfDate
    ..s $li(Data,35)=OprInfNongY
    ..s $li(Data,36)=OprInfNongYDesc
    ..s $li(Data,37)=OprDiasInfo
    ..s $li(Data,38)=OprSXInfo
    ..s $li(Data,39)=OprSXInfoDesc
    ..s $li(Data,40)=OprSHUXInfo
    ..s $li(Data,41)=OprSHUXInfoDesc
    ..s $li(Data,42)=OprCKongInfo
    ..s $li(Data,43)=OprCKongInfoDesc
    ..s $li(Data,44)=OprLGuanInfo
    ..s $li(Data,45)=OprLGuanInfoDesc
    ..s $li(Data,46)=OprWKYLInfo
    ..s $li(Data,47)=OprWKYLInfoDesc
    ..s $li(Data,48)=Text1
    ..s $li(Data,49)=OprSXLInfo
    ..s $li(Data,50)=OprSHUXLInfo
    ..s $li(Data,51)=OprSKQJD
    ..s $li(Data,52)=OprSKQJDDesc
    ..s $li(Data,53)=OprBWFL
    ..s $li(Data,54)=OprBWFLDesc
    ..s $li(Data,55)=OprDangerCls
    ..s $li(Data,56)=OprDangerClsDesc
    ..s $li(Data,57)=OprInfCtLoc
    ..s $li(Data,58)=OprInfCtLocDesc
    ..s ^CacheTemp(repid,ind)=Data
    ..s ind=ind+1
	Quit return
}

/// Creator：     ChenJB
/// CreatDate：   2010-05-19
/// Description:  查询病人手术的信息
/// Table：       DHCMed.Base.OrdItem
/// Input：       Paadm ： 就诊
/// output:       符合条件的项            
/// Return：      
/// D ##class(%ResultSet).RunQuery("DHCMed.INFService.InfBaseAricmSrv","QryOperationByPaadm","58008","1")
Query QryOperationByPaadm(Paadm As %String = "", TypeCode As %String = "", InfRepDr As %String = "") As %Query(ROWSPEC = "Rowid:%String,ArcimName:%String,sttDate:%String,OrdStsDesc:%String,EmerOprFlag:%String,EmerOprFlagDesc:%String,DateFrom:%String,TimeFrom:%String,DateTo:%String,TimeTo:%String,OprDoc:%String,OprDocDesc:%String,Anaesthesia:%String,AnaesthesiaDesc:%String,CuteType:%String,CuteTypeDesc:%String,Concrescence:%String,ConcrescenceDesc:%String,CuteInfFlag:%String,CuteInfFlagDesc:%String,OprCuteType:%String,OprCuteTypeDesc:%String,InfectionFlag:%String,InfectionFlagDesc:%String,OperICD9Map:%String,ResumeText:%String,checked:%String,childSub:%String,OprCDZBInfo:%String,OprCDZBInfoDesc:%String,OprZGInfo:%String,OprZGInfoDesc:%String,OprZGDtInfo:%String,OprInfDate:%String,OprInfNongY:%String,OprInfNongYDesc:%String,OprDiasInfo:%String,OprSXInfo:%String,OprSXInfoDesc:%String,OprSHUXInfo:%String,OprSHUXInfoDesc:%String,OprCKongInfo:%String,OprCKongInfoDesc:%String,OprLGuanInfo:%String,OprLGuanInfoDesc:%String,OprWKYLInfo:%String,OprWKYLInfoDesc:%String,Text1:%String,OprSXLInfo:%String,OprSHUXLInfo:%String,OprSKQJD:%String,OprSKQJDDesc:%String,OprBWFL:%String,OprBWFLDesc:%String,OprDangerCls:%String,OprDangerClsDesc:%String,OprInfCtLoc:%String,OprInfCtLocDesc:%String")
{
}

ClassMethod QryOperationByPaadmExecute(ByRef qHandle As %Binary, Paadm As %String = "", TypeCode As %String = "", InfRepDr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:Paadm="" $$$OK
 	Quit:TypeCode="" $$$OK
 	
 	//Set repDr=##class(DHCMed.INFService.InfReportSrv).GetReportID(+Paadm,TypeCode)
 	Set repDr=InfRepDr
 	Set OrdsOperFlag=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("OrdsOperFlag","")
 	
 	If OrdsOperFlag=0 {
 		d GetOrdsOper         //取手术医嘱信息
 	} ElseIf OrdsOperFlag=1 {
 		d GetAZOperation      //取手术申请信息
 	} ElseIf OrdsOperFlag=2 {
 		d GetSysOper          //取手术麻醉系统信息
 	} ElseIf OrdsOperFlag=3 {
 		d GetEPROperation     //取电子病历系统信息
	} Else {
		d GetOrdsOper         //取手术医嘱信息
	}
	
	Quit $$$OK
	
GetOrdsOper
    q:'$d(^OEORD(0,"Adm",+Paadm))     
    s oeord=$o(^OEORD(0,"Adm",+Paadm,""))
    //s HospCode=$$GetHospitalCode^DHCMedBase02()
    s objOeord=##class(DHCMed.Base.OeOrder).GetObjById(oeord)
    q:'$IsObject(objOeord)
    s arcim=""
    f  s arcim=$o(^OEORDi(0,"ARCIM",+oeord,arcim)) q:arcim=""  d
    .s objCls=##class(DHCMed.Base.Arcim).GetObjById(arcim)
    .q:'$IsObject(objCls)
    .//S OrdCatSubDesc=$p($g(^ARC("IC",+ItmCat)),"^",2) // ARCICDesc
    .q:objCls.ORCATDesc'["手术"
    .//q:(HospCode="ShangHai_HSDY")&&(objCls.ARCICDesc'["普通手术")  // objCls.ARCICDesc
    .s ordDate="" f  s ordDate=$o(^OEORDi(0,"ARCIM",+oeord,arcim,ordDate)) q:ordDate=""  d
    ..s oeoriSub=0 f  s oeoriSub=$o(^OEORDi(0,"ARCIM",+oeord,arcim,ordDate,oeoriSub)) q:oeoriSub=""  d
    ...s oeori=oeord_"||"_oeoriSub
    ...s objOeorICls=##class(DHCMed.Base.OrdItem).GetObjById(oeori)
    ...q:'$IsObject(objOeorICls)
    ...// OEORIItemStatDR
    ...s OrderStatusDesc=objOeorICls.OSTATDesc
    ...s OrderStatusCode=objOeorICls.OSTATCode
    ...q:(OrderStatusCode="D")!(OrderStatusCode="S")
    ...s arcimDesc=objCls.ARCIMDesc
    ...s sttDate=+objOeorICls.OEORISttDat
    ...s Data=$lb("")
    ...s $li(Data,1)=oeori           //
    ...s $li(Data,2)=arcimDesc
    ...s $li(Data,3)=$zd(+sttDate,3)
    ...s $li(Data,4)=OrderStatusDesc
    ...s EmerOprFlag="",EmerOprFlagDesc="",DateFrom="",TimeFrom="",DateTo="",TimeTo="",OprDoc="",OprDocDesc="",Anaesthesia="",AnaesthesiaDesc="",childSub="",checked=""
    ...s (CuteType,CuteTypeDesc,Concrescence,ConcrescenceDesc,CuteInfFlag,CuteInfFlagDesc,OprCuteType,OprCuteTypeDesc,InfectionFlag,InfectionFlagDesc,OperICD9Map,ResumeText)=""
    ...s (OprCDZBInfo,OprCDZBInfoDesc,OprZGInfo,OprZGInfoDesc,OprZGDtInfo,OprInfDate,OprInfNongY,OprInfNongYDesc,OprDiasInfo,OprSXInfo,OprSXInfoDesc,OprSHUXInfo,OprSHUXInfoDesc,OprCKongInfo,OprCKongInfoDesc)=""
    ...s (OprLGuanInfo,OprLGuanInfoDesc,OprWKYLInfo,OprWKYLInfoDesc,Text1,OprSXLInfo,OprSHUXLInfo)=""
    ...// ^DHCMed.INF.RepOPRI
    ...s (OprSKQJD,OprSKQJDDesc,OprBWFL,OprBWFLDesc,OprDangerCls,OprDangerClsDesc,OprInfCtLoc,OprInfCtLocDesc)=""
    ...i repDr'="" d   ///已经保存过的数据
    ....q:oeori=""
    ....s oeoriIdx=" "_$ZCVT(oeori,"U")
    ....q:'$d(^DHCMed.INF.RepOPRI("InfRepOeoriIdx",repDr,oeoriIdx))
    ....s childSub=$o(^DHCMed.INF.RepOPRI("InfRepOeoriIdx",repDr,oeoriIdx,0))
    ....q:childSub=""
    ....s objRepOPR=##class(DHCMed.INF.RepOPR).GetObjById(childSub)
    ....q:'$IsObject(objRepOPR)
    ....s checked=1
    ....s EmerOprFlag=objRepOPR.EmerOprFlag
    ....s:EmerOprFlag["Y" EmerOprFlagDesc="Yes"
    ....s:EmerOprFlag["N" EmerOprFlagDesc="No"
    ....s DateFrom=objRepOPR.DateFrom
    ....s TimeFrom=objRepOPR.TimeFrom
    ....s DateTo=objRepOPR.DateTo
    ....s TimeTo=objRepOPR.TimeTo
    ....s OprDoc=objRepOPR.OprDoc
    ....s Anaesthesia=objRepOPR.Anaesthesia
    ....s CuteType=objRepOPR.CuteType
    ....s Concrescence=objRepOPR.Concrescence
    ....s CuteInfFlag=objRepOPR.CuteInfFlag
    ....s OprCuteType=objRepOPR.OprCuteType
    ....s InfectionFlag=objRepOPR.InfectionFlag
    ....//s OperICD9Map=objRepOPR.OEORIDr
    ....s OperICD9Map=objRepOPR.OperICD9Map
    ....s ResumeText=objRepOPR.ResumeText          ////////end
    ....s OprCDZBInfo=objRepOPR.OprCDZBInfo
    ....s OprZGInfo=objRepOPR.OprZGInfo
    ....s OprZGDtInfo=objRepOPR.OprZGDtInfo
    ....s OprInfDate=objRepOPR.OprInfDate
    ....s OprInfNongY=objRepOPR.OprInfNongY
    ....s OprDiasInfo=objRepOPR.OprDiasInfo
    ....s OprSXInfo=objRepOPR.OprSXInfo
    ....s OprSHUXInfo=objRepOPR.OprSHUXInfo
    ....s OprCKongInfo=objRepOPR.OprCKongInfo
    ....s OprLGuanInfo=objRepOPR.OprLGuanInfo
    ....s OprWKYLInfo=objRepOPR.OprWKYLInfo
    ....s Text1=objRepOPR.Text1
    ....s OprSXLInfo=objRepOPR.OprSXLInfo
    ....s OprSHUXLInfo=objRepOPR.OprSHUXLInfo
    ....s OprSKQJD=objRepOPR.OprSKQJD
    ....s OprBWFL=objRepOPR.OprBWFL
    ....s OprDangerCls=objRepOPR.OprDangerCls
    ....s OprInfCtLoc=objRepOPR.OprInfCtLoc
    ..../// add hx
    ....s:+DateFrom'=0 DateFrom=$zd(DateFrom,3)
    ....s:+TimeFrom'=0 TimeFrom=$zt(TimeFrom,1)
    ....s:+DateTo'=0 DateTo=$zd(DateTo,3)
    ....s:+TimeTo'=0 TimeTo=$zt(TimeTo,1)
    ....s:+OprZGDtInfo'=0 OprZGDtInfo=$zd(OprZGDtInfo,3)
    ....s:+OprInfDate'=0 OprInfDate=$zd(OprInfDate,3)
    ....i OprInfCtLoc'="" d
    .....s objTmp=##class(DHCMed.Base.Ctloc).GetObjById(OprInfCtLoc)
    .....q:'$IsObject(objTmp)
    .....s OprInfCtLocDesc=objTmp.Descs
    ....i OprDangerCls'="" d
    .....s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(OprDangerCls,"OprDangerCls")
    .....s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    .....q:'$IsObject(objDic)
    .....s OprDangerClsDesc=objDic.Description
    .....k objDic
    ....i OprBWFL'="" d
    .....s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(OprBWFL,"OprBWFL")
    .....s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    .....q:'$IsObject(objDic)
    .....s OprBWFLDesc=objDic.Description
    .....k objDic
    ....i OprSKQJD'="" d
    .....s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(OprSKQJD,"InfectionCutType")
    .....s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    .....q:'$IsObject(objDic)
    .....s OprSKQJDDesc=objDic.Description
    .....k objDic
    ....i OprWKYLInfo'="" d
    .....s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(OprWKYLInfo,"OprWKYLInfo")
    .....s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    .....q:'$IsObject(objDic)
    .....s OprWKYLInfoDesc=objDic.Description
    .....k objDic
    ....i OprLGuanInfo'="" d
    .....s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(OprLGuanInfo,"OprLGuanInfo")
    .....s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    .....q:'$IsObject(objDic)
    .....s OprLGuanInfoDesc=objDic.Description
    .....k objDic
    ....i OprCKongInfo'="" d
    .....s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(OprCKongInfo,"OprCKongInfo")
    .....s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    .....q:'$IsObject(objDic)
    .....s OprCKongInfoDesc=objDic.Description
    .....k objDic
    ....i OprSHUXInfo'="" d
    .....s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(OprSHUXInfo,"OprSHUXInfo")
    .....s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    .....q:'$IsObject(objDic)
    .....s OprSHUXInfoDesc=objDic.Description
    .....k objDic
    ....i OprSXInfo'="" d
    .....s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(OprSXInfo,"OprSXInfo")
    .....s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    .....q:'$IsObject(objDic)
    .....s OprSXInfoDesc=objDic.Description
    .....k objDic
    ....i OprInfNongY'="" d
    .....s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(OprInfNongY,"OprInfNongY")
    .....s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    .....q:'$IsObject(objDic)
    .....s OprInfNongYDesc=objDic.Description
    .....k objDic
    ....i OprZGInfo'="" d
    .....s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(OprZGInfo,"InfectionDiagnosePrognosis")
    .....s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    .....q:'$IsObject(objDic)
    .....s OprZGInfoDesc=objDic.Description
    .....k objDic
    ....i OprCDZBInfo'="" d
    .....s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(OprCDZBInfo,"OprCDZBInfo")
    .....s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    .....q:'$IsObject(objDic)
    .....s OprCDZBInfoDesc=objDic.Description
    .....k objDic
    ....i OprDoc'="" d
    .....s objUser=##class(DHCMed.Base.SSUser).GetObjById(OprDoc)
    .....q:'$IsObject(objUser)
    .....s OprDocDesc=objUser.Name
    .....k objUser
    ....i EmerOprFlag'="" d
    .....s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(EmerOprFlag,"OperationType")
    .....s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    .....q:'$IsObject(objDic)
    .....s EmerOprFlagDesc=objDic.Description
    .....k objDic
    ....i Anaesthesia'="" d
    .....s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(Anaesthesia,"InfectionNarcosisType")
    .....s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    .....q:'$IsObject(objDic)
    .....s AnaesthesiaDesc=objDic.Description
    .....k objDic
    ....i CuteType'="" d
    .....s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(CuteType,"InfectionOpeCutType")
    .....s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    .....q:'$IsObject(objDic)
    .....s CuteTypeDesc=objDic.Description
    .....k objDic
    ....i Concrescence'="" d
    .....s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(Concrescence,"InfectionWoundCicatrize")
    .....s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    .....q:'$IsObject(objDic)
    .....s ConcrescenceDesc=objDic.Description
    .....k objDic
    ....s:CuteInfFlag="1" CuteInfFlagDesc="Yes"
    ....s:CuteInfFlag="0" CuteInfFlagDesc="No"
    ....i OprCuteType'="" d
    .....s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(OprCuteType,"InfectionOperationCutType")
    .....s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    .....q:'$IsObject(objDic)
    .....s OprCuteTypeDesc=objDic.Description
    .....k objDic
    ....s:InfectionFlag="1" InfectionFlagDesc="Yes"
    ....s:InfectionFlag="0" InfectionFlagDesc="No"
    ...s $li(Data,5)=EmerOprFlag
    ...s $li(Data,6)=EmerOprFlagDesc
    ...s $li(Data,7)=DateFrom
    ...s $li(Data,8)=TimeFrom
    ...s $li(Data,9)=DateTo
    ...s $li(Data,10)=TimeTo
    ...s $li(Data,11)=OprDoc
    ...s $li(Data,12)=OprDocDesc
    ...s $li(Data,13)=Anaesthesia
    ...s $li(Data,14)=AnaesthesiaDesc
    ...s $li(Data,15)=CuteType
    ...s $li(Data,16)=CuteTypeDesc
    ...s $li(Data,17)=Concrescence
    ...s $li(Data,18)=ConcrescenceDesc
    ...s $li(Data,19)=CuteInfFlag
    ...s $li(Data,20)=CuteInfFlagDesc
    ...s $li(Data,21)=OprCuteType
    ...s $li(Data,22)=OprCuteTypeDesc
    ...s $li(Data,23)=InfectionFlag
    ...s $li(Data,24)=InfectionFlagDesc
    ...s $li(Data,25)=OperICD9Map
    ...s $li(Data,26)=ResumeText
    ...s $li(Data,27)=checked
    ...s $li(Data,28)=childSub    //checked
    ...s $li(Data,29)=OprCDZBInfo
    ...s $li(Data,30)=OprCDZBInfoDesc
    ...s $li(Data,31)=OprZGInfo
    ...s $li(Data,32)=OprZGInfoDesc
    ...s $li(Data,33)=OprZGDtInfo
    ...s $li(Data,34)=OprInfDate
    ...s $li(Data,35)=OprInfNongY
    ...s $li(Data,36)=OprInfNongYDesc
    ...s $li(Data,37)=OprDiasInfo
    ...s $li(Data,38)=OprSXInfo
    ...s $li(Data,39)=OprSXInfoDesc
    ...s $li(Data,40)=OprSHUXInfo
    ...s $li(Data,41)=OprSHUXInfoDesc
    ...s $li(Data,42)=OprCKongInfo
    ...s $li(Data,43)=OprCKongInfoDesc
    ...s $li(Data,44)=OprLGuanInfo
    ...s $li(Data,45)=OprLGuanInfoDesc
    ...s $li(Data,46)=OprWKYLInfo
    ...s $li(Data,47)=OprWKYLInfoDesc
    ...s $li(Data,48)=Text1
    ...s $li(Data,49)=OprSXLInfo
    ...s $li(Data,50)=OprSHUXLInfo
    ...s $li(Data,51)=OprSKQJD
    ...s $li(Data,52)=OprSKQJDDesc
    ...s $li(Data,53)=OprBWFL
    ...s $li(Data,54)=OprBWFLDesc
    ...s $li(Data,55)=OprDangerCls
    ...s $li(Data,56)=OprDangerClsDesc
    ...s $li(Data,57)=OprInfCtLoc
    ...s $li(Data,58)=OprInfCtLocDesc
    ...s ^CacheTemp(repid,ind)=Data
    ...s ind=ind+1
GetAZOperation
    q:'$d(^OEORD(0,"Adm",+Paadm))  
    q:'$d(^opeschi(0,"ADM",+Paadm))  
    s id=0
    f  s id=$o(^opeschi(0,"ADM",+Paadm,id)) q:id=""  d
    .q:'$d(^opesch(id))
    .s tmpOper=$g(^opesch(id))
    .q:tmpOper=""
    .s oeori=Paadm_"||"_id
    .s arcimDesc=$p(tmpOper,"^",21)
    .s OperStatus=$p(tmpOper,"^",28)
    .q:(OperStatus'["停止")&&(OperStatus'["完成")
    .s sttDate=+$p(tmpOper,"^",17)
    .s:sttDate'=0 sttDate=$zd(sttDate,3)
    .s:sttDate=0 sttDate=""
    .//s HospCode=$$GetHospitalCode^DHCMedBase02()
    .s Data=$lb("")
    .s $li(Data,1)=oeori           //
    .s $li(Data,2)=arcimDesc
    .s $li(Data,3)=sttDate
    .s $li(Data,4)=OperStatus
    .s EmerOprFlag="",EmerOprFlagDesc="",DateFrom="",TimeFrom="",DateTo="",TimeTo="",OprDoc="",OprDocDesc="",Anaesthesia="",AnaesthesiaDesc="",childSub="",checked=""
    .s (CuteType,CuteTypeDesc,Concrescence,ConcrescenceDesc,CuteInfFlag,CuteInfFlagDesc,OprCuteType,OprCuteTypeDesc,InfectionFlag,InfectionFlagDesc,OperICD9Map,ResumeText)=""
    .s (OprCDZBInfo,OprCDZBInfoDesc,OprZGInfo,OprZGInfoDesc,OprZGDtInfo,OprInfDate,OprInfNongY,OprInfNongYDesc,OprDiasInfo,OprSXInfo,OprSXInfoDesc,OprSHUXInfo,OprSHUXInfoDesc,OprCKongInfo,OprCKongInfoDesc)=""
    .s (OprLGuanInfo,OprLGuanInfoDesc,OprWKYLInfo,OprWKYLInfoDesc,Text1,OprSXLInfo,OprSHUXLInfo)=""
    .// ^DHCMed.INF.RepOPRI
    .s (OprSKQJD,OprSKQJDDesc,OprBWFL,OprBWFLDesc,OprDangerCls,OprDangerClsDesc,OprInfCtLoc,OprInfCtLocDesc)=""
    .s DateFrom=sttDate
    .s DateTo=+$p(tmpOper,"^",22)
    .s:DateTo'=0 DateTo=$zd(DateTo,3)
    .s:DateTo=0 DateTo=""
    .s TimeFrom=+$p(tmpOper,"^",18)
    .s:TimeFrom'=0 TimeFrom=$zt(TimeFrom,1)
    .s:TimeFrom=0 TimeFrom=""
    .s TimeTo=+$p(tmpOper,"^",23)
    .s:TimeTo'=0 TimeTo=$zt(TimeTo,2)
    .s:TimeTo=0 TimeTo=""
    .s OprDocDesc=$p(tmpOper,"^",12)
    .//^SSU("SSUSR",0,"SSUSR_Name",$$ALPHAUP({SSUSR_Name}),{SSUSR_RowId})
    .s OprDoc=0
    .f  s OprDoc=$o(^SSU("SSUSR",0,"SSUSR_Name",OprDocDesc,OprDoc)) q:(+OprDoc=0)&(OprDocDesc'="")  d
    ..s objUser=##class(DHCMed.Base.SSUser).GetObjById(OprDoc)
    ..q:'$IsObject(objUser)
    ..s OprDocDesc=objUser.Name
    .s AnaesthesiaDesc=$p(tmpOper,"^",34)
    .s:AnaesthesiaDesc["全麻" Anaesthesia=1
    .s:AnaesthesiaDesc'["全麻" Anaesthesia=2
    .i repDr'="" d   ///已经保存过的数据
    ..q:oeori=""
    ..s oeoriIdx=" "_$ZCVT(oeori,"U")
    ..q:'$d(^DHCMed.INF.RepOPRI("InfRepOeoriIdx",repDr,oeoriIdx))
    ..s childSub=$o(^DHCMed.INF.RepOPRI("InfRepOeoriIdx",repDr,oeoriIdx,0))
    ..q:childSub=""
    ..s objRepOPR=##class(DHCMed.INF.RepOPR).GetObjById(childSub)
    ..q:'$IsObject(objRepOPR)
    ..s checked=1
    ..s EmerOprFlag=objRepOPR.EmerOprFlag
    ..s:EmerOprFlag["Y" EmerOprFlagDesc="Yes"
    ..s:EmerOprFlag["N" EmerOprFlagDesc="No"
    ..s DateFrom=objRepOPR.DateFrom
    ..s TimeFrom=objRepOPR.TimeFrom
    ..s DateTo=objRepOPR.DateTo
    ..s TimeTo=objRepOPR.TimeTo
    ..s OprDoc=objRepOPR.OprDoc
    ..s Anaesthesia=objRepOPR.Anaesthesia
    ..s CuteType=objRepOPR.CuteType
    ..s Concrescence=objRepOPR.Concrescence
    ..s CuteInfFlag=objRepOPR.CuteInfFlag
    ..s OprCuteType=objRepOPR.OprCuteType
    ..s InfectionFlag=objRepOPR.InfectionFlag
    ..//s OperICD9Map=objRepOPR.OEORIDr
    ..s OperICD9Map=objRepOPR.OperICD9Map
    ..s ResumeText=objRepOPR.ResumeText          ////////end
    ..s OprCDZBInfo=objRepOPR.OprCDZBInfo
    ..s OprZGInfo=objRepOPR.OprZGInfo
    ..s OprZGDtInfo=objRepOPR.OprZGDtInfo
    ..s OprInfDate=objRepOPR.OprInfDate
    ..s OprInfNongY=objRepOPR.OprInfNongY
    ..s OprDiasInfo=objRepOPR.OprDiasInfo
    ..s OprSXInfo=objRepOPR.OprSXInfo
    ..s OprSHUXInfo=objRepOPR.OprSHUXInfo
    ..s OprCKongInfo=objRepOPR.OprCKongInfo
    ..s OprLGuanInfo=objRepOPR.OprLGuanInfo
    ..s OprWKYLInfo=objRepOPR.OprWKYLInfo
    ..s Text1=objRepOPR.Text1
    ..s OprSXLInfo=objRepOPR.OprSXLInfo
    ..s OprSHUXLInfo=objRepOPR.OprSHUXLInfo
    ..s OprSKQJD=objRepOPR.OprSKQJD
    ..s OprBWFL=objRepOPR.OprBWFL
    ..s OprDangerCls=objRepOPR.OprDangerCls
    ..s OprInfCtLoc=objRepOPR.OprInfCtLoc
    ../// add hx
    ..s:+DateFrom'=0 DateFrom=$zd(DateFrom,3)
    ..s:+TimeFrom'=0 TimeFrom=$zt(TimeFrom,1)
    ..s:+DateTo'=0 DateTo=$zd(DateTo,3)
    ..s:+TimeTo'=0 TimeTo=$zt(TimeTo,1)
    ..s:+OprZGDtInfo'=0 OprZGDtInfo=$zd(OprZGDtInfo,3)
    ..s:+OprInfDate'=0 OprInfDate=$zd(OprInfDate,3)
    ..i OprInfCtLoc'="" d
    ...s objTmp=##class(DHCMed.Base.Ctloc).GetObjById(OprInfCtLoc)
    ...q:'$IsObject(objTmp)
    ...s OprInfCtLocDesc=objTmp.Descs
    ..i OprDangerCls'="" d
    ...s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(OprDangerCls,"OprDangerCls")
    ...s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    ...q:'$IsObject(objDic)
    ...s OprDangerClsDesc=objDic.Description
    ...k objDic
    ..i OprBWFL'="" d
    ...s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(OprBWFL,"OprBWFL")
    ...s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    ...q:'$IsObject(objDic)
    ...s OprBWFLDesc=objDic.Description
    ...k objDic
    ..i OprSKQJD'="" d
    ...s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(OprSKQJD,"InfectionCutType")
    ...s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    ...q:'$IsObject(objDic)
    ...s OprSKQJDDesc=objDic.Description
    ...k objDic
    ..i OprWKYLInfo'="" d
    ...s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(OprWKYLInfo,"OprWKYLInfo")
    ...s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    ...q:'$IsObject(objDic)
    ...s OprWKYLInfoDesc=objDic.Description
    ...k objDic
    ..i OprLGuanInfo'="" d
    ...s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(OprLGuanInfo,"OprLGuanInfo")
    ...s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    ...q:'$IsObject(objDic)
    ...s OprLGuanInfoDesc=objDic.Description
    ...k objDic
    ..i OprCKongInfo'="" d
    ...s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(OprCKongInfo,"OprCKongInfo")
    ...s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    ...q:'$IsObject(objDic)
    ...s OprCKongInfoDesc=objDic.Description
    ...k objDic
    ..i OprSHUXInfo'="" d
    ...s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(OprSHUXInfo,"OprSHUXInfo")
    ...s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    ...q:'$IsObject(objDic)
    ...s OprSHUXInfoDesc=objDic.Description
    ...k objDic
    ..i OprSXInfo'="" d
    ...s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(OprSXInfo,"OprSXInfo")
    ...s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    ...q:'$IsObject(objDic)
    ...s OprSXInfoDesc=objDic.Description
    ...k objDic
    ..i OprInfNongY'="" d
    ...s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(OprInfNongY,"OprInfNongY")
    ...s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    ...q:'$IsObject(objDic)
    ...s OprInfNongYDesc=objDic.Description
    ...k objDic
    ..i OprZGInfo'="" d
    ...s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(OprZGInfo,"InfectionDiagnosePrognosis")
    ...s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    ...q:'$IsObject(objDic)
    ...s OprZGInfoDesc=objDic.Description
    ...k objDic
    ..i OprCDZBInfo'="" d
    ...s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(OprCDZBInfo,"OprCDZBInfo")
    ...s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    ...q:'$IsObject(objDic)
    ...s OprCDZBInfoDesc=objDic.Description
    ...k objDic
    ..i OprDoc'="" d
    ...s objUser=##class(DHCMed.Base.SSUser).GetObjById(OprDoc)
    ...q:'$IsObject(objUser)
    ...s OprDocDesc=objUser.Name
    ...k objUser
    ..i EmerOprFlag'="" d
    ...s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(EmerOprFlag,"OperationType")
    ...s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    ...q:'$IsObject(objDic)
    ...s EmerOprFlagDesc=objDic.Description
    ...k objDic
    ..i Anaesthesia'="" d
    ...s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(Anaesthesia,"InfectionNarcosisType")
    ...s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    ...q:'$IsObject(objDic)
    ...s AnaesthesiaDesc=objDic.Description
    ...k objDic
    ..i CuteType'="" d
    ...s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(CuteType,"InfectionOpeCutType")
    ...s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    ...q:'$IsObject(objDic)
    ...s CuteTypeDesc=objDic.Description
    ...k objDic
    ..i Concrescence'="" d
    ...s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(Concrescence,"InfectionWoundCicatrize")
    ...s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    ...q:'$IsObject(objDic)
    ...s ConcrescenceDesc=objDic.Description
    ...k objDic
    ..s:CuteInfFlag="1" CuteInfFlagDesc="Yes"
    ..s:CuteInfFlag="0" CuteInfFlagDesc="No"
    ..i OprCuteType'="" d
    ...s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(OprCuteType,"InfectionOperationCutType")
    ...s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    ...q:'$IsObject(objDic)
    ...s OprCuteTypeDesc=objDic.Description
    ...k objDic
    ..s:InfectionFlag="1" InfectionFlagDesc="Yes"
    ..s:InfectionFlag="0" InfectionFlagDesc="No"
    .s $li(Data,5)=EmerOprFlag
    .s $li(Data,6)=EmerOprFlagDesc
    .s $li(Data,7)=DateFrom
    .s $li(Data,8)=TimeFrom
    .s $li(Data,9)=DateTo
    .s $li(Data,10)=TimeTo
    .s $li(Data,11)=OprDoc
    .s $li(Data,12)=OprDocDesc
    .s $li(Data,13)=Anaesthesia
    .s $li(Data,14)=AnaesthesiaDesc
    .s $li(Data,15)=CuteType
    .s $li(Data,16)=CuteTypeDesc
    .s $li(Data,17)=Concrescence
    .s $li(Data,18)=ConcrescenceDesc
    .s $li(Data,19)=CuteInfFlag
    .s $li(Data,20)=CuteInfFlagDesc
    .s $li(Data,21)=OprCuteType
    .s $li(Data,22)=OprCuteTypeDesc
    .s $li(Data,23)=InfectionFlag
    .s $li(Data,24)=InfectionFlagDesc
    .s $li(Data,25)=OperICD9Map
    .s $li(Data,26)=ResumeText
    .s $li(Data,27)=checked
    .s $li(Data,28)=childSub    //checked
    .s $li(Data,29)=OprCDZBInfo
    .s $li(Data,30)=OprCDZBInfoDesc
    .s $li(Data,31)=OprZGInfo
    .s $li(Data,32)=OprZGInfoDesc
    .s $li(Data,33)=OprZGDtInfo
    .s $li(Data,34)=OprInfDate
    .s $li(Data,35)=OprInfNongY
    .s $li(Data,36)=OprInfNongYDesc
    .s $li(Data,37)=OprDiasInfo
    .s $li(Data,38)=OprSXInfo
    .s $li(Data,39)=OprSXInfoDesc
    .s $li(Data,40)=OprSHUXInfo
    .s $li(Data,41)=OprSHUXInfoDesc
    .s $li(Data,42)=OprCKongInfo
    .s $li(Data,43)=OprCKongInfoDesc
    .s $li(Data,44)=OprLGuanInfo
    .s $li(Data,45)=OprLGuanInfoDesc
    .s $li(Data,46)=OprWKYLInfo
    .s $li(Data,47)=OprWKYLInfoDesc
    .s $li(Data,48)=Text1
    .s $li(Data,49)=OprSXLInfo
    .s $li(Data,50)=OprSHUXLInfo
    .s $li(Data,51)=OprSKQJD
    .s $li(Data,52)=OprSKQJDDesc
    .s $li(Data,53)=OprBWFL
    .s $li(Data,54)=OprBWFLDesc
    .s $li(Data,55)=OprDangerCls
    .s $li(Data,56)=OprDangerClsDesc
    .s $li(Data,57)=OprInfCtLoc
    .s $li(Data,58)=OprInfCtLocDesc
    .s ^CacheTemp(repid,ind)=Data
    .s ind=ind+1
GetSysOper
   //^DHCANOPArrange是DHC_AN_OPArrange手术排班表
   //^DHCANOPArrange(0,"Adm",{OPA_Adm_dr},{OPA_RowId})
   //麻醉表OR_Anaesthesia
   //^OR({PA_Adm.PAADM_RowID},"ANA",{ANA_Childsub})  
   //手术表OR_Anaest_Operation
   //^OR({PA_Adm.PAADM_RowID},"ANA",{Childsub},"OP",{ANAOP_Childsub})
    q:'$d(^OEORD(0,"Adm",+Paadm))  
    q:'$d(^DHCANOPArrange(0,"Adm",Paadm))
    s oparr=0
    f  s oparr=$o(^DHCANOPArrange(0,"Adm",Paadm,oparr)) q:oparr=""  d
    .s anaRowid=$p($g(^DHCANOPArrange(oparr)),"^",2)  ;OPA_Anaest_dr
    .s anaChild=$p(anaRowid,"||",2)
    .s opChild=0
    .f  s opChild=$o(^OR(Paadm,"ANA",anaChild,"OP",opChild)) q:opChild=""  d
    ..s oeori=Paadm_"||"_anaChild_"||"_opChild
    ..s s=$g(^OR(Paadm,"ANA",anaChild,"OP",opChild))
    ..s OPTypeDR=$p(s,"^",6)            ;->ORC_Operation
    ..s arcimDesc=$p($g(^ORC("OPER",OPTypeDR)),"^",2)
    ..s OPICD9Map=$p($g(^ORC("OPER",OPTypeDR)),"^",21)
    ..s sArr=$g(^DHCANOPArrange(oparr))
    ..s OperStatus=$p(sArr,"^",27)
    ..//Apply,Decline,Receive,InRoom,Operate,LeaveRoom,Finish,NotApp
    ..q:(OperStatus="NotApp")
    ..s sttDate=+$p(sArr,"^",14)
    ..s:sttDate'=0 sttDate=$zd(sttDate,3)
    ..s:sttDate=0 sttDate=""
    ..//s HospCode=$$GetHospitalCode^DHCMedBase02()
    ..s Data=$lb("")
    ..s $li(Data,1)=oeori           //
    ..s $li(Data,2)=arcimDesc
    ..s $li(Data,3)=sttDate
    ..s $li(Data,4)=OperStatus
    ..s EmerOprFlag="",EmerOprFlagDesc="",DateFrom="",TimeFrom="",DateTo="",TimeTo="",OprDoc="",OprDocDesc="",Anaesthesia="",AnaesthesiaDesc="",childSub="",checked=""
    ..s (CuteType,CuteTypeDesc,Concrescence,ConcrescenceDesc,CuteInfFlag,CuteInfFlagDesc,OprCuteType,OprCuteTypeDesc,InfectionFlag,InfectionFlagDesc,OperICD9Map,ResumeText)=""
    ..s (OprCDZBInfo,OprCDZBInfoDesc,OprZGInfo,OprZGInfoDesc,OprZGDtInfo,OprInfDate,OprInfNongY,OprInfNongYDesc,OprDiasInfo,OprSXInfo,OprSXInfoDesc,OprSHUXInfo,OprSHUXInfoDesc,OprCKongInfo,OprCKongInfoDesc)=""
    ..s (OprLGuanInfo,OprLGuanInfoDesc,OprWKYLInfo,OprWKYLInfoDesc,Text1,OprSXLInfo,OprSHUXLInfo)=""
    ..// ^DHCMed.INF.RepOPRI
    ..s (OprSKQJD,OprSKQJDDesc,OprBWFL,OprBWFLDesc,OprDangerCls,OprDangerClsDesc,OprInfCtLoc,OprInfCtLocDesc)=""
    ..s DateFrom=sttDate
    ..s DateTo=+$p(sArr,"^",16)
    ..s:DateTo'=0 DateTo=$zd(DateTo,3)
    ..s:DateTo=0 DateTo=""
    ..s TimeFrom=+$p(sArr,"^",15)
    ..s:TimeFrom'=0 TimeFrom=$zt(TimeFrom,1)
    ..s:TimeFrom=0 TimeFrom=""
    ..s TimeTo=+$p(sArr,"^",17)
    ..s:TimeTo'=0 TimeTo=$zt(TimeTo,2)
    ..s:TimeTo=0 TimeTo=""
    ..s OprDoc=$p(s,"^",8)
    ..s OprDoc=$o(^SSU("SSUSR",0,"CTPCP",OprDoc,""),-1)
    ..s objUser=##class(DHCMed.Base.SSUser).GetObjById(OprDoc)
    ..i $IsObject(objUser) d
    ...s OprDocDesc=objUser.Name
    ..e  d
    ...s OprDoc=""
    ..//一助
    ..//二助
    ..s assList=""
    ..s ass=0
    ..f  s ass=$o(^OR(Paadm,"ANA",anaChild,"OP",opChild,"ASS",ass)) q:ass=""  d
    ...s assDr=$g(^OR(Paadm,"ANA",anaChild,"OP",opChild,"ASS",ass))
    ...s objUser=##class(DHCMed.Base.SSUser).GetObjById(assDr)
    ...q:'$IsObject(objUser)
    ...s assDoctor=objUser.Name
    ...s:assDoctor'="" assList=assList_assDoctor_$c(3)
    ..s AnaesthesiaStr=$g(^OR(Paadm,"ANA",anaChild))
    ..s anDoctor=""  //麻醉医生
    ..s anDocDr=$p(AnaesthesiaStr,"^",7)
    ..s objUser=##class(DHCMed.Base.SSUser).GetObjById(anDocDr)
    ..s:$IsObject(objUser) anDoctor=objUser.Name
    ..s Anaesthesia=$p(AnaesthesiaStr,"^",5)
    ..s:Anaesthesia'="" AnaesthesiaDesc=$p(^ORC("ANMET",+Anaesthesia),"^",2)
    ..i AnaesthesiaDesc'="" d
    ...s Anaesthesia=##Class(DHCMed.SSService.DictionarySrv).GetIDByDesc("","InfectionNarcosisType",AnaesthesiaDesc)
    ..e  d
    ...s Anaesthesia=""
    ..i repDr'="" d   ///已经保存过的数据
    ...q:oeori=""
    ...s oeoriIdx=" "_$ZCVT(oeori,"U")
    ...q:'$d(^DHCMed.INF.RepOPRI("InfRepOeoriIdx",repDr,oeoriIdx))
    ...s childSub=$o(^DHCMed.INF.RepOPRI("InfRepOeoriIdx",repDr,oeoriIdx,0))
    ...q:childSub=""
    ...s objRepOPR=##class(DHCMed.INF.RepOPR).GetObjById(childSub)
    ...q:'$IsObject(objRepOPR)
    ...s checked=1
    ...s EmerOprFlag=objRepOPR.EmerOprFlag
    ...s:EmerOprFlag["Y" EmerOprFlagDesc="Yes"
    ...s:EmerOprFlag["N" EmerOprFlagDesc="No"
    ...s DateFrom=objRepOPR.DateFrom
    ...s TimeFrom=objRepOPR.TimeFrom
    ...s DateTo=objRepOPR.DateTo
    ...s TimeTo=objRepOPR.TimeTo
    ...s OprDoc=objRepOPR.OprDoc
    ...s Anaesthesia=objRepOPR.Anaesthesia
    ...s CuteType=objRepOPR.CuteType
    ...s Concrescence=objRepOPR.Concrescence
    ...s CuteInfFlag=objRepOPR.CuteInfFlag
    ...s OprCuteType=objRepOPR.OprCuteType
    ...s InfectionFlag=objRepOPR.InfectionFlag
    ...//s OperICD9Map=objRepOPR.OEORIDr
    ...s OperICD9Map=objRepOPR.OperICD9Map
    ...s ResumeText=objRepOPR.ResumeText          ////////end
    ...s OprCDZBInfo=objRepOPR.OprCDZBInfo
    ...s OprZGInfo=objRepOPR.OprZGInfo
    ...s OprZGDtInfo=objRepOPR.OprZGDtInfo
    ...s OprInfDate=objRepOPR.OprInfDate
    ...s OprInfNongY=objRepOPR.OprInfNongY
    ...s OprDiasInfo=objRepOPR.OprDiasInfo
    ...s OprSXInfo=objRepOPR.OprSXInfo
    ...s OprSHUXInfo=objRepOPR.OprSHUXInfo
    ...s OprCKongInfo=objRepOPR.OprCKongInfo
    ...s OprLGuanInfo=objRepOPR.OprLGuanInfo
    ...s OprWKYLInfo=objRepOPR.OprWKYLInfo
    ...s Text1=objRepOPR.Text1
    ...s OprSXLInfo=objRepOPR.OprSXLInfo
    ...s OprSHUXLInfo=objRepOPR.OprSHUXLInfo
    ...s OprSKQJD=objRepOPR.OprSKQJD
    ...s OprBWFL=objRepOPR.OprBWFL
    ...s OprDangerCls=objRepOPR.OprDangerCls
    ...s OprInfCtLoc=objRepOPR.OprInfCtLoc
    .../// add hx
    ...s:+DateFrom'=0 DateFrom=$zd(DateFrom,3)
    ...s:+TimeFrom'=0 TimeFrom=$zt(TimeFrom,1)
    ...s:+DateTo'=0 DateTo=$zd(DateTo,3)
    ...s:+TimeTo'=0 TimeTo=$zt(TimeTo,1)
    ...s:+OprZGDtInfo'=0 OprZGDtInfo=$zd(OprZGDtInfo,3)
    ...s:+OprInfDate'=0 OprInfDate=$zd(OprInfDate,3)
    ...i OprInfCtLoc'="" d
    ....s objTmp=##class(DHCMed.Base.Ctloc).GetObjById(OprInfCtLoc)
    ....q:'$IsObject(objTmp)
    ....s OprInfCtLocDesc=objTmp.Descs
    ...i OprDangerCls'="" d
    ....s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(OprDangerCls,"OprDangerCls")
    ....s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    ....q:'$IsObject(objDic)
    ....s OprDangerClsDesc=objDic.Description
    ....k objDic
    ...i OprBWFL'="" d
    ....s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(OprBWFL,"OprBWFL")
    ....s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    ....q:'$IsObject(objDic)
    ....s OprBWFLDesc=objDic.Description
    ....k objDic
    ...i OprSKQJD'="" d
    ....s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(OprSKQJD,"InfectionCutType")
    ....s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    ....q:'$IsObject(objDic)
    ....s OprSKQJDDesc=objDic.Description
    ....k objDic
    ...i OprWKYLInfo'="" d
    ....s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(OprWKYLInfo,"OprWKYLInfo")
    ....s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    ....q:'$IsObject(objDic)
    ....s OprWKYLInfoDesc=objDic.Description
    ....k objDic
    ...i OprLGuanInfo'="" d
    ....s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(OprLGuanInfo,"OprLGuanInfo")
    ....s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    ....q:'$IsObject(objDic)
    ....s OprLGuanInfoDesc=objDic.Description
    ....k objDic
    ...i OprCKongInfo'="" d
    ....s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(OprCKongInfo,"OprCKongInfo")
    ....s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    ....q:'$IsObject(objDic)
    ....s OprCKongInfoDesc=objDic.Description
    ....k objDic
    ...i OprSHUXInfo'="" d
    ....s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(OprSHUXInfo,"OprSHUXInfo")
    ....s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    ....q:'$IsObject(objDic)
    ....s OprSHUXInfoDesc=objDic.Description
    ....k objDic
    ...i OprSXInfo'="" d
    ....s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(OprSXInfo,"OprSXInfo")
    ....s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    ....q:'$IsObject(objDic)
    ....s OprSXInfoDesc=objDic.Description
    ....k objDic
    ...i OprInfNongY'="" d
    ....s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(OprInfNongY,"OprInfNongY")
    ....s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    ....q:'$IsObject(objDic)
    ....s OprInfNongYDesc=objDic.Description
    ....k objDic
    ...i OprZGInfo'="" d
    ....s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(OprZGInfo,"InfectionDiagnosePrognosis")
    ....s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    ....q:'$IsObject(objDic)
    ....s OprZGInfoDesc=objDic.Description
    ....k objDic
    ...i OprCDZBInfo'="" d
    ....s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(OprCDZBInfo,"OprCDZBInfo")
    ....s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    ....q:'$IsObject(objDic)
    ....s OprCDZBInfoDesc=objDic.Description
    ....k objDic
    ...i OprDoc'="" d
    ....s objUser=##class(DHCMed.Base.SSUser).GetObjById(OprDoc)
    ....q:'$IsObject(objUser)
    ....s OprDocDesc=objUser.Name
    ....k objUser
    ...i EmerOprFlag'="" d
    ....s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(EmerOprFlag,"OperationType")
    ....s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    ....q:'$IsObject(objDic)
    ....s EmerOprFlagDesc=objDic.Description
    ....k objDic
    ...i Anaesthesia'="" d
    ....s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(Anaesthesia,"InfectionNarcosisType")
    ....s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    ....q:'$IsObject(objDic)
    ....s AnaesthesiaDesc=objDic.Description
    ....k objDic
    ...i CuteType'="" d
    ....s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(CuteType,"InfectionOpeCutType")
    ....s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    ....q:'$IsObject(objDic)
    ....s CuteTypeDesc=objDic.Description
    ....k objDic
    ...i Concrescence'="" d
    ....s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(Concrescence,"InfectionWoundCicatrize")
    ....s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    ....q:'$IsObject(objDic)
    ....s ConcrescenceDesc=objDic.Description
    ....k objDic
    ...s:CuteInfFlag="1" CuteInfFlagDesc="Yes"
    ...s:CuteInfFlag="0" CuteInfFlagDesc="No"
    ...i OprCuteType'="" d
    ....s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(OprCuteType,"InfectionOperationCutType")
    ....s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    ....q:'$IsObject(objDic)
    ....s OprCuteTypeDesc=objDic.Description
    ....k objDic
    ...s:InfectionFlag="1" InfectionFlagDesc="Yes"
    ...s:InfectionFlag="0" InfectionFlagDesc="No"
    ..s $li(Data,5)=EmerOprFlag
    ..s $li(Data,6)=EmerOprFlagDesc
    ..s $li(Data,7)=DateFrom
    ..s $li(Data,8)=TimeFrom
    ..s $li(Data,9)=DateTo
    ..s $li(Data,10)=TimeTo
    ..s $li(Data,11)=OprDoc
    ..s $li(Data,12)=OprDocDesc
    ..s $li(Data,13)=Anaesthesia
    ..s $li(Data,14)=AnaesthesiaDesc
    ..s $li(Data,15)=CuteType
    ..s $li(Data,16)=CuteTypeDesc
    ..s $li(Data,17)=Concrescence
    ..s $li(Data,18)=ConcrescenceDesc
    ..s $li(Data,19)=CuteInfFlag
    ..s $li(Data,20)=CuteInfFlagDesc
    ..s $li(Data,21)=OprCuteType
    ..s $li(Data,22)=OprCuteTypeDesc
    ..s $li(Data,23)=InfectionFlag
    ..s $li(Data,24)=InfectionFlagDesc
    ..s $li(Data,25)=OperICD9Map
    ..s $li(Data,26)=ResumeText
    ..s $li(Data,27)=checked
    ..s $li(Data,28)=childSub    //checked
    ..s $li(Data,29)=OprCDZBInfo
    ..s $li(Data,30)=OprCDZBInfoDesc
    ..s $li(Data,31)=OprZGInfo
    ..s $li(Data,32)=OprZGInfoDesc
    ..s $li(Data,33)=OprZGDtInfo
    ..s $li(Data,34)=OprInfDate
    ..s $li(Data,35)=OprInfNongY
    ..s $li(Data,36)=OprInfNongYDesc
    ..s $li(Data,37)=OprDiasInfo
    ..s $li(Data,38)=OprSXInfo
    ..s $li(Data,39)=OprSXInfoDesc
    ..s $li(Data,40)=OprSHUXInfo
    ..s $li(Data,41)=OprSHUXInfoDesc
    ..s $li(Data,42)=OprCKongInfo
    ..s $li(Data,43)=OprCKongInfoDesc
    ..s $li(Data,44)=OprLGuanInfo
    ..s $li(Data,45)=OprLGuanInfoDesc
    ..s $li(Data,46)=OprWKYLInfo
    ..s $li(Data,47)=OprWKYLInfoDesc
    ..s $li(Data,48)=Text1
    ..s $li(Data,49)=OprSXLInfo
    ..s $li(Data,50)=OprSHUXLInfo
    ..s $li(Data,51)=OprSKQJD
    ..s $li(Data,52)=OprSKQJDDesc
    ..s $li(Data,53)=OprBWFL
    ..s $li(Data,54)=OprBWFLDesc
    ..s $li(Data,55)=OprDangerCls
    ..s $li(Data,56)=OprDangerClsDesc
    ..s $li(Data,57)=OprInfCtLoc
    ..s $li(Data,58)=OprInfCtLocDesc
    ..s ^CacheTemp(repid,ind)=Data
    ..s ind=ind+1
GetEPROperation
    q
GetOPERField(paadm,tmpEleExp,MrOperVer)
    n (paadm,tmpEleExp,MrOperVer)
    s tmpField=""
    q:tmpEleExp="" tmpField
    s FieldLen=$l(tmpEleExp,$c(3))     ;一个字段多数据，如：助手列表
    f iField=1:1:FieldLen d
    .s MyField=$p(tmpEleExp,$c(3),iField)
    .s EleCode=$p(MyField,"/",1)
    .s eleTmpString=""
    .f EleIndex=2:1:$l(MyField,"/") d   ;一个字段多值，如：术者
    ..s IsCode=$p(MyField,"/",EleIndex)
    ..s tmpCode=##class(DHCMed.Base.EPR).GetEPRElement(MrOperVer,paadm,EleCode,IsCode)
    ..;s tmpCode=$p($p(EleCode,"#",1),".",2)_"-"_paadm_"-"_IsCode
    ..;s eleTmpString=eleTmpString_tmpCode_$s(eleTmpString="":"",1:"/")
    ..s $p(eleTmpString,"/",EleIndex-1)=tmpCode
    .q:eleTmpString=""
    .q:eleTmpString="/"
    .;s tmpField=tmpField_eleTmpString_$c(3)
    .s $p(tmpField,$c(3),iField)=eleTmpString
    q tmpField
}

ClassMethod QryOperationByPaadmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOperationByPaadmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryOperationByPaadmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOperationByPaadmExecute ]
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

/// Creator：     ChenJB
/// CreatDate：   2010-05-19
/// Description:  查询病人辅助检查的信息
/// Table：       DHCMed.Base.OrdItem
/// Input：       Paadm ： 就诊
/// output:       符合条件的项            
/// Return：      
/// D ##class(%ResultSet).RunQuery("DHCMed.INFService.InfBaseAricmSrv","QryLabTestByPaadm","1544737","1","")
Query QryLabTestByPaadm(Paadm As %String = "", TypeCode As %String = "", InfRepDr As %String = "") As %Query(ROWSPEC = "Rowid:%String,ArcimName:%String,sttDate:%String,OrdStsDesc:%String,LabTestNo:%String,OtherPara:%String,InfPosDR:%String,InfPosDesc:%String,PathDate:%String,Sample:%String,SampleDesc:%String,Method:%String,MethodDesc:%String,DrugFlag:%String,DrugFlagDesc:%String,ResumeText:%String,checked:%String,childSub:%String,RecLocDr:%String,arrayMic:%String")
{
}

ClassMethod QryLabTestByPaadmExecute(ByRef qHandle As %Binary, Paadm As %String = "", TypeCode As %String = "", InfRepDr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	s ind=1
 	q:Paadm="" $$$OK
 	q:TypeCode="" $$$OK
 	//s repDr=##class(DHCMed.INFService.InfReportSrv).GetReportID(+Paadm,TypeCode)
 	s repDr=InfRepDr
 	s TypeNameDesc=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("GetLabResultType","")
 	d GetOrdsLab
 	k objOeord
	Quit $$$OK
GetOrdsLab
    q:'$d(^OEORD(0,"Adm",+Paadm))     
    s oeord=$o(^OEORD(0,"Adm",+Paadm,""))
    //s HospCode=$$GetHospitalCode^DHCMedBase02()
    s objOeord=##class(DHCMed.Base.OeOrder).GetObjById(oeord)
    q:'$IsObject(objOeord)
    s arcim=""
    f  s arcim=$o(^OEORDi(0,"ARCIM",+oeord,arcim)) q:arcim=""  d
    .s objCls=##class(DHCMed.Base.Arcim).GetObjById(arcim)
    .q:'$IsObject(objCls)
    .s Type=objCls.ARCICOrderType
    .q:Type'="L"
    .;q:(TypeNameDesc'="")&(TypeNameDesc'[objCls.ARCICDesc)
    .//q:(HospCode="ShangHai_HSDY")&&(objCls.ARCICDesc'["普通手术")  // objCls.ARCICDesc
    .s ordDate="" f  s ordDate=$o(^OEORDi(0,"ARCIM",+oeord,arcim,ordDate)) q:ordDate=""  d
    ..s oeoriSub=0 f  s oeoriSub=$o(^OEORDi(0,"ARCIM",+oeord,arcim,ordDate,oeoriSub)) q:oeoriSub=""  d
    ...s oeori=oeord_"||"_oeoriSub
    ...s objOeorICls=##class(DHCMed.Base.OrdItem).GetObjById(oeori)
    ...q:'$IsObject(objOeorICls)
    ...// OEORIItemStatDR
    ...s OrderStatusDesc=objOeorICls.OSTATDesc
    ...s OrderStatusCode=objOeorICls.OSTATCode
    ...q:(OrderStatusCode="D")!(OrderStatusCode="S")
    ...s arcimDesc=objCls.ARCIMDesc
    ...s sttDate=+objOeorICls.OEORISttDat
    ...s LabTestNo=objOeorICls.OEORILabEpisodeNo
    ...s RecLocDr=objOeorICls.OEORIRecDepDR
    ...s Data=$lb("")
    ...s $li(Data,1)=oeori           //
    ...s $li(Data,2)=arcimDesc
    ...s $li(Data,3)=$zd(+sttDate,3)
    ...s $li(Data,4)=OrderStatusDesc
    ...s $li(Data,5)=LabTestNo
    ...s OtherPara="",InfPosDR="",InfPosDesc="",PathDate="",Sample="",SampleDesc="",Method="",MethodDesc="",DrugFlag="",DrugFlagDesc="",childSub="",checked=""
    ...s arrayMic=""   
    ...s (ResumeText)=""
    ...s arrayMic=..GetGermAntiArryStrByLab(LabTestNo)  //取检验组 的检验药敏
    ...//q:arrayMic=""   //如果检验无结果的推出 即不显示
    ...// ^DHCMed.INF.RepOPRI
    ...s PathDate=$zd(+sttDate,3)
    ...i repDr'="" d   ///已经保存过的数据
    ....q:oeori=""
    ....s oeoriIdx=" "_$ZCVT(oeori,"U")
    ....q:'$d(^DHCMed.INF.PathogenyI("InfRepInfOeordIdx",repDr,oeoriIdx))
    ....s childSub=$o(^DHCMed.INF.PathogenyI("InfRepInfOeordIdx",repDr,oeoriIdx,0))
    ....q:childSub=""
    ....s objRepPAT=##class(DHCMed.INF.Pathogeny).GetObjById(childSub)
    ....q:'$IsObject(objRepPAT)
    ....s checked=1
    ....s InfPosDR=objRepPAT.InfPosDR
    ....s Sample=objRepPAT.Sample
    ....s PathDate=objRepPAT.PathDate
    ....s Method=objRepPAT.Method
    ....s DrugFlag=objRepPAT.DrugFlag
    ....s ResumeText=objRepPAT.ResumeText
    ....s arrayMic=..GetGermAntiArryStr(childSub)  //取保存数据 的检验药敏
    ....s:+PathDate'=0 PathDate=$zd(PathDate,3)
    ....i InfPosDR'="" d
    .....s objPos=##class(DHCMed.INF.InfPosition).GetObjById(InfPosDR)
    .....q:'$IsObject(objPos)
    .....s InfPosDesc=objPos.InfPosition
    .....k objPos
    ....i Sample'="" d
    .....s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(Sample,"InfectionLabSampleType")
    .....s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    .....q:'$IsObject(objDic)
    .....s SampleDesc=objDic.Description
    .....k objDic
    ....i Method'="" d
    .....s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(Method,"InfectionPathogenyCheckMethod")
    .....s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    .....q:'$IsObject(objDic)
    .....s MethodDesc=objDic.Description
    .....k objDic
    ....i DrugFlag'="" d
    .....s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(DrugFlag,"InfectionLabSensitive")
    .....s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    .....q:'$IsObject(objDic)
    .....s DrugFlagDesc=objDic.Description
    .....k objDic
    ...s $li(Data,6)=OtherPara      //其他参数
    ...s $li(Data,7)=InfPosDR
    ...s $li(Data,8)=InfPosDesc
    ...s $li(Data,9)=PathDate
    ...s $li(Data,10)=Sample
    ...s $li(Data,11)=SampleDesc
    ...s $li(Data,12)=Method
    ...s $li(Data,13)=MethodDesc
    ...s $li(Data,14)=DrugFlag
    ...s $li(Data,15)=DrugFlagDesc
    ...s $li(Data,16)=ResumeText
    ...s $li(Data,17)=checked
    ...s $li(Data,18)=childSub    //checked
    ...s $li(Data,19)=RecLocDr           //病原体抗生素Rec
    ...s $li(Data,20)=arrayMic
    ...s ^CacheTemp(repid,ind)=Data
    ...s ind=ind+1
    ...k objOeorICls
    .k objCls
    q
}

ClassMethod QryLabTestByPaadmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLabTestByPaadmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryLabTestByPaadmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLabTestByPaadmExecute ]
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

/// Creator：     ChenJB
/// CreatDate：   2010-05-19
/// Description:  查询微生物检查结果病原体、抗菌药物信息
/// Table：       接口
/// Input：       检验项目ID ： LabTestNo
/// output:       符合条件的项            
/// Return：      
/// D ##class(%ResultSet).RunQuery("DHCMed.INFService.InfBaseAricmSrv","QryLabTestByPaadm","58008","1")
Query QryLabMicByTestNo(LabTestNo As %String = "") As %Query(ROWSPEC = "Rowid:%String,ArcimName:%String,sttDate:%String,OrdStsDesc:%String,LabTestNo:%String,OtherPara:%String,InfPosDR:%String,InfPosDesc:%String,PathDate:%String,Sample:%String,SampleDesc:%String,Method:%String,MethodDesc:%String,DrugFlag:%String,DrugFlagDesc:%String,ResumeText:%String,checked:%String,childSub:%String")
{
}

ClassMethod QryLabMicByTestNoExecute(ByRef qHandle As %Binary, LabTestNo As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	s ind=1
 	q:LabTestNo="" $$$OK
 	
    s Data=$lb("")
    s $li(Data,1)=""           //病原体id
    s $li(Data,2)="TT"           //病原体Desc 
    s $li(Data,3)=""           //抗菌药ID
    s $li(Data,4)=""           //抗菌药Desc
    s $li(Data,5)=""           //药敏ID
    s $li(Data,6)=""           //药敏Desc
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
}

ClassMethod QryLabMicByTestNoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLabMicByTestNoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryLabMicByTestNoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLabMicByTestNoExecute ]
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

/// Creator：     ChenJB
/// CreatDate：   2010-06-13
/// Description:  查询微生物检查结果病原体、抗菌药物信息
/// Table：       接口
/// Input：       报告ID ： 报告ID
/// output:       符合条件的项            
/// Return： 病原体id C(2) 病原体Desc C(2) 抗生素情况 C(2) 实验结果Code C(2) 实验结果Desc
///          抗生素情况 == 抗生素Id()_"^"_抗生素Desc_"^"_药敏Code_"^"_药敏Desc
/// w ##class(DHCMed.INFService.InfBaseAricmSrv).GetGermAntiArryStr(1)
ClassMethod GetGermAntiArryStr(PathCSID As %String = "") As %String
{
   n (PathCSID)
   s ret=""
   q:PathCSID="" ret
   q:'$d(^DHCMed.INF.PyObjI("InfPathDr",PathCSID)) ret
   s PyObjID=""
   f  s PyObjID=$o(^DHCMed.INF.PyObjI("InfPathDr",PathCSID,PyObjID)) q:+PyObjID=0  d
   .s objCls=##class(DHCMed.INF.PyObj).GetObjById(PyObjID)
   .q:'$IsObject(objCls)
   .s objGermCls=##class(DHCMed.INF.InfPathogenDic).GetObjById(objCls.Object)
   .q:'$IsObject(objGermCls)
   .s GFlag=objCls.Flag
   .//w objCls.Flag
   .s GFlagDesc=""
   .s StrAntis=""
   .i GFlag'="" d
   ..s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(GFlag,"InfectionLabSenCheck")
   ..s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
   ..q:'$IsObject(objDic)
   ..s GFlagDesc=objDic.Description
   ..k objDic 
   .s PyObjAntiID=""
   .f  s PyObjAntiID=$o(^DHCMed.INF.PyObjDrugI("InfPyObjDr",PyObjID,PyObjAntiID)) q:+PyObjAntiID=0  d
   ..s objPyObjAntiCls=##class(DHCMed.INF.PyObjDrug).GetObjById(PyObjAntiID)
   ..q:'$IsObject(objPyObjAntiCls)
   ..s objAntiCls=##class(DHCMed.INF.InfAntiDic).GetObjById(objPyObjAntiCls.DrugDR)
   ..q:'$IsObject(objAntiCls)
   ..s AFlag=objPyObjAntiCls.Flag
   ..s AFlagDesc=""
   ..i AFlag'="" d
   ...s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(AFlag,"InfectionLabSenCheck")
   ...s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
   ...q:'$IsObject(objDic)
   ...s AFlagDesc=objDic.Description
   ..s:StrAntis'="" StrAntis=StrAntis_$c(1)_objAntiCls.%Id()_"^"_objAntiCls.Description_"^"_AFlag_"^"_AFlagDesc
   ..s:StrAntis="" StrAntis=objAntiCls.%Id()_"^"_objAntiCls.Description_"^"_AFlag_"^"_AFlagDesc
   ..k objPyObjAntiCls
   ..k objAntiCls
   .s:ret'="" ret=ret_$c(3)_objGermCls.%Id()_"^"_objGermCls.Description_$c(2)_StrAntis_$c(2)_GFlag_"^"_GFlagDesc
   .s:ret="" ret=objGermCls.%Id()_"^"_objGermCls.Description_$c(2)_StrAntis_$c(2)_GFlag_"^"_GFlagDesc
   .k objCls
   .k objGermCls
   q ret
}

/// Creator：     ChenJB
/// CreatDate：   2010-09-13
/// Description:  查询微生物检查结果病原体、抗菌药物信息
/// Table：       接口
/// Input：       报告ID ： 报告ID
/// output:       符合条件的项            
/// Return： 病原体id C(2) 病原体Desc C(2) 抗生素情况 C(2) 实验结果Code C(2) 实验结果Desc
///          抗生素情况 == 抗生素Id()_"^"_抗生素Desc_"^"_药敏Code_"^"_药敏Desc
/// w ##class(DHCMed.INFService.InfBaseAricmSrv).GetGermAntiArryStrByLab("2233671||M010||1")
ClassMethod GetGermAntiArryStrByLab(TestSetRow As %String = "") As %String
{
   n (TestSetRow)
   s ret=""
   q:TestSetRow="" ret
   //返回的描述值
   s ldata=##class(DHCMed.INFService.InterfaceOut).GetGADataByLab(TestSetRow)
   f i=1:1:$l(ldata,$c(1))  d
   .s row=$p(ldata,$c(1),i)
   .q:row=""
   .s row1Val=$p(row,$c(3),1)   //病原体
   .q:row1Val=""
   .s germTmp=" "_$$ALPHAUP^SSUTIL4(row1Val)
   .// ^DHCMed.INF.InfPathogenMapingI("Description",rowid)
   .s germMap=$o(^DHCMed.INF.InfPathogenMapingI("Description",germTmp,""))
   .q:germMap=""
   .s objMapping=##class(DHCMed.INF.InfPathogenMaping).GetObjById(germMap)
   .q:'$IsObject(objMapping)
   .s PyObjID=objMapping.PatID
   .s objGermCls=##class(DHCMed.INF.InfPathogenDic).GetObjById(PyObjID)
   .q:'$IsObject(objGermCls)
   .s GFlag="Y"    //Y 阳性  N 阴性  C 无结果
   .s GFlagDesc="阳性"
   .s row2Val=$p(row,$c(3),2)   //抗生素 及药敏$c(2)
   .s PyObjAntiID=""
   .s StrAntis=""
   .f j=1:1:$l(row2Val,$c(2))  d
   ..s col2=$p(row2Val,$c(2),j)
   ..q:col2=""
   ..s colRow1Val=$p(col2,"^",1)   //抗菌素
   ..q:colRow1Val=""
   ..s antiTmp=" "_$$ALPHAUP^SSUTIL4(colRow1Val)
   ..s antiMap=$o(^DHCMed.INF.InfAntiMappingI("Description",antiTmp,""))
   ..s objMappingAnti=##class(DHCMed.INF.InfAntiMapping).GetObjById(antiMap)
   ..q:'$IsObject(objMappingAnti)
   ..s antiDr=objMappingAnti.AntiID
   ..s objAntiCls=##class(DHCMed.INF.InfAntiDic).GetObjById(antiDr)
   ..q:'$IsObject(objAntiCls)
   ..s AFlag=""
   ..s AFlagDesc=$p(col2,"^",2)   //药敏 Y 敏感 N 耐药  C 中度
   ..i AFlagDesc["耐药" d
   ...s AFlag="N"
   ..e  d
   ...i AFlagDesc["敏感" d
   ....s AFlag="Y"
   ...e  d
   ....s AFlag="C"
   ..s:StrAntis'="" StrAntis=StrAntis_$c(1)_objAntiCls.%Id()_"^"_objAntiCls.Description_"^"_AFlag_"^"_AFlagDesc
   ..s:StrAntis="" StrAntis=objAntiCls.%Id()_"^"_objAntiCls.Description_"^"_AFlag_"^"_AFlagDesc
   ..k objPyObjAntiCls
   ..k objAntiCls
   .s:ret'="" ret=ret_$c(3)_objGermCls.%Id()_"^"_objGermCls.Description_$c(2)_StrAntis_$c(2)_GFlag_"^"_GFlagDesc
   .s:ret="" ret=objGermCls.%Id()_"^"_objGermCls.Description_$c(2)_StrAntis_$c(2)_GFlag_"^"_GFlagDesc
   .k objCls
   .k objGermCls
   q ret
}

}
