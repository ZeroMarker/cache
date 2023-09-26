Import SQLUser

/// 取就诊信息
/// by wuqk 2007-03
/// 处理病人就诊信息
Class web.DHCMedWMRBasePaadm Extends (%Library.RegisteredObject, websys.Abstract) [ Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 63;

/// 根据papmi取就诊列表
ClassMethod GetAdmList(papmi, AdmType)
{
	n (papmi,AdmType)
	s s=""
	q:'$d(^PAPERdr(papmi,"ADM",AdmType)) s
	s paadm=""
	f  s paadm=$o(^PAPERdr(papmi,"ADM",AdmType,paadm),-1) q:paadm=""  d
	.s VisitStatus=$p($g(^PAADM(+paadm)),"^",20)
	.q:VisitStatus="C"                           ;Cancel
	.s s=s_..GetAdmInfo(paadm)_$c(1)
	q s
}

/// 取就诊信息
ClassMethod GetAdmInfo(paadm)
{
    n (paadm)
    q:paadm="" ""
    q:'$d(^PAADM(+paadm)) ""
    s LocDesc="",DocDesc="",WardDesc="",RoomDesc="",BedDesc="",DischgDate="",DischgTime=""
    s tmp=$g(^PAADM(+paadm))
    s AdmType=$p(tmp,"^",2),AdmNo=$p(tmp,"^",81)
    s AdmDate=$zd($p(tmp,"^",6),3),AdmTime=$zt($p(tmp,"^",7))
    s papmi=+$p(tmp,"^",1),CTLoc=+$p(tmp,"^",4),Doc=+$p(tmp,"^",9)
    s Ward=+$p(tmp,"^",70),Room=+$p(tmp,"^",69),Bed=$p(tmp,"^",73)
    ;s:$p(tmp,"^",17)'="" DischgDate=$zd($p(tmp,"^",17),3),DischgTime=$zt($p(tmp,"^",18))
    //Modify by liuxuefeng 2009-10-25 统一出院日期使用本类中GetDisAdmDate方法获取
    ;s DischgDate=+$p(##Class(web.DHCMedBase01).GetDisDateTime(+paadm),",",1)
    ;s DischgTime=+$p(##Class(web.DHCMedBase01).GetDisDateTime(+paadm),",",2)
    ;s:DischgDate=0 DischgDate=""
    ;s:DischgTime=0 DischgTime=""
    ;s:DischgDate'="" DischgDate=$zd(DischgDate,3)
    ;s:DischgTime'="" DischgTime=$zt(DischgTime) ;modify by liuxuefeng 2009-03-04
    s DischString=..GetDisAdmDate(paadm) ;返回值格式为"日期 时间"
    s DischgDate=$p(DischString," ",1)
    s DischgTime=$p(DischString," ",2)
    
    s:CTLoc'=0 LocDesc=##class(web.DHCMedBaseCtl).GetCtlocStr(CTLoc)  ;$$GetCtlocStr^DHCMedBase(CTLoc)    
    s:Doc'=0 DocDesc=##class(web.DHCMedBaseCtl).GetUserByCTCP(Doc) ;$$GetUserByCTCP^DHCMedBase(Doc)
    s:Ward'=0 WardDesc=$p($g(^PAWARD(Ward)),"^",2)
    s:Room'=0 RoomDesc=$p($g(^PAROOM(Room)),"^",2)
    s:Bed'="" BedDesc=$p($g(^PAWARD(+Bed,"BED",$p(Bed,"||",2))),"^",1)
    s VisitStatus=$p(tmp,"^",20)
    s:VisitStatus="A" VisitStatus="在院"
    s:VisitStatus="C" VisitStatus="取消"
    s:VisitStatus="D" VisitStatus="出院"
	
    s s=paadm_"^"_AdmType_"^"_AdmNo_"^"_AdmDate_"^"_AdmTime_"^"_papmi_"^"_LocDesc_"^"_DocDesc_"^"_WardDesc_"^"_RoomDesc_"^"_BedDesc_"^"_DischgDate_"^"_DischgTime_"^"_VisitStatus
    q s
}

/// 根据paadm取诊断信息列表
ClassMethod GetMrDiagnose(paadm)
{
        n (paadm)
        s MrAdm=+$p($g(^PAADM(+paadm)),"^",61)
        s s=""
        q:'$d(^MR(+MrAdm,"DIA")) s
        
        ;^MR({MR_Adm.MRADM_RowId},"DIA",{MRDIA_Childsub})
        s Childsub=0
        f  s Childsub=$o(^MR(+MrAdm,"DIA",Childsub)) q:Childsub=""  d
        .s tmp=..BuildDisInfo(+MrAdm,Childsub)
        .s s=s_tmp_$c(1)
        q s
}

/// 格式化诊断信息
ClassMethod BuildDisInfo(MRADM, MRDIAChildsub)
{
     n (MRADM,MRDIAChildsub)
     s sDIA=$g(^MR(+MRADM,"DIA",MRDIAChildsub))
     s ICDDR=$p(sDIA,"^",1)
     s ICDDoctorDR=$p(sDIA,"^",4)
     s ICDDate=$zd(+$p(sDIA,"^",7),3)
     s ICDTime=$zt(+$p(sDIA,"^",8))
     s ICDType=$g(^MR(+MRADM,"DIA",MRDIAChildsub,"TYP","1"))
     
     s:ICDDR'="" ICDDR=ICDDR_"/"_$p($g(^MRC("ID",ICDDR)),"^",4)_"/"_$p($g(^MRC("ID",ICDDR)),"^",2)
     ;s:ICDDoctorDR'=0 ICDDoctorDR=ICDDoctorDR_"/"_$p($g(^CTPCP(ICDDoctorDR)),"^",1)_"/"_$p($g(^CTPCP(ICDDoctorDR)),"^",2)
     
     ;s:ICDDoctorDR'=0 ICDDoctorDR=$$GetSSUSERByCode^DHCMedBase($p($g(^CTPCP(ICDDoctorDR,1)),"^",1))_"/"_$p($g(^CTPCP(ICDDoctorDR,1)),"^",1)_"/"_$p($g(^CTPCP(ICDDoctorDR,1)),"^",2)
     
     s:ICDDoctorDR'="" ICDDoctorDR=##class(web.DHCMedBaseCtl).GetUserByCTCP(ICDDoctorDR)    ;$$GetUserByCTCP^DHCMedBase(ICDDoctorDR)
     ;GetSSUSERByCode
     s:ICDType'="" ICDType=ICDType_"/"_$p($g(^MRC("DTYP",ICDType)),"^",1)_"/"_$p($g(^MRC("DTYP",ICDType)),"^",2)
     
     s paadm=+$p($g(^MR(+MRADM,"PRO",1)),"^",9)
     s paadmtype=$p($g(^PAADM(paadm)),"^",2)
     s ctloc=$p($g(^PAADM(paadm)),"^",4)
     s LocDesc=ctloc_"/"_$p(^CTLOC(+ctloc),"^",2)
     s s=paadm_$c(2)_paadmtype_$c(2)_LocDesc_$c(2)_MRADM_"||"_MRDIAChildsub_$c(2)_ICDDR_$c(2)_ICDDoctorDR_$c(2)_ICDType_$c(2)_ICDDate_$c(2)_ICDTime
     q s
}

/// 取入院时情况
ClassMethod GetAdmPatCondition(paadm)
{
	n (paadm)
    s adms=$g(^PAADM(+paadm))
    s mradm=$p(adms,"^",61)              ;PAADM_MainMRADM_DR ->MR_Adm
    s mradms=$g(^MR(+mradm,"PRO",1))     ;
    s patcond=$p(mradms,"^",40)          ;MR_Adm.MRADM_PatCond_DR
    s:patcond'="" ConditionDesc=$p($g(^MRC("COND",+patcond)),"^",2)
    s:patcond="" ConditionDesc=""
    q ConditionDesc
}

/// 修改入院时情况(病人入院状态--平稳/病重/病危)
ClassMethod UpdateAdmPatCond(paadm, patcond)
{
	n (paadm,patcond)
    s adms=$g(^PAADM(+paadm))
    s mradm=+$p(adms,"^",61)              ;PAADM_MainMRADM_DR ->MR_Adm
    q:mradm=0 "-100"
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
    zn MEDDATA
	&sql(Update MR_Adm set MRADM_PatCond_DR=:patcond where MRADM_Rowid=:mradm)
	s Ret=SQLCODE
	zn CurrentNS
    q Ret
}

/// add by zf 2008-05-30
/// 只取诊断描述
ClassMethod GetMrDiagnoseDesc(paadm)
{
	n (paadm)
	s ret=""
    s TmpDiagnose=..GetMrDiagnose(+paadm)
    s sDiagnose=""
    f i=1:1:($l(TmpDiagnose,$c(1))-1) d
    .s Temp=$p(TmpDiagnose,$c(1),i)
    .s ICDDR=$p(Temp,$c(2),5)
    .s sDiagnose=sDiagnose_$p(ICDDR,"/",3)_";"
    s ret=sDiagnose
   	q ret
}

/// Creator：    刘学峰
/// CreatDate：  2009-02-11
/// Description：根据EpisodeID查询病人入院状态
/// Table：      MR_Adm
/// Input：      EpisodeID
/// Output：     patCondDr:病人入院状态Rowid,存储在表MR_Adm中MRADM_PatCond_DR字段
/// Debug:		 w ##class(web.DHCMedWMRBasePaadm).GetAdmPatCondID(EpisodeID)
ClassMethod GetAdmPatCondID(EpisodeID)
{
    n (EpisodeID)
	s ret=""
    s adms=$g(^PAADM(+EpisodeID))
    s mradm=+$p(adms,"^",61)              ;PAADM_MainMRADM_DR ->MR_Adm
    q:mradm=0 "-100"
    q:'$d(^MR(mradm)) ret
    s patCondDr=$p($g(^MR(mradm,"PRO",1)),"^",40)
    q:patCondDr="" ret
    q patCondDr
}

/// *************************************
/// 说明：取统计系统的出院日期和时间,以空格分隔
/// 参数：Paadm  就诊号
/// 返回值：ret    "2008-10-16 10:10"
/// w ##Class(web.DHCMedWMRBasePaadm).GetDisAdmDate(Paadm)
/// **************************************
ClassMethod GetDisAdmDate(Paadm)
{
		n (Paadm)
		s HospConfig=##Class(web.DHCMedBase01).GetDefaultHosp()
		s HospCode=$p(HospConfig,"/",4)
		s DisDate="",DisTime=""
	    s tmpPaadm=$g(^PAADM(+Paadm))
	    
	    ;modify by liuxuefeng 2009-07-01 修改默认出院日期、时间为PAADM_DischgDate、PAADM_DischgTime
	    
	    s strDateTime=##Class(web.DHCMedBase01).GetDisDateTime(Paadm) ;获取的strDateTime格式为“日期,时间”
	    s DisDate=$zd($p(strDateTime,",",1),3)
	    s DisTime=$zt($p(strDateTime,",",2),1)
	    ;End
	    
	    i HospCode="BeiJing_DT" d
	    .s DisDateTime=..IGetDisDateTimeFromStatistic(Paadm)
	    .s DisDate=$zd(+$p(DisDateTime,"^",1),3)
	    .s DisTime=$zt(+$p(DisDateTime,"^",2))
	    
	    ;delete by liuxuefeng 2009-07-01 由于上面已修改了默认出院日期，并且与华西医院取值相同，故注释掉此程序段
	    ;i HospCode="ChengDu_HX" d
	    ;.s tmpPaadm=$g(^PAADM(+Paadm))
	    ;.s:$p(tmpPaadm,"^",17)'="" DisDate=$zd(+$p(tmpPaadm,"^",17),3),DisTime=$zt(+$p(tmpPaadm,"^",18),1)
	    
	    //add by liuxuefeng 2009-10-25 潍坊人民医院出院日期取医生医疗结算日期
	    i HospCode="WeiFang_RMYY" d
	    .s DisDate=$zd(+$p(tmpPaadm,"^",59),3) ;PAADM_EstimDischargeDate
	    .s DisTime=$zt(+$p(tmpPaadm,"^",60),1) ;PAADM_EstimDischargeTime
	    
	    //add by liuxuefeng 2010-01-08 沈阳医大一院取统计组日期时间
	    i HospCode="ShenYang_YDYFY" d
	    .s DisDateTime=..IGetDisDateTimeFromStatistic(Paadm)
	    .s DisDate=$zd(+$p(DisDateTime,"^",1),3)
	    .s DisTime=$zt(+$p(DisDateTime,"^",2))
	    
	    i DisDate="1840-12-31" {
		    s DisDate=""
		    s DisTime=""
	    }
	    s ret=$g(DisDate)_" "_$g(DisTime)
	    q ret
}

ClassMethod IGetDisDateTimeFromStatistic(EpisodeID)
{
    n (EpisodeID)
    
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
    zn MEDDATA
    s ret=$$GetDisAdmDate^DHCMRIPday(EpisodeID)
	zn CurrentNS
	
	q ret
}

/// Creator：    刘学峰
/// CreatDate：  2009-06-05
/// Description：根据EpisodeID获取病人住院发票状态
/// Table：      DHC_INVPRTZY
/// Input：      EpisodeID：住院就诊PAADM RowID
/// Return：     -1:未打印发票;"A"--"作废";"S"--"红冲";"I"--"中途结算";"N"---"正常结算"(Abort;Interm;Normal;Strike)
/// Debug:       w ##Class(web.DHCMedWMRBasePaadm).GetFSStatus(EpisodeID)
ClassMethod GetFSStatus(EpisodeID)
{
	n (EpisodeID)
	s ret=-1
	;^DHCINVPRTZY(0,"ADM",{PRT_Adm},{PRT_Rowid})
	s PRTRowid=""
	s PRTRowid=$o(^DHCINVPRTZY(0,"ADM",EpisodeID,PRTRowid),-1)
	q:PRTRowid="" ret
	s PRTString=$g(^DHCINVPRTZY(PRTRowid))
	s PrtStatus=$p(PRTString,"^",8)
	q PrtStatus
}

}
