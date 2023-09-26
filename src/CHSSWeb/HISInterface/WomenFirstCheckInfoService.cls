Class CHSSWeb.HISInterface.WomenFirstCheckInfoService Extends %Persistent
{

/// Creator:jinming
/// CreateDate:2011-06-01
/// Description:第1次产前随访服务记录表
ClassMethod WomenFirstCheckInfo(womanRowId As %String) As %String
{
	s womanRowId = $g(womanRowId)
    s count=0
    s FirstCheckRowId = 0
    s reportData = ""
    s returnData = ""
    f  s FirstCheckRowId=$o(^CHSS.WomenFirstCheckI("WomanRowIdParrefIndex",womanRowId,FirstCheckRowId)) q:FirstCheckRowId=""  d    
    .s tempWomenFirstCheck=##class(CHSS.WomenFirstCheck).%OpenId(FirstCheckRowId)    
    .s reportData = ##class(CHSSWeb.HISInterface.WomenFirstCheckInfo).%New()
    .s reportData.FirstCheckRowId = FirstCheckRowId
    .s reportData.WomanRowId = womanRowId
    .; 检查信息
    .s reportData.CheckUnit = tempWomenFirstCheck.CheckUnit      
    .s reportData.CheckDate = tempWomenFirstCheck.CheckDate
    .i reportData.CheckDate '= "" d
    ..s reportData.CheckDate = $zd(reportData.CheckDate,3)      
    .s reportData.FinishTableDoctor = tempWomenFirstCheck.FinishTable      
    .s reportData.OperatorName = ""
    .s reportData.Operator = ""
    .i tempWomenFirstCheck.Operator '= "" d
    ..s reportData.Operator = tempWomenFirstCheck.Operator.%Id()
    ..s reportData.OperatorName = tempWomenFirstCheck.Operator.SSUSRName      
    .s reportData.OperateTime = tempWomenFirstCheck.OperateTime
    .i reportData.OperateTime '= "" d
    ..s reportData.OperateTime = $zd(reportData.OperateTime,3)          
    .; 孕产基本信息
    .s reportData.FVTADDate = tempWomenFirstCheck.FVTADDate
    .i reportData.FVTADDate '= "" d
    ..s reportData.FVTADDate = $zd(reportData.FVTADDate,3)     
    .s reportData.LastEmmeniaDate = tempWomenFirstCheck.LastEmmeniaDate
    .i reportData.LastEmmeniaDate '= "" d
    ..s reportData.LastEmmeniaDate = $zd(reportData.LastEmmeniaDate,3)     
    .s reportData.FCWeekforPreg = tempWomenFirstCheck.FCWeekforPreg    
    .s reportData.EstimateBDate = tempWomenFirstCheck.EstimateBDate
    .i reportData.EstimateBDate '= "" d
    ..s reportData.EstimateBDate = $zd(reportData.EstimateBDate,3)    
    .s reportData.PregnancyNum = tempWomenFirstCheck.PregnancyNum
    .s reportData.BearingNum = tempWomenFirstCheck.BearingNum          
    .; 既往孕产史
    .s reportData.PrematureLaborNum = tempWomenFirstCheck.PrematureLaborNum
    .s reportData.OpsBearingNum = tempWomenFirstCheck.OpsBearingNum
    .s reportData.NaAbortionNum = tempWomenFirstCheck.NaAbortionNum
    .s reportData.AbortionNum = tempWomenFirstCheck.AbortionNum
    .s reportData.OtherPregHis = tempWomenFirstCheck.OtherPregHis           
    .; 本次妊娠早孕期异常情况
    .s reportData.AbPregDes = tempWomenFirstCheck.AbPregDes     
    .s reportData.DateOfFirstCheck = tempWomenFirstCheck.DateOfFirstCheck
    .i reportData.DateOfFirstCheck '= "" d
    ..s reportData.DateOfFirstCheck = $zd(reportData.DateOfFirstCheck,3)            
    .; 基本身体检查
    .s reportData.BlPressureUnitName = ""
    .s reportData.BlPressureUnit = ""
    .i tempWomenFirstCheck.BlPressureUnit '= "" d
    ..s reportData.BlPressureUnit = tempWomenFirstCheck.BlPressureUnit.%Id()
    ..s reportData.BlPressureUnitName = tempWomenFirstCheck.BlPressureUnit.Description     
    .s reportData.HighBlPressure = tempWomenFirstCheck.HighBlPressure
    .s reportData.LowBlPressure = tempWomenFirstCheck.LowBlPressure
    .s reportData.Height = tempWomenFirstCheck.Height
    .s reportData.Weight = tempWomenFirstCheck.Weight
    .s reportData.BMI = tempWomenFirstCheck.BMI     
    .s reportData.HeartName = ""
    .s reportData.Heart = ""
    .i tempWomenFirstCheck.Heart '= "" d
    ..s reportData.Heart = tempWomenFirstCheck.Heart.%Id()
    ..s reportData.HeartName = tempWomenFirstCheck.Heart.Description     
    .s reportData.HeartAbDes = tempWomenFirstCheck.HeartAbDes    
    .s reportData.LungName = ""
    .s reportData.Lung = ""
    .i tempWomenFirstCheck.Lung '= "" d
    ..s reportData.Lung = tempWomenFirstCheck.Lung.%Id()
    ..s reportData.LungName = tempWomenFirstCheck.Lung.Description     
    .s reportData.LungAbDes = tempWomenFirstCheck.LungAbDes          
    .; 妇科检查
    .s reportData.VaginaInflammationName = ""
    .s reportData.VaginaInflammation = ""
    .i tempWomenFirstCheck.VaginaInflammation '= "" d
    ..s reportData.VaginaInflammation = tempWomenFirstCheck.VaginaInflammation.%Id()
    ..s reportData.VaginaInflammationName = tempWomenFirstCheck.VaginaInflammation.Description    
    .s reportData.VaginaInflammationDes = tempWomenFirstCheck.VaginaInflammationDes    
    .s reportData.CervicitisName = ""
    .s reportData.Cervicitis = ""
    .i tempWomenFirstCheck.Cervicitis '= "" d
    ..s reportData.Cervicitis = tempWomenFirstCheck.Cervicitis.%Id()
    ..s reportData.CervicitisName = tempWomenFirstCheck.Cervicitis.Description      
    .s reportData.CervicitisDes = tempWomenFirstCheck.CervicitisDes     
    .s reportData.DoubleWombsName = ""
    .s reportData.DoubleWombs = ""
    .i tempWomenFirstCheck.DoubleWombs '= "" d
    ..s reportData.DoubleWombs = tempWomenFirstCheck.DoubleWombs.%Id()
    ..s reportData.DoubleWombsName = tempWomenFirstCheck.DoubleWombs.Description     
    .s reportData.DoubleWombsDes = tempWomenFirstCheck.DoubleWombsDes    
    .s reportData.UterineFibroidsName = ""
    .s reportData.UterineFibroids = ""
    .i tempWomenFirstCheck.UterineFibroids '= "" d
    ..s reportData.UterineFibroids = tempWomenFirstCheck.UterineFibroids.%Id()
    ..s reportData.UterineFibroidsName = tempWomenFirstCheck.UterineFibroids.Description      
    .s reportData.UterineFibroidsDes = tempWomenFirstCheck.UterineFibroidsDes    
    .s reportData.AccessaryTumourName = ""
    .s reportData.AccessaryTumour = ""
    .i tempWomenFirstCheck.AccessaryTumour '= "" d
    ..s reportData.AccessaryTumour = tempWomenFirstCheck.AccessaryTumour.%Id()
    ..s reportData.AccessaryTumourName = tempWomenFirstCheck.AccessaryTumour.Description     
    .s reportData.AccessaryTumourDes = tempWomenFirstCheck.AccessaryTumourDes
    .s reportData.OtherGynecologyDes = tempWomenFirstCheck.OtherGynecologyDes          
    .; 子宫大小与孕周相符
    .s reportData.Compare = tempWomenFirstCheck.Compare
    .s reportData.CompareDes = tempWomenFirstCheck.CompareDes           
    .; 辅助检查
    .s reportData.Hemoglobin = tempWomenFirstCheck.Hemoglobin
    .s reportData.UrineProtein = tempWomenFirstCheck.UrineProtein
    .s reportData.UrineSugar = tempWomenFirstCheck.UrineSugar      
    .s reportData.AFPName = ""
    .s reportData.AFP = ""
    .i tempWomenFirstCheck.AFP '= "" d
    ..s reportData.AFP = tempWomenFirstCheck.AFP.%Id()
    ..s reportData.AFPName = tempWomenFirstCheck.AFP.Description    
    .s reportData.GPTALTName = ""
    .s reportData.GPTALT = ""
    .i tempWomenFirstCheck.GPTALT '= "" d
    ..s reportData.GPTALT = tempWomenFirstCheck.GPTALT.%Id()
    ..s reportData.GPTALTName = tempWomenFirstCheck.GPTALT.Description     
    .s reportData.GPTALTAbDes = tempWomenFirstCheck.GPTALTAbDes
    .s reportData.LiverFunction = tempWomenFirstCheck.LiverFunction
    .s reportData.RenalFunction = tempWomenFirstCheck.RenalFunction
    .s reportData.VaginalDischarge = tempWomenFirstCheck.VaginalDischarge      
    .s reportData.HBsAgName = ""
    .s reportData.HBsAg = ""
    .i tempWomenFirstCheck.HBsAg '= "" d
    ..s reportData.HBsAg = tempWomenFirstCheck.HBsAg.%Id()
    ..s reportData.HBsAgName = tempWomenFirstCheck.HBsAg.Description     
    .s reportData.ABOName = ""
    .s reportData.ABO = ""
    .i tempWomenFirstCheck.ABO '= "" d
    ..s reportData.ABO = tempWomenFirstCheck.ABO.%Id()
    ..s reportData.ABOName = tempWomenFirstCheck.ABO.BLDTDesc     
    .s reportData.LuesResultName = ""
    .s reportData.LuesResult = ""
    .i tempWomenFirstCheck.LuesResult '= "" d
    ..s reportData.LuesResult = tempWomenFirstCheck.LuesResult.%Id()
    ..s reportData.LuesResultName = tempWomenFirstCheck.LuesResult.Description     
    .s reportData.HIVResultName = ""
    .s reportData.HIVResult = ""
    .i tempWomenFirstCheck.HIVResult '= "" d
    ..s reportData.HIVResult = tempWomenFirstCheck.HIVResult.%Id()
    ..s reportData.HIVResultName = tempWomenFirstCheck.HIVResult.Description      
    .s reportData.OtherCheckDes = tempWomenFirstCheck.OtherCheckDes     
    .; 其他信息
    .s reportData.DangerGradeName = ""
    .s reportData.DangerGrade = ""
    .i tempWomenFirstCheck.DangerGrade '= "" d
    ..s reportData.DangerGrade = tempWomenFirstCheck.DangerGrade.%Id()
    ..s reportData.DangerGradeName = tempWomenFirstCheck.DangerGrade.Description      
    .s reportData.CDangerDes = tempWomenFirstCheck.CDangerDes    
    .s reportData.AbPregResultName = ""
    .s reportData.AbPregResult = ""
    .i tempWomenFirstCheck.AbPregResult '= "" d
    ..s reportData.AbPregResult = tempWomenFirstCheck.AbPregResult.%Id()
    ..s reportData.AbPregResultName = tempWomenFirstCheck.AbPregResult.Description     
    .s reportData.MisbirthDate = tempWomenFirstCheck.MisbirthDate
    .i reportData.MisbirthDate '= "" d
    ..s reportData.MisbirthDate = $zd(reportData.MisbirthDate,3)     
    .s reportData.Suggestion = tempWomenFirstCheck.Suggestion    
    .s reportData.PreDate = tempWomenFirstCheck.PreDate
    .i reportData.PreDate '= "" d
    ..s reportData.PreDate = $zd(reportData.PreDate,3)     
    .s tempPastHistory = tempWomenFirstCheck.PastHistory
    .s reportData.PastHistory = ##class(CHSSWeb.HISInterface.DictQuery).GetDictQuery(tempPastHistory,"DictWomenPastHistory")
    .s tempFamilyHistory = tempWomenFirstCheck.FamilyHistory
    .s reportData.FamilyHistory = ##class(CHSSWeb.HISInterface.DictQuery).GetDictQuery(tempFamilyHistory,"DictWomenFamilyHistory")
    .s reportData.DyingFetus = tempWomenFirstCheck.DyingFetus
    .s reportData.StillBirth = tempWomenFirstCheck.StillBirth
    .s reportData.NeonatalDeath = tempWomenFirstCheck.NeonatalDeath
    .s reportData.HemocytesNum = tempWomenFirstCheck.HemocytesNum
    .s reportData.PLTNum = tempWomenFirstCheck.PLTNum
    .s reportData.BloodRoutineOther = tempWomenFirstCheck.BloodRoutineOther
    .s reportData.URTOther = tempWomenFirstCheck.URTOther
    .s reportData.GPT = tempWomenFirstCheck.GPT
    .s reportData.AST = tempWomenFirstCheck.AST
    .s reportData.ALB = tempWomenFirstCheck.ALB
    .s reportData.TB = tempWomenFirstCheck.TB
    .s reportData.DBIL = tempWomenFirstCheck.DBIL
    .s reportData.Cr = tempWomenFirstCheck.Cr
    .s reportData.BUN = tempWomenFirstCheck.BUN
    .s reportData.Sk = tempWomenFirstCheck.Sk
    .s reportData.Na = tempWomenFirstCheck.Na
    .s tempVaginalFluid = tempWomenFirstCheck.VaginalFluid
    .s reportData.VaginalFluid = ##class(CHSSWeb.HISInterface.DictQuery).GetDictQuery(tempVaginalFluid,"DictWomenVaginalFluid")
    .s reportData.bTransfer = tempWomenFirstCheck.bTransfer
    .s reportData.TransferReason = tempWomenFirstCheck.TransferReason
    .s reportData.TransferDept = tempWomenFirstCheck.TransferDept
    .s reportData.bOPS = tempWomenFirstCheck.bOPS
    .s reportData.WomenOPS = tempWomenFirstCheck.WomenOPS
    .s reportData.UrineKetone = tempWomenFirstCheck.UrineKetone
    .s reportData.BLD = tempWomenFirstCheck.BLD
    .; 处理数据
    .s cdef = ##class(%Dictionary.ClassDefinition).%OpenId("CHSSWeb.HISInterface.WomenFirstCheckInfo") 	
	.s count = cdef.Properties.Count()
	.s returnData = "<WomenFirstCheck>"
	.f i = 1:1:count d
    ..s returnData = returnData_"<"_cdef.Properties.GetAt(i).Name_">"_$ZOBJPROPERTY(reportData,cdef.Properties.GetAt(i).Name)_"</"_cdef.Properties.GetAt(i).Name_">"
 	.s returnData = returnData_"</WomenFirstCheck>"
	q returnData
}

/// Creator:jinming
/// CreateDate:2011-06-02
/// Description:在第1次产前随访服务记录表获取‘总体评估’字段
ClassMethod WomenFCE(firstCheckRowId As %String) As %String
{
	s firstCheckRowId = $g(firstCheckRowId)
	s result = ##class(%ResultSet).%New()
	s sqlStr = "SELECT RowId,EvalRowIdParref,EvalContent FROM CHSS.WhFirstCheckEval where  FirstCheckRowIdParref ="_firstCheckRowId
	d result.Prepare(sqlStr)
	d result.Execute()		
	Set count=0
	Set resultString = ""	
	set tmp = ""
	set startStr = ""	
	While(result.Next())
	{
	s RowId = result.Data("RowId")
	s EvalRowIdParref= result.Data("EvalRowIdParref")
	s EvalContent= result.Data("EvalContent")
	Set tmp = tmp_startStr_EvalContent
	s startStr = "<br/>"	
	}	
	s returnData = "<WomenFCE><Info><![CDATA["_tmp_"]]></Info></WomenFCE>"
	q returnData
}

Storage Default
{
<Data name="WomenFirstCheckInfoServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.HIS6F2.WomenFirstChA49D</DataLocation>
<DefaultData>WomenFirstCheckInfoServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.HIS6F2.WomenFirstChA49D</IdLocation>
<IndexLocation>^CHSSWeb.HIS6F2.WomenFirstChA49I</IndexLocation>
<StreamLocation>^CHSSWeb.HIS6F2.WomenFirstChA49S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
