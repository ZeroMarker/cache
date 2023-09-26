Class User.DHCICULog Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = DHC_ICU_Log ]
{

Property Type As %String [ SqlColumnNumber = 2 ];

Property ArrangeId As User.DHCICUArrange [ SqlColumnNumber = 3 ];

Property LogDate As %Date [ SqlColumnNumber = 4 ];

Property LogTime As %Time [ SqlColumnNumber = 5 ];

Property UpdateUser As %String [ SqlColumnNumber = 6 ];

Property ClientIP As %String [ SqlColumnNumber = 7 ];

Property AppName As %String [ SqlColumnNumber = 8 ];

Property ServerIp As %String(MAXLEN = 1000) [ SqlColumnNumber = 9 ];

Property ProcessId As %String [ SqlColumnNumber = 10 ];

Property Note As %String(MAXLEN = 1000000) [ SqlColumnNumber = 11 ];

Property ClassName As %String(MAXLEN = 500) [ SqlColumnNumber = 12 ];

Property MethodName As %String(MAXLEN = 500) [ SqlColumnNumber = 13 ];

Property StackTraceLog As %String(MAXLEN = 1000000) [ SqlColumnNumber = 14 ];

Index ArrangeIndex On ArrangeId As Plus;

Index TypeIndex On (Type As Exact, ArrangeId As Plus);

Index TypeArrangeDateIndex On (Type As Exact, ArrangeId As Plus, LogDate As Exact);

Index DateIndex On LogDate As Exact;

// w ##class(User.DHCICULog).Log("RunMethod","","System.Collections.Generic.List`1[System.String]")

ClassMethod Log(type, arrangeId, className, methodName, note, stackTraceLog = "")
{
	q ""
	set maxCount=9000*10000 ; 九千万
	set curDataCount=$g(^DHCANICUDebug("ICULogCount"))
	if (curDataCount>=maxCount)
	{
		// 总日志超过九千万，认为日志异常
		quit "总日志超过九千万，日志异常"
	}
	set log=##class(User.DHCICULog).%New()
	set log.Type=type
	if (##class(User.DHCICUArrange).%ExistsId(arrangeId))
	{
		set log.ArrangeId=##class(User.DHCICUArrange).%OpenId(arrangeId) b
	}
	set log.ClientIP=$System.Process.ClientIPAddress()
	set log.AppName=$System.Process.ClientExecutableName()
	set log.LogDate=+$h
	set log.LogTime=$p($h,",",2)
	set log.ServerIp=$p(##class(%SYSTEM.INetInfo).GetInterfacesInfo(),$c(1),3)
	set log.ProcessId=$JOB
	
	set log.Note=note 
	set log.ClassName=className
	set log.MethodName=methodName
	set log.StackTraceLog=stackTraceLog
	set sc=log.%Save()
	if ($System.Status.IsError(sc))
	{
		quit "E^"_$System.Status.GetErrorText(sc)
	}
	
	quit 0
}

Storage Default
{
<Data name="DHCICULogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Type</Value>
</Value>
<Value name="3">
<Value>ArrangeId</Value>
</Value>
<Value name="4">
<Value>LogDate</Value>
</Value>
<Value name="5">
<Value>LogTime</Value>
</Value>
<Value name="6">
<Value>UpdateUser</Value>
</Value>
<Value name="7">
<Value>ClientIP</Value>
</Value>
<Value name="8">
<Value>AppName</Value>
</Value>
<Value name="9">
<Value>ServerIp</Value>
</Value>
<Value name="10">
<Value>ProcessId</Value>
</Value>
<Value name="11">
<Value>Note</Value>
</Value>
<Value name="12">
<Value>ClassName</Value>
</Value>
<Value name="13">
<Value>MethodName</Value>
</Value>
<Value name="14">
<Value>StackTraceLog</Value>
</Value>
</Data>
<DataLocation>^User.DHCICULogD</DataLocation>
<DefaultData>DHCICULogDefaultData</DefaultData>
<IdLocation>^User.DHCICULogD</IdLocation>
<IndexLocation>^User.DHCICULogI</IndexLocation>
<StreamLocation>^User.DHCICULogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
