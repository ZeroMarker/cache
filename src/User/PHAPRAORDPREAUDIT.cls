/// 医嘱预审核日志表
Class User.PHAPRAORDPREAUDIT Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PRAOPA_RowID, SqlTableName = PHAPRA_ORDPREAUDIT, StorageStrategy = SQLStorage ]
{

/// PRAOPA_OrdDate  下医嘱日期
Property PRAOPAOrdDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 2, SqlFieldName = PRAOPA_OrdDate ];

/// PRAOPA_OrdTime  下医嘱时间
Property PRAOPAOrdTime As %Library.Time [ SqlColumnNumber = 3, SqlFieldName = PRAOPA_OrdTime ];

/// PRAOPA_OrdItem_Dr 医嘱明细id
Property PRAOPAOrdItemDr As User.OEOrdItem [ SqlColumnNumber = 4, SqlFieldName = PRAOPA_OrdItem_Dr ];

/// PRAOPA_RecLoc_Dr  接收科室
Property PRAOPARecLocDr As User.CTLoc [ SqlColumnNumber = 5, SqlFieldName = PRAOPA_RecLoc_Dr ];

/// PRAOPA_Date  预审核日期
Property PRAOPADate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = PRAOPA_Date ];

/// PRAOPA_Time  预审核时间
Property PRAOPATime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = PRAOPA_Time ];

/// PRAOPA_Result  结果(合格、不合格)
Property PRAOPAResult As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = PRAOPA_Result ];

/// PRAOPA_RetVal  预审返回值
Property PRAOPARetVal As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = PRAOPA_RetVal ];

/// PRAOPA_Reason  审核不通过原因
Property PRAOPAReason As %Library.String [ SqlColumnNumber = 10, SqlFieldName = PRAOPA_Reason ];

/// PRAOPA_Remark  备注信息
Property PRAOPARemark As %Library.String [ SqlColumnNumber = 11, SqlFieldName = PRAOPA_Remark ];

Storage SQLStorage
{
<SqlIdExpression>$i(^BS.PHA.PRA.ORDAUDIT(0))</SqlIdExpression>
<SQLMap name="IndexAdm">
<Global>^BS.PHA.PRA.ORDAUDITi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PRAOPA_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Adm"</Expression>
</Subscript>
<Subscript name="2">
<Expression>$p($g(^OEORD(+{PRAOPA_OrdItem_Dr})),"^",1)</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PRAOPA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateResult">
<Global>^BS.PHA.PRA.ORDAUDITi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PRAOPA_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DateResult"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PRAOPA_Date}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PRAOPA_RecLoc_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PRAOPA_Result}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PRAOPA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOrdDateResult">
<Global>^BS.PHA.PRA.ORDAUDITi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PRAOPA_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"OrdResult"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PRAOPA_OrdDate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PRAOPA_RecLoc_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PRAOPA_Result}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PRAOPA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOrder">
<Global>^BS.PHA.PRA.ORDAUDITi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PRAOPA_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"OrdItem"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PRAOPA_OrdItem_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PRAOPA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPapmi">
<Global>^BS.PHA.PRA.ORDAUDITi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PRAOPA_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Papmi"</Expression>
</Subscript>
<Subscript name="2">
<Expression>$p($g(^PAADM(+$p($g(^OEORD(+{PRAOPA_OrdItem_Dr})),"^",1))),"^",1)</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PRAOPA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPrescNo">
<Global>^BS.PHA.PRA.ORDAUDITi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PRAOPA_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"PrescNo"</Expression>
</Subscript>
<Subscript name="2">
<Expression>$p($g(^OEORD(+{PRAOPA_OrdItem_Dr},"I",+$p({PRAOPA_OrdItem_Dr},"||",2),1)),"^",14)</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PRAOPA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="PRAOPA_Date">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PRAOPA_OrdDate">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PRAOPA_OrdItem_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PRAOPA_OrdTime">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PRAOPA_Reason">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PRAOPA_RecLoc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PRAOPA_Remark">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PRAOPA_Result">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PRAOPA_RetVal">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PRAOPA_Time">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^BS.PHA.PRA.ORDAUDIT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>{PRAOPA_RowID}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PRAOPA_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PRAOPA_RowID</SqlRowIdName>
<StreamLocation>^User.PHAPRAORDPREAUDITS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
