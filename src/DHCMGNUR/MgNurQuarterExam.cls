/// 
/// 季度考试
Class DHCMGNUR.MgNurQuarterExam Extends %Persistent
{

Property QuarterDep As %String(TRUNCATE = 1);

Property QuarterNur As %String(TRUNCATE = 1);

Property QuarterDate As %Date;

/// 季度
Property QuarterType As %String(TRUNCATE = 1);

/// 合格与否
Property QuarterPass As %String(TRUNCATE = 1);

/// 成绩
Property QuarterResult As %String(TRUNCATE = 1);

/// 缺考原因
Property QuarterMissReason As DHCMGNUR.CommDictionarySub;

/// 状态位
Property QuarterFlag As %Library.String;

Index DateDep On (QuarterDate, QuarterDep);

Index Date On QuarterDate;

Index Check On (QuarterDate, QuarterFlag, QuarterType, QuarterNur);

ClassMethod Save(parr As %String) As %String
{
	s ^TEMP("g0807001")=parr
	s tmp="" k tmp
	d ##class(web.DHCMgNurQuarterExamComm).setArray(parr,.tmp)
	b ;01
	s rw=tmp("rw")
	i rw="" s obj=##class(DHCMGNUR.MgNurQuarterExam).%New()
	e  s obj=##class(DHCMGNUR.MgNurQuarterExam).%OpenId(rw)
	i $G(tmp("date"))'="" d
	.s examdate=$ZDH(tmp("date"),3)
	.s obj.QuarterDate=examdate
	s obj.QuarterDep=tmp("dep")
	s obj.QuarterNur=tmp("nurse")
	s obj.QuarterMissReason=##class(DHCMGNUR.CommDictionarySub).%OpenId(tmp("reason"))
	s obj.QuarterPass=tmp("passval")
	s obj.QuarterResult=tmp("score")
	s obj.QuarterType=tmp("quarter")
	s obj.QuarterFlag="Y"
	d obj.%Save()
	q 0
}

ClassMethod getVal(id As %String) As %String
{
	s dateFlag=##class(websys.Conversions).DateFormat()
	s ret=""
	i id'=""
	{
		s obj=##class(DHCMGNUR.MgNurQuarterExam).%OpenId(id)
		i obj.QuarterDate'="" d
		.i ((dateFlag=3)!(dateFlag=4)) s QuarterDate=##class(web.DHCMgNurPerHRComm).getDateFormat(obj.QuarterDate)
		.e  s QuarterDate=""
		e  s QuarterDate=""
		s QuarterDep=obj.QuarterDep
		i obj.QuarterMissReason'="" s QuarterMissReason=obj.QuarterMissReason.%Id()
		e  s QuarterMissReason=""
		s QuarterNur=obj.QuarterNur
		s QuarterPass=obj.QuarterPass
		s QuarterResult=obj.QuarterResult
		s QuarterType=obj.QuarterType
		s ret="QuarterDate|"_QuarterDate_"^QuarterDep|"_QuarterDep_"^QuarterMissReason|"_$Tr(QuarterMissReason,"||","__")_"^QuarterNur|"_QuarterNur_"^QuarterPass|"_QuarterPass_"^QuarterResult|"_QuarterResult_"^QuarterType|"_QuarterType
	}
	q ret
}

ClassMethod isExistData(str As %String) As %String
{
	s ^TEMP("g0808001")=str
	s ret=0
	s date=$P(str,"^",1)
	q:date="" 0
	s date=$ZDH(date,3)
	s quarter=$P(str,"^",2)
	s rw=$P(str,"^",4)
	s nurse=$ZConvert($P(str,"^",3),"U")
	s id=$O(^DHCMGNUR.MgNurQuarterExamI("Check",date," Y"," "_quarter," "_nurse,""))
	i id'="" s ret=1
	q ret
}

ClassMethod invalRec(id As %String, flag As %String) As %String
{
	s ret=""
	i id'="" 
	{
		s obj=##class(DHCMGNUR.MgNurQuarterExam).%OpenId(id)
		s obj.QuarterFlag=flag
		d obj.%Save()
		s ret=obj.%Id()
	}
	q ret
}

ClassMethod importData(parr As %String) As %String
{
	s ^TEMP("g20150814001")=parr
	s examtmp="" k examtmp
	d ##class(web.DHCMgImportDataComm).setArray(parr,.examtmp)
	q:examtmp("QuarterDate")=""
	i $G(examtmp("QuarterDate"))'="" d
	.s quarterdate=$Tr(examtmp("QuarterDate")," ","")
	.s quarterdate=$Tr(quarterdate,"/","-") //$tr(examtmp("QuarterDate"),"/","-")
	.s quarterdate=$Tr(quarterdate,".","-") //$tr(examtmp("QuarterDate"),".","-")
	.s quarterdate=$ZDH(quarterdate,3)
	q:examtmp("QuarterType")=""
	i $G(examtmp("QuarterType"))'="" d
	.s type=$Tr(examtmp("QuarterType")," ","")
	.i type["一季度" s quartertype="1"
	.i type["二季度" s quartertype="2"
	.i type["三季度" s quartertype="3"
	.i type["四季度" s quartertype="4"
	q:examtmp("QuarterNur")="" //护士工号
	i $G(examtmp("QuarterNur"))'="" d
	.s quarternur=$Tr(examtmp("QuarterNur")," ","")
	.s quarternur=$ZConvert(quarternur,"U")
	q:examtmp("QuarterDep")="" //科室
	s dep=""
	i $G(examtmp("QuarterDep"))'="" d
	.s depid="" f  s depid=$O(^CTLOC(depid)) q:depid=""  d
	..s depdesc=$P(^CTLOC(depid),"^",2)
	..i depdesc=examtmp("QuarterDep") s dep=depid
	q:dep=""
	
	s rw=$O(^DHCMGNUR.MgNurQuarterExamI("Check",quarterdate," Y"," "_quartertype," "_quarternur,""))
	i rw="" d
	.b ;01
	.s obj=##class(DHCMGNUR.MgNurQuarterExam).%New()
	.s obj.QuarterDate=quarterdate
	.s obj.QuarterDep=dep
	.s obj.QuarterFlag="Y"
	.i $G(examtmp("QuarterMissReason"))'="" d
	..s reason=$ZConvert($Tr(examtmp("QuarterMissReason")," ",""),"U")
	..s reaid=$O(^DHCMGNUR.CommDictionaryI("Code"," 季度考试缺考原因",""))
	..i reaid'="" d
	...s rearw=$O(^DHCMGNUR.CommDictionarySubI("Code"," "_reason,reaid,""))
	...i rearw'="" d 
	....s reasonpar=reaid_"||"_rearw
	....s obj.QuarterMissReason=##class(DHCMGNUR.CommDictionarySub).%OpenId(reasonpar)
	.b ;04
	.s obj.QuarterNur=quarternur
	.i $G(examtmp("QuarterPass"))'="" d
	..i examtmp("QuarterPass")="优秀" s obj.QuarterPass="4"
	..i examtmp("QuarterPass")="良好" s obj.QuarterPass="3"
	..i examtmp("QuarterPass")="及格" s obj.QuarterPass="2"
	..i examtmp("QuarterPass")="不及格" s obj.QuarterPass="1"
	.b ;02
	.s obj.QuarterResult=examtmp("QuarterResult")
	.s obj.QuarterType=quartertype
	.d obj.%Save()
	q 0
}

/*i rw="" 
	{
		b ;01
		s obj=##class(DHCMGNUR.MgNurQuarterExam).%New()
		s obj.QuarterDate=quarterdate
		s obj.QuarterDep=dep
		s obj.QuarterFlag="Y"
		b ;03
		i $G(examtmp("QuarterMissReason"))'="" d
		.s reason=$ZConvert($Tr(examtmp("QuarterMissReason")," ",""),"U")
		.s reaid=$O(^DHCMGNUR.CommDictionaryI("Code"," 季度考试缺考原因",""))
		.i reaid'="" d
		..s rearw=$O(^DHCMGNUR.CommDictionarySubI("Code"," "_reason,reaid,""))
		..i rearw'="" d 
		...s reasonpar=reaid_"||"_rearw
		...s obj.QuarterMissReason=##class(DHCMGNUR.CommDictionarySub).%OpenId(reasonpar)
		.b ;04
		.s obj.QuarterNur=quarternur
		.i $G(examtmp("QuarterPass"))'="" d
		..i examtmp("QuarterPass")="优秀" s obj.QuarterPass="4"
		..i examtmp("QuarterPass")="良好" s obj.QuarterPass="3"
		..i examtmp("QuarterPass")="及格" s obj.QuarterPass="2"
		..i examtmp("QuarterPass")="不及格" s obj.QuarterPass="1"
		.b ;02
		.s obj.QuarterResult=examtmp("QuarterResult")
		.s obj.QuarterType=quartertype
		.d obj.%Save()
		*/
Storage Default
{
<Data name="MgNurQuarterExamDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>QuarterDep</Value>
</Value>
<Value name="3">
<Value>QuarterNur</Value>
</Value>
<Value name="4">
<Value>QuarterDate</Value>
</Value>
<Value name="5">
<Value>QuarterType</Value>
</Value>
<Value name="6">
<Value>QuarterPass</Value>
</Value>
<Value name="7">
<Value>QuarterResult</Value>
</Value>
<Value name="8">
<Value>QuarterMissReason</Value>
</Value>
<Value name="9">
<Value>QuarterFlag</Value>
</Value>
</Data>
<DataLocation>^DHCMGNUR.MgNurQuarterExamD</DataLocation>
<DefaultData>MgNurQuarterExamDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMGNUR.MgNurQuarterExamD</IdLocation>
<IndexLocation>^DHCMGNUR.MgNurQuarterExamI</IndexLocation>
<StreamLocation>^DHCMGNUR.MgNurQuarterExamS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
