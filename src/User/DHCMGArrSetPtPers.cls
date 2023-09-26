Class User.DHCMGArrSetPtPers Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property SetDepDR As %String(TRUNCATE = 1);

Property SetPostDR As %String(TRUNCATE = 1);

//对应的人

Property SetPostPersonDR As %String(TRUNCATE = 1);

Index DepPost On (SetDepDR, SetPostDR);

ClassMethod saveptper(parr As %String) As %String
{
   //保存岗位对应的人
  // s parr="1079^3^69|"
	s dep=$P(parr,"^")
	s post=$P(parr,"^",2)
	s personstr=$P(parr,"^",3)
	s rw="" f  s rw=$O(^User.DHCMGArrSetPtPersI("DepPost"," "_dep," "_post,rw)) q:rw=""  d
     .d ##class(User.DHCMGArrSetPtPers).%DeleteId(rw)

   if (personstr'="")
   {
      s n=$L(personstr,"|")
      for i=1:1:n
      {
	     s per=$P(personstr,"|",i)
	     if per="" continue
	     s a=##class(User.DHCMGArrSetPtPers).%New()
	     s a.SetPostDR=post
	     s a.SetPostPersonDR=per  
	     s a.SetDepDR=dep
	     d a.%Save()
	  }
   }
   q 0
}

Storage Default
{
<Data name="DHCMGArrSetPtPersDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SetPostDR</Value>
</Value>
<Value name="3">
<Value>SetPostPersonDR</Value>
</Value>
<Value name="4">
<Value>SetDepDR</Value>
</Value>
</Data>
<DataLocation>^User.DHCMGArrSetPtPersD</DataLocation>
<DefaultData>DHCMGArrSetPtPersDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMGArrSetPtPersD</IdLocation>
<IndexLocation>^User.DHCMGArrSetPtPersI</IndexLocation>
<StreamLocation>^User.DHCMGArrSetPtPersS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
