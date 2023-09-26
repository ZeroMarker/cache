Class User.CSSDLocPackage Extends (%Persistent, User.Abstract) [ SqlTableName = CSSD_LocPackage ]
{

Property CSSDLPRowid As %String(COLLATION = "Exact") [ SqlColumnNumber = 2, SqlFieldName = CSSDLP_Rowid ];

Property CSSDLPLocDr As User.CTLoc [ Required, SqlColumnNumber = 3, SqlFieldName = CSSDLP_Loc_Dr ];

Property CSSDLPPackDr As User.CSSDPackage [ Required, SqlColumnNumber = 4, SqlFieldName = CSSDLP_Pack_Dr ];

Property CSSDLPNormQty As %Integer [ SqlColumnNumber = 5, SqlFieldName = CSSDLP_NormQty ];

Property CSSDLPCurQty As %Integer [ SqlColumnNumber = 6, SqlFieldName = CSSDLP_CurQty ];

Index CSSDLocPack On (CSSDLPLocDr As Exact, CSSDLPPackDr As Exact);

Index IndexCSSDLPLocDrPkgDr On (CSSDLPLocDr As Exact, CSSDLPPackDr As Exact);

Storage Default
{
<Data name="CSSDLocPackageDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CSSDLPRowid</Value>
</Value>
<Value name="3">
<Value>CSSDLPLocDr</Value>
</Value>
<Value name="4">
<Value>CSSDLPPackDr</Value>
</Value>
<Value name="5">
<Value>CSSDLPNormQty</Value>
</Value>
<Value name="6">
<Value>CSSDLPCurQty</Value>
</Value>
</Data>
<DataLocation>^User.CSSDLocPackageD</DataLocation>
<DefaultData>CSSDLocPackageDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.CSSDLocPackageD</IdLocation>
<IndexLocation>^User.CSSDLocPackageI</IndexLocation>
<StreamLocation>^User.CSSDLocPackageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
