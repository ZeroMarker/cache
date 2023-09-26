Class User.DHCWMREPRTemplate Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = WET_Rowid, SqlTableName = DHC_WMR_EPRTemplate, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// WER_TemplateID
Property WETTemplateID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = WET_TemplateID ];

/// WET_ElementID
Property WETElementID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = WET_ElementID ];

/// WET_NormName
Property WETNormName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = WET_NormName ];

/// WET_IsNull
Property WETIsNull As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = WET_IsNull ];

/// WET_TrueContent
Property WETTrueContent As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = WET_TrueContent ];

/// WET_FalseContent
Property WETFalseContent As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = WET_FalseContent ];

/// WET_IsActive
Property WETIsActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = WET_IsActive ];

/// WET_Resume
Property WETResume As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = WET_Resume ];

/// WET_Text1
Property WETText1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = WET_Text1 ];

/// WET_Text2
Property WETText2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = WET_Text2 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCWMREPRTEM(0))</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="WET_ElementID">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="WET_FalseContent">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="WET_IsActive">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="WET_IsNull">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="WET_NormName">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="WET_Resume">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="WET_TemplateID">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="WET_Text1">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="WET_Text2">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="WET_TrueContent">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCWMREPRTEM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>WET_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{WET_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexElement">
<Global>^DHCWMREPRTEM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WET_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Element"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{WET_TemplateID}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{WET_ElementID}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{WET_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTempName">
<Global>^DHCWMREPRTEM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>WET_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"TempName"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{WET_TemplateID}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{WET_NormName}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{WET_IsActive}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{WET_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCWMREPRTemplateS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
