Class User.DHCEQCLocUser Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = LU_RowID, SqlTableName = DHC_EQCLocUser, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// LU_UserType 人员类型
Property LUUserType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = LU_UserType ];

/// LU_LocDR
Property LULocDR As User.DHCEQCDepartment [ SqlColumnNumber = 3, SqlFieldName = LU_LocDR ];

/// LU_UserDR
Property LUUserDR As User.DHCEQCUser [ SqlColumnNumber = 4, SqlFieldName = LU_UserDR ];

/// LU_InvalidFlag
Property LUInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = LU_InvalidFlag ];

/// LU_ValidDate
Property LUValidDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = LU_ValidDate ];

/// LU_ValidDateTo
Property LUValidDateTo As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = LU_ValidDateTo ];

/// LU_Hold1
Property LUHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = LU_Hold1 ];

/// LU_Hold2
Property LUHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = LU_Hold2 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCLocUser",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="LU_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="LU_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="LU_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="LU_LocDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="LU_UserDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="LU_UserType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="LU_ValidDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="LU_ValidDateTo">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>LU_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCLocUser"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{LU_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexLocUser">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>LU_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DHCEQCLocUser"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"LocUser"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LU_LocDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{LU_UserDR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{LU_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocUserType">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>LU_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DHCEQCLocUser"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"LocUserType"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LU_LocDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{LU_UserType}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{LU_UserDR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{LU_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUserType">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>LU_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DHCEQCLocUser"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"UserType"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LU_UserType}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{LU_UserDR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{LU_LocDR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{LU_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCLocUserS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
