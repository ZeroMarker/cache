/// 名称: 目录查看权限规则
/// 描述: 新框架病历结构目录的查看权限（只控制第一层）
/// 编写者：chenwenjun
/// 编写日期: 09/07/27
Class EMRservice.BOEMRCateViewPriv Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "EMRservice.BOEMRCateViewPriv";

/// Creator: 陈文俊
/// CreatDate: 2009-08-13
/// Description：获取指定DocID下的所有安全组ID
/// Table:
/// Input: docID--docID
/// Output:
/// Return: 安全组1^安全组2^安全组3
ClassMethod GetDocSSGroups(docID As %String) As %String [ WebMethod ]
{
	q:(($d(docID) = 0)||(docID = "")) ""
	s result = ""
	
	/*
	s rs = ##class(%ResultSet).%New()
	s sql = "select SSGroupID from EMRmeta_EMRDocRestriction.CatalogSSGroup where EMRDocID=?"
	d rs.Prepare(sql)
	d rs.Execute(docID)
	
	s result = ""
	s isFirst = "Y"
	WHILE (rs.Next()) 
	{
		s curSSGroupID = rs.Data("SSGroupID")
	 	
		if (isFirst = "N"){s result = result_"^"}
		s result = result_curSSGroupID
		s isFirst = "N"
	}
	d rs.Close()
	*/
	
	&sql(declare myCursor cursor for
		select SSGroupID into :groupid from EMRmeta_EMRDocRestriction.CatalogSSGroup where EMRDocID = :docID)
	&sql(open myCursor)
	for {
		&sql(fetch myCursor)
		q:(SQLCODE)
		
		if result = ""
		{	s result = groupid}
		else
		{	s result =  result_"^"_groupid}
	}
	&sql(close myCursor)
	
	q result
}

/// Creator: 陈文俊
/// CreatDate: 2009-08-13
/// Description：保存指定DocID下所适用的安全组
/// Table:
/// Input: docID--docID, sltSSGroups--所有选中的安全组ID串(格式为 ID1^ID2^ID3), unSltSSGroups--所有未选中的安全组ID串(格式为 ID1^ID2^ID3)
/// Output:
/// Return: 
ClassMethod Modify(docID As %String, sltSSGroups As %String, unSltSSGroups As %String) As %String [ WebMethod ]
{
	if ((sltSSGroups = "") || (sltSSGroups = $c(0)))
	{
		s sltSSGroupsCount = 0
	}
	else
	{
		s sltSSGroupsCount = $l(sltSSGroups, "^")
	}
	
	if ((unSltSSGroups = "") || (unSltSSGroups = $c(0)) )
	{
		s unSltSSGroupsCount = 0
	}
	else
	{
		s unSltSSGroupsCount = $l(unSltSSGroups, "^")
	}

	//保存选中的安全组
	s i = 1
	WHILE (i <= sltSSGroupsCount) 
	{
		s curSltSSGroupID = $p(sltSSGroups, "^", i)
		
		if (curSltSSGroupID '= "")
		{
			s docSSGroupRowID = $o(^DHCEMRM.EMRDOC.EMRSSGroupI("IdxCatalogSSGroup", " "_docID, " "_curSltSSGroupID, 0))
			//如果没有,则新增;有则不处理
			if (docSSGroupRowID = "")
			{
				s tempEMRCateViewPriv = ##class(EMRmeta.EMRDocRestriction.CatalogSSGroup).%New()
				q:(tempEMRCateViewPriv = "")
				
				s tempEMRCateViewPriv.EMRDocID = docID
				s tempEMRCateViewPriv.SSGroupID = curSltSSGroupID

				d tempEMRCateViewPriv.%Save()
				d tempEMRCateViewPriv.%Close()
				s tempEMRCateViewPriv = ""
			}
		}
		
		s i = i + 1
	}
	
	//删除未选中的安全组
	s i = 1
	WHILE (i <= unSltSSGroupsCount) 
	{
		s curUnSltSSGroupID = $p(unSltSSGroups, "^", i)
		
		if (curUnSltSSGroupID '= "")
		{
			s docSSGroupRowID = $o(^DHCEMRM.EMRDOC.EMRSSGroupI("IdxCatalogSSGroup", " "_docID, " "_curUnSltSSGroupID, 0))
			//如果有,则删除; 没有则不处理
			if (docSSGroupRowID '= "")
			{
				d ##class(EMRmeta.EMRDocRestriction.CatalogSSGroup).%DeleteId(docSSGroupRowID)
			}
		}
		
		s i = i + 1
	}
	
	//返回
	q "1"
}

ClassMethod GetById(argEMRCateViewPrivID As %String) As EMRservice.entity.TemplatePriv.ETemplateGroup [ WebMethod ]
{
	s result="",id="",tmpResult="" 
	s result=##class(EMRservice.entity.EMRCateViewPriv).%New()
	
	s tmpResult=##class(EMRmeta.EMRDocRestriction.CatalogSSGroup).%OpenId(argEMRCateViewPrivID)
	q:(tmpResult="") result
	s result.ID=argEMRCateViewPrivID
	s result.EMRCategoryID = tmpResult.EMRDocID
	s result.ConditionValue = tmpResult.SSGroupID
	//s result.ConditionDesc = tmpResult.ConditionDesc
		
	q result
}

}
