Class EMRservice.entity.EInstanceIndex Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "InstanceIndex";

Parameter XMLSEQUENCE = 1;

Property ID As %String(XMLNAME = "ID", XMLREF = 1) [ Required ];

Property HappenDateTime As %String(XMLNAME = "HappenDateTime", XMLREF = 1) [ Required ];

Property DateTimeFormat As %String(XMLNAME = "DateTimeFormat", XMLREF = 1) [ Required ];

Property Title As %String(XMLNAME = "Title", XMLREF = 1) [ Required ];

//Property UserID As %String(XMLNAME = "UserID", XMLREF = 1) [ Required ];

//Property UserName As %String(XMLNAME = "UserName", XMLREF = 1) [ Required ];

Property StartPageNum As %String(XMLNAME = "StartPageNum", XMLREF = 1) [ Required ];

Property StartRowNum As %String(XMLNAME = "StartRowNum", XMLREF = 1) [ Required ];

Property EndPageNum As %String(XMLNAME = "EndPageNum", XMLREF = 1) [ Required ];

Property EndRowNum As %String(XMLNAME = "EndRowNum", XMLREF = 1) [ Required ];

Property PageBreak As %String(XMLNAME = "PageBreak", XMLREF = 1) [ Required ];

Property Notes As %String(MAXLEN = "", XMLNAME = "Notes", XMLREF = 1) [ Required ];

}
