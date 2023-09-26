Class User.DHCEQMCMaintItemFactor Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MIF_RowID, SqlTableName = DHC_EQMCMaintItemFactor, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// MIF_NormalValuesDR
Property MIFNormalValuesDR As User.DHCEQCPMTemplate [ SqlColumnNumber = 2, SqlFieldName = MIF_NormalValuesDR ];

/// MIF_FactorDR
Property MIFFactorDR As User.DHCEQMCFactor [ SqlColumnNumber = 3, SqlFieldName = MIF_FactorDR ];

/// MIF_FactorValue
Property MIFFactorValue As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = MIF_FactorValue ];

/// MIF_Unit
Property MIFUnit As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = MIF_Unit ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQMCMaintItemFactor",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MIF_FactorDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MIF_FactorValue">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MIF_NormalValuesDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MIF_Unit">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>MIF_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DHCEQMCMaintItemFactor"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>{MIF_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexFactorDR">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MIF_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DHCEQMCMaintItemFactor"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"FactorDR"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MIF_FactorDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MIF_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexNormalValuesDR">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MIF_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DHCEQMCMaintItemFactor"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>"NormalValuesDR"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MIF_NormalValuesDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MIF_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQMCMaintItemFactorS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
