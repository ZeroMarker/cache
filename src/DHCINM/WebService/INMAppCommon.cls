/// Creator:
/// Desctiptions:移动护管公共方法类
/// Date:
Class DHCINM.WebService.INMAppCommon Extends %RegisteredObject
{

Parameter EscapeChar As COSEXPRESSION = "$LB($LB(""\"",""\\""),$LB($C(13),""\n""),$LB($C(10),""\r""),$LB($C(9),""\t""),$LB("""""""",""\""""""),$LB($C(8),""\b""),$LB($C(12),""\f""))";

Parameter UnEscapeChar As COSEXPRESSION = "$LB(""\\"",""\n"",""\r"",""\t"",""\"""""",""\b"",""\f"")";

Parameter JSonSlice [ Final, Internal ] = 1;

Parameter JSonInString [ Final, Internal ] = 2;

Parameter JSonInArray [ Final, Internal ] = 3;

Parameter JSonInObject [ Final, Internal ] = 4;

/// Creator:
/// Description:信息转为json格式
/// Date:
/// Table: 
/// Input:
/// Output：
/// Return:
/// Others:
ClassMethod ReturnMsgJson(msg As %String, msgcode As %String) As %GlobalCharacterStream
{
	s json=##class(%ArrayOfDataTypes).%New()
	i $CLASSNAME(msg)["OfDataTypes" {
		d json.SetAt("Success","msg")
		d json.SetAt("1","msgcode")
		d json.SetAt($g(msg),"data")
	}else {
	d json.SetAt($g(msg),"msg")
	d json.SetAt($g(msgcode),"msgcode")
	}
	s dataStream=##class(%GlobalCharacterStream).%New()
	d ..EncodeByStream(json,.dataStream)	
	q dataStream
}

/// Creator:fengliang 
/// Description:将数据转换成流
/// Date:2021-03-22
/// Table: 
/// Input:
/// Output：
/// Return:
/// Others:
ClassMethod DataToStream(data) As %GlobalCharacterStream
{
#;	i '$IsObject(data) s dataObj = ..Decode(data)
#;	e  s dataObj=data
#;	s dataStream=##class(%GlobalCharacterStream).%New()
#;	d ##class(Nur.MNIS.Common.JSON).EncodeByStream(dataObj,.dataStream)	
#;	q dataStream
}

/// Creator:lmm
/// Description:转成数据流输出
/// Date:2018.12.16
/// Table: 
/// Input:
/// Output：
/// Return:
/// Others:	
ClassMethod EncodeByStream(data As %DataType, datastream As %Stream) As %Stream
{
	
  if $IsObject(data) 
  {  
    s key=""
   
    s typeData=data.%ClassName()

    if typeData="%ArrayOfDataTypes" {
      //type object
      s key=""
      d datastream.Write("{") 
      s i=0
      F {
	      	s i=i+1
	        s pData=data.GetNext(.key)
	        q:key=""
	        i i'=1 d datastream.Write(",")
	        d datastream.Write(""""_..Escape(key)_""":")  
	        d ..EncodeByStream(pData,.datastream)
      } 
      d datastream.Write("}") 
      q ""
    }elseif typeData="%ListOfDataTypes"{
      //type array 
      d datastream.Write("[") 
      f i=1:1:data.Count()
       {
	       
        d ..EncodeByStream(data.GetAt(i),.datastream)
        i i<data.Count() d datastream.Write(",")
      }
      d datastream.Write("]")
      q ""
    }elseif typeData="Nur.OrderStaticInfo"{
      d datastream.Write(data.GetJSONFromObject())
      q ""
    }elseif typeData="Nur.JSONOBJECT"{
      d datastream.Write(..Escape(data.Content))
      q ""
    }
  }elseif ($FIND(data,".")){
	;; This $ISVALIDNUM below is causing some %String property types that are valid numbers (ie. .1293394) to be unescaped
  	;; $ISVALIDNUM allows for periods. Need to check for a . in another elseif and escape it like a string "".

	//type string
    i data="" d datastream.Write("""""") q ""
    d datastream.Write(""""_..Escape(data)_"""")
    q ""
  }elseif $ISVALIDNUM(data){
    // type number
    //w ..Escape(data)
    //q ""
    d datastream.Write(""""_data _"""") 
    q ""
  }else{
    //type string
    i data="" d datastream.Write("""""")  q ""
    d datastream.Write(""""_..Escape(data)_"""") 
    q ""
  }
  d datastream.Write("""""") 
  q ""
}

/// Creator:
/// Description:json字符串转dataType类型
/// Date:
/// Table: 
/// Input:
/// Output：
/// Return:
/// Others:	
ClassMethod Decode(str As %String) As %ArrayOfDataTypes
{
  #dim stack as %ListOfDataTypes
  s matchType=$ZCVT(str,"L")
 
  q:(matchType="true") "1"
  q:(matchType="false") "0"
  q:(matchType="null") ""  
  q:($ISVALIDNUM(matchType)) matchType 
  q:str?1"""".E1"""" ..Unescape($e(str,2,$l(str)-1))
  //..Replace($e(str,2,$l(str)-1),"\""","""")
 
  // array or object notation
  s match=str?1(1"[".E1"]",1"{".E1"}")
  s stack=##class(%ListOfDataTypes).%New()
 
  if match 
  {
    if $E(str,1)="[" 
    {
      d stack.Insert(..#JSonInArray)
      s arr=##class(%ListOfDataTypes).%New()
    }  
    else 
    {
      d stack.Insert(..#JSonInObject) 
      s obj=##class(%ArrayOfDataTypes).%New()
    }
   
    d stack.Insert(..SetAux(..#JSonSlice,1,"false"))
   
    s chars=$E(str,2,$L(str)-1)
   
    if chars="" 
    {
      if stack.GetAt(1)=..#JSonInArray 
      {
        q arr
      }
      else
       {
        q obj
      }  
    }

    s strlenChars=$L(chars)+1

    s escaped=0
    For c=1:1:strlenChars
     {
      s last=stack.Count()
      s top=stack.GetAt(last)
     
      s:(escaped=2) escaped=0
      s:(escaped=1) escaped=2
     
      s substrC2=$E(chars,c-1,c)
      if ($E(chars,c,c)="\")&&(escaped=0) s escaped=1
      
      if $e(chars,c)="" {
        s a=22
      }
     
      if (c=strlenChars || ($E(chars,c)=",")) && (top.GetAt("what")=..#JSonSlice){
        // found a comma that is not inside a string, array, etc.,
        // OR we've reached the end of the character list
        s slice = $E(chars, top.GetAt("where"),c-1)
        d stack.Insert(..SetAux(..#JSonSlice,c+1,"false"))
        if stack.GetAt(1)=..#JSonInArray{
          // we are in an array, so just push an element onto the stack
          d arr.Insert(..Decode(slice)) 
        }elseif stack.GetAt(1)=..#JSonInObject{
          // we are in an object, so figure
          // out the property name and set an
          // element in an associative array,
          // for now 
                   
          s match=slice?." "1""""1.E1""""." "1":"1.E
          if match
           {
            //'name':value par
            s key1=$p(slice,":")
            s key=..Decode(key1)
            s val=..Decode($P(slice,":",2,$l(slice,":"))) 
            d obj.SetAt(val, key)       
          }
        }
      }elseif $E(chars,c)="""" && (top.GetAt("what")'=..#JSonInString){
        // found a quote, and we are not inside a string
        d stack.Insert(..SetAux(..#JSonInString,c,$E(chars,c)))
      }elseif $E(chars,c)=top.GetAt("delim") && (top.GetAt("what")=..#JSonInString) && (escaped=0){
        // found a quote, we're in a string, and it's not escaped (look 3 charachters behind, to see the \" is not \\" )
        s last=stack.Count()
        s st=stack.RemoveAt(last)
      }elseif ($E(chars,c)="[") && (top.GetAt("what")'=..#JSonInString) && ($CASE(top.GetAt("what"),..#JSonInString:1,..#JSonInArray:1,..#JSonSlice:1,:0)){ 
        // found a left-bracket, and we are in an array, object, or slice
        d stack.Insert(..SetAux(..#JSonInArray,c,"false"))
      }elseif $E(chars,c)="]" && (top.GetAt("what")=..#JSonInArray){
        // found a right-bracket, and we're in an array
        s last=stack.Count()
        s st=stack.RemoveAt(last) 
      }elseif $E(chars,c)="{" && ($CASE(top.GetAt("what"),..#JSonSlice:1,..#JSonInArray:1,..#JSonInObject:1,:0)) 
      {
        // found a left-brace, and we are in an array, object, or slice
        d stack.Insert(..SetAux(..#JSonInObject,c,"false"))
      }elseif $E(chars,c)="}" && (top.GetAt("what")=..#JSonInObject){
        // found a right-brace, and we're in an object 
        s last=stack.Count()
        s st=stack.RemoveAt(last) 
      }
     
    }  
   
    if stack.GetAt(1)=..#JSonInObject{
      q obj
    }elseif stack.GetAt(1)=..#JSonInArray {
      q arr
    }
  }
  q str
}

/// Creator:
/// Description:将DataType格式数据编码为json格式
/// Date:
/// Table: 
/// Input:
/// Output：
/// Return:
/// Others:
ClassMethod Encode(data As %DataType) As %String
{

  if $IsObject(data) 
  {  
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
    }elseif typeData="%ListOfDataTypes"{
      //type array 
      s cad=""
      f i=1:1:data.Count(){
        s tmp=..Encode(data.GetAt(i))
        s cad=$S(i>1:cad_",",1:"")_tmp
      }
      s cad="["_cad_"]"
      q cad
    }elseif typeData="Nur.OrderStaticInfo"{ //此种方法未用
      q data.GetJSONFromObject()
    } elseif typeData="Nur.JSONOBJECT"{
    	q ..Escape(data.Content)
    }
  }elseif ($FIND(data,".")){ //此后两种方法未用
	;; This $ISVALIDNUM below is causing some %String property types that are valid numbers (ie. .1293394) to be unescaped
  	;; $ISVALIDNUM allows for periods. Need to check for a . in another elseif and escape it like a string "".

	//type string
    q:data="" """"""
    q """"_..Escape(data)_""""
  }elseif $ISVALIDNUM(data){
    // type number
    q """"_data _""""
  }else{
    //type string
    q:data="" """"""
    q """"_..Escape(data)_""""
  }
  q """"""
}

/// Creator:
/// Description:替换字符串中得特殊字符
/// Date:
/// Table: 
/// Input:
/// Output：
/// Return:
/// Others:
ClassMethod Replace(str, char, replaceChar)
{
	s tmpStr=""
	s n=$l(str,char)
	f i=1:1:n
	{
		i i'=1 s tmpStr=tmpStr_replaceChar
		s nodeStr=$p(str,char,i)
		s tmpStr=tmpStr_nodeStr
	} 
	q tmpStr
}

/// Creator:
/// Description:替换字符串中的特殊字符为htmljson可解析字符
/// Date:
/// Table: 
/// Input:
/// Output：
/// Return:
/// Others:
ClassMethod Escape(str As %String) As %String [ Internal ]
{

  for tI=1:1:$LL(..#EscapeChar) 
  { 
  
    Set tCharPair=$LG(..#EscapeChar,tI)
    Set str=..Replace(str,$LG(tCharPair,1),$LG(tCharPair,2))
  }
  Quit str
}

/// Creator:
/// Description:界面字符转为m中特殊符号
/// Date:
/// Table: 
/// Input:
/// Output：
/// Return:
/// Others:
ClassMethod Unescape(str As %String) As %String [ Internal ]
{
  For tI=1:1:$Length(str)
  {
    Set tChar=$ListFind(..#UnEscapeChar,$E(str,tI,tI+1))
    if (tChar>0)
    {
      Set $E(str,tI,tI+1)=$LG($LG(..#EscapeChar,tChar),1)
    }
  }
  Quit str
}

ClassMethod SetAux(what As %String, where As %Integer, delim As %String) As %DataType [ Internal ]
{
  s aux=##class(%ArrayOfDataTypes).%New() 
  d aux.SetAt(what,"what")
  d aux.SetAt(where,"where") 
  d aux.SetAt(delim,"delim")
 
  q aux
}

/// creator:
/// createdate:
/// input:数组
/// output:json格式字符串
/// description: 数组转json格式字符串
/// other:w ##class(web.INMVueComm).StrToJson(.tmp)
ClassMethod ArrayToJson(tmp As %String) As %GlobalCharacterStream
{
	s json=""
	s key="" f  s key=$o(tmp(key)) q:key=""  d
	.s val=tmp(key)
	.i json'="" s json=json_","
	.s json=json_""""_key_""":"""_val_""""
	s dataStream=##class(%GlobalCharacterStream).%New()
	d dataStream.Write("{")
	d dataStream.Write("""msg"":"""",""msgcode"":""1"",""data"":")
	d dataStream.Write("{"_json_"}")
	d dataStream.Write("}") 
	q dataStream
}

/// creator:
/// createdate:
/// input:"TableTitle|人力资源列表^TableCode|DHCNurPersons^TableMenu|..."
/// output:0 失败 10 成功
/// description: 解析字符串
/// other: ##class(DHCINM.WebService.INMAppUtilComm).SplitStr("A|a^B|b^C|c","^","|",.tmp)
ClassMethod SplitStr2(parr As %String, s1 As %String, s2 As %String, tmp As %String) As %String
{
	q:parr="" 0
	k tmp
	s len=$L(parr,s1)
	f i=1:1:len
	{
		s item=$P(parr,s1,i)
		continue:item=""
		s key=$P(item,s2,1)
		continue:key=""
		s val=$P(item,s2,2,$L(item,s2))
 		s tmp(key)=val
	}
	q $d(tmp)
}

/// creator:
/// createdate:
/// input:字符串
/// output:json格式字符串
/// description: 字符串转json格式字符串
/// other:w ##class(web.INMVueComm).StrToJson("a|1^b|2^c|3^d|4")
ClassMethod StrToJson(str, s1 As %String = "^", s2 As %String = "|") As %GlobalCharacterStream
{
	if str'["|"{
		q ..ReturnMsgJson(str,"-1")	
	}
	s json=""
	k tmp
	s tmp=""
	d ..SplitStr2(str,s1,s2,.tmp)
	q ..ArrayToJson(.tmp)
}

}
