/// 名称：		EMRservice.BL.BLEMRNavSchemeItemSSGroup
/// 描述：		方案项安全组Bl层
/// 编写者：	yejian
/// 编写时间：	2016-5-17
Class EMRservice.BL.BLEMRNavSchemeItemSSGroup Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator: yejian
/// CreatDate: 2016-5-17
/// Description：获取指定DocID下的所有安全组ID
/// Input: aSchemeCode,aItemCode
/// Return: 安全组1^安全组2^安全组3
ClassMethod GetItemSSGroups(aSchemeCode As %String, aItemCode As %String) As %String
{
	q:(($d(aSchemeCode) = 0)||(aSchemeCode = "")) ""
	q:(($d(aItemCode) = 0)||(aItemCode = "")) ""
	s result = ""
	
	&sql(declare myCursor cursor for
		select SSGroupID into :groupid from EMRmeta.EMRNavigationSchemeItemSSGroup 
		where SchemeCode = :aSchemeCode	And ItemCode = :aItemCode)
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

/// Creator: yejian
/// CreatDate: 2016-5-17
/// Description：保存指定方案项下所适用的安全组
/// Input: aSchemeCode,aItemCode--itemcode^itemname sltSSGroups--所有选中的安全组ID串(格式为 ID1|name^ID2|name^ID3|name), unSltSSGroups--所有未选中的安全组ID串(格式为 ID1|name^ID2|name^ID3|name)
/// Return: 1
ClassMethod ModifySSGroup(aSchemeCode As %String, aItemCode As %String, sltSSGroups As %String, unSltSSGroups As %String) As %String
{
	q:((aSchemeCode="")||(aItemCode="")|| (aSchemeCode = $c(0))|| (aItemCode = $c(0))) "0"
	s strItemCode = $p(aItemCode,"^",1)
	s strItemName = $p(aItemCode,"^",2)
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
		s strSltSSGroupID = $p(curSltSSGroupID,"|",1)
		s strSltSSGroupName = $p(curSltSSGroupID,"|",2)
		if (curSltSSGroupID '= "")
		{
			s docSSGroupRowID = $o(^DHCEMRM.EMRNavItemSSGroupI("IdxCodeSSGroup", " "_$zcvt(aSchemeCode,"U")," "_strItemCode, " "_strSltSSGroupID, 0))
			//如果没有,则新增;有则不处理
			if (docSSGroupRowID = "")
			{
				s objNavSchemeItemSSGroup = ##class(EMRmeta.EMRNavigationSchemeItemSSGroup).%New()
				q:(objNavSchemeItemSSGroup = "")
				
				s objNavSchemeItemSSGroup.SchemeCode = aSchemeCode
				s objNavSchemeItemSSGroup.ItemCode = strItemCode
				s objNavSchemeItemSSGroup.ItemName = strItemName
				s objNavSchemeItemSSGroup.SSGroupID = strSltSSGroupID
				s objNavSchemeItemSSGroup.SSGroupName = strSltSSGroupName
				d objNavSchemeItemSSGroup.%Save()
				d objNavSchemeItemSSGroup.%Close()
				s objNavSchemeItemSSGroup = ""
			}
		}
		
		s i = i + 1
	}
	
	//删除未选中的安全组
	s i = 1
	WHILE (i <= unSltSSGroupsCount) 
	{
		s curUnSltSSGroupID = $p(unSltSSGroups, "^", i)
		s strSltSSGroupID = $p(curUnSltSSGroupID,"|",1)
		if (strSltSSGroupID '= "")
		{
			s itemSSGroupRowID = $o(^DHCEMRM.EMRNavItemSSGroupI("IdxCodeSSGroup", " "_$zcvt(aSchemeCode,"U")," "_strItemCode, " "_strSltSSGroupID, 0))
			//如果有,则删除; 没有则不处理
			if (itemSSGroupRowID '= "")
			{
				d ##class(EMRmeta.EMRNavigationSchemeItemSSGroup).%DeleteId(itemSSGroupRowID)
			}
		}
		
		s i = i + 1
	}
	
	//返回
	q "1"
}

}
