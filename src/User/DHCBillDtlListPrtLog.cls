Class User.DHCBillDtlListPrtLog Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DPL_RowID, SqlTableName = DHC_BillDtlListPrtLog, StorageStrategy = SQLStorage ]
{

/// DPL_Date
Property DPLDate As %Library.Date(FORMAT = 1) [ InitialExpression = {+$h}, SqlColumnNumber = 2, SqlFieldName = DPL_Date ];

/// DPL_Time
Property DPLTime As %Library.Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 3, SqlFieldName = DPL_Time ];

/// DPL_User_DR
Property DPLUserDR As User.SSUser [ SqlColumnNumber = 4, SqlFieldName = DPL_User_DR ];

/// DPL_Inv_DR
Property DPLInvDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = DPL_Inv_DR ];

/// DPL_InvType
Property DPLInvType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = DPL_InvType ];

/// DPL_PrtTimes
Property DPLPrtTimes As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = DPL_PrtTimes ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCBillDtlListPrtLog)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DPL_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DPL_InvType">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DPL_Inv_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DPL_PrtTimes">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DPL_Time">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DPL_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCBillDtlListPrtLog</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DPL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DPL_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexInvDR">
<Global>^DHCBillDtlListPrtLogi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DPL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"InvDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DPL_InvType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DPL_Inv_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DPL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUserDate">
<Global>^DHCBillDtlListPrtLogi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DPL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"UserDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DPL_User_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DPL_Date}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DPL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DPL_RowID</SqlRowIdName>
<StreamLocation>^User.DHCBillDtlListPrtLogS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
