Class User.PHAOPRecommend Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = Rec_RowID, SqlTableName = PHAOP_Recommend, StorageStrategy = SQLStorage ]
{

/// 内容
Property RecContent As %Library.Text(MAXLEN = 500) [ SqlColumnNumber = 2, SqlFieldName = Rec_Content ];

/// 联系电话
Property RecContact As %Library.String [ SqlColumnNumber = 3, SqlFieldName = Rec_Contact ];

/// 日期
Property RecDate As %Library.Date [ SqlColumnNumber = 4, SqlFieldName = Rec_Date ];

/// 时间
Property RecTime As %Library.Time [ SqlColumnNumber = 5, SqlFieldName = Rec_Time ];

/// 人
Property RecUser As User.SSUser [ SqlColumnNumber = 6, SqlFieldName = Rec_User ];

Storage SQLStorage
{
<SqlIdExpression>$i(^BS.PHA.OP.Rec)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="Rec_Contact">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="Rec_Content">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="Rec_Date">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="Rec_Time">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="Rec_User">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^BS.PHA.OP.Rec</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>Rec_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{Rec_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.PHAOPRecommend</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^BS.PHA.OP.Rec)
	s oldI = +$g(^mdata("^BS.PHA.OP.Rec"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^BS.PHA.OP.Rec = maxI
	s ^mdata("^BS.PHA.OP.Rec") = maxI
}

}
