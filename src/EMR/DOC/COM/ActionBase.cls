/// 名称:	EMR.DOC.COM.ActionBase
/// 描述:	通用文档管理模块 Document(Doc) 业务基类
/// 编写者:	yejian
/// 编写日期: 	2020-12-7
/// 产品组：	电子病历产品组
Class EMR.DOC.COM.ActionBase Extends %RegisteredObject
{

Parameter OK = "true";

Parameter ERROR = "false";

Parameter NONE = """""";

Parameter DEFAULTERRCODE = 1001;

Parameter DECURRENT = 1;

Parameter DEPAGESIZE = 20;

Parameter ST = "ISECTIONDESC";

Parameter ET = "ICOMPOSITESAMPLE";

Parameter CT = "ICOMPOSITEDESC";

Parameter ProductCode = "DOC";

ClassMethod DefaultOutMessage(ByRef argOutMessage As %DynamicObject)
{
	s argOutMessage.success = ..#OK
	s argOutMessage.errorMessage = ""
	s argOutMessage.errorCode = ""
	s argOutMessage.showType = 0
}

/// Desc:       设置回传消息
/// Creator:    duan
/// CreateDate: 2021-3-25
/// Input:      argOutMessage:回传消息
/// 			aSuccess:"OK" 成功，"ERROR" 失败
/// 			errorMessage"errMessage" 
/// 				showType （0 默认输出,-1 只输出data 不输出外层结构）
/// OutPut:     argOutMessage 返回消息json格式
///            	string 返回1 成功
ClassMethod SetOutMessage(ByRef argOutMessage As %DynamicObject, aSuccess As %String, errMessage As %String = "", showType As %String = 0) As %String
{
	s:(aSuccess="ERROR") argOutMessage.errorCode = ..#DEFAULTERRCODE
	s argOutMessage.errorMessage = errMessage
	s argOutMessage.showType = showType
	q "1"
}

/// Desc:       截取id值
/// Creator:    duan
/// CreateDate: 2021-4-20
/// Input:      argKey 返回给前端的拼接key，拼接格式:id(节点id)-type(节点类型)
/// OutPut:     argOutMessage 返回消息json格式
///            	string 返回1 成功
ClassMethod GetIDByKey(argKey As %String = "") As %String
{
	q:(argKey="") ""
	if (argKey ["||"){
		s id = $P(argKey,"||",1)
	}else{
		s id = argKey	
	}
	
	q id
}

/// Desc:       截取type值
/// Creator:    duan
/// CreateDate: 2021-4-20
/// Input:      argKey 返回给前端的拼接key，拼接格式:id(节点id)-type(节点类型)
/// OutPut:     argOutMessage 返回消息json格式
///            	string 返回1 成功
ClassMethod GetTypeByKey(argKey As %String = "") As %String
{
	s type=""
	q:(argKey="") ""
	if (argKey ["||"){
		s type = $P(argKey,"||",2)
	}
	q type
}

/// debug w ##class(EMR.DOC.COM.ActionBase).aTest()
ClassMethod aTest()
{
	s instance = ##class(CF.EMR.DOC.TemplateVersion).%OpenId(1)
	s data = instance.DocumentData
	s obj = ##class(%DynamicObject).%New()
	s newobj =  obj.%ToJSON(data)
	b ;11
	q newobj
}

/// Desc:       格式化type
/// Creator:    duan
/// CreateDate: 2021-4-20
/// Input:     
/// OutPut:    
ClassMethod FormatType(argType As %String = "") As %String
{
	s type=""
	q:(argType="") type
	s argType = $ZCVT(argType,"U")
	if (argType="Category"){
		s type = "CG"
	}
	elseif(argType="Document")
	{
		s type = "DT"	
	}
	elseif(argType="Section")
	{
		s type = "ST"	
	}
	elseif(argType="KBTree")
	{
		s type = "KT"	
	}
	else
	{
		s type =argType	
	}
	q type
}

}
