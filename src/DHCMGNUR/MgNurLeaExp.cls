Class DHCMGNUR.MgNurLeaExp Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Relationship LeaExpParref As DHCMGNUR.MgPersons [ Cardinality = parent, Inverse = perLeaExp, Required ];

/// 姓名
Property PerName As %Library.String(TRUNCATE = 1) [ SqlFieldName = Per_Name ];

/// 工号
Property PerID As %Library.String(TRUNCATE = 1) [ SqlFieldName = Per_ID ];

/// 开始日期
Property StaDate As %Date [ SqlColumnNumber = 5, SqlFieldName = Sta_Date ];

/// 结束日期
Property EndDate As %Date [ SqlColumnNumber = 6, SqlFieldName = End_Date ];

/// 所学专业
Property PerProfession As DHCMGNUR.CommDictionarySub [ SqlFieldName = Per_Profession ];

/// 学历
Property PerSchoolAgeDr As DHCMGNUR.CommDictionarySub [ SqlFieldName = Per_SchoolAge_Dr ];

/// 学历证书号
Property PerSchoolAgeNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlFieldName = Per_SchoolAgeNo ];

/// 学位
Property PerDegreeDR As DHCMGNUR.CommDictionarySub [ SqlFieldName = Per_Degree_DR ];

/// 学位证书号
Property PerDegreeNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlFieldName = Per_DegreeNo ];

/// 毕业学校
Property PerGraduateSchool As DHCMGNUR.CommDictionarySub [ SqlColumnNumber = 30, SqlFieldName = Per_GraduateSchool ];

/// 担任职务
Property PerHeadShip As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlFieldName = Per_HeadShip ];

/// 证明人
Property PerReferences As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlFieldName = Per_References ];

/// 审核标识
Property PerFlag As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = Per_Flag ];

Index PerID On PerID;

Index PerFlag On (PerFlag, PerID);

Index DataSort On (PerID, StaDate);

ClassMethod Save(parr As %String) As %String
{
	s ^TEMP("g03151540001")=parr
	s tmp=""
	s aa=##class(web.DHCMGNurComm).settmp(parr,.tmp)
	s perid=$G(tmp("raw"))
	s id=$P(perid,"__",1)
	s rw=$P(perid,"__",2)
	i rw="" d
	.s a=##class(DHCMGNUR.MgNurLeaExp).%New()
	.s a.LeaExpParref=##class(DHCMGNUR.MgPersons).%OpenId(id)
	e  d
	.s a=##class(DHCMGNUR.MgNurLeaExp).%OpenId(id_"||"_rw)
	s p="" f  s p=$O(^oddCOM("DHCMGNUR.MgNurLeaExp","a",p)) q:p=""  d
	.i p="PerDegreeDR" s tmp(p)=$tr(tmp(p),"__","||")
    .i p="PerProfession" s tmp(p)=$tr(tmp(p),"__","||")
    .i p="PerSchoolAgeDr" s tmp(p)=$tr(tmp(p),"__","||")
    .i p="PerGraduateSchool" s tmp(p)=$tr(tmp(p),"__","||")
    s a.PerName=tmp("PerName")
    s a.PerID=tmp("PerID")
    s a.EndDate=$ZDH(tmp("EndDate"),3)
    s a.StaDate=$ZDH(tmp("StaDate"),3)
    s a.PerDegreeDR=##class(DHCMGNUR.CommDictionarySub).%OpenId(tmp("PerDegreeDR")) ///学位
    s a.PerDegreeNo=tmp("PerDegreeNo")
    ;s a.PerGraduateSchool=tmp("PerGraduateSchool")
    s a.PerGraduateSchool=##class(DHCMGNUR.CommDictionarySub).%OpenId(tmp("PerGraduateSchool"))
    s a.PerHeadShip=tmp("PerHeadShip")
    s a.PerProfession=##class(DHCMGNUR.CommDictionarySub).%OpenId(tmp("PerProfession")) ///专业
    s a.PerReferences=tmp("PerReferences")
    s a.PerSchoolAgeDr=##class(DHCMGNUR.CommDictionarySub).%OpenId(tmp("PerSchoolAgeDr")) ///学历
    s a.PerSchoolAgeNo=tmp("PerSchoolAgeNo")
    s a.PerFlag="0"
	d a.%Save()
}

ClassMethod getVal(id As %String) As %String
{
	s ret=""
	i id'=""
	{
		s a=##class(DHCMGNUR.MgPersons).%OpenId(id)
		s PerName=a.PersonName
		i a.PersonDepDR="" s PerWard=""
		i a.PersonDepDR="9999" s PerWard="待分区(不做统计)"
		i a.PersonDepDR="9998" s PerWard="退休区(不做统计)"
		i a.PersonDepDR="9997" s PerWard="离职区(不做统计)"
		i (a.PersonDepDR'="")&(a.PersonDepDR'="9999")&(a.PersonDepDR'="9998")&(a.PersonDepDR'="9997") s PerWard=$p(^CTLOC(a.PersonDepDR),"^",2) //a.PersonDepDR
		s ret=ret_"PerName"_"|"_PerName_"^"_"PerWard"_"|"_PerWard_"^"
	}
	q ret
}

ClassMethod getValue(id As %String) As %String
{
	s dateFlag=##class(websys.Conversions).DateFormat()
	s ret=""
	i id'=""
	{
		s id=$tr(id,"__","||")
		s a=##class(DHCMGNUR.MgNurLeaExp).%OpenId(id)
		;s aa=##class(DHCMGNUR.CommDictionarySub).%OpenId(a.PerProfession)
		s pidpar=$P(id,"||",1)
		s pidrw=$P(id,"||",2)
		s parm=$G(^DHCMGNUR.MgNurLeaExpD(pidpar,pidrw))
		s PerName=a.PerName
		s PerID=a.PerID
		i a.StaDate'="" d
		.i ((dateFlag=3)!(dateFlag=4)) s StaDate=##class(web.DHCMgNurPerHRComm).getDateFormat(a.StaDate)
		.e  s StaDate=""
		e  s StaDate=""
		i a.EndDate'="" d
		.i ((dateFlag=3)!(dateFlag=4)) s EndDate=##class(web.DHCMgNurPerHRComm).getDateFormat(a.EndDate)
		.e  s EndDate=""
		e  s EndDate=""
		s PerProfession=$listget(parm,9) //a.PerProfession.Code
		s PerProfession=$tr(PerProfession,"||","__")
		s PerSchoolAgeDr=$listget(parm,11)  //a.PerSchoolAgeDr.Code
		s PerSchoolAgeDr=$tr(PerSchoolAgeDr,"||","__")
		s PerSchoolAgeNo=a.PerSchoolAgeNo
		s PerDegreeDR=$listget(parm,3)  //a.PerDegreeDR.Code
		s PerDegreeDR=$tr(PerDegreeDR,"||","__")
		s PerDegreeNo=a.PerDegreeNo
		i a.PerGraduateSchool'="" s PerGraduateSchool=$tr(a.PerGraduateSchool.%Id(),"||","__")
		e  s PerGraduateSchool=""
		s PerHeadShip=a.PerHeadShip
		s PerReferences=a.PerReferences
		s PerFlag=a.PerFlag
		s ret=ret_"PerName|"_PerName_"^"_"PerID|"_PerID_"^"_"StaDate|"_StaDate_"^"_"EndDate|"_EndDate_"^"_"PerProfession|"_PerProfession_"^"_"PerSchoolAgeDr|"_PerSchoolAgeDr_"^"_"PerSchoolAgeNo|"_PerSchoolAgeNo_"^"_"PerDegreeDR|"_PerDegreeDR_"^"_"PerDegreeNo|"_PerDegreeNo_"^"_"PerGraduateSchool|"_PerGraduateSchool_"^"_"PerHeadShip|"_PerHeadShip_"^"_"PerReferences|"_PerReferences_"^"_"PerFlag|"_PerFlag_"^"
	}
	q ret
}

ClassMethod veritySave(parr As %String) As %String
{
	s perid=$P(parr,"^",1)
	s personid=$P(parr,"^",2)
	s flag=$P(parr,"^",3)
	s id=$tr(perid,"__","||")	
	b ;02
	s a=##class(DHCMGNUR.MgNurLeaExp).%OpenId(id)
	s a.PerFlag=flag
	b ;01
	d a.%Save()
	q a.%Id()
}

ClassMethod revokeSave(parr As %String) As %String
{
	s perid=$P(parr,"^",1)
	s flag=$P(parr,"^",3)
	s id=$tr(perid,"__","||")
	s a=##class(DHCMGNUR.MgNurLeaExp).%OpenId(id)
	s a.PerFlag=flag
	d a.%Save()
	q a.%Id()
}

ClassMethod delItem(id As %String) As %String
{
	TStart
	s object=##class(DHCMGNUR.MgNurLeaExp).%OpenId(id)
	i object.PerFlag="1" 
	{q "已经审核，不能删除！"}
	else
	{
		s sc = object.%DeleteId(id)
		b ;01
		i $$$ISERR(sc)  
		{
			TRollBack
			Do $System.Status.DisplayError(sc)
   			q "删除失败"
		}
		else
		{
			TCommit
			q "删除成功"
		}
	}
}

/// 导入学历子集
ClassMethod leaExpSave() As %String
{
	for i=1:1:1582
	{
	    s parr=^RSXL("RSXL","nursers",i)
	    s personid=$P(parr,"^",1) //工号
	    s personSchoolAgeDr=$P(parr,"^",3) //学历
	    i personSchoolAgeDr="60" s personSchoolAgeDr="19||5"
	    i personSchoolAgeDr="70" s personSchoolAgeDr="19||1"
	    i personSchoolAgeDr="80" s personSchoolAgeDr="19||3"
	    i personSchoolAgeDr="75" s personSchoolAgeDr="19||6"
	    i personSchoolAgeDr="81" s personSchoolAgeDr="19||7"
	    i (personSchoolAgeDr="90")!(personSchoolAgeDr="92") s personSchoolAgeDr="19||4"
	    s personprofession=$P(parr,"^",4) //专业
	    ;b ;01
	    i (personprofession="护理")!(personprofession="护理学") s personprofession="18||1"
	    ;b ;02
	    i personprofession="教育学" s personprofession="18||2"
	    i personprofession="临床医学" s personprofession="18||3"
	    i personprofession="公共管理" s personprofession="18||4"
	    i personprofession="预防医学" s personprofession="18||5"
	    i personprofession="汉语语言文学" s personprofession="18||6"
	    i personprofession="涉外护理" s personprofession="18||7"
	    i personprofession="安医夜大" s personprofession=""
	    i personprofession="英语" s personprofession=""
	    i personprofession="医疗" s personprofession=""
	    i personprofession="助产士" s personprofession=""
	    i personprofession="法学" s personprofession=""
	   ; b ;001
	    s personEndDate=$P(parr,"^",5) //毕业时间
	    i personEndDate'="" s personEndDate=$ZDH(personEndDate,3)
	    s personGraduateSchool=$P(parr,"^",6) //毕业院校
	    s personPerDegreeDR=$P(parr,"^",7) //学位
	    i personPerDegreeDR="1" s personPerDegreeDR="20||1"
	    i personPerDegreeDR="2" s personPerDegreeDR="20||2"
	    s personGradeSchoolDR=$P(parr,"^",8) //院校制式
	    
	    s id="" f  s id=$O(^DHCMGNUR.MgPersonsI("SSID"," "_personid,id)) q:id=""  d
	    .;b ;004
	    .s a=##class(DHCMGNUR.MgPersons).%OpenId(id)
	    .s aa=##class(DHCMGNUR.MgNurLeaExp).%New()
	    .s aa.LeaExpParref=##class(DHCMGNUR.MgPersons).%OpenId(id)
	    .s aa.PerName=a.PersonName
	    .s aa.PerID=a.PersonID //工号
	    .i personSchoolAgeDr'="" s aa.PerSchoolAgeDr=##class(DHCMGNUR.CommDictionarySub).%OpenId(personSchoolAgeDr) //学历
	    .i personprofession'="" s aa.PerProfession=##class(DHCMGNUR.CommDictionarySub).%OpenId(personprofession) // 专业
	    .s aa.EndDate=personEndDate //毕业时间 
	    .i personPerDegreeDR'="" s aa.PerDegreeDR=##class(DHCMGNUR.CommDictionarySub).%OpenId(personPerDegreeDR) //学位
	    .s aa.PerGraduateSchool=personGraduateSchool //毕业学校
	    .d aa.%Save()
	}
}

ClassMethod PerDegreeDRSave() As %String
{
	s personid="" f  s personid=$O(^DHCMGNUR.MgNurLeaExpI("PerID",personid)) q:personid=""  d
	.s max=""
	.s id="" f  s id=$O(^DHCMGNUR.MgNurLeaExpI("PerID",personid,id),-1) q:id=""  d
	..s rw="" f  s rw=$O(^DHCMGNUR.MgNurLeaExpI("PerID",personid,id,rw),-1) q:rw=""  d 
	...i max<rw s max=rw d
	....s a=##class(DHCMGNUR.MgNurLeaExp).%OpenId(id_"||"_max)
	....s aa=##class(DHCMGNUR.MgPersons).%OpenId(id)
	....i a.PerDegreeDR'="" s aa.PersonDegreeDR=a.PerDegreeDR
	....d aa.%Save()
}

ClassMethod Save00() As %String
{
	for i=1:1:1582
	{
		s parr=^RSXL("RSXL","nursers",i)
	    s personid=$P(parr,"^",1) //工号
	    s personPersonSchoolType=$P(parr,"^",8) //院校制式
	    i personPersonSchoolType="1" s personPersonSchoolType="15||1"
	    i personPersonSchoolType="2" s personPersonSchoolType="15||3"
	    
	    s id="" f  s id=$O(^DHCMGNUR.MgPersonsI("SSID"," "_personid,id)) q:id=""  d
	    .s a=##class(DHCMGNUR.MgPersons).%OpenId(id)
	    .i personPersonSchoolType'="" s a.PersonSchoolType=##class(DHCMGNUR.CommDictionarySub).%OpenId(personPersonSchoolType)
	    .d a.%Save()
	 }
}

Storage Default
{
<Data name="MgNurLeaExpDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EndDate</Value>
</Value>
<Value name="3">
<Value>PerDegreeDR</Value>
</Value>
<Value name="4">
<Value>PerDegreeNo</Value>
</Value>
<Value name="5">
<Value>PerGraduateSchool</Value>
</Value>
<Value name="6">
<Value>PerHeadShip</Value>
</Value>
<Value name="7">
<Value>PerID</Value>
</Value>
<Value name="8">
<Value>PerName</Value>
</Value>
<Value name="9">
<Value>PerProfession</Value>
</Value>
<Value name="10">
<Value>PerReferences</Value>
</Value>
<Value name="11">
<Value>PerSchoolAgeDr</Value>
</Value>
<Value name="12">
<Value>PerSchoolAgeNo</Value>
</Value>
<Value name="13">
<Value>StaDate</Value>
</Value>
<Value name="14">
<Value>PerFlag</Value>
</Value>
</Data>
<DataLocation>^DHCMGNUR.MgNurLeaExpD</DataLocation>
<DefaultData>MgNurLeaExpDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("LeaExpParref")</IdLocation>
<IndexLocation>^DHCMGNUR.MgNurLeaExpI</IndexLocation>
<StreamLocation>^DHCMGNUR.MgNurLeaExpS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
