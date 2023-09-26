Class EMRservice.BL.BLDiseases Extends (%RegisteredObject, %XML.Adaptor)
{

/// creator:	Candy
/// CreatDate:	2016-08-29
/// Description:供切换病人所在科室疾病类型的备选项使用
/// Table:		EMRmeta.KBDiagnos
/// Input:		AEpisodeID为患者就诊指针;
/// 			ACtLocID为登录科室RowID;
/// Output:		无
/// Return: 	病人所在科室的所有疾病类型JSON串
/// others: 	w ##Class(EMRservice.BL.BLDiseases).GetDiseasesList("112","6")
ClassMethod GetDiseasesList(AEpisodeID As %String, ACtLocID As %String) As %String
{
	s json = ""
	q:($g(AEpisodeID) = "")||($g(ACtLocID) = "") json
	
	//取患者当前就诊的诊断ICDCode，用于判断是否与已维护的某个病种相关联，若是则前台自动选中该病种；
	s mainDiagnosICDCode = ""
	s mainDiagnos = ##class(EMRservice.HISInterface.PatientInfoAssist).DiagnosInfo(AEpisodeID)	
	s:(mainDiagnos '= "") mainDiagnosICDCode = $P(mainDiagnos,"^",2)
	//病历类型关联病种
	s usedKBDiagnosID = ..GetKBDiagnosIDByEpisodeID(AEpisodeID)
	s useStatus = 0
	s tmpGroupJson = ..GetGroupDiseases(ACtLocID,mainDiagnosICDCode,usedKBDiagnosID,"0",.useStatus)
	s tmpNoGroupJson = ..GetNoGroupDiseases(ACtLocID,mainDiagnosICDCode,usedKBDiagnosID,.useStatus)
	s json = $s(useStatus = "0":"[{""id"":""0"",""name"":""不关联任何疾病"",""attributes"":{""isUsed"":""1"",""rowID"":""0"",""type"":""root""}}",1:"[{""id"":""0"",""name"":""不关联任何疾病"",""attributes"":{""isUsed"":""0"",""rowID"":""0"",""type"":""root""}}")
	s:(tmpGroupJson '= "") json = json_","
	s json = json_tmpGroupJson
	s:(tmpNoGroupJson '= "") json = json_","
    s json = json_tmpNoGroupJson_"]"
	q json
}

/// Desc:       获取Group病种
/// Creator:    Candy
/// CreateDate: 2016-8-31
/// Input：     AMainDiagnosICDCode
///             AUsedKBDiagnosID
///             AparentId
/// Output:     json
ClassMethod GetGroupDiseases(ACtLocID As %String, AMainDiagnosICDCode As %String, AUsedKBDiagnosID As %String, AparentId As %String, ByRef useStatus As %String) As %String
{
	s json = ""
	s parentId = " "_AparentId
	s groupCount = 0

	s seq = ""
	for
	{
		s seq = $o(^DHCEMRM.DiagnosGroupI("IdxLocSeq"," "_ACtLocID, parentId,seq))
		q:(seq = "")
		s rowId = ""
		for
		{
			s rowId = $o(^DHCEMRM.DiagnosGroupI("IdxLocSeq"," "_ACtLocID, parentId,seq,rowId))
			q:(rowId = "")
			s objCategory = ##Class(EMRmeta.DiagnosGroup).%OpenId(rowId)
			
			s:(groupCount '= 0) json = json_","
			s json = json_"{""id"":"""_rowId_""",""name"":"""_objCategory.GroupName_""",""attributes"":{""type"":""group""},""icon"":""../scripts/epr/ExtJS/resources/images/default/tree/folder.gif"",""children"":["  
	        
	        s subCount = 0
	        s subJson = ""
			s detailseq = ""
			for
			{
				s detailseq = $o(^DHCEMRM.DiagnosGroupDetailI("IdxSeq"," "_rowId,detailseq))
				q:(detailseq = "")
				s diagnoscode = ""
				for
				{
					s diagnoscode = $o(^DHCEMRM.DiagnosGroupDetailI("IdxSeq"," "_rowId,detailseq,diagnoscode))
					q:(diagnoscode = "")
					s dieaserowId = $o(^DHCEMRM.DiagnosI("IdxDiagnosCode",diagnoscode,""))
					continue:(dieaserowId = "")
					s obj = ##Class(EMRmeta.Diagnos).%OpenId(dieaserowId)
					continue:(obj = "")	
					s isUsed = $s((AUsedKBDiagnosID '= "")&&(dieaserowId = AUsedKBDiagnosID):1,1:0)
				
					// 根据就诊诊断判断与病种是否关联
					s:((isUsed = 0)&&(AMainDiagnosICDCode '= "")) isUsed = ..GetDiseaseRelation(AMainDiagnosICDCode,obj.DiagnosCode)
					s:(isUsed = 1) useStatus = 1
					s:(subCount '= 0) subJson = subJson_","
					s subJson = subJson_"{""id"":"""_obj.DiagnosCode_""",""name"":"""_obj.DiagnosName_""",""attributes"":{""isUsed"":"""_isUsed_""",""rowID"":"""_dieaserowId_""",""type"":""disease""}}"
					s subCount = subCount + 1				
				}	
			}
			s json = json_subJson
			s subTree = ..GetGroupDiseases(ACtLocID,AMainDiagnosICDCode,AUsedKBDiagnosID,rowId,useStatus)
			s:((subTree '= "")&&(subJson '="")) json = json_","
			s json = json_subTree
			s json = json_"]}"
			s groupCount = groupCount + 1		
		}	
	}
	q json
}

/// Desc:       获取NoGroup病种
/// Creator:    Candy
/// CreateDate: 2016-8-31
/// Input：     AMainDiagnosICDCode
///             AUsedKBDiagnosID
///             AparentId
/// Output:     json
ClassMethod GetNoGroupDiseases(ACtLocID As %String, AMainDiagnosICDCode As %String, AUsedKBDiagnosID As %String, ByRef useStatus As %String)
{
	s json = ""
	q:(ACtLocID = "") json
	s count = 0
	s diagnoscode = ""
	for
	{
		s diagnoscode = $o(^DHCEMRM.DiagnosCTLocI("IdxCTLocIDAndDiagnosCode"," "_ACtLocID,diagnoscode))
		q:(diagnoscode = "")
		
		s diagnosId = $o(^DHCEMRM.DiagnosI("IdxDiagnosCode",diagnoscode,""))
		continue:(diagnosId = "")
		s obj = ##Class(EMRmeta.Diagnos).%OpenId(diagnosId)
		continue:(obj = "")	
		continue:(..CheckInGroup(ACtLocID,obj.DiagnosCode)=1)
		s isUsed = $s((AUsedKBDiagnosID '= "")&&(diagnosId = AUsedKBDiagnosID):1,1:0)
	
		// 根据就诊诊断判断与病种是否关联
		s:((isUsed = 0)&&(AMainDiagnosICDCode '= "")) isUsed = ..GetDiseaseRelation(AMainDiagnosICDCode,obj.DiagnosCode)
		s:(isUsed = 1) useStatus = 1
		s:(count '= 0) json = json_","
		s json = json_"{""id"":"""_obj.DiagnosCode_""",""name"":"""_obj.DiagnosName_""",""attributes"":{""isUsed"":"""_isUsed_""",""rowID"":"""_diagnosId_""",""type"":""disease""}}"
		s count = count + 1	
	}
	q json
}

/// Desc:       判断病种是否在group中
/// Creator:    Candy
/// CreateDate: 2016-8-31
/// Input:      ACtLocID 科室ID
///             ADiagnosCode 病种代码 
ClassMethod CheckInGroup(ACtLocID As %String, ADiagnosCode As %String) As %String
{
	s result = 0
	s groupId = ""
	for
	{
		s groupId = $o(^DHCEMRM.DiagnosGroupI("IdxCTLocID"," "_ACtLocID,groupId))
		q:(groupId = "")
		s:($d(^DHCEMRM.DiagnosGroupDetailI("IdxCode"," "_groupId," "_$zcvt(ADiagnosCode,"U")))>0) result = 1
		q:(result = 1)
	}
	q result
}

/// creator:	Candy
/// CreatDate:	2014-01-16
/// Description:取病历类型关联病种
/// Table:		EMRinstance.AdmPatType
/// Input:		AEpisodeID为患者就诊指针;
/// Output:		无
/// Return: 	病人病历类型关联的病种ID
/// others: 	w ##Class(EMRservice.BL.BLDiseases).GetKBDiagnosIDByEpisodeID("76")
ClassMethod GetKBDiagnosIDByEpisodeID(AEpisodeID As %String) As %String [ WebMethod ]
{
	s diagnosID = ""
	s admPatTypeRowID = $o(^DHCEMRI.AdmPatTypeI("IdxEpisodeID"," "_AEpisodeID,""))
	if (admPatTypeRowID '= "")
	{
		s objKBDiagnos = ##Class(EMRinstance.AdmPatType).%OpenId(admPatTypeRowID)
		q:(objKBDiagnos = "") diagnosID 
		s diagnosID = objKBDiagnos.EPRKBDiagnosID
		d objKBDiagnos.%Close()
		s objKBDiagnos = ""
	}	
	q diagnosID
}

/// creator:	candy
/// CreatDate:	2016-8-31
/// Description:判断病种关联的疾病是否包含患者诊断
/// Table:		EMRmeta.Diagnos、EMRmeta.DiagnosDisease
/// Input:		mainDiagnosICDCode为患者就诊诊断的ICDCode;ArowID为病种ID
/// Return: 	1：病种关联的疾病包含患者诊断；0：病种关联的疾病不包含患者诊断
/// others: 	w ##Class(EMRservice.BL.BLDiseases).GetDiseaseRelation("S93.431","7")
ClassMethod GetDiseaseRelation(AmainDiagnosICDCode As %String, ADiseaseCode As %String) As %String
{
	s result = 0
	q:($g(AmainDiagnosICDCode) = "")||($g(ADiseaseCode) = "") result

	s ICDCode = ""
	for {
		s ICDCode = $O(^DHCEMRM.DiagnosDiseaseI("IdxDiagnosCodeAndICDCode"," "_ADiseaseCode,ICDCode))
		q:(ICDCode = "")
		s tmpICDCode = $tr(ICDCode," ","")
		s:($zcvt(AmainDiagnosICDCode,"U") = $zcvt(tmpICDCode,"U")) result = 1
		q:(result = 1)
	}
	q result
}

/// creator:	Candy
/// CreatDate:	2014-01-16
/// Description:供切换病人所在科室疾病类型的备选项使用
/// Table:		EMRservice.BL.BLKBDiagnos
/// Input:		AEpisodeID为患者就诊指针;
/// Output:		N(失败),Y(成功)
/// Return: 	病人所在科室的所有疾病类型JSON串
/// others: 	w ##Class(EMRservice.BL.BLKBDiagnos).SaveEpisodeDiagnos("76")
ClassMethod SaveEpisodeDiagnos(AepisodeID As %String, AdiagnosID As %String) As %String
{
	q:(AdiagnosID = "-1") "N"

	//修改病历科室表
	s userID = %session.Get("LOGON.USERID")
	s curAdmPatTypeRowID = $o(^DHCEMRI.AdmPatTypeI("IdxEpisodeID", " "_AepisodeID, 0))
	if (curAdmPatTypeRowID = "")
	{
		s curObjAdmPatType = ##Class(EMRinstance.AdmPatType).%New()
	}
	else
	{
		s curObjAdmPatType = ##Class(EMRinstance.AdmPatType).%OpenId(curAdmPatTypeRowID)
	}
	q:(curObjAdmPatType = "") $$$OK
	
	s curObjAdmPatType.EpisodeID = AepisodeID
	s curObjAdmPatType.EMRKBDiagnosID = AdiagnosID
	s curObjAdmPatType.AppointUserID = userID
	d curObjAdmPatType.%Save()
	d curObjAdmPatType.%Close()
	s curObjAdmPatType = ""
	
	q "Y"
}

/// Debugge：   w ##Class(EMRservice.BL.BLDiseases).GetBindFistNodeForOP("S002:69^S003:70^S008:164^S014:165",52,1,350)
/// Input：     ABaseNodeID为章节关联知识库ID(从前台获取$$注意为多个组，增加循环$$)
///             ADiseaseID病种ID(从前台获取)
ClassMethod GetBindFistNodeForOP(ABaseNodeIDCount As %String, ALocID As %String, ADiseaseID As %String, AEpisodeID As %String) As %String
{
	s result = "",flag=""
	q:((ABaseNodeIDCount = "")||(ALocID = "")||(AEpisodeID = "")) result
	s lenghth = $l(ABaseNodeIDCount,"^")
	for i=1:1:lenghth
	{
		s ABaseNodeID = $p($p(ABaseNodeIDCount,"^",lenghth+1-i),":",2)
		s objKBBase = ##Class(EMRmeta.KnowledgeBase).%OpenId(ABaseNodeID)
		continue:(objKBBase = "")
		s result = ..GetFistKBNode(ABaseNodeID,ALocID,0,ADiseaseID,AEpisodeID)
		continue:(result = "")
		if (flag =""){
			s flag = $p($p(ABaseNodeIDCount,"^",lenghth+1-i),":",1)_":"_result
		}else{
			s flag = flag_"^"_$p($p(ABaseNodeIDCount,"^",lenghth+1-i),":",1)_":"_result
		}
	}
	q flag
}

/// Desc:		递归查找baseID下与病种或标题关联的第一个知识库结点
/// Creator:    yan
/// CreateTime: 2017-08-11
/// Input:		AKBBaseID: 知识库KnowledgeBaseID
///             ALocID: 科室ID
///             ADiseaseID：病种ID
/// Return:     NodeID
/// 参考自:     ##Class(EMRservice.BL.BLKBNode).GetBindFistNode(BaseNodeID,LocID,DiseaseID,TitleCode,EpisodeID,NodeData)
/// Debugge：   w ##Class(EMRservice.BL.BLDiseases).GetFistKBNode(69,52,0,1,350)
ClassMethod GetFistKBNode(AKBBaseID As %String, ALocID As %String, AParentID As %String, ADiseaseID As %String, AEpisodeID As %String) As %String
{
	s result = ""
	s treeID = ""
	for
	{
		s treeID = $o(^DHCEMRM.KBTreeI("IdxBaseIDParentID"," "_AKBBaseID," "_AParentID,treeID))
		q:(treeID = "")

		continue:((AParentID = 0)&&($d(^DHCEMRM.KBTreeCTLocI("IdxCTLocKBTreeFlag"," "_ALocID," "_treeID," 1"))<=0))
		
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
				s diseaseNodeResult = ##class(EMRservice.BL.BLKBNode).IsDiseaseNodeOK(nodeID,ADiseaseID)
				s diseaseNodeFlag = $p(diseaseNodeResult,"^",1)
				continue:(diseaseNodeFlag '= 1)
				s kbNodeDiagnosID =  $p(diseaseNodeResult,"^",2)
				s result = ##class(EMRservice.BL.BLKBNode).IsDiagRuleOK(kbNodeDiagnosID,AEpisodeID)
				continue:(result '= 1) 
				s result = nodeID
				q:(result '= "")
		    }
		}
		q:(result '= "")
		s result = ..GetFistKBNode(AKBBaseID,ALocID,treeID,ADiseaseID,AEpisodeID)
    	q:(result '= "")
    }
    q result
}

/// Desc:		前台预览病种内容使用
/// Debugge：   w ##Class(EMRservice.BL.BLDiseases).GetBindFistNodeForPreview("S002:69^S003:70^S008:164^S014:165",52,1,350)
/// Input：     ABaseNodeID为章节关联知识库ID(前台传$$注意为多个组，增加循环$$)
///             ADiseaseID病种ID(前台传)
ClassMethod GetBindFistNodeForPreview(ABaseNodeIDCount As %String, ALocID As %String, ADiseaseID As %String, AEpisodeID As %String) As %String
{
	s result = "",flag=""
	q:((ABaseNodeIDCount = "")||(ALocID = "")||(AEpisodeID = "")) result
	s lenghth = $l(ABaseNodeIDCount,"^")
	for i=1:1:lenghth
	{
		s ABaseNodeID = $p($p(ABaseNodeIDCount,"^",i),":",2)
		s objKBBase = ##Class(EMRmeta.KnowledgeBase).%OpenId(ABaseNodeID)
		continue:(objKBBase = "")
		s result = ..GetFistKBNode(ABaseNodeID,ALocID,0,ADiseaseID,AEpisodeID)
		continue:(result = "")
		s obj = ##Class(EMRmeta.KBNode).%OpenId(result)
		s text = obj.TextData
		if (flag =""){
			s flag = $p($p(ABaseNodeIDCount,"^",i),":",3)_":"_text
		}else{
			s flag = flag_"<br>"_$p($p(ABaseNodeIDCount,"^",i),":",3)_":"_text
		}
	}
	q flag
}

/// w ##Class(EMRservice.BL.BLDiseases).GetDiseasesTree("112","6")
ClassMethod GetDiseasesTree(AEpisodeID As %String, ACtLocID As %String) As %String
{
	q $replace(##class(EMRservice.BL.BLDiseases).GetDiseasesList(AEpisodeID,ACtLocID),"name","text")
}

}
