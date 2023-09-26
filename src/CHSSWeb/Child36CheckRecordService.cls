Class CHSSWeb.Child36CheckRecordService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

//检索

ClassMethod List(ChildRowId, Start, Limit)
{
    s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT * FROM CHSS.Child36CheckRecord where ChildRowId = "_ChildRowId
	
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count = 0
	s resultString = ""
	s end = Start+Limit
	
	s json = ##class(Code.JsonObj).%New()
	
	While(result.Next())
	{
	 s RowId=result.Data("RowId")
	 s tempChild= ##class(CHSS.Child36CheckRecord).%OpenId(RowId)
	 

	 
	
	 s ChildRowId=""
     i tempChild.ChildRowId'="" d
	 .s ChildRowId=tempChild.ChildRowId.%Id()
	
	s DateOfCheck=tempChild.DateOfCheck
	i DateOfCheck '= "" d
	.s DateOfCheck=$zd(DateOfCheck,3)
	s GeneralCheck=tempChild.GeneralCheck
	s Doctor=tempChild.Doctor  

     s Face=""
	s FaceName=""
	i tempChild.Face'="" d
	.s Face=tempChild.Face.%Id()
	.s FaceName=tempChild.Face.Description

	s Psyche=tempChild.Psyche
	s Nutrition=tempChild.Nutrition
	s Child36Weight=tempChild.Weight
	s Height=tempChild.Height
	s BMI=tempChild.BMI
	s Tooth1=tempChild.Tooth1
	s Tooth2=tempChild.Tooth2
	s Tooth3=tempChild.Tooth3
	s Tooth4=tempChild.Tooth4
	
	 s GrowthAppraisal=""
	s GrowthAppraisalName=""
	i tempChild.GrowthAppraisal'="" d
	.s GrowthAppraisal=tempChild.GrowthAppraisal.%Id()
	.s GrowthAppraisalName=tempChild.GrowthAppraisal.Description

	s Temperature=tempChild.Temperature
	s Pulse=tempChild.Pulse
	s Skin=tempChild.Skin
	
	
	 s Eye=""
	s EyeName=""
	i tempChild.Eye'="" d
	.s Eye=tempChild.Eye.%Id()
	.s EyeName=tempChild.Eye.Description
	
	
	
	s EyeInfo=tempChild.EyeInfo
	s Mouth=tempChild.Mouth
	s MouthInfo=tempChild.MouthInfo
	
	
    s HeartRate=""
	s HeartRateName=""
	i tempChild.HeartRate'="" d
	.s HeartRate=tempChild.HeartRate.%Id()
	.s HeartRateName=tempChild.HeartRate.Description

	s HeartRateInfo=tempChild.HeartRateInfo

	 s Breath=""
	s BreathName=""
	i tempChild.Breath'="" d
	.s Breath=tempChild.Breath.%Id()
	.s BreathName=tempChild.Breath.Description

	s BreathInfo=tempChild.BreathInfo

	 s Spleen=""
	s SpleenName=""
	i tempChild.Spleen'="" d
	.s Spleen=tempChild.Spleen.%Id()
	.s SpleenName=tempChild.Spleen.Description

	s SpleenInfo=tempChild.SpleenInfo

	 s Limbs=""
	s LimbsName=""
	i tempChild.Limbs'="" d
	.s Limbs=tempChild.Limbs.%Id()
	.s LimbsName=tempChild.Limbs.Description

	s LimbsInfo=tempChild.LimbsInfo

	 s Gait=""
	s GaitName=""
	i tempChild.Gait'="" d
	.s Gait=tempChild.Gait.%Id()
	.s GaitName=tempChild.Gait.Description

	s GaitInfo=tempChild.GaitInfo
	s EyeSight=tempChild.EyeSight
	s Hearing=tempChild.Hearing
	s Language1=tempChild.Language1

	 s Action1=""
	s Action1Name=""
	i tempChild.Action1'="" d
	.s Action1=tempChild.Action1.%Id()
	.s Action1Name=tempChild.Action1.Description

	s Mentality=tempChild.Mentality

	 s Social=""
	s SocialName=""
	i tempChild.Social'="" d
	.s Social=tempChild.Social.%Id()
	.s SocialName=tempChild.Social.Description

	s BodyAct=tempChild.BodyAct
	s bAllergen=tempChild.bAllergen
	s Allergen=tempChild.Allergen
	s OtherCheck=tempChild.OtherCheck
	s Conclusion=tempChild.Conclusion
	s ConclusionInfo=tempChild.ConclusionInfo
	s bTransfer=tempChild.bTransfer
	s ReasonOfTransfer=tempChild.ReasonOfTransfer
	s PlaceOfTransfer=tempChild.PlaceOfTransfer
	s Direction=""
	s DirectionName=""
	i tempChild.Direction'="" d
	.s Direction=tempChild.Direction.%Id()
	.s DirectionName=tempChild.Direction.Description

	s tmp=""
	s tmp=RowId_"^"_ChildRowId_"^"_DateOfCheck_"^"_GeneralCheck_"^"_Doctor_"^"_Face_"^"_Psyche_"^"_Nutrition_"^"_Child36Weight_"^"_Height_"^"_BMI_"^"_Tooth1_"^"_Tooth2_"^"_Tooth3_"^"_Tooth4_"^"_GrowthAppraisal_"^"_Temperature_"^"_Pulse_"^"_Skin_"^"_Eye_"^"_EyeInfo_"^"_Mouth_"^"_MouthInfo_"^"_HeartRate_"^"_HeartRateInfo_"^"_Breath_"^"_BreathInfo_"^"_Spleen_"^"_SpleenInfo_"^"_Limbs_"^"_LimbsInfo_"^"_Gait_"^"_GaitInfo_"^"_EyeSight_"^"_Hearing_"^"_Language1_"^"_Action1_"^"_Mentality_"^"_Social_"^"_BodyAct_"^"_bAllergen_"^"_Allergen_"^"_OtherCheck_"^"_Conclusion_"^"_ConclusionInfo_"^"_bTransfer_"^"_ReasonOfTransfer_"^"_PlaceOfTransfer_"^"_Direction_"^"_FaceName_"^"_GrowthAppraisalName_"^"_EyeName_"^"_HeartRateName_"^"_BreathName_"^"_SpleenName_"^"_LimbsName_"^"_GaitName_"^"_Action1Name_"^"_SocialName_"^"_DirectionName
	s count=count+1
	i (count>Start)&(count<=end) d
    .d json.InsertRowData(tmp)
	}
    d result.Close()	
	s resultString = json.getJsonData("RowId^ChildRowId^DateOfCheck^GeneralCheck^Doctor^Face^Psyche^Nutrition^Child36Weight^Height^BMI^Tooth1^Tooth2^Tooth3^Tooth4^GrowthAppraisal^Temperature^Pulse^Skin^Eye^EyeInfo^Mouth^MouthInfo^HeartRate^HeartRateInfo^Breath^BreathInfo^Spleen^SpleenInfo^Limbs^LimbsInfo^Gait^GaitInfo^EyeSight^Hearing^Language1^Action1^Mentality^Social^BodyAct^bAllergen^Allergen^OtherCheck^Conclusion^ConclusionInfo^bTransfer^ReasonOfTransfer^PlaceOfTransfer^Direction^FaceName^GrowthAppraisalName^EyeName^HeartRateName^BreathName^SpleenName^LimbsName^GaitName^Action1Name^SocialName^DirectionName",count)
	k json
	
    Quit resultString
}

//添加

ClassMethod insert(ChildRowId, DateOfCheck, GeneralCheck, Doctor, Face, Psyche, Nutrition, Weight, Height, BMI, Tooth1, Tooth2, Tooth3, Tooth4, GrowthAppraisal, Temperature, Pulse, Skin, Eye, EyeInfo, Mouth, MouthInfo, HeartRate, HeartRateInfo, Breath, BreathInfo, Spleen, SpleenInfo, Limbs, LimbsInfo, Gait, GaitInfo, EyeSight, Hearing, Language1, Action1, Mentality, Social, BodyAct, bAllergen, Allergen, OtherCheck, Conclusion, ConclusionInfo, bTransfer, ReasonOfTransfer, PlaceOfTransfer, Direction)
{
	s tempChild = ""
	s tempChild =##class(CHSS.Child36CheckRecord).%New()
	
		
	i ChildRowId '= "" d
	s tempChild.ChildRowId=##class(CHSS.ChildBaseInfo).%OpenId(ChildRowId)
	
	s tempChild.GeneralCheck=GeneralCheck
	s tempChild.Doctor=Doctor
   
    i Face'="" d
    .s tempChild.Face=##class(CHSS.DictComplexion).%OpenId(Face)
    
	s tempChild.Psyche=Psyche
	s tempChild.Nutrition=Nutrition
	s tempChild.Weight=Weight
	s tempChild.Height=Height
	s tempChild.BMI=BMI
	s tempChild.Tooth1=Tooth1
	s tempChild.Tooth2=Tooth2
	s tempChild.Tooth3=Tooth3
	s tempChild.Tooth4=Tooth4
	
	i GrowthAppraisal'="" d
	.s tempChild.GrowthAppraisal=##class(CHSS.DictChildGrowthAppraisal).%OpenId(GrowthAppraisal)
	
	s tempChild.Temperature=Temperature
	s tempChild.Pulse=Pulse
	s tempChild.Skin=Skin

	
	 i Eye'="" d
    .s tempChild.Eye=##class(CHSS.DictComplexion).%OpenId(Eye)
    
	s tempChild.EyeInfo=EyeInfo
	s tempChild.Mouth=Mouth
	s tempChild.MouthInfo=MouthInfo
	
	i HeartRate'="" d
    .s tempChild.HeartRate=##class(CHSS.DictComplexion).%OpenId(HeartRate)

	s tempChild.HeartRateInfo=HeartRateInfo
	
	 i Breath'="" d
    .s tempChild.Breath=##class(CHSS.DictComplexion).%OpenId(Breath)

	s tempChild.BreathInfo=BreathInfo
	
	 i Spleen'="" d
    .s tempChild.Spleen=##class(CHSS.DictComplexion).%OpenId(Spleen)
    

	s tempChild.SpleenInfo=SpleenInfo
	
	 i Limbs'="" d
    .s tempChild.Limbs=##class(CHSS.DictComplexion).%OpenId(Limbs)

	s tempChild.LimbsInfo=LimbsInfo
	
	 i Gait'="" d
    .s tempChild.Gait=##class(CHSS.DictComplexion).%OpenId(Gait)
	
	s tempChild.GaitInfo=GaitInfo
	s tempChild.EyeSight=EyeSight
	s tempChild.Hearing=Hearing
	s tempChild.Language1=Language1
	
	 i Action1'="" d
    .s tempChild.Action1=##class(CHSS.DictGrowthEval).%OpenId(Action1)

	s tempChild.Mentality=Mentality
	
	i Social'="" d
    .s tempChild.Social=##class(CHSS.DictGrowthEval).%OpenId(Social)
	
	s tempChild.BodyAct=BodyAct
	s tempChild.bAllergen=bAllergen
	s tempChild.Allergen=Allergen
	s tempChild.OtherCheck=OtherCheck
	s tempChild.Conclusion=Conclusion
	s tempChild.ConclusionInfo=ConclusionInfo
	s tempChild.bTransfer=bTransfer
	s tempChild.ReasonOfTransfer=ReasonOfTransfer
	s tempChild.PlaceOfTransfer=PlaceOfTransfer
	
	i Direction'="" d
	.s tempChild.Direction=##class(CHSS.DictSuggestion).%OpenId(Direction)
	
	i DateOfCheck'="" d
	.s DateOfCheck=$zdh(DateOfCheck,3)
	.s tempChild.DateOfCheck=DateOfCheck
	
    s result=""
    s result=tempChild.%Save()
    Set resultString = ""
    i result = "1" d
    .s resultString = "{""success"":""true"",""info"":"_tempChild.%Id()_"}"
    e  d
    .s resultString = "{""success"":""false"",""info"":""数据保存出错!""}"
    q resultString
}

//修改

ClassMethod update(RowId, DateOfCheck, GeneralCheck, Doctor, Face, Psyche, Nutrition, Weight, Height, BMI, Tooth1, Tooth2, Tooth3, Tooth4, GrowthAppraisal, Temperature, Pulse, Skin, Eye, EyeInfo, Mouth, MouthInfo, HeartRate, HeartRateInfo, Breath, BreathInfo, Spleen, SpleenInfo, Limbs, LimbsInfo, Gait, GaitInfo, EyeSight, Hearing, Language1, Action1, Mentality, Social, BodyAct, bAllergen, Allergen, OtherCheck, Conclusion, ConclusionInfo, bTransfer, ReasonOfTransfer, PlaceOfTransfer, Direction)
{
	q:($d(RowId)=0)||(RowId="")
      
    s tempChild="",result=""
    s tempChild=##class(CHSS.Child36CheckRecord).%OpenId(RowId)
    q:(tempChild="") 0	
      
   
	s tempChild.GeneralCheck=GeneralCheck
	s tempChild.Doctor=Doctor
	
	
	  i Face'="" d
    .s tempChild.Face=##class(CHSS.DictComplexion).%OpenId(Face)
    
	s tempChild.Psyche=Psyche
	s tempChild.Nutrition=Nutrition
	s tempChild.Weight=Weight
	s tempChild.Height=Height
	s tempChild.BMI=BMI
	s tempChild.Tooth1=Tooth1
	s tempChild.Tooth2=Tooth2
	s tempChild.Tooth3=Tooth3
	s tempChild.Tooth4=Tooth4
	
	i GrowthAppraisal'="" d
	.s tempChild.GrowthAppraisal=##class(CHSS.DictChildGrowthAppraisal).%OpenId(GrowthAppraisal)
	
	s tempChild.Temperature=Temperature
	s tempChild.Pulse=Pulse
	s tempChild.Skin=Skin

	
	 i Eye'="" d
    .s tempChild.Eye=##class(CHSS.DictComplexion).%OpenId(Eye)
    
	s tempChild.EyeInfo=EyeInfo
	s tempChild.Mouth=Mouth
	s tempChild.MouthInfo=MouthInfo
	
	i HeartRate'="" d
    .s tempChild.HeartRate=##class(CHSS.DictComplexion).%OpenId(HeartRate)

	s tempChild.HeartRateInfo=HeartRateInfo
	
	 i Breath'="" d
    .s tempChild.Breath=##class(CHSS.DictComplexion).%OpenId(Breath)

	s tempChild.BreathInfo=BreathInfo
	
	 i Spleen'="" d
    .s tempChild.Spleen=##class(CHSS.DictComplexion).%OpenId(Spleen)
    

	s tempChild.SpleenInfo=SpleenInfo
	
	 i Limbs'="" d
    .s tempChild.Limbs=##class(CHSS.DictComplexion).%OpenId(Limbs)

	s tempChild.LimbsInfo=LimbsInfo
	
	 i Gait'="" d
    .s tempChild.Gait=##class(CHSS.DictComplexion).%OpenId(Gait)
	
	s tempChild.GaitInfo=GaitInfo
	s tempChild.EyeSight=EyeSight
	s tempChild.Hearing=Hearing
	s tempChild.Language1=Language1
	
	 i Action1'="" d
    .s tempChild.Action1=##class(CHSS.DictGrowthEval).%OpenId(Action1)

	s tempChild.Mentality=Mentality
	
	i Social'="" d
    .s tempChild.Social=##class(CHSS.DictGrowthEval).%OpenId(Social)
	
	s tempChild.BodyAct=BodyAct
	s tempChild.bAllergen=bAllergen
	s tempChild.Allergen=Allergen
	s tempChild.OtherCheck=OtherCheck
	s tempChild.Conclusion=Conclusion
	s tempChild.ConclusionInfo=ConclusionInfo
	s tempChild.bTransfer=bTransfer
	s tempChild.ReasonOfTransfer=ReasonOfTransfer
	s tempChild.PlaceOfTransfer=PlaceOfTransfer
	
	i Direction'="" d
	.s tempChild.Direction=##class(CHSS.DictSuggestion).%OpenId(Direction)
	
	i DateOfCheck'="" d
	.s DateOfCheck=$zdh(DateOfCheck,3)
	.s tempChild.DateOfCheck=DateOfCheck
	
    s result=""
    s result=tempChild.%Save()
    Set resultString = ""
    i result = "1" d
    .s resultString = "{""success"":""true"",""info"":"_tempChild.%Id()_"}"
    e  d
    .s resultString = "{""success"":""false"",""info"":""数据保存出错!""}"
    q resultString
}

Storage Default
{
<Data name="Child36CheckRecordServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.Child36Check95BD</DataLocation>
<DefaultData>Child36CheckRecordServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.Child36Check95BD</IdLocation>
<IndexLocation>^CHSSWeb.Child36Check95BI</IndexLocation>
<StreamLocation>^CHSSWeb.Child36Check95BS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
