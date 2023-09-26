Class User.DHCSSVendorUser Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = VU_RowId, SqlTableName = DHC_SSVendorUser, StorageStrategy = SQLStorage1 ]
{

/// VU_APCVM_DR
Property VUAPCVMDR As User.APCVendor [ Required, SqlColumnNumber = 2, SqlFieldName = VU_APCVM_DR ];

/// VU_UserID
Property VUUserID As %String [ Required, SqlColumnNumber = 3, SqlFieldName = VU_UserID ];

/// VU_UserPassword
Property VUUserPassword As %String [ Required, SqlColumnNumber = 4, SqlFieldName = VU_UserPassword ];

/// VU_UserName
Property VUUserName As %String [ Required, SqlColumnNumber = 5, SqlFieldName = VU_UserName ];

/// VU_SSUSR_DR
Property VUSSUSRDR As User.SSUser [ SqlColumnNumber = 6, SqlFieldName = VU_SSUSR_DR ];

/// VU_GROUP_DR
Property VUGROUPDR As User.SSGroup [ SqlColumnNumber = 7, SqlFieldName = VU_GROUP_DR ];

/// VU_DateFrom
Property VUDateFrom As %Library.Date [ SqlColumnNumber = 8, SqlFieldName = VU_DateFrom ];

/// VU_DateTo
Property VUDateTo As %Library.Date [ SqlColumnNumber = 9, SqlFieldName = VU_DateTo ];

/// VU_Active
Property VUActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = VU_Active ];

/// VU_Effective
Property VUEffective As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = VU_Effective ];

Storage SQLStorage1
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCSSVU("VU",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="VU_APCVM_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="VU_Active">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="VU_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="VU_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="VU_Effective">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="VU_GROUP_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="VU_SSUSR_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="VU_UserID">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="VU_UserName">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="VU_UserPassword">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCSSVU</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>VU_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{VU_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexSSUSR">
<Global>^DHCSSVU</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>VU_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"USER"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{VU_SSUSR_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{VU_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>VU_RowId</SqlRowIdName>
<StreamLocation>^User.DHCSSVendorUserS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
