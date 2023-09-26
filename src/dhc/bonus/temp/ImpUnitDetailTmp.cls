Class dhc.bonus.temp.ImpUnitDetailTmp Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = ImpUnitDetailTmpID ]
{

Property ImpUnitMainID As dhc.bonus.temp.ImpUnitMainTmp [ SqlColumnNumber = 2 ];

Property TmpUnitCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

Property TmpUnitName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4 ];

Property SupUnitCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5 ];

Property SupUnitName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6 ];

Property CalGroupID As dhc.bonus.data.BonusCalculateTypeGroup [ SqlColumnNumber = 7 ];

Property CalGroupValue As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 8 ];

Property ColNum As %Library.Integer [ SqlColumnNumber = 9 ];

Property OnloadFileID As dhc.bonus.data.OnloadFileType [ SqlColumnNumber = 10 ];

Property JoinDate As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11 ];

Storage Default
{
<Data name="ImpUnitDetailTmpDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ImpUnitMainID</Value>
</Value>
<Value name="3">
<Value>TmpUnitCode</Value>
</Value>
<Value name="4">
<Value>TmpUnitName</Value>
</Value>
<Value name="5">
<Value>SupUnitCode</Value>
</Value>
<Value name="6">
<Value>SupUnitName</Value>
</Value>
<Value name="7">
<Value>CalGroupID</Value>
</Value>
<Value name="8">
<Value>CalGroupValue</Value>
</Value>
<Value name="9">
<Value>ColNum</Value>
</Value>
<Value name="10">
<Value>OnloadFileID</Value>
</Value>
<Value name="11">
<Value>JoinDate</Value>
</Value>
</Data>
<DataLocation>^dhcbsImpUnitDetailTmpD</DataLocation>
<DefaultData>ImpUnitDetailTmpDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsImpUnitDetailTmpD</IdLocation>
<IndexLocation>^dhcbsImpUnitDetailTmpI</IndexLocation>
<StreamLocation>^dhcbsImpUnitDetailTmpS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
