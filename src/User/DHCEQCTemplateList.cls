Class User.DHCEQCTemplateList Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = TL_RowID, SqlTableName = DHC_EQCTemplateList, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// TL_TemplateDR
Property TLTemplateDR As User.DHCEQCTemplate [ SqlColumnNumber = 2, SqlFieldName = TL_TemplateDR ];

/// TL_ElementDR
Property TLElementDR As User.DHCEQCElement [ SqlColumnNumber = 3, SqlFieldName = TL_ElementDR ];

/// TL_SettingValue
Property TLSettingValue As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = TL_SettingValue ];

/// TL_Key
Property TLKey As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = TL_Key ];

/// TL_Note
Property TLNote As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = TL_Note ];

/// TL_Sort
Property TLSort As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = TL_Sort ];

/// TL_Repeat
Property TLRepeat As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = TL_Repeat ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCTemplateList",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="TL_ElementDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="TL_Key">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="TL_Note">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="TL_Repeat">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="TL_SettingValue">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="TL_Sort">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="TL_TemplateDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>TL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"DHCEQCTemplateList"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>{TL_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexElementDR">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>TL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DHCEQCTemplateList"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ElementDR"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TL_ElementDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{TL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexTemplateDR">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>TL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DHCEQCTemplateList"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"TemplateDR"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TL_TemplateDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>" "_{TL_Sort}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{TL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCTemplateListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
