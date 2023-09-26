Class User.DHCAdvParInformation Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = PARINFO_RowID, SqlTableName = DHC_AdvParInformation, StorageStrategy = SQLStorage ]
{

/// PARINFO_RepDr	报告id
Property PARINFORepDr As User.DHCMedAdrReport [ SqlColumnNumber = 2, SqlFieldName = PARINFO_RepDr ];

/// PARINFO_ParCarType 当事人职别
Property PARINFOParCarType As %String [ SqlColumnNumber = 3, SqlFieldName = PARINFO_ParCarType ];

/// PARINFO_ParCarPrv	当事人职称
Property PARINFOParCarPrv As %String [ SqlColumnNumber = 4, SqlFieldName = PARINFO_ParCarPrv ];

/// PARINFO_ParCarPrvYears 当事人职称年资
Property PARINFOParCarPrvYears As %String [ SqlColumnNumber = 5, SqlFieldName = PARINFO_ParCarPrvYears ];

/// PARINFO_ParSerYears 当事人服务年资
Property PARINFOParSerYears As %String [ SqlColumnNumber = 6, SqlFieldName = PARINFO_ParSerYears ];

/// PARINFO_ParIdCategory	当事人身份类别
Property PARINFOParIdCategory As %String [ SqlColumnNumber = 7, SqlFieldName = PARINFO_ParIdCategory ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCADVPARINFO)</SqlIdExpression>
<SQLMap name="IndexRepDr">
<Global>^DHCADVPARINFO</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PARINFO_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RepDr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PARINFO_RepDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PARINFO_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="PARINFO_ParCarPrv">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PARINFO_ParCarPrvYears">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PARINFO_ParCarType">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PARINFO_ParIdCategory">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PARINFO_ParSerYears">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PARINFO_RepDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCADVPARINFO</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PARINFO_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PARINFO_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAdvParInformationS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
