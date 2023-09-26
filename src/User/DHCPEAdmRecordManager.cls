Class User.DHCPEAdmRecordManager Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ SqlTableName = DHC_PE_AdmRecordManager ]
{

Parameter ClassName = "User.DHCPEAdmRecordManager";

Property ARMADMDR As User.DHCPEPreIADM [ SqlFieldName = ARM_ADM_DR ];

Property ARMUser As %String [ SqlFieldName = ARM_User ];

Property ARMDate As %Date [ SqlFieldName = ARM_Date ];

Property ARMTime As %Time [ SqlFieldName = ARM_Time ];

Property ARMType As %String [ SqlFieldName = ARM_Type ];

Property ARMRemark As %String(MAXLEN = 200) [ SqlFieldName = ARM_Remark ];

Index AdmIndex On ARMADMDR As AlphaUp;

Index AdmDateTypeIndex On (ARMDate, ARMType As AlphaUp, ARMADMDR);

Index AdmTypeIndex On (ARMADMDR, ARMType As AlphaUp);

Index UserTypeDateIndex On (ARMUser, ARMType As AlphaUp, ARMDate);

Storage Default
{
<Data name="DHCPEAdmRecordManagerDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ARMADMDR</Value>
</Value>
<Value name="3">
<Value>ARMDate</Value>
</Value>
<Value name="4">
<Value>ARMRemark</Value>
</Value>
<Value name="5">
<Value>ARMTime</Value>
</Value>
<Value name="6">
<Value>ARMType</Value>
</Value>
<Value name="7">
<Value>ARMUser</Value>
</Value>
</Data>
<DataLocation>^User.DHCPEAdmRecordManagerD</DataLocation>
<DefaultData>DHCPEAdmRecordManagerDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCPEAdmRecordManagerD</IdLocation>
<IndexLocation>^User.DHCPEAdmRecordManagerI</IndexLocation>
<StreamLocation>^User.DHCPEAdmRecordManagerS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
