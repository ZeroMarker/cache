Class User.DHCEQChangeName Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = CN_RowID, SqlTableName = DHC_EQChangeName, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// CN_EquipDR
Property CNEquipDR As User.DHCEQEquip [ SqlColumnNumber = 2, SqlFieldName = CN_EquipDR ];

/// CN_FromCatDR
Property CNFromCatDR As User.DHCEQCEquipeCat [ SqlColumnNumber = 3, SqlFieldName = CN_FromCatDR ];

/// CN_ToCatDR
Property CNToCatDR As User.DHCEQCEquipeCat [ SqlColumnNumber = 4, SqlFieldName = CN_ToCatDR ];

/// CN_ChangeReason
Property CNChangeReason As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = CN_ChangeReason ];

/// CN_ChangeDate
Property CNChangeDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = CN_ChangeDate ];

/// CN_Remark
Property CNRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = CN_Remark ];

/// CN_Status
Property CNStatus As %Library.String(DISPLAYLIST = ",新增,提交,审核,作废", MAXLEN = 2, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2,3") [ SqlColumnNumber = 8, SqlFieldName = CN_Status ];

/// CN_AddUserDR
Property CNAddUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = CN_AddUserDR ];

/// CN_AddDate
Property CNAddDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 10, SqlFieldName = CN_AddDate ];

/// CN_AddTime
Property CNAddTime As %Library.Time [ SqlColumnNumber = 11, SqlFieldName = CN_AddTime ];

/// CN_UpdateUserDR
Property CNUpdateUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = CN_UpdateUserDR ];

/// CN_UpdateDate
Property CNUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 13, SqlFieldName = CN_UpdateDate ];

/// CN_UpdateTime
Property CNUpdateTime As %Library.Time [ SqlColumnNumber = 14, SqlFieldName = CN_UpdateTime ];

/// CN_AuditUserDR
Property CNAuditUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = CN_AuditUserDR ];

/// CN_AuditDate
Property CNAuditDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 16, SqlFieldName = CN_AuditDate ];

/// CN_AuditTime
Property CNAuditTime As %Library.Time [ SqlColumnNumber = 17, SqlFieldName = CN_AuditTime ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQChangeName("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="CN_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CN_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="CN_AddUserDR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CN_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="CN_AuditTime">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="CN_AuditUserDR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="CN_ChangeDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CN_ChangeReason">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CN_EquipDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CN_FromCatDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CN_Remark">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CN_Status">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CN_ToCatDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CN_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="CN_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="CN_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Global>^DHCEQChangeName</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CN_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{CN_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexEquip">
<Global>^DHCEQChangeName</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>CN_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Equip"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CN_EquipDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CN_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQChangeNameS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
