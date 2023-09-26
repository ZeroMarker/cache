Class DHCWL.util.Json Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Javascript返回Json数据工具方法
/// creator：lhh
Property data As list Of %String;

Property dataArray As list Of %String;

Property title As %String;

Property propertyNum As %Integer;

Property result As %String;

Property root As %String;

Property totalNum As %Integer;

Property count As %Integer;

Property delimer As %String;

Property privor As %Integer;

/// s json=##class(DHCWL.util.Json).Json("id^name^mess")
ClassMethod Json(title, result = "result", root = "root", deli = "^") As Json
{
	;n (title,result,root, deli)
	q:title="" ""
	s json=##class(Json).%New()
	s json.title=title
	s json.propertyNum=$l(title,deli)
	s json.result=result,json.root=root,json.count=0,json.delimer=deli,json.totalNum=0,json.privor=0
	q json
}

ClassMethod FreeJson(deli = "^") As Json
{
	;n (deli)
	//q:title="" ""
	s json=##class(Json).%New()
	s json.delimer=deli
	q json
}

Method FreeInsert(objStr)
{
	;n (objStr)
	d ..data.Insert("{"_objStr_"}")
	d ..dataArray.Insert("["_objStr_"]")
	s ..count=..count+1,..totalNum=..totalNum+1
	q
}

/// d json.Insert("1^lhh^Hello")
Method Insert(objStr)
{
	;n (objStr)
	s obj="",obj2="",v2=""
	f i=1:1:..propertyNum {
		s v2=""
		s colName=$p(..title,..delimer,i)
		s v=$p(objStr,..delimer,i)
		f j=$l(v):-1:1 {
			s char=$e(v,j)
			continue:($ascii(char)=0)
			s v2=char_v2
		}
		s v=v2
		i obj'="" s obj=obj_","_colName_":"_$g(v),obj2=obj2_","_$g(v)
		e  s obj=colName_":"_$g(v),obj2=$g(v)
	}
	s obj="{"_obj_"}"
	d ..data.Insert(obj)
	d ..dataArray.Insert(obj2)
	s ..count=..count+1,..totalNum=..totalNum+1
	q
}

Method Update(inde, newValue)
{
	q:(inde<1)||(inde>..count)
	d ..data.RemoveAt(inde)
	d ..dataArray.RemoveAt(inde)
	d ..data.InsertAt(inde,newValue)
	d ..dataArray.InsertAt(inde,newValue)
}

/// s jsonStr=json.GetJson()
Method GetJson() As %String
{
	s result="{"_..result_":"_..count_",totalNum:"_..totalNum_","_..root_":["
	f i=1:1:..count-1 d
	.s result=result_..data.GetAt(i)_","
	s result=result_..data.GetAt(..count)_"]}"
	q result
}

Method GetJsonArray() As %Text
{
	s result="["
	f i=1:1:..count-1 d
	.s result=result_"["_..dataArray.GetAt(i)_"],"
	s result=result_"["_..dataArray.GetAt(..count)_"]]"
	q result
}

Method GetNextJsonArray() As %Text
{
	s ..privor=..privor+1,result=""
	i ..privor<=..count {
		s result="["_..dataArray.GetAt(..privor)_"]"
	}
	q result
}

Method GetHead() As %String
{
	s ..privor=0
	q "{"_..result_":"_..count_",totalNum:"_..totalNum_","_..root_":["
}

Method NextObj() As %String
{
	s ..privor=..privor+1
	q ..data.GetAt(..privor)
}

Method GetPrivor() As %Integer
{
	q ..privor
}

Method GetCount() As %Integer
{
	q ..count
}

Method Next() As %String
{
	s ..privor=..privor+1,result=""
	i ..privor<=..count {
		s result=..data.GetAt(..privor)
		i ..privor=..count {
			s result=result_"]}"
		}else{
			  s result=result_","
		}
	}
	q result
}

Method SetTotalNum(num As %Integer)
{
	s ..totalNum=num
	q
}

Method GetJsonBody() As %String
{
	s result="["
	f i=1:1:..count-1 d
	.s result=result_..data.GetAt(i)_","
	s result=result_..data.GetAt(..count)_"]"
	q result
}

/// 
/// Creator：王峥
/// CreatDate： 2013-8-20
/// Description：对JSON数据格式解码。
/// Table： 	无
/// Input： 
/// Output： json：json格式的数据,type：标识类型
/// Return： 
/// Others： 无
/// s json="[[arg,bas,232],[wds,2sd,wsd]]"
/// d ##CLASS(DHCWL.util.Json).JsonDecode(json)
ClassMethod JsonDecode(json As %String, type As %String) As %String
{
	n (json,type)

	k ^TEMPDHCWL($j,"type",type)
	s len=$l(json)
	s json=$e(json,2,len-1)
	s fieldCnt=0
	s len=$length(json,"]")
	for i=1:1:len d
	.s data=$p(json,"]",i)
	.s data=$p(data,"[",2)
	.b
	.i ($g(data)'="") d
	..s fieldCnt=fieldCnt+1
	..s ^TEMPDHCWL($j,"type",type,fieldCnt)=data
	q
}

ClassMethod buildCollectFromJsonStr(ByRef strJsonData) As %RegisteredObject
{
	n (strJsonData)
	s strJsonData=##class(DHCWL.util.StringUtil).Trim(strJsonData)
	q:$l(strJsonData)=0 "null"
	s firstStr=$e(strJsonData,1)
	s getValAct=""
	
	//b
	i ((firstStr="{")||(firstStr="[")) {
		s syStack=##class(DHCWL.util.Stack).%New()
		d syStack.Push(firstStr)
		i firstStr="{" {
			s collectObj=##class(%ArrayOfDataTypes).%New()
			s collectType="Array"
		}elseif (firstStr="[") {
			s collectObj=##class(%ListOfObjects).%New()
			s collectType="List"
		}
		s strJsonData=$e(strJsonData,2,*)
		s strJsonData=##class(DHCWL.util.StringUtil).Trim(strJsonData)
		s getValAct="getKey"
	}
	s curCharInx=0
	f {
		s strJsonData=$e(strJsonData,curCharInx,*)
		q:$g(strJsonData)=""
		s curCharInx=1
		s strJsonData=##class(DHCWL.util.StringUtil).Trim(strJsonData)
		
		s curChar=$e(strJsonData,1)
		if ((curChar="}")||(curChar="]")) {
			s stackData=syStack.Peek()
			if ((stackData="{")&&(curChar="}")) {
				s strJsonData=$e(strJsonData,2,*)
				d syStack.Pop()
				q
			}
			if ((stackData="[")&&(curChar="]")) {
				s strJsonData=$e(strJsonData,2,*)
				d syStack.Pop()
				q
			}

		}
		
		if ((curChar=",")) {
			s curCharInx=curCharInx+1
			s getValAct="getKey"
			continue
		}
		if ((curChar=":")) {
			s curCharInx=curCharInx+1
			s getValAct="getValue"
			continue
		}			
		i ((curChar="{")||(curChar="[")) {
			s jsonValueObj=..buildCollectFromJsonStr(.strJsonData)
			//s stackData=syStack.Peek()
			if collectType="Array" {
			//if stackData="{" {
				d collectObj.SetAt(jsonValueObj,jsonKey)			
			}
			if collectType="List" {
			//if stackData="[" {	
				d collectObj.Insert(jsonValueObj)			
			}
		}else{
			if getValAct="getValue" {
				s jsonValue=..getJsonValue(strJsonData,.occupyCharCnt)
				s simpleObj=##class(%ArrayOfDataTypes).%New()
				d simpleObj.SetAt(jsonValue,jsonKey)
				d collectObj.SetAt(simpleObj,jsonKey)		
			}elseif getValAct="getKey" {
				s jsonKey=..getJsonKey(strJsonData,.occupyCharCnt)			}			
			s curCharInx=occupyCharCnt+1
		}
		

	}
	/*
	w !,collectObj.Count()
	//w !,collectObj.GetAt()
	s key=""
	s key=collectObj.Next(key)
	while $g(key)'="" {
		w !,key
		w !,collectObj.GetAt(key)
		s key=collectObj.Next(key)
	}
	*/
	q $g(collectObj)
}

ClassMethod getJsonKey(strJsonData As %Text, ByRef occupyCharCnt) As %String
{
	n (strJsonData,occupyCharCnt)
	s occupyCharCnt=0
	s curStr=""
	s curCharInx=0
	s syStack=##class(DHCWL.util.Stack).%New()
	s strLen=$l(strJsonData)
	f curCharInx=1:1:strLen {
		s curChar=$e(strJsonData,curCharInx)
		if curChar="""" {
			if syStack.Size()=0 {
				d syStack.Push(curChar)
			}else{
				s stData=syStack.Peek()
				if curChar=stData{
					d syStack.Pop()
				}
			}
		}
		if ((curChar=":") && (syStack.Size()=0)) {
			q
		} 
		s curStr=curStr_curChar
		s occupyCharCnt=occupyCharCnt+1
	}

	q curStr
}

ClassMethod getJsonValue(strJsonData As %Text, ByRef occupyCharCnt) As %String
{
	n (strJsonData,occupyCharCnt)
	s strJsonData=##class(DHCWL.util.StringUtil).Trim(strJsonData)
	s occupyCharCnt=0
	s curStr=""
	s curCharInx=0
	s syStack=##class(DHCWL.util.Stack).%New()
	s strLen=$l(strJsonData)
	f curCharInx=1:1:strLen {
		s curChar=$e(strJsonData,curCharInx)
		if curChar="""" {
			if syStack.Size()=0 {
				d syStack.Push(curChar)
			}else{
				s stData=syStack.Peek()
				if curChar=stData{
					d syStack.Pop()
				}
			}
		}
		if (((curChar=",") || (curChar="]") || (curChar="}") )&& (syStack.Size()=0)) {
			q
		} 
		s curStr=curStr_curChar
		s occupyCharCnt=occupyCharCnt+1
	}

	q curStr
}

}
