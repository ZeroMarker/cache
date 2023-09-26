/// 清业务数据维护信息
/// 2015-09-14 谷雪萍 
Class User.DHCClearBusinessData Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlTableName = DHC_ClearBusinessData ]
{

/// 产品组
Property ClearProductGroup As %String [ SqlColumnNumber = 2, SqlFieldName = Clear_ProductGroup ];

/// Global名称
Property ClearGlobal As %String [ SqlColumnNumber = 3, SqlFieldName = Clear_Global ];

/// Global对应的表名
Property ClearGlobalTable As %String [ SqlColumnNumber = 4, SqlFieldName = Clear_GlobalTable ];

/// 中文描述
Property ClearDesc As %String [ SqlColumnNumber = 5, SqlFieldName = Clear_Desc ];

/// 有效标记
Property ClearStatus As %String(DISPLAYLIST = ",有效,无效", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",1,0") [ SqlColumnNumber = 6, SqlFieldName = Clear_Status ];

/// 命名空间 2015-10-30 guxueping
Property ClearNamespace As %String [ SqlColumnNumber = 7, SqlFieldName = Clear_Namespace ];

/// 根据Global名称查询rowid的索引
Index ClearGlobalI On ClearGlobal [ Unique ];

Storage Default
{
<Data name="DHCClearBusinessDataDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ClearProductGroup</Value>
</Value>
<Value name="3">
<Value>ClearGlobal</Value>
</Value>
<Value name="4">
<Value>ClearGlobalTable</Value>
</Value>
<Value name="5">
<Value>ClearDesc</Value>
</Value>
<Value name="6">
<Value>ClearStatus</Value>
</Value>
<Value name="7">
<Value>ClearNamespace</Value>
</Value>
</Data>
<DataLocation>^User.DHCClearBusinessDataD</DataLocation>
<DefaultData>DHCClearBusinessDataDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCClearBusinessDataD</IdLocation>
<IndexLocation>^User.DHCClearBusinessDataI</IndexLocation>
<StreamLocation>^User.DHCClearBusinessDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
