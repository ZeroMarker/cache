Class User.DHCAppMedLinkTar Extends (%Persistent, %XML.Adaptor) [ SqlTableName = DHC_AppMedLinkTar, StorageStrategy = SQLStorage ]
{

/// AML_Pos_Dr	体位id	Dr
Property AMLDispDr As User.DHCAppDispMedthod [ SqlColumnNumber = 2, SqlFieldName = AML_Disp_Dr ];

/// AML_Tar_Dr	收费项目id	Dr
Property AMLTarDr As User.DHCTarItem [ SqlColumnNumber = 3, SqlFieldName = AML_Tar_Dr ];

/// AML_StartDate	开始日期	Date
Property AMLStartDate As %Library.Date [ SqlColumnNumber = 4, SqlFieldName = AML_StartDate ];

/// AML_StartTime	开始时间	Time
Property AMLStartTime As %Library.Time [ SqlColumnNumber = 5, SqlFieldName = AML_StartTime ];

/// AML_EndDate	结束日期	Date
Property AMLEndDate As %Library.Date [ SqlColumnNumber = 6, SqlFieldName = AML_EndDate ];

/// AML_EndTime	结束时间	Time
Property AMLEndTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = AML_EndTime ];

/// AML_UpdUser_Dr	更新人	Dr
Property AMLUpdUserDr As User.SSUser [ SqlColumnNumber = 8, SqlFieldName = AML_UpdUser_Dr ];

/// AML_UpdDate	更新日期	Date
Property AMLUpdDate As %Library.Date [ SqlColumnNumber = 9, SqlFieldName = AML_UpdDate ];

/// AML_UpdTime	更新时间	Time
Property AMLUpdTime As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = AML_UpdTime ];

/// AML_Qty	数量	Date
Property AMLQty As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = AML_Qty ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCAPMEDTAR)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="AML_Disp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AML_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="AML_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="AML_Qty">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="AML_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AML_StartTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AML_Tar_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AML_UpdDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="AML_UpdTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="AML_UpdUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCAPMEDTAR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>{AML_RowId}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{AML_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="dispIndex">
<Global>^DHCAPMEDTAR</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Med"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AML_Disp_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AML_Tar_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AML_StartDate}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{AML_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>AML_RowId</SqlRowIdName>
<StreamLocation>^User.DHCAppMedLinkTarS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
