/// 院外培训
Class DHCMGNUR.MgNurEduTra Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Relationship EduTraParref As DHCMGNUR.MgPersons [ Cardinality = parent, Inverse = perEduTra, Required ];

/// 姓名
Property PerName As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = Per_Name ];

/// 工号
Property PerID As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = Per_ID ];

/// 开始日期
Property StaDate As %Date [ SqlColumnNumber = 4, SqlFieldName = Sta_Date ];

/// 结束日期
Property EndDate As %Date [ SqlColumnNumber = 5, SqlFieldName = End_Date ];

/// 总学时
Property PerTotalHours As %String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = Per_Total_Hours ];

/// 学分
Property PerCredit As %String(TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = Per_Credit ];

/// 学分类型
Property PerCreditType As %String(TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = Per_CreditType ];

/// 培训内容
Property PerTrainContent As %String(MAXLEN = 1024, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = Per_Train_Content ];

/// 培训班名称
Property PerCourseName As %String(TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = Per_Course_Name ];

/// 培训性质
Property PerTrainHabitude As %String(TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = Per_Train_Habitude ];

/// 培训单位
Property PerTrainUnits As %String(TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = Per_Train_Units ];

/// 审核标识
Property PerFlag As %String(TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = Per_Flag ];

Index PerID On PerID;

Index PerFlag On (PerFlag, PerID);

ClassMethod Save(parr As %String) As %String
{
	s tmp=""
	s aa=##class(web.DHCMGNurComm).settmp(parr,.tmp)
	s perid=$G(tmp("raw"))
    s id=$P(perid,"__",1)
    s rw=$P(perid,"__",2)
    s ^c123=id
    b ;01
    i rw="" d
    .s a=##class(DHCMGNUR.MgNurEduTra).%New()
    .s a.EduTraParref=##class(DHCMGNUR.MgPersons).%OpenId(id)
    e  d
    .s a=##class(DHCMGNUR.MgNurEduTra).%OpenId(id_"||"_rw)
    s a.PerName=tmp("PerName")
    s a.PerID=tmp("PerID")
    s a.EndDate=$ZDH(tmp("EndDate"),3)
    s a.StaDate=$ZDH(tmp("StaDate"),3)
    s a.PerCourseName=tmp("PerCourseName")
    s a.PerTotalHours=tmp("PerTotalHours")
    s a.PerCredit=tmp("PerCredit")
    s a.PerCreditType=tmp("PerCreditType")
    s a.PerTrainContent=tmp("PerTrainContent")
    s a.PerTrainHabitude=tmp("PerTrainHabitude")
    s a.PerTrainUnits=tmp("PerTrainUnits")
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
		s a=##class(DHCMGNUR.MgNurEduTra).%OpenId(id)
		s pidpar=$P(id,"||",1)
		s pidrw=$P(id,"||",2)
		s PerName=a.PerName
		s PerID=a.PerID
		i a.StaDate'="" d
		.i ((dateFlag=3)!(dateFlag=4)) s StaDate=##class(web.DHCMgNurPerHRComm).getDateFormat(a.StaDate)
		.e  s StaDate=""
		e  s StaDate=""
		i a.EndDate'="" d
		.i ((dateFlag=3)!(dateFlag=4)) s EndDate=##class(web.DHCMgNurPerHRComm).getDateFormat(a.EndDate)
		.e  s EndDate=""
		s PerTotalHours=a.PerTotalHours
		s PerCredit=a.PerCredit
		s PerCreditType=a.PerCreditType
		s PerTrainContent=a.PerTrainContent
		s PerCourseName=a.PerCourseName
		s PerTrainHabitude=a.PerTrainHabitude
		s PerTrainUnits=a.PerTrainUnits
		s PerFlag=a.PerFlag
		s ret=ret_"PerName|"_PerName_"^"_"PerID|"_PerID_"^"_"StaDate|"_StaDate_"^"_"EndDate|"_EndDate_"^"_"PerTotalHours|"_PerTotalHours_"^"_"PerCredit|"_PerCredit_"^"_"PerCreditType|"_PerCreditType_"^"_"PerTrainContent|"_PerTrainContent_"^"_"PerCourseName|"_PerCourseName_"^"_"PerTrainHabitude|"_PerTrainHabitude_"^"_"PerTrainUnits|"_PerTrainUnits_"^"_"PerFlag|"_PerFlag_"^"
	}
	q ret
}

ClassMethod delItem(id As %String) As %String
{
	TStart
	s object=##class(DHCMGNUR.MgNurEduTra).%OpenId(id)
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
	s a=##class(DHCMGNUR.MgNurEduTra).%OpenId(id)
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
	s a=##class(DHCMGNUR.MgNurEduTra).%OpenId(id)
	s a.PerFlag=flag
	d a.%Save()
	q a.%Id()
}

Storage Default
{
<Data name="MgNurEduTraDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EndDate</Value>
</Value>
<Value name="3">
<Value>PerCourseName</Value>
</Value>
<Value name="4">
<Value>PerID</Value>
</Value>
<Value name="5">
<Value>PerName</Value>
</Value>
<Value name="6">
<Value>PerTotalHours</Value>
</Value>
<Value name="7">
<Value>PerTrainContent</Value>
</Value>
<Value name="8">
<Value>PerTrainHabitude</Value>
</Value>
<Value name="9">
<Value>PerTrainUnits</Value>
</Value>
<Value name="10">
<Value>StaDate</Value>
</Value>
<Value name="11">
<Value>PerCredit</Value>
</Value>
<Value name="12">
<Value>PerCreditType</Value>
</Value>
<Value name="13">
<Value>PerFlag</Value>
</Value>
</Data>
<DataLocation>^DHCMGNUR.MgNurEduTraD</DataLocation>
<DefaultData>MgNurEduTraDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("EduTraParref")</IdLocation>
<IndexLocation>^DHCMGNUR.MgNurEduTraI</IndexLocation>
<StreamLocation>^DHCMGNUR.MgNurEduTraS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
