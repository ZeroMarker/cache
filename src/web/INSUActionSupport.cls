Class web.INSUActionSupport Extends %CSP.Page [ Not ProcedureBlock ]
{

Parameter SERVICEPACKAGE = "web.";

Parameter MODULEANDMETHOD = "MODULE_AND_METHOD";

/// MWToken参数 +20230314
Parameter MWTOKEN = "MWToken";

/// session状态
Property SessionStaits As %String [ InitialExpression = "TimeIn" ];

ClassMethod OnPage() As %Status
{
	s ErrInfo=""
	s ModuleName=""   ;模块名称
	s ActionName=""   ;分发方法名
	s status="-1"     ;错误代码
	
	s IsJson=0
	s NewLine="<br/>"
	s Accept=$g(%request.CgiEnvs("HTTP_ACCEPT"))
	i $f(Accept,"application/json")>0 {
		s IsJson=1
		s status="-404"
	}
	
	
	s PathInfo=%request.CgiEnvs("PATH_INFO")
	s Script=%request.CgiEnvs("SCRIPT_NAME")
	;s Module=$e(PathInfo,$l(Script),*)
	
	;01 分发模块及方法的格式验证
	s checkRtn=..checkUrlAndMoudle(.ModuleName, .ActionName, .ErrInfo)
	if checkRtn="0" {
		d ..outErrInfoFormat(status, ErrInfo)
		q $$$OK
	}
	
	;02 判断模块及方法是否存在
	s clsName=..#SERVICEPACKAGE_ModuleName
	s haveMethodFlg=##class(websys.Conversions).IsValidMethodName(clsName,ActionName)
	if (haveMethodFlg'="1") {
		s ErrInfo="无效的请求，请求方法不存在,请求为"_clsName_":"_ActionName
		d ..outErrInfoFormat(status, ErrInfo)
		q $$$OK
	}
	
	//s ..SessionStaits="TimeOut"
	
	;03 构造分发模块方法的执行字符串
	set methodObj=##class(%Dictionary.CompiledMethod).%OpenId(clsName_"||"_ActionName,0)
	s InArgList=methodObj.FormalSpecParsed      ;方法变量名称列表
	
	s DoStr="$classmethod(clsName,ActionName"   ;获取所有入参，然后实现动态调度
	if $d(InArgList)>0{
		s ArgLen=$ll(InArgList)
		f i=1:1:ArgLen d
		.s ArgName=$lg($lg(InArgList,i),1)      ;变量名
		.q:ArgName=..#MODULEANDMETHOD           ;模块处理方法参数过滤
		.q:ArgName=..#MWTOKEN                    ;MwToken参数
		.s @ArgName=$g(%request.Data(ArgName,1))
		.s DoStr=DoStr_","_ArgName
		
		s DoStr=DoStr_")"
	}
	
	;04 分发模块方法执行
	s:IsJson=1 status="-500"
	try{
		d @DoStr
		s Ret=0
	}catch errobj{
		s ErrInfo="执行d ##class("_clsName_")."_ActionName_"("
		
		s ArgLen=$ll(InArgList)
		f i=1:1:ArgLen d
		.s ArgName=$lg($lg(InArgList,i),1)       ;变量名
		.q:ArgName=..#MODULEANDMETHOD            ;模块处理方法参数过滤
		.s ArgVaue=$g(%request.Data(ArgName,1))
		.s:i>1 ErrInfo=ErrInfo_","
		.s ErrInfo=ErrInfo_""""_ArgVaue_""""
		
		s ErrInfo=ErrInfo_")"_"时发生异常！"
		s ErrInfo=ErrInfo_NewLine_"HTTP_URL:"_%request.CgiEnvs("HTTP_URL")
		s ErrInfo=ErrInfo_NewLine_"ErrorLocation:"_errobj.Location
		
		s errType=errobj.Name
		s errType=$Replace(errType,"<","&lt;")
		s errType=$Replace(errType,">","&gt;")
		s ErrInfo=ErrInfo_NewLine_"ErrType:"_errType
		s ErrInfo=ErrInfo_NewLine_"ErrSource:"_errobj.Data
		s ErrInfo=ErrInfo_NewLine_"ErrCode:"_errobj.Code

		d ..outErrInfoFormat(status, ErrInfo)	
	}
	
	Quit $$$OK
}

/// 功能说明：格式化错误信息为json格式
/// 入参说明：status   --> 错误编码
///           ErrInfo  --> 错误信息
/// 返 回 值：无
ClassMethod outErrInfoFormat(status As %String, ErrInfo As %String) As %String [ Private ]
{
	s data=##class(web.INSUAjaxData).%New()
	
	s data.status=status
	s data.data=""
	s data.info=ErrInfo
	d ##class(web.INSUEncodeJson).Encode(data)
	
	q "1"
}

/// 功能说明：验证URL路径和模块方法格式是否正确
/// 入参说明：无
/// 出参说明：ModuleName   --> 模块字符串
///           ActionName   --> 处理方法
///           ErrInfo      --> 错误信息
/// 返 回 值：1 正确 0 错误
ClassMethod checkUrlAndMoudle(ByRef ModuleName As %String, ByRef ActionName As %String, ByRef ErrInfo As %String) As %String [ Private ]
{
	s checkRtn="0"
	//s url=%request.CgiEnvs("HTTP_URL")
	s url=%request.GetCgiEnv("HTTP_URL","") //tangzf 2021-6-18 修改取值模式
	s quitFlg="0"
	s Module=$g(%request.Data(..#MODULEANDMETHOD,1))
	;01 是否有分发模型参数
	i Module="" d
	.s ErrInfo="PathInfo路径错误,没有参数["_..#MODULEANDMETHOD_"]或者值为空。HTTP_URL:"_url
	.s quitFlg="1"
	q:quitFlg="1" checkRtn
	
	;02 模块和方法的格式是否正确
	i $l(Module,"/")<3 d
	.s ErrInfo="PathInfo路径错误(模块和方法的格式不正确)，HTTP_URL:"_url
	.s quitFlg="1"
	q:quitFlg="1" checkRtn
	
	
	s ModuleName=$p(Module,"/",2)
	s ActionName=$p(Module,"/",3)
	i ((ModuleName="")||(ActionName="")) d
	.s ErrInfo=ErrInfo_"空操作(模块或者方法为空)，HTTP_URL:"_url
	.s quitFlg="1"
	q:quitFlg="1" checkRtn
	
	q "1"
}

ClassMethod OnPreHTTP() As %Boolean
{
	
	s LoginUserDr=$Get(%session.Data("LOGON.USERID"))    ;$g(%session.Get("LOGON.USERID")          ;登陆人ID,利用登陆人ID是否存在,判断session是否已经失效
	s ^TMPINSUQC("OnPreHTTP","LoginUserDr")=LoginUserDr

	s SessionStatis="TimeIn"                             ;session状态 TimeIn 未失效 TimeOut 失效
	s:LoginUserDr="" SessionStatis="TimeOut"
	Do %response.SetHeader("SessionStatis", SessionStatis)	
	q:SessionStatis'="TimeOut" 1
	
	//session 失效时的重新登陆页面
	//loginPath="/dthealth/web/insuqc/logon.csp"     //医保控费登陆页面
	//loginPath="/dthealth/web/csp/dhc.logon.csp"    //his系统的登陆页面
	s loginPath=##class(insuqc.service.com.INSUQCDicDataCtl).GetDicByCodeAndInd("INSUQC_Global_Config","InsuqcLogin_Path",4)
	s:loginPath="" loginPath="/dthealth/web/insuqc/logon.csp"
	Do %response.SetHeader("loginPath", loginPath)	

	q 1
}

}
