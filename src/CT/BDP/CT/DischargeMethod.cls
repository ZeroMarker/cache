/// Creator:zrf
/// CreatDate:2022-9-5
/// Description：出院方式
/// Table：CT.BDP.CT.DischargeMethod
Class CT.BDP.CT.DischargeMethod Extends (%Persistent, User.Abstract)
{

/// 代码
Property CTDMCode As %String [ Required, SqlFieldName = CTDM_Code ];

/// 描述
Property CTDMDesc As %String [ Required, SqlFieldName = CTDM_Desc ];

/// 开始日期
Property CTDMDateFrom As %Date [ SqlFieldName = CTDM_DateFrom ];

/// 结束日期
Property CTDMDateTo As %Date [ SqlFieldName = CTDM_DateTo ];

Index CodeIndex On CTDMCode As Exact;

Index DescIndex On CTDMDesc As Exact;

Storage Default
{
<Data name="DischargeMethodDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CTDMCode</Value>
</Value>
<Value name="3">
<Value>CTDMDesc</Value>
</Value>
<Value name="4">
<Value>CTDMDateFrom</Value>
</Value>
<Value name="5">
<Value>CTDMDateTo</Value>
</Value>
</Data>
<DataLocation>^CT.BDP.CT.DischargeMethodD</DataLocation>
<DefaultData>DischargeMethodDefaultData</DefaultData>
<IdLocation>^CT.BDP.CT.DischargeMethodD</IdLocation>
<IndexLocation>^CT.BDP.CT.DischargeMethodI</IndexLocation>
<StreamLocation>^CT.BDP.CT.DischargeMethodS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
