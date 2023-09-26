Class CHSSWeb.HISInterface.DiabetesCheckRecordInterface Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// Creator: lyy
/// CreatDate：2010-02-
/// Description:糖尿病档案接口--检索身份证号返回糖尿病人档案信息(HIS调用)
/// Table：DiabetesCheckRecord
/// Input:IDCard
/// Output：
/// Return：
/// Others：
ClassMethod DiabetesCheckRecordData(IDCard As %String)
{
		n (IDCard)
		Set IDCard=$G(IDCard)
		s IDCard=" "_IDCard
		Set start=$G(start)
		Set limit=$G(limit)
		Set sort=$G(sort)
		Set count=0
		Set resultString = ""
		Set end = start+limit
		Set json = ##class(Code.JsonObj).%New()
		set PersonRowId = 0
		s reportData = ""
		set returnData = ""
		set RowId = 0
		Set PersonRowId=$O(^CHSS.PersonHealthRecordMainI("IDCardIndex",IDCard,PersonRowId))
		q:PersonRowId="" ""
	    For  Set RowId=$O(^CHSS.DiabetesCheckRecordI("PersonRowIdParrefIndex",PersonRowId,RowId)) q:RowId=""  d
        .s tempDiabetes=##class(CHSS.DiabetesCheckRecord).%OpenId(RowId)
        .s reportData = ##class(CHSSWeb.HISInterface.DiabetesCheckRecordInfo).%New()
	  	.s DateCheck=""
	  	.s DateCheck=tempDiabetes.DateCheck
		.i DateCheck '= "" d
		..s reportData.DateCheck = $zd(DateCheck,3)
	  	.s DateOfInput=tempDiabetes.DateOfInput
		.i DateOfInput '= "" d
		..s reportData.DateOfInput = $zd(DateOfInput,3)
	    .s reportData.Remark=tempDiabetes.Remark
	    .s reportData.Deal=tempDiabetes.Deal
	    .s reportData.Direction=tempDiabetes.Direction
	    .s reportData.BloodAfterDiningOfTwo=tempDiabetes.BloodAfterDiningOfTwo
	    .s reportData.bAdverseEffects=tempDiabetes.bAdverseEffects
	    .s reportData.BloodSurgeLimosis=tempDiabetes.BloodSurgeLimosis
	    .s reportData.BloodAfterDining=tempDiabetes.BloodAfterDining
	    .s reportData.EatDrug=tempDiabetes.EatDrug
	    .s reportData.bDrink=tempDiabetes.bDrink
	    .s reportData.Hb=tempDiabetes.Hb
	    .s reportData.SugarInDay=tempDiabetes.SugarInDay
	    .s reportData.NOther=tempDiabetes.NOther
	    .s reportData.MentalStatus=tempDiabetes.MentalStatus
	    .s reportData.DrugOfAdverseEffects=tempDiabetes.DrugOfAdverseEffects
	    .s reportData.OtherOfBlood=tempDiabetes.OtherOfBlood
	    .s reportData.HbAlC=tempDiabetes.HbAlC
	    .s reportData.UniteIll=tempDiabetes.UniteIll
	    .s reportData.NAlbumen=tempDiabetes.NAlbumen
        .s reportData.SmokeNum=tempDiabetes.SmokeNum
	    .s reportData.Cholesterin=tempDiabetes.Cholesterin
	    .s reportData.FootArteryThrob=tempDiabetes.FootArteryThrob
	    .s reportData.OtherCheck= tempDiabetes.OtherCheck
	    .s reportData.DrugSideEffect=tempDiabetes.DrugSideEffect
        .s reportData.CheckAdd= tempDiabetes.CheckAdd
	    .s reportData.Exercise= tempDiabetes.Exercise
	 .s reportData.Food= tempDiabetes.Food
	 .s reportData.bSmoke= tempDiabetes.bSmoke
     .s reportData.Symptom= tempDiabetes.Symptom
     .s reportData.OtherSymptom=tempDiabetes.OtherSymptom
     .s reportData.CheckDoctor= tempDiabetes.CheckDoctor
	 .s reportData.ExerciseNum= tempDiabetes.ExerciseNum
	 .s reportData.ExerciseMin= tempDiabetes.ExerciseMin
	 .s reportData.WaistlineStern= tempDiabetes.WaistlineStern
	 .s reportData.Waistline= tempDiabetes.Waistline
	 .s reportData.Stern= tempDiabetes.Stern
	 .s reportData.DrinkQuentity= tempDiabetes.DrinkQuentity
     .s reportData.nHighPressure= tempDiabetes.nHighPressure
     .s reportData.nLowPressure= tempDiabetes.nLowPressure
     .s reportData.HeartRate= tempDiabetes.HeartRate
     .s reportData.Weight= tempDiabetes.Weight
     .s reportData.Height= tempDiabetes.Height
     .s reportData.BMI= tempDiabetes.BMI
     .s reportData.Smoke= tempDiabetes.Smoke
     .s reportData.Drink= tempDiabetes.Drink
     .set ComplyDoctor = ""
     .i tempDiabetes.ComplyDoctor '= "" d
     ..s ComplyDoctor = tempDiabetes.ComplyDoctor.%Id()
     ..s reportData.ComplyDoctor = tempDiabetes.ComplyDoctor.Description
	 .s reportData.CaseType= tempDiabetes.CaseType
	 .s reportData.bCaseTrans= tempDiabetes.bCaseTrans
	 .i tempDiabetes.BloodSurgeRate '= "" d
     ..s BloodSurgeRate = tempDiabetes.BloodSurgeRate.%Id()
     ..s reportData.BloodSurgeRate = tempDiabetes.BloodSurgeRate.Description
     .i tempDiabetes.Eyeground '= "" d
     ..s Eyeground = tempDiabetes.Eyeground.%Id()
     ..s reportData.Eyeground = tempDiabetes.Eyeground.Description
     .i tempDiabetes.MentalityAdjust '= "" d
     ..s MentalityAdjust = tempDiabetes.MentalityAdjust.%Id()
     ..s reportData.MentalityAdjust = tempDiabetes.MentalityAdjust.Description
	 .s reportData.Other= tempDiabetes.Other
	 .s reportData.bTranfer= tempDiabetes.bTranfer
	 .i tempDiabetes.TransferDept '= "" d
     ..s TransferDept = tempDiabetes.TransferDept.%Id()
     ..s reportData.TransferDept = tempDiabetes.TransferDept.Description
	 .s reportData.TransferReason= tempDiabetes.TransferReason
	  .i tempDiabetes.DrugRegularityRate '= "" d
     ..s DrugRegularityRate = tempDiabetes.DrugRegularityRate.%Id()
     ..s reportData.DrugRegularityRate = tempDiabetes.DrugRegularityRate.Description
      .i tempDiabetes.CheckResult '= "" d
     ..s CheckResult = tempDiabetes.CheckResult.%Id()
     ..s reportData.CheckResult = tempDiabetes.CheckResult.Description
	 .s reportData.DoseComplier= tempDiabetes.DoseComplier
	 .s DateOfStopDrink=tempDiabetes.DateOfStopDrink
	 .i DateOfStopDrink '= "" d
	 ..s reportData.DateOfStopDrink = $zd(DateOfStopDrink,3)
	 .s BookingDate=tempDiabetes.BookingDate
	 .i BookingDate '= "" d
	 ..s reportData.BookingDate = $zd(BookingDate,3)
		.s DateOfStopSmoke=tempDiabetes.DateOfStopSmoke
	 .i DateOfStopSmoke '= "" d
	 ..s reportData.DateOfStopSmoke = $zd(DateOfStopSmoke,3)
	 .s reportData.DateOfStopSmoke= DateOfStopSmoke
		.;第二种方法：手工拼写
	    .Set cdef = ##class(%Dictionary.ClassDefinition).%OpenId("CHSSWeb.HISInterface.DiabetesCheckRecordInfo")
 		.s returnData = "<DiabetesCheckRecord>"
		. // get list of properties
		.;Write "---Properties---",!
		.Set count = cdef.Properties.Count()
		.For i = 1:1:count d
    	..s returnData = returnData_"<"_cdef.Properties.GetAt(i).Name_">"_$ZOBJPROPERTY(reportData,cdef.Properties.GetAt(i).Name)_"</"_cdef.Properties.GetAt(i).Name_">"
 		.s returnData = returnData_"</DiabetesCheckRecord>"
		.;如果返回的是LIST，则使用[Collection = list]方式返回列表
		.;d reportReportData.PersonInfo.Insert(reportData)
		;如果是LIST，则返回reportReportData
		
		;if (reportData '= "")
		;{
			;Set status = reportData.XMLExport()
	    ;}    
	  	Quit returnData
}

/// Creator: lyy
/// CreatDate：2010-02-
/// Description: 获得LovCombo下拉框中所有选中项对应的描述值
/// Table：
/// Input: SelectedValue: 下拉框中所有选中项对应的值， TableName: 字典表的名称
/// Output：DisplayValue: 下拉框中所有选中项对应的描述值
/// Return：
/// Others：
ClassMethod GetDisplayValue(SelectedValue As %String, TableName As %String) As %String
{
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT RowId, Description FROM CHSS."_TableName_" "
		
	d result.Prepare(sqlStr)
	d result.Execute()
	
	k DisplayField
	
	While(result.Next()){
 	  
 	  s DisplayField(result.Data("RowId"))=result.Data("Description")
 	  
 	}
 	
 	d result.Close()
 	
 	set num=$l(SelectedValue,",")
 	
  	set DisplayValue=SelectedValue
 	
 	for i=1:1:num d
 	.set value=$p(DisplayValue,",",i)
 	.set $p(DisplayValue,",",i)=DisplayField(value)
 	
 	q DisplayValue
}

/// Creator:jinming
/// CreateDate:2011-05-18
/// Description:根据personRowid返回个人糖尿病随访记录list
ClassMethod DiabetesCheckRecordList(personRowid As %String, start As %String, limit As %String) As %String
{
	Set personRowid=$G(personRowid)
	s start = $g(start)
	s limit = $g(limit)
	Set count=0
	Set resultString = ""
	Set end = start+limit
	Set json = ##class(Code.JsonObj).%New()
	s reportData = ""
	set returnData = ""
	set RowId = 0
	q:personRowid="" ""
    For  Set RowId=$O(^CHSS.DiabetesCheckRecordI("PersonRowIdParrefIndex",personRowid,RowId)) q:RowId=""  d
    .s count=count+1
    .s tempDiabetes=##class(CHSS.DiabetesCheckRecord).%OpenId(RowId)
    .s reportData = ##class(CHSSWeb.HISInterface.DiabetesCheckRecordInfo).%New()
 	.s DateCheck=""
  	.s DateCheck=tempDiabetes.DateCheck
	.i DateCheck '= "" d
	..s reportData.DateCheck = $zd(DateCheck,3)
  	.s DateOfInput=tempDiabetes.DateOfInput
	.i DateOfInput '= "" d
	..s reportData.DateOfInput = $zd(DateOfInput,3)
	.s reportData.CheckType=tempDiabetes.CheckType.Description
    .s reportData.Remark=tempDiabetes.Remark
    .s reportData.Deal=tempDiabetes.Deal
    .s reportData.Direction=tempDiabetes.Direction
    .s reportData.BloodAfterDiningOfTwo=tempDiabetes.BloodAfterDiningOfTwo
    .s reportData.bAdverseEffects=tempDiabetes.bAdverseEffects
    .s reportData.BloodSurgeLimosis=tempDiabetes.BloodSurgeLimosis
    .s reportData.BloodAfterDining=tempDiabetes.BloodAfterDining
    .s reportData.EatDrug=tempDiabetes.EatDrug
    .s reportData.bDrink=tempDiabetes.bDrink
    .s reportData.Hb=tempDiabetes.Hb
    .s reportData.SugarInDay=tempDiabetes.SugarInDay
    .s reportData.NOther=tempDiabetes.NOther
    .i tempDiabetes.MentalStatus'="" d
    ..s reportData.MentalStatus=""
    ..s tempMentalStatus = tempDiabetes.MentalStatus
    ..s reportData.Symptom = ##class(CHSSWeb.HISInterface.DictQuery).GetDictQuery(tempMentalStatus,"DictMentalStatus")
    .s reportData.DrugOfAdverseEffects=tempDiabetes.DrugOfAdverseEffects
    .s reportData.OtherOfBlood=tempDiabetes.OtherOfBlood
    .s reportData.HbAlC=tempDiabetes.HbAlC
    .s reportData.UniteIll=tempDiabetes.UniteIll
    .s reportData.NAlbumen=tempDiabetes.NAlbumen
    .s reportData.SmokeNum=tempDiabetes.SmokeNum
    .s reportData.Cholesterin=tempDiabetes.Cholesterin
    .s reportData.FootArteryThrob=tempDiabetes.FootArteryThrob
    .s reportData.OtherCheck= tempDiabetes.OtherCheck
    .s reportData.DrugSideEffect=tempDiabetes.DrugSideEffect
    .s reportData.CheckAdd= tempDiabetes.CheckAdd
    .s reportData.Exercise= tempDiabetes.Exercise
	.s reportData.Food= tempDiabetes.Food.Description
	.s reportData.bSmoke= tempDiabetes.bSmoke
	.i tempDiabetes.Symptom'="" d
    ..s reportData.Symptom = ""
    ..s tempSymptom = tempDiabetes.Symptom
    ..s reportData.Symptom = ##class(CHSSWeb.HISInterface.DictQuery).GetDictQuery(tempSymptom,"DictSymptom")
    .s reportData.OtherSymptom=tempDiabetes.OtherSymptom
    .s reportData.CheckDoctor= tempDiabetes.CheckDoctor
	.s reportData.ExerciseNum= tempDiabetes.ExerciseNum
	.s reportData.ExerciseMin= tempDiabetes.ExerciseMin
	.s reportData.WaistlineStern= tempDiabetes.WaistlineStern
	.s reportData.Waistline= tempDiabetes.Waistline
	.s reportData.Stern= tempDiabetes.Stern
	.s reportData.DrinkQuentity= tempDiabetes.DrinkQuentity
    .s reportData.nHighPressure= tempDiabetes.nHighPressure
    .s reportData.nLowPressure= tempDiabetes.nLowPressure
    .s reportData.HeartRate= tempDiabetes.HeartRate
    .s reportData.Weight= tempDiabetes.Weight
    .s reportData.Height= tempDiabetes.Height
    .s reportData.BMI= tempDiabetes.BMI
    .s reportData.Smoke= tempDiabetes.Smoke
    .s reportData.Drink= tempDiabetes.Drink
    .set ComplyDoctor = ""
    .i tempDiabetes.ComplyDoctor '= "" d
    ..s ComplyDoctor = tempDiabetes.ComplyDoctor.%Id()
    ..s reportData.ComplyDoctor = tempDiabetes.ComplyDoctor.Description
	.s reportData.CaseType= tempDiabetes.CaseType
	.s reportData.bCaseTrans= tempDiabetes.bCaseTrans
	.i tempDiabetes.BloodSurgeRate '= "" d
    ..s BloodSurgeRate = tempDiabetes.BloodSurgeRate.%Id()
    ..s reportData.BloodSurgeRate = tempDiabetes.BloodSurgeRate.Description
    .i tempDiabetes.Eyeground '= "" d
    ..s Eyeground = tempDiabetes.Eyeground.%Id()
    ..s reportData.Eyeground = tempDiabetes.Eyeground.Description
    .i tempDiabetes.MentalityAdjust '= "" d
    ..s MentalityAdjust = tempDiabetes.MentalityAdjust.%Id()
    ..s reportData.MentalityAdjust = tempDiabetes.MentalityAdjust.Description
	.s reportData.Other= tempDiabetes.Other
	.s reportData.bTranfer= tempDiabetes.bTranfer
	.i tempDiabetes.TransferDept '= "" d
    ..s TransferDept = tempDiabetes.TransferDept.%Id()
    ..s reportData.TransferDept = tempDiabetes.TransferDept.CTLOCDesc
	.s reportData.TransferReason= tempDiabetes.TransferReason
	.i tempDiabetes.DrugRegularityRate '= "" d
    ..s DrugRegularityRate = tempDiabetes.DrugRegularityRate.%Id()
    ..s reportData.DrugRegularityRate = tempDiabetes.DrugRegularityRate.Description
    .i tempDiabetes.CheckResult '= "" d
    ..s CheckResult = tempDiabetes.CheckResult.%Id()
    ..s reportData.CheckResult = tempDiabetes.CheckResult.Description
	.s reportData.DoseComplier= tempDiabetes.DoseComplier
	.s DateOfStopDrink=tempDiabetes.DateOfStopDrink
	.i DateOfStopDrink '= "" d
	..s reportData.DateOfStopDrink = $zd(DateOfStopDrink,3)
	.s BookingDate=tempDiabetes.BookingDate
	.i BookingDate '= "" d
	..s reportData.BookingDate = $zd(BookingDate,3)
	.s DateOfStopSmoke=tempDiabetes.DateOfStopSmoke
	.i DateOfStopSmoke '= "" d
	..s reportData.DateOfStopSmoke = $zd(DateOfStopSmoke,3)
	.s reportData.DateOfStopSmoke= DateOfStopSmoke
	.s reportData.bBooking=tempDiabetes.bBooking
	.If (count>start)&(count<=end) d
    ..Set cdef = ##class(%Dictionary.ClassDefinition).%OpenId("CHSSWeb.HISInterface.DiabetesCheckRecordInfo")
	..s returnData = "<DiabetesCheckRecord>"
	..Set countProperties = cdef.Properties.Count()
	..For i = 1:1:countProperties d
   	...s returnData = returnData_"<"_cdef.Properties.GetAt(i).Name_">"_$ZOBJPROPERTY(reportData,cdef.Properties.GetAt(i).Name)_"</"_cdef.Properties.GetAt(i).Name_">"
	..s returnData = returnData_"</DiabetesCheckRecord>"
	..i resultString="" d
	...s resultString=returnData
	..e  d
	...s resultString=resultString_returnData
	s result="<DiabetesCheckRecords count='"_count_"'>"_resultString_"</DiabetesCheckRecords>"
	q result
}

Storage Default
{
<Data name="DiabetesCheckRecordInterfaceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.HIS6F2.DiabetesChecAEFD</DataLocation>
<DefaultData>DiabetesCheckRecordInterfaceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.HIS6F2.DiabetesChecAEFD</IdLocation>
<IndexLocation>^CHSSWeb.HIS6F2.DiabetesChecAEFI</IndexLocation>
<StreamLocation>^CHSSWeb.HIS6F2.DiabetesChecAEFS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
