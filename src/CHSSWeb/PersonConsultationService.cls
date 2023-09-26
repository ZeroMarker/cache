Class CHSSWeb.PersonConsultationService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

ClassMethod List(PersonRowIdParref, Start, Limit)
{
	Set PersonRowIdParref=$G(PersonRowIdParref)
	Set start=$G(Start)
	Set limit=$G(Limit)
	Set count=0
	Set resultString = ""
	Set end = start+limit
	Set json = ##class(Code.JsonObj).%New()
	s ConsultationRowId=0
	
    For  Set ConsultationRowId=$O(^CHSS.PersonConsultationI("PersonIndex",PersonRowIdParref,ConsultationRowId)) q:ConsultationRowId=""  d
	.s tempHos=##class(CHSS.PersonConsultation).%OpenId(ConsultationRowId)
	.
	.s ConsultDate=tempHos.ConsultDate
	.i ConsultDate'="" d
	..s ConsultDate=$zd(ConsultDate,3)
	.
	.s ConsultReason = tempHos.ConsultReason
	.s ConsultSuggestion = tempHos.ConsultSuggestion
	.s MainDoctor = tempHos.MainDoctor
	.s Remark = tempHos.Remark
	.
	.s DateRegister =tempHos.DateRegister
	.i tempHos.DateRegister '= "" d
	..s DateRegister = $zd(tempHos.DateRegister,3)
	.
	.
	.s Remark = tempHos.Remark
	.
	.s Register = tempHos.Register
	.
	.s tmp=""
	.s tmp=ConsultationRowId_"^"_PersonRowIdParref_"^"_ConsultDate_"^"_ConsultReason_"^"_ConsultSuggestion_"^"_MainDoctor_"^"_Remark_"^"_DateRegister_"^"_Register
	.s count=count+1
	.i (count>start)&(count<=end) d
    ..d json.InsertRowData(tmp)
	s resultString = json.getJsonData("ConsultationRowId^PersonRowIdParref^ConsultDate^ConsultReason^ConsultSuggestion^MainDoctor^Remark^DateRegister1^Register",count)
	k json	
	Quit resultString
}

ClassMethod insertupdata(ConsultationRowId, PersonRowId, ConsultDate, ConsultReason, ConsultSuggestion, MainDoctor, Remark, DateRegister, Register)
{
	s tempHos = ""
	
	i ConsultationRowId '= "" d
	.s tempHos = ##class(CHSS.PersonConsultation).%OpenId(ConsultationRowId)
	e  d
	.s tempHos = ##class(CHSS.PersonConsultation).%New()
	
	i PersonRowId '= "" d
	.s tempHos.PersonRowId = ##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowId)
	
	i ConsultDate '= "" d
	.s tempHos.ConsultDate = $zdh(ConsultDate,3)
	
	s tempHos.ConsultReason = ConsultReason
	s tempHos.ConsultSuggestion = ConsultSuggestion
	s tempHos.MainDoctor = MainDoctor
	s tempHos.Remark = Remark
	
	i DateRegister '= "" d
	.s tempHos.DateRegister = $zdh(DateRegister,3)
	
	s tempHos.Register = Register
	
	s resultString = ""
	s result = ""
	
	s result = tempHos.%Save()
	;w result
	i result = "1" d
	.s resultString = "{""success"":""true"",""info"":"_tempHos.%Id()_"}"
	e  d
	.s resultString = "{""success"":""false"",""info"":""数据保存出错！""}"
	
	q resultString
}

ClassMethod delete(ConsultationRowId)
{
	q:(ConsultationRowId = "") ""
	s tempHos = ##class(CHSS.PersonConsultation).%OpenId(ConsultationRowId)
	q:(tempHos = "") ""
	
	s result = tempHos.%DeleteId(ConsultationRowId)
	
	i result = "1" d
	.w "{""success"":""true"",""info"":""数据删除成功！""}"
    .
    e  d
    .w "{""success"":""false"",""info"":""数据删除出错！""}"
    .
    q ""
}

Storage Default
{
<Data name="PersonConsultationServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.PersonConsulA4BD</DataLocation>
<DefaultData>PersonConsultationServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.PersonConsulA4BD</IdLocation>
<IndexLocation>^CHSSWeb.PersonConsulA4BI</IndexLocation>
<StreamLocation>^CHSSWeb.PersonConsulA4BS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
