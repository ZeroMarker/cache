/// 住院发药库存不足记录
Class User.PHAIPNoStock Extends %Persistent [ SqlTableName = PHAIP_NoStock ]
{

Index PHACDSP On (IPNSPHACDR, IPDSPDR);

/// 发药表ID
Property IPNSPHACDR As User.DHCPHACollected [ SqlColumnNumber = 2, SqlFieldName = IPNS_PHAC_DR ];

/// 打包表ID
Property IPDSPDR As User.DHCOEDispensing [ SqlColumnNumber = 3, SqlFieldName = IPNS_DSP_DR ];

Storage Default
{
<Data name="PHAIPNoStockDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IPNSPHACDR</Value>
</Value>
<Value name="3">
<Value>IPDSPDR</Value>
</Value>
</Data>
<DataLocation>^BS.PHA.IP.NoStock</DataLocation>
<DefaultData>PHAIPNoStockDefaultData</DefaultData>
<IdLocation>^BS.PHA.IP.NoStock</IdLocation>
<IndexLocation>^BS.PHA.IP.NoStocki</IndexLocation>
<StreamLocation>^BS.PHA.IP.NoStocks</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
