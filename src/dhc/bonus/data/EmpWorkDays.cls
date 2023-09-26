Class dhc.bonus.data.EmpWorkDays Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = EmpWorkDaysID ]
{

Property month As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

Property loginname As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

Property dychuqin As %Library.Float [ SqlColumnNumber = 4 ];

Property xychuqin As %Library.Float [ SqlColumnNumber = 5 ];

Property bbchuqin As %Library.Float [ SqlColumnNumber = 6 ];

Property bbjiari As %Library.Float [ SqlColumnNumber = 7 ];

Property dyjiari As %Library.Float [ SqlColumnNumber = 8 ];

Property xyjiari As %Library.Float [ SqlColumnNumber = 9 ];

Property jiejia As %Library.Float [ SqlColumnNumber = 10 ];

Property bingshijia As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11 ];

Property curTime As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12 ];

Storage Default
{
<Data name="EmpWorkDaysDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>month</Value>
</Value>
<Value name="3">
<Value>loginname</Value>
</Value>
<Value name="4">
<Value>dychuqin</Value>
</Value>
<Value name="5">
<Value>xychuqin</Value>
</Value>
<Value name="6">
<Value>bbchuqin</Value>
</Value>
<Value name="7">
<Value>bbjiari</Value>
</Value>
<Value name="8">
<Value>dyjiari</Value>
</Value>
<Value name="9">
<Value>xyjiari</Value>
</Value>
<Value name="10">
<Value>jiejia</Value>
</Value>
<Value name="11">
<Value>bingshijia</Value>
</Value>
<Value name="12">
<Value>curTime</Value>
</Value>
</Data>
<DataLocation>^dhcbsEmpWorkDaysD</DataLocation>
<DefaultData>EmpWorkDaysDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsEmpWorkDaysD</IdLocation>
<IndexLocation>^dhcbsEmpWorkDaysI</IndexLocation>
<StreamLocation>^dhcbsEmpWorkDaysS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
