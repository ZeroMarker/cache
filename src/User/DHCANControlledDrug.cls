Class User.DHCANControlledDrug Extends %Persistent [ Owner = {_SYSTEM}, SqlTableName = DHC_AN_ControlledDrug, StorageStrategy = CacheNewStorage ]
{

Property ANCDADMDr As %String [ SqlColumnNumber = 2, SqlFieldName = ANCD_ADM_Dr ];

Property ANCDOPADr As %String [ SqlColumnNumber = 3, SqlFieldName = ANCD_OPA_Dr ];

/// 残余药品
Property ANCDOeoriDr As %String [ SqlColumnNumber = 4, SqlFieldName = ANCD_Oeori_Dr ];

/// 批号
Property ANCDLotNumber As %String [ SqlColumnNumber = 5, SqlFieldName = ANCD_LotNumber ];

/// 执行人
Property ANCDExecUserDr As %String [ SqlColumnNumber = 6, SqlFieldName = ANCD_ExecUser_Dr ];

/// 执行日期
Property ANCDExecDate As %Date [ SqlColumnNumber = 7, SqlFieldName = ANCD_ExecDate ];

/// 执行时间
Property ANCDExecTime As %Time [ SqlColumnNumber = 8, SqlFieldName = ANCD_ExecTime ];

/// 残余量
Property ANCDResidualQty As %Float [ SqlColumnNumber = 9, SqlFieldName = ANCD_ResidualQty ];

/// 残余药液处置措施
Property ANCDResidualDisposal As %String [ SqlColumnNumber = 10, SqlFieldName = ANCD_ResidualDisposal ];

/// 处置\接收人
Property ANCDDisposalUserDr As %String [ SqlColumnNumber = 11, SqlFieldName = ANCD_DisposalUser_Dr ];

/// 处置\接收日期
Property ANCDDisposalDate As %Date [ SqlColumnNumber = 12, SqlFieldName = ANCD_DisposalDate ];

/// 处置\接收时间
Property ANCDDisposalTime As %Time [ SqlColumnNumber = 13, SqlFieldName = ANCD_DisposalTime ];

/// 复核人
Property ANCDCheckUserDr As %String [ SqlColumnNumber = 14, SqlFieldName = ANCD_CheckUser_Dr ];

/// 复核日期
Property ANCDCheckDate As %Date [ SqlColumnNumber = 15, SqlFieldName = ANCD_CheckDate ];

/// 复核时间
Property ANCDCheckTime As %Time [ SqlColumnNumber = 16, SqlFieldName = ANCD_CheckTime ];

/// 用药量
Property ANCDUsedQty As %Float [ SqlColumnNumber = 17, SqlFieldName = ANCD_UsedQty ];

/// 用药量单位
Property ANCDUomDr As %String [ SqlColumnNumber = 18, SqlFieldName = ANCD_Uom_Dr ];

/// 药品数量
Property ANCDDrugAmount As %Float [ SqlColumnNumber = 19, SqlFieldName = ANCD_DrugAmount ];

/// 药品数量单位
Property ANCDUnitDr As %String [ SqlColumnNumber = 20, SqlFieldName = ANCD_Unit_Dr ];

/// 备注
Property ANCDNote As %String [ SqlColumnNumber = 21, SqlFieldName = ANCD_Note ];

/// 处方医师
Property ANCDOrderDoc As %String [ SqlColumnNumber = 22, SqlFieldName = ANCD_OrderDoc ];

/// 残余药品
Property ANCDOeoriDesc As %String [ SqlColumnNumber = 23, SqlFieldName = ANCD_Oeori_Desc ];

Index ADM On ANCDADMDr As Exact;

Index OPA On ANCDOPADr As Exact;

Storage CacheNewStorage
{
<Data name="DHCANControlledDrugClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCANControlledDrugDefaultData">
<Value name="1">
<Value>ANCDADMDr</Value>
</Value>
<Value name="2">
<Value>ANCDOPADr</Value>
</Value>
<Value name="3">
<Value>ANCDOeoriDr</Value>
</Value>
<Value name="4">
<Value>ANCDLotNumber</Value>
</Value>
<Value name="5">
<Value>ANCDExecUserDr</Value>
</Value>
<Value name="6">
<Value>ANCDExecDate</Value>
</Value>
<Value name="7">
<Value>ANCDExecTime</Value>
</Value>
<Value name="8">
<Value>ANCDResidualQty</Value>
</Value>
<Value name="9">
<Value>ANCDResidualDisposal</Value>
</Value>
<Value name="10">
<Value>ANCDDisposalUserDr</Value>
</Value>
<Value name="11">
<Value>ANCDDisposalDate</Value>
</Value>
<Value name="12">
<Value>ANCDDisposalTime</Value>
</Value>
<Value name="13">
<Value>ANCDCheckUserDr</Value>
</Value>
<Value name="14">
<Value>ANCDCheckDate</Value>
</Value>
<Value name="15">
<Value>ANCDCheckTime</Value>
</Value>
<Value name="16">
<Value>ANCDUsedQty</Value>
</Value>
<Value name="17">
<Value>ANCDUomDr</Value>
</Value>
<Value name="18">
<Value>ANCDDrugAmount</Value>
</Value>
<Value name="19">
<Value>ANCDUnitDr</Value>
</Value>
<Value name="20">
<Value>ANCDNote</Value>
</Value>
<Value name="21">
<Value>ANCDOrderDoc</Value>
</Value>
<Value name="22">
<Value>ANCDOeoriDesc</Value>
</Value>
</Data>
<DataLocation>^DHCANControlledDrug</DataLocation>
<DefaultData>DHCANControlledDrugDefaultData1</DefaultData>
<IdLocation>^DHCANControlledDrug</IdLocation>
<IndexLocation>^DHCANControlledDrug(0)</IndexLocation>
<StreamLocation>^User.DHCANControlledDrugS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
