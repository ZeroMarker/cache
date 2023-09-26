/// 个人著作
Class DHCMGNUR.MgNurPersonalBook Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Relationship PerBookParref As DHCMGNUR.MgPersons [ Cardinality = parent, Inverse = perPerBook, Required ];

/// 姓名
Property PerName As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = Per_Name ];

/// 工号
Property PerID As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = Per_ID ];

/// 书名
Property PerBookTitle As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = Per_Book_Title ];

/// 出版号
Property PerBookNumber As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = Per_Book_Number ];

/// 出版社
Property PerPubAgency As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = Per_Pub_Agency ];

/// 出版时间
Property PerPubDate As %Library.Date [ SqlColumnNumber = 7, SqlFieldName = Per_Pub_Date ];

/// 审核标识
Property PerFlag As %String(TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = Per_Flag ];

/// 编审类型
Property PerCpyEtTyp As %String(TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = PerCpyEtTyp ];

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
    .s a=##class(DHCMGNUR.MgNurPersonalBook).%New()
    .s a.PerBookParref =##class(DHCMGNUR.MgPersons).%OpenId(id)
    e  d
    .s a=##class(DHCMGNUR.MgNurPersonalBook).%OpenId(id_"||"_rw)
    s a.PerName=tmp("PerName") //姓名
    s a.PerID=tmp("PerID") // 工号
    s a.PerBookTitle=tmp("PerBookTitle") //书名
    s a.PerBookNumber=tmp("PerBookNumber") //书号
    s a.PerPubAgency=tmp("PerPubAgency") //出版社
    s a.PerPubDate=$ZDH(tmp("PerPubDate"),3) //出版时间
    s a.PerCpyEtTyp=tmp("PerCpyEtTyp")
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
		s a=##class(DHCMGNUR.MgNurPersonalBook).%OpenId(id)
		s pidpar=$P(id,"||",1)
		s pidrw=$P(id,"||",2)
		s PerName=a.PerName
		s PerID=a.PerID
		s PerBookTitle=a.PerBookTitle
		s PerBookNumber=a.PerBookNumber
		s PerPubAgency=a.PerPubAgency
		i a.PerPubDate'="" d
		.i ((dateFlag=3)!(dateFlag=4)) s PerPubDate=##class(web.DHCMgNurPerHRComm).getDateFormat(a.PerPubDate)
		.e  s PerPubDate=""
		e  s PerPubDate=""
		s PerFlag=a.PerFlag
		s PerCpyEtTyp=a.PerCpyEtTyp
		s ret=ret_"PerName|"_PerName_"^"_"PerID|"_"^"_"PerBookTitle|"_PerBookTitle_"^"_"PerBookNumber|"_PerBookNumber_"^"_"PerPubAgency|"_PerPubAgency_"^PerPubDate|"_PerPubDate_"^"_"PerFlag|"_PerFlag_"^PerCpyEtTyp|"_PerCpyEtTyp
	}
	q ret
}

/// 删除
ClassMethod delItem(id As %String) As %String
{
	TStart
	s object=##class(DHCMGNUR.MgNurPersonalBook).%OpenId(id)
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
	s a=##class(DHCMGNUR.MgNurPersonalBook).%OpenId(id)
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
	s a=##class(DHCMGNUR.MgNurPersonalBook).%OpenId(id)
	s a.PerFlag=flag
	d a.%Save()
	q a.%Id()
}

Storage Default
{
<Data name="MgNurPersonalBookDefaultData">
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
<Value>PerBookTitle</Value>
</Value>
<Value name="5">
<Value>PerBookNumber</Value>
</Value>
<Value name="6">
<Value>PerPubAgency</Value>
</Value>
<Value name="7">
<Value>PerFlag</Value>
</Value>
<Value name="8">
<Value>PerPubDate</Value>
</Value>
<Value name="9">
<Value>PerCpyEtTyp</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("perPerBook")</DataLocation>
<DefaultData>MgNurPersonalBookDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("PerBookParref")</IdLocation>
<IndexLocation>^DHCMGNUR.MgNurPersonalBookI</IndexLocation>
<StreamLocation>^DHCMGNUR.MgNurPersonalBookS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
