/// 奖惩子集
Class DHCMGNUR.MgNurRewardPunish Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Relationship RewardPunishParref As DHCMGNUR.MgPersons [ Cardinality = parent, Inverse = perRewPun, Required ];

/// 姓名
Property PerName As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = Per_Name ];

/// 工号
Property PerID As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = Per_ID ];

/// 奖惩日期
Property PerRewPunDate As %Date [ SqlColumnNumber = 4, SqlFieldName = Per_RewPun_Date ];

/// 奖惩名称
Property PerRewPunName As %String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = Per_RewPun_Name ];

/// 奖惩原因
Property PerRewPunReason As %String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = Per_RewPun_Reason ];

/// 奖惩批准单位
Property PerRewPunUnit As %String(TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = Per_RewPun_Unit ];

/// 审核标识
Property PerFlag As %String(TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = Per_Flag ];

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
    .s a=##class(DHCMGNUR.MgNurRewardPunish).%New()
    .s a.RewardPunishParref=##class(DHCMGNUR.MgPersons).%OpenId(id)
    e  d
    .s a=##class(DHCMGNUR.MgNurRewardPunish).%OpenId(id_"||"_rw)
    s a.PerName=tmp("PerName")  //##class(DHCMGNUR.MgPersons).%OpenId(id).PersonName
    s a.PerID=tmp("PerID")
    s a.PerRewPunDate=$ZDH(tmp("PerRewPunDate"),3)
    s a.PerRewPunName=tmp("PerRewPunName")
    s a.PerRewPunReason=tmp("PerRewPunReason")
    s a.PerRewPunUnit=tmp("PerRewPunUnit")
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
		s a=##class(DHCMGNUR.MgNurRewardPunish).%OpenId(id)
		s pidpar=$P(id,"||",1)
		s pidrw=$P(id,"||",2)
		s PerName=a.PerName
		s PerID=a.PerID
		i a.PerRewPunDate'="" d
		.i ((dateFlag=3)!(dateFlag=4)) s PerRewPunDate=##class(web.DHCMgNurPerHRComm).getDateFormat(a.PerRewPunDate)
		.e  s PerRewPunDate=""
		e  s PerRewPunDate=""
		s PerRewPunName=a.PerRewPunName
		s PerRewPunReason=a.PerRewPunReason
		s PerRewPunUnit=a.PerRewPunUnit		
		s PerFlag=a.PerFlag
		s ret=ret_"PerName|"_PerName_"^"_"PerID|"_PerID_"^"_"PerRewPunDate|"_PerRewPunDate_"^"_"PerRewPunName|"_PerRewPunName_"^"_"PerRewPunReason|"_PerRewPunReason_"^"_"PerRewPunUnit|"_PerRewPunUnit_"^"_"PerFlag|"_PerFlag_"^"
	}
	q ret
}

ClassMethod delItem(id As %String) As %String
{
	TStart
	s object=##class(DHCMGNUR.MgNurRewardPunish).%OpenId(id)
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
	s a=##class(DHCMGNUR.MgNurRewardPunish).%OpenId(id)
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
	s a=##class(DHCMGNUR.MgNurRewardPunish).%OpenId(id)
	s a.PerFlag=flag
	d a.%Save()
	q a.%Id()
}

Storage Default
{
<Data name="MgNurRewardPunishDefaultData">
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
<Value>PerRewPunDate</Value>
</Value>
<Value name="5">
<Value>PerRewPunName</Value>
</Value>
<Value name="6">
<Value>PerRewPunReason</Value>
</Value>
<Value name="7">
<Value>PerRewPunUnit</Value>
</Value>
<Value name="8">
<Value>PerFlag</Value>
</Value>
</Data>
<DataLocation>^DHCMGNUR.MgNurRewardPunishD</DataLocation>
<DefaultData>MgNurRewardPunishDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("RewardPunishParref")</IdLocation>
<IndexLocation>^DHCMGNUR.MgNurRewardPunishI</IndexLocation>
<StreamLocation>^DHCMGNUR.MgNurRewardPunishS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
