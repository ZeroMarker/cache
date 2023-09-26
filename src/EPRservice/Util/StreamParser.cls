Class EPRservice.Util.StreamParser Extends %RegisteredObject [ ProcedureBlock ]
{

/// CreateUser: houj
/// CreateDate: 2010-06-22
/// Desc: 清除XML中的非法字符，共32个，它们是ASCII的前32个不可见控制字符，
/// 	  在XML序列化的过程中，这32个字符会被转化为下列字符，但这些字符在XML反序列化时是非法的。
///       &#x0;	| &#x1; | &#x2; | &#x3; | &#x4; | &#x5; | &#x6; | &#x7; | &#x8; | &#x9;	
///       &#x10; | &#x11; | &#x12; | &#x13; | &#x14; | &#x15; | &#x16; | &#x17; | &#x18; | &#x19;
///       &#x1A; | &#x1B; | &#x1C; | &#x1D; | &#x1E; | &#x1F;
/// Input: argStream
/// Output: %Stream
ClassMethod ClearIllegalChar(argStream As %Stream) As %Stream
{
	
	s retStream = ##class(%GlobalCharacterStream).%New()
	
	d argStream.Rewind()
	
	s flag = 0			//状态标识
	s tmpStr = ""		//缓存字符串
	
	while (argStream.AtEnd = 0)
	{
		s origionStr = argStream.Read(10240)
		s length = $Length(origionStr)
		s okStr = ""
		
		for i = 1:1:length
		{
			s char = $e(origionStr,i,i)
			s tmpStr = tmpStr_char
			
			if (flag=0)
			{
				if (char="&")
				{	s flag = 1}
				else
				{	d ConfirmStr}
			}
			elseif (flag=1)
			{
				if (char="#")
				{	s flag = 2}
				else
				{	d ConfirmStr}
			}
			elseif (flag=2)
			{
				if (char="x")
				{	s flag = 3}
				else
				{	d ConfirmStr}
			}
			elseif (flag=3)
			{
				s cate = $$GetCategory(char)
				if (cate=1)
				{	s flag = 41}
				elseif (cate=2)
				{	s flag = 42}
				else
				{	d ConfirmStr}
			}
			elseif (flag=41)
			{
				if (char=";")
				{	d ClearStr}
				else
				{	d ConfirmStr}	
			}
			elseif (flag=42)
			{
				s cate = $$GetCategory(char)
				if (cate=1)||(cate=2)
				{	s flag=5}
				elseif (cate=3)
				{	d ClearStr}
				else
				{	d ConfirmStr}
			}
			elseif (flag=5)
			{	
				if (char=";")
				{	d ClearStr}
				else
				{	d ConfirmStr}
			}
		}
		
		d retStream.Write(okStr)
	}
	
	if flag>0
	{	d retStream.Write(tmpStr)}
		
	q retStream
	
ConfirmStr
	s flag = 0		//置状态标识为初始值
	s okStr = okStr_tmpStr
	s tmpStr = ""
	
ClearStr
	s flag = 0		//置状态标识为初始值
	s tmpStr = ""	//缓存字符串中内容为非法字符，将其内容清空
	
GetCategory(char)
	//分为三类：
	//第一类：0，2-9，A-F
	//第二类：1
	//第三类：;
	//第四类：其他字符
	q:(char="0") 1
	q:(char>=2)&&(char<=9) 1
	q:(char="A")||(char="B")||(char="C")||(char="D")||(char="E")||(char="F") 1
	q:(char="1") 2
	q:(char=";") 3
	q 4
}

/// CreateUser: houj
/// CreateDate: 2010-05-27	
/// Desc: 清除非法结束符:  &#x0;
/// Intput：argStream 
/// Output：Stream
ClassMethod ClearIllegalEndChar(argStream As %Stream) As %Stream
{
	
	s retStream = ##class(%GlobalCharacterStream).%New()
	
	d argStream.Rewind()
	
	s flag = 0			//状态标识
	s tmpStr = ""		//缓存字符串
	
	while (argStream.AtEnd = 0)
	{
		s origionStr = argStream.Read(10240)
		s length = $Length(origionStr)
		s okStr = ""
		
		for i = 1:1:length
		{
			s char = $e(origionStr,i,i)
			s tmpStr = tmpStr_char
			
			if (char="&")&&(flag=0)
			{
				s flag = 1
			}
			elseif (char="#")&&(flag=1)
			{
				s flag = 2
			}
			elseif (char="x")&&(flag=2)
			{
				s flag = 3
			}
			elseif (char="0")&&(flag=3)
			{
				s flag = 4
			}
			elseif (char=";")&&(flag=4)
			{
				s flag = 0		//置状态标识为初始值
				s tmpStr = ""	//缓存字符串中内容为非法字符，将其内容清空
			}
			else
			{
				s flag = 0		//置状态标识为初始值
				s okStr = okStr_tmpStr
				s tmpStr = ""
			}
		}
		
		d retStream.Write(okStr)
	}
	
	if flag>0
	{	d retStream.Write(tmpStr)}
		
	q retStream
}

/// CreateUser: houj
/// CreateDate: 2013-04-02	
/// Desc: 替换空格:  &nbsp;
/// Intput：argStream 
/// Output：Stream
ClassMethod ReplaceBlankChar(argStream As %Stream) As %Stream
{
	s retStream = ##class(%GlobalCharacterStream).%New()
	
	d argStream.Rewind()
	
	s flag = 0			//状态标识
	s tmpStr = ""		//缓存字符串
	
	while (argStream.AtEnd = 0)
	{
		s origionStr = argStream.Read(10240)
		s length = $Length(origionStr)
		s okStr = ""
		
		for i = 1:1:length
		{
			s char = $e(origionStr,i,i)
			s tmpStr = tmpStr_char
			
			if (char="&")&&(flag=0)
			{
				s flag = 1
			}
			elseif (char="n")&&(flag=1)
			{
				s flag = 2
			}
			elseif (char="b")&&(flag=2)
			{
				s flag = 3
			}
			elseif (char="s")&&(flag=3)
			{
				s flag = 4
			}
			elseif (char="p")&&(flag=4)
			{
				s flag = 5
			}
			elseif (char=";")&&(flag=5)
			{
				s flag = 0		//置状态标识为初始值
				s tmpStr = " "	//缓存字符串中内容为转换后的空格，将其内容替换为" "
				s okStr = okStr_tmpStr
				s tmpStr = ""
			}
			else
			{
				s flag = 0		//置状态标识为初始值
				s okStr = okStr_tmpStr
				s tmpStr = ""
			}
		}
		
		d retStream.Write(okStr)
	}
	
	if flag>0
	{	d retStream.Write(tmpStr)}
		
	q retStream
}

/// CreateUser: houj
/// CreateDate: 2013-04-02	
/// Desc: 替换空格:  &amp;nbsp;
/// Intput：argStream 
/// Output：Stream
ClassMethod ReplaceBlankChar2(argStream As %Stream) As %Stream
{
	s retStream = ##class(%GlobalCharacterStream).%New()
	
	d argStream.Rewind()
	
	s flag = 0			//状态标识
	s tmpStr = ""		//缓存字符串
	
	while (argStream.AtEnd = 0)
	{
		s origionStr = argStream.Read(10240)
		s length = $Length(origionStr)
		s okStr = ""
		
		for i = 1:1:length
		{
			s char = $e(origionStr,i,i)
			s tmpStr = tmpStr_char
			
			if (char="&")&&(flag=0)
			{
				s flag = 1
			}
			elseif (char="a")&&(flag=1)
			{
				s flag = 2
			}
			elseif (char="m")&&(flag=2)
			{
				s flag = 3
			}
			elseif (char="p")&&(flag=3)
			{
				s flag = 4
			}
			elseif (char=";")&&(flag=4)
			{
				s flag = 5
			}
			elseif (char="n")&&(flag=5)
			{
				s flag = 6
			}
			elseif (char="b")&&(flag=6)
			{
				s flag = 7
			}
			elseif (char="s")&&(flag=7)
			{
				s flag = 8
			}
			elseif (char="p")&&(flag=8)
			{
				s flag = 9
			}
			elseif (char=";")&&(flag=9)
			{
				s flag = 0		//置状态标识为初始值
				s tmpStr = " "	//缓存字符串中内容为转换后的空格，将其内容替换为" "
				s okStr = okStr_tmpStr
				s tmpStr = ""
			}
			else
			{
				s flag = 0		//置状态标识为初始值
				s okStr = okStr_tmpStr
				s tmpStr = ""
			}
		}
		
		d retStream.Write(okStr)
	}
	
	if flag>0
	{	d retStream.Write(tmpStr)}
		
	q retStream
}

/// ========== 以下为测试代码 ===========
/// d ##class(EPRservice.Util.StreamParser).Test()
ClassMethod Test() As %String
{
	s inputStream = ##class(%GlobalCharacterStream).%New()
	d inputStream.Write("<NInstanceData><Code>A0000</Code><Value /><ValueCode /><BindKBCode /><SubItems><NISimple><Code>S0001</Code><Value>施炎</Value><ValueCode /><FormatRangeCollection /></NISimple><NISimple><Code>S0002</Code><Value>00834553</Value><ValueCode /><FormatRangeCollection /></NISimple><NISimple><Code>D0021</Code><Value>18:14</Value><ValueCode>1753-1-1 18:14:35</ValueCode><FormatRangeCollection /></NISimple><NISimple><Code>D0003</Code><Value>2010-12-17</Value><ValueCode>2010-12-17 00:00:00</ValueCode><FormatRangeCollection /></NISimple><NISimple><Code>O0007</Code><Value>主治医医师：</Value><ValueCode>4</ValueCode><FormatRangeCollection /></NISimple><NISimple><Code>O0009</Code><Value /><ValueCode /><FormatRangeCollection /></NISimple><NISimple><Code>I0010</Code><Value>郭亮</Value><ValueCode>03260</ValueCode><FormatRangeCollection /></NISimple><NISimple><Code>I0013</Code><Value /><ValueCode /><FormatRangeCollection /></NISimple><NITextDesc><Code>E0019</Code><Value /><ValueCode /><SubItems><NIFree><Code /><Value>&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;施炎，16岁，男，目前诊断为急性肾功能不全，既往无高血压及器质性心脏病史，无胸闷、胸痛，可耐受体育活动，查体：心肺未见异常。ECG示：窦性心动过缓，T波改变。动态心电图示：窦性心律,38-93bpm，平均61bpm，T波改变。超声示：LV&amp;nbsp;51mm，EF&amp;nbsp;63％。血清肌酸激酶测定160U/L，血清肌酸激酶同工酶CK-MM100.0%；钾测定3.64mmol/L。暂无特殊处理，我科门诊随诊。&#x0;&#x0;&#x0;&#x0;&#x0;&#x0;&#x0;&#x0;&#x0;&#x0;&#x0;?&#x0;&#x0;&#x0;&#x0;&#x0;&#x0;&#x0;&#x0;&#x0;&#x0;入院心电图提示：HR：54次/分，ST-T改变，行24小时动态心电图检查回报：窦性心律，最低心率38次/分，发生于5时35分，ST-T改变（与体位有关），请贵科会诊，协助诊治。</Value><ValueCode /><FormatRangeCollection /></NIFree></SubItems><FormatRangeCollection /></NITextDesc><NISimple><Code>S0023</Code><Value>08296183</Value><ValueCode /><FormatRangeCollection /></NISimple><NITextDesc><Code>E0024</Code><Value /><ValueCode /><SubItems><NIFree><Code /><Value>心内科会诊记录</Value><ValueCode /><FormatRangeCollection /></NIFree></SubItems><FormatRangeCollection /></NITextDesc></SubItems></NInstanceData>")
	s outputStream = ..ClearIllegalChar(inputStream)
	d outputStream.Rewind()
	/*
	while outputStream.AtEnd = 0
	{
		w outputStream.Read(300)
	}
	*/
	
	s AFileName=##class(EPRservice.Utility).GetFileName("test111")  
	S stream=##class(%FileCharacterStream).%New()
	S stream.Filename=AFileName
	d stream.TranslateTableSet("UTF8")
	d stream.WriteLine("<?xml version=""1.0"" encoding=""UTF-8""?>")
	while (outputStream.AtEnd = 0)
	{ 
		s readstring=outputStream.Read(1024)
	  	d stream.Write(readstring)
	}
	d stream.SaveStream()
	D stream.%Close()
	
	w AFileName,!
	q "Ok"
}

/// Debug:	d ##class(EPRservice.Util.StreamParser).Test2()
ClassMethod Test2()
{
	s inputStream = ##class(%GlobalCharacterStream).%New()
	d inputStream.Write("我后面应该是三个空格&nbsp;&nbsp;&nbsp;,我后面应该也是一个空格&nbsp;,我后面没有空格.")
	
	s outStream = ..ReplaceBlankChar(inputStream)
	d outStream.Rewind()
	w outStream.Read(10000)
	q
}

/// Debug:	d ##class(EPRservice.Util.StreamParser).Test3()
ClassMethod Test3()
{
	s inputStream = ##class(%GlobalCharacterStream).%New()
	d inputStream.Write("我后面应该是三个空格&amp;nbsp;&amp;nbsp;&amp;nbsp;,我后面应该也是一个空格&nbsp;,我后面没有空格.")
	
	s outStream = ..ReplaceBlankChar2(inputStream)
	d outStream.Rewind()
	w outStream.Read(10000)
	q
}

}
