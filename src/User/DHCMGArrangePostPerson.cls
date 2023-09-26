Class User.DHCMGArrangePostPerson Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

//对应的人

Property SetSetDr As User.DHCMGArrangeSet;

Property SetPostDR As %String(TRUNCATE = 1);

Property SetPostPersonDR As %String(TRUNCATE = 1);

Index SetArr On SetSetDr;

ClassMethod SavePostPerSet(SetDr, persostr, poststr) As %String
{
 //保存设置 岗位，人员
   if (persostr'="")
   {
      s n=$L(persostr,"|")
      for i=1:1:n
      {
	     s per=$P(persostr,"|",i)
	     if per="" continue
	     s a=##class(User.DHCMGArrangePostPerson).%New()
	     s a.SetPostPersonDR=per  
	     s a.SetSetDr=SetDr
	     d a.%Save()
	  }
   }
   if (poststr'="")
   {
      s n=$L(poststr,"|")
      for i=1:1:n
      {
	     s post=$P(poststr,"|",i)
	     if post="" continue
	     s a=##class(User.DHCMGArrangePostPerson).%New()
	     s a.SetPostDR=post  
	     s a.SetSetDr=SetDr
	     d a.%Save()
	  }
   }
   q 0
}

Storage Default
{
<Data name="DHCMGArrangePostPersonDefaultData">
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
<Value>SetSetDr</Value>
</Value>
</Data>
<DataLocation>^User.DHCMGArrangePostPersonD</DataLocation>
<DefaultData>DHCMGArrangePostPersonDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMGArrangePostPersonD</IdLocation>
<IndexLocation>^User.DHCMGArrangePostPersonI</IndexLocation>
<StreamLocation>^User.DHCMGArrangePostPersonS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
