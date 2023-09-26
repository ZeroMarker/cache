/// 名称：		EMRservice.BL.BLDiagnosKBConfig
/// 描述：		知识关联病种BL层
/// 编写者：	yejian
/// 编写时间：	2016-8-2
Class EMRservice.BL.BLDiagnosKBConfig Extends (%RegisteredObject, %XML.Adaptor)
{

/// 根据病种编码获取知识库关联节点集
/// do ##Class(EMRservice.BL.BLDiagnosKBConfig).GetNodeIdSByDiagnosID("BINZ001")
ClassMethod GetNodeIdSByDiagnosID(ADiagnosCode As %String) As %String
{
  	s ret = ""
	q:(ADiagnosCode="") ret
	s RowID =""
	for 
	{
		s RowID = $o(^DHCEMRM.DiagnosKBNodeI("IdxDiagnosCode"," "_$zcvt(ADiagnosCode,"U"),RowID))
		q:(RowID = "")
		s objDKBConfig = ##Class(EMRmeta.DiagnosKBNode).%OpenId(RowID)
		q:(objDKBConfig = "")
		s ret =ret_objDKBConfig.KBNodeID_"^"
    }
	q ret
}

/// Debug: s ret = ##Class(EMRservice.BL.BLDiagnosKBConfig).GetKBNodeDiagnosByID(1)
ClassMethod GetKBNodeDiagnosByID(ARowID As %String) As EMRservice.entity.EDiagnosKBNode
{
	s ret = ""
	q:(ARowID = "") ret
	
	s objKBNodeDiagnos = ##Class(EMRmeta.DiagnosKBNode).%OpenId(ARowID)
	q:(objKBNodeDiagnos = "") ""
	
	s Result = ##Class(EMRservice.entity.EDiagnosKBNode).%New()
	s Result.ID = ARowID
	s Result.KBNodeID = objKBNodeDiagnos.KBNodeID
	s Result.KBTreeID = objKBNodeDiagnos.KBTreeID
	s Result.KBDiagnosID = objKBNodeDiagnos.KBDiagnosID
	s Result.ActiveFlag = objKBNodeDiagnos.ActiveFlag

	q Result
}

/// do ##Class(EMRservice.BOEMRDiagnosConfig).GetDiagnosByNodeID("11053")
ClassMethod GetDiagnosByNodeID(NodeID As %String) As %String
{
  	s ret = ""
	q:(NodeID="") ret
	s RowID = $o(^DHCEMRM.DiagnosKBNodeI("IdxKBNodeID",""_NodeID,""))
	while RowID '=""
	{
		s Flag=$LI(^DHCEMRM.DiagnosKBNodeD(RowID),5)
		if Flag'=0
		{
		   s ret =ret_$LI(^DHCEMRM.DiagnosKBNodeD(RowID),2)_"^"
		}
        s RowID = $o(^DHCEMRM.DiagnosKBNodeI("IdxKBNodeID",""_NodeID,RowID))
    }
	q ret
}

/// Desc:	获取知识库节点与疾病关联的多条件组合
/// Return:	$KBNodeDiagnosID^CtLocID^CtLocDesc^DiagnosID^DiagnosDesc^DictionaryID|DictionaryDesc|Code=Value*Code=Value*Code=Value
/// Debug:	w ##Class(EMRservice.BL.BLDiagnosKBConfig).GetKBNodeDiagnosWithRules(343)
ClassMethod GetKBNodeDiagnosWithRules(AKBNodeID As %String) As %String
{
	s ret = ""
	q:(AKBNodeID = "") ret
	
	s count = 0
	s diagnosID = ""
	k ^CacheTempEMRDiagnos
	
	for {
		s diagnosID = $o(^DHCEMRM.DiagnosKBNodeI("IdxKBNodeID",AKBNodeID,diagnosID))
		q:(diagnosID = "")
		
		s objDiagnosKB = ##Class(EMRmeta.DiagnosKBNode).%OpenId(diagnosID)
		continue:(objDiagnosKB = "")
		s strDiagnosCode = objDiagnosKB.DiagnosCode
		s ARowID = $o(^DHCEMRM.DiagnosI("IdxDiagnosCode"," "_$zcvt(strDiagnosCode,"U"),""))
		continue:(ARowID = "")
		s objDiagnos = ##Class(EMRmeta.Diagnos).%OpenId(ARowID)
		continue:(objDiagnos = "")
		s DiagnosName = objDiagnos.DiagnosName
		
		s kbNodeDiagnosID = $o(^DHCEMRM.DiagnosKBNodeI("IdxNodeIDAndDiagnosCode",AKBNodeID," "_$zcvt(strDiagnosCode,"U"),""))
		s objKBNodeDiagnos = ##Class(EMRmeta.DiagnosKBNode).%OpenId(kbNodeDiagnosID)
		continue:(objKBNodeDiagnos.ActiveFlag = 0)
		
		s curKBNodeDiagnosRule = kbNodeDiagnosID_"^"_strDiagnosCode_"^"_DiagnosName	
		
		s count = count + 1
		
		s rowID = ""
		for {
			s rowID = $o(^DHCEMRM.DiagnosKBNodeRuleI("IdxDiagnosKBNodeID"," "_kbNodeDiagnosID,rowID))
			q:(rowID = "")
			
			s objKBNodeDiagnosRule = ##Class(EMRmeta.DiagnosKBNodeRule).%OpenId(rowID)
			continue:(objKBNodeDiagnosRule = "")
			
			s ruleID = objKBNodeDiagnosRule.DiagnosRuleID
			s paramCode = objKBNodeDiagnosRule.DiagnosRuleCode
			s paramDesc = objKBNodeDiagnosRule.DiagnosRuleDesc
			
			s ^CacheTempEMRDiagnos(diagnosID,ruleID,paramCode) = paramDesc	
		}

		if ($d(^CacheTempEMRDiagnos(diagnosID)))
		{
			s rCount = 0
			s strRules = ""
			s curRuleID = ""
			for {
				s curRuleID = $o(^CacheTempEMRDiagnos(diagnosID,curRuleID))
				q:(curRuleID = "")
				s objStd = ##Class(EMRmeta.StdDictionary).%OpenId(curRuleID)
				
				s ruleDesc = objStd.Description
				
				s parCount = 0
				s strParams = ""
				s paramCode = ""
				for {
					s paramCode = $o(^CacheTempEMRDiagnos(diagnosID,curRuleID,paramCode))
					q:(paramCode = "")
					
					if (parCount > 0)
					{
						s strParams = strParams_"*"
					}
					s parCount = parCount + 1
					s strParams = strParams_paramCode_"="_$g(^CacheTempEMRDiagnos(diagnosID,curRuleID,paramCode))		
				}
				
				if (rCount > 0)
				{
					s strRules = strRules_"?"	
				}
				s rCount = rCount + 1
				s strRules = strRules_curRuleID_"|"_ruleDesc_"|"_strParams
			}
			
			if (strRules '= "")
			{
				s curKBNodeDiagnosRule = curKBNodeDiagnosRule_"^"_strRules	
			}	
		}
		
		if (count > 1) 
		{
			s ret = ret_"$"
		}
		s ret = ret_curKBNodeDiagnosRule 
	}
	
	k ^CacheTempEMRDiagnos
	
	q ret
}

/// Debug:	d ##Class(EMRservice.BOEMRDiagnosConfig).SaveKBNodeDiagnos(7753,"2^3",2020)
ClassMethod SaveKBNodeDiagnos(AKBNodeID As %String, AKBTreeID As %String, ADiagnosIDs As %String)
{
	q:(AKBNodeID = "")||(AKBTreeID = "")||(ADiagnosIDs = "")
	
	for i = 1:1:$l(ADiagnosIDs,"^")
	{
        s diagnosID = $p(ADiagnosIDs,"^",i)
		continue:(diagnosID = "")

		s flag = ..InsertNode(AKBNodeID,diagnosID,AKBTreeID)
		if (flag = 0)
		{
			q	
		}
	}
}

/// 保存对应关系
/// do ##Class(EMRservice.BOEMRDiagnosConfig).SaveBindDiagnos("11053","1^2","3236")
ClassMethod SaveBindDiagnos(KBNodeID As %String, KBDiagnosID As %String, KBTreeID As %String)
{
	//查找是否有此节点
	s KBnodeExist=..CheckKBNodeIDExist(KBNodeID)
	if KBnodeExist=0
	{
		if (KBDiagnosID '=$C(0))&& (KBDiagnosID '="")
		{
			for i = 1:1:$l(KBDiagnosID,"^")
			{
	            s DiagnosID = $p(KBDiagnosID,"^",i)
				continue:(DiagnosID="")
				
				s Flag = ..InsertNode(KBNodeID,DiagnosID,KBTreeID)
				if (Flag = 0)
				{
					q	
				}
			}
		}
	}
	else
	{
        do ..DeleteAllByNodeID(KBNodeID)
        if (KBDiagnosID '=$C(0))&& (KBDiagnosID '="")
        {
	        for i = 1:1:$l(KBDiagnosID,"^")
	        {
		         s DiagnosID = $p(KBDiagnosID,"^",i)
		         continue:(DiagnosID="")
		         
		         s RowID = $o(^DHCEMRM.DiagnosKBNodeI("IdxNodeDiagnosID",""_KBNodeID,DiagnosID,""))
		         if RowID '=""
		         {
			        do ..Update(RowID)
			     }
			     else
			     {
				    do ..InsertNode(KBNodeID,DiagnosID,KBTreeID)
				 }
		    }
	    }
	}
}

/// Creator:Candyxu
/// CreatDate:2011-09-29
/// Description:检查知识库节点是否在库中存在记录
/// Table:EMRmeta.DiagnosKBNode
/// Input:NodeID-知识库节点ID
/// Output:
/// Return:1-该知识库节点在库中已经存在 0-该知识库节点在库中不存在
/// Others:
/// Debug: ##Class(EMRservice.BOEMRDiagnosConfig).CheckKBNodeIDExist(NodeID)
ClassMethod CheckKBNodeIDExist(NodeID As %String) As %Integer
{
	s ret = 0
	q:(NodeID="") ret
	
	s RowID = $o(^DHCEMRM.DiagnosKBNodeI("IdxKBNodeID",""_NodeID,""))
	if (+RowID>0)
	{
		s ret = RowID
	}
	q ret
}

//插入

ClassMethod InsertNode(KBNodeID As %String, DiagnosCode As %String, KBTreeID As %String) As %String
{
	s rowID = $o(^DHCEMRM.DiagnosKBNodeI("IdxNodeIDAndDiagnosCode",KBNodeID," "_$zcvt(DiagnosCode,"U"),""))
	if (rowID = "")
	{
		s obj = ##class(EMRmeta.DiagnosKBNode).%New()
		s obj.KBNodeID = KBNodeID
		s obj.DiagnosCode = DiagnosCode
		s obj.KBTreeID = KBTreeID
		s obj.ActiveFlag = 1
	}
	else
	{
		s obj = ##Class(EMRmeta.DiagnosKBNode).%OpenId(rowID)
		s obj.ActiveFlag = 1	
	}
	if '(obj.%Save())
	{
		s ret = 0	
	}
	d obj.%Close()
	s ret = obj.%Id()
	q ret
}

//修改

ClassMethod Update(RowID As %String) As %Integer
{
	s ret = 1
	q:(RowID="") ret
	
	//原有数据进行更新,将数据ActiveFlag设置为1
	s obj = ##class(EMRmeta.DiagnosKBNode).%OpenId(RowID)
	s obj.ActiveFlag = 1
	
	if '(obj.%Save())
	{
		s ret = 0	
	}
	
	d obj.%Close()
	
	q ret
}

/// 所有存在设置为无效
ClassMethod DeleteAllByNodeID(NodeID As %String) As %Integer
{
	s ret=1
	q:(NodeID="") ret
	
	s RowID = $o(^DHCEMRM.DiagnosKBNodeI("IdxKBNodeID",""_NodeID,""))
	while RowID '=""
	{
		s ret=..Delete(RowID)
        s RowID = $o(^DHCEMRM.DiagnosKBNodeI("IdxKBNodeID",""_NodeID,RowID))
	}
	q ret
}

//设为无效

ClassMethod Delete(RowID As %String) As %String
{
	s ret = 1
	q:(RowID="") ret
	//原有数据进行“删除”,将数据ActiveFlag设置为0
	s obj = ##class(EMRmeta.DiagnosKBNode).%OpenId(RowID)
	s obj.ActiveFlag = 0
	
	if '(obj.%Save())
	{
		s ret = 0	
	}
	d obj.%Close()
	
	q ret
}

/// 查询最后一层目录下与疾病相关的节点
/// do ##Class(%ResultSet).RunQuery("EMRservice.BOEMRDiagnosConfig","QueryDateByTreeID","2020","3","201869")
Query QueryDateByTreeID(PTreeID As %String, PDiagnosID As %String, PEpisodeID As %String) As %Query(ROWSPEC = "KBNodeID:%String")
{
}

ClassMethod QueryDateByTreeIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryDateByTreeIDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryDateByTreeIDExecute(ByRef qHandle As %Binary, PTreeID As %String, PDiagnosID As %String, PEpisodeID As %String) As %Status
{
	s repid = $i(^CacheTemp)
	s qHandle = $lb(0,repid,0)
 	s ind = 1
	s objKBTree = ##Class(EMRmeta.KBTree).%OpenId(PTreeID)
 	s personalKBUserID =objKBTree.PersonalKBUserID

 	s kbNodeID = ""
 	for {
		s kbNodeID = $o(^DHCEMRM.KBNodeI("IdxKBTreeID"," "_PTreeID,kbNodeID))
		q:(kbNodeID = "")

		s objKBNode = ##Class(EMRmeta.KBNode).%OpenId(kbNodeID)
		continue:(objKBNode = "")
		
		s isCommon = objKBNode.IsCommon
		if (isCommon '= "")&&($zcvt(isCommon,"U") = "Y")
		{
			d BuildData
		}
		else
		{
			if (+personalKBUserID > 0)
		 	{
			 	//个人知识库是否也需要与病种进行关联
				s isPersonalKBBindDiagnos = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName("IsPersonalKBBindDiagnos")
				if (isPersonalKBBindDiagnos '= "")&&($zcvt(isPersonalKBBindDiagnos,"U") = "Y")
				{
					d CheckNode		
				}
				else
				{
					d BuildData	
				}	
			}
			else
			{
				d CheckNode
			}	
		}
	}
	q $$$OK

CheckNode
	s kbNodeDiagnosID = $o(^DHCEMRM.DiagnosKBNodeI("IdxNodeDiagnosID",kbNodeID,PDiagnosID,""))
	if (kbNodeDiagnosID '= "")
	{
		s objKbNodeD = ##class(EMRmeta.DiagnosKBNode).%OpenId(kbNodeDiagnosID)
		s isActive = objKbNodeD.ActiveFlag
		if (+isActive > 0)
		{
			s ret = ..IsDiagRuleOK(kbNodeDiagnosID,PEpisodeID)
			if (+ret > 0)
			{
				d BuildData
			}
		}
	}
	q
BuildData
	s data = $lb(kbNodeID)
	s ^CacheTemp(repid,ind) = data
	s ind = ind + 1	
	q
}

/// Debug:	w ##Class(EMRservice.BOEMRDiagnosConfig).IsDiagRuleOK(3,"201869")
ClassMethod IsDiagRuleOK(AKBNodeDiagnosID As %String, AEpisodeID As %String) As %String
{
	s isOK = "1"
	q:(AEpisodeID = "") isOK
	
	s hasRule = $o(^DHCEMRM.DiagnosKBNodeRuleI("IdxKBNodeDiagnosID"," "_AKBNodeDiagnosID,""))
	q:('hasRule) isOK
	
	s diagnosRuleID = ""
	for {
		s diagnosRuleID = $o(^DHCEMRM.DiagnosKBNodeRuleI("IdxKBNodeDiagnosID"," "_AKBNodeDiagnosID,diagnosRuleID))
		q:(diagnosRuleID = "") 	
		
		s objDiagnosRule = ##Class(EMRmeta.DiagnosKBNodeRule).%OpenId(diagnosRuleID)
		s dictionaryID = objDiagnosRule.DiagnosRuleID
		s dictionaryRuleCode = objDiagnosRule.DiagnosRuleCode

		s result = ..ProcessCheckDiagnosRule(AEpisodeID,dictionaryID,dictionaryRuleCode)
		if (+result <= 0)
		{
			s isOK = "0"
			quit
		}
	}
			
	q isOK
}

/// Debug:	w ##Class(EMRservice.BOEMRDiagnosConfig).ProcessCheckDiagnosRule(201869,6,"F")
ClassMethod ProcessCheckDiagnosRule(AEpisodeID As %String, ADictionaryID As %String, AParamCode As %String) As %Integer
{
	s ret = 1
	
	s objDictionary = ##Class(EMRmeta.StdDictionary).%OpenId(ADictionaryID)
	q:(objDictionary = "") ret
	
	s type = objDictionary.RuleTypeTag
	if (type = "PATSEX")
	{
		s patientID = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(AEpisodeID)
		//RowId^Code^Desc
		s gender = ##Class(EMRservice.HISInterface.PatientInfoAssist).Gender(patientID)
		s ret = (AParamCode = $p(gender,"^",2))	
	}
	
	q ret
}

ClassMethod QueryDateByTreeIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryDateByTreeIDExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Debug:	d ##Class(EMRservice.BL.BLDiagnosKBConfig).InsertRule(3,9,"238","CF-产房")
ClassMethod InsertRule(AKBNodeDiagnosID As %String, ARuleID As %String, ARuleParamCode As %String, ARuleParamDesc As %String) As %String
{
	s objKBNodeDiagnosRule = ##Class(EMRmeta.DiagnosKBNodeRule).%New()
	
	s objKBNodeDiagnosRule.DiagnosKBNodeID = AKBNodeDiagnosID
	s objKBNodeDiagnosRule.DiagnosRuleID = ARuleID
	s objKBNodeDiagnosRule.DiagnosRuleCode = ARuleParamCode
	s objKBNodeDiagnosRule.DiagnosRuleDesc = ARuleParamDesc
	
	if '(objKBNodeDiagnosRule.%Save())
	{
		s ret = -1	
	}
	d objKBNodeDiagnosRule.%Close()
	s ret = objKBNodeDiagnosRule.%Id()
	q ret
}

ClassMethod DeleteRule(AKBNodeDiagnosID As %String, ARuleID As %String, ARuleParamCode As %String) As %String
{
	s ret = 0
	q:(AKBNodeDiagnosID = "")||(ARuleID = "")||(ARuleParamCode = "") ret
	
	s rowID = $o(^DHCEMRM.DiagnosKBNodeRuleI("IdxUnique"," "_AKBNodeDiagnosID," "_ARuleID, " "_ARuleParamCode, ""))
	q:(rowID = "") ret
	
	s objKBNodeDiagnosRule = ##Class(EMRmeta.DiagnosKBNodeRule).%OpenId(rowID)
	s ret = objKBNodeDiagnosRule.%DeleteId(rowID)
	q ret
}

}
