Class User.DHCLogArcim Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DLAR_Rowid, SqlTableName = DHC_Log_Arcim, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On DLARChildsub [ IdKey, PrimaryKey, Unique ];

/// DHC_Log Parent Reference
Relationship DLARDLParref As User.DHCLog [ Cardinality = parent, Inverse = ChildDHCLogArcim, Required, SqlFieldName = DLAR_DL_Parref ];

/// DLAR_Childsub
Property DLARChildsub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = DLAR_Childsub ];

/// DLAR_Type
Property DLARType As %Library.String(MAXLEN = 1, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",0,1,2") [ SqlColumnNumber = 3, SqlFieldName = DLAR_Type ];

/// DLAR_PHCD_DR : User.ARCItmMast
Property DLARARCIMDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = DLAR_ARCIM_DR ];

/// DLAR_Code
Property DLARCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = DLAR_Code ];

/// DLAR_Desc
Property DLARDesc As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = DLAR_Desc ];

/// DLAR_Effdate
Property DLAREffdate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = DLAR_Effdate ];

/// DLAR_EffDateto
Property DLAREffDateto As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = DLAR_EffDateto ];

/// DLAR_Cat : User.ARCItemCat
Property DLARItemCat As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = DLAR_ItemCat ];

/// DLAR_BillCat :User.ARCBillSub
Property DLARBillSubCat As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = DLAR_BillSubCat ];

/// DLAR_BillingUom :User.CTUOM
Property DLARBillingUom As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = DLAR_BillingUom ];

/// DLAR_OrdPriority :User.OECPriority
Property DLAROrdPriority As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = DLAR_OrdPriority ];

/// DLAR_OrderOnItsOwn
Property DLAROrderOnItsOwn As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = DLAR_OrderOnItsOwn ];

/// DLAR_OEMsg
Property DLAROEMsg As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = DLAR_OEMsg ];

/// DLAR_Reason
Property DLARReason As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = DLAR_Reason ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="DLAR_ARCIM_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DLAR_BillSubCat">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DLAR_BillingUom">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DLAR_Code">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DLAR_Desc">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DLAR_EffDateto">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DLAR_Effdate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DLAR_ItemCat">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DLAR_OEMsg">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DLAR_OrdPriority">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DLAR_OrderOnItsOwn">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DLAR_Reason">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DLAR_Type">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCLOG</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_Log.DL_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DLAR_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_Log.DL_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ARCIM"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DLAR_Childsub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexArcim">
<Global>^DHCLOG</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_Log.DL_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DLAR_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ARCIMLOG"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DLAR_ARCIM_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DHC_Log.DL_Rowid}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{DLAR_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCLogArcimS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
