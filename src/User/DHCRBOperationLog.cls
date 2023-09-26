Class User.DHCRBOperationLog Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DOL_RowID, SqlTableName = DHCRB_OperationLog, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DOL_User_DR
Property DOLUserDR As User.SSUser [ SqlColumnNumber = 2, SqlFieldName = DOL_User_DR ];

/// DOL_IP
Property DOLIP As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DOL_IP ];

/// DOL_OperationDate
Property DOLOperationDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = DOL_OperationDate ];

/// DOL_OperationTime
Property DOLOperationTime As %Library.Time [ SqlColumnNumber = 5, SqlFieldName = DOL_OperationTime ];

/// DOL_RegNO
Property DOLRegNO As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = DOL_RegNO ];

/// DOL_OeItem_DR
Property DOLOeItemDR As User.OEOrdItem [ SqlColumnNumber = 7, SqlFieldName = DOL_OeItem_DR ];

/// DOL_Content
Property DOLContent As %Library.String(COLLATION = "Exact", MAXLEN = 1024, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = DOL_Content ];

/// DOL_Content
Property DOLNote As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = DOL_Note ];

/// DOL_OpeType
Property DOLOpeType As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = DOL_OpeType ];

/// DOL_OpeLoc
Property DOLOpeLoc As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = DOL_OpeLoc ];

/// DOL_OpeSource
Property DOLOpeSource As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = DOL_OpeSource ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBOperationLog)</SqlIdExpression>
<SQLMap name="IndexByLocID">
<Global>^DHCRBOperationLogi</Global>
<Subscript name="1">
<Expression>"LocID"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DOL_OpeLoc}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DOL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocDate">
<Global>^DHCRBOperationLogi</Global>
<Subscript name="1">
<Expression>"loc-Date"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DOL_OpeLoc}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DOL_OperationDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DOL_OperationTime}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DOL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOeItemDR">
<Global>^DHCRBOperationLogi</Global>
<Subscript name="1">
<Expression>"OeItem"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DOL_OeItem_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DOL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRegNo">
<Global>^DHCRBOperationLogi</Global>
<Subscript name="1">
<Expression>"OeItemDR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DOL_RegNO}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DOL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUser">
<Global>^DHCRBOperationLogi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DOL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"User"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DOL_User_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DOL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterMap">
<Data name="DOL_Content">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DOL_IP">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DOL_Note">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DOL_OeItem_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DOL_OpeLoc">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DOL_OpeSource">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DOL_OpeType">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DOL_OperationDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DOL_OperationTime">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DOL_RegNO">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DOL_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCRBOperationLog</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DOL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DOL_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBOperationLogS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
