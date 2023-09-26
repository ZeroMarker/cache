Class EMRservice.BL.BLiBookLink Extends %RegisteredObject
{

/// w ##class(EMRservice.BL.BLiBookLink).AddCateRestriction(1,0)
ClassMethod AddCateRestriction(ACategoryID, ACTLocID) As %String
{
	q:(ACategoryID="")||(ACTLocID="") ""
	s RestrictionID = ""
	//检查是否有关联（0关联全部科室）
	s RestrictionID = $o(^DHCEMRM.iBookRestrictionI("IdxCateRule", " "_ACategoryID, " 0", ""))
	q:(RestrictionID'="") RestrictionID
	s RestrictionID = $o(^DHCEMRM.iBookRestrictionI("IdxCateRule", " "_ACategoryID, " "_ACTLocID, ""))
	q:(RestrictionID'="") RestrictionID
	s RestrictionOBJ = ##class(EMRmeta.Repository.iBookRestriction).%New()
	s RestrictionOBJ.iBookCategoryID = ACategoryID
	s RestrictionOBJ.RuleItemID = ACTLocID
	//科室号为0关联全部科室，否则只关联对应科室
	if (ACTLocID = 0){
		s RestrictionOBJ.RuleItemDesc = "全科室"
	}else{
		s DeptDesc=$p($g(^CTLOC(ACTLocID)),"^",2)
		if $l(DeptDesc,"-")>1 {s DeptDesc=$p($g(DeptDesc),"-",2)}
		s RestrictionOBJ.RuleItemDesc = DeptDesc
	}
	d RestrictionOBJ.%Save()
	q RestrictionOBJ.%Id()
}

/// w ##class(EMRservice.BL.BLiBookLink).DeleteCateRestriction(8,-1)
ClassMethod DeleteCateRestriction(ACategoryID, ACTLocID) As %String
{
	q:(ACategoryID = "") "0"	
	//非-1删除对应，如果本来就没有视为成功
	if (ACTLocID '= -1){
		s RestrictionID = $o(^DHCEMRM.iBookRestrictionI("IdxCateRule", " "_ACategoryID, " "_ACTLocID, ""))
		q:(RestrictionID = "") "1"
		d ##class(EMRmeta.Repository.iBookRestriction).%DeleteId(RestrictionID)
	}else{
	//-1删除所有
		s RestrictionID = ""
		for{
			s RestrictionID = $o(^DHCEMRM.iBookRestrictionI("IdxCategoryID", " "_ACategoryID, RestrictionID))
			q:(RestrictionID = "")
			d ##class(EMRmeta.Repository.iBookRestriction).%DeleteId(RestrictionID)
		}
	}
	q "1"
}

/// w ##class(EMRservice.BL.BLiBookLink).AddiBLink(1,"Template",2804)
ClassMethod AddiBLink(AiBookID, AType, AItemID) As %String
{
	q:(AiBookID = "")||(AItemID = "") ""
	s AType = $zcvt(AType,"u")
	//检查是否有关联
	s LinkID = $o(^DHCEMRM.iBookItemLinkI("IdxiBookIDItemID", " "_AiBookID, " "_AType, " "_AItemID,""))
	q:(LinkID'="") LinkID_"haha"
	//不存在配置全部知识库问题，按照对应的知识库ID关联即可
	s LinkOBJ = ##class(EMRmeta.Repository.iBookItemLink).%New()
	s iBOBJ = ##class(EMRmeta.Repository.iBook).%OpenId(AiBookID)
	if (AType = "KBNODE")
	{
		s kBOBJ = ##class(EMRmeta.KBNode).%OpenId(AItemID)
		s LinkOBJ.LinkItemID = AItemID
		s LinkOBJ.LinkItemDesc = kBOBJ.Description
	}
	elseif (AType = "TEMPLATE")
	{
		s TempOBJ = ##class(EMRmeta.EMRTemplateCategory).%OpenId(AItemID)
		s LinkOBJ.LinkItemID = AItemID
		s LinkOBJ.LinkItemDesc = TempOBJ.CategoryName
	}
	s LinkOBJ.LinkItemType = AType
	s LinkOBJ.iBookID = AiBookID
	s LinkOBJ.iBookTitle = iBOBJ.Name
	d LinkOBJ.%Save()
	q LinkOBJ.%Id()
}

/// w ##class(EMRservice.BL.BLiBookLink).DeleteiBLink(7,"KBNode",7)
ClassMethod DeleteiBLink(AiBookID, AType, AItemID) As %String
{
	q:(AiBookID = "") "0"
	//非-1删除对应，如果本来就没有视为成功
	if (AItemID '= -1){
		s AType = $zcvt(AType,"u")
		s LinkID = $o(^DHCEMRM.iBookItemLinkI("IdxiBookIDItemID", " "_AiBookID, " "_AType, " "_AItemID,""))
		q:(LinkID = "") "1"
		d ##class(EMRmeta.Repository.iBookItemLink).%DeleteId(LinkID)
	}else{
	//-1删除所有
		s Type = ""
		for{
			s Type = $o(^DHCEMRM.iBookItemLinkI("IdxiBookIDItemID", " "_AiBookID, Type))
			q:(Type = "")
			s ItemID = ""
			for{
				s ItemID = $o(^DHCEMRM.iBookItemLinkI("IdxiBookIDItemID", " "_AiBookID, Type, ItemID))
				q:(ItemID = "")
				s LinkID = $o(^DHCEMRM.iBookItemLinkI("IdxiBookIDItemID", " "_AiBookID, Type, ItemID, ""))
				d ##class(EMRmeta.Repository.iBookItemLink).%DeleteId(LinkID)
			}
		}
	}
	q "1"
}

ClassMethod SetCateLocLink(SltLocs, SltCates, unSltCates) As %String
{
	//s ^CACHEEMR("EMR")=SltLocs_"^"_SltCates_"^"_unSltCates
	q:((SltLocs = "")||(SltCates_unSltCates = "")) "0"
	s LocCount = $l(SltLocs,"^")
	s SltCount = $l(SltCates,"^")
	s unSltCount = $l(unSltCates,"^")
	s i=1
	while(i<=LocCount){
		s currentLoc = $p(SltLocs,"^",i)
		s j=1
		while(j<=SltCount){
			s curSltCate = $p(SltCates, "^", j)
			d ..AddCateRestriction(curSltCate, currentLoc)
			s j = j + 1
		}
		s j=1
		while(j<=unSltCount){
			s curunSltCate = $p(unSltCates, "^", j)
			d ..DeleteCateRestriction(curunSltCate, currentLoc)
			s j = j + 1
		}
		s i = i + 1
	}
	q "1"
}

/// w ##class(EMRservice.BL.BLiBookLink).SetItemLink(7,"KBNode","7^8","")
ClassMethod SetItemLink(NodeID, NodeType, SltItems, unSltItems) As %String
{
	q:((NodeID = "")||(SltItems_unSltItems = "")) "0"
	s NodeCount = $l(NodeID,"^")
	s SltCount = $l(SltItems,"^")
	s unSltCount = $l(unSltItems,"^")
	s i=1
	while(i<=NodeCount){
		s curNode = $p(NodeID,"^",i)
		s j=1
		while(j<=SltCount){
			s curSltItemID = $p(SltItems, "^", j)
			d ..AddiBLink(curSltItemID, NodeType, curNode)
			s j = j + 1
		}
		s j=1
		while(j<=unSltCount){
			s curunSltItemID = $p(unSltItems, "^", j)
			d ..DeleteiBLink(curunSltItemID, NodeType, curNode)
			s j = j + 1
		}
		s i = i + 1
	}
	q "1"
}

ClassMethod GetiBookIDByLinkID(AType, AItemID, ACTlocID)
{
		s result = ""
		q:(AItemID = "") result
		s AType = $zcvt(AType,"u") 
		s iBookID = ""
		s LinkID = ""
		for
		{
			s LinkID = $o(^DHCEMRM.iBookItemLinkI("IdxLinkItemID", " "_AType, " "_AItemID, LinkID))
			q:(LinkID = "")
			s LinkOBJ = ##class(EMRmeta.Repository.iBookItemLink).%OpenId(LinkID)
			q:(LinkOBJ = "")
			s iBookID = LinkOBJ.iBookID
			s candisplay = ##class(EMRservice.BL.BLiBook).CheckRestriction(iBookID,ACTlocID)
			q:(candisplay = "")
			s:(result '= "") result = result_","
			s result = result_iBookID
		}
		q result
}

}
