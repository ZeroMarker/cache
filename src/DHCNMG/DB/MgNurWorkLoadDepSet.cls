/// creator: zhangjz
/// Description：工作量科室维护
/// Date:2018-07-30
Class DHCNMG.DB.MgNurWorkLoadDepSet Extends %Persistent
{

/// 病区ID（DHCNMG.DB.MgWard表ID）
Property DepDR As %String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = DepDR ];

/// 序号
Property DepSort As %Integer [ SqlColumnNumber = 3, SqlFieldName = DepSort ];

/// 病区类型（DHCNMG.DB.MgWard表WardTypeDR）W: 病区；O: 门诊; E：急诊；	OP:手术室； M:医技科室
Property Typ As %String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = Typ ];

Index Dep On DepDR;

Index Typ On Typ;

Index DepSort On DepSort;

Index TypDep On (Typ, DepDR);

Index TypSort On (Typ, DepSort);

Storage Default
{
<Data name="MgNurWorkLoadDepSetDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DepDR</Value>
</Value>
<Value name="3">
<Value>DepSort</Value>
</Value>
<Value name="4">
<Value>Typ</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.DB.MgNurWorkLoadDepSetD</DataLocation>
<DefaultData>MgNurWorkLoadDepSetDefaultData</DefaultData>
<IdLocation>^DHCNMG.DB.MgNurWorkLoadDepSetD</IdLocation>
<IndexLocation>^DHCNMG.DB.MgNurWorkLoadDepSetI</IndexLocation>
<StreamLocation>^DHCNMG.DB.MgNurWorkLoadDepSetS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
