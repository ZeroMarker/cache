Class User.DhcJFYJAcount Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = Acct_RowId, SqlTableName = Dhc_JFYJAcount, StorageStrategy = SQLStorage ]
{

Property Acctlastremain As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = Acct_lastremain ];

/// Acct_jfsum
Property Acctjfsum As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = Acct_jfsum ];

/// Acct_dfsum
Property Acctdfsum As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = Acct_dfsum ];

/// Acct_curremain
Property Acctcurremain As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = Acct_curremain ];

/// Acct_stdate
Property Acctstdate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = Acct_stdate ];

/// Acct_enddate
Property Acctenddate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = Acct_enddate ];

/// Acct_adduser
Property Acctadduser As User.SSUser [ SqlColumnNumber = 8, SqlFieldName = Acct_adduser ];

/// Acct_adddate
Property Acctadddate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = Acct_adddate ];

/// Acct_flag
Property Acctflag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = Acct_flag ];

/// Acct_printflag
Property Acctprintflag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = Acct_printflag ];

/// Acct_sttime
Property Acctsttime As %Library.Time [ SqlColumnNumber = 12, SqlFieldName = Acct_sttime ];

/// Acct_endtime
Property Acctendtime As %Library.Time [ SqlColumnNumber = 13, SqlFieldName = Acct_endtime ];

/// Acct_addtime
Property Acctaddtime As %Library.Time [ SqlColumnNumber = 14, SqlFieldName = Acct_addtime ];

/// Acct_ward_dr
Property Acctwarddr As User.PACWard [ SqlColumnNumber = 15, SqlFieldName = Acct_ward_dr ];

/// Acct_Dep_dr
Property Acctdepdr As User.CTLoc [ SqlColumnNumber = 16, SqlFieldName = Acct_dep_dr ];

/// Acct_Hospital_dr
Property AcctHospitaldr As User.CTHospital [ SqlColumnNumber = 17, SqlFieldName = Acct_hospital_dr ];

Relationship ChildDhcJFFeeAcount As User.DhcJFFeeAcount [ Cardinality = children, Inverse = FeeAcctdr ];

Relationship ChildDHCJFYJAcountPaym As User.DHCJFYJAcountPaym [ Cardinality = children, Inverse = DHCJFYJPMAcctdr ];

Relationship ChildDHCIPBillDeptAcountDetail As User.DHCIPBillDeptAcountDetail [ Cardinality = children, Inverse = IBDParRef ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCJFYJACOUNT)</SqlIdExpression>
<SQLMap name="DHCJFYJACOUNT">
<Data name="Acct_adddate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="Acct_addtime">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="Acct_adduser">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="Acct_curremain">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="Acct_dep_dr">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="Acct_dfsum">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="Acct_enddate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="Acct_endtime">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="Acct_flag">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="Acct_hospital_dr">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="Acct_jfsum">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="Acct_lastremain">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="Acct_printflag">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="Acct_stdate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="Acct_sttime">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="Acct_ward_dr">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Global>^DHCJFYJACOUNT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>Acct_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{Acct_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="DHCJFYJACOUNTDate">
<Global>^DHCJFYJACOUNT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Acct_RowId</Field>
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
<AccessType>sub</AccessType>
<Expression>{Acct_adddate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{Acct_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="DHCJFYJACOUNTENDDATE">
<Global>^DHCJFYJACOUNT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Acct_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ENDDATE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Acct_enddate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Acct_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="DHCJFYJACOUNTFlag">
<Global>^DHCJFYJACOUNT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Acct_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Flag"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{Acct_flag}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{Acct_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="DHCJFYJACOUNTStdate">
<Global>^DHCJFYJACOUNT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Acct_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"STDATE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Acct_stdate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Acct_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="DHCJFYJACOUNTUser">
<Global>^DHCJFYJACOUNT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Acct_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"User"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{Acct_adduser}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{Acct_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="DHCJFYJACOUNTWARD">
<Global>^DHCJFYJACOUNT</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"Ward"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Other</AccessType>
<Expression>{Acct_ward_dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>"EndDate"</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{Acct_enddate}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>Sub</AccessType>
<Expression>{Acct_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAcctDateFlag">
<Global>^DHCJFYJACOUNT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>Acct_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DateFlag"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Acct_flag}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Acct_enddate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{Acct_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DhcJFYJAcountS</StreamLocation>
<Type>%Storage.SQL</Type>
}

Parameter EXTENTSIZE = 250;

}
