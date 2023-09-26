Class User.DHCEQIFBBag Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = IFBB_RowID, SqlTableName = DHC_EQIFBBag, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// IFBB_Arg
Property IFBBArg As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = IFBB_Arg ];

/// IFBB_BagNo
Property IFBBBagNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = IFBB_BagNo ];

/// IFBB_ExtendID
Property IFBBExtendID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = IFBB_ExtendID ];

/// IFBB_ExtendType
Property IFBBExtendType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = IFBB_ExtendType ];

/// IFBB_Hold1
Property IFBBHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = IFBB_Hold1 ];

/// IFBB_Hold2
Property IFBBHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = IFBB_Hold2 ];

/// IFBB_Hold3
Property IFBBHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = IFBB_Hold3 ];

/// IFBB_Hold4
Property IFBBHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = IFBB_Hold4 ];

/// IFBB_Hold5
Property IFBBHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = IFBB_Hold5 ];

/// IFBB_IFBDR
Property IFBBIFBDR As User.DHCEQIFB [ SqlColumnNumber = 2, SqlFieldName = IFBB_IFBDR ];

/// IFBB_ItemDR
Property IFBBItemDR As User.DHCEQCMasterItem [ SqlColumnNumber = 4, SqlFieldName = IFBB_ItemDR ];

/// IFBB_ManuFactoryDR
Property IFBBManuFactoryDR As User.DHCEQCVendor [ SqlColumnNumber = 7, SqlFieldName = IFBB_ManuFactoryDR ];

/// IFBB_ModelDR
Property IFBBModelDR As User.DHCEQCModel [ SqlColumnNumber = 8, SqlFieldName = IFBB_ModelDR ];

/// IFBB_Quantity
Property IFBBQuantity As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = IFBB_Quantity ];

/// IFBB_Remark
Property IFBBRemark As %Library.String(COLLATION = "Exact", MAXLEN = 160, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = IFBB_Remark ];

/// IFBB_UnitDR
Property IFBBUnitDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = IFBB_UnitDR ];

/// IFBB_WinPrice
Property IFBBWinPrice As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = IFBB_WinPrice ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQIFBBag("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="IFBB_Arg">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="IFBB_BagNo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="IFBB_ExtendID">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="IFBB_ExtendType">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="IFBB_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="IFBB_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="IFBB_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="IFBB_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="IFBB_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="IFBB_IFBDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="IFBB_ItemDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="IFBB_ManuFactoryDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="IFBB_ModelDR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="IFBB_Quantity">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="IFBB_Remark">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="IFBB_UnitDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="IFBB_WinPrice">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Global>^DHCEQIFBBag</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>IFBB_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{IFBB_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexExtend">
<Global>^DHCEQIFBBag</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>IFBB_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Extend"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{IFBB_ExtendType}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{IFBB_ExtendID}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{IFBB_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexIFB">
<Global>^DHCEQIFBBag</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>IFBB_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"IFB"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{IFBB_IFBDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{IFBB_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexItem">
<Global>^DHCEQIFBBag</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>IFBB_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Item"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{IFBB_ItemDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{IFBB_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQIFBBagS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
