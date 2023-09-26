/// 下收下送线路主表
Class User.CSSDSendRoadLineMain Extends (%Persistent, User.Abstract) [ SqlTableName = CSSD_SendRoadLineMain ]
{

Property CSSDSRLMDesc As %String(COLLATION = "Exact", TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = CSSDSRLM_LineDesc ];

Property CSSDSRLMFloorCode As %String(COLLATION = "Exact") [ SqlColumnNumber = 3, SqlFieldName = CSSDSRLM_FloorCode ];

Property CSSDSRLMLineCode As %String(COLLATION = "Exact") [ SqlColumnNumber = 4, SqlFieldName = CSSDSRLM_LineCode ];

Property CSSDSRLMSenderDR As User.SSUser [ SqlColumnNumber = 5, SqlFieldName = CSSDSRLM_SenderDR ];

Property CSSDSRLMStockLOCDR As User.CTLoc [ SqlColumnNumber = 6, SqlFieldName = CSSDSRLM_StockLOCDR ];

/// 系统号 消毒供应室1,其他是2
Property CSSDSRLMSystem As %String(COLLATION = "Exact") [ SqlColumnNumber = 7, SqlFieldName = CSSDSRLM_System ];

Property CSSDSRLMIsSt As %String(COLLATION = "Exact", TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = CSSDSRLM_IsSt ];

Index indexLineDesc On CSSDSRLMDesc As Exact;

Index indexLineSystem On CSSDSRLMSystem As Exact;

Index indexLineCode On CSSDSRLMLineCode As Exact;

Storage Default
{
<Data name="CSSDSendRoadLineMainDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CSSDSRLMDesc</Value>
</Value>
<Value name="3">
<Value>CSSDSRLMFloorCode</Value>
</Value>
<Value name="4">
<Value>CSSDSRLMLineCode</Value>
</Value>
<Value name="5">
<Value>CSSDSRLMSenderDR</Value>
</Value>
<Value name="6">
<Value>CSSDSRLMStockLOCDR</Value>
</Value>
<Value name="7">
<Value>CSSDSRLMSystem</Value>
</Value>
<Value name="8">
<Value>CSSDSRLMIsSt</Value>
</Value>
</Data>
<DataLocation>^User.CSSDSendRoadLineMainD</DataLocation>
<DefaultData>CSSDSendRoadLineMainDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.CSSDSendRoadLineMainD</IdLocation>
<IndexLocation>^User.CSSDSendRoadLineMainI</IndexLocation>
<StreamLocation>^User.CSSDSendRoadLineMainS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
