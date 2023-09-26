Class DHCCL.BLL.Admission Extends %RegisteredObject
{

/// Creator：      	ypz
/// CreatDate：    	2010-03-12
/// Description： 	查找病区病人:有wardId直接找病人,无则根据ctlocId则找病人:是病区直接找病人,是科室找关联病区的病人
/// Table：        	PA_Adm,PA_Patmas,PAC_Ward,PAC_Bed
/// Input：        	wardId病区ID,ctlocId医生/护士科室ID
/// Output：       
/// Return：       	返回以"^"分割的病人信息串，病人信息:就诊号EpisodeID_"|"_床位bedCode_"|"_病人姓名patName
ClassMethod FindWardPatient(wardId As %String = "1:2", ctlocId As %String = "") As %String
{
	s retStr=""
	q:(wardId="")&(ctlocId="") retStr
	
	s wardIdList=wardId
	i wardId="" d
	    .s ctlocType=$p($g(^CTLOC(ctlocId)),"^",13)
		.i ctlocType="W" d
			..s wardIdList=$o(^PAWARD(0,"WARD_LocationDR",ctlocId,0))
		.e  d
			..i ctlocType="E" d  
			..s linksub=0
			..f  s linksub=$o(^CTLOC(ctlocId,"LINK",linksub)) q:linksub=""  d
				...s linkCtlocId=$p($g(^CTLOC(ctlocId,"LINK",linksub)),"^",1)
				...i linkCtlocId'="" d
					....s linkCtlocType=$p($g(^CTLOC(linkCtlocId)),"^",13)
					....i linkCtlocType="W" d 
						.....i wardIdList'="" s wardIdList=wardIdList_"^"
						.....s wardIdList=wardIdList_$o(^PAWARD(0,"WARD_LocationDR",linkCtlocId,0))
	q:wardIdList="" retStr
	
	f i=1:1:$l(wardIdList,"^") d
	    .s wardId=$p(wardIdList,"^",i)
	    .i ctlocId="" s ctlocId=$p(^PAWARD(+wardId),"^",5)
	    .s roomId=0
	    .f  s roomId=$o(^PAADMi("CurrWard",wardId,roomId)) q:roomId=""  d
    		..s EpisodeID=0
    		..f  s EpisodeID=$o(^PAADMi("CurrWard",wardId,roomId,EpisodeID)) q:EpisodeID=""  d
        		...q:'$d(^PAADM(EpisodeID))
        		...s paadmVisitStatus=$p($g(^PAADM(EpisodeID)),"^",20)
        		...i paadmVisitStatus'="A" q
        		...s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
        		...s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
       			...s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
        		...//s sex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
        		...s bedId=$p($g(^PAADM(EpisodeID)),"^",73)
        		...s bedSub=$p(bedId,"||",2)
        		...q:bedSub=""
        		...s bedTypeId=$p($g(^PAWARD(+bedId,"BED",+bedSub)),"^",2)
        		...s bedCode=$p($g(^PAWARD(wardId,"BED",bedSub)),"^",1)
        		...q:bedCode="" ;防止床位码表被删
        		...i retStr'="" s retStr=retStr_"^"
        		...s retStr=retStr_EpisodeID_"|"_bedCode_"|"_patName_"|" //用床位号好找
    q retStr
}

/// Creator：      	陈长青
/// CreatDate：    	2017-2-27
/// Description： 	查询病人诊断信息
/// Table：        	MR_Diagnos,MR_DiagType
/// Input:			EpisodeID:病人就诊ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("DHCAN.BLL.Admission","FindAdmDiagnosis","1372763","C008")
Query FindAdmDiagnosis(EpisodeID As %String, diagType As %String) As %Query(ROWSPEC = "RowId,ICDCode,ICDCodeDesc,DiagnosisType,DiagnosisTypeCode,DiagnosisTypeDesc,DiagnosNote") [ SqlProc ]
{
}

ClassMethod FindAdmDiagnosisExecute(ByRef qHandle As %Binary, EpisodeID As %String, diagType As %String) As %Status
{
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	
	set MRAdmID=$piece(^PAADM(EpisodeID),"^",61)
	set admDiagnosID=0
	for
	{
		set admDiagnosID=$order(^MR(MRAdmID,"DIA",admDiagnosID))
		quit:(admDiagnosID="")
		set admDiagnos=^MR(MRAdmID,"DIA",admDiagnosID)
		set ICDID=$piece(admDiagnos,"^",1)
		set ICDDesc=$piece($get(^MRC("ID",+ICDID)),"^",2)
		set admDiagTypeID=0,diagTypeCode="",diagTypeDesc=""
		set MRDiagnosID=MRAdmID_"||"_admDiagnosID
		set MRDiagnos=##class(User.MRDiagnos).%OpenId(MRDiagnosID)
		set diagnosNote=""
		for i=1:1:MRDiagnos.MRDIADesc.Count()
		{
			if (diagnosNote'="")
			{
				set diagnosNote=diagnosNote_","	
			}	
			set diagnosNote=diagnosNote_MRDiagnos.MRDIADesc.GetAt(i)
		}
		if (diagnosNote'="")
		{
			set ICDDesc=ICDDesc_"("_diagnosNote_")"	
		}
		for
		{
			set admDiagTypeID=$order(^MR(MRAdmID,"DIA",admDiagnosID,"TYP",admDiagTypeID))
			quit:(admDiagTypeID="")
			set diagTypeID=$piece(^MR(MRAdmID,"DIA",admDiagnosID,"TYP",admDiagTypeID),"^",1)
			set diagTypeCode=$piece($get(^MRC("DTYP",+diagTypeID)),"^",1)
			set diagTypeDesc=$piece($get(^MRC("DTYP",+diagTypeID)),"^",2)
			continue:("^"_diagType_"^")'[(diagTypeCode)
			do OutputRow	
		}	
	}
	
	s qHandle=$lb(0,repid,0)
	q $$$OK

OutputRow
	s Data=$lb(MRDiagnosID,ICDID,ICDDesc,MRDiagnosID_"||"_admDiagTypeID,diagTypeCode,diagTypeDesc,diagnosNote)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod FindAdmDiagnosisFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAdmDiagnosisExecute ]
{
	s AtEnd=$li(qHandle,1)
	s repid=$li(qHandle,2)
	s ind=$li(qHandle,3)
	//
	s ind=$o(^CacheTemp(repid,ind))
	i ind="" {				// if there are no more rows, finish fetching
	s AtEnd=1
	s Row=""
	}
	else      {				// fetch row
	s Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindAdmDiagnosisClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAdmDiagnosisExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

/// Creator：      	陈长青
/// CreatDate：    	2017-2-28
/// Description： 	查询诊断字典
/// Table：        	MRC_ICDx
/// Input:			EpisodeID:病人就诊ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("DHCAN.BLL.Admission","FindMRCDiagnosis","ab")
Query FindMRCDiagnosis(filterDesc As %String) As %Query(ROWSPEC = "RowId,Description,ICDCode,ICDDesc") [ SqlProc ]
{
}

ClassMethod FindMRCDiagnosisExecute(ByRef qHandle As %Binary, filterDesc As %String) As %Status
{
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	
	// 筛选字符串不能为空
	if ($length($get(filterDesc))<1)
	{
		s qHandle=$lb(0,repid,0)
		q $$$OK	
	}
	
	set filterDesc=$System.SQL.ALPHAUP(filterDesc) //$$ALPHAUP^SSUTIL4(filterDesc)
	set diagId=0,today=+$h
	for
	{
		set diagId=$order(^MRC("ID",diagId))
		quit:(diagId="")
		set ifFind=0
		set diagDesc=$piece(^MRC("ID",diagId),"^",2)
		
		// 判断诊断是否激活，未激活诊断将过滤掉
		set activeFrom=$piece(^MRC("ID",diagId),"^",6)
		set activeTo=$piece(^MRC("ID",diagId),"^",7)
		continue:(today<activeFrom)
		continue:(+activeTo>0)&(today>activeTo)
		set ICDCode=$piece(^MRC("ID",diagId),"^",4)
		set ICDDesc=diagDesc
		;set:(ICDCode'="") ICDDesc="["_ICDCode_"]"_ICDDesc	
		set:(diagDesc [ filterDesc) ifFind=1
		do:(ifFind) OutputRow
		continue:(ifFind)
		
		// 判断诊断别名中是否有包含筛选字符串的别名，如果有则输出该诊断。
		set aliasSub=0
		for
		{
			set aliasSub=$order(^MRC("ID",diagId,"ALIAS",aliasSub))
			quit:(aliasSub="")
			set aliasText=$piece(^MRC("ID",diagId,"ALIAS",aliasSub),"^",1)
			set:(aliasText [ filterDesc) ifFind=1
			do:(ifFind) OutputRow
			quit:(ifFind)	
		}
	}
	
	s qHandle=$lb(0,repid,0)
	q $$$OK	
OutputRow
	s Data=$lb(diagId,diagDesc,ICDCode,ICDDesc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod FindMRCDiagnosisFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindMRCDiagnosisExecute ]
{
	s AtEnd=$li(qHandle,1)
	s repid=$li(qHandle,2)
	s ind=$li(qHandle,3)
	//
	s ind=$o(^CacheTemp(repid,ind))
	i ind="" {				// if there are no more rows, finish fetching
	s AtEnd=1
	s Row=""
	}
	else      {				// fetch row
	s Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindMRCDiagnosisClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindMRCDiagnosisExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

/// Creator：      	陈长青
/// CreatDate：    	2016-12-29
/// Description： 	查询安全组
/// Table：        	SS_Group
/// Input:			filterDesc:安全组名称筛选字符串
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("DHCCL.BLL.Admission","FindGroup","demo")
Query FindGroup(filterDesc As %String) As %Query(ROWSPEC = "RowId,Description") [ SqlProc ]
{
}

ClassMethod FindGroupExecute(ByRef qHandle As %Binary, filterDesc As %String) As %Status
{
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	
	set groupId=0
	for
	{
		set groupId=$order(^SSU("SSGRP",groupId))
		quit:(groupId="")
		set groupDesc=$piece(^SSU("SSGRP",groupId),"^",1)
		continue:(filterDesc'="")&($System.SQL.ALPHAUP(groupDesc) '[ $System.SQL.ALPHAUP(filterDesc))
		do OutputRow	
	}
	
	s qHandle=$lb(0,repid,0)
	q $$$OK	
OutputRow
	s Data=$lb(groupId,groupDesc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod FindGroupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindGroupExecute ]
{
	s AtEnd=$li(qHandle,1)
	s repid=$li(qHandle,2)
	s ind=$li(qHandle,3)
	//
	s ind=$o(^CacheTemp(repid,ind))
	i ind="" {				// if there are no more rows, finish fetching
	s AtEnd=1
	s Row=""
	}
	else      {				// fetch row
	s Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindGroupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindGroupExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

ClassMethod GetMedicareNo(papmiId, EpisodeID) As %String [ SqlProc ]
{
	q:(papmiId="")&(EpisodeID="") ""
	i papmiId="" s papmiId=+$g(^PAADM(+EpisodeID))
	q:papmiId="" ""
	s medicareNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)
	s tmpMedicareNo=##Class(web.DHCWMRService).IGetMrNoByEpisodeID(EpisodeID) //2010用
	set:(+tmpMedicareNo>0) medicareNo=tmpMedicareNo //2010用
	q medicareNo
}

// w ##class(web.DHCClinicCom).GetPatLevelByPapmiId(9)

ClassMethod GetPatLevelByPapmiId(AdmRowId) As %String [ SqlProc ]
{
	s PAPMIRowId=+$g(^PAADM(+AdmRowId))
	q:PAPMIRowId="" ""
	s ret=""
	s flag=1	;控制是否带入密级
	i flag=1
	{
		//s ret=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(PAPMIRowId,.ErrMsg)
	}
	else
	{
		s ret=""
	}
	q ret
}

/// Creator：      	陈长青
/// CreatDate：    	2017-1-3
/// Description： 	查询病人
/// Table：        	PA_PatMas,PA_Adm
/// Input:			EpisodeID：病人就诊RowId
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("DHCCL.BLL.Admission","FindPatient","497")
Query FindPatient(EpisodeID As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT PAADM_RowID As EpisodeID,
	   PAADM_PAPMI_DR As PatientID,
	   PAADM_PAPMI_DR->PAPMI_Name As PatName,
	   PAADM_PAPMI_DR->PAPMI_IPNo As RegNo,
	   PAADM_PAPMI_DR->PAPMI_Medicare As MedcareNo,
	   %ODBCOUT(PAADM_PAPMI_DR->PAPMI_DOB) As PatDOB,
	   DHCCL_BLL.DateTime_CalAge(PAADM_PAPMI_DR->PAPMI_DOB,+$h) As PatAge,
	   PAADM_PAPMI_DR->PAPMI_Sex_DR->CTSEX_Desc As PatGender,
	   DHCCL_BLL.DateTime_ConvertToDateTime(PAADM_AdmDate,PAADM_AdmTime,'') As AdmDT,
	   PAADM_Type As AdmType,
	   %EXTERNAL(PAADM_Type) As AdmTypeDesc,
	   DHCCL_BLL.DateTime_ConvertToDateTime(PAADM_DischgDate,PAADM_DischgTime,'') As DischargeDT,
	   PAADM_VisitStatus As VisitStatus,
	   PAADM_AdmReason_DR As AdmReasonID,
	   PAADM_AdmReason_DR->REA_Desc As AdmReason,
	   PAADM_DepCode_DR As PatDeptID,
	   DHCCL_BLL.String_GetDescBySplitChar(PAADM_DepCode_DR->CTLOC_Desc,'-',2) As PatDept,
	   PAADM_CurrentWard_DR As PatWardID,
	   DHCCL_BLL.String_GetDescBySplitChar(PAADM_CurrentWard_DR->WARD_Desc,'-',2) As PatWard,
	   PAADM_CurrentBed_DR As PatBedID,
	   PAADM_CurrentBed_DR->BED_Code As PatBed,
	   DHCCL_BLL.String_GetDescBySplitChar(DHCCL_BLL.Admission_GetPatLevelByPapmiId(%ID),'^',2) As PatSecretLevel,
	   DHCCL_BLL.String_GetDescBySplitChar(DHCCL_BLL.Admission_GetPatLevelByPapmiId(%ID),'^',4) As PatSecretCode,
	   PAADM_MainMRADM_DR As MRAdmID
	   From SQLUser.PA_Adm
	   where (PAADM_RowID=:EpisodeID)
}

/// Creator：      	陈长青
/// CreatDate：    	2017-1-4
/// Description： 	查询科室
/// Table：        	CT_LocationList_Locations
/// Input:			filterDesc:筛选字符串,locList:科室列表代码
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("DHCCL.BLL.Admission","FindLocationOld","")
Query FindLocationOld(filterDesc As %String, locList As %String = "OP^EMOP^OUTOP") As %SQLQuery(CONTAINID = 1)
{
SELECT distinct LOC_CTLOC_DR As RowId,
	   LOC_CTLOC_DR->CTLOC_Code As Code,
	   LOC_CTLOC_DR->CTLOC_Desc As Description,
	   LOC_CTLOC_DR->CTLOC_Hospital_DR As HospID,
	   LOC_CTLOC_DR->CTLOC_Hospital_DR->HOSP_Desc As HospDesc
	   from SQLUser.CT_LocationList_Locations
	   where ((UPPER(LOC_CTLOC_DR->CTLOC_Desc) like UPPER('%'_:filterDesc_'%')) or (:filterDesc is null))
	   and ((UPPER('^'_:locList_'^') [ UPPER('^'||LOC_ParRef->LL_Code||'^')) or :locList is null)
}

/// Creator：      	陈长青
/// CreatDate：    	2017-1-4
/// Description： 	查询科室
/// Table：        	CT_LocationList_Locations
/// Input:			filterDesc:筛选字符串,locList:科室列表代码
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("DHCCL.BLL.Admission","FindLocationOld","")
Query FindLocationList(filterDesc As %String, locList As %String = "OP^EMOP^OUTOP") As %SQLQuery(CONTAINID = 1)
{
SELECT distinct LOC_CTLOC_DR As RowId,
	   LOC_CTLOC_DR->CTLOC_Code As Code,
	   LOC_CTLOC_DR->CTLOC_Desc As Description,
	   LOC_CTLOC_DR->CTLOC_Hospital_DR As HospID,
	   LOC_CTLOC_DR->CTLOC_Hospital_DR->HOSP_Desc As HospDesc
	   from SQLUser.CT_LocationList_Locations
	   where ((UPPER(LOC_CTLOC_DR->CTLOC_Desc) like UPPER('%'_:filterDesc_'%')) or (:filterDesc is null))
	   and (not LOC_CTLOC_DR->CTLOC_Code is null)
	   and (LOC_CTLOC_DR->CTLOC_Code<>'')
	   and (not LOC_CTLOC_DR->CTLOC_Desc is null)
	   and (LOC_CTLOC_DR->CTLOC_Desc<>'')
}

/// Creator：      	雍阳
/// CreatDate：    	2018-9-26
/// Description： 	查询科室
/// Table：        	DHCCL_Config.Location
/// Input:			filterDesc:筛选字符串,locList:科室列表代码
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("DHCCL.BLL.Admission","FindLocation","","AN^OP")
Query FindLocation(filterDesc As %String, locList As %String = "E^O") As %SQLQuery(CONTAINID = 1)
{
SELECT %Id As RowId,
	   CTLOC_Code As Code,
	   CTLOC_Desc As Description,
	   CTLOC_ActiveFlag As Active,
	   CTLOC_Type As LocType,
	   CTLOC_ContactName As Alias
	   from SQLUser.CT_LOC
	   where ((UPPER(CTLOC_Desc) like UPPER('%'_:filterDesc_'%')) or (:filterDesc is null))
	   and (UPPER('^'_:locList_'^') [ UPPER('^'||CTLOC_Type||'^'))
}

/// Creator：      	雍阳
/// CreatDate：    	2018-9-26
/// Description： 	查询科室
/// Table：        	DHCCL_Config.Location
/// Input:			filterDesc:筛选字符串,locList:科室列表代码
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("DHCCL.BLL.Admission","FindLocation","","AN^OP")
Query FindLocationCL(filterDesc As %String, locList As %String = "E") As %SQLQuery(CONTAINID = 1)
{
SELECT *
	   from DHCCL_Config.Location
	   where ((UPPER(Description) like UPPER('%'_:filterDesc_'%')) or (:filterDesc is null))
	   and (UPPER('^'_:locList_'^') [ UPPER('^'||LocType||'^'))
}

/// Creator：      	陈长青
/// CreatDate：    	2017-1-6
/// Description： 	查询ICD诊断字典
/// Table：        	MRC_ICDDx,MRC_ICDAlias
/// Input:			filterDesc:筛选字符串
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("DHCAN.Admission","FindICDDiagnosis","ab")
Query FindICDDiagnosis(filterDesc As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT distinct MRCID_RowId As RowId,
	   MRCID_Code As Code,
	   MRCID_Desc As Description
	   From SQLUser.MRC_ICDDx As Diag inner join SQLUser.MRC_ICDAlias As Alias on Diag.MRCID_RowId=Alias.ALIAS_ParRef
	   where ((Diag.MRCID_Desc like UPPER('%'_:filterDesc_'%')) or (Alias.ALIAS_Text like UPPER('%'_:filterDesc_'%')))
}

/// Creator：      	陈长青
/// CreatDate：    	2017-1-6
/// Description： 	根据科室ID查询科室医护人员
/// Table：        	RB_Resource
/// Input:			filterDesc:筛选字符串,locId:科室ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("DHCAN.Admission","FindCareProvByLoc","","5")
Query FindCareProv(filterDesc As %String, locId As %String = "") As %SQLQuery(CONTAINID = 1)
{
SELECT %ID As ResourceID,
	   RES_CTLOC_DR As LocationID,
	   RES_CTLOC_DR->CTLOC_Desc As Location,
	   RES_CTPCP_DR As RowId,
	   RES_CTPCP_DR->CTPCP_Desc As Description,
	   ((RES_CTPCP_DR->CTPCP_Desc)_'('_(RES_CTLOC_DR->CTLOC_Desc)_')') As ProvLoc,
	   RES_CTPCP_DR->CTPCP_OtherName As ShortDesc,
	   DHCCL_BLL.Admission_GetUserIDByCareProv(RES_CTPCP_DR) As UserId
	   From SQLUser.RB_Resource
	   where ((RES_CTLOC_DR=:locId) or (:locId is null))
	   and (RES_CTPCP_DR->CTPCP_ActiveFlag='Y')
	   and ((RES_CTPCP_DR->CTPCP_Desc like (:filterDesc_"%")) or (RES_CTPCP_DR->CTPCP_OtherName like (UPPER(:filterDesc)_'%')))
	   order by ShortDesc
}

/// Creator：      	陈长青
/// CreatDate：    	2017-1-6
/// Description： 	根据科室ID查询科室医护人员
/// Table：        	RB_Resource
/// Input:			filterDesc:筛选字符串,locId:科室ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("DHCCL.BLL.Admission","FindCareProvByLoc","a","29")
Query FindCareProvByLoc(filterDesc As %String, locId As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT %ID As ResourceID,
	   RES_CTLOC_DR As LocationID,
	   RES_CTLOC_DR->CTLOC_Desc As Location,
	   RES_CTPCP_DR As RowId,
	   RES_CTPCP_DR->CTPCP_Desc As Description,
	   RES_CTPCP_DR->CTPCP_OtherName As ShortDesc,
	   $EXTRACT(RES_CTPCP_DR->CTPCP_OtherName,1) As FirstChar,
	   DHCCL_BLL.Admission_GetUserIDByCareProv(RES_CTPCP_DR) As UserId
	   From SQLUser.RB_Resource
	   where (RES_CTLOC_DR=:locId)
	   and (RES_CTPCP_DR->CTPCP_ActiveFlag='Y')
	   and ((RES_CTPCP_DR->CTPCP_Desc [ UPPER(:filterDesc)) or (RES_CTPCP_DR->CTPCP_OtherName like (UPPER(:filterDesc)_'%')) or (:filterDesc is null))
	   order by ShortDesc
}

/// Creator：      	陈长青
/// CreatDate：    	2017-1-6
/// Description： 	根据科室ID查询科室医护人员
/// Table：        	RB_Resource
/// Input:			filterDesc:筛选字符串,locId:科室ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("DHCAN.Admission","FindCareProvByLoc","c","6")
Query FindWard(filterDesc As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT %ID As RowId,
	   WARD_Code As Code,
	   WARD_Desc As Description,
	   WARD_LocationDR As WardDeptID
	   From SQLUser.PAC_Ward
	   where (WARD_Desc [ :filterDesc) or (:filterDesc is null)
}

/// Creator：      	陈长青
/// CreatDate：    	2017-2-21
/// Description： 	查询医嘱项
/// Table：        	ARC_ItmMast,ARC_Alias
/// Input:			filterDesc:筛选字符串
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("DHCCL.BLL.Admission","FindMasterItem","")
Query FindMasterItem(filterDesc As %String, filterRowId As %String = "") As %SQLQuery(CONTAINID = 1)
{
SELECT distinct ARCIM_RowId As RowId,
	   ARCIM_Code As Code,
	   ARCIM_Desc As Description,
	   ARCIM_PHCDF_DR As DrgFormId,
	   ARCIM_PHCDF_DR->PHCDF_PHCIN_DR As Instruction,
	   ARCIM_PHCDF_DR->PHCDF_PHCIN_DR->PHCIN_Desc1 As InstrucDesc
	   From SQLUser.ARC_ItmMast As ItmMast inner join SQLUser.ARC_Alias As Alias on ItmMast.ARCIM_RowId=Alias.ALIAS_ARCIM_DR
	   where ((:filterRowId=ARCIM_RowId) or (:filterRowId is null))
	   and ((not :filterDesc is null) and ((ItmMast.ARCIM_Desc like UPPER('%'_:filterDesc_'%')) or (Alias.ALIAS_Text like UPPER('%'_:filterDesc_'%'))))
}

/// Creator：      	陈长青
/// CreatDate：    	2017-11-8
/// Description： 	查询药品等价单位
/// Table：        	PHC_FormDoseEquiv
/// Input:			drgFormId:药学项ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("DHCCL.BLL.Admission","FindDoseEquiv","")
Query FindDoseEquiv(drgFormId As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT EQ_CTUOM_DR->CTUOM_Desc As UomDesc,
	   EQ_CTUOM_DR->CTUOM_Code As UomCode,
	   EQ_CTUOM_DR As UomID,
	   EQ_CTUOM_DR->CTUOM_ForeignDesc As ForeignDesc,
	   EQ_DefaultDose As DefaultDose,
	   EQ_Qty As EqualQty
	   From SQLUser.PHC_FormDoseEquiv
	   where EQ_ParRef=:drgFormId
}

/// Creator：      	陈长青
/// CreatDate：    	2017-2-22
/// Description： 	查询医护人员类型
/// Table：        	CT_CarPrvTp
/// Input:			
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("DHCAN.Admission","FindCPType")
Query FindCPType() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID As RowId,
	   CTCPT_Code As Code,
	   CTCPT_Desc As Description
	   From SQLUser.CT_CarPrvTp
}

/// Creator：      	陈长青
/// CreatDate：    	2017-2-22
/// Description： 	查询科室就诊类型
/// Table：        	PAC_AdmTypeLocation
/// Input:			deptID:科室ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("DHCAN.Admission","FindDeptAdmType","53")
Query FindDeptAdmType(deptID As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT %ID As RowId,
	   ADMLOC_CTLOC_DR As DeptID,
	   ADMLOC_CTLOC_DR->CTLOC_Desc As DeptDesc,
	   ADMLOC_CTLOC_DR->CTLOC_Code As DeptCode,
	   ADMLOC_AdmType As AdmType,
	   %External(ADMLOC_AdmType) As AdmTypeDesc
	   From SQLUser.PAC_AdmTypeLocation
	   where ADMLOC_CTLOC_DR=:deptID
}

/// Creator：      	陈长青
/// CreatDate：    	2017-4-6
/// Description： 	查询HIS单位
/// Table：        	CT_UOM
/// Input:			filterDesc:筛选字符串
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("DHCAN.Admission","FindDeptAdmType","53")
Query FindUom(filterDesc As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT %ID As RowId,
	   CTUOM_Code As Code,
	   CTUOM_Desc As Description,
	   CTUOM_ForeignDesc As ForeignDesc
	   From SQLUser.CT_Uom
	   where (UPPER(CTUOM_Desc) [ UPPER(:filterDesc)) or (:filterDesc is null)
}

/// Creator：      	陈长青
/// CreatDate：    	2017-5-15
/// Description： 	根据就诊ID判断就诊记录是否存在
/// Table：        	PA_Adm
/// Input:			EpisodeID:就诊ID
/// Return：       	如果存在返回Y，不存在返回N
/// Debug:			w ##class(DHCCL.BLL.Admission).ExistsEpisode("112233")
ClassMethod ExistsEpisode(EpisodeID As %String) As %String
{
	set isExists=##class(User.PAAdm).%ExistsId(EpisodeID)
	set result=$case(isExists,
					 1:"Y",
					 0:"N")
	quit result
}

/// Creator:		杨勤
/// CreatDate:		2017-07-21
/// Description:	根据UserId获取医护人员ID
/// Table: 			SS_User
/// Input:			userID
/// Return: 		CT_CareProv的RowId,医护人员ID
/// Debug 			w ##class(DHCCL.BLL.Admission).GetCareProv(289)
ClassMethod GetCareProv(userID) As %String [ SqlProc ]
{
	quit:(userID="") ""
	&sql(SELECT SSUSR_CareProv_DR into :careProvID FROM SQLUSER.SS_User WHERE SSUSR_RowId=:userID)
	i SQLCODE q ""

	quit careProvID
}

/// Creator:		雍阳
/// CreatDate:		2019-04-10
/// Description:	根据UserCode获取医护人员ID
/// Table: 			SS_User
/// Input:			userID
/// Return: 		CT_CareProv的RowId,医护人员ID
/// Debug 			w ##class(DHCCL.BLL.Admission).GetCareProvFromCode(2220)
ClassMethod GetCareProvFromCode(userCode) As %String [ SqlProc ]
{
	quit:(userCode="") ""
	&sql(SELECT %id into :careProvID FROM SQLUSER.CT_CareProv WHERE CTPCP_Code=:userCode)
	i SQLCODE q ""

	quit careProvID
}

/// Creator:		杨勤
/// CreatDate:		2017-07-21
/// Description:	根据UserId获取医护人员ID
/// Table: 			SS_User
/// Input:			userID
/// Return: 		CT_CareProv的RowId,医护人员ID
/// Debug 			w ##class(DHCCL.BLL.Admission).GetUserIDByCareProv("37")
ClassMethod GetUserIDByCareProv(careProvID As %String) As %String [ SqlProc ]
{
	quit:(careProvID="") ""
	set userId=""
	&sql(SELECT SSUSR_RowId into :userId FROM SQLUSER.SS_User WHERE SSUSR_CareProv_DR=:careProvID)
	i SQLCODE q ""

	quit userId
}

/// Creator:		杨勤
/// CreatDate:		2017-07-21
/// Description:	根据医护人员ID获取医护人员类型
/// Table: 			CT_CareProv
/// Input:			userID
/// Return: 		医护人员类型ID
/// Debug 			w ##class(DHCCL.BLL.Admission).GetCareProvType(548)
ClassMethod GetCareProvType(careProvID) As %String [ SqlProc ]
{
	quit:(careProvID="") ""
	&sql(SELECT CTPCP_CarPrvTp_DR into :careProvTpId FROM SQLUSER.CT_CareProv WHERE CTPCP_RowId1=:careProvID)
	i SQLCODE q ""

	quit careProvTpId
}

/// Creator：      	陈长青
/// CreatDate：    	2017-11-09
/// Description： 	查询药品用法
/// Table：        	PHC_Instruc
/// Input:			filterDesc:筛选字符串
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("DHCAN.Admission","FindInstruction","53")
Query FindInstruction(filterDesc As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT %ID As RowId,
	   PHCIN_Code As Code,
	   PHCIN_Desc1 As Description,
	   PHCIN_Desc2 As ForeignDesc
	   From SQLUser.PHC_Instruc
	   where (UPPER(PHCIN_Desc1) [ UPPER(:filterDesc)) or (:filterDesc is null)
}

/// Creator：      	陈长青
/// CreatDate：    	2017-11-10
/// Description： 	获取医嘱项的接收科室
/// Table：        	
/// Input:			EpisodeID:就诊ID，locId:当前科室,arcimId:医嘱项ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("web.DHCClinicAdmission","FindRecvLoc","","","")
Query FindRecvLoc(EpisodeID As %String, locId As %String, arcimId As %String) As %Query(ROWSPEC = "Id,Desc")
{
}

ClassMethod FindRecvLocExecute(ByRef qHandle As %Binary, EpisodeID As %String, locId As %String, arcimId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	set recvLocStr=##class(web.DHCANCall).GetOrderItemRecloc("",arcimId,EpisodeID,locId)
	set locCount=$length(recvLocStr,"^")
	for i=1:1:locCount
	{
		set recvLocId=$piece(recvLocStr,$char(3),1)
		set recvLocDesc=$piece(recvLocStr,$char(3),2)
		do OutputRow	
	}
	
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutputRow
 	Set Data=$lb(recvLocId,recvLocDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindRecvLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindRecvLocExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {				// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 // Save QHandle
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindRecvLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindRecvLocExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// Descrption:医生站患者查询
Query FindLocDocCurrentAdm(LocID As %String, UserID As %String, IPAddress As %String, AllPatient As %String, PatientNo As %String, SurName As %String, StartDate As %Date, EndDate As %Date, ArrivedQue As %String, RegQue As %String, MedUnit As %String = "", PACWard As %String = "", BedId As %String = "") As %Query(ROWSPEC = "PatientID:%String,EpisodeID:%String,mradm:%String,PAPMINO:%String,PAPMIName:%String,PAPMIDOB:%String,PAPMISex:%String,PAAdmDate:%Date,PAAdmTime:%Time,PAAdmNo:%String,PAAdmDepCodeDR:%String,PAAdmDocCodeDR:%String,PAAdmType:%String,Hospital:%String,PAAdmWard:%String,PAAdmBed:%String,FinancialDischargeFlag:%String,MedicalDischargeFlag:%String,FinalDischargeFlag:%String,PAAdmReason:%String,DischargeDate:%String,RegDoctor:%String,Diagnosis:%String,ArrivedDate:%String,ArrivedTime:%String,LeavedDate:%String,LeavedTime:%String,LocSeqNo:%String,PAAdmPriority:%String,WalkStatus:%String,ConsultRoom:%String,ConsultArea:%String,PAAdmReasonCode:%String,StatusCode:%String,Age:%String,PriorityCode:%String,Called:%String,RegDocDr:%String")
{
}

ClassMethod FindLocDocCurrentAdmExecute(ByRef qHandle As %Binary, LocID As %String, UserID As %String, IPAddress As %String, AllPatient As %String, PatientNo As %String, SurName As %String, StartDate As %Date, EndDate As %Date, ArrivedQue As %String, RegQue As %String, MedUnit As %String = "", PACWard As %String = "", BedId As %String = "") As %Status
{
	//PatientNo,SurName,CurrentDept,CurrentBed,CurrentWard,CurrentDoctor,StartDate,EndDate,CurrentAdmType
	//Set ^SMLPara=LocID_","_UserID_","_IPAddress_","_AllPatient_","_PatientNo_","_SurName_","_StartDate_","_EndDate_","_ArrivedQue _","_RegQue_","_MedUnit_","_PACWard_","_BedId
	//;
	//n (qHandle, LocID , UserID , IPAddress , AllPatient , PatientNo , SurName , StartDate , EndDate , ArrivedQue, RegQue, MedUnit, PACWard, BedId)
	If LocID="" Set LocID=%session.Get("LOGON.CTLOCID")
	If UserID="" Set UserID=%session.Get("LOGON.USERID")
	If LocID="" Quit $$$OK
	If UserID="" Quit $$$OK
	//
	//
	Set repid=$I(^CacheTemp)
 	Set DocId=$p($g(^SSU("SSUSR",UserID)),"^",14)
 	If $g(DocId)="" s qHandle=$lb(0,repid,0) Quit $$$OK
 	Set DocGrp=$P($g(^CTPCP(DocId,3)),"^",1)
	//Set DocId=$p($g(^CTPCP(DocId,1)),"^",1)
	//	
	Set CurrentAdmType="I"
	//
	Kill ^TMP("DHCDocWorkBench",$j)
	Set Count=0
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	//
	Set Singleflag=0
	//
	If ($g(PatientNo)'="") Do
		.Set Singleflag=1
		.Set PAPMI=$O(^PAPERi("PAPMI_PatNo",PatientNo,""))
		.Quit:$g(PAPMI)=""
		.Do OutPAPMI
	If ($g(SurName)'="")&($g(PatientNo)="") Do
		.Set Singleflag=1
		.Set name=SurName
		.Set name0=name
		.Set SurName=$$ALPHAUP^SSUTIL4(SurName)
		.Set PAPMI=$O(^PAPERi("PAPER_PatName",SurName,""))
		.If PAPMI'="" Do OutPAPMI
		.Set Qflag="N"
		.For  Set name0=$O(^PAPERi("PAPER_PatName",name0)) Quit:(name0="")!(Qflag="Y")  Do
		..If $l(name),$e(name0,1,$l(name))'[name Set Qflag="Y" Quit
		..Set PAPMI=$O(^PAPERi("PAPER_PatName",name0,""))
		..If PAPMI="" Set Qflag="Y" Quit
		..Else  Do OutPAPMI
	Set L1="" For  Set L1=$O(^TMP("DHCDocWorkBench",$j,L1)) Quit:L1=""  Do
	.Set L2=0 For  Set L2=$O(^TMP("DHCDocWorkBench",$j,L1,L2)) Quit:L2=""  Do
	..Set ^CacheTemp(repid,ind)=^TMP("DHCDocWorkBench",$j,L1,L2)
	..Set ind=ind+1 
	Set qHandle=$lb(0,repid,0)
	Kill ^TMP("DHCDocWorkBench",$j)
	Quit:Singleflag=1 $$$OK
	//
	//全病区病人
	If AllPatient="on"	Do 
	.Do StayInWard
	.Set L1="" For  Set L1=$O(^TMP("DHCDocWorkBench",$j,L1)) Quit:L1=""  Do
	..Set L2=0 For  Set L2=$O(^TMP("DHCDocWorkBench",$j,L1,L2)) Quit:L2=""  Do
	...Set ^CacheTemp(repid,ind)=^TMP("DHCDocWorkBench",$j,L1,L2)
	...Set ind=ind+1 
	.Set qHandle=$lb(0,repid,0)
	.Kill ^TMP("DHCDocWorkBench",$j)
	Quit:AllPatient="on" $$$OK
	//
	//本科病人
	If ArrivedQue="on"	Do 
	.Do DeptPatList
	.Do TempDeptPatList
	.Set L1="" For  Set L1=$O(^TMP("DHCDocWorkBench",$j,L1)) Quit:L1=""  Do
	..Set L2=0 For  Set L2=$O(^TMP("DHCDocWorkBench",$j,L1,L2)) Quit:L2=""  Do
	...Set ^CacheTemp(repid,ind)=^TMP("DHCDocWorkBench",$j,L1,L2)
	...Set ind=ind+1 
	.Set qHandle=$lb(0,repid,0)
	.Kill ^TMP("DHCDocWorkBench",$j)
	Quit:ArrivedQue="on" $$$OK
	//
	//;----------------------------------------------------------------------;
	//
	//本病区病人
	if PACWard'="" Do
	.s WardItem=PACWard
	.Do WardPatList
	.Set L1="" For  Set L1=$O(^TMP("DHCDocWorkBench",$j,L1)) Quit:L1=""  Do
	..Set L2=0 For  Set L2=$O(^TMP("DHCDocWorkBench",$j,L1,L2)) Quit:L2=""  Do
	...Set ^CacheTemp(repid,ind)=^TMP("DHCDocWorkBench",$j,L1,L2)
	...Set ind=ind+1 
	.Set qHandle=$lb(0,repid,0)
	.Kill ^TMP("DHCDocWorkBench",$j)
	Quit:PACWard'="" $$$OK
	Set Count=0
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	//
	//Set CurrentDoctor=$g(CurrentDoctor),CurrentWard=$g(CurrentWard),CurrentDept=$g(CurrentDept)
	//if Singleflag=0 Do SetDefaultPara,SetDefaultDate
	//
	//Set CurrentDept=LocID 
	//if ($g(CurrentWard)="")&($g(CurrentDept)'="") Do
	//	.Set DeptLst=$L(CurrentDept,$C(1))
	//	.For I=1:1:DeptLst Do
	//	..Set DeptItem=$P(CurrentDept,$C(1),I)
	//	..Do DeptPatList
	//
	Do DocPatList
	Set L1="" For  Set L1=$O(^TMP("DHCDocWorkBench",$j,L1)) Quit:L1=""  Do
	.Set L2=0 For  Set L2=$O(^TMP("DHCDocWorkBench",$j,L1,L2)) Quit:L2=""  Do
	..Set ^CacheTemp(repid,ind)=^TMP("DHCDocWorkBench",$j,L1,L2)
	..Set ind=ind+1 
	Set qHandle=$lb(0,repid,0)
	Kill ^TMP("DHCDocWorkBench",$j)
	Quit $$$OK
	//
OutputRow
	Do ResetVariables
	//PatientID,EpisodeID,mradm
	Set PatientID=$P(^PAADM(PAAdm),"^",1)
	Set EpisodeID=PAAdm
	Set mradm=$P(^PAADM(PAAdm),"^",61)
	//PAPMINO,PAPMIName,PAPMIDOB,PAPMISex
	Set PAPMINO=$P(^PAPER(PatientID,"PAT",1),"^",1)
	Set PAPMIName=$P(^PAPER(PatientID,"ALL"),"^",1)
	Set PAPMIDOB=$ZD($P(^PAPER(PatientID,"ALL"),"^",6),3)
	Set Sex=$P(^PAPER(PatientID,"ALL"),"^",7)
	Set PAPMISex=$P($g(^CT("SEX",Sex)),"^",2)
	//
	Set DobDate=$P($g(^PAPER(PatientID,"ALL")),"^",6)
	If DobDate'="" Do
	.Set PAPMIDOB=$ZD($P(^PAPER(PatientID,"ALL"),"^",6),3)
	.Set PAPMIAge=$fn((+$H-DobDate)/365,"",0)
	Else  Set PAPMIDOB="",PAPMIAge=""
	s PAPMIAge=##class(web.DHCBillInterface).GetPapmiAge(PatientID,PAAdm)
	//PAAdmDate,PAAdmTime,PAAdmNo,PAAdmDepCodeDR,PAAdmDocCodeDR,PAAdmType,Hospital,PAAdmWard,PAAdmBed
	Set PAAdmDate=$ZD($P($g(^PAADM(PAAdm)),"^",6),3)
	Set PAAdmTime=$ZT($P($g(^PAADM(PAAdm)),"^",7),3)
	//
	//Add Date Check
	//	
	Set PAAdmNo=$P($g(^PAADM(PAAdm)),"^",81)
	Set Loc=$P($g(^PAADM(PAAdm)),"^",4)
	Set PAAdmDepCodeDR=##class(web.DHCDocInPatientList).RemoveAlias($P($g(^CTLOC(Loc)),"^",2))
	Set Doctor=$P($g(^PAADM(PAAdm)),"^",9)
	If Doctor'="" Set PAAdmDocCodeDR=$P($g(^CTPCP(Doctor,1)),"^",2)
	Else  Set PAAdmDocCodeDR=""
	Set PAAdmType=$P($g(^PAADM(PAAdm)),"^",2)
	Set Hosp=$P($g(^CTLOC(Loc)),"^",22)
	If Hosp'="" Set Hospital=$P($g(^CT("HOSP",Hosp)),"^",2)
	Set WardDr=$P($g(^PAADM(PAAdm)),"^",70)
	if WardDr'="" Set PAAdmWard=##class(web.DHCDocInPatientList).RemoveAlias($P($g(^PAWARD(WardDr)),"^",2))
	else  Set PAAdmWard=""
	Set AdmBedId=$P($g(^PAADM(PAAdm)),"^",73)
	//Q:(BedId'="")&&(BedId'=AdmBedId)
	if AdmBedId'="" Set PAAdmBed=$P($g(^PAWARD(+AdmBedId,"BED",$P(AdmBedId,"||",2))),"^",1)
	else  Set PAAdmBed="" 
	//FinancialDischargeFlag,MedicalDischargeFlag,FinalDischargeFlag,PAAdmReason,DischargeDate,Diagnosis
	Set FinancialDischargeFlag=$P($g(^PAADM(PAAdm)),"^",45)
	Set MedicalDischargeFlag=$P($g(^PAADM(PAAdm)),"^",63)
	Set PAAdmStatus=$P($g(^PAADM(PAAdm)),"^",20)
	Set FinalDischargeFlag=$S($g(PAAdmStatus)="D":"Y",1:"N")
	Set AdmReason=$P($g(^PAADM(PAAdm,1)),"^",7)
	If AdmReason'="" Set PAAdmReason=$P($g(^PAC("ADMREA",AdmReason)),"^",2),PAAdmReasonCode=$P($g(^PAC("ADMREA",AdmReason)),"^",5)
	Else  Set PAAdmReason="",PAAdmReasonCode=""
	Set DischargeDate=$P($g(^PAADM(PAAdm)),"^",17)
	If mradm'="" Set Diagnosis=##class(web.DHCDocInPatientList).GetMRAdmDiagnosis(mradm) 
	Else  Set Diagnosis=""
	//RegDoctor,ArrivedDate,ArrivedTime,LeavedDate,LeavedTime,LocSeqNo,PAAdmPriority
	//
	Set Count=Count+1
	Set Seq=EpisodeID
	set MotherID=$P(^PAADM(PAAdm),"^",75)
	if MotherID'="" s Seq=MotherID

	set Data=$LB(PatientID,EpisodeID,mradm,PAPMINO,PAPMIName,PAPMIDOB,PAPMISex,PAAdmDate,PAAdmTime,PAAdmNo,PAAdmDepCodeDR,PAAdmDocCodeDR,PAAdmType,Hospital,PAAdmWard,PAAdmBed,FinancialDischargeFlag,MedicalDischargeFlag,FinalDischargeFlag,PAAdmReason,DischargeDate,RegDoctor,Diagnosis,ArrivedDate,ArrivedTime,LeavedDate,LeavedTime,LocSeqNo,PAAdmPriority,WalkStatus,ConsultRoom,ConsultArea,PAAdmReasonCode,StatusCode,PAPMIAge,PriorityCode,Called,RegDocDr)
 	Set ^TMP("DHCDocWorkBench",$j,Seq,Count)=Data
	Quit
	;PatientID,EpisodeID,mradm,PAPMINO,PAPMIName,PAPMIDOB,PAPMISex,PAAdmDate,PAAdmTime,PAAdmNo,PAAdmDepCodeDR,PAAdmDocCodeDR,PAAdmType,Hospital,PAAdmWard,PAAdmBed,FinancialDischargeFlag,MedicalDischargeFlag,FinalDischargeFlag,PAAdmReason,DischargeDate,RegDoctor,Diagnosis,ArrivedDate,ArrivedTime,LeavedDate,LeavedTime,LocSeqNo,PAAdmPriority
	//
	If Seq="" Set Seq="ZZZZZ"
	set Data=$LB(PatientID,EpisodeID,mradm,PAPMINO,PAPMIName,PAPMIDOB,PAPMISex,PAAdmDate,PAAdmTime,PAAdmNo,PAAdmDepCodeDR,PAAdmDocCodeDR,PAAdmType,Hospital,PAAdmWard,PAAdmBed,FinancialDischargeFlag,MedicalDischargeFlag,FinalDischargeFlag,PAAdmReason,DischargeDate,RegDoctor,Diagnosis,ArrivedDate,ArrivedTime,LeavedDate,LeavedTime,LocSeqNo,PAAdmPriority,WalkStatus,ConsultRoom,ConsultArea,PAAdmReasonCode,OEOrdItemID)
 	
 	Set ^TMP("DHCDocWorkBench",$j,Seq,Count)=Data
	Quit
ResetVariables
	///Set (repid)=0
	Set (PatientID,EpisodeID,mradm,PAPMINO,PAPMIName,PAPMIDOB,PAPMISex,PAAdmDate,PAAdmTime,PAAdmNo,PAAdmDepCodeDR,PAAdmDocCodeDR,PAAdmType,Hospital,PAAdmWard,PAAdmBed,FinancialDischargeFlag,MedicalDischargeFlag,FinalDischargeFlag,PAAdmReason,DischargeDate,Diagnosis,RegDoctor,ArrivedDate,ArrivedTime,LeavedDate,LeavedTime,LocSeqNo,PAAdmPriority,WalkStatus,ConsultRoom,ConsultArea,PAAdmReasonCode)=""
	Quit
StayInWard
	Set WardStr=""
	Set LocLink=""
	For  Set LocLink=$O(^CTLOC(LocID,"LINK",LocLink)) Quit:LocLink=""  Do
		.Set LocItem=$P($G(^CTLOC(LocID,"LINK",LocLink)),"^",1)
		.Set LocEmerType=$P($G(^CTLOC(LocItem)),"^",13)
		.Quit:LocEmerType'="W"
		.Set EmerWard=$O(^PAWARD(0,"WARD_LocationDR",LocItem,""))
		.Quit:EmerWard=""
		.If WardStr="" Set WardStr=EmerWard
		.Else  Set WardStr=WardStr_$C(1)_EmerWard
	If WardStr'="" DO
		.Set WardLst=$L(WardStr,$C(1))
		.For I=1:1:WardLst Do
		..Set WardItem=$P(WardStr,$C(1),I)
		..Do WardPatList
	Quit
StayInWardLoc
	Set WardStr=""
	Set LocLink=""
	For  Set LocLink=$O(^CTLOC(LocID,"LINK",LocLink)) Quit:LocLink=""  Do
		.Set LocItem=$P($G(^CTLOC(LocID,"LINK",LocLink)),"^",1)
		.Set LocEmerType=$P($G(^CTLOC(LocItem)),"^",13)
		.;Quit:LocEmerType'="W"
		.Set EmerWard=$O(^PAWARD(0,"WARD_LocationDR",LocItem,""))
		.Quit:EmerWard=""
		.If WardStr="" Set WardStr=EmerWard
		.Else  Set WardStr=WardStr_$C(1)_EmerWard
	If WardStr'="" DO
		.Set WardLst=$L(WardStr,$C(1))
		.For I=1:1:WardLst Do
		..Set WardItem=$P(WardStr,$C(1),I)
		..Do WLDPatList
	Quit
	//
DocPatList
	Set DeptItem=LocID
	Quit:DeptItem=""
	If StartDate'="" Set Date=StartDate-1
	Else  Set Date=""
	//^PAADMi("AdmTypeCurrLoc",{PAADM_Type},{PAADM_DepCode_DR},{PAADM_AdmDate},{PAADM_AdmTime},{PAADM_RowID})
	For  Set Date=$O(^PAADMi("AdmTypeCurrLoc",CurrentAdmType,DeptItem,Date)) Quit:(Date="")  Do
	.Set Time=""
	.For  Set Time=$O(^PAADMi("AdmTypeCurrLoc",CurrentAdmType,DeptItem,Date,Time)) Quit:(Time="")  Do
	..Set PAAdm=""
	..For  Set PAAdm=$O(^PAADMi("AdmTypeCurrLoc",CurrentAdmType,DeptItem,Date,Time,PAAdm)) Quit:(PAAdm="")  Do
	...Set QuitFlag=0
	...if MedUnit="" d
	....Set PatDoc=$P($g(^PAADM(PAAdm)),"^",9)
	....if PatDoc="" Set QuitFlag=1
	....if PatDoc'=DocId Set QuitFlag=1
	...else  d
	....s AllowFlag=##class(web.DHCDocInPatientList).CheckCTLocMedUnit(PAAdm,DocId,DeptItem,MedUnit)
	....if AllowFlag'="1" Set QuitFlag=1
	...Q:QuitFlag=1
	...Do OutputRow
	Quit
	//
OutPAPMI
	If CurrentAdmType'="" Do
	.Set PAAdm=""
	.For  Set PAAdm=$O(^PAPERdr(PAPMI,"ADM",CurrentAdmType,PAAdm)) Quit:PAAdm=""  Do
	..Set PAAdmStatus=$P($g(^PAADM(PAAdm)),"^",20)
	..Quit:PAAdmStatus'="A"
	..;Quit:PAAdmStatus="P"
	..Quit:##class(web.DHCDocInPatientList).CheckAdmDate(PAAdm,StartDate,EndDate)
	..Do OutputRow
	Quit
DeptPatList
	Set DeptItem=LocID
	Quit:DeptItem=""
	If StartDate'="" Set Date=StartDate-1
	Else  Set Date=""
	
	//^PAADMi("AdmTypeCurrLoc",{PAADM_Type},{PAADM_DepCode_DR},{PAADM_AdmDate},{PAADM_AdmTime},{PAADM_RowID})
	For  Set Date=$O(^PAADMi("AdmTypeCurrLoc",CurrentAdmType,DeptItem,Date)) Quit:(Date="")  Do
	.Set Time=""
	.
	.For  Set Time=$O(^PAADMi("AdmTypeCurrLoc",CurrentAdmType,DeptItem,Date,Time)) Quit:(Time="")  Do
	..Set PAAdm=""
	..For  Set PAAdm=$O(^PAADMi("AdmTypeCurrLoc",CurrentAdmType,DeptItem,Date,Time,PAAdm)) Quit:(PAAdm="")  Do
	...
	...Do OutputRow
	Quit
TempDeptPatList
	Set DeptItem=LocID
	Quit:DeptItem=""
	If StartDate'="" Set Date=StartDate-1
	Else  Set Date=""
	;对于产房这种特殊病房,需要判断某些特殊医嘱就需要显示病人的走统一的自定义方法
	;这种一般都需要按登陆科室去接收科室,否则就诊科室还没有改变的情况下,录医嘱的接收科室位置可能不正确
	
	;这种特殊科室应当增加配置
	s SpecLocIDStr=""
	s CustomARCIMStr=""
	if (SpecLocIDStr[("^"_LocID_"^")) {
		s DeptItem=LocID
		For  Set Date=$O(^PAADMi("AdmTypeCurrLoc",CurrentAdmType,DeptItem,Date)) Quit:(Date="")  Do
		.Set Time=""
		.For  Set Time=$O(^PAADMi("AdmTypeCurrLoc",CurrentAdmType,DeptItem,Date,Time)) Quit:(Time="")  Do
		..Set PAAdm=""
		..For  Set PAAdm=$O(^PAADMi("AdmTypeCurrLoc",CurrentAdmType,DeptItem,Date,Time,PAAdm)) Quit:(PAAdm="")  Do
		...//得到是否包含参数中的医嘱,并且未执行
		...s NotExecFlag=##class(web.DHCDocInPatientList).GetCustomARCIMNotExecFlag(CustomARCIMStr,PAAdm)
		...Q:NotExecFlag'=1
		....Do OutputRow
	}else{
		//^PAADMi("AdmTypeCurrLoc",{PAADM_Type},{PAADM_DepCode_DR},{PAADM_AdmDate},{PAADM_AdmTime},{PAADM_RowID})
		For  Set Date=$O(^PAADMi("TempLoc",DeptItem,Date)) Quit:(Date="")  Do
		.Set Time=""
		.For  Set Time=$O(^PAADMi("TempLoc",DeptItem,Date,Time)) Quit:(Time="")  Do
		..Set PAAdm=""
		..For  Set PAAdm=$O(^PAADMi("TempLoc",DeptItem,Date,Time,PAAdm)) Quit:(PAAdm="")  Do
		...s CurrDepDR=$P($g(^PAADM(PAAdm)),"^",4)
		...q:CurrDepDR=DeptItem
		...Do OutputRow
	}
	Quit
WLDPatList
	Quit:WardItem=""
	Set RoomDr=0
	For RoomDr=$O(^PAADMi("CurrWard",WardItem,RoomDr)) Quit:RoomDr=""  Do
	.Set PAAdm=""
	.For  Set PAAdm=$O(^PAADMi("CurrWard",WardItem,RoomDr,PAAdm)) Quit:PAAdm=""  Do
	..Set PatLoc=$P($g(^PAADM(PAAdm)),"^",4)
	..Quit:(PatLoc'=LocID)
	..Set AdmDate=$P($g(^PAADM(PAAdm)),"^",6)
	..Quit:(StartDate'="")&(AdmDate<StartDate)
	..Quit:(EndDate'="")&(AdmDate>EndDate)
	..Do OutputRow
	Set AdmItm=0
	For  Set AdmItm=$O(^PAWARDA(WardItem,"WADM",AdmItm)) Quit:AdmItm=""  Do
	.Set PAAdm=$P(^PAWARDA(WardItem,"WADM",AdmItm),"^",1)
	.Set PatLoc=$P($g(^PAADM(PAAdm)),"^",4)
	.Quit:(PatLoc'=LocID)
	.Set AdmDate=$P($g(^PAADM(PAAdm)),"^",6)
	.Quit:(StartDate'="")&(AdmDate<StartDate)
	.Quit:(EndDate'="")&(AdmDate>EndDate)
	.Do OutputRow
	Quit
	//
WardPatList
	Set RoomDr=0
	For  s RoomDr=$O(^PAADMi("CurrWard",WardItem,RoomDr)) Quit:RoomDr=""  Do
	.Set PAAdm=0
	.For  Set PAAdm=$O(^PAADMi("CurrWard",WardItem,RoomDr,PAAdm)) Quit:PAAdm=""  Do
	..Set AdmDate=$P($g(^PAADM(PAAdm)),"^",6)
	..s PAADMVisitStatus=$p(^PAADM(PAAdm),"^",20)
	..q:PAADMVisitStatus="D"
	..Set AdmBedId=$P($g(^PAADM(PAAdm)),"^",73)
	..Q:(BedId'="")&&(BedId'=AdmBedId)
	..Set AdmBedId=$P($g(^PAADM(PAAdm)),"^",73)
	..Q:(BedId'="")&&(BedId'=AdmBedId)
	..Quit:(StartDate'="")&(AdmDate<StartDate)
	..Quit:(EndDate'="")&(AdmDate>EndDate)
	..Do OutputRow
	Set AdmItm=0
	For  Set AdmItm=$O(^PAWARDA(WardItem,"WADM",AdmItm)) Quit:AdmItm=""  Do
	.Set PAAdm=$P(^PAWARDA(WardItem,"WADM",AdmItm),"^",1)
	.Set AdmDate=$P($g(^PAADM(PAAdm)),"^",6)
	.Set AdmBedId=$P($g(^PAADM(PAAdm)),"^",73)
	.Q:(BedId'="")&&(BedId'=AdmBedId)
	.s PAADMVisitStatus=$p(^PAADM(PAAdm),"^",20)
	.q:PAADMVisitStatus="D"
	.Quit:(StartDate'="")&(AdmDate<StartDate)
	.Quit:(EndDate'="")&(AdmDate>EndDate)
	.Do OutputRow
	Quit
SetDefaultPara
	If (StartDate="")&(%request.Get("WIPDateFromToday")="on") Set StartDate=+$H
	If (StartDate="")&(%request.Get("WIPDtFromOffset")'="") Set StartDate=$ZDH(%request.Get("WIPDtFromOffset"),5)
	//
	If (EndDate="")&(%request.Get("WIPDateToToday")="on") Set EndDate=+$H
	If (EndDate="")&(%request.Get("WIPDtToOffset")'="") Set EndDate=$ZDH(%request.Get("WIPDtToOffset"),5)
	//
	If $g(CurrentDept)="" Do
	.Set LocStr=%request.Get("WIPLocList")
	.Set Loclen=$L(LocStr,$C(1))
	.For I=1:1:Loclen Do
	..If CurrentDept="" Set CurrentDept=$P($P(LocStr,$C(1),I),$C(2),3)
	..Else  Set CurrentDept=CurrentDept_$C(1)_$P($P(LocStr,$C(1),I),$C(2),3)
	//
	If $g(CurrentDoctor)="" Do
	.Set DocStr=%request.Get("WIPCPList")
	.Set Doclen=$L(DocStr,$C(1))
	.For I=1:1:Doclen Do
	..Set DoctCode=$P($P(DocStr,$C(1),I),$C(2),1)
	..Quit:DoctCode=""
	..Set DocRowId=$O(^CTPCP(0,"Code",$$ALPHAUP^SSUTIL4(DoctCode),""))
	..Quit:DocRowId=""
	..If CurrentDoctor="" Set CurrentDoctor=DocRowId
	..Else  Set CurrentDoctor=CurrentDoctor_$C(1)_DocRowId
	//
	If $g(CurrentWard)="" Do
	.Set WardStr=%request.Get("WIPWardList")
	.Set Wardlen=$L(WardStr,$C(1))
	.For I=1:1:Wardlen Do
	..If CurrentWard="" Set CurrentWard=$P($P(WardStr,$C(1),I),$C(2),3)
	..Else  Set CurrentWard=CurrentWard_$C(1)_$P($P(WardStr,$C(1),I),$C(2),3)
	//
	If $g(CurrentAdmType)="" Do
	.Set AdmStr=%request.Get("WIPEpisodeTypeList")
	.If $L(AdmStr)>0 Set CurrentAdmType=$E(AdmStr,1)
	Quit
SetDefaultDate
	if StartDate="" Set StartDate=+$H-6
	If EndDate="" Set EndDate=+$H
	Quit
}

ClassMethod FindLocDocCurrentAdmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindLocDocCurrentAdmExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {				// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindLocDocCurrentAdmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindLocDocCurrentAdmExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// 第二组：科室
ClassMethod GetLinkLocId(locId) As %String
{
	q:locId="" ""
	s linkSub=0,ctlocIdStr=""
	f  s linkSub=$o(^CTLOC(locId,"LINK",linkSub)) q:linkSub=""  d
		.i ctlocIdStr'="" s ctlocIdStr=ctlocIdStr_"^"
		.s ctlocIdStr=ctlocIdStr_^CTLOC(locId,"LINK",linkSub)
	q ctlocIdStr
}

ClassMethod GetRegNobyEpisodeID(EpisodeID)
{
	q:$g(EpisodeID)="" ""
	q:'$d(^PAADM(EpisodeID)) ""
	s PaitentID=$p(^PAADM(EpisodeID),"^",1)
	s admType=$p(^PAADM(EpisodeID),"^",2)

	q:$g(PaitentID)="" ""
	q:'$D(^PAPER(PaitentID,"PAT",1)) ""
	q:admType="I" $p(^PAPER(PaitentID,"PAT",1),"^",1)
	q $p(^PAPER(PaitentID,"PAT",1),"^",2)
}

// w ##class(web.DHCClinicCom).GetUserInfoByInitials(1)

ClassMethod GetUserInfoByInitials(ssusrInitials As %String) As %String
{
	set userId=..GetUserIdByInitials(ssusrInitials)
	set userInfo=""
	if (+userId>0)
	{
		set userInfo=..GetUserTypeName(userId)
	}	
	
	quit userInfo
}

ClassMethod GetUserTypeName(userId As %String) As %String
{

	//取用户的类别:医生还是护士
	q:userId="" ""
	s ctpcpId=$p($g(^SSU("SSUSR",userId)),"^",14)
	i ctpcpId="" d //20140806 其他医护人员
	  	.s retstr=$$ctpcpIdNo	  			
	e  d
		.s retstr=$$ctpcpIdOk(ctpcpId)
	q retstr
ctpcpIdNo()	
		s retStr=""
		s clcpRowId=""	//添加其他医护人员	
		f  s clcpRowId=$o(^DHCCLCP(clcpRowId)) q:clcpRowId=""  d
 			.q:clcpRowId'=userId
 			.s desc=$li(^DHCCLCP(clcpRowId),2)
 			.s alias=$li(^DHCCLCP(clcpRowId),3)
 			.s fdate=$li(^DHCCLCP(clcpRowId),4) 			
 			.s tdate=$li(^DHCCLCP(clcpRowId),5) 			
 			.q:(tdate'="")&&(tdate<+$h)
 			.s inActive=$li(^DHCCLCP(clcpRowId),6)
 			.q:(inActive'="")&&(inActive=1) 			 
 			.s ifDoc=$li($g(^DHCCLCP(clcpRowId)),7) 		
 			.s ifDocDes=""
 			.i ifDoc=0 s ifDocDes="NURSE"
 			.e  s ifDocDes="DOCTOR"
 			.s ctcptInternalType=ifDocDes,userName=desc,loadName=alias,ctpcpId=alias,ctpcpDesc=desc
 			.s retStr=ctcptInternalType_"^"_userName_"^"_loadName_"^"_ctpcpId_"^"_ctpcpDesc
		
		q retStr
ctpcpIdOk(ctpcpId)
		q:ctpcpId="" "该用户未关联医护人员!"
		s ctpcpDesc=""
		i ctpcpId'="" s ctpcpDesc=$P($g(^CTPCP(ctpcpId,1)),"^",2)
		s ctcptId=$P($g(^CTPCP(ctpcpId,1)),"^",4)  ;CTPCP_CarPrvTp_DR
		q:ctcptId="" "该医护人员未定义医护类型!"
		s ctcptInternalType=""
    	i ctcptId'="" s ctcptInternalType=$P($g(^CT("CPT",ctcptId)),"^",4)  ;CT_CarPrvTp:CTCPT_InternalType
		q:ctcptInternalType="" "医护人员类型定义有误!"
		s userName=$p($g(^SSU("SSUSR",userId)),"^",2)
		s loadName=$p($g(^SSU("SSUSR",userId)),"^",1)
		q ctcptInternalType_"^"_userName_"^"_loadName_"^"_ctpcpId_"^"_ctpcpDesc
}

ClassMethod GetUserIdByInitials(ssusrInitials As %String) As %String
{
	q:ssusrInitials="" ""
	s ssusrInitials=$$ALPHAUP^SSUTIL4(ssusrInitials)
	q $o(^SSU("SSUSR",0,"SSUSR_Initials",ssusrInitials,""))
}

/// Creator：      	chenchangqing
/// CreatDate：    	2018-06-27
/// Description： 	验证用户工号和密码
/// Table：        	
/// Input：        	account:用户工号，pwd:用户密码
/// Output：       
/// Return：       	验证正确返回"S^UserID"，失败返回"E^失败原因"
ClassMethod ValidateUser(account As %String, pwd As %String, accountSign = "N") As %String
{
	set validRet=##class(web.SSUser).IsValidUser(account,pwd)
	if (##class(User.SSUser).%ExistsId(validRet)=0)
	{
		set errorCode=$p(validRet,"^",2)
		set ret=$select(errorCode="UserNotFindErr":"用户不存在",
						errorCode="UnActiveErr":"用户未激活",
						errorCode="DateFromScopeErr":"未到用户开启日",
						errorCode="DateToScopeErr":"用户有效期已过",
						errorCode="PasswordErr":"密码错误")	
		quit "E^"_ret
	}
	else
	{
		if (accountSign="Y")
		{
			set canAccountSign=##class(DHCCL.BLL.SecureUser).CanAccountSign(account)
			quit:(canAccountSign="N") "E^用户未开通工号和密码签名权限，请联系信息中心。"		
		}	
	}
	
	quit "S^"_validRet
}

ClassMethod ValidateUserTypeByID(userId As %String, type As %String) As %String
{
	set account=$p($g(^SSU("SSUSR",userId)),"^",1)
	quit ..ValidateUserType(account,type)
}

/// Creator：      	雍阳
/// CreatDate：    	2019-03-07
/// Description： 	用户类型验证
/// Table：        	
/// Input:			userId:用户Id，type:类型("OPNURSE","SURGEON","ANDOCTOR")
/// Return：       	S:成功，E_错误原因
/// w ##class(DHCCL.BLL.Admission).ValidateUserType("2051","OPNURSE")
ClassMethod ValidateUserType(account As %String, type As %String) As %String
{
	set account=$ZCVT(account,"U")
	set careprovId=$o(^CTPCP(0,"Code",account,""))
	set result="S^1"
	
	if 'careprovId quit "E^签名用户不是医护人员，不能签名!"
	
	kill LocListDictionary
	set rowId=""
	for
	{
		set rowId=$o(^DHCCL.Config.LocListLocD(rowId))
		quit:rowId=""
		
		set LocListLoc=##class(DHCCL.Config.LocListLoc).%OpenId(rowId)
		set code=LocListLoc.LocList.Code
		set locId=LocListLoc.Location.%Id()
		set LocListDictionary(code,locId)=""
	}
		
	if type="OPNURSE"
	{
		set locId="",found=0
		for
		{
			set locId=$o(LocListDictionary("OP",locId))
			quit:locId=""
			
			if $d(^RB("RES",0,"CTPCP",careprovId,locId)) set found=1
		}
		if found set result="S^"_careprovId
		else  set result="E^签名用户不是手术室护士，不能签名!"
	}
	elseif (type="SURGEON")||(type="ANDOCTOR")
	{
		set careprovTypeId=$p($g(^CTPCP(careprovId,1)),"^",4)
		set careprovType=$p($g(^CT("CPT",careprovTypeId)),"^",4)
		if careprovType="DOCTOR" set result="S^1"
		else  set result="E^签名用户不是医生，不能签名!"
	}
	
	quit result
}

}
