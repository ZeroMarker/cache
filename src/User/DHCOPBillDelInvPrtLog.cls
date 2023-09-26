Class User.DHCOPBillDelInvPrtLog Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DIL_RowID, SqlTableName = DHC_OPBillDelInvPrtLog, StorageStrategy = SQLStorage ]
{

/// DIL_Date
Property DILDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 2, SqlFieldName = DIL_Date ];

/// DIL_Time
Property DILTime As %Library.Time [ SqlColumnNumber = 3, SqlFieldName = DIL_Time ];

/// DIL_User_DR
Property DILUserDR As User.SSUser [ SqlColumnNumber = 4, SqlFieldName = DIL_User_DR ];

/// DIL_InvPrt_DR  -> DHC_INVPRT
Property DILInvPrtDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = DIL_InvPrt_DR ];

/// DIL_PAPMI_DR
Property DILPAPMIDR As User.PAPatMas [ SqlColumnNumber = 6, SqlFieldName = DIL_PAPMI_DR ];

/// DIL_InvUser_DR(DHC_INVPRT.PRT_Usr)
Property DILInvUserDR As User.SSUser [ SqlColumnNumber = 7, SqlFieldName = DIL_InvUser_DR ];

/// DIL_InvAcount
Property DILInvAcount As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = DIL_InvAcount ];

/// DIL_InvDate
Property DILInvDate As %Library.Date [ SqlColumnNumber = 9, SqlFieldName = DIL_InvDate ];

/// DIL_InvTime
Property DILInvTime As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = DIL_InvTime ];

/// DIL_BCIDRStr  DHC_BillConInv.RowID 串(以"|"分割)
Property DILBCIDRStr As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = DIL_BCIDRStr ];

/// DIL_PBDRStr  DHC_PatientBill.RowID 串(以"|"分割)
Property DILPBDRStr As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = DIL_PBDRStr ];

/// DIL_InsDiv_DR -> INSU_Divide
Property DILInsDivDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = DIL_InsDiv_DR ];

/// DIL_Group_DR
Property DILGroupDR As User.SSGroup [ SqlColumnNumber = 14, SqlFieldName = DIL_Group_DR ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCOPBillDelInvPrtLog)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DIL_BCIDRStr">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DIL_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DIL_Group_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DIL_InsDiv_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DIL_InvAcount">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DIL_InvDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DIL_InvPrt_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DIL_InvTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DIL_InvUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DIL_PAPMI_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DIL_PBDRStr">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DIL_Time">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DIL_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCOPBillDelInvPrtLog</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DIL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DIL_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DHCOPBillDelInvPrtLogi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DIL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DATE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DIL_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DIL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInvPrt">
<Global>^DHCOPBillDelInvPrtLogi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DIL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"INV"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DIL_InvPrt_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DIL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DIL_RowID</SqlRowIdName>
<StreamLocation>^User.DHCOPBillDelInvPrtLogS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
