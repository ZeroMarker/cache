Class ext.epr.Chart Extends (%Library.Persistent, websys.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 1752;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "Name";

Parameter SQLDESCRIPTION = "Name";

Parameter SQLROWID = "ID";

/// This field stores the information, in the following format in a List.
/// itemID,itemType,Rows,Sequence
Property ChartSettings As list Of epr.ChartItem;

Property Name As %String(COLLATION = "ALPHAUP", TRUNCATE = 1);

Property Student As %Library.Boolean;

Property IsHistoryPage As %Library.Boolean;

Property DisplayConsultBanner As %Library.Boolean;

Property ChartColour As %Library.String(TRUNCATE = 1);

Property TextColour As %Library.String(TRUNCATE = 1);

Property SELChartColour As %Library.String(TRUNCATE = 1);

Property SELTextColour As %Library.String(TRUNCATE = 1);

/// Index for property Name
Index NameIndex On Name;

/// ab 24.03.06 58654
ClassMethod CopyChart(ID As %String = "", Name As %String = "")
{
}

ClassMethod CanMarkAsRead(EpisodeID As %Library.String, userid As %Library.String, OrderID As %Library.String = "") As %Library.String
{
}

ClassMethod CanMarkItemAsRead(OrderID As %Library.String = "", GroupID As %Library.String = "") As %Library.String
{
}

ClassMethod ItemsFindClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = ItemsFindFetch ]
{
}

ClassMethod ItemsFindExecute(ByRef QHandle As %Library.Binary, ChartID As %Library.String) As %Library.Status
{
}

ClassMethod ItemsFindFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = ItemsFindExecute ]
{
}

ClassMethod UnreadResults(episodeid As %Library.String, mradm As %Library.String, ByRef unread As %Library.List) As %Library.Boolean
{
}

ClassMethod UnreadResultsInChart(ChartID As %Library.String, ByRef unread As %Library.List) As %Library.Boolean
{
}

/// KM Feb-2001
ClassMethod chartSettingsDelete(ChartID As %String, itemIdx As %String)
{
}

/// KM 20-Feb-2001
ClassMethod chartSettingsInsert(ByRef cs As %Library.List, ItemID As %Library.String, ItemType As %Library.String)
{
}

/// KM 7-Mar-2001: Called from both epr.chart.csp AND epr.eprgraph.csp
ClassMethod chartSettingsSelect(ByRef itmLIST As %Library.List, ByRef params As %Library.String, cs As %Library.String)
{
}

/// KM 13-Mar-2001
ClassMethod chartSettingsSort(ByRef obj As %Library.String, ChartID As %Library.String = "")
{
}

/// YC - epr.chart.csp got too big. Moved half the code to this method.
ClassMethod ChartDisplay()
{
}

/// KM 4-Oct-2001: Called from the class methods websysBeforeSave() for any saves which 
/// may reload the EPR Chart Page after an update.
ClassMethod getEPRChartPage(ChartID As %Library.String) As %Library.String
{
}

/// KM 7-Nov-2001: Called From epr.ChartItem.Edit component
ClassMethod getGraph(ChartID As %Library.String, ItemID As %Library.String, Type As %Library.String)
{
}

/// AI 01-Jul-2002: Called From epr.ChartHeading.Edit component
ClassMethod getHeading(ChartID As %Library.String, ItemID As %Library.String, Type As %Library.String, delim As %Library.String = {$c(13,10)}) As %Library.String
{
}

ClassMethod getExpression(ChartID As %Library.String, ItemID As %Library.String, Type As %Library.String) As %Library.String
{
}

/// KM 7-Nov-2001: Called From epr.ChartItem.Edit component
ClassMethod insertGraph(ChartID As %Library.String, ItemID As %Library.String)
{
}

/// AI 01-Jul-2002: Called From epr.ChartHeading.Edit component
ClassMethod insertHeading(ChartID As %Library.String, ItemID As %Library.String)
{
}

ClassMethod insertExpression(ChartID As %Library.String, ItemID As %Library.String)
{
}

/// KM 13-Mar-2001: Called From epr.Chart.Edit component
ClassMethod websysSave(compref As %Library.String, ChartID As %Library.String)
{
}

Query Find(name As %Library.String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "id,name:%String")
{
SELECT ID, Name
FROM epr.Chart
WHERE (Name %STARTSWITH :name)
}

/// Log 55973 - PJC - 20-12-2005 : Add the "Only show entries marked for DS Report" checkbox.
Query ItemsFind(ChartID As %String) As %Library.Query(CONTAINID = 1, ROWSPEC = "index,ItemID:%String,ItemType:%String,ItemDesc:%String,DisplayHeader:%Boolean,DisplayAddButton:%Boolean,Sequence:%String,Rows:%Integer,graph:%String,heading:%String,HeadingDisplay:%String,Collapse:%Library.Boolean,ColumnWidth:%Library.Integer,AcrossEpisodes:%Boolean,OnlyMarkedForDSReport:%Boolean")
{
}

Query VBFindLE(desc As %Library.String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,Description:%Library.String")
{
SELECT	ID, Name
FROM	epr.Chart
WHERE	(Name %STARTSWITH :desc)
ORDER	BY Name
}

/// 20140428
ClassMethod RedirctWorkFlowByChart(ChartID, ChartCode, WorkFlowCodeDesc, chLINK)
{
	new (ChartID,ChartCode,WorkFlowCodeDesc,chLINK,%session,%request)
	
	Set ChartCodeId=$O(^ooChartI("NameIndex",ChartCode,""))
	Quit:ChartID'=ChartCodeId chLINK
	
	Set WKFL=##Class(websys.WorkFlow).GetIdFromCodeOrDescription(WorkFlowCodeDesc)
	Set newwkfl="&TWKFL="_WKFL_"&TWKFLI="
	Set newhrefstr=$P(chLINK,"&TWKFL=",1)_newwkfl
	Set newhrefstr=$P(newhrefstr,"epr.chart.csp",1)_"websys.csp"_$P(newhrefstr,"epr.chart.csp",2)
	Set chLINK=newhrefstr
	Quit chLINK
}

/// cspname --> ##class(web.Test).CspPage()_"?act=pott"
ClassMethod GetCSPName(ChartID As %String, PatientID = "", EpisodeID = "", mradm = "")
{
	if (ChartID>0){
		s tmpChartObj = ##class(epr.Chart).%OpenId(ChartID,0)
		i tmpChartObj.ChartSettings.Count()>0 {
			s CTProfileParamsType = tmpChartObj.ChartSettings.GetAt(1).ItemType
			s CTProfileParamsId = tmpChartObj.ChartSettings.GetAt(1).Item
			s paramsObj = ##class(epr.CTProfileParams).%OpenId(CTProfileParamsId,0)	
			i $IsObject(paramsObj)&&(CTProfileParamsType="CSPNAME") {
				s cspname = $p(paramsObj.PPParameters,"^",1)
				s csprefresh = $p(paramsObj.PPParameters,"^",2)
				if csprefresh>0{
					if $zcvt(cspname,"L")["##class("{
						Set %request.Data("PatientID",1)=PatientID
						Set %request.Data("EpisodeID",1)=EpisodeID
						Set %request.Data("mradm",1)=mradm
						x "set cspname="_cspname
					}
				}
				d paramsObj.%Close()
				s paramsObj= ""
				Quit cspname
			}
		}	
	}
	Quit ""
}

ClassMethod RedirctCharURL(ChartID As %String, chLINK As %String) As %String
{
	Set cspname = ..GetCSPName(ChartID)
	i (cspname["?"){
		s newhrefstr=$P(chLINK,"epr.chart.csp?",1)_"websys.csp?TDIRECTPAGE="_$tr(cspname,"?","&")_"&"_$P(chLINK,"epr.chart.csp?",2)
	}else{
		s newhrefstr=$P(chLINK,"epr.chart.csp",1)_"websys.csp?TDIRECTPAGE="_cspname_"&"_$e($P(chLINK,"epr.chart.csp",2),2,)
	}			
	s chLINK=newhrefstr
	;add 2013/05/14 在普通图表组加入cspname类型的chart
	/*s tmpChartObj = ##class(epr.Chart).%OpenId(ChartID,0)
	i tmpChartObj.ChartSettings.Count()>0 {
		s CTProfileParamsType = tmpChartObj.ChartSettings.GetAt(1).ItemType
		s CTProfileParamsId = tmpChartObj.ChartSettings.GetAt(1).Item
		s paramsObj = ##class(epr.CTProfileParams).%OpenId(CTProfileParamsId,0)	
		i $IsObject(paramsObj)&&(CTProfileParamsType="CSPNAME") {
			s cspname = $p(paramsObj.PPParameters,"^",1)
			s csprefresh = $p(paramsObj.PPParameters,"^",2)
			d paramsObj.%Close()
			s paramsObj= ""
			i (cspname["?"){
				s newhrefstr=$P(chLINK,"epr.chart.csp?",1)_"websys.csp?TDIRECTPAGE="_$tr(cspname,"?","&")_"&"_$P(chLINK,"epr.chart.csp?",2)
			}else{
				s newhrefstr=$P(chLINK,"epr.chart.csp",1)_"websys.csp?TDIRECTPAGE="_cspname_"&"_$e($P(chLINK,"epr.chart.csp",2),2,)
			}			
			s chLINK=newhrefstr
		}
	}*/
	///医嘱录入
	set chLINK = ..RedirctWorkFlowByChart(ChartID,"DHCOE","DHC.Doc.OrderEntry",chLINK)
	//
	set chLINK = ..RedirctWorkFlowByChart(ChartID,"DHCOECM","DHC.Doc.OP.OrderEntry.CM",chLINK)
	//西医诊断
	set chLINK = ..RedirctWorkFlowByChart(ChartID,"DHCEPRMRDIAGNOS","DHC.MRDiagnos.Edit",chLINK)
	
	set chLINK = ..RedirctWorkFlowByChart(ChartID,"DHCEPRMRDIAGNOSCM","DHC.MRDiagnos.CM.Edit",chLINK)
	//新西医诊断
	set chLINK = ..RedirctWorkFlowByChart(ChartID,"DHCMEDICINEMRDIAGNOS","DHCMRDiagnosNew",chLINK)
	//
	set chLINK = ..RedirctWorkFlowByChart(ChartID,"DHCEPRHLD","DHC.Doc.OP.OrderEntry.HLD",chLINK)
	//检查
	set chLINK = ..RedirctWorkFlowByChart(ChartID,"DHCOEJC","DHC.Doc.OrderEntry.JC",chLINK)
	//华西检查录入
	set chLINK = ..RedirctWorkFlowByChart(ChartID,"DHCOELAB","DHC.Doc.OrderEntry.LAB",chLINK)

	//检验
	set chLINK = ..RedirctWorkFlowByChart(ChartID,"DHCOEHY","DHC.Doc.OrderEntry.HY",chLINK)
	//治疗
	set chLINK = ..RedirctWorkFlowByChart(ChartID,"DHCOEZL","DHC.Doc.OrderEntry.ZL",chLINK)
	//新本次医嘱
	set chLINK = ..RedirctWorkFlowByChart(ChartID,"THEOELIST","DHC.OEORD.List",chLINK)
	;set chLINK = ..RedirctWorkFlowByChart(ChartID,"RETURN","",chLINK)
	Quit chLINK
}

/// w ##class(ext.epr.Chart).ShowChartJson(12,"")
ClassMethod ShowChartJson(ChartBookID As %String, ChartType As %String, PatientID As %String, EpisodeID As %String, EpisodeIDs As %String, mradm As %String, apptID As %String, ConsultID As %String, PAAdmTransactionID As %String, OperRoomID As %String, DischID As %String, CurrDischID As %String, DischEpisodes As %String, doctype As %String, TWKFL As %String, TWKFLI As %String) As %String [ ProcedureBlock = 0 ]
{
	
	n ChartID,ChartName,count,obj,jh,lst,unread,cmp
	s ChartID="",jh=0,count=0,unread="",myjosnstr=""

	s obj=##Class(epr.ChartBook).%OpenId(ChartBookID,0)
	//i 'obj w $p($g(t("NoChartBook"),"No ChartBook selected"),"^",1)
	i obj {
		if ChartType="L" {
			s lst=obj.LeftChartList
		} else {
			s lst=obj.ChartList
		}
		s TimeLine=obj.ShowTimeline
		s count=lst.Count()
		//i count=0 w $p($g(t("NoChartItems"),"No charts within ChartBook selected"),"^",1)
		s unreadexists=##class(epr.Chart).UnreadResults(EpisodeID,mradm,.unread)
		f jh=1:1:count {
			i lst.GetAt(jh) {
			  s ChartID=lst.GetAt(jh).%Id()
			  i (ShowCharts="")!((","_ShowCharts_",")[(","_ChartID_",")) {
				s ChartType = ""
				n chrt
				s chrt=##class(epr.Chart).%OpenId(ChartID),IsHistPage=0,(ChartColour,TextColour)=""
				i chrt d
				. s IsHistPage=chrt.IsHistoryPage
				. ; 51477
				. s ChartColour=chrt.ChartColour
				. s TextColour=chrt.TextColour
				. s SELChartColour=chrt.SELChartColour
				. s SELTextColour=chrt.SELTextColour
				. s:chrt.ChartSettings.Count()>0 ChartType = chrt.ChartSettings.GetAt(1).ItemType
				. d chrt.%Close()
				;continue:((ChartType="DHPE")||(ChartType="DHPERis"))&&(##class(web.DHCPE.Public.Setting).ShowChartPage(EpisodeID,ChartID)=0)

				s ChartName=##Class(websys.TranslationEPR).GetTrans("epr.Chart","Name",$g(%session.Data("LOGON.LANGID")),lst.GetAt(jh).Name)
				i IsHistPage {
					s chLINK="epr.chart.csp?PatientID="_PatientID_"&EpisodeID="_EpisodeID_"&EpisodeIDs="_EpisodeIDs_"&mradm="_mradm_"&ChartID="_ChartID_"&apptID="_apptID_"&ConsultID="_ConsultID_"&ConsultEpisodeID="
				} else  {
					s chLINK="epr.chart.csp?PatientID="_PatientID_"&EpisodeID="_EpisodeID_"&EpisodeIDs="_EpisodeIDs_"&mradm="_mradm_"&ChartID="_ChartID_"&PAAdmTransactionID="_PAAdmTransactionID_"&OperRoomID="_OperRoomID_"&DischID="_DischID_"&CurrDischID="_CurrDischID_"&DischEpisodes="_DischEpisodes_"&doctype="_$zcvt(doctype,"O","HTML")_"&TWKFL="_TWKFL_"&TWKFLI="_TWKFLI_"&TimeLine="_TimeLine_"&ConsultID="_ConsultID_"&ConsultEpisodeID="
				}
				s chLINK=..RedirctCharURL(ChartID,chLINK)
				s chLINK=chLINK_"&Random=2"
				
				s:(myjosnstr'="") myjosnstr=myjosnstr_","
				set myjosnstr=myjosnstr_"{"
				set myjosnstr=myjosnstr_"id:"""_ChartID_""","
				set myjosnstr=myjosnstr_"title:"""_ChartName_""","
				if ChartType="CSPNAME" {
					s CTProfileParamsId = chrt.ChartSettings.GetAt(1).Item
					s paramsObj = ##class(epr.CTProfileParams).%OpenId(CTProfileParamsId,0)	
					i $IsObject(paramsObj) {
						s csprefresh = $p(paramsObj.PPParameters,"^",2)
						if csprefresh="0"{
							Set myjosnstr=myjosnstr_"csprefresh:false,"
						}else{
							Set myjosnstr=myjosnstr_"csprefresh:true,"
						}
						d paramsObj.%Close()
						s paramsObj= ""
					}
				}else{
					Set myjosnstr=myjosnstr_"csprefresh:true,"
				}
				//set myjosnstr=myjosnstr_"iconCls:""icon-by-category"","
				set myjosnstr=myjosnstr_"autoLoad:{url:"""_chLINK_""",scripts:true}"
				
				set myjosnstr=myjosnstr_"}"
									
				/*
				w "<DIV class='chartitem' id='chart",ChartID,"' onclick='SelectChart(this);' "
				w " ChartColour='"_ChartColour_"' TextColour='"_TextColour_"'"
				w " SELChartColour='"_SELChartColour_"' SELTextColour='"_SELTextColour_"'"
				// Log 58796 YC - New line according to TN's changes
				w " style='" w:ChartColour'="" "BACKGROUND-COLOR:"_ChartColour_";" w:TextColour'="" "COLOR:"_TextColour_";" w "' "
				i IsHistPage d
				. // Log 58796 YC - Replace code according to TN's changes
				. ; Log 59791 YC - Both links now goto epr.chart.csp which decides whether or not to redirect to epr.clinicalhistory.csp
				. w " chLINK='epr.chart.csp?PatientID=",PatientID,"&EpisodeID=",EpisodeID,"&EpisodeIDs=",EpisodeIDs,"&mradm=",mradm,"&ChartID=",ChartID,"&apptID=",apptID,"&ConsultID=",ConsultID,"&ConsultEpisodeID=' >"
				e  d
				. // Log 58796 YC - Replace code according to TN's changes
				. w " chLINK='epr.chart.csp?PatientID=",PatientID,"&EpisodeID=",EpisodeID,"&EpisodeIDs=",EpisodeIDs,"&mradm=",mradm,"&ChartID=",ChartID,"&PAAdmTransactionID=",PAAdmTransactionID,"&OperRoomID=",OperRoomID,"&DischID=",DischID,"&CurrDischID=",CurrDischID,"&DischEpisodes=",DischEpisodes,"&doctype=",$zcvt(%request.Get("doctype"),"O","HTML"),"&TWKFL=",%request.Get("TWKFL"),"&TWKFLI=",%request.Get("TWKFLI"),"&TimeLine=",TimeLine,"&ConsultID=",ConsultID,"&ConsultEpisodeID='>"
				s unreadresults=0
				i unreadexists s unreadresults=##class(epr.Chart).UnreadResultsInChart(ChartID,.unread)
				i unreadresults w "<b>"_ChartName_"</b>"
				i 'unreadresults w ChartName
				w "</a>"
				w "</div>",$c(13,10)
				*/
			  }
			}
		}

	}
		
	d obj.%Close()
	s myjosnstr="["_myjosnstr_"]"
	q myjosnstr
}

/// w ##class(ext.epr.Chart)ShowNoEpisodeChartJson(12,"")
ClassMethod ShowNoEpisodeChartJson(ChartBookID As %String, ChartType As %String, PatientID As %String, EpisodeID As %String, EpisodeIDs As %String, mradm As %String, apptID As %String, ConsultID As %String, PAAdmTransactionID As %String, OperRoomID As %String, DischID As %String, CurrDischID As %String, DischEpisodes As %String, doctype As %String, TWKFL As %String, TWKFLI As %String) As %String [ ProcedureBlock = 0 ]
{
	
	n ChartID,ChartName,count,obj,jh,lst,unread,cmp
	s ChartID="",jh=0,count=0,unread="",myjosnstr=""

	s obj=##Class(epr.ChartBook).%OpenId(ChartBookID,0)
	//i 'obj w $p($g(t("NoChartBook"),"No ChartBook selected"),"^",1)
	i obj {
		if ChartType="L" {
			s lst=obj.LeftChartList
		} else {
			s lst=obj.ChartList
		}
		s TimeLine=obj.ShowTimeline
		s count=lst.Count()
		//i count=0 w $p($g(t("NoChartItems"),"No charts within ChartBook selected"),"^",1)
		s unreadexists=##class(epr.Chart).UnreadResults(EpisodeID,mradm,.unread)
		f jh=1:1:count {
			i lst.GetAt(jh) {
			  s ChartID=lst.GetAt(jh).%Id()
			  ;s flag=##class(web.DHCPE.Public.Setting).ShowChartPage(EpisodeID,ChartID)
			  ;continue:flag=0
			  i (ShowCharts="")!((","_ShowCharts_",")[(","_ChartID_",")) {
				;s ChartName=lst.GetAt(jh).Name
				n chrt
				s chrt=##class(epr.Chart).%OpenId(ChartID),IsHistPage=0,(ChartColour,TextColour)=""
				i chrt d
				. s IsHistPage=chrt.IsHistoryPage
				. ; 51477
				. s ChartColour=chrt.ChartColour
				. s TextColour=chrt.TextColour
				. s SELChartColour=chrt.SELChartColour
				. s SELTextColour=chrt.SELTextColour
				. d chrt.%Close()
				s ChartName=##Class(websys.TranslationEPR).GetTrans("epr.Chart","Name",$g(%session.Data("LOGON.LANGID")),lst.GetAt(jh).Name)
				i IsHistPage {
					s chLINK="epr.dhcwmr.chart.csp?PatientID="_PatientID_"&EpisodeID="_EpisodeID_"&EpisodeIDs="_EpisodeIDs_"&mradm="_mradm_"&ChartID="_ChartID_"&apptID="_apptID_"&ConsultID="_ConsultID_"&ConsultEpisodeID="
				} else  {
					s chLINK="epr.dhcwmr.chart.csp?PatientID="_PatientID_"&EpisodeID="_EpisodeID_"&EpisodeIDs="_EpisodeIDs_"&mradm="_mradm_"&ChartID="_ChartID_"&PAAdmTransactionID="_PAAdmTransactionID_"&OperRoomID="_OperRoomID_"&DischID="_DischID_"&CurrDischID="_CurrDischID_"&DischEpisodes="_DischEpisodes_"&doctype="_$zcvt(doctype,"O","HTML")_"&TWKFL="_TWKFL_"&TWKFLI="_TWKFLI_"&TimeLine="_TimeLine_"&ConsultID="_ConsultID_"&ConsultEpisodeID="
				}
				//s chLINK=..RedirctCharURL(ChartID,chLINK)
				s chLINK=chLINK_"&Random=2"
				s:(myjosnstr'="") myjosnstr=myjosnstr_","
				set myjosnstr=myjosnstr_"{"
				set myjosnstr=myjosnstr_"id:"""_ChartID_""","
				set myjosnstr=myjosnstr_"title:"""_ChartName_""","
				//set myjosnstr=myjosnstr_"iconCls:""icon-by-category"","
				set myjosnstr=myjosnstr_"autoLoad:{url:"""_chLINK_""",scripts:true}"
				
				set myjosnstr=myjosnstr_"}"
						
			  }
			}
		}

	}
		
	d obj.%Close()
	s myjosnstr="["_myjosnstr_"]"
	q myjosnstr
}

Storage Default
{
<Data name="ChartDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ChartColour</Value>
</Value>
<Value name="3">
<Value>ChartSettings</Value>
</Value>
<Value name="4">
<Value>DisplayConsultBanner</Value>
</Value>
<Value name="5">
<Value>IsHistoryPage</Value>
</Value>
<Value name="6">
<Value>Name</Value>
</Value>
<Value name="7">
<Value>SELChartColour</Value>
</Value>
<Value name="8">
<Value>SELTextColour</Value>
</Value>
<Value name="9">
<Value>Student</Value>
</Value>
<Value name="10">
<Value>TextColour</Value>
</Value>
</Data>
<DataLocation>^ext.epr.ChartD</DataLocation>
<DefaultData>ChartDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^ext.epr.ChartD</IdLocation>
<IndexLocation>^ext.epr.ChartI</IndexLocation>
<StreamLocation>^ext.epr.ChartS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
