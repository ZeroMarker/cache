Class User.DHCRBMemo Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DM_RowID, SqlTableName = DHCRB_Memo, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DM_Oeorditem_DR
Property DMARCItmMastDR As User.ARCItmMast [ SqlColumnNumber = 2, SqlFieldName = DM_ARCItmMast_DR ];

/// DM_Memo
Property DMMemo As %Library.String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DM_Memo ];

/// DM_ServiceGroupID
Property DMServiceGroupID As User.RBCServiceGroup [ SqlColumnNumber = 4, SqlFieldName = DM_ServiceGroupID ];

/// DM_MTemplate_DR
Property DMMTemplateDR As User.DHCRBCMemoTemplate [ SqlColumnNumber = 6, SqlFieldName = DM_MTemplate_DR ];

/// DM_UseMethod_DR
Property DMUseMethodDR As User.DHCRBCUseMethod [ SqlColumnNumber = 7, SqlFieldName = DM_UseMethod_DR ];

/// DM_BodyPart_DR
Property DMBodyPartDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = DM_BodyPart_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBApp("Memo"))</SqlIdExpression>
<SQLMap name="IndexArcBody">
<Global>^DHCRBAppi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DM_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Memo-ItmBody"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DM_ARCItmMast_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DM_BodyPart_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DM_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexArcImmastDR">
<Global>^DHCRBAppi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DM_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Memo-ItMast"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DM_ARCItmMast_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DM_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexServiceGroup">
<Global>^DHCRBAppi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DM_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ServiceGroupId-Memo"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DM_ServiceGroupID}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DM_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="DM_ARCItmMast_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DM_BodyPart_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DM_MTemplate_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DM_Memo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DM_ServiceGroupID">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DM_UseMethod_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCRBApp</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DM_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Memo"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DM_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBMemoS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
