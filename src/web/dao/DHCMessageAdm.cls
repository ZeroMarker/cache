/// 对应就诊类消息的详细展示对象
Class web.dao.DHCMessageAdm Extends %Library.RegisteredObject
{

Property Name As %String;

Property Sex As %String;

Property Age As %String;

Property AdmLoc As %String;

Property AdmDoctor As %String;

//登记号

Property AdmPapmiNo As %String;

//诊断

Property Diagnosis As %String;

//消息类型描述

Property ActionType As %String;

Property SendDate As %String;

Property SendTime As %String;

Property SendUser As %String;

Property CreateLoc As %String;

//消息内容

Property Context As %String;

Property ReadDate As %String;

Property ReadTime As %String;

Property ReadUser As %String;

Property ExecDate As %String;

Property ExecTime As %String;

Property ExecUser As %String;

Property ContentId As %String;

Property DetailsId As %String;

Property TExecFlag As %String;

Property ToolbarItems As %String;

Property ReplyList As list Of web.dao.DHCMessageReply;

Property PageNo As %String;

Property PageCount As %String;

Storage Default
{
<Data name="DHCMessageAdmDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Sex</Value>
</Value>
<Value name="4">
<Value>Age</Value>
</Value>
<Value name="5">
<Value>AdmLoc</Value>
</Value>
<Value name="6">
<Value>AdmDoctor</Value>
</Value>
<Value name="7">
<Value>Diagnosis</Value>
</Value>
<Value name="8">
<Value>ActionType</Value>
</Value>
<Value name="9">
<Value>SendDate</Value>
</Value>
<Value name="10">
<Value>SendTime</Value>
</Value>
<Value name="11">
<Value>SendUser</Value>
</Value>
<Value name="12">
<Value>Context</Value>
</Value>
</Data>
<DataLocation>^web.dao.DHCMessageAdmD</DataLocation>
<DefaultData>DHCMessageAdmDefaultData</DefaultData>
<IdLocation>^web.dao.DHCMessageAdmD</IdLocation>
<IndexLocation>^web.dao.DHCMessageAdmI</IndexLocation>
<StreamLocation>^web.dao.DHCMessageAdmS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
