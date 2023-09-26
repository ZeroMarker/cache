Class CHSSWeb.PlannedPremarriageServices Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// Creator: liuchao
/// CreatDate：2010—05-06
/// Description: 婚前检查登记表
/// Table：PersonHealthRecordMain
/// Input:CommunityCode , start, limit ,sort
/// Output：
/// Return：
/// Others：
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
		s sqlStr = "SELECT p.CheckUpRowId,m.personcode,m.personname,m.SexDr->CTSEX_Desc, p.personrowid,p.CheckUpDate,p.CheckResult,p.DoctorOpinion,p.OperatorDate,p.Register,p.Register->SSUSR_Name,p.Remark  FROM CHSS.PlannedPremarriageCheckup p,chss.PersonHealthRecordMain m  where p.personrowid=m.personrowid and m.CommunityCode = '"_communityCode_"' "_whereStr
		//w sqlStr
		d result.Prepare(sqlStr)
		d result.Execute() 
		While(result.Next())
		{
			
		set CheckUpRowId = result.Get("CheckUpRowId")			
		set PersonRowId = result.Get("PersonRowId")		
		set PersonName = result.Get("PersonName")
	   set SexName = result.Get("CTSEX_Desc")
		set PersonCode = result.Get("PersonCode")
				
	    set CheckResult = result.Get("CheckResult")
	    set DoctorOpinion = result.Get("DoctorOpinion")
	    
	    
	     
	    set CheckUpDate = result.Get("CheckUpDate")
	     i CheckUpDate '= "" d
		.s CheckUpDate = $zd(CheckUpDate,3)
		set OperatorDate = result.Get("OperatorDate")
		 i OperatorDate '= "" d
		.s OperatorDate = $zd(OperatorDate,3)
		
	 
		set Register = result.Get("Register")
		set RegisterName = result.Get("SSUSR_Name")	
			
		 
		set Remark = result.Get("Remark")

	    Set tmp = CheckUpRowId_"^"_PersonRowId_"^"_PersonName_"^"_SexName_"^"_PersonCode_"^"_CheckResult_"^"_DoctorOpinion_"^"_CheckUpDate_"^"_OperatorDate_"^"_RegisterName_"^"_Remark 
       
        ;w tmp
         
	    Set count=count+1
	    
		If (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
		}
	    Set resultString = json.getJsonData("CheckUpRowId^PersonRowId^PersonName^SexName^PersonCode^CheckResult^DoctorOpinion^CheckUpDate^OperatorDate^RegisterName^Remark",count)
	 	k json
	 	
		Quit resultString
}

ClassMethod Insert(PersonRowId As %String, CheckUpDate As %Date, CheckResult As %String, DoctorOpinion As %String, Remark As %String, OperatorDate As %Date, Register As %String) As %String
{
	 
	 
  q:PersonRowId="" ""
  s tempCheck = ##class(CHSS.PlannedPremarriageCheckup).%New()
  
   	s tempPersonHealthMain = ##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowId)
    s tempCheck.PersonRowId=tempPersonHealthMain
    s tempCheck.CheckResult=CheckResult
    s tempCheck.DoctorOpinion=DoctorOpinion
  
    	
    i CheckUpDate  '="" d  
    .s tempCheck.CheckUpDate =$zdh(CheckUpDate ,3)
    
    i OperatorDate  '="" d
    .s tempCheck.OperatorDate =$zdh(OperatorDate ,3)
    
    i Register'=""  d
    .s tempCheck.Register = ##class(User.SSUser).%OpenId(Register)
	s tempCheck.Remark=Remark
	
	s result=tempCheck.%Save()
	 s RowId= tempCheck.%Id()  
     i result = "1" d
     .w "{""success"":""true"",""info"":"_tempCheck.%Id()_"}"
     e  d
     .w "{""success"":""false"",""info"":""数据保存出错!""}"
    q ""
}

ClassMethod Update(CheckUpRowId As %String, PersonRowId As %String, CheckUpDate As %Date, CheckResult As %String, DoctorOpinion As %String, Remark As %String, OperatorDate As %Date, Register As %String)
{
	
	 
  q:CheckUpRowId="" ""
  s tempCheck = ##class(CHSS.PlannedPremarriageCheckup).%OpenId(CheckUpRowId)
  	s tempPersonHealthMain = ##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowId)
    s tempCheck.PersonRowId=tempPersonHealthMain
    s tempCheck.CheckResult=CheckResult
    s tempCheck.DoctorOpinion=DoctorOpinion
  
    	
    i CheckUpDate  '="" d
    .s tempCheck.CheckUpDate =$zdh(CheckUpDate ,3)
    
    i OperatorDate  '="" d
    .s tempCheck.OperatorDate =$zdh(OperatorDate ,3)
    
  
	s tempCheck.Remark=Remark
	
  	s result=tempCheck.%Save()
	 s RowId= tempCheck.%Id()  
     i result = "1" d
     .w "{""success"":""true"",""info"":"_tempCheck.%Id()_"}"
     e  d
     .w "{""success"":""false"",""info"":""数据保存出错!""}"
    q ""
}

ClassMethod Delete(PersonRowId As %String) As %String
{
	&sql(delete from CHSS.PlannedPremarriageCheckup where PersonRowId= :PersonRowId) 
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
<Data name="PlannedPremarriageServicesDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.PlannedPremaA75D</DataLocation>
<DefaultData>PlannedPremarriageServicesDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.PlannedPremaA75D</IdLocation>
<IndexLocation>^CHSSWeb.PlannedPremaA75I</IndexLocation>
<StreamLocation>^CHSSWeb.PlannedPremaA75S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
