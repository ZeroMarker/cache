Class CHSSWeb.HISInterface.PersonOrganCheckRecordInfoService Extends %Persistent
{

/// Creator:jinming
/// CreateDate:2011-05-20
ClassMethod PersonOrganCheckRecordInfo(personRowId As %String, checkRowId As %String) As %String
{
	Set PersonRowId = $G(personRowId)
	s checkRowId = $g(checkRowId)
	Set resultString = ""
	set reportData=""
	i $d(^CHSS.PersonYearCheckRecordI("PersonRowIdParrefIndex",PersonRowId,checkRowId)) d
	.s reportData = ##class(CHSSWeb.HISInterface.PersonOrganCheckRecordInfo).%New()
	.Set tempCheck = ##class(CHSS.PersonYearCheckRecord).%OpenId(checkRowId)
	.s reportData.YearCheckRowId = checkRowId
	.Set reportData.LeftEyesight =   tempCheck.LeftEyesight
	.Set reportData.RightEyesight =  tempCheck.RightEyesight
	.Set reportData.LeftCorrectEyesight = tempCheck.LeftCorrectEyesight
	.Set reportData.RightCorrectEyesight = tempCheck.RightCorrectEyesight
	.Set reportData.Hearing = ""
	.Set reportData.HearingId = ""
	.if tempCheck.Hearing '= "" do
	..Set reportData.Hearing = tempCheck.Hearing.Description
	..Set reportData.HearingId = tempCheck.Hearing.%Id()	
	.Set reportData.Movement = ""
	.Set reportData.MovementId = ""
	.if tempCheck.Movement '= "" do
	..Set reportData.Movement = tempCheck.Movement.Description
	..Set reportData.MovementId = tempCheck.Movement.%Id()	
	.Set reportData.Skin = ""
	.Set reportData.SkinId = ""
	.if tempCheck.Skin '= "" do
	..Set reportData.Skin = tempCheck.Skin.Description
	..Set reportData.SkinId = tempCheck.Skin.%Id()	
	.Set reportData.Scrofula = ""
	.Set reportData.ScrofulaId = ""
	.if tempCheck.Scrofula '= "" do
	..Set reportData.Scrofula = tempCheck.Scrofula.Description
	..Set reportData.ScrofulaId = tempCheck.Scrofula.%Id()		
	.Set reportData.ScrofulaOther = tempCheck.ScrofulaOther	
	.Set reportData.bBarrelChest = ""
	.Set reportData.bBarrelChestId = ""
	.if tempCheck.bBarrelChest '= "" do
	..Set reportData.bBarrelChest = tempCheck.bBarrelChest.Description
	..Set reportData.bBarrelChestId = tempCheck.bBarrelChest.%Id()					
	.Set reportData.BreathSounds = tempCheck.BreathSounds
	.Set reportData.BreathSoundsInfo = tempCheck.BreathSoundsInfo
	.Set reportData.Rale = tempCheck.Rale
	.Set reportData.RaleInfo = tempCheck.RaleInfo
	.Set reportData.HeartRate = tempCheck.HeartRate	
	.Set reportData.CardiacRhythm = ""
	.Set reportData.CardiacRhythmId = ""
	.if tempCheck.CardiacRhythm '= "" do
	..Set reportData.CardiacRhythm =   tempCheck.CardiacRhythm.Description
	..Set reportData.CardiacRhythmId = tempCheck.CardiacRhythm.%Id()	
	.Set reportData.Souffle = tempCheck.Souffle
	.Set reportData.SouffleInfo = tempCheck.SouffleInfo
	.Set reportData.Tenderness = tempCheck.Tenderness
	.Set reportData.TendernessInfo =  tempCheck.TendernessInfo
	.Set reportData.EnclosedMass =   tempCheck.EnclosedMass
	.Set reportData.EnclosedMassInfo = tempCheck.EnclosedMassInfo
	.Set reportData.Hepatauxe = tempCheck.Hepatauxe
	.Set reportData.HepatauxeInfo = tempCheck.HepatauxeInfo
	.Set reportData.Splenomegaly =  tempCheck.Splenomegaly
	.Set reportData.SplenomegalyInfo =  tempCheck.SplenomegalyInfo
	.Set reportData.ShiftingDullness = tempCheck.ShiftingDullness
	.Set reportData.ShiftingDullnessInfo = tempCheck.ShiftingDullnessInfo	
	.Set reportData.EdemaOfLimbs = ""
	.Set reportData.EdemaOfLimbsId = ""
	.if tempCheck.EdemaOfLimbs '= "" do
	..Set reportData.EdemaOfLimbs = tempCheck.EdemaOfLimbs.Description
	..Set reportData.EdemaOfLimbsId = tempCheck.EdemaOfLimbs.%Id()	
	.Set reportData.Anus = ""
	.Set reportData.AnusId = ""
	.if tempCheck.Anus '= "" do
	..Set reportData.Anus = tempCheck.Anus.Description
	..Set reportData.AnusId = tempCheck.Anus.%Id()
	.Set reportData.AnusOther = tempCheck.AnusOther
	.Set reportData.Prostate = ""
	.Set reportData.ProstateId = ""
	.if tempCheck.Prostate '= "" do
	..Set reportData.Prostate = tempCheck.Prostate.Description
	..Set reportData.ProstateId = tempCheck.Prostate.%Id()	
	.Set reportData.ProstateInfo = tempCheck.ProstateInfo
	.Set reportData.OrganOther = tempCheck.Other
	.s reportData.OralLips = tempCheck.OralLips
	.s reportData.Dentition = ""
	.s reportData.DentitionName = ""
	.if tempCheck.Dentition '= "" do
	..Set reportData.DentitionName = tempCheck.Dentition.Description
	..Set reportData.Dentition = tempCheck.Dentition.%Id()
	.s reportData.PharyngealCheck = tempCheck.PharyngealCheck
    .s reportData.VaginaInflammationName = ""
    .s reportData.VaginaInflammation = ""
    .i tempCheck.VaginaInflammation '= "" d
    ..s reportData.VaginaInflammation = tempCheck.VaginaInflammation.%Id()
    ..s reportData.VaginaInflammationName = tempCheck.VaginaInflammation.Description      
    .s reportData.VaginaInflammationDes = tempCheck.VaginaInflammationDes      
    .s reportData.CervicitisName = ""
    .s reportData.Cervicitis = ""
    .i tempCheck.Cervicitis '= "" d
    ..s reportData.Cervicitis = tempCheck.Cervicitis.%Id()
    ..s reportData.CervicitisName = tempCheck.Cervicitis.Description      
    .s reportData.CervicitisDes = tempCheck.CervicitisDes      
    .s reportData.DoubleWombsName = ""
    .s reportData.DoubleWombs = ""
    .i tempCheck.DoubleWombs '= "" d
    ..s reportData.DoubleWombs = tempCheck.DoubleWombs.%Id()
    ..s reportData.DoubleWombsName = tempCheck.DoubleWombs.Description      
    .s reportData.DoubleWombsDes = tempCheck.DoubleWombsDes      
    .s reportData.UterineFibroidsName = ""
    .s reportData.UterineFibroids = ""
    .i tempCheck.UterineFibroids '= "" d
    ..s reportData.UterineFibroids = tempCheck.UterineFibroids.%Id()
    ..s reportData.UterineFibroidsName = tempCheck.UterineFibroids.Description      
    .s reportData.UterineFibroidsDes = tempCheck.UterineFibroidsDes      
    .s reportData.AccessaryTumourName = ""
    .s reportData.AccessaryTumour = ""
    .i tempCheck.AccessaryTumour '= "" d
    ..s reportData.AccessaryTumour = tempCheck.AccessaryTumour.%Id()
    ..s reportData.AccessaryTumourName = tempCheck.AccessaryTumour.Description      
    .s reportData.AccessaryTumourDes = tempCheck.AccessaryTumourDes
    .s reportData.Galactophore = ""
    .i tempCheck.Galactophore '= "" d
    ..s reportData.Galactophore = tempCheck.Galactophore
    .s reportData.Sclera = tempCheck.Sclera
	
	.s cdef = ##class(%Dictionary.ClassDefinition).%OpenId("CHSSWeb.HISInterface.PersonOrganCheckRecordInfo") 	
	.s countProperties = cdef.Properties.Count()
	.s returnData = "<PYCRecord>"
	.f i = 1:1:countProperties d
    ..s returnData = returnData_"<"_cdef.Properties.GetAt(i).Name_">"_$ZOBJPROPERTY(reportData,cdef.Properties.GetAt(i).Name)_"</"_cdef.Properties.GetAt(i).Name_">"
 	.s returnData = returnData_"</PYCRecord>"
	q returnData
}

Storage Default
{
<Data name="PersonOrganCheckRecordInfoServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.HIS6F2.PersonOrganCD08D</DataLocation>
<DefaultData>PersonOrganCheckRecordInfoServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.HIS6F2.PersonOrganCD08D</IdLocation>
<IndexLocation>^CHSSWeb.HIS6F2.PersonOrganCD08I</IndexLocation>
<StreamLocation>^CHSSWeb.HIS6F2.PersonOrganCD08S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
