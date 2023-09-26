Class User.DHCIPMealMenu Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DHCMM_RowID, SqlTableName = DHC_IPMealMenu, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCIPMealMenuDetail As User.DHCIPMealMenuDetail [ Cardinality = children, Inverse = DHCMMDMMParref ];

/// DHCMM_StartDate
Property DHCMMStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 2, SqlFieldName = DHCMM_StartDate ];

/// DHCMM_EndDate
Property DHCMMEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = DHCMM_EndDate ];

/// DHCMM_Status //N:正常或正在使用(只能有一个)，A:使用过，T:模板或备用
Property DHCMMStatus As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DHCMM_Status ];

/// DHCMM_MenuLoc
Property DHCMMMenuLoc As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = DHCMM_MenuLoc ];

/// DHCMM_AddDate
Property DHCMMAddDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = DHCMM_AddDate ];

/// DHCMM_AddTime
Property DHCMMAddTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = DHCMM_AddTime ];

/// DHCMM_AddUser_Dr
Property DHCMMAddUserDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = DHCMM_AddUser_Dr ];

/// DHCMM_Remark
Property DHCMMRemark As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = DHCMM_Remark ];

/// DHCMM_Comment1
Property DHCMMComment1 As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = DHCMM_Comment1 ];

/// DHCMM_Comment2
Property DHCMMComment2 As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = DHCMM_Comment2 ];

/// DHCMM_AddDate
Property DHCMMUpDateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 12, SqlFieldName = DHCMM_UpDateDate ];

/// DHCMM_AddTime
Property DHCMMUpDateTime As %Library.Time [ SqlColumnNumber = 13, SqlFieldName = DHCMM_UpDateTime ];

/// DHCMM_AddUser_Dr
Property DHCMMUpDateUserDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = DHCMM_UpDateUser_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCIPMEALMENU)</SqlIdExpression>
<SQLMap name="AddUser">
<Global>^DHCIPMEALMENU</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AddUser"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCMM_AddUser_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCMM_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="DataMaster">
<Data name="DHCMM_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DHCMM_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DHCMM_AddUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DHCMM_Comment1">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DHCMM_Comment2">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DHCMM_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DHCMM_MenuLoc">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DHCMM_Remark">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DHCMM_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DHCMM_Status">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DHCMM_UpDateDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DHCMM_UpDateTime">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DHCMM_UpDateUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Global>^DHCIPMEALMENU</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHCMM_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHCMM_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexStartDate">
<Global>^DHCIPMEALMENU</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCMM_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"StartDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCMM_StartDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCMM_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="status">
<Global>^DHCIPMEALMENU</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Status"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCMM_Status}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCMM_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCIPMealMenuS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
