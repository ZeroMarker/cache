Class User.DHCEQCBarDetail Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = BD_RowID, SqlTableName = DHC_EQCBarDetail, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// BD_BarInfoDR
Property BDBarInfoDR As User.DHCEQCBarInfo [ SqlColumnNumber = 2, SqlFieldName = BD_BarInfoDR ];

/// BD_Bold
Property BDBold As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = BD_Bold ];

/// BD_Caption
Property BDCaption As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = BD_Caption ];

/// BD_Characters
Property BDCharacters As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = BD_Characters ];

/// BD_CBold
Property BDCBold As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 17, SqlFieldName = BD_CBold ];

/// BD_CFontName
Property BDCFontName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = BD_CFontName ];

/// BD_CFontSize
Property BDCFontSize As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = BD_CFontSize ];

/// BD_ColNum
Property BDColNum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = BD_ColNum ];

/// BD_FontName
Property BDFontName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = BD_FontName ];

/// BD_FontSize
Property BDFontSize As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = BD_FontSize ];

/// BD_Format
Property BDFormat As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = BD_Format ];

/// BD_Hidden
Property BDHidden As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 21, SqlFieldName = BD_Hidden ];

/// BD_Hold1
Property BDHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = BD_Hold1 ];

/// BD_Hold2
Property BDHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = BD_Hold2 ];

/// BD_Hold3
Property BDHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = BD_Hold3 ];

/// BD_Hold4
Property BDHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = BD_Hold4 ];

/// BD_Hold5
Property BDHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = BD_Hold5 ];

/// BD_Key
Property BDKey As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = BD_Key ];

/// BD_Left
Property BDLeft As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = BD_Left ];

/// BD_Line
Property BDLine As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = BD_Line ];

/// BD_LineNum
Property BDLineNum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = BD_LineNum ];

/// BD_LineX
Property BDLineX As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = BD_LineX ];

/// BD_LineY
Property BDLineY As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = BD_LineY ];

/// BD_PrintLine
Property BDPrintLine As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 12, SqlFieldName = BD_PrintLine ];

/// BD_PrtCaption
Property BDPrtCaption As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = BD_PrtCaption ];

/// BD_Remark
Property BDRemark As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = BD_Remark ];

/// BD_Top
Property BDTop As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = BD_Top ];

/// BD_Type
Property BDType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = BD_Type ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCBarDetail",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="BD_BarInfoDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="BD_Bold">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="BD_CBold">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="BD_CFontName">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="BD_CFontSize">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="BD_Caption">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="BD_Characters">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="BD_ColNum">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="BD_FontName">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="BD_FontSize">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="BD_Format">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="BD_Hidden">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="BD_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="BD_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="BD_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="BD_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="BD_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="BD_Key">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="BD_Left">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="BD_Line">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="BD_LineNum">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="BD_LineX">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="BD_LineY">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="BD_PrintLine">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="BD_PrtCaption">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="BD_Remark">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="BD_Top">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="BD_Type">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>BD_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCBarDetail"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{BD_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexBarInfo">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L8}</Expression>
<Field>BD_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCBarDetail"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"BarInfo"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{BD_BarInfoDR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{BD_Type}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>+{BD_LineNum}</Expression>
</Subscript>
<Subscript name="7">
<AccessType>sub</AccessType>
<Expression>+{BD_ColNum}</Expression>
</Subscript>
<Subscript name="8">
<AccessType>sub</AccessType>
<Expression>{BD_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHC_EQCBarDetailS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
