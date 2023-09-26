Class DtPortal.Common.Data2JsonService Extends %SOAP.WebService [ ClassType = "", Not ProcedureBlock ]
{

/// Each web service needs to supply this parameter.
Parameter NAMESPACE = "http://www.dhcc.com.cn";

/// This is the name of our web service.
/// Each web service needs to supply this parameter.
Parameter SERVICENAME = "Data2JsonService";

/// 结果集
Property Source As %ResultSet;

/// Creator：     CYQ
/// CreatDate：   2014-07-14
/// Description:  根据ClassName:methodName返回结果,转换为JSON输出
/// Table：       
/// Input：       clsName : 类名称
///               methodName : query名称
///               p1-p16 : 参数
/// Return：  string类型的json串
/// w ##class(DtPortal.Common.Data2JsonService).GetClassMethodData("DtPortal.Doctor.CSMServicesForPortal","GetDataAuditRemind","1008")
ClassMethod GetClassMethodData(clsName As %String, methodName As %String, parameterStr As %GlobalCharacterStream, serviceCodeStr As %GlobalCharacterStream) As %GlobalCharacterStream [ WebMethod ]
{
	set $zt="errorGetClassMethodData"
	s clsName=$g(clsName)
	s methodName=$g(methodName)
	s parameters=parameterStr.Read()
	s length=$l(parameters,$c(9813))
	s obj =..%New()
	set parameters = obj.CharTransfer(parameters)
	
	s serviceCode=serviceCodeStr.Read()
	s serviceCode=$replace(serviceCode,$c(10),"")
	//1-显示  0（或其他）-不显示
	s ifDisplayCode=+##Class(DtPortal.Common.PublicService).getValueByCode("DISPLAYCACHEMETHODINFO")
	
	s mdf=##class(%Dictionary.CompiledMethod).%OpenId(clsName_"||"_methodName,0)
	s err="{""status"":""-1"",""errMSG"":""("_clsName_")."_methodName_" was not found"""_",""total"":""0"",""data"":[]}"
	s objErr="{""status"":""-1"",""errMSG"":""("_clsName_")."_methodName_" 's return value is not an object """_",""total"":""0"",""data"":[]}"
	quit:'$IsObject(mdf) err
	set ret=""
	set paras=mdf.FormalSpec
	set:paras="" parasCount=0
	set:paras'="" parasCount=$l(paras,",")
	set execute="s ret=$ZOBJCLASSMETHOD(clsName,methodName"
	
	if parasCount=0 {
		set execute=execute_")"
		x execute
		} else {
			set i=0
			while (i<parasCount){
				set i=i+1
				set tempParam=$p(parameters,$C(9813),i)
				set execute=execute_",$s("""_tempParam_"""=$c(0):"""",1:"""_tempParam_""")"
			}
		set execute=execute_")"
		x execute
	}
	s obj=##class(DtPortal.Common.JsonObject).%New()
					
	set obj.ContainNullValue=1					//json中显示空值的字段
	set obj.ContainNullObject=1					//json中显示包含"{}"空对象
	set obj.ContainNullArray=1					//json中显示包含"[]"空对象
	;s outStrs = obj.ObjToJson(ret)
	if $IsObject(ret) d
	.s jsonObj=obj.FromObject(ret)
	.;s outStr = obj.FromObject(ret).Json() 	//这里是个对象。通过.Json()看到结果
	.i ifDisplayCode="1" d
	..d jsonObj.Put("serviceCode",serviceCode)
	..d jsonObj.Put("clsName",clsName)
	..d jsonObj.Put("clsMethod",methodName)
	..d jsonObj.Put("parameters",parameters)
	.s outStr = jsonObj.Json() 	//这里是个对象。通过.Json()看到结果
	.;b ;outStr
	e  d
	.s outStr=ret	//如果不是对象，原数据返回
	s convToStream = ##class(%GlobalCharacterStream).%New()
	d convToStream.Write(outStr)
	set obj = ""
	set err=""
	set objErr=""
	;b ;endclassMethod
	q convToStream
	
	
errorGetClassMethodData
	b ;err1
	set $zt="errorGetClassMethodData2"
	s convToStreamErr = ##class(%GlobalCharacterStream).%New()
	s errStr=$tr($ze,"""","'")
	s errData="{""status"":-1,""errMSG"":"_$c(34)_errStr_$c(34)_",""data"":[],""total"":""0"",""clsName"":"_$c(34)_clsName_$c(34)_",""clsMethod"":"_$c(34)_methodName_$c(34)_",""parameters"":"_$c(34)_parameters_$c(34)_",""serviceCode"":"_$c(34)_serviceCode_$c(34)_"}"
	
	d convToStreamErr.WriteLine(errData)
	q convToStreamErr
	quit
errorGetClassMethodData2
	//捕获异常里面存在错误，继续捕获
	b ;err2
	s errorAndError = ##class(%GlobalCharacterStream).%New()
	s errorAndErrorData="{""status"":-1,""errMSG"":"_$c(34)_errStr_$c(34)_",""data"":[]}"
	d errorAndError.WriteLine(errorAndErrorData)
	q errorAndError
	quit
}

Method WriteJSON(startLineNum, pageRange) As %String
{
	s startLineNum=$g(startLineNum)
	s pageRange=$g(pageRange)
	s flag=0
	i (startLineNum="")&&(pageRange="") set flag=1  ;get all data
	set total=0, wholeStr="",jsonString=""
	i flag=0  s startLineNum=startLineNum+1
	set list=##class(%Library.ListOfObjects).%New()
	While ..Source.Next() 
	{
		s total=total+1
		set jsonObj = ##class(DtPortal.Common.JsonObject).%New()
		f i=1:1:..Source.GetColumnCount()
		{
			//d ..WriteDataTag(..Source.GetColumnName(i),..EscapeChar(..Source.%GetData(i)))
			/*
			s sonValue=..Source.%GetData(i)
			s sonValue=$replace(sonValue,$c(32),"")
			s sonValue=$replace(sonValue,$c(13,10),"")
			s sonValue=$replace(sonValue,$c(0),"")*/
			s sonValue=##class(ext.util.String).EvalJSONNew(sonValue)
			d jsonObj.Put(..Source.GetColumnName(i),..EscapeChar(sonValue))
		}
		i (flag=0) d
		.i (startLineNum<=total)&&(total<(startLineNum+pageRange)) d
		..d list.Insert(jsonObj)
		e  d
		.d list.Insert(jsonObj)
	}
	set jsonObj = ##class(DtPortal.Common.JsonObject).%New()
	set wholeStr = jsonObj.ListToJson(list)
	b ;213
	s jsonString="{""status"":1,""errMSG"":""1"",""total"":"_total_",""data"":"_wholeStr_"}"
	q jsonString
}

Method CharTransfer(val As %String) As %String
{
	new (val)
	//set ret = ..ReplaceString(val,"""","'")
	set ret = ..ReplaceString(val,"""","""""")
	quit ret
}

/// add by wuqk 2014-4-10 
/// XML输出内容为特殊字符转义
Method EscapeChar(val As %String) As %String
{
	new (val)
	set ret = ..ReplaceString(val,"&","&amp;")
	set ret = ..ReplaceString(val,"<","&lt;")
	set ret = ..ReplaceString(val,">","&gt;")
	set ret = ..ReplaceString(val,"""","&quot;")
	set ret = ..ReplaceString(val,"'","&apos;")
	quit ret
}

// $TR(string,identifier,associator)

/// add by wuqk 字符串替换
Method ReplaceString(Str, OldStr, NewStr) As %String
{
	new (Str, OldStr, NewStr)
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

/// Creator：     CYQ
/// CreatDate：   2014-07-03
/// Description:  根据ClassName:Query返回结果集,转换为JSON输出
/// Table：       
/// Input：       clsName : 类名称
///               queryName : query名称
/// 			  startLineNum ：截取部分json的话，起始数的条目 
/// 			  pageRange   ：要取的数据条数
///               p1-p16 : 参数
/// Return：  string类型的json串
/// 通过此方法，将query数据转化为String类型的JSON数据。
/// w ##class(DtPortal.Common.Data2JsonService).GetQueryData("DtPortal.Doctor.ScientificResearch","ScientificSubjQuery","1","10","","","","")
/// w ##class(DtPortal.Common.Data2JsonService).GetQueryData2("DtPortal.Doctor.Special.SPatService","QrySPatList","♕♕1♕601")
ClassMethod GetQueryData(clsName As %String, queryName As %String, parameterStr As %GlobalCharacterStream, serviceCodeStr As %GlobalCharacterStream) As %GlobalCharacterStream [ WebMethod ]
{
	set $zt="error2"
	s clsName=$g(clsName)
	s queryName=$g(queryName)
	s parameters=parameterStr.Read()
	//1-显示  0（或其他）-不显示
	s ifDisplayCode=+##Class(DtPortal.Common.PublicService).getValueByCode("DISPLAYCACHEMETHODINFO")
	
	s length=$l(parameters,$C(9813))
	s startLineNum=$p(parameters,$C(9813),1)
	s pageRange=$p(parameters,$C(9813),2)

	
	s serviceCode=serviceCodeStr.Read()
	s serviceCode=$tr(serviceCode,$c(10),"")
	set qdf=##class(%Dictionary.QueryDefinition).%OpenId(clsName_"||"_queryName,0)
	s err="{""status"":""-1"",""errMSG"":""("_clsName_")."_queryName_" was not found"""_",""total"":""0"",""data"":[]}"
	s paramsNumErr="{""status"":""-1"",""errMSG"":""you should give me TWO more params"",""total"":""0"",""data"":[]}"
	quit:'$IsObject(qdf) err
	
	set err = ""
	set paras=qdf.FormalSpec
	set:paras="" parasCount=0
	set:paras'="" parasCount=$l(paras,",")  //服务里面不能默认参数带【逗号】，不然这块解析会报错，暂时修改不取parasCount这个参数
	set rs=##class(%ResultSet).%New(clsName_":"_queryName)
	//调用query时候，没有传入分页信息，退出运行并提示
	/*
	if (length-parasCount'=2){
		s convToStream = ##class(%GlobalCharacterStream).%New()
		d convToStream.Write(paramsNumErr)
		q convToStream
		}
	*/		
	if parasCount=0 {d rs.Execute()}
	
	else{
		//服务里面不能默认参数带【逗号】，不然这块解析会报错，暂时修改不取parasCount这个参数
		//set parasCount=parasCount+2  
		set parasCount=length  //修改取传进来参数的长度
		set execute="set %sc=$zobjmethod(rs,""Execute"",",i=2
		while (i<(parasCount)){
			;b ;6
			set i=i+1
			//set execute=execute_"$s($p("""_parameters_""","""_$C(9813)_""","_i_")=$c(0):"""",1:$p("""_parameters_""","""_$C(9813)_""","_i_"))"
			set tempParam=$p(parameters,$C(9813),i)
			set execute=execute_"$s("""_tempParam_"""=$c(0):"""",1:"""_tempParam_""")"
			if (i<parasCount) {set execute=execute_","}
		}
		set execute=execute_")"
		
		x execute
	}
	s err=""
	s paramsNumErr=""
	set obj=..%New()
	set obj.Source=rs
	
	s startLineNum=$g(startLineNum)
	s pageRange=$g(pageRange)
	s flag=0
	i pageRange="" set flag=1  ;get all data  //bmz 20160713 去掉这个条件(startLineNum="")&&  
	set total=0, nowNum=0
	i flag=0  s startLineNum=startLineNum+1
	set isFirst=0
	s convToStream = ##class(%GlobalCharacterStream).%New()
	While rs.Next() 
	{
		set total=total+1
		set jsonData=""
		
		set:isFirst=0 jsonData="{""status"":1,""errMSG"":""1"",""data"":"_"[{"
		
		
		set:isFirst'=0 jsonData=",{"
		
		
		For i = 1:1:rs.GetColumnCount() 
		{
			
			s sonValue=rs.%GetData(i)
			/*
			s sonValue=$tr(sonValue,$c(32),"")
			s sonValue=$tr(sonValue,$c(13,10),"")
			s sonValue=$tr(sonValue,$c(0),"")
			s sonValue=$tr(sonValue,"""","")*/
			s sonValue=##class(ext.util.String).EvalJSONNew(sonValue)
			//修改分页
			if (flag=1){
				set:i=1 jsonData=jsonData_""""_ rs.GetColumnName(i)_""""_":"_""""_sonValue_""""
				set:i'=1 jsonData=jsonData_","_""""_ rs.GetColumnName(i)_""""_":"_""""_sonValue_""""
			} else {
				
				i (startLineNum<=total)&&(total<(startLineNum+pageRange)){					
					set:i=1 jsonData=jsonData_""""_ rs.GetColumnName(i)_""""_":"_""""_sonValue_""""
					set:i'=1 jsonData=jsonData_","_""""_ rs.GetColumnName(i)_""""_":"_""""_sonValue_""""
				}
			}
			
		} 
		//修改分页
		if (flag=1){
			set jsonData=jsonData_"}"
			do convToStream.WriteLine(jsonData)
			set isFirst=1
		} else {
			if (startLineNum<=total)&&(total<(startLineNum+pageRange)){
				set jsonData=jsonData_"}"
				do convToStream.WriteLine(jsonData)
				set isFirst=1
			}
		}
		
		
		
	}
	i ifDisplayCode="1" set nullData="{""status"":1,""errMSG"":""1"",""data"":[],""total"":0,""clsName"":"_$c(34)_clsName_$c(34)_",""clsMethod"":"_$c(34)_queryName_$c(34)_",""parameters"":"_$c(34)_parameters_$c(34)_",""serviceCode"":"_$c(34)_serviceCode_$c(34)_"}"  
	e  s nullData="{""status"":1,""errMSG"":""1"",""data"":[],""total"":0}" 
	i ifDisplayCode="1" set strJson="],""total"":"_total_",""clsName"":"_$c(34)_clsName_$c(34)_",""clsMethod"":"_$c(34)_queryName_$c(34)_",""parameters"":"_$c(34)_parameters_$c(34)_",""serviceCode"":"_$c(34)_serviceCode_$c(34)_"}"
	e  s strJson="],""total"":"_total_"}"
	if total=0
	{
		do convToStream.WriteLine(nullData)
	}else
	{
		do convToStream.WriteLine(strJson)
	}
	
	q convToStream
error2
	set $zt="errorAndError"
	s convToStreamErr = ##class(%GlobalCharacterStream).%New()
	s errStr=$tr($ze,"""","'")
	s errData="{""status"":-1,""errMSG"":"_$c(34)_errStr_$c(34)_",""data"":[],""total"":""0"",""clsName"":"_$c(34)_clsName_$c(34)_",""clsMethod"":"_$c(34)_queryName_$c(34)_",""parameters"":"_$c(34)_parameters_$c(34)_",""serviceCode"":"_$c(34)_serviceCode_$c(34)_"}"
	
	d convToStreamErr.WriteLine(errData)
	q convToStreamErr
	quit
errorAndError
	//捕获异常里面存在错误，继续捕获
	s errorAndError = ##class(%GlobalCharacterStream).%New()
	s errorAndErrorData="{""status"":-1,""errMSG"":"_$c(34)_errStr_$c(34)_",""data"":[]}"
	d errorAndError.WriteLine(errorAndErrorData)
	q errorAndError
	quit
}

}
