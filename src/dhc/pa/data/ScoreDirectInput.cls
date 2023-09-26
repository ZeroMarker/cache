Class dhc.pa.data.ScoreDirectInput Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ScoreDirectInput_rowid, SqlTableName = ScoreDirectInput ]
{

Property ScoreDirectInputMonth As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = ScoreDirectInput_Month ];

Property ScoreDirectInputUnitDr As dhc.pa.data.JXUnit [ SqlColumnNumber = 3, SqlFieldName = ScoreDirectInput_UnitDr ];

Property ScoreDirectInputKPIDr As dhc.pa.data.KPIIndex1 [ SqlColumnNumber = 4, SqlFieldName = ScoreDirectInput_KPIDr ];

Property ScoreDirectInputScore As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = ScoreDirectInput_Score ];

Property ScoreDirectInputFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = ScoreDirectInput_Flag ];

Storage Default
{
<Data name="ScoreDirectInputDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ScoreDirectInputKPIDr</Value>
</Value>
<Value name="3">
<Value>ScoreDirectInputUnitDr</Value>
</Value>
<Value name="4">
<Value>ScoreDirectInputFlag</Value>
</Value>
<Value name="5">
<Value>ScoreDirectInputMonth</Value>
</Value>
<Value name="6">
<Value>ScoreDirectInputScore</Value>
</Value>
</Data>
<DataLocation>^dhc.pa.data.ScoreDirectInputD</DataLocation>
<DefaultData>ScoreDirectInputDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhc.pa.data.ScoreDirectInputD</IdLocation>
<IndexLocation>^dhc.pa.data.ScoreDirectInputI</IndexLocation>
<StreamLocation>^dhc.pa.data.ScoreDirectInputS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
