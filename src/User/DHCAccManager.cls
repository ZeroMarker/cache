Class User.DHCAccManager Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = AccM_RowID, SqlTableName = DHC_AccManager, StorageStrategy = SQLStorage ]
{

Relationship ChildDHCAccPayList As User.DHCAccPayList [ Cardinality = children, Inverse = AccPLParRef ];

Relationship ChildDHCAccPreDeposit As User.DHCAccPreDeposit [ Cardinality = children, Inverse = AccPDParRef ];

Relationship ChildDHCAccStatusChange As User.DHCAccStatusChange [ Cardinality = children, Inverse = AccSCParRef ];

Relationship ChildDHCAccFootInfo As User.DHCAccFootInfo [ Cardinality = children, Inverse = AccFIParRef ];

Relationship ChildDHCAccGroupAccredit As User.DHCAccGroupAccredit [ Cardinality = children, Inverse = AGAAccMParRef ];

/// AccM_AccountNo
Property AccMAccountNo As %Library.String(COLLATION = "Exact", MAXLEN = 16, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = AccM_AccountNo ];

/// AccM_PAPMI_DR
Property AccMPAPMIDR As User.PAPatMas [ SqlColumnNumber = 3, SqlFieldName = AccM_PAPMI_DR ];

/// AccM_PAPMINo
Property AccMPAPMINo As %Library.String(COLLATION = "Exact", MAXLEN = 12, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = AccM_PAPMINo ];

/// Card No Same to DHC_CardRef No
Property AccMCardNo As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = AccM_CardNo ];

/// AccM_OCDate
Property AccMOCDate As %Library.Date(FORMAT = 1) [ InitialExpression = {+$h}, SqlColumnNumber = 6, SqlFieldName = AccM_OCDate ];

/// AccM_OCTime
Property AccMOCTime As %Library.Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 7, SqlFieldName = AccM_OCTime ];

/// AccM_CUser_DR
Property AccMCUserDR As User.SSUser [ SqlColumnNumber = 8, SqlFieldName = AccM_CUser_DR ];

/// AccM_Balance
Property AccMBalance As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = AccM_Balance ];

/// AccM_WoffDate
Property AccMWoffDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 10, SqlFieldName = AccM_WoffDate ];

/// AccM_WoffTime
Property AccMWoffTime As %Library.Time [ SqlColumnNumber = 11, SqlFieldName = AccM_WoffTime ];

/// AccM_DUser_DR
Property AccMDUserDR As User.SSUser [ SqlColumnNumber = 12, SqlFieldName = AccM_DUser_DR ];

/// AccM_PassWord
Property AccMPassWord As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = AccM_PassWord ];

/// AccM_AccStatus
Property AccMAccStatus As %Library.String(DISPLAYLIST = ",Normal,Foot,Suspend", MAXLEN = 7, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",N,F,S") [ SqlColumnNumber = 14, SqlFieldName = AccM_AccStatus ];

/// AccM_DepPrice
Property AccMDepPrice As %Library.Float [ SqlColumnNumber = 15, SqlFieldName = AccM_DepPrice ];

/// AccM_BadPrice
Property AccMBadPrice As %Library.Float [ SqlColumnNumber = 16, SqlFieldName = AccM_BadPrice ];

/// AccM_Type 2023-04-07 ZhYW 增加"家庭账户"(Person:个人账户,Collect:集团账户,Family:家庭账户)
Property AccMType As %Library.String(DISPLAYLIST = ",Person,Collect,Family", MAXLEN = 7, TRUNCATE = 1, VALUELIST = ",P,C,F") [ SqlColumnNumber = 17, SqlFieldName = AccM_Type ];

/// Ref DHC_CredType
Property AccMCredTypeDR As User.DHCCredType [ SqlColumnNumber = 18, SqlFieldName = AccM_CredType_DR ];

/// AccM_CredNo
Property AccMCredNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = AccM_CredNo ];

/// AccM_ARRBDate
Property AccMARRBDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 20, SqlFieldName = AccM_ARRBDate ];

/// AccM_ARREDate
Property AccMARREDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 21, SqlFieldName = AccM_ARREDate ];

/// AccM_Note3
Property AccMNote3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = AccM_Note3 ];

/// AccM_CardType_DR 2023-04-07 ZhYW 就诊卡卡类型
Property AccMCardTypeDR As User.DHCCardTypeDef [ SqlColumnNumber = 23, SqlFieldName = AccM_CardType_DR ];

/// AccM_CreatMode 2023-04-07 ZhYW 账户创建模式(Person:按患者主索引建账户, Card:按卡建账户)
Property AccMCreatMode As %Library.String(DISPLAYLIST = ",Person,Card", TRUNCATE = 1, VALUELIST = ",P,C") [ SqlColumnNumber = 24, SqlFieldName = AccM_CreatMode ];

/// AccM_Hosp_DR
Property AccMHospDR As User.CTHospital [ SqlColumnNumber = 25, SqlFieldName = AccM_Hosp_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCACD("AccM"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="AccM_ARRBDate">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="AccM_ARREDate">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="AccM_AccStatus">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="AccM_AccountNo">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AccM_BadPrice">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="AccM_Balance">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="AccM_CUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="AccM_CardNo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AccM_CardType_DR">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="AccM_CreatMode">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="AccM_CredNo">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="AccM_CredType_DR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="AccM_DUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="AccM_DepPrice">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="AccM_Hosp_DR">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="AccM_Note3">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="AccM_OCDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="AccM_OCTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="AccM_PAPMINo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AccM_PAPMI_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AccM_PassWord">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="AccM_Type">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="AccM_WoffDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="AccM_WoffTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Global>^DHCACD</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>AccM_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"AccM"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{AccM_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAccStatus">
<Global>^DHCACDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>AccM_RowID</Field>
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
<Expression>"AccStatusOnly"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{AccM_AccStatus}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{AccM_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAccountNo">
<Global>^DHCACDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>AccM_RowID</Field>
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
<Expression>"AccountNo"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{AccM_AccountNo}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{AccM_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDUser">
<Global>^DHCACDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>AccM_RowID</Field>
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
<Expression>"DUserDR"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{AccM_DUser_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{AccM_WoffDate}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{AccM_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOCDate">
<Global>^DHCACDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>AccM_RowID</Field>
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
<Expression>"OCDate"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{AccM_OCDate}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{AccM_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSatus">
<Global>^DHCACDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>AccM_RowID</Field>
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
<Expression>"AccStatus"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{AccM_AccStatus}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{AccM_PAPMI_DR}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{AccM_CardNo}</Expression>
</Subscript>
<Subscript name="7">
<AccessType>sub</AccessType>
<Expression>{AccM_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexWOffDate">
<Global>^DHCACDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>AccM_RowID</Field>
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
<Expression>"WOffDate"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{AccM_WoffDate}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{AccM_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexAccType">
<Global>^DHCACDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>AccM_RowID</Field>
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
<Expression>"AccType"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{AccM_Type}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{AccM_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexPAPMI">
<Global>^DHCACDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>AccM_RowID</Field>
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
<Expression>"PAPMI"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{AccM_PAPMI_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{AccM_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCAccManagerS</StreamLocation>
<Type>%Storage.SQL</Type>
}

Parameter EXTENTSIZE = 250;

}
