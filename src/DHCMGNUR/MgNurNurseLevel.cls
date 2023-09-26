/// 护士层级
Class DHCMGNUR.MgNurNurseLevel Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Relationship NurseLevelParref As DHCMGNUR.MgPersons [ Cardinality = parent, Inverse = perNurseLevel, Required ];

/// 姓名
Property PerName As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = Per_Name ];

/// 工号
Property PerID As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = Per_ID ];

/// 层级
Property PerLevel As DHCMGNUR.CommDictionarySub [ SqlColumnNumber = 4, SqlFieldName = Per_Level ];

/// 晋升日期
Property PerPromoDate As %Date [ SqlColumnNumber = 5, SqlFieldName = Per_Promo_Date ];

/// 当前标识
Property PerCurrIdenty As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = Per_Curr_Identy ];

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
    .s a=##class(DHCMGNUR.MgNurNurseLevel).%New()
    .s a.NurseLevelParref=##class(DHCMGNUR.MgPersons).%OpenId(id)
    e  d
    .s a=##class(DHCMGNUR.MgNurNurseLevel).%OpenId(id_"||"_rw)
    s p="" f  s p=$O(^oddCOM("DHCMGNUR.MgNurNurseLevel","a",p)) q:p=""  d
    .i p="PerLevel" s tmp(p)=$tr(tmp(p),"__","||")
    s a.PerName=tmp("PerName")
    s a.PerID=tmp("PerID")
    s a.PerLevel=##class(DHCMGNUR.CommDictionarySub).%OpenId(tmp("PerLevel"))
    s a.PerPromoDate=$ZDH(tmp("PerPromoDate"),3)
    s a.PerFlag="0"
    //s a.PerCurrIdenty=tmp("PerCurrIdenty")
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
		s a=##class(DHCMGNUR.MgNurNurseLevel).%OpenId(id)
		s pidpar=$P(id,"||",1)
		s pidrw=$P(id,"||",2)
		s parm=$G(^DHCMGNUR.MgNurNurseLevelD(pidpar,pidrw))
		s PerName=a.PerName
		s PerID=a.PerID
		s PerLevel=$listget(parm,4)
		s PerLevel=$tr(PerLevel,"||","__")
		i a.PerPromoDate'="" d
		.i ((dateFlag=3)!(dateFlag=4)) s PerPromoDate=##class(web.DHCMgNurPerHRComm).getDateFormat(a.PerPromoDate)
		.e  s PerPromoDate=""
		e  s PerPromoDate=""
		s PerFlag=a.PerFlag
		s ret=ret_"PerName|"_PerName_"^"_"PerID|"_PerID_"^"_"PerLevel|"_PerLevel_"^"_"PerPromoDate|"_PerPromoDate_"^"_"PerFlag|"_PerFlag_"^"
	}
	q ret
}

/// 删除
ClassMethod delItem(id As %String) As %String
{
	s ^IDTEMP=id
	TStart
	s object=##class(DHCMGNUR.MgNurNurseLevel).%OpenId(id)
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
	s a=##class(DHCMGNUR.MgNurNurseLevel).%OpenId(id)
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
	s a=##class(DHCMGNUR.MgNurNurseLevel).%OpenId(id)
	s a.PerFlag=flag
	d a.%Save()
	q a.%Id()
}

Storage Default
{
<Data name="MgNurNurseLevelDefaultData">
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
<Value>PerLevel</Value>
</Value>
<Value name="5">
<Value>PerCurrIdenty</Value>
</Value>
<Value name="6">
<Value>PerPromoDate</Value>
</Value>
<Value name="7">
<Value>PerFlag</Value>
</Value>
</Data>
<DataLocation>^DHCMGNUR.MgNurNurseLevelD</DataLocation>
<DefaultData>MgNurNurseLevelDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("NurseLevelParref")</IdLocation>
<IndexLocation>^DHCMGNUR.MgNurNurseLevelI</IndexLocation>
<StreamLocation>^DHCMGNUR.MgNurNurseLevelS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
