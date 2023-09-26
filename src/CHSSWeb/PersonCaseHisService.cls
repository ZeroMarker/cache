Class CHSSWeb.PersonCaseHisService Extends %Persistent [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod List(start, limit)
{
	Set start=$G(start)
    Set limit=$G(limit)
    Set count=0
    Set end = start+limit
    Set json = ##class(Code.JsonObj).%New()
      
      
    s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select CaseHisRowId from CHSS.PersonCaseHis"
	d result.Prepare(sqlStr)
	d result.Execute()
	q:(result="") "[]"
	s resultString = ""
	s json = ##class(Code.JsonObj).%New()
	While(result.Next())
	{
	   s count=count+1
	   s CaseHisRowId = result.Data("CaseHisRowId")
	   s PersonCaseHis = ##class(CHSS.PersonCaseHis).%OpenId(CaseHisRowId)
	  

   
	
	s BookRowId=PersonCaseHis.BookRowId
	
	s cCaseHis=PersonCaseHis.cCaseHis
	s cWord=PersonCaseHis.cWord
	s BookDetailDR=PersonCaseHis.BookDetailDR
	s DeptRowIdDR=PersonCaseHis.DeptRowIdDR
	s DoctorId=PersonCaseHis.DoctorId
	
	
	  set WriteDate = PersonCaseHis.WriteDate
      i WriteDate '= "" d
      s WriteDate = $zd(WriteDate,3)
	
	  set CheckDate = PersonCaseHis.CheckDate
      i CheckDate '= "" d
      s CheckDate = $zd(CheckDate,3)


	s UpDoctorId=PersonCaseHis.UpDoctorId
	
	 set UpDoctorDate = PersonCaseHis.UpDoctorDate
      i UpDoctorDate '= "" d
      s UpDoctorDate = $zd(UpDoctorDate,3)
	
	s DirectDoctorId=PersonCaseHis.DirectDoctorId
	s PatientCode=PersonCaseHis.PatientCode
	s SpellCode=PersonCaseHis.SpellCode
	s PatientName=PersonCaseHis.PatientName
	s ParentTypeDR=PersonCaseHis.ParentTypeDR
	s PrintNo=PersonCaseHis.PrintNo
	s PatientActionDR=PersonCaseHis.PatientActionDR
	s CaseHisTipId=PersonCaseHis.CaseHisTipId
	
	set DirectDoctorDate = PersonCaseHis.DirectDoctorDate
      i DirectDoctorDate '= "" d
      s DirectDoctorDate = $zd(DirectDoctorDate,3)

	  s tmp=CaseHisRowId_"^"_BookRowId_"^"_cCaseHis_"^"_cWord_"^"_BookDetailDR_"^"_DeptRowIdDR_"^"_DoctorId_"^"_WriteDate_"^"_CheckDate_"^"_UpDoctorId_"^"_UpDoctorDate_"^"_DirectDoctorId_"^"_PatientCode_"^"_SpellCode_"^"_PatientName_"^"_ParentTypeDR_"^"_PrintNo_"^"_PatientActionDR_"^"_CaseHisTipId_"^"_DirectDoctorDate
	  If (count>start)&(count<=end) d
      .d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("CaseHisRowId^BookRowId^cCaseHis^cWord^BookDetailDR^DeptRowIdDR^DoctorId^WriteDate^CheckDate^UpDoctorId^UpDoctorDate^DirectDoctorId^PatientCode^SpellCode^PatientName^ParentTypeDR^PrintNo^PatientActionDR^CaseHisTipId^DirectDoctorDate",count)
    k json
	q resultString
}

ClassMethod insert(DiagnoseRowId, BookRowId, PersonRowId, cCaseHis, cWord, BookDetailDR, DeptRowIdDR, DoctorId, WriteDate, CheckDate, UpDoctorId, UpDoctorDate, DirectDoctorId, PatientCode, SpellCode, PatientName, ParentTypeDR, PrintNo, PatientActionDR, CaseHisTipId, DirectDoctorDate)
{
	 s PersonCaseHis=""
     s PersonCaseHis=##class(CHSS.PersonCaseHis).%New()
     q:(PersonCaseHis="") 0
    
    
     i DiagnoseRowId '= "" d
        .s DiagnoseRowIdobj=##class(CHSS.PersonDiagnoseRecord).%OpenId(DiagnoseRowId)
        .s PersonCaseHis.DiagnoseRowId=DiagnoseRowIdobj
    
    
    
    
	 s PersonCaseHis.BookRowId=BookRowId
	 
	 i PersonRowId '= "" d
        .s PersonRowIdobj=##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowId)
        .s PersonCaseHis.PersonRowId=PersonRowIdobj
	 
	  s PersonCaseHis.cCaseHis=cCaseHis
	  s PersonCaseHis.cWord=cWord
	  s PersonCaseHis.BookDetailDR=BookDetailDR
	   s PersonCaseHis.DeptRowIdDR=DeptRowIdDR
	   s PersonCaseHis.DoctorId=DoctorId
	          
	   i WriteDate '= "" d
       .s WriteDate=$zdh(WriteDate ,3)
       s PersonCaseHis.Writedate=WriteDate
	    
	    
	     i CheckDate '= "" d
      .s CheckDate=$zdh(CheckDate ,3)
      s PersonCaseHis.Checkdate=CheckDate
	   
	   s PersonCaseHis.UpDoctorId=UpDoctorId
	   
	   
	   
	    
	     i UpDoctorDate '= "" d
      .s UpDoctorDate=$zdh(UpDoctorDate ,3)
      s PersonCaseHis.UpDoctordate=UpDoctorDate
      
      
	   s PersonCaseHis.DirectDoctorId=DirectDoctorId
	   s PersonCaseHis.PatientCode=PatientCode
	   s PersonCaseHis.SpellCode=SpellCode
	   s PersonCaseHis.PatientName=PatientName
	   
	  s PersonCaseHis.ParentTypeDR=ParentTypeDR
	  s PersonCaseHis.PrintNo=PrintNo
	  s PersonCaseHis.PatientActionDR=PatientActionDR
	  s PersonCaseHis.CaseHisTipId=CaseHisTipId
	          
	          
	  i DirectDoctorDate '= "" d
      .s DirectDoctorDate=$zdh(DirectDoctorDate ,3)
      s PersonCaseHis.DirectDoctordate=DirectDoctorDate
	                
	
	 s result=""
     s result=PersonCaseHis.%Save()
     Set resultString = ""
     
     
     i result = "1" d
     .s resultString = "{""success"":""true"",""info"":"_PersonCaseHis.%Id()_"}"
     e  d
     .s resultString = "{""success"":""failed"",""info"":""error""}"
     q resultString
}

ClassMethod edit(CaseHisRowId, BookRowId, cCaseHis, cWord, BookDetailDR, DeptRowIdDR, DoctorId, WriteDate, CheckDate, UpDoctorId, UpDoctorDate, DirectDoctorId, PatientCode, SpellCode, PatientName, ParentTypeDR, PrintNo, PatientActionDR, CaseHisTipId, DirectDoctorDate)
{
   s PersonCaseHis=""
     s PersonCaseHis=##class(CHSS.PersonCaseHis).%OpenId(CaseHisRowId)
     q:(PersonCaseHis="") 0
   
   
	 s PersonCaseHis.BookRowId=BookRowId

	  s PersonCaseHis.cCaseHis=cCaseHis
	  s PersonCaseHis.cWord=cWord
	  s PersonCaseHis.BookDetailDR=BookDetailDR
	   s PersonCaseHis.DeptRowIdDR=DeptRowIdDR
	   s PersonCaseHis.DoctorId=DoctorId
	   
	    i WriteDate '= "" d
      .s WriteDate=$zdh(WriteDate ,3)
      s PersonCaseHis.Writedate=WriteDate
	    
	    
	     i CheckDate '= "" d
      .s CheckDate=$zdh(CheckDate ,3)
      s PersonCaseHis.Checkdate=CheckDate
	   
	   s PersonCaseHis.UpDoctorId=UpDoctorId
	   
	   
	   
	    
	     i UpDoctorDate '= "" d
      .s UpDoctorDate=$zdh(UpDoctorDate ,3)
      s PersonCaseHis.UpDoctordate=UpDoctorDate
      
      
	   s PersonCaseHis.DirectDoctorId=DirectDoctorId
	   s PersonCaseHis.PatientCode=PatientCode
	   s PersonCaseHis.SpellCode=SpellCode
	   s PersonCaseHis.PatientName=PatientName
	   
	  s PersonCaseHis.ParentTypeDR=ParentTypeDR
	  s PersonCaseHis.PrintNo=PrintNo
	  s PersonCaseHis.PatientActionDR=PatientActionDR
	  s PersonCaseHis.CaseHisTipId=CaseHisTipId
	          
	          
	  i DirectDoctorDate '= "" d
      .s DirectDoctorDate=$zdh(DirectDoctorDate ,3)
      s PersonCaseHis.DirectDoctordate=DirectDoctorDate
	                
	
	 s result=""
     s result=PersonCaseHis.%Save()
     Set resultString = ""
   
     i result = "1" d
     .s resultString = "{""success"":""true"",""info"":"_PersonCaseHis.%Id()_"}"
     e  d
     .s resultString = "{""success"":""failed"",""info"":""error""}"
     q resultString
}

ClassMethod delete(CaseHisRowId)
{
	 s PersonCaseHis=""
     s PersonCaseHis=##class(CHSS.PersonCaseHis).%OpenId(CaseHisRowId)
     q:(PersonCaseHis="") 0
	s result=PersonCaseHis.%DeleteId(CaseHisRowId)
	i result="1" d
	. s resultString="{""success"":""true"",""info"":""数据删除成功!""}"
    e  d
    .s resultString = "{""success"":""false"",""info"":""数据删除出错!""}"
    q resultString
}

Storage Default
{
<Data name="PersonCaseHisServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.PersonCaseHisServiceD</DataLocation>
<DefaultData>PersonCaseHisServiceDefaultData</DefaultData>
<IdLocation>^CHSSWeb.PersonCaseHisServiceD</IdLocation>
<IndexLocation>^CHSSWeb.PersonCaseHisServiceI</IndexLocation>
<StreamLocation>^CHSSWeb.PersonCaseHisServiceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
