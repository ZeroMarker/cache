Class User.DHCCardPATRegConfig Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = CPR_RowID, SqlTableName = DHC_CardPATRegConfig, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// CPR_SearchMasFlag
Property CPRSearchMasFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 2, SqlFieldName = CPR_SearchMasFlag ];

/// CPR_SetFocusElement
Property CPRSetFocusElement As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = CPR_SetFocusElement ];

/// CPR_PatMasFlag
Property CPRPatMasFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = CPR_PatMasFlag ];

/// CPR_CardRefFlag
Property CPRCardRefFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = CPR_CardRefFlag ];

/// CPR_AccManageFLag
Property CPRAccManageFLag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = CPR_AccManageFLag ];

/// CPR_ParseTag
Property CPRParseTag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = CPR_ParseTag ];

/// CPR_DefaultCountry_DR
Property CPRDefaultCountryDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = CPR_DefaultCountry_DR ];

/// CPR_DefaultNation_DR
Property CPRDefaultNationDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = CPR_DefaultNation_DR ];

/// CPR_DefaultProvince_DR
Property CPRDefaultProvinceDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = CPR_DefaultProvince_DR ];

/// CPR_DefaultCity_DR
Property CPRDefaultCityDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = CPR_DefaultCity_DR ];

/// CPR_Note5
Property CPRNote5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = CPR_Note5 ];

/// CPR_Note6
Property CPRNote6 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = CPR_Note6 ];

/// CPR_Note7
Property CPRNote7 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = CPR_Note7 ];

/// CPR_Note8
Property CPRNote8 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = CPR_Note8 ];

/// CPR_Note9
Property CPRNote9 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = CPR_Note9 ];

/// CPR_Note10
Property CPRNote10 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = CPR_Note10 ];

/// CPR_AccManageFLag
Property CPRIsNotStructAddressFLag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 18, SqlFieldName = CPR_IsNotStructAddressFLag ];

/// CPR_HospDR
Property CPRHospDR As CTHospital [ SqlColumnNumber = 19, SqlFieldName = CPR_Hosp_DR ];

/// CPR_CardRegMustFillIn
Property CPRCardRegMustFillIn As %String(COLLATION = "Exact", MAXLEN = 30000, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = CPR_CardRegMustFillIn ];

/// CPR_CardRegJumpSeq
Property CPRCardRegJumpSeq As %String(COLLATION = "Exact", MAXLEN = 30000, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = CPR_CardRegJumpSeq ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCARDPATREGCONFIG)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="CPR_AccManageFLag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CPR_CardRefFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CPR_CardRegJumpSeq">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="CPR_CardRegMustFillIn">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="CPR_DefaultCity_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="CPR_DefaultCountry_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CPR_DefaultNation_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CPR_DefaultProvince_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CPR_Hosp_DR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="CPR_IsNotStructAddressFLag">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="CPR_Note10">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="CPR_Note5">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="CPR_Note6">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="CPR_Note7">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="CPR_Note8">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="CPR_Note9">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="CPR_ParseTag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CPR_PatMasFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CPR_SearchMasFlag">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CPR_SetFocusElement">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCCARDPATREGCONFIG</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CPR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{CPR_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCCardPATRegConfigS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
