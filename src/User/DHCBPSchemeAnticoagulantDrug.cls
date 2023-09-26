Class User.DHCBPSchemeAnticoagulantDrug Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = BPSAD_RowId, SqlTableName = DHC_BP_SchemeAnticoagulantDrug, StorageStrategy = CacheStorage ]
{

Index ArrangeScheme On BPSADBPArrangeSchemeDr As Plus;

Property BPSADBPArrangeSchemeDr As User.DHCBPArrangeScheme [ SqlColumnNumber = 2, SqlFieldName = BPSAD_BPArrangeScheme_Dr ];

Property BPSADBPCADDr As User.DHCBPCAnticoagulantDrug [ SqlColumnNumber = 3, SqlFieldName = BPSAD_BPCAD_Dr ];

/// 总量
Property BPSADAmount As %Float [ SqlColumnNumber = 4, SqlFieldName = BPSAD_Amount ];

/// 首推量
Property BPSADFirstAmount As %Float [ SqlColumnNumber = 5, SqlFieldName = BPSAD_FirstAmount ];

/// 剂量
Property BPSADDose As %Float [ SqlColumnNumber = 6, SqlFieldName = BPSAD_Dose ];

/// 频率
Property BPSADFrequency As %Float [ SqlColumnNumber = 7, SqlFieldName = BPSAD_Frequency ];

/// 备注
Property BPSADNote As %String [ SqlColumnNumber = 8, SqlFieldName = BPSAD_Note ];

/// 是否废弃
Property BPSADIfAbandon As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = BPSAD_IfAbandon ];

/// 操作日期
Property BPSADOperationDate As %Date [ SqlColumnNumber = 10, SqlFieldName = BPSAD_OperationDate ];

/// 操作时间
Property BPSADOperationTime As %Time [ SqlColumnNumber = 11, SqlFieldName = BPSAD_OperationTime ];

/// 持续时间
Property BPSADDuration As %String [ SqlColumnNumber = 12, SqlFieldName = BPSAD_Duration ];

/// 间隔分钟
Property BPSADIntervalMinute As %String [ SqlColumnNumber = 13, SqlFieldName = BPSAD_IntervalMinute ];

/// 用量单位
Property BPSADUomDr As %String [ SqlColumnNumber = 14, SqlFieldName = BPSAD_Uom_Dr ];

/// 剂量单位
Property BPSADSpeedUnitDr As %String [ SqlColumnNumber = 15, SqlFieldName = BPSAD_SpeedUnit_Dr ];

/// 浓度
Property BPSADConcentration As %Float [ SqlColumnNumber = 16, SqlFieldName = BPSAD_Concentration ];

/// 处置作用(腹透)
Property BPSADLastReservation As %String(DISPLAYLIST = ",LastNight,PRN,WashPipe", MAXLEN = 10, SELECTIVITY = "25%", VALUELIST = ",L,P,W") [ SqlColumnNumber = 17, SqlFieldName = BPSAD_LastReservation ];

Storage CacheStorage
{
<Data name="BPSchemeAnticoagulantDrugClass">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="BPSchemeAnticoagulantDrugData">
<Attribute>%%CLASSNAME</Attribute>
<Value name="1">
<Value>BPSADBPArrangeSchemeDr</Value>
</Value>
<Value name="2">
<Value>BPSADBPCADDr</Value>
</Value>
<Value name="3">
<Value>BPSADAmount</Value>
</Value>
<Value name="4">
<Value>BPSADFirstAmount</Value>
</Value>
<Value name="5">
<Value>BPSADDose</Value>
</Value>
<Value name="6">
<Value>BPSADFrequency</Value>
</Value>
<Value name="7">
<Value>BPSADNote</Value>
</Value>
<Value name="8">
<Value>BPSADIfAbandon</Value>
</Value>
<Value name="9">
<Value>BPSADOperationDate</Value>
</Value>
<Value name="10">
<Value>BPSADOperationTime</Value>
</Value>
<Value name="11">
<Value>BPSADDuration</Value>
</Value>
<Value name="12">
<Value>BPSADIntervalMinute</Value>
</Value>
<Value name="13">
<Value>BPSADUomDr</Value>
</Value>
<Value name="14">
<Value>BPSADSpeedUnitDr</Value>
</Value>
<Value name="15">
<Value>BPSADConcentration</Value>
</Value>
<Value name="16">
<Value>BPSADLastReservation</Value>
</Value>
</Data>
<DataLocation>^DHCBPSchemeAnticoagulantDrug</DataLocation>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCBPSchemeAnticoagulantDrug</IdLocation>
<IndexLocation>^DHCBPSchemeAnticoagulantDrug(0)</IndexLocation>
<StreamLocation>^DHCBPSchemeAnticoagulantDrugS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
