Class User.DHCEQCPMTemplateList Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PMTL_RowID, SqlTableName = DHC_EQCPMTemplateList, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PMTL_TemplateDR
Property PMTLTemplateDR As User.DHCEQCPMTemplate [ SqlColumnNumber = 2, SqlFieldName = PMTL_TemplateDR ];

/// PMTL_MaintItemDR
Property PMTLMaintItemDR As User.DHCEQCMaintItem [ SqlColumnNumber = 3, SqlFieldName = PMTL_MaintItemDR ];

/// PMTL_Note
Property PMTLNote As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PMTL_Note ];

/// PMTL_Sort
Property PMTLSort As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PMTL_Sort ];

/// PMTL_DefaultVal
Property PMTLDefaultVal As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = PMTL_DefaultVal ];

/// PMTL_ItemFactorKey
Property PMTLItemFactorKey As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = PMTL_ItemFactorKey ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCPMTemplateList",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PMTL_DefaultVal">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PMTL_ItemFactorKey">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PMTL_MaintItemDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PMTL_Note">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PMTL_Sort">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PMTL_TemplateDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PMTL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DHCEQCPMTemplateList"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>{PMTL_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexMaintItemDR">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PMTL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DHCEQCPMTemplateList"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>"PMTLMaintItemDR"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PMTL_MaintItemDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PMTL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTemplateDR">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>PMTL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DHCEQCPMTemplateList"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"PMTLTemplateDR"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PMTL_TemplateDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PMTL_Sort}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PMTL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCPMTemplateListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
