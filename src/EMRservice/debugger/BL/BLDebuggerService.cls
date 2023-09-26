Class EMRservice.debugger.BL.BLDebuggerService Extends %RegisteredObject
{

/// 增加
ClassMethod SaveData(Class As %String, Code As %String, Description As %String, IsActive As %String, Method As %String, Name As %String, Parameter As %String, Type As %String)
{
	s tmpID=""
	s tmpID = $o(^DHCEMRI.DebuggerConfigI("IdxCode"," "_$zcvt(Code,"U"),tmpID))
	if (tmpID="")
	{
		s objConfig=##Class(EMRinstance.debugger.DebuggerConfigData).%New()
	}
	else
	{
		s objConfig=##Class(EMRinstance.debugger.DebuggerConfigData).%OpenId(tmpID)
	}

	s objConfig.ClassName = Class
	s objConfig.Code = Code
	s objConfig.Description = Description
	s objConfig.IsActive = IsActive
	s objConfig.MethodName = Method
	s objConfig.Name = Name
	s objConfig.Parameter = Parameter
	s objConfig.Type = Type
	
	d objConfig.%Save()
	d objConfig.%Close()
	s objConfig=""
}

/// 删除
ClassMethod DeleteData(Code As %String)
{
	s ret="0"
	s tmpID=""
	s tmpID = $o(^DHCEMRI.DebuggerConfigI("IdxCode"," "_Code,tmpID))
	if (tmpID="")
	{
		q ret
	}
	else
	{
		s objConfig=##Class(EMRinstance.debugger.DebuggerConfigData).%OpenId(tmpID)
	}
	
	s objConfig.Expression = "N"
	
	d objConfig.%Save()
	d objConfig.%Close()
	s objConfig=""
}

/// 获取所有数据
ClassMethod GetConfigData() As %String
{
	s json=[]
	s ret="0"
	s tmpID=""
	for
	{
		s tmpID = $o(^DHCEMRI.DebuggerConfigD(tmpID))
		q:(tmpID="")
		s obj = ##class(EMRinstance.debugger.DebuggerConfigData).%OpenId(tmpID)
		s IsActive = obj.IsActive
		continue:(IsActive="N")
		s Name = obj.Name
		s Description = obj.Description
		s Code = obj.Code
		s Parames = obj.Parameter
		s class = obj.ClassName
		s method = obj.MethodName
	
		
		s jsonsub = {}
		s jsonsub.name = Name
		s jsonsub.description = Description_class_" "_method
		s jsonsub.code = Code 
		s jsonsub.parames = Parames
		//s jsonsub.expression = Expression
		
		d json.%Push(jsonsub)
	}
	q json.%ToJSON()
}

/// 解析函数
/// w ##class(EMRservice.debugger.BL.BLDebuggerService).GetResultData("LisInterface4","4,@,@")
ClassMethod GetResultData(InteraceCode As %String, ParamesValueString As %String = "") As %String
{
	s json=[]
	s ParamesValueString = $replace(ParamesValueString,"@","""""")
	
	s ret="0"
	s tmpID=""
	for
	{
		s tmpID = $o(^DHCEMRI.DebuggerConfigI("IdxCode"," "_$zcvt(InteraceCode,"U"),tmpID))
		q:(tmpID="")
		
		s obj = ##class(EMRinstance.debugger.DebuggerConfigData).%OpenId(tmpID)
		s IsActive = obj.IsActive
		continue:(IsActive="N")
		s Name = obj.Name
		s Description = obj.Description
		s Code = obj.Code
		
		s class = obj.ClassName
		s method = obj.MethodName
		s paramesInfo = obj.Parameter
		
		s ParamesValueList = $lfs(ParamesValueString,",")
		
		if ($find(paramesInfo,"Date")'=0)
		{
			for i=1:1:$l(paramesInfo,",")
			{
				s argInfo = $p(paramesInfo,",",i)
				if argInfo["Date"
				{
					s $list(ParamesValueList,i) = $zdh($list(ParamesValueList,i),3)
				}
			}	
		}

		s ParamesValueString = $lts(ParamesValueList,",")
		s type = obj.Type
		
		if (type="Query")
		{
			s Expression = "result = ##class(%ResultSet).%New("""_class_":"_method_""")"
			s @Expression
			
			s result = @"result"
			
			s ExpressionExe = "sc = result.Execute("""_$replace(ParamesValueString,",",""",""")_""")"
			
			s @ExpressionExe
			
			s sc=@"sc"
			
			
			
		}
		elseif (type="method")
		{
			s Expression = "result = ##class("_class_")."_method_"("""_$replace(ParamesValueString,",",""",""")_""")"
			d @Expression
			s result = @"result"
		}

		s qrnumber=0
		while (result.Next())
		{
			
			
			s qrnumber=+$g(qrnumber)+1
			for i = 1:1:result.GetColumnCount()
			{
				s jsonsub = {}
				
			   	s key = result.GetColumnName(i)
			   
			   	s jsonsub.qrnumber= qrnumber
				s jsonsub.key = key
				s jsonsub.value = result.Data(key)
				
				d json.%Push(jsonsub)
				
	
			}
			
		}
	}
	q json.%ToJSON()
}

/// 绑定数据获取
/// w ##class(EMRservice.debugger.BL.BLDebuggerService).GetBindQueryData()
ClassMethod GetBindQueryData()
{
	s json=[]
	s ret="0"
	s tmpID=""
	for
	{
		s tmpID = $o(^DHCEMRM.BindQueryD(tmpID))
		q:(tmpID="")
		s obj = ##class(EMRmeta.BindQuery).%OpenId(tmpID)
		
		s Name = obj.Name
		s Description = obj.Description
		s Code = tmpID
		s ClassName = obj.ClassName
		s QueryName = obj.QueryName

		s jsonsub = {}
		s jsonsub.name = Name
		s jsonsub.description = Description_ClassName_" "_QueryName
		s jsonsub.code = Code
		
		//获取参数 QueryID
		s Parames=""
		s bfparameterid=""
		for
		{
			s bfparameterid=$o(^DHCEMRM.BindParameterD(bfparameterid))
			q:(bfparameterid="")
			
			s objparameter = ##class(EMRmeta.BindParameter).%OpenId(bfparameterid)
			s queryid = objparameter.QueryID
			continue:(queryid'=Code)
			
			s paramterName = objparameter.ParameterName
			s description = objparameter.Description
			
			s:(Parames'="") Parames = Parames_","_paramterName_":"_description
			s:(Parames="") Parames = paramterName_":"_description
			
		}
		s jsonsub.parames = Parames

		
		d json.%Push(jsonsub)
	}
	q json.%ToJSON()
}

/// 解析函数
/// w ##class(EMRservice.debugger.BL.BLDebuggerService).GetBindResultData("2","4")
ClassMethod GetBindResultData(InteraceCode As %String, ParamesValueString As %String = "") As %String
{
	s json=[]
	s ParamesValueString = $replace(ParamesValueString,"@","""""")
	
	s ret="0"
		
	s obj = ##class(EMRmeta.BindQuery).%OpenId(InteraceCode)
	s class = obj.ClassName
	s method = obj.QueryName

	s Expression = "result = ##class(%ResultSet).%New("""_class_":"_method_""")"
	s @Expression
		
	s result = @"result"	
	s ExpressionExe = "sc = result.Execute("_ParamesValueString_")"	
	s @ExpressionExe
	s sc=@"sc"
		
	while (result.Next())
	{
	
		for i = 1:1:result.GetColumnCount()
		{
			s jsonsub = {}
		   	s key = result.GetColumnName(i)   
			s jsonsub.key = key
			s keydesc = ..GetKeyDesc(InteraceCode,key)
			s jsonsub.keydesc = keydesc
			s jsonsub.value = result.Data(key)	
			d json.%Push(jsonsub)		
		}	
	}
	q json.%ToJSON()
}

ClassMethod GetKeyDesc(QueryID, QueryField) As %String
{
	s keyDesc=""
	s fieldId=""
	for
	{
		s fieldId = $o(^DHCEMRM.BindFieldD(fieldId))
		q:(fieldId="")
		
		s obj = ##class(EMRmeta.BindField).%OpenId(fieldId)
		s queryId = obj.QueryID
		continue:(queryId'=QueryID)
		s fieldName = obj.FieldName
		continue:(fieldName'=QueryField)
		s keyDesc = obj.Name
		q
	}	
	q keyDesc
}

/// d ##class(EMRservice.debugger.BL.BLDebuggerService).Init()
ClassMethod Init()
{
	//检验接口HSBToHis
	s class="web.DHCENS.STBLL.Method.PostReportInfo"
	s code = "LisInterface1"
	s desc = "检验接口（HSBToHis），集成平台提供标准版检查检验通"
	s isactive = "Y"	
	s method = "SelectLISItemListByDate"
	s name = "检验接口（HSBToHis）"
	s paramter ="EpisodeID:患者就诊号,Date1:查询起始日期,Date2:查询结束日期"
	s type = "Query"
	d ..SaveData(class,code,desc,isactive,method,name,paramter,type)
	
	
	//检验接口HSBToHis结果明细
	s class="web.DHCENS.STBLL.Method.PostReportInfo"
	s code = "LisInterface1Sub"
	s desc = "检验接口（HSBToHis），集成平台提供标准版检查检验通"
	s isactive = "Y"	
	s method = "SelectLISReportByOeordID"
	s name = "检验接口（HSBToHis）结果明细"
	s paramter ="OeordID:检验医嘱ID"
	s type = "Query"
	d ..SaveData(class,code,desc,isactive,method,name,paramter,type)
	
	
	//检查接口HSBToHis
	s class="web.DHCENS.STBLL.Method.PostReportInfo"
	s code = "PacsInterface1"
	s desc = "检查接口（HSBToHis），集成平台提供标准版检查检验通"
	s isactive = "Y"	
	s method = "SelectPACSItemListByDate"
	s name = "检查接口（HSBToHis）"
	s paramter ="EpisodeID:患者就诊号,Date1:查询起始日期,Date2:查询结束日期"
	s type = "Query"
	d ..SaveData(class,code,desc,isactive,method,name,paramter,type)
	

	//检查接口HSBToHis结果明细
	s class="web.DHCENS.STBLL.Method.PostReportInfo"
	s code = "PacsInterface1Sub"
	s desc = "检查接口（HSBToHis），集成平台提供标准版检查检验通"
	s isactive = "Y"	
	s method = "SelectReportByOeordID"
	s name = "检查接口（HSBToHis）结果明细"
	s paramter ="OeordID:检查医嘱ID"
	s type = "Query"
	
	d ..SaveData(class,code,desc,isactive,method,name,paramter,type)
	
	//----------------------------------------------------------------------
	//----------------------------------------------------------------------
	
	//检验接口（HIS）
	s class="DHCLabToEPR.DHCLabTestSetQuery"
	s code = "LisInterface2"
	s desc = "检验接口（HIS），检验组直接提供病历接口"
	s isactive = "N"	
	s method = "SelectLISItemListByDate"
	s name = "检验接口（HIS）"
	s paramter ="EpisodeID:患者就诊号,Date1:查询起始日期,Date2:查询结束日期"
	s type = "Query"
	d ..SaveData(class,code,desc,isactive,method,name,paramter,type)
	
	//检验接口（HIS）结果明细
	s class="DHCLabToEPR.DHCLabTestSetQuery"
	s code = "LisInterface2Sub"
	s desc = "检验接口（HIS），检验组直接提供病历接口"
	s isactive = "N"	
	s method = "SelectReportByOeordID"
	s name = "检验接口（HIS）结果明细"
	s paramter ="OeordID:检验医嘱ID"
	s type = "Query"
	d ..SaveData(class,code,desc,isactive,method,name,paramter,type)
	
	
	//检查接口（HIS）
	s class="web.DHCRisclinicQueryEPR"
	s code = "PacsInterface2"
	s desc = "检查接口（HIS），PACS组直接提供病历接口"
	s isactive = "N"	
	s method = "SelectPACSItemListByDate"
	s name = "检查接口（HIS）"
	s paramter ="EpisodeID:患者就诊号,Date1:查询起始日期,Date2:查询结束日期"
	s type = "Query"
	d ..SaveData(class,code,desc,isactive,method,name,paramter,type)
	
	
	//检查接口（HIS）结果明细
	s class="web.DHCRisclinicQueryEPR"
	s code = "PacsInterface2Sub"
	s desc = "检查接口（HIS），PACS组直接提供病历接口"
	s isactive = "N"	
	s method = "SelectReportByOeordID"
	s name = "检查接口（HIS）结果明细"
	s paramter ="OeordID:检查医嘱ID"
	s type = "Query"
	d ..SaveData(class,code,desc,isactive,method,name,paramter,type)
}

}
