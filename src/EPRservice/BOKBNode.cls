Class EPRservice.BOKBNode Extends %SOAP.WebService [ Not ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://localhost/trakcarelive/trak/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "KBNodeInfo";

ClassMethod CreateKBNode(AEKBNode As EPRservice.entity.EKBNode) As %String [ WebMethod ]
{
	TSTART

	s objKBNode = ##class(EPRmeta.KBNode).%New()
	q:(objKBNode = "") "ERROR" 
	
	s objKBNode.Name = AEKBNode.Name
	s objKBNode.KBTreeID = AEKBNode.KBTreeID
	s objKBNode.Description = AEKBNode.Description
	s objKBNode.KnowledgeBaseID = AEKBNode.KnowledgeBaseID

 	//s objKBNode.S1InstanceData = ##Class(%GlobalCharacterStream).%New() 
 	d objKBNode.S1InstanceData.CopyFrom(AEKBNode.S1InstanceData)

 	//s objKBNode.S1MetaData =##Class(%GlobalCharacterStream).%New() 
 	d objKBNode.S1MetaData.CopyFrom(AEKBNode.S1MetaData)

 	//s objKBNode.S2InstanceData =##Class(%GlobalCharacterStream).%New()
 	d objKBNode.S2InstanceData.CopyFrom(AEKBNode.S2InstanceData) 

	//s objKBNode.S2MetaData =##Class(%GlobalCharacterStream).%New() 
	d objKBNode.S2MetaData.CopyFrom(AEKBNode.S2MetaData)
	
	//s objKBNode.S3InstanceData =##Class(%GlobalCharacterStream).%New()
	d objKBNode.S3InstanceData.CopyFrom(AEKBNode.S3InstanceData) 
	
	//s objKBNode.S3MetaData =##class(%GlobalCharacterStream).%New() 
	d objKBNode.S3MetaData.CopyFrom(AEKBNode.S3MetaData)
	
	s objKBNode.IsCommon = AEKBNode.IsCommon
	
	s objKBNode.IsInUse = AEKBNode.IsInUse
	
	s objKBTree = ##Class(EPRmeta.KBTree).%OpenId(objKBNode.KBTreeID)
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

ClassMethod DeleteKBNode(AID As %String) As %Boolean [ WebMethod ]
{
	TSTART
		
	s objKBNode = ##Class(EPRmeta.KBNode).%OpenId(AID)
	if (objKBNode = "")
	{
		TROLLBACK
		q 0
	}
	
	s objKBTree = ##Class(EPRmeta.KBTree).%OpenId(objKBNode.KBTreeID)
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

ClassMethod SelectKBNodeByID(AID As %String) As EPRservice.entity.EKBNode [ WebMethod ]
{
	s objKBNode = ##Class(EPRmeta.KBNode).%OpenId(AID)
	q:(objKBNode="") ""
	
	s Result = ##Class(EPRservice.entity.EKBNode).%New()
	
	s Result.ID = objKBNode.%Id()
	s Result.Name = objKBNode.Name
	s Result.KBTreeID = objKBNode.KBTreeID
	s Result.KnowledgeBaseID = objKBNode.KnowledgeBaseID
	s Result.Description = objKBNode.Description
	s Result.S1InstanceData = objKBNode.S1InstanceData
	s Result.S1MetaData = objKBNode.S1MetaData
	s Result.S2InstanceData = objKBNode.S2InstanceData
	s Result.S2MetaData = objKBNode.S2MetaData
	s Result.S3InstanceData = objKBNode.S3InstanceData
	s Result.S3MetaData = objKBNode.S3MetaData
	s Result.Sequence = objKBNode.Sequence
	s Result.IsCommon = objKBNode.IsCommon
	s Result.IsInUse = objKBNode.IsInUse
	
	q Result
}

ClassMethod SelectKBNodeByName(AName As %String, AKnowledgeBaseID As %String) As EPRservice.dataset.EKBNodeSelectByNameDataset [ WebMethod ]
{
	New result
	set result = ##Class(EPRservice.dataset.EKBNodeSelectByNameDataset).%New()
	Do result.SetArgs(AName, AKnowledgeBaseID)
	Quit result
}

ClassMethod SelectKBNodeInUseByID(AKBTreeID As %String) As EPRservice.dataset.EKBNodeInUseDataset [ WebMethod ]
{
	New result	
	Set result = ##Class(EPRservice.dataset.EKBNodeInUseDataset).%New()
	Do result.SetArgs(AKBTreeID)
	Quit result
}

ClassMethod SelectKBNodeByKBTreeID(AKBTreeID As %String) As EPRservice.dataset.EKBNodeDataset [ WebMethod ]
{
	;S ^AAKBNode("AKBTreeID")= AKBTreeID
	New result	
	Set result = ##Class(EPRservice.dataset.EKBNodeDataset).%New()
	Do result.SetArgs(AKBTreeID)
	Quit result
}

ClassMethod UpdateKBNode(AEKBNode As EPRservice.entity.EKBNode) As %Boolean [ WebMethod ]
{
	n TempKBTreeID
	
	TSTART
	
	s objKBNode = ##Class(EPRmeta.KBNode).%OpenId(AEKBNode.ID)
	s objKBNode.Name = AEKBNode.Name
	s objKBNode.Description = AEKBNode.Description
	
	s TempKBTreeID = objKBNode.KBTreeID 
	s objKBNode.KBTreeID = AEKBNode.KBTreeID
	
	s objKBNode.KnowledgeBaseID = AEKBNode.KnowledgeBaseID
	
	d objKBNode.S1InstanceData.CopyFrom(AEKBNode.S1InstanceData)
	d objKBNode.S1MetaData.CopyFrom(AEKBNode.S1MetaData)
	d objKBNode.S2InstanceData.CopyFrom(AEKBNode.S2InstanceData)
	d objKBNode.S2MetaData.CopyFrom(AEKBNode.S2MetaData)
	d objKBNode.S3InstanceData.CopyFrom(AEKBNode.S3InstanceData)
	d objKBNode.S3MetaData.CopyFrom(AEKBNode.S3MetaData) 
	
	s objKBNode.IsCommon = AEKBNode.IsCommon
	s objKBNode.IsInUse = AEKBNode.IsInUse
		
	if (TempKBTreeID '= AEKBNode.KBTreeID)
	{
	 	if (TempKBTreeID '= "")
	  	{ 
	  		s objOldKBTree = ##Class(EPRmeta.KBTree).%OpenId(TempKBTreeID)
			s objOldKBTree.ResChildCount = objOldKBTree.ResChildCount - 1
			if '(objOldKBTree.%Save())
			{
				TROLLBACK
				Quit 0
			}    
		}
		if (AEKBNode.KBTreeID '= "")
	 	{
		 	Set objNewKBTree = ##class(EPRmeta.KBTree).%OpenId(objKBNode.KBTreeID)
			set objNewKBTree.ResChildCount = objNewKBTree.ResChildCount + 1
			if '(objNewKBTree.%Save())
			{
				TROLLBACK
				q 0
			}    
		}	   
	}
	
	if '(objKBNode.%Save())
	{
		TROLLBACK
		q 0
	}
	
	TCOMMIT
	q 1
}

ClassMethod testCreateKBNode(AEKBNode As EPRservice.entity.EKBNode) As %String [ WebMethod ]
{
 //B "S"
 TSTART
 set objKBNode = ##class(EPRmeta.KBNode).%New()
 Quit:(objKBNode ="") "ERROR" 
 set objKBNode.Name = AEKBNode.Name
 set objKBNode.KBTreeID = AEKBNode.KBTreeID
 set objKBNode.Description = AEKBNode.Description
 set objKBNode.KnowledgeBaseID = AEKBNode.KnowledgeBaseID
 set objKBNode.S1InstanceData = ##class(%GlobalCharacterStream).%New() 
 Do objKBNode.S1InstanceData.CopyFrom(AEKBNode.S1InstanceData)

 set objKBNode.S1MetaData =##class(%GlobalCharacterStream).%New() 
 Do objKBNode.S1MetaData.CopyFrom(AEKBNode.S1MetaData)

 set objKBNode.S2InstanceData =##class(%GlobalCharacterStream).%New()
 Do objKBNode.S2InstanceData.CopyFrom(AEKBNode.S2InstanceData) 

 set objKBNode.S2MetaData =##class(%GlobalCharacterStream).%New() 
 Do objKBNode.S2MetaData.CopyFrom(AEKBNode.S2MetaData)

 set objKBNode.S3InstanceData =##class(%GlobalCharacterStream).%New()
 Do objKBNode.S3InstanceData.CopyFrom(AEKBNode.S3InstanceData) 

 set objKBNode.S3MetaData =##class(%GlobalCharacterStream).%New() 
 Do objKBNode.S3MetaData.CopyFrom(AEKBNode.S3MetaData)


 /*set objKBNode.S1InstanceData = AEKBNode.S1InstanceData
 set objKBNode.S1MetaData = AEKBNode.S1MetaData
 set objKBNode.S2InstanceData = AEKBNode.S2InstanceData
 set objKBNode.S2MetaData = AEKBNode.S2MetaData
 set objKBNode.S3InstanceData = AEKBNode.S3InstanceData
 set objKBNode.S3MetaData = AEKBNode.S3MetaData*/

 set objKBTree = ##class(EPRmeta.KBTree).%OpenId(objKBNode.KBTreeID)
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
/// Description:存储顺序号
/// Table:EPRservice.BOKBNode
/// Input:树结点ID
/// do ##class(EPRservice.BOKBNode).SaveSequence("56")
ClassMethod SaveSequence(RowID As %String)
{
	 set TempKBNode= ##class(EPRmeta.KBNode).%OpenId(RowID)
	 if (TempKBNode '="")
	 {
	    set TempKBNode.Sequence=TempKBNode.%Id()
	    do TempKBNode.%Save()
	    do TempKBNode.%Close()	
	 }
     set TempKBNode=""
}

/// creator:Candy xu 
/// CreatDate:2011-05-24
/// Description:修改树节点排序顺序号
/// Table:EPRmeta.KBNode
/// Input:KBNodeID1树节点1，KBNodeID2树节点2
/// Output:无
/// Return: result是否操作成功
/// others: do ##class( EPRservice.BOKBNode).SwapSequence("1","2")
ClassMethod SwapSequence(KBNodeID1 As %String, KBNodeID2 As %String) As %Boolean [ WebMethod ]
{
	set result=0
	
	set objKBNode = ##class(EPRmeta.KBNode).%OpenId(KBNodeID1)
	set objKBNodeSele = ##class(EPRmeta.KBNode).%OpenId(KBNodeID2)
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
/// Table:		EPRmeta.KBNode
/// Input:		AEpisodeID为患者就诊指针;
/// 			ACtLocID为登录科室RowID;
/// 			AKBaseID为知识库RowID;
/// Output:		无
/// Return: 	默认知识库节点对象
/// others: 	d ##Class(EPRservice.BOKBNode).GetDefaultKBNodeByLocDiagnosID("201871","7")
ClassMethod GetDefaultKBNodeByLocDiagnosID(AEpisodeID As %String, AKBaseID As %String) As EPRservice.entity.EKBNode [ WebMethod ]
{
	s ret = ""
	
	s defaultKBNodeID = ..GetDefaultKBNodeID(AEpisodeID,AKBaseID)
	q:(defaultKBNodeID = "") ret
	
	s objKBNode = ##Class(EPRmeta.KBNode).%OpenId(defaultKBNodeID)
	q:(objKBNode = "") ret
	
	s objEKBNode = ##Class(EPRservice.entity.EKBNode).%New()
	s objEKBNode.ID = defaultKBNodeID
	s objEKBNode.Name = objKBNode.Name
	s objEKBNode.KBTreeID = objKBNode.KBTreeID
	s objEKBNode.KnowledgeBaseID = objKBNode.KnowledgeBaseID
	s objEKBNode.Description = objKBNode.Description
	s objEKBNode.S1InstanceData = objKBNode.S1InstanceData
	s objEKBNode.S1MetaData = objKBNode.S1MetaData
	s objEKBNode.S2InstanceData = objKBNode.S2InstanceData
	s objEKBNode.S2MetaData = objKBNode.S2MetaData
	s objEKBNode.S3InstanceData = objKBNode.S3InstanceData
	s objEKBNode.S3MetaData = objKBNode.S3MetaData
	s objEKBNode.IsCommon = objKBNode.IsCommon
    s objEKBNode.IsInUse = objKBNode.IsInUse
		
	q objEKBNode
}

/// creator:	Kumon Xie
/// CreatDate:	2011-09-21
/// Description:根据就诊指针获取疾病类型然后据此获取默认知识库节点
/// Table:		EPRmeta.KBNodeDiagnos
/// Input:		AEpisodeID为患者就诊指针;
/// 			AKBaseID为知识库RowID;
/// Output:		无
/// Return: 	如果存在，则返回KBNodeID，否则返回空
/// others: 	w ##Class(EPRservice.BOKBNode).GetDefaultKBNodeID("201871","133")
ClassMethod GetDefaultKBNodeID(AEpisodeID, AKBaseID) As %String
{
	s ret = ""
	q:($g(AEpisodeID) = "") ret
	
	s kbDiagnosID = ##Class(EPRservice.BOInstanceData).GetKBDiagnosIDByEpisodeID(AEpisodeID)
	q:(+kbDiagnosID = 0) ret
	
	s sequence = 10000000
	s lastKBNodeID = ""

	s rowID = ""
	for {
		s rowID = $o(^DHCEPRM.KBNodeDiagnosI("IdxKBDiagnosID",kbDiagnosID,rowID))
		q:(rowID = "")
		//wangwentao 20111017 update begin
		//实现病种功能先配先显示
		q:(lastKBNodeID '="")
		s Hospital="",Hospital=##class(EPRmeta.SysOption).GetOptionValueByName("HospitalName")
		//实现默认不加载日常病程知识库BaseID
		q:(Hospital="YKYZLYY")&&(AKBaseID=12)
		//实现默认不加载手术记录知识库BaseID
		q:(Hospital="YKYZLYY")&&(AKBaseID=26)
		//wangwentao 20111017 update end

		s objKBNodeDiagnos = $g(^DHCEPRM.KBNodeDiagnosD(rowID))
		continue:(objKBNodeDiagnos = "")
		
		s activeFlag = $list(objKBNodeDiagnos,5)
		continue:(activeFlag = 0)
		
		s kbNodeID = $list(objKBNodeDiagnos,3)
		continue:(kbNodeID = "")
		
		s objKBNode = $g(^DHCEPRM.KBNodeD(kbNodeID))
		continue:(objKBNode = "")
		
		s knowledgeBaseID = $list(objKBNode,11)
		continue:(knowledgeBaseID '= AKBaseID)
		
		s isDiagRuleOK = ##Class(EPRservice.BOEPRDiagnosConfig).IsDiagRuleOK(rowID,AEpisodeID)
		continue:(+isDiagRuleOK <= 0)
		
		s kbNodeSequence = $list(objKBNode,12)
		if (kbNodeSequence < sequence)
		{
			s sequence = kbNodeSequence
			s lastKBNodeID = kbNodeID
		}
	}
	
	q lastKBNodeID
}

}
