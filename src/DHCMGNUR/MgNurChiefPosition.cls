/// 行政职务
Class DHCMGNUR.MgNurChiefPosition Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Relationship ChiefPosParref As DHCMGNUR.MgPersons [ Cardinality = parent, Inverse = perChiefPos, Required ];

/// 姓名
Property PerName As %String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = Per_Name ];

/// 工号
Property PerID As %String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = Per_ID ];

/// 职务名称
Property PerDutyName As DHCMGNUR.CommDictionarySub [ SqlColumnNumber = 4, SqlFieldName = Per_Duty_Name ];

/// 晋升日期
Property PerPromoteDate As %Date [ SqlColumnNumber = 5, SqlFieldName = Per_Promote_Date ];

/// 任职单位
Property PerWorkUnit As %String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = Per_Work_Unit ];

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
    b ;01
    i rw="" d
    .s a=##class(DHCMGNUR.MgNurChiefPosition).%New()
    .s a.ChiefPosParref=##class(DHCMGNUR.MgPersons).%OpenId(id)
    e  d
    .s a=##class(DHCMGNUR.MgNurChiefPosition).%OpenId(id_"||"_rw)
    s p="" f  s p=$O(^oddCOM("DHCMGNUR.MgNurChiefPosition","a",p)) q:p=""  d
    .i p="PerDutyName" s tmp(p)=$tr(tmp(p),"__","||")
    s a.PerName=tmp("PerName")
    s a.PerID=tmp("PerID")    
    s a.PerPromoteDate=$ZDH(tmp("PerPromoteDate"),3)    
    s a.PerDutyName=##class(DHCMGNUR.CommDictionarySub).%OpenId(tmp("PerDutyName"))    
    s a.PerWorkUnit=tmp("PerWorkUnit")
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
		s a=##class(DHCMGNUR.MgNurChiefPosition).%OpenId(id)
		s pidpar=$P(id,"||",1)
		s pidrw=$P(id,"||",2)
		s parm=$G(^DHCMGNUR.MgNurChiefPositionD(pidpar,pidrw))
		s PerName=a.PerName
		s PerID=a.PerID
		s PerDutyName=$listget(parm,4)
		s PerDutyName=$tr(PerDutyName,"||","__")
		i a.PerPromoteDate'="" d
		.i ((dateFlag=3)!(dateFlag=4)) s PerPromoteDate=##class(web.DHCMgNurPerHRComm).getDateFormat(a.PerPromoteDate)
		.e  s PerPromoteDate=""
		e  s PerPromoteDate=""
		s PerWorkUnit=a.PerWorkUnit
		s PerFlag=a.PerFlag
		s ret=ret_"PerName|"_PerName_"^"_"PerID|"_PerID_"^"_"PerDutyName|"_PerDutyName_"^"_"PerPromoteDate|"_PerPromoteDate_"^"_"PerWorkUnit|"_PerWorkUnit_"^"_"PerFlag|"_PerFlag_"^"	
	}
	q ret
}

/// 删除
ClassMethod delItem(id As %String) As %String
{
	TStart
	s object=##class(DHCMGNUR.MgNurChiefPosition).%OpenId(id)
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
	s a=##class(DHCMGNUR.MgNurChiefPosition).%OpenId(id)
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
	s a=##class(DHCMGNUR.MgNurChiefPosition).%OpenId(id)
	s a.PerFlag=flag
	d a.%Save()
	q a.%Id()
}

Storage Default
{
<Data name="MgNurChiefPositionDefaultData">
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
<Value>PerDutyName</Value>
</Value>
<Value name="5">
<Value>PerPromoteDate</Value>
</Value>
<Value name="6">
<Value>PerWorkUnit</Value>
</Value>
<Value name="7">
<Value>PerFlag</Value>
</Value>
</Data>
<DataLocation>^DHCMGNUR.MgNurChiefPositionD</DataLocation>
<DefaultData>MgNurChiefPositionDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("ChiefPosParref")</IdLocation>
<IndexLocation>^DHCMGNUR.MgNurChiefPositionI</IndexLocation>
<StreamLocation>^DHCMGNUR.MgNurChiefPositionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
