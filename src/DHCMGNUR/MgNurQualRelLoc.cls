Class DHCMGNUR.MgNurQualRelLoc Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property HsDr As %Integer;

Property LocTyp As %String(TRUNCATE = 1);

Property WardLoc As %Integer;

Property QualItm As %Integer;

Property SortPos As %Integer;

Index Typ On (HsDr, LocTyp, QualItm);

ClassMethod delpos(hsdr, typ, Qual) As %String
{
  	s typ=$TR($ZConvert(typ,"U")," ","")
  	
	s count=0
	s rw=""  s rw=$O(^DHCMGNUR.MgNurQualRelLocI("Typ",hsdr," "_typ,Qual,rw))
	b //loc
 	if rw="" q 0
	 s a=##class(DHCMGNUR.MgNurQualRelLoc).%OpenId(rw)
	 s crw=rw
	 s oldpos=a.SortPos
	 s qudr="" f  s qudr=$O(^DHCMGNUR.MgNurQualRelLocI("Typ",hsdr," "_typ,qudr)) q:qudr=""  d
	    .s rw="" f  s rw=$O(^DHCMGNUR.MgNurQualRelLocI("Typ",hsdr," "_typ,qudr,rw)) q:rw=""  d
		..s a=##class(DHCMGNUR.MgNurQualRelLoc).%OpenId(rw)
		..s st=a.SortPos
		..if ((st>oldpos)) d
		...s a.SortPos=st-1
		...d a.%Save()
   d ##class(DHCMGNUR.MgNurQualRelLoc).%DeleteId(crw)
   q 0
}

ClassMethod getselloc(hsdr, typ)
{
 //s r=##class(DHCMGNUR.MgNurQualRelLoc).getselloc
  	 s ret=""
  	 s typ=$TR($ZConvert(typ,"U")," ","")
  	 s qudr="" f  s qudr=$O(^DHCMGNUR.MgNurQualRelLocI("Typ",hsdr," "_typ,qudr)) q:qudr=""  d
  	 .s ret=ret_qudr_"^"
  	 q ret
}

ClassMethod SavePos(hsdr, typ, qual, sort) As %String
{
 //s r=##class(DHCMGNUR.MgNurQualRelLoc).SavePos()
    s ^TMP("loc")=$LB(hsdr,typ,qual,sort)
  	s typ=$TR($ZConvert(typ,"U")," ","")
  	
	s count=0
	s rw=""  s rw=$O(^DHCMGNUR.MgNurQualRelLocI("Typ",hsdr," "_typ,qual,rw))
	b //loc
 	if rw="" q 0
	 s a=##class(DHCMGNUR.MgNurQualRelLoc).%OpenId(rw)
	 s crw=rw
	 s oldpos=a.SortPos
	 b //
    if (oldpos>sort) 
    { //加1 '<sort  && <oldpos
        b  // //值变小，往前移
	   s qudr="" f  s qudr=$O(^DHCMGNUR.MgNurQualRelLocI("Typ",hsdr," "_typ,qudr)) q:qudr=""  d
	    .s rw="" f  s rw=$O(^DHCMGNUR.MgNurQualRelLocI("Typ",hsdr," "_typ,qudr,rw)) q:rw=""  d
		..s a=##class(DHCMGNUR.MgNurQualRelLoc).%OpenId(rw)
		..s st=a.SortPos
		..//w !,st,",",sort,",",oldpos
		..if ((st'<sort)&(st<oldpos)) d
		...b //sort
		...s a.SortPos=st+1
		...d a.%Save()

	}
    if (oldpos<sort)  //值变大，往后移
    { //减1 >oldpos && '>sort
	   s qudr="" f  s qudr=$O(^DHCMGNUR.MgNurQualRelLocI("Typ",hsdr," "_typ,qudr)) q:qudr=""  d
	    .s rw="" f  s rw=$O(^DHCMGNUR.MgNurQualRelLocI("Typ",hsdr," "_typ,qudr,rw)) q:rw=""  d
		..s a=##class(DHCMGNUR.MgNurQualRelLoc).%OpenId(rw)
		..s st=a.SortPos
		..//w !,st,",",sort,",",oldpos
		..if ((st'>sort)&(st>oldpos)) d
		...s a.SortPos=st-1
		...d a.%Save()

	}
	 b ///ggg
	 s a=##class(DHCMGNUR.MgNurQualRelLoc).%OpenId(crw)
	 s a.SortPos=sort
	 d a.%Save()

	q 0
}

ClassMethod Save(typ, qustr) As %String
{
  //
	s l=$L(qustr,"^")
	s HsDr=1
	s typ=$TR($ZConvert(typ,"U")," ","")
	s count=0
	 s qudr="" f  s qudr=$O(^DHCMGNUR.MgNurQualRelLocI("Typ",HsDr," "_typ,qudr)) q:qudr=""  d
	 .s count=count+1
	for i=1:1:l
	{
	  s qudr=$P(qustr,"^",i)
	  if qudr="" continue
	  if '$D(^DHCMGNUR.MgNurQualRelLocI("Typ",HsDr," "_typ,qudr))
	  {
	     s a=##class(DHCMGNUR.MgNurQualRelLoc).%New()
	     s a.HsDr=HsDr
	     s a.QualItm=qudr
	     s a.LocTyp=typ
	     s count=count+1
	     s a.SortPos=count
	     d a.%Save()
	  }
	}
}

Storage Default
{
<Data name="MgNurQualRelLocDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>HsDr</Value>
</Value>
<Value name="3">
<Value>LocTyp</Value>
</Value>
<Value name="4">
<Value>WardLoc</Value>
</Value>
<Value name="5">
<Value>QualItm</Value>
</Value>
<Value name="6">
<Value>SortPos</Value>
</Value>
</Data>
<DataLocation>^DHCMGNUR.MgNurQualRelLocD</DataLocation>
<DefaultData>MgNurQualRelLocDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMGNUR.MgNurQualRelLocD</IdLocation>
<IndexLocation>^DHCMGNUR.MgNurQualRelLocI</IndexLocation>
<StreamLocation>^DHCMGNUR.MgNurQualRelLocS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
