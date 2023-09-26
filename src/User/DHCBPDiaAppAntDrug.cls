Class User.DHCBPDiaAppAntDrug Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = BPDAAD_RowId, SqlTableName = DHC_BP_DiaAppAntDrug, StorageStrategy = CacheStorage ]
{

Property BPDAADBPDialysisAppDr As User.DHCBPDialysisApp [ SqlColumnNumber = 2, SqlFieldName = BPDAAD_BPDialysisApp_Dr ];

Property BPDAADBPCADDr As User.DHCBPCAnticoagulantDrug [ SqlColumnNumber = 3, SqlFieldName = BPDAAD_BPCAD_Dr ];

/// 总量
Property BPDAADAmount As %Float [ SqlColumnNumber = 4, SqlFieldName = BPDAAD_Amount ];

/// 首推量
Property BPDAADFirstAmount As %Float [ SqlColumnNumber = 5, SqlFieldName = BPDAAD_FirstAmount ];

/// 剂量
Property BPDAADDose As %Float [ SqlColumnNumber = 6, SqlFieldName = BPDAAD_Dose ];

/// 频率
Property BPDAADFrequency As %Float [ SqlColumnNumber = 7, SqlFieldName = BPDAAD_Frequency ];

/// 备注
Property BPDAADNote As %String [ SqlColumnNumber = 8, SqlFieldName = BPDAAD_Note ];

/// 是否废弃
Property BPDAADIfAbandon As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = BPDAAD_IfAbandon ];

/// 操作日期
Property BPDAADOperationDate As %Date [ SqlColumnNumber = 10, SqlFieldName = BPDAAD_OperationDate ];

/// 操作时间
Property BPDAADOperationTime As %Time [ SqlColumnNumber = 11, SqlFieldName = BPDAAD_OperationTime ];

/// 持续时间
Property BPDAADDuration As %String [ SqlColumnNumber = 12, SqlFieldName = BPDAAD_Duration ];

/// 间隔分钟
Property BPDAADIntervalMinute As %String [ SqlColumnNumber = 13, SqlFieldName = BPDAAD_IntervalMinute ];

/// 用量单位
Property BPDAADUomDr As %String [ SqlColumnNumber = 14, SqlFieldName = BPDAAD_Uom_Dr ];

/// 剂量单位
Property BPDAADSpeedUnitDr As %String [ SqlColumnNumber = 15, SqlFieldName = BPDAAD_SpeedUnit_Dr ];

/// 浓度
Property BPDAADConcentration As %Float [ SqlColumnNumber = 16, SqlFieldName = BPDAAD_Concentration ];

/// 处置作用(腹透)
Property BPDAADLastReservation As %String(DISPLAYLIST = ",LastNight,PRN,WashPipe", MAXLEN = 10, SELECTIVITY = "25%", VALUELIST = ",L,P,W") [ SqlColumnNumber = 17, SqlFieldName = BPDAAD_LastReservation ];

Storage CacheStorage
{
<Data name="BPDiaAppAntDrugClass">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="BPDiaAppAntDrugData">
<Attribute>%%CLASSNAME</Attribute>
<Value name="1">
<Value>BPDAADBPDiaAppDr</Value>
</Value>
<Value name="2">
<Value>BPDAADBPCADDr</Value>
</Value>
<Value name="3">
<Value>BPDAADAmount</Value>
</Value>
<Value name="4">
<Value>BPDAADFirstAmount</Value>
</Value>
<Value name="5">
<Value>BPDAADDose</Value>
</Value>
<Value name="6">
<Value>BPDAADFrequency</Value>
</Value>
<Value name="7">
<Value>BPDAADNote</Value>
</Value>
<Value name="8">
<Value>BPDAADIfAbandon</Value>
</Value>
<Value name="9">
<Value>BPDAADOperationDate</Value>
</Value>
<Value name="10">
<Value>BPDAADOperationTime</Value>
</Value>
<Value name="11">
<Value>BPDAADDuration</Value>
</Value>
<Value name="12">
<Value>BPDAADIntervalMinute</Value>
</Value>
<Value name="13">
<Value>BPDAADUomDr</Value>
</Value>
<Value name="14">
<Value>BPDAADSpeedUnitDr</Value>
</Value>
<Value name="15">
<Value>BPDAADConcentration</Value>
</Value>
<Value name="16">
<Value>BPDAADLastReservation</Value>
</Value>
</Data>
<Data name="DHCBPDiaAppAntDrugDefaultData">
<Subscript>"1"</Subscript>
<Value name="1">
<Value>BPDAADBPDialysisAppDr</Value>
</Value>
</Data>
<DataLocation>^DHCBPDiaAppAntDrug</DataLocation>
<DefaultData>DHCBPDiaAppAntDrugDefaultData</DefaultData>
<IdLocation>^DHCBPDiaAppAntDrug</IdLocation>
<IndexLocation>^DHCBPDiaAppAntDrug(0)</IndexLocation>
<StreamLocation>^DHCBPDiaAppAntDrugS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
