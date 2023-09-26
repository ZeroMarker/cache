/// Creator:
/// Descriptions:夜班系数及夜班单价
/// Date:
Class DHCINM.Set.MgNightFeeFactor Extends %Persistent
{

/// 病区
Property Ward As %String [ SqlColumnNumber = 2, SqlFieldName = Ward ];

/// 班次
Property Post As %String [ SqlColumnNumber = 3, SqlFieldName = Post ];

/// 系数
Property Factor As %Float [ SqlColumnNumber = 4, SqlFieldName = Factor ];

/// 单价
Property Price As %Float [ SqlColumnNumber = 5, SqlFieldName = Price ];

/// 人员类型
Property Type As %String [ SqlColumnNumber = 6, SqlFieldName = Type ];

Index flag On (Type, Ward, Post);

Storage Default
{
<Data name="MgNightFeeFactorDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Ward</Value>
</Value>
<Value name="3">
<Value>Post</Value>
</Value>
<Value name="4">
<Value>Factor</Value>
</Value>
<Value name="5">
<Value>Price</Value>
</Value>
<Value name="6">
<Value>Type</Value>
</Value>
</Data>
<DataLocation>^DHCINM.Set.MgNightFeeFactorD</DataLocation>
<DefaultData>MgNightFeeFactorDefaultData</DefaultData>
<IdLocation>^DHCINM.Set.MgNightFeeFactorD</IdLocation>
<IndexLocation>^DHCINM.Set.MgNightFeeFactorI</IndexLocation>
<StreamLocation>^DHCINM.Set.MgNightFeeFactorS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
