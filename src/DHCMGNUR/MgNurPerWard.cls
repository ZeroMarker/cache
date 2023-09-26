Class DHCMGNUR.MgNurPerWard Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 护理单元Code
Property WardLoc As %Integer [ SqlColumnNumber = 2 ];

/// 护理单元描述
Property WardDesc As %String(TRUNCATE = 1) [ SqlColumnNumber = 3 ];

Property Exegesis As %String(TRUNCATE = 1) [ SqlColumnNumber = 4 ];

/// 序号
Property WardOrd As %Integer [ SqlColumnNumber = 5 ];

Index WardLoc On WardLoc;

Index WardOrd On WardOrd;

Index WardRow On (WardOrd, WardLoc);

ClassMethod Save(parr As %String) As %String
{
	s ^TMPCE("parr")=parr
	s l=$L(parr,"^")
	s count=0
	s loc="" f  s loc=$O(^DHCMGNUR.MgNurPerWardI("WardLoc",loc)) q:loc=""  d
	.s count=count+1
	f i=1:1:l d
	.s loc=$P(parr,"^",i)
	.;s id=$O(^DHCMGNUR.MgNurPerWardI("WardLoc",loc))
	.b ;01
	.i '$D(^DHCMGNUR.MgNurPerWardI("WardLoc",loc))  d
	..s a=##class(DHCMGNUR.MgNurPerWard).%New()
	..s a.WardLoc=loc
	..s a.WardDesc=$P(^CTLOC(loc),"^",2)
	..s count=count+1
	..s a.WardOrd=count
	..d a.%Save()
}

ClassMethod delete(loc As %String) As %String
{
	s count=0
	s rw="" s rw=$O(^DHCMGNUR.MgNurPerWardI("WardLoc",loc,rw))
	i rw="" q 0
	s a=##class(DHCMGNUR.MgNurPerWard).%OpenId(rw)
	s crw=rw
	s oldpos=a.WardOrd
	s CtLocDr="" f  s CtLocDr=$O(^DHCMGNUR.MgNurPerWardI("WardLoc",CtLocDr)) q:CtLocDr=""  d
	.s rw="" f  s rw=$O(^DHCMGNUR.MgNurPerWardI("WardLoc",CtLocDr,rw)) q:rw=""  d
	..s a=##class(DHCMGNUR.MgNurPerWard).%OpenId(rw)
	..s st=a.WardOrd
	..i (st>oldpos) d
	...s a.WardOrd=st-1
	...d a.%Save()
	d ##class(DHCMGNUR.MgNurPerWard).%DeleteId(crw)
	q 0
}

ClassMethod SavePos(loc, sort As %String) As %String
{
	s rw="" s rw=$O(^DHCMGNUR.MgNurPerWardI("WardLoc",loc,rw))
	i rw="" q 0
	s a=##class(DHCMGNUR.MgNurPerWard).%OpenId(rw)
	s crw=rw
	s oldpos=a.WardOrd
	s ^TEMP0012=oldpos
	i (oldpos>sort)
	{
		s CtLocDr="" f  s CtLocDr=$O(^DHCMGNUR.MgNurPerWardI("WardLoc",CtLocDr)) q:CtLocDr=""  d
		.s rw="" f  s rw=$O(^DHCMGNUR.MgNurPerWardI("WardLoc",CtLocDr,rw)) q:rw=""  d
		..s a=##class(DHCMGNUR.MgNurPerWard).%OpenId(rw)
		..s st=a.WardOrd
		..i ((st'<sort)&(st<oldpos)) d
		...s a.WardOrd=st+1
		...d a.%Save()
	}
	i (oldpos<sort)
	{
		s CtLocDr="" f  s CtLocDr=$O(^DHCMGNUR.MgNurPerWardI("WardLoc",CtLocDr)) q:CtLocDr=""  d
		.s rw="" f  s rw=$O(^DHCMGNUR.MgNurPerWardI("WardLoc",CtLocDr,rw)) q:rw=""  d
		..s a=##class(DHCMGNUR.MgNurPerWard).%OpenId(rw)
		..s st=a.WardOrd
		..i ((st'>sort)&(st>oldpos)) d
		...s a.WardOrd=st-1
		...d a.%Save()
	}
	s a=##class(DHCMGNUR.MgNurPerWard).%OpenId(crw)
	s a.WardOrd=sort
	d a.%Save()
	q 0
}

Storage Default
{
<Data name="MgNurPerWardDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WardLoc</Value>
</Value>
<Value name="3">
<Value>WardDesc</Value>
</Value>
<Value name="4">
<Value>exegesis</Value>
</Value>
<Value name="5">
<Value>Exegesis</Value>
</Value>
<Value name="6">
<Value>WardOrd</Value>
</Value>
</Data>
<DataLocation>^DHCMGNUR.MgNurPerWardD</DataLocation>
<DefaultData>MgNurPerWardDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMGNUR.MgNurPerWardD</IdLocation>
<IndexLocation>^DHCMGNUR.MgNurPerWardI</IndexLocation>
<StreamLocation>^DHCMGNUR.MgNurPerWardS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
