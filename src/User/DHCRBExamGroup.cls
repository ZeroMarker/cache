Class User.DHCRBExamGroup Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DREG_RowID, SqlTableName = DHCRB_ExamGroup, StorageStrategy = SQLStorage ]
{

/// DREGItmMastDR停止使用  
/// DREGRelationOfChildTable 默认是in ， 只有DREGItemCatDR有值时才起作用
Parameter EXTENTSIZE = 250;

Relationship ChildDHCRBExamGroupItem As User.DHCRBExamGroupItem [ Cardinality = children, Inverse = DHCRBExamGroup ];

/// DREG_ARCIMRowId
Property DREGItmMastDR As User.ARCItmMast [ SqlColumnNumber = 2, SqlFieldName = DREG_ItmMast_DR ];

/// DREG_ItemCat_DR
Property DREGItemCatDR As User.ARCItemCat [ SqlColumnNumber = 3, SqlFieldName = DREG_ItemCat_DR ];

/// DREG_RelationShipOfChildTable
Property DREGRelationOfChildTable As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DREG_RelationOfChildTable ];

/// DREG_GroupName
Property DREGGroupName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = DREG_GroupName ];

/// DREG_GroupCode
Property DREGGroupCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = DREG_GroupCode ];

/// DREG_ItemCatCode 
Property DREGItemCatCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = DREG_ItemCatCode ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBExamGroup)</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^DHCRBExamGroupi</Global>
<Subscript name="1">
<Expression>"GourpCode"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DREG_GroupCode}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DREG_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexItemCat">
<Global>^DHCRBExamGroupi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DREG_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ItemCat"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DREG_ItemCat_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DREG_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexItmMast">
<Global>^DHCRBExamGroupi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DREG_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ItmMast"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DREG_ItmMast_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DREG_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterDataIndex">
<Data name="DREG_GroupCode">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DREG_GroupName">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DREG_ItemCatCode">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DREG_ItemCat_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DREG_ItmMast_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DREG_RelationOfChildTable">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCRBExamGroup</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DREG_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DREG_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBExamGroupS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
