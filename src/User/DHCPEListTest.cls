Class User.DHCPEListTest Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract)
{

Parameter ClassName = "User.DHCPEListTest";

Property LTTest As list Of %String;

/// d ##class(User.DHCPEListTest).Out()
ClassMethod Out()
{
	s aa=$LG(^User.DHCPEListTestD(6),2)
	s aaLength=$LL(aa)
	f i=1:1:aaLength d
	.s bb=$LG(aa,i)
	.s bbLength=$LL(bb)
	.f j=1:1:bbLength d
	..w i_","_j_":"_$LG(bb,j),!
	q
}

/// d ##class(User.DHCPEListTest).Save()
ClassMethod Save()
{
	s obj=##class(User.DHCPEListTest).%New()
	d obj.LTTest.Clear()
	s aa=$LB("aaa","bbb")
	d obj.LTTest.Insert(aa)
	s bb=$LB("ccc","ddd")
	d obj.LTTest.Insert(bb)
	d obj.%Save()
}

Storage Default
{
<Data name="DHCPEListTestDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LTTest</Value>
</Value>
<Value name="3">
<Value>LT</Value>
</Value>
</Data>
<DataLocation>^User.DHCPEListTestD</DataLocation>
<DefaultData>DHCPEListTestDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCPEListTestD</IdLocation>
<IndexLocation>^User.DHCPEListTestI</IndexLocation>
<StreamLocation>^User.DHCPEListTestS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
