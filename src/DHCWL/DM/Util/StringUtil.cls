Class DHCWL.DM.Util.StringUtil Extends %RegisteredObject
{

//s str=##class(DHCWL.DM.Util.StringUtil).Trim(" ab")

ClassMethod Trim(str, trimSpeStr = "") As %String
{
	s len=$l(str),resultStr="",i=0,j=0
	s cur=""
	i trimSpeStr="" s trimSpeStr=" "
	f i=1:1:len {
		s cur=$e(str,i)
		i (cur=" ")||(cur [ trimSpeStr) {
			continue
		}else {
			q
		}
	}
	f j=len:-1:i-1 {
		s cur=$e(str,j)
		i (cur=" ")||(cur [ trimSpeStr) {
			continue
		}else {
			q
		}
	}
	q $e(str,i,j)
}

ClassMethod IsSpace(char) As %Boolean
{
	s ascii=$ascii(char)
	i ((ascii=32) || ( (ascii>=9) && (ascii<=13) ) ) q 1
	q 0
}

ClassMethod IsWord(str) As %Boolean
{
	s flag=1
	s len=$l(str)
	f i=1:1:len d
	.if '..IsLetter($e(str,i)) d
	..s flag=0,len=len+1
	q flag
}

ClassMethod IsLetter(char) As %Boolean
{
	s ascii=$ascii(char)
	if ( ((ascii>=48)&&(ascii<=57)) || ((ascii>=65)&&(ascii<=90)) || ((ascii>=97)&&(ascii<=122)) ) q 1
	q 0
}

ClassMethod ParseURLQueryParams(params As %String, ByRef paraMap)
{
  k paraMap
  s len=$l(params,"&")
  f i=1:1:len{
	s param=$p(params,"&",i)
	s k=$p(param,"=",1)
	s v=$p(param,"=",2)
	continue:k=""
	s paraMap(k)=v
  }
}

ClassMethod ReplaceStr(str, src = "", dem = "") As %String
{
	q:((src="")||(str="")) str
	if ('(str [ src)) q str
	s strLen=$l(str),srcLen=$l(src),demLen=$l(dem)
	s result="",flag=0
	f i=1:1:strLen {
		s flag=1
		f j=1:1:srcLen {
			if ($e(str,i+j-1)=$e(src,j)){
			}else{
				s flag=0
				q
			}
		}
		if (flag=1){
			s result=result_dem
			s i=i+srcLen-1
		}else{
			s result=result_$e(str,i)
		}
	}
	q result
}

// s reg= ##class(DHCWL.DM.Util.StringUtil).LikePatternConvert("%死亡%")

ClassMethod LikePatternConvert(likeExpression) As %String
{
	s len=$l(likeExpression)
	s patternStr=""
	f i=1:1:len{
		s c=$e(likeExpression,i)
		if (c="%"){
			s patternStr=patternStr_"0.E"
		}elseif (c="_"){
			s patternStr=patternStr_"1.1E"
		}else{
			s patternFlag=0
			f j=i+1:1:len{
				s c2=$e(likeExpression,j)
				if ((c2="%")||(c2="_")){
					s patternFlag=1
					q
				}
			}
			if patternFlag{
				s patternStr=patternStr_"1.1"""_$e(likeExpression,i,j-1)_""""
				s i=j-1
			}else{
				s patternStr=patternStr_"1."""_$e(likeExpression,i,len)_""""
				s i=len
			}
		}
	}
	q patternStr
}

}
