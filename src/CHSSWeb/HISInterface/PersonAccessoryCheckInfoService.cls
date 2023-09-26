Class CHSSWeb.HISInterface.PersonAccessoryCheckInfoService Extends %Persistent
{

/// Creator:jinming
/// CreateDate:2011-05-23
/// Description:辅助检查
ClassMethod PersonAccessoryCheckInfo(personRowId As %String, checkRowId As %String) As %String
{
	Set checkRowId = $G(checkRowId)
	set personRowId = $g(personRowId)
	Set AccessoryRowId = 0	
	set returnData = ""
	set reportData = ""
	s count = 0
	For  Set AccessoryRowId = $O(^CHSS.PersonYearCheckAccessoryI("YearCheckRowIdParrefIndex",checkRowId,AccessoryRowId)) q:AccessoryRowId=""  d
	.s reportData = ##class(CHSSWeb.HISInterface.PersonAccessoryCheckInfo).%New()
	.Set tempCheck = ##class(CHSS.PersonYearCheckAccessory).%OpenId(AccessoryRowId)	
	.s reportData.AccessoryRowId = AccessoryRowId
	.Set reportData.HB = tempCheck.HB
	.Set reportData.WBC = tempCheck.WBC
	.Set reportData.PLT = tempCheck.PLT
	.Set reportData.CBCOther = tempCheck.CBCOther
	.Set reportData.UrineProtein = tempCheck.UrineProtein
	.Set reportData.UrineSugar = tempCheck.UrineSugar
	.Set reportData.KET = tempCheck.KET
	.Set reportData.OccultBlood = tempCheck.OccultBlood
	.Set reportData.UrineRoutineOther =  tempCheck.UrineRoutineOther	
	.Set reportData.FecalOccultBlood = ""
	.Set reportData.FecalOccultBloodId = ""
	.if tempCheck.FecalOccultBlood '= "" do
	..Set reportData.FecalOccultBlood = tempCheck.FecalOccultBlood.Description
	..Set reportData.FecalOccultBloodId = tempCheck.FecalOccultBlood.%Id()	
	.Set reportData.ALT = tempCheck.ALT
	.Set reportData.AST = tempCheck.AST
	.Set reportData.ALB = tempCheck.ALB
	.Set reportData.TBIL = tempCheck.TBIL
	.Set reportData.DBIL = tempCheck.DBIL
	.Set reportData.Globulin = tempCheck.Globulin
	.Set reportData.GGT = tempCheck.GGT
	.Set reportData.ARP = tempCheck.ARP
	.Set reportData.Scr = tempCheck.Scr
	.Set reportData.BUN = tempCheck.BUN
	.Set reportData.CHO = tempCheck.CHO
	.Set reportData.TG = tempCheck.TG	
	.Set reportData.LDLC = tempCheck.LDLC
	.Set reportData.HDLC = tempCheck.HDLC
	.Set reportData.FPG = tempCheck.FPG
	.Set reportData.PBG = tempCheck.PBG
	.Set reportData.Eyeground = tempCheck.Eyeground	
	.Set reportData.HBsAg = ""
	.Set reportData.HBsAgId = ""
	.if tempCheck.HBsAg '= "" do
	..Set reportData.HBsAg = tempCheck.HBsAg.Description
	..Set reportData.HBsAgId = tempCheck.HBsAg.%Id()	
	.Set reportData.HbsAb = ""
	.Set reportData.HbsAbId = ""
	.if tempCheck.HbsAb '= "" do
	..Set reportData.HbsAb = tempCheck.HbsAb.Description
	..Set reportData.HbsAbId = tempCheck.HbsAb.%Id()	
	.Set reportData.HbAlc = tempCheck.HbAlc
	.Set reportData.EyegroundInfo = tempCheck.EyegroundInfo
	.Set reportData.Cardiogram =  tempCheck.Cardiogram	
	.Set reportData.CardiogramInfo = tempCheck.CardiogramInfo
	.Set reportData.Sternum = tempCheck.Sternum	
	.Set reportData.SternumSource = ""
	.Set reportData.SternumSourceId = ""
	.if tempCheck.SternumSource '= "" do
	..Set reportData.SternumSource = tempCheck.SternumSource.Description
	..Set reportData.SternumSourceId = tempCheck.SternumSource.%Id()	
	.Set reportData.SternumInfo = tempCheck.SternumInfo
	.Set reportData.XRays = tempCheck.XRays
	.Set reportData.XRaysInfo =  tempCheck.XRaysInfo
	.Set reportData.ImageCheck =  tempCheck.ImageCheck
	.Set reportData.Cholesterin = tempCheck.Cholesterin
	.Set reportData.AccessoryOther = tempCheck.OtherCheck
	.Set reportData.PH = tempCheck.PH
	.Set reportData.CEA = tempCheck.CEA
	.Set reportData.AFP = tempCheck.AFP
	
	.s cdef = ##class(%Dictionary.ClassDefinition).%OpenId("CHSSWeb.HISInterface.PersonAccessoryCheckInfo") 	
	.s count = cdef.Properties.Count()
	.s returnData = "<PersonAccessory>"
	.f i = 1:1:count d
    ..s returnData = returnData_"<"_cdef.Properties.GetAt(i).Name_">"_$ZOBJPROPERTY(reportData,cdef.Properties.GetAt(i).Name)_"</"_cdef.Properties.GetAt(i).Name_">"
 	.s returnData = returnData_"</PersonAccessory>"
	q returnData
}

Storage Default
{
<Data name="PersonAccessoryCheckInfoServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.HIS6F2.PersonAccessC5ED</DataLocation>
<DefaultData>PersonAccessoryCheckInfoServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.HIS6F2.PersonAccessC5ED</IdLocation>
<IndexLocation>^CHSSWeb.HIS6F2.PersonAccessC5EI</IndexLocation>
<StreamLocation>^CHSSWeb.HIS6F2.PersonAccessC5ES</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
