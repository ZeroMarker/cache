/// PIVA_BatUp  mt3604
Class User.PIVABatUp Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PBU_RowID, SqlTableName = PIVA_BatUp, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PBU_OEORI_DR
Property PBUOEORIDR As DHCOEDispensing [ SqlColumnNumber = 2, SqlFieldName = PBU_OEORI_DR ];

/// PBU_GrpNo
Property PBUGrpNo As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = PBU_GrpNo ];

/// PBU_BatNo
Property PBUBatNo As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = PBU_BatNo ];

/// PBU_SSUSR_Dr
Property PBUSSUSRDr As User.SSUser [ SqlColumnNumber = 5, SqlFieldName = PBU_SSUSR_Dr ];

/// PBU_Date
Property PBUDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = PBU_Date ];

/// PBU_Time
Property PBUTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = PBU_Time ];

/// PBU_UpdFlag
Property PBUUpdFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = PBU_UpdFlag ];

/// PBU_Remark
Property PBURemark As %String [ SqlColumnNumber = 9, SqlFieldName = PBU_Remark ];

/// PBU_Reason,不一定单选
Property PBUReason As %String [ SqlColumnNumber = 10, SqlFieldName = PBU_Reason ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^PIVABU)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PBU_BatNo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PBU_Date">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PBU_GrpNo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PBU_OEORI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PBU_Reason">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PBU_Remark">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PBU_SSUSR_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PBU_Time">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PBU_UpdFlag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^PIVABU</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PBU_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PBU_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^PIVABU</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PBU_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PBU_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PBU_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOeoriGrp">
<Global>^PIVABU</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PBU_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OEGRP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PBU_OEORI_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PBU_GrpNo}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PBU_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.PIVABatUpS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^PIVABU)
	s oldI = +$g(^mdata("PIVABATUP"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^PIVABU = maxI
	s ^mdata("PIVABATUP") = maxI
}

}
