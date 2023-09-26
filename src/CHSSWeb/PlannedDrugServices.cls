Class CHSSWeb.PlannedDrugServices Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// Creator: liuchao
/// CreatDate：2010—05-06
/// Description:避孕药具领用
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
		s sqlStr = "SELECT p.DurgListId,m.personcode,m.personname, p.personrowid, p.PlannedDrugParref,p.PlannedDrugParref->Description,p.TakeDate,p.ValidDate,p.Register,p.Register->SSUSR_Name,p.Remark  FROM CHSS.PlannedDrugList p,chss.PersonHealthRecordMain m  where p.personrowid=m.personrowid and m.CommunityCode = '"_communityCode_"' "_whereStr
		//w sqlStr
		d result.Prepare(sqlStr)
		d result.Execute() 
		While(result.Next())
		{
			
		set DurgListId = result.Get("DurgListId")			
		set PersonRowId = result.Get("PersonRowId")		
		set PersonName = result.Get("PersonName")
		set PersonCode = result.Get("PersonCode")
				
	    set PlannedDrugParref = result.Get("PlannedDrugParref")
	    set PlannedDrugParrefName = result.Get("Description")
	    
	    
	     
	    set TakeDate = result.Get("TakeDate")
	     i TakeDate '= "" d
		.s TakeDate = $zd(TakeDate,3)
		set ValidDate = result.Get("ValidDate")
		 i ValidDate '= "" d
		.s ValidDate = $zd(ValidDate,3)
		
	 
		set Register = result.Get("Register")
		set RegisterName = result.Get("SSUSR_Name")	
			
		 
		set Remark = result.Get("Remark")

	    Set tmp = DurgListId_"^"_PersonRowId_"^"_PersonName_"^"_PersonCode_"^"_PlannedDrugParref_"^"_PlannedDrugParrefName_"^"_TakeDate_"^"_ValidDate_"^"_RegisterName_"^"_Remark 
       
        ;w tmp
         
	    Set count=count+1
	    
		If (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
		}
	    Set resultString = json.getJsonData("DurgListId^PersonRowId^PersonName^PersonCode^PlannedDrugParref^PlannedDrugParrefName^TakeDate^ValidDate^RegisterName^Remark",count)
	 	k json
	 	
		Quit resultString
}

ClassMethod Insert(PersonRowId As %String, PlannedDrugParref As %String, TakeDate As %Date, ValidDate As %Date, Register As %String, Remark As %String)
{
	
 
  q:PersonRowId="" ""
  s tempCheck = ##class(CHSS.PlannedDrugList).%New()
  
   	s tempPersonHealthMain = ##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowId)
    s tempCheck.PersonRowId=tempPersonHealthMain
 
    i PlannedDrugParref '="" d
    
    .s tempCheck.PlannedDrugParref = ##class(CHSS.DictProphylactic).%OpenId(PlannedDrugParref)
    	
    i TakeDate  '="" d
    .s tempCheck.TakeDate =$zdh(TakeDate ,3)
    
    i ValidDate  '="" d
    .s tempCheck.ValidDate =$zdh(ValidDate ,3)
    
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

ClassMethod Update(DurgListId As %String, PersonRowId As %String, PlannedDrugParref As %String, TakeDate As %Date, ValidDate As %Date, Register As %String, Remark As %String)
{
	
	 
  q:DurgListId="" ""
  s tempCheck = ##class(CHSS.PlannedDrugList).%OpenId(DurgListId)
  	s tempPersonHealthMain = ##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowId)
    s tempCheck.PersonRowId=tempPersonHealthMain
 
    i PlannedDrugParref '="" d
    
    .s tempCheck.PlannedDrugParref = ##class(CHSS.DictProphylactic).%OpenId(PlannedDrugParref)
    	
    i TakeDate  '="" d
    .s tempCheck.TakeDate =$zdh(TakeDate ,3)
    
    i ValidDate  '="" d
    .s tempCheck.ValidDate =$zdh(ValidDate ,3)
    
 
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
	&sql(delete from CHSS.PlannedDrugList where PersonRowId= :PersonRowId) 
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
<Data name="PlannedDrugServicesDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.PlannedDrugServicesD</DataLocation>
<DefaultData>PlannedDrugServicesDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.PlannedDrugServicesD</IdLocation>
<IndexLocation>^CHSSWeb.PlannedDrugServicesI</IndexLocation>
<StreamLocation>^CHSSWeb.PlannedDrugServicesS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
