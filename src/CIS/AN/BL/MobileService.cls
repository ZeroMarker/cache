Class CIS.AN.BL.MobileService Extends %CSP.Page
{

ClassMethod OnPreHTTP(ByRef OutputBody As %Boolean) As %Boolean
{
	/*星号表示所有的域都可以接受，*/
	Do %response.SetHeader("Access-Control-Allow-Origin","*")
	Do %response.SetHeader("Access-Control-Allow-Methods","GET,POST")
	Do %response.SetHeader("Access-Control-Allow-Headers","x-requested-with,content-type")
	// Do %response.SetHeader("Access-Control-Allow-Headers","x-requested-with,content-type")
	//Do %response.SetHeader("Content-Type","application/pdf")
	Quit 1
}

ClassMethod OnPage() As %Status
{
	try{
		s msgType=%request.Data("MsgType",1)
		s params=%request.Data("Params",1)
		s clsName=%request.Data("ClassName",1)
		s stream=""
		s tag=%request.Data("Tag",1)
		s tag="XX"
		if (msgType="RunMethod"){
			s methodName=%request.Data("MethodName",1)
			if ((tag'="") || (methodName="LogOn") || (methodName="GetLocList")){
				s stream=..RunMethod(clsName,methodName,params)
			}
			else{
				w "TimeOut"
			}
		}
		elseif (msgType="RunQuery"){
			s queryName=%request.Data("QueryName",1)
			if (tag'=""){
			    s stream=..RunQuery(clsName,queryName,params)
			}
			else{
				w "TimeOut"
			}
		}
		else{
			w "Unknown Message"
	    }
	    if (stream'=""){
		    While (stream.AtEnd = 0) {
		    Set len=100
		    Write stream.Read(.len)
		  }
	    }
	}
	catch(e)
	{
		w e.AsSystemError() ,!

	}
	// w ..Response(msgType,data)
	Quit $$$OK
}

// 

// w ##class(web.DHCCLMobileInferface).Response(msgType, requestData)

// w ##class(web.DHCCLMobileInferface).Response("LogIn", "{""UserName"":""demo"",""Password"":""1""}")

ClassMethod Response(msgType, requestData)
{
	s res=0
	s data=""
    if (msgType="LogIn"){
	    ;Set %session.Data("CLMobile")=$h
	    ;Do %response.SetCookie("CLMobile",$h)
	    s data="Login Success"
	    s userInfo={}.%FromJSON(requestData)
	    s data=##class(DHCBP.Account).LogOn(userInfo.UserName,userInfo.Password)
	    s ^TempBPLogInfo(userInfo.UserName,"LogInTime")=$h
	    s ^TempBPLogInfo(userInfo.UserName,"Loc")=$h
	    s ^TempBPLogInfo(userInfo.UserName,"GroupId")=$h
	    if (data=-2){
		    s data="Login Failed"
	    }
    }
    elseif(msgType="Test") {
	    s data="Test Data"
    }
    elseif(msgType="PatList") {
	    Set tag=%request.GetCookie("CLMobile")
	    s ^TmpDebug("CLMobile")=tag
	    s data="message"
	}
	s res=$Replace(res,"""","\""")
	s data=$Replace(data,"""","\""")
	s result={}
	s result.Result=res
	s result.Data=data
	s resStr=result.%ToJSON()
	q resStr
}

// w ##class(web.DHCCLMobileInferface).RunMethod("DHCBP.Account", "LogOn", "{""userName"":""demo"", ""password"":""1""}")

// w ##class(web.DHCCLMobileInferface).RunMethod("DHCBP.Arrange", "Set", param)

// w ##class(web.DHCCLMobileInferface).RunMethod("DHCBP.Anticoagulant", "GetDrugOptions", "{""ClassName"":""DHCBP.Anticoagulant"",""MethodName"":""GetDrugOptions"",""arrangeId"":5,""drugId"":1,""Array"":""}")

ClassMethod RunMethod(className, methodName, param As %String(MAXLEN=1000000)) As %GlobalCharacterStream
{
	s ^TmpDebug("param")=$zdt($h)_":"_param
	s param=$REPLACE(param,"\u0000",$C(0))
	s param=$REPLACE(param,"\u0001",$C(1))
	s param=$REPLACE(param,"\u0002",$C(2))
	s retStr=##class(%GlobalCharacterStream).%New()
    d retStr.Rewind()
    set myobj=##class(%Dictionary.CompiledMethod).%OpenId(className_"||"_methodName,0)
    set paramList=myobj.FormalSpecParsed
    set len=$LISTLENGTH(paramList)
    //Cache 2016以后
    /*
    s paramStr=""
    s param={}.%FromJSON(param)
    s excuteStr="(resultStr)s resultStr=$ZOBJCLASSMETHOD("""_className_""","""_methodName_""""
    for i=1:1:len {
	    set item=$LIST(paramList,i)
	    set name=$LIST(item,1)
	    set type=$LIST(item,2)
	    s excuteStr=excuteStr_","""_param.%Get(name)_""""
	}
	*/
	s param=..ToJsonObj(param)
	
	s excuteStr="(resultStr)s resultStr=$ZOBJCLASSMETHOD("""_className_""","""_methodName_""""
	//opsId, itemInfoStr As %String(MAXLEN=100000), userId, moduleCode
	s opsId="",itemInfoStr="",userId="",moduleCode=""
	s opsIdVal="",itemInfoStrVal="",userIdVal="",moduleCodeVal=""
	for i=1:1:len {
	    set item=$LIST(paramList,i)
	    set name=$LIST(item,1)
	    set type=$LIST(item,2)
	    s p=param.GetAt(name)
	    s p=$Replace(p,"""","""""")
	    set:name="opsId" opsIdVal=p
	    set:name="itemInfoStr" itemInfoStrVal=p
	    set:name="userId" userIdVal=p
	    set:name="moduleCode" moduleCodeVal=p
	    s excuteStr=excuteStr_","""_p_""""
	}
	s specStr=""
	if ((className="CIS.AN.BL.Mobile")&&(methodName="SaveOperDatas"))
	{
		s specStr=##class(CIS.AN.BL.Mobile).SaveOperDatas(opsIdVal,itemInfoStrVal,userIdVal,moduleCodeVal)
	}
	
	d:specStr'="" retStr.Write(specStr)
	
	q:specStr'="" retStr
	set excuteStr=excuteStr_")"
	
	XECUTE (excuteStr,.resultStr)
	
	s returnType=myobj.ReturnType
	if (returnType["GlobalBinaryStream"){
		s retStr=resultStr
	}
	else{
		d retStr.Write(resultStr)
	}
	//d retStr.OutputToDevice()
	
	q retStr
}

// w ##class(web.DHCCLMobileInferface).RunQuery("web.DHCBPBedEquip", "FindBedEquip","{""userName"":""demo"", ""password"":""1""}")

ClassMethod RunQuery(className, queryName, param) As %GlobalCharacterStream
{
	s ^TmpDebug("param")=param
	s param=$REPLACE(param,"\u0000",$C(0))
	s param=$REPLACE(param,"\u0001",$C(1))
	s param=$REPLACE(param,"\u0002",$C(2))
	s a=1
	set myobj=##class(%Dictionary.CompiledQuery).%OpenId(className_"||"_queryName,0)
	set paramList=myobj.FormalSpecParsed
	set len=$LISTLENGTH(paramList)
	s rset=##class(%ResultSet).%New(className_":"_queryName)
	s excuteStr="(rset)set %sc=$zobjmethod(rset,""Execute"""
	/* Cache 2016以后
	s param={}.%FromJSON(param)
	
    for i=1:1:len {
	    set item=$LIST(paramList,i)
	    set name=$LIST(item,1)
	    set type=$LIST(item,2)
	    s excuteStr=excuteStr_","""_param.%Get(name)_""""
	}
	*/
	// Cache 2016以前版本
	s param=..ToJsonObj(param)
	for i=1:1:len {
	    set item=$LIST(paramList,i)
	    set name=$LIST(item,1)
	    set type=$LIST(item,2)
	    s excuteStr=excuteStr_","""_param.GetAt(name)_""""
	}
	
    s excuteStr=excuteStr_")"
    
	s retStr=##class(%GlobalCharacterStream).%New()
    d retStr.Rewind()
	s ret=""
	
	XECUTE (excuteStr,.rset)
	s count=rset.GetColumnCount()
    
    d retStr.Write("[")
    set rowIndex=1
	while (rset.Next()) {
		if rowIndex'=1 d retStr.Write(",")
		d retStr.Write("{")
		f i=1:1:count  d
		.s name=rset.GetColumnName(i)
		.s value=rset.Get(name)
		.i i=1 d retStr.Write(""""_name_""":"""_value_"""")
		.e  d retStr.Write(","""_name_""":"""_value_"""")
		d retStr.Write("}")
		set rowIndex=rowIndex+1
	}
	d retStr.Write("]")
    // d retStr.OutputToDevice()
    q retStr
}

ClassMethod ToJsonObj(jsonStr As %String)
{
  q ##class(Nur.JSON).Decode(jsonStr)
}

}
