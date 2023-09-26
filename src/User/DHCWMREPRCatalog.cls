Class User.DHCWMREPRCatalog Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = WEC_Rowid, SqlTableName = DHC_WMR_EPRCatalog, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// WEC_CatalogID
Property WECCatalogID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = WEC_CatalogID ];

/// WEC_CatalogSub
Property WECCatalogSub As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = WEC_CatalogSub ];

/// WEC_NormName
Property WECNormName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = WEC_NormName ];

/// WEC_IsActive
Property WECIsActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = WEC_IsActive ];

/// WEC_Resume
Property WECResume As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = WEC_Resume ];

/// WEC_Text1
Property WECText1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = WEC_Text1 ];

/// WEC_Text2
Property WECText2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = WEC_Text2 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCWMREPRCAT(0))</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="WEC_CatalogID">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="WEC_CatalogSub">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="WEC_IsActive">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="WEC_NormName">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="WEC_Resume">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="WEC_Text1">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="WEC_Text2">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCWMREPRCAT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>WEC_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{WEC_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCatSub">
<Global>^DHCWMREPRCAT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>WEC_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"CatSub"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{WEC_CatalogID}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{WEC_CatalogSub}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{WEC_IsActive}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{WEC_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexNormName">
<Global>^DHCWMREPRCAT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WEC_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"NormName"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{WEC_NormName}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{WEC_IsActive}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{WEC_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCWMREPRCatalogS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
