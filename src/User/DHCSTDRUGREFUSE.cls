/// d ##Class(User.DHCSTDRUGREFUSE).%BuildIndices()
Class User.DHCSTDRUGREFUSE Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = STDF_ROWID, SqlTableName = DHC_STDRUGREFUSE, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// STDF_OEDI_DR
Property STDFOEDIDR As User.OEOrdItem [ SqlColumnNumber = 2, SqlFieldName = STDF_OEDI_DR ];

/// STDF_USER_DR
Property STDFUSERDR As User.SSUser [ SqlColumnNumber = 3, SqlFieldName = STDF_USER_DR ];

/// STDF_DATE
Property STDFDATE As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = STDF_DATE ];

/// STDF_TIME
Property STDFTIME As %Library.Time [ SqlColumnNumber = 5, SqlFieldName = STDF_TIME ];

/// STDF_PRESCNO	//此字段修改为保存处方号！hulihua 2017-11-27 新疆中医
Property STDFPRESCNO As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = STDF_PRESCNO ];

/// STDF_LOC_DR
Property STDFLOCDR As User.CTLoc [ SqlColumnNumber = 7, SqlFieldName = STDF_LOC_DR ];

/// STDF_RefReason_DR
Property STDFRefReasonDR As User.DHCSTRefuseReason [ SqlColumnNumber = 8, SqlFieldName = STDF_RefReason_DR ];

/// STDF_DODIS_DR,zdm,2012-02-23
Property STDFDODISDR As User.DHCOEDispensing [ SqlColumnNumber = 9, SqlFieldName = STDF_DODIS_DR ];

/// STDF_Remark	
Property STDFRemark As %Library.String [ SqlColumnNumber = 10, SqlFieldName = STDF_Remark ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^STDF(0))</SqlIdExpression>
<SQLMap name="DATAMASTER">
<Data name="STDF_DATE">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="STDF_DODIS_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="STDF_LOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="STDF_OEDI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="STDF_PRESCNO">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="STDF_RefReason_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="STDF_Remark">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="STDF_TIME">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="STDF_USER_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^STDF</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>STDF_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{STDF_ROWID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="INDEXDATE">
<Global>^STDF</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>STDF_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DATE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{STDF_DATE}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{STDF_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="INDEXDODIS">
<Global>^STDF</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"DODIS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{STDF_DODIS_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{STDF_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="INDEXLOC">
<Global>^STDF</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>STDF_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"LOC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{STDF_LOC_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{STDF_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="INDEXOEDI">
<Global>^STDF</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>STDF_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"OEDI"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{STDF_OEDI_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{STDF_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOrdItm">
<Global>^STDF</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>STDF_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ORDITM"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>$p({STDF_OEDI_DR},"||",1,2)</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{STDF_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPrescNo">
<Global>^STDFi</Global>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>STDF_ROWID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"PRESCNO"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{STDF_PRESCNO}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{STDF_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCSTDRUGREFUSES</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
