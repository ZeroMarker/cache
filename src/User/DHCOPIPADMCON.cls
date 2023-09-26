Class User.DHCOPIPADMCON Extends %Library.Persistent [ Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = OCI_RowId, SqlTableName = DHC_OPIPADMCON, StorageStrategy = SQLStorage ]
{

/// 患者主索引  OCI_PAPMI_DR
Property OCIPAPMIDR As User.PAPatMas [ Required, SqlColumnNumber = 2, SqlFieldName = OCI_PAPMI_DR ];

/// 门诊就诊rowid  OCI_OP_Adm_DR
Property OCIOPAdmDR As User.PAAdm [ Required, SqlColumnNumber = 3, SqlFieldName = OCI_OP_Adm_DR ];

/// 住院就诊rowid  OCI_IP_Adm_DR
Property OCIIPAdmDR As User.PAAdm [ Required, SqlColumnNumber = 4, SqlFieldName = OCI_IP_Adm_DR ];

/// 门诊发票表rowid  OCI_InvPrt_DR
Property OCIInvPrtDR As User.DHCINVPRT [ Required, SqlColumnNumber = 5, SqlFieldName = OCI_InvPrt_DR ];

/// 集中打印发票表rowid  OCI_AccPayInv_DR
Property OCIAccPayInvDR As User.DHCAccPayINV [ SqlColumnNumber = 6, SqlFieldName = OCI_AccPayInv_DR ];

/// 门诊医嘱rowid  OCI_OEORI_DR
Property OCIOEORIDR As User.OEOrdItem [ Required, SqlColumnNumber = 7, SqlFieldName = OCI_OEORI_DR ];

/// 状态  OCI_Status (N：正常，C:撤回)
Property OCIStatus As %Library.String(DISPLAYLIST = ",Normal,Cancel", MAXLEN = 30, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",N,C") [ Required, SqlColumnNumber = 8, SqlFieldName = OCI_Status ];

/// 转结日期  OCI_Date
Property OCIDate As %Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = OCI_Date ];

/// 转结时间  OCI_Time
Property OCITime As %Time [ SqlColumnNumber = 10, SqlFieldName = OCI_Time ];

/// 转结人  OCI_User_DR
Property OCIUserDR As User.SSUser [ SqlColumnNumber = 11, SqlFieldName = OCI_User_DR ];

/// 撤回日期  OCI_CancelDate
Property OCICancelDate As %Date(FORMAT = 1) [ SqlColumnNumber = 12, SqlFieldName = OCI_CancelDate ];

/// 撤回时间  OCI_CancelTime
Property OCICancelTime As %Time [ SqlColumnNumber = 13, SqlFieldName = OCI_CancelTime ];

/// 撤回人  OCI_CancelUser_DR
Property OCICancelUserDR As User.SSUser [ SqlColumnNumber = 14, SqlFieldName = OCI_CancelUser_DR ];

/// 医院  OCI_Hosp_DR
Property OCIHospDR As User.CTHospital [ SqlColumnNumber = 15, SqlFieldName = OCI_Hosp_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCOPIPADMCON)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="OCI_AccPayInv_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="OCI_CancelDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="OCI_CancelTime">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="OCI_CancelUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="OCI_Date">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="OCI_Hosp_DR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="OCI_IP_Adm_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="OCI_InvPrt_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="OCI_OEORI_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="OCI_OP_Adm_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="OCI_PAPMI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="OCI_Status">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="OCI_Time">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="OCI_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Global>^DHCOPIPADMCON</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>OCI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{OCI_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAccInv">
<Global>^DHCOPIPADMCON</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OCI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AccInv"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OCI_AccPayInv_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OCI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DHCOPIPADMCON</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OCI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OCI_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OCI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexIPADMOEORI">
<Global>^DHCOPIPADMCON</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>OCI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"IPADM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OCI_IP_Adm_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"OEORI"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OCI_OEORI_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OCI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexIPOPADM">
<Global>^DHCOPIPADMCON</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>OCI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"IPADM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OCI_IP_Adm_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"OPADM"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OCI_OP_Adm_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OCI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInvPrt">
<Global>^DHCOPIPADMCON</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OCI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"InvPrt"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OCI_InvPrt_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OCI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOPADMOEORI">
<Global>^DHCOPIPADMCON</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>OCI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OPADM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OCI_OP_Adm_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"OEORI"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OCI_OEORI_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OCI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPAPMI">
<Global>^DHCOPIPADMCON</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OCI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PAPMI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OCI_PAPMI_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OCI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUser">
<Global>^DHCOPIPADMCON</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OCI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"User"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OCI_User_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OCI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>OCI_RowId</SqlRowIdName>
<StreamLocation>^User.DHCOPIPADMCON</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
