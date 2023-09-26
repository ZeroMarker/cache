/// Creator: Huxiaotian
/// Description: 提供 对象转字符串 & 字符串转对象 的方法
/// Others: 
/// 	(1)该类依赖于web.DHCST.Object和web.DHCST.Array
/// 	(2)本类主要提供方法:
/// 	##class(web.DHCST.JSONUtils).ObjWriteAsJSON(OBJ)
/// 	##class(web.DHCST.JSONUtils).ObjToJSON(OBJ)
/// 	##class(web.DHCST.JSONUtils).FromJSON(jsonStr)
/// 	obj.Insert() - obj.ToJSON()- obj.WriteJSON()
/// 	##class(web.DHCST.JSONUtils).RsToJSON()
/// 	##class(web.DHCST.JSONUtils).RsWriteJSON()
/// 	##class(web.DHCST.JSONUtils).EmptyJSON()
/// 	##class(web.DHCST.JSONUtils).WriteEmptyJSON()
/// 	##class(web.DHCST.JSONUtils).TipsJSON()
/// 	##class(web.DHCST.JSONUtils).WriteTipsJSON()
/// 	##class(web.DHCST.JSONUtils).ReplaceSpecialChar()
Class web.DHCST.JSONUtils Extends %RegisteredObject
{

/// 字符串转对象变量
Property JsonStream As %Stream.GlobalCharacter;

Property Char As %String;

Property CharS As %String;

Property SubStr As %String;

/// 数据缓存数组
Property %TempData As %String [ MultiDimensional ];

Property %CurrentDataID As %Integer [ InitialExpression = 0 ];

/// 判断数字的正则表达式
Parameter NUMREGSTR = "^(0)|([-]?(0\.|[1-9]{1}[0-9]*\.?)[0-9]*)$";

/// ============================================================================= ///
/// ==============================对象转JSON字符串=============================== ///
/// ============================================================================= ///
/// Creator: Huxiaotian
/// Date: 2018-12-03
/// Desc: 把集合转换成json输出
/// Input: OBJ - Array OR List OR String
/// Output: Write json
/// w ##class(web.DHCST.JSONUtils).ObjWriteAsJSON()
ClassMethod ObjWriteAsJSON(OBJ, jsonFirstFlag As %String = "")
{
	if jsonFirstFlag="" {
		set jsonFirst = 1
	} else {
		set jsonFirst = jsonFirstFlag // 0 or 1
	}
	set $ZT="WRITEJSONERR"
	if $IsObject(OBJ) {
		// {}
		if OBJ.%IsA("web.DHCST.Object") {
			if jsonFirst=1 {
				Write "{"
			} else {
				Write ",{"
			}
			set jsonChlFirst=1
			set jsonKey=$o(OBJ.%data(""))
			while(jsonKey'=""){
				//set jsonKey = OBJ.Next(jsonKey)
				set jsonVal = OBJ.%data(jsonKey)
				if jsonChlFirst=1 {
					Write $c(34)_jsonKey_$c(34)_":"
					set jsonChlFirst = 0
				}else{
					Write ","_$c(34)_jsonKey_$c(34)_":"
				}
				if $IsObject(jsonVal) {
					do ..ObjWriteAsJSON(jsonVal,1) // recursive method
				} else {
					set jsonVal = ..ReplaceSpecialChar(jsonVal)
					Write $c(34)_jsonVal_$c(34)
				}
				set jsonKey=$o(OBJ.%data(jsonKey)) //get next key
			}
			Write "}"
		}
		// []
		if OBJ.%IsA("web.DHCST.Array") {
			if jsonFirst=1 {
				 Write "["
			} else {
				 Write ",["
			}
			set jsonChlFirst=1
			set jsonObjCount = OBJ.Count()
			for jsonObjn=1:1:jsonObjCount {
				set jsonVal = OBJ.GetAt(jsonObjn)
				if $IsObject(jsonVal) {
					if jsonChlFirst=1 {
						do ..ObjWriteAsJSON(jsonVal,1) // recursive method
						set jsonChlFirst = 0
					} else {
						do ..ObjWriteAsJSON(jsonVal,0) // recursive method
					}
				} else {
					set jsonVal = ..ReplaceSpecialChar(jsonVal)
					if jsonChlFirst=1 {
						Write $c(34)_jsonVal_$c(34)
						set jsonChlFirst = 0
					} else {
						Write ","_$c(34)_jsonVal_$c(34)
					}
				}
			}
			Write "]"
		}
	} else {
		//string
		set OBJ = ..ReplaceSpecialChar(OBJ)
		Write "["_$c(34)_OBJ_$c(34)_"]"
	}
	quit
	
WRITEJSONERR
	set $ZT=""
	quit $ZE
}

/// Creator: Huxiaotian
/// Date: 2018-12-03
/// Desc: 把集合转换成json字符串, 使用递归调用实现集合中的数据深度解析
/// Input: OBJ - Array OR List OR String
/// Output: json string
/// Others: 
/// w ##class(web.DHCST.JSONUtils).ObjToJSON()
ClassMethod ObjToJSON(OBJ, jsonFirstFlag As %String = "", jsonStream As %Stream.GlobalCharacter = "") As %String
{
	if jsonFirstFlag="" {
		set jsonFirst = 1
		set jsonStream = ##class(%Stream.GlobalCharacter).%New()
	} else {
		set jsonFirst = jsonFirstFlag // 0 or 1
	}
	set $ZT="TOJSONERR"
	if $IsObject(OBJ){
		// {}
		if OBJ.%IsA("web.DHCST.Object") {
			if jsonFirst=1 {
				do jsonStream.Write("{")
			} else {
				do jsonStream.Write(",{")
			}
			set jsonChlFirst=1
			set jsonKey=$o(OBJ.%data(""))
			while(jsonKey'=""){
				//set jsonKey = OBJ.Next(jsonKey)
				set jsonVal = OBJ.%data(jsonKey)
				if jsonChlFirst=1 {
					do jsonStream.Write($c(34)_jsonKey_$c(34)_":")
					set jsonChlFirst = 0
				}else{
					do jsonStream.Write(","_$c(34)_jsonKey_$c(34)_":")
				}
				if $IsObject(jsonVal) {
					do ..ObjToJSON(jsonVal,1,jsonStream) // recursive method
				} else {
					set jsonVal = ..ReplaceSpecialChar(jsonVal)
					do jsonStream.Write($c(34)_jsonVal_$c(34))
				}
				set jsonKey=$o(OBJ.%data(jsonKey)) //get next key
			}
			do jsonStream.Write("}")
		}
		//[]
		if OBJ.%IsA("web.DHCST.Array") {
			if jsonFirst=1 {
				do jsonStream.Write("[")
			} else {
				do jsonStream.Write(",[")
			}
			set jsonChlFirst=1
			set jsonObjCount = OBJ.Count()
			for jsonObjn=1:1:jsonObjCount {
				set jsonVal = OBJ.GetAt(jsonObjn)
				if $IsObject(jsonVal) {
					if jsonChlFirst=1 {
						do ..ObjToJSON(jsonVal,1,jsonStream) // recursive method
						set jsonChlFirst = 0
					} else {
						do ..ObjToJSON(jsonVal,0,jsonStream) // recursive method
					}
				} else {
					set jsonVal = ..ReplaceSpecialChar(jsonVal)
					if jsonChlFirst=1 {
						do jsonStream.Write($c(34)_jsonVal_$c(34))
						set jsonChlFirst = 0
					} else {
						do jsonStream.Write(","_$c(34)_jsonVal_$c(34))
					}
				}
			}
			do jsonStream.Write("]")
		}
	} else {
		//string
		set OBJ = ..ReplaceSpecialChar(OBJ)
		do jsonStream.Write("["_$c(34)_OBJ_$c(34)_"]")
	}
	//read stream as string and return------
	set returnJsonStr = ""
	if jsonFirstFlag="" {
		do jsonStream.Rewind()
		while('jsonStream.AtEnd){
			set returnJsonStr = returnJsonStr_jsonStream.Read()
		}
		//jsonStream.%Clear()
	}
	quit returnJsonStr
	
TOJSONERR
	set $ZT=""
	quit $ZE
}

/// ============================================================================= ///
/// ==============================JSON字符串转对象=============================== ///
/// ============================================================================= ///
/// Creator: Huxiaotian 2019-10-22
/// Desc: 把json字符串转成对象,方便取值
/// Output: 由web.DHCST.Array和web.DHCST.Object嵌套组成的对象
/// Others: 以下为了方便访问对象属性采用Method而非ClassMethod, 调用之前应该先%New()
/// Reference: EMRservice.Parser.Json.cls
/// w ##class(web.DHCST.JSONUtils).FromJSON()
Method FromJSON(jsonStr)
{
	Do ..JsonStream.Write(jsonStr)
	Set json = ""
	Do ..ReadSubStr()
    If (..Char="{"){
	    Set json = ..GetObject()
	} ElseIf (..Char = "[") {
		Set json = ..GetArray()
	} Else {
		Set json = ""
	}
	Quit json
}

/// Creator: Huxiaotian 
/// Date: 2019-10-12
/// Desc: 读取JSON字符串中引号中的一段内容,存放在..SubStr中
Method ReadSubStr() [ Private ]
{
	set ..Char = ""
	set ..CharS = ""
	set ..SubStr = ""
	set ReadEnd = 0
	while (ReadEnd=0)&&('..JsonStream.AtEnd) {
		set ..Char = ..JsonStream.Read(1)
		continue:..Char=""
		continue:(..CharS'="""")&(..Char=" ")
		set:(..CharS'="""")&("{[:,]}"[..Char) ReadEnd=1
		quit:(..CharS'="""")&("{[:,]}"[..Char)
		continue:(..CharS="""""")
		if ..Char="""" {
			if ..CharS="" {
				set ..CharS = ..Char
			} elseif ..CharS="""" {
				if $e(..SubStr,*)="\" {
					set ..SubStr = ..SubStr_..Char
				} else {
					set ..CharS = """"""
				}
			}
		} else {
			set ..SubStr = ..SubStr_..Char
		}
	}
	q ""
}

Method GetObject() [ Private ]
{
	set jsonObj = ##Class(web.DHCST.Object).%New()
	while '..JsonStream.AtEnd {
		do ..ReadSubStr()
		set key="",val=""
		set key = ..GetKey()
		if (..Char=":"){
			do ..ReadSubStr()
			set val = ..GetVal()
		}
		if (key'=""){
			do jsonObj.Set(key, val)
		}
		continue:..Char=","
		quit:..Char="}"
		quit
    }
    quit jsonObj
}

Method GetArray() [ Private ]
{
	set jsonArr = ##Class(web.DHCST.Array).%New()
	while '..JsonStream.AtEnd {
		do ..ReadSubStr()
		set val = ..GetVal()
		if val'="" {
			do jsonArr.Insert(val)
		}
		continue:..Char=","
		quit:..Char="]"
		quit
	}
	quit jsonArr
}

Method GetKey() [ Private ]
{
	quit ..ReplaceCahr(..SubStr)
}

Method GetVal() [ Private ]
{
	if ..Char="{" {
		set val = ..GetObject()
		do ..ReadSubStr()
	} elseif ..Char="[" {
		set val = ..GetArray()
		do ..ReadSubStr()
	} else {
		set val = ..ReplaceCahr(..SubStr)
	}
	quit val
}

Method ReplaceCahr(instr) [ Private ]
{
	set instr = $replace(instr, "\u0000", $c(0))
	set instr = $replace(instr, "\u0001", $c(1))
	set instr = $replace(instr, "\u0002", $c(2))
	set instr = $replace(instr, "\u0003", $c(3))
	set instr = $replace(instr, "\u0004", $c(4))
	set instr = $replace(instr, "\u0005", $c(5))
	set instr = $replace(instr, "\u0006", $c(6))
	set instr = $replace(instr, "\u0007", $c(7))
	set instr = $replace(instr, "\b", $c(8))
	set instr = $replace(instr, "\t", $c(9))
	set instr = $replace(instr, "\n", $c(10))
	set instr = $replace(instr, "\u000b", $c(11))
	set instr = $replace(instr, "\f", $c(12))
	set instr = $replace(instr, "\r", $c(13))
	set instr = $replace(instr, "\u000e", $c(14))
	set instr = $replace(instr, "\u000f", $c(15))
	set instr = $replace(instr, "\u0010", $c(16))
	set instr = $replace(instr, "\u0011", $c(17))
	set instr = $replace(instr, "\u0012", $c(18))
	set instr = $replace(instr, "\u0013", $c(19))
	set instr = $replace(instr, "\u0014", $c(20))
	set instr = $replace(instr, "\u0015", $c(21))
	set instr = $replace(instr, "\u0016", $c(22))
	set instr = $replace(instr, "\u0017", $c(23))
	set instr = $replace(instr, "\u0018", $c(24))
	set instr = $replace(instr, "\u0019", $c(25))
	set instr = $replace(instr, "\u001a", $c(26))
	set instr = $replace(instr, "\u001b", $c(27))
	set instr = $replace(instr, "\u001c", $c(28))
	set instr = $replace(instr, "\u001d", $c(29))
	set instr = $replace(instr, "\u001e", $c(30))
	set instr = $replace(instr, "\u001f", $c(31))
	set instr = $replace(instr, "\\", "\")
	set instr = $replace(instr, "\""", """")
	quit instr
}

/// ============================================================================= ///
/// ===============================临时数据转JSON================================ ///
/// ============================================================================= ///
/// Desc: 数据缓存到数组
Method Insert(OneData, ColVal = "", PieceStr = "")
{
	s:ColVal="" ColVal=1
	i PieceStr="" d
	.s ..%CurrentDataID = ..%CurrentDataID + 1
	.s ThisID = ..%CurrentDataID //s ThisID = $i(^||DATAID("web.DHCST.JSONUtils"))
	.s ..%TempData(ColVal,ThisID)=OneData
	e  d
	.s pieceLen = $p(PieceStr,"^")
	.i $d(..%TempData(1,ColVal)) d
	..s itPieceLen=$l(itPieceStr,"^")
	..f nPie=1:1:itPieceLen d
	...s itPiece=$p(itPieceStr,"^",nPie) //a number
	...s $p(..%TempData(1,ColVal),"^",itPiece)=+$p(..%TempData(1,ColVal),"^",itPiece)+$p(OneData,"^",itPiece)
	.e  d
	..s ..%TempData(1,ColVal)=OneData
	q 0
}

/// Desc: 返回JSON字符串
Method ToJSON(KeyTitle As %String = "", SortRule As %String = "", JsonType As %String = "", DataFrom As %String = "", DataTo As %String = "", TitleType As %Integer = 0)
{
	//set object
	s streamObj = ##class(%Stream.GlobalCharacter).%New()
	s OBJ = $this
	
	//get title info
	s KeyTitle = $replace(KeyTitle, " ", "")
	s tDelim = "^"
	i TitleType=1 s tDelim = ","
	s keyTitleLen = $l(KeyTitle, tDelim)
	k TitleTypeArr
	k KeyTitleArr
	f iPriCol=1:1:keyTitleLen d
	.s curColStr = $p(KeyTitle, tDelim, iPriCol)
	.s KeyTitleArr(iPriCol) = $p(curColStr,",",1)
	.s TitleTypeArr(iPriCol) = 0 //..TypeIsNumber($p(curColStr,",",2)) ;TODO...
	//paging data
	s:+DataFrom=0 DataFrom=0
	s:+DataTo=0 DataTo=99999
	s priPageCount=0
	//set sort rule
	i $ZCVT(SortRule,"U")="DESC" s priSortFlag=-1
	e  s priSortFlag=1
	//type of json
	i JsonType="" d streamObj.Write("[")
	i JsonType'="" d streamObj.Write("{"_$c(34)_"rows"_$c(34)_":[")
	//iterative data
	s priFirst=1
	s priSortColValue = ""
	f  s priSortColValue = $o(OBJ.%TempData(priSortColValue),priSortFlag) q:priSortColValue=""  d
	.s priCountRetItm = ""
	.f  s priCountRetItm = $o(OBJ.%TempData(priSortColValue,priCountRetItm),priSortFlag) q:priCountRetItm=""  d
	..//paging condition
	..s priPageCount = priPageCount + 1
	..q:priPageCount<DataFrom
	..q:priPageCount>DataTo
	..//write json data
	..i priFirst=1 d
	...d streamObj.Write("{")
	...s priFirst = 0
	..e  d
	...d streamObj.Write(",{")
	..s priChlFirst = 1
	..s priOneItem = OBJ.%TempData(priSortColValue,priCountRetItm)
	..f Jsoni=1:1:keyTitleLen d
	...s priTitlei = KeyTitleArr(Jsoni) //key
	...s priTitlei = $c(34)_priTitlei_$c(34)
	...s priDatai = $p(priOneItem,"^",Jsoni) //value
	...s priDatai = ..ReplaceSpecialChar(priDatai)
	...//s:(TitleTypeArr(Jsoni)=0)!(priDatai="") priDatai=$c(34)_priDatai_$c(34) ;TODO...
	...//s:'$ISVALIDNUM(priDatai) priDatai=$c(34)_priDatai_$c(34)
	...//s:'$ISVALIDDOUBLE(priDatai) priDatai=$c(34)_priDatai_$c(34) // or $Match(priDatai,reg)
	...s priDatai = $c(34)_priDatai_$c(34) ;TODO...
	...i priChlFirst=1 d
	....d streamObj.Write(priTitlei_":"_priDatai)
	....s priChlFirst = 0
	...e  d
	....d streamObj.Write(","_priTitlei_":"_priDatai)
	..d streamObj.Write("}")
	i JsonType="" d streamObj.Write("]")
	i JsonType'="" d streamObj.Write("],"_$c(34)_JsonType_$c(34)_":"_priPageCount_"}")
	//get json string
	s returnJsonStr = ""
	d streamObj.Rewind()
	while('streamObj.AtEnd){
		s returnJsonStr = returnJsonStr_streamObj.Read()
	}
	q returnJsonStr
}

/// Desc: 写出JSON字符串
Method WriteJSON(KeyTitle As %String = "", SortRule As %String = "", JsonType As %String = "", DataFrom As %String = "", DataTo As %String = "", TitleType As %Integer = 0)
{
	s OBJ = $this
	//get title info
	s KeyTitle = $replace(KeyTitle, " ", "")
	s tDelim = "^"
	i TitleType=1 s tDelim = ","
	s keyTitleLen = $l(KeyTitle, tDelim)
	k TitleTypeArr
	k KeyTitleArr
	f iPriCol=1:1:keyTitleLen d
	.s curColStr = $p(KeyTitle, tDelim, iPriCol)
	.s KeyTitleArr(iPriCol) = $p(curColStr,",",1)
	.s TitleTypeArr(iPriCol) = 0 //..TypeIsNumber($p(curColStr,",",2)) ;TODO...
	
	//paging data
	s:+DataFrom=0 DataFrom=0
	s:+DataTo=0 DataTo=99999
	s priPageCount=0
	//set sort rule
	i $ZCVT(SortRule,"U")="DESC" s priSortFlag=-1
	e  s priSortFlag=1
	//type of json
	w:JsonType="" "["
	w:JsonType'="" "{"_$c(34)_"rows"_$c(34)_":["
	//iterative data
	s priFirst=1
	s priSortColValue = ""
	f  s priSortColValue = $o(OBJ.%TempData(priSortColValue),priSortFlag) q:priSortColValue=""  d
	.s priCountRetItm = ""
	.f  s priCountRetItm = $o(OBJ.%TempData(priSortColValue,priCountRetItm),priSortFlag) q:priCountRetItm=""  d
	..//paging condition
	..s priPageCount = priPageCount + 1
	..q:priPageCount<DataFrom
	..q:priPageCount>DataTo
	..//write json data
	..i priFirst=1 d
	...w "{"
	...s priFirst = 0
	..e  d
	...w ",{"
	..s priChlFirst = 1
	..s priOneItem = OBJ.%TempData(priSortColValue,priCountRetItm)
	..f Jsoni=1:1:keyTitleLen d
	...s priTitlei = KeyTitleArr(Jsoni) //key
	...s priTitlei = $c(34)_priTitlei_$c(34)
	...s priDatai = $p(priOneItem,"^",Jsoni) //value
	...s priDatai = ..ReplaceSpecialChar(priDatai)
	...//s:(TitleTypeArr(Jsoni)=0)!(priDatai="") priDatai=$c(34)_priDatai_$c(34) ;TODO...
	...//s:'$ISVALIDNUM(priDatai) priDatai=$c(34)_priDatai_$c(34)
	...//s:'$ISVALIDDOUBLE(priDatai) priDatai=$c(34)_priDatai_$c(34) // or $Match(priDatai,reg)
	...s priDatai = $c(34)_priDatai_$c(34) ;TODO...
	...i priChlFirst=1 d
	....w priTitlei_":"_priDatai
	....s priChlFirst = 0
	...e  d
	....w ","_priTitlei_":"_priDatai
	..w "}"
	w:JsonType="" "]"
	w:JsonType'="" "],"_$c(34)_JsonType_$c(34)_":"_priPageCount_"}"
	q ""
}

/// ============================================================================= ///
/// ================================结果集转JSON================================= ///
/// ============================================================================= ///
/// Desc: 结果集转换成JSON字符串
/// w ##class(web.DHCST.JSONUtils).RsToJSON(rs, "", "total")
ClassMethod RsToJSON(RS As %ResultSet, SortInfo As %String = "", priJsonType As %String = "", priDataFrom As %String = "", priDataTo As %String = "")
{
	// 判断是否需要排序
	s isSort = 0
	s SortRule = $p(SortInfo,"#",1)
	s SortRule = $ZCVT(SortRule,"U")
	s SortCol = $p(SortInfo,"#",2)
	s SortColExist = 0
	k TitleTypeArr
	k KeyTitleArr
	s KeyTitleStr = ""
	s priColumnsCtn = RS.GetColumnCount()
	f iPriCol=1:1:priColumnsCtn {
		s KeyTitleArr(iPriCol) = RS.GetColumnName(iPriCol)
		s:SortCol=KeyTitleArr(iPriCol) SortColExist = 1
		i iPriCol=1 {
			s KeyTitleStr = KeyTitleArr(iPriCol) //_":"_..GetDataTypeByCode(RS.GetColumnType(iPriCol)) ;TODO...
		} else {
			s KeyTitleStr = KeyTitleStr_"^"_KeyTitleArr(iPriCol) //_":"_..GetDataTypeByCode(RS.GetColumnType(iPriCol)) ;TODO...
		}
		s TitleTypeArr(iPriCol) = 0 //..IsNumberByCode(RS.GetColumnType(iPriCol)) // 0 or 1 ;TODO...
	}
	i ($Match(SortRule,"^(ASC)|(DESC)$"))&(SortColExist=1) s isSort=1
	s:+priDataFrom=0 priDataFrom=0
	s:+priDataTo=0 priDataTo=99999
	
	// 不需要排序
	s returnJsonStr = ""
	i isSort=0 {
		s streamObj = ##class(%Stream.GlobalCharacter).%New()
		s priFirst = 1
		s priCountItm = 0
		i priJsonType="" d streamObj.Write("[")
		i priJsonType'="" d streamObj.Write("{"_$c(34)_"rows"_$c(34)_":[")
		while (RS.Next()) {
			s priCountItm = priCountItm+1
			continue:priCountItm<priDataFrom
			continue:priCountItm>priDataTo
			if priFirst=1 {
				d streamObj.Write("{")
				s priFirst = 0
			} else {
				d streamObj.Write(",{")
			}
			s priChlFirst = 1
			f iCurCol=1:1:priColumnsCtn {
				s jsonKey = KeyTitleArr(iCurCol)
				s jsonKey = $c(34)_jsonKey_$c(34)
				s jsonVal = RS.GetData(iCurCol)
				s jsonVal = ..ReplaceSpecialChar(jsonVal)
				//s:(TitleTypeArr(iCurCol)=0)!(jsonVal="") jsonVal=$c(34)_jsonVal_$c(34) ;TODO...
				//s:'$ISVALIDNUM(jsonVal) jsonVal = $c(34)_jsonVal_$c(34)
				//s:'$ISVALIDDOUBLE(jsonVal) jsonVal=$c(34)_jsonVal_$c(34) // or $Match(jsonVal,reg)
				s jsonVal = $c(34)_jsonVal_$c(34) ;TODO...
				if priChlFirst=1 {
					d streamObj.Write(jsonKey_":"_jsonVal)
					s priChlFirst = 0
				} else {
					d streamObj.Write(","_jsonKey_":"_jsonVal)
				}
			}
			d streamObj.Write("}")
		}
		i priJsonType="" d streamObj.Write("]")
		i priJsonType'="" d streamObj.Write("],"_$c(34)_priJsonType_$c(34)_":"_priCountItm_"}")
		d RS.Close()
		//get json string
		d streamObj.Rewind()
		while('streamObj.AtEnd){
			s returnJsonStr = returnJsonStr_streamObj.Read()
		}
	}
	q:isSort=0 returnJsonStr
	
	// 需要排序
	i isSort=1 {
		s priObj = ##class(web.DHCST.JSONUtils).%New()
		while (RS.Next()) {
			s priOneData = ""
			s priSortColVal = ""
			f iCurCol=1:1:priColumnsCtn {
				s jsonVal = RS.GetData(iCurCol)
				if iCurCol=1 {
					s priOneData = jsonVal
				} else {
					s priOneData = priOneData_"^"_jsonVal
				}
				s:KeyTitleArr(iCurCol)=SortCol priSortColVal = jsonVal
			}
			s:priSortColVal="" priSortColVal=99999
			d priObj.Insert(priOneData, priSortColVal)
		}
		d RS.Close()
		s returnJsonStr = priObj.ToJSON(KeyTitleStr, SortRule, priJsonType, priDataFrom, priDataTo)
		//s returnJsonStr = priObj.ToJSON(KeyTitleStr, SortRule, priJsonType, priDataFrom, priDataTo, 1) ;TODO...
	}
	q:isSort=1 returnJsonStr
	
	q "[]"
}

/// Desc: 结果集写出为JSON串
/// d ##class(web.DHCST.JSONUtils).RsWriteJSON(rs, "", "total")
ClassMethod RsWriteJSON(RS As %ResultSet, SortInfo As %String = "", priJsonType As %String = "", priDataFrom As %String = "", priDataTo As %String = "")
{
	// 判断是否需要排序
	s isSort = 0
	s SortRule = $p(SortInfo,"#",1)
	s SortRule = $ZCVT(SortRule,"U")
	s SortCol = $p(SortInfo,"#",2)
	s SortColExist = 0
	k TitleTypeArr
	k KeyTitleArr
	s KeyTitleStr = ""
	s priColumnsCtn = RS.GetColumnCount()
	f iPriCol=1:1:priColumnsCtn {
		s KeyTitleArr(iPriCol) = RS.GetColumnName(iPriCol)
		s:SortCol=KeyTitleArr(iPriCol) SortColExist = 1
		i iPriCol=1 {
			s KeyTitleStr = KeyTitleArr(iPriCol) //_":"_..GetDataTypeByCode(RS.GetColumnType(iPriCol)) ;TODO...
		} else {
			s KeyTitleStr = KeyTitleStr_"^"_KeyTitleArr(iPriCol) //_":"_..GetDataTypeByCode(RS.GetColumnType(iPriCol)) ;TODO...
		}
		s TitleTypeArr(iPriCol) = 0 //..IsNumberByCode(RS.GetColumnType(iPriCol)) //0 or 1 ;TODO...
	}
	i ($Match(SortRule,"^(ASC)|(DESC)$"))&(SortColExist=1) s isSort=1
	set:+priDataFrom=0 priDataFrom=0
	set:+priDataTo=0 priDataTo=99999
	
	// 不需要排序
	i isSort=0 {
		s priFirst = 1
		s priCountItm = 0
		w:priJsonType="" "["
		w:priJsonType'="" "{"_$c(34)_"rows"_$c(34)_":["
		while (RS.Next()) {
			s priCountItm = priCountItm+1
			continue:priCountItm<priDataFrom
			continue:priCountItm>priDataTo
			if priFirst=1 {
				w "{"
				s priFirst = 0
			} else {
				w ",{"
			}
			s priChlFirst = 1
			f iCurCol=1:1:priColumnsCtn {
				s jsonKey = KeyTitleArr(iCurCol)
				s jsonKey = $c(34)_jsonKey_$c(34)
				s jsonVal = RS.GetData(iCurCol)
				s jsonVal = ..ReplaceSpecialChar(jsonVal)
				//s:(TitleTypeArr(iCurCol)=0)!(jsonVal="") jsonVal=$c(34)_jsonVal_$c(34) ;TODO...
				//s:'$ISVALIDNUM(jsonVal) jsonVal = $c(34)_jsonVal_$c(34)
				//s:'$ISVALIDDOUBLE(jsonVal) jsonVal=$c(34)_jsonVal_$c(34) // or $Match(jsonVal,reg)
				s jsonVal = $c(34)_jsonVal_$c(34) ;TODO...
				if priChlFirst=1 {
					w jsonKey_":"_jsonVal
					s priChlFirst = 0
				} else {
					w ","_jsonKey_":"_jsonVal
				}
			}
			w "}"
		}
		w:priJsonType="" "]"
		w:priJsonType'="" "],"_$c(34)_priJsonType_$c(34)_":"_priCountItm_"}"
		d RS.Close()
	}
	
	// 需要排序
	i isSort=1 {
		s priObj = ##class(web.DHCST.JSONUtils).%New()
		while (RS.Next()) {
			s priOneData = ""
			s priSortColVal = ""
			f iCurCol=1:1:priColumnsCtn {
				s jsonVal = RS.GetData(iCurCol)
				if iCurCol=1 {
					s priOneData = jsonVal
				} else {
					s priOneData = priOneData_"^"_jsonVal
				}
				s:KeyTitleArr(iCurCol)=SortCol priSortColVal = jsonVal
			}
			s:priSortColVal="" priSortColVal=99999
			d priObj.Insert(priOneData, priSortColVal)
		}
		d RS.Close()
		d priObj.WriteJSON(KeyTitleStr, SortRule, priJsonType, priDataFrom, priDataTo)
		//d priObj.WriteJSON(KeyTitleStr, SortRule, priJsonType, priDataFrom, priDataTo, 1) ;TODO...
	}
	q ""
}

/// ============================================================================= ///
/// ===========================空JSON串及信息提示JSON============================ ///
/// ============================================================================= ///
/// w ##class(web.DHCST.JSONUtils).EmptyJSON()
ClassMethod EmptyJSON(jsonType = "array")
{
	Quit:jsonType="array" "[]"
	Quit:jsonType'="array" "{"_$C(34)_jsonType_$C(34)_":0"_","_$C(34)_"rows"_$C(34)_":[]}"
	Quit "[]"
}

/// d ##class(web.DHCST.JSONUtils).WriteEmptyJSON()
ClassMethod WriteEmptyJSON(jsonType = "array")
{
	Write:jsonType="array" "[]"
	Write:jsonType'="array" "{"_$C(34)_jsonType_$C(34)_":0"_","_$C(34)_"rows"_$C(34)_":[]}"
	Quit ""
}

/// w ##class(web.DHCST.JSONUtils).TipsJSON(-101)
ClassMethod TipsJSON(sc, errMsg = "")
{
	Set sc = ..ReplaceSpecialChar(sc)
	Set errMsg = ..ReplaceSpecialChar(errMsg)
	Quit "{"_$c(34)_"errCode"_$c(34)_":"_$c(34)_sc_$c(34)_","_$c(34)_"errMsg"_$c(34)_":"_$c(34)_errMsg_$c(34)_"}"
}

/// d ##class(web.DHCST.JSONUtils).WriteTipsJSON(-101)
ClassMethod WriteTipsJSON(sc, errMsg = "")
{
	Set sc = ..ReplaceSpecialChar(sc)
	Set errMsg = ..ReplaceSpecialChar(errMsg)
	Write "{"_$c(34)_"errCode"_$c(34)_":"_$c(34)_sc_$c(34)_","_$c(34)_"errMsg"_$c(34)_":"_$c(34)_errMsg_$c(34)_"}"
	//Write {"errCode":(sc),"errMsg":(errMsg)}.%ToJSON()
	Quit ""
}

/// ============================================================================= ///
/// ===============================工具类方法==================================== ///
/// Creator: Huxiaotian 2018-04-03
/// Desc: JSON特殊字符替换
/// w ##class(web.DHCST.JSONUtils).ReplaceSpecialChar()
ClassMethod ReplaceSpecialChar(rscInputStr)
{
	set rscInputStr=$replace(rscInputStr,"\","\\")  //必须放第一个
	set rscInputStr=$replace(rscInputStr,$c(0) ,"\u0000")
	set rscInputStr=$replace(rscInputStr,$c(1) ,"\u0001")
	set rscInputStr=$replace(rscInputStr,$c(2) ,"\u0002")
	set rscInputStr=$replace(rscInputStr,$c(3) ,"\u0003")
	set rscInputStr=$replace(rscInputStr,$c(4) ,"\u0004")
	set rscInputStr=$replace(rscInputStr,$c(5) ,"\u0005")
	set rscInputStr=$replace(rscInputStr,$c(6) ,"\u0006")
	set rscInputStr=$replace(rscInputStr,$c(7) ,"\u0007")
	set rscInputStr=$replace(rscInputStr,$c(8) ,"\b")
	set rscInputStr=$replace(rscInputStr,$c(9) ,"\t")
	set rscInputStr=$replace(rscInputStr,$c(10),"\n")
	set rscInputStr=$replace(rscInputStr,$c(11),"\u000b")
	set rscInputStr=$replace(rscInputStr,$c(12),"\f")
	set rscInputStr=$replace(rscInputStr,$c(13),"\r")
	set rscInputStr=$replace(rscInputStr,$c(34),"\""")
	quit rscInputStr
}

/// w ##class(web.DHCST.JSONUtils).GetDataType()
ClassMethod GetDataType(priTypeStr = "")
{
	q:priTypeStr="" 10
	s priTypeStr = $ZCVT(priTypeStr,"U")
	q:priTypeStr="%INTEGER" 5
	q:priTypeStr="%FLOAT" 3
	q:priTypeStr="%DOUBLE" 3
	q:priTypeStr="%NUMERIC" 14
	q 10
}

/// w ##class(web.DHCST.JSONUtils).GetDataTypeByCode(5)
ClassMethod GetDataTypeByCode(priTypeCode = 10)
{
	q:priTypeCode=10 "%String"
	q:priTypeCode=5 "%Integer"
	q:priTypeCode=3 "%Float"
	q:priTypeCode=3 "%Double"
	q:priTypeCode=14 "%Numeric"
	q "%String"
}

/// w ##class(web.DHCST.JSONUtils).TypeIsNumber()
ClassMethod TypeIsNumber(priTypeStr = "")
{
	q:priTypeStr="" 0
	s priTypeStr = $ZCVT(priTypeStr,"U")
	q:priTypeStr="%INTEGER" 1
	q:priTypeStr="%FLOAT" 1
	q:priTypeStr="%DOUBLE" 1
	q:priTypeStr="%NUMERIC" 1
	q 0
}

/// w ##class(web.DHCST.JSONUtils).IsNumberByCode(5)
ClassMethod IsNumberByCode(priTypeCode = 10)
{
	q:priTypeCode=10 0
	q:priTypeCode=3 1
	q:priTypeCode=5 1
	q:priTypeCode=14 1
	q 0
}

}
