/// 名称：		EPRservice.BOGlossary
/// 描述：		术语服务类
/// 编写者：	HouJ
/// 编写时间：	2008-06-26
Class EPRservice.BOGlossary Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "GlossaryInfo";

/// Creator:	HouJ
/// CreatDate:	2008-06-26
/// Desc:		创建术语
/// Table：		EPRmeta.Glossary，EPRmeta.GlossaryCategory
/// Input：		aEGlossary 术语实体对象
/// Return：	术语Id	
ClassMethod CreateGlossary(AEGlossary As EPRservice.entity.EGlossary) As %String [ WebMethod ]
{
	s ret = ""
	
	// 检查术语GUID是否唯一
	s existed = ##Class(EPRmeta.Glossary).SelectByGUID(AEGlossary.GUID)
	q:(existed '= "") ret
	
	// 检查InternalID是否已经存在
	s id = ..GetIDByInternalID(AEGlossary.InternalID,AEGlossary.GlossaryCategoryID)
	q:(id '= "") ret
	
	s $zt = "OnCreateErrorHandler"
	
	TSTART
	
	// 创建Glossary
	s objGlossary = ##Class(EPRmeta.Glossary).%New()
	q:(objGlossary = "") ret
	
	s objGlossary.Name = AEGlossary.Name
	s objGlossary.Description = AEGlossary.Description
	s objGlossary.GUID = AEGlossary.GUID
	s objGlossary.GlossaryCategoryID = AEGlossary.GlossaryCategoryID
	s objGlossary.CreateDate = $piece($HOROLOG,",",1)
	s objGlossary.CreateTime = $piece($HOROLOG,",",2)
	s objGlossary.LastModifyDate = $piece($HOROLOG,",",1)
	s objGlossary.LastModifyTime = $piece($HOROLOG,",",2)
	s objGlossary.GlossaryType = AEGlossary.GlossaryType
	s objGlossary.ParentID = AEGlossary.ParentID
	s objGlossary.InternalID = AEGlossary.InternalID
	s objGlossary.MetaID = AEGlossary.MetaID
	
	if ('objGlossary.%Save())
	{	
		TROLLBACK
		q ret
	}
	
	if (AEGlossary.GlossaryCategoryID '= "")&&(AEGlossary.GlossaryCategoryID '= $c(0))
	{
		s flag = ..AddCategoryChildCount(AEGlossary.GlossaryCategoryID,1)
		if (flag = 0)
		{
			TROLLBACK
			q ret
		}
	}
	
	TCOMMIT
	
	s ret = objGlossary.%Id()
	q ret
	
OnCreateErrorHandler
	TROLLBACK
	q ret
}

/// Creator:	HouJ
/// CreatDate:	2008-06-26
/// Desc:		删除术语
/// Table：		EPRmeta.Glossary，EPRmeta.GlossaryCategory
/// Input：		aGlossaryId：要删除的术语Id
/// Return：	"0":删除失败	"1":删除成功	
ClassMethod DeleteGlossary(AGlossaryID As %String) As %Boolean [ WebMethod ]
{
	s ret = 0
	q:($d(AGlossaryID) = "") ret
	
	s objGlossary = ##Class(EPRmeta.Glossary).%OpenId(AGlossaryID)
	q:(objGlossary = "") ret

	TSTART
	
	if (objGlossary.GlossaryCategoryID '= "")&&(objGlossary.GlossaryCategoryID '= $C(0))
	{
		s flag = ..AddCategoryChildCount(objGlossary.GlossaryCategoryID,-1)
		if (flag = 0)
		{
			TROLLBACK
			q ret	
		}	
	}
	
	// 删除Glossary
	s isSucceed = ##Class(EPRmeta.Glossary).%DeleteId(AGlossaryID)
	if ('isSucceed)
	{
		TROLLBACK
		q ret
	}
	
	TCOMMIT
	
	s ret = 1
	q ret
}

/// Creator:	HouJ
/// CreatDate:	2008-06-26
/// Desc:		查询某术语范畴下的所有术语
/// Input：		aCategoryID：术语范畴Id
/// Return：	EPRservice.dataset.EGlossaryDataset: 术语集dataset
ClassMethod SelectAllGlossaryByCategoryID(aCategoryID) As EPRservice.dataset.EGlossaryDataset [ WebMethod ]
{
	set result = ##Class(EPRservice.dataset.EGlossaryDataset).%New()
	Do result.SetArgs(aCategoryID)
	
	quit result
}

/// Creator:	Kumon Xie
/// CreatDate:	2011-09-13
/// Desc:		查询某术语的所有子术语
/// Input：		AParentID：父术语RowID
/// Return：	EPRservice.dataset.EGlossarySubDataset: 子术语集dataset
ClassMethod GetSubGlossariesByParentID(AParentID As %String) As EPRservice.dataset.EGlossarySubDataset [ WebMethod ]
{
	s result = ##Class(EPRservice.dataset.EGlossarySubDataset).%New()
	d result.SetArgs(AParentID)
	
	q result
}

/// Creator:	Kumon Xie
/// CreatDate:	2011-09-13
/// Desc:		查询某术语的所有子术语
/// Input：		AParentID：父术语RowID
/// Return：	EPRservice.dataset.EGlossarySubDataset: 子术语集dataset
ClassMethod GetSubGlossaries() As %XML.DataSet [ WebMethod ]
{
	s result=##class(%XML.DataSet).%New("EPRservice.BOGlossary:GetSubGlossaries")
	d result.SetArgs()
	q result
}

/// Debug:	d ##Class(%ResultSet).RunQuery("EPRmeta.Glossary","GetSubGlossariesByParentID",19)
Query GetSubGlossaries() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,Name:%String,Description:%String,GUID:%String,GlossaryCategoryID:%String,GlossaryType:%String,InternalID:%String,MetaID:%String,ParentID:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_Glossary_SelectAllByParentID, SqlProc ]
{
	select ID,Name,Description,GUID,GlossaryCategoryID,GlossaryType,InternalID,MetaID,ParentID
	from EPRmeta.Glossary
	order by ID
}

/// Creator:	Kumon Xie
/// CreatDate:	2011-09-13
/// Desc:		查询所有术语集
/// Input：		AParentID：父术语RowID
/// Return：	EPRservice.dataset.EGlossarySubDataset: 子术语集dataset
ClassMethod GetAllGlossarys() As EPRservice.dataset.EGlossaryAllDataset [ WebMethod ]
{
	s result = ##Class(EPRservice.dataset.EGlossaryAllDataset).%New()
	d result.SetArgs()
	
	q result
}

/// Creator:	HouJ
/// CreatDate:	2008-06-26
/// Desc:		由术语Id取得术语对象
/// Input：		aGlossaryId：术语Id
/// Return：	EPRservice.entity.EGlossary：术语实体对象
ClassMethod SelectGlossaryById(aGlossaryId As %String) As EPRservice.entity.EGlossary [ WebMethod ]
{
	s objGlossary = ##Class(EPRmeta.Glossary).%OpenId(aGlossaryId)
	q:(objGlossary = "") ""
	
	s objEGlossary = ##Class(EPRservice.entity.EGlossary).%New()
	q:(objEGlossary = "") ""
	        
	s objEGlossary.ID = objGlossary.%Id()
	s objEGlossary.Name = objGlossary.Name
	s objEGlossary.Description = objGlossary.Description
	s objEGlossary.GUID = objGlossary.GUID
	s objEGlossary.GlossaryCategoryID = objGlossary.GlossaryCategoryID
	s objEGlossary.CreateDate = objGlossary.CreateDate
	s objEGlossary.CreateTime = objGlossary.CreateTime
	s objEGlossary.LastModifyDate = objGlossary.LastModifyDate
	s objEGlossary.LastModifyTime = objGlossary.LastModifyTime
	s objEGlossary.GlossaryType = objGlossary.GlossaryType
	s objEGlossary.ParentID = objGlossary.ParentID
	s objEGlossary.InternalID = objGlossary.InternalID
	s objEGlossary.MetaID = objGlossary.MetaID
	
	q objEGlossary
}

/// 	Creator:	HouJ
/// 	CreatDate:	2008-06-26
/// 	Desc:		更新术语
/// 	Input：		aEGlossary：术语实体对象
/// 	Return：	"0": 更新失败,  "1": 更新成功
ClassMethod UpdateGlossary(AEGlossary As EPRservice.entity.EGlossary) As %Boolean [ WebMethod ]
{
	s ret = 0
	s objGlossary = ##Class(EPRmeta.Glossary).%OpenId(AEGlossary.ID)
	q:(objGlossary = "") ret

	TSTART
	
	s oldCategoryID = objGlossary.GlossaryCategoryID
	s curCategoryID = AEGlossary.GlossaryCategoryID

	if (oldCategoryID '= "")&&(oldCategoryID '= $c(0))
	{
		s flag = ..AddCategoryChildCount(oldCategoryID,-1)
		if (flag = 0)
		{
			TROLLBACK
			q ret	
		}
		if (curCategoryID '= "")&&(curCategoryID '= $c(0))
		{
			s flag = ..AddCategoryChildCount(curCategoryID,+1)
			if (flag = 0)
			{
				TROLLBACK
				q ret	
			}	
		}	
	}
	else
	{
		if (curCategoryID '= "")&&(curCategoryID '= $c(0))
		{
			s flag = ..AddCategoryChildCount(curCategoryID,+1)
			if (flag = 0)
			{
				TROLLBACK
				q ret	
			}	
		}	
	}
	
	// 更新Glossary信息
	s objGlossary.Name = AEGlossary.Name
	s objGlossary.Description = AEGlossary.Description
	s objGlossary.GUID = AEGlossary.GUID
	s objGlossary.GlossaryCategoryID = AEGlossary.GlossaryCategoryID
	s objGlossary.CreateDate = AEGlossary.CreateDate
	s objGlossary.CreateTime = AEGlossary.CreateTime
	s objGlossary.LastModifyDate = $piece($HOROLOG,",",1)
	s objGlossary.LastModifyTime = $piece($HOROLOG,",",2)
	s objGlossary.GlossaryType = AEGlossary.GlossaryType
	s objGlossary.ParentID = AEGlossary.ParentID
	s objGlossary.InternalID = AEGlossary.InternalID
	s objGlossary.MetaID = AEGlossary.MetaID
	
	if ('objGlossary.%Save())
	{
		TROLLBACK
		q ret
	}
	
	TCOMMIT
	
	s ret = 1
	q ret
}

/// debug:	w ##Class(EPRservice.BOGlossary).AddCategoryChildCount(127,1)
ClassMethod AddCategoryChildCount(AGlossaryCategoryID As %String, AChildCount As %Integer) As %Integer
{
	q:(AGlossaryCategoryID = "")||(AGlossaryCategoryID = $c(0)) 1
	
	s ret = 0
	
	s objCategory = ##Class(EPRmeta.GlossaryCategory).%OpenId(AGlossaryCategoryID)
	q:(objCategory = "") ret

	s objCategory.ResChildCount = objCategory.ResChildCount + $g(AChildCount)
	q:('objCategory.%Save()) ret
	
	s ret = 1
	q ret
}

ClassMethod GetIDByInternalID(InternalID As %String, GlossaryCategoryID As %String) As %String
{
	q:""=InternalID ""
	s id=""
	s id=$O(^DHCEPRM.GlossaryI("IdxInternalID", " "_InternalID, " "_GlossaryCategoryID,id),1)
    q id
}

/// w ##Class(EPRservice.BOGlossary).CheckInternalID("55","55")
ClassMethod CheckInternalID(AGlossaryID As %String, AInternalID As %String) As %String [ WebMethod ]
{
	q:(AInternalID="")||(AInternalID=$C(0)) "内部标识符不能为空"
	 
	q:(AGlossaryID="")||(AGlossaryID=$C(0)) "" //AGlossaryID为空，ok
	s obj = ##Class(EPRmeta.Glossary).%OpenId(AGlossaryID)
	s GlossaryCategoryID =  obj.GlossaryCategoryID
	
	s id = $O(^DHCEPRM.GlossaryI("IdxInternalID"," "_AInternalID," "_GlossaryCategoryID,""))
	if (id = "")
	{
		//内部标识符不存在, OK
		q ""
	}
	else
	{
		if (id = AGlossaryID)
		{
			//内部标识符存在且属于当前术语范畴, OK
			q ""
		}
		else
		{
			s obj = ##Class(EPRmeta.Glossary).%OpenId(id)
			q "内部标识符与["_obj.Name_"]冲突!"
		}
	}
}

/// Creator:	Kumon Xie
/// Desc:		打散现有术语项目(最多只能执行一次,并手工清除三个备份临时Global)
/// Debug:		d ##Class(EPRservice.BOGlossary).BatchMigrationGlossaryItems()
ClassMethod BatchMigrationGlossaryItems()
{
	//第一步：备份存储术语的三个Global，迁移成功后再K掉
	if ($d(^CacheTempEPR("GlossaryD")) = 0)
	{ m ^CacheTempEPR("GlossaryD") = ^DHCEPRM.GlossaryD }
	if ($d(^CacheTempEPR("GlossaryI")) = 0)
	{ m ^CacheTempEPR("GlossaryI") = ^DHCEPRM.GlossaryI }
	if ($d(^CacheTempEPR("GlossaryS")) = 0)
	{ m ^CacheTempEPR("GlossaryS") = ^DHCEPRM.GlossaryS }
			
	TSTART
	
	//第二步：为新增的GlossaryType和ParentID赋初值;
	//目前项目上的GlossaryType只有模板单元术语,所以GlossaryType设置为TG;
	//目前项目上的没有知识库单元术语,所以ParentID设置为"";
	//(如果整个迁移操作失败,有可能是这里引起的原因,表太大,不能批量执行,那么可选的方案是:
	//注释下面的SQL操作语句,将其放到WinSQL中去执行,在后面增加WHERE条件,比如WHERE ID<2000
	//每次执行2000条Glossary的初始化
	&sql(update EPRmeta.Glossary set GlossaryType = 'TG',ParentId = '')
	
	//第三步：将原有存储于Glossary中的项目流打散存储到GlossaryItem表和GlossaryKBItem表中去
	//目前现有项目上仅存在界面模板单元术语，即只需要存储到GlossaryItem表中
	//这里是遍历整个Glossary表,如果数据量过大会给服务器带来一定压力
	s rowID = ""
	for {
		s rowID = $o(^DHCEPRM.GlossaryD(rowID))
		q:(rowID = "")
		
		s objGlossary = ##Class(EPRmeta.Glossary).%OpenId(rowID)
		if (objGlossary = "")
		{
			w "RowID = " + rowID + "的术语为空",!
			continue	
		}
		else
		{	
			s itemStream = objGlossary.MetaItemData
			continue:(itemStream.SizeGet() = 0)
			
			s sc = ##Class(%XML.TextReader).ParseStream(itemStream, .reader)
			if ($$$ISOK(sc))
			{
 				s item = ""
 				while(reader.Read())
 				{
	 				if ((reader.NodeType = "element")&&(reader.Name = "Item"))
					{
						if (reader.Read())
						{
							s item = reader.Value
							if (item '= "")
							{
								// 门诊现病史既往史(通用).现病史#TYPE:TextDesc#TID:77#TVER:0#ECODE:E0056
								// 住院病历.病史.一般情况.通用模板.住院号.值#TYPE:Simple#TID:704#TVER:0#SCODE:S0075#VTYPE:V
								// 首次病程记录.病例特点.通用模板.年龄特点.值#TYPE:SegmentSimple#TID:822#TVER:0#TCODE:G0001#SCODE:O0010#VTYPE:V
								s itemName = $p(item,"#",1)

								s code = $e(item,$l(itemName)+1,$l(item))
								 
								s tIndex = $f(code,"#TID:")
								s vIndex = $f(code,"#TVER:") 
								s templateID = $e(code,tIndex,vIndex-7)
								
								s itemCode = ""
								s eIndex = $f(code,"#ECODE:")
								s gIndex = $f(code,"#GCODE:")
								s dIndex = $f(code,"#TCODE:")
								s sIndex = $f(code,"#SCODE:")
								if (eIndex > 0)
								{
									s itemCode = $e(code,eIndex,eIndex+4)	
								}
								if (gIndex > 0)
								{
									s itemCode = $e(code,gIndex,gIndex+4)	
								}
								if (dIndex > 0)
								{
									s itemCode = $e(code,dIndex,dIndex+4)	
								}
								if (sIndex > 0)
								{
									s tmpCode = $e(code,sIndex,sIndex+4)
									if (itemCode '= "")
									{
										s itemCode = itemCode + "." + tmpCode	
									}
									else
									{
										s itemCode = tmpCode	
									}	
								}
								
								s vType = "V"
								s vTypeIndex = $f(code, "#VTYPE:")
								if (vTypeIndex > 0)
								{
									s vType = $e(code, vTypeIndex, $L(code))
								}
								
								s objItem = ##Class(EPRmeta.GlossaryItem).%New()
								s objItem.GlossaryID = rowID
								s objItem.TemplateID = templateID
								s objItem.ItemCode = itemCode
								s objItem.ItemName = itemName
								s objItem.ValueType = vType
								
								d objItem.%Save()
							}
						}	
		 			}
	 			}	
 			}
 			else
 			{
	 			TROLLBACK
	 			w "无法解析RowID = " + rowID + "的术语!",!
	 			q
	 		}	
		}	
	}
	
	//第四步：由于在Glossary表中新增了IdxCategoryID和IdxParentID,所以需要更新索引^DHCEPRM.GlossaryI
	//由于已经打散了Glossary项目的存储,所以原先存储Glossary项目的流^DHCEPRM.GlossaryS清除
	k ^DHCEPRM.GlossaryI
	k ^DHCEPRM.GlossaryS
	
	//第五步：如果P7需要手工给EPRmeta.Glossary表重建索引
	//如果是P8,则可在Terminal下执行一下语句：
	//d ##Class(EPRmeta.Glossary).%BuildIndices()
	//
	//
	//
	TCOMMIT
	
	w "迁移完毕,SUCCESS!",!
	q

ErrorHandler
	TROLLBACK
	w "捕获异常信息:"_$zerror,!
	q
}

/*
/// w ##Class(EPRservice.BOGlossary).TestCreateGlossary()
ClassMethod TestCreateGlossary() As %String
{
	s entity = ##Class(EPRservice.entity.EGlossary).%New()
	s entity.ChildCount = "0"
	s entity.CreateDate = ""
	s entity.CreateTime = ""
	s entity.Description = ""
	s entity.GlossaryCategoryID = ""
	s entity.GlossaryType = "KG"
	s entity.GUID = "957c4f40-c9ef-4b3c-bb9a-785a92f21160"
	s entity.LastModifyDate = ""
	s entity.LastModifyTime = ""
	s entity.Name = "知识库型数据集测试"
	s entity.ParentID = "10"
	s status = ..CreateGlossary(entity)
	q status
}
*/
}
