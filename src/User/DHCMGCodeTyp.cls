Class User.DHCMGCodeTyp Extends %Persistent [ ClassType = persistent, ProcedureBlock, SqlTableName = DHCMG_CodeTyp ]
{

Property TypCode As %String(TRUNCATE = 1);

Property TypDesc As %String(TRUNCATE = 1);

ClassMethod getcodedr(typ) As %String
{
 //s a=##class(User.DHCMGCodeTyp).getcodedr("")
   s codedr=""
   s rw="" f  s rw=$O(^User.DHCMGCodeTypD(rw)) q:(rw="")!(codedr'="")  d
   .s a=^User.DHCMGCodeTypD(rw)
   .s code=$List(a,2)
   .if code=typ s codedr=rw
   q codedr
}

ClassMethod Save(Parr As %String) As %String
{
   s id=$P(Parr,"^",1)
   s typ=$P(Parr,"^",2)
   s des=$P(Parr,"^",3)
   if id'="" s a=##class(User.DHCMGCodeTyp).%OpenId(id)
   e  s a=##class(User.DHCMGCodeTyp).%New()
   s a.TypCode=typ
   s a.TypDesc=des
   d a.%Save()
   q 0
}

Storage Default
{
<Data name="DHCMGCodeTypDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TypCode</Value>
</Value>
<Value name="3">
<Value>TypDesc</Value>
</Value>
</Data>
<DataLocation>^User.DHCMGCodeTypD</DataLocation>
<DefaultData>DHCMGCodeTypDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMGCodeTypD</IdLocation>
<IndexLocation>^User.DHCMGCodeTypI</IndexLocation>
<StreamLocation>^User.DHCMGCodeTypS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
