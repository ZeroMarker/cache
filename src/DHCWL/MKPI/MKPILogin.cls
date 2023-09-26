/// 日志信息配置关联表, 标示各个指标都激活了哪些类型的指标日志
/// DHCWL_MKPI.MKPILogin		d ##class(DHCWL.MKPI.MKPILogin).%BuildIndices()
Class DHCWL.MKPI.MKPILogin Extends %Persistent [ ClassType = persistent, SqlTableName = MKPILogin ]
{

/// 指标，指标DHCWL_MKPI.DHCWLMKPI表的引用
Property MKPIDr As DHCWL.MKPI.MKPI [ SqlColumnNumber = 2, SqlFieldName = MKPIDr ];

//modify by wk.2016-03-17

//Property LoginTypeDr As DHCWL.MKPI.APPLibrary [ SqlColumnNumber = 3, SqlFieldName = LoginTypeDr ];

/// 日志类型，编码表DHCWL_MKPI.DHCWLMKPIAPPLibrary的引用
Property LoginTypeDr As %Integer [ SqlColumnNumber = 3, SqlFieldName = LoginTypeDr ];

/// 激活标志
Property ActiveFlag As %String [ SqlColumnNumber = 4, SqlFieldName = ActiveFlag ];

Index LoginTypeMKPIDr On (LoginTypeDr, MKPIDr);

Index MKPIDr On MKPIDr;

Storage Default
{
<Data name="MKPILoginDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MKPIDr</Value>
</Value>
<Value name="3">
<Value>LoginTypeDr</Value>
</Value>
<Value name="4">
<Value>ActiveFlag</Value>
</Value>
</Data>
<DataLocation>^DHCWL.MKPI.MKPILoginD</DataLocation>
<DefaultData>MKPILoginDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWL.MKPI.MKPILoginD</IdLocation>
<IndexLocation>^DHCWL.MKPI.MKPILoginI</IndexLocation>
<StreamLocation>^DHCWL.MKPI.MKPILoginS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
