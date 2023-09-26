Class DHCWL.RptMgmt.HistoryRptCfg Extends %Persistent
{

/// 菜单名称
Property MenuName As %String(COLLATION = "EXACT");

/// raq名称
Property RaqName As %String(COLLATION = "EXACT", MAXLEN = 150);

/// CSP名称
Property CSPName As %String(COLLATION = "EXACT", MAXLEN = 150);

/// 主程序query
Property QueryName As %String(COLLATION = "EXACT", MAXLEN = 200);

/// 统计口径
Property Spec As %String(COLLATION = "EXACT", MAXLEN = 250);

/// 业务表
Property HisTableName As %String(COLLATION = "EXACT", MAXLEN = 250);

/// 指标
Property KPIName As %String(COLLATION = "EXACT", MAXLEN = 500);

/// 数据条件
Property Filter As %String(COLLATION = "EXACT", MAXLEN = 250);

/// 显示条件
Property RowColShow As %String(COLLATION = "EXACT", MAXLEN = 200);

/// 逻辑说明
Property ProgramLogic As %String(COLLATION = "EXACT", MAXLEN = 200);

/// 高级客户
Property AdvUser As %String(COLLATION = "EXACT");

/// 项目工程师
Property ProMaintainer As %String(COLLATION = "EXACT");

/// 开发工程师
Property DepMaintainer As %String(COLLATION = "EXACT");

/// 备注
Property Demo As %String(COLLATION = "EXACT", MAXLEN = 2048);

/// 日期
Property CreateDate As %Date;

/// 最后更新日期
Property UPdateDate As %Date;

/// 附属菜单
Property AuxiliaryMenuName As %String(COLLATION = "EXACT");

/// 使用科室
Property UsedByDep As %String(COLLATION = "EXACT", MAXLEN = 200);

Property HistoryID As %Integer;

Property RaqCSPTitleName As %String(COLLATION = "EXACT", MAXLEN = 250);

// Index InxRaqCspTitle On RaqCSPTitleName [ Unique ];

Storage Default
{
<Data name="HistoryRptCfgDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MenuName</Value>
</Value>
<Value name="3">
<Value>RaqName</Value>
</Value>
<Value name="4">
<Value>CSPName</Value>
</Value>
<Value name="5">
<Value>QueryName</Value>
</Value>
<Value name="6">
<Value>Spec</Value>
</Value>
<Value name="7">
<Value>HisTableName</Value>
</Value>
<Value name="8">
<Value>KPIName</Value>
</Value>
<Value name="9">
<Value>Filter</Value>
</Value>
<Value name="10">
<Value>RowColShow</Value>
</Value>
<Value name="11">
<Value>ProgramLogic</Value>
</Value>
<Value name="12">
<Value>AdvUser</Value>
</Value>
<Value name="13">
<Value>ProMaintainer</Value>
</Value>
<Value name="14">
<Value>DepMaintainer</Value>
</Value>
<Value name="15">
<Value>Demo</Value>
</Value>
<Value name="16">
<Value>CreateDate</Value>
</Value>
<Value name="17">
<Value>UPdateDate</Value>
</Value>
<Value name="18">
<Value>AuxiliaryMenuName</Value>
</Value>
<Value name="19">
<Value>HistoryID</Value>
</Value>
<Value name="20">
<Value>UsedByDep</Value>
</Value>
<Value name="21">
<Value>RaqCSPName</Value>
</Value>
<Value name="22">
<Value>RaqCSPTitleName</Value>
</Value>
</Data>
<DataLocation>^DHCWL.RptMgmt.HistoryRptCfgD</DataLocation>
<DefaultData>HistoryRptCfgDefaultData</DefaultData>
<IdLocation>^DHCWL.RptMgmt.HistoryRptCfgD</IdLocation>
<IndexLocation>^DHCWL.RptMgmt.HistoryRptCfgI</IndexLocation>
<StreamLocation>^DHCWL.RptMgmt.HistoryRptCfgS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
