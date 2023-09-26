/// Creator:
/// Desctiptions:移动护管请求工具类
/// Date:
Class DHCINM.WebService.INMAppUtilComm Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// creator:
/// createdate:
/// input:
/// output:
/// description: 
/// other:字符串测试
/// other:zw ##class(DHCINM.WebService.INMAppUtilComm).RequestData("web.INMLoginComm:GetNursePassword","{""usercode"":""demo"",""password"":""1"",""APPLoginID"":""0"",""APPPerID"":""0""}","Method")
/// other:对象测试
/// other:zw ##class(DHCINM.WebService.INMAppUtilComm).RequestData("web.INMSetComm:GetModule","{""id"":""1""}","RecMethod")
/// other:数组测试
/// other:zw ##class(DHCINM.WebService.INMAppUtilComm).RequestData("web.INMSetComm:FindModuleList","{""parr"":""""}","RecQuery")
/// other:zw ##class(DHCINM.WebService.INMAppUtilComm).RequestData("web.INMPersonCountComm:FindPubCode","{""type"":""职工性质""}","Query") 
ClassMethod RequestData(method, params, type)
{
	n (method, params, type, %request, %session)
	s $zt="RequestERR"
#;	{msg,msgcode}  ;字符串
#;	{msg,msgcode,data:{}}  ;对象
#;	{msg,msgcode,data:[],results} ;数组
	s className=$P(method,":",1)
	s methodName=$P(method,":",2)
	i '$IsObject(params) s paramObj = ##class(DHCINM.WebService.INMAppCommon).Decode(params)
	e  s paramObj = params
	q:(className="") ##class(DHCINM.WebService.INMAppCommon).ReturnMsgJson("类名不能为空","-1")
	q:(methodName="") ##class(DHCINM.WebService.INMAppCommon).ReturnMsgJson("方法不能为空","-1")
	if type["Method" {
		q:'$d(^oddCOM(className,"m",methodName)) ##class(DHCINM.WebService.INMAppCommon).ReturnMsgJson("无此方法","-1")
	}elseif type["Query" {
		q:'$d(^oddCOM(className,"q",methodName)) ##class(DHCINM.WebService.INMAppCommon).ReturnMsgJson("无此Query","-1")
	}
	i type="RecMethod" {
		s ret=..MethodExcute(className,methodName,paramObj)	
		q ##class(DHCINM.WebService.INMAppCommon).StrToJson(ret)
		d ##class(web.INMLogComm).SaveLog(className,methodName,paramObj.GetAt("APPLoginID"),"APP")
	}elseif(type="Method") {
		q ##class(DHCINM.WebService.INMAppCommon).ReturnMsgJson(..MethodExcute(className,methodName,paramObj),"1")
		d ##class(web.INMLogComm).SaveLog(className,methodName,paramObj.GetAt("APPLoginID"),"APP")
	}elseif(type="RecQuery") {
		q ..RecQueryExcute(className,methodName,paramObj)
	}elseif(type="Query") {
		q ..QueryExcute(className,methodName,paramObj)
	}elseif(type="MethodNoFilter") {
		q ##class(DHCINM.WebService.INMAppCommon).ReturnMsgJson(..MethodExcute(className,methodName,paramObj,1),"1")
		d ##class(web.INMLogComm).SaveLog(className,methodName,paramObj.GetAt("APPLoginID"),"APP")
	}
	q ##class(DHCINM.WebService.INMAppCommon).ReturnMsgJson("无此类型方法","-1")
RequestERR
	s ^tmp("RequestERRAPPMG")=$ze
	q ##class(DHCINM.WebService.INMAppCommon).ReturnMsgJson("后端方法出错了","-1")
}

/// creator:
/// createdate:
/// input:
/// output:
/// description: 
/// other:
ClassMethod MethodExcute(className As %String, methodName As %String, paramObj, noFilterFlag As %String = 0)
{
	n (className,methodName, paramObj, %request, %session, noFilterFlag)
	s x="s ret=##class("_className_")."_methodName_"("
	s parameters=$g(^oddCOM(className,"m",methodName,60))
	s isOverLength=0
	f i=1:1:$ll(parameters) d
	.s itm=$list(parameters,i)
	.s itmStr=$list(itm,1)
	.i paramObj.GetAt(itmStr)'="" d
	..s parameterVal=paramObj.GetAt(itmStr)
	..i $CLASSNAME(parameterVal)["CSP.CharacterStream" d
	...d TransCharacterStream
	..e  d
	...s parameterVal=parameterVal
	..;检测长度
	..s:$L(parameterVal)>32765 isOverLength=1
	..s x=x_""""_parameterVal_""""
	.e  s x=x_""""""
	.i i'=$ll(parameters) s x=x_","
	s x=x_")"
	q:isOverLength=1 ##class(DHCINM.WebService.INMAppCommon).ReturnMsgJson("内容超过最大限度,请联系开发!","-1") 
	x x
	s:noFilterFlag'=1 ret=##class(DHCINM.WebService.INMAppCommon).Escape(ret)
	q ret
TransCharacterStream
	s tmpParr=""
	while ('parameterVal.AtEnd){
		s tmpParr=tmpParr_parameterVal.Read()
	}
	s parameterVal=tmpParr
}

/// creator:
/// createdate:
/// input:
/// output:
/// description: 
/// other:
ClassMethod RecQueryExcute(className As %String, methodName As %String, paramObj)
{
	n (className,methodName, paramObj, %request, %session)
	s rs=##class(%Library.ResultSet).%New(className_":"_methodName)
	s x="d rs.Execute("
	s parametersNum=rs.GetParamCount()
	f i=1:1:parametersNum 
	{
		s parameterName=rs.GetParamName(i)
		s parameterVal=paramObj.GetAt(parameterName)
		s x=x_""""_parameterVal_""""
		i i'=parametersNum s x=x_","
	}
	s x=x_")"
	x x
	s dataStream=##class(%GlobalCharacterStream).%New()
	d dataStream.Write("{")
	d dataStream.Write("""msg"":"""",""msgcode"":""1"",""data"":[")
	s results=0
	s start=paramObj.GetAt("start")
	s limit=paramObj.GetAt("limit")
	i start="" s start=0
	i start<0 s start=0
	i limit=""  s limit=100000
	s outResults=0
	while rs.Next()'=0
	{
		i (results>=+start)&(results<+(start+limit)) {
			i outResults'=0 d dataStream.Write(",")
			s columns=rs.GetColumnCount()
			f col = 1:1:columns 
			{
				s aa=rs.GetData(col)
		       	s l=$L(aa,"^")
		       	s va=$P(aa,"^",l)
		       	d dataStream.Write("{")
		       	
		       	f i=1:1:l
		       	{
			       	s vv=$P(aa,"^",i)
			     	i vv="" 
			     	{
				     	continue
			     	}
			     	s na=$P(vv,"|",1)
			     	s nv=$P(vv,"|",2,$L(vv,"|"))
			     	s nv=##class(DHCINM.WebService.INMAppCommon).Escape(nv)
			     	d dataStream.Write(""""_na_""":"""_nv_"""")
                 	i va=""
                 	{
	                 	i i'=(l-1) d dataStream.Write(",")
                 	}
                 	i va'=""
                 	{
	                 	i i'=(l) d dataStream.Write(",")
                 	}
			   	}
	           	d dataStream.Write("}")
			 }
			 s outResults=outResults+1
		}
		s results=results+1
	}
	d dataStream.Write("],""results"":"""_results_"""}")
	q dataStream
}

/// creator:
/// createdate:
/// input:
/// output:
/// description: 
/// other:
ClassMethod QueryExcute(className As %String, methodName As %String, paramObj)
{
	n (className,methodName, paramObj, %request, %session)
	s rs=##class(%Library.ResultSet).%New(className_":"_methodName)
	s x="d rs.Execute("
	s parametersNum=rs.GetParamCount()
	f i=1:1:parametersNum
	{
		s parameterName=rs.GetParamName(i)
		s parameterVal=paramObj.GetAt(parameterName)
		s x=x_""""_parameterVal_""""
		i i'=parametersNum s x=x_","
	}
	s x=x_")"
	x x
	s dataStream=##class(%GlobalCharacterStream).%New()
	d dataStream.Write("{""msg"":"""",""msgcode"":""1"",""data"":[")
	s results=0
	s start=paramObj.GetAt("start")
	s limit=paramObj.GetAt("limit")
	i start="" s start=0
	i start<0 s start=0
	i limit=""  s limit=100000
	s outResults=0
	while rs.Next()'=0 
	{
		i (results>=+start)&(results<+(start+limit)) 
		{
			i outResults'=0 d dataStream.Write(",")
			s columnNum=rs.GetColumnCount()
			d dataStream.Write("{")
			f i=1:1:columnNum 
			{
				s columnName=rs.GetColumnHeader(i)
				s columnValue=rs.GetDataByName(columnName)
				s columnValue=##class(DHCINM.WebService.INMAppCommon).Escape(columnValue)
				d dataStream.Write(""""_columnName_""":"""_columnValue_"""")
				i i'=columnNum d dataStream.Write(",")
			}
			d dataStream.Write("}")
			s outResults=outResults+1
		}
		s results=results+1
	}
	d dataStream.Write("],""results"":"_results_"}")
	q dataStream
}

}
