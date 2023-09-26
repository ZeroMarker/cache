Class DHCEPRFS.INST.FileTemporary Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 用于存放扫描完成后未分类的文件
/// MREpisodeID
Property MREpisodeID As %String [ Required ];

/// 序号
Property OrderNum As %Integer [ Required ];

/// 文件名
Property FileName As %String(MAXLEN = 100) [ Required ];

/// 文件路径名
Property FilePath As %String(MAXLEN = 100) [ Required ];

/// 创建日期
Property CreateDate As %Date;

/// 创建时间
Property CreateTime As %Time;

/// 操作员
Property UserID As %String;

/// 状态 0 正常；1 待删除 ；2 已删除
Property Status As %String;

Index IdxMREpisodeID On MREpisodeID;

Index IdxFileName On FileName [ Unique ];

Storage Default
{
<Data name="FileTemporaryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MREpisodeID</Value>
</Value>
<Value name="3">
<Value>OrderNum</Value>
</Value>
<Value name="4">
<Value>FileName</Value>
</Value>
<Value name="5">
<Value>CreateDate</Value>
</Value>
<Value name="6">
<Value>CreateTime</Value>
</Value>
<Value name="7">
<Value>UserID</Value>
</Value>
<Value name="8">
<Value>FilePath</Value>
</Value>
<Value name="9">
<Value>Status</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.INST.FileTemporaryD</DataLocation>
<DefaultData>FileTemporaryDefaultData</DefaultData>
<IdLocation>^DHCEPRFS.INST.FileTemporaryD</IdLocation>
<IndexLocation>^DHCEPRFS.INST.FileTemporaryI</IndexLocation>
<StreamLocation>^DHCEPRFS.INST.FileTemporaryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
