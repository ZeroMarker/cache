/// 
/// ClassDescripition:人力资源子集页面控件元素
/// Date:2015-02-11
Class DHCMGNUR.MgChildPagEleSub Extends %Persistent
{

Relationship MenuParref As DHCMGNUR.MgChildPagEle [ Cardinality = parent, Inverse = ChildSub, Required ];

Property ItemTyp As %String(TRUNCATE = 1);

Property ItemDesc As %String(TRUNCATE = 1);

Property ItemCode As %String(TRUNCATE = 1);

Index ItemCode On ItemCode;

ClassMethod Save(parr As %String) As %String
{
	;s ^TEMP("gparr201502121024001")=parr
	//ItemCode|s^ItemDesc|dsdsdsd^ItemTyp|ddds^raw|5__
	s ret=0
	s id=$Tr($P($P(parr,"^",4),"|",2),"__","||")
	i $P(id,"||",2)="" d
	.s obj=##class(DHCMGNUR.MgChildPagEleSub).%New()
	.s obj.MenuParref=##class(DHCMGNUR.MgChildPagEle).%OpenId($P(id,"||",1))
	e  d
	.s obj=##class(DHCMGNUR.MgChildPagEleSub).%OpenId(id)
	s obj.ItemCode=$P($P(parr,"^",1),"|",2)
	s obj.ItemDesc=$P($P(parr,"^",2),"|",2)
	s obj.ItemTyp=$P($P(parr,"^",3),"|",2)
	d obj.%Save()
	s ret=obj.%Id()
	q ret
}

ClassMethod IsExistRec(parr As %String) As %String
{
	s ret=0
	b ;02
	q:parr=""
	;s ^TEMP("g201502121132001")=parr
	;//parr="addNew^5"
	s code=$ZConvert($P(parr,"^",1),"U")
	s rw=$P(parr,"^",2)
	s raw=$Tr($P(parr,"^",3),"__","||")
	b ;01
	s id=$O(^DHCMGNUR.MgChildPagEleSubI("ItemCode"," "_code,rw,""))
	q:id="" 1
	i rw_"||"_id=raw s ret=1
	e  s ret=0
	q ret
}

Storage Default
{
<Data name="MgChildPagEleSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ItemTyp</Value>
</Value>
<Value name="3">
<Value>ItemDesc</Value>
</Value>
<Value name="4">
<Value>ItemCode</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildSub")</DataLocation>
<DefaultData>MgChildPagEleSubDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMGNUR.MgChildPagEleC("ChildSub")</IdLocation>
<IndexLocation>^DHCMGNUR.MgChildPagEleSubI</IndexLocation>
<StreamLocation>^DHCMGNUR.MgChildPagEleSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
