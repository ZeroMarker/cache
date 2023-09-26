/// Creator:高姗姗
/// CreatDate:2021-08-11
/// Description：腧穴字典
/// Table：CT.WDT.CDSS.TCMAcupoints
Class CT.WDT.CDSS.TCMAcupoints Extends (%Persistent, User.Abstract)
{

/// 腧穴编码
Property AcupointsCode As %String [ Required ];

/// 腧穴名称
Property AcupointsName As %String;

/// 别名
Property AcupointsAlias As %String;

/// 类属
Property AcupointsGenus As %String;

/// 归经
Property AcupointsChannelTropism As %String;

/// 功效
Property AcupointsEfficacy As %String;

/// 主治
Property AcupointsAttending As %String;

/// 操作人
Property Operator As %String;

/// 操作时间
Property OperatTime As %TimeStamp;

/// 状态(编辑中、已审核、已删除)
Property State As %String;

/// 备注
Property Remarks As %String(MAXLEN = "");

/// 引用标志 D（Decision）被决策知识库引用 K（Knowledge） 被医为百科引用 R（Rule） 被规则知识库引用 M（Mapping）数据对照
Property QuoteFlag As %String(MAXLEN = 10);

Index CodeIndex On AcupointsCode [ Unique ];

Index NameIndex On AcupointsName As Exact;

Index OperatTimeIndex On OperatTime;

Storage Default
{
<Data name="TCMAcupointsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AcupointsCode</Value>
</Value>
<Value name="3">
<Value>AcupointsName</Value>
</Value>
<Value name="4">
<Value>AcupointsAlias</Value>
</Value>
<Value name="5">
<Value>AcupointsGenus</Value>
</Value>
<Value name="6">
<Value>AcupointsChannelTropism</Value>
</Value>
<Value name="7">
<Value>AcupointsEfficacy</Value>
</Value>
<Value name="8">
<Value>AcupointsAttending</Value>
</Value>
<Value name="9">
<Value>Operator</Value>
</Value>
<Value name="10">
<Value>OperatTime</Value>
</Value>
<Value name="11">
<Value>State</Value>
</Value>
<Value name="12">
<Value>Remarks</Value>
</Value>
<Value name="13">
<Value>QuoteFlag</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.TCMAcupointsD</DataLocation>
<DefaultData>TCMAcupointsDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.TCMAcupointsD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.TCMAcupointsI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.TCMAcupointsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
