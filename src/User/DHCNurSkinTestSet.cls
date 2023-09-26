Class User.DHCNurSkinTestSet Extends %Persistent
{

Property ArcimDr As %String(TRUNCATE = 1);

Property ObserveTime As %String(TRUNCATE = 1);

Property TestMethod As %String(TRUNCATE = 1);

Index ArcimDr On ArcimDr;

ClassMethod Save(parr As %String) As %String
{
	//w ##class(User.DHCNurSkinTestSet).Save("3^17||1^222分钟^皮内试验法")
	s id=$P(parr,"^",1)
	s ArcimDr=$P(parr,"^",2)
	s ObserveTime=$P(parr,"^",3)
	s TestMethod=$P(parr,"^",4)
	if $G(ArcimDr)="" q "请选择一条医嘱!"
	if $G(id)'="" {
		s a=##class(User.DHCNurSkinTestSet).%OpenId(id)
	}
	else {
		s ArcimInfo=..GetInfoByArcimDr($G(ArcimDr))
		if ArcimInfo'="" q "医嘱项已存在!"
		s a=##class(User.DHCNurSkinTestSet).%New()
	}
	s a.ArcimDr=ArcimDr
	s a.ObserveTime=ObserveTime
	s a.TestMethod=TestMethod		
	d a.%Save()
	//q a.%Id()
	q 0
}

/// 判断医嘱项是否维护过,是返回观察时间^皮试方法,否则返回空
ClassMethod GetInfoByArcimDr(ArcimDr) As %String
{
	if $G(ArcimDr)="" q ""
	s curId=$O(^User.DHCNurSkinTestSetI("ArcimDr"," "_$G(ArcimDr),""))
	if curId="" q ""
	s ObserveTime=$ListGet(^User.DHCNurSkinTestSetD(curId),3)
	s TestMethod=$ListGet(^User.DHCNurSkinTestSetD(curId),4)
	q ObserveTime_"^"_TestMethod
}

/// 撤销记录
ClassMethod Delete(id) As %String
{
	q:id="" 0
	d ##class(User.DHCNurSkinTestSet).%DeleteId(id)
	q 0
}

Storage Default
{
<Data name="DHCNurSkinTestSetDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ArcimDr</Value>
</Value>
<Value name="3">
<Value>ObserveTime</Value>
</Value>
<Value name="4">
<Value>TestMethod</Value>
</Value>
</Data>
<DataLocation>^User.DHCNurSkinTestSetD</DataLocation>
<DefaultData>DHCNurSkinTestSetDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCNurSkinTestSetD</IdLocation>
<IndexLocation>^User.DHCNurSkinTestSetI</IndexLocation>
<StreamLocation>^User.DHCNurSkinTestSetS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
