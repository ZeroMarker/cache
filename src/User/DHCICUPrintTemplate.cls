/// DHC_ICU_PrintTemplate
Class User.DHCICUPrintTemplate Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ICUPT_RowId, SqlTableName = DHC_ICU_PrintTemplate, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCICUPrintTemplateDetails As User.DHCICUPrintTemplateDetails [ Cardinality = children, Inverse = ICUPTDICUPTId ];

/// ICUPT_Code
Property ICUPTCode As %Library.String(MAXLEN = 100) [ SqlColumnNumber = 2, SqlFieldName = ICUPT_Code ];

/// ICUPT_Desc
Property ICUPTDesc As %Library.String(MAXLEN = 100) [ SqlColumnNumber = 3, SqlFieldName = ICUPT_Desc ];

/// ICUPT_Type
Property ICUPTType As %Library.String(MAXLEN = 100) [ SqlColumnNumber = 4, SqlFieldName = ICUPT_Type ];

/// ICUPT_PageSize
Property ICUPTPageSize As %Library.String(MAXLEN = 100) [ SqlColumnNumber = 5, SqlFieldName = ICUPT_PageSize ];

/// ICUPT_Flag
Property ICUPTFlag As %Library.String(MAXLEN = 100) [ SqlColumnNumber = 6, SqlFieldName = ICUPT_Flag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCICUPrintTemplate(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ICUPT_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ICUPT_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ICUPT_Flag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ICUPT_PageSize">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ICUPT_Type">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCICUPrintTemplate</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ICUPT_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{ICUPT_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>ICUPT_RowId</SqlRowIdName>
<StreamLocation>^User.DHCICUPrintTemplateS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
