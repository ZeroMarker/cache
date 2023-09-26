Class web.DHCOPCommonFunLib Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// w ##class(web.DHCOPCommonFunLib).GetXmlElementValue("<Respons><TT></TT><Err err="">1</Err></Respons>","Err")
ClassMethod GetXmlElementValue(XmlStr As %String, NodeName As %String) As %String
{
	new (XmlStr, NodeName)
	
	set XmlStr="<Response>"_$p(XmlStr,"<Response>",2)
	
	set sc=##class(%XML.TextReader).ParseString(XmlStr,.myReader)
	set myRtn=""
	set myfind=0
	if ($$$ISOK(sc)) {
		while ((myReader.Read())&&(myfind=0)) {
			if ((myReader.NodeType="element")&&(myReader.LocalName=NodeName)) {
				do myReader.Read()
				set myRtn=myReader.Value
				set myfind=1
			}
		}
		do myReader.%Close()
	}
	quit myRtn
}

/// 设置不同的舍入进制
/// w ##class(web.DHCOPCommonFunLib).Round(12.658, 1, 6)
ClassMethod Round(FNum As %String, Len As %String, RNum As %String) As %String
{
	new (FNum, Len, RNum)
	
	set Len=+$g(Len)
	set FNum=+$g(FNum)
	set RNum=+$g(RNum)
	
	quit:(FNum=0) $fn(FNum,"",Len)
	
	//求幂
	set myzp=$zpower(10,Len)
	//取整数取4舍五入,  增加了矫正
	set myRtnInt=$fn(((FNum*myzp*10)-(RNum-5))/10,"",0)
	set myNum=$fn((myRtnInt/myzp),"",Len)
	
	quit myNum
}

/// s rtn=##class(web.DHCOPCommonFunLib).Trim("")
ClassMethod Trim(IStr As %String) As %String
{
	n (IStr)
		
	s myStr=""
	i IStr=" " d
	.s IStr=""
	
	;Left Trim
	s mylen=$l(IStr)
	s myIdx=0
	s myCurStr=" "
	f i=1:1:mylen  q:(myCurStr'=" ")  d
	.s myIdx=i
	.s myCurStr=$e(IStr,i,i)
	
	s IStr=$e(IStr, myIdx, mylen)
	
	;Right Trim
	s mylen=$l(IStr)
	s myCurStr=" "
	s myIdx=0
	f i=mylen:-1:1  q:(myCurStr'=" ")  d
	.s myIdx=i
	.s myCurStr=$e(IStr,i,i)
	s IStr=$e(IStr, 1, myIdx)
	
	s myStr=IStr
	
	q myStr
}

}
