Class web.DHCEkg.HX.Dict.LogonResponse Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "Response";

/// 用户表rowid
Property RowId As %String;

/// 用户工号
Property SSUSRInitials As %String;

/// 姓名
Property Name As %String;

/// 默认登陆科室
Property DeptDR As %String;

/// 编码
Property code As %String;

}
