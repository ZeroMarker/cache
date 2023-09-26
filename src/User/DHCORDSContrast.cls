Class User.DHCORDSContrast Extends (%Persistent, %XML.Adaptor) [ Inheritance = right, SqlTableName = DHC_ORDSContrast ]
{

Property OEORIRowId As %String [ SqlFieldName = OEORI_RowId ];

Property OrdID As %String [ SqlFieldName = OrdID ];

Property LabNo As %String [ SqlFieldName = LabNo ];

Property CompanyName As %String [ SqlFieldName = Company_Name ];

Property SendDate As %String [ SqlFieldName = senddate ];

Property SendTime As %String [ SqlFieldName = sendtime ];

Property ExtRowID As %String [ SqlFieldName = Ext_RowID ];

Index IndexOfContrast On (CompanyName, OrdID, OEORIRowId);

Storage Default
{
<Data name="DHCORDSContrastDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OEORIRowId</Value>
</Value>
<Value name="3">
<Value>OrdID</Value>
</Value>
<Value name="4">
<Value>LabNo</Value>
</Value>
<Value name="5">
<Value>CompanyName</Value>
</Value>
<Value name="6">
<Value>SendDate</Value>
</Value>
<Value name="7">
<Value>SendTime</Value>
</Value>
<Value name="8">
<Value>ExtRowID</Value>
</Value>
</Data>
<DataLocation>^User.DHCORDSContrastD</DataLocation>
<DefaultData>DHCORDSContrastDefaultData</DefaultData>
<IdLocation>^User.DHCORDSContrastD</IdLocation>
<IndexLocation>^User.DHCORDSContrastI</IndexLocation>
<StreamLocation>^User.DHCORDSContrastS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
