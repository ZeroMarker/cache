Class CHSS.EarthquakePersonPsychology Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = RowId, SqlTableName = EarthquakePersonPsychology ]
{

/// 外键
Property PersonRowIdDR As CHSS.PersonHealthRecordMain [ Required ];

/// 最近作任何事都能集中注意力	
Property CanFocusAttention As %String(MAXLEN = 5, TRUNCATE = 1);

/// 最近因过分担心而失眠	
Property bInsomnia As %String(MAXLEN = 5, TRUNCATE = 1);

/// 你认为最近在许多事情中你都起了作用吗	
Property bActive As %String(MAXLEN = 5, TRUNCATE = 1);

/// 你觉得最近对许多事情都能作出决定吗
Property bDecision As %String(MAXLEN = 5, TRUNCATE = 1);

/// 你最近感觉经常处于压力之下么	
Property bUnderPressure As %String(MAXLEN = 5, TRUNCATE = 1);

/// 你最近认为你不能克服困难了吗	
Property bOvercomeTrouble As %String(MAXLEN = 5, TRUNCATE = 1);

/// 你最近能从你的日常活动中得到乐趣吗	
Property bHaveFun As %String(MAXLEN = 5, TRUNCATE = 1);

/// 你最近能勇敢面对你的难题吗	
Property bHaveBraveToFace As %String(MAXLEN = 5, TRUNCATE = 1);

/// 你最近感到高兴不起来或情绪低落吗	
Property bAwfulness As %String(MAXLEN = 5, TRUNCATE = 1);

/// 你最近缺乏自信吗	
Property bNotSelfTrust As %String(MAXLEN = 5, TRUNCATE = 1);

/// 你最近认为自己是个无用的人吗	
Property bUsefulness As %String(MAXLEN = 5, TRUNCATE = 1);

/// 你最近觉得快乐、每件事情都考虑周全了吗	
Property bThinkComprehensive As %String(MAXLEN = 5, TRUNCATE = 1);

Index PersonRowIdDRIndex On PersonRowIdDR [ Unique ];

Storage Default
{
<Data name="EarthquakePersonPsychologyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CanFocusAttention</Value>
</Value>
<Value name="3">
<Value>PersonRowIdDR</Value>
</Value>
<Value name="4">
<Value>bActive</Value>
</Value>
<Value name="5">
<Value>bAwfulness</Value>
</Value>
<Value name="6">
<Value>bDecision</Value>
</Value>
<Value name="7">
<Value>bHaveBraveToFace</Value>
</Value>
<Value name="8">
<Value>bHaveFun</Value>
</Value>
<Value name="9">
<Value>bInsomnia</Value>
</Value>
<Value name="10">
<Value>bNotSelfTrust</Value>
</Value>
<Value name="11">
<Value>bOvercomeTrouble</Value>
</Value>
<Value name="12">
<Value>bThinkComprehensive</Value>
</Value>
<Value name="13">
<Value>bUnderPressure</Value>
</Value>
<Value name="14">
<Value>bUsefulness</Value>
</Value>
</Data>
<DataLocation>^CHSS.EarthquakePeAB3D</DataLocation>
<DefaultData>EarthquakePersonPsychologyDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.EarthquakePeAB3D</IdLocation>
<IndexLocation>^CHSS.EarthquakePeAB3I</IndexLocation>
<StreamLocation>^CHSS.EarthquakePeAB3S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
