/// Creator   : wk
/// CreatDate : 2018-11-02
/// Desc      : 主页产品使用列表
/// TableName : web_DHCWL_V1_HomeTab.ProductList
Class web.DHCWL.V1.HomeTab.ProductList Extends %Persistent [ ClassType = persistent ]
{

/// 产品ID
Property ProID As %String [ Required, SqlColumnNumber = 2 ];

/// 使用时间
Property UsageTime As %Time [ Required, SqlColumnNumber = 3 ];

/// 使用次数
Property usageCount As %Integer [ Required, SqlColumnNumber = 4 ];

/// 使用日期
Property UsageDate As %Date [ Required, SqlColumnNumber = 5 ];

Index ID On ProID As AlphaUp;

Index Time On UsageTime;

Index Date On UsageDate;

Index Count On usageCount;

Storage Default
{
<Data name="ProductListDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ProID</Value>
</Value>
<Value name="3">
<Value>UsageTime</Value>
</Value>
<Value name="4">
<Value>usageCount</Value>
</Value>
<Value name="5">
<Value>UsageDate</Value>
</Value>
</Data>
<DataLocation>^web.DHCWL.V1.H7DB0.ProductListD</DataLocation>
<DefaultData>ProductListDefaultData</DefaultData>
<IdLocation>^web.DHCWL.V1.H7DB0.ProductListD</IdLocation>
<IndexLocation>^web.DHCWL.V1.H7DB0.ProductListI</IndexLocation>
<StreamLocation>^web.DHCWL.V1.H7DB0.ProductListS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
