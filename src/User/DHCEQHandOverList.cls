Class User.DHCEQHandOverList Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = HOL_RowID, SqlTableName = DHC_EQHandOverList, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// HOL_HandOverDR
Property HOLHandOverDR As User.DHCEQHandOver [ SqlColumnNumber = 2, SqlFieldName = HOL_HandOverDR ];

/// HOL_EquipDR
Property HOLEquipDR As User.DHCEQEquip [ SqlColumnNumber = 3, SqlFieldName = HOL_EquipDR ];

/// HOL_EquipLocDR
Property HOLEquipLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = HOL_EquipLocDR ];

/// HOL_LocDR
Property HOLLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = HOL_LocDR ];

Property HOLDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = HOL_Date ];

Property HOLTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = HOL_Time ];

Property HOLUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = HOL_UserDR ];

Property HOLToUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = HOL_ToUserDR ];

Property HOLDealDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 10, SqlFieldName = HOL_DealDate ];

Property HOLDealime As %Library.Time [ SqlColumnNumber = 11, SqlFieldName = HOL_DealTime ];

/// HOL_EquipStatus
Property HOLEquipStatus As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = HOL_EquipStatus ];

/// HOL_Status
Property HOLStatus As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = HOL_Status ];

/// HOL_Remark
Property HOLRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = HOL_Remark ];

/// HOL_Hold1
Property HOLHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = HOL_Hold1 ];

/// HOL_Hold2
Property HOLHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = HOL_Hold2 ];

/// HOL_Hold3
Property HOLHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = HOL_Hold3 ];

/// HOL_Hold4
Property HOLHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = HOL_Hold4 ];

/// HOL_Hold5
Property HOLHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = HOL_Hold5 ];

Property HOLInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 20, SqlFieldName = HOL_InvalidFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQHandOverList("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="HOL_Date">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="HOL_DealDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="HOL_DealTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="HOL_EquipDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="HOL_EquipLocDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="HOL_EquipStatus">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="HOL_HandOverDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="HOL_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="HOL_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="HOL_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="HOL_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="HOL_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="HOL_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="HOL_LocDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="HOL_Remark">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="HOL_Status">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="HOL_Time">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="HOL_ToUserDR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="HOL_UserDR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCEQHandOverList</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>HOL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{HOL_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DHCEQHandOverList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>HOL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{HOL_Date}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{HOL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexEquip">
<Global>^DHCEQHandOverList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>HOL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Equip"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{HOL_EquipDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{HOL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHandOver">
<Global>^DHCEQHandOverList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>HOL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"HandOver"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{HOL_HandOverDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{HOL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLoc">
<Global>^DHCEQHandOverList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>HOL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Loc"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{HOL_LocDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{HOL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQHandOverS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
