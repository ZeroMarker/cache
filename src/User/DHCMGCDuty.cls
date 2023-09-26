Class User.DHCMGCDuty Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property DutyCode As %String(TRUNCATE = 1);

//工作时间

Property DutyDesc As %String(TRUNCATE = 1);

Property DutyFreq As %String(TRUNCATE = 1);

Property DutyLocDr As %String(TRUNCATE = 1);

Property DutyLocation As %String(TRUNCATE = 1);

Property DutyPerTyp As %Library.String(DISPLAYLIST = ",Doctor,Nurse,Worker", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",D,N,W") [ SqlColumnNumber = 13, SqlFieldName = Duty_PerTyp ];

Property DutySatur As %String(TRUNCATE = 1);

Property Dutyyears As %String(TRUNCATE = 1);

Property DutyPersons As %String(TRUNCATE = 1);

Property DutyStTime As %Library.Time;

Property DutyEdTime As %Library.Time;

Index Loc On DutyLocDr;

ClassMethod SaveDuty(Parr As %String) As %String
{
    //s Parr="2^1013^sdfsd^4433^2^55^44^44^erer^8!3!^4!^6!"
    s id=$P(Parr,"^")
    s loc=$P(Parr,"^",2)
    s Desc=$P(Parr,"^",3)
    s Code=$P(Parr,"^",4)
    s DutyYears=$P(Parr,"^",5)
    s DutyTime=$P(Parr,"^",6)
    s freq=$P(Parr,"^",7)
    s satur=$P(Parr,"^",8)
    s location=$P(Parr,"^",9)
    s profpos=$P(Parr,"^",10)
    s teach=$P(Parr,"^",11)
    s mentor=$P(Parr,"^",12)
    s stime=$P(Parr,"^",13)
    s etime=$P(Parr,"^",14)
    if (id="" )
    {
	    s duty=##class(User.DHCMGCDuty).%New()
    }
    else{ 
	    s duty=##class(User.DHCMGCDuty).%OpenId(id)
	    s a=..deleteprofpos(id)
	    s a=..deleteteach(id)
	    s a=..deletementor(id)
     }
    s duty.DutyCode=Code
    s duty.DutyDesc=Desc
    s duty.DutyFreq=freq
    s duty.DutyLocDr=loc
    s duty.DutySatur=satur
    s duty.Dutyyears=DutyYears
    s duty.DutyStTime=$ZTH(stime)
    s duty.DutyEdTime=$ZTH(etime)
    //s duty.DutyTime=DutyTime
    s duty.DutyLocation=location
    d duty.%Save()
    s bb=..saveprofpos(profpos,"User.DHCMGCDutyProfPos",duty)  
    s bb=..saveprofpos(teach,"User.DHCMGCDutyTeach",duty)  
    s bb=..saveprofpos(mentor,"User.DHCMGCDutyMentor",duty)  
    q 0
}

ClassMethod deleteprofpos(duty) As %String
{
    b //
    s chl=""  f  s chl=$O(^User.DHCMGCDutyProfPosI("Duty",duty,chl)) q:chl=""  d
    .b //
    .d ##class(User.DHCMGCDutyProfPos).%DeleteId(chl)
    .b
    q 0
}

ClassMethod deleteteach(duty) As %String
{
    s chl=""  f  s chl=$O(^User.DHCMGCDutyTeachI("Duty",duty,chl)) q:chl=""  d
    .d ##class(User.DHCMGCDutyTeach).%DeleteId(chl)
    q 0
}

ClassMethod deletementor(duty) As %String
{
    s chl=""  f  s chl=$O(^User.DHCMGCDutyMentorI("Duty",duty,chl)) q:chl=""  d
    .d ##class(User.DHCMGCDutyMentor).%DeleteId(chl)
    q 0
}

ClassMethod saveprofpos(str, clsname, duty) As %String
{
     s l=$l(str,"!")
     b
     for i=1:1:l
     {
	    s a=$P(str,"!",i)
	    q:a=""
	    if clsname="User.DHCMGCDutyMentor"
	    {
	      s b=##class(User.DHCMGCDutyMentor).%New()
	    }
	    if (clsname="User.DHCMGCDutyTeach") 
	    {
	      s b=##class(User.DHCMGCDutyTeach).%New()
	    }
	    if (clsname="User.DHCMGCDutyProfPos") 
	    {
	      s b=##class(User.DHCMGCDutyProfPos).%New()
	    }
	    s b.DutyDr=duty
	    b
	    if (clsname="User.DHCMGCDutyMentor") 
	    {
	    s b.DutyMentor=a
	    }
	    if (clsname="User.DHCMGCDutyTeach") 
	    {
	    s b.DutyTeach=a
	    }
	    if (clsname="User.DHCMGCDutyProfPos") 
	    {
	    s b.DutyProfPos=a
	    }
	    d b.%Save()
	 }
	 q 0
}

Storage Default
{
<Data name="DHCMGCDutyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DutyCode</Value>
</Value>
<Value name="3">
<Value>DutyDesc</Value>
</Value>
<Value name="4">
<Value>DutyFreq</Value>
</Value>
<Value name="5">
<Value>DutyLocDr</Value>
</Value>
<Value name="6">
<Value>DutyLocation</Value>
</Value>
<Value name="7">
<Value>DutyPerTyp</Value>
</Value>
<Value name="8">
<Value>DutySatur</Value>
</Value>
<Value name="9">
<Value>DutyTime</Value>
</Value>
<Value name="10">
<Value>Dutyyears</Value>
</Value>
<Value name="11">
<Value>DutyPersons</Value>
</Value>
<Value name="12">
<Value>DutyEdTime</Value>
</Value>
<Value name="13">
<Value>DutyStTime</Value>
</Value>
</Data>
<DataLocation>^User.DHCMGCDutyD</DataLocation>
<DefaultData>DHCMGCDutyDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMGCDutyD</IdLocation>
<IndexLocation>^User.DHCMGCDutyI</IndexLocation>
<StreamLocation>^User.DHCMGCDutyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
