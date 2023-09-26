Class User.DHCPHSENDMSGITM Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHSMI_Rowid, SqlTableName = DHC_PHSENDMSGITM, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PHSMIChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_PhSendMsg Parent Reference
Relationship PHSMIPHSMParref As User.DHCPhSendMsg [ Cardinality = parent, Inverse = ChildDHCPHSENDMSGITM, Required, SqlFieldName = PHSMI_PHSM_Parref ];

/// PHSMI_BarCode
Property PHSMIBarCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PHSMI_BarCode ];

/// PHSMI_OrdItm_dr
Property PHSMIOrdItmdr As User.OEOrdItem [ SqlColumnNumber = 3, SqlFieldName = PHSMI_OrdItm_dr ];

/// PHSMI_Qty
Property PHSMIQty As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = PHSMI_Qty ];

/// PHSMI_ChildSub
Property PHSMIChildSub As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = PHSMI_ChildSub ];

/// PHSMI_DISPQty
Property PHSMIDISPQty As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = PHSMI_DISPQty ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="phsmimaster">
<Data name="PHSMI_BarCode">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHSMI_DISPQty">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHSMI_OrdItm_dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHSMI_Qty">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCPHSM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PhSendMsg.PHSM_ROWID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PHSMI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_PhSendMsg.PHSM_ROWID}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHSMI_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHSENDMSGITMS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
