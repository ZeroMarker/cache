Class CHSSWeb.PlannedServices Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// Creator: liuchao
/// CreatDate：2010—05-06
/// Description:计划生育登记
/// Table：PersonHealthRecordMain
/// Input:CommunityCode , start, limit ,sort
/// Output：
/// Return：
/// Others：
ClassMethod PlannedList(communityCode As %String, start As %Integer, limit As %Integer, sort As %String, whereStr As %String) As %String
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
		s sqlStr = "SELECT p.PlannedRowId,m.personcode,m.personname, p.personrowid,p.BirthRowIDParref,p.BirthRowIDParref->Description,p.CurrentPregnancy,p.CurrentGiveBirth,p.InPlanMan,p.InPlanFemail,p.OutPlanMan,p.OutPlanFemail,p.Register,p.Register->SSUSR_Name,p.RegisterDate,p.Remark FROM CHSS.PlannedParenthood p,chss.PersonHealthRecordMain m  where p.personrowid=m.personrowid and m.CommunityCode = '"_communityCode_"' "_whereStr
		//w sqlStr
		d result.Prepare(sqlStr)
		d result.Execute() 
		While(result.Next())
		{
			
		set PlannedRowId = result.Get("PlannedRowId")			
		set PersonRowId = result.Get("PersonRowId")		
		set PersonName = result.Get("PersonName")
		set PersonCode = result.Get("PersonCode")
				
	    set BirthRowIDParref = result.Get("BirthRowIDParref")
	    set BirthRowIDParrefName = result.Get("Description")
	    set CurrentPregnancy = result.Get("CurrentPregnancy")
		set CurrentGiveBirth = result.Get("CurrentGiveBirth")
		set InPlanMan = result.Get("InPlanMan")
		set InPlanFemail = result.Get("InPlanFemail")
		set OutPlanMan = result.Get("OutPlanMan")
		set OutPlanFemail = result.Get("OutPlanFemail")
		set Register = result.Get("Register")
		set RegisterName = result.Get("SSUSR_Name")		
		set RegisterDate = result.Get("RegisterDate")
		i RegisterDate '= "" d
		.s RegisterDate = $zd(RegisterDate,3)
		set Remark = result.Get("Remark")

	    Set tmp = PlannedRowId_"^"_PersonRowId_"^"_PersonName_"^"_PersonCode	_"^"_BirthRowIDParref_"^"_BirthRowIDParrefName_"^"_CurrentPregnancy_"^"_CurrentGiveBirth_"^"_InPlanMan_"^"_InPlanFemail_"^"_OutPlanMan_"^"_OutPlanFemail_"^"_RegisterName_"^"_RegisterName_"^"_RegisterDate_"^"_Remark 
       
        ;w tmp
         
	    Set count=count+1
	    
		If (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
		}
	    Set resultString = json.getJsonData("PlannedRowId^PersonRowId^PersonName^PersonCode^BirthRowIDParref^BirthRowIDParrefName^CurrentPregnancy^CurrentGiveBirth^InPlanMan^InPlanFemail^OutPlanMan^OutPlanFemail^Register^RegisterName^RegisterDate^Remark",count)
	 	k json
	 	
		Quit resultString
}

ClassMethod InsertPlanned(PersonRowId As %String, BirthRowIDParref As %String, CurrentPregnancy As %String, CurrentGiveBirth As %String, InPlanMan As %String, InPlanFemail As %String, OutPlanMan As %String, OutPlanFemail As %String, Register As %String, RegisterDate As %Date, Remark As %String)
{
	
	 
  q:PersonRowId="" ""
  s tempCheck = ##class(CHSS.PlannedParenthood).%New()
  
   	s tempPersonHealthMain = ##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowId)
    s tempCheck.PersonRowId=tempPersonHealthMain
 
    i BirthRowIDParref '="" d
    
    .s tempCheck.BirthRowIDParref = ##class(CHSS.DictPlanBirthStatus).%OpenId(BirthRowIDParref)
 
	s tempCheck.CurrentPregnancy=CurrentPregnancy
	s tempCheck.CurrentGiveBirth=CurrentGiveBirth
	s tempCheck.InPlanMan=InPlanMan
	s tempCheck.InPlanFemail=InPlanFemail
	s tempCheck.OutPlanMan=OutPlanMan
	s tempCheck.OutPlanFemail=OutPlanFemail
	
	
    i RegisterDate  '="" d
    .s tempCheck.RegisterDate =$zdh(RegisterDate ,3)
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

ClassMethod UpdatePlanned(PlannedRowId As %String, PersonRowId As %String, BirthRowIDParref As %String, CurrentPregnancy As %String, CurrentGiveBirth As %String, InPlanMan As %String, InPlanFemail As %String, OutPlanMan As %String, OutPlanFemail As %String, Register As %String, RegisterDate As %Date, Remark As %String)
{
	
	 
  q:PlannedRowId="" ""
  s tempCheck = ##class(CHSS.PlannedParenthood).%OpenId(PlannedRowId)
    i PersonRowId '="" d
   	.s tempPersonHealthMain = ##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowId)
    .s tempCheck.PersonRowId=tempPersonHealthMain
 
    i BirthRowIDParref '="" d
    
    .s tempCheck.BirthRowIDParref = ##class(CHSS.DictPlanBirthStatus).%OpenId(BirthRowIDParref)
 
	s tempCheck.CurrentPregnancy=CurrentPregnancy
	s tempCheck.CurrentGiveBirth=CurrentGiveBirth
	s tempCheck.InPlanMan=InPlanMan
	s tempCheck.InPlanFemail=InPlanFemail
	s tempCheck.OutPlanMan=OutPlanMan
	s tempCheck.OutPlanFemail=OutPlanFemail
	
	
    i RegisterDate  '="" d
    .s tempCheck.RegisterDate =$zdh(RegisterDate ,3)
    
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
	&sql(delete from CHSS.PlannedParenthood where PersonRowId= :PersonRowId) 
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
<Data name="PlannedServicesDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.PlannedServicesD</DataLocation>
<DefaultData>PlannedServicesDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.PlannedServicesD</IdLocation>
<IndexLocation>^CHSSWeb.PlannedServicesI</IndexLocation>
<StreamLocation>^CHSSWeb.PlannedServicesS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
