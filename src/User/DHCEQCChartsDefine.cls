Class User.DHCEQCChartsDefine Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = CD_RowID, SqlTableName = DHC_EQCChartsDefine, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// CD_Code
Property CDCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = CD_Code ];

/// CD_Desc
Property CDDesc As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = CD_Desc ];

/// CD_Remark
Property CDRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = CD_Remark ];

/// CD_Detail
Property CDDetail As %Library.String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = CD_Detail ];

/// CD_WebCls
Property CDWebCls As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = CD_WebCls ];

/// CD_QueryMethod
Property CDQueryMethod As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = CD_QueryMethod ];

/// CD_SeriesType
Property CDSeriesType As %Library.String(DISPLAYLIST = ",line,bar,pie,eqblock,eqgrid,progress", MAXLEN = 30, SELECTIVITY = "14.2857%", TRUNCATE = 1, VALUELIST = ",line,bar,pie,eqblock,eqgrid,progress") [ SqlColumnNumber = 8, SqlFieldName = CD_SeriesType ];

/// CD_SeriesName
Property CDSeriesName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = CD_SeriesName ];

/// CD_SeriesRadius
Property CDSeriesRadius As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = CD_SeriesRadius ];

/// CD_SeriesCenter
Property CDSeriesCenter As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = CD_SeriesCenter ];

/// CD_SeriesRoseType
Property CDSeriesRoseType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = CD_SeriesRoseType ];

/// CD_SeriesAreaStyle
Property CDSeriesAreaStyle As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = CD_SeriesAreaStyle ];

/// CD_SeriesSelected
Property CDSeriesSelected As %Library.String(DISPLAYLIST = ",max,min", MAXLEN = 30, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",0,1") [ SqlColumnNumber = 14, SqlFieldName = CD_SeriesSelected ];

/// CD_SeriesLabelShow
Property CDSeriesLabelShow As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 15, SqlFieldName = CD_SeriesLabelShow ];

/// CD_SeriesLabelPosition
Property CDSeriesLabelPosition As %Library.String(DISPLAYLIST = ",top,bottom,left,right,inside,insideRight,insideLeft,insidetop,insidebottom", MAXLEN = 30, SELECTIVITY = "10.0000%", TRUNCATE = 1, VALUELIST = ",top,bottom,left,right,inside,insideRight,insideLeft,insideTop,insideBottom") [ SqlColumnNumber = 16, SqlFieldName = CD_SeriesLabelPosition ];

/// CD_SeriesStack
Property CDSeriesStack As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = CD_SeriesStack ];

/// CD_SeriesMarkPoint
Property CDSeriesMarkPoint As %Library.String(DISPLAYLIST = ",max,min,maxmin", MAXLEN = 30, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2") [ SqlColumnNumber = 18, SqlFieldName = CD_SeriesMarkPoint ];

/// CD_SeriesMarkLineType
Property CDSeriesMarkLineType As %Library.String(DISPLAYLIST = ",max,min,maxmin,average,all", MAXLEN = 30, SELECTIVITY = "16.6667%", TRUNCATE = 1, VALUELIST = ",0,1,2,3,4") [ SqlColumnNumber = 19, SqlFieldName = CD_SeriesMarkLineType ];

/// CD_SeriesMarkLine
Property CDSeriesMarkLine As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = CD_SeriesMarkLine ];

/// CD_SubText
Property CDSubText As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = CD_SubText ];

/// CD_SubTextFont
Property CDSubTextFont As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = CD_SubTextFont ];

/// CD_SubTextColor
Property CDSubTextColor As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = CD_SubTextColor ];

/// CD_SubTextSize
Property CDSubTextSize As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = CD_SubTextSize ];

/// CD_SubTextBold
Property CDSubTextBold As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 25, SqlFieldName = CD_SubTextBold ];

/// CD_SubTextPosition
Property CDSubTextPosition As %Library.String(DISPLAYLIST = ",left,center,right", MAXLEN = 30, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",left,center,right") [ SqlColumnNumber = 26, SqlFieldName = CD_SubTextPosition ];

/// CD_LegendData
Property CDLegendData As %Library.String(COLLATION = "Exact", MAXLEN = 120, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = CD_LegendData ];

/// CD_LegendType
Property CDLegendType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = CD_LegendType ];

/// CD_LegentX
Property CDLegentX As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = CD_LegentX ];

/// CD_LegentY
Property CDLegentY As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = CD_LegentY ];

/// CD_XYMainFlag
Property CDXYMainFlag As %Library.String(DISPLAYLIST = ",X,Y", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",X,Y") [ SqlColumnNumber = 31, SqlFieldName = CD_XYMainFlag ];

/// CD_Hold1
Property CDHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 32, SqlFieldName = CD_Hold1 ];

/// CD_Hold2
Property CDHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 33, SqlFieldName = CD_Hold2 ];

/// CD_Hold3
Property CDHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 34, SqlFieldName = CD_Hold3 ];

/// CD_Hold4
Property CDHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 35, SqlFieldName = CD_Hold4 ];

/// CD_Hold5
Property CDHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 36, SqlFieldName = CD_Hold5 ];

/// CD_XAxisType
Property CDXAxisType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 37, SqlFieldName = CD_XAxisType ];

/// CD_YAxisType
Property CDYAxisType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 38, SqlFieldName = CD_YAxisType ];

/// CD_LegendDesc
Property CDLegendDesc As %Library.String(COLLATION = "Exact", MAXLEN = 120, TRUNCATE = 0) [ SqlColumnNumber = 39, SqlFieldName = CD_LegendDesc ];

/// CD_XYName
Property CDXYName As %Library.String(COLLATION = "Exact", MAXLEN = 120, TRUNCATE = 0) [ SqlColumnNumber = 40, SqlFieldName = CD_XYName ];

/// CD_XYDesc
Property CDXYDesc As %Library.String(COLLATION = "Exact", MAXLEN = 120, TRUNCATE = 0) [ SqlColumnNumber = 41, SqlFieldName = CD_XYDesc ];

/// CD_LegendShow
Property CDLegendShow As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 42, SqlFieldName = CD_LegendShow ];

/// CD_ToolTipShow
Property CDToolTipShow As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 43, SqlFieldName = CD_ToolTipShow ];

/// CD_CircleData
Property CDCircleData As %Library.String(COLLATION = "Exact", MAXLEN = 120, TRUNCATE = 0) [ SqlColumnNumber = 44, SqlFieldName = CD_CircleData ];

/// CD_SortFlag
Property CDSortFlag As %Library.String(DISPLAYLIST = ",asc,desc", MAXLEN = 30, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",asc,desc") [ SqlColumnNumber = 45, SqlFieldName = CD_SortFlag ];

/// CD_TopNum
Property CDTopNum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 46, SqlFieldName = CD_TopNum ];

/// CD_SeriesSubName
Property CDSeriesSubName As %Library.String(COLLATION = "Exact", MAXLEN = 120, TRUNCATE = 0) [ SqlColumnNumber = 47, SqlFieldName = CD_SeriesSubName ];

/// CD_LegendTextColor
Property CDLegendTextColor As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 48, SqlFieldName = CD_LegendTextColor ];

/// CD_XTextColor
Property CDXTextColor As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 49, SqlFieldName = CD_XTextColor ];

/// CD_YTextColor
Property CDYTextColor As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 50, SqlFieldName = CD_YTextColor ];

/// CD_XYFilterName
Property CDXYFilterName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 51, SqlFieldName = CD_XYFilterName ];

/// CD_LFilterName
Property CDLFilterName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 52, SqlFieldName = CD_LFilterName ];

/// CD_DWebCls
Property CDDWebCls As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 53, SqlFieldName = CD_DWebCls ];

/// CD_DQueryMethod
Property CDDQueryMethod As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 54, SqlFieldName = CD_DQueryMethod ];

/// CD_Function
Property CDFunction As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 55, SqlFieldName = CD_Function ];

/// CD_DetailShowCol
Property CDDetailShowCol As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 56, SqlFieldName = CD_DetailShowCol ];

/// CD_LegendDataValue
Property CDLegendDataValue As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 57, SqlFieldName = CD_LegendDataValue ];

/// CD_DataZoom
Property CDDataZoom As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 58, SqlFieldName = CD_DataZoom ];

/// CD_SLBarColorDiff
Property CDSLBarColorDiff As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 59, SqlFieldName = CD_SLBarColorDiff ];

/// CD_LegendOrient
Property CDLegendOrient As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 60, SqlFieldName = CD_LegendOrient ];

/// CD_LegendSize
Property CDLegendSize As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 61, SqlFieldName = CD_LegendSize ];

/// CD_LinearGradient
Property CDLinearGradient As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 62, SqlFieldName = CD_LinearGradient ];

/// CD_Grid
Property CDGrid As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 63, SqlFieldName = CD_Grid ];

/// CD_XAxisLine
Property CDXAxisLine As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 64, SqlFieldName = CD_XAxisLine ];

/// CD_XAxisLabelFlag
Property CDXAxisLabelFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 65, SqlFieldName = CD_XAxisLabelFlag ];

/// CD_XAxisTick
Property CDXAxisTick As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 66, SqlFieldName = CD_XAxisTick ];

/// CD_XSplitLine
Property CDXSplitLine As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 67, SqlFieldName = CD_XSplitLine ];

/// CD_XSplitArea
Property CDXSplitArea As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 68, SqlFieldName = CD_XSplitArea ];

/// CD_YAxisLine
Property CDYAxisLine As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 69, SqlFieldName = CD_YAxisLine ];

/// CD_YAxisLabelFlag
Property CDYAxisLabelFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 70, SqlFieldName = CD_YAxisLabelFlag ];

/// CD_YAxisTick
Property CDYAxisTick As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 71, SqlFieldName = CD_YAxisTick ];

/// CD_YSplitLine
Property CDYSplitLine As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 72, SqlFieldName = CD_YSplitLine ];

/// CD_XAxisLabelRotate
Property CDXAxisLabelRotate As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 73, SqlFieldName = CD_XAxisLabelRotate ];

/// CD_PosShowType
Property CDPosShowType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 74, SqlFieldName = CD_PosShowType ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCChartsDefine",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="CD_CircleData">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="CD_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CD_DQueryMethod">
<Delimiter>"^"</Delimiter>
<Piece>53</Piece>
</Data>
<Data name="CD_DWebCls">
<Delimiter>"^"</Delimiter>
<Piece>52</Piece>
</Data>
<Data name="CD_DataZoom">
<Delimiter>"^"</Delimiter>
<Piece>57</Piece>
</Data>
<Data name="CD_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CD_Detail">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CD_DetailShowCol">
<Delimiter>"^"</Delimiter>
<Piece>55</Piece>
</Data>
<Data name="CD_Function">
<Delimiter>"^"</Delimiter>
<Piece>54</Piece>
</Data>
<Data name="CD_Grid">
<Delimiter>"^"</Delimiter>
<Piece>62</Piece>
</Data>
<Data name="CD_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="CD_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="CD_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="CD_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="CD_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="CD_LFilterName">
<Delimiter>"^"</Delimiter>
<Piece>51</Piece>
</Data>
<Data name="CD_LegendData">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="CD_LegendDataValue">
<Delimiter>"^"</Delimiter>
<Piece>56</Piece>
</Data>
<Data name="CD_LegendDesc">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="CD_LegendOrient">
<Delimiter>"^"</Delimiter>
<Piece>59</Piece>
</Data>
<Data name="CD_LegendShow">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="CD_LegendSize">
<Delimiter>"^"</Delimiter>
<Piece>60</Piece>
</Data>
<Data name="CD_LegendTextColor">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="CD_LegendType">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="CD_LegentX">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="CD_LegentY">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="CD_LinearGradient">
<Delimiter>"^"</Delimiter>
<Piece>61</Piece>
</Data>
<Data name="CD_PosShowType">
<Delimiter>"^"</Delimiter>
<Piece>73</Piece>
</Data>
<Data name="CD_QueryMethod">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CD_Remark">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CD_SLBarColorDiff">
<Delimiter>"^"</Delimiter>
<Piece>58</Piece>
</Data>
<Data name="CD_SeriesAreaStyle">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="CD_SeriesCenter">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="CD_SeriesLabelPosition">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="CD_SeriesLabelShow">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="CD_SeriesMarkLine">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="CD_SeriesMarkLineType">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="CD_SeriesMarkPoint">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="CD_SeriesName">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CD_SeriesRadius">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CD_SeriesRoseType">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="CD_SeriesSelected">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="CD_SeriesStack">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="CD_SeriesSubName">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="CD_SeriesType">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CD_SortFlag">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="CD_SubText">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="CD_SubTextBold">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="CD_SubTextColor">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="CD_SubTextFont">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="CD_SubTextPosition">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="CD_SubTextSize">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="CD_ToolTipShow">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="CD_TopNum">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="CD_WebCls">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CD_XAxisLabelFlag">
<Delimiter>"^"</Delimiter>
<Piece>64</Piece>
</Data>
<Data name="CD_XAxisLabelRotate">
<Delimiter>"^"</Delimiter>
<Piece>72</Piece>
</Data>
<Data name="CD_XAxisLine">
<Delimiter>"^"</Delimiter>
<Piece>63</Piece>
</Data>
<Data name="CD_XAxisTick">
<Delimiter>"^"</Delimiter>
<Piece>65</Piece>
</Data>
<Data name="CD_XAxisType">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="CD_XSplitArea">
<Delimiter>"^"</Delimiter>
<Piece>67</Piece>
</Data>
<Data name="CD_XSplitLine">
<Delimiter>"^"</Delimiter>
<Piece>66</Piece>
</Data>
<Data name="CD_XTextColor">
<Delimiter>"^"</Delimiter>
<Piece>48</Piece>
</Data>
<Data name="CD_XYDesc">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="CD_XYFilterName">
<Delimiter>"^"</Delimiter>
<Piece>50</Piece>
</Data>
<Data name="CD_XYMainFlag">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="CD_XYName">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="CD_YAxisLabelFlag">
<Delimiter>"^"</Delimiter>
<Piece>69</Piece>
</Data>
<Data name="CD_YAxisLine">
<Delimiter>"^"</Delimiter>
<Piece>68</Piece>
</Data>
<Data name="CD_YAxisTick">
<Delimiter>"^"</Delimiter>
<Piece>70</Piece>
</Data>
<Data name="CD_YAxisType">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="CD_YSplitLine">
<Delimiter>"^"</Delimiter>
<Piece>71</Piece>
</Data>
<Data name="CD_YTextColor">
<Delimiter>"^"</Delimiter>
<Piece>49</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CD_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCChartsDefine"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{CD_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CD_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DHCEQCChartsDefine"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CD_Code}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CD_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCChartsDefineS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
