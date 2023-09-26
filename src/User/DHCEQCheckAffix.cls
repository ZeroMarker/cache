Class User.DHCEQCheckAffix Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = AF_RowID, SqlTableName = DHC_EQCheckAffix, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// AF_AffixCatDR
Property AFAffixCatDR As User.DHCEQCAffixCat [ SqlColumnNumber = 4, SqlFieldName = AF_AffixCatDR ];

/// AF_AffixDR
Property AFAffixDR As User.DHCEQCAffix [ SqlColumnNumber = 3, SqlFieldName = AF_AffixDR ];

/// AF_CurrencyDR
Property AFCurrencyDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = AF_CurrencyDR ];

/// AF_DisuseFlag
Property AFDisuseFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 15, SqlFieldName = AF_DisuseFlag ];

/// AF_EquipDR
Property AFEquipDR As User.DHCEQEquip [ SqlColumnNumber = 2, SqlFieldName = AF_EquipDR ];

/// AF_InvalidFlag
Property AFInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 16, SqlFieldName = AF_InvalidFlag ];

/// AF_LeaveDate
Property AFLeaveDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 11, SqlFieldName = AF_LeaveDate ];

/// AF_LeaveFacNo
Property AFLeaveFacNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = AF_LeaveFacNo ];

/// AF_ManuFactoryDR
Property AFManuFactoryDR As User.DHCEQCManufacturer [ SqlColumnNumber = 7, SqlFieldName = AF_ManuFactoryDR ];

/// AF_PartModel
Property AFPartModel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = AF_PartModel ];

/// AF_PartSpec
Property AFPartSpec As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = AF_PartSpec ];

/// AF_PriceFee
Property AFPriceFee As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = AF_PriceFee ];

/// AF_QuantityNum
Property AFQuantityNum As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = AF_QuantityNum ];

/// AF_ReceiverDR
Property AFReceiverDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = AF_ReceiverDR ];

/// AF_Remark
Property AFRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = AF_Remark ];

/// AF_UpdateDate
Property AFUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 18, SqlFieldName = AF_UpdateDate ];

/// AF_UpdateTime
Property AFUpdateTime As %Library.Time [ SqlColumnNumber = 19, SqlFieldName = AF_UpdateTime ];

/// AF_UpdateUserDR
Property AFUpdateUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = AF_UpdateUserDR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCheckAffix("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="AF_AffixCatDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AF_AffixDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AF_CurrencyDR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="AF_DisuseFlag">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="AF_EquipDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AF_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="AF_LeaveDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="AF_LeaveFacNo">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="AF_ManuFactoryDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="AF_PartModel">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="AF_PartSpec">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AF_PriceFee">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="AF_QuantityNum">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="AF_ReceiverDR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="AF_Remark">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="AF_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="AF_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="AF_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Global>^DHCEQCheckAffix</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AF_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{AF_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexEquip">
<Global>^DHCEQCheckAffix</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AF_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Equip"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AF_EquipDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AF_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCheckAffixS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
