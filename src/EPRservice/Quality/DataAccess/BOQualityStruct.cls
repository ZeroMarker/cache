/// ************************************************************
/// * Class Name:	EPRservice.Quality.DataAccess.BOQualityStruct
/// * Description:	质控病历结构服务类
/// * Author:		Zuoxiang Xie
/// * Create Date:	2010-04-26
/// * Version:
/// ************************************************************/
Class EPRservice.Quality.DataAccess.BOQualityStruct Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/qualityservice";

Parameter SERVICENAME = "QualityStructInfo";

/// Function:	Get all quality structs
ClassMethod SelectAllQualityStruct() As EPRservice.dataset.Quality.EQualityStructDataset [ WebMethod ]
{
	s result = ##class(EPRservice.dataset.Quality.EQualityStructDataset).%New()
	q result
}

/// Desc: Get all quality ordered structs
/// add by Candyxu  
ClassMethod SelectAllOrderStruct() As EPRservice.dataset.Quality.EQualityStructOrderDataset [ WebMethod ]
{
	s result = ##class(EPRservice.dataset.Quality.EQualityStructOrderDataset).%New()
	q result
}

/// Function:	Get quality structs under the given <ALayer>
ClassMethod GetUnderLayerStruct(ALayer As %String) As EPRservice.dataset.Quality.EStructLayerDataset [ WebMethod ]
{
	s result = ##class(EPRservice.dataset.Quality.EStructLayerDataset).%New()
	d result.SetArgs(ALayer)
	q result
}

/// Function:	Get quality struct object by the given <AStructID>
/// Input:		AStructID represent the row id of QualityStruct table
ClassMethod GetQualityStructById(AStructID As %String) As EPRservice.entity.Quality.EQualityStruct [ WebMethod ]
{
	s objStruct = ##Class(EPRmeta.Quality.QualityStruct).%OpenId(AStructID)
	q:(objStruct = "") ""
	
	s struct = ##Class(EPRservice.entity.Quality.EQualityStruct).%New()
	s struct.ID = objStruct.%Id()
	s struct.StandardName = objStruct.StandardName
	s struct.ParentId = objStruct.ParentId
	s struct.Layer = objStruct.Layer
	s struct.BindEPRName = objStruct.BindEPRName
	s struct.BindCategoryId = objStruct.BindCategoryId
	s struct.BindCategoryParentId = objStruct.BindCategoryParentId
	s struct.ChkConditionDR = objStruct.ChkConditionDR
	s struct.CategoryDR = objStruct.CategoryDR
	s struct.IsActive = objStruct.IsActive
	s struct.BindDocID = objStruct.BindDocID
	s struct.ResumeText = objStruct.ResumeText
	
 	q struct
}

///  *****************************************************
///  功能：创建质控病历结构
///  结论：0代表创建失败，其它代表新建的质控病历结构ID
///  *****************************************************
ClassMethod CreateQualityStruct(AStruct As EPRservice.entity.Quality.EQualityStruct) As %String [ WebMethod ]
{
	s BindCategoryID = AStruct.BindCategoryId
	if (BindCategoryID '= $c(0))
	{
		
		s RowID = $o(^DHCEPRM.QualityStructI("IdxCategoryIdType"," "_BindCategoryID," "_$zcvt(AStruct.Type,"U"),""))
		q:(+RowID > 0) "0"
	}
	
	TSTART
	s objStruct=##Class(EPRmeta.Quality.QualityStruct).%New()
	q:(objStruct = "") "ERROR"
	
	s objStruct.StandardName = AStruct.StandardName			//标准名称
	s objStruct.ParentId = AStruct.ParentId					//父节点ID
	s objStruct.Layer = AStruct.Layer							//所在树的第几层
	
	if (AStruct.BindEPRName=$C(0))
	{
		s objStruct.BindEPRName=$C(0)	
	}
	else
	{
		s objStruct.BindEPRName = AStruct.BindEPRName	
	}	
	if (AStruct.BindCategoryId=$C(0))
	{
		s objStruct.BindCategoryId=$C(0)	
	}
	else
	{
		s objStruct.BindCategoryId = AStruct.BindCategoryId
	}
	s bindCategoryParentId=$C(0)
	if (AStruct.BindCategoryId '= $C(0))
	{
		if (AStruct.Type = "EMR")
		{
			s objTemplateCategory = ##class(EMRmeta.TemplateCategory).%OpenId(AStruct.BindCategoryId)
			s bindCategoryParentId=objTemplateCategory.ParentID		
		}
		else
		{
			//获取所绑定的模板父目录Id
			s objTemplateCategory = ##class(EPRmeta.TemplateCategory).%OpenId(AStruct.BindCategoryId)
			s bindCategoryParentId=objTemplateCategory.ParentID	
		}
	}
	s objStruct.BindCategoryParentId = bindCategoryParentId
	if (AStruct.ChkConditionDR '= $C(0))
	{
		s objStruct.ChkConditionDR = AStruct.ChkConditionDR
	}
	else
	{
		s objStruct.ChkConditionDR = $C(0)	
	}
	s objStruct.IsActive = AStruct.IsActive
	if (AStruct.ResumeText '= $C(0))
	{
		s objStruct.ResumeText = AStruct.ResumeText
	}
	else
	{
		s objStruct.ResumeText = $C(0)	
	}
	s objStruct.Type = AStruct.Type
 	if '(objStruct.%Save())
 	{
 		TROLLBACK
 		q "-1"
 	} 
 	TCOMMIT
 	q objStruct.%Id()
}

///  *****************************************************
///  功能：更新质控病历结构
///  结论：0代表更新失败，1代表更新成功
///  *****************************************************
ClassMethod UpdateQualityStruct(AStruct As EPRservice.entity.Quality.EQualityStruct) As %String [ WebMethod ]
{
	TSTART
	s objStruct = ##Class(EPRmeta.Quality.QualityStruct).%OpenId(AStruct.ID)
	q:(objStruct = "") "ERROR"
	 
	s objStruct.StandardName = AStruct.StandardName
	s objStruct.ParentId = AStruct.ParentId
	s objStruct.Layer = AStruct.Layer
	s objStruct.BindEPRName = AStruct.BindEPRName
	s objStruct.BindCategoryId = AStruct.BindCategoryId
	s objStruct.BindCategoryParentId = AStruct.BindCategoryParentId
	s objStruct.ChkConditionDR = AStruct.ChkConditionDR
	s objStruct.CategoryDR = AStruct.CategoryDR
	s objStruct.IsActive = AStruct.IsActive
	s objStruct.BindDocID = AStruct.BindDocID
	s objStruct.ResumeText = AStruct.ResumeText

 	if '(objStruct.%Save())
 	{
 		TROLLBACK
 		q "0"
 	} 
 	TCOMMIT
 	q "1"
}

///  *****************************************************
///  功能：删除质控病历结构
///  入参：AQuaStructId为质控病历结构表QualityStruct的RowID
///  结果：flag=0 不能删除；flag=1 删除成功；flag=2 删除失败
///  调试：w ##Class(EPRservice.Quality.DataAccess.BOQualityStruct).DeleteQualityStruct()
///  *****************************************************
ClassMethod DeleteQualityStruct(AQuaStructId As %String) As %String [ WebMethod ]
{
	// 在删除病历质控结构的时候需要判断当前目录是否挂载了质控项目或模板单元
	// 如果挂载有质控项目，则不让删除
	// 如果有被任何模板单元引用，则不让删除
	
	s flag = ""
	
	// 判断是否挂载有质控项目，如果有则返回0，否则返回1
	s result1 = ..CheckStructMountEntries(AQuaStructId)
	
	// 判断是否有被任何模板单元引用，如果有则返回0，否则返回1
	s result2 = ..CheckStructRelatedUnits(AQuaStructId)
	
	if (result1 & result2 = 1)
	{
		//既没有挂载任何质控项目或也没有被任何模板单元引用
		s flag = ##Class(EPRmeta.Quality.QualityStruct).DeleteQualityStruct(AQuaStructId)	
	}
	else
	{
		s flag = result1 & result2	
	}
	q flag
}

/// Function: Check whether has entries under the given <AStructID>
/// Result:	ret=1 means not mount any entries, ret=0 means mount at least one entries
/// Debug:	w ##Class(EPRservice.Quality.DataAccess.BOQualityStruct).CheckStructMountEntries(8)
ClassMethod CheckStructMountEntries(AParentStructID As %String) As %String
{
	s ret = 1
	q:(AParentStructID = "") ret
	
	s EntryID = $o(^DHCEPRM.QualityEntryI("IdxStructDR"," "_AParentStructID,""))
	if (+EntryID > 0) 
	{
		s ret = 0
		q ret	
	}
	else
	{
		s ChildID = ""
		for {
			s ChildID = $o(^DHCEPRM.QualityStructI("IdxParentId"," "_AParentStructID,ChildID))
			q:(ChildID = "")
			
			s flag = ..CheckStructMountEntries(ChildID)
			if (flag = 0)
			{
				s ret = 0
				q	
			}
		}	
	}
	q ret
}

/// Debug:	w ##Class(EPRservice.Quality.DataAccess.BOQualityStruct).CheckStructRelatedUnits(8)
ClassMethod CheckStructRelatedUnits(AParentStructID As %String) As %String
{
	s ret = 1
	q:(AParentStructID = "") ret
		
	s objStruct = $g(^DHCEPRM.QualityStructD(AParentStructID))
	s StructName = $list(objStruct,1)
	s BindCategoryID = $list(objStruct,5)
	if (BindCategoryID = "")
	{
		s ChildID = ""
		for {
			s ChildID = $o(^DHCEPRM.QualityStructI("IdxParentId"," "_AParentStructID,ChildID))
			q:(ChildID = "")
			
			s flag = ..CheckStructRelatedUnits(ChildID)
			if (flag = 0)
			{
				s ret = 0
				q	
			}
		}		
	}
	else
	{
		s TemplateID = ""
		for {
			s TemplateID = $o(^DHCEPRM.TemplateI("IndexCategoryId"," "_BindCategoryID,TemplateID))
			q:(TemplateID = "")
			
			s UnitID = $o(^DHCEPRM.QualityTemplateI("IdxTemplateId",TemplateID,""))
			if (+UnitID > 0)
			{
				s ret = 0
				q	
			}
		}
	}
	q ret
}

///  *****************************************************
///  功能：根据质控病历目录结构ID获取电子病历界面模板
///  入参：AQualityStructId为质控病历目录结构表QualityStruct的RowID
///  调试：d ##Class(EPRservice.Quality.DataAccess.BOQualityStruct).GetTemplatesByStructId(34)
///  *****************************************************
ClassMethod GetTemplatesByStructId(AQualityStructId As %String) As EPRservice.dataset.Quality.EEPRTemplateDataset [ WebMethod ]
{
	s result = ##class(EPRservice.dataset.Quality.EEPRTemplateDataset).%New()
	d result.SetArgs(AQualityStructId)
	q result
}

/// s StructList=""
/// d ##Class(EPRservice.Quality.DataAccess.BOQualityStruct).GetChildStructsByParentID(4,.StructList)
/// w StructList
ClassMethod GetChildStructsByParentID(AParentStructID As %String, ByRef StructList As %Binary) As %String
{
	s StructID = ""
	for {
		s StructID = $o(^DHCEPRM.QualityStructI("IdxParentId"," "_AParentStructID,StructID))
		q:(StructID = "")

		s objStruct = $g(^DHCEPRM.QualityStructD(StructID))
		continue:(objStruct = "")
		
		s IsActive = $list(objStruct,8)
		continue:(IsActive '= "Y")
				
		s BindCategoryID = $list(objStruct,5)
		s BindCategoryParentId = $list(objStruct,6)
		if (BindCategoryID = "")||(BindCategoryID = $C(0))
		{
			d ..GetChildStructsByParentID(StructID,.StructList)	
		}
		else
		{
			s StructList = StructList_$lb(BindCategoryID)		
		}
	}
}

/// Function:	Check if the <AStructID> is the offspring of <AParentStructID>
/// Debug:	w ##Class(EPRservice.Quality.DataAccess.BOQualityStruct).IsChildStruct(8,11)
ClassMethod IsChildStruct(AParentStructID As %String, AStructID As %String) As %Integer
{
	s ret = -1
	if (AParentStructID = AStructID)
	{
		s ret = 1
		q ret	
	} 
	else
	{
		s StructID = ""
		for {
			s StructID = $o(^DHCEPRM.QualityStructI("IdxParentId"," "_AParentStructID,StructID))
			q:(StructID = "")
			
			s ret = ..IsChildStruct(StructID,AStructID)
			q:(ret = 1)
		}
	}
	q ret
}

/// Desc: 		遍历质控结构,检查结构下条目
/// Creator: 	Candy
/// CreateDate:	2014-9-23
/// Input:		AStructID 检查的质控结构节点ID
/// 			ARuleID 质控标准
/// 			AEpisodeID 就诊号
/// 			AUniqueKey 唯一标示码
///             AActionType 操作类型
/// 			AOtherParam 不同操作类型使用的参数
/// OutPut:     count 触犯条目数
/// Debug: 		d ##Class(EPRservice.Quality.DataAccess.BOQualityStruct).CheckStruct("23",2,8659608,9214895899,"","")
ClassMethod CheckStruct(AStructID As %String, ARuleID As %String, AEpisodeID As %String, AUniqueKey As %String, AActionType As %String, AOtherParam As %ArrayOfDataTypes, ATemplateID As %String = "") As %String
{
   
	s count = 0
	q:(AStructID = "")||(ARuleID = "")||(AEpisodeID = "")||(AUniqueKey = "") count
	s flag = ##Class(EPRservice.Quality.CheckRule.Category).IsRightCatalog(AEpisodeID,AStructID)
	q:(flag '= 1) count
	s count = count + ##Class(EPRservice.Quality.DataAccess.BOQualityEntry).CheckEntry(AStructID,ARuleID,AEpisodeID,AUniqueKey,AActionType,AOtherParam,ATemplateID)

	
	k ^tempStructIdList(AUniqueKey)
	s ^tempStructIdList(AUniqueKey,AStructID)=""
	s CategoryID=""
	s objECRecord=""
	if (AOtherParam'="")&&(AOtherParam["||"){
		//s objECRecord=##class(EMRinstance.ECRecord).%OpenId($p(AOtherParam,"||",1))
		//s:(objECRecord="") objECRecord=##class(EPRinstance.ECRecord).%OpenId($p(AOtherParam,"||",1))
		//s CategoryID=objECRecord.CategoryID
		
		//修复8.5版本中EMRinstance.ECRecord表的CategoryID为EMRmeta.TemplateCategory表指针,导致用%OpenId无法正确取值的问题
		/*if ($d(^DHCEPRI.ECRecordI("IdxEpisodeIDCategoryID",AEpisodeID))="10")
		{
			s CategoryID=$list($g(^DHCEPRI.ECRecordD($p(AOtherParam,"||",1))),2)
		}
		elseif ($d(^DHCEMRI.ECRecordI("IdxEpisodeIDCategoryID",AEpisodeID))="10")
		{
			s CategoryID=$list($g(^DHCEMRI.ECRecordD($p(AOtherParam,"||",1))),2)
		}*/
		//修复批量打印不提示
		s CategoryID=##Class(EPRservice.Quality.EmrCheckRule.Template).GetCategoryIDS(AOtherParam)
		s CategoryID = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(CategoryID,"^","Y")
	}
	
	s parentId = ""
	for
	{
		s parentId = $o(^tempStructIdList(AUniqueKey,parentId))
		q:(parentId = "")
		s structId = ""
		for
		{
			s structId = $o(^DHCEPRM.QualityStructI("IdxParentId"," "_parentId,structId))	
			q:(structId = "")
			s objStruct = ##Class(EPRmeta.Quality.QualityStruct).%OpenId(structId)
			continue:(objStruct = "")
			//检查节点是否有效
			continue:(objStruct.IsActive '= "Y")
			s flag = ##Class(EPRservice.Quality.CheckRule.Category).IsRightCatalog(AEpisodeID,structId)
			continue:(flag '= 1)
			//检查绑定模板节点
			if (objStruct.BindCategoryId '= "")&&(objStruct.BindCategoryId '= $c(0))
			{
				//continue:((CategoryID'="")&&(CategoryID'=objStruct.BindCategoryId))
				//修复批量打印不提示
		                                continue:($listfind(CategoryID,objStruct.BindCategoryId) <= 0)&&(CategoryID'="") 
				if (objStruct.Type = "EMR")
				{
					s flag = ##Class(EPRservice.Quality.ExpExplain.BOCheckRange).IsNeedCheckEMR(AEpisodeID,objStruct.BindCategoryId)	
				}
				else
				{
					
					s flag = ##Class(EPRservice.Quality.ExpExplain.BOCheckRange).IsNeedCheckEPR(AEpisodeID,objStruct.BindCategoryId)	
				}	
				continue:(flag '= 1)
			}
			s count = count + ##Class(EPRservice.Quality.DataAccess.BOQualityEntry).CheckEntry(structId,ARuleID,AEpisodeID,AUniqueKey,AActionType,AOtherParam,ATemplateID)
			s ^tempStructIdList(AUniqueKey,structId) = ""
		} 
	}
	q count
}

/// Desc: 		遍历质控结构,检查结构下条目
/// Creator: 	Candy
/// CreateDate:	2014-9-23
/// Input:		AStructID 检查的质控结构节点ID
/// 			ARuleID 质控标准
/// 			AEpisodeID 就诊号
/// 			AUniqueKey 唯一标示码
///             AActionType 操作类型
/// 			AOtherParam 不同操作类型使用的参数
/// OutPut:     count 触犯条目数
/// Debug: 		d ##Class(EPRservice.Quality.DataAccess.BOQualityStruct).CheckStructNew("23",2,8659608,9214895899,"","")
ClassMethod CheckStructNew(AStructID As %String, ARuleID As %String, AEpisodeID As %String, AUniqueKey As %String, AActionType As %String, AOtherParam As %ArrayOfDataTypes, ATemplateID As %String = "") As %String
{
   
	s count = 0
	q:(AStructID = "")||(ARuleID = "")||(AEpisodeID = "")||(AUniqueKey = "") count
	s flag = ##Class(EPRservice.Quality.CheckRule.Category).IsRightCatalogNew(AEpisodeID,AStructID)
	
	q:(flag '= 1) count
	s count = count + ##Class(EPRservice.Quality.DataAccess.BOQualityEntry).CheckEntryNew(AStructID,ARuleID,AEpisodeID,AUniqueKey,AActionType,AOtherParam,ATemplateID)

	
	k ^tempStructIdList(AUniqueKey)
	s ^tempStructIdList(AUniqueKey,AStructID)=""
	s CategoryID=""
	s objECRecord=""
	if (AOtherParam'="")&&(AOtherParam["||"){
		
		
		//s objECRecord=##class(EMRinstance.ECRecord).%OpenId($p(AOtherParam,"||",1))
		//s:(objECRecord="") objECRecord=##class(EPRinstance.ECRecord).%OpenId($p(AOtherParam,"||",1))
		//s CategoryID=objECRecord.CategoryID.%Id()
		//修复8.5版本中EMRinstance.ECRecord表的CategoryID为EMRmeta.TemplateCategory表指针,导致用%OpenId无法正确取值的问题
		/*if ($d(^DHCEPRI.ECRecordI("IdxEpisodeIDCategoryID",AEpisodeID))="10")
		{
			s CategoryID=$list($g(^DHCEPRI.ECRecordD($p(AOtherParam,"||",1))),2)
		}
		elseif ($d(^DHCEMRI.ECRecordI("IdxEpisodeIDCategoryID",AEpisodeID))="10")
		{
			s CategoryID=$list($g(^DHCEMRI.ECRecordD($p(AOtherParam,"||",1))),2)
		}*/
		//修复批量打印不提示
		s CategoryID=##Class(EPRservice.Quality.EmrCheckRule.Template).GetCategoryIDS(AOtherParam)
		s CategoryID = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(CategoryID,"^","Y")
	}
	
	s parentId = ""
	for
	{
		s parentId = $o(^tempStructIdList(AUniqueKey,parentId))
		q:(parentId = "")
		s structId = ""
		for
		{
			s structId = $o(^CT.MA.QC.QualityStructI("IdxParentId"," "_parentId,structId))	
			q:(structId = "")
			s objStruct = ##Class(CT.MA.QC.QualityStruct).%OpenId(structId)
			continue:(objStruct = "")
			//检查节点是否有效
			continue:(objStruct.IsActive '= "Y")
			s flag = ##Class(EPRservice.Quality.CheckRule.Category).IsRightCatalogNew(AEpisodeID,structId)
			continue:(flag '= 1)
			//检查绑定模板节点
			if (objStruct.BindCategoryId '= "")&&(objStruct.BindCategoryId '= $c(0))
			{
				
		        
		        //修复批量打印不提示
		        continue:($listfind(CategoryID,objStruct.BindCategoryId) <= 0)&&(CategoryID'="") 
				
			
				
				s flag = ##Class(EPRservice.Quality.ExpExplain.BOCheckRange).IsNeedCheckEMR(AEpisodeID,objStruct.BindCategoryId)	
					
				continue:(flag '= 1)
			}
			s count = count + ##Class(EPRservice.Quality.DataAccess.BOQualityEntry).CheckEntryNew(structId,ARuleID,AEpisodeID,AUniqueKey,AActionType,AOtherParam,ATemplateID)
			s ^tempStructIdList(AUniqueKey,structId) = ""
		} 
	}
	q count
}

/// d ##Class(EPRservice.Quality.DataAccess.BOQualityStruct).TestCreateStruct()
ClassMethod TestCreateStruct()
{
	s objEStruct = ##Class(EPRservice.entity.Quality.EQualityStruct).%New()
	s objEStruct.BindCategoryId = 77
	s objEStruct.BindCategoryParentId = ""
	s objEStruct.BindEPRName = "界面模板目录树.EMR08 住院病案首页.EMR080001 住院病案首页.病案首页"
	s objEStruct.ChkConditionDR = ""
	s objEStruct.IsActive="Y"
	s objEStruct.ResumeText=""
	s objEStruct.Type="EMR"
	s objEStruct.ParentId = 12
	s objEStruct.StandardName = "EMR080001 住院病案首页.病案首页"
	
	w ..CreateQualityStruct(objEStruct)
}

/// d ##Class(EPRservice.Quality.DataAccess.BOQualityStruct).GetDocIDByStructID()
ClassMethod GetDocIDByStructID(AStructID As %String)
{
	s ret=""
	q:(AStructID="") ret
	s CategoryID="",Docid=""
	&sql(
		SELECT BindCategoryId into :CategoryID FROM EPRmeta_Quality.QualityStruct WHERE ID=:AStructID
	)
	q:(CategoryID="") ret
	&sql(
		SELECT CategoryID into :Docid FROM EMRmeta.EMRTemplate WHERE BindTemplateCategoryID=:CategoryID
	)
	s ret=Docid
	q ret
}

}
