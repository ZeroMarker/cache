/// 描述: 收费员借入、借出金额表设计
/// 编写者: Suhuide
/// 编写日期: 2017-07-03
Class User.DHCBillCapitalFlow Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = Cap_RowId, SqlTableName = DHC_BillCapitalFlow, StorageStrategy = SQLStorage ]
{

/// Cap_Acount 转交金额
Property CapAcount As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = Cap_Acount ];

/// Cap_Date 转交日期
Property CapDate As %Library.Date(FORMAT = 1) [ InitialExpression = {+$h}, SqlColumnNumber = 3, SqlFieldName = Cap_Date ];

/// Cap_Time 转交时间
Property CapTime As %Library.Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 4, SqlFieldName = Cap_Time ];

/// Cap_Usr_DR 操作员
Property CapUsrDR As User.SSUser [ SqlColumnNumber = 5, SqlFieldName = Cap_Usr_DR ];

/// Cap_Flag 转入或转出 IN 转入 OUT 转出
Property CapFlag As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = Cap_Flag ];

/// Cap_ObjUsrDR 操作用户对象
Property CapObjUsrDR As User.SSUser [ SqlColumnNumber = 7, SqlFieldName = Cap_ObjUsr_DR ];

/// Cap_PayMode_DR 支付方式
Property CapPayModeDR As User.CTPayMode [ SqlColumnNumber = 8, SqlFieldName = Cap_PayMode_DR ];

/// Cap_InitCap_DR
Property CapInitCapDR As User.DHCBillCapitalFlow [ SqlColumnNumber = 9, SqlFieldName = Cap_InitCap_DR ];

/// Cap_Reports_DR 结账DR
Property CapReportsDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = Cap_Reports_DR ];

/// Cap_Handin
Property CapHandin As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 11, SqlFieldName = Cap_Handin ];

/// Cap_Type 类别 OP 门诊 IP 住院
Property CapType As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = Cap_Type ];

/// Cap_HospId 院区
Property CapHospId As User.CTHospital [ SqlColumnNumber = 13, SqlFieldName = Cap_HospId ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCBCF)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="Cap_Acount">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="Cap_Date">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="Cap_Flag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="Cap_Handin">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="Cap_HospId">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="Cap_InitCap_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="Cap_ObjUsr_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="Cap_PayMode_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="Cap_Reports_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="Cap_Time">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="Cap_Type">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="Cap_Usr_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCBCF</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>Cap_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{Cap_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DHCBCFi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>Cap_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DATE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Cap_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Cap_Date}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{Cap_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInitCapDR">
<Global>^DHCBCFi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>{Cap_RowId}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"INITCAPDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Cap_InitCap_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Cap_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRepDR">
<Global>^DHCBCFi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>Cap_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RepDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Cap_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Cap_Reports_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{Cap_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>Cap_RowId</SqlRowIdName>
<StreamLocation>^User.DHCBillCapitalFlowS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
