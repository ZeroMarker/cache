Class User.DHCNURMenuFilter Extends %Persistent
{

Property Loc As %String(TRUNCATE = 1);

Property Code As %String(TRUNCATE = 1);

//模板名称

Property Name As %String(TRUNCATE = 1);

//是否显示

Property Ifshow As %String(TRUNCATE = 1);

Index Loc On (Loc, Code);

ClassMethod Save(parr As %String, rw As %String) As %String
{
	s par=""
	//s ^objcyf212=parr
	s loc=$p(parr,"^",1)       //科室
	s Code=$p(parr,"^",2)      //EmrCode
	s name=$p(parr,"^",3)      //名称
	s ifshow=$p(parr,"^",4)    //是否显示
	s Code=$ZConvert(Code,"U")
	i rw=""
	{
      s a=##class(User.DHCNURMenuFilter).%New()
      s a.Loc=loc
	  s a.Code=Code
	  s a.Name=name
	  s a.Ifshow=ifshow
	  d a.%Save()
	}
	else
	{
      s a=##class(User.DHCNURMenuFilter).%OpenId(rw)
      s a.Loc=loc
	  s a.Code=Code
	  s a.Name=name
	  s a.Ifshow=ifshow
	  d a.%Save()
		
	}
	q 0
}

Storage Default
{
<Data name="DHCNURMenuFilterDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Loc</Value>
</Value>
<Value name="3">
<Value>Code</Value>
</Value>
<Value name="4">
<Value>Name</Value>
</Value>
<Value name="5">
<Value>Ifshow</Value>
</Value>
</Data>
<DataLocation>^User.DHCNURMenuFilterD</DataLocation>
<DefaultData>DHCNURMenuFilterDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCNURMenuFilterD</IdLocation>
<IndexLocation>^User.DHCNURMenuFilterI</IndexLocation>
<StreamLocation>^User.DHCNURMenuFilterS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
