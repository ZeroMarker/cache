Class User.DHCLogINCI Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DLIN_Rowid, SqlTableName = DHC_Log_INCI, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On DLINChildsub [ IdKey, PrimaryKey, Unique ];

/// DHC_Log Parent Reference   
Relationship DLINDLParref As User.DHCLog [ Cardinality = parent, Inverse = ChildDHCLogINCI, Required, SqlFieldName = DLIN_DL_Parref ];

/// DLIN_Code
Property DLINCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DLIN_Code ];

/// DLIN_Desc
Property DLINDesc As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DLIN_Desc ];

/// DLIN_CTUOM_DR :User.CTUOM
Property DLINCTUOMDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = DLIN_CTUOM_DR ];

/// DLIN_Childsub
Property DLINChildsub As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = DLIN_Childsub ];

/// DLIN_Type
Property DLINType As %Library.String(MAXLEN = 1, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",0,1,2") [ SqlColumnNumber = 7, SqlFieldName = DLIN_Type ];

/// DLIN_CTUOM_Purch_DR :User.CTUOM
Property DLINCTUOMPurchDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = DLIN_CTUOM_Purch_DR ];

/// DLIN_INCI_DR :User.INCItm
Property DLININCIDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = DLIN_INCI_DR ];

/// DLIN_ItmCat_DR :User.INCStkCat
Property DLINStkCatDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = DLIN_StkCat_DR ];

/// DLIN_Reason
Property DLINReason As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = DLIN_Reason ];

/// DLIN_Spec
Property DLINSpec As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = DLIN_Spec ];

/// DLIN_NoUseFlag
Property DLINNoUseFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = DLIN_NoUseFlag ];

/// DLIN_AuditFlag
Property DLINAuditFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 14, SqlFieldName = DLIN_AuditFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterLogInci">
<Data name="DLIN_AuditFlag">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DLIN_CTUOM_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DLIN_CTUOM_Purch_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DLIN_Code">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DLIN_Desc">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DLIN_INCI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DLIN_NoUseFlag">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DLIN_Reason">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DLIN_Spec">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DLIN_StkCat_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DLIN_Type">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCLOG</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_Log.DL_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DLIN_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_Log.DL_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"INCI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DLIN_Childsub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexInciAudit">
<Global>^DHCLOG</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHC_Log.DL_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>DLIN_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"INCIAUDIT"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DLIN_INCI_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DLIN_AuditFlag}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHC_Log.DL_Rowid}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DLIN_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexIncirowid">
<Global>^DHCLOG</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_Log.DL_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DLIN_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"INCILOG"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DLIN_INCI_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DHC_Log.DL_Rowid}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{DLIN_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCLogINCIS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
