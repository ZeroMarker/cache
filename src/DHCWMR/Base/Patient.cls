/// 名称：DHCWMR.Base.Patient
/// 描述：病人基本信息Pa_PatMas/Pa_Person
/// 编写者：liyi
/// 编写日期：2014-09-05
Class DHCWMR.Base.Patient Extends (%Persistent, DHCWMR.Abstract) [ ClassType = "", Not ProcedureBlock ]
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

/// 急诊病案号
Property EpPatientMrNo As %String(TRUNCATE = 1);

/// Creator：     liyi
/// CreatDate：   2014-09-10
/// Description:  根据PapmiNo取病人基本信息
/// Table：       
/// Input：       PapmiNo
/// Return：      返回obj
/// Others：   
/// s objPatient=##class(DHCWMR.Base.Patient).GetObjByPapmiNo(174)
ClassMethod GetObjByPapmiNo(PapmiNo) As DHCWMR.Base.Patient
{
	New (PapmiNo)
	Set return =""
	Quit:PapmiNo="" return
	Set PapmiNo=..RegNoCon(PapmiNo)
	Set Papmi=$o(^PAPERi("PAPMI_PatNo",PapmiNo,-1))
    Quit:Papmi="" return
    Set Papmi=+Papmi
	Set ret=..GetObjById(Papmi)
	Set return =ret
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2014-09-10
/// Description:  初始化登记号码
/// Table：       
/// Input：       PapmiNo
/// Return：      PapmiNo
/// Others：   
/// s objPatient=##class(DHCWMR.Base.Patient).RegNoCon(174)
ClassMethod RegNoCon(PAPMINo As %String) As %String
{
	Quit:PAPMINo="" PAPMINo
	Set len=8
	Set PATCFid=$o(^CF("PATCF",""))
	If PATCFid'="" Set len=$p($g(^CF("PATCF",PATCFid,3)),"^",5)
	If $l(PAPMINo)<len
	{	
		s prelen=len-$l(PAPMINo)
		For i=1:1:prelen Set PAPMINo="0"_PAPMINo
	}
	Q PAPMINo
}

/// Creator：     liyi
/// CreatDate：   2014-09-05
/// Description:  根据PAPMIRowId取病人基本信息
/// Table：       
/// Input：       PAPMIRowId
/// Return：      返回obj
/// Others：   
/// s objPatient=##class(DHCWMR.Base.Patient).GetObjById(113815)
ClassMethod GetObjById(PAPMIRowId As %String) As DHCWMR.Base.Patient
{
	n (PAPMIRowId)
	q:PAPMIRowId="" ""
	q:$d(^PAPER(PAPMIRowId))=0 ""
	s obj=##class(DHCWMR.Base.Patient).%New()
	s obj.Papmi=PAPMIRowId
	s obj.PapmiNo=$p(^PAPER(PAPMIRowId,"PAT",1),"^",1)
	s obj.PatientName=$p($g(^PAPER(PAPMIRowId,"ALL")),"^",1)
	s obj.Sex=$p($g(^CT("SEX",$p($g(^PAPER(PAPMIRowId,"ALL")),"^",7))),"^",2)
	s birth=$p($g(^PAPER(PAPMIRowId,"ALL")),"^",6)
	s:birth'="" obj.Birthday=$zd(birth,3)
	s ageData=$$CalAge(birth,+$h)
	s obj.Age=$p(ageData,"^",1)
	s obj.AgeMonth=$p(ageData,"^",2)
	s obj.AgeDay=$p(ageData,"^",3)
	s obj.PersonalID=$p($g(^PAPER(PAPMIRowId,"ALL")),"^",9)
    s ProvinceDR=$p($g(^PAPER(PAPMIRowId,"PER",2)),"^",11)
    s ProvinceDR=+ProvinceDR        
    i ProvinceDR'=0 s ProvinceDesc=$p(^CT("PROV",ProvinceDR),"^",2)
    i $g(ProvinceDesc)["-" s ProvinceDesc=$p(ProvinceDesc,"-",2)
	s obj.Province=$g(ProvinceDesc)
    s CityBirthDR=$p($g(^PAPER(PAPMIRowId,"ALL")),"^",18)
    s CityBirthDR=+CityBirthDR
    i CityBirthDR'=0 s CityBirthDesc=$p($g(^CT("CIT",CityBirthDR)),"^",2)
    i $g(CityBirthDesc)["-" s CityBirthDesc=$p(CityBirthDesc,"-",2)	
	s obj.City=$g(CityBirthDesc)
    s Marital=$p($g(^PAPER(PAPMIRowId,"PER",2)),"^",3)
    s MaritalDesc=""
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
	s obj.WorkAddress=$$xGetCompany(PAPMIRowId)
	s obj.Relation=$$xGetGX(PAPMIRowId)
	s obj.RelativeAddress=$$xGetGXAddress(PAPMIRowId)
	s obj.RelativeName=$$xGetGXNane(PAPMIRowId)
	s obj.RelativeTelephone=$$xGetGXTel(PAPMIRowId)
	s obj.Address=$$xGetHomeAddress(PAPMIRowId)
	s obj.MobileTel=$$xGetMobileTel(PAPMIRowId)
	s obj.InPatientMrNo=##class(DHCWMR.IO.ToOutService).IGetMrNoByPatientID(PAPMIRowId,"IP")
	s obj.OutPatientMrNo=##class(DHCWMR.IO.ToOutService).IGetMrNoByPatientID(PAPMIRowId,"OP")
	s obj.EpPatientMrNo =##class(DHCWMR.IO.ToOutService).IGetMrNoByPatientID(PAPMIRowId,"EP")
    s countrydr=$p($g(^PAPER(PAPMIRowId,"PER",1)),"^",8)
    s countryDesc=""
    i countrydr'="" s countryDesc=$p(^CT("COU",+countrydr),"^",2) 
	s obj.Country=countryDesc
	q obj

CalAge(IBirth,IToday) 
                 n XBirth,XToday,AgeDay,AgeMth,AgeYear,CurrMth,CurrYear,AgeYr,UseDOB
                 s IBirth=$g(IBirth),IToday=$g(IToday)
                 i IBirth>2980000 s IBirth=""
                 i IBirth<0 s IBirth=""
                 q:'$G(IBirth) ""
                 s XBirth=$ZD(IBirth)
                 s XToday=$ZD(IToday)
                 s AgeMth=XToday-XBirth
                 s AgeDay=$p(XToday,"/",2)-$p(XBirth,"/",2)
                 s CurrYear=$p(XToday,"/",3) s:CurrYear<100 CurrYear=CurrYear+1900
                 s BirthYear=$p(XBirth,"/",3) s:BirthYear<100 BirthYear=BirthYear+1900
                 s AgeYear=CurrYear-BirthYear
                 i AgeDay<0 d
                 . s AgeMth=AgeMth-1
                 . s AgeDay=AgeDay+$p("31,31,28,31,30,31,30,31,31,30,31,30,31",",",+XToday)
                 . q:XToday'=2
                 . s:((CurrYear#4)=0)&(((CurrYear#100)'=0)!((CurrYear#400)=0)) AgeDay=AgeDay+1
                 i AgeMth<0 s AgeMth=AgeMth+12,AgeYear=AgeYear-1
                 s $P(AgeYr,"|",12)=AgeYear
                 s reage=$p(AgeYr,"|",12)_"Y "_AgeMth_"M "_AgeDay_"D"
                 i $p(AgeYr,"|",12)>0  d
                 .s reage=$p(AgeYr,"|",12)_"岁"
                 e  d
                 .i AgeMth>0 d
                 ..s reage=AgeMth_"月"
                 .e  d
                 ..s reage=AgeDay_"天"
                 q AgeYear_"^"_AgeMth_"^"_AgeDay
                 
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
xGetHomeAddress(PAPMIRowId)
	n (PAPMIRowId)
	s HomeAddress=""
	q:PAPMIRowId="" PAPMIRowId
	s HomeAddress=$g(^PAPER(PAPMIRowId,"PER","ADD",1))
	q HomeAddress
xGetCompany(PAPMIRowId)
	n (PAPMIRowId)
	s WorkAddress=""
	q:PAPMIRowId="" PAPMIRowId
	s WorkAddress = $p($g(^PAPER(PAPMIRowId,"PER",4)),"^",18)
	q WorkAddress
xGetGX(PAPMIRowId)
	n (PAPMIRowId)
	s Relation=""
	q:PAPMIRowId="" PAPMIRowId
	s GXRowId=+$p($g(^PAPER(PAPMIRowId,"EMP")),"^",4)
    s Relation=$p($g(^CT("RLT",GXRowId)),"^",2)
	q Relation
xGetGXAddress(PAPMIRowId)
	n (PAPMIRowId)
	s RelativeAddress=""
	q:PAPMIRowId="" PAPMIRowId
	s RelativeAddress=$p($g(^PAPER(PAPMIRowId,"PER",1)),"^",1)
	q RelativeAddress
xGetGXNane(PAPMIRowId)
	n (PAPMIRowId)
	s RelativeName=""
	q:PAPMIRowId="" PAPMIRowId
	s RelativeName=$p($g(^PAPER(PAPMIRowId,"PER",2)),"^",13)
	q RelativeName
xGetGXTel(PAPMIRowId)
	n (PAPMIRowId)
	s RelativeTelephone=""
	q:PAPMIRowId="" PAPMIRowId
	s RelativeTelephone=$p($g(^PAPER(PAPMIRowId,"ALL")),"^",4)
	q RelativeTelephone
xGetMobileTel(PAPMIRowId)
	n (PAPMIRowId)
	s MobileTel=""
	q:PAPMIRowId="" PAPMIRowId
	s MobileTel=$p($g(^PAPER(PAPMIRowId,"PER",4)),"^",21)
	q MobileTel
}

/// Creator：     liyi
/// CreatDate：   2014-09-05
/// Description:  将对象格式化为字符串
/// Table：       
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
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
	set return=return_..EpPatientMrNo_separete	
	quit return
}

/// Creator：     liyi
/// CreatDate：   DHCWMR.Base.Patient
/// Description:  根据Pa_PatMas.PAPMI_RowId取用户信息
/// Table：       Pa_PatMas,Pa_Person
/// Input：       id:    Pa_PatMas.PAPMI_RowId
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCWMR.Base.Patient).GetStringById(1)
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

}
