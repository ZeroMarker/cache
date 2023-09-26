Class DHCEPRFS.BL.BLMREpisodeRelate Extends %RegisteredObject [ ProcedureBlock ]
{

/// Desc: 新增就诊关联
/// Debug: w ##class(DHCEPRFS.BL.BLMREpisodeRelate).AddRelation("12","NewBorn","117")
ClassMethod AddRelation(AMREpisodeID As %String, ARelatedType As %String, ARelatedMREpisodeID As %String) As %String
{
	s ret = "-1"
	q:(AMREpisodeID = "")||(ARelatedType = "")||(ARelatedMREpisodeID = "") ret
	s ret = "1"
	s relationID = ""
	s relationID = $o(^DHCEPRFS.INST.MREpisodeRelateI("IdxTypeMREpisodeID"," "_AMREpisodeID," "_$zcvt(ARelatedType,"U"),ARelatedMREpisodeID,relationID))
	if (relationID = "")
	{
		s objRelation = ##class(DHCEPRFS.INST.MREpisodeRelate).%New()
		s objRelation.MREpisodeID = AMREpisodeID
		s objRelation.RelatedType = ARelatedType
		s objRelation.RelatedMREpisodeID = ARelatedMREpisodeID
		s sc = objRelation.%Save()
		if ($$$ISERR(sc))
		{
			s ret = "0"
		}
	}
	q ret
}

/// Desc: 删除就诊关联
/// Debug: w ##class(DHCEPRFS.BL.BLMREpisodeRelate).DeleteRelation("115","OutPatient","119")
ClassMethod DeleteRelation(AMREpisodeID As %String, ARelatedType As %String, ARelatedMREpisodeID As %String) As %String
{
	s ret = "-1"
	q:(AMREpisodeID = "")||(ARelatedType = "")||(ARelatedMREpisodeID = "") ret
	s ret = "1"
	s relationID = ""
	s relationID = $o(^DHCEPRFS.INST.MREpisodeRelateI("IdxTypeMREpisodeID"," "_AMREpisodeID," "_$zcvt(ARelatedType,"U"),ARelatedMREpisodeID,relationID))
	if (relationID '= "")
	{
		s sc = ##class(DHCEPRFS.INST.MREpisodeRelate).%DeleteId(relationID)
		if ($$$ISERR(sc))
		{
			s ret = "0"
		}
	}
	q ret
}

/// Desc: 按类型获取关联归档就诊
/// Debug: w ##class(DHCEPRFS.BL.BLMREpisodeRelate).GetRelatedMREpisodeByType("12","NewBorn")
ClassMethod GetRelatedMREpisodeByType(AMREpisodeID As %String, ARelatedType As %String) As %String
{
	s ret = ""
	q:(AMREpisodeID = "")||(ARelatedType = "") ret
	f i=1:1:$l(ARelatedType,"^")
	{
		s xRelatedType = $p(ARelatedType,"^",i)
		s xMREpisodeID = ""
		f {
			s xMREpisodeID = $o(^DHCEPRFS.INST.MREpisodeRelateI("IdxTypeMREpisodeID"," "_AMREpisodeID," "_$zcvt(xRelatedType,"U"),xMREpisodeID))
			q:(xMREpisodeID = "")
			if (ret = "") {
				s ret = xMREpisodeID
			}
			else {
				s ret = ret_"^"_xMREpisodeID
			}
		}
	}
	q ret
}

/// Desc: 获取关联类型
/// Debug: w ##class(DHCEPRFS.BL.BLMREpisodeRelate).GetRelatedType("12","117")
ClassMethod GetRelatedType(AMREpisodeID As %String, ARelatedMREpisodeID As %String) As %String
{
	s ret = ""
	q:(AMREpisodeID = "")||(ARelatedMREpisodeID = "") ret
	s relationID = ""
	s relationID = $o(^DHCEPRFS.INST.MREpisodeRelateI("IdxRelatedMREpisodeID"," "_AMREpisodeID," "_ARelatedMREpisodeID,relationID))
	if (relationID '= "")
	{
		s objRelation = ##class(DHCEPRFS.INST.MREpisodeRelate).%OpenId(relationID)
		s ret = objRelation.RelatedType
		d objRelation.%Close()
	}
	q ret
}

/// Desc: 新增生成队列时, 按类型添加就诊关联
/// Debug: w ##class(DHCEPRFS.BL.BLMREpisodeRelate).RegRelationByCreate("DHC","135")
ClassMethod RegRelationByCreate(ASysCode As %String, AEpisodeID As %String) As %String
{
	s ret = "0"
	q:(AEpisodeID = "") ret
	s paAdmType = $p($g(^PAADM(AEpisodeID)),"^",2)
	q:(paAdmType '= "I") ret
	
	s ret = "1"
	s createRelatedType = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("CreateRelatedType")
	for i=1:1:$l(createRelatedType,"^")
	{
		s xType = $p(createRelatedType,"^",i)
		if (xType = "NewBorn")
		{
			s flagNewBorn = ..RelateWithNewBorn(ASysCode,AEpisodeID)
			s:(+flagNewBorn<1) ret = "-1"
		}
		elseif (xType = "OutPatient")
		{
			s flagOutPatient = ..RelateWithOutPatient(ASysCode,AEpisodeID)
			s:(+flagOutPatient<1) ret = "-2"
		}
		else
		{}
	}
	q ret
}

/// Desc: 关联新生儿
/// Debug: w ##class(DHCEPRFS.BL.BLMREpisodeRelate).RelateWithNewBorn("DHC","135")
ClassMethod RelateWithNewBorn(ASysCode As %String, AEpisodeID As %String) As %String
{
	s ret = "0"
	q:(AEpisodeID = "") ret
	s mrEpisodeID = ##class(DHCEPRFS.BL.BLMREpisode).GetMREpisodeIDByAdm(AEpisodeID,ASysCode)
	q:(mrEpisodeID = "") ret
	
	s ret = "1"
	s relatedType = "NewBorn", priority = "50"
	s childEpisodeList = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetChildEpisodeIDByAdm(AEpisodeID)
	for i=1:1:$l(childEpisodeList,"^")
	{
		s xChildEpisodeID = $p(childEpisodeList,"^",i)
		s xChildMREpisodeID = ##class(DHCEPRFS.BL.BLMREpisode).RegMREpisodeIDByAdm(xChildEpisodeID,ASysCode)
		continue:(xChildMREpisodeID = "")
		s flagRelation = ..AddRelation(mrEpisodeID,relatedType,xChildMREpisodeID)
		s:(+flagRelation<1) ret = "-1"
		s flagQueue = ##class(DHCEPRFS.BL.BLAdmTaskQueue).Create(ASysCode,xChildEpisodeID,priority)
		s:(+flagQueue<1) ret = "-2"
	}
	q ret
}

/// Desc: 关联门诊就诊
/// Debug: w ##class(DHCEPRFS.BL.BLMREpisodeRelate).RelateWithOutPatient("DHC","135")
ClassMethod RelateWithOutPatient(ASysCode As %String, AEpisodeID As %String) As %String
{
	s ret = "0"
	q:(AEpisodeID = "") ret
	s mrEpisodeID = ##class(DHCEPRFS.BL.BLMREpisode).GetMREpisodeIDByAdm(AEpisodeID,ASysCode)
	q:(mrEpisodeID = "") ret
	
	s ret = "1"
	s relatedType = "OutPatient", priority = "50"
	s opEpisodeList = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetOPEpisodeIDByIP(AEpisodeID)
	for i=1:1:$l(opEpisodeList,"^")
	{
		s xOPEpisodeID = $p(opEpisodeList,"^",i)
		s xOPMREpisodeID = ##class(DHCEPRFS.BL.BLMREpisode).RegMREpisodeIDByAdm(xOPEpisodeID,ASysCode)
		continue:(xOPMREpisodeID = "")
		s flagRelation = ..AddRelation(mrEpisodeID,relatedType,xOPMREpisodeID)
		s:(+flagRelation<1) ret = "-1"
		s flagQueue = ##class(DHCEPRFS.BL.BLAdmTaskQueue).Create(ASysCode,xOPEpisodeID,priority)
		s:(+flagQueue<1) ret = "-2"
	}
	q ret
}

}
