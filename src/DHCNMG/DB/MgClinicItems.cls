/// 
/// 
/// 
/// 临床日报指标项目
Class DHCNMG.DB.MgClinicItems Extends %Persistent [ Owner = {dhpm1} ]
{

/// 名称
Property ClinicDesc As %String(MAXLEN = 500) [ SqlColumnNumber = 2, SqlFieldName = Clinic_Desc ];

/// 详情
Property ClinicCode As %String(MAXLEN = 500) [ SqlColumnNumber = 3, SqlFieldName = Clinic_Code ];

/// 排序
Property ClinicSort As %Integer [ SqlColumnNumber = 4, SqlFieldName = Clinic_Sort ];

/// 关联医嘱Code,分割
Property ClinicArcimCode As %String(MAXLEN = 1000) [ SqlColumnNumber = 5, SqlFieldName = Clinic_ArcimCode ];

Index sort On ClinicSort;

Index code On ClinicCode;

Storage Default
{
<Data name="MgClinicItemsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ClinicDesc</Value>
</Value>
<Value name="3">
<Value>ClinicCode</Value>
</Value>
<Value name="4">
<Value>ClinicSort</Value>
</Value>
<Value name="5">
<Value>ClinicArcimCode</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.DB.MgClinicItemsD</DataLocation>
<DefaultData>MgClinicItemsDefaultData</DefaultData>
<IdLocation>^DHCNMG.DB.MgClinicItemsD</IdLocation>
<IndexLocation>^DHCNMG.DB.MgClinicItemsI</IndexLocation>
<StreamLocation>^DHCNMG.DB.MgClinicItemsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
