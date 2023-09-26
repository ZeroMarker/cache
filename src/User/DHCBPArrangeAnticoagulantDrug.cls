Class User.DHCBPArrangeAnticoagulantDrug Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = BPAAD_RowId, SqlTableName = DHC_BP_ArrangeAnticoagulantDrug, StorageStrategy = CacheStorage ]
{

Index Arrange On BPAADBPArrangeDr;

Property BPAADBPArrangeDr As User.DHCBPArrange [ SqlColumnNumber = 2, SqlFieldName = BPAAD_BPArrange_Dr ];

Property BPAADBPCADDr As User.DHCBPCAnticoagulantDrug [ SqlColumnNumber = 3, SqlFieldName = BPAAD_BPCAD_Dr ];

/// 总量
Property BPAADAmount As %Float [ SqlColumnNumber = 4, SqlFieldName = BPAAD_Amount ];

/// 首推量
Property BPAADFirstAmount As %Float [ SqlColumnNumber = 5, SqlFieldName = BPAAD_FirstAmount ];

/// 剂量
Property BPAADDose As %Float [ SqlColumnNumber = 6, SqlFieldName = BPAAD_Dose ];

/// 频率
Property BPAADFrequency As %Float [ SqlColumnNumber = 7, SqlFieldName = BPAAD_Frequency ];

/// 备注
Property BPAADNote As %String [ SqlColumnNumber = 8, SqlFieldName = BPAAD_Note ];

/// 是否废弃
Property BPAADIfAbandon As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = BPAAD_IfAbandon ];

/// 操作日期
Property BPAADOperationDate As %Date [ SqlColumnNumber = 10, SqlFieldName = BPAAD_OperationDate ];

/// 操作时间
Property BPAADOperationTime As %Time [ SqlColumnNumber = 11, SqlFieldName = BPAAD_OperationTime ];

/// 持续时间
Property BPAADDuration As %Float [ SqlColumnNumber = 12, SqlFieldName = BPAAD_Duration ];

/// 间隔分钟
Property BPAADIntervalMinute As %Float [ SqlColumnNumber = 13, SqlFieldName = BPAAD_IntervalMinute ];

/// 用量单位
Property BPAADUomDr As %String [ SqlColumnNumber = 14, SqlFieldName = BPAAD_Uom_Dr ];

/// 剂量单位
Property BPAADSpeedUnitDr As User.DHCBPCSpeedUnit [ SqlColumnNumber = 15, SqlFieldName = BPAAD_SpeedUnit_Dr ];

/// 处置作用(腹透)
Property BPAADLastReservation As %String(DISPLAYLIST = ",LastNight,PRN,WashPipe", MAXLEN = 10, SELECTIVITY = "25%", VALUELIST = ",L,P,W") [ SqlColumnNumber = 16, SqlFieldName = BPAAD_LastReservation ];

Storage CacheStorage
{
<Data name="DHCBPArrangeAnticoagulantDrugClass">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCBPArrangeAnticoagulantDrugData">
<Value name="1">
<Value>BPAADBPArrangeDr</Value>
</Value>
<Value name="2">
<Value>BPAADBPCADDr</Value>
</Value>
<Value name="3">
<Value>BPAADAmount</Value>
</Value>
<Value name="4">
<Value>BPAADFirstAmount</Value>
</Value>
<Value name="5">
<Value>BPAADDose</Value>
</Value>
<Value name="6">
<Value>BPAADFrequency</Value>
</Value>
<Value name="7">
<Value>BPAADNote</Value>
</Value>
<Value name="8">
<Value>BPAADIfAbandon</Value>
</Value>
<Value name="9">
<Value>BPAADOperationDate</Value>
</Value>
<Value name="10">
<Value>BPAADOperationTime</Value>
</Value>
<Value name="11">
<Value>BPAADDuration</Value>
</Value>
<Value name="12">
<Value>BPAADIntervalMinute</Value>
</Value>
<Value name="13">
<Value>BPAADUomDr</Value>
</Value>
<Value name="14">
<Value>BPAADSpeedUnitDr</Value>
</Value>
<Value name="15">
<Value>BPAADLastReservation</Value>
</Value>
</Data>
<DataLocation>^DHCBPArrangeAnticoagulantDrug</DataLocation>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCBPArrangeAnticoagulantDrug</IdLocation>
<IndexLocation>^DHCBPArrangeAnticoagulantDrug(0)</IndexLocation>
<StreamLocation>^DHCBPArrangeAnticoagulantDrugS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
