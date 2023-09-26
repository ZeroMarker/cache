Class User.DHCPEGSContrast Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ SqlTableName = DHC_PE_GSContrast ]
{

Parameter ClassName = "User.DHCPEGSContrast";

Property GSCDetail As %Stream.GlobalCharacter [ SqlFieldName = GSC_Detail ];

Property GSCADM As %Library.String [ SqlFieldName = GSC_ADM ];

Property GSCUpdateDate As %Library.Date [ SqlFieldName = GSC_UpdateDate ];

Property GSCUpdateUser As User.SSUser [ SqlFieldName = GSC_UpdateUser ];

Index IndexGSCADM On GSCADM;

Storage Default
{
<Data name="DHCPEGSContrastDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>GSCDetail</Value>
</Value>
<Value name="3">
<Value>GSCADM</Value>
</Value>
<Value name="4">
<Value>GSCUpdateDate</Value>
</Value>
<Value name="5">
<Value>GSCUpdateUser</Value>
</Value>
</Data>
<DataLocation>^User.DHCPEGSContrastD</DataLocation>
<DefaultData>DHCPEGSContrastDefaultData</DefaultData>
<IdLocation>^User.DHCPEGSContrastD</IdLocation>
<IndexLocation>^User.DHCPEGSContrastI</IndexLocation>
<StreamLocation>^User.DHCPEGSContrastS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
