Class dhc.bonus.test10 Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = Test ]
{

Property f1 As %Library.String(COLLATION = "Exact", MAXLEN = 150, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

Property f2 As %Library.String(COLLATION = "Exact", MAXLEN = 150, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

Property f3 As %Library.String(COLLATION = "Exact", MAXLEN = 150, TRUNCATE = 0) [ SqlColumnNumber = 4 ];

Property f4 As %Library.String(COLLATION = "Exact", MAXLEN = 150, TRUNCATE = 0) [ SqlColumnNumber = 5 ];

Property f5 As %Library.String(COLLATION = "Exact", MAXLEN = 150, TRUNCATE = 0) [ SqlColumnNumber = 6 ];

Property f6 As %Library.String(COLLATION = "Exact", MAXLEN = 150, TRUNCATE = 0) [ SqlColumnNumber = 7 ];

Property f7 As %Library.Date(FORMAT = 1) [ Required, SqlColumnNumber = 8 ];

Property f8 As %Library.String(COLLATION = "Exact", MAXLEN = 150, TRUNCATE = 0) [ SqlColumnNumber = 9 ];

Property f9 As %Library.String(COLLATION = "Exact", MAXLEN = 150, TRUNCATE = 0) [ SqlColumnNumber = 10 ];

Property f10 As %Library.String(COLLATION = "Exact", MAXLEN = 150, TRUNCATE = 0) [ SqlColumnNumber = 11 ];

Property f11 As %Library.String(COLLATION = "Exact", MAXLEN = 150, TRUNCATE = 0) [ SqlColumnNumber = 12 ];

Property f12 As %Library.String(COLLATION = "Exact", MAXLEN = 150, TRUNCATE = 0) [ SqlColumnNumber = 13 ];

Property f13 As %Library.String(COLLATION = "Exact", MAXLEN = 150, TRUNCATE = 0) [ SqlColumnNumber = 14 ];

Property f14 As %Library.String(COLLATION = "Exact", MAXLEN = 150, TRUNCATE = 0) [ SqlColumnNumber = 15 ];

Property f15 As %Library.String(COLLATION = "Exact", MAXLEN = 150, TRUNCATE = 0) [ SqlColumnNumber = 16 ];

Property f16 As %Library.String(COLLATION = "Exact", MAXLEN = 150, TRUNCATE = 0) [ SqlColumnNumber = 17 ];

Property f17 As %Library.String(COLLATION = "Exact", MAXLEN = 150, TRUNCATE = 0) [ SqlColumnNumber = 18 ];

Property f18 As %Library.String(COLLATION = "Exact", MAXLEN = 150, TRUNCATE = 0) [ SqlColumnNumber = 19 ];

Property f19 As %Library.String(COLLATION = "Exact", MAXLEN = 150, TRUNCATE = 0) [ SqlColumnNumber = 20 ];

Property f20 As %Library.String(COLLATION = "Exact", MAXLEN = 150, TRUNCATE = 0) [ SqlColumnNumber = 21 ];

Property f21 As %Library.String(COLLATION = "Exact", MAXLEN = 150, TRUNCATE = 0) [ SqlColumnNumber = 22 ];

Property f22 As %Library.String(COLLATION = "Exact", MAXLEN = 150, TRUNCATE = 0) [ SqlColumnNumber = 23 ];

Property f23 As %Library.String(COLLATION = "Exact", MAXLEN = 150, TRUNCATE = 0) [ SqlColumnNumber = 24 ];

Property f24 As %Library.String(COLLATION = "Exact", MAXLEN = 150, TRUNCATE = 0) [ SqlColumnNumber = 25 ];

Property f25 As %Library.String(COLLATION = "Exact", MAXLEN = 150, TRUNCATE = 0) [ SqlColumnNumber = 26 ];

Storage Default
{
<Data name="test10DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>f1</Value>
</Value>
<Value name="3">
<Value>f2</Value>
</Value>
<Value name="4">
<Value>f3</Value>
</Value>
<Value name="5">
<Value>f4</Value>
</Value>
<Value name="6">
<Value>f5</Value>
</Value>
<Value name="7">
<Value>f6</Value>
</Value>
<Value name="8">
<Value>f7</Value>
</Value>
<Value name="9">
<Value>f8</Value>
</Value>
<Value name="10">
<Value>f9</Value>
</Value>
<Value name="11">
<Value>f10</Value>
</Value>
<Value name="12">
<Value>f11</Value>
</Value>
<Value name="13">
<Value>f12</Value>
</Value>
<Value name="14">
<Value>f13</Value>
</Value>
<Value name="15">
<Value>f14</Value>
</Value>
<Value name="16">
<Value>f15</Value>
</Value>
<Value name="17">
<Value>f16</Value>
</Value>
<Value name="18">
<Value>f17</Value>
</Value>
<Value name="19">
<Value>f18</Value>
</Value>
<Value name="20">
<Value>f19</Value>
</Value>
<Value name="21">
<Value>f20</Value>
</Value>
<Value name="22">
<Value>f21</Value>
</Value>
<Value name="23">
<Value>f22</Value>
</Value>
<Value name="24">
<Value>f23</Value>
</Value>
<Value name="25">
<Value>f24</Value>
</Value>
<Value name="26">
<Value>f25</Value>
</Value>
</Data>
<DataLocation>^dhc.bonus.test10D</DataLocation>
<DefaultData>test10DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhc.bonus.test10D</IdLocation>
<IndexLocation>^dhc.bonus.test10I</IndexLocation>
<StreamLocation>^dhc.bonus.test10S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
