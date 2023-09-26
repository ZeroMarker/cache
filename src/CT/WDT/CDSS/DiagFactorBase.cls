/// Creator:丁亚男
/// CreatDate:2020-12-21
/// Description：诊断因子字典库V2.0 
/// Table：CT.WDT.CDSS.DiagFactorBase
Class CT.WDT.CDSS.DiagFactorBase Extends (%Persistent, User.Abstract)
{

/// 诊断因子编码(依据诊断因子分级编码)
Property DiagFactorCode As %String(MAXLEN = 50) [ Required ];

/// 诊断因子名称
Property DiagFactorName As %String(MAXLEN = "") [ Required ];

/// 诊断因子分类诊断因子分类（诊断、症状、查体、生命体征、检查结果描述、检验结果标准、病因/诱因）
Property DiagFactorClass As %String;

/// 使用标志(0编辑中，1已弃用，2已审核)
Property UseFlag As %Integer;

/// 创建时间
Property CreateDate As %TimeStamp;

/// 创建人员
Property CreateUserID As %String;

/// 备注
Property Remarks As %String(MAXLEN = "");

Index CodeIndex On DiagFactorCode [ Unique ];

Index NameIndex On DiagFactorName;

Index UpdateDateIndex On CreateDate As Exact;

Storage Default
{
<Data name="DiagFactorBaseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DiagFactorCode</Value>
</Value>
<Value name="3">
<Value>DiagFactorName</Value>
</Value>
<Value name="4">
<Value>DiagFactorClass</Value>
</Value>
<Value name="5">
<Value>UseFlag</Value>
</Value>
<Value name="6">
<Value>CreateDate</Value>
</Value>
<Value name="7">
<Value>CreateUserID</Value>
</Value>
<Value name="8">
<Value>Remarks</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.DiagFactorBaseD</DataLocation>
<DefaultData>DiagFactorBaseDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.DiagFactorBaseD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.DiagFactorBaseI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.DiagFactorBaseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
