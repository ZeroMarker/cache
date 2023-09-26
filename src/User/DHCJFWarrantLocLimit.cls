Class User.DHCJFWarrantLocLimit Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = JFWLL_RowID, SqlTableName = DHC_JFWarrantLocLimit, StorageStrategy = SQLStorage1 ]
{

Parameter EXTENTSIZE = 250;

/// JFWLL_Loc_DR
Property JFWLLLocDR As User.CTLoc [ SqlColumnNumber = 2, SqlFieldName = JFWLL_Loc_DR ];

/// JFWLL_AdmReason_DR
Property JFWLLAdmReasonDR As User.PACAdmReason [ SqlColumnNumber = 3, SqlFieldName = JFWLL_AdmReason_DR ];

/// JFWLL_TimeLimitType
Property JFWLLTimeLimitType As %Library.String(DISPLAYLIST = ",Date,Hour", MAXLEN = 4, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",D,H") [ SqlColumnNumber = 4, SqlFieldName = JFWLL_TimeLimitType ];

/// JFWLL_TimeLimit
Property JFWLLTimeLimit As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 5, SqlFieldName = JFWLL_TimeLimit ];

/// JFWLL_LimitAmount
Property JFWLLLimitAmount As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 6, SqlFieldName = JFWLL_LimitAmount ];

/// JFWLL_User_DR
Property JFWLLUserDR As User.SSUser [ SqlColumnNumber = 7, SqlFieldName = JFWLL_User_DR ];

/// JFALL_Date
Property JFWLLDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = JFWLL_Date ];

/// JFALL_Time
Property JFWLLTime As %Library.Time(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = JFWLL_Time ];

/// JFALL_Time
Property JFWLLHospDr As %Library.String [ SqlColumnNumber = 10, SqlFieldName = JFWLL_HospDr ];

Storage SQLStorage1
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCJFWARRANTLOCLIMIT)</SqlIdExpression>
<SQLMap name="DHCJFWarrantLocLimit">
<Data name="JFWLL_AdmReason_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="JFWLL_Date">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="JFWLL_HospDr">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="JFWLL_LimitAmount">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="JFWLL_Loc_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="JFWLL_Time">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="JFWLL_TimeLimit">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="JFWLL_TimeLimitType">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="JFWLL_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCJFWARRANTLOCLIMIT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>JFWLL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{JFWLL_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexLocAdmReason">
<Global>^DHCJFWARRANTLOCLIMITi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>JFWLL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LOCAdmReason"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{JFWLL_Loc_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{JFWLL_AdmReason_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{JFWLL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexAdmReason">
<Global>^DHCJFWARRANTLOCLIMITi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>JFWLL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AdmReason"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{JFWLL_AdmReason_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{JFWLL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexloc">
<Global>^DHCJFWARRANTLOCLIMITi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>JFWLL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LOC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{JFWLL_Loc_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{JFWLL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCJFWarrantLocLimitS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
