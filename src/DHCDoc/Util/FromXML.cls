Include (%callout, %occSAX, %occXSLT, %syNLS)

/// 编写者：lixu.
/// 编写日期: 2020-11-07.
/// <p>描述: 用于xml、json、数组间的互转(支持cache2010).
/// <p>主要入口方法：Json2Arr、Json2Obj、FromJSONToArr、Arr2Json、XML2Arr、XML2Obj、Arr2XML、Xml2Json
/// <EXAMPLE>
/// d ##class(DHCDoc.Util.FromXML).TestJsonXML()
/// d ##Class(DHCDoc.Util.FromXML).DemicTest()
/// d ##Class(DHCDoc.Util.FromXML).Help()
/// </EXAMPLE>
Class DHCDoc.Util.FromXML Extends %RegisteredObject
{

/// 使用说明，及后期修改说明
/// d ##Class(DHCDoc.Util.FromXML).Help()
ClassMethod Help() As %String
{
	w "说明：" ,!
	w "    常用方法主入口：Arr2Json、Json2Arr、Arr2XML、XML2Arr." ,!
	w "    如果对象为DHCDoc.Util.ArrayData对象，则可直接使用：%ToJSON、%FromJSON、%ToXML、%FromXML." ,!
	w !
	w "修改日志：" ,!
	w "    2021-08-10：1.修改字段值是json串时不能解析的问题; 2.修改Arr2Json和Arr2XML方法只接受通过DHCDoc.Util.ArrayData定义的数组" ,!
	w "    2021-09-15: 1.高版本xml转json时，父节点不是列表的问题(和低版本保持一致，便于判断节点是否存在列表);" ,!
	w "                2.低版本xml转json时，节点层数错位问题；解析xml时不需传入根节点以及过滤根节点问题." ,!
	w "    2022-06-14：1.修改Cache2016解析XML时,列表节点只有一个时，Count值不对问题" ,!
	w "    2023-03-31：1.增加XMLParse方法，使解析XML的方法以及取值方法更简洁" ,!
	w "                2.针对节点增加%isList属性，如果为1代表此节点是列表节点，解决单一子列表节点Count()判断不准问题" ,!
	w "                3.修改一些已知XML解析的问题" ,!
	w !
	w "注意事项：" ,!
	w "    1.因为数组具有自动排序功能，所以%GetNext时的key是排序后的key,取值最好通过key值来获取." ,!
	w "    2.因为数组中的列表是从1开始的，动态列表是从0开始的，所以高版本中%Get()中的序号取值时需要增加1" ,!
	w "    3.因为Data是数组中的关键字，要是Json串或xml串中有Data节点时，获取数据时不能直接用'.'获取，需用其他方式获取(Data(key))" ,!
	w "    4.节点增加了%isList属性，取列表节点时先判断此属性是否为1，为1后再通过Count()获取列表数量" ,!
	w "    5.cache2010不支持return写法(改造时需注意写法) " ,!
	w !
	w "待解决问题：" ,!
	w "    1.XML存在属性节点时的解析(是否和%Document.Object保持一致)" ,!
	w !
	w "具体列子：" ,!
	w "    d ##class(DHCDoc.Util.FromXML).TestJsonXML()" ,!
	w "    d ##Class(DHCDoc.Util.FromXML).DemicTest()"
	q ""
}

/// 版本设置
/// d ##Class(DHCDoc.Util.FromXML).SetVersion()
ClassMethod SetVersion() As %String
{
	s Version("V1.0.0.1")="2021-09-15:修复json解析,低版本xml转json节点层数错位问题."
	s Version("V1.0.0.2")="2021-11-23:扩展对象属性,支持XML属性,以及可以%New(""节点"")"
	q ""
}

Property Data As %String(MAXLEN = "") [ MultiDimensional ];

/// 行计数器
Property Row As %Integer;

/// 列计数器
Property Col As %Integer;

/// 当前字符
Property Char As %String;

/// 引号标识“"”
Property CharS As %String;

/// 子字符串
Property SubStr As %String(MAXLEN = "");

/// 是否结束
Property AtEnd As %Boolean;

/// 字符串是JSON标识
Property JsonStrFlag As %String;

/// 前一个字符(判断是否是json字符串)
Property PreChar As %String;

/// 特殊符号
Parameter JsonChars = "{[:,]}";

/// 编码转义字符
Parameter EscapeChar As COSEXPRESSION = "$LB($LB(""\"",""\\""),$LB($C(13),""\n""),$LB($C(10),""\r""),$LB($C(9),""\t""),$LB("""""""",""\""""""),$LB($C(8),""\b""),$LB($C(12),""\f""))";

/// 解码转义字符
Parameter UnEscapeChar As COSEXPRESSION = "$LB(""\\"",""\n"",""\r"",""\t"",""\"""""",""\b"",""\f"")";

/// 加载JSON数据
Method SetData(inputJson) As %String
{
	Set $this.Row=0
	Set $this.Col=0
	Set $this.AtEnd=0
	Kill i%Data
	
	Set Count=0
	If $IsObject(inputJson) {
		//输入参数->JSON数据流
		try {
			Do inputJson.Rewind()
			While ('inputJson.AtEnd) {
				Set tmpStr=inputJson.ReadLine(30000)    
				Continue:tmpStr=""
				Set Count=Count+1
				Set i%Data(Count)=tmpStr
			}
		} catch {}
	} Else {
		//输入参数->JSON字符串
		Set Count=Count+1
		Set i%Data(Count)=inputJson
	}
	Quit Count
}

/// 解析JSON数据为数组
Method GetData() As DHCDoc.Util.ArrayData
{
	Set json=##Class(DHCDoc.Util.ArrayData).%New()
	Do ..Next()
    If ($this.Char="{"){
	    Set json=..getJSONObject()
	} ElseIf ($this.Char = "[") {
		Set json=..getJSONArray()
	} Else {
		//Json格式错误
	}
	Quit json
}

/// 移动流数据指针位置
Method Next()
{
	Set $this.Char=""
	Set $this.CharS=""
	Set $this.SubStr=""
	Set $this.JsonStrFlag=0
	If $g(i%Data($this.Row))="" {
		Set $this.Row=$o(i%Data($this.Row))
		Set:$this.Row="" $this.AtEnd=1  //表示结束
		Set $this.Col=0
	}
	Quit:$this.AtEnd //退出
	
	Set iData=$g(i%Data($this.Row))
	While '$this.AtEnd {
		Set $this.Col=$this.Col+1
		If $this.Col>$l(iData) {
			Set $this.Row=$o(i%Data($this.Row))
			Set:$this.Row="" $this.AtEnd=1  //表示结束
			Set $this.Col=1
			Set iData=$g(i%Data($this.Row))
		}
		Quit:$this.AtEnd //退出
		Set $this.Char=$e(iData,$this.Col,$this.Col)
		Set $this.PreChar=$e(iData,$this.Col-1,$this.Col-1)
		Continue:$this.Char=""
		Continue:($this.CharS'="""")&($this.Char=" ")  		//非字符串内空格-->过滤
		If ($this.PreChar="""")&&(($this.Char="{")||($this.Char="[")){
			Set $this.JsonStrFlag=1		//json字符串开始
		}
		If (($this.PreChar="}")||($this.PreChar="]"))&&($this.Char="""") {
			Set $this.JsonStrFlag=2		//json字符串结束
		}
		If ("02")'[$this.JsonStrFlag{
			Set $this.SubStr=$this.SubStr_$this.Char
			Continue
		}
		Quit:($this.CharS'="""")&(..#JsonChars[$this.Char)	//非字符串内特殊符号{[:,]}-->退出
		Continue:($this.CharS="""""")  				//表示双引号之外异常内容处理
		If $this.Char="""" {
			If $this.CharS="" {
				Set $this.CharS=$this.Char
			} ElseIf $this.CharS="""" {
				If ($e($this.SubStr,*)="\") {
					//Set $this.SubStr=$this.SubStr_$this.Char
					//判断是否是标准的转义字符"\\"，且本次节点值已循环完，引号标识应该置为完整""
					if ($e($this.SubStr,*-1)'="\"){		
						Set $this.SubStr=$this.SubStr_$this.Char	
					}
					Set $this.CharS=""""""		
				} Else {
					Set $this.CharS=""""""
				}
			}
		} Else {
			Set $this.SubStr=$this.SubStr_$this.Char
		}
	}
	Quit
}

/// 获取json键值关键字
Method getKey() As %String
{
	Quit ..Unescape($this.SubStr)
}

/// 获取json键值结果
Method getVal() As %String
{
	If ($this.Char="{"){
		Set val=..getJSONObject()
		Do ..Next()
	} ElseIf ($this.Char="["){
		Set val=..getJSONArray()
		Do ..Next()
	}Else {
		If $this.JsonStrFlag'=2{
			Set val=..Unescape($this.SubStr)
		}else{
			;json字符串原样返回
			Set val=..Replace($this.SubStr, "\\", "\")
			Set val=..Replace(val, "\""", """")
		}
	}
	Quit val
}

/// 解析json对象
Method getJSONObject() As DHCDoc.Util.ArrayData
{
	Set jsonObj=##Class(DHCDoc.Util.ArrayData).%New()
	While '$this.AtEnd {
		Do ..Next()
		Set key="",val=""
		Set key=..getKey()
		If ($this.Char=":"){
			Do ..Next()
			Set val=..getVal()
		}
		//空值也要有输出
		If (key'=""){
			Do jsonObj.SetAt(val,key)
		}
		Continue:$this.Char=","  //如果是,继续
		Quit:$this.Char="}"  //如果是}结束
		Quit //程序错误
    }
    Quit jsonObj
}

/// 解析josn数组
Method getJSONArray() As DHCDoc.Util.ListData
{
	;Set jsonArr=##Class(%ArrayOfDataTypes).%New()
	;改为list，这样arr转xml的时候就不会有数字节点
	Set jsonArr=##Class(DHCDoc.Util.ListData).%New()
	While '$this.AtEnd {
		Do ..Next()
		Set val=..getVal()
		If val'="" {
			;Do jsonArr.SetAt(val,jsonArr.Count()+1)
			Do jsonArr.Insert(val)
		}
		Continue:$this.Char=","  //如果是,继续
		Quit:$this.Char="]"  //如果是}结束
		Quit //程序错误
	}
	Quit jsonArr
}

/// 给Json字符串转码(增加流转义，防止字符串转换后超长)
ClassMethod Escape(str) [ Internal ]
{
	s NewStr=""
	if $IsObject(str){
		;增加流转义处理
		s NewStr=##Class(%Stream.GlobalCharacter).%New()
		do str.Rewind()
		while 'str.AtEnd {
			s RtnStr = str.Read(20000)
			For tI=1:1:$LL(..#EscapeChar) { 
				Set tCharPair=$LG(..#EscapeChar,tI)
				Set RtnStr=$Replace(RtnStr,$LG(tCharPair,1),$LG(tCharPair,2))
			}
			do NewStr.Write(RtnStr)
		}
		do str.Rewind()
	}else{
		For tI=1:1:$LL(..#EscapeChar) { 
			Set tCharPair=$LG(..#EscapeChar,tI)
			Set NewStr=$Replace(str,$LG(tCharPair,1),$LG(tCharPair,2))
		}
	}
	Quit NewStr
}

/// 给Json字符串解码
ClassMethod Unescape(instr As %String) As %String [ Internal ]
{
	Quit:(instr="") instr
	//特殊字符处理
	//Set instr = $ZCVT(instr,"I","JSON")
	Set instr = ..Replace(instr, "\u0000", $c(0))
	Set instr = ..Replace(instr, "\u0001", $c(1))
	Set instr = ..Replace(instr, "\u0002", $c(2))
	Set instr = ..Replace(instr, "\u0003", $c(3))
	Set instr = ..Replace(instr, "\u0004", $c(4))
	Set instr = ..Replace(instr, "\u0005", $c(5))
	Set instr = ..Replace(instr, "\u0006", $c(6))
	Set instr = ..Replace(instr, "\u0007", $c(7))
	Set instr = ..Replace(instr, "\b", $c(8))       //Backspace
	Set instr = ..Replace(instr, "\t", $c(9))       //Tab 空白
	Set instr = ..Replace(instr, "\n", $c(10))      //换行
	Set instr = ..Replace(instr, "\u000b", $c(11))
	Set instr = ..Replace(instr, "\f", $c(12))      //换页 空白
	Set instr = ..Replace(instr, "\r", $c(13))      //回车
	Set instr = ..Replace(instr, "\u000e", $c(14))
	Set instr = ..Replace(instr, "\u000f", $c(15))
	Set instr = ..Replace(instr, "\u0010", $c(16))
	Set instr = ..Replace(instr, "\u0011", $c(17))
	Set instr = ..Replace(instr, "\u0012", $c(18))
	Set instr = ..Replace(instr, "\u0013", $c(19))
	Set instr = ..Replace(instr, "\u0014", $c(20))
	Set instr = ..Replace(instr, "\u0015", $c(21))
	Set instr = ..Replace(instr, "\u0016", $c(22))
	Set instr = ..Replace(instr, "\u0017", $c(23))
	Set instr = ..Replace(instr, "\u0018", $c(24))
	Set instr = ..Replace(instr, "\u0019", $c(25))
	Set instr = ..Replace(instr, "\u001a", $c(26))
	Set instr = ..Replace(instr, "\u001b", $c(27))
	Set instr = ..Replace(instr, "\u001c", $c(28))
	Set instr = ..Replace(instr, "\u001d", $c(29))
	Set instr = ..Replace(instr, "\u001e", $c(30))
	Set instr = ..Replace(instr, "\u001f", $c(31))
	Set instr = ..Replace(instr, "\\", "\")
	Set instr = ..Replace(instr, "\""", "")		// """"  直接转为空
	Quit instr
}

/// 给字符串替换
ClassMethod Replace(instr As %String, substr As %String, replacement As %String) As %String
{
	q:(substr="") instr
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

/// 返回流串
/// Input：Space:1:去除换行和空格、XMLFlag:1:是xml标识
ClassMethod GetStream(StreamStr, Space = "", XMLFlag = "") As %Stream.GlobalCharacter
{
	s newStream=##class(%Stream.GlobalCharacter).%New()	
	if $IsObject(StreamStr) {
		do StreamStr.Rewind()
		while 'StreamStr.AtEnd {
			s RtnStr = StreamStr.Read(20000)
			s HeadFlag = RtnStr["?xml version="
			if (Space=1)&&(HeadFlag'=1){
				s RtnStr=$replace(RtnStr,$c(9),"")
				s RtnStr=$replace(RtnStr,$c(10),"")
				s RtnStr=$replace(RtnStr,$c(13),"")
				;s RtnStr=$replace(RtnStr," ","")		;如果存在属性或值就含有空格，解析时不能去除属性空格
			}
			if (XMLFlag=1){
				s:HeadFlag=1 RtnStr=$zcvt(RtnStr,"O","UTF8")
			}
			d newStream.Write(RtnStr)
		}
		do StreamStr.Rewind()
	} else {
		s RtnStr=StreamStr
		s HeadFlag = RtnStr["?xml version="
		if (Space=1)&&(HeadFlag'=1){
			s RtnStr=$replace(RtnStr,$c(9),"")
			s RtnStr=$replace(RtnStr,$c(10),"")
			s RtnStr=$replace(RtnStr,$c(13),"")
			;s RtnStr=$replace(RtnStr," ","")
		}
		if (XMLFlag=1){
			s:HeadFlag=1 RtnStr=$zcvt(RtnStr,"O","UTF8")
		}
		d newStream.Write(RtnStr)
	}	
	q newStream
}

/// 给数组添加根节点和头信息
/// Input：Root:添加根节点名称、HeadFlag:xml头标识、Encoding:编码格式
ClassMethod XMLRoot(ArrData As DHCDoc.Util.ArrayData, Root As %String = "", HeadFlag As %String = "", Encoding As %String = "UTF-8") As %Stream.GlobalCharacter
{
	s Stream=##class(%Stream.GlobalCharacter).%New()
	i (Root'=""){
		s ArrayObj=##class(DHCDoc.Util.ArrayData).%New()
		d ArrayObj.SetAt(ArrData,Root)
		s ArrData=ArrayObj
	}
	s xml=..Arr2XML(ArrData)
	i HeadFlag=1{
		d Stream.Write("<?xml version=""1.0"" encoding="""_Encoding_"""?>")
	}
	d Stream.CopyFrom(xml)
	q Stream
}

/// 将Document.Object对象转为普通数组
/// 1.Simple(1/0):简洁/列表(Get模式)输出模式
/// 2.增加%isList(1/"")属性，解决不能确认子节点是列表节点还是对象节点问题
ClassMethod XMLDocument(DocObj, Simple = "1")
{
	set Obj=##class(DHCDoc.Util.ArrayData).%New()
	set key=""
	for {
		set pData=DocObj.GetNext(.key)
		quit:key=""
		if $IsObject(pData) {  
			if '(pData.%isList) {
				set value=..XMLDocument(pData,Simple)
				if Simple=1{
					do Obj.Set(key,value)
				}else{
					set ListObj=##class(DHCDoc.Util.ListData).%New()
					do ListObj.%Push(value)
					do Obj.Set(key,ListObj)
				}
			}elseif (pData.%isList) {
				set ListObj=##class(DHCDoc.Util.ListData).%New()
				set ListObj.%isList=1
				for n=1:1:pData.Count() {
					set tItem = pData.GetAt(n)
					;存在<a><b>1</b><b>2</b></a> 的情况
					if $IsObject(tItem){
						set value=..XMLDocument(tItem,Simple)
					}else{
						set value=tItem
					}
					do ListObj.%Push(value)
				}
				do Obj.Set(key,ListObj)
			}else {
				do Obj.Set(key,"")
			}
		}else{
			do Obj.Set(key,pData)
		}
	}
	quit Obj
}

/// %XML.TextReader迭代器(和XMLDocument方法保持相同的返回结构，解决低版本和高版本解析时的写法不一致问题)
/// Note: 方法思路：读取开始节点时，获取节点值，如果节点值为子节点，则递归获取子节点的值
/// Input: Reader:%XML.TextReader对象、MainNode:主节点数组(用于判断是否是列表)、PreDepth:上一节点的层级
/// Output: DHCDoc.Util.ArrayData对象
ClassMethod XMLGetIterator(Reader As %XML.TextReader, ByRef MainNode = "", ByRef PreDepth = "1") As DHCDoc.Util.ArrayData
{
	set Obj=##class(DHCDoc.Util.ArrayData).%New()		;返回对象
	while (Reader.Read()) {
		set Name = Reader.Name 						
		set Value = Reader.Value
		set Type = Reader.NodeType
		set Depth = Reader.Depth
		set Path = Reader.Path
		if Type="element" {
			;判断此节点是否存在子节点
			set HasSubNode=0
			do GetXMLNodeValue
			if (HasSubNode=1){
				set NodeValue=..XMLGetIterator(Reader,.MainNode,.PreDepth)
			}
			;判断当前节点和上一节点是否还属于同一层级，不属于则需清除节点列表
			if (Depth'=PreDepth){
				;PreDepth为结束节点的层级，比开始节点层级小1，所以需要加1
				set Level=(PreDepth+1)	
				for {
					set Level=$o(MainNode(Level))
					Quit:Level=""
					kill MainNode(Level)
				}
			}
			if $d(MainNode(Depth,Path)){
				;如果已存在改路径节点，则需改为列表节点(默认不是列表节点)
				set ListFlag=0
				set PreVal=Obj.Get(Name)			
				if $IsObject(PreVal) {  
					if $CLASSNAME(PreVal)="DHCDoc.Util.ListData" s ListFlag=1
				}
				;已存的节点数据类型是否是列表，不是则需把原来的数据改为列表存贮
				if (ListFlag=0){
					set ListObj=##class(DHCDoc.Util.ListData).%New()
					set ListObj.%isList=1
					do ListObj.Push(PreVal)
					do Obj.Set(Name,ListObj)
				}
				;此时的节点数据类型已是列表
				set CurrentVal=Obj.Get(Name)		
				do CurrentVal.Push(NodeValue)
			}else{
				;对象节点
				do Obj.Set(Name,NodeValue)
				s MainNode(Depth,Path)=1
			}
		} elseif Type="endelement" {
			;如果结束节点层级比上次小，则代表该返回此次对象
			if (Depth<(+PreDepth)) {
				set PreDepth=Depth
				Q ;因为cache2010不支持return写法
				;return Obj
			}
			set PreDepth=Depth
			set Obj=Value
			Q
			;return Value
		}else {
			;直接返回值，继续读取下一个数据
			;return Value
			set Obj=Value
			Q 
			
		}
	}
	Q Obj
	
GetXMLNodeValue
	set NodePath = Reader.Path
	do Reader.Read()		
	set NodeType = Reader.NodeType
	set NodeValue = Reader.Value
	set NodeName = Reader.Name
	if (NodeType="element"){
		;代表存在子节点，需移动读取指针到开始元素，返回原对象
		set HasSubNode=1
		set Reader.seq = Reader.seq-1
		set Reader.Depth = Reader.Depth-1
		set Reader.Path = NodePath			;因为Read会改变路径
	}elseif (NodeType="endelement"){
		;代表节点值为空
		set PreDepth=Reader.Depth
	}else{
		;代表存在元素值，需移动读取指针到结束元素
		do Reader.Read()
		set PreDepth=Reader.Depth
	}
	Quit
}

/// XML解析方法(简洁写法，和高版本的XMLDocument方法保持相同的返回结构)
ClassMethod XMLParse(xmlStream)
{
	set xmlStream=..GetStream(xmlStream,1,1)
	set sc = ##class(%XML.TextReader).ParseStream(xmlStream,.reader)
	if $$$ISERR(sc) Quit sc
	
	do reader.Read()	;先读取一下，过滤点根节点
	set Obj=..XMLGetIterator(reader,.NodeArr)
	Quit Obj
}

/****************** 封装XML、JSON、数组生成和解析接口 **********************************/
/// Json转为数组
/// w ##class(DHCDoc.Util.FromXML).Json2Arr()
ClassMethod Json2Arr(json) As DHCDoc.Util.ArrayData
{
	Set obj=##class(DHCDoc.Util.FromXML).%New()
	If obj'="" Do obj.%Close()
	Do obj.SetData(json)
	Quit obj.GetData()
}

/// Json转为对象(可直接调Json2Arr方法)
/// w ##class(DHCDoc.Util.FromXML).Json2Obj()
ClassMethod Json2Obj(json) As DHCDoc.Util.ArrayData
{
	q ..Json2Arr(json)
}

/// Json转为普通数组
/// w ##class(DHCDoc.Util.FromXML).FromJSONToArr()
ClassMethod FromJSONToArr(json, ByRef ParmArr)
{
	Set Arr=..Json2Arr(json)
	Set key=""
	For {
		Set value=Arr.GetNext(.key)
		Quit:key=""
		Set data=Arr.GetAt(key)
		if $IsObject(data){
			Kill SubArr
			Do ..FromJSONToArr(data,.SubArr)
			MERGE ParmArr(key)=SubArr
		} else {
			Set ParmArr(key)=data
		}
	}
	Quit ""
}

/// 数组转为Json流(增加了父节点写法)
/// w ##class(DHCDoc.Util.FromXML).Arr2Json()
ClassMethod Arr2Json(data As DHCDoc.Util.ArrayData, Type As %String = "") As %Stream.GlobalCharacter
{
	s jsonStream = ##class(%Stream.GlobalCharacter).%New()
	if $IsObject(data) {  
		s key=""
		s typeData=$CLASSNAME(data)	;data.%ClassName()  
		i (typeData="DHCDoc.Util.ArrayData") {			
			s key="",count=0
			s ParentNode=data.%xmlParentNode
			d:ParentNode'="" jsonStream.Write("{"""_..Escape(ParentNode)_""":")
			d jsonStream.Write("{")
			f {
				s Type=""
				s pData=data.GetNext(.key,.Type)
				q:key=""
				i Type="IGNORE" s node=$S(count'=0:",",1:"")
				e  s node=$S(count'=0:",",1:"")_""""_..Escape(key)_""":"
				s count=count+1
				d jsonStream.Write(node)				
				s value=..Arr2Json(pData,Type)
				d jsonStream.CopyFrom(value)
			} 
			d jsonStream.Write("}")
			d:ParentNode'="" jsonStream.Write("}")
			q jsonStream
		}elseif (typeData="DHCDoc.Util.ListData") {
			s cad=""
			s ParentNode=data.%xmlParentNode
			i (ParentNode'="") {
				d:(Type'="IGNORE") jsonStream.Write("[{")
				d jsonStream.Write(""""_..Escape(ParentNode)_""":")
			}
			d jsonStream.Write("[")
			f i=1:1:data.Count() {
				s symbol=$s(i>1:cad_",",1:"")
				d jsonStream.Write(symbol)
				s value=..Arr2Json(data.GetAt(i))
				d jsonStream.CopyFrom(value)
			}
			d jsonStream.Write("]")
			i (ParentNode'="")&&(Type'="IGNORE"){
				d jsonStream.Write("}]")
			}
			q jsonStream
		}elseif (typeData="%Stream.GlobalCharacter")||(typeData="%Stream.GlobalCharacter"){
			d jsonStream.Write("""")
			d jsonStream.CopyFrom(data)
			d jsonStream.Write("""")
			q jsonStream
		}
	}else{
		s val=""
		i Type'=""{
			;增加了动态写法中的类型转换
			i (Type="NULL")&&(data="") s val="null"
			e  i Type="BOOLEAN" s val=$select(data=0:"false",1:"true")
			e  i Type="NUMBER" s val=$select($ISVALIDNUM(data)=0:"",1:data)
			e  i Type="STRING" s val=""""_..Escape(data)_""""
			e  s val=data
		}elseif ($FIND(data,".")) {
			s:data="" val=""""""
			s val=""""_..Escape(data)_""""
		}elseif $ISVALIDNUM(data) {
			s val=""""_..Escape(data)_""""
		}else {
			s:data="" val=""""""
			s val=""""_..Escape(data)_""""
		}
		d jsonStream.Write(val)
		q jsonStream
	}
	q jsonStream
}

/// 数组转为XML流,支持属性和new节点
/// w ##class(DHCDoc.Util.FromXML).Arr2XML()
ClassMethod Arr2XML(data As DHCDoc.Util.ArrayData, node As %String = "", Type As %String = "") As %Stream.GlobalCharacter
{
	set XMLStream=##class(%Stream.GlobalCharacter).%New()
	if $IsObject(data) {  
		set typeData=$CLASSNAME(data)
		if (typeData="DHCDoc.Util.ArrayData") {	
			set ParentNode=data.%xmlParentNode
			if (ParentNode'="") {
				if (data.%xmlHasAttr){
					do XMLStream.Write("<"_ParentNode)
					set attrname=""
					for  set attrname=$o(data.%xmlAttrNode(ParentNode,attrname)) quit:attrname=""  do
					.set attrval=$g(data.%xmlAttrNode(ParentNode,attrname))
					.do XMLStream.Write(" "_attrname_"="""_attrval_"""")
					do XMLStream.Write(">")
				}else{
					do XMLStream.Write("<"_ParentNode_">")
				}
			}
			set (key,Type)=""
			for {
				set pData=data.GetNext(.key,.Type)
				quit:key=""
				do:Type'="IGNORE" XMLStream.Write("<"_key_">")
				;是否忽略节点名
				if (Type'="IGNORE"){
					set value=..Arr2XML(pData,key,Type)
				}else{
					set value=..Arr2XML(pData,"",Type)
				}
				do XMLStream.CopyFrom(value)
				do:Type'="IGNORE" XMLStream.Write("</"_key_">")
			} 
			do:ParentNode'="" XMLStream.Write("</"_ParentNode_">")
			quit XMLStream
		}elseif (typeData="DHCDoc.Util.ListData") {
			for Count=1:1:data.Count() {
				set ParentNode=data.%xmlParentNode	
				set:(ParentNode'="")&&(node'="") node=""	;如果有父节点，则把node节点置空			
				set tmp=..Arr2XML(data.GetAt(Count),"")
				if (node'="")&&(data.Count()>1) {
					if Count=1 {
						do XMLStream.CopyFrom(tmp)
						do XMLStream.Write("</"_node_">")
					}elseif(Count=data.Count()){
						do XMLStream.Write("<"_node_">")
						do XMLStream.CopyFrom(tmp)
					}else{
						do XMLStream.Write("<"_node_">")
						do XMLStream.CopyFrom(tmp)
						do XMLStream.Write("</"_node_">")
					}
				}else{
					do:ParentNode'="" XMLStream.Write("<"_ParentNode_">")
					do XMLStream.CopyFrom(tmp)
					do:ParentNode'="" XMLStream.Write("</"_ParentNode_">")						
				}
			}
			quit XMLStream
		}elseif (typeData="%Stream.GlobalCharacter")||(typeData="%Library.GlobalCharacterStream"){
	    	quit data
    	}
	}else {
		do XMLStream.Write(data)
		quit XMLStream
	}
	quit XMLStream
}

/// XML转为数组(不再需要传入根节点)
/// input：xmlStream：XML串/流
/// 	   Root:根节点名称(已无用，可不传)
/// 	   DemicFlag：是否使用动态解析(0/1)、
///        Simple：(1/0)单一父节点是否转为列表节点(针对动态解析有效)
/// output: 字符串/对象(失败/成功)
/// w ##class(DHCDoc.Util.FromXML).XML2Arr()
ClassMethod XML2Arr(xmlStream, Root = "", DemicFlag = "1", Simple = "1") As DHCDoc.Util.ArrayData
{
	s Arr=""
	try {
		if $d(^oddCOM("%Document.Object"))&&(DemicFlag=1) {
			s xmlStream=..GetStream(xmlStream,1,1)
			s Obj=##class(%Document.Object).%New()
			s XMLObj=Obj.XML(xmlStream)
			s Arr=..XMLDocument(XMLObj,Simple)
		}else{
			if (Simple'="1"){
				s JsonStream=..Xml2JsonOld(xmlStream)
				s Arr=..Json2Arr(JsonStream)
			}else{
				s Arr=..XMLParse(xmlStream)
			}
		}
	} catch(e) {
		Set tSC=e.AsStatus()	;e.DisplayString()
		set Arr=tSC
	}
	Q Arr
}

/// XML转为对象(可直接调XML2Arr方法)
/// w ##class(DHCDoc.Util.FromXML).XML2Obj()
ClassMethod XML2Obj(xmlStream, Root = "", DemicFlag = "1", Simple = "1") As DHCDoc.Util.ArrayData
{
	q ..XML2Arr(xmlStream,"",DemicFlag,Simple)
}

/// XML转Json流(Cache2016/Cache2010,支持包含标准xml头；ensemble2010,不支持有xml头信息)
/// <p> XML中节点是超长流串时，转json可能会超长，可采用Xml2JsonOld
/// <p> xmlStream：XML串或流、Root：根节点名称、DemicFlag：是否使用动态解析(0/1)
///     Simple：单一父节点不转为列表(针对Xml2JsonOld无效)
/// <p> w ##class(DHCDoc.Util.FromXML).Xml2Json()
ClassMethod Xml2Json(xmlStream, Root = "", DemicFlag = "1", Simple = "1") As %Stream.GlobalCharacter
{
	i $d(^oddCOM("%Document.Object"))&&(DemicFlag=1) {
		s XMLStream=..GetStream(xmlStream,"",1)
		s Obj=##class(%Document.Object).%New()
		s XMLObj=Obj.XML(XMLStream)		
		i Simple=1{
			d XMLObj.%ToJSONStream(.JsonStream)
			s JsonStream=..GetStream(JsonStream, 1)
		}else{
			;解决如果xml中list节点只有1层，则转为json时不是"[]"
			s Arr=..XMLDocument(XMLObj,Simple)
			s JsonStream=..Arr2Json(Arr)
		}
	}else{
		if (Simple'=1){
			s JsonStream=..Xml2JsonOld(xmlStream)
		}else{
			s Arr=..XMLParse(xmlStream)
			s JsonStream=..Arr2Json(Arr)
		}
	}
	q JsonStream
}

/// XML转Json流(Cache2010,支持包含xml头；ensemble2010,不支持有xml头信息)
/// Note:因为解析效率及取值写法不够简洁，推进使用XMLParse方法
/// w ##class(DHCDoc.Util.FromXML).Xml2JsonOld()
ClassMethod Xml2JsonOld(xmlStream, Root = "") As %Stream.GlobalCharacter
{
	s XMLStream=..GetStream(xmlStream,1,1)
	s JsonStream = ##class(%Stream.GlobalCharacter).%New()
	s sc=##class(%XML.XPATH.Document).CreateFromStream(XMLStream,.tDocument)
    i $$$ISERR(sc) {
	    d JsonStream.Write("{""Code"":""-1"",""Desc"":""解析失败""}")
		Quit JsonStream
	}else{
		;s Key="/"_Root
		;s tSC=tDocument.EvaluateExpression(Key,".",.pResults)	;根据输入xml路径节点查询
		s tSC=tDocument.EvaluateExpression("//*",".",.pResults)	;读取所有xml节点
		i $$$ISERR(tSC){
			d JsonStream.Write("{""Code"":""-1"",""Desc"":""解析失败""}")
			Quit JsonStream
		}
		d JsonStream.Write("{")
		s tResult=pResults.GetAt(1)
		i (tResult'="")&&(tResult.Type=$$$XPATHDOM){
			k MainNodeArr,LoopNodeArr
			s SeqNo=0
        	;1、先读取主节点，便于过滤节点 
        	While tResult.Read(){  
            	s Type=tResult.NodeType
            	s Path=tResult.Path
	            s SeqNo=SeqNo+1
	            continue:SeqNo=1			;过滤根节点
	            continue:(Type'="element") 	;过滤非元素节点
            	;s ParentPath=$p(Path,"\",1,*-2) 	;cache2010不支持该写法
            	;s ParentNode=$p(ParentPath,"\",*)
            	s Len=$l(Path,"\")
            	s ParentPath=$p(Path,"\",1,Len-2) 
            	s ParentNode=$p(ParentPath,"\",$l(ParentPath,"\"))
            	s Level=$l(ParentPath,"\")
            	continue:Level=1			;过滤父节点是根节点下的节点	
            	s MainNodeArr(ParentNode)=Level
        	}
	        ;2、重新在读取一遍数据
	        s (SeqNo,count,nodeSeq,valSeq,preLevel,arrSum)=0
	        d tResult.Rewind()	
            While tResult.Read(){  
            	s nodeType=tResult.NodeType
            	s nodePath=tResult.Path
            	s nodeName=tResult.Name  
            	s nodeValue=tResult.Value
	            s nodeLevel=$l(nodePath,"\")-2
	            s SeqNo=SeqNo+1
	            continue:SeqNo=1			;过滤根节点
            	
            	;规则：当元素序号和元素值序号不匹配:可能上一个元素值为空、可能进入下一层循环、可能返回上一层循环
            	;如果是主节点，则过滤
            	i $d(MainNodeArr(nodeName)){
	            	i (preLevel>nodeLevel){
		            	;删除高层级循环的主节点(表明一次列表结束)
		            	s node=""
		            	f {
			            	s node=$o(LoopNodeArr(node))
			            	q:node=""
			            	s Level=$g(LoopNodeArr(node))
			            	i Level>nodeLevel k LoopNodeArr(node)
			            }
		            }
	            	i ($d(LoopNodeArr(nodeName))){
		            	;过滤主节点
		            	i (valSeq'=nodeSeq) d JsonStream.Write("""""")	;上一个元素为空
		            	d JsonStream.Write("},{")
		            	s (nodeSeq,valSeq,count)=0		;当成根元素，重新计算
		            	continue
		            }else{
			            ;记录循环到的主节点
			        	s LoopNodeArr(nodeName)=nodeLevel
			        }
            	}
            	i (nodeType="element") {
			        i (valSeq'=nodeSeq){
				    	;相连的两个元素,重置序号
				    	s (nodeSeq,valSeq)=0
				    	i (nodeLevel>preLevel) {
					    	;下一层
					    	d JsonStream.Write("[{")
					    	s arrSum=arrSum+1
				    	}elseif(nodeLevel=preLevel){
					    	;同一层,且上一个元素没值
					    	d JsonStream.Write(""""",")
					    }else{
							;返回上一层,且上一个元素没值(可能返回上几层，需匹配输出结束符)
							;d JsonStream.Write("""""}],")
							;s arrSum=arrSum-1
							d JsonStream.Write("""""")
							f Loop=1:1:preLevel-nodeLevel{
				            		d JsonStream.Write("}]")
		        				s arrSum=arrSum-1
				            }
				            d JsonStream.Write(",")
						}
				    }elseif (count>0){
			        	i (nodeLevel'=preLevel){
			            	;不同层,结束列表(可能返回上几层，需匹配输出结束符)
			            	;d JsonStream.Write("}]")
			        		;s arrSum=arrSum-1
			            	f Loop=1:1:preLevel-nodeLevel{
				            	d JsonStream.Write("}]")
		        				s arrSum=arrSum-1
					        }
				    	}
					    d JsonStream.Write(",")
			        }	
		            d JsonStream.Write(""""_nodeName_""":")
		            ;元素序号
	            	s nodeSeq=nodeSeq+1
				}elseif(nodeType="chars"){
					i $IsObject(nodeValue) { 
						d JsonStream.CopyFrom(nodeValue)
					}else{
						;s nodeValue=$zcvt(nodeValue,"I","UTF8")
						d JsonStream.Write(""""_nodeValue_"""")
					}
					;元素值序号
					s valSeq=valSeq+1
				}
				;记录当前的层级，和下一个元素的层级比较	(2010的数据库,文本值没有路径)
				s:nodeLevel>0 preLevel=nodeLevel					
				s count=count+1	
            }
        	i (valSeq'=nodeSeq) {
	        	;最后一个元素没有值
	        	d JsonStream.Write("""""")
	        }
	        i arrSum>0{
		    	;匹配输出}]
		    	f i=1:1:arrSum{
			    	d JsonStream.Write("}]")
			    }
		    }
        }
		d JsonStream.Write("}")  
	}
	q JsonStream
}

/**************************************************** 用法、例子 Start *******************************************************/
/// 得到测试数组(定义：s Arr=##class(DHCDoc.Util.ArrayData).%New())
/// w ##class(DHCDoc.Util.FromXML).TestGet()
ClassMethod TestGet() As DHCDoc.Util.ArrayData
{
	s Code="First",Desc="第一层"
	s ArrayObj=##class(DHCDoc.Util.ArrayData).%New()
	d ArrayObj.SetAt(Code,"Code")
	d ArrayObj.SetAt(Desc,"Desc_Text")
	d ArrayObj.SetAt("测试","Data")
	;定义节点值为流的情况
	;s PhotoStream=##class(ext.util.String).Img2Base64("C:\Users\LX\Pictures\2.jpg") 
	s PhotoStream=##class(%Stream.GlobalCharacter).%New()
	d PhotoStream.Write("策划师")
	d ArrayObj.SetAt(PhotoStream,"Photo")
	s DataObj=##class(DHCDoc.Util.ListData).%New()
	f List=1:1:2 {
		s CodeList="Second:"_List,DescList="第二层:"_List
		s ArraySubObj=##class(DHCDoc.Util.ArrayData).%New()
		d ArraySubObj.SetAt(CodeList,"CodeS")
		d ArraySubObj.SetAt(DescList,"DescS")
		;三层节点
		s SubObj=##class(DHCDoc.Util.ListData).%New()
		f Sub=1:1:1 {
			s CodeSub="Third:"_Sub,DescSub="第三层:"_Sub
			s SubArr=##class(DHCDoc.Util.ArrayData).%New()
			d SubArr.SetAt(CodeSub,"CodeT")
			d SubArr.SetAt(DescSub,"DescT")
			d SubObj.Insert(SubArr)
		}
		d ArraySubObj.SetAt(SubObj,"DataT")
		d DataObj.Insert(ArraySubObj)
	}
	d ArrayObj.SetAt(DataObj,"DataS")
	s XMLArr=##class(DHCDoc.Util.ArrayData).%New()
	d XMLArr.SetAt(ArrayObj,"Request")
	q XMLArr
}

/// 测试数组、XML、Json互转
/// d ##class(DHCDoc.Util.FromXML).TestJsonXML()
ClassMethod TestJsonXML() As %String
{
	s ArrObj=..TestGet()
	
	w "数组转XML：" ,!
	s XMLStr=..Arr2XML(ArrObj)	
	w "		"_XMLStr.Read() ,!
		
	w "添加根节点和xml头：" ,!
	s XMLStr=..XMLRoot(ArrObj,"",1)
	w "  "_XMLStr.Read() ,!
	
	w "XML转数组：(ensemble2010,不支持有XML头信息) " ,!
	s Arr=..XML2Arr(XMLStr) 
	i $IsObject(Arr) { 
		w "	  Code："_Arr.Data("Code") ,!
		w "	  Desc_Text："_Arr.Data("Desc_Text") ,!
		;如果有乱码，需转换处理一下
		;w "	  Desc_Text："_$zcvt(Arr.Data("Desc_Text"),"I","UTF8") ,!
		i Arr.IsDefined("Photo") d
		.w "      Photo："_Arr."Photo" ,!
		w "	  DataSSum："_Arr."DataS".Count() ,!
		w "	  DataS.Code："_Arr."DataS".%Get(1)."CodeS" ,!
	}else{
		w "解析失败："_Arr
		q ""
	}
	
	w "数组转Json：" ,!
	s JsonStr=..Arr2Json(ArrObj)
	w "		"_JsonStr.Read() ,!
	
	w "Json转数组：" ,!
	s Arr=..Json2Arr(JsonStr)
	w "	Code："_Arr.Data("Request").Data("Code") ,!
	w "	DataSSum："_Arr.Data("Request").Data("DataS").Count() ,!
	w "	DataS.Code："_Arr.Data("Request").Data("DataS").GetAt(1).Data("CodeS") ,!	
	
	w "Json转普通数组：" ,!
	s ParmArr("Test")="测试"
	d ..FromJSONToArr(JsonStr,.ParmArr)
	w " Test："_ParmArr("Test") ,!
	w " Code："_$g(ParmArr("Request","Code")) ,!
	w " DataS.Code："_$g(ParmArr("Request","DataS",1,"CodeS")) ,!
	
	w "XML转Json：",!
	s JsonStr=..Xml2Json(XMLStr)
	w "		"_JsonStr.Read() ,!
	
	;Xml2JsonOld可能不符合要求，需要重新再构建生成json
	s XML="<Request><list><deptInfos><deptCode></deptCode><deptDesc></deptDesc><deptName></deptName><hosOrgCode></hosOrgCode><indexNo></indexNo><isDelete></isDelete><isRegister></isRegister><normdeptCode></normdeptCode><normdeptName></normdeptName></deptInfos><deptInfos><deptCode></deptCode><deptDesc></deptDesc><deptName></deptName><hosOrgCode></hosOrgCode><indexNo></indexNo><isDelete></isDelete><isRegister></isRegister><normdeptCode></normdeptCode><normdeptName></normdeptName></deptInfos><deptInfos><deptCode>12345</deptCode><deptDesc></deptDesc><deptName></deptName><hosOrgCode></hosOrgCode><indexNo></indexNo><isDelete></isDelete><isRegister></isRegister><normdeptCode></normdeptCode><normdeptName></normdeptName></deptInfos><deptInfos><deptCode></deptCode><deptDesc></deptDesc><deptName></deptName><hosOrgCode></hosOrgCode><indexNo></indexNo><isDelete></isDelete><isRegister></isRegister><normdeptCode></normdeptCode><normdeptName></normdeptName></deptInfos></list><messageHeader><accessAccount></accessAccount><sign></sign></messageHeader></Request>"
	w "XML转Json转换前：",!
	s JsonStr=..Xml2JsonOld(XML)
	w "		"_JsonStr.Read() ,!
	
	s Arr=..Json2Arr(JsonStr)
	s Arr1=##class(DHCDoc.Util.ArrayData).%New()
	d Arr1.SetAt(Arr.Data("list").Get(1).Data("deptInfos"),"list")
	d Arr1.SetAt(Arr.Data("messageHeader").Get(1),"messageHeader")
	s JsonNew=..Arr2Json(Arr1)
	w "XML转Json转换后：",!
	w "		"_JsonNew.Read() ,!

	q ""
}

/// 动态写法测试(s Arr=##Class(DHCDoc.Util.ArrayData).%New())
/// 新增数据类型和链式写法
/// 注意：1.因为数组具有自动排序功能，所以%GetNext时的key是排序后的key,取值最好通过key值来获取
/// </p>2.因为数组中的列表是从1开始的，动态列表是从0开始的，所以高版本中%Get()中的序号需要增加1
/// </p>3.因为Data是数组中的关键字，要是Json串或xml串中有Data节点时，获取数据时不能直接用"."获取，需用其他方式获取
/// d ##Class(DHCDoc.Util.FromXML).TestDemic()
ClassMethod TestDemic() As %String
{
	w "链式写法(带字符类型)：" ,!
	s obj=##Class(DHCDoc.Util.ArrayData).%New()
	d obj.%Set("a","","null").%Set("b","1","boolean").%Set("c","3","number").%Set("d",4,"string").%Set("e","test_json")
	s Json=obj.%ToJSON().Read()
	w "	"_Json ,!
	
	w "JsonObj: " ,!
	s Arr=##Class(DHCDoc.Util.ArrayData).%New()
	s JsonObj=Arr.%FromJSON(Json)
	s key=""
	f {
		s value=JsonObj.%GetNext(.key)
		q:key=""
		w "	"_key_": "_value ,!
	}
	
	;支持动态写法和静态写法
	s Obj=##Class(DHCDoc.Util.ArrayData).%New()
	s Obj.a=1
	d Obj.SetAt(2,"b_b")
	d Obj.%Set("c",3)
	s SubObj=##Class(DHCDoc.Util.ListData).%New()
	f Sub=1:1:2 {
		s CodeSub="Third:"_Sub,DescSub="第三层:"_Sub
		s SubArr=##Class(DHCDoc.Util.ArrayData).%New()
		d SubArr.SetAt(CodeSub,"CodeT")
		d SubArr.SetAt(DescSub,"DescT")
		;d SubObj.Insert(SubArr)
		d SubObj.Push(SubArr)
	}
	d Obj.SetAt(SubObj,"DataT")
	
	;"json转换和解析"  
	s Json=Obj.%ToJSON()
	w "Json：	",!
	w "	"_Json.Read() ,!
	
	;%Get()需注意是从1开始
	s Arr=##Class(DHCDoc.Util.ArrayData).%New()
	s JsonObj=Arr.%FromJSON(Json)
	w "JsonObj：	",!
	w "	JsonObj.b_b="_JsonObj."b_b" ,!
	f len=1:1:JsonObj.DataT.%Size() d
	.w "	JsonObj.DataT("_len_").CodeT="_JsonObj.Data("DataT").Data(len).Data("CodeT")
	.w "、JsonObj.DataT("_len_").DescT="_JsonObj."DataT".%Get(len)."DescT" ,!
	
	;"xml转换和解析"
	s MainObj=##Class(DHCDoc.Util.ArrayData).%New()
	s MainObj.Request=Obj
	s xml=##Class(DHCDoc.Util.FromXML).Arr2XML(MainObj)
	w "XML：	",!
	w "	"_xml.Read() ,!
	
	d xml.Rewind()
	s xmlobj=##Class(DHCDoc.Util.FromXML).XML2Arr(xml)
	w "XMLObj: 		",!
	w "	XMLObj.b_b:"_xmlobj."b_b" ,!
	f len=1:1:xmlobj."DataT".Count() d
	.w "	XMLObj.DataT("_len_").CodeT:"_xmlobj."DataT".Data(len)."CodeT" ,!
	
	q ""
}

/// 最新简洁写法+XML属性测试(推荐方式一)
/// d ##Class(DHCDoc.Util.FromXML).TestXMLAttr()
ClassMethod TestXMLAttr() As %String
{
	;方式一:
	s Obj=##class(DHCDoc.Util.ArrayData).%New("Request")
	s sub=##class(DHCDoc.Util.ListData).%New("List")
	f i=1:1:2 {	
		s attr=##class(DHCDoc.Util.ArrayData).%New("Attr")
		s attr."AttrA"="A"_i
		s attr."parm"="列表"_i
		d attr.SetAttr("a","属性"_i)
		d attr.SetAttr("b","属性b"_i)
		d attr.SetAt(i,"Attr","Ignore")
		d sub.%Push(attr)
	}
	s Obj.Lists=sub
	s xml=Obj.%ToXML()
	w "方式一:"_xml.Read() ,!
	
	;方式二：
	s Obj=##class(DHCDoc.Util.ArrayData).%New("Request")
	s sub=##class(DHCDoc.Util.ListData).%New()
	f i=1:1:2 {	
		s attr=##class(DHCDoc.Util.ArrayData).%New("Attr")
		s attr."AttrA"="A"_i
		s attr."parm"="列表"_i
		d attr.SetAttr("a","属性"_i)
		d attr.SetAttr("b","属性b"_i)
		d attr.SetAt(i,"Attr","Ignore")
		d sub.%Push(attr)
	}
	s Obj.Lists=##class(DHCDoc.Util.ArrayData).%New()
	s Obj.Lists."List"=sub
	s xml=Obj.%ToXML()
	w "方式二:"_xml.Read() ,!
	
	;方式三:
	s Obj=##class(DHCDoc.Util.ArrayData).%New("Request")
	s sub=##class(DHCDoc.Util.ListData).%New()
	f i=1:1:2 {	
		s sub1=##class(DHCDoc.Util.ArrayData).%New()
		s attr=##class(DHCDoc.Util.ArrayData).%New("Attr")
		s attr."AttrA"="A"_i
		s attr."parm"="列表"_i
		d attr.SetAttr("a","属性"_i)
		d attr.SetAttr("b","属性b"_i)
		d attr.SetAt(i,"Attr","Ignore")
		s sub1."List"=attr
		d sub.%Push(sub1)
	}	
	s Obj1=##class(DHCDoc.Util.ArrayData).%New("Lists")
	d Obj1.SetAt(sub,"Lists","Ignore")
	d Obj.SetAt(Obj1,"Lists","Ignore")
	s xml=Obj.%ToXML()
	w "方式三:"_xml.Read() ,!

	q ""
}

/// 最新简洁写法：Json
/// d ##Class(DHCDoc.Util.FromXML).GetJsonNew()
ClassMethod GetJsonNew()
{
 	s Obj=##class(DHCDoc.Util.ArrayData).%New("request")
	s diagL=##class(DHCDoc.Util.ListData).%New()
	f i=1:1:2 {
		s diag=##class(DHCDoc.Util.ArrayData).%New()
		s diag."icdName"="上呼吸道感染"
		d diagL.%Push(diag)
	}
	s Obj."diagnosis"=##class(DHCDoc.Util.ArrayData).%New()
	s Obj."diagnosis"."diag"=diagL
	
	s drugL=##class(DHCDoc.Util.ListData).%New("drug")
	f i=1:1:2 {
		s drug=##class(DHCDoc.Util.ArrayData).%New()
		s drug."drugChemName"="沙格列汀片"
		d drugL.%Push(drug)
	}
	s Obj."drugs"=drugL
	s Obj."flag"=1
	s Json=..Arr2Json(Obj)
	w Json.Read() ,!
	q ""
}

/// d ##Class(DHCDoc.Util.FromXML).Test()
ClassMethod Test()
{
	;s XML="<Root><a1>1</a1><a1>2</a1><code>0</code></Root>"
	;s XML="<Root><a><a1>1</a1><a1>2</a1><a2>3</a2></a><code>0</code></Root>"
	s XML="<Root><Input1></Input1><Input2>Val2</Input2><data1><Lists><InputS1>ValS1</InputS1><InputS2>ValS2</InputS2></Lists></data1><data2><Lists><InputS1>ValS1</InputS1></Lists><Lists><InputS2>ValS2</InputS2></Lists></data2></Root>"
	;s XML="<Request><list><deptInfos><deptCode></deptCode><deptDesc>内分泌</deptDesc><deptName></deptName></deptInfos><deptInfos><deptCode></deptCode><deptDesc>呼吸一科</deptDesc><deptName></deptName></deptInfos><deptInfos><deptCode>YK001</deptCode><deptDesc></deptDesc><deptName></deptName></deptInfos></list><messageHeader><accessAccount></accessAccount><sign></sign></messageHeader><Code>0</Code><Desc>成功</Desc></Request>"
	;s XML="<Request><list><deptInfos><deptCode></deptCode><deptDesc></deptDesc><deptName></deptName></deptInfos><deptInfos><deptCode></deptCode><deptDesc></deptDesc><deptName></deptName></deptInfos><deptInfos><deptCode>YK001</deptCode><deptDesc></deptDesc><deptName></deptName></deptInfos></list><messageHeader><accessAccount></accessAccount><sign></sign></messageHeader><Code></Code><Desc></Desc></Request>"
	;s XML="<Req><TransactionCode></TransactionCode><Data><StartTime></StartTime><EndTime></EndTime><DeptCode></DeptCode><CardNo></CardNo><CardType></CardType><HisRegId>16889641</HisRegId></Data></Req>"
	;s XML="<Root><a><a1>1</a1><a2/><a1>2</a1></a><code>0</code><Desc/></Root>"
	s Obj=##class(DHCDoc.Util.FromXML).XML2Arr(XML,,0)
	b ;1
	Q 1
}

}
