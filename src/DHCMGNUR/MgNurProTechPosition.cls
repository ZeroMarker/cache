/// 专业技术职务
Class DHCMGNUR.MgNurProTechPosition Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Relationship ProTechPosParref As DHCMGNUR.MgPersons [ Cardinality = parent, Inverse = perProTechPos, Required ];

/// 姓名
Property PerName As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = Per_Name ];

/// 工号
Property PerID As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = Per_ID ];

/// 专业技术资格名称
Property PerProfQualName As DHCMGNUR.CommDictionarySub [ SqlColumnNumber = 4, SqlFieldName = Per_Prof_QualName ];

/// 聘任专业技术职务名称
Property PerAppProfQualPosName As DHCMGNUR.CommDictionarySub [ SqlColumnNumber = 5, SqlFieldName = Per_Prof_QualPosName ];

/// 是否具有职业资格
Property PerOccuQual As %String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = Per_Occu_Qual ];

/// 聘任起始日期
Property PerAppStartDate As %Date [ SqlColumnNumber = 7, SqlFieldName = Per_App_StartDate ];

/// 聘任终止日期
Property PerAppEndDate As %Date [ SqlColumnNumber = 8, SqlFieldName = Per_App_EndDate ];

/// 聘任考核结果
Property PerAppExamRersult As %String(TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = Per_App_ExamRersult ];

/// 审核标识
Property PerFlag As %String(TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = Per_Flag ];

Index PerID On PerID;

Index PerFlag On (PerFlag, PerID);

ClassMethod Save(parr As %String) As %String
{
	s tmp=""
	s aa=##class(web.DHCMGNurComm).settmp(parr,.tmp)
	s perid=$G(tmp("raw"))
	s id=$P(perid,"__",1)
	s rw=$P(perid,"__",2)
    ;s id=$G(tmp("rw"))
    i rw="" d
    .s a=##class(DHCMGNUR.MgNurProTechPosition).%New()
    .s a.ProTechPosParref=##class(DHCMGNUR.MgPersons).%OpenId(id)
    e  d
    .s a=##class(DHCMGNUR.MgNurProTechPosition).%OpenId(id_"||"_rw)
    s p="" f  s p=$O(^oddCOM("DHCMGNUR.MgNurProTechPosition","a",p)) q:p=""  d
    .i p="PerProfQualName" s tmp(p)=$tr(tmp(p),"__","||")
    .i p="PerAppProfQualPosName" s tmp(p)=$tr(tmp(p),"__","||")
    s a.PerName=tmp("PerName")
    s a.PerID=tmp("PerID")
    s a.PerAppStartDate=$ZDH(tmp("PerAppStartDate"),3)
    i tmp("PerAppEndDate")'="" s a.PerAppEndDate=$ZDH(tmp("PerAppEndDate"),3)
    e  s a.PerAppEndDate=""
    s a.PerProfQualName=##class(DHCMGNUR.CommDictionarySub).%OpenId(tmp("PerProfQualName")) ///专业技术资格名称
    s a.PerAppProfQualPosName=##class(DHCMGNUR.CommDictionarySub).%OpenId(tmp("PerAppProfQualPosName")) ///聘任专业技术职务名称
    s a.PerOccuQual=tmp("PerOccuQual")
    s a.PerAppExamRersult=tmp("PerAppExamRersult")
    s a.PerFlag="0"   
    b ;001
    d a.%Save()
    q a.%Id()
}

ClassMethod getValue(id As %String) As %String
{
	s dateFlag=##class(websys.Conversions).DateFormat()
	s ret=""
	i id'=""
	{
		s id=$tr(id,"__","||")
		s a=##class(DHCMGNUR.MgNurProTechPosition).%OpenId(id)
		s pidpar=$P(id,"||",1)
		s pidrw=$P(id,"||",2)
		s parm=$G(^DHCMGNUR.MgNurProTechPositionD(pidpar,pidrw))
		s PerName=a.PerName
		s PerID=a.PerID
		s PerProfQualName=$listget(parm,8)
		s PerProfQualName=$tr(PerProfQualName,"||","__")
		s PerAppProfQualPosName=$listget(parm,9)
		s PerAppProfQualPosName=$tr(PerAppProfQualPosName,"||","__")
		s PerOccuQual=a.PerOccuQual
		i a.PerAppStartDate'="" d
		.i ((dateFlag=3)!(dateFlag=4)) s PerAppStartDate=##class(web.DHCMgNurPerHRComm).getDateFormat(a.PerAppStartDate)
		.e  s PerAppStartDate=""
		e  s PerAppStartDate=""
		i a.PerAppEndDate'="" d
		.i ((dateFlag=3)!(dateFlag=4)) s PerAppEndDate=##class(web.DHCMgNurPerHRComm).getDateFormat(a.PerAppEndDate)
		.e  s PerAppEndDate=$ZD(a.PerAppEndDate,3)
		e  s PerAppEndDate=""
		s PerAppExamRersult=a.PerAppExamRersult
		s PerFlag=a.PerFlag
		s ret=ret_"PerName|"_PerName_"^"_"PerID|"_PerID_"^"_"PerProfQualName|"_PerProfQualName_"^"_"PerAppProfQualPosName|"_PerAppProfQualPosName_"^"_"PerOccuQual|"_PerOccuQual_"^"_"PerAppStartDate|"_PerAppStartDate_"^"_"PerAppEndDate|"_PerAppEndDate_"^"_"PerAppExamRersult|"_PerAppExamRersult_"^"_"PerFlag|"_PerFlag_"^"	
	}
	q ret
}

/// 删除
ClassMethod delItem(id As %String) As %String
{
	TStart
	s object=##class(DHCMGNUR.MgNurProTechPosition).%OpenId(id)
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

ClassMethod veritySave(parr As %String) As %String
{
	s perid=$P(parr,"^",1)
	s personid=$P(parr,"^",2)
	s flag=$P(parr,"^",3)
	s id=$tr(perid,"__","||")	
	b ;02
	s a=##class(DHCMGNUR.MgNurProTechPosition).%OpenId(id)
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
	s a=##class(DHCMGNUR.MgNurProTechPosition).%OpenId(id)
	s a.PerFlag=flag
	d a.%Save()
	q a.%Id()
}

ClassMethod RSZYJSSave() As %String
{
	for i=1:1:2442
	{
		 s parr=^RSZYJS("RSZYJS","nursers",i)
		 s personid=$P(parr,"^",1)
		 s personProfQualPos=$P(parr,"^",3)
		 i personProfQualPos="254" s personProfQualPos="28||2"
		 i personProfQualPos="255" s personProfQualPos="28||2"
		 i personProfQualPos="253" s personProfQualPos="28||3"
		 i personProfQualPos="252" s personProfQualPos="28||4"
		 i personProfQualPos="022" s personProfQualPos="28||5"
		 i personProfQualPos="023" s personProfQualPos="28||6"
		 i personProfQualPos="983" s personProfQualPos="28||7"
		 i personProfQualPos="982" s personProfQualPos="28||8"
		 i personProfQualPos="663" s personProfQualPos="28||9"
		 i personProfQualPos="124" s personProfQualPos="28||10"
		 i personProfQualPos="264" s personProfQualPos="28||11"
		 i personProfQualPos="263" s personProfQualPos="28||12"
		 i personProfQualPos="259" s personProfQualPos="28||13"
		 i personProfQualPos="613" s personProfQualPos="28||14"
		 i personProfQualPos="251" s personProfQualPos="28||15"
		 i personProfQualPos="265" s personProfQualPos="28||16"
		 s personAppStartDate=$P(parr,"^",5)
		 i personAppStartDate'="" s personAppStartDate=$ZDH(personAppStartDate,3)
		 
		 s id="" f  s id=$O(^DHCMGNUR.MgPersonsI("SSID"," "_personid,id)) q:id=""  d
		 .s a=##class(DHCMGNUR.MgPersons).%OpenId(id)
		 .s aa=##class(DHCMGNUR.MgNurProTechPosition).%New()
		 .s aa.ProTechPosParref=##class(DHCMGNUR.MgPersons).%OpenId(id)
		 .s aa.PerName=a.PersonName
		 .s aa.PerID=a.PersonID
		 .i personProfQualPos'="" s aa.PerAppProfQualPosName=##class(DHCMGNUR.CommDictionarySub).%OpenId(personProfQualPos)
		 .s aa.PerAppStartDate=personAppStartDate
		 .d aa.%Save()
	}
}

/// 将专业技术职务职称信息导入主表中
ClassMethod ImportPersonsSave() As %String
{
	s personid="" f  s personid=$O(^DHCMGNUR.MgNurProTechPositionI("PerID",personid)) q:personid=""  d
	.s max=""
	.s id="" f  s id=$O(^DHCMGNUR.MgNurProTechPositionI("PerID",personid,id),-1) q:id=""  d
	..s rw="" f  s rw=$O(^DHCMGNUR.MgNurProTechPositionI("PerID",personid,id,rw),-1) q:rw=""  d
	...i max<rw s max=rw d
	....s a=##class(DHCMGNUR.MgNurProTechPosition).%OpenId(id_"||"_max)
	....s aa=##class(DHCMGNUR.MgPersons).%OpenId(id)
	....i a.PerAppProfQualPosName'="" s aa.PersonAppDutyDR=a.PerAppProfQualPosName
	....;b ;01
	....d aa.%Save()
}

Storage Default
{
<Data name="MgNurProTechPositionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PerID</Value>
</Value>
<Value name="3">
<Value>PerName</Value>
</Value>
<Value name="4">
<Value>PerAppStartDate</Value>
</Value>
<Value name="5">
<Value>PerAppEndDate</Value>
</Value>
<Value name="6">
<Value>PerAppExamRersult</Value>
</Value>
<Value name="7">
<Value>PerOccuQual</Value>
</Value>
<Value name="8">
<Value>PerProfQualName</Value>
</Value>
<Value name="9">
<Value>PerAppProfQualPosName</Value>
</Value>
<Value name="10">
<Value>PerFlag</Value>
</Value>
</Data>
<DataLocation>^DHCMGNUR.MgNurProTechPositionD</DataLocation>
<DefaultData>MgNurProTechPositionDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("ProTechPosParref")</IdLocation>
<IndexLocation>^DHCMGNUR.MgNurProTechPositionI</IndexLocation>
<StreamLocation>^DHCMGNUR.MgNurProTechPositionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
