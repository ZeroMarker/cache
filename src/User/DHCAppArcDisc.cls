Class User.DHCAppArcDisc Extends (%Persistent, %XML.Adaptor) [ SqlTableName = DHC_AppArcDisc, StorageStrategy = SQLStorage ]
{

// AD_Arc_Dr	医嘱项id	Dr

Property ADArcDr As User.ARCItmMast [ SqlColumnNumber = 2, SqlFieldName = AD_Arc_Dr ];

// AD_PartNum	部位数	Number

Property ADPartNum As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = AD_PartNum ];

// AD_Discount	打折系数	Number

Property ADDiscount As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = AD_Discount ];

// AD_StartDate	开始日期	Date

Property ADStartDate As %Library.Date [ SqlColumnNumber = 5, SqlFieldName = AD_StartDate ];

// AD_StartTime	开始时间	Time

Property ADStartTime As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = AD_StartTime ];

// AD_EndDate	结束日期	Date

Property ADEndDate As %Library.Date [ SqlColumnNumber = 7, SqlFieldName = AD_EndDate ];

// AD_EndTime	结束时间	Time

Property ADEndTime As %Library.Time [ SqlColumnNumber = 8, SqlFieldName = AD_EndTime ];

// AD_UpdUser_Dr	更新人	Dr

Property ADUpdUserDr As User.SSUser [ SqlColumnNumber = 9, SqlFieldName = AD_UpdUser_Dr ];

// AD_UpdDate	更新日期	Date

Property ADUpdDate As %Library.Date [ SqlColumnNumber = 10, SqlFieldName = AD_UpdDate ];

// AD_UpdTime	更新时间	Time

Property ADUpdTime As %Library.Time [ SqlColumnNumber = 11, SqlFieldName = AD_UpdTime ];

// 0是门诊,1是住院，2全部

Property ADOutFlag As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = AD_OutFlag ];

// 医院

Property ADHospital As CTHospital [ SqlColumnNumber = 13, SqlFieldName = AD_Hospital ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCAPARCDIS)</SqlIdExpression>
<SQLMap name="ArcFlagIndex">
<Global>^DHCAPARCDIS</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Arc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AD_Arc_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AD_OutFlag}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AD_StartDate}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{AD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="DataMaster">
<Data name="AD_Arc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AD_Discount">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AD_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="AD_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="AD_Hospital">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="AD_OutFlag">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="AD_PartNum">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AD_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AD_StartTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="AD_UpdDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="AD_UpdTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="AD_UpdUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^DHCAPARCDIS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>{AD_RowId}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{AD_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>AD_RowId</SqlRowIdName>
<StreamLocation>^User.DHCAppArcDiscS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
