Class User.DHCPHDraw Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHDW_RowID, SqlTableName = DHC_PHDraw, StorageStrategy = SQLStorage ]
{

Relationship ChildDHCPHDrawInc As User.DHCPHDrawInc [ Cardinality = children, Inverse = PHDWIPHDWParref ];

/// 备药单号
Property PHDWNo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ Required, SqlColumnNumber = 2, SqlFieldName = PHDW_No ];

Index PHDWNoIndex On PHDWNo;

/// 发药药房
Property PHDWPHLocDr As User.CTLoc [ SqlColumnNumber = 3, SqlFieldName = PHDW_PHLoc_Dr ];

/// 病区
Property PHDWWardLocDr As User.CTLoc [ SqlColumnNumber = 4, SqlFieldName = PHDW_WardLoc_Dr ];

/// 类型（送药1、取药2）
Property PHDWType As User.PHAIPReqType [ SqlColumnNumber = 5, SqlFieldName = PHDW_Type ];

/// 备药单状态
Property PHDWStatus As %String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = PHDW_Status ];

/// 创建人
Property PHDWUserCreateDr As User.SSUser [ SqlColumnNumber = 7, SqlFieldName = PHDW_UserCreate_Dr ];

/// 备药人
Property PHDWUserCompDr As User.SSUser [ SqlColumnNumber = 8, SqlFieldName = PHDW_UserComp_Dr ];

/// 装箱人
Property PHDWUserPackDr As User.SSUser [ SqlColumnNumber = 9, SqlFieldName = PHDW_UserPack_Dr ];

/// 生成备药单日期
Property PHDWDateCreate As %Date [ SqlColumnNumber = 10, SqlFieldName = PHDW_DateCreate ];

/// 生成备药单时间
Property PHDWTimeCreate As %Time [ SqlColumnNumber = 11, SqlFieldName = PHDW_TimeCreate ];

/// 备药完成日期
Property PHDWDateComp As %Date [ SqlColumnNumber = 12, SqlFieldName = PHDW_DateComp ];

/// 备药完成时间
Property PHDWTimeComp As %Time [ SqlColumnNumber = 13, SqlFieldName = PHDW_TimeComp ];

/// 核对装箱日期
Property PHDWDatePack As %Date [ SqlColumnNumber = 14, SqlFieldName = PHDW_DatePack ];

/// 核对装箱时间
Property PHDWTimePack As %Time [ SqlColumnNumber = 15, SqlFieldName = PHDW_TimePack ];

/// 装箱号
Property PHDWPHBoxDr As User.DHCPHBox [ SqlColumnNumber = 16, SqlFieldName = PHDW_PHBox_Dr ];

/// 排序规则
Property PHDWSortDr As User.DHCPHDrawSort [ SqlColumnNumber = 17, SqlFieldName = PHDW_Sort_Dr ];

/// 发药主表ID
Property PHDWPhacDr As User.DHCPHACollected [ SqlColumnNumber = 18, SqlFieldName = PHDW_Phac_Dr ];

/// 框二维码
Property PHDWBasketNo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = PHDW_BasketNo ];

/// 当前操作人 (防止重复)
Property PHDWUserCurrDr As User.SSUser [ SqlColumnNumber = 20, SqlFieldName = PHDW_UserCurr_Dr ];

/// 打印标志
Property PHDWPrintFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 21, SqlFieldName = PHDW_PrintFlag ];

Storage SQLStorage
{
<ExtentSize>2</ExtentSize>
<Property name="%%ID">
<AverageFieldSize>3</AverageFieldSize>
<Selectivity>1</Selectivity>
</Property>
<Property name="PHDWDateComp">
<AverageFieldSize>4.5</AverageFieldSize>
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="PHDWDateCreate">
<AverageFieldSize>7</AverageFieldSize>
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="PHDWDatePack">
<AverageFieldSize>4.5</AverageFieldSize>
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="PHDWNo">
<AverageFieldSize>11</AverageFieldSize>
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="PHDWPHBoxDr">
<AverageFieldSize>2.5</AverageFieldSize>
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="PHDWPHLocDr">
<AverageFieldSize>5</AverageFieldSize>
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="PHDWPhacDr">
<AverageFieldSize>3.5</AverageFieldSize>
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="PHDWSortDr">
<AverageFieldSize>2.5</AverageFieldSize>
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="PHDWStatus">
<AverageFieldSize>4</AverageFieldSize>
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="PHDWTimeComp">
<AverageFieldSize>4.5</AverageFieldSize>
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="PHDWTimeCreate">
<AverageFieldSize>7</AverageFieldSize>
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="PHDWTimePack">
<AverageFieldSize>4.5</AverageFieldSize>
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="PHDWType">
<AverageFieldSize>3</AverageFieldSize>
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="PHDWUserCompDr">
<AverageFieldSize>2.5</AverageFieldSize>
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="PHDWUserCreateDr">
<AverageFieldSize>5</AverageFieldSize>
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="PHDWUserPackDr">
<AverageFieldSize>2.5</AverageFieldSize>
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="PHDWWardLocDr">
<AverageFieldSize>5</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<SqlIdExpression>$i(^DHCPHDRAW)</SqlIdExpression>
<SQLMap name="DataMaster">
<BlockCount>-4</BlockCount>
<Data name="PHDW_BasketNo">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="PHDW_DateComp">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PHDW_DateCreate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PHDW_DatePack">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PHDW_No">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHDW_PHBox_Dr">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PHDW_PHLoc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHDW_Phac_Dr">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PHDW_PrintFlag">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="PHDW_Sort_Dr">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PHDW_Status">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHDW_TimeComp">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PHDW_TimeCreate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PHDW_TimePack">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PHDW_Type">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHDW_UserComp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PHDW_UserCreate_Dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PHDW_UserCurr_Dr">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="PHDW_UserPack_Dr">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PHDW_WardLoc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCPHDRAW</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHDW_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{PHDW_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexBasketNo">
<Global>^DHCPHDRAWi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PHDW_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"BasketNo"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHDW_PHLoc_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHDW_DateCreate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHDW_BasketNo}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHDW_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexBox">
<BlockCount>-4</BlockCount>
<Global>^DHCPHDRAWi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PHDW_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Box"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHDW_PHBox_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHDW_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCreateUserDrDate">
<Global>^DHCPHDRAWi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHDW_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"CreateUserDrDate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHDW_UserCreate_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHDW_DateCreate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHDW_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDispLocId">
<BlockCount>-4</BlockCount>
<Global>^DHCPHDRAWi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PHDW_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DispLocId"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHDW_PHLoc_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHDW_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocDate">
<BlockCount>-4</BlockCount>
<Global>^DHCPHDRAWi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHDW_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"LocDate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHDW_PHLoc_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHDW_DateCreate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHDW_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexNo">
<BlockCount>-4</BlockCount>
<Global>^DHCPHDRAWi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PHDW_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"No"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>{PHDW_No}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{PHDW_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPha">
<Global>^DHCPHDRAWi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PHDW_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"PHA"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHDW_Phac_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHDW_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStatus">
<BlockCount>-4</BlockCount>
<Global>^DHCPHDRAWi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHDW_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Status"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHDW_PHLoc_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHDW_Status}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHDW_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStatusDate">
<Global>^DHCPHDRAWi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PHDW_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"StatusDate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHDW_PHLoc_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHDW_DateCreate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHDW_Status}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHDW_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexWard">
<Global>^DHCPHDRAWi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PHDW_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Ward"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHDW_WardLoc_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHDW_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexWardDate">
<BlockCount>-4</BlockCount>
<Global>^DHCPHDRAWi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHDW_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"WardDate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHDW_WardLoc_Dr}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{PHDW_DateCreate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHDW_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexUserIDStatus">
<Global>^DHCPHDRAWi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHDW_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"UserIDStatus"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHDW_UserCreate_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHDW_Status}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHDW_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPHDrawS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCPHDRAW)
	s oldI = +$g(^mdata("DHCPHDRAW"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCPHDRAW = maxI
	s ^mdata("DHCPHDRAW") = maxI
}

}
