/// stock item stored condition
Class User.DHCItmStoreCond Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ISC_RowID, SqlTableName = DHC_ItmStoreCond, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// common tempreture
Property ISCCommonTemp As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 2, SqlFieldName = ISC_CommonTemp ];

/// the min tempreture
Property ISCMinTemp As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ISC_MinTemp ];

/// the max tempreture
Property ISCMaxTemp As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = ISC_MaxTemp ];

/// dhcisc_dry
Property ISCDry As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = ISC_Dry ];

/// dhcisc_MinHumidity
Property ISCMinHumidity As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = ISC_MinHumidity ];

/// dhcisc_MaxHumidity
Property ISCMaxHumidity As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = ISC_MaxHumidity ];

/// dhcisc_Airtight
Property ISCAirtight As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = ISC_Airtight ];

/// dhcisc_Dark
Property ISCDark As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = ISC_Dark ];

/// dhcisc_Ventilate
Property ISCVentilate As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = ISC_Ventilate ];

/// dhcisc_Radiation
Property ISCRadiation As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = ISC_Radiation ];

/// seal
Property ISCSeal As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 12, SqlFieldName = ISC_Seal ];

/// ISC_CoolGloomy
Property ISCCoolGloomy As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = ISC_CoolGloomy ];

/// ISC_GloomyCool
Property ISCGloomyCool As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 14, SqlFieldName = ISC_GloomyCool ];

/// ISC_MeltPack
Property ISCMeltPack As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 15, SqlFieldName = ISC_MeltPack ];

/// ISC_COLDST
Property ISCCOLDST As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 16, SqlFieldName = ISC_COLDST ];

/// 冷冻
Property ISCFREEZE As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 17, SqlFieldName = ISC_FREEZE ];

/// 防潮
Property ISCDAMPPROOF As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 18, SqlFieldName = ISC_DAMPPROOF ];

/// 遮光
Property ISCSHADING As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 19, SqlFieldName = ISC_SHADING ];

/// 避免冰冻
Property ISCFREEZEAVOIDANCE As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 20, SqlFieldName = ISC_FREEZEAVOIDANCE ];

/// 阴凉
Property ISCShadyCool As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 21, SqlFieldName = ISC_ShadyCool ];

/// 防霉
Property ISCMildewProof As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 22, SqlFieldName = ISC_MildewProof ];

/// 防蛀
Property ISCMothProof As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 23, SqlFieldName = ISC_MothProof ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCItemSC)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ISC_Airtight">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ISC_COLDST">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ISC_CommonTemp">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ISC_CoolGloomy">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="ISC_DAMPPROOF">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="ISC_Dark">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ISC_Dry">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ISC_FREEZE">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="ISC_FREEZEAVOIDANCE">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="ISC_GloomyCool">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="ISC_MaxHumidity">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ISC_MaxTemp">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ISC_MeltPack">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ISC_MildewProof">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="ISC_MinHumidity">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ISC_MinTemp">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ISC_MothProof">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="ISC_Radiation">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ISC_SHADING">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="ISC_Seal">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="ISC_ShadyCool">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="ISC_Ventilate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCItemSC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ISC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{ISC_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCItmStoreCondS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCItemSC)
	s oldI = +$g(^mdata("DHCITMSTORECOND"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCItemSC = maxI
	s ^mdata("DHCITMSTORECOND") = maxI
}

}
