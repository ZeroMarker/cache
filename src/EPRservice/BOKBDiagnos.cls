Class EPRservice.BOKBDiagnos Extends %SOAP.WebService [ ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://localhost/trakcarelive/trak/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService. 
Parameter SERVICENAME = "KBDiagnos";

ClassMethod GetDiagnosByID(ARowID As %String) As EPRservice.entity.EKBDiagnos [ WebMethod ]
{
	s objDiagnos = ##Class(EPRmeta.KBDiagnos).%OpenId(ARowID)
	q:(objDiagnos = "") ""
	
	s Result = ##Class(EPRservice.entity.EKBDiagnos).%New()
	s Result.ID = objDiagnos.%Id()
	s Result.Name = objDiagnos.Name
	s Result.Description = objDiagnos.Description
	s Result.GroupName = objDiagnos.GroupName
	s Result.GroupDescription = objDiagnos.GroupDescription
	s Result.Diagnos = objDiagnos.Diagnos
	s Result.CTLocID = objDiagnos.CTLocID
	s Result.UserID = objDiagnos.UserID
	s Result.CreateDate = $zd(objDiagnos.CreateDate,3)

	q Result
}

/// Debug: ##class(EPRservice.BOKBDiagnos).GetAllDiagnos()
ClassMethod GetAllDiagnos() As %XML.DataSet [ WebMethod ]
{
	s result = ##Class(%XML.DataSet).%New("EPRservice.BOKBDiagnos:SelectAllDiagnos")
	q result
}

ClassMethod AddKBDiagnos(AKBDiagnos As EPRservice.entity.EKBDiagnos) As %String [ WebMethod ]
{
	s ret = 1
	s objKBDiagnos = ##Class(EPRmeta.KBDiagnos).%New()
	s objKBDiagnos.Name = AKBDiagnos.Name
	s objKBDiagnos.Description = AKBDiagnos.Description
	s objKBDiagnos.GroupName = AKBDiagnos.GroupName
	s objKBDiagnos.GroupDescription = AKBDiagnos.GroupDescription
	s objKBDiagnos.Diagnos = AKBDiagnos.Diagnos
	s objKBDiagnos.CTLocID = AKBDiagnos.CTLocID
	s objKBDiagnos.UserID = AKBDiagnos.UserID
	s objKBDiagnos.CreateDate = $p($h,",",1)	
	if '(objKBDiagnos.%Save())
	{
		s ret = 0	
	}
	d objKBDiagnos.%Close()
	q ret
}

ClassMethod DelKBDiagnos(ADiagnosID As %String) As %Boolean [ WebMethod ]
{
	s ret = 0
	q:($g(ADiagnosID) = "") ret

	s flag = 1
	s diagnosID = $g(ADiagnosID)
	
	TSTART
	
	s kbNodeDiagnosID = ""
	for {
		s kbNodeDiagnosID = $o(^DHCEPRM.KBNodeDiagnosI("IdxKBDiagnosID",diagnosID,kbNodeDiagnosID))
		q:(kbNodeDiagnosID = "")
		
		s objKBNodeDiagnos = ##Class(EPRmeta.KBNodeDiagnos).%OpenId(kbNodeDiagnosID)
		if '(objKBNodeDiagnos.%DeleteId(kbNodeDiagnosID))
		{
			TROLLBACK
			s flag = 0
			q
		}
	}
	
	s objKBDiagnos = ##Class(EPRmeta.KBDiagnos).%OpenId(diagnosID)
	if '(objKBDiagnos.%DeleteId(diagnosID))
	{
		TROLLBACK
		s flag = 0
	}
	
	s ret = flag
	q ret
}

ClassMethod ModKBDiagnos(AKBDiagnos As EPRservice.entity.EKBDiagnos) As %Boolean [ WebMethod ]
{
	s ret = 1
	s objKBDiagnos = ##Class(EPRmeta.KBDiagnos).%OpenId(AKBDiagnos.ID)
	s objKBDiagnos.Name = AKBDiagnos.Name
	s objKBDiagnos.Description = AKBDiagnos.Description
	s objKBDiagnos.GroupName = AKBDiagnos.GroupName
	s objKBDiagnos.GroupDescription = AKBDiagnos.GroupDescription
	s objKBDiagnos.Diagnos = AKBDiagnos.Diagnos
	s objKBDiagnos.CTLocID = AKBDiagnos.CTLocID
	s objKBDiagnos.UserID = AKBDiagnos.UserID
	//s objKBDiagnos.CreateDate = AKBDiagnos.CreateDate
	if '(objKBDiagnos.%Save())
	{
		s ret = 0	
	}
	d objKBDiagnos.%Close()
	q ret
}

ClassMethod GetDiagnosByCtLocID(ACtLocID As %String) As EPRservice.dataset.EKBDiagnosByCtLocID [ WebMethod ]
{
	s result = ##Class(%XML.DataSet).%New("EPRmeta.KBDiagnos:GetDiagnosByCtLocID")
	d result.SetArgs(ACtLocID)
	q result
}

/// creator:	Kumon Xie
/// CreatDate:	2011-09-21
/// Description:供切换病人所在科室疾病类型的备选项使用
/// Table:		EPRmeta.KBDiagnos
/// Input:		AEpisodeID为患者就诊指针;
/// 			ACtLocID为登录科室RowID;
/// Output:		无
/// Return: 	病人所在科室的所有疾病类型JSON串
/// others: 	w ##Class(EPRservice.BOKBDiagnos).GetDiagnosJSONByCtLocID("201871","34")
ClassMethod GetDiagnosJSONByCtLocID(AEpisodeID As %String, ACtLocID As %String) As %String
{
	s ret = ""
	q:($g(AEpisodeID) = "")||($g(ACtLocID) = "") ret
	
	s isUsed = 0
	s usedKBDiagnosID = ##Class(EPRservice.BOInstanceData).GetKBDiagnosIDByEpisodeID(AEpisodeID)
	
	s count = 0
	if (+usedKBDiagnosID = 0)
	{
		w "[[0,'不关联任何疾病',1]"
		s count = count + 1	
	}
	else
	{
		w "[[0,'不关联任何疾病',0]"
		s count = count + 1
	}

	//s json = $s(+usedKBDiagnosID = 0:"[[0,'不关联任何疾病',1]",1:"[[0,'不关联任何疾病',0]")
	s diagnosName = ""
	for {
		s diagnosName = $o(^DHCEPRM.KBDiagnosI("IdxCTLocIDAndName",ACtLocID, diagnosName))
		q:(diagnosName = "")
		s rowID = ""
		for {
			s rowID = $o(^DHCEPRM.KBDiagnosI("IdxCTLocIDAndName",ACtLocID,diagnosName,rowID))
			q:(rowID = "")
		
			s objKBDiagnos = $g(^DHCEPRM.KBDiagnosD(rowID))
			continue:(objKBDiagnos = "")
		
			s name = $list(objKBDiagnos,2)
			s desc = $list(objKBDiagnos,3)
			s isUsed = $s((usedKBDiagnosID '= "")&&(rowID = usedKBDiagnosID):1,1:0)
		
			s count = count + 1
			if count>1 w ","
			w "["_rowID_",'"_desc_"',"_isUsed_"]"
		}
	}
	
	w "]"
}

/// Debug: 	w ##Class(EPRservice.BOKBDiagnos).ChecktDiagnosByCtLocID("201868","34")
ClassMethod ChecktDiagnosByCtLocID(AEpisodeID As %String, ACtLocID As %String)
{
	s rowID = ""
	s ret = 0
	for {
		//b "s"
		s rowID = $o(^DHCEPRM.KBDiagnosI("IdxCTLocID",ACtLocID,rowID))
		q:(rowID="")
		s objKBDiagnos = ##Class(EPRmeta.KBDiagnos).%OpenId(rowID)
		if (objKBDiagnos.GroupName = $c(0) || (objKBDiagnos.GroupName = ""))
		{
			s objKBDiagnos.GroupName = "ZZ"
			s objKBDiagnos.GroupDescription = "未分组"
			s sc = objKBDiagnos.%Save()
			d objKBDiagnos.%Close()
			s ret = 1	
		}
		elseif(objKBDiagnos.GroupName '= "ZZ")
		{
			s ret = 1
		}	
	}
	q ret
}

/// Debug: 	w ##Class(EPRservice.BOKBDiagnos).GetCurrentDiagnosByCtLocID("201868","34")
ClassMethod GetCurrentDiagnosByCtLocID(AEpisodeID As %String, ACtLocID As %String) As %String
{
	s usedKBDiagnosID = ##Class(EPRservice.BOInstanceData).GetKBDiagnosIDByEpisodeID(AEpisodeID)
	q:(+usedKBDiagnosID)<1 ""
	
	//已选择的病种对当前科室不可用 
	//q:($d(^DHCEPRM.KBDiagnosI("IdxCTLocID",ACtLocID,usedKBDiagnosID)) '= "1") ""
	
	s objKBDiagnos = ##Class(EPRmeta.KBDiagnos).%OpenId(usedKBDiagnosID)
	q:(objKBDiagnos = "") ""
	
	s desc = objKBDiagnos.Description
	q desc
}

/// CreatDate:	2013-12-16
/// Description:供切换病人所在科室疾病类型的备选项使用(分组树)
/// Debug: 	w ##Class(EPRservice.BOKBDiagnos).GetDiagnosJSONTreeByCtLocID("201871","34","RT0")
ClassMethod GetDiagnosJSONTreeByCtLocID(AEpisodeID As %String, ACtLocID As %String, AParentID As %String) As %String
{
	s type = $E(AParentID,1,2)
	w "["
	
	if (type = "RT")
	{	
		d ..GetCategoryJson(ACtLocID,AEpisodeID)
	}
	elseif (type = "CG")
	{	
		d ..GetCateChapterJson(ACtLocID, AParentID)
	}
	
	w "]"
}

/// debug: d ##class(EPRservice.BOKBDiagnos).GetCategoryJson("34","")
ClassMethod GetCategoryJson(ACtLocID As %String, AEpisodeID As %String)
{
	s count = 0
	s firstJson = "{"
	s firstJson = firstJson_"id:'0'"
	s firstJson = firstJson_",text:'不关联任何疾病'"
	s firstJson = firstJson_",leaf:'true'"
	s firstJson = firstJson_",cls:'leaf'"
	s firstJson = firstJson_"}"
	
	s usedKBDiagnosID = ##Class(EPRservice.BOInstanceData).GetKBDiagnosIDByEpisodeID(AEpisodeID)
	if ((+usedKBDiagnosID)>0)
	{
		s count = count + 1
		w firstJson
	}
	
	//获取直接显示根目录下的病种，做数据兼容
	s groupNameList = " ^ "_$c(0)
	s length = $L(groupNameList,"^")
	for i = 1:1:length
	{
		s groupName = $P(groupNameList,"^",i)
		continue:(groupName="")
		
		s diagnosName = $o(^DHCEPRM.KBDiagnosI("IdxCTLocIDAndGroupNameAndName", ACtLocID, groupName,""))
		continue:(diagnosName="")
			
		s rowID = $o(^DHCEPRM.KBDiagnosI("IdxCTLocIDAndGroupNameAndName", ACtLocID, groupName, diagnosName,""))
		s objKBDiagnos = ##Class(EPRmeta.KBDiagnos).%OpenId(rowID)
		continue:(objKBDiagnos="")
		
		s description = objKBDiagnos.Description
		
		if (count = 0)
		{
			s count = count + 1
			w firstJson
		}
		
		s count = count + 1
		
		if count>1 w ","
		w "{"
		w "id:'"_rowID_"'"
		w ",text:'"_description_"'"
		w ",leaf:'true'"
		w ",cls:'leaf'"
		w "}"
	}
	
	//遍历根节点的第一层目录(Category类型)
	s groupName = ""
	for {
		s groupName = $o(^DHCEPRM.KBDiagnosI("IdxCTLocIDAndGroupNameAndName", ACtLocID, groupName))
		q:(groupName = "")
		
		b
		continue:(groupName=" ")||(groupName=(" "_$c(0)))

		s diagnosName = $o(^DHCEPRM.KBDiagnosI("IdxCTLocIDAndGroupNameAndName", ACtLocID, groupName,""))
			
		s rowID = $o(^DHCEPRM.KBDiagnosI("IdxCTLocIDAndGroupNameAndName", ACtLocID, groupName, diagnosName,""))
		s objKBDiagnos = ##Class(EPRmeta.KBDiagnos).%OpenId(rowID)
		continue:(objKBDiagnos="")
		
		s groupDescription = objKBDiagnos.GroupDescription
		s gName = objKBDiagnos.GroupName
		
		if (count = 0)
		{
			s count = count + 1
			w firstJson
		}
		
		s count = count + 1
		
		if count>1 w ","
		w "{"
		w "id:'CG"_gName_"'"
		w ",text:'"_groupDescription_"'"
		w ",cls:'folder'"
		w "}"
	}
}

/// debug: d ##class(EPRservice.BOKBDiagnos).GetCateChapterJson("34","CGZZ")
ClassMethod GetCateChapterJson(ACtLocID As %String, AGroupName As %String)
{
	s groupName = $ZCVT($e(AGroupName,3,$l(AGroupName)),"U")
	s count = 0
	
	//遍历第二层节点(CategoryChapter)
	s diagnosName = ""
	for {
		s diagnosName = $o(^DHCEPRM.KBDiagnosI("IdxCTLocIDAndGroupNameAndName", ACtLocID, " "_groupName, diagnosName))
		q:(diagnosName="")
		s rowID = ""
		for {
			s rowID = $o(^DHCEPRM.KBDiagnosI("IdxCTLocIDAndGroupNameAndName", ACtLocID, " "_groupName, diagnosName,rowID))
			q:(rowID = "")
			s objKBDiagnos = ##Class(EPRmeta.KBDiagnos).%OpenId(rowID)
			s desc = objKBDiagnos.Description
		
			s count = count + 1
			
			if (count > 1) w "," 
			w "{"
			w "id:'"_rowID_"'"
			w ",text:'"_desc_"'"
			w ",leaf:'true'"
			w ",cls:'leaf'"
			w "}"	
		}
	}
}

Query SelectAllDiagnos() As %SQLQuery(CONTAINID = 0, ROWSPEC = "ID:%String,LocID:%String,Desc:%String,Diagnos:%String,Name:%String")
{
	SELECT ID,CTLocID,Description,Diagnos,Name From EPRmeta.KBDiagnos Order By ID
}

ClassMethod SaveEpisodeDiagnos(episodeID As %String, diagnosID As %String, userID As %String) As %String
{
	//修改病历科室表
	s curAdmPatTypeRowID = $o(^DHCEPRI.AdmPatTypeI("EpisodeIDIdx", " "_episodeID, 0))
	if (curAdmPatTypeRowID = "")
	{
		s curObjAdmPatType = ##Class(EPRinstance.AdmPatType).%New()
	}
	else
	{
		s curObjAdmPatType = ##Class(EPRinstance.AdmPatType).%OpenId(curAdmPatTypeRowID)
	}
	q:(curObjAdmPatType = "") "0"
	
	s curObjAdmPatType.EpisodeID = episodeID
	s curObjAdmPatType.EPRKBDiagnosID = diagnosID
	s curObjAdmPatType.AppointUserID = userID
	d curObjAdmPatType.%Save()
	d curObjAdmPatType.%Close()
	s curObjAdmPatType = ""
	
	q "1"
}

/// w ##Class(EPRservice.BOKBDiagnos).AutoBindKBDiagnos("201871","34","5972")
ClassMethod AutoBindKBDiagnos(AEpisodeID As %String, ACTLocID As %String, AUserID As %String = "") As %String
{
	//未开启通过诊断自动关联病种功能
	s autoBindKBDiagnos = ##class(EPRmeta.SysOption).GetOptionValueByName("AutoBindKBDiagnos")
	q:(autoBindKBDiagnos '= "Y") "-1"
	
	s ACurrentBindKBDiagnosID = ##Class(EPRservice.BOInstanceData).GetKBDiagnosIDByEpisodeID(AEpisodeID)
	
	//已经关联了一个特定病种，不再需要做自动关联
	q:(+ACurrentBindKBDiagnosID)>0 ACurrentBindKBDiagnosID
	
	//已经选择不关联任何病种，不再需要做自动关联
	q:(ACurrentBindKBDiagnosID="0") ACurrentBindKBDiagnosID
	
	//已经出院，不再需要做自动关联
	s isDis = ..IsDis(AEpisodeID)
	q:(isDis="1") ACurrentBindKBDiagnosID
	
	//没有诊断信息，不需做自动关联
	s diagICDIDList = ..DiagnosICDInfo(AEpisodeID)
	q:(diagICDIDList="") ACurrentBindKBDiagnosID
	
	//自动关联一个病种
	s rowID = ""
	for {
		//b "s"
		s rowID = $o(^DHCEPRM.KBDiagnosI("IdxCTLocID",ACTLocID,rowID))
		q:(rowID="")
		
		s objKBDiagnos = ##Class(EPRmeta.KBDiagnos).%OpenId(rowID)
		continue:(objKBDiagnos="")
		continue:(objKBDiagnos.Diagnos="")||(objKBDiagnos.Diagnos=$c(0))
		
		s hasCommon = ..HasCommonICD(objKBDiagnos.Diagnos, diagICDIDList)
		continue:(hasCommon="0")
		
		do ..SaveEpisodeDiagnos(AEpisodeID, rowID, AUserID)
		s ACurrentBindKBDiagnosID = rowID
		quit
	}
	
	//没有和诊断对应的病种，关联一个空病种，表示已经自动做过关联动作，提高性能
	if (+ACurrentBindKBDiagnosID)<1
	{
	 	s ACurrentBindKBDiagnosID = "0"
	 	do ..SaveEpisodeDiagnos(AEpisodeID, "0", AUserID)
	}
	
	q ACurrentBindKBDiagnosID
}

ClassMethod IsDis(AEpisodeID) As %Boolean
{
	s admInfo = $g(^PAADM(AEpisodeID))
	if ($p(admInfo,"^",2) = "I")
	{
		q:($p(admInfo,"^",17) '= "") "1"   //出院日期不为空，已经出院
		q "0"
	}
	else
	{
		q "1"
	}
}

/// Desc: 诊断信息，诊断的优先原则为：出院诊断>主要诊断>入院诊断
/// Input: argAdmId: 就诊rowid
/// Return: RowId^RowId2^RowId3
ClassMethod DiagnosICDInfo(argAdmId As %String) As %String
{
	q:(argAdmId="") ""
	
	
	s retDiagICDIDs = ""
	
	//出院诊断
	s disDiagTypeID = $O(^MRC("DTYP",0,"Code","DIS",""))  
	if (disDiagTypeID '= "")
	{
		s retDiagICDIDs = ..GetTypedDiagnosICDID(argAdmId, disDiagTypeID)
	}
	q:(retDiagICDIDs '= "") retDiagICDIDs
	
	//主要诊断
	s mainDiagTypeId = $O(^MRC("DTYP",0,"Code","M",""))
	if (mainDiagTypeId '= "")
	{
		s retDiagICDIDs = ..GetTypedDiagnosICDID(argAdmId, mainDiagTypeId)
	}
	q:(retDiagICDIDs '= "") retDiagICDIDs
	
	//入院诊断
	s admDiagTypeId = $O(^MRC("DTYP",0,"Code","PRE",""))
	s tmpid = $O(^MRC("DTYP",0,"Code","C008",""))
	if (tmpid '= "")
	{
		if admDiagTypeId = ""
		{	s admDiagTypeId = tmpid}
		else
		{	s admDiagTypeId = admDiagTypeId_"^"_tmpid}
	}
	if (admDiagTypeId '= "")
	{
		s retDiagICDIDs = ..GetTypedDiagnosICDID(argAdmId, admDiagTypeId)
	}
	q:(retDiagICDIDs '= "") retDiagICDIDs
	
	q retDiagICDIDs
}

/// Desc:	取指定类型的诊断ID
ClassMethod GetTypedDiagnosICDID(argEpisodeID As %String, argMRCDiagnosTypeID As %String) As %String
{
	q:(argMRCDiagnosTypeID = "") ""
	
	s ret = ""
	
	s mrAdmDR = $p($g(^PAADM(argEpisodeID)),"^",61)
	q:(mrAdmDR = "") ""
	
	s mrcDiagnosTypeIDString = "^"_argMRCDiagnosTypeID_"^"
	
	s mrDiaChildsub = "0"
	for {
		s mrDiaChildsub = $o(^MR(mrAdmDR,"DIA",mrDiaChildsub))
		q:(mrDiaChildsub="")
		
		s typeChildSub = 0
		for {
			s typeChildSub = $o(^MR(mrAdmDR,"DIA",mrDiaChildsub,"TYP",typeChildSub))
			q:(typeChildSub = "")
			
			s mrcDiagTypID = $p($g(^MR(mrAdmDR,"DIA",mrDiaChildsub,"TYP",typeChildSub)),"^",1)
			continue:(mrcDiagTypID = "")
			
			//判断是否为待选诊断类型
			continue:('$f(mrcDiagnosTypeIDString, "^"_mrcDiagTypID_"^"))
			
			s icdID = $p($g(^MR(mrAdmDR,"DIA",mrDiaChildsub)),"^",1)
			continue:(icdID="")
			
			if ret = ""
			{	s ret = icdID}
			else
			{	s ret = ret_"^"_icdID}	
		}
	}
	
	q ret
}

ClassMethod HasCommonICD(AICDList1 As %String, AICDList2 As %String) As %Boolean
{
	s hasCommon = 0
	
	s count1 = $L(AICDList1,"^")
	s count2 = $L(AICDList2,"^")
	for i = 1:1:count1
	{
		s icd1 = $p(AICDList1,"^",i)
		
		for j = 1:1:count2
		{
			s icd2 = $p(AICDList2,"^",j)
			if (icd1 = icd2)
			{
				s hasCommon = 1
				q
			}
		}
		
		q:(hasCommon = 1)
	}
	
	q hasCommon
}

}
