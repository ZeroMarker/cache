Class User.DHCAppPisMaster Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = AP_RowID, SqlTableName = DHC_AppPisMaster, StorageStrategy = SQLStorage ]
{

Relationship ChildDHCAPPPISARC As User.DHCAppPisArc [ Cardinality = children, Inverse = APParRefDr ];

Relationship ChildDHCAPPPISSPEC As User.DHCAppPisSpec [ Cardinality = children, Inverse = APParRefDr ];

Relationship ChildDHCAPPPISCUTBAS As User.DHCAppPisCutBas [ Cardinality = children, Inverse = APParRefDr ];

Relationship ChildDHCAPPPISTUMOUR As User.DHCAppPisTumour [ Cardinality = children, Inverse = APParRefDr ];

Relationship ChildDHCAPPPISGYNWON As User.DHCAppPisGynWon [ Cardinality = children, Inverse = APParRefDr ];

Relationship ChildDHCAPPPISAUTOPSY As User.DHCAppPisAutoPsy [ Cardinality = children, Inverse = APParRefDr ];

Relationship ChildDHCAPPPISCONSULT As User.DHCAppPisConsult [ Cardinality = children, Inverse = APParRefDr ];

/// 病人Adm   AP_Adm_Dr
Property APAdmDr As User.PAAdm [ SqlColumnNumber = 2, SqlFieldName = AP_Adm_Dr ];

/// 是否冰冻  AP_FrostFlag
Property APFrostFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 3, SqlFieldName = AP_FrostFlag ];

/// 加急标志  AP_EmgFlag
Property APEmgFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = AP_EmgFlag ];

/// 申请单号  AP_No 
Property APNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = AP_No ];

/// 申请医生  AP_CreateDoc_Dr
Property APCreateDocDr As User.SSUser [ SqlColumnNumber = 6, SqlFieldName = AP_CreateDoc_Dr ];

/// 申请日期  AP_CreateDate
Property APCreateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = AP_CreateDate ];

/// 申请时间  AP_CreateTime
Property APCreateTime As %Library.Time [ SqlColumnNumber = 8, SqlFieldName = AP_CreateTime ];

/// 申请科室  AP_Loc_Dr
Property APLocDr As User.CTLoc [ SqlColumnNumber = 9, SqlFieldName = AP_Loc_Dr ];

/// 申请状态  AP_Status 
Property APStatus As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = AP_Status ];

/// 停止人  AP_XUser_Dr
Property APXUserDr As User.SSUser [ SqlColumnNumber = 11, SqlFieldName = AP_XUser_Dr ];

/// 停止日期  AP_XDate
Property APXDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 12, SqlFieldName = AP_XDate ];

/// 停止时间  AP_XTime
Property APXTime As %Library.Time [ SqlColumnNumber = 13, SqlFieldName = AP_XTime ];

/// 病理号  AP_PisNo
Property APPisNo As %Library.String [ SqlColumnNumber = 14, SqlFieldName = AP_PisNo ];

/// 临床病历  AP_MedRecord
Property APCliRecord As %Library.String(COLLATION = "Exact", MAXLEN = 100000, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = AP_MedRecord ];

/// 临床诊断  AP_MedDiag
Property APMedDiag As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = AP_MedDiag ];

/// 已肝病史  AP_HepatitisB
Property APHepatitisB As %Library.String [ SqlColumnNumber = 17, SqlFieldName = AP_HepatitisB ];

/// 手术所见  AP_OperRes
Property APOperRes As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = AP_OperRes ];

/// 传染病史  AP_InfDisHis
Property APInfDisHis As %Library.String [ SqlColumnNumber = 19, SqlFieldName = AP_InfDisHis ];

/// 首次发现人乳头瘤病毒时间  AP_PerPapVirus
Property APPerPapVirus As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 20, SqlFieldName = AP_PerPapVirus ];

/// 申请单类型  AP_Type
Property APType As %Library.String [ SqlColumnNumber = 21, SqlFieldName = AP_Type ];

/// 病理结果状态  AP_Status_Dr
Property APStatusDr As User.DHCAppTestStatus [ SqlColumnNumber = 22, SqlFieldName = AP_Status_Dr ];

/// 既往检查日期及结果  AP_PreResult
Property APPreResult As %Library.String(COLLATION = "Exact", MAXLEN = 99999, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = AP_PreResult ];

/// 申请目的  AP_Purpose
Property APPurpose As %Library.String(COLLATION = "Exact", MAXLEN = 99999, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = AP_Purpose ];

/// 详情病史  AP_DisHistory
Property APDisHistory As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = AP_DisHistory ];

/// 辅助检查  AP_SupExa
Property APSupExa As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = AP_SupExa ];

/// 家族史 AP_FamilyHistory
Property APFamilyHistory As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = AP_FamilyHistory ];

/// 营养状况 AP_Nutriture
Property APNutriture As %Library.String [ SqlColumnNumber = 28, SqlFieldName = AP_Nutriture ];

/// 药物治疗及剂量 AP_Medication
Property APMedication As %Library.String [ SqlColumnNumber = 29, SqlFieldName = AP_Medication ];

/// 用药史 AP_MedicationHistory
Property APMedicationHistory As %Library.String [ SqlColumnNumber = 30, SqlFieldName = AP_MedicationHistory ];

/// 自身抗体 AP_AAbs
Property APAAbs As %Library.String [ SqlColumnNumber = 31, SqlFieldName = AP_AAbs ];

/// 肝移植专填内容 AP_LiverTrans 
Property APLiverTrans As %Library.String [ SqlColumnNumber = 32, SqlFieldName = AP_LiverTrans ];

/// 其他 AP_Other
Property APOther As %Library.String [ SqlColumnNumber = 33, SqlFieldName = AP_Other ];

/// 本次申请检查项目 AP_ApplyItems
Property APApplyItems As %Library.String [ SqlColumnNumber = 34, SqlFieldName = AP_ApplyItems ];

/// 病理申请单信息
Property APJsonInfo As %Library.String(MAXLEN = 10000000) [ SqlColumnNumber = 35, SqlFieldName = AP_JsonInfo ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCAPPPM)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="AP_AAbs">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="AP_Adm_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AP_ApplyItems">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="AP_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="AP_CreateDoc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="AP_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="AP_DisHistory">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="AP_EmgFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AP_FamilyHistory">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="AP_FrostFlag">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AP_HepatitisB">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="AP_InfDisHis">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="AP_JsonInfo">
<Node>"JsonInfo"</Node>
</Data>
<Data name="AP_LiverTrans">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="AP_Loc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="AP_MedDiag">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="AP_MedRecord">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="AP_Medication">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="AP_MedicationHistory">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="AP_No">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AP_Nutriture">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="AP_OperRes">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="AP_Other">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="AP_PerPapVirus">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="AP_PisNo">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="AP_PreResult">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="AP_Purpose">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="AP_Status">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="AP_Status_Dr">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="AP_SupExa">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="AP_Type">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="AP_XDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="AP_XTime">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="AP_XUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Global>^DHCAPPPM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{AP_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAdm">
<Global>^DHCAPPPM</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Adm"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AP_Adm_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCreatDateTime">
<Global>^DHCAPPPM</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>AP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CreatDateTime"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AP_CreateDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AP_CreateTime}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCreateDate">
<Global>^DHCAPPPM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CreateDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AP_CreateDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPisNo">
<Global>^DHCAPPPM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PisNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AP_No}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCAppPisMasterS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
