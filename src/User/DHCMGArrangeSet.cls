Class User.DHCMGArrangeSet Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property SetDepDR As %String(TRUNCATE = 1);

Property SetTyp As %Library.String(DISPLAYLIST = ",Fix,Duty,LZ,Grp", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",F,D,L,G");

Property SetFromDate As %Library.Date(FORMAT = 1);

Property SetEndDate As %Library.Date(FORMAT = 1);

Index DepTyp On (SetDepDR, SetTyp);

//Index DepTyp On (SetDepDR, SetTyp);

ClassMethod SaveArrSet(parr As %String) As %String
{
   //s id=$P(parr,"^",1)
   //s parr="^1079^3|9|10|11|^69|186|266|367|^F^2009-02-14^2009-02-28"
   s Dep=$P(parr,"^",2)
   s Post=$P(parr,"^",3)
   s pers=$P(parr,"^",4)
   s Typ=$P(parr,"^",5)
   s fdate=$P(parr,"^",6)
   s edate=$P(parr,"^",7)
   s id="" s id=$O(^User.DHCMGArrangeSetI("DepTyp"," "_Dep," "_Typ,id))
   if id=""  s a=##class(User.DHCMGArrangeSet).%New()
   e  s a=##class(User.DHCMGArrangeSet).%OpenId(id)
   s a.SetDepDR=Dep
   s a.SetTyp=Typ
   s a.SetFromDate=$ZDH(fdate,3)
   s a.SetEndDate=$ZDH(edate,3)
   d a.%Save()
   if (id'="")
   {
   s rw="" f  s rw=$O(^User.DHCMGArrangePostPersonI("SetArr",id,rw)) q:rw=""  d
   .d ##class(User.DHCMGArrangePostPerson).%DeleteId(rw)
   .b
   }
   s setstr=##class(User.DHCMGArrangePostPerson).SavePostPerSet(a,pers,Post)
   q 0
}

Storage Default
{
<Data name="DHCMGArrangeSetDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SetDep</Value>
</Value>
<Value name="3">
<Value>SetEndDate</Value>
</Value>
<Value name="4">
<Value>SetFromDate</Value>
</Value>
<Value name="5">
<Value>SetPostDr</Value>
</Value>
<Value name="6">
<Value>SetTyp</Value>
</Value>
<Value name="7">
<Value>SetDepDR</Value>
</Value>
<Value name="8">
<Value>SetPostDR</Value>
</Value>
</Data>
<DataLocation>^User.DHCMGArrangeSetD</DataLocation>
<DefaultData>DHCMGArrangeSetDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMGArrangeSetD</IdLocation>
<IndexLocation>^User.DHCMGArrangeSetI</IndexLocation>
<StreamLocation>^User.DHCMGArrangeSetS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
