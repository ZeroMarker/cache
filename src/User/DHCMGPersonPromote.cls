Class User.DHCMGPersonPromote Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property PromDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 2, SqlFieldName = Prom_Date ];

//记录时间

Property PromTime As %Library.Time [ InitialExpression = {+$p($h,",",2)}, Required, SqlColumnNumber = 3, SqlFieldName = Prom_Time ];

Property PromProfPosDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = Prom_ProfPos_DR ];

Property PromAppProfPosDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = Prom_AppProfPos_DR ];

Property PromTeachDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = Prom_Teach_DR ];

Property PromMentorDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = Prom_Mentor_DR ];

Property PromCurrent As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = Prom_Current ];

Property PromRecDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = Prom_RecDate ];

Property PromRecTime As %Library.Time [ InitialExpression = {+$p($h,",",2)}, Required, SqlColumnNumber = 10, SqlFieldName = Prom_RecTime ];

Property PromRecUser As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = Prom_RecUser ];

Property PromPerson As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = Prom_Person ];

Index Person On PromPerson;

ClassMethod savepromote(parr As %String) As %String
{
	//w ##class(User.DHCMGPersonPromote).savepromote("20^875^2014-12-25^11^^^^N^1")
	//s parr="20^875^2014-12-25^11^^^^N^1"
	s id=$P(parr,"^",1)
	s personid=$P(parr,"^",2)
	s promdate=$P(parr,"^",3)
	s ProfPosDR=$P(parr,"^",4)
	s AppProfPosDR=$P(parr,"^",5)
	s TeachDR=$P(parr,"^",6)
	s MentorDR=$P(parr,"^",7)
	s Current=$P(parr,"^",8)
	s Userid=$P(parr,"^",9)
	s recdate=$P($h,",",1)
	s rectime=$P($h,",",2)
	if id="" s prom=##class(User.DHCMGPersonPromote).%New()
    e  s prom=##class(User.DHCMGPersonPromote).%OpenId(id)
    s prom.PromPerson=(personid)
    s prom.PromDate=$ZDH(promdate,3)
    s prom.PromTime=$P($h,",",2)
    s prom.PromProfPosDR=ProfPosDR
    s prom.PromAppProfPosDR=AppProfPosDR
    s prom.PromTeachDR=TeachDR
    s prom.PromMentorDR=MentorDR
    s prom.PromCurrent=Current
    s prom.PromRecDate=recdate
    s prom.PromRecTime=rectime
    d prom.%Save()
    if (Current="Y")
    {
	  s p=##class(User.DHCMGPersons).%OpenId(personid)
	  i ProfPosDR'="" {
	    s p.PersonTechPostDate=$ZDH(promdate,3)
	    s p.PersonProfPostDR=##class(User.DHCMGCPostCode).%OpenId(ProfPosDR)
	  }
	  ;i AppProfPosDR'="" s p.PersonAppDutyDR=##class(User.DHCMGCPostCode).%OpenId(AppProfPosDR)
	  i AppProfPosDR'="" d
	  .s p.PersonAppdutyDate=$ZDH(promdate,3)
	  .s p.PersonAppDutyDR=##class(User.DHCMGCPostCode).%OpenId(AppProfPosDR)
	  i TeachDR'="" s p.PersonTeachPostDR=##class(User.DHCMGCPostCode).%OpenId(TeachDR)
	  i MentorDR'="" s p.PersonMentorDR=##class(User.DHCMGCPostCode).%OpenId(MentorDR)
	  d p.%Save()
	}
	
	 if (Current'="Y") d
	 .i ProfPosDR'="" d
     ..s allno=""
     ..s tmpId="" f  s tmpId=$o(^User.DHCMGPersonPromoteI("Person"," "_personid,tmpId)) q:(tmpId="")!(allno="Y")  d
     ...q:allno="Y"
     ...s ProfPos=$listget(^User.DHCMGPersonPromoteD(tmpId),6)
     ...q:ProfPos=""
     ...s flagY=$listget(^User.DHCMGPersonPromoteD(tmpId),3)
     ...i flagY="Y" s allno="Y"
     ..i allno="" d
     ...s p=##class(User.DHCMGPersons).%OpenId(personid)
	 ...s p.PersonTechPostDate=""
	 ...s p.PersonProfPostDR=""
	 ...d p.%Save() 
	 .///
     .i AppProfPosDR'="" d
     ..s allno=""
     ..s tmpId="" f  s tmpId=$o(^User.DHCMGPersonPromoteI("Person"," "_personid,tmpId)) q:(tmpId="")!(allno="Y")  d
     ...q:allno="Y"
     ...s ProfPos=$listget(^User.DHCMGPersonPromoteD(tmpId),2)
     ...q:ProfPos=""
     ...s flagY=$listget(^User.DHCMGPersonPromoteD(tmpId),3)
     ...i flagY="Y" s allno="Y"
     ..i allno="" d
     ...s p=##class(User.DHCMGPersons).%OpenId(personid)
	 ...s p.PersonAppdutyDate=""
	 ...s p.PersonAppDutyDR=""
	 ...d p.%Save() 
	 .///
	 .i TeachDR'="" d
     ..s allno=""
     ..s tmpId="" f  s tmpId=$o(^User.DHCMGPersonPromoteI("Person"," "_personid,tmpId)) q:(tmpId="")!(allno="Y")  d
     ...q:allno="Y"
     ...s ProfPos=$listget(^User.DHCMGPersonPromoteD(tmpId),10)
     ...q:ProfPos=""
     ...s flagY=$listget(^User.DHCMGPersonPromoteD(tmpId),3)
     ...i flagY="Y" s allno="Y"
     ..i allno="" d
     ...s p=##class(User.DHCMGPersons).%OpenId(personid)
	 ...s p.PersonTeachPostDR=""
	 ...d p.%Save() 
	 .///
	 .i MentorDR'="" d
     ..s allno=""
     ..s tmpId="" f  s tmpId=$o(^User.DHCMGPersonPromoteI("Person"," "_personid,tmpId)) q:(tmpId="")!(allno="Y")  d
     ...q:allno="Y"
     ...s ProfPos=$listget(^User.DHCMGPersonPromoteD(tmpId),5)
     ...q:ProfPos=""
     ...s flagY=$listget(^User.DHCMGPersonPromoteD(tmpId),3)
     ...i flagY="Y" s allno="Y"
     ..i allno="" d
     ...s p=##class(User.DHCMGPersons).%OpenId(personid)
	 ...s p.PersonMentorDR=""
	 ...d p.%Save() 
    q 0
}

Storage Default
{
<Data name="DHCMGPersonPromoteDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PromAppProfPosDR</Value>
</Value>
<Value name="3">
<Value>PromCurrent</Value>
</Value>
<Value name="4">
<Value>PromDate</Value>
</Value>
<Value name="5">
<Value>PromMentorDR</Value>
</Value>
<Value name="6">
<Value>PromProfPosDR</Value>
</Value>
<Value name="7">
<Value>PromRecDate</Value>
</Value>
<Value name="8">
<Value>PromRecTime</Value>
</Value>
<Value name="9">
<Value>PromRecUser</Value>
</Value>
<Value name="10">
<Value>PromTeachDR</Value>
</Value>
<Value name="11">
<Value>PromTime</Value>
</Value>
<Value name="12">
<Value>PromPerson</Value>
</Value>
</Data>
<DataLocation>^User.DHCMGPersonPromoteD</DataLocation>
<DefaultData>DHCMGPersonPromoteDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMGPersonPromoteD</IdLocation>
<IndexLocation>^User.DHCMGPersonPromoteI</IndexLocation>
<StreamLocation>^User.DHCMGPersonPromoteS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
