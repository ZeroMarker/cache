Class User.CSSDCleanDetailPacksNumber Extends (%Persistent, User.Abstract) [ SqlRowIdName = CSSDCDPN_Rowid, SqlTableName = CSSD_CleanDetailPacksNumber ]
{

/// 清洗明细ID
Property CSSDCDPNCleanDetail As User.CSSDCleanDetailPacks [ SqlColumnNumber = 2, SqlFieldName = CSSDCDPN_CleanDetailDR ];

/// 数量
Property CSSDCDPNQty As %Integer [ SqlColumnNumber = 3, SqlFieldName = CSSDCDPN_Qty ];

/// 包数
Property CSSDCDPNPackQty As %Integer [ SqlColumnNumber = 4, SqlFieldName = CSSDCDPN_PackQty ];

/// 标签
Property CSSDCDPNLabel As %String(COLLATION = "Exact") [ SqlColumnNumber = 5, SqlFieldName = CSSDCDPN_Label ];

Index CSSDCDPNCleanDetailLabelIndex On (CSSDCDPNCleanDetail As Exact, CSSDCDPNLabel As Exact);

Index CSSDCDPNLabelIndex On CSSDCDPNLabel As Exact;

Storage Default
{
<Data name="CSSDCleanDetailPacksNumberDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CSSDCDPNCleanDetail</Value>
</Value>
<Value name="3">
<Value>CSSDCDPNQty</Value>
</Value>
<Value name="4">
<Value>CSSDCDPNPackQty</Value>
</Value>
<Value name="5">
<Value>CSSDCDPNLabel</Value>
</Value>
</Data>
<DataLocation>^CSSDCleanDetailPacksNumberD</DataLocation>
<DefaultData>CSSDCleanDetailPacksNumberDefaultData</DefaultData>
<IdLocation>^CSSDCleanDetailPacksNumberD</IdLocation>
<IndexLocation>^CSSDCleanDetailPacksNumberI</IndexLocation>
<SqlRowIdName>CSSDCDPN_Rowid</SqlRowIdName>
<StreamLocation>^CSSDCleanDetailPacksNumberS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
