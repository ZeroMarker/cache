/// DHC_MedUserLog
Class User.DHCMedUserLog Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MULG_RowID, SqlTableName = DHC_MedUserLog, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// ModelCode
Property MULGModelCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = MULG_ModelCode ];

/// SS_USER
Property MULGUserDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = MULG_User_DR ];

/// Start Date
Property MULGDateFrom As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = MULG_DateFrom ];

/// End Date
Property MULGDateTo As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = MULG_DateTo ];

/// Active Flag
Property MULGActiveFlg As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = MULG_ActiveFlg ];

/// user loc
Property MULGUserLoc As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = MULG_UserLoc ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCMedUserLog)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MULG_ActiveFlg">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MULG_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MULG_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MULG_ModelCode">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MULG_UserLoc">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MULG_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCMedUserLog</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MULG_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{MULG_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexModel">
<Global>^DHCMedUserLog</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MULG_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ModelCode"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MULG_ModelCode}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MULG_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexModelUser">
<Global>^DHCMedUserLog</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MULG_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ModelUser"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MULG_ModelCode}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MULG_User_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{MULG_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCMedUserLogS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
