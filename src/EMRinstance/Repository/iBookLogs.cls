/// 名称:EMRinstance.Repository.iBookLogs
/// 描述:联机文献使用日志
/// 编写者：guozongtao
/// 编写日期: 2014-8-19
Class EMRinstance.Repository.iBookLogs Extends %Persistent
{

/// 使用行为：新增目录/修改目录/新增文档/调阅文档
Property Action As %String;

/// 用户ID(SS_USER)
Property UserID As %String;

Property CTloCID As %String;

Property SSGroupID As %String;

/// 操作日期
Property OperateDate As %Date;

Property OperateTime As %Time;

/// 操作时使用的计算机IP
Property OperateMachineIP As %String;

/// EMRmeta.Repository.iBook.ID
Property iBookID As %String;

Storage Default
{
<Data name="iBookLogsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Action</Value>
</Value>
<Value name="3">
<Value>UserID</Value>
</Value>
<Value name="4">
<Value>CTloCID</Value>
</Value>
<Value name="5">
<Value>SSGroupID</Value>
</Value>
<Value name="6">
<Value>OperateDate</Value>
</Value>
<Value name="7">
<Value>OperateTime</Value>
</Value>
<Value name="8">
<Value>OperateMachineIP</Value>
</Value>
<Value name="9">
<Value>iBookID</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.iBookLogsD</DataLocation>
<DefaultData>iBookLogsDefaultData</DefaultData>
<IdLocation>^DHCEMRI.iBookLogsD</IdLocation>
<IndexLocation>^DHCEMRI.iBookLogsI</IndexLocation>
<StreamLocation>^DHCEMRI.iBookLogsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
