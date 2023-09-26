Class User.DHCPhaReserveDetail Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PRDET_Rowid, SqlTableName = DHC_PhaReserveDetail, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PRDETChildsub [ IdKey, PrimaryKey, Unique ];

/// DHC_PhaReserve Parent Reference
Relationship PRDETPRESParref As User.DHCPhaReserve [ Cardinality = parent, Inverse = ChildDHCPhaReserveDetail, Required, SqlFieldName = PRDET_PRES_Parref ];

//

Relationship ChildDHCPhaReserveDetailSub As User.DHCPhaReserveDetailSub [ Cardinality = children, Inverse = PRDETSPRDETParref ];

/// PRDET_Childsub
Property PRDETChildsub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = PRDET_Childsub ];

/// PRDET_Type
Property PRDETType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PRDET_Type ];

/// PRDET_Qty
Property PRDETQty As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = PRDET_Qty ];

/// PRDET_Pointer
Property PRDETPointer As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PRDET_Pointer ];

/// PRDET_AvailQty
Property PRDETAvailQty As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = PRDET_AvailQty ];

/// PRDET_Date
Property PRDETDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = PRDET_Date ];

/// PRDET_OperUser_Dr
Property PRDETOperUserDr As User.SSUser [ SqlColumnNumber = 8, SqlFieldName = PRDET_OperUser_Dr ];

/// PRDET_Time
Property PRDETTime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = PRDET_Time ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="PRDET_AvailQty">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PRDET_Date">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PRDET_OperUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PRDET_Pointer">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PRDET_Qty">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PRDET_Time">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PRDET_Type">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCPRES</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PhaReserve.PRES_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PRDET_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_PhaReserve.PRES_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"DET"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PRDET_Childsub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DHCPRES</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHC_PhaReserve.PRES_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PRDET_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DHC_PhaReserve.PRES_Rowid}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PRDET_Date}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{PRDET_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypePointer">
<Global>^DHCPRES</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHC_PhaReserve.PRES_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>PRDET_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TypePointer"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PRDET_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PRDET_Pointer}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHC_PhaReserve.PRES_Rowid}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PRDET_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPhaReserveDetailS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
