Class User.DHCPHConsult Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHCON_RowID, SqlTableName = DHC_PHConsult, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCPHConsultDetail As User.DHCPHConsultDetail [ Cardinality = children, Inverse = PHCONTDCONParRef ];

Relationship ChildDHCPHConsultItm As User.DHCPHConsultItm [ Cardinality = children, Inverse = PHCONIParRefDr ];

/// PHCON_Date
Property PHCONDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 2, SqlFieldName = PHCON_Date ];

/// PHCON_Time
Property PHCONTime As %Library.Time [ SqlColumnNumber = 3, SqlFieldName = PHCON_Time ];

/// PHCON_User  取值时，根据咨询人身份： 医生/护士 SS_USER  患者/家属 pa_patmas
Property PHCONUserDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PHCON_User_Dr ];

/// PHCON_Type_Dr
Property PHCONTypeDr As User.DHCPHConsultType [ SqlColumnNumber = 5, SqlFieldName = PHCON_Type_Dr ];

/// PHCON_Loc_Dr
Property PHCONLocDr As User.CTLoc [ SqlColumnNumber = 6, SqlFieldName = PHCON_Loc_Dr ];

/// PHCON_Desc
Property PHCONDesc As %Library.String(COLLATION = "Exact", MAXLEN = 800, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = PHCON_Desc ];

/// PHCON_FinishFlag
Property PHCONFinishFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = PHCON_FinishFlag ];

/// PHCON_QEType_Dr
Property PHCONQETypeDr As User.DHCPHConQueType [ SqlColumnNumber = 9, SqlFieldName = PHCON_QEType_Dr ];

/// PHCON_UserType  咨询人身份  1--医生/护士  2--患者/家属  
Property PHCONUserType As User.PHACPWConsIden [ SqlColumnNumber = 10, SqlFieldName = PHCON_UserType ];

/// PHCON_SpecialCrowd  特殊人群(针对患者咨询)
Property PHCONSpecialCrowd As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = PHCON_SpecialCrowd ];

/// PHCON_ChronicDisease  慢性病(针对患者咨询)
Property PHCONChronicDisease As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = PHCON_ChronicDisease ];

/// PHCON_Remark  备注(针对患者咨询)
Property PHCONRemark As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = PHCON_Remark ];

/// PHCON_ContactNum  联系电话
Property PHCONContactNum As %Library.String(COLLATION = "Exact", MAXLEN = 13, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = PHCON_ContactNum ];

/// PHCON_PAPMI_DR 患者PatientID
Property PHCONPAPMIDR As User.PAPatMas [ SqlColumnNumber = 15, SqlFieldName = PHCON_PAPMI_DR ];

/// PHCON_Adm_Dr 患者就诊ID
Property PHCONAdmDr As User.PAAdm [ SqlColumnNumber = 16, SqlFieldName = PHCON_Adm_Dr ];

/// PHCON_PatName 患者姓名
Property PHCONPatName As %Library.String(COLLATION = "Exact", MAXLEN = 11, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = PHCON_PatName ];

/// PHCON_PatSex 性别
Property PHCONPatSex As User.CTSex [ SqlColumnNumber = 18, SqlFieldName = PHCON_PatSex ];

/// PHCON_PatAge 年龄
Property PHCONPatAge As %Library.String(COLLATION = "Exact", MAXLEN = 11, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = PHCON_PatAge ];

/// PHCON_PatDiag 诊断信息
Property PHCONPatDiag As %Library.String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = PHCON_PatDiag ];

/// PHCON_Way 咨询方式
Property PHCONWay As User.PHACPWConsWays [ SqlColumnNumber = 21, SqlFieldName = PHCON_Way ];

/// PHCON_RefMat 参考资料
Property PHCONRefMat As %Library.Integer [ SqlColumnNumber = 22, SqlFieldName = PHCON_RefMat ];

/// PHCON_Duration 服务时间
Property PHCONDuration As User.PHACPWConsTime [ SqlColumnNumber = 23, SqlFieldName = PHCON_Duration ];

/// PHCON_TraArc 追踪建档
Property PHCONTraArc As %Library.Integer [ SqlColumnNumber = 24, SqlFieldName = PHCON_TraArc ];

/// PHCON_ResDept 预约科别
Property PHCONResDept As %Library.String(COLLATION = "Exact", MAXLEN = 11, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = PHCON_ResDept ];

/// PHCON_TipLimit 提示期限
Property PHCONTipLimit As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 26, SqlFieldName = PHCON_TipLimit ];

/// PHCON_TraWay 追踪方式
Property PHCONTraWay As %Library.Integer [ SqlColumnNumber = 27, SqlFieldName = PHCON_TraWay ];

/// PHCON_AnsUser_Dr 回答人员
Property PHCONAnsUserDr As User.SSUser [ SqlColumnNumber = 28, SqlFieldName = PHCON_AnsUser_Dr ];

/// PHCON_TraRes 追踪结果
Property PHCONTraRes As %Library.Integer [ SqlColumnNumber = 29, SqlFieldName = PHCON_TraRes ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPHCONS)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PHCON_Adm_Dr">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PHCON_AnsUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="PHCON_ChronicDisease">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PHCON_ContactNum">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PHCON_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHCON_Desc">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PHCON_Duration">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="PHCON_FinishFlag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PHCON_Loc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHCON_PAPMI_DR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PHCON_PatAge">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="PHCON_PatDiag">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="PHCON_PatName">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PHCON_PatSex">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PHCON_QEType_Dr">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PHCON_RefMat">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="PHCON_Remark">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PHCON_ResDept">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="PHCON_SpecialCrowd">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PHCON_Time">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHCON_TipLimit">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="PHCON_TraArc">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="PHCON_TraRes">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="PHCON_TraWay">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="PHCON_Type_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHCON_UserType">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PHCON_User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHCON_Way">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Global>^DHCPHCONS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHCON_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{PHCON_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDateLoc">
<Global>^DHCPHCONS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PHCON_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"DATELOC"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHCON_Date}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PHCON_Loc_Dr}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{PHCON_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateType">
<Global>^DHCPHCONS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PHCON_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"DATETYPE"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHCON_Date}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PHCON_Type_Dr}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{PHCON_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateUserType">
<Global>^DHCPHCONS</Global>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>PHCON_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHCON_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"UserType"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHCON_UserType}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PHCON_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexDateQeType">
<Global>^DHCPHCONS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>{PHCON_RowID}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DATEQETYPE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHCON_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHCON_QEType_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHCON_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPHConsultS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCPHCONS)
	s oldI = +$g(^mdata("DHCPHCONSULT"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCPHCONS = maxI
	s ^mdata("DHCPHCONSULT") = maxI
}

}
