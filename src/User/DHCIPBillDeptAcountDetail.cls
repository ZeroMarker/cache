Class User.DHCIPBillDeptAcountDetail Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = IBD_RowID, SqlTableName = DHC_IPBillDeptAcountDetail, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On IBDSub [ IdKey, PrimaryKey, Unique ];

/// DHC_AccPFoot Parent Reference
Relationship IBDParRef As User.DhcJFYJAcount [ Cardinality = parent, Inverse = ChildDHCIPBillDeptAcountDetail, Required, SqlFieldName = IBD_ParRef ];

/// AccPFS_Sub
Property IBDSub As %Library.Float [ InitialExpression = {$i(^DHCIPBillDeptAcountD($p(%d(0),$c(1),1),"SUB",0))}, SqlColumnNumber = 2, SqlFieldName = IBD_Sub ];

/// AccPFS_AccM_DR
Property IBDAdm As %Library.String [ SqlColumnNumber = 3, SqlFieldName = IBD_Adm ];

/// IBDSub
Property IBDAdd As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = IBD_Add ];

/// AccPFS_CardPay
Property IBDRef As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = IBD_Ref ];

/// AccPFS_CurLeft
Property IBDPay As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = IBD_Pay ];

/// AccPFS_RefundPrePay
Property IBDPreBal As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = IBD_PreBal ];

/// AccPFS_PrePay
Property IBDCurBal As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = IBD_CurBal ];

/// AccPFS_Note4
Property IBDNote1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = IBD_Note1 ];

/// AccPFS_Note5
Property IBDNote2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = IBD_Note2 ];

/// AccPFS_Note6
Property IBDNote3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = IBD_Note3 ];

/// AccPFS_Note7
Property IBDNote4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = IBD_Note4 ];

/// AccPFS_Note8
Property IBDNote5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = IBD_Note5 ];

/// AccPFS_Note9
Property IBDNote6 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = IBD_Note6 ];

/// AccPFS_Note10
Property IBDNote7 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = IBD_Note7 ];

/// AccPFS_AccM_DR
Property IBDLoc As %Library.String [ SqlColumnNumber = 16, SqlFieldName = IBD_Loc ];

/// AccPFS_AdmStatus
Property IBDAdmStatus As %Library.String [ SqlColumnNumber = 17, SqlFieldName = IBD_AdmStatus ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Master">
<Data name="IBD_Add">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="IBD_Adm">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="IBD_AdmStatus">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="IBD_CurBal">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="IBD_Loc">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="IBD_Note1">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="IBD_Note2">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="IBD_Note3">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="IBD_Note4">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="IBD_Note5">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="IBD_Note6">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="IBD_Note7">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="IBD_Pay">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="IBD_PreBal">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="IBD_Ref">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCIPBillDeptAcountD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>Dhc_JFYJAcount.Acct_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>IBD_Sub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{Dhc_JFYJAcount.Acct_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SUB"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IBD_Sub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexofadm">
<Global>^DHCIPBillDeptAcountD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Dhc_JFYJAcount.Acct_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>IBD_Sub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Adm"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IBD_Adm}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Dhc_JFYJAcount.Acct_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{IBD_Sub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCIPBillDeFD57S</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
