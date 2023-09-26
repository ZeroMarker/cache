Class CHSSWeb.ChronicChartService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// Creator: lyy
/// CreatDate：2010-03-
/// Description: 慢性病曲线图统计信息
/// Table：
/// Input: 
/// Output：
/// Return：
/// Others：
ClassMethod GetStatInfo(PersonRowId As %Integer, StatType As %String, start As %Integer, limit As %Integer, sort As %String, whereStr As %String) As %String
{
    Set start=$G(start)
	Set limit=$G(limit)
	
	Set count=0
	Set resultString = ""
	Set end = start+limit  
	
	Set json = ##class(Code.JsonObj).%New()
    Set tmp = ""
    
  
    s result = ##class(%Library.ResultSet).%New()
        
    
    if StatType="Pressure" d
    .s sqlStr = "select DateCheck, HighPressure As ChartNumOne, LowPressure As ChartNumTwo, '老年人随访' As Source, 120 As NChartNumOne, 80 As NChartNumTwo  from CHSS.ElerlyHealthCheckRecord where HighPressure is not null and LowPressure is not null  and PersonRowId = '"_PersonRowId_"' "_whereStr
    .s sqlStr = sqlStr_" union select DateCheck, nHighPressure As ChartNumOne, nLowPressure As ChartNumTwo, '高血压随访' As Source, 120 As NChartNumOne, 80 As NChartNumTwo from CHSS.HBPCheckRecord where nHighPressure is not null and nLowPressure is not null  and PersonRowIdParref = '"_PersonRowId_"' "_whereStr
    .s sqlStr = sqlStr_" union select DateCheck, nHighPressure As ChartNumOne, nLowPressure As ChartNumTwo, '糖尿病随访' As Source, 120 As NChartNumOne, 80 As NChartNumTwo from CHSS.DiabetesCheckRecord where nHighPressure is not null and nLowPressure is not null  and PersonRowIdParref = '"_PersonRowId_"' "_whereStr
    
    e  i StatType="BloodSurgeLimosis" d
    .s sqlStr = "select DateCheck, BloodSurgeLimosis As ChartNumOne, 0 As ChartNumTwo, '老年人随访' As Source, 7 As NChartNumOne, 0 As NChartNumTwo from CHSS.ElerlyHealthCheckRecord where BloodSurgeLimosis is not null and PersonRowId = '"_PersonRowId_"' "_whereStr
    .s sqlStr = sqlStr_" union select DateCheck, BloodSurgeLimosis As ChartNumOne, 0 As ChartNumTwo, '高血压随访' As Source, 7 As NChartNumOne, 0 As NChartNumTwo from CHSS.HBPCheckRecord where BloodSurgeLimosis is not null  and PersonRowIdParref = '"_PersonRowId_"' "_whereStr
    .s sqlStr = sqlStr_" union select DateCheck, BloodSurgeLimosis As ChartNumOne, 0 As ChartNumTwo, '糖尿病随访' As Source, 7 As NChartNumOne, 0 As NChartNumTwo from CHSS.DiabetesCheckRecord where BloodSurgeLimosis is not null  and PersonRowIdParref = '"_PersonRowId_"' "_whereStr
       
    e  i StatType="BMI" d
    .s sqlStr = "select DateCheck, BMI As ChartNumOne, 0 As ChartNumTwo, '老年人随访' As Source, 24 As NChartNumOne, 19 As NChartNumTwo from CHSS.ElerlyHealthCheckRecord where BMI is not null and  PersonRowId = '"_PersonRowId_"' "_whereStr
	.s sqlStr = sqlStr_" union select DateCheck, BMI As ChartNumOne, 0 As ChartNumTwo, '高血压随访' As Source, 24 As NChartNumOne, 19 As NChartNumTwo from CHSS.HBPCheckRecord where BMI is not null  and PersonRowIdParref = '"_PersonRowId_"' "_whereStr
    .s sqlStr = sqlStr_" union select DateCheck, BMI As ChartNumOne, 0 As ChartNumTwo, '糖尿病随访' As Source, 24 As NChartNumOne, 19 As NChartNumTwo from CHSS.DiabetesCheckRecord where BMI is not null  and PersonRowIdParref = '"_PersonRowId_"' "_whereStr

			
	d result.Prepare(sqlStr)
	d result.Execute()
	
	While(result.Next())
	{
		s DateCheck=result.Data("DateCheck")
		i (DateCheck'="") d
		.s DateCheck = $zd(DateCheck,3)
		s ChartNumOne=result.Data("ChartNumOne")
		s ChartNumTwo=result.Data("ChartNumTwo")
		s Source=result.Data("Source")
		s NChartNumOne=result.Data("NChartNumOne")
		s NChartNumTwo=result.Data("NChartNumTwo")
				
		Set tmp = DateCheck_"^"_ChartNumOne_"^"_ChartNumTwo_"^"_Source_"^"_NChartNumOne_"^"_NChartNumTwo
    
     	Set count=count+1
     	If (count>start)&(count<=end) d
     	.d json.InsertRowData(tmp)
    }
    
    d result.Close()
    
    
     
    Set resultString = json.getJsonData("DateCheck^ChartNumOne^ChartNumTwo^Source^NChartNumOne^NChartNumTwo",count)
    k json
      
    Quit resultString
}

Storage Default
{
<Data name="ChronicChartServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.ChronicChartServiceD</DataLocation>
<DefaultData>ChronicChartServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.ChronicChartServiceD</IdLocation>
<IndexLocation>^CHSSWeb.ChronicChartServiceI</IndexLocation>
<StreamLocation>^CHSSWeb.ChronicChartServiceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
