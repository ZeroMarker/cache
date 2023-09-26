Class User.DHCPHBox Extends (%Persistent, %XML.Adaptor, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHB_RowID, SqlTableName = DHC_PHBox, StorageStrategy = SQLStorage ]
{

Relationship ChildPHAINBoxItm As User.PHAINBoxItm [ Cardinality = children, Inverse = PIBIPHBParRef ];

/// 箱号
Property PHBNo As %String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ Required, SqlColumnNumber = 2, SqlFieldName = PHB_No ];

Index PHBNoIndex On PHBNo;

/// 箱数
Property PHBNum As %Library.Numeric [ SqlColumnNumber = 3, SqlFieldName = PHB_Num ];

/// 交接人员
Property PHBUserPhHandDr As User.SSUser [ SqlColumnNumber = 4, SqlFieldName = PHB_UserPhHand_Dr ];

/// 交接日期
Property PHBDatePhHand As %Date [ SqlColumnNumber = 5, SqlFieldName = PHB_DatePhHand ];

/// 交接时间
Property PHBTimePhHand As %Time [ SqlColumnNumber = 6, SqlFieldName = PHB_TimePhHand ];

/// 物流人员（送货人员）
Property PHBUserLogisticsDr As %Library.String [ SqlColumnNumber = 7, SqlFieldName = PHB_UserLogistics_Dr ];

/// 病区交接人
Property PHBUserWardHandDr As User.SSUser [ SqlColumnNumber = 8, SqlFieldName = PHB_UserWardHand_Dr ];

/// 病区交接日期
Property PHBDateWardHand As %Date [ SqlColumnNumber = 9, SqlFieldName = PHB_DateWardHand ];

/// 病区交接时间
Property PHBTimeWardHand As %Time [ SqlColumnNumber = 10, SqlFieldName = PHB_TimeWardHand ];

/// 病区核对人
Property PHBUserWardChkDr As User.SSUser [ SqlColumnNumber = 11, SqlFieldName = PHB_UserWardChk_Dr ];

/// 病区核对日期
Property PHBDateWardChk As %Date [ SqlColumnNumber = 12, SqlFieldName = PHB_DateWardChk ];

/// 病区核对时间
Property PHBTimeWardChk As %Time [ SqlColumnNumber = 13, SqlFieldName = PHB_TimeWardChk ];

/// 状态
Property PHBStatus As %Library.String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = PHB_Status ];

/// 作废装箱
Property PHBNoUseFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 15, SqlFieldName = PHB_NoUseFlag ];

/// 供给科室
Property PHBFLocDr As User.CTLoc [ SqlColumnNumber = 16, SqlFieldName = PHB_FLoc_Dr ];

/// 接收科室
Property PHBTLocDr As User.CTLoc [ SqlColumnNumber = 17, SqlFieldName = PHB_TLoc_Dr ];

/// 装箱人
Property PHBUserCreateDr As User.SSUser [ SqlColumnNumber = 18, SqlFieldName = PHB_UserCreate_Dr ];

/// 装箱日期
Property PHBDateCreate As %Date [ SqlColumnNumber = 19, SqlFieldName = PHB_DateCreate ];

/// 装箱时间
Property PHBTimeCreate As %Time [ SqlColumnNumber = 20, SqlFieldName = PHB_TimeCreate ];

/// 备注
Property PHBRemark As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = PHB_Remark ];

/// 汇总标签打印标志
Property PHBPrintFlag As %String(DISPLAYLIST = ",Yes,No,Print", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N,P") [ InitialExpression = "N", SqlColumnNumber = 22, SqlFieldName = PHB_PrintFlag ];

/// 病区物流人
Property PHBWardLogisticsDr As User.SSUser [ SqlColumnNumber = 23, SqlFieldName = PHB_WardLogistics_Dr ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCPHBOX)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PHB_DateCreate">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="PHB_DatePhHand">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHB_DateWardChk">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PHB_DateWardHand">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PHB_FLoc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PHB_No">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHB_NoUseFlag">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PHB_Num">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHB_PrintFlag">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="PHB_Remark">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="PHB_Status">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PHB_TLoc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PHB_TimeCreate">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="PHB_TimePhHand">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHB_TimeWardChk">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PHB_TimeWardHand">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PHB_UserCreate_Dr">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PHB_UserLogistics_Dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PHB_UserPhHand_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHB_UserWardChk_Dr">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PHB_UserWardHand_Dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PHB_WardLogistics_Dr">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Global>^DHCPHBOX</Global>
<PopulationType>full</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHB_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{PHB_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCreateDate">
<Global>^DHCPHBOXi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHB_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"CreateDate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHB_DateCreate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHB_FLoc_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHB_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCreateDatePhLocWard">
<Global>^DHCPHBOXi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>PHB_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CreateDatePhLocWrad"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHB_DateCreate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHB_FLoc_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHB_TLoc_Dr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PHB_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexNo">
<Global>^DHCPHBOXi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PHB_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"No"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHB_No}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHB_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPrint">
<Global>^DHCPHBOXi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PHB_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Print"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHB_FLoc_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHB_DateCreate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHB_PrintFlag}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHB_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexWard">
<Global>^DHCPHBOXi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PHB_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Ward"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHB_TLoc_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHB_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexWardDate">
<Global>^DHCPHBOXi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PHB_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"WardDate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHB_DateCreate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHB_FLoc_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHB_TLoc_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHB_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexWardDateWardHand">
<Global>^DHCPHBOXi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PHB_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"WardDateWardHand"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHB_TLoc_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHB_DateWardHand}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHB_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>User.DHCPHBoxS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCPHBOX)
	s oldI = +$g(^mdata("DHCPHBOX"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCPHBOX = maxI
	s ^mdata("DHCPHBOX") = maxI
}

}
