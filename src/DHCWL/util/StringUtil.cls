Class DHCWL.util.StringUtil Extends %RegisteredObject [ Not ProcedureBlock ]
{

ClassMethod Trim(str, trimSpeStr = "") As %String
{
	n (str,trimSpeStr)
	s len=$l(str),resultStr="",i=0,j=0
	s cur=""
	i trimSpeStr="" s trimSpeStr=" "
	f i=1:1:len {
		s cur=$e(str,i)
		i (cur=" ")||( trimSpeStr [ cur) {
			continue
		}else {
			q
		}
	}
	f j=len:-1:i {
		s cur=$e(str,j)
		i (cur=" ")||(trimSpeStr [ cur) {
			continue
		}else {
			q
		}
	}
	q $e(str,i,j)
}

ClassMethod Delete(str, trimSpeStr) As %String
{
	n (str,trimSpeStr)
	s len=$l(str),resultStr="",i=0,j=0
	s cur=""
	i trimSpeStr="" s trimSpeStr=" "
	s tmp=""
	f i=1:1:len {
		s cur=$e(str,i)
		i (cur=" ")||( trimSpeStr [ cur) {
			continue
		}else {
			s tmp=tmp_cur
		}
	}
	
	q tmp
}

//w ##class(DHCWL.util.StringUtil).EscapeStr("abc\(add")

ClassMethod EscapeStr(str As %Text, specalChar = "(", escape = "\") As %Text
{
	n (str,specalChar,escape)
	q:(str="") ""
	q:(specalChar="")||(escape="") str
	s result="",post="",cur=""
	s len=$l(str)
	f i=1:1:len {
		s cur=$e(str,i)
		if (i<len){
			s post=$e(str,i+1)
		}else {
			s post=""
		}
		if ((cur=escape)&&(post=specalChar)){
			continue
		}
		s result=result_cur
	}
	q result
}

/// w ##class(DHCWL.util.StringUtil).ReplaceStr("abcdefaaabb","aa","ccdd")
ClassMethod ReplaceStr(str, src = "", dem = "") As %String
{
	n (str,src,dem)
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

ClassMethod SubStringIndex(a, b) As %Integer
{
}

/// s list=##class(DHCWL.util.StringUtil).ListFromString("abc,d,e,f",",")
ClassMethod ListFromString(str As %String, deli As %String = ",")
{
	n (str,deli)
	s list=$lb(),len=$l(str,deli)
	f i=1:1:len {
		s $list(list,i)=$p(str,deli,i)	
	}
	q list
}

}
