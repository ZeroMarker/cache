Class CHSS.WhFirstCheckEval Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = RowId, SqlTableName = WhFirstCheckEval ]
{

/// 初次孕产期检查编号
Property FirstCheckRowIdParref As CHSS.WomenFirstCheck;

/// 评价编号
Property EvalRowIdParref As CHSS.DictFirstCheckEval;

/// 评价内容
Property EvalContent As %String(MAXLEN = 100, TRUNCATE = 1);

Storage Default
{
<Data name="WhFirstCheckEvalDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EvalContent</Value>
</Value>
<Value name="3">
<Value>EvalRowIdParref</Value>
</Value>
<Value name="4">
<Value>FirstCheckRowIdParref</Value>
</Value>
</Data>
<DataLocation>^CHSS.WhFirstCheckEvalD</DataLocation>
<DefaultData>WhFirstCheckEvalDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.WhFirstCheckEvalD</IdLocation>
<IndexLocation>^CHSS.WhFirstCheckEvalI</IndexLocation>
<StreamLocation>^CHSS.WhFirstCheckEvalS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
