Class User.DHCPHMediSuggest Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHMS_RowId, SqlTableName = DHCPH_MediSuggest, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCPHMediSugItm As User.DHCPHMediSugItm [ Cardinality = children, Inverse = PHMSIPHMSParRef ];

/// PHMS_User_Dr  操作人
Property PHMSUserDr As User.SSUser [ SqlColumnNumber = 2, SqlFieldName = PHMS_User_Dr ];

/// PHMS_Adm_Dr  病人AdmDr
Property PHMSAdmDr As User.PAAdm [ SqlColumnNumber = 3, SqlFieldName = PHMS_Adm_Dr ];

/// PHMS_Date  操作日期
Property PHMSDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = PHMS_Date ];

/// PHMS_Time  操作时间
Property PHMSTime As %Library.Time [ SqlColumnNumber = 5, SqlFieldName = PHMS_Time ];

/// PHMS_EndDate  截止日期
Property PHMSEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = PHMS_EndDate ];

/// PHMS_EndTime  截止时间
Property PHMSEndTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = PHMS_EndTime ];

/// PHMS_AgreeFlag  同意标志
Property PHMSAgreeFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = PHMS_AgreeFlag ];

/// PHMS_OrdList  医嘱串
Property PHMSOrdList As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = PHMS_OrdList ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPHMS)</SqlIdExpression>
<SQLMap name="IndexAdm">
<Global>^DHCPHMS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHMS_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ADM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHMS_Adm_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHMS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="PHMS_Adm_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHMS_AgreeFlag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PHMS_Date">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHMS_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHMS_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PHMS_OrdList">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PHMS_Time">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHMS_User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCPHMS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHMS_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{PHMS_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHMediSuggestS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCPHMS)
	s oldI = +$g(^mdata("DHCPHMediSuggest"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCPHMS = maxI
	s ^mdata("DHCPHMediSuggest") = maxI
}

}
