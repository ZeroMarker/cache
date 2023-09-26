Class CHSSWeb.PersonDiagnoseRecordService Extends %Persistent [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod List(start, limit)
{
	Set start=$G(start)
    Set limit=$G(limit)
    Set count=0
    Set end = start+limit
    Set json = ##class(Code.JsonObj).%New()
      
      
    s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select DiagnoseRowId from CHSS.PersonDiagnoseRecord"
	d result.Prepare(sqlStr)
	d result.Execute()
	q:(result="") "[]"
	s resultString = ""
	s json = ##class(Code.JsonObj).%New()
	While(result.Next())
	{
	   s count=count+1
	   s DiagnoseRowId = result.Data("DiagnoseRowId")
	   s PersonDiagnoseRecord = ##class(CHSS.PersonDiagnoseRecord).%OpenId(DiagnoseRowId)
	  
       s PersonCode=PersonDiagnoseRecord.PersonCode
	   s PatientCode=PersonDiagnoseRecord.PatientCode
       s PatientName=PersonDiagnoseRecord.PatientName
	   s SpellCode=PersonDiagnoseRecord.SpellCode
	   s Sex=PersonDiagnoseRecord.Sex
	   
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

ClassMethod insert(PatientRowId, PersonRowIdParref, ClinicFlag, YearsUnit, PatientTypeID, DoctorID, CureDoctorId, GetDoctorID, DiagnoseDate, PatientCode, PatientName, SpellCode, SexDR, CaseCode, CardCode, DiagnoseCardCode, RegisterDate, Keenness, PrintFlag, PrintDate, PrintNum, NearUseDate, ValidFlag, DiagnoseFlag, DiagResult, ICDCode, bRequestInHosFlag, bHospitalFlag, DiganoseOPId, OutDate)
{
	 s PersonDiagnoseRecord=""
     s PersonDiagnoseRecord=##class(CHSS.PersonDiagnoseRecord).%New()
     q:(PersonDiagnoseRecord="") 0
   
    
	 i PatientRowId '= "" d
        .s PatientRowIdobj=##class(CHSS.PatientActivate).%OpenId(PatientRowId)
        .s PersonDiagnoseRecord.PatientRowId=PatientRowIdobj


	 i PersonRowIdParref '= "" d
        .s PersonRowIdobj=##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowIdParref)
        .s PersonDiagnoseRecord.PersonRowIdParref=PersonRowIdobj
	
	s PersonDiagnoseRecord.ClinicFlag=ClinicFlag
	s PersonDiagnoseRecord.YearsUnit=YearsUnit
	s PersonDiagnoseRecord.PatientTypeID=PatientTypeID
	s PersonDiagnoseRecord.DoctorID=DoctorID
	s PersonDiagnoseRecord.CureDoctorId=CureDoctorId
	s PersonDiagnoseRecord.GetDoctorID=GetDoctorID

	
	
    i DiagnoseDate '= "" d
    .s DiagnoseDate=$zdh(DiagnoseDate ,3)
    s PersonDiagnoseRecord.DiagnoseDate=DiagnoseDate
	
	s PersonDiagnoseRecord.PatientCode=PatientCode
	s PersonDiagnoseRecord.PatientName=PatientName
	s PersonDiagnoseRecord.SpellCode=SpellCode
	s PersonDiagnoseRecord.SexDR=SexDR
	s PersonDiagnoseRecord.CaseCode=CaseCode
	s PersonDiagnoseRecord.CardCode=CardCode
	s PersonDiagnoseRecord.DiagnoseCardCode=DiagnoseCardCode

	
	i RegisterDate '= "" d
    .s RegisterDate=$zdh(RegisterDate ,3)
    s PersonDiagnoseRecord.RegisterDate=RegisterDate
	
	s PersonDiagnoseRecord.Keenness=Keenness
	s PersonDiagnoseRecord.PrintFlag=PrintFlag

	
	i PrintDate '= "" d
    .s PrintDate=$zdh(PrintDate ,3)
    s PersonDiagnoseRecord.PrintDate=PrintDate
	
	
	s PersonDiagnoseRecord.PrintNum=PrintNum

	
	i NearUseDate '= "" d
    .s NearUseDate=$zdh(NearUseDate ,3)
    s PersonDiagnoseRecord.NearUseDate=NearUseDate
	
	
	s PersonDiagnoseRecord.ValidFlag=ValidFlag
	s PersonDiagnoseRecord.DiagnoseFlag=DiagnoseFlag
	s PersonDiagnoseRecord.DiagResult=DiagResult
	s PersonDiagnoseRecord.ICDCode=ICDCode
	s PersonDiagnoseRecord.bRequestInHosFlag=bRequestInHosFlag
	s PersonDiagnoseRecord.bHospitalFlag=bHospitalFlag	
	s PersonDiagnoseRecord.DiganoseOPId=DiganoseOPId
	
	  

	i OutDate '= "" d
    .s OutDate=$zdh(OutDate ,3)
    s PersonDiagnoseRecord.OutDate=OutDate

	
	 s result=""
     s result=PersonDiagnoseRecord.%Save()
     Set resultString = ""
   
     i result = "1" d
     .s resultString = "{""success"":""true"",""info"":"_PersonDiagnoseRecord.%Id()_"}"
     e  d
     .s resultString = "{""success"":""failed"",""info"":""error""}"
     q resultString
}

ClassMethod edit(DiagnoseRowId, ClinicFlag, YearsUnit, PatientTypeID, DoctorID, CureDoctorId, GetDoctorID, DiagnoseDate, PatientCode, PatientName, SpellCode, SexDR, CaseCode, CardCode, DiagnoseCardCode, RegisterDate, Keenness, PrintFlag, PrintDate, PrintNum, NearUseDate, ValidFlag, DiagnoseFlag, DiagResult, ICDCode, bRequestInHosFlag, bHospitalFlag, DiganoseOPId, OutDate)
{
  	 s PersonDiagnoseRecord=""
     s PersonDiagnoseRecord=##class(CHSS.PersonDiagnoseRecord).%OpenId(DiagnoseRowId)
     q:(PersonDiagnoseRecord="") 0
   


	s PersonDiagnoseRecord.ClinicFlag=ClinicFlag
	s PersonDiagnoseRecord.YearsUnit=YearsUnit
	s PersonDiagnoseRecord.PatientTypeID=PatientTypeID
	s PersonDiagnoseRecord.DoctorID=DoctorID
	s PersonDiagnoseRecord.CureDoctorId=CureDoctorId
	s PersonDiagnoseRecord.GetDoctorID=GetDoctorID

	
	
    i DiagnoseDate '= "" d
    .s DiagnoseDate=$zdh(DiagnoseDate ,3)
    s PersonDiagnoseRecord.DiagnoseDate=DiagnoseDate
	
	s PersonDiagnoseRecord.PatientCode=PatientCode
	s PersonDiagnoseRecord.PatientName=PatientName
	s PersonDiagnoseRecord.SpellCode=SpellCode
	s PersonDiagnoseRecord.SexDR=SexDR
	s PersonDiagnoseRecord.CaseCode=CaseCode
	s PersonDiagnoseRecord.CardCode=CardCode
	s PersonDiagnoseRecord.DiagnoseCardCode=DiagnoseCardCode

	
	i RegisterDate '= "" d
    .s RegisterDate=$zdh(RegisterDate ,3)
    s PersonDiagnoseRecord.RegisterDate=RegisterDate
	
	s PersonDiagnoseRecord.Keenness=Keenness
	s PersonDiagnoseRecord.PrintFlag=PrintFlag

	
	i PrintDate '= "" d
    .s PrintDate=$zdh(PrintDate ,3)
    s PersonDiagnoseRecord.PrintDate=PrintDate
	
	
	s PersonDiagnoseRecord.PrintNum=PrintNum

	
	i NearUseDate '= "" d
    .s NearUseDate=$zdh(NearUseDate ,3)
    s PersonDiagnoseRecord.NearUseDate=NearUseDate
	
	
	s PersonDiagnoseRecord.ValidFlag=ValidFlag
	s PersonDiagnoseRecord.DiagnoseFlag=DiagnoseFlag
	s PersonDiagnoseRecord.DiagResult=DiagResult
	s PersonDiagnoseRecord.ICDCode=ICDCode
	s PersonDiagnoseRecord.bRequestInHosFlag=bRequestInHosFlag
	s PersonDiagnoseRecord.bHospitalFlag=bHospitalFlag	
	s PersonDiagnoseRecord.DiganoseOPId=DiganoseOPId
	
	  

	i OutDate '= "" d
    .s OutDate=$zdh(OutDate ,3)
    s PersonDiagnoseRecord.OutDate=OutDate

	
	 s result=""
     s result=PersonDiagnoseRecord.%Save()
     Set resultString = ""
   
     i result = "1" d
     .s resultString = "{""success"":""true"",""info"":"_PersonDiagnoseRecord.%Id()_"}"
     e  d
     .s resultString = "{""success"":""failed"",""info"":""error""}"
     q resultString
}

ClassMethod delete(DiagnoseRowId)
{
     
	s PersonDiagnoseRecord=""
    s PersonDiagnoseRecord=##class(CHSS.PersonDiagnoseRecord).%OpenId(DiagnoseRowId)
    q:(PersonDiagnoseRecord="") 0
	s result=PersonDiagnoseRecord.%DeleteId(DiagnoseRowId)
	i result="1" d
	. s resultString="{""success"":""true"",""info"":""数据删除成功!""}"
    e  d
    .s resultString = "{""success"":""false"",""info"":""数据删除出错!""}"
    q resultString
}

Storage Default
{
<Data name="PersonDiagnoseRecordServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.PersonDiagnoAD1D</DataLocation>
<DefaultData>PersonDiagnoseRecordServiceDefaultData</DefaultData>
<IdLocation>^CHSSWeb.PersonDiagnoAD1D</IdLocation>
<IndexLocation>^CHSSWeb.PersonDiagnoAD1I</IndexLocation>
<StreamLocation>^CHSSWeb.PersonDiagnoAD1S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
