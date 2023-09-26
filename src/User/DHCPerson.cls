Class User.DHCPerson Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PAPER_RowID, SqlTableName = DHC_Person, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PAPER_PaPerson_dr
Property PAPERPaPersondr As User.PAPerson [ SqlColumnNumber = 2, SqlFieldName = PAPER_PaPerson_dr ];

/// PAPER_SGMedicareCode1
Property PAPERSGMedicareCode1 As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PAPER_SGMedicareCode1 ];

/// PAPER_SGMedicareCode2
Property PAPERSGMedicareCode2 As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PAPER_SGMedicareCode2 ];

/// PAPER_SGMedicareCode3
Property PAPERSGMedicareCode3 As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PAPER_SGMedicareCode3 ];

/// PAPER_FCMedicareCode1
Property PAPERFCMedicareCode1 As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = PAPER_FCMedicareCode1 ];

/// PAPER_FCMedicareCode2
Property PAPERFCMedicareCode2 As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = PAPER_FCMedicareCode2 ];

/// PAPER_Comment1
Property PAPERComment1 As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = PAPER_Comment1 ];

/// PAPER_Comment2
Property PAPERComment2 As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = PAPER_Comment2 ];

/// PAPER_Comment3
Property PAPERComment3 As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = PAPER_Comment3 ];

/// PAPER_Comment4
Property PAPERComment4 As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = PAPER_Comment4 ];

/// PAPER_Comment5
Property PAPERComment5 As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = PAPER_Comment5 ];

/// PAPER_CityFlag
Property PAPERCityFlag As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = PAPER_CityFlag ];

Property PAPERBirthProvinceDR As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = PAPER_BirthProvince_DR ];

Property PAPERBirthCityDR As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = PAPER_BirthCity_DR ];

Property PAPERBirthAreadr As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = PAPER_BirthArea_dr ];

Property PAPERBirthAddress As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = PAPER_BirthAddress ];

Property PAPERHouseProvinceDR As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = PAPER_HouseProvince_DR ];

Property PAPERHouseCityDR As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = PAPER_HouseCity_DR ];

Property PAPERHouseAreaDR As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = PAPER_HouseArea_DR ];

Property PAPERHouseAddress As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = PAPER_HouseAddress ];

Property PAPERHouseCountryDR As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = PAPER_HouseCountry_DR ];

/// // 出生街道
Property PAPERBirthStreetDR As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = PAPER_BirthStreet_DR ];

/// /户口街道
Property PAPERHouseStreetDR As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = PAPER_HouseStreet_DR ];

/// / 现住街道
Property PAPERStreetDR As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = PAPER_Street_DR ];

/// // 出生地址
Property PAPERBirthAddressNewDR As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = PAPER_BirthAddressNew_DR ];

/// /户口地址
Property PAPERHouseAddressNewDR As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = PAPER_HouseAddressNew_DR ];

/// / 现住地址
Property PAPERAddressNewDR As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = PAPER_AddressNew_DR ];

/// 同意网络/app查看病历
Property PAPERAgreeEmrWebFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 29, SqlFieldName = PAPER_AgreeEmrWebFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPERSON)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PAPER_AddressNew_DR">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="PAPER_AgreeEmrWebFlag">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="PAPER_BirthAddress">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PAPER_BirthAddressNew_DR">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="PAPER_BirthArea_dr">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PAPER_BirthCity_DR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PAPER_BirthProvince_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PAPER_BirthStreet_DR">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="PAPER_CityFlag">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PAPER_Comment1">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PAPER_Comment2">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PAPER_Comment3">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PAPER_Comment4">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PAPER_Comment5">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PAPER_FCMedicareCode1">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PAPER_FCMedicareCode2">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PAPER_HouseAddress">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="PAPER_HouseAddressNew_DR">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="PAPER_HouseArea_DR">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="PAPER_HouseCity_DR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="PAPER_HouseCountry_DR">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="PAPER_HouseProvince_DR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PAPER_HouseStreet_DR">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="PAPER_PaPerson_dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PAPER_SGMedicareCode1">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PAPER_SGMedicareCode2">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PAPER_SGMedicareCode3">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PAPER_Street_DR">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Global>^DHCPERSON</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PAPER_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PAPER_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCityFlag">
<Global>^DHCPERSON</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PAPER_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CityFlag"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PAPER_CityFlag}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PAPER_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexComment1">
<Global>^DHCPERSON</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PAPER_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Comment1"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PAPER_Comment1}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PAPER_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexComment2">
<Global>^DHCPERSON</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PAPER_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Comment2"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PAPER_Comment2}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PAPER_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexComment3">
<Global>^DHCPERSON</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PAPER_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Comment3"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PAPER_Comment3}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PAPER_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexComment4">
<Global>^DHCPERSON</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PAPER_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Comment4"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PAPER_Comment4}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PAPER_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexComment5">
<Global>^DHCPERSON</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PAPER_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Comment5"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PAPER_Comment5}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PAPER_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexFCMedicareCode1">
<Global>^DHCPERSON</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PAPER_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"FCMedicareCode1"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PAPER_FCMedicareCode1}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PAPER_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexFCMedicareCode2">
<Global>^DHCPERSON</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PAPER_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"FCMedicareCode2"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PAPER_FCMedicareCode2}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PAPER_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPaPerson">
<Global>^DHCPERSON</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PAPER_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PAPERSON"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PAPER_PaPerson_dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PAPER_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSGMedicareCode1">
<Global>^DHCPERSON</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PAPER_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SGMedicareCode1"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PAPER_SGMedicareCode1}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PAPER_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSGMedicareCode2">
<Global>^DHCPERSON</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PAPER_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SGMedicareCode2"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PAPER_SGMedicareCode2}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PAPER_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSGMedicareCode3">
<Global>^DHCPERSON</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PAPER_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SGMedicareCode3"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PAPER_SGMedicareCode3}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PAPER_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPersonS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
