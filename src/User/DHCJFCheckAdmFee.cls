Class User.DHCJFCheckAdmFee Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = JFCAF_Rowid, SqlTableName = DHC_JFCheckAdmFee, StorageStrategy = SQLStorage ]
{

/// 就诊ID
Property JFCAFAdmDr As User.PAAdm [ SqlColumnNumber = 2, SqlFieldName = JFCAF_Adm_Dr ];

/// 监控点
Property JFCAFMPCDr As User.DHCBillMonitorPointConfig [ SqlColumnNumber = 3, SqlFieldName = JFCAF_MPC_Dr ];

/// 审核点类型
Property JFCAFTypeCode As %Library.String [ SqlColumnNumber = 4, SqlFieldName = JFCAF_TypeCode ];

/// 审核点指针
Property JFCAFTypeDr As %Library.String [ SqlColumnNumber = 5, SqlFieldName = JFCAF_Type_Dr ];

/// 审核人
Property JFCAFUserDr As User.SSUser [ SqlColumnNumber = 6, SqlFieldName = JFCAF_User_Dr ];

/// 审核日期
Property JFCAFDate As %Library.Date(FORMAT = 1) [ InitialExpression = {+$h}, SqlColumnNumber = 7, SqlFieldName = JFCAF_Date ];

/// 审核时间
Property JFCAFTime As %Library.Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 8, SqlFieldName = JFCAF_Time ];

/// 审核备注
Property JFCAFMemo As %Library.String(MAXLEN = 3000) [ SqlColumnNumber = 9, SqlFieldName = JFCAF_Memo ];

/// 2022-11-14 ZhYW 审核级别
Property JFCAFLevel As %Library.String(MAXLEN = 11, TRUNCATE = 1, VALUELIST = ",1,2") [ SqlColumnNumber = 10, SqlFieldName = JFCAF_Level ];

/// 2022-11-14 ZhYW 更新人
Property JFCAFUpdtUserDr As User.SSUser [ SqlColumnNumber = 11, SqlFieldName = JFCAF_UpdtUser_Dr ];

/// 2022-11-14 ZhYW 更新日期
Property JFCAFUpdtDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 12, SqlFieldName = JFCAF_UpdtDate ];

/// 2022-11-14 ZhYW 更新时间
Property JFCAFUpdtTime As %Library.Time [ SqlColumnNumber = 13, SqlFieldName = JFCAF_UpdtTime ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCJFCheckAdmFee)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="JFCAF_Adm_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="JFCAF_Date">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="JFCAF_Level">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="JFCAF_MPC_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="JFCAF_Memo">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="JFCAF_Time">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="JFCAF_TypeCode">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="JFCAF_Type_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="JFCAF_UpdtDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="JFCAF_UpdtTime">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="JFCAF_UpdtUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="JFCAF_User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCJFCheckAdmFee</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>JFCAF_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{JFCAF_Rowid}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexTypeDR">
<Global>^DHCJFCheckAdmFee</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>JFCAF_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TypeDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{JFCAF_Adm_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{JFCAF_MPC_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{JFCAF_TypeCode}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{JFCAF_Type_Dr}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{JFCAF_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexAdm">
<Global>^DHCJFCheckAdmFee</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>JFCAF_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Adm"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{JFCAF_Adm_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{JFCAF_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexDate">
<Global>^DHCJFCheckAdmFee</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>JFCAF_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{JFCAF_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{JFCAF_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexMPC">
<Global>^DHCJFCheckAdmFee</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>JFCAF_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"MPCDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{JFCAF_MPC_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{JFCAF_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexUser">
<Global>^DHCJFCheckAdmFee</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>JFCAF_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"User"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{JFCAF_User_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{JFCAF_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCJFCheckAdmFeeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
