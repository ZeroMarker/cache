Class User.DHCBPCAnticoagulantDrug Extends %Persistent [ Owner = {_SYSTEM}, SqlTableName = DHC_BPC_AnticoagulantDrug, StorageStrategy = CacheStorage ]
{

Property BPCADCode As %String [ SqlColumnNumber = 2, SqlFieldName = BPCAD_Code ];

Property BPCADDesc As %String [ SqlColumnNumber = 3, SqlFieldName = BPCAD_Desc ];

/// 总量
Property BPCADAmount As %Float [ SqlColumnNumber = 4, SqlFieldName = BPCAD_Amount ];

/// 浓度
Property BPCADConcentration As %Float [ SqlColumnNumber = 5, SqlFieldName = BPCAD_Concentration ];

/// 单位
Property BPCADUomDr As %String [ SqlColumnNumber = 6, SqlFieldName = BPCAD_UomDr ];

/// 首推量
Property BPCADFirstAmount As %Float [ SqlColumnNumber = 7, SqlFieldName = BPCAD_FirstAmount ];

/// 剂量
Property BPCADDose As %Float [ SqlColumnNumber = 8, SqlFieldName = BPCAD_Dose ];

/// 频率
Property BPCADFrequency As %Float [ SqlColumnNumber = 9, SqlFieldName = BPCAD_Frequency ];

/// 备注
Property BPCADNote As %String [ SqlColumnNumber = 10, SqlFieldName = BPCAD_Note ];

/// 速度单位指针
Property BPCADBPCSUDr As User.DHCBPCSpeedUnit [ SqlColumnNumber = 11, SqlFieldName = BPCAD_BPCSU_Dr ];

/// 持续时间
Property BPCADDuration As %Float [ SqlColumnNumber = 12, SqlFieldName = BPCAD_Duration ];

/// 间隔分钟
Property BPCADIntervalMinute As %Float [ SqlColumnNumber = 13, SqlFieldName = BPCAD_IntervalMinute ];

/// 分类
Property BPCADCatDr As %String [ SqlColumnNumber = 14, SqlFieldName = BPCAD_CatDr ];

/// 科室
Property BPCADLocationDr As %String [ SqlColumnNumber = 15, SqlFieldName = BPCAD_Location_Dr ];

/// 处置作用(腹透)
Property BPCADLastReservation As %Float [ SqlColumnNumber = 16, SqlFieldName = BPCAD_LastReservation ];

/// 数据归属
Property DataAttribution As User.DHCBPCDataAttribution [ SqlColumnNumber = 17, SqlFieldName = BPCAD_DataAttribution ];

Storage CacheStorage
{
<Data name="BPCAnticoagulantDrugClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="BPCAnticoagulantDrugDefaultData">
<Attribute>%%CLASSNAME</Attribute>
<Value name="1">
<Value>BPCADCode</Value>
</Value>
<Value name="2">
<Value>BPCADDesc</Value>
</Value>
<Value name="3">
<Value>BPCADAmount</Value>
</Value>
<Value name="4">
<Value>BPCADConcentration</Value>
</Value>
<Value name="5">
<Value>BPCADUomDr</Value>
</Value>
<Value name="6">
<Value>BPCADFirstAmount</Value>
</Value>
<Value name="7">
<Value>BPCADDose</Value>
</Value>
<Value name="8">
<Value>BPCADFrequency</Value>
</Value>
<Value name="9">
<Value>BPCADNote</Value>
</Value>
<Value name="10">
<Value>BPCADBPCSUDr</Value>
</Value>
<Value name="11">
<Value>BPCADDuration</Value>
</Value>
<Value name="12">
<Value>BPCADIntervalMinute</Value>
</Value>
<Value name="13">
<Value>BPCADCatDr</Value>
</Value>
<Value name="14">
<Value>BPCADLocationDr</Value>
</Value>
<Value name="15">
<Value>BPCADLastReservation</Value>
</Value>
<Value name="16">
<Value>DataAttribution</Value>
</Value>
</Data>
<DataLocation>^DHCBPC("AnticoagulantDrug")</DataLocation>
<DefaultData>BPCAnticoagulantDrugDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCBPC("AnticoagulantDrug")</IdLocation>
<IndexLocation>^DHCBPC("AnticoagulantDrug",0)</IndexLocation>
<StreamLocation>^User.DHCBPCAnticoagulantDrugS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
