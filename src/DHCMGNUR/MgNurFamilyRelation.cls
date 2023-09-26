/// 家庭成员
Class DHCMGNUR.MgNurFamilyRelation Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Relationship FamRelParref As DHCMGNUR.MgPersons [ Cardinality = parent, Inverse = perFamRel, Required ];

/// 姓名
Property PerName As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = Per_Name ];

/// 工号
Property PerID As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = Per_ID ];

/// 与本人关系
Property PerRelationSelf As %String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = Per_Relation_Self ];

/// 成员姓名
Property PerMemberName As %String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = Per_Member_Name ];

/// 成员工作单位
Property PerMemberWorkUnit As %String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = Per_Member_WorkUnit ];

/// 成员联系方式
Property PerMemberContact As %String(TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = Per_Member_Contact ];

/// 成员职务
Property PerMemberPosition As %String(TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = Per_Member_Position ];

/// 审核标识
Property PerFlag As %String(TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = Per_Flag ];

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
    .s a=##class(DHCMGNUR.MgNurFamilyRelation).%New()
    .s a.FamRelParref =##class(DHCMGNUR.MgPersons).%OpenId(id)
    e  d
    .s a=##class(DHCMGNUR.MgNurFamilyRelation).%OpenId(id_"||"_rw)
    s a.PerName=tmp("PerName")
    s a.PerID=tmp("PerID")
   	s a.PerRelationSelf=tmp("PerRelationSelf")
   	s a.PerMemberName=tmp("PerMemberName")
   	s a.PerMemberWorkUnit=tmp("PerMemberWorkUnit")
   	s a.PerMemberContact=tmp("PerMemberContact")
   	s a.PerMemberPosition=tmp("PerMemberPosition")
   	s a.PerFlag="0"
    b ;001
    d a.%Save()
    q a.%Id()
}

ClassMethod getValue(id As %String) As %String
{
	s ret=""
	i id'=""
	{
		s id=$tr(id,"__","||")
		s a=##class(DHCMGNUR.MgNurFamilyRelation).%OpenId(id)
		s pidpar=$P(id,"||",1)
		s pidrw=$P(id,"||",2)
		s PerName=a.PerName
		s PerID=a.PerID
		s PerRelationSelf=a.PerRelationSelf
		s PerMemberName=a.PerMemberName
		s PerMemberWorkUnit=a.PerMemberWorkUnit
		s PerMemberContact=a.PerMemberContact
		s PerMemberPosition=a.PerMemberPosition
		s PerFlag=a.PerFlag
		
		s ret=ret_"PerName|"_PerName_"^"_"PerID|"_PerID_"^"_"PerRelationSelf|"_PerRelationSelf_"^"_"PerMemberName|"_PerMemberName_"^"_"PerMemberWorkUnit|"_PerMemberWorkUnit_"^"_"PerMemberContact|"_PerMemberContact_"^"_"PerMemberPosition|"_PerMemberPosition_"^"_"PerFlag|"_PerFlag_"^"
	}
	q ret
}

/// 删除
ClassMethod delItem(id As %String) As %String
{
	TStart
	s object=##class(DHCMGNUR.MgNurFamilyRelation).%OpenId(id)
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
	s a=##class(DHCMGNUR.MgNurFamilyRelation).%OpenId(id)
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
	s a=##class(DHCMGNUR.MgNurFamilyRelation).%OpenId(id)
	s a.PerFlag=flag
	d a.%Save()
	q a.%Id()
}

Storage Default
{
<Data name="MgNurFamilyRelationDefaultData">
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
<Value>PerRelationSelf</Value>
</Value>
<Value name="5">
<Value>PerMemberName</Value>
</Value>
<Value name="6">
<Value>PerMemberWorkUnit</Value>
</Value>
<Value name="7">
<Value>PerMemberContact</Value>
</Value>
<Value name="8">
<Value>PerMemberPosition</Value>
</Value>
<Value name="9">
<Value>PerFlag</Value>
</Value>
</Data>
<DataLocation>^DHCMGNUR.MgNurFamilyRelationD</DataLocation>
<DefaultData>MgNurFamilyRelationDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("FamRelParref")</IdLocation>
<IndexLocation>^DHCMGNUR.MgNurFamilyRelationI</IndexLocation>
<StreamLocation>^DHCMGNUR.MgNurFamilyRelationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
