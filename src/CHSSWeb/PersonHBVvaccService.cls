Class CHSSWeb.PersonHBVvaccService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// Creator: lyy
/// CreatDate：2009—09-23
/// Description:检索体检乙肝疫苗接种情况
/// Table：PersonHBVvacc
/// Input: PersonHBVvacc
/// Output：
/// Return：
/// Others：
ClassMethod ListPage(start As %Integer, limit As %Integer, PersonRowId As %Integer) As %String
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT VaccRowId, PersonRowId, YearOfVacc, TimesOfVaccination, TimeOfMonitor, VaccPlan, HBsQuality, HBsRation, VaccPlace, VaccinationPlace, DosageOfVaccination FROM CHSS.PersonHBVvacc where PersonRowId ="_PersonRowId
		
	d result.Prepare(sqlStr)
	d result.Execute()
	
	Set start=$G(start)
	Set limit=$G(limit)
	
	Set count=0
	Set resultString = ""
	Set end = start+limit
	
	Set json = ##class(Code.JsonObj).%New()
	
	While(result.Next())
	{
	s VaccRowId = result.Data("VaccRowId")	
	s PersonRowId = result.Data("PersonRowId")
	s YearOfVacc = result.Data("YearOfVacc")
	s TimesOfVaccination = result.Data("TimesOfVaccination")
	s TimeOfMonitor = result.Data("TimeOfMonitor")
	i (TimeOfMonitor'="") d
	.s TimeOfMonitor = $zd(TimeOfMonitor,3)
	s VaccPlan = result.Data("VaccPlan")
	s HBsQuality = result.Data("HBsQuality")
	s HBsRation = result.Data("HBsRation")
	s VaccPlace = result.Data("VaccPlace")
	s VaccinationPlace = result.Data("VaccinationPlace")
	s DosageOfVaccination = result.Data("DosageOfVaccination")	
	
	
	Set tmp=VaccRowId_"^"_PersonRowId_"^"_YearOfVacc_"^"_TimesOfVaccination_"^"_TimeOfMonitor_"^"_VaccPlan_"^"_HBsQuality_"^"_HBsRation_"^"_VaccPlace_"^"_VaccinationPlace_"^"_DosageOfVaccination

	Set count = count+1
	If (count>start)&(count<=end) d
	.d json.InsertRowData(tmp)
	}	
	
	Set resultString = json.getJsonData("VaccRowId^PersonRowId^YearOfVacc^TimesOfVaccination^TimeOfMonitor^VaccPlan^HBsQuality^HBsRation^VaccPlace^VaccinationPlace^DosageOfVaccination",count)
	
	k json
	d result.Close()
	q resultString
}

ClassMethod ShowInfo(start As %Integer, limit As %Integer, PersonRowId As %Integer, RecordId As %Integer, TableType As %String) As %String
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT VaccRowId, PersonRowId, YearOfVacc, TimesOfVaccination, TimeOfMonitor, VaccPlan, HBsQuality, HBsRation, VaccPlace, VaccinationPlace, DosageOfVaccination FROM CHSS.PersonHBVvacc where PersonRowId ="_PersonRowId
		
	d result.Prepare(sqlStr)
	d result.Execute()
	
	Set start=$G(start)
	Set limit=$G(limit)
	
	Set count=0
	Set resultString = ""
	Set end = start+limit
	
	set tmp = ""
	set startStr = "'"
	
	While(result.Next())
	{
		
	s VaccRowId = result.Data("VaccRowId")	
	s PersonRowId = result.Data("PersonRowId")
	s YearOfVacc = result.Data("YearOfVacc")
	s TimesOfVaccination = result.Data("TimesOfVaccination")
	s TimeOfMonitor = result.Data("TimeOfMonitor")
	i (TimeOfMonitor'="") d
	.s TimeOfMonitor = $zd(TimeOfMonitor,3)
	s VaccPlan = result.Data("VaccPlan")
	s HBsQuality = result.Data("HBsQuality")
	s HBsRation = result.Data("HBsRation")
	s VaccPlace = result.Data("VaccPlace")
	s VaccinationPlace = result.Data("VaccinationPlace")
	s DosageOfVaccination = result.Data("DosageOfVaccination")	
	Set tmp = tmp_startStr_YearOfVacc
	s startStr = "、"
	}
	
	i tmp '= "" d
	.s tmp = tmp_"'"
	e  d
	.s tmp = """"""
	q "{""success"":""true"",""info"":"_tmp_"}"
}

ClassMethod insert(PersonRowId, YearOfVacc, TimesOfVaccination, TimeOfMonitor, VaccPlan, HBsQuality, HBsRation, VaccPlace, VaccinationPlace, DosageOfVaccination) As %String
{
	q:(PersonRowId="") "个人档案号为空，保存出错！"
		
	s VaccRowId=""
	q:VaccRowId'="" "code-rep"
	i TimeOfMonitor '= "" d
	.s TimeOfMonitor=$zdh(TimeOfMonitor,3)
	
	&sql(insert into CHSS.PersonHBVvacc (PersonRowId, YearOfVacc, TimesOfVaccination, TimeOfMonitor, VaccPlan, HBsQuality, HBsRation, VaccPlace, VaccinationPlace, DosageOfVaccination) values(:PersonRowId, :YearOfVacc, :TimesOfVaccination, :TimeOfMonitor, :VaccPlan, :HBsQuality, :HBsRation, :VaccPlace, :VaccinationPlace, :DosageOfVaccination))
	q SQLCODE
}

ClassMethod update(VaccRowId, YearOfVacc, TimesOfVaccination, TimeOfMonitor, VaccPlan, HBsQuality, HBsRation, VaccPlace, VaccinationPlace, DosageOfVaccination) As %String
{
	q:(VaccRowId="") "code-rep"
	i TimeOfMonitor '= "" d
	.s TimeOfMonitor=$zdh(TimeOfMonitor,3)
	&sql(update CHSS.PersonHBVvacc set YearOfVacc=:YearOfVacc,TimesOfVaccination=:TimesOfVaccination,TimeOfMonitor=:TimeOfMonitor,VaccPlan=:VaccPlan,HBsQuality=:HBsQuality,HBsRation=:HBsRation,VaccPlace=:VaccPlace,VaccinationPlace=:VaccinationPlace,DosageOfVaccination=:DosageOfVaccination where %ID=:VaccRowId)
	q SQLCODE
}

//删除一条数据库中已经存在的记录

ClassMethod delete(VaccRowId) As %String
{

	&sql(delete from CHSS.PersonHBVvacc where %ID=:VaccRowId)
	q SQLCODE
}

Storage Default
{
<Data name="PersonHBVvaccServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.PersonHBVvaccServiceD</DataLocation>
<DefaultData>PersonHBVvaccServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.PersonHBVvaccServiceD</IdLocation>
<IndexLocation>^CHSSWeb.PersonHBVvaccServiceI</IndexLocation>
<StreamLocation>^CHSSWeb.PersonHBVvaccServiceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
