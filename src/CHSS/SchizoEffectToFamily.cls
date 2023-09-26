Class CHSS.SchizoEffectToFamily Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = RowId, SqlTableName = SchizoEffectToFamily ]
{

/// 流水号	
Property EffectRowIDDR As %String(MAXLEN = 60, TRUNCATE = 1);

/// 个人档案主键	
Property PersonRowId As %Integer;

/// 随访记录CheckRowId外键
Property CheckRowId As %Integer;

/// 次数
Property Times As %Numeric;

Storage Default
{
<Data name="SchizoEffectToFamilyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EffectRowIDDR</Value>
</Value>
<Value name="3">
<Value>PersonRowId</Value>
</Value>
<Value name="4">
<Value>Times</Value>
</Value>
<Value name="5">
<Value>CheckRowId</Value>
</Value>
</Data>
<DataLocation>^CHSS.SchizoEffectToFamilyD</DataLocation>
<DefaultData>SchizoEffectToFamilyDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.SchizoEffectToFamilyD</IdLocation>
<IndexLocation>^CHSS.SchizoEffectToFamilyI</IndexLocation>
<StreamLocation>^CHSS.SchizoEffectToFamilyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
