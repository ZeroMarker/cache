/// DHC_AN_Para
Class User.DHCANPara Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ANP_RowId, SqlTableName = DHC_AN_Para, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 80000;

Relationship ChildDHCANParaItem As User.DHCANParaItem [ Cardinality = children, Inverse = ANPIParref ];

Relationship ChildDHCANParaTimeScale As User.DHCANParaTimeScale [ Cardinality = children, Inverse = ANPTParref ];

/// ANP_OPA_Dr
Property ANPOPADr As User.DHCANOPArrange [ SqlColumnNumber = 2, SqlFieldName = ANP_OPA_Dr ];

/// ANP_Interval
Property ANPCtlocDr As %Library.String [ SqlColumnNumber = 3, SqlFieldName = ANP_Ctloc_Dr ];

/// ANP_IBPFlag
Property ANPUserDr As %Library.String [ SqlColumnNumber = 4, SqlFieldName = ANP_User_Dr ];

/// ANP_Code
Property ANPCode As %Library.String [ SqlColumnNumber = 5, SqlFieldName = ANP_Code ];

/// ANP_Desc
Property ANPDesc As %Library.String [ SqlColumnNumber = 6, SqlFieldName = ANP_Desc ];

/// ANP_EditFlag
Property ANPEditFlag As %Library.String(DISPLAYLIST = ",Normal,Delete", MAXLEN = 7, SELECTIVITY = "16.6667%", TRUNCATE = 1, VALUELIST = ",N,D") [ SqlColumnNumber = 7, SqlFieldName = ANP_EditFlag ];

Storage SQLStorage
{
<ExtentSize>80000</ExtentSize>
<SqlIdExpression>$i(^DHCANPara(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ANP_Code">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ANP_Ctloc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ANP_Desc">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ANP_EditFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ANP_OPA_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ANP_User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCANPara</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ANP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{ANP_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCtloc">
<Global>^DHCANPara</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ANP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Ctloc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ANP_Ctloc_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ANP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUser">
<Global>^DHCANPara</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ANP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"User"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ANP_User_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ANP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexOpa">
<Global>^DHCANPara</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>ANP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ANP_OPA_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ANP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCANParaS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
