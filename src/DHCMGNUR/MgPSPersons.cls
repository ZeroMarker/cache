/// 实习进修人员表
Class DHCMGNUR.MgPSPersons Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 员工编号
Property PersonID As %String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = Person_ID ];

/// 胸牌号
Property ChestID As %String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = Chest_ID ];

/// 类别 S:进修 P:实习
Property PersonType As %String(TRUNCATE = 1) [ Required, SqlColumnNumber = 4, SqlFieldName = Person_Type ];

/// 姓名
Property PersonName As %String(TRUNCATE = 1) [ Required, SqlColumnNumber = 5, SqlFieldName = Person_Name ];

/// 参加工作时间
Property PersonWorkDate As %String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = Person_WorkDate ];

/// 来院时间
Property PersonComeDate As %String(TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = Person_ComeDate ];

/// 单位或学校
Property PersonLocation As %String(TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = Person_Location ];

/// 班级
Property PersonClass As %String(TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = Person_Class ];

/// 专业或进修专科
Property Perfessional As %String(TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = Perfessional ];

/// 性别
Property PersonSex As %String(TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = Person_Sex ];

/// 出生日期
Property PersonDob As %String(TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = Person_Dob ];

/// 联系地址
Property PersonAddress As %String(TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = Person_Address ];

/// 联系方式
Property PersonPhone As %String(TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = Person_Phone ];

/// 开始时间
Property PersonStDate As %String(TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = Person_StDate ];

/// 结束日期
Property PersonEndDate As %String(TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = Person_EndDate ];

/// 分配科室
Property PersonWard As %String(TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = Person_Ward ];

/// 组别
Property PersonGroup As %String(TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = Person_Group ];

/// 状态 在岗:Y 离岗:N  
Property PersonStatus As %String(TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = Person_Status ];

Property PersonType2 As %String(TRUNCATE = 1) [ SqlColumnNumber = 20, SqlFieldName = Person_Type2 ];

Index SSID On PersonID;

Index Type On PersonType;

Index Ward On PersonWard;

Index WardStatus On (PersonWard, PersonType);

Index WardType On (PersonWard, PersonType);

/// d ##class(DHCMGNUR.MgPSPersons).Save("PersonID|3724^ChestID|23422^PersonName|张珊^PersonLocation|安徽省立医院南区^Perfessional|手术护理^PersonDob|2014-06-25^PersonAddress|安徽省立医院南区^PersonPhone|354435435^PersonWard|897^PersonStDate|2014-06-10^PersonEndDate|^PersonSex|女^PersonType|P")
ClassMethod Save(parr As %String) As %String
{
	q:parr="" ""
	s tmp=""
	s ^tempxbl=parr
	d ##class(web.DHCNurRosterComm).setTmp(parr,.tmp)
	s a=##class(DHCMGNUR.MgPSPersons).%New()
	s a.PersonID=$g(tmp("PersonID")) 
	s a.ChestID=$g(tmp("ChestID"))
	s a.PersonType=$g(tmp("PersonType"))
	s a.PersonName=$g(tmp("PersonName"))
	i $g(tmp("PersonWorkDate"))'="" s a.PersonWorkDate=$zdh(tmp("PersonWorkDate"),3)
	else  s a.PersonWorkDate=""
	i $g(tmp("PersonComeDate"))'="" s a.PersonComeDate=$zdh(tmp("PersonComeDate"),3)
	else  s a.PersonComeDate=""
	s a.PersonLocation=$g(tmp("PersonLocation"))
	s a.PersonClass=$g(tmp("PersonClass"))
	s a.Perfessional=$g(tmp("Perfessional"))
	s a.PersonSex=$g(tmp("PersonSex"))
	i $g(tmp("PersonDob"))'="" s a.PersonDob=$zdh(tmp("PersonDob"),3)
	else  s a.PersonDob=""
	s a.PersonAddress=$g(tmp("PersonAddress"))
	s a.PersonPhone=$g(tmp("PersonPhone"))
	i $g(tmp("PersonStDate"))'="" s a.PersonStDate=$zdh(tmp("PersonStDate"),3)
	else  s a.PersonStDate=""
	i $g(tmp("PersonEndDate"))'="" s a.PersonEndDate=$zdh(tmp("PersonEndDate"),3)
	else  s a.PersonEndDate=""
	s a.PersonWard=$g(tmp("PersonWard"))
	s a.PersonType2=$g(tmp("PersonType2"))
	s a.PersonGroup=""
	s a.PersonStatus="Y"
	TStart
	s sc=a.%Save()
	i $$$ISERR(sc)
	{
		TRollBack
		Do $System.Status.DisplayError(sc)
   		q "ERROR"
	}
	else
	{
		TCommit
		i a.PersonID="" 
		{
			s zerotmp=""
			f i=1:1:(4-$L(a.%Id()))
			{
				s zerotmp=zerotmp_"0"
			}
			s a.PersonID=$g(tmp("PersonType"))_zerotmp_a.%Id()
			d a.%Save()
		}

		q "OK"
	}
}

ClassMethod Update(parr As %String) As %String
{
	q:parr="" ""
	s tmp=""
	d ##class(web.DHCNurRosterComm).setTmp(parr,.tmp)
	s a=##class(DHCMGNUR.MgPSPersons).%OpenId(tmp("ID"))
	s a.PersonID=$g(tmp("PersonID")) 
	s a.ChestID=$g(tmp("ChestID"))
	s a.PersonType=$g(tmp("PersonType"))
	s a.PersonName=$g(tmp("PersonName"))
	i $g(tmp("PersonWorkDate"))'="" s a.PersonWorkDate=$zdh(tmp("PersonWorkDate"),3)
	else  s a.PersonWorkDate=""
	i $g(tmp("PersonComeDate"))'="" s a.PersonComeDate=$zdh(tmp("PersonComeDate"),3)
	else  s a.PersonComeDate=""
	s a.PersonLocation=$g(tmp("PersonLocation"))
	s a.PersonClass=$g(tmp("PersonClass"))
	s a.Perfessional=$g(tmp("Perfessional"))
	s a.PersonSex=$g(tmp("PersonSex"))
	i $g(tmp("PersonDob"))'="" s a.PersonDob=$zdh(tmp("PersonDob"),3)
	else  s a.PersonDob=""
	s a.PersonAddress=$g(tmp("PersonAddress"))
	s a.PersonPhone=$g(tmp("PersonPhone"))
	i $g(tmp("PersonStDate"))'="" s a.PersonStDate=$zdh(tmp("PersonStDate"),3)
	else  s a.PersonStDate=""
	i $g(tmp("PersonEndDate"))'="" s a.PersonEndDate=$zdh(tmp("PersonEndDate"),3)
	else  s a.PersonEndDate=""
	s a.PersonWard=$g(tmp("PersonWard"))
	s a.PersonType2=$g(tmp("PersonType2"))
	s a.PersonStatus="Y"
	TStart
	s sc=a.%Save()
	i $$$ISERR(sc)
	{
		TRollBack
		Do $System.Status.DisplayError(sc)
   		q "ERROR"
	}
	else
	{
		TCommit
		i a.PersonID="" 
		{
			s zerotmp=""
			f i=1:1:(4-$L(a.%Id()))
			{
				s zerotmp=zerotmp_"0"
			}
			s a.PersonID=$g(tmp("PersonType"))_zerotmp_a.%Id()
			d a.%Save()
		}
		q "OK"
	}
}

ClassMethod getVal(ID As %String) As %String
{
	q:ID=""
	s ret=""
	s a=##class(DHCMGNUR.MgPSPersons).%OpenId(ID)
	s ret="PersonID|"_a.PersonID
	s ret=ret_"^"_"ChestID|"_a.ChestID
	s ret=ret_"^"_"PersonType|"_a.PersonType
	s ret=ret_"^"_"PersonName|"_a.PersonName
	s ret=ret_"^"_"PersonWorkDate|" i a.PersonWorkDate'="" s ret=ret_$zd(a.PersonWorkDate,3)
	s ret=ret_"^"_"PersonComeDate|" i a.PersonComeDate'="" s ret=ret_$zd(a.PersonComeDate,3)
	s ret=ret_"^"_"PersonLocation|"_a.PersonLocation
	s ret=ret_"^"_"PersonClass|"_a.PersonClass
	s ret=ret_"^"_"Perfessional|"_a.Perfessional
	s ret=ret_"^"_"PersonSex|"_a.PersonSex
	s ret=ret_"^"_"PersonDob|" i a.PersonDob'="" s ret=ret_$zd(a.PersonDob,3)
	i a.PersonDob'="" s ret=ret_"^"_"PersonAge|"_$P($$CalAge^at182(a.PersonDob,$h),"|",12)
	else  s ret=ret_"^"_"PersonAge|"
	s ret=ret_"^"_"PersonAddress|"_a.PersonAddress
	s ret=ret_"^"_"PersonPhone|"_a.PersonPhone
	s ret=ret_"^"_"PersonStDate|" i a.PersonStDate'="" s ret=ret_$zd(a.PersonStDate,3)
	s ret=ret_"^"_"PersonEndDate|" i a.PersonEndDate'="" s ret=ret_$zd(a.PersonEndDate,3)
	s ret=ret_"^"_"PersonWard|"_a.PersonWard
	i a.PersonWard'="" s ret=ret_"^"_"WardCode|"_$P(^CTLOC(a.PersonWard),"^",1)
	else  s ret=ret_"^"_"WardCode|"
	s ret=ret_"^"_"PersonStatus|"_a.PersonStatus
	s ret=ret_"^PersonType2|" i a.PersonType2'="" s ret=ret_a.PersonType2
	s ret=ret_"^"_"ID|"_ID
	q ret
}

ClassMethod SetStatus(parr As %String) As %String
{
	q:parr=""
	s ID=$P(parr,"^",1)
	s Status=$P(parr,"^",2)
	s a=##class(DHCMGNUR.MgPSPersons).%OpenId(ID)
	s a.PersonStatus=Status
	d a.%Save()
	q
}

ClassMethod CheckIDRepeat(personID)
{
	q:personID="" 0
	s id=$O(^DHCMGNUR.MgPSPersonsI("SSID"," "_personID,""))
	q id
}

Storage Default
{
<Data name="MgPSPersonsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PersonID</Value>
</Value>
<Value name="3">
<Value>ChestID</Value>
</Value>
<Value name="4">
<Value>PersonType</Value>
</Value>
<Value name="5">
<Value>PersonName</Value>
</Value>
<Value name="6">
<Value>PersonLocation</Value>
</Value>
<Value name="7">
<Value>PersonClass</Value>
</Value>
<Value name="8">
<Value>Perfessional</Value>
</Value>
<Value name="9">
<Value>PersonSex</Value>
</Value>
<Value name="10">
<Value>PersonDob</Value>
</Value>
<Value name="11">
<Value>PersonAddress</Value>
</Value>
<Value name="12">
<Value>PersonPhone</Value>
</Value>
<Value name="13">
<Value>PersonStDate</Value>
</Value>
<Value name="14">
<Value>PersonEndDate</Value>
</Value>
<Value name="15">
<Value>PersonStatus</Value>
</Value>
<Value name="16">
<Value>PersonTempWard</Value>
</Value>
<Value name="17">
<Value>PersonWard</Value>
</Value>
<Value name="18">
<Value>PersonWorkDate</Value>
</Value>
<Value name="19">
<Value>PersonComeDate</Value>
</Value>
<Value name="20">
<Value>PersonGroup</Value>
</Value>
<Value name="21">
<Value>PersonType2</Value>
</Value>
</Data>
<DataLocation>^DHCMGNUR.MgPSPersonsD</DataLocation>
<DefaultData>MgPSPersonsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMGNUR.MgPSPersonsD</IdLocation>
<IndexLocation>^DHCMGNUR.MgPSPersonsI</IndexLocation>
<StreamLocation>^DHCMGNUR.MgPSPersonsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
