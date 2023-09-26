Import SQLUser

/// 取就诊信息
/// by wuqk 2007-03
/// 处理病人就诊信息
Class web.DHCWMRBasePaadm Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 89;

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

/// Creator:wangCS
/// CreateDate:2011-09-28
/// Description:根据paadm取转科记录
/// Debug:w ##Class(web.DHCWMRBasePaadm).GetAdmTranLoc(77152)
ClassMethod GetAdmTranLoc(paadm)
{
	n (paadm)
	s ret=""
	;^PAADMi("TransDateTime1",{PA_Adm.PAADM_RowID},{TRANS_StartDate},{TRANS_StartTime},{TRANS_Childsub}) 
    set lastDate=$p($h,",",1)
    set lastTime=86399   ;23:59:59
    set ret=$$GetAdmLoc(lastDate,lastTime,-1)
	q ret
GetAdmLoc(startDate,startTime,direction) 
    set locRowId=0
    set tranLoc=""
    set startDate=$o(^PAADMi("TransDateTime1",paadm,startDate),direction)
    set transChildSub=0
    set count=0
    while (startDate'=""){
       set startTime=$o(^PAADMi("TransDateTime1",paadm,startDate,startTime),direction)
       while (startTime'=""){
	   	   set transChildSub=$o(^PAADMi("TransDateTime1",paadm,startDate,startTime,transChildSub))
	   	   while(transChildSub'=""){
		   	    ;^PAADM({PA_Adm.PAADM_RowID},"TRANS",{TRANS_Childsub}
		   		set locRowId=$p($g(^PAADM(paadm,"TRANS",transChildSub)),"^",6)
		   		if (locRowId'=""){
			   		;^CTLOC({CTLOC_RowID}) 
		            set locCode=$p($g(^CTLOC(locRowId)),"^",1)
		            if (tranLoc'[locCode){
		              set:tranLoc'="" tranLoc=tranLoc_"^"_locCode
		              set:tranLoc="" tranLoc=locCode
		            }
			    }
		   		;q:locRowId=""
		   		set transChildSub=$o(^PAADMi("TransDateTime1",paadm,startDate,startTime,transChildSub))
		   }
		   set startTime=$o(^PAADMi("TransDateTime1",paadm,startDate,startTime),direction)
	   }
	   set count=count+1
	   ;q:count=2
	   ;q:startDate=""
	   set startDate=$o(^PAADMi("TransDateTime1",paadm,startDate),direction)
	}
    quit tranLoc
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
    ;s DischgDate=+$p(##Class(web.DHCWMRMedBase01).GetDisDateTime(+paadm),",",1)
    ;s DischgTime=+$p(##Class(web.DHCWMRMedBase01).GetDisDateTime(+paadm),",",2)
    ;s:DischgDate=0 DischgDate=""
    ;s:DischgTime=0 DischgTime=""
    ;s:DischgDate'="" DischgDate=$zd(DischgDate,3)
    ;s:DischgTime'="" DischgTime=$zt(DischgTime) ;modify by liuxuefeng 2009-03-04
    s DischString=..GetDisAdmDate(paadm) ;返回值格式为"日期 时间"
    s DischgDate=$p(DischString," ",1)
    s DischgTime=$p(DischString," ",2)
    s:DischgDate="1840-12-31" DischgDate="" ;add by zf 20100421
    s:DischgDate="1840-12-31" DischgTime="" ;add by zf 20100421
    
    s:CTLoc'=0 LocDesc=##class(web.DHCWMRMedBaseCtl).GetCtlocStr(CTLoc)  ;$$GetCtlocStr^DHCWMRMedBase(CTLoc)    
    s:Doc'=0 DocDesc=##class(web.DHCWMRMedBaseCtl).GetUserByCTCP(Doc) ;$$GetUserByCTCP^DHCWMRMedBase(Doc)
    s:Ward'=0 WardDesc=$p($g(^PAWARD(Ward)),"^",2)
    s:Room'=0 RoomDesc=$p($g(^PAROOM(Room)),"^",2)
    s:Bed'="" BedDesc=$p($g(^PAWARD(+Bed,"BED",$p(Bed,"||",2))),"^",1)
    s VisitStatus=$p(tmp,"^",20)
    s IsDeath=$p($g(^PAPER(+papmi,"ALL")),"^",12)
    s:VisitStatus="A" VisitStatus="在院"
    s:VisitStatus="C" VisitStatus="取消"
    s:VisitStatus="D" VisitStatus="出院"
	s:IsDeath="Y" VisitStatus="死亡"
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
     
     ;s:ICDDoctorDR'=0 ICDDoctorDR=$$GetSSUSERByCode^DHCWMRMedBase($p($g(^CTPCP(ICDDoctorDR,1)),"^",1))_"/"_$p($g(^CTPCP(ICDDoctorDR,1)),"^",1)_"/"_$p($g(^CTPCP(ICDDoctorDR,1)),"^",2)
     
     s:ICDDoctorDR'="" ICDDoctorDR=##class(web.DHCWMRMedBaseCtl).GetUserByCTCP(ICDDoctorDR)    ;$$GetUserByCTCP^DHCWMRMedBase(ICDDoctorDR)
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
    &sql(Update MR_Adm set MRADM_PatCond_DR=:patcond where MRADM_Rowid=:mradm)
	s ret=SQLCODE
    q ret
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
/// Debug:		 w ##class(web.DHCWMRBasePaadm).GetAdmPatCondID(EpisodeID)
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
/// w ##Class(web.DHCWMRBasePaadm).GetDisAdmDate(Paadm)
/// **************************************
ClassMethod GetDisAdmDate(Paadm)
{
		n (Paadm)
		s HospConfig=##Class(web.DHCWMRMedBase01).GetDefaultHosp()
		s HospCode=$p(HospConfig,"/",4)
		s DisDate="",DisTime=""
	    s tmpPaadm=$g(^PAADM(+Paadm))
	    s PatientID=$p(tmpPaadm,"^",1)			//add by liuxuefeng 2010-04-08
	    
	    ;modify by liuxuefeng 2009-07-01 修改默认出院日期、时间为PAADM_DischgDate、PAADM_DischgTime
	    ;s strDateTime=##Class(web.DHCWMRMedBase01).GetDisDateTime(Paadm) ;获取的strDateTime格式为“日期,时间”
	    ;s DisDate=$zd($p(strDateTime,",",1),3)
	    ;s DisTime=$zt($p(strDateTime,",",2),1)
	    s DisDate=$p($g(^PAADM(+Paadm)),"^",17) ;PAADM_DischgDate
	    s DisTime=$p($g(^PAADM(+Paadm)),"^",18) ;PAADM_DischgTime

	    
	    i HospCode="BeiJing_DT" d
		.Set Config=##Class(websys.Configuration).%OpenId(1)
	    .Set MEDDATA=Config.DataNamespace
	    .Set LABDATA=Config.LabDataNamespace
	    .Set CurrentNS=$ZNSPACE
	    .d Config.%Close()
		.zn MEDDATA
	    .s tmpDateTime=$$GetDisAdmDate^DHCMRIPday(Paadm)
	    .zn CurrentNS
	    .s:$p(tmpDateTime,"^",1)'="" DisDate=+$p(tmpDateTime,"^",1),DisTime=+$p(tmpDateTime,"^",2)
	    
	    //add by liuxuefeng 2009-10-25 潍坊人民医院		出院日期取医生医疗结算日期
	    //add by liuxuefeng 2010-04-21 妇产医院			出院日期取医生医疗结算日期
	    i ((HospCode="WeiFang_RMYY")||(HospCode="BeiJing_FC")) d
	    .s DisDate=+$p(tmpPaadm,"^",59) ;PAADM_EstimDischargeDate
	    .s DisTime=+$p(tmpPaadm,"^",60) ;PAADM_EstimDischargeTime
	    
	    //add by liuxuefeng 2010-01-08 沈阳医大一院取统计组日期时间,如果病人死亡，取死亡日期时间
	    i HospCode="ShenYang_YDYFY" d
	    .s DisDateTime=##Class(web.DHCWMRVolDisAdmQry).IGetDisDateTimeFromStatistic(Paadm)
	    .s DisDate=+$p(DisDateTime,"^",1)
	    .s DisTime=+$p(DisDateTime,"^",2)
	    .;如果病人死亡，取病人死亡日期时间 add by liuxuefeng 2010-04-08
	    .s Deceased=$p($g(^PAPER(PatientID,"ALL")),"^",12) ;PAPER_Deceased
	    .;^PAPERdr({PAADM_PAPMI_DR},"ADM",{PAADM_Type},{PAADM_RowID})
	    .s LastIPAdm=$o(^PAPERdr(PatientID,"ADM","I",""),-1) //判断此次就诊是否是最后一次就诊
	    .i (Deceased="Y")&&(LastIPAdm=Paadm) d
	    ..s DisDate=+$p($g(^PAPER(PatientID,"ALL")),"^",13)  ;PAPER_Deceased_Date
	    ..s DisTime=+$p($g(^PAPER(PatientID,"ALL")),"^",8)  ;PAPER_DeceasedTime

	    
	    s:+DisDate'=0 DisDate=$zd(+DisDate,3)
		s:+DisTime'=0 DisTime=$zt(+DisTime,1)
	    
	    s ret=$g(DisDate)_" "_$g(DisTime)
	    q ret
}

/// Creator：    刘学峰
/// CreatDate：  2009-06-05
/// Description：根据EpisodeID获取病人住院发票状态
/// Table：      DHC_INVPRTZY
/// Input：      EpisodeID：住院就诊PAADM RowID
/// Return：     -1:未打印发票;"A"--"作废";"S"--"红冲";"I"--"中途结算";"N"---"正常结算"(Abort;Interm;Normal;Strike)
/// Debug:       w ##Class(web.DHCWMRBasePaadm).GetFSStatus(EpisodeID)
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

/// Creator：    刘学峰
/// CreatDate：  2010-04-22
/// Description：获取出院查询使用的Pa_Adm表索引
/// Table：      DHC_INVPRTZY
/// Input：      无
/// Return：     "DischDate"或"EstDisch"
/// Debug:       w ##Class(web.DHCWMRBasePaadm).GetDisDateIndex()
ClassMethod GetDisDateIndex()
{
	;^PAADMi("DischDate",{PAADM_DischgDate},{PAADM_RowID})
	;^PAADMi("EstDisch",{PAADM_EstimDischargeDate},{PAADM_RowID})
	s DisIndex="DischDate"		;默认出院索引使用最终结算日期索引
	s HospCode=##class(web.DHCWMRMedBase01).GetDefaultHospCode() //add by liuxuefeng 2009-12-07
	s:HospCode="BeiJing_FC" DisIndex="EstDisch"
	q DisIndex
}

}
