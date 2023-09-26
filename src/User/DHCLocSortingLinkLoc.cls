Class User.DHCLocSortingLinkLoc Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = SLL_RowID, SqlTableName = DHC_LocSortingLinkLoc, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// SLL_DLS_DR
Property SLLDLSDR As User.DHCLocSorting [ SqlColumnNumber = 2, SqlFieldName = SLL_DLS_DR ];

/// SLL_CTLoc_DR
Property SLLCTLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = SLL_CTLoc_DR ];

/// SLL_AddUser_DR
Property SLLAddUserDR As User.SSUser [ SqlColumnNumber = 4, SqlFieldName = SLL_AddUser_DR ];

/// SLL_AddDate
Property SLLAddDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = SLL_AddDate ];

/// SLL_AddTime
Property SLLAddTime As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = SLL_AddTime ];

/// SLL_UpdateUser_DR
Property SLLUpdateUserDR As User.SSUser [ SqlColumnNumber = 7, SqlFieldName = SLL_UpdateUser_DR ];

/// SLL_UpdateDate
Property SLLUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = SLL_UpdateDate ];

/// SLL_UpdateTime
Property SLLUpdateTime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = SLL_UpdateTime ];

/// Index UNSLLCTLocDR On SLLCTLocDR [ Unique ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCLocSortingLinkLoc)</SqlIdExpression>
<SQLMap name="IndexCTLocDR">
<Global>^DHCLocSortingLinkLoc</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SLL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"CTLoc"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{SLL_CTLoc_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{SLL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDLSDR">
<Global>^DHCLocSortingLinkLoc</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SLL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"DLS"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{SLL_DLS_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{SLL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMaster">
<Data name="SLL_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SLL_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SLL_AddUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SLL_CTLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SLL_DLS_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SLL_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="SLL_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="SLL_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCLocSortingLinkLoc</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>SLL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{SLL_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCLocSortingLinkLocS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
