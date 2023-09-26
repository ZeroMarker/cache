Class web.DHCBPHTTPInterface Extends %CSP.Page
{

ClassMethod OnPreHTTP() As %Boolean
{
	//kill ^TempICUDebug
	/*set ^TempICUDebug("OnPreHTTP",$h)="NewSession"
	set %session.UseSessionCookie=1
	// ?CacheNoRedirect=1&CacheUserName=dhsyslogin&CachePassword=1q2w3e4r%T6y7u8i9o0p
	Do %response.SetCookie("CacheUserName","dhsyslogin")
	Do %response.SetCookie("CachePassword","1q2w3e4r%T6y7u8i9o0p")
	*/
	Quit $$$OK
}

ClassMethod OnPage() As %Status
{
	try{
		/*If (%session.NewSession = 1) {
		     // this is a new session
		    // set ^TempICUDebug("web.DHCBPHTTPInterface",$h)="NewSession"
		     //do %session.Login("dhsyslogin","1q2w3e4r%T6y7u8i9o0p")
		     //set %session.Data("CacheUserName")="dhsyslogin"
		     //set %session.Data("CachePassword")="1q2w3e4r%T6y7u8i9o0p"
		     //kill ^TempICUDebug
		     // write "NewSession"
		  }
		  else
		  {
		  set ^TempICUDebug("web.DHCBPHTTPInterface",$h)="OldSession:"_%session.SessionId
		  //write %session.SessionId,!
		  set %session.EndSession=1
		  do %session.Logout(1000000)
		  }
		*/
		set os=##class(%SYSTEM.Version).GetOS()
		if os="Windows"
		{
			set nullDev="//./nul"
		}
		if os="UNIX"
		{
			set nullDev="/dev/null/"
		}
		// 将write重定向到nullDev，之后write语句将不再输出到浏览器端
		USE nullDev

		set clsName=$g(%request.Data("ClassName",1))
		set queryName=$g(%request.Data("QueryName",1))
		set MsgType=$g(%request.Data("MsgType",1))
		set stream=""
		set errorStr=""
		//set ^tempDebug("MsgType")=MsgType
		if (MsgType="RunMethod")
		{
			set methodName=%request.Data("MethodName",1)
			set stream=..RunMethod(clsName,methodName,.errorStr)
		}
		else
		{
			set queryName=%request.Data("QueryName",1)
			set stream=..RunQuery(clsName,queryName,.errorStr)
		}
		// 恢复默认
		USE 0
		if (errorStr'="")
		{
			write errorStr,!
		}
		elseif (..IsClass(stream,"%GlobalCharacterStream"))
		{
		    While (stream.AtEnd = 0) 
		    {
			    Set len=1024
			    Write stream.Read(.len)
			}
		}
		else
		{
		    Write stream
		}
	}
	catch(e)
	{
		w e.AsSystemError() ,!
	}
	Quit $$$OK
}

ClassMethod RunMethod(className As %String, methodName As %String, errorStr As %String) As %GlobalCharacterStream
{
	set retStr=##class(%GlobalCharacterStream).%New()
	do retStr.Rewind()
	set myobj=##class(%Dictionary.CompiledMethod).%OpenId(className_"||"_methodName,0)
	set paramList=myobj.FormalSpecParsed
	set createInstanceStr="set instance=##class("_className_").%New()"
	set excuteStr="(resultStr,ParaList)s resultStr=$METHOD(instance,"""_methodName_""""
	set ParaList=""
	// set excuteStr=excuteStr_..GetParams(paramList,.ParaList)
	set argCount=%request.Get("ArgCnt")

	for i=1:1:argCount
	{
		set argName="Arg"_i
		set ParaList(i)=%request.Data(argName,1)
		set excuteStr=excuteStr_",ParaList("_i_")"
	}
	set excuteStr=excuteStr_")"

	try
	{
		set ^tempICUDebug("RunMethod")=excuteStr
		XECUTE createInstanceStr,(excuteStr,.resultStr,.ParaList)

		s returnType=myobj.ReturnType
		set retStr=resultStr
	}
	catch
	{
		set errorStr=$ZE
	}
	if $TLEVEL>0 TRollback 
	q retStr
}

ClassMethod RunQuery(className, queryName, errorStr) As %GlobalCharacterStream
{
	set myobj=##class(%Dictionary.CompiledQuery).%OpenId(className_"||"_queryName,0)
	set paramList=myobj.FormalSpecParsed
	s rset=##class(%ResultSet).%New(className_":"_queryName)
	s excuteStr="(rset,ParaList)set %sc=$zobjmethod(rset,""Execute"""
	kill ParaList
	//set excuteStr=excuteStr_..GetParams(paramList,.ParaList)
	set argCount=%request.Get("ArgCnt")

	for i=1:1:argCount
	{
		set argName="Arg"_i
		set ParaList(i)=%request.Data(argName,1)
		set excuteStr=excuteStr_",ParaList("_i_")"
	}

	set excuteStr=excuteStr_")"
	set retStr=##class(%GlobalCharacterStream).%New()
	    d retStr.Rewind()
	set ret=""

	XECUTE (excuteStr,.rset,.ParaList)
	set count=rset.GetColumnCount()
	do retStr.Write("{""rows"":")
	do retStr.Write("[")
	set rowIndex=0
	while (rset.Next()) {
		if rowIndex'=0 d retStr.Write(",")
		do retStr.Write("{")
		for i=1:1:count
		{
			set name=rset.GetColumnName(i)
			set value=rset.Get(name)
			set value=$zconvert(value,"O","JSON")
			if i=1 d retStr.Write(""""_name_""":"""_value_"""")
			else  d retStr.Write(","""_name_""":"""_value_"""")
		}
		do retStr.Write("}")
		set rowIndex=rowIndex+1
	}
	do retStr.Write("]")
	do retStr.Write(",""total"":"_rowIndex)
	do retStr.Write(",""rowIndex"":"_1)
	do retStr.Write("}")
	quit retStr
}

ClassMethod IsClass(obj, className) As %Boolean
{
	if ($isobject(obj)&&((obj.%ClassName()=className)||(obj.%IsA(className))))
	{
	quit $$$OK
	}
	quit 0
}

/*ClassMethod GetParams(paramList, ParaList)
{
	set argCount=%request.Get("ArgCnt")
	set excuteStr=""
	for i=1:1:argCount
	{
	set argName="Arg"_i
	set ParaList(i)=%request.Data(argName,1)
	set excuteStr=excuteStr_",ParaList("_i_")"
	}
	set ^tempDebug("GetParams")=excuteStr
	quit excuteStr
}*/

/// 该方法未使用

}
