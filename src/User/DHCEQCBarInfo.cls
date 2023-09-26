Class User.DHCEQCBarInfo Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = BI_RowID, SqlTableName = DHC_EQCBarInfo, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// BI_ActiveFlag
Property BIActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 26, SqlFieldName = BI_ActiveFlag ];

/// BI_BarHeight
Property BIBarHeight As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = BI_BarHeight ];

/// BI_BarMark
Property BIBarMark As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = BI_BarMark ];

/// BI_BarLine
Property BIBarLine As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = BI_BarLine ];

/// BI_BarPosX
Property BIBarPosX As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = BI_BarPosX ];

/// BI_BarPosY
Property BIBarPosY As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = BI_BarPosY ];

/// BI_BarStyle
Property BIBarStyle As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = BI_BarStyle ];

/// BI_BarWidth
Property BIBarWidth As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = BI_BarWidth ];

/// BI_BorderStyle
Property BIBorderStyle As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = BI_BorderStyle ];

/// BI_BorderX
Property BIBorderX As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = BI_BorderX ];

/// BI_BorderY
Property BIBorderY As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = BI_BorderY ];

/// BI_CapationCellWidth
Property BICapationCellWidth As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = BI_CapationCellWidth ];

/// BI_ColWidth
Property BIColWidth As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = BI_ColWidth ];

/// BI_CorrectLevel
Property BICorrectLevel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = BI_CorrectLevel ];

/// BI_Desc
Property BIDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = BI_Desc ];

/// BI_FontBold
Property BIFontBold As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 15, SqlFieldName = BI_FontBold ];

/// BI_FontName
Property BIFontName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = BI_FontName ];

/// BI_FontSize
Property BIFontSize As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = BI_FontSize ];

/// BI_Hold1
Property BIHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 34, SqlFieldName = BI_Hold1 ];

/// BI_Hold2
Property BIHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 35, SqlFieldName = BI_Hold2 ];

/// BI_Hold3
Property BIHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 36, SqlFieldName = BI_Hold3 ];

/// BI_Hold4
Property BIHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 37, SqlFieldName = BI_Hold4 ];

/// BI_Hold5
Property BIHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 38, SqlFieldName = BI_Hold5 ];

/// BI_InvalidFlag
Property BIInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 29, SqlFieldName = BI_InvalidFlag ];

/// BI_Left
Property BILeft As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = BI_Left ];

/// BI_Line
Property BILine As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = BI_Line ];

/// BI_LineB
Property BILineB As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = BI_LineB ];

/// BI_LineHeigh
Property BILineHeigh As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = BI_LineHeigh ];

/// BI_LineOffset
Property BILineOffset As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = BI_LineOffset ];

/// BI_OffsetX
Property BIOffsetX As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = BI_OffsetX ];

/// BI_PrtName
Property BIPrtName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = BI_PrtName ];

/// BI_Style
Property BIStyle As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = BI_Style ];

/// BI_Top
Property BITop As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = BI_Top ];

/// BI_UpdateDate
Property BIUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 31, SqlFieldName = BI_UpdateDate ];

/// BI_UpdateTime
Property BIUpdateTime As %Library.Time [ SqlColumnNumber = 32, SqlFieldName = BI_UpdateTime ];

/// BI_UpdateUserDR
Property BIUpdateUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = BI_UpdateUserDR ];

/// BI_WordCount
Property BIWordCount As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 33, SqlFieldName = BI_WordCount ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCBarInfo",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="BI_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="BI_BarHeight">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="BI_BarLine">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="BI_BarMark">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="BI_BarPosX">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="BI_BarPosY">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="BI_BarStyle">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="BI_BarWidth">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="BI_BorderStyle">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="BI_BorderX">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="BI_BorderY">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="BI_CapationCellWidth">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="BI_ColWidth">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="BI_CorrectLevel">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="BI_Desc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="BI_FontBold">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="BI_FontName">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="BI_FontSize">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="BI_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="BI_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="BI_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="BI_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="BI_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="BI_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="BI_Left">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="BI_Line">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="BI_LineB">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="BI_LineHeigh">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="BI_LineOffset">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="BI_OffsetX">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="BI_PrtName">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="BI_Style">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="BI_Top">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="BI_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="BI_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="BI_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="BI_WordCount">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>BI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCBarInfo"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{BI_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexActive">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>BI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCBarInfo"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Active"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{BI_ActiveFlag}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{BI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexBarStyle">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>BI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCBarInfo"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"BarStyle"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{BI_BarStyle}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{BI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCBarInfoS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
