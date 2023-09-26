<!--// Copyright (c) 2000 TRAK Systems Pty. ALL RIGHTS RESERVED. -->
<!--
Program:	tkQASInteface.asp
'Date:		21/01/2002
'Author:	SA/KK/RQG
'Purpose:	This program is called from the registration screen. 
'			If a search is required, the program will get the records from the database matching all the parameters entered from the entry screen. 
'			The data manipulation will be made and the result will be showed on the screen in the form of a lookup table. If a selection is made from
'			the lookup table, the program will return a string in the form of:
'			postcode^suburb^state^address1^address2
-->

<SCRIPT SRC="../scripts/websys.js"> </SCRIPT>
<SCRIPT SRC="/csp/broker/cspbroker.js"> </SCRIPT>
<TITLE>Trak Systems EPR</TITLE>
<LINK REL="stylesheet" TYPE="text/css" HREF="../scripts/websys.css"></LINK>
<HTML>
<body bgColor="beige">
<BODY bottomMargin=0 leftMargin=0 rightMargin=0 topMargin=0 CLASS="clsLookUp">
<TABLE style="LEFT: 0px; TOP: 0px">
<TR>
<TD colSpan=2 valign=top>
<TABLE id=tblLookup Name=tblLookup CELLSPACING=1>
<%
	'Constant variables
	Const NUMADDRESSLINES = 6	'Not used
	Const NUMDATAPLUSLINES = 1	'Not used
	Const MAX_TABLE_LINES = 19
	Const ADDRESS1_PARAM = 0
	Const SUBURB_PARAM = 1
	Const STATE_PARAM= 2
	Const POSTCODE_PARAM= 3
	Const FIELD_PARAM= 4
	Const OPEN_PARAM= 5
	
	Const RET_ADD_LINE_1 = 0			'Address Line 1
	Const RET_ADD_LINE_2 = 1			'Address Line 2 - To be hidden in lookup table
	Const RET_ADD_LINE_3 = 2			'Address Line 3 - To be hidden in lookup table
	Const RET_SUBURB = 3				'Town
	Const RET_STATE = 4				'County
	Const RET_POSTCODE = 5			'Postcode
	Const RET_HLTH_AREA_CODE = 0	'Health Care Area Code - This is DataPlus Line 0
	Const RET_HLTH_REGION = 1		'Health Care Region Code - This is Dataplus Line 1
	
	'Const RET_HLTH_AREA_NAME = 1	'Health Care Area Name - This is DataPlus Line 1)
'					You must edit the qaproweb.ini file such that it includes the nhsc and pclh datasets (below),using the
'					following setup:
'					DataPlusLines=2
'					DataPlusLine1=W40 PCLH.PCLHCode
'					DataPlusLine2=W40 NHSC.H.A.Code This is the HealthCare Region (Called District Health Authority in QAS)
'					Dataset=Yes
'					+DataSet: PCLH
'					+DataSet: NHSC
'					You must also allow datasets within qansrv.ini and ensure that both datasets are available
'

	'Error messages
	Const sTooManyMatches = "Too many matches. Please refine your search"
	Const sInvalidParam = "No valid parameters have been passed to this search. Please advise technical support of this error."
	Const sNoQASMatch = "No QAS match found"
	Const sNoMatchFound = "No match found"
	Const sBlankParam1 = "sParams is blank"
	Const sBlankParam2 = "sParams is blank at end of Sub(RetrieveAddressFromQAS)"
	Const sInvalidChar = "Invalid characters were entered"
	Dim qasAddress
	Dim qasDataPlusLines
	Dim qasDataPlusCount	
	Dim qasStatus
	Dim iCode
	Dim iCount
	Dim lResultCount
	Dim lCount
	Dim iLine

	' Connection to the QAProWeb object
	Dim qasProWeb

	'Entry variables to be passed in
	Dim tkAddress1
	Dim tkSuburb
	Dim tkState
	Dim tkPostcode
	Dim tkField
	Dim tkFromBroker		' cjb 09/01/2007 59107
	Dim tkOpenCount		' SA: tkOpenCount is an indicator for whether the fetch is a new one, or an existing one in which the user has asked for more records.
	
	Dim bDone
	Dim sParams
	Dim PString(20)
	dim ictr

	
	Call GetInterfaceData()

	Sub GetInterfaceData
		'Get the input interface data
		Dim sParamArray()
		Dim sWarning
		
		' cjb 09/01/2007 59107
		lResultCount=0
		iCode=0
		
		sParams=Request("ParamStr")		' search criteria passed to the asp from the parent lookup
		
		sParams=Replace(sParams,"'","")	'rqg,Log27109: Remove the single quote from the string which is passed back from QAS
		
		If sParams <> "" Then
			tkAddress1=Trim(Mpiece(sParams, "^", 1))
			tkSuburb=Trim(Mpiece(sParams, "^", 2))
			tkState=Trim(Mpiece(sParams, "^", 3))
			tkPostcode=Trim(Mpiece(sParams, "^", 4))
			tkField=Trim(Mpiece(sParams, "^", 5))
			tkFromBroker=Mpiece(sParams, "^", 6)
			tkOpenCount=Mpiece(sParams, "^", 7)	' keep OpenCount as the last piece
			
			If tkFromBroker = "" Then
				tkFromBroker = 0
			End If

			'Response.Write("sParams=" & sParams & "<BR>")
			'Response.Write("tkAddress1=" & tkAddress1 & "<BR>" & "tkSuburb=" & tkSuburb & "<BR>" & "tkState=" & tkState & "<BR>" & "tkPostcode=" & tkPostcode & "<BR>" & "tkField=" & tkField & "<BR>" & "tkFromBroker=" & tkFromBroker & "<BR>" & "tkOpenCount=" & tkOpenCount & "<BR>")

			If tkAddress1 = "" And _
				tkSuburb = "" And _
				tkState = "" And _
				tkPostcode = "" Then
					sWarning = CreateErrorString("!WARN!", "", sTooManyMatches, "")
					Call CreateTable(sWarning, bDone, sParams)		
			Else
				Call RetrieveAddressFromQAS()
			End If
			
		Else
			sWarning = CreateErrorString("!ERR!", "Trak Error", sInvalidParam , sBlankParam1)
			Call CreateTable(sWarning, bDone, sParams)		
			
		End If
		
		'Response.Write("tkAddress1=" & tkAddress1 & "<BR>" & "tkSuburb=" & tkSuburb & "<BR>" & "tkState=" & tkState & "<BR>" & "tkPostcode=" & tkPostcode & "<BR>" & "tkField=" & tkField & "<BR>" & "tkOpenCount=" & tkOpenCount & "<BR>")
	End Sub


	Sub RetrieveAddressFromQAS
		
		Dim sTableString
		Dim sRetSingleAddress
		Dim sRetAddress1
		Dim sRetAddress2
		Dim sRetAddress3
		Dim sRetSuburb
		Dim sRetState
		Dim sRetPostcode
		Dim sRetHlthAreaCode
		Dim sRetHlthAreaName
		Dim sRetHlthRegCode
		Dim sRetHltRegInfo
		
		bDone = False
		iCode = 0
		sTableString = ""
		
		Set qasProWeb = Server.CreateObject("QAProWeb.QAProWeb.1")
		
		'Response.Write("Object created" & "<BR>")
		
		qasStatus = ""
		qasProWeb.Close
		
		'Response.Write("Close called" & "<BR>")
		
		iCode = qasProWeb.Open("QAProWeb", "")
		
		'Response.Write("Open called" & "<BR>")
		'Response.Write("iCode=" & iCode & "<BR>")
		
		If iCode < 0 Then
			
			'Response.Write("OPEN FAILED" & "<BR>" & "iCode=" & iCode & "<BR>" & "qasStatus=" & qasStatus & "<BR>")
			
			qasStatus = qasProWeb.ErrorMessage(iCode)
			'Response.Write("qasStatus=" & qasStatus & "<BR>")
				
			sTableString = CreateErrorString("!ERR!", CStr(iCode), qasStatus, "OPEN")
			'Response.Write("sTableString=" & sTableString & "<BR>")
				
		End If
						
		If iCode = 0 Then
			
			' SA: The ProWeb search is extremely restricting in the way it errors.
			' Wildcard searches may be used, but the following must be added to the configuration file (in our case C:\WinNT\system32\QAPROWEB.ini Under [QAProWeb] heading
			' AllowWildcardSearches=Yes
			
		   	'iCode = qasProWeb.Search("", "", "", "tw119?j")
		   	
		   	iCode = qasProWeb.Search(tkAddress1, tkSuburb, tkState, tkPostcode)
		   	
			'Response.Write("iCode=" & iCode & "<BR>")

			'If qasProWeb.ResultsCount < 0 Then iCode = qasProWeb.ResultsCount
			'Response.Write("qasProWeb.ResultsCount=" & qasProWeb.ResultsCount & "<BR>")		
			
			' SA: Error -9811 is a warning that the postcode has been recoded.  ie. changed by the Postal Service.
			' This error is not fatal, but usually requires a warning message, which I am not giving here.
		    
			If iCode = 0 Or iCode = -9811 Then
	    		lResultCount = CInt(tkOpenCount) + MAX_TABLE_LINES

				'Response.Write("qasProWeb.ResultsCount=" & qasProWeb.ResultsCount & "<BR>" & "PRE lResultCount=" & lResultCount & "<BR>")		

				If lResultCount > qasProWeb.ResultsCount Then 
					lResultCount = qasProWeb.ResultsCount
					bDone = True
				End If

				qasDataPlusCount = qasProWeb.DataPlusCount
				
				'Response.Write("qasProWeb.DataPlusCount=" & qasDataPlusCount & "<BR>" & "qasProWeb.ResultsCount=" & qasProWeb.ResultsCount & "<BR>" & "POST lResultCount=" & lResultCount & "<BR>" & "tkOpenCount=" & tkOpenCount & "<BR>")		

				If lResultCount > 0 Then
					For lCount = tkOpenCount To lResultCount - 1
						qasAddress = qasProWeb.Address(lCount)
						qasDataPlusLines = qasProWeb.DataPlus(lCount)
						If UBound(qasAddress) > 0 Then
						
							sRetAddress1=qasAddress(RET_ADD_LINE_1)
							sRetAddress2=qasAddress(RET_ADD_LINE_2)
							sRetAddress3=qasAddress(RET_ADD_LINE_3)
							sRetSuburb=qasAddress(RET_SUBURB)
							sRetState=qasAddress(RET_STATE)
							sRetPostcode=qasAddress(RET_POSTCODE)
	
							If qasDataPlusCount > 0 Then						
								sRetHlthRegionCode=qasDataPlusLines(RET_HLTH_REGION)
								sRetHlthAreaCode=qasDataPlusLines(RET_HLTH_AREA_CODE)
								'Response.Write "OK - qasDataPlusCount=" & qasDataPlusCount & "<BR>"	
								'Response.Write "HealthCode^" & sRetHlthAreaCode & "<BR>"
								'Response.Write "HealthName^" & sRetHlthAreaName & "<BR>"
							'Else
								'Response.Write "FAILED - UBound(qasDataPlusLines)=" & UBound(qasDataPlusLines) & "<BR>"								
							End If
							
							' SA: Note there is NO delimiter between Address Lines 2 & 3
							' These QAS fields will be concatenated, and saved as a single address field on Medtrak (AddressLine2)
							sRetSingleAddress = sRetAddress1 + "^" + sRetAddress2
							
							If Trim(sRetAddress3) <> "" Then
								sRetSingleAddress = sRetSingleAddress + " " + sRetAddress3
							End If
							
							sRetSingleAddress = sRetSingleAddress + "^" + sRetSuburb + "^" + sRetState + "^" + sRetPostcode + "^" + sRetHlthAreaCode + "^" + sRetHlthRegionCode + "^"
			  				
			  				sTableString = sTableString + sRetSingleAddress + "|"
			  									
		  				End If
					Next
				End If
			Elseif iCode = -9980 Then
				'Error -9980 indicates Too many matches
				sTableString = CreateErrorString("!WARN!", "", sTooManyMatches, "")
				
			Elseif iCode = -9978 Then
				'Error -9978 indicates No match
				'sTableString = ""
				sTableString = CreateErrorString("!WARN!", "", sNoMatchFound, "")
				'Response.Write("No Match" & "<BR>")
			
			Elseif iCode = -10000 Then
				'Error -10000 indicates Invalid characters
				'sTableString = ""
				sTableString = CreateErrorString("!WARN!", "", sInvalidChar, "")

			Elseif iCode < 0 Then
				'Response.Write("SEARCH FAILED" & "<BR>" & "iCode=" & iCode & "<BR>" & "qasStatus=" & qasStatus & "<BR>")

				qasStatus = qasProWeb.ErrorMessage(iCode)
				sTableString = CreateErrorString("!ERR!", CStr(iCode), qasStatus, "SEARCH")

				'Response.Write("sTableString=" & sTableString & "<BR>")
			End If
			
		End If

		qasProWeb.Close
		Set qasProWeb = Nothing

		If sTableString = "" Then
			' SA: "No QAS match found" is separate to the "No Match Found"
			' I suspect QAS is falling over for some reason. This error seems to only occur with specific search criteria (eg. "Bridgewood" records after page 2).
			sTableString = CreateErrorString("!WARN!", "", sNoQASMatch, "")
		Elseif sParams = "" Then
			sTableString = CreateErrorString("!WARN!", "", sBlankParam2, "")				
		End If

		Call CreateTable(sTableString, bDone, sParams)
		'Response.Write("qasStatus=" & qasStatus & "<BR>" & "sTableString=" & sTableString & "<BR>" & "sParams=" & sParams & "<BR>" & "END" & "<BR>")

		'Response.Write("</table>")

		Call CreateJavaStr
	End Sub

	Function CreateErrorString(sErrorType, sCode, sDesc, sEvent)
	'Creates an error string depending on error type
		Dim sErrorString
		Dim sErrParamStr

		If sErrorType = "!ERR!" Then
			sErrParamStr = "tkAddress1=" + tkAddress1 + " tkSuburb=" + tkSuburb + " tkState=" + tkState + " tkPostcode=" + tkPostcode + " tkField=" + tkField + " tkFromBroker=" + tkFromBroker + " tkOpenCount=" + CStr(tkOpenCount)
			
			sErrorString = sErrorType + "^" + sCode + "^" + sDesc + "^" + sEvent + "^" + sErrParamStr

			'Response.Write("ERR sErrorType=" & sErrorType & "<BR>" & "ERR sCode=" & sCode & "<BR>" & "ERR sDesc=" & sDesc & "<BR>" & "ERR sEvent=" & sEvent & "<BR>" & "ERR sErrParamStr=" & sErrParamStr & "<BR>" & "ERR sErrorString=" & sErrorString & "<BR>" & "ERR Len(sErrorString)=" & Len(sErrorString) & "<BR>")
			
		Elseif sErrorType = "!WARN!" Then
			sErrorString = sErrorType + "^" + sDesc 
		End If
		CreateErrorString = sErrorString + "^|"
	End Function


	Public Function mPiece(s1, sep, n)
	   'SA: Taken unedited from tkCommon.clstkFormat
	   
	   '+++ VB/Rig Skip +++
	    Dim pto 
	    Dim pfrom 
	    Dim k 
	    Dim S 

	    pto = 1 - Len(sep)
	    S = s1 & sep
	    mPiece = ""
	    For k = 1 To n
	        pfrom = pto + Len(sep)
	        pto = InStr(pfrom, S, sep)
	        If pto = 0 Then
	            Exit For
	        End If
	    Next
	    If pto = 0 Then
	        Exit Function
	    End If
	    mPiece = Mid(S, pfrom, pto - pfrom)
	End Function

	Function CreateTable(sTableString, bDone, ParamStr)
	'Accepts stream data in the following format:
	' Address1^Address2^Suburb^State^PostCode|....|....|...
	'It will display a lookup table showing all the items for selection. Once a selection is made, it will return in the format of 
	' PostCode^Suburb^State^Address1^Address2^HealthCareArea
	
		dim aSuburb,aState,aZip,aAddress1,aAddress2,aHlthCareArea,aHlthCareRegion 'storage array fields
		'dim ictr 'rows counter
		dim aRowField(200)
		dim iFirstPos, iNextPos  'Character position in the string
		dim temp, i
		dim iOpenCnt
		Dim sStripParamStr, iNextCnt, iPrevCnt, sNextParam, sPrevParam
		Dim sErr, sErrNo, sErrDesc, sErrEvent, sErrParam1, sErrParam2

		'Check if error or warning was send
		sErr = mPiece(sTableString, "^", 1)
		if sErr="!ERR!" then 
			sErrNo = mPiece(sTableString, "^", 2)
			sErrDesc = mPiece(sTableString, "^", 3)
			sErrEvent = mPiece(sTableString, "^", 4)
			sErrParam1 = mPiece(sTableString, "^", 5)
			sErrParam2 = mPiece(sTableString, "^", 6)
			Response.Write("<B>An error occured during the QAS search.<BR>Error Number: " & sErrNo & "<BR>Error Description: " & sErrDesc & "<BR>Error Event: " & sErrEvent & "<BR>Params: " & sErrParam1 & "!" & sErrParam2 & "</B>")
			exit function
		elseif sErr="!WARN!" then
		    sErrNo = mPiece(sTableString, "^", 2) 					
			Response.Write( "<B>" &  sErrNo & "</B>")
			exit function
		end if

		'Get the open count from ParamStr which is positioned at the far end of the string
		iFirstPos = instrrev(ParamStr,"^")
		sStripParamStr=""
		if iFirstPos <>  0 then
			sStripParamStr = Left(ParamStr, iFirstPos-1)
			iOpenCnt=mPiece(ParamStr, "^", 7)
		else
			iOpenCnt = 0
		end if	
			  		
		sStripParamStr = trim(sStripParamStr)

		'Get each line from the string and save it into array
		if trim(sTableString) <> "" then
			'Get the elements from the array and display
			i = 0
			ictr = 1
			do while  (mPiece(sTableString, "|", ictr) <> "")
				i = ictr - 1
				aRowField(i) = mPiece(sTableString, "|", ictr)
				ictr = ictr + 1
			loop 
			if aRowField(0) = "" then exit function
			ictr = i

			for i = 0 to ictr
				'Subscript for aRowField is zero based
				aAddress1 = mPiece(aRowField(i), "^", 1)
				aAddress2 = mPiece(aRowField(i), "^", 2)
				aSuburb = mPiece(aRowField(i), "^", 3)
				aState = mPiece(aRowField(i), "^", 4)
				aZip = mPiece(aRowField(i), "^", 5)
				aHlthCareArea=mPiece(aRowField(i), "^", 6)		' cjb 24/10/2005 56273 - the 6th piece was put into the aHlthCareArea variable, but this is saved as the HCRegion...  Given this piece a sensible name and added aHlthCareArea as the 7th piece, for the HCA
				aHlthCareRegion=mPiece(aRowField(i), "^", 7) 	'jjd Changed the piece name to be consistant with data provided
				'aHlthCareArea="zqas1 testing QAS HCA"			' testing
				'aHlthCareRegion="zqas1 testing QAS HCR"		' testing
				'KK just for testing
				'if trim(aHlthCareArea) = "" then 
				'	aHlthCareArea="Health Care Area"
				'end if
				'Response.Write  aZip & "^" & aHlthCareArea
				PString(i)= aZip & "^" & aSuburb & "^" & aState & "^" & aAddress1 & "^" & aAddress2 & "^" & aHlthCareArea & "^" & aHlthCareRegion
				temp= "<TR onclick=" & """RowSelect(" & i & ");""" & " onmousedown=" & """TR_OnMouseDown(" & i & ");""" & "><TD NOWRAP>" & aAddress1 & "</TD><TD NOWRAP>" & aAddress2 & "</TD><TD NOWRAP>" & aSuburb & "</TD><TD NOWRAP>" & aState & "</TD><TD NOWRAP>" & aZip & "</TD></TR>" & vbCrLf & vbCrLf
				Response.write (temp) 

			next 
			'Response.Write (ParamStr & "Open count=" & iOpenCnt & "<BR>")		
			if iOpenCnt = 0 then
				if Not bDone Then
					iNextCnt = iOpenCnt + MAX_TABLE_LINES 
					sNextParam = sStripParamStr & "^" & iNextCnt
					'Response.Write (sNextParam & "Open count=" & iOpenCnt & "Next count=" & iNextCnt & "<BR>")
					'Response.Write("<Table><TR onclick=" & "NextPage();><A href='" & "tkQASInterface.asp" & "?" & "ParamStr=" & sNextParam & "'><img id=" & "NPage" & " border=" & "0" & " alt=" & "Next page" & " src=" & "..\images\websys\pagenext.gif" & "></A></TR></Table>")
					Response.Write("<Table><TR><TD onclick=" & """NextPage();""" & "><A href='" & "tkQASInterface.asp" & "?" & "ParamStr=" & sNextParam & "'><img id=" & "NPage" & " border=" & "0" & " alt=" & "Next page" & " src=" & "..\images\websys\pagenext.gif" & "></A></TD></TR></Table>" & vbCrLf)
				End If
			elseif iOpenCnt > 0 then
		    	iPrevCnt = iOpenCnt - MAX_TABLE_LINES
  				sPrevParam = sStripParamStr & "^" & iPrevCnt
				'Response.Write("<TABLE><TR><TD onclick=" & "PrevPage();" & "><A href='" & "tkQASInterface.asp" & "?" & "ParamStr=" & sPrevParam & "'><img alt src=""" & "..\images\websys\pageprev.gif" & """></TD>")
				Response.Write("<Table><TR><TD onclick=" & """PrevPage();""" & "><A href='" & "tkQASInterface.asp" & "?" & "ParamStr=" & sPrevParam & "'><img id=" & "PPage" & " border=" & "0" & " alt=" & "Previous page" & " src=" & "..\images\websys\pageprev.gif" & "></A></TD>" & vbCrLf)
				if Not bDone Then
					iNextCnt = iOpenCnt + MAX_TABLE_LINES
					sNextParam = sStripParamStr & "^" & iNextCnt
					'Response.Write("<TD onclick=" & "NextPage();" & "><A href='" & "tkQASInterface.asp" & "?" & "ParamStr=" & sNextParam & "'><img alt src=""" & "..\images\websys\pagenext.gif" & """></TD></TR></Table>")
					Response.Write("<TD onclick=" & """NextPage();""" & "><A href='" & "tkQASInterface.asp" & "?" & "ParamStr=" & sNextParam & "'><img id=" & "NPage" & " border=" & "0" & " alt=" & "Next page" & " src=" & "..\images\websys\pagenext.gif" & "></A></TD></TR></Table>" & vbCrLf)
				End If
			end if
		else
			'Res=Msgbox ("Passed item cannot be blank",,"Error")
		end if
	End Function

	Sub CreateJavaStr
		'response.Write("Java String" & "<BR>")

		dim sTempString 
		response.Write("</table><BR>" & vbCrLf & vbCrLf)
		response.Write("<SCRIPT Language=""JavaScript"">" & vbCrLf)
		response.Write("var JString=new Array();" & vbCrLf)
		for j=0 to UBound(PString)
			'Response.Write("PString = " & j & " > " & PString(j) & "<BR>" & vbCrLf)
			if PString(j)="" then
				exit for
			end if
			'Check if the string contains quotes and put a backslash if found
			sTempString = Replace(PString(j),"'","\'")
			'response.Write("JString[" & j & "]='" & PString(j) & "';")
			response.Write("JString[" & j & "]='" & sTempString & "';" & vbCrLf)
		next
		Response.Write ("var Nrows='" & ictr & "';" & vbCrLf)
		response.Write("</SCRIPT>" & vbCrLf)
	End Sub

%>

<SCRIPT Language="JavaScript">
//Inherited from normal Lookups

if (window.name!="TRAK_hidden") this.focus();
var selectedrow=-1;
var isSelected=0; 
try { 
	var maxrows=Nrows;  //<%= ictr %>;
} catch(e) {};

//var maxrows=18;
//var maxrows = JString.length - 1;

function TR_OnMouseDown(row) {
	if (selectedrow>-1) {
		RowUnHighlight(selectedrow);
	}
	selectedrow=row;
	RowHighlight(selectedrow);
}
function OnKeyDownHandler(e) {
	if (maxrows>-1) {
		var eKey=websys_getKey(e);
		switch (eKey) {
		case 9: //Don't allow to tab off lookup table - therefore select
			RowSelect(selectedrow);
			break;
		case 13: //Enter select
			RowSelect(selectedrow);
			break;
		case 33: //Page Up
			PrevPage();
			break;
		case 34: //Page Down
			NextPage();
			break;
		case 35: //End
			//var ilength = JString.length;
			//alert("rows=" + ilength);
			//alert("content=" + JString[ilength-1]);
			try {
				RowUnHighlight(selectedrow);
				selectedrow=maxrows;
				RowHighlight(selectedrow);
			} catch(e) {
				//RowHighlight(ilength-1);
				RowHighlight(selectedrow-1);
			};
			break;
		case 36: //Home
			try {
				RowUnHighlight(selectedrow);
				selectedrow=0;
				RowHighlight(selectedrow);
			} catch(e) {};
			break;
		case 38: //Cursor up
			if (selectedrow>0) {
				RowUnHighlight(selectedrow);
				selectedrow-=1;
				RowHighlight(selectedrow);
			}
			break;
		case 40: //Cursor down
			// RQG, This line is commented out as Nrows is not giving the right value for some reason and was replaced by the next line.    
			//if (selectedrow<maxrows) { 

			if (selectedrow <= (maxrows-1)) {
				try {
					RowUnHighlight(selectedrow);
					selectedrow+=1;
					RowHighlight(selectedrow);
				}
				catch(e) {RowHighlight(selectedrow-1);}; //Force to highlight the last row
			}
			break;
		} //switch
	} 
}
function RowHighlight(row) {
	var eTR=document.getElementById('tblLookup').rows[row];
	eTR.className='clsLookUpSelected';
	selectedrow=row;
}
function RowUnHighlight(row) {
	var eTR=document.getElementById('tblLookup').rows[row];
	eTR.className='';
}
function docHandler() {
	
	// cjb 09/01/2006 59107
	var iCode=<%= iCode %>;
	var tkFromBroker=<%= tkFromBroker %>;
	var lResultCount=<%= lResultCount %>;
	//alert(<%= lResultCount %>);
	
	// if called from the broker and only one result returned, populate the address fields
	if (tkFromBroker==1) {
		if ((lResultCount==1)&&(iCode==0)) {PopulateMain(lResultCount)};
		else { BrokerFail();};
	}
	
	websys_reSizeT();
}
//window.onload=CreateandShowTable("1^2^3^4^5^|","1")  //docHandler;
//Window.onload=docHandler;

try { 
	RowHighlight(0);
} catch(e) {}; 

//document.onkeydown=OnKeyDownHandler; 
function RowSelect(row) { 
	//alert(JString[row]);
	var par_win=window.opener; 
	par_win.QAS_ZipLookupSelect(JString[row]); 
	isSelected=1; 
	window.close(); 
}

// cjb 09/01/2006 59107
var qaswin="<%= Request("QASWIN") %>";
function PopulateMain(row) { 
	row=row-1;
	if (row!=0) return;
	//alert(JString[row]);
	
	if (qaswin=="") {
		var win=window.top.frames['TRAK_main']; 
	} else {
		var win=window.open('',qaswin);
	}
	
	win.QAS_ZipLookupSelect(JString[row]); 
	
	isSelected=1; 
} 

// cjb 09/01/2006 59107
function BrokerFail() { 
	if (qaswin=="") {
		var win=window.top.frames['TRAK_main']; 
	} else {
		var win=window.open('',qaswin);
	}
	
	win.QAS_BrokerFail(); 
	
	isSelected=1; 
} 


function PrevPage() { 
	isSelected=1;
	try {
		var obj = document.getElementById("PPage");
		obj.click(); 
	} catch(e) {};
} 
function NextPage() { 
	isSelected=1;
	try {
		var obj = document.getElementById("NPage");
		obj.click();
	} catch(e) {};
} 
function RegainFocus() { 
	if (!isSelected) { 
		try { 
			var par_win=window.opener; 
			par_win.websys_setfocus('CTCITDesc'); 
		} catch(e) {}; 
	} 
} 
window.onload=docHandler;
document.body.onunload=RegainFocus; 
document.onkeydown=OnKeyDownHandler; 
</Script>
</TD></TR></TABLE>
</BODY>
</HTML>
