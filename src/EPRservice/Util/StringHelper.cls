Class EPRservice.Util.StringHelper Extends %RegisteredObject [ ProcedureBlock ]
{

/// Desc:	过滤特殊字符
/// Input:	inputStr ：输入字符串
/// Output：无
/// Return：过滤特殊字符后的字符串
/// Debug:	w ##Class(EPRservice.Util.StringHelper).FilterSpecialChar("")
ClassMethod FilterSpecialChar(inputStr As %String) As %String
{
	s inputStr = $tr(inputStr, $C(0), "")
	s inputStr = $tr(inputStr, $C(10), "")
	s inputStr = $tr(inputStr, $C(13), "")
	s inputStr = $tr(inputStr, """", "")
	q inputStr
}

/// Desc:	替换字符串中的指定字符
/// Input:	inputStr: 输入字符串
/// 		fromStr	: 被替换的字符
/// 		toStr	: 替换为的字符
/// Output：无
/// Return：替换后的字符串
/// Debug:	w ##Class(EPRservice.Util.StringHelper).FilterSpecialChar("")
ClassMethod Replace(inputStr As %String, fromStr As %String, toStr As %String) As %String
{
	set count = $Length(inputStr, fromStr)
    quit:(count <= 1) inputStr
    
    set outStr = $p(inputStr,fromStr,1)
	for i = 2:1:count
	{
		set outStr = outStr_toStr_$p(inputStr,fromStr,i)
	}
	
	q outStr
}

/// Desc:	转换String为List
/// Input:	AInputString : 待转换字符串
/// 		ASeparator : 分隔符
/// Debug：	w ##Class(EPRservice.Util.StringHelper).ConvertStringToList("1^2^3","^")
ClassMethod ConvertStringToList(AInputString As %String, ASeparator As %String) As %List
{
	s ret = ""
	
	q:(AInputString="")||(ASeparator="") ret
	
	s count = $length(AInputString, ASeparator)
	for i=1:1:count
	{
		s tmpVal = $P(AInputString, ASeparator, i)
		s ret = ret_$lb(tmpVal)
	}
	
	q ret
}

}
