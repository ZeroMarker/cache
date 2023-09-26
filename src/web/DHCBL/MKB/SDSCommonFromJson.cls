/// Descript:	Json字符串解析(不支持2016)
/// Creator:	高姗姗
/// CreateDate:	2019-08-06
/// Input:		Json字符串
/// Output:     Json对象
/// Other: set json= ##class(ext.util.JsonObject).FromJSON(str)
/// Other: s bizObjId=json.GetValue("BizObjId")
Class web.DHCBL.MKB.SDSCommonFromJson Extends %RegisteredObject
{

/// JsonObj
Property JsonObj;

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
	q obj		;.%ToJSON()
}

}
