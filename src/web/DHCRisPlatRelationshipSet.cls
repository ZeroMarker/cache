Import SQLUser

/// 检查关系配置类
Class web.DHCRisPlatRelationshipSet Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 导入检查组信息
/// w ##class(web.DHCRisPlatRelationshipSet).ImportExamGroup(^DHCRisTemp("ImportExamGroup"))
ClassMethod ImportExamGroup(info As %String) As %String
{
	n (info)
	s ^DHCRisTemp("ImportExamGroup")=info
	s examGroupCode=$p(info,"^",1)
	s examGroupDesc=$p(info,"^",2)
	s itemCatCode=$p(info,"^",3)
	s itemCatDesc=$p(info,"^",4)
	s itemCatRowid=$p(info,"^",5)
	s relationShip=$p(info,"^",6)
	s arcItemRowid=$p(info,"^",7)
	s arcItemCode=$p(info,"^",8)
	s arcItemDesc=$p(info,"^",9)
	s bodyRowid=$p(info,"^",10)
	s bodyCode=$p(info,"^",11)
	s bodyDesc=$p(info,"^",12)
	
	//
	if ((examGroupCode="")||(examGroupDesc=""))
	{
		q:"-100^检查组描述和Code不能为空"
	}
	
	//查询检查组id
	s groupRowid=$o(^DHCRBExamGroupi("GourpCode",examGroupCode,""))
	b //02
	if (groupRowid'="")
	{
		s groupObj=##class(User.DHCRBExamGroup).%OpenId(groupRowid)
		
	}
	else
	{
		s groupObj=##class(User.DHCRBExamGroup).%New()
	}
	s groupObj.DREGGroupCode=examGroupCode
	s groupObj.DREGGroupName=examGroupDesc
	s groupObj.DREGItemCatCode=itemCatCode
	if (itemCatRowid="")
	{
		if (itemCatCode'="")
		{
			s itemCatRowid=$o(^ARC("IC",0,"Code",$$ALPHAUP^SSUTIL4(itemCatCode),""))
		}
	}
	
	b //01
	if (itemCatRowid'="")
	{
		s groupObj.DREGItemCatDR=##class(User.ARCItemCat).%OpenId(itemCatRowid)  ;itemCatRowid
	}
	s groupObj.DREGRelationOfChildTable=relationShip
	

	s sc=groupObj.%Save()
	if ($$$ISERR(sc)){
		q "-20000^检查组保存失败"
	}else{
		s ret="0"
		s SQLCODE=0
	}
	
	s groupRowid=groupObj.%Id()
	//s groupObj.
	
	if (arcItemRowid="")
	{
		if (arcItemCode'="")
		{
			s arcItmSub=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(arcItemCode),""))
			if (arcItmSub'="")
			{
				s arcItmVersion=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(arcItemCode),arcItmSub,""))
				if (arcItmVersion'="")
				{
					s arcItemRowid=arcItmSub_"||"_arcItmVersion
				}
			}
		}
	}
	if (arcItemRowid'="")
	{
		s subRowid=$o(^DHCRBExamGroup(0,"ItemMastIndex",arcItemRowid,groupRowid,""))
		if (subRowid="")
		{
			&sql(insert into DHCRB_ExamGroupItem(DHCRB_ExamGroup, DREGI_ItmMast_DR, DREGI_ItemCode, DREGI_ItemDesc, DREGI_BodyDR, DREGI_BodyCode)
	    		values(:groupRowid,:arcItemRowid,:arcItemCode,:arcItemDesc,:bodyRowid,:bodyCode))
		}
	}
	
	/*s groupItemObj=##class(User.DHCRBExamGroupItem).%New()
	s groupItemObj.DHCRBExamGroup=groupObj
	s groupItemObj.DREGIItemCode=arcItemCode
	s groupItemObj.DREGIItmMastDR=arcItemRowid
	s groupItemObj.DREGIItemDesc=arcItemDesc
	s groupItemObj.DREGIBodyCode=bodyCode
	s groupItemObj.DREGIBodyDR=bodyRowid
	
	s sc=groupItemObj.%Save()
	if ( $$$ISERR(sc))
	{
		b //02
		q "-20001^检查组项目保存失败"
	}
	else
	{
		b //01
		s ret="0"
	}*/
	
	
	q $g(SQLCODE)
}

/// 导入互斥检查信息
/// w ##class(web.DHCRisPlatRelationshipSet).ImportRejectExamInfo(^DHCRisTemp("ImportRejectExamInfo"))
ClassMethod ImportRejectExamInfo(info As %String) As %String
{
	n (info)
	s ^DHCRisTemp("ImportRejectExamInfo")=info

	s arcItemRowid=$p(info,"^",1)
	s arcItemCode=$p(info,"^",2)
	s arcItemDesc=$p(info,"^",3)
	s bodyRowid=$p(info,"^",4)
	s bodyCode=$p(info,"^",5)
	s bodyDesc=$p(info,"^",6)
	s rejectGroupID=$p(info,"^",7)
	s rejectGroupCode=$p(info,"^",8)
	s rejectGroupDesc=$p(info,"^",9)
	s rejectArcItemRowid=$p(info,"^",10)
	s rejectArcItemCode=$p(info,"^",11)
	s rejectArcItemDesc=$p(info,"^",12)
	s rejectBodyRowid=$p(info,"^",13)
	s rejectBodyCode=$p(info,"^",14)
	//s rejectBodyDesc=$p(info,"^",15)
	s time=$p(info,"^",15)
	s timeUnit=$p(info,"^",16)
	s hintType=$p(info,"^",17)
	
	//
	if (arcItemRowid="")
	{
		if (arcItemCode'="")
		{
			s arcItmSub=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(arcItemCode),""))
			if (arcItmSub'="")
			{
				s arcItmVersion=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(arcItemCode),arcItmSub,""))
				if (arcItmVersion'="")
				{
					s arcItemRowid=arcItmSub_"||"_arcItmVersion
				}
			}
		}
	}
	
	if (arcItemRowid="")
	{
		q:"-100^检查项目ID和Code不能都为空"
	}
	
	//插入DHCRB_ExamSortProperty表数据
	s sortPropertyRowid=$o(^User.DHCRBExamSortPropertyI("ItmMastIndex",arcItemRowid,""))
	if (sortPropertyRowid="")
	{
		&sql(insert into DHCRB_ExamSortProperty(ItmMastDr) values(:arcItemRowid))
	}
	
	if (rejectGroupID="")
	{
		if (rejectGroupCode'="")
		{
			s rejectGroupID=$o(^DHCRBExamGroupi("GourpCode",rejectGroupCode,""))
		}
	}
	
	if (rejectArcItemRowid="")
	{
		if (rejectArcItemCode'="")
		{
			s arcItmSub=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(rejectArcItemCode),""))
			if (arcItmSub'="")
			{
				s arcItmVersion=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(rejectArcItemCode),arcItmSub,""))
				if (arcItmVersion'="")
				{
					s rejectArcItemRowid=arcItmSub_"||"_arcItmVersion
				}
			}
		}
	}
	
	if ((rejectGroupID="")&&(rejectArcItemRowid=""))
	{
		q:"-200^互斥项目和互斥组不能都为空"
	}
	
	//判断是否存在DHCRB_ExamRejectItem
	if (rejectArcItemRowid'="")
	{
		s rejectTabelRowid=$o(^User.DHCRBExamRejectItemI("RejectItmMastIndex"," "_arcItemRowid," "_rejectArcItemRowid,""))
	}
	elseif (rejectGroupID'="")
	{
		s rejectTabelRowid=$o(^User.DHCRBExamRejectItemI("ExamGroupIndex"," "_arcItemRowid,rejectGroupID,""))
	}
	
	if (rejectTabelRowid'="")
	{
		&sql(update DHCRB_ExamRejectItem (ItmMastDR,ItmMastCode, ItmBodyDR, ItmBodyCode, ExamGroupID, RejectExamGroupCode,RejectItmMastDR, RejectItmMastCode, RejectItmBodyDR, RejectItmBodyCode, RejectTime, TimeUnit, HintType)
			VALUES(:arcItemRowid,:arcItemCode,:bodyRowid,:bodyCode,:rejectGroupID,:rejectGroupCode,:rejectArcItemRowid,:rejectArcItemCode,:rejectBodyRowid,:rejectBodyCode,:time,:timeUnit,:hintType) where ID=:rejectTabelRowid )
	}
	else
	{
		&sql(INSERT INTO DHCRB_ExamRejectItem (ItmMastDR,ItmMastCode, ItmBodyDR, ItmBodyCode, ExamGroupID, RejectExamGroupCode,RejectItmMastDR, RejectItmMastCode, RejectItmBodyDR, RejectItmBodyCode, RejectTime, TimeUnit, HintType)
			VALUES(:arcItemRowid,:arcItemCode,:bodyRowid,:bodyCode,:rejectGroupID,:rejectGroupCode,:rejectArcItemRowid,:rejectArcItemCode,:rejectBodyRowid,:rejectBodyCode,:time,:timeUnit,:hintType))
	}
	b //01
	q $g(SQLCODE)
}

/// 导入互斥检查信息
/// w ##class(web.DHCRisPlatRelationshipSet).ImportPrepositionInfo(^DHCRisTemp("ImportRejectExamInfo"))
ClassMethod ImportPrepositionInfo(info As %String) As %String
{
	n (info)
	s ^DHCRisTemp("ImportRejectExamInfo")=info

	s arcItemRowid=$p(info,"^",1)
	s arcItemCode=$p(info,"^",2)
	s arcItemDesc=$p(info,"^",3)
	s bodyRowid=$p(info,"^",4)
	s bodyCode=$p(info,"^",5)
	s bodyDesc=$p(info,"^",6)
	s PrepositionGroupID=$p(info,"^",7)
	s PrepositionGroupCode=$p(info,"^",8)
	s PrepositionGroupDesc=$p(info,"^",9)
	s PrepositionArcItemRowid=$p(info,"^",10)
	s PrepositionArcItemCode=$p(info,"^",11)
	s PrepositionArcItemDesc=$p(info,"^",12)
	s PrepositionBodyRowid=$p(info,"^",13)
	s PrepositionBodyCode=$p(info,"^",14)
	
	s time=$p(info,"^",15)
	s timeUnit=$p(info,"^",16)
	s hintType=$p(info,"^",17)
	
	//
	if (arcItemRowid="")
	{
		q:"-100^检查项目ID不能为空"
	}
	
	if ((PrepositionGroupID="")&&(PrepositionArcItemRowid=""))
	{
		q:"-200^前置项目和前置组不能都为空"
	}
	
	
	&sql(INSERT INTO DHCRB_ExamPrepositionItem (ItmMastDR, ItmMastCode, ItmBodyDR, ItmBodyCode, ExamGroupID, PrepositonExamGroupCode, PrepositonItmMastDR, PrepositonItmMastCode, PrepositonItmBodyDR, PrepositonItmBodyCode, PreTime, TimeUnit, HintType)
			VALUES(:arcItemRowid,:arcItemCode,:bodyRowid,:bodyCode,:PrepositionGroupID,:PrepositionGroupCode,:PrepositionArcItemRowid,:PrepositionArcItemCode,:PrepositionBodyRowid,:PrepositionBodyCode,:time,:timeUnit,:hintType))
	
	b //01
	q $g(SQLCODE)
}

}
