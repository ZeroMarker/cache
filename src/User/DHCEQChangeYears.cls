Class User.DHCEQChangeYears Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = CY_RowID, SqlTableName = DHC_EQChangeYears, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// CY_EquipDR
Property CYEquipDR As User.DHCEQEquip [ SqlColumnNumber = 2, SqlFieldName = CY_EquipDR ];

/// CY_FromYearsNum
Property CYFromYearsNum As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = CY_FromYearsNum ];

/// CY_ToYearsNum
Property CYToYearsNum As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = CY_ToYearsNum ];

/// CY_ChangeReason
Property CYChangeReason As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = CY_ChangeReason ];

/// CY_ChangeDate
Property CYChangeDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = CY_ChangeDate ];

/// CY_Remark
Property CYRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = CY_Remark ];

/// CY_Status
Property CYStatus As %Library.String(DISPLAYLIST = ",新增,提交,审核,作废", MAXLEN = 2, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2,3") [ SqlColumnNumber = 8, SqlFieldName = CY_Status ];

/// CY_AddUserDR
Property CYAddUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = CY_AddUserDR ];

/// CY_AddDate
Property CYAddDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 10, SqlFieldName = CY_AddDate ];

/// CY_AddTime
Property CYAddTime As %Library.Time [ SqlColumnNumber = 11, SqlFieldName = CY_AddTime ];

/// CY_UpdateUserDR
Property CYUpdateUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = CY_UpdateUserDR ];

/// CY_UpdateDate
Property CYUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 13, SqlFieldName = CY_UpdateDate ];

/// CY_UpdateTime
Property CYUpdateTime As %Library.Time [ SqlColumnNumber = 14, SqlFieldName = CY_UpdateTime ];

/// CY_AuditUserDR
Property CYAuditUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = CY_AuditUserDR ];

/// CY_AuditDate
Property CYAuditDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 16, SqlFieldName = CY_AuditDate ];

/// CY_AuditTime
Property CYAuditTime As %Library.Time [ SqlColumnNumber = 17, SqlFieldName = CY_AuditTime ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQChangeYears("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="CY_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CY_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="CY_AddUserDR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CY_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="CY_AuditTime">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="CY_AuditUserDR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="CY_ChangeDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CY_ChangeReason">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CY_EquipDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CY_FromYearsNum">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CY_Remark">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CY_Status">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CY_ToYearsNum">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CY_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="CY_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="CY_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Global>^DHCEQChangeYears</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CY_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{CY_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexEquip">
<Global>^DHCEQChangeYears</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>CY_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Equip"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CY_EquipDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CY_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQChangeYearsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
