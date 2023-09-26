/// 表名：DHCWL_CodeCfg.DHCWLCodeCfgLogInfo  d ##class(DHCWL.CodeCfg.LogInfo).%BuildIndices()
/// global:^DHCWL.CodeCfg.LogInfoD    ^DHCWL.CodeCfg.LogInfoI
/// 统计组日志主表
Class DHCWL.CodeCfg.LogInfo Extends %Persistent [ SqlTableName = DHCWLCodeCfgLogInfo ]
{

/// 操作用户ID
Property GrpUserID As %String [ SqlColumnNumber = 2, SqlFieldName = Grp_UserID ];

/// 操作用户名称
Property GrpUserName As %String [ SqlColumnNumber = 3, SqlFieldName = Grp_UserName ];

/// 操作用户IP
Property GrpUserIP As %String [ SqlColumnNumber = 4, SqlFieldName = Grp_UserIP ];

/// 操作类型
Property GrpOperType As %String [ SqlColumnNumber = 5, SqlFieldName = Grp_OperType ];

/// 操作模块
Property GrpModuleType As %String [ SqlColumnNumber = 6, SqlFieldName = Grp_ModuleType ];

/// 模块信息
Property GrpDependMoudle As %String [ SqlColumnNumber = 7, SqlFieldName = Grp_DependMoudle ];

/// 操作日期
Property GrpOperDate As %Date [ SqlColumnNumber = 8, SqlFieldName = Grp_OperDate ];

/// 操作时间
Property GrpOperTime As %Time [ SqlColumnNumber = 9, SqlFieldName = Grp_OperTime ];

/// 统计组属性变动
Property GrpModAttr As %String(MAXLEN = 100) [ SqlColumnNumber = 10, SqlFieldName = Grp_ModAttr ];

Index GrpDateTime On (GrpOperDate, GrpOperTime);

Storage Default
{
<Data name="LogInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>GrpUserID</Value>
</Value>
<Value name="3">
<Value>GrpUserName</Value>
</Value>
<Value name="4">
<Value>GrpUserIP</Value>
</Value>
<Value name="5">
<Value>GrpOperType</Value>
</Value>
<Value name="6">
<Value>GrpModuleType</Value>
</Value>
<Value name="7">
<Value>GrpDependMoudle</Value>
</Value>
<Value name="8">
<Value>GrpOperDate</Value>
</Value>
<Value name="9">
<Value>GrpOperTime</Value>
</Value>
<Value name="10">
<Value>GrpOtherInfor</Value>
</Value>
<Value name="11">
<Value>GrpModAttr</Value>
</Value>
</Data>
<DataLocation>^DHCWL.CodeCfg.LogInfoD</DataLocation>
<DefaultData>LogInfoDefaultData</DefaultData>
<IdLocation>^DHCWL.CodeCfg.LogInfoD</IdLocation>
<IndexLocation>^DHCWL.CodeCfg.LogInfoI</IndexLocation>
<StreamLocation>^DHCWL.CodeCfg.LogInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
