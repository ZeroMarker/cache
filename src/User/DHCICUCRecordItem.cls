Class User.DHCICUCRecordItem Extends (%Persistent, %XML.Adaptor) [ Inheritance = right, Owner = {_SYSTEM}, SqlRowIdName = ICUCRI_RowId, SqlTableName = DHC_ICUC_RecordItem, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// ICUCRI_Code
Property ICUCRICode As %Library.String(COLLATION = "Exact", TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = ICUCRI_Code ];

/// ICUCRI_Desc
Property ICUCRIDesc As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ICUCRI_Desc ];

/// ICUCRI_Type
Property ICUCRIType As %Library.String(DISPLAYLIST = ",Drug,VitalSign,Event,Therapy,Lab", MAXLEN = 9, SELECTIVITY = "16.6667%", TRUNCATE = 1, VALUELIST = ",D,V,E,T,L") [ SqlColumnNumber = 4, SqlFieldName = ICUCRI_Type ];

/// ICUCRI_Arcim_Dr
Property ICUCRIArcimDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = ICUCRI_Arcim_Dr ];

/// ICUCRI_ViewCat_Dr
Property ICUCRIViewCatDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = ICUCRI_ViewCat_Dr ];

/// ICUCRI_Uom_Dr
Property ICUCRIUomDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = ICUCRI_Uom_Dr ];

/// ICUCRI_Icon_Dr
Property ICUCRIIconDr As User.DHCANCIcon [ SqlColumnNumber = 8, SqlFieldName = ICUCRI_Icon_Dr ];

/// ICUCRI_Color
Property ICUCRIColor As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = ICUCRI_Color ];

/// ICUCRI_SummaryICUCRI_Dr Old:ICUCRI_AnApply 血滤汇总项
Property ICUCRISummaryICUCRIDr As User.DHCICUCRecordItem [ SqlColumnNumber = 10, SqlFieldName = ICUCRI_SummaryICUCRI_Dr ];

/// ICUCRI_IcuApply
Property ICUCRIIcuApply As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = ICUCRI_IcuApply ];

/// ICUCRI_Options
Property ICUCRIOptions As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = ICUCRI_Options ];

/// ICUCRI_ICUCIOI_Dr
Property ICUCRIICUCIOIDr As User.DHCICUCIOItem [ SqlColumnNumber = 13, SqlFieldName = ICUCRI_ICUCIOI_Dr ];

/// ICUCRI_MultiValueDesc
Property ICUCRIMultiValueDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = ICUCRI_MultiValueDesc ];

/// ICUCRI_SortNo
Property ICUCRISortNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = ICUCRI_SortNo ];

/// ICUCRI_Arcos_Dr
Property ICUCRIArcosDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = ICUCRI_Arcos_Dr ];

Property ICUCRIDataType As %String(DISPLAYLIST = ",Numeric,String,Choice,MultipleChoice,Icon,Date,DateTime", VALUELIST = ",N,S,C,M,I,D,DT") [ SqlColumnNumber = 17, SqlFieldName = ICUCRI_DataType ];

Property ICUCRIIsContinue As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 18, SqlFieldName = ICUCRI_IsContinue ];

Property ICUCRIAnMethodDr As %String [ SqlColumnNumber = 19, SqlFieldName = ICUCRI_AnMethod_Dr ];

Property ICUCRIMax As %Float [ SqlColumnNumber = 20, SqlFieldName = ICUCRI_Max ];

Property ICUCRIMin As %Float [ SqlColumnNumber = 21, SqlFieldName = ICUCRI_Min ];

Property ICUCRIImpossibleMax As %Float [ SqlColumnNumber = 22, SqlFieldName = ICUCRI_ImpossibleMax ];

Property ICUCRIImpossibleMin As %Float [ SqlColumnNumber = 23, SqlFieldName = ICUCRI_ImpossibleMin ];

Property ICUCRIMainICUCRIDr As User.DHCICUCRecordItem [ SqlColumnNumber = 24, SqlFieldName = ICUCRI_MainICUCRI_Dr ];

Property ICUCRIDataField As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = ICUCRI_DataField ];

Property ICUCRIDataFormat As %String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = ICUCRI_DataFormat ];

Property ICUCRIFormat As %String [ SqlColumnNumber = 27, SqlFieldName = ICUCRI_Format ];

Property ICUCRIFormatField As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = ICUCRI_FormatField ];

Property ICUCRITemplateICUCRIDr As User.DHCICUCRecordItem [ SqlColumnNumber = 29, SqlFieldName = ICUCRI_TemplateICUCRI_Dr ];

Property ICUCRITemplateSubICUCRIDr As %String(MAXLEN = 100) [ SqlColumnNumber = 30, SqlFieldName = ICUCRI_TemplateSubICUCRI_Dr ];

Property ICUCRISumFormat As %String [ SqlColumnNumber = 31, SqlFieldName = ICUCRI_SumFormat ];

Property ICUCRISumFormatField As %String [ SqlColumnNumber = 32, SqlFieldName = ICUCRI_SumFormatField ];

Property ICUCRICriticalMax As %Float [ SqlColumnNumber = 33, SqlFieldName = ICUCRI_CriticalMax ];

Property ICUCRICriticalMin As %Float [ SqlColumnNumber = 34, SqlFieldName = ICUCRI_CriticalMin ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCICUC("RecordItem",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ICUCRI_AnMethod_Dr">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="ICUCRI_Arcim_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ICUCRI_Arcos_Dr">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="ICUCRI_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ICUCRI_Color">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ICUCRI_CriticalMax">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="ICUCRI_CriticalMin">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="ICUCRI_DataField">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="ICUCRI_DataFormat">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="ICUCRI_DataType">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="ICUCRI_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ICUCRI_Format">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="ICUCRI_FormatField">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="ICUCRI_ICUCIOI_Dr">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ICUCRI_Icon_Dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ICUCRI_IcuApply">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ICUCRI_ImpossibleMax">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="ICUCRI_ImpossibleMin">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="ICUCRI_IsContinue">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="ICUCRI_MainICUCRI_Dr">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="ICUCRI_Max">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="ICUCRI_Min">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="ICUCRI_MultiValueDesc">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="ICUCRI_Options">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ICUCRI_SortNo">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="ICUCRI_SumFormat">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="ICUCRI_SumFormatField">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="ICUCRI_SummaryICUCRI_Dr">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ICUCRI_TemplateICUCRI_Dr">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="ICUCRI_TemplateSubICUCRI_Dr">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="ICUCRI_Type">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ICUCRI_Uom_Dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ICUCRI_ViewCat_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCICUC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ICUCRI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"RecordItem"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ICUCRI_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCICUC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ICUCRI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"RecordItem"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ICUCRI_Code}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ICUCRI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypeCode">
<Global>^DHCICUC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>ICUCRI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"RecordItem"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"TypeCode"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ICUCRI_Type}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ICUCRI_Code}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ICUCRI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCICUCRecordItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
