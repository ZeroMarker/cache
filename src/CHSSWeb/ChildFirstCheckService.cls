Class CHSSWeb.ChildFirstCheckService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

//检索

ClassMethod List(ChildRowId, Start, Limit)
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT * FROM CHSS.ChildFirstCheck where ChildRowId = "_ChildRowId
	
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count = 0
	s resultString = ""
	s end = Start+Limit
	
	s json = ##class(Code.JsonObj).%New()
	
	While(result.Next())
	{
	 
	
	 
	 
	 s RowId=result.Data("RowId")
	 s tempChild= ##class(CHSS.ChildFirstCheck).%OpenId(RowId)
	 
	 s PersonRowIdParref=""
	 i tempChild.PersonRowIdParref'="" d
	 .s PersonRowIdParref= tempChild.PersonRowIdParref.%Id()
	 
	
	 s ChildRowId=""
     i tempChild.ChildRowId'="" d
	 .s ChildRowId=tempChild.ChildRowId.%Id()
	 
	 
	 s Temperature=tempChild.Temperature
	 s Breath=tempChild.Breath
	 s Pulse=tempChild.Pulse
	 
	 
	s Face=""
	s FaceName=""
	i tempChild.Face'="" d
	.s Face=tempChild.Face.%Id()
	.s FaceName=tempChild.Face.Description
	 
	 
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
	 
	 s Mouth=""
	 s MouthName=""
	 i tempChild.Mouth'="" d 
	.s Mouth=tempChild.Mouth.%Id()
	.s MouthName=tempChild.Mouth.Description
	 
	 s MouthInfo=tempChild.MouthInfo
	
	 
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
	 
	   s UmbilicalCord=""
	 s UmbilicalCordName=""
	 i tempChild.UmbilicalCord'="" d 
	 .s UmbilicalCord=tempChild.UmbilicalCord.%Id()
	 .s UmbilicalCordName=tempChild.UmbilicalCord.Description
	 
	 
	
	 s Limbs=""
	 s LimbsName=""
	 i tempChild.Limbs'="" d 
	.s Limbs=tempChild.Limbs.%Id()
	.s LimbsName=tempChild.Limbs.Description
	 s LimbsInfo=tempChild.LimbsInfo
	 
	  s Jugular=""
	 s JugularName=""
	 i tempChild.Jugular'="" d 
	.s Jugular=tempChild.Jugular.%Id()
	.s JugularName=tempChild.Jugular.Description
	
	 s JugularInfo=tempChild.JugularInfo
	 
	 
	 s Skin=""
	 s SkinName=""
	 i tempChild.Skin'="" d 
	 .s Skin=tempChild.Skin.%Id()
	 .s SkinName =tempChild.Skin.Description
	 
	 
	
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
	 
	 s BreastFeeding=""
	 s BreastFeedingName=""
	 i tempChild.BreastFeeding'="" d 
	 .s BreastFeeding=tempChild.BreastFeeding.%Id()
	 .s BreastFeedingName =tempChild.BreastFeeding.Description
	 
	   s BackBone=""
	 s BackBoneName=""
	 i tempChild.BackBone'="" d 
	.s BackBone=tempChild.BackBone.%Id()
	.s BackBoneName=tempChild.BackBone.Description
	
	 s BackBoneInfo=tempChild.BackBoneInfo
	 s bTransfer=tempChild.bTransfer
	 s ReasonOfTransfer=tempChild.ReasonOfTransfer
	 s PlaceOfTransfer=tempChild.PlaceOfTransfer
	
	s Direction=""
	s DirectionName=""
	i tempChild.Direction'="" d
	.s Direction=tempChild.Direction.%Id()
	.s DirectionName=tempChild.Direction.Description
	
	
	 s DateOfCheck=tempChild.DateOfCheck
	 i DateOfCheck'= "" d
	 .s DateOfCheck=$zd(DateOfCheck,3)
	
	 s Doctor=tempChild.Doctor
	 s DateOfNextCheck=tempChild.DateOfNextCheck
	 i DateOfNextCheck'= "" d
	.s DateOfNextCheck = $zd(DateOfNextCheck,3)
	
    s PlaceOfNextCheck=tempChild.PlaceOfNextCheck
    
    s GestationalWeeks=tempChild.GestationalWeeks
    s BirthHospital=tempChild.BirthHospital
    
     s NewbornAsphy=""
	 s NewbornAsphyName=""
	 i tempChild.NewbornAsphy'="" d 
	 .s NewbornAsphy=tempChild.NewbornAsphy.%Id()
	 .s NewbornAsphyName =tempChild.NewbornAsphy.Description
     s bDeformity=tempChild.bDeformity
   
     s NewbornHearing=""
	 s NewbornHearingName=""
	 i tempChild.NewbornHearing'="" d 
	 .s NewbornHearing=tempChild.NewbornHearing.%Id()
	 .s NewbornHearingName =tempChild.NewbornHearing.Description

    s NewbornWeight=tempChild.NewbornWeight
    s Bregma1=tempChild.Bregma1
    s Bregma2=tempChild.Bregma2
    
    
   
     s BregmaInfo=""
	 s BregmaInfoName=""
	 i tempChild.BregmaInfo'="" d 
	 .s BregmaInfo=tempChild.BregmaInfo.%Id()
	 .s BregmaInfoName =tempChild.BregmaInfo.Description
    /*
	s tmp=""
	s tmp=RowId_"^"_PersonRowIdParref_"^"_ChildRowId
	s tmp=tmp_"^"_Temperature_"^"_Breath_"^"_Pulse
	s tmp=tmp_Face_"^"_Eye_"^"_EyeInfo_"^"_Ear_"^"_EarInfo
	s tmp=tmp_"^"_Mouth_"^"_MouthInfo_"^"_Nose_"^"_NoseInfo
	s tmp=tmp_"^"_Chest_"^"_ChestInfo_"^"_Abdomen_"^"_AbdomenInfo
	s tmp=tmp_"^"_UmbilicalCord_"^"_Limbs_"^"_LimbsInfo_"^"_Jugular
	s tmp=tmp_"^"_JugularInfo_"^"_Skin_"^"_Anus_"^"_AnusInfo_"^"_Genitalia
	s tmp=tmp_"^"_GenitaliaInfo_"^"_BreastFeeding_"^"_BackBone_"^"_BackBoneInfo
	s tmp=tmp_"^"_bTransfer_"^"_ReasonOfTransfer_"^"_PlaceOfTransfer
	s tmp=tmp_"^"_Direction_"^"_DateOfCheck_"^"_Doctor_"^"_DateOfNextCheck
	s tmp=tmp_"^"_PlaceOfNextCheck_"^"_FaceName_"^"_UmbilicalCordName
	s tmp=tmp_"^"_SkinName_"^"_BreastFeedingName_"^"_GenitaliaName_"^"_EyeName
	s tmp=tmp_"^"_EarName_"^"_MouthName_"^"_NoseName_"^"_ChestName
	s tmp=tmp_"^"_AbdomenName_"^"_JugularName_"^"_LimbsName_"^"_AnusName
	s tmp=tmp_"^"_BackBoneName_"^"_DirectionName
	*/
	s tmp = RowId_"^"_PersonRowIdParref_"^"_ChildRowId_"^"_Temperature_"^"_Breath_"^"_Pulse_"^"_Face_"^"_Eye_"^"_EyeInfo_"^"_Ear_"^"_EarInfo_"^"_Mouth_"^"_MouthInfo_"^"_Nose_"^"_NoseInfo_"^"_Chest_"^"_ChestInfo_"^"_Abdomen_"^"_AbdomenInfo_"^"_UmbilicalCord_"^"_Limbs_"^"_LimbsInfo_"^"_Jugular_"^"_JugularInfo_"^"_Skin_"^"_Anus_"^"_AnusInfo_"^"_Genitalia_"^"_GenitaliaInfo_"^"_BreastFeeding_"^"_BackBone_"^"_BackBoneInfo_"^"_bTransfer_"^"_ReasonOfTransfer_"^"_PlaceOfTransfer_"^"_Direction_"^"_DateOfCheck_"^"_Doctor_"^"_DateOfNextCheck_"^"_PlaceOfNextCheck_"^"_FaceName_"^"_UmbilicalCordName_"^"_SkinName_"^"_BreastFeedingName_"^"_GenitaliaName_"^"_EyeName_"^"_EarName_"^"_MouthName_"^"_NoseName_"^"_ChestName_"^"_AbdomenName_"^"_JugularName_"^"_LimbsName_"^"_AnusName_"^"_BackBoneName_"^"
	_DirectionName_"^"_GestationalWeeks_"^"_BirthHospital_"^"_NewbornAsphy_"^"_NewbornAsphyName_"^"_bDeformity_"^"_NewbornHearing_"^"_NewbornHearingName_"^"_NewbornWeight_"^"_Bregma1_"^"_Bregma2_"^"_BregmaInfo_"^"_BregmaInfoName

	
	s count = count+1
	i (count>Start)&(count<=end) d
	.d json.InsertRowData(tmp)
	
	}
	d result.Close()
	s resultString = json.getJsonData("RowId^PersonRowIdParref^ChildRowId^Temperature^Breath^Pulse^Face^Eye^EyeInfo^Ear^EarInfo^Mouth^MouthInfo^Nose^NoseInfo^Chest^ChestInfo^Abdomen^AbdomenInfo^UmbilicalCord^Limbs^LimbsInfo^Jugular^JugularInfo^Skin^Anus^AnusInfo^Genitalia^GenitaliaInfo^BreastFeeding^BackBone^BackBoneInfo^bTransfer^ReasonOfTransfer^PlaceOfTransfer^Direction^DateOfCheck^Doctor^DateOfNextCheck^PlaceOfNextCheck^FaceName^UmbilicalCordName^SkinName^BreastFeedingName^GenitaliaName^EyeName^EarName^MouthName^NoseName^ChestName^AbdomenName^JugularName^LimbsName^AnusName^BackBoneName^DirectionName^GestationalWeeks^BirthHospital^NewbornAsphy^NewbornAsphyName^bDeformity^NewbornHearing^NewbornHearingName^NewbornWeight^Bregma1^Bregma2^BregmaInfo^BregmaInfoName",count)
	k json	
	Quit resultString
}

//添加

ClassMethod insert(PersonRowIdParref, ChildRowId, Temperature, Breath, Pulse, Face, Eye, EyeInfo, Ear, EarInfo, Mouth, MouthInfo, Nose, NoseInfo, Chest, ChestInfo, Abdomen, AbdomenInfo, UmbilicalCord, Limbs, LimbsInfo, Jugular, JugularInfo, Skin, Anus, AnusInfo, Genitalia, GenitaliaInfo, BreastFeeding, BackBone, BackBoneInfo, bTransfer, ReasonOfTransfer, PlaceOfTransfer, Direction, DateOfCheck, Doctor, DateOfNextCheck, PlaceOfNextCheck, GestationalWeeks, BirthHospital, NewbornAsphy, bDeformity, NewbornHearing, NewbornWeight, Bregma1, Bregma2, BregmaInfo)
{
	s tempChild = ""
	s tempChild =##class(CHSS.ChildFirstCheck).%New()
	
	i PersonRowIdParref '= "" d
	.s tempChild.PersonRowIdParref = ##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowIdParref)
	
	
	i ChildRowId '= "" d
	s tempChild.ChildRowId=##class(CHSS.ChildBaseInfo).%OpenId(ChildRowId)
	
	s tempChild.Temperature=Temperature
	s tempChild.Breath=Breath
	s tempChild.Pulse=Pulse
	
	i Face'="" d
    .s tempChild.Face=##class(CHSS.DictComplexion).%OpenId(Face)
 
	i Eye'="" d 
	.s tempChild.Eye=##class(CHSS.DictPhysique).%OpenId(Eye)
	s tempChild.EyeInfo=EyeInfo
	
    i Ear'="" d 
    .s tempChild.Ear=##class(CHSS.DictPhysique).%OpenId(Ear)
	s tempChild.EarInfo=EarInfo
	
	i Mouth'="" d 
    .s tempChild.Mouth=##class(CHSS.DictPhysique).%OpenId(Mouth)
	
	s tempChild.MouthInfo=MouthInfo
	
	i Nose'="" d
	.s tempChild.Nose=##class(CHSS.DictPhysique).%OpenId(Nose)
	s tempChild.NoseInfo=NoseInfo
	
	
	i Chest'="" d
	.s tempChild.Chest=##class(CHSS.DictPhysique).%OpenId(Chest)
	s tempChild.ChestInfo=ChestInfo
	
	
	i Abdomen'="" d
	.s tempChild.Abdomen=##class(CHSS.DictPhysique).%OpenId(Abdomen)
	s tempChild.AbdomenInfo=AbdomenInfo
	
	i UmbilicalCord'="" d
	.s tempChild.UmbilicalCord=##class(CHSS.DictUmbilicalCord).%OpenId(UmbilicalCord)
	
	i Limbs'="" d
	.s tempChild.Limbs=##class(CHSS.DictPhysique).%OpenId(Limbs)
	s tempChild.LimbsInfo=LimbsInfo
	
	i Jugular'="" d
    .s tempChild.Jugular=##class(CHSS.DictPhysique).%OpenId(Jugular)
	s tempChild.JugularInfo=JugularInfo
	
	i Skin'="" d
	.s tempChild.Skin=##class(CHSS.DictChildSkin).%OpenId(Skin)
	
	
	i Anus'="" d
	.s tempChild.Anus=##class(CHSS.DictPhysique).%OpenId(Anus)
	s tempChild.AnusInfo=AnusInfo
	
	
	i Genitalia'="" d 
	.s tempChild.Genitalia=##class(CHSS.DictPhysique).%OpenId(Genitalia)
	s tempChild.GenitaliaInfo=GenitaliaInfo
	
	
	i BreastFeeding'="" d 
	.s tempChild.BreastFeeding=##class(CHSS.DictFeedType).%OpenId(BreastFeeding)
	
	
	i BackBone'="" d
	.s tempChild.BackBone=##class(CHSS.DictPhysique).%OpenId(BackBone)
	s tempChild.BackBoneInfo=BackBoneInfo
	s tempChild.bTransfer=bTransfer
	s tempChild.ReasonOfTransfer=ReasonOfTransfer
	s tempChild.PlaceOfTransfer=PlaceOfTransfer
	
	i Direction'="" d
	.s tempChild.Direction=##class(CHSS.DictSuggestion).%OpenId(Direction)
	
	i DateOfCheck'="" d
	.s DateOfCheck=$zdh(DateOfCheck,3)
	.s tempChild.DateOfCheck=DateOfCheck
	
	s tempChild.Doctor=Doctor
	
	i DateOfNextCheck'="" d
	.s DateOfNextCheck=$zdh(DateOfNextCheck,3)
    .s tempChild.DateOfNextCheck=DateOfNextCheck
    
	s tempChild.PlaceOfNextCheck=PlaceOfNextCheck
    
    
    s tempChild.GestationalWeeks=GestationalWeeks
    s tempChild.BirthHospital=BirthHospital
    
    i NewbornAsphy'="" d
    .s tempChild.NewbornAsphy=##class(CHSS.DictNewbornAsphy).%OpenId(NewbornAsphy)
   
    s tempChild.bDeformity=bDeformity
    
    i NewbornHearing'="" d
    .s tempChild.NewbornHearing=##class(CHSS.DictNewbornHearing).%OpenId(NewbornHearing)
    s tempChild.NewbornWeight=NewbornWeight
    s tempChild.Bregma1=Bregma1
    s tempChild.Bregma2=Bregma2 
    
     i BregmaInfo'="" d
    s tempChild.BregmaInfo=##class(CHSS.DictBregmaInfo).%OpenId(BregmaInfo)
	
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

ClassMethod updata(RowId, PersonRowIdParref, ChildRowId, Temperature, Breath, Pulse, Face, Eye, EyeInfo, Ear, EarInfo, Mouth, MouthInfo, Nose, NoseInfo, Chest, ChestInfo, Abdomen, AbdomenInfo, UmbilicalCord, Limbs, LimbsInfo, Jugular, JugularInfo, Skin, Anus, AnusInfo, Genitalia, GenitaliaInfo, BreastFeeding, BackBone, BackBoneInfo, bTransfer, ReasonOfTransfer, PlaceOfTransfer, Direction, DateOfCheck, Doctor, DateOfNextCheck, PlaceOfNextCheck, GestationalWeeks, BirthHospital, NewbornAsphy, bDeformity, NewbornHearing, NewbornWeight, Bregma1, Bregma2, BregmaInfo)
{
	 q:($d(RowId)=0)||(RowId="")
      
     s tempChild="",result=""
     s tempChild=##class(CHSS.ChildFirstCheck).%OpenId(RowId)
     q:(tempChild="") 0	
      
   i PersonRowIdParref '= "" d
	.s tempChild.PersonRowIdParref = ##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowIdParref)
	
	
	i ChildRowId '= "" d
	s tempChild.ChildRowId=##class(CHSS.ChildBaseInfo).%OpenId(ChildRowId)
	
	s tempChild.Temperature=Temperature
	s tempChild.Breath=Breath
	s tempChild.Pulse=Pulse
	
	i Face'="" d
    .s tempChild.Face=##class(CHSS.DictComplexion).%OpenId(Face)
 
	i Eye'="" d 
	.s tempChild.Eye=##class(CHSS.DictPhysique).%OpenId(Eye)
	s tempChild.EyeInfo=EyeInfo
	
    i Ear'="" d 
    .s tempChild.Ear=##class(CHSS.DictPhysique).%OpenId(Ear)
	s tempChild.EarInfo=EarInfo
	
	i Mouth'="" d 
    .s tempChild.Mouth=##class(CHSS.DictPhysique).%OpenId(Mouth)
	
	s tempChild.MouthInfo=MouthInfo
	
	i Nose'="" d
	.s tempChild.Nose=##class(CHSS.DictPhysique).%OpenId(Nose)
	s tempChild.NoseInfo=NoseInfo
	
	
	i Chest'="" d
	.s tempChild.Chest=##class(CHSS.DictPhysique).%OpenId(Chest)
	s tempChild.ChestInfo=ChestInfo
	
	
	i Abdomen'="" d
	.s tempChild.Abdomen=##class(CHSS.DictPhysique).%OpenId(Abdomen)
	s tempChild.AbdomenInfo=AbdomenInfo
	
	i UmbilicalCord'="" d
	.s tempChild.UmbilicalCord=##class(CHSS.DictUmbilicalCord).%OpenId(UmbilicalCord)
	
	i Limbs'="" d
	.s tempChild.Limbs=##class(CHSS.DictPhysique).%OpenId(Limbs)
	s tempChild.LimbsInfo=LimbsInfo
	
	i Jugular'="" d
    .s tempChild.Jugular=##class(CHSS.DictPhysique).%OpenId(Jugular)
	s tempChild.JugularInfo=JugularInfo
	
	i Skin'="" d
	.s tempChild.Skin=##class(CHSS.DictChildSkin).%OpenId(Skin)
	
	
	i Anus'="" d
	.s tempChild.Anus=##class(CHSS.DictPhysique).%OpenId(Anus)
	s tempChild.AnusInfo=AnusInfo
	
	
	i Genitalia'="" d 
	.s tempChild.Genitalia=##class(CHSS.DictPhysique).%OpenId(Genitalia)
	s tempChild.GenitaliaInfo=GenitaliaInfo
	
	
	i BreastFeeding'="" d 
	.s tempChild.BreastFeeding=##class(CHSS.DictFeedType).%OpenId(BreastFeeding)
	
	
	i BackBone'="" d
	.s tempChild.BackBone=##class(CHSS.DictPhysique).%OpenId(BackBone)
	s tempChild.BackBoneInfo=BackBoneInfo
	s tempChild.bTransfer=bTransfer
	s tempChild.ReasonOfTransfer=ReasonOfTransfer
	s tempChild.PlaceOfTransfer=PlaceOfTransfer
	
	i Direction'="" d
	.s tempChild.Direction=##class(CHSS.DictSuggestion).%OpenId(Direction)
	
	i DateOfCheck'="" d
	.s DateOfCheck=$zdh(DateOfCheck,3)
	.s tempChild.DateOfCheck=DateOfCheck
	
	s tempChild.Doctor=Doctor
	
	i DateOfNextCheck'="" d
	.s DateOfNextCheck=$zdh(DateOfNextCheck,3)
    .s tempChild.DateOfNextCheck=DateOfNextCheck
    
	s tempChild.PlaceOfNextCheck=PlaceOfNextCheck
    
       s tempChild.GestationalWeeks=GestationalWeeks
    s tempChild.BirthHospital=BirthHospital
    
    i NewbornAsphy'="" d
    .s tempChild.NewbornAsphy=##class(CHSS.DictNewbornAsphy).%OpenId(NewbornAsphy)
   
    s tempChild.bDeformity=bDeformity
    
    i NewbornHearing'="" d
    .s tempChild.NewbornHearing=##class(CHSS.DictNewbornHearing).%OpenId(NewbornHearing)
    s tempChild.NewbornWeight=NewbornWeight
    s tempChild.Bregma1=Bregma1
    s tempChild.Bregma2=Bregma2 
     i BregmaInfo'="" d
    s tempChild.BregmaInfo=##class(CHSS.DictBregmaInfo).%OpenId(BregmaInfo)
	
    s result=""
    s result=tempChild.%Save()
    Set resultString = ""
    i result = "1" d
    .s resultString = "{""success"":""true"",""info"":""数据保存成功！""}"
    e  d
    .s resultString = "{""success"":""false"",""info"":""数据保存出错!""}"
    q resultString
}

Storage Default
{
<Data name="ChildFirstCheckServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.ChildFirstCh89BD</DataLocation>
<DefaultData>ChildFirstCheckServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.ChildFirstCh89BD</IdLocation>
<IndexLocation>^CHSSWeb.ChildFirstCh89BI</IndexLocation>
<StreamLocation>^CHSSWeb.ChildFirstCh89BS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
