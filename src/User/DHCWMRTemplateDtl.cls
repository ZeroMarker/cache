Class User.DHCWMRTemplateDtl Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = RowId, SqlTableName = DHC_WMR_TemplateDtl, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// TempId
Property TempId As User.DHCWMRFPTemplate [ SqlColumnNumber = 2 ];

/// ItemId
Property ItemId As User.DHCWMRFPItemDic [ SqlColumnNumber = 3 ];

/// Pos
Property Pos As %Library.Float [ SqlColumnNumber = 4 ];

/// DefaultValue
Property DefaultValue As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5 ];

/// ToolTip
Property ToolTip As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6 ];

/// ResumeText
Property ResumeText As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 7 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCWMRFPTD)</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="DefaultValue">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ItemId">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="Pos">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ResumeText">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="TempId">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ToolTip">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCWMRFPTD</Global>
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
<SQLMap name="IndexTempId">
<Global>^DHCWMRFPTD</Global>
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
<Expression>"TempId"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{TempId}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCWMRTemplateDtlS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
