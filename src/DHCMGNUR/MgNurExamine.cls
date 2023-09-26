/// 考核子集
Class DHCMGNUR.MgNurExamine Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Relationship ExamineParref As DHCMGNUR.MgPersons [ Cardinality = parent, Inverse = perExamine, Required ];

/// 姓名
Property PerName As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = Per_Name ];

/// 工号
Property PerID As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = Per_ID ];

/// 考核时间
Property PerExamineDate As %Date [ SqlColumnNumber = 4, SqlFieldName = Per_Examine_Date ];

/// 考核类别
Property PerExamineType As %String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = Per_Examine_Type ];

/// 考核内容
Property PerExamineContent As %String(MAXLEN = 512, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = Per_Examine_Content ];

/// 考核结果
Property PerExamineResult As %String(TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = Per_Examine_Result ];

/// 考核意见
Property PerExamineOpinion As %String(TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = Per_Examine_Opinion ];

/// 考核单位
Property PerExamineUnit As %String(TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = Per_Examine_Unit ];

/// 考察人
Property PerExaminePerson As %String(TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = Per_Examine_Person ];

/// 考核分数
Property PerExamineScore As %String(TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = Per_Examine_Score ];

/// 审核标识
Property PerFlag As %String(TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = Per_Flag ];

Index PerID On PerID;

Index PerFlag On (PerFlag, PerID);

ClassMethod Save(parr As %String) As %String
{
	s tmp=""
	s aa=##class(web.DHCMGNurComm).settmp(parr,.tmp)
	s perid=$G(tmp("raw"))
	s id=$P(perid,"__",1)
	s rw =$P(perid,"__",2)
   	i rw="" d
   	.s a=##class(DHCMGNUR.MgNurExamine).%New()
   	.s a.ExamineParref =##class(DHCMGNUR.MgPersons).%OpenId(id)
   	e  d
   	.s a=##class(DHCMGNUR.MgNurExamine).%OpenId(id_"||"_rw)
    s a.PerName=tmp("PerName")
    s a.PerID=tmp("PerID")
   	s a.PerExamineDate=$ZDH(tmp("PerExamineDate"),3)
   	s a.PerExamineType=tmp("PerExamineType")
   	s a.PerExamineContent=tmp("PerExamineContent")
   	s a.PerExamineResult=tmp("PerExamineResult")
   	s a.PerExamineOpinion=tmp("PerExamineOpinion")
   	s a.PerExamineUnit=tmp("PerExamineUnit")
   	s a.PerExaminePerson=tmp("PerExaminePerson")
   	s a.PerExamineScore=tmp("PerExamineScore")
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
		s a=##class(DHCMGNUR.MgNurExamine).%OpenId(id)
		s pidpar=$P(id,"||",1)
		s pidrw=$P(id,"||",2)
		s PerName=a.PerName
		s PerID=a.PerID
		i a.PerExamineDate'="" d
		.i ((dateFlag=3)!(dateFlag=4)) s PerExamineDate=##class(web.DHCMgNurPerHRComm).getDateFormat(a.PerExamineDate)
		.e  s PerExamineDate=""
		e  s PerExamineDate=""
		s PerExamineType=a.PerExamineType
		s PerExamineContent=a.PerExamineContent
		s PerExamineResult=a.PerExamineResult
		s PerExamineOpinion=a.PerExamineOpinion
		s PerExamineUnit=a.PerExamineUnit
		s PerExaminePerson=a.PerExaminePerson
		s PerExamineScore=a.PerExamineScore
		s PerFlag=a.PerFlag
		s ret=ret_"PerName|"_PerName_"^"_"PerID|"_PerID_"^"_"PerExamineDate|"_PerExamineDate_"^"_"PerExamineType|"_PerExamineType_"^"_"PerExamineContent|"_PerExamineContent_"^"_"PerExamineResult|"_PerExamineResult_"^"_"PerExamineOpinion|"_PerExamineOpinion_"^"_"PerExamineUnit|"_PerExamineUnit_"^"_"PerExaminePerson|"_PerExaminePerson_"^"_"PerExamineScore|"_PerExamineScore_"^"_"PerFlag|"_PerFlag_"^"
	}
	q ret
}

ClassMethod veritySave(parr As %String) As %String
{
	s perid=$P(parr,"^",1)
	s personid=$P(parr,"^",2)
	s flag=$P(parr,"^",3)
	s id=$tr(perid,"__","||")
	s a=##class(DHCMGNUR.MgNurExamine).%OpenId(id)
	s a.PerFlag=flag
	d a.%Save()
	q a.%Id()
}

ClassMethod revokeSave(parr As %String) As %String
{
	s perid=$P(parr,"^",1)
	s flag=$P(parr,"^",3)
	s id=$tr(perid,"__","||")
	s a=##class(DHCMGNUR.MgNurExamine).%OpenId(id)
	s a.PerFlag=flag
	d a.%Save()
	q a.%Id()
}

ClassMethod delItem(id As %String) As %String
{
	TStart
	s object=##class(DHCMGNUR.MgNurExamine).%OpenId(id)
	i object.PerFlag="1" 
	{q "已经审核，不能删除！"}
	else
	{
		s sc = object.%DeleteId(id)
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
<Data name="MgNurExamineDefaultData">
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
<Value>PerExamineDate</Value>
</Value>
<Value name="5">
<Value>PerExamineType</Value>
</Value>
<Value name="6">
<Value>PerExamineResult</Value>
</Value>
<Value name="7">
<Value>PerExamineOpinion</Value>
</Value>
<Value name="8">
<Value>PerExamineUnit</Value>
</Value>
<Value name="9">
<Value>PerExaminePerson</Value>
</Value>
<Value name="10">
<Value>PerExamineContent</Value>
</Value>
<Value name="11">
<Value>PerFlag</Value>
</Value>
<Value name="12">
<Value>PerExamineScore</Value>
</Value>
</Data>
<DataLocation>^DHCMGNUR.MgNurExamineD</DataLocation>
<DefaultData>MgNurExamineDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("perExamine")</IdLocation>
<IndexLocation>^DHCMGNUR.MgNurExamineI</IndexLocation>
<StreamLocation>^DHCMGNUR.MgNurExamineS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
