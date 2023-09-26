Class User.DHCEQAdjustDataList Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ADL_RowID, SqlTableName = DHC_EQAdjustDataList, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// ADL_AdjustDataDR
Property ADLAdjustDataDR As User.DHCEQAdjustData [ SqlColumnNumber = 2, SqlFieldName = ADL_AdjustDataDR ];

/// ADL_DepreTotal
Property ADLDepreTotal As %Library.Float [ SqlColumnNumber = 16, SqlFieldName = ADL_DepreTotal ];

/// EQStatus
Property ADLEQStatus As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = ADL_EQStatus ];

/// ADL_EquipDR
Property ADLEquipDR As User.DHCEQEquip [ SqlColumnNumber = 3, SqlFieldName = ADL_EquipDR ];

/// ADL_FromEquipTypeDR
Property ADLFromEquipTypeDR As User.DHCEQCEquipType [ SqlColumnNumber = 5, SqlFieldName = ADL_FromEquipTypeDR ];

/// ADL_FromInfo
Property ADLFromInfo As %Library.String(COLLATION = "Exact", MAXLEN = 120, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = ADL_FromInfo ];

/// ADL_FromLocDR
Property ADLFromLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = ADL_FromLocDR ];

/// ADL_FromOriginDR
Property ADLFromOriginDR As User.DHCEQCOrigin [ SqlColumnNumber = 7, SqlFieldName = ADL_FromOriginDR ];

/// ADL_FromStatCatDR
Property ADLFromStatCatDR As User.DHCEQCStatCat [ SqlColumnNumber = 6, SqlFieldName = ADL_FromStatCatDR ];

/// ADL_Hold1
Property ADLHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = ADL_Hold1 ];

/// ADL_Hold2
Property ADLHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = ADL_Hold2 ];

/// ADL_Hold3
Property ADLHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = ADL_Hold3 ];

/// ADL_Hold4
Property ADLHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = ADL_Hold4 ];

/// ADL_Hold5
Property ADLHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = ADL_Hold5 ];

/// ADL_Hold6
Property ADLHold6 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = ADL_Hold6 ];

/// ADL_NetFee
Property ADLNetFee As %Library.Float [ SqlColumnNumber = 17, SqlFieldName = ADL_NetFee ];

/// OriginalFee
Property ADLOriginalFee As %Library.Float [ SqlColumnNumber = 15, SqlFieldName = ADL_OriginalFee ];

/// ADL_ToEquipTypeDR
Property ADLToEquipTypeDR As User.DHCEQCEquipType [ SqlColumnNumber = 10, SqlFieldName = ADL_ToEquipTypeDR ];

/// ADL_ToInfo
Property ADLToInfo As %Library.String(COLLATION = "Exact", MAXLEN = 120, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = ADL_ToInfo ];

/// ADL_ToLocDR
Property ADLToLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = ADL_ToLocDR ];

/// ADL_ToOriginDR
Property ADLToOriginDR As User.DHCEQCOrigin [ SqlColumnNumber = 12, SqlFieldName = ADL_ToOriginDR ];

/// ADL_ToStatCatDR
Property ADLToStatCatDR As User.DHCEQCStatCat [ SqlColumnNumber = 11, SqlFieldName = ADL_ToStatCatDR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQAdjustDataList("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ADL_AdjustDataDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ADL_DepreTotal">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="ADL_EQStatus">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="ADL_EquipDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ADL_FromEquipTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ADL_FromInfo">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ADL_FromLocDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ADL_FromOriginDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ADL_FromStatCatDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ADL_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="ADL_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="ADL_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="ADL_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="ADL_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="ADL_Hold6">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="ADL_NetFee">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="ADL_OriginalFee">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="ADL_ToEquipTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ADL_ToInfo">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ADL_ToLocDR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ADL_ToOriginDR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ADL_ToStatCatDR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Global>^DHCEQAdjustDataList</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ADL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{ADL_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAdjustData">
<Global>^DHCEQAdjustDataList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ADL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"AdjustData"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{ADL_AdjustDataDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{ADL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexEquip">
<Global>^DHCEQAdjustDataList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ADL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Equip"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ADL_EquipDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ADL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQAdjustDataListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
