Class User.DHCINVOEItemAuthorize Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = IOA_RowID, SqlTableName = DHC_INVOEItemAuthorize, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On IOASub [ IdKey, PrimaryKey, Unique ];

/// DHC_INVPRT Parent Reference
Relationship PRTIOAParRef As User.DHCINVPRT [ Cardinality = parent, Inverse = ChildDHCINVOEItemAuthorize, Required, SqlFieldName = PRT_IOA_ParRef ];

/// IOA_Sub
Property IOASub As %Float [ InitialExpression = {$i(^DHCINVPRT($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"OA",0))}, SqlColumnNumber = 2, SqlFieldName = IOA_Sub ];

/// IOA_OEORI_DR 医嘱ID
Property IOAOEORIDR As User.OEOrdItem [ SqlColumnNumber = 3, SqlFieldName = IOA_OEORI_DR ];

/// IOA_User_DR 申请人
Property IOAUserDR As User.SSUser [ SqlColumnNumber = 4, SqlFieldName = IOA_User_DR ];

/// IOA_Date 申请日期
Property IOADate As %Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = IOA_Date ];

/// IOA_Time 申请时间
Property IOATime As %Time [ SqlColumnNumber = 6, SqlFieldName = IOA_Time ];

/// IOA_RequestQty 申请数量 
Property IOARequestQty As %Float [ SqlColumnNumber = 7, SqlFieldName = IOA_RequestQty ];

/// IOA_Flag 申请状态 Application申请,Pass 通过
Property IOAFlag As %String(DISPLAYLIST = ",Application,Pass", MAXLEN = 11, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",A,P") [ SqlColumnNumber = 8, SqlFieldName = IOA_Flag ];

/// IOA_PBO_DR  DHC_PatBillOrder
Property IOAPBODR As User.DHCPatBillOrder [ SqlColumnNumber = 9, SqlFieldName = IOA_PBO_DR ];

/// IOA_ARTI_DR	新版申请单中间表指针
Property IOAARTIDR As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = IOA_ARTI_DR ];

/// IOA_DSPB_DR	打包明细表DHC_OEDispBatch
Property IOADSPBDR As User.DHCOEDispBatch [ SqlColumnNumber = 11, SqlFieldName = IOA_DSPB_DR ];

/// IOA_DrugOweFlag 欠药标志
Property IOADrugOweFlag As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = IOA_DrugOweFlag ];

/// IOA_ReasonDR 申请原因指针
Property IOAReasonDR As User.DHCINVOPRefReason [ SqlColumnNumber = 13, SqlFieldName = IOA_ReasonDR ];

/// IOA_AuditUser 审核人
Property IOAAuditUser As User.SSUser [ SqlColumnNumber = 14, SqlFieldName = IOA_AuditUser ];

/// IOA_AuditDate 审核日期
Property IOAAuditDate As %Date [ SqlColumnNumber = 15, SqlFieldName = IOA_AuditDate ];

/// IOA_AuditTime 审核时间
Property IOAAuditTime As %Time [ SqlColumnNumber = 16, SqlFieldName = IOA_AuditTime ];

/// IOA_AuditView 审核意见
Property IOAAuditView As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = IOA_AuditView ];

/// IOA_ReqestDeptDR 申请科室
Property IOAReqestDeptDR As User.CTLoc [ SqlColumnNumber = 18, SqlFieldName = IOA_ReqestDeptDR ];

/// IOA_ARCIM_DR  医嘱项
Property IOAARCIMDR As User.ARCItmMast [ SqlColumnNumber = 19, SqlFieldName = IOA_ARCIM_DR ];

/// IOA_PrescNo 处方号
Property IOAPrescNo As %String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = IOA_PrescNo ];

/// IOA_RefundRepPart 以"!!"分隔的退费部位RowId串
Property IOARefundRepPart As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = IOA_RefundRepPart ];

/// IOA_LabNo 检验号
Property IOALabNo As %String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = IOA_LabNo ];

/// IOA_PHDISITMCLB ;发药子表记录(发药不能为空)
Property IOAPHDISITMCLB As %String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = IOA_PHDISITMCLB ];

/// IOA_RequestAmt 申请金额
Property IOARequestAmt As %Float [ SqlColumnNumber = 24, SqlFieldName = IOA_RequestAmt ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="IOA_ARCIM_DR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="IOA_ARTI_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="IOA_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="IOA_AuditTime">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="IOA_AuditUser">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="IOA_AuditView">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="IOA_DSPB_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="IOA_Date">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="IOA_DrugOweFlag">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="IOA_Flag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="IOA_LabNo">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="IOA_OEORI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="IOA_PBO_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="IOA_PHDISITMCLB">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="IOA_PrescNo">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="IOA_ReasonDR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="IOA_RefundRepPart">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="IOA_ReqestDeptDR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="IOA_RequestAmt">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="IOA_RequestQty">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="IOA_Time">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="IOA_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCINVPRT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_INVPRT.PRT_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>IOA_Sub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_INVPRT.PRT_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"OA"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{IOA_Sub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexARCIMDR">
<Global>^DHCINVPRT</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_INVPRT.PRT_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>IOA_Sub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ARCIMDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IOA_ARCIM_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_INVPRT.PRT_Rowid}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"OA"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{IOA_Sub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexARTIDR">
<Global>^DHCINVPRT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_INVPRT.PRT_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>IOA_Sub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ARTIDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IOA_ARTI_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_INVPRT.PRT_Rowid}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"OA"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{IOA_Sub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAuditDate">
<Global>^DHCINVPRT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_INVPRT.PRT_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>IOA_Sub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AUDITDATE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IOA_AuditDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_INVPRT.PRT_Rowid}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"OA"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{IOA_Sub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDSPBDR">
<Global>^DHCINVPRT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_INVPRT.PRT_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>IOA_Sub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DSPBDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IOA_DSPB_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_INVPRT.PRT_Rowid}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"OA"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{IOA_Sub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexIOADate">
<Global>^DHCINVPRT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_INVPRT.PRT_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>IOA_Sub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"IOADATE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IOA_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_INVPRT.PRT_Rowid}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"OA"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{IOA_Sub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexIOADept">
<Global>^DHCINVPRT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_INVPRT.PRT_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>IOA_Sub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DEPTDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IOA_ReqestDeptDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_INVPRT.PRT_Rowid}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"OA"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{IOA_Sub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexIOAFlag">
<Global>^DHCINVPRT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_INVPRT.PRT_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>IOA_Sub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"IOAFLAG"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IOA_Flag}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_INVPRT.PRT_Rowid}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"OA"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{IOA_Sub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOEORI">
<Global>^DHCINVPRT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_INVPRT.PRT_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>IOA_Sub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OEORI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IOA_OEORI_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_INVPRT.PRT_Rowid}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"OA"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{IOA_Sub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPBO">
<Global>^DHCINVPRT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_INVPRT.PRT_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>IOA_Sub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PBO"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IOA_PBO_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_INVPRT.PRT_Rowid}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"OA"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{IOA_Sub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPHDISITMCLB">
<Global>^DHCINVPRT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_INVPRT.PRT_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>IOA_Sub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PHDISITMCLB"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IOA_PHDISITMCLB}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_INVPRT.PRT_Rowid}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"OA"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{IOA_Sub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPrescNo">
<Global>^DHCINVPRT</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_INVPRT.PRT_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>IOA_Sub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PRESCNO"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IOA_PrescNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_INVPRT.PRT_Rowid}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"OA"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{IOA_Sub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCINVOEItemAuthorizeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

Parameter EXTENTSIZE = 250;

}
