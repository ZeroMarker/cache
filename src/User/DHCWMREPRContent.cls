Class User.DHCWMREPRContent Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = WECT_Rowid, SqlTableName = DHC_WMR_EPRContent, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// WECT_TemplateID
Property WECTTemplateID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = WECT_TemplateID ];

/// WECT_EPRContent
Property WECTEPRContent As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = WECT_EPRContent ];

/// WECT_IsActive
Property WECTIsActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = WECT_IsActive ];

/// WECT_Resume
Property WECTResume As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = WECT_Resume ];

/// WECT_Text1
Property WECTText1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = WECT_Text1 ];

/// WECT_Text2
Property WECTText2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = WECT_Text2 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCWMREPRCT(0))</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="WECT_EPRContent">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="WECT_IsActive">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="WECT_Resume">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="WECT_TemplateID">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="WECT_Text1">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="WECT_Text2">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCWMREPRCT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>WECT_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{WECT_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexEPRContent">
<Global>^DHCWMREPRCT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WECT_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"EPRContent"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{WECT_EPRContent}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{WECT_IsActive}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{WECT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTemplateID">
<Global>^DHCWMREPRCT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WECT_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"TemplateID"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{WECT_TemplateID}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{WECT_IsActive}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{WECT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCWMREPRContentS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
