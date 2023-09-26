Class User.DHCRBStudyImages Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DRSI_RowID, SqlTableName = DHCRB_StudyImages, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DRSI_StudyNo
Property DRSIStudyNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DRSI_StudyNo ];

/// DRSI_Height
Property DRSIHeight As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = DRSI_Height ];

/// DRSI_Width
Property DRSIWidth As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = DRSI_Width ];

/// DRSI_Size
Property DRSISize As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = DRSI_Size ];

/// DRSI_FileName
Property DRSIFileName As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = DRSI_FileName ];

/// DRSI_ExtName
Property DRSIExtName As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = DRSI_ExtName ];

/// DRSI_Medium_DR
Property DRSIMediumDR As User.DHCRBCMedium [ SqlColumnNumber = 8, SqlFieldName = DRSI_Medium_DR ];

/// DRSI_ImageDesc
Property DRSIImageDesc As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = DRSI_ImageDesc ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBStudy(0,"StudyImages"))</SqlIdExpression>
<SQLMap name="IndexFilesName">
<Global>^DHCRBStudyi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DRSI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"FileName"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DRSI_FileName}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DRSI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStudyNo">
<Global>^DHCRBStudyi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DRSI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"StudyNo-Images"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DRSI_StudyNo}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DRSI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterDataIndex">
<Data name="DRSI_ExtName">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DRSI_FileName">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DRSI_Height">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DRSI_ImageDesc">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DRSI_Medium_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DRSI_Size">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DRSI_StudyNo">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DRSI_Width">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCRBStudy</Global>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DRSI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"StudyImages"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DRSI_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBStudyImagesS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
