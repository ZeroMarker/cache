Class User.DHCPECurDateAdmInfo Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ Inheritance = right, SqlTableName = DHC_PE_CurDateAdmInfo ]
{

Parameter ClassName = "User.DHCPECurDateAdmInfo";

Property CDADate As %Library.Date [ Required, SqlFieldName = CDA_Date ];

Property CDATime As %Library.Time [ Required, SqlFieldName = CDA_Time ];

Property CDAAdm As PAAdm [ Required, SqlFieldName = CDA_PAADM ];

Index DateAdmIndex On (CDADate, CDAAdm) [ Unique ];

ClassMethod Insert(PAADM)
{
	
	;d ##class(User.DHCPECurDateAdmInfo).Insert("14031")
	s Date=+$H
	s Time=$P($H,",",2)
	s obj=##class(User.DHCPECurDateAdmInfo).%New()
	d obj.CDAAdmSetObjectId(PAADM)
	s obj.CDADate=Date
	s obj.CDATime=Time
	d obj.%Save()
}

Storage Default
{
<Data name="DHCPECurDateAdmInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CDADate</Value>
</Value>
<Value name="3">
<Value>CDATime</Value>
</Value>
<Value name="4">
<Value>CDAAdm</Value>
</Value>
</Data>
<DataLocation>^User.DHCPECurDateAdmInfoD</DataLocation>
<DefaultData>DHCPECurDateAdmInfoDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCPECurDateAdmInfoD</IdLocation>
<IndexLocation>^User.DHCPECurDateAdmInfoI</IndexLocation>
<StreamLocation>^User.DHCPECurDateAdmInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
