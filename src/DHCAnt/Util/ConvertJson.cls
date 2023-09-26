/// QP
/// 2016-08-14
/// jQuery EasyUI JSON 公共类
Class DHCAnt.Util.ConvertJson Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2016-08-14
/// DESC: 返回空对象
ClassMethod GetNoDataJson() As %String
{
	Q "{}"
}

/// CTOR: QP
/// DATE: 2016-08-14
/// DESC: JSON开始符
ClassMethod GetDataStartJson() As %String
{
	Q "{"
}

/// QP
/// DATE: 2016-08-14
/// JSON结束符
ClassMethod GetDataEndJson() As %String
{
	Q "}"
}

/// QP
/// DATE: 2016-08-14
/// JSON键值对
ClassMethod GetDataJson(keyName, keyValue) As %String
{
	S keyValue=..FilterValue(keyValue)
	Q """"_keyName_""""_":"_""""_keyValue_""","
}

/// dyp
/// DATE: 2017-03-01
/// 最后一个JSON键值对
ClassMethod GetLastDataJson(keyName, keyValue) As %String
{
	S keyValue=..FilterValue(keyValue)
	Q """"_keyName_""""_":"_""""_keyValue_""""
}

/// QP
/// DATE: 2016-08-14
/// 处理影响JSON格式的字符
ClassMethod FilterValue(value) As %String
{
	s value=$tr(value,$c(10))   ;替换换行符
	s value=$tr(value,$c(13))	;替换回车符
	//s value=$Replace(value,"\","\\")
	//s value=$Replace(value,"'","\'")
	s value=..ReplaceStr(value,"\","\\")
	s value=..ReplaceStr(value,"'","\'")
	q value
}

/// QP
/// DATE: 2016-08-14
/// 替换字符
ClassMethod ReplaceStr(Str, OldStr, NewStr) As %String
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

/// 获取json第一行格式 
ClassMethod GetJsonFirstRow(RowValue) As %String
{
	Q "{"_RowValue_"},"
}

/// 获取json最后一行格式 
ClassMethod GetJsonLastRow(RowValue) As %String
{
	Q "{"_RowValue_"}"
	//Q "{"_RowValue_"}"_"]"
}

}
