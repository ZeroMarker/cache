/// 名称:           EPRservice.BOGlossaryItem
/// 描述:           术语项目服务类(包括模板单元项目和知识库单元项目)
/// 编写者：        Zuoxiang Xie
/// 编写日期:       2011-08-30
Class EPRservice.BOGlossaryItem Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "GlossaryItemInfo";

ClassMethod GetGlossaryItems(AGlossaryID As %String) As EPRservice.dataset.EGlossaryItemDataset [ WebMethod ]
{
	s result = ##Class(EPRservice.dataset.EGlossaryItemDataset).%New()
	d result.SetArgs(AGlossaryID)
	
	q result
}

ClassMethod GetGlossaryKBItems(AGlossaryID As %String) As EPRservice.dataset.EGlossaryKBItemDataset [ WebMethod ]
{
	s result = ##Class(EPRservice.dataset.EGlossaryKBItemDataset).%New()
	d result.SetArgs(AGlossaryID)
	
	q result
}

/// Desc:	更新术语下的项目(包括保存,更新和删除,用事务处理)
/// AGlossaryItems的Scheme：GlossaryID|GlossaryType|TemplateID^ItemName^ItemCode^ValueType$TemplateID^ItemName^ItemCode^ValueType
/// Debug:	w ##Class(EPRservice.BOGlossaryItem).UpdateGlossaryItems("4402^TG|1&^#TYPE:ICOMPOSITESAMPLE#SCODE:S001|CCODE:V005|CSCODE:I0002^V^NEW^EMR09 住院志.EMR090001 入院记录.入院记录.患者基本信息.COMPOSITE:V005.入院记录.性别.值$1&^EMRinstance.InstanceData#CreateUser^V^EMRINSTANCE^EMR09 住院志.EMR090001 入院记录.入院记录.CreateUser 创建者")
ClassMethod UpdateGlossaryItems(AGlossaryItems As %String) As %Boolean [ WebMethod ]
{
	s ret = 1
	s glossaryItems = ""
	s rootInfo = $p(AGlossaryItems,"|",1)
	if ($l(AGlossaryItems,"|")>2)
	{
		s glossaryItems = $REPLACE(AGlossaryItems,rootInfo_"|","")
	}
	else
	{
		s glossaryItems = $p(AGlossaryItems,"|",2)
	}
	
	
	s glossaryID = $p(rootInfo,"^",1)
	s glossaryType = $p(rootInfo,"^",2)
	s objGlossary = ##Class(EPRmeta.Glossary).%OpenId(glossaryID)
	q:(objGlossary = "") 0
	s sInternalID = objGlossary.InternalID

	
	if ($zcvt(glossaryType,"U") = "TG")
	{
		//先取出原有的所有术语项目并存放于一个ArrayOfObjects中
		s arrItems = ##Class(%ArrayOfObjects).%New()
		
		s rowID = ""
		for {
			s rowID = $o(^DHCEPRM.GlossaryItemI("IdxGlossaryID",glossaryID,rowID))
			q:(rowID = "")
			
			s objCurItem = ##Class(EPRmeta.GlossaryItem).%OpenId(rowID)
						
			d arrItems.SetAt(objCurItem,rowID)
		}
		
		for i=1:1:$l(glossaryItems,"$")	
		{
			s item = $p(glossaryItems,"$",i)
			
			s atemplateID = $p(item,"^",1)
			s templateID = atemplateID
			s templateCode = ""
			if ($l(atemplateID,"&")>=2&&(atemplateID [ "&"))
			{
				s templateID = $p(atemplateID,"&",1)
				s templateCode = $p(atemplateID,"&",2)
			}
			if (item [ "^EMRINSTANCE^")
			{
				s itemCode = $p(item,"^",2)
			}
			else
			{
				s itemCode = $zcvt($p(item,"^",2),"U")
			}
			s valueType = $p(item,"^",3)
			s temType = ""
			s itemName = ""
			if ( $l(item,"^")>=5)&&(item [ "^NEW^")
			{
				s temType = $p(item,"^",4)
				s itemName = $p(item,"^",5)
				if ($l(item,"^")=6)
				{
					s itemName = $p(item,"^",5)_"^"_$p(item,"^",6)
				}
				elseif ($l(item,"^")=7)
				{
					s itemName = $p(item,"^",5)_"^"_$p(item,"^",6)_"^"_$p(item,"^",7)
				}
			}
			elseif ( $l(item,"^")>=5)&&(item [ "^BASE^")
			{
				s temType = $p(item,"^",4)
				s itemName = $p(item,"^",5)
				if ($l(item,"^")=6)
				{
					s itemName = $p(item,"^",5)_"^"_$p(item,"^",6)
				}
				elseif ($l(item,"^")=7)
				{
					s itemName = $p(item,"^",5)_"^"_$p(item,"^",6)_"^"_$p(item,"^",7)
				}
			}
			elseif (item [ "^GROUP^") || (item [ "^EMRINSTANCE^")
			{
				s temType = $p(item,"^",4)
				s itemName = $p(item,"^",5)
			}
			else
			{
				s itemName = $p(item,"^",5)
			}
			
			
			s itemID = $o(^DHCEPRM.GlossaryItemI("IdxComposite",glossaryID,templateID," "_$zcvt(itemCode,"U")," "_$zcvt(valueType,"U"),""))
			if (itemID = "")
			{
				s objItem = ##Class(EPRmeta.GlossaryItem).%New()
				s objItem.GlossaryID = glossaryID
				s objItem.TemplateID = templateID
				s objItem.ItemCode = itemCode
				s objItem.ItemName = itemName
				s objItem.ValueType = valueType
				s objItem.TemType = temType
				s objItem.InternalID = sInternalID
				S objItem.TemplateCode = templateCode
				d objItem.%Save()	
			}
			else
			{
				s objItem = ##Class(EPRmeta.GlossaryItem).%OpenId(itemID)
				if (objItem.ItemName '= itemName)
				{
					s objItem.ItemName = itemName
					s objItem.TemType = temType
					s objItem.TemplateCode = templateCode
					s objItem.InternalID = sInternalID
					d objItem.%Save()	
				}
				d arrItems.RemoveAt(itemID)	
			}
		}
		
		s key = ""
		while(1)
		{
			s key = arrItems.Next(key)
			q:(key = "")
			
			s handler = arrItems.GetAt(key)
			d handler.%DeleteId(key)	
		}
	}
	else
	{
		s contextGlossaryID = $p(rootInfo,"^",3)
		
		//先取出原有的所有术语项目并存放于一个ArrayOfObjects中
		s arrKBItems = ##Class(%ArrayOfObjects).%New()
		
		s rowID = ""
		for {
			s rowID = $o(^DHCEPRM.GlossaryKBItemI("IdxGlossaryID",glossaryID,rowID))
			q:(rowID = "")
			
			s objCurKBItem = ##Class(EPRmeta.GlossaryKBItem).%OpenId(rowID)
						
			d arrKBItems.SetAt(objCurKBItem,rowID)
		}
		
		for i=1:1:$l(glossaryItems,"$")	
		{
			s kbItem = $p(glossaryItems,"$",i)
			
			s kbNodeID = $p(kbItem,"^",1)
			s kbPartNo = $p(kbItem,"^",2)
			s itemCode = $zcvt($p(kbItem,"^",3),"U")
			s valueType = $p(kbItem,"^",4)
			s kbType = ""
			s itemName = ""
			if ( $l(kbItem,"^")>=6)&&(kbItem [ "^NEW^")
			{
				s kbType = $p(kbItem,"^",5)
				s itemName = $p(kbItem,"^",6)
				if ($l(kbItem,"^")=7)
				{
					s itemName = $p(kbItem,"^",6)_"^"_$p(kbItem,"^",7)
				}
			}
			else
			{
				s itemName = $p(kbItem,"^",6)
			}

			s kbItemID = $o(^DHCEPRM.GlossaryKBItemI("IdxComposite",glossaryID,kbNodeID,kbPartNo," "_$zcvt(itemCode,"U")," "_$zcvt(valueType,"U"),""))
			if (kbItemID = "")
			{
				s objItem = ##Class(EPRmeta.GlossaryKBItem).%New()
				s objItem.GlossaryID = glossaryID
				s objItem.ContextGlossaryID = contextGlossaryID
				s objItem.KBNodeID = kbNodeID
				s objItem.KBPartNo = kbPartNo
				s objItem.ItemCode = itemCode
				s objItem.ItemName = itemName
				s objItem.ValueType = valueType
				s objItem.KBType = kbType
				d objItem.%Save()	
			}
			else
			{
				s objKBItem = ##Class(EPRmeta.GlossaryKBItem).%OpenId(kbItemID)
				if (objKBItem.ItemName '= itemName)
				{
					s objKBItem.ItemName = itemName
					s objKBItem.KBType = kbType
					d objKBItem.%Save()	
				}
				d arrKBItems.RemoveAt(kbItemID)	
			}	
		}
		
		s key = ""
		while(1)
		{
			s key = arrKBItems.Next(key)
			q:(key = "")
			
			s handler = arrKBItems.GetAt(key)
			d handler.%DeleteId(key)	
		}
	}
	
	q ret
}

/// 获取和单元相关联的术语 todo
/// w ##Class(EPRservice.BOGlossaryItem).GetTerms(704,"D0024")
ClassMethod GetTerms(ATemplateID As %String, AItemCode As %String) As EPRservice.dataset.UnitGlossaryDataSet [ WebMethod ]
{
	Set ds=##class(EPRservice.dataset.UnitGlossaryDataSet).%New()
	d ds.SetArgs(ATemplateID,AItemCode)
	Quit ds
}

/// 删除单元和术语的关联关系 glossaryIDs下所有的
ClassMethod DelUnitGlossary(glossaryIDs As %String)
{
	q:""=glossaryIDs ""
	for i=1:1:$l(glossaryIDs,"^")
	{
		s glossaryID=$p(glossaryIDs,"^",i)
		d ..DelByGlossaryID(glossaryID)
	}
}

/// 删除glossaryID下所有的记录
/// w ##Class(EPRservice.BOGlossaryItem).DelItemByGlossaryID("2214^TG")
ClassMethod DelItemByGlossaryID(AGlossaryItems As %String) As %Boolean [ WebMethod ]
{
	q:(AGlossaryItems = "")
	s ret=1
	s glossaryID = $p(AGlossaryItems,"^",1)
	s glossaryType = $p(AGlossaryItems,"^",2)
	TSTART
	s oid = ""
	if ($zcvt(glossaryType,"U") = "TG")
	{
		for {
			s oid = $o(^DHCEPRM.GlossaryItemI("IdxGlossaryID",glossaryID,oid))
		    q:(oid = "")
		    Do ##class(EPRmeta.GlossaryItem).%DeleteId(oid)
		}
	}
	else
	{
		for {
			s oid = $o(^DHCEPRM.GlossaryKBItemI("IdxGlossaryID",glossaryIDs,oid))
		    q:(oid = "")
		    Do ##class(EPRmeta.GlossaryKBItem).%DeleteId(oid)
		}
	}
	TCOMMIT
	q ret
}

/// 删除glossaryID下所有的记录
ClassMethod DelByGlossaryID(glossaryID As %String)
{
	q:(glossaryID = "")
	s oid="" 
	for {
		s oid = $o(^DHCEPRM.GlossaryItemI("IdxGlossaryID",glossaryID,oid))
	    q:(oid = "")
	    Do ##class(EPRmeta.GlossaryItem).%DeleteId(oid)
	}
}

/// 删除单元下所有的记录
/// TemplateID ItemCode ValueType
ClassMethod DelByUnit(TemplateID As %String, ItemCode As %String, ValueType As %String)
{
	
	s glossaryID = ""
	for {
		s glossaryID = $O(^DHCEPRM.GlossayItem("IdxLink"," "_TemplateID, " "_ItemCode, ValueType, glossaryID))
		q:(glossaryID = "")
		s oid="" 
		s oid = $o(^DHCEPRM.GlossaryItemI("IdxGlossaryID",glossaryID,oid))
	    q:(oid = "")
	    Do ##class(EPRmeta.GlossaryItem).%DeleteId(oid)
	}
}

/// 保存单元和术语的关系
/// 入参：TemplateID ItemCode CateInfo 
///       ValueType^ItemName^GlossaryID$
ClassMethod SaveUnitGlossary(TemplateID As %String, ItemCode As %String, CateInfo As %String, contents As %String) As %Boolean [ WebMethod ]
{
	
	// 先删再加
	&sql(delete from EPRMeta.GlossaryItem where TemplateID = :TemplateID and ItemCode = :ItemCode)
	
	q:""=contents 1
	//TSTART
	for i=1:1:$l(contents,"$")
	{
		s content=$p(contents,"$",i) 
		
		s ValueType=$p(content,"^",1)
		s ItemName=$p(content,"^",2)
		s glossaryID=$p(content,"^",3)
		    
		s objItem = ##Class(EPRmeta.GlossaryItem).%New()
		s objItem.GlossaryID = glossaryID
		//w glossaryID,!
		s objItem.TemplateID = TemplateID
		s objItem.ItemCode = ItemCode
		s objItem.ItemName = CateInfo_ItemName
		s objItem.ValueType = ValueType
		d objItem.%Save()	    
	}
	//TCOMMIT
	
	q 1
}

/// Creator:	yejian
/// CreatDate:  2019-7-12
/// Desc:		根据模板获取关联术语信息(维护端根据编码获取术语)
/// Input：		ATemplateID：模板ID
/// Return：	dataset
/// w ##Class(EPRservice.BOGlossaryItem).SelectGlossaryByItemCode(28)
ClassMethod SelectGlossaryByTemID(ATemplateID As %String) As %XML.DataSet [ WebMethod ]
{
	s result = ##Class(%XML.DataSet).%New("EPRservice.dao.DUnitGlossary:SelectGlossaryByTemID")
	d result.SetArgs(ATemplateID)
	q result
}

/// Creator:	yejian
/// CreatDate:  2022-2-15
/// Desc:		根据模板获取关联术语信息(维护端根据编码获取术语)
/// Input：		ATemplateCode：模板编码
/// 			ATemType 类型（模板:NEW,模板元素:BASE）
/// Return：	dataset
/// debug:  w ##Class(EPRservice.BOGlossaryItem).SelectGlossaryByTemID(1)
ClassMethod SelectGlossaryByTemCode(ATemplateCode As %String, ATemType As %String) As %XML.DataSet [ WebMethod ]
{
	s result = ##Class(%XML.DataSet).%New("EPRservice.dao.DUnitGlossary:SelectGlossaryByTemCode")
	d result.SetArgs(ATemplateCode,ATemType)
	q result
}

/// Creator:	yejian
/// CreatDate:  2022-1-27
/// Desc:		根据术语关联ID删除关联
/// Input：		AID：eprmeta.glossaryItem 表rowID
/// Return：	0:失败，1:成功
/// w ##Class(EPRservice.BOGlossaryItem).DelGlossaryItemByID(538)
ClassMethod DelGlossaryItemByID(AID As %String) As %String [ WebMethod ]
{
	q ##Class(EPRservice.dao.DUnitGlossary).DelGlossaryItemByID(AID)
}

/// Creator:	yejian
/// CreatDate:  2022-2-11
/// Desc:		修改术语关联关系
/// Input：		AGlossaryItem：EPRservice.entity.EGlossaryItem
/// Return：	0:失败，1:成功
/// w ##Class(EPRservice.BOGlossaryItem).UpGlossaryItem(538)
ClassMethod UpGlossaryItem(AGlossaryItem As EPRservice.entity.EGlossaryItem) As %String [ WebMethod ]
{
	q ##Class(EPRservice.dao.DUnitGlossary).UpGlossaryItem(AGlossaryItem)
}

/// Creator:	yejian
/// CreatDate:  2022-2-11
/// Desc:		添加术语关联关系
/// Input：		AGlossaryItem：EPRservice.entity.EGlossaryItem
/// Return：	0:失败，1:成功
/// w ##Class(EPRservice.BOGlossaryItem).AddGlossaryItem(538)
ClassMethod AddGlossaryItem(AGlossaryItem As EPRservice.entity.EGlossaryItem) As %String [ WebMethod ]
{
	q ##Class(EPRservice.dao.DUnitGlossary).AddGlossaryItem(AGlossaryItem)
}

/// Creator:	yejian
/// CreatDate:  2022-2-11
/// Desc:		通过模板元素术语关系，添加元素术语关联关系
/// Input：		AGlossaryItem：EPRservice.entity.EGlossaryItem
/// Return：	0:失败，1:成功
/// w ##Class(EPRservice.BOGlossaryItem).AddGlossaryItem(538)
ClassMethod AddGlossaryItemByCElement(AGlossaryItemOld As EPRservice.entity.EGlossaryItem, AGlossaryItemNew As EPRservice.entity.EGlossaryItem) As %String [ WebMethod ]
{
	q ##Class(EPRservice.dao.DUnitGlossary).AddGlossaryItemByCElement(AGlossaryItemOld,AGlossaryItemNew)
}

/// Desc:       发布时清理无用的术语关联
/// Creator:    yejian
/// CreateDate: 2021-6-15
/// Input:      argArr 模板简单元素集合，aTemplateID 目录ID，aType 模板类型
/// OutPut:     返回值：成功 1，失败 -1
/// w ##Class(EPRservice.BOGlossaryItem).ClearGlossaryItemsByCode()
ClassMethod ClearGlossaryItemsByCode(argArr As %ListOfDataTypes(ELEMENTTYPE="%String",MAXLEN="200"), aTemplateID As %String, aType As %String = "NEW") As %String [ WebMethod ]
{
 	q ##class(EPRservice.dao.DUnitGlossary).ClearGlossaryItemsByCode(argArr,aTemplateID,aType)
}

}
