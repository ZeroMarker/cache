/// 名称:EMRservice.InterfaceService.GetRecrodSessionDesc
/// 描述:获取三版病历章节的text
/// 编写者：wangyu
/// 编写日期: 2021-03-26
Class EMRservice.InterfaceService.GetRecrodSessionDesc Extends %RegisteredObject
{

/// Creator：      编写者：wangyu
/// CreatDate：    2021-03-26
/// Description:   三版病历根据InstanceID和元素或者章节的Code取病历的元素或者章节的描述
/// Table：        
/// Input：        Stream :模板数据流,实例数据流
/// Return：       节点流数据 (metadata,sctipts,PresentationData)
/// Others：       其它说明
/// Debug:         w ##Class(EMRservice.InterfaceService.GetRecrodSessionDesc).getEMRRecrodtext("218||2","L0001")
ClassMethod getEMRRecrodtext(argInstanceID As %String, argSessionCode As %String) As %String
{
	/*
	s DisplayName = ""
	q:(argInstanceID = "")||(argSessionCode = "") DisplayName
	s ACode = $e(argSessionCode,1)
	s objInstance = ##class(EMRinstance.InstanceData).%OpenId(argInstanceID)
	q:(objInstance = "") DisplayName
	q:(objInstance.Status '= "Save") DisplayName
	s streamScatterData = ##Class(EMRservice.Parser.StreamData).ParserStream(objInstance.InstanceData,"<ScatterData>","</ScatterData>","14")
	s sc =##class(%XML.XPATH.Document).CreateFromStream(streamScatterData,.scatterData)
	q:($$$ERROR(sc)) recrodSession
	s sc = scatterData.EvaluateExpression("/ScatterData/Component","count(Section)",.sections)
	q:($$$ERROR(sc)||(sections.GetAt(1)="")) DisplayName
	s count = sections.GetAt(1).Value
	for i=1:1:count
	{
		set sc=scatterData.EvaluateExpression("/ScatterData/Component/Section["_i_"]/Code","@Code",.result)
		continue:($$$ERROR(sc)||(result.GetAt(1)=""))	
		s Code = result.GetAt(1).Value
		if (Code = argSessionCode) 
		{
			set sc=scatterData.EvaluateExpression("/ScatterData/Component/Section["_i_"]/Code","@DisplayName",.result)
			continue:($$$ERROR(sc)||(result.GetAt(1)=""))	
			s DisplayName = result.GetAt(1).Value
		}
		elseif ((ACode '="S")&&(ACode '="H")&&(ACode '="F"))
		{
			
			s xmlItem = ..getXmlType(ACode)
			s sc = scatterData.EvaluateExpression("/ScatterData/Component/Section["_i_"]/Composite/SubItems","count("_xmlItem_")",.result)
			continue:($$$ERROR(sc)||(result.GetAt(1)=""))
			s total = result.GetAt(1).Value
			for j=1:1:total
			{
				set sc=scatterData.EvaluateExpression("/ScatterData/Component/Section["_i_"]/Composite/SubItems/"_xmlItem_"["_j_"]/Code","@Code",.result)
				continue:($$$ERROR(sc)||(result.GetAt(1)=""))		
				s Code = result.GetAt(1).Value
				continue:(Code '= argSessionCode)
				set sc=scatterData.EvaluateExpression("/ScatterData/Component/Section["_i_"]/Composite/SubItems/"_xmlItem_"["_j_"]/Code","@DisplayName",.result)
				continue:($$$ERROR(sc)||(result.GetAt(1)=""))		
				s DisplayName = result.GetAt(1).Value
			}	
		}	
		
	}
	q DisplayName
	*/
	s DisplayName = ""
	s DisplayName = ##class(EMRservice.InterfaceService.EMRRecordInfo).GetElementtNameByCode(argInstanceID, argSessionCode)
	q DisplayName
}

ClassMethod getXmlType(ACode As %String)
{
		
		if (ACode = "L")
		{
			s Xmltype = "MIString"	
		}
		elseif (ACode = "I")
		{
			s Xmltype = "MIDictionary"
		}
		elseif (ACode = "S")
		{
			s Xmltype = "MIString"
		}
		elseif (ACode = "D")
		{	
		s Xmltype = "MIDateTime"			
			
		}			
		elseif (ACode = "H")
		{	
		s Xmltype = "MILink"			
			
		}
		elseif (ACode = "N")
		{
			s Xmltype = "MINumber"				
		}			
		elseif (ACode = "O")
		{
			s Xmltype = "MIMonoChoice"		
		}
		elseif (ACode = "E")
		{
			s Xmltype = "MITextDesc"		
		}
		elseif(ACode = "G")
		{
			s Xmltype = "MISegment"
		}
		q Xmltype
}

}
