/// ************************************************************
/// * Class Name:	EPRservice.Quality.DataAccess.BOQualityPool
/// * Description:	Quality pool related BO
/// * Author:		Zuoxiang Xie
/// * Create Date:	2010-04-26
/// * Version:
/// ************************************************************/
Class EPRservice.Quality.DataAccess.BOQualityPool Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/qualityservice";

Parameter SERVICENAME = "QualityPoolInfo";

///  *****************************************************
///  功能：根据多种条件查询相应质控规则和质控项目并分页
///  入参：AType为质控规则类型（E：完整性规则；U：一致性规则）
///  	   ARuleID为质控标准RowID
///  	   AStructID为质控病历结构RowID（目的是为了加载该病历结构下的所有质控项目）
///  	   ATemplateID为质控模板单元RowID，可以加载属于某模板下的质控项目（只有完整性规则和项目需要）
/// 	   AIsRuleFirst为是否选择质控标准优先（1：质控标准优先；0：质控病历目录结构优先）
/// 	   AIsNewQuery代表是否为新查询（1：新查询；0：旧查询，分页用）
/// 	   APageNum为页码，取第几页的数据
/// 	   APageSize为每页记录数
/// 	   AResultCount为记录总条数
/// 	   AUniqueGlobalID为一个唯一的标志位，相当于Web中的Session，从前端传过来的是一个GUID
///  *****************************************************
ClassMethod GetPoolByMultiParams(AType As %String, ARuleID As %String, AStructID As %String, ATemplateID As %String, AIsRuleFirst As %String, AIsNewQuery As %String, APageNum As %String, APageSize As %String, ACode As %String, ByRef AResultCount As %String, ByRef AUniqueGlobalID As %String) As EPRservice.dataset.Quality.EQualityPoolDataset [ WebMethod ]
{
	// Check parameters
	if (ARuleID=$C(0))
	{
		s ARuleID=""	
	}
	if (AStructID=$C(0))
	{
		s AStructID=""	
	}
	if (ATemplateID=$C(0))
	{
		s ATemplateID=""	
	}
	
	// Get count of all records and write records to ^CacheTempDHCEPRQualityPool
	s AResultCount = ##Class(EPRmeta.Quality.QualityPool).GetQualityPoolsOrEntries(AType, ARuleID, AStructID, ATemplateID, AIsRuleFirst, AIsNewQuery, AUniqueGlobalID,ACode)
	
	// Get result set of pools or entries
	s result = ##Class(EPRservice.dataset.Quality.EQualityPoolDataset).%New()
	d result.SetArgs(APageNum,APageSize,AResultCount,.AUniqueGlobalID)
	q result
}

///  *****************************************************
///  功能：根据质控规则ID获取质控规则
///  入参：APoolID为质控规则ID
///  结论：质控规则对象
ClassMethod GetQualityPoolByID(APoolID As %String) As EPRservice.entity.Quality.EQualityPool [ WebMethod ]
{
	s objPool = ##class(EPRmeta.Quality.QualityPool).%OpenId(APoolID)
	q:(objPool = "") ""
	
	s pool = ##class(EPRservice.entity.Quality.EQualityPool).%New()
	s pool.ID = objPool.%Id()
	s pool.Code = objPool.Code
	s pool.Title = objPool.Title
	s pool.Expression = objPool.Expression
	s pool.IsActive = objPool.IsActive
	s pool.Type = objPool.Type
	s pool.ResumeText = objPool.ResumeText
	
 	q pool
}

ClassMethod KillPoolTempGlobal(AUniqueGlobalID As %String) As %String [ WebMethod ]
{
	s ret=0
	q:(AUniqueGlobalID="") ret
	if ($d(^CacheTempDHCEPRQualityPool(AUniqueGlobalID)))
	{
		k ^CacheTempDHCEPRQualityPool(AUniqueGlobalID)
		s ret=1	
	}
	q ret
}

/// **************************************************
/// 功能：新增或更新质控模板单元  QualityTemplate
/// 入参：InString，待增加或修改的模板单元信息
/// 结论：成功返回RowID，不成功返回0
/// **************************************************
ClassMethod UpdateQualityElement(AElement As EPRservice.entity.Quality.EQualityTemplate)
{
	TSTART
	if (AElement.ID="")
	{
		s objElement=##Class(EPRmeta.Quality.QualityTemplate).%New()
	}
	else
	{
		s objElement=##Class(EPRmeta.Quality.QualityTemplate).%OpenId(AElement.ID)
	}
	s objElement.TemplateId=AElement.TemplateId
	s objElement.ElementCode=AElement.ElementCode
    s objElement.NormalName=AElement.NormalName
    s objElement.SimpleName=AElement.SimpleName
    s objElement.IsNull=AElement.IsNull
    s objElement.IsActive=AElement.IsActive
    s objElement.LUDateTime=AElement.LUDateTime
    s objElement.ResumeText=AElement.ResumeText
    
    if '(objElement.%Save())
 	{
 		TROLLBACK
 		q "0"
 	} 
 	TCOMMIT
 	q objElement.%Id()
}

/// **************************************************
/// 功能： 创建或更新质控规则  QualityPool
/// 入参：InString，待增加或修改的质控规则信息
/// 结论：成功返回RowID，不成功返回0
/// 调试：##Class(EPRservice.Quality.DataAccess.BOQualityPool).UpdateQualityPool()
/// **************************************************
ClassMethod CreateQualityPool(APool As EPRservice.entity.Quality.EQualityPool) As %String [ WebMethod ]
{
	set ret=-1
	s flag = ..CheckPoolCodeExist(APool.Code)
	q:flag>0 ret
	
	TStart
	s objPool=##class(EPRmeta.Quality.QualityPool).%New()

	s objPool.Code=APool.Code					
	s objPool.Title=APool.Title       			
    s objPool.Expression=APool.Expression                  
    s objPool.IsActive=APool.IsActive  					
    s objPool.Type=APool.Type  						
    s objPool.ResumeText=APool.ResumeText 
    s objPool.IsQuery = APool.IsQuery 				

    if '(objPool.%Save())
 	{
 		TROLLBACK
 		q "0"
 	} 
 	TCOMMIT
 	q objPool.%Id()
}

/// w ##Class(EPRservice.Quality.DataAccess.BOQualityPool).CheckPoolCodeExist("U001")
ClassMethod CheckPoolCodeExist(APoolCode As %String) As %Integer
{
	s count = 0
 	&sql(SELECT COUNT(Code) INTO:count FROM EPRmeta_Quality.QualityPool WHERE Code = :APoolCode)
 	q count
}

ClassMethod UpdateQualityPool(APool As EPRservice.entity.Quality.EQualityPool) As %String [ WebMethod ]
{
	TSTART
	s objPool=##class(EPRmeta.Quality.QualityPool).%OpenId(APool.ID)

	s objPool.Code=APool.Code					
	s objPool.Title=APool.Title       			
    s objPool.Expression=APool.Expression                  
    s objPool.IsActive=APool.IsActive  					
    s objPool.Type=APool.Type  						
    s objPool.ResumeText=APool.ResumeText
    s objPool.IsQuery = APool.IsQuery   //Add by Candy  				

    if '(objPool.%Save())
 	{
 		TROLLBACK
 		q "0"
 	} 
 	TCOMMIT
 	q objPool.%Id()
}

ClassMethod DeleteQualityPool(APoolID As %String) As %Boolean [ WebMethod ]
{
	TStart
	s pool = ##Class(EPRmeta.Quality.QualityPool).%OpenId(APoolID)
	q:(pool = "") 0
	
	if '(pool.%DeleteId(APoolID))
 	{
	 	TRollBack
	 	q 0	
	}
	TCommit
	q 1
}

/// Desc:		批量导入界面模板单元到质控模板单元表QualityTemplate和质控规则库QualityPool中
/// Input:		AStream 为包含模板单元的自定义字符流
/// ModifyDate:  2013-04-3 修改增加模板元素后能导入功能 by Candy
/// ModityDate:  2014-10-8 增加EMR单元导入 by Candy
ClassMethod SyncQualityUnit(AStream As EPRservice.entity.ReStreamData, AType As %String) As %String [ WebMethod ]
{
	s item = "", count = 0
	q:((AType = "")||(AType = $c(0))) count
	d AStream.StreamData.Rewind()
	While (AStream.StreamData.AtEnd = 0)
	{
		s char = AStream.StreamData.Read(1)
		if (char '= "%")
		{
			s item = item_char
		}
		else
		{
			s item = ##Class(EPRservice.Quality.CommonHelper).ChangeStorageChar(item)
			s TemplateID = $p(item,"^",3)			//模板Id
			s ElementName = $p(item,"^",4)			//模板单元名称
			s ElementCode = $p(item,"^",5)			//模板单元代码
			s ElementCode = "#TYPE:"_$p(ElementCode,"#TYPE:",2)	
			s:((TemplateID = "")||(ElementName = "")||(ElementCode = "")) item = ""
			continue:(item = "")
			
			if (AType '= "EMR")
			{
				s objTemplate = ##Class(EPRmeta.Template).%OpenId(TemplateID)	
			}
			else
			{
				s objTemplate = ##Class(EMRmeta.Template).%OpenId(TemplateID)
			}
			s:(objTemplate = "") item = ""
			continue:(item = "")
			s CategoryID = objTemplate.TemplateCategoryID
			s StructID = $o(^DHCEPRM.QualityStructI("IdxCategoryIdType"," "_CategoryID," "_AType,""))
			s:(StructID = "") item = ""
			continue:(item = "")
			
			s TemplateName = objTemplate.Name
			s StructAlias = $list(^DHCEPRM.QualityStructD(StructID),1)
			s SimpleName = $p(StructAlias,".",1)_"."_TemplateName_"."_ElementName
			s ResumeText = StructID_"#"_StructAlias
			s IsNull = "N"							//是否允许为空，“N”代表不允许为空，“Y”代表允许为空
			s IsActive = "Y"						//是否有效
			s LUDateTime = $ZD($H,3)				//更新时间，默认为当前时间，格式为：“2010-05-12”
            
            s ElementId = $o(^DHCEPRM.QualityTemplateI("IdxElementCode",ElementCode,""))
			if (ElementId = "")
	        {
		        s objElement=##Class(EPRmeta.Quality.QualityTemplate).%New()
				s objElement.TemplateId = TemplateID
				s objElement.ElementCode = ElementCode
				s objElement.NormalName = ElementName
				s objElement.SimpleName = SimpleName
				s objElement.IsNull = IsNull
				s objElement.IsActive = IsActive
				s objElement.ResumeText = ResumeText        
		        
	        }else
	        {
		        s objElement=##Class(EPRmeta.Quality.QualityTemplate).%OpenId(ElementId)
				s:(objElement = "") item = ""
				continue:(item = "")
				
				s:(objElement.NormalName = ElementName) item = ""
				continue:(item = "")
				
				s objElement.TemplateId = TemplateID
				s objElement.ElementCode = ElementCode
				s objElement.NormalName = ElementName			//模板单元名称
				s objElement.SimpleName = SimpleName			//模板单元标准名称        
		    }
		    
		    TSTART
		    s rcElement = objElement.%Save()
		    s:($$$ISERR(rcElement)) item = ""
		    continue:(item = "")
		    
		    s ElementId = objElement.%Id()
			s TempId = $case(AType="EMR",1:"M"_ElementId,:"E"_ElementId)

			if ($d(^DHCEPRM.QualityPoolD(TempId)))
			{
				//与该模板单元关联的质控规则存在，则更新质控规则，暂时只做Title更新
				s objPool=##class(EPRmeta.Quality.QualityPool).%OpenId(TempId)
				s objPool.Code = TempId
				s objPool.Title = SimpleName_"未填写，请及时完成！"
			}
			else
			{
				//不存在，则做插入操作
				s objPool=##class(EPRmeta.Quality.QualityPool).%New()	
				s objPool.Code = TempId
				s objPool.Title = SimpleName_"未填写，请及时完成！"
				if (AType '= "EMR")
				{
					s objPool.Expression = "##Class(EPRservice.Quality.CheckRule.Template).IsSaveElement(EpisodeID,"""_ElementId_""",InstanceID)"
				}
				else
				{
					s objPool.Expression = "##Class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsSaveElement(EpisodeID,"""_ElementId_""",InstanceID)"					
				}
				s objPool.IsActive = "Y"
				s objPool.Type = "E"
				s objPool.ResumeText = $C(0)
			}
			s rcPool = objPool.%Save()
	        if ($$$ISERR(rcPool))
	        {
		        TROLLBACK
		        s item = ""
		        continue
		    }else
		    {
			    TCOMMIT
			}
			s item = ""
		    s count = count+1
		}
	}
	d AStream.%Close()
	q count
}

///  功能：根据完整性节点ID获取元素路径代码(SCode_CCode_CSCode)
///  入参：AElementID为质控完整性检查点元素ID集合(多个用"\"分隔)
///  结论：元素路径代码(多个用"#"分隔)
///  test：##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode("10007\10008")
ClassMethod GetElementCode(AElementIDs As %String) As %String
{
	s result=""
	for I=1:1:$l(AElementIDs,"\")
	{
		s ElementID=$p(AElementIDs,"\",I)
		
		//模板单元对象
		s objQualityTemplate = ##Class(EPRmeta.Quality.QualityTemplate).%OpenId(ElementID)
		continue:(objQualityTemplate = "")
		continue:($zcvt(objQualityTemplate.IsActive,"U") '= "Y")
		
		s ElementItem = objQualityTemplate.ElementCode
		continue:(ElementItem = "")
		
		s ItemList = ##Class(EMRservice.Tools.Tool).GetListFromString(ElementItem,"#")
		continue:($ll(ItemList) '= 4)
		
		s TemplateID = $p($lg(ItemList,2),":",2)
		s ItemCode = $lg(ItemList,3)
		s SCode = $zcvt($p($p(ItemCode,"|",1),":",2),"U")
		s CCode = $zcvt($p($p(ItemCode,"|",2),":",2),"U")
		s CSCode = $zcvt($p($p(ItemCode,"|",3),":",2),"U")
		
		s:(result'="") result=result_"#"_SCode_"_"_CCode_"_"_CSCode
		s:(result="") result=SCode_"_"_CCode_"_"_CSCode
	}
 	q result
}

/// d ##Class(%ResultSet).RunQuery("EPRservice.Quality.DataAccess.BOQualityPool","GetQualityPools")	
Query GetQualityPools(Rule, Struct) As %Query(ROWSPEC = "rowId,score,active,structDesc,vetoGrade,title")
{
}

ClassMethod GetQualityPoolsExecute(ByRef qHandle As %Binary, Rule = "", Struct = "") As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	//查询已开启的质控条目
	
	s ruleId=""
	
	for
	{
		s ruleId=$o(^DHCEPRM.QualityEntryI("IdxRuleDR",ruleId))
		q:(ruleId="")
		continue:($tr(ruleId," ","")'=Rule)&&(Rule'="")
		
		s rowId=""
		
		for
		{
			s rowId=$o(^DHCEPRM.QualityEntryI("IdxRuleDR",ruleId,rowId))
			q:(rowId="")
			
			s objEntry=##class(EPRmeta.Quality.QualityEntry).%OpenId(rowId)
			
			s score=objEntry.Score
			
			s active=objEntry.IsActive
			;continue:(active="N")
			
			s structId=objEntry.StructDR
			
			continue:(structId'=Struct)&&(Struct'="")
			
			s vetoGrade=objEntry.VetoGrade
			
			s objPool=##class(EPRmeta.Quality.QualityPool).%OpenId(objEntry.PoolDR)
			
			s title=$replace(objPool.Title," ","")
			
			s structDesc=##class(EPRmeta.Quality.QualityStruct).%OpenId(structId).StandardName
			
			s structDesc=$replace(structDesc," ","")
			
			s Data=$lb(rowId,score,active,structDesc,vetoGrade,title)
			
			s ^CacheTemp(repid,ind) = Data
			
			s ind = ind + 1
			
			
		}
	}
	
	Quit $$$OK
}

ClassMethod GetQualityPoolsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetQualityPoolsExecute ]
{
	s repid = $list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

ClassMethod GetQualityPoolsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetQualityPoolsExecute ]
{
	s AtEnd = $list(qHandle,1)
 	s repid = $list(qHandle,2)
 	s ind = $list(qHandle,3)
 	
 	s ind = $o(^CacheTemp(repid,ind))
 	if (ind = "") 
 	{
 		s AtEnd = 1
 		s Row = ""
 		k ^CacheTemp(repid)
 	} 
 	else 
 	{	
 		s Row = ^CacheTemp(repid,ind)
 	}
 	s qHandle = $lb(AtEnd,repid,ind)
	q $$$OK
}

///  功能：根据完整性节点ID获取元素章节代码
///  入参：AElementID为质控完整性检查点元素ID集合(多个用"\"分隔)
/// ##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(11343)
ClassMethod GetElementSCode(AElementIDs As %String)
{
	s result=""
	for I=1:1:$l(AElementIDs,"\")
	{
		s ElementID=$p(AElementIDs,"\",I)
		
		//模板单元对象
		s objQualityTemplate = ##Class(EPRmeta.Quality.QualityTemplate).%OpenId(ElementID)
		continue:(objQualityTemplate = "")
		continue:($zcvt(objQualityTemplate.IsActive,"U") '= "Y")
		
		s ElementItem = objQualityTemplate.ElementCode
		continue:(ElementItem = "")
		
		s ItemList = ##Class(EMRservice.Tools.Tool).GetListFromString(ElementItem,"#")
		continue:($ll(ItemList) '= 4)
		
		s TemplateID = $p($lg(ItemList,2),":",2)
		s ItemCode = $lg(ItemList,3)
		s SCode = $zcvt($p($p(ItemCode,"|",1),":",2),"U")

		s:(result'="") result=result_$c(0)_SCode
		s:(result="") result=SCode
	}
 	q result
}

}
