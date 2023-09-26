/// 项目表
Class CSM.SysProject Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 责任科室
Property ChargeDept As %String(MAXLEN = 100, TRUNCATE = 1);

/// 责任医疗机构
Property ChargeHospital As %String(MAXLEN = 100, TRUNCATE = 1);

/// 责任人
Property Charger As %String(MAXLEN = 100, TRUNCATE = 1);

/// ID
/// Property ProjectID As %Integer [ Required ];
/// 项目代码
Property Code As %String(MAXLEN = 100, TRUNCATE = 1);

/// 项目描述
Property Description As %String(MAXLEN = 500, TRUNCATE = 1);

/// 终止日期
Property EndDate As %String(MAXLEN = 10, TRUNCATE = 1);

/// 项目名称
Property Name As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 需要申请码验证用户身份
Property NeedValidationCode As %String(MAXLEN = 1, TRUNCATE = 1);

/// 级别
Property PrjLevel As %String(TRUNCATE = 1);

/// 起始日期
Property StartDate As %String(MAXLEN = 10, TRUNCATE = 1);

/// 项目状态：新建0/启动1/暂停2/中止-1/结束-2/作废-3
Property Status As %String(MAXLEN = 2, TRUNCATE = 1) [ Required ];

///   Index MainIdx On ProjectID [ PrimaryKey, Unique ];

Storage Default
{
<Data name="SysProjectDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ChargeHospital</Value>
</Value>
<Value name="3">
<Value>Code</Value>
</Value>
<Value name="4">
<Value>Description</Value>
</Value>
<Value name="5">
<Value>Name</Value>
</Value>
<Value name="6">
<Value>ProjectID</Value>
</Value>
<Value name="7">
<Value>ChargeDept</Value>
</Value>
<Value name="8">
<Value>Charger</Value>
</Value>
<Value name="9">
<Value>EndDate</Value>
</Value>
<Value name="10">
<Value>PrjLevel</Value>
</Value>
<Value name="11">
<Value>StartDate</Value>
</Value>
<Value name="12">
<Value>Status</Value>
</Value>
<Value name="13">
<Value>NeedValidationCode</Value>
</Value>
</Data>
<DataLocation>^CSM.SysProjectD</DataLocation>
<DefaultData>SysProjectDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CSM.SysProjectD</IdLocation>
<IndexLocation>^CSM.SysProjectI</IndexLocation>
<StreamLocation>^CSM.SysProjectS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
