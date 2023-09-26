Class User.DHCOPBillHDDC Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = HDDC_Rowid, SqlTableName = DHC_OPBillHDDC, StorageStrategy = SQLStorage ]
{

Relationship HDDCChildSub As User.DHCOPBillHDDCSub [ Cardinality = children, Inverse = HDDCParref ];

Property HISDR As %Library.String [ SqlColumnNumber = 2, SqlFieldName = HIS_DR ];

Property AddDate As %Library.Date [ SqlColumnNumber = 3, SqlFieldName = Add_Date ];

Property LOCDR As %Library.String [ SqlColumnNumber = 4, SqlFieldName = LOC_DR ];

Property Place As %Library.String [ SqlColumnNumber = 5, SqlFieldName = Place ];

Property ModDate As %Library.Date [ SqlColumnNumber = 6, SqlFieldName = Mod_Date ];

Property OrderType As %Library.String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = Order_Type ];

Property ReLOCDR As %Library.String [ SqlColumnNumber = 8, SqlFieldName = ReLOC_DR ];

Property CheckFlag As %Library.String [ SqlColumnNumber = 9, SqlFieldName = Check_Flag ];

Property ORDReLOCDR As %Library.String [ SqlColumnNumber = 10, SqlFieldName = ORDReLOC_DR ];

Property HospDR As %Library.String [ SqlColumnNumber = 11, SqlFieldName = Hosp_DR ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCOPBillHDDC)</SqlIdExpression>
<SQLMap name="IndexORDReloc">
<Global>^DHCOPBillHDDC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>HDDC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ORDReloc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Order_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LOC_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ORDReLOC_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{HDDC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOrdType">
<Global>^DHCOPBillHDDC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>HDDC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TypeLoc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Order_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LOC_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{HDDC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexReloc">
<Global>^DHCOPBillHDDC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>HDDC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RELOC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LOC_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ReLOC_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{HDDC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasteHDDC">
<Data name="Add_Date">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="Check_Flag">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="HIS_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="Hosp_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="Loc_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="Mod_Date">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ORDReLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="Order_Type">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="Place">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ReLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCOPBillHDDC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>HDDC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{HDDC_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexlocdr">
<Global>^DHCOPBillHDDC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>HDDC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"LocDR"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{Loc_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{HDDC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCOPBillHDDCS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
