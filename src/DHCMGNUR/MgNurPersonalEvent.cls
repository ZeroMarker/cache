/// 个人事件
Class DHCMGNUR.MgNurPersonalEvent Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Relationship PerEventParref As DHCMGNUR.MgPersons [ Cardinality = parent, Inverse = perPerEvent, Required ];

/// 姓名
Property PerName As %String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = Per_Name ];

/// 工号
Property PerID As %String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = Per_ID ];

/// 开始时间
Property PerStDate As %Library.Date [ SqlColumnNumber = 4, SqlFieldName = Per_StDate ];

/// 结束时间
Property PerEndDate As %Library.Date [ SqlColumnNumber = 5, SqlFieldName = Per_EndDate ];

/// 主要事件
Property PerPrimaryEvent As %String(MAXLEN = 300, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = Per_Primary_Event ];

/// 审核标识
Property PerFlag As %String(TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = Per_Flag ];

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
    .s a=##class(DHCMGNUR.MgNurPersonalEvent).%New()
    .s a.PerEventParref=##class(DHCMGNUR.MgPersons).%OpenId(id)
    e  d
    .s a=##class(DHCMGNUR.MgNurPersonalEvent).%OpenId(id_"||"_rw)
    s a.PerName=tmp("PerName")
    s a.PerID=tmp("PerID")
    s a.PerStDate=$ZDH(tmp("PerStDate"),3)
    s a.PerEndDate=$ZDH(tmp("PerEndDate"),3)
    s a.PerPrimaryEvent=tmp("PerPrimaryEvent")
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
		s a=##class(DHCMGNUR.MgNurPersonalEvent).%OpenId(id)
		s pidpar=$P(id,"||",1)
		s pidrw=$P(id,"||",2)
		s PerName=a.PerName
		s PerID=a.PerID
		i a.PerStDate'="" d
		.i ((dateFlag=3)!(dateFlag=4)) s PerStDate=##class(web.DHCMgNurPerHRComm).getDateFormat(a.PerStDate)
		.e  s PerStDate=""
		e  s PerStDate=""
		i a.PerEndDate'="" d
		.i ((dateFlag=3)!(dateFlag=4)) s PerEndDate=##class(web.DHCMgNurPerHRComm).getDateFormat(a.PerEndDate)
		.e  s PerEndDate=""
		e  s PerEndDate=""
		s PerPrimaryEvent=a.PerPrimaryEvent
		s PerFlag=a.PerFlag
		s ret=ret_"PerName|"_PerName_"^PerID|"_PerID_"^PerStDate|"_PerStDate_"^PerEndDate|"_PerEndDate_"^PerPrimaryEvent|"_PerPrimaryEvent_"^PerFlag|"_PerFlag_"^"
	}
	q ret
}

/// 删除
ClassMethod delItem(id As %String) As %String
{
	TStart
	s object=##class(DHCMGNUR.MgNurPersonalEvent).%OpenId(id)
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
	s a=##class(DHCMGNUR.MgNurPersonalEvent).%OpenId(id)
	s a.PerFlag=flag
	d a.%Save()
	d a.%Id()
}

ClassMethod revokeSave(parr As %String) As %String
{
	s perid=$P(parr,"^",1)
	s flag=$P(parr,"^",3)
	s id=$tr(perid,"_","||")
	s a=##class(DHCMGNUR.MgNurPersonalEvent).%OpenId(id)
	s a.PerFlag=flag
	d a.%Save()
	q a.%Id()
}

Storage Default
{
<Data name="MgNurPersonalEventDefaultData">
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
<Value>PerEndDate</Value>
</Value>
<Value name="5">
<Value>PerStDate</Value>
</Value>
<Value name="6">
<Value>PerPrimaryEvent</Value>
</Value>
<Value name="7">
<Value>PerFlag</Value>
</Value>
</Data>
<DataLocation>^DHCMGNUR.MgNurPersonalEventD</DataLocation>
<DefaultData>MgNurPersonalEventDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("PerEventParref")</IdLocation>
<IndexLocation>^DHCMGNUR.MgNurPersonalEventI</IndexLocation>
<StreamLocation>^DHCMGNUR.MgNurPersonalEventS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
