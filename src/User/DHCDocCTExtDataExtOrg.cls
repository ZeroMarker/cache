Class User.DHCDocCTExtDataExtOrg Extends %Persistent [ SqlTableName = DHC_DocCTExtDataExtOrg, StorageStrategy = SQLStorage ]
{

/// MUC_ExtCode
Property MUCExtOrgCode As %Library.String [ SqlColumnNumber = 2, SqlFieldName = MUC_ExtOrg_Code ];

/// MUC_ExtDesc
Property MUCExtOrgDesc As %Library.String [ SqlColumnNumber = 3, SqlFieldName = MUC_ExtOrg_Desc ];

/// MUC_Active
Property MUCExtOrgActive As %Library.String(DISPLAYLIST = ",Yes,NO", MAXLEN = 7, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = MUC_ExtOrg_Active ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCMUCExtOrg)</SqlIdExpression>
<SQLMap name="DataMap">
<Data name="MUC_ExtOrg_Active">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MUC_ExtOrg_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MUC_ExtOrg_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCMUCExtOrg</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MUC_ExtOrg_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{MUC_ExtOrg_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCMUCExtOrgi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>MUC_ExtOrg_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{MUC_ExtOrg_Code}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MUC_ExtOrg_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>MUC_ExtOrg_Rowid</SqlRowIdName>
<StreamLocation>^User.DHCDocCTExtDataExtOrgS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
