/// ///实习护士分组
Class DHCMGNUR.MgPPerGroup Extends %Persistent
{

/// 分组名称
Property GroupDesc As %String [ SqlColumnNumber = 2, SqlFieldName = Group_Desc ];

/// 分组病区
Property GroupWard As %String [ SqlColumnNumber = 3, SqlFieldName = Group_Ward ];

/// 分组名称
Property GroupValid As %String [ SqlColumnNumber = 4, SqlFieldName = Group_Valid ];

ClassMethod Save(parr As %String) As %String
{
	q:parr=""
	s GroupDesc=$P(parr,"^",1)
	s GroupWard=$P(parr,"^",2)
	s a=##class(DHCMGNUR.MgPPerGroup).%New()
	s a.GroupDesc=GroupDesc
	s a.GroupWard=GroupWard
	d a.%Save()
	q
}

ClassMethod getVal(ID As %String) As %String
{
	q:ID=""
	s a= ##class(DHCMGNUR.MgPPerGroup).%OpenId(ID)
	q:a=""
	s ret="GroupDesc|"_a.GroupDesc
	s ret=ret_"^GroupWard|"_a.GroupWard
	s ret=ret_"^GroupValid|"_a.GroupValid
	s ret=ret_"^ID|"_ID
	q ret
}

ClassMethod setMarks(parr As %String) As %String
{
	q:parr=""
	s ID=$P(parr,"^",1)
	s Mark=$P(parr,"^",2)
	s MarkVal=$P(parr,"^",3)
	s a=##class(DHCMGNUR.MgPPerGroup).%OpenId(ID)
	i Mark="Valid" s a.GroupValid=MarkVal
	d a.%Save()
	q
}

Storage Default
{
<Data name="MgPPerGroupDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>GroupDesc</Value>
</Value>
<Value name="3">
<Value>GroupWard</Value>
</Value>
<Value name="4">
<Value>GroupValid</Value>
</Value>
</Data>
<DataLocation>^DHCMGNUR.MgPPerGroupD</DataLocation>
<DefaultData>MgPPerGroupDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMGNUR.MgPPerGroupD</IdLocation>
<IndexLocation>^DHCMGNUR.MgPPerGroupI</IndexLocation>
<StreamLocation>^DHCMGNUR.MgPPerGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
