<%@ Language=VBScript %>
<%Option Explicit%>
<!-- Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. -->
<!-- LCID=3081 sets the regional settings to English(Australian)
as a temporary fix to the date format problems the VBScript seems
to produce.  -->

<%
Function RegKey(sKey)
	Dim Sh
	Set Sh = CreateObject("WScript.Shell")
	On Error Resume Next
	RegKey = 0
	ret = Sh.RegRead(sKey)
	If Err.Number = 0 Then
		RegKey = 1
	ElseIf CBool(Instr(Err.Description,"Unable")) Then
		RegKey = 1
	End If
	Err.Clear: On Error Goto 0
End Function

Dim ChartFXVer

if RegKey("HKEY_CLASSES_ROOT\ChartFX.ASP.Server\CurVer")=1 then
	ChartFXVer="6.2"
Else
	ChartFXVer="5.5"
End If
%>

<!-- #include virtual='/Include/CfxIE.inc' -->
<!-- #include virtual='/Include/CfxIEExtra.inc' -->


<html><head>
 <LINK REL="stylesheet" TYPE="text/css" HREF="../scripts/websys.css">
 </LINK>
<%
	' Log 54821 YC - Include custom stylesheet
	Dim stylesheet
	stylesheet=Request("stylesheet")
	If stylesheet<>"" Then Response.Write "<LINK REL=""stylesheet"" TYPE=""text/css"" HREF=""" & stylesheet & """></LINK>"
%>
</head>
<body>
<DIV id="eprPatientBannerSlot"></DIV>

<%

	Dim CacheFactory
	Dim sConn,rs
	Dim GraphChart					'Is main charting object.
	Dim PatientID,PatientName,MRAdm,MRAdmlist
	Dim YAxisIndex,YAxisNumber
	Dim ObsGrpID,LabResID,OrdProfileID
	Dim ObsGrpDesc,LabResDesc,OrdProfileDesc
	Dim GraphType,GraphHeight,GraphWidth
	Dim MarkerSize
	dim FromDateTime, ToDateTime 			'These are true date variables
	Dim MajorStep, MinorStep			'Step sizes on the time scale
	Dim TimeFormat,OriginTime
	Dim CACHE_PIVOT_DATE,CACHE_PIVOT_TIME
	Dim iSeriesCount,XAxisNoOfPoints
	Dim OKToGraph
	Dim LabItemCount,iSeriesForLegendNum,TestId,SeriesNumber
	Dim YAxes()	' to hold the items for each axis
	Dim YAxisMin(2)
	Dim YAxisMax(2)
	Dim YAxisStep(2)
	Dim iSeriesMax()  ' will hold the number of points in each series - so we can pad out the other series with hidden points
	Dim CumulativeItems
	Dim StdtypGraphType
	Dim GraphCode
	Dim Label

	'Constant declarations
	CACHE_PIVOT_DATE="31/12/1840"
	CACHE_PIVOT_TIME="0:00"

	'Initialise variable which should stop code execution when set to false
	OKToGraph = True
	Response.Write "<BR>"

	Call GetInterfaceData
	If OKToGraph Then ConnectToCacheServer
	If OKToGraph Then RetrieveAndValidateDates FromDateTime, ToDateTime

	If OKToGraph Then CreateChartFXObject
	If OKToGraph Then FormatTimeRange FromDateTime, ToDateTime, MajorStep, MinorStep
	If OKToGraph And GraphType<>"" Then GetStdtypGraphType GraphCode   'KK 23/3/05 L:46461
	If OKToGraph Then SetYAxisAttributes
	If OKToGraph Then OpenChartObjForData
	'If OKToGraph Then AssignHiLoChartData FromDateTime, ToDateTime, MinorStep
	If OKToGraph Then AssignChartData FromDateTime, ToDateTime, MinorStep
	' Log 46461 YC - Dancis Curve
	If OKTOGraph And StdtypGraphType="DC" And (Request("ShowRef")<>"") Then ShowDancisLines FromDateTime, ToDateTime
	If OKToGraph Then InitialiseChartValues
	If OKToGraph Then SetXAxisLabels FromDateTime, ToDateTime, MajorStep, MinorStep
	If OKToGraph Then CloseChartObjForData
	'If OKToGraph Then SetGraphColors
	Call DisplayGraph

	Sub GetInterfaceData
		'Get the input interface data
		PatientID=Request("PatientID")
		If PatientID="" Then
			Dim nopatientid
			nopatientid=Request("TNO_PATIENT_ID")
			If nopatientid="" Then nopatientid="ERROR: Patient ID not passed"
			Response.Write nopatientid & "<BR>"
		End If
		'Log 53370 YC - Gets current label units
		Label=Request("IntervalType")
		MRAdm=Request("mradm")
		MRAdmlist=Request("mradmlist")
		If MRAdmlist<>"" Then
			MRAdm=MRAdmlist
		End If
		If MRAdm="" Then
			Dim nomradm
			nomradm=Request("TNO_MRADM")
			If nomradm="" Then nomradm="ERROR: mradm not passed"
			Response.Write nomradm & "<BR>"
		End If
		GraphType=Request("Graph")
		' try and get it from the hidden field - used for ADHOC QUERIES
		If GraphType="" Then
			GraphType=Request("HiddenGraph")
		End If
		GraphCode=Request("GRPHCode")
		' lastly, try and get it from the cumulative items
		CumulativeItems = ""
		If GraphType="" Then
			CumulativeItems=Request("Selected")
		End If
		'If CumulativeItems<>"" Then
		'	CumulativeItems=CumulativeItems 'YC - whats the point of this?!
		'End If
		'Response.Write Request("Selected")
		If ((GraphType="") and (CumulativeItems="")) Then
			Dim nographtype
			nographtype=Request("TNO_GRAPH_TYPE")
			If nographtype="" Then nographtype="ERROR: Undefined Graph Type"
			Response.Write nographtype & "<BR>"
			OKToGraph = False
		End If
		sConn=Request("LayoutManager")
		If sConn = "" Then
			Dim noserver
			noserver=Request("TNO_SERVER")
			If noserver="" Then noserver="ERROR: No server details passed - Default Server has been set"
			Response.Write noserver & "<BR>"
			sConn = "cn_iptcp:128.230.0.22[1972]:W642DEV"
		End If
	End Sub

	Sub ConnectToCacheServer
		Set CacheFactory=server.CreateObject("CacheObject.Factory")
		If Not CacheFactory.Connect(sConn) Then
			Dim failedconnection
			failedconnection=Request("TFAILED_CONNECTION")
			If failedconnection="" Then failedconnection="Failed to connect to"
			Response.Write failedconnection & " " & sConn
		End If
	End Sub

	Sub RetrieveAndValidateDates( dateTimeFrom, dateTimeTo )
		'returns dateTime
		Dim DateFrom,DateTo,TimeFrom,TimeTo

		DateFrom=Request("DateFrom")
		DateTo=Request("DateTo")
		TimeFrom=Request("TimeFrom")
		TimeTo=Request("TimeTo")
		If TimeFrom="" Then TimeFrom=TimeValue("00:00")
		If TimeTo="" Then TimeTo=TimeValue("00:00")
		If Not TestDates(DateFrom,TimeFrom,DateTo,TimeTo,dateTimeFrom, dateTimeTo) then
			OKToGraph = False
		End If

	End Sub

	Sub CreateChartFXObject

		if ChartFXVer="6.2" then 
			Set GraphChart = Server.CreateObject("ChartFX.ASP.Server")
		else
			Set GraphChart = Server.CreateObject("ChartFX.WebServer")
		End If

	End Sub

Sub SetYAxisAttributes
	dim rs, rs2
	dim YAxis
	dim AxisNumber
	dim GraphCode
	dim SeqY1
	dim SeqY2
	dim Seq
	dim MaxSeq

	GraphCode = ""
	If ((GraphType="") and (CumulativeItems<>"")) Then
		' Graph ALL selected items defined for this cumulative graph profile
		'
		Dim GraphItemCount, GraphItemArr, GraphItem, GraphDescStr, GraphDescArr, GraphDesc
		GraphItemCount = 0
		GraphItemArr = Split(CumulativeItems, "^")
		GraphDescStr = Request("SelectedDesc")
		GraphDescArr = Split(GraphDescStr, "^")
		SeqY1 = 0
		SeqY2 = 0
		MaxSeq = 0
		iSeriesCount = 0 ' will hold the TOTAL number of items to be displayed
		For GraphItem = LBound(GraphItemArr) to UBound(GraphItemArr)
		  if GraphDescArr(GraphItem)<> "" Then
			iSeriesCount = iSeriesCount + 1
			if (((iSeriesCount + 1) mod 2) = 0) then
				AxisNumber = 1
				Seq = SeqY1
				SeqY1 = SeqY1 + 1
			else
				AxisNumber = 2
				Seq = SeqY2
				SeqY2 = SeqY2 + 1
			end if
			if Seq > Maxseq Then
				MaxSeq = Seq
			End If

			ReDim Preserve YAxes(2, 14, (MaxSeq + 1))
			YAxes(AxisNumber, 0, Seq) = "LB"
			YAxes(AxisNumber, 1, Seq) = GraphDescArr(GraphItem)
			YAxes(AxisNumber, 2, Seq) = Int((4) * Rnd)   'normlineValue
			YAxes(AxisNumber, 3, Seq) = Int((4) * Rnd)   'varlineValue
			YAxes(AxisNumber, 5, Seq) = Int((11) * Rnd)   'markerValue
			YAxes(AxisNumber, 9, Seq) = ""   ' don't require a DR for the lab - the search is done by code..
			YAxes(AxisNumber, 10, Seq) = GraphItemArr(GraphItem)
			YAxes(AxisNumber, 12, Seq) = 4
			' set random RGB colour values
			YAxes(AxisNumber, 4, Seq) = RGB(Int((256) * Rnd),Int((256) * Rnd),Int((256) * Rnd))
			YAxes(AxisNumber, 8, Seq) = RGB(Int((256) * Rnd),Int((256) * Rnd),Int((256) * Rnd))
			' NO max and min ref ranges
			YAxes(AxisNumber, 6, Seq) = ""
			YAxes(AxisNumber, 7, Seq) = ""
		  End If
		Next
	Else
		Set rs=CacheFactory.ResultSet("epr.CTGraphDefinition","GetGraphDetailsByCodeOrDesc")
		' Log 52339 YC - Adhoc graph with no description/code not displaying
		If Request("Graph")<>"" Then
			Call rs.Execute("", "", GraphType)
		Else
			Call rs.Execute("", GraphType, "") 'Adhoc Graph
		End If
		' END Log 52339 YC
		' SET THE BOUNDS
		' Get the first (and only) row
		If rs.Next() Then
			GraphCode = rs.GetdataByName("GRPHCode")
			'Response.Write "Type: " & GraphType & "<BR>Code:" & GraphCode
			if ChartFXVer="6.2" then
				Set YAxis=GraphChart.AxisY
			else
				Set YAxis=GraphChart.Axis(AXIS_Y)
			End If
			If rs.GetDataByName("GRPHY1AxisMin") <> "" Then YAxis.Min = rs.GetDataByName("GRPHY1AxisMin")
			If rs.GetDataByName("GRPHY1AxisMax") <> "" Then YAxis.Max = rs.GetDataByName("GRPHY1AxisMax")
			If rs.GetDataByName("GRPHY1AxisStep") <> "" Then YAxis.Step = rs.GetDataByName("GRPHY1AxisStep")
			'YAxis.Grid=TRUE
			'YAxis.GridColor=RGB(0,0,256)

			if ChartFXVer="6.2" then
				Set YAxis=GraphChart.AxisY2
			else
				Set YAxis=GraphChart.Axis(AXIS_Y2)
			End If
			If rs.GetDataByName("GRPHY2AxisMin") <> "" Then YAxis.Min = rs.GetDataByName("GRPHY2AxisMin")
			If rs.GetDataByName("GRPHY2AxisMax") <> "" Then YAxis.Max = rs.GetDataByName("GRPHY2AxisMax")
			If rs.GetDataByName("GRPHY2AxisStep") <> "" Then YAxis.Step = rs.GetDataByName("GRPHY2AxisStep")
			'YAxis.Grid=TRUE
			'YAxis.GridColor=RGB(256,0,0)

			'Log 53370 YC - Gives it the x axis interval type defined by the graph interval type is blank
			'A bit messy but we don't want to open the rs again later for the x axis.
			If Request("IntervalType")="" Then
				Dim IntTypeDef
				Set IntTypeDef=CacheFactory.Static("websys.StandardTypeItem")
				Label=IntTypeDef.GetExactDescription("GraphIntervalDisplay",rs.GetDataByName("GRPHXAxisIntervalType"))
 			End If

			' Log 46461 YC - Hard Code Dancis Axes
			If StdtypGraphType="DC" Then
				Dim babyweightgrams
				babyweightgrams=Request("TBABY_WEIGHT_GRAMS")
				If babyweightgrams="" Then babyweightgrams="Baby's Weight in Grams (g)"
				Dim babyweightpounds
				babyweightpounds=Request("TBABY_WEIGHT_POUNDS")
				If babyweightpounds="" Then babyweightpounds="Baby's Weight in Pounds (lb)"

				' Y1
				if ChartFXVer="6.2" then
					Set YAxis=GraphChart.AxisY
					YAxis.DataFormat.Decimals = 0
					YAxis.Title.Text = babyweightgrams
				else
					Set YAxis=GraphChart.Axis(AXIS_Y)
					YAxis.Decimals = 0
					YAxis.Title = babyweightgrams
				End If
				YAxis.Min = 500
				YAxis.Max = 3250
				YAxis.Step = 150
				
				' Y2
				if ChartFXVer="6.2" then
					Set YAxis=GraphChart.AxisY2
					YAxis.DataFormat.Decimals = 0
					YAxis.Title.Text = babyweightpounds
				else
					Set YAxis=GraphChart.Axis(AXIS_Y2)
					YAxis.Decimals = 1
					YAxis.Title = babyweightpounds
				End If
				YAxis.Min = 1.1
				YAxis.Max = 7.15
				YAxis.Step = 0.5
			End If

			' Get the graph ITEMS - put them on 'YAxes' as:
			' YAxes(axis, date row, item number)
			' YAxes(1, 0, 1)=axis Y1, item type, item number 1
			' YAxes(1, 0, 2)=axis Y1, item type, item number 2
			' YAxes(1, 1, 1)=axis Y1, item name, item number 1
			' YAxes(1, 1, 2)=axis Y1, item name, item number 2

			Set rs2=CacheFactory.ResultSet("epr.CTGraphDefinition","GetGraphItems")
			Call rs2.Execute(GraphCode)
			SeqY1 = 0
			SeqY2 = 0
			MaxSeq = 0
			iSeriesCount = 0 ' will hold the TOTAL number of items to be displayed

			Do While rs2.Next() and (rs2.GetDataByName("itmDR")<>"")
				If rs2.GetDataByName("ObsOnly") = "Y" Then
					'Do Nothing
				else
					if rs2.GetDataByName("YAxis") = "Y1" then
						AxisNumber = 1
						Seq = SeqY1
						SeqY1 = SeqY1 + 1
					else
						AxisNumber = 2
						Seq = SeqY2
						SeqY2 = SeqY2 + 1
					end if
					if Seq > Maxseq Then
						MaxSeq = Seq
					End If
					iSeriesCount = iSeriesCount + 1
					ReDim Preserve YAxes(2, 14, (MaxSeq + 1))
					YAxes(AxisNumber, 0, Seq) = rs2.GetDataByName("Type")
					YAxes(AxisNumber, 1, Seq) = rs2.GetDataByName("ItemName")
					YAxes(AxisNumber, 2, Seq) = CInt(rs2.GetDataByName("normlineValue"))
					YAxes(AxisNumber, 3, Seq) = CInt(rs2.GetDataByName("varlineValue"))
					if IsNumeric(rs2.GetDataByName("markerValue")) then
						YAxes(AxisNumber, 5, Seq) = CInt(rs2.GetDataByName("markerValue"))
					end if
					YAxes(AxisNumber, 9, Seq) = rs2.GetDataByName("itmDR")
					YAxes(AxisNumber, 10, Seq) = rs2.GetDataByName("itmCode")
					' Log 51350 YC - Ability to change marker size
					YAxes(AxisNumber, 12, Seq) = rs2.GetDataByName("MarkerSize")
					YAxes(AxisNumber, 13, Seq) = rs2.GetDataByName("lnkitmDR")
					' use the RGB colour values
					YAxes(AxisNumber, 4, Seq) = SetRGB(rs2.GetDataByName("RGBCol"))
					YAxes(AxisNumber, 8, Seq) = SetRGB(rs2.GetDataByName("RefRGBCol"))
					' if there are max and min ref ranges - they will be plotted as extra line series
					' do NOT show ref ranges if the link is off...
					YAxes(AxisNumber, 6, Seq) =  ""
					YAxes(AxisNumber, 7, Seq) =  ""
					YAxes(AxisNumber, 14, Seq) =  ""
					if (Request("ShowRef") = "on") then
						YAxes(AxisNumber, 6, Seq) = rs2.GetDataByName("UpRange")
						if YAxes(AxisNumber, 6, Seq) <> "" then
							iSeriesCount = iSeriesCount + 1
			 			end if
						YAxes(AxisNumber, 7, Seq) = rs2.GetDataByName("LowRange")
						if YAxes(AxisNumber, 7, Seq) <> "" then
							iSeriesCount = iSeriesCount + 1
						end if
						YAxes(AxisNumber, 14, Seq) = rs2.GetDataByName("NonLinearRefRanges")
						if YAxes(AxisNumber, 14, Seq) <> "" then
							dim refRanges
					    refRanges = split(YAxes(AxisNumber, 14, Seq),",")
							iSeriesCount = iSeriesCount + UBound(refRanges) + 1
						end if
					end if
				end if
			Loop
			rs2.Close
			If SeqY1 = 0 And SeqY2 = 0 Then 'No items on each y-axis
				OKToGraph = False
				Dim nographsetup
				nographsetup=Request("TNO_GRAPH_SETUP")
				If nographsetup="" Then nographsetup="No Axis information exists for this graph<BR>Please setup the graph via the epr setup tables"
				Response.Write nographsetup & "<BR>"
			End If
		Else
			Dim undefinedgraph
			undefinedgraph=Request("TUNDEFINED_GRAPH")
			If undefinedgraph="" Then undefinedgraph="Graph Selected is undefined"
			Response.Write undefinedgraph & "<BR>"
			OKToGraph = False
		End If 'graph type defined
		rs.Close
	End If  'cumulative items defined

	End Sub

	Function SetRGB(RGBString)
		dim ArrRGB
		ArrRGB = Split(RGBString, "^")
		if UBound(ArrRGB) > 2 then
			SetRGB = RGB(CInt(ArrRGB(0)), CInt(ArrRGB(1)), CInt(ArrRGB(2)))
		end if
	End Function

	Function GetStdtypGraphType(GraphCode)
		'GraphCode is unique
		Dim GraphDef
		Dim Graphid
		Dim objGraph
		StdtypGraphType=""
		If GraphType<>"" Then
			set GraphDef=CacheFactory.Static("epr.CTGraphDefinition")
			Graphid=GraphDef.GetIdFromCodeOrDescription(GraphType)
			If Graphid<>"" Then
				Set objGraph = CacheFactory.OpenId("epr.CTGraphDefinition",Graphid)
			End If
			If objGraph Then
				StdtypGraphType = objGraph.GRPHGraphType  'Get GraphType value from Standard Types
				objGraph.sys_close
			End If
			set objGraph=Nothing
		End If
	End Function

	Sub ShowDancisLines (StartDateTime,EndDateTime)  'KK 23/3/05 L:46461
		Dim i,j,x
		Dim Axis
		Dim k
		Dim Days
		Dim CurveData(8)
		Dim LineData
		CurveData(0)="750,725,700,675,650,625,600,595,580,570,560,555,551,550,558,562,565,570,580,590,600,612,624,636,648,660,672,684,696,708,720,732,744,756,768,780,792,804,816,828,840,852,864,876,888,900,912,924,936,948,960,972"
		CurveData(1)="1000,975,950,940,925,910,905,905,900,900,905,910,922,940,950,965,980,1000,1021.2,1042.4,1063.6,1084.8,1106,1127.2,1148.4,1169.6,1190.8,1212,1233.2,1254.4,1275.6,1296.8,1318,1339.2,1360.4,1381.6,1402.8,1424,1445.2,1466.4,1487.6,1508.8,1530,1551.2,1572.4,1593.6,1614.8,1636,1657.2,1678.4,1699.6"
		CurveData(2)="1250,1225,1195,1175,1160,1149,1150,1150,1150,1165,1180,1195,1210,1225,1240,1255,1278,1301,1324,1347,1370,1393,1416,1439,1462,1485,1508,1531,1554,1577,1600,1623,1646,1669,1692,1715,1738,1761,1784,1807,1830,1853,1876,1899,1922,1945,1968,1991,2014,2037,2060"
		CurveData(3)="1500,1475,1445,1420,1405,1400,1400,1400,1405,1410,1425,1440,1455,1480,1500,1525.9,1551.8,1577.7,1603.6,1629.5,1655.4,1681.3,1707.2,1733.1,1759,1784.9,1810.8,1836.7,1862.6,1888.5,1914.4,1940.3,1966.2,1992.1,2018,2043.9,2069.8,2095.7,2121.6,2147.5,2173.4,2199.3,2225.2,2251.1,2277,2302.9,2328.8,2354.7,2380.6,2406.5,2432.4"
		CurveData(4)="1750,1725,1690,1660,1635,1635,1640,1650,1670,1685,1710,1727,1749,1770,1805,1835,1865,1895,1925,1955,1985,2015,2045,2075,2105,2135,2165,2195,2225,2255,2285,2315,2345,2375,2405,2435,2465,2495,2525,2555,2585,2615,2645,2675,2705,2735,2765,2795,2825,2855,2885"
		CurveData(5)="2000,1950,1925,1900,1895,1895,1897.5,1905,1925,1950,1987,2020,2050,2075,2115,2150,2181,2212,2243,2274,2305,2336,2367,2398,2429,2460,2491,2522,2553,2584,2615,2646,2677,2708,2739,2770,2801,2832,2863,2894,2925,2956,2987,3018,3049,3080,3111,3142,3173,3204,3235"
		CurveData(6)="2250,2200,2150,2130,2110,2110,2115,2140,2160,2195,2248,2290,2330,2370,2410,2450,2490,2530,2570,2610,2650,2690,2730,2770,2810,2850,2890,2930,2970,3010,3050,3090,3130,3170,3210,3250,3350,3350,3350,3350,3350,3350,3350,3350,3350,3350,3350,3350,3350,3350,3350"
		CurveData(7)="2500,2450,2400,2380,2370,2375,2400,2450,2495,2535,2575,2620,2665,2710,2755,2800,2845,2890,2935,2980,3025,3070,3115,3160,3205,3250,3350,3350,3350,3350,3350,3350,3350,3350,3350,3350,3350,3350,3350,3350,3350,3350,3350,3350,3350,3350,3350,3350,3350,3350,3350"

		Days = DateDiff("d",StartDateTime, EndDateTime)+2
		Days = CInt(Days)
		If Days<=0 Then Days=1 ' default 50
		If Days>50 Then Days=51
		'GraphChart.OpenDataEX COD_VALUES,8,Days
		'GraphChart.OpenDataEX COD_XVALUES,8,Days
		if ChartFXVer="6.2" then
			GraphChart.OpenData COD_COLORS, iSeriesCount+8, 0		
		else
			GraphChart.OpenDataEx COD_COLORS, iSeriesCount+8, 0
		End If
		For i = 0 to 7
			LineData=""
			LineData = Split(CurveData(i),",")
			GraphChart.Series(i+iSeriesCount).LineStyle = YAxes(1, 3, 0)  'CHART_SOLID
			GraphChart.Series(i+iSeriesCount).MarkerShape = MK_NONE 'YAxes(1, 5, 0)
			GraphChart.Series(i+iSeriesCount).Color = YAxes(1, 8, 0)
			GraphChart.Series(i+iSeriesCount).Gallery = Curve
			For j = 0 to Days-1
				if j<=Ubound(LineData) Then
					'Log 46461 YC - Added CDbl so that LineData(j) is not interpreted as string
					'Fixes problem of decimal points being intepreted as a "thousand" separator in portugal
					GraphChart.Series(i+iSeriesCount).YValue(j) = CDbl(LineData(j))  'x + (j * 10)
					GraphChart.Series(i+iSeriesCount).XValue(j) = j*1440
					ReDim Preserve iSeriesMax(i+iSeriesCount+2)
					iSeriesMax(i+iSeriesCount)=Days  '-2
				End If
			Next

		Next
		iSeriesCount=iSeriesCount+8
		GraphChart.CloseData COD_COLORS
	End Sub

	Sub OpenChartObjForData
		'Open the communication channel
		Dim Count
		If StdtypGraphType="DC" Then
			Count=iSeriesCount+8
		Else
			Count=iSeriesCount
		End If
		if ChartFXVer="6.2" then
			GraphChart.OpenData COD_Values,CStr(Count), COD_Unknown	'XAxisNoOfPoints
			GraphChart.OpenData COD_XValues,CStr(Count),COD_Unknown	'XAxisNoOfPoints		
		else
			GraphChart.OpenDataEx COD_VALUES,CStr(Count), COD_UNKNOWN	'XAxisNoOfPoints
			GraphChart.OpenDataEx COD_XVALUES,CStr(Count),COD_UNKNOWN	'XAxisNoOfPoints
			'GraphChart.OpenDataEx COD_COLORS,CStr(Count), COD_UNKNOWN	'XAxisNoOfPoints
		End If
	End Sub

	Sub InitialiseChartValues
		'To initialise values for each point on the X-Axis. The default value
		'for points without associated values is 0. We need to clear these "0"
		'values rather than show them
		Dim SeriesIndex
		Dim PointIndex
		Dim MaxPoints
		MaxPoints = 0
		For SeriesIndex = 0 to CLng(iSeriesCount) - 1
			if iSeriesMax(SeriesIndex) > MaxPoints then
				MaxPoints = iSeriesMax(SeriesIndex)
			end if
		Next
		For SeriesIndex = 0 to CLng(iSeriesCount) - 1
		' Log 51350 YC - MarkerSize now defined as YAxes(YAxisIndex, 12, itemnum) further on
			'GraphChart.Series(SeriesIndex).MarkerSize = 4
			GraphChart.Series(SeriesIndex).LineWidth = 2
			'Response.Write(iSeriesMax(SeriesIndex)&","&cstr(MaxPoints)&" ")
			For PointIndex = iSeriesMax(SeriesIndex) to MaxPoints + 1000
				if ChartFXVer="6.2" then
					GraphChart.Value(SeriesIndex, PointIndex) = CHART_HIDDEN
				else
					GraphChart.ValueEx(SeriesIndex, PointIndex) = CHART_HIDDEN
				End If
			Next
		Next
	End Sub

	Sub AssignChartData ( DateTimeFrom, DateTimeTo, mMinorStep )
		Dim iSeriesNum
		Dim YAxisIndex
		dim CurrentItemDesc
		Dim itemnum
		Dim xDateTime
		Dim CacheDateFrom,CacheTimeFrom,CacheDateTo,CacheTimeTo

		'To get points exactly at the Start and End times, modify the Cache From and To times:
		xDateTime = DateAdd("s", -1, DateTimeFrom)	'StartTime -1 second
		CacheDateFrom = DatePut(DateValue(xDateTime))
		CacheTimeFrom = TimePut(TimeValue(xDateTime))
		xDateTime = DateAdd("s", 1, DateTimeTo)		'End Time + 1 second
		CacheDateTo = DatePut(DateValue(xDateTime))
		CacheTimeTo = TimePut(TimeValue(xDatetime))

		iSeriesNum = 0

		' for each Y-Axis
		if ChartFXVer="6.2" then
			GraphChart.OpenData COD_COLORS, iSeriesCount, 0
		else
			GraphChart.OpenDataEx COD_COLORS, iSeriesCount, 0
		End If
		for YAxisIndex = 1 to 2
			' for each item
			for itemnum = LBound(YAxes, 3) to UBound(YAxes, 3)
				if YAxes(YAxisIndex, 0, itemnum) <> "" then
					' Log 51350 YC - Ability to change marker size
					'create a dummy FIRST point for the series which i hidden
					'Call PlotPoint(iSeriesNum, 0, CHART_HIDDEN, CHART_HIDDEN )
					GraphChart.Series(iSeriesNum).MarkerShape = YAxes(YAxisIndex, 5, itemnum)
					GraphChart.Series(iSeriesNum).MarkerSize = YAxes(YAxisIndex, 12, itemnum)
					GraphChart.Series(iSeriesNum).LineStyle = YAxes(YAxisIndex, 2, itemnum)
					GraphChart.Series(iSeriesNum).Legend = YAxes(YAxisIndex, 1, itemnum) & " (Y" & YAxisIndex & ")"
					GraphChart.Series(iSeriesNum).Color =  YAxes(YAxisIndex, 4, itemnum)
					Call SetSeriesYAxis(YAxisIndex,iSeriesNum)
					Call ChartOneItem (YAxisIndex, itemnum , DateTimeFrom, DateTimeTo, CacheDateFrom, CacheTimeFrom, CacheDateTo, CacheTimeTo, mMinorStep, iSeriesNum, iSeriesMax)
				end if
			next
		next
		GraphChart.CloseData COD_COLORS
	End Sub

	Sub AssignHiLoChartData ( DateTimeFrom, DateTimeTo, mMinorStep )
		Dim iSeriesNum
		Dim YAxisIndex, YAxisIndex2
		dim CurrentItemDesc
		Dim itemnum, itemnum2
		Dim xDateTime
		Dim CacheDateFrom,CacheTimeFrom,CacheDateTo,CacheTimeTo

		'To get points exactly at the Start and End times, modify the Cache From and To times:
		xDateTime = DateAdd("s", -1, DateTimeFrom)	'StartTime -1 second
		CacheDateFrom = DatePut(DateValue(xDateTime))
		CacheTimeFrom = TimePut(TimeValue(xDateTime))
		xDateTime = DateAdd("s", 1, DateTimeTo)		'End Time + 1 second
		CacheDateTo = DatePut(DateValue(xDateTime))
		CacheTimeTo = TimePut(TimeValue(xDatetime))

		iSeriesNum = 0

		' for each Y-Axis
		if ChartFXVer="6.2" then
			GraphChart.OpenData COD_COLORS, iSeriesCount, 0
		else
			GraphChart.OpenDataEx COD_COLORS, iSeriesCount, 0
		End If

		for YAxisIndex = 1 to 2
			' for each item
			for itemnum = LBound(YAxes, 3) to UBound(YAxes, 3)
				if YAxes(YAxisIndex, 0, itemnum) <> "" and YAxes(YAxisIndex, 13, itemnum) <> "" Then
					' below is wrong...we shouldn't be going thru the axes to find the linked item
					' just get the linked item and graph it.
					For YAxisIndex2 = 1 to 2
						' for each item
						For itemnum2 = LBound(YAxes, 3) to UBound(YAxes, 3)
							'find linked item
							If YAxes(YAxisIndex, 13, itemnum) = YAxes(YAxisIndex2, 9, itemnum2) Then
								' Log 51350 YC - Ability to change marker size
								'create a dummy FIRST point for the series which i hidden
								'Call PlotPoint(iSeriesNum, 0, CHART_HIDDEN, CHART_HIDDEN )
								GraphChart.Series(OHLC_OPEN).Gallery = OPENHILOWCLOSE
								GraphChart.Series(OHLC_OPEN).MarkerShape = YAxes(YAxisIndex, 5, itemnum)
								GraphChart.Series(OHLC_OPEN).MarkerSize = YAxes(YAxisIndex, 12, itemnum)
								'GraphChart.Series(OHLC_OPEN).LineStyle = YAxes(YAxisIndex, 2, itemnum)
								GraphChart.Series(OHLC_OPEN).Legend = YAxes(YAxisIndex, 1, itemnum) & " (Y" & YAxisIndex & ")"
								GraphChart.Series(OHLC_OPEN).Color =  YAxes(YAxisIndex, 4, itemnum)
								Call SetSeriesYAxis(YAxisIndex,OHLC_OPEN)
								'Call ChartOneItem (YAxisIndex, itemnum , DateTimeFrom, DateTimeTo, CacheDateFrom, CacheTimeFrom, CacheDateTo, CacheTimeTo, mMinorStep, iSeriesNum, iSeriesMax)
								'attributes for linked item
								GraphChart.Series(OHLC_CLOSE).Gallery = OPENHILOWCLOSE
								GraphChart.Series(OHLC_CLOSE).MarkerShape = YAxes(YAxisIndex2, 5, itemnum2)
								GraphChart.Series(OHLC_CLOSE).MarkerSize = YAxes(YAxisIndex2, 12, itemnum2)
								'GraphChart.Series(OHLC_CLOSE).LineStyle = YAxes(YAxisIndex2, 2, itemnum2)
								GraphChart.Series(OHLC_CLOSE).Legend = YAxes(YAxisIndex2, 1, itemnum2) & " (Y" & YAxisIndex & ")"
								GraphChart.Series(OHLC_CLOSE).Color =  YAxes(YAxisIndex2, 4, itemnum2)
								Call SetSeriesYAxis(YAxisIndex2,OHLC_CLOSE)
								Call ChartHiLoItem (YAxisIndex, itemnum, YAxisIndex2, itemnum2, DateTimeFrom, DateTimeTo, CacheDateFrom, CacheTimeFrom, CacheDateTo, CacheTimeTo, mMinorStep, iSeriesNum, iSeriesMax)
							End If
						Next
					Next
				end if
			next
		next
		GraphChart.CloseData COD_COLORS
	End Sub

	Sub ChartOneItem ( YAxisIndex, itemnum, DateTimeFrom, DateTimeTo, CacheDateFrom, CacheTimeFrom, CacheDateTo, CacheTimeTo, mMinorStep, iSeriesNum, iSeriesMax)
		' takes an item and some dates, and returns the x and Y cord to be plotted..
		Dim XCoOrd, YCoOrd
		Dim rs
		Dim GraphDate,GraphTime
		Dim PointIndex
		Dim ShowRef
		Dim itemtype
		Dim itemDR
		Dim itemCode

		itemtype = YAxes(YAxisIndex, 0, itemnum)
		itemDR = YAxes(YAxisIndex, 9, itemnum)
		itemCode = YAxes(YAxisIndex, 10, itemnum)

		'response.write "<BR>" & PatientID & ", " & itemCode & ", " & CacheDateFrom & ", " & CacheDateTo

		ShowRef = 0
		PointIndex=0
		if itemtype = "OB" then
			Set rs=CacheFactory.ResultSet("web.MRObservations","FindEMR")
			Call rs.Execute(MRAdm,itemDR,CacheDateFrom,CacheDateTo,CacheTimeFrom,CacheTimeTo)
			'Call rs.Execute(20592,42,50000,65000,0,0)
			Do While rs.Next()
				ShowRef = 1
				GraphDate = DateGet(CStr(rs.GetDataByName("cacheDate")))
				GraphTime = TimeGet(rs.GetDataByName("cacheTime"))
				XCoOrd = ConvertTimeToCoOrd(DateTimeFrom, CDate(GraphDate & " " & GraphTime))
				YCoOrd = rs.GetDataByName("OBSValue")
				'Response.Write ("<BR>in obs:, Date/time=" & GraphDate & ", " & GraphTime & "X=" & XCoOrd & ", Y=" & YCoOrd & ", CacheDT" & rs.GetDataByName("cacheDate") & ", " & rs.GetDataByName("cacheTime"))
				if (YCoOrd <> "") Then
					Call PlotPoint(iSeriesNum,PointIndex,XCoOrd,YCoOrd)
				End If
			Loop
			rs.Close
		elseif itemtype="LB" then
			Set rs=CacheFactory.ResultSet("epr.LabGraphTestSets","ResultsForGraph")
			Call rs.Execute(PatientID,itemCode,CacheDateFrom,CacheDateTo,CacheTimeFrom,CacheTimeTo)
			'Call rs.Execute(25924,"A0001",50000,65000,0,0)
			Do While rs.Next()
				ShowRef = 1
				GraphDate = DateGet(CStr(rs.GetDataByName("Date")))
				GraphTime = TimeGet(rs.GetDataByName("Time"))
				XCoOrd = ConvertTimeToCoOrd(DateTimeFrom, CDate( GraphDate & " " & GraphTime))
				YCoOrd = rs.GetDataByName("ResultValue")
				'Response.Write ("<BR>in lab:, Date/time=" & GraphDate & ", " & GraphTime & "X=" & XCoOrd & ", Y=" & YCoOrd)
				if (YCoOrd <> "") Then
					Call PlotPoint(iSeriesNum,PointIndex,XCoOrd,YCoOrd)
				End If
			Loop
			rs.Close
		elseif itemtype="OR" then
			Set rs=CacheFactory.ResultSet("epr.LabGraphTestSets","FindForGraph")
			'Response.Write PatientID & ", " & itemDR & ", " & CacheDateFrom & ", " & CacheDateTo & ", " & CacheTimeFrom & ", " & CacheTimeTo
			'Response.flush
			Call rs.Execute(PatientID,itemDR,CacheDateFrom,CacheDateTo,CacheTimeFrom,CacheTimeTo)
			'Call rs.Execute(3018,"7142||1",58000,65000,0,0)
			Do While rs.Next()
				ShowRef = 1
				GraphDate = rs.GetDataByName("Date")
				GraphTime = rs.GetDataByName("Time")
				XCoOrd = ConvertTimeToCoOrd(DateTimeFrom, CDate(GraphDate & " " & GraphTime))
				YCoOrd = rs.GetDataByName("DoseQty")
				'Response.Write ("<BR>in ord:, Date/time=" & GraphDate & ", " & GraphTime & "X=" & XCoOrd & ", Y=" & YCoOrd)
				if (YCoOrd <> "") Then
					Call PlotPoint(iSeriesNum,PointIndex,XCoOrd,YCoOrd)
				End If
			Loop
			rs.Close
		end if
		' mark the max points of this series
		ReDim Preserve iSeriesMax(iSeriesNum+1)
		iSeriesMax(iSeriesNum) = PointIndex
		iSeriesNum = iSeriesNum + 1
		If StdtypGraphType<>"DC" Then
			' only show the ref ranges if we have plotted something..
			if YAxes(YAxisIndex, 6, itemnum) <> "" then
				ShowRefLines "upper", YAxisIndex, iSeriesNum, itemnum, DateTimeFrom, DateTimeTo
			end if
			if YAxes(YAxisIndex, 7, itemnum) <> "" then
				ShowRefLines "lower", YAxisIndex, iSeriesNum, itemnum, DateTimeFrom, DateTimeTo
			end if
			if YAxes(YAxisIndex, 14, itemnum) <> "" then
				ShowNonLinearRefLines YAxisIndex, iSeriesNum, itemnum
			end if
		End If
	End Sub

	Sub ChartHiLoItem ( YAxisIndex, itemnum, YAxisIndex2, itemnum2, DateTimeFrom, DateTimeTo, CacheDateFrom, CacheTimeFrom, CacheDateTo, CacheTimeTo, mMinorStep, iSeriesNum, iSeriesMax)
		' takes an item and some dates, and returns the x and Y coord to be plotted..
		Dim XCoOrd, YCoOrd, XCoOrd2, YCoOrd2
		Dim rs
		Dim GraphDate,GraphTime
		Dim PointIndex1, PointIndex2
		Dim ShowRef
		Dim itemtype
		Dim itemDR
		Dim itemCode
		Dim itemtype2
		Dim itemDR2
		Dim itemCode2
		Dim obsArr1(),obsArr2()

		ReDim obsArr1(1000)
		ReDim obsArr2(1000)

		itemtype = YAxes(YAxisIndex, 0, itemnum)
		itemDR = YAxes(YAxisIndex, 9, itemnum)
		itemCode = YAxes(YAxisIndex, 10, itemnum)

		itemtype2 = YAxes(YAxisIndex2, 0, itemnum2)
		itemDR2 = YAxes(YAxisIndex2, 9, itemnum2)
		itemCode2 = YAxes(YAxisIndex2, 10, itemnum2)

		ShowRef = 0
		PointIndex1=0
		PointIndex2=0

		if itemtype = "OB" then
			Set rs=CacheFactory.ResultSet("web.MRObservations","FindEMR")
			Call rs.Execute(MRAdm,itemDR,CacheDateFrom,CacheDateTo,CacheTimeFrom,CacheTimeTo)
			'Call rs.Execute(20592,42,50000,65000,0,0)
			Do While rs.Next()
				ShowRef = 1
				GraphDate = rs.GetDataByName("ObsDate")
				GraphTime = rs.GetDataByName("OBSTime")
				XCoOrd = ConvertTimeToCoOrd(DateTimeFrom, CDate(GraphDate & " " & GraphTime))
				YCoOrd = rs.GetDataByName("OBSValue")
				'Response.Write ("<BR>in obs:, Date/time=" & GraphDate & ", " & GraphTime & "X=" & XCoOrd & ", Y=" & YCoOrd)
				if (YCoOrd <> "") Then
					If PointIndex1>UBound(obsArr1,1) Then
						ReDim Preserve obsArr1(1,PointIndex1+1000)
					End If
					obsArr1(0,PointIndex1)=XCoOrd
					obsArr1(1,PointIndex1)=YCoOrd
					PointIndex1=PointIndex1+1
				End If
			Loop
			rs.Close
			Call rs.Execute(MRAdm,itemDR2,CacheDateFrom,CacheDateTo,CacheTimeFrom,CacheTimeTo)
			'Call rs.Execute(20592,42,50000,65000,0,0)
			Do While rs.Next()
				ShowRef = 1
				GraphDate = rs.GetDataByName("ObsDate")
				GraphTime = rs.GetDataByName("OBSTime")
				XCoOrd2 = ConvertTimeToCoOrd(DateTimeFrom, CDate(GraphDate & " " & GraphTime))
				YCoOrd2 = rs.GetDataByName("OBSValue")
				'Response.Write ("<BR>in obs:, Date/time=" & GraphDate & ", " & GraphTime & "X=" & XCoOrd & ", Y=" & YCoOrd)
				if (YCoOrd2 <> "") Then
					If PointIndex2>UBound(obsArr2,1) Then
						ReDim Preserve obsArr2(1,PointIndex2+1000)
					End If
					obsArr2(0,PointIndex)=XCoOrd2
					obsArr2(1,PointIndex)=YCoOrd2
					PointIndex2=PointIndex2+1
				End If
			Loop
			rs.Close
		end If
		ReDim Preserve iSeriesMax(3)
		iSeriesMax(OHLC_OPEN) = PointIndex1
		iSeriesMax(OHLC_CLOSE) = PointIndex2
		iSeriesMax(OHLC_HIGH) = 0
		iSeriesMax(OHLC_LOW) = 0
		ReDim Preserve obsArr1(1,PointIndex1-1)
		ReDim Preserve obsArr1(1,PointIndex2-1)
		Call PlotHiLo(obsArr1,obsArr2,PointIndex1,PointIndex2,XCoOrd,YCoOrd,XCoOrd2,YCoOrd2)
	End Sub

	Sub ShowNonLinearRefLines (YAxisIndex, iSeriesNum, itemnum)
		Dim refRanges
		Dim i
		Dim pointCount
		Dim XCoord
		Dim GraphDate
		Dim legendStr
		Dim xIncrementUnit
		Dim increment

		refRanges = Split(YAxes(YAxisIndex, 14, itemnum),",")

		'response.write(Ubound(refRanges))

		For i = 0 To Ubound(refRanges)
		  'Response.Write(refRanges(i) & ":")
			Set rs=CacheFactory.ResultSet("epr.CTRefRangeCoordinates","GetRefRangeCoordinates")
			Call rs.Execute(refRanges(i))
			'Response.Write(iSeriesCount & "," & iSeriesNum & ":")
			GraphChart.Series(iSeriesNum).MarkerShape = MK_NONE
			GraphChart.Series(iSeriesNum).LineStyle = YAxes(YAxisIndex, 3, itemnum)
			Call SetSeriesYAxis(YAxisIndex,iSeriesNum)
			GraphChart.Series(iSeriesNum).Color = YAxes(YAxisIndex, 8, itemnum)
			pointCount=0
			increment=0
			Do While rs.Next()

				If increment=0 Then
					xIncrementUnit=rs.GetDataByName("XIncrement")
					If xIncrementUnit = "Y" Then
						increment = 365
					elseif xIncrementUnit = "M" then
						increment = 30
					elseif xIncrementUnit = "W" then
						increment = 7
					else
						increment = 1
					End If
				End If

				'Response.Write(increment & ", ")
				GraphDate = DateGet( CStr(rs.GetDataByName("XCoord")) * increment )
				'Response.Write(GraphDate & ",")
				XCoord = ConvertTimeToCoOrd(DateGet(CStr(0)), CDate(GraphDate))
 				'Response.Write(XCoord & ".")
				Call PlotPoint(iSeriesNum, pointCount, XCoord, rs.GetDataByName("YCoord"))
				legendStr = rs.GetDataByName("Description")
			Loop
			GraphChart.Series(iSeriesNum).Legend = legendStr & " (Y" & YAxisIndex & ")"
			' mark the max points of this series
			ReDim Preserve iSeriesMax(iSeriesNum+1)
			iSeriesMax(iSeriesNum) = pointCount
			iSeriesNum = iSeriesNum + 1
			rs.Close()
		Next


	End Sub

	Sub ShowRefLines (RefType, YAxisIndex, iSeriesNum, itemnum, DateTimeFrom, DateTimeTo)
		dim AxisKey
		dim legendStr

		if RefType = "upper" then
			AxisKey = 6
			Dim upperref
			upperref=Request("TUPPER_REF")
			If upperref="" Then upperref="Up. ref"
			legendStr = upperref & " "
		else
			AxisKey = 7
			Dim lowerref
			lowerref=Request("TLOWER_REF")
			If lowerref="" Then lowerref="Low. ref"
			legendStr = lowerref & " "
		end if
		Call PlotPoint(iSeriesNum, 0, 0, (YAxes(YAxisIndex, AxisKey, itemnum)))
		GraphChart.Series(iSeriesNum).MarkerShape = YAxes(YAxisIndex, 5, itemnum)
		GraphChart.Series(iSeriesNum).LineStyle = YAxes(YAxisIndex, 3, itemnum)
		GraphChart.Series(iSeriesNum).Legend = legendStr & YAxes(YAxisIndex, 1, itemnum) & " (Y" & YAxisIndex & ")"
		'Response.Write "iSeriesNum1=" & iSeriesNum & "<BR>" & "YAxisIndex=" & YAxisIndex & "<BR>"
		Call SetSeriesYAxis(YAxisIndex,iSeriesNum)
		' plot the right point
		Call PlotPoint(iSeriesNum, 1, ConvertTimeToCoOrd(DateTimeFrom, DateTimeTo), YAxes(YAxisIndex, AxisKey, itemnum))
		GraphChart.Series(iSeriesNum).Color = YAxes(YAxisIndex, 8, itemnum)
		' mark the max points of this series
		ReDim Preserve iSeriesMax(iSeriesNum+1)
		iSeriesMax(iSeriesNum) = 2
		iSeriesNum = iSeriesNum + 1

	End Sub

	Sub CloseChartObjForData
		'Close the communication channel
		'GraphChart.CloseData COD_COLORS
		if ChartFXVer="6.2" then
			GraphChart.CloseData COD_XValues
			GraphChart.CloseData COD_Values
		else
			GraphChart.CloseData COD_VALUES
			GraphChart.CloseData COD_XVALUES
		End If
	End Sub

	Sub FormatTimeRange (StartDateTime,EndDateTime, mMajorStep, mMinorStep )
		'Computes the Major and Minor steps in the time range and formats the X-axis labels
		Dim Minutes
		Dim Axis
		Dim i
		Dim DateTime
		Dim xHours
		Dim fmtTest
		Dim IncrementAmount
		Dim IncrementUnit
		Dim Increment
		Dim iIncrement

		' Log 46460 - AI - 01-12-2004 : Increment is now made up of two fields - a numeric value and a type of unit.
		'                               Use the hidden Code rather than getting the code from the description.
		'
		'Increment=Request("Increment")
		'
		iIncrement=Request("Increment")
		Increment = 0
		if not IsNumeric(iIncrement) then
			iIncrement=0
		end if
		IncrementAmount = int(iIncrement)
		IncrementUnit = Request("IncrementUnitCode")
		If IncrementUnit = "" Then
			IncrementUnit = "M"
		End If
		'increment in minutes
		If IncrementUnit = "M" Then
			Increment = int(IncrementAmount)
		ElseIf IncrementUnit = "H" Then
			Increment = int(IncrementAmount * 60)
		ElseIf IncrementUnit = "D" Then
			Increment = int(IncrementAmount * 60 * 24)
		ElseIf IncrementUnit = "W" Then
			Increment = int(IncrementAmount * 60 * 24 * 7)
		End If
		' end Log 46460
		'Response.Write "Increment=" & Increment & "<BR>"
		Minutes = DateDiff("n",StartDateTime, EndDateTime)
		xHours = int(Minutes/60)
		if Increment <> 0 Then
			mMajorStep = Increment
			mMinorStep = Increment
		ElseIf xHours <= 1 Then
			mMinorStep = 5
			mMajorStep = 5
		ElseIf xHours <= 4 Then
			mMinorStep = 5
			mMajorStep = 15
		ElseIf xHours <= 9 Then
			mMinorStep = 5
			mMajorStep = 30
		ElseIf xHours <= 15 Then
			mMinorStep = 15
			mMajorStep = 60
		ElseIf xHours <= 40 Then
			mMinorStep = 30
			mMajorStep = 120		'2 hours
		ElseIf xHours <= 60 Then
			mMinorStep = 60
			mMajorStep = 240		'4 hours
		ElseIf xHours <= 120 Then
			mMinorStep = 120
			mMajorStep = 480
		ElseIf xHours <= 240 Then
			mMinorStep = 180
			mMajorStep = 720
		ElseIf xHours <=480 Then
			mMinorStep = 360
			mMajorStep = 1440		'1 day
		ElseIf xHours <=960 Then
			mMinorStep = 720
			mMajorStep = 2880		'2 days
		ElseIf xHours <= 1920 Then
			mMinorStep = 1440		'1 day
			mMajorStep = 5760
		ElseIf XHours <= 3840 Then
			mMinorStep = 1440
			mMajorStep = 10080	'7 days
		ElseIf xHours <= 7680 Then
			mMinorStep = 10080	'7 Days
			mMajorStep = 20160	'14 days
		Else
			mMinorStep = 10080	'7 Days
			mMajorStep = 40320	'4 weeks
		End If
		'rounding to nearest interval
		' looks like a load of crap
		'Dim xDateTime
		'Dim mindiff
		'xDateTime = DateValue(StartDateTime)
		'If xDateTime < StartDateTime Then
			'mindiff = DateDiff("n", xDateTime,StartDateTime)
			'XAxisNoOfPoints = mindiff
			'Response.Write "mindiff=" & mindiff
			'StartDateTime = DateAdd("n", -(mindiff mod mMajorStep), StartDateTime )
		'End If
	End sub

	Sub SetXAxisLabels ( StartDateTime,EndDateTime, mMajorStep, mMinorStep )
		'X axis labels must be set after the point data has been set
		Dim Minutes
		Dim Axis
		Dim i
		Dim DateTime
		Dim xHours
		Dim fmtTest
		Dim IncAmount
		Dim IntType
		Dim Divisor
		Dim IntTypeDef

		If Label<>"" Then
			Set IntTypeDef=CacheFactory.Static("websys.StandardTypeItem")
			IntType=IntTypeDef.GetIdFromCodeOrDescription("GraphIntervalDisplay",Label)
		Else
			IntType="DT"
		End If
		If StdtypGraphType="DC" Then
			IntType="D"
		End If
		If IntType="M" Then
			Divisor=1
		ElseIf IntType="H" Then
			Divisor=60
		ElseIf IntType="D" Then
			Divisor=1440
		ElseIf IntType="W" Then
			Divisor=10080
		Else
			IntType="DT"
			Divisor=1
		End If

		Minutes = DateDiff("n",StartDateTime, EndDateTime)
		if ChartFXVer="6.2" then
			Set Axis=GraphChart.AxisX
			Axis.DataFormat.Decimals = 0
		else
			Set Axis=GraphChart.Axis(AXIS_X)
			Axis.Format = AF_NONE
			Axis.Decimals = 0
		End If

		Axis.Min = 0
		Axis.Max = Minutes
		Axis.MinorStep = mMinorStep
		Axis.Step = mMajorStep
		Axis.LabelValue = Axis.Step
	
		Axis.Style = Axis.Style AND NOT AS_SINGLELINE

		For i = 0 to Int(Minutes/Axis.Step)
			If IntType<>"DT" Then
				IncAmount = Round(((i * Axis.Step) / Divisor),2)
				Axis.Label(i) = IncAmount
				Dim TheTitle
				If StdtypGraphType="DC" Then
					Dim babyageindays
					babyageindays=Request("TBABY_AGE_IN_DAYS")
					If babyageindays="" Then babyageindays="Baby's Age in Days"
					TheTitle = babyageindays
				Else
					TheTitle = Label
				End If
				if ChartFXVer="6.2" then
					Axis.Title.Text = TheTitle
				else
					Axis.Title = TheTitle
				End If
			Else
				DateTime = DateAdd("n", i * Axis.Step, StartDateTime)
				fmtTest = FormatDateTime( DateTime, vbShortTime )
				If fmtTest = formatDateTime(0,vbShortTime) Then
					If MajorStep < 1440 Then
						fmtTest = fmtTest & vbcrlf & FormatMonthDay( DateTime)
					Else
						fmtTest = FormatMonthDay(DateTime)
					End If
				End If
				Axis.Label(i) = fmtTest
				'Axis.Label(i) = i+1
			End If
		Next
	End sub


	Function FormatMonthDay ( DateTime )
		'Returns a Month Day string
		Dim xMonth
		Dim xDay

		xMonth = Month(DateTime)
		FormatMonthDay = Day(DateTime) & " " & MonthName(xMonth, True)
	end Function

	Function TestDates ( FromDate, FromTime, ToDate,ToTime, dateTimeFrom, dateTimeTo )
		'tests for valid date ranges and returns to DateTime Variables
		Dim Message
		dim conv
		dim epr
		dim thedate
		dim dateFrom
		dim dateTo
		dim timeFrom
		dim timeTo

		' Converts date to logical format and then to YMD format
		' Its only with YMD format that we can relie on VB working correctly when converting to a DATE type
		set conv=CacheFactory.Static("websys.Conversions")
		set epr=CacheFactory.Static("epr.GraphOrderSets")
		thedate=conv.DateHtmlToLogical(FromDate)
		thedate=epr.DateLogicalToYMD(thedate)
		if thedate<>"" then FromDate=thedate
		thedate=conv.DateHtmlToLogical(ToDate)
		thedate=epr.DateLogicalToYMD(thedate)
		if thedate<>"" then ToDate=thedate

		If IsDate(FromDate) then
			If FromTime = "" then
			elseif IsDate(FromTime) then
			Else
				Dim invalidfromtime
				invalidfromtime=Request("TINVALID_FROM_TIME")
				If invalidfromtime="" Then invalidfromtime="Invalid From Time"
				Message = invalidfromtime
			end if
			If Message = "" then
				if IsDate(ToDate) then
					If ToTime = "" then
					elseif IsDate(ToTime) then
					Else
						Dim invalidtotime
						invalidtotime=Request("TINVALID_TO_TIME")
						If invalidtotime="" Then invalidtotime="Invalid To Time"
						Message = invalidtotime
					end if
				Else
					Dim notodate
					notodate=Request("TNO_TO_DATE")
					If notodate="" Then notodate="To Date Missing"
					Message = notodate
				end if
				If Message = "" then
					dateTimeFrom = CDate(FromDate & " " & FromTime)
					dateTimeTo = CDate(ToDate & " " & ToTime)
					' Log 66451 - DAH - Test Date/Time separately
					dateFrom = CDate(FromDate)
					dateTo = CDate(ToDate)
					timeFrom = CDate(FromTime)
					timeTo = CDate(ToTime)
					'Response.Write ( dateTimeFrom & "|" & dateTimeTo & "<BR>" & CDate(FromTime) & "|" & CDate(ToTime) & "<BR>")
					If dateFrom > dateTo or (dateFrom = dateTo and timeFrom > timeTo) Then
						Dim fromgreaterthanto
						fromgreaterthanto=Request("TFROM_GREATER_THAN_TO")
						If fromgreaterthanto="" Then fromgreaterthanto="From date and time is greater than To date and time"
						Message = fromgreaterthanto
					end if
				end if
			end if
		Else
			Dim nofromdate
			nofromdate=Request("TNO_FROM_DATE")
			If nofromdate="" Then nofromdate="From Date Missing"
			Message = nofromdate
		end if
		If Message = "" then
			TestDates = True
		else
			Response.Write ( "<P><B>" & Message & "</B></P>")
		end if
	end Function

	Function SetDate(ExternalDate)
		'Required because there seems to be some unusual inconsistency between
		'the page interpreting date as dd/MM/YY or MM/dd/YY - and this is not
		'dependent on the server's regional settings.
		Dim sDay,sMonth,sYear
		sDay = Day(ExternalDate)
		sMonth = Month(ExternalDate)
		sYear = Year(ExternalDate)
		SetDate = sDay & "/" & sMonth & "/" & sYear
	End Function

	Function DatePut(ExternalDate)
		'Convert external date to internal cache date
		DatePut = DateDiff("d",CACHE_PIVOT_DATE,ExternalDate)
	End Function

	Function DateGet(InternalDate)
		'Convert internal cache date to external date
		'Set to 0 if blank to avoid type mismatch errors
		If InternalDate="" Then InternalDate=0
		DateGet = DateAdd("d",InternalDate,CACHE_PIVOT_DATE)
	End Function

	Function TimePut(ExternalTime)
		'Convert external time to internal cache time
		If ExternalTime = "" Then
			TimePut = 0
		Else
			TimePut = DateDiff("s",CACHE_PIVOT_TIME,ExternalTime)
		End If
	End Function

	Function TimeGet(InternalTime)
		'Convert internal cache time to external time
		'Set to 0 if blank to avoid type mismatch errors
		If InternalTime="" Then InternalTime=0
		TimeGet = DateAdd("s",InternalTime,CACHE_PIVOT_TIME)
	End Function

	Sub SetSeriesYAxis(YAxisIndex,ChartSeriesIndex)
		If YAxisIndex = 1 Then
			if ChartFXVer="6.2" then
				GraphChart.Series(ChartSeriesIndex).YAxis=YAxis_Main
			else
				GraphChart.Series(ChartSeriesIndex).YAxis=AXIS_Y
			End If
		ElseIf YAxisIndex = 2 Then
			if ChartFXVer="6.2" then
				GraphChart.Series(ChartSeriesIndex).YAxis=YAxis_Secondary
			else
				GraphChart.Series(ChartSeriesIndex).YAxis=AXIS_Y2
			End If
		End If
	End Sub

	Sub PlotPoint(SeriesIndex,PointIndex,XCoOrdinate,YCoOrdinate)
		If IsNumeric(YCoOrdinate) Then
			YCoOrdinate=CSng(YCoOrdinate)
			if ChartFXVer="6.2" then
				GraphChart.Value(SeriesIndex,PointIndex) = YCoOrdinate
				GraphChart.XValue(SeriesIndex,PointIndex) = XCoOrdinate
			Else
				GraphChart.ValueEx(SeriesIndex,PointIndex) = YCoOrdinate
				GraphChart.XValueEx(SeriesIndex,PointIndex) = XCoOrdinate
			End If
			PointIndex=PointIndex+1
		End If
	End Sub

	Sub PlotHiLo(obsArr1,obsArr2,PointIndex1,PointIndex2,XCoOrd,YCoOrd,XCoOrd2,YCoOrd2)
		Dim i
		If IsNumeric(YCoOrd) and IsNumeric(YCoOrd2) Then
			YCoOrd=CSng(YCoOrd)
			YCoOrd2=CSng(YCoOrd2)
			For i=0 to PointIndex1
				if ChartFXVer="6.2" then
					GraphChart.Value(OHLC_OPEN,PointIndex) = YCoOrd
					GraphChart.Value(OHLC_CLOSE,PointIndex) = YCoOrd2
				else
					GraphChart.ValueEx(OHLC_OPEN,PointIndex) = YCoOrd
					GraphChart.ValueEx(OHLC_CLOSE,PointIndex) = YCoOrd2
				End If
			Next
			'GraphChart.XValueEx(SeriesIndex,PointIndex) = XCoOrdinate
		End If
	End Sub

	Function ConvertTimeToCoOrd(OriginDateTime,PointDateTime)
		'SA: ConvertTimeToCoOrd returns the point number. This is equivalent to the
		'number of minor steps (or major if minor steps aren't defined) from the origin.
		'note: If more than one value (Y coord) for the allocated time frame
		'(X coord) is used (ie Minutes, Hours, Days), the last will
		'overwrite all previous settings to the value
		'Response.Write "DateTime=" & PointDateTime & "<BR>"

		ConvertTimeToCoOrd = Clng(DateDiff("n",OriginDateTime,PointDateTime))
	End Function

	Sub DisplayGraph
		If OKToGraph Then
			GraphChart.Chart3D = false
			GraphChart.Gallery = LINES
			'GraphChart.Gallery = OPENHILOWCLOSE
			GraphChart.SerLegBox = True	'Show Series Legend Box
			'GraphChart.LegendBoxObj.SkipEmpty = True 'Do not display empty legends

			GraphHeight=CLng(Request("Height"))
			GraphWidth=CLng(Request("Width"))

			If StdtypGraphType="PG" Then
				GraphChart.SerLegBoxObj.Width=200
				GraphWidth=GraphWidth+200
			End If

			' Log 52341 YC - Set minimum size for graphs
			If GraphHeight<200 Then GraphHeight=200 End If
			If GraphWidth<400 Then GraphWidth=400 End If

			Dim YAxis
			if ChartFXVer="6.2" then
				Set YAxis=GraphChart.AxisY2
			else
				Set YAxis=GraphChart.Axis(AXIS_Y2)
			End If

			' Log 66417 DAH - Set size for graphs is Y2 is defined. 
			If (YAxis.Min < 10^308 and YAxis.Max > -(10^308)) then GraphWidth=GraphWidth+43 End If
			
			'Response.Write "GraphHeight=" & GraphHeight & "<BR>"
			'Response.Write "GraphWidth=" & GraphWidth & "<BR>"
			%>
			<%=GraphChart.GetHtmlTag(GraphWidth,GraphHeight,"Image") %>
		<%Else
			Dim nograph
			nograph=Request("TNO_GRAPH")
			If nograph="" Then nograph="No Graph To Display"
			Response.Write "<BR>" & "-------------" & nograph & "-------------"
		End If
	End Sub
	
	Dim iframeurl
	iframeurl=Request("path") & "websys.default.csp?WEBSYS.TCOMPONENT=MRObservations.ChartFX.ListEdit&Graph=" & escape(Request("Graph"))
	iframeurl=iframeurl & "&DateFrom=" & Request("DateFrom") & "&TimeFrom=" & Request("TimeFrom") & "&Increment=" & Request("Increment") & "&IncrementUnit=" & Request("IncrementUnit") & "&mradm=" & Request("mradm") & "&NoOfIntervals=" & Request("NoOfIntervals")
	
%>
<!--=GraphChart.GetHtmlTag(GraphHeight,GraphWidth,"Auto")-->
<% If StdtypGraphType="PG" Then %>
		<IFRAME src=<% Response.Write iframeurl %> frameborder=0 Width=<%=GraphWidth%> Height=100%>
<% End If %>

</body>
</html>
