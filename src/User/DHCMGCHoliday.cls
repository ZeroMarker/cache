Class User.DHCMGCHoliday Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property HolCode As %String(TRUNCATE = 1);

Property HolDesc As %String(TRUNCATE = 1);

Property HolCurrFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N");

ClassMethod saveHoli(parr As %String) As %String
{
   // w ##class(User.DHCMGCHoliday).saveHoli("^休^休^N")
   //s parr="^休^休^N"
   s id=$P(parr,"^")
   s code=$P(parr,"^",2)
   s desc=$P(parr,"^",3)
   s flag=$P(parr,"^",4)
   
   s rtn=0
   s rw=0 f  s rw=$o(^User.DHCMGCHolidayD(rw)) q:(rw="")!(rtn'=0)  d
   .s curflag=$listget(^User.DHCMGCHolidayD(rw),3)
   .q:curflag="Y"
   .s curcode=$listget(^User.DHCMGCHolidayD(rw),2)
   .s curdesc=$listget(^User.DHCMGCHolidayD(rw),4)
   .i (curcode=code)&(curdesc=desc) s rtn="假期有重复!"
   b //33
   q:rtn'=0 rtn
   if id="" s hol=##class(User.DHCMGCHoliday).%New()
   e  s hol=##class(User.DHCMGCHoliday).%OpenId(id)
   s hol.HolCode=code
   s hol.HolDesc=desc
   s hol.HolCurrFlag=flag
   d hol.%Save()
   q 0
}

Storage Default
{
<Data name="DHCMGCHolidayDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>HolCode</Value>
</Value>
<Value name="3">
<Value>HolCurrFlag</Value>
</Value>
<Value name="4">
<Value>HolDesc</Value>
</Value>
</Data>
<DataLocation>^User.DHCMGCHolidayD</DataLocation>
<DefaultData>DHCMGCHolidayDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMGCHolidayD</IdLocation>
<IndexLocation>^User.DHCMGCHolidayI</IndexLocation>
<StreamLocation>^User.DHCMGCHolidayS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
