Class CHSSWeb.WomenGSurveyStatService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// Creator: lyy
/// CreatDate：2010-09-
/// Description:妇科疾病人数统计表
/// Table：
/// Input: 
/// Output：
/// Return：
/// Others：
ClassMethod GetDiseaseStatInfo(CommunityCode As %String, start As %Integer, limit As %Integer, sort As %String) As %String
{
    
    s result = ##class(%Library.ResultSet).%New()
    
    
    s sqlStr = "select ItemAssortName As DiseaseName, nvl(sum(Num0),0) As Num0, nvl(sum(Num10),0) As Num10, nvl(sum(Num20),0) As Num20, nvl(sum(Num30),0) As Num30, nvl(sum(Num40),0) As Num40, nvl(sum(Num50),0) As Num50, nvl(sum(Num60),0) As Num60, nvl(sum(Num70),0) As Num70, nvl(sum(Num),0) As Num from (select ItemAssortName, DECODE({fn Floor(DATEDIFF('dd', Birth, GETDATE())/365/10)}, 0, 1, 0) as Num0, DECODE({fn Floor(DATEDIFF('dd', Birth, GETDATE())/365/10)}, 1, 1, 0) as Num10, DECODE({fn Floor(DATEDIFF('dd', Birth, GETDATE())/365/10)}, 2, 1, 0) as Num20, DECODE({fn Floor(DATEDIFF('dd', Birth, GETDATE())/365/10)}, 3, 1, 0) as Num30, DECODE({fn Floor(DATEDIFF('dd', Birth, GETDATE())/365/10)}, 4, 1, 0) as Num40, DECODE({fn Floor(DATEDIFF('dd', Birth, GETDATE())/365/10)}, 5, 1, 0) as Num50, DECODE({fn Floor(DATEDIFF('dd', Birth, GETDATE())/365/10)}, 6, 1, 0) as Num60, DECODE({fn SIGN({fn Floor(DATEDIFF('dd', Birth, GETDATE())/365/10)}-6)}, 1, 1, 0) as Num70, 1 as Num from (select pa.ItemAssortName, pb.Birth from CHSS.PersonHealthDiagnose pa, CHSS.PersonHealthRecordMain pb where pa.ItemdCode = '29' and pa.PersonRowIdParref = pb.PersonRowId and pb.CommunityCode ='"_CommunityCode_"' ) ) group by ItemAssortName"
    s sqlStr = sqlStr_" union select '合计' As DiseaseName, nvl(sum(Num0),0) As Num0, nvl(sum(Num10),0) As Num10, nvl(sum(Num20),0) As Num20, nvl(sum(Num30),0) As Num30, nvl(sum(Num40),0) As Num40, nvl(sum(Num50),0) As Num50, nvl(sum(Num60),0) As Num60, nvl(sum(Num70),0) As Num70, nvl(sum(Num),0) As Num from (select ItemAssortName, DECODE({fn Floor(DATEDIFF('dd', Birth, GETDATE())/365/10)}, 0, 1, 0) as Num0, DECODE({fn Floor(DATEDIFF('dd', Birth, GETDATE())/365/10)}, 1, 1, 0) as Num10, DECODE({fn Floor(DATEDIFF('dd', Birth, GETDATE())/365/10)}, 2, 1, 0) as Num20, DECODE({fn Floor(DATEDIFF('dd', Birth, GETDATE())/365/10)}, 3, 1, 0) as Num30, DECODE({fn Floor(DATEDIFF('dd', Birth, GETDATE())/365/10)}, 4, 1, 0) as Num40, DECODE({fn Floor(DATEDIFF('dd', Birth, GETDATE())/365/10)}, 5, 1, 0) as Num50, DECODE({fn Floor(DATEDIFF('dd', Birth, GETDATE())/365/10)}, 6, 1, 0) as Num60, DECODE({fn SIGN({fn Floor(DATEDIFF('dd', Birth, GETDATE())/365/10)}-6)}, 1, 1, 0) as Num70, 1 as Num from (select pa.ItemAssortName, pb.Birth from CHSS.PersonHealthDiagnose pa, CHSS.PersonHealthRecordMain pb where pa.ItemdCode = '29' and pa.PersonRowIdParref = pb.PersonRowId and pb.CommunityCode ='"_CommunityCode_"' ) ) "
    
   	
    d result.Prepare(sqlStr)
	d result.Execute()
	   
    Set start=$G(start)
	Set limit=$G(limit)
	
	Set count=0
	Set resultString = ""
	Set end = start+limit  
	
	Set json = ##class(Code.JsonObj).%New()
    Set tmp = ""
    
       	
	While(result.Next())
	{
		Set tmp = result.Data("DiseaseName")_"^"_result.Data("Num0")_"^"_result.Data("Num10")_"^"_result.Data("Num20")_"^"_result.Data("Num30")_"^"_result.Data("Num40")_"^"_result.Data("Num50")_"^"_result.Data("Num60")_"^"_result.Data("Num70")_"^"_result.Data("Num")

    	Set count=count+1
    	If (count>start)&(count<=end) d
    	.d json.InsertRowData(tmp)
    }
    
        
    Set resultString = json.getJsonData("DiseaseName^Num0^Num10^Num20^Num30^Num40^Num50^Num60^Num70^Sum",count)
    k json
    d result.Close()
     
    Quit resultString
}

/// Creator: lyy
/// CreatDate：2010-09-
/// Description: 妇科疾病统计图表
/// Table：
/// Input: 
/// Output：
/// Return：
/// Others：
ClassMethod GetDiseaseChartInfo(CommunityCode As %String, start As %Integer, limit As %Integer, sort As %String) As %String
{
    Set start=$G(start)
	Set limit=$G(limit)
	
	Set count=0
	Set resultString = ""
	Set end = start+limit  
	
	Set json = ##class(Code.JsonObj).%New()
    Set tmp = ""
    
    
    s result = ##class(%Library.ResultSet).%New()
    
    s sqlStr = "select ItemAssortName as DiseaseName, count(*) as Num from CHSS.PersonHealthDiagnose where ItemdCode = '29' and PersonRowIdParref in (select PersonRowId from CHSS.PersonHealthRecordMain where CommunityCode ='"_CommunityCode_"') group by ItemAssortName"
    
       
   			
	d result.Prepare(sqlStr)
	d result.Execute()
	
	While(result.Next())
	{
	
	    s DiseaseName=result.Data("DiseaseName")
		s Num=result.Data("Num")
				
		Set tmp = DiseaseName_"^"_Num
    
     	Set count=count+1
     	If (count>start)&(count<=end) d
     	.d json.InsertRowData(tmp)
    }
    
    d result.Close()
    
    
     
    Set resultString = json.getJsonData("DiseaseName^Num",count)
    k json
      
    Quit resultString
}

Storage Default
{
<Data name="WomenGSurveyStatServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.WomenGSurvey948D</DataLocation>
<DefaultData>WomenGSurveyStatServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.WomenGSurvey948D</IdLocation>
<IndexLocation>^CHSSWeb.WomenGSurvey948I</IndexLocation>
<StreamLocation>^CHSSWeb.WomenGSurvey948S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
