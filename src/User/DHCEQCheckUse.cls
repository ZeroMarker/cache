Class User.DHCEQCheckUse Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = CU_RowID, SqlTableName = DHC_EQCheckUse, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// CU_EquipDR
Property CUEquipDR As User.DHCEQEquip [ SqlColumnNumber = 2, SqlFieldName = CU_EquipDR ];

/// CU_UseDate
Property CUUseDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = CU_UseDate ];

/// CU_OriginalFee
Property CUOriginalFee As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = CU_OriginalFee ];

/// CU_NetRemainFee
Property CUNetRemainFee As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = CU_NetRemainFee ];

/// CU_LimitYearsNum
Property CULimitYearsNum As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = CU_LimitYearsNum ];

/// CU_UseLocDR
Property CUUseLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = CU_UseLocDR ];

/// CU_Status
Property CUStatus As %Library.String(DISPLAYLIST = ",新增,提交,审核", MAXLEN = 2, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2") [ SqlColumnNumber = 8, SqlFieldName = CU_Status ];

/// CU_Remark
Property CURemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = CU_Remark ];

/// CU_DepreMethodDR
Property CUDepreMethodDR As User.DHCEQCDepreMethod [ SqlColumnNumber = 10, SqlFieldName = CU_DepreMethodDR ];

/// CU_TransAssetDate
Property CUTransAssetDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 11, SqlFieldName = CU_TransAssetDate ];

/// CU_AddUserDR
Property CUAddUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = CU_AddUserDR ];

/// CU_AddDate
Property CUAddDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 13, SqlFieldName = CU_AddDate ];

/// CU_AddTime
Property CUAddTime As %Library.Time [ SqlColumnNumber = 14, SqlFieldName = CU_AddTime ];

/// CU_UpdateUserDR
Property CUUpdateUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = CU_UpdateUserDR ];

/// CU_UpdateDate
Property CUUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 16, SqlFieldName = CU_UpdateDate ];

/// CU_UpdateTime
Property CUUpdateTime As %Library.Time [ SqlColumnNumber = 17, SqlFieldName = CU_UpdateTime ];

/// CU_AuditUserDR
Property CUAuditUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = CU_AuditUserDR ];

/// CU_AuditDate
Property CUAuditDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 19, SqlFieldName = CU_AuditDate ];

/// CU_AuditTime
Property CUAuditTime As %Library.Time [ SqlColumnNumber = 20, SqlFieldName = CU_AuditTime ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCheckUse("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="CU_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="CU_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="CU_AddUserDR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="CU_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="CU_AuditTime">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="CU_AuditUserDR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="CU_DepreMethodDR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CU_EquipDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CU_LimitYearsNum">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CU_NetRemainFee">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CU_OriginalFee">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CU_Remark">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CU_Status">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CU_TransAssetDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="CU_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="CU_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="CU_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="CU_UseDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CU_UseLocDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCEQCheckUse</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CU_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{CU_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexEquip">
<Global>^DHCEQCheckUse</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>CU_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Equip"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CU_EquipDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CU_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCheckUseS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
