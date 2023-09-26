Class User.DHCEQBindObj Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = BO_RowID, SqlTableName = DHC_EQBindObj, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// BO_SourceType
Property BOSourceType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = BO_SourceType ];

/// BO_SourceID
Property BOSourceID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = BO_SourceID ];

/// BO_BindType
Property BOBindType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = BO_BindType ];

/// BO_BindID
Property BOBindID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = BO_BindID ];

/// BO_BindNo
Property BOBindNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = BO_BindNo ];

/// BO_BindUserDR
Property BOBindUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = BO_BindUserDR ];

/// BO_FromDate
Property BOFromDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = BO_FromDate ];

/// BO_FromTime
Property BOFromTime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = BO_FromTime ];

/// BO_UnBindUserDR
Property BOUnBindUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = BO_UnBindUserDR ];

/// BO_ToDate
Property BOToDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 11, SqlFieldName = BO_ToDate ];

/// BO_ToTime
Property BOToTime As %Library.Time [ SqlColumnNumber = 12, SqlFieldName = BO_ToTime ];

/// BO_Remark
Property BORemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = BO_Remark ];

/// BO_InvalidFlag
Property BOInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 14, SqlFieldName = BO_InvalidFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQBindObj("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="BO_BindID">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="BO_BindNo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="BO_BindType">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="BO_BindUserDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="BO_FromDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="BO_FromTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="BO_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="BO_Remark">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="BO_SourceID">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="BO_SourceType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="BO_ToDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="BO_ToTime">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="BO_UnBindUserDR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^DHCEQBindObj</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>BO_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{BO_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexBindNo">
<Global>^DHCEQBindObj</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>L5</Expression>
<Field>BO_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BindNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BO_InvalidFlag}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BO_BindNo}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{BO_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSourceID">
<Global>^DHCEQBindObj</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>BO_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"SourceID"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{BO_InvalidFlag}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{BO_SourceType}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{BO_SourceID}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>Sub</AccessType>
<Expression>{BO_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQBindObjS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
