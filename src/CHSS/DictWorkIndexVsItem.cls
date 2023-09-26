Class CHSS.DictWorkIndexVsItem Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = IndexVsItemRowId, SqlTableName = DictWorkIndexVsItem ]
{

/// 配置项目
Property ItemRowId As CHSS.DictBussCustodyConfigItem;

/// 业务监管指标
Property IndexRowId As CHSS.DictBussCustodyIndex;

/// 值
Property WorkValue As %Numeric;

/// 考核年份
Property Year As %String(MAXLEN = 4);

Storage Default
{
<Data name="DictWorkIndexVsItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IndexRowId</Value>
</Value>
<Value name="3">
<Value>ItemRowId</Value>
</Value>
<Value name="4">
<Value>Value</Value>
</Value>
<Value name="5">
<Value>Year</Value>
</Value>
<Value name="6">
<Value>WorkValue</Value>
</Value>
<Value name="7">
<Value>CheckYear</Value>
</Value>
</Data>
<DataLocation>^CHSS.DictWorkIndexVsItemD</DataLocation>
<DefaultData>DictWorkIndexVsItemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.DictWorkIndexVsItemD</IdLocation>
<IndexLocation>^CHSS.DictWorkIndexVsItemI</IndexLocation>
<StreamLocation>^CHSS.DictWorkIndexVsItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
