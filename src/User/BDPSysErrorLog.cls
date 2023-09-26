/// Function: 错误日志 定义
/// Creator: sunfengchao
/// CreateDate:2016-6-22
Class User.BDPSysErrorLog Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = BDPER_RowId, SqlTableName = BDP_SysErrorLog, StorageStrategy = SQLStorage ]
{

/// 出错日期
Property BDPERDate As %Date [ SqlColumnNumber = 2, SqlFieldName = BDPER_Date ];

/// 出错时间
Property BDPERTime As %Time [ SqlColumnNumber = 3, SqlFieldName = BDPER_Time ];

/// 出错模块 (菜单名称)  
Property BDPERApp As %String [ SqlColumnNumber = 4, SqlFieldName = BDPER_App ];

/// 发生错误的业务类
Property BDPERClassInfo As %String [ SqlColumnNumber = 5, SqlFieldName = BDPER_ClassInfo ];

/// 出现错误的代码块 (哪个类方法) 
Property BDPERModule As %String [ SqlColumnNumber = 6, SqlFieldName = BDPER_Module ];

/// 出错信息
Property BDPERErrInfo As %String [ SqlColumnNumber = 7, SqlFieldName = BDPER_ErrInfo ];

/// 原先的数据value  删除添加时为原数据,修改时为新数据
Property BDPERKeyValue As %String(MAXLEN = "") [ SqlColumnNumber = 8, SqlFieldName = BDPER_KeyValue ];

/// IP 地址
Property BDPERIPAddress As %String [ SqlColumnNumber = 9, SqlFieldName = BDPER_IPAddress ];

/// 操作用户
Property BDPERSSUSRDR As User.SSUser [ SqlColumnNumber = 10, SqlFieldName = BDPER_SSUSR_DR ];

/// 浏览器版本
Property BDPERBrowserInfo As %String [ SqlColumnNumber = 11, SqlFieldName = BDPER_BrowserInfo ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^BDPERROR(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="BDPER_App">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="BDPER_BrowserInfo">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="BDPER_ClassInfo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="BDPER_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="BDPER_ErrInfo">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="BDPER_IPAddress">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="BDPER_KeyValue">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="BDPER_Module">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="BDPER_SSUSR_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="BDPER_Time">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^BDPERROR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>BDPER_RowI</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{BDPER_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^BDPERROR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>BDPER_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{BDPER_Date}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{BDPER_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>BDPER_RowId</SqlRowIdName>
<StreamLocation>^User.BDPSysErrorLogS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
