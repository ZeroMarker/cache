/// 科研论文子集
Class DHCMGNUR.MgNurResThesis Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Relationship ResThesisParref As DHCMGNUR.MgPersons [ Cardinality = parent, Inverse = perResThesis, Required ];

/// 姓名
Property PerName As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = Per_Name ];

/// 工号
Property PerID As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = Per_ID ];

///  科研项目
Property PerResearchItem As %Library.String(MAXLEN = 512, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = Per_Research_Item ];

/// 科研项目级别
Property PerResearchType As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = Per_Research_Type ];

/// 科研成果
Property PerResearchResult As %Library.String(MAXLEN = 512, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = Per_Research_Result ];

/// 发表论文 
Property PerPubThesis As %Library.String(MAXLEN = 512, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = Per_Pub_Thesis ];

/// 发表时间
Property PerPubDate As %Library.Date [ SqlColumnNumber = 8, SqlFieldName = Per_Pub_Date ];

/// 出版期刊
Property PerJournalTitle As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = Per_Journal_Title ];

/// 期刊类型
Property PerJournalType As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = Per_Journal_Type ];

/// 作者类别
Property PerAuthorType As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = Per_Author_Type ];

/// 审核标识
Property PerFlag As %String(TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = Per_Flag ];

/// 年
Property PerJalYear As %String(TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = Per_Jal_Year ];

/// 卷(期)
Property PerJalVol As %String(TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = Per_Jal_Vol ];

/// 页
Property PerJalPage As %String(TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = Per_Jal_Page ];

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
    .s a=##class(DHCMGNUR.MgNurResThesis).%New()
    .s a.ResThesisParref =##class(DHCMGNUR.MgPersons).%OpenId(id)
    e  d
    .s a=##class(DHCMGNUR.MgNurResThesis).%OpenId(id_"||"_rw)
    s a.PerName=tmp("PerName") //姓名
    s a.PerID=tmp("PerID") // 工号
   	s a.PerResearchItem=tmp("PerResearchItem") //科研项目
   	s a.PerResearchType=tmp("PerResearchType") //科研项目级别
   	s a.PerResearchResult=tmp("PerResearchResult") //科研成果
   	s a.PerPubThesis=tmp("PerPubThesis") //发表论文
   	i tmp("PerPubDate")'="" s a.PerPubDate=$ZDH(tmp("PerPubDate"),3) //发表时间
   	e  s a.PerPubDate=""
   	s a.PerJournalTitle=tmp("PerJournalTitle") //出版期刊
   	s a.PerJournalType=tmp("PerJournalType") //期刊级别
   	s a.PerAuthorType=tmp("PerAuthorType") //作者类别
   	s a.PerJalVol=tmp("PerJalVol")
   	s a.PerJalPage=tmp("PerJalPage")
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
		s a=##class(DHCMGNUR.MgNurResThesis).%OpenId(id)
		s pidpar=$P(id,"||",1)
		s pidrw=$P(id,"||",2)
		s PerName=a.PerName
		s PerID=a.PerID
		s PerResearchItem=a.PerResearchItem
		s PerResearchType=a.PerResearchType
		s PerResearchResult=a.PerResearchResult
		s PerPubThesis=a.PerPubThesis
		i a.PerPubDate'="" d
		.i ((dateFlag=3)!(dateFlag=4)) s PerPubDate=##class(web.DHCMgNurPerHRComm).getDateFormat(a.PerPubDate)
		.e  s PerPubDate=""
		e  s PerPubDate=""
		s PerJournalTitle=a.PerJournalTitle
		s PerJournalType=a.PerJournalType
		s PerAuthorType=a.PerAuthorType
		s PerFlag=a.PerFlag
		s PerJalVol=a.PerJalVol
		s PerJalPage=a.PerJalPage
		s ret=ret_"PerName|"_PerName_"^"_"PerID|"_"^"_"PerResearchItem|"_PerResearchItem_"^"_"PerResearchType|"_PerResearchType_"^"_"PerResearchResult|"_PerResearchResult_"^"_"PerPubThesis|"_PerPubThesis_"^"_"PerPubDate|"_PerPubDate_"^"_"PerJournalTitle|"_PerJournalTitle_"^"_"PerJournalType|"_PerJournalType_"^PerAuthorType|"_PerAuthorType_"^"_"PerFlag|"_PerFlag_"^PerJalVol|"_PerJalVol_"^PerJalPage|"_PerJalPage_"^"
	}
	q ret
}

/// 删除
ClassMethod delItem(id As %String) As %String
{
	TStart
	s object=##class(DHCMGNUR.MgNurResThesis).%OpenId(id)
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
	s a=##class(DHCMGNUR.MgNurResThesis).%OpenId(id)
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
	s a=##class(DHCMGNUR.MgNurResThesis).%OpenId(id)
	s a.PerFlag=flag
	d a.%Save()
	q a.%Id()
}

Storage Default
{
<Data name="MgNurResThesisDefaultData">
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
<Value>PerResearchItem</Value>
</Value>
<Value name="5">
<Value>PerResearchResult</Value>
</Value>
<Value name="6">
<Value>PerPubThesis</Value>
</Value>
<Value name="7">
<Value>PerThesisTitle</Value>
</Value>
<Value name="8">
<Value>PerJournalTitle</Value>
</Value>
<Value name="9">
<Value>PerJournalType</Value>
</Value>
<Value name="10">
<Value>PerResearchType</Value>
</Value>
<Value name="11">
<Value>PerPubDate</Value>
</Value>
<Value name="12">
<Value>PerFlag</Value>
</Value>
<Value name="13">
<Value>PerAuthorType</Value>
</Value>
<Value name="14">
<Value>PerJalYear</Value>
</Value>
<Value name="15">
<Value>PerJalVol</Value>
</Value>
<Value name="16">
<Value>PerJalPage</Value>
</Value>
</Data>
<DataLocation>^DHCMGNUR.MgNurResThesisD</DataLocation>
<DefaultData>MgNurResThesisDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("ResThesisParref")</IdLocation>
<IndexLocation>^DHCMGNUR.MgNurResThesisI</IndexLocation>
<StreamLocation>^DHCMGNUR.MgNurResThesisS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
