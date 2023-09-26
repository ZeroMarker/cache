Class DHCMGNUR.MgNurWard Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property HsDr As %Integer;

Property LocTyp As %String(TRUNCATE = 1);

Property WardLoc As %Integer;

Property SortPos As %Integer;

Index Typ On (HsDr, LocTyp, WardLoc);

ClassMethod delpos(hsdr, typ, loc) As %String
{
  	s typ=$TR($ZConvert(typ,"U")," ","")
  	
	s count=0
	s rw=""  s rw=$O(^DHCMGNUR.MgNurWardI("Typ",hsdr," "_typ,loc,rw))
	b //loc
 	if rw="" q 0
	 s a=##class(DHCMGNUR.MgNurWard).%OpenId(rw)
	 s crw=rw
	 s oldpos=a.SortPos
	 s CtLocDr="" f  s CtLocDr=$O(^DHCMGNUR.MgNurWardI("Typ",hsdr," "_typ,CtLocDr)) q:CtLocDr=""  d
	    .s rw="" f  s rw=$O(^DHCMGNUR.MgNurWardI("Typ",hsdr," "_typ,CtLocDr,rw)) q:rw=""  d
		..s a=##class(DHCMGNUR.MgNurWard).%OpenId(rw)
		..s st=a.SortPos
		..if ((st>oldpos)) d
		...s a.SortPos=st-1
		...d a.%Save()
   d ##class(DHCMGNUR.MgNurWard).%DeleteId(crw)
   q 0
}

ClassMethod getselloc(hsdr, typ)
{
 //s r=##class(DHCMGNUR.MgNurWard).getselloc
  	 s ret=""
  	 s typ=$TR($ZConvert(typ,"U")," ","")
  	 s CtLocDr="" f  s CtLocDr=$O(^DHCMGNUR.MgNurWardI("Typ",hsdr," "_typ,CtLocDr)) q:CtLocDr=""  d
  	 .s ret=ret_CtLocDr_"^"
  	 q ret
}

ClassMethod SavePos(hsdr, typ, loc, sort) As %String
{
 //s r=##class(DHCMGNUR.MgNurWard).SavePos()
    s ^TMP("loc")=$LB(hsdr,typ,loc,sort)
  	s typ=$TR($ZConvert(typ,"U")," ","")
  	
	s count=0
	s rw=""  s rw=$O(^DHCMGNUR.MgNurWardI("Typ",hsdr," "_typ,loc,rw))
	b //loc
 	if rw="" q 0
	 s a=##class(DHCMGNUR.MgNurWard).%OpenId(rw)
	 s crw=rw
	 s oldpos=a.SortPos
	 b //
    if (oldpos>sort) 
    { //加1 '<sort  && <oldpos
        b  // //值变小，往前移
	   s CtLocDr="" f  s CtLocDr=$O(^DHCMGNUR.MgNurWardI("Typ",hsdr," "_typ,CtLocDr)) q:CtLocDr=""  d
	    .s rw="" f  s rw=$O(^DHCMGNUR.MgNurWardI("Typ",hsdr," "_typ,CtLocDr,rw)) q:rw=""  d
		..s a=##class(DHCMGNUR.MgNurWard).%OpenId(rw)
		..s st=a.SortPos
		..//w !,st,",",sort,",",oldpos
		..if ((st'<sort)&(st<oldpos)) d
		...b //sort
		...s a.SortPos=st+1
		...d a.%Save()

	}
    if (oldpos<sort)  //值变大，往后移
    { //减1 >oldpos && '>sort
	   s CtLocDr="" f  s CtLocDr=$O(^DHCMGNUR.MgNurWardI("Typ",hsdr," "_typ,CtLocDr)) q:CtLocDr=""  d
	    .s rw="" f  s rw=$O(^DHCMGNUR.MgNurWardI("Typ",hsdr," "_typ,CtLocDr,rw)) q:rw=""  d
		..s a=##class(DHCMGNUR.MgNurWard).%OpenId(rw)
		..s st=a.SortPos
		..//w !,st,",",sort,",",oldpos
		..if ((st'>sort)&(st>oldpos)) d
		...s a.SortPos=st-1
		...d a.%Save()

	}
	 b ///ggg
	 s a=##class(DHCMGNUR.MgNurWard).%OpenId(crw)
	 s a.SortPos=sort
	 d a.%Save()

	q 0
}

ClassMethod Save(typ, locstr) As %String
{
	s l=$L(locstr,"^")
	s HsDr=1
	s typ=$TR($ZConvert(typ,"U")," ","")
	s count=0
	 s loc="" f  s loc=$O(^DHCMGNUR.MgNurWardI("Typ",HsDr," "_typ,loc)) q:loc=""  d
	 .s count=count+1
	for i=1:1:l
	{
	  s loc=$P(locstr,"^",i)
	  if loc="" continue
	  if '$D(^DHCMGNUR.MgNurWardI("Typ",HsDr," "_typ,loc))
	  {
	     s a=##class(DHCMGNUR.MgNurWard).%New()
	     s a.HsDr=HsDr
	     s a.WardLoc=loc
	     s a.LocTyp=typ
	     s count=count+1
	     s a.SortPos=count
	     d a.%Save()
	  }
	}
}

Storage Default
{
<Data name="MgNurWardDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LocTyp</Value>
</Value>
<Value name="3">
<Value>WardLoc</Value>
</Value>
<Value name="4">
<Value>SortPos</Value>
</Value>
<Value name="5">
<Value>HsDr</Value>
</Value>
</Data>
<DataLocation>^DHCMGNUR.MgNurWardD</DataLocation>
<DefaultData>MgNurWardDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMGNUR.MgNurWardD</IdLocation>
<IndexLocation>^DHCMGNUR.MgNurWardI</IndexLocation>
<StreamLocation>^DHCMGNUR.MgNurWardS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
