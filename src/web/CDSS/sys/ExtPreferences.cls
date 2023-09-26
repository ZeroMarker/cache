Class web.CDSS.sys.ExtPreferences Extends web.CDSS.sys.Preferences [ ProcedureBlock ]
{

ClassMethod SaveAuthorizeData(ObjectType As %String, ObjectReference As %String, Data As %String) As %String
{
	s flag=""
	s flag = ..DHCSaveDataToServer(ObjectType,ObjectReference,Data)
	if (flag=0){
		s result = "{msg:"_flag_"}"
	}else{
		s result = "{msg:"_flag_"}"
	}
	q result
}

/// 一级授权中获取Tree类型的json串, 界面的控件也可以是Grid
/// ParentID： 父ID
/// ObjectType: 需要显示的优先级类别
/// ObjectReference： 在界面上 选择的 Group或者User或者CTLoc(登录科室)
ClassMethod GetTreeJson(ParentID As %String, ObjectType As %String, ObjectReference As %String) As %String
{
}

/// 二级授权中获取Tree类型的json串, 界面的控件也可以是Grid
/// 功能描述： 根据当前登录用户(有二级授权用户的)的Session信息获取到该用户可以  给别人授权的数据；
/// ParentID： 父ID
/// ObjectType: 需要显示的优先级类别
/// ObjectReference： 在界面上 选择的 Group或者User或者CTLoc(登录科室)
/// SessionStr: session串
ClassMethod GetTreeJson2(ParentID As %String, ObjectType As %String, ObjectReference As %String, SessionStr As %String) As %String
{
}

}
