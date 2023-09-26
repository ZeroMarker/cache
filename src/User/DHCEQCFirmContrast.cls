Class User.DHCEQCFirmContrast Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = FC_RowID, SqlTableName = DHC_EQCFirmContrast, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// FC_FirmType
Property FCFirmType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = FC_FirmType ];

/// FC_FirmDR
Property FCFirmDR As User.DHCEQCVendor [ SqlColumnNumber = 3, SqlFieldName = FC_FirmDR ];

/// FC_InvalidFlag
Property FCInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = FC_InvalidFlag ];

/// FC_Hold1
Property FCHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = FC_Hold1 ];

/// FC_Hold2
Property FCHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = FC_Hold2 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCFirmContrast",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="FC_FirmDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="FC_FirmType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="FC_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="FC_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="FC_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>FC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCFirmContrast"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{FC_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexFirm">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>FC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DHCEQCFirmContrast"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"FirmDR"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{FC_FirmDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{FC_FirmType}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{FC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexFirmType">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>FC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DHCEQCFirmContrast"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"FirmType"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{FC_FirmType}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{FC_FirmDR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{FC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCFirmContrastS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
