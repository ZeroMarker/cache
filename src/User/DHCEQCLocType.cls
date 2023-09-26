Class User.DHCEQCLocType Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = LT_RowID, SqlTableName = DHC_EQCLocType, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// LT_FromDate
Property LTFromDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = LT_FromDate ];

/// LT_Hold1
Property LTHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = LT_Hold1 ];

/// LT_Hold2
Property LTHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = LT_Hold2 ];

/// LT_Hold3
Property LTHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = LT_Hold3 ];

/// LT_Hold4
Property LTHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = LT_Hold4 ];

/// LT_Hold5
Property LTHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = LT_Hold5 ];

/// LT_Location
Property LTLocation As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = LT_Location ];

/// LT_LocDR
Property LTLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = LT_LocDR ];

/// LT_ManageUserDR
Property LTManageUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = LT_ManageUserDR ];

/// LT_Remark
Property LTRemark As %Library.String(COLLATION = "Exact", MAXLEN = 160, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = LT_Remark ];

/// LT_Tel
Property LTTel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = LT_Tel ];

/// LT_ToDate
Property LTToDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = LT_ToDate ];

/// LT_Type
Property LTType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = LT_Type ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCLocType",0))</SqlIdExpression>
<SQLMap name="DateMaster">
<Data name="LT_FromDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="LT_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="LT_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="LT_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="LT_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="LT_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="LT_LocDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="LT_Location">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="LT_ManageUserDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="LT_Remark">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="LT_Tel">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="LT_ToDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="LT_Type">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>LT_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCLocType"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{LT_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexLoc">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>LT_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DHCEQCLocType"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Loc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LT_LocDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{LT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocType">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>LT_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DHCEQCLocType"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"LocType"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LT_Type}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{LT_LocDR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{LT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCLocTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
