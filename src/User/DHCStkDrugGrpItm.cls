Class User.DHCStkDrugGrpItm Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = SDGI_RowId, SqlTableName = DHCStkDrugGrpItm, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On SDGIChildSub [ IdKey, PrimaryKey, Unique ];

/// DHCStkDrugGroup Parent Reference
Relationship SDGISDGParRef As User.DHCStkDrugGroup [ Cardinality = parent, Inverse = ChildDHCStkDrugGrpItm, Required, SqlFieldName = SDGI_SDG_ParRef ];

/// SDGI_ChildSub
Property SDGIChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = SDGI_ChildSub ];

/// SDGI_OrderCat_DR - User.ARCItemCat
Property SDGIOrderCatDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = SDGI_OrderCat_DR ];

/// SDGI_OrderCatDesc
Property SDGIOrderCatDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = SDGI_OrderCatDesc ];

/// SDGI_Type
Property SDGIType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = SDGI_Type ];

/// SDGI_WholeFlag
Property SDGIWholeFlag As %Library.String(COLLATION = "Exact", MAXLEN = 2, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = SDGI_WholeFlag ];

Index SDGIOrderCatDRUnqIdx1 On SDGIOrderCatDR;

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="SDGI_OrderCatDesc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SDGI_OrderCat_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SDGI_Type">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SDGI_WholeFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCSTDRUGGRP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHCStkDrugGroup.SDG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>SDGI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHCStkDrugGroup.SDG_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{SDGI_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexOrderCat">
<Global>^DHCSTDRUGGRP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCStkDrugGroup.SDG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>SDGI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ORDCAT"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{SDGI_OrderCat_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DHCStkDrugGroup.SDG_RowId}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{SDGI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCStkDrugGrpItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
