Class User.DHCMatDisp Extends (%Persistent, User.Abstract) [ SqlRowIdName = DISP_RowId, SqlTableName = DHC_MatDisp, StorageStrategy = SqlStorage ]
{

Relationship ChildDHCMatDispItm As User.DHCMatDispItm [ Cardinality = children, Inverse = DSIParRef ];

Property DISPNo As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DISP_No ];

Property DISPDate As %Library.Date [ SqlColumnNumber = 3, SqlFieldName = DISP_Date ];

Property DISPTime As %Library.Time [ SqlColumnNumber = 4, SqlFieldName = DISP_Time ];

Property DISPSSUSRDR As User.SSUser [ SqlColumnNumber = 5, SqlFieldName = DISP_SSUSR_DR ];

Property DISPCTLOCDR As User.CTLoc [ SqlColumnNumber = 6, SqlFieldName = DISP_CTLOC_DR ];

Property DISPPatDR As User.PAPatMas [ SqlColumnNumber = 7, SqlFieldName = DISP_Pat_DR ];

Property DISPAdmLocDR As User.CTLoc [ SqlColumnNumber = 8, SqlFieldName = DISP_AdmLoc_DR ];

Property DISPPrescNo As %String [ SqlColumnNumber = 9, SqlFieldName = DISP_PrescNo ];

Storage SqlStorage
{
<SqlIdExpression>$i(^DHCMATDISP(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DISP_AdmLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DISP_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DISP_Date">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DISP_No">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DISP_Pat_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DISP_PrescNo">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DISP_SSUSR_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DISP_Time">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCMATDISP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DISP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DISP_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexDateLoc">
<Global>^DHCMATDISP</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DateLoc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DISP_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DISP_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DISP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexPrescNo">
<Global>^DHCMATDISP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DISP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PRESCNO"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DISP_PrescNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DISP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DISP_RowId</SqlRowIdName>
<StreamLocation>^User.DHCMatDispS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
