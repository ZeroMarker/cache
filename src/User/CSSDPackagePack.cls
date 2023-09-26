Class User.CSSDPackagePack Extends (%Persistent, User.Abstract) [ SqlRowIdName = CSSDPP_Rowid, SqlTableName = CSSD_PackagePack ]
{

Property CSSDPPDate As %Date [ SqlColumnNumber = 2, SqlFieldName = CSSDPP_Date ];

Property CSSDPPLabel As %String(COLLATION = "Exact") [ SqlColumnNumber = 3, SqlFieldName = CSSDPP_Label ];

Property CSSDPPLocDr As User.CTLoc [ SqlColumnNumber = 4, SqlFieldName = CSSDPP_Loc_DR ];

Property CSSDPPMachineDR As User.CSSDMachineConfig [ SqlColumnNumber = 5, SqlFieldName = CSSDPP_Machine_DR ];

Property CSSDPPQty As %String(COLLATION = "Exact", TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = CSSDPP_Qty ];

Property CSSDPPHeatNo As %Integer [ SqlColumnNumber = 7, SqlFieldName = CSSDPP_HeatNo ];

Property CSSDPPTime As %Time [ SqlColumnNumber = 8, SqlFieldName = CSSDPP_Time ];

Property CSSDPPUserDr As User.SSUser [ SqlColumnNumber = 9, SqlFieldName = CSSDPP_User_DR ];

Property CSSDPPSerialNo As %String(COLLATION = "Exact") [ Required, SqlColumnNumber = 10, SqlFieldName = CSSDPP_SerialNo ];

Property CSSDPPAckUserDr As User.SSUser [ SqlColumnNumber = 11, SqlFieldName = CSSDPP_AckUser_DR ];

Property CSSDPPAckDate As %Date [ SqlColumnNumber = 12, SqlFieldName = CSSDPP_AckDate ];

Property CSSDPPPackage As User.CSSDPackage [ SqlColumnNumber = 13, SqlFieldName = CSSDPP_Package_DR ];

Property CSSDPPIsLoadSteCar As %Library.Boolean [ SqlColumnNumber = 14, SqlFieldName = CSSDPP_IsLoadSteCar ];

/// 申请科室
Property CSSDPPApplyLoc As User.CTLoc [ SqlColumnNumber = 15, SqlFieldName = CSSDPP_ApplyLoc ];

/// 指向请领明细表
Property CSSDPPApplyDetailDr As User.CSSDPackageApplyDetail [ SqlColumnNumber = 16, SqlFieldName = CSSDPP_ApplyDetailDr ];

/// 单据号
Property CSSDPPApplyNo As %String(COLLATION = "Exact") [ SqlColumnNumber = 17, SqlFieldName = CSSDPP_ApplyNo ];

/// 指向回收明细表
Property CSSDPPCallDetailDr As User.CSSDCallbackDetailNew [ SqlColumnNumber = 18, SqlFieldName = CSSDPP_CallBackDetailDr ];

/// 生成的标签所对应的发放科室 默认为消毒包维护中的科室 
Property CSSDPPPackLocDr As User.CTLoc [ SqlColumnNumber = 19, SqlFieldName = CSSDPP_PackLocDR ];

/// 外来器械分包条码(外来器械绑定的固定标签)
Property CSSDPPNewLabel As %String(COLLATION = "Exact") [ SqlColumnNumber = 20, SqlFieldName = CSSDPP_NewLabel ];

/// 绿色通道标志
Property CSSDPPGreenFlag As %String(COLLATION = "Exact") [ SqlColumnNumber = 21, SqlFieldName = CSSDPP_GreenFlag ];

/// 配包人
Property CSSDPPPackUserDr As User.SSUser [ SqlColumnNumber = 22, SqlFieldName = CSSDPP_PackUser_DR ];

/// 外来器械绑定的固定标签
Property CSSDPPExtLabel As %String(COLLATION = "Exact") [ SqlColumnNumber = 23, SqlFieldName = CSSDPP_ExtLabel ];

/// 包装材料ID
Property CSSDPPMaterialDr As User.CSSDMaterial [ SqlColumnNumber = 24, SqlFieldName = CSSDPP_Material_DR ];

Property CSSDPPLevelFlag As %String(COLLATION = "Exact") [ SqlColumnNumber = 25, SqlFieldName = CSSDPP_LevelFlag ];

/// 备注
Property CSSDPPRemark As %String(COLLATION = "Exact") [ SqlColumnNumber = 26, SqlFieldName = CSSDPP_Remark ];

/// 灭菌人
Property CSSDPPSterUserDr As User.SSUser [ SqlColumnNumber = 27, SqlFieldName = CSSDPP_SterUser_DR ];

/// 固定标签
Property CSSDPPFixedLabel As User.CSSDCodeDict [ SqlColumnNumber = 28, SqlFieldName = CSSDPP_FixedLabel ];

/// 内部包装数
Property CSSDPPPackNum As %String(COLLATION = "Exact") [ SqlColumnNumber = 29, SqlFieldName = CSSDPP_PackNum ];

/// 打印次数
Property CSSDPPPrtTimes As %Integer [ SqlColumnNumber = 30, SqlFieldName = CSSDPP_PrtTimes ];

/// 清洗主表的dr
Property CSSDPPCleanDR As User.CSSDClean [ SqlColumnNumber = 31, SqlFieldName = CSSDPP_Clean_DR ];

/// 记录清洗明细表的dr
Property CSSDPPCleanDetailDR As User.CSSDCleanDetailPacks [ SqlColumnNumber = 32, SqlFieldName = CSSDPP_CleanDetail_DR ];

/// 清洗架标牌
Property CSSDPPBasketCode As %String(COLLATION = "Exact") [ SqlColumnNumber = 33, SqlFieldName = CSSDPP_BasketCode ];

/// 灭菌时间
Property CSSDPPSterTime As %Time [ SqlColumnNumber = 34, SqlFieldName = CSSDPP_SterTime ];

Index CSSDPPSerialNoIndex On CSSDPPSerialNo As Exact;

Index CSSDPPLocDateIndex On (CSSDPPLocDr As Exact, CSSDPPDate As Exact);

Index CSSDPPLabelIndex On CSSDPPLabel As Exact;

Index IndexCSSDPPDate On CSSDPPDate As Exact;

Index IndexCSSDPPAckDate On CSSDPPAckDate As Exact;

Index CSSDPPNewLabelIndex On CSSDPPNewLabel As Exact;

Index CSSDPPIsLoadSteCarIndex On CSSDPPIsLoadSteCar As Exact;

Index CallBackDetail On CSSDPPCallDetailDr As Exact;

Index CodeDict On CSSDPPFixedLabel As Exact;

Index CSSDPPCleanDRPrtTimes On (CSSDPPCleanDR As Exact, CSSDPPPrtTimes As Exact);

Index CSSDPPCleanIndex On (CSSDPPCleanDR As Exact, CSSDPPPackage As Exact, CSSDPPBasketCode As Exact);

Index CSSDPPCleanDrPackageDrIndex On (CSSDPPCleanDR As Exact, CSSDPPCleanDetailDR As Exact, CSSDPPPackage As Exact);

Storage Default
{
<Data name="CSSDPackagePackDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CSSDPPDate</Value>
</Value>
<Value name="3">
<Value>CSSDPPLabel</Value>
</Value>
<Value name="4">
<Value>CSSDPPLocDr</Value>
</Value>
<Value name="5">
<Value>CSSDPPMachineDR</Value>
</Value>
<Value name="6">
<Value>CSSDPPQty</Value>
</Value>
<Value name="7">
<Value>CSSDPPHeatNo</Value>
</Value>
<Value name="8">
<Value>CSSDPPTime</Value>
</Value>
<Value name="9">
<Value>CSSDPPUserDr</Value>
</Value>
<Value name="10">
<Value>CSSDPPSerialNo</Value>
</Value>
<Value name="11">
<Value>CSSDPPAckUserDr</Value>
</Value>
<Value name="12">
<Value>CSSDPPAckDate</Value>
</Value>
<Value name="13">
<Value>CSSDPPPackage</Value>
</Value>
<Value name="14">
<Value>CSSDPPIsLoadSteCar</Value>
</Value>
<Value name="15">
<Value>CSSDPPApplyLoc</Value>
</Value>
<Value name="16">
<Value>CSSDPPApplyDetailDr</Value>
</Value>
<Value name="17">
<Value>CSSDPPApplyNo</Value>
</Value>
<Value name="18">
<Value>CSSDPPCallDetailDr</Value>
</Value>
<Value name="19">
<Value>CSSDPPPackLocDr</Value>
</Value>
<Value name="20">
<Value>CSSDPPNewLabel</Value>
</Value>
<Value name="21">
<Value>CSSDPPGreenFlag</Value>
</Value>
<Value name="22">
<Value>CSSDPPPackUserDr</Value>
</Value>
<Value name="23">
<Value>CSSDPPExtLabel</Value>
</Value>
<Value name="24">
<Value>CSSDPPMaterialDr</Value>
</Value>
<Value name="25">
<Value>CSSDPPLevelFlag</Value>
</Value>
<Value name="26">
<Value>CSSDPPRemark</Value>
</Value>
<Value name="27">
<Value>CSSDPPSterUserDr</Value>
</Value>
<Value name="28">
<Value>CSSDPPFixedLabel</Value>
</Value>
<Value name="29">
<Value>CSSDPPPackNum</Value>
</Value>
<Value name="30">
<Value>CSSDPPPrtTimes</Value>
</Value>
<Value name="31">
<Value>CSSDPPCleanDetailDR</Value>
</Value>
<Value name="32">
<Value>CSSDPPCleanDR</Value>
</Value>
<Value name="33">
<Value>CSSDPPBasketCode</Value>
</Value>
<Value name="34">
<Value>CSSDPPSterTime</Value>
</Value>
</Data>
<DataLocation>^User.CSSDPackagePackD</DataLocation>
<DefaultData>CSSDPackagePackDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.CSSDPackagePackD</IdLocation>
<IndexLocation>^User.CSSDPackagePackI</IndexLocation>
<SqlRowIdName>CSSDPP_Rowid</SqlRowIdName>
<StreamLocation>^User.CSSDPackagePackS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
