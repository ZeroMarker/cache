Class User.DHCMGPersonArrMem Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

//备注

Property ARRPerDR As %String(TRUNCATE = 1);

Property ARRDepDR As %String(TRUNCATE = 1);

Property ARRDate As %Library.Date(FORMAT = 1);

Property ARRMem1 As %String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0);

Property ARRMem2 As %String(TRUNCATE = 1);

Index PersonDate On (ARRPerDR, ARRDate);

Index DepDate On (ARRDepDR, ARRDate);

ClassMethod del(per) As %String
{
 //d ##class(User.DHCMGPersonArrMem).del(per)
	s per=" "_per
	s date="" f  s date=$O(^User.DHCMGPersonArrMemI("PersonDate",per,date)) q:date=""  d
	.s rw=""  f  s rw=$O(^User.DHCMGPersonArrMemI("PersonDate",per,date,rw)) q:rw=""  d
	..d ##class(User.DHCMGPersonArrMem).%DeleteId(rw)
	q 0
}

ClassMethod deldep(dep) As %String
{
 //d ##class(User.DHCMGPersonArrMem).del(per)
	s dep=" "_dep
	s date="" f  s date=$O(^User.DHCMGPersonArrMemI("DepDate",dep,date)) q:date=""  d
	.s rw=""  f  s rw=$O(^User.DHCMGPersonArrMemI("DepDate",dep,date,rw)) q:rw=""  d
	..d ##class(User.DHCMGPersonArrMem).%DeleteId(rw)
	q 0
}

ClassMethod savedepmem(dep, date, mem) As %String
{
 //d ##class(User.DHCMGPersonArrMem).savedepmem()
       s oldmem=##class(User.DHCMGPersonArrange).getdeparrmem(dep,date)
	   if mem=""
	   {
	     d ##class(User.DHCMGPersonArrMem).deldep(dep)
	     q ""
	   }
	   if (oldmem'=mem)
	   {
		   s date=$ZDH(date,3)
	       s a=##class(User.DHCMGPersonArrMem).%New()
	       s a.ARRDepDR=dep
	       s a.ARRDate=date
	       s a.ARRMem1=mem
	       d a.%Save()
	   }
    q ""
}

ClassMethod deldate(per, curdate) As %String
{
 	//d ##class(User.DHCMGPersonArrMem).deldate(per,curdate)
	s per=" "_per
	s rw=""  f  s rw=$O(^User.DHCMGPersonArrMemI("PersonDate",per,curdate,rw)) q:rw=""  d
	.d ##class(User.DHCMGPersonArrMem).%DeleteId(rw)
	q 0
}

Storage Default
{
<Data name="DHCMGPersonArrMemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ARRDate</Value>
</Value>
<Value name="3">
<Value>ARRMem1</Value>
</Value>
<Value name="4">
<Value>ARRMem2</Value>
</Value>
<Value name="5">
<Value>ARRPerDR</Value>
</Value>
<Value name="6">
<Value>ARRDepDR</Value>
</Value>
</Data>
<DataLocation>^User.DHCMGPersonArrMemD</DataLocation>
<DefaultData>DHCMGPersonArrMemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMGPersonArrMemD</IdLocation>
<IndexLocation>^User.DHCMGPersonArrMemI</IndexLocation>
<StreamLocation>^User.DHCMGPersonArrMemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
