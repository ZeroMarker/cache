/// 耗材-带量采购库存项关联表
Class CT.HRP.MAT.PurInfoRelation Extends (%Persistent, User.Abstract) [ SqlTableName = PurInfoRelation ]
{

/// 库存项ID
Property PIRINCI As User.INCItm [ Required, SqlColumnNumber = 3, SqlFieldName = PIR_INCI ];

/// 带量采购表ID
Property PIRPURDR As CT.HRP.MAT.PurchaseInfo [ Required, SqlColumnNumber = 4, SqlFieldName = PIR_PUR_DR ];

/// 带量采购编号
Property PIRPURNo As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 5, SqlFieldName = PIR_PURNo ];

/// 已采购量(对应基本单位)
Property PIRCompletedQty As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = PIR_CompletedQty ];

/// 是否启用
Property PIRUseFlag As %Library.String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = PIR_UseFlag ];

Index Inci On PIRINCI As Exact;

Index InciPurDR On (PIRINCI As Exact, PIRPURDR As Exact);

Index InciUse On (PIRINCI As Exact, PIRUseFlag As Exact);

Index PurDR On PIRPURDR As Exact;

Storage Default
{
<Data name="PurInfoRelationDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PIRINCI</Value>
</Value>
<Value name="3">
<Value>PIRPURDR</Value>
</Value>
<Value name="4">
<Value>PIRPURNo</Value>
</Value>
<Value name="5">
<Value>PIRCompletedQty</Value>
</Value>
<Value name="6">
<Value>PIRUseFlag</Value>
</Value>
</Data>
<DataLocation>^CT.HRP.MAT.PurInfoRelationD</DataLocation>
<DefaultData>PurInfoRelationDefaultData</DefaultData>
<IdLocation>^CT.HRP.MAT.PurInfoRelationD</IdLocation>
<IndexLocation>^CT.HRP.MAT.PurInfoRelationI</IndexLocation>
<StreamLocation>^CT.HRP.MAT.PurInfoRelationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
