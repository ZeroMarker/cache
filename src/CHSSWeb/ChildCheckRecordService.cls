Class CHSSWeb.ChildCheckRecordService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

//检索

ClassMethod List(ChildRowId, Start, Limit)
{

	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT * FROM CHSS.childcheckrecord where ChildRowId = "_ChildRowId
	
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count = 0

	s resultString = ""
	s end = Start+Limit
	
	s json = ##class(Code.JsonObj).%New()
	
	While(result.Next())
	{
	s RowId=result.Data("RowId")
	s tempChild=##class(CHSS.ChildCheckRecord).%OpenId(RowId)

	s CheckMonth=tempChild.CheckMonth
	s CheckMonthName=tempChild.CheckMonth
	s DateOfCheck=tempChild.DateOfCheck
	i DateOfCheck '= "" d
	.s DateOfCheck=$zd(DateOfCheck,3)
	
	s Doctor=tempChild.Doctor  
	s ChildWeight=tempChild.Weight
	s Height=tempChild.Height
	s BMI=tempChild.BMI
	s GrowthAppraisal=tempChild.GrowthAppraisal
	s Temperature=tempChild.Temperature
	s Breath=tempChild.Breath
	s Pulse=tempChild.Pulse
	
	s Face=""
	s FaceName=""
	i tempChild.Face'="" d
	.s Face=tempChild.Face.%Id()
	.s FaceName=tempChild.Face.Description
	
	 s Skin=""
	 s SkinName=""
	 i tempChild.Skin'="" d 
	 .s Skin=tempChild.Skin.%Id()
	 .s SkinName =tempChild.Skin.Description
	
	
	
	 s Bregma=""
	 s BregmaName=""
	 i tempChild.Bregma'="" d 
	 .s Bregma=tempChild.Bregma.%Id()
	 .s BregmaName =tempChild.Bregma.Description
	
	
	
	s Length=tempChild.Length
	s Width=tempChild.Width
	
	 s Eye=""
	 s EyeName=""
	i tempChild.Eye'="" d 
	.s Eye=tempChild.Eye.%Id()
	.s EyeName=tempChild.Eye.Description
	
	
	s EyeInfo=tempChild.EyeInfo
	
	s Ear=""
	s EarName=""
	i tempChild.Ear'="" d 
	.s Ear=tempChild.Ear.%Id()
	.s EarName=tempChild.Ear.Description
	s EarInfo=tempChild.EarInfo
	
	s Teething=""
	s TeethingName=""
	i tempChild.Teething'="" d 
	.s Teething=tempChild.Teething.%Id()
	.s TeethingName=tempChild.Teething.Description
	s TeethingInfo=tempChild.TeethingInfo
	
	
	 s Nose=""
	 s NoseName=""
	 i tempChild.Nose'="" d 
	.s Nose=tempChild.Nose.%Id()
	.s NoseName=tempChild.Nose.Description
	s NoseInfo=tempChild.NoseInfo
	
	
	 s Chest=""
	 s ChestName=""
	 i tempChild.Chest'="" d 
	.s Chest=tempChild.Chest.%Id()
	.s ChestName=tempChild.Chest.Description
	s ChestInfo=tempChild.ChestInfo
	
	
	 s Abdomen=""
	 s AbdomenName=""
	 i tempChild.Abdomen'="" d 
	.s Abdomen=tempChild.Abdomen.%Id()
	.s AbdomenName=tempChild.Abdomen.Description
	s AbdomenInfo=tempChild.AbdomenInfo
	
	 s UmbilicalReg=""
	 s UmbilicalRegName=""
	 i tempChild.UmbilicalReg'="" d 
	 .s UmbilicalReg=tempChild.UmbilicalReg.%Id()
	 .s UmbilicalRegName=tempChild.UmbilicalReg.Description
	s UmbilicalRegInfo=tempChild.UmbilicalRegInfo
	
	
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
	
	s JointHip=""
	 s JointHipName=""
	 i tempChild.JointHip'="" d 
	.s JointHip=tempChild.JointHip.%Id()
	.s JointHipName=tempChild.JointHip.Description
	s JointHipInfo=tempChild.JointHipInfo
	
		s PrimReaction=""
	 s PrimReactionName=""
	 i tempChild.PrimReaction'="" d 
	.s PrimReaction=tempChild.PrimReaction.%Id()
	.s PrimReactionName=tempChild.PrimReaction.Description
	s PrimReactionInfo=tempChild.PrimReactionInfo
	s VitaminD=tempChild.VitaminD
	s EyeSight=tempChild.EyeSight
	s Hearing=tempChild.Hearing
	s Social=tempChild.Social
	s Actions=tempChild.Actions
	
     s bSickLast=""
	 s bSickLastName=""
	 i tempChild.bSickLast'="" d 
	.s bSickLast=tempChild.bSickLast.%Id()
	.s bSickLastName=tempChild.bSickLast.Description
	
	

	s RicketsSym=""
	 s RicketsSymName=""
	 i tempChild.RicketsSym'="" d 
	.s RicketsSym=tempChild.RicketsSym.%Id()
	.s RicketsSymName=tempChild.RicketsSym.Description
	
	s RicketsSign=""
	 s RicketsSignName=""
	 i tempChild.RicketsSign'="" d 
	.s RicketsSign=tempChild.RicketsSign.%Id()
	.s RicketsSignName=tempChild.RicketsSign.Description
	
	
	s Anus=""
	 s AnusName=""
	 i tempChild.Anus'="" d 
	.s Anus=tempChild.Anus.%Id()
	.s AnusName=tempChild.Anus.Description
	s AnusInfo=tempChild.AnusInfo
	
	
	s Genitalia=""
	 s GenitaliaName=""
	 i tempChild.Genitalia'="" d 
	.s Genitalia=tempChild.Genitalia.%Id()
	.s GenitaliaName=tempChild.Genitalia.Description
	s GenitaliaInfo=tempChild.GenitaliaInfo
	
	s HGB=tempChild.HGB
	s OutdoorActivity=tempChild.OutdoorActivity
	s ReasonOfTransfer=tempChild.ReasonOfTransfer
	s bTransfer=tempChild.bTransfer
	s PlaceOfTransfer=tempChild.PlaceOfTransfer
	
	
	s Direction=""
	s DirectionName=""
	i tempChild.Direction'="" d
	.s Direction=tempChild.Direction.%Id()
	.s DirectionName=tempChild.Direction.Description
	
	s DateOfNextCheck=tempChild.DateOfNextCheck
	i DateOfNextCheck '= "" d
	.s DateOfNextCheck=$zd(DateOfNextCheck,3)
	s PlaceOfNextCheck=tempChild.PlaceOfNextCheck
	
	s tmp=""
	s tmp=RowId_"^"_ChildRowId_"^"_CheckMonth_"^"_DateOfCheck_"^"_Doctor_"^"_ChildWeight_"^"_Height_"^"_BMI_"^"_GrowthAppraisal_"^"_Temperature_"^"_Breath_"^"_Pulse_"^"_Face_"^"_Skin_"^"_Bregma_"^"_Length_"^"_Width_"^"_Eye_"^"_EyeInfo_"^"_Ear_"^"_EarInfo_"^"_Teething_"^"_TeethingInfo_"^"_Nose_"^"_NoseInfo_"^"_Chest_"^"_ChestInfo_"^"_Abdomen_"^"_AbdomenInfo_"^"_UmbilicalReg_"^"_UmbilicalRegInfo_"^"_Limbs_"^"_LimbsInfo_"^"_Gait_"^"_GaitInfo_"^"_JointHip_"^"_JointHipInfo_"^"_PrimReaction_"^"_PrimReactionInfo_"^"_VitaminD_"^"_EyeSight_"^"_Hearing_"^"_Social_"^"_Actions_"^"_bSickLast_"^"_RicketsSym_"^"_RicketsSign_"^"_AnusInfo_"^"_Anus_"^"_GenitaliaInfo_"^"_Genitalia_"^"_HGB_"^"_OutdoorActivity_"^"_bTransfer_"^"_ReasonOfTransfer_"^"_PlaceOfTransfer_"^"_Direction_"^"_DateOfNextCheck_"^"_PlaceOfNextCheck_"^"_FaceName_"^"_SkinName_"^"_BregmaName_"^"_bSickLastName_"^"_RicketsSymName_"^"_RicketsSignName_"^"_EyeName_"^"_EarName_"^"_TeethingName_"^"_NoseName_"^"_ChestName_"^"_AbdomenName_"^"_UmbilicalRegName_"^"_LimbsName_"^"_GaitName_"^"_JointHipName_"^"_PrimReactionName_"^"_AnusName_"^"_GenitaliaName_"^"_DirectionName_"^"_CheckMonthName

	s count=count+1
	i (count>Start)&(count<=end) d
    .d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("RowId^ChildRowId^CheckMonth^DateOfCheck^Doctor^ChildWeight^Height^BMI^GrowthAppraisal^Temperature^Breath^Pulse^Face^Skin^Bregma^Length^Width^Eye^EyeInfo^Ear^EarInfo^Teething^TeethingInfo^Nose^NoseInfo^Chest^ChestInfo^Abdomen^AbdomenInfo^UmbilicalReg^UmbilicalRegInfo^Limbs^LimbsInfo^Gait^GaitInfo^JointHip^JointHipInfo^PrimReaction^PrimReactionInfo^VitaminD^EyeSight^Hearing^Social^Actions^bSickLast^RicketsSym^RicketsSign^AnusInfo^Anus^GenitaliaInfo^Genitalia^HGB^OutdoorActivity^bTransfer^ReasonOfTransfer^PlaceOfTransfer^Direction^DateOfNextCheck^PlaceOfNextCheck^FaceName^SkinName^BregmaName^bSickLastName^RicketsSymName^RicketsSignName^EyeName^EarName^TeethingName^NoseName^ChestName^AbdomenName^UmbilicalRegName^LimbsName^GaitName^JointHipName^PrimReactionName^AnusName^GenitaliaName^DirectionName^CheckMonthName",count)
	k json
	Quit resultString
}

//添加

ClassMethod insert(PersonRowIdParref, ChildRowId, CheckMonth, DateOfCheck, Doctor, Weight, Height, BMI, GrowthAppraisal, Temperature, Breath, Pulse, Face, Skin, Bregma, Length, Width, Eye, EyeInfo, Ear, EarInfo, Teething, TeethingInfo, Nose, NoseInfo, Chest, ChestInfo, Abdomen, AbdomenInfo, UmbilicalReg, UmbilicalRegInfo, Limbs, LimbsInfo, Gait, GaitInfo, JointHip, JointHipInfo, PrimReaction, PrimReactionInfo, VitaminD, EyeSight, Hearing, Social, Actions, bSickLast, RicketsSym, RicketsSign, AnusInfo, Anus, GenitaliaInfo, Genitalia, HGB, OutdoorActivity, bTransfer, ReasonOfTransfer, PlaceOfTransfer, Direction, DateOfNextCheck, PlaceOfNextCheck)
{
	s tempChild = ""
	s tempChild =##class(CHSS.ChildCheckRecord).%New()
	
	i PersonRowIdParref '= "" d
	.s tempChild.PersonRowIdParref = ##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowIdParref)
	
	s tempChild.ChildRowId=ChildRowId
	
	i ChildRowId '= "" d
	s tempChild.ChildRowId=##class(CHSS.ChildBaseInfo).%OpenId(ChildRowId)
	
	s tempChild.CheckMonth=CheckMonth
	
	i DateOfCheck '= "" d
	.s tempChild.DateOfCheck=$zdh(DateOfCheck,3)
	
	s tempChild.Doctor=Doctor
	s tempChild.Weight=Weight
	s tempChild.Height=Height
	s tempChild.BMI=BMI
	s tempChild.GrowthAppraisal=GrowthAppraisal
	s tempChild.Temperature=Temperature
	s tempChild.Breath=Breath
	s tempChild.Pulse=Pulse
	
	i Face'="" d
    .s tempChild.Face=##class(CHSS.DictComplexion).%OpenId(Face)
    
	i Skin'="" d
	.s tempChild.Skin=##class(CHSS.DictChildSkin).%OpenId(Skin)    


	i Bregma'="" d 
	.s tempChild.Bregma=##class(CHSS.DictFontanel).%OpenId(Bregma)    
	s tempChild.Length=Length
	s tempChild.Width=Width
	
	i Eye'="" d 
	.s tempChild.Eye=##class(CHSS.DictPhysique).%OpenId(Eye)
	s tempChild.EyeInfo=EyeInfo
	
	 i Ear'="" d 
    .s tempChild.Ear=##class(CHSS.DictPhysique).%OpenId(Ear)
	s tempChild.EarInfo=EarInfo
	
	
	i Teething'="" d
	.s tempChild.Teething=##class(CHSS.DictPhysique).%OpenId(Teething)
	s tempChild.TeethingInfo=TeethingInfo
	
	i Nose'="" d
	.s tempChild.Nose=##class(CHSS.DictPhysique).%OpenId(Nose)
	s tempChild.NoseInfo=NoseInfo
	
	
	i Chest'="" d
	.s tempChild.Chest=##class(CHSS.DictPhysique).%OpenId(Chest)
	s tempChild.ChestInfo=ChestInfo
	
	
	i Abdomen'="" d
	.s tempChild.Abdomen=##class(CHSS.DictPhysique).%OpenId(Abdomen)
	s tempChild.AbdomenInfo=AbdomenInfo
	
    i UmbilicalReg'="" d
	.s tempChild.UmbilicalReg=##class(CHSS.DictUmbilicalCord).%OpenId(UmbilicalReg)
	s tempChild.UmbilicalRegInfo=UmbilicalRegInfo
	
	
	i Limbs'="" d
	.s tempChild.Limbs=##class(CHSS.DictPhysique).%OpenId(Limbs)
	s tempChild.LimbsInfo=LimbsInfo
	
	i Gait'="" d
	.s tempChild.Gait=##class(CHSS.DictPhysique).%OpenId(Gait)
	s tempChild.GaitInfo=GaitInfo
	
	
	i JointHip'="" d
	.s tempChild.JointHip=##class(CHSS.DictPhysique).%OpenId(JointHip)
	s tempChild.JointHipInfo=JointHipInfo
	
	
	i PrimReaction'="" d
	.s tempChild.PrimReaction=##class(CHSS.DictPhysique).%OpenId(PrimReaction)
	s tempChild.PrimReactionInfo=PrimReactionInfo
	
	
	s tempChild.VitaminD=VitaminD
	s tempChild.EyeSight=EyeSight
	s tempChild.Hearing=Hearing
	s tempChild.Social=Social
	s tempChild.Actions=Actions
	
	i bSickLast'="" d
	.s tempChild.bSickLast=##class(CHSS.DictHaveDiseaseOfTwo).%OpenId(bSickLast)
	
	
	i RicketsSym'="" d
	.s tempChild.RicketsSym=##class(CHSS.DictRicketsSym).%OpenId(RicketsSym)
	
	i RicketsSign'="" d
	.s tempChild.RicketsSign=##class(CHSS.DictRicketSign).%OpenId(RicketsSign)
	s tempChild.AnusInfo=AnusInfo
	
	i Anus'="" d 
	.s tempChild.Anus=##class(CHSS.DictPhysique).%OpenId(Anus)
	s tempChild.GenitaliaInfo=GenitaliaInfo
	
	i Genitalia'=""  d
	.s tempChild.Genitalia=##class(CHSS.DictPhysique).%OpenId(Genitalia)
	
	s tempChild.HGB=HGB
	s tempChild.OutdoorActivity=OutdoorActivity
	s tempChild.bTransfer=bTransfer
	s tempChild.ReasonOfTransfer=ReasonOfTransfer
	s tempChild.PlaceOfTransfer=PlaceOfTransfer
	
	
	i Direction'="" d
	.s tempChild.Direction=##class(CHSS.DictSuggestion).%OpenId(Direction)
	
	i DateOfNextCheck'="" d
	.s DateOfNextCheck=$zdh(DateOfNextCheck,3)
    .s tempChild.DateOfNextCheck=DateOfNextCheck
    
	s tempChild.PlaceOfNextCheck=PlaceOfNextCheck
    
    s result=""
    s result=tempChild.%Save()
    Set resultString = ""
    i result = "1" d
    .s resultString = "{""success"":""true"",""info"":""数据保存成功！""}"
    e  d
    .s resultString = "{""success"":""false"",""info"":""数据保存出错!""}"
    q resultString
}

//修改

ClassMethod update(RowId, PersonRowIdParref, ChildRowId, CheckMonth, DateOfCheck, Doctor, Weight, Height, BMI, GrowthAppraisal, Temperature, Breath, Pulse, Face, Skin, Bregma, Length, Width, Eye, EyeInfo, Ear, EarInfo, Teething, TeethingInfo, Nose, NoseInfo, Chest, ChestInfo, Abdomen, AbdomenInfo, UmbilicalReg, UmbilicalRegInfo, Limbs, LimbsInfo, Gait, GaitInfo, JointHip, JointHipInfo, PrimReaction, PrimReactionInfo, VitaminD, EyeSight, Hearing, Social, Actions, bSickLast, RicketsSym, RicketsSign, AnusInfo, Anus, GenitaliaInfo, Genitalia, HGB, OutdoorActivity, bTransfer, ReasonOfTransfer, PlaceOfTransfer, Direction, DateOfNextCheck, PlaceOfNextCheck)
{
	q:($d(RowId)=0)||(RowId="")
      
    s tempChild="",result=""
    s tempChild=##class(CHSS.ChildCheckRecord).%OpenId(RowId)
    q:(tempChild="") 0	
      
	i PersonRowIdParref '= "" d
	.s tempChild.PersonRowIdParref = ##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowIdParref)
	
	s tempChild.ChildRowId=ChildRowId
	
	i ChildRowId '= "" d
	s tempChild.ChildRowId=##class(CHSS.ChildBaseInfo).%OpenId(ChildRowId)
	
	s tempChild.CheckMonth=CheckMonth
	
	i DateOfCheck '= "" d
	.s tempChild.DateOfCheck=$zdh(DateOfCheck,3)
	
	s tempChild.Doctor=Doctor
	s tempChild.Weight=Weight
	s tempChild.Height=Height
	s tempChild.BMI=BMI
	s tempChild.GrowthAppraisal=GrowthAppraisal
	s tempChild.Temperature=Temperature
	s tempChild.Breath=Breath
	s tempChild.Pulse=Pulse
	
	i Face'="" d
    .s tempChild.Face=##class(CHSS.DictComplexion).%OpenId(Face)
    
	i Skin'="" d
	.s tempChild.Skin=##class(CHSS.DictChildSkin).%OpenId(Skin)    


	i Bregma'="" d 
	.s tempChild.Bregma=##class(CHSS.DictFontanel).%OpenId(Bregma)    
	s tempChild.Length=Length
	s tempChild.Width=Width
	
	i Eye'="" d 
	.s tempChild.Eye=##class(CHSS.DictPhysique).%OpenId(Eye)
	s tempChild.EyeInfo=EyeInfo
	
	 i Ear'="" d 
    .s tempChild.Ear=##class(CHSS.DictPhysique).%OpenId(Ear)
	s tempChild.EarInfo=EarInfo
	
	
	i Teething'="" d
	.s tempChild.Teething=##class(CHSS.DictPhysique).%OpenId(Teething)
	s tempChild.TeethingInfo=TeethingInfo
	
	i Nose'="" d
	.s tempChild.Nose=##class(CHSS.DictPhysique).%OpenId(Nose)
	s tempChild.NoseInfo=NoseInfo
	
	
	i Chest'="" d
	.s tempChild.Chest=##class(CHSS.DictPhysique).%OpenId(Chest)
	s tempChild.ChestInfo=ChestInfo
	
	
	i Abdomen'="" d
	.s tempChild.Abdomen=##class(CHSS.DictPhysique).%OpenId(Abdomen)
	s tempChild.AbdomenInfo=AbdomenInfo
	
    i UmbilicalReg'="" d
	.s tempChild.UmbilicalReg=##class(CHSS.DictUmbilicalCord).%OpenId(UmbilicalReg)
	s tempChild.UmbilicalRegInfo=UmbilicalRegInfo
	
	
	i Limbs'="" d
	.s tempChild.Limbs=##class(CHSS.DictPhysique).%OpenId(Limbs)
	s tempChild.LimbsInfo=LimbsInfo
	
	i Gait'="" d
	.s tempChild.Gait=##class(CHSS.DictPhysique).%OpenId(Gait)
	s tempChild.GaitInfo=GaitInfo
	
	
	i JointHip'="" d
	.s tempChild.JointHip=##class(CHSS.DictPhysique).%OpenId(JointHip)
	s tempChild.JointHipInfo=JointHipInfo
	
	
	i PrimReaction'="" d
	.s tempChild.PrimReaction=##class(CHSS.DictPhysique).%OpenId(PrimReaction)
	s tempChild.PrimReactionInfo=PrimReactionInfo
	
	
	s tempChild.VitaminD=VitaminD
	s tempChild.EyeSight=EyeSight
	s tempChild.Hearing=Hearing
	s tempChild.Social=Social
	s tempChild.Actions=Actions
	
		i bSickLast'="" d
	.s tempChild.bSickLast=##class(CHSS.DictHaveDiseaseOfTwo).%OpenId(bSickLast)
	
	i RicketsSym'="" d
	.s tempChild.RicketsSym=##class(CHSS.DictRicketsSym).%OpenId(RicketsSym)
	
	i RicketsSign'="" d
	.s tempChild.RicketsSign=##class(CHSS.DictRicketSign).%OpenId(RicketsSign)
	s tempChild.AnusInfo=AnusInfo
	
	i Anus'="" d 
	.s tempChild.Anus=##class(CHSS.DictPhysique).%OpenId(Anus)
	s tempChild.GenitaliaInfo=GenitaliaInfo
	
	
	i Genitalia'=""  d
	.s tempChild.Genitalia=##class(CHSS.DictPhysique).%OpenId(Genitalia)
	s tempChild.HGB=HGB
	s tempChild.OutdoorActivity=OutdoorActivity
	s tempChild.bTransfer=bTransfer
	s tempChild.ReasonOfTransfer=ReasonOfTransfer
	s tempChild.PlaceOfTransfer=PlaceOfTransfer
	
	
	i Direction'="" d
	.s tempChild.Direction=##class(CHSS.DictSuggestion).%OpenId(Direction)
	
	i DateOfNextCheck'="" d
	.s DateOfNextCheck=$zdh(DateOfNextCheck,3)
    .s tempChild.DateOfNextCheck=DateOfNextCheck
    
	s tempChild.PlaceOfNextCheck=PlaceOfNextCheck
    
    s result=""
    s result=tempChild.%Save()
    Set resultString = ""
    i result = "1" d
    .s resultString = "{""success"":""true"",""info"":""数据保存成功！""}"
    e  d
    .s resultString = "{""success"":""false"",""info"":""数据保存出错!""}"
    q resultString
}

//删除

ClassMethod delete(RowId)
{
	&sql(delete from CHSS.ChildCheckRecord where %ID =:RowId )
	q SQLCODE
}

Storage Default
{
<Data name="ChildCheckRecordServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.ChildCheckRe8F2D</DataLocation>
<DefaultData>ChildCheckRecordServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.ChildCheckRe8F2D</IdLocation>
<IndexLocation>^CHSSWeb.ChildCheckRe8F2I</IndexLocation>
<StreamLocation>^CHSSWeb.ChildCheckRe8F2S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
