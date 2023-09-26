/// 名称:EMRservice.BOEMRDiagnosConfig
/// 描述:知识关联病种
/// 编写者:Candyxu
/// 编写日期:2011-09-18
Class EMRservice.BOEMRDiagnosConfig Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://localhost/trakcarelive/trak/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService. 
Parameter SERVICENAME = "DiagnosConfig";

/// Debug: s ret = ##Class(EMRservice.BOEMRDiagnosConfig).GetKBNodeDiagnosByID(1)
ClassMethod GetKBNodeDiagnosByID(ARowID As %String) As EMRservice.entity.EKBNodeDiagnos [ WebMethod ]
{
	s ret = ""
	q:(ARowID = "") ret
	
	s objKBNodeDiagnos = ##Class(EMRmeta.KBNodeDiagnos).%OpenId(ARowID)
	q:(objKBNodeDiagnos = "") ""
	
	s Result = ##Class(EMRservice.entity.EKBNodeDiagnos).%New()
	s Result.ID = ARowID
	s Result.KBNodeID = objKBNodeDiagnos.KBNodeID
	s Result.KBTreeID = objKBNodeDiagnos.KBTreeID
	s Result.KBDiagnosID = objKBNodeDiagnos.KBDiagnosID
	s Result.ActiveFlag = objKBNodeDiagnos.ActiveFlag

	q Result
}

/// do ##Class(EMRservice.BOEMRDiagnosConfig).GetDiagnosByNodeID("11053")
ClassMethod GetDiagnosByNodeID(NodeID As %String) As %String [ WebMethod ]
{
  	s ret = ""
	q:(NodeID="") ret
	s RowID = $o(^DHCEMRM.KBNodeDiagnosI("IdxKBNodeID",""_NodeID,""))
	while RowID '=""
	{
		s Flag=$LI(^DHCEMRM.KBNodeDiagnosD(RowID),5)
		if Flag'=0
		{
		   s ret =ret_$LI(^DHCEMRM.KBNodeDiagnosD(RowID),2)_"^"
		}
        s RowID = $o(^DHCEMRM.KBNodeDiagnosI("IdxKBNodeID",""_NodeID,RowID))
    }
	q ret
}

/// Desc:	获取知识库节点与疾病关联的多条件组合
/// Return:	$KBNodeDiagnosID^CtLocID^CtLocDesc^DiagnosID^DiagnosDesc^DictionaryID|DictionaryDesc|Code=Value*Code=Value*Code=Value
/// Debug:	w ##Class(EMRservice.BOEMRDiagnosConfig).GetKBNodeDiagnosWithRules(7753)
ClassMethod GetKBNodeDiagnosWithRules(AKBNodeID As %String) As %String [ WebMethod ]
{
	s ret = ""
	q:(AKBNodeID = "") ret
	
	s count = 0
	s diagnosID = ""
	k ^CacheTempEMRDiagnos
	
	for {
		s diagnosID = $o(^DHCEMRM.KBNodeDiagnosI("IdxNodeDiagnosID",AKBNodeID,diagnosID))
		q:(diagnosID = "")
		
		s objDiagnos = ##Class(EMRmeta.KBDiagnos).%OpenId(diagnosID)
		continue:(objDiagnos = "")
		
		s ctLocID = objDiagnos.CTLocID
		s ctLocDesc = ""
		s:(ctLocID '= "") ctLocDesc = $p($g(^CTLOC(+ctLocID)),"^",1)
		s description = objDiagnos.Description
		
		s kbNodeDiagnosID = $o(^DHCEMRM.KBNodeDiagnosI("IdxNodeDiagnosID",AKBNodeID,diagnosID,""))
		s objKBNodeDiagnos = ##Class(EMRmeta.KBNodeDiagnos).%OpenId(kbNodeDiagnosID)
		continue:(objKBNodeDiagnos.ActiveFlag = 0)
		
		s curKBNodeDiagnosRule = kbNodeDiagnosID_"^"_ctLocID_"^"_ctLocDesc_"^"_diagnosID_"^"_description	
		
		s count = count + 1
		
		s rowID = ""
		for {
			s rowID = $o(^DHCEMRM.KBNodeDiagnosRuleI("IdxKBNodeDiagnosID"," "_kbNodeDiagnosID,rowID))
			q:(rowID = "")
			
			s objKBNodeDiagnosRule = ##Class(EMRmeta.KBNodeDiagnosRule).%OpenId(rowID)
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
ClassMethod SaveKBNodeDiagnos(AKBNodeID As %String, AKBTreeID As %String, ADiagnosIDs As %String) [ WebMethod ]
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
ClassMethod SaveBindDiagnos(KBNodeID As %String, KBDiagnosID As %String, KBTreeID As %String) [ WebMethod ]
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
		         
		         s RowID = $o(^DHCEMRM.KBNodeDiagnosI("IdxNodeDiagnosID",""_KBNodeID,DiagnosID,""))
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
/// Table:EMRmeta.KBNodeDiagnos
/// Input:NodeID-知识库节点ID
/// Output:
/// Return:1-该知识库节点在库中已经存在 0-该知识库节点在库中不存在
/// Others:
/// Debug: ##Class(EMRservice.BOEMRDiagnosConfig).CheckKBNodeIDExist(NodeID)
ClassMethod CheckKBNodeIDExist(NodeID As %String) As %Integer
{
	s ret = 0
	q:(NodeID="") ret
	
	s RowID = $o(^DHCEMRM.KBNodeDiagnosI("IdxKBNodeID",""_NodeID,""))
	if (+RowID>0)
	{
		s ret = RowID
	}
	q ret
}

//插入

ClassMethod InsertNode(KBNodeID As %String, KBDiagnosID As %String, KBTreeID As %String) As %String [ WebMethod ]
{
	s rowID = $o(^DHCEMRM.KBNodeDiagnosI("IdxNodeDiagnosID",KBNodeID,KBDiagnosID,""))
	if (rowID = "")
	{
		s obj = ##class(EMRmeta.KBNodeDiagnos).%New()
		s obj.KBNodeID = KBNodeID
		s obj.KBDiagnosID = KBDiagnosID
		s obj.KBTreeID = KBTreeID
		s obj.ActiveFlag = 1
	}
	else
	{
		s obj = ##Class(EMRmeta.KBNodeDiagnos).%OpenId(rowID)
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
	s obj = ##class(EMRmeta.KBNodeDiagnos).%OpenId(RowID)
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
	
	s RowID = $o(^DHCEMRM.KBNodeDiagnosI("IdxKBNodeID",""_NodeID,""))
	while RowID '=""
	{
		s ret=..Delete(RowID)
        s RowID = $o(^DHCEMRM.KBNodeDiagnosI("IdxKBNodeID",""_NodeID,RowID))
	}
	q ret
}

//设为无效

ClassMethod Delete(RowID As %String) As %String [ WebMethod ]
{
	s ret = 1
	q:(RowID="") ret
	//原有数据进行“删除”,将数据ActiveFlag设置为0
	s obj = ##class(EMRmeta.KBNodeDiagnos).%OpenId(RowID)
	s obj.ActiveFlag = 0
	
	if '(obj.%Save())
	{
		s ret = 0	
	}
	d obj.%Close()
	
	q ret
}

/// 根据TreeID查找数据
ClassMethod GetDataByTreeID(TreeID As %String, DiagnosID As %String, EpisodeID As %String) As EMRservice.dataset.EKBDiagnosConfigDataSet [ WebMethod ]
{
	S result = ##Class(EMRservice.dataset.EKBDiagnosConfigDataSet).%New()
	d result.SetArgs(TreeID,DiagnosID,EpisodeID)
 	q result
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
	s kbNodeDiagnosID = $o(^DHCEMRM.KBNodeDiagnosI("IdxNodeDiagnosID",kbNodeID,PDiagnosID,""))
	if (kbNodeDiagnosID '= "")
	{
		s objKbNodeD = ##class(EMRmeta.KBNodeDiagnos).%OpenId(kbNodeDiagnosID)
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
	
	s hasRule = $o(^DHCEMRM.KBNodeDiagnosRuleI("IdxKBNodeDiagnosID"," "_AKBNodeDiagnosID,""))
	q:('hasRule) isOK
	
	s diagnosRuleID = ""
	for {
		s diagnosRuleID = $o(^DHCEMRM.KBNodeDiagnosRuleI("IdxKBNodeDiagnosID"," "_AKBNodeDiagnosID,diagnosRuleID))
		q:(diagnosRuleID = "") 	
		
		s objDiagnosRule = ##Class(EMRmeta.KBNodeDiagnosRule).%OpenId(diagnosRuleID)
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

}
