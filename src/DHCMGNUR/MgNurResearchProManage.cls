Class DHCMGNUR.MgNurResearchProManage Extends %Persistent
{

/// 立项等级
Property ProjectGrade As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = Project_Grade ];

/// 立项名称
Property ProjectName As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = Project_Name ];

/// 立项日期
Property ProjectDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = Project_Date ];

/// 预计完成日期
Property FinishDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = Finish_Date ];

/// 立项总负责人
Property FirstResponser As %Library.String [ SqlColumnNumber = 6, SqlFieldName = First_Responser ];

/// 第二负责人
Property SecondResponser As %Library.String [ SqlColumnNumber = 7, SqlFieldName = Second_Responser ];

/// 第三负责人
Property ThirdResponser As %Library.String [ SqlColumnNumber = 8, SqlFieldName = Third_Responser ];

/// 其他负责人
Property OtherResponser As %Library.String [ SqlColumnNumber = 9, SqlFieldName = Other_Responser ];

/// 项目类型
Property ProjectType As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = Project_Type ];

/// 科研经费
Property ProjectSpotExpense As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = Project_SpotExpense ];

/// 总负责人职务
Property FirResponerHead As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = Fir_ResponerHead ];

/// 总负责人职称
Property FirResponerDuty As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = Fir_ResponerDuty ];

/// 总负责人层级
Property FirResponerLev As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = Fir_ResponerLev ];

/// 总负责人大科
Property FirResponerBig As %String(TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = Fir_ResponerBig ];

/// 总负责人病房
Property FirResponerLoc As %String(TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = Fir_ResponerLoc ];

/// 结题日期
Property ConcludeDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 17, SqlFieldName = Conclude_Date ];

/// 备注
Property ProjectRemark As %String(TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = Project_Remark ];

/// 第二负责人职务
Property SecResponerHead As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = Sec_ResponerHead ];

/// 第二负责人职称
Property SecResponerDuty As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 20, SqlFieldName = Sec_ResponerDuty ];

/// 第二负责人层级
Property SecResponerLev As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 21, SqlFieldName = Sec_ResponerLev ];

/// 第二负责人大科
Property SecResponerBig As %String(TRUNCATE = 1) [ SqlColumnNumber = 22, SqlFieldName = Sec_ResponerBig ];

/// 第二负责人病房
Property SecResponerLoc As %String(TRUNCATE = 1) [ SqlColumnNumber = 23, SqlFieldName = Sec_ResponerLoc ];

Index PrjDate On ProjectDate;

Index flag On (ProjectDate, ProjectName, FirstResponser);

ClassMethod Save(parr As %String) As %String
{
	;s ^TEMP("gresearchProMan")=parr
	//parr="rw@^researchStDate@2015-10-01^researchGrade@75||1^researchName@测试
	//^researchEndDate@2015-10-31^researchType@76||2^researchExpense@123
	//^resFirResponser@411^resFirResponHead@22||3^resFirResponDuty@28||3
	//^resFirResponLev@12||4^resFirResponBig@^resFirResponLoc@^resSecRespon@1
	//^resSecResponHead@22||2^resSecResponDuty@28||2^resSecResponLev@12||3
	//^resSecResponBig@^resSecResponLoc@^resThirdRespon@0002^resOtherRespon@0006
	//^resConcludeDate@2015-10-31^resProRemark@备注"
	s tmp="" k tmp
	d ##class(web.DHCMgNurQuarterExamComm).setArray(parr,.tmp)
	s rw=tmp("rw")
	i rw="" s obj=##class(DHCMGNUR.MgNurResearchProManage).%New()
	e  s obj=##class(DHCMGNUR.MgNurResearchProManage).%OpenId(rw)
	i $G(tmp("researchStDate"))'="" s obj.ProjectDate=$ZDH(tmp("researchStDate"),3)
	e  s obj.ProjectDate=""
	i $G(tmp("researchGrade"))'="" s obj.ProjectGrade=tmp("researchGrade")
	e  s obj.ProjectGrade=""
	i $G(tmp("researchName"))'="" s obj.ProjectName=$ZConvert(tmp("researchName"),"U")
	e  s obj.ProjectName=""
	i $G(tmp("researchEndDate"))'="" s obj.FinishDate=$ZDH(tmp("researchEndDate"),3)
	e  s obj.FinishDate=""
	i $G(tmp("researchType"))'="" s obj.ProjectType=tmp("researchType")
	e  s obj.ProjectType=""
	i $G(tmp("researchExpense"))'="" s obj.ProjectSpotExpense=tmp("researchExpense")
	e  s obj.ProjectSpotExpense=""
	i $G(tmp("resFirResponser"))'="" s obj.FirstResponser=$ZConvert(tmp("resFirResponser"),"U")
	e  s obj.FirstResponser=""
	i $G(tmp("resFirResponHead"))'="" s obj.FirResponerHead=tmp("resFirResponHead")
	e  s obj.FirResponerHead=""
	i $G(tmp("resFirResponDuty"))'="" s obj.FirResponerDuty=tmp("resFirResponDuty")
	e  s obj.FirResponerDuty=""
	i $G(tmp("resFirResponLev"))'="" s obj.FirResponerLev=tmp("resFirResponLev")
	e  s obj.FirResponerLev=""
	i $G(tmp("resFirResponBig"))'="" s obj.FirResponerBig=tmp("resFirResponBig")
	e  s obj.FirResponerBig=""
	i $G(tmp("resFirResponLoc"))'="" s obj.FirResponerLoc=tmp("resFirResponLoc")
	e  s obj.FirResponerLoc=""
	i $G(tmp("resSecRespon"))'="" s obj.SecondResponser=$ZConvert(tmp("resSecRespon"),"U")
	e  s obj.SecondResponser=""
	i $G(tmp("resSecResponHead"))'="" s obj.SecResponerHead=tmp("resSecResponHead")
	e  s obj.SecResponerHead=""
	i $G(tmp("resSecResponDuty"))'="" s obj.SecResponerDuty=tmp("resSecResponDuty")
	e  s obj.SecResponerDuty=""
	i $G(tmp("resSecResponLev"))'="" s obj.SecResponerLev=tmp("resSecResponLev")
	e  s obj.SecResponerLev=""
	i $G(tmp("resSecResponBig"))'="" s obj.SecResponerBig=tmp("resSecResponBig")
	e  s obj.SecResponerBig=""
	i $G(tmp("resSecResponLoc"))'="" s obj.SecResponerLoc=tmp("resSecResponLoc")
	e  s obj.SecResponerLoc=""
	i $G(tmp("resThirdRespon"))'="" s obj.ThirdResponser=$ZConvert(tmp("resThirdRespon"),"U")
	e  s obj.ThirdResponser=""
	i $G(tmp("resOtherRespon"))'="" s obj.OtherResponser=$ZConvert(tmp("resOtherRespon"),"U")
	e  s obj.OtherResponser=""
	i $G(tmp("resConcludeDate"))'="" s obj.ConcludeDate=$ZDH(tmp("resConcludeDate"),3)
	e  s obj.ConcludeDate=""
	i $G(tmp("resProRemark"))'="" s obj.ProjectRemark=tmp("resProRemark")
	e  s obj.ProjectRemark=""
	d obj.%Save()
	q obj.%Id()
}

ClassMethod getVal(id As %String) As %String
{
	s dateFlag=##class(websys.Conversions).DateFormat()
	s ret=""
	i id'="" 
	{
		s obj=##class(DHCMGNUR.MgNurResearchProManage).%OpenId(id)
		i obj.ProjectDate'="" s researchdate=$ZD(obj.ProjectDate,3)
		e  s researchdate=""
		s researchgrade=obj.ProjectGrade
		s researchname=obj.ProjectName
		i obj.FinishDate'="" d
		.i ((dateFlag=3)!(dateFlag=4)) s expectedate=##class(web.DHCMgNurPerHRComm).getDateFormat(obj.FinishDate)
		.e  s expectedate=""
		e  s expectedate=""
		s projecttype=obj.ProjectType
		s proexpense=obj.ProjectSpotExpense
		s firresponser=obj.FirstResponser
		s firresponhead=obj.FirResponerHead
		s firresponduty=obj.FirResponerDuty
		s firresponlev=obj.FirResponerLev
		s firresponbig=obj.FirResponerBig
		s firresponloc=obj.FirResponerLoc
		s secrespon=obj.SecondResponser
		s secresponhead=obj.SecResponerHead
		s secresponduty=obj.SecResponerDuty
		s secresponlev=obj.SecResponerLev
		s secresponbig=obj.SecResponerBig
		s secresponloc=obj.SecResponerLoc
		s thirdrespon=obj.ThirdResponser
		s otherrespon=obj.OtherResponser
		i obj.ConcludeDate'="" d
		.i ((dateFlag=3)!(dateFlag=4)) s concludedate=##class(web.DHCMgNurPerHRComm).getDateFormat(obj.ConcludeDate)
		.e  s concludedate=""
		e  s concludedate=""
		s proremark=obj.ProjectRemark
		s ret="researchdate@"_researchdate_"^researchgrade@"_researchgrade_"^researchname@"_researchname_"^expectedate@"_expectedate_"^projecttype@"_projecttype_"^proexpense@"_proexpense_"^firresponser@"_firresponser_"^firresponhead@"_firresponhead_"^firresponduty@"_firresponduty_"^firresponlev@"_firresponlev_"^firresponbig@"_firresponbig_"^firresponloc@"_firresponloc_"^secrespon@"_secrespon_"^secresponhead@"_secresponhead_"^secresponduty@"_secresponduty_"^secresponlev@"_secresponlev_"^secresponbig@"_secresponbig_"^secresponloc@"_secresponloc_"^thirdrespon@"_thirdrespon_"^otherrespon@"_otherrespon_"^concludedate@"_concludedate_"^proremark@"_proremark
	}
	q ret
}

ClassMethod isExist(parr As %String) As %String
{
	;s ^TEMP("gpromanage1006001")=parr
	//parr="2015-09-30^测试^411"
	s date=$ZDH($P(parr,"^",1),3)
	s title=$zcvt($P(parr,"^",2),"U")
	s nurse=$zcvt($P(parr,"^",3),"U")
	s rw=$O(^DHCMGNUR.MgNurResProManI("flag",date," "_title," "_nurse,""))
	q rw
}

ClassMethod datethan(researchdate, expectedate) As %String
{
	q:expectedate="" ""
	q:researchdate="" ""
	s ret=0
	s date1=$ZDH(researchdate,3)
	s date2=$ZDH(expectedate,3)
	i date2<date1  s ret=1
	q ret
}

Storage Default
{
<Data name="MgNurResProManDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ProjectGrade</Value>
</Value>
<Value name="3">
<Value>ProjectName</Value>
</Value>
<Value name="4">
<Value>CreateProjectDate</Value>
</Value>
<Value name="5">
<Value>PerFinishDate</Value>
</Value>
<Value name="6">
<Value>FirstResponser</Value>
</Value>
<Value name="7">
<Value>FirstResponserOutside</Value>
</Value>
<Value name="8">
<Value>SecondeResponser</Value>
</Value>
<Value name="9">
<Value>SecondeResponserOutside</Value>
</Value>
<Value name="10">
<Value>ThirdResponser</Value>
</Value>
<Value name="11">
<Value>ThirdResponserOutside</Value>
</Value>
<Value name="12">
<Value>OtherResponser</Value>
</Value>
<Value name="13">
<Value>OtherResponserOutside</Value>
</Value>
<Value name="14">
<Value>ProjectType</Value>
</Value>
<Value name="15">
<Value>ProjectSpotExpense</Value>
</Value>
<Value name="16">
<Value>responer1Head</Value>
</Value>
<Value name="17">
<Value>responer1Duty</Value>
</Value>
<Value name="18">
<Value>responer1Lev</Value>
</Value>
<Value name="19">
<Value>responer1Big</Value>
</Value>
<Value name="20">
<Value>responer1Loc</Value>
</Value>
<Value name="21">
<Value>concludeDate</Value>
</Value>
<Value name="22">
<Value>remark</Value>
</Value>
<Value name="23">
<Value>responer1HeadS</Value>
</Value>
<Value name="24">
<Value>responer1DutyS</Value>
</Value>
<Value name="25">
<Value>responer1LevS</Value>
</Value>
<Value name="26">
<Value>responer1BigS</Value>
</Value>
<Value name="27">
<Value>responer1LocS</Value>
</Value>
<Value name="28">
<Value>ProjectDate</Value>
</Value>
<Value name="29">
<Value>FinishDate</Value>
</Value>
<Value name="30">
<Value>SecondResponser</Value>
</Value>
<Value name="31">
<Value>FirResponerHead</Value>
</Value>
<Value name="32">
<Value>FirResponerDuty</Value>
</Value>
<Value name="33">
<Value>FirResponerLev</Value>
</Value>
<Value name="34">
<Value>FirResponerBig</Value>
</Value>
<Value name="35">
<Value>FirResponerLoc</Value>
</Value>
<Value name="36">
<Value>ConcludeDate</Value>
</Value>
<Value name="37">
<Value>ProjectRemark</Value>
</Value>
<Value name="38">
<Value>SecResponerHead</Value>
</Value>
<Value name="39">
<Value>SecResponerDuty</Value>
</Value>
<Value name="40">
<Value>SecResponerLev</Value>
</Value>
<Value name="41">
<Value>SecResponerBig</Value>
</Value>
<Value name="42">
<Value>SecResponerLoc</Value>
</Value>
</Data>
<DataLocation>^DHCMGNUR.MgNurResProManD</DataLocation>
<DefaultData>MgNurResProManDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMGNUR.MgNurResProManD</IdLocation>
<IndexLocation>^DHCMGNUR.MgNurResProManI</IndexLocation>
<StreamLocation>^DHCMGNUR.MgNurResProManS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
