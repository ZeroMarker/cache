Class CHSSWeb.ChronicStatService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// Creator: lyy
/// CreatDate：2010-05-
/// Description: 慢性病管理工作量
/// Table：
/// Input: 
/// Output：
/// Return：
/// Others：
ClassMethod GetStatInfo(CommunityCode As %String, start As %Integer, limit As %Integer, sort As %String, whereStr As %String) As %String
{
    Set start=$G(start)
	Set limit=$G(limit)
	
	Set count=0
	Set resultString = ""
	Set end = start+limit  
	
	Set json = ##class(Code.JsonObj).%New()
    Set tmp = ""
    
  
    s result = ##class(%Library.ResultSet).%New()
    
        
    s sqlStr = "select '高血压' as ChronicType, CheckDoctor, count(*) as CheckNum from CHSS.HBPCheckRecord where CheckDoctor is not null and PersonRowIdParref in (select PersonRowId from CHSS.PersonHealthRecordMain where CommunityCode ='"_CommunityCode_"') "_whereStr_" group by CheckDoctor"
    s sqlStr = sqlStr_" union select '糖尿病' as ChronicType, CheckDoctor, count(*) as CheckNum from CHSS.DiabetesCheckRecord where CheckDoctor is not null and PersonRowIdParref in (select PersonRowId from CHSS.PersonHealthRecordMain where CommunityCode ='"_CommunityCode_"') "_whereStr_" group by CheckDoctor"
    
    
			
	d result.Prepare(sqlStr)
	d result.Execute()
	
	While(result.Next())
	{
	
	    s ChronicType=result.Data("ChronicType")
		s CheckDoctor=result.Data("CheckDoctor")
		s CheckNum=result.Data("CheckNum")
				
		Set tmp = ChronicType_"^"_CheckDoctor_"^"_CheckNum
    
     	Set count=count+1
     	If (count>start)&(count<=end) d
     	.d json.InsertRowData(tmp)
    }
    
    d result.Close()
    
    
     
    Set resultString = json.getJsonData("ChronicType^CheckDoctor^CheckNum",count)
    k json
      
    Quit resultString
}

/// Creator: lyy
/// CreatDate：2010-06-
/// Description: 慢性病用药统计
/// Table：
/// Input: 
/// Output：
/// Return：
/// Others：
ClassMethod GetDrugStatInfo(CommunityCode As %String, ChronicType As %String, start As %Integer, limit As %Integer, sort As %String) As %String
{
    Set start=$G(start)
	Set limit=$G(limit)
	
	Set count=0
	Set resultString = ""
	Set end = start+limit  
	
	Set json = ##class(Code.JsonObj).%New()
    Set tmp = ""
    
    
    s result = ##class(%Library.ResultSet).%New()
    
    if ChronicType="HBP" d
    .s sqlStr = "select DrugName, count(*) as Num from (select distinct DrugName, PersonRowId from CHSS.PersonLongTermDrug where DrugName is not null and TableType = 'HBPCheckRecord' and PersonRowId in (select PersonRowId from CHSS.PersonHealthRecordMain where CommunityCode ='"_CommunityCode_"')) group by DrugName"
    e  i ChronicType="Diabetes" d
    .s sqlStr = "select DrugName, count(*) as Num from (select distinct DrugName, PersonRowId from CHSS.PersonLongTermDrug where DrugName is not null and TableType = 'DiabetesCheckRecord' and PersonRowId in (select PersonRowId from CHSS.PersonHealthRecordMain where CommunityCode ='"_CommunityCode_"')) group by DrugName"

       
   			
	d result.Prepare(sqlStr)
	d result.Execute()
	
	While(result.Next())
	{
	
	    s DrugName=result.Data("DrugName")
		s Num=result.Data("Num")
				
		Set tmp = DrugName_"^"_Num
    
     	Set count=count+1
     	If (count>start)&(count<=end) d
     	.d json.InsertRowData(tmp)
    }
    
    d result.Close()
    
    
     
    Set resultString = json.getJsonData("DrugName^Num",count)
    k json
      
    Quit resultString
}

/// Creator: lyy
/// CreatDate：2010-06-
/// Description: 精神病统计
/// Table：
/// Input: 
/// Output：
/// Return：
/// Others：
ClassMethod GetSchizoStatInfo(CommunityCode As %String, start As %Integer, limit As %Integer, sort As %String, whereStr As %String) As %String
{

	
	Set start=$G(start)
	Set limit=$G(limit)
	
	Set count=0
	Set resultString = ""
	Set end = start+limit  
	
	Set json = ##class(Code.JsonObj).%New()
    Set tmp = ""
    
     
    s result = ##class(%Library.ResultSet).%New()
    
    s sqlStr = "select Age, count(*) As Num from ( SELECT CASE WHEN {fn Floor(DATEDIFF('dd', Birth, GETDATE())/365/10)} >=0 and {fn Floor(DATEDIFF('dd', Birth, GETDATE())/365/10)} <=2 THEN '0-30' Else Case WHEN {fn Floor(DATEDIFF('dd', Birth, GETDATE())/365/10)} = 3 THEN '30-40' Else Case WHEN {fn Floor(DATEDIFF('dd', Birth, GETDATE())/365/10)} = 4 THEN '40-50' Else Case WHEN {fn Floor(DATEDIFF('dd', Birth, GETDATE())/365/10)} = 5 THEN '50-60' ELSE '60以上' END END END END As Age from CHSS.PersonHealthRecordMain where Birth is not Null and CommunityCode ='"_CommunityCode_"' "_whereStr_" and PersonRowId in (select PersonRowIdParref from CHSS.PersonHealthDiagnose where ItemdCode = '22' and ItemAssortName = '精神病') ) group by Age"
    
    
   			
	d result.Prepare(sqlStr)
	d result.Execute()
	
	While(result.Next())
	{
		
		s Age=result.Data("Age")
		s Num=result.Data("Num")
		
		Set tmp = Age_"^"_Num
    
     	Set count=count+1
     	If (count>start)&(count<=end) d
     	.d json.InsertRowData(tmp)
	    
    }
    
    d result.Close()
    
           
    Set resultString = json.getJsonData("Age^Num",count)
    k json
      
    Quit resultString
}

Storage Default
{
<Data name="ChronicStatServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.ChronicStatServiceD</DataLocation>
<DefaultData>ChronicStatServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.ChronicStatServiceD</IdLocation>
<IndexLocation>^CHSSWeb.ChronicStatServiceI</IndexLocation>
<StreamLocation>^CHSSWeb.ChronicStatServiceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
