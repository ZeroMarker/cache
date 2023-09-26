Class User.DHCINPOItm Extends (%Library.Persistent, User.Abstract) [ SqlRowIdName = POI_RowId, SqlTableName = DHC_INPOItm, StorageStrategy = SqlStorage1 ]
{

Parameter EXTENTSIZE = 250;

Property POIINPOIDR As User.INPOItm [ SqlColumnNumber = 2, SqlFieldName = POI_INPOI_DR ];

Property POISMSSentFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 3, SqlFieldName = POI_SMS_SentFlag ];

Property POIPlatSentFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = POI_PlatSentFlag ];

Property POICanceledFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = POI_CanceledFlag ];

/// 具体规格
Property POISpecList As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = POI_SpecList ];

/// 批号
Property POIBatchNo As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = POI_BatchNo ];

/// 效期
Property POIExpDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = POI_ExpDate ];

/// 发票号
Property POIInvNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = POI_InvNo ];

/// 发票日期
Property POIInvDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 10, SqlFieldName = POI_InvDate ];

/// 发票金额
Property POIInvMoney As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = POI_InvMoney ];

/// 随行单号
Property POISxNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = POI_SxNo ];

/// 要求到达日期
Property POIDemandDate As %Date [ SqlColumnNumber = 13, SqlFieldName = POI_DemandDate ];

/// 验收数量
Property POIQty As %Float [ SqlColumnNumber = 14, SqlFieldName = POI_Qty ];

/// 厂商
Property POIPHMNFDR As User.PHManufacturer [ SqlColumnNumber = 15, SqlFieldName = POI_PHMNF_DR ];

/// 加急标记
Property POIUrgentFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 16, SqlFieldName = POI_UrgentFlag ];

Storage SqlStorage1
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCINPOI(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="POI_BatchNo">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="POI_CanceledFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="POI_DemandDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="POI_ExpDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="POI_INPOI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="POI_InvDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="POI_InvMoney">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="POI_InvNo">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="POI_PHMNF_DR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="POI_PlatSentFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="POI_Qty">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="POI_SMS_SentFlag">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="POI_SpecList">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="POI_SxNo">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="POI_UrgentFlag">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Global>^DHCINPOI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>POI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{POI_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexINPOI">
<Global>^DHCINPOI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>POI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"INPOI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{POI_INPOI_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{POI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCINPOItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
