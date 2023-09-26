Class User.DHCItmRemark Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = IR_RowID, SqlTableName = DHC_ItmRemark, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCItmReVendor As User.DHCItmReVendor [ Cardinality = children, Inverse = IRVParref ];

/// IR_INCI_DR
Property IRINCIDR As User.INCItm [ SqlColumnNumber = 2, SqlFieldName = IR_INCI_DR ];

/// IR_PHManf_DR
Property IRPHManfDR As User.PHManufacturer [ SqlColumnNumber = 3, SqlFieldName = IR_PHManf_DR ];

/// IR_Label
Property IRLabel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = IR_Label ];

/// IR_LastText
Property IRLastText As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = IR_LastText ];

/// IR_NewText
Property IRNewText As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = IR_NewText ];

/// IR_UpDate
Property IRUpDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = IR_UpDate ];

/// IR_UpTime
Property IRUpTime As %Library.Time [ SqlColumnNumber = 8, SqlFieldName = IR_UpTime ];

/// IR_UpUser_DR
Property IRUpUserDR As User.SSUser [ SqlColumnNumber = 9, SqlFieldName = IR_UpUser_DR ];

/// IR_Certificat
Property IRCertificat As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = IR_Certificat ];

/// IR_TextExpDate
Property IRTextExpDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 11, SqlFieldName = IR_TextExpDate ];

/// IR_RegCertNo
Property IRRegCertNo As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = IR_RegCertNo ];

/// IR_RegCertExpDate
Property IRRegCertExpDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 13, SqlFieldName = IR_RegCertExpDate ];

/// 区域统一编码
Property IRRegionCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = IR_RegionCode ];

/// IR_MC_DR  - User.DHCItmManfCert
Property IRMCDR As %Library.String [ SqlColumnNumber = 15, SqlFieldName = IR_MC_DR ];

/// IR_SA_DR  -  User.DHCItmManfCertSA
Property IRSADR As %Library.String [ SqlColumnNumber = 16, SqlFieldName = IR_SA_DR ];

/// IR_RegCertItmDesc  注册证物资名称
Property IRRegCertItmDesc As %Library.String(COLLATION = "Exact", MAXLEN = 220, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = IR_RegCertItmDesc ];

/// IR_HygLicDoc  卫生许可批件
Property IRHygLicDoc As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = IR_HygLicDoc ];

/// IR_HygLicDocExpDate  卫生许可批件效期
Property IRHygLicDocExpDate As %Library.Date [ SqlColumnNumber = 19, SqlFieldName = IR_HygLicDocExpDate ];

/// IR_InspectRep   检验报告
Property IRInspectRep As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = IR_InspectRep ];

/// IR_InspectRepExpDate   检验报告效期
Property IRInspectRepExpDate As %Library.Date [ SqlColumnNumber = 21, SqlFieldName = IR_InspectRepExpDate ];

/// IR_TdMkRegCert   商标注册证
Property IRTdMkRegCert As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = IR_TdMkRegCert ];

/// IR_TdMkRegCertExpDate   商标注册证效期
Property IRTdMkRegCertExpDate As %Library.Date [ SqlColumnNumber = 23, SqlFieldName = IR_TdMkRegCertExpDate ];

/// IR_RegCertNoFull -- 注册证号全称
Property IRRegCertNoFull As %Library.String(COLLATION = "Exact", MAXLEN = 90, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = IR_RegCertNoFull ];

/// IR_RegCertDateOfIssue -- 注册证发证日期
Property IRRegCertDateOfIssue As %Library.Date [ SqlColumnNumber = 25, SqlFieldName = IR_RegCertDateOfIssue ];

/// IR_RegCertExpDate_Extended  -- 注册证延长效期标志
Property IRRegCertExpDateExtended As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 26, SqlFieldName = IR_RegCertExpDate_Extended ];

/// 厂家招标号
Property IRPurPlanCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = IR_PurPlanCode ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^ITMREK)</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="IR_Certificat">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="IR_HygLicDoc">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="IR_HygLicDocExpDate">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="IR_INCI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="IR_InspectRep">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="IR_InspectRepExpDate">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="IR_Label">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="IR_LastText">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="IR_MC_DR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="IR_NewText">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="IR_PHManf_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="IR_PurPlanCode">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="IR_RegCertDateOfIssue">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="IR_RegCertExpDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="IR_RegCertExpDate_Extended">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="IR_RegCertItmDesc">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="IR_RegCertNo">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="IR_RegCertNoFull">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="IR_RegionCode">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="IR_SA_DR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="IR_TdMkRegCert">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="IR_TdMkRegCertExpDate">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="IR_TextExpDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="IR_UpDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="IR_UpTime">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="IR_UpUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^ITMREK</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>IR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{IR_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDATE">
<Global>^ITMREK</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>IR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"IR"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{IR_UpDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{IR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexINCI">
<Global>^ITMREK</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>IR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"INCI"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{IR_INCI_DR}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{IR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInciDate">
<Global>^ITMREK</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"INCIDATE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IR_INCI_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IR_UpDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{IR_UpTime}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{IR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInciManf">
<Global>^ITMREK</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>IR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"INCIMNF"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{IR_INCI_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{IR_PHManf_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{IR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSA">
<Global>^ITMREK</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>IR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SA"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IR_SA_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCItmRemarkS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^ITMREK)
	s oldI = +$g(^mdata("DHCITMREMARK"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^ITMREK = maxI
	s ^mdata("DHCITMREMARK") = maxI
}

}
