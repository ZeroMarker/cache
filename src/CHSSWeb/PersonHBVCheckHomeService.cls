Class CHSSWeb.PersonHBVCheckHomeService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// Creator: lyy
/// CreatDate：2009—07-08
/// Description:乙肝体检首页情况
/// Table：PersonHBVCheckHome
/// Input: PersonHBVCheckHome
/// Output：
/// Return：
/// Others：
ClassMethod List(PersonRowIdDR As %Integer, YearCheckRowIdParref As %Integer, start As %Integer, limit As %Integer, sort As %String) As %String
{
		Set PersonRowIdDR=$G(PersonRowIdDR)
		Set start=$G(start)
		Set limit=$G(limit)
		Set sort=$G(sort)
		Set count=0
		Set resultString = ""
		Set end = start+limit
		Set json = ##class(Code.JsonObj).%New()
		set HBVRowId = 0
		Set tmp = ""
		
		Set YearCheckRowIdParref=$G(YearCheckRowIdParref)
		
		
		For  Set HBVRowId=$O(^CHSS.PersonHBVCheckHomeI("PersonRowIdDRIndex",PersonRowIdDR,HBVRowId)) q:HBVRowId=""  d
		.
		
		.s tempPersonHBVCheckInfo=##class(CHSS.PersonHBVCheckHome).%OpenId(HBVRowId)
		
		./// 既往乙肝病史 
		.s bHaveHBV = tempPersonHBVCheckInfo.bHaveHBV
		
		.set DateOfFirstCheck = tempPersonHBVCheckInfo.DateOfFirstCheck
		.i DateOfFirstCheck '= "" d
		..s DateOfFirstCheck = $zd(DateOfFirstCheck,3)
		
		.set TypeOfFirstCheckName = ""
		.set TypeOfFirstCheck = ""
		.i tempPersonHBVCheckInfo.TypeOfFirstCheck '= "" d
		..s TypeOfFirstCheck = tempPersonHBVCheckInfo.TypeOfFirstCheck.%Id()
		..s TypeOfFirstCheckName = tempPersonHBVCheckInfo.TypeOfFirstCheck.Description
		
		.set DiagnoseThenName = ""
		.set DiagnoseThen = ""
		.i tempPersonHBVCheckInfo.DiagnoseThen '= "" d
		..s DiagnoseThen = tempPersonHBVCheckInfo.DiagnoseThen.%Id()
		..s DiagnoseThenName = tempPersonHBVCheckInfo.DiagnoseThen.Description
		
		.s GOT = tempPersonHBVCheckInfo.GOT
		./// 肝功能异常情况
		.s ALT = tempPersonHBVCheckInfo.ALT
	    .s AST = tempPersonHBVCheckInfo.AST
        .s ALB = tempPersonHBVCheckInfo.ALB
        .s GLOB = tempPersonHBVCheckInfo.GLOB
        .s AG = tempPersonHBVCheckInfo.AG
        .s TB = tempPersonHBVCheckInfo.TB
        .s DB = tempPersonHBVCheckInfo.DB
		
		.s bHaveComplication = tempPersonHBVCheckInfo.bHaveComplication
		.s bTreatThen = tempPersonHBVCheckInfo.bTreatThen
		.s bFollowUp = tempPersonHBVCheckInfo.bFollowUp
		.s bRelapse = tempPersonHBVCheckInfo.bRelapse
		
		
		.set TreatEffectionName = ""
		.set TreatEffection = ""
		.i tempPersonHBVCheckInfo.TreatEffection '= "" d
		..s TreatEffection = tempPersonHBVCheckInfo.TreatEffection.%Id()
		..s TreatEffectionName = tempPersonHBVCheckInfo.TreatEffection.Description
		
		./// 乙肝疫苗接种情况 
		
		.s bVaccination = tempPersonHBVCheckInfo.bVaccination
	
		.set VaccinationPlaceName = ""
		.set VaccinationPlace = ""
		.i tempPersonHBVCheckInfo.VaccinationPlace '= "" d
		..s VaccinationPlace = tempPersonHBVCheckInfo.VaccinationPlace.%Id()
		..s VaccinationPlaceName = tempPersonHBVCheckInfo.VaccinationPlace.Description
		
		.set DosageOfVaccinationName = ""
		.set DosageOfVaccination = ""
		.i tempPersonHBVCheckInfo.DosageOfVaccination '= "" d
		..s DosageOfVaccination = tempPersonHBVCheckInfo.DosageOfVaccination.%Id()
		..s DosageOfVaccinationName = tempPersonHBVCheckInfo.DosageOfVaccination.Description
		
		.s Needles = tempPersonHBVCheckInfo.Needles
		
		.set FirstVaccination = tempPersonHBVCheckInfo.FirstVaccination
		.i FirstVaccination '= "" d
		..s FirstVaccination = $zd(FirstVaccination,3)
		
		.set SecondVaccination = tempPersonHBVCheckInfo.SecondVaccination
		.i SecondVaccination '= "" d
		..s SecondVaccination = $zd(SecondVaccination,3)
		
		.set ThirdVaccination = tempPersonHBVCheckInfo.ThirdVaccination
		.i ThirdVaccination '= "" d
		..s ThirdVaccination = $zd(ThirdVaccination,3)
		
		.s TimesOfVaccination = tempPersonHBVCheckInfo.TimesOfVaccination
		.s bMonitor = tempPersonHBVCheckInfo.bMonitor
		
		.set TiterName = ""
		.set Titer = ""
		.i tempPersonHBVCheckInfo.Titer '= "" d
		..s Titer = tempPersonHBVCheckInfo.Titer.%Id()
		..s TiterName = tempPersonHBVCheckInfo.Titer.Description
		
		.set FrequencyOfMonitorName = ""
		.set FrequencyOfMonitor = ""
		.i tempPersonHBVCheckInfo.FrequencyOfMonitor '= "" d
		..s FrequencyOfMonitor = tempPersonHBVCheckInfo.FrequencyOfMonitor.%Id()
		..s FrequencyOfMonitorName = tempPersonHBVCheckInfo.FrequencyOfMonitor.Description
		
		.s bReplant = tempPersonHBVCheckInfo.bReplant 
		
		./// 感染途径调查
		./// 垂直传播
		.s bFatherInfection = tempPersonHBVCheckInfo.bFatherInfection
		
		.set DateOfFatherInfection = tempPersonHBVCheckInfo.DateOfFatherInfection
		.i DateOfFatherInfection '= "" d
		..s DateOfFatherInfection = $zd(DateOfFatherInfection,3)
		
		.s bMomInfection = tempPersonHBVCheckInfo.bMomInfection
		
		.set DateOfMomInfection = tempPersonHBVCheckInfo.DateOfMomInfection
		.i DateOfMomInfection '= "" d
		..s DateOfMomInfection = $zd(DateOfMomInfection,3)
		
		
		.s bSonInfection = tempPersonHBVCheckInfo.bSonInfection
		
		.set DateOfSonInfection = tempPersonHBVCheckInfo.DateOfSonInfection
		.i DateOfSonInfection '= "" d
		..s DateOfSonInfection = $zd(DateOfSonInfection,3)
		
		
		.s bFamilyHBV = tempPersonHBVCheckInfo.bFamilyHBV
		.s bFamilyCirrhosis = tempPersonHBVCheckInfo.bFamilyCirrhosis
		.s bLiverCancer = tempPersonHBVCheckInfo.bLiverCancer
		
		./// 水平传播
		./// 血液途径
		.
		.s bBloodTransfusion = tempPersonHBVCheckInfo.bBloodTransfusion
		
		.set TypOfBloodName = ""
		.set TypOfBlood = ""
		.i tempPersonHBVCheckInfo.TypOfBlood '= "" d
		..s TypOfBlood = tempPersonHBVCheckInfo.TypOfBlood.%Id()
		..s TypOfBloodName = tempPersonHBVCheckInfo.TypOfBlood.Description
		
		.set KindOfBloodName = ""
		.set KindOfBlood = ""
		.i tempPersonHBVCheckInfo.KindOfBlood '= "" d
		..s KindOfBlood = tempPersonHBVCheckInfo.KindOfBlood.%Id()
		..s KindOfBloodName = tempPersonHBVCheckInfo.KindOfBlood.Description
		
		.s bIVDrug = tempPersonHBVCheckInfo.bIVDrug
		.s bUseOneInjector = tempPersonHBVCheckInfo.bUseOneInjector
		
		.set UseInjectorName = ""
		.set UseInjector = ""
		.i tempPersonHBVCheckInfo.UseInjector '= "" d
		..s UseInjector = tempPersonHBVCheckInfo.UseInjector.%Id()
		..s UseInjectorName = tempPersonHBVCheckInfo.UseInjector.Description
		
		.s bNotOneTIme = tempPersonHBVCheckInfo.bNotOneTIme
		
		./// 非血液途径
		.
		.s bSpouseInfection = tempPersonHBVCheckInfo.bSpouseInfection
		
		.set DateOfspouseInfection = tempPersonHBVCheckInfo.DateOfspouseInfection
		.i DateOfspouseInfection '= "" d
		..s DateOfspouseInfection = $zd(DateOfspouseInfection,3)
		
		.s HBVContactHistory = tempPersonHBVCheckInfo.HBVContactHistory
		.s bHairdressing = tempPersonHBVCheckInfo.bHairdressing
		.s bTattoo = tempPersonHBVCheckInfo.bTattoo
		.s bFoottMassage = tempPersonHBVCheckInfo.bFoottMassage
		.s bSexPartner = tempPersonHBVCheckInfo.bSexPartner
		.s SexPartnerNum = tempPersonHBVCheckInfo.SexPartnerNum
		.s bExposureHBV = tempPersonHBVCheckInfo.bExposureHBV
		
		.///症状和并发症情况
		.
		.s StatusOfFirstCheckValue = tempPersonHBVCheckInfo.StatusOfFirstCheckValue
		.s ComplicationInfoValue = tempPersonHBVCheckInfo.ComplicationInfoValue
		
		.s HBVDNA = tempPersonHBVCheckInfo.HBVDNA
        
        .set DateOfBroInfection = tempPersonHBVCheckInfo.DateOfBroInfection
        .i DateOfBroInfection '= "" d
        ..s DateOfBroInfection = $zd(DateOfBroInfection,3)
        
        .s bBroInfection = tempPersonHBVCheckInfo.bBroInfection
        .s bOneUseInje = tempPersonHBVCheckInfo.bOneUseInje
        .s bReUseInje = tempPersonHBVCheckInfo.bReUseInje
        .s OtherPass = tempPersonHBVCheckInfo.OtherPass
        
        .set DateOfStart = tempPersonHBVCheckInfo.DateOfStart
        .i DateOfStart '= "" d
        ..s DateOfStart = $zd(DateOfStart,3)
        
        .set HBVMName = ""
        .set HBVM = ""
        .i tempPersonHBVCheckInfo.HBVM '= "" d
        ..s HBVM = tempPersonHBVCheckInfo.HBVM.%Id()
        ..s HBVMName = tempPersonHBVCheckInfo.HBVM.Description
        
        .s bGOT = tempPersonHBVCheckInfo.bGOT
       
		
		.Set tmp = HBVRowId_"^"_bHaveHBV_"^"_DateOfFirstCheck_"^"_TypeOfFirstCheck_"^"_TypeOfFirstCheckName_"^"_DiagnoseThen_"^"_DiagnoseThenName_"^"_GOT_"^"_ALT_"^"_AST_"^"_ALB_"^"_GLOB_"^"_AG_"^"_TB_"^"_DB_"^"_bHaveComplication_"^"_bTreatThen_"^"_bFollowUp_"^"_bRelapse_"^"_TreatEffection_"^"_TreatEffectionName_"^"_bVaccination_"^"_VaccinationPlace_"^"_VaccinationPlaceName_"^"_DosageOfVaccination_"^"_DosageOfVaccinationName_"^"_Needles_"^"_FirstVaccination_"^"_SecondVaccination_"^"_ThirdVaccination_"^"_TimesOfVaccination_"^"_bMonitor_"^"_Titer_"^"_TiterName_"^"_FrequencyOfMonitor_"^"_FrequencyOfMonitorName_"^"_bReplant_"^"_bFatherInfection_"^"_DateOfFatherInfection_"^"_bMomInfection_"^"_DateOfMomInfection_"^"_bSonInfection_"^"_DateOfSonInfection_"^"_bFamilyHBV_"^"_bFamilyCirrhosis_"^"_bLiverCancer_"^"_bBloodTransfusion_"^"_TypOfBlood_"^"_TypOfBloodName_"^"_KindOfBlood_"^"_KindOfBloodName_"^"_bIVDrug_"^"_bUseOneInjector_"^"_UseInjector_"^"_UseInjectorName_"^"_bNotOneTIme_"^"_bSpouseInfection_"^"_DateOfspouseInfection_"^"_HBVContactHistory_"^"_bHairdressing_"^"_bTattoo_"^"_bFoottMassage_"^"_bSexPartner_"^"_SexPartnerNum_"^"_bExposureHBV_"^"_StatusOfFirstCheckValue_"^"_ComplicationInfoValue_"^"_HBVDNA_"^"_DateOfBroInfection_"^"_bBroInfection_"^"_bOneUseInje_"^"_bReUseInje_"^"_OtherPass_"^"_DateOfStart_"^"_HBVM_"^"_HBVMName_"^"_bGOT
	    .Set count=count+1
	    .///.If (count>start)&(count<=end) d
		.///..d json.InsertRowData(tmp)
		.
		.
		
		
		If (count>start)&(count<=end) d
		.set tmpPersonYearCheckHBV = ##class(CHSSWeb.PersonYearCheckHBVService).List(YearCheckRowIdParref,start,limit,sort)
		.set tmp = tmp_"^"_tmpPersonYearCheckHBV
		.
		.d json.InsertRowData(tmp)
		.
		
	    Set resultString = json.getJsonData("HBVRowId^bHaveHBV^DateOfFirstCheck^TypeOfFirstCheck^TypeOfFirstCheckName^DiagnoseThen^DiagnoseThenName^GOT^ALT1^AST1^ALB1^GLOB^AG^TB^DB^bHaveComplication^bTreatThen^bFollowUp^bRelapse^TreatEffection^TreatEffectionName^bVaccination^VaccinationPlace^VaccinationPlaceName^DosageOfVaccination^DosageOfVaccinationName^Needles^FirstVaccination^SecondVaccination^ThirdVaccination^TimesOfVaccination^bMonitor^Titer^TiterName^FrequencyOfMonitor^FrequencyOfMonitorName^bReplant^bFatherInfection^DateOfFatherInfection^bMomInfection^DateOfMomInfection^bSonInfection^DateOfSonInfection^bFamilyHBV^bFamilyCirrhosis^bLiverCancer^bBloodTransfusion^TypOfBlood^TypOfBloodName^KindOfBlood^KindOfBloodName^bIVDrug^bUseOneInjector^UseInjector^UseInjectorName^bNotOneTIme^bSpouseInfection^DateOfspouseInfection^HBVContactHistory^bHairdressing^bTattoo^bFoottMassage^bSexPartner^SexPartnerNum^bExposureHBV^StatusOfFirstCheckValue^ComplicationInfoValue^HBVDNA^DateOfBroInfection^bBroInfection^bOneUseInje^bReUseInje^OtherPass^DateOfStart^HBVM^HBVMName^bGOT^HBVRecordRowId^CurSizeOfLiver^CurSizeOfLiverName^CurRigidityOfLiver^CurRigidityOfLiverName^CurSizeOfSpleen^CurSizeOfSpleenName^CurRigidityOfSpleen^CurRigidityOfSpleenName^CurLiverFunction^CurLiverFunctionName^CurALT^CurAST^CurALB^CurGLOB^CurAG^CurTB^CurDB^HbsAg1^HbsAgName^HbsAb1^HbsAbName^HbeAg^HbeAgName^HBeAb^HBeAbName^HbcAb^HbcAbName^AFP^SizeOfLiver^SizeOfLiverName^ShapeOfLiver^ShapeOfLiverName^EnvelopeOfLiver^EnvelopeOfLiverName^EchoOfLiver^EchoOfLiverName^NoduleOfLiver^NoduleOfLiverName^PortalOfLiver^PortalOfLiverName^WidthOfLiverPortal^SizeOfSpleen^SizeOfSpleenName^ShapeOfSpleen^ShapeOfSpleenName^DepthOfSpleen^DepthOfSpleenName^NoduleOfSpleen^NoduleOfSpleenName^SplenicVein^SplenicVeinName^WidthOfSplenicVein^LiverBUS^CurStatusValue^PhysicalSignValue^GallSize^GallSizeName^DepthOfGall^DepthOfGallName^GallStone^LiverPortalOther",count)
	 	k json
	 	
		Quit resultString
}

/// Creator: lyy
/// CreatDate：2009—07-08
/// Description:添加乙肝体检首页情况
/// Table：PersonHBVCheckHome
/// Input: PersonHBVCheckHome
/// Output：
/// Return：
/// Others：
ClassMethod Insert(PersonRowIdDR As %Integer, bHaveHBV As %String, DateOfFirstCheck As %Date, TypeOfFirstCheck As %Integer, DiagnoseThen As %Integer, GOT As %String, ALT As %String, AST As %String, ALB As %String, GLOB As %String, AG As %String, TB As %String, DB As %String, bHaveComplication As %String, bTreatThen As %String, bFollowUp As %String, bRelapse As %String, TreatEffection As %Integer, bVaccination As %String, VaccinationPlace As %Integer, DosageOfVaccination As %Integer, Needles As %Numeric, FirstVaccination As %Date, SecondVaccination As %Date, ThirdVaccination As %Date, TimesOfVaccination As %Numeric, bMonitor As %String, Titer As %Integer, FrequencyOfMonitor As %Integer, bReplant As %String, bFatherInfection As %String, DateOfFatherInfection As %Date, bMomInfection As %String, DateOfMomInfection As %Date, bSonInfection As %String, DateOfSonInfection As %Date, bFamilyHBV As %String, bFamilyCirrhosis As %String, bLiverCancer As %String, bBloodTransfusion As %String, TypOfBlood As %Integer, KindOfBlood As %Integer, bIVDrug As %String, bUseOneInjector As %String, UseInjector As %Integer, bNotOneTIme As %String, bSpouseInfection As %String, DateOfspouseInfection As %Date, HBVContactHistory As %String, bHairdressing As %String, bTattoo As %String, bFoottMassage As %String, bSexPartner As %String, SexPartnerNum As %Numeric, bExposureHBV As %String, StatusOfFirstCheckValue As %String, ComplicationInfoValue As %String, HBVDNA As %Float, DateOfBroInfection As %Date, bBroInfection As %String, bOneUseInje As %String, bReUseInje As %String, OtherPass As %String, DateOfStart As %Date, HBVM As %Integer, bGOT As %String) As %String
{
	  s tempPersonHBVCheckInfo=""
      s tempPersonHBVCheckInfo=##class(CHSS.PersonHBVCheckHome).%New()
      q:(tempPersonHBVCheckInfo="") 0
      
      s PersonRowIdDRobj=##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowIdDR)
      s tempPersonHBVCheckInfo.PersonRowIdDR=PersonRowIdDRobj
            
      
      /// 既往乙肝病史 
      s tempPersonHBVCheckInfo.bHaveHBV = bHaveHBV
      
      i DateOfFirstCheck '= "" d
      .s DateOfFirstCheck=$zdh(DateOfFirstCheck,3)
      s tempPersonHBVCheckInfo.DateOfFirstCheck=DateOfFirstCheck
      
      i TypeOfFirstCheck '= "" d
      .s TypeOfFirstCheckobj=##class(CHSS.DictTypeOfFirstCheck).%OpenId(TypeOfFirstCheck)
      .s tempPersonHBVCheckInfo.TypeOfFirstCheck=TypeOfFirstCheckobj
      
      i DiagnoseThen '= "" d
      .s DiagnoseThenobj=##class(CHSS.DictDiagnoseResult).%OpenId(DiagnoseThen)
      .s tempPersonHBVCheckInfo.DiagnoseThen=DiagnoseThenobj
      
      s tempPersonHBVCheckInfo.GOT = GOT
      
      /// 肝功能异常情况
      s tempPersonHBVCheckInfo.ALT = ALT
      s tempPersonHBVCheckInfo.AST = AST
      s tempPersonHBVCheckInfo.ALB = ALB
      s tempPersonHBVCheckInfo.GLOB = GLOB
      s tempPersonHBVCheckInfo.AG = AG
      s tempPersonHBVCheckInfo.TB = TB
      s tempPersonHBVCheckInfo.DB = DB
      
      
      s tempPersonHBVCheckInfo.bHaveComplication = bHaveComplication
      s tempPersonHBVCheckInfo.bTreatThen = bTreatThen
      s tempPersonHBVCheckInfo.bFollowUp = bFollowUp
      s tempPersonHBVCheckInfo.bRelapse = bRelapse
      
      i TreatEffection '= "" d
      .s TreatEffectionobj=##class(CHSS.DictTreatEffection).%OpenId(TreatEffection)
      .s tempPersonHBVCheckInfo.TreatEffection=TreatEffectionobj
      
      
      /// 乙肝疫苗接种情况 
      
      s tempPersonHBVCheckInfo.bVaccination = bVaccination
      /// VaccinationPlace--
      
      i VaccinationPlace '= "" d
      .s VaccinationPlaceobj=##class(CHSS.DictVaccinationPlace).%OpenId(VaccinationPlace)
      .s tempPersonHBVCheckInfo.VaccinationPlace=VaccinationPlaceobj
      
      i DosageOfVaccination '= "" d
      .s DosageOfVaccinationobj=##class(CHSS.DictVaccinationDosage).%OpenId(DosageOfVaccination)
      .s tempPersonHBVCheckInfo.DosageOfVaccination=DosageOfVaccinationobj
      
      
      s tempPersonHBVCheckInfo.Needles = Needles
      
      i FirstVaccination '= "" d
      .s FirstVaccination=$zdh(FirstVaccination,3)
      s tempPersonHBVCheckInfo.FirstVaccination=FirstVaccination
      
      i SecondVaccination '= "" d
      .s SecondVaccination=$zdh(SecondVaccination,3)
      s tempPersonHBVCheckInfo.SecondVaccination=SecondVaccination
      
      i ThirdVaccination '= "" d
      .s ThirdVaccination=$zdh(ThirdVaccination,3)
      s tempPersonHBVCheckInfo.ThirdVaccination=ThirdVaccination
      
      s tempPersonHBVCheckInfo.TimesOfVaccination = TimesOfVaccination
      s tempPersonHBVCheckInfo.bMonitor = bMonitor
      
      
      i Titer '= "" d
      .s Titerobj=##class(CHSS.DictTiter).%OpenId(Titer)
      .s tempPersonHBVCheckInfo.Titer=Titerobj
      
      i FrequencyOfMonitor '= "" d
      .s FrequencyOfMonitorobj=##class(CHSS.DictMonitorFrequency).%OpenId(FrequencyOfMonitor)
      .s tempPersonHBVCheckInfo.FrequencyOfMonitor=FrequencyOfMonitorobj
      
      s tempPersonHBVCheckInfo.bReplant = bReplant
      
      
      /// 感染途径调查
      /// 垂直传播
      s tempPersonHBVCheckInfo.bFatherInfection = bFatherInfection
      
      i DateOfFatherInfection '= "" d
      .s DateOfFatherInfection=$zdh(DateOfFatherInfection,3)
      s tempPersonHBVCheckInfo.DateOfFatherInfection=DateOfFatherInfection
      
      s tempPersonHBVCheckInfo.bMomInfection = bMomInfection
      
      i DateOfMomInfection '= "" d
      .s DateOfMomInfection=$zdh(DateOfMomInfection,3)
      s tempPersonHBVCheckInfo.DateOfMomInfection=DateOfMomInfection
      
      s tempPersonHBVCheckInfo.bSonInfection = bSonInfection
      
      i DateOfSonInfection '= "" d
      .s DateOfSonInfection=$zdh(DateOfSonInfection,3)
      s tempPersonHBVCheckInfo.DateOfSonInfection=DateOfSonInfection
      
      s tempPersonHBVCheckInfo.bFamilyHBV = bFamilyHBV
      s tempPersonHBVCheckInfo.bFamilyCirrhosis = bFamilyCirrhosis
      s tempPersonHBVCheckInfo.bLiverCancer = bLiverCancer
      
      
      /// 水平传播
      /// 血液途径
      
      s tempPersonHBVCheckInfo.bBloodTransfusion = bBloodTransfusion
      
      i TypOfBlood '= "" d
      .s TypOfBloodobj=##class(CHSS.DictTypOfBlood).%OpenId(TypOfBlood)
      .s tempPersonHBVCheckInfo.TypOfBlood=TypOfBloodobj
      
      i KindOfBlood '= "" d
      .s KindOfBloodobj=##class(CHSS.DictKindOfBlood).%OpenId(KindOfBlood)
      .s tempPersonHBVCheckInfo.KindOfBlood=KindOfBloodobj
      
      s tempPersonHBVCheckInfo.bIVDrug = bIVDrug
      s tempPersonHBVCheckInfo.bUseOneInjector = bUseOneInjector
      
      i UseInjector '= "" d
      .s UseInjectorobj=##class(CHSS.DictKindOfBlood).%OpenId(UseInjector)
      .s tempPersonHBVCheckInfo.UseInjector=UseInjectorobj
      
      s tempPersonHBVCheckInfo.bNotOneTIme = bNotOneTIme
      
      
      /// 非血液途径
      
      s tempPersonHBVCheckInfo.bSpouseInfection = bSpouseInfection
      
      i DateOfspouseInfection '= "" d
      .s DateOfspouseInfection=$zdh(DateOfspouseInfection,3)
      s tempPersonHBVCheckInfo.DateOfspouseInfection=DateOfspouseInfection
      
      
      s tempPersonHBVCheckInfo.HBVContactHistory = HBVContactHistory
      s tempPersonHBVCheckInfo.bHairdressing = bHairdressing
      s tempPersonHBVCheckInfo.bTattoo = bTattoo
      s tempPersonHBVCheckInfo.bFoottMassage = bFoottMassage
      s tempPersonHBVCheckInfo.bSexPartner = bSexPartner
      s tempPersonHBVCheckInfo.SexPartnerNum = SexPartnerNum
      s tempPersonHBVCheckInfo.bExposureHBV = bExposureHBV
      
      ///症状和并发症情况
	  
	  s tempPersonHBVCheckInfo.StatusOfFirstCheckValue = StatusOfFirstCheckValue
	  s tempPersonHBVCheckInfo.ComplicationInfoValue = ComplicationInfoValue
	  
	  
	  s tempPersonHBVCheckInfo.HBVDNA = HBVDNA
      
      i DateOfBroInfection '= "" d
      .s DateOfBroInfection=$zdh(DateOfBroInfection,3)
      s tempPersonHBVCheckInfo.DateOfBroInfection=DateOfBroInfection
      
      s tempPersonHBVCheckInfo.bBroInfection = bBroInfection
      s tempPersonHBVCheckInfo.bOneUseInje = bOneUseInje
      s tempPersonHBVCheckInfo.bReUseInje = bReUseInje
      s tempPersonHBVCheckInfo.OtherPass = OtherPass
      
      i DateOfStart '= "" d
      .s DateOfStart=$zdh(DateOfStart,3)
      s tempPersonHBVCheckInfo.DateOfStart=DateOfStart
      
      i HBVM '= "" d
      .s HBVMobj=##class(CHSS.DictHBVM).%OpenId(HBVM)
      .s tempPersonHBVCheckInfo.HBVM=HBVMobj
      
      
      s tempPersonHBVCheckInfo.bGOT = bGOT
      
      s result=""
      s result=tempPersonHBVCheckInfo.%Save()
      Set resultString = ""
      
      i result = "1" d
      .s resultString = "success:true,info:"_tempPersonHBVCheckInfo.%Id()
      .///w "{""success"":""true"",""info"":"_tempPersonHBVCheckInfo.%Id()_"}"
      e  d
      .s resultString = "{""success"":""false"",""info"":""数据保存出错!""}"
      .///w "{""success"":""false"",""info"":""数据保存出错!""}"
      .
      q resultString
}

/// Creator: lyy
/// CreatDate：2009—07-08
/// Description:更新乙肝体检首页情况
/// Table：PersonHBVCheckHome
/// Input: PersonHBVCheckHome
/// Output：
/// Return：
/// Others：
ClassMethod Update(HBVRowId As %Integer, bHaveHBV As %String, DateOfFirstCheck As %Date, TypeOfFirstCheck As %Integer, DiagnoseThen As %Integer, GOT As %String, ALT As %String, AST As %String, ALB As %String, GLOB As %String, AG As %String, TB As %String, DB As %String, bHaveComplication As %String, bTreatThen As %String, bFollowUp As %String, bRelapse As %String, TreatEffection As %Integer, bVaccination As %String, VaccinationPlace As %Integer, DosageOfVaccination As %Integer, Needles As %Numeric, FirstVaccination As %Date, SecondVaccination As %Date, ThirdVaccination As %Date, TimesOfVaccination As %Numeric, bMonitor As %String, Titer As %Integer, FrequencyOfMonitor As %Integer, bReplant As %String, bFatherInfection As %String, DateOfFatherInfection As %Date, bMomInfection As %String, DateOfMomInfection As %Date, bSonInfection As %String, DateOfSonInfection As %Date, bFamilyHBV As %String, bFamilyCirrhosis As %String, bLiverCancer As %String, bBloodTransfusion As %String, TypOfBlood As %Integer, KindOfBlood As %Integer, bIVDrug As %String, bUseOneInjector As %String, UseInjector As %Integer, bNotOneTIme As %String, bSpouseInfection As %String, DateOfspouseInfection As %Date, HBVContactHistory As %String, bHairdressing As %String, bTattoo As %String, bFoottMassage As %String, bSexPartner As %String, SexPartnerNum As %Numeric, bExposureHBV As %String, StatusOfFirstCheckValue As %String, ComplicationInfoValue As %String, HBVDNA As %Float, DateOfBroInfection As %Date, bBroInfection As %String, bOneUseInje As %String, bReUseInje As %String, OtherPass As %String, DateOfStart As %Date, HBVM As %Integer, bGOT As %String) As %String
{
  
      q:($d(HBVRowId)=0)||(HBVRowId="")
      
      s tempPersonHBVCheckInfo="",result=""
      s tempPersonHBVCheckInfo=##class(CHSS.PersonHBVCheckHome).%OpenId(HBVRowId)
      q:(tempPersonHBVCheckInfo="") 0
       
      
      /// 既往乙肝病史 
      s tempPersonHBVCheckInfo.bHaveHBV = bHaveHBV
      
      i DateOfFirstCheck '= "" d
      .s DateOfFirstCheck=$zdh(DateOfFirstCheck,3)
      s tempPersonHBVCheckInfo.DateOfFirstCheck=DateOfFirstCheck
      
      i TypeOfFirstCheck '= "" d
      .s TypeOfFirstCheckobj=##class(CHSS.DictTypeOfFirstCheck).%OpenId(TypeOfFirstCheck)
      .s tempPersonHBVCheckInfo.TypeOfFirstCheck=TypeOfFirstCheckobj
      
      i DiagnoseThen '= "" d
      .s DiagnoseThenobj=##class(CHSS.DictDiagnoseResult).%OpenId(DiagnoseThen)
      .s tempPersonHBVCheckInfo.DiagnoseThen=DiagnoseThenobj
      
      s tempPersonHBVCheckInfo.GOT = GOT
      
      /// 肝功能异常情况
      s tempPersonHBVCheckInfo.ALT = ALT
      s tempPersonHBVCheckInfo.AST = AST
      s tempPersonHBVCheckInfo.ALB = ALB
      s tempPersonHBVCheckInfo.GLOB = GLOB
      s tempPersonHBVCheckInfo.AG = AG
      s tempPersonHBVCheckInfo.TB = TB
      s tempPersonHBVCheckInfo.DB = DB
      
      
      s tempPersonHBVCheckInfo.bHaveComplication = bHaveComplication
      s tempPersonHBVCheckInfo.bTreatThen = bTreatThen
      s tempPersonHBVCheckInfo.bFollowUp = bFollowUp
      s tempPersonHBVCheckInfo.bRelapse = bRelapse
      
      i TreatEffection '= "" d
      .s TreatEffectionobj=##class(CHSS.DictTreatEffection).%OpenId(TreatEffection)
      .s tempPersonHBVCheckInfo.TreatEffection=TreatEffectionobj
      
      
      /// 乙肝疫苗接种情况 
      
      s tempPersonHBVCheckInfo.bVaccination = bVaccination
      /// VaccinationPlace--
      
      i VaccinationPlace '= "" d
      .s VaccinationPlaceobj=##class(CHSS.DictVaccinationPlace).%OpenId(VaccinationPlace)
      .s tempPersonHBVCheckInfo.VaccinationPlace=VaccinationPlaceobj
      
      i DosageOfVaccination '= "" d
      .s DosageOfVaccinationobj=##class(CHSS.DictVaccinationDosage).%OpenId(DosageOfVaccination)
      .s tempPersonHBVCheckInfo.DosageOfVaccination=DosageOfVaccinationobj
      
      
      s tempPersonHBVCheckInfo.Needles = Needles
      
      i FirstVaccination '= "" d
      .s FirstVaccination=$zdh(FirstVaccination,3)
      s tempPersonHBVCheckInfo.FirstVaccination=FirstVaccination
      
      i SecondVaccination '= "" d
      .s SecondVaccination=$zdh(SecondVaccination,3)
      s tempPersonHBVCheckInfo.SecondVaccination=SecondVaccination
      
      i ThirdVaccination '= "" d
      .s ThirdVaccination=$zdh(ThirdVaccination,3)
      s tempPersonHBVCheckInfo.ThirdVaccination=ThirdVaccination
      
      s tempPersonHBVCheckInfo.TimesOfVaccination = TimesOfVaccination
      s tempPersonHBVCheckInfo.bMonitor = bMonitor
      
      
      i Titer '= "" d
      .s Titerobj=##class(CHSS.DictTiter).%OpenId(Titer)
      .s tempPersonHBVCheckInfo.Titer=Titerobj
      
      i FrequencyOfMonitor '= "" d
      .s FrequencyOfMonitorobj=##class(CHSS.DictMonitorFrequency).%OpenId(FrequencyOfMonitor)
      .s tempPersonHBVCheckInfo.FrequencyOfMonitor=FrequencyOfMonitorobj
      
      s tempPersonHBVCheckInfo.bReplant = bReplant
      
      
      /// 感染途径调查
      /// 垂直传播
      s tempPersonHBVCheckInfo.bFatherInfection = bFatherInfection
      
      i DateOfFatherInfection '= "" d
      .s DateOfFatherInfection=$zdh(DateOfFatherInfection,3)
      s tempPersonHBVCheckInfo.DateOfFatherInfection=DateOfFatherInfection
      
      s tempPersonHBVCheckInfo.bMomInfection = bMomInfection
      
      i DateOfMomInfection '= "" d
      .s DateOfMomInfection=$zdh(DateOfMomInfection,3)
      s tempPersonHBVCheckInfo.DateOfMomInfection=DateOfMomInfection
      
      s tempPersonHBVCheckInfo.bSonInfection = bSonInfection
      
      i DateOfSonInfection '= "" d
      .s DateOfSonInfection=$zdh(DateOfSonInfection,3)
      s tempPersonHBVCheckInfo.DateOfSonInfection=DateOfSonInfection
      
      s tempPersonHBVCheckInfo.bFamilyHBV = bFamilyHBV
      s tempPersonHBVCheckInfo.bFamilyCirrhosis = bFamilyCirrhosis
      s tempPersonHBVCheckInfo.bLiverCancer = bLiverCancer
      
      
      /// 水平传播
      /// 血液途径
      
      s tempPersonHBVCheckInfo.bBloodTransfusion = bBloodTransfusion
      
      i TypOfBlood '= "" d
      .s TypOfBloodobj=##class(CHSS.DictTypOfBlood).%OpenId(TypOfBlood)
      .s tempPersonHBVCheckInfo.TypOfBlood=TypOfBloodobj
      
      i KindOfBlood '= "" d
      .s KindOfBloodobj=##class(CHSS.DictKindOfBlood).%OpenId(KindOfBlood)
      .s tempPersonHBVCheckInfo.KindOfBlood=KindOfBloodobj
      
      s tempPersonHBVCheckInfo.bIVDrug = bIVDrug
      s tempPersonHBVCheckInfo.bUseOneInjector = bUseOneInjector
      
      i UseInjector '= "" d
      .s UseInjectorobj=##class(CHSS.DictKindOfBlood).%OpenId(UseInjector)
      .s tempPersonHBVCheckInfo.UseInjector=UseInjectorobj
      
      s tempPersonHBVCheckInfo.bNotOneTIme = bNotOneTIme
      
      
      /// 非血液途径
      
      s tempPersonHBVCheckInfo.bSpouseInfection = bSpouseInfection
      
      i DateOfspouseInfection '= "" d
      .s DateOfspouseInfection=$zdh(DateOfspouseInfection,3)
      s tempPersonHBVCheckInfo.DateOfspouseInfection=DateOfspouseInfection
      
      
      s tempPersonHBVCheckInfo.HBVContactHistory = HBVContactHistory
      s tempPersonHBVCheckInfo.bHairdressing = bHairdressing
      s tempPersonHBVCheckInfo.bTattoo = bTattoo
      s tempPersonHBVCheckInfo.bFoottMassage = bFoottMassage
      s tempPersonHBVCheckInfo.bSexPartner = bSexPartner
      s tempPersonHBVCheckInfo.SexPartnerNum = SexPartnerNum
      s tempPersonHBVCheckInfo.bExposureHBV = bExposureHBV
      
      ///症状和并发症情况
	  
	  s tempPersonHBVCheckInfo.StatusOfFirstCheckValue = StatusOfFirstCheckValue
	  s tempPersonHBVCheckInfo.ComplicationInfoValue = ComplicationInfoValue
	  
	  
	  s tempPersonHBVCheckInfo.HBVDNA = HBVDNA
      
      i DateOfBroInfection '= "" d
      .s DateOfBroInfection=$zdh(DateOfBroInfection,3)
      s tempPersonHBVCheckInfo.DateOfBroInfection=DateOfBroInfection
      
      s tempPersonHBVCheckInfo.bBroInfection = bBroInfection
      s tempPersonHBVCheckInfo.bOneUseInje = bOneUseInje
      s tempPersonHBVCheckInfo.bReUseInje = bReUseInje
      s tempPersonHBVCheckInfo.OtherPass = OtherPass
      
      i DateOfStart '= "" d
      .s DateOfStart=$zdh(DateOfStart,3)
      s tempPersonHBVCheckInfo.DateOfStart=DateOfStart
      
      i HBVM '= "" d
      .s HBVMobj=##class(CHSS.DictHBVM).%OpenId(HBVM)
      .s tempPersonHBVCheckInfo.HBVM=HBVMobj

      s tempPersonHBVCheckInfo.bGOT = bGOT
      
      s result=""
      s result=tempPersonHBVCheckInfo.%Save()
      Set resultString = ""
      
     
      i result = "1" d
      .s resultString = "success:true,info:"_HBVRowId
      .///w "{""success"":""true"",""info"":"_HBVRowId_"}"
      e  d
      .s resultString = "{""success"":""false"",""info"":""数据保存出错!""}"
      .///w "{""success"":""false"",""info"":""数据保存出错!""}"
      q resultString
}

Storage Default
{
<Data name="PersonHBVCheckHomeServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.PersonHBVChe98FD</DataLocation>
<DefaultData>PersonHBVCheckHomeServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.PersonHBVChe98FD</IdLocation>
<IndexLocation>^CHSSWeb.PersonHBVChe98FI</IndexLocation>
<StreamLocation>^CHSSWeb.PersonHBVChe98FS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
