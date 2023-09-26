Class User.DHCMGArrSystemSet Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

//产妇每天工作时间

Property SuckleWoman As %String(TRUNCATE = 1);

// 正常人每天工作时间

Property NaturalMan As %String(TRUNCATE = 1);

//正常人每周工作几天

Property NaturalManWorkDays As %String(TRUNCATE = 1);

//班次冻结日期

Property PostFreezeDate As %String(TRUNCATE = 1);

Property FilePath As %String(TRUNCATE = 1);

ClassMethod Save(parr As %String) As %String
{
	s id=$P(parr,"^",1)
	s Suckle=$P(parr,"^",2)
	s Natural=$P(parr,"^",3)
	s Days=$P(parr,"^",4)
	s Freeze=$P(parr,"^",5)
	s path=$P(parr,"^",6)
	if id'="" s a=##class(User.DHCMGArrSystemSet).%OpenId(id)
	e  s a=##class(User.DHCMGArrSystemSet).%New()
	s a.SuckleWoman=Suckle
	s a.NaturalMan=Natural
	s a.NaturalManWorkDays=Days
	s a.PostFreezeDate=Freeze
	s a.FilePath=path
	d a.%Save()
	q 0
}

ClassMethod getset() As %String
{
  //##class(User.DHCMGArrSystemSet).getset()
   s ret=""
   s rw="" f  s rw=$O(^User.DHCMGArrSystemSetD(rw)) q:rw=""  d
   .s a=^User.DHCMGArrSystemSetD(rw)
   .s suckle=$List(a,5)
   .s natural=$List(a,2)
   .s workdays=$List(a,3)
   .s postfreezedate=$List(a,4)
   .s path=$List(a,6)
   .s ret=rw_"^"_suckle_"^"_natural_"^"_workdays_"^"_postfreezedate_"^"_path
   q ret
}

Storage Default
{
<Data name="DHCMGArrSystemSetDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>NaturalMan</Value>
</Value>
<Value name="3">
<Value>NaturalManWorkDays</Value>
</Value>
<Value name="4">
<Value>PostFreezeDate</Value>
</Value>
<Value name="5">
<Value>SuckleWoman</Value>
</Value>
<Value name="6">
<Value>FilePath</Value>
</Value>
</Data>
<DataLocation>^User.DHCMGArrSystemSetD</DataLocation>
<DefaultData>DHCMGArrSystemSetDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMGArrSystemSetD</IdLocation>
<IndexLocation>^User.DHCMGArrSystemSetI</IndexLocation>
<StreamLocation>^User.DHCMGArrSystemSetS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
