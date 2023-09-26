Class CHSSWeb.WomenFirstCheckService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// Creator: lyy
/// CreatDate：2010-06-
/// Description:初次孕产期检查情况
/// Table：WomenFirstCheck
/// Input: WomenFirstCheck
/// Output：
/// Return：
/// Others：
ClassMethod List(WomanRowIdParref As %String, start As %Integer, limit As %Integer, sort As %String) As %String
{
      Set WomanRowIdParref=$G(WomanRowIdParref)
      Set start=$G(start)
      Set limit=$G(limit)
      Set sort=$G(sort)
      Set count=0
      Set resultString = ""
      Set end = start+limit
      Set json = ##class(Code.JsonObj).%New()
      set FirstCheckRowId = 0
      Set tmp = ""
      
      
      
      For  Set FirstCheckRowId=$O(^CHSS.WomenFirstCheckI("WomanRowIdParrefIndex",WomanRowIdParref,FirstCheckRowId)) q:FirstCheckRowId=""  d
      .
      
      .s tempWomenFirstCheck=##class(CHSS.WomenFirstCheck).%OpenId(FirstCheckRowId)
      .
       
 
      ./// 检查信息
      .
      .s CheckUnit = tempWomenFirstCheck.CheckUnit
      
      .s CheckDate = tempWomenFirstCheck.CheckDate
      .i CheckDate '= "" d
      ..s CheckDate = $zd(CheckDate,3)
      
      .s FinishTable = tempWomenFirstCheck.FinishTable
      
      .s OperatorName = ""
      .s Operator = ""
      .i tempWomenFirstCheck.Operator '= "" d
      ..s Operator = tempWomenFirstCheck.Operator.%Id()
      ..s OperatorName = tempWomenFirstCheck.Operator.SSUSRName
      
      .s OperateTime = tempWomenFirstCheck.OperateTime
      .i OperateTime '= "" d
      ..s OperateTime = $zd(OperateTime,3)
      
      
      ./// 孕产基本信息
      .
      .s FVTADDate = tempWomenFirstCheck.FVTADDate
      .i FVTADDate '= "" d
      ..s FVTADDate = $zd(FVTADDate,3)
      
      .s LastEmmeniaDate = tempWomenFirstCheck.LastEmmeniaDate
      .i LastEmmeniaDate '= "" d
      ..s LastEmmeniaDate = $zd(LastEmmeniaDate,3)
      
      .s FCWeekforPreg = tempWomenFirstCheck.FCWeekforPreg
      
      .s EstimateBDate = tempWomenFirstCheck.EstimateBDate
      .i EstimateBDate '= "" d
      ..s EstimateBDate = $zd(EstimateBDate,3)
      
      .s PregnancyNum = tempWomenFirstCheck.PregnancyNum
      .s BearingNum = tempWomenFirstCheck.BearingNum
      
      
      ./// 既往孕产史
      .
      .s PrematureLaborNum = tempWomenFirstCheck.PrematureLaborNum
      .s OpsBearingNum = tempWomenFirstCheck.OpsBearingNum
      .s NaAbortionNum = tempWomenFirstCheck.NaAbortionNum
      .s AbortionNum = tempWomenFirstCheck.AbortionNum
      .s OtherPregHis = tempWomenFirstCheck.OtherPregHis
      
      
      ./// 本次妊娠早孕期异常情况
      .
      .s AbPregDes = tempWomenFirstCheck.AbPregDes
      
      .s DateOfFirstCheck = tempWomenFirstCheck.DateOfFirstCheck
      .i DateOfFirstCheck '= "" d
      ..s DateOfFirstCheck = $zd(DateOfFirstCheck,3)
      
      
      ./// 基本身体检查
      .
      .s BlPressureUnitName = ""
      .s BlPressureUnit = ""
      .i tempWomenFirstCheck.BlPressureUnit '= "" d
      ..s BlPressureUnit = tempWomenFirstCheck.BlPressureUnit.%Id()
      ..s BlPressureUnitName = tempWomenFirstCheck.BlPressureUnit.Description
      
      .s HighBlPressure = tempWomenFirstCheck.HighBlPressure
      .s LowBlPressure = tempWomenFirstCheck.LowBlPressure
      .s Height = tempWomenFirstCheck.Height
      .s Weight = tempWomenFirstCheck.Weight
      .s BMI = tempWomenFirstCheck.BMI
      
      .s HeartName = ""
      .s Heart = ""
      .i tempWomenFirstCheck.Heart '= "" d
      ..s Heart = tempWomenFirstCheck.Heart.%Id()
      ..s HeartName = tempWomenFirstCheck.Heart.Description
      
      .s HeartAbDes = tempWomenFirstCheck.HeartAbDes
      
      .s LungName = ""
      .s Lung = ""
      .i tempWomenFirstCheck.Lung '= "" d
      ..s Lung = tempWomenFirstCheck.Lung.%Id()
      ..s LungName = tempWomenFirstCheck.Lung.Description
      
      .s LungAbDes = tempWomenFirstCheck.LungAbDes
      
      
      ./// 妇科检查
      .
      .s VaginaInflammationName = ""
      .s VaginaInflammation = ""
      .i tempWomenFirstCheck.VaginaInflammation '= "" d
      ..s VaginaInflammation = tempWomenFirstCheck.VaginaInflammation.%Id()
      ..s VaginaInflammationName = tempWomenFirstCheck.VaginaInflammation.Description
      
      .s VaginaInflammationDes = tempWomenFirstCheck.VaginaInflammationDes
      
      .s CervicitisName = ""
      .s Cervicitis = ""
      .i tempWomenFirstCheck.Cervicitis '= "" d
      ..s Cervicitis = tempWomenFirstCheck.Cervicitis.%Id()
      ..s CervicitisName = tempWomenFirstCheck.Cervicitis.Description
      
      .s CervicitisDes = tempWomenFirstCheck.CervicitisDes
      
      .s DoubleWombsName = ""
      .s DoubleWombs = ""
      .i tempWomenFirstCheck.DoubleWombs '= "" d
      ..s DoubleWombs = tempWomenFirstCheck.DoubleWombs.%Id()
      ..s DoubleWombsName = tempWomenFirstCheck.DoubleWombs.Description
      
      .s DoubleWombsDes = tempWomenFirstCheck.DoubleWombsDes
      
      .s UterineFibroidsName = ""
      .s UterineFibroids = ""
      .i tempWomenFirstCheck.UterineFibroids '= "" d
      ..s UterineFibroids = tempWomenFirstCheck.UterineFibroids.%Id()
      ..s UterineFibroidsName = tempWomenFirstCheck.UterineFibroids.Description
      
      .s UterineFibroidsDes = tempWomenFirstCheck.UterineFibroidsDes
      
      .s AccessaryTumourName = ""
      .s AccessaryTumour = ""
      .i tempWomenFirstCheck.AccessaryTumour '= "" d
      ..s AccessaryTumour = tempWomenFirstCheck.AccessaryTumour.%Id()
      ..s AccessaryTumourName = tempWomenFirstCheck.AccessaryTumour.Description
      
      .s AccessaryTumourDes = tempWomenFirstCheck.AccessaryTumourDes
      .s OtherGynecologyDes = tempWomenFirstCheck.OtherGynecologyDes
      
      
      ./// 子宫大小与孕周相符
      .
      .s Compare = tempWomenFirstCheck.Compare
      .s CompareDes = tempWomenFirstCheck.CompareDes
      
      
      ./// 辅助检查
      .
      .s Hemoglobin = tempWomenFirstCheck.Hemoglobin
      .s UrineProtein = tempWomenFirstCheck.UrineProtein
      .s UrineSugar = tempWomenFirstCheck.UrineSugar
      
      .s AFPName = ""
      .s AFP = ""
      .i tempWomenFirstCheck.AFP '= "" d
      ..s AFP = tempWomenFirstCheck.AFP.%Id()
      ..s AFPName = tempWomenFirstCheck.AFP.Description
      
      .s GPTALTName = ""
      .s GPTALT = ""
      .i tempWomenFirstCheck.GPTALT '= "" d
      ..s GPTALT = tempWomenFirstCheck.GPTALT.%Id()
      ..s GPTALTName = tempWomenFirstCheck.GPTALT.Description
      
      .s GPTALTAbDes = tempWomenFirstCheck.GPTALTAbDes
      .s LiverFunction = tempWomenFirstCheck.LiverFunction
      .s RenalFunction = tempWomenFirstCheck.RenalFunction
      .s VaginalDischarge = tempWomenFirstCheck.VaginalDischarge
      
      .s HBsAgName = ""
      .s HBsAg = ""
      .i tempWomenFirstCheck.HBsAg '= "" d
      ..s HBsAg = tempWomenFirstCheck.HBsAg.%Id()
      ..s HBsAgName = tempWomenFirstCheck.HBsAg.Description
      
      .s ABOName = ""
      .s ABO = ""
      .i tempWomenFirstCheck.ABO '= "" d
      ..s ABO = tempWomenFirstCheck.ABO.%Id()
      ..s ABOName = tempWomenFirstCheck.ABO.BLDTDesc
      
      .s LuesResultName = ""
      .s LuesResult = ""
      .i tempWomenFirstCheck.LuesResult '= "" d
      ..s LuesResult = tempWomenFirstCheck.LuesResult.%Id()
      ..s LuesResultName = tempWomenFirstCheck.LuesResult.Description
      
      .s HIVResultName = ""
      .s HIVResult = ""
      .i tempWomenFirstCheck.HIVResult '= "" d
      ..s HIVResult = tempWomenFirstCheck.HIVResult.%Id()
      ..s HIVResultName = tempWomenFirstCheck.HIVResult.Description
      
      .s OtherCheckDes = tempWomenFirstCheck.OtherCheckDes
      
      
      ./// 其他信息
      .
      .s DangerGradeName = ""
      .s DangerGrade = ""
      .i tempWomenFirstCheck.DangerGrade '= "" d
      ..s DangerGrade = tempWomenFirstCheck.DangerGrade.%Id()
      ..s DangerGradeName = tempWomenFirstCheck.DangerGrade.Description
      
      .s CDangerDes = tempWomenFirstCheck.CDangerDes
      
      .s AbPregResultName = ""
      .s AbPregResult = ""
      .i tempWomenFirstCheck.AbPregResult '= "" d
      ..s AbPregResult = tempWomenFirstCheck.AbPregResult.%Id()
      ..s AbPregResultName = tempWomenFirstCheck.AbPregResult.Description
      
      .s MisbirthDate = tempWomenFirstCheck.MisbirthDate
      .i MisbirthDate '= "" d
      ..s MisbirthDate = $zd(MisbirthDate,3)
      
      .s Suggestion = tempWomenFirstCheck.Suggestion
      
      .s PreDate = tempWomenFirstCheck.PreDate
      .i PreDate '= "" d
      ..s PreDate = $zd(PreDate,3)
      
      .s PastHistory = tempWomenFirstCheck.PastHistory
      .s FamilyHistory = tempWomenFirstCheck.FamilyHistory
      .s DyingFetus = tempWomenFirstCheck.DyingFetus
      .s StillBirth = tempWomenFirstCheck.StillBirth
      .s NeonatalDeath = tempWomenFirstCheck.NeonatalDeath
      .s HemocytesNum = tempWomenFirstCheck.HemocytesNum
      .s PLTNum = tempWomenFirstCheck.PLTNum
      .s BloodRoutineOther = tempWomenFirstCheck.BloodRoutineOther
      .s URTOther = tempWomenFirstCheck.URTOther
      .s GPT = tempWomenFirstCheck.GPT
      .s AST = tempWomenFirstCheck.AST
      .s ALB = tempWomenFirstCheck.ALB
      .s TB = tempWomenFirstCheck.TB
      .s DBIL = tempWomenFirstCheck.DBIL
      .s Cr = tempWomenFirstCheck.Cr
      .s BUN = tempWomenFirstCheck.BUN
      .s Sk = tempWomenFirstCheck.Sk
      .s Na = tempWomenFirstCheck.Na
      .s VaginalFluid = tempWomenFirstCheck.VaginalFluid
      .s bTransfer = tempWomenFirstCheck.bTransfer
      .s TransferReason = tempWomenFirstCheck.TransferReason
      .s TransferDept = tempWomenFirstCheck.TransferDept
      .s bOPS = tempWomenFirstCheck.bOPS
      .s WomenOPS = tempWomenFirstCheck.WomenOPS
      .s UrineKetone = tempWomenFirstCheck.UrineKetone
      .s BLD = tempWomenFirstCheck.BLD



      .Set tmp = FirstCheckRowId_"^"_CheckUnit_"^"_CheckDate_"^"_FinishTable_"^"_Operator_"^"_OperatorName_"^"_OperateTime_"^"_FVTADDate_"^"_LastEmmeniaDate_"^"_FCWeekforPreg_"^"_EstimateBDate_"^"_PregnancyNum_"^"_BearingNum_"^"_PrematureLaborNum_"^"_OpsBearingNum_"^"_NaAbortionNum_"^"_AbortionNum_"^"_OtherPregHis_"^"_AbPregDes_"^"_DateOfFirstCheck_"^"_BlPressureUnit_"^"_BlPressureUnitName_"^"_HighBlPressure_"^"_LowBlPressure_"^"_Height_"^"_Weight_"^"_BMI_"^"_Heart_"^"_HeartName_"^"_HeartAbDes_"^"_Lung_"^"_LungName_"^"_LungAbDes_"^"_VaginaInflammation_"^"_VaginaInflammationName_"^"_VaginaInflammationDes_"^"_Cervicitis_"^"_CervicitisName_"^"_CervicitisDes_"^"_DoubleWombs_"^"_DoubleWombsName_"^"_DoubleWombsDes_"^"_UterineFibroids_"^"_UterineFibroidsName_"^"_UterineFibroidsDes_"^"_AccessaryTumour_"^"_AccessaryTumourName_"^"_AccessaryTumourDes_"^"_OtherGynecologyDes_"^"_Compare_"^"_CompareDes_"^"_Hemoglobin_"^"_UrineProtein_"^"_UrineSugar_"^"_AFP_"^"_AFPName_"^"_GPTALT_"^"_GPTALTName_"^"_GPTALTAbDes_"^"_LiverFunction_"^"_RenalFunction_"^"_VaginalDischarge_"^"_HBsAg_"^"_HBsAgName_"^"_ABO_"^"_ABOName_"^"_LuesResult_"^"_LuesResultName_"^"_HIVResult_"^"_HIVResultName_"^"_OtherCheckDes_"^"_DangerGrade_"^"_DangerGradeName_"^"_CDangerDes_"^"_AbPregResult_"^"_AbPregResultName_"^"_MisbirthDate_"^"_Suggestion_"^"_PreDate_"^"_PastHistory_"^"_FamilyHistory_"^"_DyingFetus_"^"_StillBirth_"^"_NeonatalDeath_"^"_HemocytesNum_"^"_PLTNum_"^"_BloodRoutineOther_"^"_URTOther_"^"_GPT_"^"_AST_"^"_ALB_"^"_TB_"^"_DBIL_"^"_Cr_"^"_BUN_"^"_Sk_"^"_Na_"^"_VaginalFluid_"^"_bTransfer_"^"_TransferReason_"^"_TransferDept_"^"_bOPS_"^"_WomenOPS_"^"_UrineKetone_"^"_BLD

      .Set count=count+1
      .If (count>start)&(count<=end) d
      ..d json.InsertRowData(tmp)
      .
      .
      
      Set resultString = json.getJsonData("FirstCheckRowId^CheckUnit^CheckDate^FinishTable1^Operator1^Operator1Name^OperateTime^FVTADDate^LastEmmeniaDate^FCWeekforPreg^EstimateBDate^PregnancyNum^BearingNum^PrematureLaborNum^OpsBearingNum^NaAbortionNum^AbortionNum^OtherPregHis^AbPregDes^DateOfFirstCheck^BlPressureUnit^BlPressureUnitName^HighBlPressure^LowBlPressure^Height^Weight^BMI^Heart^HeartName^HeartAbDes^Lung^LungName^LungAbDes^VaginaInflammation^VaginaInflammationName^VaginaInflammationDes^Cervicitis^CervicitisName^CervicitisDes^DoubleWombs^DoubleWombsName^DoubleWombsDes^UterineFibroids^UterineFibroidsName^UterineFibroidsDes^AccessaryTumour^AccessaryTumourName^AccessaryTumourDes^OtherGynecologyDes^Compare^CompareDes^Hemoglobin^UrineProtein^UrineSugar^AFP^AFPName^GPTALT^GPTALTName^GPTALTAbDes^LiverFunction^RenalFunction^VaginalDischarge^HBsAg^HBsAgName^ABO^ABOName^LuesResult^LuesResultName^HIVResult^HIVResultName^OtherCheckDes^DangerGrade^DangerGradeName^CDangerDes^AbPregResult^AbPregResultName^MisbirthDate^Suggestion^PreDate^PastHistory^FamilyHistory^DyingFetus^StillBirth^NeonatalDeath^HemocytesNum^PLTNum^BloodRoutineOther^URTOther^GPT^AST^ALB^TB^DBIL^Cr^BUN^Sk^Na^VaginalFluid^bTransfer^TransferReason^TransferDept^bOPS^WomenOPS^UrineKetone^BLD",count)
      k json
      
      Quit resultString
}

/// Creator: lyy
/// CreatDate：2010-06-
/// Description:添加初次孕产期检查情况
/// Table：WomenFirstCheck
/// Input: WomenFirstCheck
/// Output：
/// Return：
/// Others：
ClassMethod Insert(WomanRowIdParref As %Integer, CheckUnit As %String, CheckDate As %Date, FinishTable As %String, Operator As %Integer, OperateTime As %Date, FVTADDate As %Date, LastEmmeniaDate As %Date, FCWeekforPreg As %Integer, EstimateBDate As %Date, PregnancyNum As %Integer, BearingNum As %Integer, PrematureLaborNum As %Integer, OpsBearingNum As %Integer, NaAbortionNum As %Integer, AbortionNum As %Integer, OtherPregHis As %String, AbPregDes As %String, DateOfFirstCheck As %Date, BlPressureUnit As %Integer, HighBlPressure As %Integer, LowBlPressure As %Integer, Height As %Float, Weight As %Float, BMI As %Float, Heart As %Integer, HeartAbDes As %String, Lung As %Integer, LungAbDes As %String, VaginaInflammation As %Integer, VaginaInflammationDes As %String, Cervicitis As %Integer, CervicitisDes As %String, DoubleWombs As %Integer, DoubleWombsDes As %String, UterineFibroids As %Integer, UterineFibroidsDes As %String, AccessaryTumour As %Integer, AccessaryTumourDes As %String, OtherGynecologyDes As %String, Compare As %String, CompareDes As %String, Hemoglobin As %String, UrineProtein As %String, UrineSugar As %String, AFP As %Integer, GPTALT As %Integer, GPTALTAbDes As %String, LiverFunction As %String, RenalFunction As %String, VaginalDischarge As %String, HBsAg As %Integer, ABO As %Integer, LuesResult As %Integer, HIVResult As %Integer, OtherCheckDes As %String, DangerGrade As %Integer, CDangerDes As %String, AbPregResult As %Integer, MisbirthDate As %Date, Suggestion As %String, PreDate As %Date, PastHistory As %String, FamilyHistory As %String, DyingFetus As %Numeric, StillBirth As %Numeric, NeonatalDeath As %Numeric, HemocytesNum As %Float, PLTNum As %Float, BloodRoutineOther As %String, URTOther As %String, GPT As %String, AST As %String, ALB As %String, TB As %String, DBIL As %String, Cr As %String, BUN As %String, Sk As %String, Na As %String, VaginalFluid As %String, bTransfer As %String, TransferReason As %String, TransferDept As %String, bOPS As %String, WomenOPS As %String, UrineKetone As %String, BLD As %String) As %String
{
      s tempWomenFirstCheck=""
      s tempWomenFirstCheck=##class(CHSS.WomenFirstCheck).%New()
      q:(tempWomenFirstCheck="") 0
      
	  
      s WomanRowIdParrefobj=##class(CHSS.WomenBaseInfo).%OpenId(WomanRowIdParref)
      s tempWomenFirstCheck.WomanRowIdParref=WomanRowIdParrefobj
      
      /// 检查信息

      s tempWomenFirstCheck.CheckUnit = CheckUnit
      
      i CheckDate '= "" d
      .s CheckDate=$zdh(CheckDate,3)
      s tempWomenFirstCheck.CheckDate = CheckDate
      
      s tempWomenFirstCheck.FinishTable = FinishTable
      
      ///i Operator '= "" d
      .///s Operatorobj = ##class(User.SSUser).%OpenId(Operator)
      .///s tempWomenFirstCheck.Operator = Operatorobj
      
      i OperateTime '= "" d
      .s OperateTime=$zdh(OperateTime,3)
      s tempWomenFirstCheck.OperateTime = OperateTime
      
      
      /// 孕产基本信息
      
      i FVTADDate '= "" d
      .s FVTADDate=$zdh(FVTADDate,3)
      s tempWomenFirstCheck.FVTADDate = FVTADDate
      
      i LastEmmeniaDate '= "" d
      .s LastEmmeniaDate=$zdh(LastEmmeniaDate,3)
      s tempWomenFirstCheck.LastEmmeniaDate = LastEmmeniaDate
      
      s tempWomenFirstCheck.FCWeekforPreg = FCWeekforPreg
      
      i EstimateBDate '= "" d
      .s EstimateBDate=$zdh(EstimateBDate,3)
      s tempWomenFirstCheck.EstimateBDate = EstimateBDate
      
      s tempWomenFirstCheck.PregnancyNum = PregnancyNum
      s tempWomenFirstCheck.BearingNum = BearingNum
      
      
      /// 既往孕产史
      
      s tempWomenFirstCheck.PrematureLaborNum = PrematureLaborNum
      s tempWomenFirstCheck.OpsBearingNum = OpsBearingNum
      s tempWomenFirstCheck.NaAbortionNum = NaAbortionNum
      s tempWomenFirstCheck.AbortionNum = AbortionNum
      s tempWomenFirstCheck.OtherPregHis = OtherPregHis
      
      
      /// 本次妊娠早孕期异常情况
      
      s tempWomenFirstCheck.AbPregDes = AbPregDes
      
      i DateOfFirstCheck '= "" d
      .s DateOfFirstCheck=$zdh(DateOfFirstCheck,3)
      s tempWomenFirstCheck.DateOfFirstCheck = DateOfFirstCheck
      
      
      /// 基本身体检查
      
      i BlPressureUnit '= "" d
      .s BlPressureUnitobj = ##class(CHSS.DictHBPUnit).%OpenId(BlPressureUnit)
      .s tempWomenFirstCheck.BlPressureUnit = BlPressureUnitobj
      
      s tempWomenFirstCheck.HighBlPressure = HighBlPressure
      s tempWomenFirstCheck.LowBlPressure = LowBlPressure
      s tempWomenFirstCheck.Height = Height
      s tempWomenFirstCheck.Weight = Weight
      s tempWomenFirstCheck.BMI = BMI
      
      i Heart '= "" d
      .s Heartobj = ##class(CHSS.DictHeartCheckResult).%OpenId(Heart)
      .s tempWomenFirstCheck.Heart = Heartobj
      
      s tempWomenFirstCheck.HeartAbDes = HeartAbDes
      
      i Lung '= "" d
      .s Lungobj = ##class(CHSS.DictHeartCheckResult).%OpenId(Lung)
      .s tempWomenFirstCheck.Lung = Lungobj
      
      s tempWomenFirstCheck.LungAbDes = LungAbDes
      
      
      /// 妇科检查
      
      i VaginaInflammation '= "" d
      .s VaginaInflammationobj = ##class(CHSS.DictWomenCheck).%OpenId(VaginaInflammation)
      .s tempWomenFirstCheck.VaginaInflammation = VaginaInflammationobj
      
      s tempWomenFirstCheck.VaginaInflammationDes = VaginaInflammationDes
      
      i Cervicitis '= "" d
      .s Cervicitisobj = ##class(CHSS.DictWomenCheck).%OpenId(Cervicitis)
      .s tempWomenFirstCheck.Cervicitis = Cervicitisobj
      
      s tempWomenFirstCheck.CervicitisDes = CervicitisDes
      
      i DoubleWombs '= "" d
      .s DoubleWombsobj = ##class(CHSS.DictWomenCheck).%OpenId(DoubleWombs)
      .s tempWomenFirstCheck.DoubleWombs = DoubleWombsobj
      
      s tempWomenFirstCheck.DoubleWombsDes = DoubleWombsDes
      
      i UterineFibroids '= "" d
      .s UterineFibroidsobj = ##class(CHSS.DictWomenCheck).%OpenId(UterineFibroids)
      .s tempWomenFirstCheck.UterineFibroids = UterineFibroidsobj
      
      s tempWomenFirstCheck.UterineFibroidsDes = UterineFibroidsDes
      
      i AccessaryTumour '= "" d
      .s AccessaryTumourobj = ##class(CHSS.DictWomenCheck).%OpenId(AccessaryTumour)
      .s tempWomenFirstCheck.AccessaryTumour = AccessaryTumourobj
      
      s tempWomenFirstCheck.AccessaryTumourDes = AccessaryTumourDes
      s tempWomenFirstCheck.OtherGynecologyDes = OtherGynecologyDes
      
      
      /// 子宫大小与孕周相符
      
      s tempWomenFirstCheck.Compare = Compare
      s tempWomenFirstCheck.CompareDes = CompareDes
      
      
      /// 辅助检查
      
      s tempWomenFirstCheck.Hemoglobin = Hemoglobin
      s tempWomenFirstCheck.UrineProtein = UrineProtein
      s tempWomenFirstCheck.UrineSugar = UrineSugar
      
      i AFP '= "" d
      .s AFPobj = ##class(CHSS.DictHeartCheckResult).%OpenId(AFP)
      .s tempWomenFirstCheck.AFP = AFPobj
      
      i GPTALT '= "" d
      .s GPTALTobj = ##class(CHSS.DictHeartCheckResult).%OpenId(GPTALT)
      .s tempWomenFirstCheck.GPTALT = GPTALTobj
      
      s tempWomenFirstCheck.GPTALTAbDes = GPTALTAbDes
      s tempWomenFirstCheck.LiverFunction = LiverFunction
      s tempWomenFirstCheck.RenalFunction = RenalFunction
      s tempWomenFirstCheck.VaginalDischarge = VaginalDischarge
      
      i HBsAg '= "" d
      .s HBsAgobj = ##class(CHSS.DictHBVTag).%OpenId(HBsAg)
      .s tempWomenFirstCheck.HBsAg = HBsAgobj
      
      i ABO '= "" d
      .s ABOobj = ##class(User.PACBloodType).%OpenId(ABO)
      .s tempWomenFirstCheck.ABO = ABOobj
      
      i LuesResult '= "" d
      .s LuesResultobj = ##class(CHSS.DictHBVTag).%OpenId(LuesResult)
      .s tempWomenFirstCheck.LuesResult = LuesResultobj
      
      i HIVResult '= "" d
      .s HIVResultobj = ##class(CHSS.DictHBVTag).%OpenId(HIVResult)
      .s tempWomenFirstCheck.HIVResult = HIVResultobj
      
      s tempWomenFirstCheck.OtherCheckDes = OtherCheckDes
      
      
      /// 其他信息
      
      i DangerGrade '= "" d
      .s DangerGradeobj = ##class(CHSS.DictWomenDangerGrade).%OpenId(DangerGrade)
      .s tempWomenFirstCheck.DangerGrade = DangerGradeobj
      
      s tempWomenFirstCheck.CDangerDes = CDangerDes
      
      i AbPregResult '= "" d
      .s AbPregResultobj = ##class(CHSS.DictWomenAbPregResult).%OpenId(AbPregResult)
      .s tempWomenFirstCheck.AbPregResult = AbPregResultobj
      
      i MisbirthDate '= "" d
      .s MisbirthDate=$zdh(MisbirthDate,3)
      s tempWomenFirstCheck.MisbirthDate = MisbirthDate
      
      s tempWomenFirstCheck.Suggestion = Suggestion
      
      i PreDate '= "" d
      .s PreDate=$zdh(PreDate,3)
      s tempWomenFirstCheck.PreDate = PreDate
      
      
      s tempWomenFirstCheck.PastHistory = PastHistory
      s tempWomenFirstCheck.FamilyHistory = FamilyHistory
      s tempWomenFirstCheck.DyingFetus = DyingFetus
      s tempWomenFirstCheck.StillBirth = StillBirth
      s tempWomenFirstCheck.NeonatalDeath = NeonatalDeath
      s tempWomenFirstCheck.HemocytesNum = HemocytesNum
      s tempWomenFirstCheck.PLTNum = PLTNum
      s tempWomenFirstCheck.BloodRoutineOther = BloodRoutineOther
      s tempWomenFirstCheck.URTOther = URTOther
      s tempWomenFirstCheck.GPT = GPT
      s tempWomenFirstCheck.AST = AST
      s tempWomenFirstCheck.ALB = ALB
      s tempWomenFirstCheck.TB = TB
      s tempWomenFirstCheck.DBIL = DBIL
      s tempWomenFirstCheck.Cr = Cr
      s tempWomenFirstCheck.BUN = BUN
      s tempWomenFirstCheck.Sk = Sk
      s tempWomenFirstCheck.Na = Na
      s tempWomenFirstCheck.VaginalFluid = VaginalFluid
      s tempWomenFirstCheck.bTransfer = bTransfer
      s tempWomenFirstCheck.TransferReason = TransferReason
      s tempWomenFirstCheck.TransferDept = TransferDept
      s tempWomenFirstCheck.bOPS = bOPS
      s tempWomenFirstCheck.WomenOPS = WomenOPS
      s tempWomenFirstCheck.UrineKetone = UrineKetone
      s tempWomenFirstCheck.BLD = BLD


        
      s result=""
      s result=tempWomenFirstCheck.%Save()
      Set resultString = ""
      
      
      i result = "1" d
      .s resultString = "{""success"":""true"",""info"":"_tempWomenFirstCheck.%Id()_"}"
      .///w "{""success"":""true"",""info"":"_tempWomenFirstCheck.%Id()_"}"
      e  d
      .s resultString = "{""success"":""false"",""info"":""数据保存出错!""}"
      .///w "{""success"":""false"",""info"":""数据保存出错!""}"
      .
      q resultString
}

/// Creator: lyy
/// CreatDate：2010-06-
/// Description:更新初次孕产期检查情况
/// Table：WomenFirstCheck
/// Input: WomenFirstCheck
/// Output：
/// Return：
/// Others：
ClassMethod Update(FirstCheckRowId As %Integer, CheckUnit As %String, CheckDate As %Date, FinishTable As %String, Operator As %Integer, OperateTime As %Date, FVTADDate As %Date, LastEmmeniaDate As %Date, FCWeekforPreg As %Integer, EstimateBDate As %Date, PregnancyNum As %Integer, BearingNum As %Integer, PrematureLaborNum As %Integer, OpsBearingNum As %Integer, NaAbortionNum As %Integer, AbortionNum As %Integer, OtherPregHis As %String, AbPregDes As %String, DateOfFirstCheck As %Date, BlPressureUnit As %Integer, HighBlPressure As %Integer, LowBlPressure As %Integer, Height As %Float, Weight As %Float, BMI As %Float, Heart As %Integer, HeartAbDes As %String, Lung As %Integer, LungAbDes As %String, VaginaInflammation As %Integer, VaginaInflammationDes As %String, Cervicitis As %Integer, CervicitisDes As %String, DoubleWombs As %Integer, DoubleWombsDes As %String, UterineFibroids As %Integer, UterineFibroidsDes As %String, AccessaryTumour As %Integer, AccessaryTumourDes As %String, OtherGynecologyDes As %String, Compare As %String, CompareDes As %String, Hemoglobin As %String, UrineProtein As %String, UrineSugar As %String, AFP As %Integer, GPTALT As %Integer, GPTALTAbDes As %String, LiverFunction As %String, RenalFunction As %String, VaginalDischarge As %String, HBsAg As %Integer, ABO As %Integer, LuesResult As %Integer, HIVResult As %Integer, OtherCheckDes As %String, DangerGrade As %Integer, CDangerDes As %String, AbPregResult As %Integer, MisbirthDate As %Date, Suggestion As %String, PreDate As %Date, PastHistory As %String, FamilyHistory As %String, DyingFetus As %Numeric, StillBirth As %Numeric, NeonatalDeath As %Numeric, HemocytesNum As %Float, PLTNum As %Float, BloodRoutineOther As %String, URTOther As %String, GPT As %String, AST As %String, ALB As %String, TB As %String, DBIL As %String, Cr As %String, BUN As %String, Sk As %String, Na As %String, VaginalFluid As %String, bTransfer As %String, TransferReason As %String, TransferDept As %String, bOPS As %String, WomenOPS As %String, UrineKetone As %String, BLD As %String) As %String
{
  
      q:($d(FirstCheckRowId)=0)||(FirstCheckRowId="")
      
      s tempWomenFirstCheck="",result=""
      s tempWomenFirstCheck=##class(CHSS.WomenFirstCheck).%OpenId(FirstCheckRowId)
      q:(tempWomenFirstCheck="") 0
       
      
      /// 检查信息

      s tempWomenFirstCheck.CheckUnit = CheckUnit
      
      i CheckDate '= "" d
      .s CheckDate=$zdh(CheckDate,3)
      s tempWomenFirstCheck.CheckDate = CheckDate
      
      s tempWomenFirstCheck.FinishTable = FinishTable
      
      ///i Operator '= "" d
      .///s Operatorobj = ##class(User.SSUser).%OpenId(Operator)
      .///s tempWomenFirstCheck.Operator = Operatorobj
      
      i OperateTime '= "" d
      .s OperateTime=$zdh(OperateTime,3)
      s tempWomenFirstCheck.OperateTime = OperateTime
      
      
      /// 孕产基本信息
      
      i FVTADDate '= "" d
      .s FVTADDate=$zdh(FVTADDate,3)
      s tempWomenFirstCheck.FVTADDate = FVTADDate
      
      i LastEmmeniaDate '= "" d
      .s LastEmmeniaDate=$zdh(LastEmmeniaDate,3)
      s tempWomenFirstCheck.LastEmmeniaDate = LastEmmeniaDate
      
      s tempWomenFirstCheck.FCWeekforPreg = FCWeekforPreg
      
      i EstimateBDate '= "" d
      .s EstimateBDate=$zdh(EstimateBDate,3)
      s tempWomenFirstCheck.EstimateBDate = EstimateBDate
      
      s tempWomenFirstCheck.PregnancyNum = PregnancyNum
      s tempWomenFirstCheck.BearingNum = BearingNum
      
      
      /// 既往孕产史
      
      s tempWomenFirstCheck.PrematureLaborNum = PrematureLaborNum
      s tempWomenFirstCheck.OpsBearingNum = OpsBearingNum
      s tempWomenFirstCheck.NaAbortionNum = NaAbortionNum
      s tempWomenFirstCheck.AbortionNum = AbortionNum
      s tempWomenFirstCheck.OtherPregHis = OtherPregHis
      
      
      /// 本次妊娠早孕期异常情况
      
      s tempWomenFirstCheck.AbPregDes = AbPregDes
      
      i DateOfFirstCheck '= "" d
      .s DateOfFirstCheck=$zdh(DateOfFirstCheck,3)
      s tempWomenFirstCheck.DateOfFirstCheck = DateOfFirstCheck
      
      
      /// 基本身体检查
      
      i BlPressureUnit '= "" d
      .s BlPressureUnitobj = ##class(CHSS.DictHBPUnit).%OpenId(BlPressureUnit)
      .s tempWomenFirstCheck.BlPressureUnit = BlPressureUnitobj
      
      s tempWomenFirstCheck.HighBlPressure = HighBlPressure
      s tempWomenFirstCheck.LowBlPressure = LowBlPressure
      s tempWomenFirstCheck.Height = Height
      s tempWomenFirstCheck.Weight = Weight
      s tempWomenFirstCheck.BMI = BMI
      
      i Heart '= "" d
      .s Heartobj = ##class(CHSS.DictHeartCheckResult).%OpenId(Heart)
      .s tempWomenFirstCheck.Heart = Heartobj
      
      s tempWomenFirstCheck.HeartAbDes = HeartAbDes
      
      i Lung '= "" d
      .s Lungobj = ##class(CHSS.DictHeartCheckResult).%OpenId(Lung)
      .s tempWomenFirstCheck.Lung = Lungobj
      
      s tempWomenFirstCheck.LungAbDes = LungAbDes
      
      
      /// 妇科检查
      
      i VaginaInflammation '= "" d
      .s VaginaInflammationobj = ##class(CHSS.DictWomenCheck).%OpenId(VaginaInflammation)
      .s tempWomenFirstCheck.VaginaInflammation = VaginaInflammationobj
      
      s tempWomenFirstCheck.VaginaInflammationDes = VaginaInflammationDes
      
      i Cervicitis '= "" d
      .s Cervicitisobj = ##class(CHSS.DictWomenCheck).%OpenId(Cervicitis)
      .s tempWomenFirstCheck.Cervicitis = Cervicitisobj
      
      s tempWomenFirstCheck.CervicitisDes = CervicitisDes
      
      i DoubleWombs '= "" d
      .s DoubleWombsobj = ##class(CHSS.DictWomenCheck).%OpenId(DoubleWombs)
      .s tempWomenFirstCheck.DoubleWombs = DoubleWombsobj
      
      s tempWomenFirstCheck.DoubleWombsDes = DoubleWombsDes
      
      i UterineFibroids '= "" d
      .s UterineFibroidsobj = ##class(CHSS.DictWomenCheck).%OpenId(UterineFibroids)
      .s tempWomenFirstCheck.UterineFibroids = UterineFibroidsobj
      
      s tempWomenFirstCheck.UterineFibroidsDes = UterineFibroidsDes
      
      i AccessaryTumour '= "" d
      .s AccessaryTumourobj = ##class(CHSS.DictWomenCheck).%OpenId(AccessaryTumour)
      .s tempWomenFirstCheck.AccessaryTumour = AccessaryTumourobj
      
      s tempWomenFirstCheck.AccessaryTumourDes = AccessaryTumourDes
      s tempWomenFirstCheck.OtherGynecologyDes = OtherGynecologyDes
      
      
      /// 子宫大小与孕周相符
      
      s tempWomenFirstCheck.Compare = Compare
      s tempWomenFirstCheck.CompareDes = CompareDes
      
      
      /// 辅助检查
      
      s tempWomenFirstCheck.Hemoglobin = Hemoglobin
      s tempWomenFirstCheck.UrineProtein = UrineProtein
      s tempWomenFirstCheck.UrineSugar = UrineSugar
      
      i AFP '= "" d
      .s AFPobj = ##class(CHSS.DictHeartCheckResult).%OpenId(AFP)
      .s tempWomenFirstCheck.AFP = AFPobj
      
      i GPTALT '= "" d
      .s GPTALTobj = ##class(CHSS.DictHeartCheckResult).%OpenId(GPTALT)
      .s tempWomenFirstCheck.GPTALT = GPTALTobj
      
      s tempWomenFirstCheck.GPTALTAbDes = GPTALTAbDes
      s tempWomenFirstCheck.LiverFunction = LiverFunction
      s tempWomenFirstCheck.RenalFunction = RenalFunction
      s tempWomenFirstCheck.VaginalDischarge = VaginalDischarge
      
      i HBsAg '= "" d
      .s HBsAgobj = ##class(CHSS.DictHBVTag).%OpenId(HBsAg)
      .s tempWomenFirstCheck.HBsAg = HBsAgobj
      
      i ABO '= "" d
      .s ABOobj = ##class(User.PACBloodType).%OpenId(ABO)
      .s tempWomenFirstCheck.ABO = ABOobj
      
      i LuesResult '= "" d
      .s LuesResultobj = ##class(CHSS.DictHBVTag).%OpenId(LuesResult)
      .s tempWomenFirstCheck.LuesResult = LuesResultobj
      
      i HIVResult '= "" d
      .s HIVResultobj = ##class(CHSS.DictHBVTag).%OpenId(HIVResult)
      .s tempWomenFirstCheck.HIVResult = HIVResultobj
      
      s tempWomenFirstCheck.OtherCheckDes = OtherCheckDes
      
      
      /// 其他信息
      
      i DangerGrade '= "" d
      .s DangerGradeobj = ##class(CHSS.DictWomenDangerGrade).%OpenId(DangerGrade)
      .s tempWomenFirstCheck.DangerGrade = DangerGradeobj
      
      s tempWomenFirstCheck.CDangerDes = CDangerDes
      
      i AbPregResult '= "" d
      .s AbPregResultobj = ##class(CHSS.DictWomenAbPregResult).%OpenId(AbPregResult)
      .s tempWomenFirstCheck.AbPregResult = AbPregResultobj
      
      i MisbirthDate '= "" d
      .s MisbirthDate=$zdh(MisbirthDate,3)
      s tempWomenFirstCheck.MisbirthDate = MisbirthDate
      
      s tempWomenFirstCheck.Suggestion = Suggestion
      
      i PreDate '= "" d
      .s PreDate=$zdh(PreDate,3)
      s tempWomenFirstCheck.PreDate = PreDate
      
      
      
      s tempWomenFirstCheck.PastHistory = PastHistory
      s tempWomenFirstCheck.FamilyHistory = FamilyHistory
      s tempWomenFirstCheck.DyingFetus = DyingFetus
      s tempWomenFirstCheck.StillBirth = StillBirth
      s tempWomenFirstCheck.NeonatalDeath = NeonatalDeath
      s tempWomenFirstCheck.HemocytesNum = HemocytesNum
      s tempWomenFirstCheck.PLTNum = PLTNum
      s tempWomenFirstCheck.BloodRoutineOther = BloodRoutineOther
      s tempWomenFirstCheck.URTOther = URTOther
      s tempWomenFirstCheck.GPT = GPT
      s tempWomenFirstCheck.AST = AST
      s tempWomenFirstCheck.ALB = ALB
      s tempWomenFirstCheck.TB = TB
      s tempWomenFirstCheck.DBIL = DBIL
      s tempWomenFirstCheck.Cr = Cr
      s tempWomenFirstCheck.BUN = BUN
      s tempWomenFirstCheck.Sk = Sk
      s tempWomenFirstCheck.Na = Na
      s tempWomenFirstCheck.VaginalFluid = VaginalFluid
      s tempWomenFirstCheck.bTransfer = bTransfer
      s tempWomenFirstCheck.TransferReason = TransferReason
      s tempWomenFirstCheck.TransferDept = TransferDept
      s tempWomenFirstCheck.bOPS = bOPS
      s tempWomenFirstCheck.WomenOPS = WomenOPS
      s tempWomenFirstCheck.UrineKetone = UrineKetone
      s tempWomenFirstCheck.BLD = BLD  
      
      
  
      s result=""
      s result=tempWomenFirstCheck.%Save()
      Set resultString = ""
      
      
      i result = "1" d
      .s resultString = "{""success"":""true"",""info"":"_FirstCheckRowId_"}"
      .///w "{""success"":""true"",""info"":"_FirstCheckRowId_"}"
      e  d
      .s resultString = "{""success"":""false"",""info"":""数据保存出错!""}"
      .///w "{""success"":""false"",""info"":""数据保存出错!""}"
      q resultString
}

Storage Default
{
<Data name="WomenFirstCheckServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.WomenFirstCh8BDD</DataLocation>
<DefaultData>WomenFirstCheckServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.WomenFirstCh8BDD</IdLocation>
<IndexLocation>^CHSSWeb.WomenFirstCh8BDI</IndexLocation>
<StreamLocation>^CHSSWeb.WomenFirstCh8BDS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
