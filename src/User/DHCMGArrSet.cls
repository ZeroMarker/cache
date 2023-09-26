Class User.DHCMGArrSet Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

//岗位顺序

Property ArrDepDr As %String(TRUNCATE = 1);

Property ArrTyp As %Library.String(DISPLAYLIST = ",Fix,Duty,LZ,Grp", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",F,D,L,G");

Property ArrNo As %String(TRUNCATE = 1);

Property ArrPost As %String(TRUNCATE = 1);

Property ArrPersonNum As %String(TRUNCATE = 1);

Index DepTyp On (ArrDepDr, ArrTyp);

ClassMethod SaveSet(parr As %String) As %String
{
   s id=$P(parr,"^",1)
   s dep=$P(parr,"^",2)
   s typ=$P(parr,"^",3)
   s no=$P(parr,"^",4)
   s post=$P(parr,"^",5)
   s num=$P(parr,"^",6)
   s a=##class(User.DHCMGArrSet).%New()
   s a.ArrDepDr=dep
   s a.ArrTyp=typ
   s a.ArrNo=no
   s a.ArrPost=post
   s a.ArrPersonNum=num
   d a.%Save()
   q 0
}

ClassMethod Delid(id As %String) As %String
{
	 d ##class(User.DHCMGArrSet).%DeleteId(id)
	 q 0
}

Storage Default
{
<Data name="DHCMGArrSetDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ArrDepDr</Value>
</Value>
<Value name="3">
<Value>ArrNo</Value>
</Value>
<Value name="4">
<Value>ArrPersonNum</Value>
</Value>
<Value name="5">
<Value>ArrPost</Value>
</Value>
<Value name="6">
<Value>ArrTyp</Value>
</Value>
</Data>
<DataLocation>^User.DHCMGArrSetD</DataLocation>
<DefaultData>DHCMGArrSetDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMGArrSetD</IdLocation>
<IndexLocation>^User.DHCMGArrSetI</IndexLocation>
<StreamLocation>^User.DHCMGArrSetS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
