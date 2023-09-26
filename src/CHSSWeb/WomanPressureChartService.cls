Class CHSSWeb.WomanPressureChartService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// Creator: lyy
/// CreatDate：2010-03-
/// Description: 血压曲线图统计信息
/// Table：
/// Input: 
/// Output：
/// Return：
/// Others：
ClassMethod GetStatInfo(WomanRowIdParref As %Integer, StatType As %String, start As %Integer, limit As %Integer, sort As %String, whereStr As %String) As %String
{
    Set start=$G(start)
	Set limit=$G(limit)
	
	Set count=0
	Set resultString = ""
	Set end = start+limit  
	
	Set json = ##class(Code.JsonObj).%New()
    Set tmp = ""
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr=""
    s PersonRowId=""
    
    if (StatType="Pressure")
    {
      s sqlStr="select * from CHSS.WomenBaseInfo where WomanRowId="_WomanRowIdParref
      d result.Prepare(sqlStr)
	  d result.Execute()
	  While(result.Next())
	  {
		s PersonRowId=result.Data("PersonRowIdParref")
	  }
      d result.Close()
      s result = ##class(%Library.ResultSet).%New()
    }
    
    if StatType="Pressure" d
    .s sqlStr = "select CheckDate As DateCheck, HighPressure As ChartNumOne, LowPressure As ChartNumTwo, '妇女产前随访' As Source, 120 As NChartNumOne, 80 As NChartNumTwo  from CHSS.WhAntepartumRecheck where HighPressure is not null and LowPressure is not null  and WomanRowIdParref = '"_WomanRowIdParref_"' and CheckDate"_whereStr
    .s sqlStr = sqlStr_" union select DateCheck, nHighPressure As ChartNumOne, nLowPressure As ChartNumTwo, '高血压随访' As Source, 120 As NChartNumOne, 80 As NChartNumTwo from CHSS.HBPCheckRecord where nHighPressure is not null and nLowPressure is not null  and PersonRowIdParref = '"_PersonRowId_"' and DateCheck"_whereStr
    .s sqlStr = sqlStr_" union select DateCheck, nHighPressure As ChartNumOne, nLowPressure As ChartNumTwo, '糖尿病随访' As Source, 120 As NChartNumOne, 80 As NChartNumTwo from CHSS.DiabetesCheckRecord where nHighPressure is not null and nLowPressure is not null  and PersonRowIdParref = '"_PersonRowId_"' and DateCheck"_whereStr
    e 
    if StatType="Weight" d
    .s sqlStr="select CheckDate As DateCheck,Weight As ChartNumOne,0 As ChartNumTwo,'妇女产前随访' As Source,120 As NChartNumOne, 80 As NChartNumTwo from CHSS.WhAntepartumRecheck where Weight is not null and WomanRowIdParref = '"_WomanRowIdParref_"' and CheckDate"_whereStr
    e
    if StatType="WombHeight" d
    .s sqlStr="select CheckDate As DateCheck,WombHeight As ChartNumOne,0 As ChartNumTwo,'妇女产前随访' As Source,120 As NChartNumOne, 80 As NChartNumTwo from CHSS.WhAntepartumRecheck where WombHeight is not null and WomanRowIdParref = '"_WomanRowIdParref_"' and CheckDate"_whereStr
    e
    if StatType="AbdomenGirth" d
    .s sqlStr="select CheckDate As DateCheck,AbdomenGirth As ChartNumOne,0 As ChartNumTwo,'妇女产前随访' As Source,120 As NChartNumOne, 80 As NChartNumTwo from CHSS.WhAntepartumRecheck where AbdomenGirth is not null and WomanRowIdParref = '"_WomanRowIdParref_"' and CheckDate"_whereStr
       
		
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
      
    q resultString
}

Storage Default
{
<Data name="WomanPressureChartServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.WomanPressurA1ED</DataLocation>
<DefaultData>WomanPressureChartServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.WomanPressurA1ED</IdLocation>
<IndexLocation>^CHSSWeb.WomanPressurA1EI</IndexLocation>
<StreamLocation>^CHSSWeb.WomanPressurA1ES</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
