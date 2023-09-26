/// 名称: web.DHCExtUtil
/// 描述: 工具类
Class web.DHCExtUtil Extends %RegisteredObject
{

/// 描述: 替换字符串中的特殊字符
/// 入参：    Str,OldStr,NewStr
ClassMethod ReplaceString(Str, OldStr, NewStr) As %String
{
	set intCounter = 1
	while (1)
	{
		set tmp =$e(Str, intCounter, intCounter + $l(OldStr) - 1) 
		if (tmp = OldStr)
		{
			 set $e(Str, intCounter, intCounter + $l(OldStr) - 1) = NewStr
			 set intCounter = intCounter + $l(NewStr) - $l(OldStr)
		}
		quit:intCounter>=$l(Str)
		set intCounter = intCounter + 1
	}
	quit Str
}

/// 描述: 替换字符串中是否包含指定的字符
/// 入参：    Str,OldStr,NewStr
ClassMethod IncludeStr(Str, IndexStr) As %Boolean
{
	set startIndex=1
	if $l(Str) < $l(IndexStr)
	{
		quit 0
	}
	set rs = 0
	while (1)
	{
			s endIndex =  startIndex + $l(IndexStr) - 1
			if (endIndex > $l(Str))
			{
				quit
			}
			set tmp =$e(Str, startIndex,endIndex) 
			if (tmp = IndexStr)
			{
				s rs = 1
				quit
			}
			else
			{
				set startIndex = startIndex + 1
			}
	}
	quit rs
}

/// Description:  格式化对象为json格式
/// Input：       obj
/// Return：      json格式的字符串
ClassMethod SerializeObject(obj) As %String
{
	//n (obj)
	set ret=""
	if obj.%ClassName(1)="%Library.ListOfObjects" {
		set intCnt=obj.Count()
	 	for i=1:1:intCnt {
		 	set tmpObj=obj.GetAt(i)
		 	set ret=ret_..SerializeObject(tmpObj)
		 	//set:i<intCnt ret=ret_","_$c(13)_$c(10)
		 	set:i<intCnt ret=ret_","
		 }
		 set ret="["_ret_"]"
		}
	elseif obj.%ClassName(1)="%Collection.ListOfObj"{
		set intCnt=obj.Size
	 	for i=1:1:intCnt {
		 	set tmpObj=obj.GetAt(i)
		 	set ret=ret_..SerializeObject(tmpObj)
		 	//set:i<intCnt ret=ret_","_$c(13)_$c(10)
		 	set:i<intCnt ret=ret_","
		 }
		 set ret="["_ret_"]"
		}
	elseif obj.%ClassName(1)="%Library.ResultSet"
	{
		 set columns=obj.GetColumnCount()
		 set i=""
		 set index = 0
		 //w obj.Next(),!
		 while obj.Next()
		 {
			set rowData=""
			for i=1:1:columns
		 	{
			 	set:i>1 rowData=rowData_","
			 	set rowData=rowData_obj.GetColumnName(i)_":"
			 	set tmpData=obj.GetData(i)
			 	set tmpData=##class(web.DHCExtUtil).ReplaceString(tmpData,"'","\'")
		 		set tmpData=##class(web.DHCExtUtil).ReplaceString(tmpData,$c(13),"\n")
		 		set tmpData=##class(web.DHCExtUtil).ReplaceString(tmpData,$c(10),"\r")
			 	set rowData=rowData_"'"_tmpData_"'"
		 	}
		 	
		 	set:index>0 ret = ret_","
			set ret = ret_"{"_rowData_"}"
			set index = index +1
		 }
		 set ret="["_ret_"]"
	}
	else{
		set cdef = ##class(%Dictionary.ClassDefinition).%OpenId(obj.%ClassName(1))
		
		if cdef.Storages.Count()>0 {
			set ID=obj.%Id()
			set ret="ID:'"_ID_"',"
			}
		set intPropertyCnt=cdef.Properties.Count()
		for i=1:1:intPropertyCnt  {
			
			//set ret=ret_"," //_$c(13)_$c(10)
			set strPropertyName=cdef.Properties.GetAt(i).Name
			set strType=cdef.Properties.GetAt(i).Type
			set strValue = ##class(web.DHCExcuteScript).GetObjectValue(obj,strPropertyName,strType)
			if $IsObject(strValue) {
				set strValue=..SerializeObject(strValue)
			}
			set ret=ret_strPropertyName_":"_strValue
			set:i<intPropertyCnt ret=ret_","
			}
		set ret="{"_ret_"}"
		d cdef.%Close()
		k cdef
		}
	quit ret
}

/// 描述: 替换字符串中的引号e
/// 入参：    strQuotation：字符串
ClassMethod ReplaceQuotation(strQuotation As %String) As %String
{
	quit ##class(web.DHCExtUtil).ReplaceString(strQuotation,$c(34),"”")
}

/// 描述: 替换字符串中的特殊字符
/// 入参：    strCharacter
ClassMethod ReplaceCharacterForJS(strCharacter As %String) As %String
{
	set strCharacter=##class(web.DHCExtUtil).ReplaceString(strCharacter,"'","\'")
	set strCharacter=##class(web.DHCExtUtil).ReplaceString(strCharacter,$c(13),"\n")
	set strCharacter=##class(web.DHCExtUtil).ReplaceString(strCharacter,$c(10),"\r")
	quit strCharacter
}

Storage Default
{
<Data name="DHCExtUtilDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCExtUtilD</DataLocation>
<DefaultData>DHCExtUtilDefaultData</DefaultData>
<IdLocation>^web.DHCExtUtilD</IdLocation>
<IndexLocation>^web.DHCExtUtilI</IndexLocation>
<StreamLocation>^web.DHCExtUtilS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
