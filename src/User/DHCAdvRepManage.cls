Class User.DHCAdvRepManage Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = ARMA_RowID, SqlTableName = DHC_AdvRepManage, StorageStrategy = NewStorage1 ]
{

/// ARMA_Type_Dr	报告类别
Property ARMATypeDr As %String [ SqlColumnNumber = 2, SqlFieldName = ARMA_Type_Dr ];

/// ARMA_Pointer	指针
Property ARMAPointer As %String [ SqlColumnNumber = 3, SqlFieldName = ARMA_Pointer ];

/// ARMA_Level_Dr	分级
Property ARMALevelDr As %String [ SqlColumnNumber = 4, SqlFieldName = ARMA_Level_Dr ];

/// ARMA_Cat_Dr	描述
Property ARMACatDr As User.DHCAdvMedRepCat [ SqlColumnNumber = 5, SqlFieldName = ARMA_Cat_Dr ];

/// ARMA_DealMeth_Dr	处理办法
Property ARMADealMethDr As User.DHCAdvDealMethod [ SqlColumnNumber = 6, SqlFieldName = ARMA_DealMeth_Dr ];

/// ARMA_ImpMeth_Dr	改进办法
Property ARMAImpMethDr As User.DHCAdvImpMethod [ SqlColumnNumber = 7, SqlFieldName = ARMA_ImpMeth_Dr ];

/// ARMA_AdviceTxt	职能部门意见陈述
Property ARMAAdviceTxt As %String(COLLATION = "Exact", MAXLEN = 30000, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = ARMA_AdviceTxt ];

/// ARMA_ImpTxt	改进措施
Property ARMAImpTxt As %String(COLLATION = "Exact", MAXLEN = 30000, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = ARMA_ImpTxt ];

/// ARMA_ImpDate	改进措施日期
Property ARMAImpDate As %Date [ SqlColumnNumber = 10, SqlFieldName = ARMA_ImpDate ];

/// ARMA_ImpTime	改进措施时间
Property ARMAImpTime As %Time [ SqlColumnNumber = 11, SqlFieldName = ARMA_ImpTime ];

/// ARMA_ImpUser	改进措施签名
Property ARMAImpUser As %String [ SqlColumnNumber = 12, SqlFieldName = ARMA_ImpUser ];

/// ARMA_ReasonDate	意见陈述日期
Property ARMAReasonDate As %Date [ SqlColumnNumber = 13, SqlFieldName = ARMA_ReasonDate ];

/// ARMA_ReasonTime	意见陈述时间
Property ARMAReasonTime As %Time [ SqlColumnNumber = 14, SqlFieldName = ARMA_ReasonTime ];

/// ARMA_ReasonUser	意见陈述签名
Property ARMAReasonUser As %String [ SqlColumnNumber = 15, SqlFieldName = ARMA_ReasonUser ];

/// ARMA_HarmLevel_Dr	损害级别
Property ARMAHarmLevelDr As %String [ SqlColumnNumber = 16, SqlFieldName = ARMA_HarmLevel_Dr ];

/// 奖罚情况 lp 2018-1-3
Property ARMAReward As %String [ SqlColumnNumber = 17, SqlFieldName = ARMA_Reward ];

/// 不良事件分级 lp 2018-1-16
Property ARMAEventLevel As %String [ SqlColumnNumber = 18, SqlFieldName = ARMA_EventLevel ];

/// 科室意见标志 lp 2018-1-16 Y-同意 N-其他意见
Property ARMALocAdviceFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 19, SqlFieldName = ARMA_LocAdviceFlag ];

/// 质控科室意见陈述 lp 2018-1-16
Property ARMAQuaLocAdviceTxt As %String(COLLATION = "Exact", MAXLEN = 30000, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = ARMA_QuaLocAdviceTxt ];

/// 讨论结果分享 lp 2018-1-16
Property ARMADisResultShare As %String [ SqlColumnNumber = 21, SqlFieldName = ARMA_DisResultShare ];

/// 评估人 
Property ARMAManageUser As %String [ SqlColumnNumber = 22, SqlFieldName = ARMA_ManageUser ];

/// 评估日期
Property ARMAManageDate As %Date [ SqlColumnNumber = 23, SqlFieldName = ARMA_ManageDate ];

/// 评估时间
Property ARMAManageTime As %Time [ SqlColumnNumber = 24, SqlFieldName = ARMA_ManageTime ];

/// 评估科室
Property ARMAManageLocDr As User.CTLoc [ SqlColumnNumber = 25, SqlFieldName = ARMA_ManageLoc_Dr ];

/// 当事人类型
Property ARMAPartyType As %String [ SqlColumnNumber = 26, SqlFieldName = ARMA_PartyType ];

/// 当事人职称
Property ARMAPartyTitle As %String [ SqlColumnNumber = 27, SqlFieldName = ARMA_PartyTitle ];

Storage NewStorage1
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCADVREPMAN)</SqlIdExpression>
<SQLMap name="IndexCatDr">
<Global>^DHCADVREPMAN</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ARMA_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CatDr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ARMA_Cat_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARMA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDealMeth">
<Global>^DHCADVREPMAN</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ARMA_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DealMeth"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ARMA_DealMeth_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARMA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexImpMeth">
<Global>^DHCADVREPMAN</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ARMA_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ImpMeth"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ARMA_ImpMeth_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARMA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPointer">
<Global>^DHCADVREPMAN</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ARMA_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Pointer"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ARMA_Pointer}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARMA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypePointer">
<Global>^DHCADVREPMAN</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ARMA_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TyepPointer"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ARMA_Type_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARMA_Pointer}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ARMA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="ARMA_AdviceTxt">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ARMA_Cat_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ARMA_DealMeth_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ARMA_DisResultShare">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="ARMA_EventLevel">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="ARMA_HarmLevel_Dr">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="ARMA_ImpDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ARMA_ImpMeth_Dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ARMA_ImpTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ARMA_ImpTxt">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ARMA_ImpUser">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ARMA_Level_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ARMA_LocAdviceFlag">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="ARMA_ManageDate">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="ARMA_ManageLoc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="ARMA_ManageTime">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="ARMA_ManageUser">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="ARMA_PartyTitle">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="ARMA_PartyType">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="ARMA_Pointer">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ARMA_QuaLocAdviceTxt">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="ARMA_ReasonDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ARMA_ReasonTime">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="ARMA_ReasonUser">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="ARMA_Reward">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="ARMA_Type_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCADVREPMAN</Global>
<Subscript name="1">
<Expression>{ARMA_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAdvRepManageS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
