Class User.DHCAppTestLinkTar Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = ATL_RowID, SqlTableName = DHC_AppTestLinkTar, StorageStrategy = SQLStorage ]
{

/// ATL_Itm_Dr	检测项目id	Dr
Property ATLItmDr As User.DHCAppTestItem [ SqlColumnNumber = 2, SqlFieldName = ATL_Itm_Dr ];

/// ATL_Tar_Dr	收费项目id	Dr
Property ATLTarDr As User.DHCTarItem [ SqlColumnNumber = 3, SqlFieldName = ATL_Tar_Dr ];

/// ATL_StartDate	开始日期	Date
Property ATLStartDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 4, SqlFieldName = ATL_StartDate ];

/// ATL_StartTime	开始时间	Time
Property ATLStartTime As %Library.Time(FORMAT = 4) [ SqlColumnNumber = 5, SqlFieldName = ATL_StartTime ];

/// ATL_EndDate		结束日期	Date
Property ATLEndDate As %Library.Date [ SqlColumnNumber = 6, SqlFieldName = ATL_EndDate ];

/// ATL_EndTime	结束时间	Time
Property ATLEndTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = ATL_EndTime ];

/// ATL_UpdUser_Dr	更新人	Dr
Property ATLUpdUserDr As User.SSUser [ SqlColumnNumber = 8, SqlFieldName = ATL_UpdUser_Dr ];

/// ATL_UpdDate	更新日期	Date
Property ATLUpdDate As %Library.Date [ SqlColumnNumber = 9, SqlFieldName = ATL_UpdDate ];

/// ATL_UpdTime	更新时间	Time
Property ATLUpdTime As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = ATL_UpdTime ];

/// ATL_Qty	数量
Property ATLQty As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = ATL_Qty ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCAPPTESTAR)</SqlIdExpression>
<SQLMap name="IndexItem">
<Global>^DHCAPPTESTAR</Global>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>ATL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Test"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ATL_Itm_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ATL_Tar_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ATL_StartDate}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ATL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="ATL_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ATL_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ATL_Itm_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ATL_Qty">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ATL_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ATL_StartTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ATL_Tar_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ATL_UpdDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ATL_UpdTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ATL_UpdUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCAPPTESTAR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ATL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{ATL_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAppTestLinkTarS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
