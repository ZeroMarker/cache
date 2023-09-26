Class User.DHCMGCCode Extends %Persistent [ ClassType = persistent, ProcedureBlock, SqlTableName = DHCMGC_Code ]
{

/// 代码维护
Property MgCodeTyp As User.DHCMGCodeTyp;

Property MgCodeDesc As %String(TRUNCATE = 1);

Property MgCodeCode As %String(TRUNCATE = 1);

Property MgCodeColor As %String(TRUNCATE = 1);

Property MgCodeStDate As %Library.Date(FORMAT = 1);

Property MgCodeEdDate As %Library.Date(FORMAT = 1);

Index Typ On MgCodeTyp;

ClassMethod getcodedr(code, typ) As %String
{
 //##class(User.DHCMGCodeTyp).getcodedr("")
  //##class(User.DHCMGCCode).getcodedr("")

  s typdr=##class(User.DHCMGCodeTyp).getcodedr(typ)
  q:typdr="" ""
  s codedr=""
  s rw=""  f  s rw=$O(^User.DHCMGCCodeI("Typ",typdr,rw)) q:(rw="")!(codedr'="")  d
  .s a=^User.DHCMGCCodeD(rw)
  .s des=$list(a,3)
  .if des=code s codedr=rw
  q codedr
}

ClassMethod Save(parr As %String) As %String
{
  // s parr="^1^首都医科大学^首都医科大学^2009-03-12^"
   s id=$P(parr,"^",1)
   s Typ=$P(parr,"^",2)
   s code=$P(parr,"^",3)
   s desc=$P(parr,"^",4)
   s stdate=$P(parr,"^",5)
   s edate=$P(parr,"^",6)
   if id'="" s a=##class(User.DHCMGCCode).%OpenId(id)
   e  s a=##class(User.DHCMGCCode).%New()
   s a.MgCodeTyp=##class(User.DHCMGCodeTyp).%OpenId(Typ)
   s a.MgCodeDesc=desc
   s a.MgCodeCode=code
   s a.MgCodeStDate=$ZDH(stdate,3)
   if edate'="" s a.MgCodeEdDate=$ZDH(edate,3)
   d a.%Save()
   q 0
}

ClassMethod SaveColor(id, colorstr) As %String
{
 //人员类别颜色设置
	if id'=""
	{
	  s a=##class(User.DHCMGCCode).%OpenId(id)
      s a.MgCodeColor=colorstr
      d a.%Save()
     q 0
	}
	q 1
}

ClassMethod GetPertypColor(id) As %String
{
 //取人员类别颜色
 //s a##class(User.DHCMGCCode).GetPertypColor(43)
	s ret=""
   	if id'=""
	{
	 // s a=##class(User.DHCMGCCode).%OpenId(id)
     // s ret=$G(a.MgCodeColor)
      s a=^User.DHCMGCCodeD(id)
      s ret=$listGet(a,7)
	}
	q ret
}

Storage Default
{
<Data name="DHCMGCCodeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MgCodeCode</Value>
</Value>
<Value name="3">
<Value>MgCodeDesc</Value>
</Value>
<Value name="4">
<Value>MgCodeEdDate</Value>
</Value>
<Value name="5">
<Value>MgCodeStDate</Value>
</Value>
<Value name="6">
<Value>MgCodeTyp</Value>
</Value>
<Value name="7">
<Value>MgCodeColor</Value>
</Value>
</Data>
<DataLocation>^User.DHCMGCCodeD</DataLocation>
<DefaultData>DHCMGCCodeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMGCCodeD</IdLocation>
<IndexLocation>^User.DHCMGCCodeI</IndexLocation>
<StreamLocation>^User.DHCMGCCodeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
