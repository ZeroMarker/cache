/// 报表的数据查询日志
/// 这个日志管理主要用来做报表级别的管理，最细粒度是报表
/// 记录日志标准： replogflag = 1	;暂定需要调用报表人员必须使用
Class User.DHCRepDataQueryLog Extends %Persistent [ ClassType = persistent, ProcedureBlock, SqlTableName = DHC_RepDataQueryLog ]
{

/// 智能报表名称
Property BIRepName As %String(MAXLEN = "") [ Required ];

/// 用户使用这个报表，提交的条件， 条件使用Json串标示
Property BIRepCondition As %String(MAXLEN = "");

/// 查询日期(监控日期)
Property QueryDate As %Date [ InitialExpression = {+$h}, Required ];

/// 查询时间(监控时间)
Property QueryTime As %Time [ InitialExpression = {+$p($h,",",2)}, Required ];

/// 查询用户，这个一定取session信息，如果Session中没有，可以为空
Property QueryUserName As %String(MAXLEN = "");

Property QueryGroupDesc As %String(MAXLEN = "");

/// 查询用户使用的机器IP
Property QueryUserIP As %String(MAXLEN = "");

Index DateRepUserIdx On (QueryDate, BIRepName, QueryUserName);

Index RepUserIdx On (BIRepName, QueryUserName);

Storage Default
{
<Data name="DHCRepDataQueryLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BIRepName</Value>
</Value>
<Value name="3">
<Value>BIRepCondition</Value>
</Value>
<Value name="4">
<Value>QueryDate</Value>
</Value>
<Value name="5">
<Value>QueryTime</Value>
</Value>
<Value name="6">
<Value>QueryUserDR</Value>
</Value>
<Value name="7">
<Value>QueryUserName</Value>
</Value>
<Value name="8">
<Value>QueryGroupDesc</Value>
</Value>
<Value name="9">
<Value>QueryUserIP</Value>
</Value>
</Data>
<DataLocation>^User.DHCRepDataQueryLogD</DataLocation>
<DefaultData>DHCRepDataQueryLogDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCRepDataQueryLogD</IdLocation>
<IndexLocation>^User.DHCRepDataQueryLogI</IndexLocation>
<StreamLocation>^User.DHCRepDataQueryLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
