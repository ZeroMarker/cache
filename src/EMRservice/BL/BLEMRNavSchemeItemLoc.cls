/// 名称:EMRservice.BL.BLEMRNavSchemeItemLoc
/// 描述:患者完整病历内容的组织方案科室服务
/// 编写者：yejian
/// 编写日期: 2016-5-17
Class EMRservice.BL.BLEMRNavSchemeItemLoc Extends (%RegisteredObject, %XML.Adaptor)
{

Query SelectAllLocRowId() As %SQLQuery(CONTAINID = 1, ROWSPEC = "Code:%String,Des:%String,HosID:%String,HosName:%String")
{
SELECT c.CTLOC_RowId,c.CTLOC_Desc,c.CTLOC_Hospital_DR->HOSP_RowId,c.CTLOC_Hospital_DR->HOSP_Desc
FROM SQLUser.CT_Loc c
where  c.CTLOC_Type IN ('E','W','OP','EM','O')
Order By c.CTLOC_Desc,c.CTLOC_RowId
}

/// Creator: yejian
/// CreatDate: 2016-5-17
/// Description：获取指定DocID下的所有科室ID
/// Input: aSchemeCode,aItemCode
/// Return: 科室1^科室2^科室3
ClassMethod GetItemLoc(aSchemeCode As %String, aItemCode As %String) As %String
{
	q:(($d(aSchemeCode) = 0)||(aSchemeCode = "")) ""
	q:(($d(aItemCode) = 0)||(aItemCode = "")) ""
	s result = ""
	
	&sql(declare myCursor cursor for
		select CTLocID into :groupid from EMRmeta.EMRNavigationSchemeItemLoc 
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
/// Description：保存指定方案项下所适用的科室
/// Input: aSchemeCode,aItemCode--itemcode^itemname sltLocs--所有选中的科室ID串(格式为 ID1|name^ID2|name^ID3|name), unSltLocs--所有未选中的科室ID串(格式为 ID1|name^ID2|name^ID3|name)
/// Return: 1
ClassMethod ModifyLoc(aSchemeCode As %String, aItemCode As %String, sltLocs As %String, unSltLocs As %String) As %String
{
	q:((aSchemeCode="")||(aItemCode="")|| (aSchemeCode = $c(0))|| (aItemCode = $c(0))) "0"
	s strItemCode = $p(aItemCode,"^",1)
	s strItemName = $p(aItemCode,"^",2)
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
		//s strcurSltLocID = $p(curSltLocID,"|",1)
		//s strcurSltLocName = $p(curSltLocID,"|",2)
		s strcurSltLocID = curSltLocID
		S strcurSltLocName = $p($g(^CTLOC(curSltLocID)),"^",2)
		if (curSltLocID '= "")
		{
			s docLocRowID = $o(^DHCEMRM.EMRNavItemLocI("IdxCodeCTLocID", " "_$zcvt(aSchemeCode,"U")," "_strItemCode, " "_strcurSltLocID, 0))
			//如果没有,则新增;有则不处理
			if (docLocRowID = "")
			{
				s objNavSchemeItemLoc = ##class(EMRmeta.EMRNavigationSchemeItemLoc).%New()
				q:(objNavSchemeItemLoc = "")
				
				s objNavSchemeItemLoc.SchemeCode = aSchemeCode
				s objNavSchemeItemLoc.ItemCode = strItemCode
				s objNavSchemeItemLoc.ItemName = strItemName
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
		//s strcurSltLocID = $p(curUnSltLocID,"|",1)
		s strcurSltLocID =curUnSltLocID
		if (strcurSltLocID '= "")
		{
			s itemLocRowID = $o(^DHCEMRM.EMRNavItemLocI("IdxCodeCTLocID", " "_$zcvt(aSchemeCode,"U")," "_strItemCode, " "_strcurSltLocID, 0))
			//如果有,则删除; 没有则不处理
			if (itemLocRowID '= "")
			{
				d ##class(EMRmeta.EMRNavigationSchemeItemLoc).%DeleteId(itemLocRowID)
			}
		}
		
		s i = i + 1
	}
	
	//返回
	q "1"
}

}
