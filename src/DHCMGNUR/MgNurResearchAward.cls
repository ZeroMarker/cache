/// 
/// 科研成果奖管理实体类
Class DHCMGNUR.MgNurResearchAward Extends %Persistent
{

/// 奖项来源
Property ScienSource As %String [ SqlColumnNumber = 2, SqlFieldName = Scien_Source ];

/// 成果等级
Property ScienGrade As %String [ SqlColumnNumber = 3, SqlFieldName = Scien_Grade ];

/// 获奖时间
Property ScienDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = Scien_Date ];

/// 奖金数额
Property ScienBonuses As %String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = Scien_Bonuses ];

/// 成果类型
Property ScienType As %String [ SqlColumnNumber = 6, SqlFieldName = Scien_Type ];

/// 第一完成人
Property ScienFirPer As %String [ SqlColumnNumber = 7, SqlFieldName = Scien_FirPer ];

/// 第二完成人
Property ScienSecPer As %String [ SqlColumnNumber = 8, SqlFieldName = Scien_SecPer ];

/// 第三完成人
Property ScienThirdPer As %String [ SqlColumnNumber = 9, SqlFieldName = Scien_ThirdPer ];

/// 其他完成人
Property ScienOtPer As %String [ SqlColumnNumber = 10, SqlFieldName = Scien_OtPer ];

/// 第一完成人所在大科
Property ScienFirBig As %String(TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = Scien_FirBig ];

/// 第一完成人所在病房
Property ScienFirLoc As %String(TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = Scien_FirLoc ];

/// 奖项名称
Property ScienName As %String(TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = Scien_Name ];

/// 第一完成人职务
Property ScienFirHead As %String [ SqlColumnNumber = 14, SqlFieldName = Scien_FirHead ];

/// 第一完成人职称
Property ScienFirDuty As %String [ SqlColumnNumber = 15, SqlFieldName = Scien_FirDuty ];

/// 第一完成人层级
Property ScienFirLev As %String [ SqlColumnNumber = 16, SqlFieldName = Scien_FirLev ];

/// 第二完成人层级
Property ScienSecLev As %String [ SqlColumnNumber = 17, SqlFieldName = Scien_SecLev ];

/// 第二完成人职务
Property ScienSecHead As %String [ SqlColumnNumber = 18, SqlFieldName = Scien_SecHead ];

/// 第二完成人职称
Property ScienSecDuty As %String [ SqlColumnNumber = 19, SqlFieldName = Scien_SecDuty ];

/// 第三完成人层级
Property ScienThirdLev As %String [ SqlColumnNumber = 20, SqlFieldName = Scien_ThirdLev ];

/// 第三完成人职务
Property ScienThirdHead As %String [ SqlColumnNumber = 21, SqlFieldName = Scien_ThirdHead ];

/// 第三完成人职称
Property ScienThirdDuty As %String [ SqlColumnNumber = 22, SqlFieldName = Scien_ThirdDuty ];

/// 第二完成人所在大科
Property ScienSecBig As %String(TRUNCATE = 1) [ SqlColumnNumber = 23, SqlFieldName = Scien_SecBig ];

/// 第二完成人所在病房
Property ScienSecLoc As %String(TRUNCATE = 1) [ SqlColumnNumber = 24, SqlFieldName = Scien_SecLoc ];

/// 第三完成人所在大科
Property ScienThirdBig As %String(TRUNCATE = 1) [ SqlColumnNumber = 25, SqlFieldName = Scien_ThirdBig ];

/// 第三完成人所在病房
Property ScienThirdLoc As %String(TRUNCATE = 1) [ SqlColumnNumber = 26, SqlFieldName = Scien_ThirdLoc ];

Index Date On ScienDate;

Index flag On (ScienName, ScienDate, ScienFirPer);

ClassMethod Save(parr As %String) As %String
{
	;s ^TEMP("g20150925001")=parr
	//parr="rw@^scienSource@38||1^scienGrade@39||1^scienDate@2015-09-01^scienName@测试1^scienBonuses@12000^
	//scienType@40||2^scienFirPer@04428^scienFirHead@22||2^scienFirDuty@28||3^scienFirLev@12||3^
	//scienFirBig@OutWard^scienFirLoc@76^scienSecPer@04898^scienSecHead@22||5^scienSecDuty@28||15^
	//scienSecLev@12||4^scienSecBig@HLB^scienSecLoc@801^scienThirdPer@00091^scienThirdHead@22||7^scienThirdDuty@28||1
	//^scienThirdLev@12||2^scienThirdBig@InWard^scienThirdLoc@133^scienOtPer@00455"
	s tmp="" k tmp
	d ##class(web.DHCMgNurQuarterExamComm).setArray(parr,.tmp)
	s rw=tmp("rw")
	i rw="" s obj=##class(DHCMGNUR.MgNurResearchAward).%New()
	e  s obj=##class(DHCMGNUR.MgNurResearchAward).%OpenId(rw)
	i $G(tmp("scienSource"))'="" s obj.ScienSource=tmp("scienSource")
	e  s obj.ScienSource=""
	i $G(tmp("scienGrade"))'="" s obj.ScienGrade=tmp("scienGrade")
	e  s obj.ScienGrade=""
	i $G(tmp("scienDate"))'="" s obj.ScienDate=$ZDH(tmp("scienDate"),3)
	e  s obj.ScienDate=""
	i $G(tmp("scienName"))'="" s obj.ScienName=$ZConvert(tmp("scienName"),"U")
	e  s obj.ScienName=""
	i $G(tmp("scienBonuses"))'="" s obj.ScienBonuses=tmp("scienBonuses")
	e  s obj.ScienBonuses=""
	i $G(tmp("scienType"))'="" s obj.ScienType=tmp("scienType")
	e  s obj.ScienType=""
	i $G(tmp("scienFirPer"))'="" s obj.ScienFirPer=$ZConvert(tmp("scienFirPer"),"U")
	e  s obj.ScienFirPer=""
	i $G(tmp("scienFirHead"))'="" s obj.ScienFirHead=tmp("scienFirHead")
	e  s obj.ScienFirHead=""
	i $G(tmp("scienFirDuty"))'="" s obj.ScienFirDuty=tmp("scienFirDuty")
	e  s obj.ScienFirDuty=""
	i $G(tmp("scienFirLev"))'="" s obj.ScienFirLev=tmp("scienFirLev")
	e  s obj.ScienFirLev=""
	i $G(tmp("scienFirBig"))'="" s obj.ScienFirBig=tmp("scienFirBig")
	e  s obj.ScienFirBig=""
	i $G(tmp("scienFirLoc"))'="" s obj.ScienFirLoc=tmp("scienFirLoc")
	e  s obj.ScienFirLoc=""
	i $G(tmp("scienSecPer"))'="" s obj.ScienSecPer=$ZConvert(tmp("scienSecPer"),"U")
	e  s obj.ScienSecPer=""
	i $G(tmp("scienSecHead"))'="" s obj.ScienSecHead=tmp("scienSecHead")
	e  s obj.ScienSecHead=""
	i $G(tmp("scienSecDuty"))'="" s obj.ScienSecDuty=tmp("scienSecDuty")
	e  s obj.ScienSecDuty=""
	i $G(tmp("scienSecLev"))'="" s obj.ScienSecLev=tmp("scienSecLev")
	e  s obj.ScienSecLev=""
	i $G(tmp("scienSecBig"))'="" s obj.ScienSecBig=tmp("scienSecBig")
	e  s obj.ScienSecBig=""
	i $G(tmp("scienSecLoc"))'="" s obj.ScienSecLoc=tmp("scienSecLoc")
	e  s obj.ScienSecLoc=""
	i $G(tmp("scienThirdPer"))'="" s obj.ScienThirdPer=$ZConvert(tmp("scienThirdPer"),"U")
	e  s obj.ScienThirdPer=""
	i $G(tmp("scienThirdHead"))'="" s obj.ScienThirdHead=tmp("scienThirdHead")
	e  s obj.ScienThirdHead=""
	i $G(tmp("scienThirdDuty"))'="" s obj.ScienThirdDuty=tmp("scienThirdDuty")
	e  s obj.ScienThirdDuty=""
	i $G(tmp("scienThirdLev"))'="" s obj.ScienThirdLev=tmp("scienThirdLev")
	e  s obj.ScienThirdLev=""
	i $G(tmp("scienThirdBig"))'="" s obj.ScienThirdBig=tmp("scienThirdBig")
	e  s obj.ScienThirdBig=""
	i $G(tmp("scienThirdLoc"))'="" s obj.ScienThirdLoc=tmp("scienThirdLoc")
	e  s obj.ScienThirdLoc=""
	i $G(tmp("scienOtPer"))'="" s obj.ScienOtPer=$ZConvert(tmp("scienOtPer"),"U")
	e  s obj.ScienOtPer=""
	d obj.%Save()
	q 0
}

ClassMethod getVal(id As %String) As %String
{
	s dateFlag=##class(websys.Conversions).DateFormat()
	s ret="" 
	i id'=""
	{
		s obj=##Class(DHCMGNUR.MgNurResearchAward).%OpenId(id)
		s awardsource=obj.ScienSource
		s awardgrade=obj.ScienGrade
		i obj.ScienDate'="" d
		.i ((dateFlag=3)!(dateFlag=4)) s awarddate=##class(web.DHCMgNurPerHRComm).getDateFormat(obj.ScienDate)
		.e  s awarddate=""
		e  s awarddate=""
		s awardname=obj.ScienName
		s awardbonus=obj.ScienBonuses
		s awardtype=obj.ScienType
		s awardfirper=obj.ScienFirPer
		s awardfirhead=obj.ScienFirHead
		s awardfirduty=obj.ScienFirDuty
		s awardfirlev=obj.ScienFirLev
		s awardfirbig=obj.ScienFirBig
		s awardfirloc=obj.ScienFirLoc
		s awardsecper=obj.ScienSecPer
		s awardsechead=obj.ScienSecHead
		s awardsecduty=obj.ScienSecDuty
		s awardseclev=obj.ScienSecLev
		s awardsecbig=obj.ScienSecBig
		s awardsecloc=obj.ScienSecLoc
		s awardthirper=obj.ScienThirdPer
		s awardthirhead=obj.ScienThirdHead
		s awardthirduty=obj.ScienThirdDuty
		s awardthirlev=obj.ScienThirdLev
		s awardthirbig=obj.ScienThirdBig
		s awardthirloc=obj.ScienThirdLoc
		s awardothper=obj.ScienOtPer
		s ret="awardsource@"_awardsource_"^awardgrade@"_awardgrade_"^awarddate@"_awarddate_"^awardname@"_awardname_"^awardbonus@"_awardbonus_"^awardtype@"_awardtype_"^awardfirper@"_awardfirper_"^awardfirhead@"_awardfirhead_"^awardfirduty@"_awardfirduty_"^awardfirlev@"_awardfirlev_"^awardfirbig@"_awardfirbig_"^awardfirloc@"_awardfirloc_"^awardsecper@"_awardsecper_"^awardsechead@"_awardsechead_"^awardsecduty@"_awardsecduty_"^awardseclev@"_awardseclev_"^awardsecbig@"_awardsecbig_"^awardsecloc@"_awardsecloc_"^awardthirper@"_awardthirper_"^awardthirhead@"_awardthirhead_"^awardthirduty@"_awardthirduty_"^awardthirlev@"_awardthirlev_"^awardthirbig@"_awardthirbig_"^awardthirloc@"_awardthirloc_"^awardothper@"_awardothper
	}
	q ret
}

ClassMethod isExist(parr As %String) As %String
{
	;s ^TEMP("g0928001002")=parr
	//parr=""
	s date=$P(parr,"^",1)
	i date'="" s date=$ZDH(date,3)
	q:date=""
	s title=$ZConvert($P(parr,"^",2),"U")
	s firnurse=$ZConvert($P(parr,"^",3),"U")
	s retVal=""
	s retVal=$O(^DHCMGNUR.MgNurResearchAwardI("flag"," "_title,date," "_firnurse,""))
	q retVal
}

Storage Default
{
<Data name="MgNurResearchAwardDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ScienSource</Value>
</Value>
<Value name="3">
<Value>ScienGrade</Value>
</Value>
<Value name="4">
<Value>ScienDate</Value>
</Value>
<Value name="5">
<Value>ScienBonuses</Value>
</Value>
<Value name="6">
<Value>ScienType</Value>
</Value>
<Value name="7">
<Value>ScienFirPer</Value>
</Value>
<Value name="8">
<Value>ScienSecPer</Value>
</Value>
<Value name="9">
<Value>ScienThirdPer</Value>
</Value>
<Value name="10">
<Value>ScienOtPer</Value>
</Value>
<Value name="11">
<Value>ScienFirBig</Value>
</Value>
<Value name="12">
<Value>ScienFirLoc</Value>
</Value>
<Value name="13">
<Value>ScienName</Value>
</Value>
<Value name="14">
<Value>ScienFirHead</Value>
</Value>
<Value name="15">
<Value>ScienFirDuty</Value>
</Value>
<Value name="16">
<Value>ScienFirLev</Value>
</Value>
<Value name="17">
<Value>ScienSecLev</Value>
</Value>
<Value name="18">
<Value>ScienSecHead</Value>
</Value>
<Value name="19">
<Value>ScienSecDuty</Value>
</Value>
<Value name="20">
<Value>ScienThirdLev</Value>
</Value>
<Value name="21">
<Value>ScienThirdHead</Value>
</Value>
<Value name="22">
<Value>ScienThirdDuty</Value>
</Value>
<Value name="23">
<Value>ScienSecBig</Value>
</Value>
<Value name="24">
<Value>ScienSecLoc</Value>
</Value>
<Value name="25">
<Value>ScienThirdBig</Value>
</Value>
<Value name="26">
<Value>ScienThirdLoc</Value>
</Value>
</Data>
<DataLocation>^DHCMGNUR.MgNurResearchAwardD</DataLocation>
<DefaultData>MgNurResearchAwardDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMGNUR.MgNurResearchAwardD</IdLocation>
<IndexLocation>^DHCMGNUR.MgNurResearchAwardI</IndexLocation>
<StreamLocation>^DHCMGNUR.MgNurResearchAwardS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
