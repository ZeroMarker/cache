Class EMRservice.BOKBDiagnos Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://localhost/trakcarelive/trak/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService. 
Parameter SERVICENAME = "KBDiagnos";

ClassMethod GetDiagnosByID(ARowID As %String) As EMRservice.entity.EKBDiagnos [ WebMethod ]
{
	s objDiagnos = ##Class(EMRmeta.KBDiagnos).%OpenId(ARowID)
	q:(objDiagnos = "") ""
	
	s Result = ##Class(EMRservice.entity.EKBDiagnos).%New()
	s Result.ID = objDiagnos.%Id()
	s Result.Name = objDiagnos.Name
	s Result.Description = objDiagnos.Description
	s Result.GroupName = objDiagnos.GroupName
	s Result.GroupDescription = objDiagnos.GroupDescription
	s Result.Diagnos = objDiagnos.Diagnos
	s Result.CTLocID = objDiagnos.CTLocID
	s Result.UserID = objDiagnos.UserID	
	s Result.CreateDate = $zd(objDiagnos.CreateDate,3)
	s Result.Status = objDiagnos.Status

	q Result
}

/// Debug: ##class(EMRservice.BOKBDiagnos).GetAllDiagnos()
ClassMethod GetAllDiagnos() As %XML.DataSet [ WebMethod ]
{
	s result = ##Class(%XML.DataSet).%New("EMRservice.BOKBDiagnos:SelectAllDiagnos")
	q result
}

ClassMethod AddKBDiagnos(AKBDiagnos As EMRservice.entity.EKBDiagnos) As %String [ WebMethod ]
{
	s ret = 1
	s objKBDiagnos = ##Class(EMRmeta.KBDiagnos).%New()
	s objKBDiagnos.Name = AKBDiagnos.Name
	s objKBDiagnos.Description = AKBDiagnos.Description
	s objKBDiagnos.GroupName = AKBDiagnos.GroupName
	s objKBDiagnos.GroupDescription = AKBDiagnos.GroupDescription
	s objKBDiagnos.Diagnos = AKBDiagnos.Diagnos
	s objKBDiagnos.CTLocID = AKBDiagnos.CTLocID
	s objKBDiagnos.UserID = AKBDiagnos.UserID
	s objKBDiagnos.CreateDate = $p($h,",",1)	
	s objKBDiagnos.Status = AKBDiagnos.Status
	if (objKBDiagnos.%Save())
	{
		 s ret=objKBDiagnos.%Id()
	}
	else
	{
		s ret=0
	}
	
	d objKBDiagnos.%Close()
	q ret
}

ClassMethod AddDiseaseRelation(DiseaseRelation As EMRservice.entity.EDiseaseRelation) As %String [ WebMethod ]
{
	s ret = 1
	s objDiseaseRelation = ##Class(EMRmeta.DiseaseRelation).%New()
	s objDiseaseRelation.CTLocID =DiseaseRelation.CTLocID
	s objDiseaseRelation.KBDiagnosID =DiseaseRelation.KBDiagnosID
	s objDiseaseRelation.ICDID =DiseaseRelation.ICDID
	s objDiseaseRelation.ICDCode =DiseaseRelation.ICDCode	
	s objDiseaseRelation.ICDName =DiseaseRelation.ICDName
	if (objDiseaseRelation.%Save())
	   {
		    s ret=objDiseaseRelation.%Id()
	   }
	   else
	   {
		   s ret=0
	    }		
	
	d objDiseaseRelation.%Close()
	q ret
}

ClassMethod CheckDiseaseRelationCode(CTLocID As %String, KBDiagnosID As %String, ICDCode As %String) As %String [ WebMethod ]
{
	
	s rowID = ""	
    s rowID = $o(^DHCEMRM.DiseaseRelationI("IdxDiagnosRelationCode",CTLocID,KBDiagnosID," "_$zcvt(ICDCode,"U"),rowID))
	q rowID
}

ClassMethod CheckKBDiagnos(CTLocID As %String, Code As %String) As %String [ WebMethod ]
{
	s rowID = ""
    s rowID = $o(^DHCEMRM.KBDiagnosI("IdxCTLocIDAndName",CTLocID," "_Code,rowID))
	q rowID
}

ClassMethod DelDiseaseRelation(AID As %String) As %Boolean [ WebMethod ]
{
	&SQL(DELETE FROM EMRmeta.DiseaseRelation WHERE ID=:AID)
	q SQLCODE
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
		s kbNodeDiagnosID = $o(^DHCEMRM.KBNodeDiagnosI("IdxKBDiagnosID",diagnosID,kbNodeDiagnosID))
		q:(kbNodeDiagnosID = "")
		
		s objKBNodeDiagnos = ##Class(EMRmeta.KBNodeDiagnos).%OpenId(kbNodeDiagnosID)
		if '(objKBNodeDiagnos.%DeleteId(kbNodeDiagnosID))
		{
			TROLLBACK
			s flag = 0
			q
		}
	}
	
	s objKBDiagnos = ##Class(EMRmeta.KBDiagnos).%OpenId(diagnosID)
	if '(objKBDiagnos.%DeleteId(diagnosID))
	{
		TROLLBACK
		s flag = 0
	}
	TCommit
	s ret = flag
	q ret
}

ClassMethod ModKBDiagnos(AKBDiagnos As EMRservice.entity.EKBDiagnos) As %Boolean [ WebMethod ]
{
	
	s ret = 1
	s objKBDiagnos = ##Class(EMRmeta.KBDiagnos).%OpenId(AKBDiagnos.ID)
	s objKBDiagnos.Name = AKBDiagnos.Name
	s objKBDiagnos.Description = AKBDiagnos.Description
	s objKBDiagnos.GroupName = AKBDiagnos.GroupName
	s objKBDiagnos.GroupDescription = AKBDiagnos.GroupDescription
	s objKBDiagnos.Diagnos = AKBDiagnos.Diagnos
	s objKBDiagnos.CTLocID = AKBDiagnos.CTLocID
	s objKBDiagnos.Status = AKBDiagnos.Status
	//s objKBDiagnos.UserID = AKBDiagnos.UserID
	//s objKBDiagnos.CreateDate = AKBDiagnos.CreateDate
	if '(objKBDiagnos.%Save())
	{		   
		s ret=0
	}	
	d objKBDiagnos.%Close()
	q ret
}

ClassMethod ModDiseaseRelation(DiseaseRelation As EMRservice.entity.EDiseaseRelation) As %Boolean [ WebMethod ]
{
	
	s ret = 1
	s objDiseaseRelation = ##Class(EMRmeta.DiseaseRelation).%OpenId(DiseaseRelation.ID)
	s objDiseaseRelation.CTLocID =DiseaseRelation.CTLocID
	s objDiseaseRelation.KBDiagnosID =DiseaseRelation.KBDiagnosID
	s objDiseaseRelation.ICDID =DiseaseRelation.ICDID
	s objDiseaseRelation.ICDCode =DiseaseRelation.ICDCode	
	s objDiseaseRelation.ICDName =DiseaseRelation.ICDName
	if '(objDiseaseRelation.%Save())
	{
        s ret=0
	}
	d objDiseaseRelation.%Close()	
	q ret
}

ClassMethod GetDiseaseRelationID(ACTLocID As %String, ADiagnosID As %String) As %String [ WebMethod ]
{
	s AID=""
	&sql(select ID into:AID from EMRmeta.DiseaseRelation where CTLocID=:ACTLocID and KBDiagnosID=:ADiagnosID)
	q AID
}

ClassMethod GetDiagnosByCtLocID(ACtLocID As %String) As EMRservice.dataset.EKBDiagnosByCtLocID [ WebMethod ]
{
	//s result = ##Class(%XML.DataSet).%New("EMRservice.BL.BLKBDiagnos:GetDiagnosByCtLocID")
	s result = ##Class(EMRservice.dataset.EKBDiagnosByCtLocID).%New()	
	d result.SetArgs(ACtLocID)
	q result
}

/// creator:	Kumon Xie
/// CreatDate:	2011-09-21
/// Description:供切换病人所在科室疾病类型的备选项使用
/// Table:		EMRmeta.KBDiagnos
/// Input:		AEpisodeID为患者就诊指针;
/// 			ACtLocID为登录科室RowID;
/// Output:		无
/// Return: 	病人所在科室的所有疾病类型JSON串
/// others: 	w ##Class(EMRservice.BOKBDiagnos).GetDiagnosJSONByCtLocID("201871","34")
ClassMethod GetDiagnosJSONByCtLocID(AEpisodeID As %String, ACtLocID As %String) As %String
{
	s ret = ""
	q:($g(AEpisodeID) = "")||($g(ACtLocID) = "") ret
	
	s isUsed = 0
	s usedKBDiagnosID = ##Class(EMRservice.BOInstanceData).GetKBDiagnosIDByEpisodeID(AEpisodeID)
	
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
		s diagnosName = $o(^DHCEMRM.KBDiagnosI("IdxCTLocIDAndName",ACtLocID, diagnosName))
		q:(diagnosName = "")
		s rowID = ""
		for {
			s rowID = $o(^DHCEMRM.KBDiagnosI("IdxCTLocIDAndName",ACtLocID,diagnosName,rowID))
			q:(rowID = "")
		
			s objKBDiagnos = $g(^DHCEMRM.KBDiagnosD(rowID))
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

/// Debug: 	w ##Class(EMRservice.BOKBDiagnos).ChecktDiagnosByCtLocID("201868","34")
ClassMethod ChecktDiagnosByCtLocID(AEpisodeID As %String, ACtLocID As %String)
{
	s rowID = ""
	s ret = 0
	for {
		//b "s"
		s rowID = $o(^DHCEMRM.KBDiagnosI("IdxCTLocID",ACtLocID,rowID))
		q:(rowID="")
		s objKBDiagnos = ##Class(EMRmeta.KBDiagnos).%OpenId(rowID)
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

/// Debug: 	w ##Class(EMRservice.BOKBDiagnos).GetCurrentDiagnosByCtLocID("201868","34")
ClassMethod GetCurrentDiagnosByCtLocID(AEpisodeID As %String, ACtLocID As %String)
{
	s usedKBDiagnosID = ##Class(EMRservice.BOInstanceData).GetKBDiagnosIDByEpisodeID(AEpisodeID)
	s isUsed = "0"
	s desc = ""
	s groupName = ""
	for {
		s groupName = $o(^DHCEMRM.KBDiagnosI("IdxCTLocIDAndGroupNameAndName", ACtLocID, groupName))
		q:(groupName="")
		s diagnosName = ""
		for {
			s diagnosName = $o(^DHCEMRM.KBDiagnosI("IdxCTLocIDAndGroupNameAndName", ACtLocID, groupName, diagnosName))
			q:(diagnosName = "")
			s rowID = ""
			for {	
				s rowID = $o(^DHCEMRM.KBDiagnosI("IdxCTLocIDAndGroupNameAndName", ACtLocID, groupName, diagnosName, rowID))
				q:(rowID="")
				if ((usedKBDiagnosID '= "")&&(rowID = usedKBDiagnosID))
				{
					s objKBDiagnos = ##Class(EMRmeta.KBDiagnos).%OpenId(rowID)
					s desc = objKBDiagnos.Description
					s isUsed = "1"	
					q
				}
			}
			q:(isUsed = "1")	
		}
		q:(isUsed = "1")
	}
	q desc
}

/// CreatDate:	2013-12-16
/// Description:供切换病人所在科室疾病类型的备选项使用(分组树)
/// Debug: 	w ##Class(EMRservice.BOKBDiagnos).GetDiagnosJSONTreeByCtLocID("201871","34","RT0")
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

/// debug: d ##class(EMRservice.BOKBDiagnos).GetCategoryJson("34")
ClassMethod GetCategoryJson(ACtLocID As %String, AEpisodeID As %String)
{
	s count = 0

	s usedKBDiagnosID = ##Class(EMRservice.BOInstanceData).GetKBDiagnosIDByEpisodeID(AEpisodeID)
	if ((+usedKBDiagnosID = 0) || (+usedKBDiagnosID = 1))
	{
		s count = count + 1
		w "{"
		w "id:'0'"
		w ",text:'不关联任何疾病'"
		w ",leaf:'true'"
		w ",cls:'leaf'"
		w "}"
	}
	
	//遍历根节点的第一层目录(Category类型)
	s groupName = ""
	
	for {
		s groupName = $o(^DHCEMRM.KBDiagnosI("IdxCTLocIDAndGroupNameAndName", ACtLocID, groupName))
		q:(groupName = "")

		s diagnosName = $o(^DHCEMRM.KBDiagnosI("IdxCTLocIDAndGroupNameAndName", ACtLocID, groupName,""))
			
		s rowID = $o(^DHCEMRM.KBDiagnosI("IdxCTLocIDAndGroupNameAndName", ACtLocID, groupName, diagnosName,""))
		s objKBDiagnos = ##Class(EMRmeta.KBDiagnos).%OpenId(rowID)
		s groupDescription = objKBDiagnos.GroupDescription
		s gName = objKBDiagnos.GroupName
		
		s count = count + 1
		
		if count>1 w ","
		w "{"
		w "id:'CG"_gName_"'"
		w ",text:'"_groupDescription_"'"
		w ",cls:'folder'"
		w "}"
	}
}

/// debug: d ##class(EMRservice.BOKBDiagnos).GetCateChapterJson("34","CGZZ")
ClassMethod GetCateChapterJson(ACtLocID As %String, AGroupName As %String)
{
	s groupName = $ZCVT($e(AGroupName,3,$l(AGroupName)),"U")
	s count = 0
	
	//遍历第二层节点(CategoryChapter)
	s diagnosName = ""
	for {
		s diagnosName = $o(^DHCEMRM.KBDiagnosI("IdxCTLocIDAndGroupNameAndName", ACtLocID, " "_groupName, diagnosName))
		q:(diagnosName="")
		s rowID = ""
		for {
			s rowID = $o(^DHCEMRM.KBDiagnosI("IdxCTLocIDAndGroupNameAndName", ACtLocID, " "_groupName, diagnosName,rowID))
			q:(rowID = "")
			s objKBDiagnos = ##Class(EMRmeta.KBDiagnos).%OpenId(rowID)
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
	SELECT ID,CTLocID,Description,Diagnos,Name From EMRmeta.KBDiagnos Order By ID
}

ClassMethod GetAllDiagnosByKBDiagnosID(KBDiagnosID As %String) As EMRservice.dataset.EDiagnos [ WebMethod ]
{
    s dataset = ##class(EMRservice.dataset.EDiagnos).%New()
	d dataset.SetArgs(KBDiagnosID)
	q dataset
}

ClassMethod Test()
{
    s obj = ##class(EMRservice.entity.EKBDiagnos).%New()
	s obj.CTLocID="106"
	s obj.Description="1"
	s obj.ID="91"
	s obj.Diagnos="aaa"
	s obj.GroupName="sdfsdaf"
	s obj.Name="sdfsdaf"
	s obj.GroupDescription="sdfsdaf"
	
	s objre = ##class(EMRservice.entity.EDiseaseRelation).%New()
	w ..ModKBDiagnos(obj,objre)
	q 1
}

}
