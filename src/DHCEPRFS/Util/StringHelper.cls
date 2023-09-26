Class DHCEPRFS.Util.StringHelper Extends %RegisteredObject [ ProcedureBlock ]
{

/// CreateUser: LiaoWP
/// CreateDate: 20009-08-06
/// Desc: 去掉字符串两端的空格
/// Input: argStr:原始字符串
/// Return：去掉两端空格的字符串
ClassMethod Trim(argStr As %String) As %String
{
	Q:(argStr="") ""
	
	Set sLoc=0,eLoc=0,StrLen=0,sChar="",eChar="",i=0
	Set StrLen=$l(argStr)
	for i=1:1:StrLen
	{
		Set sLoc=i,sChar=$E(argStr,i)
		Q:(sChar'=" ")
	}
	for i=StrLen:-1:1
	{
		Set eLoc=i,eChar=$E(argStr,i)
		Q:(eChar'=" ")
	}
	
	s RtnStr=$E(argStr,sLoc,eLoc)
	Q RtnStr
}

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

/// Creator:ZhanMingChao
/// Description:返回汉字的编码信息
/// Input：	HANZI:汉字
/// 			FLAG:返回何种编码(1:ASC码,2:汉字,3:拼音,4:首拼,5:四角码6:五笔码7:区位码8:笔划数9:郑码)
/// 			SPLIT:分割符(可以为空)
/// Output：
/// 	非0:返回编码信息:ASC码^汉字^拼音^首拼^四角码^五笔码^区位码^笔划数^郑码
/// 	0：未找到编码信息
/// CreatDate:2011-06-08
/// w ##class(web.DHCINSUPort).GetCNCODE("东华",4,"^")
/// w ##class(web.DHCINSUPort).GetCNCODE("东华",4,"")
ClassMethod GetCNCODE(HANZIS As %String = "", FLAG As %String = "", SPLIT As %String = "") As %String
{
	s Rtnstr=""
	q:$g(HANZIS)="" Rtnstr
	s Rtnstr=""
	f i=1:1:$l(HANZIS) d
	.s HANZI=$EXTRACT(HANZIS,i)
	.s ASCIICODE=$ASCII(HANZI)
	.i $D(^DHCCharacterEncoding("0","ASCII",ASCIICODE))'=0 d
	..s rowid=$o(^DHCCharacterEncoding("0","ASCII",ASCIICODE,""))
	..s tmpstr=""
	..s:FLAG="" tmpstr=$g(^DHCCharacterEncoding(rowid))
	..s:FLAG'="" tmpstr=$p(^DHCCharacterEncoding(rowid),"^",FLAG)
	..i Rtnstr=""  d
	...s Rtnstr=tmpstr
	..e  d
	...s Rtnstr=Rtnstr_SPLIT_tmpstr
	.e  d
	..s:Rtnstr="" Rtnstr="?"
	..s Rtnstr=Rtnstr_SPLIT_"?"
	
	q Rtnstr
}

/// Desc: JSON特殊字符转换
/// Debug: w ##class(DHCEPRFS.Util.StringHelper).ConvertJSONSpecialChar("""test""")
ClassMethod ConvertJSONSpecialChar(AInputStr As %String) As %String
{
	s ret = $replace(AInputStr,$c(92),"\\") //反斜线
	s ret = $replace(ret,$c(34),"\""") //双引号
	q ret
}

/// @param : %String jsonstr {name:"wang:hc",age:1}
/// 把jsonstr转成jsonObject对象.现仅支持一级简单的json
ClassMethod FromJSON(jsonstr As %String) As ext.util.JsonObject
{
	if jsonstr="{}" Quit ""
	s jsonstrlen=$length(jsonstr)
	s tempstr=$EXTRACT(jsonstr,2,jsonstrlen-1)
	s obj = ##class(ext.util.JsonObject).%New()
	s len=$length(tempstr,",")
	for i=1:1:len {
		s tempstr1=$P(tempstr,",",i)
		s name=$P(tempstr1,":",1)
		s value=$E(tempstr1,$l(name)+2,$l(tempstr1)) 
		//$P(tempstr1,":",2,$l())
		if name["""" s name=$P(name,"""",2)
		if value["""" s value=$P(value,"""",2)
		d obj.Put(name,value)
	}
	Q obj
}

/// Desc: hisui里面的datebox值转换为yyyy-MM-dd格式
/// Debug: w ##class(DHCEPRFS.Util.StringHelper).DateboxToNormal("")
ClassMethod DateboxToNormal(date As %String) As %String
{
	q:(date="") ""
	///1 MM/DD/YYYY  3 YYYY-MM-DD  4 DD/MM/YYYY
	//标准格式不转换
	q:($L(date,"-")=3)&&($L($P(date,"-",1))=4) date
	s formate =##class(websys.Conversions).DateFormat()
	q:(formate="1") $P(date,"/",3)_"-"_$P(date,"/",1)_"-"_$P(date,"/",2)
	q:(formate="4") $P(date,"/",3)_"-"_$P(date,"/",2)_"-"_$P(date,"/",1)
	q:(formate="3") date
	q date
}

/// Desc: cache返回的日期(yyyy-MM-dd)转为his里面配置的格式要求
/// Debug：w ##class(DHCEPRFS.Util.StringHelper).CacheDateToDatebox("")
ClassMethod CacheDateToDatebox(date As %String) As %String
{
	q:(date="") ""
	s formate =##class(websys.Conversions).DateFormat()
	q:(formate="1") $P(date,"-",2)_"/"_$P(date,"-",3)_"/"_$P(date,"-",1)
	q:(formate="4") $P(date,"-",3)_"/"_$P(date,"-",2)_"/"_$P(date,"-",1)
	q:(formate="3") date
	q date
}

/// Desc: cache返回的日期(yyyy-MM-dd hh:mm:ss)转为his里面配置的格式要求
/// Debug：w ##class(DHCEPRFS.Util.StringHelper).CacheDateTimeToDatebox("")
ClassMethod CacheDateTimeToDateBox(dateTime As %String) As %String
{
	q:(dateTime="") ""
	q:($L(dateTime," ")'=2) dateTime
	q ##class(DHCEPRFS.Util.StringHelper).CacheDateToDatebox($P(dateTime," ",1))_" "_$P(dateTime," ",2)
}

/// Desc: 日期内部格式转换
/// Debug: w ##class(DHCEPRFS.Util.StringHelper).FormatLogicalDate("2022-06-24")
ClassMethod FormatLogicalDate(ADateStr As %String) As %String
{
	s ret = "" 
	q:(ADateStr = "") ret
	s $zt = "FormatLogicalDateErr"
	s ret = ##class(websys.Conversions).DateHtmlToLogical(ADateStr)
	q ret
FormatLogicalDateErr
	s ret = ..DateHtmlToLogical(ADateStr)
	q ret
}

/// Debug: w ##class(DHCEPRFS.Util.StringHelper).DateHtmlToLogical("2022-06-24")
ClassMethod DateHtmlToLogical(ADateStr As %String) As %String
{
	s ret = ""
	q:(ADateStr = "") ret
	s:(ADateStr["-") ret = $zdh(ADateStr,3)
	s:(ADateStr["/") ret = $zdh(ADateStr,4)
	q ret
}

/// Desc: 日期显示格式转换
/// Debug: w ##class(DHCEPRFS.Util.StringHelper).FormatDisplayDate("66284")
ClassMethod FormatDisplayDate(ADateStr As %String) As %String
{
	s ret = "" 
	q:(ADateStr = "") ret
	s $zt = "FormatDisplayDateErr"
	s ret = ##class(websys.Conversions).DateLogicalToHtml(ADateStr)
	q ret
FormatDisplayDateErr
	s ret = ..DateLogicalToHtml(ADateStr)
	q ret
}

/// Debug: w ##class(DHCEPRFS.Util.StringHelper).DateLogicalToHtml("66284")
ClassMethod DateLogicalToHtml(ADateStr As %String) As %String
{
	s ret = ""
	q:(ADateStr = "") ret
	s dateFormat = ##class(websys.Conversions).DateFormat()
	s ret = $zd(ADateStr,dateFormat)
	q ret
}

}
