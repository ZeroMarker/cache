Class EMRservice.BOKBNode Extends %SOAP.WebService [ ClassType = "", Not ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://localhost/trakcarelive/trak/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "KBNodeInfo";

ClassMethod GetXMLRecord() As %GlobalBinaryStream [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLKBNode).GetXMLRecord(4)
}

ClassMethod CreateKBNode(AEKBNode As EMRservice.entity.EKBNode) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLKBNode).CreateKBNode(AEKBNode)
}

ClassMethod UpdateKBNodeMetaData(aKBNodeID As %String, AEKBNode As EMRservice.entity.EKBNode) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLKBNode).UpdateKBNodeMetaData(aKBNodeID,AEKBNode)
}

ClassMethod DeleteKBNode(AID As %String) As %Boolean [ WebMethod ]
{
	TSTART
		
	s objKBNode = ##Class(EMRmeta.KBNode).%OpenId(AID)
	if (objKBNode = "")
	{
		TROLLBACK
		q 0
	}
	
	s objKBTree = ##Class(EMRmeta.KBTree).%OpenId(objKBNode.KBTreeID)
	if (objKBTree = "")
	{
	  	TROLLBACK
		q 0
	}
		
	s objKBTree.ResChildCount = objKBTree.ResChildCount - 1
	if '(objKBTree.%Save())
	{
		TROLLBACK
		q 0
	}	
	
	if '(objKBNode.%DeleteId(AID))
	{
		TROLLBACK
		q 0
	}
	
	TCOMMIT
	q 1
}

ClassMethod SelectKBNodeByID(AID As %String) As EMRservice.entity.EKBNode [ WebMethod ]
{
	s objKBNode = ##Class(EMRmeta.KBNode).%OpenId(AID)
	q:(objKBNode="") ""
	
	s Result = ##Class(EMRservice.entity.EKBNode).%New()
	
	s Result.ID = objKBNode.%Id()
	s Result.Name = objKBNode.Name
	s Result.KBTreeID = objKBNode.KBTreeID
	s Result.KnowledgeBaseID = objKBNode.KnowledgeBaseID
	s Result.Description = objKBNode.Description
	d Result.PresentationData.CopyFrom(objKBNode.PresentationData)
	d Result.MetaData.CopyFrom(objKBNode.MetaData)
	d Result.ScriptData.CopyFrom(objKBNode.ScriptData)		

	s Result.Sequence = objKBNode.Sequence
	s Result.IsCommon = objKBNode.IsCommon
	s Result.IsInUse = objKBNode.IsInUse
	s Result.NodeType = objKBNode.NodeType
	s Result.TextData = objKBNode.TextData
	q Result
}

ClassMethod SelectAllKBNode() As EMRservice.dataset.EKBNodeAllDataSet [ WebMethod ]
{
	New result	
	Set result = ##Class(EMRservice.dataset.EKBNodeAllDataSet).%New()
	Do result.SetArgs()
	Quit result
}

ClassMethod UpdatePresentation(AEKBNode As EMRservice.entity.EKBNode) As %Boolean [ WebMethod ]
{
    q ##Class(EMRservice.BL.BLKBNode).UpdatePresentation(AEKBNode)
}

ClassMethod SelectKBNodeByName(AName As %String, AKnowledgeBaseID As %String) As EMRservice.dataset.EKBNodeSelectByNameDataset [ WebMethod ]
{
	New result
	set result = ##Class(EMRservice.dataset.EKBNodeSelectByNameDataset).%New()
	Do result.SetArgs(AName, AKnowledgeBaseID)
	Quit result
}

ClassMethod SelectKBNodeInUseByID(AKBTreeID As %String) As EMRservice.dataset.EKBNodeInUseDataset [ WebMethod ]
{
	New result	
	Set result = ##Class(EMRservice.dataset.EKBNodeInUseDataset).%New()
	Do result.SetArgs(AKBTreeID)
	Quit result
}

ClassMethod SelectKBNodeByKBTreeID(AKBTreeID As %String) As EMRservice.dataset.EKBNodeDataset [ WebMethod ]
{
	;S ^AAKBNode("AKBTreeID")= AKBTreeID
	New result	
	Set result = ##Class(EMRservice.dataset.EKBNodeDataset).%New()
	Do result.SetArgs(AKBTreeID)
	Quit result
}

ClassMethod UpdateKBNode(AEKBNode As EMRservice.entity.EKBNode) As %Boolean [ WebMethod ]
{
    q ##Class(EMRservice.BL.BLKBNode).UpdateKBNode(AEKBNode)
}

ClassMethod testCreateKBNode(AEKBNode As EMRservice.entity.EKBNode) As %String [ WebMethod ]
{
 //B "S"
 TSTART
 set objKBNode = ##class(EMRmeta.KBNode).%New()
 Quit:(objKBNode ="") "ERROR" 
 set objKBNode.Name = AEKBNode.Name
 set objKBNode.KBTreeID = AEKBNode.KBTreeID
 set objKBNode.Description = AEKBNode.Description
 set objKBNode.KnowledgeBaseID = AEKBNode.KnowledgeBaseID
 set objKBNode.InstanceData = ##class(%GlobalCharacterStream).%New() 
 Do objKBNode.InstanceData.CopyFrom(AEKBNode.InstanceData)

 set objKBNode.MetaData =##class(%GlobalCharacterStream).%New() 
 Do objKBNode.MetaData.CopyFrom(AEKBNode.MetaData)

 set objKBTree = ##class(EMRmeta.KBTree).%OpenId(objKBNode.KBTreeID)
 if (objKBTree ="")
 {
	  TROLLBACK
 Quit 0
 }
 set objKBTree.ResChildCount = objKBTree.ResChildCount + 1
 if '(objKBTree.%Save())
 {
 TROLLBACK
 Quit 0
 } 


 if '(objKBNode.%Save())
	{
	  TROLLBACK
 Quit 0
 } 
 TCOMMIT
	Quit objKBNode.%Id()
}

/// creator:Candy xu 
/// CreatDate:2011-05-24
/// Description:修改树节点排序顺序号
/// Table:EMRmeta.KBNode
/// Input:KBNodeID1树节点1，KBNodeID2树节点2
/// Output:无
/// Return: result是否操作成功
/// others: do ##class( EMRservice.BOKBNode).SwapSequence("1","2")
ClassMethod SwapSequence(KBNodeID1 As %String, KBNodeID2 As %String) As %Boolean [ WebMethod ]
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

/// creator:	Kumon Xie
/// CreatDate:	2011-09-21
/// Description:根据登录科室、疾病种类以及知识库获取默认知识库节点对象
/// Table:		EMRmeta.KBNode
/// Input:		AEpisodeID为患者就诊指针;
/// 			ACtLocID为登录科室RowID;
/// 			AKBaseID为知识库RowID;
/// Output:		无
/// Return: 	默认知识库节点对象
/// others: 	d ##Class(EMRservice.BOKBNode).GetDefaultKBNodeByLocDiagnosID("201871","7")
ClassMethod GetDefaultKBNodeByLocDiagnosID(AEpisodeID As %String, AKBaseID As %String) As EMRservice.entity.EKBNode [ WebMethod ]
{
	s ret = ""
	
	s defaultKBNodeID = ..GetDefaultKBNodeID(AEpisodeID,AKBaseID)
	q:(defaultKBNodeID = "") ret
	
	s objKBNode = ##Class(EMRmeta.KBNode).%OpenId(defaultKBNodeID)
	q:(objKBNode = "") ret
	
	s objEKBNode = ##Class(EMRservice.entity.EKBNode).%New()
	s objEKBNode.ID = defaultKBNodeID
	s objEKBNode.Name = objKBNode.Name
	s objEKBNode.KBTreeID = objKBNode.KBTreeID
	s objEKBNode.KnowledgeBaseID = objKBNode.KnowledgeBaseID
	s objEKBNode.Description = objKBNode.Description
	s objEKBNode.InstanceData = objKBNode.InstanceData
	s objEKBNode.MetaData = objKBNode.MetaData

	s objEKBNode.IsCommon = objKBNode.IsCommon
    s objEKBNode.IsInUse = objKBNode.IsInUse
		
	q objEKBNode
}

/// creator:	Kumon Xie
/// CreatDate:	2011-09-21
/// Description:根据就诊指针获取疾病类型然后据此获取默认知识库节点
/// Table:		EMRmeta.KBNodeDiagnos
/// Input:		AEpisodeID为患者就诊指针;
/// 			AKBaseID为知识库RowID;
/// Output:		无
/// Return: 	如果存在，则返回KBNodeID，否则返回空
/// others: 	w ##Class(EMRservice.BOKBNode).GetDefaultKBNodeID("201871","133")
ClassMethod GetDefaultKBNodeID(AEpisodeID, AKBaseID) As %String
{
	s ret = ""
	q:($g(AEpisodeID) = "") ret
	
	s kbDiagnosID = ##Class(EMRservice.BOInstanceData).GetKBDiagnosIDByEpisodeID(AEpisodeID)
	q:(+kbDiagnosID = 0) ret
	
	s sequence = 10000000
	s lastKBNodeID = ""

	s rowID = ""
	for {
		s rowID = $o(^DHCEMRM.KBNodeDiagnosI("IdxKBDiagnosID",kbDiagnosID,rowID))
		q:(rowID = "")
		//wangwentao 20111017 update begin
		//实现病种功能先配先显示
		q:(lastKBNodeID '="")
		s Hospital="",Hospital=##class(EMRservice.BL.BLSysOption).GetOptionValueByName("HospitalName")
		//实现默认不加载日常病程知识库BaseID
		q:(Hospital="YKYZLYY")&&(AKBaseID=12)
		//实现默认不加载手术记录知识库BaseID
		q:(Hospital="YKYZLYY")&&(AKBaseID=26)
		//wangwentao 20111017 update end

		s objKBNodeDiagnos = ##Class(EMRmeta.KBNodeDiagnos).%OpenId(rowID)
		continue:(objKBNodeDiagnos = "")
		
		s activeFlag = objKBNodeDiagnos.ActiveFlag
		continue:(activeFlag = 0)
		
		s kbNodeID = objKBNodeDiagnos.KBNodeID
		continue:(kbNodeID = "")
		
		s objKBNode = ##Class(EMRmeta.KBNode).%OpenId(kbNodeID)
		continue:(objKBNode = "")
		
		s knowledgeBaseID = objKBNode.KnowledgeBaseID
		continue:(knowledgeBaseID '= AKBaseID)
		
		s isDiagRuleOK = ##Class(EMRservice.BOEMRDiagnosConfig).IsDiagRuleOK(rowID,AEpisodeID)
		continue:(+isDiagRuleOK <= 0)
		
		s kbNodeSequence = objKBNode.Sequence
		if (kbNodeSequence < sequence)
		{
			s sequence = kbNodeSequence
			s lastKBNodeID = kbNodeID
		}
	}
	
	q lastKBNodeID
}

}
