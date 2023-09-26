Class CHSSWeb.HISInterface.HBPCheckRecordInterface Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// Creator: lyy
/// CreatDate：2010-02-
/// Description:高血压档案接口--检索身份证号返回高血压病人档案信息(HIS调用)
/// Table：ElerlyBaseInfo
/// Input:IDCard
/// Output：
/// Return：
/// Others：
ClassMethod HBPCheckRecordData(IDCard As %String)
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
		set HBPCheckRecordRowId = 0
		Set PersonRowId=$O(^CHSS.PersonHealthRecordMainI("IDCardIndex",IDCard,PersonRowId))
		q:PersonRowId="" ""
	    For  Set HBPCheckRecordRowId=$O(^CHSS.HBPCheckRecordI("PersonRowIdParrefIndex",23,HBPCheckRecordRowId)) q:HBPCheckRecordRowId=""  d
        .s tempHBPCheckRecord=##class(CHSS.HBPCheckRecord).%OpenId(HBPCheckRecordRowId)
        .s reportData = ##class(CHSSWeb.HISInterface.HBPCheckRecordInfo).%New()
        .s DateCheck=tempHBPCheckRecord.DateCheck
		.i DateCheck '= "" d
		..s reportData.DateCheck = $zd(DateCheck,3)
		 .s DateOfCheck=tempHBPCheckRecord.DateOfCheck
		.i DateOfCheck '= "" d
		..s reportData.DateOfCheck = $zd(DateOfCheck,3)
		.s DateOfInput=tempHBPCheckRecord.DateOfInput
		.i DateOfInput '= "" d
		..s reportData.DateOfInput = $zd(DateOfInput,3)
        .s DateOfUpdate=tempHBPCheckRecord.DateOfUpdate
		.i DateOfUpdate '= "" d
		..s reportData.DateOfUpdate = $zd(DateOfUpdate,3)
	    .s reportData.Remark=tempHBPCheckRecord.Remark
	    .s reportData.Deal=tempHBPCheckRecord.Deal
	    .s reportData.Direction=tempHBPCheckRecord.Direction
	    .s reportData.DangerousFactor=tempHBPCheckRecord.DangerousFactor
	    .s reportData.NonDrugTherapy=tempHBPCheckRecord.NonDrugTherapy
	    .s reportData.BloodAfterDiningOfTwo=tempHBPCheckRecord.BloodAfterDiningOfTwo
	    .s reportData.bAdverseEffects=tempHBPCheckRecord.bAdverseEffects
	    .s reportData.BloodSurgeLimosis=tempHBPCheckRecord.BloodSurgeLimosis
	    .s reportData.BloodAfterDining=tempHBPCheckRecord.BloodAfterDining
	    .s reportData.EatDrug=tempHBPCheckRecord.EatDrug
	    .s reportData.bDrink=tempHBPCheckRecord.bDrink
	    .s reportData.Checker=tempHBPCheckRecord.Checker
	    .s reportData.Hb=tempHBPCheckRecord.Hb
	    .s reportData.SugarInDay=tempHBPCheckRecord.SugarInDay
	    .s reportData.NOther=tempHBPCheckRecord.NOther
	    .s reportData.DrugOfAdverseEffects=tempHBPCheckRecord.DrugOfAdverseEffects
	    .s reportData.OtherOfBlood=tempHBPCheckRecord.OtherOfBlood
	    .s reportData.HbAlC=tempHBPCheckRecord.HbAlC
	    .s reportData.UniteIll=tempHBPCheckRecord.UniteIll
	    .s reportData.NAlbumen=tempHBPCheckRecord.NAlbumen
        .s reportData.SmokeNum=tempHBPCheckRecord.SmokeNum
	    .s reportData.Cholesterin=tempHBPCheckRecord.Cholesterin
	    .s reportData.FootArteryThrob=tempHBPCheckRecord.FootArteryThrob
	    .s reportData.OtherCheck= tempHBPCheckRecord.OtherCheck
	    .s reportData.DrugSideEffect= tempHBPCheckRecord.DrugSideEffect
        .s reportData.CheckAdd= tempHBPCheckRecord.CheckAdd
	    .s reportData.Exercise= tempHBPCheckRecord.Exercise
	    .s reportData.Food= tempHBPCheckRecord.Food
	    .s reportData.bSmoke= tempHBPCheckRecord.bSmoke
        .s reportData.Symptom= tempHBPCheckRecord.Symptom
        .s reportData.OtherSymptom=tempHBPCheckRecord.OtherSymptom
        .s reportData.CheckDoctor= tempHBPCheckRecord.CheckDoctor
	    .s reportData.ExerciseNum= tempHBPCheckRecord.ExerciseNum
	    .s reportData.ExerciseMin= tempHBPCheckRecord.ExerciseMin
	    .s reportData.WaistlineStern= tempHBPCheckRecord.WaistlineStern
	    .s reportData.DrinkQuentity= tempHBPCheckRecord.DrinkQuentity
        .s reportData.nHighPressure= tempHBPCheckRecord.nHighPressure
        .s reportData.nLowPressure= tempHBPCheckRecord.nLowPressure
        .s reportData.HeartRate= tempHBPCheckRecord.HeartRate
        .s reportData.Weight= tempHBPCheckRecord.Weight
        .s reportData.Height= tempHBPCheckRecord.Height
        .s reportData.BMI= tempHBPCheckRecord.BMI
        .s reportData.Smoke= tempHBPCheckRecord.Smoke
        .s reportData.Drink= tempHBPCheckRecord.Drink
        .set ComplyDoctor = ""
        .i tempHBPCheckRecord.ComplyDoctor '= "" d
        ..s ComplyDoctor = tempHBPCheckRecord.ComplyDoctor.%Id()
        ..s reportData.ComplyDoctor = tempHBPCheckRecord.ComplyDoctor.Description
         .set CheckType = ""
        .i tempHBPCheckRecord.CheckType '= "" d
        ..s CheckType = tempHBPCheckRecord.CheckType.%Id()
        ..s reportData.CheckType = tempHBPCheckRecord.CheckType.Description
         .set MentalityAdjust = ""
        .i tempHBPCheckRecord.MentalityAdjust '= "" d
        ..s MentalityAdjust = tempHBPCheckRecord.MentalityAdjust.%Id()
        ..s reportData.MentalityAdjust = tempHBPCheckRecord.MentalityAdjust.Description
	    .s reportData.Other= tempHBPCheckRecord.Other
	    .s reportData.bTranfer= tempHBPCheckRecord.bTranfer
	    .set TransferDept = ""
        .i tempHBPCheckRecord.TransferDept '= "" d
        ..s TransferDept = tempHBPCheckRecord.TransferDept.%Id()
        ..s reportData.TransferDept = tempHBPCheckRecord.TransferDept.CTLOCDesc
	    .s reportData.TransferReason= tempHBPCheckRecord.TransferReason
	    .set DrugRegularityRate = ""
        .i tempHBPCheckRecord.DrugRegularityRate '= "" d
        ..s DrugRegularityRate = tempHBPCheckRecord.DrugRegularityRate.%Id()
        ..s reportData.DrugRegularityRate = tempHBPCheckRecord.DrugRegularityRate.Description
	    .s reportData.DoseComplier=tempHBPCheckRecord.DoseComplier
	    .s DateOfStopDrink=tempHBPCheckRecord.DateOfStopDrink
		.i DateOfStopDrink '= "" d
		..s reportData.DateOfStopDrink = $zd(DateOfStopDrink,3)
		.s BookingDate=tempHBPCheckRecord.BookingDate
		.i BookingDate '= "" d
		..s reportData.BookingDate = $zd(BookingDate,3)
		.s DateOfStopSmoke=tempHBPCheckRecord.DateOfStopSmoke
		.i DateOfStopSmoke '= "" d
		..s reportData.DateOfStopSmoke = $zd(DateOfStopSmoke,3)
	    .s reportData.bBooking=tempHBPCheckRecord.bBooking
		
		.;第二种方法：手工拼写
	    .Set cdef = ##class(%Dictionary.ClassDefinition).%OpenId("CHSSWeb.HISInterface.HBPCheckRecordInfo")
 		.s returnData = "<HBPCheckRecord>"
		. // get list of properties
		.;Write "---Properties---",!
		.Set count = cdef.Properties.Count()
		.For i = 1:1:count d
    	..s returnData = returnData_"<"_cdef.Properties.GetAt(i).Name_">"_$ZOBJPROPERTY(reportData,cdef.Properties.GetAt(i).Name)_"</"_cdef.Properties.GetAt(i).Name_">"
 		.s returnData = returnData_"</HBPCheckRecord>"
 		.

		
		.;如果返回的是LIST，则使用[Collection = list]方式返回列表
		.;d reportReportData.PersonInfo.Insert(reportData)
		.
		
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
/// Date:2011-05-18
/// Description:高血压随访记录
ClassMethod HBPCheckRecordList(PersonRowId As %String, start As %String, limit As %String) As %String
{
	Set PersonRowId=$G(PersonRowId)	
	s start = $g(start)
	s limit = $g(limit)	
	Set count=0
	Set resultString = ""
	Set end = start+limit
	Set json = ##class(Code.JsonObj).%New()
	s reportData = ""
	set returnData = ""
	set HBPCheckRecordRowId = 0
	q:PersonRowId="" ""
    For  Set HBPCheckRecordRowId=$O(^CHSS.HBPCheckRecordI("PersonRowIdParrefIndex",PersonRowId,HBPCheckRecordRowId)) q:HBPCheckRecordRowId=""  d
    .Set count=count+1
    .s tempHBPCheckRecord=##class(CHSS.HBPCheckRecord).%OpenId(HBPCheckRecordRowId)
    .s reportData = ##class(CHSSWeb.HISInterface.HBPCheckRecordInfo).%New()
    .s DateCheck=tempHBPCheckRecord.DateCheck
	.i DateCheck '= "" d
	..s reportData.DateCheck = $zd(DateCheck,3)
	.s DateOfCheck=tempHBPCheckRecord.DateOfCheck
	.i DateOfCheck '= "" d
	..s reportData.DateOfCheck = $zd(DateOfCheck,3)
	.s DateOfInput=tempHBPCheckRecord.DateOfInput
	.i DateOfInput '= "" d
	..s reportData.DateOfInput = $zd(DateOfInput,3)
    .s DateOfUpdate=tempHBPCheckRecord.DateOfUpdate
	.i DateOfUpdate '= "" d
	..s reportData.DateOfUpdate = $zd(DateOfUpdate,3)
	.s reportData.Remark=tempHBPCheckRecord.Remark
	.s reportData.Deal=tempHBPCheckRecord.Deal
	.s reportData.Direction=tempHBPCheckRecord.Direction
	.s reportData.DangerousFactor=tempHBPCheckRecord.DangerousFactor
	.s reportData.NonDrugTherapy=tempHBPCheckRecord.NonDrugTherapy
	.s reportData.BloodAfterDiningOfTwo=tempHBPCheckRecord.BloodAfterDiningOfTwo
	.s reportData.bAdverseEffects=tempHBPCheckRecord.bAdverseEffects
	.s reportData.BloodSurgeLimosis=tempHBPCheckRecord.BloodSurgeLimosis
	.s reportData.BloodAfterDining=tempHBPCheckRecord.BloodAfterDining
	.s reportData.EatDrug=tempHBPCheckRecord.EatDrug
	.s reportData.bDrink=tempHBPCheckRecord.bDrink
	.s reportData.Checker=tempHBPCheckRecord.Checker
	.s reportData.Hb=tempHBPCheckRecord.Hb
	.s reportData.SugarInDay=tempHBPCheckRecord.SugarInDay
	.s reportData.NOther=tempHBPCheckRecord.NOther
	.s reportData.DrugOfAdverseEffects=tempHBPCheckRecord.DrugOfAdverseEffects
	.s reportData.OtherOfBlood=tempHBPCheckRecord.OtherOfBlood
	.s reportData.HbAlC=tempHBPCheckRecord.HbAlC
	.s reportData.UniteIll=tempHBPCheckRecord.UniteIll
	.s reportData.NAlbumen=tempHBPCheckRecord.NAlbumen
    .s reportData.SmokeNum=tempHBPCheckRecord.SmokeNum
	.s reportData.Cholesterin=tempHBPCheckRecord.Cholesterin
	.s reportData.FootArteryThrob=tempHBPCheckRecord.FootArteryThrob
	.s reportData.OtherCheck= tempHBPCheckRecord.OtherCheck
	.s reportData.DrugSideEffect= tempHBPCheckRecord.DrugSideEffect
    .s reportData.CheckAdd= tempHBPCheckRecord.CheckAdd
	.s reportData.Exercise= tempHBPCheckRecord.Exercise
	.s reportData.Food= tempHBPCheckRecord.Food
	.s reportData.bSmoke= tempHBPCheckRecord.bSmoke
    .s reportData.Symptom = ""
	.i tempHBPCheckRecord.Symptom'="" d
    ..s tempSymptom = tempHBPCheckRecord.Symptom
    ..s reportData.Symptom = ##class(CHSSWeb.HISInterface.DictQuery).GetDictQuery(tempSymptom,"DictSymptom")
    .s reportData.OtherSymptom=tempHBPCheckRecord.OtherSymptom
    .s reportData.CheckDoctor= tempHBPCheckRecord.CheckDoctor
	.s reportData.ExerciseNum= tempHBPCheckRecord.ExerciseNum
	.s reportData.ExerciseMin= tempHBPCheckRecord.ExerciseMin
	.s reportData.WaistlineStern= tempHBPCheckRecord.WaistlineStern
	.s reportData.DrinkQuentity= tempHBPCheckRecord.DrinkQuentity
    .s reportData.nHighPressure= tempHBPCheckRecord.nHighPressure
    .s reportData.nLowPressure= tempHBPCheckRecord.nLowPressure
    .s reportData.HeartRate= tempHBPCheckRecord.HeartRate
    .s reportData.Weight= tempHBPCheckRecord.Weight
    .s reportData.Height= tempHBPCheckRecord.Height
    .s reportData.BMI= tempHBPCheckRecord.BMI
    .s reportData.Smoke= tempHBPCheckRecord.Smoke
    .s reportData.Drink= tempHBPCheckRecord.Drink
    .set ComplyDoctor = ""
    .i tempHBPCheckRecord.ComplyDoctor '= "" d
    ..s ComplyDoctor = tempHBPCheckRecord.ComplyDoctor.%Id()
    ..s reportData.ComplyDoctor = tempHBPCheckRecord.ComplyDoctor.Description
    .set CheckType = ""
    .i tempHBPCheckRecord.CheckType '= "" d
    ..s CheckType = tempHBPCheckRecord.CheckType.%Id()
    ..s reportData.CheckType = tempHBPCheckRecord.CheckType.Description
    .set MentalityAdjust = ""
    .i tempHBPCheckRecord.MentalityAdjust '= "" d
    ..s MentalityAdjust = tempHBPCheckRecord.MentalityAdjust.%Id()
    ..s reportData.MentalityAdjust = tempHBPCheckRecord.MentalityAdjust.Description
	.s reportData.Other= tempHBPCheckRecord.Other
	.s reportData.bTranfer= tempHBPCheckRecord.bTranfer
	.set TransferDept = ""
    .i tempHBPCheckRecord.TransferDept '= "" d
    ..s TransferDept = tempHBPCheckRecord.TransferDept.%Id()
    ..s reportData.TransferDept = tempHBPCheckRecord.TransferDept.CTLOCDesc
	.s reportData.TransferReason= tempHBPCheckRecord.TransferReason
	.set DrugRegularityRate = ""
    .i tempHBPCheckRecord.DrugRegularityRate '= "" d
    ..s DrugRegularityRate = tempHBPCheckRecord.DrugRegularityRate.%Id()
    ..s reportData.DrugRegularityRate = tempHBPCheckRecord.DrugRegularityRate.Description
	.s reportData.DoseComplier=tempHBPCheckRecord.DoseComplier
	.s DateOfStopDrink=tempHBPCheckRecord.DateOfStopDrink
	.i DateOfStopDrink '= "" d
	..s reportData.DateOfStopDrink = $zd(DateOfStopDrink,3)
	.s BookingDate=tempHBPCheckRecord.BookingDate
	.i BookingDate '= "" d
	..s reportData.BookingDate = $zd(BookingDate,3)
	.s DateOfStopSmoke=tempHBPCheckRecord.DateOfStopSmoke
	.i DateOfStopSmoke '= "" d
	..s reportData.DateOfStopSmoke = $zd(DateOfStopSmoke,3)
	.s reportData.bBooking=tempHBPCheckRecord.bBooking			
    .If (count>start)&(count<=end) d
	..Set cdef = ##class(%Dictionary.ClassDefinition).%OpenId("CHSSWeb.HISInterface.HBPCheckRecordInfo") 	
	..Set countProperties = cdef.Properties.Count()
	..s returnData = "<HBPCheckRecord>"
	..For i = 1:1:countProperties d
    ...s returnData = returnData_"<"_cdef.Properties.GetAt(i).Name_">"_$ZOBJPROPERTY(reportData,cdef.Properties.GetAt(i).Name)_"</"_cdef.Properties.GetAt(i).Name_">"
 	..s returnData = returnData_"</HBPCheckRecord>"
 	..i resultString = "" d
 	...s resultString = returnData
 	..e  d
 	...s resultString = resultString_returnData
	s result="<HBPCheckRecords count='"_count_"'>"_resultString_"</HBPCheckRecords>"
	q result
}

Storage Default
{
<Data name="HBPCheckRecordInterfaceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.HIS6F2.HBPCheckReco8A8D</DataLocation>
<DefaultData>HBPCheckRecordInterfaceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.HIS6F2.HBPCheckReco8A8D</IdLocation>
<IndexLocation>^CHSSWeb.HIS6F2.HBPCheckReco8A8I</IndexLocation>
<StreamLocation>^CHSSWeb.HIS6F2.HBPCheckReco8A8S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
