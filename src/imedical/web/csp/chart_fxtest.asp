<%@ Language=VBScript %>
<html>
<head>
<!-- #include virtual="/Include/CfxIE.inc" -->
<!-- #include virtual="/Include/CfxIEExtra.inc"-->
<!--
<title>Example 1</title>
</head>
<body>
<P><B><U> This is a demo of Chart_FX IE 2000.</U></B></P>
<P>Chart FX IE installs on the same machine as the Web Server. When using ISS as the Web server it is natural to use ASP and VBscript to configure the Charting tool. Normally the Charting tool is configured to embed a charting object into the html page sent to the client. This enables the user to play with the display format of the chart. It is also possible as in this example to force the server side charting tool to embed an image into the client html page. 
<P>Regardless of the method (Object or Image) a file is always generated on the Web Server site. These temporary files will need to be deleted on a regular basis.
See <U>\\Cow\E\InetPub\wwwroot\CfxTemp</U>
</P>
-->
<% Set Chart1 = Server.CreateObject("ChartFX.WebServer") %>
<%
'Open the communication channel
Chart1.Title(CHART_TOPTIT) =  "Vital Signs"
Chart1.OpenDataEX COD_VALUES,2,6
For j = 0 to 5
	'Assign the values to the series selected    
	Chart1.ValueEX(0,j) = j * 2
Next
Chart1.Axis(AXIS_X).Format = "hh:mm"
Chart1.Axis(AXIS_X).STEP = 2
Chart1.Axis(AXIS_X).minorstep = 2

For j = 1 to 6
	Chart1.ValueEX(1,j-1) = (j * j * (Rnd(5)))
Next

For j = 0 to 5
	Chart1.Axis(AXIS_X).Label(j) =	DateAdd("h", 10 + j, 0)
	'Response.Write "Chart1.Axis(AXIS_X).Label(j)=" & Chart1.Axis(AXIS_X).Label(j)
next
'Temperature
Chart1.ValueEx(2,0) = 30 + 2
Chart1.ValueEx(2,1) = 30 + 2
Chart1.ValueEx(2,2) = 30 + 1
Chart1.ValueEx(2,3) = 30 + 3
Chart1.ValueEx(2,4) = 30 + 4
Chart1.ValueEx(2,5) = 30 + 3
'medication dosage
Dim array(5)
array(0) = 70
array(1) = 80
array(2) = 60
array(3) = 65
array(4) = 60
array(5) = 65
For i = 0 to 5
	Chart1.ValueEx(3,i) = array(i)
next
Chart1.CloseData COD_VALUES



Chart1.OpenDataEX COD_CONSTANTS, 1, 0
Chart1.ConstantLine(0).Value=40
'Chart1.ConstantLine(0).Color=RGB(255, 0, 0)
Chart1.ConstantLine(0).Axis = AXIS_Y
Chart1.ConstantLine(0).LineWidth = 4
Chart1.CloseData COD_CONSTANTS

'Close the communication channel

Chart1.Chart3D = false
Chart1.Gallery = LINES
Chart1.Series(0).MarkerSize = 5
CHart1.Series(0).LineStyle = CHART_DOT
Chart1.Series(0).PointLabels = true
Chart1.Series(0).Color = vbBlue

Chart1.Series(1).Color = RGB(0, 200, 200)

Chart1.Chart3D = false
Chart1.Gallery = CURVE
Chart1.Series(2).MarkerSize = 5
CHart1.Series(2).LineStyle = CHART_DOT
Chart1.Series(2).PointLabels = true
Chart1.Series(2).Color = vbRed

Chart1.Series(3).Gallery = SCATTER
Chart1.Series(3).PointLabels = true
Chart1.Series(3).MarkerShape = MK_CROSS
Chart1.Series(3).MarkerSize = 5
Chart1.Series(3).Color = RGB( 100, 255, 0)

Chart1.Axis(AXIS_Y).Min = 0
Chart1.Axis(AXIS_Y).Max = 100
Chart1.Axis(AXIS_Y).Title = "BP & Pulse"
Chart1.Axis(AXIS_Y2).Min = 30
Chart1.Axis(AXIS_Y2).Max = 34
Chart1.Axis(AXIS_Y2).Title = "Temp"
Chart1.Axis(AXIS_X).Min = 0
CHart1.Axis(AXIS_X).Max = 6
Chart1.Axis(AXIS_X).Title = "Time"
CHart1.Axis(AXIS_X).Format = AF_TIME


Chart1.Series(0).YAxis = AXIS_Y
Chart1.Series(1).YAxis = AXIS_Y
Chart1.Series(2).YAxis = AXIS_Y2

Chart1.SerLegBox = True
Chart1.Series(0).Legend = "BP"
Chart1.Series(1).Legend = "Pulse"
Chart1.Series(2).Legend = "Temp"
Chart1.Series(3).Legend = "Medication"

'
'Set AnnotX = Server.CreateObject("AnnotationX.AnnList")
'Add Annotation List to ChartFX<BR>      
'Chart1.AddExtension AnnotX


'For i = 0 to 0 
'	Set Obj = AnnotX.Add(OBJECT_TYPE_TEXT)
'	Set Series = Chart1.Series(3)
'	
'	X = """" & Cstr( i) & ","  & Cstr(array(i)) & """"
'	Obj.Attach ATTACH_CENTER,"0,10"
'	Obj.Width = 30
'	Obj.Height = 20
'	obj.Text = "mg"
'	Obj.Font.Size = 10
'	Obj.AllowMove = False
'Next
%>

<%=Chart1.GetHtmlTag(800,600,"Auto") %>
</body>
</html>
