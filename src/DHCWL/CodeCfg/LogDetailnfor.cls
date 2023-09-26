/// 表名：DHCWL_CodeCfg.DHCWLCodeCfgLogDetailInfo  d ##class(DHCWL.CodeCfg.LogDetailnfor).%BuildIndices()
/// global:^DHCWL.CodeCfg.LogDetailnforD    ^DHCWL.CodeCfg.LogDetailnforI
/// 统计组日志明细表
Class DHCWL.CodeCfg.LogDetailnfor Extends %Persistent [ SqlTableName = DHCWLCodeCfgLogDetailInfo ]
{

/// 存储信息表头
Property GrpLogHeader As %String [ SqlColumnNumber = 2, SqlFieldName = Grp_LogHeader ];

/// 存储信息内容
Property GrpLogInfor As %String [ SqlColumnNumber = 3, SqlFieldName = Grp_LogInfor ];

/// 日志管理主表
Property GrpLogDr As %String [ SqlColumnNumber = 4, SqlFieldName = Grp_LogDr ];

/// 操作类型
Property GrpOperType As %String [ SqlColumnNumber = 5, SqlFieldName = Grp_OperType ];

Storage Default
{
<Data name="LogDetailnforDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>GrpID</Value>
</Value>
<Value name="3">
<Value>GrpDesc</Value>
</Value>
<Value name="4">
<Value>GrpBeforInfor</Value>
</Value>
<Value name="5">
<Value>GrpAfterInfor</Value>
</Value>
<Value name="6">
<Value>GrpLogDr</Value>
</Value>
<Value name="7">
<Value>GrpCode</Value>
</Value>
<Value name="8">
<Value>GrpLogHeader</Value>
</Value>
<Value name="9">
<Value>GrpLogInfor</Value>
</Value>
<Value name="10">
<Value>GrpOperType</Value>
</Value>
</Data>
<DataLocation>^DHCWL.CodeCfg.LogDetailnforD</DataLocation>
<DefaultData>LogDetailnforDefaultData</DefaultData>
<IdLocation>^DHCWL.CodeCfg.LogDetailnforD</IdLocation>
<IndexLocation>^DHCWL.CodeCfg.LogDetailnforI</IndexLocation>
<StreamLocation>^DHCWL.CodeCfg.LogDetailnforS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
