/// Description: 毒麻药品登记/回收表(一条执行记录对应一条数据)
/// Creator: 	 Huxt 2020-09-27
/// d ##class(User.PHAINNarcRecord).%BuildIndices()
Class User.PHAINNarcRecord Extends %Persistent [ SqlRowIdName = PINR_RowId, SqlTableName = PHAIN_NarcRecord ]
{

/// 索引
Index Adm On PINRAdmDR As Exact;

Index OEORE On PINROEOREDR As Exact;

Index RegDate On PINRRegDate As Exact;

Index DspAddDate On PINRDspAddDate As Exact;

Index DosingDate On PINRDosingDate As Exact;

Index DispDate On PINRDispDate As Exact;

/// ===============
/// 指向子表(记录回收信息)
Relationship ChildPHAINNarcRecordRec As User.PHAINNarcRecordRec [ Cardinality = children, Inverse = PINRRParRef ];

/// ===============
/// 就诊ID
Property PINRAdmDR As User.PAAdm [ SqlColumnNumber = 2, SqlFieldName = PINR_Adm_DR ];

/// 就诊类型
Property PINRAdmType As %String(COLLATION = "Exact", MAXLEN = 3) [ SqlColumnNumber = 3, SqlFieldName = PINR_AdmType ];

/// 患者科室
Property PINRPatLocDR As User.CTLoc [ SqlColumnNumber = 4, SqlFieldName = PINR_PatLoc_DR ];

/// 患者病区
Property PINRPatWardDR As User.CTLoc [ SqlColumnNumber = 5, SqlFieldName = PINR_PatWard_DR ];

/// 主管医师
Property PINRMainDocDR As User.SSUser [ SqlColumnNumber = 6, SqlFieldName = PINR_MainDoc_DR ];

/// 麻醉医师
Property PINRNarcDocDR As User.SSUser [ SqlColumnNumber = 7, SqlFieldName = PINR_NarcDoc_DR ];

/// 手术间
Property PINROperRoom As %String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 8, SqlFieldName = PINR_OperRoom ];

/// ===============
/// 药品编号
Property PINRINCINo As %String(COLLATION = "Exact", MAXLEN = 80) [ SqlColumnNumber = 9, SqlFieldName = PINR_INCINo ];

/// 药品批号
Property PINRINCIBatchNo As %String(COLLATION = "Exact", MAXLEN = 80) [ SqlColumnNumber = 10, SqlFieldName = PINR_INCIBatchNo ];

/// 执行记录ID
Property PINROEOREDR As User.OEOrdExec [ SqlColumnNumber = 11, SqlFieldName = PINR_OEORE_DR ];

/// 用药登记科室(药房or科室)
Property PINRRegLocDR As User.CTLoc [ SqlColumnNumber = 12, SqlFieldName = PINR_RegLoc_DR ];

/// 用药登记人
Property PINRRegUserDR As User.SSUser [ SqlColumnNumber = 13, SqlFieldName = PINR_RegUser_DR ];

/// 用药登记日期
Property PINRRegDate As %Date [ SqlColumnNumber = 14, SqlFieldName = PINR_RegDate ];

/// 用药登记时间
Property PINRRegTime As %Time [ SqlColumnNumber = 15, SqlFieldName = PINR_RegTime ];

/// ===============
/// 领药人
Property PINRDispRecUserDR As User.SSUser [ SqlColumnNumber = 16, SqlFieldName = PINR_DispRecUser_DR ];

/// 领药日期
Property PINRDispDate As %Date [ SqlColumnNumber = 17, SqlFieldName = PINR_DispDate ];

/// 领药时间
Property PINRDispTime As %Time [ SqlColumnNumber = 18, SqlFieldName = PINR_DispTime ];

/// 实际发药批号
Property PINRDispBatchNo As %String(COLLATION = "Exact", MAXLEN = 80) [ SqlColumnNumber = 19, SqlFieldName = PINR_DispBatchNo ];

/// 麻醉药品编号
Property PINRDispINCINo As %String [ SqlColumnNumber = 20, SqlFieldName = PINR_DispINCINo ];

/// 门诊发药子表ID
Property PINRPHDIDR As User.DHCPHDISITEM [ SqlColumnNumber = 21, SqlFieldName = PINR_PHDI_DR ];

/// 住院发药子表ID
Property PINRPACIDR As User.DHCPHACollectItm [ SqlColumnNumber = 22, SqlFieldName = PINR_PACI_DR ];

/// 库存项ID (方便统计)
Property PINRRINCIDR As User.INCItm [ SqlColumnNumber = 23, SqlFieldName = PINR_INCI_DR ];

/// 科室库存批次ID (方便统计)
Property PINRRINCLBDR As User.INCItmLcBt [ SqlColumnNumber = 24, SqlFieldName = PINR_INCLB_DR ];

/// 用药登记备注
Property PINRRemarks As %String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 25, SqlFieldName = PINR_Remarks ];

/// 领药人身份证号
Property PINRDispRecUserIDNo As %String(COLLATION = "Exact", MAXLEN = 30) [ SqlColumnNumber = 26, SqlFieldName = PINR_DispRecUserIDNo ];

/// 手术间ID
Property PINROperRoomDR As User.DHCANCOperRoom [ SqlColumnNumber = 27, SqlFieldName = PINR_OperRoom_DR ];

/// 开医嘱日期 (有些医院要按此日期统计)
Property PINRDspAddDate As %Date [ SqlColumnNumber = 28, SqlFieldName = PINR_DspAddDate ];

/// 预计用药日期 (有些医院要按此日期统计)
Property PINRDosingDate As %Date [ SqlColumnNumber = 29, SqlFieldName = PINR_DosingDate ];

/// 实际用药量
Property PINRUseQty As %Float [ SqlColumnNumber = 30, SqlFieldName = PINR_UseQty ];

/// 实际用药量单位 (与医嘱剂量单位一致)
Property PINRUseUom As User.CTUOM [ SqlColumnNumber = 31, SqlFieldName = PINR_UseUom ];

/// 用药登记确认人
Property PINRRegCheckUserDR As User.SSUser [ SqlColumnNumber = 32, SqlFieldName = PINR_RegCheckUser_DR ];

/// 这条记录当前状态 (空或N-未登记/Y-已登记/C-撤销登记)
Property PINRStatus As %String(COLLATION = "EXACT", DISPLAYLIST = ",Yes,No,Cancel", MAXLEN = 6, SELECTIVITY = "25%", TRUNCATE = 1, VALUELIST = ",Y,N,C") [ SqlColumnNumber = 33, SqlFieldName = PINR_Status ];

/// 撤销登记人
Property PINRCancelUserDR As User.SSUser [ SqlColumnNumber = 34, SqlFieldName = PINR_CancelUser_DR ];

/// 撤销登记日期
Property PINRCancelDate As %Date [ SqlColumnNumber = 35, SqlFieldName = PINR_CancelDate ];

/// 撤销登记时间
Property PINRCancelTime As %Time [ SqlColumnNumber = 36, SqlFieldName = PINR_CancelTime ];

/// 麻醉机编号
Property PINRMachineCode As %String(COLLATION = "Exact", MAXLEN = 80) [ SqlColumnNumber = 37, SqlFieldName = PINR_MachineCode ];

/// 领药科室
Property PINRDispRecLocDR As User.CTLoc [ SqlColumnNumber = 38, SqlFieldName = PINR_DispRecLoc_DR ];

/// 用药批次ID (预留)
Property PINRINCIBDR As User.INCItmBat [ SqlColumnNumber = 39, SqlFieldName = PINR_INCIB_DR ];

Storage Default
{
<Data name="PHAINNarcRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PINRAdmDR</Value>
</Value>
<Value name="3">
<Value>PINRAdmType</Value>
</Value>
<Value name="4">
<Value>PINRPatLocDR</Value>
</Value>
<Value name="5">
<Value>PINRPatWardDR</Value>
</Value>
<Value name="6">
<Value>PINRMainDocDR</Value>
</Value>
<Value name="7">
<Value>PINRNarcDocDR</Value>
</Value>
<Value name="8">
<Value>PINROperRoom</Value>
</Value>
<Value name="9">
<Value>PINRINCINo</Value>
</Value>
<Value name="10">
<Value>PINRINCIBatchNo</Value>
</Value>
<Value name="11">
<Value>PINROEOREDR</Value>
</Value>
<Value name="12">
<Value>PINRRegLocDR</Value>
</Value>
<Value name="13">
<Value>PINRRegUserDR</Value>
</Value>
<Value name="14">
<Value>PINRRegDate</Value>
</Value>
<Value name="15">
<Value>PINRRegTime</Value>
</Value>
<Value name="16">
<Value>PINRDispRecUserDR</Value>
</Value>
<Value name="17">
<Value>PINRDispDate</Value>
</Value>
<Value name="18">
<Value>PINRDispTime</Value>
</Value>
<Value name="19">
<Value>PINRDispBatchNo</Value>
</Value>
<Value name="20">
<Value>PINRDispINCINo</Value>
</Value>
<Value name="21">
<Value>PINRPHDIDR</Value>
</Value>
<Value name="22">
<Value>PINRPACIDR</Value>
</Value>
<Value name="23">
<Value>PINRRINCIDR</Value>
</Value>
<Value name="24">
<Value>PINRRINCLBDR</Value>
</Value>
<Value name="25">
<Value>PINRRemarks</Value>
</Value>
<Value name="26">
<Value>PINRDispRecUserIDNo</Value>
</Value>
<Value name="27">
<Value>PINROperRoomDR</Value>
</Value>
<Value name="28">
<Value>PINRDspAddDate</Value>
</Value>
<Value name="29">
<Value>PINRDosingDate</Value>
</Value>
<Value name="30">
<Value>PINRUseQty</Value>
</Value>
<Value name="31">
<Value>PINRUseUom</Value>
</Value>
<Value name="32">
<Value>PINRRegCheckUserDR</Value>
</Value>
<Value name="33">
<Value>PINRStatus</Value>
</Value>
<Value name="34">
<Value>PINRCancelUserDR</Value>
</Value>
<Value name="35">
<Value>PINRCancelDate</Value>
</Value>
<Value name="36">
<Value>PINRCancelTime</Value>
</Value>
<Value name="37">
<Value>PINRMachineCode</Value>
</Value>
<Value name="38">
<Value>PINRDispRecLocDR</Value>
</Value>
<Value name="39">
<Value>PINRINCIBDR</Value>
</Value>
</Data>
<DataLocation>^BS.PHA.IN.NarcRecord</DataLocation>
<DefaultData>PHAINNarcRecordDefaultData</DefaultData>
<IdLocation>^BS.PHA.IN.NarcRecord</IdLocation>
<IndexLocation>^BS.PHA.IN.NarcRecordI</IndexLocation>
<StreamLocation>^User.PHAINNarcRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
