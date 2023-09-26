Class CT.HRP.MAT.InciDiCode Extends (%Persistent, User.Abstract) [ SqlRowIdName = IDC_RowId, SqlTableName = InciDiCode, StorageStrategy = Default ]
{

/// 库存项id
Property IDCINCIDR As User.INCItm [ SqlColumnNumber = 2, SqlFieldName = IDC_INCI_DR ];

/// DI码
Property IDCDiCode As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 3, SqlFieldName = IDC_DiCode ];

/// 下级DI码
Property IDCLowerDiCode As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 4, SqlFieldName = IDC_LowerDiCode ];

/// 对下级DI码的转换系数
Property IDCFactor As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = IDC_Factor ];

Index Inci On IDCINCIDR As Exact;

Index DiCode On IDCDiCode As Exact;

Storage Default
{
<Data name="InciDiCodeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IDCINCIDR</Value>
</Value>
<Value name="3">
<Value>IDCDiCode</Value>
</Value>
<Value name="4">
<Value>IDCLowerDiCode</Value>
</Value>
<Value name="5">
<Value>IDCFactor</Value>
</Value>
</Data>
<DataLocation>^CT.HRP.MAT.InciDiCodeD</DataLocation>
<DefaultData>InciDiCodeDefaultData</DefaultData>
<IdLocation>^CT.HRP.MAT.InciDiCodeD</IdLocation>
<IndexLocation>^CT.HRP.MAT.InciDiCodeI</IndexLocation>
<StreamLocation>^CT.HRP.MAT.InciDiCodeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
