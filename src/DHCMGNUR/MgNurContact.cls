/// 个人联系信息
Class DHCMGNUR.MgNurContact Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Relationship ContactParref As DHCMGNUR.MgPersons [ Cardinality = parent, Inverse = perContact, Required ];

/// 姓名
Property PerName As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = Per_Name ];

/// 工号
Property PerID As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = Per_ID ];

/// 家庭电话
Property PerHouseTel As %String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = Per_House_Tel ];

/// 办公电话
Property PerOfficeTel As %String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = Per_Office_Tel ];

/// 手机
Property PerMobilePhone As %String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = Per_Mobile_Phone ];

///  家庭地址
Property PerHouseAddress As %String(TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = Per_House_Address ];

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
    .s a=##class(DHCMGNUR.MgNurContact).%New()
    .s a.ContactParref =##class(DHCMGNUR.MgPersons).%OpenId(id)
    e  d
    .s a=##class(DHCMGNUR.MgNurContact).%OpenId(id_"||"_rw)
    s a.PerName=tmp("PerName")
    s a.PerID=tmp("PerID")
    s a.PerHouseAddress=tmp("PerHouseAddress")
    s a.PerHouseTel=tmp("PerHouseTel")
    s a.PerMobilePhone=tmp("PerMobilePhone")
    s a.PerOfficeTel=tmp("PerOfficeTel")
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
		s a=##class(DHCMGNUR.MgNurContact).%OpenId(id)
		s pidpar=$P(id,"||",1)
		s pidrw=$P(id,"||",2)
		s PerName=a.PerName
		s PerID=a.PerID
		s PerHouseTel=a.PerHouseTel
		s PerOfficeTel=a.PerOfficeTel
		s PerMobilePhone=a.PerMobilePhone
		s PerHouseAddress=a.PerHouseAddress
		s PerFlag=a.PerFlag
		s ret=ret_"PerName|"_PerName_"^"_"PerID|"_"^"_"PerHouseTel|"_PerHouseTel_"^"_"PerOfficeTel|"_PerOfficeTel_"^"_"PerMobilePhone|"_PerMobilePhone_"^"_"PerHouseAddress|"_PerHouseAddress_"^"_"PerFlag|"_PerFlag_"^"
	}
	q ret
}

/// 删除
ClassMethod delItem(id As %String) As %String
{
	TStart
	s object=##class(DHCMGNUR.MgNurContact).%OpenId(id)
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
	s a=##class(DHCMGNUR.MgNurContact).%OpenId(id)
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
	s a=##class(DHCMGNUR.MgNurContact).%OpenId(id)
	s a.PerFlag=flag
	d a.%Save()
	q a.%Id()
}

ClassMethod TXSave() As %String
{
	for i=1:1:607
	{
		s parr=^RSTX("RSTX","nursers",i)
	    s personid=$P(parr,"^",1) //工号
	    s personTelHand=$P(parr,"^",3) //手机号
	    s personOffTel=$P(parr,"^",4) // 办公电话
	    s personTelHome=$P(parr,"^",5) //家庭电话
	    s personAddress=$P(parr,"^",6) //家庭住址
	    
	    s id="" f  s id=$O(^DHCMGNUR.MgPersonsI("SSID"," "_personid,id)) q:id=""  d
	    .s a=##class(DHCMGNUR.MgPersons).%OpenId(id)
	    .//s a.PersonTelHand=personTelHand
	    .//s a.PersonTelHome=personTelHome
	    .//s a.PersonAddress=personAddress
	    .s aa=##class(DHCMGNUR.MgNurContact).%New()
	    .s aa.ContactParref=##class(DHCMGNUR.MgPersons).%OpenId(id)
	    .s aa.PerName=a.PersonName
	    .s aa.PerID=a.PersonID
	    .s aa.PerMobilePhone=personTelHand //手机
	    .s aa.PerOfficeTel=personOffTel //办公电话
	    .s aa.PerHouseTel=personTelHome //家庭电话
	    .s aa.PerHouseAddress=personAddress //家庭住址
	    .//b ;001
	    .d aa.%Save()
	    .//d a.%Save()
	    
	}
}

Storage Default
{
<Data name="MgNurContactDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PerHouseAddress</Value>
</Value>
<Value name="3">
<Value>PerHouseTel</Value>
</Value>
<Value name="4">
<Value>PerID</Value>
</Value>
<Value name="5">
<Value>PerMobilePhone</Value>
</Value>
<Value name="6">
<Value>PerName</Value>
</Value>
<Value name="7">
<Value>PerOfficeTel</Value>
</Value>
<Value name="8">
<Value>PerFlag</Value>
</Value>
</Data>
<DataLocation>^DHCMGNUR.MgNurContactD</DataLocation>
<DefaultData>MgNurContactDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("ContactParref")</IdLocation>
<IndexLocation>^DHCMGNUR.MgNurContactI</IndexLocation>
<StreamLocation>^DHCMGNUR.MgNurContactS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
