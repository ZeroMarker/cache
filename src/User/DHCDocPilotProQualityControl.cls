Class User.DHCDocPilotProQualityControl Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PPQC_RowId, SqlTableName = DHC_DocPilotProQualityControl, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// 检查日期
Property QCDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 2, SqlFieldName = PPQC_Date ];

/// 项目名称
Property QCProjectDr As User.DHCDocPilotProject [ SqlColumnNumber = 3, SqlFieldName = PPQC_Project_Dr ];

/// 主要研究者
Property QCUser As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PPQC_User ];

/// 存在的问题
Property QCQuestion As %Library.String(COLLATION = "Exact", MAXLEN = 5000, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PPQC_Question ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCDocPPQC)</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="PPQC_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PPQC_Project_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PPQC_Question">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PPQC_User">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCDocPPQC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PPQC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PPQC_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCDocPilot76C9S</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
