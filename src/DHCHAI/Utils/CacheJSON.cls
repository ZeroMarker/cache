/// 名称: DHCHAI.Utils.CahceJSON（来源：web.INSUCacheJSON.cls）
/// 描述: 解析json方法
/// 编写者：zhufei
/// 编写日期: 2017-10-26
Class DHCHAI.Utils.CacheJSON Extends %String
{

/*
*ZMC 20140715 from intersystems
* Decode a single JSON object into an %ArrayOfDataTypes
* Decode nested arrays of JSON objects into a %ListOfObjects containing %ArrayOfDataTypes
* Decode a single JSON object into a custom Cache object
* Encode an %ArrayOfDataTypes to a JSON string
* Encode a custom Cache object class to a JSON string
* Encode a %ListOfObjects containing %ArrayOfDataTypes into a JSON string
* Embed an array as the value of an element
* Convert a Cache object instance into an %ArrayOfDataTypes
*/
Parameter EscapeChar As COSEXPRESSION = "$LB($LB(""\"",""\\""),$LB($C(13),""\n""),$LB($C(10),""\r""),$LB($C(9),""\t""),$LB("""""""",""\""""""),$LB($C(8),""\b""),$LB($C(12),""\f""))";

Parameter UnEscapeChar As COSEXPRESSION = "$LB(""\\"",""\n"",""\r"",""\t"",""\"""""",""\b"",""\f"")";

Parameter JSonSlice [ Final, Internal ] = 1;

Parameter JSonInString [ Final, Internal ] = 2;

Parameter JSonInArray [ Final, Internal ] = 3;

Parameter JSonInObject [ Final, Internal ] = 4;

ClassMethod GetEscapeChars() As %String
{
  Quit ..#EscapeChar
}

ClassMethod SetAux(what As %String, where As %Integer, delim As %String) As %DataType [ Internal ]
{
  s aux=##class(%ArrayOfDataTypes).%New() 
  d aux.SetAt(what,"what")
  d aux.SetAt(where,"where") 
  d aux.SetAt(delim,"delim")
  q aux
}

/// 判断是否转码（在字符串结尾处没有成奇数个数的\）
ClassMethod isEscaped(str As %String, c As %String) As %Boolean [ Internal ]
{
  s pos=$F(str,c)
  q ($L($E(str,1,pos))-$L($REPLACE($E(str,1,pos),"\","")))#2=1
}

/// 给字符串转码 
ClassMethod Escape(str As %String) As %String [ Internal ]
{
  for tI=1:1:$LL(..#EscapeChar) { 
    Set tCharPair=$LG(..#EscapeChar,tI)
    Set str=$Replace(str,$LG(tCharPair,1),$LG(tCharPair,2))
  }
  Quit str
}

ClassMethod Unescape(str As %String) As %String [ Internal ]
{
  For tI=1:1:$Length(str){
    Set tChar=$ListFind(..#UnEscapeChar,$E(str,tI,tI+1))
    if (tChar>0){
      Set $E(str,tI,tI+1)=$LG($LG(..#EscapeChar,tChar),1)
    }
  }
  Quit str
}

/// JSON字符串解码 
ClassMethod Decode(str As %String) As %ArrayOfDataTypes
{
  #dim stack as %ListOfDataTypes
  s matchType=$ZCVT(str,"L")
 
  q:(matchType="true") "1"
  q:(matchType="false") "0"
  q:(matchType="null") ""  
  q:($ISVALIDNUM(matchType)) matchType 
  q:str?1"""".E1"""" ..Unescape($e(str,2,$l(str)-1))
  //$replace($e(str,2,$l(str)-1),"\""","""")
  // array or object notation
  s match=str?1(1"[".E1"]",1"{".E1"}")
  s stack=##class(%ListOfDataTypes).%New()
 
  if match {
    if $E(str,1)="[" {
      d stack.Insert(..#JSonInArray)
      s arr=##class(%ListOfDataTypes).%New()
    }  
    else {
      d stack.Insert(..#JSonInObject) 
      s obj=##class(%ArrayOfDataTypes).%New()
    }
   
    d stack.Insert(..SetAux(..#JSonSlice,1,"false"))
   
    s chars=$E(str,2,$L(str)-1)
   
    if chars="" {
      if stack.GetAt(1)=..#JSonInArray {
        q arr
      }
      else {
        q obj
      }  
    }

    s strlenChars=$L(chars)+1

    s escaped=0
    For c=1:1:strlenChars {
      s last=stack.Count()
      s top=stack.GetAt(last)
     
      s:(escaped=2) escaped=0
      s:(escaped=1) escaped=2
     
      s substrC2=$E(chars,c-1,c)
      if ($E(chars,c,c)="\")&&(escaped=0) s escaped=1
      
      if $e(chars,c)="" {
        s a=22
      }
     
      if (c=strlenChars || ($E(chars,c)=",")) && (top.GetAt("what")=..#JSonSlice) {
        // found a comma that is not inside a string, array, etc.,
        // OR we've reached the end of the character list
        //
        s slice = $E(chars, top.GetAt("where"),c-1)
        d stack.Insert(..SetAux(..#JSonSlice,c+1,"false"))
        if stack.GetAt(1)=..#JSonInArray {
          // we are in an array, so just push an element onto the stack
          d arr.Insert(..Decode(slice)) 
        }
        elseif stack.GetAt(1)=..#JSonInObject {
          // we are in an object, so figure
          // out the property name and set an
          // element in an associative array,
          // for now 
                   
          s match=slice?." "1""""1.E1""""." "1":"1.E
          if match {
            //'name':value par
            s key1=$p(slice,":")
            s key=..Decode(key1)

            s val=..Decode($P(slice,":",2,$l(slice,":"))) 
            d obj.SetAt(val, key)
                    
          }
        }
      }
      elseif $E(chars,c)="""" && (top.GetAt("what")'=..#JSonInString) {
        // found a quote, and we are not inside a string
        d stack.Insert(..SetAux(..#JSonInString,c,$E(chars,c)))
      }
      elseif $E(chars,c)=top.GetAt("delim") && (top.GetAt("what")=..#JSonInString) && (escaped=0) {
        // found a quote, we're in a string, and it's not escaped (look 3 charachters behind, to see the \" is not \\" )
        s last=stack.Count()
        s st=stack.RemoveAt(last)
      }
      elseif ($E(chars,c)="[") && (top.GetAt("what")'=..#JSonInString) && ($CASE(top.GetAt("what"),..#JSonInString:1,..#JSonInArray:1,..#JSonSlice:1,:0)) { 
        // found a left-bracket, and we are in an array, object, or slice
        d stack.Insert(..SetAux(..#JSonInArray,c,"false"))
      }
      elseif $E(chars,c)="]" && (top.GetAt("what")=..#JSonInArray) {
        // found a right-bracket, and we're in an array
        s last=stack.Count()
        s st=stack.RemoveAt(last) 
      }
      ;modificacio 19/11/08: ..#JSonString -> #JSonInArray
      elseif $E(chars,c)="{" && ($CASE(top.GetAt("what"),..#JSonSlice:1,..#JSonInArray:1,..#JSonInObject:1,:0)) {
        // found a left-brace, and we are in an array, object, or slice
        d stack.Insert(..SetAux(..#JSonInObject,c,"false"))
      }
      elseif $E(chars,c)="}" && (top.GetAt("what")=..#JSonInObject) {
        // found a right-brace, and we're in an object 
        s last=stack.Count()
        s st=stack.RemoveAt(last) 
      }
     
    }  
   
    if stack.GetAt(1)=..#JSonInObject {
      q obj
    }
    elseif stack.GetAt(1)=..#JSonInArray {
      q arr
    }
  }
  q str
}

/// 把CACHE的数据转为JSON字符串
ClassMethod Encode(data As %DataType) As %String
{

  if $IsObject(data) {  
    s key=""
   
    s typeData=data.%ClassName()

    if typeData="%ArrayOfDataTypes" {
      //type object
      s key=""
      s cad=""
      F {
        s pData=data.GetNext(.key)
        q:key=""
        s value=..Encode(pData)
        s cad=$S(cad'="":cad_",",1:"")_""""_..Escape(key)_""":"_value  
      } 
      q "{"_cad_"}"
    }
    elseif typeData="%ListOfDataTypes" {
      //type array 
     
      s cad=""
      f i=1:1:data.Count() {
        s tmp=..Encode(data.GetAt(i))
        s cad=$S(i>1:cad_",",1:"")_tmp
      }
     
      s cad="["_cad_"]"
      q cad
    }
    //ZMC Add ListofObj 20151022
    elseif typeData["ListOfObj" {
      //type list 
     
      s cad=""
      f i=1:1:data.Count() {
        s tmp=..Encode(..GetAsArrayOfDataTypesFromOBJ(data.GetAt(i)))
        s cad=$S(i>1:cad_",",1:"")_tmp
      }
     
      s cad="["_cad_"]"
      q cad
    }
  }
  elseif ($FIND(data,".")) {
	;; This $ISVALIDNUM below is causing some %String property types that are valid numbers (ie. .1293394) to be unescaped
  	;; $ISVALIDNUM allows for periods. Need to check for a . in another elseif and escape it like a string "".

	//type string
    q:data="" "null"
    q """"_..Escape(data)_""""
  }
  elseif $ISVALIDNUM(data) {
    // type number
    //q data	防止01转为1，改为下面
    q """"_..Escape(data)_""""
  }
  else {
    //type string
    q:data="" "null"
    //q:data="" ""
    q """"_..Escape(data)_""""
  }
}

ClassMethod CreateStringPair(pKey As %String, pValue As %String) As %String
{
  Quit """"_pKey_""":"""_..Escape(pValue)_""""
}

/// 解析
ClassMethod Parse(pStr As CacheJSON) As %ArrayOfDataTypes
{
  Quit ##class(DHCHAI.Utils.CacheJSON).Decode(pStr)
}

ClassMethod Stringify(pData As %DataType) As CacheJSON
{
  Quit ##class(DHCHAI.Utils.CacheJSON).Encode(pData)
}

/// Return an encoded JSON string of the object.<br>
/// Uses all object properties that do not start with a % char.
Method GetJSONFromObject() As %String [ CodeMode = objectgenerator ]
{
	// Only create this method when compiling other classes this is extended upon
	If (%compiledclass.Name '= "DHCHAI.Utils.CacheJSON") {
		
		// Wrap the object in an array
		Do %code.WriteLine(" Set array = ##class(%ArrayOfDataTypes).%New()")
		
		
		// Rip through each property of the class.. that does not start with a %
		// Insert each property as a key=>value pair in the array
		For i = 1:1:%compiledclass.Properties.Count() {
	        Set prop = %compiledclass.Properties.GetAt(i).Name
	        IF ($EXTRACT(prop) '= "%") {
		        Do %code.WriteLine(" Do array.SetAt(.."_prop_","""_prop_""")")
	        }
	        
	    }
    	
	    // Return an encoded JSON string of the object
	    Do %code.WriteLine(" Quit ..Encode(array)")
	}
}

/// Returns the object as an %ArrayOfDataTypes key=>value pair set.
/// This is helpful when trying to return a %ListOfDataTypes in JSON form, by quickly building an array object to Insert.
/// Uses all object properties that do not start with a % char.
Method GetAsArrayOfDataTypes() As %ArrayOfDataTypes [ CodeMode = objectgenerator ]
{
	// Only create this method when compiling other classes this is extended upon
	If (%compiledclass.Name '= "DHCHAI.Utils.CacheJSON") {
		
		// Wrap the object in an array
		Do %code.WriteLine(" Set array = ##class(%ArrayOfDataTypes).%New()")
	
		// Rip through each property of the class.. that does not start with a %
		// Insert each property as a key=>value pair in the array
		For i = 1:1:%compiledclass.Properties.Count() {
	        Set prop = %compiledclass.Properties.GetAt(i).Name
	        IF ($EXTRACT(prop) '= "%") {
		        Do %code.WriteLine(" Do array.SetAt(.."_prop_","""_prop_""")")
	        }
	    }
    
	    // Return an %ArrayOfDataTypes representation of the object
	    Do %code.WriteLine(" Quit array")
	}
}

ClassMethod GetAsArrayOfDataTypesFromOBJ(classOBJ) As %ArrayOfDataTypes
{
	s arr=##class(%ArrayOfDataTypes).%New()
	if (classOBJ.%IsA("%Library.Persistent")||(classOBJ.%IsA("%RegisteredObject"))){
		s className=classOBJ.%ClassName()
		s pkgName=classOBJ.%PackageName()
		s key=""
		s:$d(^oddCOM(className)) ClassName=className
		s:$d(^oddCOM(pkgName_"."_className)) ClassName=pkgName_"."_className
		f {
			s key=$o(^oddCOM(ClassName,"a",key))
			q:key=""
			i $e(key,1)="%"{
				continue
			}
			s private=$g(^oddDEF(ClassName,"a",key,35))
			if private=1{
				continue
			}
			/* 暂不考虑类型
			s tmptype=$g(^oddCOM(ClassName,"a",key,5))
			i tmptype="" {
				s tmpClassName=^oddCOM(ClassName,"a",key,2)
				s tmptype=$g(^oddCOM(tmpClassName,"a",key,5))
			}
			*/
			d arr.SetAt($PROPERTY(classOBJ,key),key)
		}
	}
	q arr
}

/// Returns an OREF populated with the values from the JSON
/// Uses all object properties that do not start with a % char.
ClassMethod GetObjectFromJSON(JSON As %String) As %RegisteredObject [ CodeMode = objectgenerator ]
{
	// Only create this method when compiling other classes this is extended upon
	If (%compiledclass.Name '= "Spectrum.Util.CacheJSON") {
		Do %code.WriteLine(" Set return = ##class("_%compiledclass.Name_").%New()")
	
		Do %code.WriteLine(" Set myDecodedArray = ..Decode(JSON)")
		
		// Rip through each property of the class.. that does not start with a %
		// Insert each property into the object to return
		For i = 1:1:%compiledclass.Properties.Count() {
	        Set prop = %compiledclass.Properties.GetAt(i).Name
	        IF ($EXTRACT(prop) '= "%") {
		        //Do %code.WriteLine(" Do array.SetAt(.."_prop_","""_prop_""")")
		        Do %code.WriteLine(" Set return."_prop_" = myDecodedArray.GetAt("""_prop_""")")
	        }
	    }
	    
		Do %code.WriteLine(" Quit return")
	}
}

/// 把JSON转换为对象(支持属性集合)。
/// objClass:对象实例,必须继承自%RegisteredObject
/// inJson:JSON字符串或已经转换为Array的JSON
ClassMethod RtnObjectFromJSON(objClass, inJson) As %RegisteredObject
{
	;q:$IsObject(inJson)=0 objClass
	q:$IsObject(objClass)=0 objClass
	s rtnobj=objClass
	if (objClass.%IsA("%Library.Persistent")||(objClass.%IsA("%RegisteredObject"))){
		i $IsObject(inJson){
			s myDecodedArray =inJson
		}else{
			s myDecodedArray = ..Decode(inJson)
		}
		s className=objClass.%ClassName()
		s pkgName=objClass.%PackageName()
		s key=""
		s:$$$defClassDefined(className) ClassName=className
		s:$$$defClassDefined(pkgName_"."_className) ClassName=pkgName_"."_className
		f {
			s key=$$$defMemberNext(ClassName,$$$cCLASSproperty,key)
			q:key=""
			i $e(key,1)="%"{
				continue
			}
			s private=$$$comMemberKeyGet(ClassName,$$$cCLASSproperty,key,35)
			if private=1{
				continue
			}
			s (tmptype,subclass)=""
			i $$$defMemberKeyDefined(ClassName,$$$cCLASSproperty,key,27) {
				s tmptype=$$$defMemberKeyGet(ClassName,$$$cCLASSproperty,key,27)
				s subclass=$$$defMemberKeyGet(ClassName,$$$cCLASSproperty,key,5)
				s subar=myDecodedArray.GetAt(key)
				s jsobj=##class(%ArrayOfDataTypes).%New()
				s tmpsubclassobj=""
				s subkey=key
				i $IsObject(subar)=0 {
					s $PROPERTY(rtnobj,key)=subar
				}else{
					f i=1:1:subar.Count(){
						s jsobj=subar.GetAt(i)
						s tmpvn="##class("_subclass_").%New()"
						Set tmpsubclassobj=$$XECUTEN^INSUFUN(tmpvn)
						//XECUTE ("Set tmpsubclassobj=##class("_subclass_").%New()")
						s tmpsubclassobj=..RtnObjectFromJSON(tmpsubclassobj,jsobj)
						s stas=$$XECUTENN^INSUFUN(.rtnobj,subkey,tmpsubclassobj)
					}
				}
			}else{
				s $PROPERTY(rtnobj,key)=myDecodedArray.GetAt(key)
			}
		}
		q rtnobj
	}
	else{q objClass}
}

Storage Default
{
<Data name="CacheJSONDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.Utils.CacheJSOND</DataLocation>
<DefaultData>CacheJSONDefaultData</DefaultData>
<IdLocation>^DHCHAI.Utils.CacheJSOND</IdLocation>
<IndexLocation>^DHCHAI.Utils.CacheJSONI</IndexLocation>
<StreamLocation>^DHCHAI.Utils.CacheJSONS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
