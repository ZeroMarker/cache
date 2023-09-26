/// 急诊担保原因字典表
Class User.DHCEmGuaReason Extends (%Persistent, %XML.Adaptor) [ SqlTableName = DHC_EmGuaReason ]
{

Index GRECodeIndex On (GRECode, GREHospDr) [ Unique ];

Index GREDescIndex On (GREDesc, GREHospDr) [ Unique ];

Index GRECode On GRECode [ Unique ];

/// 原因代码
Property GRECode As %String [ Required, SqlFieldName = GRE_Code ];

/// 原因描述
Property GREDesc As %String [ SqlFieldName = GRE_Desc ];

/// 是否启用
Property GREActiveFlag As %String [ SqlFieldName = GRE_ActiveFlag ];

/// 集团化医院
Property GREHospDr As CTHospital [ SqlFieldName = GRE_Hosp_Dr ];

Storage Default
{
<Data name="DHCEmGuaReasonDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>GRECode</Value>
</Value>
<Value name="3">
<Value>GREDesc</Value>
</Value>
<Value name="4">
<Value>GREActiveFlag</Value>
</Value>
<Value name="5">
<Value>GREHospDr</Value>
</Value>
</Data>
<DataLocation>^User.DHCEmGuaReasonD</DataLocation>
<DefaultData>DHCEmGuaReasonDefaultData</DefaultData>
<IdLocation>^User.DHCEmGuaReasonD</IdLocation>
<IndexLocation>^User.DHCEmGuaReasonI</IndexLocation>
<StreamLocation>^User.DHCEmGuaReasonS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
