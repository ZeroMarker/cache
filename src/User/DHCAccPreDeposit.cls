/// Account PrePay
Class User.DHCAccPreDeposit Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = AccPD_RowID, SqlTableName = DHC_AccPreDeposit, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On AccPDSub [ IdKey, PrimaryKey, Unique ];

/// DHC_AccManager Parent Reference
Relationship AccPDParRef As User.DHCAccManager [ Cardinality = parent, Inverse = ChildDHCAccPreDeposit, Required, SqlFieldName = AccPD_ParRef ];

Relationship ChildDHCAccPrePayMode As User.DHCAccPrePayMode [ Cardinality = children, Inverse = APPMAccPDParRef ];

/// AccPD_Sub
Property AccPDSub As %Library.Float [ InitialExpression = {$i(^DHCACD("AccM",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"AccPD",0))}, SqlColumnNumber = 2, SqlFieldName = AccPD_Sub ];

/// AccPD_Type 2020-06-30 增加ToRefund(预退款)状态
Property AccPDType As %Library.String(DISPLAYLIST = ",Pay,Refund,Trans,Foot,ToRefund", MAXLEN = 6, TRUNCATE = 1, VALUELIST = ",P,R,T,F,TR") [ SqlColumnNumber = 3, SqlFieldName = AccPD_Type ];

/// AccPD_PreSum
Property AccPDPreSum As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = AccPD_PreSum ];

/// AccPD_PreDate
Property AccPDPreDate As %Library.Date(FORMAT = 1) [ InitialExpression = {+$h}, SqlColumnNumber = 5, SqlFieldName = AccPD_PreDate ];

/// AccPD_PreTime
Property AccPDPreTime As %Library.Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 6, SqlFieldName = AccPD_PreTime ];

/// AccPD_User_DR
Property AccPDUserDR As User.SSUser [ SqlColumnNumber = 7, SqlFieldName = AccPD_User_DR ];

/// Bill No for PrePay money
Property AccPDBillNum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = AccPD_BillNum ];

/// AccPD_PDFoot_DR
Property AccPDPDFootDR As User.DHCINVPRTReports [ SqlColumnNumber = 9, SqlFieldName = AccPD_PDFoot_DR ];

/// AccPD_Left
Property AccPDLeft As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = AccPD_Left ];

/// AccPD_BackReason
Property AccPDBackReason As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = AccPD_BackReason ];

/// AccPD_DepType_DR 押金类型
Property AccPDDepTypeDR As User.ARCDepType [ SqlColumnNumber = 12, SqlFieldName = AccPD_DepType_DR ];

/// AccPD_FootDate
Property AccPDFootDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 13, SqlFieldName = AccPD_FootDate ];

/// AccPD_FootTime
Property AccPDFootTime As %Library.Time [ SqlColumnNumber = 14, SqlFieldName = AccPD_FootTime ];

/// AccPD_FootUser_DR
Property AccPDFootUserDR As User.SSUser [ SqlColumnNumber = 15, SqlFieldName = AccPD_FootUser_DR ];

/// AccPD_AccFI_DR
Property AccPDAccFIDR As User.DHCAccFootInfo [ SqlColumnNumber = 16, SqlFieldName = AccPD_AccFI_DR ];

/// AccPD_Hospital_DR
Property AccPDHospitalDR As User.CTHospital [ Required, SqlColumnNumber = 17, SqlFieldName = AccPD_Hospital_DR ];

/// AccPD_Handin
Property AccPDHandin As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 18, SqlFieldName = AccPD_Handin ];

/// AccPD_InitAccPD_DR
Property AccPDInitAccPDDR As User.DHCAccPreDeposit [ SqlColumnNumber = 19, SqlFieldName = AccPD_InitAccPD_DR ];

/// AccPD_Remark
Property AccPDRemark As %Library.String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = AccPD_Remark ];

/// AccPD_IPAddress
Property AccPDIPAddress As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 21, SqlFieldName = AccPD_IPAddress ];

/// AccPD_AccMFrom_DR 2023-04-07 ZhYW 转入账户指针
Property AccPDAccMFromDR As User.DHCAccManager [ SqlColumnNumber = 22, SqlFieldName = AccPD_AccMFrom_DR ];

/// AccPD_AccMTo_DR 2023-04-07 ZhYW 转出账户指针
Property AccPDAccMToDR As User.DHCAccManager [ SqlColumnNumber = 23, SqlFieldName = AccPD_AccMTo_DR ];

/// AccPD_CardNo 2023-04-21 ZhYW 充值/退款时的使用就诊卡卡号
Property AccPDCardNo As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = AccPD_CardNo ];

/// AccPD_CardType_DR 2023-04-21 ZhYW 充值/退款时的使用就诊卡卡类型
Property AccPDCardTypeDR As User.DHCCardTypeDef [ SqlColumnNumber = 25, SqlFieldName = AccPD_CardType_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="AccPD_AccFI_DR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="AccPD_AccMFrom_DR">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="AccPD_AccMTo_DR">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="AccPD_BackReason">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="AccPD_BillNum">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="AccPD_CardNo">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="AccPD_CardType_DR">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="AccPD_DepType_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="AccPD_FootDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="AccPD_FootTime">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="AccPD_FootUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="AccPD_Handin">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="AccPD_Hospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="AccPD_IPAddress">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="AccPD_InitAccPD_DR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="AccPD_Left">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="AccPD_PDFoot_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="AccPD_PreDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AccPD_PreSum">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AccPD_PreTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AccPD_Remark">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="AccPD_Type">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AccPD_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCACD</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DHC_AccManager.AccM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>AccPD_Sub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"AccM"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{DHC_AccManager.AccM_RowID}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"AccPD"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{AccPD_Sub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAccPDBillNum">
<Global>^DHCACDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHC_AccManager.AccM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>AccPD_Sub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"AccM"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"BillNo"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{AccPD_BillNum}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{DHC_AccManager.AccM_RowID}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>"AccPD"</Expression>
</Subscript>
<Subscript name="7">
<AccessType>sub</AccessType>
<Expression>{AccPD_Sub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAccPDPreDate">
<Global>^DHCACDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHC_AccManager.AccM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>AccPD_Sub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"AccM"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"APDDate"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{AccPD_PreDate}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{DHC_AccManager.AccM_RowID}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>"AccPD"</Expression>
</Subscript>
<Subscript name="7">
<AccessType>sub</AccessType>
<Expression>{AccPD_Sub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexFootDate">
<Global>^DHCACDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHC_AccManager.AccM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>AccPD_Sub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"AccM"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"FD"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{AccPD_FootDate}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{DHC_AccManager.AccM_RowID}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>"AccPD"</Expression>
</Subscript>
<Subscript name="7">
<AccessType>sub</AccessType>
<Expression>{AccPD_Sub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInitDR">
<Global>^DHCACDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHC_AccManager.AccM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>AccPD_Sub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"AccM"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"InitDR"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AccPD_InitAccPD_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHC_AccManager.AccM_RowID}</Expression>
</Subscript>
<Subscript name="6">
<Expression>"AccPD"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{AccPD_Sub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPDFootDR">
<Global>^DHCACDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHC_AccManager.AccM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>AccPD_Sub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"AccM"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"PDFootDR"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{AccPD_PDFoot_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{DHC_AccManager.AccM_RowID}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>"AccPD"</Expression>
</Subscript>
<Subscript name="7">
<AccessType>sub</AccessType>
<Expression>{AccPD_Sub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUser">
<Global>^DHCACDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>DHC_AccManager.AccM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L8}</Expression>
<Field>AccPD_Sub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"AccM"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"User"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{AccPD_User_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{AccPD_PreDate}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{DHC_AccManager.AccM_RowID}</Expression>
</Subscript>
<Subscript name="7">
<AccessType>sub</AccessType>
<Expression>"AccPD"</Expression>
</Subscript>
<Subscript name="8">
<AccessType>sub</AccessType>
<Expression>{AccPD_Sub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUserBillNum">
<Global>^DHCACDi</Global>
<Subscript name="1">
<Expression>"AccM"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"UserBillNo"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AccPD_User_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AccPD_Type}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{AccPD_BillNum}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{DHC_AccManager.AccM_RowID}</Expression>
</Subscript>
<Subscript name="8">
<Expression>"AccPD"</Expression>
</Subscript>
<Subscript name="9">
<Expression>{AccPD_Sub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUserFootDate">
<Global>^DHCACDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>DHC_AccManager.AccM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L8}</Expression>
<Field>AccPD_Sub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"AccM"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"UFDate"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{AccPD_User_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{AccPD_FootDate}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{DHC_AccManager.AccM_RowID}</Expression>
</Subscript>
<Subscript name="7">
<AccessType>sub</AccessType>
<Expression>"AccPD"</Expression>
</Subscript>
<Subscript name="8">
<AccessType>sub</AccessType>
<Expression>{AccPD_Sub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexHandin">
<Global>^DHCACDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>DHC_AccManager.AccM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L8}</Expression>
<Field>AccPD_Sub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"AccM"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"HandIn"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AccPD_Handin}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AccPD_User_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DHC_AccManager.AccM_RowID}</Expression>
</Subscript>
<Subscript name="7">
<Expression>"AccPD"</Expression>
</Subscript>
<Subscript name="8">
<Expression>{AccPD_Sub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCAccPreDepositS</StreamLocation>
<Type>%Storage.SQL</Type>
}

Parameter EXTENTSIZE = 250;

}
