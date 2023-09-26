Class User.DHCInvprtzySub Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PrtSub_rowid, SqlTableName = DHC_InvprtzySub, StorageStrategy = SQLStorage ]
{

/// PrtSub_Inv
Property PrtSubInv As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PrtSub_Inv ];

/// PrtSub_date
Property PrtSubdate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = PrtSub_date ];

/// PrtSub_time
Property PrtSubtime As %Library.Time [ SqlColumnNumber = 4, SqlFieldName = PrtSub_time ];

/// PrtSub_adm_dr
Property PrtSubadmdr As User.PAAdm [ SqlColumnNumber = 5, SqlFieldName = PrtSub_adm_dr ];

/// PrtSub_pb_dr
Property PrtSubpbdr As User.DHCPatientBill [ SqlColumnNumber = 6, SqlFieldName = PrtSub_pb_dr ];

/// PrtSub_invprtzy_dr
Property PrtSubinvprtzydr As User.DHCINVPRTZY [ SqlColumnNumber = 7, SqlFieldName = PrtSub_invprtzy_dr ];

///  PrtSub_Acount
Property PrtSubAcount As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = PrtSub_Acount ];

/// prt_user
Property PrtSubuser As User.SSUser [ SqlColumnNumber = 9, SqlFieldName = PrtSub_user ];

/// PrtSub_flag
Property PrtSubflag As %Library.String(DISPLAYLIST = ",Normal,Abort,Strike,Interm", MAXLEN = 6, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",N,A,S,I") [ SqlColumnNumber = 10, SqlFieldName = PrtSub_flag ];

/// PrtSub_intinv_dr
Property PrtSubinitinvdr As User.DHCInvprtzySub [ SqlColumnNumber = 11, SqlFieldName = PrtSub_initinv_dr ];

/// PrtSub_Handin
Property PrtSubHandin As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 12, SqlFieldName = PrtSub_Handin ];

/// PrtSub_HandinDate
Property PrtSubHandinDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 13, SqlFieldName = PrtSub_HandinDate ];

/// PrtSub_HandinTime
Property PrtSubHandinTime As %Library.Time [ SqlColumnNumber = 14, SqlFieldName = PrtSub_HandinTime ];

/// PrtSub_Jk_dr
Property PrtSubJkdr As %Library.String(COLLATION = "Exact", MAXLEN = 19, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = PrtSub_Jk_dr ];

/// PrtSub_Papmi_dr
Property PrtSubPapmidr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = PrtSub_Papmi_dr ];

/// PrtSub_Comment2
Property PrtSubComment2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = PrtSub_Comment2 ];

/// PrtSub_Comment3
Property PrtSubComment3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = PrtSub_Comment3 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCInvprtzySub)</SqlIdExpression>
<SQLMap name="dataMaster">
<Data name="PrtSub_Acount">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PrtSub_Comment2">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PrtSub_Comment3">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PrtSub_Handin">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PrtSub_HandinDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PrtSub_HandinTime">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PrtSub_Inv">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PrtSub_Jk_dr">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PrtSub_Papmi_dr">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PrtSub_adm_dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PrtSub_date">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PrtSub_flag">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PrtSub_initinv_dr">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PrtSub_invprtzy_dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PrtSub_pb_dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PrtSub_time">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PrtSub_user">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^DHCInvprtzySub</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PrtSub_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PrtSub_rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexPapmi">
<Global>^DHCInvprtzySub</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PrtSub_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PAPMI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PrtSub_Papmi_dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PrtSub_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexadm">
<Global>^DHCInvprtzySub</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PrtSub_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Adm"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PrtSub_adm_dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PrtSub_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexcomment2">
<Global>^DHCInvprtzySub</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PrtSub_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"COM2"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PrtSub_Comment2}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PrtSub_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexcomment3">
<Global>^DHCInvprtzySub</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PrtSub_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"COM3"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PrtSub_Comment3}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PrtSub_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexdate">
<Global>^DHCInvprtzySub</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PrtSub_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PrtSub_date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PrtSub_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexdateuser">
<Global>^DHCInvprtzySub</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PrtSub_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DateUser"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PrtSub_date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PrtSub_user}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PrtSub_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexflag">
<Global>^DHCInvprtzySub</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PrtSub_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Flag"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PrtSub_flag}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PrtSub_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexhandin">
<Global>^DHCInvprtzySub</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PrtSub_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Handin"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PrtSub_Handin}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PrtSub_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexhandindate">
<Global>^DHCInvprtzySub</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PrtSub_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HandDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PrtSub_HandinDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PrtSub_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexinitinv">
<Global>^DHCInvprtzySub</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PrtSub_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"InitInv"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PrtSub_initinv_dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PrtSub_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexinv">
<Global>^DHCInvprtzySub</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PrtSub_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"INV"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PrtSub_Inv}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PrtSub_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexinvprtzydr">
<Global>^DHCInvprtzySub</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PrtSub_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"InvprtzyDr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PrtSub_invprtzy_dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PrtSub_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexjkdr">
<Global>^DHCInvprtzySub</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PrtSub_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"JkDr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PrtSub_Jk_dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PrtSub_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexpb">
<Global>^DHCInvprtzySub</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PrtSub_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PbDr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PrtSub_pb_dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PrtSub_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexuser">
<Global>^DHCInvprtzySub</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PrtSub_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"User"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PrtSub_user}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PrtSub_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCInvprtzySubS</StreamLocation>
<Type>%Storage.SQL</Type>
}

Parameter EXTENTSIZE = 250;

}
