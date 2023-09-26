/// Creator:高姗姗
/// CreatDate:2021-08-11
/// Description：中药字典 
/// Table：CT.WDT.CDSS.TCMMedicine
Class CT.WDT.CDSS.TCMMedicine Extends (%Persistent, User.Abstract)
{

/// 中药编码
Property MedicineCode As %String [ Required ];

/// 中药名称
Property MedicineName As %String;

/// 别名
Property MedicineAlias As %String;

/// 性味
Property MedicineTaste As %String;

/// 归经
Property MedicineChannelTropism As %String;

/// 功效
Property MedicineEfficacy As %String;

/// 主治
Property MedicineAttending As %String(MAXLEN = "");

/// 用法用量
Property MedicineUsage As %String(MAXLEN = "");

/// 禁忌
Property MedicineTaboo As %String(MAXLEN = "");

/// 操作人
Property Operator As %String;

/// 操作时间
Property OperatTime As %TimeStamp;

/// 状态(编辑中、已审核、已删除)
Property State As %String;

/// 备注
Property Remarks As %String(MAXLEN = "");

Index CodeIndex On MedicineCode [ Unique ];

Index NameIndex On MedicineName;

Storage Default
{
<Data name="TCMMedicineDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MedicineCode</Value>
</Value>
<Value name="3">
<Value>MedicineName</Value>
</Value>
<Value name="4">
<Value>MedicineAlias</Value>
</Value>
<Value name="5">
<Value>MedicineTaste</Value>
</Value>
<Value name="6">
<Value>MedicineChannelTropism</Value>
</Value>
<Value name="7">
<Value>MedicineEfficacy</Value>
</Value>
<Value name="8">
<Value>MedicineAttending</Value>
</Value>
<Value name="9">
<Value>MedicineUsage</Value>
</Value>
<Value name="10">
<Value>MedicineTaboo</Value>
</Value>
<Value name="11">
<Value>Operator</Value>
</Value>
<Value name="12">
<Value>OperatTime</Value>
</Value>
<Value name="13">
<Value>State</Value>
</Value>
<Value name="14">
<Value>Remarks</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.TCMMedicineD</DataLocation>
<DefaultData>TCMMedicineDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.TCMMedicineD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.TCMMedicineI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.TCMMedicineS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
