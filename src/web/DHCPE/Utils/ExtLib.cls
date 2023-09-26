/// Descript:	体检自定义标签引入类
/// Creater:	wangguoying
/// CreateDate:	2022-06-21
Class web.DHCPE.Utils.ExtLib Extends %RegisteredObject
{

/// Descript:引入自定义标签内容
/// Input:
/// 				require：标签代码，逗号分隔
/// 				cspName：CSP文件名称，8.4之后的版本无需指定
/// Return: 
/// Creater:	wangguoying
/// CreateDate:	2022-06-21
/// Debug: d ##class(web.DHCPE.Utils.ExtLib).LoadLib()
ClassMethod LoadLib(require, cspName = "")
{
}

ClassMethod MatchCharSet(type)
{
}

/// Descript: 加载 js
/// Input:
/// 				src：js路径
/// 				encoding：js编码格式
/// Return: 
/// Creater:	wangguoying
/// CreateDate:	2022-06-21
/// Debug: d ##class(web.DHCPE.Utils.ExtLib).LoadLib()
ClassMethod LoadJS(src, encoding = "")
{
}

/// Descript: 加载 CSS
/// Input:
/// 				src：CSS路径
/// Return: 
/// Creater:	wangguoying
/// CreateDate:	2022-06-21
/// Debug: d ##class(web.DHCPE.Utils.ExtLib).LoadCSS()
ClassMethod LoadCSS(src)
{
}

}
