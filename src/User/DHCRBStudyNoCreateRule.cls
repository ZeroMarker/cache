Class User.DHCRBStudyNoCreateRule Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = RSC_Rowid, SqlTableName = DHCRB_StudyNo_CreateRule, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// RSC_EQGroup_DR
Property RSCEQGroupDR As User.RBCEquipmentGroup [ SqlColumnNumber = 2, SqlFieldName = RSC_EQGroup_DR ];

/// RSC_Prefix
Property RSCPrefix As %Library.String(COLLATION = "Exact", MAXLEN = 15, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = RSC_Prefix ];

/// RSC_Loc_DR
Property RSCLocDR As User.CTLoc [ SqlColumnNumber = 4, SqlFieldName = RSC_Loc_DR ];

/// RSC_MaxNumber
Property RSCMaxNumber As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = RSC_MaxNumber ];

/// RSC_AppType
Property RSCAppType As %Library.String(COLLATION = "Exact", MAXLEN = 2, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = RSC_AppType ];

/// RSC_SUBORDERCAT_DR
Property RSCSUBORDERCATDR As User.ARCItemCat [ SqlColumnNumber = 7, SqlFieldName = RSC_SUBORDERCAT_DR ];

/// RSC_Operation_DR
Property RSCOperationDR As User.DHCRBCPatientStatus [ SqlColumnNumber = 8, SqlFieldName = RSC_Operation_DR ];

/// RSC_MoreStudyNo
Property RSCMoreStudyNo As %Library.String(COLLATION = "Exact", MAXLEN = 15, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = RSC_MoreStudyNo ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPACRegInfoCR("CreateRule",0))</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="RSC_AppType">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="RSC_EQGroup_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RSC_Loc_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="RSC_MaxNumber">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="RSC_MoreStudyNo">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="RSC_Operation_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="RSC_Prefix">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RSC_SUBORDERCAT_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCPACRegInfoCR</Global>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>RSC_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CreateRule"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RSC_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexEQGroup">
<Global>^DHCPACRegInfoCRi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RSC_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"EQG_CreateNo"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RSC_EQGroup_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RSC_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLoc">
<Global>^DHCPACRegInfoCRi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RSC_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"LocCreateNo"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RSC_Loc_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RSC_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocEqGroup">
<Global>^DHCPACRegInfoCRi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RSC_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"LocEQGroupRule"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RSC_Loc_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RSC_EQGroup_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RSC_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSubOrderCat">
<Global>^DHCPACRegInfoCRi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>RSC_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SubOrderCat"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RSC_SUBORDERCAT_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RSC_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCRBStudyNoCreateRuleS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
