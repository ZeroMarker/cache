Class User.DHCMGPersonHoliday Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property HOLPersonDR As %String(TRUNCATE = 1);

//备注

Property HOLFromDate As %Library.Date(FORMAT = 1);

Property HOLEndDate As %Library.Date(FORMAT = 1);

Property HOLStTime As %Library.Time;

Property HOLETime As %Library.Time;

Property HOLHolDR As %String(TRUNCATE = 1);

Property HOLRecDate As %Library.Date(FORMAT = 1);

Property HOLRecTime As %Library.Time [ InitialExpression = {+$p($h,",",2)}, Required ];

Property HOLRecUser As %String(TRUNCATE = 1);

Property HOLAudDate As %Library.Date(FORMAT = 1);

Property HOLAudTime As %Library.Time [ InitialExpression = {+$p($h,",",2)}, Required ];

Property HOLAudUser As %String(TRUNCATE = 1);

Property HOLMem As %String(TRUNCATE = 1);

Property HOLDepDr As %String(TRUNCATE = 1);

Index DepDate On (HOLDepDr, HOLFromDate);

Index PerHl On (HOLPersonDR, HOLHolDR);

Index PersonDate On (HOLPersonDR, HOLFromDate);

Index dephlper On (HOLDepDr, HOLHolDR, HOLPersonDR);

ClassMethod ShcHol(per, date) As %String
{
   s rw=""  s rw=$O(^User.DHCMGPersonHolidayI("PersonDate"," "_per,date,rw))
   q rw
}

ClassMethod DelHolBakXH(per, date) As %String
{
   //s a=##class(User.DHCMGPersonHoliday).DelHol()
	 // s per=2981,date="2009-11-20"
      s date=$ZDH(date,3)
      s ProtectDay=$g(^DHCCLSet("DHCNURMG","ArrangeProtectDay"))
      q:(date<(+$h))&((+$h-date)'<ProtectDay)&(ProtectDay'="") 0

      s rw=""  s rw=$O(^User.DHCMGPersonHolidayI("PersonDate"," "_per,date,rw))
      
      if rw'=""
      {
	    s perhol=##class(User.DHCMGPersonHoliday).%OpenId(rw) 
	    s fdate=perhol.HOLFromDate
	    s edate=perhol.HOLEndDate
	    if (fdate=edate)
	    {
		    d ##class(User.DHCMGPersonHoliday).%DeleteId(rw) 
		}else{
			s perhol.HOLFromDate=fdate+1
            d perhol.%Save()
			}

	  }
	  q 0
}

ClassMethod DelHol(per, date) As %String
{
   //s a=##class(User.DHCMGPersonHoliday).DelHol()
	 // s per=2981,date="2009-11-20"
      s date=$ZDH(date,3)
      s ProtectDay=$g(^DHCCLSet("DHCNURMG","ArrangeProtectDay"))
      q:(date<(+$h))&((+$h-date)'<ProtectDay)&(ProtectDay'="") 0
      
      ;s rw=""  s rw=$O(^User.DHCMGPersonHolidayI("PersonDate"," "_per,date,rw))
      s rw="" f  s rw=$O(^User.DHCMGPersonHolidayI("PersonDate"," "_per,date,rw)) q:rw=""   d
      .q:rw=""
	  .s perhol=##class(User.DHCMGPersonHoliday).%OpenId(rw) 
	  .s fdate=perhol.HOLFromDate
	  .s edate=perhol.HOLEndDate
	  .if (fdate=edate) d
	  ..d ##class(User.DHCMGPersonHoliday).%DeleteId(rw) 
	  .else  d
	  ..s perhol.HOLFromDate=fdate+1
      ..d perhol.%Save()
	  q 0
}

ClassMethod SavePerHolBakXH(parr As %String) As %String
{
	//s parr="^931^3^2009-4-14^2009-4-14^543^1082^^9:06:53^11:06:53"
	s id=$P(parr,"^",1)
	s pers=$P(parr,"^",2)
	s hldr=$P(parr,"^",3)
	s fdate=$P(parr,"^",4)
	s edate=$P(parr,"^",5)
	s fdate=$ZDH(fdate,3)
	s ProtectDay=$g(^DHCCLSet("DHCNURMG","ArrangeProtectDay"))
    q:(fdate<(+$h))&((+$h-fdate)'<ProtectDay)&(ProtectDay'="") 0
	s edate=$ZDH(edate,3)
	s user=$P(parr,"^",6)
	s dep=$P(parr,"^",7)
	s mem=$P(parr,"^",8)
	s sttime=$P(parr,"^",9)
	s etime=$P(parr,"^",10)
	s hol=..ShcHol(pers,fdate)
	if hol'=""
	{
		s dd=##class(User.DHCMGPersonHoliday).%OpenId(hol)
		if dd.HOLDepDr'=dep  d ##class(User.DHCMGPersonHoliday).%DeleteId(hol) 
	}
	q:hol'="" ""
	if sttime'="" s sttime=$ZTH(sttime,3)
	if etime'="" s etime=$ZTH(etime,3)
	b //dd
	if id="" s perhol=##class(User.DHCMGPersonHoliday).%New()
	e  s perhol=##class(User.DHCMGPersonHoliday).%OpenId(id)
	s oldper="",oldval=""
	if id'=""           
	{
	   s oldper=perhol.HOLPersonDR
	   s fd=perhol.HOLFromDate
	   s ed=perhol.HOLEndDate
	   s oldval=ed-fd
	   b /////
	}
	s perhol.HOLPersonDR=pers
	s perhol.HOLFromDate=fdate
	s perhol.HOLEndDate=edate
	s perhol.HOLHolDR=hldr
	s perhol.HOLRecUser=user
	s perhol.HOLRecDate=+$H
	s perhol.HOLRecTime=$P($H,",",2)
	s perhol.HOLDepDr=dep
	s perhol.HOLMem=mem
	s perhol.HOLStTime=sttime
	s perhol.HOLETime=etime
	d perhol.%Save()
	s hol=##class(User.DHCMGCHoliday).%OpenId(hldr)
    if hol.HolCode="BX" 
    { //补休时 要更新存休数据
      // 如果是更新
	   s val=(edate-fdate)+1
	   if (id'="")&(oldper=pers) s val=val-oldval
	   s val=(8*val)
	   if (fdate=edate)&(sttime'="")
	   {
	      s val=(etime-sttime)/3600
	   }
	   b
	   s a=##class(User.DHCMGPersonOverRest).uplastRec(pers,val)
	}
	q 0
}

ClassMethod SavePerHol(parr As %String) As %String
{
	//s parr="^931^3^2009-4-14^2009-4-14^543^1082^^9:06:53^11:06:53"
	//^6321^4^2012-11-5^2012-11-5^^121^^^^
	s id=$P(parr,"^",1)
	s pers=$P(parr,"^",2)
	s hldr=$P(parr,"^",3)
	s fdate=$P(parr,"^",4)
	s edate=$P(parr,"^",5)
	s fdate=$ZDH(fdate,3)
	s ProtectDay=$g(^DHCCLSet("DHCNURMG","ArrangeProtectDay"))
    q:(fdate<(+$h))&((+$h-fdate)'<ProtectDay)&(ProtectDay'="") 0
	s edate=$ZDH(edate,3)
	s user=$P(parr,"^",6)
	s dep=$P(parr,"^",7)
	s mem=$P(parr,"^",8)
	s sttime=$P(parr,"^",9)
	s etime=$P(parr,"^",10)
	s addflag=$P(parr,"^",11)
	b //10
	s hol=..ShcHol(pers,fdate)
	//if hol'=""
	if (hol'="")&(addflag'="Y")
	{
		s dd=##class(User.DHCMGPersonHoliday).%OpenId(hol)
		if dd.HOLDepDr'=dep  d ##class(User.DHCMGPersonHoliday).%DeleteId(hol) 
	}
	//q:hol'="" ""
	q:(hol'="")&(addflag'="Y") ""
	if sttime'="" s sttime=$ZTH(sttime,3)
	if etime'="" s etime=$ZTH(etime,3)
	b //dd
	if id="" s perhol=##class(User.DHCMGPersonHoliday).%New()
	e  s perhol=##class(User.DHCMGPersonHoliday).%OpenId(id)
	s oldper="",oldval=""
	if id'=""           
	{
	   s oldper=perhol.HOLPersonDR
	   s fd=perhol.HOLFromDate
	   s ed=perhol.HOLEndDate
	   s oldval=ed-fd
	   b /////
	}
	s perhol.HOLPersonDR=pers
	s perhol.HOLFromDate=fdate
	s perhol.HOLEndDate=edate
	s perhol.HOLHolDR=hldr
	s perhol.HOLRecUser=user
	s perhol.HOLRecDate=+$H
	s perhol.HOLRecTime=$P($H,",",2)
	s perhol.HOLDepDr=dep
	s perhol.HOLMem=mem
	s perhol.HOLStTime=sttime
	s perhol.HOLETime=etime
	d perhol.%Save()
	s hol=##class(User.DHCMGCHoliday).%OpenId(hldr)
    if hol.HolCode="BX" 
    { //补休时 要更新存休数据
      // 如果是更新
	   s val=(edate-fdate)+1
	   if (id'="")&(oldper=pers) s val=val-oldval
	   s val=(8*val)
	   if (fdate=edate)&(sttime'="")
	   {
	      s val=(etime-sttime)/3600
	   }
	   b
	   s a=##class(User.DHCMGPersonOverRest).uplastRec(pers,val)
	}
	q 0
}

ClassMethod SavePerHol1(parr As %String) As %String
{
	//s parr="773^2007^1^2010-02-07^2010-02-08^3539^1304^21:47:04^21:47:04"
	
	s id=$P(parr,"^",1)
	s pers=$P(parr,"^",2)
	s hldr=$P(parr,"^",3)
	s fdate=$P(parr,"^",4)
	s edate=$P(parr,"^",5)
	s fdate=$ZDH(fdate,3)
	s edate=$ZDH(edate,3)
	s user=$P(parr,"^",6)
	s dep=$P(parr,"^",7)
	s mem=""
	s sttime=$ZTH($P(parr,"^",8))
	s etime=$ZTH($P(parr,"^",9))
	if id="" s perhol=##class(User.DHCMGPersonHoliday).%New()
	e  s perhol=##class(User.DHCMGPersonHoliday).%OpenId(id)
	s oldper="",oldval=""
	if id'=""           
	{
	   s oldper=perhol.HOLPersonDR
	   s fd=perhol.HOLFromDate
	   s ed=perhol.HOLEndDate
	   s oldval=ed-fd
	   b /////
	}
	s perhol.HOLPersonDR=pers
	s perhol.HOLFromDate=fdate
	s perhol.HOLEndDate=edate
	s perhol.HOLHolDR=hldr
	s perhol.HOLRecUser=user
	s perhol.HOLRecDate=+$H
	s perhol.HOLRecTime=$P($H,",",2)
	s perhol.HOLDepDr=dep
	s perhol.HOLMem=mem
	s perhol.HOLStTime=sttime
	s perhol.HOLETime=etime
	d perhol.%Save()
	s hol=##class(User.DHCMGCHoliday).%OpenId(hldr)
    if hol.HolCode="BX" 
    { //补休时 要更新存休数据
      // 如果是更新
	   s val=(edate-fdate)+1
	   if (id'="")&(oldper=pers) s val=val-oldval
	   s val=(8*val)
	   if (fdate=edate)&(sttime'="")
	   {
	      s val=(etime-sttime)/3600
	   }
	   b
	   s a=##class(User.DHCMGPersonOverRest).uplastRec(pers,val)
	}
	q 0
}

Storage Default
{
<Data name="DHCMGPersonHolidayDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>HOLEndDate</Value>
</Value>
<Value name="3">
<Value>HOLFromDate</Value>
</Value>
<Value name="4">
<Value>HOLHolDR</Value>
</Value>
<Value name="5">
<Value>HOLMem</Value>
</Value>
<Value name="6">
<Value>HOLPersonDR</Value>
</Value>
<Value name="7">
<Value>HOLRecDate</Value>
</Value>
<Value name="8">
<Value>HOLRecTime</Value>
</Value>
<Value name="9">
<Value>HOLRecUser</Value>
</Value>
<Value name="10">
<Value>HOLDepDr</Value>
</Value>
<Value name="11">
<Value>HOLAudDate</Value>
</Value>
<Value name="12">
<Value>HOLAudTime</Value>
</Value>
<Value name="13">
<Value>HOLAudUser</Value>
</Value>
<Value name="14">
<Value>HOLETime</Value>
</Value>
<Value name="15">
<Value>HOLStTime</Value>
</Value>
</Data>
<DataLocation>^User.DHCMGPersonHolidayD</DataLocation>
<DefaultData>DHCMGPersonHolidayDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMGPersonHolidayD</IdLocation>
<IndexLocation>^User.DHCMGPersonHolidayI</IndexLocation>
<StreamLocation>^User.DHCMGPersonHolidayS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
