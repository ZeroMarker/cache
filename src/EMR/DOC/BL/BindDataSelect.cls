/// 名称:	EMR.DOC.BL.BindDataSelect
/// 描述:	通用文档管理模块 Document(Doc) 数据绑定查询业务类
/// 编写者：yejian
/// 编写日期: 2021-1-12
/// 产品组：电子病历产品组
Class EMR.DOC.BL.BindDataSelect Extends EMR.DOC.COM.ActionBase
{

Property HISBindData As %ArrayOfDataTypes;

Property EPRBindData As %ArrayOfDataTypes;

/// Desc:       取绑定数据
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  	命令参数 {"action":"LOAD_DEFAULT_FIELD","params":{"bindparams":{"DateTimeFormat":"yyyy-MM-ddHH:mm:ss","DiseaseID":"0","EpisodeID":"67","EventID":"","EventType":"","HappenDateTime":"2021-04-2915:10:59","TemplateID":"1","TemplateVersionID":"1","DocumentID":"-1","PatientID":"61","Title":"日常病程记录","TitleCode":"EMR100002","UserLocID":"315"},"items":[{"bindCode":"[HIS]用户自定义信息.医院名称[字符]#TYPE:DataSet#CNAME:EMR.DOC.HISInterface.SystemData#QNAME:GetCustomInfo#FNAME:HospitalName#VALUETYPE:","bindType":"DataBase","code":"Header_V001_L0009"},{"bindCode":"[HIS]患者出入院信息.当前科室字符[字符]#TYPE:DataSet#CNAME:EMR.DOC.HISInterface.SystemData#QNAME:GetATDInfo#FNAME:CurDeptDesc#VALUETYPE:","bindType":"DataBase","code":"Header_V001_L0004"},{"BindCode":"入院记录.患者基本信息..年龄#TYPE:ICompositeSample#TID:1#SCODE:S001|CCODE:V003|CSCODE:L0003#VTYPE:V","BindType":"EPR","Code":"S001_V004_L0003"},{"bindCode":"[HIS]患者基本信息.患者姓名[字符]#TYPE:DataSet#CNAME:EMR.DOC.HISInterface.SystemData#QNAME:GetPatientInfo#FNAME:Name#VALUETYPE:","bindType":"DataBase","code":"Header_V001_L0001"},{"bindCode":"[HIS]患者基本信息.住院病案号[字符]#TYPE:DataSet#CNAME:EMR.DOC.HISInterface.SystemData#QNAME:GetPatientInfo#FNAME:IPRecordNo#VALUETYPE:","bindType":"DataBase","code":"Header_V001_L0007"}]},"product":"OP"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod LoadDefaultField(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s outMessage = ##Class(%GlobalBinaryStream).%New()
	s listParam = ##Class(%ArrayOfDataTypes).%New()
	s objBand = ##Class(EMR.DOC.BL.BindDataSelect).%New()
	s strProductCode = argInJson.product
	//解析参数，存入数组中
	s bindParams = argInJson.params
	s bindIterator =bindParams.%GetIterator()
	while bindIterator.%GetNext(.key , .value) {
		s strKey =$zcvt(key,"U")
		continue:(strKey = "ITEMS")
	    d listParam.SetAt(value,strKey)
	} 
	s itemsArr = argInJson.params.items
	s count = itemsArr.%Size()
	//解析传入的绑定数据
	s itemIterator =itemsArr.%GetIterator()
    while itemIterator.%GetNext(.index , .jItem){
	    s code = jItem.code
	    s bindCode = jItem.bindCode
	    continue:((bindCode="")||(code=""))
	    s bindType = $case(bindCode,"":"Query",:$p($p(bindCode,"#",2),":",2))
	    //[HIS]患者基本信息.患者姓名#BINDTYPE:Query#QueryName:EMR.DOC.HISInterface.SystemData:GetPatientInfo#BindFiled:Name#ValueType:Text
	    d:(bindType = "Query") objBand.HISBindData.SetAt(bindCode,code)
	    //入院记录.患者基本信息..年龄#BINDTYPE:EMR#TYPE:ICompositeSample#TID:1#SCODE:S001|CCODE:V003|CSCODE:L0003#VTYPE:V"
	    d:(bindType = "EMR") objBand.EPRBindData.SetAt(bindCode,code)
	}
	
	//取绑定值
	s result = ##Class(EMR.DOC.BL.BindDataSelect).GetDefaultDataBind(objBand,listParam,.argOutData)
	s okCount = $p(result,"@",1)
	s failCount = count - okCount
	if (failCount = 0) 
	{
		 q argOutMessage.success = ..#OK
	}
	else
	{
		s failure = $p(result,"@",2)
		s strFailure = "count:"_count_"^failCount:"_failCount_"^failure:"_failure
		q ..SetOutMessage(argOutMessage,"OK",strFailure,2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       取模板绑定值
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      ABaseBindCode 数据绑定集合 Key: Code,Value：EMR.DOC.BL.BindDataSelect 属性有 HISBindData(HIS数据绑定)EPRBindData(电子病历数据绑定)
///             AListParam 参数值集合 key 参数名称 ,Value: 参数值
/// OutPut:     OutMessage 返回数据绑定值的item items:[{ "Code":"1^S01_H02_S.001","DataBaseBindCode":"默认值","EPRBindCode":"1"} ,{…}]}          
ClassMethod GetDefaultDataBind(ABaseBindCode As EMR.DOC.BL.BindDataSelect, AListParam As %ArrayOfDataTypes, ByRef AOutData As %GlobalBinaryStream) As %String
{
	s count = 0
	s HISBindData = ABaseBindCode.HISBindData
	s EPRBindData = ABaseBindCode.EPRBindData
	
	s streamHisData =  ##Class(%GlobalBinaryStream).%New()
	s streamEprData = ##Class(%GlobalBinaryStream).%New()
	s jsonData = ##class(%DynamicObject).%New()
	//获取HIS数据绑定
	s his = ..GetHISBindData(HISBindData,AListParam,.jsonData)
	//获取实例数据绑定
	s emr = ..GetEPRBindData(EPRBindData,AListParam,.jsonData)
	d:(jsonData.%Size()>0) jsonData.%ToJSON(AOutData)
	s hisCount = $p(his,"@",1)
	s emrCount = $p(emr,"@",1)
	s errorMessage = $p(his,"@",2)_$p(emr,"@",2)
	s count = (+hisCount) + (+emrCount)
	q count_"@"_errorMessage
}

/// Desc:       取HIS绑定数据
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      AHISBindCode 绑定值集合 key: Code, Value: 绑定串
///             AListParam 参数集
/// OutPut:     以Json格式返回绑定默认值
ClassMethod GetHISBindData(AHISBindCode As %ArrayOfDataTypes, AListParam As %ArrayOfDataTypes, ByRef objJson As %DynamicObject) As %String
{
	
	s arrayObj = ##Class(%ArrayOfDataTypes).%New()
	s code = ""
	s errorMessage = ""
	for
	{
		s bindItem = AHISBindCode.GetNext(.code)
		q:(code = "")
		s tempItems = ..GetListFromString(bindItem,"#")
		continue:($ll(tempItems) '= 5)
	    s className = $p($lg(tempItems,3),":",2)
	    s queryName = $p($lg(tempItems,3),":",3)
	    s filedName = $p($lg(tempItems,4),":",2)
	    s valueType = $p($lg(tempItems,5),":",2)
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
			s:(i '= 1) params = params_","
			s strParam = $lg(listParam,i)
			s strParam = $zcvt(strParam,"U")
			s params = params_AListParam.GetAt(strParam)
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
				;s value = ##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(value)
				;s value = $ZCVT(value,"O","UTF8")
				s objArr  = ##class(%DynamicArray).%New()
				s objItem  = ##class(%DynamicObject).%New()
				s objChecked = ##class(%DynamicObject).%New()
				s json = ""
				//如果值为空，字典、单选、多选、下拉，直接返回空[]
				if (value="")&&((valueType = "List")||(valueType = "RadioGroup")||(valueType = "Checkbox")||(valueType = "Select"))
				{
					d objChecked.%Set("checked",[])
					d objJson.%Set(code,objChecked)
				}
				elseif (valueType = "List")
				{
					s objItem.id = $p(value,"^",1)
					s objItem.value = $p(value,"^",2)
					s objItem.text = $p(value,"^",3)
					d objArr.%Push(objItem)
					d objChecked.%Set("checked",objArr)
					d objJson.%Set(code,objChecked)
				}
				elseif (valueType = "RadioGroup")
				{
					s count = $l(value,"^")
					s objItem.id = $case(count,3:$p(value,"^",1),:"")
					s objItem.value = $case(count,3:$p(value,"^",2),:$p(value,"^",1))
					s objItem.text = $case(count,3:$p(value,"^",3),:$p(value,"^",2))
					d objArr.%Push(objItem)
					d objChecked.%Set("checked",objArr)
					d objJson.%Set(code,objChecked)
				}
				elseif ((valueType = "Checkbox")||(valueType = "Select"))
				{
					s count = $l(value,"|")
					s objArr = ##class(%DynamicArray).%New()
					for I=1:1:count
					{
						s nValue=$p(value,"|",I)
						s count = $l(nValue,"^")
						s objItem.id = $case(count,3:$p(nValue,"^",1),:"")
						s objItem.value = $case(count,3:$p(nValue,"^",2),:$p(nValue,"^",1))
						s objItem.text = $case(count,3:$p(nValue,"^",3),:$p(nValue,"^",2))
						d objArr.%Push(objItem)
					}
					d objChecked.%Set("checked",objArr)
					d objJson.%Set(code,objChecked)
				}
				elseif (valueType = "Link")
				{
					//增加链接单元的绑定数据
					s objArr = ##class(%DynamicArray).%New()
					if (value'="")
					{
						s objArr = [].%FromJSON(value)
						d objChecked.%Set("checked",objArr)
					}
					else
					{
						s objChecked=""
					}
					d objJson.%Set(code,objChecked)
				}
				else
				{
					s objItem.text = value
					d objJson.%Set(code,objItem)
				}
				s count = count + 1
			}
		}
	}
	q count_"@"_errorMessage
}

/// Desc:       取单个HIS绑定数据
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      AHISBindCode 绑定值集合 key: Code, Value: 绑定串
///             jsonParam 参数集
/// OutPut:     以Json格式返回绑定默认值
/// Debug:		s jsonParam ={"templateID":"76","episodeID":"4","userCode":"ys01"}
/// 			s arrData = ##class(%DynamicArray).%New()
/// 			w ##class(EMR.DOC.BL.BindDataSelect).GetHISBindDataValue("[HIS]患者基本信息.患者姓名#BINDTYPE:Query#QueryName:EMR.DOC.HISInterface.SystemData:GetPatientInfo#BindFiled:Name#ValueType:Text",jsonParam,.arrData)
ClassMethod GetHISBindDataValue(ACode As %String, AHISBindCode As %String, AListParam As %ArrayOfDataTypes, ByRef objJson As %DynamicObject) As %String
{
	s $zt = "Error"
	s strRes = "1"
	s code = ACode
	s errorMessage = ""
	
	s tempItems = ..GetListFromString(AHISBindCode,"#")
	q:($ll(tempItems) '= 5)
    s className = $p($lg(tempItems,3),":",2)
    s queryName = $p($lg(tempItems,3),":",3)
    s filedName = $p($lg(tempItems,4),":",2)
    s valueType = $p($lg(tempItems,5),":",2)
	
	s params = ..GetParameterString(className,queryName)
	s listParam = ..GetListFromString(params,",")
	s params = ""
	for i=1:1:$ll(listParam)
	{
		s:(i '= 1) params = params_","
		s strParam = $lg(listParam,i)
		s strParam = $zcvt(strParam,"U")
		s params = params_AListParam.GetAt(strParam)
	}
	s resultDataSet = ..GetDataByQueryName(className,queryName,params)
	s:(resultDataSet = "") errorMessage = errorMessage_className_"|"_queryName_"^"
	While resultDataSet.Next() 
	{
		s value = resultDataSet.GetDataByName(filedName)
		s objArr  = ##class(%DynamicArray).%New()
		s objItem  = ##class(%DynamicObject).%New()
		if (valueType = "List")
		{
			s bindRowId = $p(value,"^",1)
			s bindCode = $p(value,"^",2)
			s bindDesc = $p(value,"^",3)
			s objItem.bindCode=bindCode
			s objItem.bindDesc=bindDesc
			s objItem.bindRowID=bindRowId
			d objArr.%Push(objItem)
			s objJson.code =code
			s objJson.values = objArr
		}
		elseif (valueType = "RadioGroup")
		{
			s bindCode = $p(value,"^",1)
			s bindDesc = $p(value,"^",2)
			s objItem.bindCode=bindCode
			s objItem.bindDesc=bindDesc
			d objArr.%Push(objItem)
			s objJson.code =code
			s objJson.values = objArr
			
		}
		elseif ((valueType = "Checkbox")||(valueType = "Select"))
		{
			s count = $l(value,"|")
			for I=1:1:count
			{
				s bindCode = $p($p(value,"|",I),"^",1)
				s bindDesc = $p($p(value,"|",I),"^",2)
				s objItem  = ##class(%DynamicObject).%New()
				s objItem.bindCode=bindCode
				s objItem.bindDesc=bindDesc
				d objArr.%Push(objItem)
			}
			s objJson.code =code
			s objJson.values = objArr
		}
		else
		{
			s objItem.bindDesc=value
			d objArr.%Push(objItem)
			s objJson.code =code
			s objJson.values = objArr
		}
		q
	}
	q strRes
Error
	q "-1"_errorMessage
}

/// Desc:       取EPR绑定数据
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      AEPRBindCode 绑定值集合 key: Code, Value: 绑定串
///             AListParam 参数集
/// OutPut:     以Json格式返回绑定默认值
ClassMethod GetEPRBindData(AEPRBindCode As %ArrayOfDataTypes, AListParam As %ArrayOfDataTypes, ByRef arrJson As %DynamicArray) As %String
{
	;s stramMessage = ##Class(%GlobalBinaryStream).%New()
	
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
		s episodeID = AListParam.GetAt("EPISODEID")
		s value = ##Class(EMR.DOC.BL.GlossaryAchieveValue).GetScatterData(episodeID,bindItem,"")
		s:(value = "ERROR") errorMessage =errorMessage_bindItem_"^"
		continue:(value = "ERROR")
		;s value = ##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(value)
		s value = $ZCVT(value,"O","UTF8")
		s type = $p($p(bindItem,"#",4),":",2)
		s objjson  = ##class(%DynamicObject).%New()
		s objArr  = ##class(%DynamicArray).%New()
		s objItem  = ##class(%DynamicObject).%New()
		if (type = "Dict")
		{
			s bindRowId = $p(value,"|",1)
			s bindCode = $p(value,"|",2)
			s bindDesc = $p(value,"|",3)
			s objjson.code =code
			s objItem.bindCode=bindCode
			s objItem.bindDesc=bindDesc
			s objItem.bindRowID=bindRowId
			d objArr.%Push(objItem)
			s objjson.values = objArr
		}
		elseif(type = "Mono")
		{
			s bindCode = $p(value,"|",1)
			s bindDesc = $p(value,"|",2)
			s objjson.code =code
			s objItem.bindCode=bindCode
			s objItem.bindDesc=bindDesc
			d objArr.%Push(objItem)
			s objjson.values = objArr
		} 
		elseif(type = "Mult")
		{
			s cjson = ""
			s count = $l(value,"#")
			for I=1:1:count
			{
				s bindCode = $p($p(value,"#",I),"|",1)
				s bindDesc = $p($p(value,"#",I),"|",2)		
				s objItem  = ##class(%DynamicObject).%New()
				s objItem.bindCode=bindCode
				s objItem.bindDesc=bindDesc
				d objArr.%Push(objItem)
			}
			s objjson.code =code
			s objjson.values = objArr
		}
		else
		{
			s objjson.code =code
			s objItem.bindDesc=value
			d objArr.%Push(objItem)
			s objjson.values = objArr
		}
		s count = count + 1
		d arrJson.%Push(objjson)
	}
	q count_"@"_errorMessage
}

/// Desc:       根据类名，方法名取其参数信息
/// Creator:    yejian
/// CreateDate: 2020-12-7 
/// Input:      AClassName 类名
///            AQueryName 参数名
/// OutPut:     retStr 参数名,参数名,参数名... 
/// Debug:   w ##Class(EMR.DOC.BL.BindDataSelect).GetParameterString("EMRservice.SystemData","GetPatientInfo")
ClassMethod GetParameterString(AClassName As %String, AQueryName As %String) As %String [ WebMethod ]
{
	s retStr=""
	q:(($d(AClassName)=0)||($d(AQueryName)=0)) retStr

	s queryId = ##class(EMR.DOC.BL.BindQuery).SelectIDByClassName(AClassName,AQueryName)
	q:(queryId="") retStr

	s dataSet = ##class(%ResultSet).%New("EMR.DOC.BL.BindParameter:SelectParameterByQueryID")
	d dataSet.Execute(queryId)
	while (dataSet.Next())
	{
		if (retStr = "")
		{  
			s retStr = dataSet.Data("Code")
		}
		else
		{
			s retStr = retStr_","_dataSet.Data("Code")
		}	
	}
	q retStr
}

/// Desc:       取数据信息
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      AClassName 类名
///             AQueryName 参数名
/// OutPut:     query数据集合
/// Debug: d ##Class(EMR.DOC.BL.BindDataSelect).GetDataByQueryName("EMRservice.SystemData","GetPatientInfo","76")
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
/// Creator:    yejian
/// CreateDate: 2020-12-7
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

/// d ##Class(EMR.DOC.BL.BindDataSelect).Test()
ClassMethod Test()
{
	s objBand = ##Class(EMR.DOC.BL.BindDataSelect).%New()
	s HISBindData = "[HIS]患者基本信息.患者姓名[字符]#TYPE:DataSet#CNAME:EMR.OP.HISInterface.SystemData#QNAME:GetLabInfo#FNAME:Name"
	s EPRBindData="基本信息.新增节点.入院记录.姓名#TYPE:ISECTIONDESC#TID:172#SCODE:S1663812513675|CSCODE:SI1663812528318#VTYPE:V"
	d objBand.HISBindData.SetAt(HISBindData,"1")
	d objBand.EPRBindData.SetAt(EPRBindData,"1")
	s ListParam = ##Class(%ArrayOfDataTypes).%New()
	d ListParam.SetAt(1175,"EPISODEID")
	s OutMessage = ##Class(%GlobalBinaryStream).%New()
	s status = ..GetDefaultDataBind(objBand,ListParam,OutMessage)
	d OutMessage.OutputToDevice()
}

}
