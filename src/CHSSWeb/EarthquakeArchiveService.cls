Class CHSSWeb.EarthquakeArchiveService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// Creator: lyy
/// CreatDate：2009-08-26
/// Description: 地震档案
/// Table：EarthquakeArchive
/// Input: EarthquakeArchive
/// Output：
/// Return：
/// Others：
ClassMethod List(CommunityCode As %String, start As %Integer, limit As %Integer, sort As %String) As %String
{
      Set CommunityCode=$G(CommunityCode)
      Set CommunityCode=" "_CommunityCode
      Set start=$G(start)
      Set limit=$G(limit)
      Set sort=$G(sort)
      Set count=0
      Set resultString = ""
      Set end = start+limit
      Set json = ##class(Code.JsonObj).%New()
      set RowId = 0
      Set tmp = ""
      
      
      
      For  Set RowId=$O(^CHSS.EarthquakeArchiveI("CommunityCodeIndex",CommunityCode,RowId)) q:RowId=""  d
      .
      
      .s tempEarthquakeArchive=##class(CHSS.EarthquakeArchive).%OpenId(RowId)
            
           
      ./// 地震前1年气候条件
      .
      .s RainBef = tempEarthquakeArchive.RainBef
      .s AirHumidityBef = tempEarthquakeArchive.AirHumidityBef
      .s AverageTemperatureBef = tempEarthquakeArchive.AverageTemperatureBef
      .s AirPollutionIndexBef = tempEarthquakeArchive.AirPollutionIndexBef
      
      
      ./// 地震后1年气候条件
      .
      .s RainAfter = tempEarthquakeArchive.RainAfter
      .s AirHumidityAfter = tempEarthquakeArchive.AirHumidityAfter
      .s AverageTemperAfter = tempEarthquakeArchive.AverageTemperAfter
      .s AirPollutionIndexAfter = tempEarthquakeArchive.AirPollutionIndexAfter
      
      ./// 地震前3年（2005~2007）交通建设
      .
      .s TrafficInvest07 = tempEarthquakeArchive.TrafficInvest07
      .s HighwayMileage07 = tempEarthquakeArchive.HighwayMileage07
      .s SuperHighway07 = tempEarthquakeArchive.SuperHighway07
      .s FirstClass07 = tempEarthquakeArchive.FirstClass07
      .s VillageHaveHighway07 = tempEarthquakeArchive.VillageHaveHighway07
      
      
      ./// 地震后交通建设
      .
      .s HighwayMileageAfter = tempEarthquakeArchive.HighwayMileageAfter
      .s SuperHighwayAfter = tempEarthquakeArchive.SuperHighwayAfter
      .s FirstClassAfter = tempEarthquakeArchive.FirstClassAfter
      .s VillageHaveHighwayAfter = tempEarthquakeArchive.VillageHaveHighwayAfter
      
      
      ./// 地震前通信建设及广播电视覆盖情况
      .
      .s Communication07 = tempEarthquakeArchive.Communication07
      .s FixedTelphone07 = tempEarthquakeArchive.FixedTelphone07
      .s MobilePhone07 = tempEarthquakeArchive.MobilePhone07
      .s Broadcast07 = tempEarthquakeArchive.Broadcast07
      .s TV2007 = tempEarthquakeArchive.TV2007
      
      
      ./// 地震后通信受损情况
      .
      .s bCommImpairment = tempEarthquakeArchive.bCommImpairment
      .s TimeOfCommDisruption = tempEarthquakeArchive.TimeOfCommDisruption
      
      
      ./// 地震前卫生资源基本情况
      .
      .s HealthCareInvest07 = tempEarthquakeArchive.HealthCareInvest07
      .s AllBedNum07 = tempEarthquakeArchive.AllBedNum07
      .s MedicalPersonnel07 = tempEarthquakeArchive.MedicalPersonnel07
      .s Doctor07 = tempEarthquakeArchive.Doctor07
      .s Nurse07 = tempEarthquakeArchive.Nurse07
      .s OtherMedicalPersonel07 = tempEarthquakeArchive.OtherMedicalPersonel07
      .s CollNum07 = tempEarthquakeArchive.CollNum07
      .s MiddleTitelNum07 = tempEarthquakeArchive.MiddleTitelNum07
      
      .s TechnicalSecNum07 = tempEarthquakeArchive.TechnicalSecNum07
      .s DoctorNumOfVillage07 = tempEarthquakeArchive.DoctorNumOfVillage07
      .s DoctorNumHaveCer07 = tempEarthquakeArchive.DoctorNumHaveCer07
      .s PrimarySchLevelNum07 = tempEarthquakeArchive.PrimarySchLevelNum07
      .s JuniorMiddleLevelNum07 = tempEarthquakeArchive.JuniorMiddleLevelNum07
      .s EducationalLevelNum07 = tempEarthquakeArchive.EducationalLevelNum07
      
      
      ./// 地震后2008年底卫生资源情况
      .
      .s HealthCareInvest08 = tempEarthquakeArchive.HealthCareInvest08
      .s AllBedNum2008 = tempEarthquakeArchive.AllBedNum2008
      .s MedicalPersonnel08 = tempEarthquakeArchive.MedicalPersonnel08
      .s Doctor2008 = tempEarthquakeArchive.Doctor2008
      .s Nurse2008 = tempEarthquakeArchive.Nurse2008
      .s OtherMedicalPersonel08 = tempEarthquakeArchive.OtherMedicalPersonel08
      .s CollNum2008 = tempEarthquakeArchive.CollNum2008
      .s MiddleTitelNum08 = tempEarthquakeArchive.MiddleTitelNum08
      
      .s TechnicalSecNum08 = tempEarthquakeArchive.TechnicalSecNum08
      .s DoctorNumOfVillage08 = tempEarthquakeArchive.DoctorNumOfVillage08
      .s DoctorNumHaveCer08 = tempEarthquakeArchive.DoctorNumHaveCer08
      .s PrimarySchLevelNum08 = tempEarthquakeArchive.PrimarySchLevelNum08
      .s JuniorMiddleLevelNum08 = tempEarthquakeArchive.JuniorMiddleLevelNum08
      .s EducationalLevelNum08 = tempEarthquakeArchive.EducationalLevelNum08
      
      
      ./// 地震损失情况
      .
      .s DisasterAffectedNum = tempEarthquakeArchive.DisasterAffectedNum
      .s DeathInEQ = tempEarthquakeArchive.DeathInEQ
      .s DamageInEQ = tempEarthquakeArchive.DamageInEQ
      .s HouseDestroyedNum = tempEarthquakeArchive.HouseDestroyedNum
      .s HouseDestroyedArea = tempEarthquakeArchive.HouseDestroyedArea
      .s DeathOfMedicalPersonel = tempEarthquakeArchive.DeathOfMedicalPersonel
      .s DamageOfMedicalPersonel = tempEarthquakeArchive.DamageOfMedicalPersonel
      .s LossOfEquipment = tempEarthquakeArchive.LossOfEquipment
      .s CurMedicalPersonel = tempEarthquakeArchive.CurMedicalPersonel

      .set HousingDamageName = ""
      .set HousingDamage = ""
      .i tempEarthquakeArchive.HousingDamage '= "" d
      ..s HousingDamage = tempEarthquakeArchive.HousingDamage.%Id()
      ..s HousingDamageName = tempEarthquakeArchive.HousingDamage.Description

      .s CurHousing = tempEarthquakeArchive.CurHousing
      .s bBreakToCountry = tempEarthquakeArchive.bBreakToCountry
      .s BreakDays = tempEarthquakeArchive.BreakDays
      .s bTBFreeBreak = tempEarthquakeArchive.bTBFreeBreak
      .s TBFreeBreakDays = tempEarthquakeArchive.TBFreeBreakDays
      .s WaterBreakDays = tempEarthquakeArchive.WaterBreakDays
      .s FoodBreakDays = tempEarthquakeArchive.FoodBreakDays
      .s CommunicationBreakDays = tempEarthquakeArchive.CommunicationBreakDays


      ./// 地形地貌
      .
      .set LandformName = ""
      .set Landform = ""
      .i tempEarthquakeArchive.Landform '= "" d
      ..s Landform = tempEarthquakeArchive.Landform.%Id()
      ..s LandformName = tempEarthquakeArchive.Landform.Description
      
      
      ./// 劳动力及收入
      .
      .s TotalHousehold07 = tempEarthquakeArchive.TotalHousehold07
      .s LabourForce07 = tempEarthquakeArchive.LabourForce07
      .s RegisteredJoblessRate07 = tempEarthquakeArchive.RegisteredJoblessRate07
      .s OutWork07 = tempEarthquakeArchive.OutWork07
      .s InWork07 = tempEarthquakeArchive.InWork07
      .s TotalHousehold08 = tempEarthquakeArchive.TotalHousehold08
      .s LabourForce08 = tempEarthquakeArchive.LabourForce08
      .s RegisteredJoblessRate08 = tempEarthquakeArchive.RegisteredJoblessRate08
      .s OutWork2008 = tempEarthquakeArchive.OutWork2008
      .s InWork2008 = tempEarthquakeArchive.InWork2008
      
      
      ./// 基本教育情况
      .
      .s EducationInvest07 = tempEarthquakeArchive.EducationInvest07
      .s TeacherNum07 = tempEarthquakeArchive.TeacherNum07
      .s UntaughtTeacher07 = tempEarthquakeArchive.UntaughtTeacher07
      .s PrimaryTeacher07 = tempEarthquakeArchive.PrimaryTeacher07
      .s EducationalTeacher07 = tempEarthquakeArchive.EducationalTeacher07
      .s CollTeacher07 = tempEarthquakeArchive.CollTeacher07
      .s EducationInvest08 = tempEarthquakeArchive.EducationInvest08
      .s TeacherNum08 = tempEarthquakeArchive.TeacherNum08
      .s UntaughtTeacher08 = tempEarthquakeArchive.UntaughtTeacher08
      .s PrimaryTeacher08 = tempEarthquakeArchive.PrimaryTeacher08
      .s EducationlTeacher08 = tempEarthquakeArchive.EducationlTeacher08
      .s CollTeacher08 = tempEarthquakeArchive.CollTeacher08
      
      
      ./// 本次填表情况
      .
      .set DateInput = tempEarthquakeArchive.DateInput 
      .i DateInput '= "" d
      ..s DateInput = $zd(DateInput ,3)

      .set OperatorInputName = ""
      .set OperatorInput = ""
      .i tempEarthquakeArchive.OperatorInput '= "" d
      ..s OperatorInput = tempEarthquakeArchive.OperatorInput.%Id()
      ..s OperatorInputName = tempEarthquakeArchive.OperatorInput.SSUSRName


      ./// 基本信息
      .
      .s Area = tempEarthquakeArchive.Area
      .s PopulationBefore = tempEarthquakeArchive.PopulationBefore
      .s PopuDensityBefore = tempEarthquakeArchive.PopuDensityBefore
      .s URB = tempEarthquakeArchive.URB
      
      
      ./// 地震信息
      .
      .s SeismicIntensity = tempEarthquakeArchive.SeismicIntensity
      .s EqAcceler = tempEarthquakeArchive.EqAcceler
      .s Scale25 = tempEarthquakeArchive.Scale25
      
      .s RoadDamageScale = tempEarthquakeArchive.RoadDamageScale
      
  
      ./// 地震损失情况
      .
      .s MissingNum = tempEarthquakeArchive.MissingNum
      .s EqDeathNum = tempEarthquakeArchive.EqDeathNum
      .s EqHurtNum = tempEarthquakeArchive.EqHurtNum
      .s HouseCollapse = tempEarthquakeArchive.HouseCollapse
      
            
      ./// 劳动力及收入
      .
      .s PerIncome2007 = tempEarthquakeArchive.PerIncome2007
      .s PerIncome2008 = tempEarthquakeArchive.PerIncome2008

           
      .Set tmp = RowId_"^"_RainBef_"^"_AirHumidityBef_"^"_AverageTemperatureBef_"^"_AirPollutionIndexBef_"^"_RainAfter_"^"_AirHumidityAfter_"^"_AverageTemperAfter_"^"_AirPollutionIndexAfter_"^"_TrafficInvest07_"^"_HighwayMileage07_"^"_SuperHighway07_"^"_FirstClass07_"^"_VillageHaveHighway07_"^"_HighwayMileageAfter_"^"_SuperHighwayAfter_"^"_FirstClassAfter_"^"_VillageHaveHighwayAfter_"^"_Communication07_"^"_FixedTelphone07_"^"_MobilePhone07_"^"_Broadcast07_"^"_TV2007_"^"_bCommImpairment_"^"_TimeOfCommDisruption_"^"_HealthCareInvest07_"^"_AllBedNum07_"^"_MedicalPersonnel07_"^"_Doctor07_"^"_Nurse07_"^"_OtherMedicalPersonel07_"^"_CollNum07_"^"_MiddleTitelNum07_"^"_TechnicalSecNum07_"^"_DoctorNumOfVillage07_"^"_DoctorNumHaveCer07_"^"_PrimarySchLevelNum07_"^"_JuniorMiddleLevelNum07_"^"_EducationalLevelNum07_"^"_HealthCareInvest08_"^"_AllBedNum2008_"^"_MedicalPersonnel08_"^"_Doctor2008_"^"_Nurse2008_"^"_OtherMedicalPersonel08_"^"_CollNum2008_"^"_MiddleTitelNum08_"^"_TechnicalSecNum08_"^"_DoctorNumOfVillage08_"^"_DoctorNumHaveCer08_"^"_PrimarySchLevelNum08_"^"_JuniorMiddleLevelNum08_"^"_EducationalLevelNum08_"^"_DisasterAffectedNum_"^"_DeathInEQ_"^"_DamageInEQ_"^"_HouseDestroyedNum_"^"_HouseDestroyedArea_"^"_DeathOfMedicalPersonel_"^"_DamageOfMedicalPersonel_"^"_LossOfEquipment_"^"_CurMedicalPersonel_"^"_HousingDamage_"^"_HousingDamageName_"^"_CurHousing_"^"_bBreakToCountry_"^"_BreakDays_"^"_bTBFreeBreak_"^"_TBFreeBreakDays_"^"_WaterBreakDays_"^"_FoodBreakDays_"^"_CommunicationBreakDays_"^"_Landform_"^"_LandformName_"^"_TotalHousehold07_"^"_LabourForce07_"^"_RegisteredJoblessRate07_"^"_OutWork07_"^"_InWork07_"^"_TotalHousehold08_"^"_LabourForce08_"^"_RegisteredJoblessRate08_"^"_OutWork2008_"^"_InWork2008_"^"_EducationInvest07_"^"_TeacherNum07_"^"_UntaughtTeacher07_"^"_PrimaryTeacher07_"^"_EducationalTeacher07_"^"_CollTeacher07_"^"_EducationInvest08_"^"_TeacherNum08_"^"_UntaughtTeacher08_"^"_PrimaryTeacher08_"^"_EducationlTeacher08_"^"_CollTeacher08_"^"_DateInput_"^"_OperatorInput_"^"_OperatorInputName_"^"_Area_"^"_PopulationBefore_"^"_PopuDensityBefore_"^"_URB_"^"_SeismicIntensity_"^"_EqAcceler_"^"_Scale25_"^"_RoadDamageScale_"^"_MissingNum_"^"_EqDeathNum_"^"_EqHurtNum_"^"_HouseCollapse_"^"_PerIncome2007_"^"_PerIncome2008
      .Set count=count+1
      .If (count>start)&(count<=end) d
      ..d json.InsertRowData(tmp)
      .
      .
      
      Set resultString = json.getJsonData("RowId^RainBef^AirHumidityBef^AverageTemperatureBef^AirPollutionIndexBef^RainAfter^AirHumidityAfter^AverageTemperAfter^AirPollutionIndexAfter^TrafficInvest07^HighwayMileage07^SuperHighway07^FirstClass07^VillageHaveHighway07^HighwayMileageAfter^SuperHighwayAfter^FirstClassAfter^VillageHaveHighwayAfter^Communication07^FixedTelphone07^MobilePhone07^Broadcast07^TV2007^bCommImpairment^TimeOfCommDisruption^HealthCareInvest07^AllBedNum07^MedicalPersonnel07^Doctor07^Nurse07^OtherMedicalPersonel07^CollNum07^MiddleTitelNum07^TechnicalSecNum07^DoctorNumOfVillage07^DoctorNumHaveCer07^PrimarySchLevelNum07^JuniorMiddleLevelNum07^EducationalLevelNum07^HealthCareInvest08^AllBedNum2008^MedicalPersonnel08^Doctor2008^Nurse2008^OtherMedicalPersonel08^CollNum2008^MiddleTitelNum08^TechnicalSecNum08^DoctorNumOfVillage08^DoctorNumHaveCer08^PrimarySchLevelNum08^JuniorMiddleLevelNum08^EducationalLevelNum08^DisasterAffectedNum^DeathInEQ^DamageInEQ^HouseDestroyedNum^HouseDestroyedArea^DeathOfMedicalPersonel^DamageOfMedicalPersonel^LossOfEquipment^CurMedicalPersonel^HousingDamage^HousingDamageName^CurHousing^bBreakToCountry^BreakDays^bTBFreeBreak^TBFreeBreakDays^WaterBreakDays^FoodBreakDays^CommunicationBreakDays^Landform^LandformName^TotalHousehold07^LabourForce07^RegisteredJoblessRate07^OutWork07^InWork07^TotalHousehold08^LabourForce08^RegisteredJoblessRate08^OutWork2008^InWork2008^EducationInvest07^TeacherNum07^UntaughtTeacher07^PrimaryTeacher07^EducationalTeacher07^CollTeacher07^EducationInvest08^TeacherNum08^UntaughtTeacher08^PrimaryTeacher08^EducationlTeacher08^CollTeacher08^DateInput^OperatorInput^OperatorInputName^Area^PopulationBefore^PopuDensityBefore^URB^SeismicIntensity^EqAcceler^Scale25^RoadDamageScale^MissingNum^EqDeathNum^EqHurtNum^HouseCollapse^PerIncome2007^PerIncome2008",count)
      k json
      
      Quit resultString
}

/// Creator: lyy
/// CreatDate：2009-08-26
/// Description: 添加地震档案
/// Table：EarthquakeArchive
/// Input: EarthquakeArchive
/// Output：
/// Return：
/// Others：
ClassMethod Insert(CommunityCode As %String, RainBef As %String, AirHumidityBef As %String, AverageTemperatureBef As %String, AirPollutionIndexBef As %String, RainAfter As %String, AirHumidityAfter As %String, AverageTemperAfter As %String, AirPollutionIndexAfter As %String, TrafficInvest07 As %Float, HighwayMileage07 As %Float, SuperHighway07 As %Float, FirstClass07 As %Float, VillageHaveHighway07 As %Numeric, HighwayMileageAfter As %Float, SuperHighwayAfter As %Float, FirstClassAfter As %Float, VillageHaveHighwayAfter As %Numeric, Communication07 As %Float, FixedTelphone07 As %Numeric, MobilePhone07 As %Numeric, Broadcast07 As %Float, TV2007 As %Float, bCommImpairment As %String, TimeOfCommDisruption As %Float, HealthCareInvest07 As %Float, AllBedNum07 As %Numeric, MedicalPersonnel07 As %Numeric, Doctor07 As %Numeric, Nurse07 As %Numeric, OtherMedicalPersonel07 As %Numeric, CollNum07 As %Numeric, MiddleTitelNum07 As %Numeric, TechnicalSecNum07 As %Numeric, DoctorNumOfVillage07 As %Numeric, DoctorNumHaveCer07 As %Numeric, PrimarySchLevelNum07 As %Numeric, JuniorMiddleLevelNum07 As %Numeric, EducationalLevelNum07 As %Numeric, HealthCareInvest08 As %Float, AllBedNum2008 As %Numeric, MedicalPersonnel08 As %Numeric, Doctor2008 As %Numeric, Nurse2008 As %Numeric, OtherMedicalPersonel08 As %Numeric, CollNum2008 As %Numeric, MiddleTitelNum08 As %Numeric, TechnicalSecNum08 As %Numeric, DoctorNumOfVillage08 As %Numeric, DoctorNumHaveCer08 As %Numeric, PrimarySchLevelNum08 As %Numeric, JuniorMiddleLevelNum08 As %Numeric, EducationalLevelNum08 As %Numeric, DisasterAffectedNum As %Numeric, DeathInEQ As %Numeric, DamageInEQ As %Numeric, HouseDestroyedNum As %Numeric, HouseDestroyedArea As %Float, DeathOfMedicalPersonel As %Numeric, DamageOfMedicalPersonel As %Numeric, LossOfEquipment As %Numeric, CurMedicalPersonel As %Numeric, HousingDamage As %Integer, CurHousing As %String, bBreakToCountry As %String, BreakDays As %Numeric, bTBFreeBreak As %String, TBFreeBreakDays As %Numeric, WaterBreakDays As %Numeric, FoodBreakDays As %Numeric, CommunicationBreakDays As %Numeric, Landform As %Integer, TotalHousehold07 As %Numeric, LabourForce07 As %Numeric, RegisteredJoblessRate07 As %Float, OutWork07 As %Numeric, InWork07 As %Numeric, TotalHousehold08 As %Numeric, LabourForce08 As %Numeric, RegisteredJoblessRate08 As %Float, OutWork2008 As %Numeric, InWork2008 As %Numeric, EducationInvest07 As %Float, TeacherNum07 As %Numeric, UntaughtTeacher07 As %Numeric, PrimaryTeacher07 As %Numeric, EducationalTeacher07 As %Numeric, CollTeacher07 As %Numeric, EducationInvest08 As %Float, TeacherNum08 As %Numeric, UntaughtTeacher08 As %Numeric, PrimaryTeacher08 As %Numeric, EducationlTeacher08 As %Numeric, CollTeacher08 As %Numeric, DateInput As %Date, OperatorInput As %Integer, Area As %Float, PopulationBefore As %Numeric, PopuDensityBefore As %Float, URB As %Float, SeismicIntensity As %String, EqAcceler As %String, Scale25 As %Float, RoadDamageScale As %Float, MissingNum As %Numeric, EqDeathNum As %Float, EqHurtNum As %Float, HouseCollapse As %Float, PerIncome2007 As %Float, PerIncome2008 As %Float) As %String
{
      s tempEarthquakeArchive=""
      s tempEarthquakeArchive=##class(CHSS.EarthquakeArchive).%New()
      q:(tempEarthquakeArchive="") 0
      
      
      s tempEarthquakeArchive.CommunityCode = CommunityCode
      
      
      /// 地震前1年气候条件
      
      s tempEarthquakeArchive.RainBef = RainBef
      s tempEarthquakeArchive.AirHumidityBef = AirHumidityBef
      s tempEarthquakeArchive.AverageTemperatureBef = AverageTemperatureBef
      s tempEarthquakeArchive.AirPollutionIndexBef = AirPollutionIndexBef
      
      
      /// 地震后1年气候条件
            
      s tempEarthquakeArchive.RainAfter = RainAfter
      s tempEarthquakeArchive.AirHumidityAfter = AirHumidityAfter
      s tempEarthquakeArchive.AverageTemperAfter = AverageTemperAfter
      s tempEarthquakeArchive.AirPollutionIndexAfter = AirPollutionIndexAfter
      
      
      /// 地震前3年（2005~2007）交通建设
                  
      s tempEarthquakeArchive.TrafficInvest07 = TrafficInvest07
      s tempEarthquakeArchive.HighwayMileage07 = HighwayMileage07
      s tempEarthquakeArchive.SuperHighway07 = SuperHighway07
      s tempEarthquakeArchive.FirstClass07 = FirstClass07
      s tempEarthquakeArchive.VillageHaveHighway07 = VillageHaveHighway07
      
      
      /// 地震后交通建设
      
      s tempEarthquakeArchive.HighwayMileageAfter = HighwayMileageAfter
      s tempEarthquakeArchive.SuperHighwayAfter = SuperHighwayAfter
      s tempEarthquakeArchive.FirstClassAfter = FirstClassAfter
      s tempEarthquakeArchive.VillageHaveHighwayAfter = VillageHaveHighwayAfter
      
      /// 地震前通信建设及广播电视覆盖情况
      
      s tempEarthquakeArchive.Communication07 = Communication07
      s tempEarthquakeArchive.FixedTelphone07 = FixedTelphone07
      s tempEarthquakeArchive.MobilePhone07 = MobilePhone07
      s tempEarthquakeArchive.Broadcast07 = Broadcast07
      s tempEarthquakeArchive.TV2007 = TV2007
      
      
      /// 地震后通信受损情况
      
      s tempEarthquakeArchive.bCommImpairment = bCommImpairment
      s tempEarthquakeArchive.TimeOfCommDisruption = TimeOfCommDisruption
      
      
      /// 地震前卫生资源基本情况
      
      s tempEarthquakeArchive.HealthCareInvest07 = HealthCareInvest07
      s tempEarthquakeArchive.AllBedNum07 = AllBedNum07
      s tempEarthquakeArchive.MedicalPersonnel07 = MedicalPersonnel07
      s tempEarthquakeArchive.Doctor07 = Doctor07
      s tempEarthquakeArchive.Nurse07 = Nurse07
      s tempEarthquakeArchive.OtherMedicalPersonel07 = OtherMedicalPersonel07
      s tempEarthquakeArchive.CollNum07 = CollNum07
      s tempEarthquakeArchive.MiddleTitelNum07 = MiddleTitelNum07
      
      s tempEarthquakeArchive.TechnicalSecNum07 = TechnicalSecNum07
      s tempEarthquakeArchive.DoctorNumOfVillage07 = DoctorNumOfVillage07
      s tempEarthquakeArchive.DoctorNumHaveCer07 = DoctorNumHaveCer07
      s tempEarthquakeArchive.PrimarySchLevelNum07 = PrimarySchLevelNum07
      s tempEarthquakeArchive.JuniorMiddleLevelNum07 = JuniorMiddleLevelNum07
      s tempEarthquakeArchive.EducationalLevelNum07 = EducationalLevelNum07
      
      
      /// 地震后2008年底卫生资源情况
      
      s tempEarthquakeArchive.HealthCareInvest08 = HealthCareInvest08
      s tempEarthquakeArchive.AllBedNum2008 = AllBedNum2008
      s tempEarthquakeArchive.MedicalPersonnel08 = MedicalPersonnel08
      s tempEarthquakeArchive.Doctor2008 = Doctor2008
      s tempEarthquakeArchive.Nurse2008 = Nurse2008
      s tempEarthquakeArchive.OtherMedicalPersonel08 = OtherMedicalPersonel08
      s tempEarthquakeArchive.CollNum2008 = CollNum2008
      s tempEarthquakeArchive.MiddleTitelNum08 = MiddleTitelNum08
      
      s tempEarthquakeArchive.TechnicalSecNum08 = TechnicalSecNum08
      s tempEarthquakeArchive.DoctorNumOfVillage08 = DoctorNumOfVillage08
      s tempEarthquakeArchive.DoctorNumHaveCer08 = DoctorNumHaveCer08
      s tempEarthquakeArchive.PrimarySchLevelNum08 = PrimarySchLevelNum08
      s tempEarthquakeArchive.JuniorMiddleLevelNum08 = JuniorMiddleLevelNum08
      s tempEarthquakeArchive.EducationalLevelNum08 = EducationalLevelNum08
      
      
      /// 地震损失情况
      
      s tempEarthquakeArchive.DisasterAffectedNum = DisasterAffectedNum
      s tempEarthquakeArchive.DeathInEQ = DeathInEQ
      s tempEarthquakeArchive.DamageInEQ = DamageInEQ
      s tempEarthquakeArchive.HouseDestroyedNum = HouseDestroyedNum
      s tempEarthquakeArchive.HouseDestroyedArea = HouseDestroyedArea
      s tempEarthquakeArchive.DeathOfMedicalPersonel = DeathOfMedicalPersonel
      s tempEarthquakeArchive.DamageOfMedicalPersonel = DamageOfMedicalPersonel
      s tempEarthquakeArchive.LossOfEquipment = LossOfEquipment
      s tempEarthquakeArchive.CurMedicalPersonel = CurMedicalPersonel

      i HousingDamage '= "" d
      .s HousingDamageobj=##class(CHSS.DictHouseDamage).%OpenId(HousingDamage)
      .s tempEarthquakeArchive.HousingDamage=HousingDamageobj

      s tempEarthquakeArchive.CurHousing = CurHousing
      s tempEarthquakeArchive.bBreakToCountry = bBreakToCountry
      s tempEarthquakeArchive.BreakDays = BreakDays
      s tempEarthquakeArchive.bTBFreeBreak = bTBFreeBreak
      s tempEarthquakeArchive.TBFreeBreakDays = TBFreeBreakDays
      s tempEarthquakeArchive.WaterBreakDays = WaterBreakDays
      s tempEarthquakeArchive.FoodBreakDays = FoodBreakDays
      s tempEarthquakeArchive.CommunicationBreakDays = CommunicationBreakDays
      
      
      /// 地形地貌
      
      i Landform '= "" d
      .s Landformobj=##class(CHSS.DictLandform).%OpenId(Landform)
      .s tempEarthquakeArchive.Landform=Landformobj
      
      
      /// 劳动力及收入

      s tempEarthquakeArchive.TotalHousehold07 = TotalHousehold07
      s tempEarthquakeArchive.LabourForce07 = LabourForce07
      s tempEarthquakeArchive.RegisteredJoblessRate07 = RegisteredJoblessRate07
      s tempEarthquakeArchive.OutWork07 = OutWork07
      s tempEarthquakeArchive.InWork07 = InWork07
      s tempEarthquakeArchive.TotalHousehold08 = TotalHousehold08
      s tempEarthquakeArchive.LabourForce08 = LabourForce08
      s tempEarthquakeArchive.RegisteredJoblessRate08 = RegisteredJoblessRate08
      s tempEarthquakeArchive.OutWork2008 = OutWork2008
      s tempEarthquakeArchive.InWork2008 = InWork2008
      
      
      /// 基本教育情况
      
      s tempEarthquakeArchive.EducationInvest07 = EducationInvest07
      s tempEarthquakeArchive.TeacherNum07 = TeacherNum07
      s tempEarthquakeArchive.UntaughtTeacher07 = UntaughtTeacher07
      s tempEarthquakeArchive.PrimaryTeacher07 = PrimaryTeacher07
      s tempEarthquakeArchive.EducationalTeacher07 = EducationalTeacher07
      s tempEarthquakeArchive.CollTeacher07 = CollTeacher07
      s tempEarthquakeArchive.EducationInvest08 = EducationInvest08
      s tempEarthquakeArchive.TeacherNum08 = TeacherNum08
      s tempEarthquakeArchive.UntaughtTeacher08 = UntaughtTeacher08
      s tempEarthquakeArchive.PrimaryTeacher08 = PrimaryTeacher08
      s tempEarthquakeArchive.EducationlTeacher08 = EducationlTeacher08
      s tempEarthquakeArchive.CollTeacher08 = CollTeacher08


      /// 本次填表情况
      
      i DateInput '= "" d
      .s DateInput = $zdh(DateInput,3)
      s tempEarthquakeArchive.DateInput = DateInput

      ///i OperatorInput '= "" d
      .///s OperatorInputobj = ##class(User.SSUser).%OpenId(OperatorInput)
      .///s tempFamilyEarthquakeInfo.OperatorInput = OperatorInputobj
      
      
      /// 基本信息
      
      s tempEarthquakeArchive.Area = Area
      s tempEarthquakeArchive.PopulationBefore = PopulationBefore
      s tempEarthquakeArchive.PopuDensityBefore = PopuDensityBefore
      s tempEarthquakeArchive.URB = URB
      
      
      /// 地震信息
      
      s tempEarthquakeArchive.SeismicIntensity = SeismicIntensity
      s tempEarthquakeArchive.EqAcceler = EqAcceler
      s tempEarthquakeArchive.Scale25 = Scale25
      
      s tempEarthquakeArchive.RoadDamageScale = RoadDamageScale
      
  
      /// 地震损失情况
      
      s tempEarthquakeArchive.MissingNum = MissingNum
      s tempEarthquakeArchive.EqDeathNum = EqDeathNum
      s tempEarthquakeArchive.EqHurtNum = EqHurtNum
      s tempEarthquakeArchive.HouseCollapse = HouseCollapse
      
            
      /// 劳动力及收入
      
      s tempEarthquakeArchive.PerIncome2007 = PerIncome2007
      s tempEarthquakeArchive.PerIncome2008 = PerIncome2008

        
      s result=""
      s result=tempEarthquakeArchive.%Save()
      Set resultString = ""
      
      
      i result = "1" d
      .s resultString = "{""success"":""true"",""info"":"_tempEarthquakeArchive.%Id()_"}"
      .///w "{""success"":""true"",""info"":"_tempEarthquakeArchive.%Id()_"}"
      e  d
      .s resultString = "{""success"":""false"",""info"":""数据保存出错!""}"
      .///w "{""success"":""false"",""info"":""数据保存出错!""}"
      .
      q resultString
}

/// Creator: lyy
/// CreatDate：2009-08-26
/// Description: 更新地震档案
/// Table：EarthquakeArchive
/// Input: EarthquakeArchive
/// Output：
/// Return：
/// Others：
ClassMethod Update(RowId As %Integer, RainBef As %String, AirHumidityBef As %String, AverageTemperatureBef As %String, AirPollutionIndexBef As %String, RainAfter As %String, AirHumidityAfter As %String, AverageTemperAfter As %String, AirPollutionIndexAfter As %String, TrafficInvest07 As %Float, HighwayMileage07 As %Float, SuperHighway07 As %Float, FirstClass07 As %Float, VillageHaveHighway07 As %Numeric, HighwayMileageAfter As %Float, SuperHighwayAfter As %Float, FirstClassAfter As %Float, VillageHaveHighwayAfter As %Numeric, Communication07 As %Float, FixedTelphone07 As %Numeric, MobilePhone07 As %Numeric, Broadcast07 As %Float, TV2007 As %Float, bCommImpairment As %String, TimeOfCommDisruption As %Float, HealthCareInvest07 As %Float, AllBedNum07 As %Numeric, MedicalPersonnel07 As %Numeric, Doctor07 As %Numeric, Nurse07 As %Numeric, OtherMedicalPersonel07 As %Numeric, CollNum07 As %Numeric, MiddleTitelNum07 As %Numeric, TechnicalSecNum07 As %Numeric, DoctorNumOfVillage07 As %Numeric, DoctorNumHaveCer07 As %Numeric, PrimarySchLevelNum07 As %Numeric, JuniorMiddleLevelNum07 As %Numeric, EducationalLevelNum07 As %Numeric, HealthCareInvest08 As %Float, AllBedNum2008 As %Numeric, MedicalPersonnel08 As %Numeric, Doctor2008 As %Numeric, Nurse2008 As %Numeric, OtherMedicalPersonel08 As %Numeric, CollNum2008 As %Numeric, MiddleTitelNum08 As %Numeric, TechnicalSecNum08 As %Numeric, DoctorNumOfVillage08 As %Numeric, DoctorNumHaveCer08 As %Numeric, PrimarySchLevelNum08 As %Numeric, JuniorMiddleLevelNum08 As %Numeric, EducationalLevelNum08 As %Numeric, DisasterAffectedNum As %Numeric, DeathInEQ As %Numeric, DamageInEQ As %Numeric, HouseDestroyedNum As %Numeric, HouseDestroyedArea As %Float, DeathOfMedicalPersonel As %Numeric, DamageOfMedicalPersonel As %Numeric, LossOfEquipment As %Numeric, CurMedicalPersonel As %Numeric, HousingDamage As %Integer, CurHousing As %String, bBreakToCountry As %String, BreakDays As %Numeric, bTBFreeBreak As %String, TBFreeBreakDays As %Numeric, WaterBreakDays As %Numeric, FoodBreakDays As %Numeric, CommunicationBreakDays As %Numeric, Landform As %Integer, TotalHousehold07 As %Numeric, LabourForce07 As %Numeric, RegisteredJoblessRate07 As %Float, OutWork07 As %Numeric, InWork07 As %Numeric, TotalHousehold08 As %Numeric, LabourForce08 As %Numeric, RegisteredJoblessRate08 As %Float, OutWork2008 As %Numeric, InWork2008 As %Numeric, EducationInvest07 As %Float, TeacherNum07 As %Numeric, UntaughtTeacher07 As %Numeric, PrimaryTeacher07 As %Numeric, EducationalTeacher07 As %Numeric, CollTeacher07 As %Numeric, EducationInvest08 As %Float, TeacherNum08 As %Numeric, UntaughtTeacher08 As %Numeric, PrimaryTeacher08 As %Numeric, EducationlTeacher08 As %Numeric, CollTeacher08 As %Numeric, DateInput As %Date, OperatorInput As %Integer, Area As %Float, PopulationBefore As %Numeric, PopuDensityBefore As %Float, URB As %Float, SeismicIntensity As %String, EqAcceler As %String, Scale25 As %Float, RoadDamageScale As %Float, MissingNum As %Numeric, EqDeathNum As %Float, EqHurtNum As %Float, HouseCollapse As %Float, PerIncome2007 As %Float, PerIncome2008 As %Float) As %String
{
  
      q:($d(RowId)=0)||(RowId="")
      
      s tempEarthquakeArchive="",result=""
      s tempEarthquakeArchive=##class(CHSS.EarthquakeArchive).%OpenId(RowId)
      q:(tempEarthquakeArchive="") 0
              
      
      /// 地震前1年气候条件
      
      s tempEarthquakeArchive.RainBef = RainBef
      s tempEarthquakeArchive.AirHumidityBef = AirHumidityBef
      s tempEarthquakeArchive.AverageTemperatureBef = AverageTemperatureBef
      s tempEarthquakeArchive.AirPollutionIndexBef = AirPollutionIndexBef
      
      
      /// 地震后1年气候条件
            
      s tempEarthquakeArchive.RainAfter = RainAfter
      s tempEarthquakeArchive.AirHumidityAfter = AirHumidityAfter
      s tempEarthquakeArchive.AverageTemperAfter = AverageTemperAfter
      s tempEarthquakeArchive.AirPollutionIndexAfter = AirPollutionIndexAfter
      
      
      /// 地震前3年（2005~2007）交通建设
                  
      s tempEarthquakeArchive.TrafficInvest07 = TrafficInvest07
      s tempEarthquakeArchive.HighwayMileage07 = HighwayMileage07
      s tempEarthquakeArchive.SuperHighway07 = SuperHighway07
      s tempEarthquakeArchive.FirstClass07 = FirstClass07
      s tempEarthquakeArchive.VillageHaveHighway07 = VillageHaveHighway07
      
      
      /// 地震后交通建设
      
      s tempEarthquakeArchive.HighwayMileageAfter = HighwayMileageAfter
      s tempEarthquakeArchive.SuperHighwayAfter = SuperHighwayAfter
      s tempEarthquakeArchive.FirstClassAfter = FirstClassAfter
      s tempEarthquakeArchive.VillageHaveHighwayAfter = VillageHaveHighwayAfter
      
      /// 地震前通信建设及广播电视覆盖情况
      
      s tempEarthquakeArchive.Communication07 = Communication07
      s tempEarthquakeArchive.FixedTelphone07 = FixedTelphone07
      s tempEarthquakeArchive.MobilePhone07 = MobilePhone07
      s tempEarthquakeArchive.Broadcast07 = Broadcast07
      s tempEarthquakeArchive.TV2007 = TV2007
      
      
      /// 地震后通信受损情况
      
      s tempEarthquakeArchive.bCommImpairment = bCommImpairment
      s tempEarthquakeArchive.TimeOfCommDisruption = TimeOfCommDisruption
      
      
      /// 地震前卫生资源基本情况
      
      s tempEarthquakeArchive.HealthCareInvest07 = HealthCareInvest07
      s tempEarthquakeArchive.AllBedNum07 = AllBedNum07
      s tempEarthquakeArchive.MedicalPersonnel07 = MedicalPersonnel07
      s tempEarthquakeArchive.Doctor07 = Doctor07
      s tempEarthquakeArchive.Nurse07 = Nurse07
      s tempEarthquakeArchive.OtherMedicalPersonel07 = OtherMedicalPersonel07
      s tempEarthquakeArchive.CollNum07 = CollNum07
      s tempEarthquakeArchive.MiddleTitelNum07 = MiddleTitelNum07
      
      s tempEarthquakeArchive.TechnicalSecNum07 = TechnicalSecNum07
      s tempEarthquakeArchive.DoctorNumOfVillage07 = DoctorNumOfVillage07
      s tempEarthquakeArchive.DoctorNumHaveCer07 = DoctorNumHaveCer07
      s tempEarthquakeArchive.PrimarySchLevelNum07 = PrimarySchLevelNum07
      s tempEarthquakeArchive.JuniorMiddleLevelNum07 = JuniorMiddleLevelNum07
      s tempEarthquakeArchive.EducationalLevelNum07 = EducationalLevelNum07
      
      
      /// 地震后2008年底卫生资源情况
      
      s tempEarthquakeArchive.HealthCareInvest08 = HealthCareInvest08
      s tempEarthquakeArchive.AllBedNum2008 = AllBedNum2008
      s tempEarthquakeArchive.MedicalPersonnel08 = MedicalPersonnel08
      s tempEarthquakeArchive.Doctor2008 = Doctor2008
      s tempEarthquakeArchive.Nurse2008 = Nurse2008
      s tempEarthquakeArchive.OtherMedicalPersonel08 = OtherMedicalPersonel08
      s tempEarthquakeArchive.CollNum2008 = CollNum2008
      s tempEarthquakeArchive.MiddleTitelNum08 = MiddleTitelNum08
      
      s tempEarthquakeArchive.TechnicalSecNum08 = TechnicalSecNum08
      s tempEarthquakeArchive.DoctorNumOfVillage08 = DoctorNumOfVillage08
      s tempEarthquakeArchive.DoctorNumHaveCer08 = DoctorNumHaveCer08
      s tempEarthquakeArchive.PrimarySchLevelNum08 = PrimarySchLevelNum08
      s tempEarthquakeArchive.JuniorMiddleLevelNum08 = JuniorMiddleLevelNum08
      s tempEarthquakeArchive.EducationalLevelNum08 = EducationalLevelNum08
      
      
      /// 地震损失情况
      
      s tempEarthquakeArchive.DisasterAffectedNum = DisasterAffectedNum
      s tempEarthquakeArchive.DeathInEQ = DeathInEQ
      s tempEarthquakeArchive.DamageInEQ = DamageInEQ
      s tempEarthquakeArchive.HouseDestroyedNum = HouseDestroyedNum
      s tempEarthquakeArchive.HouseDestroyedArea = HouseDestroyedArea
      s tempEarthquakeArchive.DeathOfMedicalPersonel = DeathOfMedicalPersonel
      s tempEarthquakeArchive.DamageOfMedicalPersonel = DamageOfMedicalPersonel
      s tempEarthquakeArchive.LossOfEquipment = LossOfEquipment
      s tempEarthquakeArchive.CurMedicalPersonel = CurMedicalPersonel

      i HousingDamage '= "" d
      .s HousingDamageobj=##class(CHSS.DictHouseDamage).%OpenId(HousingDamage)
      .s tempEarthquakeArchive.HousingDamage=HousingDamageobj

      s tempEarthquakeArchive.CurHousing = CurHousing
      s tempEarthquakeArchive.bBreakToCountry = bBreakToCountry
      s tempEarthquakeArchive.BreakDays = BreakDays
      s tempEarthquakeArchive.bTBFreeBreak = bTBFreeBreak
      s tempEarthquakeArchive.TBFreeBreakDays = TBFreeBreakDays
      s tempEarthquakeArchive.WaterBreakDays = WaterBreakDays
      s tempEarthquakeArchive.FoodBreakDays = FoodBreakDays
      s tempEarthquakeArchive.CommunicationBreakDays = CommunicationBreakDays
      
      
      /// 地形地貌
      
      i Landform '= "" d
      .s Landformobj=##class(CHSS.DictLandform).%OpenId(Landform)
      .s tempEarthquakeArchive.Landform=Landformobj
      
      
      /// 劳动力及收入

      s tempEarthquakeArchive.TotalHousehold07 = TotalHousehold07
      s tempEarthquakeArchive.LabourForce07 = LabourForce07
      s tempEarthquakeArchive.RegisteredJoblessRate07 = RegisteredJoblessRate07
      s tempEarthquakeArchive.OutWork07 = OutWork07
      s tempEarthquakeArchive.InWork07 = InWork07
      s tempEarthquakeArchive.TotalHousehold08 = TotalHousehold08
      s tempEarthquakeArchive.LabourForce08 = LabourForce08
      s tempEarthquakeArchive.RegisteredJoblessRate08 = RegisteredJoblessRate08
      s tempEarthquakeArchive.OutWork2008 = OutWork2008
      s tempEarthquakeArchive.InWork2008 = InWork2008
      
      
      /// 基本教育情况
      
      s tempEarthquakeArchive.EducationInvest07 = EducationInvest07
      s tempEarthquakeArchive.TeacherNum07 = TeacherNum07
      s tempEarthquakeArchive.UntaughtTeacher07 = UntaughtTeacher07
      s tempEarthquakeArchive.PrimaryTeacher07 = PrimaryTeacher07
      s tempEarthquakeArchive.EducationalTeacher07 = EducationalTeacher07
      s tempEarthquakeArchive.CollTeacher07 = CollTeacher07
      s tempEarthquakeArchive.EducationInvest08 = EducationInvest08
      s tempEarthquakeArchive.TeacherNum08 = TeacherNum08
      s tempEarthquakeArchive.UntaughtTeacher08 = UntaughtTeacher08
      s tempEarthquakeArchive.PrimaryTeacher08 = PrimaryTeacher08
      s tempEarthquakeArchive.EducationlTeacher08 = EducationlTeacher08
      s tempEarthquakeArchive.CollTeacher08 = CollTeacher08


      /// 本次填表情况
      
      i DateInput '= "" d
      .s DateInput = $zdh(DateInput,3)
      s tempEarthquakeArchive.DateInput = DateInput

      ///i OperatorInput '= "" d
      .///s OperatorInputobj = ##class(User.SSUser).%OpenId(OperatorInput)
      .///s tempFamilyEarthquakeInfo.OperatorInput = OperatorInputobj
      
      
      /// 基本信息
      
      s tempEarthquakeArchive.Area = Area
      s tempEarthquakeArchive.PopulationBefore = PopulationBefore
      s tempEarthquakeArchive.PopuDensityBefore = PopuDensityBefore
      s tempEarthquakeArchive.URB = URB
      
      
      /// 地震信息
      
      s tempEarthquakeArchive.SeismicIntensity = SeismicIntensity
      s tempEarthquakeArchive.EqAcceler = EqAcceler
      s tempEarthquakeArchive.Scale25 = Scale25
      
      s tempEarthquakeArchive.RoadDamageScale = RoadDamageScale
      
  
      /// 地震损失情况
      
      s tempEarthquakeArchive.MissingNum = MissingNum
      s tempEarthquakeArchive.EqDeathNum = EqDeathNum
      s tempEarthquakeArchive.EqHurtNum = EqHurtNum
      s tempEarthquakeArchive.HouseCollapse = HouseCollapse
      
            
      /// 劳动力及收入
      
      s tempEarthquakeArchive.PerIncome2007 = PerIncome2007
      s tempEarthquakeArchive.PerIncome2008 = PerIncome2008
      
        
      s result=""
      s result=tempEarthquakeArchive.%Save()
      Set resultString = ""
      
      
      i result = "1" d
      .s resultString = "{""success"":""true"",""info"":"_RowId_"}"
      .///w "{""success"":""true"",""info"":"_RowId_"}"
      e  d
      .s resultString = "{""success"":""false"",""info"":""数据保存出错!""}"
      .///w "{""success"":""false"",""info"":""数据保存出错!""}"
      q resultString
}

Storage Default
{
<Data name="EarthquakeArchiveServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.EarthquakeAr99ED</DataLocation>
<DefaultData>EarthquakeArchiveServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.EarthquakeAr99ED</IdLocation>
<IndexLocation>^CHSSWeb.EarthquakeAr99EI</IndexLocation>
<StreamLocation>^CHSSWeb.EarthquakeAr99ES</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
