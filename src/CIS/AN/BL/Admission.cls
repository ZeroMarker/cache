/// HIS就诊信息
Class CIS.AN.BL.Admission Extends %RegisteredObject
{

/// Creator：        ypz
/// CreatDate：      2010-03-12
/// Description：    查找病区病人:有wardId直接找病人,无则根据ctlocId则找病人:是病区直接找病人,是科室找关联病区的病人
/// Table：          PA_Adm,PA_Patmas,PAC_Ward,PAC_Bed
/// Input：          wardId病区ID,ctlocId医生/护士科室ID
/// Output：       
/// Return：         返回以"^"分割的病人信息串，病人信息:就诊号EpisodeID_"|"_床位bedCode_"|"_病人姓名patName
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

/// Creator：        陈长青
/// CreatDate：      2017-2-27
/// Description：    查询病人诊断信息
/// Table：          MR_Diagnos,MR_DiagType
/// Input:          EpisodeID:病人就诊ID
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.Admission","FindAdmDiagnosis","301","C008")
Query FindAdmDiagnosis(EpisodeID As %String, diagType As %String) As %Query(ROWSPEC = "RowId,ICDCode,ICDCodeDesc,DiagnosisType,DiagnosisTypeCode,DiagnosisTypeDesc,DiagnosNote,DiagID,DiagDesc") [ SqlProc ]
{
}

ClassMethod FindAdmDiagnosisExecute(ByRef qHandle As %Binary, EpisodeID As %String, diagType As %String) As %Status
{
    s repid=$i(^CacheTemp)
    i $g(ind)="" s ind=1
    k ^TMPANDiagon($j)
    set MRAdmID=$piece(^PAADM(EpisodeID),"^",61)
    set admDiagnosID=0
    set PreDiagConfig=##class(CIS.AN.BL.DataConfiguration).GetValueByKey("PreDiagConfig")
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
        set Sequence=$P(^MR(MRAdmID,"DIA",admDiagnosID,"EPR"),"^",2)
        for
        {
            set admDiagTypeID=$order(^MR(MRAdmID,"DIA",admDiagnosID,"TYP",admDiagTypeID))
            quit:(admDiagTypeID="")
            set diagTypeID=$piece(^MR(MRAdmID,"DIA",admDiagnosID,"TYP",admDiagTypeID),"^",1)
            set diagTypeCode=$piece($get(^MRC("DTYP",+diagTypeID)),"^",1)
            set diagTypeDesc=$piece($get(^MRC("DTYP",+diagTypeID)),"^",2)
            //根据手术申请配置选择取主诊断或全部诊断 20201127 YuanLin
            set MainDiagFlag=$p($g(^MR(MRAdmID,"DIA",admDiagnosID,1)),"^",20)
            continue:(PreDiagConfig="Y")&(PreDiagConfig'=MainDiagFlag)
            //continue:(("^"_diagType_"^")'[(diagTypeCode))&(diagType'="")
            if (Sequence="")
            {
	            s Data=$lb(MRDiagnosID,ICDID,ICDDesc,MRDiagnosID_"||"_admDiagTypeID,diagTypeCode,diagTypeDesc,diagnosNote,ICDID,ICDDesc)
            	do OutputRow  
            } 
            else
            {
	            set ^TMPANDiagon($j,Sequence)=$lb(MRDiagnosID,ICDID,ICDDesc,MRDiagnosID_"||"_admDiagTypeID,diagTypeCode,diagTypeDesc,diagnosNote,ICDID,ICDDesc)
	        } 
        }
    }
    set se=""
    for
    {
	    set se=$O(^TMPANDiagon($j,se))
	    quit:(se="")
	    set Data=^TMPANDiagon($j,se)
	    do OutputRow  
	}
    k ^TMPANDiagon($j)
    s qHandle=$lb(0,repid,0)
    q $$$OK

OutputRow
    ;s Data=$lb(MRDiagnosID,ICDID,ICDDesc,MRDiagnosID_"||"_admDiagTypeID,diagTypeCode,diagTypeDesc,diagnosNote,ICDID,ICDDesc)
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
    i ind="" {              // if there are no more rows, finish fetching
    s AtEnd=1
    s Row=""
    }
    else      {             // fetch row
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

/// Creator：        陈长青
/// CreatDate：      2017-2-28
/// Description：    查询诊断字典
/// Table：          MRC_ICDx
/// Input:          EpisodeID:病人就诊ID
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.Admission","FindMRCDiagnosis","阿米巴阑尾炎","151")
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.Admission","FindMRCDiagnosis","关节")
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.Admission","FindMRCDiagnosis","jgj")
Query FindMRCDiagnosis(filterDesc As %String, filterDiagId As %String = "") As %Query(ROWSPEC = "RowId,Description,ICDCode,ICDDesc") [ SqlProc ]
{
}

ClassMethod FindMRCDiagnosisExecute(ByRef qHandle As %Binary, filterDesc As %String, filterDiagId As %String = "") As %Status
{
    s repid=$i(^CacheTemp)
    i $g(ind)="" s ind=1
    
    if (filterDiagId'="")&($d(^MRC("ID",+filterDiagId)))
    {
	    set diagId=filterDiagId
	    set diagDesc=$piece(^MRC("ID",diagId),"^",2)
	    set ICDCode=$piece(^MRC("ID",diagId),"^",4)
	    set ICDDesc=diagDesc
	    do OutputRow
	    s qHandle=$lb(0,repid,0)
        q $$$OK 
	}
	b //ccq
    
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
        //set:(diagDesc [ filterDesc) ifFind=1
        set:($System.SQL.ALPHAUP(diagDesc) [ filterDesc) ifFind=1
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
    i ind="" {              // if there are no more rows, finish fetching
    s AtEnd=1
    s Row=""
    }
    else      {             // fetch row
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

/// Creator：        陈长青
/// CreatDate：      2016-12-29
/// Description：    查询安全组
/// Table：          SS_Group
/// Input:          filterDesc:安全组名称筛选字符串
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.Admission","FindGroup","demo")
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
        set SSGRPActiveFlag=$piece(^SSU("SSGRP",groupId),"^",151)
        continue:(SSGRPActiveFlag="N")
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
    i ind="" {              // if there are no more rows, finish fetching
    s AtEnd=1
    s Row=""
    }
    else      {             // fetch row
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

ClassMethod GetMedicareNo(papmiId As %String, EpisodeID As %String) As %String [ SqlProc ]
{
	set instance=..GetInstance(EpisodeID)
	set result=""
	
	if $IsObject(instance) set result=instance.MedcareNo
	else  set result=..GetMedicareNoOld(papmiId,EpisodeID)
	
	quit result
}

ClassMethod GetMedicareNoOld(papmiId, EpisodeID) As %String [ SqlProc ]
{
    q:(papmiId="")&(EpisodeID="") ""
    i papmiId="" s papmiId=+$g(^PAADM(+EpisodeID))
    q:papmiId="" ""
    s medicareNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)
    //s tmpMedicareNo=##Class(web.DHCWMRService).IGetMrNoByEpisodeID(EpisodeID) //2010用
    s MedType=$P($g(^PAADM(EpisodeID)),"^",2)
	s tmpMedicareNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID,MedType,.ErrMsg)
	set:(+tmpMedicareNo>0) medicareNo=tmpMedicareNo //2010用
    q medicareNo
}

// w ##class(web.DHCClinicCom).GetPatLevelByPapmiId(9)

ClassMethod GetPatLevelByPapmiId(AdmRowId) As %String [ SqlProc ]
{
    s PAPMIRowId=+$g(^PAADM(+AdmRowId))
    q:PAPMIRowId="" ""
    s ret=""
    s flag=1    ;控制是否带入密级
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

ClassMethod GetMedCareNo(EpisodeID As %String) As %String [ SqlProc ]
{
	set instance=..GetInstance(EpisodeID)
	set result=""
	
	if $IsObject(instance) set result=instance.MedcareNo
	else  set result=..GetMedCareNoOld(EpisodeID)
	
	quit result
}

ClassMethod GetMedCareNoOld(EpisodeID As %String) As %String [ SqlProc ]
{
	s PatientID=$P($g(^PAADM(EpisodeID)),"^",1)
	s MedType=$P($g(^PAADM(EpisodeID)),"^",2)
	//s MrNo=$P(^PAPER(PatientID,"PAT",1),"^",22)
	s MrNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID,MedType,.ErrMsg)
	//q:(MrNo'="") MrNo
    //s MrNo =##Class(web.DHCWMRService).IGetMrNoByEpisodeID(EpisodeID)
    s:+MrNo'>0 MrNo=""
    q MrNo
}

/// Creator：        陈长青
/// CreatDate：      2017-1-3
/// Description：    查询病人
/// Table：          PA_PatMas,PA_Adm
/// Input:          EpisodeID：病人就诊RowId
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.Admission","FindPatient","18")
Query FindPatient(EpisodeID As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT %ID As EpisodeID,
       PAADM_PAPMI_DR As PatientID,
       PAADM_PAPMI_DR->PAPMI_Name As PatName,
       PAADM_PAPMI_DR->PAPMI_IPNo As RegNo,
       PAADM_PAPMI_DR->PAPMI_ID As CardID,
       PAADM_PAPMI_DR->PAPMI_PAPER_DR->PAPER_TelH As MobPhone,
       CIS_AN_BL.Admission_GetMedcareNo(:EpisodeID)_"" As MedcareNo,
       CIS_AN_BL.Admission_GetMedcareNo(:EpisodeID)_"" As MedicareNo,
       PAADM_PAPMI_DR->PAPMI_DOB As PatDOBH,
       %ODBCOUT(PAADM_PAPMI_DR->PAPMI_DOB) As PatDOB,
       CIS_AN_COM.DateTime_CalAge(PAADM_PAPMI_DR->PAPMI_DOB,+$h) As PatAge,
       PAADM_PAPMI_DR->PAPMI_Sex_DR->CTSEX_Desc As PatGender,
       PAADM_AdmDate As AdmDateH,
       CIS_AN_COM.DateTime_ConvertToDate(PAADM_AdmDate,'') As AdmDate,
       CIS_AN_COM.DateTime_ConvertToTime(PAADM_AdmTime,'') As AdmTime,
       CIS_AN_COM.DateTime_ConvertToDateTime(PAADM_AdmDate,PAADM_AdmTime,'') As AdmDT,
       PAADM_Type As AdmType,
       %EXTERNAL(PAADM_Type) As AdmTypeDesc,
       CIS_AN_COM.DateTime_ConvertToDate(PAADM_DischgDate,'') As DischargeDate,
       CIS_AN_COM.DateTime_ConvertToTime(PAADM_DischgTime,'') As DischargeTime,
       CIS_AN_COM.DateTime_ConvertToDateTime(PAADM_DischgDate,PAADM_DischgTime,'') As DischargeDT,
       PAADM_VisitStatus As VisitStatus,
       %EXTERNAL(PAADM_VisitStatus) As VisitStatusDesc,
       PAADM_AdmReason_DR As AdmReasonID,
       PAADM_AdmReason_DR->REA_Desc As AdmReason,
       PAADM_DepCode_DR As PatDeptID,
       PAADM_DepCode_DR->CTLOC_Desc As PatDept,
       PAADM_DepCode_DR->CTLOC_Desc As PatDeptDesc,
       PAADM_CurrentWard_DR As PatWardID,
       PAADM_CurrentWard_DR->WARD_Desc As PatWard,
       PAADM_CurrentWard_DR->WARD_Desc As PatWardDesc,
       PAADM_CurrentBed_DR As PatBedID,
       PAADM_CurrentBed_DR->BED_Code As PatBed,
       PAADM_CurrentBed_DR->BED_Code As PatBedCode,
       CIS_AN_COM.String_GetDescBySplitChar(CIS_AN_BL.Admission_GetPatLevelByPapmiId(%ID),'^',2) As PatSecretLevel,
       CIS_AN_COM.String_GetDescBySplitChar(CIS_AN_BL.Admission_GetPatLevelByPapmiId(%ID),'^',4) As PatSecretCode,
       PAADM_MainMRADM_DR As MRAdmID
       From SQLUser.PA_Adm
       where (%ID=:EpisodeID)
}

/// Creator：        yongyang
/// CreatDate：      2021-12-20
/// Description：    查询病人
/// Table：          CIS.AN.Patient,CIS.AN.Admission
/// Input:           EpisodeID：病人就诊RowId
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.Admission","FindPatient","18")
Query FindPatientNew(EpisodeID As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT EpisodeID As EpisodeID,
       Patient->PatientID As PatientID,
       Patient->FullName As PatName,
       Patient->RegNo As RegNo,
       Patient->CardID As CardID,
       Patient->TelephoneNo As MobPhone,
       MedcareNo As MedcareNo,
       MedcareNo As MedicareNo,
       Patient->DOB As PatDOBH,
       %ODBCOUT(Patient->DOB) As PatDOB,
       CIS_AN_COM.DateTime_CalAge(Patient->DOB,+$h) As PatAge,
       Patient->Sex->Description As PatGender,
       AdmDate As AdmDateH,
       CIS_AN_COM.DateTime_ConvertToDate(AdmDate,'') As AdmDate,
       CIS_AN_COM.DateTime_ConvertToTime(AdmTime,'') As AdmTime,
       CIS_AN_COM.DateTime_ConvertToDateTime(AdmDate,AdmTime,'') As AdmDT,
       Type As AdmType,
       %EXTERNAL(Type) As AdmTypeDesc,
       CIS_AN_COM.DateTime_ConvertToDate(DischargeDate,'') As DischargeDate,
       CIS_AN_COM.DateTime_ConvertToTime(DischargeTime,'') As DischargeTime,
       CIS_AN_COM.DateTime_ConvertToDateTime(DischargeDate,DischargeTime,'') As DischargeDT,
       VisitStatus As VisitStatus,
       %EXTERNAL(VisitStatus) As VisitStatusDesc,
       "" As AdmReasonID,
       AdmReason As AdmReason,
       Department As PatDeptID,
       CIS_AN_COM.String_GetDescByID("User.CTLoc","CTLOCCode",Department) As PatDept,
       CIS_AN_COM.String_GetDescByID("User.CTLoc","CTLOCCode",Department) As PatDeptDesc,
       Ward As PatWardID,
       CIS_AN_COM.String_GetDescByID("User.PACWard","WARDDesc",Ward) As PatWard,
       CIS_AN_COM.String_GetDescByID("User.PACWard","WARDDesc",Ward) As PatWardDesc,
       Bed As PatBedID,
       CIS_AN_COM.String_GetDescByID("User.PACBed","BEDCode",Bed) As PatBed,
       CIS_AN_COM.String_GetDescByID("User.PACBed","BEDCode",Bed) As PatBedCode,
       Patient->SecretLevel As PatSecretLevel,
       Patient->SecretCode As PatSecretCode,
       EpisodeID As MRAdmID
       From CIS_AN.Admission
       where (EpisodeID=:EpisodeID)
}

/// Creator：        陈长青
/// CreatDate：      2017-1-4
/// Description：    查询科室
/// Table：          CT_LocationList_Locations
/// Input:          filterDesc:筛选字符串,locList:科室列表代码
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.Admission","FindLocationOld","","INOPDEPT","2")
Query FindLocationOld(filterDesc As %String, locList As %String = "OP^EMOP^OUTOP", hospId As %String = "") As %SQLQuery(CONTAINID = 1)
{
SELECT distinct LOC_CTLOC_DR As RowId,
       LOC_CTLOC_DR->CTLOC_Code As Code,
       CIS_AN_COM.String_GetTranslationByBDP("User.CTLoc","CTLOCDesc",LOC_CTLOC_DR) As Description,
       LOC_CTLOC_DR->CTLOC_Hospital_DR As HospID,
       LOC_CTLOC_DR->CTLOC_Hospital_DR->HOSP_Desc As HospDesc,
       LOC_CTLOC_DR->CTLOC_ContactName As Alias
      
       from SQLUser.CT_LocationList_Locations
       where ((UPPER(LOC_CTLOC_DR->CTLOC_Desc) like UPPER('%'_:filterDesc_'%')) or (:filterDesc is null) or (UPPER(LOC_CTLOC_DR->CTLOC_ContactName) [ UPPER(:filterDesc)))
       and (not LOC_CTLOC_DR->CTLOC_Code is null)
       and (LOC_CTLOC_DR->CTLOC_Code<>'')
       and (not LOC_CTLOC_DR->CTLOC_Desc is null)
       and (LOC_CTLOC_DR->CTLOC_Desc<>'')
       and ((UPPER('^'_:locList_'^') [ UPPER('^'||LOC_ParRef->LL_Code||'^')) or :locList is null)
}

/// Creator：        陈长青
/// CreatDate：      2017-1-4
/// Description：    查询科室
/// Table：          CT_LocationList_Locations
/// Input:          filterDesc:筛选字符串,locList:科室列表代码
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.Admission","FindLocationOld","")
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

/// Creator：        雍阳
/// CreatDate：      2018-9-26
/// Description：    查询科室
/// Table：          CF_AN.Location
/// Input:          filterDesc:筛选字符串,locList:科室列表代码
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.Admission","FindLocation","","INOPDEPT^EMOPDEPT^OUTOPDEPT^AN^OUTAN^EMAN")
Query FindLocation(filterDesc As %String, locList As %String = "E^O", needActive As %String = "N", hospId As %String = "") As %SQLQuery(CONTAINID = 1)
{
SELECT %Id As RowId,
       CTLOC_Code As Code,
       CTLOC_Desc As Description,
       CTLOC_ActiveFlag As Active,
       CTLOC_Type As LocType
       from SQLUser.CT_LOC
       where ((UPPER(CTLOC_Desc) [ UPPER(:filterDesc)) or (UPPER(CTLOC_ContactName) [ UPPER(:filterDesc)) or (:filterDesc is null))
       and (UPPER('^'_:locList_'^') [ UPPER(STRING('^',CTLOC_Type,'^')))
       and (((CTLOC_DateActiveFrom<=+$h) and (CTLOC_DateActiveTo>=+$h or CTLOC_DateActiveTo is null)) or (:needActive<>"Y"))
       and ((CTLOC_Hospital_DR=:hospId) or (:hospId is null))
}

// d ##class(%ResultSet).RunQuery("CIS.AN.BL.Admission","FindLocList","","INOPDEPT^EMOPDEPT^OUTOPDEPT^AN^OUTAN^EMAN","")

Query FindLocList(desc As %String, locListCodeStr As %String = "", EpisodeID As %String = "") As %Query(ROWSPEC = "RowId,Code,Description,Active,LocType") [ SqlProc ]
{
}

ClassMethod FindLocListExecute(ByRef qHandle As %Binary, desc As %String, locListCodeStr As %String = "INOPDEPT", EpisodeID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	;转吧，汉字不方便
	s find=0
	s desc=##class(web.DHCClinicCom).GetChinaChar(desc)
	s desc=$$ALPHAUP^SSUTIL4(desc)
	s locListCodeStr=##class(web.DHCClinicCom).AdjustLocListCode(locListCodeStr,EpisodeID)
	s ctlocIdList=##class(web.DHCClinicCom).GetLocIdByLocListCode(locListCodeStr)
	f i=1:1:$l(ctlocIdList,"^") d
		.s ctlocId=$p(ctlocIdList,"^",i)
		.q:ctlocId=""
		.q:'$d(^CTLOC(ctlocId))
		.s ctlocDesc=$p(^CTLOC(ctlocId),"^",2)
		.q:(desc'="")&($$ALPHAUP^SSUTIL4(##class(web.DHCClinicCom).GetChinaChar(ctlocDesc))'[desc)
		.s ctlocCode=$p(^CTLOC(ctlocId),"^",1)
		.s find=1
		.Do OutputRow6
	i (find=0)!(ctlocIdList="") d
		.s ctlocrowid="" f  s ctlocrowid=$o(^CTLOC(ctlocrowid)) q:ctlocrowid=""  d
			..q:'$d(^CTLOC(ctlocrowid))
			..;b	;in
			..s ctlocDesc=$p(^CTLOC(ctlocrowid),"^",2)
			..;w ##class(web.DHCClinicCom).GetChinaChar(ctlocDesc)_"/"
			..q:(desc'="")&($$ALPHAUP^SSUTIL4(##class(web.DHCClinicCom).GetChinaChar(ctlocDesc))'[desc)
			..s ctlocId=ctlocrowid
			..Do OutputRow6	 
			
    s hospitalId=$p(^CTLOC(ctlocId),"^",22)
	s hospital=""
	i (hospitalId'="") s hospital=$p($g(^CT("HOSP",hospitalId)),"^",2)	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow6
	set Data=$lb(ctlocId,ctlocCode,ctlocDesc,"","")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod FindLocListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindLocListExecute ]
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

ClassMethod FindLocListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindLocListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator：        雍阳
/// CreatDate：      2018-9-26
/// Description：    查询科室
/// Table：          CF_AN.Location
/// Input:          filterDesc:筛选字符串,locList:科室列表代码
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.Admission","FindLocation","","INOPDEPT^EMOPDEPT^OUTOPDEPT^AN^OUTAN^EMAN")
Query FindLocationCL(filterDesc As %String, locList As %String = "E") As %SQLQuery(CONTAINID = 1)
{
SELECT *
       from CF_AN.Location
       where ((UPPER(Description) like UPPER('%'_:filterDesc_'%')) or (:filterDesc is null))
       and (UPPER('^'_:locList_'^') [ UPPER('^'||LocType||'^'))
}

/// Creator：        陈长青
/// CreatDate：      2017-1-6
/// Description：    查询ICD诊断字典
/// Table：          MRC_ICDDx,MRC_ICDAlias
/// Input:          filterDesc:筛选字符串
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("DHCAN.Admission","FindICDDiagnosis","ab")
Query FindICDDiagnosis(filterDesc As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT distinct MRCID_RowId As RowId,
       MRCID_Code As Code,
       MRCID_Desc As Description
       From SQLUser.MRC_ICDDx As Diag inner join SQLUser.MRC_ICDAlias As Alias on Diag.MRCID_RowId=Alias.ALIAS_ParRef
       where ((Diag.MRCID_Desc like UPPER('%'_:filterDesc_'%')) or (Alias.ALIAS_Text like UPPER('%'_:filterDesc_'%')))
}

/// Creator：        陈长青
/// CreatDate：      2017-1-6
/// Description：    根据科室ID查询科室医护人员
/// Table：          RB_Resource
/// Input:          filterDesc:筛选字符串,locId:科室ID
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.Admission","FindCareProv","","95")
Query FindCareProv(filterDesc As %String, locId As %String = "") As %SQLQuery(CONTAINID = 1)
{
SELECT RES_CTPCP_DR As RowId,
	   RES_CTLOC_DR->CTLOC_Desc As Location,
	   %ID As ResourceID,
       RES_CTLOC_DR As LocationID,
       RES_CTPCP_DR->CTPCP_Desc As Description,
       ((RES_CTPCP_DR->CTPCP_Desc)_'('_(RES_CTLOC_DR->CTLOC_Desc)_')') As ProvLoc,
       RES_CTPCP_DR->CTPCP_OtherName As ShortDesc,
       CIS_AN_BL.Admission_GetUserIDByCareProv(RES_CTPCP_DR) As UserId
       From SQLUser.RB_Resource
       where ((RES_CTLOC_DR=:locId) or (:locId is null))
       and (RES_CTPCP_DR->CTPCP_ActiveFlag='Y')
       and ((RES_CTPCP_DR->CTPCP_Desc like (:filterDesc_"%")) or (RES_CTPCP_DR->CTPCP_OtherName like (UPPER(:filterDesc)_'%')) or (:filterDesc is null))
       group by RES_CTPCP_DR,RES_CTLOC_DR
       order by ShortDesc
}

/// Creator：        杨国宾
/// CreatDate：      2021-7-23
/// Description：    根据科室ID查询科室医护人员(去掉重复项)
/// Table：          RB_Resource
/// Input:          filterDesc:筛选字符串,locId:科室ID
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.Admission","FindCareProvSingle","","95")
Query FindCareProvSingle(filterDesc As %String, locId As %String = "") As %SQLQuery(CONTAINID = 1)
{
SELECT RES_CTPCP_DR As RowId,
	   RES_CTLOC_DR->CTLOC_Desc As Location,
	   %ID As ResourceID,
       RES_CTLOC_DR As LocationID,
       RES_CTPCP_DR->CTPCP_Desc As Description,
       ((RES_CTPCP_DR->CTPCP_Desc)_'('_(RES_CTLOC_DR->CTLOC_Desc)_')') As ProvLoc,
       RES_CTPCP_DR->CTPCP_OtherName As ShortDesc,
       CIS_AN_BL.Admission_GetUserIDByCareProv(RES_CTPCP_DR) As UserId
       From SQLUser.RB_Resource
       where ((RES_CTLOC_DR=:locId) or (:locId is null))
       and (RES_CTPCP_DR->CTPCP_ActiveFlag='Y')
       and ((RES_CTPCP_DR->CTPCP_Desc like (:filterDesc_"%")) or (RES_CTPCP_DR->CTPCP_OtherName like (UPPER(:filterDesc)_'%')) or (:filterDesc is null))
       group by RES_CTPCP_DR->CTPCP_Desc
       order by ShortDesc
}

/// Creator：        陈长青
/// CreatDate：      2017-1-6
/// Description：    根据科室ID查询科室医护人员
/// Table：          RB_Resource
/// Input:          filterDesc:筛选字符串,locId:科室ID
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.Admission","FindCareProvByLoc","","298")
Query FindCareProvByLocOld(filterDesc As %String = "", locId As %String, ifAnaesthetist As %String = "") As %SQLQuery(CONTAINID = 1)
{
SELECT %ID As ResourceID,
       RES_CTLOC_DR As LocationID,
       RES_CTLOC_DR->CTLOC_Desc As Location,
       RES_CTPCP_DR As RowId,
       RES_CTPCP_DR->CTPCP_Desc As Description,
       RES_CTPCP_DR->CTPCP_OtherName As ShortDesc,
       $EXTRACT(RES_CTPCP_DR->CTPCP_OtherName,1) As FirstChar,
       CIS_AN_BL.Admission_GetUserIDByCareProv(RES_CTPCP_DR) As UserId
       From SQLUser.RB_Resource
       where (RES_CTLOC_DR=:locId)
       and (RES_CTPCP_DR->CTPCP_ActiveFlag='Y')
       and (RES_CTPCP_DR->CTPCP_Anaesthetist=:ifAnaesthetist or :ifAnaesthetist is null)
	   and (RES_DateActiveFrom<=+$h and (RES_DateActiveTo>=+$h or RES_DateActiveTo is null))
	   and (RES_CTPCP_DR->CTPCP_DateActiveFrom<=+$h and (RES_CTPCP_DR->CTPCP_DateActiveTo>=+$h or RES_CTPCP_DR->CTPCP_DateActiveTo is null))
       and ((RES_CTPCP_DR->CTPCP_Desc [ UPPER(:filterDesc)) or (RES_CTPCP_DR->CTPCP_OtherName like (UPPER(:filterDesc)_'%')) or (:filterDesc is null))
       order by ShortDesc
}

/// Creator：        雍阳
/// CreatDate：      2020-6-24
/// Description：    根据科室ID查询科室医护人员，合并院外人员表
/// Table：          RB_Resource, CF_AN.CareProvider
/// Input:           filterDesc:筛选字符串,locId:科室ID
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.Admission","FindCareProvByLoc","","298")
Query FindCareProvByLoc(filterDesc As %String = "", locId As %String, ifAnaesthetist As %String = "", internalType As %String = "", docId As %String = "") As %SQLQuery(CONTAINID = 1)
{
SELECT %ID As ResourceID,
       RES_CTLOC_DR As LocationID,
       RES_CTLOC_DR->CTLOC_Desc As Location,
       RES_CTPCP_DR As RowId,
	   CIS_AN_COM.String_GetDescByID('User.CTCareProv','CTPCPDesc',RES_CTPCP_DR) As Description,
       RES_CTPCP_DR->CTPCP_OtherName As ShortDesc,
       $EXTRACT(RES_CTPCP_DR->CTPCP_OtherName,1) As FirstChar,
       CIS_AN_BL.Admission_GetUserIDByCareProv(RES_CTPCP_DR) As UserId,
       CIS_AN_BL.Admission_GetUserInitialsByCareProv(RES_CTPCP_DR) As UserInitials,
       CIS_AN_BL.Admission_GetUserTagByCareProv(RES_CTPCP_DR) As UserTags
       From SQLUser.RB_Resource
       where (RES_CTLOC_DR=:locId)
       and (RES_CTPCP_DR->CTPCP_ActiveFlag='Y')
       and (RES_CTPCP_DR->CTPCP_Anaesthetist=:ifAnaesthetist or :ifAnaesthetist is null)
       and (RES_CTPCP_DR->CTPCP_CarPrvTp_DR->CTCPT_InternalType=:internalType or :internalType is null)
	   and (RES_DateActiveFrom<=+$h and (RES_DateActiveTo>=+$h or RES_DateActiveTo is null))
	   and (RES_CTPCP_DR->CTPCP_DateActiveFrom<=+$h and (RES_CTPCP_DR->CTPCP_DateActiveTo>=+$h or RES_CTPCP_DR->CTPCP_DateActiveTo is null))
       and ((RES_CTPCP_DR->CTPCP_Desc [ UPPER(:filterDesc)) or (RES_CTPCP_DR->CTPCP_OtherName like (UPPER(:filterDesc)_'%')) or (:filterDesc is null))
       and (RES_CTPCP_DR!=:docId or :docId is null)
UNION ALL
SELECT "" AS ResourceID,
	   c.Dept As LocationID,
       d.CTLOC_Desc As Location,
       b.FullName As RowId,
       b.FullName As Description,
       b.Alias As ShortDesc,
       $EXTRACT(b.Alias,1) As FirstChar,
       "" As UserId,
       "" As UserInitials,
       "" As UserTags
       From CF_AN.CareProvider AS b
       LEFT JOIN CF_AN.Resource AS c on c.CareProvider = b.RowId
       LEFT JOIN SQLUser.CT_Loc AS d ON c.Dept = d.CTLOC_RowID
       WHERE c.Dept=:locId
       and b.Active='Y'
       and ((NOT b.Surgeon=:ifAnaesthetist) or :ifAnaesthetist is null)
       and (b.ActiveDate<=+$h and (b.ExpireDate>=+$h or b.ExpireDate is null))
       and ((b.FullName [ UPPER(:filterDesc)) or (b.Alias like (UPPER(:filterDesc)_'%')) or (:filterDesc is null))
       order by ShortDesc
}

/// Creator：        陈长青
/// CreatDate：      2017-1-6
/// Description：    根据科室ID查询科室医护人员
/// Table：          RB_Resource
/// Input:          filterDesc:筛选字符串,locId:科室ID
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("DHCAN.Admission","FindCareProvByLoc","c","6")
Query FindWard(filterDesc As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT %ID As RowId,
       WARD_Code As Code,
       CIS_AN_COM.String_GetTranslationByBDP("User.PACWard","WARDDesc",%ID) As Description,
       WARD_LocationDR As WardDeptID,
       WARD_LocationDR->CTLOC_ContactName As Alias
       From SQLUser.PAC_Ward
       where (WARD_Desc [ :filterDesc) or (:filterDesc is null)
}

/// Creator：        陈长青
/// CreatDate：      2017-2-21
/// Description：    查询医嘱项
/// Table：          ARC_ItmMast,ARC_Alias
/// Input:          filterDesc:筛选字符串
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.Admission","FindMasterItem","","11486||1")
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

/// Creator：        陈长青
/// CreatDate：      2017-11-8
/// Description：    查询药品等价单位
/// Table：          PHC_FormDoseEquiv
/// Input:          drgFormId:药学项ID
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.Admission","FindDoseEquiv","")
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

/// Creator：        陈长青
/// CreatDate：      2017-2-22
/// Description：    查询医护人员类型
/// Table：          CT_CarPrvTp
/// Input:          
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("DHCAN.Admission","FindCPType")
Query FindCPType() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID As RowId,
       CTCPT_Code As Code,
       CTCPT_Desc As Description
       From SQLUser.CT_CarPrvTp
}

/// Creator：        陈长青
/// CreatDate：      2017-2-22
/// Description：    查询科室就诊类型
/// Table：          PAC_AdmTypeLocation
/// Input:          deptID:科室ID
/// Return：         ResultSet
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

ClassMethod GetDeptAdmType(deptID As %String) As %String
{
    set retAdmType=""
    quit:(##class(User.CTLoc).%ExistsId(deptID)=0) retAdmType
    set rs=##class(%ResultSet).%New("CIS.AN.BL.Admission:FindDeptAdmType")
    set sc=rs.Execute(deptID)
    while(rs.%Next())
    {
        set curDeptID=rs.Get("DeptID")
        set:(curDeptID=deptID) retAdmType=rs.Get("AdmType")
        quit:(retAdmType'="")   
    }
    
    quit retAdmType
}

/// Creator：        陈长青
/// CreatDate：      2017-4-6
/// Description：    查询HIS单位
/// Table：          CT_UOM
/// Input:          filterDesc:筛选字符串
/// Return：         ResultSet
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

/// Creator：        陈长青
/// CreatDate：      2017-5-15
/// Description：    根据就诊ID判断就诊记录是否存在
/// Table：          PA_Adm
/// Input:          EpisodeID:就诊ID
/// Return：         如果存在返回Y，不存在返回N
/// Debug:          w ##class(CIS.AN.BL.Admission).ExistsEpisode("112233")
ClassMethod ExistsEpisode(EpisodeID As %String) As %String
{
    set isExists=##class(User.PAAdm).%ExistsId(EpisodeID)
    set result=$case(isExists,
                     1:"Y",
                     0:"N")
    quit result
}

/// Creator:        杨勤
/// CreatDate:      2017-07-21
/// Description:    根据UserId获取医护人员ID
/// Table:          SS_User
/// Input:          userID
/// Return:         CT_CareProv的RowId,医护人员ID
/// Debug           w ##class(CIS.AN.BL.Admission).GetCareProv("6463")
ClassMethod GetCareProv(userID) As %String [ SqlProc ]
{
    quit:(userID="") ""
    set careProvID=""
    &sql(SELECT SSUSR_CareProv_DR into :careProvID FROM SQLUSER.SS_User WHERE SSUSR_RowId=:userID)
    i SQLCODE q ""

    quit careProvID
}

/// Creator:        杨勤
/// CreatDate:      2017-07-21
/// Description:    根据UserId获取医护人员ID
/// Table:          SS_User
/// Input:          userID
/// Return:         CT_CareProv的RowId,医护人员ID
/// Debug           w ##class(CIS.AN.BL.Admission).GetUserIDByCareProv("37")
ClassMethod GetUserIDByCareProv(careProvID As %String) As %String [ SqlProc ]
{
    quit:(careProvID="") ""
    set userId=""
    &sql(SELECT SSUSR_RowId into :userId FROM SQLUSER.SS_User WHERE SSUSR_CareProv_DR=:careProvID)
    i SQLCODE q ""

    quit userId
}

/// Creator:        杨勤
/// CreatDate:      2017-07-21
/// Description:    根据UserId获取医护人员ID
/// Table:          SS_User
/// Input:          userID
/// Return:         CT_CareProv的RowId,医护人员ID
/// Debug           w ##class(CIS.AN.BL.Admission).GetUserIDByCareProv("37")
ClassMethod GetUserInitialsByCareProv(careProvID As %String) As %String [ SqlProc ]
{
    quit:(careProvID="") ""
    set userId=$o(^SSU("SSUSR",0,"CTPCP",careProvID,0))
	set userInitials=$p($g(^SSU("SSUSR",+userId)),"^",1)
    quit userInitials
}

/// Creator:        yongyang
/// CreatDate:      2021-04-19
/// Description:    根据careProvID获取医护人员标签
/// Table:          SS_User,SS_Group
/// Input:          careProvID
/// Return:         标签:
/// Debug           w ##class(CIS.AN.BL.Admission).GetUserTagByCareProv("37")
ClassMethod GetUserTagByCareProv(careProvID As %String) As %String [ SqlProc ]
{
    quit:(careProvID="") ""
    set userId="",group=""
    &sql(SELECT SSUSR_RowId,SSUSR_Group->SSGRP_Desc into :userId,:group FROM SQLUSER.SS_User WHERE SSUSR_CareProv_DR=:careProvID)
    i SQLCODE q ""
	set result=""
	i group["麻醉护士" set result=result_$lb("麻醉护士")
	i group["手术室护士" set result=result_$lb("手术护士")
	
    quit $LISTTOSTRING(result,",")
}

/// Creator:        杨勤
/// CreatDate:      2017-07-21
/// Description:    根据医护人员ID获取医护人员类型
/// Table:          CT_CareProv
/// Input:          userID
/// Return:         医护人员类型ID
/// Debug           w ##class(CIS.AN.BL.Admission).GetCareProvType(548)
ClassMethod GetCareProvType(careProvID) As %String [ SqlProc ]
{
    quit:(careProvID="") ""
    &sql(SELECT CTPCP_CarPrvTp_DR into :careProvTpId FROM SQLUSER.CT_CareProv WHERE CTPCP_RowId1=:careProvID)
    i SQLCODE q ""

    quit careProvTpId
}

/// Creator：        陈长青
/// CreatDate：      2017-11-09
/// Description：    查询药品用法
/// Table：          PHC_Instruc
/// Input:          filterDesc:筛选字符串
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("DHCAN.Admission","FindInstruction","53")
Query FindInstruction(filterDesc As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT %ID As RowId,
       PHCIN_Code As Code,
       PHCIN_Desc1 As Description,
       PHCIN_Desc2 As ForeignDesc
       From SQLUser.PHC_Instruc
       where (UPPER(PHCIN_Desc1) [ UPPER(:filterDesc)) or (:filterDesc is null)
       or (UPPER(PHCIN_Desc2) [ UPPER(:filterDesc))
}

ClassMethod GetReceiveLoc(opsId As %String, arcimId As %String) As %String
{
	quit:'##class(CIS.AN.OperSchedule).%ExistsId(opsId) ""
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	set EpisodeID=operSchedule.EpisodeID
	
	
	set recvLocId=+##class(web.DHCDocOrderCommon).GetRecloc(EpisodeID,arcimId)
    
    quit recvLocId
}

/// Creator：        陈长青
/// CreatDate：      2017-11-10
/// Description：    获取医嘱项的接收科室
/// Table：          
/// Input:          EpisodeID:就诊ID，locId:当前科室,arcimId:医嘱项ID
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("web.DHCClinicAdmission","FindRecvLoc","","","")
Query FindRecvLoc(EpisodeID As %String, locId As %String, arcimId As %String) As %Query(ROWSPEC = "Id,Desc")
{
}

ClassMethod FindRecvLocExecute(ByRef qHandle As %Binary, EpisodeID As %String, locId As %String, arcimId As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    
    s drugFormId=$p($g(^ARCIM($p(arcimId,"||",1),$p(arcimId,"||",2),1)),"^",12)
    if (drugFormId'="")
    {
        set recvLocStr=##class(web.DHCANCall).GetOrderItemRecloc("",arcimId,EpisodeID,locId)    
    }
    else
    {
        set recvLocId=locId
        set recvLocDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTLoc","CTLOCDesc",locId)
        do OutputRow
        set recvLocStr=##class(web.DHCANCall).GetOrderItemRecloc("",arcimId,"",locId)   
    }
    
    set locCount=$length(recvLocStr,"^")
    for i=1:1:locCount
    {
        set recvLocId=$piece(recvLocStr,$char(3),1)
        continue:(recvLocId="")
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
 If ind="" {                // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {                // fetch row
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
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.Admission","FindLocDocCurrentAdm","104","6463","","","","","","","","","on","","")
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.Admission","FindLocDocCurrentAdm","95","10209","","","","zl8006","","","on","","on","")
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.Admission","FindLocDocCurrentAdm","191","18881","","","","","","","","","on","","","")
Query FindLocDocCurrentAdm(LocID As %String, UserID As %String, IPAddress As %String, AllPatient As %String, PatientNo As %String, SurName As %String, StartDate As %Date, EndDate As %Date, ArrivedQue As %String, RegQue As %String, MedUnit As %String = "", PACWard As %String = "", BedId As %String = "", ChiefDoc As %String = "") As %Query(ROWSPEC = "PatientID:%String,EpisodeID:%String,MedicareNo As %String,mradm:%String,PAPMINO:%String,PAPMIName:%String,PAPMIDOB:%String,PAPMISex:%String,PAAdmDate:%Date,PAAdmTime:%Time,PAAdmNo:%String,PAAdmDepCodeDR:%String,PAAdmDocCodeDR:%String,PAAdmType:%String,Hospital:%String,PAAdmWard:%String,PAAdmBed:%String,FinancialDischargeFlag:%String,MedicalDischargeFlag:%String,FinalDischargeFlag:%String,PAAdmReason:%String,DischargeDate:%String,RegDoctor:%String,Diagnosis:%String,ArrivedDate:%String,ArrivedTime:%String,LeavedDate:%String,LeavedTime:%String,LocSeqNo:%String,PAAdmPriority:%String,WalkStatus:%String,ConsultRoom:%String,ConsultArea:%String,PAAdmReasonCode:%String,StatusCode:%String,Age:%String,PriorityCode:%String,Called:%String,RegDocDr:%String,patChiefDoc:%String")
{
}

ClassMethod FindLocDocCurrentAdmExecute(ByRef qHandle As %Binary, LocID As %String, UserID As %String, IPAddress As %String, AllPatient As %String, PatientNo As %String, SurName As %String, StartDate As %Date, EndDate As %Date, ArrivedQue As %String, RegQue As %String, MedUnit As %String = "", PACWard As %String = "", BedId As %String = "", ChiefDoc As %String = "") As %Status
{
    //PatientNo,SurName,CurrentDept,CurrentBed,CurrentWard,CurrentDoctor,StartDate,EndDate,CurrentAdmType
    //Set ^SMLPara=LocID_","_UserID_","_IPAddress_","_AllPatient_","_PatientNo_","_SurName_","_StartDate_","_EndDate_","_ArrivedQue _","_RegQue_","_MedUnit_","_PACWard_","_BedId
    //;
    //n (qHandle, LocID , UserID , IPAddress , AllPatient , PatientNo , SurName , StartDate , EndDate , ArrivedQue, RegQue, MedUnit, PACWard, BedId)
    If LocID="" Set LocID=%session.Get("LOGON.CTLOCID")
    //Set LocID=95
    If UserID="" Set UserID=%session.Get("LOGON.USERID")
    If LocID="" Quit $$$OK
    If UserID="" Quit $$$OK
    //
    //
    Set repid=$I(^CacheTemp)
    Set DocId=$p($g(^SSU("SSUSR",UserID)),"^",14)
    b ;2
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
    If ($g(PatientNo)'="") Do     //登记号查询
        .Set PatientNo=..GetPatientNo(PatientNo)
        .Set Singleflag=1
        .Set PAPMI=$O(^PAPERi("PAPMI_PatNo",PatientNo,""))
        .Quit:$g(PAPMI)=""
        .Do OutPAPMI
    If ($g(PatientNo)'="") Do     //病案号/住院号查询
        .Set PatientNo=..GetPatientNo(PatientNo)
        .Set Singleflag=1
        .Set PAPMI=$O(^PAPERi("Medicare1",PatientNo,""))
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
    If AllPatient="on"  Do 
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
    If ArrivedQue="on"  Do 
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
    .b ;21
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
    //  .Set DeptLst=$L(CurrentDept,$C(1))
    //  .For I=1:1:DeptLst Do
    //  ..Set DeptItem=$P(CurrentDept,$C(1),I)
    //  ..Do DeptPatList
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
    Set MedicareNo=##class(CIS.AN.BL.Admission).GetMedicareNo("",EpisodeID)
    Set mradm=$P(^PAADM(PAAdm),"^",61)
    //PAPMINO,PAPMIName,PAPMIDOB,PAPMISex
    Set PAPMINO=$P(^PAPER(PatientID,"PAT",1),"^",1)
    Set PAPMIName=$P(^PAPER(PatientID,"ALL"),"^",1)
    Set PAPMIDOB=$ZD($P(^PAPER(PatientID,"ALL"),"^",6),3)
    Set Sex=$P(^PAPER(PatientID,"ALL"),"^",7)
    set PAPMISex=##class(CIS.AN.COM.String).GetTranslationByBDP("User.CTSex","CTSEXDesc",Sex) //多语言改造翻译后台数据 YL 20221101
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
    //Set PAAdmDepCodeDR=##class(web.DHCDocInPatientList).RemoveAlias($P($g(^CTLOC(Loc)),"^",2))
	Set PAAdmDepCodeDR=##class(CIS.AN.COM.String).GetTranslationByBDP("User.CTLoc","CTLOCDesc",Loc)  //多语言改造翻译后台数据 YL 20221101
    Set Doctor=$P($g(^PAADM(PAAdm)),"^",9)
    If Doctor'="" Set PAAdmDocCodeDR=$P($g(^CTPCP(Doctor,1)),"^",2)
    Else  Set PAAdmDocCodeDR=""
    Set PAAdmType=$P($g(^PAADM(PAAdm)),"^",2)
    Set Hosp=$P($g(^CTLOC(Loc)),"^",22)
    If Hosp'="" Set Hospital=$P($g(^CT("HOSP",Hosp)),"^",2)
    Set WardDr=$P($g(^PAADM(PAAdm)),"^",70)
    //if WardDr'="" Set PAAdmWard=##class(web.DHCDocInPatientList).RemoveAlias($P($g(^PAWARD(WardDr)),"^",2))
	if WardDr'="" Set PAAdmWard=##class(CIS.AN.COM.String).GetTranslationByBDP("User.PACWard","WARDDesc",WardDr) //多语言改造翻译后台数据 YL 20221101
    else  Set PAAdmWard=""
    Set AdmBedId=$P($g(^PAADM(PAAdm)),"^",73)
    if AdmBedId'="" Set PAAdmBed=$P($g(^PAWARD(+AdmBedId,"BED",$P(AdmBedId,"||",2))),"^",1)
    else  Set PAAdmBed="" 
    Q:(BedId'="")&&(BedId'=PAAdmBed)
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
    set patChiefDocId=$P(^PAADM(PAAdm),"^",9)
    Q:(ChiefDoc'="")&&(ChiefDoc'=patChiefDocId)
    //if patChiefDocId'="" set patChiefDoc=$P($g(^CTPCP(patChiefDocId,1)),"^",2)
    if patChiefDocId'="" set patChiefDoc=##class(CIS.AN.COM.String).GetDescByID("User.CTCareProv","CTPCPDesc",patChiefDocId) //多语言改造翻译后台数据 YL 20221101
    else  set patChiefDoc=""
    set Data=$LB(PatientID,EpisodeID,MedicareNo,mradm,PAPMINO,PAPMIName,PAPMIDOB,PAPMISex,PAAdmDate,PAAdmTime,PAAdmNo,PAAdmDepCodeDR,PAAdmDocCodeDR,PAAdmType,Hospital,PAAdmWard,PAAdmBed,FinancialDischargeFlag,MedicalDischargeFlag,FinalDischargeFlag,PAAdmReason,DischargeDate,RegDoctor,Diagnosis,ArrivedDate,ArrivedTime,LeavedDate,LeavedTime,LocSeqNo,PAAdmPriority,WalkStatus,ConsultRoom,ConsultArea,PAAdmReasonCode,StatusCode,PAPMIAge,PriorityCode,Called,RegDocDr,patChiefDoc)
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
    ....;if AllowFlag'="1" Set QuitFlag=1     //什么意思？ YL 20200417
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
    ..b ;5
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
 If ind="" {                // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {                // fetch row
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

ClassMethod GetRegNobyEpisodeID(EpisodeID As %String) As %String
{
	set instance=..GetInstance(EpisodeID)
	set result=""
	
	if $IsObject(instance) set result=instance.Patient.RegNo
	else  set result=..GetRegNobyEpisodeIDOld(EpisodeID)
	
	quit result
}

ClassMethod GetRegNobyEpisodeIDOld(EpisodeID) As %String
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

/// w ##class(CIS.AN.BL.Admission).GetRegNoByName("鱼")
ClassMethod GetRegNoByName(patName)
{
    q:$g(patName)="" ""
    s papmiId="",regNo="",regNoList=""
    for
    {
	    s papmiId=$o(^PAPER(papmiId))
        q:(papmiId="")
        s patname=$p($g(^PAPER(papmiId,"ALL")),"^",1)
        continue:(patname'="")&(patname'[patName)
        s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	    i regNoList="" s regNoList=regNo
	    e  s regNoList=regNoList_","_regNo
    }
    q regNoList
}

ClassMethod GetEpisodeListByMedcareNo(medcareNo As %String) As %String
{
	set PatientID=##class(web.DHCWMRService).IGetPatientIDByMrNo(medcareNo)
	kill EpisodeList
	set result=..GetEpisodeListByPatientID(PatientID,.EpisodeList)
	quit result
}

ClassMethod GetEpisodeListByRegNo(regNo As %String) As %String
{
	q:$g(regNo)="" ""
	set PatientID="",result="",splitChar=","
	&sql(select %ID into :PatientID from SQLUser.PA_PatMas where PAPMI_IPNo=:regNo)
	kill EpisodeList
	set IPResult=..GetEpisodeListByPatientID(PatientID,.EpisodeList)
	&sql(select %ID into :PatientID from SQLUser.PA_PatMas where PAPMI_OPNo=:regNo)
	set OPResult=..GetEpisodeListByPatientID(PatientID,.EpisodeList)
	set:(IPResult'="") result=IPResult
	set:(result'="")&(OPResult) result=result_","_OPResult
	quit result
}

ClassMethod GetEpisodeListByPatientID(PatientID As %String, ByRef EpisodeList As %String) As %String
{
	set result=""
	if (##class(User.PAPatMas).%ExistsId(PatientID))
	{
		set admType="",splitChar=","
		for
		{
			set admType=$o(^PAPERdr(PatientID,"ADM",admType))
			quit:(admType="")
			set EpisodeID=0
			for
			{
				set EpisodeID=$o(^PAPERdr(PatientID,"ADM",admType,EpisodeID))
				quit:(EpisodeID="")
				set:(result'="") result=result_splitChar
				continue:($data(EpisodeList(EpisodeID)))
				set result=result_EpisodeID	
				set EpisodeList(EpisodeID)=""
			}	
		}
	}
	quit result
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
    q:userId="" "用户有误!"
    s ctpcpId=$p($g(^SSU("SSUSR",userId)),"^",14)
    i ctpcpId="" d //20140806 其他医护人员
        .s retstr=$$ctpcpIdNo               
    e  d
        .s retstr=$$ctpcpIdOk(ctpcpId)
    q retstr
ctpcpIdNo() 
        s retStr=""
        s clcpRowId=""  //添加其他医护人员  
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
            .b
            .s ctcptInternalType=ifDocDes,userName=desc,loadName=alias,ctpcpId=alias,ctpcpDesc=desc
            .s retStr=ctcptInternalType_"^"_userName_"^"_loadName_"^"_ctpcpId_"^"_ctpcpDesc
        
        q retStr
ctpcpIdOk(ctpcpId)
    b   ;2
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

/// Creator：        chenchangqing
/// CreatDate：      2018-06-27
/// Description：    验证用户工号和密码
/// Table：          
/// Input：          account:用户工号，pwd:用户密码
/// Output：       
/// Return：         验证正确返回"S^UserID"，失败返回"E^失败原因"
/// w ##class(CIS.AN.BL.Admission).ValidateUser("HS01",1)
ClassMethod ValidateUserold(account As %String, pwd As %String, accountSign = "N") As %String
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
            set canAccountSign=##class(CIS.AN.BL.SecureUser).CanAccountSign(account)
            quit:(canAccountSign="N") "E^用户未开通工号和密码签名权限，请联系信息中心。"       
        }   
    }
    
    quit "S^"_validRet
}

/// Creator：      	陈长青
/// CreatDate：    	2017-1-9
/// Description： 	获取手术助手名称
/// Table：        	SQLUser.CT_CareProv
/// Input:			assIdStr:手术助手ID，多个助手以","拼接
/// Return：       	手术助手名称，多个助手以","拼接
/// w ##class(CIS.AN.BL.OperationList).GetAssistantDesc("1")
ClassMethod GetCareProvDesc(assIdStr As %String) As %String [ SqlProc ]
{
	set assIdCount=$length(assIdStr,","),result=""
	for i=1:1:assIdCount
	{
		set assId=$p(assIdStr,",",i)
		set careProvDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTCareProv","CTPCPDesc",assId)
		set:(careProvDesc="") careProvDesc=assId
		if (i>1)&(assId'="")
		{
			set result=result_","	
		}	
		set result=result_careProvDesc
	}	
	
	quit result
}

/// Creator：        yongyang
/// CreatDate：      2020-02-06
/// Description：    判断两个科室是否关联(sourceLoc是否关联targetLoc)
/// Table：          
/// Input：          sourceLoc:源科室，targetLoc:目标科室
/// Output：       
/// Return：         关联返回1，不关联返回0
/// w ##class(CIS.AN.BL.Admission).IsLinkedLoc(298,296)
ClassMethod IsLinkedLoc(sourceLoc, targetLoc) As %String [ SqlProc ]
{
	&sql(SELECT top 1 * FROM SQLUser.CT_LocLinkLocation WHERE LINK_ParRef=:sourceLoc and link_ctloc_dr=:targetLoc)
	if 'SQLCODE quit 1
	
	quit 0
}

/// Creator：        yongyang
/// CreatDate：      2020-02-06
/// Description：    获取医院名称
/// Table：          
/// Input：          hospitalId:医院ID
/// Output：       
/// Return：         医院名称描述
/// w ##class(CIS.AN.BL.Admission).GetHospital(2)
ClassMethod GetHospital(hospitalId) As %String
{
	set result=""
	&sql(select HOSP_Desc into :result from SQLUser.ct_hospital where %id=:hospitalId)
	
	if 'SQLCODE quit result
	quit ""
}

/// Creator：        yangguobin
/// CreatDate：      2020-02-18
/// Description：    验证用户工号和密码
/// Table：          
/// Input：          account:用户工号，pwd:用户密码
/// Output：       
/// Return：         验证正确返回"S^UserID"，失败返回"E^失败原因"
/// w ##class(CIS.AN.BL.Admission).ValidateUser("HS01",1)
ClassMethod ValidateUser(account As %String, pwd As %String, accountSign = "N") As %String
{
    set validRet=..IsValidUser(account,pwd)
    if (##class(CF.AN.SSUser).%ExistsId(validRet)=0)
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
            set canAccountSign=##class(CIS.AN.BL.SecureUser).CanAccountSign(account)
            quit:(canAccountSign="N") "E^用户未开通工号和密码签名权限，请联系信息中心。"       
        }   
    }
    
    quit "S^"_validRet
}

/// by yangguobin 2020-02-18
/// 0^UserNotFindErr         -用户不存在
/// -userid^UnActiveErr      -未激活
/// -userid^DateFromScopeErr -未到用户开启日
/// -userid^DateToScopeErr   -用户有效期已过
/// -userid^PasswordErr      -密码错误
/// w ##class(CIS.AN.BL.Admission).IsValidUser("DOCTOR","1")
ClassMethod IsValidUser(username As %String, password As %String, overrideauthentication As %Library.Boolean = 0) As %String
{
 s encrypt=$$ENCR^SSUTIL2(password)
 s userid=""
 &sql(select RowId into :userid from CF_AN.SSUser where UPPER(Initials)=UPPER(:username))
 q:userid="" 0_"^UserNotFindErr"
 set User=##class(CF.AN.SSUser).%OpenId(userid)
 Set persistUserName = User.Initials
 
 //Q:persistUserName'=username "0^UserNotFindErr"
 //Q:$zcvt(persistUserName,"U")'=$zcvt(username,"U") "0^UserNotFindErr"
 s SSUSRActive=User.Active
 ;s SSUSRActive=$p($g(^SSU("SSUSR",userid)),"^",19)
 Q:SSUSRActive'="Y" -userid_"^UnActiveErr"
 s datefrom=User.ActiveDate
 ;s datefrom=$p($g(^SSU("SSUSR",userid)),"^",96)
 ;s dateto=$p($g(^SSU("SSUSR",userid)),"^",97)
 Q:(datefrom'="")&&(datefrom>+$H) -userid_"^DateFromScopeErr"
 s dateto=User.ExpireDate
 Q:(dateto'="")&&(dateto<+$H) -userid_"^DateToScopeErr"
 s persistPWD=User.Password
 ;s persistPWD=$p($g(^SSU("SSUSR",userid)),"^",3)
 q:persistPWD'=encrypt -userid_"^PasswordErr"
 quit +userid
}

/// Creator：        yangguobin
/// CreatDate：      2020-04-17
/// Description：    获取工号对应的医护人员类型
/// Table：          
/// Input：          account:用户工号
/// Output：       
/// Return：         验证正确返回"S^UserID"，失败返回"E^失败原因"
/// w ##class(CIS.AN.BL.Admission).GetCareProvTypeByAccount("HS01")
ClassMethod GetCareProvTypeByAccount(account As %String) As %String
{
	set CareProvTypeId=""
	&sql(select SSUSR_CareProv_DR into :CareProvTypeId from SQLUser.SS_User where SSUSR_Initials=:account)
	q:CareProvTypeId="" "未找到医护人员类型"
	&sql(SELECT CTPCP_CarPrvTp_DR->CTCPT_InternalType into :InternalType FROM SQLUSER.CT_CareProv WHERE CTPCP_RowId1=:CareProvTypeId)
	q InternalType
}

ClassMethod GetHospIDByDept(deptID As %String) As %String
{
	quit $p($g(^CTLOC(+deptID)),"^",22)
}

/// Creator：        yuanlin
/// CreatDate：      2020-05-22
/// Description：    手术申请界面患者列表查询登记号/病案号/住院号补零
/// Table：          
/// Input：          登记号/病案号/住院号
/// Output：       
/// Return：
/// w ##class(CIS.AN.BL.Admission).GetPatientNo(8)
ClassMethod GetPatientNo(PatientNo As %String) As %String
{
	set length=10-$l(PatientNo)
	for num=1:1:length do
	.set PatientNo="0"_PatientNo
	quit PatientNo
}

/// Creator：        yongyang
/// CreatDate：      2020-05-29
/// Description：    获取医嘱项名称
/// Table：          
/// Input：          医嘱项ID
/// Output：       
/// Return：
/// w ##class(CIS.AN.BL.Admission).GetArcimDesc("2679||1")
ClassMethod GetArcimDesc(arcimId As %String, isAbbreviate As %String = 0) As %String
{
	quit:arcimId="" ""
	set arcimVer=$p(arcimId,"||",2)
	quit:arcimVer=""
	set arcimDesc=$p($g(^ARCIM(+arcimId,arcimVer,1)),"^",2)
	//i arcimDesc["[" s arcimDesc=$p(arcimDesc,"[",1)
	if isAbbreviate
	{
		set arcimAbbrev=$p($g(^ARCIM(+arcimId,arcimVer,1)),"^",3)
		quit:1[arcimAbbrev
		set arcimDesc=arcimAbbrev
	}
	quit arcimDesc
}

/// w ##class(CIS.AN.BL.Admission).GetInstance(patientID)
ClassMethod GetInstance(EpisodeID As %String) As CIS.AN.Admission
{
	set rowId=$O(^CIS.AN.AdmissionI("IAdm"," "_$ZCVT(EpisodeID,"U"),""))
	if ##class(CIS.AN.Admission).%ExistsId(rowId) quit ##class(CIS.AN.Admission).%OpenId(rowId)
	
	quit ""
}

/// w ##class(CIS.AN.BL.Admission).ExistsInstance(patientID)
ClassMethod ExistsInstance(EpisodeID As %String) As %Boolean
{
	set rowId=$O(^CIS.AN.AdmissionI("IAdm"," "_$ZCVT(EpisodeID,"U"),""))
	if ##class(CIS.AN.Admission).%ExistsId(rowId) quit 1
	
	quit 0
}

/// Creator：        元琳
/// CreatDate：      2022-3-17
/// Description：    查询医护人员类型
/// Table：          CT_CarPrvTp
/// Input:           
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.Admission","FindCarPrvTp")
Query FindCarPrvTp() As %SQLQuery(CONTAINID = 1)
{
SELECT distinct CTCPT_RowId As RowId,
       CTCPT_Desc As Description
       from SQLUser.CT_CarPrvTp
}

}
