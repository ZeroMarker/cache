Class User.DHCEQUseRecordList Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = URL_RowID, SqlTableName = DHC_EQUseRecordList, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// URL_UseRecordDR
Property URLUseRecordDR As User.DHCEQUseRecordList [ SqlColumnNumber = 2, SqlFieldName = URL_UseRecordDR ];

/// URL_OEOrderID
Property URLOEOrderID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = URL_OEOrderID ];

/// URL_TariDR
Property URLTariDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = URL_TariDR ];

/// URL_TariCode
Property URLTariCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = URL_TariCode ];

/// URL_TariDesc
Property URLTariDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = URL_TariDesc ];

/// URL_TariCateDR
Property URLTariCateDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = URL_TariCateDR ];

/// URL_TariCateDesc
Property URLTariCateDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = URL_TariCateDesc ];

/// URL_Qty
Property URLQty As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = URL_Qty ];

/// URL_Price
Property URLPrice As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = URL_Price ];

/// URL_TotalFee
Property URLTotalFee As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = URL_TotalFee ];

/// URL_UOMDR
Property URLUOMDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = URL_UOMDR ];

/// URL_DrugFlag
Property URLDrugFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = URL_DrugFlag ];

/// URL_IncItmDR
Property URLIncItmDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = URL_IncItmDR ];

/// URL_Hold1
Property URLHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = URL_Hold1 ];

/// URL_Hold2
Property URLHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = URL_Hold2 ];

/// URL_Hold3
Property URLHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = URL_Hold3 ];

/// URL_Hold4
Property URLHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = URL_Hold4 ];

/// URL_Hold5
Property URLHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = URL_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQUseRecordList("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="URL_DrugFlag">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="URL_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="URL_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="URL_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="URL_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="URL_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="URL_IncItmDR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="URL_OEOrderID">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="URL_Price">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="URL_Qty">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="URL_TariCateDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="URL_TariCateDesc">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="URL_TariCode">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="URL_TariDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="URL_TariDesc">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="URL_TotalFee">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="URL_UOMDR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="URL_UseRecordDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCEQUseRecordList</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>URL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{URL_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexUseRecord">
<Global>^DHCEQUseRecordList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>URL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"UseRecord"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{URL_UseRecordDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{URL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQUseRecordListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
