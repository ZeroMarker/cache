Class CHSSWeb.PlannedMethodServices Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// Creator: liuchao
/// CreatDate：2010—05-06
/// Description:避孕措施列表
/// Table：PersonHealthRecordMain
/// Input:CommunityCode , start, limit ,sort
/// Output：
/// Return：
/// Others：
ClassMethod a()
{
	  s result = ##class(%Library.ResultSet).%New()
 	  s sqlStr = "select m.methodName,m.DateOfRegister   from CHSS.PlannedConceptionMethod m"

      d result.Prepare(sqlStr)
		d result.Execute() 
	   While(result.Next())
		{
	  w result.Get("DateOfRegister"),!	
			
	  }
	q "q"
}

ClassMethod List(communityCode As %String, start As %Integer, limit As %Integer, sort As %String, whereStr As %String) As %String
{
		n (communityCode, start, limit, sort, whereStr)
         
		Set communityCode=$G(communityCode)

		Set start=$G(start)
		Set limit=$G(limit)
		Set sort=$G(sort)
		Set count=0
		Set resultString = ""
		Set end = start+limit
		Set json = ##class(Code.JsonObj).%New()
		set PersonRowId = 0
		s result = ##class(%Library.ResultSet).%New()
		//
		s sqlStr = "SELECT p.MethodId,m.personcode,m.personname, p.personrowid,p.MethodName,p.MethodName->Description,p.MethodDate,p.DateOfRegister,p.Register->SSUSR_Name,p.Remark FROM CHSS.PlannedConceptionMethod p,chss.PersonHealthRecordMain m  where p.personrowid=m.personrowid and m.CommunityCode = '"_communityCode_"' "_whereStr
		//w sqlStr
		d result.Prepare(sqlStr)
		d result.Execute() 
		While(result.Next())
		{
			
		set MethodId = result.Get("MethodId")			
		set PersonRowId = result.Get("PersonRowId")		
		set PersonName = result.Get("PersonName")
		set PersonCode = result.Get("PersonCode")
				
	    set Method = result.Get("MethodName")
	    set MethodName = result.Get("Description")
	    
	    set MethodDate = result.Get("MethodDate")
		i MethodDate '= "" d
		.s MethodDate = $zd(MethodDate,3)
	    
	    set DateOfRegister = result.Get("DateOfRegister")
		i DateOfRegister '= "" d
		.s DateOfRegister = $zd(DateOfRegister,3)     
	    
		set RegisterName = result.Get("SSUSR_Name")		
        set Register = result.Get("Register")
		set Remark = result.Get("Remark")

	    Set tmp = MethodId_"^"_PersonRowId_"^"_PersonName_"^"_PersonCode_"^"_Method_"^"_MethodName_"^"_MethodDate_"^"_DateOfRegister_"^"_RegisterName_"^"_Remark 
       
        ;w tmp
         
	    Set count=count+1
	    
		If (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
		}
	    Set resultString = json.getJsonData("MethodId^PersonRowId^PersonName^PersonCode^Method^MethodName^MethodDate^DateOfRegister^RegisterName^Remark",count)
	 	k json
	 	
		Quit resultString
}

ClassMethod Insert(PersonRowId As %String, MethodDate As %Date, Method As %String, DateOfRegister As %Date, Register As %String, Remark As %String)
{
	
	 
  q:PersonRowId="" ""
  s tempCheck = ##class(CHSS.PlannedConceptionMethod).%New()
  
   	s tempPersonHealthMain = ##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowId)
    s tempCheck.PersonRowId=tempPersonHealthMain
 
    i Method '="" d    
    .s tempCheck.MethodName = ##class(CHSS.DictProphylacticMethod).%OpenId(Method)
 
     i MethodDate  '="" d
    .s tempCheck.MethodDate =$zdh(MethodDate ,3)
    
    i DateOfRegister  '="" d
    .s tempCheck.DateOfRegister =$zdh(DateOfRegister ,3)
    
    i Register'=""  d
    .s tempCheck.Register = ##class(User.SSUser).%OpenId(Register)
	s tempCheck.Remark=Remark
	
	s result=tempCheck.%Save()
	 s RowId= tempCheck.%Id() //$g(%ROWID)
     i result = "1" d
     .w "{""success"":""true"",""info"":"_tempCheck.%Id()_"}"
     e  d
     .w "{""success"":""false"",""info"":""数据保存出错!""}"
    q ""
}

ClassMethod Update(MethodId As %String, PersonRowId As %String, MethodDate As %Date, Method As %String, DateOfRegister As %Date, Register As %String, Remark As %String)
{
	
	 
  q:MethodId="" ""
  s tempCheck = ##class(CHSS.PlannedConceptionMethod).%OpenId(MethodId)
    i PersonRowId '="" d
   	.s tempPersonHealthMain = ##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowId)
    .s tempCheck.PersonRowId=tempPersonHealthMain
 
    i Method '="" d    
    .s tempCheck.MethodName = ##class(CHSS.DictProphylacticMethod).%OpenId(Method)
 
     i MethodDate '="" d
    .s tempCheck.MethodDate =$zdh(MethodDate ,3)
    
    i DateOfRegister  '="" d
    .s tempCheck.DateOfRegister =$zdh(DateOfRegister ,3)
    
    
	s tempCheck.Remark=Remark
	s result=tempCheck.%Save()
	 s RowId= tempCheck.%Id() //$g(%ROWID)
     i result = "1" d
     .w "{""success"":""true"",""info"":"_tempCheck.%Id()_"}"
     e  d
     .w "{""success"":""false"",""info"":""数据保存出错!""}"
    q ""
}

ClassMethod Delete(PersonRowId As %String) As %String
{
	&sql(delete from CHSS.PlannedConceptionMethod where PersonRowId= :PersonRowId) 
	  s result=SQLCODE
      Set resultString = ""
      
      i result = "0" d
      .s resultString = "{""success"":""true"",""info"":"_PersonRowId_"}"
      e  d
      .s resultString = "{""success"":""false"",""info"":""数据删除出错!""}"
      
      q resultString
}

Storage Default
{
<Data name="PlannedMethodServicesDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.PlannedMethodServicesD</DataLocation>
<DefaultData>PlannedMethodServicesDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.PlannedMethodServicesD</IdLocation>
<IndexLocation>^CHSSWeb.PlannedMethodServicesI</IndexLocation>
<StreamLocation>^CHSSWeb.PlannedMethodServicesS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
