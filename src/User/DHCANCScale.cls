/// DHC_ANC_Scale
Class User.DHCANCScale Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ANCS_RowId, SqlTableName = DHC_ANC_Scale, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// ANCS_Code
Property ANCSCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = ANCS_Code ];

/// ANCS_Desc
Property ANCSDesc As %Library.String(COLLATION = "Exact", MAXLEN = 80, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ANCS_Desc ];

/// ANCS_MinVal
Property ANCSMinVal As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = ANCS_MinVal ];

/// ANCS_MaxVal
Property ANCSMaxVal As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = ANCS_MaxVal ];

/// ANCS_Ratio
Property ANCSRatio As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = ANCS_Ratio ];

/// ANCS_Uom_Dr
Property ANCSUomDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = ANCS_Uom_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCANC("Scale",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ANCS_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ANCS_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ANCS_MaxVal">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ANCS_MinVal">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ANCS_Ratio">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ANCS_Uom_Dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCANC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ANCS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Scale"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ANCS_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCANCScaleS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
