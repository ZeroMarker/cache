/// 名称:基础数据平台公共方法       
/// 编写者:基础数据平台组 -陈莹 
/// 编写日期: 2016-4-7
Class web.DHCBL.BDP.FunLib Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator:chenying
/// Description:全角转半角后并返回字符串的首拼
/// Input：  HANZI:汉字
/// Output：返回字符串的首拼
/// CreatDate:2016-4-18
/// ^DHCCharacterEncoding(6814)="65360^ｐ^^P^PPPP^PPPP^^^"
/// w ##class(web.DHCBL.BDP.FunLib).GetPYCODE("东华1259te") --->DH1259TE
/// w ##class(web.DHCBL.BDP.FunLib).GetPYCODE("东华")
ClassMethod GetPYCODE(HANZIS As %String = "") As %String
{
    n (HANZIS)
    s Rtnstr=""
    q:$g(HANZIS)="" Rtnstr
    s Rtnstr=##class(web.DHCBL.BDP.FunLib).GetCNCODE(HANZIS,4,"")
    q Rtnstr
}

/// Creator:chenying
/// Description:获取登录科室的医院id
/// CreatDate:2018-11-1
/// w ##class(web.DHCBL.BDP.FunLib).GetHospId() 
ClassMethod GetHospId() As %String
{
	N (%session)
	s HOSPID=""
	if $d(%session) s HOSPID=$g(%session.Data("LOGON.HOSPID"))
	Q HOSPID
}

/// Creator:chenying
/// Description:Description:先将汉字全角转换成半角，再返回转换后汉字的编码信息
/// Input：  Input：	HANZI:汉字
/// 			FLAG:返回何种编码(1:ASC码,2:汉字,3:拼音,4:首拼,5:四角码,6:五笔码,7:区位码,8:笔划数,9:郑码)
/// 			SPLIT:分割符(可以为空)
/// Output：
/// 	非0:返回编码信息:ASC码^汉字^拼音^首拼^四角码^五笔码^区位码^笔划数^郑码
/// /	0：未找到编码信息
/// CreatDate:2016-4-18
/// ^DHCCharacterEncoding(6814)="65360^ｐ^^P^PPPP^PPPP^^^"
/// w ##class(web.DHCBL.BDP.FunLib).GetDBCCNCODE("",3,"^") --->DH1259TE
/// w ##class(web.DHCBL.BDP.FunLib).GetDBCCNCODE("东华１２５９ｔｅ",4,"^") --->DH1259TE
ClassMethod GetDBCCNCODE(HANZIS As %String = "", FLAG As %String = "", SPLIT As %String = "") As %String
{
	n (HANZIS,FLAG,SPLIT)
    s Rtnstr=""
    q:$g(HANZIS)="" Rtnstr
    s Rtnstr=##class(web.DHCBL.BDP.FunLib).GetCNCODE(HANZIS,FLAG,SPLIT)
    q Rtnstr
}

/// Function:全角转半角后并返回字符串的五笔码(注意是全码，不是首拼)
/// Creator:基础数据平台组 sunfengchao
/// CreatDate:2016-11-25
/// Input：  HANZI:汉字
/// Output：返回字符串的五笔码
/// Debug:  w ##class(web.DHCBL.BDP.FunLib).GetWBCODE("取是是")
ClassMethod GetWBCODE(HANZIS As %String = "") As %String
{
    n (HANZIS)
    s Rtnstr=""
    q:$g(HANZIS)="" Rtnstr
   	s Rtnstr=##class(web.DHCBL.BDP.FunLib).GetCNCODE(HANZIS,6,"")
    q Rtnstr
}

/// Creator:chenying
/// Description:全角转半角,返回转换后汉字的编码信息
/// Input：  HANZI:汉字
///             FLAG:返回何种编码(1:ASC码,2:汉字,3:拼音,4:首拼,5:四角码,6:五笔码,7:区位码,8:笔划数,9:郑码)
///             SPLIT:分割符(可以为空)
/// Output：
///     非0:返回编码信息:ASC码^汉字^拼音^首拼^四角码^五笔码^区位码^笔划数^郑码
///     0：未找到编码信息
/// CreatDate:2016-4-7
/// w ##class(web.DHCBL.BDP.FunLib).GetCNCODE("东华1259te",4,"") --->DH1259TE
/// w ##class(web.DHCBL.BDP.FunLib).GetCNCODE("东华",4,"")
ClassMethod GetCNCODE(HANZIS As %String = "", FLAG As %String = "", SPLIT As %String = "") As %String
{
    n (HANZIS,FLAG,SPLIT)
    s Rtnstr=""
    q:$g(HANZIS)="" Rtnstr
    s HANZIS=$zcvt(HANZIS,"U")
    f i=1:1:$l(HANZIS) d
    .s HANZI=$EXTRACT(HANZIS,i)
    .s ASCIICODE=$ASCII(HANZI)
    .;to DBC  全角转半角
    .i ASCIICODE=12288 s HANZI=$c(32)
    .i (ASCIICODE<65375)&(ASCIICODE>65280) s HANZI=$c(ASCIICODE-65248)
    .i $D(^DHCCharacterEncoding("0","ASCII",ASCIICODE))'=0 d
    ..s Encodingrowid=$o(^DHCCharacterEncoding("0","ASCII",ASCIICODE,""))
   	..s tmpstr=""
    ..s:FLAG="" tmpstr=$g(^DHCCharacterEncoding(Encodingrowid))
    ..s:FLAG'="" tmpstr=$p($g(^DHCCharacterEncoding(Encodingrowid)),"^",FLAG)
    ..if tmpstr="" s tmpstr=HANZI   //大小写字母和数字  flag=3(拼音)里取到的是空，需要处理
    ..i Rtnstr=""  d
    ...s Rtnstr=tmpstr
    ..e  d
    ...s Rtnstr=Rtnstr_SPLIT_tmpstr
    .e  d
    ..if (ASCIICODE=32) d    ;  $ASCII(" ")=32
    ...s tmpstr=" "
    ...i Rtnstr=""  d
    ....s Rtnstr=tmpstr
    ...e  d
    ....s Rtnstr=Rtnstr_SPLIT_tmpstr
    ..else  d
    ...if (Rtnstr="") d
    ....s Rtnstr=HANZI  ///?
    ...else  d
    ....s Rtnstr=Rtnstr_SPLIT_HANZI  ///?
    q Rtnstr
}

/*
/// Creator:ZhanMingChao  web.DHCINSUPort
/// Description:返回汉字的编码信息
/// Input：  HANZI:汉字
///             FLAG:返回何种编码(1:ASC码,2:汉字,3:拼音,4:首拼,5:四角码6:五笔码7:区位码8:笔划数9:郑码)
///             SPLIT:分割符(可以为空)
/// Output：
///     非0:返回编码信息:ASC码^汉字^拼音^首拼^四角码^五笔码^区位码^笔划数^郑码
///     0：未找到编码信息
/// CreatDate:2011-06-08
/// w ##class(web.DHCBL.BDP.FunLib).GetCNCODE("东华",4,"^")
/// w ##class(web.DHCBL.BDP.FunLib).GetCNCODE("东华",4,"")
ClassMethod GetCNCODE(HANZIS As %String = "", FLAG As %String = "", SPLIT As %String = "") As %String
{
    n (HANZIS,FLAG,SPLIT)
    s Rtnstr="0"
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
*/
/// Creator:ZhanMingChao
/// Description:自动转换全角半角
/// Input：  字符串
///             FLAG:0全角转为半角，1半角转为全角
/// Output：
///     非0:返回转换后的字符串
///     0：异常
/// CreatDate:2013-04-23
/// w ##class(web.DHCBL.BDP.FunLib).AutoSBDB("东华１２５９ｔｅｓｔ",0)
ClassMethod AutoSBDB(InArgs As %String = "", FLAG As %String = "") As %String
{
    n (InArgs,FLAG)
    s Rtnstr=""   ;"0"
    q:$g(InArgs)="" Rtnstr
    s tmpstr=""
    i FLAG="1" d    ;to SBC
    .f i=1:1:$l(InArgs) d
    ..i $ASCII($EXTRACT(InArgs,i))=32 d
    ...s tmpstr=tmpstr_$c(12288)
    ..e  d
    ...i $ASCII($EXTRACT(InArgs,i))<127 d
    ....s tmpstr=tmpstr_$c($ASCII($EXTRACT(InArgs,i))+65248)
    ...e  s tmpstr=tmpstr_$EXTRACT(InArgs,i)
    e  d
    .f i=1:1:$l(InArgs) d   ;to DBC
    ..i $ASCII($EXTRACT(InArgs,i))=12288 d
    ...s tmpstr=tmpstr_$c(32)
    ..e  d
    ...i ($ASCII($EXTRACT(InArgs,i))<65375)&($ASCII($EXTRACT(InArgs,i))>65280) d
    ....s tmpstr=tmpstr_$c($ASCII($EXTRACT(InArgs,i))-65248)
    ...e  s tmpstr=tmpstr_$EXTRACT(InArgs,i)
    s:tmpstr'="" Rtnstr=tmpstr
    q Rtnstr
}

/// Creator:陈莹
/// Description:判断类方法里某个ClassMethod有几个入参
/// Input：  ClassName:类名称,如"web.DHCBL.BDP.FunLib"，ClassMethod:类方法名称,如："IsValidMethodName"
/// w ##class(web.DHCBL.BDP.FunLib).GetCMInParaNum("web.UDHCJFPRICE","GetOrderPrice")
ClassMethod GetCMInParaNum(ClassName As %String = "", ClassMethod As %String = "") As %String
{
    n (ClassName,ClassMethod)
    s mylen=""
    q:((ClassName="")!(ClassMethod="")) mylen
    s myCID=ClassName_"||"_ClassMethod
    s myobj=##class(%Dictionary.CompiledMethod).%OpenId(myCID)
    q:('$IsObject(myobj)) mylen
    ;myobj.FormalSpec     pattype,instype,arcim,sttdate,prior,instr,linkto,oeprice,HospID,ExpStr:%String=""
    s mylen=$l(myobj.FormalSpec,",")
    d myobj.%Close()
    q mylen
}

/// Creator:陈莹
/// Description:判断类是否存在
/// Input：  classname:类名称,如"web.DHCBL.BDP.FunLib"
/// Output：1:存在，0:不存在
/// CreatDate:2016-4-8
/// w ##class(web.DHCBL.BDP.FunLib).IsValidClassName("web.DHCBL.BDP.FunLib")
ClassMethod IsValidClassName(classname As %Library.String) As %Library.Boolean
{
    n (classname)
    q:(classname="") 0
    //set myobj = ##class(%Dictionary.ClassDefinition).%OpenId(classname,0)
    s myobj=##class(%Dictionary.CompiledClass).%OpenId(classname)
    s myrtn=0
    i ($IsObject(myobj)){
        s myobj=""
        s myrtn = 1
    }
    q myrtn
}

/// Creator:陈莹
/// Description:判断某个类方法是否存在
/// Input：  classname:类名称,如"web.DHCBL.BDP.FunLib"，methodname:类方法名称,如："IsValidMethodName"
/// Output：1:存在，0:不存在
/// CreatDate:2016-4-8
/// w ##class(web.DHCBL.BDP.FunLib).IsValidMethodName("web.DHCBL.BDP.FunLib","IsValidMethodName")
ClassMethod IsValidMethodName(classname As %Library.String, methodname As %Library.String) As %Library.Boolean
{
    n (classname, methodname)
    q:((classname="")||(methodname="")) 0
    s myobj=##class(%Dictionary.CompiledMethod).%OpenId(classname_"||"_methodname)
    s myrtn=0
    i ($IsObject(myobj))
    {
        s myobj=""
        s myrtn = 1
    }
    q myrtn
}

/// Creator:陈莹
/// Description:判断Query是否存在
/// Input：  classname:类名称,如"web.DHCBL.BDP.FunLib",queryname：Query名称，如"GetList"
/// Output：1:存在，0:不存在
/// CreatDate:2016-4-8
/// w ##class(web.DHCBL.BDP.FunLib).IsValidQueryName("web.DHCBL.CT.ARCItemCat","GetList")
ClassMethod IsValidQueryName(classname As %Library.String, queryname As %Library.String) As %Library.Boolean
{
    n (classname, queryname)
    q:((classname="")||(queryname="")) 0
    s myobj=##class(%Dictionary.CompiledQuery).%OpenId(classname_"||"_queryname)
    s myrtn=0
    i ($IsObject(myobj))
    {
        s myobj=""
        s myrtn = 1
    }
    q myrtn
}

/// Creator:陈莹
/// CreatDate:2021-06-16
/// Description:判断表内某Property属性是否存在
/// Input:包名,类名,字段名
/// Return: 存在1,不存在0
/// w ##class(web.DHCBL.BDP.FunLib).IsValidPropertyName("web.Entity.CT.MRCICDDx","MRCIDCode")
ClassMethod IsValidPropertyName(classname As %String, Property As %String)
{
	n (classname,Property)
	q:(classname="")||(Property="") 0
	s myrtn=0
	set myobj=##class(%Dictionary.PropertyDefinition).%OpenId(classname_"||"_Property,0)
	i ($IsObject(myobj))
	{
		s myobj=""
		s myrtn = 1
	}
	q myrtn
}

/// Creator:陈莹
/// Description:快速排序
/// Input：a 数组   排序从a(1)到a(n)
/// Output：排序号的数据依次从小到大    左边最小
/// CreatDate:2016-4-8   
/// d ##class(web.DHCBL.BDP.FunLib).QuickSort(.a,1,n)
ClassMethod QuickSort(ByRef a As %String, left As %String, right As %String) As %String
{
    n (a,left,right)
    S $ZT="QSERROR"
    s m=a(left),temp=0
    s i=left,j=right
    while(i<j)
    {
        for
        {
            if (i<j)&(a(j)>=m)
            {
                 s j=j-1
            }
            else 
            {
                  s temp=m
                  s a(i)=a(j)
                  s a(j)=temp
            }
            quit:a(j)=m   
        }
        for
        {
            if (i<j)&(a(i)<=m)
            {
                s i=i+1
            }
            else 
            {
                s temp=m
                s a(j)=a(i)
                s a(i)=temp
            }
            quit:a(i)=m
            
        }
    }
    s a(i)=m
    
    ///add@2018-07-05已经排好序后不再进行循环，以防出现循环超过30次提示MAXSCOPE错误 chenying
    s flag=1
    for m=left:1:(right-1)
    {
	    if (a(m)>a(m+1))
	    {
		    s flag=0
		    q	     
	    }    
    }
    if flag=0
    {
	    if ((i-left)>1)
	    {
		    d ..QuickSort(.a,left,i-1)
		    
	    }
	    if ((right-i)>1)
	    {
		    d ..QuickSort(.a,i+1,right)
		  
	    }
    }
    q i
QSERROR
	Q i
}

/// Creator:陈莹
/// Description:快速排序  降序
/// Input：a 数组   排序从a(1)到a(n)
/// Output：排序号的数据依次从大到小    左边最大
/// CreatDate:2016-4-8
/// d ##class(web.DHCBL.BDP.FunLib).QuickSort(.a,1,n)
ClassMethod QuickSortDesc(ByRef a As %String, left As %String, right As %String) As %String
{
	n (a,left,right)
    S $ZT="QSERRORD"
	s m=a(left),temp=0
	s i=left,j=right

	while (i<j)
	{
		for
		{
			if ((i<j)&(a(j)<=m))  s j=j-1        //a(j)>=m ,不加=号的话，当输入相等的数时会报错
			else  s temp=m,a(i)=a(j),a(j)=temp 
			quit:a(j)=m
		}
		for
		{
			if ((i<j)&(a(i)>=m)) s i=i+1         //a(i)<=m ,不加=号的话，当输入相等的数时会报错
			else  s temp=m,a(j)=a(i),a(i)=temp
			quit:a(i)=m 
		}
	}
	s a(i)=m
	s flag=1
    for m=left:1:(right-1)
    {
	    if (a(m)<a(m+1))
	    {
		    s flag=0
		    q	     
	    }    
    }
    if flag=0
    {
		if ((i-left)> 1)
		{
			d ..QuickSortDesc(.a,left,i-1)
		}
		if ((right-i)> 1)  
		{
			d ..QuickSortDesc(.a,i+1,right)
		}
    }
	quit i
QSERRORD
	Q i
}

/// Function:字符串长度不够时，前面自动补0使字符串长度为num
/// Creator:陈莹
/// CreateDate: 2016-12-23
/// Debug: w ##class(web.DHCBL.BDP.FunLib).AddZEROToStr("332",6)    /// -->000332
ClassMethod AddZEROToStr(str, len) As %String
{
	n (str,len)
	if str="" s str="1"  //空字符串 返回以0开头的 1 数据
	s char=0
	set mylen = $l(str)
	set mystr = str
	if mylen>=len quit str
	for i=1:1:len-mylen set mystr=char_mystr
	quit mystr
}

/// 获取系统日期格式配置
/// @return 
///    1 MM/DD/YYYY
///    3 YYYY-MM-DD
///    4 DD/MM/YYYY
ClassMethod DateFormat()
{
	n
	s dateformat=$lg($g(^websys.ConfigurationD(1)),10)
	s datesper=$lg($g(^websys.ConfigurationD(1)),4)
	i (dateformat="DMY") Quit 4
	i (dateformat="YMD") Quit 3
	Quit 3
}

/// Creator:chenying
/// CreatDate:2017-2-28
/// FunLib.js获取系统日期格式配置
ClassMethod GetDateFormat()
{
	n
	s dateformat=$lg($g(^websys.ConfigurationD(1)),10)
	s datesper=$lg($g(^websys.ConfigurationD(1)),4)
	
	i (dateformat="DMY")||(dateformat="") Quit "j/n/Y"
	i (dateformat="YMD") Quit "Y-m-d"
	Quit "Y-m-d"  ///2017-11-9 默认 为 2017-11-09 格式
}

/// Creator:chenying
/// CreatDate:2017-2-28
/// Input:"2016-11-20"
/// Retunr:64242
/// Description:根据config修改输出日期格式  数字转日期格式
/// w ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(64242)
ClassMethod DateLogicalToHtml(h As %String) As %String [ Final ]
{
	;w ##class(websys.Conversions).DateLogicalToHtml()
	n (h)
	s $ZT="ErrD"
	s ret=""
	Q:h="" ""
	Q:h=0 ""
	s h=$tr(h,"""","")
	s h=$p(h,",",1)
	//; 不全是数字且不包含逗号,则返回h  66666,34444
	Q:(h'?1n.n)&&(h'[",") h
	s dateformat=$lg($g(^websys.ConfigurationD(1)),10)
	//s myobj=##class(%Dictionary.CompiledMethod).%OpenId("websys.Conversions||DateLogicalToHtml")
    //i ($IsObject(myobj)){
       s ret= ##class(websys.Conversions).DateLogicalToHtml(+h)
    //}
	i (dateformat="YMD")&&(ret["/") s ret=$TR(ret,"/","-")   ///老系统里 YMD  会转换成2017/02/28  需要换成2017-02-28才对
	q ret
ErrD
	q ""
}

/// Creator:chenying
/// CreatDate:2017-2-28
/// Input:"2016-11-20"
/// Retunr:64242    
/// Description:根据config修改输入格式   日期格式转数字
/// w ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical("2016-11-20")
ClassMethod DateHtmlToLogical(d As %String) As %String [ Final ]
{
	n (d)
	s $ZT="ErrD2"
	s ret=""
	Q:d="" ""
	///全是数字就返回d
	Q:d?1n.n d
	if d["/"
	{
		///兼容年/月/日格式 2019/04/02
		if ($l($p(d,"/",3))=2)&&($l($p(d,"/",1))>2)
		{
			s d=$tr(d,"/","-")
		}
		else
		{
			s year=$p(d,"/",3)
			if year<1841 q ""
		}
	}
	if d["-"
	{
		s year=$p(d,"-",1)
		if year<1841 q ""
	}
	
	s str=$tr($tr($tr(d,"-",""),",",""),"/","")
	
	if (str?1n.n)
	{	
		//s myobj=##class(%Dictionary.CompiledMethod).%OpenId("websys.Conversions||DateHtmlToLogical")
	    //i ($IsObject(myobj)){
	       s ret= ##class(websys.Conversions).DateHtmlToLogical(d)
	    //}
	    if ret'>0 d ErrD2
	}
	q ret
ErrD2
	quit ""
}

/// Creator:chenying
/// CreatDate:2017-7-18
/// Input:"2017/07/18"
/// Retunr:64242    
/// Description:  2017/07/18
/// w ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical("2017/07/18")
ClassMethod DateHtmlToLogicalYmd(d As %String) As %String [ Final ]
{
	n (d)
	s ret=""
	Q:d="" ""
	///全是数字就返回d
	Q:d?1n.n d
	s $ZT="ErrD3"
	Q $zdh(d,15)	
ErrD3
	Q "ERROR!"
}

/// Creator:chenying
/// CreatDate:2017-2-28
/// Description:根据config获取时间格式
ClassMethod TimeFormat()
{
	n
	s Config=$g(^websys.ConfigurationD(1))
	s timeformat = $Lg(Config,11)
	
	if (timeformat="HM"){ //24小时
		Set timeformat=2
	}elseif (timeformat="HMS"){ //24小时
		Set timeformat = 1
	}elseif (timeformat="hms"){	//12小时
		Set timeformat = 3
	}elseif (timeformat="hm"){  //12小时
		Set timeformat = 4
	}
	Set:timeformat="" timeformat=1
	quit timeformat
}

/// Creator:chenying
/// CreatDate:2017-2-28
/// Input:15444,1
/// Retunr:04:17:24
/// Description:根据config修改输入格式   数字转时间格式
/// @param h      数字时间
/// @param format 默认走系统配置HM, 其它和$zt一样,为空时为 HH:MM,1时为HH:MM:SS
/// w ##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(15444,1)
ClassMethod TimeLogicalToHtml(h As %String, format = "") As %String [ Final ]
{
	n (h, format)
	s $ZT="ErrT1"
	; w ##class(websys.Conversions).TimeLogicalToHtml(15444)
	Q:h="" ""
	Q:h'?1n.n h
	s time=""
	//s myobj=##class(%Dictionary.CompiledMethod).%OpenId("websys.Conversions||TimeLogicalToHtml")
    //i ($IsObject(myobj)){
	   s time= ##class(websys.Conversions).TimeLogicalToHtml(h,format)
    //}
    q time
ErrT1
	if +h>0 s h=$zt(+h,1)
	q h
}

/// Creator:chenying
/// CreatDate:2017-2-28
/// Input:"23:17:24",1
/// Retunr:83820
/// Description:根据config修改输入格式   时间转数字
/// w ##class(web.DHCBL.BDP.FunLib).TimeHtmlToLogical("23:17:24")
/// w ##class(web.DHCBL.BDP.FunLib).TimeHtmlToLogical("23:17:24",1)
ClassMethod TimeHtmlToLogical(t As %String, format = "") As %String [ Final ]
{
	n (t,format)
	s $ZT="ErrT2"
	Q:t="" ""
	Q:t?1n.n t   //1n.n 全是数字
	s t=$tr(t,"：",":")
	s t=$tr(t," ","")
	s t=$tr(t,"'","")
	q:t'[":" ""
	Q:t="" ""
	s time=""
	//s myobj=##class(%Dictionary.CompiledMethod).%OpenId("websys.Conversions||TimeHtmlToLogical")
    // i ($IsObject(myobj)){
	   s time= ##class(websys.Conversions).TimeHtmlToLogical(t,format)
    //}
	q time
ErrT2
	q ""
}

/// Creator:chenying
/// CreatDate:2017-2-28
/// Input:"4.334"
/// Description:验证传过来的值是不是非负数(0及正数) 
/// 考虑 3.   .5555    3加空格
/// 可用于判断价格是否有效 
/// w ##class(web.DHCBL.BDP.FunLib).IsNonnegativeNumber("-3.44")  -1
/// w ##class(web.DHCBL.BDP.FunLib).IsNonnegativeNumber("3.4")  3.4
/// w ##class(web.DHCBL.BDP.FunLib).IsNonnegativeNumber("3.4元")  -1
/// Retunr:-1  不是数字    >=0 返回数字本身
ClassMethod IsNonnegativeNumber(number) As %String
{
	n (number)
	q:number="" ""
	s flag=0
	if number["-" q -1
	s number=..trim(number)   //过滤末尾空格
	if number["."
	{
		s length=$l(number,".")
		if length>2     
		{
			q -1   ///只能有一个小数点
		}
		else
		{	
			s number1=$tr(number,".","")
			if number1?1n.n  q number
			else  q -1
		}		
	}
	else
	{
		if number?1n.n  q number
		else  q -1
		
	}
}

/// Creator:chenying
/// CreatDate:2017-2-28
/// Input:"4.334"
/// Description:验证传过来的值是不是正整数
/// 3加空格
/// 可用与判断价格是否有效 
/// w ##class(web.DHCBL.BDP.FunLib).IsPositiveInteger("-3.44")  0
/// w ##class(web.DHCBL.BDP.FunLib).IsPositiveInteger("3.4")  1
/// w ##class(web.DHCBL.BDP.FunLib).IsPositiveInteger("3")  3
/// -1  不是正整数   
/// >0 返回数字本身
ClassMethod IsPositiveInteger(number) As %String
{
	n (number)
	q:number="" ""
	s flag=0
	if number["-" q -1
	s number=..trim(number)   //过滤末尾空格
	if number=0 q -1
	if $l(number,".")=2  ///考虑95.0
	{
		s str=$p(number,".",2)
		if (str["0")
		{
			if $tr(str,"0","")="" q number
			
		}
		else
		{
			q -1
		}
	}
	if number?1n.n  q number
	else  q -1
}

/// Creator：基础数据平台组 陈莹
/// CreatDate: 2017-3-15
/// Description：去掉字符串末尾的空格 中间的空格不处理
/// w ##class(web.DHCBL.BDP.FunLib).trim(" v  dv fdfv   ")
/// 输入" v  dv fdfv   ",返回" v  dv fdfv"
ClassMethod trim(str) As %String
{
	n (str)
	While ($e(str,$l(str))=" ")
	{
		s str=$e(str,1,$l(str)-1)
	}
	q str
}

/// Function:全角转半角后并返回字符串的 编码 的首字母
/// Creator:陈莹
/// CreatDate:2017-03-27
/// Input：  HANZI:汉字
///             FLAG:返回何种编码(1:ASC码,2:汉字,3:拼音,4:首拼,5:四角码,6:五笔码,7:区位码,8:笔划数,9:郑码)
///             SPLIT:分割符(可以为空)
/// Output：返回字符串的编码(1:ASC码,2:汉字,3:拼音,4:首拼,5:四角码,6:五笔码,7:区位码,8:笔划数,9:郑码)的首字母
/// Debug:  w ##class(web.DHCBL.BDP.FunLib).GetSCNCODE("取是是",4,"")
ClassMethod GetSCNCODE(HANZIS As %String = "", FLAG As %String = "", SPLIT As %String = "") As %String
{
    n (HANZIS,FLAG,SPLIT)
    s Rtnstr=""
    q:$g(HANZIS)="" Rtnstr
   	s HANZIS=$zcvt(HANZIS,"U")
    f i=1:1:$l(HANZIS) d
    .s HANZI=$EXTRACT(HANZIS,i)
    .s ASCIICODE=$ASCII(HANZI)
    .;to DBC  全角转半角
    .i ASCIICODE=12288 s HANZI=$c(32)
    .i (ASCIICODE<65375)&(ASCIICODE>65280) s HANZI=$c(ASCIICODE-65248)
    .i $D(^DHCCharacterEncoding("0","ASCII",ASCIICODE))'=0 d
    ..s Encodingrowid=$o(^DHCCharacterEncoding("0","ASCII",ASCIICODE,""))
    ..s tmpstr=""
    ..s:FLAG="" tmpstr=$g(^DHCCharacterEncoding(Encodingrowid))
    ..s:FLAG'="" tmpstr=$p($g(^DHCCharacterEncoding(Encodingrowid)),"^",FLAG)
    ..s:tmpstr'="" tmpstr=$e(tmpstr,1)   ///取第一个字母
    ..i Rtnstr=""  d
    ...s Rtnstr=tmpstr
    ..e  d
    ...s Rtnstr=Rtnstr_SPLIT_tmpstr
    .e  d
    ..if (ASCIICODE=32) d    ;  $ASCII(" ")=32
    ...s tmpstr=" "
    ...i Rtnstr=""  d
    ....s Rtnstr=tmpstr
    ...e  d
    ....s Rtnstr=Rtnstr_SPLIT_tmpstr
    ..else  d
    ...if (Rtnstr="") d
    ....s Rtnstr=HANZI  ///?
    ...else  d
    ....s Rtnstr=Rtnstr_SPLIT_HANZI  ///?
    q Rtnstr
}

/// Function:全角转半角后并返回字符串的五笔码
/// Creator:基础数据平台组 sunfengchao  SPFlag:为1时取首拼，不填时 返回全拼。
/// CreatDate:2016-11-25
/// Input：  HANZI:汉字
/// Output：返回字符串的五笔码
/// Debug:  w ##class(web.DHCBL.BDP.FunLib).GetSWBCODE("取是是")
ClassMethod GetSWBCODE(HANZIS As %String, SPFlag As %String = "") As %String
{
    n (HANZIS,SPFlag)
    s Rtnstr=""
    q:$g(HANZIS)="" Rtnstr
    s HANZIS=$zcvt(HANZIS,"U")
    f i=1:1:$l(HANZIS) d
    .s HANZI=$EXTRACT(HANZIS,i)
    .s ASCIICODE=$ASCII(HANZI)
    .;to DBC  全角转半角
    .i ASCIICODE=12288 s HANZI=$c(32)
    .i (ASCIICODE<65375)&(ASCIICODE>65280) s HANZI=$c(ASCIICODE-65248)
    .i $D(^DHCCharacterEncoding("0","ASCII",ASCIICODE))'=0 d
    ..s Encodingrowid=$o(^DHCCharacterEncoding("0","ASCII",ASCIICODE,""))
    ..s tmpstr=""
    ..s tmpstr=$p($g(^DHCCharacterEncoding(Encodingrowid)),"^",6)
    ..s:SPFlag=1 tmpstr=$e(tmpstr,1)  //取第一位
    ..i Rtnstr=""  d
    ...s Rtnstr=tmpstr
    ..e  d
    ...s Rtnstr=Rtnstr_tmpstr
    .e  d
    ..if (ASCIICODE=32) d    ;  $ASCII(" ")=32
    ...s tmpstr=" "
    ...i Rtnstr=""  d
    ....s Rtnstr=tmpstr
    ...e  d
    ....s Rtnstr=Rtnstr_tmpstr
    ..else  d
    ...if (Rtnstr="") d
    ....s Rtnstr=HANZI
    ...else  d
    ....s Rtnstr=Rtnstr_HANZI
    q Rtnstr
}

/// Function:清理基础数据平台有关的数据
/// Creator:陈莹
/// CreatDate:2017-03-30
/// w ##class(web.DHCBL.BDP.FunLib).ClearBDPHistoryData()
ClassMethod ClearBDPHistoryData()
{
	n
	//清除组内授权
	d ##class(web.DHCBL.BDP.BDPPreferences).MDeleteData()
	//导入菜单颜色标记
	k ^TMPHASIMPORT("BDPData")
	//日志审计
	k ^BDPDATAAUDIT
	
	///用户习惯
	k ^User.BDPUserHabitI
	k ^User.BDPUserHabitD
	//排序
	k ^User.BDPSortD
	k ^User.BDPSortI
	
	///别名描述检索配置
	K ^User.BDPAliasConfigureD
	K ^User.BDPAliasConfigureI

	///错误日志
	k ^BDPERROR
	
	//基础数据日志管理
	k ^User.BDPDataChangeLogD
	k ^User.BDPDataChangeLogI
	k ^BDPChangeLogLogD //物资日志关联relaventkey
	k ^BDPChangeLogLogI
	
	//版本号及关联表
	k ^User.BDPTableVersionI
	k ^User.BDPTableVersionI
	k ^User.BDPTableVersionLinkDataD
	k ^User.BDPTableVersionLinkDataI
	
	
	//多院区业务配置 和明细 2021-11-15
	k ^User.BDPHospitalServiceConfigD
	k ^User.BDPHospitalServiceConfigI
	k ^User.BDPHospSerConfigCategoryD
	k ^User.BDPHospSerConfigCategoryI
	
	//清除医呼通相关数据
	k ^CT("EQ"),^CT("HCCSEQ")  //医呼通设备
	k ^CT("HCCSELCL")  //医呼通设备关联个人通讯录
	k ^CT("HCCSCL")   //个人通讯录
	k ^CT("HCCSGROUP")  //通讯录群组、群组关联个人通讯录
	k ^CT("HCCSPRE"),^CT("PRE")  //通讯录授权
	k ^CT("HCCSLOC") //医呼通科室 、医呼通科室关联HIS科室
	k ^CT("HCCSAUTLOC") //科室授权（个人通讯录表的科室 关联 授权科室）
	k ^CT("HCCSVDT"),^CT("VDT")  //语音备忘录类型
	d ##class(web.DHCBL.BDP.BDPMappingHOSP).DeleteTableHospitals("CT_HCCSEquipment")
	d ##class(web.DHCBL.BDP.BDPMappingHOSP).DeleteTableHospitals("CT_HCCSContactList")
	d ##class(web.DHCBL.BDP.BDPMappingHOSP).DeleteTableHospitals("CT_HCCSGroup")
	d ##class(web.DHCBL.BDP.BDPMappingHOSP).DeleteTableHospitals("CT_HCCSLocation")
	d ##class(web.DHCBL.BDP.BDPMappingHOSP).DeleteTableHospitals("CT_HCCSVoiceDeviceType")
	
	
	Q ""
}

/// Function:
/// Creator:陈莹
/// CreatDate:2017-04-05
/// 先清掉，再导入基础数据平台组数据  （慎重执行）
/// w ##class(web.DHCBL.BDP.FunLib).ImportData("D:\","BDP.gof")
ClassMethod ImportData(dir, filename)
{
	n (dir,filename)
	//别名
	k ^User.BDPAliasI
	k ^User.BDPAliasD
	d ##class(web.DHCBL.BDP.BDPPreferences).MDeleteData()
	
	//日志审计
	k ^BDPDATAAUDIT
	
	///用户习惯
	k ^User.BDPUserHabitI
	k ^User.BDPUserHabitD
	
	//翻译
	k ^User.BDPTranslationD
	k ^User.BDPTranslationI
	
	//排序
	k ^User.BDPSortD
	k ^User.BDPSortI
	
	///别名描述检索配置
	K ^User.BDPAliasConfigureD
	K ^User.BDPAliasConfigureI
	
	//国家标准编码类别对照
	k ^User.BDPMenuNATDataTypeD
	k ^User.BDPMenuNATDataTypeI
	
	///国家标准元值域
	k ^BDPDATADOMAIN 
	k ^BDPDOMAINTYPE
	
	///国家标准编码
	k ^User.BDPStandardCodeI
	k ^User.BDPStandardCodeD

	
	///错误日志
	k ^BDPERROR
	
	//日志
	k ^User.BDPDataChangeLogD
	k ^User.BDPDataChangeLogI

	k ^User.BDPEILinkD
  	k ^User.BDPEILinkI
  	k ^User.BDPEIMenuD
  	k ^User.BDPEIMenuI
  	k ^User.BDPEXConfigC
  	k ^User.BDPEXConfigD
  	k ^User.BDPEXConfigI
  	k ^User.BDPEXFieldConfigI
  	k ^User.BDPIMConfigC
  	k ^User.BDPIMConfigD 
  	k ^User.BDPIMConfigI
  	k ^User.BDPIMFieldConfigI
  	
  	k ^User.BDPConfigD
  	k ^User.BDPConfigI
  	k ^User.BDPMenuTableD
  	k ^User.BDPMenuTableI
  	k ^User.BDPTableFieldI
  	k ^User.BDPTableListC
  	k ^User.BDPTableListD
  	k ^User.BDPTableListI
  	
  	///
  	k ^User.BDPExecutablesC
  	k ^User.BDPExecutablesD
  	k ^User.BDPExecutablesI
  	k ^User.BDPExtExecItemI
  	k ^User.BDPMenuD
  	k ^User.BDPMenuI
	d $SYSTEM.OBJ.ImportDir(dir,filename)
	q 1
}

/// d ##class(web.DHCBL.BDP.FunLib).ExportData("D:\BDP.gof")
ClassMethod ExportData(dir)
{
	n (dir)
	k CList
	k myIdx
	
	//平台配置和表结构登记的global——BDPSystemData.gof	
	s CList($i(CList))= "User.BDPConfigD.GBL"
	s CList($i(CList))= "User.BDPConfigI.GBL"	
	s CList($i(CList))= "User.BDPMenuTableD.GBL"
	s CList($i(CList))= "User.BDPMenuTableI.GBL"
	s CList($i(CList))= "User.BDPTableFieldI.GBL"
	s CList($i(CList))= "User.BDPTableListD.GBL"
	s CList($i(CList))= "User.BDPTableListI.GBL"
	s CList($i(CList))= "User.BDPTableListC.GBL"
	;国家标准编码
	//s CList($i(CList))= "BDPDATADOMAIN.GBL"
	//s CList($i(CList))= "BDPDOMAINTYPE.GBL"
	
	
	//菜单和功能大表的global——Menu.gof
	s CList($i(CList))= "User.BDPExecutablesC.GBL"
	s CList($i(CList))= "User.BDPExecutablesD.GBL"
	s CList($i(CList))= "User.BDPExecutablesI.GBL"
	s CList($i(CList))= "User.BDPExtExecItemI.GBL"
	s CList($i(CList))= "User.BDPMenuD.GBL"
	s CList($i(CList))= "User.BDPMenuI.GBL"
	s CList($i(CList))= "User.BDPIconManageD.GBL"
	s CList($i(CList))= "User.BDPIconManageI.GBL"
    
    //导入导出的global——BDPDataIMEX
	s CList($i(CList))= "User.BDPEILinkD.GBL"
	s CList($i(CList))= "User.BDPEILinkI.GBL"
	s CList($i(CList))= "User.BDPEXConfigC.GBL"
	s CList($i(CList))= "User.BDPEXConfigD.GBL"
	s CList($i(CList))= "User.BDPEXConfigI.GBL"
	s CList($i(CList))= "User.BDPEXFieldConfigI.GBL"
	s CList($i(CList))= "User.BDPIMConfigC.GBL"
	s CList($i(CList))= "User.BDPIMConfigD.GBL"
	s CList($i(CList))= "User.BDPIMConfigI.GBL"
	s CList($i(CList))= "User.BDPIMFieldConfigI.GBL"
	s CList($i(CList))= "User.BDPEIMenuD.GBL"
	s CList($i(CList))= "User.BDPEIMenuI.GBL"
	
	s items = ""
	f {
		s myIdx = $i(myIdx)
		q:(myIdx>$g(CList))
		s:((items'="")&&(CList(myIdx)'="")) items= items_","

		s items = items_CList(myIdx)
	}

	d $SYSTEM.OBJ.Export(items, dir, "", .log)
	q 1
}

/// CreatDate:2017-06-22
/// Creator:chenying
/// Description：处理数据的不可见字符，ASCii表中前33位是不可见字符
/// Description：Ext 前台在处理含不可见字符的jason数据时处理不了，查询不会显示数据，不会报错。
/// w ##class(web.DHCBL.BDP.FunLib).TR()
ClassMethod TR(Info)
{
	n (Info)
	Quit:Info="" ""
	For i=0:1:32 Do
	.Set Info=$tr(Info,$c(i),"")
	.For j=0:1:32 Do
	..Set Info=$tr(Info,$c(i,j),"")
	
	Quit Info
}

/// Creator:陈莹
/// CreatDate:2016-12-2
/// Description:获取返回json结果的id值
/// Input:str:{success:'true',id:'4444'}
/// Return:rowid :4444
/// Other:w ##class(web.DHCBL.BDP.FunLib).GetResultRowId("{success:'true',id:'4444'}")
ClassMethod GetResultRowId(str) As %String
{
	n (str)
	s rRowId=""
	s str=$e(str,2,$l(str)-1)
	s str=$tr(str,"""","")
	s str=$tr(str,"'","")
	s str=$tr(str,$c(34),"")
	if (str["success:true")||(str["success:'true'")||(str["'success':'true'")
	{	
	
		s length=$l(str,",")
		for i=1:1:length
		{
			s istr=$p(str,",",i)
			s prop=$p(istr,":",1)
			if prop="id"
			{
				s rRowId=$p(istr,":",2)
			}
		}
		
	}
	q rRowId
}

/// Function: 提供query查询的接口
/// CreateDate:2017-07-07
/// Creator:  陈莹 
/// 适用于医嘱项。收费项。诊断、手术等有自己的别名表的
/// Debug:    w ##class(web.DHCBL.BDP.FunLib).GetAliasFlag("F","霍乱用","霍乱")
ClassMethod GetAliasFlag(LookUpMode As %String, Desc As %String, alias As %String) As %String
{
	new (LookUpMode,Desc,alias) 
	if (alias'="")&(Desc="") q 0
	if (alias="")&(Desc="") q 1
	s:alias'="" alias=$zcvt(alias,"U")
	s:Desc'="" Desc=$zcvt(Desc,"U")
	s AlasFlag=0
	;1 检索模式为空或者是 F 时 :模糊检索
	if ((LookUpMode="")||(LookUpMode="F"))
	{
		if (Desc[alias) s AlasFlag=1
	}

	;2检索模式不为空； A 精确检索  
	if (LookUpMode="A")
	{
		s AlasFlag=0 
		for j=1:1:$Length(Desc,"^")
		{
			s SearchDesc=$p(Desc,"^",j)
			if (SearchDesc=alias) s AlasFlag=1
		}
	}

	;3 当查询模式为 L: 左匹配检索
	if (LookUpMode="L")
	{ 
		s AlasFlag=0 
		s aliaslen=$Length(alias)
		for j=1:1:$Length(Desc,"^")
		{
			s SearchDesc=$p(Desc,"^",j)
			s SearchDescS=$e(SearchDesc,1,aliaslen)  
			if (SearchDescS=alias) s AlasFlag=1
		}
		
	}   
	q AlasFlag
}

/// Creator:陈莹
/// CreatDate:2018-10-08
/// Description：优化返回的错误信息
/// Input：sc
/// Return:返回的错误信息
/// Other:w ##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
ClassMethod GetErrorInfo(sc)
{
	n (sc)
	s ErrorInfo=$SYSTEM.Status.GetErrorText(sc)
	//s ErrorInfo=##class(web.DHCBL.BDP.FunLib).EvalJSON(ErrorInfo)
	s ErrorInfo = ##class(web.BDP.util.String).Replace(ErrorInfo,"\","\\")
	s ErrorInfo = ##class(web.BDP.util.String).Replace(ErrorInfo,"""","“")
	s ErrorInfo = ##class(web.BDP.util.String).Replace(ErrorInfo,"'","‘")
	//不保留回车换行
	s ErrorInfo = ##class(web.DHCBL.BDP.FunLib).TransLinefeed(ErrorInfo,"")	
	//去掉其他不可见字符
	s ErrorInfo= ##class(web.DHCBL.BDP.FunLib).Util(ErrorInfo)
	q ErrorInfo
}

/// Creator:chenying
/// Description:校验身份证号
/// Input：  身份证号
/// Output：1 校验通过，0校验失败
/// CreatDate:2019-09-16
/// w ##class(web.DHCBL.BDP.FunLib).IsValidIdNum("11010519491231002X")
ClassMethod IsValidIdNum(IdNum) As %String
{
	n (IdNum)
	q:IdNum="" 1
	s length=$L(IdNum)
	s flag=0
	if ((length'=15)&&(length'=18)) q flag
	if $E(IdNum,1)=0 q flag  //1-9
	if (length=15)
	{
		if (length?1n.n)
		{
			s IdNum712=$E(IdNum,7,12)
			s date=$zdh("19"_IdNum712,8)
			if date>+$h 
			{
				s flag=0
			}
			else
			{
				s flag=1
			}
			
		}
		else
		{
			s flag=0
			
		}
	}
	if (length=18)
	{
		s IdNum17=$E(IdNum,1,17)
		if (IdNum17?1n.n)
		{
			s IdNum714=$E(IdNum,7,14)
			
			s date=$zdh(IdNum714,8)
			if date>+$h 
			{
				s flag=0
			}
			else
			{
				///校验码
				s total=($E(IdNum,1)*7)+($E(IdNum,2)*9)+($E(IdNum,3)*10)+($E(IdNum,4)*5)+($E(IdNum,5)*8)+($E(IdNum,6)*4)+($E(IdNum,7)*2)+($E(IdNum,8)*1)+($E(IdNum,9)*6)+($E(IdNum,10)*3)+($E(IdNum,11)*7)+($E(IdNum,12)*9)+($E(IdNum,13)*10)+($E(IdNum,14)*5)+($E(IdNum,15)*8)+($E(IdNum,16)*4)+($E(IdNum,17)*2)
				s yu= total#11
				s validcode=$case(yu,0:1,1:0,2:"X",3:9,4:8,5:7,6:6,7:5,8:4,9:3,10:2,:"")
				IF $E(IdNum,18)'=validcode
				{
					s flag=0
				}
				else
				{
					s flag=1
				}
			}
			
		}
		else
		{
			
			s flag=0
		}
	}
	q flag
}

/// @param path {String} 文件路径。
/// @return sgc {%Stream.GlobalCharacter} 返回字符流对象
/// @other 把文件转成base64的字符流对象
/// s sgc= ##class(web.DHCBL.BDP.FunLib).GetBase64("E:\网络拓扑图.pdf")
/// while('sgc.AtEnd){
///    w sgc.Read(16384)
/// }
ClassMethod GetBase64(path) As %Stream.GlobalCharacter
{
	n (path)
 	#dim sgc As %Stream.GlobalCharacter
 	Set sgc = ##class(%Stream.GlobalCharacter).%New()
    Set path = ##Class(%File).NormalizeFilename(path)
    if '##class(%File).Exists(path) {
	    do sgc.Write("NotExistsFile")
	    Quit sgc
    }
    set fileobj = ##class(%FileBinaryStream).%New()  
    set fileobj.Filename = $g(path)   
    set byteList = fileobj.Read(12288)      ;要为3的倍数,这样补0才不会出问题. 12288 = 3*4*1024，12k  
    while(byteList'=""){ 
    	set baseStr = ##class(%SYSTEM.Encryption).Base64Encode(byteList)
    	s baseStr=$tr(baseStr,$c(10),"")
    	s baseStr=$tr(baseStr,$c(13),"")
    	;w $l(baseStr)->16814->读时要用
        do sgc.Write(baseStr)
        set byteList = ""         
        set byteList = fileobj.Read(12288)
    }     
    do fileobj.%Close()  
    set fileobj=""  
    quit sgc
}

/// @param sgc {%Stream.GlobalCharacter || String} sgc可以为字符流也可为字符串
/// @param path {String} 图片路径 d:\1.jpg
/// @return 1
/// @other 把sgc保存成path图片
/// /
/// w ##class(ext.util.String).Base642Img(str1,"d:1.jpg")
/// w ##class(ext.util.String).Base642Img(sgc,"d:1.jpg")
ClassMethod Base642Img(sgc, path As %String) As %Boolean
{
	if (sgc'=""){
		Set path = ##Class(%File).NormalizeFilename(path)
		Set img = ##class(%FileBinaryStream).%New()
		set img.Filename = $g(path)
		if ($IsObject(sgc)) {	;sgc字符流
			do sgc.Rewind()
			while ('sgc.AtEnd){			
				Set baseStr = sgc.Read(16814) ;不能用16k
				Set byteList = ##class(%SYSTEM.Encryption).Base64Decode(baseStr)
				do img.Write(byteList)	
			}
		}else{	;sgc字符串
			Set byteList = ##class(%SYSTEM.Encryption).Base64Decode(sgc)
			do img.Write(byteList)
		}
		do img.SaveStream()
		do img.%Close()
		set img = ""
	}
	quit $$$OK
}

/// 把pdf文件，转成存base64编码的txt文件
/// w ##class(web.DHCBL.BDP.FunLib).CreatTxt("E:\网络拓扑图.pdf")
ClassMethod CreatTxt(path) As %String
{
	n (path)
	Set path1 = ##Class(%File).NormalizeFilename(path) //获取当前路径 D
    if '##class(%File).Exists(path1) {
	    q "文件不存在"
    }
    s txtpath=$p(path,".pdf",1)_".txt"
    s file=##class(%File).%New(txtpath)
	d file.Open("NWS")
	//d file.WriteLine()  //换行
	//d file.Write($lg($g(^User.CTWebHospitalD(1)),22))
	set fileobj  = ##class(%FileBinaryStream).%New()  
    set fileobj.Filename = $g(path)
    set byteList = fileobj.Read(12288)      ;要为3的倍数,这样补0才不会出问题. 12288 = 3*4*1024，12k  
    s count=0
    while(byteList'=""){ 
    	set baseStr = ##class(%SYSTEM.Encryption).Base64Encode(byteList)
    	s baseStr=$tr(baseStr,$c(10),"")
    	s baseStr=$tr(baseStr,$c(13),"")
    	d file.Write(baseStr)
    	set byteList = fileobj.Read(12288)   
    }   
    do fileobj.%Close()  
	d file.%Save()
	d file.%Close()
	k file
	q "txt生成成功，"_txtpath
}

/// Creator:陈莹
/// CreatDate:2020-02-27
/// 处理字符串的特殊符号,主要是别名  保存了英文的小数点
/// w ##class(web.DHCBL.BDP.FunLib).RemoveSpecialSymbols("")
ClassMethod RemoveSpecialSymbols(Text) As %String
{
	n (Text)
	s Text=$tr(Text,"""","")
	s Text=$tr(Text,"[","")
	s Text=$tr(Text,"]","")
	s Text=$tr(Text,":","")
	s Text=$tr(Text,"*","")
	s Text=$tr(Text,"】","")
	s Text=$tr(Text,"【","")
	s Text=$tr(Text,"{","")
	s Text=$tr(Text,"}","")
	s Text=$tr(Text,"'","")
	s Text=$tr(Text,"‘","")
	s Text=$tr(Text,"“","")
	s Text=$tr(Text,"”","")
	s Text=$tr(Text,"’","")
	s Text=$tr(Text,"′","")
	s Text=$tr(Text," ","")
	s Text=$tr(Text,"(","")
	s Text=$tr(Text,"★","")
	s Text=$tr(Text,"+","")
	s Text=$tr(Text,",","")
	s Text=$tr(Text,"Ａ","α")
	s Text=$tr(Text,"Ｂ","β")
	s Text=$tr(Text,"Γ","γ")
	s Text=$tr(Text,"-","")
	s Text=$tr(Text,"、","")
	s Text=$tr(Text,"—","")
	s Text=$tr(Text,"（","")
	s Text=$tr(Text,"）","")
	s Text=$tr(Text,")","")
	s Text=$tr(Text,"Φ","")
	s Text=$tr(Text,"°","")
	s Text=$tr(Text,"¡","")
	s Text=$tr(Text,"≥","")
	s Text=$tr(Text,"≤","")
	s Text=$tr(Text,"＜","")
	s Text=$tr(Text,">","")
	s Text=$tr(Text,"<","")
	s Text=$tr(Text,"=","")
	s Text=$tr(Text,"$","")
	s Text=$tr(Text,"#","")
	s Text=$tr(Text,"!","")
	s Text=$tr(Text,"！","")
	s Text=$tr(Text,"￥","")
	s Text=$tr(Text,"~","")
	s Text=$tr(Text,"`","")
	s Text=$tr(Text,"ã","a")
	s Text=$tr(Text,"Ã","A")
	s Text=$tr(Text,"·","")
	s Text=$tr(Text,"？","")
	s Text=$tr(Text,"?","")
	s Text=$tr(Text,"，","")
	s Text=$tr(Text,"。","")
	s Text=$tr(Text,"：","")
	s Text=$tr(Text,"Ⅰ","1")
	s Text=$tr(Text,"Ⅱ","2")
	s Text=$tr(Text,"Ⅲ","3")
	s Text=$tr(Text,"Ⅳ","4")
	s Text=$tr(Text,"Ⅴ","5")
	s Text=$tr(Text,"Ⅵ","6")
	s Text=$tr(Text,"Ⅶ","7")
	s Text=$tr(Text,"Ⅷ","8")
	s Text=$tr(Text,"Ⅹ","9")
	s Text=$tr(Text,"×","")
	s Text=$tr(Text,"±","")
	s Text=$tr(Text,"※","")
	s Text=$tr(Text,"/","")
	s Text=$tr(Text,"&","")
	q Text
}

/// Creator:chenying
/// CreatDate:2017-07-12
/// Description:处理字符串里的不可见字符,保留回车换行 (保存数据前调用Save用）
/// w ##class(web.DHCBL.BDP.FunLib).Util(mystr)
ClassMethod Util(mystr) As %String
{
	n (mystr)
	q:(mystr="") mystr	
	for mystri=0:1:31
	{
		continue:mystri=10
		continue:mystri=13
		s mystr = ##class(web.BDP.util.String).Replace(mystr,$c(mystri),"")
	}
	for mystri=158:1:170
	{
		s mystr = ##class(web.BDP.util.String).Replace(mystr,$c(mystri),"")
	}
	Q mystr
}

/// Creator:chenying----停止使用，改成用EvalJSON
/// CreatDate:2017-07-12
/// Description:----停止使用，改成用EvalJSON
/// w ##class(web.DHCBL.BDP.FunLib)Utilstring(mystr)
ClassMethod Utilstring(mystr) As %String
{
	n (mystr)
	q:(mystr="") mystr	
	for mystri=0:1:31
	{
		s mystr = ##class(web.BDP.util.String).Replace(mystr,$c(mystri),"")
	}
	for mystri=158:1:170
	{
		s mystr = ##class(web.BDP.util.String).Replace(mystr,$c(mystri),"")
	}
	Q mystr
}

/*

/// Creator:陈莹
/// CreatDate:2018-06-29  用于查询数据用，比如GetList,OpenData
/// Description：对JSON数据字符特殊字符处理   英文的双引号 单引号转换成中文的引号，其他不可见字符全部去掉（差别：但保留换行）
/// Input：instr -输入的字符串
/// Return:mystr -处理特殊字符后的字符串
/// Other:w ##class(web.DHCBL.BDP.FunLib).EvalJSONB(mystr)
ClassMethod EvalJSONB(instr As %String) As %String
{
	n (instr)
	s mystr = instr
	q:(mystr="") mystr	
	s mystr=$tr(mystr,"'","’")	
	s mystr=$tr(mystr,"""","”")	
	s mystr = ##class(web.BDP.util.String).Replace(mystr,$c(13),"")
	s mystr = ##class(web.BDP.util.String).Replace(mystr,$c(10,10,10),"<br/>")	
	s mystr = ##class(web.BDP.util.String).Replace(mystr,$c(10),"<br/>")	
	s mystr = ##class(web.BDP.util.String).Replace(mystr,"\","\\")	
	
	for i=0:1:31
	{
		continue:i=10
		s mystr = ##class(web.BDP.util.String).Replace(mystr,$c(i),"")
	}
	for i=158:1:170
	{
		s mystr = ##class(web.BDP.util.String).Replace(mystr,$c(i),"")
	}
	q mystr
}

/// Creator:陈莹
/// CreatDate:2018-06-29 用于查询数据用，比如GetList,OpenData
/// Description：对JSON数据字符特殊字符处理   英文的双引号 单引号转换成中文的引号,其他不可见字符全部去掉
/// Input：instr -输入的字符串
/// Return:mystr -处理特殊字符后的字符串
/// Other:w ##class(web.DHCBL.BDP.FunLib).EvalJSON(mystr)
ClassMethod EvalJSON(instr As %String) As %String
{
	n (instr)
	s mystr = instr
	q:(mystr="") mystr	
	s mystr=$tr(mystr,"'","’")	
	s mystr=$tr(mystr,"""","”")	
	s mystr = ##class(web.BDP.util.String).Replace(mystr,$c(13),"")
	s mystr = ##class(web.BDP.util.String).Replace(mystr,$c(10),"")	
	s mystr = ##class(web.BDP.util.String).Replace(mystr,"\","\\")	
	for i=0:1:31
	{
		continue:i=10
		s mystr = ##class(web.BDP.util.String).Replace(mystr,$c(i),"")
	}
	for i=158:1:170
	{
		s mystr = ##class(web.BDP.util.String).Replace(mystr,$c(i),"")
	}
	q mystr
}

*/
/// Creator:陈莹
/// CreatDate:2018-06-29
/// Description： 用于自己拼双引号的json串时调用
///      注意；只适用于自己拼Json串的方法里调用，Query类型、 以及使用了JsonS()的OpenData的字段 不要调用此方法
///      对数据特殊字符处理   \转换成\\  英文的双引号转换成\" ,其他不可见字符全部去掉,在拼Json串之前调用（差别：不保留换行）
/// Input：instr -输入的字符串
/// Return:mystr -处理特殊字符后的字符串
/// Other:w ##class(web.DHCBL.BDP.FunLib).EvalJSON(mystr)
ClassMethod EvalJSON(instr As %String) As %String
{
	n (instr)
	s mystr = instr
	q:(mystr="") mystr	
	s mystr = ##class(web.BDP.util.String).Replace(mystr,"\","\\")
	s mystr = ##class(web.BDP.util.String).Replace(mystr,"""","\""")
	//不保留回车换行
	s mystr = ##class(web.DHCBL.BDP.FunLib).TransLinefeed(mystr,"")	
	//去掉其他不可见字符
	s mystr= ##class(web.DHCBL.BDP.FunLib).Util(mystr)
	q mystr
}

/// Creator:陈莹
/// CreatDate:2020-10-22  
/// Description：用于自己拼双引号的json串时调用，保留换行
///      注意；只适用于自己拼Json串的方法里调用，Query类型、 以及使用了JsonS()的OpenData的字段 不要调用此方法
///      对数据特殊字符处理   \转换成\\  英文的双引号转换成\" ,其他不可见字符全部去掉,在拼Json串之前调用（差别：但保留换行）
/// Input：instr -输入的字符串
/// Return:mystr -处理特殊字符后的字符串
/// Other:w ##class(web.DHCBL.BDP.FunLib).EvalJSONB(mystr)      //保留回车换行 ,用于自己拼Json串的GetData GetData  Method方法
/// Other:w ##class(web.DHCBL.BDP.FunLib).EvalJSON(mystr,"O")   //保留回车换行 ,用于自己拼串的OpenData方法
ClassMethod EvalJSONB(instr As %String, flag As %String = "") As %String
{
	n (instr, flag)
	s mystr = instr
	q:(mystr="") mystr	
	s mystr = ##class(web.BDP.util.String).Replace(mystr,"\","\\")
	s mystr = ##class(web.BDP.util.String).Replace(mystr,"""","\""")
	if (flag="")  //保留回车换行 ,用于自己拼Json串的GetData  Method方法,不适用于Query方法，Query方法里如果要保留回车换行，调用
	{
		s mystr = ##class(web.DHCBL.BDP.FunLib).TransLinefeed(mystr,"G")  //列表里的换行
	}
	elseif (flag="O") //保留回车换行 ,用于自己拼串的OpenData方法
	{
		s mystr = ##class(web.DHCBL.BDP.FunLib).TransLinefeed(mystr,"O")  //弹出框里的换行 
	}
	
	s mystr= ##class(web.DHCBL.BDP.FunLib).Util(mystr)
	q mystr
}

/// Creator:陈莹
/// CreatDate:2020-10-22  
/// Description：用于Query方法里如果某个字段要保留换行调用 (</br/>)
///               使用了JsonS()的OpenData的字段无需调用,自己拼串的OpenData的字段调用
/// Input：instr -输入的字符串
/// Return:mystr -处理特殊字符后的字符串
/// Other:w ##class(web.DHCBL.BDP.FunLib).TransLinefeed(mystr,"")      //不保留回车换行
/// Other:w ##class(web.DHCBL.BDP.FunLib).TransLinefeed(mystr,"G")      //保留回车换行 ,用于Query方法字段要保留换行时
/// Other:w ##class(web.DHCBL.BDP.FunLib).TransLinefeed(mystr,"O")   //保留回车换行 ,用于自己拼串的OpenData方法字段要保留换行时
ClassMethod TransLinefeed(instr As %String, flag As %String = "") As %String
{
	n (instr, flag)
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

/// Creator:陈莹
/// CreatDate:2022-4-17
/// Description：检验组优化表结构索引后，需调用此方法
/// Input：Data  索引数据
/// Return: 处理的索引内容
/// ##Class(web.DHCBL.BDP.FunLib).IndexData()
ClassMethod IndexData(Data As %String) As %String
{
	n (Data)
	s $ZT="ErrorIndex"
	s Data=##Class(LIS.Util.Common).IndexData(Data)
	q Data
ErrorIndex
	s Data=$c(32)_$zcvt(Data,"U")
	q Data
}

}
