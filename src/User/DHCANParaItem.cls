/// DHC_AN_ParaItem
Class User.DHCANParaItem Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ANPI_RowId, SqlTableName = DHC_AN_ParaItem, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 80000;

Index RowIDBasedIDKeyIndex On ANPIChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_AN_Para Parent Reference
Relationship ANPIParref As User.DHCANPara [ Cardinality = parent, Inverse = ChildDHCANParaItem, Required, SqlFieldName = ANPI_Parref ];

//Property ANPIChildSub As %Library.Float [ InitialExpression = {$i(^DHCANPara($p($s($d(p1):p1,1:%d(0)),$c(1),1),"I",0))}, SqlColumnNumber = 2, SqlFieldName = ANPI_ChildSub ];

/// ANPI_ChildSub
/// For P8 ///Property ANPIChildSub As %Library.Float [ InitialExpression = {$i(^DHCANPara($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"I",0))}, SqlColumnNumber = 2, SqlFieldName = ANPI_ChildSub ];
Property ANPIChildSub As %Library.Float [ InitialExpression = {$i(^DHCANPara($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"I",0))}, SqlColumnNumber = 2, SqlFieldName = ANPI_ChildSub ];

/// ANPI_Type
Property ANPIType As %Library.String(DISPLAYLIST = ",Drug,VitalSign,Event,Therapy,Lab", MAXLEN = 9, SELECTIVITY = "16.6667%", TRUNCATE = 1, VALUELIST = ",D,V,E,T,L") [ SqlColumnNumber = 3, SqlFieldName = ANPI_Type ];

/// ANPI_ViewSuperCat_Dr
Property ANPIViewSuperCatDr As User.DHCANCViewSuperCat [ SqlColumnNumber = 4, SqlFieldName = ANPI_ViewSuperCat_Dr ];

/// ANPI_Arcim_Dr
Property ANPIArcimDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = ANPI_Arcim_Dr ];

/// ANPI_AnOrd_Dr
Property ANPIAnOrdDr As User.DHCANCCommonOrd [ SqlColumnNumber = 6, SqlFieldName = ANPI_AnOrd_Dr ];

/// ANPI_Flag
Property ANPIFlag As %Library.String(DISPLAYLIST = ",Display,Hide,Uncollect", MAXLEN = 9, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",D,H,U") [ SqlColumnNumber = 7, SqlFieldName = ANPI_Flag ];

/// ANPI_Source
Property ANPISource As %Library.String(DISPLAYLIST = ",Instrument,Manual", MAXLEN = 10, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",I,M") [ SqlColumnNumber = 8, SqlFieldName = ANPI_Source ];

/// ANPI_Icon_Dr
Property ANPIIconDr As User.DHCANCIcon [ SqlColumnNumber = 9, SqlFieldName = ANPI_Icon_Dr ];

/// ANPI_SeqNo
Property ANPISeqNo As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = ANPI_SeqNo ];

/// ANPI_Color
Property ANPIColor As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = ANPI_Color ];

/// ANPI_Scale_Dr
Property ANPIScaleDr As User.DHCANCScale [ SqlColumnNumber = 12, SqlFieldName = ANPI_Scale_Dr ];

/// ANPI_ViewCat_Dr
Property ANPIViewCatDr As User.DHCANCViewCat [ SqlColumnNumber = 13, SqlFieldName = ANPI_ViewCat_Dr ];

/// ANPI_Uom_Dr
Property ANPIUomDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = ANPI_Uom_Dr ];

Property ANPIDisplayName As %String(TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = ANPI_DisplayName ];

Property ANPITempType As %String [ SqlColumnNumber = 16, SqlFieldName = ANPI_TempType ];

Property ANPIInstrDr As %String [ SqlColumnNumber = 17, SqlFieldName = ANPI_Instr_Dr ];

Property ANPIConcentration As %Float [ SqlColumnNumber = 18, SqlFieldName = ANPI_Concentration ];

Property ANPIConcentrationUnitDr As %String [ SqlColumnNumber = 19, SqlFieldName = ANPI_ConcentrationUnit_Dr ];

Property ANPISpeed As %Float [ SqlColumnNumber = 20, SqlFieldName = ANPI_Speed ];

Property ANPISpeedUnitDr As %String [ SqlColumnNumber = 21, SqlFieldName = ANPI_SpeedUnit_Dr ];

Property ANPIDose As %Float [ SqlColumnNumber = 22, SqlFieldName = ANPI_Dose ];

Property ANPIDoseUomDr As %String [ SqlColumnNumber = 23, SqlFieldName = ANPI_DoseUom_Dr ];

Storage SQLStorage
{
<ExtentSize>80000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="ANPI_AnOrd_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ANPI_Arcim_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ANPI_Color">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ANPI_Concentration">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="ANPI_ConcentrationUnit_Dr">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="ANPI_DisplayName">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="ANPI_Dose">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="ANPI_DoseUom_Dr">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="ANPI_Flag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ANPI_Icon_Dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ANPI_Instr_Dr">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="ANPI_Scale_Dr">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ANPI_SeqNo">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ANPI_Source">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ANPI_Speed">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="ANPI_SpeedUnit_Dr">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="ANPI_TempType">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="ANPI_Type">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ANPI_Uom_Dr">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ANPI_ViewCat_Dr">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ANPI_ViewSuperCat_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCANPara</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_AN_Para.ANP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>ANPI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DHC_AN_Para.ANP_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ANPI_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCANParaItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
