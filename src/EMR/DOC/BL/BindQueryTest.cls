/// 名称:	EMR.DOC.BL.BindQueryTest
/// 描述:	通用文档管理模块 Document(Doc) 数据集测试类
/// 编写者：yejian
/// 编写日期: 2021-1-12
/// 产品组：电子病历产品组
Class EMR.DOC.BL.BindQueryTest Extends EMR.DOC.COM.ActionBase
{

/// Desc:       获取数据集测试数据
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  命令选项类型 {"params":{"action":"GET_TEST_BINDVALUES","args":{"BindQueryID":"1","Param": [{"Name":"EpisodeID","Value":"67"}]}},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetTestBindValues(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s BindQueryID = argInJson.params.args.BindQueryID
	s aParam = argInJson.params.args.Param
	s strParams= ""
	s intParamSize = aParam.%Size()
	for i=0:1:(intParamSize-1)
	{
		s jItem = aParam.%Get(i)
		s strParam = jItem.Value
		s strParams = $case(strParams,"":strParam,:strParams_","_strParam)
	}
    s strRes = ##Class(EMR.DOC.BL.BindQueryTest).GetTestBindValuesJson(BindQueryID,strParams,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR")
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       获取数据集测试数据JSON
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      aBindQueryID	数据集ID
/// 			aParam			数据集参数
/// OutPut:     argOutData		返回数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.BindQueryTest).GetTestBindValuesJson("1","67",.argOutData)
ClassMethod GetTestBindValuesJson(aBindQueryID As %String, aParams As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "-1"
	q:((aBindQueryID="")) strRes
	s objBindQuery = ##class(CF.EMR.DOC.BindQuery).%OpenId(aBindQueryID)
	q:(objBindQuery="") strRes
	s jsonArr = ##class(%DynamicArray).%New()
	s strClassName = $p(objBindQuery.QueryName,":",1)
	s strQueryName = $p(objBindQuery.QueryName,":",2)
	//实现方法为Query查询
	if (objBindQuery.BindType.Code ="Query")
	{
		s strMethodQuery = strClassName_"||"_strQueryName
		s methodQuery = ##class(%Dictionary.CompiledQuery).%ExistsId(strMethodQuery)
		q:(methodQuery="0") strRes
		s obj = ##class(%Dictionary.CompiledQuery).%OpenId(strMethodQuery)
		q:(obj="") strRes
		s colCount=$ll(obj.ColNames)
		q:(colCount<1) strRes
		s resultDataSet = ##class(EMR.DOC.BL.BindQueryTest).GetDataByQueryName(strClassName,strQueryName,aParams)
		;s:(resultDataSet = "") errorMessage = errorMessage_className_"|"_queryName_"^"
	    q:(resultDataSet = "") strRes
		While (resultDataSet.Next()) 
		{
			s strRowFid = ""
			for
			{
				s strRowFid = $o(^CF.EMR.DOC.BindFieldI("IdxBindQuery",aBindQueryID,strRowFid))
				q:(strRowFid="")
				s jsonQuery  = ##class(%DynamicObject).%New()
				s objFiled = ##class(CF.EMR.DOC.BindField).%OpenId(strRowFid)
				q:(objFiled="")
				s value = resultDataSet.GetDataByName(objFiled.BindFiled)
				s jsonQuery.Code =objFiled.BindFiled
	    		s jsonQuery.Name =objFiled.Name
	    		s jsonQuery.Value =value
				d jsonArr.%Push(jsonQuery)
			}
		}
		
	}
	elseif(objBindQuery.BindType.Code ="ClassMethod")
	{
		
	}			
	d jsonArr.%ToJSON(argOutData)
	s strRes = "1"
	q strRes
}

/// Desc:       取数据信息
/// Creator:    yejian
/// CreateDate: 2021-2-4  
/// Input:      AClassName 类名
///             AQueryName 参数名
/// OutPut:     query数据集合
/// Debug: w ##Class(EMR.DOC.BL.BindQueryTest).GetDataByQueryName("EMRservice.SystemData","GetPatientInfo","67")
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

}
