/// 名称:	EMR.DOC.BL.DateTimeStandSrv
/// 描述:	日期格式业务逻辑类
/// 编写者:	yejian
/// 编写日期: 	2022-8-25
/// 产品组：	电子病历产品组
Class EMR.DOC.BL.DateTimeStandSrv Extends EMR.DOC.COM.ActionBase
{

/// Desc:       获取服务器日期格式
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Table:		
/// Input:      argInJson  命令参数 {"product":"OP","action":"GET_STANDARD_DATE","params":{"type":"Date","value":"2022-10-17"}}
/// 			AType:[Date(日期),Time(时间)] 
///          	aValue:日期或时间   
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GeStandardDate(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s type = argInJson.params.type
	s value = argInJson.params.value
	s product = argInJson.product
    s strRes = ##Class(EMR.DOC.BL.DateTimeStandSrv).GeStandardDateJson(type,value,.argOutData)
	//1 获取成功
	if (strRes="1")
	{ 
	  	q argOutMessage.success = ..#OK
	}
	elseif(strRes["-1^")
	{  
		s strErr = $p(strRes,"^",2)
	    q ..SetOutMessage(argOutMessage,"ERROR",strErr,2)
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","获取数据失败",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       获取服务器日期格式
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Table:		
/// Input:   	AType:[Date(日期),Time(时间)] 
///          	aValue:日期或时间   
/// Output:     成功：1 失败 -1^失败信息 
/// debug:  	s obj = ##class(%GlobalBinaryStream).%New()     
/// 			q ##Class(EMR.DOC.BL.DateTimeStandSrv).GeStandardDateJson("Date","2022年10月17日",.obj)
ClassMethod GeStandardDateJson(aType As %String, aValue As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
	q:(aType="")||(aValue="") "-1^返回类型、日期不能为空"
	s dateValue = ##class(EMR.DOC.COM.DateTimeFormat).GetDateTimeHtmlToLogical(aType,aValue)
	 if (aType = "Date"){
        s retvalue = $zd(dateValue,3)  
    }
    elseif(aType = "Time"){
        s retvalue = $zt(dateValue,1) 
    }
	s retvalue = """"_retvalue_""""
	d argOutData.Write(retvalue)
	q strRes
}

/// Desc:       获取服务器日期格式
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Table:		
/// Input:      argInJson  命令参数 {"action":"GET_DATEFORMAT","product":"OP"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GeDateFormat(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
    s strRes = ##Class(EMR.DOC.BL.DateTimeStandSrv).GeDateFormatJson(.argOutData)
	//1 获取成功
	if (strRes="1")
	{ 
	  	q argOutMessage.success = ..#OK
	}
	elseif(strRes["-1^")
	{  
		s strErr = $p(strRes,"^",2)
	    q ..SetOutMessage(argOutMessage,"ERROR",strErr,2)
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","获取数据失败",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       获取系统日期格式配置
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Table:		
/// Input:   	AType:[Date(日期),Time(时间)] 
///          	aValue:日期或时间   
/// Output:     1 MM/DD/YYYY，3 YYYY-MM-DD，4 DD/MM/YYYY 
/// debug:  	s obj = ##class(%GlobalBinaryStream).%New()     
/// 			q ##Class(EMR.DOC.BL.DateTimeStandSrv).GeDateFormatJson(.obj)
ClassMethod GeDateFormatJson(ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
	s dateValue = ##class(websys.Conversions).DateFormat()
	s retvalue = """"_dateValue_""""
	d argOutData.Write(retvalue)
	q strRes
}

/// Desc:       获取指定格式的服务时间
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Table:		
/// Input:      argInJson  命令参数 {"action":"GET_SERVER_TIME","params":{"DateTimeFormat":"yyyy-MM-ddHH:mm:ss"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetServerTime(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
    s strRes = ##Class(EMR.DOC.BL.DateTimeStandSrv).GetServerTimeJson(.argOutData)
	//1 获取成功
	if (strRes="1")
	{ 
	  	q argOutMessage.success = ..#OK
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","获取数据失败",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       获取指定格式的服务时间
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Table:		CF.EMR.OP.SysOption 门急诊系统参数表
/// Input: 		argOutData json数据
/// Output:     成功：1 失败  -200 aSectionID参数未传 -201 根据kbbaseId未查到数据
/// debug:  s obj = ##class(%GlobalBinaryStream).%New()     
/// 		q ##Class(EMR.DOC.BL.DateTimeStandSrv).GetServerTimeJson(.obj)
ClassMethod GetServerTimeJson(ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
    s jsonItem  = ##class(%DynamicObject).%New()
   	s strkey = ""
	s date = $zd($p($h,",",1),3)
	s time = $zt($p($h,",",2))
	s datetime = date_" "_time
	s reDateTime = ##class(EMR.DOC.COM.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","DateTime",datetime)
	s reDateTime = """"_reDateTime_""""
	d argOutData.Write(reDateTime)
	q strRes
}

}
