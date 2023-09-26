Class DOC.Interface.Log Extends (%Persistent, User.Abstract) [ SqlTableName = Log ]
{

Index LogCode On (InsertDate, LogCode);

Index NodeSeqno On (LogCode, NodeSeqno);

Index InsertTime On (InsertDate, InsertTime);

Index InsertDateTime On (InsertDate, InsertTime, LogCode);

Index LogType On (LogType, SuccStatus);

/// 日志代码
Property LogCode As %String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 2 ];

/// 日志描述
Property LogDesc As %String(COLLATION = "EXACT", MAXLEN = 500) [ SqlColumnNumber = 3 ];

/// 节点描述
Property NodeDesc As %String(COLLATION = "EXACT", MAXLEN = 500) [ SqlColumnNumber = 4 ];

/// 节点序号(标识多个日志间是否属于同一链)
Property NodeSeqno As %String(COLLATION = "EXACT", MAXLEN = 100) [ SqlColumnNumber = 5 ];

/// 方法入参串
Property InParams As %Stream.GlobalCharacter [ SqlColumnNumber = 6 ];

/// 方法出参串
Property OutParams As %Stream.GlobalCharacter [ SqlColumnNumber = 7 ];

/// 日志成功状态
Property SuccStatus As %String(COLLATION = "EXACT", DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 8 ];

/// 插入日期
Property InsertDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 9 ];

/// 插入时间
Property InsertTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 10 ];

/// 调用者电脑信息
Property ComputerInfo As %String(COLLATION = "EXACT", MAXLEN = 1000) [ SqlColumnNumber = 11 ];

/// 调用者方法信息
Property InvokeInfo As %String(COLLATION = "EXACT", MAXLEN = 1000) [ SqlColumnNumber = 12 ];

/// Json扩展参数(未用)
Property JsonStr As %String(MAXLEN = 10000) [ SqlColumnNumber = 13 ];

/// Json扩展参数(未用)
Property JsonStrExt As %String(MAXLEN = 10000) [ SqlColumnNumber = 14 ];

/// 日志类型
Property LogType As %String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 15 ];

Storage Default
{
<Data name="LogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LogCode</Value>
</Value>
<Value name="3">
<Value>LogDesc</Value>
</Value>
<Value name="4">
<Value>NodeDesc</Value>
</Value>
<Value name="5">
<Value>NodeSeqno</Value>
</Value>
<Value name="6">
<Value>InParams</Value>
</Value>
<Value name="7">
<Value>OutParams</Value>
</Value>
<Value name="8">
<Value>SuccStatus</Value>
</Value>
<Value name="9">
<Value>InsertDate</Value>
</Value>
<Value name="10">
<Value>InsertTime</Value>
</Value>
<Value name="11">
<Value>ComputerInfo</Value>
</Value>
<Value name="12">
<Value>InvokeInfo</Value>
</Value>
<Value name="13">
<Value>JsonStr</Value>
</Value>
<Value name="14">
<Value>JsonStrExt</Value>
</Value>
<Value name="15">
<Value>LogType</Value>
</Value>
</Data>
<DataLocation>^DOC.Interface.LogD</DataLocation>
<DefaultData>LogDefaultData</DefaultData>
<IdLocation>^DOC.Interface.LogD</IdLocation>
<IndexLocation>^DOC.Interface.LogI</IndexLocation>
<StreamLocation>^DOC.Interface.LogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
