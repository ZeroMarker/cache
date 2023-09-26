Include (%callout, %occSAX, %occXSLT, %syNLS)

/// @author czf
/// @date   2021/1/13
/// 对象与json间转换
/// 命名%MethodName时,避免名称与其继承的基类方法名重复
Class web.DHCEQ.Plat.JsonObject Extends (%RegisteredObject, %XML.Adaptor)
{

Property xmlData As %String(MAXLEN = "") [ MultiDimensional, Private ];

/// The type (classname:propertyname) of the elements stored in the collection.
Property ElementType As %String(MAXLEN = 256) [ InitialExpression = {..#ELEMENTTYPE} ];

/// The type (class name) of the elements stored in the collection.
Parameter ELEMENTTYPE = "%String";

Parameter JSonSlice [ Final, Internal ] = 1;

Parameter JSonInString [ Final, Internal ] = 2;

Parameter JSonInArray [ Final, Internal ] = 3;

Parameter JSonInObject [ Final, Internal ] = 4;

Parameter EscapeChar As COSEXPRESSION = "$LB($LB(""\"",""\\""),$LB($C(13),""\n""),$LB($C(10),""\r""),$LB($C(9),""\t""),$LB("""""""",""\""""""),$LB($C(8),""\b""),$LB($C(12),""\f""))";

Parameter UnEscapeChar As COSEXPRESSION = "$LB(""\\"",""\n"",""\r"",""\t"",""\"""""",""\b"",""\f"")";

/// Creator:czf
/// CreatDate:2021-01-18
/// 使支持对象.key取值
/// This method gets the value of an unknown property
/// where its argument is the referenced property. 
/// Because %DispatchGetProperty() attempts to resolve any unknown property associated with the class, it has no specified return value; 
/// if successful, it returns a value whose type is that of the property being resolved
Method %DispatchGetProperty(key As %String)
{
	q $g(i%xmlData(key))
}

/// Creator:czf
/// CreatDate:2021-01-18
/// 使支持对象.key赋值
/// This method sets the value of an unknown property.
/// where its arguments are the name of the referenced property and the value to set for it.
Method %DispatchSetProperty(key As %String, value As %String)
{
	if $e(key,1,1)="'",$e(key,$l(key),$l(key))="'"{
		set key = $e(key,2,$l(key)-1) 
	}
	if $e(value,1,1)="'",$e(value,$l(value),$l(value))="'"{
		set value = $e(value,2,$l(value)-1)	
	}
	Set i%xmlData(key)=value
	
	Quit $$$OK
}

Method Clear() As %Status
{
	Kill i%xmlData
	Quit $$$OK
}

/// Starting from, but not including, location <var>key</var>, 
/// finds the next element in the array with value equal to <var>element</var>.
/// <p>If key is a null string (""), the search starts at the beginning of the array.
/// <p><b>Find</b> returns the key associated with the found element or null string ("") if no element is found.
Method Find(element As %String, key As %String) As %String
{
	Set k=$get(key)
	For  Set k=$order(i%xmlData(k)) Quit:k=""||(i%xmlData(k)=element)
	Quit k
}

/// Returns the number of elements contained in the array.
Method Count() As %Integer [ ProcedureBlock = 1 ]
{
	Set key="" For count=0:1 Set key=$order(i%xmlData(key)) Quit:key=""
	Quit count
}

/// Returns true (1) if a value is defined at location <var>key</var>, 
/// otherwise false (0).
Method %IsDefined(key As %String) As %Boolean [ CodeMode = expression, Final ]
{
$data(i%xmlData(key))
}

/// Finds and returns the value of the element at the location after <var>key</var> 
/// in the array. If <var>key</var> is a null string (""), it returns 
/// the value of the first element in the array.
/// <p>The value of <var>key</var>, which is passed by reference, is updated to the key 
/// value of the returned element or null string ("") if <var>key</var> is at the end of the array.
Method GetNext(ByRef key As %String) As %String
{
	Set key=$order(i%xmlData($get(key)))
	Quit $select(key="":"",1:$get(i%xmlData(key)))
}

/// Finds and returns the value of the element at the location before <var>key</var> 
/// in the array. If <var>key</var> is a null string (""), it returns 
/// the value of the last element in the array.
/// <p>The value of <var>key</var>, which is passed by reference, is updated to the key 
/// value of the returned element or null string ("") if <var>key</var> is at the beginning of the array.
Method GetPrevious(ByRef key As %String) As %String
{
	Set key=$order(i%xmlData($get(key)),-1)
	Quit $select(key="":"",1:$get(i%xmlData(key)))
}

/// Finds and returns the key value of the element at the location following <var>key</var> in the array. 
/// If key is a null string (""), then <b>Next</b> returns the key value for the first element in the array.
Method Next(key As %String = "") As %String [ CodeMode = expression, Final ]
{
$order(i%xmlData(key))
}

/// Finds and returns the key value of the element at the location preceding <var>key</var> in the array. 
/// If key is a null string (""), then <METHOD>Next</METHOD> returns the key value for the last element in the array.
Method Previous(key As %String = "") As %String [ CodeMode = expression, Final ]
{
$order(i%xmlData(key),-1)
}

/// Removes the element associated with <var>key</var> in the array.
/// <p><b>RemoveAt</b> returns the value of the removed element or null string ("") 
/// if no element was removed.
Method RemoveAt(key As %String) As %String
{
	Set removed=$get(i%xmlData(key))
	Kill i%xmlData(key)
	Quit removed
}

/// Creator:czf
/// CreatDate:2021-01-18
/// Finds and returns the value of the element associated with <var>key</var>.
/// <p><b>GetAt</b> returns the value of the element associated with <var>key</var> 
/// or null string ("") if no element is found.
Method %Get(key As %String)
{
	q $g(i%xmlData(key))
}

/// Creator:czf
/// CreatDate:2021-01-18
/// Sets the value of the element associated with <var>key</var> to <var>element</var>.
/// <p>Returns a <CLASS>%Status</CLASS> value indicating success or failure.
Method %Set(key, value) As %Status
{
	if $e(key,1,1)="'",$e(key,$l(key),$l(key))="'"{
		set key = $e(key,2,$l(key)-1) 
	}
	if $e(value,1,1)="'",$e(value,$l(value),$l(value))="'"{
		set value = $e(value,2,$l(value)-1)	
	}
	Set i%xmlData(key)=value
	
	Quit $$$OK
}

/// Creator:czf
/// CreatDate:2021-01-18
/// 对象转换为json字符串
Method %ToJSON() As %Library.String
{
	s jsonStream = ##class(%Stream.GlobalCharacter).%New()
	
	s k=""
	s count=0
	d jsonStream.Write("{")
	for
	{
		s d=..GetNext(.k)
		q:k=""
		s value=..Arr2Json(d)
		s node=$S(count'=0:",",1:"")_""""_..Escape(k)_""":"
		s count=count+1
		d jsonStream.Write(node)
		i $IsObject(value){
			d jsonStream.CopyFrom(value)
		}else{
			d jsonStream.Write(value)
		}
	}
	d jsonStream.Write("}")
	q ..GetString(jsonStream)
}

/// Creator:czf
/// CreatDate:2021-01-18
/// json字符串转换为web.DHCEQ.Plat.JsonObject对象
/// w ##class(web.DHCEQ.Plat.JsonObject).FromJSON()
ClassMethod FromJSON(jsonStr) As JsonObject
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
			set obj=##class(web.DHCEQ.Plat.JsonObject).%New()
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
					d arr.Insert(..FromJSON(slice)) 
				}elseif stack.GetAt(1)=..#JSonInObject {
					// we are in an object, so figure
					// out the property name and set an
					// element in an associative array,
					// for now 
					   
					set match=slice?." "1""""1.E1""""." "1":"1.E
					if match {
						//'name':value par
						set key1=$p(slice,":")
						set key=..FromJSON(key1)
						set val=..FromJSON($P(slice,":",2,$l(slice,":"))) 
						do obj.%Set(key,val)
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

/// 返回流对象
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

/// 流转换为字符串
/// w ##class(web.DHCEQ.Plat.JsonObject).GetString()
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

ClassMethod SetAux(what As %String, where As %Integer, delim As %String) As %DataType [ Internal ]
{
	set aux=##class(%ArrayOfDataTypes).%New() 
	do aux.SetAt(what,"what")
	do aux.SetAt(where,"where") 
	do aux.SetAt(delim,"delim")
	quit aux
}

/// 数组转换为Json串，支持多层转换
/// w ##class(web.DHCEQ.Plat.JsonObject).ArrayToJsonStr()
/// czf 2021-02-25 增加Flag参数，Flag=1直接返回流
ClassMethod ArrayToJsonStr(data As %DataType, Flag As %String = "") As %String
{
	s Str=""
	s ArrayStream=..Arr2Json(data)
	i Flag=1 q ArrayStream
	s Str=..GetString(ArrayStream)
	q Str
}

/// 数组转为Json流
/// w ##class(web.DHCEQ.Plat.JsonObject).Arr2Json()
ClassMethod Arr2Json(data As %DataType) As %GlobalCharacterStream
{
	s jsonStream = ##class(%Stream.GlobalCharacter).%New()
	if $IsObject(data) {  
		s key=""
		s typeData=data.%ClassName()
		i typeData="%ArrayOfDataTypes"||(typeData="JsonObject") {
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

/// d ##class(web.DHCEQ.Plat.JsonObject).Test()
ClassMethod Test() As %String
{
	s obj=##class(web.DHCEQ.Plat.JsonObject).%New() 
	s obj."Co_de"="001"
	s obj."Desc"="名称"
	d obj.%Set("Model","型号")
	s objRef = ##class(web.DHCEQ.Plat.JsonObject).%New()
	s objRef.Name="Jack",objRef.Sex="man"
	s obj.PatInfo=objRef  		//组合属性赋值
	
	w obj."Desc",!
	w obj.%Get("Co_de"),!
	w obj.%ToJSON(),!
	
	s a=obj.%ToJSON()
	s frobj=..FromJSON(a)
	w frobj,!
	w frobj.Desc,!
	w frobj.PatInfo.Name,!
}

}
