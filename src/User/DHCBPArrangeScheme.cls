Class User.DHCBPArrangeScheme Extends %Persistent [ Owner = {_SYSTEM}, SqlTableName = DHC_BP_ArrangeScheme, StorageStrategy = CacheStorage ]
{

Property BPASBPPatRegisterDr As User.DHCBPPatRegister [ SqlColumnNumber = 2, SqlFieldName = BPAS_BPPatRegister_Dr ];

Property BPASBPSchemeDr As User.DHCBPScheme [ SqlColumnNumber = 3, SqlFieldName = BPAS_BPScheme_Dr ];

Property BPASBPCBPModeDr As User.DHCBPCBloodPurificationMode [ SqlColumnNumber = 4, SqlFieldName = BPAS_BPCBPMode_Dr ];

Property BPASSecondBPCBPModeDr As User.DHCBPCBloodPurificationMode [ SqlColumnNumber = 5, SqlFieldName = BPAS_SecondBPCBPMode_Dr ];

Property BPASBedDr As User.DHCBPCBed [ SqlColumnNumber = 6, SqlFieldName = BPAS_BedDr ];

Property BPASWeekSeqNo As %Integer [ SqlColumnNumber = 7, SqlFieldName = BPAS_WeekSeqNo ];

Property BPASWeekDay As %Integer [ SqlColumnNumber = 8, SqlFieldName = BPAS_WeekDay ];

Property BPASDaySeqNo As %String(DISPLAYLIST = ",AM,PM,Evening", MAXLEN = 7, SELECTIVITY = "25%", VALUELIST = ",A,P,E") [ SqlColumnNumber = 9, SqlFieldName = BPAS_DaySeqNo ];

Property BPASIfActive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = BPAS_IfActive ];

Property BPASEffectDate As %Date [ SqlColumnNumber = 11, SqlFieldName = BPAS_EffectDate ];

Property BPASMainBPASDr As User.DHCBPArrangeScheme [ SqlColumnNumber = 12, SqlFieldName = BPAS_MainBPAS_Dr ];

/// 血液净化材料
Property BPASBPCConsumableDr As User.DHCBPCConsumable [ SqlColumnNumber = 13, SqlFieldName = BPAS_BPCConsumable_Dr ];

Property BPASSecondBPCConsumableDr As User.DHCBPCConsumable [ SqlColumnNumber = 14, SqlFieldName = BPAS_SecondBPCConsumable_Dr ];

Property BPASThirdBPCConsumableDr As User.DHCBPCConsumable [ SqlColumnNumber = 15, SqlFieldName = BPAS_ThirdBPCConsumable_Dr ];

Property BPASFourthBPCConsumableDr As User.DHCBPCConsumable [ SqlColumnNumber = 16, SqlFieldName = BPAS_FourthBPCConsumable_Dr ];

Property BPASTherapyDuration As %Float [ SqlColumnNumber = 17, SqlFieldName = BPAS_TherapyDuration ];

Property BPASIfAbandon As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 18, SqlFieldName = BPAS_IfAbandon ];

/// 抗凝方案指针
Property BPASAnticoagulantModeDr As User.DHCBPCAnticoagulantMode [ SqlColumnNumber = 19, SqlFieldName = BPAS_AnticoagulantMode_Dr ];

/// 是否为临时方案制定
Property BPASIsTemporary As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 20, SqlFieldName = BPAS_IsTemporary ];

/// 血滤置换液输入方式（前稀释，后稀释）
Property BPASFilterReplaceMode As %String [ SqlColumnNumber = 21, SqlFieldName = BPAS_FilterReplaceMode ];

/// 血滤置换量
Property BPASFilterReplaceAmount As %Float [ SqlColumnNumber = 22, SqlFieldName = BPAS_FilterReplaceAmount ];

/// 透析总量(腹透)
Property BPASDialysateAmount As %Float [ SqlColumnNumber = 23, SqlFieldName = BPAS_DialysateAmount ];

/// 单次注入量(腹透)
Property BPASSingleInAmount As %Float [ SqlColumnNumber = 24, SqlFieldName = BPAS_SingleInAmount ];

/// 交换次数(腹透)
Property BPASExchangeTimes As %Float [ SqlColumnNumber = 25, SqlFieldName = BPAS_ExchangeTimes ];

/// 最末袋保留(腹透)
Property BPASTheLastReservation As %Float [ SqlColumnNumber = 26, SqlFieldName = BPAS_TheLastReservation ];

/// 腹透机透析总量(腹透)
Property BPASTotalAmountOfMachine As %Float [ SqlColumnNumber = 27, SqlFieldName = BPAS_TotalAmountOfMachine ];

Index Register On BPASBPPatRegisterDr;

Index Scheme On BPASBPSchemeDr;

Index BedDay On (BPASBedDr, BPASIfActive As Exact, BPASWeekDay);

Storage CacheStorage
{
<Data name="DHCBPArrangeSchemeClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCBPArrangeSchemeDefaultData">
<Attribute>BPASWeekDay</Attribute>
<Value name="1">
<Value>BPASBPPatRegisterDr</Value>
</Value>
<Value name="2">
<Value>BPASBPSchemeDr</Value>
</Value>
<Value name="3">
<Value>BPASBPCBPModeDr</Value>
</Value>
<Value name="4">
<Value>BPASSecondBPCBPModeDr</Value>
</Value>
<Value name="5">
<Value>BPASBedDr</Value>
</Value>
<Value name="6">
<Value>BPASWeekSeqNo</Value>
</Value>
<Value name="7">
<Value>BPASWeekDay</Value>
</Value>
<Value name="8">
<Value>BPASDaySeqNo</Value>
</Value>
<Value name="9">
<Value>BPASIfActive</Value>
</Value>
<Value name="10">
<Value>BPASEffectDate</Value>
</Value>
<Value name="11">
<Value>BPASMainBPASDr</Value>
</Value>
<Value name="12">
<Value>BPASBPCConsumableDr</Value>
</Value>
<Value name="13">
<Value>BPASSecondBPCConsumableDr</Value>
</Value>
<Value name="14">
<Value>BPASThirdBPCConsumableDr</Value>
</Value>
<Value name="15">
<Value>BPASFourthBPCConsumableDr</Value>
</Value>
<Value name="16">
<Value>BPASTherapyDuration</Value>
</Value>
<Value name="17">
<Value>BPASIfAbandon</Value>
</Value>
<Value name="18">
<Value>BPASAnticoagulantModeDr</Value>
</Value>
<Value name="19">
<Value>BPASIsTemporary</Value>
</Value>
<Value name="20">
<Value>BPASFilterReplaceMode</Value>
</Value>
<Value name="21">
<Value>BPASFilterReplaceAmount</Value>
</Value>
<Value name="22">
<Value>BPASDialysateAmount</Value>
</Value>
<Value name="23">
<Value>BPASSingleInAmount</Value>
</Value>
<Value name="24">
<Value>BPASExchangeTimes</Value>
</Value>
<Value name="25">
<Value>BPASTheLastReservation</Value>
</Value>
<Value name="26">
<Value>BPASTotalAmountOfMachine</Value>
</Value>
</Data>
<DataLocation>^DHCBPArrangeScheme</DataLocation>
<DefaultData>DHCBPArrangeSchemeDefaultData1</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCBPArrangeScheme</IdLocation>
<IndexLocation>^DHCBPArrangeScheme(0)</IndexLocation>
<StreamLocation>^User.DHCBPArrangeSchemeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
