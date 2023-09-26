/// JSON，XML，动态对象之间的相互转换
/// Creator:WangQingyong 2019-05-20
/// note：产生子类：DHCDoc.Util.FromXML。本类已停用
Class DHCDoc.Util.XMLParse Extends %RegisteredObject
{

/// XML字符串或者流转对象
/// w ##class(DHCDoc.Util.XMLParse).XMLToObj("<Request><ExtUserID>demo</ExtUserID><Code></Code><HospitalId>1</HospitalId><datas><data><Name>123</Name><Sex>女</Sex></data><data><Name>023</Name><Sex>男</Sex></data></datas></Request>").%ToJSON()
/// w ##class(DHCDoc.Util.XMLParse).XMLToObj("<Request><ExtUserID>demo</ExtUserID><Code></Code><HospitalId>1</HospitalId><data><Name>123</Name><Sex>女</Sex></data><data><Name>023</Name><Sex>男</Sex></data></Request>","/Request/data").%ToJSON()
/// w ##class(DHCDoc.Util.XMLParse).XMLToObj("<Request><Head><Title>My Title</Title></Head><Body><ResultCode>100</ResultCode></Body></Request>").%ToJSON()
ClassMethod XMLToObj(XMLStream, ListNodePathStr = "") As %DynamicObject
{
	s JsonStr=..XMLToJSON(XMLStream,ListNodePathStr)
	s obj=##class(%DynamicObject).%FromJSON(JsonStr)
	Q obj
}

/// XML字符串或者流转JSON流
ClassMethod XMLToJSON(XMLStream, ListNodePathStr = "") As %Stream.GlobalCharacter
{
	s Stream=##class(%Stream.GlobalCharacter).%New()
	if $IsObject(XMLStream) s sc = ##class(%XML.TextReader).ParseStream(XMLStream,.reader)
	else  s sc = ##class(%XML.TextReader).ParseString(XMLStream,.reader)
	if $$$ISOK(sc){
		while (reader.Read()) {
			s Type=reader.NodeType,Path=reader.Path
			for i=1:1:$L(ListNodePathStr,","){
				s ListNodePath=$P(ListNodePathStr,",",i)
				continue:ListNodePath=""
				s Depth=$L(ListNodePath,"/")
				if ListNodePath=$P(Path,"/",1,Depth){
					s $P(Path,"/",1,Depth)=$P(Path,"/",1,Depth)_"/"_$P(Path,"/",Depth)
					s ParentPath=$P(ListNodePath,"/",1,$L(ListNodePath,"/")-1)
					if '$D(PList(ParentPath,"LeftSymbol")){
						s PList(ParentPath,"LeftSymbol")="{"
						s GrandParentPath=$P(ParentPath,"/",1,$L(ParentPath,"/")-1)
						if GrandParentPath'=""{
							if PList(GrandParentPath,"LeftSymbol")="{"{
								s PList(ParentPath,"LeftSymbol")="["
							}
						}
					}
				}
			}
			if Type="element"{
				s ParentPath=$P(Path,"/",1,$L(Path,"/")-1)
				if ParentPath'=""{
					s PList(ParentPath,"LeftSymbol")="{"
					s GrandParentPath=$P(ParentPath,"/",1,$L(ParentPath,"/")-1)
					if GrandParentPath'=""{
						if PList(GrandParentPath,"LeftSymbol")="{"{
							s PList(ParentPath,"LeftSymbol")="["
						}
					}
				}
			}elseif Type="endelement"{
				for i=1:1:$L(ListNodePathStr,","){
					s ListNodePath=$P(ListNodePathStr,",",i)
					continue:ListNodePath=""
					s Depth=$L(ListNodePath,"/")
					s ParentPath=$P(Path,"/",1,Depth-1)
					if Path=ParentPath{
						s Value=""""_$P(ListNodePath,"/",Depth)_""":["_$G(PList(ListNodePath,"Value"))_"]"
						i $G(PList(Path,"Value"))="" s PList(Path,"Value")=Value
						e  s PList(Path,"Value")=PList(Path,"Value")_","_Value
					}
				}
				s Value=$G(PList(Path,"Value"))
				if Value'=""{
					s LeftSymbol=$G(PList(Path,"LeftSymbol"))
					s RepSymbolFlag=0
					i (LeftSymbol="[")&($E(Value,1)'="{") s LeftSymbol="{",RepSymbolFlag=1
					s RightSymbol=$CASE(LeftSymbol,"{":"}","[":"]",:"")
					s Value=LeftSymbol_Value_RightSymbol
					i (LeftSymbol="[")!RepSymbolFlag s Value=""""_reader.Name_""":"_Value
					s ParentPath=$P(Path,"/",1,$L(Path,"/")-1)
					if ParentPath'=""{
						i $G(PList(ParentPath,"Value"))="" s PList(ParentPath,"Value")=Value
						e  s PList(ParentPath,"Value")=PList(ParentPath,"Value")_","_Value
					}else{
						if 'Stream.%IsNull() d Stream.Write(",")
						d Stream.Write(Value)
					}
				}
				k PList(Path)
			}else{
				s Name=$P(Path,"/",$L(Path,"/"))
				s PList(Path,"Value")=""""_Name_""":"""_reader.Value_""""
			}
		}
	}
	if Stream.%IsNull() d Stream.Write("{}")
	Q Stream
}

/// JSON字符串或流转XML流
/// w ##class(DHCDoc.Util.XMLParse).JSONToXML(str,"Request").Read()
ClassMethod JSONToXML(JSONStream, RootName, NodeList) As %Stream.GlobalCharacter
{
	s obj=##class(%DynamicObject).%FromJSON(JSONStream)
	Q ..ObjToXML(obj,RootName,.NodeList)
}

/// 对象转XML流
/// w ##class(DHCDoc.Util.XMLParse).ObjToXML({"Datas":[{"Name":"张三","Age":13},{"Name":"李四","Age":16}]},"Request",.NodeList).Read()
ClassMethod ObjToXML(obj, RootName, NodeList) As %Stream.GlobalCharacter
{
	s Stream=##class(%Stream.GlobalCharacter).%New()
	s HideNode=""
	s HideNode=$G(NodeList(RootName,"HideNode"))
	i 'HideNode d Stream.Write("<"_RootName_">")
	s iter=obj.%GetIterator()
	while iter.%GetNext(.key,.value){
		if $IsObject(value){
			if $ClassName(obj)="%Library.DynamicArray"{
				s key=$G(NodeList(RootName,"ChildNode"))
				s:key="" key=$E(RootName,1,$L(RootName)-1)
			}
			d Stream.CopyFrom(..ObjToXML(value,key,.NodeList))
		}else{
			d Stream.Write("<"_key_">"_value_"</"_key_">")
		}
	}
	i 'HideNode d Stream.Write("</"_RootName_">")
	Q Stream
}

}
