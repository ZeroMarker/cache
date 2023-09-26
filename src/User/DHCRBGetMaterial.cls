/// Get Material
Class User.DHCRBGetMaterial Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DRBGM_Rowid, SqlTableName = DHCRB_GetMaterial, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// User of the Get Material man
Property DRBGMUSSERDR As %String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = DRBGM_USSER_DR ];

/// Date of Getting Material
Property DRBGMDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = DRBGM_Date ];

/// Time of Getting Material
Property DRBGMTime As %Library.Time [ SqlColumnNumber = 4, SqlFieldName = DRBGM_Time ];

/// reference of OE_OrdItem 
Property DRBGMOeorditemDR As %String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = DRBGM_Oeorditem_DR ];

/// StudyNo
Property DRBGMStudyNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = DRBGM_StudyNo ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBMaterial)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DRBGM_Date">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DRBGM_Oeorditem_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DRBGM_StudyNo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DRBGM_Time">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DRBGM_USSER_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCRBMaterial</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DRBGM_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DRBGM_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexOeordItem">
<Global>^DHCRBMaterial</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DRBGM_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Oeorditem"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DRBGM_Oeorditem_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DRBGM_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStudyNo">
<Global>^DHCRBMaterial</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DRBGM_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"StudyNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DRBGM_StudyNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DRBGM_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUserDR">
<Global>^DHCRBMaterial</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DRBGM_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"UserDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DRBGM_USSER_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DRBGM_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCRBGetMaterialS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
