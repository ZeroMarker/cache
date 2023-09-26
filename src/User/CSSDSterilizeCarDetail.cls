/// 灭菌车明细表
Class User.CSSDSterilizeCarDetail Extends (%Persistent, User.Abstract) [ SqlTableName = CSSD_SterilizeCarDetail ]
{

Property CSSDSCDCarLabel As %String(COLLATION = "Exact") [ SqlColumnNumber = 2, SqlFieldName = CSSDSCD_CarLabel ];

Property CSSDSCDPkgDr As User.CSSDPackage [ SqlColumnNumber = 3, SqlFieldName = CSSDSCD_PkgDr ];

Property CSSDSCDPkgLabel As %String(COLLATION = "Exact") [ SqlColumnNumber = 4, SqlFieldName = CSSDSCD_PkgLabel ];

Property CSSDSCDPkgNum As %Numeric [ SqlColumnNumber = 5, SqlFieldName = CSSDSCD_PkgNum ];

Index IndexPkgLabel On CSSDSCDPkgLabel As Exact;

Index IndexCarLabel On CSSDSCDCarLabel As Exact;

Storage Default
{
<Data name="CSSDSterilizeCarDetailDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CSSDSCDCarLabel</Value>
</Value>
<Value name="3">
<Value>CSSDSCDPkgDr</Value>
</Value>
<Value name="4">
<Value>CSSDSCDPkgLabel</Value>
</Value>
<Value name="5">
<Value>CSSDSCDPkgNum</Value>
</Value>
</Data>
<DataLocation>^User.CSSDSterilizeCarDetailD</DataLocation>
<DefaultData>CSSDSterilizeCarDetailDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.CSSDSterilizeCarDetailD</IdLocation>
<IndexLocation>^User.CSSDSterilizeCarDetailI</IndexLocation>
<StreamLocation>^User.CSSDSterilizeCarDetailS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
