Class User.DHCAppPosLinkTar Extends (%Persistent, %XML.Adaptor) [ SqlTableName = DHC_AppPosLinkTar, StorageStrategy = SQLStorage ]
{

/// APL_Pos_Dr	体位id	Dr
Property APLPosDr As User.DHCAppPosition [ SqlColumnNumber = 2, SqlFieldName = APL_Pos_Dr ];

/// APL_Tar_Dr	收费项目id	Dr
Property APLTarDr As User.DHCTarItem [ SqlColumnNumber = 3, SqlFieldName = APL_Tar_Dr ];

/// APL _StartDate	开始日期	Date
Property APLStartDate As %Library.Date [ SqlColumnNumber = 4, SqlFieldName = APL_StartDate ];

/// APL _StartTime	开始时间	Time
Property APLStartTime As %Library.Time [ SqlColumnNumber = 5, SqlFieldName = APL_StartTime ];

/// APL_EndDate	结束日期	Date
Property APLEndDate As %Library.Date [ SqlColumnNumber = 6, SqlFieldName = APL_EndDate ];

/// APL _EndTime	结束时间	Time
Property APLEndTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = APL_EndTime ];

/// APL_UpdUser_Dr	更新人	Dr
Property APLUpdUserDr As User.SSUser [ SqlColumnNumber = 8, SqlFieldName = APL_UpdUser_Dr ];

/// APL_UpdDate	更新日期	Date
Property APLUpdDate As %Library.Date [ SqlColumnNumber = 9, SqlFieldName = APL_UpdDate ];

/// APL_UpdTime	更新时间	Time
Property APLUpdTime As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = APL_UpdTime ];

/// APL_Qty	数量	Date
Property APLQty As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = APL_Qty ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCAPPOSTAR)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="APL_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="APL_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="APL_Pos_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="APL_Qty">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="APL_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="APL_StartTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="APL_Tar_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="APL_UpdDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="APL_UpdTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="APL_UpdUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCAPPOSTAR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>{APL_RowId}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{APL_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="PosTarIndex">
<Global>^DHCAPPOSTAR</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Pos"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{APL_Pos_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{APL_Tar_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{APL_StartDate}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{APL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>APL_RowId</SqlRowIdName>
<StreamLocation>^User.DHCAppPosLinkTarS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
