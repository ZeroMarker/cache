Class User.DHCEQInventoryAudit Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = IA_RowID, SqlTableName = DHC_EQInventoryAudit, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// IA_DiffeNum
Property IADiffeNum As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = IA_DiffeNum ];

/// IA_Hold1
Property IAHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = IA_Hold1 ];

/// IA_Hold2
Property IAHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = IA_Hold2 ];

/// IA_Hold3
Property IAHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = IA_Hold3 ];

/// IA_Hold4
Property IAHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = IA_Hold4 ];

/// IA_Hold5
Property IAHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = IA_Hold5 ];

/// IA_InventoryDR
Property IAInventoryDR As User.DHCEQInventory [ SqlColumnNumber = 2, SqlFieldName = IA_InventoryDR ];

/// IA_LocDR
Property IALocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = IA_LocDR ];

/// IA_LoseNum
Property IALoseNum As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = IA_LoseNum ];

/// IA_NotInventoryNum
Property IANotInventoryNum As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = IA_NotInventoryNum ];

/// IA_ProfitNum
Property IAProfitNum As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = IA_ProfitNum ];

/// IA_Remark
Property IARemark As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = IA_Remark ];

/// IA_Status
Property IAStatus As %Library.String(COLLATION = "Exact", DISPLAYLIST = ",新增,盘点科室提交,管理科室确认", MAXLEN = 2, SELECTIVITY = "25%", TRUNCATE = 1, VALUELIST = ",0,1,2") [ SqlColumnNumber = 9, SqlFieldName = IA_Status ];

/// IA_TotalNum
Property IATotalNum As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = IA_TotalNum ];

/// IA_Type
Property IAType As %Library.String(COLLATION = "Exact", DISPLAYLIST = ",盘点状态汇总,处理状态汇总,处理结果汇总", MAXLEN = 2, SELECTIVITY = "25%", TRUNCATE = 1, VALUELIST = ",0,1,2") [ SqlColumnNumber = 16, SqlFieldName = IA_Type ];

/// IA_AuditUserDR
Property IAAuditUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = IA_AuditUserDR ];

/// IA_AuditDate
Property IAAuditDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 18, SqlFieldName = IA_AuditDate ];

/// IA_AuditTime
Property IAAuditTime As %Library.Time [ SqlColumnNumber = 19, SqlFieldName = IA_AuditTime ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQInventoryAudit("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="IA_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="IA_AuditTime">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="IA_AuditUserDR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="IA_DiffeNum">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="IA_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="IA_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="IA_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="IA_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="IA_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="IA_InventoryDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="IA_LocDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="IA_LoseNum">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="IA_NotInventoryNum">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="IA_ProfitNum">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="IA_Remark">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="IA_Status">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="IA_TotalNum">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="IA_Type">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Global>^DHCEQInventoryAudit</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>IA_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{IA_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexInventory">
<Global>^DHCEQInventoryAudit</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>IA_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"Inventory"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{IA_InventoryDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{IA_LocDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{IA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypeInventory">
<Global>^DHCEQInventoryAudit</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>IA_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"TypeInventory"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{IA_Type}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{IA_InventoryDR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{IA_LocDR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{IA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQInventoryAuditS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
