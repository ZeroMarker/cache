/// DHC_ANC_CommonOrd
Class User.DHCANCCommonOrd Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ANCO_RowId, SqlTableName = DHC_ANC_CommonOrd, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// ANCO_Code
Property ANCOCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = ANCO_Code ];

/// ANCO_Desc
Property ANCODesc As %Library.String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ANCO_Desc ];

/// ANCO_Type
Property ANCOType As %Library.String(DISPLAYLIST = ",Drug,VitalSign,Event,Therapy,Lab", MAXLEN = 9, SELECTIVITY = "16.6667%", TRUNCATE = 1, VALUELIST = ",D,V,E,T,L") [ SqlColumnNumber = 4, SqlFieldName = ANCO_Type ];

/// ANCO_Arcim_Dr
Property ANCOArcimDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = ANCO_Arcim_Dr ];

/// ANCO_ViewCat_Dr
Property ANCOViewCatDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = ANCO_ViewCat_Dr ];

/// ANCO_Uom_Dr
Property ANCOUomDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = ANCO_Uom_Dr ];

/// ANCO_Icon_Dr
Property ANCOIconDr As User.DHCANCIcon [ SqlColumnNumber = 8, SqlFieldName = ANCO_Icon_Dr ];

/// ANCO_Color
Property ANCOColor As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = ANCO_Color ];

/// ANCO_AnApply
Property ANCOAnApply As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = ANCO_AnApply ];

/// ANCO_IcuApply
Property ANCOIcuApply As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = ANCO_IcuApply ];

/// ANCO_Options
Property ANCOOptions As %Library.String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = ANCO_Options ];

/// ANCO_ICUCIOI_Dr
Property ANCOICUCIOIDr As User.DHCICUCIOItem [ SqlColumnNumber = 13, SqlFieldName = ANCO_ICUCIOI_Dr ];

/// ANCO_MultiValueDesc
Property ANCOMultiValueDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = ANCO_MultiValueDesc ];

/// ANCO_SortNo
Property ANCOSortNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = ANCO_SortNo ];

/// ANCO_Arcos_Dr
Property ANCOArcosDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = ANCO_Arcos_Dr ];

Property ANCODataType As %String(DISPLAYLIST = ",Numeric,String,Choice,MultipleChoice,Icon,Date", VALUELIST = ",N,S,C,M,I,D") [ SqlColumnNumber = 17, SqlFieldName = ANCO_DataType ];

Property ANCOIsContinue As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 18, SqlFieldName = ANCO_IsContinue ];

Property ANCOAnMethodDr As %String [ SqlColumnNumber = 19, SqlFieldName = ANCO_AnMethod_Dr ];

Property ANCOMax As %Float [ SqlColumnNumber = 20, SqlFieldName = ANCO_Max ];

Property ANCOMin As %Float [ SqlColumnNumber = 21, SqlFieldName = ANCO_Min ];

Property ANCOImpossibleMax As %Float [ SqlColumnNumber = 22, SqlFieldName = ANCO_ImpossibleMax ];

Property ANCOImpossibleMin As %Float [ SqlColumnNumber = 23, SqlFieldName = ANCO_ImpossibleMin ];

Property ANCOMainAncoDr As DHCANCCommonOrd [ SqlColumnNumber = 24, SqlFieldName = ANCO_MainAnco_Dr ];

Property ANCODataField As %String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = ANCO_DataField ];

Property ANCODataFormat As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = ANCO_DataFormat ];

Property ANCOFormat As %String [ SqlColumnNumber = 27, SqlFieldName = ANCO_Format ];

Property ANCOFormatField As %String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = ANCO_FormatField ];

Property ANCOTemplateAncoDr As DHCANCCommonOrd [ SqlColumnNumber = 29, SqlFieldName = ANCO_TemplateAnco_Dr ];

Property ANCOTemplateSubAncoDr As %String(MAXLEN = 100) [ SqlColumnNumber = 30, SqlFieldName = ANCO_TemplateSubAnco_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCANC("ComOrd",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ANCO_AnApply">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ANCO_AnMethod_Dr">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="ANCO_Arcim_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ANCO_Arcos_Dr">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="ANCO_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ANCO_Color">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ANCO_DataField">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="ANCO_DataFormat">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="ANCO_DataType">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="ANCO_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ANCO_Format">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="ANCO_FormatField">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="ANCO_ICUCIOI_Dr">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ANCO_Icon_Dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ANCO_IcuApply">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ANCO_ImpossibleMax">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="ANCO_ImpossibleMin">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="ANCO_IsContinue">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="ANCO_MainAnco_Dr">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="ANCO_Max">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="ANCO_Min">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="ANCO_MultiValueDesc">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="ANCO_Options">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ANCO_SortNo">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="ANCO_TemplateAnco_Dr">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="ANCO_TemplateSubAnco_Dr">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="ANCO_Type">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ANCO_Uom_Dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ANCO_ViewCat_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCANC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ANCO_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ComOrd"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ANCO_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexTypeCode">
<Global>^DHCANC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>ANCO_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ComOrd"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"TypeCode"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ANCO_Type}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ANCO_Code}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ANCO_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCANCCommonOrdS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
