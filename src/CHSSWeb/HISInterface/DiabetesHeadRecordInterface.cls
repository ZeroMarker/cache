Class CHSSWeb.HISInterface.DiabetesHeadRecordInterface Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// Creator: lyy
/// CreatDate：2010-02-
/// Description:糖尿病档案接口--检索身份证号返回糖尿病人档案信息(HIS调用)
/// Table：ElerlyBaseInfo
/// Input:IDCard
/// Output：
/// Return：
/// Others：
ClassMethod DiabetesHeadRecordData(IDCard As %String)
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
		set MainPageRowId = 0
		Set PersonRowId=$O(^CHSS.PersonHealthRecordMainI("IDCardIndex",IDCard,PersonRowId))
		q:PersonRowId="" ""
	    For  Set MainPageRowId=$O(^CHSS.DiabetesHeadPageI("PersonRowIdIndex",PersonRowId,MainPageRowId)) q:MainPageRowId=""  d
        .s tempDiabetesHead=##class(CHSS.DiabetesHeadPage).%OpenId(MainPageRowId)
        .s reportData = ##class(CHSSWeb.HISInterface.DiabetesHeadRecordInfo).%New()
        .s DiseaseType = tempDiabetesHead.DiseaseType
        .s DiagnoseDate=""
	  	.s DiagnoseDate=tempDiabetesHead.DiagnoseDate
		.i DiagnoseDate '= "" d
		..s reportData.DiagnoseDate = $zd(DiagnoseDate,3)
	    .s reportData.BloodSurgeLimosis= tempDiabetesHead.BloodSurgeLimosis
	    .s reportData.BloodAfterDiningOfTwo= tempDiabetesHead.BloodAfterDiningOfTwo
	    .s reportData.BloodAfterDining= tempDiabetesHead.BloodAfterDining
	    .s reportData.CaseSource= tempDiabetesHead.CaseSource
        .i tempDiabetesHead.DiseaseHistory '= "" d
        ..s DiseaseHistory = tempDiabetesHead.DiseaseHistory.%Id()
        ..s reportData.DiseaseHistory = tempDiabetesHead.DiseaseHistory.Description
        .s reportData.CheckDoctor= tempDiabetesHead.CheckDoctor
        .s DateOfInput=tempDiabetesHead.DateCheck
		.i DateOfInput '= "" d
		..s reportData.DateCheck = $zd(DateOfInput,3)
        .i tempDiabetesHead.CheckType '= "" d
        ..s CheckType = tempDiabetesHead.CheckType.%Id()
        ..s reportData.CheckType = tempDiabetesHead.CheckType.Description
        .s StaffInput= ""
        .i tempDiabetesHead.StaffInput '= "" d
        ..s StaffInput = tempDiabetesHead.StaffInput.%Id()
        ..s reportData.StaffInput = tempDiabetesHead.StaffInput.SSUSRName
	  	.s DateOfInput=tempDiabetesHead.DateOfInput
		.i DateOfInput '= "" d
		..s reportData.DateOfInput = $zd(DateOfInput,3)
		.s DateOfUpdate=""
	  	.s DateOfUpdate=tempDiabetesHead.DateOfUpdate
		.i DateOfUpdate '= "" d
		..s reportData.DateOfUpdate = $zd(DateOfUpdate,3)
	    .s reportData.UniteIll= tempDiabetesHead.UniteIll
		.;第二种方法：手工拼写
	    .Set cdef = ##class(%Dictionary.ClassDefinition).%OpenId("CHSSWeb.HISInterface.DiabetesHeadRecordInfo")
 		.s returnData = "<DiabetesHeadPage>"
		. // get list of properties
		.;Write "---Properties---",!
		.Set count = cdef.Properties.Count()
		.For i = 1:1:count d
    	..s returnData = returnData_"<"_cdef.Properties.GetAt(i).Name_">"_$ZOBJPROPERTY(reportData,cdef.Properties.GetAt(i).Name)_"</"_cdef.Properties.GetAt(i).Name_">"
 		.s returnData = returnData_"</DiabetesHeadPage>"
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

Storage Default
{
<Data name="DiabetesHeadRecordInterfaceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.HIS6F2.DiabetesHeadA83D</DataLocation>
<DefaultData>DiabetesHeadRecordInterfaceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.HIS6F2.DiabetesHeadA83D</IdLocation>
<IndexLocation>^CHSSWeb.HIS6F2.DiabetesHeadA83I</IndexLocation>
<StreamLocation>^CHSSWeb.HIS6F2.DiabetesHeadA83S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
