/// 休假子集
Class DHCMGNUR.MgNurHoliday Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Relationship HoliParref As DHCMGNUR.MgPersons [ Cardinality = parent, Inverse = perHoli, Required ];

/// 姓名
Property PerName As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = Per_Name ];

/// 工号
Property PerID As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = Per_ID ];

/// 病区
Property PerWard As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = Per_Ward ];

/// 休假开始时间
Property PerVacationStDate As %Date [ SqlColumnNumber = 5, SqlFieldName = Per_Vacation_StDate ];

/// 休假结束时间
Property PerVacationEndDate As %Date [ SqlColumnNumber = 6, SqlFieldName = Per_Vacation_EndDate ];

/// 休假类别
Property PerVacationType As DHCMGNUR.CommDictionarySub [ SqlColumnNumber = 7, SqlFieldName = Per_Vacation_Type ];

/// 休假天数
Property PerVacationDay As %String(TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = Per_Vacation_Day ];

/// 休假原因
Property PerVacationReason As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = Per_Vacation_Reason ];

/// 审核标识
Property PerFlag As %String(TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = Per_Flag ];

// Property PerSign As %String [ SqlColumnNumber = 11, SqlFieldName = Per_Sign ];

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
    .s a=##class(DHCMGNUR.MgNurHoliday).%New()
    .s a.HoliParref=##class(DHCMGNUR.MgPersons).%OpenId(id)
    e  d
    .s a=##class(DHCMGNUR.MgNurHoliday).%OpenId(id_"||"_rw)
    s p="" f  s p=$O(^oddCOM("DHCMGNUR.MgNurHoliday","a",p)) q:p=""  d
    .i p="PerVacationType" s tmp(p)=$tr(tmp(p),"__","||")
    s a.PerName=tmp("PerName")
    s a.PerID=tmp("PerID")
    s a.PerWard=tmp("PerWard")
    s a.PerVacationStDate=$ZDH(tmp("PerVacationStDate"),3)
    s a.PerVacationEndDate=$ZDH(tmp("PerVacationEndDate"),3)
    s a.PerVacationType=##class(DHCMGNUR.CommDictionarySub).%OpenId(tmp("PerVacationType"))
    s a.PerVacationDay=tmp("PerVacationDay")
    s a.PerVacationReason=tmp("PerVacationReason")
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
		s a=##class(DHCMGNUR.MgNurHoliday).%OpenId(id)
		s pidpar=$P(id,"||",1)
		s pidrw=$P(id,"||",2)
		s parm=$G(^DHCMGNUR.MgNurHolidayD(pidpar,pidrw))
		s PerName=a.PerName
		s PerID=a.PerID
		s PerWard=a.PerWard ; $p(^CTLOC(a.PerWard),"^",2)
		i a.PerVacationStDate'="" d
		.i ((dateFlag=3)!(dateFlag=4)) s PerVacationStDate=##class(web.DHCMgNurPerHRComm).getDateFormat(a.PerVacationStDate)
		.e  s PerVacationStDate=""
		e   s PerVacationStDate=""
		i a.PerVacationEndDate'="" d
		.i ((dateFlag=3)!(dateFlag=4)) s PerVacationEndDate=##class(web.DHCMgNurPerHRComm).getDateFormat(a.PerVacationEndDate)
		.e  s PerVacationEndDate=""
		e  s PerVacationEndDate=""
		s PerVacationType=$listget(parm,9)
		s PerVacationType=$tr(PerVacationType,"||","__")
		s PerVacationDay=a.PerVacationDay
		s PerVacationReason=a.PerVacationReason
		s PerFlag=a.PerFlag
		s ret=ret_"PerName|"_PerName_"^"_"PerID|"_PerID_"^"_"PerWard|"_PerWard_"^"_"PerVacationStDate|"_PerVacationStDate_"^"_"PerVacationEndDate|"_PerVacationEndDate_"^"_"PerVacationDay|"_PerVacationDay_"^"_"PerVacationType|"_PerVacationType_"^"_"PerVacationReason|"_PerVacationReason_"^"_"PerFlag|"_PerFlag_"^"
	}
	q ret
}

ClassMethod revokeSave(parr As %String) As %String
{
	s perid=$P(parr,"^",1)
	s flag=$P(parr,"^",3)
	s id=$tr(perid,"__","||")
	s a=##class(DHCMGNUR.MgNurHoliday).%OpenId(id)
	s a.PerFlag=flag
	d a.%Save()
	q a.%Id()
}

ClassMethod veritySave(parr As %String) As %String
{
	s perid=$P(parr,"^",1)
	s personid=$P(parr,"^",2)
	s flag=$P(parr,"^",3)
	s id=$tr(perid,"__","||")	
	s a=##class(DHCMGNUR.MgNurHoliday).%OpenId(id)
	s a.PerFlag=flag
	d a.%Save()
	q a.%Id()
}

ClassMethod delItem(id As %String) As %String
{
	TStart
	s object=##class(DHCMGNUR.MgNurHoliday).%OpenId(id)
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

Storage Default
{
<Data name="MgNurHolidayDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PerFlag</Value>
</Value>
<Value name="3">
<Value>PerID</Value>
</Value>
<Value name="4">
<Value>PerName</Value>
</Value>
<Value name="5">
<Value>PerVacationDay</Value>
</Value>
<Value name="6">
<Value>PerVacationEndDate</Value>
</Value>
<Value name="7">
<Value>PerVacationReason</Value>
</Value>
<Value name="8">
<Value>PerVacationStDate</Value>
</Value>
<Value name="9">
<Value>PerVacationType</Value>
</Value>
<Value name="10">
<Value>PerWard</Value>
</Value>
</Data>
<DataLocation>^DHCMGNUR.MgNurHolidayD</DataLocation>
<DefaultData>MgNurHolidayDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("perHoli")</IdLocation>
<IndexLocation>^DHCMGNUR.MgNurHolidayI</IndexLocation>
<StreamLocation>^DHCMGNUR.MgNurHolidayS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
