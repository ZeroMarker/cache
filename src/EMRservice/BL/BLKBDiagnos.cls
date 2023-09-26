Class EMRservice.BL.BLKBDiagnos Extends %RegisteredObject
{

/// creator:	Candy
/// CreatDate:	2014-01-16
/// Description:供切换病人所在科室疾病类型的备选项使用
/// Table:		EMRmeta.KBDiagnos
/// Input:		AEpisodeID为患者就诊指针;
/// 			ACtLocID为登录科室RowID;
/// Output:		无
/// Return: 	病人所在科室的所有疾病类型JSON串
/// others: 	w ##Class(EMRservice.BL.BLKBDiagnos).GetDiagnosJSONByCtLocID("43","6")
ClassMethod GetDiagnosJSONByCtLocID(AEpisodeID As %String, ACtLocID As %String) As %String
{
	s ret = ""
	q:($g(AEpisodeID) = "")||($g(ACtLocID) = "") ret
	
	//取患者当前就诊的诊断ICDCode，用于判断是否与已维护的某个病种相关联，若是则前台自动选中该病种；
	s mainDiagnosICDCode = ""
	s mainDiagnos = ##class(EMRservice.HISInterface.PatientInfoAssist).DiagnosInfo(AEpisodeID)
	if (mainDiagnos = "")
    {
        s mainDiagnos = ..getOPdiagnosis(AEpisodeID)
    }
	if (mainDiagnos '= "")
	{	
		s mainDiagnosICDCode = $P(mainDiagnos,"^",2)
	}
	
	s json = ""
	s hasUsed = 0
	s usedKBDiagnosID = ##Class(EMRservice.BL.BLKBDiagnos).GetKBDiagnosIDByEpisodeID(AEpisodeID)
	
	s GroupName = ""
	for {
		s GroupName = $o(^DHCEMRM.KBDiagnosI("IdxCTLocIDAndGroupNameAndName",ACtLocID,GroupName))
		//分组代码为空则不显示
		continue:(GroupName=" ")||(GroupName=(" "_$c(0)))
		q:(GroupName = "")
		//取分组名称，用于页面显示
		s GroupDesc = ""
		s Name = ""
		for {
			s Name = $o(^DHCEMRM.KBDiagnosI("IdxCTLocIDAndGroupNameAndName",ACtLocID,GroupName,Name))
			q:(Name = "")
			
			s rowID = $o(^DHCEMRM.KBDiagnosI("IdxCTLocIDAndGroupNameAndName",ACtLocID,GroupName,Name,""))
			//s objKBDiagnos = $g(^DHCEMRM.KBDiagnosD(rowID))
			
			s objKBDiagnos = ##Class(EMRmeta.KBDiagnos).%OpenId(rowID)
			continue:(objKBDiagnos = "")
	
			s GroupDesc = objKBDiagnos.GroupDescription
			continue:(GroupDesc=" ")||(GroupDesc=($c(0)))
			q
		}
		s viewGroupName = "group"_$e(GroupName,2,$l(GroupName))   //区分病种id和分组id相同的情况,分组id前加“group”
		if (GroupDesc = "")||(GroupDesc = $c(0))
		{
			s GroupDesc = "未维护分组描述"
		}
		//s json = json_",{'id':'"_viewGroupName_"','text':'"_GroupDesc_"','state':'closed',children:["     //此种方法，前台对应JQuery的combotree控件
		s json = json_",{""id"":"""_viewGroupName_""",""name"":"""_GroupDesc_""",""children"":["                      //此种方法，前台对应JQuery的zTree控件
		//取每个分组的病种
		s ChildName = ""
		for {
			s ChildName = $o(^DHCEMRM.KBDiagnosI("IdxCTLocIDAndGroupNameAndName",ACtLocID,GroupName,ChildName))
			q:(ChildName = "")
			
			s rowID = ""
			for {
				s rowID = $o(^DHCEMRM.KBDiagnosI("IdxCTLocIDAndGroupNameAndName",ACtLocID,GroupName,ChildName,rowID))
				q:(rowID = "")
				//s objKBDiagnos = $g(^DHCEMRM.KBDiagnosD(rowID))
				s objKBDiagnos = ##Class(EMRmeta.KBDiagnos).%OpenId(rowID)
				continue:(objKBDiagnos = "")
				
				s name = objKBDiagnos.Name
				s desc = objKBDiagnos.Description
				s isUsed = $s((usedKBDiagnosID '= "")&&(rowID = usedKBDiagnosID):1,1:0)
				
				// 根据就诊诊断判断与病种是否关联
				if (isUsed = 0)&&(mainDiagnosICDCode '= "")
				{
					s isUsed = ..getDiseaseRelation(mainDiagnosICDCode,rowID)
				}
				if (isUsed = 1)
				{
					s hasUsed = 1
				}
				
				s json = json_"{""id"":"""_name_""",""name"":"""_desc_""",""attributes"":{""isUsed"":"""_isUsed_""",""rowID"":"""_rowID_"""}},"
			}
		}
		s json = $e(json,1,$l(json)-1)
		s json = json_"]}"
	}
	s json = $s(+hasUsed = 0:"[{""id"":""0"",""name"":""不关联任何疾病"",""attributes"":{""isUsed"":""1"",""rowID"":""0""}}"_json,1:"[{""id"":""0"",""name"":""不关联任何疾病"",""attributes"":{""isUsed"":""0"",""rowID"":""0""}}"_json)
	s json = $tr(json,$c(10),"")
	s json = $tr(json,$c(13),"")
	s json = json_"]"
	q json
}

/// creator:	niucaicai
/// CreatDate:	2015-11-11
/// Description:判断病种关联的疾病是否包含患者诊断
/// Table:		EMRmeta.KBDiagnos、EMRmeta.DiseaseRelation
/// Input:		mainDiagnosICDCode为患者就诊诊断的ICDCode;ArowID为病种ID
/// Return: 	1：病种关联的疾病包含患者诊断；0：病种关联的疾病不包含患者诊断
/// others: 	w ##Class(EMRservice.BL.BLKBDiagnos).getDiseaseRelation("S93.431","7")
ClassMethod getDiseaseRelation(AmainDiagnosICDCode As %String, ArowID As %String) As %String
{
	s ret = 0
	q:($g(AmainDiagnosICDCode) = "")||($g(ArowID) = "") ret
	
	s KBDiagnosID = ArowID
	s DiseaseRelationRowID = ""
	for {
		s DiseaseRelationRowID = $O(^DHCEMRM.DiseaseRelationI("IdxKBDiagnosID",KBDiagnosID,DiseaseRelationRowID))
		q:(DiseaseRelationRowID = "")
		
		s DiseaseRelationObj = ##Class(EMRmeta.DiseaseRelation).%OpenId(DiseaseRelationRowID)
		s ICDID = DiseaseRelationObj.ICDID
		s ICDCode = DiseaseRelationObj.ICDCode
		s ICDName = DiseaseRelationObj.ICDName
		d DiseaseRelationObj.%Close()
		
		continue:(AmainDiagnosICDCode '= ICDCode)
		s ret = 1
	}
	q ret
}

/// 取门诊诊断信息
ClassMethod getOPdiagnosis(argAdmId As %String) As %String
{
	q:(argAdmId="") ""
	
	s retDiagnos = ""
	s diagnosID = ""
	
	//门诊诊断
	s disDiagTypeID = $O(^MRC("DTYP",0,"Code","OP",""))  
	if (disDiagTypeID '= "")
	{
		s diagIDs = ..GetTypedDiagnosID(argAdmId, disDiagTypeID)
		if diagIDs '= ""
		{
			s diagnosID = $P(diagIDs, "^", 1)
			s retDiagnos = ..GetDiagnosWithNote(diagnosID)
		}
	}
	q:(retDiagnos '= "") retDiagnos
	q retDiagnos
}

/// Desc:	取指定类型的诊断ID
ClassMethod GetTypedDiagnosID(argEpisodeID As %String, argMRCDiagnosTypeID As %String) As %String
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
			
			s mrDiagnosID = mrAdmDR_"||"_mrDiaChildsub
			if ret = ""
			{	s ret = mrDiagnosID}
			else
			{	s ret = ret_"^"_mrDiagnosID}	
		}
	}
	q ret
}

/// 	Desc:	取诊断信息
/// 	Input:	argMRDiagnosID : MR_Adm.MRADM_RowId||MR_Diagnos.MRDIA_Childsub
/// 	Return：RowId^诊断代码^诊断描述(诊断备注)
ClassMethod GetDiagnosWithNote(argMRDiagnosID) As %String
{
	s mrAdmID = $P(argMRDiagnosID, "||", 1)
	s mrDiaChildSub = $P(argMRDiagnosID, "||", 2)
	q:(mrAdmID = "")||(mrDiaChildSub = "") ""
	
	s icdid = $p($g(^MR(mrAdmID,"DIA",mrDiaChildSub)),"^",1)
	q:(icdid = "") ""
	
	s icdCode = $p($g(^MRC("ID",icdid)),"^",4)
	s icdDesc = $p($g(^MRC("ID",icdid)),"^",2)
	
	s diagNote=$g(^MR(mrAdmID,"DIA",mrDiaChildSub,"DES",1))
	//s diagNote=$g(^MR(mrAdmID,"DIA",mrDiaChildSub,"DES"))
	if (diagNote '= "") 
	{	s icdDesc = icdDesc_"("_diagNote_")"}	
	
	q icdid_"^"_icdCode_"^"_icdDesc
}

/// creator:	Candy
/// CreatDate:	2014-01-16
/// Description:取患者所关联疾病
/// Table:		EMRmeta.KBDiagnos
/// Input:		AEpisodeID为患者就诊指针;
/// Output:		无
/// Return: 	病人所在科室的所有疾病类型JSON串
/// others: 	w ##Class(EMRservice.BL.BLKBDiagnos).GetKBDiagnosIDByEpisodeID("76")
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

/// Debug:	d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLKBDiagnos","GetDiagnosByCtLocID",34)
Query GetDiagnosByCtLocID(ACtLocID As %String) As %Query(ROWSPEC = "ID,Name,Description,GroupName,GroupDescription,Diagnos,UserID,UserName,UserCreateDate,Status")
{
}

ClassMethod GetDiagnosByCtLocIDExecute(ByRef qHandle As %Binary, ACtLocID As %String) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	s Name = ""
	
	q:($g(ACtLocID) = "") $$$OK
	
	for {
		s Name = $o(^DHCEMRM.KBDiagnosI("IdxCTLocIDAndName",$g(ACtLocID),$zcvt(Name,"U")))
		q:(Name = "")
		s rowID = ""
		for {
			s rowID = $o(^DHCEMRM.KBDiagnosI("IdxCTLocIDAndName",$g(ACtLocID),$zcvt(Name,"U"),rowID))
			q:(rowID = "")
			s objKBDiagnos = ##Class(EMRmeta.KBDiagnos).%OpenId(rowID)
			continue:(objKBDiagnos = "")
		
			s name = objKBDiagnos.Name
			s desc = objKBDiagnos.Description
			s groupName = objKBDiagnos.GroupName
			s groupDescription = objKBDiagnos.GroupDescription
			s diagnos = objKBDiagnos.Diagnos
			s userID = objKBDiagnos.UserID
			s userName = $s(userID '= "":$p($g(^SSU("SSUSR",+userID)),"^",2),1:"")
			s createDate = $s(objKBDiagnos.CreateDate '= "":$zd(objKBDiagnos.CreateDate,3),1:"")
			s status = objKBDiagnos.Status
			s:((status="") || (status="0")) status="正常"
			s:(status="1") status="停用"
		
			s Data = $lb(rowID,name,desc,groupName,groupDescription,diagnos,userID,userName,createDate,status)
			s ^CacheTemp(repid,ind) = Data
			s ind = ind + 1	
		}
	}
	
	q $$$OK
}

ClassMethod GetDiagnosByCtLocIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDiagnosByCtLocIDExecute ]
{
	s AtEnd=$list(qHandle,1)
 	s repid=$list(qHandle,2)
 	s ind=$list(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	if ind="" {	
 		s AtEnd=1
 		s Row=""
 		k ^CacheTemp(repid)
 	} else {
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetDiagnosByCtLocIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDiagnosByCtLocIDExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// Debug:	d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLKBDiagnos","GetAllDiagnosByKBDiagnosID","117")
Query GetAllDiagnosByKBDiagnosID(KBDiagnosID As %String) As %Query(ROWSPEC = "ID,ICDID,ICDCode,ICDName")
{
}

ClassMethod GetAllDiagnosByKBDiagnosIDExecute(ByRef qHandle As %Binary, KBDiagnosID As %String) As %Status
{
	
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)

	//开始查询
	s rowid = 0
	for {
		s rowid=$o(^DHCEMRM.DiseaseRelationI("IdxKBDiagnosID",KBDiagnosID,rowid))
		quit:(rowid = "")			
			
		s objDiseaseRel = ##Class(EMRmeta.DiseaseRelation).%OpenId(rowid)
		s ICDID=objDiseaseRel.ICDID
		s ICDCode=objDiseaseRel.ICDCode
		s ICDName=objDiseaseRel.ICDName
		
		s Data = $LB(rowid,ICDID,ICDCode,ICDName)
		s ^CacheTemp(repid,ind) = Data
		s ind = ind + 1			
	}		
	
	q $$$OK
}

ClassMethod GetAllDiagnosByKBDiagnosIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllDiagnosByKBDiagnosIDExecute ]
{
	s AtEnd=$list(qHandle,1)
 	s repid=$list(qHandle,2)
 	s ind=$list(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	if ind="" {	
 		s AtEnd=1
 		s Row=""
 		k ^CacheTemp(repid)
 	} else {
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetAllDiagnosByKBDiagnosIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllDiagnosByKBDiagnosIDExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

}
