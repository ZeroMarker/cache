/// 名称:EMRservice.BL.BLEMRTemplateGroupLoc
/// 描述:病历分组科室关联BO
/// 编写者：yejian
/// 编写日期: 2017-8-15
Class EMRservice.BL.BLEMRTemplateGroupLoc Extends (%RegisteredObject, %XML.Adaptor)
{

Query SelectAllLocRowId() As %SQLQuery(CONTAINID = 1, ROWSPEC = "Code:%String,Des:%String")
{
SELECT c.CTLOC_RowId,c.CTLOC_Desc
FROM SQLUser.CT_Loc c
where  c.CTLOC_Type IN ('E','W','OP','EM','O')
Order By c.CTLOC_Desc,c.CTLOC_RowId
}

/// Creator: yejian
/// CreatDate: 2016-5-17
/// Description：获取指定DocID下的所有科室ID
/// Input: aSchemeCode,aItemCode
/// Return: 科室1^科室2^科室3
ClassMethod GetGroupLoc(aGroupCode As %String) As %String
{
	q:(($d(aGroupCode) = 0)||(aGroupCode = "")) ""
	s result = ""
	
	&sql(declare myGroupCursor cursor for
		select CTLocID into :groupid from EMRmeta.EMRTemplateGroupLoc 
		where  TemplateGroupCode = :aGroupCode)
	&sql(open myGroupCursor)
	for {
		&sql(fetch myGroupCursor)
		q:(SQLCODE)
		
		if result = ""
		{	s result = groupid}
		else
		{	s result =  result_"^"_groupid}
	}
	&sql(close myGroupCursor)
	
	q result
}

/// Creator: yejian
/// CreatDate: 2016-5-17
/// Description：保存指定方案项下所适用的科室
/// Input: aSchemeCode,aItemCode--itemcode^itemname sltLocs--所有选中的科室ID串(格式为 ID1|name^ID2|name^ID3|name), unSltLocs--所有未选中的科室ID串(格式为 ID1|name^ID2|name^ID3|name)
/// Return: 1
ClassMethod ModifyLoc(aGroupCode As %String, sltLocs As %String, unSltLocs As %String) As %String
{
	q:((aGroupCode="")||(aGroupCode = $c(0))) "0"
	s strGroupCode = $p(aGroupCode,"^",1)
	s strGroupName = $p(aGroupCode,"^",2)
	if ((sltLocs = "") || (sltLocs = $c(0)))
	{
		s sltLocsCount = 0
	}
	else
	{
		s sltLocsCount = $l(sltLocs, "^")
	}
	
	if ((unSltLocs = "") || (unSltLocs = $c(0)) )
	{
		s unSltLocsCount = 0
	}
	else
	{
		s unSltLocsCount = $l(unSltLocs, "^")
	}

	//保存选中的科室
	s i = 1
	WHILE (i <= sltLocsCount) 
	{
		s curSltLocID = $p(sltLocs, "^", i)
		s strcurSltLocID = $p(curSltLocID,"|",1)
		s strcurSltLocName = $p(curSltLocID,"|",2)
		if (curSltLocID '= "")
		{
			s docLocRowID = $o(^DHCEMRM.EMRTemplateGroupLocI("IdxCodeCTLocID"," "_$zcvt(strGroupCode,"U"), " "_strcurSltLocID, 0))
			//如果没有,则新增;有则不处理
			if (docLocRowID = "")
			{
				s objNavSchemeItemLoc = ##class(EMRmeta.EMRTemplateGroupLoc).%New()
				q:(objNavSchemeItemLoc = "")
				
				s objNavSchemeItemLoc.TemplateGroupCode = strGroupCode
				s objNavSchemeItemLoc.TemplateGroupName = strGroupName
				s objNavSchemeItemLoc.CTLocID = strcurSltLocID
				s objNavSchemeItemLoc.CTLocDesc = strcurSltLocName
				d objNavSchemeItemLoc.%Save()
				d objNavSchemeItemLoc.%Close()
				s objNavSchemeItemLoc = ""
			}
		}
		
		s i = i + 1
	}
	
	//删除未选中的科室
	s i = 1
	WHILE (i <= unSltLocsCount) 
	{
		s curUnSltLocID = $p(unSltLocs, "^", i)
		s strcurSltLocID = $p(curUnSltLocID,"|",1)
		if (strcurSltLocID '= "")
		{
			s itemLocRowID = $o(^DHCEMRM.EMRTemplateGroupLocI("IdxCodeCTLocID", " "_$zcvt(strGroupCode,"U"), " "_strcurSltLocID, 0))
			//如果有,则删除; 没有则不处理
			if (itemLocRowID '= "")
			{
				d ##class(EMRmeta.EMRTemplateGroupLoc).%DeleteId(itemLocRowID)
			}
		}
		
		s i = i + 1
	}
	
	//返回
	q "1"
}

/// Creator:     yejian
/// CreateDate:  2021-6-24
/// Description: 获取病历展现中知情告知关联的所有科室
/// Input:       aCategoryID 病历展现业务活动记录分类目录 目录展现结构第1层
/// Output:      rowID,Code,Desc,Type
/// Debug:       s argOutData=##Class(EMRservice.BL.BLEMRTemplateGroupLoc).GetAgreeRecordCTLocs("6") 
/// 			 d argOutData.OutputToDevice()
ClassMethod GetAgreeRecordCTLocs(aParentID As %String) As %GlobalBinaryStream
{
	s json = ##Class(%GlobalBinaryStream).%New()
	q:(aParentID = "") json
	s arryCtLocID = ##Class(%ArrayOfDataTypes).%New()
	d json.Write("[")
	d json.Write("{")
	d json.Write("""RowID"":"""_"ALL"_"""")
	d json.Write(",""Code"":"""_"ALL"_"""")
	d json.Write(",""Desc"":"""_"全院"_"""")
	d json.Write("}")
	s curCategoryId = ""
	for
	{
		s curCategoryId = $o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCategoryID"," "_aParentID,curCategoryId))
		q:(curCategoryId = "")
		s objEMRTemplateCategory =##Class(EMRmeta.EMRTemplateCategory).%OpenId(curCategoryId)
		continue:(objEMRTemplateCategory.CategoryType '= "CategoryChapter")	
		s curDocIDS=""
	    s curDocID=""
	    for
	    {		
			s curDocID = $o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCategoryID"," "_curCategoryId,curDocID))
			q:(curDocID = "")
			s curObjDocCategory =##Class(EMRmeta.EMRTemplateCategory).%OpenId(curDocID)
			continue:(curObjDocCategory.CategoryType '= "TempCate")
			
	        //知情告知模板分组
			s curDocGropID = ""
			set groupID = ""
		 	for 
		 	{
				set groupID = $o(^DHCEMRM.DocRes.DocsInGroupI("DocIDIdx"," "_curDocID,groupID)) //注：此处取得的 groupID 在左侧含有空格
				q:(groupID="")
				//遍历该模板组下的规则，校验是否有规则适合
				s restrictionId = ""
				for
				{
					s restrictionId = $o(^DHCEMRM.DocRes.DocRestrictionI("GroupIDIdx",groupID,restrictionId))
					q:(restrictionId="")
					s objRes = ##class(EMRmeta.EMRDocRestriction.DocRestriction).%OpenId(restrictionId)
					q:(objRes = "")
					if (objRes.RuleItemIDs [ "PATDEPT:")
					{
						s ctLocId = $p(objRes.RuleItemIDs,":",2)
						
						s rowId =  $zstrip(ctLocId,"*P")
						s locCode = $p($g(^CTLOC(rowId)),"^",1)
						s locDesc = $p($g(^CTLOC(rowId)),"^",2)
						continue:(arryCtLocID.GetAt(rowId) '= "")
						d arryCtLocID.SetAt(curDocID,rowId)
						d:(json.Size>1) json.Write(",")
						d json.Write("{")
						d json.Write("""RowID"":"""_rowId_"""")
						d json.Write(",""Code"":"""_locCode_"""")
						d json.Write(",""Desc"":"""_locDesc_"""")
						d json.Write("}")
					}	
				}	
		 	}
	    }
	}
	d json.Write("]")
	k arryCtLocID
	q json
}

}
