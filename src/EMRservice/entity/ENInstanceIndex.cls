Class EMRservice.entity.ENInstanceIndex Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "NInstanceIndex";

Parameter XMLSEQUENCE = 1;

Property InstanceProperty As EMRservice.entity.EInstanceProperty(XMLNAME = "InstanceProperty", XMLPROJECTION = "ELEMENT", XMLREF = 1) [ Required ];

Property InstanceIndex As list Of EMRservice.entity.EInstanceIndex(XMLNAME = "InstanceIndex", XMLPROJECTION = "ELEMENT", XMLREF = 1) [ Required ];

}
