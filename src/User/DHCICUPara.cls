/// DHC_ICU_Para
Class User.DHCICUPara Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ICUP_RowId, SqlTableName = DHC_ICU_Para, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCICUParaItem As User.DHCICUParaItem [ Cardinality = children, Inverse = ICUPIParref ];

/// ICUP_ICUA_Dr
Property ICUPICUADr As User.DHCICUArrange [ SqlColumnNumber = 2, SqlFieldName = ICUP_ICUA_Dr ];

/// ICUP_Ctloc_Dr
Property ICUPCtlocDr As %Library.String [ SqlColumnNumber = 3, SqlFieldName = ICUP_Ctloc_Dr ];

/// ICUP_IBPFlag
Property ICUPIBPFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = ICUP_IBPFlag ];

/// ICUP_ANCSH_Dr
Property ICUPANCSHDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = ICUP_ANCSH_Dr ];

/// ICUP_Type
Property ICUPType As %Library.String(DISPLAYLIST = ",Doctor,Nurse", MAXLEN = 6, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",D,N") [ SqlColumnNumber = 6, SqlFieldName = ICUP_Type ];

/// ICUP_Desc
Property ICUPDesc As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = ICUP_Desc ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCICUPara(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ICUP_ANCSH_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ICUP_Ctloc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ICUP_Desc">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ICUP_IBPFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ICUP_ICUA_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ICUP_Type">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCICUPara</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ICUP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{ICUP_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCtloc">
<Global>^DHCICUPara</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ICUP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Ctloc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ICUP_Ctloc_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ICUP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexICUArrange">
<Global>^DHCICUPara</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ICUP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ICUA"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ICUP_ICUA_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ICUP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ICUP_RowId</SqlRowIdName>
<StreamLocation>^User.DHCICUParaS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
