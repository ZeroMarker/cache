Class User.DHCPAPregDelBaby Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = BABY_RowID, SqlTableName = DHC_PA_PregDelBaby, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On (BABYPregDr, BABYDelSub, BABYChildsub) [ IdKey, PrimaryKey, Unique ];

/// BABY_Preg_Dr
Property BABYPregDr As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = BABY_Preg_Dr ];

/// BABY_Del_Sub
Property BABYDelSub As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = BABY_Del_Sub ];

/// BABY_Childsub
Property BABYChildsub As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = BABY_Childsub ];

/// BABY_Status
Property BABYStatus As %Library.String(DISPLAYLIST = ",Delivery,Fed,Monitor,Cancel,Newborn", MAXLEN = 8, SELECTIVITY = "16.6667%", TRUNCATE = 1, VALUELIST = ",D,F,M,C,N") [ SqlColumnNumber = 5, SqlFieldName = BABY_Status ];

/// BABY_MembraneRuptureMode
Property BABYMembraneRuptureMode As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = BABY_MembraneRuptureMode ];

/// BABY_CordWeekNum
Property BABYCordWeekNum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = BABY_CordWeekNum ];

/// BABY_CordRoundNeckLoose
Property BABYCordRoundNeckLoose As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = BABY_CordRoundNeckLoose ];

/// BABY_CaputDetail
Property BABYCaputDetail As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = BABY_CaputDetail ];

/// BABY_AnomalCompl
Property BABYAnomalCompl As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = BABY_AnomalCompl ];

/// BABY_CordDrug
Property BABYCordDrug As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = BABY_CordDrug ];

/// BABY_PrintFlag
Property BABYPrintFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 12, SqlFieldName = BABY_PrintFlag ];

/// BABY_Placenta_dr
Property BABYPlacentadr As User.PAPregDelPlacenta [ SqlColumnNumber = 13, SqlFieldName = BABY_Placenta_dr ];

/// BABY_ScreenDate
Property BABYScreenDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 14, SqlFieldName = BABY_ScreenDate ];

/// BABY_ScreenTime
Property BABYScreenTime As %Library.Time [ SqlColumnNumber = 15, SqlFieldName = BABY_ScreenTime ];

/// BABY_BinauralFlag
Property BABYBinauralFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 16, SqlFieldName = BABY_BinauralFlag ];

/// BABY_LeftEarFlag
Property BABYLeftEarFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 17, SqlFieldName = BABY_LeftEarFlag ];

/// BABY_RightEarFlag
Property BABYRightEarFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 18, SqlFieldName = BABY_RightEarFlag ];

/// BABY_ScreenDoc
Property BABYScreenDoc As %Library.String [ SqlColumnNumber = 19, SqlFieldName = BABY_ScreenDoc ];

/// BABY_DiseaseScreenDate
Property BABYDiseaseScreenDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 20, SqlFieldName = BABY_DiseaseScreenDate ];

/// BABY_DiseaseScreenTime
Property BABYDiseaseScreenTime As %Library.Time [ SqlColumnNumber = 21, SqlFieldName = BABY_DiseaseScreenTime ];

/// BABY_DiseaseScreenDoc
Property BABYDiseaseScreenDoc As %Library.String [ SqlColumnNumber = 22, SqlFieldName = BABY_DiseaseScreenDoc ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterMap">
<Data name="BABY_AnomalCompl">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>6</Piece>
</Data>
<Data name="BABY_BinauralFlag">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>12</Piece>
</Data>
<Data name="BABY_CaputDetail">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>5</Piece>
</Data>
<Data name="BABY_CordDrug">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>7</Piece>
</Data>
<Data name="BABY_CordRoundNeckLoose">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>4</Piece>
</Data>
<Data name="BABY_CordWeekNum">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>3</Piece>
</Data>
<Data name="BABY_DiseaseScreenDate">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>16</Piece>
</Data>
<Data name="BABY_DiseaseScreenDoc">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>18</Piece>
</Data>
<Data name="BABY_DiseaseScreenTime">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>17</Piece>
</Data>
<Data name="BABY_LeftEarFlag">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>13</Piece>
</Data>
<Data name="BABY_MembraneRuptureMode">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>2</Piece>
</Data>
<Data name="BABY_Placenta_dr">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>9</Piece>
</Data>
<Data name="BABY_PrintFlag">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>8</Piece>
</Data>
<Data name="BABY_RightEarFlag">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>14</Piece>
</Data>
<Data name="BABY_ScreenDate">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>10</Piece>
</Data>
<Data name="BABY_ScreenDoc">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>15</Piece>
</Data>
<Data name="BABY_ScreenTime">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>11</Piece>
</Data>
<Data name="BABY_Status">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>1</Piece>
</Data>
<Global>^PAPRG</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>BABY_Preg_Dr</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>BABY_Del_Sub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>BABY_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{BABY_Preg_Dr}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"DEL"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{BABY_Del_Sub}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>"BABY"</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{BABY_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPlacetadr">
<Global>^PAPRGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>BABY_Preg_Dr</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>BABY_Del_Sub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>BABY_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"BABY_Placenta_dr"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{BABY_Placenta_dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BABY_Preg_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DEL"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{BABY_Del_Sub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>"BABY"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{BABY_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPAPregDelBabyS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
