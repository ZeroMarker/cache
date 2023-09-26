Class User.DHCRBApplicationBillOrdIt Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DAO_Rowid, SqlTableName = DHCRB_ApplicationBill_OrdItem, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On DAOChildSub [ IdKey, PrimaryKey, Unique ];

/// DHCRB_ApplicationBill Parent Reference
Relationship DAOParRef As User.DHCRBApplicationBill [ Cardinality = parent, Inverse = ChildDHCRBApplicationBillOrdIt, Required, SqlFieldName = DAO_ParRef ];

/// Child subscript
Property DAOChildSub As %Library.Float [ InitialExpression = {$i(^DHCRBApp("DHCRBAPPLICATIONBILLORDITEM"))}, Required, SqlColumnNumber = 2, SqlFieldName = DAO_ChildSub ];

/// DAO_OrdItem_DR
Property DAOOrdItemDR As %String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = DAO_OrdItem_DR ];

/// DAO_Nums
Property DAONums As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = DAO_Nums ];

/// DAO_Price
Property DAOPrice As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = DAO_Price ];

/// DAO_TotalPrice
Property DAOTotalPrice As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = DAO_TotalPrice ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterMap">
<Data name="DAO_Nums">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DAO_OrdItem_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DAO_Price">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DAO_TotalPrice">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCRBAppOrd</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DHCRB_ApplicationBill.DRA_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DAO_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"OrdItem"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DHCRB_ApplicationBill.DRA_Rowid}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DAO_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexOrder">
<Global>^DHCRBAppOrdi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHCRB_ApplicationBill.DRA_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>DAO_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DAO_OrdItem_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCRB_ApplicationBill.DRA_Rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DAO_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCRBApplicationBillOrdItS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
