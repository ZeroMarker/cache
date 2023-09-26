Class dhc.sync.data.Config Extends (%Persistent, %Populate, %XML.Adaptor) [ ClassType = persistent, SqlRowIdName = Rowid, SqlTableName = Sync_Config ]
{

Property VarName As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = VarName ];

Property TomcatIP As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = TomcatIP ];

Property f2 As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = f2 ];

Property f3 As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = f3 ];

Property f4 As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = f4 ];

Property f5 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = f5 ];

Property f6 As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = f6 ];

Property f7 As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = f7 ];

Property f8 As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = f8 ];

Property f9 As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = f9 ];

Property f10 As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = f10 ];

Property f11 As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = f11 ];

Property f12 As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = f12 ];

Property f13 As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = f13 ];

Property f14 As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = f14 ];

Property f15 As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = f15 ];

Property f16 As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = f16 ];

Property f17 As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = f17 ];

Storage Default
{
<Data name="ConfigDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TomcatIP</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>LocLevel</Value>
</Value>
<Value name="5">
<Value>Super</Value>
</Value>
<Value name="6">
<Value>State</Value>
</Value>
<Value name="7">
<Value>Type</Value>
</Value>
<Value name="8">
<Value>DGroup</Value>
</Value>
<Value name="9">
<Value>Classify</Value>
</Value>
<Value name="10">
<Value>Address</Value>
</Value>
<Value name="11">
<Value>Phone</Value>
</Value>
<Value name="12">
<Value>Mnemonics</Value>
</Value>
<Value name="13">
<Value>StartDate</Value>
</Value>
<Value name="14">
<Value>EndDate</Value>
</Value>
<Value name="15">
<Value>Storey</Value>
</Value>
<Value name="16">
<Value>Code0</Value>
</Value>
<Value name="17">
<Value>Code1</Value>
</Value>
<Value name="18">
<Value>Code2</Value>
</Value>
<Value name="19">
<Value>Code3</Value>
</Value>
<Value name="20">
<Value>f1</Value>
</Value>
<Value name="21">
<Value>f2</Value>
</Value>
<Value name="22">
<Value>f3</Value>
</Value>
<Value name="23">
<Value>f4</Value>
</Value>
<Value name="24">
<Value>f5</Value>
</Value>
<Value name="25">
<Value>f6</Value>
</Value>
<Value name="26">
<Value>f7</Value>
</Value>
<Value name="27">
<Value>f8</Value>
</Value>
<Value name="28">
<Value>f9</Value>
</Value>
<Value name="29">
<Value>f10</Value>
</Value>
<Value name="30">
<Value>f11</Value>
</Value>
<Value name="31">
<Value>f12</Value>
</Value>
<Value name="32">
<Value>f13</Value>
</Value>
<Value name="33">
<Value>f14</Value>
</Value>
<Value name="34">
<Value>f15</Value>
</Value>
<Value name="35">
<Value>f16</Value>
</Value>
<Value name="36">
<Value>f17</Value>
</Value>
<Value name="37">
<Value>VarName</Value>
</Value>
</Data>
<DataLocation>^dhc.sync.data.ConfigD</DataLocation>
<DefaultData>ConfigDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhc.sync.data.ConfigD</IdLocation>
<IndexLocation>^dhc.sync.data.ConfigI</IndexLocation>
<StreamLocation>^dhc.sync.data.ConfigS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
