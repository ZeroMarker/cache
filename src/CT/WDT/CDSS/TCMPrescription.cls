/// Creator:高姗姗
/// CreatDate:2021-08-11
/// Description：中医方剂字典 
/// Table：CT.WDT.CDSS.TCMPrescription
Class CT.WDT.CDSS.TCMPrescription Extends (%Persistent, User.Abstract)
{

/// 方剂编码
Property PrescriptionCode As %String [ Required ];

/// 方剂名称
Property PrescriptionName As %String;

/// 别名
Property PrescriptionAlias As %String;

/// 主治
Property PrescriptionAttending As %String;

/// 功用
Property PrescriptionFunction As %String;

/// 方剂分类
Property PrescriptionType As %String;

// 出处

// Property PrescriptionSource As %String;

// 关联疾病

// Property RelatedDisease As %String;

/// 操作人
Property Operator As %String;

/// 操作时间
Property OperatTime As %TimeStamp;

/// 状态(编辑中、已审核、已删除)
Property State As %String;

/// 备注
Property Remarks As %String(MAXLEN = "");

Index CodeIndex On PrescriptionCode [ Unique ];

Index NameIndex On PrescriptionName;

Storage Default
{
<Data name="TCMPrescriptionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PrescriptionCode</Value>
</Value>
<Value name="3">
<Value>PrescriptionName</Value>
</Value>
<Value name="4">
<Value>PrescriptionAlias</Value>
</Value>
<Value name="5">
<Value>PrescriptionAttending</Value>
</Value>
<Value name="6">
<Value>PrescriptionFunction</Value>
</Value>
<Value name="7">
<Value>PrescriptionType</Value>
</Value>
<Value name="8">
<Value>Operator</Value>
</Value>
<Value name="9">
<Value>OperatTime</Value>
</Value>
<Value name="10">
<Value>State</Value>
</Value>
<Value name="11">
<Value>Remarks</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.TCMPrescriptionD</DataLocation>
<DefaultData>TCMPrescriptionDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.TCMPrescriptionD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.TCMPrescriptionI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.TCMPrescriptionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
