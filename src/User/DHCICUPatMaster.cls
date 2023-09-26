Class User.DHCICUPatMaster Extends %Persistent [ Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ICUPM_RowId, SqlTableName = DHC_ICU_PatMaster, StorageStrategy = CacheStorage ]
{

Property ICUPMIdentityCard As %String [ SqlColumnNumber = 2, SqlFieldName = ICUPM_IdentityCard ];

Property ICUPMName As %String [ SqlColumnNumber = 3, SqlFieldName = ICUPM_Name ];

Property ICUPMBirthdate As %Date [ SqlColumnNumber = 4, SqlFieldName = ICUPM_Birthdate ];

Property ICUPMIsEstimatedBirthdate As %Boolean [ SqlColumnNumber = 5, SqlFieldName = ICUPM_IsEstimatedBirthdate ];

Property ICUPMSex As %String(DISPLAYLIST = ",Male,Female,Unknown,Untold", VALUELIST = ",1,2,0,9") [ SqlColumnNumber = 6, SqlFieldName = ICUPM_Sex ];

Property ICUPMIsEstimatedSex As %Boolean [ SqlColumnNumber = 7, SqlFieldName = ICUPM_IsEstimatedSex ];

Property ICUPMEthnicity As %String(DISPLAYLIST = ",Yellow,White,Black,Mix,Other", VALUELIST = ",Y,W,B,M,O") [ SqlColumnNumber = 8, SqlFieldName = ICUPM_Ethnicity ];

Property ICUPMNation As %String [ SqlColumnNumber = 9, SqlFieldName = ICUPM_Nation ];

Index IdentityCard On ICUPMIdentityCard As Exact;

Index Name On ICUPMName As Exact;

Storage CacheStorage
{
<Data name="DHCICUPatMasterClassaName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCICUPatMasterDefaultData">
<Value name="1">
<Value>ICUPMIdentityCard</Value>
</Value>
<Value name="2">
<Value>ICUPMName</Value>
</Value>
<Value name="3">
<Value>ICUPMBirthdate</Value>
</Value>
<Value name="4">
<Value>ICUPMIsEstimatedBirthdate</Value>
</Value>
<Value name="5">
<Value>ICUPMSex</Value>
</Value>
<Value name="6">
<Value>ICUPMIsEstimatedSex</Value>
</Value>
<Value name="7">
<Value>ICUPMEthnicity</Value>
</Value>
<Value name="8">
<Value>ICUPMNation</Value>
</Value>
</Data>
<DataLocation>^DHCICUPatMaster</DataLocation>
<DefaultData>DHCICUPatMasterDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCICUPatMaster</IdLocation>
<IndexLocation>^DHCICUPatMaster(0)</IndexLocation>
<StreamLocation>^User.DHCICUPatMasterS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
