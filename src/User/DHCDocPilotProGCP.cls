Class User.DHCDocPilotProGCP Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PPGCP_RowId, SqlTableName = DHC_DocPilotProGCP, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// 科室
Property GCPDept As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PPGCP_Dept ];

/// 姓名
Property GCPName As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PPGCP_Name ];

/// 技术岗位
Property GCPWork As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PPGCP_Work ];

/// 培训时间
Property GCPTime As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PPGCP_Time ];

/// 学时
Property GCPHours As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = PPGCP_Hours ];

/// 培训机构
Property GCPCompany As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = PPGCP_Company ];

/// 培训级别
Property GCPLevel As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = PPGCP_Level ];

/// 培训方式
Property GCPMethod As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = PPGCP_Method ];

/// 发证日期
Property GCPDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 10, SqlFieldName = PPGCP_Date ];

/// 证书标号
Property GCPBookLabel As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = PPGCP_BookLabel ];

/// 发证日期1
Property GCPDate1 As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = PPGCP_Date1 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCDocPPGCP)</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="PPGCP_BookLabel">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PPGCP_Company">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PPGCP_Date">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PPGCP_Date1">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PPGCP_Dept">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PPGCP_Hours">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PPGCP_Level">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PPGCP_Method">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PPGCP_Name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PPGCP_Time">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PPGCP_Work">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCDocPPGCP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PPGCP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PPGCP_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCDocPilotProGCPS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
