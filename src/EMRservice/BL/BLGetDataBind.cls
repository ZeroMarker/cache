Class EMRservice.BL.BLGetDataBind Extends (%RegisteredObject, %XML.Adaptor)
{

Property HISBindData As %ArrayOfDataTypes;

Property EPRBindData As %ArrayOfDataTypes;

Property HISMethodData As %ArrayOfDataTypes;

/// Desc:       取模板绑定值
/// Creator:    Candy
/// CreateDate: 2014-1-20
/// Input:      ABaseBindCode 数据绑定集合 Key: Code,Value：EMRservice.BL.BLGetDataBind 属性有 HISBindData(HIS数据绑定)EPRBindData(电子病历数据绑定)
///             AListParam 参数值集合 key 参数名称 ,Value: 参数值
/// OutPut:     OutMessage 返回数据绑定值的item items:[{ "Code":"1^S01_H02_S.001","DataBaseBindCode":"默认值","EPRBindCode":"1"} ,{…}]}          
ClassMethod GetDefaultDataBind(ABaseBindCode As EMRservice.BL.BLGetDataBind, AListParam As %ArrayOfDataTypes, ByRef AOutMessage As %GlobalBinaryStream) As %String
{
	s count = 0
	s HISBindData = ABaseBindCode.HISBindData
	s EPRBindData = ABaseBindCode.EPRBindData
	s HISMethodData = ABaseBindCode.HISMethodData
	
	s streamHisData =  ##Class(%GlobalBinaryStream).%New()
	s streamEprData = ##Class(%GlobalBinaryStream).%New()
	s streamMethData = ##Class(%GlobalBinaryStream).%New()
	s his = ..GetHISBindData(HISBindData,AListParam,streamHisData)
	s emr = ..GetEPRBindData(EPRBindData,AListParam,streamEprData)
	s meth = ..GetMethBindData(HISMethodData,AListParam,streamMethData)   //CopyFrom(##class(EMRservice.SystemParameter).test())  
	
	d AOutMessage.Write("""items"":[")
	d AOutMessage.CopyFrom(streamHisData)
	d:((streamHisData.Size > 0)&&(streamEprData.Size >0)) AOutMessage.Write(",")
	d AOutMessage.CopyFrom(streamEprData)
	d:((AOutMessage.Size > 9)&&(streamMethData.Size >0)) AOutMessage.Write(",")
	d AOutMessage.CopyFrom(streamMethData)
	d AOutMessage.Write("]")
	s hisCount = $p(his,"@",1)
	s emrCount = $p(emr,"@",1)
	s methCount = $p(meth,"@",1)
	s errorMessage = $p(his,"@",2)_$p(emr,"@",2)_$p(meth,"@",2)
	s count = (+hisCount) + (+emrCount) + (+methCount)
	q count_"@"_errorMessage
}

/// Desc:       取方法值进行绑定
/// Creator:    
/// CreateDate: 2021-08-06
/// Input:      AHISBindCode 绑定值集合 key: Code, Value: 绑定串
///             AListParam 参数集
/// OutPut:     以Json格式返回绑定默认值
ClassMethod GetMethBindData(AHISBindCode As %ArrayOfDataTypes, AListParam As %ArrayOfDataTypes, OutMessage As %GlobalBinaryStream) As %String
{
	s stramMessage = ##Class(%GlobalBinaryStream).%New()
	s arrayObj = ##Class(%ArrayOfDataTypes).%New()
	s code = ""
	s errorMessage = ""
	for
	{
		s bindItem = AHISBindCode.GetNext(.code)
		q:(code = "")
		s tempItems = ..GetListFromString(bindItem,"#")
	    s className = $p($lg(tempItems,3),":",2)
	    s methodName = $p($lg(tempItems,4),":",2)
	    s filedName = $p($lg(tempItems,5),":",2)
	    s valueType = $p($lg(tempItems,6),":",2)
	    s tempList = arrayObj.GetAt(className_"^"_methodName)
	    s:(tempList = "") tempList = ##Class(%ListOfDataTypes).%New()
	    d tempList.Insert(filedName_"^"_valueType_"^"_code)
	    d arrayObj.SetAt(tempList,className_"^"_methodName)
	}
	s classMethodName = ""
	s count = 0
	for
	{	
		s listQueryObj = arrayObj.GetNext(.classMethodName)
		q:(classMethodName = "")
		s className = $p(classMethodName,"^",1)
		s methoName = $p(classMethodName,"^",2)
		s params = ..GetParameterString(className,methoName)
		s listParam = ..GetListFromString(params,",")
		s params = ""
		for i=1:1:$ll(listParam)
		{
			s:(i '= 1) params = params_","
			s params = params_AListParam.GetAt($lg(listParam,i))
		}
		s resultDataSet = ##Class(%GlobalBinaryStream).%New()		
		s execCode = "result=##class("_className_")."_methoName_"("_params_")"
        s @execCode
        s result = @"result" 
        while (result.AtEnd = 0)
        {
            d resultDataSet.Write($ZSTRIP(result.Read(32000),"*C",,$c(1)_$c(2)))
        }
		if (resultDataSet.Size = "0")
		{
			s errorMessage = errorMessage_className_"|"_methoName_"^"
		}
        else
        {
	        s Code = $p(listQueryObj.GetAt(1),"^",3)
			d:(stramMessage.Size > 0) stramMessage.Write(",")
			d stramMessage.Write("{""Code"":"""_Code_""",""Values"":[{""BindDesc"":""")
			d stramMessage.CopyFrom(resultDataSet)
			d stramMessage.Write("""}]}")
			s count = count + 1
        }
	}
	d OutMessage.CopyFrom(stramMessage)
	q count_"@"_errorMessage
}

/// Desc:       取HIS绑定数据
/// Creator:    Candy
/// CreateDate: 2014-3-13
/// Input:      AHISBindCode 绑定值集合 key: Code, Value: 绑定串
///             AListParam 参数集
/// OutPut:     以Json格式返回绑定默认值
ClassMethod GetHISBindData(AHISBindCode As %ArrayOfDataTypes, AListParam As %ArrayOfDataTypes, OutMessage As %GlobalBinaryStream) As %String
{
	s stramMessage = ##Class(%GlobalBinaryStream).%New()
	s arrayObj = ##Class(%ArrayOfDataTypes).%New()
	s code = ""
	s errorMessage = ""
	for
	{
		s bindItem = AHISBindCode.GetNext(.code)
		q:(code = "")
		s tempItems = ..GetListFromString(bindItem,"#")
		continue:($ll(tempItems) '= 6)
	    s className = $p($lg(tempItems,3),":",2)
	    s queryName = $p($lg(tempItems,4),":",2)
	    s filedName = $p($lg(tempItems,5),":",2)
	    s valueType = $p($lg(tempItems,6),":",2)
	    s tempList = arrayObj.GetAt(className_"^"_queryName)
	    s:(tempList = "") tempList = ##Class(%ListOfDataTypes).%New()
	    d tempList.Insert(filedName_"^"_valueType_"^"_code)
	    d arrayObj.SetAt(tempList,className_"^"_queryName)
	}
	s classQueryName = ""
	s count = 0
	for
	{
		s listQueryObj = arrayObj.GetNext(.classQueryName)
		q:(classQueryName = "")
		s className = $p(classQueryName,"^",1)
		s queryName = $p(classQueryName,"^",2)
		s params = ..GetParameterString(className,queryName)
		s listParam = ..GetListFromString(params,",")
		s params = ""
		
		for i=1:1:$ll(listParam)
		{
			// 会诊兼容 EventId取值与 ProductSourceCode
			if ((className="EMRservice.SystemData")&&(queryName = "GetConsultInfo"))
			{
				s:(i '= 1) params = params_","
				if ($lg(listParam,i)="EventID")
				{
					if (AListParam.GetAt($lg(listParam,i)) ="")
					{
						s paramsValue = AListParam.GetAt("ProductSourceCode")
						if (paramsValue'="")
						{
							s params = params_"ProductSourceCode:"_paramsValue
						}
						else
						{
							s params = params_AListParam.GetAt($lg(listParam,i))
						}
					}
					else
					{
						s params = params_AListParam.GetAt($lg(listParam,i))
					}
				}
				else
				{
					s params = params_AListParam.GetAt($lg(listParam,i))
				}
			}
			else
			{
				s:(i '= 1) params = params_","
				s params = params_AListParam.GetAt($lg(listParam,i))
			}
		}
		s resultDataSet = ..GetDataByQueryName(className,queryName,params)
		s:(resultDataSet = "") errorMessage = errorMessage_className_"|"_queryName_"^"
        continue:(resultDataSet = "")
		While resultDataSet.Next() 
		{
			for i=1:1:listQueryObj.Count()
			{
				s filedCode = listQueryObj.GetAt(i)
				continue:(filedCode = "")
				s filedName = $p(filedCode,"^",1)
				s valueType = $p(filedCode,"^",2)
				s code = $p(filedCode,"^",3)
				s value = resultDataSet.GetDataByName(filedName)
				d:(count '= 0) stramMessage.Write(",")
				s value = ##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(value)
				s value = $ZCVT(value,"O","UTF8")
				s json = ""
				if (valueType = "Dict")
				{
					s bindRowId = $p(value,"^",1)
					s bindCode = $p(value,"^",2)
					s bindDesc = $p(value,"^",3)
					s json = "{""Code"":"""_code_""",""Values"":[{""BindCode"":"""_bindCode_""",""BindDesc"":"""_bindDesc_""",""BindRowID"":"""_bindRowId_"""}]}"	
				}
				elseif (valueType = "Mono")
				{
					s bindCode = $p(value,"^",1)
					s bindDesc = $p(value,"^",2)
					s json = "{""Code"":"""_code_""",""Values"":[{""BindCode"":"""_bindCode_""",""BindDesc"":"""_bindDesc_"""}]}"
				}
				elseif (valueType = "Mult")
				{
					s count = $l(value,"|")
					s cjson = ""
					for I=1:1:count
					{
						s bindCode = $p($p(value,"|",I),"^",1)
						s bindDesc = $p($p(value,"|",I),"^",2)
						s:(count '= 1) cjson = cjson_","
						s cjson = cjson_"{""BindCode"":"""_bindCode_""",""BindDesc"":"""_bindDesc_"""}"
					}
					s json = "{""Code"":"""_code_""",""Values"":["_cjson_"]}"
				}
				else
				{
					s json = "{""Code"":"""_code_""",""Values"":[{""BindDesc"":"""_value_"""}]}"
				}
				d stramMessage.Write(json)
				s count = count + 1
			}
		}
	}
	d OutMessage.CopyFrom(stramMessage)
	q count_"@"_errorMessage
}

/// Desc:       取EPR绑定数据
/// Creator:    Candy
/// CreateDate: 2014-7-24
/// Input:      AEPRBindCode 绑定值集合 key: Code, Value: 绑定串
///             AListParam 参数集
/// OutPut:     以Json格式返回绑定默认值
ClassMethod GetEPRBindData(AEPRBindCode As %ArrayOfDataTypes, AListParam As %ArrayOfDataTypes, OutMessage As %GlobalBinaryStream) As %String
{
	s stramMessage = ##Class(%GlobalBinaryStream).%New()
	s errorMessage = ""
	s code = ""
	s count = 0
	for
	{ 
		//基本信息.新增节点.入院记录.姓名#TYPE:ICompositeSample#TID:81#SCODE:S001|CCODE:VK1|CSCODE:L010#VTYPE:V
		s bindItem = AEPRBindCode.GetNext(.code)
		q:(code = "")
		s index = $f(bindItem,"#")
		s bindItem = $e(bindItem,index,$l(bindItem))
		s episodeID = AListParam.GetAt("EpisodeID")
        
        // 门诊历史病历引用改为绑定的方式实现，引用时传到后台要引用的历史实例ID
		s lastInsID = AListParam.GetAt("LastInsID")
		// 历史实例ID不为空的情况下，就诊号取历史就诊
		if (lastInsID '= "") 
		{
			s obj = ##class(EMRinstance.InstanceData).%OpenId(lastInsID)
			s:(obj '= "") episodeID = obj.EpisodeID
		}
        
		d:(count '= 0) stramMessage.Write(",")
		s value = ##Class(EMRservice.BL.BLScatterData).GetScatterData(episodeID,bindItem,lastInsID)
		s:(value = "ERROR") errorMessage =errorMessage_bindItem_"^"
		continue:(value = "ERROR")
		s value = ##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(value)
		s value = $ZCVT(value,"O","UTF8")
		s type = $p($p(bindItem,"#",4),":",2)
		s json = ""
		if (type = "Dict")
		{
			s bindRowId = $p(value,"|",1)
			s bindCode = $p(value,"|",2)
			s bindDesc = $p(value,"|",3)
			s json = "{""Code"":"""_code_""",""Values"":[{""BindCode"":"""_bindCode_""",""BindDesc"":"""_bindDesc_""",""BindRowID"":"""_bindRowId_"""}]}"
		}
		elseif(type = "Mono")
		{
			s bindCode = $p(value,"|",1)
			s bindDesc = $p(value,"|",2)
			s json = "{""Code"":"""_code_""",""Values"":[{""BindCode"":"""_bindCode_""",""BindDesc"":"""_bindDesc_"""}]}"
		} 
		elseif(type = "Mult")
		{
			s cjson = ""
			s count = $l(value,"#")
			for I=1:1:count
			{
				s bindCode = $p($p(value,"#",I),"|",1)
				s bindDesc = $p($p(value,"#",I),"|",2)		
				s:(I '= 1) cjson = cjson_","
				s cjson = cjson_"{""BindCode"":"""_bindCode_""",""BindDesc"":"""_bindDesc_"""}"
			}
			s json = "{""Code"":"""_code_""",""Values"":["_cjson_"]}"
		}
		else
		{
			s json = "{""Code"":"""_code_""",""Values"":[{""BindDesc"":"""_value_"""}]}"
		}
		d stramMessage.Write(json)
		s count = count + 1
	}
	d OutMessage.CopyFrom(stramMessage)
	q count_"@"_errorMessage
}

/// Desc:       根据类名，方法名取其参数信息
/// Creator:    Candy
/// CreateDate: 2014-1-20  
/// Input:      AClassName 类名
///            AQueryName 参数名
/// OutPut:     retStr 参数名,参数名,参数名... 
/// Debug:   w ##Class(EMRservice.BL.BLGetDataBind).GetParameterString("EMRservice.SystemData","GetPatientInfo")
ClassMethod GetParameterString(AClassName As %String, AQueryName As %String) As %String [ WebMethod ]
{
	s retStr=""
	q:(($d(AClassName)=0)||($d(AQueryName)=0)) retStr

	s queryId = ##class(EMRservice.BL.BLBindQuery).SelectIDByClassName(AClassName,AQueryName)
	q:(queryId="") retStr

	s dataSet = ##class(%ResultSet).%New("EMRservice.BL.BLBindParameter:SelectParameterByQueryID")
	d dataSet.Execute(queryId)
	while (dataSet.Next())
	{
		if (retStr = "")
		{  
			s retStr = dataSet.Data("ParameterName")
		}
		else
		{
			s retStr = retStr_","_dataSet.Data("ParameterName")
		}	
	}
	q retStr
}

/// Desc:       取数据信息
/// Creator:    Candy
/// CreateDate: 2014-3-13  
/// Input:      AClassName 类名
///             AQueryName 参数名
/// OutPut:     query数据集合
/// Debug: d ##Class(EMRservice.BL.BLGetDataBind).GetDataByQueryName("EMRservice.SystemData","GetPatientInfo","76")
ClassMethod GetDataByQueryName(AClassName As %String, AQueryName As %String, AParameterS As %String) As %ResultSet
{
	s $ZT="ERROR"
	s tempNameSpace = $namespace
	s result = ##class(%ResultSet).%New()
	s result.ClassName = AClassName
	s result.QueryName = AQueryName
	if (AParameterS="")
	{
		d result.Execute() 
		q result
	}
	elseif (AParameterS'="") 	 
	{
		s ParaCount = $LENGTH(AParameterS,",")

		q:(ParaCount>10) 
		if (ParaCount=1)	 
		{
			d result.Execute($P(AParameterS,",",1))
		}
		elseif (ParaCount=2)	 
		{
			d result.Execute($P(AParameterS,",",1),$P(AParameterS,",",2))  
		}	 
		elseif (ParaCount=3)	 
		{
			d result.Execute($P(AParameterS,",",1),$P(AParameterS,",",2),$P(AParameterS,",",3))  
		}	 
		elseif (ParaCount=4)	 
		{
			d result.Execute($P(AParameterS,",",1),$P(AParameterS,",",2),$P(AParameterS,",",3),$P(AParameterS,",",4))  
		}	 
		elseif (ParaCount=5)	 
		{
			d result.Execute($P(AParameterS,",",1),$P(AParameterS,",",2),$P(AParameterS,",",3),$P(AParameterS,",",4),$P(AParameterS,",",5))  
		}	 
		elseif (ParaCount=6)	 
		{
			d result.Execute($P(AParameterS,",",1),$P(AParameterS,",",2),$P(AParameterS,",",3),$P(AParameterS,",",4),$P(AParameterS,",",5),$P(AParameterS,",",6))  
		}	 
		elseif (ParaCount=7)	 
		{
			d result.Execute($P(AParameterS,",",1),$P(AParameterS,",",2),$P(AParameterS,",",3),$P(AParameterS,",",4),$P(AParameterS,",",5),$P(AParameterS,",",6),$P(AParameterS,",",7))  
		}	 
		elseif (ParaCount=8)	 
		{
			d result.Execute($P(AParameterS,",",1),$P(AParameterS,",",2),$P(AParameterS,",",3),$P(AParameterS,",",4),$P(AParameterS,",",5),$P(AParameterS,",",6),$P(AParameterS,",",7),$P(AParameterS,",",8))  
		}	 
		elseif (ParaCount=9)	 
		{
			d result.Execute($P(AParameterS,",",1),$P(AParameterS,",",2),$P(AParameterS,",",3),$P(AParameterS,",",4),$P(AParameterS,",",5),$P(AParameterS,",",6),$P(AParameterS,",",7),$P(AParameterS,",",8),$P(AParameterS,",",9))  
		}	 
		elseif (ParaCount=10)	 
		{
			d result.Execute($P(AParameterS,",",1),$P(AParameterS,",",2),$P(AParameterS,",",3),$P(AParameterS,",",4),$P(AParameterS,",",5),$P(AParameterS,",",6),$P(AParameterS,",",7),$P(AParameterS,",",8),$P(AParameterS,",",9),$P(AParameterS,",",10))  
		}
		q result
	}
ERROR
	s:($namespace '= tempNameSpace) $namespace = tempNameSpace					 	        
	q ""
}

/// Desc:    将字符串返回list
/// Creator: Candy
/// Input:   AValue 串 AChar 分割符
/// ouput:   list串
/// debug: 
ClassMethod GetListFromString(AValue As %String, AChar As %String, AFlag As %String = "Y") As %List
{
	s ret = ""
	s $zt="GetListFromStringErr"
	s:$g(AChar)="" AChar=","
	s tmpVal="",tmpRet=""
	for Ind=1:1:$length(AValue,AChar)
	{
		s tmpVal = $p(AValue,AChar,Ind)
		continue:($zcvt(AFlag,"U") = "Y")&&(tmpVal = "")
		s tmpRet = tmpRet_$lb(tmpVal)
	}
	s ret = tmpRet
	q ret
GetListFromStringErr
   	q ""
}

/// d ##Class(EMRservice.BL.BLGetDataBind).Test()
ClassMethod Test()
{
	s objBand = ##Class(EMRservice.BL.BLGetDataBind).%New()
	s HISBindData = "[HIS]患者基本信息.患者姓名[字符]#TYPE:DataSet#CNAME:EMRservice.SystemData#QNAME:GetPatientInfo#FNAME:Name"
	d objBand.HISBindData.SetAt(HISBindData,"1")
	s ListParam = ##Class(%ArrayOfDataTypes).%New()
	d ListParam.SetAt(76,"EpisodeID")
	s OutMessage = ##Class(%GlobalBinaryStream).%New()
	s status = ..GetDefaultDataBind(objBand,ListParam,OutMessage)
	d OutMessage.OutputToDevice()
}

}
