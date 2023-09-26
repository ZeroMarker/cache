Class DHCNMG.DB.MgClinicalType Extends %Persistent [ Owner = {dhpm1} ]
{

Relationship ChildSub As DHCNMG.DB.MgClinicalTypeSub [ Cardinality = children, Inverse = Parref ];

/// 类型
Property ClinicalType As %String [ SqlColumnNumber = 2, SqlFieldName = Clinical_Type ];

Property ClinicalUser As %Integer [ SqlColumnNumber = 3, SqlFieldName = Clinical_User ];

Property ClinicalWard As %String [ SqlColumnNumber = 4, SqlFieldName = Clinical_Ward ];

Index Type On ClinicalType;

Storage Default
{
<Data name="MgClinicalTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ClinicalType</Value>
</Value>
<Value name="3">
<Value>ClinicalUser</Value>
</Value>
<Value name="4">
<Value>ClinicalWard</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.DB.MgClinicalTypeD</DataLocation>
<DefaultData>MgClinicalTypeDefaultData</DefaultData>
<IdLocation>^DHCNMG.DB.MgClinicalTypeD</IdLocation>
<IndexLocation>^DHCNMG.DB.MgClinicalTypeI</IndexLocation>
<StreamLocation>^DHCNMG.DB.MgClinicalTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
