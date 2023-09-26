/// 名称：web.DHCCPW.Base.Patient
/// 描述：病人基本信息Pa_PatMas/Pa_Person
/// 编写者：李阳
/// 编写日期：2010-04-04
Class web.DHCCPW.Base.Patient Extends (%Persistent, web.DHCCPW.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

/// 病人ID
/// Pa_PatMas.PAPMI_RowId
Property Papmi As %String(TRUNCATE = 1);

/// 病人就诊卡号码
/// Pa_PatMas.PAPMI_No
Property PapmiNo As %String(TRUNCATE = 1);

/// 病人姓名
/// Pa_PatMas.PAPMI_Name
Property PatientName As %String(TRUNCATE = 1);

/// 性别
/// Pa_PatMas.PAPMI_Sex_DR
Property Sex As %String(TRUNCATE = 1);

/// 出生日期
/// Pa_person.PAPER_Dob
Property Birthday As %String(TRUNCATE = 1);

/// 年龄(年)
/// Pa_person.PAPER_AgeYr
Property Age As %Numeric;

/// 年龄(月)
/// Pa_person.PAPER_AgeMth
Property AgeMonth As %Numeric;

/// 年龄(日)
/// Pa_person.PAPER_AgeDay
Property AgeDay As %Numeric;

/// 身份证号码
/// Pa_person.PAPER_ID
Property PersonalID As %String(TRUNCATE = 1);

/// 省
Property Province As %String(TRUNCATE = 1);

/// 市
Property City As %String(TRUNCATE = 1);

/// 婚姻
Property Marital As %String(TRUNCATE = 1);

/// 民族
Property Nation As %String(TRUNCATE = 1);

/// 联系电话
Property Telephone As %String(TRUNCATE = 1);

/// 学历
Property Education As %String(TRUNCATE = 1);

/// 工作单位
Property WorkAddress As %String(TRUNCATE = 1);

/// 与联系人的关系
Property Relation As %String(TRUNCATE = 1);

/// 联系人地址
Property RelativeAddress As %String(TRUNCATE = 1);

/// 联系人姓名
Property RelativeName As %String(TRUNCATE = 1);

/// 联系人电话
Property RelativeTelephone As %String(TRUNCATE = 1);

/// 住址
Property Address As %String(TRUNCATE = 1);

/// 国籍
Property Country As %String(TRUNCATE = 1);

/// 住院病案号
Property InPatMrNo As %String(TRUNCATE = 1);

/// 门诊病案号
Property OpPatMrNo As %String(TRUNCATE = 1);

/// 手机号（工作电话）
Property MobileTel As %String(TRUNCATE = 1);

/// 住院病案号
Property InPatientMrNo As %String(TRUNCATE = 1);

/// 门诊病案号
Property OutPatientMrNo As %String(TRUNCATE = 1);

/// s objPatient=##class(web.DHCCPW.Base.Patient).GetPatientByRegNo(140270)
/// 通过病人登记号获取病人信息
ClassMethod GetPatientByRegNo(RegNo As %String) As web.DHCCPW.Base.Patient
{
	q:RegNo="" ""
	s RegNo=$$RegNoCon(RegNo)
	//^PAPERi("PAPMI_PatNo",$$ALPHAUP({PAPMI_No}),{PAPMI_RowId})
	s patientID=$o(^PAPERi("PAPMI_PatNo",RegNo,""))
	s objPatient=##class(web.DHCCPW.Base.Patient).GetObjById(patientID)
	q objPatient
}

ClassMethod GetJsonById(PAPMIRowId As %String) As %String
{
	//new (PAPMIRowId)
	set obj=..GetObjById(PAPMIRowId)
	//b
	quit:'$IsObject(obj) ""
	set json=""
	set cls=##class(%ClassDefinition).%OpenId("web.DHCCPW.Base.Patient")
	set properCount=cls.Properties.Count()
	for i=1:1:properCount {
		set strPropertyName=cls.Properties.GetAt(i).Name
		set expression="set strValue=obj."_strPropertyName
		x expression
		set json=json_strPropertyName
		set json=json_":'"_strValue_"',"
	}
	if json'=""{
		set json=$e(json,1,$l(json)-1)
	}
	s json="{"_json_"}"
	quit json
}

/// s objPatient=##class(web.DHCCPW.Base.Patient).GetObjById(113815)
ClassMethod GetObjById(PAPMIRowId As %String) As web.DHCCPW.Base.Patient
{
	n (PAPMIRowId)
	q:PAPMIRowId="" ""
	q:$d(^PAPER(PAPMIRowId))=0 ""
	s obj=##class(web.DHCCPW.Base.Patient).%New()
	s obj.Papmi=PAPMIRowId
	s obj.PapmiNo=$p(^PAPER(PAPMIRowId,"PAT",1),"^",1)
	s obj.PatientName=$p($g(^PAPER(PAPMIRowId,"ALL")),"^",1)
	s obj.Sex=$p($g(^CT("SEX",$p($g(^PAPER(PAPMIRowId,"ALL")),"^",7))),"^",2)
	s birth=$p($g(^PAPER(PAPMIRowId,"ALL")),"^",6)
	s:birth'="" obj.Birthday=$zd(birth,3)

	//update by zf 20150228 统一调用年龄计算方法
	s ageData=##class(web.DHCCPW.IO.FromHisSrv).GetPapmiAge(PAPMIRowId,"","","")	//返回“*岁*月*天”
	set AgeYear=0,AgeMonth=0,AgeDay=0
	if ageData["岁" {
		set AgeYear=+ageData
	} else {
		if ageData["月" {
			set AgeMonth=+ageData
			set AgeDay=+$p(ageData,"月",2)
		} else {
			set AgeDay=+ageData
		}
	}
	s obj.Age=AgeYear
	s obj.AgeMonth=AgeMonth
	s obj.AgeDay=AgeDay

	s obj.PersonalID=$p($g(^PAPER(PAPMIRowId,"ALL")),"^",9)
    s ProvinceDR=$p($g(^PAPER(PAPMIRowId,"PER",2)),"^",11)
    s ProvinceDR=+ProvinceDR        
    i ProvinceDR'=0 s ProvinceDesc=$p(^CT("PROV",ProvinceDR),"^",2)
    i $g(ProvinceDesc)["-" s ProvinceDesc=$p(ProvinceDesc,"-",2)
	s obj.Province=$g(ProvinceDesc)
    s CityBirthDR=$p($g(^PAPER(PAPMIRowId,"ALL")),"^",18)
    s CityBirthDR=+CityBirthDR
    i CityBirthDR'=0 s CityBirthDesc=$p(^CT("CIT",CityBirthDR),"^",2)
    i $g(CityBirthDesc)["-" s CityBirthDesc=$p(CityBirthDesc,"-",2)	
	s obj.City=$g(CityBirthDesc)
    s Marital=$p($g(^PAPER(PAPMIRowId,"PER",2)),"^",3)
    s MaritalDesc=""      ;add by wuqk 2008-07-01
    i Marital'="" s MaritalDesc=$p(^CT("MAR",+Marital),"^",2) 	
	s obj.Marital=$g(MaritalDesc)
    s nationdr=$p($g(^PAPER(PAPMIRowId,"PER",2)),"^",1)
    i nationdr'="" s nationDesc=$p(^CT("NAT",+nationdr),"^",2) 
    i $g(nationDesc)'="" d
    .i nationDesc["-" s nationDesc=$p(nationDesc,"-",2)	
	s obj.Nation=$g(nationDesc)
	s obj.Telephone=$p($g(^PAPER(PAPMIRowId,"PER",1)),"^",11)
    s educationdr=$p($g(^PAPER(PAPMIRowId,"PER",2)),"^",5)
    s educationDesc=""
    i educationdr'="" s educationDesc=$p(^CT("EDU",+educationdr),"^",2)	
	s obj.Education=$g(educationDesc)
	s obj.WorkAddress=""  //$$xGetCompany(PAPMIRowId)
	s obj.Relation=""  //$$xGetGX(PAPMIRowId)
	s obj.RelativeAddress=""  //$$xGetGXAddress(PAPMIRowId)
	s obj.RelativeName=""  //$$xGetGXMan(PAPMIRowId)
	s obj.RelativeTelephone=""  //$$xGetGXTel(PAPMIRowId)
	s obj.Address=""  //$$xGetHomeAddress(PAPMIRowId)
	s obj.InPatientMrNo=""  //$$xGetHomeAddress(PAPMIRowId)
	s obj.OutPatientMrNo=""  //$$xGetHomeAddress(PAPMIRowId)
    s countrydr=$p($g(^PAPER(PAPMIRowId,"PER",1)),"^",8)
    s countryDesc=""
    i countrydr'="" s countryDesc=$p(^CT("COU",+countrydr),"^",2) 
	s obj.Country=countryDesc
	q obj
RegNoCon(PAPMINo)
    n (PAPMINo)
    q:PAPMINo="" PAPMINo
	s len=8
	s PATCFid=$o(^CF("PATCF",""))
	i PATCFid'="" s len=$p($g(^CF("PATCF",PATCFid,3)),"^",5)
	if $l(PAPMINo)<len d
	.s prelen=len-$l(PAPMINo)
	.for i=1:1:prelen s PAPMINo="0"_PAPMINo
	Q PAPMINo
}

Method ToString(separete As %String) As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
	} 
	set return=..Papmi_separete
	set return=return_..PapmiNo_separete
	set return=return_..PatientName_separete
	set return=return_..Sex_separete
	set return=return_..Birthday_separete
	set return=return_..Age_separete
	set return=return_..AgeMonth_separete
	set return=return_..AgeDay_separete
	set return=return_..PersonalID_separete
	set return=return_..Province_separete
	set return=return_..City_separete
	set return=return_..Marital_separete
	set return=return_..Nation_separete
	set return=return_..Telephone_separete
	set return=return_..Education_separete
	set return=return_..WorkAddress_separete
	set return=return_..Relation_separete
	set return=return_..RelativeAddress_separete
	set return=return_..RelativeName_separete
	set return=return_..RelativeTelephone_separete
	set return=return_..Address_separete
	set return=return_..Country_separete
	set return=return_..InPatientMrNo_separete
	set return=return_..OutPatientMrNo_separete	
	quit return
}

/// Creator：     李阳
/// CreatDate：   2010-04-08
/// Description:  根据Pa_PatMas.PAPMI_RowId取用户信息
/// Table：       Pa_PatMas,Pa_Person
/// Input：       id:    Pa_PatMas.PAPMI_RowId
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(web.DHCCPW.Base.Patient).GetStringById(1)
ClassMethod GetStringById(id As %String, separete As %String) As %String
{
	new (id,separete)
	set return=""
	set obj=..GetObjById(id)
	if $IsObject(obj){
		set return=obj.ToString($g(separete))
	}	
	quit return
}

Storage Default
{
<Data name="PatientDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Address</Value>
</Value>
<Value name="3">
<Value>Age</Value>
</Value>
<Value name="4">
<Value>AgeDay</Value>
</Value>
<Value name="5">
<Value>AgeMonth</Value>
</Value>
<Value name="6">
<Value>Birthday</Value>
</Value>
<Value name="7">
<Value>City</Value>
</Value>
<Value name="8">
<Value>Country</Value>
</Value>
<Value name="9">
<Value>Education</Value>
</Value>
<Value name="10">
<Value>InPatMrNo</Value>
</Value>
<Value name="11">
<Value>InPatientMrNo</Value>
</Value>
<Value name="12">
<Value>Marital</Value>
</Value>
<Value name="13">
<Value>MobileTel</Value>
</Value>
<Value name="14">
<Value>Nation</Value>
</Value>
<Value name="15">
<Value>OpPatMrNo</Value>
</Value>
<Value name="16">
<Value>OutPatientMrNo</Value>
</Value>
<Value name="17">
<Value>Papmi</Value>
</Value>
<Value name="18">
<Value>PapmiNo</Value>
</Value>
<Value name="19">
<Value>PatientName</Value>
</Value>
<Value name="20">
<Value>PersonalID</Value>
</Value>
<Value name="21">
<Value>Province</Value>
</Value>
<Value name="22">
<Value>Relation</Value>
</Value>
<Value name="23">
<Value>RelativeAddress</Value>
</Value>
<Value name="24">
<Value>RelativeName</Value>
</Value>
<Value name="25">
<Value>RelativeTelephone</Value>
</Value>
<Value name="26">
<Value>Sex</Value>
</Value>
<Value name="27">
<Value>Telephone</Value>
</Value>
<Value name="28">
<Value>WorkAddress</Value>
</Value>
</Data>
<DataLocation>^web.DHCCPW.Base.PatientD</DataLocation>
<DefaultData>PatientDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCCPW.Base.PatientD</IdLocation>
<IndexLocation>^web.DHCCPW.Base.PatientI</IndexLocation>
<StreamLocation>^web.DHCCPW.Base.PatientS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
