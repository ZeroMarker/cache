Class User.DHCIPBillConfirm Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = Con_RowID, SqlTableName = DHC_IPBillConfirm, StorageStrategy = SQLStorage ]
{

Property ConAdm As %Library.String(TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = Con_Adm ];

Property ConBillNo As %Library.String(TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = Con_BillNo ];

/// Y 审核通过	N 审核拒绝	C 撤销审核
Property ConFlag As %Library.String(TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = Con_Flag ];

Property ConDate As %Library.Date [ SqlColumnNumber = 5, SqlFieldName = Con_Date ];

Property ConTime As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = Con_Time ];

Property ConUser As %Library.String(TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = Con_User ];

Property ConReason As %Library.String(MAXLEN = "") [ SqlColumnNumber = 8, SqlFieldName = Con_Reason ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCIPBILLCONFIRM)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="Con_Adm">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="Con_BillNo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="Con_Date">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="Con_Flag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="Con_Reason">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="Con_Time">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="Con_User">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCIPBILLCONFIRM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>Con_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{Con_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexBillNo">
<Global>^DHCIPBILLCONFIRM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Con_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BillNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Con_BillNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Con_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DHCIPBILLCONFIRM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Con_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Con_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Con_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUser">
<Global>^DHCIPBILLCONFIRM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Con_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"User"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Con_User}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Con_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCIPBillConfirmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
