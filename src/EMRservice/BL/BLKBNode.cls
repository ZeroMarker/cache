Class EMRservice.BL.BLKBNode Extends %RegisteredObject
{

/// Desc:		返回baseID下与病种或标题关联的第一个知识库结点
/// Creator:    candy
/// CreateTime: 2014-07-21
/// Input:		AKBBaseID: 知识库KnowledgeBaseID
///             ALocID: 科室ID
///             ATitleCode: 标题代码
///             ADiseaseID：病种ID
/// OutPut:     Node xml流数据
/// Return:     NodeID
ClassMethod GetBindFistNode(AKBBaseID As %String, ALocID As %String, ADiseaseID As %String, ATitleCode As %String, AEpisodeID As %String, ByRef OutStream As %GlobalBinaryStream) As %String
{
	s $zt="Error"
	s result = ""
	q:((AKBBaseID = "")||(ALocID = "")||(AEpisodeID = "")) result
	s objKBBase = ##Class(EMRmeta.KnowledgeBase).%OpenId(AKBBaseID)
	q:(objKBBase = "") result
	s result = ..GetFistKBNode(AKBBaseID,ALocID,0,ADiseaseID,ATitleCode,AEpisodeID,OutStream)
	q result
Error
   	q result
}

/// Desc:		递归查找baseID下与病种或标题关联的第一个知识库结点
/// Creator:    candy
/// CreateTime: 2014-01-19
/// Input:		AKBBaseID: 知识库KnowledgeBaseID
///             ALocID: 科室ID
///             AParentID:父节点rowID
///             ADiseaseID：病种ID
///             ATitleCode: 标题代码
/// OutPut:     Node xml流数据
/// Return:     NodeID
ClassMethod GetFistKBNode(AKBBaseID As %String, ALocID As %String, AParentID As %String, ADiseaseID As %String, ATitleCode As %String, AEpisodeID As %String, ByRef OutStream As %GlobalBinaryStream) As %String
{
	s result = ""
	s treeID = ""
	for
	{
		s treeID = $o(^DHCEMRM.KBTreeI("IdxBaseIDParentID"," "_AKBBaseID," "_AParentID,treeID))
		q:(treeID = "")
		continue:((AParentID = 0)&&($d(^DHCEMRM.KBTreeCTLocI("IdxCTLocKBTreeFlag"," "_ALocID," "_treeID," 1"))<=0))
		continue:((ATitleCode '= "")&&($d(^DHCEMRM.KBTreeTitlesRuleI("IdxIDCode"," "_treeID," "_ATitleCode))<=0))
		s nodeID = ""
		for
		{
			s nodeID = $o(^DHCEMRM.KBNodeI("IdxKBTreeID"," "_treeID,nodeID))
			q:(nodeID = "")
			s objNode = ##Class(EMRmeta.KBNode).%OpenId(nodeID)
			continue:(objNode = "")
			continue:($zcvt(objNode.IsInUse,"U") '= "Y")
			k objNode
			if ((ADiseaseID '= "0")&&(ADiseaseID '= ""))
		    {
				s diseaseNodeResult = ..IsDiseaseNodeOK(nodeID,ADiseaseID)
				s diseaseNodeFlag = $p(diseaseNodeResult,"^",1)
				continue:(diseaseNodeFlag '= 1)
				s kbNodeDiagnosID =  $p(diseaseNodeResult,"^",2)
				s result = ..IsDiagRuleOK(kbNodeDiagnosID,AEpisodeID)
				continue:(result '= 1) 
				s status = ..GetNodeXML(nodeID,OutStream)
				s:(status = 1) result = nodeID
				q:(result '= "")
		    }
		    elseif (ATitleCode '= "")
		    {
				s status = ..GetNodeXML(nodeID,OutStream)
				s:(status = 1) result = nodeID
				q:(result '= "")
			}
		}
		q:(result '= "")
		d OutStream.Clear()
		s result = ..GetFistKBNode(AKBBaseID,ALocID,treeID,ADiseaseID,ATitleCode,AEpisodeID,OutStream)
    	q:(result '= "")
    }
    q result
}

/// Desc:       取知识内容xml
/// Creator:    Candy
/// CreateDate: 2014-01-19
/// Input:      ANodeID 知识库ID
/// OutPut:     OutKBNode 知识库节点xml            
ClassMethod GetNodeXML(ANodeID As %String, ByRef OutKBNode As %GlobalBinaryStream) As %String
{
	s result = "-1"
	q:(ANodeID = "") result
	s objKBNode = ##Class(EMRmeta.KBNode).%OpenId(ANodeID)
	q:(objKBNode = "") result
	d OutKBNode.Write("<?xml version=""1.0"" encoding=""UTF-8""?>")
	d OutKBNode.Write("<KBData>")
	  d OutKBNode.Write("<TemplateGUID>"_objKBNode.GUID_"</TemplateGUID>")
	  d OutKBNode.Write("<Macros>")
	  d OutKBNode.Write("<Macro/>")
	  d OutKBNode.Write("</Macros>")
      d OutKBNode.Write("<StructuredBody>")
	    d OutKBNode.CopyFrom(objKBNode.MetaData)
	    d OutKBNode.CopyFrom(objKBNode.ScriptData)
	    d OutKBNode.CopyFrom(objKBNode.MediasData)
	    d OutKBNode.CopyFrom(objKBNode.InitialData)
	    d OutKBNode.CopyFrom(objKBNode.PresentationData)
	    d OutKBNode.Write("</StructuredBody>")
	d OutKBNode.Write("</KBData>") 
	q 1
}

/// Desc: 		根据病种、科室绑定查询绑定知识库
/// Creaotr:	Candy
/// CreateDate:	2014-1-23
/// Input:		AKBBaseID:知识库KnowledgeBaseID
///             ALocID:科室ID
///             ADiseaseID:病种ID
///             AEpisodeID:就诊号
///             ATitleCode:标题代码
///             AUserID: 用户ID
/// OutPut:     知识库树JSon
/// Deubgger:   w ##Class(EMRservice.BL.BLKBNode).GetBindKBNode("2","6","","457","105","")
/// Deubgger:   w ##Class(EMRservice.BL.BLKBNode).GetBindKBNode("2","16","7","131","662","")
ClassMethod GetBindKBNode(AKBBaseID As %String, ALocID As %String, ADiseaseID As %String, AEpisodeID As %String, AUserID As %String, ATitleCode As %String = "", AType As %String = "") As %Stream
{
	s strJson = ##class(%GlobalCharacterStream).%New()
	q:(AKBBaseID = "")||(ALocID = "")||(AEpisodeID = "") strJson 

	s objKBBase = ##Class(EMRmeta.KnowledgeBase).%OpenId(AKBBaseID)
	q:(objKBBase = "") strJson
	s tempLocId = ALocID
	s specialLocIds = ##Class(EMRservice.SystemParameter).GetSpecialLocId()
	s locFlag = "0"
	for i=1:1:$l(specialLocIds,"^")
	{
		s specialLocId = $p(specialLocIds,"^",i)
		if (ALocID = specialLocId)
		{
			s locFlag = "1"
			q
		}
	}
	if (locFlag = "1")
	{
		s tempLocId = $p($g(^SSU("SSUSR",AUserID)),"^",4)
	}
	s strTreeNodes = ..GetTreeNodes(AKBBaseID,0,tempLocId,ATitleCode,ADiseaseID,AEpisodeID,AUserID,AType)
	q:(strTreeNodes.Size =0) strJson
	s kbBaseName = ""
	Set langid=20
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
	}
	s kbBaseName = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRmeta.KnowledgeBase","Name",objKBBase.Name,langid)
	s kbBaseName = ##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(kbBaseName)
	d strJson.Write("{""id"":"""_objKBBase.%Id()_""",""text"":"""_kbBaseName_""",""state"":""open"",""attributes"":{""type"":""KBBase""},""children"":[" )
    
    d strJson.CopyFrom(strTreeNodes)
    d strJson.Write("]}")
    
    q strJson
}

/// Desc:      取baseID下所有节点
/// Creaotr:   Candyxu
/// CreateDate：2014-6-4
/// Input:		AKBBaseID:知识库KnowledgeBaseID
///             ALocID:科室ID
///             ADiseaseID:病种ID
///             AEpisodeID:就诊号
///             ATitleCode:标题代码
///             AUserID: 用户ID
/// OutPut:     tree JSon
/// d ##Class(EMRservice.BL.BLKBNode).GetTreeNodes(2,11,6,"","",457,106)
/// d ##Class(EMRservice.BL.BLKBNode).GetTreeNodes(2,137,6,"","",149,359)
/// s obj=##Class(EMRservice.BL.BLKBNode).GetTreeNodes(7,0,6,"","",230,359)
ClassMethod GetTreeNodes(AKBBaseID As %String, AParentID As %String, ALocID As %String, ATitleCode As %String, ADiseaseID As %String, AEpisodeID As %String, AUserID As %String, AType As %String = "") As %Stream
{
	s treeID = "",i = 0
	s treeSeq = ""
	s strJson = ##class(%GlobalCharacterStream).%New()
	s tempJson = ##class(%GlobalCharacterStream).%New()
	s treeNodes = ##class(%GlobalCharacterStream).%New()
	s tempChildJson = ##class(%GlobalCharacterStream).%New()
	//是否显示该医生创建的所有知识库，还是显示该医生在本科室下创建的知识库
	s isDisplayAllPersonalKBNode = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName("IsDisplayAllPersonalKBNode")
  	s:(isDisplayAllPersonalKBNode = "") isDisplayAllPersonalKBNode = "Y"
  	
  	Set langid=20
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
	}
	
	for
	{
		s treeSeq = $o(^DHCEMRM.KBTreeI("IdxBaseIDParentIDSeq"," "_AKBBaseID," "_AParentID,treeSeq))
		//s treeSeq = $o(^DHCEMRM.KBTreeI("IdxBaseIDParentIDSeq"," "_AKBBaseID," "_AParentID,treeSeq),-1)
		q:(treeSeq = "")
		s treeID = $o(^DHCEMRM.KBTreeI("IdxBaseIDParentIDSeq"," "_AKBBaseID," "_AParentID,treeSeq,""))
		q:(treeID = "")
		
		s objTree = ##Class(EMRmeta.KBTree).%OpenId(treeID)
		q:(objTree = "")
		s IsActive = objTree.IsActive
		continue:(IsActive = "N")
		s personalKBUserID = objTree.PersonalKBUserID
		s:(personalKBUserID = $c(0)) personalKBUserID = ""
		continue:((AUserID '= "")&&(personalKBUserID '= "")&&(AUserID '= personalKBUserID))
		continue:((ATitleCode '= "")&&(personalKBUserID = "")&&($d(^DHCEMRM.TitlesI("IdxCode"," "_ATitleCode))=10)&&($d(^DHCEMRM.KBTreeTitlesRuleI("IdxIDCode"," "_treeID," "_ATitleCode))<=0))
		
		//是否显示该医生创建的所有知识库，还是显示该医生在本科室下创建的知识库
		if (AType '= "ALLLOC")
		{
			if (isDisplayAllPersonalKBNode ="Y")
			{
				//当第一级节点(parentID=0)没关联该科室，并且下级没有个人知识库时退出此层循环
				continue:(($d(^DHCEMRM.KBTreeCTLocI("IdxCTLocKBTreeFlag"," "_ALocID," "_treeID," 1"))<=0)&&($d(^DHCEMRM.KBTreeI("IdxBaseParentUserID"," "_AKBBaseID," "_treeID," "_AUserID))<=0)&&(AParentID = 0))	
				s hasChildInUse = 0
				if (($d(^DHCEMRM.KBTreeCTLocI("IdxCTLocKBTreeFlag"," "_ALocID," "_treeID," 1"))<=0)&&($d(^DHCEMRM.KBTreeI("IdxBaseParentUserID"," "_AKBBaseID," "_treeID," "_AUserID))>0)&&(AParentID = 0))
				{
					//没关联该科室，并且下级有可用个人知识库
					s hasChildInUse = ..HasChildTreeInUse(AKBBaseID,treeID,AUserID)
					continue:(hasChildInUse = 0)
				}
				s finalParentID = ""
				//找当前treeID的第一级节点treeID
				s finalParentID = ..GetFinalParentID(treeID)
				continue:(($d(^DHCEMRM.KBTreeCTLocI("IdxCTLocKBTreeFlag"," "_ALocID," "_finalParentID," 1"))<=0)&&(AParentID '= 0)&&($d(^DHCEMRM.KBTreeI("IdxBaseParentUserID"," "_AKBBaseID," "_treeID," "_AUserID))<=0)&&(personalKBUserID = ""))
				if (($d(^DHCEMRM.KBTreeCTLocI("IdxCTLocKBTreeFlag"," "_ALocID," "_finalParentID," 1"))<=0)&&(AParentID '= 0)&&($d(^DHCEMRM.KBTreeI("IdxBaseParentUserID"," "_AKBBaseID," "_treeID," "_AUserID))>0)&&(personalKBUserID = ""))
				{
					//没关联该科室，并且下级有可用个人知识库
					s hasChildInUse = ..HasChildTreeInUse(AKBBaseID,treeID,AUserID)
					continue:(hasChildInUse = 0)
				}
			}
			else
			{
				continue:(($d(^DHCEMRM.KBTreeCTLocI("IdxCTLocKBTreeFlag"," "_ALocID," "_treeID," 1"))<=0)&&(AParentID = 0))	
			}
			if (AType = "PERSONAL")||(AType = "PERSONALTREE")
			{
				continue:((personalKBUserID = "")&&(AParentID '= 0))
			}
		}	
		s type = $case(personalKBUserID,"":"KBTree",:"PersonalKBTree")
		s tempJson = ##class(%GlobalCharacterStream).%New(),k=0
		s treeNodes = ##class(%GlobalCharacterStream).%New()
		d:(k '= 0) tempJson.Write(",")
		s kbTreeName = ""
		s kbTreeName = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRmeta.KBTree","Name",objTree.Name,langid)
		s kbTreeName = ##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(kbTreeName)
		s isCollapse = ##Class(EMRservice.SystemParameter).SetKnowledgeBaseCollapse()
		if (isCollapse = "3")
		{
			if (($o(^DHCEMRM.KBNodeI("IdxKBTreeID"," "_treeID,"")))'="")
			{
				s treeState = "closed"
			}
			else 
			{
				s treeState = "open"
			}
		}
		else
		{
			s treeState = "closed"
		}
		d tempJson.Write("{""id"":"""_treeID_""",""text"":"""_kbTreeName_""",""state"":"""_treeState_""",""attributes"":{""type"":"""_type_""",""personalKBUserID"":"""_personalKBUserID_"""},""children"":[")
		// 获取个人知识库目录标识
		if (AType '= "PERSONALTREE"){
			if (AParentID = 0)	
			{
				if ($o(^DHCEMRM.KBNodeShareI("IdxLocTreeParentNode"," "_ALocID," "_treeID,"")) '= "")
				{
					s shareCat = ##class(EMRservice.HISInterface.Translation).Get("EMRTrans","共享知识库")
					
					d tempJson.Write("{""id"":""0"",""text"":"""_shareCat_""",""state"":"""_treeState_""",""attributes"":{""type"":""ShareKBTree""},""children"":[")
					s shareNode = ##Class(EMRservice.BL.BLKBNode).GetShareNodes(ALocID,treeID)
					d tempJson.CopyFrom(shareNode)
					d tempJson.Write("]},")
				}
			}
			
			if (('(($d(^DHCEMRM.KBTreeCTLocI("IdxCTLocKBTreeFlag"," "_ALocID," "_treeID," 1"))<=0)&&(AParentID = 0)))||(AType="ALLLOC"))
		    {
				s nodeID = "",j = 0
				s nodeSeq = ""
				s tempChildJson = ##class(%GlobalCharacterStream).%New()
				for
				{
					//显示个人所有知识库
					if ((isDisplayAllPersonalKBNode = "Y")&&(AType '= "ALLLOC")&&(isDisplayAllPersonalKBNode = "Y"))
					{
						//过滤非关联科室的科室知识库节点
						q:(($d(^DHCEMRM.KBTreeCTLocI("IdxCTLocKBTreeFlag"," "_ALocID," "_finalParentID," 1"))<=0)&&(AParentID '= 0)&&($d(^DHCEMRM.KBTreeI("IdxBaseParentUserID"," "_AKBBaseID," "_treeID," "_AUserID))>0)&&(personalKBUserID = ""))
					}
					s nodeSeq = $o(^DHCEMRM.KBNodeI("IdxKBTreeIDSeq"," "_treeID,nodeSeq))
					q:(nodeSeq = "")
					s nodeID = $o(^DHCEMRM.KBNodeI("IdxKBTreeIDSeq"," "_treeID,nodeSeq,""))
					q:(nodeID = "")
					s objNode = ##Class(EMRmeta.KBNode).%OpenId(nodeID)
					q:(objNode = "")
				    continue:($zcvt(objNode.IsInUse,"U") '= "Y")
				    
					if ((ADiseaseID '= "0")&&(ADiseaseID '= ""))
					{
						s diseaseNodeResult = ..IsDiseaseNodeOK(nodeID,ADiseaseID)
						s diseaseNodeFlag = $p(diseaseNodeResult,"^",1)
						if (diseaseNodeFlag = "1")
						{
							s kbNodeDiagnosID = $p(diseaseNodeResult,"^",2)
							s result = ..IsDiagRuleOK(kbNodeDiagnosID,AEpisodeID)
							if (result = 1)
							{
							   d:(j '= 0) tempChildJson.Write(",")
							   d tempChildJson.CopyFrom(..GetKBNodes(objNode))
							   
							   s j = j + 1
							}		
						}
					}
				    else
				    {
						d:(j '= 0) tempChildJson.Write(",")
						d tempChildJson.CopyFrom(..GetKBNodes(objNode))
						
						s j = j + 1
						
					}
				}
		    }
		}
		//个人知识库在前
		d treeNodes.CopyFrom(..GetTreeNodes(AKBBaseID,treeID,ALocID,ATitleCode,ADiseaseID,AEpisodeID,AUserID,AType))
	    d tempJson.CopyFrom(treeNodes)
	    d:((treeNodes.Size '=0)&&(tempChildJson.Size '=0)) tempJson.Write(",")
	    d tempJson.CopyFrom(tempChildJson)
	   	d tempJson.Write("]}")
		d:(i '= 0) strJson.Write(",")
		d strJson.CopyFrom(tempJson)	
		
		s k=k+1
		s i = i + 1
	}
	
    q strJson
}

ClassMethod GetKBNodes(objNode) As %Stream
{
	s strJson = ##class(%GlobalCharacterStream).%New()
	s isEmpty = $case(objNode.MetaData.Size,0:"Y",:"N")
	
	
	Set langid=20
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
	}
	s kbNodeName = ""
	s kbNodeName = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRmeta.KBNode","Name",objNode.Name,langid)
	s kbNodeName = ##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(kbNodeName)
	
	d strJson.Write("{""id"":"""_objNode.%Id()_"""")
	d strJson.Write(",""text"":"""_kbNodeName_"""")
	d strJson.Write(",""attributes"":{""type"":""KBNode""")
	d strJson.Write(",""desc"":"""_$s(objNode.Description=$c(0):"",1:objNode.Description)_"""")
	d strJson.Write(",""isCommon"":"""_objNode.IsCommon_"""")
	d strJson.Write(",""isInUse"":"""_objNode.IsInUse_"""")
	d strJson.Write(",""isEmpty"":"""_isEmpty_"""}}")
	q strJson
}

/// Desc:       找第一级节点的treeID
/// Creaotr:    Donglulu
/// CreateDate：2016-7-28
/// Input:		TreeID:知识库当前目录的TreeID
/// OutPut:     第一级节点的treeID，parentID的0的那一级节点的treeID
/// w ##Class(EMRservice.BL.BLKBNode).GetFinalParentID("")
ClassMethod GetFinalParentID(TreeID As %String) As %String
{
	for
	{
		s objTree = ##Class(EMRmeta.KBTree).%OpenId(TreeID)
		q:(objTree.ParentID = 0) 
		s TreeID = objTree.ParentID
	}
	q TreeID
}

/// Desc:       判断下一层有没有可用的个人知识库目录节点
/// Creaotr:    Donglulu
/// CreateDate：2016-1-22
/// Input:		
/// OutPut:     
/// w ##Class(EMRservice.BL.BLKBNode).HasChildTreeInUse("1","4858","359")
ClassMethod HasChildTreeInUse(AKBBaseID As %String, ATreeID As %String, AUserID As %String) As %String
{
	s treeChildID = ""
	s hasChildInUse = 0
	for
	{
		s treeChildID = $o(^DHCEMRM.KBTreeI("IdxBaseParentUserID"," "_AKBBaseID," "_ATreeID," "_AUserID,treeChildID))
		q:(treeChildID = "")
		
		s objTreeChild = ##Class(EMRmeta.KBTree).%OpenId(treeChildID)
		continue:(objTreeChild = "")
		s TreeChildIsActive = objTreeChild.IsActive
		continue:(TreeChildIsActive = "N")
		
		s hasChildInUse = 1
		q
	}
	q hasChildInUse
}

/// Desc:        判断知识关联病种
/// Creator:     Candy
/// CreateDate:  2016-9-1
/// Input:       ANodeID 
///              ADiseaseCode
/// Output:      0,1
/// Debug:	     w ##Class(EMRservice.BL.BLKBNode).IsDiseaseNodeOK(94,"76")
ClassMethod IsDiseaseNodeOK(ANodeID As %String, ADiseaseID As %String) As %String
{
	s result = 0
	q:(ANodeID = "")||(ADiseaseID = "") result
	s diseaseCode = ""
	s objDises = ##Class(EMRmeta.Diagnos).%OpenId(ADiseaseID)
	q:(objDises = "") result
	s diseaseCode = objDises.DiagnosCode
	q:(diseaseCode = "") result
	s kbNodeDiagnosID = $o(^DHCEMRM.DiagnosKBNodeI("IdxNodeIDAndDiagnosCode",ANodeID," "_$zcvt(diseaseCode,"U"),""))
	q:(kbNodeDiagnosID = "") result
	s objNodeDiagnos = ##Class(EMRmeta.DiagnosKBNode).%OpenId(kbNodeDiagnosID)
	q:(objNodeDiagnos = "") result
	s isActive = objNodeDiagnos.ActiveFlag
	q:(+isActive <=0) result
	s result = 1
	q result_"^"_kbNodeDiagnosID
}

/// Desc:        判断知识关联病种Rule
/// Creator:     Candy
/// CreateDate:  2014-4-1
/// Input:       AKBNodeDiagnosID 
///              AEpisodeID
/// Output:      0,1
/// Debug:	     w ##Class(EMRservice.BL.BLKBNode).IsDiagRuleOK(94,"76")
ClassMethod IsDiagRuleOK(AKBNodeDiagnosID As %String, AEpisodeID As %String) As %String
{
	s isOK = "1"
	q:(AEpisodeID = "") isOK
	
	//s hasRule = $o(^DHCEMRM.KBNodeDiagnosRuleI("IdxKBNodeDiagnosID"," "_AKBNodeDiagnosID,""))
	s hasRule = $o(^DHCEMRM.DiagnosKBNodeRuleI("IdxDiagnosKBNodeID"," "_AKBNodeDiagnosID,""))
	q:('hasRule) isOK
	
	s diagnosRuleID = ""
	for {
		//s diagnosRuleID = $o(^DHCEMRM.KBNodeDiagnosRuleI("IdxKBNodeDiagnosID"," "_AKBNodeDiagnosID,diagnosRuleID))
		s diagnosRuleID = $o(^DHCEMRM.DiagnosKBNodeRuleI("IdxDiagnosKBNodeID"," "_AKBNodeDiagnosID,diagnosRuleID))		
		q:(diagnosRuleID = "") 	
		
		//s objDiagnosRule = ##Class(EMRmeta.KBNodeDiagnosRule).%OpenId(diagnosRuleID)
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

/// Desc:        判断知识关联病种联合条件
/// Creator:     Candy
/// CreateDate:  2014-4-1
/// Input:       ADictionaryID 
///              AEpisodeID
///              AParamCode
/// Output:      0,1
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

Query SELECTInUseBYPARENTID(KBTreeID As %String = "") As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,Name:%String,KBTreeID:%String,KnowledgeBaseID:%String ,Description:%String,IsCommon:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_KBNode_SELECTInUseBYPARENTID, SqlProc ]
{
	 SELECT ID, Name, KBTreeID,KnowledgeBaseID, Description,IsCommon
	 FROM EMRmeta.KBNode
	 WHERE (KBTreeID = :KBTreeID)
	 ORDER BY Sequence
}

Query SELECTBYPARENTID(KBTreeID As %String = "") As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,Name:%String,KBTreeID:%String,KnowledgeBaseID:%String ,Description:%String,IsCommon:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_KBNode_SELECTBYPARENTID, SqlProc ]
{
	 SELECT ID, Name, KBTreeID,KnowledgeBaseID, Description,IsCommon
	 FROM EMRmeta.KBNode
	 WHERE (KBTreeID = :KBTreeID)
	 ORDER BY Sequence
}

Query SELECTALLKBNODES() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,Name:%String,KBTreeID:%String,KnowledgeBaseID:%String ,Description:%String,IsCommon:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_KBNode_SELECTALLKBNODES, SqlProc ]
{
	 SELECT ID, Name, KBTreeID,KnowledgeBaseID, Description,IsCommon
	 FROM EMRmeta.KBNode
}

/// Desc: 按节点名称模糊查找
Query SELECTBYNAME(PKBName As %String, KnowledgeBaseID As %String) As %Query(ROWSPEC = "ID:%Integer,Name:%String,KBTreeID:%String")
{
}

ClassMethod SELECTBYNAMEExecute(ByRef qHandle As %Binary, PKBName As %String, KnowledgeBaseID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	q:(PKBName = "")||(PKBName = $c(0)) $$$OK
 	Set KnowledgeBaseID = " "_KnowledgeBaseID
 	Set KBRowID = "0"
 	for {
	 	set KBRowID = $o(^DHCEMRM.KBNodeI("IdxKBKnowledgeBaseID",KnowledgeBaseID,KBRowID))
	 	q:(KBRowID = "")
	 	
	 	set Name = $li(^DHCEMRM.KBNodeD(KBRowID),4)
	 	if ($F(Name,PKBName) = 0) continue
	 	set TreeID = $li(^DHCEMRM.KBNodeD(KBRowID),3)
	 	set data = $lb(KBRowID,Name,TreeID)
	    set ^CacheTemp(repid,ind)=data
	    set ind=ind+1  	 
	
	}
	Quit $$$OK
}

ClassMethod SELECTBYNAMEClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SELECTBYNAMEExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod SELECTBYNAMEFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SELECTBYNAMEExecute ]
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

/// Desc:       保存知识库模板数据
/// Creator:    candy
/// Createdate: 2014-01-25
/// Input:      argInData 模板文件流
///             TemplateVersionId   
/// Output:     result 1成功,-1失败 
ClassMethod SaveComposite(argInData As %GlobalBinaryStream, KBNodeID As %String, userID As %String = "") As %String
{
	s result = "-1"		
    q:((KBNodeID = "")||(argInData = "")) result 
        
    s streamMetaData = ##Class(EMRservice.Parser.StreamData).ParserStream(argInData,"<MetaData","</MetaData>","11")
    s streamScriptData = ##Class(EMRservice.Parser.StreamData).ParserStream(argInData,"<Scripts>","</Scripts>","10")
    s streamPresentationData = ##Class(EMRservice.Parser.StreamData).ParserStream(argInData,"<PresentationData>","</PresentationData>","19")
    s streamMediasData = ##Class(EMRservice.Parser.StreamData).ParserStream(argInData,"<Medias>","</Medias>","9")
    s streamInitialData = ##Class(EMRservice.Parser.StreamData).ParserStream(argInData,"<InitialData>","</InitialData>","14")

    
    s objKbNode = ##Class(EMRmeta.KBNode).%OpenId(KBNodeID)
    q:(objKbNode = "") result
    s objKbNode.UserID = userID
    
    d objKbNode.MetaData.CopyFrom(streamMetaData)
    d objKbNode.ScriptData.CopyFrom(streamScriptData)
    d objKbNode.PresentationData.CopyFrom(streamPresentationData)
    d objKbNode.MediasData.CopyFrom(streamMediasData)
    d objKbNode.InitialData.CopyFrom(streamInitialData)
    s sc = objKbNode.%Save()

	s:($$$ISOK(sc)) result = "1"
	q result
}

/// Desc:       插入知识库
/// Creaotr:    Candy
/// CreateDate: 2014-1-25
/// Input:		KBNodeID 知识ID
/// OutPut:     OutRecords 知识库xml流
/// Deubgger:   w ##Class(EMRservice.BL.BLKBNode).LoadComposite("",4)
ClassMethod LoadComposite(ByRef OutRecords As %GlobalBinaryStream, AKBNodeID As %String) As %String
{
	s result = "-1"		
    q:(AKBNodeID = "") result 
    d ..GetNodeXML(AKBNodeID,OutRecords)
	s result = "1"
	q result
}

/// Desc: 修改节点属性
/// Creator: Candy
/// CreateDate: 2014-5-28
ClassMethod UpdateKBNode(AEKBNode As EMRservice.entity.EKBNode) As %String
{
	s TempKBTreeID =""
	
	TSTART
	
	s result = "0"
	s objKBNode = ##Class(EMRmeta.KBNode).%OpenId(AEKBNode.ID)
	q:(objKBNode = "") result
	s objKBNode.Name = AEKBNode.Name
	s objKBNode.Description = AEKBNode.Description
	s objKBNode.IsCommon = AEKBNode.IsCommon
	s objKBNode.IsInUse = AEKBNode.IsInUse
	s objKBNode.NodeType = AEKBNode.NodeType
	s objKBNode.TextData= AEKBNode.TextData
	
	s TempKBTreeID = objKBNode.KBTreeID 
	s:(AEKBNode.KBTreeID '= "") objKBNode.KBTreeID = AEKBNode.KBTreeID
	
	if ((AEKBNode.KBTreeID '= "")&&(TempKBTreeID '= AEKBNode.KBTreeID))
	{
	 	if (TempKBTreeID '= "")
	  	{ 
	  		s objOldKBTree = ##Class(EMRmeta.KBTree).%OpenId(TempKBTreeID)
			s objOldKBTree.ResChildCount = objOldKBTree.ResChildCount - 1
			if '(objOldKBTree.%Save())
			{
				TROLLBACK
				s result = "0"
			}    
		}
		if (AEKBNode.KBTreeID '= "")
	 	{
		 	Set objNewKBTree = ##class(EMRmeta.KBTree).%OpenId(objKBNode.KBTreeID)
			set objNewKBTree.ResChildCount = objNewKBTree.ResChildCount + 1
			if '(objNewKBTree.%Save())
			{
				TROLLBACK
				s result = "0"
			}    
		}	   
	}
	if '(objKBNode.%Save())
	{
		TROLLBACK
		s result = "0"	
	}
	
	TCOMMIT
	s result = "1"	
	
	q result
}

ClassMethod UpdatePresentation(AEKBNode As EMRservice.entity.EKBNode) As %String
{
	s result = "-1"		
    q:((AEKBNode = "")||(AEKBNode.ID = "")) result 
        

    s streamPresentationData = AEKBNode.PresentationData
    
    s objKbNode = ##Class(EMRmeta.KBNode).%OpenId(AEKBNode.ID)
    q:(objKbNode = "") result
    d objKbNode.PresentationData.CopyFrom(streamPresentationData)
    s sc = objKbNode.%Save()

	s:($$$ISOK(sc)) result = "1"
	q result
}

/// Desc:		停用知识库
/// Creaotr:	Candy
/// CreateDate:	2014-10-20
/// Input:		AKBNodeID 知识库ID
/// 				AIsInUse  (Y 启用,N 停用)
/// OutPut:     result 0失败 1成功
ClassMethod StopOrStartKBNode(AKBNodeID As %String, AIsInUse As %String) As %String
{
	s result = "0"
	s objKBNode = ##Class(EMRmeta.KBNode).%OpenId(AKBNodeID)
	q:(objKBNode = "") result
	s objKBNode.IsInUse = AIsInUse
	s sc = objKBNode.%Save()
	if $$$ISOK(sc)
	{
		s result = "1"	
	}
	q result
}

/// Desc: 新建知识库节点
/// Creator: Candy
/// CreateDate: 2014-6-5
ClassMethod CreateKBNode(AEKBNode As EMRservice.entity.EKBNode) As %String
{
	TSTART
	s objKBNode = ##class(EMRmeta.KBNode).%New()	
	s objKBNode.Name = AEKBNode.Name
	s objKBNode.KBTreeID = AEKBNode.KBTreeID
	s objKBNode.Description = AEKBNode.Description
	s objKBNode.KnowledgeBaseID = AEKBNode.KnowledgeBaseID	
	s objKBNode.IsCommon = AEKBNode.IsCommon
	s objKBNode.IsInUse = AEKBNode.IsInUse
	s objKBNode.NodeType = AEKBNode.NodeType
	s objKBNode.TextData = AEKBNode.TextData
	d objKBNode.MetaData.CopyFrom(AEKBNode.MetaData)
	d objKBNode.PresentationData.CopyFrom(AEKBNode.PresentationData)
	d objKBNode.ScriptData.CopyFrom(AEKBNode.ScriptData)
	d objKBNode.MediasData.CopyFrom(AEKBNode.MediasData)
	d objKBNode.InitialData.CopyFrom(AEKBNode.InitialData)

	s objKBTree = ##Class(EMRmeta.KBTree).%OpenId(objKBNode.KBTreeID)
	if (objKBTree = "")
	{
	  	TROLLBACK
		q 0
	}
	s objKBTree.ResChildCount = objKBTree.ResChildCount + 1
	if '(objKBTree.%Save())
	{
		TROLLBACK
		q 0
	} 
	
	if '(objKBNode.%Save())
	{
	  	TROLLBACK
		q 0
	}
	TCOMMIT
	d ..SaveSequence(objKBNode.%Id())
	q objKBNode.%Id()
}

/// Desc: 新建知识库节点
/// Creator: Candy
/// CreateDate: 2014-6-5
ClassMethod UpdateKBNodeMetaData(aKBNodeID As %String, AEKBNode As EMRservice.entity.EKBNode) As %String
{
	s result = "0"
	q:(aKBNodeID = "") result
	s objKbNode = ##Class(EMRmeta.KBNode).%OpenId(aKBNodeID)
    q:(objKbNode = "") result
    
    d objKbNode.MetaData.CopyFrom(AEKBNode.MetaData)
    d objKbNode.ScriptData.CopyFrom(AEKBNode.ScriptData)
    d objKbNode.MediasData.CopyFrom(AEKBNode.MediasData)
    d objKbNode.InitialData.CopyFrom(AEKBNode.InitialData)
	d objKbNode.PresentationData.CopyFrom(AEKBNode.PresentationData)
    s sc = objKbNode.%Save()

	s:($$$ISOK(sc)) result = "1"
	q result
}

/// creator:     Candyxu 
/// CreatDate:   2014-06-05
/// Description: 存储顺序号
/// Table:       EMRservice.BOKBNode
/// Input:       树结点ID
/// debug        do ##class(EMRservice.BOKBNode).SaveSequence("56")
ClassMethod SaveSequence(RowID As %String)
{
	s TempKBNode= ##class(EMRmeta.KBNode).%OpenId(RowID)
	q:(TempKBNode = "")
	s TempKBNode.Sequence=TempKBNode.%Id()
	d TempKBNode.%Save()
	d TempKBNode.%Close()	
	k TempKBNode
}

/// d ##Class(EMRservice.BL.BLKBNode).doClear()
ClassMethod doClear()
{
	s objKBNode = ##Class(EMRmeta.KBNode).%OpenId("4")
	d objKBNode.MetaData.Clear()
    d objKBNode.ScriptData.Clear()
    d objKBNode.MediasData.Clear()
    d objKBNode.InitialData.Clear()
    d objKBNode.PresentationData.Clear()
    d objKBNode.%Save()
}

/// creator:Candy xu 
/// CreatDate:2011-05-24
/// Description:修改树节点排序顺序号
/// Table:EMRmeta.KBNode
/// Input:KBNodeID1树节点1，KBNodeID2树节点2
/// Output:无
/// Return: result是否操作成功
/// others: do ##class(EMRservice.BL.BLKBNode).SwapSequence("1","2")
ClassMethod SwapSequence(KBNodeID1, KBNodeID2 As %String) As %Boolean
{
	set result=0
	
	set objKBNode = ##class(EMRmeta.KBNode).%OpenId(KBNodeID1)
	set objKBNodeSele = ##class(EMRmeta.KBNode).%OpenId(KBNodeID2)
	q:((objKBNode = "")||(objKBNodeSele = "")) result
	 
	set TempSequence = objKBNode.Sequence
	set objKBNode.Sequence = objKBNodeSele.Sequence
	set objKBNodeSele.Sequence = TempSequence
	
	set $zt = "SwapErrorHandler"
	
	Tstart
	
	set scResult = objKBNode.%Save()
	if $$$ISERR(scResult)
	{
		Trollback
		q result
	}
	
	set scResultSele = objKBNodeSele.%Save() 
	if $$$ISERR(scResultSele)
	{
		Trollback
		q Ruslut
	}
	
	TCOMMIT
			    
	do objKBNodeSele.%Close()
	do objKBNode.%Close()
	set objKBNodeSele = ""
	set objKBNode = ""
	
	set Ruslut = 1
	q Ruslut

SwapErrorHandler
	Trollback
	q "0"
}

/// creator:Donglulu 
/// CreatDate:2016-09-1
/// Description:追加节点之后，修改树节点排序顺序号
/// Table:EMRmeta.KBNode
/// Input:KBNodeID1：右键选中的知识库节点ID,KBNodeID2：追加的知识库节点ID
/// Output: result是否操作成功
/// Debug:  w ##class(EMRservice.BL.BLKBNode).UpdateKbnodeSeq("15405","15544","5212")
ClassMethod UpdateKbnodeSeq(KBNodeID1 As %String, KBNodeID2 As %String, KBTreeID As %String) As %Boolean
{
	s result = 0
	q:(KBNodeID1 = "")||(KBNodeID2 = "")||(KBTreeID = "")
	s nodeID = ""
	s nodeSeq = ""
	s objNode = ##Class(EMRmeta.KBNode).%OpenId(KBNodeID1)
	s preSeq = objNode.Sequence
	d objNode.%Close()	
	k objNode
	//将追加节点之后的节点顺序号加1
	for
	{
		s nodeSeq = $o(^DHCEMRM.KBNodeI("IdxKBTreeIDSeq"," "_KBTreeID,nodeSeq),-1)
		q:(nodeSeq = "")||(nodeSeq = preSeq)
		s nodeID = $o(^DHCEMRM.KBNodeI("IdxKBTreeIDSeq"," "_KBTreeID,nodeSeq,""))
		q:(nodeID = "")
		s objNode = ##Class(EMRmeta.KBNode).%OpenId(nodeID)
		q:(objNode = "")
		s objNode.Sequence = objNode.Sequence + 1
		d objNode.%Save()
		d objNode.%Close()	
		k objNode
	}
	
	//改变追加进来的节点的顺序号
	s objNode = ##Class(EMRmeta.KBNode).%OpenId(KBNodeID2)
	s objNode.Sequence = preSeq + 1
	d objNode.%Save()
	d objNode.%Close()	
	k objNode
	s result = 1
	q result
}

/// Desc: 		根据知识库节点ID查询该节点的知识库文本内容
/// Creaotr:	Lina
/// CreateDate:	2016-8-30
/// Input:		AKBNodeID: 知识库节点ID
/// OutPut:     知识库文本内容JSon
/// Deubgger:   w ##Class(EMRservice.BL.BLKBNode).GetKBNodeTextByKBNodeID("6")
ClassMethod GetKBNodeTextByKBNodeID(AKBNodeID As %String) As %String
{
	q:(AKBNodeID = "") ""
	s objKbNode = ##Class(EMRmeta.KBNode).%OpenId(AKBNodeID)
    q:(objKbNode = "") ""
    s TextData = objKbNode.TextData
    s TextData = $REPLACE(TextData,$C(10),"<br/>")
    q TextData
}

/// Desc:		共享个人知识库
/// Creaotr:	董璐璐
/// CreateDate:	2017-9-5
/// Input:		AKBNodeID 个人知识库节点ID
/// w ##Class(EMRservice.BL.BLKBNode).ShareKBNode("8664","4133","190")
ClassMethod ShareKBNode(AKBNodeID As %String, AUserID As %String, AUserLocID As %String) As %String
{
	s result = 0
	q:(AKBNodeID = "")||(AUserID = "")||(AUserLocID = "") result
	s kbTreeParentID = ##Class(EMRservice.BL.BLKBNode).GetkbTreeParentID(AKBNodeID)
	s strKBNodeShareID = $o(^DHCEMRM.KBNodeShareI("IdxUserIDLocIDKBNode"," "_AUserID," "_AUserLocID,AKBNodeID,""))
	q:(strKBNodeShareID '= "") "-1"
	s isApprove = ##class(EMRservice.BL.BLSysOption).GetOptionValueByName2("KBShareIsAprrove","N")
	s obj = ##Class(EMRmeta.KBNodeShare).%New()
	s obj.KBTreeParentID = kbTreeParentID
	s obj.KBNodeID = AKBNodeID
	s obj.UserID = AUserID
	s obj.CTLocID = AUserLocID
	if (isApprove="N")
	{
		s obj.Status = "1"
	}
	else
	{
		s obj.Status = "2"
	}
	s sc = obj.%Save()
	s result = $$$ISOK(sc)
	d obj.%Close()	
	k obj
	q result
}

/// Desc: 		根据知识库节点ID查询该节点的关联的 EMRmeta.KBTree表中ParentID为0的KBTreeID（知识库目录与科室关联的一级）
/// Creaotr:	董璐璐
/// CreateDate:	2019-5-14
/// Input:		AKBNodeID: 知识库节点ID
/// OutPut:     kbTreeParentID
/// Deubgger:   w ##Class(EMRservice.BL.BLKBNode).GetkbTreeParentID("8676")
ClassMethod GetkbTreeParentID(AKBNodeID As %String) As %String
{
	s result = ""
	q:(AKBNodeID = "") result
	s objKbNode = ##Class(EMRmeta.KBNode).%OpenId(AKBNodeID)
    q:(objKbNode = "") result
    s kbtreeID = objKbNode.KBTreeID
	for
	{
		s objKbTree = ##Class(EMRmeta.KBTree).%OpenId(kbtreeID)
    	q:(objKbTree = "") 
    	if (objKbTree.ParentID = "0")
    	{
	    	s result = kbtreeID
	    	q
    	}
    	s kbtreeID = objKbTree.ParentID
	}
	
    q result
}

/// Desc:      取共享知识库节点
/// Creaotr:   董璐璐
/// CreateDate：2019-5-14
/// Input:		AKBTreeParentID:知识库treeID
///             ALocID:科室ID
/// OutPut:     node JSon
/// d ##Class(EMRservice.BL.BLKBNode).GetShareNodes(190,871)
ClassMethod GetShareNodes(ALocID As %String, AKBTreeParentID As %String) As %Stream
{
	s strJson = ##class(%GlobalCharacterStream).%New()
	q:(ALocID = "")||(AKBTreeParentID = "") strJson 
	s nodeID = ""
	for
	{
		s nodeID = $o(^DHCEMRM.KBNodeShareI("IdxLocTreeParentNode"," "_ALocID," "_AKBTreeParentID,nodeID))
		q:(nodeID = "")
		
		s nodeShareID = $o(^DHCEMRM.KBNodeShareI("IdxLocTreeParentNode"," "_ALocID," "_AKBTreeParentID,nodeID,""))
		q:(nodeShareID = "")
		s objShare = ##Class(EMRmeta.KBNodeShare).%OpenId(nodeShareID)
		q:(objShare = "")
		continue:((objShare.Status '= "1"))
		s objNode = ##Class(EMRmeta.KBNode).%OpenId(nodeID)
		q:(objNode = "")
		continue:($zcvt(objNode.IsInUse,"U") '= "Y")
		d:(strJson.Size > 0) strJson.Write(",")
		
		s isEmpty = $case(objNode.MetaData.Size,0:"Y",:"N")
		s kbNodeName = ""
		s kbNodeName = ##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(objNode.Name)
	
		d strJson.Write("{""id"":"""_objNode.%Id()_"""")
		d strJson.Write(",""text"":"""_kbNodeName_"""")
		d strJson.Write(",""attributes"":{""type"":""KBNode""")
		d strJson.Write(",""desc"":"""_$s(objNode.Description=$c(0):"",1:objNode.Description)_"""")
		d strJson.Write(",""isCommon"":"""_objNode.IsCommon_"""")
		d strJson.Write(",""isInUse"":"""_objNode.IsInUse_"""")
		d strJson.Write(",""shareUser"":"""_objShare.UserID_"""")
		d strJson.Write(",""isEmpty"":"""_isEmpty_"""}}")

	}
	q strJson
}

/// Desc:       取消分享个人知识库节点
/// Creator:    董璐璐
/// CreateDate: 2019-5-15
/// Input:      argRowID 	知识库KBnodeID
///             argUserID    登录用户
///             argUserLocID 登录科室
/// Output:     成功返回1 ,失败返回空
/// Debug:      w ##Class(EMRservice.BL.BLKBNode).CancelShareNode("8676",4133,190)
ClassMethod CancelShareNode(argRowID As %String, argUserID As %String, argUserLocID As %String) As %String
{
	s result = ""
	q:(argRowID = "")||(argUserID = "")||(argUserLocID = "") result
	
	s nodeShareID = $o(^DHCEMRM.KBNodeShareI("IdxUserIDLocIDKBNode"," "_argUserID," "_argUserLocID,argRowID,""))
	q:(nodeShareID = "")
    
    s sc = ##class(EMRmeta.KBNodeShare).%DeleteId(nodeShareID)
	s:($$$ISOK(sc)) result = "1"
	q result
}

/// Desc:       共享个人知识库迁移数据（迁移至用户默认登录科室）
/// Creator:    董璐璐
/// CreateDate: 2019-5-15
/// Input:      
/// Output:     
/// Debug:      d ##Class(EMRservice.BL.BLKBNode).ShareKBNodeMoveTo()
ClassMethod ShareKBNodeMoveTo()
{
	s nodeID = ""
	for
	{
		s nodeID = $o(^DHCEMRM.KBNodeI("IdxIsShareIsInUse"," Y"," Y",nodeID))
		q:(nodeID = "")
		s objKBNode = ##Class(EMRmeta.KBNode).%OpenId(nodeID)
		s treeID = objKBNode.KBTreeID
		continue:(treeID = "")
		s objKBTree = ##Class(EMRmeta.KBTree).%OpenId(treeID)
		s userID = objKBTree.PersonalKBUserID
		continue:(userID = "")
		s locID = ##class(EMRservice.BL.BLPowerUser).GetUserLocID(userID)
		continue:(locID = "")
		s KBTreeParentID = ##Class(EMRservice.BL.BLKBNode).GetkbTreeParentID(nodeID)
		continue:(KBTreeParentID = "")
		
		s strKBNodeShareID = $o(^DHCEMRM.KBNodeShareI("IdxUserIDLocIDKBNode"," "_userID," "_locID,nodeID,""))
		continue:(strKBNodeShareID '= "") 
		
		s objNodeShare = ##Class(EMRmeta.KBNodeShare).%New()
		s objNodeShare.KBNodeID = nodeID
		s objNodeShare.UserID = userID
	    s objNodeShare.CTLocID = locID
	    s objNodeShare.Status = "1"
	    s objNodeShare.KBTreeParentID = KBTreeParentID
	    s sc = objNodeShare.%Save()
	    d objNodeShare.%Close()	
		k objNodeShare
	}
}

/// Desc:       共享个人知识库迁移数据（迁移至用户其他登录科室）
/// Creator:    董璐璐
/// CreateDate: 2020-3-5
/// Input:      
/// Output:  
/// Debug:      d ##Class(EMRservice.BL.BLKBNode).ShareKBNodeMoveToOtherLoc()
ClassMethod ShareKBNodeMoveToOtherLoc()
{
	
	s nodeID = ""
	for
	{
		s nodeID = $o(^DHCEMRM.KBNodeI("IdxIsShareIsInUse"," Y"," Y",nodeID))
		q:(nodeID = "")
		s objKBNode = ##Class(EMRmeta.KBNode).%OpenId(nodeID)
		s treeID = objKBNode.KBTreeID
		continue:(treeID = "")
		s objKBTree = ##Class(EMRmeta.KBTree).%OpenId(treeID)
		s userID = objKBTree.PersonalKBUserID
		continue:(userID = "")
		s KBTreeParentID = ##Class(EMRservice.BL.BLKBNode).GetkbTreeParentID(nodeID)
		continue:(KBTreeParentID = "")
		
		s OTHLLDr=""
		f{
			s OTHLLDr=$o(^SSU("SSUSR",userID,"OTHLL",OTHLLDr))
			
			q:OTHLLDr=""
			s otherDeptDr=$p(^SSU("SSUSR",userID,"OTHLL",OTHLLDr),"^",1)
			s strKBNodeShareID = $o(^DHCEMRM.KBNodeShareI("IdxUserIDLocIDKBNode"," "_userID," "_otherDeptDr,nodeID,""))
			continue:(strKBNodeShareID '= "") 

			s objNodeShare = ##Class(EMRmeta.KBNodeShare).%New()
			s objNodeShare.KBNodeID = nodeID
			s objNodeShare.UserID = userID
		    s objNodeShare.CTLocID = otherDeptDr
		    s objNodeShare.Status = "1"
		    s objNodeShare.KBTreeParentID = KBTreeParentID
		    s sc = objNodeShare.%Save()
		    d objNodeShare.%Close()	
			k objNodeShare
		}
	}
}

/// creator:     liuyunfei
/// CreatDate:   2019-11-12
/// Description: 记录知识库目录树节点修改日志
/// Input:       userId: 操作人id
///              userName：当前操作人用户名
///              ipAddress:当前操作人ip
/// 			 information：ID^NameOld^NameNew^TextDataOld^TextDataNew(节点id^节点原名^节点新名^节点原内容^节点新内容)
///              actionType：产品类型 
/// debug:       d ##class(EMRservice.BL.BLKBNode).UpdateKBNodeNameEventLog("10209","医生01","192.168.0.171","567^测试01^测试02^ 测试11^ 测试12","EMR.Knowledge.Update")
ClassMethod UpdateKBNodeNameEventLog(userId As %String, userName As %String, ipAddress As %String, information As %String, actionType As %String) As %String
{
	s Condition = ""
	
	s Condition = Condition_"{""userId"":"""_userId_""","
	s Condition = Condition_"""userName"":"""_userName_""","
	s Condition = Condition_"""ipAddress"":"""_ipAddress_""","
	s Condition = Condition_"""id"":"""_$p(information,"^",1)_""","
	s Condition = Condition_"""nameOld"":""—"","
	s Condition = Condition_"""nameNew"":""—"","
	s Condition = Condition_"""nodeNameOld"":"""_$p(information,"^",2)_""","
	s Condition = Condition_"""nodeNameNew"":"""_$p(information,"^",3)_""","
	s Condition = Condition_"""textDataOld"":"""_$p(information,"^",4)_""","
	s Condition = Condition_"""textDataNew"":"""_$p(information,"^",5)_"""}"
	d ##Class(EMRservice.Ajax.SetDataToEventLog).SetDataToEventLog(actionType,Condition,"")
	w ""
}

/// creator:     liuyunfei
/// CreatDate:   2019-11-12
/// Description: 记录知识库目录树节点删除日志
/// Input:       userId: 操作人id
///              userName：当前操作人用户名
///              ipAddress:当前操作人ip
/// 			 information：id^name^nodeName(节点id^文件夹名称^节点名称)
///              actionType：产品类型 
/// debug:       d ##class(EMRservice.BL.BLKBNode).DeleteKBNodeNameEventLog("10209","医生01","192.168.0.171","567^测试01^测试02^ 测试11^ 测试12","EMR.Knowledge.Delete")
ClassMethod DeleteKBNodeNameEventLog(userId As %String, userName As %String, ipAddress As %String, information As %String, actionType As %String) As %String
{
	s Condition = ""
	
	s Condition = Condition_"{""userId"":"""_userId_""","
	s Condition = Condition_"""userName"":"""_userName_""","
	s Condition = Condition_"""ipAddress"":"""_ipAddress_""","
	s Condition = Condition_"""id"":"""_$p(information,"^",1)_""","
	s Condition = Condition_"""name"":"""_$p(information,"^",2)_""","
	s Condition = Condition_"""nodeName"":"""_$p(information,"^",3)_"""}"
	d ##Class(EMRservice.Ajax.SetDataToEventLog).SetDataToEventLog(actionType,Condition,"")
	w ""
}

/// creator:     liuyunfei
/// CreatDate:   2019-11-14
/// Description: 记录知识库浏览日志
/// Input:       userId: 操作人id
///              userName：当前操作人用户名
///              ipAddress:当前操作人ip
/// 			 information：id^name(章节id^章节名称)
///              actionType：产品类型 
/// debug:       d ##class(EMRservice.BL.BLKBNode).ViewKBNodeNameEventLog("10209","医生01","192.168.0.171","13^主诉","EMR.Knowledge.View")
ClassMethod ViewKBNodeNameEventLog(userId As %String, userName As %String, ipAddress As %String, information As %String, actionType As %String) As %String
{
	s Condition = ""
	
	s Condition = Condition_"{""userId"":"""_userId_""","
	s Condition = Condition_"""userName"":"""_userName_""","
	s Condition = Condition_"""ipAddress"":"""_ipAddress_""","
	s Condition = Condition_"""id"":"""_$p(information,"^",1)_""","
	s Condition = Condition_"""name"":"""_$p(information,"^",2)_"""}"
	d ##Class(EMRservice.Ajax.SetDataToEventLog).SetDataToEventLog(actionType,Condition,"")
	w ""
}

/// Desc:       关联知识库
/// Creaotr:    yejian
/// CreateDate: 2020-9-1
/// Input:		KBNodeID 知识ID
/// OutPut:     OutRecords 知识库xml流
/// Deubgger:   w ##Class(EMRservice.BL.BLKBNode).LoadComposite("",4)
ClassMethod LoadCompositeReKBNodeID(ByRef OutRecords As %GlobalBinaryStream, AKBNodeID As %String) As %String
{
	s result = "-1"		
    q:(AKBNodeID = "") result 
    d ..GetNodeXMLReKBNodeID(AKBNodeID,OutRecords)
	s result = "1"
	q result
}

/// Desc:       取知识内容xml替换KBNodeID
/// Creator:    yejian
/// CreateDate: 2020-9-1
/// Input:      ANodeID 知识库ID
/// OutPut:     OutKBNode 知识库节点xml            
ClassMethod GetNodeXMLReKBNodeID(ANodeID As %String, ByRef OutKBNode As %GlobalBinaryStream) As %String
{
	s result = "-1"
	q:(ANodeID = "") result
	s objKBNode = ##Class(EMRmeta.KBNode).%OpenId(ANodeID)
	q:(objKBNode = "") result
	s metaDataStream = ##class(%GlobalBinaryStream).%New()
	s ReplaceStream = ##class(%GlobalBinaryStream).%New()
	d OutKBNode.Write("<?xml version=""1.0"" encoding=""UTF-8""?>")
	d OutKBNode.Write("<KBData>")
	d OutKBNode.Write("<TemplateGUID>"_objKBNode.GUID_"</TemplateGUID>")
	d OutKBNode.Write("<Macros>")
	d OutKBNode.Write("<Macro/>")
	d OutKBNode.Write("</Macros>")
	d OutKBNode.Write("<StructuredBody>")
	//知识库通过插件导出导入的数据存在xml中kbnodeid和表中kbnodeid值不一致情况单独处理
	//d OutKBNode.CopyFrom(objKBNode.MetaData)
	s strInclude = "KBNodeID="_""""_ANodeID_""""
	s strReplace = """"_ANodeID_""""
	s strContain ="KBNodeID="
	s strReplaceBaseID = "BindKBBaseID="_""""_objKBNode.KnowledgeBaseID_""""
	s strContainBaseID = "BindKBBaseID=""0"""
	d metaDataStream.CopyFrom(objKBNode.MetaData)
	s strMetaD =  metaDataStream.Read(5000)
	//xml中的kbnodeid和表中的kbnodeid一致，不做处理
	if ((strMetaD[strInclude)&&(strMetaD[strReplaceBaseID))
	{
		d OutKBNode.CopyFrom(objKBNode.MetaData)
	}
	else
	{
		d metaDataStream.Rewind()
		while (metaDataStream.AtEnd = 0)
		{
			s tmp =  metaDataStream.Read(32000)
			if (tmp [ strContainBaseID)
			{
				s tmp = $REPLACE(tmp,strContainBaseID,strReplaceBaseID)
			}
			if (tmp [ strContain)
			{
				s tmp1 = $p(tmp,strContain,1)
				s tmp2 = strContain
				s tmp3 = $p(tmp,strContain,2)
				s tmp31 = $p(tmp3,"/>",1)
				s tmp3 = $REPLACE(tmp3,tmp31,strReplace)
				s tmp = tmp1_tmp2_tmp3
			}
			d ReplaceStream.Write(tmp)
		} 
		d OutKBNode.CopyFrom(ReplaceStream)
	}

	d OutKBNode.CopyFrom(objKBNode.ScriptData)
	d OutKBNode.CopyFrom(objKBNode.MediasData)
	d OutKBNode.CopyFrom(objKBNode.InitialData)
	d OutKBNode.CopyFrom(objKBNode.PresentationData)
	d OutKBNode.Write("</StructuredBody>")
	d OutKBNode.Write("</KBData>") 
	q 1
}

}
