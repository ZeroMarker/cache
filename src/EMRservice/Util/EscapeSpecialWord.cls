/// 特殊字符处理
Class EMRservice.Util.EscapeSpecialWord Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:       存入json前的特殊字符处理
/// Creator:    Candy
/// CreateDate: 2016-5-5  
/// Input:      AValue json项描述
/// OutPut:     result 处理好的字符串 
/// Debug:   w ##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape("入院记录\现病史")
ClassMethod JsonEscape(AValue As %String)
{
		s result = AValue
		s result = $Replace(result,"\","\\")
		s result = $Replace(result,"""","\""")
		s result = $Replace(result,"\\b","\b")
		s result = $Replace(result,"\\f","\f")
		s result = $Replace(result,"\\n","\n")
		s result = $Replace(result,"\\r","\r")
		s result = $Replace(result,"\\t","\t")
		q result
}

/// Desc:       处理HTML不合法字符串
/// Creator:    Donglulu
/// CreateDate: 2017-8-4  
/// Input:      AValue 字符串描述
/// OutPut:     result 处理好的字符串 
/// Debug:   w ##Class(EMRservice.Util.EscapeSpecialWord).HtmlEscape("入院记录\现病史")
ClassMethod HtmlEscape(AValue As %String)
{
		s result = AValue
		s result = $Replace(result,"<","&lt")
		s result = $Replace(result,">","&gt")
		s result = $Replace(result,"＜","&lt")
		s result = $Replace(result,"＞","&gt")
		q result
}

/// Desc:       处理XML不合法字符串
/// Creator:    duan
/// CreateDate: 2019-10-30  
/// Input:      AValue 字符串描述
/// OutPut:     result 处理好的字符串 
/// Debug:   w ##Class(EMRservice.Util.EscapeSpecialWord).XmlEscape("<<10ml")
ClassMethod XmlEscape(AValue As %String)
{
		s result = AValue
		s result = $Replace(result,"&","&amp;")
		s result = $Replace(result,"<","&lt;")
		s result = $Replace(result,">","&gt;")	
		q result
}

/// Debug:	w ##Class(EMRservice.Util.EscapeSpecialWord).EscapeJSON("")
ClassMethod EscapeJSON(input) As %String
{
	q:(input = "") input
	
	s ret = input
		
	s ret = ..Replace(ret,"\", "\\")
	
	s ret = ..Replace(ret,"""", "\""")
	
	s ret = ..Replace(ret,$c(8), "\b") 
	
	s ret = ..Replace(ret,$c(9), "\t")
	
	s ret = ..Replace(ret,$c(10), "\n")
	
	s ret = ..Replace(ret,$c(12), "")
	
	s ret = ..Replace(ret,$c(13), "\r")
	
	s ret = ..Replace(ret,$c(14), "") 
	
	//32之前是不可见字符
	
	s ret = ..Replace(ret,$c(0), "")
	
	q ret
}

/// Desc:	替换字符串中的指定字符
/// Input:	inputStr: 输入字符串
/// 		fromStr	: 被替换的字符
/// 		toStr	: 替换为的字符
/// Output：无
/// Return：替换后的字符串
/// Debug:	w ##Class(CA.Util.String).FilterSpecialChar("")
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

Storage Default
{
<StreamLocation>^EMRservice4543.EscapeSpeciF98ES</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
