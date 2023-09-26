Class User.DHCAppArcPartLinkArc Extends %Persistent [ SqlTableName = DHC_AppArcPartLinkArc, StorageStrategy = DHCAppAcPartLinkArc ]
{

/// ALTA_Tar_Dr	收费项目id	Dr
Property ALTAArcListDr As User.ARCItmMast [ SqlColumnNumber = 2, SqlFieldName = ALTA_ArcList_Dr ];

/// ALT_Arc_Dr	检查项目id	Dr
Property ALTAArcDr As User.ARCItmMast [ SqlColumnNumber = 3, SqlFieldName = ALTA_Arc_Dr ];

/// ALT_StartDate	开始日期	Date
Property ALTAStartDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 4, SqlFieldName = ALTA_StartDate ];

/// ALT_StartTime	开始时间	Time
Property ALTAStartTime As %Library.Time(FORMAT = 4) [ SqlColumnNumber = 5, SqlFieldName = ALTA_StartTime ];

/// ALT_EndDate	结束日期	Date
Property ALTAEndDate As %Library.Date [ SqlColumnNumber = 6, SqlFieldName = ALTA_EndDate ];

/// ALT_EndTime	结束时间	Time
Property ALTAEndTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = ALTA_EndTime ];

/// ALT_UpdUser_Dr	更新人	Dr
Property ALTAUpdUserDr As User.SSUser [ SqlColumnNumber = 8, SqlFieldName = ALTA_UpdUser_Dr ];

/// ALT_UpdDate	更新日期	Date
Property ALTAUpdDate As %Library.Date [ SqlColumnNumber = 9, SqlFieldName = ALTA_UpdDate ];

/// ALT_UpdTime	更新时间	Time
Property ALTAUpdTime As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = ALTA_UpdTime ];

/// ALT_Qty	数量
Property ALTAQty As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = ALTA_Qty ];

/// ALT_Part_Dr	部位id
Property ALTAPartDr As User.DHCAppPart [ SqlColumnNumber = 12, SqlFieldName = ALTA_Part_Dr ];

/// 年龄限制
Property ALTAAgeLimits As %String [ SqlColumnNumber = 13, SqlFieldName = ALTA_AgeLimits ];

/// 日期限制
Property ALTADateLimits As %String [ SqlColumnNumber = 14, SqlFieldName = ALTA_DateLimits ];

/// 是否手工选择
Property ALTAByHandle As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 15, SqlFieldName = ALTA_ByHandle ];

Storage DHCAppAcPartLinkArc
{
<SqlIdExpression>$i(^DHCAPARCLARC)</SqlIdExpression>
<SQLMap name="ArcPartIndex">
<Global>^DHCAPARCLARCi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ArcPart"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ALTA_Arc_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ALTA_Part_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="DataMaster">
<Data name="ALTA_AgeLimits">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ALTA_ArcList_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ALTA_Arc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ALTA_ByHandle">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="ALTA_DateLimits">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="ALTA_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ALTA_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ALTA_Part_Dr">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ALTA_Qty">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ALTA_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ALTA_StartTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ALTA_UpdDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ALTA_UpdTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ALTA_UpdUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCAPARCLARC</Global>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>RowID</SqlRowIdName>
<StreamLocation>^User.DHCAppArcPartLinkArcS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
