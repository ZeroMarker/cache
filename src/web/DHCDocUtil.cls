/// Creator:      周志强
/// CreatDate:    2009.02.20
/// Description:: 医生站实用方法和算法类       
/// Others:
Class web.DHCDocUtil Extends DHCDoc.Util.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// creator:郭荣勇
/// date:	2010-03-18
/// input:	语言rowid,需要翻译的字符串
/// return:	翻译后的字符串
/// desc:
ClassMethod GetTranslatedStr(LogonLanID, Desc) As %String
{
	if (LogonLanID="")||(Desc="") Q Desc
	//得到翻译描述表ID,如果没有则会插入一条
	s myrtnStr=""
	s phraseid=##class(websys.Dictionary).AddItem(Desc)
	if +phraseid=0 Q Desc
	s myrtnStr=##class(websys.DictionaryTranslated).GetItem(LogonLanID,phraseid)
	if myrtnStr="" Q Desc
	
	Q myrtnStr
}

/// Creator:      徐鹏
/// CreatDate:    2009.04.01
/// Description:  对中文做utf-8转换,解决P8中文传递参数时的 bug
/// Table:       
/// Input:        InStr:字符串
/// Others:       为了解决P8版本汉字模糊查询翻页后无法正常显示的问题
/// 在在组件使用该类方法得到值及Query中执行查询前进行该转换  
/// Return:       装换后的字符串
ClassMethod UnEscape(InStr As %String) As %String
{
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
}

/// 日期转换类
/// creator:郭荣勇
/// date:	2014-03-18
/// input:	需要转换的javascript纯对象,返回数组的引用
/// return:	cache的数组
/// desc:   将json数据转换为数组
/// w ##class(web.DHCDocUtil).GetArrayByObjStr()
ClassMethod GetArrayByObjStr(ObjStr As %String, ByRef array As %Binary) As %Library.ArrayOfObjects
{
	;n (ObjStr,array)
	s $zt="GetArrayByObjStrErr"
	;{DefaultExpendList:true,DefaultExpendTemplate:false,BigFont:true,SmallFont:false,ShowGridFootBar:true}
	s ObjStr=$e(ObjStr,2,$l(ObjStr)-1)
	for i=1:1:$l(ObjStr,",") {
		s OneItem=$p(ObjStr,",",i)
		continue:OneItem=""
		s array($p(OneItem,":",1))=$p(OneItem,":",2)
	}
	q
GetArrayByObjStrErr
	q
}

/// 去除JSON数据中的特殊字符
ClassMethod EvalJSON(instr As %String) As %String
{
	;w ##class(ext.util.String).EvalJSON("a\")
	s mystr = instr
	
	q:(mystr="") mystr
	
	s mystr = ..Replace(mystr,"\", "\\")
	
	//s mystr = ..Replace(mystr,"'", "&#39") //  \'
	s mystr = ..Replace(mystr,"'", "") 
	s mystr = ..Replace(mystr,$c(13), "")
	
	s mystr = ..Replace(mystr,$c(10), "")
	
	s mystr = ..Replace(mystr,$c(0), "\u0000")
	s mystr = ..Replace(mystr,$c(1), "\u0001")
	s mystr = ..Replace(mystr,$c(2), "\u0002")
	s mystr = ..Replace(mystr,$c(3), "\u0003")
	s mystr = ..Replace(mystr,$c(4), "\u0004")
	s mystr = ..Replace(mystr,$c(5), "\u0005")
    s mystr = ..Replace(mystr,"	", "")
	q mystr
}

ClassMethod EvalHTML(instr As %String) As %String
{
	s mystr = instr
	q:(mystr="") mystr
	s mystr = ..Replace(mystr,";", "&#59;")
	s mystr = ..Replace(mystr,"""", "&#34;")
	s mystr = ..Replace(mystr,"'", "&#39;")
	s mystr = ..Replace(mystr,"/", "&#47;")
	s mystr = ..Replace(mystr,":", "&#58;")
	
	s mystr = ..Replace(mystr,"\", "&#92;")


	q mystr
}

/// 要求被替换的内容不能=""
ClassMethod Replace(instr As %String, substr As %String, replacement As %String) As %String
{
	;
	q:(substr="") instr
	;q:(replacement="") instr
	q:'($l(instr,substr)>1) instr
	
	s mylen=$l(instr,substr)
	for myIdx=1:1:mylen {
		s myary(myIdx)=$p(instr,substr, myIdx)
	}
		
	s mystr=""
	s myIdx=""
	s myIdx=$o(myary(myIdx))
	while (myIdx'=""){
		s myrepstr=""
		i ($o(myary(myIdx))=""){
			s myrepstr=myary(myIdx)
		}else{
			s myrepstr=myary(myIdx)_replacement
		}
		
		i (mystr=""){
			s mystr=myrepstr
		}else{
			s mystr=mystr_myrepstr
		}
		
		s myIdx=$o(myary(myIdx))
		q:(myIdx="")
	}
	
	q mystr
}

/// //w ##class(web.DHCDocUtil).CompareSysDateTime("2017-01-16!17:30:00")
ClassMethod CompareSysDateTime(InDateTime As %String)
{
	s ret=1
	s InDate=$p(InDateTime,"!",1)	
	s InTime=$p(InDateTime,"!",2)
	s InDate=..%ZDH(InDate)
	//i (InDate["/") s InDate=$zdh(InDate,4)
 	//i (InDate["-") s InDate=$zdh(InDate,3)
 	i (InTime[":") s InTime=..%ZTH(InTime)
 	s CurDate=..%SysDate()
 	s CurTime=..%SysTime()
 	if (InDate="")!(InTime="") s ret=0
 	else  if (CurDate<InDate)!((CurDate=InDate)&&(CurTime<InTime)) s ret=0
 	q ret
}

ClassMethod GetHisSysDateTime(FormatType)
{
	s CurrentDate=..%SysDate()
	s CurrentTime=..%SysTime()
	s OutputDate="",OutputTime=""
	if FormatType=3{
		s OutputDate=$zd(+$h,3)
	}
	if FormatType=4{
		s OutputDate=$zd(+$h,4)
	}
	s OutputTime=..%ZT(..%SysTime(),1)
	/*if FormatType=1{
		;01/11/2017 15:43:19
		s OutputDate=$zd(+$h,1)
		s OutputTime=..%ZT(..%SysTime(),1)
	}elseif FormatType=2{
		;2017-01-11 15:43:19
		s OutputDate=$zd(+$h,3)
		s OutputTime=..%ZT(..%SysTime(),1)
	}elseif FormatType=3{
		;01/11/2017 15:43
		s OutputDate=$zd(+$h,1)
		s OutputTime=..%ZT(..%SysTime(),2)
	}elseif FormatType=4{
		;2017-01-11 15:43
		s OutputDate=$zd(+$h,3)
		s OutputTime=..%ZT(..%SysTime(),1)
	}*/
	s outputstr=OutputDate_$c(1)_OutputTime
	q outputstr
}

}
