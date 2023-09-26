/// DHC_ICU_ParaItem
Class User.DHCICUParaItem Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ICUPI_RowId, SqlTableName = DHC_ICU_ParaItem, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On ICUPIChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_ICU_Para Parent Reference
Relationship ICUPIParref As User.DHCICUPara [ Cardinality = parent, Inverse = ChildDHCICUParaItem, Required, SqlFieldName = ICUPI_Parref ];

Relationship ChildDHCICUParaItemDetail As User.DHCICUParaItemDetail [ Cardinality = children, Inverse = ICUPIDParref ];

/// ICUPI_ChildSub
/// For P5 ///Property ICUPIChildSub As %Numeric [ InitialExpression = {$i(^DHCICUPara($p($s($d(p1):p1,1:%d(0)),$c(1),1),"I",0))}, Required, SqlColumnNumber = 2, SqlFieldName = ICUPI_ChildSub ];
Property ICUPIChildSub As %Numeric [ InitialExpression = {$i(^DHCICUPara($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"I",0))}, Required, SqlColumnNumber = 2, SqlFieldName = ICUPI_ChildSub ];

/// ICUPI_Type
Property ICUPIType As %Library.String(DISPLAYLIST = ",Drug,VitalSign,Event,Therapy,Lab", MAXLEN = 9, SELECTIVITY = "16.6667%", TRUNCATE = 1, VALUELIST = ",D,V,E,T,L") [ SqlColumnNumber = 3, SqlFieldName = ICUPI_Type ];

/// ICUPI_ViewSuperCat_Dr
Property ICUPIViewSuperCatDr As User.DHCICUCViewSuperCat [ SqlColumnNumber = 4, SqlFieldName = ICUPI_ViewSuperCat_Dr ];

/// ICUPI_Oeore_Dr
Property ICUPIOeoreDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = ICUPI_Oeore_Dr ];

/// ICUPI_ComOrd_Dr
Property ICUPIComOrdDr As User.DHCICUCRecordItem [ SqlColumnNumber = 6, SqlFieldName = ICUPI_ComOrd_Dr ];

/// ICUPI_Flag
Property ICUPIFlag As %Library.String(DISPLAYLIST = ",Display,Hide,Uncollect", MAXLEN = 9, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",D,H,U") [ SqlColumnNumber = 7, SqlFieldName = ICUPI_Flag ];

/// ICUPI_Source
Property ICUPISource As %Library.String(DISPLAYLIST = ",Instrument,Manual", MAXLEN = 10, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",I,M") [ SqlColumnNumber = 8, SqlFieldName = ICUPI_Source ];

/// ICUPI_Icon_Dr
Property ICUPIIconDr As User.DHCANCIcon [ SqlColumnNumber = 9, SqlFieldName = ICUPI_Icon_Dr ];

/// ICUPI_SeqNo
Property ICUPISeqNo As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = ICUPI_SeqNo ];

/// ICUPI_Color
Property ICUPIColor As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = ICUPI_Color ];

/// ICUPI_Scale_Dr
Property ICUPIScaleDr As User.DHCANCScale [ SqlColumnNumber = 12, SqlFieldName = ICUPI_Scale_Dr ];

/// ICUPI_ViewCat_Dr
Property ICUPIViewCatDr As User.DHCICUCViewCat [ SqlColumnNumber = 13, SqlFieldName = ICUPI_ViewCat_Dr ];

/// ICUPI_Uom_Dr
Property ICUPIUomDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = ICUPI_Uom_Dr ];

Property ICUPICode As %String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = ICUPI_Code ];

Property ICUPIDesc As %String(COLLATION = "Exact", MAXLEN = 2000, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = ICUPI_Desc ];

Property ICUPIStartDate As %Date [ SqlColumnNumber = 17, SqlFieldName = ICUPI_StartDate ];

Property ICUPIStartTime As %Time [ SqlColumnNumber = 18, SqlFieldName = ICUPI_StartTime ];

Property ICUPIEndDate As %Date [ SqlColumnNumber = 19, SqlFieldName = ICUPI_EndDate ];

Property ICUPIEndTime As %Time [ SqlColumnNumber = 20, SqlFieldName = ICUPI_EndTime ];

Property ICUPIICUPIDr As User.DHCICUParaItem [ SqlColumnNumber = 21, SqlFieldName = ICUPI_ICUPI_Dr ];

Property ICUPIIsActive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 22, SqlFieldName = ICUPI_IsActive ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="ICUPI_Code">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="ICUPI_Color">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ICUPI_ComOrd_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ICUPI_Desc">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="ICUPI_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="ICUPI_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="ICUPI_Flag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ICUPI_ICUPI_Dr">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="ICUPI_Icon_Dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ICUPI_IsActive">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="ICUPI_Oeore_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ICUPI_Scale_Dr">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ICUPI_SeqNo">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ICUPI_Source">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ICUPI_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="ICUPI_StartTime">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="ICUPI_Type">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ICUPI_Uom_Dr">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ICUPI_ViewCat_Dr">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ICUPI_ViewSuperCat_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCICUPara</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_ICU_Para.ICUP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>ICUPI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DHC_ICU_Para.ICUP_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ICUPI_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCICUParaItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
