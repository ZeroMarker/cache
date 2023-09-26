Class EPRservice.Util.CharacterEncoding Extends %RegisteredObject [ ProcedureBlock ]
{

/// Debug: w ##Class(EPRservice.Util.CharacterEncoding).UnEscape("%u6D4B%u8BD5")
ClassMethod UnEscape(InStr As %String) As %String
{
	/*
	s num=1,retStr="",tmpNum=1
	f num=1:1:$l(InStr,"%") d
	.s char=$p(InStr,"%",num)
	.i num=1 d
	..s retStr=$e(char,1,$l(char))
	.e  d
	..i $e(char,1,1)'="u" d
	...s retStr=retStr_$char($zhex($e(char,1,2)))_$e(char,3,$l(char))
	..e  d
	...s retStr=retStr_$char($zhex($e(char,2,5)))_$e(char,6,$l(char))
	q retStr
	*/
	
	s num=1,tmpNum=1,retStr=""
	for num=1:1:$l(InStr,"%") {
		s char=$p(InStr,"%",num)
		if (num=1)
		{
			s retStr=$e(char,1,$l(char))	
		}
		else
		{
			if ($e(char,1,1)'="u")
			{
				s retStr=retStr_$char($zhex($e(char,1,2)))_$e(char,3,$l(char))
			}
			else
			{
				s retStr=retStr_$char($zhex($e(char,2,5)))_$e(char,6,$l(char))	
			}	
		}	
	}
	q retStr
}

}
