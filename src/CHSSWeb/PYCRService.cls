Class CHSSWeb.PYCRService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

ClassMethod List(PersonRowId As %String, start As %Integer, limit As %Integer) As %String
{
	
	Set PersonRowId = $G( PersonRowId )
	Set start = $G( start )
	Set limit = $G( limit )	
	Set end   = start + limit 
	Set count = 0
	Set resultString = ""
	Set json  = ##class(Code.JsonObj).%New()
	Set checkRowId = 0
    Set tempPersonCheck = ##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowId)
    Set Sex = tempPersonCheck.SexDR.CTSEXDesc 
    Set Age = ..GetAge(tempPersonCheck.Birth)
	For  Set checkRowId = $O(^CHSS.PersonYearCheckRecordI("PersonRowIdParrefIndex",PersonRowId,checkRowId)) q:checkRowId=""  d
	.Set tempCheck = ##class(CHSS.PersonYearCheckRecord).%OpenId(checkRowId)
	.Set DateCheck = $zd(tempCheck.DateCheck,3)
	.Set CheckDoctor = tempCheck.CheckDoctor
	.Set Symptom = tempCheck.Symptom
	.Set Temperature = tempCheck.Temperature
	.Set Pulse =  tempCheck.Pulse
	.Set Breath = tempCheck.Breath
	.Set nHighPressure = tempCheck.nHighPressure
	.Set nLowPressure =  tempCheck.nLowPressure
	.Set Weight =  tempCheck.Weight
	.Set Height =  tempCheck.Height
	.Set BMI =   tempCheck.BMI
	.Set WaistlineStern = tempCheck.WaistlineStern
	.s Waist = tempCheck.Waist
	.s Saddle = tempCheck.Saddle
	.Set OlderCongnize = ""
	.Set OlderCongnizeId = ""
	.if tempCheck.OlderCongnize '= "" do
	..Set OlderCongnize = tempCheck.OlderCongnize.Description
	..Set OlderCongnizeId = tempCheck.OlderCongnize.%Id()
	
	.Set OlderCongnizeScore = tempCheck.OlderCongnizeScore
	
	.Set OlderSensibility = ""
	.Set OlderSensibilityId = ""
	.if tempCheck.OlderSensibility '= "" do
	..Set OlderSensibility = tempCheck.OlderSensibility.Description
	..Set OlderSensibilityId = tempCheck.OlderSensibility.%Id()
	
	.Set OlderSensibilityScore = tempCheck.OlderSensibilityScore
	.Set LiveQuality = tempCheck.LiveQuality
	.Set LeftEyesight =   tempCheck.LeftEyesight
	.Set RightEyesight =  tempCheck.RightEyesight
	.Set LeftCorrectEyesight = tempCheck.LeftCorrectEyesight
	.Set RightCorrectEyesight = tempCheck.RightCorrectEyesight

	.Set Hearing = ""
	.Set HearingId = ""
	.if tempCheck.Hearing '= "" do
	..Set Hearing = tempCheck.Hearing.Description
	..Set HearingId = tempCheck.Hearing.%Id()
	
	.Set Movement = ""
	.Set MovementId = ""
	.if tempCheck.Movement '= "" do
	..Set Movement = tempCheck.Movement.Description
	..Set MovementId = tempCheck.Movement.%Id()
	
	.Set Skin = ""
	.Set SkinId = ""
	.if tempCheck.Skin '= "" do
	..Set Skin = tempCheck.Skin.Description
	..Set SkinId = tempCheck.Skin.%Id()
	
	.Set Scrofula = ""
	.Set ScrofulaId = ""
	.if tempCheck.Scrofula '= "" do
	..Set Scrofula = tempCheck.Scrofula.Description
	..Set ScrofulaId = tempCheck.Scrofula.%Id()		
	.Set ScrofulaOther = tempCheck.ScrofulaOther
	
	.Set bBarrelChest = ""
	.Set bBarrelChestId = ""
	.if tempCheck.bBarrelChest '= "" do
	..Set bBarrelChest = tempCheck.bBarrelChest.Description
	..Set bBarrelChestId = tempCheck.bBarrelChest.%Id()	
				
	.Set BreathSounds = tempCheck.BreathSounds

	.Set BreathSoundsInfo = tempCheck.BreathSoundsInfo
	.Set Rale = tempCheck.Rale
	.Set RaleInfo = tempCheck.RaleInfo
	.Set HeartRate = tempCheck.HeartRate
	
	.Set CardiacRhythm = ""
	.Set CardiacRhythmId = ""
	.if tempCheck.CardiacRhythm '= "" do
	..Set CardiacRhythm =   tempCheck.CardiacRhythm.Description
	..Set CardiacRhythmId = tempCheck.CardiacRhythm.%Id()
	
	.Set Souffle = tempCheck.Souffle
	.Set SouffleInfo = tempCheck.SouffleInfo
	.Set Tenderness = tempCheck.Tenderness
	.Set TendernessInfo =  tempCheck.TendernessInfo
	.Set EnclosedMass =   tempCheck.EnclosedMass
	.Set EnclosedMassInfo = tempCheck.EnclosedMassInfo

	.Set Hepatauxe = tempCheck.Hepatauxe
	.Set HepatauxeInfo = tempCheck.HepatauxeInfo
	.Set Splenomegaly =  tempCheck.Splenomegaly
	.Set SplenomegalyInfo =  tempCheck.SplenomegalyInfo
	.Set ShiftingDullness = tempCheck.ShiftingDullness
	.Set ShiftingDullnessInfo = tempCheck.ShiftingDullnessInfo
	
	.Set EdemaOfLimbs = ""
	.Set EdemaOfLimbsId = ""
	.if tempCheck.EdemaOfLimbs '= "" do
	..Set EdemaOfLimbs = tempCheck.EdemaOfLimbs.Description
	..Set EdemaOfLimbsId = tempCheck.EdemaOfLimbs.%Id()
	
	.Set Anus = ""
	.Set AnusId = ""
	.if tempCheck.Anus '= "" do
	..Set Anus = tempCheck.Anus.Description
	..Set AnusId = tempCheck.Anus.%Id()

	.Set AnusOther = tempCheck.AnusOther

	.Set Prostate = ""
	.Set ProstateId = ""
	.if tempCheck.Prostate '= "" do
	..Set Prostate = tempCheck.Prostate.Description
	..Set ProstateId = tempCheck.Prostate.%Id()
	
	.Set ProstateInfo = tempCheck.ProstateInfo
	.Set PersonCode =##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowId).PersonCode
	.Set PersonName =##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowId).PersonName
	.Set Other = tempCheck.Other
	.s OralLips = tempCheck.OralLips
	.s Dentition = ""
	.s DentitionName = ""
	.if tempCheck.Dentition '= "" do
	..Set DentitionName = tempCheck.Dentition.Description
	..Set Dentition = tempCheck.Dentition.%Id()
	.
	.s PharyngealCheck = tempCheck.PharyngealCheck
	.//判断是否打印过
    .Set IsPrint = 0
	.if (tempCheck.IsPrint '= ""&&tempCheck.IsPrint '= "0") do
	..Set IsPrint = tempCheck.IsPrint
	.//条形码是否存在
	.Set IsExist= $d(^CHSS.CheckUpBarcodeRecordI("YearCheckRowIdIndex"," "_checkRowId))
    
    ./// 妇科检查
      .
      .s VaginaInflammationName = ""
      .s VaginaInflammation = ""
      .i tempCheck.VaginaInflammation '= "" d
      ..s VaginaInflammation = tempCheck.VaginaInflammation.%Id()
      ..s VaginaInflammationName = tempCheck.VaginaInflammation.Description
      
      .s VaginaInflammationDes = tempCheck.VaginaInflammationDes
      
      .s CervicitisName = ""
      .s Cervicitis = ""
      .i tempCheck.Cervicitis '= "" d
      ..s Cervicitis = tempCheck.Cervicitis.%Id()
      ..s CervicitisName = tempCheck.Cervicitis.Description
      
      .s CervicitisDes = tempCheck.CervicitisDes
      
      .s DoubleWombsName = ""
      .s DoubleWombs = ""
      .i tempCheck.DoubleWombs '= "" d
      ..s DoubleWombs = tempCheck.DoubleWombs.%Id()
      ..s DoubleWombsName = tempCheck.DoubleWombs.Description
      
      .s DoubleWombsDes = tempCheck.DoubleWombsDes
      
      .s UterineFibroidsName = ""
      .s UterineFibroids = ""
      .i tempCheck.UterineFibroids '= "" d
      ..s UterineFibroids = tempCheck.UterineFibroids.%Id()
      ..s UterineFibroidsName = tempCheck.UterineFibroids.Description
      
      .s UterineFibroidsDes = tempCheck.UterineFibroidsDes
      
      .s AccessaryTumourName = ""
      .s AccessaryTumour = ""
      .i tempCheck.AccessaryTumour '= "" d
      ..s AccessaryTumour = tempCheck.AccessaryTumour.%Id()
      ..s AccessaryTumourName = tempCheck.AccessaryTumour.Description
      
      .s AccessaryTumourDes = tempCheck.AccessaryTumourDes
      .s Galactophore = tempCheck.Galactophore
      .s Sclera = tempCheck.Sclera
	
	
	.Set tmp= ""
	.Set tmp = checkRowId_"^"_PersonCode_"^"_PersonName_"^"_DateCheck_"^"_CheckDoctor_"^"_Symptom_"^"_Temperature_"^"_Pulse_"^"_Breath_"^"_nHighPressure_"^"_nLowPressure_"^"_Weight_"^"_Height_"^"_BMI_"^"_WaistlineStern_"^"_OlderCongnize_"^"_OlderCongnizeId_"^"_OlderCongnizeScore_"^"_OlderSensibility_"^"_OlderSensibilityId_"^"_OlderSensibilityScore_"^"_LiveQuality_"^"_LeftEyesight_"^"_RightEyesight_"^"_LeftCorrectEyesight_"^"_RightCorrectEyesight_"^"_Hearing_"^"_HearingId_"^"_Movement_"^"_MovementId_"^"_Skin_"^"_SkinId_"^"_Scrofula_"^"_ScrofulaId_"^"_ScrofulaOther_"^"_bBarrelChest_"^"_bBarrelChestId_"^"_BreathSounds_"^"_BreathSoundsInfo_"^"_Rale_"^"_RaleInfo_"^"_HeartRate_"^"_CardiacRhythm_"^"_CardiacRhythmId_"^"_Souffle_"^"_SouffleInfo_"^"_Tenderness_"^"_TendernessInfo_"^"_EnclosedMass_"^"_EnclosedMassInfo_"^"_Hepatauxe_"^"_HepatauxeInfo_"^"_Splenomegaly_"^"_SplenomegalyInfo_"^"_ShiftingDullness_"^"_ShiftingDullnessInfo_"^"_EdemaOfLimbs_"^"_EdemaOfLimbsId_"^"_Anus_"^"_AnusId_"^"_AnusOther_"^"_Prostate_"^"_ProstateId_"^"_ProstateInfo_"^"_Other_"^"_PersonRowId_"^"_IsPrint_"^"_IsExist_"^"_Sex_"^"_Age_"^"_Waist_"^"_Saddle_"^"_OralLips_"^"_Dentition_"^"_DentitionName_"^"_PharyngealCheck_"^"_VaginaInflammation_"^"_VaginaInflammationName_"^"_VaginaInflammationDes_"^"_Cervicitis_"^"_CervicitisName_"^"_CervicitisDes_"^"_DoubleWombs_"^"_DoubleWombsName_"^"_DoubleWombsDes_"^"_UterineFibroids_"^"_UterineFibroidsName_"^"_UterineFibroidsDes_"^"_AccessaryTumour_"^"_AccessaryTumourName_"^"_AccessaryTumourDes_"^"_Galactophore_"^"_Sclera
	.Set count=count+1
	.If (count>start)&(count<=end) d
    ..d json.InsertRowData(tmp)
	Set resultString = json.getJsonData("YearCheckRowId^PersonCode^PersonName^DateCheck^CheckDoctor^Symptom^Temperature^Pulse^Breath^nHighPressure^nLowPressure^Weight^Height^BMI^WaistlineStern^OlderCongnize^OlderCongnizeId^OlderCongnizeScore^OlderSensibility^OlderSensibilityId^OlderSensibilityScore^LiveQuality^LeftEyesight^RightEyesight^LeftCorrectEyesight^RightCorrectEyesight^Hearing^HearingId^Movement^MovementId^Skin^SkinId^Scrofula^ScrofulaId^ScrofulaOther^bBarrelChest^bBarrelChestId^BreathSounds^BreathSoundsInfo^Rale^RaleInfo^HeartRate^CardiacRhythm^CardiacRhythmId^Souffle^SouffleInfo^Tenderness^TendernessInfo^EnclosedMass^EnclosedMassInfo^Hepatauxe^HepatauxeInfo^Splenomegaly^SplenomegalyInfo^ShiftingDullness^ShiftingDullnessInfo^EdemaOfLimbs^EdemaOfLimbsId^Anus^AnusId^AnusOther^Prostate^ProstateId^ProstateInfo^Other^PersonRowId^IsPrint^IsExist^Sex^Age^Waist^Saddle^OralLips^Dentition^DentitionName^PharyngealCheck^VaginaInflammation^VaginaInflammationName^VaginaInflammationDes^Cervicitis^CervicitisName^CervicitisDes^DoubleWombs^DoubleWombsName^DoubleWombsDes^UterineFibroids^UterineFibroidsName^UterineFibroidsDes^AccessaryTumour^AccessaryTumourName^AccessaryTumourDes^Galactophore^Sclera",count)
	k json	
	Quit resultString
}

ClassMethod Insert(PersonRowIdParref As %String, DateCheck As %Date, CheckDoctor As %String, Symptom As %String, Temperature As %Float, Pulse As %Integer, Breath As %Integer, nHighPressure As %Integer, nLowPressure As %Integer, Height As %Float, Weight As %Float, BMI As %Float, WaistlineStern As %Float, OlderCongnizeId As %String, OlderCongnizeScore As %String, OlderSensibilityId As %String, LiveQuality As %String, OlderSensibilityScore As %String, LeftEyesight As %Float, RightEyesight As %Float, LeftCorrectEyesight As %Float, RightCorrectEyesight As %Float, HearingId As %String, MovementId As %String, SkinId As %String, ScrofulaId As %String, ScrofulaOther As %String, bBarrelChestId As %String, BreathSounds As %String, BreathSoundsInfo As %String, Rale As %String, RaleInfo As %String, HeartRate As %String, CardiacRhythmId As %String, Souffle As %String, SouffleInfo As %String, Tenderness As %String, TendernessInfo As %String, EnclosedMass As %String, EnclosedMassInfo As %String, Hepatauxe As %String, HepatauxeInfo As %String, Splenomegaly As %String, SplenomegalyInfo As %String, ShiftingDullness As %String, ShiftingDullnessInfo As %String, EdemaOfLimbsId As %String, AnusId As %String, AnusOther As %String, ProstateId As %String, ProstateInfo As %String, Other As %String, Waist As %Float, Saddle As %Float, OralLips As %String, Dentition As %Integer, PharyngealCheck As %String, VaginaInflammation As %Integer, VaginaInflammationDes As %String, Cervicitis As %Integer, CervicitisDes As %String, DoubleWombs As %Integer, DoubleWombsDes As %String, UterineFibroids As %Integer, UterineFibroidsDes As %String, AccessaryTumour As %Integer, AccessaryTumourDes As %String, Galactophore As %String, Sclera As %String) As %String
{
	Set tempCheck = ""
	Set tempCheck = ##class(CHSS.PersonYearCheckRecord).%New()
	q:(tempCheck = "" ) 0
	
	Set ReturnId = ..existPersonRowId(PersonRowIdParref)
	
	i (ReturnId'="0") d
	.w "{""success"":""false"",""info"":""个人编码: "_ReturnId_" 已存在! 请重新输入!""}"
	e  d
	.Set tempCheck.PersonRowIdParref = ##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowIdParref)
	

	.i DateCheck '= "" do
	..;Set tempCheck.DateCheck = $zdh(DateCheck,3)
	.;Set tempCheck.CheckDoctor = CheckDoctor
	.;Set tempCheck.Symptom = Symptom
	.;Set tempCheck.Temperature = Temperature
	.;Set tempCheck.Pulse = Pulse
	.;Set tempCheck.Breath  = Breath 
	.;Set tempCheck.nHighPressure = nHighPressure
	.;Set tempCheck.nLowPressure = nLowPressure
	.;Set tempCheck.Height  = Height 
	.;Set tempCheck.Weight = Weight
	.;Set tempCheck.BMI  = BMI
	.;Set tempCheck.WaistlineStern  = WaistlineStern
	.;Set tempCheck.OlderCongnize = ##class(CHSS.DictCognitiveAbility).%OpenId(OlderCongnizeId)
	.;Set tempCheck.OlderCongnizeScore  = OlderCongnizeScore 
	.;Set tempCheck.OlderSensibility  = ##class(CHSS.DictAffectiveState).%OpenId(OlderSensibilityId) 
	.;Set tempCheck.OlderSensibilityScore  = OlderSensibilityScore 
	.;Set tempCheck.LiveQuality  = LiveQuality 
	.;Set tempCheck.HeartRate  = HeartRate 
	.;Set tempCheck.Waist = Waist
	.;Set tempCheck.Saddle = Saddle
	.Set tempCheck.HeartRate  = HeartRate 
	.Set tempCheck.LeftEyesight   = LeftEyesight  
	.Set tempCheck.RightEyesight   = RightEyesight  
	.Set tempCheck.LeftCorrectEyesight  = LeftCorrectEyesight 
	.Set tempCheck.RightCorrectEyesight   = RightCorrectEyesight 
	.Set tempCheck.Hearing = ##class(CHSS.DictHearing).%OpenId(HearingId)
	.Set tempCheck.Movement  = ##class(CHSS.DictMotorFunction).%OpenId(MovementId) 

	.Set tempCheck.Skin = ##class(CHSS.DictSkin).%OpenId(SkinId)
	.Set tempCheck.Scrofula  = ##class(CHSS.DictLymphNodes).%OpenId(ScrofulaId) 
	.Set tempCheck.ScrofulaOther  = ScrofulaOther 
	.Set tempCheck.bBarrelChest   =  ##class(CHSS.DictBarrelChest).%OpenId(bBarrelChestId)  
	.Set tempCheck.BreathSounds  = BreathSounds 
	.Set tempCheck.BreathSoundsInfo   = BreathSoundsInfo 	
	
	.Set tempCheck.Rale  = Rale 
	.Set tempCheck.RaleInfo   = RaleInfo 
	.
	.Set tempCheck.CardiacRhythm   = ##class(CHSS.DictCardiacRhythm).%OpenId(CardiacRhythmId)  
	.Set tempCheck.Souffle   = Souffle   
	.Set tempCheck.SouffleInfo    = SouffleInfo   
	.Set tempCheck.Tenderness   = Tenderness 
	.Set tempCheck.TendernessInfo    = TendernessInfo 
	.Set tempCheck.EnclosedMass   = EnclosedMass 
	.Set tempCheck.EnclosedMassInfo    = EnclosedMassInfo  
	.Set tempCheck.Hepatauxe   = Hepatauxe  
	.Set tempCheck.HepatauxeInfo    = HepatauxeInfo   
	.Set tempCheck.Splenomegaly    = Splenomegaly    
	.Set tempCheck.SplenomegalyInfo     = SplenomegalyInfo    
	.Set tempCheck.ShiftingDullness    = ShiftingDullness  
	.Set tempCheck.ShiftingDullnessInfo     = ShiftingDullnessInfo 	
	.Set tempCheck.EdemaOfLimbs    = ##class(CHSS.DictLowerExtremityEdema).%OpenId(EdemaOfLimbsId)  
	.Set tempCheck.Anus     = ##class(CHSS.DictAnus).%OpenId(AnusId)   
	.Set tempCheck.AnusOther    = AnusOther   
	.Set tempCheck.Prostate    = ##class(CHSS.DictProstate).%OpenId(ProstateId )
	.Set tempCheck.ProstateInfo     = ProstateInfo
	.Set tempCheck.Other = Other
	.set tempCheck.OralLips = OralLips
	.i Dentition '= "" d
	..Set tempCheck.Dentition = ##class(CHSS.DictDentition).%OpenId(Dentition)
	.Set tempCheck.PharyngealCheck  = PharyngealCheck 
	.
	.
	.i VaginaInflammation '= "" d
    ..s VaginaInflammationobj = ##class(CHSS.DictWomenCheck).%OpenId(VaginaInflammation)
    ..s tempCheck.VaginaInflammation = VaginaInflammationobj
    .
    .s tempCheck.VaginaInflammationDes = VaginaInflammationDes
    .i Cervicitis '= "" d
    ..s Cervicitisobj = ##class(CHSS.DictWomenCheck).%OpenId(Cervicitis)
    ..s tempCheck.Cervicitis = Cervicitisobj
    . 
    .s tempCheck.CervicitisDes = CervicitisDes
    .
    .i DoubleWombs '= "" d
    ..s DoubleWombsobj = ##class(CHSS.DictWomenCheck).%OpenId(DoubleWombs)
    ..s tempCheck.DoubleWombs = DoubleWombsobj
    .
    .s tempCheck.DoubleWombsDes = DoubleWombsDes
    . 
    .i UterineFibroids '= "" d
    ..s UterineFibroidsobj = ##class(CHSS.DictWomenCheck).%OpenId(UterineFibroids)
    ..s tempCheck.UterineFibroids = UterineFibroidsobj
    . 
    .s tempCheck.UterineFibroidsDes = UterineFibroidsDes
    . 
    .i AccessaryTumour '= "" d
    ..s AccessaryTumourobj = ##class(CHSS.DictWomenCheck).%OpenId(AccessaryTumour)
    ..s tempCheck.AccessaryTumour = AccessaryTumourobj
    . 
    .s tempCheck.AccessaryTumourDes = AccessaryTumourDes
    .s tempCheck.Galactophore = Galactophore
    .s tempCheck.Sclera = Sclera
	.s result=""
    .s result=tempCheck.%Save()
    .s YearCheckRowIdParref = tempCheck.%Id()
    .i result = "1" d
    ..w "{""success"":""true"",""info"":"_tempCheck.%Id()_"}"
    ..&SQL(insert into CHSS.PersonLifeStyle (YearCheckRowIdParref,PersonRowIdParref) values (:YearCheckRowIdParref,:PersonRowIdParref))
    ..w ##class(CHSSWeb.PersonHealthAppraiseService).insert(PersonRowIdParref,YearCheckRowIdParref)
    .e  d
    ..w "{""success"":""false"",""info"":""数据保存出错!""}"
    q ""
    /*
	.Set tempCheck.Dentition = ##class(CHSS.DictDentition).%OpenId(DentitionId)
	.Set tempCheck.PharyngealCheck  = PharyngealCheck 
	.Set tempCheck.WaistlineStern  = WaistlineStern 	
	.Set tempCheck.LiveQuality  = LiveQuality  
	     
	
	.if BookingDate '= "" d
	..Set BookingDate  = $zdh(BookingDate ,3) 
	.Set tempCheck.BookingDate = BookingDate
	
	.Set tempCheck.bBooking      = bBooking     
	.Set tempCheck.BloodSurgeLimosis     = BloodSurgeLimosis   
	.Set tempCheck.Cholesterin      = Cholesterin 
	 
	.Set tempCheck.MentalityAdjust    = MentalityAdjust  
	.Set tempCheck.CheckResult     = CheckResult   
	.Set tempCheck.Deal    = Deal   
	.Set tempCheck.StaffInput     = ##class(User.SSUser).%OpenId(StaffInputId)    
	.Set tempCheck.Other    = Other    
	*/
}

ClassMethod Update(CheckRecordId As %String, PersonRowIdParref As %String, LeftEyesight As %Float, RightEyesight As %Float, LeftCorrectEyesight As %Float, RightCorrectEyesight As %Float, HearingId As %String, MovementId As %String, SkinId As %String, ScrofulaId As %String, ScrofulaOther As %String, bBarrelChestId As %String, BreathSounds As %String, BreathSoundsInfo As %String, RaleId As %String, RaleInfo As %String, HeartRate As %String, CardiacRhythmId As %String, Souffle As %String, SouffleInfo As %String, Tenderness As %String, TendernessInfo As %String, EnclosedMass As %String, EnclosedMassInfo As %String, Hepatauxe As %String, HepatauxeInfo As %String, Splenomegaly As %String, SplenomegalyInfo As %String, ShiftingDullness As %String, ShiftingDullnessInfo As %String, EdemaOfLimbsId As %String, AnusId As %String, AnusOther As %String, ProstateId As %String, ProstateInfo As %String, Other As %String, OralLipsId As %String, DentitionId As %Integer, PharyngealCheckId As %String, VaginaInflammationId As %Integer, VaginaInflammationDes As %String, CervicitisId As %Integer, CervicitisDes As %String, DoubleWombsId As %Integer, DoubleWombsDes As %String, UterineFibroidsId As %Integer, UterineFibroidsDes As %String, AccessaryTumourId As %Integer, AccessaryTumourDes As %String, Galactophore As %String, ScleraId As %String) As %String
{
	q:($d(CheckRecordId)=0)||(CheckRecordId="")
	//q:($d(PersonRowIdParrefId)=0)||(PersonRowIdParrefId="")
	Set tempCheck = ""
	Set tempCheck = ##class(CHSS.PersonYearCheckRecord).%OpenId(CheckRecordId)

	q:(tempCheck = "" ) 0

	Set tempCheck.PersonRowIdParref = ##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowIdParref)

	;i DateCheck '= "" do
	.;Set tempCheck.DateCheck = $zdh(DateCheck,3)
	;Set tempCheck.CheckDoctor = CheckDoctor
	;Set tempCheck.Symptom = Symptom
	;Set tempCheck.Temperature = Temperature
	;Set tempCheck.Pulse = Pulse
	;Set tempCheck.Breath  = Breath 
	;Set tempCheck.nHighPressure = nHighPressure
	;Set tempCheck.nLowPressure = nLowPressure
	;Set tempCheck.Height  = Height 
	;Set tempCheck.Weight = Weight
	;Set tempCheck.BMI  = BMI
	;Set tempCheck.WaistlineStern  = WaistlineStern
	;Set tempCheck.OlderCongnize = ##class(CHSS.DictCognitiveAbility).%OpenId(OlderCongnizeId)
	;Set tempCheck.OlderCongnizeScore  = OlderCongnizeScore 
	;Set tempCheck.OlderSensibility  = ##class(CHSS.DictAffectiveState).%OpenId(OlderSensibilityId) 
	;Set tempCheck.OlderSensibilityScore  = OlderSensibilityScore  
	;Set tempCheck.LiveQuality = LiveQuality 
	;Set tempCheck.Waist = Waist
	;Set tempCheck.Saddle = Saddle
	;Set tempCheck.HeartRate  = HeartRate
	i ScleraId '= "" d
	.s ScleraObj = ##class(CHSS.DictSclera).%OpenId(ScleraId)
	.s tempCheck.Sclera = ScleraObj
	
	Set tempCheck.HeartRate  = HeartRate 
	Set tempCheck.LeftEyesight   = LeftEyesight  
	Set tempCheck.RightEyesight   = RightEyesight  
	Set tempCheck.LeftCorrectEyesight  = LeftCorrectEyesight 
	Set tempCheck.RightCorrectEyesight   = RightCorrectEyesight 
	Set tempCheck.Hearing = ##class(CHSS.DictHearing).%OpenId(HearingId)
	Set tempCheck.Movement  = ##class(CHSS.DictMotorFunction).%OpenId(MovementId) 

	Set tempCheck.Skin = ##class(CHSS.DictSkin).%OpenId(SkinId)
	Set tempCheck.Scrofula  = ##class(CHSS.DictLymphNodes).%OpenId(ScrofulaId) 
	Set tempCheck.ScrofulaOther  = ScrofulaOther 
	Set tempCheck.bBarrelChest   =  ##class(CHSS.DictBarrelChest).%OpenId(bBarrelChestId)  
	
	Set tempCheck.BreathSounds  = BreathSounds 
	Set tempCheck.BreathSoundsInfo   = BreathSoundsInfo 	
	
	i RaleId '= "" d   //罗音
	.s RaleObj = ##class(CHSS.DictRale).%OpenId(RaleId)
	.s tempCheck.Rale = RaleObj
	
	Set tempCheck.RaleInfo   = RaleInfo 
	
	Set tempCheck.CardiacRhythm = ##class(CHSS.DictCardiacRhythm).%OpenId(CardiacRhythmId)  
	Set tempCheck.Souffle = Souffle   
	Set tempCheck.SouffleInfo = SouffleInfo   
	Set tempCheck.Tenderness = Tenderness 
	Set tempCheck.TendernessInfo = TendernessInfo 
	Set tempCheck.EnclosedMass = EnclosedMass 
	Set tempCheck.EnclosedMassInfo = EnclosedMassInfo  
	Set tempCheck.Hepatauxe = Hepatauxe  
	Set tempCheck.HepatauxeInfo = HepatauxeInfo   
	Set tempCheck.Splenomegaly = Splenomegaly    
	Set tempCheck.SplenomegalyInfo = SplenomegalyInfo    
	Set tempCheck.ShiftingDullness = ShiftingDullness  
	Set tempCheck.ShiftingDullnessInfo = ShiftingDullnessInfo 	
	Set tempCheck.EdemaOfLimbs = ##class(CHSS.DictLowerExtremityEdema).%OpenId(EdemaOfLimbsId)  
	Set tempCheck.Anus = ##class(CHSS.DictAnus).%OpenId(AnusId)   
	Set tempCheck.AnusOther = AnusOther   
	Set tempCheck.Prostate = ##class(CHSS.DictProstate).%OpenId(ProstateId )
	Set tempCheck.ProstateInfo = ProstateInfo
	Set tempCheck.Other = Other
	
	/// 妇科检查
      
      i VaginaInflammationId '= "" d
      .s VaginaInflammationobj = ##class(CHSS.DictWomenCheck).%OpenId(VaginaInflammationId)
      .s tempCheck.VaginaInflammation = VaginaInflammationobj
      
      s tempCheck.VaginaInflammationDes = VaginaInflammationDes
      
      i CervicitisId '= "" d
      .s Cervicitisobj = ##class(CHSS.DictWomenCheck).%OpenId(CervicitisId)
      .s tempCheck.Cervicitis = Cervicitisobj
      
      s tempCheck.CervicitisDes = CervicitisDes
      
      i DoubleWombsId '= "" d
      .s DoubleWombsobj = ##class(CHSS.DictWomenCheck).%OpenId(DoubleWombsId)
      .s tempCheck.DoubleWombs = DoubleWombsobj
      
      s tempCheck.DoubleWombsDes = DoubleWombsDes
      
      i UterineFibroidsId '= "" d
      .s UterineFibroidsobj = ##class(CHSS.DictWomenCheck).%OpenId(UterineFibroidsId)
      .s tempCheck.UterineFibroids = UterineFibroidsobj
      
      s tempCheck.UterineFibroidsDes = UterineFibroidsDes
      
      i AccessaryTumourId '= "" d
      .s AccessaryTumourobj = ##class(CHSS.DictWomenCheck).%OpenId(AccessaryTumourId)
      .s tempCheck.AccessaryTumour = AccessaryTumourobj
      
      s tempCheck.AccessaryTumourDes = AccessaryTumourDes
      
      s tempCheck.Galactophore = Galactophore
      
	  i DentitionId '= "" d
	  .Set DentitionObj  = ##class(CHSS.DictDentition).%OpenId(DentitionId)
	  .s tempCheck.Dentition = DentitionObj
	  
	  i PharyngealCheckId '= "" d
	  .s PharyngealCheckObj = ##class(CHSS.DictPharyngeal).%OpenId(PharyngealCheckId)
	  .Set tempCheck.PharyngealCheck  = PharyngealCheckObj

	  i OralLipsId '= "" d
	  . set OralLipsobj = ##class(CHSS.DictOralLips).%OpenId(OralLipsId)
	  .set tempCheck.OralLips = OralLipsobj
	
	s result=""
    s result=tempCheck.%Save()
    ;q result
    i result = "1" d
    .w "{""success"":""true"",""info"":"_tempCheck.%Id()_"}"
    e  d
    .w "{""success"":""false"",""info"":""数据保存出错!""}"
    
    q ""
}

ClassMethod existPersonRowId(PersonRowId As %String) As %String
{
	q:PersonRowId="" "-1"
	s PersonRowId=" "_PersonRowId
	q:$d(^CHSS.PersonYearCheckRecordI("PersonRowIdParrefIndex",PersonRowId)) "1"
	q "0"
}

ClassMethod Delete(CheckRowId As %String) As %String
{
	&sql(delete from CHSS.PersonYearCheckRecord where YearCheckRowId= :CheckRowId)
	w SQLCODE
	q "0"
}

ClassMethod ListByComm(communityCode As %String, start As %Integer, limit As %Integer) As %String
{
	Set communityCode = " "_$G(communityCode)
	Set start = $G( start )
	Set limit = $G( limit )	
	
	Set end   = start + limit 
	Set count = 0
	
	set PersonRowId = 0
	set checkRowId = 0
	
	Set resultString = ""
	Set json  = ##class(Code.JsonObj).%New()

	For  Set PersonRowId=$O(^CHSS.PersonHealthRecordMainI("CommunityCodeIndex",communityCode,PersonRowId)) q:PersonRowId=""  d
		.For  Set checkRowId = $O(^CHSS.PersonYearCheckRecordI("PersonRowIdParrefIndex",PersonRowId,checkRowId)) q:checkRowId=""  d
			..Set tempCheck = ##class(CHSS.PersonYearCheckRecord).%OpenId(checkRowId)
			..Set DateCheck = $zd(tempCheck.DateCheck,3)
			..Set CheckDoctor = tempCheck.CheckDoctor
			..Set Symptom = tempCheck.Symptom
			..Set Temperature = tempCheck.Temperature
			..Set Pulse =  tempCheck.Pulse
			..Set Breath = tempCheck.Breath
			..Set nHighPressure = tempCheck.nHighPressure
			..Set nLowPressure =  tempCheck.nLowPressure
			..Set Weight =  tempCheck.Weight
			..Set Height =  tempCheck.Height
			..Set BMI =  tempCheck.BMI
			..Set Waist = tempCheck.Waist
			..Set Saddle = tempCheck.Saddle
			..Set WaistlineStern = tempCheck.WaistlineStern

			..Set OlderCongnize = ""
			..Set OlderCongnizeId = ""
			..if tempCheck.OlderCongnize '= "" do
				...Set OlderCongnize = tempCheck.OlderCongnize.Description
				...Set OlderCongnizeId = tempCheck.OlderCongnize.%Id()
	
			..Set OlderCongnizeScore = tempCheck.OlderCongnizeScore
	
			..Set OlderSensibility = ""
			..Set OlderSensibilityId = ""
			..if tempCheck.OlderSensibility '= "" do
				...Set OlderSensibility = tempCheck.OlderSensibility.Description
				...Set OlderSensibilityId = tempCheck.OlderSensibility.%Id()
	
			..Set OlderSensibilityScore = tempCheck.OlderSensibilityScore
			..Set LiveQuality = tempCheck.LiveQuality
			..Set LeftEyesight =   tempCheck.LeftEyesight
			..Set RightEyesight =  tempCheck.RightEyesight
			..Set LeftCorrectEyesight = tempCheck.LeftCorrectEyesight
			..Set RightCorrectEyesight = tempCheck.RightCorrectEyesight

			..Set Hearing = ""
			..Set HearingId = ""
			..if tempCheck.Hearing '= "" do
				...Set Hearing = tempCheck.Hearing.Description
				...Set HearingId = tempCheck.Hearing.%Id()
	
			..Set Movement = ""
			..Set MovementId = ""
			..if tempCheck.Movement '= "" do
				...Set Movement = tempCheck.Movement.Description
				...Set MovementId = tempCheck.Movement.%Id()
	
			..Set Skin = ""
			..Set SkinId = ""
			..if tempCheck.Skin '= "" do
				...Set Skin = tempCheck.Skin.Description
				...Set SkinId = tempCheck.Skin.%Id()
	
			..Set Scrofula = ""
			..Set ScrofulaId = ""
			..if tempCheck.Scrofula '= "" do
				...Set Scrofula = tempCheck.Scrofula.Description
				...Set ScrofulaId = tempCheck.Scrofula.%Id()		
			
			..Set ScrofulaOther = tempCheck.ScrofulaOther
	
			..Set bBarrelChest = ""
			..Set bBarrelChestId = ""
			..if tempCheck.bBarrelChest '= "" do
				...Set bBarrelChest = tempCheck.bBarrelChest.Description
				...Set bBarrelChestId = tempCheck.bBarrelChest.%Id()	
				
			..Set BreathSounds = tempCheck.BreathSounds
			..Set BreathSoundsInfo = tempCheck.BreathSoundsInfo
			
			..s Rale = ""   //罗音   
			..s RaleId = ""
			..i tempCheck.Rale '= "" d
				...s Rale = tempCheck.Rale.Description
				...S RaleId = tempCheck.Rale.%Id()
			
			..Set RaleInfo = tempCheck.RaleInfo
			..Set HeartRate = tempCheck.HeartRate
	
			..Set CardiacRhythm = ""
			..Set CardiacRhythmId = ""
			..if tempCheck.CardiacRhythm '= "" do
				...Set CardiacRhythm =   tempCheck.CardiacRhythm.Description
				...Set CardiacRhythmId = tempCheck.CardiacRhythm.%Id()
	
			..Set Souffle = tempCheck.Souffle
			..Set SouffleInfo = tempCheck.SouffleInfo
			..Set Tenderness = tempCheck.Tenderness
			..Set TendernessInfo =  tempCheck.TendernessInfo
			..Set EnclosedMass =   tempCheck.EnclosedMass
			..Set EnclosedMassInfo = tempCheck.EnclosedMassInfo

			..Set Hepatauxe = tempCheck.Hepatauxe
			..Set HepatauxeInfo = tempCheck.HepatauxeInfo
			..Set Splenomegaly =  tempCheck.Splenomegaly
			..Set SplenomegalyInfo =  tempCheck.SplenomegalyInfo
			..Set ShiftingDullness = tempCheck.ShiftingDullness
			..Set ShiftingDullnessInfo = tempCheck.ShiftingDullnessInfo
	
			..Set EdemaOfLimbs = ""
			..Set EdemaOfLimbsId = ""
			..if tempCheck.EdemaOfLimbs '= "" do
				...Set EdemaOfLimbs = tempCheck.EdemaOfLimbs.Description
				...Set EdemaOfLimbsId = tempCheck.EdemaOfLimbs.%Id()
	
			..Set Anus = ""
			..Set AnusId = ""
			..if tempCheck.EdemaOfLimbs '= "" do
				...Set Anus = tempCheck.Anus.Description
				...Set AnusId = tempCheck.Anus.%Id()

						..Set AnusOther = tempCheck.AnusOther

			..Set Prostate = ""    //前列腺
			..Set ProstateId = ""
			..if tempCheck.Prostate '= "" do
				...Set Prostate = tempCheck.Prostate.Description
				...set ProstateId = tempCheck.Prostate.%Id()
				
			..//add by hwb 2011-06-24
			..s OralLips = ""
			..s OralLipsId = ""
			..i tempCheck.OralLips '= "" d  //口唇
				...s OralLips=tempCheck.OralLips.Description
				...s OralLipsId=tempCheck.OralLips.%Id()
			
			..s Dentition = ""  //齿列
			..s DentitionId = ""
			..i tempCheck.Dentition '= "" d
				...s Dentition = tempCheck.Dentition.Description
				...s DentitionId = tempCheck.Dentition.%Id()
				
			..s PharyngealCheck = ""  //咽部
			..s PharyngealCheckId = ""
			..i tempCheck.PharyngealCheck '= "" d
				...s PharyngealCheck = tempCheck.PharyngealCheck.Description
				...s PharyngealCheckId = tempCheck.PharyngealCheck.%Id()			
			
			..s Sclera = ""
			..s ScleraId = ""
			..i tempCheck.Sclera '= "" d  //巩膜
				...s Sclera=tempCheck.Sclera.Description
				...s ScleraId=tempCheck.Sclera.%Id()
			
			..s VaginaInflammation = ""
			..s VaginaInflammationId = ""
			..i tempCheck.VaginaInflammation '= "" d  //外阴
				...s VaginaInflammation=tempCheck.VaginaInflammation.Description
				...s VaginaInflammationId=tempCheck.VaginaInflammation.%Id()
			
			..set VaginaInflammationDes = tempCheck.VaginaInflammationDes  //外阴异常情况
			..s Cervicitis = ""
			..s CervicitisId = ""			
			..i tempCheck.Cervicitis '= "" d  //宫颈
				...s Cervicitis=tempCheck.Cervicitis.Description
				...s CervicitisId=tempCheck.Cervicitis.%Id()
			
			..set CervicitisDes = tempCheck.CervicitisDes  //宫颈异常情况

			..s DoubleWombs = ""
			..s DoubleWombsId = ""				
			..i tempCheck.DoubleWombs '= "" d  //阴道
				...s DoubleWombs=tempCheck.DoubleWombs.Description
				...s DoubleWombsId=tempCheck.DoubleWombs.%Id()
			
			..set DoubleWombsDes = tempCheck.DoubleWombsDes  //阴道异常情况

			..s UterineFibroids = ""
			..s UterineFibroidsId = ""				
			..i tempCheck.UterineFibroids '= "" d  //宫体
				...s UterineFibroids=tempCheck.UterineFibroids.Description
				...s UterineFibroidsId=tempCheck.UterineFibroids.%Id()
			
			..set UterineFibroidsDes = tempCheck.UterineFibroidsDes  //宫体异常情况

			..s AccessaryTumour = ""
			..s AccessaryTumourId = ""				
			..i tempCheck.AccessaryTumour '= "" d  //附件
				...s AccessaryTumour=tempCheck.AccessaryTumour.Description
				...s AccessaryTumourId=tempCheck.AccessaryTumour.%Id()
			
			..set AccessaryTumourDes = tempCheck.AccessaryTumourDes  //附件异常情况

			..Set ProstateInfo = tempCheck.ProstateInfo
			..Set PersonCode =##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowId).PersonCode
			..Set PersonName =##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowId).PersonName
	
			..Set Other = tempCheck.Other
			..set Galactophore = tempCheck.Galactophore
			..Set tmp= ""
			..Set tmp = checkRowId_"^"_PersonCode_"^"_PersonName_"^"_DateCheck_"^"_CheckDoctor_"^"_Symptom_"^"_Temperature_"^"_Pulse_"^"_Breath_"^"_nHighPressure_"^"_nLowPressure_"^"_Weight_"^"_Height_"^"_BMI_"^"_Waist_"^"_Saddle_"^"_WaistlineStern_"^"_OlderCongnize_"^"_OlderCongnizeId_"^"_OlderCongnizeScore_"^"_OlderSensibility_"^"_OlderSensibilityId_"^"_OlderSensibilityScore_"^"_LiveQuality_"^"_LeftEyesight_"^"_RightEyesight_"^"_LeftCorrectEyesight_"^"_RightCorrectEyesight_"^"_Hearing_"^"_HearingId_"^"_Movement_"^"_MovementId_"^"_Skin_"^"_SkinId_"^"_Scrofula_"^"_ScrofulaId_"^"_ScrofulaOther_"^"_bBarrelChest_"^"_bBarrelChestId_"^"_BreathSounds_"^"_BreathSoundsInfo_"^"_Rale_"^"_RaleId_"^"_RaleInfo_"^"_HeartRate_"^"_CardiacRhythm_"^"_CardiacRhythmId_"^"_Souffle_"^"_SouffleInfo_"^"_Tenderness_"^"_TendernessInfo_"^"_EnclosedMass_"^"_EnclosedMassInfo_"^"_Hepatauxe_"^"_HepatauxeInfo_"^"_Splenomegaly_"^"_SplenomegalyInfo_"^"_ShiftingDullness_"^"_ShiftingDullnessInfo_"^"_EdemaOfLimbs_"^"_EdemaOfLimbsId_"^"_Anus_"^"_AnusId_"^"_AnusOther_"^"_Prostate_"^"_ProstateId_"^"_ProstateInfo_"^"_Other_"^"_PersonRowId_"^"_OralLips_"^"_OralLipsId_"^"_Dentition_"^"_DentitionId_"^"_PharyngealCheck_"^"_PharyngealCheckId_"^"_Sclera_"^"_ScleraId_"^"_VaginaInflammation_"^"_VaginaInflammationId_"^"_VaginaInflammationDes_"^"_Cervicitis_"^"_CervicitisId_"^"_CervicitisDes_"^"_DoubleWombs_"^"_DoubleWombsId_"^"_DoubleWombsDes_"^"_UterineFibroids_"^"_UterineFibroidsId_"^"_UterineFibroidsDes_"^"_AccessaryTumour_"^"_AccessaryTumourId_"^"_AccessaryTumourDes_"^"_Galactophore
			..Set count=count+1
			
			..If (count>start)&(count<=end) d
    			...d json.InsertRowData(tmp)
    
	Set resultString = json.getJsonData("YearCheckRowId^PersonCode^PersonName^DateCheck^CheckDoctor^Symptom^Temperature^Pulse^Breath^nHighPressure^nLowPressure^Weight^Height^BMI^Waist^Saddle^WaistlineStern^OlderCongnize^OlderCongnizeId^OlderCongnizeScore^OlderSensibility^OlderSensibilityId^OlderSensibilityScore^LiveQuality^LeftEyesight^RightEyesight^LeftCorrectEyesight^RightCorrectEyesight^Hearing^HearingId^Movement^MovementId^Skin^SkinId^Scrofula^ScrofulaId^ScrofulaOther^bBarrelChest^bBarrelChestId^BreathSounds^BreathSoundsInfo^Rale^RaleId^RaleInfo^HeartRate^CardiacRhythm^CardiacRhythmId^Souffle^SouffleInfo^Tenderness^TendernessInfo^EnclosedMass^EnclosedMassInfo^Hepatauxe^HepatauxeInfo^Splenomegaly^SplenomegalyInfo^ShiftingDullness^ShiftingDullnessInfo^EdemaOfLimbs^EdemaOfLimbsId^Anus^AnusId^AnusOther^Prostate^ProstateId^ProstateInfo^Other^PersonRowId^OralLips^OralLipsId^Dentition^DentitionId^PharyngealCheck^PharyngealCheckId^Sclera^ScleraId^VaginaInflammation^VaginaInflammationId^VaginaInflammationDes^Cervicitis^CervicitisId^CervicitisDes^DoubleWombs^DoubleWombsId^DoubleWombsDes^UterineFibroids^UterineFibroidsId^UterineFibroidsDes^AccessaryTumour^AccessaryTumourId^AccessaryTumourDes^Galactophore",count)
	k json	
	Quit resultString
}

ClassMethod ListByCheck(CheckRowId, start As %Integer, limit As %Integer) As %String
{
	q:(CheckRowId="") ""
	s count = 1
	Set json  = ##class(Code.JsonObj).%New()
	Set CheckRowId = $G( CheckRowId )
	s tempCheck = ""
	Set tempCheck = ##class(CHSS.PersonYearCheckRecord).%OpenId(CheckRowId)

	Set DateCheck = tempCheck.DateCheck
	i DateCheck '= "" d
	.Set DateCheck = $zd(DateCheck,3)
	Set CheckDoctor = tempCheck.CheckDoctor
	Set Symptom = tempCheck.Symptom
	Set Temperature = tempCheck.Temperature
	Set Pulse =  tempCheck.Pulse
	Set Breath = tempCheck.Breath
	Set nHighPressure = tempCheck.nHighPressure
	Set nLowPressure =  tempCheck.nLowPressure
	Set Weight =  tempCheck.Weight
	Set Height =  tempCheck.Height
	Set BMI =   tempCheck.BMI
	Set WaistlineStern = tempCheck.WaistlineStern
	
	Set OlderCongnize = ""
	Set OlderCongnizeId = ""
	if tempCheck.OlderCongnize '= "" do
		.Set OlderCongnize = tempCheck.OlderCongnize.Description
		.Set OlderCongnizeId = tempCheck.OlderCongnize.%Id()
	
	Set OlderCongnizeScore = tempCheck.OlderCongnizeScore
	
	Set OlderSensibility = ""
	Set OlderSensibilityId = ""
	if tempCheck.OlderSensibility '= "" do
		.Set OlderSensibility = tempCheck.OlderSensibility.Description
		.Set OlderSensibilityId = tempCheck.OlderSensibility.%Id()
	
	Set OlderSensibilityScore = tempCheck.OlderSensibilityScore
	Set LiveQuality = tempCheck.LiveQuality
	Set LeftEyesight =   tempCheck.LeftEyesight
	Set RightEyesight =  tempCheck.RightEyesight
	set LeftCorrectEyesight = ""
	set RightCorrectEyesight = ""
	Set LeftCorrectEyesight = tempCheck.LeftCorrectEyesight
	Set RightCorrectEyesight = tempCheck.RightCorrectEyesight

	Set Hearing = ""
	Set HearingId = ""
	if tempCheck.Hearing '= "" do
		.Set Hearing = tempCheck.Hearing.Description
		.Set HearingId = tempCheck.Hearing.%Id()
	
	Set Movement = ""
	Set MovementId = ""
	if tempCheck.Movement '= "" do
		.Set Movement = tempCheck.Movement.Description
		.Set MovementId = tempCheck.Movement.%Id()
	
	Set Skin = ""
	Set SkinId = ""
	if tempCheck.Skin '= "" do
		.Set Skin = tempCheck.Skin.Description
		.Set SkinId = tempCheck.Skin.%Id()
	
	Set Scrofula = ""
	Set ScrofulaId = ""
	if tempCheck.Scrofula '= "" do
		.Set Scrofula = tempCheck.Scrofula.Description
		.Set ScrofulaId = tempCheck.Scrofula.%Id()		
	
	Set ScrofulaOther = tempCheck.ScrofulaOther
	
	Set bBarrelChest = ""
	Set bBarrelChestId = ""
	if tempCheck.bBarrelChest '= "" do
		.Set bBarrelChest = tempCheck.bBarrelChest.Description
		.Set bBarrelChestId = tempCheck.bBarrelChest.%Id()	
				
	Set BreathSounds = tempCheck.BreathSounds

	Set BreathSoundsInfo = tempCheck.BreathSoundsInfo
	Set Rale = tempCheck.Rale
	Set RaleInfo = tempCheck.RaleInfo
	Set HeartRate = tempCheck.HeartRate
	
	Set CardiacRhythm = ""
	Set CardiacRhythmId = ""
	if tempCheck.CardiacRhythm '= "" do
		.Set CardiacRhythm =   tempCheck.CardiacRhythm.Description
		.Set CardiacRhythmId = tempCheck.CardiacRhythm.%Id()
	
	Set Souffle = tempCheck.Souffle
	Set SouffleInfo = tempCheck.SouffleInfo
	Set Tenderness = tempCheck.Tenderness
	Set TendernessInfo =  tempCheck.TendernessInfo
	Set EnclosedMass =   tempCheck.EnclosedMass
	Set EnclosedMassInfo = tempCheck.EnclosedMassInfo

	Set Hepatauxe = tempCheck.Hepatauxe
	Set HepatauxeInfo = tempCheck.HepatauxeInfo
	Set Splenomegaly =  tempCheck.Splenomegaly
	Set SplenomegalyInfo =  tempCheck.SplenomegalyInfo
	Set ShiftingDullness = tempCheck.ShiftingDullness
	Set ShiftingDullnessInfo = tempCheck.ShiftingDullnessInfo
	
	Set EdemaOfLimbs = ""
	Set EdemaOfLimbsId = ""
	if tempCheck.EdemaOfLimbs '= "" do
		.Set EdemaOfLimbs = tempCheck.EdemaOfLimbs.Description
		.Set EdemaOfLimbsId = tempCheck.EdemaOfLimbs.%Id()
	
	Set Anus = ""
	Set AnusId = ""
	if tempCheck.Anus '= "" do
		.Set Anus = tempCheck.Anus.Description
		.Set AnusId = tempCheck.Anus.%Id()

	Set AnusOther = tempCheck.AnusOther

	Set Prostate = ""
	Set ProstateId = ""
	if tempCheck.Prostate '= "" do
		.Set Prostate = tempCheck.Prostate.Description
		.Set ProstateId = tempCheck.Prostate.%Id()
	
	Set ProstateInfo = tempCheck.ProstateInfo
	Set UserCode = tempCheck.PersonRowIdParref.PersonCode
	;##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowId).PersonCode
	Set PersonName = tempCheck.PersonRowIdParref.PersonName
	;##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowId).PersonName
	
	Set Other = tempCheck.Other
	set PersonRowId = tempCheck.PersonRowIdParref.%Id()
	Set tmp= ""
	Set tmp = CheckRowId_"^"_UserCode_"^"_PersonName_"^"_DateCheck_"^"_CheckDoctor_"^"_Symptom_"^"_Temperature_"^"_Pulse_"^"_Breath_"^"_nHighPressure_"^"_nLowPressure
	set tmp = tmp_"^"_Weight_"^"_Height_"^"_BMI_"^"_WaistlineStern
	set tmp = tmp_"^"_OlderCongnize_"^"_OlderCongnizeId_"^"_OlderCongnizeScore
	set tmp = tmp_"^"_OlderSensibility_"^"_OlderSensibilityId_"^"_OlderSensibilityScore
	set tmp = tmp_"^"_LiveQuality_"^"_LeftEyesight_"^"_RightEyesight
	set tmp = tmp_"^"_LeftCorrectEyesight_"^"_RightCorrectEyesight
	set tmp = tmp_"^"_Hearing_"^"_HearingId_"^"_Movement_"^"_MovementId
	set tmp = tmp_"^"_Skin_"^"_SkinId_"^"_Scrofula_"^"_ScrofulaId_"^"_ScrofulaOther_"^"_bBarrelChest_"^"_bBarrelChestId_"^"_BreathSounds_"^"_BreathSoundsInfo_"^"_Rale_"^"_RaleInfo_"^"_HeartRate_"^"_CardiacRhythm_"^"_CardiacRhythmId_"^"_Souffle_"^"_SouffleInfo_"^"_Tenderness_"^"_TendernessInfo_"^"_EnclosedMass_"^"_EnclosedMassInfo_"^"_Hepatauxe_"^"_HepatauxeInfo_"^"_Splenomegaly_"^"_SplenomegalyInfo_"^"_ShiftingDullness_"^"_ShiftingDullnessInfo_"^"_EdemaOfLimbs_"^"_EdemaOfLimbsId_"^"_Anus_"^"_AnusId
	set tmp = tmp_"^"_AnusOther_"^"_Prostate_"^"_ProstateId_"^"_ProstateInfo_"^"_Other
	set tmp = tmp_"^"_PersonRowId

    d json.InsertRowData(tmp)
    s resultString = ""
	Set resultString = json.getJsonData("YearCheckRowId^PersonRowIdParref^PersonName^DateCheck^CheckDoctor^Symptom^Temperature^Pulse^Breath^nHighPressure^nLowPressure^Weight^Height^BMI^WaistlineStern^OlderCongnize^OlderCongnizeId^OlderCongnizeScore^OlderSensibility^OlderSensibilityId^OlderSensibilityScore^LiveQuality^LeftEyesight^RightEyesight^LeftCorrectEyesight^RightCorrectEyesight^Hearing^HearingId^Movement^MovementId^Skin^SkinId^Scrofula^ScrofulaId^ScrofulaOther^bBarrelChest^bBarrelChestId^BreathSounds^BreathSoundsInfo^Rale^RaleInfo^HeartRate^CardiacRhythm^CardiacRhythmId^Souffle^SouffleInfo^Tenderness^TendernessInfo^EnclosedMass^EnclosedMassInfo^Hepatauxe^HepatauxeInfo^Splenomegaly^SplenomegalyInfo^ShiftingDullness^ShiftingDullnessInfo^EdemaOfLimbs^EdemaOfLimbsId^Anus^AnusId^AnusOther^Prostate^ProstateId^ProstateInfo^Other^PersonRowId",count)
	k json	
	Quit resultString
}

ClassMethod ListByCheckRecord(CheckRowId, start As %Integer, limit As %Integer) As %String
{
	q:(CheckRowId="") ""
	s count = 1
	Set json  = ##class(Code.JsonObj).%New()
	Set CheckRowId = $G( CheckRowId )
	s tempCheck = ""
	Set tempCheck = ##class(CHSS.PersonYearCheckRecord).%OpenId(CheckRowId)
	
	set YearCheckRowId = CheckRowId
	set LeftEyesight = tempCheck.LeftEyesight  //左眼视力
	set RightEyesight = tempCheck.RightEyesight  //右眼视力
	set LeftCorrectEyesight = tempCheck.LeftCorrectEyesight  //纠正左眼视力
	set RightCorrectEyesight = tempCheck.RightCorrectEyesight  //纠正右眼视力

	set Hearing = ""  //听力
	set HearingId = ""
	if tempCheck.Hearing '= "" do
		.set Hearing = tempCheck.Hearing.Description
		.set HearingId = tempCheck.Hearing.%Id()

	set Movement = ""  //运动功能
	set MovementId = ""
	if tempCheck.Movement '= "" do
		.set Movement = tempCheck.Movement.Description
		.set MovementId = tempCheck.Movement.%Id()

	set Skin = ""   //皮肤
	set SkinId = ""
	if tempCheck.Skin '= "" do
		.set Skin = tempCheck.Skin.Description
		.set SkinId = tempCheck.Skin.%Id()

	set Scrofula = ""   //淋巴结
	set ScrofulaId = ""
	if tempCheck.Scrofula '= "" do
		.set Scrofula = tempCheck.Scrofula.Description
		.set ScrofulaId = tempCheck.Scrofula.%Id()		
		
	set ScrofulaOther = tempCheck.ScrofulaOther   //淋巴结其他

	set bBarrelChest = ""   //胸状态
	set bBarrelChestId = ""
	if tempCheck.bBarrelChest '= "" do
		.set bBarrelChest = tempCheck.bBarrelChest.Description
		.set bBarrelChestId = tempCheck.bBarrelChest.%Id()	
			
	set BreathSounds = tempCheck.BreathSounds    //呼吸音正常
	set BreathSoundsInfo = tempCheck.BreathSoundsInfo    //呼吸音异常
		
	s Rale = ""   //罗音   
	s RaleId = ""
	i tempCheck.Rale '= "" d
		.s Rale = tempCheck.Rale.Description
		.s RaleId = tempCheck.Rale.%Id()
		
	set RaleInfo = tempCheck.RaleInfo   //其他
	set HeartRate = tempCheck.HeartRate  //心率(次/分钟)

	set CardiacRhythm = ""  //心律
	set CardiacRhythmId = ""
	if tempCheck.CardiacRhythm '= "" do
		.set CardiacRhythm =   tempCheck.CardiacRhythm.Description
		.set CardiacRhythmId = tempCheck.CardiacRhythm.%Id()

	set Souffle = tempCheck.Souffle  //杂音
	set SouffleInfo = tempCheck.SouffleInfo  //杂音异常
	set Tenderness = tempCheck.Tenderness  //压痛
	set TendernessInfo =  tempCheck.TendernessInfo  //压痛情况
	set EnclosedMass =   tempCheck.EnclosedMass  //包块
	set EnclosedMassInfo = tempCheck.EnclosedMassInfo  //包块情况

	
	set Hepatauxe = tempCheck.Hepatauxe  //肝大
	set HepatauxeInfo = tempCheck.HepatauxeInfo  //肝大情况
	set Splenomegaly =  tempCheck.Splenomegaly  //脾大
	set SplenomegalyInfo =  tempCheck.SplenomegalyInfo  //脾大情况
	set ShiftingDullness = tempCheck.ShiftingDullness  //移动性浊音
	set ShiftingDullnessInfo = tempCheck.ShiftingDullnessInfo  //移动性浊音情况

	set EdemaOfLimbs = ""  //下肢水肿
	set EdemaOfLimbsId = ""
	if tempCheck.EdemaOfLimbs '= "" do
		.set EdemaOfLimbs = tempCheck.EdemaOfLimbs.Description
		.set EdemaOfLimbsId = tempCheck.EdemaOfLimbs.%Id()

	set Anus = ""    //肛门
	set AnusId = ""
	if tempCheck.EdemaOfLimbs '= "" do
		.set Anus = tempCheck.Anus.Description
		.set AnusId = tempCheck.Anus.%Id()

	set AnusOther = tempCheck.AnusOther  //肛门其他

	set Prostate = ""    //前列腺
	set ProstateId = ""
	if tempCheck.Prostate '= "" do
		.set Prostate = tempCheck.Prostate.Description
		.set ProstateId = tempCheck.Prostate.%Id()
		
	Set ProstateInfo = tempCheck.ProstateInfo  //前列腺情况
	Set Other = tempCheck.Other  //其他
	set PersonRowId = tempCheck.PersonRowIdParref.%Id()  //PersonRowId
			
	s OralLips = ""    //口唇
	s OralLipsId = ""
	i tempCheck.OralLips '= "" d  
		.s OralLips=tempCheck.OralLips.Description
		.s OralLipsId=tempCheck.OralLips.%Id()
		
	s Dentition = ""  //齿列
	s DentitionId = ""
	i tempCheck.Dentition '= "" d
		.s Dentition = tempCheck.Dentition.Description
		.s DentitionId = tempCheck.Dentition.%Id()
			
	s PharyngealCheck = ""  //咽部
	s PharyngealCheckId = ""
	i tempCheck.PharyngealCheck '= "" d
		.s PharyngealCheck = tempCheck.PharyngealCheck.Description
		.s PharyngealCheckId = tempCheck.PharyngealCheck.%Id()			
		
	s Sclera = ""  //巩膜
	s ScleraId = ""
	i tempCheck.Sclera '= "" d  
		.s Sclera=tempCheck.Sclera.Description
		.s ScleraId=tempCheck.Sclera.%Id()
		
	s VaginaInflammation = ""  //外阴
	s VaginaInflammationId = ""
	i tempCheck.VaginaInflammation '= "" d 
		.s VaginaInflammation=tempCheck.VaginaInflammation.Description
		.s VaginaInflammationId=tempCheck.VaginaInflammation.%Id()
		
	set VaginaInflammationDes = tempCheck.VaginaInflammationDes  //外阴异常情况
	
	s Cervicitis = ""  //宫颈
	s CervicitisId = ""			
	i tempCheck.Cervicitis '= "" d  
		.s Cervicitis=tempCheck.Cervicitis.Description
		.s CervicitisId=tempCheck.Cervicitis.%Id()
		
	set CervicitisDes = tempCheck.CervicitisDes  //宫颈异常情况

	s DoubleWombs = ""  //阴道
	s DoubleWombsId = ""				
	i tempCheck.DoubleWombs '= "" d  
		.s DoubleWombs=tempCheck.DoubleWombs.Description
		.s DoubleWombsId=tempCheck.DoubleWombs.%Id()
		
	set DoubleWombsDes = tempCheck.DoubleWombsDes  //阴道异常情况

	s UterineFibroids = ""  //宫体
	s UterineFibroidsId = ""				
	i tempCheck.UterineFibroids '= "" d 
		.s UterineFibroids=tempCheck.UterineFibroids.Description
		.s UterineFibroidsId=tempCheck.UterineFibroids.%Id()
		
	set UterineFibroidsDes = tempCheck.UterineFibroidsDes  //宫体异常情况

	s AccessaryTumour = ""  //附件
	s AccessaryTumourId = ""				
	i tempCheck.AccessaryTumour '= "" d  
		.s AccessaryTumour=tempCheck.AccessaryTumour.Description
		.s AccessaryTumourId=tempCheck.AccessaryTumour.%Id()
	
	set AccessaryTumourDes = tempCheck.AccessaryTumourDes  //附件异常情况
	set Galactophore = tempCheck.Galactophore  //乳腺
	
	Set tmp= ""
	Set tmp = YearCheckRowId_"^"_LeftEyesight_"^"_RightEyesight_"^"_LeftCorrectEyesight_"^"_RightCorrectEyesight_"^"_Hearing_"^"_HearingId_"^"_Movement_"^"_MovementId_"^"_Skin_"^"_SkinId_"^"_Scrofula_"^"_ScrofulaId_"^"_ScrofulaOther_"^"_bBarrelChest_"^"_bBarrelChestId_"^"_BreathSounds_"^"_BreathSoundsInfo_"^"_Rale_"^"_RaleId_"^"_RaleInfo_"^"_HeartRate_"^"_CardiacRhythm_"^"_CardiacRhythmId_"^"_Souffle_"^"_SouffleInfo_"^"_Tenderness_"^"_TendernessInfo_"^"_EnclosedMass_"^"_EnclosedMassInfo_"^"_Hepatauxe_"^"_HepatauxeInfo_"^"_Splenomegaly_"^"_SplenomegalyInfo_"^"_ShiftingDullness_"^"_ShiftingDullnessInfo_"^"_EdemaOfLimbs_"^"_EdemaOfLimbsId_"^"_Anus_"^"_AnusId_"^"_AnusOther_"^"_Prostate_"^"_ProstateId_"^"_ProstateInfo_"^"_Other_"^"_PersonRowId_"^"_OralLips_"^"_OralLipsId_"^"_Dentition_"^"_DentitionId_"^"_PharyngealCheck_"^"_PharyngealCheckId_"^"_Sclera_"^"_ScleraId_"^"_VaginaInflammation_"^"_VaginaInflammationId_"^"_VaginaInflammationDes_"^"_Cervicitis_"^"_CervicitisId_"^"_CervicitisDes_"^"_DoubleWombs_"^"_DoubleWombsId_"^"_DoubleWombsDes_"^"_UterineFibroids_"^"_UterineFibroidsId_"^"_UterineFibroidsDes_"^"_AccessaryTumour_"^"_AccessaryTumourId_"^"_AccessaryTumourDes_"^"_Galactophore

    d json.InsertRowData(tmp)
    s resultString = ""
	Set resultString = json.getJsonData("YearCheckRowId^LeftEyesight^RightEyesight^LeftCorrectEyesight^RightCorrectEyesight^Hearing^HearingId^Movement^MovementId^Skin^SkinId^Scrofula^ScrofulaId^ScrofulaOther^bBarrelChest^bBarrelChestId^BreathSounds^BreathSoundsInfo^Rale^RaleId^RaleInfo^HeartRate^CardiacRhythm^CardiacRhythmId^Souffle^SouffleInfo^Tenderness^TendernessInfo^EnclosedMass^EnclosedMassInfo^Hepatauxe^HepatauxeInfo^Splenomegaly^SplenomegalyInfo^ShiftingDullness^ShiftingDullnessInfo^EdemaOfLimbs^EdemaOfLimbsId^Anus^AnusId^AnusOther^Prostate^ProstateId^ProstateInfo^Other^PersonRowId^OralLips^OralLipsId^Dentition^DentitionId^PharyngealCheck^PharyngealCheckId^Sclera^ScleraId^VaginaInflammation^VaginaInflammationId^VaginaInflammationDes^Cervicitis^CervicitisId^CervicitisDes^DoubleWombs^DoubleWombsId^DoubleWombsDes^UterineFibroids^UterineFibroidsId^UterineFibroidsDes^AccessaryTumour^AccessaryTumourId^AccessaryTumourDes^Galactophore",count)
	k json
	Quit resultString
}

ClassMethod CheckSearch(communityCode As %String, PersonCode As %String, PersonName As %String, DateCheck As %Date, CheckDoctor As %String, start As %Integer, limit As %Integer) As %String
{
	 
	q:(communityCode="") ""
	Set start = $G( start )
	Set limit = $G( limit )	
	Set end   = start + limit 
	Set count = 0
	s json  = ##class(Code.JsonObj).%New()
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select * from CHSS.PersonYearCheckRecord where PersonRowIdParref->CommunityCode = '"_communityCode_"'"
	
	if PersonCode '= "" d
		.s sqlStr = sqlStr_" and PersonRowIdParref->PersonCode like '%"_PersonCode_"%'"
	if PersonName '= "" d
		.s sqlStr = sqlStr_" and PersonRowIdParref->PersonName like '%"_PersonName_"%'"
	if DateCheck '= "" d
		.s DateCheck = $zdh(DateCheck,3)
		.s sqlStr = sqlStr_" and DateCheck='"_DateCheck_"'"
	if CheckDoctor '= "" d
		.s sqlStr = sqlStr_" and CheckDoctor like '%"_CheckDoctor_"%'"	
	d result.Prepare(sqlStr)
	d result.Execute()
	;w sqlStr
	While(result.Next())
	{
		set CheckRowId = result.Get("YearCheckRowId")	
		Set tempCheck = ##class(CHSS.PersonYearCheckRecord).%OpenId(CheckRowId)

		Set DateCheck = tempCheck.DateCheck

		i DateCheck '= "" d
			.Set DateCheck = $zd(DateCheck,3)
		
		Set CheckDoctor = tempCheck.CheckDoctor
		Set Symptom = tempCheck.Symptom
		Set Temperature = tempCheck.Temperature
		Set Pulse =  tempCheck.Pulse
		Set Breath = tempCheck.Breath
		Set nHighPressure = tempCheck.nHighPressure
		Set nLowPressure =  tempCheck.nLowPressure
		Set Weight =  tempCheck.Weight
		Set Height =  tempCheck.Height
		Set BMI =   tempCheck.BMI
		Set WaistlineStern = tempCheck.WaistlineStern
	
		Set OlderCongnize = ""
		Set OlderCongnizeId = ""
		if tempCheck.OlderCongnize '= "" do
			.Set OlderCongnize = tempCheck.OlderCongnize.Description
			.Set OlderCongnizeId = tempCheck.OlderCongnize.%Id()
	
		Set OlderCongnizeScore = tempCheck.OlderCongnizeScore
	
		Set OlderSensibility = ""
		Set OlderSensibilityId = ""
		if tempCheck.OlderSensibility '= "" do
			.Set OlderSensibility = tempCheck.OlderSensibility.Description
			.Set OlderSensibilityId = tempCheck.OlderSensibility.%Id()
	
		Set OlderSensibilityScore = tempCheck.OlderSensibilityScore
		Set LiveQuality = tempCheck.LiveQuality
		Set LeftEyesight =   tempCheck.LeftEyesight
		Set RightEyesight =  tempCheck.RightEyesight
		Set LeftCorrectEyesight = tempCheck.LeftCorrectEyesight
		Set RightCorrectEyesight = tempCheck.RightCorrectEyesight

		Set Hearing = ""
		Set HearingId = ""
		if tempCheck.Hearing '= "" do
			.Set Hearing = tempCheck.Hearing.Description
			.Set HearingId = tempCheck.Hearing.%Id()
	
		Set Movement = ""
		Set MovementId = ""
		if tempCheck.Movement '= "" do
			.Set Movement = tempCheck.Movement.Description
			.Set MovementId = tempCheck.Movement.%Id()
	
		Set Skin = ""
		Set SkinId = ""
		if tempCheck.Skin '= "" do
			.Set Skin = tempCheck.Skin.Description
			.Set SkinId = tempCheck.Skin.%Id()
	
		Set Scrofula = ""
		Set ScrofulaId = ""
		if tempCheck.Scrofula '= "" do
			.Set Scrofula = tempCheck.Scrofula.Description
			.Set ScrofulaId = tempCheck.Scrofula.%Id()		
	
		Set ScrofulaOther = tempCheck.ScrofulaOther
	
		Set bBarrelChest = ""
		Set bBarrelChestId = ""
		if tempCheck.bBarrelChest '= "" do
			.Set bBarrelChest = tempCheck.bBarrelChest.Description
			.Set bBarrelChestId = tempCheck.bBarrelChest.%Id()	
				
		Set BreathSounds = tempCheck.BreathSounds

		Set BreathSoundsInfo = tempCheck.BreathSoundsInfo
		Set Rale = tempCheck.Rale
		Set RaleInfo = tempCheck.RaleInfo
		Set HeartRate = tempCheck.HeartRate
	
		Set CardiacRhythm = ""
		Set CardiacRhythmId = ""
		if tempCheck.CardiacRhythm '= "" do
			.Set CardiacRhythm =   tempCheck.CardiacRhythm.Description
			.Set CardiacRhythmId = tempCheck.CardiacRhythm.%Id()
	
		Set Souffle = tempCheck.Souffle
		Set SouffleInfo = tempCheck.SouffleInfo
		Set Tenderness = tempCheck.Tenderness
		Set TendernessInfo =  tempCheck.TendernessInfo
		Set EnclosedMass =   tempCheck.EnclosedMass
		Set EnclosedMassInfo = tempCheck.EnclosedMassInfo

		Set Hepatauxe = tempCheck.Hepatauxe
		Set HepatauxeInfo = tempCheck.HepatauxeInfo
		Set Splenomegaly =  tempCheck.Splenomegaly
		Set SplenomegalyInfo =  tempCheck.SplenomegalyInfo
		Set ShiftingDullness = tempCheck.ShiftingDullness
		Set ShiftingDullnessInfo = tempCheck.ShiftingDullnessInfo
	
		Set EdemaOfLimbs = ""
		Set EdemaOfLimbsId = ""
		if tempCheck.EdemaOfLimbs '= "" do
			.Set EdemaOfLimbs = tempCheck.EdemaOfLimbs.Description
			.Set EdemaOfLimbsId = tempCheck.EdemaOfLimbs.%Id()
	
		Set Anus = ""
		Set AnusId = ""
		if tempCheck.Anus '= "" do
			.Set Anus = tempCheck.Anus.Description
			.Set AnusId = tempCheck.Anus.%Id()

		Set AnusOther = tempCheck.AnusOther

		Set Prostate = ""
		Set ProstateId = ""
		if tempCheck.Prostate '= "" do
			.Set Prostate = tempCheck.Prostate.Description
			.Set ProstateId = tempCheck.Prostate.%Id()
	
		Set ProstateInfo = tempCheck.ProstateInfo
		Set PersonCode = tempCheck.PersonRowIdParref.PersonCode
		;##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowId).PersonCode
		Set PersonName = tempCheck.PersonRowIdParref.PersonName
		;##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowId).PersonName
	
		Set Other = tempCheck.Other

		Set tmp= ""
		Set tmp = CheckRowId_"^"_PersonCode_"^"_PersonName_"^"_DateCheck_"^"_CheckDoctor_"^"_Symptom_"^"_Temperature_"^"_Pulse_"^"_Breath_"^"_nHighPressure_"^"_nLowPressure_"^"_Weight_"^"_Height_"^"_BMI_"^"_WaistlineStern_"^"_OlderCongnize_"^"_OlderCongnizeId_"^"_OlderCongnizeScore_"^"_OlderSensibility_"^"_OlderSensibilityId_"^"_OlderSensibilityScore_"^"_LiveQuality_"^"_LeftEyesight_"^"_RightEyesight_"^"_LeftCorrectEyesight_"^"_RightCorrectEyesight_"^"_Hearing_"^"_HearingId_"^"_Movement_"^"_MovementId_"^"_Skin_"^"_SkinId_"^"_Scrofula_"^"_ScrofulaId_"^"_ScrofulaOther_"^"_bBarrelChest_"^"_bBarrelChestId_"^"_BreathSounds_"^"_BreathSoundsInfo_"^"_Rale_"^"_RaleInfo_"^"_HeartRate_"^"_CardiacRhythm_"^"_CardiacRhythmId_"^"_Souffle_"^"_SouffleInfo_"^"_Tenderness_"^"_TendernessInfo_"^"_EnclosedMass_"^"_EnclosedMassInfo_"^"_Hepatauxe_"^"_HepatauxeInfo_"^"_Splenomegaly_"^"_SplenomegalyInfo_"^"_ShiftingDullness_"^"_ShiftingDullnessInfo_"^"_EdemaOfLimbs_"^"_EdemaOfLimbsId_"^"_Anus_"^"_AnusId_"^"_AnusOther_"^"_Prostate_"^"_ProstateId_"^"_ProstateInfo_"^"_Other
		Set count=count+1

		If (count>start)&(count<=end) d
    		.d json.InsertRowData(tmp)
    }	
    s resultString = ""
	Set resultString = json.getJsonData("YearCheckRowId^PersonCode^PersonName^DateCheck^CheckDoctor^Symptom^Temperature^Pulse^Breath^nHighPressure^nLowPressure^Weight^Height^BMI^WaistlineStern^OlderCongnize^OlderCongnizeId^OlderCongnizeScore^OlderSensibility^OlderSensibilityId^OlderSensibilityScore^LiveQuality^LeftEyesight^RightEyesight^LeftCorrectEyesight^RightCorrectEyesight^Hearing^HearingId^Movement^MovementId^Skin^SkinId^Scrofula^ScrofulaId^ScrofulaOther^bBarrelChest^bBarrelChestId^BreathSounds^BreathSoundsInfo^Rale^RaleInfo^HeartRate^CardiacRhythm^CardiacRhythmId^Souffle^SouffleInfo^Tenderness^TendernessInfo^EnclosedMass^EnclosedMassInfo^Hepatauxe^HepatauxeInfo^Splenomegaly^SplenomegalyInfo^ShiftingDullness^ShiftingDullnessInfo^EdemaOfLimbs^EdemaOfLimbsId^Anus^AnusId^AnusOther^Prostate^ProstateId^ProstateInfo^Other",count)
	k json	
	b ;aaa
	Quit resultString
}

ClassMethod GetAge(birthdate As %String) As %Integer
{
  S birth = $zd(birthdate,3)	
  S today = $zd($h,3)
  s age = $E(today,1,4)- $E(birth,1,4)
  S birth = $E(today,1,4)_$E(birth,5,10)
  i ($zdh(birth,3)-$h>0) d
  .s age=age-1  
  i age=-1 d
  .s age=0
  q age
}

ClassMethod BaseInsert(PersonRowIdParref As %String, DateCheck As %Date, CheckDoctor As %String, Symptom As %String, Temperature As %Float, Pulse As %Integer, Breath As %Integer, nHighPressure As %Integer, nLowPressure As %Integer, Height As %Float, Weight As %Float, BMI As %Float, WaistlineStern As %Float, OlderCongnizeId As %String, OlderCongnizeScore As %String, OlderSensibilityId As %String, LiveQuality As %String, OlderSensibilityScore As %String, LeftEyesight As %Float, RightEyesight As %Float, LeftCorrectEyesight As %Float, RightCorrectEyesight As %Float, HearingId As %String, MovementId As %String, SkinId As %String, ScrofulaId As %String, ScrofulaOther As %String, bBarrelChestId As %String, BreathSounds As %String, BreathSoundsInfo As %String, Rale As %String, RaleInfo As %String, HeartRate As %String, CardiacRhythmId As %String, Souffle As %String, SouffleInfo As %String, Tenderness As %String, TendernessInfo As %String, EnclosedMass As %String, EnclosedMassInfo As %String, Hepatauxe As %String, HepatauxeInfo As %String, Splenomegaly As %String, SplenomegalyInfo As %String, ShiftingDullness As %String, ShiftingDullnessInfo As %String, EdemaOfLimbsId As %String, AnusId As %String, AnusOther As %String, ProstateId As %String, ProstateInfo As %String, Other As %String, Waist As %Float, Saddle As %Float) As %String
{
	Set tempCheck = ""
	Set tempCheck = ##class(CHSS.PersonYearCheckRecord).%New()
	q:(tempCheck = "" ) 0
	
	Set ReturnId = ..existPersonRowId(PersonRowIdParref)
	
	i (ReturnId'="0") d
	.w "{""success"":""false"",""info"":""个人编码: "_ReturnId_" 已存在! 请重新输入!""}"
	e  d
	.Set tempCheck.PersonRowIdParref = ##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowIdParref)
	
	.i DateCheck '= "" do
	..Set tempCheck.DateCheck = $zdh(DateCheck,3)
	.Set tempCheck.CheckDoctor = CheckDoctor
	.Set tempCheck.Symptom = Symptom
	.Set tempCheck.Temperature = Temperature
	.Set tempCheck.Pulse = Pulse
	.Set tempCheck.Breath  = Breath 
	.Set tempCheck.nHighPressure = nHighPressure
	.Set tempCheck.nLowPressure = nLowPressure
	.Set tempCheck.Height  = Height 
	.Set tempCheck.Weight = Weight
	.Set tempCheck.BMI  = BMI
	.Set tempCheck.WaistlineStern  = WaistlineStern
	.Set tempCheck.OlderCongnize = ##class(CHSS.DictCognitiveAbility).%OpenId(OlderCongnizeId)
	.Set tempCheck.OlderCongnizeScore  = OlderCongnizeScore 
	.Set tempCheck.OlderSensibility  = ##class(CHSS.DictAffectiveState).%OpenId(OlderSensibilityId) 
	.Set tempCheck.OlderSensibilityScore  = OlderSensibilityScore 
	.
	.
	.Set tempCheck.Waist = Waist
	.Set tempCheck.Saddle = Saddle
	.Set tempCheck.HeartRate  = HeartRate 
	.s result=""
    .s result=tempCheck.%Save()
    .s YearCheckRowIdParref = tempCheck.%Id()
    .i result = "1" d
    ..w "{""success"":""true"",""info"":"_tempCheck.%Id()_"}"
    ..&SQL(insert into CHSS.PersonLifeStyle (YearCheckRowIdParref,PersonRowIdParref) values (:YearCheckRowIdParref,:PersonRowIdParref))
    ..w ##class(CHSSWeb.PersonHealthAppraiseService).insert(PersonRowIdParref,YearCheckRowIdParref)
    .e  d
    ..w "{""success"":""false"",""info"":""数据保存出错!""}"
    q ""
    /*
	.Set tempCheck.Dentition = ##class(CHSS.DictDentition).%OpenId(DentitionId)
	.Set tempCheck.PharyngealCheck  = PharyngealCheck 
	.Set tempCheck.WaistlineStern  = WaistlineStern 	
	.Set tempCheck.LiveQuality  = LiveQuality  
	     
	
	.if BookingDate '= "" d
	..Set BookingDate  = $zdh(BookingDate ,3) 
	.Set tempCheck.BookingDate = BookingDate
	
	.Set tempCheck.bBooking      = bBooking     
	.Set tempCheck.BloodSurgeLimosis     = BloodSurgeLimosis   
	.Set tempCheck.Cholesterin      = Cholesterin 
	 
	.Set tempCheck.MentalityAdjust    = MentalityAdjust  
	.Set tempCheck.CheckResult     = CheckResult   
	.Set tempCheck.Deal    = Deal   
	.Set tempCheck.StaffInput     = ##class(User.SSUser).%OpenId(StaffInputId)    
	.Set tempCheck.Other    = Other    
	*/
}

ClassMethod BaseUpdate(CheckRecordId As %String, PersonRowIdParref As %String, DateCheck As %Date, CheckDoctor As %String, Symptom As %String, Temperature As %Float, Pulse As %Integer, Breath As %Integer, nHighPressure As %Integer, nLowPressure As %Integer, Height As %Float, Weight As %Float, BMI As %Float, WaistlineStern As %Float, OlderCongnizeId As %String, OlderCongnizeScore As %String, OlderSensibilityId As %String, OlderSensibilityScore As %String, LiveQuality As %String, LeftEyesight As %Float, RightEyesight As %Float, LeftCorrectEyesight As %Float, RightCorrectEyesight As %Float, HearingId As %String, MovementId As %String, SkinId As %String, ScrofulaId As %String, ScrofulaOther As %String, bBarrelChestId As %String, BreathSounds As %String, BreathSoundsInfo As %String, Rale As %String, RaleInfo As %String, HeartRate As %String, CardiacRhythmId As %String, Souffle As %String, SouffleInfo As %String, Tenderness As %String, TendernessInfo As %String, EnclosedMass As %String, EnclosedMassInfo As %String, Hepatauxe As %String, HepatauxeInfo As %String, Splenomegaly As %String, SplenomegalyInfo As %String, ShiftingDullness As %String, ShiftingDullnessInfo As %String, EdemaOfLimbsId As %String, AnusId As %String, AnusOther As %String, ProstateId As %String, ProstateInfo As %String, Other As %String, Waist As %Float, Saddle As %Float) As %String
{
	q:($d(CheckRecordId)=0)||(CheckRecordId="")
	//q:($d(PersonRowIdParrefId)=0)||(PersonRowIdParrefId="")
	Set tempCheck = ""
	
	Set tempCheck = ##class(CHSS.PersonYearCheckRecord).%OpenId(CheckRecordId)

	q:(tempCheck = "" ) 0
	
	Set tempCheck.PersonRowIdParref = ##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowIdParref)
	i DateCheck '= "" do
	.Set tempCheck.DateCheck = $zdh(DateCheck,3)
	Set tempCheck.CheckDoctor = CheckDoctor
	Set tempCheck.Symptom = Symptom
	Set tempCheck.Temperature = Temperature
	Set tempCheck.Pulse = Pulse
	Set tempCheck.Breath  = Breath 
	Set tempCheck.nHighPressure = nHighPressure
	Set tempCheck.nLowPressure = nLowPressure
	Set tempCheck.Height  = Height 
	Set tempCheck.Weight = Weight
	Set tempCheck.BMI  = BMI
	Set tempCheck.Waist = Waist
	Set tempCheck.Saddle = Saddle
	Set tempCheck.WaistlineStern  = WaistlineStern
	Set tempCheck.OlderCongnize = ##class(CHSS.DictCognitiveAbility).%OpenId(OlderCongnizeId)
	Set tempCheck.OlderCongnizeScore  = OlderCongnizeScore 
	Set tempCheck.OlderSensibility  = ##class(CHSS.DictAffectiveState).%OpenId(OlderSensibilityId) 
	Set tempCheck.OlderSensibilityScore  = OlderSensibilityScore
	Set tempCheck.LiveQuality = LiveQuality
	Set tempCheck.HeartRate  = HeartRate 
	s result=""
    s result=tempCheck.%Save()
    i result = "1" d
    .w "{""success"":""true"",""info"":"_tempCheck.%Id()_"}"
    e  d
    .w "{""success"":""false"",""info"":""数据保存出错!""}"
    
    q ""
}

Storage Default
{
<Data name="PYCRServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.PYCRServiceD</DataLocation>
<DefaultData>PYCRServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.PYCRServiceD</IdLocation>
<IndexLocation>^CHSSWeb.PYCRServiceI</IndexLocation>
<StreamLocation>^CHSSWeb.PYCRServiceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
