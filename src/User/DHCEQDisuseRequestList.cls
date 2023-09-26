Class User.DHCEQDisuseRequestList Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DRL_RowID, SqlTableName = DHC_EQDisuseRequestList, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DRL_ChangeReason
Property DRLChangeReason As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = DRL_ChangeReason ];

/// DRL_DisureDate
Property DRLDisureDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = DRL_DisureDate ];

/// DRL_DisuseRequestDR
Property DRLDisuseRequestDR As User.DHCEQDisuseRequest [ SqlColumnNumber = 2, SqlFieldName = DRL_DisuseRequestDR ];

/// DRL_DisuseTypeDR
Property DRLDisuseTypeDR As User.DHCEQCDisuseType [ SqlColumnNumber = 5, SqlFieldName = DRL_DisuseTypeDR ];

/// DRL_EquipDR
Property DRLEquipDR As User.DHCEQEquip [ SqlColumnNumber = 3, SqlFieldName = DRL_EquipDR ];

/// DRL_Hold1
Property DRLHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = DRL_Hold1 ];

/// DRL_Hold2
Property DRLHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = DRL_Hold2 ];

/// DRL_Hold3
Property DRLHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = DRL_Hold3 ];

/// DRL_Remark
Property DRLRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = DRL_Remark ];

/// DRL_UpdateDate
Property DRLUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 10, SqlFieldName = DRL_UpdateDate ];

/// DRL_UpdateTime
Property DRLUpdateTime As %Library.Time [ SqlColumnNumber = 11, SqlFieldName = DRL_UpdateTime ];

/// DRL_UpdateUserDR
Property DRLUpdateUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = DRL_UpdateUserDR ];

/// DRL_UseState
Property DRLUseState As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DRL_UseState ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQDisuseRequestList("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DRL_ChangeReason">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DRL_DisureDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DRL_DisuseRequestDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DRL_DisuseTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DRL_EquipDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DRL_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DRL_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DRL_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DRL_Remark">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DRL_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DRL_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DRL_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DRL_UseState">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCEQDisuseRequestList</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DRL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DRL_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDisuseRequest">
<Global>^DHCEQDisuseRequestList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DRL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"DisuseRequest"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DRL_DisuseRequestDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DRL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexEquipDR">
<Global>^DHCEQDisuseRequestList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DRL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"EquipDR"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DRL_EquipDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DRL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQDisuseRequestListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
