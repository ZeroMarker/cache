/// Description: CDSS公共方法
/// Creator: 高姗姗
/// Date: 2020-10-15
Class web.CDSS.CMKB.FunLib Extends %RegisteredObject
{

/// Creator:高姗姗
/// CreatDate:用于查询数据用，OpenData
/// Description：对数据特殊字符处理   英文的双引号 单引号转换成中文的引号,在拼Json串之后调用
/// Input：str -输入的JSON字符串
/// Return:mystr -处理特殊字符后的JSON字符串
/// Other:w ##class(web.CDSS.CMKB.FunLib).EvalJSON(str)
ClassMethod EvalJSON(str) As %String
{
	s mystr=""
	s len=$Length(str,""",""")
	for i=1:1:len
	{
		s pair=$p(str,""",""",i)
		s key=$p(pair,""":""",1)
		s val=$p(pair,""":""",2)
		if (i=1)
		{
			s key=$p(key,"{""",2)
		}
		if (i=len)
		{
			s val=$p(val,"""}",1)	
		}
		s val=$tr(val,"\'","’")	
		s val=$tr(val,"""","”")	
		if (mystr="")
		{
			s mystr=""""_key_""":"""_val_""""
		}
		else{
			s mystr=mystr_","""_key_""":"""_val_""""
		}
	}
	s mystr="{"_mystr_"}"
	q mystr
}

/// Creator:丁亚男
/// CreatDate:2021-09-03
/// Description:处理年龄时间格式转换
/// Input:num:数值, unit:单位, isinclude:是否包含, minormax:最大值还是最小值标志
/// Return:多少天
/// Other:w ##class(web.CDSS.CMKB.FunLib).TransforDateFormat(3,"月",1,"max")
ClassMethod TransforDateFormat(num, unit, isinclude = "", minormax = "")
{
	s days=""
	if (num'="")
	{
		s coeff=365 //默认值
		s:unit="天" coeff=1
		s:unit="月" coeff=30
		s:unit="岁" coeff=365
		s days=num*coeff
		if (isinclude=1)&(minormax="min")
		{
			s days=days-1
		}
		if (isinclude=1)&(minormax="max")
		{
			s days=days+1
		}
	}
	q days
}

/// Creator:陈莹
/// CreatDate:2020-10-22  
/// Description：用于Query方法里如果某个字段要保留换行调用 (</br/>)
///               使用了JsonS()的OpenData的字段无需调用,自己拼串的OpenData的字段调用
/// Input：instr -输入的字符串
/// Return:mystr -处理特殊字符后的字符串
/// Other:w ##class(web.CDSS.CMKB.FunLib).TransLinefeed(mystr,"")      //不保留回车换行
/// Other:w ##class(web.CDSS.CMKB.FunLib).TransLinefeed(mystr,"G")      //保留回车换行 ,用于Query方法字段要保留换行时
/// Other:w ##class(web.CDSS.CMKB.FunLib).TransLinefeed(mystr,"O")   //保留回车换行 ,用于自己拼串的OpenData方法字段要保留换行时
ClassMethod TransLinefeed(instr As %String, flag As %String = "") As %String
{
	s mystr = instr
	q:(mystr="") mystr
	if (flag="")  //不保留回车换行
	{
		s mystr = ##class(web.BDP.util.String).Replace(mystr,$c(13,10),"")
		s mystr = ##class(web.BDP.util.String).Replace(mystr,$c(10,10,10),"")	
		s mystr = ##class(web.BDP.util.String).Replace(mystr,$c(10),"")
		s mystr = ##class(web.BDP.util.String).Replace(mystr,$c(13),"")
	}
	elseif (flag="G")  //保留回车换行 ,用于Query方法字段要保留换行时
	{
		s mystr = ##class(web.BDP.util.String).Replace(mystr,$c(13,10),"<br/>")   //列表里的换行
		s mystr = ##class(web.BDP.util.String).Replace(mystr,$c(10,10,10),"<br/>")	
		s mystr = ##class(web.BDP.util.String).Replace(mystr,$c(10),"<br/>")
		s mystr = ##class(web.BDP.util.String).Replace(mystr,$c(13),"<br/>")
	}
	elseif (flag="O") //保留回车换行 ,用于自己拼串的OpenData方法字段要保留换行时
	{
		s mystr = ##class(web.BDP.util.String).Replace(mystr,$c(13,10),"\n")  //弹出框里的换行 
		s mystr = ##class(web.BDP.util.String).Replace(mystr,$c(10,10,10),"\n")	
		s mystr = ##class(web.BDP.util.String).Replace(mystr,$c(10),"\n")
		s mystr = ##class(web.BDP.util.String).Replace(mystr,$c(13),"\n")
	}
	q mystr
}

}
