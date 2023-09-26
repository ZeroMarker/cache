/// 计费界面样式 
Class DHCBILL.Common.DHCBILLLayOutStyle Extends %RegisteredObject
{

/// Creator: tangzf
/// CreateDate: 2019-04-20
/// Descript: custom类型元素下拉框样式 Combobox 
/// Input:	width : Combobox 宽度
/// 		name  : Combobox Id
/// Output: 
/// Return: 对应name的Combobox
/// DeBug: w ##class(DHCBILL.Common.DHCBILLLayOutStyle).GetDefaultCombox()
ClassMethod GetDefaultCombox(width, name)
{
	i (width="")||(width=0) s width=155
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"px;HEIGHT:30px;' class='hisui-combobox'></select>"
	q $$$OK
}

/// Creator: tangzf
/// CreateDate: 2019-04-21
/// Descript: custom类型元素 弹窗 Dialog
/// Input:	divName : Dialog id
/// 		ExpString  : 扩展串
/// Output: 
/// Return: 对应id的 Dialog
/// DeBug: w ##class(DHCBILL.Common.DHCBILLLayOutStyle).GetDefaultDialog()
ClassMethod GetDefaultDialog(divName As %String = "", ExpString As %String = "") As %String
{
	w "<div id='"_divName_"' style='padding:10px;display:none;'>"
	w "<table id='t"_divName_"'></table>"
	w "</div>"
	q $$$OK
}

/// Creator: tangzf
/// CreateDate: 2019-04-21
/// Descript: 根据组件名称获取组件信息
/// Input:	cmpName : 组件名 , inputStr : query入参
/// Output: 组件RowId _"^"_组件对应类名_"^"_组件对应query名
/// Return: 
/// DeBug: w ##class(DHCBILL.Common.DHCBILLLayOutStyle).GetComponentInfoByName()
ClassMethod GetComponentInfoByName(cmpName) As %String
{
	s ^CacheTemp("GetComponentInfoByName")=$lb(cmpName)
	s cmpName = $$ALPHAUP^SSUTIL4(cmpName)
 	s cmpRowID = $O(^websys.ComponentI("UniqueNameIndex",cmpName,""))
 	q:+cmpRowID=0 "-1^"
 	s cmpInfo=$g(^websys.ComponentD(cmpRowID))
 	s className=$lg(cmpInfo,2)
 	s queryName=$lg(cmpInfo,3)
 	s rtnStr=cmpRowID_"^"_className_"^"_queryName
 	q rtnStr
}

/// Creator: tangzf
/// CreateDate: 2019-04-21
/// Descript: 将入参转换为 json 格式
/// Input:	inputStr :入参 &AccountID=2&a=3&b=4"
/// Output: 标准json 串
/// Return: 
/// DeBug: w ##class(DHCBILL.Common.DHCBILLLayOutStyle).GetJson("&AccountID=2&a=3&b=4")
ClassMethod GetJson(inputStr) As %String
{
 	s strIndex=$l(inputStr,"&")
 	s outPutStr=""
 	f strIndex=1:1:strIndex  d
 	.s paraInfo=$p(inputStr,"&",strIndex)
 	.q:paraInfo=""
 	.s paraName=$p(paraInfo,"=",1)
 	.s paraVal=$p(paraInfo,"=",2) 
 	.i outPutStr=""  d
 	..s outPutStr=""""_paraName_""""_":"_""""_paraVal_""""
 	.e  d
 	..s outPutStr=outPutStr_","_""""_paraName_""""_":"_""""_paraVal_""""
 	s outPutStr="{"_outPutStr_"}"
 	q outPutStr
}

/// Creator: tangzf
/// CreateDate: 2019-06-01
/// Descript: custom类型元素 Tips 提示框
/// Input:	divName : Dialog id
/// 		content  : 提示内容
/// Output: 
/// Return: 对应id的 tips
/// DeBug: w ##class(DHCBILL.Common.DHCBILLLayOutStyle).GetDefaultTips()
ClassMethod GetDefaultTips(divName As %String = "", content As %String) As %String
{
	w "<div class='"_divName_"'>"
	w "<div class='messager-popover info' style='z-index:1;padding-left:10px'>"
	w "<span class='messager-popover-icon info'></span>"
	w "<span class='content'>"
	w content
	w "</span>"
	w "</div>"
	w "</div>"
	q $$$OK
}

}
