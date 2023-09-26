Class DHCMGNUR.MgChildPagEle Extends %Persistent
{

Relationship ChildSub As DHCMGNUR.MgChildPagEleSub [ Cardinality = children, Inverse = MenuParref ];

/// 描述
Property MenuTitle As %String(TRUNCATE = 1);

/// code
Property MenuCode As %String(TRUNCATE = 1);

/// 序号
Property MenuSort As %String(TRUNCATE = 1);

Index Code On MenuCode;

ClassMethod Save(parr As %String) As %String
{
	;s ^TEMP("g21853001")=parr
	//parr="rw|^MenuCode|ssssss^MenuDesc|sssss"
	s ret=""
	s id=$P($P(parr,"^",1),"|",2)
	i id'="" s obj=##class(DHCMGNUR.MgChildPagEle).%OpenId(id)
	e  s obj=##class(DHCMGNUR.MgChildPagEle).%New()
	s obj.MenuCode=$P($P(parr,"^",2),"|",2)
	s obj.MenuTitle=$P($P(parr,"^",3),"|",2)
	d obj.%Save()
	q obj.%Id()
}

ClassMethod getVal(id) As %String
{
	s ret=""
	i id'="" d
	.s obj=##class(DHCMGNUR.MgChildPagEle).%OpenId(id)
	.s menuCode=obj.MenuCode
	.s menuDesc=obj.MenuTitle
	.s ret="rw|"_id_"^menuCode|"_menuCode_"^menuDesc|"_menuDesc
	q ret
}

ClassMethod IsExist(parr As %String) As %String
{
	s ^TEMP("g201502111427001")=parr
	//parr="rw|9^MenuCode|DHCNURPerLearningList^MenuDesc|学习经历"
	s ret=0
	;s code=$ZConvert($P($P(parr,"^",2),"|",2),"U")
	;s rw=$P($P(parr,"^",1),"|",2)
	s code=$ZConvert(parr,"U")
	s id=$O(^DHCMGNUR.MgChildPagEleI("Code"," "_code,""))
	q:id="" 0
	i id'="" s ret=1
	e  s ret=0
	q ret
}

Storage Default
{
<Data name="MgChildPagEleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MenuTitle</Value>
</Value>
<Value name="3">
<Value>MenuCode</Value>
</Value>
<Value name="4">
<Value>MenuSort</Value>
</Value>
</Data>
<DataLocation>^DHCMGNUR.MgChildPagEleD</DataLocation>
<DefaultData>MgChildPagEleDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMGNUR.MgChildPagEleD</IdLocation>
<IndexLocation>^DHCMGNUR.MgChildPagEleI</IndexLocation>
<StreamLocation>^DHCMGNUR.MgChildPagEleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
