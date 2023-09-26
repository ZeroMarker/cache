Class CHSSWeb.PersonInHosRecordService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
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
	s InHosRowId=0
	
    For  Set InHosRowId=$O(^CHSS.PersonInHosRecordI("PersonIndex",PersonRowIdParref,InHosRowId)) q:InHosRowId=""  d
	.s tempHos=##class(CHSS.PersonInHosRecord).%OpenId(InHosRowId)
	.
	.s DateInHos=tempHos.DateInHos
	.i DateInHos'="" d
	..s DateInHos=$zd(DateInHos,3)
	.
	.s HospitalName = tempHos.HospitalName
	.s DeptName = tempHos.DeptName
	.s Diagnose = tempHos.Diagnose
	.s Result = tempHos.Result
	.
	.s DateOutHos =tempHos.DateOutHos
	.i tempHos.DateOutHos '= "" d
	..s DateOutHos = $zd(tempHos.DateOutHos,3)
	.
	.s InHosCode = tempHos.InHosCode
	.s Remark = tempHos.Remark
	.
	.s DateRegister = tempHos.DateRegister
	.i tempHos.DateRegister '= "" d
	..s DateRegister = $zd(tempHos.DateRegister,3)
	.
	.s Register = tempHos.Register
	
	.s tmp=""
	.s tmp=InHosRowId_"^"_PersonRowIdParref_"^"_DateInHos_"^"_HospitalName_"^"_DeptName_"^"_Diagnose_"^"_Result_"^"_DateOutHos_"^"_InHosCode_"^"_Remark_"^"_DateRegister_"^"_Register
	.s count=count+1
	.i (count>start)&(count<=end) d
    ..d json.InsertRowData(tmp)
	s resultString = json.getJsonData("InHosRowId^PersonRowIdParref^DateInHos^HospitalName^DeptName^Diagnose^Result^DateOutHos^InHosCode^Remark^DateRegister001^Register",count)
	k json	
	Quit resultString
}

ClassMethod ListShowInfo(PersonRowIdParref, Start, Limit)
{
	Set PersonRowIdParref=$G(PersonRowIdParref)
	Set start=$G(Start)
	Set limit=$G(Limit)
	Set count=0
	Set resultString = ""
	Set end = start+limit

	s InHosRowId=0
	s resultString = ""
	s tmp = ""
	s startStr = "'"
    For  Set InHosRowId=$O(^CHSS.PersonInHosRecordI("PersonIndex",PersonRowIdParref,InHosRowId)) q:InHosRowId=""  d
	.s tempHos=##class(CHSS.PersonInHosRecord).%OpenId(InHosRowId)
	.
	.s DateInHos=tempHos.DateInHos
	.i DateInHos'="" d
	..s DateInHos=$zd(DateInHos,3)
	.
	.s HospitalName = tempHos.HospitalName
	.s DeptName = tempHos.DeptName
	.s Diagnose = tempHos.Diagnose
	.s Result = tempHos.Result
	.
	.s DateOutHos =tempHos.DateOutHos
	.i tempHos.DateOutHos '= "" d
	..s DateOutHos = $zd(tempHos.DateOutHos,3)
	.
	.s InHosCode = tempHos.InHosCode
	.s Remark = tempHos.Remark
	.
	.s DateRegister = tempHos.DateRegister
	.i tempHos.DateRegister '= "" d
	..s DateRegister = $zd(tempHos.DateRegister,3)
	.
	.s Register = tempHos.Register
	.s tmp = tmp_startStr_HospitalName_":"_Diagnose
	.s startStr = "、"
	i tmp '= "" d
	.s tmp = tmp_"'"
	.
	e  d
	.s tmp = """"""
	w "{""success"":""true"",""info"":"_tmp_"}"
	q ""
}

ClassMethod insertupdata(InHosRowId, PersonRowId, DateInHos, HospitalName, DeptName, Diagnose, Result, DateOutHos, InHosCode, Remark, DateRegister, Register)
{
	s tempHos = ""
	
	i InHosRowId '= "" d
	.s tempHos = ##class(CHSS.PersonInHosRecord).%OpenId(InHosRowId)
	e  d
	.s tempHos = ##class(CHSS.PersonInHosRecord).%New()
	
	i PersonRowId '= "" d
	.s tempHos.PersonRowId = ##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowId)
	
	i DateInHos '= "" d
	.s tempHos.DateInHos = $zdh(DateInHos,3)
	
	s tempHos.HospitalName = HospitalName
	s tempHos.DeptName = DeptName
	s tempHos.Diagnose = Diagnose
	s tempHos.Result = Result
	
	i DateOutHos '= "" d
	.s tempHos.DateOutHos = $zdh(DateOutHos,3)
	
	s tempHos.InHosCode = InHosCode
	s tempHos.Remark = Remark
	
	i DateRegister '= "" d
	.s tempHos.DateRegister = $zdh(DateRegister,3)
	
	s tempHos.Register = Register
	
	s resultString = ""
	s result = ""
	
	s result = tempHos.%Save()
	i result = "1" d
	.s resultString = "{""success"":""true"",""info"":"_tempHos.%Id()_"}"
	e  d
	.s resultString = "{""success"":""false"",""info"":""数据保存出错！""}"
	
	q resultString
}

ClassMethod delete(InHosRowId)
{
	q:(InHosRowId = "") ""
	s tempHos = ##class(CHSS.PersonInHosRecord).%OpenId(InHosRowId)
	q:(tempHos = "") ""
	
	s result = tempHos.%DeleteId(InHosRowId)
	
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
<Data name="PersonInHosRecordServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.PersonInHosR988D</DataLocation>
<DefaultData>PersonInHosRecordServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.PersonInHosR988D</IdLocation>
<IndexLocation>^CHSSWeb.PersonInHosR988I</IndexLocation>
<StreamLocation>^CHSSWeb.PersonInHosR988S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
