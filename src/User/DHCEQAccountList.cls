Class User.DHCEQAccountList Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = AL_RowID, SqlTableName = DHC_EQAccountList, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// AL_InStockListDR
Property ALInStockListDR As User.DHCEQInStockList [ SqlColumnNumber = 2, SqlFieldName = AL_InStockListDR ];

/// AL_UserDR
Property ALUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = AL_UserDR ];

/// AL_Date
Property ALDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = AL_Date ];

/// AL_Time
Property ALTime As %Library.Time [ SqlColumnNumber = 5, SqlFieldName = AL_Time ];

/// AL_EquipTypeDR
Property ALEquipTypeDR As User.DHCEQCEquipType [ SqlColumnNumber = 6, SqlFieldName = AL_EquipTypeDR ];

/// AL_StatCatDR
Property ALStatCatDR As User.DHCEQCStatCat [ SqlColumnNumber = 7, SqlFieldName = AL_StatCatDR ];

/// AL_EquipCatDR
Property ALEquipCatDR As User.DHCEQCEquipeCat [ SqlColumnNumber = 8, SqlFieldName = AL_EquipCatDR ];

/// AL_LimitYearsNum
Property ALLimitYearsNum As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = AL_LimitYearsNum ];

/// AL_Remark
Property ALRemark As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = AL_Remark ];

/// AL_InvalidFlag
Property ALInvalidFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = AL_InvalidFlag ];

/// AL_CancelUserDR
Property ALCancelUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = AL_CancelUserDR ];

/// AL_CancelDate
Property ALCancelDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 13, SqlFieldName = AL_CancelDate ];

/// AL_CancelTime
Property ALCancelTime As %Library.Time [ SqlColumnNumber = 14, SqlFieldName = AL_CancelTime ];

/// AL_Hold1
Property ALHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = AL_Hold1 ];

/// AL_Hold2
Property ALHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = AL_Hold2 ];

/// AL_Hold3
Property ALHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = AL_Hold3 ];

/// AL_Hold4
Property ALHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = AL_Hold4 ];

/// AL_Hold5
Property ALHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = AL_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQAccountList("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="AL_CancelDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="AL_CancelTime">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="AL_CancelUserDR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="AL_Date">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AL_EquipCatDR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="AL_EquipTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="AL_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="AL_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="AL_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="AL_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="AL_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="AL_InStockListDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AL_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="AL_LimitYearsNum">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="AL_Remark">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="AL_StatCatDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="AL_Time">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AL_UserDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCEQAccountList</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{AL_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexInStockList">
<Global>^DHCEQAccountList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"InStockList"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AL_InStockListDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQAccountListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
