/// Descript:	Json字符串解析
/// Creator:	XuChao
/// CreateDate:	2018-03-26
/// Input:		Json字符串
/// Output:     Json对象
Class web.CSSDHUI.Common.FromJson Extends %RegisteredObject
{

/// JsonObj
Property JsonObj;

/// Cache2016写法
Method %FromJSON(jsonstr As %String)
{
	s ret=0
	s i%JsonObj={}
	q:jsonstr="" ret
	try{
		s i%JsonObj={}.%FromJSON(jsonstr)
	}catch{s ret=-100}
	q ret
}

Method %Set(key, value)
{
	d i%JsonObj.%Set(key,value)
}

/// 取json对象的Key对应的值
Method %Get(key)
{
	q i%JsonObj.%Get(key)
}

Method %GetObj()
{
	q i%JsonObj
}

Method %Pop()
{
	s obj=""
	try{
		s obj=i%JsonObj.%Pop()
	}catch{}
	i obj="" q ""
	q obj
}

}
