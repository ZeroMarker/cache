Class User.DHCAppReport Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = AR_RowID, SqlTableName = DHC_AppReport, StorageStrategy = SQLStorage ]
{

Relationship ChildDHCAPPREPARC As User.DHCAppRepArc [ Cardinality = children, Inverse = ARParRefDr ];

Relationship ChildDHCAPPREPOTHOPT As User.DHCAppRepOthOpt [ Cardinality = children, Inverse = ARParRefDr ];

/// 申请单号  AR_No
Property ARNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = AR_No ];

/// 申请日期  AR_CreateDate
Property ARCreateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = AR_CreateDate ];

/// 申请时间  AR_CreateTime
Property ARCreateTime As %Library.Time [ SqlColumnNumber = 4, SqlFieldName = AR_CreateTime ];

/// 申请医生  AR_CreateDoc_Dr
Property ARCreateDocDr As User.SSUser [ SqlColumnNumber = 5, SqlFieldName = AR_CreateDoc_Dr ];

/// 执行科室  AR_ExecLoc_Dr
Property ARExecLocDr As User.CTLoc [ SqlColumnNumber = 6, SqlFieldName = AR_ExecLoc_Dr ];

/// 病人Adm   AR_Adm_Dr
Property ARAdmDr As User.PAAdm [ SqlColumnNumber = 7, SqlFieldName = AR_Adm_Dr ];

/// 医嘱子类  AR_Cat_Dr
Property ARCatDr As User.CTLoc [ SqlColumnNumber = 8, SqlFieldName = AR_Cat_Dr ];

/// 预约日期  AR_AppointDate
Property ARAppointDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = AR_AppointDate ];

/// 预约时间  AR_AppointTime
Property ARAppointTime As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = AR_AppointTime ];

/// 登记日期  ARRegDate
Property ARRegDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 11, SqlFieldName = AR_RegDate ];

/// 登记时间  AR_RegTime
Property ARRegTime As %Library.Time [ SqlColumnNumber = 12, SqlFieldName = AR_RegTime ];

/// 报告日期  AR_RepDate
Property ARRepDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 13, SqlFieldName = AR_RepDate ];

/// 报告时间  AR_RepTime
Property ARRepTime As %Library.Time [ SqlColumnNumber = 14, SqlFieldName = AR_RepTime ];

/// 审核日期  AR_AuditDate
Property ARAuditDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 15, SqlFieldName = AR_AuditDate ];

/// 审核时间  AR_AuditTime
Property ARAuditTime As %Library.Time [ SqlColumnNumber = 16, SqlFieldName = AR_AuditTime ];

/// 是否加急标志 AR_EmgFlag
Property AREmgFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 17, SqlFieldName = AR_EmgFlag ];

/// 是否发送  AR_SendFlag
Property ARSendFlag As %Library.String(DISPLAYLIST = ",Yes,No,IPrac", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N,I") [ SqlColumnNumber = 18, SqlFieldName = AR_SendFlag ];

/// 报告状态  AR_Status
Property ARStatus As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 19, SqlFieldName = AR_Status ];

/// 指定医生  AR_AppointDoc
Property ARAppointDoc As User.SSUser [ SqlColumnNumber = 20, SqlFieldName = AR_AppointDoc ];

/// 检查目的  AR_Purpose
Property ARPurpose As %Library.String(COLLATION = "Exact", MAXLEN = 99999, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = AR_Purpose ];

/// 加急原因  AR_EmgRemark
Property AREmgRemark As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = AR_EmgRemark ];

/// 执行打印的护士ID	AR_NurPrtUserId
Property ARNurPrtUserId As User.SSUser [ SqlColumnNumber = 23, SqlFieldName = AR_NurPrtUserId ];

/// 打印日期  AR_NurPrtDate
Property ARNurPrtDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 24, SqlFieldName = AR_NurPrtDate ];

/// 打印时间  AR_NurPrtTime
Property ARNurPrtTime As %Library.Time [ SqlColumnNumber = 25, SqlFieldName = AR_NurPrtTime ];

/// 病人诊断  AR_PatDiags
Property ARPatDiags As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = AR_PatDiags ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCAPREP)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="AR_Adm_Dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="AR_AppointDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="AR_AppointDoc">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="AR_AppointTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="AR_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="AR_AuditTime">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="AR_Cat_Dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="AR_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AR_CreateDoc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AR_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AR_EmgFlag">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="AR_EmgRemark">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="AR_ExecLoc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="AR_No">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AR_NurPrtDate">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="AR_NurPrtTime">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="AR_NurPrtUserId">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="AR_PatDiags">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="AR_Purpose">
<Node>"Purpose"</Node>
</Data>
<Data name="AR_RegDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="AR_RegTime">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="AR_RepDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="AR_RepTime">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="AR_SendFlag">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="AR_Status">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Global>^DHCAPREP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{AR_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAdm">
<Global>^DHCAPREP</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ADM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AR_Adm_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexArNo">
<Global>^DHCAPREP</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ARNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AR_No}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCreateDate">
<Global>^DHCAPREP</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CreateDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AR_CreateDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCAppReportS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
