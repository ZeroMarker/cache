Class User.DHCPHBasManTeacher Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHBMT_RowID, SqlTableName = DHC_PHBasManTeacher, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PHBMT_User_Dr
Property PHBMTUserDr As User.SSUser [ SqlColumnNumber = 2, SqlFieldName = PHBMT_User_Dr ];

/// PHBMT_Sex_Dr
Property PHBMTSexDr As User.CTSex [ SqlColumnNumber = 3, SqlFieldName = PHBMT_Sex_Dr ];

/// PHBMT_Education
Property PHBMTEducation As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PHBMT_Education ];

/// PHBMT_Loc_Dr
Property PHBMTLocDr As User.CTLoc [ SqlColumnNumber = 5, SqlFieldName = PHBMT_Loc_Dr ];

/// PHBMT_Career
Property PHBMTCareer As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = PHBMT_Career ];

/// PHBMT_CarPrvTp
Property PHBMTCarPrvTp As User.CTCareProv [ SqlColumnNumber = 7, SqlFieldName = PHBMT_CarPrvTp ];

/// PHBMT_Date
Property PHBMTDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = PHBMT_Date ];

/// PHBMT_Time
Property PHBMTTime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = PHBMT_Time ];

/// PHBMT_Remark
Property PHBMTRemark As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = PHBMT_Remark ];

/// PHBMT_Age
Property PHBMTAge As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = PHBMT_Age ];

/// PHBMT_Flag
Property PHBMTFlag As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = PHBMT_Flag ];

/// PHBMT_ClinicalDate
Property PHBMTClinicalDate As %Library.Date [ SqlColumnNumber = 13, SqlFieldName = PHBMT_ClinicalDate ];

/// PHBMT_CliTeaDate
Property PHBMTCliTeaDate As %Library.Date [ SqlColumnNumber = 14, SqlFieldName = PHBMT_CliTeaDate ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPHBMT)</SqlIdExpression>
<SQLMap name="DataMater">
<Data name="PHBMT_Age">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PHBMT_CarPrvTp">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PHBMT_Career">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHBMT_CliTeaDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PHBMT_ClinicalDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PHBMT_Date">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PHBMT_Education">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHBMT_Flag">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PHBMT_Loc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHBMT_Remark">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PHBMT_Sex_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHBMT_Time">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PHBMT_User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCPHBMT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHBMT_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHBMT_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DHCPHBMT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHBMT_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RepDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHBMT_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHBMT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPHBasManTeacherS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCPHBMT)
	s oldI = +$g(^mdata("DHCPHBASMANTEACHER"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCPHBMT = maxI
	s ^mdata("DHCPHBASMANTEACHER") = maxI
}

}
