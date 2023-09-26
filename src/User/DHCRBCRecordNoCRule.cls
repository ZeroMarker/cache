Class User.DHCRBCRecordNoCRule Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DRCR_RowID, SqlTableName = DHCRBC_RecordNo_CRule, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DRCR_Loc_DR
Property DRCRLocDR As User.CTLoc [ SqlColumnNumber = 2, SqlFieldName = DRCR_Loc_DR ];

/// DRCR_Prefix
Property DRCRPrefix As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DRCR_Prefix ];

/// DRCR_CreateType
Property DRCRCreateType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DRCR_CreateType ];

/// DRCR_OperationType
Property DRCROperationType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = DRCR_OperationType ];

/// DRCR_EqGroup_DR
Property DRCREqGroupDR As User.RBCEquipmentGroup [ SqlColumnNumber = 6, SqlFieldName = DRCR_EqGroup_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBCRecordNoCreateRule)</SqlIdExpression>
<SQLMap name="IndexEQGroupNo">
<Global>^DHCRBCRecordNoCreateRulei</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DRCR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"EQGroupCreateNo"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DRCR_EqGroup_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DRCR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocEQGroupNo">
<Global>^DHCRBCRecordNoCreateRulei</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DRCR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"LocEQGroupRule"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DRCR_Loc_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DRCR_EqGroup_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DRCR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocNo">
<Global>^DHCRBCRecordNoCreateRulei</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DRCR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"LocCreateNo"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DRCR_Loc_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DRCR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterMap">
<Data name="DRCR_CreateType">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DRCR_EqGroup_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DRCR_Loc_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DRCR_OperationType">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DRCR_Prefix">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCRBCRecordNoCreateRule</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DRCR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DRCR_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCRecordNoCRuleS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
