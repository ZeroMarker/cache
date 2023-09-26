Class User.DhcStkYearReport Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = StkYr_Rowid, SqlTableName = Dhc_StkYearReport, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On StkYrChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_StkYear Parent Reference
Relationship StkYrParRef As User.DHCStkYear [ Cardinality = parent, Inverse = ChildDhcStkYearReport, Required, SqlFieldName = StkYr_ParRef ];

/// StkYr_ChildSub
Property StkYrChildSub As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = StkYr_ChildSub ];

/// StkYr_Inci_Dr
Property StkYrInciDr As User.INCItm [ SqlColumnNumber = 4, SqlFieldName = StkYr_Inci_Dr ];

///  StkYr_Incil_Dr
Property StkYrIncilDr As User.INCItmLoc [ SqlColumnNumber = 5, SqlFieldName = StkYr_Incil_Dr ];

/// StkYr_PhyQty
Property StkYrPhyQty As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = StkYr_PhyQty ];

/// StkYr_PhyAmount
Property StkYrPhyAmount As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = StkYr_PhyAmount ];

/// StkYr_LastPhyQty
Property StkYrLastPhyQty As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = StkYr_LastPhyQty ];

/// StkYr_LastAmount
Property StkYrLastAmount As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = StkYr_LastAmount ];

/// StkYr_AddQty
Property StkYrAddQty As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = StkYr_AddQty ];

/// StkYr_AddAmount
Property StkYrAddAmount As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = StkYr_AddAmount ];

/// StkYr_Ssusr_Dr
Property StkYrSsusrDr As User.SSUser [ SqlColumnNumber = 12, SqlFieldName = StkYr_Ssusr_Dr ];

/// StkYr_AspAmount
Property StkYrAspAmount As %Library.Float [ SqlColumnNumber = 13, SqlFieldName = StkYr_AspAmount ];

/// StkYr_Remarks
Property StkYrRemarks As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = StkYr_Remarks ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="MasterMap">
<Data name="StkYr_AddAmount">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="StkYr_AddQty">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="StkYr_AspAmount">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="StkYr_Inci_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="StkYr_Incil_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="StkYr_LastAmount">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="StkYr_LastPhyQty">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="StkYr_PhyAmount">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="StkYr_PhyQty">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="StkYr_Remarks">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="StkYr_Ssusr_Dr">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Global>^DHCSTKYEARREP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_StkYear.DhcSy_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>StkYr_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_StkYear.DhcSy_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"YR"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{StkYr_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DhcStkYearReportS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
