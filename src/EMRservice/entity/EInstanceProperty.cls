Class EMRservice.entity.EInstanceProperty Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "InstanceProperty";

Parameter XMLSEQUENCE = 1;

Property TemplateType As %String(XMLNAME = "TemplateType", XMLREF = 1) [ Required ];

Property Editor As %String(XMLNAME = "Editor", XMLREF = 1) [ Required ];

Property IsMutex As %String(XMLNAME = "IsMutex", XMLREF = 1) [ Required ];

Property IsLeadframe As %String(XMLNAME = "IsLeadframe", XMLREF = 1) [ Required ];

Property LastModifyPosition As %String(MAXLEN = "", XMLNAME = "LastModifyPosition", XMLREF = 1) [ Required ];

}
