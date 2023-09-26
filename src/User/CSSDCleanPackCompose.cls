Class User.CSSDCleanPackCompose Extends (%Persistent, User.Abstract) [ SqlRowIdName = CSSDCDPC_Rowid, SqlTableName = CSSD_CleanPackCompose ]
{

/// 清洗明细ID
Property CSSDCDPCCleanDetail As User.CSSDCleanDetailPacks [ SqlColumnNumber = 2, SqlFieldName = CSSDCDPC_CleanDetailDR ];

/// 数量
Property CSSDCDPCQty As %Integer [ SqlColumnNumber = 3, SqlFieldName = CSSDCDPC_Qty ];

/// 包
Property CSSDCDPCPkgDr As User.CSSDPackage [ SqlColumnNumber = 4, SqlFieldName = CSSDCDPC_PkgDr ];

/// 标签
Property CSSDCDPCLabel As %String(COLLATION = "Exact") [ SqlColumnNumber = 5, SqlFieldName = CSSDCDPC_Label ];

Index ComposePkgDrLabelIndex On (CSSDCDPCCleanDetail As Exact, CSSDCDPCPkgDr As Exact, CSSDCDPCLabel As Exact);

Index ComposeDetailIndex On CSSDCDPCCleanDetail As Exact;

Index ComposeLabelIndex On CSSDCDPCLabel As Exact;

Storage Default
{
<Data name="CSSDCleanPackComposeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CSSDCDPCCleanDetail</Value>
</Value>
<Value name="3">
<Value>CSSDCDPCQty</Value>
</Value>
<Value name="4">
<Value>CSSDCDPCPkgDr</Value>
</Value>
<Value name="5">
<Value>CSSDCDPCLabel</Value>
</Value>
</Data>
<DataLocation>^User.CSSDCleanPackComposeD</DataLocation>
<DefaultData>CSSDCleanPackComposeDefaultData</DefaultData>
<IdLocation>^User.CSSDCleanPackComposeD</IdLocation>
<IndexLocation>^User.CSSDCleanPackComposeI</IndexLocation>
<SqlRowIdName>CSSDCDPC_Rowid</SqlRowIdName>
<StreamLocation>^User.CSSDCleanPackComposeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
