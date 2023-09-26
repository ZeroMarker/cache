Class User.DHCCardRef Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = CF_RowID, SqlTableName = DHC_CardRef, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCCardStatusChange As User.DHCCardStatusChange [ Cardinality = children, Inverse = CSCCFParRef ];

/// CF_AccNo_DR
Property CFAccNoDR As User.DHCAccManager [ SqlColumnNumber = 2, SqlFieldName = CF_AccNo_DR ];

/// CF_CardNo
Property CFCardNo As %Library.String(COLLATION = "Exact", MAXLEN = 128, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = CF_CardNo ];

/// CF_SecurityNO
Property CFSecurityNO As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = CF_SecurityNO ];

/// CF_PAPMI_DR
Property CFPAPMIDR As %Library.String(COLLATION = "Exact", TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = CF_PAPMI_DR ];

/// ID Card
Property CFIDCardNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = CF_IDCardNo ];

/// CF_PAPMINo
Property CFPAPMINo As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = CF_PAPMINo ];

/// CF_Date
Property CFDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = CF_Date ];

/// CF_Time
Property CFTime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = CF_Time ];

/// CF_User_DR
Property CFUserDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = CF_User_DR ];

/// CF_ActiveFlag
Property CFActiveFlag As %Library.String(DISPLAYLIST = ",Normal,Suspend,Reclaim,Depose,UnActivated", MAXLEN = 7, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",N,S,R,D,UA") [ SqlColumnNumber = 11, SqlFieldName = CF_ActiveFlag ];

/// CF_DateFrom
Property CFDateFrom As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 12, SqlFieldName = CF_DateFrom ];

/// CF_DateTo
Property CFDateTo As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 13, SqlFieldName = CF_DateTo ];

/// CF_CancleDate
Property CFCancleDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 14, SqlFieldName = CF_CancleDate ];

/// CF_CancleTime
Property CFCancleTime As %Library.Time [ SqlColumnNumber = 15, SqlFieldName = CF_CancleTime ];

/// CF_CancleUser_DR
Property CFCancleUserDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = CF_CancleUser_DR ];

/// CF_CardType_DR
Property CFCardTypeDR As User.DHCCardTypeDef [ SqlColumnNumber = 17, SqlFieldName = CF_CardType_DR ];

/// CF_CardINVPRT_DR
Property CFCardINVPRTDR As User.DHCCardINVPRT [ SqlColumnNumber = 18, SqlFieldName = CF_CardINVPRT_DR ];

/// CF_FareType
Property CFFareType As %Library.String(DISPLAYLIST = ",No Pay,Person Charge,Collect Charge", MAXLEN = 14, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",NP,PC,CC") [ SqlColumnNumber = 19, SqlFieldName = CF_FareType ];

// CF_Note4

// Property CFNote4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = CF_Note4 ];

// CF_Note5

// Property CFNote5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = CF_Note5 ];

/// CF_BankSignFlag 0未签约  1签约
Property CFBankSignFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = CF_BankSignFlag ];

/// CF_BankCode 按照规定 工 01； 农 02； 中 03； 建 04  往后排
Property CFBankCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = CF_BankCode ];

/// 是否为遗失卡(院内遗失,非患者遗失)
Property CFLostCard As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 22, SqlFieldName = CF_LostCard ];

/// 遗失卡操作员
Property CFLostCardUserDR As User.SSUser [ SqlColumnNumber = 23, SqlFieldName = CF_LostCardUser_DR ];

/// 电子健康卡二维码信息
Property CFElecCardNo As %Library.String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = CF_ElecCardNo ];

/// 电子健康卡ID
Property CFElecPId As %Library.String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = CF_ElecPId ];

/// 电子健康卡二维码图片编码(静态)
Property CFElecStaticQrcodePhoto As %Library.String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = CF_ElecStaticQrcodePhoto ];

/// CF_BatchFlag
/// 电子健康卡批量注册标志
Property CFElecBatchFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 27, SqlFieldName = CF_ElecBatchFlag ];

/// 电子健康卡是否激活标志
Property CFElecActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 28, SqlFieldName = CF_ElecActive ];

/// 电子健康卡注册时间
Property CFElecRegistTime As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = CF_ElecRegistTime ];

/// 临时卡标识
Property CFIsTemporaryCard As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 30, SqlFieldName = CF_IsTemporaryCard ];

/// 卡号别名 作为卡号的补充索引 可以存卡片的uid之类唯一标识数据
Property CFCardUID As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 31, SqlFieldName = CF_CardUID ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCARD("CF"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="CF_AccNo_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CF_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="CF_BankCode">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="CF_BankSignFlag">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="CF_CancleDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="CF_CancleTime">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="CF_CancleUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="CF_CardINVPRT_DR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="CF_CardNo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CF_CardType_DR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="CF_CardUID">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="CF_Date">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CF_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="CF_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="CF_ElecActive">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="CF_ElecBatchFlag">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="CF_ElecCardNo">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="CF_ElecPId">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="CF_ElecRegistTime">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="CF_ElecStaticQrcodePhoto">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="CF_FareType">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="CF_IDCardNo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CF_IsTemporaryCard">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="CF_LostCard">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="CF_LostCardUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="CF_PAPMINo">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CF_PAPMI_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CF_SecurityNO">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CF_Time">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CF_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^DHCCARD</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CF_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"CF"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{CF_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAccNodr">
<Global>^DHCCARDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CF_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"CF"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"AccNoDR"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{CF_AccNo_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{CF_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCancelDate">
<Global>^DHCCARDi</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"CF"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"CancleDate"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CF_CancleDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CF_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCardTypeCardNo">
<Global>^DHCCARDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>CF_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"CF"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"CardTypeNo"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{CF_CardType_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{CF_CardNo}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{CF_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCardTypePAPMI">
<Global>^DHCCARDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>CF_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"CF"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"TypePAPMINO"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{CF_CardType_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{CF_PAPMI_DR}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{CF_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DHCCARDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CF_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"CF"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{CF_Date}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{CF_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexINVPRT">
<Global>^DHCCARDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CF_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"CF"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"INVPRT"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{CF_CardINVPRT_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{CF_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPAPMICardTypeDR">
<Global>^DHCCARDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>CF_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"CF"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"PAPMICTDR"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{CF_PAPMI_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{CF_CardType_DR}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{CF_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPAPMIDR">
<Global>^DHCCARDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CF_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"CF"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"PAPMIDR"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{CF_PAPMI_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{CF_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUID">
<Global>^DHCCARDi</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"CF"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"UID"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({CF_CardUID})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CF_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexCFCardNo">
<Global>^DHCCARDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CF_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"CF"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"CardNo"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{CF_CardNo}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{CF_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexCFIDCardNo">
<Global>^DHCCARDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CF_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"CF"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"IDCardNo"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{CF_IDCardNo}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{CF_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexCFUserDR">
<Global>^DHCCARDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CF_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"CF"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"UserDR"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{CF_User_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{CF_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCCardRefS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
