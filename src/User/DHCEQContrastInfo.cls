Class User.DHCEQContrastInfo Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = CI_RowID, SqlTableName = DHC_EQContrastInfo, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// CI_ContrastTypeDR
Property CIContrastTypeDR As User.DHCEQContrastType [ SqlColumnNumber = 2, SqlFieldName = CI_ContrastTypeDR ];

/// CI_SYSID
Property CISYSID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = CI_SYSID ];

/// CI_SYSCODE
Property CISYSCODE As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = CI_SYSCODE ];

/// CI_SYSDESC
Property CISYSDESC As %Library.String(COLLATION = "Exact", MAXLEN = 634, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = CI_SYSDESC ];

/// CI_EXID
Property CIEXID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = CI_EXID ];

/// CI_EXCODE
Property CIEXCODE As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = CI_EXCODE ];

/// CI_EXDESC
Property CIEXDESC As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = CI_EXDESC ];

/// CI_FromDate
Property CIFromDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = CI_FromDate ];

/// CI_ToDate
Property CIToDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 10, SqlFieldName = CI_ToDate ];

/// CI_Remark
Property CIRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = CI_Remark ];

/// CI_Hold1
Property CIHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = CI_Hold1 ];

/// CI_Hold2
Property CIHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = CI_Hold2 ];

/// CI_Hold3
Property CIHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = CI_Hold3 ];

/// CI_Hold4
Property CIHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = CI_Hold4 ];

/// CI_Hold5
Property CIHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = CI_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQContrastInfo",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="CI_ContrastTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CI_EXCODE">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CI_EXDESC">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CI_EXID">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CI_FromDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CI_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="CI_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="CI_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="CI_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="CI_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="CI_Remark">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="CI_SYSCODE">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CI_SYSDESC">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CI_SYSID">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CI_ToDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQContrastInfo"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{CI_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexExCode">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>CI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQContrastInfo"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"ExCode"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{CI_ContrastTypeDR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({CI_EXCODE})</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{CI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexExID">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQContrastInfo"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"EXID"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{CI_EXID}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{CI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSysID">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQContrastInfo"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"SYSID"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{CI_SYSID}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{CI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQContrastInfoS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
