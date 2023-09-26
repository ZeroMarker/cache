/// CTOR: QP
/// DATE: 2021-08-04
/// DESC: ASynAntiRt
Class DHCAnt.Serve.Model.ASynAntiRt Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "SynAntiRt";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Property phyNum As %String(MAXLEN = 32767, TRUNCATE = 1, XMLNAME = "phyNum");

Property permissionsNum As %String(MAXLEN = 32767, TRUNCATE = 1, XMLNAME = "permissionsNum");

Property visittype As %String(MAXLEN = 32767, TRUNCATE = 1, XMLNAME = "visittype");

Property permissiontype As %String(MAXLEN = 32767, TRUNCATE = 1, XMLNAME = "permissiontype");

Property ischeck As %String(MAXLEN = 32767, TRUNCATE = 1, XMLNAME = "ischeck");

Property type As %String(MAXLEN = 32767, TRUNCATE = 1, XMLNAME = "type");

Property hospitalcode As %String(MAXLEN = 32767, TRUNCATE = 1, XMLNAME = "hospitalcode");

Property OperateUser As %String(MAXLEN = 32767, TRUNCATE = 1, XMLNAME = "OperateUser");

}
