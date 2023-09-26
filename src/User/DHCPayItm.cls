Class User.DHCPayItm Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PAYI_Rowid, SqlTableName = DHC_PayItm, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PAYIChildsub [ IdKey, PrimaryKey, Unique ];

/// DHC_Pay Parent Reference
Relationship PAYIPAYParref As User.DHCPay [ Cardinality = parent, Inverse = ChildDHCPayItm, Required, SqlFieldName = PAYI_PAY_Parref ];

/// PAYI_Childsub
Property PAYIChildsub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = PAYI_Childsub ];

/// PAYI_INGRI_DR
Property PAYIINGRIDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PAYI_INGRI_DR ];

/// PAYI_INCI_DR : User.INCItm
Property PAYIINCIDR As User.INCItm [ SqlColumnNumber = 4, SqlFieldName = PAYI_INCI_DR ];

/// PAYI_RecAmt
Property PAYIRecAmt As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = PAYI_RecAmt ];

/// PAYI_PayedAmt
Property PAYIPayedAmt As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = PAYI_PayedAmt ];

/// PAYI_DiscRate
Property PAYIDiscRate As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = PAYI_DiscRate ];

/// PAYI_PayAmt
Property PAYIPayAmt As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = PAYI_PayAmt ];

/// PAYI_OverFlag
Property PAYIOverFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = PAYI_OverFlag ];

/// PAYI_Remarks
Property PAYIRemarks As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = PAYI_Remarks ];

/// PAYI_RecType
Property PAYIRecType As %Library.String(DISPLAYLIST = ",Receive,Return", MAXLEN = 7, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",G,R") [ SqlColumnNumber = 11, SqlFieldName = PAYI_RecType ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterMap">
<Data name="PAYI_DiscRate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PAYI_INCI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PAYI_INGRI_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PAYI_OverFlag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PAYI_PayAmt">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PAYI_PayedAmt">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PAYI_RecAmt">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PAYI_RecType">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PAYI_Remarks">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^DHCPAY</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_Pay.PAY_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PAYI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_Pay.PAY_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PAYI_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexINCI">
<Global>^DHCPAY</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_Pay.PAY_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PAYI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"INCI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PAYI_INCI_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DHC_Pay.PAY_Rowid}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{PAYI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexINGRI">
<Global>^DHCPAY</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_Pay.PAY_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PAYI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"GRI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{PAYI_INGRI_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DHC_Pay.PAY_Rowid}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{PAYI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypeIngri">
<Global>^DHCPAY</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHC_Pay.PAY_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>PAYI_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TYPEGR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PAYI_RecType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PAYI_INGRI_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PAYI_PAY_Parref}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PAYI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPayItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
