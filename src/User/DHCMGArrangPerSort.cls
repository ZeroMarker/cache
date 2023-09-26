Class User.DHCMGArrangPerSort Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

//排班表位置

Property SetPersonDR As %String(TRUNCATE = 1);

Property SetPersonSort As %String(TRUNCATE = 1);

Property SetDepDR As %String(TRUNCATE = 1);

Property SetDepSort As %String(TRUNCATE = 1);

Property SetTyp As %String(TRUNCATE = 1);

Property PersonDep As %String(TRUNCATE = 1);

Index Person On SetPersonDR;

Index Dep On SetDepDR;

Index Typ On SetTyp;

Index TypDep On (SetTyp, SetDepDR);

Index DepPer On (PersonDep, SetPersonDR);

ClassMethod del(dep, perid) As %String
{
  s rw="" s rw=$O(^User.DHCMGArrangPerSortI("DepPer"," "_dep," "_perid,rw))
  if rw'=""  s a=##class(User.DHCMGArrangPerSort).%DeleteId(rw)
  q 0
}

ClassMethod SavePerSort(parr As %String) As %String
{
	s ln=$L(parr,"^")
	f i=1:1:ln
	{
		s itm=$P(parr,"^",i)
		q:itm=""
		s perid=$P(itm,"|",1)
		s sortno=$P(itm,"|",2)
		s dep=$P(itm,"|",3)
		s rw="" s rw=$O(^User.DHCMGArrangPerSortI("DepPer"," "_dep," "_perid,rw))
		if rw="" s persort=##class(User.DHCMGArrangPerSort).%New()
		e  s persort=##class(User.DHCMGArrangPerSort).%OpenId(rw)
		s persort.SetPersonDR=perid
		s persort.SetPersonSort=sortno
		if dep'="" s persort.PersonDep=dep
		d persort.%Save()
	}
	q 0
}

ClassMethod SaveDepSort(parr As %String, Typ As %String) As %String
{
   
  // s ^AA=parr ##class(User.DHCMGArrangPerSort).SaveDepSort
	s ln=$L(parr,"^")
	f i=1:1:ln
	{
		s itm=$P(parr,"^",i)
		q:itm=""
		s dep=$P(itm,"|",1)
		s sortno=$P(itm,"|",2)
		s rw="" s rw=$O(^User.DHCMGArrangPerSortI("TypDep"," "_Typ," "_dep,rw))
		if rw="" s deport=##class(User.DHCMGArrangPerSort).%New()
		e  s deport=##class(User.DHCMGArrangPerSort).%OpenId(rw)
		s deport.SetDepDR=dep
		s deport.SetDepSort=sortno
		s deport.SetTyp=Typ
		d deport.%Save()
		s tmp(dep)=""
	}
	s rw=""  f  s rw=$O(^User.DHCMGArrangPerSortI("Typ"," "_Typ,rw)) q:rw=""  d
	.s loc=$ListGet(^User.DHCMGArrangPerSortD(rw),4)
	.if '$D(tmp(loc))  d ##class(User.DHCMGArrangPerSort).%DeleteId(rw)
	q 0
}

ClassMethod delarrSortByper(per) As %String
{
 //删除自动排班
   s flag=0
   s rw=$o(^User.DHCMGArrangPerSortI("Person"," "_per,""))
   q:rw="" flag
   d ##class(User.DHCMGArrangPerSort).%DeleteId(rw)
   q flag
}

Storage Default
{
<Data name="DHCMGArrangPerSortDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SetPersonDR</Value>
</Value>
<Value name="3">
<Value>SetPersonSort</Value>
</Value>
<Value name="4">
<Value>SetDepDR</Value>
</Value>
<Value name="5">
<Value>SetDepSort</Value>
</Value>
<Value name="6">
<Value>SetTyp</Value>
</Value>
<Value name="7">
<Value>PersonDep</Value>
</Value>
</Data>
<DataLocation>^User.DHCMGArrangPerSortD</DataLocation>
<DefaultData>DHCMGArrangPerSortDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMGArrangPerSortD</IdLocation>
<IndexLocation>^User.DHCMGArrangPerSortI</IndexLocation>
<StreamLocation>^User.DHCMGArrangPerSortS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
