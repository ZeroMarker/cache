Class web.INSUCacheJSON Extends %String
{

/// ZMC 20140715 from intersystems
/// Decode a single JSON object into an %ArrayOfDataTypes
/// Decode nested arrays of JSON objects into a %ListOfObjects containing %ArrayOfDataTypes
/// Decode a single JSON object into a custom Cache object
/// Encode an %ArrayOfDataTypes to a JSON string
/// Encode a custom Cache object class to a JSON string
/// Encode a %ListOfObjects containing %ArrayOfDataTypes into a JSON string
/// Embed an array as the value of an element
/// Convert a Cache object instance into an %ArrayOfDataTypes
/// ZMC 20180910 修改部分BUG
/// ZMC 20190425 修改一个重现的BUG
/// ZMC 20200115 增加EncodetoStream和GetJSONStreamFromObject函数,解决生成json超长问题(主要是cache2010及以下版本)
/// ZMC 20200116 增加用法说明
/// ZMC 20200226 修正老库RtnObjectFromJSON问题
/// ZMC 20200401 修正某些第三方接口中,数字字段不允许用引号的问题及01被当成数字的问题
Parameter EscapeChar As COSEXPRESSION = "$LB($LB(""\"",""\\""),$LB($C(13),""\n""),$LB($C(10),""\r""),$LB($C(9),""\t""),$LB("""""""",""\""""""),$LB($C(8),""\b""),$LB($C(12),""\f""))";

Parameter UnEscapeChar As COSEXPRESSION = "$LB(""\\"",""\n"",""\r"",""\t"",""\"""""",""\b"",""\f"")";

Parameter JSonSlice [ Final, Internal ] = 1;

Parameter JSonInString [ Final, Internal ] = 2;

Parameter JSonInArray [ Final, Internal ] = 3;

Parameter JSonInObject [ Final, Internal ] = 4;

ClassMethod Help() As %String
{
	w "一、对象转JSON",!!
	w "	用法1、对象obj已经继承web.INSUCacheJSON",!
	w "		s obj=##class(User.INSUDicData).%OpenId(2659)",!
	w "		s jsonString =obj.GetJSONFromObject()	;直接生成JSON",!!

	w "	用法2、对象obj没有继承web.INSUCacheJSON",!
	w "		obj可以是类、数组、集合等",!
	w "		s jsonString =##class(web.INSUCacheJSON).Encode(obj) ;生成JSON",!!

 	w "二、JSON转对象",!!
	w "	用法1、对象obj已经继承web.INSUCacheJSON",!
	w "		s Obj=##class(User.INSUDicData).%New()",!
	w "		s newObj=Obj.GetObjectFromJSON(jsonString)	;JSON转对象",!!

	w "	用法2、对象obj没有继承web.INSUCacheJSON",!
	w "		s tmpObj=##class(User.test).%New()",!
	w "		d ##class(web.INSUCacheJSON).RtnObjectFromJSON(.tmpObj,jsonString) ;JSON转对象",!
	w "		或s newObj2=##class(web.INSUCacheJSON).RtnObjectFromJSON(tmpObj,jsonString) ",!
	q ""
}

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

/// 判断是否转码(只判断第一个\是否转码). 
ClassMethod isEscaped(str As %String, c As %String) As %Boolean [ Internal ]
{
  s pos=$F(str,c)
  q ($L($E(str,1,pos))-$L($TR($E(str,1,pos),"\","")))#2=1
}

/// 给字符串转码   
ClassMethod Escape(str As %String) As %String [ Internal ]
{
  for tI=1:1:$LL(..#EscapeChar) d
  .s tCharPair=$LG(..#EscapeChar,tI)
  .s str=$REPLACE(str,$LG(tCharPair,1),$LG(tCharPair,2))  
  Quit str
}

ClassMethod Unescape(str As %String) As %String [ Internal ]
{
  For tI=1:1:$Length(str) d
  .Set tChar=$ListFind(..#UnEscapeChar,$E(str,tI,tI+1))
  .if (tChar>0) d
  ..Set $E(str,tI,tI+1)=$LG($LG(..#EscapeChar,tChar),1)
  Quit str
}

/// JSON字符串转为%ArrayOfDataTypes
/// 推荐用RtnObjectFromJSON或GetObjectFromJSON,可把JSON转为类对象.  
ClassMethod Decode(str As %String) As %ArrayOfDataTypes
{
  #dim stack as %ListOfDataTypes
  s matchType=$ZCVT(str,"L")
 
  q:(matchType="true") "1"
  q:(matchType="false") "0"
  q:(matchType="null") ""  
  q:($ISVALIDNUM(matchType)) matchType 
  q:str?1"""".E1"""" ..Unescape($e(str,2,$l(str)-1))
  //$TR($e(str,2,$l(str)-1),"\""","""")
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
      //..#JSonString -> #JSonInArray
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

/// 把CACHE的数据或对象转为JSON字符串.  
/// w ##class(web.INSUCacheJSON).Encode(web.INSUTest)
/// 推荐用GetJSONFromObject,可以把类对象生成JSON  
/// 如果json超长,就用EncodetoStream函数
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
	elseif (typeData="%GlobalBinaryStream") {
		s piece = ""
		while (data.AtEnd = 0) {
			s piece = piece_data.Read()
		}
		q """"_..Escape(piece)_""""
	}
	else {
		S ^DD(123)=data
		//maybe is OBJ,ZMC 20190425
		s cad=..Encode(..GetAsArrayOfDataTypesFromOBJ(data))
		q cad
		/*
		s className = $P(data, "@", 2)
		s libelle = $PARAMETER(className, "JSONLIBELLE")	//获取参数.	 	
		s isLink = $L(libelle, ".")=2
		
		// RelationShip
		if isLink {
			s child = $ZObjProperty(data, $P(libelle, ".", 1))
			s childLibelle = $P(libelle, ".", 2)			
			s key=""
	  		s cad=""
	  		for {
				s pData = data.GetNext(.key)
				q:key=""
				s value = ..Encode(pData)
				s cad = $S(cad'="":cad_",",1:"")_""""_..Escape(key)_""":"_value
	  		}
	  		s isProperty = $Find(childLibelle, "()")=0
	  		s lib = $Case(isProperty, 1:$ZObjProperty(child, childLibelle), :$Method(child, $E(childLibelle, 1, *-2)))
			q "{"_cad_",""childLibelle"":"_..Escape(lib)_"""}"
		}
		else {
			if $l(libelle)>2 {
				s lib = $Case($Find(libelle, "()"), 0:$ZObjProperty(data, libelle), :$Method(data, $E(libelle, 1, *-2)))
				;q "{""id"":"""_..Escape(data.%Id())_""",""libelle"":"""_..Escape(lib)_"""}"
			}
			else{
				//maybe is OBJ,ZMC 20190425
				s cad=..Encode(..GetAsArrayOfDataTypesFromOBJ(data))
				q cad
			}			
		}
		*/
	}
  }
  elseif $ISVALIDNUM(data) {
    // type number
    s:$p(data,".",1)="" data=0_data
    q $s(($e(data,1,1)="0")&&($e(data,1,2)'="0."):""""_..Escape(data)_"""",1:data)
    q data
  }
  elseif (($FIND(data,"."))&&(($e(data,1)'="{")&&($e(data,1)'="["))) {
	;; This $ISVALIDNUM below is causing some %String property types that are valid numbers (ie. .1293394) to be unescaped
  	;; $ISVALIDNUM allows for periods. Need to check for a . in another elseif and escape it like a string "".
	//type string
    q:data="" """"""
    q """"_..Escape(data)_""""
  }
  elseif $Case(data, "true":1, "false":1, :0) {
	  q data
  }
  else {
    //type string
    q:data="" """"""
   
  
    q:$tr(data," ","")="{}" data  //空json对象 DingSH 20210902
    q:$tr(data," ","")="[]" data  //空json数组 DingSH 20210902
    //i ($e(data,1)="{")||($e(data,1)="[") {
	i (($e(data,1)="{")||($e(data,1)="["))&&(data["""")&&(data[":") {    //  增加{}或[]判断条件 DingSH 20210902
	    s tmpend=$e(data,$l(data))
		q:(tmpend="}"||(tmpend="]")) data
	}
	
	
    //q:data="" ""
    q """"_..Escape(data)_""""
  }
}

/// 把CACHE的数据或对象转为JSON数据流.  
/// w ##class(web.INSUCacheJSON).EncodetoStream(web.INSUTest)
/// 推荐用GetJSONStreamFromObject,可以把类对象生成JSON数据流 
ClassMethod EncodetoStream(data As %DataType) As %GlobalCharacterStream
{
  #dim cadStream As %GlobalCharacterStream
  
  if $IsObject(data) {  
    s key=""   
    s typeData=data.%ClassName()
    if typeData="%ArrayOfDataTypes" {
      //type object
      s cadStream = ##class(%GlobalCharacterStream).%New()
      s i=0
      s key=""
      F {
        s pData=data.GetNext(.key)
        q:key=""
        s valueS=..EncodetoStream(pData)
        s i=i+1
        i i=1 d
        .d cadStream.Write("{"_""_""""_..Escape(key)_""":")
        e  d 
        .d cadStream.Write(","_""""_..Escape(key)_""":")
        d cadStream.CopyFrom(valueS)
        d valueS.Clear()
      } 
      d cadStream.Write("}")
      q cadStream
    }
    elseif typeData="%ListOfDataTypes" {
      //type array    
      s cadStream = ##class(%GlobalCharacterStream).%New() 
      d cadStream.Write("[")
      f i=1:1:data.Count() {
        s tmpS=..EncodetoStream(data.GetAt(i))
        ;s cad=$S(i>1:cad_",",1:"")_tmp
        i i=1 d
        .d cadStream.Write("")
        e  d 
        .d cadStream.Write(",")
        d cadStream.CopyFrom(tmpS)
        d tmpS.Clear()
      }
      d cadStream.Write("]")
      q cadStream
    }
    elseif typeData["ListOfObj" {
      //type list      
      s cadStream = ##class(%GlobalCharacterStream).%New() 
      d cadStream.Write("[")
      f i=1:1:data.Count() {
        s tmpS=..EncodetoStream(..GetAsArrayOfDataTypesFromOBJ(data.GetAt(i)))
        i i=1 d
        .d cadStream.Write("")
        e  d 
        .d cadStream.Write(",")
        d cadStream.CopyFrom(tmpS)
        d tmpS.Clear()
      }
      d cadStream.Write("]")
      q cadStream
    }
	elseif (typeData="%GlobalBinaryStream") {
		s cadStream = ##class(%GlobalCharacterStream).%New() 
		i data.Size>1 d
		.d cadStream.Write("""")
		while (data.AtEnd = 0) {
			d cadStream.CopyFrom(..Escape(data.Read(32000)))
		}
		d cadStream.Write("""")
		q cadStream
	}
	else {
		
		//maybe is OBJ,ZMC 20200116
		s cadStream = ##class(%GlobalCharacterStream).%New() 
		s tmpStream=..EncodetoStream(..GetAsArrayOfDataTypesFromOBJ(data))
		d cadStream.CopyFrom(tmpStream)
		d tmpStream.Clear()
		q cadStream
		/*
		s className = $P(data, "@", 2)
		s libelle = $PARAMETER(className, "JSONLIBELLE")	//获取参数.	 	
		s isLink = $L(libelle, ".")=2
		s cadStream = ##class(%GlobalCharacterStream).%New() 
		// RelationShip
		if isLink {
			s child = $ZObjProperty(data, $P(libelle, ".", 1))
			s childLibelle = $P(libelle, ".", 2)			
			s key=""
			s i=0
	  		
	  		for {
				s pData = data.GetNext(.key)
				q:key=""
				s i=i+1
				s valueS = ..EncodetoStream(pData)
				;s cad = $S(cad'="":cad_",",1:"")_""""_..Escape(key)_""":"_value
		        i i=1 d
		        .d cadStream.Write("{"_""""""_..Escape(key)_""":")
		        e  d 
		        .d cadStream.Write(","_""""""_..Escape(key)_""":")
		        d cadStream.CopyFrom(valueS)
		        d valueS.Clear()
	  		}
	  		s isProperty = $Find(childLibelle, "()")=0
	  		s lib = $Case(isProperty, 1:$ZObjProperty(child, childLibelle), :$Method(child, $E(childLibelle, 1, *-2)))
	  		i i=1 d
	  		.d cadStream.Write("{")
	  		d cadStream.Write(",""childLibelle"":"_..Escape(lib)_"""}")
			q cadStream
		}
		else {
			if $l(libelle)>2 {
				s lib = $Case($Find(libelle, "()"), 0:$ZObjProperty(data, libelle), :$Method(data, $E(libelle, 1, *-2)))
				;d cadStream.Write("{""id"":"""_..Escape(data.%Id())_""",""libelle"":"""_..Escape(lib)_"""}")
				;q cadStream
			}
			else{
				//maybe is OBJ,ZMC 20200116
				s tmpStream=..EncodetoStream(..GetAsArrayOfDataTypesFromOBJ(data))
				d cadStream.CopyFrom(tmpStream)
				d tmpStream.Clear()
				q cadStream
			}			
		}
		*/
	}
  }
  elseif $ISVALIDNUM(data) {
    // type number
    s:$p(data,".",1)="" data=0_data
    ;s:($e(data,1,1)="0")&&($e(data,1,2)'="0.") data=""""_..Escape(data)_""""
    s data=""""_data_""""
    s cadStream = ##class(%GlobalCharacterStream).%New() 
    d cadStream.Write(data)
    q cadStream
  }
  elseif (($FIND(data,"."))&&(($e(data,1)'="{")&&($e(data,1)'="["))) {
	;; This $ISVALIDNUM below is causing some %String property types that are valid numbers (ie. .1293394) to be unescaped
  	;; $ISVALIDNUM allows for periods. Need to check for a . in another elseif and escape it like a string "".
	//type string
	s cadStream = ##class(%GlobalCharacterStream).%New() 
	i data="" d
	.d cadStream.Write("""""")
	e  d
	.d cadStream.Write(""""_..Escape(data)_"""")
    q cadStream
  }

  elseif $Case(data, "true":1, "false":1, :0) {
    s cadStream = ##class(%GlobalCharacterStream).%New() 
    d cadStream.Write(data)
    q cadStream
  }
  else {
    //type string
	s cadStream = ##class(%GlobalCharacterStream).%New() 
	i data="" d
	.d cadStream.Write("""""")
	e  d
	.i ($e(data,1)="{")||($e(data,1)="[") d
	..d cadStream.Write(data)
	.e  d cadStream.Write(""""_..Escape(data)_"""")
    q cadStream
  }
}

ClassMethod CreateStringPair(pKey As %String, pValue As %String) As %String
{
  Quit """"_pKey_""":"""_..Escape(pValue)_""""
}

/// 解析.  
ClassMethod Parse(pStr As INSUCacheJSON) As %ArrayOfDataTypes
{
  Quit ##class(web.INSUCacheJSON).Decode(pStr)
}

ClassMethod Stringify(pData As %DataType) As INSUCacheJSON
{
  Quit ##class(web.INSUCacheJSON).Encode(pData)
}

/// 把对象序列化为JSON串(对象属性不能以%char开头)
/// 对象属性不能以%char开头
/// 对象需要继承此类
/// s json=##class(web.INSUTest).GetJSONFromObject() ;生成json串
Method GetJSONFromObject() As %String [ CodeMode = objectgenerator ]
{
	// Only create this method when compiling other classes this is extended upon
	If (%compiledclass.Name '= "web.INSUCacheJSON") {
		
		// Wrap the object in an array
		Do %code.WriteLine(" Set array = ##class(%ArrayOfDataTypes).%New()")
		// Rip through each property of the class.. that does not start with a %
		// Insert each property as a key=>value pair in the array
		For i = 1:1:%compiledclass.Properties.Count() {
	        Set prop = %compiledclass.Properties.GetAt(i).Name
	        s tmppropnode=%compiledclass.Properties.GetAt(i).Parameters.GetAt("XMLNAME")
	        s propnode=prop
	        s:tmppropnode'="" propnode=tmppropnode
	        IF ($EXTRACT(prop) '= "%") {
		        Do %code.WriteLine(" Do array.SetAt(.."_prop_","""_propnode_""")")
	        }
	        
	    }
    	
	    // Return an encoded JSON string of the object
	    Do %code.WriteLine(" Quit ..Encode(array)")
	}
}

/// 把对象序列化为JSON串字符流(对象属性不能以%char开头)
/// 对象属性不能以%char开头
/// 对象需要继承此类
/// s json=##class(web.INSUTest).GetJSONStreamFromObject() ;生成json字符流
Method GetJSONStreamFromObject() As %String [ CodeMode = objectgenerator ]
{
	// Only create this method when compiling other classes this is extended upon
	If (%compiledclass.Name '= "web.INSUCacheJSON") {
		
		// Wrap the object in an array
		Do %code.WriteLine(" Set array = ##class(%ArrayOfDataTypes).%New()")
		
		
		// Rip through each property of the class.. that does not start with a %
		// Insert each property as a key=>value pair in the array
		For i = 1:1:%compiledclass.Properties.Count() {
	        Set prop = %compiledclass.Properties.GetAt(i).Name
	        s tmppropnode=%compiledclass.Properties.GetAt(i).Parameters.GetAt("XMLNAME")
	        s propnode=prop
	        s:tmppropnode'="" propnode=tmppropnode
	        IF ($EXTRACT(prop) '= "%") {
		        Do %code.WriteLine(" Do array.SetAt(.."_prop_","""_propnode_""")")
	        }
	        
	    }
    	
	    // Return an encoded JSON string of the object
	    Do %code.WriteLine(" Quit ..EncodetoStream(array)")
	}
}

/// Returns the object as an %ArrayOfDataTypes key=>value pair set.
/// This is helpful when trying to return a %ListOfDataTypes in JSON form, by quickly building an array object to Insert.
/// Uses all object properties that do not start with a % char.
Method GetAsArrayOfDataTypesOld() As %ArrayOfDataTypes [ CodeMode = objectgenerator ]
{
	// Only create this method when compiling other classes this is extended upon
	If (%compiledclass.Name '= "web.INSUCacheJSON") {
		
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

/// Returns the object as an %ArrayOfDataTypes key=>value pair set.
/// This is helpful when trying to return a %ListOfDataTypes in JSON form, by quickly building an array object to Insert.
Method GetAsArrayOfDataTypes() As %ArrayOfDataTypes [ CodeMode = objectgenerator ]
{
	// Wrap the object in an array
	d %code.WriteLine(" s array = ##class(%ArrayOfDataTypes).%New()")
	
	// Rip through each property of the class.. that does not start with a %
	// Insert each property as a key=>value pair in the array
	for i=1:1:%compiledclass.Properties.Count()
	{
		s property = %compiledclass.Properties.GetAt(i)
		
		// %Library.Date
		if (property.Type = "%Library.Date") {
			d %code.WriteLine(" s dateCache = .."_property.Name_"")
			d %code.WriteLine(" s dateString = $Case(dateCache, """":"""", :$zd(dateCache, 3,,,,,,,""""))")
			d %code.WriteLine(" d array.SetAt(dateString,"""_property.Name_""")")
		}
		
		// .%Id()
		elseif (property.Name = "%%OID") {
			//d %code.WriteLine(" d array.SetAt(..%Id(),""id"")")
		}
		elseif ($E(property.Name) '= "%") {
			if (property.Collection="array") {
				d %code.WriteLine(" s list = ##class(%ListOfDataTypes).%New()")
				d %code.WriteLine(" for i=1:1:.."_property.Name_".Count() {")
				d %code.WriteLine(" 	s child = .."_property.Name_".GetAt(i).GetAsArrayOfDataTypes()")
				d %code.WriteLine(" 	d list.Insert(child)")
				d %code.WriteLine(" }")
				d %code.WriteLine(" d array.SetAt(list,"""_property.Name_""")")
			}
			elseif ($E(property.Type) = "%") {
				d %code.WriteLine(" d array.SetAt(.."_property.Name_","""_property.Name_""")")
			}
			elseif (property.Calculated = 0) {
				;d %code.WriteLine(" d array.SetAt($Case(.."_property.Name_","""":"""",:.."_property.Name_".%Id()),"""_property.Name_""")")
			}
		}
	}
	
	if ($Get(%parameter("JSONLIBELLE"))'="") {
		d %code.WriteLine(" d array.SetAt(.."_%parameter("JSONLIBELLE")_",""childLibelle"")")
	}
	
	if ($Get(%parameter("ExtendGetJSONFromObject"))'="") {
		d %code.WriteLine(" d .."_%parameter("ExtendGetJSONFromObject")_"(.array)")
	}
	
	// Return an %ArrayOfDataTypes representation of the object
	d %code.WriteLine(" q array")
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
			; 暂不考虑类型.   
			;s tmptype=$g(^oddCOM(ClassName,"a",key,5))
			;i tmptype="" {
			;	;s tmpClassName=^oddCOM(ClassName,"a",key,2)
			;	;s tmptype=$g(^oddCOM(tmpClassName,"a",key,5))
			;}
			s keynode=key
			s tmpkeynode=$$$comMemberArrayGet(ClassName,$$$cCLASSproperty,key,"P","XMLNAME")
			s:tmpkeynode'="" keynode=tmpkeynode
			d arr.SetAt($ZObjProperty(classOBJ,key),keynode)
		}
	}
	q arr
}

/// JSON转为对象
/// 	对象User.INSUDicData已经继承web.INSUCacheJSON
/// 	s Obj=##class(User.INSUDicData).%New()
/// 	s newObj=Obj.GetObjectFromJSON(jsonString)	;JSON转对象
ClassMethod GetObjectFromJSON(JSON As %String) As %RegisteredObject [ CodeMode = objectgenerator ]
{
	// Only create this method when compiling other classes this is extended upon
	If (%compiledclass.Name '= "web.INSUCacheJSON") {
		Do %code.WriteLine(" Set return = ##class("_%compiledclass.Name_").%New()")
	
		Do %code.WriteLine(" Set myDecodedArray = ..Decode(JSON)")
		
		// Rip through each property of the class.. that does not start with a %
		// Insert each property into the object to return
		#dim prop As %Dictionary.CompiledProperty
		For i = 1:1:%compiledclass.Properties.Count() {
	        Set prop = %compiledclass.Properties.GetAt(i)
	        set propName=prop.Name
	        set propNameNode=propName
	        set tmppropName=prop.Parameters.GetAt("XMLNAME")
	        set:tmppropName'="" propNameNode=tmppropName
	        IF ($EXTRACT(propName) '= "%") {
		        set propType=prop.Type
		        set propTypeClass="" if propType'="" set propTypeClass=##class(%Dictionary.CompiledClass).%OpenId(propType)
		        set isOBJ=0 if $isobject(propTypeClass),propTypeClass.ClassType'="datatype" set isOBJ=1
		        //Do %code.WriteLine(" Do array.SetAt(.."_prop_","""_prop_""")")
		        if (isOBJ) {
			        Do %code.Write(" set strJSON = ..Encode(myDecodedArray.GetAt("""_propNameNode_"""))")
			        Do %code.WriteLine(" // As "_propType_" (class)")
			        Do %code.WriteLine(" Set return."_propName_" = ##class("_propType_").GetObjectFromJSON(strJSON)")
		        }
		        else {
			        Do %code.Write(" Set return."_propName_" = myDecodedArray.GetAt("""_propNameNode_""")")
			        Do %code.WriteLine(" // As "_propType_" (datatype)")
		        }
	        }
	    }
	    
		Do %code.WriteLine(" Quit return")
	}
}

/// 把JSON转换为对象(支持属性集合).
/// objClass:对象实例,必须继承%RegisteredObject,不必继承本类.
/// inJson:JSON字符串或已经转换为Array的JSON
/// 和GetObjectFromJSON是相同功能.
/// 		s tmpObj=##class(User.test).%New()
/// 		d ##class(web.INSUCacheJSON).RtnObjectFromJSON(.tmpObj,jsonString) ;JSON转对象
/// 		或s newObj2=##class(web.INSUCacheJSON).RtnObjectFromJSON(tmpObj,jsonString) 
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
			s keynode=key
			s tmpkeynode=$$$comMemberArrayGet(ClassName,$$$cCLASSproperty,key,"P","XMLNAME")
			s:tmpkeynode'="" keynode=tmpkeynode
			s (tmptype,subclass)=""
			i $$$defMemberKeyDefined(ClassName,$$$cCLASSproperty,key,27) {
				s tmptype=$$$defMemberKeyGet(ClassName,$$$cCLASSproperty,key,27)
				s subclass=$$$defMemberKeyGet(ClassName,$$$cCLASSproperty,key,5)
				s subar=myDecodedArray.GetAt(keynode)
				s jsobj=##class(%ArrayOfDataTypes).%New()
				s tmpsubclassobj=""
				s subkey=key
				i $IsObject(subar)=0 {
					s $ZObjProperty(rtnobj,key)=subar
				}else{
					f i=1:1:subar.Count() d
					.s jsobj=subar.GetAt(i)
					.s tmpvn="##class("_subclass_").%New()"
					.Set tmpsubclassobj=$$XECUTEN^INSUFUN(tmpvn)
					.//XECUTE ("Set tmpsubclassobj=##class("_subclass_").%New()")
					.s tmpsubclassobj=..RtnObjectFromJSON(tmpsubclassobj,jsobj)
					.s stas=$$XECUTENN^INSUFUN(.rtnobj,subkey,tmpsubclassobj)
					
				}
			}else{
				s subclass=""
				s jsobj=myDecodedArray.GetAt(keynode)
				i $$$defMemberKeyDefined(ClassName,$$$cCLASSproperty,key,5) {
					s subclass=$$$defMemberKeyGet(ClassName,$$$cCLASSproperty,key,5)
					i $e(subclass,1)="%"{
						s $ZObjProperty(rtnobj,key)=jsobj
					}else{
						s tmpvn="##class("_subclass_").%New()"
						Set tmpsubclassobj=$$XECUTEN^INSUFUN(tmpvn)
						s tmpsubclassobj=..RtnObjectFromJSON(tmpsubclassobj,jsobj)
						s $ZObjProperty(rtnobj,key)=tmpsubclassobj
					}
				}else{
					s $ZObjProperty(rtnobj,key)=jsobj
				}
			}
		}
		q rtnobj
	}
	else{q objClass}
}

/// Returns an OREF populated with the values from the JSON
ClassMethod SetObjectFromJSON(JSON As %String) As %RegisteredObject [ CodeMode = objectgenerator ]
{
	d %code.WriteLine(" d ..SetObjectFromArray(..Decode(JSON))")
}

ClassMethod SetObjectFromArray(myArray) As %RegisteredObject [ CodeMode = objectgenerator ]
{
	// Permet de gérer l'id et donc la création/modification des objets
	d %code.WriteLine(" s OID = myArray.GetAt(""id"")")
	d %code.WriteLine(" if (OID=0) { s obj = ##class("_%compiledclass.Name_").%New() }")
	d %code.WriteLine(" else { s obj = ##class("_%compiledclass.Name_").%OpenId(OID) }")
	
	for i=1:1:%compiledclass.Properties.Count()
	{
		s property = %compiledclass.Properties.GetAt(i)
		
		if ($EXTRACT(property.Name) '= "%")
		{
			// %Library.Date
			if (property.Type = "%Library.Date") {
				d %code.WriteLine(" s dateString = myArray.GetAt("""_property.Name_""")")
				d %code.WriteLine(" s formatedDate = $Case(dateString, """":"""", :$zdh(dateString, 3,,,,,,,""""))")
				d %code.WriteLine(" s obj."_property.Name_" = formatedDate")
			}
			
			// %Library.GlobalBinaryStream
			elseif (property.Type = "%Library.GlobalBinaryStream") {
				d %code.WriteLine(" s val = myArray.GetAt("""_property.Name_""")")
				d %code.WriteLine(" if $IsObject(val) { d obj."_property.Name_".CopyFrom(val) }")
				d %code.WriteLine(" else { d obj."_property.Name_".Write(val) }")
			}
			
			// %Library.*
			elseif ($Extract(property.Type, 1, 8) = "%Library") {
				if (property.Calculated = 0) {
					d %code.WriteLine(" s obj."_property.Name_" = myArray.GetAt("""_property.Name_""")")
				}
			}
			
			// Si c'est une relation complexe
			elseif (property.Collection="array") {
				d %code.WriteLine(" d obj."_property.Name_".Clear()")
				d %code.WriteLine(" s list = myDecodedArray.GetAt("""_property.Name_""")")
				d %code.WriteLine(" for i=1:1:list.Count() { ")
				d %code.WriteLine(" 	s child = $ZObjClassMethod("""_property.Type_""", ""SetObjectFromArray"",  list.GetAt(i))")
				d %code.WriteLine(" 	d obj."_property.Name_".Insert(child)")
				d %code.WriteLine(" }")
			}
			
			// Si c'est object simple
			else {
				d %code.WriteLine(" d obj."_property.Name_"SetObjectId(myArray.GetAt("""_property.Name_"""))")
			}
		}
	}
	   
	d %code.WriteLine(" q obj")
}

}
