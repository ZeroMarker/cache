Class User.DHCMGCHolWorkAge Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

//假期天数设定

Property LevelHol As User.DHCMGCHoliday;

Property LevelNum As %String(TRUNCATE = 1);

Property LevelDays As %String(TRUNCATE = 1);

Index typ On LevelHol;

ClassMethod getval(workyears) As %String
{
 //s a=##class(User.DHCMGCHolWorkAge).getval()
   s hdays=0
   s h=""  f  s h=$O(^User.DHCMGCHolWorkAgeI("typ",h)) q:h=""  d
   .s rw=""  f  s rw=$O(^User.DHCMGCHolWorkAgeI("typ",h,rw)) q:rw=""  d
   ..s level=$List(^User.DHCMGCHolWorkAgeD(rw),3)
   ..s days=$List(^User.DHCMGCHolWorkAgeD(rw),4)
   ..if workyears'<level d
   ...if $D(HH(h)) d
   ....if HH(h)<days s HH(h)=days
   ...e  s HH(h)=days
   s h="" f  s h=$O(HH(h)) q:h=""  d
   .s hdays=hdays+HH(h)
   q hdays
}

ClassMethod save(parr As %String) As %String
{
  //s parr="^4^5^5"
  s id=$P(parr,"^",1)
  s hol=$P(parr,"^",2)
  s level=$P(parr,"^",3)
  s days=$P(parr,"^",4)
  if id'="" s a=##class(User.DHCMGCHolWorkAge).%OpenId(id)
  e  s a=##class(User.DHCMGCHolWorkAge).%New()
  s a.LevelHol=##class(User.DHCMGCHoliday).%OpenId(hol)
  s a.LevelNum=level
  s a.LevelDays=days
  d a.%Save()
  q 0
}

ClassMethod del(id) As %String
{
   d ##class(User.DHCMGCHolWorkAge).%DeleteId(id)
   q 0
}

Storage Default
{
<Data name="DHCMGCHolWorkAgeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LevelHol</Value>
</Value>
<Value name="3">
<Value>LevelNum</Value>
</Value>
<Value name="4">
<Value>LevelDays</Value>
</Value>
</Data>
<DataLocation>^User.DHCMGCHolWorkAgeD</DataLocation>
<DefaultData>DHCMGCHolWorkAgeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMGCHolWorkAgeD</IdLocation>
<IndexLocation>^User.DHCMGCHolWorkAgeI</IndexLocation>
<StreamLocation>^User.DHCMGCHolWorkAgeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
