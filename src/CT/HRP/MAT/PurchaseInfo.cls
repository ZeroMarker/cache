/// 耗材-带量采购
Class CT.HRP.MAT.PurchaseInfo Extends (%Persistent, User.Abstract) [ SqlTableName = PurchaseInfo ]
{

Property PURINCIDR As User.INCItm [ SqlColumnNumber = 2, SqlFieldName = PUR_INCI_DR ];

/// 带量采购类型,指向
Property PURType As CT.HRP.MAT.ComDictValue [ SqlColumnNumber = 3, SqlFieldName = PUR_Type ];

Property PURNo As %String(COLLATION = "Exact") [ Required, SqlColumnNumber = 4, SqlFieldName = PUR_No ];

Property PURStartDate As %Date [ SqlColumnNumber = 5, SqlFieldName = PUR_StartDate ];

Property PUREndDate As %Date [ SqlColumnNumber = 6, SqlFieldName = PUR_EndDate ];

/// 对应基本单位
Property PURQty As %Float [ SqlColumnNumber = 7, SqlFieldName = PUR_Qty ];

/// 对应基本单位
Property PURCompletedQty As %Float [ SqlColumnNumber = 8, SqlFieldName = PUR_CompletedQty ];

/// 带量采购名称(物资名称)
Property PURDesc As %String(COLLATION = "Exact") [ SqlColumnNumber = 9, SqlFieldName = PUR_Desc ];

Index PURNo On PURNo As Exact;

Storage Default
{
<Data name="PurchaseInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PURINCIDR</Value>
</Value>
<Value name="3">
<Value>PURType</Value>
</Value>
<Value name="4">
<Value>PURNo</Value>
</Value>
<Value name="5">
<Value>PURStartDate</Value>
</Value>
<Value name="6">
<Value>PUREndDate</Value>
</Value>
<Value name="7">
<Value>PURQty</Value>
</Value>
<Value name="8">
<Value>PURCompletedQty</Value>
</Value>
<Value name="9">
<Value>PURDesc</Value>
</Value>
</Data>
<DataLocation>^CT.HRP.MAT.PurchaseInfoD</DataLocation>
<DefaultData>PurchaseInfoDefaultData</DefaultData>
<IdLocation>^CT.HRP.MAT.PurchaseInfoD</IdLocation>
<IndexLocation>^CT.HRP.MAT.PurchaseInfoI</IndexLocation>
<StreamLocation>^CT.HRP.MAT.PurchaseInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
