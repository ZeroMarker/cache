Class User.DHCMDTConsult Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MC_RowID, SqlTableName = DHC_MDTConsult, StorageStrategy = SQLStorage ]
{

Relationship ChildDHCMDTCONSULTITM As User.DHCMDTConsultItm [ Cardinality = children, Inverse = MCParRefDr ];

/// 病人Adm   MC_Adm_Dr
Property MCAdmDr As User.PAAdm [ SqlColumnNumber = 2, SqlFieldName = MC_Adm_Dr ];

/// 申请科室  MC_RLoc_Dr
Property MCRLocDr As User.CTLoc [ SqlColumnNumber = 3, SqlFieldName = MC_RLoc_Dr ];

/// 申请日期  MC_RDate
Property MCRDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = MC_RDate ];

/// 申请时间  MC_RTime
Property MCRTime As %Library.Time [ SqlColumnNumber = 5, SqlFieldName = MC_RTime ];

/// 申请医生  MC_RUser_Dr
Property MCRUserDr As User.SSUser [ SqlColumnNumber = 6, SqlFieldName = MC_RUser_Dr ];

/// 病情及诊疗经过  MC_TrePro
Property MCTrePro As %Library.Text(MAXLEN = 20000) [ SqlColumnNumber = 7, SqlFieldName = MC_TrePro ];

/// 会诊的理由和目的  MC_Purpose
Property MCPurpose As %Library.Text(MAXLEN = 20000) [ SqlColumnNumber = 8, SqlFieldName = MC_Purpose ];

/// 会诊日期  MC_NDate
Property MCNDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = MC_NDate ];

/// 会诊时间  MC_NTime
Property MCNTime As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = MC_NTime ];

/// 会诊地点  MC_NPlace
Property MCNPlace As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = MC_NPlace ];

/// 最终治疗措施  MC_TreMeasures
Property MCTreMeasures As %Library.String(COLLATION = "Exact", MAXLEN = 20000, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = MC_TreMeasures ];

/// 申请状态  MC_ExeStatus
Property MCExeStatus As User.DHCMDTConsStatus [ SqlColumnNumber = 13, SqlFieldName = MC_ExeStatus ];

/// 联系人  MC_Contacts
Property MCContacts As %Library.String [ SqlColumnNumber = 14, SqlFieldName = MC_Contacts ];

/// 联系电话  MC_ConsPhone
Property MCConsPhone As %Library.String [ SqlColumnNumber = 15, SqlFieldName = MC_ConsPhone ];

/// 打印标志  MC_PrintFlag
Property MCPrintFlag As %Library.String [ SqlColumnNumber = 16, SqlFieldName = MC_PrintFlag ];

/// 疑难病种  MC_Group_Dr
Property MCGroupDr As User.DHCMDTGroup [ SqlColumnNumber = 17, SqlFieldName = MC_Group_Dr ];

/// 医护资源表  MC_Care_Dr
Property MCRBResDr As User.RBResource [ SqlColumnNumber = 18, SqlFieldName = MC_RBRes_Dr ];

/// 预约资源表  MC_AppSc_Dr
Property MCAppScDr As User.RBApptSchedule [ SqlColumnNumber = 19, SqlFieldName = MC_AppSc_Dr ];

/// 预约资源表  MC_Appoint_Dr
Property MCAppointDr As User.RBAppointment [ SqlColumnNumber = 20, SqlFieldName = MC_Appoint_Dr ];

/// 预约就诊ID  
Property MCAppAdmDr As User.PAAdm [ SqlColumnNumber = 21, SqlFieldName = MC_AppAdm_Dr ];

/// 病历Id  
Property MCInstanceDr As %Library.String [ SqlColumnNumber = 22, SqlFieldName = MC_Instance_Dr ];

/// 第几次会诊  MC_Times
Property MCTimes As %Library.String [ SqlColumnNumber = 23, SqlFieldName = MC_Times ];

/// 会诊讨论  MC_DisProcess
Property MCDisProcess As %Library.Text(MAXLEN = 20000) [ SqlColumnNumber = 24, SqlFieldName = MC_DisProcess ];

/// 备注  MC_Notes
Property MCNotes As %Library.Text(MAXLEN = 5000) [ SqlColumnNumber = 25, SqlFieldName = MC_Notes ];

/// 补充说明  MC_SuppNotes
Property MCSuppNotes As %Library.Text(MAXLEN = 5000) [ SqlColumnNumber = 26, SqlFieldName = MC_SuppNotes ];

/// 病人ID  MC_PatientDr
Property MCPatientDr As User.PAPatMas [ SqlColumnNumber = 27, SqlFieldName = MC_Patient_Dr ];

/// 肿瘤状态  MC_TumStage
Property MCTumStage As %Library.String [ SqlColumnNumber = 28, SqlFieldName = MC_TumStage ];

/// 主持人   MC_Host
Property MCHost As User.SSUser [ SqlColumnNumber = 29, SqlFieldName = MC_Host ];

/// 是否加急  MC_EmFlag
Property MCEmFlag As %Library.String [ SqlColumnNumber = 30, SqlFieldName = MC_EmFlag ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCMDTCON)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MC_Adm_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MC_AppAdm_Dr">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="MC_AppSc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="MC_Appoint_Dr">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="MC_ConsPhone">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="MC_Contacts">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="MC_DisProcess">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="MC_EmFlag">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="MC_ExeStatus">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="MC_Group_Dr">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="MC_Host">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="MC_Instance_Dr">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="MC_NDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="MC_NPlace">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="MC_NTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="MC_Notes">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="MC_Patient_Dr">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="MC_PrintFlag">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="MC_Purpose">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MC_RBRes_Dr">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="MC_RDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MC_RLoc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MC_RTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MC_RUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MC_SuppNotes">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="MC_Times">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="MC_TreMeasures">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="MC_TrePro">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MC_TumStage">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Global>^DHCMDTCON</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{MC_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAdm">
<Global>^DHCMDTCON</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Adm"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MC_Adm_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAppAdm">
<Global>^DHCMDTCON</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AppAdm"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MC_AppAdm_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAppoint">
<Global>^DHCMDTCON</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Appoint"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MC_Appoint_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DHCMDTCON</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ReqDateIndex"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MC_RDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexNDate">
<Global>^DHCMDTCON</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"NDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MC_NDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCMDTConsultS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
