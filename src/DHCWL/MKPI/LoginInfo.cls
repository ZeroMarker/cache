/// 指标4.0版本日志信息
/// DHCWL_MKPI.LoginInfo		d ##class(DHCWL.MKPI.LoginInfo).%BuildIndices()
/// 
Class DHCWL.MKPI.LoginInfo Extends %Persistent [ ClassType = persistent, SqlTableName = LoginInfo ]
{

/// 日志记录日期
Property LoginDate As %Date [ SqlColumnNumber = 2, SqlFieldName = Login_Date ];

/// 日志记录开始时间
Property LoginSTime As %Time [ SqlColumnNumber = 3, SqlFieldName = Login_STime ];

/// 日志记录结束时间
Property LoginETime As %Time [ SqlColumnNumber = 4, SqlFieldName = Login_ETime ];

/// 操作用户
Property Operator As %String [ SqlColumnNumber = 5, SqlFieldName = Operator ];

//modify by wk.2016-03-17

//Property LoginTypeDr As DHCWL.MKPI.APPLibrary [ SqlColumnNumber = 6, SqlFieldName = Login_TypeDr ];

/// 记录日志类型，编码表DHCWL_MKPI.DHCWLMKPIAPPLibrary的引用
Property LoginTypeDr As %Integer [ SqlColumnNumber = 6, SqlFieldName = Login_TypeDr ];

/// 调用的方法名字
Property CalledFunction As %String(MAXLEN = 100) [ SqlColumnNumber = 7, SqlFieldName = CalledFunction ];

/// 指标列表，操作中影响的指标列表id
Property MKPIIdList As %String(MAXLEN = 200) [ SqlColumnNumber = 8, SqlFieldName = MKPIIdList ];

/// 操作前指标的个属性列表，用串拼接，在指标定义日志类型中使用
Property PrePropertyList As %String(MAXLEN = 300) [ SqlColumnNumber = 9, SqlFieldName = PrePropertyList ];

/// 操作后指标的个属性列表，用串拼接，在指标定义日志类型中使用
Property PostPropertyList As %String(MAXLEN = 300) [ SqlColumnNumber = 10, SqlFieldName = PostPropertyList ];

/// 参数--指标的取数规则，在指标数据中使用
Property ParaKpiRule As %String(MAXLEN = 300) [ SqlColumnNumber = 11, SqlFieldName = ParaKpiRule ];

/// 参数--指标的过滤规则，在指标数据中使用
Property ParaFilterRule As %String(MAXLEN = 300) [ SqlColumnNumber = 12, SqlFieldName = ParaFilterRule ];

/// 参数--查询日期范围和类型，在指标数据及其任务中使用
Property ParaDateScope As %String [ SqlColumnNumber = 13, SqlFieldName = ParaDateScope ];

/// 参数--其他参数信息列表
Property ParaOther As %String(MAXLEN = 300) [ SqlColumnNumber = 14, SqlFieldName = ParaOther ];

/// 操作后的状态
Property OperateState As %String [ SqlColumnNumber = 15, SqlFieldName = OperateState ];

/// 其他内容
Property OtherContent As %String [ SqlColumnNumber = 16, SqlFieldName = OtherContent ];

Index LoginTypeDate On (LoginTypeDr, LoginDate);

Storage Default
{
<Data name="LoginInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LoginDate</Value>
</Value>
<Value name="3">
<Value>LoginSTime</Value>
</Value>
<Value name="4">
<Value>LoginETime</Value>
</Value>
<Value name="5">
<Value>Operator</Value>
</Value>
<Value name="6">
<Value>LoginTypeDr</Value>
</Value>
<Value name="7">
<Value>CalledFunction</Value>
</Value>
<Value name="8">
<Value>MKPIIdList</Value>
</Value>
<Value name="9">
<Value>PrePropertyList</Value>
</Value>
<Value name="10">
<Value>PostPropertyList</Value>
</Value>
<Value name="11">
<Value>ParaKpiRule</Value>
</Value>
<Value name="12">
<Value>ParaFilterRule</Value>
</Value>
<Value name="13">
<Value>ParaDateScope</Value>
</Value>
<Value name="14">
<Value>ParaOther</Value>
</Value>
<Value name="15">
<Value>OperateState</Value>
</Value>
<Value name="16">
<Value>OtherContent</Value>
</Value>
</Data>
<DataLocation>^DHCWL.MKPI.LoginInfoD</DataLocation>
<DefaultData>LoginInfoDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWL.MKPI.LoginInfoD</IdLocation>
<IndexLocation>^DHCWL.MKPI.LoginInfoI</IndexLocation>
<StreamLocation>^DHCWL.MKPI.LoginInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
