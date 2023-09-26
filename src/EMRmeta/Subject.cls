/// Class Name:		EMRmeta.Subject
/// Description:	电子病历订阅信息表
/// 					数据订阅流程：
/// 					[电子病历事件(Event)]相关的电子病历数据[由电子病历数据编码(Glossary)确定]被某个观察者[由观察者类型(Type)确定]订阅，
/// 					观察者根据取到的电子病历数据和自身数据[由观察者数据编码(Code)确定]决定要做什么操作
/// Creator:		Lina
/// Create Date:	2015-09-17		
Class EMRmeta.Subject Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Index Idx On Event;

/// 唯一索引：某个观察者Type只能订阅某个电子病历事件Event相关的特定电子病历数据Glossary一次
Index IdxMain On (Event, Type, Glossary) [ Unique ];

/// 观察者/订阅者数据编码
Property Code As %String(MAXLEN = 30, TRUNCATE = 1) [ Required ];

/// 电子病历数据编码，支持：术语集编码、电子病历自定义数据项编码
Property Glossary As %String(MAXLEN = 30, TRUNCATE = 1) [ Required ];

/// 电子病历数据描述
Property Description As %String(MAXLEN = 200, TRUNCATE = 1);

/// 表达式
Property Expression As %String(MAXLEN = 200, TRUNCATE = 1);

/// 观察者/订阅者类型
Property Type As %String(MAXLEN = 30, TRUNCATE = 1) [ Required ];

/// 是否有效 Y/N
Property IsActive As %String(MAXLEN = 3, TRUNCATE = 1);

/// 备注文本
Property ResumeText As %String(MAXLEN = 200, TRUNCATE = 1);

/// 电子病历事件
Property Event As %String(TRUNCATE = 1) [ Required ];

Storage Default
{
<Data name="SubjectDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>Glossary</Value>
</Value>
<Value name="4">
<Value>Description</Value>
</Value>
<Value name="5">
<Value>Expression</Value>
</Value>
<Value name="6">
<Value>Type</Value>
</Value>
<Value name="7">
<Value>IsActive</Value>
</Value>
<Value name="8">
<Value>ResumeText</Value>
</Value>
<Value name="9">
<Value>Event</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.SubjectD</DataLocation>
<DefaultData>SubjectDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRM.SubjectD</IdLocation>
<IndexLocation>^DHCEMRM.SubjectI</IndexLocation>
<StreamLocation>^DHCEMRM.SubjectS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
