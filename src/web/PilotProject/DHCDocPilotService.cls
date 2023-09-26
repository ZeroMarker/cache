Import SQLUser

Class web.PilotProject.DHCDocPilotService Extends (DHCDoc.Util.RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// creator:郭荣勇
/// date:2019-05-29
/// desc:接口,根据项目ID和患者Rowid获取药理合同单位ID及描述
/// input:PPRowId 项目ID,PatientID 患者表Rowid
/// output: 合同单位ID^合同单位 或 空
/// w ##class(web.PilotProject.DHCDocPilotService).IGetHCP("",8811189)
ClassMethod IGetHCP(CurInsType As %String = "", PatientID As %String) As %String
{
	n (CurInsType,PatientID)
	Q:(PatientID="")!(CurInsType="") ""
	s InsTypeDesc=$p(^PAC("ADMREA",CurInsType),"^",2)
	Q:InsTypeDesc'["临床试验" ""
	s HCPDR="",HCP=""
	s PPRowId=""
	f  s PPRowId=$o(^DHCDocPPP("PapmiDr",0,PatientID,PPRowId)) q:PPRowId=""  d
	.s PPPRowId = 0
	.f  s PPPRowId=$o(^DHCDocPPP("PapmiDr",0,PatientID,PPRowId,PPPRowId)) q:PPPRowId=""  d
	..s VisitStatus=$p($g(^DHCDocPPP(PPRowId,PPPRowId)),"^",2)
	..Q:VisitStatus'="N"
	..s HCPDR=$p($g(^DHCDocPPP(PPRowId,PPPRowId)),"^",19)
    i HCPDR="" s HCPDR=$p($g(^PAPER(PatientID,"PER",4)),"^",17)
    i HCPDR'="" s HCP=$p($g(^CT("HCP",HCPDR)),"^",2)
    
    Q HCPDR_"^"_HCP
}

/// date:2013-03-04
/// desc:接口,判断就诊是否药理病人就诊
/// input:EpisodeID 就诊表Rowid
/// output: 1 是,其他 不是
/// w ##class(web.PilotProject.DHCDocPilotService).IIsPilotAdm(274719)
ClassMethod IIsPilotAdm(EpisodeID As %String) As %Boolean
{
        n (EpisodeID)
        s myrtn = 0
        s PPRowId = 0
        for {
                s PPRowId=$O(^DHCDocPPPA("AdmDr",EpisodeID,0,PPRowId)) Q:PPRowId=""
                s PPState=$p($g(^DHCDocPP(PPRowId)),"^",16)
                ;continue:PPState'="V"
                s PPPRowId = 0
                for {
                        s PPPRowId=$O(^DHCDocPPPA("AdmDr",EpisodeID,0,PPRowId,PPPRowId)) Q:PPPRowId=""
                        s VisitStatus=$p($g(^DHCDocPPP(PPRowId,PPPRowId)),"^",2)
						continue:VisitStatus'="N"
                        s PPPARowId = 0
                        for {
                                s PPPARowId=$O(^DHCDocPPPA("AdmDr",EpisodeID,0,PPRowId,PPPRowId,PPPARowId)) q:PPPARowId=""
                                s ActiveFlag=$p($g(^DHCDocPPPA(PPRowId,PPPRowId,PPPARowId)),"^",4)
								continue:ActiveFlag'="Y"
                                s myrtn = 1
                                quit
                        }
						Q:myrtn=1
                }
			Q:myrtn=1
        }
        
        Q myrtn_"^"_PPRowId
}

/// creator:Lid
/// date:2014-09-05
/// desc:接口,判断住院就诊是否药理病人就诊
/// input:EpisodeID 就诊表Rowid,AdmType:O门诊（默认），I住院
/// output: 1 是,其他 不是
/// w ##class(web.PilotProject.DHCDocPilotService).IIsPilotInAdmTwo(274719)
ClassMethod IIsPilotInAdmTwo(EpisodeID As %String, AdmType As %String = "O") As %Boolean
{
        n (EpisodeID,AdmType)
        s myrtn = 0
        s PPRowId = 0
        for {
                s PPRowId=$O(^DHCDocPPPA("AdmDr",EpisodeID,0,PPRowId)) Q:PPRowId=""
                s PPState=$p($g(^DHCDocPP(PPRowId)),"^",16)
                ;continue:PPState'="V"
                s PPPRowId = 0
                for {
                        s PPPRowId=$O(^DHCDocPPPA("AdmDr",EpisodeID,0,PPRowId,PPPRowId)) Q:PPPRowId=""
                        s VisitStatus=$p($g(^DHCDocPPP(PPRowId,PPPRowId)),"^",2)
						continue:VisitStatus'="N"
                        s PPPARowId = 0
                        for {
                                s PPPARowId=$O(^DHCDocPPPA("AdmDr",EpisodeID,0,PPRowId,PPPRowId,PPPARowId)) q:PPPARowId=""
                                s ActiveFlag=$p($g(^DHCDocPPPA(PPRowId,PPPRowId,PPPARowId)),"^",4)
                                s AllFreeFlag=$p($g(^DHCDocPPPA(PPRowId,PPPRowId,PPPARowId)),"^",10)
								continue:(AllFreeFlag'="Y")&(ActiveFlag'="Y")
								if (((AdmType="O")&(ActiveFlag="Y"))!((AdmType="I")&(AllFreeFlag="Y"))){
									s myrtn = 1	
								}
                                quit
                        }
						Q:myrtn=1
                }
			Q:myrtn=1
        }
        
        Q myrtn_"^"_PPRowId
}

/// 公共接口部分
/// creator:guorongyong
/// date:2010-05-22
/// desc:根据病人PA_PatMas的RowId得到此病人在药理项目的就诊ID
/// Input:PAPMIID:病人的PA_PatMas的RowId
/// Output：PA_Adm表的RowId
ClassMethod getProAdmByPAPMIID(PAPMIID As %String) As %String
{
        Q ##class(web.PilotProject.DHCDocPilotProCommon).getProAdmByPAPMIID(PAPMIID)
}

/// 公共接口部分
/// creator:guorongyong
/// date:2013-11-11
/// desc:根据项目RowId跟用户RowId得到账号
/// Input:PPRowId:项目RowId,UserId 用户RowId
/// Output：
ClassMethod GetAccount(PPRowId As %String, UserId As %String) As %String
{
        Q ##class(web.PilotProject.DHCDocPilotProCommon).GetAccount(PPRowId,UserId)
}

/// Description:: 查询患者是否正在住院,在出院则返回就诊RowId
/// Table:        PA_Adm
/// Input:        PatientID:病人ID
/// Output:         
/// Return:      0:不在院  非0：就诊ID
/// Others:        
ClassMethod CheckPatInIPAdm(PatientID As %String) As %String
{
	n (PatientID)
	s PaadmRowId=""
	s InFlag=0
	f  s PaadmRowId=$O(^PAPERdr(PatientID,"ADM","I",PaadmRowId)) q:(PaadmRowId="")||(InFlag=1)  d
	.s PatVistiStatus=$p($g(^PAADM(PaadmRowId)),"^",20)
	.q:PatVistiStatus'="A" // 不是在院病人则退出
	.s InFlag=PaadmRowId
	Q InFlag
}

/// 入院登记借口
/// creater:zzy
/// date：2014-03-05
/// desc:如果病人未退出实验,住院后试验的信息带入到住院的系统中
/// Input:  
/// OutPut:
/// w ##class(web.PilotProject.DHCDocPilotService).TransPilotPatToInPatient(1607,716)
ClassMethod TransPilotPatToInPatient(UserID As %String, UserLoc As %String, PPRowId As %String = "") As %String
{
    n (UserID,UserLoc,PPRowId)
    s ^zzy("TransPilotPatToInPatient")=UserID_"^"_UserLoc_"^"_PPRowId
    s SuperDepRowId=##Class(web.PilotProject.DHCDocPPGroupSeting).GetConfigNode("SuperDepRowId")
    if SuperDepRowId=UserLoc {
            ;s UserProStr=##class(web.PilotProject.DHCDocPilotProPat).GetAllProStr()
            ;超级科室无需处理
            Q
    }else{
            s UserProStr=##class(web.PilotProject.DHCDocPilotProPat).GetUserProStr(UserID)
    }
    b
    ;对于此用户有权限的科研项目,如果不存在门诊和住院都有效的科研就诊记录,则需要按如下规则判断
    ;1.加入科研日期后的就诊,就诊科室的医护人员中是否有包含此用户的,有则取此就诊置为科研有效,有有效的门诊或者住院记录按此规则
    for i=1:1:$l(UserProStr,"^") {
        s PPRowId=$p(UserProStr,"^",i)
        if PPRowId="" continue
        Set CreateProLoc=$p($g(^DHCDocPP(PPRowId)),"^",6)
        Set ProStartUserDr=$p($g(^DHCDocPP(PPRowId)),"^",10)
        Set ProStartDate=$p($g(^DHCDocPP(PPRowId)),"^",11)
        Set ProEndDate=$p($g(^DHCDocPP(PPRowId)),"^",13)
        Set ProState=$p($g(^DHCDocPP(PPRowId)),"^",16)
        ;项目截止则退出
        if ((ProStartDate>=..%SysDate())&&(ProStartDate'=""))||((ProEndDate<=..%SysDate())&&(ProEndDate'="")) continue
        s PPPRowId = 0
        for {
            s PPPRowId=$O(^DHCDocPPP(PPRowId,PPPRowId))
            Q:PPPRowId=""
            s VisitState=$p(^DHCDocPPP(PPRowId,PPPRowId),"^",2)
            if (VisitState'="N") continue 
            s AddProPatUser=$P($g(^DHCDocPPP(PPRowId,PPPRowId)),"^",5)
            s AddProPatLoc=$P($g(^DHCDocPPP(PPRowId,PPPRowId)),"^",4)
            s PPPatRowId=PPRowId_"||"_PPPRowId
            s CreateDate=$p(^DHCDocPPP(PPRowId,PPPRowId),"^",6)
            s PatientID=$p(^DHCDocPPP(PPRowId,PPPRowId),"^",1)
            s AgreementDate=$p(^DHCDocPPP(PPRowId,PPPRowId),"^",12)
            i AgreementDate'="" s AgreementDate=$zd(AgreementDate,4)
            s ExitDate=$p(^DHCDocPPP(PPRowId,PPPRowId),"^",13)
            s HealthCareProviderDr=$p($g(^PAPER(PatientID,"PER",4)),"^",17)
            s PPPCreateDepartmentDr=$p(^DHCDocPPP(PPRowId,PPPRowId),"^",4)
            s PPPCreateUserDr=$p(^DHCDocPPP(PPRowId,PPPRowId),"^",5)
            s PPPPatientLimit=$p(^DHCDocPPP(PPRowId,PPPRowId),"^",9)
            s PPPReMark=$p(^DHCDocPPP(PPRowId,PPPRowId),"^",10)
            s ScreenNo=$p(^DHCDocPPP(PPRowId,PPPRowId),"^",17)
            s PPPARowId=0
            for {
                s PPPARowId=$O(^DHCDocPPPA(PPRowId,PPPRowId,PPPARowId)) Q:PPPARowId=""
                s PPPAAdmDr=$p(^DHCDocPPPA(PPRowId,PPPRowId,PPPARowId),"^",1)
                continue:PPPAAdmDr=""
                s PAAdmType=$p($g(^PAADM(PPPAAdmDr)),"^",2)
                i PAAdmType'="I" s PAAdmType="O"
                s ActiveFlag=$p(^DHCDocPPPA(PPRowId,PPPRowId,PPPARowId),"^",4)
				if ActiveFlag'="Y" continue
				s ActiveProAdmAry(PatientID,PAAdmType,PPRowId_"||"_PPPRowId_"||"_PPPARowId)=PPPAAdmDr
            }
            ;m ^tmpgry("ProAdmAry")=ActiveProAdmAry
            ;所有记账标识找最后一条记录复制
            s LastPPPARowId=$O(^DHCDocPPPA(PPRowId,PPPRowId,""),-1)
            s AllFreeFlag="N"
            i LastPPPARowId'="" s AllFreeFlag=$p(^DHCDocPPPA(PPRowId,PPPRowId,LastPPPARowId),"^",10)
            
            ;存在有效住院记录,则判断是否有有效的住院药理就诊记录,不存在则插入;判断是否有有效门诊记录,没有则按上述的1.说明插入
            ;不存在有效住院记录,则判断是否有住院未结束记录,有则结束;判断是否有有效门诊记录,没有则按上述的1.说明插入
			s ActiveCanProAdmId=""
			i '$d(ActiveProAdmAry(PatientID,"I")) {
    			s ActiveCanProAdmId=$$GetActiveCanProAdm(PatientID,UserID,CreateDate,"I")
			}
			;得到加入科研日期后的就诊,就诊科室的医护人员中包含此用户的有效门诊就诊
			i '$d(ActiveProAdmAry(PatientID,"O")) {
				s ActiveCanProAdmId=$$GetActiveCanProAdm(PatientID,UserID,CreateDate,"O^E")
			}
			i ActiveCanProAdmId'="" {
				s Para="<DHCDocPilotProPat><AgreementDate>"_AgreementDate_"</AgreementDate><EpisodeID>"_ActiveCanProAdmId_"</EpisodeID>"
                s Para=Para_"<ExitDate>"_ExitDate_"</ExitDate><HealthCareProviderDr>"_HealthCareProviderDr_"</HealthCareProviderDr><PPPCreateDepartmentDr>"_PPPCreateDepartmentDr_"</PPPCreateDepartmentDr><PPPCreateUserDr>"_PPPCreateUserDr_"</PPPCreateUserDr><PPPPatientLimit>"_PPPPatientLimit_"</PPPPatientLimit>"
                s Para=Para_"<PPPReMark>"_PPPReMark_"</PPPReMark><PPPVisitStatus>N</PPPVisitStatus><PatientID>"_PatientID_"</PatientID><ScreenNo>"_ScreenNo_"</ScreenNo></DHCDocPilotProPat>"
                d ##class(web.PilotProject.DHCDocPilotProPat).InsertProPatAdm(PPRowId_"||"_PPPRowId,ActiveCanProAdmId,"",AllFreeFlag)
			}
				
			;对于出院和退号的自动取消
			s AdmTypeLoop=""
			for {
				s AdmTypeLoop=$O(ActiveProAdmAry(PatientID,AdmTypeLoop)) Q:AdmTypeLoop=""
				s PPPAIDLoop=0
				for {
    				s PPPAIDLoop=$O(ActiveProAdmAry(PatientID,AdmTypeLoop,PPPAIDLoop)) Q:PPPAIDLoop=""
    				s Adm=$p($g(ActiveProAdmAry(PatientID,AdmTypeLoop,PPPAIDLoop)),"^",1)
    				continue:Adm=""
    				s Status=$P($G(^PAADM(Adm)),"^",20)
					if (Status="C")||(Status="D") {
						&sql(update SQLUser.DHC_DocPilotProPatAdm set PPPA_ActiveFlag='N' where PPPA_RowId=:PPPAIDLoop)
					}
				}
			}
				
        }
    }
	
	Q
AdmDepIsIncludeDoc(AdmDepId,UserID)
	;0 不包含,1 包含
	s ret=0
	Q:AdmDepId="" ret
	s DocId=$p(^SSU("SSUSR",UserID),"^",14)
	i $d(^RB("RES",0,"CTPCP",DocId,AdmDepId)) s ret=1
	
	Q ret
GetActiveCanProAdm(PatientID,UserID,CreateDate,AdmTypeStr)
	s FindOPAdm=""
	for I=1:1:$l(AdmTypeStr,"^") {
		s IType=$p(AdmTypeStr,"^",I)
		continue:IType=""
		s Adm=0
		for {
			s Adm=$O(^PAPERdr(PatientID,"ADM",IType,Adm)) Q:(Adm="")||(FindOPAdm'="")
			s Status=$P($G(^PAADM(Adm)),"^",20)
			continue:Status'="A"
			s AdmDate=$p(^PAADM(Adm),"^",6)
			continue:AdmDate<CreateDate
			s DepCodeDR=$p(^PAADM(Adm),"^",4)
			continue:$$AdmDepIsIncludeDoc(DepCodeDR,UserID)=0
			s FindOPAdm=Adm
		}
	}
	
	Q FindOPAdm
}

/// Creater: gry
/// date：2017-12-14
/// desc:得到就诊是否全部费用走科研,走住院证表
/// Input:  AdmID：就诊ID
/// OutPut: Y 是,N 不是
/// w ##class(web.PilotProject.DHCDocPilotService).PilotProIPAllFreeFlag(7131018)
ClassMethod PilotProIPAllFreeFlag(ActiveCanProAdmId)
{
	n (ActiveCanProAdmId)
	s AllFreeFlag="N"
	q:ActiveCanProAdmId="" AllFreeFlag
	s IPBPRowId=0
	for {
		s IPBPRowId=$O(^DHCDocIPBK(0,"EpisodeIDTo",ActiveCanProAdmId,IPBPRowId)) Q:IPBPRowId=""
		s IsActive=$P($g(^DHCDocIPBK(IPBPRowId)),"^",9)
		;continue:IsActive'="Y"
		s AllFreeFlag=$P($g(^DHCDocIPBK(IPBPRowId)),"^",18)
	}
	
	Q AllFreeFlag
}

/// Creater: zzy
/// date：2014-04-28
/// desc:根据就诊得到科研信息
/// Input:  AdmID：就诊ID
/// OutPut:PPStartUser_"^"_Acc_"^"_ContactUser_"^"_ContactTel  PI_"^"_账户_"^"_联系人_"^"_联系人电话
/// w ##class(web.PilotProject.DHCDocPilotService).GetPilotInfoByAdm(7131018)
ClassMethod GetPilotInfoByAdm(AdmID As %String) As %String
{
	n (AdmID)
	s Acc="",PPRowId="",ContactUser="",ContactTel="",ContactUser=""
	q:AdmID="" ""
	s RowId=""
	s CreatUser=""
	S PPStartUser=""
	f  s PPRowId=$o(^DHCDocPPPA("AdmDr",AdmID,0,PPRowId)) q:PPRowId=""  d
	.s PPPRowId=""
	.f  s PPPRowId=$o(^DHCDocPPPA("AdmDr",AdmID,0,PPRowId,PPPRowId)) q:PPPRowId=""  d
	..s PPPARowId=""
	..f  s PPPARowId=$o(^DHCDocPPPA("AdmDr",AdmID,0,PPRowId,PPPRowId,PPPARowId)) q:PPPARowId=""  d
	...s Active=$p($g(^DHCDocPPPA(PPRowId,PPPRowId,PPPARowId)),"^",4)
	...;q:Active'="Y"  //判断是否在组
	...s CreatUser=$p(^DHCDocPPP(PPRowId,PPPRowId),"^",5) 
	...s Acc=##class(web.PilotProject.DHCDocPilotProCommon).GetAccount(PPRowId,CreatUser)
	...s PPStartUser=##Class(web.PilotProject.DHCDocPilotProCommon).GetPIByUserID(PPRowId,CreatUser)
	...s RowId=PPRowId
	i RowId'="" d
	.s PPCRowId=""
	.f  s PPCRowId=$O(^DHCDocPPC(RowId,PPCRowId)) Q:(PPCRowId="")  d
    ..s JoinUserDr=$p(^DHCDocPPC(RowId,PPCRowId),"^",1)
	..s PPCUserDr=$p(^DHCDocPPC(RowId,PPCRowId),"^",12)
	..s ContactFlag=$p(^DHCDocPPC(RowId,PPCRowId),"^",10)
	..i ContactFlag="Y" d
	...s ContactTel=$p(^DHCDocPPC(RowId,PPCRowId),"^",11)
	...i JoinUserDr'="" s ContactUser=$p($g(^SSU("SSUSR",JoinUserDr)),"^",2)
	q PPStartUser_"^"_Acc_"^"_ContactUser_"^"_ContactTel
}

ClassMethod GetPilotInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPilotInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPilotInfoExecute(ByRef qHandle As %Binary, EpisodeID As %String) As %Status
{
 Set repid=$I(^CacheTemp)
 If $g(ind)="" Set ind=1
	 s Ret=##class(web.PilotProject.DHCDocPilotService).GetPilotInfoByAdm(EpisodeID)
	 s PPStartUser=$p(Ret,"^",1)
	 s Acc=$p(Ret,"^",2)
	 s ContactUser=$p(Ret,"^",3)
	 s ContactTel=$p(Ret,"^",4)
	 do OutputRow
     Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(PPStartUser,Acc,ContactUser,ContactTel)
	 Set ^CacheTemp(repid,ind)=Data
	 Set ind=ind+1
	Quit
}

ClassMethod GetPilotInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPilotInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {	
	    // if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else      {
		// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

// d ##class(%ResultSet).RunQuery("web.PilotProject.DHCDocPilotService","GetPilotInfo",4054056)

Query GetPilotInfo(EpisodeID As %String) As %Library.Query(CONTAINID = "", ROWSPEC = "PPStartUser:%String,Acc:%String,ContactUser:%String,ContactTel:%String")
{
}

/// 得到病人访问位置,用于判断是门诊科室还是住院科室
/// "O" 门诊科室,"E" 急诊科室, "I" 住院科室
ClassMethod GetAdmTypeLoc(DepId As %String) As %String
{
	Q:DepId="" ""
	s AdmLocRowId=$O(^PAC("ADMLOC",0,"AdmType","O",DepId,0))
	Q:AdmLocRowId'="" "O"
	s AdmLocRowId=$O(^PAC("ADMLOC",0,"AdmType","E",DepId,0))
	Q:AdmLocRowId'="" "E"
	s AdmLocRowId=$O(^PAC("ADMLOC",0,"AdmType","I",DepId,0))
	Q:AdmLocRowId'="" "I"
	Q ""
}

}
