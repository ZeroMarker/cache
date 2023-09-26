/// 科内业务学习
Class DHCMGNUR.MgNurDepartLearning Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Relationship DepartLearnParref As DHCMGNUR.MgPersons [ Cardinality = parent, Inverse = perDepartLearn, Required ];

/// 姓名
Property PerName As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = Per_Name ];

/// 工号
Property PerID As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = Per_ID ];

/// 学习日期
Property PerLearnDate As %Date [ SqlColumnNumber = 4, SqlFieldName = Per_Learn_Date ];

/// 学习内容
Property PerLearnContent As %String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = Per_Learn_Content ];

/// 主讲人
Property PerPresenter As %String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = Per_Presenter ];

/// 学分
Property PerCredit As %String(TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = Per_Credit ];

/// 学分类型
Property PerCreditType As %String(TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = Per_Credit_Type ];

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
    i rw="" d
    .s a=##class(DHCMGNUR.MgNurDepartLearning).%New()
    .s a.DepartLearnParref=##class(DHCMGNUR.MgPersons).%OpenId(id)
    e  d
    .s a=##class(DHCMGNUR.MgNurDepartLearning).%OpenId(id_"||"_rw)
    s a.PerName=tmp("PerName")
    s a.PerID=tmp("PerID")
    s a.PerLearnDate=$ZDH(tmp("PerLearnDate"),3)
    s a.PerLearnContent=tmp("PerLearnContent")
    s a.PerPresenter=tmp("PerPresenter")
    s a.PerCredit=tmp("PerCredit")
    s a.PerCreditType=tmp("PerCreditType")
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
		s a=##class(DHCMGNUR.MgNurDepartLearning).%OpenId(id)
		s pidpar=$P(id,"||",1)
		s pidrw=$P(id,"||",2)
		s PerName=a.PerName
		s PerID=a.PerID
		i a.PerLearnDate'="" d
		.i ((dateFlag=3)!(dateFlag=4)) s PerLearnDate=##class(web.DHCMgNurPerHRComm).getDateFormat(a.PerLearnDate)
		.e  s PerLearnDate=""
		e  s PerLearnDate=""
		s PerLearnContent=a.PerLearnContent
		s PerPresenter=a.PerPresenter
		s PerCredit=a.PerCredit
		s PerCreditType=a.PerCreditType
		s PerFlag=a.PerFlag
		s ret=ret_"PerName|"_PerName_"^"_"PerID|"_PerID_"^"_"PerLearnDate|"_PerLearnDate_"^"_"PerLearnContent|"_PerLearnContent_"^"_"PerPresenter|"_PerPresenter_"^"_"PerCredit|"_PerCredit_"^"_"PerCreditType|"_PerCreditType_"^"_"PerFlag|"_PerFlag_"^"
	}
	q ret
}

/// 删除
ClassMethod delItem(id As %String) As %String
{
	TStart
	s object=##class(DHCMGNUR.MgNurDepartLearning).%OpenId(id)
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
	s a=##class(DHCMGNUR.MgNurDepartLearning).%OpenId(id)
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
	s a=##class(DHCMGNUR.MgNurDepartLearning).%OpenId(id)
	s a.PerFlag=flag
	d a.%Save()
	q a.%Id()
}

Storage Default
{
<Data name="MgNurDepartLearningDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PerCredit</Value>
</Value>
<Value name="3">
<Value>PerCreditType</Value>
</Value>
<Value name="4">
<Value>PerID</Value>
</Value>
<Value name="5">
<Value>PerLearnContent</Value>
</Value>
<Value name="6">
<Value>PerLearnDate</Value>
</Value>
<Value name="7">
<Value>PerName</Value>
</Value>
<Value name="8">
<Value>PerPresenter</Value>
</Value>
<Value name="9">
<Value>PerFlag</Value>
</Value>
</Data>
<DataLocation>^DHCMGNUR.MgNurDepartLearningD</DataLocation>
<DefaultData>MgNurDepartLearningDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("perDepartLearn")</IdLocation>
<IndexLocation>^DHCMGNUR.MgNurDepartLearningI</IndexLocation>
<StreamLocation>^DHCMGNUR.MgNurDepartLearningS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
