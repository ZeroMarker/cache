Class EMRservice.Util.String Extends %RegisteredObject [ ProcedureBlock ]
{

ClassMethod EscapeJsonStream(inputStream As %Stream) As %Stream
{
	s retStream = ##class(%GlobalCharacterStream).%New()
	d inputStream.Rewind()
	while (inputStream.AtEnd = 0)
	{
		d retStream.Write(..EscapeJSON(inputStream.Read(16000)))
	}
	q retStream
}

/// Debug:	w ##Class(EMRservice.Util.String).EscapeJSON("")
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
/// Debug:	w ##Class(EMRservice.Util.String).FilterSpecialChar("")
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

}
