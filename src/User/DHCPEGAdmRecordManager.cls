Class User.DHCPEGAdmRecordManager Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ SqlTableName = DHC_PE_GAdmRecordManager, StorageStrategy = "" ]
{

Parameter ClassName = "User.DHCPEGAdmRecordManager";

Property GRMADMDR As User.DHCPEPreGADM [ SqlFieldName = GRM_ADM_DR ];

Property GRMUser As %String [ SqlFieldName = GRM_User ];

Property GRMDate As %Date [ SqlFieldName = GRM_Date ];

Property GRMTime As %Time [ SqlFieldName = GRM_Time ];

Property GRMType As %String [ SqlFieldName = GRM_Type ];

Property GRMRemark As %String [ SqlFieldName = GRM_Remark ];

Index AdmIndex On GRMADMDR As AlphaUp;

Storage Default
{
<Data name="DHCPEGAdmRecordManagerDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>GRMADMDR</Value>
</Value>
<Value name="3">
<Value>GRMUser</Value>
</Value>
<Value name="4">
<Value>GRMDate</Value>
</Value>
<Value name="5">
<Value>GRMTime</Value>
</Value>
<Value name="6">
<Value>GRMType</Value>
</Value>
<Value name="7">
<Value>GRMRemark</Value>
</Value>
</Data>
<DataLocation>^User.DHCPEGAdmRecordManagerD</DataLocation>
<DefaultData>DHCPEGAdmRecordManagerDefaultData</DefaultData>
<IdLocation>^User.DHCPEGAdmRecordManagerD</IdLocation>
<IndexLocation>^User.DHCPEGAdmRecordManagerI</IndexLocation>
<StreamLocation>^User.DHCPEGAdmRecordManagerS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
