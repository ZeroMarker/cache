Class User.DHCAppArcLinkTar Extends (%Persistent, %XML.Adaptor) [ SqlTableName = DHC_AppArcLinkTar, StorageStrategy = SQLStorage ]
{

/// ALT_Tar_Dr	收费项目id	Dr
Property ALTTarDr As User.DHCTarItem [ SqlColumnNumber = 2, SqlFieldName = ALT_Tar_Dr ];

/// ALT_Arc_Dr	检查项目id	Dr
Property ALTArcDr As User.ARCItmMast [ SqlColumnNumber = 3, SqlFieldName = ALT_Arc_Dr ];

/// ALT_StartDate	开始日期	Date
Property ALTStartDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 4, SqlFieldName = ALT_StartDate ];

/// ALT_StartTime	开始时间	Time
Property ALTStartTime As %Library.Time(FORMAT = 4) [ SqlColumnNumber = 5, SqlFieldName = ALT_StartTime ];

/// ALT_EndDate	结束日期	Date
Property ALTEndDate As %Library.Date [ SqlColumnNumber = 6, SqlFieldName = ALT_EndDate ];

/// ALT_EndTime	结束时间	Time
Property ALTEndTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = ALT_EndTime ];

/// ALT_UpdUser_Dr	更新人	Dr
Property ALTUpdUserDr As User.SSUser [ SqlColumnNumber = 8, SqlFieldName = ALT_UpdUser_Dr ];

/// ALT_UpdDate	更新日期	Date
Property ALTUpdDate As %Library.Date [ SqlColumnNumber = 9, SqlFieldName = ALT_UpdDate ];

/// ALT_UpdTime	更新时间	Time
Property ALTUpdTime As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = ALT_UpdTime ];

/// ALT_Qty	数量
Property ALTQty As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = ALT_Qty ];

/// ALT_BaseFlag	基价标置
Property ALTBaseFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 12, SqlFieldName = ALT_BaseFlag ];

/// ALT_Part_Dr	部位id
Property ALTPartDr As User.DHCAppPart [ SqlColumnNumber = 13, SqlFieldName = ALT_Part_Dr ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCAPARCLTA)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ALT_Arc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ALT_BaseFlag">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ALT_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ALT_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ALT_Part_Dr">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ALT_Qty">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ALT_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ALT_StartTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ALT_Tar_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ALT_UpdDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ALT_UpdTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ALT_UpdUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCAPARCLTA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>{ALT_RowId}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{ALT_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="arcTarIndex">
<Global>^DHCAPARCLTA</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Arc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ALT_Arc_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ALT_Tar_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ALT_StartDate}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ALT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ALT_RowId</SqlRowIdName>
<StreamLocation>^User.DHCAppArcLinkTarS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
