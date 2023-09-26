Class User.DHCEQCAlias Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = A_RowID, SqlTableName = DHC_EQCAlias, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// A_RowID
Property AText As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = A_Text ];

/// A_Desc
Property ADesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = A_Desc ];

/// A_SourceType
Property ASourceType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = A_SourceType ];

/// A_SourceID
Property ASourceID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = A_SourceID ];

/// A_DateFrom
Property ADateFrom As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = A_DateFrom ];

/// A_DateTo
Property ADateTo As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = A_DateTo ];

/// A_Remark
Property ARemark As %Library.String(COLLATION = "Exact", MAXLEN = 160, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = A_Remark ];

/// A_InvalidFlag
Property AInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = A_InvalidFlag ];

/// A_Type
Property AType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = A_Type ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCAlias",0))</SqlIdExpression>
<SQLMap name="DateMaster">
<Data name="A_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="A_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="A_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="A_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="A_Remark">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="A_SourceID">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="A_SourceType">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="A_Text">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="A_Type">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>A_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCAlias"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{A_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>A_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DHCEQCAlias"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{A_SourceType}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{A_Desc}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{A_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSourceID">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>A_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DHCEQCAlias"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"SourceID"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{A_SourceType}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{A_SourceID}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{A_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexText">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>A_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DHCEQCAlias"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Text"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{A_SourceType}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{A_Text}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{A_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCAliasS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
