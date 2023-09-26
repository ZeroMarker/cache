Class CHSSWeb.HISInterface.HBPHeadPageInterface Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// Creator: lyy
/// CreatDate：2010-02-
/// Description:高血压档案接口--检索身份证号返回高血压病人档案信息(HIS调用)
/// Table：HBPHeadPageInfo
/// Input:IDCard
/// Output：
/// Return：
/// Others：
ClassMethod HBPHeadRecordData(IDCard As %String)
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
		set HBPHeadRowId = 0
		
		Set PersonRowId=$O(^CHSS.PersonHealthRecordMainI("IDCardIndex",IDCard,PersonRowId))
		q:PersonRowId="" ""
	    For  Set HBPHeadRowId=$O(^CHSS.HBPHeadPageI("PersonRowIdIndex",36,HBPHeadRowId)) q:HBPHeadRowId=""  d
        .s tempHBPHeadPageInfo=##class(CHSS.HBPHeadPage).%OpenId(HBPHeadRowId)
        .s reportData = ##class(CHSSWeb.HISInterface.HBPHeadPageInfo).%New()
        .s Intime=tempHBPHeadPageInfo.Intime
		.i Intime '= "" d
		..s reportData.Intime = $zd(Intime,3)
	   .s reportData.Doctor=tempHBPHeadPageInfo.Doctor
	   .set StaffInput = ""
        .i tempHBPHeadPageInfo.StaffInput '= "" d
        ..s StaffInput = tempHBPHeadPageInfo.StaffInput.%Id()
        ..s reportData.StaffInput = tempHBPHeadPageInfo.StaffInput.SSUSRName
	   .s DateOfInput=tempHBPHeadPageInfo.DateOfInput
		.i DateOfInput '= "" d
		..s reportData.DateOfInput = $zd(DateOfInput,3)
	   .s DateOfCheck=tempHBPHeadPageInfo.DateOfCheck
		.i DateOfCheck '= "" d
		..s reportData.DateOfCheck = $zd(DateOfCheck,3)
	    .s DateOfUpdate=tempHBPHeadPageInfo.DateOfUpdate
		.i DateOfUpdate '= "" d
		..s reportData.DateOfUpdate = $zd(DateOfUpdate,3)
	   .s reportData.DiagnoseUnit= tempHBPHeadPageInfo.DiagnoseUnit
	   .s reportData.Checker=tempHBPHeadPageInfo.Checker
	   .s reportData.SmokeInfo= tempHBPHeadPageInfo.SmokeInfo
	   .s reportData.DrinkInfo= tempHBPHeadPageInfo.DrinkInfo
	   .s reportData.GymInfo= tempHBPHeadPageInfo.GymInfo
	   .s reportData.CheckOutWay = tempHBPHeadPageInfo.CheckOutWay
	   .s reportData.Mof = tempHBPHeadPageInfo.Mof
	   .s reportData.DiseaseHistory= tempHBPHeadPageInfo.DiseaseHistory
	   .s reportData.Weight= tempHBPHeadPageInfo.Weight
	   .s reportData.High= tempHBPHeadPageInfo.High
	   .s reportData.BMI= tempHBPHeadPageInfo.BMI
	   .s reportData.DangerousFactor= tempHBPHeadPageInfo.DangerousFactor
	   .s reportData.HighPressure= tempHBPHeadPageInfo.HighPressure
	   .s reportData.LowPressure= tempHBPHeadPageInfo.LowPressure
	   .s reportData.UniteIll= tempHBPHeadPageInfo.UniteIll
	    .set SelfCare = ""
        .i tempHBPHeadPageInfo.SelfCare '= "" d
        ..s SelfCare = tempHBPHeadPageInfo.SelfCare.%Id()
        ..s reportData.SelfCare = tempHBPHeadPageInfo.SelfCare.Description
	   .s reportData.CaseDiscuss= tempHBPHeadPageInfo.CaseDiscuss
	   .s reportData.ReasonOfDisc= tempHBPHeadPageInfo.ReasonOfDisc
       .s reportData.ResultOfDisc= tempHBPHeadPageInfo.ResultOfDisc
		.;第二种方法：手工拼写
	    .Set cdef = ##class(%Dictionary.ClassDefinition).%OpenId("CHSSWeb.HISInterface.HBPHeadPageInfo")
 		.s returnData = "<HBPHeadPage>"
		. // get list of properties
		.;Write "---Properties---",!
		.Set count = cdef.Properties.Count()
		.For i = 1:1:count d
    	..s returnData = returnData_"<"_cdef.Properties.GetAt(i).Name_">"_$ZOBJPROPERTY(reportData,cdef.Properties.GetAt(i).Name)_"</"_cdef.Properties.GetAt(i).Name_">"
 		.s returnData = returnData_"</HBPHeadPage>"
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

Storage Default
{
<Data name="HBPHeadPageInterfaceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.HIS6F2.HBPHeadPageI75AD</DataLocation>
<DefaultData>HBPHeadPageInterfaceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.HIS6F2.HBPHeadPageI75AD</IdLocation>
<IndexLocation>^CHSSWeb.HIS6F2.HBPHeadPageI75AI</IndexLocation>
<StreamLocation>^CHSSWeb.HIS6F2.HBPHeadPageI75AS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
