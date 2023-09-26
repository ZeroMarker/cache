/// Descript:字符串处理类
/// Creater:	wangguoying
/// CreateDate:	2020-03-04
Class web.DHCPE.Utils.StringUtil Extends %RegisteredObject
{

/// Descript:根据ASCII码值排序
/// Input:
/// 				StrList：待排序的字符串
/// 				Delimiter：字符串分隔符
/// 				Type：ASC 升序 ， Desc 降序
/// Return: 
/// Creater:	wangguoying
/// CreateDate:	2020-03-04
/// Debug: w ##class(web.DHCPE.Utils.StringUtil).SortByASCII("deviceInfo^fee^flowId^hospitalId^operId^outRefundNo^outTradeNo^reason^service^sign^signType^sourceCode^terminalNo^tradeTime")
ClassMethod SortByASCII(StrList As %String, Type As %String = "ASC", Delimiter As %String = "^")
{
	s len=$L(StrList,Delimiter)
	f i=1:1:len-1
	{
		f j=1:1:len-i
		{
			s str=$P(StrList,Delimiter,j)
			s nexStr=$P(StrList,Delimiter,j+1)
			i '(..CompareByASCII(str,nexStr,Type))  //逆序换位置
			{
				s $P(StrList,Delimiter,j)=nexStr
				s $P(StrList,Delimiter,j+1)=str
			}
		}		
	}
	q StrList
}

/// Descript：比较两个字符串的ASCII码值的大小
/// Input:
/// 				Com1：字符串1
/// 				Com2：字符串1
/// 				Type：ASC 升序 ， DESC 降序
/// Return: ASC时，Com1<=Com2 为1，Com1>Com2时  为 0，Desc时相反
/// Creater:	wangguoying
/// CreateDate:	2020-03-04
/// Debug: w ##class(web.DHCPE.Utils.StringUtil).CompareByASCII("abc1","abc")
ClassMethod CompareByASCII(Com1, Com2, Type As %String = "ASC")
{
	q:Com1=Com2 1
	s ret=""
	s len=$L(Com1)
	i len<$L(Com2) s len=$L(Com2)
	f i=1:1:len  
	{
		s char1=$e(Com1,i)
		s char2=$e(Com2,i)
		continue:char1=char2
		s ret=$ascii(char1)<$ascii(char2)
		i Type="DESC" s ret='ret
		q:ret'=""
	}
	q ret
}

/// Description：比较两个字符串集合（通过相同分隔符确定对比值） 取补集
/// Input:
/// 				Com1：字符串1
/// 				Com2：字符串1
/// 				Type：0：完全补集 1：Com1中存在，Com2中不存在 2：Com2中存在，Com1中不存在
/// 				Delimiter: 固定分隔符
/// Return: 
/// Creator:	wangguoying
/// CreateDate:	2021-07-09
/// Debug: w ##class(web.DHCPE.Utils.StringUtil).GetComplement(",,526,551,556,",",",0,",")
ClassMethod GetComplement(Com1, Com2, Type As %String = "0", Delimiter As %String = "^")
{
	s unionSet = ..GetUnionSet(Com1,Com2,Delimiter)
	s intersection = ..GetIntersection(Com1,Com2,Delimiter)
	s Ret = ""
	s intersection = Delimiter_intersection_Delimiter
	f i=1:1:$L(unionSet,Delimiter) d
	.s element = $P(unionSet,Delimiter,i)
	.q:element=""
	.i intersection'[(Delimiter_element_Delimiter) d
	..s:Ret'="" Ret = Ret_Delimiter_element
	..s:Ret="" Ret = element
	q:(Type=0)||(Ret="") Ret
	s NewRet = ""
	s intersection = ""
	i Type = 1  s intersection = Delimiter_Com2_Delimiter
	i Type = 2  s intersection = Delimiter_Com1_Delimiter
	b
	f i=1:1:$L(Ret,Delimiter) d
	.s element = $P(Ret,Delimiter,i)
	.q:element=""
	.i intersection'[(Delimiter_element_Delimiter) d
	..s:NewRet'="" NewRet = Ret_Delimiter_element
	..s:NewRet="" NewRet = element
	
	q NewRet
}

/// Description：两个字符串集合（通过相同分隔符确定对比值）取交集
/// Input:
/// 				Com1：字符串1
/// 				Com2：字符串1
/// 				Delimiter: 固定分隔符
/// Return: 
/// Creator:	wangguoying
/// CreateDate:	2021-07-09
/// Debug: w ##class(web.DHCPE.Utils.StringUtil).GetIntersection("a^b^c1","^a^b^c")
ClassMethod GetIntersection(Com1, Com2, Delimiter As %String = "^")
{
	s Ret = ""
	s Com1 = Delimiter_Com1_Delimiter
	s Com2 = Delimiter_Com2_Delimiter
	f i=1:1:$l(Com1,Delimiter)
	{
		s element = $P(Com1,Delimiter,i)
		continue:element=""
		i Com2[(Delimiter_element_Delimiter) d
		.s:Ret'="" Ret = Ret_Delimiter_element
		.s:Ret="" Ret = element
	}
	q Ret
}

/// Description：两个字符串集合（通过相同分隔符确定对比值）取并集
/// Input:
/// 				Com1：字符串1
/// 				Com2：字符串1
/// 				Delimiter: 固定分隔符
/// Return: 
/// Creator:	wangguoying
/// CreateDate:	2021-07-09
/// Debug: w ##class(web.DHCPE.Utils.StringUtil).GetUnionSet("a^b^c1","a^b^c")
ClassMethod GetUnionSet(Com1, Com2, Delimiter As %String = "^")
{
	s Ret = Com1
	s Com1 = Delimiter_Com1_Delimiter
	f i=1:1:$l(Com2,Delimiter)
	{
		s element = $P(Com2,Delimiter,i)
		continue:element=""
		i Com1'[(Delimiter_element_Delimiter) d
		.s:Ret'="" Ret = Ret_Delimiter_element
		.s:Ret="" Ret=element
	}
	q Ret
}

}
