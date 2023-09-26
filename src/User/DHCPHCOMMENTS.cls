Class User.DHCPHCOMMENTS Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PCNTS_RowID, SqlTableName = DHC_PHCOMMENTS, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCPHCOMMENTSITM As User.DHCPHCOMMENTSITM [ Cardinality = children, Inverse = PCNTSIParRefDr ];

Relationship ChildDHCPHCOMMENTSREITM As User.DHCPHCOMMENTSREITM [ Cardinality = children, Inverse = PCNTSRIParRefDr ];

/// PCNTS_No
Property PCNTSNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PCNTS_No ];

/// PCNTS_Date
Property PCNTSDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = PCNTS_Date ];

/// PCNTS_Time
Property PCNTSTime As %Library.Time [ SqlColumnNumber = 4, SqlFieldName = PCNTS_Time ];

/// PCNTS_Text
Property PCNTSText As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PCNTS_Text ];

/// PCNTS_Type
Property PCNTSType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = PCNTS_Type ];

/// PCNTS_User_Dr
Property PCNTSUserDr As User.SSUser [ SqlColumnNumber = 7, SqlFieldName = PCNTS_User_Dr ];

/// PCNTS_Way_Dr
Property PCNTSWayDr As User.DHCPHCNTSWAY [ SqlColumnNumber = 8, SqlFieldName = PCNTS_Way_Dr ];

/// PCNTS_Hosp_Dr
Property PCNTSHospDr As User.CTHospital [ SqlColumnNumber = 9, SqlFieldName = PCNTS_Hosp_Dr ];

/// PCNTS_SubmFlag
Property PCNTSSubmFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = PCNTS_SubmFlag ];

/// PCNTS_Note
Property PCNTSNote As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = PCNTS_Note ];

/// PCNTS_PrescCounts
Property PCNTSPrescCounts As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = PCNTS_PrescCounts ];

/// PCNTS_AdmCounts
Property PCNTSAdmCounts As %Library.Float [ SqlColumnNumber = 13, SqlFieldName = PCNTS_AdmCounts ];

/// PCNTS_ReSaveFlag	//二次抽取标志
Property PCNTSReSaveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 14, SqlFieldName = PCNTS_ReSaveFlag ];

/// 点评单状态
Property PCNTSStatus As %Library.String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = PCNTS_Status ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPHCNTS)</SqlIdExpression>
<SQLMap name="IndexDate">
<Global>^DHCPHCNTS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PCNTS_RowID</Field>
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
<Expression>{PCNTS_Date}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PCNTS_Type}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{PCNTS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexNo">
<Global>^DHCPHCNTS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PCNTS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"No"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PCNTS_No}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PCNTS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="PCNTS_AdmCounts">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PCNTS_Date">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PCNTS_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PCNTS_No">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PCNTS_Note">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PCNTS_PrescCounts">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PCNTS_ReSaveFlag">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PCNTS_Status">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PCNTS_SubmFlag">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PCNTS_Text">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PCNTS_Time">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PCNTS_Type">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PCNTS_User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PCNTS_Way_Dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCPHCNTS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PCNTS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PCNTS_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHCOMMENTSS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCPHCNTS)
	s oldI = +$g(^mdata("DHCPHCOMMENTS"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCPHCNTS = maxI
	s ^mdata("DHCPHCOMMENTS") = maxI
}

}
