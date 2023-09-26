Class User.dhcsfbuy Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = buy_rowid, SqlTableName = dhc_sfbuy, StorageStrategy = SQLStorage ]
{

/// buy_date
Property buydate As %Library.Date(FORMAT = 1) [ InitialExpression = {+$h}, SqlColumnNumber = 2, SqlFieldName = buy_date ];

/// buy_time
Property buytime As %Library.Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 3, SqlFieldName = buy_time ];

/// buy_startno
Property buystartno As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = buy_startno ];

/// buy_endno
Property buyendno As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = buy_endno ];

/// buy_payamt
Property buypayamt As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = buy_payamt ];

/// buy_user
Property buyuser As User.SSUser [ SqlColumnNumber = 7, SqlFieldName = buy_user ];

/// buy_loc
Property buyloc As %Library.String(DISPLAYLIST = ",InPatient,OutPatient,Emergency,Registration,Login,Medicare", MAXLEN = 10, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",I,O,E,R,L,M") [ SqlColumnNumber = 8, SqlFieldName = buy_loc ];

/// buy_currentno
Property buycurrentno As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = buy_currentno ];

/// buy_useflag
Property buyuseflag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = buy_useflag ];

/// buy_gruser
Property buygruser As User.SSUser [ SqlColumnNumber = 11, SqlFieldName = buy_gruser ];

/// buy_title
Property buytitle As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = buy_title ];

/// buy_serialno
Property buyserialno As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = buy_serialno ];

/// buy_remain
Property buyremain As %Library.Float [ SqlColumnNumber = 14, SqlFieldName = buy_remain ];

/// buy_comment1
Property buycomment1 As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = buy_comment1 ];

/// buy_comment2
Property buycomment2 As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = buy_comment2 ];

/// buy_hospital
Property buyhospital As User.CTHospital [ SqlColumnNumber = 17, SqlFieldName = buy_hospital ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<Property name="buydate">
<Selectivity>7.6923%</Selectivity>
</Property>
<SqlIdExpression>$i(^DHCSFBUY)</SqlIdExpression>
<SQLMap name="dataMaster">
<Data name="buy_comment1">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="buy_comment2">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="buy_currentno">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="buy_date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="buy_endno">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="buy_gruser">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="buy_hospital">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="buy_loc">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="buy_payamt">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="buy_remain">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="buy_serialno">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="buy_startno">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="buy_time">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="buy_title">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="buy_useflag">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="buy_user">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCSFBUY</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>buy_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{buy_rowid}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexDate">
<Global>^DHCSFBUY</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>buy_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{buy_date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{buy_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexofBeginINVId">
<Global>^DHCSFBUY</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>buy_rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BeginNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{buy_loc}</Expression>
</Subscript>
<Subscript name="4">
<Expression>$l({buy_startno})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{buy_startno}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{buy_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexofBeginInvABCId">
<Global>^DHCSFBUY</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>buy_rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BeginABC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{buy_loc}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{buy_title}</Expression>
</Subscript>
<Subscript name="5">
<Expression>$l({buy_startno})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{buy_startno}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{buy_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.dhcsfbuyS</StreamLocation>
<Type>%Storage.SQL</Type>
}

Parameter EXTENTSIZE = 250;

}
