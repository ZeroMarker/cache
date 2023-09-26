Class User.DHCEQCGroupCTable Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = GCT_RowID, SqlTableName = DHC_EQCGroupCTable, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// GCT_GroupDR
Property GCTGroupDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = GCT_GroupDR ];

/// GCT_CodeTableDR
Property GCTCodeTableDR As User.DHCEQCCodeTable [ SqlColumnNumber = 3, SqlFieldName = GCT_CodeTableDR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCGroupCTable",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="GCT_CodeTableDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="GCT_GroupDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>GCT_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCGroupCTable"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{GCT_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCGroupCTableS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
