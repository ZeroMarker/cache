Class CHSSWeb.PatientActivateService Extends %Persistent [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod List(start, limit)
{
	Set start=$G(start)
    Set limit=$G(limit)
    Set count=0
    Set end = start+limit
    Set json = ##class(Code.JsonObj).%New()
      
      
    s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select PatientRowId from CHSS.PatientActivate"
	d result.Prepare(sqlStr)
	d result.Execute()
	q:(result="") "[]"
	s resultString = ""
	s json = ##class(Code.JsonObj).%New()
	While(result.Next())
	{
	   s count=count+1
	   s PatientRowId = result.Data("PatientRowId")
	   s PatientActivate = ##class(CHSS.PatientActivate).%OpenId(PatientRowId)
       s PersonCode=PatientActivate.PersonCode
	   s PatientCode=PatientActivate.PatientCode
       s PatientName=PatientActivate.PatientName
	   s SpellCode=PatientActivate.SpellCode
	   s Sex=PatientActivate.Sex
	   
	  set RegisterDate = PatientActivate.RegisterDate
      i RegisterDate '= "" d
      s RegisterDate = $zd(RegisterDate,3)

	
	   s Remark=PatientActivate.Remark
	   s bValidFlag=PatientActivate.bValidFlag
	   
	     set NearUseDate = PatientActivate.NearUseDate
      i NearUseDate '= "" d
      s NearUseDate = $zd(NearUseDate,3)
	   
	  s tmp=PatientRowId_"^"_PersonCode_"^"_PatientCode_"^"_PatientName_"^"_SpellCode_"^"_Sex_"^"_RegisterDate
	  If (count>start)&(count<=end) d
      .d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("PatientRowId^PersonCode^PatientCode^PatientName^SpellCode^Sex^RegisterDate",count)
    k json
	q resultString
}

ClassMethod insert(PersonRowId, PersonCode, PatientCode, PatientName, SpellCode, Sex, RegisterDate, Remark, bValidFlag, NearUseDate)
{
	 s PatientActivate=""
     s PatientActivate=##class(CHSS.PatientActivate).%New()
     q:(PatientActivate="") 0
   
     i PersonRowId '= "" d
        .s PersonRowIdobj=##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowId)
        .s PatientActivate.PersonRowId=PersonRowIdobj
      
     
     
	 s PatientActivate.PersonCode=PersonCode
	  s PatientActivate.PatientCode=PatientCode
	  s PatientActivate.PatientName=PatientName
	  s PatientActivate.SpellCode=SpellCode
	  s PatientActivate.Sex=Sex

	    i RegisterDate '= "" d
      .s RegisterDate=$zdh(RegisterDate ,3)
      s PatientActivate.RegisterDate=RegisterDate
	  
	  s PatientActivate.Remark=Remark
	  s PatientActivate.bValidFlag=bValidFlag
	  
	  
	    i NearUseDate '= "" d
      .s NearUseDate=$zdh(NearUseDate ,3)
      s PatientActivate.NearUseDate=NearUseDate
	
	                         
	                                     
	 
	
	 s result=""
     s result=PatientActivate.%Save()
     Set resultString = ""
   
     i result = "1" d
     .s resultString = "{""success"":""true"",""info"":"_PatientActivate.%Id()_"}"
     e  d
     .s resultString = "{""success"":""failed"",""info"":""error""}"
     q resultString
}

ClassMethod edit(PatientRowId, PersonCode, PatientCode, PatientName, SpellCode, Sex, RegisterDate, Remark, bValidFlag, NearUseDate)
{
    s PatientActivate=""
    s PatientActivate=##class(CHSS.PatientActivate).%OpenId(PatientRowId)
    q:(PatientActivate="") 0
    
    
    
    
	 s PatientActivate.PersonCode=PersonCode
	  s PatientActivate.PatientCode=PatientCode
	  s PatientActivate.PatientName=PatientName
	  s PatientActivate.SpellCode=SpellCode
	  s PatientActivate.Sex=Sex
	  
	    i RegisterDate '= "" d
      .s RegisterDate=$zdh(RegisterDate ,3)
      s PatientActivate.RegisterDate=RegisterDate
	  
	  s PatientActivate.Remark=Remark
	  s PatientActivate.bValidFlag=bValidFlag
	  
	  
	    i NearUseDate '= "" d
      .s NearUseDate=$zdh(NearUseDate ,3)
      s PatientActivate.NearUseDate=NearUseDate
	
	                         
	                                     
	 
	
	 s result=""
     s result=PatientActivate.%Save()
     Set resultString = ""
   
     i result = "1" d
     .s resultString = "{""success"":""true"",""info"":"_PatientActivate.%Id()_"}"
     e  d
     .s resultString = "{""success"":""failed"",""info"":""error""}"
     q resultString
}

ClassMethod delete(PatientRowId)
{
	 s PatientActivate=""
    s PatientActivate=##class(CHSS.PatientActivate).%OpenId(PatientRowId)
    q:(PatientActivate="") 0
	s result=PatientActivate.%DeleteId(PatientRowId)
	i result="1" d
	. s resultString="{""success"":""true"",""info"":""数据删除成功!""}"
    e  d
    .s resultString = "{""success"":""false"",""info"":""数据删除出错!""}"
    q resultString
}

Storage Default
{
<Data name="PatientActivateServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.PatientActiv8D7D</DataLocation>
<DefaultData>PatientActivateServiceDefaultData</DefaultData>
<IdLocation>^CHSSWeb.PatientActiv8D7D</IdLocation>
<IndexLocation>^CHSSWeb.PatientActiv8D7I</IndexLocation>
<StreamLocation>^CHSSWeb.PatientActiv8D7S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
