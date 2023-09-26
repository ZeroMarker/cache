Class CHSS.WomenDangerFactor Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = FactorRowId, SqlTableName = WomenDangerFactor ]
{

/// 高危记录
Property DangerRowId As CHSS.WomenDangerRecord;

/// 高危评分项目Vs明细
Property ItemVsDetailRowId As CHSS.DictDangerItemVsDetail;

Storage Default
{
<Data name="WomenDangerFactorDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DangerRowId</Value>
</Value>
<Value name="3">
<Value>ItemVsDetailRowId</Value>
</Value>
</Data>
<DataLocation>^CHSS.WomenDangerFactorD</DataLocation>
<DefaultData>WomenDangerFactorDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.WomenDangerFactorD</IdLocation>
<IndexLocation>^CHSS.WomenDangerFactorI</IndexLocation>
<StreamLocation>^CHSS.WomenDangerFactorS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
