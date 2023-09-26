Class dhc.bonus.temp.ImpUnitMainTmp Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = ImpUnitMainTmpID ]
{

Property OnloadFileID As dhc.bonus.data.OnloadFileType [ SqlColumnNumber = 2 ];

Property ImpTitle As %Library.String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

Property ImpFileDesc As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 4 ];

Property ImpUserCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5 ];

Property ImpDatetime As %Library.TimeStamp [ SqlColumnNumber = 6 ];

Property ImpFlag As %Library.Integer [ SqlColumnNumber = 7 ];

Property FileName As %Library.String(COLLATION = "Exact", MAXLEN = 600, TRUNCATE = 0) [ SqlColumnNumber = 8 ];

Property UpDatetime As %Library.TimeStamp [ SqlColumnNumber = 9 ];

Storage Default
{
<Data name="ImpUnitMainTmpDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OnloadFileID</Value>
</Value>
<Value name="3">
<Value>ImpTitle</Value>
</Value>
<Value name="4">
<Value>ImpFileDesc</Value>
</Value>
<Value name="5">
<Value>ImpUserCode</Value>
</Value>
<Value name="6">
<Value>ImpDatetime</Value>
</Value>
<Value name="7">
<Value>ImpFlag</Value>
</Value>
<Value name="8">
<Value>FileName</Value>
</Value>
<Value name="9">
<Value>UpDatetime</Value>
</Value>
</Data>
<DataLocation>^dhcbsImpUnitMainTmpD</DataLocation>
<DefaultData>ImpUnitMainTmpDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsImpUnitMainTmpD</IdLocation>
<IndexLocation>^dhcbsImpUnitMainTmpI</IndexLocation>
<StreamLocation>^dhcbsImpUnitMainTmpS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
