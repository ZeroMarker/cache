Class User.DHCWMRFPTemplate Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = RowId, SqlTableName = DHC_WMR_FPTemplate, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// Code
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

/// Description
Property Description As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

/// MRTypeDr
Property MRTypeDr As User.DHCWMRDictionary [ SqlColumnNumber = 4 ];

/// IsActive
Property IsActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5 ];

/// ResumeText
Property ResumeText As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 6 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCWMRFPT)</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="Description">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="IsActive">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MRTypeDr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ResumeText">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCWMRFPT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexMrTypeDr">
<Global>^DHCWMRFPT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"MrTypeDr"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MRTypeDr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCWMRFPTemplateS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
