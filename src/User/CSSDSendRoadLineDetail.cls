/// 下收下送线路明细
Class User.CSSDSendRoadLineDetail Extends (%Persistent, User.Abstract) [ SqlTableName = CSSD_SendRoadLineDetail ]
{

Property CSSDSRLDLocDR As User.CTLoc [ SqlColumnNumber = 2, SqlFieldName = CSSDSRLD_LocDR ];

Property CSSDSRLDReciverDR As User.SSUser [ SqlColumnNumber = 3, SqlFieldName = CSSDSRLD_ReciverDR ];

Property CSSDSRLDSortNo As %Numeric [ SqlColumnNumber = 4, SqlFieldName = CSSDSRLD_SortNo ];

/// 主表ID
Property CSSDSRLDRoadLineDR As User.CSSDSendRoadLineMain [ SqlColumnNumber = 5, SqlFieldName = CSSDSRLD_RoadLineDR ];

Index indexLineLoc On (CSSDSRLDRoadLineDR As Exact, CSSDSRLDLocDR As Exact);

Index IndexRoadLineDR On CSSDSRLDRoadLineDR As Exact;

Storage Default
{
<Data name="CSSDSendRoadLineDetailDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CSSDSRLDLocDR</Value>
</Value>
<Value name="3">
<Value>CSSDSRLDReciverDR</Value>
</Value>
<Value name="4">
<Value>CSSDSRLDSortNo</Value>
</Value>
<Value name="5">
<Value>CSSDSRLDRoadLineDR</Value>
</Value>
</Data>
<DataLocation>^User.CSSDSendRoadLineDetailD</DataLocation>
<DefaultData>CSSDSendRoadLineDetailDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.CSSDSendRoadLineDetailD</IdLocation>
<IndexLocation>^User.CSSDSendRoadLineDetailI</IndexLocation>
<StreamLocation>^User.CSSDSendRoadLineDetailS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
