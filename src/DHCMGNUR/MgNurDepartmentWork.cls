/// 承担科室工作
Class DHCMGNUR.MgNurDepartmentWork Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Relationship DepWorkParref As DHCMGNUR.MgPersons [ Cardinality = parent, Inverse = perDepWork, Required ];

/// 姓名
Property PerName As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = Per_Name ];

/// 工号
Property PerID As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = Per_ID ];

/// 日期
Property PerDate As %Date [ SqlColumnNumber = 4, SqlFieldName = Per_Date ];

/// 实习带教老师
Property PerInternTeacher As %String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = Per_Intern_Teacher ];

/// 指导老师
Property PerInstructor As %String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = Per_Instructor ];

/// 总指导老师
Property PerHeadInstructor As %String(TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = Per_Head_Instructor ];

/// 质控护士
Property PerQualCtrNurse As %String(TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = Per_QualCtr_Nurse ];

/// 监控护士
Property PerMoniNurse As %String(TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = Per_Moni_Nurse ];

/// 消防护士
Property PerFireNurse As %String(TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = Per_Fire_Nurse ];

/// 设备护士
Property PerDeviceNurse As %String(TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = Per_Device_Nurse ];

/// 工作内容
Property PerWorkContent As %String(TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = Per_Work_Content ];

/// 审核标识
Property PerFlag As %String(TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = Per_Flag ];

/// 总带教老师
Property PerTotTeacher As %String(TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = Per_TotTeacher ];

Index PerID On PerID;

Index PerFlag On (PerFlag, PerID);

ClassMethod Save(parr As %String) As %String
{
	s tmp=""
	s aa=##class(web.DHCMGNurComm).settmp(parr,.tmp)
	s perid=$G(tmp("raw"))
    s id=$P(perid,"__",1)
    s rw=$P(perid,"__",2)
    i rw="" d
    .s a=##class(DHCMGNUR.MgNurDepartmentWork).%New()
    .s a.DepWorkParref=##class(DHCMGNUR.MgPersons).%OpenId(id)
    e  d
    .s a=##class(DHCMGNUR.MgNurDepartmentWork).%OpenId(id_"||"_rw)
    s a.PerName=tmp("PerName")
    s a.PerID=tmp("PerID")
    s a.PerDate=$ZDH(tmp("PerDate"),3)
    s a.PerInternTeacher=tmp("PerInternTeacher")
    s a.PerInstructor=tmp("PerInstructor")
	s a.PerHeadInstructor=tmp("PerHeadInstructor")
	s a.PerQualCtrNurse=tmp("PerQualCtrNurse")
	s a.PerMoniNurse=tmp("PerMoniNurse")
	s a.PerFireNurse=tmp("PerFireNurse")
	s a.PerDeviceNurse=tmp("PerDeviceNurse")
	s a.PerTotTeacher=tmp("PerTotTeacher")
    s a.PerFlag="0"
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
		s a=##class(DHCMGNUR.MgNurDepartmentWork).%OpenId(id)
		s pidpar=$P(id,"||",1)
		s pidrw=$P(id,"||",2)
		s PerName=a.PerName
		s PerID=a.PerID
		i a.PerDate'="" d
		.i ((dateFlag=3)!(dateFlag=4)) s PerDate=##class(web.DHCMgNurPerHRComm).getDateFormat(a.PerDate)
		.e  s PerDate=""
		e  s PerDate=""		
		s PerInternTeacher=a.PerInternTeacher		
		s PerInstructor=a.PerInstructor
		s PerHeadInstructor=a.PerHeadInstructor
		s PerQualCtrNurse=a.PerQualCtrNurse
		s PerMoniNurse=a.PerMoniNurse
		s PerFireNurse=a.PerFireNurse
		s PerDeviceNurse=a.PerDeviceNurse
		s PerFlag=a.PerFlag
		s PerTotTeacher=a.PerTotTeacher
		s ret=ret_"PerName|"_PerName_"^"_"PerID|"_PerID_"^"_"PerInternTeacher|"_PerInternTeacher_"^"_"PerDate|"_PerDate_"^"_"PerInstructor|"_PerInstructor_"^"_"PerHeadInstructor|"_PerHeadInstructor_"^"_"PerQualCtrNurse|"_PerQualCtrNurse_"^"_"PerMoniNurse|"_PerMoniNurse_"^"_"PerMoniNurse|"_PerMoniNurse_"^"_"PerFireNurse|"_PerFireNurse_"^"_"PerDeviceNurse|"_PerDeviceNurse_"^"_"PerFlag|"_PerFlag_"^PerTotTeacher|"_PerTotTeacher
	}
	q ret
}

/// 删除
ClassMethod delItem(id As %String) As %String
{
	TStart
	s object=##class(DHCMGNUR.MgNurDepartmentWork).%OpenId(id)
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
	s a=##class(DHCMGNUR.MgNurDepartmentWork).%OpenId(id)
	s a.PerFlag=flag
	d a.%Save()
	q a.%Id()
}

ClassMethod revokeSave(parr As %String) As %String
{
	s perid=$P(parr,"^",1)
	s flag=$P(parr,"^",3)
	s id=$tr(perid,"__","||")
	s a=##class(DHCMGNUR.MgNurDepartmentWork).%OpenId(id)
	s a.PerFlag=flag
	d a.%Save()
	q a.%Id()
}

Storage Default
{
<Data name="MgNurDepartmentWorkDefaultData">
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
<Value>PerInternTeacher</Value>
</Value>
<Value name="5">
<Value>PerInstructor</Value>
</Value>
<Value name="6">
<Value>PerHeadInstructor</Value>
</Value>
<Value name="7">
<Value>PerDate</Value>
</Value>
<Value name="8">
<Value>PerLevel</Value>
</Value>
<Value name="9">
<Value>PerWorkContent</Value>
</Value>
<Value name="10">
<Value>PerDeviceNurse</Value>
</Value>
<Value name="11">
<Value>PerFireNurse</Value>
</Value>
<Value name="12">
<Value>PerMoniNurse</Value>
</Value>
<Value name="13">
<Value>PerQualCtrNurse</Value>
</Value>
<Value name="14">
<Value>PerFlag</Value>
</Value>
<Value name="15">
<Value>PerTotTeacher</Value>
</Value>
</Data>
<DataLocation>^DHCMGNUR.MgNurDepartmentWorkD</DataLocation>
<DefaultData>MgNurDepartmentWorkDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("DepWorkParref")</IdLocation>
<IndexLocation>^DHCMGNUR.MgNurDepartmentWorkI</IndexLocation>
<StreamLocation>^DHCMGNUR.MgNurDepartmentWorkS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
