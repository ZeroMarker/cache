Class CHSSWeb.HISInterface.PersonHealthAppraiseInfo Extends %Persistent
{

/// 危险因素
Property DangerInfo As %String(MAXLEN = 100, TRUNCATE = 1);

/// 健康指导
Property HealthSuggest As %String(MAXLEN = 100, TRUNCATE = 1);

/// 体检结果
Property CheckResult As %String(MAXLEN = 100, TRUNCATE = 1);

/// 体检异常
Property CheckResultInfo As %String(MAXLEN = 100, TRUNCATE = 1);

/// 其他
Property AppraiseOther As %String(MAXLEN = 100, TRUNCATE = 1);

Storage Default
{
<Data name="PersonHealthAppraiseInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CheckResult</Value>
</Value>
<Value name="3">
<Value>CheckResultInfo</Value>
</Value>
<Value name="4">
<Value>DangerControl</Value>
</Value>
<Value name="5">
<Value>DangerInfo</Value>
</Value>
<Value name="6">
<Value>HealthSuggest</Value>
</Value>
<Value name="7">
<Value>AppraiseOther</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.HIS6F2.PersonHealth98ED</DataLocation>
<DefaultData>PersonHealthAppraiseInfoDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.HIS6F2.PersonHealth98ED</IdLocation>
<IndexLocation>^CHSSWeb.HIS6F2.PersonHealth98EI</IndexLocation>
<StreamLocation>^CHSSWeb.HIS6F2.PersonHealth98ES</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
