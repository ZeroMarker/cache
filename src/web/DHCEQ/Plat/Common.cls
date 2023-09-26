Include (%callout, %occSAX, %occXSLT, %syNLS)

/// add by czf 2020-11-23
/// 数组、流、Json串之间相互转换
Class web.DHCEQ.Plat.Common Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter JSonSlice [ Final, Internal ] = 1;

Parameter JSonInString [ Final, Internal ] = 2;

Parameter JSonInArray [ Final, Internal ] = 3;

Parameter JSonInObject [ Final, Internal ] = 4;

Parameter EscapeChar As COSEXPRESSION = "$LB($LB(""\"",""\\""),$LB($C(13),""\n""),$LB($C(10),""\r""),$LB($C(9),""\t""),$LB("""""""",""\""""""),$LB($C(8),""\b""),$LB($C(12),""\f""))";

Parameter UnEscapeChar As COSEXPRESSION = "$LB(""\\"",""\n"",""\r"",""\t"",""\"""""",""\b"",""\f"")";

/// 给Json字符串转码 
ClassMethod Escape(str As %String) As %String [ Internal ]
{
	for tI=1:1:$LL(..#EscapeChar) { 
		Set tCharPair=$LG(..#EscapeChar,tI)
		Set str=$Replace(str,$LG(tCharPair,1),$LG(tCharPair,2))
	}
	Quit str
}

/// 给Json字符串解码 
ClassMethod Unescape(str As %String) As %String [ Internal ]
{
  for tI=1:1:$Length(str){
    set tChar=$ListFind(..#UnEscapeChar,$E(str,tI,tI+1))
    if (tChar>0){
      set $E(str,tI,tI+1)=$LG($LG(..#EscapeChar,tChar),1)
    }
  }
  quit str
}

ClassMethod SetAux(what As %String, where As %Integer, delim As %String) As %DataType [ Internal ]
{
	set aux=##class(%ArrayOfDataTypes).%New() 
	do aux.SetAt(what,"what")
	do aux.SetAt(where,"where") 
	do aux.SetAt(delim,"delim")
	quit aux
}

/// 返回流串
ClassMethod GetStream(StreamStr) As %Stream.GlobalCharacter
{
	set newStream = ##class(%Stream.GlobalCharacter).%New()
	if $IsObject(StreamStr) {
		s newStream = StreamStr
	} else {
		d newStream.Write(StreamStr)
	}
	q newStream
}

/// 去除Json中的重复节点
/// NodeList："、"串接
ClassMethod CutJsonNode(JsonStr, NodeList) As %GlobalCharacterStream
{
	s newStream = ##class(%Stream.GlobalCharacter).%New()
	s jsonStream=..GetStream(JsonStr)
	do jsonStream.Rewind()
	while 'jsonStream.AtEnd {
		s jsonStr = jsonStream.Read(10000)
		f len=1:1:$l(NodeList,"、"){
			s nodeName=$p(NodeList,"、",len)
			continue:nodeName=""
			s hidenode="],"""_nodeName_""":["
			s jsonStr=$replace(jsonStr,hidenode,",")
		}
		do newStream.Write(jsonStr)
	}
	quit newStream
}

/// 给数组的数据添加根节点
ClassMethod XMLRoot(ArrData As %ArrayOfDataTypes, Root As %String = "", encoding = "utf-8") As %GlobalCharacterStream
{
	s Stream=##class(%GlobalCharacterStream).%New()
	i (Root'=""){
		s ArrayObj=##class(%ArrayOfDataTypes).%New()
		d ArrayObj.SetAt(ArrData,Root)
	}
	s xml=..Arr2XML(ArrayObj)
	d Stream.Write("<?xml version=""1.0"" encoding="_$c(34)_encoding_$c(34)_"?>")
	d Stream.CopyFrom(xml)
	q Stream
}

/// 去除XML的头(<?xml version="1.0" encoding="UTF-8"?>), 返回流
/// w ##class(DHCDoc.Util.XML).CutXmlHeadNew("<?xml version=""1.0"" encoding=""utf-8""?><Data><a>asd</a><b>中文</b></Data>")
ClassMethod CutXmlHead(xmlStr) As %Stream.GlobalCharacter
{
	set newStream = ##class(%Stream.GlobalCharacter).%New()
	set xmlStream=..GetStream(xmlStr)
	set xmlStreamSize = xmlStream.SizeGet()
	do xmlStream.Rewind()
	set cnt = 0
	while 'xmlStream.AtEnd {
		set char = xmlStream.Read(1)
		continue:char=""
		continue:char=" "
		set cnt = cnt + 1
		set charArr(cnt) = char
		continue:cnt=1
		if (cnt > 50) {
			do xmlStream.Rewind()
			do newStream.Write(xmlStream.Read())
		}
		if (charArr(cnt-1)="?")&&(charArr(cnt)=">") {
			do newStream.Write(xmlStream.Read(xmlStreamSize - cnt))
		}
	}
	quit newStream
}

/// 数组转为XML流
ClassMethod Arr2XML(data As %ArrayOfDataTypes, node As %String = "") As %GlobalCharacterStream
{
	if $IsObject(data) {  
		set key=""
		set typeData=data.%ClassName()
		if typeData="%ArrayOfDataTypes" {
			//type object
			set key=""
			set XMLStream=##class(%GlobalCharacterStream).%New()
			set cad=""
			for {
				set pData=data.GetNext(.key)
				quit:key=""
				set value=..Arr2XML(pData,key)
				if $IsObject(value){
					do XMLStream.Write("<"_key_">")
					do XMLStream.CopyFrom(value)
					do XMLStream.Write("</"_key_">")
				}else{
					do XMLStream.Write("<"_key_">"_value_"</"_key_">")
				}
			} 
			quit XMLStream
		}elseif typeData="%ListOfDataTypes" {
			//type array 
			set XMLStream=##class(%GlobalCharacterStream).%New()
			set cad=""
			for Count=1:1:data.Count() {
				set tmp=..Arr2XML(data.GetAt(Count))
				if $IsObject(tmp){
					if (node'="")&&(data.Count()>1) {
						if Count#2=0 {
							do XMLStream.Write("<"_node_">")
							do XMLStream.CopyFrom(tmp)
						}
						if Count#2=1 {
							do XMLStream.CopyFrom(tmp)
							do XMLStream.Write("</"_node_">")
						}
					}else{
						do XMLStream.CopyFrom(tmp)
					}
				}else{
					do XMLStream.Write(tmp)
				}
			}
			quit XMLStream
    	}elseif typeData="GlobalCharacter" {
	    	quit data
    	}
	}else {
		quit data
	}
}

/// XML转Json流
/// Root：根节点、HiddenNodeStr：需要隐藏的重复节点(、串接)、HiddenFlag：默认隐藏重复节点和根节点
ClassMethod Xml2Json(xmlStream, Root, HiddenNodeStr = "", HiddenFlag As %String = "Y") As %GlobalCharacterStream
{
	s JsonStr=""
	s JsonStream = ##class(%Stream.GlobalCharacter).%New()
	s XMLStream = ##class(%Stream.GlobalCharacter).%New()
	s xmlStream=..GetStream(xmlStream)
	d xmlStream.Rewind()
	while 'xmlStream.AtEnd{
		d XMLStream.Write($zcvt(xmlStream.Read(),"O","UTF8"))
	}
	s sc=##class(%XML.XPATH.Document).CreateFromStream(XMLStream,.tDocument)
    i $$$ISERR(sc) {
		quit sc
	}else{
		s Key="/"_Root
		s tSC=tDocument.EvaluateExpression(Key,".",.pResults)
		i ($$$ISOK(tSC)&&(pResults.GetAt(1)'="")){
			f tI=1:1:pResults.Count(){
		        s tResult=pResults.GetAt(tI)
		        i (tResult.Type=$$$XPATHDOM){   
		        	s (count,nodeseq,valseq,predepth)=0
		        	;s JsonStr=JsonStr_"{"
		        	d JsonStream.Write("{")
		            While tResult.Read(){  
		            	s nodeType=tResult.NodeType
		            	s nodePath=tResult.Path
		            	s nodeName=tResult.Name  
		            	s nodeValue=tResult.Value
			            s cudepth=$l(nodePath,"\")
		            	;判断是否隐藏跟节点
		            	i (HiddenFlag="Y")&&(nodeName=Root) continue
		            	i (HiddenNodeStr[nodeName)&&(nodeName=Root) continue
		            	i (nodeType="element") {
					        i (valseq'=nodeseq) {
						        ;相连的两个元素，重置序号
						        s (nodeseq,valseq)=0
						        ;i nodeName=Root s JsonStr=JsonStr_"{"
				            	;e  s JsonStr=JsonStr_"[{"
				            	i nodeName=Root  d JsonStream.Write("{")
				            	e  d JsonStream.Write("[{")
				            }
				            elseif (cudepth'=predepth)&&(count>0){
					            ;不是同一层的元素(进入了一下次循环，结束列表)
					        	;s JsonStr=JsonStr_ "}],"
					        	d JsonStream.Write("}],")
					        }
					        elseif count>0 {
						        ;不是第一个元素
					            ;s JsonStr=JsonStr_ ","   
					            d JsonStream.Write(",")
				            }
				            ;s JsonStr=JsonStr_""""_nodeName_""":"
				            d JsonStream.Write(""""_nodeName_""":")
				            s nodeseq=nodeseq+1
						}elseif(nodeType="chars"){
							;s JsonStr=JsonStr_ """"_nodeValue_""""
							i $IsObject(nodeValue) { 
								s DocumentContent=""
								d nodeValue.Rewind()
								while (nodeValue.AtEnd=0){
									s DocumentContent=DocumentContent_nodeValue.Read(10000)
								}
							}
							d JsonStream.Write(""""_nodeValue_"""")
	            			s valseq=valseq+1
						}
						;记录当前的层级，和下一个元素的层级比较	
						s predepth=$l(nodePath,"\") 
						;记录最深层级路径
						s mapdepth(predepth,nodePath)=nodePath
						s count=count+1	
		            }
	        	}
		        ;i (count>0)&&(HiddenNodeStr'[Root) s JsonStr=JsonStr_ "}"
	            ;s JsonStr=JsonStr_ "}"
	            i (count>0)&&(HiddenNodeStr'[Root) d JsonStream.Write("}")
	            d JsonStream.Write("}")
	            ;隐藏重复节点
	        	s HiddenNode=""
	        	i (HiddenFlag="Y")&&($d(mapdepth)){
		        	s maxdepth=$o(mapdepth(""),-1)
		        	i maxdepth>2{ 
		        		s maxpath="" 
		        		f {
			        		s maxpath=$o(mapdepth(maxdepth,maxpath))
			        		q:maxpath=""
			        		s Hidepath=$replace($e(maxpath,2,maxdepth-2),"\","、")
		        			i HiddenNode'="" s HiddenNode=HiddenNode_"、"_Hidepath
		        			e  s HiddenNode=Hidepath
		        		}
		        	}
		        }elseif(HiddenNodeStr'=""){
			        s HiddenNode=HiddenNodeStr
		        }
		        ;s JsonStr=..CutJsonNode(JsonStr,HiddenNode)
		        s JsonStream=..CutJsonNode(JsonStream,HiddenNode)
	        }
		}
	}
	;q JsonStr
	q JsonStream
}

/// 数组转为Json串
/// 单层转换
/// w ##class(web.DHCEQ.Plat.Common).Arr2JsonStr()
ClassMethod Arr2JsonStr(data As %DataType) As %String
{
	if $IsObject(data) {  
		set key=""
		set typeData=data.%ClassName()
		if typeData="%ArrayOfDataTypes" {
			//type object
			set key=""
			set cad=""
			for {
				set pData=data.GetNext(.key)
				quit:key=""
				set value=..Arr2Json(pData)
				set cad=$S(cad'="":cad_",",1:"")_""""_..Escape(key)_""":"_value  
			} 
			quit "{"_cad_"}"
		}elseif typeData="%ListOfDataTypes" {
			//type array 
			set cad=""
			for i=1:1:data.Count() {
				set tmp=..Arr2Json(data.GetAt(i))
				set cad=$S(i>1:cad_",",1:"")_tmp
			}
			set cad="["_cad_"]"
			quit cad
		}elseif typeData="GlobalCharacter"{			
			s DocumentContent=""
			d data.Rewind()
			while (data.AtEnd=0){
				s DocumentContent=DocumentContent_data.Read(10000)
			}
			q DocumentContent
		}
	}elseif ($FIND(data,".")) {
		//type string
		quit:data="" """"""
		quit """"_..Escape(data)_""""
	}elseif $ISVALIDNUM(data) {
		// type number
		//quit data	防止01转为1，改为下面
		quit """"_..Escape(data)_""""
	}else {
		//type string
		q:data="" """"""
		quit """"_..Escape(data)_""""
	}
	q ""
}

/// 数组转为Json流
/// w ##class(web.DHCEQ.Plat.Common).Arr2Json()
ClassMethod Arr2Json(data As %DataType) As %GlobalCharacterStream
{
	s jsonStream = ##class(%Stream.GlobalCharacter).%New()
	if $IsObject(data) {  
		s key=""
		s typeData=data.%ClassName()
		i typeData="%ArrayOfDataTypes" {
			s key=""
			s count=0
			d jsonStream.Write("{")
			f {
				s pData=data.GetNext(.key)
				q:key=""
				s value=..Arr2Json(pData)
				s node=$S(count'=0:",",1:"")_""""_..Escape(key)_""":"
				s count=count+1
				d jsonStream.Write(node)
				i $IsObject(value){
					d jsonStream.CopyFrom(value)
				}else{
					d jsonStream.Write(value)
				}
			} 
			d jsonStream.Write("}")
			q jsonStream
		}elseif typeData="%ListOfDataTypes" {
			s cad=""
			d jsonStream.Write("[")
			f i=1:1:data.Count() {
				s tmp=..Arr2Json(data.GetAt(i))
				s symbol=$S(i>1:cad_",",1:"")
				d jsonStream.Write(symbol)
				i $IsObject(tmp){
					d jsonStream.CopyFrom(tmp)	
				}else{
					d jsonStream.Write(tmp)
				}
			}
			d jsonStream.Write("]")
			q jsonStream
		}elseif typeData="GlobalCharacter"{
			d jsonStream.Write("""")
			d jsonStream.CopyFrom(data)
			d jsonStream.Write("""")
			q jsonStream
		}
	}elseif ($FIND(data,".")) {
		q:data="" """"""
		q """"_..Escape(data)_""""
	}elseif $ISVALIDNUM(data) {
		q """"_..Escape(data)_""""
	}else {
		q:data="" """"""
		q """"_..Escape(data)_""""
	}
	q jsonStream
}

/// Json转为数组
/// w ##class(web.DHCEQ.Plat.Common).Json2Arr("[{""DiskName"":""c:"",""DiskTotalSpace"":""50.01""},{""DiskName"":""e:"",""DiskTotalSpace"":""100.01""}]")
/// "{""school"":{""title"":""national middle school"",""place"":""XiChangRoad""},""teacher"":{[{""name"":""sara"",""age"":""25""},{""name"":""journey"",""age"":""23""}]}}"
ClassMethod Json2Arr(jsonStr) As %ArrayOfDataTypes
{
	s jsonStream=..GetStream(jsonStr)
	s str=""
	d jsonStream.Rewind()
	while (jsonStream.AtEnd=0){
		s str=str_jsonStream.Read(10000)
	}
	#dim stack As %ListOfDataTypes
	set matchType=$ZCVT(str,"L")
	quit:(matchType="true") "1"
	quit:(matchType="false") "0"
	quit:(matchType="null") ""  
	quit:($ISVALIDNUM(matchType)) matchType 
	quit:str?1"""".E1"""" ..Unescape($e(str,2,$l(str)-1))

	set match=str?1(1"[".E1"]",1"{".E1"}")
	set stack=##class(%ListOfDataTypes).%New()

	if match {
		if $E(str,1)="[" {
			do stack.Insert(..#JSonInArray)
			set arr=##class(%ListOfDataTypes).%New()
		}else {
			d stack.Insert(..#JSonInObject) 
			set obj=##class(%ArrayOfDataTypes).%New()
		}

		do stack.Insert(..SetAux(..#JSonSlice,1,"false"))
		set chars=$E(str,2,$L(str)-1)
		if chars="" {
			if stack.GetAt(1)=..#JSonInArray {
				quit arr
			}else {
				quit obj
			}  
		}
		set strlenChars=$L(chars)+1
		set escaped=0
		For c=1:1:strlenChars {
			set last=stack.Count()
			set top=stack.GetAt(last)
			set:(escaped=2) escaped=0
			set:(escaped=1) escaped=2
			set substrC2=$E(chars,c-1,c)
			if ($E(chars,c,c)="\")&&(escaped=0){
				set escaped=1
			}
			if $e(chars,c)="" {
				set a=22
			}

			if (c=strlenChars || ($E(chars,c)=",")) && (top.GetAt("what")=..#JSonSlice) {
				// found a comma that iset not inside a string, array, etc.,
				// OR we've reached the end of the character list
				
				set slice = $E(chars, top.GetAt("where"),c-1)
				do stack.Insert(..SetAux(..#JSonSlice,c+1,"false"))
				if stack.GetAt(1)=..#JSonInArray {
					// we are in an array, so just push an element onto the stack
					d arr.Insert(..Json2Arr(slice)) 
				}elseif stack.GetAt(1)=..#JSonInObject {
					// we are in an object, so figure
					// out the property name and set an
					// element in an associative array,
					// for now 
					   
					set match=slice?." "1""""1.E1""""." "1":"1.E
					if match {
						//'name':value par
						set key1=$p(slice,":")
						set key=..Json2Arr(key1)
						set val=..Json2Arr($P(slice,":",2,$l(slice,":"))) 
						do obj.SetAt(val, key)
					}
				}
			}elseif $E(chars,c)="""" && (top.GetAt("what")'=..#JSonInString) {
				// found a quote, and we are not inside a string
				d stack.Insert(..SetAux(..#JSonInString,c,$E(chars,c)))
			}elseif $E(chars,c)=top.GetAt("delim") && (top.GetAt("what")=..#JSonInString) && (escaped=0) {
				// found a quote, we're in a string, and it'set not escaped (look 3 charachterset behind, to see the \" iset not \\" )
				set last=stack.Count()
				set st=stack.RemoveAt(last)
			}elseif ($E(chars,c)="[") && (top.GetAt("what")'=..#JSonInString) && ($CASE(top.GetAt("what"),..#JSonInString:1,..#JSonInArray:1,..#JSonSlice:1,:0)) { 
				// found a left-bracket, and we are in an array, object, or slice
				d stack.Insert(..SetAux(..#JSonInArray,c,"false"))
			}
			elseif $E(chars,c)="]" && (top.GetAt("what")=..#JSonInArray) {
				// found a right-bracket, and we're in an array
				set last=stack.Count()
				set st=stack.RemoveAt(last) 
			}elseif $E(chars,c)="{" && ($CASE(top.GetAt("what"),..#JSonSlice:1,..#JSonInArray:1,..#JSonInObject:1,:0)) {
				// found a left-brace, and we are in an array, object, or slice
				do stack.Insert(..SetAux(..#JSonInObject,c,"false"))
			}elseif $E(chars,c)="}" && (top.GetAt("what")=..#JSonInObject) {
				// found a right-brace, and we're in an object 
				set last=stack.Count()
				set st=stack.RemoveAt(last) 
			}
		}  
		if stack.GetAt(1)=..#JSonInObject {
			q obj
		}elseif stack.GetAt(1)=..#JSonInArray {
			q arr
		}
	}
	q str
}

/// 测试数组、XML、Json互转
/// w ##class(DHCDoc.Util.XML).Test()
ClassMethod Test() As %String
{
	s Code="First",Desc="第一层"
	s ArrayObj=##class(%ArrayOfDataTypes).%New()
	d ArrayObj.SetAt(Code,"Code")
	d ArrayObj.SetAt(Desc,"Desc_Text")
	s PhotoStream=##class(ext.util.String).Img2Base64("C:\Users\LX\Pictures\2.jpg") 
	d ArrayObj.SetAt(PhotoStream,"Photo")
	s DataObj=##class(%ListOfDataTypes).%New()
	f List=1:1:2 {
		s CodeList="Second:"_List,DescList="第二层:"_List
		s ArraySubObj=##class(%ArrayOfDataTypes).%New()
		d ArraySubObj.SetAt(CodeList,"CodeS")
		d ArraySubObj.SetAt(DescList,"DescS")
		;三层节点
		s SubObj=##class(%ListOfDataTypes).%New()
		f Sub=1:1:2 {
			s CodeSub="Third:"_Sub,DescSub="第三层:"_Sub
			s SubArr=##class(%ArrayOfDataTypes).%New()
			d SubArr.SetAt(CodeSub,"CodeT")
			d SubArr.SetAt(DescSub,"DescT")
			d SubObj.Insert(SubArr)
		}
		d ArraySubObj.SetAt(SubObj,"DataT")
		d DataObj.Insert(ArraySubObj)
	}
	d ArrayObj.SetAt(DataObj,"DataS")
	s XMLArr=##class(%ArrayOfDataTypes).%New()
	d XMLArr.SetAt(ArrayObj,"Request")


	w "数组转XML：" ,!
	;s XMLStr=..Arr2XML(XMLArr,"")	
	s XMLStr=..XMLRoot(ArrayObj,"Request")
	w "XML："_XMLStr.Read() ,!

	
	w !, "XML转数组：" ,!
	;注：xml转json的时候，需要传入根节点。
	s JsonStr=..Xml2Json(XMLStr,"Request","Request、DataS、DataT","N")
	;s JsonStr=..Xml2Josn(XMLStr,"Request")
	i $IsObject(JsonStr) { 
		s DocumentContent=""
		d JsonStr.Rewind()
		while (JsonStr.AtEnd=0){
			s DocumentContent=DocumentContent_JsonStr.Read(1000)
		}
		s DocumentContent=$tr(DocumentContent,$c(10),"")  ;因为流串存在换行
		s DocumentContent=$tr(DocumentContent,$c(0),"")
		s JsonStr=DocumentContent
	}
	s Arr=..Json2Arr(JsonStr) ;.OutputToDevice()
	i $IsObject(Arr) { 
		w "Code："_Arr.Data("Code") ,!
		w "Desc_Text："_Arr.Data("Desc_Text") ,!
		i Arr.IsDefined("Photo") d
		.w "Photo："_Arr.Data("Photo") ,!
		w "DataSSum："_Arr.Data("DataS").Count() ,!
		w "DataS.Code："_Arr.Data("DataS").GetAt(1).Data("CodeS") ,!
	}else{
		w "解析失败："_Arr
		q ""
	}


	w !,"数组转Json：" ,!
	s JsonStr=..Arr2Json(ArrayObj)
	i $IsObject(JsonStr) { 
		s DocumentContent=""
		d JsonStr.Rewind()
		while (JsonStr.AtEnd=0){
			s DocumentContent=DocumentContent_JsonStr.Read(1000)
		}
		s JsonStr=DocumentContent
	}
	w "Json："_JsonStr ,!


	w !,"Json转数组：" ,!
	s Arr=..Json2Arr(JsonStr)
	w "Code："_Arr.Data("Code") ,!
	w "DataSSum："_Arr.Data("DataS").Count() ,!
	w "DataS.Code："_Arr.Data("DataS").GetAt(1).Data("CodeS") ,!	
	
	q ""
}

/// 流转换为字符串
/// w ##class(web.DHCEQ.Plat.Common).GetString()
ClassMethod GetString(StreamStr) As %String
{
	s RtnStr=""
	if $IsObject(StreamStr) {
		do StreamStr.Rewind()
		while 'StreamStr.AtEnd {
			s RtnStr = RtnStr_StreamStr.Read(10000)
		}
	} else {
		s RtnStr=StreamStr
	}
	q RtnStr
}

/// 数组转换为Json串，支持多层转换
/// w ##class(web.DHCEQ.Plat.Common).ArrayToJsonStr()
ClassMethod ArrayToJsonStr(data As %DataType) As %String
{
	s Str=""
	s ArrayStream=##class(web.DHCEQ.Plat.Common).Arr2Json(data)
	s Str=##class(web.DHCEQ.Plat.Common).GetString(ArrayStream)
	q Str
}

}
