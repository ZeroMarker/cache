/// 配液大类
Class User.PIVAOrderLink Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = POL_Rowid, SqlTableName = PIVA_OrderLink, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildPIVAOrderLinkItm As User.PIVAOrderLinkItm [ Cardinality = children, Inverse = POLIPOLParRef ];

Relationship ChildPIVAOrderLinkOrder As User.PIVAOrderLinkOrder [ Cardinality = children, Inverse = POLOPOLParRef ];

Relationship ChildPIVAOrderLinkInstruc As User.PIVAOrderLinkInstruc [ Cardinality = children, Inverse = POLSPOLParRef ];

/// 名称
Property POLDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = POL_Desc ];

/// 最小容积量
Property POLMinVolume As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = POL_MinVolume ];

/// 最大容积量
Property POLMaxVolume As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = POL_MaxVolume ];

/// 优先级
Property POLOrdNum As %Library.String [ SqlColumnNumber = 5, SqlFieldName = POL_OrdNum ];

/// 代码\简称
Property POLCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = POL_Code ];

/// 关联收费规则(1,2,3...)->PHAPIVAS_FeeRule
Property POLFeeRules As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = POL_FeeRules ];

/// 最小年龄
Property POLMinAge As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = POL_MinAge ];

/// 最大年龄
Property POLMaxAge As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = POL_MaxAge ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^POLI)</SqlIdExpression>
<SQLMap name="DataMasterPOLI">
<Data name="POL_Code">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="POL_Desc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="POL_FeeRules">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="POL_MaxAge">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="POL_MaxVolume">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="POL_MinAge">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="POL_MinVolume">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="POL_OrdNum">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^POLI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>POL_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{POL_Rowid}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.PIVAOrderLinkS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^POLI)
	s oldI = +$g(^mdata("PIVAORDERLINK"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^POLI = maxI
	s ^mdata("PIVAORDERLINK") = maxI
}

}
